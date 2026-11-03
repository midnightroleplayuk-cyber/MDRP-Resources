JobConfigLocales["sky_ambulancejob:it"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Valutazioni mediche",
                sharedMedicalEvaluations = "Valutazioni mediche condivise",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Permetti respawn",
                        description = "Controlla se questo letto può essere selezionato per i giocatori respawn.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configurare lavori di ambulanze, letti ospedalieri, sistemi di morte, interazioni e impostazioni principali.",
                    title = "Lavori di ambulanza",
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
            features = {
                bleeding = {
                    description = "Abilita il sistema di spurgo.",
                    label = "Sanguinamento",
                },
                bodybags = {
                    description = "Abilita flussi di erogazione sacche mortuarie e sacca mortuaria.",
                    label = "sacche mortuarie",
                },
                consciousScenarioBloodPressure = {
                    description = "Lasciare controlli della pressione sanguigna mentre il paziente è cosciente.",
                    label = "Pressione sanguigna cosciente",
                },
                deathTimeout = {
                    description = "Abilita il flusso di timeout della morte.",
                    label = "Tempo di morte",
                },
                fractures = {
                    description = "Abilitare la manipolazione e il trattamento delle fratture.",
                    label = "Fratture",
                },
                knockout = {
                    description = "Abilita il sistema ad eliminazione diretta.",
                    label = "KO",
                },
                legShotRagdoll = {
                    description = "Fai cadere i giocatori quando sparato in zone di gamba o piedi configurati.",
                    label = "Ragdoll con la gamba sparata",
                },
                pain = {
                    description = "Abilita il sistema del dolore.",
                    label = "Dolore",
                },
                respawnInBed = {
                    description = "respawn ha rianimato i giocatori in un letto d'ospedale quando disponibili.",
                    label = "respawn a letto",
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
                gang = "Banda",
                allowInVehicle = "Consentire nel veicolo",
                allowMovement = "Permetti movimento",
                animDict = "Dizionario animazione",
                animFlag = "Flag animazione",
                animName = "Nome animazione",
                bleeding = "Sanguinamento",
                cause = "Causa",
                chance = "Possibilità",
                class = "Classe",
                companyPrice = "Prezzo aziendale",
                companyPricePerEmployee = "Prezzo per dipendente",
                copayPercent = "Ticket sanitario %",
                description = "Descrizione",
                dictionary = "Dizionario animazione",
                duration = "Durata",
                durationMs = "Durata (ms)",
                effect = "Effetto",
                effectDurationMs = "Durata dell'effetto (ms)",
                effectDurationSeconds = "Durata dell'effetto (secondi)",
                enabled = "Attivo",
                extractionType = "Tipo di estrazione",
                foreignObject = "Oggetto estraneo",
                heal = "Guarigione",
                id = "ID",
                itemName = "Nome dell'elemento",
                key = "Chiave",
                label = "Etichetta",
                lang = "Lingua",
                limit = "Limite",
                lossPerSecond = "Perdita al secondo",
                max = "Massimo",
                min = "Minimo",
                minGrade = "Grado minimo",
                minigame = "minigioco",
                model = "Modello oggetto",
                name = "Nome del lavoro",
                options = "Opzioni (tipi di selezione)",
                pain = "Dolore",
                pauseBleedingSeconds = "Sanguinamento in pausa (secondi)",
                price = "Prezzo",
                progressbarAllowInVehicle = "Progressi: consentire nel veicolo",
                progressbarAllowMovement = "Progresso: consentire il movimento",
                progressbarCanCancel = "I progressi possono essere cancellati",
                progressbarDisableCarMovement = "Progressi: disabilitare il movimento del veicolo",
                progressbarDisableCombat = "Progressi: disabilitare il combattimento",
                progressbarDisableMouse = "Progresso: disabilita il mouse",
                progressbarDisableMovement = "Avanzamento: disabilitare il movimento",
                progressbarDisableSprint = "Progresso: disabilita sprint",
                progressbarDuration = "Durata del progresso",
                progressbarEnabled = "Barra di avanzamento abilitata",
                progressbarLabel = "Etichetta barra di avanzamento",
                progressbarUseWhileDead = "Progresso utilizzabile mentre è morto",
                questions = "Domande",
                requireItems = "Richiede elementi",
                required = "Obbligatorio",
                requiresExtraction = "Richiede l'estrazione",
                requiresOpenWound = "Richiede una ferita aperta",
                sort = "Ordinanza",
                state = "Stato",
                stopBleeding = "Smettila di sanguinare",
                threshold = "Soglia",
                time = "Ora",
                type = "Tipo",
                useAnimation = "Usa animazione",
                value = "Valore",
                zone = "Zona",
                zones = "Zone",
                systolic = "Pressione sistolica",
                diastolic = "Pressione diastolica",
                cardiacArrest = "Arresto cardiaco",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Generale",
                },
                billingRange = {
                    label = "Ampiezza",
                },
                billingReasons = {
                    label = "Impostazioni della ragione",
                },
                billingUi = {
                    label = "interfaccia utente",
                },
                bodyBagAnimation = {
                    label = "Animazione",
                },
                bodyBagAttachGeneral = {
                    label = "Allega",
                },
                bodyBagAttachOffsets = {
                    label = "Spostamenti",
                },
                bodyBagAttachRotation = {
                    label = "Rotazione",
                },
                bodyBagDeliveryGeneral = {
                    label = "Generale",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Generale",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Pagamento",
                },
                bodyBagDeliveryUi = {
                    label = "interfaccia utente",
                },
                bodyBagGeneral = {
                    label = "Generale",
                },
                crutchAssign = {
                    label = "Assegnazione",
                },
                crutchDuration = {
                    label = "Durata",
                },
                crutchGeneral = {
                    label = "Generale",
                },
                crutchItems = {
                    label = "Voce",
                },
                crutchRestrictions = {
                    label = "Restrizioni",
                },
                damageHandlingBladeWeapons = {
                    label = "Armi a lama",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Lista nera sanguinante",
                },
                damageHandlingBleedingClasses = {
                    label = "Classi di sanguinamento",
                },
                damageHandlingBloodSystem = {
                    label = "Sistema ematologico",
                },
                damageHandlingDeathInjuries = {
                    label = "Lesioni da morte",
                },
                damageHandlingInjuryEffects = {
                    label = "Effetti del pregiudizio",
                },
                damageHandlingInjuryThresholds = {
                    label = "Soglie di pregiudizio",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll per colpo alla gamba",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zone ragdoll per colpo alla gamba",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Fratture dei danni dal vivo",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Possibilità di zona",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Apri stack della ferita",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limiti della zona",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Classi di ferita dal vivo",
                },
                damageHandlingMedications = {
                    label = "Farmaci",
                },
                damageHandlingPainClasses = {
                    label = "Classi di dolore",
                },
                damageHandlingPainEffects = {
                    label = "Effetti del dolore",
                },
                damageHandlingStatusEffects = {
                    label = "Effetti sullo stato",
                },
                damageHandlingVehicleDamage = {
                    label = "Danni al veicolo",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Cause di danno",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Ferite",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Protezione contro l'impatto del veicolo",
                },
                deathAnimal = {
                    label = "Ripiegamento animale",
                },
                deathAnimalAnimation = {
                    label = "Animazione animale",
                },
                deathAnimation = {
                    label = "Animazione",
                },
                deathGeneral = {
                    label = "Generale",
                },
                deathModels = {
                    label = "Sovrascritture di modelli",
                },
                deathScreenAiMedic = {
                    label = "Generale",
                },
                deathScreenAiMedicAvailability = {
                    label = "Disponibilità",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Comportamento",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Forza Revive",
                },
                deathScreenAiMedicPayment = {
                    label = "Pagamento",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Rivivere a letto",
                },
                deathScreenAiMedicSpawn = {
                    label = "spawn",
                },
                deathScreenAiMedicTiming = {
                    label = "Tempismo",
                },
                deathScreenControls = {
                    label = "Controlli",
                },
                deathScreenDamageLogs = {
                    label = "Log dei danni",
                },
                deathScreenDimensions = {
                    label = "Dimensioni",
                },
                deathScreenDispatch = {
                    label = "Centrale operativa",
                },
                deathScreenEarlyRespawn = {
                    label = "Generale",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Disponibilità",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Pagamento",
                },
                deathScreenGeneral = {
                    label = "Generale",
                },
                deathScreenHospitalSelection = {
                    label = "Selezione dell'ospedale",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Fotocamera selezione",
                },
                deathScreenInformation = {
                    label = "Generale",
                },
                deathScreenIntegration = {
                    label = "Integrazione",
                },
                deathScreenLogs = {
                    label = "Log delle morti",
                },
                deathScreenMinigame = {
                    label = "minigioco",
                },
                deathScreenRespawn = {
                    label = "Generale",
                },
                deathScreenRespawnAccounts = {
                    label = "Account",
                },
                deathScreenRespawnFallback = {
                    label = "Coordi di caduta",
                },
                deathScreenRespawnItems = {
                    label = "Elementi",
                },
                deathScreenRespawnWeapons = {
                    label = "Armi",
                },
                deathScreenStyle = {
                    label = "Stile schermata di morte",
                },
                deathScreenVoice = {
                    label = "Voce",
                },
                deathTimeoutGeneral = {
                    label = "Generale",
                },
                deathTimeoutWhitelist = {
                    label = "Lavori in whitelist",
                },
                diagnoseAnim = {
                    label = "Animazione",
                },
                diagnoseCpr = {
                    label = "RCP",
                },
                diagnoseFullHeal = {
                    label = "Guarigione completa",
                },
                diagnoseGeneral = {
                    label = "Generale",
                },
                doctorNpcAvailability = {
                    label = "Disponibilità",
                },
                doctorNpcGeneral = {
                    label = "Generale",
                },
                doctorNpcHealOther = {
                    label = "Guarire altri",
                },
                doctorNpcHealSelf = {
                    label = "Guarire Sé",
                },
                doctorNpcRanges = {
                    description = "Queste gamme non controllano quanto un giocatore deve essere vicino per aprire l'interazione NPC medico. Essi si applicano solo dopo l'apertura del menu medico.",
                    label = "Ampiezza",
                },
                doctorNpcRevive = {
                    label = "Rianima",
                },
                doctorNpcReviveInBed = {
                    label = "Rivivere a letto",
                },
                firstAidAnimation = {
                    label = "Animazione",
                },
                firstAidGeneral = {
                    label = "Generale",
                },
                firstAidLicenseAdd = {
                    label = "Licenza Aggiungi",
                },
                firstAidLicenseRemove = {
                    label = "Rimuovi licenza",
                },
                firstAidPosition = {
                    label = "Posizione",
                },
                healthInsuranceExpiration = {
                    label = "Scadenza",
                },
                healthInsuranceGeneral = {
                    label = "Generale",
                },
                healthInsurancePayment = {
                    label = "Pagamento",
                },
                healthInsuranceProviders = {
                    label = "Fornitori",
                },
                hospitalBedsBedAnimation = {
                    label = "Animazione del letto",
                },
                hospitalBedsCreator = {
                    label = "Creatore",
                },
                hospitalBedsDistances = {
                    label = "Distanze",
                },
                hospitalBedsGeneral = {
                    label = "Generale",
                },
                hospitalBedsGetupAnimation = {
                    label = "Getup Animazione",
                },
                hospitalBedsModels = {
                    label = "Modelli di letti",
                },
                hospitalBedsOffsets = {
                    label = "Spostamenti",
                },
                hospitalBlip = {
                    label = "Ospedale blip",
                },
                imagingGeneral = {
                    label = "Generale",
                },
                imagingRanges = {
                    label = "Ampiezza",
                },
                keybinds = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Assegnazione tasti",
                },
                knockoutGeneral = {
                    label = "Generale",
                },
                knockoutWeapons = {
                    label = "Armi",
                },
                medicCarryAttach = {
                    label = "Allega",
                },
                medicCarryAttachOffsets = {
                    label = "Spostamenti",
                },
                medicCarryAttachRotation = {
                    label = "Rotazione",
                },
                medicCarryCarrierAnimation = {
                    label = "Animazione del vettore",
                },
                medicCarryGeneral = {
                    label = "Generale",
                },
                medicCarryPassengerAnimation = {
                    label = "Animazione dei passeggeri",
                },
                medicCarryRestrictions = {
                    label = "Restrizioni",
                },
                medicRevivePersistence = {
                    label = "Generale",
                },
                medicalEvaluationRecipients = {
                    label = "Professioni beneficiarie",
                },
                medicalEvaluationSharing = {
                    label = "Campi condivisi",
                },
                medicalEvaluationTypes = {
                    label = "Tipi di valutazione",
                },
                medicalEvaluationsGeneral = {
                    label = "Generale",
                },
                medicalWearablesArmRestrictions = {
                    label = "Limitazioni del gesso al braccio",
                },
                medicalWearablesCasts = {
                    label = "Gessi",
                },
                medicalWearablesDuration = {
                    label = "Durata di utilizzo",
                },
                medicalWearablesGeneral = {
                    label = "Generale",
                },
                medicalWearablesHeadBandage = {
                    label = "Bendaggio alla testa",
                },
                medicalWearablesLegRestrictions = {
                    label = "Limitazioni del gesso alla gamba",
                },
                medicalWearablesNeckBrace = {
                    label = "Collare cervicale",
                },
                medicalWearablesOxygenMask = {
                    label = "Maschera d'ossigeno",
                },
                medicalWearablesPatientHud = {
                    label = "HUD paziente",
                },
                medicalWearablesRemoval = {
                    label = "Rimozione",
                },
                medicalWearablesSplints = {
                    label = "Stecche",
                },
                medicalWearablesTorsoBandage = {
                    label = "Bendaggio al torso",
                },
                minigamesCprGeneral = {
                    label = "Generale",
                },
                minigamesEnabled = {
                    label = "Abilitato",
                },
                minigamesVentilationGeneral = {
                    label = "Generale",
                },
                operationsAnesthesia = {
                    label = "Anestesia",
                },
                operationsDistances = {
                    label = "Distanze",
                },
                operationsDoctorAnimation = {
                    label = "Animazione del chirurgo",
                },
                operationsGeneral = {
                    label = "Generale",
                },
                operationsPatientAnimation = {
                    label = "Animazione del paziente",
                },
                operationsTrainingAnimation = {
                    label = "Animazione di addestramento",
                },
                propPlacement = {
                    label = "Posizionamento oggetti",
                },
                propPlacementItems = {
                    label = "Articoli oggetto",
                },
                publicTreatmentGeneral = {
                    label = "Generale",
                },
                publicTreatmentJobs = {
                    label = "Lavori ammessi",
                },
                publicTreatmentRequirements = {
                    label = "Requisiti",
                },
                reviveRewardGeneral = {
                    label = "Generale",
                },
                reviveRewardPayment = {
                    label = "Pagamento",
                },
                selfDiagnoseGeneral = {
                    label = "Generale",
                },
                stretcherAnimation = {
                    label = "Animazione",
                },
                stretcherCarryAttach = {
                    label = "Trasporta allegato",
                },
                stretcherFolded = {
                    label = "Variante piegato",
                },
                stretcherFoldedPatientAttach = {
                    label = "Allegato del paziente piegato",
                },
                stretcherGeneral = {
                    label = "Generale",
                },
                stretcherHelicopter = {
                    label = "Elicottero",
                },
                stretcherPatientAttach = {
                    label = "Collegamento del paziente",
                },
                stretcherTreatmentAnim = {
                    label = "Animazione",
                },
                stretcherVehicleAttach = {
                    label = "Allegato del veicolo",
                },
                stretcherVehicleLists = {
                    label = "Modelli di veicoli",
                },
                treatmentAnim = {
                    label = "Animazione",
                },
                treatmentEnable = {
                    label = "Abilita",
                },
                trunk = {
                    label = "bagagliaio",
                },
                vehiclePullGeneral = {
                    label = "Generale",
                },
                wheelchairAssign = {
                    label = "Assegnazione",
                },
                wheelchairDuration = {
                    label = "Durata",
                },
                wheelchairGeneral = {
                    label = "Generale",
                },
                wheelchairItems = {
                    label = "Voce",
                },
                wheelchairRestrictions = {
                    label = "Restrizioni",
                },
                xrayGeneral = {
                    label = "Generale",
                },
                xrayRanges = {
                    label = "Ampiezza",
                },
                appointmentsGeneral = {
                    label = "Generale",
                },
                appointmentsLimits = {
                    label = "Limiti",
                },
                appointmentsNotifications = {
                    label = "Notifiche",
                },
                appointmentsScheduling = {
                    label = "Programmazione",
                },
                healthCompatibility = {
                    label = "Compatibilità sanitaria",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Generale",
                },
                minigamesRandomization = {
                    label = "Casualizzazione",
                },
            },
            settingSections = {
                billing = "Fatturazione",
                bodyBag = "sacca mortuaria",
                damageHandling = "Gestione dei danni",
                death = "Morte",
                deathScreen = "schermata di morte",
                diagnose = "Diagnosi",
                doctorNpc = "Dottor NPC",
                general = "Generale",
                healthInsurance = "Assicurazione malattia",
                hospitalBeds = "Letti ospedalieri",
                knockout = "KO",
                medicCarry = "Trasporto medico",
                minigames = "minigioco",
                mobilityAid = "Aiuti alla mobilità",
                operations = "Operazioni",
                rewards = "Premi",
                treatment = "Trattamento",
                vehiclePull = "Pull del veicolo",
                medicalEvaluations = "Valutazioni mediche",
                organization = "Organizzazione",
            },
            settingSubsections = {
                aiMedic = "medico IA",
                anesthesia = "Anestesia",
                animation = "Animazione",
                animations = "Animazioni",
                attach = "Allega",
                bedAnimation = "Animazione del letto",
                blood = "Sangue",
                bodyBagDeliveryReward = "Consegna sacca mortuaria Premio",
                carrierAnimation = "Animazione del vettore",
                classification = "Classificazione",
                cpr = "RCP",
                crutch = "Stampella",
                deathInjuries = "Lesioni da morte",
                deathScreenStyle = "Stile schermata di morte",
                deathTimeout = "Tempo di morte",
                delivery = "Consegna",
                diagnoseAnim = "Animazione",
                dispatch = "Centrale operativa",
                earlyRespawn = "respawn precoce",
                effects = "Effetti",
                firstAid = "Primo soccorso",
                general = "Generale",
                getupAnimation = "Getup Animazione",
                imaging = "Diagnostica per immagini",
                information = "Informazioni",
                keybinds = "Assegnazione tasti",
                liveDamage = "Danni vivi",
                logs = "Log",
                medicRevivePersistence = "Generale",
                medicalWearables = "Dispositivi medici",
                medications = "Farmaci",
                minigame = "minigioco",
                passengerAnimation = "Animazione dei passeggeri",
                pricing = "Prezzi",
                propPlacement = "Posizionamento oggetti",
                publicTreatment = "Trattamento pubblico",
                respawn = "respawn",
                reviveInBed = "Rivivere a letto",
                reviveReward = "Ricompensa rianimazione",
                selfDiagnose = "Autodiagnosi",
                stretcher = "Barella",
                stretcherTreatmentAnim = "Animazione",
                thresholds = "Soglia",
                treatmentAnim = "Animazione",
                trunk = "bagagliaio",
                vehicleImpact = "Impatto del veicolo",
                ventilation = "Ventilazione",
                wheelchair = "Sedia a rotelle",
                xray = "Raggio X",
                appointments = "Nomine",
                bloodTransfusion = "Trasfusione di sangue",
                medicalEvaluations = "Valutazioni mediche",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor: Sposta su",
                    description = "Configures: Editor: Sposta su.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor: Sposta giù",
                    description = "Configures: Editor: Sposta giù.",
                },
                ambulanceEditorControl174 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 174",
                },
                ambulanceEditorControl175 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 175",
                },
                ambulanceEditorControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 177",
                },
                ambulanceEditorControl201 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 201",
                },
                ambulanceEditorControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 202",
                },
                ambulanceEditorControl21 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 21",
                },
                ambulanceEditorControl32 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 32",
                },
                ambulanceEditorControl33 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 33",
                },
                ambulanceEditorControl34 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 34",
                },
                ambulanceEditorControl35 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 35",
                },
                ambulanceEditorControl36 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 36",
                },
                ambulanceEditorControl37 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 37",
                },
                ambulanceEditorControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 38",
                },
                ambulanceEditorControl44 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Editor · Controllo 44",
                },
                ambulanceFirstAidControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Primo soccorso · Controllo 38",
                },
                ambulanceStretcherEditorControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 177",
                },
                ambulanceStretcherEditorControl201 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 201",
                },
                ambulanceStretcherEditorControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 202",
                },
                ambulanceStretcherEditorControl21 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 21",
                },
                ambulanceStretcherEditorControl241 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 241",
                },
                ambulanceStretcherEditorControl242 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 242",
                },
                ambulanceStretcherEditorControl25 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 25",
                },
                ambulanceStretcherEditorControl32 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 32",
                },
                ambulanceStretcherEditorControl33 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 33",
                },
                ambulanceStretcherEditorControl34 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 34",
                },
                ambulanceStretcherEditorControl35 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 35",
                },
                ambulanceStretcherEditorControl36 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 36",
                },
                ambulanceStretcherEditorControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 38",
                },
                ambulanceStretcherEditorControl44 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione · Controllo 44",
                },
                billingAccount = {
                    description = "Il conto della societa' di ripiego dei legacy usato per la fatturazione.",
                    label = "Conto",
                },
                billingCloseOnSuccess = {
                    description = "Chiudere l'interfaccia utente di fatturazione automaticamente dopo una fattura di successo.",
                    label = "Avvicinamento al successo",
                },
                billingCurrency = {
                    description = "Chiave di valuta opzionale utilizzata per i pagamenti di fatturazione.",
                    label = "Valuta",
                },
                billingCustomBillingReasons = {
                    description = "Permettere ai medici di inserire motivi di fatturazione personalizzati.",
                    label = "Motivi personalizzati",
                },
                billingDepositToSociety = {
                    description = "Depositare le entrate di fatturazione nel conto della società.",
                    label = "Deposito alla società",
                },
                billingEnabled = {
                    description = "Abilitare il sistema di fatturazione medica.",
                    label = "Abilitato",
                },
                billingMaxReasonLength = {
                    description = "Lunghezza massima dei motivi di fatturazione personalizzati.",
                    label = "Lunghezza massima della ragione",
                },
                billingMode = {
                    description = "Scegliere se le fatture mediche addebitano istantaneamente, richiedere la conferma, o utilizzare il sistema di fatturazione quadro.",
                    label = "Modalità fatturazione",
                    options = {
                        consent = "Paga o declina",
                        framework = "Bill quadro",
                        instant = "Onere istantaneo",
                    },
                },
                billingRange = {
                    description = "Gamma massima per trovare pazienti fatturabili.",
                    label = "Ampiezza",
                },
                billingReasonPresets = {
                    description = "Motivi di fatturazione predefiniti indicati nell'interfaccia utente di fatturazione.",
                    itemLabel = "Motivazione",
                    label = "Preimpostazioni della ragione",
                },
                billingRefreshSeconds = {
                    description = "Secondi tra fatturabili-giocatore rinfresca.",
                    label = "Aggiorna secondi",
                },
                bladeWeapons = {
                    description = "Nomi di armi o hash che dovrebbero essere classificati come danni da coltello invece di contundenti.",
                    itemLabel = "Arma",
                    label = "Armi a lama",
                },
                bleedingBlacklist = {
                    description = "Armi che non dovrebbero mai creare emorragia viva o ferite aperte.",
                    itemLabel = "Arma",
                    label = "Sanguinamento lista nera",
                },
                bleedingClassesProfiles = {
                    description = "Profili di gravità del sanguinamento e il loro tasso di perdita di sangue.",
                    label = "Lezioni di sanguinamento",
                },
                bloodSystemDebugLogInterval = {
                    description = "Secondi tra i messaggi di debug del sistema sanguigno.",
                    label = "Intervallo di log di debug",
                },
                bloodSystemMaxVolume = {
                    description = "Valore massimo del volume ematico utilizzato dal sistema dello stato del paziente.",
                    label = "Volume massimo",
                },
                bloodSystemRegenPerSecond = {
                    description = "Rigenerazione passiva del sangue applicata quando il paziente non sta attivamente sanguinando.",
                    label = "Regen al secondo",
                },
                bloodSystemTickIntervalMs = {
                    description = "Intervallo di zecche del server utilizzato per la perdita di sangue e gli aggiornamenti di recupero.",
                    label = "Intervallo di tick ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Soglia del volume sanguigno al di sotto della quale il paziente diventa incosciente.",
                    label = "Soglia inconscia",
                },
                bodyBagAnimationDict = {
                    description = "dizionario animazione utilizzato per trasportare una sacca mortuaria.",
                    label = "Dizionario animazione",
                },
                bodyBagAnimationEnabled = {
                    description = "Utilizzare un'animazione dedicata carry durante il trasporto di una sacca mortuaria.",
                    label = "Abilitato",
                },
                bodyBagAnimationFlag = {
                    description = "Bandiera TaskPlayAnim usata per l'animazione carry.",
                    label = "Flag animazione",
                },
                bodyBagAnimationName = {
                    description = "Clip per animazione utilizzata per trasportare una sacca mortuaria.",
                    label = "Nome animazione",
                },
                bodyBagAttachBone = {
                    description = "Nome dell'osso del ped o ID dell'osso usato per l'attacco sacca mortuaria.",
                    label = "Osso",
                },
                bodyBagAttachRx = {
                    description = "sacca mortuaria attaccare la rotazione X.",
                    label = "Allega RX",
                },
                bodyBagAttachRy = {
                    description = "sacca mortuaria attaccare la rotazione Y.",
                    label = "Allega RY",
                },
                bodyBagAttachRz = {
                    description = "sacca mortuaria attacca la rotazione Z.",
                    label = "Allega RZ",
                },
                bodyBagAttachX = {
                    description = "sacca mortuaria attacca lo spostamento X.",
                    label = "Allega X",
                },
                bodyBagAttachY = {
                    description = "Spostamento sacca mortuaria collegato Y.",
                    label = "Allega Y",
                },
                bodyBagAttachZ = {
                    description = "sacca mortuaria attaccare Z offset.",
                    label = "Allega Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Chiave locale usata per il prompt di aiuto consegna della sacca mortuaria.",
                    label = "Chiave dell'etichetta di aiuto",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distanza usata per la validazione consegna della sacca mortuaria.",
                    label = "Distanza interattiva",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Consegna sacco mortuario",
                },
                bodyBagDeliveryInteraction = {
                    description = "Interaction temtarga key usato per consegna della sacca mortuarias.",
                    label = "Interazione temtarga",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Richiedete ai medici di consegnare sacche mortuarie ai punti di consegna configurati.",
                    label = "Richiede la consegna",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Chiedere ai medici di essere in servizio prima della consegna sacca mortuaria.",
                    label = "Richiedi servizio attivo",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Chiave primaria dell'account utilizzata per i premi di consegna sacca mortuaria.",
                    label = "Conto",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Tipo di account primario utilizzato per premi di consegna sacca mortuaria.",
                    label = "Tipo di conto",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Ricompensa pagata per una consegna sacca mortuaria.",
                    label = "Quantità",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Chiave personalizzata opzionale utilizzata per premi di consegna sacca mortuaria.",
                    label = "Valuta",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Pagare una ricompensa configurata dopo una consegna sacca mortuaria è completato.",
                    label = "Abilitato",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Detrai i premi di consegna sacca mortuaria dalla società del lavoro condivisa prima di pagare il medico.",
                    label = "Pagare dalla società",
                },
                bodyBagEnabled = {
                    description = "Abilitare il sistema sacca mortuaria.",
                    label = "Abilitato",
                },
                bodyBagHidePatient = {
                    description = "Nascondere il paziente ped mentre la sacca mortuaria è collegato.",
                    label = "Nascondi il paziente",
                },
                bodyBagModel = {
                    description = "Modello oggetto utilizzato per sacche mortuarie.",
                    label = "Modello",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha ha fatto domanda al paziente mentre era nel cadavere.",
                    label = "Paziente alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Distanza massima per assegnare una stampella ad un altro giocatore.",
                    label = "Assegna distanza massima",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Disabilitare automaticamente la stampella quando l'assegnazione scade.",
                    label = "Auto-unequip alla scadenza",
                },
                crutchClipset = {
                    description = "Movement clipset applicato durante l'utilizzo della stampella.",
                    label = "Clipset",
                },
                crutchDefaultDurationMinutes = {
                    description = "Durata della stampella assegnata predefinita in minuti.",
                    label = "Durata predefinita",
                },
                crutchDisableSprint = {
                    description = "Block sprint mentre una stampella è attrezzata.",
                    label = "Disabilita sprint",
                },
                crutchDisableWeapons = {
                    description = "Bloccare l'uso dell'arma mentre una stampella è attrezzata.",
                    label = "Disabilita le armi",
                },
                crutchItemName = {
                    description = "Inventario usato per la stampella.",
                    label = "Nome dell'elemento",
                },
                crutchMaxDurationMinutes = {
                    description = "Durata massima dell'assegnazione delle stampelle consentita in minuti.",
                    label = "Durata massima",
                },
                crutchMinDurationMinutes = {
                    description = "Durata minima dell'assegnazione delle stampelle consentita in minuti.",
                    label = "Durata minima",
                },
                crutchProp = {
                    description = "Modello oggetto utilizzato per la stampella.",
                    label = "oggetto",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Secondi durante i quali i singoli colpi vengono raccolti in un messaggio.",
                    label = "Intervallo gruppo",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Numero massimo di singoli colpi in un messaggio Discord.",
                    label = "Colpi per messaggio",
                },
                damageLogsEnabled = {
                    description = "Invia a Discord i colpi non letali confermati dal server.",
                    label = "Log dei danni",
                },
                deathAnimalAnimationDictionary = {
                    description = "dizionario animazione utilizzato per l'animazione animale della morte.",
                    label = "Dizionario animale",
                },
                deathAnimalAnimationName = {
                    description = "Clip di animazione usata per l'animazione animale della morte.",
                    label = "Nome dell'animazione animale",
                },
                deathAnimalUseAnimation = {
                    description = "Permetti all'animale configurato di usare un'animazione di morte scritta.",
                    label = "Animazione animale",
                },
                deathAnimationDictionary = {
                    description = "dizionario animazione utilizzato per l'animazione di morte predefinita.",
                    label = "Dizionario animazione",
                },
                deathAnimationName = {
                    description = "Clip di animazione usato per l'animazione di morte predefinita.",
                    label = "Nome animazione",
                },
                deathInjuriesProfiles = {
                    description = "Profili di ferita applicati quando un giocatore muore per una causa specifica.",
                    itemLabel = "Lesione",
                    label = "Lesioni mortali",
                },
                deathModels = {
                    description = "Sovrascrivere il comportamento di animazione della morte per modello ped o hash modello.",
                    label = "Sovrascritture di modelli",
                },
                deathScreenAiMedicAccount = {
                    description = "Conto primario addebitato per il medico IA.",
                    label = "Conto",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Secondi aggiunti al timer dissanguato quando è richiesto il medico IA.",
                    label = "Aggiungi timer della morte",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Lasciare che il medico IA ravvivi le ferite fatali.",
                    label = "Consentire ferite fatali",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distanza alla quale il medico IA si ferma e si avvicina a piedi.",
                    label = "Distanza di avvicinamento",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "tempo di attesa prima che il medico IA possa essere richiamato.",
                    label = "Secondi tempo di attesa",
                },
                deathScreenAiMedicCurrency = {
                    description = "Chiave di valuta opzionale utilizzata per i pagamenti medico IA.",
                    label = "Valuta",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Valuta utilizzata per i pagamenti medico IA.",
                    label = "Importo della valuta",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Secondi prima delil medico IA despawn dopo la fine.",
                    label = "Ritardo di Despawn",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Ritardo prima dell'inizio delil medico IA centrale operativa.",
                    label = "Ritardo centrale operativa",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Velocità di trasmissione utilizzata dal veicoil medico IA.",
                    label = "Velocità di trasmissione",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Massimo tempo di guida prima che i trigger revivano la forza.",
                    label = "Timeout di guida",
                },
                deathScreenAiMedicEnabled = {
                    description = "Abilitare il flusso di salvataggio medico IA.",
                    label = "Abilitato",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Fallback account utilizzato quando il conto primario medico IA ha fondi insufficienti.",
                    label = "Account Fallback",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Forzare un rilancio se il medico IA non riesce a raggiungere il giocatore.",
                    label = "Forza rianimata abilitata",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "medico IA funziona solo mentre i medici su servizio sono al di sotto o al di sotto di questo numero.",
                    label = "Max medici online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Durata massima della missione prima dell'attivazione della forza.",
                    label = "Timeout missione",
                },
                deathScreenAiMedicPedModel = {
                    description = "Modello Ped utilizzato per il medico IA.",
                    label = "Modello Ped",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Destinazione utilizzata quando il giocatore a terra chiama il medico IA.",
                    label = "Richiedi destinazione",
                    options = {
                        hospital = "Ospedale",
                        location = "Posizione attuale",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Prezzo addebitato per chiamare il medico IA.",
                    label = "Prezzo",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Secondi dalla morte del paziente prima che un medico possa proporre l'invio remoto di un medico IA.",
                    label = "Attesa invio remoto",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Permettere ai medici di inviare il medico IA ad uno giocatore a terra dalla mappa centrale operativa e dal comando /aimedic.",
                    label = "invio remoto",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "medico IA centrale operativa remoto funziona solo mentre i medici servizio sono al di sotto o al di sotto di questo conteggio.",
                    label = "invio remoto max medici online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Destinazione utilizzata quando l'invio di un medico IA remoto viene accettato.",
                    label = "Destinazione invio remoto",
                    options = {
                        hospital = "Ospedale",
                        location = "Posizione attuale",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Secondi a disposizione del paziente per accettare l'offerta di un medico IA remoto.",
                    label = "Timeout offerta remota",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Distanza richiesta prima che il medico IA inizi reviVINg.",
                    label = "Distanza di ripresa",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Secondi spesi reviVINg il giocatore.",
                    label = "Durata di ripresa",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teletrasportare il giocatore in un letto d'ospedale invece di reviVINg sul posto.",
                    label = "Rivivere a letto",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Raggio di ricerca usato per trovare un letto rianimato.",
                    label = "Raggio di ricerca letto",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Secondi dopo la morte prima che il medico IA diventi disponibile.",
                    label = "Secondi fino a disponibili",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Raggio massimo medico IA spawn.",
                    label = "Raggio spawn max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Raggio minimo medico IA spawn.",
                    label = "Raggio spawn min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Modello di veicolo utilizzato dalil medico IA.",
                    label = "Modello di veicolo",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Modalità vocale inconscia: nessuna, ascolta o completa.",
                    label = "Modalità voce",
                    options = {
                        full = "completo",
                        listen = "ascolta",
                        none = "nessuno",
                    },
                },
                deathScreenAllowedControls = {
                    description = "ID di controllo che rimangono abilitati mentre sono incoscienti.",
                    label = "Controlli consentiti",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Giocatori respawn automatici se il timer dissanguato è già scaduto durante la disconnessione.",
                    label = "Riconnessione automatica respawn scaduta",
                },
                deathScreenBackgroundEnd = {
                    description = "Colore finale dello sfondo schermata di morte.",
                    label = "Fine del contesto",
                },
                deathScreenBackgroundStart = {
                    description = "Inizia il colore dello sfondo schermata di morte.",
                    label = "Inizia lo sfondo",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Secondi prima che scada il timer dissanguato.",
                    label = "Timer sbiadito",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensioni in cui il flusso schermata di morte respawn è bloccato.",
                    label = "Dimensioni bloccate",
                },
                deathScreenBorderColor = {
                    description = "Colore bordo utilizzato dallo schermata di morte.",
                    label = "Colore bordo",
                },
                deathScreenDispatchEnabled = {
                    description = "Inviare gli eventi centrale operativa dal flusso schermata di morte.",
                    label = "centrale operativa abilitato",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Destinatari alternativi se nessun destinatario principale è vivo e in servizio. Lascia vuoto per avvisare sempre i lavori principali.",
                    itemLabel = "Lavoro",
                    label = "Lavori di riserva",
                },
                deathScreenDispatchJobs = {
                    description = "Lavori allertati quando un giocatore a terra richiede aiuto.",
                    itemLabel = "Lavoro",
                    label = "Lavori allertati",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Conto primario addebitato per respawn precoce.",
                    label = "Conto",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Tenete a disposizione lo respawn precoce anche per ferite fatali.",
                    label = "Consentire ferite fatali",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Chiave di valuta opzionale usata per i primi pagamenti respawn.",
                    label = "Valuta",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Moneta utilizzata per i primi pagamenti respawn.",
                    label = "Importo della valuta",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Abilitare pagamento anticipato respawn.",
                    label = "Abilitato",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Fallback account utilizzato quando il conto primario ha fondi insufficienti.",
                    label = "Account Fallback",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Etichetta opzionale indicata per il pagamento anticipato respawn.",
                    label = "Etichetta di pagamento",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Prezzo addebitato per un anticipo respawn.",
                    label = "Prezzo",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Solo consentire respawn precoce quando nessun medico è in servizio.",
                    label = "Non richiedere alcun medico",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Secondi dopo la morte prima che respawn precoce diventa disponibile.",
                    label = "Secondi fino a disponibili",
                },
                deathScreenEnableKeyboard = {
                    description = "Permetti l'utilizzo della tastiera sullo schermata di morte.",
                    label = "Abilita tastiera",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Backend vocale esterno muto quando abilitato.",
                    label = "Sistema vocale esterno",
                    options = {
                        saltychat = "saltychat",
                        yaca = "già",
                    },
                },
                deathScreenFocusKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Schermata morte: interazione mouse",
                },
                deathScreenHandlingMode = {
                    description = "Usa l'animazione di morte statica o conserva la fisica ragdoll naturale finché il corpo non è stabile.",
                    label = "Gestione della morte",
                    options = {
                        natural = "Naturale",
                        static = "Statica",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Nascondere lo schermata di morte dopo che SPACE passa ai comandi di gioco; disattivare questo per mantenere visibile l'overlay legacy.",
                    label = "Nascondi sovrapposizione con i controlli di gioco",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Spostamento in altezza applicato al target di messa a fuoco della telecamera.",
                    label = "Altezza messa a fuoco",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Anteprima del campo visivo della fotocamera.",
                    label = "Campo visivo",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Spostamento orientamento utilizzato quando si posiziona la fotocamera di anteprima.",
                    label = "Spostamento orientamento",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Spostamento in altezza applicato alla fotocamera di anteprima.",
                    label = "Altezza della fotocamera",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Piazzola applicata alla fotocamera di anteprima.",
                    label = "Inclinazione",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distanza dalla telecamera di anteprima al punto di spawn.",
                    label = "Raggio della fotocamera",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Utilizzare una transizione liscia quando si apre la fotocamera di selezione dell'ospedale.",
                    label = "Transizione liscia",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Permettere ai giocatori di selezionare un ospedale prima di respawnING.",
                    label = "Selezione ospedaliera",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Mostra la selezione dell'ospedale solo quando esistono più di un ospedale.",
                    label = "Richiede più ospedali",
                },
                deathScreenInformationEnabled = {
                    description = "Mostra il blocco informazioni sullo schermata di morte.",
                    label = "Abilitato",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Mostra la causa di morte nel blocco informazioni schermata di morte.",
                    label = "Mostra la causa della morte",
                },
                deathScreenInformationShowInjuries = {
                    description = "Mostra le lesioni nel blocco informazioni schermata di morte.",
                    label = "Mostra le lesioni",
                },
                deathScreenInformationShowKiller = {
                    description = "Mostra il nome dell'assassino nel blocco informazioni schermata di morte.",
                    label = "Mostra l'assassino",
                },
                deathScreenInformationShowWeapon = {
                    description = "Mostra l'arma nel blocco informazioni schermata di morte.",
                    label = "Mostra arma",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gang autorizzate",
                    description = "Seleziona i nomi interni di gang o organizzazioni indipendenti. Un lavoro o gang corrispondente concede il permesso o l’esenzione. Il servizio è richiesto solo per i lavori.",
                    itemLabel = "Banda",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "I lavori hanno permesso di vedere informazioni estese schermata di morte.",
                    itemLabel = "Lavoro",
                    label = "Lavori in lista bianca",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Secondi massimi consentiti per il caricamento di ogni screenshot.",
                    label = "Timeout screenshot",
                },
                deathScreenLogScreenshots = {
                    description = "Carica le visuali della vittima e dell’uccisore confermato dopo il log testuale.",
                    label = "Screenshot",
                },
                deathScreenLogsEnabled = {
                    description = "Invia un log Discord ogni volta che un giocatore muore.",
                    label = "Log delle morti",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distanza in metri usato per contare un medico come vicino.",
                    label = "Raggio medico nelle vicinanze",
                },
                deathScreenMinigameEnabled = {
                    description = "Abilita lo schermata di morte minigioco.",
                    label = "Abilitato",
                },
                deathScreenMinigameUrl = {
                    description = "URL aperto per lo schermata di morte minigioco.",
                    label = "URL minigioco",
                },
                deathScreenMode = {
                    description = "Usa la schermata di morte integrata o un'integrazione esterna.",
                    label = "Modalità schermata",
                    options = {
                        external = "Esterna",
                        internal = "Interna",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Silenziare i sistemi vocali esterni mentre il lettore è morto.",
                    label = "Muto voce esterna",
                },
                deathScreenMutedTextColor = {
                    description = "Colore del testo mutato usato dallo schermata di morte.",
                    label = "Colore testo mutato",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Stampa motivi dettagliati su client e server mentre il corpo rimane in ragdoll.",
                    label = "Debug del ragdoll naturale",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Stabilizza automaticamente i corpi immobili oppure richiede a un soccorritore in servizio di metterli in posizione laterale di sicurezza.",
                    label = "Stabilizzazione naturale",
                    options = {
                        automatic = "Automatica",
                        medic = "Soccorritore richiesto",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Colore di sfondo del pannello utilizzato dallo schermata di morte.",
                    label = "Sfondo del pannello",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Bloccare respawn automatico dopo l'emorragia.",
                    label = "Prevenire l'auto-respawn",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Bloccare auto-respawn mentre un medico è nelle vicinanze.",
                    label = "Bloccare quando il medico nelle vicinanze",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Il blocco si riavvia dopo la scadenza del timer dissanguato.",
                    label = "Prevenire la ripresa alla scadenza",
                },
                deathScreenPrimaryColor = {
                    description = "Colore CSS base utilizzato per il tema schermata di morte.",
                    label = "Colore primario",
                },
                deathScreenPrimaryDark = {
                    description = "Colore opzionale dell'accento più scuro per lo schermata di morte.",
                    label = "Dark primario",
                },
                deathScreenPrimaryStrong = {
                    description = "Colore opzionale più forte per l'accento schermata di morte.",
                    label = "Resistenza primaria",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "orientamento utilizzato quando la stazione non ha orientamento demultad.",
                    label = "orientamento predefinito",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Fallback respawn orientamento utilizzato quando non esistono posizioni ospedaliere.",
                    label = "Fallback orientamento",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Coordinata Fallback respawn X utilizzata quando non esistono posizioni ospedaliere.",
                    label = "X di riserva",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Coordinata Y Fallback respawn usata quando non esistono posizioni ospedaliere.",
                    label = "Ripiegamento Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Coordinata Z Fallback respawn usata quando non esistono posizioni ospedaliere.",
                    label = "Z di riserva",
                },
                deathScreenRespawnHospitalId = {
                    description = "Scegliete un ospedale fisso per gli respawn. Lasciatelo vuoto per usare l'ospedale più vicino.",
                    label = "Ospedale respawn",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Rimuovere i saldi dei conti su respawn.",
                    label = "Rimuove account",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Nome account rimosso su respawn.",
                    itemLabel = "Conto",
                    label = "Nome account",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Rimuovere gli articoli di inventario su respawn.",
                    label = "Rimuovi elementi",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Inventario mantenuto su respawn.",
                    itemLabel = "Voce",
                    label = "Elementi ignorati",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Rimuovete le armi da arma su respawn.",
                    label = "Rimuovere le armi",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Armi tenute sullo respawn.",
                    itemLabel = "Arma",
                    label = "Armi ignorate",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teletrasportare il giocatore in un ospedale su respawn.",
                    label = "Teletrasporto in ospedale",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Riprendere il timer dissanguato dopo la riconnessione invece di ripristinarlo.",
                    label = "Riprendere la connessione",
                },
                deathScreenShadowLight = {
                    description = "Colore ombra morbido utilizzato dal schermata di morte.",
                    label = "Luce ombra",
                },
                deathScreenShadowMid = {
                    description = "Colore medio ombra utilizzato dallo schermata di morte.",
                    label = "Media ombra",
                },
                deathScreenShowNearestMedic = {
                    description = "Mostra il medico più vicino sullo schermata di morte.",
                    label = "Mostra il medico più vicino",
                },
                deathScreenTextColor = {
                    description = "Colore principale del testo utilizzato dallo schermata di morte.",
                    label = "Colore testo",
                },
                deathScreenTextShadow = {
                    description = "Colore dell'ombra del testo usato dallo schermata di morte.",
                    label = "Ombra di testo",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Applicare il timeout della morte dopo knockout rivive pure.",
                    label = "Applica al knockout",
                },
                deathTimeoutSeconds = {
                    description = "Secondi dopo un rilancio che il combattimento rimane disabile.",
                    label = "Secondi",
                },
                deathTimeoutShowUi = {
                    description = "Mostra il banner del conto alla rovescia quando è attivo.",
                    label = "Mostra UI",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gang autorizzate",
                    description = "Seleziona i nomi interni di gang o organizzazioni indipendenti. Un lavoro o gang corrispondente concede il permesso o l’esenzione. Il servizio è richiesto solo per i lavori.",
                    itemLabel = "Banda",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Lavori esenti dalle restrizioni relative al timeout della morte.",
                    itemLabel = "Lavoro",
                    label = "Lavori in lista bianca",
                },
                deathUseAnimation = {
                    description = "Riproduce l'animazione di morte configurata per i peds supportati.",
                    label = "Usa animazione",
                },
                diagnoseAnimClip = {
                    description = "Clip di animazione utilizzato durante l'apertura diagnostica. Lasciare vuoto per utilizzare uno scenario invece.",
                    label = "Nome animazione",
                },
                diagnoseAnimDict = {
                    description = "dizionario animazione utilizzato durante l'apertura diagnostica. Lasciare vuoto per utilizzare uno scenario invece.",
                    label = "Dizionario animazione",
                },
                diagnoseAnimScenario = {
                    description = "Scenario usato durante l'apertura diagnostica. Lasciare vuoto per usare dict + clip invece.",
                    label = "Scenario",
                },
                diagnoseCprAnimDict = {
                    description = "dizionario animazione usato per la RCP.",
                    label = "Dizionario animazione",
                },
                diagnoseCprAnimName = {
                    description = "Clip di animazione utilizzato per CPR.",
                    label = "Nome animazione",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Tempo di diagnosi continuo richiesto prima che compaia l'azione completa della guarigione.",
                    label = "Ritardo secondi",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Richiedi zaino di soccorso",
                    description = "Richiedi rescue_backpack per mostrare la barra degli strumenti di esame a sinistra. Disattiva per mostrarla sempre; i requisiti degli oggetti per i singoli strumenti restano validi.",
                },
                diagnoseFullHealEnabled = {
                    description = "Permettere la guarigione completa dopo una sessione di diagnosi continua.",
                    label = "Abilitato",
                },
                diagnoseInteractDistance = {
                    description = "Massima distanza necessaria per diagnosticare o impacchettare un paziente.",
                    label = "Distanza interattiva",
                },
                diagnosePatientMovementMode = {
                    label = "Movimento del paziente",
                    description = "Immobilizza il paziente mentre un altro giocatore tiene aperto il menu di trattamento, oppure consenti il movimento e chiudi il menu oltre la distanza di trattamento. L'autodiagnosi si configura separatamente.",
                    options = {
                        freeze = "Immobilizza il paziente",
                        distance = "Chiudi oltre il limite di distanza",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Distanza di trattamento (m)",
                    description = "Distanza massima tra chi esegue il trattamento e il paziente prima della chiusura del menu in modalità distanza. La distanza di apertura si configura separatamente.",
                },
                diagnoseKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione diagnosi",
                },
                diagnoseOpenDelayMs = {
                    description = "Ritardo prima che l'interfaccia utente diagnostica si apra.",
                    label = "Ritardo aperto ms",
                },
                diagnosePromptDistance = {
                    description = "Distanza usata per mostrare il prompt della diagnosi.",
                    label = "Distanza immediata",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Durata utilizzata per le animazioni di trattamento.",
                    label = "Durata del trattamento ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Depositare i pagamenti del medico nel conto della società condivisa al momento della ricarica diretta.",
                    label = "Aggiungi entrate alla società",
                },
                doctorNpcEnabled = {
                    description = "Abilitare il servizio medico NPC.",
                    label = "Abilitato",
                },
                doctorNpcHealOtherAccount = {
                    description = "Chiave primaria dell'account usata per caricare la guarigione di un altro giocatore.",
                    label = "Conto",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Tipo di account primario utilizzato per caricare la guarigione di un altro giocatore.",
                    label = "Tipo di conto",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Chiave di valuta personalizzata opzionale usata per caricare la guarigione di un altro giocatore.",
                    label = "Valuta",
                },
                doctorNpcHealOtherPrice = {
                    description = "Prezzo per guarire un altro giocatore al medico NPC.",
                    label = "Prezzo",
                },
                doctorNpcHealSelfAccount = {
                    description = "Chiave di conto primaria usata per caricare auto-guarigione.",
                    label = "Conto",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Tipo di conto primario utilizzato per caricare auto-guarigione.",
                    label = "Tipo di conto",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Chiave di valuta personalizzata opzionale utilizzata per caricare auto-guarigione.",
                    label = "Valuta",
                },
                doctorNpcHealSelfPrice = {
                    description = "Prezzo per guarirsi dal medico NPC.",
                    label = "Prezzo",
                },
                doctorNpcInteractionRange = {
                    description = "Come chiudere l'utente deve rimanere al medico NPC mentre si utilizza il menu medico aperto. Questo non cambia la distanza iniziale NPC prompt.",
                    label = "Gamma di interazione",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Il medico NPC funziona solo mentre i medici su servizio sono al di sotto di questo limite.",
                    label = "Max medici online",
                },
                doctorNpcPatientRange = {
                    description = "Quanto il paziente deve essere vicino al medico NPC per guarire altri o riprendere a lavorare dopo aver selezionato l'azione.",
                    label = "Gamma di pazienti",
                },
                doctorNpcPaymentMode = {
                    description = "Caricare immediatamente i giocatori o inviare una fattura.",
                    label = "Modalità di pagamento",
                    options = {
                        bill = "fattura",
                        remove = "rimuovi",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Usato solo per elencare i giocatori nelle vicinanze nel medico NPC UI. Non permette il trattamento da solo.",
                    label = "Intervallo di scansione del giocatore",
                },
                doctorNpcReviveAccount = {
                    description = "La chiave primaria dell'account usata per caricare il medico ravviva.",
                    label = "Conto",
                },
                doctorNpcReviveAccountType = {
                    description = "Tipo di conto primario utilizzato per addebitare medico rianima.",
                    label = "Tipo di conto",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Consente al medico NPC di rianimare ferite mortali o non rianimabili. Un tempo di dissanguamento scaduto continua a bloccare la rianimazione.",
                    label = "Consenti ferite mortali",
                },
                doctorNpcReviveCurrency = {
                    description = "La chiave di valuta personalizzata opzionale usata per caricare il medico rianima.",
                    label = "Valuta",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Posto rianimato giocatori nel letto più vicino ospedale dopo un medico rianimare.",
                    label = "Abilitato",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Distanza massima utilizzata per trovare un letto vicino ospedale per il medico rianima.",
                    label = "Raggio di ricerca",
                },
                doctorNpcRevivePrice = {
                    description = "Prezzo per far rivivere un giocatore al medico NPC.",
                    label = "Prezzo",
                },
                enforceMaxHealth = {
                    description = "Mantieni la massima salute del giocatore a 200. Disabilita questo quando un'altra risorsa gestisce la massima salute.",
                    label = "Forzare 200 massima salute",
                },
                firstAidActionDurationMs = {
                    description = "Quanto dura l'azione di primo soccorso.",
                    label = "Durata dell'azione ms",
                },
                firstAidAnimationDict = {
                    description = "dizionario animazione utilizzato durante l'azione di primo soccorso.",
                    label = "Dizionario animazione",
                },
                firstAidAnimationFlag = {
                    description = "Bandiera TaskPlayAnim usata durante l'azione di primo soccorso.",
                    label = "Flag animazione",
                },
                firstAidAnimationName = {
                    description = "Clip di animazione utilizzato durante l'azione di primo soccorso.",
                    label = "Nome animazione",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Secondi aggiunti al timer sanguinante del paziente dopo il primo soccorso.",
                    label = "Secondi di estensione del sanguinamento",
                },
                firstAidEnabled = {
                    description = "Abilitare la funzione di primo soccorso per i giocatori con licenza.",
                    label = "Primo soccorso abilitato",
                },
                firstAidLicense = {
                    description = "Nome della licenza quadro usato per convalidare l'accesso di primo soccorso.",
                    label = "Nome della licenza",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Lasciate che il personale dell'ambulanza dia le licenze approvate nelle cartelle dei pazienti. L'azione radiale dà solo la licenza di primo soccorso.",
                    label = "Aggiungi licenza abilitata",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Mostra l'azione add-license nel menu radiale.",
                    label = "Aggiungi licenza radiale",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Richiedere EMS servizio prima che l'azione di licenza aggiuntiva possa essere utilizzata.",
                    label = "Aggiungi la licenza richiede servizio",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Ulteriori licenze quadro personale ambulanza può dare o rimuovere nelle cartelle dei pazienti. La licenza di primo soccorso configurato è sempre incluso.",
                    itemLabel = "Licenza",
                    label = "Licenze aggiuntive per i pazienti",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Permetti al personale dell'ambulanza di rimuovere le licenze approvate nelle cartelle dei pazienti. L'azione radiale rimuove solo la licenza di primo soccorso.",
                    label = "Rimuovi licenza abilitata",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Mostra l'azione remove-license nel menu radiale.",
                    label = "Rimuovi la licenza radiale",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Richiede EMS servizio prima di poter utilizzare l'azione remove-license.",
                    label = "Rimuovi la licenza richiede servizio",
                },
                firstAidPositionChestOffset = {
                    description = "Spostamento del torace utilizzato durante l'allineamento per il primo soccorso.",
                    label = "Spostamento del torace",
                },
                firstAidPositionSideOffset = {
                    description = "Spostamento laterale utilizzato durante l'allineamento per il primo soccorso.",
                    label = "Spostamento laterale",
                },
                firstAidPositionZOffset = {
                    description = "Spostamento verticale utilizzato durante l'allineamento per il primo soccorso.",
                    label = "Spostamento Z",
                },
                firstAidRequireLicense = {
                    description = "Richiede la licenza di primo soccorso configurata prima che un giocatore possa utilizzare il primo soccorso.",
                    label = "Richiede la licenza",
                },
                firstAidTargetDistance = {
                    description = "Distanza massima consentita per l'uso di pronto soccorso.",
                    label = "Distanza obiettivo",
                },
                healthInsuranceAccount = {
                    description = "Chiave del conto Fallback utilizzata per i pagamenti assicurativi.",
                    label = "Conto",
                },
                healthInsuranceAccountType = {
                    description = "Tipo di conto primario utilizzato per i pagamenti assicurativi.",
                    label = "Tipo di conto",
                },
                healthInsuranceAvailableDays = {
                    description = "Durata assicurativa disponibile in giorni.",
                    label = "Giorni disponibili",
                },
                healthInsuranceCommand = {
                    description = "Comando di chat usato per aprire l'interfaccia utente dell'assicurazione sanitaria.",
                    label = "Comando",
                },
                healthInsuranceCurrency = {
                    description = "Chiave di valuta personalizzata opzionale utilizzata per i pagamenti assicurativi.",
                    label = "Valuta",
                },
                healthInsuranceEnabled = {
                    description = "Abilitare il sistema di assicurazione sanitaria.",
                    label = "Abilitato",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Consente ai dipendenti autorizzati di modificare i prezzi assicurativi dal tablet. Disattiva per applicare i prezzi della tabella dei fornitori qui sotto.",
                    label = "Gestione prezzi dal tablet",
                },
                healthInsuranceProviders = {
                    description = "Fornitori di assicurazioni offerti ai giocatori.",
                    itemLabel = "Fornitore",
                    label = "Fornitori",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Usa gli stessi fornitori e le stesse polizze per tutti i lavori registrati in questa risorsa ambulanza.",
                    label = "Condividi tra i lavori di ambulanza",
                },
                hospitalBedsBedAnimationDict = {
                    description = "dizionario animazione è in loop mentre il giocatore si trova sul letto. Lascia vuoto per usare il ripiego predefinito dell'animazione di morte.",
                    label = "Dizionario animazione",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Durata manuale opzionale per l'animazione del letto a loop. Utilizzata solo quando viene configurata un'animazione del letto personalizzata.",
                    label = "Durata ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Bandiera TaskPlayAnim utilizzata per l'animazione del letto a loop. Usata solo quando viene configurata un'animazione del letto personalizzata.",
                    label = "Flag animazione",
                },
                hospitalBedsBedAnimationName = {
                    description = "Clip di animazione in loop mentre il giocatore si trova sul letto. Lascia vuoto per usare il ripiego predefinito di animazione di morte.",
                    label = "Nome animazione",
                },
                hospitalBedsBreakDistance = {
                    description = "Distanza dopo la quale il giocatore è costretto fuori dal letto.",
                    label = "Distanza di interruzione",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Modello di anteprima prenotato utilizzato nell'editor di posizione letto ospedale.",
                    label = "Modello ping creatore",
                },
                hospitalBedsEnabled = {
                    description = "Abilitare interazioni con letto ospedaliero configurato.",
                    label = "Abilitato",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "dizionario animazione giocato quando il giocatore si alza dal letto. Lascia vuoto per utilizzare il comportamento di stand-up predefinito.",
                    label = "Dizionario animazione",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Durata manuale opzionale per l'animazione get-up. Usata solo quando viene configurata un'animazione get-up personalizzata.",
                    label = "Durata ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Bandiera TaskPlayAnim usata per l'animazione get-up. Usata solo quando viene configurata un'animazione get-up personalizzata.",
                    label = "Flag animazione",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Clip di animazione giocato quando il giocatore si alza dal letto. Lascia vuoto per utilizzare il comportamento di stand-up predefinito.",
                    label = "Nome animazione",
                },
                hospitalBedsHeadingOffset = {
                    description = "orientamento offset applicato quando si posiziona il giocatore sul letto.",
                    label = "Spostamento orientamento",
                },
                hospitalBedsHeightOffset = {
                    description = "Spostamento verticale applicato quando si posiziona il giocatore sul letto.",
                    label = "Spostamento altezza",
                },
                hospitalBedsInteractDistance = {
                    description = "Distanza massima richiesta per utilizzare un letto d'ospedale.",
                    label = "Distanza interattiva",
                },
                hospitalBedsInteractKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Interazione letto ospedaliero",
                },
                hospitalBedsModels = {
                    description = "Modelli di oggetti mondiali trattati come letti ospedalieri utilizzabili.",
                    itemLabel = "Modello",
                    label = "Modelli di letti",
                },
                hospitalBedsSearchRadius = {
                    description = "Raggio utilizzato per trovare vicino letto oggetti o letti configurati.",
                    label = "Raggio di ricerca",
                },
                hospitalBlipColor = {
                    description = "blip colore ID utilizzato per mappa ospedaliera blip.",
                    label = "Colore",
                },
                hospitalBlipEnabled = {
                    description = "Visualizza mappa ospedaliera blip per posizioni ospedaliere configurate.",
                    label = "Abilitato",
                },
                hospitalBlipName = {
                    description = "Fallback hospital blip nome usato quando non è disponibile il nome della stazione.",
                    label = "Nome",
                },
                hospitalBlipScale = {
                    description = "Scala blip utilizzata per la mappa ospedaliera blip.",
                    label = "Scala",
                },
                hospitalBlipSprite = {
                    description = "blip sprite ID usato per la mappa ospedaliera blip.",
                    label = "Folletto",
                },
                imagingInteractionRange = {
                    description = "Distanza massima dalla stazione di rappresentazione per l'operatore.",
                    label = "Gamma di interazione",
                },
                imagingPatientRange = {
                    description = "Distanza massima dalla stazione di imaging per il paziente.",
                    label = "Gamma di pazienti",
                },
                imagingScanDurationSeconds = {
                    description = "Durata in secondi per i risultati della TAC e della risonanza magnetica.",
                    label = "Durata scansione",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Moltiplicatore solo visivo per gli effetti di sovrapposizione di sanguinamento.",
                    label = "Intensità di sovrapposizione di sanguinamento",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Moltiplicatore solo visivo per gli effetti dello schermo del dolore.",
                    label = "Intensità dello schermo del dolore",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "La percentuale minima di salute massima persa in un singolo colpo prima di sanguinamento e dolore vengono applicati.",
                    label = "Sanguinamento/dolore percentuale minima",
                },
                injuryThresholdRespectArmor = {
                    description = "Salta l'emorragia e il dolore quando il colpo è stato assorbito da armatura.",
                    label = "Respect Armor",
                },
                knockoutRegenerateDamage = {
                    description = "Rigenerare i danni alla knockout dopo la scadenza del timer respawn.",
                    label = "Rigenerare i danni",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Secondi su cui il danno da knockout è guarito indietro.",
                    label = "Durata della rigenerazione",
                },
                knockoutRespawnSeconds = {
                    description = "Secondi prima di un respawn automatico quando un giocatore è steso.",
                    label = "Secondi respawn",
                },
                knockoutWeapons = {
                    description = "Nomi di armi o hash che dovrebbero innescare knockout invece del pieno schermata di morte.",
                    itemLabel = "Arma",
                    label = "Armi",
                },
                legShotRagdollChance = {
                    description = "C'è la probabilita' che un colpo corrispondente faccia scattare una bambola.",
                    label = "Possibilità",
                },
                legShotRagdollCooldownMs = {
                    description = "Ritardo minimo tra i raggdolls sparati alle gambe.",
                    label = "tempo di attesa ms",
                },
                legShotRagdollDebug = {
                    description = "Log leg-shot decisioni ragdoll per il test.",
                    label = "Debug",
                },
                legShotRagdollDurationMs = {
                    description = "Quanto dura la bambola.",
                    label = "Durata ms",
                },
                legShotRagdollFeet = {
                    description = "Permetti ai colpi ai piedi di innescare il ragdoll.",
                    label = "Piedi",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Skip ragdolls quando l'armatura ha assorbito il colpo.",
                    label = "Ignora i colpi di armatura",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Permettere colpi sulla gamba inferiore sinistra.",
                    label = "Parte inferiore sinistra della gamba",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Permettere colpi sulla parte superiore sinistra della gamba.",
                    label = "Parte superiore sinistra",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Permettere solo gli spari per innescare il ragdoll.",
                    label = "Solo colpi di arma da fuoco",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Permettere colpi sulla parte inferiore destra della gamba.",
                    label = "Parte inferiore destra della gamba",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Permettere colpi sulla parte superiore destra della gamba.",
                    label = "Parte superiore destra della gamba",
                },
                liveDamageFracturesChance = {
                    description = "È probabile che un danno cosciente abbia colpito una frattura.",
                    label = "Possibilità",
                },
                liveDamageFracturesEnabled = {
                    description = "Lascia che i danni coscienti colpiscano le fratture.",
                    label = "Abilitato",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Percentuale minima di salute massima persa con un singolo colpo prima che possa verificarsi una frattura in tempo reale.",
                    label = "Percentuale minima di danno",
                },
                liveDamageFracturesZones = {
                    description = "Possibilità di frattura per zona per danni vivi.",
                    label = "Possibilità di zona",
                },
                liveOpenWoundStacksDefault = {
                    description = "Massimo stack di ferite aperte per zona quando non esiste un bypass per zona.",
                    label = "Limite predefinito",
                },
                liveOpenWoundStacksZones = {
                    description = "Limiti opzionali di pila di ferita aperta per zona.",
                    itemLabel = "Zona",
                    label = "Limiti di zona",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Classe di sanguinamento iniziale applicata per causa di danno vivo.",
                    label = "Classe di sanguinamento delle ferite vive",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Lasciare che il vettore entri e guidi un veicolo senza far cadere il paziente.",
                    label = "Consentire il vettore nel veicolo",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Permetti di portare i giocatori coscienti.",
                    label = "Consenti obiettivi coscienti",
                },
                medicCarryAllowSprint = {
                    description = "Permetti di sprint durante il trasporto di un paziente.",
                    label = "Permetti sprint",
                },
                medicCarryAttachBone = {
                    description = "Indice osseo usato per collegare il giocatore trasportato.",
                    label = "Fissare l'osso",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Trasportate la rotazione del passo.",
                    label = "Inclinazione",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Trasportare la rotazione del rotolo dell'attacco.",
                    label = "Rotolo",
                },
                medicCarryAttachOffsetsX = {
                    description = "Trasporta l'offset X dell'attaccante.",
                    label = "Spostamento X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Portare l'attacco Y offset.",
                    label = "Spostamento Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Trasportate la rotazione dell'imbardata.",
                    label = "Imbardata",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Trasportare l'attacco Z offset.",
                    label = "Spostamento Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "dizionario animazione usato dal medico durante il trasporto di un paziente.",
                    label = "Dizionario animazione",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Bandiera TaskPlayAnim utilizzata dal medico trasportare animazione.",
                    label = "Flag animazione",
                },
                medicCarryCarrierAnimationName = {
                    description = "Clip di animazione utilizzato dal medico durante il trasporto di un paziente.",
                    label = "Nome animazione",
                },
                medicCarryEnabled = {
                    description = "Abilita il sistema di trasporto medico.",
                    label = "Abilitato",
                },
                medicCarryMaxDistance = {
                    description = "Distanza massima richiesta per prelevare un paziente.",
                    label = "Distanza massima",
                },
                medicCarryPassengerAnimationDict = {
                    description = "dizionario animazione usato dal paziente trasportato.",
                    label = "Dizionario animazione",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Bandiera TaskPlayAnim usata dall'animazione del paziente trasportato.",
                    label = "Flag animazione",
                },
                medicCarryPassengerAnimationName = {
                    description = "Clip di animazione utilizzata dal paziente trasportato.",
                    label = "Nome animazione",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Riapplicare l'animazione della morte dopo aver fatto cadere un paziente incosciente.",
                    label = "Riapplica l'animazione della morte",
                },
                medicCarryRequireOnDuty = {
                    description = "Solo i medici servizio possono avviare un trasporto.",
                    label = "Richiedi servizio attivo",
                },
                medicReviveAllowFatalWounds = {
                    description = "Consente ai medici in servizio di trattare e rianimare ferite mortali o non rianimabili. Un tempo di dissanguamento scaduto continua a bloccare la rianimazione.",
                    label = "Consenti ferite mortali",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Mantenere le lesioni irrisolte dopo il trattamento o checklist si riavvia.",
                    label = "Mantenere le lesioni",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Mantenere i valori del dolore dopo il trattamento o la lista di controllo si riavvia quando le lesioni sono conservate.",
                    label = "Mantieni il dolore",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Distanza massima usata per elencare i giocatori vicini durante la creazione di una valutazione medica.",
                    label = "Distanza pazienti vicini",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Lavori per i quali è possibile emettere e condividere valutazioni mediche.",
                    label = "Lavori destinatari",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Consenti ai lavori destinatari di vedere la data di nascita del paziente.",
                    label = "Condividi data di nascita",
                },
                medicalEvaluationShareConclusion = {
                    description = "Consenti ai lavori destinatari di vedere la conclusione medica.",
                    label = "Condividi conclusione",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Consenti ai lavori destinatari di vedere quali tipi di valutazione sono stati eseguiti.",
                    label = "Condividi tipi di valutazione",
                },
                medicalEvaluationShareFullName = {
                    description = "Consenti ai lavori destinatari di vedere il nome completo del paziente.",
                    label = "Condividi nome completo",
                },
                medicalEvaluationShareGender = {
                    description = "Consenti ai lavori destinatari di vedere il genere del paziente.",
                    label = "Condividi genere",
                },
                medicalEvaluationShareHeight = {
                    description = "Consenti ai lavori destinatari di vedere l'altezza del paziente.",
                    label = "Condividi altezza",
                },
                medicalEvaluationShareHobbies = {
                    description = "Consenti ai lavori destinatari di vedere le attività nel tempo libero e gli hobby del paziente.",
                    label = "Condividi tempo libero e hobby",
                },
                medicalEvaluationShareIssuer = {
                    description = "Mostra il nome dell’autore. Il lavoro emittente resta visibile nella cartella dei documenti condivisi.",
                    label = "Condividi i dati dell’autore",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Consenti ai lavori destinatari di vedere l'ID personale del paziente.",
                    label = "Condividi ID personale",
                },
                medicalEvaluationShareProfession = {
                    description = "Consenti ai lavori destinatari di vedere la professione del paziente.",
                    label = "Condividi professione",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Consenti ai lavori destinatari di vedere le domande del questionario e le risposte registrate.",
                    label = "Condividi domande e risposte",
                },
                medicalEvaluationShareResult = {
                    description = "Consenti ai lavori destinatari di vedere se la valutazione è in attesa, superata o non superata.",
                    label = "Condividi risultato",
                },
                medicalEvaluationShareWeight = {
                    description = "Consenti ai lavori destinatari di vedere il peso del paziente.",
                    label = "Condividi peso",
                },
                medicalEvaluationTypes = {
                    description = "Configura tipi di valutazione, domande, tipi di risposta e lo stato attivo di ogni domanda.",
                    label = "Tipi di valutazione e questionari",
                    options = {
                        boolean = "Sì / No",
                        boolean_text = "Sì / No con dettagli",
                        date = "Data",
                        multi_select = "Scelta multipla",
                        number = "Numero",
                        rating = "Valutazione",
                        select = "Scelta singola",
                        text = "Testo",
                        textarea = "Area di testo",
                        time = "Ora",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Abilita le valutazioni mediche nel tablet dell'ambulanza.",
                    label = "Attivo",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Offre una durata permanente che resta attiva finché un medico non rimuove il dispositivo.",
                    label = "Consenti fino alla rimozione",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Impedisce gli attacchi corpo a corpo mentre è indossato un gesso al braccio.",
                    label = "Disattiva corpo a corpo",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Forza il combattimento disarmato e impedisce di cambiare arma mentre è indossato un gesso al braccio.",
                    label = "Disattiva armi",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Applica limitazioni al combattimento mentre è indossato un gesso al braccio.",
                    label = "Attivo",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Tratta la frattura corrispondente quando viene applicato un gesso o una stecca.",
                    label = "Integrazione delle fratture",
                },
                medicalWearablesCastsEnabled = {
                    description = "Consente gessi su braccia e gambe sinistre e destre.",
                    label = "Attivo",
                },
                medicalWearablesCastsItem = {
                    description = "Oggetto dell'inventario consumato quando viene applicato un gesso.",
                    label = "Oggetto",
                },
                medicalWearablesCastsMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per i gessi.",
                    label = "Minigioco",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Durata predefinita del dispositivo medico in minuti. Imposta 0 per mantenerlo fino alla rimozione.",
                    label = "Minuti predefiniti",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Durate dei dispositivi medici mostrate ai medici, in minuti.",
                    label = "Opzioni di durata",
                },
                medicalWearablesEnabled = {
                    description = "Abilita i modelli di gesso, stecca, bendaggio, collare e maschera d'ossigeno nell'interfaccia di trattamento.",
                    label = "Attivo",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Frequenza con cui vengono rimossi i dispositivi medici temporizzati scaduti.",
                    label = "Controllo scadenza (secondi)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Consente il modello di bendaggio alla testa.",
                    label = "Attivo",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Oggetto dell'inventario consumato per un bendaggio alla testa.",
                    label = "Oggetto",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per un bendaggio alla testa.",
                    label = "Minigioco",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Impedisce di saltare mentre è indossato un gesso alla gamba.",
                    label = "Disattiva salto",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Impedisce di correre mentre è indossato un gesso alla gamba.",
                    label = "Disattiva corsa",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Forza il set di animazioni di movimento ferito mentre è indossato un gesso alla gamba.",
                    label = "Forza camminata ferita",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Sostituisce la velocità di movimento mentre è indossato un gesso alla gamba.",
                    label = "Velocità di movimento",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Applica limitazioni al movimento mentre è indossato un gesso alla gamba.",
                    label = "Attivo",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Consente il modello di collare cervicale.",
                    label = "Attivo",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Oggetto dell'inventario consumato per un collare cervicale.",
                    label = "Oggetto",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per un collare cervicale.",
                    label = "Minigioco",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Consente il modello di maschera d'ossigeno.",
                    label = "Attivo",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Oggetto dell'inventario consumato per una maschera d'ossigeno.",
                    label = "Oggetto",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per una maschera d'ossigeno.",
                    label = "Minigioco",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Mostra al paziente gli ausili medici attivi e il tempo di utilizzo rimanente.",
                    label = "Attivato",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Sceglie dove visualizzare l'HUD degli ausili medici del paziente.",
                    label = "Posizione",
                    options = {
                        ["bottom-center"] = "In basso al centro",
                        ["bottom-left"] = "In basso a sinistra",
                        ["bottom-right"] = "In basso a destra",
                        center = "Centro",
                        ["center-left"] = "Centro sinistra",
                        ["center-right"] = "Centro destra",
                        ["top-center"] = "In alto al centro",
                        ["top-left"] = "In alto a sinistra",
                        ["top-right"] = "In alto a destra",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Ripristina gessi, stecche, collari cervicali e bendaggi al torso temporizzati dopo riconnessioni e riavvii della risorsa.",
                    label = "Persistenza dei dispositivi medici",
                },
                medicalWearablesRemoval = {
                    description = "Consente ai medici di rimuovere gessi, stecche, collari e bendaggi al torso attivi dall'interfaccia di trattamento.",
                    label = "Rimozione da parte del medico",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Mostra la rimozione dei dispositivi medici con lo strumento configurato nell'interfaccia di trattamento.",
                    label = "Trattamento di rimozione attivo",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Strumento riutilizzabile dell'inventario necessario per rimuovere un dispositivo medico.",
                    label = "Oggetto",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minigioco per rimuovere gli ausili medici (cast_saw predefinito).",
                    label = "Minigioco",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Consente stecche a tracolla sul braccio sinistro e destro.",
                    label = "Attivo",
                },
                medicalWearablesSplintsItem = {
                    description = "Oggetto dell'inventario consumato quando viene applicata una stecca.",
                    label = "Oggetto",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per le stecche.",
                    label = "Minigioco",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Consente il modello di bendaggio al torso.",
                    label = "Attivo",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Oggetto dell'inventario consumato per un bendaggio al torso.",
                    label = "Oggetto",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Minigioco di trattamento esistente utilizzato per un bendaggio al torso.",
                    label = "Minigioco",
                },
                medicationsProfiles = {
                    description = "Voci di farmaci dichiarativi utilizzate per il trattamento e l'automedicazione.",
                    itemLabel = "Farmaci",
                    label = "Farmaci",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Abilitare la maschera valvola borsa minigioco.",
                    label = "Maschera valvola borsa",
                },
                minigamesCastSawEnabled = {
                    description = "Abilita il minigioco della sega per rimuovere gli ausili medici.",
                    label = "Sega per gesso",
                },
                minigamesBandageWrapEnabled = {
                    description = "Abilitare la fasciatura minigioco.",
                    label = "Fascia dell'involucro",
                },
                minigamesBloodPressureEnabled = {
                    description = "Abilitare la pressione sanguigna minigioco.",
                    label = "Pressione sanguigna",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Abilita la trasfusione di sangue minigioco.",
                    label = "Trasfusione di sangue",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Abilitare l'estrazione del proiettile minigioco.",
                    label = "Estrazione di proiettili",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Respiri necessari durante ogni fase di ventilazione.",
                    label = "Respiri per ciclo",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Secondi per completare un set di compressione.",
                    label = "Durata della compressione per set",
                },
                minigamesCprCompressionWindow = {
                    description = "Spostamento consentito quando si preme un battito di compressione.",
                    label = "Finestra di compressione",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Abilitare lo stadio di compressione minigioco.",
                    label = "Compressioni CPR",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Numero di compressioni per set.",
                    label = "Compressione per set",
                },
                minigamesCprCycles = {
                    description = "Quanti cicli di RCP sono necessari per finire lo minigioco.",
                    label = "Cicli",
                },
                minigamesCprEnabled = {
                    description = "Abilitare il RCP minigioco.",
                    label = "RCP",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Conto alla rovescia prima che inizino le compressioni CPR.",
                    label = "Introduzione secondi di ritardo",
                },
                minigamesCprMaxMisses = {
                    description = "Misss permesso prima di fallire il RCP minigioco.",
                    label = "Manca il massimo",
                },
                minigamesCprSetsPerCycle = {
                    description = "Quanti set di compressione funzionano prima di uno stadio del respiro.",
                    label = "Set per ciclo",
                },
                minigamesCprVentilationEnabled = {
                    description = "Abilitare lo stadio di ventilazione CPR minigioco.",
                    label = "Ventilazione CPR",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Abilitare il misuratore di glucosio minigioco.",
                    label = "Misuratore di glucosio",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Abilitare la misurazione dell'impulso minigioco.",
                    label = "Misurazione dell'impulso",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Abilitare il pulsantimetro minigioco.",
                    label = "Ossimetro a impulsi",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Abilitare l'infusione salina minigioco.",
                    label = "Infusione salina",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Secondi prima che un tentativo di ventilazione si spenga. Impostare 0 per disabilitare.",
                    label = "Secondi tempo di respirazione",
                },
                minigamesVentilationEnabled = {
                    description = "Abilitare la ventilazione minigioco.",
                    label = "Ventilazione",
                },
                minigamesVentilationTolerance = {
                    description = "Tolleranza alla distanza del pixel quando si traccia l'onda del flusso d'aria.",
                    label = "Tolleranza",
                },
                operationsBreakDistance = {
                    description = "Distanza massima dei partecipanti dalla sala prima dell'interruzione dell'intervento.",
                    label = "Distanza di interruzione",
                },
                operationsDoctorAnimationDict = {
                    description = "Dizionario di animazioni GTA usato dal chirurgo durante un intervento reale.",
                    label = "Dizionario animazione chirurgo",
                },
                operationsDoctorAnimationFlag = {
                    description = "Flag di animazione GTA applicato al chirurgo durante un intervento reale.",
                    label = "Flag animazione chirurgo",
                },
                operationsDoctorAnimationName = {
                    description = "Clip di animazione usata dal chirurgo durante un intervento reale.",
                    label = "Nome animazione chirurgo",
                },
                operationsEnabled = {
                    description = "Abilita le sale operatorie e gli interventi chirurgici.",
                    label = "Abilitato",
                },
                operationsFadeInMs = {
                    description = "Durata in millisecondi della dissolvenza in entrata del paziente al risveglio.",
                    label = "Dissolvenza risveglio (ms)",
                },
                operationsFadeOutMs = {
                    description = "Durata in millisecondi della dissolvenza in uscita del paziente durante l'anestesia.",
                    label = "Dissolvenza anestesia (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Tempo massimo senza un’azione valida nel minigioco prima dell’interruzione della sessione.",
                    label = "Timeout inattività (s)",
                },
                operationsInteractDistance = {
                    description = "Distanza massima per visualizzare e usare le interazioni della sala operatoria.",
                    label = "Distanza di interazione",
                },
                operationsInteractKey = {
                    description = "ID del controllo usato per interagire con il tavolo operatorio e la posizione del chirurgo.",
                    label = "Tasto di interazione",
                },
                operationsPatientAnimationDict = {
                    description = "Dizionario di animazioni GTA usato mentre il paziente è in anestesia generale.",
                    label = "Dizionario animazione paziente",
                },
                operationsPatientAnimationFlag = {
                    description = "Flag di animazione GTA applicato all'animazione del paziente sdraiato.",
                    label = "Flag animazione paziente",
                },
                operationsPatientAnimationName = {
                    description = "Clip di animazione usata mentre il paziente è in anestesia generale.",
                    label = "Nome animazione paziente",
                },
                operationsPatientRange = {
                    description = "Raggio massimo usato per rilevare un paziente sdraiato sul tavolo operatorio.",
                    label = "Raggio del paziente",
                },
                operationsRequireOnDuty = {
                    description = "Richiede che i chirurghi siano in servizio prima di usare una sala operatoria.",
                    label = "Richiedi servizio",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Tempo massimo in cui il chirurgo può restare nella selezione dell’operazione prima dell’interruzione della sessione.",
                    label = "Timeout selezione (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Dizionario di animazioni GTA usato per l'addestramento chirurgico senza paziente.",
                    label = "Dizionario animazione addestramento",
                },
                operationsTrainingAnimationFlag = {
                    description = "Flag di animazione GTA applicato all'animazione di addestramento chirurgico.",
                    label = "Flag animazione addestramento",
                },
                operationsTrainingAnimationName = {
                    description = "Clip di animazione usata per l'addestramento chirurgico senza paziente.",
                    label = "Nome animazione addestramento",
                },
                painClassesProfiles = {
                    description = "Soglie di dolore, etichette ed effetti post-elaborazione.",
                    label = "Classi di dolore",
                },
                painEffectsMinPainLevel = {
                    description = "Livello minimo di dolore prima dell'inizio degli effetti dello schermo del dolore.",
                    label = "Livello minimo di dolore",
                },
                primaryColor = {
                    description = "Colore principale per l'interfaccia EMS e il gruppo dei lavori di soccorso.",
                    label = "Colore primario",
                },
                propPlacementConsumeItem = {
                    description = "Consumare l'elemento di inventario corrispondente quando lo oggetto è posizionato.",
                    label = "Consuma elemento",
                },
                propPlacementEnabled = {
                    description = "Consente di posizionare EMS oggetti configurato da elementi di inventario utilizzabili.",
                    label = "Abilitato",
                },
                propPlacementItemNames = {
                    description = "Mappa modelli EMS oggetto per l'inventario dei nomi degli elementi per il posizionamento basato sugli elementi.",
                    label = "Denominazione degli elementi oggetto",
                },
                propPlacementRequireOnDuty = {
                    description = "Richiede al giocatore di essere in servizio prima di posizionare EMS oggetti.",
                    label = "Richiedi servizio attivo",
                },
                propPlacementReturnItem = {
                    description = "Riporre l'articolo consumato quando viene rimosso uno oggetto inserito.",
                    label = "Restituisci l'elemento su rimuovi",
                },
                propPlacementVehicleAccess = {
                    description = "Permetti a bagagliaio oggetti di aprire il flusso di posizionamento invece dell'utilizzo solo di elementi.",
                    label = "Accesso al veicolo",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Consentire il trattamento pubblico su giocatori consapevoli.",
                    label = "Permettere pazienti coscienti",
                },
                publicTreatmentAllowedGangs = {
                    label = "Gang consentite",
                    description = "Seleziona i nomi interni di gang o organizzazioni indipendenti. Un lavoro o gang corrispondente concede il permesso o l’esenzione. Il servizio è richiesto solo per i lavori. Gradi minimi facoltativi. Un elenco vuoto consente tutti i gradi. I requisiti degli oggetti restano validi.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Lavori che possono utilizzare il trattamento pubblico senza essere SME.",
                    label = "Lavori ammessi",
                },
                publicTreatmentEnabled = {
                    description = "Abilitare il trattamento pubblico per i soccorritori non EMS con accesso valido.",
                    label = "Trattamento pubblico abilitato",
                },
                publicTreatmentInteractDistance = {
                    description = "Distanza massima richiesta per iniziare il trattamento pubblico.",
                    label = "Distanza interattiva",
                },
                publicTreatmentKeybind = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Presta primo soccorso",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Mostra il messaggio di trattamento e abilita il relativo tasto. Disattiva questa opzione se usi export o un menu radiale personalizzato.",
                    label = "Interazione da tastiera abilitata",
                },
                publicTreatmentPromptDistance = {
                    description = "Distanza usata per mostrare la pronta cura del pubblico.",
                    label = "Distanza immediata",
                },
                publicTreatmentRequireAllItems = {
                    description = "Richiede ogni articoil medico elencato invece di uno solo.",
                    label = "Richiede tutti gli elementi",
                },
                publicTreatmentRequiredItems = {
                    description = "Elementi di inventario che contano come attrezzi di trattamento pubblico validi.",
                    itemLabel = "Voce",
                    label = "Articoli richiesti",
                },
                reviveRewardAccount = {
                    description = "Chiave primaria del conto usata per rilanciare i pagamenti di ricompensa.",
                    label = "Conto",
                },
                reviveRewardAccountType = {
                    description = "Tipo di conto primario utilizzato per rilanciare i pagamenti di ricompensa.",
                    label = "Tipo di conto",
                },
                reviveRewardAmount = {
                    description = "Ricompensa pagata al medico per una rianimazione.",
                    label = "Quantità",
                },
                reviveRewardCurrency = {
                    description = "Chiave di valuta personalizzata opzionale utilizzata per rilanciare i pagamenti di ricompensa.",
                    label = "Valuta",
                },
                reviveRewardEnabled = {
                    description = "Pagare una ricompensa configurata dopo che un medico rianimato di successo.",
                    label = "Abilitato",
                },
                reviveRewardPayFromSociety = {
                    description = "Deduct ravvivare ricompense dalla società del lavoro condivisa prima di pagare il medico.",
                    label = "Pagare dalla società",
                },
                selfDiagnoseCommand = {
                    description = "Comando di chat usato per aprire autodiagnosi.",
                    label = "Comando",
                },
                selfDiagnoseEnabled = {
                    description = "Permettere ai giocatori di aprire l'interfaccia utente diagnostica su se stessi.",
                    label = "Autodiagnosi abilitata",
                },
                selfDiagnoseKeybind = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Autodiagnosi",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Ritardo prima che l'interfaccia utente autodiagnostica si apra.",
                    label = "Ritardo aperto ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Limitare l'autodiagnosi ai soli lavori medici.",
                    label = "Richiede lavoro medico",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Non congelare il giocatore mentre autodiagnosi.",
                    label = "Salta il blocco su se stessi",
                },
                statusEffectsProfiles = {
                    description = "Effetti dello schermo configurati e soglie per sanguinamento, sangue basso, fame e sete.",
                    label = "Effetti sullo stato",
                },
                stretcherAnimDict = {
                    description = "dizionario animazione utilizzato durante il trasporto della barella.",
                    label = "Animazione dict",
                },
                stretcherAnimName = {
                    description = "Nome dell'animazione utilizzato durante il trasporto della barella.",
                    label = "Nome animazione",
                },
                stretcherAttachRx = {
                    description = "Portare la rotazione dell'attacco X per la barella.",
                    label = "Allega RX",
                },
                stretcherAttachRy = {
                    description = "Portare la rotazione dell'attacco Y per la barella.",
                    label = "Allega RY",
                },
                stretcherAttachRz = {
                    description = "Portare la rotazione Z dell'attacco per la barella.",
                    label = "Allega RZ",
                },
                stretcherAttachX = {
                    description = "Carry attach X offset per il barella.",
                    label = "Allega X",
                },
                stretcherAttachY = {
                    description = "Carry attach Y offset per la barella.",
                    label = "Allega Y",
                },
                stretcherAttachZ = {
                    description = "Carry attach Z offset per il barella.",
                    label = "Allega Z",
                },
                stretcherFoldedEnabled = {
                    description = "Abilitare la variante barella pieghevole opzionale all'interno dei veicoli.",
                    label = "Ripiegato abilitato",
                },
                stretcherFoldedModel = {
                    description = "Modello oggetto utilizzato per la variante barella piegata.",
                    label = "Modello piegato",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Paziente orientamento utilizzato per la variante barella piegato.",
                    label = "Paziente pieghevole orientamento",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Attacco paziente offset X per il barella piegato.",
                    label = "Paziente piegato X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Attacco paziente Y offset per il barella piegato.",
                    label = "Paziente piegato Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Attacco paziente Z offset per il barella piegato.",
                    label = "Paziente piegato Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Interaction Distanza override usata per elicotteri.",
                    label = "Elicottero interagiscono a distanza",
                },
                stretcherHelicopterModels = {
                    description = "Modelli di veicoli trattati come elicotteri barella.",
                    itemLabel = "Modello",
                    label = "Modelli di elicotteri",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Override della distanza di prelievo utilizzato per elicotteri.",
                    label = "Distanza di prelievo dell'elicottero",
                },
                stretcherInteractDistance = {
                    description = "Distanza massima per le richieste di interazione barella.",
                    label = "Distanza interattiva",
                },
                stretcherItemEnabled = {
                    description = "Abilita l'oggetto barella nell'inventario, inclusi l'acquisto nel negozio e l'utilizzo.",
                    label = "Oggetto barella",
                },
                stretcherItemPickupEnabled = {
                    description = "Consente di riporre nell'inventario le barelle posizionate tramite l'oggetto dell'inventario.",
                    label = "Recupero oggetto",
                },
                stretcherModel = {
                    description = "Modello primario barella oggetto utilizzato dal sistema EMS barella.",
                    label = "Modello",
                },
                stretcherPatientAnimationDict = {
                    description = "Dizionario animazione per i pazienti sulla barella e il PNG di anteprima.",
                    label = "Dizionario animazione paziente",
                },
                stretcherPatientAnimationName = {
                    description = "Clip animazione per i pazienti sulla barella e il PNG di anteprima.",
                    label = "Nome animazione paziente",
                },
                stretcherPatientAttachHeading = {
                    description = "Il paziente orientamento usato mentre giaceva sulla barella.",
                    label = "Paziente orientamento",
                },
                stretcherPatientAttachX = {
                    description = "Attacco paziente X offset sulla barella.",
                    label = "Paziente X",
                },
                stretcherPatientAttachY = {
                    description = "Attacco paziente Y offset sulla barella.",
                    label = "Paziente Y",
                },
                stretcherPatientAttachZ = {
                    description = "Attacco paziente Z offset sulla barella.",
                    label = "Paziente Z",
                },
                stretcherPickupDistance = {
                    description = "Distanza necessaria per raccogliere e interagire con la barella.",
                    label = "Distanza di prelievo",
                },
                stretcherTreatmentAnimClip = {
                    description = "Clip di animazione utilizzata durante il trattamento di un paziente su una barella. Lasciare vuoto per utilizzare uno scenario o l'animazione di trattamento ripiego.",
                    label = "Nome animazione",
                },
                stretcherTreatmentAnimDict = {
                    description = "dizionario animazione utilizzato durante il trattamento di un paziente su una barella. Lasciare vuoto per utilizzare uno scenario o l'animazione trattamento ripiego.",
                    label = "Dizionario animazione",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Scenario opzionale utilizzato durante il trattamento di un paziente su una barella. Lasciare vuoto per usare dict + clip o l'animazione di trattamento ripiego.",
                    label = "Scenario",
                },
                stretcherVehicleAttachRx = {
                    description = "Allacciare la rotazione X del veicolo per caricare la barella.",
                    label = "Veicolo RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Rotazione di attacco del veicolo Y per il caricamento della barella.",
                    label = "Veicolo RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Agganciare il veicolo a rotazione Z per caricare la barella.",
                    label = "Veicolo RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Spostamento asse X del veicolo per il caricamento della barella.",
                    label = "Veicolo X",
                },
                stretcherVehicleAttachY = {
                    description = "Spostamento del fissaggio del veicolo Y per il caricamento della barella.",
                    label = "Veicolo Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Guarnizione Z del veicolo per il caricamento della barella.",
                    label = "Veicolo Z",
                },
                stretcherVehicleModels = {
                    description = "I modelli di veicoli hanno permesso di caricare la barella.",
                    itemLabel = "Modello",
                    label = "Modelli di veicoli",
                },
                treatmentAnimClip = {
                    description = "Clip di animazione utilizzato durante il trattamento di un paziente. Lasciare vuoto per utilizzare uno scenario invece.",
                    label = "Nome animazione",
                },
                treatmentAnimDict = {
                    description = "dizionario animazione utilizzato durante il trattamento di un paziente. Lasciare vuoto per utilizzare uno scenario invece.",
                    label = "Dizionario animazione",
                },
                treatmentAnimScenario = {
                    description = "Scenario usato durante il trattamento di un paziente. Lasciare vuoto per usare dict + clip invece.",
                    label = "Scenario",
                },
                trunkPropsEnabled = {
                    label = "Props del veicolo",
                    description = "Scegli i props accanto a un veicolo di servizio vicino.",
                },
                trunkEnabled = {
                    description = "Abilitare la funzione bagagliaio del veicolo per i veicoli ambulanza.",
                    label = "Abilitato",
                },
                vehicleDamageModifier = {
                    description = "Moltiplicatore di danni applicato mentre il giocatore è all'interno di un veicolo.",
                    label = "Modificatore dei danni al veicolo",
                },
                vehicleImpactProtectionCauses = {
                    description = "Le cause di morte che dovrebbero essere considerate come impatti dei veicoli protetti.",
                    itemLabel = "Causa",
                    label = "Cause di danno",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Impedire che gli impatti dei veicoli a bassa velocità uccidano il giocatore.",
                    label = "Abilitato",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Gli impatti del veicolo al di sotto di questa velocità non possono uccidere il giocatore.",
                    label = "Velocità fatale km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Gli impatti del veicolo a questa velocità o al di sopra di questa usano la configurazione normale di lesioni mortali.",
                    label = "Velocità del danno totale km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Le lesioni si sono applicate quando la protezione contro gli urti del veicolo blocca un colpo fatale.",
                    itemLabel = "Lesione",
                    label = "Ferite",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Percentuale di massima salute preservata quando un impatto protetto avrebbe ucciso il giocatore.",
                    label = "Percentuale sulla salute della sopravvivenza",
                },
                vehiclePullEnabled = {
                    description = "Abilita l'estrazione dei pazienti dai veicoli.",
                    label = "Abilitato",
                },
                vehiclePullMaxDistance = {
                    description = "Distanza massima richiesta per estrarre un paziente da un veicolo.",
                    label = "Distanza massima",
                },
                wheelchairAssignMaxDistance = {
                    description = "Distanza massima per assegnare una sedia a rotelle ad un altro giocatore.",
                    label = "Assegna distanza massima",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Disabilitare automaticamente la sedia a rotelle quando l'assegnazione scade.",
                    label = "Auto-unequip alla scadenza",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Durata predefinita assegnata alle sedie a rotelle in minuti.",
                    label = "Durata predefinita",
                },
                wheelchairDisableSprint = {
                    description = "Block sprint mentre la sedia a rotelle è attrezzata.",
                    label = "Disabilita sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Bloccare l'uso dell'arma mentre la sedia a rotelle è attrezzata.",
                    label = "Disabilita le armi",
                },
                wheelchairExitControl = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Lascia sedia a rotelle",
                },
                wheelchairItemName = {
                    description = "Inventario usato per la sedia a rotelle.",
                    label = "Nome dell'elemento",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Durata massima per l'assegnazione delle sedie a rotelle in minuti.",
                    label = "Durata massima",
                },
                wheelchairMinDurationMinutes = {
                    description = "Durata minima consentita dell'assegnazione della sedia a rotelle in minuti.",
                    label = "Durata minima",
                },
                wheelchairVehicle = {
                    description = "Modello di veicolo utilizzato per la sedia a rotelle.",
                    label = "Modello di veicolo",
                },
                xrayInteractionRange = {
                    description = "Distanza massima dalla stazione a raggi X per l'operatore.",
                    label = "Gamma di interazione",
                },
                xrayPatientRange = {
                    description = "Distanza massima dalla stazione dei raggi X per il paziente.",
                    label = "Gamma di pazienti",
                },
                xrayScanDurationSeconds = {
                    description = "Durata in secondi per il risultato della scansione a raggi X.",
                    label = "Durata scansione",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Raffreddamento in pochi secondi tra i tentativi di prenotazione dei pazienti.",
                    label = "Raffreddamento prenotazione",
                },
                appointmentsEnabled = {
                    description = "Attiva la prenotazione degli appuntamenti dei pazienti e il calendario medico personale.",
                    label = "Abilitato",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Numero massimo di giorni nel futuro che i pazienti possono prenotare.",
                    label = "Prenotazione anticipata massima",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Numero massimo di futuri appuntamenti attivi che un paziente può tenere.",
                    label = "Appuntamenti massimi per paziente",
                },
                appointmentsMinLeadMinutes = {
                    description = "Numero minimo di minuti tra la prenotazione e l'appuntamento.",
                    label = "Tempo minimo di consegna",
                },
                appointmentsNotificationApp = {
                    description = "identificativo dell'app del telefono utilizzato per le notifiche degli appuntamenti.",
                    label = "App di notifica",
                },
                appointmentsNotificationsEnabled = {
                    description = "Avvisa i pazienti al telefono al momento della prenotazione o della cancellazione degli appuntamenti.",
                    label = "Comunicazioni telefoniche",
                },
                appointmentsReasonMaxLength = {
                    description = "Numero massimo di caratteri accettati per il motivo dell'appuntamento.",
                    label = "Limite di carattere della ragione",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Durata e intervallo di griglia di uno slot di appuntamento in minuti.",
                    label = "Durata dello slot",
                },
                minigamesBandageWrapRandomization = {
                    description = "Randomizzare la direzione del percorso della garza, la forma e le proporzioni.",
                    label = "Variazione fasciatura",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Casualmente il percorso di accesso venoso per trasfusioni di sangue.",
                    label = "Variazione dell'accesso alla trasfusione",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Richiedete la procedura di accesso venoso multi-step prima del controllo del flusso. Disabilitate per la vecchia versione semplice.",
                    label = "Stadio di accesso venoso",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Casualmente la forma del canale della ferita, la larghezza e le ostruzioni.",
                    label = "Variazione di estrazione del proiettile",
                },
                stretcherVehicleAttachEditor = {
                    description = "Posizionare e ruotare la barella all'interno di un'ambulanza configurata.",
                    label = "Attacco del veicolo",
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
                firstAidPublicTreatmentConflict = "Il primo soccorso e il trattamento pubblico non possono essere entrambi attivati allo stesso tempo. SaVINg disabilita entrambi.",
            },
        },
    },
}
