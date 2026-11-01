JobConfigLocales["sky_firejob:it"] = {
    Nui = {
        workshopConfig = {
            configs = {
                sky_firejob = {
                    subtitle = "Configura i lavori dei vigili del fuoco, l'accensione con accendino, gli incendi dei veicoli, il soccorso tecnico, le operazioni di salvataggio NPC, le caserme e le impostazioni del creatore di missioni.",
                    title = "Lavori dei vigili del fuoco",
                },
            },
            creatorSections = {
                fireStations = {
                    entryLabel = "Caserma dei vigili del fuoco",
                    entryPluralLabel = "Caserme dei vigili del fuoco",
                    label = "Caserme dei vigili del fuoco",
                },
            },
            dispatchActions = {
                addChannel = "Aggiungi canale radio",
                addKeyword = "Aggiungi parola chiave",
                addPoi = "Aggiungi POI",
                addReporter = "Aggiungi segnalante",
                addStatus = "Aggiungi stato FMS",
                addVehicle = "Aggiungi unità virtuale",
                addVehicleType = "Aggiungi tipo di unità",
                currentLocation = "Usa posizione attuale",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Assegna immediatamente le unità disponibili corrispondenti quando viene creato l'intervento.",
                available = "Le unità con questo stato possono essere suggerite e assegnate a un nuovo intervento.",
                averageResponseSpeedKmh = "Calcola l'orario di arrivo stimato dalla distanza in linea d'aria.",
                callsign = "Nominativo radio univoco mostrato quando i giocatori occupano questa unità virtuale.",
                centerEnabled = "Consente ai membri autorizzati in servizio di presidiare una centrale operativa.",
                channelId = "ID del canale radio per PMA Voice, SaltyChat e YACA. Gli ID numerici come 2500 restano invariati; PMA Voice converte gli ID testuali in un numero stabile.",
                channelLabel = "Nome leggibile del canale mostrato a dispatcher e unità.",
                crewCapacity = "Numero massimo di operatori assegnabili all'unità. Usa 0 per un equipaggio illimitato.",
                defaultChannel = "Definisce il canale di fallback di questa squadra quando non è selezionato alcun canale. Le unità si collegano comunque manualmente. Nessuno usa il predefinito del gruppo.",
                emergencyAppEnabled = "Rende questo lavoro selezionabile come servizio pubblico nell'app Emergenze del telefono.",
                enabled = "Rende questo lavoro disponibile nell'app Dispatch e negli interventi tra più lavori.",
                icon = "Seleziona l'icona mostrata per questa categoria nell'app Dispatch.",
                incidentAssessmentEnabled = "Mostra le domande mediche e di valutazione del pericolo nella ricezione completa dell'emergenza.",
                jobs = "Altri nomi di lavoro che ricevono gli interventi con questa parola chiave.",
                joinLocked = "Impedisce ad altri operatori di unirsi dopo che l'unità è stata occupata.",
                minimumCrew = "Numero minimo di operatori nelle unità selezionate per questo piano di risposta.",
                noUnitFallback = "Senza una centrale o un'unità presidiata invia una notifica Sky a tutti i membri in servizio.",
                poiId = "Identificatore tecnico stabile che i profili delle stazioni possono usare anche dopo la rinomina del POI.",
                radius = "Distanza massima in metri entro cui è udibile l'annuncio della stazione.",
                readyStatusCode = "Stato FMS applicato quando questa risorsa diventa disponibile per l'invio.",
                requirements = "Fabbisogno come coppie TIPO:QUANTITÀ, ad esempio PATROL:2,CRIME:1.",
                resourceType = "Classifica la risorsa operativa per filtri e coordinamento della centrale.",
                respondingStatusCode = "Stato FMS applicato quando questa risorsa parte per un intervento.",
                shortLabel = "Etichetta compatta facoltativa mostrata sui sei tasti di memoria del canale radio.",
                stationId = "Associa questa unità a una stazione configurata nel profilo della centrale operativa.",
                statusCode = "Stato FMS numerico mostrato sulla radio portatile.",
                statusLabel = "Significato di questo stato FMS per dispatcher e unità.",
                unitId = "Identificatore tecnico stabile che conserva l'unità anche se cambia il nominativo radio.",
                vehicleType = "Deve corrispondere a un codice di tipo unità configurato nella sezione precedente.",
                vehicleTypeCode = "Codice breve dell'unità usato nei piani di risposta, ad esempio PATROL, CRIME, EMS o RESCUE.",
                vehicleTypeLabel = "Nome leggibile di questa categoria di unità.",
            },
            dispatchFields = {
                address = "Indirizzo",
                autoAlarm = "Allarme automatico",
                available = "Disponibile per l'invio",
                averageResponseSpeedKmh = "Velocità di risposta stimata (km/h)",
                callsign = "Nominativo radio",
                category = "Categoria",
                centerEnabled = "Abilita centrale operativa",
                channelId = "ID canale",
                code = "Codice",
                crewCapacity = "Capacità equipaggio",
                defaultChannel = "Canale radio predefinito",
                emergencyAppEnabled = "Mostra nell'app Emergenze",
                enabled = "Abilita Dispatch",
                icon = "Icona",
                incidentAssessmentEnabled = "Abilita valutazione dell'emergenza",
                jobs = "Lavori destinatari (separati da virgole)",
                joinLocked = "Blocca ingresso equipaggio",
                keywordCode = "Codice parola chiave",
                label = "Etichetta",
                minimumCrew = "Equipaggio minimo",
                name = "Nome",
                noUnitFallback = "Avvisa il personale in servizio senza unità",
                noneChannel = "Nessuno / predefinito del gruppo",
                note = "Nota",
                phone = "Telefono",
                poiId = "ID POI stabile",
                radius = "Raggio dell'annuncio",
                readyStatusCode = "Stato di disponibilità",
                requirements = "Unità richieste (ad esempio PATROL:2,CRIME:1)",
                resourceType = "Tipo di risorsa",
                respondingStatusCode = "Stato di intervento",
                shortLabel = "Etichetta memoria radio",
                stationId = "ID stazione",
                type = "Tipo",
                unitId = "ID unità stabile",
                vehicleType = "Tipo di unità di risposta",
            },
            dispatchIconOptions = {
                crime = "Unità investigativa",
                emergency = "Unità di emergenza",
                ems = "Unità sanitaria",
                fire = "Unità antincendio",
                heavy = "Unità pesante",
                k9 = "Unità cinofila",
                medical = "Unità medica",
                patrol = "Pattuglia",
                rescue = "Unità di soccorso",
                service = "Unità di servizio",
                supervisor = "Supervisore",
                tactical = "Unità tattica",
            },
            dispatchNavigation = {
                active = "Dispatch attivo",
                description = "Configura ricezione delle emergenze, radio, unità, piani di risposta, luoghi e segnalanti per questo lavoro.",
                inactive = "Dispatch disattivato",
                steps = {
                    accessText = "Abilita Dispatch e gestisci ricezione pubblica e fallback per questa squadra operativa.",
                    accessTitle = "Accesso e ricezione emergenze",
                    fleetText = "Configura canali, stati FMS, tipi di unità e nominativi radio.",
                    fleetTitle = "Radio e flotta",
                    responseText = "Completa parole chiave, requisiti delle unità e POI.",
                    responseTitle = "Piani di risposta",
                },
                summary = {
                    channels = "Canali radio",
                    plans = "Piani di risposta",
                    reporters = "Segnalanti conosciuti",
                    statuses = "FMS disponibili",
                    units = "Unità virtuali",
                },
                title = "Spedizione",
                warnings = {
                    channels = "Non esistono canali radio espliciti; verrà usato il canale predefinito del gruppo.",
                    defaultChannel = "Il canale predefinito selezionato non esiste più.",
                    disabled = "Dispatch è disattivato per questo lavoro.",
                    statuses = "Almeno uno stato FMS deve essere disponibile per poter allarmare le unità.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Definisce i canali radio a cui possono collegarsi unità e centrali operative presidiate.",
                dispatchKeywords = "Definisce parole chiave, quantità di unità richieste, lavori coinvolti e allarme automatico facoltativo.",
                dispatchPois = "Memorizza stazioni e luoghi comuni per i moduli d'intervento e gli annunci locali.",
                dispatchReporters = "Gestisce nomi dei segnalanti, numeri di richiamo e note operative proprie del lavoro.",
                dispatchStatusCodes = "Configura le etichette degli stati FMS e quali stati valgono come disponibili per nuovi interventi.",
                dispatchVehicleTypes = "Definisce le categorie di unità usate dai piani di risposta, ad esempio pattuglia, investigativa, sanitaria o soccorso.",
                dispatchVehicles = "Definisce unità Dispatch virtuali occupabili ovunque, senza richiedere un veicolo generato.",
            },
            extensions = {
                dispatchChannels = "Canali radio",
                dispatchKeywords = "Parole chiave e piani di risposta",
                dispatchPois = "POI Dispatch",
                dispatchReporters = "Segnalanti conosciuti",
                dispatchSettings = {
                    description = "Configura l'accesso della squadra operativa, la ricezione delle emergenze e il canale radio predefinito.",
                    label = "Impostazioni Dispatch",
                },
                dispatchStatusCodes = "Codici di stato FMS",
                dispatchVehicleTypes = "Tipi di unità Dispatch",
                dispatchVehicles = "Flotta Dispatch",
                emptyDescription = "Usa il pulsante qui sopra per creare la prima voce.",
                emptyTitle = "Nessuna configurazione",
                invalidSelection = "Selezione non valida: {value}",
                trainingSettings = {
                    description = "Configura l'accesso alla formazione, l'iscrizione, le approvazioni e la pianificazione del corso per questo lavoro.",
                    label = "Impostazioni di allenamento",
                },
            },
            extinguisherMaintenanceStates = {
                checked = "Controllato",
                damaged = "Danneggiato",
                empty = "Vuoto",
                missing = "Nessun estintore",
            },
            extinguisherMountStates = {
                empty = "Monta vuoto",
                mounted = "Estintore montato",
            },
            features = {
                waterMonitor = {
                    description = "Trattare con fuochi più grandi utilizzando un flusso d'acqua costante con passo regolabile. Richiede una linea di alimentazione per un veicolo antincendio con acqua serbatoio, idrante, o pompa.",
                    label = "Monitor dell'acqua",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Per mostrare questo lavoro nell’app Emergenze, la centrale operativa deve essere abilitata. Abilitala oppure disattiva la visualizzazione nell’app Emergenze nelle impostazioni della centrale.",
                dispatchJobNotCovered = "Nessuna centrale operativa attiva copre il lavoro «{job}». In sky_jobs_base/config/config.lua, aggiungi «{job}» a coveredJobs nel profilo appropriato di Config.Dispatch.centers, poi riavvia sky_jobs_base. Il ripristino delle impostazioni non modifica questa assegnazione.",
                invalidDispatchChannels = "Gli ID dei canali radio devono essere univoci e ogni canale deve avere un'etichetta valida.",
                invalidDispatchDefaultChannel = "Il canale radio predefinito non esiste. Nelle impostazioni della centrale, seleziona un canale esistente oppure «Nessuno».",
                invalidDispatchKeywords = "I piani di risposta devono avere codici univoci e requisiti TIPO:QUANTITÀ validi.",
                invalidDispatchPois = "ID, nomi e coordinate dei POI devono essere validi e univoci.",
                invalidDispatchRadioButtons = "Controlla i pulsanti funzione della radio: usa ogni pulsante supportato una sola volta e seleziona un’azione dal relativo elenco.",
                invalidDispatchRadioFmsKeys = "Controlla i tasti FMS della radio: usa ogni tasto (0-9, * o #) una sola volta e assegna un codice di stato esistente oppure lascialo non assegnato.",
                invalidDispatchReadyStatus = "Nelle impostazioni della centrale, seleziona un codice di disponibilità contrassegnato come disponibile nell’elenco dei codici di stato.",
                invalidDispatchReporters = "I dati dei segnalanti superano il numero di voci o la lunghezza dei campi consentiti.",
                invalidDispatchRespondingStatus = "Nelle impostazioni della centrale, seleziona un codice di partenza per intervento contrassegnato come non disponibile nell’elenco dei codici di stato.",
                invalidDispatchSettings = "Seleziona uno stato di disponibilità esistente e disponibile, uno stato di intervento non disponibile e un canale predefinito valido.",
                invalidDispatchStatusCodes = "I codici FMS devono essere univoci e almeno uno stato deve essere disponibile.",
                invalidDispatchVehicleTypes = "I codici dei tipi di unità devono essere univoci e completi.",
                invalidDispatchVehicles = "ID e nominativi delle unità devono essere univoci e tutti i riferimenti a tipi e stazioni devono esistere.",
            },
            misc = {
                defaultFireTruckLabel = "autopompa",
                fireStationCategoryLabel = "Caserma dei vigili del fuoco",
                fireStationEntryLabel = "Caserma dei vigili del fuoco",
                fireStationPosition = "Posizione caserma dei vigili del fuoco",
                fireStationsTitle = "Caserme dei vigili del fuoco",
                hoseConnectionEditorTitle = "Editor connessione manichetta",
                hydrantConnectionEditorTitle = "Editor di connessioni idrante manichetta",
                pumpIntakeEditorTitle = "Editor di aspirazione della pompa",
                pumpOutletEditorTitle = "Editor di pomp outlet",
                pumpPanelAccessEditorTitle = "manichetta Control Access Editor",
                scbaRefillBlipLabel = "Ricarica SCBA",
                scbaRefillStationLabel = "Stazione di ricarica SCBA",
            },
            settingFields = {
                cannonId = "ID del cannone ad acqua",
                cannonLabel = "Nome del cannone ad acqua",
                reason = "Motivo",
                airBottleSlots = "Fessure per bottiglie d'aria",
                amount = "Quantità",
                automatic = "Automatico",
                canSpread = "Consentire la diffusione del fuoco",
                component = "Componente",
                connection = "Connessione",
                currentPosition = "Situazione attuale",
                delete = "Elimina",
                description = "Descrizione",
                dispatchJobs = "Lavori destinatari",
                drawables = "Disegni",
                enabled = "Abilitato",
                fillLevel = "Livello di riempimento",
                fireType = "Tipo di incendio con sorgente di accensione",
                foamTankEnabled = "Serbatoio schiuma",
                foamTankSize = "Litri di schiuma",
                gearKey = "Digitare",
                hydrantConnection = "Collegamento idrante",
                hydrantRx = "idrante RX",
                hydrantRy = "idrante RY",
                hydrantRz = "idrante RZ",
                hydrantX = "idrante X",
                hydrantY = "idrante Y",
                hydrantZ = "idrante Z",
                id = "ID",
                igniteDistance = "Distanza dall'accensione dell'impianto",
                intensity = "Intensità",
                job = "Lavoro",
                jobs = "Lavori in servizio",
                key = "Chiave",
                label = "Etichetta",
                location = "Ubicazione",
                maintenanceStatus = "Manutenzione",
                minOnDuty = "in servizio richiesto",
                minimum = "Minimo online",
                mission = "Missione",
                model = "Modello",
                name = "Nome",
                prop = "oggetto",
                pumpConnections = "Collegamenti alla pompa",
                pumpDischargeCount = "Scarichi di pompa",
                pumpIntake1Connection = "Assunzione 1",
                pumpIntake1Label = "Etichetta dell'assunzione 1",
                pumpIntake1Rx = "Rotazione dell'assunzione 1 X",
                pumpIntake1Ry = "Rotazione dell'assunzione 1 Y",
                pumpIntake1Rz = "Rotazione Z dell'assunzione 1",
                pumpIntake1X = "Assunzione 1 X",
                pumpIntake1Y = "Assunzione 1 Y",
                pumpIntake1Z = "Assunzione 1 Z",
                pumpIntake2Connection = "Assunzione 2",
                pumpIntake2Label = "Etichetta dell'assunzione 2",
                pumpIntake2Rx = "Rotazione dell'assunzione 2 X",
                pumpIntake2Ry = "Rotazione dell'assunzione 2 Y",
                pumpIntake2Rz = "Rotazione Z dell'assunzione 2",
                pumpIntake2X = "Assunzione 2 X",
                pumpIntake2Y = "Assunzione 2 Y",
                pumpIntake2Z = "Assunzione 2 Z",
                pumpIntakeCount = "Aspirazione della pompa",
                pumpOutlet1Connection = "Uscita 1",
                pumpOutlet1Label = "Etichetta di uscita 1",
                pumpOutlet1Rx = "Outlet 1 rotazione X",
                pumpOutlet1Ry = "Outlet 1 rotazione Y",
                pumpOutlet1Rz = "Outlet 1 rotazione Z",
                pumpOutlet1X = "Outlet 1 X",
                pumpOutlet1Y = "Outlet 1 Y",
                pumpOutlet1Z = "Outlet 1 Z",
                pumpOutlet2Connection = "Uscita 2",
                pumpOutlet2Label = "Etichetta di uscita 2",
                pumpOutlet2Rx = "Outlet 2 rotazione X",
                pumpOutlet2Ry = "Outlet 2 rotazione Y",
                pumpOutlet2Rz = "Outlet 2 rotazione Z",
                pumpOutlet2X = "Outlet 2 X",
                pumpOutlet2Y = "Outlet 2 Y",
                pumpOutlet2Z = "Outlet 2 Z",
                pumpOutlet3Connection = "Uscita 3",
                pumpOutlet3Label = "Etichetta di uscita 3",
                pumpOutlet3Rx = "Outlet 3 rotazione X",
                pumpOutlet3Ry = "Outlet 3 rotazione Y",
                pumpOutlet3Rz = "Outlet 3 rotazione Z",
                pumpOutlet3X = "Outlet 3 X",
                pumpOutlet3Y = "Outlet 3 Y",
                pumpOutlet3Z = "Outlet 3 Z",
                pumpOutlet4Connection = "Uscita 4",
                pumpOutlet4Label = "Etichetta di uscita 4",
                pumpOutlet4Rx = "Outlet 4 rotazione X",
                pumpOutlet4Ry = "Outlet 4 rotazione Y",
                pumpOutlet4Rz = "Outlet 4 rotazione Z",
                pumpOutlet4X = "Outlet 4 X",
                pumpOutlet4Y = "Outlet 4 Y",
                pumpOutlet4Z = "Outlet 4 Z",
                pumpPanelAccess = "manichetta Controllo accesso",
                pumpPanelConfigured = "Pannello configurato",
                pumpPanelSize = "Dimensioni del pannello",
                pumpPanelX = "Pannello X",
                pumpPanelY = "Pannello Y",
                pumpPanelZ = "Pannello Z",
                resource = "Risorsa",
                rx = "RX",
                ry = "RY",
                rz = "RZ",
                scenario = "Missione",
                sourceScale = "Dimensione del fuoco risultante",
                state = "Stato del monte",
                teleport = "Teletrasporto",
                textures = "Texture",
                turretBone = "Osso della canna della torretta",
                turretMuzzleOffsetX = "Spostamento del muso X",
                turretMuzzleOffsetY = "Spostamento muso Y",
                turretMuzzleOffsetZ = "Spostamento del muso Z",
                turretOffsetX = "Scostamento della torretta X",
                turretOffsetY = "Spostamento torretta Y",
                turretOffsetZ = "Spostamento della torretta Z",
                turretTipOffset = "Distanza punta canna",
                waterGravityScale = "Gravità dell'acqua",
                waterTankEnabled = "Serbatoio dell'acqua",
                waterTankSize = "Litri d'acqua",
                waterVelocity = "Velocità dell'acqua",
                weather = "Tipo di tempo",
                x = "X",
                y = "Y",
                z = "Z",
                zOffset = "Spostamento altezza fuoco",
            },
            settingGroups = {
                billing = { label = "Fatturazione" },
                absorbentMinigame = {
                    description = "Controlla lo spargimento di olio assorbente minigioco.",
                    label = "minigioco absorbente",
                },
                access = {
                    label = "Accesso",
                },
                air = {
                    label = "Aria respirabile",
                },
                airItem = {
                    label = "Elemento della bottiglia d'aria",
                },
                airRefill = {
                    label = "Ricarica dell'aria",
                },
                ambulance = {
                    label = "Ambulanza",
                },
                animals = {
                    label = "Salvataggio di animali",
                },
                attachment = {
                    label = "Allegato",
                },
                automaticMissionDispatch = {
                    description = "Controlla la creazione di centrale operativa per le missioni avviate automaticamente e manualmente.",
                    label = "Centrale operativa",
                },
                automaticMissionJobs = {
                    description = "Questi lavori vengono utilizzati quando una missione non ha lavori specifici della missione.",
                    label = "Lavori servizio predefiniti",
                },
                automaticMissionList = {
                    description = "Ogni missione del Creatore Missionario è automaticamente elencata.",
                    label = "Le missioni disponibili",
                },
                automaticMissionTiming = {
                    description = "Controlla quando il programmatore tenta di avviare una missione automatica.",
                    label = "Attivazione automatica",
                },
                breathing = {
                    label = "Respirazione",
                },
                breathingClothing = {
                    label = "Indumenti di protezione dal respiro",
                },
                burnDamage = {
                    label = "Danni alla masterizzazione",
                },
                cleanup = {
                    description = "Controlli necessari articoli di pulizia, il consumo di articoli e i tempi di avanzamento di ripiego.",
                    label = "Flusso di pulizia",
                },
                consumption = {
                    label = "Consumo",
                },
                creator = {
                    label = "Creatore",
                },
                detection = {
                    label = "Rilevamento",
                },
                dispatch = {
                    label = "Centrale operativa",
                },
                distance = {
                    label = "Distanze",
                },
                dump = {
                    label = "Dump acqua",
                },
                effects = {
                    label = "Effetti",
                },
                engineBehavior = {
                    label = "Sicurezza dei veicoli",
                },
                engineOutput = {
                    label = "Output motore",
                },
                engineRetention = {
                    label = "Ritenzione del motore",
                },
                enterAnimation = {
                    label = "Inserisci animazione",
                },
                exitAnimation = {
                    label = "Animazione di uscita",
                },
                explosion = {
                    label = "Esplosione",
                },
                external = {
                    label = "Esterna",
                },
                extinguish = {
                    label = "Estinzione",
                },
                extinguisher = {
                    label = "Estintore",
                },
                femaleBreathingClothing = {
                    label = "Indumenti di protezione dal respiro",
                },
                femaleHeatClothing = {
                    label = "Indumenti per la protezione contro il calore",
                },
                femaleProtectiveMaskClothing = {
                    label = "Indumenti con maschera protettiva",
                },
                fieldFlow = {
                    label = "Flusso di campo",
                },
                fireExtinguishFeedback = {
                    label = "Spegnere il feedback",
                },
                fireParticles = {
                    label = "Fiamme e fumo",
                },
                fireReward = {
                    description = "Controlla il deposito della società pagato quando un fuoco standalone è completamente spento.",
                    label = "Payout fuoco",
                },
                fireRewardJobs = {
                    description = "Le società di lavoro che ricevono il pagamento standalone del fuoco. Ogni lavoro usa il suo conto della società configurata.",
                    label = "L'occupazione nella società del fuoco",
                },
                fireSoundAmbient = {
                    label = "Ambiente antincendio",
                },
                fireSoundChainsaw = {
                    label = "Sega a catena",
                },
                fireSoundFlare = {
                    label = "Suono luminoso",
                },
                fireThirst = {
                    label = "Sete di fuoco",
                },
                flow = {
                    label = "Flusso",
                },
                flowBehavior = {
                    label = "Comportamento di flusso",
                },
                foamRefill = {
                    label = "Riempimento schiuma",
                },
                foamRefillVisual = {
                    label = "Ricarica della schiuma Visual",
                },
                fullFireStage = {
                    label = "Stadio di fuoco completo",
                },
                general = {
                    label = "Generale",
                },
                glassMinigame = {
                    description = "Controlla il punto debole veicolo-finestra minigioco.",
                    label = "Vetro minigioco",
                },
                groundActionAnimation = {
                    label = "Animazione per la gestione del terreno",
                },
                hazard = {
                    description = "Controlla il pericolo di fuoriuscita, l'intensità e le soglie di rimozione automatica.",
                    label = "Configurazione pericoli",
                },
                heat = {
                    label = "Calore",
                },
                heatClothing = {
                    label = "Indumenti per la protezione contro il calore",
                },
                heatStress = {
                    label = "Stress termico",
                },
                helicopters = {
                    label = "Elicotteri",
                },
                hoseGrounding = {
                    label = "Messa a terra",
                },
                hosePerformance = {
                    label = "Prestazioni",
                },
                hoseProp = {
                    label = "manichetta oggetto",
                },
                hosePropGeometry = {
                    label = "Geometria oggetto",
                },
                hoseSimulation = {
                    label = "Simulazione",
                },
                hydrantSupply = {
                    label = "idrante Supply",
                },
                hydrants = {
                    label = "idranti",
                },
                idleAnimation = {
                    label = "Animazione operativa",
                },
                ignition = {
                    label = "Nuovi incendi dal menu",
                },
                interaction = {
                    label = "Interazione",
                },
                item = {
                    label = "Voce",
                },
                items = {
                    label = "Elementi",
                },
                keybinds = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Assegnazione tasti",
                },
                landing = {
                    label = "Sbarco",
                },
                limits = {
                    label = "Limiti",
                },
                maintenance = {
                    label = "Stato",
                },
                maintenanceAccess = {
                    label = "Accesso",
                },
                manual = {
                    label = "Accensione manuale",
                },
                manualOnly = {
                    label = "Solo manuale",
                },
                nozzle = {
                    label = "lancia",
                },
                nozzleAttachment = {
                    label = "Allegato manichetta",
                },
                nozzleBend = {
                    label = "Piegare la connessione",
                },
                nozzleDirection = {
                    label = "Direzione di uscita",
                },
                nozzlePlacement = {
                    label = "Posizionamento a terra",
                },
                npcFireReactions = {
                    label = "Reazioni di incendio NPC",
                },
                npcFireReactionsModes = {
                    label = "Modalità di reazione NPC",
                },
                offsets = {
                    label = "Spostamenti allegati",
                },
                oilReward = {
                    description = "Controlla il deposito della società pagato quando una fuoriuscita di petrolio è pulita.",
                    label = "Sovvenzione petrolifera",
                },
                oilRewardJobs = {
                    description = "Le società di lavoro che ricevono i pagamenti di pulizia del petrolio. Ogni lavoro usa il suo conto della società configurata.",
                    label = "Occupazione nella società petrolifera",
                },
                placement = {
                    label = "Posizionamento",
                },
                playerEntrapment = {
                    label = "Trappola del giocatore",
                },
                portablePumpSupply = {
                    label = "Fornitura di pompe portatili",
                },
                pressureControl = {
                    label = "Controllo della pressione",
                },
                pressureLimits = {
                    label = "Limiti di pressione",
                },
                progression = {
                    label = "Progressione",
                },
                propGeneral = {
                    label = "Punti di accensione dell'oggetto",
                },
                propLimits = {
                    label = "Limiti della fonte di accensione",
                },
                propList = {
                    label = "Possibili fonti di accensione",
                },
                props = {
                    label = "oggetti",
                },
                protectiveMask = {
                    label = "Maschera protettiva contro gli incendi",
                },
                protectiveMaskClothing = {
                    label = "Indumenti con maschera protettiva",
                },
                protectiveMaskItem = {
                    label = "Articolo maschera protettiva",
                },
                pump = {
                    label = "Pompa",
                },
                pumpDamage = {
                    label = "Danni alla pompa",
                },
                pumpIntakeHose = {
                    label = "Assunzione manichetta",
                },
                pumpPanelGeneral = {
                    description = "Scegliete tra i semplici comandi manuali della pompa automatici e potenziati.",
                    label = "Modalità pannello",
                },
                pumpTargets = {
                    label = "Obiettivi della connessione",
                },
                rainFire = {
                    label = "Comportamento del fuoco",
                },
                rainGeneral = {
                    label = "Generale",
                },
                rainVisuals = {
                    label = "Visuale",
                },
                rainWeather = {
                    label = "Intensità meteo",
                },
                random = {
                    label = "Casuale",
                },
                randomJobs = {
                    label = "Lavori casuali",
                },
                reignition = {
                    label = "Riaccensione",
                },
                release = {
                    label = "Rilascio",
                },
                render = {
                    label = "Visibilità",
                },
                requirements = {
                    label = "Requisiti",
                },
                rescueReward = {
                    description = "Controlla il deposito della società pagato quando un'operazione di salvataggio è completata.",
                    label = "Payout di salvataggio",
                },
                rescueRewardJobs = {
                    description = "Le società di lavoro che ricevono i pagamenti di salvataggio. Ogni lavoro usa il suo conto della società configurata.",
                    label = "Occupazione nella società del salvataggio",
                },
                restock = {
                    label = "Riporti",
                },
                rpmRange = {
                    label = "Intervallo RPM",
                },
                seatbelt = {
                    description = "Controlla la cintura di sicurezza intrappolata che taglia minigioco.",
                    label = "Cintura di sicurezza minigioco",
                },
                smallFireStage = {
                    label = "Piccolo stadio di incendio",
                },
                smokeStage = {
                    label = "Fase del fumo",
                },
                spreaderMinigame = {
                    description = "Controlla la pressione dello spandiporta minigioco.",
                    label = "Spandiporta minigioco",
                },
                standaloneAccidents = {
                    label = "Incidenti permanenti",
                },
                standaloneResult = {
                    label = "Risultato standalone",
                },
                standaloneThresholds = {
                    label = "Soglie indipendenti",
                },
                stream = {
                    label = "Flusso idrico",
                },
                sweepMinigame = {
                    description = "Controlla l'olio spazzando minigioco.",
                    label = "Spazzatura minigioco",
                },
                tankFill = {
                    label = "Riempimento serbatoio",
                },
                tankSupply = {
                    label = "Fornitura del serbatoio del veicolo",
                },
                targets = {
                    label = "Obiettivi",
                },
                thermalWarnings = {
                    label = "Avvertenze di temperatura",
                },
                timing = {
                    label = "Tempismo",
                },
                treeBase = {
                    description = "Core caduto-albero abilitare, servizio requisito, modello e distanza spawn.",
                    label = "Incidente",
                },
                treeBlip = {
                    description = "Mappa blip mostrata per incidenti caduti attivi.",
                    label = "blip",
                },
                treeCarry = {
                    description = "Modello di tronchi, osso, offset e movimento si fondono durante il trasporto dei pezzi.",
                    label = "Portare oggetto",
                },
                treeCarryAnimation = {
                    description = "dizionario animazione, nome e bandiera usati durante il trasporto dei tronchi.",
                    label = "Animazione per il trasporto",
                },
                treeDispatch = {
                    description = "Controlla se gli incidenti di alberi caduti inviano uno centrale operativa e quali posti di lavoro ricevono.",
                    label = "Centrale operativa",
                },
                treeDropMarker = {
                    description = "Stile marcatore e colore visualizzato all'uscita log.",
                    label = "Marcatore di discesa",
                },
                treeDropZone = {
                    description = "Spostamento locale, raggio e area di pulizia per i tronchi consegnati.",
                    label = "Zona di abbandono",
                },
                treeInteractionMarker = {
                    description = "Stile del marcatore e colore mostrato al punto di interazione dell'albero.",
                    label = "Marcatore di sega",
                },
                treeInteractionPoint = {
                    description = "Distanza di interazione e posizione locale dove i giocatori iniziano a tagliare l'albero.",
                    label = "Punto di sega",
                },
                treeLogSpawn = {
                    description = "Numero, modello, spaziatura e distanza di prelievo per i pezzi di log generati.",
                    label = "Pezzi di tronchi",
                },
                treeReward = {
                    description = "Controlla il deposito della società pagato quando un albero caduto è completamente liberato.",
                    label = "Pagamento dell'albero",
                },
                treeRewardJobs = {
                    description = "Le società di lavoro che ricevono i pagamenti degli alberi caduti. Ogni lavoro usa il relativo cliente configurato della società.",
                    label = "Occupazione nella società degli alberi",
                },
                treeSawAnimation = {
                    description = "dizionario animazione, nome e bandiera utilizzati durante il taglio.",
                    label = "Animazione sega",
                },
                treeSawAttach = {
                    description = "Posizione della motosega, rotazione, collisione e comportamento degli attacchi multa.",
                    label = "Attacco motosega",
                },
                treeSawMinigame = {
                    description = "Quante sezioni di sega devono essere completate prima che i registri possano essere cancellati.",
                    label = "Segatura minigioco",
                },
                treeSawTool = {
                    description = "Modello e osso utilizzato per la motosega tenuta durante il taglio.",
                    label = "Sega a catena oggetto",
                },
                types = {
                    label = "Tipi",
                },
                usage = {
                    label = "Articolo e comando",
                },
                vehicle = {
                    label = "Accensione del veicolo",
                },
                vehicleBend = {
                    label = "Benda del collegamento del veicolo",
                },
                vehicleEntrapment = {
                    label = "Intrappolamento del veicolo",
                },
                vehiclePumpBehavior = {
                    label = "Comportamento pompa e motore",
                },
                vehicleSmokeClasses = {
                    label = "Tipi di veicoli protetti",
                },
                vehicleSmokeProtection = {
                    label = "Protezione contro il fumo dei veicoli",
                },
                vehicleState = {
                    label = "Stato del veicolo",
                },
                vehicleTransfer = {
                    label = "Trasferimento di veicoli",
                },
                vehicleTransferBehavior = {
                    label = "Comportamento di trasferimento",
                },
                vehicleTransferSourceOffset = {
                    label = "Connettore sorgente",
                },
                vehicleTransferTargetOffset = {
                    label = "Connettore di destinazione",
                },
                vehicles = {
                    label = "Veicoli",
                },
                water = {
                    label = "Acqua",
                },
                waterCannon = {
                    label = "Cannone ad acqua per veicoli",
                },
                waterReaction = {
                    label = "Reazione all'acqua",
                },
            },
            settingSections = {
                billing = "Fatturazione",
                activeOilSpills = "Spills di olio attivo",
                automaticMissions = "Missioni automatiche",
                consumption = "Consumo",
                effects = "Effetti",
                extinguishFeedback = "Commenti",
                extinguishing = "Estinzione",
                fire = "Fuoco",
                foamRefill = "Riempimento schiuma",
                foamRefillVisual = "Ricarica della schiuma Visual",
                general = "Generale",
                heliBucket = "Secchio d'acqua",
                hose = "manichetta",
                hydrants = "idranti",
                interiorExtinguishers = "Estintori interni",
                lighter = "accendino",
                minigames = "minigioco",
                npcRescue = "Soccorso NPC",
                oilCleanup = "Pulizia",
                oilGeneral = "Generale",
                oilHazard = "Rischio",
                oilSpills = "Spills olio",
                protectiveGear = "Attrezzi protettivi",
                pump = "Pompa",
                pumpPanel = "Pannello pompa",
                rain = "Pioggia",
                reignition = "Riaccensione",
                rendering = "Rendering",
                rescueCushion = "Cuscino di salvataggio",
                rewardFire = "Ricompensa al fuoco",
                rewardOil = "Premio olio",
                rewardRescue = "Ricompensa salvataggio",
                rewardTree = "Premio albero",
                rewards = "Premi",
                scenarioCreator = "Creatore di missione",
                sounds = "Suoni",
                spread = "Spargere il fuoco",
                treeDispatch = "Centrale operativa",
                treeDrop = "Rinuncia",
                treeGeneral = "Generale",
                treeInteraction = "Interazione",
                treeLogs = "Registri",
                treeSaw = "Segatura",
                trees = "Alberi",
                vehicleEntrapment = "Intrappolamento del veicolo",
                vehicleFires = "Incendi del veicolo",
                vehicleRescue = "Salvataggio di veicoli",
                vehicles = "Veicoli",
                waterMonitor = "Monitor dell'acqua",
            },
            settingSubsections = {
                weaponIgnition = "Incendi da armi",
                activeOilSpills = "Spills di olio attivo",
                consumption = "Consumo",
                engineSafety = "Motore e sicurezza",
                extinguishFeedback = "Commenti",
                extinguisherCustomMounts = "Montature personalizzate",
                extinguisherGeneral = "Generale",
                extinguisherMaintenance = "Manutenzione",
                extinguisherMounts = "Monta e riempi",
                extinguisherPlacement = "Posizionamento",
                extinguishing = "Estinzione",
                femaleClothing = "Vestito femminile",
                foamRefill = "Riempimento schiuma",
                foamRefillVisual = "Ricarica della schiuma Visual",
                general = "Generale",
                hydrants = "idranti",
                hydraulics = "Idraulica",
                keybinds = "Assegnazione tasti",
                maleClothing = "Abbigliamento maschile",
                minigameGlass = "Vetro",
                minigameOilAbsorbent = "Assorbente all'olio",
                minigameOilSweep = "Spazzatura ad olio",
                minigameSaw = "Segatura",
                minigameSeatbelt = "Cintura di sicurezza",
                minigameSpreader = "Distributore porta",
                nozzle = "lancia",
                oilCleanup = "Pulizia",
                oilGeneral = "Generale",
                oilHazard = "Rischio",
                pressure = "Pressione & RPM",
                pump = "Pompa",
                rain = "Pioggia",
                reignition = "Riaccensione",
                rendering = "Rendering",
                reward = "Ricompensa",
                rewardFire = "Ricompensa al fuoco",
                rewardOil = "Premio olio",
                rewardRescue = "Ricompensa salvataggio",
                rewardTree = "Premio albero",
                simulation = "Simulazione",
                sounds = "Suoni",
                spread = "Spargere il fuoco",
                treeDispatch = "Centrale operativa",
                treeDrop = "Rinuncia",
                treeGeneral = "Generale",
                treeInteraction = "Interazione",
                treeLogs = "Registri",
                vehicleFires = "Incendi del veicolo",
                vehicleTransfer = "Trasferimento di veicoli",
                vehicles = "Veicoli",
                visuals = "Visuale",
            },
            settings = {
                fireWeaponIgnitionEnabled = {
                    label = "Abilita incendi da armi",
                    description = "Crea incendi Sky con le armi elencate. Lascia disabilitato finché i vigili del fuoco non sono pronti. Gli incendi esistenti e le fiamme native di GTA restano invariati.",
                },
                fireWeaponIgnitionWeapons = {
                    label = "Armi che possono provocare incendi",
                    description = "Nomi delle armi, ad es. WEAPON_MOLOTOV o WEAPON_FLAREGUN. Un elenco vuoto disabilita gli incendi da armi. Proiettili o impatti devono essere rilevabili.",
                },
                hoseHollowNozzleGroundOffset = {
                    label = "Scostamento da terra della lancia a getto cavo",
                },
                hoseNozzleModel = {
                    label = "Modello della lancia",
                    choose = "Scegli un modello",
                    intact = "Modello della lancia",
                    description = "Scegli la lancia normale o quella europea. Cambiare modello ritira le manichette d'attacco posizionate.",
                    preview = "Anteprima 3D",
                    previewDescription = "Mostra l'oggetto reale nel gioco. Salva la scelta separatamente.",
                    previewHelp = "Frecce per spostare, Page Up/Down per l'altezza, rotellina per ruotare, Invio per chiudere, Backspace per annullare.",
                    invalidModel = "Modello oggetto non valido.",
                    modelMissing = "Questo oggetto non è disponibile nel gioco.",
                    previewFailed = "Impossibile aprire l'anteprima.",
                    previewRequiresGame = "Apri /jobconfig in FiveM per vedere l'oggetto.",
                    options = {
                        normal = "Lancia normale",
                        hohlstrahlrohr = "Lancia europea",
                    },
                },
                fireBillingEnabled = {
                    label = "Abilita fatture",
                    description = "Consente ai vigili del fuoco in servizio di emettere fatture dal menu radiale.",
                },
                fireBillingMode = {
                    label = "Sistema di fatturazione",
                    description = "Usa il fornitore scelto in Sky Base (Sky predefinito) o il pagamento locale in contanti/carta.",
                    options = {
                        consent = "Contanti o carta",
                        framework = "Fornitore di fatturazione Sky Base",
                    },
                },
                fireBillingReasons = {
                    label = "Motivi della fattura",
                    description = "Motivi e prezzi selezionabili. È possibile combinare più motivi.",
                    itemLabel = "Motivo",
                },
                fireBillingRange = {
                    label = "Distanza del destinatario",
                    description = "Distanza massima in metri tra chi emette la fattura e il destinatario.",
                },
                fireBillingMaxAmount = {
                    label = "Importo massimo della fattura",
                    description = "Limite per singola fattura, sia per il sistema interno sia per quello esterno.",
                },
                airBottleSlots = {
                    description = "Configures: Fessure per bottiglie d'aria.",
                    label = "Fessure per bottiglie d'aria",
                },
                canSpread = {
                    description = "Permette ad un incendio iniziato qui di diffondersi attraverso il sistema di diffusione dei pompieri.",
                    label = "Consentire la diffusione del fuoco",
                },
                connection = {
                    description = "Configures: Connessione.",
                    label = "Connessione",
                },
                customExtinguisherMounts = {
                    description = "Supporti personalizzati persistenti con il loro attuale estintore e stato di manutenzione.",
                    label = "Montaggio di estintori posizionati",
                },
                deckGunSprayGamepadKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone sul tetto: tieni premuto",
                },
                deckGunSprayKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone sul tetto: tieni premuto",
                },
                drawables = {
                    description = "Configures: Disegni.",
                    label = "Disegni",
                },
                fireBreathingAirEnabled = {
                    description = "Consuma la pressione dell'aria finita mentre lo SCBA è indossato.",
                    label = "Usa aria cilindro",
                },
                fireBreathingCapacitySeconds = {
                    description = "Configures: Capacità dell'aria secondi.",
                    label = "Capacità dell'aria secondi",
                },
                fireBreathingComponents = {
                    description = "Regole dei componenti per maschera e serbatoio d'aria. I disegnabili accettano qualsiasi, qualsiasi NonPredefinito, un numero, o numeri separati da virgola.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireBreathingCriticalPercent = {
                    description = "Configures: Percentuale aria critica.",
                    label = "Percentuale aria critica",
                },
                fireBreathingHeatConsumption = {
                    description = "Configures: Consumo di calore.",
                    label = "Consumo di calore",
                },
                fireBreathingHudUpdateInterval = {
                    description = "Configures: Intervallo di aggiornamento HUD.",
                    label = "Intervallo di aggiornamento HUD",
                },
                fireBreathingIdleConsumption = {
                    description = "Configures: Consumo idle.",
                    label = "Consumo idle",
                },
                fireBreathingItemEnabled = {
                    description = "Richiede l'elemento di inventario configurato prima che SCBA possa essere utilizzato.",
                    label = "Richiede elemento cilindro",
                },
                fireBreathingItemName = {
                    description = "Configures: Nome dell'elemento del cilindro.",
                    label = "Nome dell'elemento del cilindro",
                },
                fireBreathingItemSaveInterval = {
                    description = "Configures: Intervallo di risparmio di pressione.",
                    label = "Intervallo di risparmio di pressione",
                },
                fireBreathingItemSavePressure = {
                    description = "Configures: Salva i metadati della pressione.",
                    label = "Salva i metadati della pressione",
                },
                fireBreathingJumpingConsumption = {
                    description = "Configures: Saltare il consumo.",
                    label = "Saltare il consumo",
                },
                fireBreathingLowPercent = {
                    description = "Configures: Basso percentuale di aria.",
                    label = "Basso percentuale di aria",
                },
                fireBreathingMaskForceFirstPerson = {
                    description = "Forza la fotocamera in prima persona mentre la sovrapposizione della maschera è attiva.",
                    label = "Forza in prima persona",
                },
                fireBreathingMaskOverlayEnabled = {
                    description = "Mostra l'overlay della maschera in prima persona mentre la protezione respiratoria è attiva.",
                    label = "Maschera sovrapposizione",
                },
                fireBreathingPressureBar = {
                    description = "Configures: Barra di pressione completa.",
                    label = "Barra di pressione completa",
                },
                fireBreathingProps = {
                    description = "Configures: oggetti richiesto.",
                    itemLabel = "oggetto",
                    label = "oggetti richiesto",
                },
                fireBreathingRefillEnabled = {
                    description = "Richiede l'elemento cilindro con i metadati di pressione. Posizionare le stazioni tramite il creatore del fuoco.",
                    label = "Abilita stazioni di ricarica",
                },
                fireBreathingRefillRate = {
                    description = "Configures: Barra di tasso di riempimento al secondo.",
                    label = "Barra di tasso di riempimento al secondo",
                },
                fireBreathingRunningConsumption = {
                    description = "Configures: Consumo di corrente.",
                    label = "Consumo di corrente",
                },
                fireBreathingSmokeConsumption = {
                    description = "Configures: Consumo di fumo.",
                    label = "Consumo di fumo",
                },
                fireBreathingSmokeMultiplier = {
                    description = "Esposizione al fumo che raggiunge ancora il giocatore mentre SCBA è attivo.",
                    label = "Moltiplicatore di esposizione al fumo",
                },
                fireBreathingSprintingConsumption = {
                    description = "Configures: Consumo di stampa.",
                    label = "Consumo di stampa",
                },
                fireBreathingToxicConsumption = {
                    description = "Configures: Consumo tossico.",
                    label = "Consumo tossico",
                },
                fireBreathingToxicMultiplier = {
                    description = "Esposizione tossica riservata tuning per SCBA.",
                    label = "Moltiplicatore di esposizione al fumo tossico",
                },
                fireEditorControl14 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 14",
                },
                fireEditorControl15 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 15",
                },
                fireEditorControl174 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 174",
                },
                fireEditorControl175 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 175",
                },
                fireEditorControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 177",
                },
                fireEditorControl191 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 191",
                },
                fireEditorControl199 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 199",
                },
                fireEditorControl200 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 200",
                },
                fireEditorControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 202",
                },
                fireEditorControl21 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 21",
                },
                fireEditorControl24 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 24",
                },
                fireEditorControl25 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 25",
                },
                fireEditorControl32 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 32",
                },
                fireEditorControl322 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 322",
                },
                fireEditorControl33 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 33",
                },
                fireEditorControl34 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 34",
                },
                fireEditorControl35 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 35",
                },
                fireEditorControl36 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 36",
                },
                fireEditorControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 38",
                },
                fireEditorControl44 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 44",
                },
                fireEditorControl45 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 45",
                },
                fireExtinguishFeedbackAlpha = {
                    description = "Opacità della Sprite da 0 a 255.",
                    label = "Alpha feedback del fuoco",
                },
                fireExtinguishFeedbackEnabled = {
                    description = "Mostra lo sprite di fiamma sopra un fuoco mentre si sta spegnendo.",
                    label = "Abilita sprite di feedback del fuoco",
                },
                fireExtinguishFeedbackHeight = {
                    description = "Spostamento verticale sopra il fuoco dove viene disegnato lo sprite.",
                    label = "Altezza di risposta al fuoco",
                },
                fireExtinguishFeedbackMaxScale = {
                    description = "La più grande dimensione dello sprite quando l'estinzione è appena iniziata.",
                    label = "Scala massima di feedback del fuoco",
                },
                fireExtinguishFeedbackMinScale = {
                    description = "Le dimensioni dello sprite più piccole quando il progresso estinguente è quasi completo.",
                    label = "Scala minima di risposta al fuoco",
                },
                fireExtinguisherEffectiveness = {
                    description = "Moltiplicatore di efficacia universale applicato all'estintore.",
                    label = "Efficacia dell'estintore",
                },
                fireExtinguisherEnabled = {
                    description = "Permette a WEAPON_FIREEXTINGUISHER di spegnere ogni tipo di incendio.",
                    label = "Abilita estintore",
                },
                fireExtinguisherHitRadius = {
                    description = "Configures: Raggio di hit dell'estintore.",
                    label = "Raggio di hit dell'estintore",
                },
                fireExtinguisherProgressPerSecond = {
                    description = "Configures: Velocità di estinzione dell'estintore.",
                    label = "Velocità di estinzione dell'estintore",
                },
                fireExtinguisherRange = {
                    description = "Configures: Campo dell'estintore.",
                    label = "Campo dell'estintore",
                },
                fireFemaleBreathingComponents = {
                    description = "Regole dei componenti femminili per maschera e serbatoio d'aria.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireFemaleBreathingProps = {
                    description = "Configures: oggetti richiesto.",
                    itemLabel = "oggetto",
                    label = "oggetti richiesto",
                },
                fireFemaleHeatComponents = {
                    description = "Norme relative ai componenti femminili per gli indumenti protettivi.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireFemaleHeatProps = {
                    description = "Configures: oggetti richiesto.",
                    itemLabel = "oggetto",
                    label = "oggetti richiesto",
                },
                fireFemaleProtectiveMaskComponents = {
                    description = "Le regole relative ai componenti femminili si applicano quando è equipaggiata la maschera protettiva antincendio.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireFemaleProtectiveMaskProps = {
                    description = "Configures: Oggetti di scena richiesti.",
                    itemLabel = "oggetto",
                    label = "Oggetti di scena richiesti",
                },
                fireFirstSpreadDelaySeconds = {
                    description = "Tempo minimo dopo l'accensione prima che un incendio possa iniziare a diffondersi.",
                    label = "Primi secondi di ritardo di diffusione",
                },
                fireFlameScaleMultiplier = {
                    description = "Dimensione visiva delle fiamme. 1 è la dimensione normale; si applica agli incendi attivi senza modificare la difficoltà di spegnimento.",
                    label = "Moltiplicatore dimensione fiamme",
                },
                fireGearEnabled = {
                    description = "Accende o spegne gli indumenti, SCBA e il controllo termico.",
                    label = "Abilitare dispositivi di protezione",
                },
                fireHeatBurnDurationMultiplier = {
                    description = "Configures: Moltiplicatore di durata di masterizzazione.",
                    label = "Moltiplicatore di durata di masterizzazione",
                },
                fireHeatComponents = {
                    description = "Regole dei componenti per l'abbigliamento protettivo. I disegnabili accettano qualsiasi, qualsiasi NonPredefinito, un numero, o numeri separati da virgola.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireHeatIgnite = {
                    description = "Configures: Può accendere mentre protetto.",
                    label = "Può accendere mentre protetto",
                },
                fireHeatProps = {
                    description = "Configures: oggetti richiesto.",
                    itemLabel = "oggetto",
                    label = "oggetti richiesto",
                },
                fireHeatResistancePercent = {
                    description = "Semplice resistenza di protezione per capi completi vigile del fuoco. 0 significa nessuna riduzione, 100 significa nessun danno diretto al fuoco.",
                    label = "Percentuale di resistenza al calore",
                },
                fireHeatStressBurnLevel = {
                    description = "Configures: Livello di masterizzazione.",
                    label = "Livello di masterizzazione",
                },
                fireHeatStressDamageInterval = {
                    description = "Configures: Intervallo di danni al calore.",
                    label = "Intervallo di danni al calore",
                },
                fireHeatStressDirectFlameDistance = {
                    description = "Configures: Distanza di fiamma diretta.",
                    label = "Distanza di fiamma diretta",
                },
                fireHeatStressEnabled = {
                    description = "Configures: Abilita lo stress termico.",
                    label = "Abilita lo stress termico",
                },
                fireHeatStressExposurePower = {
                    description = "Valori più elevati accumulo di calore lento quando il giocatore è vicino, ma non direttamente all'interno, il fuoco.",
                    label = "Curva di calore a distanza",
                },
                fireHeatStressFullHeatDistance = {
                    description = "Configures: Distanza di calore totale.",
                    label = "Distanza di calore totale",
                },
                fireHeatStressInitialGainMultiplier = {
                    description = "Moltiplicatore utilizzato mentre la temperatura del nucleo è ancora bassa.",
                    label = "Moltiplicatore iniziale di guadagno termico",
                },
                fireHeatStressMaxDistance = {
                    description = "Configures: Distanza massima di stress termico.",
                    label = "Distanza massima di stress termico",
                },
                fireHeatStressProgressionPower = {
                    description = "Valori più alti mantengono l'aumento precoce più lento e lasciare che si espanda più tardi.",
                    label = "Curva di progressione del calore",
                },
                fireHeatStressProtectedDamage = {
                    description = "Configures: Danni protetti.",
                    label = "Danni protetti",
                },
                fireHeatStressProtectedDamageLevel = {
                    description = "Configures: Livello di danno protetto.",
                    label = "Livello di danno protetto",
                },
                fireHeatStressProtectedDecay = {
                    description = "Configures: Decadimento protetto.",
                    label = "Decadimento protetto",
                },
                fireHeatStressProtectedDirectFlameDistance = {
                    description = "Configures: Distanza di fiamma diretta protetta.",
                    label = "Distanza di fiamma diretta protetta",
                },
                fireHeatStressProtectedGain = {
                    description = "Configures: Guadagno di calore protetto.",
                    label = "Guadagno di calore protetto",
                },
                fireHeatStressUnprotectedDamage = {
                    description = "Configures: Danni non protetti.",
                    label = "Danni non protetti",
                },
                fireHeatStressUnprotectedDamageLevel = {
                    description = "Configures: Livello di danno non protetto.",
                    label = "Livello di danno non protetto",
                },
                fireHeatStressUnprotectedDecay = {
                    description = "Configures: Decadimento non protetto.",
                    label = "Decadimento non protetto",
                },
                fireHeatStressUnprotectedDirectFlameDistance = {
                    description = "Configures: Distanza di fiamma diretta non protetta.",
                    label = "Distanza di fiamma diretta non protetta",
                },
                fireHeatStressUnprotectedGain = {
                    description = "Configures: Guadagno di calore non protetto.",
                    label = "Guadagno di calore non protetto",
                },
                fireIgnitionGrowthSeconds = {
                    description = "Secondi necessari a un nuovo incendio creato dal menu per raggiungere la dimensione completa. Vale per i nuovi incendi.",
                    label = "Durata della crescita iniziale",
                },
                fireIgnitionStartScale = {
                    description = "Dimensione iniziale delle fiamme nel menu. I valori inferiori a 1 crescono fino alla dimensione completa del profilo.",
                    label = "Dimensione iniziale nel menu",
                },
                fireInteriorExtinguishersControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Estintore a muro · Controllo 38",
                },
                fireMaxFlameSources = {
                    description = "Limite per client condiviso tra tutti gli incendi. Le fiamme vicine hanno la priorità; limiti inferiori lasciano più capacità per le particelle dei getti d’acqua.",
                    label = "Numero massimo di sorgenti di fiamme visibili",
                },
                fireMaxFlamesPerFire = {
                    description = "Numero massimo di fiamme che un singolo incendio può contenere.",
                    label = "Fuochi massimi per incendio",
                },
                fireMaxSmokeSources = {
                    description = "Limite per client per le colonne di fumo condivise e il fumo interno. Le sorgenti vicine hanno la priorità.",
                    label = "Numero massimo di sorgenti di fumo visibili",
                },
                fireMaxSpreadDistance = {
                    description = "Distanza massima da una fiamma esistente alla quale può comparire una nuova fiamma.",
                    label = "Distanza massima di diffusione",
                },
                fireMinSpreadDistance = {
                    description = "Distanza minima da una fiamma esistente alla quale può comparire una nuova fiamma.",
                    label = "Distanza minima di diffusione",
                },
                fireNozzleProgressPerSecond = {
                    description = "Estinzione del progresso applicato dall'acqua al secondo.",
                    label = "Velocità di estinzione lancia",
                },
                fireNozzleRange = {
                    description = "Distanza massima alla quale la manichetta lancia può colpire un incendio.",
                    label = "Campo di estinzione lancia",
                },
                firePropIgnitionControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Accensione oggetto · Controllo 177",
                },
                firePropIgnitionControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Accensione oggetto · Controllo 38",
                },
                fireProtectiveMaskComponents = {
                    description = "Regole sui componenti applicate quando è equipaggiata la maschera protettiva antincendio.",
                    itemLabel = "Componente",
                    label = "Componenti di abbigliamento richiesti",
                },
                fireProtectiveMaskEnabled = {
                    description = "Abilita la maschera filtrante riutilizzabile per il fumo di incendi senza aria della bombola.",
                    label = "Abilita la maschera protettiva",
                },
                fireProtectiveMaskForceFirstPerson = {
                    description = "Forza la visuale in prima persona mentre la sovrapposizione della maschera protettiva è attiva.",
                    label = "Forza la prima persona",
                },
                fireProtectiveMaskItemEnabled = {
                    description = "Richiede l'articolo di inventario configurato prima di poter utilizzare la maschera protettiva.",
                    label = "Richiede l'articolo maschera protettiva",
                },
                fireProtectiveMaskItemName = {
                    description = "Configures: Nome dell'articolo della maschera protettiva.",
                    label = "Nome dell'articolo della maschera protettiva",
                },
                fireProtectiveMaskOverlayEnabled = {
                    description = "Mostra la sovrapposizione della maschera in prima persona mentre la maschera protettiva è attiva.",
                    label = "Sovrapposizione della maschera",
                },
                fireProtectiveMaskProps = {
                    description = "Configures: Oggetti di scena richiesti.",
                    itemLabel = "oggetto",
                    label = "Oggetti di scena richiesti",
                },
                fireProtectiveMaskSmokeMultiplier = {
                    description = "Esposizione al fumo che raggiunge ancora il giocatore mentre la maschera protettiva è attiva.",
                    label = "Moltiplicatore dell'esposizione al fumo",
                },
                fireProtectiveMaskToxicMultiplier = {
                    description = "Esposizione tossica che raggiunge comunque il giocatore. Valori più elevati rendono necessario l'autorespiratore per i fumi pericolosi.",
                    label = "Moltiplicatore dell'esposizione al fumo tossico",
                },
                fireRainEnabled = {
                    description = "Lascia che la pioggia colpisca gli incendi esterni.",
                    label = "Abilita effetti pioggia",
                },
                fireRainFlameScale = {
                    description = "Scala di fiamma visiva a piena intensità di pioggia.",
                    label = "Scala di fiamma sotto la pioggia",
                },
                fireRainLargeFireSpreadMultiplier = {
                    description = "Moltiplicatore di diffusione per grandi incendi esterni a piena intensità di pioggia.",
                    label = "Grande moltiplicatore di spargimento d'incendio",
                },
                fireRainMinimumIntensity = {
                    description = "I valori di pioggia al di sotto di questa soglia non hanno effetto.",
                    label = "Intensità minima della pioggia",
                },
                fireRainSmallFireMaxFlames = {
                    description = "Gli incendi esterni fino a questo conteggio di fiamma possono essere spenti dalla pioggia.",
                    label = "Piccolo fuoco fiamme massime",
                },
                fireRainSmallFireProgressPerSecond = {
                    description = "Progressi di estinzione delle piogge al secondo a piena intensità meteo.",
                    label = "Velocità di estinzione del piccolo incendio",
                },
                fireRainSmokeScale = {
                    description = "Scala di fumo visiva a piena intensità di pioggia.",
                    label = "Scala fumo sotto la pioggia",
                },
                fireRainWeatherIntensity = {
                    description = "Intensità dell'effetto di pioggia per tipo meteo GTA da 0.0 a 1.0.",
                    itemLabel = "Meteo",
                    label = "Intensità meteo",
                },
                fireReignitionChancePercent = {
                    description = "Per cento di probabilità rotolata ogni volta che una fiamma combustibile si spegne.",
                    label = "% probabilità di riaccensione",
                },
                fireReignitionDelaySeconds = {
                    description = "Secondi tra estinzione e la piccola fiamma di ritorno.",
                    label = "Riaccendere i secondi di ritardo",
                },
                fireReignitionEnabled = {
                    description = "Consente alle fiamme combustibili spente di riaccendersi dopo un breve ritardo.",
                    label = "Abilita la riaccensione",
                },
                fireReignitionExtinguishRequiredPercent = {
                    description = "Per cento del normale progresso di estinzione richiesto prima di una fiamma riaccesa è finalmente fuori.",
                    label = "Completamente fuori dopo l'accensione percentuale",
                },
                fireReignitionFinalExtinguishHoldSeconds = {
                    description = "Secondi estinzione deve continuare dopo il pieno progresso prima che una fiamma riaccesa è finalmente fuori.",
                    label = "Tempo di attesa finale",
                },
                fireReignitionGrowthPerSecond = {
                    description = "Quanta scala la fiamma riaccesa guadagna al secondo fino a raggiungere la grandezza massima.",
                    label = "Crescita al secondo",
                },
                fireReignitionNearImpactAccuracy = {
                    description = "Estinzione della precisione utilizzata quando solo l'impatto è vicino ad una mini fiamma riaccesa.",
                    label = "Precisione dell'impatto vicino",
                },
                fireReignitionNearImpactTolerance = {
                    description = "Metri supplementari intorno ad una mini fiamma riaccesa dove un impatto quasi corrispondente conta ancora.",
                    label = "Tolleranza all'impatto vicino",
                },
                fireReignitionStartScale = {
                    description = "Moltiplicatore di scala usato quando la fiamma riaccende.",
                    label = "Scala di fiamma iniziale",
                },
                fireRenderDistance = {
                    description = "Distanza massima di rendering condivisa per fiamme e fumo.",
                    label = "Fuoco e fumo rendono la distanza",
                },
                fireSmokeDensityMultiplier = {
                    description = "Moltiplica l’opacità visibile del fumo: 0 lo nasconde, 1 è normale e 2 aumenta l’opacità fino al limite consentito. I danni da fumo non cambiano.",
                    label = "Moltiplicatore densità fumo",
                },
                fireSmokeScaleMultiplier = {
                    description = "Dimensione visiva delle colonne di fumo ascendenti. 1 è la dimensione normale; si applica al fumo attivo.",
                    label = "Moltiplicatore dimensione fumo",
                },
                fireSmokeWindResponse = {
                    description = "Quanto intensamente il fumo incluso segue il vento atmosferico. Cambiare profilo ricrea le colonne di fumo.",
                    label = "Influenza del vento sul fumo",
                    options = {
                        gentle = "Lieve",
                        none = "Nessuna influenza del vento",
                        normal = "Normale",
                        strong = "Forte",
                    },
                },
                fireSoundChainsawEnabled = {
                    description = "Suona il suono della motosega in 3D mentre un giocatore sega un albero caduto.",
                    label = "Abilita il suono della motosega",
                },
                fireSoundChainsawRange = {
                    description = "Distanza in metri dove i giocatori possono sentire la motosega.",
                    label = "Gamma di motoseghe",
                },
                fireSoundChainsawVolume = {
                    description = "Volume massimo per il suono della motosega 3D.",
                    label = "Volume della motosega",
                },
                fireSoundFireAmbientEnabled = {
                    description = "Riproduce suoni spaziali del fuoco adatti al tipo di incendio.",
                    label = "Abilita il suono ambientale del fuoco",
                },
                fireSoundFireAmbientRange = {
                    description = "Distanza in metri dove i giocatori possono sentire fuochi attivi.",
                    label = "Ampiezza dell'ambiente di combustione",
                },
                fireSoundFireAmbientVolume = {
                    description = "Volume generale dei suoni spaziali del fuoco: 0 = muto, 1 = massimo. Le modifiche valgono anche per gli incendi attivi.",
                    label = "Volume ambiente di incendio",
                },
                fireSoundFireFlareEnabled = {
                    description = "Riproduce il suono corto durante le reazioni dell'acqua.",
                    label = "Abilita il suono del flare",
                },
                fireSoundFireFlareRange = {
                    description = "Distanza in metri dove i giocatori possono sentire i suoni del flare di reazione all'acqua.",
                    label = "Intervallo di luminosità del suono",
                },
                fireSoundFireFlareVolume = {
                    description = "Volume massimo per il suono del flare a reazione idrica.",
                    label = "Volume del suono luminoso",
                },
                fireSpreadAttemptsPerTick = {
                    description = "Numero di possibili posizioni di spread controllate durante ogni aggiornamento di spread.",
                    label = "Tentativi di diffusione per aggiornamento",
                },
                fireSpreadEnabled = {
                    description = "Consente agli incendi attivi di creare ulteriori fiamme su ambienti combustibili.",
                    label = "Abilita la diffusione del fuoco",
                },
                fireSpreadIntervalSeconds = {
                    description = "Intervallo di base tra gli aggiornamenti di spread. Valori più bassi eseguono controlli di spread più frequentemente.",
                    label = "Secondi intervallo di diffusione",
                },
                fireThirstEnabled = {
                    description = "Aumenta il consumo di sete mentre il giocatore è esposto al calore del fuoco.",
                    label = "Abilita l'aumento della sete",
                },
                fireThirstMinimumBaseLossPerMinute = {
                    description = "Perdita minima di sete utilizzata come base di moltiplicatore quando il tasso quadro è troppo piccolo per notarlo.",
                    label = "Perdita minima di base al minuto",
                },
                fireThirstMultiplier = {
                    description = "Moltiplica la normale perdita di sete mentre il giocatore è esposto al calore del fuoco.",
                    label = "Sete moltiplicatore",
                },
                fireThirstUpdateInterval = {
                    description = "Intervallo tra i controlli dello stato del framework mentre il giocatore rimane esposto al calore dell'incendio.",
                    label = "Intervallo di controllo dello stato ms",
                },
                fireType = {
                    description = "Determina quale profilo antincendio viene utilizzato per questa fonte di accensione.",
                    label = "Tipo di incendio con sorgente di accensione",
                },
                fireWaterMonitorControl172 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 172",
                },
                fireWaterMonitorControl173 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 173",
                },
                fireWaterMonitorControl174 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 174",
                },
                fireWaterMonitorControl175 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 175",
                },
                fireWaterMonitorControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 177",
                },
                fireWaterMonitorControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 202",
                },
                fireWaterMonitorControl24 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 24",
                },
                fireWaterMonitorControl241 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 241",
                },
                fireWaterMonitorControl242 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 242",
                },
                fireWaterMonitorControl25 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cannone ad acqua · Controllo 25",
                },
                firetruckHudCursorKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "HUD autopompa: tieni interazione mouse",
                },
                firetruckHudToggleKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Attiva/disattiva HUD autopompa",
                },
                firetruckWaterCannonEnabled = {
                    description = "Consente l'installazione di cannoni ad acqua su veicoli supportati per spegnere gli incendi.",
                    label = "Abilita cannone d'acqua del veicolo",
                },
                firetruckWaterCannonMinRange = {
                    description = "La distanza più stretta che il cannone del veicolo fisso può raggiungere perché non può mirare completamente verso il basso.",
                    label = "Gamma minima di cannoni ad acqua",
                },
                firetruckWaterCannonModels = {
                    description = "Una riga per cannone. Ripeti il modello per i cannoni sul tetto e anteriore, con un ID univoco per modello e il bone della canna corretto. Le voci esistenti usano deckGun. Ogni cannone richiede un ID univoco per modello (1-48 lettere senza accenti, cifre, trattini bassi o trattini).",
                    itemLabel = "Cannone ad acqua",
                    label = "Cannoni ad acqua dei veicoli",
                },
                firetruckWaterCannonProgressPerSecond = {
                    description = "Estinzione dei progressi applicati dai cannoni ad acqua per veicolo al secondo.",
                    label = "Velocità di estinzione cannone d'acqua",
                },
                foamTankEnabled = {
                    description = "Configures: Serbatoio schiuma.",
                    label = "Serbatoio schiuma",
                },
                foamTankSize = {
                    description = "Configures: Litri di schiuma.",
                    label = "Litri di schiuma",
                },
                gearKey = {
                    options = {
                        helmet = "Casco",
                        mask = "Maschera",
                        other = "Altro (nessuna protezione)",
                        pants = "Pantaloni",
                        shoes = "Scarpe",
                        top = "Alto",
                    },
                },
                heatLevelHudPosition = {
                    description = "Posizione del pannello HUD di esposizione al calore.",
                    label = "Posizione del pannello di esposizione al calore",
                },
                heliBucketAllowedJobs = {
                    description = "Lasciare vuoto per consentire tutti i lavori configurati in questo Firejob.",
                    itemLabel = "Lavoro",
                    label = "Lavori ammessi",
                },
                heliBucketAttachDistance = {
                    description = "Distanza massima tra il punto di attacco dell'elicottero e la benna durante l'attacco.",
                    label = "Distanza massima dell'attacco",
                },
                heliBucketAttachKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Aggancia/sgancia benna elicottero",
                },
                heliBucketAutoAttachOnGround = {
                    description = "Aggancia automaticamente un secchio a terra vicino quando l'elicottero è a portata.",
                    label = "Attacco automatico corda a terra",
                },
                heliBucketBucketOffsetX = {
                    description = "Posizione X locale dove la corda si attacca alla benna oggetto.",
                    label = "Spostamento della corda del secchio X",
                },
                heliBucketBucketOffsetY = {
                    description = "Posizione Y locale dove la corda si attacca alla benna oggetto.",
                    label = "Spostamento della corda del secchio Y",
                },
                heliBucketBucketOffsetZ = {
                    description = "Posizione Z locale dove la corda si attacca alla benna oggetto.",
                    label = "Spostamento della corda del secchio Z",
                },
                heliBucketCommand = {
                    description = "Nome di comando senza slash, per esempio waterbucket.",
                    label = "Comando",
                },
                heliBucketCommandEnabled = {
                    description = "Permette di posizionare il Secchio d'Acqua senza un elemento utilizzando il comando.",
                    label = "Abilita l' uso dei comandi",
                },
                heliBucketConsumeItem = {
                    description = "Rimuove un elemento configurato dopo il posizionamento riuscito.",
                    label = "Consumare la voce sul collocamento",
                },
                heliBucketDetachMaxGroundDistance = {
                    description = "Altezza massima della benna al di sopra del suolo alla quale è consentito staccare.",
                    label = "Altezza massima di distacco",
                },
                heliBucketDumpEnabled = {
                    description = "Permette di liberare l'acqua immagazzinata dal secchio.",
                    label = "Abilita scarico dell'acqua",
                },
                heliBucketDumpHitRadius = {
                    description = "Raggio intorno alla colonna d'acqua che cade che può colpire gli incendi.",
                    label = "Raggio di hit",
                },
                heliBucketDumpJetScale = {
                    description = "Scala visiva del getto d'acqua principale sotto il secchio.",
                    label = "Scala Jet",
                },
                heliBucketDumpKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Scarica acqua dalla benna",
                },
                heliBucketDumpLitersPerSecond = {
                    description = "Quantità di acqua immagazzinata rilasciata al secondo durante il dumping.",
                    label = "Dump litri al secondo",
                },
                heliBucketDumpProgressPerSecond = {
                    description = "Forza di estinzione della base applicata agli incendi all'interno della colonna d'acqua.",
                    label = "Spegnere il progresso al secondo",
                },
                heliBucketDumpRayLength = {
                    description = "Massima distanza verso il basso controllata per gli incendi sotto la benna.",
                    label = "Lunghezza del raggio",
                },
                heliBucketDumpSprayScale = {
                    description = "Scala visiva dell'ampio effetto spray acqua sotto il secchio.",
                    label = "Scala spray",
                },
                heliBucketEnabled = {
                    description = "Consente il posizionamento, l'attacco in elicottero, il riempimento e lo scarico dei secchi d'acqua.",
                    label = "Abilita il secchio dell'acqua",
                },
                heliBucketGroundAttachDistance = {
                    description = "Altezza massima della benna a terra consentita per l'attacco automatico.",
                    label = "Distanza dell'attacco a terra",
                },
                heliBucketHelicopterOffsets = {
                    description = "Posizione dell'attacco della corda per modello di elicottero; utilizzare di default come modello di ripiego.",
                    itemLabel = "Spostamento",
                    label = "Spostamento della fune dell'elicottero",
                },
                heliBucketHelicopters = {
                    description = "I nomi dei modelli di elicotteri che possono attaccare il Secchio d'Acqua.",
                    itemLabel = "Elicottero",
                    label = "Modelli di elicotteri ammessi",
                },
                heliBucketItem = {
                    description = "Inventario usato per posizionare il Water Bucket.",
                    label = "Nome dell'elemento",
                },
                heliBucketItemEnabled = {
                    description = "Permette di posizionare il Secchio d'Acqua utilizzando l'elemento d'inventario configurato.",
                    label = "Abilita l' uso dell' elemento",
                },
                heliBucketLabel = {
                    description = "Nome mostrato nelle interazioni e nelle notifiche.",
                    label = "Visualizza etichetta",
                },
                heliBucketModel = {
                    description = "Modello oggetto spawn per il Secchio Acqua.",
                    label = "Modello Bucket oggetto",
                },
                heliBucketMovingStreamDistance = {
                    description = "Massima distanza di sincronizzazione mentre il Secchio d'Acqua è collegato e moVINg.",
                    label = "Distanza di streaming MoVINg",
                },
                heliBucketPickupDistance = {
                    description = "Distanza massima dalla quale si può prelevare un secchio d'acqua non attaccato.",
                    label = "Distanza di prelievo",
                },
                heliBucketRequireOnDuty = {
                    description = "Consente solo ai membri del servizio di un lavoro consentito di utilizzare il Water Bucket.",
                    label = "Richiedi servizio attivo",
                },
                heliBucketRequirePilot = {
                    description = "Richiede al giocatore di occupare il sedile pilota dell'elicottero prima di controllare la benna.",
                    label = "Richiede il sedile del pilota",
                },
                heliBucketReturnItemOnRemove = {
                    description = "Restituisce un elemento configurato quando il Secchio d'Acqua viene prelevato.",
                    label = "Restituisci l'elemento al ritiro",
                },
                heliBucketRopeLength = {
                    description = "Lunghezza della corda che collega l'elicottero e Water Bucket.",
                    label = "Lunghezza corda",
                },
                heliBucketRopeType = {
                    description = "Identificazione del tipo di corda GTA utilizzata per il collegamento a benna.",
                    label = "Tipo di corda",
                },
                heliBucketStreamDistance = {
                    description = "Massima distanza di sincronizzazione mentre il Secchio d'Acqua è fermo.",
                    label = "Distanza di streaming",
                },
                heliBucketWaterCapacityLiters = {
                    description = "Massima quantità di acqua che il secchio può contenere.",
                    label = "Capacità litri",
                },
                heliBucketWaterCheckIntervalMs = {
                    description = "Intervallare in millisecondi tra i controlli per l'immersione della benna.",
                    label = "Intervallo di controllo dell'acqua ms",
                },
                heliBucketWaterEnabled = {
                    description = "Permette al Secchio d'Acqua di raccogliere acqua quando è sommerso.",
                    label = "Abilita riempimento acqua",
                },
                heliBucketWaterFillRateLitersPerSecond = {
                    description = "Quantità di acqua aggiunta al secondo mentre la benna è sommersa.",
                    label = "Tasso di riempimento litri al secondo",
                },
                heliBucketZOffset = {
                    description = "Correzione verticale applicata quando si posiziona la benna oggetto a terra.",
                    label = "Spostamento Z del terreno",
                },
                hoseAddPointDistance = {
                    description = "Distanza di movimento richiesta prima di aggiungere un altro punto manichetta.",
                    label = "Aggiungi distanza punti",
                },
                hoseDeployDistance = {
                    description = "Distanza massima dal veicolo al quale può essere installato uno manichetta.",
                    label = "Distanza di spiegamento",
                },
                hoseFoamLitersPerSecond = {
                    description = "Tasso di scarico della schiuma durante la spruzzatura della schiuma.",
                    label = "Litri di schiuma al secondo",
                },
                hoseFoamRefillAnimDict = {
                    description = "Configures: Dizionario animazione ricarica schiuma.",
                    label = "Dizionario animazione ricarica schiuma",
                },
                hoseFoamRefillAnimFlag = {
                    description = "Configures: Bandiera anim ricarica schiuma.",
                    label = "Bandiera anim ricarica schiuma",
                },
                hoseFoamRefillAnimName = {
                    description = "Configures: Denominazione dell'animazione di ricarica della schiuma.",
                    label = "Denominazione dell'animazione di ricarica della schiuma",
                },
                hoseFoamRefillBone = {
                    description = "Configures: Ricarica di schiuma osso.",
                    label = "Ricarica di schiuma osso",
                },
                hoseFoamRefillDistance = {
                    description = "Distanza massima dal veicolo durante la ricarica.",
                    label = "Distanza di ricarica della schiuma",
                },
                hoseFoamRefillDurationMs = {
                    description = "Durata del processo per un'azione di ricarica.",
                    label = "Durata di ricarica della schiuma ms",
                },
                hoseFoamRefillEnabled = {
                    description = "Lasciare riempire i serbatoi di schiuma del veicolo con un elemento di inventario.",
                    label = "Abilita la ricarica della schiuma",
                },
                hoseFoamRefillItem = {
                    description = "Articolo d'inventario richiesto per riempire il serbatoio di schiuma.",
                    label = "Elemento di ricarica della schiuma",
                },
                hoseFoamRefillLiters = {
                    description = "Quanti litri di schiuma si aggiunge al serbatoio del veicolo.",
                    label = "Litri di ricarica della schiuma",
                },
                hoseFoamRefillOffsetRx = {
                    description = "Configures: Rotazione di ricarica della schiuma X.",
                    label = "Rotazione di ricarica della schiuma X",
                },
                hoseFoamRefillOffsetRy = {
                    description = "Configures: Rotazione di ricarica della schiuma Y.",
                    label = "Rotazione di ricarica della schiuma Y",
                },
                hoseFoamRefillOffsetRz = {
                    description = "Configures: Rotazione di ricarica della schiuma Z.",
                    label = "Rotazione di ricarica della schiuma Z",
                },
                hoseFoamRefillOffsetX = {
                    description = "Configures: Spostamento della schiuma X.",
                    label = "Spostamento della schiuma X",
                },
                hoseFoamRefillOffsetY = {
                    description = "Configures: Spostamento della schiuma Y.",
                    label = "Spostamento della schiuma Y",
                },
                hoseFoamRefillOffsetZ = {
                    description = "Configures: Spostamento della schiuma Z.",
                    label = "Spostamento della schiuma Z",
                },
                hoseFoamRefillProp = {
                    description = "oggetto mostrato nella mano mentre si ricarica il serbatoio di schiuma.",
                    label = "Ricarica della schiuma oggetto",
                },
                hoseFoamRefillRequireOnDuty = {
                    description = "Configures: Richiede in servizio per la ricarica in schiuma.",
                    label = "Richiede in servizio per la ricarica in schiuma",
                },
                hoseFoamWaterLitersPerSecond = {
                    description = "Portata di scarico del serbatoio dell'acqua durante la spruzzatura di schiuma senza alimentazione esterna.",
                    label = "Litri d'acqua schiuma al secondo",
                },
                hoseGroundActionAnimationDict = {
                    description = "Configures: Dizionario animazione.",
                    label = "Dizionario animazione",
                },
                hoseGroundActionAnimationDurationMs = {
                    description = "Durata totale dell'animazione in millisecondi.",
                    label = "Durata dell'animazione",
                },
                hoseGroundActionAnimationEnabled = {
                    description = "Gioca un'animazione mentre sdraiati o raccoglie l'attacco manichetta.",
                    label = "Abilita la gestione dell'animazione",
                },
                hoseGroundActionAnimationFlag = {
                    description = "Configures: Flag animazione.",
                    label = "Flag animazione",
                },
                hoseGroundActionAnimationLayDownName = {
                    description = "Configures: Animazione di posa.",
                    label = "Animazione di posa",
                },
                hoseGroundActionAnimationPickUpName = {
                    description = "Configures: Animazione pick-up.",
                    label = "Animazione pick-up",
                },
                hoseGroundActionAnimationTransitionMs = {
                    description = "Tempo in millisecondi in cui la lancia cambia tra la mano e il terreno.",
                    label = "Tempo di transizione dell'oggetto",
                },
                hoseGroundOffset = {
                    description = "Spostamento verticale utilizzato quando i nuovi punti manichetta vengono posizionati a terra.",
                    label = "Spostamento del suola manichetta",
                },
                hoseGroundedNozzleHeadingOffset = {
                    description = "La correzione dello sbadiglio si è aggiunta alla direzione di fronte del giocatore quando ha posato la lancia.",
                    label = "Spostamento lancia a terra orientamento",
                },
                hoseGroundedNozzleOffset = {
                    description = "Correzione verticale applicata all'oggetto dell'arma dopo il posizionamento a terra.",
                    label = "Spostamento lancia a terra",
                },
                hoseGroundedNozzlePitch = {
                    description = "Piazzola usata per posare il modella lancia pianeggiante a terra.",
                    label = "Piazzola lancia messa a terra",
                },
                hoseGroundedNozzleRoll = {
                    description = "Correzione del rotolo applicata al modella lancia a terra.",
                    label = "Rotola lancia macinato",
                },
                hoseHydrantConnectDistance = {
                    description = "Distanza massima da un idrante oggetto quando si attacca una linea di alimentazione.",
                    label = "idrante distanza di connessione",
                },
                hoseHydrants = {
                    description = "Modelli oggetto rilevati come idranti per i collegamenti delle manichette e sulla mappa.",
                    itemLabel = "Idrante",
                    label = "Modelli oggetto idrante",
                },
                hoseMaxLength = {
                    description = "Lunghezza massima della manichetta in metri prima che la lancia si disconnetta.",
                    label = "Lunghezza massima manichetta",
                },
                hoseNozzleBendDistance = {
                    description = "Distanza usata per formare la curva manichetta dietro la lancia.",
                    label = "lancia distanza curva",
                },
                hoseNozzleExitDirectionX = {
                    description = "Direzione X locale in cui la manichetta esce dalla lancia.",
                    label = "Direzione di uscita X",
                },
                hoseNozzleExitDirectionY = {
                    description = "Direzione locale Y in cui la manichetta esce dalla lancia.",
                    label = "Direzione di uscita Y",
                },
                hoseNozzleExitDirectionZ = {
                    description = "Direzione Z locale in cui la manichetta esce dalla lancia.",
                    label = "Direzione di uscita Z",
                },
                hoseNozzleExitLength = {
                    description = "Lunghezza dritta manichetta leaVINg lancia prima della prima curva.",
                    label = "Lunghezza di uscita lancia",
                },
                hoseNozzleOffsetX = {
                    description = "X offset dell'attacco manichetta sull'arma lancia.",
                    label = "Spostamento lancia X",
                },
                hoseNozzleOffsetY = {
                    description = "Spostamento Y dell'attacco manichetta sull'arma lancia.",
                    label = "Spostamento lancia Y",
                },
                hoseNozzleOffsetZ = {
                    description = "Spostamento Z dell'attacco manichetta sull'arma lancia.",
                    label = "lancia offset Z",
                },
                hoseDividing = {
                    description = "Attiva il divisore portatile a tre vie con valvole indipendenti e flusso d'acqua. Disattivato per impostazione predefinita.",
                    label = "Divisore manichette",
                },
                hosePerformanceMode = {
                    description = "High End privilegia il movimento manichetta più fluido. Le prestazioni riducono gli aggiornamenti manichetta e riducono il carico client.",
                    label = "Modalità prestazioni manichetta",
                    options = {
                        high_end = "Alta gamma",
                        performance = "Prestazioni",
                    },
                },
                hosePropBaseLength = {
                    description = "Lunghezza originale del modello del segmento manichetta prima della scalatura.",
                    label = "Lunghezza base oggetto",
                },
                hosePropBaseRadius = {
                    description = "Raggio originale del modello del segmento manichetta prima della scalatura.",
                    label = "Raggio base oggetto",
                },
                hosePropLengthRatio = {
                    description = "Correzione della lunghezza applicata durante la scalatura del modello del segmento manichetta.",
                    label = "Rapporto lunghezza oggetto",
                },
                hosePropRoll = {
                    description = "Correzione del rotolo in gradi per il modello del segmento manichetta.",
                    label = "Rotolo di oggetto",
                },
                hosePropsEnabled = {
                    description = "spawn visibile manichetta segmento oggetti durante l'utilizzo della lancia. idrante linee di alimentazione ancora rendering quando questo è disabilitato.",
                    label = "Rendere lancia manichetta oggetti",
                },
                hosePumpConnectDistance = {
                    description = "Distanza utilizzata per verificare se la pompa può disegnare acqua nelle vicinanze.",
                    label = "Distanza di connessione pompa",
                },
                hosePumpControlIdlePressure = {
                    description = "Pressione utilizzata quando viene creato un nuovo controllo della pompa.",
                    label = "Pressione iniziale",
                },
                hosePumpControlIdleRpm = {
                    description = "Pompa-motore visualizzato RPM alla pressione più bassa.",
                    label = "RPM al minimo",
                },
                hosePumpControlMaxPressure = {
                    description = "Massima pressione selezionabile sul pannello pompa migliorato.",
                    label = "Pressione massima",
                },
                hosePumpControlMaxRpm = {
                    description = "Motore a pompa visualizzato RPM alla massima pressione.",
                    label = "Massimo RPM",
                },
                hosePumpControlMinPressure = {
                    description = "PSI minimo richiesto per una presa per l'approvvigionamento idrico.",
                    label = "Pressione minima",
                },
                hosePumpControlPresetPressure = {
                    description = "Pressione selezionata dal pulsante preimpostato e utilizzata come riferimento di flusso normale.",
                    label = "Pressione preimpostata",
                },
                hosePumpControlPressureStep = {
                    description = "PSI aggiunto o rimosso da un pulsante premere.",
                    label = "Fase di pressione",
                },
                hosePumpControlTankFillLitersPerSecond = {
                    description = "L'acqua si sposta nel serbatoio del veicolo ogni secondo mentre Tank Fill è attivo.",
                    label = "Serbatoio pieno litri/secondo",
                },
                hosePumpEnabled = {
                    description = "Permettere la stesura della pompa da fonti di acqua naturali rilevate.",
                    label = "Abilita la pompa portatile",
                },
                hosePumpIntakeExtraLength = {
                    description = "Aspirazione supplementare manichetta lunghezza che si estende nella superficie dell'acqua rilevata.",
                    label = "Lunghezza supplementare di aspirazione",
                },
                hosePumpIntakeSubmergeDepth = {
                    description = "Profondità dell'endpoint di assunzione manichetta al di sotto della superficie dell'acqua rilevata.",
                    label = "Profondità di immersione di aspirazione",
                },
                hosePumpItem = {
                    description = "Articolo di inventario utilizzato per avviare la pompa portatile direttamente.",
                    label = "Nome dell'elemento pompa",
                },
                hosePumpItemEnabled = {
                    description = "Registra l'elemento della pompa configurato in modo da utilizzarlo avvia il posizionamento della pompa portatile.",
                    label = "Abilita l' uso dell' elemento della pompa",
                },
                hosePumpItemRequired = {
                    description = "I giocatori devono trasportare l'elemento della pompa configurato prima di poter avviare un alimentatore portatile della pompa.",
                    label = "Richiede l'articolo della pompa",
                },
                hosePumpModel = {
                    description = "oggetto spawn è la pompa portatile per la stesura.",
                    label = "Modello pompa oggetto",
                },
                hosePumpNaturalWaterEnabled = {
                    description = "Permettere alla pompa portatile di disegnare da fiumi, laghi e altre superfici d'acqua rilevate.",
                    label = "Abilita la stesura dell'acqua naturale",
                },
                hosePumpPanelStyle = {
                    description = "Semplice utilizzo del comando automatico della pompa con una presa e una scarica. Migliorato consente controlli manuali con un massimo di due prese e quattro scariche.",
                    label = "Pannello pompa",
                    options = {
                        enhanced = "Pannello migliorato",
                        simple = "Pannello semplice",
                    },
                },
                hosePumpTargetDistance = {
                    description = "Massima distanza giocatore da un obiettivo di connessione della pompa configurato.",
                    label = "Distanza di interazione dell'obiettivo",
                },
                hosePumpTargetSize = {
                    description = "Raggio di ogni punto di attacco della pompa.",
                    label = "Raggio del punto di destinazione",
                },
                hosePumpWaterProbeDepth = {
                    description = "Quanto sotto ogni punto della sonda per cercare acqua.",
                    label = "Profondità sonda acqua pompa",
                },
                hosePumpWaterProbeDistance = {
                    description = "Quanto lontano intorno al punto di posizionamento della pompa per cercare l'acqua.",
                    label = "Distanza sonda acqua pompa",
                },
                hoseRadius = {
                    description = "Raggio reso dei segmenti manichetta.",
                    label = "Raggio manichetta",
                },
                hoseRelaxPasses = {
                    description = "Numero di passaggi di vincolo utilizzati per lisciare la manichetta per aggiornamento.",
                    label = "Passi relax",
                },
                hoseSegmentLength = {
                    description = "Distanza obiettivo tra punti simulati manichetta.",
                    label = "Lunghezza del segmento",
                },
                hoseSegmentOverlap = {
                    description = "Coppia visiva tra manichetta adiacente oggetti per nascondere le lacune.",
                    label = "Sovrapposizione del segmento",
                },
                hoseSegmentProp = {
                    description = "Modello utilizzato per rendere visibile ogni segmento manichetta.",
                    label = "Segmento oggetto",
                },
                hoseSegmentUpdateDistance = {
                    description = "Il minimo movimento prima della renderizzazione dei segmenti manichetta viene ricostruito.",
                    label = "Distanza di aggiornamento del segmento",
                },
                hoseUpdateInterval = {
                    description = "Intervallo di aggiornamento della simulazione manichetta in millisecondi.",
                    label = "Intervallo di aggiornamento",
                },
                hoseVehicleBendDistance = {
                    description = "Distanza utilizzata per formare la curva manichetta al veicolo.",
                    label = "Distanza di curvatura del veicolo",
                },
                hoseVehicleExitLength = {
                    description = "Lunghezza dritta manichetta leaVINg il collegamento del veicolo.",
                    label = "Lunghezza di uscita del veicolo",
                },
                hoseVehiclePumpBehaviorActiveRpm = {
                    description = "Valore RPM applicato mentre la pompa del veicolo è attiva. Utilizzare da 0.0 a 1.0.",
                    label = "RPM attivo",
                },
                hoseVehiclePumpBehaviorAmbientTemperature = {
                    description = "Temperatura della pompa più bassa e obiettivo di raffreddamento in gradi Celsius.",
                    label = "Temperatura ambiente",
                },
                hoseVehiclePumpBehaviorCavitationTemperatureGain = {
                    description = "Temperatura target aggiuntiva aggiunta a piena cavitazione.",
                    label = "Aumento della temperatura di cavitazione",
                },
                hoseVehiclePumpBehaviorCriticalTemperature = {
                    description = "Temperatura della pompa alla quale inizia l'allarme critico.",
                    label = "Temperatura critica",
                },
                hoseVehiclePumpBehaviorDamageTemperature = {
                    description = "Temperatura della pompa al di sopra della quale inizia il danno al motore.",
                    label = "Temperatura dei danni",
                },
                hoseVehiclePumpBehaviorDryRunDamagePerSecond = {
                    description = "Danni alla salute del motore applicati ogni secondo durante il funzionamento a secco.",
                    label = "Danno alla marcia a secco/secondo",
                },
                hoseVehiclePumpBehaviorDryRunTemperature = {
                    description = "Temperatura obiettivo mentre la pompa funziona senza acqua.",
                    label = "Temperatura di funzionamento a secco",
                },
                hoseVehiclePumpBehaviorEnabled = {
                    description = "Mantiene i motori in funzione e controlla la pompa RPM mentre i sistemi manichetta utilizzano il veicolo.",
                    label = "Abilita il comportamento della pompa",
                },
                hoseVehiclePumpBehaviorEngagementMaxSpeed = {
                    description = "Velocità massima del veicolo in metri al secondo alla quale la pompa può essere attivata.",
                    label = "Velocità massima di coinvolgimento",
                },
                hoseVehiclePumpBehaviorEngineDamageEnabled = {
                    description = "Consente al surriscaldamento e al funzionamento a secco di danneggiare il motore. Disattivato per impostazione predefinita; gli avvisi della pompa restano attivi.",
                    label = "Danni al motore causati dalla pompa",
                },
                hoseVehiclePumpBehaviorFuelPercentPerMinute = {
                    description = "Percentuale di carburante di base consumata al minuto mentre la pompa funziona.",
                    label = "Percentuale di carburante/minuto",
                },
                hoseVehiclePumpBehaviorImmobilizePumpVehicles = {
                    description = "Previene il veicolo della pompa da driVINg mentre la sua pompa è attiva.",
                    label = "Bloccare il veicolo durante il pompaggio",
                },
                hoseVehiclePumpBehaviorImmobilizeTransferVehicles = {
                    description = "Previene i veicoli da driVINg mentre è collegata una linea di trasferimento veicolo-veicolo.",
                    label = "Veicoli per il trasferimento di serrature",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringPump = {
                    description = "Mantiene acceso il motore del veicolo sorgente durante lo spruzzo a mano manichette o cannoni ad acqua.",
                    label = "Motore acceso durante la spruzzatura",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringTransfer = {
                    description = "Mantiene i motori del veicolo in funzione mentre una linea di trasferimento è collegata.",
                    label = "Motore acceso durante il trasferimento",
                },
                hoseVehiclePumpBehaviorKeepEngineOnWhenAbandoned = {
                    description = "Mantiene i veicoli a pompa configurati in funzione dopo l'uscita del conducente.",
                    label = "Tenere il motore acceso quando abbandonato",
                },
                hoseVehiclePumpBehaviorMaxEngineDamagePerSecond = {
                    description = "Massimo danno motore-salute applicato ogni secondo dallo stress della pompa.",
                    label = "Danno massimo/secondo",
                },
                hoseVehiclePumpBehaviorOverloadWarningLoad = {
                    description = "Rapporto carico motore al quale inizia l'avvertimento di sovraccarico.",
                    label = "Carico di avviso di sovraccarico",
                },
                hoseVehiclePumpBehaviorRpmEnabled = {
                    description = "Solleva veicolo RPM mentre una mano manichetta o cannone acqua spruzza da quel veicolo.",
                    label = "Alzare la pompa RPM",
                },
                hoseVehiclePumpBehaviorThermalResponse = {
                    description = "Come la temperatura della pompa si muove rapidamente verso il suo obiettivo calcolato.",
                    label = "Risposta termica",
                },
                hoseVehiclePumpBehaviorUpdateMs = {
                    description = "Quante volte il client ricarica motore, blocco e comportamento RPM in millisecondi.",
                    label = "Intervallo di aggiornamento",
                },
                hoseVehiclePumpBehaviorWarningTemperature = {
                    description = "Temperatura della pompa alla quale inizia l'allarme di surriscaldamento.",
                    label = "Temperatura di avvertimento",
                },
                hoseVehiclePumpHydraulicsCavitationStartRatio = {
                    description = "Quota della capacità della fonte alla quale inizia la cavitazione.",
                    label = "Rapporto di inizio della cavitazione",
                },
                hoseVehiclePumpHydraulicsFrictionLossPsiPerTenMeters = {
                    description = "Perdita di pressione applicata per dieci metri di manichetta attivo.",
                    label = "Perdita di attrito PSI per 10 m",
                },
                hoseVehiclePumpHydraulicsHydrantIntakePressure = {
                    description = "Pressione di aspirazione in PSI fornita da idrante.",
                    label = "Pressione di aspirazione idrante",
                },
                hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond = {
                    description = "Portata massima dell'acqua fornita da un idrante in litri al secondo.",
                    label = "Portata dell'idrante",
                },
                hoseVehiclePumpHydraulicsPumpIntakePressure = {
                    description = "Pressione di aspirazione in PSI fornita da una pompa portatile.",
                    label = "Pressione di aspirazione della pompa",
                },
                hoseVehiclePumpHydraulicsPumpSupplyGpm = {
                    description = "Flusso massimo d'acqua fornito da una pompa portatile.",
                    label = "Alimentazione pompa GPM",
                },
                hoseVehiclePumpHydraulicsTankIntakePressure = {
                    description = "Pressione di aspirazione in PSI fornita dal serbatoio del veicolo.",
                    label = "Pressione di aspirazione del serbatoio",
                },
                hoseVehiclePumpHydraulicsTankSupplyGpm = {
                    description = "Flusso massimo d'acqua fornito dal serbatoio del veicolo.",
                    label = "GPM di alimentazione del serbatoio",
                },
                hoseVehicleTransferAllowExternalSource = {
                    description = "Un veicolo sorgente collegato a idrante o all'alimentazione della pompa può riempire l'obiettivo senza drenare il proprio serbatoio.",
                    label = "Consenti sorgente esterna",
                },
                hoseVehicleTransferConnectDistance = {
                    description = "Distanza massima dal giocatore per collegare una linea di trasferimento.",
                    label = "Distanza di connessione",
                },
                hoseVehicleTransferDisconnectWhenSourceEmpty = {
                    description = "Disconnetti automaticamente il trasferimento quando il serbatoio sorgente è vuoto.",
                    label = "Ferma quando la sorgente è vuota",
                },
                hoseVehicleTransferDisconnectWhenTargetFull = {
                    description = "Disconnetti automaticamente il trasferimento quando il serbatoio di destinazione è pieno.",
                    label = "Ferma quando l'obiettivo è pieno",
                },
                hoseVehicleTransferEnabled = {
                    description = "Consente a una linea manichetta di trasferire l'acqua da un carro armato ad un altro.",
                    label = "Abilita il trasferimento del veicolo",
                },
                hoseVehicleTransferLitersPerSecond = {
                    description = "L'acqua si spostava dal veicolo sorgente al veicolo bersaglio ogni secondo.",
                    label = "Litri al secondo",
                },
                hoseVehicleTransferMaxLength = {
                    description = "Distanza massima consentita tra i due veicoli collegati.",
                    label = "Lunghezza massima della linea",
                },
                hoseVehicleTransferRequireOnDuty = {
                    description = "Solo su servizio vigili del fuoco può creare trasferimenti d'acqua di veicoli.",
                    label = "Richiedi servizio attivo",
                },
                hoseVehicleTransferSourceDirectionX = {
                    description = "Configures: Direzione sorgente X.",
                    label = "Direzione sorgente X",
                },
                hoseVehicleTransferSourceDirectionY = {
                    description = "Configures: Direzione sorgente Y.",
                    label = "Direzione sorgente Y",
                },
                hoseVehicleTransferSourceDirectionZ = {
                    description = "Configures: Direzione sorgente Z.",
                    label = "Direzione sorgente Z",
                },
                hoseVehicleTransferSourceOffsetX = {
                    description = "Configures: Sorgente X.",
                    label = "Sorgente X",
                },
                hoseVehicleTransferSourceOffsetY = {
                    description = "Configures: Fonte Y.",
                    label = "Fonte Y",
                },
                hoseVehicleTransferSourceOffsetZ = {
                    description = "Configures: Fonte Z.",
                    label = "Fonte Z",
                },
                hoseVehicleTransferTargetDirectionX = {
                    description = "Configures: Direzione di destinazione X.",
                    label = "Direzione di destinazione X",
                },
                hoseVehicleTransferTargetDirectionY = {
                    description = "Configures: Direzione di destinazione Y.",
                    label = "Direzione di destinazione Y",
                },
                hoseVehicleTransferTargetDirectionZ = {
                    description = "Configures: Direzione di destinazione Z.",
                    label = "Direzione di destinazione Z",
                },
                hoseVehicleTransferTargetOffsetX = {
                    description = "Configures: Obiettivo X.",
                    label = "Obiettivo X",
                },
                hoseVehicleTransferTargetOffsetY = {
                    description = "Configures: Obiettivo Y.",
                    label = "Obiettivo Y",
                },
                hoseVehicleTransferTargetOffsetZ = {
                    description = "Configures: Obiettivo Z.",
                    label = "Obiettivo Z",
                },
                hoseVehicleTransferTickMs = {
                    description = "Intervallo di aggiornamento del server per linee di trasferimento attive.",
                    label = "Segnatura di trasferimento ms",
                },
                hoseVehicles = {
                    description = "Modelli di veicoli con pannelli pompa, serbatoi e connessioni di aspirazione e scarico configurabili singolarmente.",
                    itemLabel = "Veicolo",
                    label = "Veicoli a pompa",
                },
                hoseWaterLitersPerSecond = {
                    description = "Tasso di scarico del serbatoio dell'acqua durante la spruzzatura dell'acqua senza alimentazione esterna.",
                    label = "Litri d'acqua al secondo",
                },
                hydrantConnection = {
                    description = "Configures: Collegamento idrante.",
                    label = "Collegamento idrante",
                },
                hydrantRx = {
                    description = "Configures: idrante RX.",
                    label = "idrante RX",
                },
                hydrantRy = {
                    description = "Configures: idrante RY.",
                    label = "idrante RY",
                },
                hydrantRz = {
                    description = "Configures: idrante RZ.",
                    label = "idrante RZ",
                },
                hydrantX = {
                    description = "Configures: idrante X.",
                    label = "idrante X",
                },
                hydrantY = {
                    description = "Configures: idrante Y.",
                    label = "idrante Y",
                },
                hydrantZ = {
                    description = "Configures: idrante Z.",
                    label = "idrante Z",
                },
                igniteDistance = {
                    description = "Quanto il giocatore deve essere vicino a questa fonte di accensione per piazzare l'accensione.",
                    label = "Distanza dall'accensione dell'impianto",
                },
                interiorExtinguishersAllowedJobs = {
                    description = "Lascia vuoto per consentire tutti i lavori. Disattiva il requisito di servizio per permettere a chiunque di prelevare e rifornire gli estintori.",
                    itemLabel = "Lavoro",
                    label = "Lavori ammessi",
                },
                interiorExtinguishersEmptyMountHeadingOffset = {
                    description = "Correzione dello sbadiglio specifica del modello applicata al supporto vuoto.",
                    label = "Correzione del monte orientamento",
                },
                interiorExtinguishersEmptyMountModel = {
                    description = "oggetto personalizzato visualizzato nella posizione originale mentre manca l'estintore.",
                    label = "Modello di montaggio vuoto",
                },
                interiorExtinguishersEmptyMountOffsetX = {
                    description = "Spostamento locale sinistro/destro dopo aver applicato la rotazione oggetto. Valori negativi lo spostano a sinistra.",
                    label = "Spostamento del supporto X",
                },
                interiorExtinguishersEmptyMountOffsetY = {
                    description = "Spostamento locale in avanti/indietro dopo l'applicazione della rotazione oggetto.",
                    label = "Spostamento del supporto Y",
                },
                interiorExtinguishersEmptyMountOffsetZ = {
                    description = "Spostamento verticale locale dopo aver applicato la rotazione oggetto.",
                    label = "Spostamento del supporto Z",
                },
                interiorExtinguishersEmptyMountStreamDistance = {
                    description = "Distanza entro la quale vengono caricati gli estintori vuoti.",
                    label = "Distanza dello stream di montaggio vuota",
                },
                interiorExtinguishersEmptyThresholdPercent = {
                    description = "Riempire la percentuale a o sotto la quale un estintore è vuoto.",
                    label = "Soglia vuota percentuale",
                },
                interiorExtinguishersEnabled = {
                    description = "Permette a vigili del fuoco di prendere l'estintore configurato oggetti dagli interni.",
                    label = "Abilita il prelievo",
                },
                interiorExtinguishersFullAmmo = {
                    description = "Munizioni di armi crude che rappresentano il 100% di riempimento per inventari senza metadata percentuale.",
                    label = "Munizioni complete di estintore",
                },
                interiorExtinguishersInteractionDistance = {
                    description = "Massima distanza per premere E su un estintore oggetto.",
                    label = "Distanza di prelievo",
                },
                interiorExtinguishersItem = {
                    description = "Articolo o arma aggiunto quando un estintore è preso e consumato quando un supporto è rifornito.",
                    label = "Voce d'inventario",
                },
                interiorExtinguishersLabel = {
                    description = "Nome mostrato nelle interazioni pickup e restock.",
                    label = "Visualizza etichetta",
                },
                interiorExtinguishersMaintenanceAllowedJobs = {
                    description = "Ulteriori lavori hanno permesso di utilizzare azioni radiali estintore. I lavori antincendio sono sempre inclusi.",
                    itemLabel = "Lavoro",
                    label = "Lavori di radiale e manutenzione",
                },
                interiorExtinguishersMaintenanceEnabled = {
                    description = "Tracce vuote e state di estintore danneggiato.",
                    label = "Abilita gli stati di manutenzione",
                },
                interiorExtinguishersMaintenanceRequireOnDuty = {
                    description = "Richiede che i lavori di manutenzione siano in servizio.",
                    label = "Richiedi servizio attivo",
                },
                interiorExtinguishersModels = {
                    description = "Modelli di oggetti interni che possono essere presi.",
                    itemLabel = "Modello",
                    label = "Modelli di estintore oggetto",
                },
                interiorExtinguishersNoDutyJobs = {
                    description = "I lavori in questa lista possono prendere e rifornire estintori senza essere in servizio.",
                    itemLabel = "Lavoro",
                    label = "Lavori senza servizio",
                },
                interiorExtinguishersPickupDurationMs = {
                    description = "Animazione e durata di avanzamento prima che l'estintore sia preso.",
                    label = "Durata del prelievo ms",
                },
                interiorExtinguishersPlacementAllowedJobs = {
                    description = "Lasciare vuoto per utilizzare i lavori generali estintore o tutti i lavori di Firejob configurati.",
                    itemLabel = "Lavoro",
                    label = "Posti di lavoro",
                },
                interiorExtinguishersPlacementConsumeItem = {
                    description = "Rimuove esattamente un kit di montaggio solo dopo il posizionamento riesce.",
                    label = "Consumare la voce sul collocamento",
                },
                interiorExtinguishersPlacementDynamic = {
                    description = "Abilita la fisica per l'estintore posizionato.",
                    label = "oggetto dinamico",
                },
                interiorExtinguishersPlacementEnabled = {
                    description = "Lasciare autorizzato vigili del fuoco mettere kit di montaggio estintore nel mondo.",
                    label = "Abilita posizionamento",
                },
                interiorExtinguishersPlacementItem = {
                    description = "Inventario che inizia il posizionamento di un kit completo di montaggio estintore.",
                    label = "Elemento di posizionamento",
                },
                interiorExtinguishersPlacementModel = {
                    description = "Modello di oggetto utilizzato per estintori posizionati liberamente.",
                    label = "Modello oggetto posizionato",
                },
                interiorExtinguishersPlacementPickupDistance = {
                    description = "Distanza massima per remoVINg un estintore posto.",
                    label = "Distanza di prelievo",
                },
                interiorExtinguishersPlacementRequireOnDuty = {
                    description = "Solo su servizio vigili del fuoco può posizionare e rimuovere estintori.",
                    label = "Richiede servizio per il posizionamento",
                },
                interiorExtinguishersPlacementReturnItem = {
                    description = "Restituisce il kit di montaggio quando viene rimosso il suo oggetto posto.",
                    label = "Restituisci l'elemento al ritiro",
                },
                interiorExtinguishersPlacementStreamDistance = {
                    description = "Distanza entro la quale viene caricato l'estintore posto.",
                    label = "Distanza flusso",
                },
                interiorExtinguishersPlacementWallEnabled = {
                    description = "Allinea l'estintore con superfici verticali selezionate dal raycast di posizionamento.",
                    label = "Abilita posizionamento a parete",
                },
                interiorExtinguishersPlacementWallHeadingOffset = {
                    description = "Ruota l'estintore attorno al suo asse verticale dopo l'allineamento della parete.",
                    label = "Correzione orientamento da parete",
                },
                interiorExtinguishersPlacementWallOffset = {
                    description = "Sposta l'estintore lontano dalla parete selezionata lungo la sua superficie normale.",
                    label = "Distanza del muro",
                },
                interiorExtinguishersPlacementZOffset = {
                    description = "Spostamento verticale applicato all'estintore posto.",
                    label = "Spostamento Z del terreno",
                },
                interiorExtinguishersRequireOnDuty = {
                    description = "Consente solo ai membri del servizio di un lavoro consentito di prendere e rifornire estintori.",
                    label = "Richiedi servizio attivo",
                },
                interiorExtinguishersRestoreDistance = {
                    description = "Distanza massima da un montaggio preso mentre si preme E con un elemento estintore.",
                    label = "Distanza di rifornimento",
                },
                interiorExtinguishersRestoreDurationMs = {
                    description = "Animazione e durata di avanzamento prima che l'estintore viene consumato.",
                    label = "Durata del rifornimento ms",
                },
                interiorExtinguishersScanDistance = {
                    description = "Raggio di scansione degli oggetti intorno al giocatore.",
                    label = "Distanza di scansione",
                },
                label = {
                    description = "Configures: Etichetta.",
                    label = "Etichetta",
                },
                lighterAnimationDict = {
                    description = "dizionario animazione utilizzato durante la piantatura dell'accensione.",
                    label = "Animazione dict",
                },
                lighterAnimationDurationMs = {
                    description = "Per quanto tempo dura l'animazione e l'azione di avanzamento dell'accensione prima che l'accensione sia piantata.",
                    label = "Durata dell'animazione ms",
                },
                lighterAnimationFlag = {
                    description = "Bandiera TaskPlayAnim usata per l'animazione di accensione.",
                    label = "Flag animazione",
                },
                lighterAnimationName = {
                    description = "Clip di animazione utilizzato durante la piantatura dell'accensione.",
                    label = "Nome animazione",
                },
                lighterConsumeItem = {
                    description = "Consuma l'elemento accendino configurato dopo un trigger di accensione riuscito.",
                    label = "Consumare elemento accendino",
                },
                lighterCooldownSeconds = {
                    description = "tempo di attesa condiviso tra accendino usi per oggetti e veicoli.",
                    label = "Secondi tempo di attesa",
                },
                lighterIgniteDelaySeconds = {
                    description = "Ritardo dopo accensione riuscita prima dell'incendio effettivo, giVINg il giocatore tempo di correre.",
                    label = "Secondi di ritardo di accensione",
                },
                lighterItem = {
                    description = "Elemento di inventario utilizzato per l'installazione di ignizioni su veicoli e altre fonti di ignizione configurate.",
                    label = "Elemento accendino",
                },
                lighterVehicleEnabled = {
                    description = "Lasciare che l'elemento accendino accenda i veicoli nelle vicinanze.",
                    label = "Abilitare l'accensione del veicolo",
                },
                lighterVehicleMaxDistance = {
                    description = "Distanza massima da un veicolo per l'impianto dell'accensione.",
                    label = "Distanza di accensione del veicolo",
                },
                lighterVehicleOffsetX = {
                    description = "Spostamento X locale utilizzato per la posizione di incendio del veicolo piantato.",
                    label = "Spegnimento del fuoco del veicolo X",
                },
                lighterVehicleOffsetY = {
                    description = "Spostamento Y locale usato per la posizione di incendio del veicolo piantato.",
                    label = "Spostamento dell'incendio del veicolo Y",
                },
                lighterVehicleOffsetZ = {
                    description = "Spostamento Z locale utilizzato per la posizione di incendio del veicolo piantato.",
                    label = "Spostamento del fuoco del veicolo Z",
                },
                lighterVehicleRequireOnDuty = {
                    description = "Consenti solo l'accensione del veicolo mentre il giocatore è in servizio nel lavoro di fuoco configurato.",
                    label = "Richiede un lavoro antincendio servizio",
                },
                lighterVehicleRequiredJobs = {
                    description = "Se riempito, l'accensione del veicolo funziona solo mentre la quantità configurata di lavori specifici è in linea.",
                    itemLabel = "Lavoro",
                    label = "Lavori online richiesti",
                },
                lighterVehicleSourceScale = {
                    description = "Moltiplicatore di scala applicato agli incendi che vengono avviati con il accendino sui veicoli.",
                    label = "Scala antincendio del veicolo",
                },
                npcFireReactionsCooldownMs = {
                    description = "Ritardo prima dello stesso NPC è permesso di reagire nuovamente ad un incendio.",
                    label = "NPC reaction tempo di attesa ms",
                },
                npcFireReactionsDurationMs = {
                    description = "Quanto dura una reazione attiva NPC prima della sua scadenza.",
                    label = "Durata della reazione NPC ms",
                },
                npcFireReactionsEnabled = {
                    description = "Permette ai civili ambientali vicini di andare nel panico o filmare incendi attivi.",
                    label = "Abilita reazioni di fuoco NPC",
                },
                npcFireReactionsFilmChance = {
                    description = "Possibilità da 0.0 a 1.0 che un film NPC adatto invece di non fare nulla.",
                    label = "Possibilità di ripresa telefonica",
                },
                npcFireReactionsFilmEnabled = {
                    description = "Lascia che i civili adatti si fermino e registrino gli incendi nelle vicinanze con il loro telefono.",
                    label = "Abilita le riprese telefoniche",
                },
                npcFireReactionsFilmRadius = {
                    description = "Gli NPC all'interno di questa distanza possono filmare il fuoco con il loro telefono.",
                    label = "Raggio di ripresa NPC",
                },
                npcFireReactionsFleeDistance = {
                    description = "Quanto lontano gli NPC nel panico cercano di fuggire dal fuoco.",
                    label = "NPC distanza di fuga",
                },
                npcFireReactionsMaxTrackedPeds = {
                    description = "Limita quanti NPC possono essere controllati contemporaneamente dal sistema di reazione.",
                    label = "Massima reazione NPC",
                },
                npcFireReactionsPanicEnabled = {
                    description = "Lascia i civili vicini nel panico e scappa quando un incendio si avvicina troppo.",
                    label = "Abilita le reazioni di panico",
                },
                npcFireReactionsPanicRadius = {
                    description = "Gli NPC all'interno di questa distanza preferiscono le reazioni di panico e fuga.",
                    label = "Raggio di panico NPC",
                },
                npcFireReactionsRadius = {
                    description = "Distanza massima da un incendio a cui un NPC può reagire.",
                    label = "Raggio di reazione NPC",
                },
                npcFireReactionsUpdateInterval = {
                    description = "Quante volte il sistema scansiona gli NPC adatti intorno agli incendi attivi.",
                    label = "Intervallo di aggiornamento della reazione NPC ms",
                },
                npcRescueAnimalEntrapmentEnabled = {
                    description = "Configures: Intrappolamento di animali.",
                    label = "Intrappolamento di animali",
                },
                npcRescueAnimalEntrapmentPanicChance = {
                    description = "Configures: Intrappolato animale panico possibilità.",
                    label = "Intrappolato animale panico possibilità",
                },
                npcRescueAnimalTreeEnabled = {
                    description = "Configures: Animali in albero / altezza.",
                    label = "Animali in albero / altezza",
                },
                npcRescueAnimalTreePanicChance = {
                    description = "Configures: Evento di panico per gli animali.",
                    label = "Evento di panico per gli animali",
                },
                npcRescueAnimalWaterEnabled = {
                    description = "Configures: Salvataggio delle acque animali.",
                    label = "Salvataggio delle acque animali",
                },
                npcRescueAnimalWaterPanicChance = {
                    description = "Configures: Animali d'acqua possibilità di panico.",
                    label = "Animali d'acqua possibilità di panico",
                },
                npcRescueBicycleEnabled = {
                    description = "Configures: Incidente in bicicletta rurale.",
                    label = "Incidente in bicicletta rurale",
                },
                npcRescueDropoffRadius = {
                    description = "Distanza necessaria per consegnare un paziente salvato all'ambulanza.",
                    label = "Raggio di abbandono",
                },
                npcRescueEnabled = {
                    description = "Abilitare missioni di salvataggio NPC e flussi di attività.",
                    label = "Abilitato",
                },
                npcRescueFieldExtractionDurationMs = {
                    description = "Configures: Durata predefinita di salvataggio/estrazione ms.",
                    label = "Durata predefinita di salvataggio/estrazione ms",
                },
                npcRescueFieldStabilizationDurationMs = {
                    description = "Configures: Durata predefinita della stabilizzazione ms.",
                    label = "Durata predefinita della stabilizzazione ms",
                },
                npcRescueForestEnabled = {
                    description = "Configures: Lesioni forestali / salvataggio forestale.",
                    label = "Lesioni forestali / salvataggio forestale",
                },
                npcRescueRubbleEnabled = {
                    description = "Configures: Intrappolamento di macerie / soccorso delle macerie.",
                    label = "Intrappolamento di macerie / soccorso delle macerie",
                },
                npcRescueSearchRadius = {
                    description = "Raggio di ricerca utilizzato per le scene di soccorso non-veicolo.",
                    label = "Raggio di ricerca",
                },
                oilAbsorbentBrushRadius = {
                    description = "Raggio di ogni colpo di diffusione assorbente nello minigioco assorbente.",
                    label = "Raggio di diffusione",
                },
                oilAbsorbentGranulesPerMove = {
                    description = "Quanti granuli assorbenti sono spawnED per gradino di movimento valido.",
                    label = "Granuli per movimento",
                },
                oilAbsorbentMinigameEnabled = {
                    description = "Sostituisce la semplice azione di legame con lo minigioco di diffusione assorbente.",
                    label = "Abilita minigioco assorbente",
                },
                oilAbsorbentRequiredCoverage = {
                    description = "Quanto della fuoriuscita deve essere coperta prima che la fase assorbente abbia successo.",
                    label = "Copertura richiesta",
                },
                oilCleanupAbsorbentItem = {
                    description = "Articolo di inventario richiesto per la fase assorbente di pulizia dell'olio.",
                    label = "Elemento assorbente",
                },
                oilCleanupAllowedJobs = {
                    description = "I lavori in questa lista bianca possono pulire le fuoriuscite di petrolio oltre ai lavori configurati in questo Firejob.",
                    label = "Ulteriori lavori consentiti",
                },
                oilCleanupBindDurationMs = {
                    description = "Durata dell'avanzamento della caduta se il minigioco assorbente è disattivato.",
                    label = "Durata del legame Fallback ms",
                },
                oilCleanupBroomItem = {
                    description = "Inventario richiesto per spazzare una fuoriuscita limitata.",
                    label = "Elemento di spazzola",
                },
                oilCleanupConsumeAbsorbent = {
                    description = "Consuma un elemento assorbente su un uso riuscito.",
                    label = "Consumare assorbente",
                },
                oilCleanupConsumeBroom = {
                    description = "Consuma l'elemento di spazzatura configurato dopo la pulizia riuscita.",
                    label = "Consuma elemento di spazzatura",
                },
                oilCleanupRequireOnDuty = {
                    description = "Solo su servizio vigili del fuoco può pulire fuoriuscite di olio.",
                    label = "Richiedi servizio vigile del fuoco",
                },
                oilCleanupSweepDurationMs = {
                    description = "Durata dell'avanzamento in caduta se la spazzata minigioco è disabilitata.",
                    label = "Durata dello sweep di Fallback ms",
                },
                oilSpillsActive = {
                    description = "Live list of active oil spills with teleport and elimine actions.",
                    label = "Sversamenti attivi di petrolio",
                },
                oilSpillsDefaultIntensity = {
                    description = "Intensità di pericolo predefinita utilizzata per le fuoriuscite di petrolio di nuova creazione.",
                    label = "Intensità predefinita",
                },
                oilSpillsDeleteOnRestart = {
                    description = "Elimina le perdite di petrolio memorizzate all'inizio delle risorse invece di ripristinarle.",
                    label = "Elimina al riavvio",
                },
                oilSpillsEnabled = {
                    description = "Attiva le pozze d’olio, gli slittamenti e la pulizia. Le macchie automatiche dopo una collisione o dovute all’usura richiedono Sky Mechanic o un’altra risorsa collegata.",
                    label = "Abilita il sistema delle macchie d’olio",
                },
                oilSpillsInteractionDistance = {
                    description = "Distanza necessaria per interagire e ripulire una fuoriuscita.",
                    label = "Distanza d'interazione",
                },
                oilSpillsLifetimeMinutes = {
                    description = "Per quanto tempo le fuoriuscite di petrolio non rimovibili rimangono attive prima della scadenza.",
                    label = "Minuti di vita",
                },
                oilSpillsMaxActive = {
                    description = "Numero massimo di perdite di petrolio sincronizzate che possono esistere in una sola volta.",
                    label = "Sversamenti massimi attivi",
                },
                oilSpillsObjectGroundOffset = {
                    description = "Spostamento a terra applicato alla fuoriuscita oggetti per adattarsi meglio alla superficie stradale.",
                    label = "Spostamento del suolo dell'oggetto",
                },
                oilSpillsRemoveBelow = {
                    description = "Le gocce vengono rimosse automaticamente una volta che la loro intensità scende al di sotto di questo valore.",
                    label = "Rimuovi sotto l'intensità",
                },
                oilSpillsResetIds = {
                    buttonLabel = "Reimposta gli ID",
                    description = "Rinumera tutte le fuoriuscite di olio attivo da 1 senza lacune e sincronizza ogni giocatore.",
                    label = "Reimposta gli ID di fuoriuscita dell'olio",
                },
                oilSpillsSlipRadius = {
                    description = "Raggio in cui i giocatori e peds possono scivolare sulla fuoriuscita.",
                    label = "Raggio di scorrimento",
                },
                oilSweepBrushRadius = {
                    description = "Raggio intorno al colpo di scopa che contribuisce a spazzare il progresso.",
                    label = "Raggio di scorrimento",
                },
                oilSweepMaxSidewaysRatio = {
                    description = "Rapporto massimo di movimento laterale consentito prima che un colpo di spazzatura venga ignorato.",
                    label = "Tolleranza laterale",
                },
                oilSweepMinStrokeDistance = {
                    description = "Distanza minima del cursore necessaria prima che un colpo di spazzatura possa aggiungere progresso.",
                    label = "Distanza minima di corsa",
                },
                oilSweepMinUpwardDelta = {
                    description = "Minimo movimento verso l'alto richiesto per un colpo di scopa valido.",
                    label = "Movimento minimo verso l'alto",
                },
                oilSweepMinigameEnabled = {
                    description = "Sostituisce la semplice barra di avanzamento spazzatura con la scopa minigioco.",
                    label = "Abilita spazzata minigioco",
                },
                oilSweepRequiredProgress = {
                    description = "È necessario procedere da 0.0 a 1.0 prima di pulire la fuoriuscita legata.",
                    label = "Avanzamento dello spazzamento richiesto",
                },
                oilSweepToolWidth = {
                    description = "Larghezza immagine della scopa visualizzata nella spazzatura minigioco.",
                    label = "Larghezza immagine scopa",
                },
                playerEntrapmentAllowOffDuty = {
                    description = "Conta anche la controparte configurata off-servizio di un lavoro richiesto quando si controlla il minimo personale online.",
                    label = "Conteggio lavori off-servizio",
                },
                playerEntrapmentAutoReleaseWhenRepaired = {
                    description = "Configures: Rilasciare quando riparato.",
                    label = "Rilasciare quando riparato",
                },
                playerEntrapmentBaseChance = {
                    description = "Configures: Possibilità di base.",
                    label = "Possibilità di base",
                },
                playerEntrapmentCooldownSeconds = {
                    description = "Configures: Secondi tempo di attesa.",
                    label = "Secondi tempo di attesa",
                },
                playerEntrapmentDoorOverviewEnabled = {
                    description = "Mostra un piccolo veicolo con porte di uscita danneggiate, aperte e utilizzabili nell'HUD intrappolato.",
                    label = "Mostra panoramica delle porte",
                },
                playerEntrapmentEnabled = {
                    description = "I giocatori possono rimanere intrappolati dopo un danno sufficiente del veicolo o un ribaltamento.",
                    label = "Abilita intrappolamento del giocatore",
                },
                playerEntrapmentHudEnabled = {
                    description = "Configures: Mostra HUD intrappolato.",
                    label = "Mostra HUD intrappolato",
                },
                playerEntrapmentMinBodyHealthLoss = {
                    description = "Salute del corpo minima persa in una collisione prima che intrappolamento può innescare. Valori inferiori innescare più facilmente.",
                    label = "Danni corporei minimi",
                },
                playerEntrapmentMinEngineHealthLoss = {
                    description = "La salute minima del motore persa in una collisione prima che l'intrappolamento possa innescare.",
                    label = "Danni minimi al motore",
                },
                playerEntrapmentPreventExit = {
                    description = "Configures: Block leaVINg veicolo.",
                    label = "Block leaVINg veicolo",
                },
                playerEntrapmentReleaseOnAnyDoor = {
                    description = "Configures: Rilasciare dopo ogni porta aperta.",
                    label = "Rilasciare dopo ogni porta aperta",
                },
                playerEntrapmentRepairedBodyHealthThreshold = {
                    description = "Configures: Soglia del corpo di riparazione.",
                    label = "Soglia del corpo di riparazione",
                },
                playerEntrapmentRepairedEngineHealthThreshold = {
                    description = "Configures: Soglia del motore di riparazione.",
                    label = "Soglia del motore di riparazione",
                },
                playerEntrapmentRepairedMaxRoll = {
                    description = "Configures: Riparazione max rotolo.",
                    label = "Riparazione max rotolo",
                },
                playerEntrapmentRequiredJobs = {
                    description = "Se le voci sono presenti qui, l'intrappolamento del veicolo attiva solo mentre la quantità configurata di lavori specifici è online.",
                    itemLabel = "Lavoro",
                    label = "Lavori online richiesti",
                },
                playerEntrapmentRolloverBonusChance = {
                    description = "Configures: Possibilità di rollover bonus.",
                    label = "Possibilità di rollover bonus",
                },
                playerEntrapmentRolloverMinRoll = {
                    description = "Configures: Soglia di ribaltamento.",
                    label = "Soglia di ribaltamento",
                },
                propIgnitionDuplicateDistance = {
                    description = "Impedisce di piantare un'altra accensione troppo vicina a un incendio esistente.",
                    label = "Distanza minima dal fuoco esistente",
                },
                propIgnitionEnabled = {
                    description = "Consente di utilizzare oggetti selezionati e sorgenti di accensione fisse per le ignizioni piantate con lo accendino.",
                    label = "Abilita punti di accensione oggetto",
                },
                propIgnitionHighlightEnabled = {
                    description = "Contrassegna le sorgenti di accensione corrispondenti con un contorno mentre la ricerca accendino è attiva.",
                    label = "Evidenziare i punti di accensione",
                },
                propIgnitionMaxActiveFires = {
                    description = "Numero massimo di incendi attivi che possono esistere immediatamente da questi punti di accensione.",
                    label = "Fuochi massimi di oggetti attivi",
                },
                propIgnitionProps = {
                    description = "Modelli di oggetti o sorgenti fisse di accensione in cui si può utilizzare un'accensione a pianta.",
                    itemLabel = "Fonte di accensione",
                    label = "Possibili fonti di accensione",
                },
                propIgnitionRequireLineOfSight = {
                    description = "Possono essere evidenziati e utilizzati solo punti di accensione con una linea di visuale chiara.",
                    label = "Richiede una linea di visuale chiara",
                },
                propIgnitionScanDistance = {
                    description = "Raggio in cui sono rilevati eventuali punti di accensione nella zona.",
                    label = "Raggio di ricerca dell'accensione",
                },
                propIgnitionScanDurationMs = {
                    description = "Per quanto tempo i punti di accensione rilevati rimangono evidenziati prima che la ricerca si chiuda automaticamente.",
                    label = "Evidenziare la durata ms",
                },
                pumpDischargeCount = {
                    description = "Configures: Scarichi di pompa.",
                    label = "Scarichi di pompa",
                },
                rescueCushionAllowedJobs = {
                    description = "Lasciare vuoto per consentire a tutti i lavori di fuoco configurati di posizionare l'oggetto cuscino di salvataggio.",
                    itemLabel = "Lavoro",
                    label = "Lavori ammessi",
                },
                rescueCushionConsumeItem = {
                    description = "Rimuove un oggetto cuscino di salvataggio dall'inventario quando è posizionato.",
                    label = "Consumare l'elemento sul posto",
                },
                rescueCushionEnabled = {
                    description = "Attiva o disattiva completamente il sistema di cuscini di salvataggio.",
                    label = "Abilita cuscino di salvataggio",
                },
                rescueCushionItem = {
                    description = "Elemento di inventario usato per posizionare il cuscino di salvataggio.",
                    label = "Nome dell'elemento",
                },
                rescueCushionLabel = {
                    description = "Visualizza il nome mostrato per il cuscino di salvataggio posto oggetto.",
                    label = "Etichetta",
                },
                rescueCushionLandingHeight = {
                    description = "Differenza massima di altezza sopra il cuscino al quale si applica ancora la protezione dall'atterraggio.",
                    label = "Altezza di atterraggio",
                },
                rescueCushionLandingRadius = {
                    description = "Raggio orizzontale intorno al cuscino in cui i giocatori in caduta sono protetti.",
                    label = "Raggio di atterraggio",
                },
                rescueCushionModel = {
                    description = "Modello mondiale oggetto che ottiene spawn quando il cuscino è posizionato.",
                    label = "Modello oggetto",
                },
                rescueCushionPickupDistance = {
                    description = "Quanto vicino un giocatore deve essere per raccogliere il cuscino di salvataggio posto di back up.",
                    label = "Distanza di prelievo",
                },
                rescueCushionRequireOnDuty = {
                    description = "Consente solo allo servizio vigili del fuoco di posizionare l'elemento cuscino di salvataggio.",
                    label = "Richiedi servizio attivo",
                },
                rescueCushionReturnItemOnRemove = {
                    description = "Restituisce l'elemento configurato al giocatore quando il cuscino posizionato viene raccolto.",
                    label = "Restituisci l'oggetto al pickup",
                },
                rescueCushionStreamDistance = {
                    description = "Distanza alla quale il cuscino di soccorso posto oggetto inizia lo streaming ai giocatori vicini.",
                    label = "Distanza flusso",
                },
                rescueCushionZOffset = {
                    description = "Spostamento verticale applicato al cuscino di soccorso spawn oggetto.",
                    label = "Spostamento posizione Z",
                },
                rx = {
                    description = "Configurazioni: RX.",
                    label = "RX",
                },
                ry = {
                    description = "Configurazioni: RY.",
                    label = "RY",
                },
                rz = {
                    description = "Configurazioni: RZ.",
                    label = "RZ",
                },
                scbaHudPosition = {
                    description = "Posizione del manometro SCBA HUD.",
                    label = "Posizione manometrica",
                },
                scenarioAutomaticMissions = {
                    description = "Abilita l'avvio automatico per missione, imposta il numero richiesto di membri in servizio, scegli i lavori conteggiati e quelli che ricevono il dispatch. Gli elenchi vuoti usano i lavori globali in servizio o del dispatch.",
                    itemLabel = "Missione",
                    label = "Le missioni disponibili",
                },
                scenarioCreatorAllowRescue = {
                    description = "Lasciate che il creatore della missione ponga compiti di salvataggio di pazienti e animali.",
                    label = "Scheda di salvataggio",
                },
                scenarioCreatorAllowVehicleFire = {
                    description = "Permetti al creatore della missione di posizionare veicoli in fiamme configurati.",
                    label = "Scheda antincendio del veicolo",
                },
                scenarioCreatorEnabled = {
                    description = "Abilitare la missione di fuoco creatore e hub strumenti.",
                    label = "Abilitato",
                },
                scenarioCreatorOpenMenu = {
                    buttonLabel = "Creatore di missione aperto",
                    description = "Aprire il menu Sky Fire Mission Creator e chiudere il Job Configurator.",
                    label = "Menu Creatore missione",
                    unsavedTooltip = "Salva prima",
                },
                scenarioDispatchEnabled = {
                    description = "Crea uno sky_jobs_base centrale operativa quando viene avviata una missione.",
                    label = "Invia centrale operativa",
                },
                scenarioDispatchJobs = {
                    description = "Utilizzati quando una missione non ha lavori destinatari specifici per il dispatch.",
                    itemLabel = "Lavoro",
                    label = "Lavori mirati centrale operativa",
                },
                scenarioRandomChance = {
                    description = "Possibilità per intervallo da 0.0 a 1.0.",
                    label = "Possibilità di attivazione",
                },
                scenarioRandomEnabled = {
                    description = "Avvia automaticamente una missione abilitata dopo l'intervallo configurato.",
                    label = "Abilita le missioni automatiche",
                },
                scenarioRandomSelectionMode = {
                    description = "La rotazione casuale avvia una volta ogni missione attualmente idonea prima di ripeterne una. La scelta puramente casuale consente ripetizioni.",
                    label = "Selezione missioni",
                    options = {
                        rotation = "Rotazione casuale",
                        random = "Casuale puro",
                    },
                },
                scenarioRandomIntervalMax = {
                    description = "Configures: Intervallo massimo minuti.",
                    label = "Intervallo massimo minuti",
                },
                scenarioRandomIntervalMin = {
                    description = "Configures: Minuti minimi di intervallo.",
                    label = "Minuti minimi di intervallo",
                },
                scenarioRandomJobs = {
                    description = "I giocatori On-servizio in questi lavori contano quando la missione selezionata non ha lavori specifici.",
                    itemLabel = "Lavoro",
                    label = "Lavori servizio predefiniti",
                },
                scenarioRandomManualOnly = {
                    description = "Configures: Missioni solo manuali.",
                    label = "Missioni solo manuali",
                },
                smokePoisoningEnabled = {
                    description = "Attiva o disattiva l'esposizione al fumo, l'avvelenamento e i relativi effetti sul fumo.",
                    label = "Abilita avvelenamento da fumo",
                },
                smokeVehicleClosedExposureMultiplier = {
                    description = "Moltiplicatore di esposizione al fumo mentre tutte le finestre laterali rilevanti sono ancora intatte.",
                    label = "Moltiplicatore di fumo del veicolo chiuso",
                },
                smokeVehicleExposureMultiplier = {
                    description = "Moltiplicatore di esposizione al fumo una volta che un veicolo protetto perde la sua protezione del finestrino o per i tipi di veicoli non protetti.",
                    label = "Moltiplicatore di fumo del veicolo rotto o aperto",
                },
                smokeVehicleProtectAutomobiles = {
                    description = "Configures: Proteggere le automobili.",
                    label = "Proteggere le automobili",
                },
                smokeVehicleProtectBoats = {
                    description = "Configures: Proteggere le barche.",
                    label = "Proteggere le barche",
                },
                smokeVehicleProtectCycles = {
                    description = "Configures: Proteggere i cicli.",
                    label = "Proteggere i cicli",
                },
                smokeVehicleProtectHelicopters = {
                    description = "Configures: Proteggere gli elicotteri.",
                    label = "Proteggere gli elicotteri",
                },
                smokeVehicleProtectMotorcycles = {
                    description = "Configures: Proteggere i motocicli.",
                    label = "Proteggere i motocicli",
                },
                smokeVehicleProtectPlanes = {
                    description = "Configures: Proteggere gli aerei.",
                    label = "Proteggere gli aerei",
                },
                smokeVehicleProtectionEnabled = {
                    description = "Consente di configurare i tipi di veicolo che proteggono gli occupanti dal fumo mentre il veicolo rimane sigillato.",
                    label = "Abilitare la protezione contro il fumo del veicolo",
                },
                smokeWarningHudPosition = {
                    description = "Posizione della barra HUD avvelenamento da fumo.",
                    label = "Posizione della barra di avvelenamento da fumo",
                },
                societyRewardFireEnabled = {
                    description = "Interruttore globale per i pagamenti della società dopo che un fuoco standalone è spento.",
                    label = "Abilita i pagamenti del fuoco",
                },
                societyRewardFireJobs = {
                    description = "Configurare ogni lavoro separatamente con il proprio stato abilitato e importo di pagamento. Inserire il nome del lavoro; il suo conto società configurato riceve il denaro.",
                    itemLabel = "Lavoro",
                    label = "Lavori di ricompensa antincendio",
                },
                societyRewardFireScenarioEnabled = {
                    description = "Paga anche la ricompensa del fuoco quando viene spento un incendio appartenente a una missione del Creatore di missioni.",
                    label = "Paga gli incendi di missione",
                },
                societyRewardOilEnabled = {
                    description = "Interruttore globale per i pagamenti della società dopo una fuoriuscita di petrolio è pulito.",
                    label = "Abilita le vincite dell'olio",
                },
                societyRewardOilJobs = {
                    description = "Configurare ogni lavoro separatamente con il proprio stato abilitato e importo di pagamento. Inserire il nome del lavoro; il suo conto società configurato riceve il denaro.",
                    itemLabel = "Lavoro",
                    label = "Lavori di ricompensa petrolifera",
                },
                societyRewardOilScenarioEnabled = {
                    description = "Paga anche la ricompensa petrolifera quando viene ripulita una fuoriuscita di petrolio appartenente a una missione Mission Creator.",
                    label = "Pagare le fuoriuscite di petrolio della missione",
                },
                societyRewardRescueEnabled = {
                    description = "Cambio globale per i pagamenti della società dopo che un'operazione di salvataggio è completata.",
                    label = "Abilita le vincite di salvataggio",
                },
                societyRewardRescueJobs = {
                    description = "Configurare ogni lavoro separatamente con il proprio stato abilitato e importo di pagamento. Inserire il nome del lavoro; il suo conto società configurato riceve il denaro.",
                    itemLabel = "Lavoro",
                    label = "Lavori di ricompensa per il salvataggio",
                },
                societyRewardRescueScenarioEnabled = {
                    description = "Paga anche la ricompensa di salvataggio quando viene completata un'attività di salvataggio appartenente a una missione di Mission Creator.",
                    label = "Paga i salvataggi in missione",
                },
                societyRewardTreeEnabled = {
                    description = "Cambio globale per i pagamenti della società dopo che un albero caduto è eliminato.",
                    label = "Abilita le vincite degli alberi",
                },
                societyRewardTreeJobs = {
                    description = "Configurare ogni lavoro separatamente con il proprio stato abilitato e importo di pagamento. Inserire il nome del lavoro; il suo conto società configurato riceve il denaro.",
                    itemLabel = "Lavoro",
                    label = "Lavori di ricompensa degli alberi",
                },
                societyRewardTreeScenarioEnabled = {
                    description = "Paga anche la ricompensa dell'albero quando un albero caduto appartenente a una missione del Creatore di missioni viene ripulito.",
                    label = "Paga gli alberi delle missioni",
                },
                sourceScale = {
                    description = "Moltiplicatore di scala applicato al fuoco creato a questa fonte di accensione.",
                    label = "Dimensione del fuoco risultante",
                },
                textures = {
                    description = "Configures: Texture.",
                    label = "Texture",
                },
                trappedRescueAllowAnyDoor = {
                    description = "Configures: Permettere qualsiasi porta rimossa.",
                    label = "Permettere qualsiasi porta rimossa",
                },
                trappedRescueAllowCarry = {
                    description = "Configures: Consentire il trasporto della persona salvata.",
                    label = "Consentire il trasporto della persona salvata",
                },
                trappedRescueAllowDrop = {
                    description = "Configures: Permetti di mettere giù la persona.",
                    label = "Permetti di mettere giù la persona",
                },
                trappedRescueAmbulanceFreeze = {
                    description = "Configures: Fermate l'ambulanza.",
                    label = "Fermate l'ambulanza",
                },
                trappedRescueAmbulanceInvincible = {
                    description = "Configures: Ambulanza InVINcible.",
                    label = "Ambulanza InVINcible",
                },
                trappedRescueAmbulanceLights = {
                    description = "Configures: Abilita le luci di emergenza.",
                    label = "Abilita le luci di emergenza",
                },
                trappedRescueAmbulanceOpenRearDoors = {
                    description = "Configures: Porte posteriori aperte.",
                    label = "Porte posteriori aperte",
                },
                trappedRescueDropoffRadius = {
                    description = "Configures: Raggio di rilascio dell'ambulanza.",
                    label = "Raggio di rilascio dell'ambulanza",
                },
                trappedRescueEnabled = {
                    description = "Consente di eseguire operazioni di salvataggio di persone e animali basate su scenari.",
                    label = "Abilita le attività di salvataggio NPC",
                },
                trappedRescueExtractionDurationMs = {
                    description = "Configures: Durata di estrazione del veicolo ms.",
                    label = "Durata di estrazione del veicolo ms",
                },
                trappedRescueForceGain = {
                    description = "Configures: Guadagno di forza al secondo.",
                    label = "Guadagno di forza al secondo",
                },
                trappedRescueForceLoss = {
                    description = "Configures: Perdita di forza al secondo.",
                    label = "Perdita di forza al secondo",
                },
                trappedRescueForceMax = {
                    description = "Configures: Buona tirata massima.",
                    label = "Buona tirata massima",
                },
                trappedRescueForceMin = {
                    description = "Configures: Buona tirata minima.",
                    label = "Buona tirata minima",
                },
                trappedRescueInteractionDistance = {
                    description = "Configures: Distanza d'interazione NPC.",
                    label = "Distanza d'interazione NPC",
                },
                trappedRescueJamChance = {
                    description = "Configures: Possibilità di inceppamento della fibbia.",
                    label = "Possibilità di inceppamento della fibbia",
                },
                trappedRescueMaxMisses = {
                    description = "Configures: Tiri non riusciti ammessi.",
                    label = "Tiri non riusciti ammessi",
                },
                trappedRescuePullsRequired = {
                    description = "Configures: Tiri forti richiesti.",
                    label = "Tiri forti richiesti",
                },
                trappedRescueReliefHoldMs = {
                    description = "Configures: Tempo di attesa ms.",
                    label = "Tempo di attesa ms",
                },
                trappedRescueReliefZoneMax = {
                    description = "Configures: Zona di tensione massima.",
                    label = "Zona di tensione massima",
                },
                trappedRescueReliefZoneMin = {
                    description = "Configures: Zona di tensione minima.",
                    label = "Zona di tensione minima",
                },
                trappedRescueRequireDoor = {
                    description = "Configures: Richiede la porta rimossa.",
                    label = "Richiede la porta rimossa",
                },
                trappedRescueRequireGlass = {
                    description = "Configures: Richiede la finestra rotta.",
                    label = "Richiede la finestra rotta",
                },
                trappedRescueRequireMatchingSide = {
                    description = "Configures: La finestra deve corrispondere al lato paziente.",
                    label = "La finestra deve corrispondere al lato paziente",
                },
                trappedRescueRequireOnDuty = {
                    description = "Configures: Richiedi servizio attivo.",
                    label = "Richiedi servizio attivo",
                },
                trappedRescueSeatbeltDurationMs = {
                    description = "Configures: Termine ms.",
                    label = "Termine ms",
                },
                trappedRescueSeatbeltEnabled = {
                    description = "Configures: Abilita cintura di sicurezza minigioco.",
                    label = "Abilita cintura di sicurezza minigioco",
                },
                treeBlipColor = {
                    description = "Configures: Colore blip.",
                    label = "Colore blip",
                },
                treeBlipLabel = {
                    description = "Configures: etichetta blip.",
                    label = "etichetta blip",
                },
                treeBlipScale = {
                    description = "Configures: Scala blip.",
                    label = "Scala blip",
                },
                treeBlipSprite = {
                    description = "Configures: Sprite blip.",
                    label = "Sprite blip",
                },
                treeCarryAnimDict = {
                    description = "Configures: Portare dizionario animazione.",
                    label = "Portare dizionario animazione",
                },
                treeCarryAnimFlag = {
                    description = "Configures: Bandiera di animazione per il trasporto.",
                    label = "Bandiera di animazione per il trasporto",
                },
                treeCarryAnimName = {
                    description = "Configures: Nome dell'animazione del trasporto.",
                    label = "Nome dell'animazione del trasporto",
                },
                treeCarryMoveBlend = {
                    description = "Configures: Miscela di movimento per il trasporto.",
                    label = "Miscela di movimento per il trasporto",
                },
                treeCarryOffsetRx = {
                    description = "Configures: Rotazione di carico X.",
                    label = "Rotazione di carico X",
                },
                treeCarryOffsetRy = {
                    description = "Configures: Rotazione di carico Y.",
                    label = "Rotazione di carico Y",
                },
                treeCarryOffsetRz = {
                    description = "Configures: Rotazione di carico Z.",
                    label = "Rotazione di carico Z",
                },
                treeCarryOffsetX = {
                    description = "Configures: Spostamento del carico X.",
                    label = "Spostamento del carico X",
                },
                treeCarryOffsetY = {
                    description = "Configures: Spostamento del carico Y.",
                    label = "Spostamento del carico Y",
                },
                treeCarryOffsetZ = {
                    description = "Configures: Spostamento del carico Z.",
                    label = "Spostamento del carico Z",
                },
                treeCarryProp = {
                    description = "Configures: Modello oggetto trasportato.",
                    label = "Modello oggetto trasportato",
                },
                treeCarryPropBone = {
                    description = "Configures: Osso da trasporto.",
                    label = "Osso da trasporto",
                },
                treeDispatchEnabled = {
                    description = "Configures: Invia l'albero centrale operativa.",
                    label = "Invia l'albero centrale operativa",
                },
                treeDispatchJobs = {
                    description = "Configures: Lavori mirati centrale operativa.",
                    itemLabel = "Lavoro",
                    label = "Lavori mirati centrale operativa",
                },
                treeDropCleanupRadius = {
                    description = "I log consegnati vengono rimossi quando nessun giocatore rimane entro questo intervallo.",
                    label = "Intervallo di pulizia",
                },
                treeDropMarkerA = {
                    description = "Configures: Marcatore alfa.",
                    label = "Marcatore alfa",
                },
                treeDropMarkerB = {
                    description = "Configures: Marcatore blu.",
                    label = "Marcatore blu",
                },
                treeDropMarkerG = {
                    description = "Configures: Verde marcatore.",
                    label = "Verde marcatore",
                },
                treeDropMarkerHeight = {
                    description = "Configures: Altezza marcatore.",
                    label = "Altezza marcatore",
                },
                treeDropMarkerR = {
                    description = "Configures: Rosso marcatore.",
                    label = "Rosso marcatore",
                },
                treeDropMarkerType = {
                    description = "Configures: Tipo marcatore.",
                    label = "Tipo marcatore",
                },
                treeDropOffsetX = {
                    description = "Local sideways offset dall'albero caduto.",
                    label = "Spostamento a discesa X",
                },
                treeDropOffsetY = {
                    description = "Spostamento locale lungo l'albero orientamento.",
                    label = "Spostamento a discesa Y",
                },
                treeDropOffsetZ = {
                    description = "Spostamento verticale a discesa.",
                    label = "Spostamento a discesa Z",
                },
                treeDropRadius = {
                    description = "Configures: Raggio di discesa.",
                    label = "Raggio di discesa",
                },
                treeEnabled = {
                    description = "Configures: Abilita incidenti sugli alberi caduti.",
                    label = "Abilita incidenti sugli alberi caduti",
                },
                treeInteractionDistance = {
                    description = "Configures: Distanza d'interazione.",
                    label = "Distanza d'interazione",
                },
                treeInteractionOffsetX = {
                    description = "Locale sfalsato dal modello dell'albero.",
                    label = "Spostamento punto sega X",
                },
                treeInteractionOffsetY = {
                    description = "Offset longitudinale locale dal modello ad albero.",
                    label = "Spostamento del punto di sega Y",
                },
                treeInteractionOffsetZ = {
                    description = "Spostamento verticale dal modello ad albero.",
                    label = "Spostamento del punto di taglio Z",
                },
                treeMarkerA = {
                    description = "Configures: Marcatore alfa.",
                    label = "Marcatore alfa",
                },
                treeMarkerB = {
                    description = "Configures: Marcatore blu.",
                    label = "Marcatore blu",
                },
                treeMarkerG = {
                    description = "Configures: Verde marcatore.",
                    label = "Verde marcatore",
                },
                treeMarkerHeight = {
                    description = "Configures: Altezza marcatore.",
                    label = "Altezza marcatore",
                },
                treeMarkerR = {
                    description = "Configures: Rosso marcatore.",
                    label = "Rosso marcatore",
                },
                treeMarkerSize = {
                    description = "Configures: Dimensione marcatore.",
                    label = "Dimensione marcatore",
                },
                treeMarkerType = {
                    description = "Configures: Tipo marcatore.",
                    label = "Tipo marcatore",
                },
                treePickupDistance = {
                    description = "Configures: Distanza di prelievo.",
                    label = "Distanza di prelievo",
                },
                treePieceCount = {
                    description = "Configures: Numero di pezzi di legno.",
                    label = "Numero di pezzi di legno",
                },
                treePieceModel = {
                    description = "Configures: Modello di pezzo di registro.",
                    label = "Modello di pezzo di registro",
                },
                treePieceSpacing = {
                    description = "Configures: Log spaziatura pezzo.",
                    label = "Log spaziatura pezzo",
                },
                treePropModel = {
                    description = "Modello oggetto spawned per l'albero caduto.",
                    label = "Modello di albero caduto",
                },
                treeRequireOnDuty = {
                    description = "Configures: Richiedi servizio attivo.",
                    label = "Richiedi servizio attivo",
                },
                treeSawAnimDict = {
                    description = "Configures: Dizionario animazione.",
                    label = "Dizionario animazione",
                },
                treeSawAnimFlag = {
                    description = "Configures: Flag animazione.",
                    label = "Flag animazione",
                },
                treeSawAnimName = {
                    description = "Configures: Nome animazione.",
                    label = "Nome animazione",
                },
                treeSawCollision = {
                    description = "Configures: Abilita collisione oggetto.",
                    label = "Abilita collisione oggetto",
                },
                treeSawIsPed = {
                    description = "Configures: Allega al ped.",
                    label = "Allega al ped",
                },
                treeSawOffsetRx = {
                    description = "Configures: Rotazione della sega a catena X.",
                    label = "Rotazione della sega a catena X",
                },
                treeSawOffsetRy = {
                    description = "Configures: Rotazione della sega a catena Y.",
                    label = "Rotazione della sega a catena Y",
                },
                treeSawOffsetRz = {
                    description = "Configures: Rotazione della motosega Z.",
                    label = "Rotazione della motosega Z",
                },
                treeSawOffsetX = {
                    description = "Configures: Spostamento della sega a catena X.",
                    label = "Spostamento della sega a catena X",
                },
                treeSawOffsetY = {
                    description = "Configures: Spostamento motosega Y.",
                    label = "Spostamento motosega Y",
                },
                treeSawOffsetZ = {
                    description = "Configures: Spostamento della sega a catena Z.",
                    label = "Spostamento della sega a catena Z",
                },
                treeSawProp = {
                    description = "Configures: Modello motosega oggetto.",
                    label = "Modello motosega oggetto",
                },
                treeSawPropBone = {
                    description = "Configures: Osso di sega a catena.",
                    label = "Osso di sega a catena",
                },
                treeSawRotationOrder = {
                    description = "Configures: Ordine di rotazione.",
                    label = "Ordine di rotazione",
                },
                treeSawSections = {
                    description = "Configures: Seghette richieste.",
                    label = "Seghette richieste",
                },
                treeSawSoftPinning = {
                    description = "Configures: Usa pinning morbido.",
                    label = "Usa pinning morbido",
                },
                treeSawSyncRotation = {
                    description = "Configures: Sincronizza rotazione.",
                    label = "Sincronizza rotazione",
                },
                treeSpawnRange = {
                    description = "L'albero in rete spawn quando un giocatore entra in questa gamma.",
                    label = "Gamma spawn",
                },
                vehicleFiresBurnDamageBreakWindows = {
                    description = "Configures: Spezzare le finestre a fuoco pieno.",
                    label = "Spezzare le finestre a fuoco pieno",
                },
                vehicleFiresBurnDamageBurstTyres = {
                    description = "Configures: Ruote di combustione a fuoco pieno.",
                    label = "Ruote di combustione a fuoco pieno",
                },
                vehicleFiresBurnDamageDeformation = {
                    description = "Configures: Forza di deformazione visiva.",
                    label = "Forza di deformazione visiva",
                },
                vehicleFiresBurnDamageEnabled = {
                    description = "Progressivamente danneggia e deforma il veicolo in fiamme prima dell'esplosione ritardata.",
                    label = "Danneggiare il veicolo durante la combustione",
                },
                vehicleFiresBurnDamageFullBodyHealth = {
                    description = "Configures: Salute del corpo a fuoco pieno.",
                    label = "Salute del corpo a fuoco pieno",
                },
                vehicleFiresBurnDamageIntervalSeconds = {
                    description = "Secondi tra le zecche danni aggiuntivi durante la fase di fuoco completo.",
                    label = "Intervallo di danno totale da incendio",
                },
                vehicleFiresBurnDamageMinimumBodyHealth = {
                    description = "Configures: Salute minima del corpo prima dell'esplosione.",
                    label = "Salute minima del corpo prima dell'esplosione",
                },
                vehicleFiresBurnDamagePerTick = {
                    description = "Configures: Danni corporei per intervallo.",
                    label = "Danni corporei per intervallo",
                },
                vehicleFiresBurnDamageSmallBodyHealth = {
                    description = "Configures: Salute del corpo a fuoco piccolo.",
                    label = "Salute del corpo a fuoco piccolo",
                },
                vehicleFiresCanExtinguishFoam = {
                    description = "Consente la formazione di schiuma proveniente da uno manichetta o da una fornitura di veicoli per spegnere questo materiale antincendio del veicolo.",
                    label = "Estintore con schiuma",
                },
                vehicleFiresCanExtinguishWater = {
                    description = "Permette di spegnere il materiale antincendio del veicolo con acqua manichetta, cannoni d'acqua del veicolo e acqua del secchio dell'elicottero.",
                    label = "Estintore con acqua",
                },
                vehicleFiresCanExtinguishWaterMonitor = {
                    description = "Permette al monitor portatile dell'acqua di spegnere questo materiale antincendio del veicolo.",
                    label = "Estintore con Monitor dell'acqua",
                },
                vehicleFiresDuplicateDistance = {
                    description = "Impedisce la creazione di un altro veicolo fuoco troppo vicino a uno esistente.",
                    label = "Distanza duplicata",
                },
                vehicleFiresEnabled = {
                    description = "Abilitare il sistema antincendio del veicolo.",
                    label = "Abilitato",
                },
                vehicleFiresEngineHealth = {
                    description = "Ha tenuto a 300 o più per prevenire l'incendio del veicolo nativo di GTA e l'esplosione prematura.",
                    label = "Salute del motore durante la combustione",
                },
                vehicleFiresEngineOff = {
                    description = "Configures: Spegnere il motore.",
                    label = "Spegnere il motore",
                },
                vehicleFiresExplosionCameraShake = {
                    description = "Configures: Frullo della fotocamera.",
                    label = "Frullo della fotocamera",
                },
                vehicleFiresExplosionDamageScale = {
                    description = "Configures: Scala di danno da esplosione.",
                    label = "Scala di danno da esplosione",
                },
                vehicleFiresExplosionDelaySeconds = {
                    description = "Secondi prima che un veicolo in fiamme esploda.",
                    label = "Secondi ritardo di esplosione",
                },
                vehicleFiresExplosionEnabled = {
                    description = "I veicoli non esplodono all'istante; questo controlla l'esplosione ritardata facoltativa.",
                    label = "Abilita esplosione ritardata",
                },
                vehicleFiresExplosionPostBurnSeconds = {
                    description = "Secondi il veicolo distrutto continua a bruciare dopo che esplode.",
                    label = "Durata della masterizzazione dopo l'esplosione",
                },
                vehicleFiresExplosionRemoveFire = {
                    description = "Rimuove il fuoco dopo la durata di masterizzazione post-esplosione configurata. Disabilita per un incendio relitto illimitato.",
                    label = "Rimuovere il fuoco dopo la combustione",
                },
                vehicleFiresExplosionType = {
                    description = "Configures: Tipo di esplosione.",
                    label = "Tipo di esplosione",
                },
                vehicleFiresExternalAllowedResources = {
                    description = "Risorse permesse per creare fuochi di veicoli attraverso l'amo esterno.",
                    itemLabel = "Risorsa",
                    label = "Risorse ammesse",
                },
                vehicleFiresExternalEnabled = {
                    description = "Permetti al meccanico o agli script approvati di creare incendi di veicoli di Fuoco.",
                    label = "Abilita la creazione esterna",
                },
                vehicleFiresExternalMaxSourceDistance = {
                    description = "Distanza massima tra le coordinate esterne del grilletto e il veicolo.",
                    label = "Distanza massima dalla sorgente",
                },
                vehicleFiresFireType = {
                    description = "Tipo di fonte di fuoco utilizzato quando viene creato un incendio del veicolo.",
                    label = "Tipo di incendio",
                },
                vehicleFiresFoamEffectiveness = {
                    description = "Valori più elevati rendono la schiuma spegnere gli incendi dei veicoli più velocemente.",
                    label = "Efficacia della schiuma",
                },
                vehicleFiresKeepUndriveable = {
                    description = "Configures: Mantenere il veicolo non guidabile.",
                    label = "Mantenere il veicolo non guidabile",
                },
                vehicleFiresManualConsumeItem = {
                    description = "Configures: Consumare elemento accendino.",
                    label = "Consumare elemento accendino",
                },
                vehicleFiresManualEnabled = {
                    description = "Permettere ai giocatori di accendere i veicoli vicini manualmente.",
                    label = "Accensione manuale",
                },
                vehicleFiresManualItem = {
                    description = "Articolo d'inventario richiesto per l'accensione manuale del veicolo.",
                    label = "Elemento di accensione",
                },
                vehicleFiresManualMaxDistance = {
                    description = "Configures: Distanza massima di accensione.",
                    label = "Distanza massima di accensione",
                },
                vehicleFiresManualSourceScale = {
                    description = "Configures: Scala di accensione manuale.",
                    label = "Scala di accensione manuale",
                },
                vehicleFiresMaterial = {
                    description = "Profilo del materiale utilizzato per il comportamento del carburante del veicolo.",
                    label = "Materiale antincendio",
                },
                vehicleFiresMaxActive = {
                    description = "Configures: Incendi massimi del veicolo attivo.",
                    label = "Incendi massimi del veicolo attivo",
                },
                vehicleFiresPetrolTankHealth = {
                    description = "Teneva a 1000 cosi' solo l'esplosione configurata dei pompieri può distruggere il veicolo.",
                    label = "Benzina salute serbatoio durante la combustione",
                },
                vehicleFiresProgressionEnabled = {
                    description = "Gli incendi dei veicoli iniziano con il fumo, crescono in un piccolo incendio e poi raggiungono la piena intensità.",
                    label = "Abilita l'incendio graduale del veicolo",
                },
                vehicleFiresProgressionExplosionAfterFullFire = {
                    description = "Aggiunge il fumo e le piccole durate di fuoco prima dell'inizio del ritardo di esplosione configurato.",
                    label = "Timer di esplosione dopo il fuoco completo",
                },
                vehicleFiresProgressionFullIntensity = {
                    description = "Configures: Piena intensità del fuoco.",
                    label = "Piena intensità del fuoco",
                },
                vehicleFiresProgressionFullSize = {
                    description = "Configures: Dimensione totale del fuoco.",
                    label = "Dimensione totale del fuoco",
                },
                vehicleFiresProgressionFullSmokeDensity = {
                    description = "Configures: Piena densità del fumo di fuoco.",
                    label = "Piena densità del fumo di fuoco",
                },
                vehicleFiresProgressionSmallDurationSeconds = {
                    description = "Configures: Piccola durata del fuoco secondi.",
                    label = "Piccola durata del fuoco secondi",
                },
                vehicleFiresProgressionSmallIntensity = {
                    description = "Configures: Piccola intensità del fuoco.",
                    label = "Piccola intensità del fuoco",
                },
                vehicleFiresProgressionSmallSize = {
                    description = "Configures: Piccola dimensione del fuoco.",
                    label = "Piccola dimensione del fuoco",
                },
                vehicleFiresProgressionSmallSmokeDensity = {
                    description = "Configures: Piccola densità di fumo incendio.",
                    label = "Piccola densità di fumo incendio",
                },
                vehicleFiresProgressionSmallSourceScale = {
                    description = "Configures: Piccola scala antincendio.",
                    label = "Piccola scala antincendio",
                },
                vehicleFiresProgressionSmokeDensity = {
                    description = "Configures: Densità dello stadio del fumo.",
                    label = "Densità dello stadio del fumo",
                },
                vehicleFiresProgressionSmokeDurationSeconds = {
                    description = "Configures: Durata del fumo secondi.",
                    label = "Durata del fumo secondi",
                },
                vehicleFiresProgressionSmokeIntensity = {
                    description = "Configures: Intensità dello stadio del fumo.",
                    label = "Intensità dello stadio del fumo",
                },
                vehicleFiresProgressionSmokeSize = {
                    description = "Configures: Dimensione stadio fumo.",
                    label = "Dimensione stadio fumo",
                },
                vehicleFiresProgressionSmokeSourceScale = {
                    description = "Mantenere questo molto basso per la maggior parte fumo con fiamme appena visibili.",
                    label = "Scala di fiamma per stadi di fumo",
                },
                vehicleFiresServerCooldownSeconds = {
                    description = "Global tempo di attesa per accensione con accendino manuale.",
                    label = "tempo di attesa di accensione a livello di server",
                },
                vehicleFiresSourceScale = {
                    description = "Configures: Scala di fuoco predefinita.",
                    label = "Scala di fuoco predefinita",
                },
                vehicleFiresStandaloneAllowNpcVehicles = {
                    description = "Configures: Permettere veicoli NPC.",
                    label = "Permettere veicoli NPC",
                },
                vehicleFiresStandaloneChance = {
                    description = "Configures: Possibilità di incendio d'emergenza.",
                    label = "Possibilità di incendio d'emergenza",
                },
                vehicleFiresStandaloneCooldownSeconds = {
                    description = "Configures: Crash tempo di attesa secondi.",
                    label = "Crash tempo di attesa secondi",
                },
                vehicleFiresStandaloneEnabled = {
                    description = "Lasciate che Firejob crei incendi di veicoli da gravi incidenti senza richiedere Mechanicjob.",
                    label = "Abilita crash standalone",
                },
                vehicleFiresStandaloneForwardMotionRatio = {
                    description = "Configures: Rapporto di movimento in avanti.",
                    label = "Rapporto di movimento in avanti",
                },
                vehicleFiresStandaloneIgnoreElectric = {
                    description = "Configures: Ignorare i veicoli elettrici.",
                    label = "Ignorare i veicoli elettrici",
                },
                vehicleFiresStandaloneMechanicResources = {
                    description = "Risorse che disabilitano il rilevamento di crash di ripiego mentre sono in esecuzione.",
                    itemLabel = "Risorsa",
                    label = "Risorse meccaniche",
                },
                vehicleFiresStandaloneMinBodyHealthLoss = {
                    description = "Configures: Danni corporei minimi.",
                    label = "Danni corporei minimi",
                },
                vehicleFiresStandaloneMinEngineHealthLoss = {
                    description = "Configures: Danni minimi al motore.",
                    label = "Danni minimi al motore",
                },
                vehicleFiresStandaloneMinImpactSpeedKmh = {
                    description = "Configures: Velocità minima d'urto.",
                    label = "Velocità minima d'urto",
                },
                vehicleFiresStandaloneMinSpeedDropKmh = {
                    description = "Configures: Perdita minima di velocità.",
                    label = "Perdita minima di velocità",
                },
                vehicleFiresStandaloneMode = {
                    description = "Fallback funziona solo quando le risorse meccaniche configurate non sono attive. È sempre possibile eseguire insieme a Mechanicjob. I disabili tengono solo trigger manuali, esterni o meccanici.",
                    label = "Modalità standalone",
                    options = {
                        always = "Sempre",
                        disabled = "Disabilitato",
                        fallback = "Ripiegamento",
                    },
                },
                vehicleFiresStandaloneRequireDriver = {
                    description = "Configures: Richiede il driver del giocatore.",
                    label = "Richiede il driver del giocatore",
                },
                vehicleFiresStandaloneServerMaxDistance = {
                    description = "Massima distanza consentita dal giocatore dalle coordinate di crash.",
                    label = "Distanza massima del server",
                },
                vehicleFiresStandaloneSmokeDensity = {
                    description = "Configures: Densità del fumo di crash.",
                    label = "Densità del fumo di crash",
                },
                vehicleFiresStandaloneSourceScale = {
                    description = "Configures: Scala di fuoco del crash.",
                    label = "Scala di fuoco del crash",
                },
                vehicleFiresWaterEffectiveness = {
                    description = "Utilizzare 0 in modo che l'acqua non spenga gli incendi del carburante del veicolo.",
                    label = "Efficacia dell'acqua",
                },
                vehicleFiresWaterReactionChance = {
                    description = "Configures: Possibilità di reazione.",
                    label = "Possibilità di reazione",
                },
                vehicleFiresWaterReactionEnabled = {
                    description = "Consente di diffondere, fumare o esplodere l'acqua sugli incendi del carburante del veicolo a seconda dei valori riportati di seguito.",
                    label = "L'acqua peggiora le cose.",
                },
                vehicleFiresWaterReactionExplosionChance = {
                    description = "Configures: Possibilità di reazione all'esplosione.",
                    label = "Possibilità di reazione all'esplosione",
                },
                vehicleFiresWaterReactionInterval = {
                    description = "Configures: Intervallo di reazione ms.",
                    label = "Intervallo di reazione ms",
                },
                vehicleFiresWaterReactionSmokeIncrease = {
                    description = "Configures: Aumento del fumo.",
                    label = "Aumento del fumo",
                },
                vehicleFiresWaterReactionSpreadCount = {
                    description = "Configures: Numero di spargimenti.",
                    label = "Numero di spargimenti",
                },
                vehicleRescueAllowMissionCreatorVehicles = {
                    description = "Permettere ai veicoli posti dal Creatore Missione Fuoco di diventare bersagli di salvataggio.",
                    label = "Veicoli ideatori di missioni",
                },
                vehicleRescueAllowStateBag = {
                    description = "Gli script esterni possono contrassegnare i veicoli con Entity(veicolo).state[configuredKey] = true.",
                    label = "Permetti il marcatore della borsa di stato",
                },
                vehicleRescueAllowWorldVehicles = {
                    description = "Lasciare che i normali veicoli danneggiati nel mondo diventino bersagli di salvataggio.",
                    label = "Veicoli terrestri",
                },
                vehicleRescueBreakDoorOnComplete = {
                    description = "Configures: Rompere la porta GTA sul successo.",
                    label = "Rompere la porta GTA sul successo",
                },
                vehicleRescueBreakWindowOnComplete = {
                    description = "Configures: Rompere la finestra GTA sul successo.",
                    label = "Rompere la finestra GTA sul successo",
                },
                vehicleRescueDoorLabel = {
                    description = "Etichetta di interazione indicata per la diffusione di una porta del veicolo.",
                    label = "Etichetta di interazione porte",
                },
                vehicleRescueDoorWheelLabel = {
                    description = "Utilizzare %s come segnaposto per l'etichetta laterale della porta rilevata.",
                    label = "Etichetta della ruota della porta",
                },
                vehicleRescueEnabled = {
                    description = "Abilitare le interazioni soccorso tecnico sui veicoli.",
                    label = "Abilitato",
                },
                vehicleRescueGlassDurationMs = {
                    description = "Configures: Durata ms.",
                    label = "Durata ms",
                },
                vehicleRescueGlassGoodZone = {
                    description = "Configures: Zona buona.",
                    label = "Zona buona",
                },
                vehicleRescueGlassHammerItem = {
                    description = "Articolo di inventario richiesto per rompere i finestrini del veicolo.",
                    label = "Articolo martello di vetro",
                },
                vehicleRescueGlassHammerProp = {
                    description = "Configures: Martello di vetro oggetto.",
                    label = "Martello di vetro oggetto",
                },
                vehicleRescueGlassHitPoints = {
                    description = "Configures: Punti deboli.",
                    label = "Punti deboli",
                },
                vehicleRescueGlassLabel = {
                    description = "Etichetta di interazione mostrata per rompere un finestrino del veicolo.",
                    label = "Etichetta di interazione vetro",
                },
                vehicleRescueGlassMaxMisses = {
                    description = "Configures: Missioni consentite.",
                    label = "Missioni consentite",
                },
                vehicleRescueGlassMinigameEnabled = {
                    description = "Configures: Abilita vetro minigioco.",
                    label = "Abilita vetro minigioco",
                },
                vehicleRescueGlassMistakePenalty = {
                    description = "Configures: Colpi di penalità di errore.",
                    label = "Colpi di penalità di errore",
                },
                vehicleRescueGlassPerfectZone = {
                    description = "Configures: Zona perfetta.",
                    label = "Zona perfetta",
                },
                vehicleRescueGlassRequiredHits = {
                    description = "Configures: Risultati richiesti.",
                    label = "Risultati richiesti",
                },
                vehicleRescueGlassWheelLabel = {
                    description = "Utilizzare %s come segnaposto per l'etichetta laterale della porta rilevata.",
                    label = "Etichetta della ruota in vetro",
                },
                vehicleRescueInteractionDistance = {
                    description = "Configures: Distanza d'interazione.",
                    label = "Distanza d'interazione",
                },
                vehicleRescueMaxScanDistance = {
                    description = "Configures: Distanza di scansione del veicolo.",
                    label = "Distanza di scansione del veicolo",
                },
                vehicleRescuePatientAccessibleAfterAnyDoor = {
                    description = "Imposta lo stato di salvataggio del veicolo ad essere accessibile dopo che una porta è stata rimossa.",
                    label = "Paziente accessibile dopo una porta",
                },
                vehicleRescuePlayerEntrapmentEnabled = {
                    description = "Trappola giocatori in veicoli gravemente danneggiati fino a quando non viene creato l'accesso di salvataggio.",
                    label = "Trappola del giocatore",
                },
                vehicleRescueRequireMatchingGlassForDoor = {
                    description = "Il punto porta appare solo dopo che la finestra laterale corrispondente è stata rimossa.",
                    label = "La porta richiede vetro corrispondente",
                },
                vehicleRescueRequireOnDuty = {
                    description = "Solo su servizio vigili del fuoco può rompere il vetro e forzare le porte.",
                    label = "Richiedi servizio attivo",
                },
                vehicleRescueSpreaderDecayPerTick = {
                    description = "Configures: Decadimento per zecca.",
                    label = "Decadimento per zecca",
                },
                vehicleRescueSpreaderDurationMs = {
                    description = "Configures: Durata ms.",
                    label = "Durata ms",
                },
                vehicleRescueSpreaderItem = {
                    description = "Articolo di inventario richiesto per diffondere le porte del veicolo.",
                    label = "Elemento diffusore",
                },
                vehicleRescueSpreaderMaxPumpPower = {
                    description = "Configures: Buona pompa massima.",
                    label = "Buona pompa massima",
                },
                vehicleRescueSpreaderMinPumpPower = {
                    description = "Configures: Buona pompa minima.",
                    label = "Buona pompa minima",
                },
                vehicleRescueSpreaderMinigameEnabled = {
                    description = "Configures: Abilita lo spreader minigioco.",
                    label = "Abilita lo spreader minigioco",
                },
                vehicleRescueSpreaderOverPressurePenalty = {
                    description = "Configures: Pena di sovrapressione.",
                    label = "Pena di sovrapressione",
                },
                vehicleRescueSpreaderPressureGain = {
                    description = "Configures: Aumento di pressione.",
                    label = "Aumento di pressione",
                },
                vehicleRescueSpreaderPressureLoss = {
                    description = "Configures: Perdita di pressione.",
                    label = "Perdita di pressione",
                },
                vehicleRescueSpreaderProgressPerTick = {
                    description = "Configures: Progressi per segno di spunta.",
                    label = "Progressi per segno di spunta",
                },
                vehicleRescueSpreaderProp = {
                    description = "Configures: Diffusore oggetto.",
                    label = "Diffusore oggetto",
                },
                vehicleRescueSpreaderPumpsRequired = {
                    description = "La porta viene rimossa dopo circa 3 a 5 buone pompe di spalmatore.",
                    label = "Cicli di pompa richiesti",
                },
                vehicleRescueSpreaderRequiredProgress = {
                    description = "Configures: Progressi necessari.",
                    label = "Progressi necessari",
                },
                vehicleRescueSpreaderSweetSpotMax = {
                    description = "Configures: Pressione punto dolce max.",
                    label = "Pressione punto dolce max",
                },
                vehicleRescueSpreaderSweetSpotMin = {
                    description = "Configures: Pressione punto dolce min.",
                    label = "Pressione punto dolce min",
                },
                vehicleRescueStateBagKey = {
                    description = "Configures: Chiave della borsa di Stato.",
                    label = "Chiave della borsa di Stato",
                },
                vehicleRescueWorldBodyHealthThreshold = {
                    description = "Configures: Soglia di salute dell'organismo.",
                    label = "Soglia di salute dell'organismo",
                },
                vehicleRescueWorldEngineHealthThreshold = {
                    description = "Configures: Soglia di salute del motore.",
                    label = "Soglia di salute del motore",
                },
                vehicleRescueWorldRequiresDamage = {
                    description = "Se abilitata, i normali veicoli del mondo devono essere danneggiati al di sotto delle soglie configurate.",
                    label = "I veicoli del mondo hanno bisogno di danni",
                },
                waterMonitorAllowedJobs = {
                    description = "Lasciare vuoto per consentire tutti i lavori configurati in questo Firejob.",
                    itemLabel = "Lavoro",
                    label = "Lavori ammessi",
                },
                waterMonitorCommand = {
                    description = "Nome di comando senza slash, per esempio watermonitor.",
                    label = "Comando",
                },
                waterMonitorCommandEnabled = {
                    description = "Permette di posizionare il Monitor dell'acqua senza un elemento utilizzando il comando.",
                    label = "Abilita l' uso dei comandi",
                },
                waterMonitorConsumeItem = {
                    description = "Rimuove un elemento configurato dopo il posizionamento riuscito.",
                    label = "Consumare la voce sul collocamento",
                },
                waterMonitorEnabled = {
                    description = "Consente il posizionamento e il funzionamento del monitor portatile dell'acqua.",
                    label = "Abilita monitor dell' acqua",
                },
                waterMonitorEnterAnimDict = {
                    description = "dizionario animazione caricato quando un giocatore inizia a utilizzare il Monitor Acqua.",
                    label = "Dizionario",
                },
                waterMonitorEnterAnimDurationMs = {
                    description = "Durata dell'animazione di invio in millisecondi; usare -1 per nessun timeout.",
                    label = "Durata ms",
                },
                waterMonitorEnterAnimName = {
                    description = "Clip di animazione riprodotto quando si entra nella posizione operativa.",
                    label = "Nome animazione",
                },
                waterMonitorExitAnimDict = {
                    description = "dizionario animazione caricato quando un giocatore smette di utilizzare il Monitor Acqua.",
                    label = "Dizionario",
                },
                waterMonitorExitAnimDurationMs = {
                    description = "Durata dell'animazione di uscita in millisecondi; utilizzare -1 per nessun timeout.",
                    label = "Durata ms",
                },
                waterMonitorExitAnimName = {
                    description = "Clip di animazione riprodotto quando leaVINg la posizione operativa.",
                    label = "Nome animazione",
                },
                waterMonitorIdleAnimDict = {
                    description = "dizionario animazione utilizzato durante il funzionamento del Monitor Acqua.",
                    label = "Dizionario",
                },
                waterMonitorIdleAnimDurationMs = {
                    description = "Durata dell'animazione operativa in millisecondi; usare -1 per mantenerla attiva.",
                    label = "Durata ms",
                },
                waterMonitorIdleAnimName = {
                    description = "Clip di animazione per looping utilizzato durante l'utilizzo del Water Monitor.",
                    label = "Nome animazione",
                },
                waterMonitorInteractionDistance = {
                    description = "Distanza massima dalla quale può essere utilizzato il Monitor dell'acqua.",
                    label = "Distanza d'interazione",
                },
                waterMonitorItem = {
                    description = "Elemento di inventario usato per posizionare il Monitor dell'acqua.",
                    label = "Nome dell'elemento",
                },
                waterMonitorItemEnabled = {
                    description = "Permette di posizionare il Monitor Acqua utilizzando l'elemento inventario configurato.",
                    label = "Abilita l' uso dell' elemento",
                },
                waterMonitorLabel = {
                    description = "Nome mostrato nelle interazioni e nelle notifiche.",
                    label = "Visualizza etichetta",
                },
                waterMonitorModel = {
                    description = "oggetto modello spawned per il Monitor Acqua.",
                    label = "Modello oggetto",
                },
                waterMonitorPickupDistance = {
                    description = "Distanza massima dalla quale si può prelevare un Monitor dell'acqua posizionato.",
                    label = "Distanza di prelievo",
                },
                waterMonitorRequireOnDuty = {
                    description = "Consente solo ai membri on-servizio di un lavoro consentito di utilizzare il Water Monitor.",
                    label = "Richiedi servizio attivo",
                },
                waterMonitorReturnItemOnRemove = {
                    description = "Restituisce un elemento configurato quando il Monitor dell'acqua viene prelevato.",
                    label = "Restituisci l'elemento al ritiro",
                },
                waterMonitorStreamDistance = {
                    description = "Distanza massima alla quale i Monitor dell'acqua sono sincronizzati e resi.",
                    label = "Distanza di streaming",
                },
                waterMonitorStreamHitRadius = {
                    description = "Raggio intorno alla traiettoria dell'acqua che può influenzare un incendio.",
                    label = "Raggio di hit",
                },
                waterMonitorStreamMinRange = {
                    description = "Distanza minima di flusso utilizzata quando si punta il Monitor dell'acqua.",
                    label = "Gamma minima",
                },
                waterMonitorStreamProgressPerSecond = {
                    description = "Resistenza di estinzione di base applicata agli incendi colpiti dal flusso.",
                    label = "Spegnere il progresso al secondo",
                },
                waterMonitorStreamRange = {
                    description = "Distanza massima di percorrenza del flusso d'acqua in metri.",
                    label = "Ampiezza",
                },
                waterMonitorStreamTrajectorySegments = {
                    description = "Numero di segmenti utilizzati per calcolare la traiettoria dell'acqua curva.",
                    label = "Segmenti di traiettoria",
                },
                waterMonitorStreamWaterGravityScale = {
                    description = "Controlla come la gravità piega fortemente la traiettoria dell'acqua verso il basso.",
                    label = "Scala di gravità",
                },
                waterMonitorStreamWaterLitersPerSecond = {
                    description = "Acqua consumata dall'alimentazione collegata durante la spruzzatura.",
                    label = "Litri d'acqua al secondo",
                },
                waterMonitorStreamWaterVelocity = {
                    description = "Velocità iniziale utilizzata per calcolare la traiettoria dell'acqua.",
                    label = "Velocità dell'acqua",
                },
                waterMonitorZOffset = {
                    description = "Correzione verticale applicata quando si posiziona lo oggetto sul terreno.",
                    label = "Spostamento Z del terreno",
                },
                waterTankEnabled = {
                    description = "Configures: Serbatoio dell'acqua.",
                    label = "Serbatoio dell'acqua",
                },
                waterTankSize = {
                    description = "Configures: Litri d'acqua.",
                    label = "Litri d'acqua",
                },
                x = {
                    description = "Configurazioni: X.",
                    label = "X",
                },
                y = {
                    description = "Configurazioni: Y.",
                    label = "Y",
                },
                z = {
                    description = "Configurazioni: Z.",
                    label = "Z",
                },
                zOffset = {
                    description = "Spostamento verticale in modo che il fuoco creato si trova correttamente sulla fonte di accensione cmanichettan.",
                    label = "Spostamento altezza fuoco",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Consente ai dipendenti di iscriversi alle sessioni di formazione disponibili.",
                approvalRequired = "Mantiene le autoiscrizioni in sospeso finché un istruttore autorizzato non le approva.",
                defaultCapacity = "Numero predefinito di posti utilizzati quando viene creata una nuova sessione di formazione.",
                enabled = "Rende disponibile l'app di formazione per questo lavoro.",
                requireOnDuty = "Richiede ai dipendenti di essere in servizio prima di aprire o utilizzare l'app di formazione.",
                upcomingDays = "Numero di giorni futuri visualizzati nella pianificazione dell'app Formazione.",
            },
            trainingFields = {
                allowSelfEnrollment = "Consenti l'autoiscrizione",
                approvalRequired = "Richiedere l'approvazione dell'iscrizione",
                defaultCapacity = "Capacità predefinita",
                enabled = "Abilita la formazione",
                requireOnDuty = "Richiedere dovere",
                upcomingDays = "Prossimo periodo (giorni)",
            },
        },
    },
}
