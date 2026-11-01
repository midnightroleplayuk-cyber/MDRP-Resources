JobConfigLocales["sky_mechanicjob:nl"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Mobiele testbankinstallatie",
                    entryPluralLabel = "Mobiele testbankinstallaties",
                    label = "Mobiele testbankinstallaties",
                },
                workshops = {
                    entryLabel = "Werkplaats",
                    entryPluralLabel = "Werkplaatsen",
                    label = "Werkplaatsen",
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
                crewCapacity = "Maximaal aantal personen dat deze eenheid kan bemannen. Gebruik 0 voor onbeperkte bemanning.",
                joinLocked = "Voorkomt dat extra personen zich aansluiten nadat de eenheid is bemand.",
                minimumCrew = "Minimaal aantal personen in de voor dit inzetvoorstel geselecteerde eenheden.",
                poiId = "Vaste technische identificatie waarnaar meldkamerprofielen ook na een naamswijziging kunnen verwijzen.",
                readyStatusCode = "FMS-status die wordt ingesteld zodra deze resource inzetgereed is.",
                resourceType = "Classificeert de operationele resource voor filters en coördinatie in de meldkamer.",
                respondingStatusCode = "FMS-status die wordt ingesteld zodra deze resource naar een incident uitrukt.",
                shortLabel = "Optioneel kort label op de zes geheugenknoppen voor radiokanalen.",
                stationId = "Koppelt deze eenheid aan een standplaats uit het meldkamerprofiel.",
                unitId = "Vaste technische identificatie waarmee de eenheid behouden blijft als de roepnaam verandert.",
                autoAlarm = "Wijst onmiddellijk overeenkomende beschikbare eenheden toe wanneer er een incident wordt gecreëerd.",
                available = "Eenheden met deze status kunnen worden voorgesteld en toegewezen aan een nieuw incident.",
                averageResponseSpeedKmh = "Berekent de weergegeven aankomstschatting op basis van een rechte lijnafstand.",
                callsign = "Unieke radioroepnaam die wordt weergegeven wanneer spelers deze virtuele eenheid bemannen.",
                centerEnabled = "Hiermee kunnen geautoriseerde dienstdoende leden een meldkamer bemannen.",
                channelId = "Radiokanaal-ID voor PMA Voice, SaltyChat en YACA. Numerieke ID's zoals 2500 blijven ongewijzigd; PMA Voice wijst tekst-ID's toe aan een stabiel getal.",
                channelLabel = "Leesbare kanaalnaam getoond aan coördinatoren en eenheden.",
                defaultChannel = "Dispatchers sluiten zich aan bij dit kanaal wanneer ze aan hun dienst beginnen. Eenheden worden handmatig lid via het tabblad Radio. Selecteer Geen om de standaard voor de taakgroep te gebruiken.",
                emergencyAppEnabled = "Maakt deze taak selecteerbaar als een openbare dienst in de Noodtelefoon-app.",
                enabled = "Maakt deze taak beschikbaar voor de Dispatch-app en cross-job-incidenten.",
                icon = "Selecteer het pictogram dat voor deze toestelcategorie wordt weergegeven in de Dispatch-app.",
                incidentAssessmentEnabled = "Toont medische en gevarenbeoordelingsvragen in de volledige incidentintake.",
                jobs = "Extra functienamen die incidenten ontvangen met dit trefwoord.",
                noUnitFallback = "Stuurt, zonder centrum of bemande eenheid, een Sky-melding naar alle dienstdoende leden.",
                radius = "Maximale afstand in meters waarop de stationsmededeling kan worden gehoord.",
                requirements = "Antwoordvraag als TYPE:COUNT-paren, bijvoorbeeld PATROL:2,CRIME:1.",
                statusCode = "Numerieke FMS-status weergegeven op de handradio.",
                statusLabel = "Betekenis van deze FMS-status voor coördinatoren en eenheden.",
                vehicleType = "Moet overeenkomen met een voertuigtypecode die in de vorige subsectie is geconfigureerd.",
                vehicleTypeCode = "Korte eenheidscode die wordt gebruikt in responsvereisten, bijvoorbeeld PATROL, CRIME, EMS of RESCUE.",
                vehicleTypeLabel = "Leesbare naam van deze toestelcategorie.",
            },
            dispatchFields = {
                crewCapacity = "Bemanningscapaciteit",
                joinLocked = "Bemanningstoegang vergrendelen",
                minimumCrew = "Minimale bemanning",
                poiId = "Vaste POI-ID",
                readyStatusCode = "Code voor gereedstatus",
                resourceType = "Resourcetype",
                respondingStatusCode = "Code voor uitrukstatus",
                shortLabel = "Label van radiogeheugen",
                stationId = "Standplaats-ID",
                unitId = "Vaste eenheids-ID",
                address = "Adres",
                autoAlarm = "Automatisch alarm",
                available = "Beschikbaar voor verzending",
                averageResponseSpeedKmh = "Geschatte reactiesnelheid (km/u)",
                callsign = "Roepnaam",
                category = "Categorie",
                centerEnabled = "Schakel centrale in",
                channelId = "Kanaal-ID",
                code = "Rubriek",
                defaultChannel = "Standaardradiokanaal",
                emergencyAppEnabled = "Weergeven in noodapp",
                enabled = "Verzending inschakelen",
                icon = "Icoon",
                incidentAssessmentEnabled = "Noodbeoordeling inschakelen",
                jobs = "Doeltaken (door komma's gescheiden)",
                keywordCode = "Trefwoordcode",
                label = "Etiket",
                name = "Naam",
                noUnitFallback = "Waarschuw het dienstdoende personeel zonder eenheden",
                noneChannel = "Geen/groep standaard",
                note = "Opmerking",
                phone = "Telefoon",
                radius = "Aankondigingsradius",
                requirements = "Vereiste eenheden (bijvoorbeeld PATROL:2,CRIME:1)",
                type = "Typen",
                vehicleType = "Type responseenheid",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Bekende melders",
                    channels = "Radiokanalen",
                    plans = "Inzetplannen",
                    statuses = "Beschikbare FMS-statussen",
                    units = "Virtuele eenheden",
                },
                active = "Meldkamer actief",
                description = "Configureer voor deze baan de noodoproepinname, radio, eenheden, inzetplannen, locaties en meldergegevens.",
                inactive = "Meldkamer uitgeschakeld",
                steps = {
                    accessText = "Schakel de meldkamer in en bepaal of medewerkers van deze baan de meldkamer mogen bemannen.",
                    accessTitle = "Toegang en meldinginname",
                    fleetText = "Configureer kanalen, FMS-statuscodes, voertuigtypen en roepnamen.",
                    fleetTitle = "Radio en wagenpark",
                    responseText = "Rond de inrichting af met trefwoorden, inzetvereisten en interessante locaties.",
                    responseTitle = "Inzetplannen",
                },
                title = "Meldkamer",
                warnings = {
                    channels = "Er zijn geen eigen radiokanalen; het reservekanaal van de beroepsgroep wordt gebruikt.",
                    defaultChannel = "Het gekozen standaardkanaal bestaat niet meer.",
                    disabled = "De meldkamer is voor deze baan uitgeschakeld.",
                    statuses = "Er moet minstens één FMS-status beschikbaar zijn voordat eenheden kunnen worden gealarmeerd.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Beheert meldersnamen, terugbelnummers en meldkamernotities voor deze functie.",
                dispatchChannels = "Definieert de radiokanalen waar eenheden en bemande meldkamers zich bij kunnen aansluiten.",
                dispatchKeywords = "Definieert trefwoorden voor incidenten, vereiste voertuigtellingen, deelnemende taken en optionele automatische alarmering.",
                dispatchPois = "Slaat stations en algemene locaties op voor incidentformulieren en positiegebaseerde stationsaankondigingen.",
                dispatchStatusCodes = "Configureert FMS-statuslabels en welke statussen gelden als beschikbaar voor nieuwe incidenten.",
                dispatchVehicleTypes = "Definieert de eenheidscategorieën die worden gebruikt door responsplannen, zoals Patrouille, Crime Unit, EMS of Rescue.",
                dispatchVehicles = "Definieert virtuele expeditievoertuigen die overal kunnen worden bemand zonder dat een voortgebracht voertuig nodig is.",
            },
            diagnosticsSettings = {
                enabledLabel = "Voertuigdiagnose inschakelen",
                enabledDescription = "Sta deze job toe voertuigdiagnose te openen en daarmee onderdelen te repareren.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Voertuigdiagnose",
                    description = "Stel de toegang van deze job tot voertuigdiagnose in.",
                },
                dispatchReporters = "Bekende melders",
                invalidSelection = "Ongeldige selectie: {value}",
                billingPrices = {
                    description = "Configureer factuurprijzen voor onderhoud en reparatie geschiedenis. De actie sleutel is afgestemd op action_key, action_type, of het werk label.",
                    label = "Factureringsredenen",
                },
                billingSettings = {
                    description = "Configureren van mechanische facturering gedrag voor dit beroep.",
                    label = "Facturering",
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
                partsDeliveryShop = "Onderdelenlevering winkel",
                trainingSettings = {
                    description = "Configureer trainingstoegang, inschrijving, goedkeuringen en cursusplanning voor deze taak.",
                    label = "Trainingsinstellingen",
                },
                tuningCostProfile = {
                    description = "Configureer kosten voor performance, uiterlijk, wielen en speciale opties voor deze job.",
                    label = "Tuningprijzen",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Vrije camera in het tuningmenu",
                    description = "Sta toe dat Spatie de cursor verbergt om de camera vrij te bewegen. Escape sluit het menu nog steeds.",
                },
                tuningCamera = {
                    description = "Richt de camera automatisch op het geselecteerde onderdeel. Uitgeschakeld blijft de normale spelcamera actief.",
                    label = "Automatische tuningcamera",
                },
                jgMileage = {
                    description = "JG Vehicle Mileage gebruiken zolang de resource draait. Anders de Sky-kilometerstand gebruiken. JG HUD wordt apart ingesteld.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "De geselecteerde kilometerstand in JG HUD tonen. Werkt zonder JG Vehicle Mileage; installeer de HUD-adapter volgens de README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Schakel de beheereditor en automatische regels voor kentekens en voertuigmodellen in. Haal betrokken voertuigen na uitschakeling opnieuw uit de garage om al toegepaste waarden te herstellen.",
                    label = "Handlingeditor",
                },
                kuv = {
                    description = "Technische keuring starten",
                    label = "Technische voertuigkeuring",
                },
                mobileDyno = {
                    description = "Schakel de mobiele testbank, bedienings- en resultatenschermen, ventilatorregelaar en tablet-app in.",
                    label = "Mobiele testbank",
                },
                vehicleRegistration = {
                    description = "Voertuig registreren / overschrijven",
                    label = "Voertuigregistratie",
                },
                antiLag = {
                    description = "Activeer anti-lag installatie en uitlaateffecten.",
                    label = "Antilaag",
                },
                brakeOverheating = {
                    description = "Activeer gefaseerde remwarmte, gloeiende schijven, kritische vonken en korte remfade.",
                    label = "Oververhitting rem",
                },
                carryItems = {
                    description = "Vereis dat geleverde onderdelen door de werkplaats worden vervoerd.",
                    label = "Fysieke onderdelenafhandeling",
                },
                customHandling = {
                    description = "Activeer aangepaste aandrijving en handling tuning.",
                    label = "Aangepaste verwerking",
                },
                electronicTuning = {
                    description = "Activeer persistente ECU, verlichting en driver-assistance tuning opties.",
                    label = "Elektronische afstelling",
                },
                instantTuning = {
                    description = "Laat directe afstemming toe op geconfigureerde publieke stemlocaties.",
                    label = "Direct tunen",
                },
                mileageHud = {
                    description = "Toon kilometerinformatie tijdens het rijden.",
                    label = "Kilometer-HUD",
                },
                nitro = {
                    description = "Activeer nitro installatie en voertuig boost gebruik.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Schakel werkplaatsbestellingen en leverzones in.",
                    label = "Onderdelenlevering",
                },
                selfServiceOrderNotifications = {
                    description = "Licht medewerkers in wanneer er een zelfbedieningsopdracht wordt gemaakt.",
                    label = "Selfservicebestellingsmeldingen",
                },
                stance = {
                    description = "Toon standaanpassingen in alle afstemmenu's en schakel het Stance Kit-item in.",
                    label = "Stand",
                },
                stanceWheelSize = {
                    description = "Tonen, opslaan en toepassen van wielgrootte aanpassingen in Stance.",
                    label = "Hoogte van het wiel",
                },
                stanceWheelWidth = {
                    description = "Weergeven, opslaan en toepassen van wielbreedte-aanpassingen in stand.",
                    label = "Hoogte Wielbreedte",
                },
                subscriptions = {
                    description = "Activeer workshop abonnement terminals, management en klantenkortingen.",
                    label = "Werkplaatsabonnementen",
                },
                twoStep = {
                    description = "Activeer tweetraps lanceerregeling en uitlaateffecten.",
                    label = "Tweetraps",
                },
                vehicleMaintenanceNotifications = {
                    description = "Licht eigenaren in wanneer hun voertuig de ingestelde onderhoudsdrempel bereikt.",
                    label = "Kennisgevingen betreffende het onderhoud van voertuigen",
                },
                wheelDamage = {
                    description = "Schakel realistische wielschade en reparaties in.",
                    label = "Wielschade",
                },
                workshopLift = {
                    description = "Schakel bruikbare brugpunten in werkplaatsen in.",
                    label = "Werkplaatsbrug",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Plaats het punt op de keuringsplek van de werkplaats. Het voertuig moet binnen de ingestelde keuringsafstand staan voor de technische keuring en registratie.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Positie van de resultatenmonitor.",
                    label = "Resultatenmonitor",
                },
                mobile_dyno_station = {
                    description = "Positie van de mobiele testbank.",
                    label = "Mobiele testbank",
                },
                vehicle_registry = "Keurings- en registratiepunt",
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
            settingGroups = {
                diagnostics = {
                    label = "Diagnostiek",
                },
                keybinds = {
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                    label = "Toetsen",
                },
                safety = {
                    label = "Validatie en veiligheid",
                },
                antiExploit = {
                    label = "Anti-exploit",
                },
                coach = {
                    label = "Telemetrie Coach",
                },
                cooldownMultipliers = {
                    label = "Afkoelingsfactoren",
                },
                crashFalloff = {
                    label = "Afname van botsingsschade",
                },
                criticalEngine = {
                    label = "Gebroken motor",
                },
                deformation = {
                    label = "Vervorming",
                },
                fade = {
                    label = "Verminderde remwerking door hitte",
                },
                features = {
                    label = "Functies",
                },
                format = {
                    label = "Formaat",
                },
                frontalImpact = {
                    label = "Ernstige frontimpact",
                },
                general = {
                    label = "Algemeen",
                },
                heatMultipliers = {
                    label = "Opwarmingsfactoren",
                },
                illegalMarket = {
                    label = "Illegale markt",
                },
                integration = {
                    label = "Integratie",
                },
                items = {
                    label = "Voorwerpen",
                },
                lifetime = {
                    label = "Levensduur",
                },
                limits = {
                    label = "Opslaggrenzen",
                },
                repairRestore = {
                    label = "Reparatie herstellen",
                },
                risk = {
                    label = "Risico",
                },
                rules = {
                    label = "Regels",
                },
                stages = {
                    label = "Oververhittingsfasen",
                },
                tyreRepair = {
                    label = "Reparatie van banden",
                },
                visuals = {
                    label = "Visuele effecten",
                },
            },
            settingSections = {
                electronicTuning = "ECU-motorsoftware",
                handlingEditor = "Rijgedrag-editor",
                mobileDyno = "Mobiele testbank",
                vehicleRegistry = "Voertuigdocumenten",
                advancedPricing = "Geavanceerde prijzen",
                brakeOverheating = "Oververhitting rem",
                carryItems = "Carry items",
                fakePlates = "Valse platen",
                firejobVehicleFires = "Voertuigbranden",
                general = "Algemeen",
                instantTuning = "Direct tunen",
                maintenanceNotifications = "Aanmeldingen voor onderhoud",
                mileageHud = "Kilometer-HUD",
                oilLeaks = "Vloeistoflekken van voertuigen",
                partsTheft = "Onderdelendiefstal",
                subscriptions = "Abonnementen",
                tuning = "Tuning",
                vehicleCare = "Onderhoud van voertuigen",
                wear = "Slijtage",
                wheelDamage = "Wielschade",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Overig",
                handlingAir = "Lucht",
                handlingGeneral = "Algemeen",
                handlingRoad = "Weg",
                handlingWater = "Water",
            },
            settingSubsections = {
                mechanicHotkeys = "Toetsen",
                database = "Database",
                handlingEditorGeneral = "Editorinstellingen",
                handlingMaximumCBikeHandlingData = "Motorfiets",
                handlingMaximumCBoatHandlingData = "Boot",
                handlingMaximumCCarHandlingData = "Auto",
                handlingMaximumCFlyingHandlingData = "Vliegtuig",
                handlingMaximumCHandlingData = "Voertuigbasis",
                handlingMaximumCSeaPlaneHandlingData = "Watervliegtuig",
                handlingMaximumCSpecialFlightHandlingData = "Speciale vlucht",
                handlingMaximumCSubmarineHandlingData = "Onderzeeër",
                handlingMaximumCTrailerHandlingData = "Aanhanger",
                handlingMaximumCVehicleWeaponHandlingData = "Voertuigwapens",
                keybinds = "Toetsen",
                operation = "Bediening",
                placementRules = "Plaatsingsregels",
                testFlow = "Testverloop",
                tuning = "Opties voor direct tunen",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Voertuigreparatie",
                    description = "Bied reparaties aan bij locaties voor directe tuning.",
                },
                instantTuningRepairPrice = {
                    label = "Reparatieprijs",
                    description = "Vaste reparatieprijs zonder de prijsfactor voor tuning.",
                },
                instantTuningWashEnabled = {
                    label = "Voertuig wassen",
                    description = "Bied wasbeurten aan bij locaties voor directe tuning.",
                },
                instantTuningWashPrice = {
                    label = "Wasprijs",
                    description = "Vaste wasprijs zonder de prijsfactor voor tuning.",
                },
                vehiclePriceSource = {
                    label = "Bron van voertuigprijzen",
                    description = "Automatisch: SQL bij ESX; voertuigcatalogus bij QBCore/Qbox. Database: ingestelde SQL-tabel bij elk framework.",
                    options = {
                        auto = "Automatisch (framework)",
                        database = "Database",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabel voor voertuigprijzen",
                    description = "Tabel met aankoopprijzen, bijvoorbeeld dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Kolom voor spawnnamen",
                    description = "Kolom met spawnnamen, bijvoorbeeld spawn_code (JG), niet de weergavenaam.",
                },
                vehiclePricePriceColumn = {
                    label = "Prijskolom",
                    description = "Kolom met numerieke aankoopprijzen, bijvoorbeeld price.",
                },
                vehiclePriceHashColumn = {
                    label = "Kolom voor modelhash (optioneel)",
                    description = "Optionele numerieke hashkolom, bijvoorbeeld hashkey (JG). Laat leeg om hashes uit spawnnamen te berekenen.",
                },
                handlingEditorFieldMaximum = {
                    description = "Harde maximumwaarde die de editor voor dit rijgedragveld accepteert.",
                },
                handlingEditorFocusKey = {
                    label = "Terug naar handling-editor",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Aantal gecodeerde bytes waarna een editorverzoek, antwoord of momentopname als groot wordt gemeld.",
                    label = "Drempel voor grote payloads",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Meet editorbewerkingen en waarschuwt via Sky.Debug wanneer ingestelde limieten worden overschreden.",
                    label = "Prestatiecontroles",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Aantal milliseconden tussen samengevoegde prestatieoverzichten wanneer uitgebreide debugregistratie actief is.",
                    label = "Samenvattingsinterval",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Aantal milliseconden waarna een editorbewerking als traag wordt gemeld.",
                    label = "Drempel voor trage bewerkingen",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Het maximale percentage waarmee een numerieke schuifregelaar boven of onder de ingelezen voertuigbasis mag bewegen. Directe invoer en XML-import blijven verliesvrij. Een veldmaximum dat afwijkt van de standaard vervangt de bovengrens van de schuifregelaar.",
                    label = "Maximale schuifafwijking",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Katalysatordiefstal · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Katalysatordiefstal · Besturing 73",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl172 = {
                    label = "Vermogensbank · Besturing 172",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl173 = {
                    label = "Vermogensbank · Besturing 173",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl174 = {
                    label = "Vermogensbank · Besturing 174",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl175 = {
                    label = "Vermogensbank · Besturing 175",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl177 = {
                    label = "Vermogensbank · Besturing 177",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl38 = {
                    label = "Vermogensbank · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl45 = {
                    label = "Vermogensbank · Besturing 45",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicDynoControl47 = {
                    label = "Vermogensbank · Besturing 47",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Spuiten · Besturing 200",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Spuiten · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Voertuigonderhoud · Besturing 200",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Voertuigonderhoud · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Voertuig duwen · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Voertuig duwen · Besturing 33",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Voertuig duwen · Besturing 34",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Voertuig duwen · Besturing 35",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Voertuig duwen · Besturing 32",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Voertuig duwen · Besturing 21",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Wielwissel · Besturing 200",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Wielwissel · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Wielwissel · Besturing 22",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Wieldiefstal · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Wieldiefstal · Besturing 73",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                mobileDynoConsumeItem = {
                    description = "Verwijder één voorwerp na een geslaagde plaatsing.",
                    label = "Voorwerp verbruiken",
                },
                mobileDynoCooldownMs = {
                    label = "Afkoelduur",
                },
                mobileDynoCountdownMs = {
                    label = "Startaftelling",
                },
                mobileDynoDuiDistance = {
                    label = "Renderafstand paneel",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Afstand ventilatorregelaar",
                    description = "Afstand in meter voor het gebruik van de fysieke schakelaar tussen de koelventilatoren.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Duur volledige belasting",
                    description = "Milliseconden besteed aan aanhoudende volledige belasting in profielen die een volledige laadfase omvatten.",
                },
                mobileDynoHistoryLimit = {
                    label = "Geschiedenislimiet",
                },
                mobileDynoInteractionDistance = {
                    label = "Interactieafstand paneel",
                },
                mobileDynoItemUseEnabled = {
                    description = "Sta plaatsing van dyno en monitor toe door voorwerpen te gebruiken.",
                    label = "Plaatsing met voorwerp",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limiet actieve sessies",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Voertuigdetectieafstand",
                },
                mobileDynoMonitorItem = {
                    description = "Inventarisvoorwerp waarmee een resultatenmonitor wordt geplaatst.",
                    label = "Monitorvoorwerp",
                },
                mobileDynoPersistItems = {
                    description = "Bewaar nieuwe plaatsingen na een herstart van de server.",
                    label = "Plaatsingen opslaan",
                },
                mobileDynoPickupDistance = {
                    description = "Maximale afstand in meters om apparatuur op te pakken.",
                    label = "Oppakafstand",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Maximaal hoogteverschil",
                    description = "Maximale grondhoogte variatie in meters geaccepteerd over alle Dyno voetafdruk sondes.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Maximale plaatsingshelling",
                    description = "Maximale grondhelling in graden geaccepteerd over de dyno voetafdruk.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Monteurs moeten in dienst zijn om apparatuur te plaatsen en te bedienen.",
                    label = "Dienst verplicht",
                },
                mobileDynoResultDuiDistance = {
                    label = "Renderafstand resultatenscherm",
                    description = "Maximale afstand in meter waarop de afzonderlijke resultaatmonitor wordt weergegeven.",
                },
                mobileDynoReturnItem = {
                    description = "Geef het verbruikte voorwerp terug bij het oppakken van de apparatuur.",
                    label = "Voorwerp teruggeven",
                },
                mobileDynoStationItem = {
                    description = "Inventarisvoorwerp waarmee een dyno wordt geplaatst.",
                    label = "Dynovoorwerp",
                },
                mobileDynoTabletDistance = {
                    description = "Maximale afstand van de dyno in meters voor tabletbediening en actieve tests.",
                    label = "Tabletbereik",
                },
                nitroActivationKey = {
                    label = "Nitro ingedrukt houden",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                registryBikeChecks = {
                    description = "Keuringspunten voor motoren",
                    label = "Keuringspunten voor motoren",
                },
                registryCarChecks = {
                    description = "Keuringspunten voor auto's",
                    label = "Keuringspunten voor auto's",
                },
                registryDistance = {
                    description = "Serviceafstand (meter)",
                    label = "Serviceafstand (meter)",
                },
                registryKuvFee = {
                    description = "Technische voertuigkeuring-kosten",
                    label = "Technische voertuigkeuring-kosten",
                },
                registryKuvValidityDays = {
                    description = "Geldigheid van nieuwe keuringen in echte tijd. Standaard: 30 dagen. Bestaande vervaldata blijven behouden.",
                    label = "Geldigheid keuring (werkelijke dagen)",
                },
                registryKuvWarningDays = {
                    description = "Waarschuwingstermijn (dagen)",
                    label = "Waarschuwingstermijn (dagen)",
                },
                registryRegistrationFee = {
                    description = "Registratiekosten",
                    label = "Registratiekosten",
                },
                registryReinspectionFee = {
                    description = "Herkeuringskosten",
                    label = "Herkeuringskosten",
                },
                registryRequireKuv = {
                    description = "Geldige Technische voertuigkeuring eisen bij registratie",
                    label = "Geldige Technische voertuigkeuring eisen bij registratie",
                },
                registrySessionSeconds = {
                    description = "Bevestigingstermijn (seconden)",
                    label = "Bevestigingstermijn (seconden)",
                },
                registryTransferFee = {
                    description = "Overschrijvingskosten",
                    label = "Overschrijvingskosten",
                },
                registryVehicleTypes = {
                    description = "Toegestane voertuigtypen",
                    label = "Toegestane voertuigtypen",
                },
                tuningFocusKey = {
                    label = "Muisbediening van tuning",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                addRevenueToSociety = {
                    description = "Deposit betaalde tuning order geld op de tuning professional society rekening.",
                    label = "Deposit inkomsten aan de samenleving",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Onderdelen levering winkel categorieën die vrij inkoopbaar blijven terwijl geavanceerde prijzen is ingeschakeld. Matching negeert behuizing en whitespace.",
                    itemLabel = "Categorie",
                    label = "Altijd beschikbare categorieën",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Houd geconfigureerde winkel items uit de geselecteerde categorieën beschikbaar zonder een tuning order en prijs ze via het dynamische leverancier systeem.",
                    label = "Altijd beschikbare winkelartikelen",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Aantal dagen weergegeven in de analyse van de winst van de tablet.",
                    label = "Analyseperiode",
                },
                advancedPricingCategoryRules = {
                    description = "Aandeel van de leverancier, marge, arbeids- en prijsgrenzen per tuningcategorie.",
                    label = "Categorievoorschriften",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Standaard mechanische marge voor klasse- en rangaanpassingen.",
                    label = "Standaardmarge",
                },
                advancedPricingDifficultyRules = {
                    description = "Extra arbeidskosten voor elke aanpassing moeilijkheid.",
                    label = "Moeilijkheidsregels",
                },
                advancedPricingEnabled = {
                    description = "Bereken de afstemprijzen op de server en, wanneer Parts Delivery is ingeschakeld, vereisen Dynasty onderdelen te kopen voor hun specifieke afstemorder.",
                    label = "Activeer geavanceerde prijzen",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normale virtuele voorraad voor elk leverancier item.",
                    label = "Basisvoorraad",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Vraagpunten verwijderd per verstreken dag.",
                    label = "Verval van de dagelijkse vraag",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Leverancier markup toegevoegd voor elk vraagpunt.",
                    label = "Opname van de vraag per eenheid",
                },
                advancedPricingInventoryEnabled = {
                    description = "Verhoog de leveranciersprijzen wanneer de virtuele voorraad laag is of de vraag hoog is.",
                    label = "Dynamische leveranciersvoorraad",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maximale leveranciersmarkering veroorzaakt door een lage voorraad.",
                    label = "Toeslag bij lage voorraad",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Voorraadniveau waaronder schaarsteprijzen beginnen.",
                    label = "Drempelwaarde voor een laag bestand",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Bovengrens voor de opslag.",
                    label = "Maximale verbruiksaanduiding",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtuele eenheden aangevuld per verstreken dag.",
                    label = "Dagelijkse hervoorraad",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globale kortingsplafond voor mechanische facturen.",
                    label = "Maximale korting",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Hoogste toegestane mechanische marge.",
                    label = "Maximummarge",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Wereldwijde prijsgrens voor een tuning-onderdeel.",
                    label = "Maximale kleinhandelsprijs",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Opmaak, arbeid en korting grenzen door mechanische kwaliteit.",
                    label = "Mechanische rangregels",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Laagste toegestane mechanische marge.",
                    label = "Minimummarge",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Wereldwijde lagere prijsgrens voor een stemgedeelte.",
                    label = "Minimale kleinhandelsprijs",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Voertuigwaarde gebruikt voor het compacte voorbeeld.",
                    label = "Compacte voorbeeldwaarde",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Voorbeeld tuning kosten percentage gebruikt door de live preview.",
                    label = "Snelheid van tuningvoorbeeld",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Voertuigwaarde gebruikt voor het sportvoorbeeld.",
                    label = "Sportvoorbeeldwaarde",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Voertuigwaarde gebruikt voor het supercar voorbeeld.",
                    label = "Supervoorbeeldwaarde",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuten voordat een onbetaalde prijsnotering wordt herberekend.",
                    label = "Levensduur van de offerte",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Percentage terugbetaald voor een aangeschaft ordergebonden deel.",
                    label = "Teruggave",
                },
                advancedPricingRoundingStep = {
                    description = "Rond elke Dynasty inkooplijn om dit geld stap.",
                    label = "Afrondingsstap van leverancier",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Percentage van de klant deelprijs in rekening gebracht door Dynasty Auto Supply.",
                    label = "Aandeel van leverancier",
                },
                advancedPricingTaxPercent = {
                    description = "Belastingpercentage dat afzonderlijk wordt opgeslagen in de prijsstellingsboekhouding.",
                    label = "Belasting",
                },
                advancedPricingVehicleClassRules = {
                    description = "Marge- en arbeidsaanpassingen per GTA voertuigklasse.",
                    label = "Voorschriften voor voertuigklasse",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Brake upgrade koeldown multipliers",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Afkoelingsfactoren per voertuigklasse",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Vertraging in milliseconden na remmen voordat de actieve koeling begint.",
                    label = "Koelvertraging",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Warmte verwijderd per seconde terwijl de rem niet wordt gebruikt.",
                    label = "Afkoelsnelheid",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Warmteniveau waarbij vonken en korte remmen kunnen beginnen.",
                    label = "Kritische drempel",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Kans van 0 tot 1 voor een korte remuitschakeling tijdens het remmen bij kritische hitte.",
                    label = "Vervagen kans per seconde",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Afkoelen vervagen",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maximale vervagingsduur",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minimale vervagingsduur",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Remopwaardering warmtevermenigvuldigers",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Warmtevermenigvuldigers van voertuigklasse",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Basiswarmte gewonnen per seconde tijdens het remmen bij referentiesnelheid.",
                    label = "Warmteaanwas",
                },
                brakeOverheatingHotThreshold = {
                    label = "Warme drempel",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Minimumsnelheid van het voertuig in km/h voordat het remmen warmte veroorzaakt.",
                    label = "Minimumremsnelheid",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Snelheid in km/h waarbij de geconfigureerde basiswarmtewinst wordt toegepast.",
                    label = "Referentiesnelheid",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maximale vonkinterval",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minimum vonkinterval",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximale afstand in meter voor gloed en vonkweergave.",
                    label = "Visuele afstand",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Warmdrempel",
                },
                carryItems = {
                    description = "Geleverd onderdelen die fysiek gedragen rekwisieten moeten worden.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Motortakel",
                                forklift = "Heftruck",
                                hand = "Hand",
                            },
                        },
                    },
                    itemLabel = "Voorwerp voor dragen",
                    label = "Voorwerpen voor dragen",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 voegt geen extra vermogen toe; 1,10 verhoogt het koppel met 10%. Geldt voor voertuigen met dit ECU-niveau.",
                    label = "Koppelvermenigvuldiger niveau 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 voegt geen extra vermogen toe; 1,10 verhoogt het koppel met 10%. Geldt voor voertuigen met dit ECU-niveau.",
                    label = "Koppelvermenigvuldiger niveau 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 voegt geen extra vermogen toe; 1,10 verhoogt het koppel met 10%. Geldt voor voertuigen met dit ECU-niveau.",
                    label = "Koppelvermenigvuldiger niveau 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 voegt geen extra vermogen toe; 1,10 verhoogt het koppel met 10%. Geldt voor voertuigen met dit ECU-niveau.",
                    label = "Koppelvermenigvuldiger niveau 4",
                },
                fakePlatesAudit = {
                    label = "Auditlog",
                },
                fakePlatesBlacklist = {
                    description = "Geblokkeerde woorden of fragmenten die niet in valse platen kunnen verschijnen.",
                    label = "Zwarte lijst",
                },
                fakePlatesBlankPlateItem = {
                    description = "Ambacht / winkel materiaal gebruikt voor nep plaat economie loops.",
                    label = "Lege plaat-item",
                },
                fakePlatesCooldownMinutes = {
                    label = "Afkoeltijd (minuten)",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Falloff kans",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Crash falloff ingeschakeld",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minimale crashsnelheid",
                },
                fakePlatesEnabled = {
                    description = "Laat spelers om nepplaat kits te gebruiken op voertuigen.",
                    label = "Activeer valse platen",
                },
                fakePlatesExpireMinutes = {
                    description = "0 houdt nepplaten actief totdat reset of herstart behandeling hen verwijdert.",
                    label = "Verlopen minuten",
                },
                fakePlatesExpireOnRestart = {
                    label = "Verlopen bij herstart",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Betaalrekening",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Illegale markt ingeschakeld",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Illegale marktprijs",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Risico-multiplier",
                },
                fakePlatesInstallDurationMs = {
                    label = "Duur ms installeren",
                },
                fakePlatesItem = {
                    description = "One-use item dat start met de nep plaat installatie flow.",
                    label = "Valse plaatset-item",
                },
                fakePlatesMaxLength = {
                    label = "Maximale lengte",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Voertuigafstand",
                },
                fakePlatesMinLength = {
                    label = "Minimale lengte",
                },
                fakePlatesPattern = {
                    description = "Lua patroon gebruikt om valse plaat tekst te valideren, bijvoorbeeld ^[A-Z0-9]+$.",
                    label = "Lua-patroon",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Afstand van de plaat",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Blokkeer dubbele actieve valse platen",
                },
                fakePlatesPrinterItem = {
                    description = "Craft / winkel tool gebruikt voor nep plaat economie loops.",
                    label = "Plaatprinteritem",
                },
                fakePlatesRequireEngineOff = {
                    label = "Motor moet uit staan",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Gebruik Config.Functions.CanApplyFakePlate alvorens installatie toe te staan.",
                    label = "Eigenaar of sleutels nodig",
                },
                fakePlatesRequireStopped = {
                    label = "Het voertuig moet worden gestopt",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Gereserveerd voor garage-integraties die de reset event/export bellen.",
                    label = "Reset op garagewinkel",
                },
                fakePlatesRiskCharacters = {
                    label = "Typotekens",
                },
                fakePlatesRiskEnabled = {
                    label = "Risico-typefouten ingeschakeld",
                },
                fakePlatesRiskTypoChance = {
                    label = "Typo-kans",
                },
                fallbackVehicleValue = {
                    description = "Waarde die wordt gebruikt wanneer geen voertuigprijs kan worden opgelost.",
                    label = "Waarde van het terugvalvoertuig",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Kans van 0 tot 1 nadat de motor kritiek blijft.",
                    label = "Kritieke kans op een motorbrand",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Seconden voordat een ander kapotte motorbrand kan activeren.",
                    label = "Kritieke motorkoeling",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Vertraging in milliseconden voordat een kapotte motor kan ontbranden.",
                    label = "Kritische vertraging van de motor ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Sta kritisch beschadigde motoren toe om na een vertraging een brand van een Firejob voertuig te starten.",
                    label = "Onbelaste motoren",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Rookdichtheid gebruikt voor noodbrandverzoeken.",
                    label = "Kritische motorrookdichtheid",
                },
                firejobVehicleFiresEnabled = {
                    description = "Sta Mechanic job schade systemen toe om autobranden te vragen bij Firejob.",
                    label = "Branden van brandweervoertuigen activeren",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Vereiste voorwaartse verplaatsingsverhouding van 0 tot 1.",
                    label = "Voorwaartse bewegingsverhouding",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Kans van 0 tot 1 dat een kwalificerende inslag een brand veroorzaakt.",
                    label = "Impact vuurkans",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Seconden voordat een andere inslag kan activeren.",
                    label = "Afkoeling van de impactbrand",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Sta sterke frontale ongevallen toe om een brandweerwagen brand te vragen.",
                    label = "Ignite na ernstige crashes",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Rookdichtheid gebruikt voor gecrashte brandverzoeken.",
                    label = "Inslagrookdichtheid",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatisch gebruikt de geconfigureerde Firejob resource; Uitgeschakeld voorkomt Mechanicjob het creëren van branden.",
                    label = "Integratiemodus",
                    options = {
                        automatic = "Automatisch",
                        disabled = "Uitgeschakeld",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimale gezondheid van het lichaam verloren tijdens de impact.",
                    label = "Minimale schade aan het lichaam",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimale motor gezondheid verloren tijdens de botsing.",
                    label = "Minimale motorschade",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Gebruik 0 om deze vervormingscontrole uit te schakelen.",
                    label = "Minimale vervorming van de voorzijde",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimumsnelheid vóór de botsing in km/h.",
                    label = "Minimum botssnelheid",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Vereist snelheidsverlies in km/h tijdens de botsing.",
                    label = "Minimumsnelheidsverlies",
                },
                firejobVehicleFiresResource = {
                    description = "Hulpbron die verzoeken om voertuigbrand ontvangt.",
                    label = "Hulpbron voor vuurwerk",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Interne server evenement gebruikt door de monteur client om een Firejob voertuig brand te vragen.",
                    label = "Mechanische server-gebeurtenis",
                },
                freeVehicles = {
                    description = "Vehicle paaimodellen die gratis stemmen orders ontvangen.",
                    itemLabel = "Voertuigmodel",
                    label = "Gratis afstemvoertuigen",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Voorkomen Toepassen terwijl er een kritische behandeling conflict bestaat.",
                    label = "Blokkerende kritische bevindingen",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Verwacht maximale vertraging in m/s2 voor een voltooide remtest.",
                    label = "Minimale remvertraging",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Gemeten monsters vereist voordat Telemetrie Coach een run evalueert.",
                    label = "Minimummonsters",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Gemeten wielslipsnelheid in km/h waarbij tractieverlies wordt gerapporteerd.",
                    label = "Waarschuwing voor wielslip",
                },
                handlingEditorDefaultTab = {
                    description = "Pagina geselecteerd wanneer de standalone Handling Editor wordt geopend.",
                    label = "Startpagina",
                    options = {
                        advanced = "Geavanceerd",
                        export = "Exporteren",
                        flags = "Vlaggen",
                        fleet = "Vloot",
                        inspector = "Lagen",
                        profiles = "Profielen",
                        simple = "Eenvoudig",
                        telemetry = "Telemetrie",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Zorg voor effect, referentiebereik, symptomen, gerelateerde velden en live ondersteuning voor elke handling waarde.",
                    label = "Velddocumentatie",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Zoek en filter vlag namen, effecten, bit posities en hexadecimale maskers.",
                    label = "Vlag zoekopdracht",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Zoeken, inspecteren, bevorderen en herstellen van model- en plaatverwerkingsregels.",
                    label = "Vlootbeheerder",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Toon de voertuigbasis, geïnstalleerde aangepaste tuning, modelregel, plaatregel en huidige editor ontwerp voor elk veld.",
                    label = "Laaginspecteur",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maximale model- en plaatregels geladen in Fleet Manager.",
                    label = "Vlootresultaatlimiet",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maximum aantal herzieningen behouden voor elk profiel.",
                    label = "Profielherzieningen",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maximale benoemde werkruimtes behouden voor elke beheerder.",
                    label = "Persoonlijke werkruimten",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Maak een auditable revisie wanneer een gedeeld profiel wordt bijgewerkt of hersteld.",
                    label = "Profielversie",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Maak transparante op regels gebaseerde aanbevelingen op basis van gemeten wegtestgegevens.",
                    label = "Telemetrie Coach",
                },
                handlingEditorValidatorEnabled = {
                    description = "Detecteer onveilige of tegenstrijdige combinaties voordat de behandeling wordt toegepast.",
                    label = "Validator voor verwerking",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Sta beheerders toe om de naam private editor concepts te behouden.",
                    label = "Persoonlijke werkruimten",
                },
                instantTuningAllowedJobs = {
                    description = "Optionele globale allow-list. Laat leeg om iedereen toe te staan tenzij monteur-alleen is ingeschakeld.",
                    itemLabel = "Jobnaam",
                    label = "Toegestane banen",
                },
                instantTuningBlipColor = {
                    description = "GTA blip kleur id.",
                    label = "Vervagingskleur",
                },
                instantTuningBlipEnabled = {
                    description = "Toon kaartblips voor directe afstemlocaties.",
                    label = "Blip ingeschakeld",
                },
                instantTuningBlipName = {
                    description = "De naam van het kaartje.",
                    label = "Bleeknaam",
                },
                instantTuningBlipSprite = {
                    description = "ID van het pictogram voor de GTA-kaartmarkering.",
                    label = "Pictogram van kaartmarkering",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Gebruik marker-stijl E-interactie, zelfs wanneer doelondersteuning is ingeschakeld.",
                    label = "Krachtmarkeringsinteractie",
                },
                instantTuningInteractionDistance = {
                    description = "Standaardafstand voor het gebruik van instant tuning-punten.",
                    label = "Interactieafstand",
                },
                instantTuningLabel = {
                    description = "Standaard tekst getoond op instant tuning punten.",
                    label = "Standaard label",
                },
                instantTuningLocations = {
                    description = "Instant tuning points. Gebruik 0 afstand om de standaard interactie afstand te erven.",
                    itemLabel = "Locaties",
                    label = "Locaties",
                },
                instantTuningMarkerEnabled = {
                    description = "Teken een wereld marker op directe tuning locaties.",
                    label = "Markering ingeschakeld",
                },
                instantTuningMarkerType = {
                    description = "GTA marker type gebruikt voor directe afstemlocaties.",
                    label = "Markertype",
                },
                instantTuningMechanicOnly = {
                    description = "Beperk alle instant tuning locaties tot geconfigureerde mechanische beroepen.",
                    label = "Alleen mechanisch",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplier toegepast op instant tuning prijzen.",
                    label = "Prijsvermenigvuldiger",
                },
                instantTuningProfile = {
                    description = "Configureer welke stemopties beschikbaar zijn op instant tuning punten.",
                    label = "Instant Tuning-opties",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimum minuten voordat hetzelfde voertuig kan leiden tot een andere onderhoudsherinnering.",
                    label = "Afkoelen van aanmelding",
                },
                maintenanceNotificationsEnabled = {
                    description = "Waarschuw voertuigeigenaren wanneer een slijtagedeel de onderhoudsdrempel bereikt.",
                    label = "Ingeschakeld",
                },
                maintenanceNotificationsThreshold = {
                    description = "Draag percentage of lager waarop onderhoud verschuldigd wordt geacht.",
                    label = "Tier 1-kernkapitaal",
                },
                mileageHudDigits = {
                    description = "Aantal cijfers in de kilometerstand HUD.",
                    label = "Digits",
                },
                mileageHudPosition = {
                    description = "Sleep de kilometerstand HUD preview naar de gewenste schermpositie.",
                    label = "Positie",
                },
                oilLeaksCooldownSeconds = {
                    description = "Seconden voordat een lek kan activeren.",
                    label = "Afkoelen van de impact",
                },
                oilLeaksEnabled = {
                    description = "Laat beschadigde verbrandingsvoertuigen vocht achterlaten tijdens het rijden.",
                    label = "Activeer vloeistoflekken",
                },
                oilLeaksEngineOilChance = {
                    description = "Normale lekkans van 0 tot 1.",
                    label = "Kans op motorolie",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kritische lekkans van 0 tot 1.",
                    label = "Kritische kans op motorolie",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Motorolie toestand op of onder welke de kritieke kans wordt gebruikt.",
                    label = "Kritieke oliedrempel voor motor",
                },
                oilLeaksEngineOilThreshold = {
                    description = "De toestand van motorolie op of onder welke een lek kan starten.",
                    label = "Drempelwaarde motorolie",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Vereiste voorwaartse verplaatsingsverhouding van 0 tot 1.",
                    label = "Voorwaartse bewegingsverhouding",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Laat zware frontale botsingen toe om een tijdelijk motorvloeistoflek te starten.",
                    label = "Frontale botsingslekken",
                },
                oilLeaksImpactChance = {
                    description = "Kans van 0 tot 1 dat een kwalificerende inslag begint een lek.",
                    label = "Impactlekkans",
                },
                oilLeaksImpactRadius = {
                    description = "Straal van het eerste vloeistofpunt dat ontstaat door een inslag.",
                    label = "Straal van botsingen",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimum seconden tussen paden.",
                    label = "Treininterval",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Seconden een lek gaat door na een kwalificerende impact.",
                    label = "duur van het effectlek",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimale gezondheid van het lichaam verloren tijdens de impact.",
                    label = "Minimale schade aan het lichaam",
                },
                oilLeaksMinDistance = {
                    description = "Minimale afgelegde afstand tussen paden.",
                    label = "Trailafstand",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimale motor gezondheid verloren tijdens de botsing.",
                    label = "Minimale motorschade",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Vereiste vervorming van de voorkant. Gebruik 0 om deze controle uit te schakelen.",
                    label = "Minimale vervorming van de voorzijde",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimumsnelheid vóór de botsing in km/h.",
                    label = "Minimum botssnelheid",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Vereist snelheidsverlies in km/h tijdens de botsing.",
                    label = "Minimumsnelheidsverlies",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minimale voertuigsnelheid in km/h voordat een vloeistoflek een spoor kan creëren.",
                    label = "Minimumsnelheid",
                },
                oilLeaksRadius = {
                    description = "Straal van normale voertuig vloeistof trail punten.",
                    label = "Spoorradius",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normale lekkans van 0 tot 1.",
                    label = "Transmissie vloeistofkans",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kritische lekkans van 0 tot 1.",
                    label = "Kritische transmissiekans",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Transmissievloeistoftoestand op of onder welke de kritieke kans wordt gebruikt.",
                    label = "Kritische transmissiedrempel",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Transmissievloeistoftoestand waarbij een lek kan beginnen.",
                    label = "Transmissievloeistofdrempel",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Voertuigklassen die hef-afhankelijke orderwerk zonder werkplaatslift kunnen voltooien.",
                    itemLabel = "Voertuigklasse toevoegen",
                    label = "Lift bypass-voertuigklassen",
                    options = {
                        ["0"] = "Compacts",
                        ["1"] = "Sedans",
                        ["10"] = "Industrieel",
                        ["11"] = "Nutsvoorziening",
                        ["12"] = "Vans",
                        ["13"] = "Cycli",
                        ["14"] = "Boten",
                        ["15"] = "Helikopters",
                        ["16"] = "Vliegtuigen",
                        ["17"] = "Onderhoud",
                        ["18"] = "Noodgeval",
                        ["19"] = "Militair",
                        ["2"] = "SUV's",
                        ["20"] = "Handel",
                        ["21"] = "Treinen",
                        ["22"] = "Open wiel",
                        ["3"] = "Koppels",
                        ["4"] = "Spier",
                        ["5"] = "Sport Classics",
                        ["6"] = "Sport",
                        ["7"] = "Super",
                        ["8"] = "Motorrijwielen",
                        ["9"] = "Wegen",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modellen voor het paaien van voertuigen die zonder werkplaatslift een lift-afhankelijk orderwerk kunnen voltooien.",
                    itemLabel = "Voertuigmodel",
                    label = "Lift bypass voertuig modellen",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milliseconden gebruikt voor order installatie stappen die geen minigame draaien.",
                    label = "Eenvoudige installatieduur",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Voertuigklasse ID's die altijd gebruik maken van de normale monteur installatie zonder gespecialiseerde lift of minigame stromen.",
                    label = "Niet-minigame voertuigklassen",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Voertuig paaimodellen die altijd gebruik maken van de normale monteur installatie zonder gespecialiseerde lift of minigame stromen.",
                    label = "Niet-minigame voertuigmodellen",
                },
                partsDeliveryCompanyCard = {
                    description = "Laat onderdelen levering orders te gebruiken bedrijf fondsen.",
                    label = "Betaling van bedrijfskaart",
                },
                partsDeliveryMode = {
                    description = "Houd de standaard fysieke leveringsstroom of voeg de volledige levering direct toe aan de inventaris van de verzamelende speler.",
                    label = "Leveringsbehandeling",
                    options = {
                        player_inventory = "Spelerinventaris",
                        standard = "Standaard leveringsstroom",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Milliseconden nodig om een kant-en-klare onderdelen levering uit te pakken.",
                    label = "Open duur",
                },
                partsDeliveryOwnCard = {
                    description = "Laat spelers om onderdelen levering bestellingen te betalen met hun eigen geld.",
                    label = "Eigen kaartbetaling",
                },
                partsDeliveryTimeSeconds = {
                    description = "Seconden tussen het bestellen van onderdelen en de levering wordt klaar.",
                    label = "Levertijd",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventaris bij diefstal van een katalysator.",
                    label = "Catalytische converter-item",
                },
                partsTheftDealerAccount = {
                    description = "Rekening gebruikt voor gestolen onderdelen dealer uitbetalingen, zoals geld of bank.",
                    label = "Dealer uitbetaling rekening",
                },
                partsTheftDealerItems = {
                    description = "Gestolen items de dealer zal kopen en hun uitbetaling waarden.",
                    itemLabel = "Handelaar",
                    label = "Handelaarsitems",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventaris item gegeven wanneer de dealer uitbetaling type is Item. De verkoopprijs wordt gebruikt als het item bedrag.",
                    label = "Dealer uitbetaling item",
                },
                partsTheftDealerPayoutType = {
                    description = "Kies of de dealer betaalt op een kader rekening of geeft een inventaris item.",
                    label = "Dealer uitbetaling type",
                    options = {
                        account = "Rekening",
                        item = "Voorwerp",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maximale afstand van de dealer om gestolen onderdelen te verkopen.",
                    label = "Handelaar verkoop afstand",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Seconden voordat hetzelfde voertuig deel kan maken van een andere verzending.",
                    label = "Dispatchwachttijd",
                },
                partsTheftDispatchEnabled = {
                    description = "Creëer een politiebericht wanneer een wiel of katalysator wordt gestolen.",
                    label = "Stuur de politie.",
                },
                partsTheftDispatchJobs = {
                    description = "beroepsnamen die onderdelen diefstal verzenden ontvangen.",
                    itemLabel = "Jobnaam",
                    label = "Dispatch-jobs",
                },
                partsTheftDispatchMessage = {
                    description = "Bericht getoond op de verzending alarm. Ondersteunt {plate}, {part}, en {type}.",
                    label = "Bericht versturen",
                },
                partsTheftDispatchTitle = {
                    description = "Titel weergegeven op de melding van verzending. Ondersteunt {plate}, {part}, en {type}.",
                    label = "Verzendingstitel",
                },
                partsTheftItem = {
                    description = "Inventory item gebruikt om wielen en katalysatoren te stelen.",
                    label = "Hulpmiddel voor diefstal",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Verwijder de diefstal tool item na een succesvolle diefstal actie.",
                    label = "Hulpmiddel voor diefstal consumeren",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventaris item toegekend bij wielen worden gestolen.",
                    label = "Gestolen wiel item",
                },
                priceType = {
                    description = "Percentage berekent de kosten van de voertuigprijs. Vast gebruikt geldwaarden. Voertuigklasse maakt gebruik van de klasseprijstabel.",
                    label = "Prijstype",
                    options = {
                        class = "Voertuigklasse",
                        fixed = "Vast",
                        percentage = "Percentage",
                    },
                },
                primaryColor = {
                    description = "Standaardkleur voor de monteur-beroepsgroep en nieuwe beroepen. Gebruik een hex waarde zoals #EDC001.",
                    label = "Primaire kleur",
                },
                publicUsersSeePrices = {
                    description = "Wanneer ingeschakeld betalen publieke klanten tijdens het bestellen. Schakel dit uit om onbetaalde bestellingen voor mechanische facturering te creëren.",
                    label = "Openbaar zelfbedieningsbevelen in rekening brengen",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Sta toegestane bazen toe om een abonnement te kopen voor hun hele beroep met behulp van bedrijfsfondsen.",
                    label = "Abonnementen van ondernemingen",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Betalingsvaluta",
                },
                subscriptionsEnabled = {
                    description = "Activeer workshopabonnementen, klantenterminals en abonnementskortingen.",
                    label = "Ingeschakeld",
                },
                subscriptionsMaximumDurations = {
                    description = "Maximale duur en prijsopties per abonnementsmodel.",
                    label = "Maximumduur",
                },
                subscriptionsMaximumModels = {
                    description = "Maximale abonnement modellen een workshop kan configureren in de tablet.",
                    label = "Maximummodellen",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Optionele looping animatie clip gebruikt wanneer het scenario leeg is.",
                    label = "Animatiefragment voor NPC",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Optionele animatie woordenboek gebruikt wanneer het scenario leeg is.",
                    label = "NPC emotiewoordenboek",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped model geboren op abonnement terminals, bijvoorbeeld s_m_m_autoshop_01.",
                    label = "Standaard NPC-model",
                },
                subscriptionsNpcScenario = {
                    description = "Optioneel GTA scenario zoals WORLD_HUMAN_CLIPBOARD. Laat leeg om de emote animatie te gebruiken.",
                    label = "NPC-scenario",
                },
                tuningBlockedPlates = {
                    description = "Voertuigen met een van deze platen kunnen niet worden afgesteld, geïnstalleerd of laten stemmen verwijderd. Bijpassen negeert behuizing en witruimte.",
                    itemLabel = "Kenteken",
                    label = "Geblokkeerde stemplaten",
                },
                tuningWorkshopDistance = {
                    description = "Maximale afstand van een zelfbedieningspunt voor vereiste installatie- of verwijderingsacties.",
                    label = "Werkplaats vereiste afstand",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Vereiste tuning order installs om te starten en voltooien in de buurt van een self-service tuning punt.",
                    label = "Werkplaats nodig voor installatie",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Vereiste tuning verwijderingen om te beginnen en te voltooien in de buurt van een self-service tuning punt.",
                    label = "Vereiste werkplaats voor verhuizingen",
                },
                vehicleCareRepairDurationMs = {
                    description = "Repareer de voortgang in milliseconden.",
                    label = "Reparatieduur",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Reset ook realistische wielschade bij het gebruik van de reparatie actie.",
                    label = "Realistische wielschade herstellen",
                },
                vehicleCareRepairItem = {
                    description = "Inventory item gebruikt door de reparatie actie van het voertuig.",
                    label = "Reparatie-item",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maximale afstand tot het voertuig tijdens de reparatie.",
                    label = "Repareren max afstand",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Verwijder het reparatie-item na gebruik.",
                    label = "Consumeer reparatie-item",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Herstel normale GTA voertuigschade bij het gebruik van de reparatie actie.",
                    label = "Herstel voertuigschade",
                },
                vehicleCareRepairWearParts = {
                    description = "Kies welke slijtage en service onderdelen het reparatie-item herstelt. Schakel vloeistoffen hier als olie, koelvloeistof, remvloeistof, of transmissievloeistof moet de diagnose reparatiestroom vereisen.",
                    itemLabel = "Draag deel",
                    label = "Reparatie kit gerestaureerde onderdelen",
                },
                vehicleCareWashItem = {
                    description = "Inventory item gebruikt om een voertuig te wassen.",
                    label = "Was-item",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Verwijder het wasmiddel na gebruik.",
                    label = "Consume wash-item",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Afstand een gewaxt voertuig blijft schoon.",
                    label = "Wasvrije kilometers",
                },
                vehicleCareWaxItem = {
                    description = "Inventaris gebruikt om een voertuig te wassen.",
                    label = "Waspunt",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Verwijder het wasmiddel na gebruik.",
                    label = "Consumeerwas",
                },
                vehicleClassPricing = {
                    description = "Overschrijf het prijstype en de kosten multiplier voor elke GTA voertuigklasse.",
                    label = "Prijzen van voertuigklassen",
                },
                wearParts = {
                    description = "Slijtage onderdelen van het voertuig, hun levensduur afstand, vereiste reparatie item, item verbruik, en installatie flow.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalytische converter",
                                fluid_refill = "Vloeistofvulling",
                                hood_install = "Hood installatie",
                                oil_change = "Oliewisseling",
                                performance = "Prestaties",
                                underbody_neon = "Onderlichaam / lift",
                                wheel = "Wiel",
                            },
                        },
                    },
                    itemLabel = "Draag deel",
                    label = "Draag onderdelen",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Basiswiel schade multiplier.",
                    label = "Standaard multiplier",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtreert de vervormingssondepunten die niet naar de carrosserie van het voertuig wijzen.",
                    label = "Probe-hoekdrempel",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Extra kracht toegevoegd elke herstel iteratie.",
                    label = "Verhoging van de schade door vervorming",
                },
                wheelDamageDeformationEnabled = {
                    description = "Vang en herstel body deuken tijdens banden reparatie geometrie herbouwt.",
                    label = "Vervorming herstellen",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Startkracht gebruikt bij het herstellen van deuken.",
                    label = "Aanvankelijke vervormingsschade",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximale SetVehicleDamage passen gebruikt om deuken te herbouwen.",
                    label = "Deformatie-iteraties",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minimale gedetecteerde vervorming magnitude om op te slaan.",
                    label = "Deformatiedrempel",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Vermenigvuldiger gebruikt wanneer het voertuig off-road wielen heeft.",
                    label = "Factor voor terreinwielen",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra instant non-wheel schade herstel passeert na wielgeometrie is herbouwd.",
                    label = "Teruggave van de schade",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Extra instant pass voor stilstaande of nog platte banden nadat een wiel is gerepareerd.",
                    label = "Wheel-state reapply pass",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Houd body, motor, ramen, deuren, vuil en visuele schade wanneer bandenreparatie wielgeometrie herbouwt.",
                    label = "Behoud van voertuigschade",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Herstel gebroken ramen zonder het luide smash effect waar mogelijk.",
                    label = "Rustig kapotte ramen",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Stilstaande banden opnieuw toepassen zonder dat er een nieuw popgeluid of -effect ontstaat.",
                    label = "Stilteband opnieuw toepassen",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maximale afstand tot de beschadigde of ontbrekende band voor de montageactie.",
                    label = "Afstand bandbevestiging",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maximale afstand van de geplaatste auto jack voor de verwijdering actie.",
                    label = "Auto jack verwijder afstand",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Schade multipliers per GTA voertuigklasse.",
                    itemLabel = "Voertuigklasse",
                    label = "Multipliers van voertuigklasse",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Andere beroepen blokkeren als monteurs in dienst zijn",
                },
                allowsprint = {
                    label = "Sprinten met bezorgdozen toestaan",
                },
            },
            tuningCategories = {
                bodywork = "Carrosserie",
                electronics = "ECU en voertuigelektronica",
                engineSounds = "Motorgeluiden",
                handling = "Rijgedrag",
                lights = "Verlichting",
                other = "Overig",
                paint = "Lakwerk",
                performance = "Prestaties",
                stance = "Stand",
                wheels = "Wielen",
            },
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Klantprijs",
                description = "Voorbeeld van een cosmetische berekening met de huidige regels.",
                labor = "Arbeid",
                live = "Livevoorbeeld",
                margin = "Marge",
                sports = "Sportauto",
                super = "Supercar",
                supplier = "Leverancier",
                title = "Prijsvoorbeeld",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configureer monteur-jobs, winkels, voertuigen en werkplaatslocaties.",
                    title = "Monteur-jobs",
                },
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
            fields = {
                quantity = "Aantal",
            },
            settingFieldDescriptions = {
                radialEnabled = "Open mechanische facturering van het radiale menu.",
                allowTuningInvoices = "Stuur de stemmand naar de dichtstbijzijnde klant. Installatie ontgrendelt na volledige betaling.",
                customerRange = "Maximale afstand in meter voor het afgeven van facturen aan nabijgelegen klanten.",
                allowAnalytics = "Laat facturering analytics, tenzij een cijferregel het overschrijft.",
                allowCustomPrices = "Sta monteurs toe om factuur positie prijzen te bewerken voordat ze uitgeven.",
                allowEstimates = "Laat schattingen die klanten moeten accepteren vóór betaling.",
                allowImmediatePayment = "Het rechtstreeks betalen van facturen uit dit beroep mogelijk maken.",
                allowManualItems = "Sta mechanica toe willekeurige factuurposities te creëren.",
                allowPartialPayments = "Laat stortingen en meerdere betalingen naar één factuur.",
                analyticsPeriodDays = "Dagen inbegrepen in de facturatie analytics.",
                defaultDueDays = "Dagen tot een factuur te laat is.",
                depositPercent = "Vereist depositopercentage nadat een factuur is uitgegeven of een schatting is geaccepteerd.",
                enabled = "Sta dit beroep toe om mechanische facturering te gebruiken.",
                estimateLifetimeHours = "Uren voordat een onbeantwoorde schatting verloopt.",
                gradeRules = "Factuur limieten en acties beschikbaar voor elke monteur kwaliteit.",
                maxDiscountPercent = "De grootste korting die een factuur kan ontvangen.",
                maximumInvoiceAmount = "Wereldwijd maximum totaal vóór de grade limieten.",
                maximumManualItems = "Maximale willekeurige posities per document.",
                maximumReminders = "Maximale herinneringen toegestaan per factuur.",
                minimumInvoiceAmount = "Minimumtotaal voor ramingen en facturen.",
                minimumPartialPayment = "Kleinste gedeeltelijke betaling, met uitzondering van een kleiner saldo of deposito.",
                reminderFee = "Vergoeding toegevoegd door elke geldige herinnering.",
                reminderGraceDays = "Dagen te laat voordat de eerste herinnering is toegestaan.",
                taxPercent = "Belasting toegevoegd na kortingen.",
            },
            settingFields = {
                radialEnabled = "Radiaal optreden van factuur",
                allowTuningInvoices = "Facturering van klanten",
                customerRange = "Klantenafstand",
                allowAnalytics = "Boekhoudkundige analyse",
                allowCancellation = "Annulering",
                allowCustomPrices = "Gebruikelijke prijzen toestaan",
                allowEstimates = "Schattingen toestaan",
                allowImmediatePayment = "Onmiddellijke betaling toestaan",
                allowManualItems = "Eigen posities toestaan",
                allowPartialPayments = "Gedeeltelijke betalingen toestaan",
                allowReminders = "Herinneringen",
                amount = "Bedrag",
                analyticsPeriodDays = "Analyseperiode",
                bone = "Bot",
                category = "Categorie",
                classId = "Klasse ID",
                defaultDueDays = "Betalingstermijn (dagen)",
                depositPercent = "Aanbetalingspercentage",
                difficulty = "Moeilijkheidsgraad",
                enabled = "Ingeschakeld",
                estimateLifetimeHours = "Geschatte levensduur (uren)",
                flow = "Stroom installeren",
                grade = "Graad",
                gradeRules = "Graadregels",
                item = "Voorwerp",
                key = "Sleutel",
                kilometersToZero = "Kilometers tot nul",
                label = "Naam",
                laborFee = "Arbeidskosten",
                laborMultiplier = "Werkvermenigvuldiger",
                marginAdjustmentPercent = "Margeaanpassing",
                marginPercent = "Marge %",
                maxDiscountPercent = "Maximale korting",
                maximumInvoiceAmount = "Maximale factuur",
                maximumManualItems = "Maximale eigen posities",
                maximumPrice = "Maximum",
                maximumReminders = "Maximale herinneringen",
                minimumInvoiceAmount = "Minimumfactuur",
                minimumPartialPayment = "Minimale gedeeltelijke betaling",
                minimumPrice = "Minimum",
                multiplier = "Multiplier",
                name = "Itemnaam",
                partKey = "Deelsleutel",
                price = "Prijs",
                priceType = "Prijstype",
                prop = "Object",
                reason = "Reden",
                reminderFee = "Herinneringsvergoeding",
                reminderGraceDays = "Herinneringsperiode",
                removeAfterUse = "Consumeer artikel",
                repair = "Reparatie met kit",
                repairItem = "Reparatie-item",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Leverancier",
                taxPercent = "Factureringsbelasting",
                transport = "Vervoer",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Upgrade",
                maximumDiscountPercent = "Maximale korting",
            },
            settingValues = {
                air_filter = "Luchtfilter",
                brake_fluid = "Remvloeistof",
                brake_pads = "Remkussens",
                catalytic_converter = "Catalytische converter",
                clutch = "Koppeling",
                coolant = "Koelmiddel",
                engine_oil = "Motorolie",
                inverter = "Omvormer",
                spark_plugs = "Vonkenpluggen",
                suspension = "Suspensie",
                traction_battery = "Tractiebatterij",
                transmission_fluid = "Transmissievloeistof",
                tyres = "Banden",
                vehicleClass_0 = "Compacts",
                vehicleClass_1 = "Sedans",
                vehicleClass_10 = "Industrieel",
                vehicleClass_11 = "Nutsvoorziening",
                vehicleClass_12 = "Vans",
                vehicleClass_13 = "Cycli",
                vehicleClass_14 = "Boten",
                vehicleClass_15 = "Helikopters",
                vehicleClass_16 = "Vliegtuigen",
                vehicleClass_17 = "Onderhoud",
                vehicleClass_18 = "Noodgeval",
                vehicleClass_19 = "Militair",
                vehicleClass_2 = "SUV's",
                vehicleClass_20 = "Handel",
                vehicleClass_21 = "Treinen",
                vehicleClass_22 = "Open wiel",
                vehicleClass_3 = "Koppels",
                vehicleClass_4 = "Spier",
                vehicleClass_5 = "Sport Classics",
                vehicleClass_6 = "Sport",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Motorrijwielen",
                vehicleClass_9 = "Wegen",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Uitgeschakeld",
                        [1] = "GTA Standaard",
                        [2] = "Uitlaatknallen voor straatgebruik",
                        [3] = "Anti-lag voor circuit",
                        [4] = "Anti-lag voor rally",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatische gevaren",
                    values = {
                        [0] = "Uit",
                        [1] = "Aan",
                    },
                },
                electronic_brake_lights = {
                    label = "Remlichten",
                    values = {
                        [0] = "Normaal",
                        [1] = "Noodflits",
                        [2] = "Uit",
                    },
                },
                electronic_engine_tune = {
                    label = "Motorsoftware",
                    values = {
                        [0] = "Voorraad",
                        [1] = "Fase 1",
                        [2] = "Fase 2",
                        [3] = "Fase 3",
                        [4] = "Fase 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Koplamp Helderheid",
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
                    label = "Hoge Stralen op Horn",
                    values = {
                        [0] = "Uit",
                        [1] = "Aan",
                    },
                },
                electronic_idle_rpm = {
                    label = "Inactief RPM",
                    values = {
                        [0] = "Voorraad",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Binnenlicht",
                    values = {
                        [0] = "Normaal",
                        [1] = "Rood",
                    },
                },
                electronic_mood_color = {
                    label = "Mood lichtkleur",
                    values = {
                        [0] = "Uit",
                        [1] = "Rood",
                        [10] = "Lem",
                        [11] = "Turkoois",
                        [12] = "Indigo",
                        [13] = "Wit",
                        [14] = "Warm wit",
                        [15] = "Koudwit",
                        [16] = "Amber",
                        [2] = "Blauw",
                        [3] = "Groen",
                        [4] = "Cyaan",
                        [5] = "Magenta",
                        [6] = "Geel",
                        [7] = "Oranje",
                        [8] = "Paars",
                        [9] = "Roze",
                    },
                },
                electronic_mood_intensity = {
                    label = "Mood Lichtintensiteit",
                    values = {
                        [0] = "Dim",
                        [1] = "Normaal",
                        [2] = "Helder",
                    },
                },
                electronic_radio_power = {
                    label = "Radiovermogen",
                    values = {
                        [0] = "Uit",
                        [1] = "Aan",
                    },
                },
                electronic_throttle_response = {
                    label = "Gasrespons",
                    values = {
                        [0] = "Meer Tractie",
                        [1] = "Agressief",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie-afstelling",
                    values = {
                        [0] = "Uit",
                        [1] = "Zacht",
                        [2] = "Intens",
                    },
                },
            },
            vehicleClassLabel = "Klasse {id} ({name})",
        },
    },
}
