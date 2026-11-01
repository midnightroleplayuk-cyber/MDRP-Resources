JobConfigLocales["sky_policejob:it"] = {
    JobConfiguratorComingSoon = "Questo configuratore di professione arrivera' presto.",
    JobConfiguratorImportFailed = "Importazione di valori config.lua per '%s' non riuscita: %s.",
    JobConfiguratorImportHistoryFailed = "L'importazione è riuscita, ma la sua entrata storica non poteva essere salvata.",
    JobConfiguratorImportNoData = "'%s' non fornisce dati di importazione config.lua.",
    JobConfiguratorImportSuccess = "Valori config.lua importati per '%s': %d professioni, %d impostazione, %d caratteristica, e %d deviazioni di interazione applicate.",
    JobConfiguratorNoPermission = "Non hai il permesso di usare questo comando.",
    JobConfiguratorTitle = "Configuratore lavori",
    JobConfiguratorUnknown = "Configuratore di professione sconosciuto.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configurare dipartimenti di polizia, negozi, oggetti, veicoli, stazioni e impostazioni principali.",
                    title = "Lavori di polizia",
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
                radioButton = "Pulsante",
                radioButtonAction = "Azione pulsante",
                radioButtonStatus = "FMS Stato",
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
                dispatchRadioButtons = "Imposta l'azione predefinita centrale per ogni pulsante di funzione fisica.",
                dispatchRadioFmsKeys = "Assegna lo stato FMS alle chiavi fisiche. La tastiera esegue solo FMS modifiche.",
            },
            extensions = {
                caseNumbering = {
                    label = "Numeri dei fascicoli",
                    description = "Configura i numeri automatici dei fascicoli per questo lavoro.",
                    fields = {
                        prefix = {
                            label = "Prefisso del fascicolo",
                            description = "Prefisso dei nuovi fascicoli, ad esempio LSPD o LSCSD. Fino a 16 caratteri, convertiti in maiuscolo; se vuoto usa CASE. I numeri esistenti e assegnati manualmente restano invariati.",
                        },
                    },
                },
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
                dispatchRadioButtons = "Pulsanti funzione radio",
                dispatchRadioFmsKeys = "FMS Assegnazione delle chiavi",
            },
            features = {
                billing = {
                    description = "Abilita i flussi di lavoro di fatturazione della polizia.",
                    label = "Fatturazione",
                },
                devices = {
                    description = "Abilitare dispositivi di applicazione deployable.",
                    label = "Telecamere CCTV e a velocità",
                },
                evidence = {
                    description = "Abilita l'archiviazione delle prove, le prove sul campo e i flussi di scansione.",
                    label = "Prove",
                },
                impound = {
                    description = "Abilita i flussi di lavoro dei lotti sequestrati.",
                    label = "Sequestro",
                },
                jail = {
                    description = "Abilita l'assegnazione della prigione e le attività dei detenuti.",
                    label = "Carcere",
                },
                propPlacement = {
                    description = "Abilita la configurazione della polizia oggetti e veicolo configurazioni di oggetti.",
                    label = "Posizionamento oggetti",
                },
                radial = {
                    description = "Consentire azioni radiali della polizia come il sequestro e il bloccaggio delle ruote.",
                    label = "Azioni radiali",
                },
                restraints = {
                    description = "Abilita polsini, fascette, cinture per le gambe e borse per la testa.",
                    label = "Mezzi di contenzione",
                },
                socialWork = {
                    description = "Abilita l'assegnazione di compiti e attività di assistenza sociale.",
                    label = "Lavori socialmente utili",
                },
                tablet = {
                    description = "Abilita le app tablet della polizia configurate da questa risorsa.",
                    label = "App per tablet",
                },
                tracking = {
                    description = "Abilita localizzatori GPS e monitor per caviglie.",
                    label = "Tracciamento",
                },
                vehicleRadar = {
                    description = "Abilita il radar dei veicoli di pattuglia.",
                    label = "Radar del veicolo",
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
            settingFields = {
                gangMinimumGrade = "Grado minimo",
                gang = "Banda",
                component = "Componente",
                description = "Descrizione",
                fineAmount = "Quantità multa",
                itemName = "Nome dell'elemento",
                length = "Lunghezza",
                max = "Massimo",
                maxOverKmh = "Max oltre",
                min = "minimo",
                minOverKmh = "Eccesso min.",
                model = "Modello oggetto",
                propModel = "Modello oggetto",
                reason = "Motivazione",
                vehicleClass = "Classe",
            },
            settingGroups = {
                access = {
                    label = "Accesso",
                },
                animation = {
                    label = "Animazione",
                },
                ankleMonitor = {
                    label = "Monitor caviglia",
                },
                ankleMonitorAccess = {
                    label = "Accesso al monitoraggio caviglia",
                },
                ankleMonitorPlacement = {
                    label = "Posizionamento della caviglia del monitor",
                },
                ankleMonitorZone = {
                    label = "Zona di monitoraggio delle caviglie",
                },
                ankleMonitorZoneVisual = {
                    label = "Visual della zona di monitoraggio delle caviglie",
                },
                assignment = {
                    label = "Assegnazione",
                },
                blip = {
                    label = "Stazione blip",
                },
                carry = {
                    label = "Trasporto",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Durata CCTV",
                },
                cctvPlacement = {
                    label = "Posizionamento CCTV",
                },
                cctvRepair = {
                    label = "Riparazione CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animazione di riparazione CCTV",
                },
                clamp = {
                    label = "Morsetto",
                },
                clampWeld = {
                    label = "Saldatura del morsetto",
                },
                cleanup = {
                    label = "Pulizia",
                },
                collection = {
                    label = "Raccolta",
                },
                controls = {
                    label = "Controlli",
                },
                creator = {
                    label = "Creatore",
                },
                crimeSceneTape = {
                    label = "Nastro della scena del crimine",
                },
                crimeSceneTapeAccess = {
                    label = "Accesso al nastro",
                },
                crimeSceneTapeInventory = {
                    label = "Inventario del nastro",
                },
                crimeSceneTapeLength = {
                    label = "Lunghezza del nastro",
                },
                crimeSceneTapePlacement = {
                    label = "Posizionamento del nastro",
                },
                database = {
                    label = "Banca dati",
                },
                delivery = {
                    label = "Consegna",
                },
                detection = {
                    label = "Rilevamento",
                },
                dispatch = {
                    label = "Centrale operativa",
                },
                escape = {
                    label = "Fuga",
                },
                escort = {
                    label = "Scorta",
                },
                evidenceStorage = {
                    label = "Stoccaggio prove",
                },
                fastLock = {
                    label = "Blocco automatico veloce",
                },
                general = {
                    label = "Generale",
                },
                gpsTracker = {
                    label = "Tracciatore GPS",
                },
                gpsTrackerAccess = {
                    label = "Accesso al localizzatore GPS",
                },
                gpsTrackerPlacement = {
                    label = "Posizionamento del localizzatore GPS",
                },
                gpsTrackerTiming = {
                    label = "Tempistiche localizzatore GPS",
                },
                handcuffs = {
                    label = "Manette",
                },
                handsUp = {
                    label = "Mani in alto",
                },
                header = {
                    label = "Intestazione",
                },
                impound = {
                    label = "Sequestro",
                },
                imprisonment = {
                    label = "ImcarcereMENT",
                },
                jailCanteenGeneral = {
                    label = "carcere Canteen",
                },
                jailCanteenPackage = {
                    label = "Pacchetto mensa",
                },
                jailCarry = {
                    label = "Trasporto di lavoro",
                },
                jailCarryInspection = {
                    label = "Ispezione del trasporto",
                },
                jailCleaning = {
                    label = "Lavoro di pulizia",
                },
                jailCleaningIllegalFinds = {
                    label = "Trovi illegali",
                },
                jailCleaningOutline = {
                    label = "Linea di pulizia",
                },
                jailDoctor = {
                    label = "carcere Dottore",
                },
                jailElectricalCodes = {
                    label = "Codici elettrici carcere",
                },
                jailElectricalGeneral = {
                    label = "carcere elettrico",
                },
                jailElectricalPenalties = {
                    label = "carcere Sanzioni elettriche",
                },
                jailElectricalRewards = {
                    label = "Premi elettrici carcere",
                },
                jailInmatesAlcoholic = {
                    label = "Detenuto alcolizzato",
                },
                jailInmatesCodeList = {
                    label = "Informativa detenuta",
                },
                jailInmatesDrugDealer = {
                    label = "Detenuto spacciatore di droga",
                },
                jailInmatesWireCutter = {
                    label = "Runner dello strumento detenuto",
                },
                jailJobs = {
                    label = "Lavori carcere",
                },
                jailOutfitFemale = {
                    label = "Vestito femminile",
                },
                jailOutfitMale = {
                    label = "Outfit maschile",
                },
                keybinds = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Assegnazione tasti",
                },
                keybindsHandcuff = {
                    label = "Tastiera a manette",
                },
                keybindsUnhandcuff = {
                    label = "Keybind slacciata",
                },
                marker = {
                    label = "Marcatore",
                },
                markerColor = {
                    label = "Colore marcatore",
                },
                mugshotAnimation = {
                    label = "Animazione foto segnaletica",
                },
                mugshotBoard = {
                    label = "foto segnaletica Board",
                },
                mugshotCameraCoords = {
                    label = "Posizione della telecamera foto segnaletica",
                },
                mugshotCameraRotation = {
                    label = "Rotazione della telecamera foto segnaletica",
                },
                mugshotGeneral = {
                    label = "foto segnaletica",
                },
                mugshotMetadata = {
                    label = "Metadati foto segnaletica",
                },
                mugshotPosition = {
                    label = "Posizione foto segnaletica",
                },
                mugshotTiming = {
                    label = "foto segnaletica Timing",
                },
                officerDown = {
                    label = "Agente Down",
                },
                outfit = {
                    label = "Abbigliamento",
                },
                overlay = {
                    label = "Sovrapposto targa",
                },
                payment = {
                    label = "Pagamento",
                },
                paymentFlow = {
                    label = "Flusso di pagamento",
                },
                penalties = {
                    label = "Sanzioni",
                },
                playerSearch = {
                    label = "Ricerca giocatore",
                },
                playerSearchAnimation = {
                    label = "Animazione ricerca giocatore",
                },
                props = {
                    label = "Articoli oggetto",
                },
                reasons = {
                    label = "Motivazione",
                },
                release = {
                    label = "Rilascio",
                },
                restore = {
                    label = "Ripristina",
                },
                rules = {
                    label = "Regole",
                },
                scan = {
                    label = "Scansione",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Sentenza",
                },
                shotsFired = {
                    label = "Colpi di arma da fuoco",
                },
                sound = {
                    label = "Suono",
                },
                speedcam = {
                    label = "Fotocamere a velocità",
                },
                speedcamAdvanced = {
                    label = "Autovelox avanzato",
                },
                speedcamBilling = {
                    label = "Velocità di fatturazione della fotocamera",
                },
                speedcamDispatch = {
                    label = "Speed Camera centrale operativa",
                },
                speedcamDurability = {
                    label = "Velocità di durata della fotocamera",
                },
                speedcamPlacement = {
                    label = "Posizionamento della telecamera di velocità",
                },
                speedcamRepair = {
                    label = "Riparazione della macchina fotografica di velocità",
                },
                speedcamRepairAnimation = {
                    label = "Animazione riparazione autovelox",
                },
                speedcamTiming = {
                    label = "Tempismo della fotocamera di velocità",
                },
                speedcamVisual = {
                    label = "Visualizzazione della fotocamera di velocità",
                },
                speedcams = {
                    label = "Autovelox",
                },
                storage = {
                    label = "Stoccaggio",
                },
                subscription = {
                    label = "App Abbonamento",
                },
                tasks = {
                    label = "Compiti",
                },
                theme = {
                    label = "Tema",
                },
                timing = {
                    label = "Tempismo",
                },
                warningUi = {
                    label = "Attenzione UI",
                },
                world = {
                    label = "Mondo",
                },
                zipties = {
                    label = "fascette",
                },
                ziptiesCutter = {
                    label = "tagliafascette",
                },
                cctvMotionDetection = {
                    label = "Rilevamento del movimento",
                },
                cctvMotionDispatch = {
                    label = "Invio rilevamento movimento",
                },
                cctvMotionTiming = {
                    label = "Tempi di rilevamento del movimento",
                },
                display = {
                    label = "Visualizzazione",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Relazioni",
                },
                tackle = {
                    label = "Affronta",
                },
                vin = {
                    label = "VIN Controllo",
                },
            },
            settingSections = {
                radarGun = "Pistola radar",
                billing = "Fatturazione",
                cctv = "CCTV",
                dispatch = "Centrale operativa",
                equipment = "Attrezzature",
                evidence = "Prove",
                impound = "Sequestro",
                jail = "Carcere",
                radar = "Radar del veicolo",
                radial = "Azioni radiali",
                restraints = "Mezzi di contenzione",
                socialWork = "Lavori socialmente utili",
                speedCamera = "Fotocamera a velocità",
                spikeStrips = "Strisce chiodate",
                stations = "Stazioni",
                tablet = "App per tablet",
                tracking = "Tracciamento",
                fakePlates = "Targhe false",
                general = "Generale",
            },
            settingSubsections = {
                app = "App autovelox",
                apps = "App",
                billing = "Fatturazione",
                canteen = "Mensa del carcere",
                dispatch = "Centrale operativa",
                durability = "Durata",
                electrical = "Impianto elettrico del carcere",
                general = "Generale",
                handcuffs = "Manette e fascette",
                inmates = "Detenuti",
                jobs = "Lavori carcere",
                keybinds = "Assegnazione tasti",
                motionDetection = "Rilevamento del movimento",
                mugshot = "Foto segnaletica",
                placement = "Posizionamento",
                repair = "Riparazione",
                timing = "Tempismo",
                visuals = "Visuale",
            },
            settings = {
                radarGunClearKey = { label = "Pistola radar: Cancella misura" },
                radarGunToggleUiKey = { label = "Pistola radar: Attiva/disattiva interfaccia" },
                radarGunNoTargetHoldMs = { label = "Tempo di mantenimento bersaglio (ms)" },
                radarGunMinimumReading = { label = "Velocità minima visualizzata" },
                radarGunSpeedSmoothing = { label = "Smussamento velocità (0–1)" },
                radarGunBeamRadius = { label = "Raggio del fascio (m)" },
                radarGunRefreshRateMs = { label = "Intervallo di misura (ms)" },
                radarGunUseMph = { label = "Usa MPH", description = "Mostra le misurazioni in miglia orarie invece che in chilometri orari." },
                radarGunRange = { label = "Portata di misurazione", description = "Distanza massima in metri alla quale la pistola radar rileva i veicoli." },
                radarGunRequireOnDuty = { label = "Richiedi servizio", description = "Richiede che gli agenti siano in servizio prima di misurare i veicoli con la pistola radar." },
                radarGunAllowedJobs = { label = "Lavori o gruppi consentiti", description = "police comprende tutti i lavori di polizia configurati; sono ammessi anche nomi diretti. Un elenco vuoto elimina i limiti di lavoro.", itemLabel = "Lavoro o gruppo" },
                radarGunEnabled = { label = "Pistola radar", description = "Abilita la pistola radar portatile SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Gang consentite",
                    description = "Seleziona i nomi interni di gang o organizzazioni indipendenti. Un lavoro o gang corrispondente concede il permesso o l’esenzione. Il servizio è richiesto solo per i lavori.",
                    itemLabel = "Banda",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Gradi minimi delle gang",
                    description = "Gradi minimi facoltativi. Un elenco vuoto consente tutti i gradi. I requisiti degli oggetti restano validi.",
                },

                tabletRegistry = { label = "Registro", description = "Attiva i registri RP personalizzati in File Explorer. I fascicoli di cittadini e veicoli restano disponibili separatamente." },
                tabletFiles = { label = "Esplora file", description = "Raggruppa gli atti della polizia in Esplora file. I documenti DOJ compaiono solo quando il DOJ è attivo." },
                ankleMonitorAnimDurationMs = {
                    description = "Millisecondi spesi ad applicare un monitor alla caviglia.",
                    label = "Applica durata",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenario giocato durante l'applicazione di un monitor alla caviglia.",
                    label = "Applica scenario",
                },
                ankleMonitorAttachBone = {
                    description = "Ped osso utilizzato per fissare il monitor caviglia oggetto.",
                    label = "Fissare l'osso",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Rimuovere l'elemento del monitor alla caviglia dopo il posizionamento.",
                    label = "Consumare il monitor alla caviglia",
                },
                ankleMonitorCutItem = {
                    description = "Elemento di inventario utilizzato per rimuovere i monitor alla caviglia.",
                    label = "Taglia elemento",
                },
                ankleMonitorEnabled = {
                    description = "Abilita posizionamento cavigliera.",
                    label = "Monitor per caviglie",
                },
                ankleMonitorItem = {
                    description = "Elemento d'inventario usato per posizionare i monitor alla caviglia.",
                    label = "Elemento di controllo delle caviglie",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Millisecondi tra gli aggiornamenti delle mappe dei monitor alla caviglia.",
                    label = "Intervallo di aggiornamento mappa",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Mantiene i braccialetti elettronici nel database quando i giocatori monitorati si disconnettono, ripristinandoli dopo riconnessioni e riavvii del server.",
                    label = "Mantieni dopo la disconnessione",
                },
                ankleMonitorPlaceDistance = {
                    description = "Distanza massima per posizionare un cavigliera.",
                    label = "Distanza luogo",
                },
                ankleMonitorPropModel = {
                    description = "Modello oggetto utilizzato per il controllo visivo della caviglia.",
                    label = "Modello oggetto",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di usare i monitor alla caviglia.",
                    label = "Il monitor alla caviglia richiede servizio",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Richiedete al giocatore di essere nel gruppo della polizia prima di usare i monitor alla caviglia.",
                    label = "La cavigliera richiede lavoro di polizia.",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Restituisci l'elemento del monitor alla caviglia quando viene rimosso.",
                    label = "Ritorno caviglia monitor su rimozione",
                },
                ankleMonitorWarningSeconds = {
                    description = "L'ora di avvertimento prima di una violazione della zona di monitoraggio caviglia è centrale operativaED.",
                    label = "Secondi di avvertimento zona",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Millisecondi tra cavigliera zona di allarme bip.",
                    label = "Intervallo di segnale acustico zona",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Nome del suono utilizzato per le avvertenze relative alla zona di controllo delle caviglie.",
                    label = "Suono acustico",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Set sonoro utilizzato per gli avvertimenti delle zone di monitoraggio caviglie.",
                    label = "Impostazione del suono del segnale acustico",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Valore alfa utilizzato per la zona di monitoraggio caviglie blip.",
                    label = "blip alfa",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Colore blip usato quando un bersaglio si trova all'interno dell'area consentita.",
                    label = "Colore blip consentito",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Colore blip usato quando un bersaglio lascia l'area consentita.",
                    label = "Colore escluso blip",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Millisecondi tra i controlli della zona cavigliera.",
                    label = "Intervallo di controllo zona",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Secondi prima di un altro monitor alla caviglia zona centrale operativa può essere inviato.",
                    label = "Zona centrale operativa tempo di attesa",
                },
                ankleMonitorZoneEnabled = {
                    description = "Abilita i controlli della zona del monitor alla caviglia.",
                    label = "Zone di monitoraggio delle caviglie",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Sprite blip usata per i marcatori delle zone di monitoraggio delle caviglie.",
                    label = "Etichetta zona sprite",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Raggio utilizzato per i contorni delle zone di monitoraggio delle caviglie.",
                    label = "Raggio di linea",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Dimensioni del gradino utilizzate per i contorni delle zone di monitoraggio delle caviglie.",
                    label = "Passo fuori linea",
                },
                billingAccount = {
                    description = "Account Fallback utilizzato quando un lavoro non ha un account della società configurato.",
                    label = "Conto della società di ripiegamento",
                },
                billingCloseOnSuccess = {
                    description = "Chiudere l'interfaccia utente di fatturazione dopo che è stata emessa una fattura.",
                    label = "Chiudi dopo il successo",
                },
                billingCurrency = {
                    description = "Chiave valuta utilizzata per la fatturazione. Lascia vuoto per utilizzare la valuta predefinita.",
                    label = "Valuta",
                },
                billingCustomReasons = {
                    description = "Consenti motivi di fatturazione personalizzati invece di solo preset.",
                    label = "Motivi personalizzati",
                },
                billingDepositToSociety = {
                    description = "Depositare le entrate di fatturazione nel conto della società del lavoro.",
                    label = "Deposito alla società",
                },
                billingMaxReasonLength = {
                    description = "Numero massimo di caratteri per motivi di fatturazione personalizzati.",
                    label = "Lunghezza del motivo",
                },
                billingMode = {
                    description = "Scegliere se le fatture della polizia addebitano istantaneamente, richiedere la conferma del cittadino, o utilizzare il sistema di fatturazione quadro.",
                    label = "Modalità fatturazione",
                    options = {
                        consent = "Paga o declina",
                        framework = "Bill quadro",
                        instant = "Onere istantaneo",
                    },
                },
                billingRange = {
                    description = "Distanza massima obiettivo per l'emissione di fatture della polizia.",
                    label = "Campo di fatturazione",
                },
                billingReasonPresets = {
                    description = "Motivi di fatturazione predefiniti indicati nell'interfaccia utente di fatturazione.",
                    itemLabel = "Motivazione",
                    label = "Preimpostazioni della ragione",
                },
                billingRefreshSeconds = {
                    description = "Intervallo di aggiornamento del target durante l'apertura dell'interfaccia utente di fatturazione.",
                    label = "Aggiorna secondi",
                },
                billingShowRecipientName = {
                    description = "Mostra il nome del cittadino sulle anteprime e sulle ricevute dei biglietti.",
                    label = "Mostra il nome del destinatario",
                },
                carryAllowCarrierInVehicle = {
                    description = "Permettere al vettore di entrare e guidare un veicolo senza cadere il giocatore trasportato.",
                    label = "Consentire il vettore nel veicolo",
                },
                carryAllowConscious = {
                    description = "Lasciare che siano trasportati obiettivi coscienti.",
                    label = "Portare obiettivi coscienti",
                },
                carryAllowSprint = {
                    description = "Permettere sprint mentre si porta un altro giocatore.",
                    label = "Permetti sprint durante il trasporto",
                },
                carryEnabled = {
                    description = "Abilita il trasporto dei giocatori.",
                    label = "Trasporto",
                },
                carryMaxDistance = {
                    description = "Distanza massima per iniziare a trasportare un giocatore.",
                    label = "Distanza di trasporto",
                },
                carryRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di iniziare un trasporto.",
                    label = "Il trasporto richiede servizio",
                },
                cctvDamageCooldownMs = {
                    description = "Millisecondi prima che i danni CCTV possono essere nuovamente applicati.",
                    label = "Danni tempo di attesa",
                },
                cctvDamagePerHit = {
                    description = "Danni alla durata applicati alle telecamere a circuito chiuso per ogni hit.",
                    label = "Danni per colpo",
                },
                cctvDefaultName = {
                    description = "Nome di visualizzazione predefinito per le telecamere a circuito chiuso dispiegate.",
                    label = "Nome predefinito CCTV",
                },
                cctvDefaultPitch = {
                    description = "Piazzola predefinita per telecamere a circuito chiuso.",
                    label = "Pitch predefinito",
                },
                cctvDisassembleDistance = {
                    description = "Distanza usata per smontare telecamere a circuito chiuso.",
                    label = "Distanza di smontaggio",
                },
                cctvEnabled = {
                    description = "Abilita posizionamento e streaming della telecamera CCTV.",
                    label = "Telecamere a circuito chiuso",
                },
                cctvHealthDisplayDistance = {
                    description = "Distanza alla quale è indicata la salute delle telecamere a circuito chiuso.",
                    label = "Distanza di visualizzazione della salute",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Millisecondi che la salute delle telecamere di sicurezza rimane visibile.",
                    label = "Durata della visualizzazione della salute",
                },
                cctvHealthTextOffset = {
                    description = "Spostamento verticale usato per il testo di salute CCTV.",
                    label = "Spostamento testo salute",
                },
                cctvHeightStep = {
                    description = "Passo di altezza utilizzato durante il posizionamento telecamere a circuito chiuso.",
                    label = "Passo in altezza",
                },
                cctvItem = {
                    description = "Inventario usato per posizionare telecamere a circuito chiuso.",
                    label = "Voce CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Soglia di durata in cui si raccomanda la manutenzione delle telecamere a circuito chiuso.",
                    label = "Soglia di mantenimento",
                },
                cctvMaxDurability = {
                    description = "Massima durata della telecamera CCTV.",
                    label = "Durata delle CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Secondi prima che una telecamera possa creare un altro dispatch di movimento.",
                    label = "Attesa dispatch",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Millisecondi tra le scansioni del movimento lato client.",
                    label = "Intervallo di scansione",
                },
                cctvMotionClientCooldownMs = {
                    description = "Millisecondi prima che un client possa segnalare nuovamente la stessa telecamera.",
                    label = "Attesa segnalazione client",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Attiva automaticamente gli avvisi di movimento per le nuove telecamere CCTV.",
                    label = "Attiva le nuove telecamere per impostazione predefinita",
                },
                cctvMotionDetectionEnabled = {
                    description = "Abilita gli avvisi dispatch di rilevamento movimento per ogni telecamera CCTV.",
                    label = "Avvisi di movimento",
                },
                cctvMotionDetectionRadius = {
                    description = "Distanza massima di rilevamento del movimento in metri.",
                    label = "Raggio di rilevamento",
                },
                cctvMotionFieldOfView = {
                    description = "Angolo del cono di rilevamento del movimento in gradi.",
                    label = "Campo visivo",
                },
                cctvMotionJobs = {
                    description = "Nomi dei lavori o gruppi che ricevono i dispatch di movimento CCTV.",
                    itemLabel = "Lavoro o gruppo",
                    label = "Lavori dispatch",
                },
                cctvMotionMinimumSpeed = {
                    description = "Velocità minima di un'entità in metri al secondo per essere considerata in movimento.",
                    label = "Velocità minima di movimento",
                },
                cctvMoveStep = {
                    description = "Passo di movimento utilizzato durante il posizionamento telecamere CCTV.",
                    label = "Sposta passo",
                },
                cctvPropModel = {
                    description = "Modello oggetto utilizzato per le telecamere a circuito chiuso.",
                    label = "Modello CCTV oggetto",
                },
                cctvRepairAnimDict = {
                    description = "dizionario animazione utilizzato durante la riparazione di telecamere a circuito chiuso.",
                    label = "Riparazione animazione dict",
                },
                cctvRepairAnimFlag = {
                    description = "Bandiera di animazione utilizzata durante la riparazione di telecamere a circuito chiuso.",
                    label = "Repair animazione flag",
                },
                cctvRepairAnimName = {
                    description = "Nome di animazione utilizzato durante la riparazione delle telecamere a circuito chiuso.",
                    label = "Nome dell'animazione di riparazione",
                },
                cctvRepairCancelDelayMs = {
                    description = "Millisecondi prima della riparazione CCTV può essere annullato.",
                    label = "Riparazione annullare il ritardo",
                },
                cctvRepairDistance = {
                    description = "Distanza usata per riparare telecamere a circuito chiuso.",
                    label = "Distanza di riparazione",
                },
                cctvRepairItem = {
                    description = "Inventario usato per riparare telecamere a circuito chiuso.",
                    label = "Elemento di riparazione",
                },
                cctvRepairPerTick = {
                    description = "Durabilità ripristinata per ogni tick di riparazione CCTV.",
                    label = "Riparazione per segno di spunta",
                },
                cctvRepairTickMs = {
                    description = "Millisecondi tra le zecche di riparazione delle telecamere a circuito chiuso.",
                    label = "Tick di riparazione",
                },
                cctvRotateStep = {
                    description = "Passo di rotazione utilizzato durante il posizionamento telecamere a circuito chiuso.",
                    label = "Ruota passo",
                },
                cctvStreamDistance = {
                    description = "Distanza usata per le telecamere a circuito chiuso.",
                    label = "Distanza flusso",
                },
                cctvViewOffset = {
                    description = "Visualizza offset utilizzato per CCTV videocamera in diretta rendering.",
                    label = "Visualizza offset",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Crea una barriera di collisione lungo il nastro per impedire ai giocatori di attraversarlo.",
                    label = "Collisione bloccante del nastro",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Rimuove un oggetto nastro dall'inventario dopo il posizionamento riuscito.",
                    label = "Consuma l'oggetto nastro",
                },
                crimeSceneTapeDynamic = {
                    description = "Consente al nastro di reagire alla fisica e alla gravità invece di bloccarlo in posizione.",
                    label = "Fisica dinamica",
                },
                crimeSceneTapeEnabled = {
                    description = "Consente di posizionare il nastro della scena del crimine usando un oggetto dell'inventario.",
                    label = "Nastro della scena del crimine",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Solo i lavori autorizzati possono rimuovere il nastro e, quando richiesto, devono essere in servizio.",
                    label = "Limita la rimozione",
                },
                crimeSceneTapeItem = {
                    description = "Nome dell'oggetto dell'inventario che avvia il posizionamento del nastro della scena del crimine.",
                    label = "Oggetto nastro",
                },
                crimeSceneTapeJobs = {
                    description = "Nomi dei lavori autorizzati a usare il nastro della scena del crimine.",
                    itemLabel = "Lavoro",
                    label = "Lavori autorizzati",
                },
                crimeSceneTapeLabel = {
                    description = "Nome visualizzato per il nastro della scena del crimine durante il posizionamento.",
                    label = "Etichetta del nastro",
                },
                crimeSceneTapeLengthStep = {
                    description = "Incremento in metri a cui viene arrotondata la lunghezza selezionata del nastro.",
                    label = "Incremento della lunghezza",
                },
                crimeSceneTapeMaxLength = {
                    description = "Distanza massima consentita tra i due paletti del nastro, in metri.",
                    label = "Lunghezza massima del nastro",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Distanza massima di uno dei due punti finali dall'agente che posiziona il nastro.",
                    label = "Distanza massima di posizionamento",
                },
                crimeSceneTapeMinLength = {
                    description = "Distanza minima consentita tra i due paletti del nastro, in metri.",
                    label = "Lunghezza minima del nastro",
                },
                crimeSceneTapeModel = {
                    description = "Nome del modello dell'oggetto usato per il nastro della scena del crimine posizionato.",
                    label = "Modello del nastro",
                },
                crimeSceneTapePostModel = {
                    description = "Modello dell'oggetto utilizzato per entrambi i paletti del nastro.",
                    label = "Modello del paletto",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Distanza massima dalla quale è possibile rimuovere il nastro della scena del crimine posizionato.",
                    label = "Distanza di rimozione",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Solo i membri in servizio dei lavori autorizzati possono posizionare il nastro.",
                    label = "Richiedi servizio",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Restituisce l'oggetto consumato quando il nastro posizionato viene rimosso.",
                    label = "Restituisci l'oggetto alla rimozione",
                },
                crimeSceneTapeSag = {
                    description = "Abbassamento massimo verso il basso del nastro tra i paletti, in metri.",
                    label = "Abbassamento del nastro",
                },
                crimeSceneTapeSections = {
                    description = "Modelli nativi delle sezioni di nastro utilizzati per comporre la lunghezza selezionata.",
                    itemLabel = "Sezione del nastro",
                    label = "Sezioni del nastro",
                },
                crimeSceneTapeShowPosts = {
                    description = "Genera paletti di sostegno visibili a entrambe le estremità del nastro della scena del crimine a lunghezza variabile.",
                    label = "Mostra i paletti del nastro",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Distanza entro la quale viene caricato il nastro della scena del crimine posizionato.",
                    label = "Distanza di caricamento",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Altezza del nastro sopra i punti del terreno selezionati.",
                    label = "Altezza del nastro",
                },
                crimeSceneTapeVariableLength = {
                    description = "Consente agli agenti di definire un punto iniziale e uno finale per posizionare il nastro con una lunghezza regolabile.",
                    label = "Lunghezza variabile del nastro",
                },
                crimeSceneTapeZOffset = {
                    description = "Scostamento verticale applicato durante il posizionamento del modello del nastro.",
                    label = "Scostamento verticale",
                },
                cuffsAnimDict = {
                    description = "dizionario animazione utilizzato per i giocatori limitati.",
                    label = "Animazione dict",
                },
                cuffsAnimFlag = {
                    description = "Bandiera di animazione utilizzata per i giocatori limitati.",
                    label = "Flag animazione",
                },
                cuffsAnimName = {
                    description = "Nome dell'animazione utilizzato per i giocatori limitati.",
                    label = "Nome animazione",
                },
                cuffsConsumeItem = {
                    description = "Rimuovere l'articolo a manette quando i manette sono applicati.",
                    label = "Consumare le manette",
                },
                cuffsEnabled = {
                    description = "Abilita le azioni delle manette.",
                    label = "Manette",
                },
                cuffsEscapeEnabled = {
                    description = "Abilita la fuga del bracciale minigioco.",
                    label = "Evasione del manicotto",
                },
                cuffsEscapeKeyPool = {
                    description = "Chiavi che possono apparire nel bracciale fuga minigioco.",
                    itemLabel = "Chiave",
                    label = "Parcheggio chiavi di fuga",
                },
                cuffsEscapeRounds = {
                    description = "Numero di colpi richiesti nel braccio di fuga minigioco.",
                    label = "Giri di fuga",
                },
                cuffsEscapeWindowMs = {
                    description = "Millisecondi consentito per bracciale fuga finestra di ingresso.",
                    label = "Finestra di fuga",
                },
                cuffsHandsUpEnabled = {
                    description = "Abilitare lo stato manubrio utilizzato da manette e fascette.",
                    label = "Mani in alto!",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Secondi la chiave maniglia deve essere tenuto prima di attivazione.",
                    label = "Mani in alto secondi di attesa",
                },
                cuffsHandsUpKey = {
                    description = "Tastiera usata per alzare le mani.",
                    label = "Mani in alto la chiave",
                },
                cuffsItem = {
                    description = "Inventario usato per le azioni a manette.",
                    label = "Elemento del manicotto",
                },
                cuffsMaxDistance = {
                    description = "Distanza massima obiettivo per le azioni del bracciale.",
                    label = "Distanza del manicotto",
                },
                cuffsRequireItem = {
                    description = "Richiedete l' elemento a manette configurato.",
                    label = "Le manette richiedono l'elemento",
                },
                cuffsRequireOnDuty = {
                    description = "Richiede lo stato dello servizio prima dello ammanettamento.",
                    label = "Le manette richiedono servizio",
                },
                cuffsReturnOnRemove = {
                    description = "Restituisci l'articolo a manette quando i manette vengono rimossi.",
                    label = "Manette di ritorno",
                },
                dispatchOfficerDownEnabled = {
                    description = "Mandate uno segnalazione della centrale operativa quando un ufficiale dello servizio va a terra.",
                    label = "Agente a terra allarmi",
                },
                dispatchOfficerDownJobs = {
                    description = "Lavori che dovrebbero ricevere un agente sotto centrale operativaES.",
                    itemLabel = "Lavoro",
                    label = "Agente a terra.",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Avvisa solo i giocatori che sono attualmente in servizio.",
                    label = "Agente a terra richiede servizio",
                },
                dispatchShotsFiredChance = {
                    description = "Probabilità da 0.0 a 1.0 che un colpo rilevato generi un'allerta.",
                    label = "Probabilità di allerta",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Secondi prima che lo stesso giocatore può innescare altri colpi di allarme sparato.",
                    label = "Colpi di arma da fuoco tempo di attesa",
                },
                dispatchShotsFiredEnabled = {
                    description = "Abilitare colpi sparati segnalazioni della centrale operativa.",
                    label = "Sparatoria d'allarme",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Armi che non dovrebbero innescare colpi di allarme sparato.",
                    itemLabel = "Arma",
                    label = "Armi ignorate",
                },
                dispatchShotsFiredJobs = {
                    description = "Lavori che dovrebbero ricevere colpi sparati centrale operativaES.",
                    itemLabel = "Lavoro",
                    label = "Colpi d'arma da fuoco",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Avvisa solo i giocatori che sono attualmente in servizio.",
                    label = "Colpi sparati richiedono servizio",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Crea le voci centrale operativa quando vengono rilevati colpi sparati.",
                    label = "Invio colpi sparati centrale operativa",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Probabilità da 0.0 a 1.0 che un colpo silenziato rilevato generi un'allerta.",
                    label = "Probabilità di allerta con silenziatore",
                },
                escortEnabled = {
                    description = "Abilitare i giocatori di scorta.",
                    label = "Scorta",
                },
                escortMaxDistance = {
                    description = "Distanza massima per iniziare a scortare un giocatore.",
                    label = "Distanza di scorta",
                },
                escortRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di scortare i giocatori.",
                    label = "Escort richiede servizio",
                },
                escortVehicleDistance = {
                    description = "Distanza massima per inserire un giocatore scortato in un veicolo.",
                    label = "Distanza del veicolo scorta",
                },
                evidenceBloodDamageThreshold = {
                    description = "Soglia minima di danno prima della creazione di prove nel sangue.",
                    label = "Soglia del danno ematologico",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Millisecondi prima che possa essere creato un altro involucro.",
                    label = "Cosing tempo di attesa",
                },
                evidenceCasingMergeRadius = {
                    description = "Radius univa i bossoli vicini.",
                    label = "Inserisci il raggio di fusione",
                },
                evidenceCleanupIntervalMs = {
                    description = "Millisecondi tra prove pulizia passa.",
                    label = "Intervallo di pulizia",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Secondi prima della scadenza automatica del campo prove.",
                    label = "Pulizia TTL",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Detergente per tutti",
                    description = "Consenti a tutti di rimuovere tracce con perossido di idrogeno. Disattiva per usare gli elenchi di lavori e gang.",
                },
                evidenceCleanerJobs = {
                    label = "Lavori del detergente",
                    description = "Nomi interni consentiti senza accesso pubblico. Basta un lavoro o una gang corrispondente; gli elenchi vuoti negano l’accesso.",
                    itemLabel = "Lavoro",
                },
                evidenceCleanerGangs = {
                    label = "Gang del detergente",
                    description = "Nomi interni consentiti senza accesso pubblico. Basta un lavoro o una gang corrispondente; gli elenchi vuoti negano l’accesso.",
                    itemLabel = "Banda",
                },
                evidenceCollectDistance = {
                    description = "Distanza utilizzata per raccogliere il campo prove.",
                    label = "Distanza di raccolta",
                },
                evidenceDiscoverDistance = {
                    description = "Distanza usata per scoprire i vicini marcatori prove.",
                    label = "Scopri distanza",
                },
                evidenceFieldEnabled = {
                    description = "Abilita la creazione e la collezione prove sul campo.",
                    label = "Campo prove",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Arma usata per ispezionare e rivelare prove sul campo.",
                    label = "Arma torcia elettrica",
                },
                evidenceGloveFreeHands = {
                    description = "Identificazione dei componenti a mano trattati come non indossando guanti.",
                    label = "Mani libere da guanti",
                },
                evidenceMarkerColor = {
                    description = "Colore RGBA utilizzato per i marcatori di campo prove.",
                    label = "Colore marcatore",
                },
                evidenceMarkerDrawDistance = {
                    description = "Disegna la distanza utilizzata per i marcatori prove di campo.",
                    label = "Disegna distanza",
                },
                evidenceMarkerOffset = {
                    description = "Spostamento marcatore verticale utilizzato per il campo prove.",
                    label = "Spostamento",
                },
                evidenceMarkerScaleX = {
                    description = "Scala X marcatore utilizzata per il campo prove.",
                    label = "Scala X",
                },
                evidenceMarkerScaleY = {
                    description = "Scala marker Y usata per il campo prove.",
                    label = "Scala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Scala marcatore Z usata per il campo prove.",
                    label = "Scala Z",
                },
                evidenceMarkerType = {
                    description = "Tipo di marcatore utilizzato per il campo prove.",
                    label = "Tipo marcatore",
                },
                evidenceMaxCreateDistance = {
                    description = "Distanza massima per la creazione dei record prove.",
                    label = "Crea distanza",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Millisecondi consentito per il consenso del campione di saliva.",
                    label = "Timeout consenso Saliva",
                },
                evidenceScannerDistance = {
                    description = "Distanza usata per le interazioni dello scanner prove.",
                    label = "Distanza dello scanner",
                },
                evidenceScannerDurationMs = {
                    description = "Durata dell'azione dell'impronta digitale/dello scanner in millisecondi.",
                    label = "Durata dello scanner",
                },
                evidenceStorageMaxCompartments = {
                    description = "Numero massimo di scomparti prove.",
                    label = "Compartimenti di stoccaggio",
                },
                gpsTrackerBeepDistance = {
                    description = "Distanza in cui il segnale acustico del localizzatore GPS diventa rilevante.",
                    label = "Distanza bip",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Millisecondi tra i bip quando lontano da un localizzatore.",
                    label = "Intervallo di bip lontano",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Millisecondi tra i bip quando vicino a un localizzatore.",
                    label = "Intervallo di segnale acustico vicino",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Rimuove l'elemento del tracker dopo il posizionamento.",
                    label = "Consumare GPS tracker",
                },
                gpsTrackerEnabled = {
                    description = "Abilita il posizionamento e la scansione del localizzatore GPS del veicolo.",
                    label = "Tracker GPS",
                },
                gpsTrackerItem = {
                    description = "Inventario usato per posizionare GPS trackers.",
                    label = "Elemento tracciante",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Millisecondi tra gli aggiornamenti della mappa del tracker.",
                    label = "Intervallo di aggiornamento mappa",
                },
                gpsTrackerPlaceDistance = {
                    description = "Distanza massima per posizionare un localizzatore GPS su un veicolo.",
                    label = "Distanza luogo",
                },
                gpsTrackerRemoveDistance = {
                    description = "Distanza massima per rimuovere un localizzatore GPS posto.",
                    label = "Rimuovere la distanza",
                },
                gpsTrackerRemoveKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Rimuovi localizzatore GPS",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di usare i localizzatori GPS.",
                    label = "GPS richiede servizio",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Richiede al giocatore di far parte del gruppo di polizia prima di usare i localizzatori GPS.",
                    label = "GPS richiede lavoro di polizia",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Restituisci l' elemento del tracker quando viene rimosso.",
                    label = "Rimuovi il tracker al momento della rimozione",
                },
                gpsTrackerScanDistance = {
                    description = "Distanza massima per la scansione dei localizzatori.",
                    label = "Distanza scansione GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Millisecondi ha passato la scansione per un localizzatore GPS.",
                    label = "Durata scansione",
                },
                gpsTrackerScannerWeapon = {
                    description = "Arma o strumento utilizzato per la scansione dei tracker GPS.",
                    label = "Arma dello scanner",
                },
                impoundAccount = {
                    description = "Account utilizzato per caricare i rilasci sequestrati.",
                    label = "Conto di pagamento",
                },
                impoundCreatorVehicleModel = {
                    description = "Modello di veicolo mostrato dall'anteprima del creatore del deposito.",
                    label = "Modello di veicolo creatore",
                },
                impoundCustomGarageEnabled = {
                    description = "Utilizzare un'interfaccia di sequestro del garage personalizzato quando disponibile.",
                    label = "Deposito del garage personalizzato",
                },
                impoundDefaultPrice = {
                    description = "Predefinito prezzo di rilascio sequestrato.",
                    label = "Prezzo predefinito",
                },
                impoundDeliveryDistance = {
                    description = "Distanza usata per sequestrare interazioni di erogazione.",
                    label = "Distanza di consegna",
                },
                impoundDeliveryMarker = {
                    description = "Configurazione del marcatore utilizzata per le consegne di sequestri.",
                    label = "Marcatore di consegna",
                },
                impoundEnabled = {
                    description = "Abilita flussi di lavoro sequestrati.",
                    label = "Sequestro",
                },
                impoundMarker = {
                    description = "Configurazione del marcatore utilizzata per le interazioni di sequestro.",
                    label = "Marcatore dell'impronta",
                },
                impoundRadialEnabled = {
                    description = "Abilitare azioni radiali di sequestro.",
                    label = "Imposta azione",
                },
                impoundRadialRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di usare l'azione radiale del deposito.",
                    label = "Il sequestro richiede servizio",
                },
                impoundRadialVehicleDistance = {
                    description = "Distanza massima dal veicolo bersaglio per le azioni radiali di sequestro.",
                    label = "Distanza del veicolo pompato",
                },
                impoundReleaseDistance = {
                    description = "Distanza usata per le interazioni di rilascio sequestri.",
                    label = "Distanza di rilascio",
                },
                impoundReleaseKey = {
                    description = "Codice di controllo usato per rilasciare i veicoli sequestrati.",
                    label = "Chiave di rilascio",
                },
                impoundRequireDelivery = {
                    description = "Richiedete la consegna a un deposito giudiziario configurato.",
                    label = "Richiede la consegna",
                },
                impoundStorageBasePrice = {
                    description = "Prezzo di rilascio base per i veicoli sequestrati.",
                    label = "Prezzo base di stoccaggio",
                },
                impoundStorageDailyFee = {
                    description = "Supplemento deposito giudiziario per giorno configurato.",
                    label = "Tassa giornaliera di magazzinaggio",
                },
                impoundStorageDaySeconds = {
                    description = "Quanti secondi contano come un giorno di fatturazione.",
                    label = "Secondi giorno di conservazione",
                },
                impoundStorageEnabled = {
                    description = "Abilita gestione deposito giudiziario a pagamento.",
                    label = "deposito giudiziario",
                },
                jailAssignRange = {
                    description = "Distanza massima per assegnare un obiettivo a carcere.",
                    label = "Intervallo di assegnazione",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minuti uno carcereER deve aspettare prima di rivendicare un altro pacchetto mensa.",
                    label = "Minuti tempo di attesa",
                },
                jailCanteenPackage = {
                    description = "Articoli concessi dal pacchetto mensa carcere.",
                    label = "Pacchetto mensa",
                },
                jailCellStreamDistance = {
                    description = "Distanza usata per lo streaming delle celle solitarie oggetto.",
                    label = "Distanza del flusso cellulare",
                },
                jailClearInventory = {
                    description = "Cancellare l'inventario dei giocatori quando li invia a carcere.",
                    label = "Cancella inventario",
                },
                jailDefaultMonths = {
                    description = "Durata predefinita dello carcere quando si apre l'interfaccia utente dell'assegnazione.",
                    label = "Mesi predefiniti",
                },
                jailDispatchJobs = {
                    description = "Lavori che dovrebbero ricevere carcere centrale operativaES.",
                    itemLabel = "Lavoro",
                    label = "Lavori centrale operativa",
                },
                jailDoctorHealEvent = {
                    description = "Server o evento client attivato quando il medico carcere guarisce uno carcereER.",
                    label = "Evento di guarigione",
                },
                jailElectricalCodeListItem = {
                    description = "Articolo di inventario necessario per rivelare i codici elettrici generati.",
                    label = "Voce dell'elenco di codici",
                },
                jailElectricalCodeMax = {
                    description = "Il più alto valore di codice casuale per la scatola elettrica.",
                    label = "Codice massimo",
                },
                jailElectricalCodeMin = {
                    description = "Il valore di codice casuale più basso per la scatola elettrica.",
                    label = "Codice minimo",
                },
                jailElectricalCodesCount = {
                    description = "Quanti codici candidati vengono generati per la scatola elettrica.",
                    label = "Conteggio codici",
                },
                jailElectricalEnabled = {
                    description = "Abilita il breakout elettrico carcere minigioco.",
                    label = "Cassetta elettrica",
                },
                jailElectricalPinLength = {
                    description = "Numero di cifre utilizzate per i codici PIN della scatola elettrica.",
                    label = "Lunghezza del PIN",
                },
                jailElectricalPropModel = {
                    description = "Modello mondiale oggetto utilizzato per la scatola elettrica carcere.",
                    label = "Modello oggetto",
                },
                jailElectricalShockDamage = {
                    description = "Danni causati quando uno carcereER fallisce la sequenza elettrica.",
                    label = "Danni agli urti",
                },
                jailElectricalShockRagdollMs = {
                    description = "Millisecondi di ragdoll dopo uno shock elettrico.",
                    label = "Ragdoll da scossa",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Condanna minuti rimossi dopo un tentativo di fuga elettrica riuscito.",
                    label = "Il successo riduce i minuti",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Quantità necessaria per il commercio di detenuti alcolici.",
                    label = "Importo richiesto",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Articolo richiesto per il commercio dei detenuti alcolici.",
                    label = "Articolo richiesto",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Ricompensa per il commercio di detenuti alcolizzati.",
                    label = "Importo della ricompensa",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Una ricompensa per il commercio di detenuti alcolizzati.",
                    label = "Elemento premio",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Etichetta premiata per il commercio di detenuti alcolici.",
                    label = "Etichetta premio",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Quantità richiesta per il commercio dei detenuti informatori.",
                    label = "Importo richiesto",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Oggetto richiesto per il commercio dei detenuti informatori.",
                    label = "Articolo richiesto",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Importo della ricompensa per il traffico di detenuti informatori.",
                    label = "Importo della ricompensa",
                },
                jailInmateCodeListRewardItem = {
                    description = "Oggetto di ricompensa per il commercio dei detenuti informatori.",
                    label = "Elemento premio",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Etichetta premiata per il commercio dei detenuti informatori.",
                    label = "Etichetta premio",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Oggetti accettati per il commercio di detenuti spacciatori.",
                    label = "Elementi accettati",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Quantità richiesta per il commercio di detenuti spacciatori.",
                    label = "Importo richiesto",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Ricompensa per lo spacciatore di detenuti.",
                    label = "Importo della ricompensa",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Oggetto premio per il commercio di detenuti spacciatori.",
                    label = "Elemento premio",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Etichetta premiata per il commercio di detenuti spacciatori.",
                    label = "Etichetta premio",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Permettere contrabbando trovato durante la pulizia carcere per contare per il commercio di detenuti spacciatori.",
                    label = "Utilizzare il contrabbando di pulizia",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Quantità richiesta per il traffico di detenuti corridore strumento.",
                    label = "Importo richiesto",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Articolo richiesto per il traffico di detenuti corridore strumento.",
                    label = "Articolo richiesto",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Importo della ricompensa per il commercio di detenuti corridore strumento.",
                    label = "Importo della ricompensa",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Oggetto premio per il commercio di detenuti corridore strumento.",
                    label = "Elemento premio",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Etichetta premiata mostrata per il commercio di detenuti corridore strumento.",
                    label = "Etichetta premio",
                },
                jailJobsCarryBoxModel = {
                    description = "Modello oggetto utilizzato per il job box carcere.",
                    label = "Modello di scatola di trasporto",
                },
                jailJobsCarryDropoffKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Lavoro in carcere: consegna",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Raggio di caduta per il lavoro di trasporto carcere.",
                    label = "Raggio di abbandono",
                },
                jailJobsCarryInspectKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Lavoro in carcere: ispeziona",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Articoli spazzatura che possono essere trovati durante l'ispezione portare scatole di lavoro.",
                    label = "Articoli di ispezione spazzatura",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Possibilità di una ricompensa da bottino utilizzabile durante l'ispezione delle scatole.",
                    label = "Possibilità di bottino utilizzabile",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Articoli utilizzabili che possono essere trovati durante l'ispezione portare scatole di lavoro.",
                    label = "Elementi di ispezione utilizzabili",
                },
                jailJobsCarryInteractDistance = {
                    description = "Distanza di interazione per il lavoro di trasporto carcere.",
                    label = "Trasportare distanza interattiva",
                },
                jailJobsCarryMaxDistance = {
                    description = "Massima distanza consentita per portare la progressione di lavoro carcere.",
                    label = "Distanza massima di trasporto",
                },
                jailJobsCarryPickupKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Lavoro in carcere: raccogli",
                },
                jailJobsCarryPickupOffset = {
                    description = "Oggetto di Offset utilizzato per la posizione di ritiro del lavoro di trasporto.",
                    label = "Spostamento pickup",
                },
                jailJobsCarryTimeReduction = {
                    description = "Riduzione della sentenza per il completamento del lavoro carry carcere.",
                    label = "Riduzione del tempo di trasporto",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Pulizia: smaltisci",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modello utilizzato per il cassonetto di pulizia carcere oggetto.",
                    label = "Modello di dumpster",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Possibilità di trovare contrabbando durante la pulizia.",
                    label = "Illegale trovare la possibilità",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Oggetti che possono essere trovati durante la pulizia in carcere.",
                    label = "Trova oggetti illegali",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Timeout per richieste di ricerca illegali in millisecondi.",
                    label = "Trova il timeout del prompt",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distanza usata per pulire l'interazione con i rifiuti.",
                    label = "Pulizia interagiscono distanza",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Distanza massima prima di pulire oggetti reset o despawn.",
                    label = "Distanza massima di pulizia",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Massimo cestino simultaneo oggetti per pulizia carcere.",
                    label = "Massimo cestino oggetti",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Distanza minima dal centro per la pulizia dei rifiuti spawn.",
                    label = "Raggio minimo spawn",
                },
                jailJobsCleaningPickupKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Pulizia: raccogli",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Millisecondi tra i tentativi di pulizia dei rifiuti spawn.",
                    label = "Intervallo spawn del cestino",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Raggio usato per spawn pulizia rifiuti oggetti.",
                    label = "Raggio spawn del cestino",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modelli di spazzatura oggetto utilizzati per il lavoro di pulizia carcere.",
                    itemLabel = "Modello",
                    label = "Modelli di cestino",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Colore del contorno RGBA utilizzato per la pulizia del cestino carcere oggetti.",
                    label = "Colore contorno",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Abilitare i contorni su carcere pulizia spazzatura oggetti.",
                    label = "Descrizione del cestino",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID Shader utilizzato per pulire i profili dei rifiuti carcere.",
                    label = "Shader contorno",
                },
                jailJobsTimeReduction = {
                    description = "Riduzione della pena per completare il lavoro di pulizia carcere.",
                    label = "Riduzione del tempo di pulizia",
                },
                jailJobsTrashGoal = {
                    description = "Cestino necessario per completare il lavoro di pulizia carcere.",
                    label = "L'obiettivo della spazzatura di pulizia",
                },
                jailMaxMonths = {
                    description = "Durata massima selezionabile carcere.",
                    label = "Mesi massimi",
                },
                jailMinMonths = {
                    description = "Durata minima selezionabile carcere.",
                    label = "Mesi minimi",
                },
                jailMonthMinutes = {
                    description = "Minuti in tempo reale rappresentati da un mese carcere.",
                    label = "Minuti al mese",
                },
                jailObjectStreamDistance = {
                    description = "Distanza utilizzata per lo streaming persistente di oggetti carcere.",
                    label = "Distanza flusso oggetto",
                },
                jailOutfitApplyDelayMs = {
                    description = "Ritardo dopo l'adesione prima che venga applicato il vestito carcere.",
                    label = "Outfit applicare il ritardo",
                },
                jailOutfitEnabled = {
                    description = "Abilita gli abiti carcere.",
                    label = "Vestito carcere",
                },
                jailOutfitFemaleArms = {
                    description = "Componente delle braccia outfit carcere femminili.",
                    label = "Braccia",
                },
                jailOutfitFemaleChain1 = {
                    description = "Outfit donna carcere a catena disegnabile.",
                    label = "Catena 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Female carcere outfit catena texture.",
                    label = "Catena 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Decalcomanie femminili carcere disegnabili.",
                    label = "Decal 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Vestito femminile carcere decalcomania.",
                    label = "Adesivi 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Vetri femmina carcere disegnabili (-1 rimuove gli occhiali).",
                    label = "Bicchieri 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Vetri donna carcere texture.",
                    label = "Bicchieri 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Casco vestito donna carcere disegnato.",
                    label = "Casco 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Casco femmina carcere vestito texture.",
                    label = "Casco 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Pantalone donna carcere disegnato.",
                    label = "Pantaloni 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Pantalone donna carcere texture.",
                    label = "Pantaloni 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Outfit donna carcere scarpe disegnabili.",
                    label = "Scarpe 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Femmina carcere abbigliamento scarpe texture.",
                    label = "Scarpe 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Vestito femminile carcere torso disegnabile.",
                    label = "Torso 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Vestito femminile carcere trama torso.",
                    label = "Torso 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Vestito donna carcere T-shirt disegnabile.",
                    label = "T-shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Vestito donna carcere T-shirt texture.",
                    label = "T-shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Completo di bracci maschili carcere.",
                    label = "Braccia",
                },
                jailOutfitMaleChain1 = {
                    description = "Catene maschili carcere disegnabili.",
                    label = "Catena 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Maschio carcere outfit catena texture.",
                    label = "Catena 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Decalcomanie maschili carcere disegnabili.",
                    label = "Decal 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Maschio carcere vestito decalcomania texture.",
                    label = "Adesivi 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Occhiali maschili carcere disegnabili (-1 rimuove gli occhiali).",
                    label = "Bicchieri 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Vetri maschio carcere texture.",
                    label = "Bicchieri 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Casco maschio carcere disegnato.",
                    label = "Casco 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Maschio carcere vestito texture casco.",
                    label = "Casco 2",
                },
                jailOutfitMalePants1 = {
                    description = "Pantalone uomo carcere disegnato.",
                    label = "Pantaloni 1",
                },
                jailOutfitMalePants2 = {
                    description = "Maschio carcere outfit pantaloni texture.",
                    label = "Pantaloni 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Scarpe da uomo carcere disegnabili.",
                    label = "Scarpe 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Maschio carcere outfit scarpe texture.",
                    label = "Scarpe 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Vestito maschio carcere con busto disegnabile.",
                    label = "Torso 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Outfit maschio carcere trama torso.",
                    label = "Torso 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Vestito maschio carcere T-shirt disegnabile.",
                    label = "T-shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Vestito maschio carcere T-shirt texture.",
                    label = "T-shirt 2",
                },
                jailRequireJailTerminal = {
                    description = "Permetti solo frasi carcere rilasciate da un ufficiale vicino ad un terminale dello carcere selezionato.",
                    label = "Richiede terminale del carcere",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Ripristinate il vestito civile salvato quando scoppia uno carcereER.",
                    label = "Ripristinare il vestito al breakout",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Finestra di grazia dopo il ripristino prima che la correzione spawn smetta di applicare.",
                    label = "Ripristina la finestra di correzione",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teletrasporto ripristinato carcereers torna a carcere spawn se caricano fuori dalla zona carcere.",
                    label = "Teletrasporto ripristinato carcereers",
                },
                jailTerminalRange = {
                    description = "Distanza massima dall'ufficiale da un terminale dello carcere selezionato.",
                    label = "Gamma terminale del carcere",
                },
                jailZoneExitGraceMs = {
                    description = "Finestra di grazia prima di un'uscita zona carcere può contare come un breakout.",
                    label = "Grace di uscita zona",
                },
                mugshotAnimDict = {
                    description = "dizionario animazione utilizzato durante la cattura foto segnaletica.",
                    label = "Animazione dict",
                },
                mugshotAnimFlag = {
                    description = "Bandiera di animazione utilizzata durante la cattura foto segnaletica.",
                    label = "Flag animazione",
                },
                mugshotAnimName = {
                    description = "Nome dell'animazione utilizzato durante la cattura foto segnaletica.",
                    label = "Nome animazione",
                },
                mugshotBoardHeader = {
                    description = "Intestazione principale mostrata sulla scheda foto segnaletica.",
                    label = "Intestazione della scheda",
                },
                mugshotBoardSubheader = {
                    description = "Sottointestazione di caduta mostrata sulla scheda foto segnaletica.",
                    label = "Sottointestazione di bordo",
                },
                mugshotCameraCoordsX = {
                    description = "Coordinata X del mondo della fotocamera usata per foto segnaletiche.",
                    label = "Fotocamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Coordinata Y del mondo della fotocamera utilizzata per foto segnaletiche.",
                    label = "Telecamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Coordinata Z mondo fotocamera utilizzata per foto segnaletiche.",
                    label = "Telecamera Z",
                },
                mugshotCameraFov = {
                    description = "Campo visivo utilizzato per le catture foto segnaletica.",
                    label = "Telecamera FOV",
                },
                mugshotCameraRotX = {
                    description = "Rotazione della fotocamera X utilizzata per foto segnaletiche.",
                    label = "Rotazione X",
                },
                mugshotCameraRotY = {
                    description = "Rotazione della fotocamera Y usata per foto segnaletiche.",
                    label = "Rotazione Y",
                },
                mugshotCameraRotZ = {
                    description = "Rotazione della fotocamera Z usata per foto segnaletiche.",
                    label = "Rotazione Z",
                },
                mugshotCaptureTimeout = {
                    description = "Millisecondi massimi consentiti per le chiamate di cattura foto segnaletica.",
                    label = "Cattura timeout",
                },
                mugshotEnabled = {
                    description = "Abilitare la cattura foto segnaletica durante l'assunzione di carcere.",
                    label = "Cattura foto segnaletica",
                },
                mugshotHeading = {
                    description = "orientamento applicato durante la cattura foto segnaletica.",
                    label = "orientamento",
                },
                mugshotLocationX = {
                    description = "Coordinata X mondiale utilizzata per la cattura foto segnaletica.",
                    label = "Ubicazione X",
                },
                mugshotLocationY = {
                    description = "Coordinata Y mondiale utilizzata per la cattura foto segnaletica.",
                    label = "Ubicazione Y",
                },
                mugshotLocationZ = {
                    description = "Coordinata Z mondiale utilizzata per la cattura foto segnaletica.",
                    label = "Ubicazione Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Formato della descrizione utilizzato per i metadati foto segnaletica memorizzati.",
                    label = "Descrizione dei metadati",
                },
                mugshotMetadataName = {
                    description = "Nome dei metadati di inventario utilizzato per la foto foto segnaletica memorizzata.",
                    label = "Nome dei metadati",
                },
                mugshotWaitMs = {
                    description = "Millisecondi da aspettare prima di scattare la foto foto segnaletica.",
                    label = "Aspetta millisecondi",
                },
                playerSearchAnimDict = {
                    description = "dizionario animazione utilizzato durante le ricerche del lettore.",
                    label = "Animazione dict",
                },
                playerSearchAnimFlag = {
                    description = "Bandiera di animazione usata durante le ricerche del giocatore.",
                    label = "Flag animazione",
                },
                playerSearchAnimName = {
                    description = "Nome dell'animazione usato durante le ricerche del giocatore.",
                    label = "Nome animazione",
                },
                playerSearchDurationMs = {
                    description = "Durata dell'anteprima di ricerca dei giocatori in millisecondi.",
                    label = "Durata della ricerca",
                },
                playerSearchEnabled = {
                    description = "Abilita il flusso di lavoro in anteprima per la ricerca dei giocatori.",
                    label = "Ricerca giocatore",
                },
                playerSearchRange = {
                    description = "Distanza massima per avviare una ricerca del giocatore.",
                    label = "Intervallo di ricerca",
                },
                playerSearchScenario = {
                    description = "Scenario usato quando non viene riprodotta alcuna animazione di ricerca esplicita.",
                    label = "Scenario di ricerca",
                },
                policeBillingControl200 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Fatturazione · Controllo 200",
                },
                policeBillingControl322 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Fatturazione · Controllo 322",
                },
                policeEditorControl10 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 10",
                },
                policeEditorControl11 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 11",
                },
                policeEditorControl172 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 172",
                },
                policeEditorControl173 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 173",
                },
                policeEditorControl174 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 174",
                },
                policeEditorControl175 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 175",
                },
                policeEditorControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 177",
                },
                policeEditorControl191 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 191",
                },
                policeEditorControl201 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 201",
                },
                policeEditorControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 202",
                },
                policeEditorControl21 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 21",
                },
                policeEditorControl32 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 32",
                },
                policeEditorControl322 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 322",
                },
                policeEditorControl33 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 33",
                },
                policeEditorControl34 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 34",
                },
                policeEditorControl35 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 35",
                },
                policeEditorControl36 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 36",
                },
                policeEditorControl37 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 37",
                },
                policeEditorControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 38",
                },
                policeEditorControl44 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 44",
                },
                policeEditorControl73 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 73",
                },
                policePrimaryColor = {
                    description = "Colore predefinito per il gruppo dei lavori di polizia.",
                    label = "Colore primario",
                },
                propPlacementConsumeItem = {
                    description = "Rimuovere un elemento di inventario quando uno oggetto è posto dall'inventario.",
                    label = "Consumare elemento oggetto",
                },
                propPlacementEnabled = {
                    description = "Permettere la polizia configurata oggetti da posizionare da elementi o veicoli.",
                    label = "Posizionamento oggetto",
                },
                propPlacementItemNames = {
                    description = "Mappa modelli oggetto per l'inventario dei nomi degli elementi per il posizionamento oggetto basato su elementi.",
                    label = "Denominazione degli elementi oggetto",
                },
                propPlacementRequireOnDuty = {
                    description = "Solo gli ufficiali servizio possono piazzare oggetti configurato.",
                    label = "oggetti richiede servizio",
                },
                propPlacementReturnItem = {
                    description = "Riporre l'articolo consumato quando viene rimosso uno oggetto inserito.",
                    label = "Restituisci elemento oggetto",
                },
                propPlacementVehicleAccess = {
                    description = "Permettere ai veicoli di lavoro di esporre il loro oggetto configurato equipaggiamento.",
                    label = "Accesso al veicolo oggetto",
                },
                radialEnabled = {
                    description = "Attiva le azioni radiali della polizia.",
                    label = "Polizia radiale",
                },
                radialHandcuffKeybindCommand = {
                    description = "Nome del comando registrato per la chiave a manette.",
                    label = "Comando manette",
                },
                radialHandcuffKeybindDescription = {
                    description = "Descrizione mostrata per la chiave a manette.",
                    label = "Descrizione delle manette",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Abilita la chiave a manette diretta.",
                    label = "Portachiavi a manette",
                },
                radialHandcuffKeybindKey = {
                    description = "Tastiera usata per l'azione diretta delle manette.",
                    label = "Chiave a mano",
                },
                radialKeybindsEnabled = {
                    description = "Abilita le tastiere dirette per le azioni radiali selezionate.",
                    label = "Tastiere dirette",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Nome del comando registrato per la chiave non a mano.",
                    label = "Comando smonta manette",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Descrizione mostrata per la chiave smanicata.",
                    label = "Descrizione delle manette",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Abilita la chiave diretta smanicata.",
                    label = "Tastiera slacciata",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Tastiera usata per l'azione diretta di smontaggio delle manette.",
                    label = "Chiave slacciata",
                },
                socialWorkAssignRange = {
                    description = "Distanza massima per assegnare le attività lavori socialmente utili.",
                    label = "Intervallo di assegnazione",
                },
                socialWorkDeadlineDefault = {
                    description = "Termine predefinito lavori socialmente utili in minuti. Zero disabilita le scadenze.",
                    label = "Termine predefinito",
                },
                socialWorkDeadlineMax = {
                    description = "Termine massimo lavori socialmente utili in minuti. Zero disabilita il tappo.",
                    label = "Termine massimo",
                },
                socialWorkDeadlineMin = {
                    description = "Termine minimo lavori socialmente utili in minuti.",
                    label = "Termine minimo",
                },
                socialWorkDefaultTasks = {
                    description = "Quantità di attività predefinita quando si apre l'assegnazione lavori socialmente utili.",
                    label = "Attività predefinite",
                },
                socialWorkEnabled = {
                    description = "Abilita l'assegnazione lavori socialmente utili e i flussi di lavoro delle attività.",
                    label = "lavori socialmente utili",
                },
                socialWorkImprisonmentJailId = {
                    description = "carcere ID utilizzato quando le violazioni lavori socialmente utili portano ad imcarcerement.",
                    label = "ID Fallback carcere",
                },
                socialWorkImprisonmentMonths = {
                    description = "Mesi assegnati quando le violazioni lavori socialmente utili provocano carcere.",
                    label = "ImcarcereMENT mesi",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Nome ufficiale usato per i registri lavori socialmente utili imcarcerement.",
                    label = "ImcarcereMENT nome ufficiale",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Inviare i trasgressori in isolamento quando imcarcerement innesca.",
                    label = "Usare l'imcarcerement solitario",
                },
                socialWorkInactivityMinutes = {
                    description = "Minuti prima dell'inattività lavori socialmente utili si applicano le sanzioni.",
                    label = "Minuti di inattività",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Pena di task applicata quando un giocatore lavori socialmente utili rimane inattivo troppo a lungo.",
                    label = "Pena dell'inattività",
                },
                socialWorkMaxTasks = {
                    description = "Massimo compito selezionabile lavori socialmente utili.",
                    label = "Compiti massimi",
                },
                socialWorkMinTasks = {
                    description = "Attività lavori socialmente utili selezionabili al minimo.",
                    label = "Compiti minimi",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Consenti ai revisori di fatturare al proprietario registrato anche quando la targa catturata viene contrassegnata come falsa o clonata.",
                    label = "Consenti targhe sospette false",
                },
                speedCamProcessingMode = {
                    description = "Scegli addebito immediato, pagamento entro il termine configurato o sola verifica di un agente.",
                    label = "Modalità di elaborazione",
                    options = {
                        instant = "Addebita subito",
                        later = "Paga dopo (predefinito)",
                        review = "Solo verifica di un agente",
                    },
                },
                speedCamAdvancedPageSize = {
                    description = "Numero massimo di acquisizioni restituite per pagina tablet.",
                    label = "Controlla le dimensioni della pagina",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Lati veicolo le cui foto possono essere utilizzate per il riconoscimento della targa. Utilizzare anteriore e/o posteriore.",
                    itemLabel = "Lato",
                    label = "Lati riconosciuti",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Consenti l'approvazione solo dopo aver completato il caricamento delle foto dell'autovelox.",
                    label = "Richiedere prove fotografiche",
                },
                speedCamAdvancedReviewPermission = {
                    description = "È necessaria l'autorizzazione del menu Boss per approvare o scartare le acquisizioni. 18 è Gestisci fatturazione.",
                    label = "Controlla l'ID autorizzazione",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Conserva le acquisizioni la cui targa non è presente nel database dei veicoli immatricolati.",
                    label = "Conservare veicoli non immatricolati",
                },
                speedCamBillingEnabled = {
                    description = "Emettere fatture automatiche quando le telecamere di velocità catturano un reato corrispondente. Richiede la funzione di fatturazione globale per essere abilitato.",
                    label = "multe automatico",
                },
                speedCamBillingExcludedJobs = {
                    description = "Lavori che non ricevono mai bollette automatiche della telecamera di velocità.",
                    itemLabel = "Lavoro",
                    label = "Lavori esclusi",
                },
                speedCamBillingExcludedModels = {
                    description = "Nomi del veicolo spawn che non ricevono mai bollette automatiche della telecamera di velocità.",
                    itemLabel = "Modello",
                    label = "Modelli di veicoli esclusi",
                },
                speedCamBillingRules = {
                    description = "Le regole multa utilizzate dalle autovelox. La gamma di overage più stretta viene prima fatturata; se nessuna regola corrisponde, SpeedViolation reati viene usata come ripiego.",
                    label = "Regole multa",
                },
                speedCamCameraEaseMs = {
                    description = "Per quanto tempo la vista facilita l'angolo della fotocamera di velocità. Abbassare = swing più corto; troppo basso può misalignare la foto.",
                    label = "Facilità della telecamera (ms)",
                },
                speedCamCameraFov = {
                    description = "Campo visivo utilizzato per la cattura della fotocamera di velocità.",
                    label = "Telecamera FOV",
                },
                speedCamCheckIntervalMs = {
                    description = "Millisecondi tra le scansioni della telecamera di velocità.",
                    label = "Intervallo di controllo",
                },
                speedCamCooldownMs = {
                    description = "Millisecondi prima che la stessa telecamera di velocità può innescare di nuovo.",
                    label = "Trigger tempo di attesa",
                },
                speedCamDamageCooldownMs = {
                    description = "Millisecondi prima che il danno della telecamera di velocità possa essere nuovamente applicato.",
                    label = "Danni tempo di attesa",
                },
                speedCamDamagePerHit = {
                    description = "Danni alla durata applicati alle telecamere di velocità per colpo.",
                    label = "Danni per colpo",
                },
                speedCamDamagedModelThreshold = {
                    description = "Percentuale della durabilità massima alla quale o al di sotto della quale viene mostrato il modello danneggiato. Esempio: 50 con durabilità massima 200 cambia il modello a 100.",
                    label = "Soglia del modello danneggiato (%)",
                },
                speedCamDefaultLimit = {
                    description = "Limite predefinito della telecamera di velocità.",
                    label = "Limite di velocità predefinito",
                },
                speedCamDefaultName = {
                    description = "Nome visualizzato proposto quando si posiziona un autovelox. Può essere tradotto senza cambiare l'oggetto nell'inventario o il modello.",
                    label = "Nome predefinito",
                },
                speedCamDefaultTolerance = {
                    description = "Tolleranza predefinita della telecamera di velocità.",
                    label = "Tolleranza predefinita",
                },
                speedCamDisassembleDistance = {
                    description = "Distanza usata per smontare le telecamere di velocità.",
                    label = "Distanza di smontaggio",
                },
                speedCamEnabled = {
                    description = "Abilita le autovelox portatili.",
                    label = "Telecamere a velocità",
                },
                speedCamFlashColor = {
                    description = "Colore flash RGBA usato dalle fotocamere di velocità.",
                    label = "Colore flash",
                },
                speedCamFlashDurationMs = {
                    description = "Tempo di dissolvenza del flash della fotocamera a velocità rossa. Non impostare troppo basso o l'oscillazione della fotocamera diventa visibile.",
                    label = "Durata del flash (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distanza alla quale è indicata la salute della telecamera di velocità.",
                    label = "Distanza di visualizzazione della salute",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Millisecondi che la salute della telecamera di velocità rimane visibile.",
                    label = "Durata della visualizzazione della salute",
                },
                speedCamHealthTextOffset = {
                    description = "Spostamento verticale utilizzato per il testo di stato della telecamera di velocità.",
                    label = "Spostamento testo salute",
                },
                speedCamItem = {
                    description = "Nome interno esatto dell'oggetto nell'inventario, ad es. speedcam. Inserisci la chiave dell'oggetto, non il nome visualizzato; il negozio del lavoro deve fornire lo stesso oggetto.",
                    label = "Nome dell'oggetto autovelox",
                },
                speedCamMaintenanceThreshold = {
                    description = "Soglia di durata in cui si raccomanda la manutenzione della telecamera di velocità.",
                    label = "Soglia di mantenimento",
                },
                speedCamMaxDurability = {
                    description = "Massima durata delle autovelox installate.",
                    label = "Resistenza massima",
                },
                speedCamMaxLimit = {
                    description = "Limite massimo della telecamera di velocità configurabile.",
                    label = "Limite massimo di velocità",
                },
                speedCamMaxTolerance = {
                    description = "Massima tolleranza della telecamera di velocità configurabile.",
                    label = "Tolleranza massima",
                },
                speedCamPhotoLocale = {
                    description = "Locale opzionale usato per il timestamp sulle foto della fotocamera di velocità. Lascia vuoto per usare il locale locale del lettore flash.",
                    label = "Foto locale",
                },
                speedCamPhotoTimeZone = {
                    description = "Fuso orario opzionale usato per il timestamp sulle foto della telecamera di velocità. Lascia vuoto per usare il fuso orario locale del giocatore lampeggiato.",
                    label = "Fuso orario delle foto",
                },
                speedCamPoliceNotification = {
                    description = "Inviare una notifica centrale operativa quando le telecamere di velocità catturano le violazioni.",
                    label = "Allarme polizia di Speedcam",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Trattare la telecamera di velocità obiettivo centrale operativa come un gruppo di lavoro.",
                    label = "Il target centrale operativa è il gruppo",
                },
                speedCamPoliceNotificationJob = {
                    description = "Chiave di lavoro o di gruppo usata per le notifiche della telecamera di velocità centrale operativa.",
                    label = "Obiettivo centrale operativa",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Notificare solo gli obiettivi della telecamera di velocità centrale operativa che sono in servizio.",
                    label = "centrale operativa richiede servizio",
                },
                speedCamPoliceNotificationType = {
                    description = "centrale operativa gravity/type used for speed camera alerts.",
                    label = "Tipo centrale operativa",
                },
                speedCamPropModel = {
                    description = "Nome di spawn del modello integro dell'autovelox, ad es. sky_speedcam. Una preimpostazione seleziona anche i modelli danneggiato e distrutto. I modelli personalizzati devono essere disponibili nel gioco.",
                    label = "Modello Speedcam oggetto",
                    custom = "Modello personalizzato",
                    choose = "Scegli un modello",
                    preview = "Anteprima 3D",
                    customPlaceholder = "Nome spawn del prop",
                    previewDescription = "Mostra il prop scelto nel gioco. L'anteprima non salva le modifiche.",
                    invalidModel = "Inserisci prima un nome prop valido.",
                    modelMissing = "Questo modello non è disponibile nel gioco.",
                    previewFailed = "Impossibile aprire l'anteprima del modello.",
                    intact = "Modello intatto",
                    previewRequiresGame = "Apri /jobconfig in FiveM per vedere il prop dal vivo.",
                    previewHelp = "Frecce: sposta; PagSu/PagGiù: altezza; rotella: ruota; Invio: chiudi; Backspace: annulla.",
                    options = {
                        sky_speedcam = "Autovelox standard",
                        sky_germ_speedcam = "Autovelox tedesco",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Nome di spawn del modello danneggiato dell'autovelox, ad es. sky_speedcam2. Usa una variante corrispondente al modello integro.",
                    label = "Modello oggetto danneggiato",
                },
                speedCamPropModelDestroyed = {
                    description = "Nome del modello mostrato quando la durabilità raggiunge 0, ad es. sky_speedcam1. Usa una variante corrispondente al modello integro.",
                    label = "Modello oggetto distrutto",
                },
                speedCamRepairAnimDict = {
                    description = "dizionario animazione utilizzato durante la riparazione delle telecamere di velocità.",
                    label = "Riparazione animazione dict",
                },
                speedCamRepairAnimFlag = {
                    description = "Bandiera di animazione utilizzata durante la riparazione delle telecamere di velocità.",
                    label = "Repair animazione flag",
                },
                speedCamRepairAnimName = {
                    description = "Nome di animazione utilizzato durante la riparazione delle telecamere di velocità.",
                    label = "Nome dell'animazione di riparazione",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Millisecondi prima della riparazione della telecamera di velocità può essere annullato.",
                    label = "Riparazione annullare il ritardo",
                },
                speedCamRepairDistance = {
                    description = "Distanza usata per riparare le autovelox.",
                    label = "Distanza di riparazione",
                },
                speedCamRepairItem = {
                    description = "Nome interno esatto dell'oggetto per le riparazioni, ad es. fixtool. Inserisci la chiave dell'oggetto, non il nome visualizzato.",
                    label = "Nome dell'oggetto di riparazione",
                },
                speedCamRepairPerTick = {
                    description = "Durabilità ripristinato per velocità macchina fotografica riparazione tick.",
                    label = "Riparazione per segno di spunta",
                },
                speedCamRepairTickMs = {
                    description = "Millisecondi tra speed camera riparazione zecche.",
                    label = "Tick di riparazione",
                },
                speedCamStreamDistance = {
                    description = "Distanza dal giocatore in metri entro cui vengono caricati i modelli degli autovelox. Oltre questa distanza vengono scaricati; gli autovelox salvati restano posizionati.",
                    label = "Distanza flusso",
                },
                speedCamTriggerRadius = {
                    description = "Raggio di rilevamento in metri attorno all'autovelox per i veicoli che superano il limite.",
                    label = "Raggio di attivazione",
                },
                speedCamUseMph = {
                    description = "Visualizzazione e limiti di velocità di processo della fotocamera in MPH.",
                    label = "Usare MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Armi che possono danneggiare le telecamere di velocità mentre la restrizione è abilitata.",
                    itemLabel = "Arma",
                    label = "Armi ammesse",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Solo le armi elencate possono danneggiare le telecamere di velocità mentre questo è abilitato.",
                    label = "Limitazioni abilitate",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distanza in metri prima di ripulire gli avvisi della telecamera di velocità.",
                    label = "Distanza libera",
                },
                speedCameraAppDefaultApp = {
                    description = "Mostra l'app della telecamera di velocità come app predefinita per tablet.",
                    label = "App predefinita",
                },
                speedCameraAppDescription = {
                    description = "Descrizione mostrata per l'app del tablet della telecamera di velocità.",
                    label = "Descrizione",
                },
                speedCameraAppDeveloper = {
                    description = "Etichetta dello sviluppatore mostrata per l'app del tablet della telecamera di velocità.",
                    label = "Sviluppatore",
                },
                speedCameraAppEnabled = {
                    description = "Abilita l'app della telecamera della polizia.",
                    label = "App autovelox per tablet",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Intestazione del sopracciglio mostrato nell'app della fotocamera di velocità.",
                    label = "Sopracciglio dell'intestazione",
                },
                speedCameraAppHeaderTitle = {
                    description = "Titolo dell'intestazione mostrato nell'app della telecamera di velocità.",
                    label = "Titolo dell'intestazione",
                },
                speedCameraAppIcon = {
                    description = "Percorso icona utilizzato per l'app del tablet della telecamera di velocità.",
                    label = "Percorso icona",
                },
                speedCameraAppIdentifier = {
                    description = "Identifier interno per l'app del tablet della telecamera di velocità.",
                    label = "Numero di identificazione",
                },
                speedCameraAppInFrontDot = {
                    description = "Soglia del punto usata per determinare se una telecamera di velocità è di fronte al lettore.",
                    label = "Nella parte anteriore punto",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Velocità minima del veicolo in KMH prima che siano indicate le avvertenze.",
                    label = "Velocità minima del veicolo",
                },
                speedCameraAppName = {
                    description = "Visualizza il nome dell'app del tablet della telecamera di velocità.",
                    label = "Nome dell'applicazione",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distanza in metri prima di comunicare circa le autovelox vicine.",
                    label = "Notifica distanza",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Avvisa solo le autovelox mentre il giocatore è in un veicolo.",
                    label = "Solo su veicolo",
                },
                speedCameraAppOverlayBackground = {
                    description = "Colore di sfondo utilizzato per la sovrapposizione immagine targa.",
                    label = "Sfondo sovrapposto",
                },
                speedCameraAppOverlayBorder = {
                    description = "Colore bordo utilizzato per la sovrapposizione immagine targa.",
                    label = "Confine sovrapposto",
                },
                speedCameraAppOverlayColor = {
                    description = "Colore del testo utilizzato per la sovrapposizione immagine targa.",
                    label = "Colore sovrapposizione",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Abilita la sovrapposizione di immagini targa sulle immagini della fotocamera di velocità catturate.",
                    label = "Sovrapposto abilitato",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Scala caratteri utilizzata per la sovrapposizione immagine targa.",
                    label = "Sovrapporre la scala dei caratteri",
                },
                speedCameraAppOverlayX = {
                    description = "Posizione X in sovrapposizione normalizzata da sinistra a destra.",
                    label = "Sovrapposto X",
                },
                speedCameraAppOverlayY = {
                    description = "Posizione Y di sovrapposizione normalizzata dall'alto verso il basso.",
                    label = "Sovrapposto Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Avverti solo per le telecamere di velocità che sono di fronte al giocatore.",
                    label = "Richiedi davanti",
                },
                speedCameraAppRoute = {
                    description = "Percorso del router aperto dall'app del tablet della telecamera di velocità.",
                    label = "Via",
                },
                speedCameraAppSize = {
                    description = "Dimensioni di archiviazione riportate per l'app del tablet della telecamera di velocità.",
                    label = "Dimensione dell'applicazione",
                },
                speedCameraAppSoundCoord = {
                    description = "Riproduci i suoni di avvertimento della telecamera di velocità alle coordinate mondiali.",
                    label = "Coordinata del suono",
                },
                speedCameraAppSoundEnabled = {
                    description = "Abilita i suoni di avvertimento per l'app della telecamera di velocità.",
                    label = "Suono abilitato",
                },
                speedCameraAppSoundFrontend = {
                    description = "Riproduce i suoni di avvertimento della telecamera di velocità sul canale audio frontend.",
                    label = "Suono frontend",
                },
                speedCameraAppSoundLayers = {
                    description = "Numero di suoni di avviso a strati riprodotti dall'app della telecamera di velocità.",
                    label = "Livelli sonori",
                },
                speedCameraAppSoundName = {
                    description = "Nome del suono utilizzato per gli avvisi delle app della telecamera di velocità.",
                    label = "Nome sonoro",
                },
                speedCameraAppSoundRange = {
                    description = "Range utilizzato per i suoni di avvertimento dell'app della telecamera di velocità.",
                    label = "Campo sonoro",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Numero di volte il suono di avvertimento della telecamera di velocità si ripete.",
                    label = "Conteggio di ripetizione",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Millisecondi tra il suono di avvertimento della telecamera di velocità si ripete.",
                    label = "Ritardo ripetuto",
                },
                speedCameraAppSoundSet = {
                    description = "Set di suoni utilizzato per gli avvisi delle app della telecamera di velocità.",
                    label = "Suono impostato",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Account utilizzato per i pagamenti di abbonamento dell'app della telecamera di velocità del tablet.",
                    label = "Conto",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Abilita gli abbonamenti a pagamento per l'app della telecamera di velocità del tablet.",
                    label = "Abbonamento abilitato",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Giorni tra i rinnovamenti di abbonamento della telecamera della velocità del tablet.",
                    label = "Giorni di intervallo",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Prezzo addebitato per l'abbonamento all'app della telecamera della velocità del tablet.",
                    label = "Prezzo di abbonamento",
                },
                speedCameraAppThemeAccent = {
                    description = "Colore dell'accento utilizzato dall'app della telecamera di velocità.",
                    label = "Accensione",
                },
                speedCameraAppThemeBackground = {
                    description = "Sfondo lineare-gradiente utilizzato dall'app della telecamera di velocità.",
                    label = "Contesto",
                },
                speedCameraAppThemeBorder = {
                    description = "Colore bordo utilizzato dall'app fotocamera di velocità.",
                    label = "Bordo",
                },
                speedCameraAppThemeButtonText = {
                    description = "Colore del testo del pulsante utilizzato dall'app della fotocamera di velocità.",
                    label = "Testo pulsante",
                },
                speedCameraAppThemeDanger = {
                    description = "Colore di pericolo utilizzato dall'app della telecamera di velocità.",
                    label = "Pericolo",
                },
                speedCameraAppThemeGhost = {
                    description = "Colore del pulsante Ghost utilizzato dall'app della fotocamera di velocità.",
                    label = "Fantasma",
                },
                speedCameraAppThemeGhostText = {
                    description = "Colore del testo fantasma utilizzato dall'app della fotocamera di velocità.",
                    label = "Testo fantasma",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Colore gradiente morbido utilizzato dall'app della fotocamera di velocità.",
                    label = "Gradiente morbido",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Colore del bordo inattivo utilizzato dall'app della telecamera di velocità.",
                    label = "Bordo inattivo",
                },
                speedCameraAppThemeModal = {
                    description = "Colore di sfondo modale utilizzato dall'app fotocamera di velocità.",
                    label = "Modale",
                },
                speedCameraAppThemeMutedText = {
                    description = "Colore del testo mutato usato dall'app della telecamera di velocità.",
                    label = "Testo mutato",
                },
                speedCameraAppThemeOverlay = {
                    description = "Colore di sovrapposizione utilizzato dall'app della fotocamera di velocità.",
                    label = "Sovrapposto",
                },
                speedCameraAppThemePillText = {
                    description = "Colore del testo della pillola utilizzato dall'app della fotocamera di velocità.",
                    label = "Testo pillola",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Colore principale di avvio gradiente utilizzato dall'app della telecamera di velocità.",
                    label = "Principale da",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Colore di fine gradiente primario usato dall'app della telecamera di velocità.",
                    label = "Da primario a",
                },
                speedCameraAppThemeShadow = {
                    description = "Colore ombra utilizzato dall'app della fotocamera di velocità.",
                    label = "Ombra",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Colore dell'accento Spotlight utilizzato dall'app della fotocamera di velocità.",
                    label = "Faro",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Colore del testo sottile usato dall'app della telecamera di velocità.",
                    label = "Testo sottile",
                },
                speedCameraAppThemeSuccess = {
                    description = "Colore di successo utilizzato dall'app della fotocamera di velocità.",
                    label = "Successo",
                },
                speedCameraAppThemeSurface = {
                    description = "Colore superficie utilizzato dall'app della fotocamera di velocità.",
                    label = "Superficie",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Colore superficie morbida utilizzata dall'app fotocamera di velocità.",
                    label = "Superficie molle",
                },
                speedCameraAppThemeText = {
                    description = "Colore principale del testo utilizzato dall'app della telecamera di velocità.",
                    label = "Testo",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Colore di accento RGBA utilizzato per l'interfaccia utente di avvertimento della telecamera di velocità.",
                    label = "Accento RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Colore RGBA utilizzato per lo sfondo dell'interfaccia utente di avvertimento della telecamera di velocità.",
                    label = "Sfondo RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Colore icona RGBA utilizzato per l'interfaccia utente di avvertimento della telecamera di velocità.",
                    label = "Icona RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Colore del testo dell'icona RGBA usato per l'interfaccia utente della telecamera di velocità.",
                    label = "Testo icona RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Secondi l'interfaccia utente di avvertimento rimane visibile.",
                    label = "Secondi UI di avvertimento",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA colore del sottotesto utilizzato per l'interfaccia utente di avvertimento della telecamera di velocità.",
                    label = "Subtext RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Colore del testo RGBA utilizzato per l'interfaccia utente della telecamera di velocità.",
                    label = "Testo RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Colore del titolo RGBA utilizzato per l'interfaccia utente della telecamera di velocità.",
                    label = "Titolo RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Millisecondi tra i controlli di prossimità della striscia di spike.",
                    label = "Intervallo di controllo",
                },
                spikeStripsEnabled = {
                    description = "Abilita strisce di punta implementate.",
                    label = "Strisce di spike",
                },
                spikeStripsModels = {
                    description = "Modelli oggetto trattati come strisce a punta attive.",
                    itemLabel = "Modello",
                    label = "Modelli",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Millisecondi prima della scansione della striscia di punti ripercorre dopo nessuna corrispondenza.",
                    label = "Intervallo di riprova",
                },
                spikeStripsScanDistance = {
                    description = "Distanza usata per la scansione di strisce di spike vicine.",
                    label = "Distanza di scansione",
                },
                spikeStripsTriggerDistance = {
                    description = "Distanza alla quale i pneumatici vengono fatti esplodere da una striscia di spigolo.",
                    label = "Distanza di attivazione",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Etichetta della categoria usata per il creatore di stazioni blip.",
                    label = "Categoria Stazione blip",
                },
                stationCreatorBlipColor = {
                    description = "Mappa blip colore utilizzato per stazioni di polizia.",
                    label = "Colore stazione blip",
                },
                stationCreatorBlipScale = {
                    description = "Scala usata per la stazione di polizia blip.",
                    label = "Scala blip della stazione",
                },
                stationCreatorBlipShortRange = {
                    description = "Mostra stazione blip solo a breve distanza.",
                    label = "Stazione blip a corto raggio",
                },
                stationCreatorBlipSprite = {
                    description = "Mappa blip sprite usata per le stazioni di polizia.",
                    label = "Stazione blip sprite",
                },
                stationCreatorBlipUseStationName = {
                    description = "Usa il nome della stazione configurata per l'etichetta della mappa blip.",
                    label = "Usa nome stazione",
                },
                tabletAutoFillCitizens = {
                    description = "Precaricare il registro dei cittadini dalla banca dati quadro.",
                    label = "Riempimento automatico dei cittadini",
                },
                tabletAutoFillVehicles = {
                    description = "Precaricare il registro dei veicoli dal database quadro.",
                    label = "Veicoli di riempimento automatico",
                },
                tabletBolos = {
                    description = "Mostra l'app BOLO.",
                    label = "BOLO",
                },
                tabletCases = {
                    description = "Mostra l'app dei casi.",
                    label = "Casi",
                },
                tabletCitizens = {
                    description = "Mostra l'app del registro dei cittadini.",
                    label = "I cittadini",
                },
                tabletConfiscations = {
                    description = "Mostra il registro degli oggetti sequestrati durante le perquisizioni.",
                    label = "Sequestri",
                },
                tabletOffences = {
                    description = "Mostra l'app reati.",
                    label = "reati",
                },
                tabletPrison = {
                    description = "Mostra l'app carcere.",
                    label = "carcere",
                },
                tabletReportEnforcement = {
                    description = "Permettere agli agenti di assegnare reati di segnalare sospetti e emettere frasi multe o carcere dai report salvati.",
                    label = "Relazione sull'esecuzione",
                },
                tabletReports = {
                    description = "Mostra l'app dei report.",
                    label = "Relazioni",
                },
                tabletSocialWork = {
                    description = "Mostra l'app lavori socialmente utili.",
                    label = "lavori socialmente utili",
                },
                tabletSpeedcamReviews = {
                    description = "Mostra l'app di revisione avanzata degli autovelox quando la modalità avanzata è abilitata.",
                    label = "Recensioni sugli autovelox",
                },
                tabletVehicles = {
                    description = "Mostra l'app del registro veicoli.",
                    label = "Veicoli",
                },
                tabletWarrants = {
                    description = "Mostra l'app dei mandati.",
                    label = "Garanzie",
                },
                tabletWeapons = {
                    description = "Mostra l'app del registro armi.",
                    label = "Armi",
                },
                tackleCuffKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Ammanetta persona placcata",
                },
                tackleKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Placcaggio",
                },
                tackleReleaseKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Rilascia persona placcata",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Millisecondi prima di un altro allarme radar può essere sollevato.",
                    label = "Allarme tempo di attesa",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Le classi dei veicoli hanno permesso di usare il radar.",
                    label = "Classi di veicoli ammesse",
                },
                vehicleRadarAutoFastLock = {
                    description = "Segnala automaticamente i bersagli molto veloci nel radar.",
                    label = "Blocco automatico veloce",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Soglia di velocità utilizzata per serratura auto veloce.",
                    label = "Soglia di bloccaggio rapido",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Riduci limite",
                },
                vehicleRadarDefaultLimit = {
                    description = "Limite di velocità predefinito utilizzato dal radar del veicolo.",
                    label = "Limite radar predefinito",
                },
                vehicleRadarEnabled = {
                    description = "Abilita il radar del veicolo di pattuglia.",
                    label = "Radar del veicolo",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Aumenta limite",
                },
                vehicleRadarLimitStep = {
                    description = "La quantità è cambiata per ogni regolazione del limite radar.",
                    label = "Passo limite",
                },
                vehicleRadarLockFrontKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Blocco anteriore",
                },
                vehicleRadarLockRearKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Blocco posteriore",
                },
                vehicleRadarMaxLimit = {
                    description = "Limite di velocità massimo consentito nel radar del veicolo.",
                    label = "Limite massimo radar",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Massimo campo consentito per il radar targeting.",
                    label = "Grado massimo di passo",
                },
                vehicleRadarMinLimit = {
                    description = "Limite minimo di velocità consentito nel radar del veicolo.",
                    label = "Limite minimo radar",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Velocità minima prima che il radar consideri valido un bersaglio.",
                    label = "Velocità minima dell'obiettivo",
                },
                vehicleRadarModeFrontKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Modalità anteriore",
                },
                vehicleRadarModeRearKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Modalità posteriore",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Millisecondi tra le scansioni radar mentre il veicolo di pattuglia è moVINg.",
                    label = "Intervallo di scansione MoVINg",
                },
                vehicleRadarPassengerControl = {
                    description = "Permettere ai passeggeri di controllare il radar del veicolo.",
                    label = "Controllo dei passeggeri",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Permettere ai passeggeri di visualizzare i dati radar mirroring.",
                    label = "Specchio passeggeri",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Millisecondi tra aggiornamenti di sincronizzazione radar per i passeggeri.",
                    label = "Intervallo di sincronizzazione dei passeggeri",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Soglia di proiezione utilizzata nella valutazione degli obiettivi radar.",
                    label = "Soglia di proiezione",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Richiede una linea di visuale libera prima che i radar chiudano un bersaglio.",
                    label = "Richiede una linea di visuale",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Richiedere lo stato servizio prima di utilizzare il radar del veicolo.",
                    label = "Radar richiede servizio",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Millisecondi tra scansioni radar fisse.",
                    label = "Intervallo di scansione",
                },
                vehicleRadarScanRadius = {
                    description = "Raggio di scansione radar del veicolo.",
                    label = "Raggio di scansione",
                },
                vehicleRadarToggleKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Attiva/disattiva",
                },
                vehicleRadarUseMph = {
                    description = "Visualizzare i valori di velocità radar in MPH.",
                    label = "Utilizzi radar MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Millisecondi tra veicoli vicini piscina rinfresca.",
                    label = "Rinnovamento della piscina del veicolo",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Trasmetti/pausa anteriore",
                },
                vehicleRadarXmitRearKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Radar: Trasmetti/pausa posteriore",
                },
                wheelClampConsumeItem = {
                    description = "Rimuovere l'elemento bloccaruota dopo il posizionamento.",
                    label = "Consumare l'elemento morsetto",
                },
                wheelClampEnabled = {
                    description = "Abilitare l'azione bloccaruota.",
                    label = "bloccaruota",
                },
                wheelClampItem = {
                    description = "Elemento di inventario utilizzato per il posizionamento bloccaruota.",
                    label = "Elemento di bloccaggio",
                },
                wheelClampPropModel = {
                    description = "Modello oggetto utilizzato per il posto bloccaruota.",
                    label = "Modello pinza oggetto",
                },
                wheelClampRequireItem = {
                    description = "Richiedete l'articolo bloccaruota configurato. Tenetelo abilitato quando la modalità di utilizzo del morsetto è impostata su Inventario o su Entrambi.",
                    label = "Il clamp richiede l'elemento",
                },
                wheelClampRequireOnDuty = {
                    description = "Richiede lo stato servizio prima di posizionare bloccaruota.",
                    label = "La pinza richiede servizio",
                },
                wheelClampTyreDistance = {
                    description = "Distanza massima dal pneumatico durante la posa o la saldatura di un morsetto.",
                    label = "Distanza del pneumatico",
                },
                wheelClampUseItem = {
                    description = "Utilizzare radiale, inventario, o entrambi per il posizionamento bloccaruota. Inventario o Entrambi devono essere abbinati con Clamp richiede elemento.",
                    label = "Modalità di utilizzo del morsetto",
                    options = {
                        both = "Entrambi",
                        inventory = "Inventario",
                        radial = "Radiale",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Distanza massima dal veicolo bersaglio quando si posiziona un morsetto.",
                    label = "Distanza del veicolo",
                },
                wheelClampWeldBurstTyre = {
                    description = "Bruciare il pneumatico dopo che un morsetto è saldato.",
                    label = "Pneumatico a scoppio",
                },
                wheelClampWeldDurationMs = {
                    description = "Millisecondi necessari per rimuovere un morsetto mediante saldatura.",
                    label = "Durata della saldatura",
                },
                wheelClampWeldEnabled = {
                    description = "Lasciare che bloccaruota sia rimosso con un saldatore.",
                    label = "Saldatura del morsetto",
                },
                wheelClampWeldItem = {
                    description = "Articolo d'inventario richiesto per la saldatura del morsetto.",
                    label = "Elemento saldatore",
                },
                wheelClampWeldMinigame = {
                    description = "Richiede la saldatura a morsetto minigioco prima della rimozione completa.",
                    label = "Weld minigioco",
                },
                ziptiesConsumeItem = {
                    description = "Rimuovere un elemento fascettetie quando uno è applicato.",
                    label = "Consumare fascette",
                },
                ziptiesCutterConsumeItem = {
                    description = "Rimuovere l'elemento taglierina dopo il taglio fascette.",
                    label = "Consumare elemento taglierina",
                },
                ziptiesCutterEnabled = {
                    description = "Permettere ai tagliafili di rimuovere fascette.",
                    label = "tagliafascette",
                },
                ziptiesCutterItem = {
                    description = "Inventario usato per tagliare fascette.",
                    label = "Elemento taglierina",
                },
                ziptiesEnabled = {
                    description = "Abilita le azioni con fascette.",
                    label = "fascette",
                },
                ziptiesItem = {
                    description = "Inventario usato per le azioni zittie.",
                    label = "Elemento fascette",
                },
                ziptiesRequireHandsUp = {
                    description = "Richiedete uno stato di mani in alto prima di applicare fascette.",
                    label = "Mani in alto per fascette",
                },
                ziptiesRequireItem = {
                    description = "Richiede l'elemento fascettetie configurato.",
                    label = "fascette richiedono articolo",
                },
                ziptiesReturnOnRemove = {
                    description = "Restituire un elemento fascettetie quando fascette viene rimosso.",
                    label = "Ritorna fascette",
                },
                evidenceGsrDurationSeconds = {
                    description = "Secondi residui d'arma da fuoco rimangono sulle mani di un giocatore.",
                    label = "GSR durata",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Impedire GSR da essere applicato quando il tiratore indossa i guanti.",
                    label = "Guanti per proteggere le mani",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Armi che non applicano residui di polvere da sparo.",
                    label = "Armi ignorate",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisecondi tra i controlli di pulizia acqua/pioggia mentre GSR è attivo.",
                    label = "Intervallo di controllo del lavaggio",
                },
                evidenceGsrWashInRain = {
                    description = "Permetti alla pioggia di rimuovere residui di polvere da sparo.",
                    label = "Lavare sotto la pioggia",
                },
                evidenceGsrWashInWater = {
                    description = "Permettere all'acqua di rimuovere residui di polvere da sparo.",
                    label = "Lavare in acqua",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam mostra la targa falsa",
                    description = "Mostra la targa finta nella telecamera dell'elicottero.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Strumenti normali mostrano la targa finta",
                    description = "Visualizza la targa finta in strumenti di polizia standard.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar mostra la targa finta",
                    description = "Mostra la targa finta sul radar di bordo.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Lasciate che i sistemi di polizia leggano il finto statebag.",
                    label = "Riconosci le targhe false",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Chiave di stato dell'entità veicolo pubblicata da Mechanicjob.",
                    label = "Chiave di stato",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam mostra la targa falsa",
                    description = "Visualizza la targa finta in rapporti radar fissi.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Lasciare vuoto per consentire tutti i gradi delle professioni ammesse.",
                    label = "VIN gradi",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN professioni",
                    description = "professioni autorizzate ad utilizzare VIN verifica.",
                },
                fakePlateVinAudit = {
                    label = "Audit VIN controlli",
                    description = "Salva VIN controlli al registro di controllo.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN controllo abilitato",
                    description = "Abilita il comando di verifica del veicolo VIN.",
                },
                fakePlateVinCommand = {
                    label = "Comando VIN",
                    description = "Comando usato per verificare il VIN.",
                },
                fakePlateVinCooldown = {
                    label = "Cooldown VIN",
                    description = "Ritardo tra due controlli VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN distanza massima",
                    description = "Distanza massima tra l'ufficiale e il veicolo per verificare la sua VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Mostra indicatore falso",
                    description = "Mostra un indicatore quando un assegno rileva una targa falsa.",
                },
                fakePlateVinRequireDuty = {
                    label = "Richiede servizio",
                    description = "chiede all'ufficiale di essere in servizio per verificare un VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Richiede l'elemento scanner",
                    description = "Richiede l'oggetto dello scanner configurato per verificare un VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Elemento dello scanner",
                    description = "Articolo di inventario richiesto per verificare un VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Mettere il prigioniero a disoccupati quando sono in prigione.",
                    label = "Rimuove la professione in prigione",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Ripristinare la professione originale del prigioniero dopo il rilascio. Disabilitato a tenerli disoccupati.",
                    label = "Ripristina la professione originale",
                },
                primaryColor = {
                    description = "Colore predefinito per il gruppo dei lavori di polizia.",
                    label = "Colore primario",
                },
                tackleCommand = {
                    description = "Comando registrato per affrontare la persona più vicina. Inserire il nome del comando senza barra.",
                    label = "Comando tackle",
                },
                tackleCuffCommand = {
                    description = "Comando registrato per ammanettare la persona attualmente tenuta dopo un placcaggio. Inserire il nome del comando senza slash.",
                    label = "Comando del polsino",
                },
                tackleCuffDescription = {
                    description = "Descrizione visualizzata per l'attaccatura del bracciale nel menu legature FiveM.",
                    label = "Descrizione della chiave del polsino del tackle",
                },
                tackleDescription = {
                    description = "Descrizione visualizzata per l'attaccatura nel menu legature dei tasti FiveM.",
                    label = "Affronta la descrizione del keybind",
                },
                tackleEnabled = {
                    description = "Attivare affrontare la persona più vicina e tenerli sul terreno.",
                    label = "Affronta",
                },
                tackleMaxDistance = {
                    description = "Distanza massima dal bersaglio quando si avvia un placcaggio.",
                    label = "Distanza di risposta",
                },
                tackleNeedsSprint = {
                    description = "Chieda all'ufficiale di sbrigarsi prima di affrontare una persona.",
                    label = "L'attaccatura richiede sprint",
                },
                tackleReleaseCommand = {
                    description = "Comando registrato per il rilascio della persona attualmente tenuta dopo un placcaggio. Inserire il nome del comando senza barra.",
                    label = "Comando di rilascio del tackle",
                },
                tackleReleaseDescription = {
                    description = "Descrizione visualizzata per la rilegatura del rilascio del placcaggio nel menu legature dei tasti FiveM.",
                    label = "Descrizione del keybind del rilascio del tackle",
                },
                tackleRequireOnDuty = {
                    description = "Richiedere lo stato di servizio prima che un ufficiale possa affrontare una persona.",
                    label = "Tackle richiede il dovere",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Comando usato per aprire o chiudere l'editor di layout radar. Inserire il nome del comando senza barra.",
                    label = "Comando layout radar",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Comando usato per ripristinare il layout radar predefinito. Inserire il nome del comando senza barra.",
                    label = "Reimposta il comando di layout radar",
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
            warnings = {
                cuffsConsumeRequiresItem = "Consumare manette non ha effetto mentre il requisito elemento polsino è disabilitato.",
                wheelClampUseItemRequiresItem = "Modalità di utilizzo del morsetto Inventario o Entrambi richiedono Clamp richiede che l'elemento rimanga abilitato.",
                ziptiesConsumeRequiresItem = "Consumare fascette non ha effetto mentre il requisito dell'elemento fascettetie è disabilitato.",
            },
            locationDescriptions = {
                jail_public_blip = "La posizione viene ricavata automaticamente dal punto di spawn della prigione o, se non impostato, dal primo terminale della prigione.",
            },
        },
    },
}
