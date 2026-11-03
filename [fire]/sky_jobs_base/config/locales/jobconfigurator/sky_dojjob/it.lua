JobConfigLocales["sky_dojjob:it"] = {
    Nui = {
        tablet = {
            apps = {
                doj_finance = "Finanze",
                doj_conditions = "Prescrizioni",
                doj_elections = "Elezioni",
                doj_files = "Archivio fascicoli",
                doj_hearings = "Udienze",
                doj_law = "Codici legali",
                doj_offences = "Bel catalogo",
                doj_shared_files = "Documenti condivisi",
            },
        },
        workshopConfig = {
            registryFiles = { licenseType = "Tipo di licenza", licenseLabel = "Nome del registro", marriages = "Registro dei matrimoni" },
            configs = {
                sky_dojjob = {
                    subtitle = "Configura i lavori DOJ, le sedi del tribunale e l'app del codice legale.",
                    title = "Lavori del Dipartimento di Giustizia",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Tribunale",
                    entryPluralLabel = "Tribunali",
                    label = "Tribunali",
                },
            },
            extensions = {
                invalidSelection = "Selezione non valida: {value}",
                trainingSettings = {
                    description = "Configura l'accesso alla formazione, l'iscrizione, le approvazioni e la pianificazione del corso per questo lavoro.",
                    label = "Impostazioni di allenamento",
                },
            },
            features = {
                dojHandovers = {
                    label = "Passaggi di consegne",
                    description = "Abilita i passaggi di consegne, le decisioni giudiziarie e i rapporti di esecuzione. Documenti e condivisione restano disponibili.",
                },
                dojBodycamRequests = {
                    label = "Richieste di registrazioni bodycam",
                    description = "Richiedi filmati della polizia. Richiede i passaggi di consegne; le registrazioni salvate restano disponibili separatamente.",
                },
                dojFinance = { label = "Finanze", description = "Saldi delle fazioni, trasferimenti del tesoro e storico." },
                dojConditions = {
                    description = "Abilita prescrizioni strutturate, prove, scadenze e gestione delle violazioni.",
                    label = "Prescrizioni",
                },
                dojCourtroom = {
                    description = "Abilita sessioni d'aula sicure, presentazione delle prove e interazioni basate sui ruoli.",
                    label = "Aula in tempo reale",
                },
                dojElections = {
                    description = "Abilita la gestione delle elezioni e il voto sicuro nelle cabine elettorali registrate.",
                    label = "Elezioni",
                },
                dojHearings = {
                    description = "Abilita la pianificazione delle aule, il check-in e lo stato ufficiale delle udienze.",
                    label = "Udienze",
                },
                dojLegalCodes = {
                    description = "Abilita la cronologia dei libri legali, delle modifiche di testo e delle revisioni.",
                    label = "Codici giuridici",
                },
                dojOffences = {
                    description = "Abilitare il catalogo compatto reato e l'anteprima della calcolatrice.",
                    label = "catalogo delle multe",
                },
                dojPrinters = {
                    description = "Abilita le stampanti fisiche e la relativa infrastruttura di runtime.",
                    label = "Stampanti",
                },
                dojPublicDisplays = {
                    description = "Abilita dati in tempo reale filtrati per la privacy sugli schermi del tribunale.",
                    label = "Schermi pubblici delle aule",
                },
                dojTablet = {
                    description = "Abilita l'accesso alle applicazioni per tablet DOJ.",
                    label = "tablet DOJ",
                },
                dojTaxes = {
                    description = "Riscuote periodicamente le imposte su veicoli e case dai giocatori online.",
                    label = "Imposte patrimoniali",
                },
            },
            locations = {
                stationPosition = "Sede / icona sulla mappa",
                stationPositionHint = "Punto principale di questa sede del lavoro. Se l'icona sulla mappa è attivata in Lavoro → Blip, appare qui.",
                addCourtroom = "Aggiungi aula di tribunale",
                courtroom = "Aula di tribunale",
                courtroom_display_desk_27 = "Schermo prove – monitor da scrivania da 27 pollici",
                courtroom_display_wall_55 = "Schermo prove – TV a parete da 55 pollici",
                courtroom_display_wall_75 = "Schermo prove – TV a parete da 75 pollici",
                courtroom_display_wall_100 = "Schermo prove – TV a parete da 100 pollici",
                courtroom_display_wall_120 = "Schermo prove – TV a parete da 120 pollici",
                courtroom_display_wall_150 = "Schermo prove – TV a parete da 150 pollici",
                courtroom_display_board_93 = "Lavagna interattiva – 150 pollici con carrello",
                courtroom_display_projection = "Schermo prove dell’aula – schermo da proiezione da 4,5 m",
                courtroom_judge_mic = "Aula – microfono del giudice",
                courtroom_jury_room = "Aula – sala della giuria",
                courtroom_room = "Aula – centro pubblico / aula",
                courtroom_witness = "Aula – postazione del testimone",
                electionBooth = "Cabina elettorale",
                publicDisplayDesk27 = "Schermo pubblico – monitor da scrivania da 27 pollici",
                publicDisplayTerminal43 = "Schermo pubblico – terminale da pavimento da 43 pollici",
                publicDisplayWall55 = "Schermo pubblico – TV a parete da 55 pollici",
                publicDisplayWall75 = "Schermo pubblico – TV a parete da 75 pollici",
                publicDisplayWall100 = "Schermo pubblico – TV a parete da 100 pollici",
                publicDisplayWall120 = "Schermo pubblico – TV a parete da 120 pollici",
                publicDisplayWall150 = "Schermo pubblico – TV a parete da 150 pollici",
                publicDisplayProjection = "Display pubblico – schermo da proiezione da 4,5 m",
                publicLegalCode = "Codice giuridico pubblico",
            },
            printers = {
                groups = {
                    paper = "Carta",
                    ink = "Inchiostro",
                    general = "Stampante",
                    printing = "Stampa e accesso",
                    placement = "Modello e posizione",
                },
                actions = {
                    selectExisting = "Seleziona stampante esistente",
                    selectExistingHint = "Punta la stampante. Invio: seleziona · Esc: annulla",
                    add = "Aggiungi stampante",
                    open = "Controlla stampante",
                    place = "Posiziona stampante",
                    setPosition = "Usa la posizione attuale",
                },
                classes = {
                    office = "Ufficio",
                    professional = "Professionale",
                    standard = "Norma",
                },
                description = "Configura stampanti, materiali di consumo, code, accesso e posizionamento per questo lavoro.",
                fieldDescriptions = {
                    paperCapacity = "Quantità massima di carta usata da ogni stampante di questo lavoro.",
                    paperEnabled = "Se attivo, tutte le stampanti di questo lavoro partono vuote e richiedono l'oggetto di ricarica condiviso.",
                    refillAmount = "Carta aggiunta a qualsiasi stampante di questo lavoro usando l'oggetto di ricarica condiviso.",
                    refillItem = "Nome interno dell'oggetto di inventario consumato quando viene ricaricata una stampante di questo lavoro.",
                },
                fields = {
                    active = "Attiva",
                    class = "Classe",
                    heading = "Orientamento",
                    id = "ID stabile",
                    label = "Etichetta",
                    maxQueue = "Capacità coda",
                    minimumGrade = "Grado minimo",
                    paperCapacity = "Capacità carta",
                    paperEnabled = "Richiedi ricariche di carta",
                    propModel = "Modello oggetto",
                    refillAmount = "Carta per oggetto di ricarica",
                    refillItem = "Oggetto di ricarica",
                    deleteCopiesAfterRestart = "Elimina copie al riavvio",
                    deleteCopiesAfterRestartHint = "Elimina le stampe non ritirate al riavvio del servizio di stampa.",
                    spawnProp = "Genera oggetto",
                    speed = "Velocità di stampa",
                    status = "Stato",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Classe: {class}",
                    paper = "Carta: {paper} / {capacity}",
                    queue = "Coda: {queue} / {maxQueue}",
                    status = "Stato: {status}",
                    title = "Stampante",
                },
                messages = {
                    grade_too_low = "Il tuo grado è troppo basso per questa stampante.",
                    invalid_amount = "La quantità di ricarica non è valida.",
                    missingModel = "Seleziona un modello oggetto valido prima del posizionamento.",
                    missing_refill_item = "Non hai l'oggetto di ricarica configurato.",
                    no_refill_printer = "Nessuna stampante accessibile con carta attiva è nelle vicinanze.",
                    paper_capacity_exceeded = "La capacità della carta verrebbe superata.",
                    paper_disabled = "La gestione della carta è disattivata per questa stampante.",
                    paper_full = "La scorta di carta di questa stampante è già piena.",
                    printer_inactive = "Questa stampante è inattiva.",
                    printer_not_found = "La stampante non esiste più.",
                    refill_cooldown = "Attendi un momento prima di ricaricare di nuovo.",
                    refilled = "Aggiunte {amount} unità di carta. Scorta: {paper} / {capacity}.",
                    too_far_away = "Avvicinati alla stampante.",
                    unavailable = "Stampante non disponibile.",
                    wrong_job = "Non appartieni al lavoro di questa stampante.",
                },
                settings = {
                    description = "Queste impostazioni si applicano a tutte le stampanti configurate per questo lavoro.",
                    title = "Impostazioni stampanti del lavoro",
                },
                statuses = {
                    maintenance = "Manutenzione",
                    offline = "Fuori rete",
                    online = "In linea",
                },
                title = "Stampanti",
                values = {
                    disabled = "Disabilitato",
                    enabled = "Abilitato",
                    selectItem = "Seleziona oggetto",
                },
            },
            recordsAccessGuide = {
                description = "Scegli chi può accedere ai fascicoli e in quale ambito opera. I gradi senza assegnazione non hanno accesso.",
                grades = {
                    assigned = "gradi assegnati",
                    chooseDomain = "Risolvi assegnazione",
                    conflict = "Un grado ha più assegnazioni. Seleziona un ambito o Nessun accesso per risolvere il conflitto.",
                    description = "Seleziona un ambito per ogni grado. Scegli Nessun accesso per i gradi da mantenere bloccati.",
                    domainColumn = "Ambito",
                    empty = "Non sono stati trovati gradi per il job DOJ configurato.",
                    emptyHint = "Crea prima i gradi DOJ nel framework, quindi riapri il configuratore.",
                    gradeColumn = "Grado",
                    noAccess = "Nessun accesso",
                    noResults = "Nessun grado corrispondente trovato.",
                    notFound = "Non più presente nel framework",
                    search = "Cerca gradi",
                    title = "Gradi e ambiti",
                },
                publish = {
                    saveHint = "Fai clic su Salva in alto per applicare le modifiche. I giocatori potranno quindi verificare di nuovo il proprio accesso.",
                },
                status = {
                    conflict = "Risolvi le associazioni duplicate",
                    disabled = "Tablet DOJ disattivato",
                    incomplete = "Associa almeno un grado",
                    ready = "Pronto per il salvataggio",
                    unpublished = "Mappatura non ancora pubblicata",
                },
                steps = {
                    gradesText = "Seleziona una sola area degli atti per ogni grado che deve ricevere l'accesso.",
                    gradesTitle = "Associa i gradi DOJ",
                    publishText = "Dopo ogni modifica viene preparata automaticamente una nuova versione della mappatura.",
                    publishTitle = "Pubblica e salva",
                    tabletText = "Il tablet deve essere attivo per aprire le app dei fascicoli.",
                    tabletTitle = "Attiva il tablet DOJ",
                },
                title = "Configura l'accesso agli atti",
            },
            settingGroups = {
                dojWarrants = { label = "Mandati giudiziari" },
                dojAccess = {
                    label = "Accesso",
                },
                dojCourthouseBlip = {
                    label = "Mappa blip",
                },
                dojLegalBooks = {
                    label = "Libri",
                },
                dojLegalContentLimits = {
                    label = "Limiti di contenuto",
                },
                dojLegalItem = {
                    label = "Oggetto inventario",
                },
                dojLegalRateLimits = {
                    label = "Limiti di frequenza",
                },
                dojLegalRevisions = {
                    label = "Revisioni",
                },
                dojLegalTransfers = {
                    label = "Documenti di grandi dimensioni",
                },
                dojOffenceCalculation = {
                    label = "Calcolatore",
                },
                dojOffenceRateLimits = {
                    label = "Limiti di frequenza",
                },
                dojOffenceMiranda = {
                    label = "Indicazioni del catalogo",
                },
                dojOffenceSource = {
                    label = "Fonte del catalogo",
                },
                dojRecordsGradeBindings = {
                    description = "Associa ogni grado DOJ disponibile a una sola area degli atti, quindi pubblica la mappatura.",
                    label = "Gradi e aree degli atti",
                },
                dojTaxPayment = {
                    label = "Pagamento",
                },
                dojTaxRates = {
                    label = "Aliquote",
                },
                dojTaxSchedule = {
                    label = "Pianificazione",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Contratti notarili",
                    powers_of_attorney = "Procure",
                    name_changes = "Cambi di nome",
                    company_registry = "Registro delle imprese",
                    association_registry = "Registro delle associazioni",
                    licensing = "Licenze",
                    administrative_decisions = "Decisioni amministrative",
                    administrative_objections = "Ricorsi amministrativi",
                },
            },
            settingSections = {
                finance = "Finanze",
                registries = "Registri",
                courthouses = "Tribunali",
                general = "Generale",
                legalCodes = "Codici giuridici",
                offences = "catalogo delle multe",
                recordsAccess = "Accesso agli atti",
                tablet = "tablet",
                taxes = "Imposte",
                courtroom = "Aula di tribunale",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registri delle licenze",
                    description = "Scegli le licenze che il DOJ può rilasciare. Ogni voce ha un registro separato. La rimozione di una voce non revoca le licenze esistenti.",
                },
                dojRegistryAccess = {
                    ["label"] = "Accesso ai registri da file",
                    ["description"] = "Modifica l’accesso ai registri in config/registry. Un elenco vuoto usa i valori predefiniti dei file. Campi e funzioni server/client si modificano nei file Lua.",
                },
                dojTreasuryJob = { label = "Lavoro del tesoro", description = "Lavoro il cui conto condiviso riceve gli incassi e paga i trasferimenti." },
                dojFinanceJobs = { label = "Fazioni visibili", description = "Chiavi dei lavori registrati presenti nei conti. Il tesoro è sempre incluso." },
                dojFinanceLimit = { label = "Limite per operazione", description = "Importo massimo per trasferimento o riscossione." },
                dojFinePaymentMode = { label = "Pagamento delle sanzioni", description = "Pagamento bancario diretto o fattura esterna. Creare una fattura non conferma il pagamento.", options = { bank = "Pagamento bancario", billing = "Fattura" } },
                dojFineSociety = { label = "Destinatario delle sanzioni", description = "Lavoro il cui conto condiviso riceve le sanzioni imposte." },
                dojHearingParticipantRoles = {
                    label = "Ruoli dei partecipanti",
                    description = "Ruoli predefiniti: defendant (imputato), witness (testimone), juror (giurato), judge (giudice). Aggiungi chiavi in minuscolo (massimo 24 caratteri, trattini bassi consentiti). Mantieni judge. I ruoli personalizzati non assegnano permessi di giudice o giuria.",
                },
                dojWarrantTemplateCodes = {
                    label = "Codici dei modelli di mandato",
                    description = "Codici dei modelli mostrati nei mandati della polizia dopo la firma giudiziaria e la condivisione. Predefiniti: HB, DB, RB.",
                },
                dojCourtroomBoardMove = { label = "Spostare la lavagna", description = "Tasto predefinito per prendere o rilasciare la lavagna (es. F). I giocatori possono cambiarlo nei comandi FiveM. La posizione si ripristina al riavvio." },
                dojRegistryCatalog = {
                    label = "Registri DOJ",
                    description = "Attiva e rinomina i registri DOJ, poi imposta accesso ai lavori e livelli di autorizzazione. Restano validi i permessi dei ruoli DOJ. I registri RP personalizzati si gestiscono in Jobs Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Categoria etichetta utilizzata per la mappa del tribunale blip.",
                    label = "Categoria blip",
                },
                dojCourthouseBlipColor = {
                    description = "Colore della mappa utilizzato per i tribunali.",
                    label = "Colore blip",
                },
                dojCourthouseBlipScale = {
                    description = "Scala mappa utilizzata per il tribunale blip.",
                    label = "Scala blip",
                },
                dojCourthouseBlipShortRange = {
                    description = "Mostra solo il tribunale blip a breve distanza.",
                    label = "Campo corto",
                },
                dojCourthouseBlipSprite = {
                    description = "Sprite della mappa usato per i tribunali.",
                    label = "Sprite blip",
                },
                dojLegalBookItem = {
                    description = "Oggetto per un'edizione fissa dei codici. Il primo utilizzo salva contenuto e data; richiede oggetti singoli con metadati.",
                    label = "Oggetto libro dei codici",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Millisecondi minimi tra richieste di creazione di libri legali.",
                    label = "Crea libro tempo di attesa",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Millisecondi minimi tra le richieste di creazione di revisione.",
                    label = "Crea revisione tempo di attesa",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Millisecondi minimi tra richieste di cancellazione di libri legali.",
                    label = "Elimina libro tempo di attesa",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Millisecondi minimi tra le richieste di cancellazione della revisione.",
                    label = "Elimina revisione tempo di attesa",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Millisecondi minimi tra le richieste di un libro legale.",
                    label = "Carica libro tempo di attesa",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Millisecondi minimi tra le richieste per la lista di libri legali.",
                    label = "Carica libreria tempo di attesa",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Timeout minimo utilizzato per richieste di documenti di grandi dimensioni.",
                    label = "Timeout richiesta grande in millisecondi",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Numero massimo di caratteri ammessi in un'abbreviazione di libro legale.",
                    label = "Lunghezza massima abbreviazione",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Numero massimo di caratteri ammessi in un titolo di libro legale.",
                    label = "Lunghezza massima del titolo del libro",
                },
                dojLegalMaxContentBytes = {
                    description = "Dimensione massima serializzata di una revisione completa del libro legale.",
                    label = "Dimensione massima del contenuto in byte",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Lunghezza massima del titolo accettata durante l'importazione di paragrafi strutturati legacy.",
                    label = "Lunghezza massima del paragrafo legacy",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Numero massimo di paragrafi strutturati accettati durante le importazioni precedenti.",
                    label = "Massimo paragrafo legacy per libro",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Numero massimo di caratteri ammessi in una nota di revisione.",
                    label = "Lunghezza massima della nota di revisione",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Numero massimo consentito di nodi di editor in una revisione.",
                    label = "Nodi di testo ricchi massimi",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Limite di banda per giocatore usato per trasferire documenti legali di grandi dimensioni.",
                    label = "Tasso di trasferimento in byte al secondo",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Millisecondi minimi tra richieste di riordino di libri legali.",
                    label = "Riordinare i libri tempo di attesa",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Millisecondi minimi tra gli aggiornamenti dei metadati del libro legale.",
                    label = "Aggiorna tempo di attesa",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Numero massimo di revisioni caricate all'apertura di un libro giuridico.",
                    label = "Cronologia delle revisioni visibile",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Millisecondi minimi tra le anteprime della calcolatrice lato server.",
                    label = "Calcolatore tempo di attesa",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Millisecondi minimi tra le richieste di catalogo.",
                    label = "Carica catalogo tempo di attesa",
                },
                dojOffenceMaxSelection = {
                    description = "Numero massimo di reati incluso in un'anteprima calcolatrice.",
                    label = "Selezione massima",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Millisecondi minimi tra le modifiche al catalogo reato.",
                    label = "Catalogo modifica tempo di attesa",
                },
                dojOffenceMirandaWarning = {
                    description = "Avviso personalizzato mostrato nel catalogo delle sanzioni. Lascia vuoto per usare il testo predefinito nella lingua selezionata.",
                    label = "Avviso Miranda",
                },
                dojPrimaryColor = {
                    description = "Colore principale utilizzato dal gruppo di lavoro DOJ e tablet.",
                    label = "Colore primario",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Questi gradi lavorano con gli atti amministrativi e di cancelleria.",
                    label = "Amministrazione giudiziaria",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Questi gradi lavorano con gli atti e le decisioni giudiziarie.",
                    label = "Magistratura",
                },
                dojRecordsMappingVersion = {
                    description = "Revisione pubblicata della mappatura tra gradi e aree degli atti. Un valore vuoto mantiene bloccato l'accesso.",
                    label = "Versione di pubblicazione",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Questi gradi lavorano con gli atti della procura.",
                    label = "Procura",
                },
                dojTabletRequireDuty = {
                    description = "Solo i dipendenti servizio DOJ possono aprire l'app del codice legale.",
                    label = "Richiede servizio",
                },
                dojTaxCurrency = {
                    description = "Valuta Sky Base usata solo quando il metodo di pagamento è diretto.",
                    label = "Valuta per addebito diretto",
                },
                dojTaxHouseAmount = {
                    description = "Importo addebitato per ogni casa posseduta da un giocatore.",
                    label = "Imposta per casa",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Secondi prima della prima riscossione quando non è salvato alcun ciclo fiscale precedente.",
                    label = "Ritardo iniziale",
                },
                dojTaxIntervalMinutes = {
                    description = "Minuti tra i cicli automatici di riscossione delle imposte patrimoniali.",
                    label = "Intervallo di riscossione",
                },
                dojTaxNotifyPlayer = {
                    description = "Notifica i giocatori dopo un addebito diretto, l'invio di una fattura o quando i fondi non sono sufficienti.",
                    label = "Notifica i giocatori",
                },
                dojTaxPaymentMode = {
                    description = "Usa direttamente il saldo bank/money selezionato oppure invia una fattura societaria Sky Base per ogni giocatore soggetto a imposta e ciclo fiscale.",
                    label = "Metodo di pagamento",
                    options = {
                        bills = "Fatture Sky Base",
                        direct = "Saldo bank/money",
                    },
                },
                dojTaxSocietyJob = {
                    description = "Lavoro DOJ il cui conto società configurato riceve tutte le entrate fiscali.",
                    label = "Lavoro DOJ destinatario",
                },
                dojTaxVehicleAmount = {
                    description = "Importo addebitato per ogni veicolo posseduto da un giocatore.",
                    label = "Imposta per veicolo",
                },
                dojCourtroomGavel = {
                    label = "Giudice Martelletto",
                    description = "Modello Gavel, attaccamento a mano, animazione, suono e schemi di sciopero. Le modifiche si applicano anche senza riavviare.",
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
            gavel = {
                enabled = "Abilitato",
                cooldown = "Raffreddamento dell'innesco (ms)",
                defaultPreset = "Schema di strike predefinito",
                prop = "Propulsore di caviglia",
                model = "Nome del modello",
                bone = "Osso della mano ID",
                offset = "Spostamento (metri)",
                rotation = "Rotazione (gradi)",
                presets = "Schemi di strike",
                single = "Sciopero unico",
                double = "Doppio colpo",
                strikes = "Numero di scioperi",
                interval = "Intervallo di strike (ms)",
                impact = "Ritardo acustico (ms)",
                audio = "Suono",
                asset = "Attività audio",
                volume = "Volume",
                animation = "Animazione",
                dict = "Dizionario animazione",
                clip = "Nome animazione",
                duration = "Durata del movimento (ms)",
                flag = "Opzioni di animazione",
                x = "X",
                y = "Y",
                z = "Z",
            },
        },
    },
}
