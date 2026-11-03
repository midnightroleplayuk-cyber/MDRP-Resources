JobConfigLocales["sky_mechanicjob:it"] = {
    Nui = {
        workshopConfig = {
            settingFieldDescriptions = {
                radialEnabled = "Apri la fatturazione dell’officina dal menu radiale.",
                allowTuningInvoices = "Invia la fattura del carrello di tuning al cliente più vicino. Il montaggio è disponibile dopo il pagamento completo.",
                customerRange = "Distanza massima in metri per fatturare ai clienti nelle vicinanze.",
                allowAnalytics = "Permetti la fatturazione analitica a meno che una regola di grado non lo sovrascriva.",
                allowCustomPrices = "Consenti alla meccanica di modificare i prezzi delle posizioni fatturate prima dell'emissione.",
                allowEstimates = "Consentire le stime che i clienti devono accettare prima del pagamento.",
                allowImmediatePayment = "Lasciare che le fatture di questa professione siano pagate direttamente.",
                allowManualItems = "Permetti alla meccanica di creare posizioni arbitrarie di fattura.",
                allowPartialPayments = "Consentire depositi e pagamenti multipli verso una fattura.",
                analyticsPeriodDays = "Giorni inclusi nelle analisi di fatturazione.",
                defaultDueDays = "Giorni fino a quando una fattura diventa in ritardo.",
                depositPercent = "Percentuale di deposito richiesta dopo l'emissione di una fattura o si accetta un preventivo.",
                enabled = "Permetti a questa professione di utilizzare la fatturazione meccanica.",
                estimateLifetimeHours = "Ore prima che scada una stima senza risposta.",
                gradeRules = "Limiti di fatturazione e azioni disponibili per ogni grado meccanico.",
                maxDiscountPercent = "Il più grande sconto una fattura può ricevere.",
                maximumInvoiceAmount = "Totale massimo globale prima dei limiti di grado.",
                maximumManualItems = "Posizioni arbitrarie massime per documento.",
                maximumReminders = "Massimo promemoria consentito per fattura.",
                minimumInvoiceAmount = "Totale minimo per stime e fatture.",
                minimumPartialPayment = "Il pagamento parziale più piccolo, escluso un saldo o un deposito più piccolo.",
                reminderFee = "Costo aggiunto da ogni promemoria valido.",
                reminderGraceDays = "Giorni in ritardo prima che il primo promemoria è permesso.",
                taxPercent = "Imposta aggiunta dopo gli sconti.",
            },
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Prezzo del cliente",
                description = "Esempio di calcolo cosmetico utilizzando le regole attuali.",
                labor = "Lavoro",
                live = "Anteprima dal vivo",
                margin = "Margine",
                sports = "Auto sportive",
                super = "Supercar",
                supplier = "Fornitore",
                title = "Anteprima del prezzo",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configurare lavori meccanici, negozi, veicoli e posizioni officina.",
                    title = "Lavori da meccanico",
                },
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Installazione banco prova mobile",
                    entryPluralLabel = "Installazioni banco prova mobile",
                    label = "Installazioni banco prova mobile",
                },
                workshops = {
                    entryLabel = "Officina",
                    entryPluralLabel = "Officine",
                    label = "Officine",
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
            diagnosticsSettings = {
                enabledLabel = "Abilita diagnostica veicoli",
                enabledDescription = "Consente a questo lavoro di aprire la diagnostica dei veicoli e riparare i componenti al suo interno.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnostica veicoli",
                    description = "Configura l’accesso di questo lavoro alla diagnostica dei veicoli.",
                },
                billingPrices = {
                    description = "Configurare i prezzi delle fatture per le voci della cronologia di manutenzione e riparazione. Il tasto azione è abbinato a action_key, action_type o all'etichetta di lavoro.",
                    label = "Prezzi di fatturazione",
                },
                billingSettings = {
                    description = "Configurare il comportamento di fatturazione meccanico per questo lavoro.",
                    label = "Fatturazione",
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
                partsDeliveryShop = "Consegna di pezzi",
                trainingSettings = {
                    description = "Configura l'accesso alla formazione, l'iscrizione, le approvazioni e la pianificazione del corso per questo lavoro.",
                    label = "Impostazioni di allenamento",
                },
                tuningCostProfile = {
                    description = "Configurare le prestazioni, l'aspetto, la ruota e i costi speciali di questo lavoro. I costi supportano array di elementi richiesti e gli oggetti di aggiornamento stage.",
                    label = "Prezzi tuning",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Telecamera libera nel menu di tuning",
                    description = "Consente di nascondere il cursore con Spazio per muovere liberamente la telecamera. Escape continua a chiudere il menu.",
                },
                tuningCamera = {
                    description = "Inquadra automaticamente il componente selezionato. Se disattivata, mantiene la normale telecamera di gioco.",
                    label = "Telecamera tuning automatica",
                },
                jgMileage = {
                    description = "Usare JG Vehicle Mileage mentre la sua risorsa è attiva. Altrimenti usare il chilometraggio Sky. JG HUD si configura separatamente.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Mostrare il chilometraggio selezionato in JG HUD. Funziona senza JG Vehicle Mileage; installare l’adattatore HUD seguendo il README.",
                    label = "JG HUD",
                },
                antiLag = {
                    description = "Abilitare l'installazione anti-lag e gli effetti di scarico.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Abilita calore progressivo, dischi incandescenti, scintille critiche e brevi cali di frenata.",
                    label = "Surriscaldamento freni",
                },
                carryItems = {
                    description = "Parti consegnate che dovrebbero diventare fisicamente trasportate oggetti.",
                    label = "Oggetti per il trasporto",
                },
                customHandling = {
                    description = "Abilita trasmissione personalizzata e manipolazione tuning.",
                    label = "Gestione personalizzata",
                },
                electronicTuning = {
                    description = "Abilita opzioni persistenti per ECU, luci e assistenza alla guida.",
                    label = "Tuning elettronico",
                },
                handlingEditor = {
                    description = "Attiva l’editor amministratore e le regole automatiche per targa e modello. Dopo la disattivazione, ritira nuovamente dal garage i veicoli interessati per ripristinare i valori già applicati.",
                    label = "Editor di guida",
                },
                instantTuning = {
                    description = "Consenti l'ottimizzazione diretta nelle posizioni di ottimizzazione pubbliche configurate.",
                    label = "tuning istantaneo",
                },
                kuv = {
                    description = "Avvia controllo tecnico",
                    label = "Controllo tecnico del veicolo",
                },
                mileageHud = {
                    description = "Mostra le informazioni sul chilometraggio del veicolo durante la guida.",
                    label = "HUD chilometraggio",
                },
                mobileDyno = {
                    description = "Abilita il banco prova mobile, i display di controllo e risultato, il controller delle ventole e il tablet.",
                    label = "Banco prova mobile",
                },
                nitro = {
                    description = "Abilitare l'installazione di nitro e l'uso di spinta del veicolo.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Abilita gli ordini di consegna delle parti officina e le baie di consegna.",
                    label = "Consegna delle parti",
                },
                selfServiceOrderNotifications = {
                    description = "Avvisa i dipendenti on-servizio quando viene creato un ordine tuning self-service.",
                    label = "Notificazione degli ordini self-service",
                },
                stance = {
                    description = "Mostra le regolazioni di Stance in tutti i menu tuning e abilita l'elemento Kit Stance.",
                    label = "Stato",
                },
                stanceWheelSize = {
                    description = "Mostrare, salvare e applicare le regolazioni delle dimensioni della ruota in Stance.",
                    label = "Dimensione della ruota di forza",
                },
                stanceWheelWidth = {
                    description = "Mostrare, salvare e applicare le regolazioni della larghezza della ruota in Stance.",
                    label = "Larghezza della ruota della distanza",
                },
                subscriptions = {
                    description = "Abilita i terminali degli abbonamenti, la gestione e gli sconti per i clienti dell'officina.",
                    label = "Abbonamenti dell'officina",
                },
                twoStep = {
                    description = "Abilita il controllo di lancio in due fasi e gli effetti di scarico.",
                    label = "Due-Step",
                },
                vehicleMaintenanceNotifications = {
                    description = "Avvisa i proprietari quando il veicolo raggiunge la soglia di manutenzione configurata.",
                    label = "Notifiche di manutenzione del veicolo",
                },
                vehicleRegistration = {
                    description = "Immatricola / trasferisci",
                    label = "Immatricolazione",
                },
                wheelDamage = {
                    description = "Abilita danni e riparazioni realistici alla ruota.",
                    label = "Danni alla ruota",
                },
                workshopLift = {
                    description = "Abilita i punti di sollevamento utilizzabili configurati in officine.",
                    label = "Sollevatore officina",
                },
            },
            fields = {
                quantity = "Quantità",
            },
            locationDescriptions = {
                vehicle_registry = "Posiziona il punto nell’area di revisione dell’officina. Il veicolo deve trovarsi entro la distanza di controllo configurata per la revisione e l’immatricolazione.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Posizione del monitor dei risultati.",
                    label = "Monitor risultati",
                },
                mobile_dyno_station = {
                    description = "Posizione del banco prova mobile.",
                    label = "Stazione banco prova mobile",
                },
                vehicle_registry = "Punto di revisione e immatricolazione",
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
                radialEnabled = "Fattura nel menu radiale",
                allowTuningInvoices = "Fattura il tuning ai clienti",
                customerRange = "Distanza del cliente",
                allowAnalytics = "Analisi contabile",
                allowCancellation = "Cancellazione",
                allowCustomPrices = "Consenti prezzi personalizzati",
                allowEstimates = "Consenti stime",
                allowImmediatePayment = "Consentire il pagamento immediato",
                allowManualItems = "Consenti le tue posizioni",
                allowPartialPayments = "Consenti pagamenti parziali",
                allowReminders = "Promemoria",
                amount = "Quantità",
                analyticsPeriodDays = "Periodo di analisi",
                bone = "Osso",
                category = "Categoria",
                classId = "ID classe",
                defaultDueDays = "Termine di pagamento (giorni)",
                depositPercent = "Percentuale di deposito",
                difficulty = "Difficoltà",
                enabled = "Abilitato",
                estimateLifetimeHours = "Durata stimata (ore)",
                flow = "Installa flusso",
                grade = "Grado",
                gradeRules = "Regole di grado",
                item = "Voce",
                key = "Chiave",
                kilometersToZero = "Chilometri a zero",
                label = "Etichetta",
                laborFee = "Costo del lavoro",
                laborMultiplier = "Moltiplicatore del lavoro",
                marginAdjustmentPercent = "Regolazione del margine",
                marginPercent = "Margine%",
                maxDiscountPercent = "Massimo sconto",
                maximumInvoiceAmount = "Fattura massima",
                maximumManualItems = "Posizioni proprie massime",
                maximumPrice = "Massimo",
                maximumReminders = "Numero massimo di promemoria",
                minimumInvoiceAmount = "Fattura minima",
                minimumPartialPayment = "Pagamento parziale minimo",
                minimumPrice = "Minimo",
                multiplier = "Moltiplicatore",
                name = "Nome dell'elemento",
                partKey = "Chiave della parte",
                price = "Prezzo",
                priceType = "Tipo di prezzo",
                prop = "oggetto",
                reason = "Motivazione",
                reminderFee = "Tassa di sollecito",
                reminderGraceDays = "Periodo di grazia del sollecito",
                removeAfterUse = "Consuma elemento",
                repair = "Riparazione con kit",
                repairItem = "Elemento di riparazione",
                rx = "Roto X",
                ry = "RY",
                rz = "RZ",
                supplierSharePercent = "Fornitore%",
                taxPercent = "Imposta sulla fattura",
                transport = "Trasporti",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Miglioramento",
                maximumDiscountPercent = "Sconto massimo",
            },
            settingGroups = {
                antiExploit = {
                    label = "Protezione anti-exploit",
                },
                cooldownMultipliers = {
                    label = "Moltiplicatori di raffreddamento",
                },
                crashFalloff = {
                    label = "Distacco in caso di incidente",
                },
                criticalEngine = {
                    label = "Motore rotto",
                },
                deformation = {
                    label = "Deformazione",
                },
                diagnostics = {
                    label = "Diagnostica",
                },
                fade = {
                    label = "Perdita di efficacia dei freni",
                },
                format = {
                    label = "Formato",
                },
                frontalImpact = {
                    label = "Grave impatto frontale",
                },
                heatMultipliers = {
                    label = "Moltiplicatori di riscaldamento",
                },
                illegalMarket = {
                    label = "Mercato illegale",
                },
                integration = {
                    label = "Integrazione",
                },
                items = {
                    label = "Oggetti",
                },
                keybinds = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Assegnazione tasti",
                },
                lifetime = {
                    label = "Durata",
                },
                repairRestore = {
                    label = "Ripristina",
                },
                risk = {
                    label = "Rischio",
                },
                rules = {
                    label = "Regole",
                },
                safety = {
                    label = "Convalida e sicurezza",
                },
                stages = {
                    label = "Fasi di surriscaldamento",
                },
                tyreRepair = {
                    label = "Riparazione pneumatici",
                },
                visuals = {
                    label = "Effetti visivi",
                },
                coach = {
                    label = "Telemetria Coach",
                },
                features = {
                    label = "Caratteristiche",
                },
                general = {
                    label = "Generale",
                },
                limits = {
                    label = "Limiti di stoccaggio",
                },
            },
            settingSections = {
                electronicTuning = "Software motore ECU",
                advancedPricing = "Prezzi avanzati",
                brakeOverheating = "Surriscaldamento freni",
                carryItems = "Oggetti per il trasporto",
                fakePlates = "Targhe false",
                firejobVehicleFires = "Incendi del veicolo",
                general = "Generale",
                handlingEditor = "Editor della tenuta di strada",
                instantTuning = "tuning istantaneo",
                maintenanceNotifications = "Notifiche di manutenzione",
                mileageHud = "HUD chilometraggio",
                mobileDyno = "Banco prova mobile",
                oilLeaks = "Le perdite di fluido del veicolo",
                partsTheft = "Furto di parti",
                subscriptions = "Abbonamenti",
                tuning = "tuning",
                vehicleCare = "Cura del veicolo",
                vehicleRegistry = "Documenti del veicolo",
                wear = "Abbigliamento",
                wheelDamage = "Danni alla ruota",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Aggiuntivo",
                handlingAir = "Aria",
                handlingGeneral = "Generale",
                handlingRoad = "Strada",
                handlingWater = "Acqua",
            },
            settingSubsections = {
                mechanicHotkeys = "Assegnazione tasti",
                database = "Banca dati",
                handlingEditorGeneral = "Impostazioni editor",
                handlingMaximumCBikeHandlingData = "Motocicletta",
                handlingMaximumCBoatHandlingData = "Barca",
                handlingMaximumCCarHandlingData = "Auto",
                handlingMaximumCFlyingHandlingData = "Aereo",
                handlingMaximumCHandlingData = "Base del veicolo",
                handlingMaximumCSeaPlaneHandlingData = "Idrovolante",
                handlingMaximumCSpecialFlightHandlingData = "Volo speciale",
                handlingMaximumCSubmarineHandlingData = "Sottomarino",
                handlingMaximumCTrailerHandlingData = "Rimorchio",
                handlingMaximumCVehicleWeaponHandlingData = "Armi del veicolo",
                keybinds = "Assegnazione tasti",
                operation = "Funzionamento",
                placementRules = "Regole di posizionamento",
                testFlow = "Flusso di prova",
                tuning = "Opzioni di modifica istantanea",
            },
            settingValues = {
                air_filter = "Filtro aria",
                brake_fluid = "Fluido frenante",
                brake_pads = "Pad dei freni",
                catalytic_converter = "Convertitore catalitico",
                clutch = "Frizione",
                coolant = "Raffreddante",
                engine_oil = "Olio motore",
                inverter = "Inverter di potenza",
                spark_plugs = "Plug spark",
                suspension = "Sospensione",
                traction_battery = "Batteria di trazione",
                transmission_fluid = "Fluido di trasmissione",
                tyres = "Pneumatici",
                vehicleClass_0 = "Compatti",
                vehicleClass_1 = "Sedani",
                vehicleClass_10 = "Industriale",
                vehicleClass_11 = "Utilità",
                vehicleClass_12 = "Furgoni",
                vehicleClass_13 = "Cicli",
                vehicleClass_14 = "Barche",
                vehicleClass_15 = "Elicotteri",
                vehicleClass_16 = "Aerei",
                vehicleClass_17 = "Servizio",
                vehicleClass_18 = "Emergenza",
                vehicleClass_19 = "Militare",
                vehicleClass_2 = "SUV",
                vehicleClass_20 = "Commerciale",
                vehicleClass_21 = "Treni",
                vehicleClass_22 = "Ruota aperta",
                vehicleClass_3 = "Coppe",
                vehicleClass_4 = "Muscolo",
                vehicleClass_5 = "Sport Classici",
                vehicleClass_6 = "Sport",
                vehicleClass_7 = "Eccellente",
                vehicleClass_8 = "Motocicli",
                vehicleClass_9 = "Fuoristrada",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Riparazione veicolo",
                    description = "Offri la riparazione nei punti di tuning istantaneo.",
                },
                instantTuningRepairPrice = {
                    label = "Prezzo riparazione",
                    description = "Prezzo fisso della riparazione, senza moltiplicatore del tuning.",
                },
                instantTuningWashEnabled = {
                    label = "Lavaggio veicolo",
                    description = "Offri il lavaggio nei punti di tuning istantaneo.",
                },
                instantTuningWashPrice = {
                    label = "Prezzo lavaggio",
                    description = "Prezzo fisso del lavaggio, senza moltiplicatore del tuning.",
                },
                vehiclePriceSource = {
                    label = "Origine dei prezzi dei veicoli",
                    description = "Automatico: SQL su ESX; catalogo veicoli su QBCore/Qbox. Database: tabella SQL configurata su ogni framework.",
                    options = {
                        auto = "Automatico (framework)",
                        database = "Banca dati",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabella dei prezzi dei veicoli",
                    description = "Tabella con i prezzi di acquisto, ad es. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Colonna del nome di spawn",
                    description = "Colonna dei nomi di spawn, ad es. spawn_code (JG), non del nome visualizzato.",
                },
                vehiclePricePriceColumn = {
                    label = "Colonna del prezzo",
                    description = "Colonna dei prezzi di acquisto numerici, ad es. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Colonna hash del modello (facoltativa)",
                    description = "Colonna hash numerica facoltativa, ad es. hashkey (JG). Lasciare vuota per calcolare gli hash dai nomi di spawn.",
                },
                addRevenueToSociety = {
                    description = "Deposito versato tuning denaro d'ordine sul conto della società del lavoro tuning.",
                    label = "Entrate da deposito verso la società",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Categorie del negozio ricambi che restano acquistabili liberamente con i prezzi avanzati attivi. Maiuscole, minuscole e spazi vengono ignorati.",
                    itemLabel = "Categoria",
                    label = "Categorie sempre disponibili",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Mantiene disponibili senza un ordine di tuning gli articoli configurati nelle categorie selezionate e li prezza tramite il sistema dinamico del fornitore.",
                    label = "Articoli del negozio sempre disponibili",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Numero di giorni mostrati nell'analisi dei profitti del tablet.",
                    label = "Periodo di analisi",
                },
                advancedPricingCategoryRules = {
                    description = "Limiti di quota, margine, manodopera e prezzo del fornitore per categoria di ottimizzazione.",
                    label = "Regole di categoria",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Margine meccanico predefinito prima degli aggiustamenti di classe e grado.",
                    label = "Margine predefinito",
                },
                advancedPricingDifficultyRules = {
                    description = "Costo di manodopera aggiuntivo per ogni difficoltà di ottimizzazione.",
                    label = "Regole di difficoltà",
                },
                advancedPricingEnabled = {
                    description = "Ricalcola i prezzi di tuning sul server e, quando la consegna dei ricambi è abilitata, richiede l'acquisto dei ricambi Dynasty per lo specifico ordine di tuning.",
                    label = "Abilita prezzi avanzati",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Stock virtuale normale per ogni articolo del fornitore.",
                    label = "Calcio di base",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Punti richiesta rimossi per giorno trascorso.",
                    label = "Declino della domanda giornaliera",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Markup del fornitore aggiunto per ogni punto di domanda.",
                    label = "Maggiorazione della domanda per unità",
                },
                advancedPricingInventoryEnabled = {
                    description = "Aumenta i prezzi dei fornitori quando le scorte virtuali sono basse o la domanda è elevata.",
                    label = "Stock fornitori dinamico",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maggiorazione massima del fornitore causata da scorte scarse.",
                    label = "Markup di stock basso",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Livello delle scorte al di sotto del quale iniziano i prezzi di scarsità.",
                    label = "Soglia di scorte basse",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Limite superiore per il ricarico della domanda.",
                    label = "Markup massimo della domanda",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Unità virtuali rifornite per giorno trascorso.",
                    label = "Rifornimento giornaliero",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Massimale di sconto globale per le fatture dei meccanici.",
                    label = "Sconto massimo",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Margine meccanico massimo consentito.",
                    label = "Margine massimo",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Limite di prezzo superiore globale per una parte di ottimizzazione.",
                    label = "Prezzo massimo al dettaglio",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Limiti di markup, manodopera e sconto per qualità meccanica.",
                    label = "Regole di grado meccanico",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Margine meccanico consentito più basso.",
                    label = "Margine minimo",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Limite di prezzo globale inferiore per una parte di ottimizzazione.",
                    label = "Prezzo minimo al dettaglio",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Valore del veicolo utilizzato per l'esempio compatto.",
                    label = "Valore di anteprima compatto",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Esempio di percentuale del costo di ottimizzazione utilizzata dall'anteprima dal vivo.",
                    label = "Tasso di ottimizzazione dell'anteprima",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Valore del veicolo utilizzato per l'esempio sportivo.",
                    label = "Valore dell'anteprima sportiva",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Valore del veicolo utilizzato per l'esempio della supercar.",
                    label = "Valore di anteprima eccellente",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuti prima che un preventivo di prezzo non pagato venga ricalcolato.",
                    label = "Citazione a vita",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Percentuale rimborsata per una parte acquistata vincolata all'ordine.",
                    label = "Rimborso del reso",
                },
                advancedPricingRoundingStep = {
                    description = "Arrotondare ciascuna linea di approvvigionamento di Dynasty a questo passo di denaro.",
                    label = "Fase di arrotondamento del fornitore",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Percentuale del prezzo della parte cliente addebitata da Dynasty Auto Supply.",
                    label = "Quota del fornitore",
                },
                advancedPricingTaxPercent = {
                    description = "Percentuale fiscale memorizzata separatamente nella contabilità dei prezzi.",
                    label = "Tassa",
                },
                advancedPricingVehicleClassRules = {
                    description = "Adeguamenti di margine e manodopera per classe di veicoli GTA.",
                    label = "Regole della classe del veicolo",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Raffreddamento per upgrade freni",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Raffreddamento per classe veicolo",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Ritardo in millisecondi dopo la frenata prima che inizi il raffreddamento attivo.",
                    label = "Ritardo di raffreddamento",
                },
                brakeOverheatingCoolingPerSecond = {
                    label = "Velocità di raffreddamento",
                    description = "Il calore rimosso al secondo mentre il freno non è utilizzato.",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Livello di calore che può attivare scintille e brevi cali di frenata.",
                    label = "Soglia critica",
                },
                brakeOverheatingFadeChancePerSecond = {
                    label = "Probabilità calo al secondo",
                    description = "Possibilità da 0 a 1 per un breve taglio del freno durante la frenata a calore critico.",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Cooldown del calo",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Durata massima del calo",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Durata minima del calo",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Riscaldamento per upgrade freni",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Riscaldamento per classe veicolo",
                },
                brakeOverheatingHeatGainPerSecond = {
                    label = "Guadagno di calore",
                    description = "Il calore di base guadagnato al secondo durante la frenata alla velocità di riferimento.",
                },
                brakeOverheatingHotThreshold = {
                    label = "Soglia calda",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Velocità minima in km/h prima che la frenata generi calore.",
                    label = "Velocità minima di frenata",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Velocità in km/h alla quale si applica il guadagno termico di base.",
                    label = "Velocità di riferimento",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Intervallo massimo scintille",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Intervallo minimo scintille",
                },
                brakeOverheatingVisualDistance = {
                    label = "Distanza effetti",
                    description = "Distanza massima in metri per il bagliore e la scintilla.",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Soglia tiepida",
                },
                carryItems = {
                    description = "Parti consegnate che dovrebbero diventare fisicamente trasportate oggetti.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Albero motore",
                                forklift = "Carrelli elevatori",
                                hand = "Mano",
                            },
                        },
                    },
                    itemLabel = "Elemento di trasporto",
                    label = "Oggetti per il trasporto",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 non aggiunge potenza; 1,10 aumenta la coppia del 10%. Si applica ai veicoli con questo stadio ECU.",
                    label = "Moltiplicatore di coppia dello stadio 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 non aggiunge potenza; 1,10 aumenta la coppia del 10%. Si applica ai veicoli con questo stadio ECU.",
                    label = "Moltiplicatore di coppia dello stadio 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 non aggiunge potenza; 1,10 aumenta la coppia del 10%. Si applica ai veicoli con questo stadio ECU.",
                    label = "Moltiplicatore di coppia dello stadio 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 non aggiunge potenza; 1,10 aumenta la coppia del 10%. Si applica ai veicoli con questo stadio ECU.",
                    label = "Moltiplicatore di coppia dello stadio 4",
                },
                fakePlatesAudit = {
                    label = "Registro di controllo",
                },
                fakePlatesBlacklist = {
                    description = "Parole o frammenti bloccati che non possono comparire nelle targhe false.",
                    label = "Lista nera",
                },
                fakePlatesBlankPlateItem = {
                    description = "Materiale di produzione o negozio utilizzato nel circuito economico delle targhe false.",
                    label = "Oggetto targa vuota",
                },
                fakePlatesCooldownMinutes = {
                    label = "Intervallo (minuti)",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Probabilità di distacco",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Abilita il distacco in caso di incidente",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Velocità minima dell'incidente",
                },
                fakePlatesEnabled = {
                    description = "Consente ai giocatori di utilizzare kit per targhe false sui veicoli.",
                    label = "Abilita targhe false",
                },
                fakePlatesExpireMinutes = {
                    description = "0 mantiene attive le targhe false finché non vengono ripristinate o rimosse dalla gestione del riavvio.",
                    label = "Scadenza (minuti)",
                },
                fakePlatesExpireOnRestart = {
                    label = "Scade al riavvio",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Conto di pagamento",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Abilita mercato illegale",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Prezzo del mercato illegale",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Moltiplicatore di rischio",
                },
                fakePlatesInstallDurationMs = {
                    label = "Durata installazione (ms)",
                },
                fakePlatesItem = {
                    description = "Oggetto monouso che avvia l'installazione della targa falsa.",
                    label = "Oggetto kit targa falsa",
                },
                fakePlatesMaxLength = {
                    label = "Lunghezza massima",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Distanza dal veicolo",
                },
                fakePlatesMinLength = {
                    label = "Lunghezza minima",
                },
                fakePlatesPattern = {
                    description = "Pattern Lua utilizzato per convalidare il testo delle targhe false, ad esempio ^[A-Z0-9]+$.",
                    label = "Pattern Lua",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Distanza dalla posizione della targa",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Blocca targhe false attive duplicate",
                },
                fakePlatesPrinterItem = {
                    description = "Strumento di produzione o negozio utilizzato nel circuito economico delle targhe false.",
                    label = "Oggetto stampante per targhe",
                },
                fakePlatesRequireEngineOff = {
                    label = "Il motore deve essere spento",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Utilizza Config.Functions.CanApplyFakePlate prima di consentire l'installazione.",
                    label = "Richiedi proprietario o chiavi",
                },
                fakePlatesRequireStopped = {
                    label = "Il veicolo deve essere fermo",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Riservato alle integrazioni garage che richiamano l'evento o l'export di ripristino.",
                    label = "Ripristina al deposito in garage",
                },
                fakePlatesRiskCharacters = {
                    label = "Caratteri per gli errori",
                },
                fakePlatesRiskEnabled = {
                    label = "Abilita errori di battitura casuali",
                },
                fakePlatesRiskTypoChance = {
                    label = "Probabilità di errore",
                },
                fallbackVehicleValue = {
                    description = "Valore utilizzato quando nessun prezzo del veicolo può essere risolto.",
                    label = "Valore del veicolo in caduta",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Possibilità da 0 a 1 dopo che il motore rimane critico.",
                    label = "Critica probabilità di incendio del motore",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Secondi prima che un altro incendio con motore rotto possa innescare.",
                    label = "Motore critico tempo di attesa",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Ritardo in millisecondi prima che un motore rotto possa accendersi.",
                    label = "Ritardo critico del motore ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Permettere ai motori danneggiati criticamente di avviare un incendio di un veicolo di vigili del fuoco dopo un ritardo.",
                    label = "Ignire i motori rotti",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Densità del fumo usata per richieste di incendio con motore rotto.",
                    label = "Densità critica del fumo del motore",
                },
                firejobVehicleFiresEnabled = {
                    description = "Permettere ai sistemi di danni meccanici di richiedere incendi di veicoli da pompieri.",
                    label = "Abilitare gli incendi di veicoli antincendio",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Rapporto di movimento richiesto in avanti da 0 a 1.",
                    label = "Rapporto di movimento in avanti",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Possibilità da 0 a 1 che un impatto qualificante appicchi un incendio.",
                    label = "Possibilità di incendio d'urto",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Secondi prima che un altro incendio d'urto possa innescare.",
                    label = "Impact fire tempo di attesa",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Permettere incidenti frontali forti per richiedere un incendio veicolo pompieri.",
                    label = "Ignite dopo gravi crash",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Densità del fumo usata per le richieste di crash-triggered incendio.",
                    label = "Densità del fumo d'urto",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatico utilizza la risorsa Firejob configurata; Disabilitato impedisce Mechanicjob di creare incendi.",
                    label = "Modalità integrazione",
                    options = {
                        automatic = "Automatico",
                        disabled = "Disabilitato",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Salute corporea minima persa durante l'impatto.",
                    label = "Danni corporei minimi",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "La salute minima del motore ha perso durante l'impatto.",
                    label = "Danni minimi al motore",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Usare 0 per disabilitare questo controllo di deformazione.",
                    label = "Deformazione anteriore minima",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Velocità minima di preurto in km/h.",
                    label = "Velocità minima d'urto",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Perdita di velocità richiesta in km/h durante l'urto.",
                    label = "Perdita minima di velocità",
                },
                firejobVehicleFiresResource = {
                    description = "Risorsa che riceve richieste di incendio del veicolo.",
                    label = "Risorse dei pompieri",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Evento server interno utilizzato dal client meccanico per richiedere un incendio di un veicolo antincendio.",
                    label = "Evento server meccanico",
                },
                freeVehicles = {
                    description = "Modelli di veicoli spawn che ricevono ordini tuning gratuiti.",
                    itemLabel = "Modello di veicolo",
                    label = "Veicoli tuning gratuiti",
                },
                handlingEditorFieldMaximum = {
                    description = "Valore massimo rigido accettato dall'editor per questo campo di tenuta di strada.",
                },
                handlingEditorFocusKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Torna all'editor handling",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Byte codificati dopo i quali una richiesta, risposta o istantanea dell'editor viene segnalata come grande.",
                    label = "Soglia payload grande",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Misura le operazioni dell'editor e avvisa tramite Sky.Debug quando vengono superati i limiti configurati.",
                    label = "Controlli delle prestazioni",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Millisecondi tra i riepiloghi aggregati delle prestazioni quando il log dettagliato è attivo.",
                    label = "Intervallo riepilogo",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Millisecondi dopo i quali un'operazione dell'editor viene segnalata come lenta.",
                    label = "Soglia operazione lenta",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Percentuale massima di cui un cursore numerico può spostarsi sopra o sotto la base del veicolo letta. L'inserimento diretto e l'importazione XML restano senza perdite. Un massimo del campo diverso da quello predefinito sostituisce il limite superiore del cursore.",
                    label = "Scostamento massimo del cursore",
                },
                instantTuningAllowedJobs = {
                    description = "Facoltativo globale per consentire-list. Lascia vuoto per consentire a tutti a meno che non sia abilitato solo meccanico.",
                    itemLabel = "Nome del lavoro",
                    label = "Lavori ammessi",
                },
                instantTuningBlipColor = {
                    description = "GTA blip colore id.",
                    label = "Colore blip",
                },
                instantTuningBlipEnabled = {
                    description = "Visualizza mappa blip per posizioni immediate tuning.",
                    label = "blip abilitato",
                },
                instantTuningBlipName = {
                    description = "Mappa blip nome.",
                    label = "Nome blip",
                },
                instantTuningBlipSprite = {
                    description = "ID sprite blip GTA.",
                    label = "Sprite blip",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Utilizzare l'interazione in stile marcatore E anche quando il supporto target è abilitato.",
                    label = "Interazione con i marcatori di forza",
                },
                instantTuningInteractionDistance = {
                    description = "Distanza predefinita per l'utilizzo di punti tuning istantanei.",
                    label = "Distanza d'interazione",
                },
                instantTuningLabel = {
                    description = "Testo predefinito mostrato in punti tuning istantanei.",
                    label = "Etichetta predefinita",
                },
                instantTuningLocations = {
                    description = "Punti tuning istantanei. Utilizzare 0 distanza per ereditare la distanza di interazione predefinita.",
                    itemLabel = "Posizioni",
                    label = "Posizioni",
                },
                instantTuningMarkerEnabled = {
                    description = "Disegna un marcatore del mondo nelle posizioni immediate di tuning.",
                    label = "Marcatore abilitato",
                },
                instantTuningMarkerType = {
                    description = "Tipo di marcatore GTA utilizzato per posizioni immediate tuning.",
                    label = "Tipo marcatore",
                },
                instantTuningMechanicOnly = {
                    description = "Limitare tutte le posizioni tuning istantanee ai lavori meccanici configurati.",
                    label = "Solo meccanica",
                },
                instantTuningPriceMultiplier = {
                    description = "Moltiplicatore applicato ai prezzi tuning istantanei.",
                    label = "Moltiplicatore dei prezzi",
                },
                instantTuningProfile = {
                    description = "Configura quali opzioni tuning sono disponibili nei punti immediatamente tuning.",
                    label = "Opzioni tuning istantaneo",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Numero minimo di minuti prima che lo stesso veicolo possa attivare un altro promemoria di manutenzione.",
                    label = "Intervallo tra le notifiche",
                },
                maintenanceNotificationsEnabled = {
                    description = "Avvisa i proprietari dei veicoli quando un componente soggetto a usura raggiunge la soglia di manutenzione.",
                    label = "Abilitate",
                },
                maintenanceNotificationsThreshold = {
                    description = "Percentuale di usura pari o inferiore alla quale la manutenzione è considerata necessaria.",
                    label = "Soglia di intervento",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Furto catalizzatore · Controllo 38",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Furto catalizzatore · Controllo 73",
                },
                mechanicDynoControl172 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 172",
                },
                mechanicDynoControl173 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 173",
                },
                mechanicDynoControl174 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 174",
                },
                mechanicDynoControl175 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 175",
                },
                mechanicDynoControl177 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 177",
                },
                mechanicDynoControl38 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 38",
                },
                mechanicDynoControl45 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 45",
                },
                mechanicDynoControl47 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Banco prova · Controllo 47",
                },
                mechanicSprayPaintControl200 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Verniciatura · Controllo 200",
                },
                mechanicSprayPaintControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Verniciatura · Controllo 202",
                },
                mechanicVehicleCareControl200 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cura veicolo · Controllo 200",
                },
                mechanicVehicleCareControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cura veicolo · Controllo 202",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 38",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 33",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 34",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 35",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 32",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Spingi veicolo · Controllo 21",
                },
                mechanicWheelChangeControl200 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cambio ruota · Controllo 200",
                },
                mechanicWheelChangeControl202 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cambio ruota · Controllo 202",
                },
                mechanicWheelChangeControl22 = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Cambio ruota · Controllo 22",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Furto ruota · Controllo 38",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Furto ruota · Controllo 73",
                },
                mileageHudDigits = {
                    description = "Numero di cifre mostrate nel chilometraggio HUD.",
                    label = "Cifre",
                },
                mileageHudPosition = {
                    description = "Trascinare l'anteprima del chilometraggio HUD nella posizione desiderata dello schermo.",
                    label = "Posizione",
                },
                mobileDynoConsumeItem = {
                    description = "Rimuovere un oggetto dopo il posizionamento riuscito.",
                    label = "Consumare un oggetto",
                },
                mobileDynoCooldownMs = {
                    label = "Durata raffreddamento",
                },
                mobileDynoCountdownMs = {
                    label = "Conto alla rovescia",
                },
                mobileDynoDuiDistance = {
                    label = "Distanza rendering pannello",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Distanza controller ventole",
                    description = "Distanza in metri per l'utilizzo dell'interruttore fisico tra le ventole di raffreddamento.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Durata a pieno carico",
                    description = "Millisecondi spesi a pieno carico sostenuto in profili che includono uno stadio a pieno carico.",
                },
                mobileDynoHistoryLimit = {
                    label = "Limite cronologia",
                },
                mobileDynoInteractionDistance = {
                    label = "Distanza interazione pannello",
                },
                mobileDynoItemUseEnabled = {
                    description = "Consentire il posizionamento del banco e del monitor usando gli oggetti.",
                    label = "Posizionamento tramite oggetto",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limite sessioni attive",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Distanza acquisizione veicolo",
                },
                mobileDynoMonitorItem = {
                    description = "Oggetto da usare per posizionare un monitor dei risultati.",
                    label = "Oggetto del monitor",
                },
                mobileDynoPersistItems = {
                    description = "Mantenere i nuovi posizionamenti dopo il riavvio del server.",
                    label = "Salvare i posizionamenti",
                },
                mobileDynoPickupDistance = {
                    description = "Distanza massima in metri per raccogliere l’attrezzatura.",
                    label = "Distanza di raccolta",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Variazione massima di altezza",
                    description = "Variazione massima in metri di altezza dal suolo accettata su tutte le sonde di impronta di dino.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Pendenza massima di posa",
                    description = "Massima pendenza al suolo in gradi accettati attraverso l'impronta del dino.",
                },
                mobileDynoRequireOnDuty = {
                    description = "I meccanici devono essere in servizio per posizionare e usare il banco.",
                    label = "Servizio obbligatorio",
                },
                mobileDynoResultDuiDistance = {
                    label = "Distanza display risultati",
                    description = "Distanza massima in metri alla quale viene reso il monitor separato dei risultati.",
                },
                mobileDynoReturnItem = {
                    description = "Restituire l’oggetto consumato quando si raccoglie l’attrezzatura.",
                    label = "Restituire un oggetto",
                },
                mobileDynoStationItem = {
                    description = "Oggetto da usare per posizionare un banco prova.",
                    label = "Oggetto del banco",
                },
                mobileDynoTabletDistance = {
                    description = "Distanza massima dal banco in metri per il controllo da tablet e i test attivi.",
                    label = "Portata del tablet",
                },
                nitroActivationKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Tieni premuto nitro",
                },
                oilLeaksCooldownSeconds = {
                    description = "Secondi prima che un'altra perdita di impatto possa innescare.",
                    label = "Impatto tempo di attesa",
                },
                oilLeaksEnabled = {
                    description = "Lasciare che i veicoli a combustione danneggiati lascino il fluido alle spalle mentre driVINg.",
                    label = "Abilita perdite di liquidi",
                },
                oilLeaksEngineOilChance = {
                    description = "Possibilità di fuga normale da 0 a 1.",
                    label = "Possibilità di olio motore",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Possibilità di fuga critica da 0 a 1.",
                    label = "Critica probabilità olio motore",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Condizioni dell'olio motore a o al di sotto della quale viene utilizzata la probabilità critica.",
                    label = "Soglia critica dell'olio motore",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Condizioni dell'olio motore a o al di sotto della quale può iniziare una perdita.",
                    label = "Soglia olio motore",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Rapporto di movimento richiesto in avanti da 0 a 1.",
                    label = "Rapporto di movimento in avanti",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Permettere gravi impatti frontali per avviare una perdita temporanea del fluido motore.",
                    label = "Fuga d'urto frontale",
                },
                oilLeaksImpactChance = {
                    description = "Possibilità da 0 a 1 che un impatto di qualificazione inizia una perdita.",
                    label = "Possibilità di fuga d'impatto",
                },
                oilLeaksImpactRadius = {
                    description = "Raggio del punto fluido iniziale creato da un impatto.",
                    label = "Raggio di fuoriuscita dell'impatto",
                },
                oilLeaksIntervalSeconds = {
                    description = "Secondi minimi tra i sentieri.",
                    label = "Intervallo trail",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Secondi una perdita continua dopo un impatto qualificante.",
                    label = "Durata della perdita d'impatto",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Salute corporea minima persa durante l'impatto.",
                    label = "Danni corporei minimi",
                },
                oilLeaksMinDistance = {
                    description = "Distanza minima percorsa tra i sentieri.",
                    label = "Distanza trail",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "La salute minima del motore ha perso durante l'impatto.",
                    label = "Danni minimi al motore",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Deformazione anteriore richiesta. Usare 0 per disabilitare questo controllo.",
                    label = "Deformazione anteriore minima",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Velocità minima di preurto in km/h.",
                    label = "Velocità minima d'urto",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Perdita di velocità richiesta in km/h durante l'urto.",
                    label = "Perdita minima di velocità",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Velocità minima del veicolo in km/h prima che una perdita di liquido possa creare una pista.",
                    label = "Velocità minima",
                },
                oilLeaksRadius = {
                    description = "Raggio dei binari regolari del veicolo.",
                    label = "Raggio del binario",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Possibilità di fuga normale da 0 a 1.",
                    label = "Possibilità del fluido di trasmissione",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Possibilità di fuga critica da 0 a 1.",
                    label = "Possibilità di trasmissione critica",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Condizioni del fluido di trasmissione a o al di sotto del quale si utilizza la probabilità critica.",
                    label = "Soglia critica di trasmissione",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Condizioni del fluido di trasmissione a o sotto la quale può iniziare una perdita.",
                    label = "Soglia del fluido di trasmissione",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Classi di veicoli in grado di completare l'ordine dipendente dal sollevamento senza un sollevatore officina.",
                    itemLabel = "Aggiungere la classe del veicolo",
                    label = "Classi di bypass per ascensori",
                    options = {
                        ["0"] = "Compatti",
                        ["1"] = "Sedani",
                        ["10"] = "Industriale",
                        ["11"] = "Utilità",
                        ["12"] = "Furgoni",
                        ["13"] = "Cicli",
                        ["14"] = "Barche",
                        ["15"] = "Elicotteri",
                        ["16"] = "Aerei",
                        ["17"] = "Servizio",
                        ["18"] = "Emergenza",
                        ["19"] = "Militare",
                        ["2"] = "SUV",
                        ["20"] = "Commerciale",
                        ["21"] = "Treni",
                        ["22"] = "Ruota aperta",
                        ["3"] = "Coppe",
                        ["4"] = "Muscolo",
                        ["5"] = "Sport Classici",
                        ["6"] = "Sport",
                        ["7"] = "Eccellente",
                        ["8"] = "Motocicli",
                        ["9"] = "Fuoristrada",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modelli di veicoli spawn in grado di completare l'ordine dipendente dal sollevamento senza sollevamento officina.",
                    itemLabel = "Modello di veicolo",
                    label = "Modelli di veicoli a bypass per ascensori",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millisecondi usati per ordinare i passaggi di installazione che non eseguono uno minigioco.",
                    label = "Durata semplice dell'installazione",
                },
                partsDeliveryCompanyCard = {
                    description = "Consenti agli ordini di consegna delle parti di utilizzare i fondi aziendali.",
                    label = "Pagamento con carta aziendale",
                },
                partsDeliveryMode = {
                    description = "Mantiene il flusso fisico standard oppure aggiunge l'intera consegna direttamente all'inventario del giocatore che la ritira.",
                    label = "Gestione della consegna",
                    options = {
                        player_inventory = "Inventario del giocatore",
                        standard = "Flusso di consegna standard",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millisecondi necessari per disfare una consegna dei pezzi pronti.",
                    label = "Durata aperta",
                },
                partsDeliveryOwnCard = {
                    description = "Permettere ai giocatori di pagare parti consegna ordini con i propri soldi.",
                    label = "Pagamento con carta propria",
                },
                partsDeliveryTimeSeconds = {
                    description = "Secondi tra ordinare parti e la consegna si sta preparando.",
                    label = "Tempi di consegna",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Articolo di inventario assegnato quando un convertitore catalitico viene rubato.",
                    label = "Elemento convertitore catalitico",
                },
                partsTheftDealerAccount = {
                    description = "Conto utilizzato per i pagamenti di pezzi rubati, come denaro o banca.",
                    label = "Conto di pagamento del concessionario",
                },
                partsTheftDealerItems = {
                    description = "Articoli rubati il rivenditore comprerà e i loro valori di vincita.",
                    itemLabel = "Elemento rivenditore",
                    label = "Articoli del rivenditore",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventario articolo dato quando il tipo di pagamento rivenditore è voce. Il prezzo di vendita viene utilizzato come l'importo dell'articolo.",
                    label = "Articolo di pagamento del rivenditore",
                },
                partsTheftDealerPayoutType = {
                    description = "Scegliere se il rivenditore paga in un conto quadro o dà un articolo di inventario.",
                    label = "Tipo di pagamento del concessionario",
                    options = {
                        account = "Conto",
                        item = "Voce",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Massima distanza dal rivenditore per vendere pezzi rubati.",
                    label = "Distributore di distanza di vendita",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Secondi prima della stessa parte del veicolo può creare un altro centrale operativa.",
                    label = "centrale operativa tempo di attesa",
                },
                partsTheftDispatchEnabled = {
                    description = "Creare una polizia centrale operativa quando viene rubata una ruota o un convertitore catalitico.",
                    label = "Manda la polizia centrale operativa",
                },
                partsTheftDispatchJobs = {
                    description = "Nomi di lavoro che ricevono parti furto centrale operativaES.",
                    itemLabel = "Nome del lavoro",
                    label = "Lavori centrale operativa",
                },
                partsTheftDispatchMessage = {
                    description = "Messaggio mostrato nella segnalazione della centrale operativa. Supporta {plate}, {part} e {type}.",
                    label = "Messaggio centrale operativa",
                },
                partsTheftDispatchTitle = {
                    description = "Titolo mostrato nella segnalazione della centrale operativa. Supporta {plate}, {part} e {type}.",
                    label = "Titolo centrale operativa",
                },
                partsTheftItem = {
                    description = "Inventario usato per rubare ruote e convertitori catalitici.",
                    label = "Elemento strumento furto",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Rimuovere l'elemento strumento di furto dopo un'azione di furto di successo.",
                    label = "Consuma lo strumento furto",
                },
                partsTheftStolenWheelItem = {
                    description = "Articolo d'inventario assegnato quando le ruote vengono rubate.",
                    label = "Elemento ruota rubata",
                },
                priceType = {
                    description = "Percentuale calcola ogni costo tuning dal prezzo del veicolo. Fisso utilizza l'importo di denaro inserito.",
                    label = "Tipo di prezzo",
                    options = {
                        class = "Classe del veicolo",
                        fixed = "Fisso",
                        percentage = "Percentuale",
                    },
                },
                primaryColor = {
                    description = "Colore predefinito per il gruppo dei lavori meccanici e per i nuovi lavori. Usare un valore esadecimale come #EDC001.",
                    label = "Colore primario",
                },
                publicUsersSeePrices = {
                    description = "Quando abilitata, i clienti pubblici pagano durante l'ordine. Disabilita questo per creare ordini non pagati per la fatturazione meccanica.",
                    label = "Accreditamento degli ordini pubblici di self-service",
                },
                registryBikeChecks = {
                    description = "Punti di controllo moto",
                    label = "Punti di controllo moto",
                },
                registryCarChecks = {
                    description = "Punti di controllo auto",
                    label = "Punti di controllo auto",
                },
                registryDistance = {
                    description = "Distanza di servizio (metri)",
                    label = "Distanza di servizio (metri)",
                },
                registryKuvFee = {
                    description = "Costo Controllo tecnico del veicolo",
                    label = "Costo Controllo tecnico del veicolo",
                },
                registryKuvValidityDays = {
                    description = "Validità dei nuovi controlli in tempo reale. Predefinito: 30 giorni. Le scadenze esistenti restano invariate.",
                    label = "Validità del controllo (giorni reali)",
                },
                registryKuvWarningDays = {
                    description = "Preavviso (giorni)",
                    label = "Preavviso (giorni)",
                },
                registryRegistrationFee = {
                    description = "Costo immatricolazione",
                    label = "Costo immatricolazione",
                },
                registryReinspectionFee = {
                    description = "Costo di ripetizione",
                    label = "Costo di ripetizione",
                },
                registryRequireKuv = {
                    description = "Richiedi Controllo tecnico del veicolo valida per immatricolare",
                    label = "Richiedi Controllo tecnico del veicolo valida per immatricolare",
                },
                registrySessionSeconds = {
                    description = "Tempo di conferma (secondi)",
                    label = "Tempo di conferma (secondi)",
                },
                registryTransferFee = {
                    description = "Costo passaggio",
                    label = "Costo passaggio",
                },
                registryVehicleTypes = {
                    description = "Tipi di veicoli ammessi",
                    label = "Tipi di veicoli ammessi",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Consente ai responsabili autorizzati di acquistare un abbonamento per l'intera azienda utilizzando i fondi aziendali.",
                    label = "Abbonamenti aziendali",
                },
                subscriptionsCurrency = {
                    description = "Valuta di sky_base utilizzata per acquistare gli abbonamenti, ad esempio bank.",
                    label = "Valuta di pagamento",
                },
                subscriptionsEnabled = {
                    description = "Abilita gli abbonamenti dell'officina, i terminali clienti e gli sconti sugli abbonamenti.",
                    label = "Abilitato",
                },
                subscriptionsMaximumDurations = {
                    description = "Numero massimo di opzioni di durata e prezzo per ogni modello di abbonamento.",
                    label = "Numero massimo di durate",
                },
                subscriptionsMaximumModels = {
                    description = "Numero massimo di modelli di abbonamento che un'officina può configurare nel tablet.",
                    label = "Numero massimo di modelli",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Clip di animazione ciclica opzionale utilizzata quando lo scenario è vuoto.",
                    label = "Clip emote dell'NPC",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Dizionario di animazione opzionale utilizzato quando lo scenario è vuoto.",
                    label = "Dizionario emote dell'NPC",
                },
                subscriptionsNpcPedModel = {
                    description = "Modello ped generato presso i terminali degli abbonamenti, ad esempio s_m_m_autoshop_01.",
                    label = "Modello ped dell'NPC",
                },
                subscriptionsNpcScenario = {
                    description = "Scenario GTA opzionale, come WORLD_HUMAN_CLIPBOARD. Lascia vuoto per utilizzare l'animazione emote.",
                    label = "Scenario dell'NPC",
                },
                tuningFocusKey = {
                    description = "Tasto predefinito FiveM, ad es. E, F6 o MOUSE_BUTTON:MOUSE_RIGHT. Vuoto significa nessun tasto predefinito. I giocatori possono personalizzare i tasti nelle impostazioni FiveM; le assegnazioni salvate vengono mantenute.",
                    label = "Tuning: interazione mouse",
                },
                tuningWorkshopDistance = {
                    description = "Distanza massima da un punto tuning self-service per le azioni di installazione o rimozione richieste.",
                    label = "officina distanza richiesta",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Richiedere l'ordine tuning si installa per iniziare e completare in prossimità di un punto tuning self-service.",
                    label = "Richiede officina per installazioni",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Richiedere rimozione tuning per avviare e completare in prossimità di un punto tuning self-service.",
                    label = "Richiede l'officina per il trasloco",
                },
                vehicleCareRepairDurationMs = {
                    description = "Riparare la durata del progresso in millisecondi.",
                    label = "Durata della riparazione",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Anche ripristinare danni realistici ruota quando si utilizza l'azione di riparazione.",
                    label = "Correggi danni realistici alla ruota",
                },
                vehicleCareRepairItem = {
                    description = "Articolo di inventario utilizzato dall'azione di riparazione veicolo.",
                    label = "Elemento di riparazione",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Distanza massima dal veicolo durante la riparazione.",
                    label = "Distanza massima di riparazione",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Rimuovere l'elemento di riparazione dopo l'uso.",
                    label = "Consumare elemento di riparazione",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Riparare i danni normali del veicolo GTA quando si utilizza l'azione di riparazione.",
                    label = "Correggi i danni al veicolo",
                },
                vehicleCareRepairWearParts = {
                    description = "Scegliere quali parti di usura e di servizio l'articolo di riparazione ripristina. Disabilitare i fluidi qui se olio, refrigerante, fluido freno, o fluido di trasmissione dovrebbe richiedere il flusso di riparazione diagnostica.",
                    itemLabel = "Parte indossabile",
                    label = "Kit riparazione parti restaurate",
                },
                vehicleCareWashItem = {
                    description = "Inventario usato per lavare un veicolo.",
                    label = "Lavaggio",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Rimuovere l'articolo dopo l'uso.",
                    label = "Consumare l'elemento di lavaggio",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Distanza di un veicolo cerato rimane pulito.",
                    label = "Cera chilometri puliti",
                },
                vehicleCareWaxItem = {
                    description = "Inventario usato per cerare un veicolo.",
                    label = "Elemento cera",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Rimuovere l'elemento cera dopo l'uso.",
                    label = "Consumare elemento cera",
                },
                vehicleClassPricing = {
                    description = "Sostituisci il tipo di prezzo e il moltiplicatore di costo per ciascuna classe di veicolo GTA.",
                    label = "Prezzi per classe di veicolo",
                },
                wearParts = {
                    description = "Parti di usura del veicolo, la loro distanza di vita, articolo di riparazione richiesto, il consumo di articoli, e installare il flusso.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Convertitore catalitico",
                                fluid_refill = "Ricarica di liquidi",
                                hood_install = "Installazione del cappuccio",
                                oil_change = "Variazione del petrolio",
                                performance = "Prestazioni",
                                underbody_neon = "Sottocorpo / sollevatore",
                                wheel = "Ruota",
                            },
                        },
                    },
                    itemLabel = "Parte indossabile",
                    label = "Indossare parti",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Moltiplicatore danni alla ruota di base.",
                    label = "Moltiplicatore predefinito",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtri di deformazione punti sonda che non puntano al corpo del veicolo.",
                    label = "Soglia angolo sonda",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Forza aggiuntiva aggiunto ogni ripristino iterazione.",
                    label = "Incremento del danno da deformazione",
                },
                wheelDamageDeformationEnabled = {
                    description = "Catturare e ripristinare le ammaccature durante la ricostruzione della geometria della riparazione dei pneumatici.",
                    label = "Ripristina deformazione",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Forza di partenza usata per ripristinare le ammaccature.",
                    label = "Danni iniziali alla deformazione",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximum SetVeicleDamage passa utilizzato per ricostruire le ammaccature.",
                    label = "Iterazioni di deformazione",
                },
                wheelDamageDeformationThreshold = {
                    description = "Magnitudine minima di deformazione rilevata da memorizzare.",
                    label = "Soglia di deformazione",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Moltiplicatore utilizzato quando il veicolo ha ruote fuoristrada.",
                    label = "Moltiplicatore di ruote fuoristrada",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Danni extra istantanei non-ruota ripristinare i passaggi dopo la geometria della ruota è ricostruito.",
                    label = "Passaggi di riapplicazione del danno",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Passi istantanei supplementari per pneumatici ancora mancanti o ancora piatti dopo la riparazione di una ruota.",
                    label = "Passi di riapplicazione dello stato delle ruote",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Tenere corpo, motore, finestre, porte, sporco e danni visivi quando la riparazione di pneumatici ricostruisce la geometria della ruota.",
                    label = "Preservare i danni al veicolo",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Ripristinare le finestre rotte senza l'effetto schianto forte dove possibile.",
                    label = "Finestre spezzate tranquille",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Riapplicare i pneumatici ancora piatti senza innescare un nuovo suono o un nuovo effetto pop.",
                    label = "Riapplicazione silenziosa dei pneumatici piatti",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Distanza massima dal pneumatico danneggiato o mancante per l'azione del montaggio.",
                    label = "Distanza di collegamento del pneumatico",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Distanza massima dal posto cric per l'azione di rimozione.",
                    label = "cric rimuovere la distanza",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Moltiplicatori di danni per classe di veicolo GTA.",
                    itemLabel = "Classe del veicolo",
                    label = "Moltiplicatori di classe dei veicoli",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Prevenire Applica mentre esiste un conflitto di gestione critica.",
                    label = "Blocco dei risultati critici",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Decelerazione massima prevista in m/s2 per una prova di frenatura completata.",
                    label = "Decelerazione minima del freno",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Campioni misurati richiesti prima che Telemetry Coach valuti una corsa.",
                    label = "Campioni minimi",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Velocità di scorrimento della ruota misurata in km/h alla quale è segnalata la perdita di trazione.",
                    label = "Avvisatore di slittamento della ruota",
                },
                handlingEditorDefaultTab = {
                    description = "Pagina selezionata ogni volta che l'editor di gestione standalone si apre.",
                    label = "Pagina iniziale",
                    options = {
                        advanced = "Avanzato",
                        export = "Esporta",
                        flags = "Flag",
                        fleet = "Flotta",
                        inspector = "Livelli",
                        profiles = "Profili",
                        simple = "Semplice",
                        telemetry = "Telemetria",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Fornire effetto, gamma di riferimento, sintomi, campi correlati e supporto dal vivo per ogni valore di manipolazione.",
                    label = "Documentazione sul campo",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Search and filter flag names, effects, bit positions and esadecimal masks.",
                    label = "Ricerca bandiera",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Cercare, ispezionare, promuovere e ripristinare il modello e le regole di gestione della piastra.",
                    label = "Gestore della flotta",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Mostra la base del veicolo, l'accordatura personalizzata installata, la regola del modello, la regola della targa e la bozza corrente dell'editor per ogni campo.",
                    label = "Ispettore di livello",
                },
                handlingEditorMaxFleetResults = {
                    description = "Regole massime di modelli e targhe caricate in Fleet Manager.",
                    label = "Limite dei risultati della flotta",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Numero massimo di revisioni mantenute per ciascun profilo.",
                    label = "Revisione del profilo",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Massimo spazio di lavoro con nome mantenuto per ogni amministratore.",
                    label = "Aree di lavoro personali",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Crea una revisione verificabile ogni volta che un profilo condiviso viene aggiornato o ripristinato.",
                    label = "Versione del profilo",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Crea raccomandazioni trasparenti basate su regole basate su dati di test su strada misurati.",
                    label = "Telemetria Coach",
                },
                handlingEditorValidatorEnabled = {
                    description = "Rilevare combinazioni non sicure o contraddittorie prima dell'applicazione della manipolazione.",
                    label = "Validatore di gestione",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Permetti agli amministratori di mantenere le bozze private dell'editor.",
                    label = "Aree di lavoro personali",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "ID di classe veicolo che utilizzano sempre la normale installazione meccanica senza ascensore specializzato o flussi di minigiochi.",
                    label = "Classi di veicoli diversi dai minigame",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modelli di autospawn che utilizzano sempre la normale installazione meccanica senza ascensore specializzato o flussi di minigioco.",
                    label = "Modelli di veicoli diversi dal minimo",
                },
                tuningBlockedPlates = {
                    description = "I veicoli con una di queste piastre non possono essere sintonizzati, installati, o devono essere rimossi. L'abbinamento ignora l'involucro e lo spazio bianco.",
                    itemLabel = "targa",
                    label = "Piastre di regolazione bloccate",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Blocca gli altri lavori se ci sono meccanici in servizio",
                },
                allowsprint = {
                    label = "Consenti lo scatto con le scatole delle consegne",
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
            tuningCategories = {
                bodywork = "Carrozzeria e aspetto",
                electronics = "ECU ed elettronica del veicolo",
                engineSounds = "Suoni del motore",
                handling = "Maneggevolezza",
                lights = "Luci",
                other = "Altro",
                paint = "Verniciatura",
                performance = "Prestazioni",
                stance = "Assetto",
                wheels = "Ruote",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "Anti-Lag",
                    values = {
                        [0] = "Disattivato",
                        [1] = "Standard GTA",
                        [2] = "Scoppi stradali",
                        [3] = "Anti-Lag da gara",
                        [4] = "Anti-Lag rally",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Quattro frecce automatiche",
                    values = {
                        [0] = "Disattivate",
                        [1] = "Attivate",
                    },
                },
                electronic_brake_lights = {
                    label = "Luci freno",
                    values = {
                        [0] = "Normali",
                        [1] = "Lampeggio emergenza",
                        [2] = "Disattivate",
                    },
                },
                electronic_engine_tune = {
                    label = "Software motore",
                    values = {
                        [0] = "Serie",
                        [1] = "Fase 1",
                        [2] = "Fase 2",
                        [3] = "Fase 3",
                        [4] = "Fase 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Luminosità fari",
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
                    label = "Abbaglianti con clacson",
                    values = {
                        [0] = "Disattivati",
                        [1] = "Attivati",
                    },
                },
                electronic_idle_rpm = {
                    label = "Giri al minimo",
                    values = {
                        [0] = "Serie",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Luce abitacolo",
                    values = {
                        [0] = "Normale",
                        [1] = "Rossa",
                    },
                },
                electronic_mood_color = {
                    label = "Colore luce ambiente",
                    values = {
                        [0] = "Disattivata",
                        [1] = "Rosso",
                        [10] = "Calce",
                        [11] = "Turchese",
                        [12] = "Indaco",
                        [13] = "Bianco",
                        [14] = "Bianco caldo",
                        [15] = "Bianco freddo",
                        [16] = "Ambra",
                        [2] = "Blu",
                        [3] = "Verde",
                        [4] = "Ciano",
                        [5] = "Magenta",
                        [6] = "Giallo",
                        [7] = "Arancione",
                        [8] = "Viola",
                        [9] = "Rosa",
                    },
                },
                electronic_mood_intensity = {
                    label = "Intensità luce ambiente",
                    values = {
                        [0] = "Bassa",
                        [1] = "Normale",
                        [2] = "Alta",
                    },
                },
                electronic_radio_power = {
                    label = "Alimentazione radio",
                    values = {
                        [0] = "Disattivata",
                        [1] = "Attivata",
                    },
                },
                electronic_throttle_response = {
                    label = "Risposta acceleratore",
                    values = {
                        [0] = "Più trazione",
                        [1] = "Aggressiva",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Taratura impennata",
                    values = {
                        [0] = "Disattivata",
                        [1] = "Morbida",
                        [2] = "Intensa",
                    },
                },
            },
            vehicleClassLabel = "Classe {id} ({name})",
        },
    },
}
