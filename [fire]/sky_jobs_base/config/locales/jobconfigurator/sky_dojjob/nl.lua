JobConfigLocales["sky_dojjob:nl"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Financiën" ,
                doj_conditions = "Condities",
                doj_elections = "Verkiezingen",
                doj_files = "Case-bestandsverkenner",
                doj_hearings = "Hoorzitting",
                doj_law = "Juridische Codes",
                doj_offences = "Fijne catalogus",
                doj_shared_files = "Gedeelde documenten",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Toegang tot dossiers instellen",
                description = "Kies wie dossiers mag openen en in welk domein diegene werkt. Rangen zonder toewijzing hebben geen toegang.",
                status = {
                    unpublished = "De toewijzing is nog niet gepubliceerd",
                    conflict = "Los dubbele toewijzingen op",
                    disabled = "De DOJ-tablet is uitgeschakeld",
                    incomplete = "Wijs minimaal één rang toe",
                    ready = "Klaar om op te slaan",
                },
                steps = {
                    tabletTitle = "DOJ-tablet inschakelen",
                    tabletText = "De tablet moet ingeschakeld zijn om de dossierapps te openen.",
                    gradesTitle = "DOJ-rangen toewijzen",
                    gradesText = "Kies precies één dossierdomein voor elke rang die toegang moet krijgen.",
                    publishTitle = "Publiceren en opslaan",
                    publishText = "Na elke wijziging aan de toewijzing wordt automatisch een nieuwe versie voorbereid.",
                },
                grades = {
                    title = "Rangtoewijzingen",
                    description = "Kies één domein per rang. Kies Geen toegang voor rangen die uitgesloten moeten blijven.",
                    search = "Rangen zoeken",
                    conflict = "Een rang heeft meerdere toewijzingen. Kies één domein of Geen toegang om dit op te lossen.",
                    notFound = "Bestaat niet meer in het framework",
                    noResults = "Geen overeenkomstige rang gevonden.",
                    empty = "Geen rangen gevonden voor de ingestelde DOJ-baan.",
                    emptyHint = "Maak de DOJ-rangen eerst aan in je framework en open daarna de configurator opnieuw.",
                    gradeColumn = "Rang",
                    domainColumn = "Dossierdomein",
                    noAccess = "Geen toegang",
                    chooseDomain = "Toewijzing oplossen",
                    assigned = "rangen toegewezen",
                },
                publish = {
                    saveHint = "Klik bovenaan op Opslaan om je wijzigingen toe te passen. Spelers kunnen daarna hun toegang opnieuw controleren.",
                },
            },
            registryFiles = { licenseType = "Licentietype", licenseLabel = "Registernaam", marriages = "Huwelijksregister" },
            features = {
                dojHandovers = {
                    label = "Overdrachten",
                    description = "Schakelt overdrachten, gerechtelijke beslissingen en uitvoeringsverslagen in. Documenten en delen blijven beschikbaar.",
                },
                dojBodycamRequests = {
                    label = "Bodycamverzoeken",
                    description = "Vraag politiebeelden op. Vereist Overdrachten; opgeslagen opnamen blijven afzonderlijk beschikbaar.",
                },
                dojFinance = { label = "Financiën", description = "Factiesaldi, staatsoverschrijvingen en transactiegeschiedenis." },
                dojConditions = {
                    description = "Activeer gestructureerde voorwaarden, bewijs, deadlines, en schending follow-up.",
                    label = "Condities",
                },
                dojCourtroom = {
                    description = "Activeer beveiligde live-rechtzaalsessies, bewijspresentatie en op rollen gebaseerde kamerinteracties.",
                    label = "Rechtzaal live",
                },
                dojElections = {
                    description = "Activeer verkiezingsadministratie en stem veilig bij stemhokjes.",
                    label = "Verkiezingen",
                },
                dojHearings = {
                    description = "Activeer de planning van de rechtszaal, check-in, en gezaghebbende hoorstatus controles.",
                    label = "Hoorzitting",
                },
                dojLegalCodes = {
                    description = "Activeer juridische boeken, rijke tekst bewerken, en revisie geschiedenis.",
                    label = "Juridische codes",
                },
                dojOffences = {
                    description = "Activeer de compacte bestandscatalogus en rekenvoorbeeld.",
                    label = "Fijne catalogus",
                },
                dojPrinters = {
                    description = "Activeer fysieke printers en hun runtime infrastructuur.",
                    label = "Printers",
                },
                dojPublicDisplays = {
                    description = "Activeer door privacy gefilterde live-gegevens voor gerechtsgebouwdisplays.",
                    label = "Openbare rechtszaal displays",
                },
                dojTablet = {
                    description = "Activeer toegang tot de DOJ tablet-apps.",
                    label = "DOJ-tablet",
                },
                dojTaxes = {
                    description = "Periodiek verzamelen van voertuig en huis belastingen van online spelers.",
                    label = "Vermogensbelastingen",
                },
            },
            settingSections = {
                finance = "Financiën",
                courtroom = "Rechtzaal",
                registries = "Register",
                courthouses = "Rechtbanken",
                general = "Algemeen",
                legalCodes = "Juridische codes",
                offences = "Fijne catalogus",
                recordsAccess = "Toegang tot dossiers",
                tablet = "Tablet",
                taxes = "Belastingen",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Licentieregisters",
                    description = "Kies welke licenties het DOJ mag uitgeven. Elke vermelding krijgt een eigen register. Bestaande licenties blijven behouden bij het verwijderen van een vermelding.",
                },
                dojRegistryAccess = {
                    ["label"] = "Toegang tot registerbestanden",
                    ["description"] = "Pas de toegang tot registers in config/registry aan. Een lege lijst gebruikt de standaardwaarden uit de bestanden. Velden en server-/clientfuncties wijzig je in de Lua-bestanden.",
                },
                dojTreasuryJob = { label = "Baan van staatskas", description = "Baan waarvan de gedeelde rekening inningen ontvangt en overschrijvingen betaalt." },
                dojFinanceJobs = { label = "Zichtbare facties", description = "Sleutels van geregistreerde banen in het rekeningoverzicht. De staatskas staat er altijd bij." },
                dojFinanceLimit = { label = "Transactielimiet", description = "Maximumbedrag per overschrijving of inning." },
                dojFinePaymentMode = { label = "Betaling van opgelegde boetes", description = "Directe bankbetaling of externe factuur. Een aangemaakte factuur bevestigt geen betaling.", options = { bank = "Bankbetaling", billing = "Factuur" } },
                dojFineSociety = { label = "Ontvanger van boetes", description = "Baan waarvan de gedeelde rekening opgelegde boetes ontvangt." },
                dojCourtroomBoardMove = {
                    label = "Verschuif het gerechtshof",
                    description = "Standaard sleutel om een mobiel bord te grijpen of vrij te geven (bv. F). Spelers kunnen het overschrijven in FiveM sleutel bindingen. Beweging is tijdelijk en resetten na herstart.",
                },
                dojCourtroomGavel = {
                    label = "Rechter hamer.",
                    description = "Gavelmodel, handbevestiging, animatie, geluid en stakingspatronen. Wijzigingen zijn ook van toepassing zonder herstart.",
                },
                dojHearingParticipantRoles = {
                    label = "Rol van de deelnemers",
                    description = "Standaard rollen: gedaagde, getuige, jurylid, rechter. Voeg aangepaste kleine rolsleutels hier (tot 24 karakters, onderstrepingen toegestaan). Houd rechter. Aangepaste rollen geven geen rechter of jury toestemmingen.",
                },
                dojWarrantTemplateCodes = {
                    label = "Sjablooncodes voor garanties",
                    description = "Templatecodes weergegeven onder PD Geboden na gerechtelijke handtekening en delen. Standaarden: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ-registers",
                    description = "Activeer en naam DOJ registers, dan instellen beroep toegang en opruiming. Bestaande DOJ role permissies nog steeds van toepassing. Custom RP registers worden beheerd in beroepen Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Categorie label gebruikt voor gerechtsgebouw kaart blips.",
                    label = "Blip categorie",
                },
                dojCourthouseBlipColor = {
                    description = "Kaartkleur gebruikt voor gerechtsgebouwen.",
                    label = "Vervagingskleur",
                },
                dojCourthouseBlipScale = {
                    description = "Kaart schaal gebruikt voor gerechtsgebouw blips.",
                    label = "Bleekschaal",
                },
                dojCourthouseBlipShortRange = {
                    description = "Alleen blips van het gerechtsgebouw van korte afstand.",
                    label = "Kort bereik",
                },
                dojCourthouseBlipSprite = {
                    description = "Kaart sprite gebruikt voor gerechtsgebouwen.",
                    label = "Pictogram van kaartmarkering",
                },
                dojLegalBookItem = {
                    description = "Inventarisitem voor een vaste juridische code editie. Eerste gebruik slaat de inhoud en datum op; vereist individuele items met metagegevens.",
                    label = "Boekpost juridische code",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimum milliseconden tussen wettelijke aanmaakverzoeken.",
                    label = "Book-cooldown maken",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimum milliseconden tussen revisie-aanmaakverzoeken.",
                    label = "Revisiecooldown aanmaken",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimum milliseconden tussen de verzoeken om verwijdering van juridische boeken.",
                    label = "Book-cooldown verwijderen",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimum milliseconden tussen revisie verwijderingsverzoeken.",
                    label = "Revisiecooldown verwijderen",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimum milliseconden tussen verzoeken om een wettelijk boek.",
                    label = "Afkoelen van het boek laden",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimum milliseconden tussen de verzoeken om de juridische lijst.",
                    label = "Afkoelen van bibliotheek laden",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Minimale timeout gebruikt voor grote documentaanvragen.",
                    label = "Groot verzoek timeout in milliseconden",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maximaal aantal tekens toegestaan in een afkorting van een juridisch boek.",
                    label = "Maximale lengte afkorting",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maximaal aantal tekens toegestaan in een juridische titel.",
                    label = "Maximale titellengte van het boek",
                },
                dojLegalMaxContentBytes = {
                    description = "Maximale geserialiseerde grootte van één volledige juridische herziening.",
                    label = "Maximumgrootte in bytes",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maximale titellengte geaccepteerd tijdens het importeren van oude gestructureerde alinea's.",
                    label = "Maximale legacy paragraaf titellengte",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maximum aantal gestructureerde alinea's dat tijdens de oude invoer is aanvaard.",
                    label = "Maximale legacy alinea's per boek",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maximum aantal tekens toegestaan in een revisienotitie.",
                    label = "Maximale revisienotitielengte",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maximum aantal editornodes toegestaan in één revisie.",
                    label = "Maximale rich-text knooppunten",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Per-player bandbreedte limiet gebruikt voor de overdracht van grote juridische documenten.",
                    label = "Overdrachtspercentage in bytes per seconde",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimum milliseconden tussen wettelijke-boek reorder verzoeken.",
                    label = "Boeken opnieuw afkoelen",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minimum milliseconden tussen juridische metadata updates.",
                    label = "Afkoelen van het boek bijwerken",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maximum aantal herzieningen geladen bij het openen van een juridisch boek.",
                    label = "Zichtbare revisiegeschiedenis",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimale milliseconden tussen server-side calculator previews.",
                    label = "Afkoelen van de rekenmachine",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimum milliseconden tussen catalogusverzoeken.",
                    label = "Afkoelen van catalogus laden",
                },
                dojOffenceMaxSelection = {
                    description = "Maximum aantal strafbare feiten opgenomen in één rekenvoorbeeld.",
                    label = "Maximale selectie",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minimum milliseconden tussen wijzigingen in de strafbare feitenlijst.",
                    label = "Catalogus bewerken afkoelen",
                },
                dojOffenceMirandaWarning = {
                    description = "Aangepaste waarschuwing getoond in de fijne catalogus. Laat leeg om de standaard tekst in de geselecteerde taal te gebruiken.",
                    label = "Waarschuwing van Miranda",
                },
                dojPrimaryColor = {
                    description = "Hoofdkleur gebruikt door de DOJ professional groep en tablet.",
                    label = "Primaire kleur",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Deze cijfers werken samen met de administratie en het register.",
                    label = "Rekenkamer",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Deze cijfers werken met gerechtelijke dossiers en beslissingen.",
                    label = "Justitie",
                },
                dojRecordsMappingVersion = {
                    description = "Gepubliceerde herziening van de graad-tot-records-domein mapping. Een lege waarde houdt records toegang uitgeschakeld.",
                    label = "Publicatieversie",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Deze cijfers werken met een strafblad.",
                    label = "Aanklager",
                },
                dojTabletRequireDuty = {
                    description = "Alleen medewerkers op diensttijd DOJ mogen de juridische code-app openen.",
                    label = "Vereist plicht",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Directe valuta",
                },
                dojTaxHouseAmount = {
                    description = "Bedrag in rekening gebracht voor elk huis eigendom van een speler.",
                    label = "Belasting per woning",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Seconden om te wachten voor de eerste inning wanneer er geen vorige belastingcyclus wordt opgeslagen.",
                    label = "Initiële vertraging",
                },
                dojTaxIntervalMinutes = {
                    description = "Minuten tussen automatische asset-tax inning cycli.",
                    label = "Inzamelinterval",
                },
                dojTaxNotifyPlayer = {
                    description = "Licht spelers in na een directe inzameling, een wetsvoorstel of onvoldoende fondsen.",
                    label = "Spelers op de hoogte brengen",
                },
                dojTaxPaymentMode = {
                    description = "Gebruik het geselecteerde bank-/geldsaldo rechtstreeks of dien één Sky Base Society-factuur in per belastbare speler en belastingcyclus.",
                    label = "Betaalmethode",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Bank / geldsaldo",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ beroep wiens geconfigureerde samenleving rekening ontvangt alle geïnde belastinginkomsten.",
                    label = "Ontvanger DOJ beroep",
                },
                dojTaxVehicleAmount = {
                    description = "Bedrag in rekening gebracht voor elk voertuig dat eigendom is van een speler.",
                    label = "Belasting per voertuig",
                },
            },
            printers = {
                groups = {
                    paper = "Papier",
                    ink = "Inkt",
                    general = "Printer",
                    printing = "Afdrukken en toegang",
                    placement = "Model en plaatsing",
                },
                actions = {
                    selectExisting = "Bestaande printer selecteren",
                    selectExistingHint = "Richt op de printer. Enter: selecteren · Esc: annuleren",
                    add = "Printer toevoegen",
                    open = "Printer bekijken",
                    place = "Printer plaatsen",
                    setPosition = "Huidige locatie gebruiken",
                },
                classes = {
                    office = "Kantoor",
                    professional = "Professioneel",
                    standard = "Standaard",
                },
                description = "Configureer printers, verbruiksmaterialen, wachtrijen, toegang en plaatsing voor deze baan.",
                fieldDescriptions = {
                    paperCapacity = "Maximale papiervoorraad per printer van deze baan.",
                    paperEnabled = "Wanneer dit is ingeschakeld, beginnen de printers van deze baan leeg en hebben ze het gezamenlijke navulitem nodig.",
                    refillAmount = "Hoeveelheid papier die met het gezamenlijke navulitem aan een printer van deze baan wordt toegevoegd.",
                    refillItem = "Interne naam van het inventarisitem dat wordt verbruikt bij het bijvullen van een printer van deze baan.",
                },
                fields = {
                    active = "Actief",
                    class = "Klasse",
                    heading = "Richting",
                    id = "Vaste ID",
                    label = "Naam",
                    maxQueue = "Wachtrijcapaciteit",
                    minimumGrade = "Minimale rang",
                    paperCapacity = "Papiercapaciteit",
                    paperEnabled = "Papier bijvullen verplicht",
                    propModel = "Objectmodel",
                    refillAmount = "Papier per navulitem",
                    refillItem = "Navulitem",
                    deleteCopiesAfterRestart = "Kopieën na herstart verwijderen",
                    deleteCopiesAfterRestartHint = "Niet opgehaalde afdrukken verwijderen wanneer de printservice opnieuw start.",
                    spawnProp = "Object plaatsen",
                    speed = "Afdruksnelheid",
                    status = "Status tonen",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Klasse: {class}",
                    paper = "Papier: {paper} / {capacity}",
                    queue = "Wachtrij: {queue} / {maxQueue}",
                    status = "Status: {status}",
                    title = "Printer",
                },
                messages = {
                    grade_too_low = "Je rang is te laag voor deze printer.",
                    invalid_amount = "De navulhoeveelheid is ongeldig.",
                    missingModel = "Kies een geldig printermodel voordat je het plaatst.",
                    missing_refill_item = "Je hebt het ingestelde navulitem niet.",
                    no_refill_printer = "Er is geen toegankelijke printer met papierverbruik in de buurt.",
                    paper_capacity_exceeded = "De papiercapaciteit zou worden overschreden.",
                    paper_disabled = "Papierverbruik is uitgeschakeld voor deze printer.",
                    paper_full = "De papierlade van deze printer is al vol.",
                    printer_inactive = "Deze printer is uitgeschakeld.",
                    printer_not_found = "De printer bestaat niet meer.",
                    refill_cooldown = "Wacht even voordat je opnieuw bijvult.",
                    refilled = "{amount} vellen toegevoegd. Voorraad: {paper} / {capacity}.",
                    too_far_away = "Ga dichter bij de printer staan.",
                    unavailable = "Printer niet beschikbaar.",
                    wrong_job = "Je baan heeft geen toegang tot deze printer.",
                },
                settings = {
                    description = "Deze instellingen gelden voor alle printers die voor deze baan zijn ingesteld.",
                    title = "Printerinstellingen voor deze baan",
                },
                statuses = {
                    maintenance = "Onderhoud",
                    offline = "Offline",
                    online = "Online",
                },
                title = "Printers",
                values = {
                    disabled = "Uitgeschakeld",
                    enabled = "Ingeschakeld",
                    selectItem = "Item kiezen",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Configureer DOJ beroepen, rechtbank locaties, en de juridische code app.",
                    title = "Beroepen van het Ministerie van Justitie",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Rechtbank",
                    entryPluralLabel = "Rechtbanken",
                    label = "Rechtbanken",
                },
            },
            extensions = {
                invalidSelection = "Ongeldige selectie: {value}",
                trainingSettings = {
                    description = "Configureer trainingstoegang, inschrijving, goedkeuringen en cursusplanning voor deze taak.",
                    label = "Trainingsinstellingen",
                },
            },
            locations = {
                stationPosition = "Locatie / map blip",
                stationPositionHint = "Hoofdpunt van deze joblocatie. Als de map blip is ingeschakeld onder Job → Blips, verschijnt deze hier.",
                addCourtroom = "Rechtzaal toevoegen",
                courtroom = "Rechtzaal",
                courtroom_display_desk_27 = "Rechtszaal bewijs display . 27-inch bureau monitor",
                courtroom_display_wall_55 = "Rechtszaal bewijs display . . 55-inch muur TV",
                courtroom_display_wall_75 = "Rechtszaal bewijs display . . 75-inch muur TV",
                courtroom_display_wall_100 = "Rechtszaal bewijs display . . 100-inch muur TV",
                courtroom_display_wall_120 = "Rechtszaal bewijs display . . 120-inch muur TV",
                courtroom_display_wall_150 = "Rechtszaal bewijs display . . 150-inch muur TV",
                courtroom_display_board_93 = "Rechtzaal interactief bord met 150-inch mobiele standaard",
                courtroom_display_projection = "Rechtszaal bewijs display . 4.5 m projectiescherm",
                courtroom_judge_mic = "Rechter microfoon in rechtszaal",
                courtroom_jury_room = "Rechtzaal .. jurykamer",
                courtroom_room = "Rechtzaal / zaalcentrum",
                courtroom_witness = "Getuigenbank voor de rechtbank",
                electionBooth = "Stemmen Booth",
                publicDisplayDesk27 = "Public Display, 27-inch bureaumonitor",
                publicDisplayTerminal43 = "Publiek display: 43-inch Floor Terminal",
                publicDisplayWall55 = "Public Display 55-inch Wall TV",
                publicDisplayWall75 = "Public Display 75-inch Wall TV",
                publicDisplayWall100 = "Public Display 100-inch Wall TV",
                publicDisplayWall120 = "Public Display 120-inch Wall TV",
                publicDisplayWall150 = "Public Display 150-inch Wall TV",
                publicDisplayProjection = "Public Display 4.5 m Projectiescherm",
                publicLegalCode = "Publieke juridische code",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Gerechtelijke bevelen",
                },
                dojAccess = {
                    label = "Toegang",
                },
                dojCourthouseBlip = {
                    label = "Kaartmarkering",
                },
                dojLegalBooks = {
                    label = "Boeken",
                },
                dojLegalContentLimits = {
                    label = "Inhoudslimieten",
                },
                dojLegalItem = {
                    label = "Inventarisitem",
                },
                dojLegalRateLimits = {
                    label = "Snelheidslimieten",
                },
                dojLegalRevisions = {
                    label = "Herzieningen",
                },
                dojLegalTransfers = {
                    label = "Grote documenten",
                },
                dojOffenceCalculation = {
                    label = "Rekenmachine",
                },
                dojOffenceRateLimits = {
                    label = "Snelheidslimieten",
                },
                dojOffenceMiranda = {
                    label = "Catalogusgids",
                },
                dojOffenceSource = {
                    label = "Catalogusbron",
                },
                dojRecordsGradeBindings = {
                    description = "Wijs elke beschikbare DOJ graad toe aan precies één registratie domein, en publiceer vervolgens de mapping.",
                    label = "Klassen en registratiedomeinen",
                },
                dojTaxPayment = {
                    label = "Betaling",
                },
                dojTaxRates = {
                    label = "Tarieven",
                },
                dojTaxSchedule = {
                    label = "Schema",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notariële contracten",
                    powers_of_attorney = "Bevoegdheid van de advocaat",
                    name_changes = "Naamwijzigingen",
                    company_registry = "Bedrijfsregister",
                    association_registry = "Associatieregister",
                    licensing = "Vergunningen",
                    administrative_decisions = "Administratieve besluiten",
                    administrative_objections = "Administratieve bezwaren",
                },
            },
            gavel = {
                enabled = "Ingeschakeld",
                cooldown = "Afkoelen activeren (ms)",
                defaultPreset = "Standaard slagpatroon",
                prop = "Gavelprop",
                model = "Modelnaam",
                bone = "Handbeen ID",
                offset = "Verschuiving (meters)",
                rotation = "Rotatie (graden)",
                presets = "Strike patronen",
                single = "Enkelvoudige staking",
                double = "Dubbele staking",
                strikes = "Aantal stakingen",
                interval = "Interval tussen slagen (ms)",
                impact = "Geluidsvertraging (ms)",
                audio = "Geluid",
                asset = "Audioactiva",
                volume = "Volume",
                animation = "Animatie",
                dict = "Animatiewoordenboek",
                clip = "Animatienaam",
                duration = "Bewegingsduur (ms)",
                flag = "Animatievlaggen",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Hiermee kunnen werknemers zichzelf inschrijven voor beschikbare trainingssessies.",
                approvalRequired = "Houdt zelfinschrijvingen in behandeling totdat een geautoriseerde instructeur deze goedkeurt.",
                defaultCapacity = "Standaardaantal stoelen dat wordt gebruikt wanneer een nieuwe trainingssessie wordt gemaakt.",
                enabled = "Maakt de trainingsapp beschikbaar voor deze taak.",
                requireOnDuty = "Vereist dat werknemers dienst hebben voordat ze de Trainingsapp openen of gebruiken.",
                upcomingDays = "Aantal toekomstige dagen weergegeven in het Training App-schema.",
            },
            trainingFields = {
                allowSelfEnrollment = "Zelfinschrijving toestaan",
                approvalRequired = "Goedkeuring van inschrijving vereisen",
                defaultCapacity = "Standaardcapaciteit",
                enabled = "Schakel training in",
                requireOnDuty = "Vereist plicht",
                upcomingDays = "Komende periode (dagen)",
            },
        },
    },
}
