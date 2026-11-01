JobConfigLocales["sky_ambulancejob:nl"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Medische beoordelingen",
                sharedMedicalEvaluations = "Gedeelde medische beoordelingen",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Respawn toestaan",
                        description = "Bepaalt of dit bed gebruikt mag worden voor speler-respawns.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configureer ambulancetaken, ziekenhuisbedden, overlijdenssystemen, interacties en instellingen voor kernfuncties.",
                    title = "Ambulance banen",
                },
            },
            dispatchActions = {
                currentLocation = "Gebruik huidige locatie",
                addChannel = "Radiokanaal toevoegen",
                addKeyword = "Steekwoord toevoegen",
                addPoi = "POI toevoegen",
                addReporter = "Melder toevoegen",
                addStatus = "FMS-status toevoegen",
                addVehicle = "Virtuele eenheid toevoegen",
                addVehicleType = "Eenheidstype toevoegen",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Minimumaantal personeelsleden in de voor dit responsplan geselecteerde eenheden.",
                noUnitFallback = "Stuurt, zonder centrum of bemande eenheid, een Sky-melding naar alle dienstdoende leden.",
                radius = "Maximale afstand in meters waarop de stationsmededeling kan worden gehoord.",
                requirements = "Antwoordvraag als TYPE:COUNT-paren, bijvoorbeeld PATROL:2,CRIME:1.",
                statusCode = "Numerieke FMS-status weergegeven op de handradio.",
                statusLabel = "Betekenis van deze FMS-status voor coördinatoren en eenheden.",
                vehicleType = "Moet overeenkomen met een voertuigtypecode die in de vorige subsectie is geconfigureerd.",
                vehicleTypeCode = "Korte eenheidscode die wordt gebruikt in responsvereisten, bijvoorbeeld PATROL, CRIME, EMS of RESCUE.",
                vehicleTypeLabel = "Leesbare naam van deze toestelcategorie.",
                crewCapacity = "Maximaal aantal personen dat deze eenheid kan bemannen. Gebruik 0 voor onbeperkte bemanning.",
                joinLocked = "Voorkomt dat extra personen zich aansluiten nadat de eenheid is bemand.",
                poiId = "Vaste technische identificatie waarnaar meldkamerprofielen ook na een naamswijziging kunnen verwijzen.",
                readyStatusCode = "FMS-status die wordt ingesteld zodra deze resource inzetgereed is.",
                resourceType = "Classificeert de operationele resource voor filters en coördinatie in de meldkamer.",
                respondingStatusCode = "FMS-status die wordt ingesteld zodra deze resource naar een incident uitrukt.",
                shortLabel = "Optioneel kort label op de zes geheugenknoppen voor radiokanalen.",
                stationId = "Koppelt deze eenheid aan een standplaats uit het meldkamerprofiel.",
                unitId = "Vaste technische identificatie waarmee de eenheid behouden blijft als de roepnaam verandert.",
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
                defaultChannel = "Standaardradiokanaal",
                emergencyAppEnabled = "Weergeven in noodapp",
                enabled = "Verzending inschakelen",
                icon = "Icoon",
                incidentAssessmentEnabled = "Noodbeoordeling inschakelen",
                jobs = "Doeltaken (door komma's gescheiden)",
                keywordCode = "Trefwoordcode",
                label = "Etiket",
                minimumCrew = "Minimale bemanning",
                name = "Naam",
                noUnitFallback = "Waarschuw het dienstdoende personeel zonder eenheden",
                noneChannel = "Geen/groep standaard",
                note = "Opmerking",
                phone = "Telefoon",
                radius = "Aankondigingsradius",
                requirements = "Vereiste eenheden (bijvoorbeeld PATROL:2,CRIME:1)",
                type = "Typen",
                vehicleType = "Type responseenheid",
                crewCapacity = "Bemanningscapaciteit",
                joinLocked = "Bemanningstoegang vergrendelen",
                poiId = "Vaste POI-ID",
                readyStatusCode = "Code voor gereedstatus",
                resourceType = "Resourcetype",
                respondingStatusCode = "Code voor uitrukstatus",
                shortLabel = "Label van radiogeheugen",
                stationId = "Standplaats-ID",
                unitId = "Vaste eenheids-ID",
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
                    statuses = "Beschikbare FMS",
                    units = "Virtuele eenheden",
                    reporters = "Bekende melders",
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
                dispatchStatusCodes = "Configureert FMS-statuslabels en welke statussen gelden als beschikbaar voor nieuwe incidenten.",
                dispatchVehicleTypes = "Definieert de eenheidscategorieën die worden gebruikt door responsplannen, zoals Patrouille, Crime Unit, EMS of Rescue.",
                dispatchVehicles = "Definieert virtuele expeditievoertuigen die overal kunnen worden bemand zonder dat een voortgebracht voertuig nodig is.",
                dispatchReporters = "Beheert meldersnamen, terugbelnummers en meldkamernotities voor deze functie.",
            },
            extensions = {
                invalidSelection = "Ongeldige selectie: {value}",
                trainingSettings = {
                    description = "Configureer trainingstoegang, inschrijving, goedkeuringen en cursusplanning voor deze taak.",
                    label = "Trainingsinstellingen",
                },
                dispatchReporters = "Bekende melders",
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
            },
            features = {
                bleeding = {
                    description = "Schakel het ontluchtingssysteem in.",
                    label = "Bloeden",
                },
                bodybags = {
                    description = "Maak lijkzakken en bezorgstromen voor lijkzakken mogelijk.",
                    label = "Lijkzakken",
                },
                consciousScenarioBloodPressure = {
                    description = "Laat bloeddrukcontroles uitvoeren terwijl de patiënt bij bewustzijn is.",
                    label = "Bewuste bloeddruk",
                },
                deathTimeout = {
                    description = "Schakel de time-outstroom voor overlijden in.",
                    label = "Time-out voor de dood",
                },
                fractures = {
                    description = "Maak het hanteren en behandelen van fracturen mogelijk.",
                    label = "Breuken",
                },
                knockout = {
                    description = "Schakel het knock-outsysteem in.",
                    label = "Knock-out",
                },
                legShotRagdoll = {
                    description = "Laat de speler vallen bij een treffer in ingestelde been- of voetzones.",
                    label = "Vallen bij beenschot",
                },
                pain = {
                    description = "Schakel het pijnsysteem in.",
                    label = "Pijn",
                },
                respawnInBed = {
                    description = "Respawn bracht spelers weer tot leven in een ziekenhuisbed, indien beschikbaar.",
                    label = "Ontspan in bed",
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
                gang = "Bende",
                allowInVehicle = "Toestaan in voertuig",
                allowMovement = "Beweging toestaan",
                animDict = "Animatiewoordenboek",
                animFlag = "Animatievlag",
                animName = "Animatienaam",
                bleeding = "Bloeding",
                cause = "Oorzaak",
                chance = "Kans",
                class = "Klasse",
                companyPrice = "Bedrijfsprijs",
                companyPricePerEmployee = "Prijs per medewerker",
                copayPercent = "Copay%",
                description = "Beschrijving",
                dictionary = "Animatiewoordenboek",
                duration = "Duur",
                durationMs = "Duur (ms)",
                effect = "Effect",
                effectDurationMs = "Effectduur (ms)",
                effectDurationSeconds = "Effectduur (seconden)",
                enabled = "Ingeschakeld",
                extractionType = "Verwijderingstype",
                foreignObject = "Vreemd voorwerp",
                heal = "Genezing",
                id = "ID",
                itemName = "Artikelnaam",
                key = "Sleutel",
                label = "Naam",
                lang = "Taal",
                limit = "Limiet",
                lossPerSecond = "Verlies per seconde",
                max = "Maximum",
                min = "Minimum",
                minGrade = "Min cijfer",
                minigame = "Minispel",
                model = "Prop-model",
                name = "Taaknaam",
                options = "Opties (selectietypen)",
                pain = "Pijn",
                pauseBleedingSeconds = "Bloeding pauzeren (seconden)",
                price = "Prijs",
                progressbarAllowInVehicle = "Voortgang: toestaan in voertuig",
                progressbarAllowMovement = "Voortgang: beweging toestaan",
                progressbarCanCancel = "Voortgang annuleerbaar",
                progressbarDisableCarMovement = "Voortgang: voertuigbeweging blokkeren",
                progressbarDisableCombat = "Voortgang: gevecht blokkeren",
                progressbarDisableMouse = "Voortgang: muis blokkeren",
                progressbarDisableMovement = "Voortgang: beweging blokkeren",
                progressbarDisableSprint = "Voortgang: sprint blokkeren",
                progressbarDuration = "Voortgangsduur",
                progressbarEnabled = "Voortgangsbalk ingeschakeld",
                progressbarLabel = "Voortgangstekst",
                progressbarUseWhileDead = "Bruikbaar wanneer dood",
                questions = "Vragen",
                requireItems = "Vereist artikelen",
                required = "Vereist",
                requiresExtraction = "Verwijdering vereist",
                requiresOpenWound = "Open wond vereist",
                sort = "Volgorde",
                state = "Status",
                stopBleeding = "Bloeding stoppen",
                threshold = "Drempel",
                time = "Tijd",
                type = "Soort",
                useAnimation = "Gebruik animatie",
                value = "Waarde",
                zone = "Gebied",
                zones = "Gebieden",
                systolic = "Systolische bloeddruk",
                diastolic = "Diastolische bloeddruk",
                cardiacArrest = "Hartstilstand",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Algemeen",
                },
                billingRange = {
                    label = "Bereik",
                },
                billingReasons = {
                    label = "Reden-voorinstellingen",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animatie",
                },
                bodyBagAttachGeneral = {
                    label = "Bijvoegen",
                },
                bodyBagAttachOffsets = {
                    label = "Compensaties",
                },
                bodyBagAttachRotation = {
                    label = "Rotatie",
                },
                bodyBagDeliveryGeneral = {
                    label = "Algemeen",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Algemeen",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Betaling",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Algemeen",
                },
                crutchAssign = {
                    label = "Opdracht",
                },
                crutchDuration = {
                    label = "Duur",
                },
                crutchGeneral = {
                    label = "Algemeen",
                },
                crutchItems = {
                    label = "Voorwerp",
                },
                crutchRestrictions = {
                    label = "Beperkingen",
                },
                damageHandlingBladeWeapons = {
                    label = "Blade-wapens",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Bloedende zwarte lijst",
                },
                damageHandlingBleedingClasses = {
                    label = "Bloedende lessen",
                },
                damageHandlingBloodSystem = {
                    label = "Bloed systeem",
                },
                damageHandlingDeathInjuries = {
                    label = "Doodsverwondingen",
                },
                damageHandlingInjuryEffects = {
                    label = "Letseleffecten",
                },
                damageHandlingInjuryThresholds = {
                    label = "Blessuredrempels",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Been-schot ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Been-schot zones",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Levende schadefracturen",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zonekansen",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Open wond stacks",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Zone limieten",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Live wondlessen",
                },
                damageHandlingMedications = {
                    label = "Medicijnen",
                },
                damageHandlingPainClasses = {
                    label = "Pijn klassen",
                },
                damageHandlingPainEffects = {
                    label = "Pijneffecten",
                },
                damageHandlingStatusEffects = {
                    label = "Statuseffecten",
                },
                damageHandlingVehicleDamage = {
                    label = "Voertuigschade",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Schade Oorzaken",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Blessures",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Bescherming tegen voertuigimpact",
                },
                deathAnimal = {
                    label = "Terugval van dieren",
                },
                deathAnimalAnimation = {
                    label = "Dierenanimatie",
                },
                deathAnimation = {
                    label = "Animatie",
                },
                deathGeneral = {
                    label = "Algemeen",
                },
                deathModels = {
                    label = "Per modeloverschrijvingen",
                },
                deathScreenAiMedic = {
                    label = "Algemeen",
                },
                deathScreenAiMedicAvailability = {
                    label = "Beschikbaarheid",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Gedrag",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Forceer herleven",
                },
                deathScreenAiMedicPayment = {
                    label = "Betaling",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Herleef in bed",
                },
                deathScreenAiMedicSpawn = {
                    label = "Paaien",
                },
                deathScreenAiMedicTiming = {
                    label = "Tijdstip",
                },
                deathScreenControls = {
                    label = "Controles",
                },
                deathScreenDamageLogs = {
                    label = "Schadelogs",
                },
                deathScreenDimensions = {
                    label = "Afmetingen",
                },
                deathScreenDispatch = {
                    label = "Verzenden",
                },
                deathScreenEarlyRespawn = {
                    label = "Algemeen",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Beschikbaarheid",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Betaling",
                },
                deathScreenGeneral = {
                    label = "Algemeen",
                },
                deathScreenHospitalSelection = {
                    label = "Ziekenhuis selectie",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Selectiecamera",
                },
                deathScreenInformation = {
                    label = "Algemeen",
                },
                deathScreenIntegration = {
                    label = "Integratie",
                },
                deathScreenLogs = {
                    label = "Overlijdenslogs",
                },
                deathScreenMinigame = {
                    label = "Minispel",
                },
                deathScreenRespawn = {
                    label = "Algemeen",
                },
                deathScreenRespawnAccounts = {
                    label = "Rekeningen",
                },
                deathScreenRespawnFallback = {
                    label = "Terugvalcoördinaten",
                },
                deathScreenRespawnItems = {
                    label = "Artikelen",
                },
                deathScreenRespawnWeapons = {
                    label = "Wapens",
                },
                deathScreenStyle = {
                    label = "Doodsschermstijl",
                },
                deathScreenVoice = {
                    label = "Stem",
                },
                deathTimeoutGeneral = {
                    label = "Algemeen",
                },
                deathTimeoutWhitelist = {
                    label = "Vacatures op de witte lijst",
                },
                diagnoseAnim = {
                    label = "Animatie",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Volledige genezing",
                },
                diagnoseGeneral = {
                    label = "Algemeen",
                },
                doctorNpcAvailability = {
                    label = "Beschikbaarheid",
                },
                doctorNpcGeneral = {
                    label = "Algemeen",
                },
                doctorNpcHealOther = {
                    label = "Genees de ander",
                },
                doctorNpcHealSelf = {
                    label = "Genees jezelf",
                },
                doctorNpcRanges = {
                    description = "Deze bereiken bepalen niet hoe dichtbij een speler moet zijn om de dokter-NPC-interactie te openen. Ze zijn pas van toepassing nadat het doktersmenu is geopend.",
                    label = "Bereiken",
                },
                doctorNpcRevive = {
                    label = "Herleven",
                },
                doctorNpcReviveInBed = {
                    label = "Herleef in bed",
                },
                firstAidAnimation = {
                    label = "Animatie",
                },
                firstAidGeneral = {
                    label = "Algemeen",
                },
                firstAidLicenseAdd = {
                    label = "Licentie toevoegen",
                },
                firstAidLicenseRemove = {
                    label = "Licentie verwijderen",
                },
                firstAidPosition = {
                    label = "Positie",
                },
                healthInsuranceExpiration = {
                    label = "Vervaldatum",
                },
                healthInsuranceGeneral = {
                    label = "Algemeen",
                },
                healthInsurancePayment = {
                    label = "Betaling",
                },
                healthInsuranceProviders = {
                    label = "Aanbieders",
                },
                hospitalBedsBedAnimation = {
                    label = "Bedanimatie",
                },
                hospitalBedsCreator = {
                    label = "Schepper",
                },
                hospitalBedsDistances = {
                    label = "Afstanden",
                },
                hospitalBedsGeneral = {
                    label = "Algemeen",
                },
                hospitalBedsGetupAnimation = {
                    label = "Getup-animatie",
                },
                hospitalBedsModels = {
                    label = "Modellen",
                },
                hospitalBedsOffsets = {
                    label = "Compensaties",
                },
                hospitalBlip = {
                    label = "Ziekenhuis Blip",
                },
                imagingGeneral = {
                    label = "Algemeen",
                },
                imagingRanges = {
                    label = "Bereiken",
                },
                keybinds = {
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                    label = "Toetsen",
                },
                knockoutGeneral = {
                    label = "Algemeen",
                },
                knockoutWeapons = {
                    label = "Wapens",
                },
                medicCarryAttach = {
                    label = "Bijvoegen",
                },
                medicCarryAttachOffsets = {
                    label = "Compensaties",
                },
                medicCarryAttachRotation = {
                    label = "Rotatie",
                },
                medicCarryCarrierAnimation = {
                    label = "Carrier-animatie",
                },
                medicCarryGeneral = {
                    label = "Algemeen",
                },
                medicCarryPassengerAnimation = {
                    label = "Passagiersanimatie",
                },
                medicCarryRestrictions = {
                    label = "Beperkingen",
                },
                medicRevivePersistence = {
                    label = "Algemeen",
                },
                medicalEvaluationRecipients = {
                    label = "Ontvangers",
                },
                medicalEvaluationSharing = {
                    label = "Gedeelde velden",
                },
                medicalEvaluationTypes = {
                    label = "Evaluatietypes",
                },
                medicalEvaluationsGeneral = {
                    label = "Algemeen",
                },
                medicalWearablesArmRestrictions = {
                    label = "Beperkingen van armgips",
                },
                medicalWearablesCasts = {
                    label = "Gipsverbanden",
                },
                medicalWearablesDuration = {
                    label = "Draagtijd",
                },
                medicalWearablesGeneral = {
                    label = "Algemeen",
                },
                medicalWearablesHeadBandage = {
                    label = "Hoofdverband",
                },
                medicalWearablesLegRestrictions = {
                    label = "Beperkingen van beengips",
                },
                medicalWearablesNeckBrace = {
                    label = "Nekbrace",
                },
                medicalWearablesOxygenMask = {
                    label = "Zuurstofmasker",
                },
                medicalWearablesPatientHud = {
                    label = "Patiënten-HUD",
                },
                medicalWearablesRemoval = {
                    label = "Verwijderen",
                },
                medicalWearablesSplints = {
                    label = "Spalken",
                },
                medicalWearablesTorsoBandage = {
                    label = "Rompverband",
                },
                minigamesCprGeneral = {
                    label = "Algemeen",
                },
                minigamesEnabled = {
                    label = "Ingeschakeld",
                },
                minigamesVentilationGeneral = {
                    label = "Algemeen",
                },
                operationsAnesthesia = {
                    label = "Anesthesie",
                },
                operationsDistances = {
                    label = "Afstanden",
                },
                operationsDoctorAnimation = {
                    label = "Artsanimatie",
                },
                operationsGeneral = {
                    label = "Algemeen",
                },
                operationsPatientAnimation = {
                    label = "Patiëntanimatie",
                },
                operationsTrainingAnimation = {
                    label = "Trainingsanimatie",
                },
                propPlacement = {
                    label = "Prop-plaatsing",
                },
                propPlacementItems = {
                    label = "Prop-items",
                },
                publicTreatmentGeneral = {
                    label = "Algemeen",
                },
                publicTreatmentJobs = {
                    label = "Toegestane banen",
                },
                publicTreatmentRequirements = {
                    label = "Vereisten",
                },
                reviveRewardGeneral = {
                    label = "Algemeen",
                },
                reviveRewardPayment = {
                    label = "Betaling",
                },
                selfDiagnoseGeneral = {
                    label = "Algemeen",
                },
                stretcherAnimation = {
                    label = "Animatie",
                },
                stretcherCarryAttach = {
                    label = "Draag bijlage",
                },
                stretcherFolded = {
                    label = "Gevouwen variant",
                },
                stretcherFoldedPatientAttach = {
                    label = "Gevouwen patiëntbevestiging",
                },
                stretcherGeneral = {
                    label = "Algemeen",
                },
                stretcherHelicopter = {
                    label = "Helikopter",
                },
                stretcherPatientAttach = {
                    label = "Patiënt bijlage",
                },
                stretcherTreatmentAnim = {
                    label = "Animatie",
                },
                stretcherVehicleAttach = {
                    label = "Voertuigbevestiging",
                },
                stretcherVehicleLists = {
                    label = "Voertuigmodellen",
                },
                treatmentAnim = {
                    label = "Animatie",
                },
                treatmentEnable = {
                    label = "Inschakelen",
                },
                trunk = {
                    label = "Kofferbak",
                },
                vehiclePullGeneral = {
                    label = "Algemeen",
                },
                wheelchairAssign = {
                    label = "Opdracht",
                },
                wheelchairDuration = {
                    label = "Duur",
                },
                wheelchairGeneral = {
                    label = "Algemeen",
                },
                wheelchairItems = {
                    label = "Voorwerp",
                },
                wheelchairRestrictions = {
                    label = "Beperkingen",
                },
                xrayGeneral = {
                    label = "Algemeen",
                },
                xrayRanges = {
                    label = "Bereiken",
                },
                appointmentsGeneral = {
                    label = "Algemeen",
                },
                appointmentsLimits = {
                    label = "Limieten",
                },
                appointmentsNotifications = {
                    label = "Meldingen",
                },
                appointmentsScheduling = {
                    label = "Planning",
                },
                healthCompatibility = {
                    label = "Compatibiliteit op gezondheidsgebied",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Algemeen",
                },
                minigamesRandomization = {
                    label = "Randomisatie",
                },
            },
            settingSections = {
                billing = "Facturering",
                bodyBag = "Lijkzak",
                damageHandling = "Schadeafhandeling",
                death = "Dood",
                deathScreen = "Doodsscherm",
                diagnose = "Diagnose",
                doctorNpc = "Dokter NPC",
                general = "Algemeen",
                healthInsurance = "Ziektekostenverzekering",
                hospitalBeds = "Ziekenhuisbedden",
                knockout = "Knock-out",
                medicCarry = "Medic draagt",
                minigames = "Minigames",
                mobilityAid = "Mobiliteitshulpmiddelen",
                operations = "Operaties",
                organization = "Organisatie",
                rewards = "Beloningen",
                treatment = "Behandeling",
                vehiclePull = "Voertuig trekken",
            },
            settingSubsections = {
                aiMedic = "AI-arts",
                anesthesia = "Anesthesie",
                animation = "Animatie",
                animations = "Animaties",
                attach = "Bijvoegen",
                bedAnimation = "Bedanimatie",
                blood = "Bloed",
                bodyBagDeliveryReward = "Beloning voor levering van lijkzak",
                carrierAnimation = "Carrier-animatie",
                classification = "Classificatie",
                cpr = "CPR",
                crutch = "Kruk",
                deathInjuries = "Doodsverwondingen",
                deathScreenStyle = "Doodsschermstijl",
                deathTimeout = "Time-out voor de dood",
                delivery = "Levering",
                diagnoseAnim = "Diagnose van animatie",
                dispatch = "Verzenden",
                earlyRespawn = "Vroege respawn",
                effects = "Effecten",
                firstAid = "E.H.B.O",
                general = "Algemeen",
                getupAnimation = "Getup-animatie",
                imaging = "Beeldvorming",
                information = "Informatie",
                keybinds = "Toetsen",
                liveDamage = "Levende schade",
                logs = "Logboeken",
                medicRevivePersistence = "Medic herleeft doorzettingsvermogen",
                medicalEvaluations = "Medische beoordelingen",
                medicalWearables = "Medische hulpmiddelen",
                medications = "Medicijnen",
                minigame = "Minispel",
                passengerAnimation = "Passagiersanimatie",
                pricing = "Prijzen",
                propPlacement = "Prop-plaatsing",
                publicTreatment = "Openbare behandeling",
                respawn = "Herspawnen",
                reviveInBed = "Herleef in bed",
                reviveReward = "Beloning nieuw leven inblazen",
                selfDiagnose = "Zelfdiagnose",
                stretcher = "Brancard",
                stretcherTreatmentAnim = "Animatie voor brancardbehandeling",
                thresholds = "Drempels",
                treatmentAnim = "Behandeling Animatie",
                trunk = "Kofferbak",
                vehicleImpact = "Voertuigimpact",
                ventilation = "Ventilatie",
                wheelchair = "Rolstoel",
                xray = "X-Ray",
                appointments = "Afspraken",
                bloodTransfusion = "Bloedtransfusie",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor · Besturing 172",
                    description = "Configuraties: Editor: Omhoog.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor · Besturing 173",
                    description = "Configuraties: Editor: Naar beneden.",
                },
                ambulanceEditorControl174 = {
                    label = "Editor · Besturing 174",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl175 = {
                    label = "Editor · Besturing 175",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl177 = {
                    label = "Editor · Besturing 177",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl201 = {
                    label = "Editor · Besturing 201",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl202 = {
                    label = "Editor · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl21 = {
                    label = "Editor · Besturing 21",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl32 = {
                    label = "Editor · Besturing 32",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl33 = {
                    label = "Editor · Besturing 33",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl34 = {
                    label = "Editor · Besturing 34",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl35 = {
                    label = "Editor · Besturing 35",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl36 = {
                    label = "Editor · Besturing 36",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl37 = {
                    label = "Editor · Besturing 37",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl38 = {
                    label = "Editor · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceEditorControl44 = {
                    label = "Editor · Besturing 44",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Eerste hulp · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interactie · Besturing 177",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interactie · Besturing 201",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interactie · Besturing 202",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interactie · Besturing 21",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interactie · Besturing 241",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interactie · Besturing 242",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interactie · Besturing 25",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interactie · Besturing 32",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interactie · Besturing 33",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interactie · Besturing 34",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interactie · Besturing 35",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interactie · Besturing 36",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interactie · Besturing 38",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interactie · Besturing 44",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                billingAccount = {
                    description = "Verouderd fallback society-account dat wordt gebruikt voor facturering.",
                    label = "Rekening",
                },
                billingCloseOnSuccess = {
                    description = "Sluit de factureringsinterface automatisch na een succesvolle factuur.",
                    label = "Sluit af bij succes",
                },
                billingCurrency = {
                    description = "Optionele valutasleutel die wordt gebruikt voor factureringsbetalingen.",
                    label = "Munteenheid",
                },
                billingCustomBillingReasons = {
                    description = "Sta artsen toe aangepaste factureringsredenen in te voeren.",
                    label = "Aangepaste redenen",
                },
                billingDepositToSociety = {
                    description = "Stort de factuuropbrengsten op de rekening van de vereniging.",
                    label = "Storting aan de samenleving",
                },
                billingEnabled = {
                    description = "Schakel het medische factureringssysteem in.",
                    label = "Ingeschakeld",
                },
                billingMaxReasonLength = {
                    description = "Maximale lengte van aangepaste factureringsredenen.",
                    label = "Maximale redenlengte",
                },
                billingMode = {
                    description = "Kies of medische rekeningen direct in rekening worden gebracht, bevestiging vereisen of het raamwerkfactureringssysteem gebruiken.",
                    label = "Factureringsmodus",
                    options = {
                        consent = "Betalen of weigeren",
                        framework = "Kaderwetsvoorstel",
                        instant = "Direct opladen",
                    },
                },
                billingRange = {
                    description = "Maximaal bereik voor het vinden van factureerbare patiënten.",
                    label = "Bereik",
                },
                billingReasonPresets = {
                    description = "Vooraf ingestelde factureringsredenen weergegeven in de factureringsinterface.",
                    itemLabel = "Reden",
                    label = "Voorinstellingen voor redenen",
                },
                billingRefreshSeconds = {
                    description = "Seconden tussen vernieuwingen van factureerbare spelers.",
                    label = "Vernieuw seconden",
                },
                bladeWeapons = {
                    description = "Wapennamen of hashes die moeten worden geclassificeerd als messchade in plaats van bot.",
                    itemLabel = "Wapen",
                    label = "Blade-wapens",
                },
                bleedingBlacklist = {
                    description = "Wapens die nooit bloedingen of open wonden mogen veroorzaken.",
                    itemLabel = "Wapen",
                    label = "Bloedende zwarte lijst",
                },
                bleedingClassesProfiles = {
                    description = "Profielen van de ernst van bloedingen en hun bloedverliespercentage.",
                    label = "Bloedende lessen",
                },
                bloodSystemDebugLogInterval = {
                    description = "Seconden tussen debuglogberichten van het bloedsysteem.",
                    label = "Interval voor foutopsporingslogboek",
                },
                bloodSystemMaxVolume = {
                    description = "Maximale bloedvolumewaarde gebruikt door het patiëntstatussysteem.",
                    label = "Maximaal volume",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passieve bloedregeneratie wordt toegepast wanneer de patiënt niet actief bloedt.",
                    label = "Regen per seconde",
                },
                bloodSystemTickIntervalMs = {
                    description = "Servertikinterval gebruikt voor bloedverlies- en herstelupdates.",
                    label = "Tikinterval ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Bloedvolumedrempel waaronder de patiënt bewusteloos raakt.",
                    label = "Onbewuste drempel",
                },
                bodyBagAnimationDict = {
                    description = "Animatiewoordenboek gebruikt voor het dragen van een lijkzak.",
                    label = "Animatiewoordenboek",
                },
                bodyBagAnimationEnabled = {
                    description = "Gebruik een speciale draaganimatie terwijl je een lijkzak draagt.",
                    label = "Ingeschakeld",
                },
                bodyBagAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt voor de carry-animatie.",
                    label = "Animatie vlag",
                },
                bodyBagAnimationName = {
                    description = "Animatieclip gebruikt voor het dragen van een lijkzak.",
                    label = "Animatienaam",
                },
                bodyBagAttachBone = {
                    description = "Ped-botnaam of bot-ID gebruikt voor de lijkzakbevestiging.",
                    label = "Bot",
                },
                bodyBagAttachRx = {
                    description = "Lijkzak bevestigt X-rotatie.",
                    label = "RX bevestigen",
                },
                bodyBagAttachRy = {
                    description = "Lijkzak bevestigt Y-rotatie.",
                    label = "Bevestig RY",
                },
                bodyBagAttachRz = {
                    description = "Lijkzak bevestigt Z-rotatie.",
                    label = "Voeg RZ toe",
                },
                bodyBagAttachX = {
                    description = "Lijkzakbevestiging X offset.",
                    label = "X bijvoegen",
                },
                bodyBagAttachY = {
                    description = "Lijkzakbevestiging Y-offset.",
                    label = "Bevestig Y",
                },
                bodyBagAttachZ = {
                    description = "Lijkzak bevestigd Z-offset.",
                    label = "Bevestig Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Landcode die wordt gebruikt voor de hulpprompt voor het afgeven van lijkzakken.",
                    label = "Help labelsleutel",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Afstand gebruikt voor validatie van de lijkzakafgifte.",
                    label = "Interactie afstand",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Controle-ID gebruikt voor interacties met het afgeven van lijkzakken.",
                    label = "Interactie sleutel",
                },
                bodyBagDeliveryInteraction = {
                    description = "Interactiesjabloonsleutel gebruikt voor het afgeven van lijkzakken.",
                    label = "Interactie sjabloon",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Vereisen dat artsen lijkzakken afgeven bij geconfigureerde afleverpunten.",
                    label = "Vereist drop-off",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Vereisen dat er artsen aanwezig zijn voordat de lijkzak wordt afgeleverd.",
                    label = "Vereist in dienst",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Primaire accountsleutel die wordt gebruikt voor beloningen voor het bezorgen van lijkzakken.",
                    label = "Rekening",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Primair accounttype dat wordt gebruikt voor beloningen voor het bezorgen van lijkzakken.",
                    label = "Accounttype",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Beloningsbedrag betaald voor het bezorgen van een lijkzak.",
                    label = "Hoeveelheid",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt voor beloningen voor het bezorgen van lijkzakken.",
                    label = "Munteenheid",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Betaal een geconfigureerde beloning nadat de levering van een lijkzak is voltooid.",
                    label = "Ingeschakeld",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Trek de beloningen voor het bezorgen van lijkzakken af ​​van de gedeelde banenvereniging voordat u de dokter betaalt.",
                    label = "Betalen vanuit de samenleving",
                },
                bodyBagEnabled = {
                    description = "Schakel het lijkzaksysteem in.",
                    label = "Ingeschakeld",
                },
                bodyBagHidePatient = {
                    description = "Verberg de patiëntpedo terwijl de lijkzak is bevestigd.",
                    label = "Patiënt verbergen",
                },
                bodyBagModel = {
                    description = "Propmodel gebruikt voor lijkzakken.",
                    label = "Model",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha bracht de patiënt aan terwijl hij in een bodybag zat.",
                    label = "Patiënt alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Maximale afstand voor het toewijzen van een kruk aan een andere speler.",
                    label = "Wijs maximale afstand toe",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Schakel de kruk automatisch uit wanneer de opdracht afloopt.",
                    label = "Automatisch uitrusten bij verlopen",
                },
                crutchClipset = {
                    description = "Bewegingsclipset aangebracht tijdens gebruik van de kruk.",
                    label = "Clipset",
                },
                crutchDefaultDurationMinutes = {
                    description = "Standaard toegewezen krukduur in minuten.",
                    label = "Standaardduur",
                },
                crutchDisableSprint = {
                    description = "Bloksprinten terwijl een kruk is uitgerust.",
                    label = "Sprint uitschakelen",
                },
                crutchDisableWeapons = {
                    description = "Blokkeer wapengebruik terwijl een kruk is uitgerust.",
                    label = "Schakel wapens uit",
                },
                crutchItemName = {
                    description = "Inventarisitem gebruikt voor de kruk.",
                    label = "Artikelnaam",
                },
                crutchMaxDurationMinutes = {
                    description = "Maximaal toegestane duur van de kruktoewijzing in minuten.",
                    label = "Maximale duur",
                },
                crutchMinDurationMinutes = {
                    description = "Minimaal toegestane duur van de kruktoewijzing in minuten.",
                    label = "Minimale duur",
                },
                crutchProp = {
                    description = "Propmodel gebruikt voor de kruk.",
                    label = "Object",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Seconden waarin afzonderlijke treffers in één bericht worden verzameld.",
                    label = "Bundelinterval",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maximaal aantal afzonderlijke treffers per Discord-bericht.",
                    label = "Treffers per bericht",
                },
                damageLogsEnabled = {
                    description = "Stuur door de server bevestigde niet-dodelijke treffers naar Discord.",
                    label = "Schadelogs",
                },
                deathAnimalAnimationDictionary = {
                    description = "Animatiewoordenboek gebruikt voor de animatie van de dood van dieren.",
                    label = "Dierenwoordenboek",
                },
                deathAnimalAnimationName = {
                    description = "Animatieclip gebruikt voor de animatie van de terugvaldood van dieren.",
                    label = "Naam van dierenanimatie",
                },
                deathAnimalUseAnimation = {
                    description = "Laat de geconfigureerde terugval van het dier een scripted death-animatie gebruiken.",
                    label = "Dierenanimatie",
                },
                deathAnimationDictionary = {
                    description = "Animatiewoordenboek gebruikt voor de standaard doodsanimatie.",
                    label = "Animatiewoordenboek",
                },
                deathAnimationName = {
                    description = "Animatieclip gebruikt voor de standaard doodsanimatie.",
                    label = "Animatienaam",
                },
                deathInjuriesProfiles = {
                    description = "Blessureprofielen die worden toegepast wanneer een speler door een specifieke oorzaak overlijdt.",
                    itemLabel = "Blessure",
                    label = "Dood verwondingen",
                },
                deathModels = {
                    description = "Overschrijf het doodsanimatiegedrag per ped-model of model-hash.",
                    label = "Modeloverschrijvingen",
                },
                deathScreenAiMedicAccount = {
                    description = "Primaire account in rekening gebracht voor de AI-medicus.",
                    label = "Rekening",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Seconden toegevoegd aan de aflooptimer wanneer de AI-medic wordt gevraagd.",
                    label = "Doodtimer toevoegen",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Laat de AI-medicus dodelijke wonden doen herleven.",
                    label = "Laat dodelijke wonden toe",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Afstand waarop de AI-medic stopt en te voet nadert.",
                    label = "Benader afstand",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Cooldown voordat de AI-medicus opnieuw kan worden opgeroepen.",
                    label = "Afkoelseconden",
                },
                deathScreenAiMedicCurrency = {
                    description = "Optionele valutasleutel die wordt gebruikt voor AI-medicijnbetalingen.",
                    label = "Munteenheid",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Valutaformatter gebruikt voor AI-medicijnbetalingen.",
                    label = "Valuta formatter",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Seconden voordat de AI-medicus despawnt nadat hij klaar is.",
                    label = "Despawn-vertraging",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Vertraging voordat de AI-medicus begint.",
                    label = "Verzending vertraging",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Rijsnelheid gebruikt door het AI-medicijnvoertuig.",
                    label = "Rijsnelheid",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximale aandrijftijd voordat force-reviving wordt geactiveerd.",
                    label = "Time-out van de rit",
                },
                deathScreenAiMedicEnabled = {
                    description = "Schakel de AI-medic-reddingsstroom in.",
                    label = "Ingeschakeld",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Reserveaccount dat wordt gebruikt wanneer het primaire AI-medic-account onvoldoende saldo heeft.",
                    label = "Reserverekening",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Forceer een herleving als de AI-medicus de speler niet kan bereiken.",
                    label = "Herleven forceren ingeschakeld",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "AI-medic werkt alleen zolang de dienstdoende medici op of onder dit aantal zitten.",
                    label = "Max dokters online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximale missieduur voordat force-revive-triggers worden geactiveerd.",
                    label = "Time-out van de missie",
                },
                deathScreenAiMedicPedModel = {
                    description = "Ped-model gebruikt voor de AI-medic.",
                    label = "Ped-model",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Bestemming wanneer de neergehaalde speler zelf de AI-medicus oproept.",
                    label = "Bestemming van spelersverzoek",
                    options = {
                        hospital = "Ziekenhuis",
                        location = "Huidige locatie",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Prijs die in rekening wordt gebracht voor het bellen van de AI-medicus.",
                    label = "Prijs",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Seconden na de dood van de speler voordat een medicus een AI-medicus op afstand kan aanbieden.",
                    label = "Wachttijd voor verzending op afstand",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Geef medici de mogelijkheid om de AI-medic naar een neergehaalde speler te sturen vanaf de verzendkaart en het /aimedic-commando.",
                    label = "Verzending op afstand",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Het op afstand verzenden van AI-medici werkt alleen als de dienstdoende medici zich op of onder dit aantal bevinden.",
                    label = "Max. Medics online op afstand verzenden",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Bestemming wanneer een AI-medicus op afstand wordt verzonden en geaccepteerd.",
                    label = "Bestemming van verzending op afstand",
                    options = {
                        hospital = "Ziekenhuis",
                        location = "Huidige locatie",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Seconden waarin de speler een aanbod voor een AI-medicus op afstand kan accepteren.",
                    label = "Time-out van aanbod op afstand",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Vereiste afstand voordat de AI-medicus weer tot leven komt.",
                    label = "Herleef afstand",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Seconden besteed aan het reanimeren van de speler.",
                    label = "Duur herleven",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleporteer de speler naar een ziekenhuisbed in plaats van ter plekke weer tot leven te komen.",
                    label = "Kom weer tot leven in bed",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Zoekradius gebruikt om een ​​Revive-bed te vinden.",
                    label = "Zoekradius voor bedden",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Seconden na de dood voordat de AI-medicus beschikbaar komt.",
                    label = "Seconden tot beschikbaar",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximale spawnradius van AI-medici.",
                    label = "Spawnradius max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimale spawnradius van AI-medici.",
                    label = "Spawnradius min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Voertuigmodel gebruikt door de AI-medic.",
                    label = "Voertuigmodel",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Stemmodus bij bewusteloosheid: geen, luister of vol.",
                    label = "Stemmodus",
                    options = {
                        full = "vol",
                        listen = "luisteren",
                        none = "geen",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Controle-ID's die ingeschakeld blijven terwijl ze bewusteloos zijn.",
                    label = "Toegestane controles",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Laat spelers automatisch respawnen als de aflooptimer al is verlopen terwijl de verbinding was verbroken.",
                    label = "Automatische respawn verlopen, opnieuw verbinding maken",
                },
                deathScreenBackgroundEnd = {
                    description = "Eindkleur van de achtergrond van het doodsscherm.",
                    label = "Achtergrond einde",
                },
                deathScreenBackgroundStart = {
                    description = "Startkleur van de achtergrond van het doodsscherm.",
                    label = "Achtergrond begin",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Seconden voordat de aflooptimer afloopt.",
                    label = "Aftaptimer",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensies waar de respawnstroom van het doodsscherm wordt geblokkeerd.",
                    label = "Geblokkeerde afmetingen",
                },
                deathScreenBorderColor = {
                    description = "Randkleur gebruikt door het doodsscherm.",
                    label = "Randkleur",
                },
                deathScreenDispatchEnabled = {
                    description = "Verzend verzendingsgebeurtenissen vanuit de doodsschermstroom.",
                    label = "Verzending ingeschakeld",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Vervangende ontvangers wanneer geen primaire ontvanger in leven en in dienst is. Laat leeg om altijd de primaire banen te alarmeren.",
                    itemLabel = "Baan",
                    label = "Vervangende banen",
                },
                deathScreenDispatchJobs = {
                    description = "Banen die worden gealarmeerd wanneer een uitgeschakelde speler hulp vraagt.",
                    itemLabel = "Baan",
                    label = "Gealarmeerde banen",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Primaire account wordt in rekening gebracht voor vroege respawn.",
                    label = "Rekening",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Houd vroege respawning beschikbaar, zelfs bij dodelijke wonden.",
                    label = "Laat dodelijke wonden toe",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Optionele valutasleutel die wordt gebruikt voor vroege respawningbetalingen.",
                    label = "Munteenheid",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Valutaformatter gebruikt voor vroege respawningbetalingen.",
                    label = "Valuta formatter",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Schakel betaalde vroege respawn in.",
                    label = "Ingeschakeld",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Reserverekening die wordt gebruikt wanneer het primaire account onvoldoende saldo heeft.",
                    label = "Reserverekening",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Optioneel label getoond voor de vroege respawningbetaling.",
                    label = "Betaallabel",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Prijs die in rekening wordt gebracht voor een vroege respawn.",
                    label = "Prijs",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Sta alleen een vroege respawn toe als er geen medici aanwezig zijn.",
                    label = "Geen medicijnen nodig",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Seconden na de dood voordat vroege respawn beschikbaar komt.",
                    label = "Seconden tot beschikbaar",
                },
                deathScreenEnableKeyboard = {
                    description = "Sta toetsenbordgebruik toe op het doodsscherm.",
                    label = "Toetsenbord inschakelen",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Externe stem-backend om te dempen indien ingeschakeld.",
                    label = "Extern spraaksysteem",
                    options = {
                        saltychat = "zoutje",
                        yaca = "jaca",
                    },
                },
                deathScreenFocusKey = {
                    label = "Muisbediening van het doodscherm",
                    description = "Standaardtoets voor FiveM, bijvoorbeeld E, F6 of MOUSE_BUTTON:MOUSE_RIGHT. Leeg betekent geen standaardtoets. Spelers kunnen hun toetsen wijzigen in de FiveM-instellingen; opgeslagen persoonlijke toewijzingen blijven behouden.",
                },
                deathScreenHandlingMode = {
                    description = "Gebruik de statische doodsanimatie of behoud natuurlijke ragdollfysica totdat het lichaam stabiel ligt.",
                    label = "Doodafhandeling",
                    options = {
                        natural = "Natuurlijk",
                        static = "Statisch",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Verbergt het doodsscherm nadat SPATIE naar spelbesturing schakelt; schakel dit uit om de eerdere zichtbare overlay te behouden.",
                    label = "Overlay verbergen bij spelbesturing",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Hoogteverschuiving toegepast op het focusdoel van de camera.",
                    label = "Focushoogte",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Voorbeeld van het gezichtsveld van de camera.",
                    label = "Gezichtsveld",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Koersafwijking gebruikt bij het plaatsen van de voorbeeldcamera.",
                    label = "Koersafwijking",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Hoogteverschuiving toegepast op de voorbeeldcamera.",
                    label = "Camerahoogte",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Pitch toegepast op de voorbeeldcamera.",
                    label = "Toonhoogte",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Afstand van de voorbeeldcamera tot het spawnpunt.",
                    label = "Cameraradius",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Zorg voor een vloeiende overgang bij het openen van de ziekenhuisselectiecamera.",
                    label = "Vlotte overgang",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Laat spelers een ziekenhuis selecteren voordat ze respawnen.",
                    label = "Ziekenhuis selectie",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Toon ziekenhuisselectie alleen als er meer dan één ziekenhuis bestaat.",
                    label = "Meerdere ziekenhuizen nodig",
                },
                deathScreenInformationEnabled = {
                    description = "Toon het informatieblok op het doodsscherm.",
                    label = "Ingeschakeld",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Toon de doodsoorzaak in het informatieblok van het overlijdensscherm.",
                    label = "Doodsoorzaak weergeven",
                },
                deathScreenInformationShowInjuries = {
                    description = "Toon verwondingen in het informatieblok van het overlijdensscherm.",
                    label = "Laat verwondingen zien",
                },
                deathScreenInformationShowKiller = {
                    description = "Toon de naam van de moordenaar in het informatieblok van het doodsscherm.",
                    label = "Showmoordenaar",
                },
                deathScreenInformationShowWeapon = {
                    description = "Toon het wapen in het informatieblok van het doodsscherm.",
                    label = "Toon wapen",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangs op de whitelist",
                    description = "Selecteer interne gang- of organisatienamen. Een overeenkomende job of gang geeft de toestemming of uitzondering. Dienstplicht geldt alleen voor jobs.",
                    itemLabel = "Bende",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Jobs mocht uitgebreide doodsscherminformatie zien.",
                    itemLabel = "Functie",
                    label = "Vacatures op de witte lijst",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximaal aantal seconden voor elke upload van een overlijdenscreenshot.",
                    label = "Screenshot-time-out",
                },
                deathScreenLogScreenshots = {
                    description = "Upload het perspectief van slachtoffer en bevestigde dader na het tekstlog.",
                    label = "Schermafbeeldingen",
                },
                deathScreenLogsEnabled = {
                    description = "Stuur een Discord-log wanneer een speler overlijdt.",
                    label = "Overlijdenslogs",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Afstand in meters die wordt gebruikt om een ​​arts als dichtbij te beschouwen.",
                    label = "Medic nabijgelegen straal",
                },
                deathScreenMinigameEnabled = {
                    description = "Schakel de minigame Death Screen in.",
                    label = "Ingeschakeld",
                },
                deathScreenMinigameUrl = {
                    description = "URL geopend voor de death screen-minigame.",
                    label = "Minigame-URL",
                },
                deathScreenMode = {
                    description = "Gebruik het ingebouwde doodsscherm of een externe integratie.",
                    label = "Schermmodus",
                    options = {
                        external = "Extern",
                        internal = "Intern",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Demp externe stemsystemen terwijl de speler dood is.",
                    label = "Externe stem dempen",
                },
                deathScreenMutedTextColor = {
                    description = "Gedempte tekstkleur gebruikt door het doodsscherm.",
                    label = "Gedempte tekstkleur",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Toont gedetailleerde client- en serverredenen zolang het lichaam in ragdoll blijft.",
                    label = "Debug natuurlijke ragdoll",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Stabiliseer stil liggende lichamen automatisch of laat een hulpverlener in dienst ze in de stabiele zijligging leggen.",
                    label = "Natuurlijke stabilisatie",
                    options = {
                        automatic = "Automatisch",
                        medic = "Hulpverlener vereist",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Achtergrondkleur van paneel gebruikt door het doodsscherm.",
                    label = "Paneelachtergrond",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Blokkeer automatische respawn na afloop.",
                    label = "Voorkom automatisch respawnen",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Blokkeer automatische respawn terwijl er een hospik in de buurt is.",
                    label = "Blokkeer wanneer dokter in de buurt is",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Blok herleeft nadat de aflooptimer is verstreken.",
                    label = "Voorkom heropleving bij het verstrijken van de geldigheidsduur",
                },
                deathScreenPrimaryColor = {
                    description = "Basis CSS-kleur gebruikt voor het death screen-thema.",
                    label = "Primaire kleur",
                },
                deathScreenPrimaryDark = {
                    description = "Optionele donkerdere accentkleur voor het doodsscherm.",
                    label = "Primair donker",
                },
                deathScreenPrimaryStrong = {
                    description = "Optionele sterkere accentkleur voor het doodsscherm.",
                    label = "Primair sterk",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Koers die wordt gebruikt als voor het station geen koers is gedefinieerd.",
                    label = "Standaardkop",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Terugval- respawnkop die wordt gebruikt als er geen ziekenhuisposities zijn.",
                    label = "Terugvalrubriek",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Fallback respawn X-coördinaat gebruikt als er geen ziekenhuisposities bestaan.",
                    label = "Terugval X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Fallback respawn Y-coördinaat gebruikt als er geen ziekenhuisposities bestaan.",
                    label = "Terugval Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Fallback respawn Z-coördinaat gebruikt als er geen ziekenhuisposities bestaan.",
                    label = "Terugval Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Kies een vast ziekenhuis voor respawns. Laat het leeg om het dichtstbijzijnde ziekenhuis te gebruiken.",
                    label = "Herstel ziekenhuis",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Verwijder rekeningsaldi bij respawn.",
                    label = "Accounts verwijderen",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Accountnamen verwijderd bij respawn.",
                    itemLabel = "Rekening",
                    label = "Accountnamen",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Verwijder inventarisitems bij respawn.",
                    label = "Artikelen verwijderen",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Inventarisitems worden bewaard tijdens respawn.",
                    itemLabel = "Voorwerp",
                    label = "Genegeerde items",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Verwijder wapenwielwapens tijdens respawn.",
                    label = "Verwijder wapens",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Wapens bleven op respawn.",
                    itemLabel = "Wapen",
                    label = "Genegeerde wapens",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleporteer de speler naar een ziekenhuis tijdens respawn.",
                    label = "Teleporteren naar het ziekenhuis",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Hervat de aflooptimer nadat u opnieuw verbinding hebt gemaakt, in plaats van deze opnieuw in te stellen.",
                    label = "Hervat bij opnieuw verbinden",
                },
                deathScreenShadowLight = {
                    description = "Zachte schaduwkleur gebruikt door het doodsscherm.",
                    label = "Schaduw licht",
                },
                deathScreenShadowMid = {
                    description = "Middenschaduwkleur gebruikt door het doodsscherm.",
                    label = "Schaduw midden",
                },
                deathScreenShowNearestMedic = {
                    description = "Toon de dichtstbijzijnde dokter op het doodsscherm.",
                    label = "Toon dichtstbijzijnde dokter",
                },
                deathScreenTextColor = {
                    description = "Primaire tekstkleur gebruikt door het doodsscherm.",
                    label = "Tekstkleur",
                },
                deathScreenTextShadow = {
                    description = "Tekstschaduwkleur gebruikt door het doodsscherm.",
                    label = "Tekst schaduw",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Pas de time-out voor de dood ook toe nadat de knock-out weer tot leven is gekomen.",
                    label = "Toepassen op knock-out",
                },
                deathTimeoutSeconds = {
                    description = "Seconden na een heropleving blijft dat gevecht uitgeschakeld.",
                    label = "Seconden",
                },
                deathTimeoutShowUi = {
                    description = "Toon de aftelbanner voor de doodstime-out terwijl deze actief is.",
                    label = "Toon gebruikersinterface",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangs op de whitelist",
                    description = "Selecteer interne gang- of organisatienamen. Een overeenkomende job of gang geeft de toestemming of uitzondering. Dienstplicht geldt alleen voor jobs.",
                    itemLabel = "Bende",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Banen zijn vrijgesteld van de time-outbeperkingen bij overlijden.",
                    itemLabel = "Functie",
                    label = "Vacatures op de witte lijst",
                },
                deathUseAnimation = {
                    description = "Speel de geconfigureerde doodsanimatie voor ondersteunde peds.",
                    label = "Gebruik animatie",
                },
                diagnoseAnimClip = {
                    description = "Animatieclip gebruikt tijdens het openen van Diagnose. Laat leeg als u in plaats daarvan een scenario wilt gebruiken.",
                    label = "Animatienaam",
                },
                diagnoseAnimDict = {
                    description = "Animatiewoordenboek gebruikt bij het openen van diagnose. Laat leeg als u in plaats daarvan een scenario wilt gebruiken.",
                    label = "Animatiewoordenboek",
                },
                diagnoseAnimScenario = {
                    description = "Scenario gebruikt bij het openen van diagnose. Laat leeg om in plaats daarvan dict + clip te gebruiken.",
                    label = "Scenario",
                },
                diagnoseCprAnimDict = {
                    description = "Animatiewoordenboek gebruikt voor reanimatie.",
                    label = "Animatiewoordenboek",
                },
                diagnoseCprAnimName = {
                    description = "Animatieclip gebruikt voor reanimatie.",
                    label = "Animatienaam",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Vereiste ononderbroken diagnosetijd voordat volledige genezing verschijnt.",
                    label = "Vertraging in seconden",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Reddingsrugzak vereisen",
                    description = "Vereis rescue_backpack om de linker werkbalk met onderzoekstools te tonen. Schakel dit uit om de werkbalk altijd te tonen; de itemvereisten van afzonderlijke tools blijven gelden.",
                },
                diagnoseFullHealEnabled = {
                    description = "Sta volledige genezing toe na een ononderbroken diagnosesessie.",
                    label = "Ingeschakeld",
                },
                diagnoseInteractDistance = {
                    description = "Maximale afstand die nodig is om een ​​patiënt te diagnosticeren of in een bodybag te plaatsen.",
                    label = "Interactie afstand",
                },
                diagnosePatientMovementMode = {
                    label = "Beweging van de patiënt",
                    description = "Zet de patiënt vast zolang een andere speler het behandelmenu open heeft, of sta beweging toe en sluit het menu zodra de behandelafstand wordt overschreden. Zelfdiagnose wordt apart ingesteld.",
                    options = {
                        freeze = "Patiënt vastzetten",
                        distance = "Sluiten bij overschrijden afstand",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Behandelafstand (m)",
                    description = "Maximale afstand tussen behandelaar en patiënt voordat het behandelmenu in afstandsmodus sluit. De afstand om het menu te openen wordt apart ingesteld.",
                },
                diagnoseKey = {
                    description = "Controle-ID gebruikt voor diagnose-interacties.",
                    label = "Interactie sleutel",
                },
                diagnoseOpenDelayMs = {
                    description = "Vertraging voordat de diagnose-UI wordt geopend.",
                    label = "Openvertraging ms",
                },
                diagnosePromptDistance = {
                    description = "Afstand die wordt gebruikt om de diagnoseprompt weer te geven.",
                    label = "Prompt afstand",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Duur gebruikt voor behandelingsanimaties.",
                    label = "Behandelingsduur ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Stort doktersbetalingen op de gedeelde rekening van de samenleving wanneer u rechtstreeks factureert.",
                    label = "Voeg inkomsten toe aan de samenleving",
                },
                doctorNpcEnabled = {
                    description = "Schakel de dokters-NPC-service in.",
                    label = "Ingeschakeld",
                },
                doctorNpcHealOtherAccount = {
                    description = "Primaire accountsleutel die wordt gebruikt om de genezing van een andere speler in rekening te brengen.",
                    label = "Rekening",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Primaire accounttype dat wordt gebruikt om de genezing van een andere speler in rekening te brengen.",
                    label = "Accounttype",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt om de genezing van een andere speler in rekening te brengen.",
                    label = "Munteenheid",
                },
                doctorNpcHealOtherPrice = {
                    description = "Price om een ​​andere speler bij de dokter NPC te genezen.",
                    label = "Prijs",
                },
                doctorNpcHealSelfAccount = {
                    description = "Primaire accountsleutel die wordt gebruikt om zelfherstel in rekening te brengen.",
                    label = "Rekening",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Primair accounttype dat wordt gebruikt om zelfherstel in rekening te brengen.",
                    label = "Accounttype",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt om zelfherstel in rekening te brengen.",
                    label = "Munteenheid",
                },
                doctorNpcHealSelfPrice = {
                    description = "Prijs om jezelf te genezen bij de dokter NPC.",
                    label = "Prijs",
                },
                doctorNpcInteractionRange = {
                    description = "Hoe dicht de gebruiker bij de dokter-NPC moet blijven tijdens het gebruik van het geopende doktersmenu. Dit verandert niets aan de initiële NPC-promptafstand.",
                    label = "Interactie bereik",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Dokter NPC werkt alleen zolang de dienstdoende medici onder deze limiet zitten.",
                    label = "Max dokters online",
                },
                doctorNpcPatientRange = {
                    description = "Hoe dicht de patiënt bij de NPC-arts moet zijn om anderen te genezen of weer aan het werk te krijgen nadat de actie is geselecteerd.",
                    label = "Patiëntenbereik",
                },
                doctorNpcPaymentMode = {
                    description = "Breng spelers onmiddellijk in rekening of stuur een factuur.",
                    label = "Betaalwijze",
                    options = {
                        bill = "rekening",
                        remove = "verwijderen",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Wordt alleen gebruikt om spelers in de buurt weer te geven in de dokter-NPC-gebruikersinterface. Het staat op zichzelf geen behandeling toe.",
                    label = "Scanbereik speler",
                },
                doctorNpcReviveAccount = {
                    description = "Primaire accountsleutel die wordt gebruikt om doktersreanimaties in rekening te brengen.",
                    label = "Rekening",
                },
                doctorNpcReviveAccountType = {
                    description = "Primaire accounttype dat wordt gebruikt om doktersrevisies in rekening te brengen.",
                    label = "Accounttype",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Laat de NPC-arts dodelijke of niet-reanimeerbare verwondingen reanimeren. Een verstreken verbloedingstijd blijft reanimatie blokkeren.",
                    label = "Dodelijke verwondingen toestaan",
                },
                doctorNpcReviveCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt om doktersoplevingen in rekening te brengen.",
                    label = "Munteenheid",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Plaats herstelde spelers in het dichtstbijzijnde ziekenhuisbed nadat een arts is bijgekomen.",
                    label = "Ingeschakeld",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maximale afstand die wordt gebruikt om een ​​ziekenhuisbed in de buurt te vinden waar de arts kan revalideren.",
                    label = "Zoekradius",
                },
                doctorNpcRevivePrice = {
                    description = "Prijs om een ​​speler bij de dokter NPC nieuw leven in te blazen.",
                    label = "Prijs",
                },
                firstAidActionDurationMs = {
                    description = "Hoe lang de EHBO-actie duurt.",
                    label = "Actieduur ms",
                },
                firstAidAnimationDict = {
                    description = "Animatiewoordenboek gebruikt tijdens de EHBO-actie.",
                    label = "Animatiewoordenboek",
                },
                firstAidAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt tijdens de EHBO-actie.",
                    label = "Animatie vlag",
                },
                firstAidAnimationName = {
                    description = "Animatiefragment gebruikt tijdens de EHBO-actie.",
                    label = "Animatienaam",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Seconden toegevoegd aan de bloedingstimer van de patiënt na eerste hulp.",
                    label = "Uitloopverlenging seconden",
                },
                firstAidEnabled = {
                    description = "Schakel de EHBO-functie in voor gelicentieerde spelers.",
                    label = "EHBO ingeschakeld",
                },
                firstAidLicense = {
                    description = "Kaderlicentienaam die wordt gebruikt om de toegang tot eerste hulp te valideren.",
                    label = "Licentienaam",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Laat ambulancepersoneel de EHBO-vergunning afgeven.",
                    label = "Licentie toevoegen ingeschakeld",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Toon de actie voor het toevoegen van een licentie in het radiale menu.",
                    label = "Voeg licentieradiaal toe",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Vereist EMS-dienst voordat de actie voor het toevoegen van een licentie kan worden gebruikt.",
                    label = "Voeg licentie toe, vereist plicht",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Laat ambulancepersoneel de EHBO-vergunning intrekken.",
                    label = "Licentie verwijderen ingeschakeld",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Toon de actie voor het verwijderen van de licentie in het radiale menu.",
                    label = "Licentie radiaal verwijderen",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Vereist EMS-plicht voordat de actie voor het verwijderen van de licentie kan worden gebruikt.",
                    label = "Verwijder licentievereiste plicht",
                },
                firstAidPositionChestOffset = {
                    description = "Borstoffset gebruikt tijdens het uitlijnen voor eerste hulp.",
                    label = "Borstafwijking",
                },
                firstAidPositionSideOffset = {
                    description = "Zijwaartse offset gebruikt tijdens het uitlijnen voor eerste hulp.",
                    label = "Zijwaartse offset",
                },
                firstAidPositionZOffset = {
                    description = "Verticale offset gebruikt tijdens het uitlijnen voor eerste hulp.",
                    label = "Z-offset",
                },
                firstAidRequireLicense = {
                    description = "Vereist de geconfigureerde EHBO-licentie voordat een speler eerste hulp kan gebruiken.",
                    label = "Vereist licentie",
                },
                firstAidTargetDistance = {
                    description = "Maximaal toegestane afstand voor EHBO-gebruik.",
                    label = "Doel afstand",
                },
                healthInsuranceAccount = {
                    description = "Reserverekeningsleutel die wordt gebruikt voor verzekeringsbetalingen.",
                    label = "Rekening",
                },
                healthInsuranceAccountType = {
                    description = "Primair rekeningtype dat wordt gebruikt voor verzekeringsbetalingen.",
                    label = "Accounttype",
                },
                healthInsuranceAvailableDays = {
                    description = "Beschikbare verzekeringsduur in dagen.",
                    label = "Beschikbare dagen",
                },
                healthInsuranceCommand = {
                    description = "Chatopdracht die wordt gebruikt om de gebruikersinterface van de zorgverzekering te openen.",
                    label = "Commando",
                },
                healthInsuranceCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt voor verzekeringsbetalingen.",
                    label = "Munteenheid",
                },
                healthInsuranceEnabled = {
                    description = "Schakel het zorgverzekeringssysteem in.",
                    label = "Ingeschakeld",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Hiermee kunnen bevoegde medewerkers verzekeringsprijzen via de tablet wijzigen. Schakel dit uit om de prijzen uit de onderstaande aanbiederstabel af te dwingen.",
                    label = "Prijsbeheer via tablet",
                },
                healthInsuranceProviders = {
                    description = "Verzekeringsaanbieders aangeboden aan spelers.",
                    itemLabel = "Aanbieder",
                    label = "Aanbieders",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Gebruikt dezelfde aanbieders en polissen voor alle banen die in deze ambulancebron zijn geregistreerd.",
                    label = "Delen tussen ambulancebanen",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Animatiewoordenboek herhaald terwijl de speler op bed ligt. Laat dit leeg om de standaard fallback voor de doodsanimatie te gebruiken.",
                    label = "Animatiewoordenboek",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Optionele handmatige duur voor de loopingbed-animatie. Wordt alleen gebruikt als er een aangepaste bedanimatie is geconfigureerd.",
                    label = "Duur ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt voor de lusbedanimatie. Wordt alleen gebruikt als er een aangepaste bedanimatie is geconfigureerd.",
                    label = "Animatie vlag",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animatieclip wordt herhaald terwijl de speler op bed ligt. Laat dit leeg om de standaard fallback voor de doodsanimatie te gebruiken.",
                    label = "Animatienaam",
                },
                hospitalBedsBreakDistance = {
                    description = "Afstand waarna de speler van het bed wordt gedwongen.",
                    label = "Pauze afstand",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Bekijk een voorbeeld van het ped-model dat wordt gebruikt in de editor voor ziekenhuisbedposities.",
                    label = "Creator ped-model",
                },
                hospitalBedsEnabled = {
                    description = "Schakel geconfigureerde ziekenhuisbedinteracties in.",
                    label = "Ingeschakeld",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Animatiewoordenboek dat wordt afgespeeld wanneer de speler uit bed opstaat. Laat dit leeg om het standaard stand-up-gedrag te gebruiken.",
                    label = "Animatiewoordenboek",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Optionele handmatige duur voor de opsta-animatie. Wordt alleen gebruikt als er een aangepaste opsta-animatie is geconfigureerd.",
                    label = "Duur ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt voor de opsta-animatie. Wordt alleen gebruikt als er een aangepaste opsta-animatie is geconfigureerd.",
                    label = "Animatie vlag",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animatiefragment dat wordt afgespeeld wanneer de speler uit bed opstaat. Laat dit leeg om het standaard stand-up-gedrag te gebruiken.",
                    label = "Animatienaam",
                },
                hospitalBedsHeadingOffset = {
                    description = "Koersafwijking wordt toegepast wanneer de speler op het bed wordt geplaatst.",
                    label = "Koersafwijking",
                },
                hospitalBedsHeightOffset = {
                    description = "Verticale offset toegepast bij het plaatsen van de speler op het bed.",
                    label = "Hoogteverschuiving",
                },
                hospitalBedsInteractDistance = {
                    description = "Maximale afstand die nodig is om een ​​ziekenhuisbed te gebruiken.",
                    label = "Interactie afstand",
                },
                hospitalBedsInteractKey = {
                    description = "Controle-ID die wordt gebruikt om een ​​ziekenhuisbed binnen te gaan of te verlaten.",
                    label = "Interactie sleutel",
                },
                hospitalBedsModels = {
                    description = "Wereldobjectmodellen behandeld als bruikbare ziekenhuisbedden.",
                    itemLabel = "Model",
                    label = "Bedmodellen",
                },
                hospitalBedsSearchRadius = {
                    description = "Radius wordt gebruikt om bedsteunen of geconfigureerde bedden in de buurt te vinden.",
                    label = "Zoekradius",
                },
                hospitalBlipColor = {
                    description = "Blip-kleur-ID gebruikt voor blips op de ziekenhuiskaart.",
                    label = "Kleur",
                },
                hospitalBlipEnabled = {
                    description = "Toon ziekenhuiskaart-blips voor geconfigureerde ziekenhuisposities.",
                    label = "Ingeschakeld",
                },
                hospitalBlipName = {
                    description = "Reserveziekenhuisblip-naam die wordt gebruikt als er geen stationsnaam beschikbaar is.",
                    label = "Naam",
                },
                hospitalBlipScale = {
                    description = "Blip-schaal gebruikt voor blips van ziekenhuiskaarten.",
                    label = "Schaal",
                },
                hospitalBlipSprite = {
                    description = "Blip-sprite-ID gebruikt voor blips op de ziekenhuiskaart.",
                    label = "Sprite",
                },
                imagingInteractionRange = {
                    description = "Maximale afstand tot het beeldstation voor de operator.",
                    label = "Interactie bereik",
                },
                imagingPatientRange = {
                    description = "Maximale afstand tot het beeldstation voor de patiënt.",
                    label = "Patiëntenbereik",
                },
                imagingScanDurationSeconds = {
                    description = "Duur in seconden voor CT- en MRI-scanresultaten.",
                    label = "Scanduur",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Alleen visueel vermenigvuldiger voor overlay-effecten.",
                    label = "Intensiteit van bloedingsoverlay",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Alleen visuele vermenigvuldiger voor pijnschermeffecten.",
                    label = "Intensiteit van het pijnscherm",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Minimumpercentage van maximale gezondheid dat verloren gaat bij één enkele treffer voordat bloedingen en pijn optreden.",
                    label = "Bloeding/pijn min. procent",
                },
                injuryThresholdRespectArmor = {
                    description = "Sla bloedingen en pijn over als de treffer door pantser werd geabsorbeerd.",
                    label = "Respecteer het pantser",
                },
                knockoutRegenerateDamage = {
                    description = "Genereer knock-outschade opnieuw nadat de respawn-timer is verlopen.",
                    label = "Herstel schade",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Seconden waarover knock-outschade wordt hersteld.",
                    label = "Regeneratieduur",
                },
                knockoutRespawnSeconds = {
                    description = "Seconden vóór een automatische respawn wanneer een speler wordt uitgeschakeld.",
                    label = "Respawn seconden",
                },
                knockoutWeapons = {
                    description = "Wapennamen of hashes die een knock-out zouden moeten veroorzaken in plaats van het volledige doodsscherm.",
                    itemLabel = "Wapen",
                    label = "Wapens",
                },
                legShotRagdollChance = {
                    description = "Procentuele kans dat een geldige treffer ragdoll activeert.",
                    label = "Kans",
                },
                legShotRagdollCooldownMs = {
                    description = "Minimale vertraging tussen been-schot ragdolls.",
                    label = "Afkoelen ms",
                },
                legShotRagdollDebug = {
                    description = "Logt ragdoll-beslissingen voor testen.",
                    label = "Debuggen",
                },
                legShotRagdollDurationMs = {
                    description = "Hoe lang de ragdoll duurt.",
                    label = "Duur ms",
                },
                legShotRagdollFeet = {
                    description = "Laat voet-treffers ragdoll activeren.",
                    label = "Voeten",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Slaat ragdoll over als pantser de treffer absorbeerde.",
                    label = "Pantser-treffers negeren",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Laat treffers op het linker onderbeen toe.",
                    label = "Linker onderbeen",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Laat treffers op het linker bovenbeen toe.",
                    label = "Linker bovenbeen",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Alleen schoten mogen ragdoll activeren.",
                    label = "Alleen schoten",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Laat treffers op het rechter onderbeen toe.",
                    label = "Rechter onderbeen",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Laat treffers op het rechter bovenbeen toe.",
                    label = "Rechter bovenbeen",
                },
                liveDamageFracturesChance = {
                    description = "Basiskans dat een bewuste schadehit een breuk veroorzaakt.",
                    label = "Kans",
                },
                liveDamageFracturesEnabled = {
                    description = "Sta toe dat bewuste schade-hits breuken veroorzaken.",
                    label = "Ingeschakeld",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Minimaal percentage van de maximale gezondheid dat door één treffer verloren moet gaan voordat een breuk kan ontstaan.",
                    label = "Minimaal schadepercentage",
                },
                liveDamageFracturesZones = {
                    description = "Breukkansen per zone voor live schade.",
                    label = "Zonekansen",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maximale open-wond stacks per zone zonder zone-override.",
                    label = "Standaard limiet",
                },
                liveOpenWoundStacksZones = {
                    description = "Optionele open-wond stack limieten per zone.",
                    itemLabel = "Gebied",
                    label = "Zone limieten",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Initiële bloedingsklasse toegepast per levende schadeoorzaak.",
                    label = "Live wondbloedingsles",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Sta toe dat de drager een voertuig instapt en bestuurt zonder de patiënt neer te leggen.",
                    label = "Drager in voertuig toestaan",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Laat het dragen van bewuste spelers toe.",
                    label = "Laat bewuste doelen toe",
                },
                medicCarryAllowSprint = {
                    description = "Sta sprinten toe terwijl u een patiënt draagt.",
                    label = "Sprint toestaan",
                },
                medicCarryAttachBone = {
                    description = "Botindex die wordt gebruikt om de gedragen speler vast te maken.",
                    label = "Bot vastmaken",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Draag de steekrotatie.",
                    label = "Toonhoogte",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Draag de rotatie van de rol.",
                    label = "Rollen",
                },
                medicCarryAttachOffsetsX = {
                    description = "Draagbevestiging X-offset.",
                    label = "Verschuiving X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Draag bevestiging Y-offset.",
                    label = "Verschuiving Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Draag de gierrotatie.",
                    label = "Jaaa",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Draagbevestiging Z-offset.",
                    label = "Verschuiving Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Animatiewoordenboek gebruikt door de dokter terwijl hij een patiënt draagt.",
                    label = "Animatiewoordenboek",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt door de medic carry-animatie.",
                    label = "Animatie vlag",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animatieclip gebruikt door de hospik terwijl hij een patiënt draagt.",
                    label = "Animatienaam",
                },
                medicCarryEnabled = {
                    description = "Schakel het doktersdraagsysteem in.",
                    label = "Ingeschakeld",
                },
                medicCarryMaxDistance = {
                    description = "Maximale afstand die nodig is om een ​​patiënt op te halen.",
                    label = "Maximale afstand",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Animatiewoordenboek gebruikt door de gedragen patiënt.",
                    label = "Animatiewoordenboek",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "TaskPlayAnim-vlag gebruikt door de overgedragen patiëntanimatie.",
                    label = "Animatie vlag",
                },
                medicCarryPassengerAnimationName = {
                    description = "Animatieclip gebruikt door de gedragen patiënt.",
                    label = "Animatienaam",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Pas de doodsanimatie opnieuw toe nadat je een bewusteloze patiënt hebt laten vallen.",
                    label = "Pas de doodsanimatie opnieuw toe",
                },
                medicCarryRequireOnDuty = {
                    description = "Alleen dienstdoende medici kunnen een carry starten.",
                    label = "Vereist in dienst",
                },
                medicReviveAllowFatalWounds = {
                    description = "Laat dienstdoende medici dodelijke of niet-reanimeerbare verwondingen behandelen en reanimeren. Een verstreken verbloedingstijd blijft reanimatie blokkeren.",
                    label = "Dodelijke verwondingen toestaan",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Houd onopgeloste blessures na behandeling of checklist weer tot leven.",
                    label = "Houd verwondingen",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Behoud pijnwaarden na behandeling of checklist herleeft wanneer blessures behouden blijven.",
                    label = "Houd pijn",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximale afstand gebruikt om nabijgelegen spelers bij het maken van een medische evaluatie.",
                    label = "Vlakbij patiëntbereik",
                },
                medicalEvaluationRecipientJobs = {
                    description = "beroepen waarvoor medische evaluaties kunnen worden afgegeven en gedeeld.",
                    label = "Ontvangende banen",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Laat de ontvangende beroepen de geboortedatum van de patiënt zien.",
                    label = "Gedeelde geboortedatum",
                },
                medicalEvaluationShareConclusion = {
                    description = "Laat de ontvangende beroepen de medische conclusie zien.",
                    label = "Conclusie over het aandeel",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Ontvangers toestaan te zien welke evaluatietypes zijn uitgevoerd.",
                    label = "Soorten evaluatie van aandelen",
                },
                medicalEvaluationShareFullName = {
                    description = "Laat ontvangende beroepen de volledige naam van de patiënt zien.",
                    label = "Volledige naam delen",
                },
                medicalEvaluationShareGender = {
                    description = "Laat de ontvangende beroepen het geslacht van de patiënt zien.",
                    label = "Gedeeld geslacht",
                },
                medicalEvaluationShareHeight = {
                    description = "Laat de receiver de lengte van de patiënt zien.",
                    label = "Hoogte delen",
                },
                medicalEvaluationShareHobbies = {
                    description = "Laat ontvangende beroepen om de vrije tijd activiteiten en hobby's van de patiënt te zien.",
                    label = "Deel vrijetijdsbesteding en hobby's",
                },
                medicalEvaluationShareIssuer = {
                    description = "Toon de naam van de auteur. De uitgevende job blijft zichtbaar als map bij Gedeelde documenten.",
                    label = "Auteursgegevens delen",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Laat ontvangende beroepen de persoonlijke ID van de patiënt zien.",
                    label = "Delen persoonlijke ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Laat de ontvangende beroepen het beroep van de patiënt zien.",
                    label = "Beroepsdelen",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Ontvangers in staat stellen vragen over de vragenlijst en opgenomen antwoorden te bekijken.",
                    label = "Vragen en antwoorden delen",
                },
                medicalEvaluationShareResult = {
                    description = "Laat de ontvangende beroepen zien of de evaluatie in behandeling is, is geslaagd of niet.",
                    label = "Resultaat van delen",
                },
                medicalEvaluationShareWeight = {
                    description = "Laat ontvangende beroepen het gewicht van de patiënt zien.",
                    label = "Aandeelgewicht",
                },
                medicalEvaluationTypes = {
                    description = "Configureer type evaluatie, vragen, antwoorden en of elke vraag actief is.",
                    label = "Soorten evaluatie en vragenlijsten",
                    options = {
                        boolean = "Ja / Nee",
                        boolean_text = "Ja / Nee met details",
                        date = "Datum",
                        multi_select = "Meerkeuze",
                        number = "Nummer",
                        rating = "Waardering",
                        select = "Eén keuze",
                        text = "Tekst",
                        textarea = "Tekstgebied",
                        time = "Tijd",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Activeer medische evaluaties in de ambulancetablet.",
                    label = "Ingeschakeld",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Biedt een permanente duur die actief blijft totdat een medic het hulpmiddel verwijdert.",
                    label = "Toestaan tot verwijderen",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Voorkomt slagaanvallen wanneer armgips wordt gedragen.",
                    label = "Slagaanvallen uitschakelen",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Dwingt ongewapend gebruik af en voorkomt wisselen van wapen wanneer armgips wordt gedragen.",
                    label = "Wapens uitschakelen",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Past gevechtsbeperkingen toe wanneer armgips wordt gedragen.",
                    label = "Ingeschakeld",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Behandelt de passende breuk wanneer gips of een spalk wordt aangebracht.",
                    label = "Breukintegratie",
                },
                medicalWearablesCastsEnabled = {
                    description = "Staat gips toe op de linker- en rechterarm en -been.",
                    label = "Ingeschakeld",
                },
                medicalWearablesCastsItem = {
                    description = "Voorwerp uit de inventaris dat wordt verbruikt bij het aanbrengen van gips.",
                    label = "Voorwerp",
                },
                medicalWearablesCastsMinigame = {
                    description = "Bestaand behandelminispel dat voor gips wordt gebruikt.",
                    label = "Minispel",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Standaardduur van het medische hulpmiddel in minuten. Stel 0 in voor tot verwijderen.",
                    label = "Standaardminuten",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Duurkeuzes voor medische hulpmiddelen die in minuten aan medics worden getoond.",
                    label = "Duurkeuzes",
                },
                medicalWearablesEnabled = {
                    description = "Schakelt gips-, spalk-, verband-, nekbrace- en zuurstofmaskermodellen in de behandelinterface in.",
                    label = "Ingeschakeld",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Hoe vaak verlopen getimede medische hulpmiddelen worden verwijderd.",
                    label = "Vervaldatumcontrole (seconden)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Staat het hoofdverbandmodel toe.",
                    label = "Ingeschakeld",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Voorwerp uit de inventaris dat voor een hoofdverband wordt verbruikt.",
                    label = "Voorwerp",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Bestaand behandelminispel dat voor een hoofdverband wordt gebruikt.",
                    label = "Minispel",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Voorkomt springen wanneer beengips wordt gedragen.",
                    label = "Springen uitschakelen",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Voorkomt sprinten wanneer beengips wordt gedragen.",
                    label = "Sprinten uitschakelen",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Dwingt de gewonde bewegingsanimaties af wanneer beengips wordt gedragen.",
                    label = "Gewonde loopstijl afdwingen",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Overschrijft de bewegingssnelheid wanneer beengips wordt gedragen.",
                    label = "Bewegingssnelheid",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Past bewegingsbeperkingen toe wanneer beengips wordt gedragen.",
                    label = "Ingeschakeld",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Staat het nekbracemodel toe.",
                    label = "Ingeschakeld",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Voorwerp uit de inventaris dat voor een nekbrace wordt verbruikt.",
                    label = "Voorwerp",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Bestaand behandelminispel dat voor een nekbrace wordt gebruikt.",
                    label = "Minispel",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Staat het zuurstofmaskermodel toe.",
                    label = "Ingeschakeld",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Voorwerp uit de inventaris dat voor een zuurstofmasker wordt verbruikt.",
                    label = "Voorwerp",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Bestaand behandelminispel dat voor een zuurstofmasker wordt gebruikt.",
                    label = "Minispel",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Toont patiënten hun actieve medische hulpmiddelen en resterende draagtijd.",
                    label = "Ingeschakeld",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Kies waar de patiënten-HUD voor medische hulpmiddelen wordt getoond.",
                    label = "Positie",
                    options = {
                        ["bottom-center"] = "Onder midden",
                        ["bottom-left"] = "Onder links",
                        ["bottom-right"] = "Onder rechts",
                        center = "Midden",
                        ["center-left"] = "Midden links",
                        ["center-right"] = "Midden rechts",
                        ["top-center"] = "Boven midden",
                        ["top-left"] = "Boven links",
                        ["top-right"] = "Boven rechts",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Herstelt getimede gipsverbanden, spalken, nekbraces en rompverbanden na opnieuw verbinden en herstarten van de resource.",
                    label = "Behoud van medische hulpmiddelen",
                },
                medicalWearablesRemoval = {
                    description = "Laat medics actieve gipsverbanden, spalken, nekbraces en rompverbanden via de behandelinterface verwijderen.",
                    label = "Verwijdering door medic",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Toont het verwijderen van medische hulpmiddelen met het ingestelde gereedschap in de behandelinterface.",
                    label = "Verwijderbehandeling ingeschakeld",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Herbruikbaar gereedschap uit de inventaris dat nodig is om een medisch hulpmiddel te verwijderen.",
                    label = "Voorwerp",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minispel voor het verwijderen van medische hulpmiddelen (standaard cast_saw).",
                    label = "Minispel",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Staat draagdoekspalken toe op de linker- en rechterarm.",
                    label = "Ingeschakeld",
                },
                medicalWearablesSplintsItem = {
                    description = "Voorwerp uit de inventaris dat wordt verbruikt bij het aanbrengen van een spalk.",
                    label = "Voorwerp",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Bestaand behandelminispel dat voor spalken wordt gebruikt.",
                    label = "Minispel",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Staat het rompverbandmodel toe.",
                    label = "Ingeschakeld",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Voorwerp uit de inventaris dat voor een rompverband wordt verbruikt.",
                    label = "Voorwerp",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Bestaand behandelminispel dat voor een rompverband wordt gebruikt.",
                    label = "Minispel",
                },
                medicationsProfiles = {
                    description = "Declaratieve medicatiegegevens die worden gebruikt voor behandeling en zelfmedicatie.",
                    itemLabel = "Medicatie",
                    label = "Medicijnen",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Schakel de minigame met het zakventielmasker in.",
                    label = "Zakventielmasker",
                },
                minigamesCastSawEnabled = {
                    description = "Schakelt het gipszaagminispel in voor het verwijderen van medische hulpmiddelen.",
                    label = "Gipszaag",
                },
                minigamesBandageWrapEnabled = {
                    description = "Schakel de verbandwikkel-minigame in.",
                    label = "Verbandomslag",
                },
                minigamesBloodPressureEnabled = {
                    description = "Schakel de bloeddrukminigame in.",
                    label = "Bloeddruk",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Schakel de bloedtransfusie-minigame in.",
                    label = "Bloedtransfusie",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Schakel de minigame voor kogelextractie in.",
                    label = "Kogelextractie",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Benodigde ademhalingen tijdens elke ventilatiefase.",
                    label = "Ademhalingen per cyclus",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Seconden om één compressieset te voltooien.",
                    label = "Compressieduur per set",
                },
                minigamesCprCompressionWindow = {
                    description = "Toegestane offset bij het raken van een compressieslag.",
                    label = "Compressievenster",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Schakel de minigame-fase CPR-compressies in.",
                    label = "CPR-compressies",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Aantal compressies per set.",
                    label = "Compressies per set",
                },
                minigamesCprCycles = {
                    description = "Hoeveel reanimatiecycli zijn er nodig om de minigame te voltooien.",
                    label = "Cycli",
                },
                minigamesCprEnabled = {
                    description = "Schakel de CPR-minigame in.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Aftellen voordat de reanimatiecompressies beginnen.",
                    label = "Intro vertragingsseconden",
                },
                minigamesCprMaxMisses = {
                    description = "Misses toegestaan ​​voordat de CPR-minigame mislukte.",
                    label = "Max mist",
                },
                minigamesCprSetsPerCycle = {
                    description = "Hoeveel compressiesets er vóór een ademhalingsfase worden uitgevoerd.",
                    label = "Sets per cyclus",
                },
                minigamesCprVentilationEnabled = {
                    description = "Schakel de minigame-fase CPR-beademing in.",
                    label = "CPR-ventilatie",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Schakel de minigame van de glucosemeter in.",
                    label = "Glucosemeter",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Schakel de minigame met hartslagmeting in.",
                    label = "Pulsmeting",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Schakel de pulsoximeter-minigame in.",
                    label = "Pulsoximeter",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Schakel de minigame met zoutinfusie in.",
                    label = "Zoute infusie",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Seconden voordat een ventilatiepoging wordt beëindigd. Stel 0 in om uit te schakelen.",
                    label = "Ademtime-out seconden",
                },
                minigamesVentilationEnabled = {
                    description = "Schakel de ventilatieminigame in.",
                    label = "Ventilatie",
                },
                minigamesVentilationTolerance = {
                    description = "Pixelafstandstolerantie bij het volgen van de luchtstroomgolf.",
                    label = "Tolerantie",
                },
                operationsBreakDistance = {
                    description = "Maximale afstand van deelnemers tot de kamer voordat de ingreep wordt afgebroken.",
                    label = "Afbreekafstand",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA-animatiewoordenboek voor de chirurg tijdens een echte ingreep.",
                    label = "Animatiewoordenboek arts",
                },
                operationsDoctorAnimationFlag = {
                    description = "GTA-animatievlag voor de chirurg tijdens een echte ingreep.",
                    label = "Animatievlag arts",
                },
                operationsDoctorAnimationName = {
                    description = "Animatieclip voor de chirurg tijdens een echte ingreep.",
                    label = "Animatienaam arts",
                },
                operationsEnabled = {
                    description = "Schakelt operatiekamers en chirurgische ingrepen in.",
                    label = "Ingeschakeld",
                },
                operationsFadeInMs = {
                    description = "Duur in milliseconden van het infaden van het patiëntscherm bij het ontwaken.",
                    label = "Infaden bij ontwaken (ms)",
                },
                operationsFadeOutMs = {
                    description = "Duur in milliseconden van het uitfaden van het patiëntscherm bij anesthesie.",
                    label = "Uitfaden bij anesthesie (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Maximale tijd zonder geldige minigameactie voordat de sessie wordt afgebroken.",
                    label = "Inactiviteitstime-out (s)",
                },
                operationsInteractDistance = {
                    description = "Maximale afstand voor het tonen en gebruiken van operatiekamerinteracties.",
                    label = "Interactieafstand",
                },
                operationsInteractKey = {
                    description = "Besturings-ID voor interacties met de operatietafel en de positie van de chirurg.",
                    label = "Interactietoets",
                },
                operationsPatientAnimationDict = {
                    description = "GTA-animatiewoordenboek voor de patiënt onder volledige anesthesie.",
                    label = "Animatiewoordenboek patiënt",
                },
                operationsPatientAnimationFlag = {
                    description = "GTA-animatievlag voor de liggende patiëntanimatie.",
                    label = "Animatievlag patiënt",
                },
                operationsPatientAnimationName = {
                    description = "Animatieclip voor de patiënt onder volledige anesthesie.",
                    label = "Animatienaam patiënt",
                },
                operationsPatientRange = {
                    description = "Maximaal bereik om een patiënt op de operatietafel te detecteren.",
                    label = "Patiëntbereik",
                },
                operationsRequireOnDuty = {
                    description = "Vereist dat chirurgen in dienst zijn voordat ze een operatiekamer gebruiken.",
                    label = "Dienst vereist",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Maximale tijd die de chirurg in de operatieselectie mag blijven voordat de sessie wordt afgebroken.",
                    label = "Selectietime-out (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA-animatiewoordenboek voor operatietraining zonder patiënt.",
                    label = "Animatiewoordenboek training",
                },
                operationsTrainingAnimationFlag = {
                    description = "GTA-animatievlag voor de operatietrainingsanimatie.",
                    label = "Animatievlag training",
                },
                operationsTrainingAnimationName = {
                    description = "Animatieclip voor operatietraining zonder patiënt.",
                    label = "Animatienaam training",
                },
                painClassesProfiles = {
                    description = "Pijndrempels, labels en nabewerkingseffecten.",
                    label = "Pijn lessen",
                },
                painEffectsMinPainLevel = {
                    description = "Minimaal pijnniveau voordat pijnschermeffecten optreden.",
                    label = "Min pijnniveau",
                },
                primaryColor = {
                    description = "Hoofdkleur voor de EMS-interface en de ambulancewerkgroep.",
                    label = "Primaire kleur",
                },
                propPlacementConsumeItem = {
                    description = "Consumeer het overeenkomende inventarisitem wanneer het rekwisiet wordt geplaatst.",
                    label = "Consumeer artikel",
                },
                propPlacementEnabled = {
                    description = "Sta toe dat geconfigureerde EMS-steunen uit bruikbare inventarisitems worden geplaatst.",
                    label = "Ingeschakeld",
                },
                propPlacementItemNames = {
                    description = "Wijs EMS-propmodellen toe aan inventarisitemnamen voor plaatsing op basis van items.",
                    label = "Namen van propitems",
                },
                propPlacementRequireOnDuty = {
                    description = "Vereisen dat de speler dienst heeft voordat hij EMS-rekwisieten plaatst.",
                    label = "Vereist in dienst",
                },
                propPlacementReturnItem = {
                    description = "Geef het verbruikte voorwerp terug als een geplaatst rekwisiet wordt verwijderd.",
                    label = "Artikel retourneren bij verwijderen",
                },
                propPlacementVehicleAccess = {
                    description = "Sta toe dat trunksteunen de plaatsingsstroom openen in plaats van gebruik van alleen items.",
                    label = "Toegang voor voertuigen",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Sta publieke behandeling van bewuste spelers toe.",
                    label = "Sta bewuste patiënten toe",
                },
                publicTreatmentAllowedGangs = {
                    label = "Toegestane gangs",
                    description = "Selecteer interne gang- of organisatienamen. Een overeenkomende job of gang geeft de toestemming of uitzondering. Dienstplicht geldt alleen voor jobs. Optionele minimale gangrangen. Een lege lijst staat alle rangen toe. Itemvereisten blijven gelden.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Banen die een openbare behandeling kunnen gebruiken zonder EMS te zijn.",
                    label = "Toegestane banen",
                },
                publicTreatmentEnabled = {
                    description = "Maak openbare behandeling mogelijk voor niet-EMS-hulpverleners met geldige toegang.",
                    label = "Openbare behandeling ingeschakeld",
                },
                publicTreatmentInteractDistance = {
                    description = "Maximale afstand vereist om openbare behandeling te starten.",
                    label = "Interactie afstand",
                },
                publicTreatmentKeybind = {
                    description = "Standaardinteractie-keybind gebruikt voor openbare behandeling.",
                    label = "Sleutelbinder",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Toon de behandelingsmelding en schakel de bijbehorende toets in. Schakel dit uit bij gebruik van exports of een eigen radiaalmenu.",
                    label = "Toetsenbordinteractie ingeschakeld",
                },
                publicTreatmentPromptDistance = {
                    description = "Afstand gebruikt om de openbare behandelingsprompt weer te geven.",
                    label = "Prompt afstand",
                },
                publicTreatmentRequireAllItems = {
                    description = "Vereis elk vermeld medisch item in plaats van slechts één.",
                    label = "Alle items nodig",
                },
                publicTreatmentRequiredItems = {
                    description = "Inventariseer items die gelden als geldige uitrusting voor openbare behandeling.",
                    itemLabel = "Voorwerp",
                    label = "Vereiste artikelen",
                },
                reviveRewardAccount = {
                    description = "Primaire accountsleutel die wordt gebruikt voor het doen herleven van beloningsbetalingen.",
                    label = "Rekening",
                },
                reviveRewardAccountType = {
                    description = "Primair accounttype dat wordt gebruikt voor Revive-beloningsbetalingen.",
                    label = "Accounttype",
                },
                reviveRewardAmount = {
                    description = "Beloningsbedrag betaald aan de hospik voor een heropleving.",
                    label = "Hoeveelheid",
                },
                reviveRewardCurrency = {
                    description = "Optionele aangepaste valutasleutel die wordt gebruikt voor het doen herleven van beloningsbetalingen.",
                    label = "Munteenheid",
                },
                reviveRewardEnabled = {
                    description = "Betaal een geconfigureerde beloning na een succesvolle Medic Revive.",
                    label = "Ingeschakeld",
                },
                reviveRewardPayFromSociety = {
                    description = "Trek de beloningen van de gedeelde banenvereniging af voordat u de dokter betaalt.",
                    label = "Betalen vanuit de samenleving",
                },
                selfDiagnoseCommand = {
                    description = "Chatopdracht gebruikt om de zelfdiagnose te openen.",
                    label = "Commando",
                },
                selfDiagnoseEnabled = {
                    description = "Laat spelers de diagnose-UI voor zichzelf openen.",
                    label = "Zelfdiagnose ingeschakeld",
                },
                selfDiagnoseKeybind = {
                    description = "Standaard keybind gebruikt om de zelfdiagnose te openen.",
                    label = "Sleutelbinder",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Vertraging voordat de gebruikersinterface voor zelfdiagnose wordt geopend.",
                    label = "Openvertraging ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Beperk zelfdiagnose alleen tot medische taken.",
                    label = "Vereist medische baan",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Laat de speler niet bevriezen tijdens de zelfdiagnose.",
                    label = "Sla bevriezing van jezelf over",
                },
                statusEffectsProfiles = {
                    description = "Geconfigureerde schermeffecten en drempels voor bloedingen, weinig bloed, honger en dorst.",
                    label = "Statuseffecten",
                },
                stretcherAnimDict = {
                    description = "Animatiewoordenboek gebruikt tijdens het dragen van de brancard.",
                    label = "Animatie dict",
                },
                stretcherAnimName = {
                    description = "Animatienaam die wordt gebruikt tijdens het dragen van de brancard.",
                    label = "Animatienaam",
                },
                stretcherAttachRx = {
                    description = "Draagbevestiging X-rotatie voor de brancard.",
                    label = "RX bevestigen",
                },
                stretcherAttachRy = {
                    description = "Draagbevestiging Y-rotatie voor de brancard.",
                    label = "Bevestig RY",
                },
                stretcherAttachRz = {
                    description = "Draagbevestiging Z-rotatie voor de brancard.",
                    label = "Voeg RZ toe",
                },
                stretcherAttachX = {
                    description = "Draagbevestiging X-offset voor de brancard.",
                    label = "X bijvoegen",
                },
                stretcherAttachY = {
                    description = "Draagbevestiging Y-offset voor de brancard.",
                    label = "Bevestig Y",
                },
                stretcherAttachZ = {
                    description = "Draagbevestiging Z-offset voor de brancard.",
                    label = "Bevestig Z",
                },
                stretcherFoldedEnabled = {
                    description = "Schakel de optionele opgevouwen brancardvariant in voertuigen in.",
                    label = "Gevouwen ingeschakeld",
                },
                stretcherFoldedModel = {
                    description = "Propmodel gebruikt voor de gevouwen brancardvariant.",
                    label = "Opgevouwen model",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Patiëntkop gebruikt voor de opgevouwen brancardvariant.",
                    label = "Gevouwen patiëntenkop",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Patiëntbevestiging X-offset voor de opgevouwen brancard.",
                    label = "Opgevouwen patiënt X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Patiëntbevestiging Y-offset voor de gevouwen brancard.",
                    label = "Opgevouwen patiënt Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Patiënt bevestigt Z-offset voor de gevouwen brancard.",
                    label = "Gevouwen patiënt Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Interactieafstandsoverbrugging gebruikt voor helikopters.",
                    label = "Helikopter interactie afstand",
                },
                stretcherHelicopterModels = {
                    description = "Voertuigmodellen behandeld als brancardhelikopters.",
                    itemLabel = "Model",
                    label = "Helikoptermodellen",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Overbrugging van de ophaalafstand gebruikt voor helikopters.",
                    label = "Ophaalafstand van helikopter",
                },
                stretcherInteractDistance = {
                    description = "Maximale afstand voor aanwijzingen voor brancardinteractie.",
                    label = "Interactie afstand",
                },
                stretcherItemEnabled = {
                    description = "Schakel het brancarditem in, inclusief aankoop in de winkel en gebruik.",
                    label = "Brancarditem",
                },
                stretcherItemPickupEnabled = {
                    description = "Sta toe dat brancards die via het inventarisitem zijn geplaatst, terug in de inventaris worden gezet.",
                    label = "Item oppakken",
                },
                stretcherModel = {
                    description = "Primair brancardpropmodel gebruikt door het EMS-brancardsysteem.",
                    label = "Model",
                },
                stretcherPatientAnimationDict = {
                    description = "Animatiewoordenboek voor patiënten op de brancard en de voorbeeld-NPC.",
                    label = "Animatiewoordenboek patiënt",
                },
                stretcherPatientAnimationName = {
                    description = "Animatieclip voor patiënten op de brancard en de voorbeeld-NPC.",
                    label = "Animatienaam patiënt",
                },
                stretcherPatientAttachHeading = {
                    description = "Hoofdrichting van de patiënt gebruikt terwijl hij op de brancard ligt.",
                    label = "Patiënt rubriek",
                },
                stretcherPatientAttachX = {
                    description = "Patiënt bevestigt X offset op de brancard.",
                    label = "Patiënt X",
                },
                stretcherPatientAttachY = {
                    description = "Patiënt bevestigt Y-offset op de brancard.",
                    label = "Patiënt Y",
                },
                stretcherPatientAttachZ = {
                    description = "Patiënt bevestigt Z-offset op de brancard.",
                    label = "Patiënt Z",
                },
                stretcherPickupDistance = {
                    description = "De afstand die nodig is om de brancard op te pakken en ermee te werken.",
                    label = "Ophaalafstand",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animatieclip gebruikt tijdens de behandeling van een patiënt op een brancard. Laat dit leeg om een ​​scenario of de terugval van de behandelingsanimatie te gebruiken.",
                    label = "Animatienaam",
                },
                stretcherTreatmentAnimDict = {
                    description = "Animatiewoordenboek gebruikt tijdens de behandeling van een patiënt op een brancard. Laat dit leeg om een ​​scenario of de terugval van de behandelingsanimatie te gebruiken.",
                    label = "Animatiewoordenboek",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Optioneel scenario dat wordt gebruikt tijdens de behandeling van een patiënt op een brancard. Laat dit leeg om dict + clip of de fallback van de behandelingsanimatie te gebruiken.",
                    label = "Scenario",
                },
                stretcherVehicleAttachRx = {
                    description = "Voertuigbevestiging X-rotatie voor het laden van de brancard.",
                    label = "Voertuig RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Voertuigbevestiging Y-rotatie voor het laden van de brancard.",
                    label = "Voertuig RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Voertuigbevestiging Z-rotatie voor het laden van de brancard.",
                    label = "Voertuig RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Voertuigbevestiging X offset voor het laden van de brancard.",
                    label = "Voertuig X",
                },
                stretcherVehicleAttachY = {
                    description = "Voertuigbevestiging Y-offset voor het laden van de brancard.",
                    label = "Voertuig Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Voertuigbevestiging Z-offset voor het laden van de brancard.",
                    label = "Voertuig Z",
                },
                stretcherVehicleModels = {
                    description = "Voertuigmodellen mogen de brancard laden.",
                    itemLabel = "Model",
                    label = "Voertuigmodellen",
                },
                treatmentAnimClip = {
                    description = "Animatieclip gebruikt tijdens de behandeling van een patiënt. Laat leeg als u in plaats daarvan een scenario wilt gebruiken.",
                    label = "Animatienaam",
                },
                treatmentAnimDict = {
                    description = "Animatiewoordenboek gebruikt tijdens de behandeling van een patiënt. Laat leeg als u in plaats daarvan een scenario wilt gebruiken.",
                    label = "Animatiewoordenboek",
                },
                treatmentAnimScenario = {
                    description = "Scenario gebruikt tijdens de behandeling van een patiënt. Laat leeg om in plaats daarvan dict + clip te gebruiken.",
                    label = "Scenario",
                },
                trunkPropsEnabled = {
                    label = "Voertuigprops",
                    description = "Kies props bij een dienstvoertuig in de buurt.",
                },
                trunkEnabled = {
                    description = "Schakel de kofferbakfunctie in voor ambulancevoertuigen.",
                    label = "Ingeschakeld",
                },
                vehicleDamageModifier = {
                    description = "Schadevermenigvuldiger wordt toegepast terwijl de speler zich in een voertuig bevindt.",
                    label = "Voertuigschademodificator",
                },
                vehicleImpactProtectionCauses = {
                    description = "Doodsoorzaken die moeten gelden als beschermde voertuiginslagen.",
                    itemLabel = "Oorzaak",
                    label = "Schade veroorzaakt",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Voorkom dat voertuiginslagen bij lage snelheid de speler doden.",
                    label = "Ingeschakeld",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Voertuiginslagen onder deze snelheid kunnen de speler niet doden.",
                    label = "Fatale snelheid km/u",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Bij botsingen met voertuigen op of boven deze snelheid wordt gebruik gemaakt van de normale configuratie voor dodelijke verwondingen.",
                    label = "Snelheid bij volledige schade km/u",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Verwondingen die worden toegepast wanneer de botsbescherming van een voertuig een dodelijke treffer blokkeert.",
                    itemLabel = "Blessure",
                    label = "Blessures",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Percentage van de maximale gezondheid dat behouden blijft wanneer een beschermde impact de speler zou hebben gedood.",
                    label = "Overlevingsgezondheidspercentage",
                },
                vehiclePullEnabled = {
                    description = "Mogelijkheid om patiënten uit voertuigen te trekken.",
                    label = "Ingeschakeld",
                },
                vehiclePullMaxDistance = {
                    description = "Maximale afstand die nodig is om een ​​patiënt uit een voertuig te trekken.",
                    label = "Maximale afstand",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maximale afstand voor het toewijzen van een rolstoel aan een andere speler.",
                    label = "Wijs maximale afstand toe",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Ontkoppel de rolstoel automatisch wanneer de opdracht afloopt.",
                    label = "Automatisch uitrusten bij verlopen",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Standaard toegewezen rolstoelduur in minuten.",
                    label = "Standaardduur",
                },
                wheelchairDisableSprint = {
                    description = "Bloksprinten terwijl de rolstoel is uitgerust.",
                    label = "Sprint uitschakelen",
                },
                wheelchairDisableWeapons = {
                    description = "Blokkeer wapengebruik terwijl de rolstoel is uitgerust.",
                    label = "Schakel wapens uit",
                },
                wheelchairExitControl = {
                    description = "Controle-ID gebruikt om de rolstoel te verlaten.",
                    label = "Exitcontrole",
                },
                wheelchairItemName = {
                    description = "Inventarisartikel gebruikt voor de rolstoel.",
                    label = "Artikelnaam",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximaal toegestane duur van de rolstoeltoewijzing in minuten.",
                    label = "Maximale duur",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimaal toegestane duur van de rolstoeltoewijzing in minuten.",
                    label = "Minimale duur",
                },
                wheelchairVehicle = {
                    description = "Voertuigmodel gebruikt voor de rolstoel.",
                    label = "Voertuigmodel",
                },
                xrayInteractionRange = {
                    description = "Maximale afstand tot het röntgenstation voor de operator.",
                    label = "Interactie bereik",
                },
                xrayPatientRange = {
                    description = "Maximale afstand tot het röntgenstation voor de patiënt.",
                    label = "Patiëntenbereik",
                },
                xrayScanDurationSeconds = {
                    description = "Duur in seconden voor het röntgenscanresultaat.",
                    label = "Scanduur",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Afkoelen in seconden tussen het boeken van patiënten pogingen.",
                    label = "Reserveren afkoelen",
                },
                appointmentsEnabled = {
                    description = "Activeer een afspraak voor de patiënt en de persoonlijke medische kalender.",
                    label = "Ingeschakeld",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maximum aantal dagen in de toekomst dat patiënten mogen boeken.",
                    label = "Maximale reservering vooraf",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maximaal aantal actieve toekomstige afspraken kan een patiënt houden.",
                    label = "Maximale afspraken per patiënt",
                },
                appointmentsMinLeadMinutes = {
                    description = "Minimum aantal minuten tussen boeking en afspraak.",
                    label = "Minimale doorlooptijd",
                },
                appointmentsNotificationApp = {
                    description = "Telefoon app identifier gebruikt voor afspraak notificaties.",
                    label = "Notificatieapp",
                },
                appointmentsNotificationsEnabled = {
                    description = "Waarschuw patiënten op hun telefoon wanneer afspraken worden geboekt of geannuleerd.",
                    label = "Telefoonnotificaties",
                },
                appointmentsReasonMaxLength = {
                    description = "Maximum aantal tekens geaccepteerd om de reden van de afspraak.",
                    label = "Grens voor redentekens",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Duur en raster interval van een afspraak slot in minuten.",
                    label = "Slotduur",
                },
                enforceMaxHealth = {
                    description = "Houd de speler maximale gezondheid op 200. Schakel dit uit wanneer een andere bron maximale gezondheid beheert.",
                    label = "Dwing 200 max gezondheid",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Extra framework licenties ambulancepersoneel kan geven of verwijderen in patiëntendossiers. De geconfigureerde EHBO-licentie is altijd inbegrepen.",
                    itemLabel = "Licentie",
                    label = "Aanvullende patiëntenlicenties",
                },
                minigamesBandageWrapRandomization = {
                    description = "Willekeurig het gaas pad richting, vorm en proporties.",
                    label = "Bandage wrap variatie",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Willekeurig het veneuze toegangspad voor bloedtransfusies.",
                    label = "Transfusie-toegangsvariatie",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Vereist de multi-stap veneuze toegang procedure voor stroomregeling. Schakel voor de oude eenvoudige versie.",
                    label = "Fase van veneuze toegang",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Willekeurig de wondkanaalvorm, breedte en obstructies.",
                    label = "Variatie kogelafzuiging",
                },
                stretcherVehicleAttachEditor = {
                    description = "Plaats en draai de brancard in een geconfigureerde ambulance.",
                    label = "Voertuigbevestiging",
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
            warnings = {
                firstAidPublicTreatmentConflict = "Eerste hulp en openbare behandeling kunnen niet tegelijkertijd worden ingeschakeld. Door op te slaan worden beide uitgeschakeld.",
            },
            actions = {
                hideDetails = "Close",
                editPosition = "Edit",
                actionFailed = "Unable to save changes.",
                editDetails = "Edit",
                delete = "Delete",
                remove = "Delete",
            },
        },
    },
}
