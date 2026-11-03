JobConfigLocales["sky_policejob:nl"] = {
    JobConfiguratorComingSoon = "Deze functieconfigurator komt binnenkort beschikbaar.",
    JobConfiguratorNoPermission = "Je hebt geen toestemming om dit commando te gebruiken.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configureer politieafdelingen, winkels, voorwerpen, voertuigen, stations en kerninstellingen.",
                    title = "Politiebanen",
                },
            },
            dispatchActions = {
                addChannel = "Radiokanaal toevoegen",
                addKeyword = "Steekwoord toevoegen",
                addPoi = "POI toevoegen",
                addReporter = "Melder toevoegen",
                addStatus = "FMS-status toevoegen",
                addVehicle = "Virtuele eenheid toevoegen",
                addVehicleType = "Eenheidstype toevoegen",
                currentLocation = "Gebruik huidige locatie",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Wijst onmiddellijk overeenkomende beschikbare eenheden toe wanneer er een incident wordt gecreëerd.",
                available = "Eenheden met deze status kunnen worden voorgesteld en toegewezen aan een nieuw incident.",
                averageResponseSpeedKmh = "Berekent de weergegeven aankomstschatting op basis van een rechte lijnafstand.",
                callsign = "Unieke radioroepnaam die wordt weergegeven wanneer spelers deze virtuele eenheid bemannen.",
                centerEnabled = "Hiermee kunnen geautoriseerde dienstdoende leden een meldkamer bemannen.",
                channelId = "Radiokanaal-ID voor PMA Voice, SaltyChat en YACA. Numerieke ID's zoals 2500 blijven ongewijzigd; PMA Voice wijst tekst-ID's toe aan een stabiel getal.",
                channelLabel = "Leesbare kanaalnaam getoond aan coördinatoren en eenheden.",
                crewCapacity = "Maximaal aantal personen dat deze eenheid kan bemannen. Gebruik 0 voor onbeperkte bemanning.",
                defaultChannel = "Dispatchers sluiten zich aan bij dit kanaal wanneer ze aan hun dienst beginnen. Eenheden worden handmatig lid via het tabblad Radio. Selecteer Geen om de standaard voor de taakgroep te gebruiken.",
                emergencyAppEnabled = "Maakt deze taak selecteerbaar als een openbare dienst in de Noodtelefoon-app.",
                enabled = "Maakt deze taak beschikbaar voor de Dispatch-app en cross-job-incidenten.",
                icon = "Selecteer het pictogram dat voor deze toestelcategorie wordt weergegeven in de Dispatch-app.",
                incidentAssessmentEnabled = "Toont medische en gevarenbeoordelingsvragen in de volledige incidentintake.",
                jobs = "Extra functienamen die incidenten ontvangen met dit trefwoord.",
                joinLocked = "Voorkomt dat extra personen zich aansluiten nadat de eenheid is bemand.",
                minimumCrew = "Minimaal aantal personen in de voor dit inzetvoorstel geselecteerde eenheden.",
                noUnitFallback = "Stuurt, zonder centrum of bemande eenheid, een Sky-melding naar alle dienstdoende leden.",
                poiId = "Vaste technische identificatie waarnaar meldkamerprofielen ook na een naamswijziging kunnen verwijzen.",
                radius = "Maximale afstand in meters waarop de stationsmededeling kan worden gehoord.",
                readyStatusCode = "FMS-status die wordt ingesteld zodra deze resource inzetgereed is.",
                requirements = "Antwoordvraag als TYPE:COUNT-paren, bijvoorbeeld PATROL:2,CRIME:1.",
                resourceType = "Classificeert de operationele resource voor filters en coördinatie in de meldkamer.",
                respondingStatusCode = "FMS-status die wordt ingesteld zodra deze resource naar een incident uitrukt.",
                shortLabel = "Optioneel kort label op de zes geheugenknoppen voor radiokanalen.",
                stationId = "Koppelt deze eenheid aan een standplaats uit het meldkamerprofiel.",
                statusCode = "Numerieke FMS-status weergegeven op de handradio.",
                statusLabel = "Betekenis van deze FMS-status voor coördinatoren en eenheden.",
                unitId = "Vaste technische identificatie waarmee de eenheid behouden blijft als de roepnaam verandert.",
                vehicleType = "Moet overeenkomen met een voertuigtypecode die in de vorige subsectie is geconfigureerd.",
                vehicleTypeCode = "Korte eenheidscode die wordt gebruikt in responsvereisten, bijvoorbeeld PATROL, CRIME, EMS of RESCUE.",
                vehicleTypeLabel = "Leesbare naam van deze toestelcategorie.",
            },
            dispatchFields = {
                address = "Adres",
                autoAlarm = "Automatisch alarm",
                available = "Beschikbaar voor verzending",
                averageResponseSpeedKmh = "Geschatte reactiesnelheid (km/u)",
                callsign = "Roepnaam",
                category = "Categorie",
                centerEnabled = "Schakel centrale in",
                channelId = "Kanaal-ID",
                code = "Rubriek",
                crewCapacity = "Bemanningscapaciteit",
                defaultChannel = "Standaardradiokanaal",
                emergencyAppEnabled = "Weergeven in noodapp",
                enabled = "Verzending inschakelen",
                icon = "Icoon",
                incidentAssessmentEnabled = "Noodbeoordeling inschakelen",
                jobs = "Doeltaken (door komma's gescheiden)",
                joinLocked = "Bemanningstoegang vergrendelen",
                keywordCode = "Trefwoordcode",
                label = "Etiket",
                minimumCrew = "Minimale bemanning",
                name = "Naam",
                noUnitFallback = "Waarschuw het dienstdoende personeel zonder eenheden",
                noneChannel = "Geen/groep standaard",
                note = "Opmerking",
                phone = "Telefoon",
                poiId = "Vaste POI-ID",
                radius = "Aankondigingsradius",
                readyStatusCode = "Code voor gereedstatus",
                requirements = "Vereiste eenheden (bijvoorbeeld PATROL:2,CRIME:1)",
                resourceType = "Resourcetype",
                respondingStatusCode = "Code voor uitrukstatus",
                shortLabel = "Label van radiogeheugen",
                stationId = "Standplaats-ID",
                type = "Typen",
                unitId = "Vaste eenheids-ID",
                vehicleType = "Type responseenheid",
                radioButton = "Knop",
                radioButtonAction = "Knopactie",
                radioButtonStatus = "FMS Status",
            },
            dispatchIconOptions = {
                crime = "Misdaadeenheid",
                emergency = "Noodeenheid",
                ems = "EMS-eenheid",
                fire = "Brandeenheid",
                heavy = "Zware eenheid",
                k9 = "K-9-eenheid",
                medical = "Medische eenheid",
                patrol = "Patrouille",
                rescue = "Reddingseenheid",
                service = "Service-eenheid",
                supervisor = "Toezichthouder",
                tactical = "Tactische eenheid",
            },
            dispatchNavigation = {
                active = "Verzending actief",
                description = "Configureer noodintake, radio, eenheden, responsplannen, locaties en verslaggevergegevens voor deze taak.",
                inactive = "Verzending uitgeschakeld",
                steps = {
                    accessText = "Schakel verzending in en bepaal of deze taak een verzendingscentrum kan bemannen.",
                    accessTitle = "Toegang en spoedopname",
                    fleetText = "Configureer kanalen, FMS-statuscodes, voertuigtypen en roepnamen.",
                    fleetTitle = "Radio en vloot",
                    responseText = "Eindig met trefwoorden, responsvereisten en POI's.",
                    responseTitle = "Reactieplannen",
                },
                summary = {
                    channels = "Radiokanalen",
                    plans = "Reactieplannen",
                    reporters = "Bekende melders",
                    statuses = "Beschikbare FMS",
                    units = "Virtuele eenheden",
                },
                title = "Verzending",
                warnings = {
                    channels = "Er bestaan geen expliciete radiokanalen; het terugvalkanaal voor de taakgroep zal worden gebruikt.",
                    defaultChannel = "Het geselecteerde standaardkanaal bestaat niet meer.",
                    disabled = "Verzending is uitgeschakeld voor deze taak.",
                    statuses = "Er moet ten minste één FMS-status beschikbaar zijn, zodat eenheden kunnen worden gealarmeerd.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Definieert de radiokanalen waar eenheden en bemande meldkamers zich bij kunnen aansluiten.",
                dispatchKeywords = "Definieert trefwoorden voor incidenten, vereiste voertuigtellingen, deelnemende taken en optionele automatische alarmering.",
                dispatchPois = "Slaat stations en algemene locaties op voor incidentformulieren en positiegebaseerde stationsaankondigingen.",
                dispatchReporters = "Beheert meldersnamen, terugbelnummers en meldkamernotities voor deze functie.",
                dispatchStatusCodes = "Configureert FMS-statuslabels en welke statussen gelden als beschikbaar voor nieuwe incidenten.",
                dispatchVehicleTypes = "Definieert de eenheidscategorieën die worden gebruikt door responsplannen, zoals Patrouille, Crime Unit, EMS of Rescue.",
                dispatchVehicles = "Definieert virtuele expeditievoertuigen die overal kunnen worden bemand zonder dat een voortgebracht voertuig nodig is.",
                dispatchRadioButtons = "Stelt de centraal vooraf gedefinieerde actie in voor elke fysieke functieknop.",
                dispatchRadioFmsKeys = "Geeft FMS status aan de fysieke nummertoetsen. Het toetsenbord voert alleen FMS wijzigingen uit.",
            },
            extensions = {
                caseNumbering = {
                    label = "Dossiernummers",
                    description = "Configureer automatische dossiernummers voor deze baan.",
                    fields = {
                        prefix = {
                            label = "Dossiervoorvoegsel",
                            description = "Voorvoegsel voor nieuwe dossiers, zoals LSPD of LSCSD. Maximaal 16 tekens, omgezet naar hoofdletters; leeg gebruikt CASE. Bestaande en handmatig toegewezen nummers blijven behouden.",
                        },
                    },
                },
                dispatchReporters = "Bekende melders",
                invalidSelection = "Ongeldige selectie: {value}",
                trainingSettings = {
                    description = "Configureer trainingstoegang, inschrijving, goedkeuringen en cursusplanning voor deze taak.",
                    label = "Trainingsinstellingen",
                },
                dispatchChannels = "Radiokanalen",
                dispatchKeywords = "Trefwoorden en responsplannen",
                dispatchPois = "Centrale POI's",
                dispatchSettings = {
                    description = "Configureren verzending toegang, noodinlaat, en het standaard radiokanaal.",
                    label = "Instellingen voor verzending",
                },
                dispatchStatusCodes = "Statuscodes",
                dispatchVehicleTypes = "Type verzendingsvoertuig",
                dispatchVehicles = "Verzendingsvlootgegevens",
                emptyDescription = "Gebruik de knop Toevoegen hierboven om het eerste item aan te maken.",
                emptyTitle = "Nog niets geconfigureerd",
                dispatchRadioButtons = "Radiofunctieknoppen",
                dispatchRadioFmsKeys = "FMS Sleutelopdracht",
            },
            features = {
                billing = {
                    description = "Schakel factureringsworkflows voor de politie in.",
                    label = "Facturatie",
                },
                devices = {
                    description = "Schakel inzetbare handhavingsapparatuur in.",
                    label = "CCTV en snelheidscamera's",
                },
                evidence = {
                    description = "Schakel bewijsopslag, veldbewijs en scannerworkflows in.",
                    label = "Bewijsmateriaal",
                },
                impound = {
                    description = "Schakel workflows voor de inbeslagnameplaats in.",
                    label = "Inbeslagname",
                },
                jail = {
                    description = "Schakel gevangenisstraffen en gevangenisactiviteiten in.",
                    label = "Gevangenis",
                },
                propPlacement = {
                    description = "Schakel configureerbare politievoorwerpen en voertuig-voorwerploadouts in.",
                    label = "Voorwerpplaatsing",
                },
                radial = {
                    description = "Schakel politie-radiale acties in, zoals inbeslagname en wielklem.",
                    label = "Radiale acties",
                },
                restraints = {
                    description = "Schakel handboeien, tape, beugelboeien en hoofdbags in.",
                    label = "Fixatiemiddelen",
                },
                socialWork = {
                    description = "Schakel toewijzing van sociaal werk en taakactiviteiten in.",
                    label = "Sociaal werk",
                },
                tablet = {
                    description = "Schakel politietablet-apps in die door deze resource zijn geconfigureerd.",
                    label = "Politietablet",
                },
                tracking = {
                    description = "Schakel GPS-trackers en enkelmonitors in.",
                    label = "Volgsystemen",
                },
                vehicleRadar = {
                    description = "Schakel patrouillevoertuigradar in.",
                    label = "Voertuigradar",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Om deze job in de noodoproep-app te tonen, moet Dispatch ingeschakeld zijn. Schakel Dispatch in of zet de weergave in de noodoproep-app uit bij de Dispatch-instellingen.",
                dispatchJobNotCovered = "Geen actieve meldkamer dekt de job ‘{job}’. Voeg ‘{job}’ in sky_jobs_base/config/config.lua toe aan coveredJobs in het juiste profiel onder Config.Dispatch.centers en herstart sky_jobs_base. Het terugzetten van instellingen verandert deze toewijzing niet.",
                invalidDispatchChannels = "Radiokanaal-ID's moeten uniek zijn en elk kanaal heeft een geldig label nodig.",
                invalidDispatchDefaultChannel = "Het standaardradiokanaal bestaat niet. Kies bij de Dispatch-instellingen een bestaand kanaal of ‘Geen’.",
                invalidDispatchKeywords = "Inzetvoorstellen moeten unieke codes en geldige TYPE:AANTAL-vereisten hebben.",
                invalidDispatchPois = "POI-ID's, namen en coördinaten moeten geldig en uniek zijn.",
                invalidDispatchRadioButtons = "Controleer de functieknoppen van de radio: gebruik elke ondersteunde knop maar één keer en kies een actie uit de bijbehorende lijst.",
                invalidDispatchRadioFmsKeys = "Controleer de FMS-toetsen van de radio: gebruik elke toets (0-9, * of #) maar één keer en wijs een bestaande statuscode toe of laat de toets zonder toewijzing.",
                invalidDispatchReadyStatus = "Kies bij de Dispatch-instellingen een gereedstatus die bij Statuscodes als beschikbaar is gemarkeerd.",
                invalidDispatchReporters = "De gegevens van bekende melders overschrijden het toegestane aantal of de veldlengtes.",
                invalidDispatchRespondingStatus = "Kies bij de Dispatch-instellingen een uitrukstatus die bij Statuscodes als niet beschikbaar is gemarkeerd.",
                invalidDispatchSettings = "Kies een bestaande beschikbare gereedstatus, een niet-beschikbare uitrukstatus en een geldig standaardkanaal.",
                invalidDispatchStatusCodes = "FMS-codes moeten uniek zijn en minstens één status moet beschikbaar zijn.",
                invalidDispatchVehicleTypes = "Codes voor inzettypen moeten uniek en volledig zijn.",
                invalidDispatchVehicles = "Eenheids-ID's en roepnamen moeten uniek zijn en alle type- en standplaatsverwijzingen moeten bestaan.",
            },
            settingFields = {
                gangMinimumGrade = "Minimumrang",
                gang = "Bende",
                component = "Onderdeel",
                description = "Omschrijving",
                fineAmount = "Boetebedrag",
                itemName = "Itemnaam",
                length = "Lengte",
                max = "Max.",
                maxOverKmh = "Max overschrijding",
                min = "Min",
                minOverKmh = "Min overschrijding",
                model = "Voorwerpmodel",
                propModel = "Voorwerpmodel",
                reason = "Reden",
                vehicleClass = "Klasse",
            },
            settingGroups = {
                access = {
                    label = "Toegang",
                },
                animation = {
                    label = "Animatie",
                },
                ankleMonitor = {
                    label = "Enkelmonitor",
                },
                ankleMonitorAccess = {
                    label = "Enkelmonitor toegang",
                },
                ankleMonitorPlacement = {
                    label = "Enkelmonitor bevestiging",
                },
                ankleMonitorZone = {
                    label = "Enkelmonitorzone",
                },
                ankleMonitorZoneVisual = {
                    label = "Enkelmonitorzone weergave",
                },
                assignment = {
                    label = "Toewijzing",
                },
                blip = {
                    label = "Stationsblip",
                },
                carry = {
                    label = "Dragen",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV-duurzaamheid",
                },
                cctvPlacement = {
                    label = "CCTV-plaatsing",
                },
                cctvRepair = {
                    label = "CCTV-reparatie",
                },
                cctvRepairAnimation = {
                    label = "CCTV-reparatieanimatie",
                },
                clamp = {
                    label = "Wielklem",
                },
                clampWeld = {
                    label = "Klem lassen",
                },
                cleanup = {
                    label = "Opschonen",
                },
                collection = {
                    label = "Verzameling",
                },
                controls = {
                    label = "Bedieningen",
                },
                creator = {
                    label = "Maker",
                },
                crimeSceneTape = {
                    label = "Plaats-delictlint",
                },
                crimeSceneTapeAccess = {
                    label = "Toegang tot lint",
                },
                crimeSceneTapeInventory = {
                    label = "Lintinventaris",
                },
                crimeSceneTapeLength = {
                    label = "Lintlengte",
                },
                crimeSceneTapePlacement = {
                    label = "Lint plaatsen",
                },
                database = {
                    label = "Database",
                },
                delivery = {
                    label = "Aflevering",
                },
                detection = {
                    label = "Detectie",
                },
                dispatch = {
                    label = "Verzenden",
                },
                escape = {
                    label = "Ontsnappen",
                },
                escort = {
                    label = "Escorteren",
                },
                evidenceStorage = {
                    label = "Bewijsopslag",
                },
                fastLock = {
                    label = "Automatische snelvergrendeling",
                },
                general = {
                    label = "Algemeen",
                },
                gpsTracker = {
                    label = "GPS-tracker",
                },
                gpsTrackerAccess = {
                    label = "GPS-trackertoegang",
                },
                gpsTrackerPlacement = {
                    label = "GPS-trackerplaatsing",
                },
                gpsTrackerTiming = {
                    label = "GPS-tracker timing",
                },
                handcuffs = {
                    label = "Handboeien",
                },
                handsUp = {
                    label = "Handen omhoog",
                },
                header = {
                    label = "Koptekst",
                },
                impound = {
                    label = "Inbeslagname",
                },
                imprisonment = {
                    label = "Opsluiting",
                },
                jailCanteenGeneral = {
                    label = "Gevangeniskantine",
                },
                jailCanteenPackage = {
                    label = "Kantinepakket",
                },
                jailCarry = {
                    label = "Draagtaak",
                },
                jailCarryInspection = {
                    label = "Draaginspectie",
                },
                jailCleaning = {
                    label = "Schoonmaaktaak",
                },
                jailCleaningIllegalFinds = {
                    label = "Illegale vondsten",
                },
                jailCleaningOutline = {
                    label = "Schoonmaak-omlijning",
                },
                jailDoctor = {
                    label = "Gevangenisdokter",
                },
                jailElectricalCodes = {
                    label = "Elektriciteitskast-codes",
                },
                jailElectricalGeneral = {
                    label = "Gevangenis-elektriciteitskast",
                },
                jailElectricalPenalties = {
                    label = "Elektriciteitskast-straffen",
                },
                jailElectricalRewards = {
                    label = "Elektriciteitskast-beloningen",
                },
                jailInmatesAlcoholic = {
                    label = "Alcoholistgevangene",
                },
                jailInmatesCodeList = {
                    label = "Informant-gevangene",
                },
                jailInmatesDrugDealer = {
                    label = "Drugsdealer-gevangene",
                },
                jailInmatesWireCutter = {
                    label = "Gereedschaprunner-gevangene",
                },
                jailJobs = {
                    label = "Gevangenistaken",
                },
                jailOutfitFemale = {
                    label = "Vrouwenoutfit",
                },
                jailOutfitMale = {
                    label = "Mannenoutfit",
                },
                keybinds = {
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                    label = "Toetsen",
                },
                keybindsHandcuff = {
                    label = "Boei-sneltoets",
                },
                keybindsUnhandcuff = {
                    label = "Ontboei-sneltoets",
                },
                marker = {
                    label = "Markering",
                },
                markerColor = {
                    label = "Markerkleur",
                },
                mugshotAnimation = {
                    label = "Boekingsfoto-animatie",
                },
                mugshotBoard = {
                    label = "Boekingsfoto-bord",
                },
                mugshotCameraCoords = {
                    label = "Boekingsfoto camerapositie",
                },
                mugshotCameraRotation = {
                    label = "Boekingsfoto camerarotatie",
                },
                mugshotGeneral = {
                    label = "Boekingsfoto",
                },
                mugshotMetadata = {
                    label = "Boekingsfoto-metadata",
                },
                mugshotPosition = {
                    label = "Boekingsfoto-positie",
                },
                mugshotTiming = {
                    label = "Boekingsfoto timing",
                },
                officerDown = {
                    label = "Agent neer",
                },
                outfit = {
                    label = "Kleding",
                },
                overlay = {
                    label = "Kentekenoverlay",
                },
                payment = {
                    label = "Betaling",
                },
                paymentFlow = {
                    label = "Betalingsflow",
                },
                penalties = {
                    label = "Straffen",
                },
                playerSearch = {
                    label = "Fouilleren",
                },
                playerSearchAnimation = {
                    label = "Fouilleeranimatie",
                },
                props = {
                    label = "Voorwerp-items",
                },
                reasons = {
                    label = "Redenen",
                },
                release = {
                    label = "Vrijgave",
                },
                restore = {
                    label = "Herstellen",
                },
                rules = {
                    label = "Regels",
                },
                scan = {
                    label = "Scannen",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Straf",
                },
                shotsFired = {
                    label = "Schoten gelost",
                },
                sound = {
                    label = "Geluid",
                },
                speedcam = {
                    label = "Snelheidscamera's",
                },
                speedcamBilling = {
                    label = "Snelheidscamera-facturatie",
                },
                speedcamDispatch = {
                    label = "Snelheidscamera-dispatch",
                },
                speedcamDurability = {
                    label = "Snelheidscamera-duurzaamheid",
                },
                speedcamPlacement = {
                    label = "Snelheidscamera-plaatsing",
                },
                speedcamRepair = {
                    label = "Snelheidscamera-reparatie",
                },
                speedcamRepairAnimation = {
                    label = "Snelheidscamera-reparatieanimatie",
                },
                speedcamTiming = {
                    label = "Snelheidscamera timing",
                },
                speedcamVisual = {
                    label = "Snelheidscamera weergave",
                },
                speedcams = {
                    label = "Snelheidscamera's",
                },
                storage = {
                    label = "Opslag",
                },
                subscription = {
                    label = "Abonnement",
                },
                tasks = {
                    label = "Taken",
                },
                theme = {
                    label = "Thema",
                },
                timing = {
                    label = "Tijden",
                },
                warningUi = {
                    label = "Waarschuwingsscherm",
                },
                world = {
                    label = "Wereld",
                },
                zipties = {
                    label = "Tape",
                },
                ziptiesCutter = {
                    label = "Tapeknipper",
                },
                cctvMotionDetection = {
                    label = "Bewegingsdetectie",
                },
                cctvMotionDispatch = {
                    label = "Melding bij bewegingsdetectie",
                },
                cctvMotionTiming = {
                    label = "Timing van bewegingsdetectie",
                },
                display = {
                    label = "Weergave",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Rapporten",
                },
                speedcamAdvanced = {
                    label = "Geavanceerde snelheidscamera",
                },
                tackle = {
                    label = "Tackelen",
                },
                vin = {
                    label = "VIN Controle",
                },
            },
            settingSections = {
                radarGun = "Radarpistool",
                billing = "Facturatie",
                cctv = "CCTV",
                dispatch = "Verzenden",
                equipment = "Uitrusting",
                evidence = "Bewijsmateriaal",
                impound = "Inbeslagname",
                jail = "Gevangenis",
                radar = "Voertuigradar",
                radial = "Radiale acties",
                restraints = "Fixatiemiddelen",
                socialWork = "Sociaal werk",
                speedCamera = "Snelheidscamera",
                spikeStrips = "Spijkermatten",
                stations = "Zenders",
                tablet = "Tablet-apps",
                tracking = "Volgsystemen",
                fakePlates = "Valse platen",
                general = "Algemeen",
            },
            settingSubsections = {
                app = "Snelheidscamera-app",
                apps = "Apps",
                billing = "Facturatie",
                canteen = "Gevangeniskantine",
                dispatch = "Verzenden",
                durability = "Duurzaamheid",
                electrical = "Gevangenis-elektriciteitskast",
                general = "Algemeen",
                handcuffs = "Handboeien en kabelbinders",
                inmates = "Gevangenen",
                jobs = "Gevangenistaken",
                keybinds = "Toetsen",
                motionDetection = "Bewegingsdetectie",
                mugshot = "Boekingsfoto",
                placement = "Plaatsing",
                repair = "Reparatie",
                timing = "Tijden",
                visuals = "Visuele weergave",
            },
            settings = {
                radarGunClearKey = { label = "Radarpistool: Meting wissen" },
                radarGunToggleUiKey = { label = "Radarpistool: Interface wisselen" },
                radarGunNoTargetHoldMs = { label = "Vasthoudtijd doelwit (ms)" },
                radarGunMinimumReading = { label = "Laagste weergegeven snelheid" },
                radarGunSpeedSmoothing = { label = "Snelheidsafvlakking (0–1)" },
                radarGunBeamRadius = { label = "Straalradius (m)" },
                radarGunRefreshRateMs = { label = "Meetinterval (ms)" },
                radarGunUseMph = { label = "MPH gebruiken", description = "Toon metingen in mijl per uur in plaats van kilometer per uur." },
                radarGunRange = { label = "Meetbereik", description = "Maximale afstand in meters waarop het radarpistool voertuigen detecteert." },
                radarGunRequireOnDuty = { label = "Dienst vereist", description = "Vereis dat agenten in dienst zijn voordat zij voertuigen met het radarpistool meten." },
                radarGunAllowedJobs = { label = "Toegestane jobs of groepen", description = "police omvat alle ingestelde politiebanen; directe baannamen zijn ook mogelijk. Een lege lijst heft de baanbeperking op.", itemLabel = "Baan of groep" },
                radarGunEnabled = { label = "Radarpistool", description = "Schakel het draagbare SKY SR-2-radarpistool in." },
                fakePlateVinAllowedGangs = {
                    label = "Toegestane gangs",
                    description = "Selecteer interne gang- of organisatienamen. Een overeenkomende job of gang geeft de toestemming of uitzondering. Dienstplicht geldt alleen voor jobs.",
                    itemLabel = "Bende",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Minimale gangrangen",
                    description = "Optionele minimale gangrangen. Een lege lijst staat alle rangen toe. Itemvereisten blijven gelden.",
                },

                speedCamProcessingMode = {
                    description = "Kies direct afschrijven, betalen binnen de ingestelde termijn of alleen beoordeling door een agent.",
                    label = "Verwerkingsmodus",
                    options = {
                        instant = "Direct afschrijven",
                        later = "Later betalen (standaard)",
                        review = "Alleen beoordeling door agent",
                    },
                },
                tabletRegistry = { label = "Register", description = "Aangepaste RP-registers in File Explorer inschakelen. Personen- en voertuigdossiers blijven afzonderlijk beschikbaar." },
                tabletFiles = { label = "Bestandsverkenner", description = "Bundelt politiedossiers in de bestandsverkenner. DOJ-documenten verschijnen alleen als DOJ actief is." },
                ankleMonitorAnimDurationMs = {
                    description = "Aantal milliseconden dat wordt besteed aan het bevestigen van een enkelmonitor.",
                    label = "Toepassingsduur",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenario dat wordt afgespeeld tijdens het bevestigen van een enkelmonitor.",
                    label = "Toepassingsscenario",
                },
                ankleMonitorAttachBone = {
                    description = "Ped-bot dat wordt gebruikt om het enkelmonitor-voorwerp te bevestigen.",
                    label = "Bevestigingsbot",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Verwijder het enkelmonitor-item na bevestiging.",
                    label = "Enkelmonitor verbruiken",
                },
                ankleMonitorCutItem = {
                    description = "Inventarisitem dat wordt gebruikt om enkelmonitors te verwijderen.",
                    label = "Doorknip-item",
                },
                ankleMonitorEnabled = {
                    description = "Schakel het bevestigen van enkelmonitors in.",
                    label = "Enkelmonitor",
                },
                ankleMonitorItem = {
                    description = "Inventarisitem dat wordt gebruikt om enkelmonitors te bevestigen.",
                    label = "Enkelmonitor-item",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Aantal milliseconden tussen kaartupdates van de enkelmonitor.",
                    label = "Kaartupdate-interval",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Bewaart enkelbanden in de database wanneer gevolgde spelers de verbinding verbreken, zodat ze na opnieuw verbinden en serverherstarts worden hersteld.",
                    label = "Behouden na verbreken verbinding",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maximale afstand om een enkelmonitor te bevestigen.",
                    label = "Plaatsingsafstand",
                },
                ankleMonitorPropModel = {
                    description = "Voorwerpmodel dat wordt gebruikt voor de visuele weergave van de enkelmonitor.",
                    label = "Voorwerpmodel",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Vereis diensttoestand voordat enkelmonitors kunnen worden gebruikt.",
                    label = "Enkelmonitor vereist dienst",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Vereis dat de speler tot de politiegroep behoort voordat enkelmonitors kunnen worden gebruikt.",
                    label = "Enkelmonitor vereist politiejob",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Geef het enkelmonitor-item terug wanneer het wordt verwijderd.",
                    label = "Enkelmonitor retourneren bij verwijderen",
                },
                ankleMonitorWarningSeconds = {
                    description = "Waarschuwingstijd voordat een enkelmonitorzone-overtreding wordt gedispatcht.",
                    label = "Waarschuwingstijd zone (seconden)",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Aantal milliseconden tussen waarschuwingspieptonen van de enkelmonitorzone.",
                    label = "Zone-piepinterval",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Geluidsnaam die wordt gebruikt voor waarschuwingen van de enkelmonitorzone.",
                    label = "Pieptoon-geluid",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Geluidsset die wordt gebruikt voor waarschuwingen van de enkelmonitorzone.",
                    label = "Pieptoon-geluidsset",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Alfawaarde die wordt gebruikt voor blips van de enkelmonitorzone.",
                    label = "Blip-doorzichtigheid",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Blipkleur die wordt gebruikt wanneer een doelwit zich binnen het toegestane gebied bevindt.",
                    label = "Blipkleur toegestaan",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Blipkleur die wordt gebruikt wanneer een doelwit het toegestane gebied verlaat.",
                    label = "Blipkleur uitgesloten",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Aantal milliseconden tussen controles van de enkelmonitorzone.",
                    label = "Zonecontrole-interval",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Aantal seconden voordat een volgende enkelmonitorzone-dispatch kan worden verzonden.",
                    label = "Zone-dispatch-afkoeltijd",
                },
                ankleMonitorZoneEnabled = {
                    description = "Schakel controles voor enkelmonitorzones in.",
                    label = "Enkelmonitorzones",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Blip-sprite die wordt gebruikt voor markers van de enkelmonitorzone.",
                    label = "Zonelabel-sprite",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Radius die wordt gebruikt voor omlijningen van de enkelmonitorzone.",
                    label = "Omlijningsradius",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Stapgrootte die wordt gebruikt voor omlijningen van de enkelmonitorzone.",
                    label = "Omlijningsstap",
                },
                billingAccount = {
                    description = "Reserverekening die wordt gebruikt wanneer een job geen geconfigureerde bedrijfsrekening heeft.",
                    label = "Reserve bedrijfsrekening",
                },
                billingCloseOnSuccess = {
                    description = "Sluit de facturatie-interface nadat een factuur is uitgeschreven.",
                    label = "Sluiten na succes",
                },
                billingCurrency = {
                    description = "Valutasleutel die voor facturering wordt gebruikt. Laat leeg om de standaardvaluta te gebruiken.",
                    label = "Valuta",
                },
                billingCustomReasons = {
                    description = "Sta aangepaste factureringsredenen toe in plaats van alleen voorinstellingen.",
                    label = "Aangepaste redenen",
                },
                billingDepositToSociety = {
                    description = "Stort factureringsinkomsten in de bedrijfsrekening van de job.",
                    label = "Storten in bedrijfskas",
                },
                billingMaxReasonLength = {
                    description = "Maximumaantal tekens voor aangepaste factureringsredenen.",
                    label = "Lengte van reden",
                },
                billingMode = {
                    description = "Kies of politiefacturen direct worden geïnd, bevestiging van de burger vereisen, of het frameworkfactureringssysteem gebruiken.",
                    label = "Factureringsmodus",
                    options = {
                        consent = "Betalen of weigeren",
                        framework = "Frameworkfactuur",
                        instant = "Direct innen",
                    },
                },
                billingRange = {
                    description = "Maximale doelafstand voor het uitschrijven van politiefacturen.",
                    label = "Factureerafstand",
                },
                billingReasonPresets = {
                    description = "Voorgedefinieerde factureringsredenen die in de facturatie-interface worden getoond.",
                    itemLabel = "Reden",
                    label = "Voorinstellingen redenen",
                },
                billingRefreshSeconds = {
                    description = "Doel-vernieuwingsinterval terwijl de facturatie-interface geopend is.",
                    label = "Vernieuwingsinterval (seconden)",
                },
                billingShowRecipientName = {
                    description = "Toon de naam van de burger op boetevoorbeelden en betalingsbewijzen.",
                    label = "Naam ontvanger tonen",
                },
                carryAllowCarrierInVehicle = {
                    description = "Sta toe dat de drager een voertuig instapt en bestuurt zonder de speler neer te leggen.",
                    label = "Drager in voertuig toestaan",
                },
                carryAllowConscious = {
                    description = "Sta toe dat doelwitten die bij bewustzijn zijn worden gedragen.",
                    label = "Bij bewustzijn dragen toestaan",
                },
                carryAllowSprint = {
                    description = "Sta toe dat er wordt gesprint terwijl een andere speler wordt gedragen.",
                    label = "Sprinten tijdens dragen toestaan",
                },
                carryEnabled = {
                    description = "Schakel het dragen van spelers in.",
                    label = "Dragen",
                },
                carryMaxDistance = {
                    description = "Maximale afstand om te beginnen met het dragen van een speler.",
                    label = "Draagafstand",
                },
                carryRequireOnDuty = {
                    description = "Vereis diensttoestand voordat het dragen kan beginnen.",
                    label = "Dragen vereist dienst",
                },
                cctvDamageCooldownMs = {
                    description = "Aantal milliseconden voordat er opnieuw schade aan de CCTV kan worden toegebracht.",
                    label = "Schade-afkoeltijd",
                },
                cctvDamagePerHit = {
                    description = "Duurzaamheidsschade die per treffer wordt toegebracht aan CCTV-camera's.",
                    label = "Schade per treffer",
                },
                cctvDefaultName = {
                    description = "Standaard weergavenaam voor geplaatste CCTV-camera's.",
                    label = "Standaardnaam CCTV",
                },
                cctvDefaultPitch = {
                    description = "Standaard camerakanteling voor het plaatsen van CCTV.",
                    label = "Standaard kanteling",
                },
                cctvDisassembleDistance = {
                    description = "Afstand die wordt gebruikt om CCTV-camera's te demonteren.",
                    label = "Demontageafstand",
                },
                cctvEnabled = {
                    description = "Schakel plaatsing en streaming van CCTV-camera's in.",
                    label = "CCTV-camera's",
                },
                cctvHealthDisplayDistance = {
                    description = "Afstand waarop de conditie van de CCTV wordt getoond.",
                    label = "Weergaveafstand conditie",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Aantal milliseconden dat de conditie van de CCTV zichtbaar blijft.",
                    label = "Weergaveduur conditie",
                },
                cctvHealthTextOffset = {
                    description = "Verticale verschuiving die wordt gebruikt voor de conditietekst van de CCTV.",
                    label = "Tekstverschuiving conditie",
                },
                cctvHeightStep = {
                    description = "Hoogtestap die wordt gebruikt bij het positioneren van CCTV-camera's.",
                    label = "Hoogtestap",
                },
                cctvItem = {
                    description = "Inventarisitem dat wordt gebruikt om CCTV-camera's te plaatsen.",
                    label = "CCTV-item",
                },
                cctvMaintenanceThreshold = {
                    description = "Duurzaamheidsdrempel waarbij onderhoud aan de CCTV wordt aanbevolen.",
                    label = "Onderhoudsdrempel",
                },
                cctvMaxDurability = {
                    description = "Maximale duurzaamheid van CCTV-camera's.",
                    label = "CCTV-duurzaamheid",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Seconden voordat een camera een nieuwe bewegingsdispatch kan maken.",
                    label = "Dispatchwachttijd",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Milliseconden tussen bewegingsscans aan de clientzijde.",
                    label = "Scaninterval",
                },
                cctvMotionClientCooldownMs = {
                    description = "Milliseconden voordat één client dezelfde camera opnieuw kan melden.",
                    label = "Clientmeldingswachttijd",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Schakel bewegingsmeldingen automatisch in voor nieuw geplaatste CCTV-camera's.",
                    label = "Nieuwe camera's standaard inschakelen",
                },
                cctvMotionDetectionEnabled = {
                    description = "Schakel dispatchmeldingen voor bewegingsdetectie per CCTV-camera in.",
                    label = "Bewegingsmeldingen",
                },
                cctvMotionDetectionRadius = {
                    description = "Maximale afstand voor bewegingsdetectie in meters.",
                    label = "Detectieradius",
                },
                cctvMotionFieldOfView = {
                    description = "Hoek van de bewegingsdetectiekegel in graden.",
                    label = "Gezichtsveld",
                },
                cctvMotionJobs = {
                    description = "Jobnamen of jobgroepen die CCTV-bewegingsdispatches ontvangen.",
                    itemLabel = "Job of groep",
                    label = "Dispatchjobs",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimale snelheid van een entiteit in meter per seconde om als beweging te tellen.",
                    label = "Minimale bewegingssnelheid",
                },
                cctvMoveStep = {
                    description = "Verplaatsingsstap die wordt gebruikt bij het positioneren van CCTV-camera's.",
                    label = "Verplaatsingsstap",
                },
                cctvPropModel = {
                    description = "Voorwerpmodel dat wordt gebruikt voor geplaatste CCTV-camera's.",
                    label = "CCTV-voorwerpmodel",
                },
                cctvRepairAnimDict = {
                    description = "Animatiewoordenboek dat wordt gebruikt tijdens het repareren van CCTV-camera's.",
                    label = "Reparatie-animatiewoordenboek",
                },
                cctvRepairAnimFlag = {
                    description = "Animatievlag die wordt gebruikt tijdens het repareren van CCTV-camera's.",
                    label = "Reparatie-animatievlag",
                },
                cctvRepairAnimName = {
                    description = "Animatienaam die wordt gebruikt tijdens het repareren van CCTV-camera's.",
                    label = "Reparatie-animatienaam",
                },
                cctvRepairCancelDelayMs = {
                    description = "Aantal milliseconden voordat de CCTV-reparatie kan worden geannuleerd.",
                    label = "Annuleervertraging reparatie",
                },
                cctvRepairDistance = {
                    description = "Afstand die wordt gebruikt om CCTV-camera's te repareren.",
                    label = "Reparatieafstand",
                },
                cctvRepairItem = {
                    description = "Inventarisitem dat wordt gebruikt om CCTV-camera's te repareren.",
                    label = "Reparatie-item",
                },
                cctvRepairPerTick = {
                    description = "Duurzaamheid die per reparatietik van de CCTV wordt hersteld.",
                    label = "Herstel per tik",
                },
                cctvRepairTickMs = {
                    description = "Aantal milliseconden tussen reparatietikken van de CCTV.",
                    label = "Reparatietik",
                },
                cctvRotateStep = {
                    description = "Rotatiestap die wordt gebruikt bij het positioneren van CCTV-camera's.",
                    label = "Rotatiestap",
                },
                cctvStreamDistance = {
                    description = "Afstand die wordt gebruikt om CCTV-camera's te laden.",
                    label = "Laadafstand",
                },
                cctvViewOffset = {
                    description = "Weergaveverschuiving die wordt gebruikt voor live CCTV-camerarendering.",
                    label = "Weergaveverschuiving",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Creëert langs het lint een blokkerende botsingsbarrière, zodat spelers er niet doorheen kunnen lopen.",
                    label = "Blokkerende lintcollisie",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Verwijder na een geslaagde plaatsing één lintitem uit de inventaris.",
                    label = "Lintitem verbruiken",
                },
                crimeSceneTapeDynamic = {
                    description = "Laat het lint reageren op fysica en zwaartekracht in plaats van het vast te zetten.",
                    label = "Dynamische fysica",
                },
                crimeSceneTapeEnabled = {
                    description = "Sta toe dat plaats-delictlint met een inventarisitem wordt geplaatst.",
                    label = "Plaats-delictlint",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Alleen toegestane banen mogen het lint verwijderen en moeten, indien vereist, in dienst zijn.",
                    label = "Verwijderen beperken",
                },
                crimeSceneTapeItem = {
                    description = "Naam van het inventarisitem waarmee de plaatsing van plaats-delictlint wordt gestart.",
                    label = "Lintitem",
                },
                crimeSceneTapeJobs = {
                    description = "Namen van banen die het plaats-delictlint mogen gebruiken.",
                    itemLabel = "Baan",
                    label = "Toegestane banen",
                },
                crimeSceneTapeLabel = {
                    description = "Weergavenaam van het plaats-delictlint tijdens het plaatsen.",
                    label = "Lintnaam",
                },
                crimeSceneTapeLengthStep = {
                    description = "Stap in meters waarop de geselecteerde lintlengte wordt afgerond.",
                    label = "Lengtestap",
                },
                crimeSceneTapeMaxLength = {
                    description = "Langste toegestane afstand tussen de twee lintpalen, in meters.",
                    label = "Maximale lintlengte",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Maximale afstand van een van beide eindpunten tot de agent die het lint plaatst.",
                    label = "Maximale plaatsingsafstand",
                },
                crimeSceneTapeMinLength = {
                    description = "Kortste toegestane afstand tussen de twee lintpalen, in meters.",
                    label = "Minimale lintlengte",
                },
                crimeSceneTapeModel = {
                    description = "Naam van het voorwerpmodel voor het geplaatste plaats-delictlint.",
                    label = "Lintmodel",
                },
                crimeSceneTapePostModel = {
                    description = "Voorwerpmodel dat voor beide lintpalen wordt gebruikt.",
                    label = "Paalmodel",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Maximale afstand waarop het geplaatste plaats-delictlint kan worden verwijderd.",
                    label = "Verwijderafstand",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Alleen dienstdoende leden van toegestane banen mogen het lint plaatsen.",
                    label = "Dienst vereist",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Geef het verbruikte item terug wanneer het geplaatste lint wordt verwijderd.",
                    label = "Item teruggeven bij verwijderen",
                },
                crimeSceneTapeSag = {
                    description = "Maximale neerwaartse doorhang van het lint tussen de palen, in meters.",
                    label = "Doorhang van het lint",
                },
                crimeSceneTapeSections = {
                    description = "Natieve modellen van lintsegmenten waarmee de geselecteerde lengte wordt samengesteld.",
                    itemLabel = "Lintsegment",
                    label = "Lintsegmenten",
                },
                crimeSceneTapeShowPosts = {
                    description = "Plaatst zichtbare steunpalen aan beide uiteinden van het misdaadlint met variabele lengte.",
                    label = "Lintpalen tonen",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Afstand waarbinnen het geplaatste plaats-delictlint wordt geladen.",
                    label = "Laadafstand",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Hoogte van het lint boven de geselecteerde grondpunten.",
                    label = "Linthoogte",
                },
                crimeSceneTapeVariableLength = {
                    description = "Laat agenten een begin- en eindpunt instellen om het plaats-delictlint met een instelbare lengte te plaatsen.",
                    label = "Variabele lintlengte",
                },
                crimeSceneTapeZOffset = {
                    description = "Verticale verschuiving die bij het plaatsen van het lintmodel wordt toegepast.",
                    label = "Hoogteverschuiving",
                },
                cuffsAnimDict = {
                    description = "Animatiewoordenboek dat wordt gebruikt voor gefixeerde spelers.",
                    label = "Animatiewoordenboek",
                },
                cuffsAnimFlag = {
                    description = "Animatievlag die wordt gebruikt voor gefixeerde spelers.",
                    label = "Animatievlag",
                },
                cuffsAnimName = {
                    description = "Animatienaam die wordt gebruikt voor gefixeerde spelers.",
                    label = "Animatienaam",
                },
                cuffsConsumeItem = {
                    description = "Verwijder het handboei-item wanneer handboeien worden aangebracht.",
                    label = "Handboeien verbruiken",
                },
                cuffsEnabled = {
                    description = "Schakel handboei-acties in.",
                    label = "Handboeien",
                },
                cuffsEscapeEnabled = {
                    description = "Schakel de ontsnappings-minigame voor handboeien in.",
                    label = "Ontsnappen uit boeien",
                },
                cuffsEscapeKeyPool = {
                    description = "Toetsen die kunnen verschijnen in de ontsnappings-minigame voor handboeien.",
                    itemLabel = "Toets",
                    label = "Ontsnappingstoetsen",
                },
                cuffsEscapeRounds = {
                    description = "Aantal rondes dat vereist is in de ontsnappings-minigame voor handboeien.",
                    label = "Ontsnappingsrondes",
                },
                cuffsEscapeWindowMs = {
                    description = "Aantal milliseconden dat is toegestaan per invoervenster van de ontsnappingspoging.",
                    label = "Ontsnappingsvenster",
                },
                cuffsHandsUpEnabled = {
                    description = "Schakel de 'handen omhoog'-status in die door boeien en tape wordt gebruikt.",
                    label = "Handen omhoog",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Aantal seconden dat de handen-omhoog-toets ingedrukt moet blijven voordat activering plaatsvindt.",
                    label = "Ingedrukt houden (seconden)",
                },
                cuffsHandsUpKey = {
                    description = "Toetsenbordtoets die wordt gebruikt om de handen omhoog te steken.",
                    label = "Handen-omhoog-toets",
                },
                cuffsItem = {
                    description = "Inventarisitem dat wordt gebruikt voor handboei-acties.",
                    label = "Boei-item",
                },
                cuffsMaxDistance = {
                    description = "Maximale doelafstand voor boei-acties.",
                    label = "Boei-afstand",
                },
                cuffsRequireItem = {
                    description = "Vereis het geconfigureerde handboei-item.",
                    label = "Boeien vereist item",
                },
                cuffsRequireOnDuty = {
                    description = "Vereis diensttoestand voordat iemand geboeid kan worden.",
                    label = "Boeien vereist dienst",
                },
                cuffsReturnOnRemove = {
                    description = "Geef het handboei-item terug wanneer handboeien worden verwijderd.",
                    label = "Handboeien retourneren",
                },
                dispatchOfficerDownEnabled = {
                    description = "Verstuur een dispatchmelding wanneer een in dienst zijnde agent neergaat.",
                    label = "Waarschuwingen agent neer",
                },
                dispatchOfficerDownJobs = {
                    description = "Jobs die dispatchmeldingen moeten ontvangen wanneer een agent neergaat.",
                    itemLabel = "Baan",
                    label = "Jobs agent neer",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Meld alleen aan spelers die momenteel in dienst zijn.",
                    label = "Agent neer vereist dienst",
                },
                dispatchShotsFiredChance = {
                    description = "Kans van 0.0 tot 1.0 dat een gedetecteerd schot een melding aanmaakt.",
                    label = "Meldingskans",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Aantal seconden voordat dezelfde speler opnieuw een schoten-gelost-melding kan activeren.",
                    label = "Afkoeltijd schoten gelost",
                },
                dispatchShotsFiredEnabled = {
                    description = "Schakel dispatchmeldingen voor schoten gelost in.",
                    label = "Waarschuwingen schoten gelost",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Wapens die geen schoten-gelost-meldingen mogen activeren.",
                    itemLabel = "Wapen",
                    label = "Genegeerde wapens",
                },
                dispatchShotsFiredJobs = {
                    description = "Jobs die dispatchmeldingen voor schoten gelost moeten ontvangen.",
                    itemLabel = "Baan",
                    label = "Jobs schoten gelost",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Meld alleen aan spelers die momenteel in dienst zijn.",
                    label = "Schoten gelost vereist dienst",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Maak dispatchmeldingen aan wanneer schoten gelost worden gedetecteerd.",
                    label = "Dispatch schoten gelost versturen",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Kans van 0.0 tot 1.0 dat een gedetecteerd gedempt schot een melding aanmaakt.",
                    label = "Meldingskans voor gedempte schoten",
                },
                escortEnabled = {
                    description = "Schakel het escorteren van spelers in.",
                    label = "Escorteren",
                },
                escortMaxDistance = {
                    description = "Maximale afstand om te beginnen met het escorteren van een speler.",
                    label = "Escorteerafstand",
                },
                escortRequireOnDuty = {
                    description = "Vereis diensttoestand voordat spelers geëscorteerd kunnen worden.",
                    label = "Escorteren vereist dienst",
                },
                escortVehicleDistance = {
                    description = "Maximale afstand om een geëscorteerde speler in een voertuig te plaatsen.",
                    label = "Escorteer-voertuigafstand",
                },
                evidenceBloodDamageThreshold = {
                    description = "Minimale schadedrempel voordat bloedbewijs wordt aangemaakt.",
                    label = "Bloedschadedrempel",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Aantal milliseconden voordat er weer een huls kan worden aangemaakt.",
                    label = "Hulsafkoeltijd",
                },
                evidenceCasingMergeRadius = {
                    description = "Radius die wordt gebruikt om nabijgelegen hulzen samen te voegen.",
                    label = "Huls-samenvoegradius",
                },
                evidenceCleanupIntervalMs = {
                    description = "Aantal milliseconden tussen opschoonrondes van bewijs.",
                    label = "Opschoon-interval",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Aantal seconden voordat veldbewijs automatisch vervalt.",
                    label = "Opschoon-levensduur",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Reiniger voor iedereen",
                    description = "Laat iedereen sporen met waterstofperoxide verwijderen. Schakel uit om de job- en ganglijsten te gebruiken.",
                },
                evidenceCleanerJobs = {
                    label = "Jobs voor de reiniger",
                    description = "Toegestane interne namen zonder openbare toegang. Een overeenkomende job of gang geeft toegang; lege lijsten weigeren toegang.",
                    itemLabel = "Baan",
                },
                evidenceCleanerGangs = {
                    label = "Gangs voor de reiniger",
                    description = "Toegestane interne namen zonder openbare toegang. Een overeenkomende job of gang geeft toegang; lege lijsten weigeren toegang.",
                    itemLabel = "Bende",
                },
                evidenceCollectDistance = {
                    description = "Afstand die wordt gebruikt om veldbewijs te verzamelen.",
                    label = "Verzamelafstand",
                },
                evidenceDiscoverDistance = {
                    description = "Afstand die wordt gebruikt om nabijgelegen bewijsmarkers te ontdekken.",
                    label = "Ontdekafstand",
                },
                evidenceFieldEnabled = {
                    description = "Schakel het aanmaken en verzamelen van bewijs in het veld in.",
                    label = "Veldbewijs",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Wapen dat wordt gebruikt om bewijs in het veld te inspecteren en zichtbaar te maken.",
                    label = "Zaklampwapen",
                },
                evidenceGloveFreeHands = {
                    description = "Hand-componenten-ID's die worden beschouwd als handen zonder handschoenen.",
                    label = "Handen zonder handschoenen",
                },
                evidenceMarkerColor = {
                    description = "RGBA-kleur die wordt gebruikt voor markers van veldbewijs.",
                    label = "Markerkleur",
                },
                evidenceMarkerDrawDistance = {
                    description = "Weergaveafstand die wordt gebruikt voor markers van veldbewijs.",
                    label = "Weergaveafstand",
                },
                evidenceMarkerOffset = {
                    description = "Verticale markerverschuiving die wordt gebruikt voor veldbewijs.",
                    label = "Verschuiving",
                },
                evidenceMarkerScaleX = {
                    description = "X-schaal van de marker die wordt gebruikt voor veldbewijs.",
                    label = "Schaal X",
                },
                evidenceMarkerScaleY = {
                    description = "Y-schaal van de marker die wordt gebruikt voor veldbewijs.",
                    label = "Schaal Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Z-schaal van de marker die wordt gebruikt voor veldbewijs.",
                    label = "Schaal Z",
                },
                evidenceMarkerType = {
                    description = "Markertype dat wordt gebruikt voor veldbewijs.",
                    label = "Markertype",
                },
                evidenceMaxCreateDistance = {
                    description = "Maximale afstand voor het aanmaken van bewijsrecords.",
                    label = "Aanmaakafstand",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Aantal milliseconden dat is toegestaan voor toestemming voor een speekselmonster.",
                    label = "Time-out toestemming speekselmonster",
                },
                evidenceScannerDistance = {
                    description = "Afstand die wordt gebruikt voor interacties met de bewijsscanner.",
                    label = "Scannerafstand",
                },
                evidenceScannerDurationMs = {
                    description = "Duur van de vingerafdruk-/scanneractie in milliseconden.",
                    label = "Scannerduur",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maximumaantal opslagvakken voor bewijsopslag.",
                    label = "Opslagvakken",
                },
                gpsTrackerBeepDistance = {
                    description = "Afstand waarop de piepfeedback van de GPS-tracker relevant wordt.",
                    label = "Piepafstand",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Aantal milliseconden tussen piepjes wanneer ver van een tracker.",
                    label = "Piepinterval veraf",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Aantal milliseconden tussen piepjes wanneer dichtbij een tracker.",
                    label = "Piepinterval dichtbij",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Verwijder het tracker-item na plaatsing.",
                    label = "GPS-tracker verbruiken",
                },
                gpsTrackerEnabled = {
                    description = "Schakel plaatsing en scannen van voertuig-GPS-trackers in.",
                    label = "GPS-tracker",
                },
                gpsTrackerItem = {
                    description = "Inventarisitem dat wordt gebruikt om GPS-trackers te plaatsen.",
                    label = "Tracker-item",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Aantal milliseconden tussen kaartupdates van de tracker.",
                    label = "Kaartupdate-interval",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maximale afstand om een GPS-tracker op een voertuig te plaatsen.",
                    label = "Plaatsingsafstand",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maximale afstand om een geplaatste GPS-tracker te verwijderen.",
                    label = "Verwijderafstand",
                },
                gpsTrackerRemoveKey = {
                    description = "Controlecode die wordt gebruikt om een geplaatste GPS-tracker te verwijderen.",
                    label = "Verwijdertoets",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Vereis diensttoestand voordat GPS-trackers kunnen worden gebruikt.",
                    label = "GPS vereist dienst",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Vereis dat de speler tot de politiegroep behoort voordat GPS-trackers kunnen worden gebruikt.",
                    label = "GPS vereist politiejob",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Geef het tracker-item terug wanneer het wordt verwijderd.",
                    label = "Tracker retourneren bij verwijderen",
                },
                gpsTrackerScanDistance = {
                    description = "Maximale afstand om te scannen op trackers.",
                    label = "GPS-scanafstand",
                },
                gpsTrackerScanDurationMs = {
                    description = "Aantal milliseconden dat wordt besteed aan het scannen naar een GPS-tracker.",
                    label = "Scanduur",
                },
                gpsTrackerScannerWeapon = {
                    description = "Wapen of gereedschap dat wordt gebruikt om te scannen op GPS-trackers.",
                    label = "Scannerwapen",
                },
                impoundAccount = {
                    description = "Rekening die wordt gebruikt om inbeslagname-vrijgaves in rekening te brengen.",
                    label = "Betaalrekening",
                },
                impoundCreatorVehicleModel = {
                    description = "Voertuigmodel dat wordt getoond in de voorvertoning van de inbeslagname-maker.",
                    label = "Voertuigmodel maker",
                },
                impoundCustomGarageEnabled = {
                    description = "Gebruik een aangepaste inbeslagname-interface van de garage indien beschikbaar.",
                    label = "Aangepaste garage-inbeslagname",
                },
                impoundDefaultPrice = {
                    description = "Standaardprijs voor het vrijgeven van in beslag genomen voertuigen.",
                    label = "Standaardprijs",
                },
                impoundDeliveryDistance = {
                    description = "Afstand die wordt gebruikt voor afleverinteracties bij inbeslagname.",
                    label = "Afleverafstand",
                },
                impoundDeliveryMarker = {
                    description = "Markerconfiguratie die wordt gebruikt voor afleveringen bij inbeslagname.",
                    label = "Aflevermarker",
                },
                impoundEnabled = {
                    description = "Schakel inbeslagnameworkflows in.",
                    label = "Inbeslagname",
                },
                impoundMarker = {
                    description = "Markerconfiguratie die wordt gebruikt voor inbeslagname-interacties.",
                    label = "Inbeslagname-marker",
                },
                impoundRadialEnabled = {
                    description = "Schakel radiale inbeslagnameacties in.",
                    label = "Inbeslagname-actie",
                },
                impoundRadialRequireOnDuty = {
                    description = "Vereis diensttoestand voordat de radiale inbeslagname-actie kan worden gebruikt.",
                    label = "Inbeslagname vereist dienst",
                },
                impoundRadialVehicleDistance = {
                    description = "Maximale afstand tot het doelvoertuig voor radiale inbeslagnameacties.",
                    label = "Inbeslagname voertuigafstand",
                },
                impoundReleaseDistance = {
                    description = "Afstand die wordt gebruikt voor interacties bij het vrijgeven van inbeslagname.",
                    label = "Vrijgave-afstand",
                },
                impoundReleaseKey = {
                    description = "Controlecode die wordt gebruikt om in beslag genomen voertuigen vrij te geven.",
                    label = "Vrijgave-toets",
                },
                impoundRequireDelivery = {
                    description = "Vereis aflevering bij een geconfigureerde inbeslagnameplaats.",
                    label = "Aflevering vereisen",
                },
                impoundStorageBasePrice = {
                    description = "Basisvrijgaveprijs voor opgeslagen in beslag genomen voertuigen.",
                    label = "Basisprijs opslag",
                },
                impoundStorageDailyFee = {
                    description = "Extra opslagkosten voor inbeslagname per geconfigureerde dag.",
                    label = "Dagelijkse opslagkosten",
                },
                impoundStorageDaySeconds = {
                    description = "Aantal seconden dat telt als één factureringsdag voor opslag.",
                    label = "Seconden per opslagdag",
                },
                impoundStorageEnabled = {
                    description = "Schakel betaalde afhandeling van inbeslagnameopslag in.",
                    label = "Inbeslagnameopslag",
                },
                jailAssignRange = {
                    description = "Maximale afstand om een doelwit naar de gevangenis te sturen.",
                    label = "Toewijzingsafstand",
                },
                jailCanteenCooldownMinutes = {
                    description = "Aantal minuten dat een gevangene moet wachten voordat een volgend kantinepakket kan worden opgehaald.",
                    label = "Afkoeltijd (minuten)",
                },
                jailCanteenPackage = {
                    description = "Items die worden verstrekt door het kantinepakket van de gevangenis.",
                    label = "Kantinepakket",
                },
                jailCellStreamDistance = {
                    description = "Afstand die wordt gebruikt voor het laden van voorwerpen van de isoleercel.",
                    label = "Celweergaveafstand",
                },
                jailClearInventory = {
                    description = "Wis de inventaris van de speler wanneer deze naar de gevangenis wordt gestuurd.",
                    label = "Inventaris wissen",
                },
                jailDefaultMonths = {
                    description = "Standaard gevangenisduur bij het openen van de toewijzingsinterface.",
                    label = "Standaard aantal maanden",
                },
                jailDispatchJobs = {
                    description = "Jobs die gevangenisdispatches moeten ontvangen.",
                    itemLabel = "Baan",
                    label = "Dispatch-jobs",
                },
                jailDoctorHealEvent = {
                    description = "Server- of clientevent dat wordt geactiveerd wanneer de gevangenisdokter een gevangene geneest.",
                    label = "Genezingsevent",
                },
                jailElectricalCodeListItem = {
                    description = "Inventarisitem dat vereist is om gegenereerde elektriciteitscodes te onthullen.",
                    label = "Codelijst-item",
                },
                jailElectricalCodeMax = {
                    description = "Hoogste willekeurige codewaarde voor de elektriciteitskast.",
                    label = "Maximumcode",
                },
                jailElectricalCodeMin = {
                    description = "Laagste willekeurige codewaarde voor de elektriciteitskast.",
                    label = "Minimumcode",
                },
                jailElectricalCodesCount = {
                    description = "Aantal kandidaatcodes dat wordt gegenereerd voor de elektriciteitskast.",
                    label = "Aantal codes",
                },
                jailElectricalEnabled = {
                    description = "Schakel de elektriciteitskast-ontsnappingsminigame in de gevangenis in.",
                    label = "Elektriciteitskast",
                },
                jailElectricalPinLength = {
                    description = "Aantal cijfers dat wordt gebruikt voor PIN-codes van de elektriciteitskast.",
                    label = "PIN-lengte",
                },
                jailElectricalPropModel = {
                    description = "Wereldvoorwerpmodel dat wordt gebruikt voor de elektriciteitskast van de gevangenis.",
                    label = "Voorwerpmodel",
                },
                jailElectricalShockDamage = {
                    description = "Schade die wordt toegebracht wanneer een gevangene de elektrische sequentie verkeerd uitvoert.",
                    label = "Schokschade",
                },
                jailElectricalShockRagdollMs = {
                    description = "Aantal milliseconden ragdoll na een elektrische schok.",
                    label = "Ragdoll na schok",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Aantal strafminuten dat wordt afgetrokken na een geslaagde ontsnappingspoging via de elektriciteitskast.",
                    label = "Strafvermindering bij succes (minuten)",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Hoeveelheid die vereist is voor de ruilhandel met de alcoholistgevangene.",
                    label = "Vereiste hoeveelheid",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Item dat vereist is voor de ruilhandel met de alcoholistgevangene.",
                    label = "Vereist item",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Beloningshoeveelheid voor de ruilhandel met de alcoholistgevangene.",
                    label = "Beloningshoeveelheid",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Beloningsitem voor de ruilhandel met de alcoholistgevangene.",
                    label = "Beloningsitem",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Beloningslabel dat wordt getoond voor de ruilhandel met de alcoholistgevangene.",
                    label = "Beloningslabel",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Hoeveelheid die vereist is voor de ruilhandel met de informant-gevangene.",
                    label = "Vereiste hoeveelheid",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Item dat vereist is voor de ruilhandel met de informant-gevangene.",
                    label = "Vereist item",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Beloningshoeveelheid voor de ruilhandel met de informant-gevangene.",
                    label = "Beloningshoeveelheid",
                },
                jailInmateCodeListRewardItem = {
                    description = "Beloningsitem voor de ruilhandel met de informant-gevangene.",
                    label = "Beloningsitem",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Beloningslabel dat wordt getoond voor de ruilhandel met de informant-gevangene.",
                    label = "Beloningslabel",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Geaccepteerde items voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Geaccepteerde items",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Hoeveelheid die vereist is voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Vereiste hoeveelheid",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Beloningshoeveelheid voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Beloningshoeveelheid",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Beloningsitem voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Beloningsitem",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Beloningslabel dat wordt getoond voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Beloningslabel",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Sta toe dat smokkelwaar die tijdens het schoonmaken in de gevangenis is gevonden meetelt voor de ruilhandel met de drugsdealer-gevangene.",
                    label = "Schoonmaaksmokkelwaar gebruiken",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Hoeveelheid die vereist is voor de ruilhandel met de gereedschaprunner-gevangene.",
                    label = "Vereiste hoeveelheid",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Item dat vereist is voor de ruilhandel met de gereedschaprunner-gevangene.",
                    label = "Vereist item",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Beloningshoeveelheid voor de ruilhandel met de gereedschaprunner-gevangene.",
                    label = "Beloningshoeveelheid",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Beloningsitem voor de ruilhandel met de gereedschaprunner-gevangene.",
                    label = "Beloningsitem",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Beloningslabel dat wordt getoond voor de ruilhandel met de gereedschaprunner-gevangene.",
                    label = "Beloningslabel",
                },
                jailJobsCarryBoxModel = {
                    description = "Voorwerpmodel dat wordt gebruikt voor de doos van de draagtaak in de gevangenis.",
                    label = "Doosmodel",
                },
                jailJobsCarryDropoffKey = {
                    description = "Controlecode die wordt gebruikt om dozen van de draagtaak af te leveren.",
                    label = "Aflever-toets draagtaak",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Afleverradius voor de draagtaak in de gevangenis.",
                    label = "Afleverradius",
                },
                jailJobsCarryInspectKey = {
                    description = "Controlecode die wordt gebruikt om dozen van de draagtaak te inspecteren.",
                    label = "Inspectie-toets",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Waardeloze items die kunnen worden gevonden bij het inspecteren van dozen van de draagtaak.",
                    label = "Waardeloze inspectie-items",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Kans op een bruikbare buitbeloning bij het inspecteren van dozen.",
                    label = "Kans bruikbare buit",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Bruikbare items die kunnen worden gevonden bij het inspecteren van dozen van de draagtaak.",
                    label = "Bruikbare inspectie-items",
                },
                jailJobsCarryInteractDistance = {
                    description = "Interactieafstand voor de draagtaak in de gevangenis.",
                    label = "Interactieafstand draagtaak",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maximaal toegestane afstand voor voortgang van de draagtaak in de gevangenis.",
                    label = "Maximale afstand draagtaak",
                },
                jailJobsCarryPickupKey = {
                    description = "Controlecode die wordt gebruikt om dozen van de draagtaak op te rapen.",
                    label = "Oppak-toets draagtaak",
                },
                jailJobsCarryPickupOffset = {
                    description = "Verschuivingsobject dat wordt gebruikt voor de oppaklocatie van de draagtaak.",
                    label = "Oppak-verschuiving",
                },
                jailJobsCarryTimeReduction = {
                    description = "Strafvermindering voor het voltooien van de draagtaak in de gevangenis.",
                    label = "Strafvermindering draagtaak",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Controlecode die wordt gebruikt bij de vuilniscontainer van de gevangenis.",
                    label = "Container-toets",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Model dat wordt gebruikt voor het vuilniscontainer-voorwerp van de gevangenis.",
                    label = "Containermodel",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Kans om smokkelwaar te vinden tijdens het schoonmaken.",
                    label = "Kans illegale vondst",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Items die tijdens het schoonmaken in de gevangenis kunnen worden gevonden.",
                    label = "Illegale vondstitems",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Time-out voor meldingen van illegale vondsten in milliseconden.",
                    label = "Time-out vondstmelding",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Afstand die wordt gebruikt voor interactie met schoonmaakafval.",
                    label = "Interactieafstand schoonmaak",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maximale afstand voordat schoonmaakvoorwerpen resetten of verdwijnen.",
                    label = "Maximale schoonmaakafstand",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maximumaantal gelijktijdige afvalvoorwerpen voor het schoonmaken in de gevangenis.",
                    label = "Maximumaantal afvalvoorwerpen",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimale afstand vanaf het middelpunt voor het spawnen van schoonmaakafval.",
                    label = "Minimale spawnradius",
                },
                jailJobsCleaningPickupKey = {
                    description = "Controlecode die wordt gebruikt om gevangenis-schoonmaakafval op te rapen.",
                    label = "Oppak-toets schoonmaak",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Aantal milliseconden tussen pogingen om schoonmaakafval te spawnen.",
                    label = "Spawninterval afval",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Radius die wordt gebruikt om schoonmaakafval-voorwerpen te spawnen.",
                    label = "Spawnradius afval",
                },
                jailJobsCleaningTrashModels = {
                    description = "Afvalvoorwerpmodellen die worden gebruikt voor de schoonmaaktaak in de gevangenis.",
                    itemLabel = "Model",
                    label = "Afvalmodellen",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "RGBA-omlijningskleur die wordt gebruikt voor schoonmaakafval-voorwerpen in de gevangenis.",
                    label = "Omlijningskleur",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Schakel omlijningen in op schoonmaakafval-voorwerpen in de gevangenis.",
                    label = "Afvalomlijning",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "Shader-ID die wordt gebruikt voor omlijningen van gevangenis-schoonmaakafval.",
                    label = "Omlijningsshader",
                },
                jailJobsTimeReduction = {
                    description = "Strafvermindering voor het voltooien van de schoonmaaktaak in de gevangenis.",
                    label = "Strafvermindering schoonmaak",
                },
                jailJobsTrashGoal = {
                    description = "Aantal afvalitems dat nodig is om de schoonmaaktaak in de gevangenis te voltooien.",
                    label = "Doel schoonmaakafval",
                },
                jailMaxMonths = {
                    description = "Maximaal selecteerbare gevangenisduur.",
                    label = "Maximum aantal maanden",
                },
                jailMinMonths = {
                    description = "Minimaal selecteerbare gevangenisduur.",
                    label = "Minimum aantal maanden",
                },
                jailMonthMinutes = {
                    description = "Aantal minuten in de echte tijd dat één gevangenismaand vertegenwoordigt.",
                    label = "Minuten per maand",
                },
                jailObjectStreamDistance = {
                    description = "Afstand die wordt gebruikt voor het laden van permanente wereldvoorwerpen van de gevangenis.",
                    label = "Objectweergaveafstand",
                },
                jailOutfitApplyDelayMs = {
                    description = "Vertraging na het verbinden voordat de gevangenisoutfit wordt toegepast.",
                    label = "Vertraging outfit toepassen",
                },
                jailOutfitEnabled = {
                    description = "Schakel gevangenisoutfits in.",
                    label = "Gevangenisoutfit",
                },
                jailOutfitFemaleArms = {
                    description = "Armencomponent van de vrouwen-gevangenisoutfit.",
                    label = "Armen",
                },
                jailOutfitFemaleChain1 = {
                    description = "Drawable van de ketting van de vrouwen-gevangenisoutfit.",
                    label = "Ketting 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Textuur van de ketting van de vrouwen-gevangenisoutfit.",
                    label = "Ketting 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Drawable van de stickers van de vrouwen-gevangenisoutfit.",
                    label = "Stickers 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Textuur van de stickers van de vrouwen-gevangenisoutfit.",
                    label = "Stickers 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Drawable van de bril van de vrouwen-gevangenisoutfit (-1 verwijdert de bril).",
                    label = "Bril 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Textuur van de bril van de vrouwen-gevangenisoutfit.",
                    label = "Bril 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Drawable van de helm van de vrouwen-gevangenisoutfit.",
                    label = "Helm 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Textuur van de helm van de vrouwen-gevangenisoutfit.",
                    label = "Helm 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Drawable van de broek van de vrouwen-gevangenisoutfit.",
                    label = "Broek 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Textuur van de broek van de vrouwen-gevangenisoutfit.",
                    label = "Broek 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Drawable van de schoenen van de vrouwen-gevangenisoutfit.",
                    label = "Schoenen 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Textuur van de schoenen van de vrouwen-gevangenisoutfit.",
                    label = "Schoenen 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Drawable van het bovenlijf van de vrouwen-gevangenisoutfit.",
                    label = "Bovenlijf 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Textuur van het bovenlijf van de vrouwen-gevangenisoutfit.",
                    label = "Bovenlijf 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Drawable van het T-shirt van de vrouwen-gevangenisoutfit.",
                    label = "T-shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Textuur van het T-shirt van de vrouwen-gevangenisoutfit.",
                    label = "T-shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Armencomponent van de mannen-gevangenisoutfit.",
                    label = "Armen",
                },
                jailOutfitMaleChain1 = {
                    description = "Drawable van de ketting van de mannen-gevangenisoutfit.",
                    label = "Ketting 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Textuur van de ketting van de mannen-gevangenisoutfit.",
                    label = "Ketting 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Drawable van de stickers van de mannen-gevangenisoutfit.",
                    label = "Stickers 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Textuur van de stickers van de mannen-gevangenisoutfit.",
                    label = "Stickers 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Drawable van de bril van de mannen-gevangenisoutfit (-1 verwijdert de bril).",
                    label = "Bril 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Textuur van de bril van de mannen-gevangenisoutfit.",
                    label = "Bril 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Drawable van de helm van de mannen-gevangenisoutfit.",
                    label = "Helm 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Textuur van de helm van de mannen-gevangenisoutfit.",
                    label = "Helm 2",
                },
                jailOutfitMalePants1 = {
                    description = "Drawable van de broek van de mannen-gevangenisoutfit.",
                    label = "Broek 1",
                },
                jailOutfitMalePants2 = {
                    description = "Textuur van de broek van de mannen-gevangenisoutfit.",
                    label = "Broek 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Drawable van de schoenen van de mannen-gevangenisoutfit.",
                    label = "Schoenen 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Textuur van de schoenen van de mannen-gevangenisoutfit.",
                    label = "Schoenen 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Drawable van het bovenlijf van de mannen-gevangenisoutfit.",
                    label = "Bovenlijf 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Textuur van het bovenlijf van de mannen-gevangenisoutfit.",
                    label = "Bovenlijf 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Drawable van het T-shirt van de mannen-gevangenisoutfit.",
                    label = "T-shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Textuur van het T-shirt van de mannen-gevangenisoutfit.",
                    label = "T-shirt 2",
                },
                jailRequireJailTerminal = {
                    description = "Sta celstraffen door agenten alleen toe bij een terminal van de geselecteerde gevangenis.",
                    label = "Gevangenisterminal vereist",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Herstel de opgeslagen burgeroutfit wanneer een gevangene ontsnapt.",
                    label = "Outfit herstellen bij ontsnapping",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Coulancevenster na herstel voordat spawn-correctie stopt met toepassen.",
                    label = "Herstel-correctievenster",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleporteer herstelde gevangenen terug naar het gevangenis-spawnpunt als ze buiten de gevangeniszone laden.",
                    label = "Teleporteer herstelde gevangenen",
                },
                jailTerminalRange = {
                    description = "Maximale afstand van de agent tot een terminal van de geselecteerde gevangenis.",
                    label = "Bereik gevangenisterminal",
                },
                jailZoneExitGraceMs = {
                    description = "Coulancevenster voordat het verlaten van de gevangeniszone als ontsnapping telt.",
                    label = "Coulance zone-verlaten",
                },
                mugshotAnimDict = {
                    description = "Animatiewoordenboek dat wordt gebruikt tijdens het maken van de boekingsfoto.",
                    label = "Animatiewoordenboek",
                },
                mugshotAnimFlag = {
                    description = "Animatievlag die wordt gebruikt tijdens het maken van de boekingsfoto.",
                    label = "Animatievlag",
                },
                mugshotAnimName = {
                    description = "Animatienaam die wordt gebruikt tijdens het maken van de boekingsfoto.",
                    label = "Animatienaam",
                },
                mugshotBoardHeader = {
                    description = "Hoofdkoptekst die wordt getoond op het boekingsfotobord.",
                    label = "Bordkoptekst",
                },
                mugshotBoardSubheader = {
                    description = "Reservesubkoptekst die wordt getoond op het boekingsfotobord.",
                    label = "Bord-subkoptekst",
                },
                mugshotCameraCoordsX = {
                    description = "Wereld-X-coördinaat van de camera die wordt gebruikt voor boekingsfoto's.",
                    label = "Camera X",
                },
                mugshotCameraCoordsY = {
                    description = "Wereld-Y-coördinaat van de camera die wordt gebruikt voor boekingsfoto's.",
                    label = "Camera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Wereld-Z-coördinaat van de camera die wordt gebruikt voor boekingsfoto's.",
                    label = "Camera Z",
                },
                mugshotCameraFov = {
                    description = "Gezichtsveld dat wordt gebruikt voor het maken van boekingsfoto's.",
                    label = "Camera-gezichtsveld",
                },
                mugshotCameraRotX = {
                    description = "Camerarotatie X die wordt gebruikt voor boekingsfoto's.",
                    label = "Rotatie X",
                },
                mugshotCameraRotY = {
                    description = "Camerarotatie Y die wordt gebruikt voor boekingsfoto's.",
                    label = "Rotatie Y",
                },
                mugshotCameraRotZ = {
                    description = "Camerarotatie Z die wordt gebruikt voor boekingsfoto's.",
                    label = "Rotatie Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maximumaantal milliseconden dat is toegestaan voor callbacks bij het maken van de boekingsfoto.",
                    label = "Time-out opname",
                },
                mugshotEnabled = {
                    description = "Schakel het maken van een boekingsfoto in bij binnenkomst in de gevangenis.",
                    label = "Boekingsfoto maken",
                },
                mugshotHeading = {
                    description = "Richting die wordt toegepast tijdens het maken van de boekingsfoto.",
                    label = "Richting",
                },
                mugshotLocationX = {
                    description = "Wereld-X-coördinaat die wordt gebruikt voor het maken van de boekingsfoto.",
                    label = "Locatie X",
                },
                mugshotLocationY = {
                    description = "Wereld-Y-coördinaat die wordt gebruikt voor het maken van de boekingsfoto.",
                    label = "Locatie Y",
                },
                mugshotLocationZ = {
                    description = "Wereld-Z-coördinaat die wordt gebruikt voor het maken van de boekingsfoto.",
                    label = "Locatie Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Omschrijvingsformaat dat wordt gebruikt voor de opgeslagen boekingsfoto-metadata.",
                    label = "Metadata-omschrijving",
                },
                mugshotMetadataName = {
                    description = "Naam van de inventarismetadata die wordt gebruikt voor de opgeslagen boekingsfoto.",
                    label = "Metadatanaam",
                },
                mugshotWaitMs = {
                    description = "Aantal milliseconden om te wachten voordat de boekingsfoto wordt gemaakt.",
                    label = "Wachttijd (milliseconden)",
                },
                playerSearchAnimDict = {
                    description = "Animatiewoordenboek dat wordt gebruikt tijdens het fouilleren van spelers.",
                    label = "Animatiewoordenboek",
                },
                playerSearchAnimFlag = {
                    description = "Animatievlag die wordt gebruikt tijdens het fouilleren van spelers.",
                    label = "Animatievlag",
                },
                playerSearchAnimName = {
                    description = "Animatienaam die wordt gebruikt tijdens het fouilleren van spelers.",
                    label = "Animatienaam",
                },
                playerSearchDurationMs = {
                    description = "Duur van de fouilleer-voorvertoning in milliseconden.",
                    label = "Fouilleerduur",
                },
                playerSearchEnabled = {
                    description = "Schakel de voorvertoningsworkflow voor het fouilleren van spelers in.",
                    label = "Fouilleren",
                },
                playerSearchRange = {
                    description = "Maximale afstand om het fouilleren van een speler te starten.",
                    label = "Fouilleerafstand",
                },
                playerSearchScenario = {
                    description = "Scenario dat wordt gebruikt wanneer geen expliciete fouilleeranimatie wordt afgespeeld.",
                    label = "Fouilleerscenario",
                },
                policeBillingControl200 = {
                    label = "Facturatie · Besturing 200",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeBillingControl322 = {
                    label = "Facturatie · Besturing 322",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl10 = {
                    label = "Editor · Besturing 10",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl11 = {
                    label = "Editor · Besturing 11",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl172 = {
                    label = "Editor · Besturing 172",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl173 = {
                    label = "Editor · Besturing 173",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl174 = {
                    label = "Editor · Besturing 174",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl175 = {
                    label = "Editor · Besturing 175",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl177 = {
                    label = "Editor · Besturing 177",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl191 = {
                    label = "Editor · Besturing 191",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl201 = {
                    label = "Editor · Besturing 201",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl202 = {
                    label = "Editor · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl21 = {
                    label = "Editor · Besturing 21",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl32 = {
                    label = "Editor · Besturing 32",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl322 = {
                    label = "Editor · Besturing 322",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl33 = {
                    label = "Editor · Besturing 33",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl34 = {
                    label = "Editor · Besturing 34",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl35 = {
                    label = "Editor · Besturing 35",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl36 = {
                    label = "Editor · Besturing 36",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl37 = {
                    label = "Editor · Besturing 37",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl38 = {
                    label = "Editor · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl44 = {
                    label = "Editor · Besturing 44",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policeEditorControl73 = {
                    label = "Editor · Besturing 73",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                policePrimaryColor = {
                    description = "Standaardkleur voor de politiewerkgroep.",
                    label = "Primaire kleur",
                },
                propPlacementConsumeItem = {
                    description = "Verwijder één inventarisitem wanneer een voorwerp vanuit de inventaris wordt geplaatst.",
                    label = "Voorwerpitem verbruiken",
                },
                propPlacementEnabled = {
                    description = "Sta toe dat geconfigureerde politievoorwerpen worden geplaatst vanuit items of voertuigen.",
                    label = "Voorwerpplaatsing",
                },
                propPlacementItemNames = {
                    description = "Koppel voorwerpmodellen aan inventarisitemnamen voor itemgebaseerde voorwerpplaatsing.",
                    label = "Voorwerpitem-namen",
                },
                propPlacementRequireOnDuty = {
                    description = "Alleen agenten die in dienst zijn kunnen geconfigureerde voorwerpen plaatsen.",
                    label = "Voorwerpen vereisen dienst",
                },
                propPlacementReturnItem = {
                    description = "Geef het verbruikte item terug wanneer een geplaatst voorwerp wordt verwijderd.",
                    label = "Voorwerpitem retourneren",
                },
                propPlacementVehicleAccess = {
                    description = "Sta toe dat jobvoertuigen hun geconfigureerde voorwerploadout beschikbaar stellen.",
                    label = "Voertuigvoorwerptoegang",
                },
                radialEnabled = {
                    description = "Schakel radiale politieacties in.",
                    label = "Politie-radiaal menu",
                },
                radialHandcuffKeybindCommand = {
                    description = "Commandonaam die is geregistreerd voor de boei-sneltoets.",
                    label = "Boei-commando",
                },
                radialHandcuffKeybindDescription = {
                    description = "Omschrijving die wordt getoond bij de boei-sneltoets.",
                    label = "Boei-omschrijving",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Schakel de directe boei-sneltoets in.",
                    label = "Boei-sneltoets",
                },
                radialHandcuffKeybindKey = {
                    description = "Toetsenbordtoets die wordt gebruikt voor de directe boei-actie.",
                    label = "Boei-toets",
                },
                radialKeybindsEnabled = {
                    description = "Schakel directe sneltoetsen in voor geselecteerde radiale acties.",
                    label = "Directe sneltoetsen",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Commandonaam die is geregistreerd voor de ontboei-sneltoets.",
                    label = "Ontboei-commando",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Omschrijving die wordt getoond bij de ontboei-sneltoets.",
                    label = "Ontboei-omschrijving",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Schakel de directe ontboei-sneltoets in.",
                    label = "Ontboei-sneltoets",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Toetsenbordtoets die wordt gebruikt voor de directe ontboei-actie.",
                    label = "Ontboei-toets",
                },
                socialWorkAssignRange = {
                    description = "Maximale afstand om sociaal-werktaken toe te wijzen.",
                    label = "Toewijzingsafstand",
                },
                socialWorkDeadlineDefault = {
                    description = "Standaard deadline voor sociaal werk in minuten. Nul schakelt deadlines uit.",
                    label = "Standaard deadline",
                },
                socialWorkDeadlineMax = {
                    description = "Maximale deadline voor sociaal werk in minuten. Nul schakelt de limiet uit.",
                    label = "Maximumtermijn",
                },
                socialWorkDeadlineMin = {
                    description = "Minimale deadline voor sociaal werk in minuten.",
                    label = "Minimumtermijn",
                },
                socialWorkDefaultTasks = {
                    description = "Standaard aantal taken bij het openen van de toewijzing voor sociaal werk.",
                    label = "Standaard aantal taken",
                },
                socialWorkEnabled = {
                    description = "Schakel toewijzing en taakworkflows voor sociaal werk in.",
                    label = "Sociaal werk",
                },
                socialWorkImprisonmentJailId = {
                    description = "Gevangenis-ID die wordt gebruikt wanneer overtredingen bij sociaal werk leiden tot opsluiting.",
                    label = "Reserve gevangenis-ID",
                },
                socialWorkImprisonmentMonths = {
                    description = "Aantal maanden dat wordt opgelegd wanneer overtredingen bij sociaal werk resulteren in gevangenisstraf.",
                    label = "Maanden opsluiting",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Agentnaam die wordt gebruikt voor opsluitingsrecords bij sociaal werk.",
                    label = "Naam behandelend agent",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Stuur overtreders naar de isoleercel wanneer opsluiting wordt geactiveerd.",
                    label = "Isoleercel gebruiken",
                },
                socialWorkInactivityMinutes = {
                    description = "Aantal minuten voordat inactiviteitsstraffen voor sociaal werk van toepassing worden.",
                    label = "Inactiviteitsminuten",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Taakstraf die wordt toegepast wanneer een speler met sociaal werk te lang inactief blijft.",
                    label = "Taakstraf bij inactiviteit",
                },
                socialWorkMaxTasks = {
                    description = "Maximaal selecteerbaar aantal sociaal-werktaken.",
                    label = "Maximumaantal taken",
                },
                socialWorkMinTasks = {
                    description = "Minimaal selecteerbaar aantal sociaal-werktaken.",
                    label = "Minimumaantal taken",
                },
                speedCamBillingEnabled = {
                    description = "Schrijf automatisch facturen uit wanneer snelheidscamera's een overeenkomende overtreding vastleggen. Vereist dat de algemene functie Facturatie is ingeschakeld.",
                    label = "Automatische boetes",
                },
                speedCamBillingExcludedJobs = {
                    description = "Banen die nooit automatische snelheidsboetes ontvangen.",
                    itemLabel = "Baan",
                    label = "Uitgesloten banen",
                },
                speedCamBillingExcludedModels = {
                    description = "Spawnnamen van voertuigen die nooit automatische snelheidsboetes ontvangen.",
                    itemLabel = "Model",
                    label = "Uitgesloten voertuigmodellen",
                },
                speedCamBillingRules = {
                    description = "Boeteregels die door snelheidscamera's worden gebruikt. Het nauwst overeenkomende overschrijdingsbereik wordt als eerste gefactureerd; als geen enkele regel overeenkomt, worden SpeedViolation-overtredingen als reserve gebruikt.",
                    label = "Boeteregels",
                },
                speedCamCameraEaseMs = {
                    description = "Hoe lang het duurt voordat de weergave overgaat naar de hoek van de snelheidscamera. Lager = kortere beweging; te laag kan de foto verkeerd uitlijnen.",
                    label = "Camera-overgang (ms)",
                },
                speedCamCameraFov = {
                    description = "Gezichtsveld dat wordt gebruikt voor opnames van de snelheidscamera.",
                    label = "Camera-gezichtsveld",
                },
                speedCamCheckIntervalMs = {
                    description = "Aantal milliseconden tussen scans van de snelheidscamera.",
                    label = "Controle-interval",
                },
                speedCamCooldownMs = {
                    description = "Aantal milliseconden voordat dezelfde snelheidscamera opnieuw kan activeren.",
                    label = "Activerings-afkoeltijd",
                },
                speedCamDamageCooldownMs = {
                    description = "Aantal milliseconden voordat er opnieuw schade aan de snelheidscamera kan worden toegebracht.",
                    label = "Schade-afkoeltijd",
                },
                speedCamDamagePerHit = {
                    description = "Duurzaamheidsschade die per treffer wordt toegebracht aan snelheidscamera's.",
                    label = "Schade per treffer",
                },
                speedCamDamagedModelThreshold = {
                    description = "Percentage van de maximale duurzaamheid waarop of waaronder het beschadigde model verschijnt. Voorbeeld: 50 bij een maximale duurzaamheid van 200 schakelt bij 100 duurzaamheid.",
                    label = "Drempel beschadigd model (%)",
                },
                speedCamDefaultLimit = {
                    description = "Standaard snelheidslimiet van de snelheidscamera.",
                    label = "Standaard snelheidslimiet",
                },
                speedCamDefaultName = {
                    description = "Voorgestelde weergavenaam bij het plaatsen van een flitser. Deze naam mag worden vertaald zonder het inventarisitem of propmodel te wijzigen.",
                    label = "Standaardnaam",
                },
                speedCamDefaultTolerance = {
                    description = "Standaard tolerantie van de snelheidscamera.",
                    label = "Standaard tolerantie",
                },
                speedCamDisassembleDistance = {
                    description = "Afstand die wordt gebruikt om snelheidscamera's te demonteren.",
                    label = "Demontageafstand",
                },
                speedCamEnabled = {
                    description = "Schakel draagbare snelheidscamera's in.",
                    label = "Snelheidscamera's",
                },
                speedCamFlashColor = {
                    description = "RGBA-flitskleur die door snelheidscamera's wordt gebruikt.",
                    label = "Flitskleur",
                },
                speedCamFlashDurationMs = {
                    description = "Uitfadetijd van de rode flits van de snelheidscamera. Stel dit niet te laag in, anders wordt de camerabeweging zichtbaar.",
                    label = "Flitsduur (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Afstand waarop de conditie van de snelheidscamera wordt getoond.",
                    label = "Weergaveafstand conditie",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Aantal milliseconden dat de conditie van de snelheidscamera zichtbaar blijft.",
                    label = "Weergaveduur conditie",
                },
                speedCamHealthTextOffset = {
                    description = "Verticale verschuiving die wordt gebruikt voor de conditietekst van de snelheidscamera.",
                    label = "Tekstverschuiving conditie",
                },
                speedCamItem = {
                    description = "Exacte interne itemnaam in de inventaris, bijvoorbeeld speedcam. Vul de itemsleutel in, niet de weergavenaam; de baanwinkel moet hetzelfde item geven.",
                    label = "Itemnaam flitser",
                },
                speedCamMaintenanceThreshold = {
                    description = "Duurzaamheidsdrempel waarbij onderhoud aan de snelheidscamera wordt aanbevolen.",
                    label = "Onderhoudsdrempel",
                },
                speedCamMaxDurability = {
                    description = "Maximale duurzaamheid van geplaatste snelheidscamera's.",
                    label = "Maximale duurzaamheid",
                },
                speedCamMaxLimit = {
                    description = "Maximaal configureerbare snelheidslimiet van de camera.",
                    label = "Maximale snelheidslimiet",
                },
                speedCamMaxTolerance = {
                    description = "Maximaal configureerbare tolerantie van de snelheidscamera.",
                    label = "Maximale tolerantie",
                },
                speedCamPhotoLocale = {
                    description = "Optionele regio-instelling die wordt gebruikt voor de tijdstempel op foto's van de snelheidscamera. Laat leeg om de lokale regio-instelling van de geflitste speler te gebruiken.",
                    label = "Foto-regio-instelling",
                },
                speedCamPhotoTimeZone = {
                    description = "Optionele tijdzone die wordt gebruikt voor de tijdstempel op foto's van de snelheidscamera. Laat leeg om de lokale tijdzone van de geflitste speler te gebruiken.",
                    label = "Foto-tijdzone",
                },
                speedCamPoliceNotification = {
                    description = "Verstuur een dispatchmelding wanneer snelheidscamera's overtredingen vastleggen.",
                    label = "Politiewaarschuwing snelheidscamera",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Behandel het dispatch-doel van de snelheidscamera als een jobgroep.",
                    label = "Dispatch-doel is groep",
                },
                speedCamPoliceNotificationJob = {
                    description = "Job- of groepssleutel die wordt gebruikt voor dispatchmeldingen van de snelheidscamera.",
                    label = "Dispatch-doel",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Meld alleen aan dispatch-doelen van de snelheidscamera die in dienst zijn.",
                    label = "Dispatch vereist dienst",
                },
                speedCamPoliceNotificationType = {
                    description = "Dispatch-ernst/type dat wordt gebruikt voor waarschuwingen van de snelheidscamera.",
                    label = "Dispatch-type",
                },
                speedCamPropModel = {
                    description = "Spawnnaam van het intacte flitsermodel, bijvoorbeeld sky_speedcam. Een voorinstelling selecteert ook de beschadigde en vernielde modellen. Eigen modellen moeten beschikbaar zijn in het spel.",
                    label = "Voorwerpmodel snelheidscamera",
                    custom = "Aangepast model",
                    choose = "Kies een model",
                    preview = "3D-voorbeeld",
                    customPlaceholder = "Spawnnaam van prop",
                    previewDescription = "Bekijk de gekozen prop in het spel. Het voorbeeld slaat niets op.",
                    invalidModel = "Voer eerst een geldige propnaam in.",
                    modelMissing = "Dit propmodel is niet beschikbaar in het spel.",
                    previewFailed = "Het modelvoorbeeld kon niet worden geopend.",
                    intact = "Intact propmodel",
                    previewRequiresGame = "Open /jobconfig in FiveM om de prop live te bekijken.",
                    previewHelp = "Pijlen: verplaatsen; PageUp/PageDown: hoogte; muiswiel: draaien; Enter: sluiten; Backspace: annuleren.",
                    options = {
                        sky_speedcam = "Standaard flitspaal",
                        sky_germ_speedcam = "Duitse flitspaal",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Spawnnaam van het beschadigde flitsermodel, bijvoorbeeld sky_speedcam2. Gebruik een variant die bij het intacte model hoort.",
                    label = "Beschadigd voorwerpmodel",
                },
                speedCamPropModelDestroyed = {
                    description = "Spawnnaam van het model bij 0 duurzaamheid, bijvoorbeeld sky_speedcam1. Gebruik een variant die bij het intacte model hoort.",
                    label = "Vernietigd voorwerpmodel",
                },
                speedCamRepairAnimDict = {
                    description = "Animatiewoordenboek dat wordt gebruikt tijdens het repareren van snelheidscamera's.",
                    label = "Reparatie-animatiewoordenboek",
                },
                speedCamRepairAnimFlag = {
                    description = "Animatievlag die wordt gebruikt tijdens het repareren van snelheidscamera's.",
                    label = "Reparatie-animatievlag",
                },
                speedCamRepairAnimName = {
                    description = "Animatienaam die wordt gebruikt tijdens het repareren van snelheidscamera's.",
                    label = "Reparatie-animatienaam",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Aantal milliseconden voordat de reparatie van de snelheidscamera kan worden geannuleerd.",
                    label = "Annuleervertraging reparatie",
                },
                speedCamRepairDistance = {
                    description = "Afstand die wordt gebruikt om snelheidscamera's te repareren.",
                    label = "Reparatieafstand",
                },
                speedCamRepairItem = {
                    description = "Exacte interne itemnaam voor reparaties, bijvoorbeeld fixtool. Vul de itemsleutel in, niet de weergavenaam.",
                    label = "Itemnaam voor reparatie",
                },
                speedCamRepairPerTick = {
                    description = "Duurzaamheid die per reparatietik van de snelheidscamera wordt hersteld.",
                    label = "Herstel per tik",
                },
                speedCamRepairTickMs = {
                    description = "Aantal milliseconden tussen reparatietikken van de snelheidscamera.",
                    label = "Reparatietik",
                },
                speedCamStreamDistance = {
                    description = "Afstand tot de speler in meters waarbinnen flitsermodellen worden geladen. Daarbuiten worden de modellen uitgeladen; opgeslagen flitsers blijven geplaatst.",
                    label = "Laadafstand",
                },
                speedCamTriggerRadius = {
                    description = "Detectiestraal in meters rond de flitser voor voertuigen die te hard rijden.",
                    label = "Activeringsradius",
                },
                speedCamUseMph = {
                    description = "Toon en verwerk snelheidslimieten van de camera in MPH.",
                    label = "MPH gebruiken",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Wapens die snelheidscamera's mogen beschadigen zolang de beperking is ingeschakeld.",
                    itemLabel = "Wapen",
                    label = "Toegestane wapens",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Alleen vermelde wapens kunnen snelheidscamera's beschadigen zolang dit is ingeschakeld.",
                    label = "Beperking ingeschakeld",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Afstand in meters voordat snelheidscamerawaarschuwingen worden gewist.",
                    label = "Wisafstand",
                },
                speedCameraAppDefaultApp = {
                    description = "Toon de snelheidscamera-app als standaard tablet-app.",
                    label = "Standaard-app",
                },
                speedCameraAppDescription = {
                    description = "Omschrijving die wordt getoond voor de snelheidscamera-tablet-app.",
                    label = "Omschrijving",
                },
                speedCameraAppDeveloper = {
                    description = "Ontwikkelaarslabel dat wordt getoond voor de snelheidscamera-tablet-app.",
                    label = "Ontwikkelaar",
                },
                speedCameraAppEnabled = {
                    description = "Schakel de snelheidscamera-app op de politietablet in.",
                    label = "Snelheidscamera-tablet-app",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Subtitel boven de koptekst die wordt getoond in de snelheidscamera-app.",
                    label = "Kop-subtitel",
                },
                speedCameraAppHeaderTitle = {
                    description = "Koptitel die wordt getoond in de snelheidscamera-app.",
                    label = "Koptitel",
                },
                speedCameraAppIcon = {
                    description = "Icoonpad dat wordt gebruikt voor de snelheidscamera-tablet-app.",
                    label = "Icoonpad",
                },
                speedCameraAppIdentifier = {
                    description = "Interne identificatiecode voor de snelheidscamera-tablet-app.",
                    label = "Identificatiecode",
                },
                speedCameraAppInFrontDot = {
                    description = "Drempelwaarde die wordt gebruikt om te bepalen of een snelheidscamera zich voor de speler bevindt.",
                    label = "Voor-drempelwaarde",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Minimale voertuigsnelheid in km/u voordat waarschuwingen worden getoond.",
                    label = "Minimale voertuigsnelheid",
                },
                speedCameraAppName = {
                    description = "Weergavenaam van de snelheidscamera-tablet-app.",
                    label = "App-naam",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Afstand in meters voordat wordt gemeld over nabijgelegen snelheidscamera's.",
                    label = "Meldingsafstand",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Waarschuw alleen voor snelheidscamera's terwijl de speler in een voertuig zit.",
                    label = "Alleen in voertuig",
                },
                speedCameraAppOverlayBackground = {
                    description = "Achtergrondkleur die wordt gebruikt voor de kentekenoverlay.",
                    label = "Overlay-achtergrond",
                },
                speedCameraAppOverlayBorder = {
                    description = "Randkleur die wordt gebruikt voor de kentekenoverlay.",
                    label = "Overlayrand",
                },
                speedCameraAppOverlayColor = {
                    description = "Tekstkleur die wordt gebruikt voor de kentekenoverlay.",
                    label = "Overlaykleur",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Schakel kentekenoverlays in op vastgelegde snelheidscamerabeelden.",
                    label = "Overlay ingeschakeld",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Lettergrootteschaal die wordt gebruikt voor de kentekenoverlay.",
                    label = "Overlay lettergrootte",
                },
                speedCameraAppOverlayX = {
                    description = "Genormaliseerde X-positie van de overlay van links naar rechts.",
                    label = "X-overlay",
                },
                speedCameraAppOverlayY = {
                    description = "Genormaliseerde Y-positie van de overlay van boven naar beneden.",
                    label = "Y-overlay",
                },
                speedCameraAppRequireInFront = {
                    description = "Waarschuw alleen voor snelheidscamera's die zich voor de speler bevinden.",
                    label = "Alleen vooraan vereisen",
                },
                speedCameraAppRoute = {
                    description = "Routerpad dat wordt geopend door de snelheidscamera-tablet-app.",
                    label = "Route",
                },
                speedCameraAppSize = {
                    description = "Gerapporteerde opslaggrootte van de snelheidscamera-tablet-app.",
                    label = "App-grootte",
                },
                speedCameraAppSoundCoord = {
                    description = "Speel waarschuwingsgeluiden van de snelheidscamera af op wereldcoördinaten.",
                    label = "Geluid op coördinaten",
                },
                speedCameraAppSoundEnabled = {
                    description = "Schakel waarschuwingsgeluiden in voor de snelheidscamera-app.",
                    label = "Geluid ingeschakeld",
                },
                speedCameraAppSoundFrontend = {
                    description = "Speel waarschuwingsgeluiden van de snelheidscamera af op het frontend-audiokanaal.",
                    label = "Frontend-geluid",
                },
                speedCameraAppSoundLayers = {
                    description = "Aantal gelaagde waarschuwingsgeluiden dat door de snelheidscamera-app wordt afgespeeld.",
                    label = "Geluidslagen",
                },
                speedCameraAppSoundName = {
                    description = "Geluidsnaam die wordt gebruikt voor waarschuwingen van de snelheidscamera-app.",
                    label = "Geluidsnaam",
                },
                speedCameraAppSoundRange = {
                    description = "Bereik dat wordt gebruikt voor waarschuwingsgeluiden van de snelheidscamera-app.",
                    label = "Geluidsbereik",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Aantal keren dat het waarschuwingsgeluid van de snelheidscamera wordt herhaald.",
                    label = "Aantal herhalingen",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Aantal milliseconden tussen herhalingen van het waarschuwingsgeluid van de snelheidscamera.",
                    label = "Herhalingsvertraging",
                },
                speedCameraAppSoundSet = {
                    description = "Geluidsset die wordt gebruikt voor waarschuwingen van de snelheidscamera-app.",
                    label = "Geluidsset",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Rekening die wordt gebruikt voor betalingen van het abonnement op de snelheidscamera-tablet-app.",
                    label = "Rekening",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Schakel betaalde abonnementen in voor de snelheidscamera-tablet-app.",
                    label = "Abonnement ingeschakeld",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Aantal dagen tussen verlengingen van het abonnement op de snelheidscamera-tablet-app.",
                    label = "Interval (dagen)",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Prijs die in rekening wordt gebracht voor het abonnement op de snelheidscamera-tablet-app.",
                    label = "Abonnementsprijs",
                },
                speedCameraAppThemeAccent = {
                    description = "Accentkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Accent",
                },
                speedCameraAppThemeBackground = {
                    description = "Lineaire verloopachtergrond die wordt gebruikt door de snelheidscamera-app.",
                    label = "Achtergrond",
                },
                speedCameraAppThemeBorder = {
                    description = "Randkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Rand",
                },
                speedCameraAppThemeButtonText = {
                    description = "Knoptekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Knoptekst",
                },
                speedCameraAppThemeDanger = {
                    description = "Gevaarkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Gevaar",
                },
                speedCameraAppThemeGhost = {
                    description = "Ghost-knopkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Spook",
                },
                speedCameraAppThemeGhostText = {
                    description = "Ghost-tekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Ghost-tekst",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Zachte verloopkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Zacht verloop",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Inactieve randkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Inactieve rand",
                },
                speedCameraAppThemeModal = {
                    description = "Achtergrondkleur van het modaalvenster die wordt gebruikt door de snelheidscamera-app.",
                    label = "Modaalvenster",
                },
                speedCameraAppThemeMutedText = {
                    description = "Gedempte tekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Gedempte tekst",
                },
                speedCameraAppThemeOverlay = {
                    description = "Overlaykleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Overlay",
                },
                speedCameraAppThemePillText = {
                    description = "Pil-tekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Pil-tekst",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Startkleur van het primaire verloop die wordt gebruikt door de snelheidscamera-app.",
                    label = "Primair start",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Eindkleur van het primaire verloop die wordt gebruikt door de snelheidscamera-app.",
                    label = "Primair eind",
                },
                speedCameraAppThemeShadow = {
                    description = "Schaduwkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Schaduw",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Spotlight-accentkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Spotlight",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Subtiele tekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Subtiele tekst",
                },
                speedCameraAppThemeSuccess = {
                    description = "Succeskleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Succes",
                },
                speedCameraAppThemeSurface = {
                    description = "Oppervlaktekleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Oppervlak",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Zachte oppervlaktekleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Zacht oppervlak",
                },
                speedCameraAppThemeText = {
                    description = "Primaire tekstkleur die wordt gebruikt door de snelheidscamera-app.",
                    label = "Tekst",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA-accentkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Accent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA-kleur die wordt gebruikt voor de achtergrond van de snelheidscamera-waarschuwingsinterface.",
                    label = "Achtergrond RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA-icoonkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Icoon RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA-icoontekstkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Icoontekst RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Aantal seconden dat de waarschuwingsinterface zichtbaar blijft.",
                    label = "Waarschuwingsduur (seconden)",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA-subtekstkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Subtekst RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "RGBA-tekstkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Tekst RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "RGBA-titelkleur die wordt gebruikt voor de snelheidscamera-waarschuwingsinterface.",
                    label = "Titel RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Aantal milliseconden tussen nabijheidscontroles van spijkermatten.",
                    label = "Controle-interval",
                },
                spikeStripsEnabled = {
                    description = "Schakel uitgerolde spijkermatten in.",
                    label = "Spijkermatten",
                },
                spikeStripsModels = {
                    description = "Voorwerpmodellen die worden beschouwd als actieve spijkermatten.",
                    itemLabel = "Model",
                    label = "Modellen",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Aantal milliseconden voordat het scannen van spijkermatten opnieuw wordt geprobeerd na geen overeenkomst.",
                    label = "Herhalingsinterval",
                },
                spikeStripsScanDistance = {
                    description = "Afstand die wordt gebruikt om te scannen op nabijgelegen spijkermatten.",
                    label = "Scanafstand",
                },
                spikeStripsTriggerDistance = {
                    description = "Afstand waarop banden door een spijkermat worden lekgeprikt.",
                    label = "Activeringsafstand",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Categorielabel dat wordt gebruikt voor blips van de stationmaker.",
                    label = "Stationsblip-categorie",
                },
                stationCreatorBlipColor = {
                    description = "Kaartblipkleur die wordt gebruikt voor politiestations.",
                    label = "Stationsblip-kleur",
                },
                stationCreatorBlipScale = {
                    description = "Schaal die wordt gebruikt voor politiestation-blips.",
                    label = "Stationsblip-schaal",
                },
                stationCreatorBlipShortRange = {
                    description = "Toon stationsblips alleen op korte afstand.",
                    label = "Stationsblip korte afstand",
                },
                stationCreatorBlipSprite = {
                    description = "Kaartblip-sprite die wordt gebruikt voor politiestations.",
                    label = "Stationsblip-sprite",
                },
                stationCreatorBlipUseStationName = {
                    description = "Gebruik de geconfigureerde stationsnaam als label voor de kaartblip.",
                    label = "Stationsnaam gebruiken",
                },
                tabletAutoFillCitizens = {
                    description = "Vul het burgerregister vooraf in vanuit de frameworkdatabase.",
                    label = "Burgers automatisch invullen",
                },
                tabletAutoFillVehicles = {
                    description = "Vul het voertuigregister vooraf in vanuit de frameworkdatabase.",
                    label = "Voertuigen automatisch invullen",
                },
                tabletBolos = {
                    description = "Toon de BOLO-app.",
                    label = "BOLO's",
                },
                tabletCases = {
                    description = "Toon de zaken-app.",
                    label = "Zaken",
                },
                tabletCitizens = {
                    description = "Toon de burgerregister-app.",
                    label = "Burgers",
                },
                tabletConfiscations = {
                    description = "Toon het register van voorwerpen die bij fouilleringen in beslag zijn genomen.",
                    label = "Inbeslagnames",
                },
                tabletOffences = {
                    description = "Toon de overtredingen-app.",
                    label = "Overtredingen",
                },
                tabletPrison = {
                    description = "Toon de gevangenis-app.",
                    label = "Gevangenis",
                },
                tabletReportEnforcement = {
                    description = "Laat agenten overtredingen koppelen en boetes of celstraffen uitvoeren vanuit opgeslagen rapporten.",
                    label = "Rapporthandhaving",
                },
                tabletReports = {
                    description = "Toon de rapporten-app.",
                    label = "Rapporten",
                },
                tabletSocialWork = {
                    description = "Toon de sociaal-werk-app.",
                    label = "Sociaal werk",
                },
                tabletVehicles = {
                    description = "Toon de voertuigregister-app.",
                    label = "Voertuigen",
                },
                tabletWarrants = {
                    description = "Toon de arrestatiebevelen-app.",
                    label = "Arrestatiebevelen",
                },
                tabletWeapons = {
                    description = "Toon de wapenregister-app.",
                    label = "Wapens",
                },
                tackleCuffKey = {
                    label = "Getackelde persoon boeien",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                tackleKey = {
                    label = "Tackelen",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                tackleReleaseKey = {
                    label = "Getackelde persoon loslaten",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Aantal milliseconden voordat er opnieuw een radarwaarschuwing kan worden gegeven.",
                    label = "Waarschuwings-afkoeltijd",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Voertuigklassen die de radar mogen gebruiken.",
                    label = "Toegestane voertuigklassen",
                },
                vehicleRadarAutoFastLock = {
                    description = "Markeer automatisch zeer snelle doelwitten in de radar.",
                    label = "Automatische snelvergrendeling",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Snelheidsdrempel die wordt gebruikt voor automatische snelvergrendeling.",
                    label = "Drempel snelvergrendeling",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Toetstoewijzing die wordt gebruikt om de snelheidslimiet van de radar te verlagen.",
                    label = "Toets limiet verlagen",
                },
                vehicleRadarDefaultLimit = {
                    description = "Standaard snelheidslimiet die door de voertuigradar wordt gebruikt.",
                    label = "Standaard radarlimiet",
                },
                vehicleRadarEnabled = {
                    description = "Schakel de radar van het patrouillevoertuig in.",
                    label = "Voertuigradar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Toetstoewijzing die wordt gebruikt om de snelheidslimiet van de radar te verhogen.",
                    label = "Toets limiet verhogen",
                },
                vehicleRadarLimitStep = {
                    description = "Hoeveelheid die per aanpassing van de radarlimiet wordt gewijzigd.",
                    label = "Limietstap",
                },
                vehicleRadarLockFrontKey = {
                    description = "Toetstoewijzing die wordt gebruikt om het doelwit van de voorradar te vergrendelen.",
                    label = "Voor-vergrendeltoets",
                },
                vehicleRadarLockRearKey = {
                    description = "Toetstoewijzing die wordt gebruikt om het doelwit van de achterradar te vergrendelen.",
                    label = "Achter-vergrendeltoets",
                },
                vehicleRadarMaxLimit = {
                    description = "Maximale snelheidslimiet die is toegestaan in de voertuigradar.",
                    label = "Maximum radarlimiet",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maximale kantelhoek die is toegestaan voor het richten van de radar.",
                    label = "Maximale kantelhoek",
                },
                vehicleRadarMinLimit = {
                    description = "Minimale snelheidslimiet die is toegestaan in de voertuigradar.",
                    label = "Minimum radarlimiet",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Minimale snelheid voordat de radar een doelwit als geldig beschouwt.",
                    label = "Minimale doelsnelheid",
                },
                vehicleRadarModeFrontKey = {
                    description = "Toetstoewijzing die wordt gebruikt om de voorradar-modus te wisselen.",
                    label = "Toets voormodus",
                },
                vehicleRadarModeRearKey = {
                    description = "Toetstoewijzing die wordt gebruikt om de achterradar-modus te wisselen.",
                    label = "Toets achtermodus",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Aantal milliseconden tussen radarscans terwijl het patrouillevoertuig beweegt.",
                    label = "Scaninterval bij beweging",
                },
                vehicleRadarPassengerControl = {
                    description = "Sta toe dat passagiers de voertuigradar bedienen.",
                    label = "Bediening door passagier",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Sta toe dat passagiers gespiegelde radargegevens bekijken.",
                    label = "Passagiersweergave",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Aantal milliseconden tussen radarsynchronisaties voor passagiers.",
                    label = "Synchronisatie-interval passagier",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Projectiedrempel die wordt gebruikt bij het beoordelen van radardoelwitten.",
                    label = "Projectiedrempel",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Vereis een vrije zichtlijn voordat de radar een doelwit vergrendelt.",
                    label = "Zichtlijn vereisen",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Vereis diensttoestand voordat de voertuigradar kan worden gebruikt.",
                    label = "Radar vereist dienst",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Aantal milliseconden tussen scans van de stilstaande radar.",
                    label = "Scaninterval",
                },
                vehicleRadarScanRadius = {
                    description = "Scanradius van de voertuigradar.",
                    label = "Scanradius",
                },
                vehicleRadarToggleKey = {
                    description = "Toetstoewijzing die wordt gebruikt om de voertuigradar aan/uit te schakelen.",
                    label = "Aan/uit-toets",
                },
                vehicleRadarUseMph = {
                    description = "Toon radarsnelheidswaarden in MPH.",
                    label = "Radar gebruikt MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Aantal milliseconden tussen vernieuwingen van de pool met nabijgelegen voertuigen.",
                    label = "Vernieuwing voertuigpool",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Toetstoewijzing die wordt gebruikt voor XMIT/HOLD van de voorradar.",
                    label = "Voor-XMIT-toets",
                },
                vehicleRadarXmitRearKey = {
                    description = "Toetstoewijzing die wordt gebruikt voor XMIT/HOLD van de achterradar.",
                    label = "Achter-XMIT-toets",
                },
                wheelClampConsumeItem = {
                    description = "Verwijder het wielklem-item na plaatsing.",
                    label = "Klem-item verbruiken",
                },
                wheelClampEnabled = {
                    description = "Schakel de wielklemactie in.",
                    label = "Wielklem",
                },
                wheelClampItem = {
                    description = "Inventarisitem dat wordt gebruikt voor het plaatsen van de wielklem.",
                    label = "Klem-item",
                },
                wheelClampPropModel = {
                    description = "Voorwerpmodel dat wordt gebruikt voor de geplaatste wielklem.",
                    label = "Klem-voorwerpmodel",
                },
                wheelClampRequireItem = {
                    description = "Vereis het geconfigureerde wielklem-item. Houd dit ingeschakeld wanneer de gebruiksmodus van de klem is ingesteld op Inventaris of Beide.",
                    label = "Klem vereist item",
                },
                wheelClampRequireOnDuty = {
                    description = "Vereis diensttoestand voordat wielklemmen kunnen worden geplaatst.",
                    label = "Klem vereist dienst",
                },
                wheelClampTyreDistance = {
                    description = "Maximale afstand tot de band bij het plaatsen of lassen van een klem.",
                    label = "Bandafstand",
                },
                wheelClampUseItem = {
                    description = "Gebruik radiaal menu, inventaris of beide voor het plaatsen van wielklemmen. Inventaris of Beide moet worden gecombineerd met 'Klem vereist item'.",
                    label = "Klem-gebruiksmodus",
                    options = {
                        both = "Beide",
                        inventory = "Inventaris",
                        radial = "Radiaal menu",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maximale afstand tot het doelvoertuig bij het plaatsen van een klem.",
                    label = "Voertuigafstand",
                },
                wheelClampWeldBurstTyre = {
                    description = "Laat de band klappen nadat een klem is losgelast.",
                    label = "Band laten klappen",
                },
                wheelClampWeldDurationMs = {
                    description = "Aantal milliseconden dat nodig is om een klem te verwijderen door lassen.",
                    label = "Lasduur",
                },
                wheelClampWeldEnabled = {
                    description = "Sta toe dat wielklemmen met een lasapparaat worden verwijderd.",
                    label = "Klem lassen",
                },
                wheelClampWeldItem = {
                    description = "Inventarisitem dat vereist is voor het lassen van de klem.",
                    label = "Lasapparaat-item",
                },
                wheelClampWeldMinigame = {
                    description = "Vereis de klem-las-minigame voordat het verwijderen wordt voltooid.",
                    label = "Las-minigame",
                },
                ziptiesConsumeItem = {
                    description = "Verwijder een tape-item wanneer het wordt aangebracht.",
                    label = "Tape verbruiken",
                },
                ziptiesCutterConsumeItem = {
                    description = "Verwijder het knipper-item na het doorknippen van tape.",
                    label = "Knipper-item verbruiken",
                },
                ziptiesCutterEnabled = {
                    description = "Sta toe dat draadknippers tape verwijderen.",
                    label = "Tapeknipper",
                },
                ziptiesCutterItem = {
                    description = "Inventarisitem dat wordt gebruikt om tape door te knippen.",
                    label = "Knipper-item",
                },
                ziptiesEnabled = {
                    description = "Schakel tape-acties in.",
                    label = "Tape",
                },
                ziptiesItem = {
                    description = "Inventarisitem dat wordt gebruikt voor tape-acties.",
                    label = "Tape-item",
                },
                ziptiesRequireHandsUp = {
                    description = "Vereis de 'handen omhoog'-status voordat tape kan worden aangebracht.",
                    label = "Handen omhoog vereist voor tape",
                },
                ziptiesRequireItem = {
                    description = "Vereis het geconfigureerde tape-item.",
                    label = "Tape vereist item",
                },
                ziptiesReturnOnRemove = {
                    description = "Geef een tape-item terug wanneer de tape wordt verwijderd.",
                    label = "Tape retourneren",
                },
                evidenceGsrDurationSeconds = {
                    description = "Seconds kruitsporen blijven op de handen van een speler.",
                    label = "GSR duur",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Voorkomen dat GSR wordt toegepast wanneer de schutter handschoenen draagt.",
                    label = "Handschoenen beschermen handen",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Wapens die geen kruitsporen gebruiken.",
                    label = "Genegeerde wapens",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milliseconden tussen water/regen schoonmaakcontroles terwijl GSR actief is.",
                    label = "Controle-interval wassen",
                },
                evidenceGsrWashInRain = {
                    description = "Laat regenen om kruitsporen te verwijderen.",
                    label = "Was in de regen",
                },
                evidenceGsrWashInWater = {
                    description = "Laat water kruitsporen verwijderen.",
                    label = "Was in water",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam toont nepplaat",
                    description = "Toont de valse plaat in de helikoptercamera.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normale gereedschappen tonen nepplaat",
                    description = "Toont de valse plaat in standaard politiegereedschappen.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar toont nepplaat",
                    description = "Toont de valse plaat op de radar aan boord.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Laat de politie de gedeelde nepplaat tas lezen.",
                    label = "Herkennen van valse platen",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Voertuig entiteit statebag sleutel gepubliceerd door Mechanicjob.",
                    label = "Statebag-sleutel",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam toont nepplaat",
                    description = "Toont de valse plaat in vaste radarrapporten.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Facultatief beroep/vergunningslijst. Laat leeg om alle kwaliteiten van de toegestane beroepen toe te staan.",
                    label = "VIN klassen",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN beroepen",
                    description = "beroepen die gebruik mogen maken van VIN verificatie.",
                },
                fakePlateVinAudit = {
                    label = "Controle VIN controles",
                    description = "Bespaart VIN controles aan de audit log.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN controle ingeschakeld",
                    description = "Schakel het verificatiecommando van voertuig VIN in.",
                },
                fakePlateVinCommand = {
                    label = "VIN commando",
                    description = "Commando gebruikt om de VIN. van een voertuig te controleren.",
                },
                fakePlateVinCooldown = {
                    label = "VIN afkoeling",
                    description = "Vertraging tussen twee VIN controles.",
                },
                fakePlateVinDistance = {
                    label = "VIN max afstand",
                    description = "Maximale afstand tussen de officier en het voertuig om de VIN. te verifiëren",
                },
                fakePlateVinIndicator = {
                    label = "Namaak-indicator tonen",
                    description = "Toont een indicator wanneer een controle een nepplaat detecteert.",
                },
                fakePlateVinRequireDuty = {
                    label = "Vereist plicht",
                    description = "Verzoekt de officier om dienst te hebben om een VIN te verifiëren.",
                },
                fakePlateVinRequireScanner = {
                    label = "Scanner-item nodig",
                    description = "Vereist dat het geconfigureerde scannerobject een VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Scanner-item",
                    description = "Inventaris nodig om een VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Laat de gevangene werkloos worden als ze gevangen zitten.",
                    label = "Verwijder beroep in de gevangenis",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Het oorspronkelijke beroep van de gevangene herstellen na de vrijlating.",
                    label = "Origineel beroep herstellen",
                },
                primaryColor = {
                    description = "Standaardkleur voor de politiewerkgroep.",
                    label = "Primaire kleur",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Laat beoordelaars om de geregistreerde eigenaar te factureren, zelfs wanneer de gevangen plaat wordt gemarkeerd als nep of gekloond.",
                    label = "Vermoedelijke valse platen toestaan",
                },
                speedCamAdvancedPageSize = {
                    description = "Maximale opnames per tabletpagina.",
                    label = "Paginagrootte bekijken",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Voertuigkanten waarvan de foto's kunnen worden gebruikt voor plaatherkenning. Gebruik voor- en/of achterzijde.",
                    itemLabel = "Zijzijde",
                    label = "Herkenbare zijden",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Alleen goedkeuring toestaan na het uploaden van de snelheidscamera.",
                    label = "Vereist foto-bewijs",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu toestemming vereist om captures goed te keuren of weg te gooien. 18 is Manage Billing.",
                    label = "Toestemming tot herziening ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Vangsten waarvan de plaat niet aanwezig is in de geregistreerde voertuigdatabase.",
                    label = "Niet-geregistreerde voertuigen opslaan",
                },
                tabletSpeedcamReviews = {
                    description = "Toon de geavanceerde snelheidscamera review app wanneer geavanceerde modus is ingeschakeld.",
                    label = "Snelheidscamera beoordelingen",
                },
                tackleCommand = {
                    description = "Opdracht geregistreerd voor het aanpakken van de dichtstbijzijnde persoon. Voer de commandonaam in zonder een slash.",
                    label = "Tackle-opdracht",
                },
                tackleCuffCommand = {
                    description = "Opdracht geregistreerd voor het manchetten van de persoon die momenteel wordt vastgehouden na een tackle. Voer de commandonaam in zonder een slash.",
                    label = "Manchetcommando",
                },
                tackleCuffDescription = {
                    description = "Beschrijving weergegeven voor de tackle manchet binding in het FiveM sleutel bindingen menu.",
                    label = "Aanpakken manchet sleutelbind beschrijving",
                },
                tackleDescription = {
                    description = "Beschrijving weergegeven voor de tackle binding in het FiveM sleutel bindingen menu.",
                    label = "Toetsenbindbeschrijving",
                },
                tackleEnabled = {
                    description = "Activeer het aanpakken van de dichtstbijzijnde persoon en houd ze op de grond.",
                    label = "Tackelen",
                },
                tackleMaxDistance = {
                    description = "Maximale afstand tot het doel bij het starten van een tackle.",
                    label = "Tackle-afstand",
                },
                tackleNeedsSprint = {
                    description = "Vraag de agent om te sprinten voordat hij iemand aanraakt.",
                    label = "Tackle vereist sprinten",
                },
                tackleReleaseCommand = {
                    description = "Opdracht geregistreerd voor het vrijgeven van de persoon die momenteel gehouden wordt na een tackle. Voer de commandonaam in zonder een slash.",
                    label = "Release-opdracht aanpakken",
                },
                tackleReleaseDescription = {
                    description = "Beschrijving weergegeven voor de tackle release binding in het FiveM sleutel bindingen menu.",
                    label = "Tackle release keybind beschrijving",
                },
                tackleRequireOnDuty = {
                    description = "Vereist dienststaat voordat een officier een persoon kan pakken.",
                    label = "Tackle vereist plicht",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Opdracht gebruikt om de radar layout-editor te openen of te sluiten. Voer de opdrachtnaam in zonder een slash.",
                    label = "Radaropmaakopdracht",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Opdracht gebruikt om de standaard radarindeling te herstellen. Voer de opdrachtnaam in zonder een slash.",
                    label = "Radarindelingsopdracht resetten",
                },
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
            locationDescriptions = {
                jail_public_blip = "De positie wordt automatisch overgenomen van het spawnpunt van de gevangenis, of van de eerste gevangenisterminal als er geen spawnpunt is ingesteld.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Consume manchetten heeft geen effect terwijl manchet item eis is uitgeschakeld.",
                wheelClampUseItemRequiresItem = "Klem gebruik modus Inventaris of Both vereist Klem vereist item om ingeschakeld te blijven.",
                ziptiesConsumeRequiresItem = "Consume zipties heeft geen effect terwijl ziptie item eis is uitgeschakeld.",
            },
        },
    },
    JobConfiguratorImportFailed = "Importeren van config.lua-waarden voor '%s' is mislukt: %s.",
    JobConfiguratorImportHistoryFailed = "Het importeren is gelukt, maar de geschiedenis kon niet worden opgeslagen.",
    JobConfiguratorImportNoData = "'%s' levert geen importgegevens voor config.lua.",
    JobConfiguratorImportSuccess = "Geïmporteerde config.lua waarden voor '%s': %d beroepen, %d instelling, %d functie, en %d interactie afwijkingen toegepast.",
    JobConfiguratorTitle = "Beroepsconfigurator",
    JobConfiguratorUnknown = "Onbekende beroepsconfigurator.",
}
