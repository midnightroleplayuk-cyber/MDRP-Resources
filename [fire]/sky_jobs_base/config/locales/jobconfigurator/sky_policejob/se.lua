JobConfigLocales["sky_policejob:se"] = {
    JobConfiguratorComingSoon = "Denna jobbkonfigurator kommer snart.",
    JobConfiguratorNoPermission = "Du har inte tillåtelse att använda detta kommando.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Konfigurera polisavdelningar, butiker, objekt, fordon, stationer och grundläggande funktionsinställningar.",
                    title = "Polisjobb",
                },
            },
            dispatchActions = {
                addChannel = "Lägg till radiokanal",
                addKeyword = "Lägg till nyckelord",
                addPoi = "Lägg till intressepunkt",
                addReporter = "Lägg till anmälare",
                addStatus = "Lägg till FMS-status",
                addVehicle = "Lägg till virtuell enhet",
                addVehicleType = "Lägg till enhetstyp",
                currentLocation = "Använd aktuell plats",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Omedelbart tilldelas matchande tillgängliga enheter när en incident skapas.",
                available = "Enheter i denna status kan föreslås och tilldelas en ny incident.",
                averageResponseSpeedKmh = "Beräknar den visade ankomstuppskattningen från rakt avstånd.",
                callsign = "Unikt radiosamtal visas när spelare bemannar denna virtuella enhet.",
                centerEnabled = "Tillåter auktoriserade tjänstemän att bemanna ett avsändningscenter.",
                channelId = "Radiokanal ID för PMA Voice, SaltyChat och YACA. Numeriska ID som 2500 förblir oförändrade; PMA Voice kartlägger text-ID till ett stabilt nummer.",
                channelLabel = "Läsbart kanalnamn som visas för avsändare och enheter.",
                crewCapacity = "Högsta antalet personer som får bemanna enheten. Använd 0 för obegränsad besättning.",
                defaultChannel = "Dispatchers går med i den här kanalen när de startar sitt skift. Enheter går manuellt från Radio-fliken. Välj Ingen att använda arbetsgruppsstandarden.",
                emergencyAppEnabled = "Gör det här jobbet valbart som en offentlig tjänst i nödtelefonappen.",
                enabled = "Gör detta jobb tillgängligt för Dispatch App och cross-job incidenter.",
                icon = "Välj ikonen som visas för denna enhetskategori i Dispatch App.",
                incidentAssessmentEnabled = "Visar frågor om medicinsk och farlig bedömning i hela incidentintaget.",
                jobs = "Ytterligare jobbnamn som får incidenter med hjälp av detta sökord.",
                joinLocked = "Hindrar fler personer från att ansluta när enheten redan är bemannad.",
                minimumCrew = "Minsta antal personer i enheterna som väljs för denna insatsplan.",
                noUnitFallback = "Utan en central eller bemannad enhet skickar en Sky-meddelande till alla medlemmar på avdelningen.",
                poiId = "Beständig teknisk identifierare som centralprofiler kan använda även efter att platsen bytt namn.",
                radius = "Maximalt avstånd i meter där stationsmeddelandet kan höras.",
                readyStatusCode = "FMS-status som används när resursen blir tillgänglig för utlarmning.",
                requirements = "Svarskrav som TYPE:COUNT-par, till exempel PATROL:2,CRIME:1.",
                resourceType = "Klassificerar den operativa resursen för ledningscentralens filter och samordning.",
                respondingStatusCode = "FMS-status som används när resursen svarar på en händelse.",
                shortLabel = "Valfri kort etikett på radions sex minnesknappar för kanaler.",
                stationId = "Kopplar enheten till en station i ledningscentralens profil.",
                statusCode = "Numerisk FMS-status visas på den handhållna radion.",
                statusLabel = "Betydelse av denna FMS-status för avsändare och enheter.",
                unitId = "Beständig teknisk identifierare som bevarar enheten även om anropssignalen ändras.",
                vehicleType = "Måste matcha en fordonstyp kod konfigurerad i föregående underavsnitt.",
                vehicleTypeCode = "Kort enhetskod som används i svarskrav, till exempel PATROL, CRIME, EMS eller RESCUE.",
                vehicleTypeLabel = "Läsbart namn på denna enhetskategori.",
            },
            dispatchFields = {
                address = "Adress",
                autoAlarm = "Automatiskt larm",
                available = "Tillgänglig för Dispatch",
                averageResponseSpeedKmh = "Uppskattad responshastighet (km/h)",
                callsign = "Anropssignal",
                category = "Kategori",
                centerEnabled = "Aktivera Dispatch Center",
                channelId = "Kanal ID",
                code = "Kodkod",
                crewCapacity = "Besättningskapacitet",
                defaultChannel = "Standard radiokanal",
                emergencyAppEnabled = "Visa i nödapp",
                enabled = "Enable Dispatch",
                icon = "Ikon",
                incidentAssessmentEnabled = "Aktivera nödbedömning",
                jobs = "Måljobb (komma separerade)",
                joinLocked = "Lås anslutning till besättningen",
                keywordCode = "Keyword-kod",
                label = "Etikett",
                minimumCrew = "Minsta besättning",
                name = "Namnnamn",
                noUnitFallback = "Meddela personal utan enheter",
                noneChannel = "Ingen / grupp standard",
                note = "Notera",
                phone = "Telefon",
                poiId = "Beständigt POI-ID",
                radius = "Tillkännagivande radie",
                readyStatusCode = "Kod för beredskapsstatus",
                requirements = "Krävda enheter (till exempel PATROL:2,CRIME:1)",
                resourceType = "Resurstyp",
                respondingStatusCode = "Kod för utryckningsstatus",
                shortLabel = "Etikett för radiominne",
                stationId = "Stations-ID",
                type = "Typ",
                unitId = "Beständigt enhets-ID",
                vehicleType = "Svar enhet typ",
                radioButton = "Knapp",
                radioButtonAction = "Knappåtgärd",
                radioButtonStatus = "FMS-status",
            },
            dispatchIconOptions = {
                crime = "Brottsenhet",
                emergency = "Nödenhet",
                ems = "EMS Enhet",
                fire = "Brandenhet",
                heavy = "Tung enhet",
                k9 = "K-9 enhet",
                medical = "Medicinsk enhet",
                patrol = "patrullering",
                rescue = "Räddningsenhet",
                service = "Serviceenhet",
                supervisor = "Tillsynsman",
                tactical = "Taktisk enhet",
            },
            dispatchNavigation = {
                active = "Dispatch aktiv",
                description = "Konfigurera nödintag, radio, enheter, svarsplaner, platser och reporterdata för detta jobb.",
                inactive = "Dispatch Disabled",
                steps = {
                    accessText = "Aktivera avsändning och avgöra om detta jobb kan bemanna ett avsändningscenter.",
                    accessTitle = "Tillgång och nödintag",
                    fleetText = "Konfigurera kanaler, FMS statuskoder, fordonstyper och callsigns.",
                    fleetTitle = "Radio och flotta",
                    responseText = "Avsluta med sökord, svarskrav och POI.",
                    responseTitle = "Response planer",
                },
                summary = {
                    channels = "Radiokanaler",
                    plans = "Response planer",
                    reporters = "Kända anmälare",
                    statuses = "Tillgänglig FMS",
                    units = "Virtuella enheter",
                },
                title = "Larmcentral",
                warnings = {
                    channels = "Inga explicita radiokanaler finns; arbetsgruppens nedgångskanal kommer att användas.",
                    defaultChannel = "Den valda standardkanalen finns inte längre.",
                    disabled = "Dispatch är inaktiverad för detta jobb.",
                    statuses = "Minst en FMS-status måste vara tillgänglig så att enheter kan vara alarmerade.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Definierar de radiokanaler som enheter och bemannade sändningscentra kan ansluta sig.",
                dispatchKeywords = "Definierar incident sökord, obligatoriska fordonsräkningar, deltagande jobb och valfri automatisk alarmering.",
                dispatchPois = "Butiksstationer och gemensamma platser för incidentformulär och positionsbaserade stationsmeddelanden.",
                dispatchReporters = "Hanterar anmälares namn, återuppringningsnummer och ledningsanteckningar för jobbet.",
                dispatchStatusCodes = "Konfigurerar FMS-statusetiketter och vilka statuser som gäller för nya incidenter.",
                dispatchVehicleTypes = "Definierar enhetskategorier som används av svarsplaner, t.ex. Patrol, Crime Unit, EMS eller Rescue.",
                dispatchVehicles = "Definierar virtuella sändningsfordon som kan bemannas från var som helst utan att kräva ett gyllene fordon.",
                dispatchRadioButtons = "Ställer in den centralt fördefinierade åtgärden för varje fysisk funktionsknapp.",
                dispatchRadioFmsKeys = "Tilldela FMS status till de fysiska talknapparna. Knappsatsen utför bara FMS ändringar.",
            },
            extensions = {
                caseNumbering = {
                    label = "Ärendenummer",
                    description = "Konfigurera automatiska ärendenummer för detta jobb.",
                    fields = {
                        prefix = {
                            label = "Ärendeprefix",
                            description = "Prefix för nya ärenden, till exempel LSPD eller LSCSD. Högst 16 tecken som omvandlas till versaler; tomt fält använder CASE. Befintliga och manuellt tilldelade nummer behålls.",
                        },
                    },
                },
                dispatchReporters = "Kända anmälare",
                invalidSelection = "Ogiltigt val: {value}",
                trainingSettings = {
                    description = "Konfigurera utbildningsåtkomst, inskrivning, godkännanden och kursplanering för detta jobb.",
                    label = "Träningsinställningar",
                },
                dispatchChannels = "Radiokanaler",
                dispatchKeywords = "Nyckelord och svarsplaner",
                dispatchPois = "Avsändnings-/avsändningsstationer",
                dispatchSettings = {
                    description = "Konfigurera sändningsåtkomst, nödintag och standardradiokanal.",
                    label = "Avsändningsinställningar",
                },
                dispatchStatusCodes = "Statuskoder",
                dispatchVehicleTypes = "Typer av avsändningsfordon",
                dispatchVehicles = "Uppgifter om sändningsflottan",
                emptyDescription = "Använd tilläggsknappen ovan för att skapa den första posten.",
                emptyTitle = "Ingenting konfigurerat ännu",
                dispatchRadioButtons = "Knappar för radiofunktion",
                dispatchRadioFmsKeys = "FMS Nyckeluppdrag",
            },
            features = {
                billing = {
                    description = "Aktivera polisens faktureringsflöden.",
                    label = "Fakturering",
                },
                devices = {
                    description = "Aktivera utplacerbara övervakningsenheter.",
                    label = "CCTV och fartkameror",
                },
                evidence = {
                    description = "Aktivera bevisförvaring, fältbevis och skannerflöden.",
                    label = "Bevis",
                },
                impound = {
                    description = "Aktivera flöden för beslagsplatsen.",
                    label = "Beslag",
                },
                jail = {
                    description = "Aktivera fängelsedomar och fångaktiviteter.",
                    label = "Fängelse",
                },
                propPlacement = {
                    description = "Aktivera konfigurerbara polisobjekt och fordonsobjektsutrustning.",
                    label = "Objektplacering",
                },
                radial = {
                    description = "Aktivera polisens radialåtgärder som beslag och hjulboja.",
                    label = "Radialåtgärder",
                },
                restraints = {
                    description = "Aktivera handfängsel, buntband, benfängsel och huvor.",
                    label = "Tvångsmedel",
                },
                socialWork = {
                    description = "Aktivera tilldelning av socialt arbete och uppgiftsaktiviteter.",
                    label = "Socialtjänst",
                },
                tablet = {
                    description = "Aktivera polisens surfplatteappar som konfigurerats av denna resurs.",
                    label = "Polissurfplatta",
                },
                tracking = {
                    description = "Aktivera GPS-spårare och fotbojor.",
                    label = "Spårning",
                },
                vehicleRadar = {
                    description = "Aktivera patrullfordonets radar.",
                    label = "Fordonsradar",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "För att visa jobbet i nödsamtalsappen måste larmfunktionen vara aktiverad. Aktivera den eller stäng av visningen i nödsamtalsappen under larminställningarna.",
                dispatchJobNotCovered = "Ingen aktiv larmcentral täcker jobbet ”{job}”. Lägg till ”{job}” i coveredJobs i rätt profil under Config.Dispatch.centers i sky_jobs_base/config/config.lua och starta om sky_jobs_base. Att återställa inställningarna ändrar inte denna tilldelning.",
                invalidDispatchChannels = "Radiokanalernas ID måste vara unika och varje kanal behöver en giltig etikett.",
                invalidDispatchDefaultChannel = "Standardradiokanalen finns inte. Välj en befintlig kanal eller ”Ingen” under larminställningarna.",
                invalidDispatchKeywords = "Insatsplaner måste ha unika koder och giltiga krav av typen TYP:ANTAL.",
                invalidDispatchPois = "POI-ID, namn och koordinater måste vara giltiga och unika.",
                invalidDispatchRadioButtons = "Kontrollera radions funktionsknappar: använd varje knapp som stöds bara en gång och välj en åtgärd från dess lista.",
                invalidDispatchRadioFmsKeys = "Kontrollera radions FMS-tangenter: använd varje tangent (0-9, * eller #) bara en gång och tilldela en befintlig statuskod eller lämna den utan tilldelning.",
                invalidDispatchReadyStatus = "Välj en beredskapskod under larminställningarna som är markerad som tillgänglig i listan med statuskoder.",
                invalidDispatchReporters = "Uppgifterna för kända anmälare överskrider tillåtet antal poster eller fältlängder.",
                invalidDispatchRespondingStatus = "Välj en utryckningskod under larminställningarna som är markerad som otillgänglig i listan med statuskoder.",
                invalidDispatchSettings = "Välj en befintlig tillgänglig beredskapsstatus, en otillgänglig utryckningsstatus och en giltig standardkanal.",
                invalidDispatchStatusCodes = "FMS-koder måste vara unika och minst en status måste vara tillgänglig.",
                invalidDispatchVehicleTypes = "Koder för insatsenhetstyper måste vara unika och fullständiga.",
                invalidDispatchVehicles = "Enhets-ID och anropssignaler måste vara unika och alla typ- och stationsreferenser måste finnas.",
            },
            settingFields = {
                gangMinimumGrade = "Lägsta grad",
                gang = "Gäng",
                component = "Komponent",
                description = "Beskrivning",
                fineAmount = "Bötesbelopp",
                itemName = "Föremålsnamn",
                length = "Längd",
                max = "Högst",
                maxOverKmh = "Max över",
                min = "Minus",
                minOverKmh = "Min över",
                model = "Objektmodell",
                propModel = "Objektmodell",
                reason = "Orsak",
                vehicleClass = "Klass",
            },
            settingGroups = {
                access = {
                    label = "Åtkomst",
                },
                animation = {
                    label = "Animering",
                },
                ankleMonitor = {
                    label = "Fotboja",
                },
                ankleMonitorAccess = {
                    label = "Åtkomst till fotboja",
                },
                ankleMonitorPlacement = {
                    label = "Placering av fotboja",
                },
                ankleMonitorZone = {
                    label = "Zon för fotboja",
                },
                ankleMonitorZoneVisual = {
                    label = "Visuellt för fotbojans zon",
                },
                assignment = {
                    label = "Tilldelning",
                },
                blip = {
                    label = "Stationsmarkör",
                },
                carry = {
                    label = "Bärande",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Hållbarhet för CCTV",
                },
                cctvPlacement = {
                    label = "Placering av CCTV",
                },
                cctvRepair = {
                    label = "Reparation av CCTV",
                },
                cctvRepairAnimation = {
                    label = "Reparationsanimation för CCTV",
                },
                clamp = {
                    label = "Hjulboja",
                },
                clampWeld = {
                    label = "Svetsning av hjulboja",
                },
                cleanup = {
                    label = "Rensning",
                },
                collection = {
                    label = "Insamling",
                },
                controls = {
                    label = "Kontroller",
                },
                creator = {
                    label = "Skapare",
                },
                crimeSceneTape = {
                    label = "Brottsplatsband",
                },
                crimeSceneTapeAccess = {
                    label = "Åtkomst till band",
                },
                crimeSceneTapeInventory = {
                    label = "Bandinventarie",
                },
                crimeSceneTapeLength = {
                    label = "Bandlängd",
                },
                crimeSceneTapePlacement = {
                    label = "Placering av band",
                },
                database = {
                    label = "Databas",
                },
                delivery = {
                    label = "Leverans",
                },
                detection = {
                    label = "Upptäckt",
                },
                dispatch = {
                    label = "Utryckning",
                },
                escape = {
                    label = "Undkomma",
                },
                escort = {
                    label = "Eskort",
                },
                evidenceStorage = {
                    label = "Bevisförvaring",
                },
                fastLock = {
                    label = "Automatisk snabblåsning",
                },
                general = {
                    label = "Allmänt",
                },
                gpsTracker = {
                    label = "GPS-spårare",
                },
                gpsTrackerAccess = {
                    label = "Åtkomst till GPS-spårare",
                },
                gpsTrackerPlacement = {
                    label = "Placering av GPS-spårare",
                },
                gpsTrackerTiming = {
                    label = "Tidsinställning för GPS-spårare",
                },
                handcuffs = {
                    label = "Handfängsel",
                },
                handsUp = {
                    label = "Händer upp",
                },
                header = {
                    label = "Rubrik",
                },
                impound = {
                    label = "Beslag",
                },
                imprisonment = {
                    label = "Fängelsestraff",
                },
                jailCanteenGeneral = {
                    label = "Fängelsematsal",
                },
                jailCanteenPackage = {
                    label = "Matsalspaket",
                },
                jailCarry = {
                    label = "Bärjobb",
                },
                jailCarryInspection = {
                    label = "Inspektion av bärjobb",
                },
                jailCleaning = {
                    label = "Städjobb",
                },
                jailCleaningIllegalFinds = {
                    label = "Olagliga fynd",
                },
                jailCleaningOutline = {
                    label = "Kontur för städning",
                },
                jailDoctor = {
                    label = "Fängelseläkare",
                },
                jailElectricalCodes = {
                    label = "Koder för elskåp",
                },
                jailElectricalGeneral = {
                    label = "Elskåp",
                },
                jailElectricalPenalties = {
                    label = "Påföljder för elskåp",
                },
                jailElectricalRewards = {
                    label = "Belöningar för elskåp",
                },
                jailInmatesAlcoholic = {
                    label = "Alkoholistfånge",
                },
                jailInmatesCodeList = {
                    label = "Informatörsfånge",
                },
                jailInmatesDrugDealer = {
                    label = "Langarfånge",
                },
                jailInmatesWireCutter = {
                    label = "Verktygsbudbärarfånge",
                },
                jailJobs = {
                    label = "Fängelsejobb",
                },
                jailOutfitFemale = {
                    label = "Kvinnlig outfit",
                },
                jailOutfitMale = {
                    label = "Manlig outfit",
                },
                keybinds = {
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                    label = "Kortkommandon",
                },
                keybindsHandcuff = {
                    label = "Snabbtangent för handfängsel",
                },
                keybindsUnhandcuff = {
                    label = "Snabbtangent för att ta bort handfängsel",
                },
                marker = {
                    label = "Markör",
                },
                markerColor = {
                    label = "Markörfärg",
                },
                mugshotAnimation = {
                    label = "Animation för signalementsfoto",
                },
                mugshotBoard = {
                    label = "Skylt för signalementsfoto",
                },
                mugshotCameraCoords = {
                    label = "Kameraposition för signalementsfoto",
                },
                mugshotCameraRotation = {
                    label = "Kamerarotation för signalementsfoto",
                },
                mugshotGeneral = {
                    label = "Signalementsfoto",
                },
                mugshotMetadata = {
                    label = "Metadata för signalementsfoto",
                },
                mugshotPosition = {
                    label = "Position för signalementsfoto",
                },
                mugshotTiming = {
                    label = "Tidsinställning för signalementsfoto",
                },
                officerDown = {
                    label = "Polis nere",
                },
                outfit = {
                    label = "Utrustad",
                },
                overlay = {
                    label = "Skyltöverlägg",
                },
                payment = {
                    label = "Betalning",
                },
                paymentFlow = {
                    label = "Betalningsflöde",
                },
                penalties = {
                    label = "Påföljder",
                },
                playerSearch = {
                    label = "Visitering",
                },
                playerSearchAnimation = {
                    label = "Animation för visitering",
                },
                props = {
                    label = "Objekt",
                },
                reasons = {
                    label = "Orsaker",
                },
                release = {
                    label = "Uthämtning",
                },
                restore = {
                    label = "Återställning",
                },
                rules = {
                    label = "Regler",
                },
                scan = {
                    label = "Skanning",
                },
                scanner = {
                    label = "Skanner",
                },
                sentence = {
                    label = "Straff",
                },
                shotsFired = {
                    label = "Skottlossning",
                },
                sound = {
                    label = "Ljud",
                },
                speedcam = {
                    label = "Fartkameror",
                },
                speedcamBilling = {
                    label = "Fakturering för fartkamera",
                },
                speedcamDispatch = {
                    label = "Utryckning för fartkamera",
                },
                speedcamDurability = {
                    label = "Hållbarhet för fartkamera",
                },
                speedcamPlacement = {
                    label = "Placering av fartkamera",
                },
                speedcamRepair = {
                    label = "Reparation av fartkamera",
                },
                speedcamRepairAnimation = {
                    label = "Reparationsanimation för fartkamera",
                },
                speedcamTiming = {
                    label = "Tidsinställning för fartkamera",
                },
                speedcamVisual = {
                    label = "Visuellt för fartkamera",
                },
                speedcams = {
                    label = "Fartkameror",
                },
                storage = {
                    label = "Förvaring",
                },
                subscription = {
                    label = "Appabonnemang",
                },
                tasks = {
                    label = "Uppgifter",
                },
                theme = {
                    label = "Tema",
                },
                timing = {
                    label = "Tidsinställning",
                },
                warningUi = {
                    label = "Varningsgränssnitt",
                },
                world = {
                    label = "Värld",
                },
                zipties = {
                    label = "Buntband",
                },
                ziptiesCutter = {
                    label = "Buntbandsklippare",
                },
                cctvMotionDetection = {
                    label = "Rörelsedetektering",
                },
                cctvMotionDispatch = {
                    label = "Avsändning av rörelsedetektering",
                },
                cctvMotionTiming = {
                    label = "Tidpunkt för rörelsedetektering",
                },
                display = {
                    label = "Visning",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Rapporter",
                },
                speedcamAdvanced = {
                    label = "Avancerad hastighetskamera",
                },
                tackle = {
                    label = "Tackla",
                },
                vin = {
                    label = "VIN Kontroll",
                },
            },
            settingSections = {
                radarGun = "Radarhandtag",
                billing = "Fakturering",
                cctv = "CCTV",
                dispatch = "Utryckning",
                equipment = "Utrustning",
                evidence = "Bevis",
                impound = "Beslag",
                jail = "Fängelse",
                radar = "Fordonsradar",
                radial = "Radialåtgärder",
                restraints = "Tvångsmedel",
                socialWork = "Socialtjänst",
                speedCamera = "Fartkamera",
                spikeStrips = "Spikmattor",
                stations = "Stationer",
                tablet = "Surfplatteappar",
                tracking = "Spårning",
                fakePlates = "Falska plattor",
                general = "Allmän",
            },
            settingSubsections = {
                app = "Fartkameraapp",
                apps = "Appar",
                billing = "Fakturering",
                canteen = "Fängelsematsal",
                dispatch = "Utryckning",
                durability = "Hållbarhet",
                electrical = "Elskåp",
                general = "Allmänt",
                handcuffs = "Handbojor och buntband",
                inmates = "Intagna",
                jobs = "Fängelsejobb",
                keybinds = "Kortkommandon",
                motionDetection = "Rörelsedetektering",
                mugshot = "Signalementsfoto",
                placement = "Placering",
                repair = "Reparation",
                timing = "Tidsinställning",
                visuals = "Visuellt",
            },
            settings = {
                radarGunClearKey = { label = "Radarpistol: Rensa mätvärde" },
                radarGunToggleUiKey = { label = "Radarpistol: Växla gränssnitt" },
                radarGunNoTargetHoldMs = { label = "Målets kvarhållningstid (ms)" },
                radarGunMinimumReading = { label = "Lägsta visade hastighet" },
                radarGunSpeedSmoothing = { label = "Hastighetsutjämning (0–1)" },
                radarGunBeamRadius = { label = "Strålradie (m)" },
                radarGunRefreshRateMs = { label = "Mätintervall (ms)" },
                radarGunUseMph = { label = "Använd MPH", description = "Visa mätningar i miles per timme i stället för kilometer per timme." },
                radarGunRange = { label = "Mätområde", description = "Maximalt avstånd i meter där radarhandtaget upptäcker fordon." },
                radarGunRequireOnDuty = { label = "Kräv tjänst", description = "Kräv att poliser är i tjänst innan de mäter fordon med radarhandtaget." },
                radarGunAllowedJobs = { label = "Tillåtna jobb eller grupper", description = "police omfattar alla konfigurerade polisjobb; direkta jobbnamn fungerar också. En tom lista tar bort jobbegränsningar.", itemLabel = "Jobb eller grupp" },
                radarGunEnabled = { label = "Radarhandtag", description = "Aktivera det handhållna radarhandtaget SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Tillåtna gäng",
                    description = "Välj interna namn för gäng eller fristående organisationer. Ett matchande jobb eller gäng ger tillståndet eller undantaget. Tjänstgöring krävs endast för jobb.",
                    itemLabel = "Gäng",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Lägsta gänggrader",
                    description = "Valfria lägsta gänggrader. En tom lista tillåter alla grader. Föremålskraven gäller fortfarande.",
                },

                speedCamProcessingMode = {
                    description = "Välj direkt debitering, betalning inom den inställda fristen eller endast polisgranskning.",
                    label = "Behandlingsläge",
                    options = {
                        instant = "Dra beloppet direkt",
                        later = "Betala senare (standard)",
                        review = "Endast polisgranskning",
                    },
                },
                tabletRegistry = { label = "Register", description = "Aktivera anpassade RP-register i File Explorer. Person- och fordonsakter finns fortfarande tillgängliga separat." },
                tabletFiles = { label = "Filhanterare", description = "Samlar polisens handlingar i filutforskaren. DOJ-dokument visas endast när DOJ körs." },
                ankleMonitorAnimDurationMs = {
                    description = "Millisekunder som det tar att sätta på en fotboja.",
                    label = "Tid för påsättning",
                },
                ankleMonitorAnimScenario = {
                    description = "Scenario som spelas upp vid påsättning av en fotboja.",
                    label = "Scenario vid påsättning",
                },
                ankleMonitorAttachBone = {
                    description = "Ped-skelettdel som används för att fästa fotbojans objekt.",
                    label = "Fästpunkt (bone)",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Ta bort fotbojeföremålet efter placering.",
                    label = "Förbruka fotboja",
                },
                ankleMonitorCutItem = {
                    description = "Inventarieföremål som används för att ta bort fotbojor.",
                    label = "Klipparföremål",
                },
                ankleMonitorEnabled = {
                    description = "Aktivera placering av fotbojor.",
                    label = "Fotboja",
                },
                ankleMonitorItem = {
                    description = "Inventarieföremål som används för att placera ut fotbojor.",
                    label = "Fotbojeföremål",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Millisekunder mellan kartuppdateringar för fotbojan.",
                    label = "Kartuppdateringsintervall",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Behåller fotbojor i databasen när övervakade spelare kopplar från, så att de återställs efter återanslutningar och serveromstarter.",
                    label = "Behåll efter frånkoppling",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maximalt avstånd för att sätta på en fotboja.",
                    label = "Placeringsavstånd",
                },
                ankleMonitorPropModel = {
                    description = "Objektmodell som används för fotbojans visuella utseende.",
                    label = "Objektmodell",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Kräv tjänstestatus innan fotbojor används.",
                    label = "Fotboja kräver tjänst",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Kräv att spelaren tillhör polisgruppen för att använda fotbojor.",
                    label = "Fotboja kräver poliser",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Återlämna fotbojeföremålet när den tas bort.",
                    label = "Återlämna fotboja vid borttagning",
                },
                ankleMonitorWarningSeconds = {
                    description = "Varningstid innan en zonöverträdelse för fotboja skickas som utryckning.",
                    label = "Varningssekunder för zon",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Millisekunder mellan varningspip för fotbojans zon.",
                    label = "Pipintervall för zon",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Ljudnamn som används för fotbojans zonvarningar.",
                    label = "Pipljud",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Ljuduppsättning som används för fotbojans zonvarningar.",
                    label = "Ljuduppsättning för pip",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Transparensvärde som används för fotbojans zonmarkörer.",
                    label = "Transparens för markör",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Kartmarkörens färg som används när ett mål befinner sig inom det tillåtna området.",
                    label = "Färg för tillåten markör",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Kartmarkörens färg som används när ett mål lämnar det tillåtna området.",
                    label = "Färg för utesluten markör",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Millisekunder mellan zonkontroller för fotboja.",
                    label = "Kontrollintervall för zon",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Sekunder innan ytterligare en zonutryckning för fotboja kan skickas.",
                    label = "Nedkylningstid för zonutryckning",
                },
                ankleMonitorZoneEnabled = {
                    description = "Aktivera zonkontroller för fotboja.",
                    label = "Zoner för fotboja",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Kartmarkörens sprite som används för fotbojans zonmarkörer.",
                    label = "Sprite för zonetikett",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Radie som används för fotbojans zonkonturer.",
                    label = "Konturens radie",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Stegstorlek som används för fotbojans zonkonturer.",
                    label = "Konturens stegstorlek",
                },
                billingAccount = {
                    description = "Reservkonto som används när ett jobb saknar konfigurerat organisationskonto.",
                    label = "Reservkonto för organisation",
                },
                billingCloseOnSuccess = {
                    description = "Stäng faktureringsgränssnittet efter att en faktura har utfärdats.",
                    label = "Stäng efter lyckad fakturering",
                },
                billingCurrency = {
                    description = "Valutanyckel som används för fakturering. Lämna tomt för att använda standardvalutan.",
                    label = "Valuta",
                },
                billingCustomReasons = {
                    description = "Tillåt anpassade faktureringsorsaker istället för endast förinställda.",
                    label = "Anpassade orsaker",
                },
                billingDepositToSociety = {
                    description = "Sätt in faktureringsintäkter på jobbets organisationskonto.",
                    label = "Sätt in till organisation",
                },
                billingMaxReasonLength = {
                    description = "Maximalt antal tecken för anpassade faktureringsorsaker.",
                    label = "Längd på orsak",
                },
                billingMode = {
                    description = "Välj om polisfakturor debiteras omedelbart, kräver medborgarens godkännande, eller använder framework-faktureringssystemet.",
                    label = "Faktureringsläge",
                    options = {
                        consent = "Betala eller neka",
                        framework = "Framework-faktura",
                        instant = "Omedelbar debitering",
                    },
                },
                billingRange = {
                    description = "Maximalt målavstånd för att utfärda polisfakturor.",
                    label = "Faktureringsavstånd",
                },
                billingReasonPresets = {
                    description = "Förinställda faktureringsorsaker som visas i faktureringsgränssnittet.",
                    itemLabel = "Orsak",
                    label = "Förinställda orsaker",
                },
                billingRefreshSeconds = {
                    description = "Uppdateringsintervall för mål medan faktureringsgränssnittet är öppet.",
                    label = "Uppdateringssekunder",
                },
                billingShowRecipientName = {
                    description = "Visa medborgarens namn i bötesförhandsvisningar och på kvitton.",
                    label = "Visa mottagarens namn",
                },
                carryAllowCarrierInVehicle = {
                    description = "Tillåt bäraren att gå in i och köra ett fordon utan att släppa spelaren.",
                    label = "Tillåt bärare i fordon",
                },
                carryAllowConscious = {
                    description = "Tillåt att medvetna mål bärs.",
                    label = "Bär medvetna mål",
                },
                carryAllowSprint = {
                    description = "Tillåt att spurta medan en annan spelare bärs.",
                    label = "Tillåt spurt vid bärande",
                },
                carryEnabled = {
                    description = "Aktivera bärande av spelare.",
                    label = "Bärande",
                },
                carryMaxDistance = {
                    description = "Maximalt avstånd för att börja bära en spelare.",
                    label = "Bäravstånd",
                },
                carryRequireOnDuty = {
                    description = "Kräv tjänstestatus innan bärande påbörjas.",
                    label = "Bärande kräver tjänst",
                },
                cctvDamageCooldownMs = {
                    description = "Millisekunder innan CCTV kan skadas igen.",
                    label = "Nedkylning för skada",
                },
                cctvDamagePerHit = {
                    description = "Hållbarhetsskada som tillämpas på CCTV-kameror per träff.",
                    label = "Skada per träff",
                },
                cctvDefaultName = {
                    description = "Standardvisningsnamn för utplacerade CCTV-kameror.",
                    label = "Standardnamn för CCTV",
                },
                cctvDefaultPitch = {
                    description = "Standardkameralutning för CCTV-placering.",
                    label = "Standardlutning",
                },
                cctvDisassembleDistance = {
                    description = "Avstånd som används för att demontera CCTV-kameror.",
                    label = "Demonteringsavstånd",
                },
                cctvEnabled = {
                    description = "Aktivera placering och streaming av CCTV-kameror.",
                    label = "CCTV-kameror",
                },
                cctvHealthDisplayDistance = {
                    description = "Avstånd på vilket CCTV:s hållbarhet visas.",
                    label = "Visningsavstånd för hållbarhet",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Millisekunder som CCTV:s hållbarhet förblir synlig.",
                    label = "Visningstid för hållbarhet",
                },
                cctvHealthTextOffset = {
                    description = "Vertikal förskjutning som används för CCTV:s hållbarhetstext.",
                    label = "Textförskjutning för hållbarhet",
                },
                cctvHeightStep = {
                    description = "Höjdsteg som används vid positionering av CCTV-kameror.",
                    label = "Höjdsteg",
                },
                cctvItem = {
                    description = "Inventarieföremål som används för att placera ut CCTV-kameror.",
                    label = "CCTV-föremål",
                },
                cctvMaintenanceThreshold = {
                    description = "Hållbarhetströskel där underhåll av CCTV rekommenderas.",
                    label = "Underhållströskel",
                },
                cctvMaxDurability = {
                    description = "Maximal hållbarhet för CCTV-kameror.",
                    label = "Hållbarhet för CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Sekunder innan en kamera kan skapa ett nytt rörelselarm.",
                    label = "Dispatchpaus",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Millisekunder mellan rörelseskanningar på klienten.",
                    label = "Skanningsintervall",
                },
                cctvMotionClientCooldownMs = {
                    description = "Millisekunder innan en klient kan rapportera samma kamera igen.",
                    label = "Klientens rapportpaus",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Aktivera rörelselarm automatiskt för nyplacerade CCTV-kameror.",
                    label = "Aktivera nya kameror som standard",
                },
                cctvMotionDetectionEnabled = {
                    description = "Aktivera dispatchlarm vid rörelsedetektering för varje CCTV-kamera.",
                    label = "Rörelselarm",
                },
                cctvMotionDetectionRadius = {
                    description = "Maximalt avstånd för rörelsedetektering i meter.",
                    label = "Detekteringsradie",
                },
                cctvMotionFieldOfView = {
                    description = "Vinkel för rörelsedetekteringens kon i grader.",
                    label = "Synfält",
                },
                cctvMotionJobs = {
                    description = "Jobbnamn eller jobbgrupper som tar emot CCTV-rörelselarm.",
                    itemLabel = "Jobb eller grupp",
                    label = "Dispatchjobb",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minsta objekthastighet i meter per sekund som räknas som rörelse.",
                    label = "Minsta rörelsehastighet",
                },
                cctvMoveStep = {
                    description = "Rörelsesteg som används vid positionering av CCTV-kameror.",
                    label = "Flyttsteg",
                },
                cctvPropModel = {
                    description = "Objektmodell som används för utplacerade CCTV-kameror.",
                    label = "Objektmodell för CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Animationsordlista som används vid reparation av CCTV-kameror.",
                    label = "Animationsordlista för reparation",
                },
                cctvRepairAnimFlag = {
                    description = "Animationsflagga som används vid reparation av CCTV-kameror.",
                    label = "Animationsflagga för reparation",
                },
                cctvRepairAnimName = {
                    description = "Animationsnamn som används vid reparation av CCTV-kameror.",
                    label = "Animationsnamn för reparation",
                },
                cctvRepairCancelDelayMs = {
                    description = "Millisekunder innan CCTV-reparation kan avbrytas.",
                    label = "Fördröjning för avbruten reparation",
                },
                cctvRepairDistance = {
                    description = "Avstånd som används för att reparera CCTV-kameror.",
                    label = "Reparationsavstånd",
                },
                cctvRepairItem = {
                    description = "Inventarieföremål som används för att reparera CCTV-kameror.",
                    label = "Reparationsföremål",
                },
                cctvRepairPerTick = {
                    description = "Hållbarhet som återställs per reparationstakt för CCTV.",
                    label = "Reparation per takt",
                },
                cctvRepairTickMs = {
                    description = "Millisekunder mellan CCTV:s reparationstakter.",
                    label = "Reparationstakt",
                },
                cctvRotateStep = {
                    description = "Rotationssteg som används vid positionering av CCTV-kameror.",
                    label = "Rotationssteg",
                },
                cctvStreamDistance = {
                    description = "Avstånd som används för att ladda CCTV-kameror.",
                    label = "Laddningsavstånd",
                },
                cctvViewOffset = {
                    description = "Vyförskjutning som används för CCTV:s direktsända kamerarendering.",
                    label = "Vyförskjutning",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Skapar en blockerande kollisionsbarriär längs bandet så att spelare inte kan gå igenom det.",
                    label = "Blockerande kollision för bandet",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Ta bort ett bandföremål från inventariet efter en lyckad placering.",
                    label = "Förbruka bandföremålet",
                },
                crimeSceneTapeDynamic = {
                    description = "Låt bandet påverkas av fysik och gravitation i stället för att låsas på plats.",
                    label = "Dynamisk fysik",
                },
                crimeSceneTapeEnabled = {
                    description = "Tillåt placering av brottsplatsband med ett inventarieföremål.",
                    label = "Brottsplatsband",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Endast tillåtna jobb får ta bort bandet och, när det krävs, måste medlemmen vara i tjänst.",
                    label = "Begränsa borttagning",
                },
                crimeSceneTapeItem = {
                    description = "Namnet på inventarieföremålet som startar placering av brottsplatsband.",
                    label = "Bandföremål",
                },
                crimeSceneTapeJobs = {
                    description = "Jobbnamn som får använda brottsplatsbandet.",
                    itemLabel = "Jobb",
                    label = "Tillåtna jobb",
                },
                crimeSceneTapeLabel = {
                    description = "Namnet som visas för brottsplatsbandet under placeringen.",
                    label = "Bandets visningsnamn",
                },
                crimeSceneTapeLengthStep = {
                    description = "Steg i meter som den valda bandlängden avrundas till.",
                    label = "Längdsteg",
                },
                crimeSceneTapeMaxLength = {
                    description = "Längsta tillåtna avstånd mellan de två bandstolparna, i meter.",
                    label = "Största bandlängd",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Största tillåtna avstånd från någon av ändpunkterna till polisen som placerar bandet.",
                    label = "Största placeringsavstånd",
                },
                crimeSceneTapeMinLength = {
                    description = "Kortaste tillåtna avstånd mellan de två bandstolparna, i meter.",
                    label = "Minsta bandlängd",
                },
                crimeSceneTapeModel = {
                    description = "Namnet på objektmodellen som används för placerat brottsplatsband.",
                    label = "Bandmodell",
                },
                crimeSceneTapePostModel = {
                    description = "Objektmodell som används för båda bandstolparna.",
                    label = "Stolpmodell",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Det största avstånd från vilket det placerade brottsplatsbandet kan tas bort.",
                    label = "Borttagningsavstånd",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Endast tjänstgörande medlemmar i tillåtna jobb får placera bandet.",
                    label = "Kräv tjänstgöring",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Ge tillbaka det förbrukade föremålet när det placerade bandet tas bort.",
                    label = "Återlämna föremålet vid borttagning",
                },
                crimeSceneTapeSag = {
                    description = "Bandets största nedhängning mellan stolparna, i meter.",
                    label = "Bandets nedhängning",
                },
                crimeSceneTapeSections = {
                    description = "Inbyggda modeller för bandsektioner som används för att sätta samman den valda längden.",
                    itemLabel = "Bandsektion",
                    label = "Bandsektioner",
                },
                crimeSceneTapeShowPosts = {
                    description = "Skapar synliga stödstolpar i båda ändarna av brottsplatsbandet med variabel längd.",
                    label = "Visa bandstolpar",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Avståndet inom vilket det placerade brottsplatsbandet laddas.",
                    label = "Laddningsavstånd",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Bandets höjd över de valda markpunkterna.",
                    label = "Bandhöjd",
                },
                crimeSceneTapeVariableLength = {
                    description = "Låter poliser ange en start- och slutpunkt och placera brottsplatsbandet med justerbar längd.",
                    label = "Variabel bandlängd",
                },
                crimeSceneTapeZOffset = {
                    description = "Vertikal förskjutning som används när bandmodellen placeras.",
                    label = "Höjdförskjutning",
                },
                cuffsAnimDict = {
                    description = "Animationsordlista som används för fängslade spelare.",
                    label = "Animationsordlista",
                },
                cuffsAnimFlag = {
                    description = "Animationsflagga som används för fängslade spelare.",
                    label = "Animationsflagga",
                },
                cuffsAnimName = {
                    description = "Animationsnamn som används för fängslade spelare.",
                    label = "Animationsnamn",
                },
                cuffsConsumeItem = {
                    description = "Ta bort handfängselföremålet när handfängsel sätts på.",
                    label = "Förbruka handfängsel",
                },
                cuffsEnabled = {
                    description = "Aktivera åtgärder för handfängsel.",
                    label = "Handfängsel",
                },
                cuffsEscapeEnabled = {
                    description = "Aktivera minispelet för att undkomma handfängsel.",
                    label = "Undkomma handfängsel",
                },
                cuffsEscapeKeyPool = {
                    description = "Tangenter som kan förekomma i minispelet för att undkomma handfängsel.",
                    itemLabel = "Tangent",
                    label = "Tangentpool för undkomma",
                },
                cuffsEscapeRounds = {
                    description = "Antal omgångar som krävs i minispelet för att undkomma handfängsel.",
                    label = "Antal omgångar för undkomma",
                },
                cuffsEscapeWindowMs = {
                    description = "Antal millisekunder som tillåts per inmatningsfönster vid undkomma.",
                    label = "Tidsfönster för undkomma",
                },
                cuffsHandsUpEnabled = {
                    description = "Aktivera tillståndet händer upp som används av handfängsel och buntband.",
                    label = "Händer upp",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Antal sekunder som tangenten för händer upp måste hållas innan den aktiveras.",
                    label = "Håll-sekunder för händer upp",
                },
                cuffsHandsUpKey = {
                    description = "Tangentbordstangent som används för att lyfta händerna.",
                    label = "Tangent för händer upp",
                },
                cuffsItem = {
                    description = "Inventarieföremål som används för åtgärder med handfängsel.",
                    label = "Handfängselföremål",
                },
                cuffsMaxDistance = {
                    description = "Maximalt målavstånd för åtgärder med handfängsel.",
                    label = "Avstånd för handfängsel",
                },
                cuffsRequireItem = {
                    description = "Kräv det konfigurerade handfängselföremålet.",
                    label = "Handfängsel kräver föremål",
                },
                cuffsRequireOnDuty = {
                    description = "Kräv tjänstestatus innan handfängsel sätts på.",
                    label = "Handfängsel kräver tjänst",
                },
                cuffsReturnOnRemove = {
                    description = "Återlämna handfängselföremålet när handfängslet tas bort.",
                    label = "Återlämna handfängsel",
                },
                dispatchOfficerDownEnabled = {
                    description = "Skicka en utryckningsavisering när en polis i tjänst går ner.",
                    label = "Larm för polis nere",
                },
                dispatchOfficerDownJobs = {
                    description = "Jobb som ska ta emot utryckningar för polis nere.",
                    itemLabel = "Jobb",
                    label = "Jobb för polis nere",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Meddela endast spelare som för närvarande är i tjänst.",
                    label = "Polis nere kräver tjänst",
                },
                dispatchShotsFiredChance = {
                    description = "Sannolikhet från 0.0 till 1.0 att ett upptäckt skott skapar ett larm.",
                    label = "Sannolikhet för larm",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Sekunder innan samma spelare kan utlösa ytterligare ett larm för skottlossning.",
                    label = "Nedkylning för skottlossning",
                },
                dispatchShotsFiredEnabled = {
                    description = "Aktivera utryckningsaviseringar för skottlossning.",
                    label = "Larm för skottlossning",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Vapen som inte ska utlösa larm för skottlossning.",
                    itemLabel = "Vapen",
                    label = "Ignorerade vapen",
                },
                dispatchShotsFiredJobs = {
                    description = "Jobb som ska ta emot utryckningar för skottlossning.",
                    itemLabel = "Jobb",
                    label = "Jobb för skottlossning",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Meddela endast spelare som för närvarande är i tjänst.",
                    label = "Skottlossning kräver tjänst",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Skapa utryckningsposter när skottlossning upptäcks.",
                    label = "Skicka utryckning för skottlossning",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Sannolikhet från 0.0 till 1.0 att ett upptäckt ljuddämpat skott skapar ett larm.",
                    label = "Sannolikhet för larm vid ljuddämpade skott",
                },
                escortEnabled = {
                    description = "Aktivera eskortering av spelare.",
                    label = "Eskort",
                },
                escortMaxDistance = {
                    description = "Maximalt avstånd för att börja eskortera en spelare.",
                    label = "Eskortavstånd",
                },
                escortRequireOnDuty = {
                    description = "Kräv tjänstestatus innan spelare eskorteras.",
                    label = "Eskort kräver tjänst",
                },
                escortVehicleDistance = {
                    description = "Maximalt avstånd för att placera en eskorterad spelare i ett fordon.",
                    label = "Eskortens fordonsavstånd",
                },
                evidenceBloodDamageThreshold = {
                    description = "Lägsta skadetröskel innan blodbevis skapas.",
                    label = "Tröskelvärde för blodskada",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Millisekunder innan ytterligare en hylsa kan skapas.",
                    label = "Nedkylning för hylsor",
                },
                evidenceCasingMergeRadius = {
                    description = "Radie som används för att slå samman närliggande hylsor.",
                    label = "Sammanslagningsradie för hylsor",
                },
                evidenceCleanupIntervalMs = {
                    description = "Millisekunder mellan bevisrensningsomgångar.",
                    label = "Rensningsintervall",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Sekunder innan fältbevis automatiskt löper ut.",
                    label = "Livslängd för rensning",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Rengöringsmedel för alla",
                    description = "Låt alla ta bort spår med väteperoxid. Stäng av för att använda jobb- och gänglistorna.",
                },
                evidenceCleanerJobs = {
                    label = "Jobb för rengöringsmedlet",
                    description = "Tillåtna interna namn utan offentlig åtkomst. Ett matchande jobb eller gäng ger åtkomst; tomma listor nekar åtkomst.",
                    itemLabel = "Jobb",
                },
                evidenceCleanerGangs = {
                    label = "Gäng för rengöringsmedlet",
                    description = "Tillåtna interna namn utan offentlig åtkomst. Ett matchande jobb eller gäng ger åtkomst; tomma listor nekar åtkomst.",
                    itemLabel = "Gäng",
                },
                evidenceCollectDistance = {
                    description = "Avstånd som används för att samla in fältbevis.",
                    label = "Insamlingsavstånd",
                },
                evidenceDiscoverDistance = {
                    description = "Avstånd som används för att upptäcka närliggande bevismarkörer.",
                    label = "Upptäcktsavstånd",
                },
                evidenceFieldEnabled = {
                    description = "Aktivera skapande och insamling av bevis i fält.",
                    label = "Fältbevis",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Vapen som används för att inspektera och avslöja bevis i fält.",
                    label = "Ficklampsvapen",
                },
                evidenceGloveFreeHands = {
                    description = "Komponent-ID för händer som räknas som att inte bära handskar.",
                    label = "Bara händer utan handskar",
                },
                evidenceMarkerColor = {
                    description = "RGBA-färg som används för fältbevismarkörer.",
                    label = "Markörfärg",
                },
                evidenceMarkerDrawDistance = {
                    description = "Ritavstånd som används för fältbevismarkörer.",
                    label = "Ritavstånd",
                },
                evidenceMarkerOffset = {
                    description = "Vertikal markörförskjutning som används för fältbevis.",
                    label = "Förskjutning",
                },
                evidenceMarkerScaleX = {
                    description = "Markörens X-skala som används för fältbevis.",
                    label = "Skala X",
                },
                evidenceMarkerScaleY = {
                    description = "Markörens Y-skala som används för fältbevis.",
                    label = "Skala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Markörens Z-skala som används för fältbevis.",
                    label = "Skala Z",
                },
                evidenceMarkerType = {
                    description = "Markörtyp som används för fältbevis.",
                    label = "Markörtyp",
                },
                evidenceMaxCreateDistance = {
                    description = "Maximalt avstånd för att skapa bevisposter.",
                    label = "Skapandeavstånd",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Millisekunder som tillåts för samtycke till salivprov.",
                    label = "Tidsgräns för salivsamtycke",
                },
                evidenceScannerDistance = {
                    description = "Avstånd som används för interaktioner med bevisskannern.",
                    label = "Skanneravstånd",
                },
                evidenceScannerDurationMs = {
                    description = "Åtgärdstid för fingeravtryck/skanner i millisekunder.",
                    label = "Skannertid",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maximalt antal fack för bevisförvaring.",
                    label = "Förvaringsfack",
                },
                gpsTrackerBeepDistance = {
                    description = "Avstånd där pipåterkoppling för GPS-spåraren blir relevant.",
                    label = "Pipavstånd",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Millisekunder mellan pip när man är långt från en spårare.",
                    label = "Pipintervall långt bort",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Millisekunder mellan pip när man är nära en spårare.",
                    label = "Pipintervall nära",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Ta bort spårarföremålet efter placering.",
                    label = "Förbruka GPS-spårare",
                },
                gpsTrackerEnabled = {
                    description = "Aktivera placering och skanning av GPS-spårare på fordon.",
                    label = "GPS-spårare",
                },
                gpsTrackerItem = {
                    description = "Inventarieföremål som används för att placera ut GPS-spårare.",
                    label = "Spårarföremål",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Millisekunder mellan kartuppdateringar för spårare.",
                    label = "Kartuppdateringsintervall",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maximalt avstånd för att placera en GPS-spårare på ett fordon.",
                    label = "Placeringsavstånd",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maximalt avstånd för att ta bort en utplacerad GPS-spårare.",
                    label = "Borttagningsavstånd",
                },
                gpsTrackerRemoveKey = {
                    description = "Kontrollkod som används för att ta bort en utplacerad GPS-spårare.",
                    label = "Borttagningstangent",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Kräv tjänstestatus innan GPS-spårare används.",
                    label = "GPS kräver tjänst",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Kräv att spelaren tillhör polisgruppen för att använda GPS-spårare.",
                    label = "GPS kräver poliser",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Återlämna spårarföremålet när det tas bort.",
                    label = "Återlämna spårare vid borttagning",
                },
                gpsTrackerScanDistance = {
                    description = "Maximalt avstånd för att skanna efter spårare.",
                    label = "Skanningsavstånd för GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Millisekunder som det tar att skanna efter en GPS-spårare.",
                    label = "Skanningstid",
                },
                gpsTrackerScannerWeapon = {
                    description = "Vapen eller verktyg som används för att skanna efter GPS-spårare.",
                    label = "Skannervapen",
                },
                impoundAccount = {
                    description = "Konto som används för att debitera beslagsuthämtningar.",
                    label = "Betalningskonto",
                },
                impoundCreatorVehicleModel = {
                    description = "Fordonsmodell som visas i beslagsskaparens förhandsvisning.",
                    label = "Skaparens fordonsmodell",
                },
                impoundCustomGarageEnabled = {
                    description = "Använd ett anpassat garagegränssnitt för beslag när det är tillgängligt.",
                    label = "Anpassat garage för beslag",
                },
                impoundDefaultPrice = {
                    description = "Standardpris för att hämta ut ett beslagtaget fordon.",
                    label = "Standardpris",
                },
                impoundDeliveryDistance = {
                    description = "Avstånd som används för inlämningsinteraktioner vid beslag.",
                    label = "Inlämningsavstånd",
                },
                impoundDeliveryMarker = {
                    description = "Markörkonfiguration som används för inlämning till beslag.",
                    label = "Inlämningsmarkör",
                },
                impoundEnabled = {
                    description = "Aktivera beslagsflöden.",
                    label = "Beslag",
                },
                impoundMarker = {
                    description = "Markörkonfiguration som används för beslagsinteraktioner.",
                    label = "Beslagsmarkör",
                },
                impoundRadialEnabled = {
                    description = "Aktivera radiala beslagsåtgärder.",
                    label = "Beslagsåtgärd",
                },
                impoundRadialRequireOnDuty = {
                    description = "Kräv tjänstestatus innan den radiala beslagsåtgärden används.",
                    label = "Beslag kräver tjänst",
                },
                impoundRadialVehicleDistance = {
                    description = "Maximalt avstånd till målfordonet för radiala beslagsåtgärder.",
                    label = "Beslagets fordonsavstånd",
                },
                impoundReleaseDistance = {
                    description = "Avstånd som används för uthämtningsinteraktioner vid beslag.",
                    label = "Uthämtningsavstånd",
                },
                impoundReleaseKey = {
                    description = "Kontrollkod som används för att hämta ut beslagtagna fordon.",
                    label = "Uthämtningstangent",
                },
                impoundRequireDelivery = {
                    description = "Kräv att fordonet lämnas in till en konfigurerad beslagsplats.",
                    label = "Kräver inlämning",
                },
                impoundStorageBasePrice = {
                    description = "Grundpris för att hämta ut förvarade beslagtagna fordon.",
                    label = "Grundpris för förvaring",
                },
                impoundStorageDailyFee = {
                    description = "Extra beslagsförvaringsavgift per konfigurerad dag.",
                    label = "Daglig förvaringsavgift",
                },
                impoundStorageDaySeconds = {
                    description = "Hur många sekunder som räknas som en faktureringsdag för förvaring.",
                    label = "Sekunder per förvaringsdag",
                },
                impoundStorageEnabled = {
                    description = "Aktivera hantering av betald beslagsförvaring.",
                    label = "Beslagsförvaring",
                },
                jailAssignRange = {
                    description = "Maximalt avstånd för att skicka ett mål till fängelse.",
                    label = "Tilldelningsavstånd",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minuter en fånge måste vänta innan nästa matsalspaket kan hämtas.",
                    label = "Nedkylningsminuter",
                },
                jailCanteenPackage = {
                    description = "Föremål som ges av fängelsets matsalspaket.",
                    label = "Matsalspaket",
                },
                jailCellStreamDistance = {
                    description = "Avstånd som används för streaming av isoleringscellens objekt.",
                    label = "Laddningsavstånd för cell",
                },
                jailClearInventory = {
                    description = "Töm spelarens inventarie när denne skickas till fängelset.",
                    label = "Töm inventarie",
                },
                jailDefaultMonths = {
                    description = "Standardfängelsetid när tilldelningsgränssnittet öppnas.",
                    label = "Standardantal månader",
                },
                jailDispatchJobs = {
                    description = "Jobb som ska ta emot fängelseutryckningar.",
                    itemLabel = "Jobb",
                    label = "Utryckningsjobb",
                },
                jailDoctorHealEvent = {
                    description = "Server- eller klienthändelse som utlöses när fängelseläkaren läker en fånge.",
                    label = "Läkningshändelse",
                },
                jailElectricalCodeListItem = {
                    description = "Inventarieföremål som krävs för att avslöja genererade elkoder.",
                    label = "Kodlisteföremål",
                },
                jailElectricalCodeMax = {
                    description = "Högsta slumpmässiga kodvärde för elskåpet.",
                    label = "Högsta kod",
                },
                jailElectricalCodeMin = {
                    description = "Lägsta slumpmässiga kodvärde för elskåpet.",
                    label = "Lägsta kod",
                },
                jailElectricalCodesCount = {
                    description = "Hur många kandidatkoder som genereras för elskåpet.",
                    label = "Antal koder",
                },
                jailElectricalEnabled = {
                    description = "Aktivera fängelsets minispel för rymning via elskåp.",
                    label = "Elskåp",
                },
                jailElectricalPinLength = {
                    description = "Antal siffror som används för elskåpets PIN-koder.",
                    label = "PIN-längd",
                },
                jailElectricalPropModel = {
                    description = "Världsobjektmodell som används för fängelsets elskåp.",
                    label = "Objektmodell",
                },
                jailElectricalShockDamage = {
                    description = "Skada som ges när en fånge misslyckas med elsekvensen.",
                    label = "Chockskada",
                },
                jailElectricalShockRagdollMs = {
                    description = "Millisekunder av ragdoll efter en elchock.",
                    label = "Ragdoll efter chock",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Strafftidsminuter som tas bort efter ett lyckat rymningsförsök via elskåp.",
                    label = "Minuter för lyckad strafflindring",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Mängd som krävs för handeln med den alkoholiserade fången.",
                    label = "Nödvändig mängd",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Föremål som krävs för handeln med den alkoholiserade fången.",
                    label = "Nödvändigt föremål",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Belöningsmängd för handeln med den alkoholiserade fången.",
                    label = "Belöningsmängd",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Belöningsföremål för handeln med den alkoholiserade fången.",
                    label = "Belöningsföremål",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Belöningsetikett som visas för handeln med den alkoholiserade fången.",
                    label = "Belöningsetikett",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Mängd som krävs för handeln med informatörsfången.",
                    label = "Nödvändig mängd",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Föremål som krävs för handeln med informatörsfången.",
                    label = "Nödvändigt föremål",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Belöningsmängd för handeln med informatörsfången.",
                    label = "Belöningsmängd",
                },
                jailInmateCodeListRewardItem = {
                    description = "Belöningsföremål för handeln med informatörsfången.",
                    label = "Belöningsföremål",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Belöningsetikett som visas för handeln med informatörsfången.",
                    label = "Belöningsetikett",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Föremål som godkänns för handeln med langarfången.",
                    label = "Godkända föremål",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Mängd som krävs för handeln med langarfången.",
                    label = "Nödvändig mängd",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Belöningsmängd för handeln med langarfången.",
                    label = "Belöningsmängd",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Belöningsföremål för handeln med langarfången.",
                    label = "Belöningsföremål",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Belöningsetikett som visas för handeln med langarfången.",
                    label = "Belöningsetikett",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Tillåt att smuggelgods som hittas vid fängelsestädning räknas för handeln med langarfången.",
                    label = "Använd smuggelgods från städning",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Mängd som krävs för handeln med verktygsbudbärarfången.",
                    label = "Nödvändig mängd",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Föremål som krävs för handeln med verktygsbudbärarfången.",
                    label = "Nödvändigt föremål",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Belöningsmängd för handeln med verktygsbudbärarfången.",
                    label = "Belöningsmängd",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Belöningsföremål för handeln med verktygsbudbärarfången.",
                    label = "Belöningsföremål",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Belöningsetikett som visas för handeln med verktygsbudbärarfången.",
                    label = "Belöningsetikett",
                },
                jailJobsCarryBoxModel = {
                    description = "Objektmodell som används för bärjobbets låda.",
                    label = "Lådmodell för bärjobb",
                },
                jailJobsCarryDropoffKey = {
                    description = "Kontrollkod som används för att lämna av lådor i bärjobbet.",
                    label = "Avlämningstangent för bärjobb",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Avlämningsradie för bärjobbet.",
                    label = "Avlämningsradie",
                },
                jailJobsCarryInspectKey = {
                    description = "Kontrollkod som används för att inspektera bärjobbets lådor.",
                    label = "Inspektionstangent",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Skrotföremål som kan hittas vid inspektion av bärjobbets lådor.",
                    label = "Skrotföremål vid inspektion",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Chans för en användbar belöning vid inspektion av lådor.",
                    label = "Chans för användbart byte",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Användbara föremål som kan hittas vid inspektion av bärjobbets lådor.",
                    label = "Användbara inspektionsföremål",
                },
                jailJobsCarryInteractDistance = {
                    description = "Interaktionsavstånd för fängelsets bärjobb.",
                    label = "Interaktionsavstånd för bärjobb",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maximalt tillåtet avstånd för framsteg i bärjobbet.",
                    label = "Maxavstånd för bärjobb",
                },
                jailJobsCarryPickupKey = {
                    description = "Kontrollkod som används för att plocka upp lådor i bärjobbet.",
                    label = "Upphämtningstangent för bärjobb",
                },
                jailJobsCarryPickupOffset = {
                    description = "Förskjutningsobjekt som används för bärjobbets upphämtningsplats.",
                    label = "Förskjutning för upphämtning",
                },
                jailJobsCarryTimeReduction = {
                    description = "Strafflindring för att slutföra fängelsets bärjobb.",
                    label = "Strafflindring för bärjobb",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Kontrollkod som används vid fängelsets soptunna.",
                    label = "Tangent för soptunna",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modell som används för fängelsestädningens soptunneobjekt.",
                    label = "Modell för soptunna",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Chans att hitta smuggelgods under städning.",
                    label = "Chans att hitta olagligt",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Föremål som kan hittas vid städning i fängelset.",
                    label = "Föremål för olagliga fynd",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Tidsgräns för prompten om olagliga fynd i millisekunder.",
                    label = "Tidsgräns för fyndprompt",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Avstånd som används för interaktion med städskräp.",
                    label = "Interaktionsavstånd för städning",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maximalt avstånd innan städobjekt återställs eller försvinner.",
                    label = "Maxavstånd för städning",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maximalt antal samtidiga skräpobjekt för fängelsestädning.",
                    label = "Max antal skräpobjekt",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minsta avstånd från centrum för generering av städskräp.",
                    label = "Minsta genereringsradie",
                },
                jailJobsCleaningPickupKey = {
                    description = "Kontrollkod som används för att plocka upp fängelsestädningens skräp.",
                    label = "Upphämtningstangent för städning",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Millisekunder mellan genereringsförsök av städskräp.",
                    label = "Genereringsintervall för skräp",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Radie som används för att generera skräpobjekt för städning.",
                    label = "Genereringsradie för skräp",
                },
                jailJobsCleaningTrashModels = {
                    description = "Skräpobjektmodeller som används för fängelsets städjobb.",
                    itemLabel = "Modell",
                    label = "Skräpmodeller",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "RGBA-konturfärg som används för fängelsestädningens skräpobjekt.",
                    label = "Konturfärg",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Aktivera konturer på fängelsestädningens skräpobjekt.",
                    label = "Kontur för skräp",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "Shader-ID som används för fängelsestädningens skräpkonturer.",
                    label = "Konturshader",
                },
                jailJobsTimeReduction = {
                    description = "Strafflindring för att slutföra fängelsets städjobb.",
                    label = "Strafflindring för städning",
                },
                jailJobsTrashGoal = {
                    description = "Antal skräpföremål som krävs för att slutföra fängelsets städjobb.",
                    label = "Skräpmål för städning",
                },
                jailMaxMonths = {
                    description = "Högsta valbara fängelsetid.",
                    label = "Högsta antal månader",
                },
                jailMinMonths = {
                    description = "Minsta valbara fängelsetid.",
                    label = "Minsta antal månader",
                },
                jailMonthMinutes = {
                    description = "Realtidsminuter som en fängelsemånad motsvarar.",
                    label = "Minuter per månad",
                },
                jailObjectStreamDistance = {
                    description = "Avstånd som används för streaming av fängelsets permanenta världsobjekt.",
                    label = "Laddningsavstånd för objekt",
                },
                jailOutfitApplyDelayMs = {
                    description = "Fördröjning efter anslutning innan fängelseoutfiten tillämpas.",
                    label = "Fördröjning för outfit",
                },
                jailOutfitEnabled = {
                    description = "Aktivera fängelseoutfits.",
                    label = "Fängelseoutfit",
                },
                jailOutfitFemaleArms = {
                    description = "Komponent för kvinnlig fängelseoutfits armar.",
                    label = "Armar",
                },
                jailOutfitFemaleChain1 = {
                    description = "Utseende för kvinnlig fängelseoutfits kedja.",
                    label = "Kedja 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Textur för kvinnlig fängelseoutfits kedja.",
                    label = "Kedja 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Utseende för kvinnlig fängelseoutfits dekaler.",
                    label = "Dekaler 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Textur för kvinnlig fängelseoutfits dekaler.",
                    label = "Dekaler 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Utseende för kvinnlig fängelseoutfits glasögon (-1 tar bort glasögonen).",
                    label = "Glasögon 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Textur för kvinnlig fängelseoutfits glasögon.",
                    label = "Glasögon 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Utseende för kvinnlig fängelseoutfits hjälm.",
                    label = "Hjälm 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Textur för kvinnlig fängelseoutfits hjälm.",
                    label = "Hjälm 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Utseende för kvinnlig fängelseoutfits byxor.",
                    label = "Byxor 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Textur för kvinnlig fängelseoutfits byxor.",
                    label = "Byxor 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Utseende för kvinnlig fängelseoutfits skor.",
                    label = "Skor 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Textur för kvinnlig fängelseoutfits skor.",
                    label = "Skor 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Utseende för kvinnlig fängelseoutfits överkropp.",
                    label = "Överkropp 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Textur för kvinnlig fängelseoutfits överkropp.",
                    label = "Överkropp 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Utseende för kvinnlig fängelseoutfits T-shirt.",
                    label = "T-shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Textur för kvinnlig fängelseoutfits T-shirt.",
                    label = "T-shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Komponent för manlig fängelseoutfits armar.",
                    label = "Armar",
                },
                jailOutfitMaleChain1 = {
                    description = "Utseende för manlig fängelseoutfits kedja.",
                    label = "Kedja 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Textur för manlig fängelseoutfits kedja.",
                    label = "Kedja 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Utseende för manlig fängelseoutfits dekaler.",
                    label = "Dekaler 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Textur för manlig fängelseoutfits dekaler.",
                    label = "Dekaler 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Utseende för manlig fängelseoutfits glasögon (-1 tar bort glasögonen).",
                    label = "Glasögon 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Textur för manlig fängelseoutfits glasögon.",
                    label = "Glasögon 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Utseende för manlig fängelseoutfits hjälm.",
                    label = "Hjälm 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Textur för manlig fängelseoutfits hjälm.",
                    label = "Hjälm 2",
                },
                jailOutfitMalePants1 = {
                    description = "Utseende för manlig fängelseoutfits byxor.",
                    label = "Byxor 1",
                },
                jailOutfitMalePants2 = {
                    description = "Textur för manlig fängelseoutfits byxor.",
                    label = "Byxor 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Utseende för manlig fängelseoutfits skor.",
                    label = "Skor 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Textur för manlig fängelseoutfits skor.",
                    label = "Skor 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Utseende för manlig fängelseoutfits överkropp.",
                    label = "Överkropp 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Textur för manlig fängelseoutfits överkropp.",
                    label = "Överkropp 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Utseende för manlig fängelseoutfits T-shirt.",
                    label = "T-shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Textur för manlig fängelseoutfits T-shirt.",
                    label = "T-shirt 2",
                },
                jailRequireJailTerminal = {
                    description = "Tillåt fängelsestraff från poliser endast nära en terminal för det valda fängelset.",
                    label = "Kräv fängelseterminal",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Återställ den sparade civila outfiten när en fånge rymmer.",
                    label = "Återställ outfit vid rymning",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Tidsfönster efter återställning innan korrigeringen av startpunkt slutar tillämpas.",
                    label = "Fönster för återställningskorrigering",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleportera återställda fångar tillbaka till fängelsets startpunkt om de laddas in utanför fängelsezonen.",
                    label = "Teleportera återställda fångar",
                },
                jailTerminalRange = {
                    description = "Maximalt avstånd från polisen till en terminal för det valda fängelset.",
                    label = "Avstånd till fängelseterminal",
                },
                jailZoneExitGraceMs = {
                    description = "Tidsfönster innan ett utträde ur fängelsezonen kan räknas som en rymning.",
                    label = "Marginal för zonutträde",
                },
                mugshotAnimDict = {
                    description = "Animationsordlista som används vid fotografering av signalementsfoto.",
                    label = "Animationsordlista",
                },
                mugshotAnimFlag = {
                    description = "Animationsflagga som används vid fotografering av signalementsfoto.",
                    label = "Animationsflagga",
                },
                mugshotAnimName = {
                    description = "Animationsnamn som används vid fotografering av signalementsfoto.",
                    label = "Animationsnamn",
                },
                mugshotBoardHeader = {
                    description = "Huvudrubrik som visas på skylten för signalementsfoto.",
                    label = "Skyltens huvudrubrik",
                },
                mugshotBoardSubheader = {
                    description = "Reservunderrubrik som visas på skylten för signalementsfoto.",
                    label = "Skyltens underrubrik",
                },
                mugshotCameraCoordsX = {
                    description = "Kamerans världskoordinat X som används för signalementsfoto.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Kamerans världskoordinat Y som används för signalementsfoto.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Kamerans världskoordinat Z som används för signalementsfoto.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Synfält som används för fotografering av signalementsfoto.",
                    label = "Kamerans synfält",
                },
                mugshotCameraRotX = {
                    description = "Kamerans X-rotation som används för signalementsfoto.",
                    label = "Rotation X",
                },
                mugshotCameraRotY = {
                    description = "Kamerans Y-rotation som används för signalementsfoto.",
                    label = "Rotation Y",
                },
                mugshotCameraRotZ = {
                    description = "Kamerans Z-rotation som används för signalementsfoto.",
                    label = "Rotation Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maximalt antal millisekunder som tillåts för återanrop vid fotografering av signalementsfoto.",
                    label = "Tidsgräns för fotografering",
                },
                mugshotEnabled = {
                    description = "Aktivera fotografering av signalementsfoto vid fängelseintagning.",
                    label = "Fotografering av signalementsfoto",
                },
                mugshotHeading = {
                    description = "Riktning som tillämpas vid fotografering av signalementsfoto.",
                    label = "Riktning",
                },
                mugshotLocationX = {
                    description = "Världskoordinat X som används för fotografering av signalementsfoto.",
                    label = "Plats X",
                },
                mugshotLocationY = {
                    description = "Världskoordinat Y som används för fotografering av signalementsfoto.",
                    label = "Plats Y",
                },
                mugshotLocationZ = {
                    description = "Världskoordinat Z som används för fotografering av signalementsfoto.",
                    label = "Plats Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Beskrivningsformat som används för den lagrade metadatan för signalementsfoto.",
                    label = "Metadatabeskrivning",
                },
                mugshotMetadataName = {
                    description = "Metadatanamn i inventariet som används för det lagrade signalementsfotot.",
                    label = "Metadatanamn",
                },
                mugshotWaitMs = {
                    description = "Millisekunder att vänta innan signalementsfotot tas.",
                    label = "Väntemillisekunder",
                },
                playerSearchAnimDict = {
                    description = "Animationsordlista som används vid visitering.",
                    label = "Animationsordlista",
                },
                playerSearchAnimFlag = {
                    description = "Animationsflagga som används vid visitering.",
                    label = "Animationsflagga",
                },
                playerSearchAnimName = {
                    description = "Animationsnamn som används vid visitering.",
                    label = "Animationsnamn",
                },
                playerSearchDurationMs = {
                    description = "Varaktighet för visiteringens förhandsvisning i millisekunder.",
                    label = "Visiteringstid",
                },
                playerSearchEnabled = {
                    description = "Aktivera flödet för visiteringsförhandsvisning.",
                    label = "Visitering",
                },
                playerSearchRange = {
                    description = "Maximalt avstånd för att påbörja en visitering.",
                    label = "Visiteringsavstånd",
                },
                playerSearchScenario = {
                    description = "Scenario som används när ingen uttrycklig visiteringsanimation spelas upp.",
                    label = "Visiteringsscenario",
                },
                policeBillingControl200 = {
                    label = "Fakturering · Kontroll 200",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeBillingControl322 = {
                    label = "Fakturering · Kontroll 322",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl10 = {
                    label = "Redigerare · Kontroll 10",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl11 = {
                    label = "Redigerare · Kontroll 11",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl172 = {
                    label = "Redigerare · Kontroll 172",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl173 = {
                    label = "Redigerare · Kontroll 173",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl174 = {
                    label = "Redigerare · Kontroll 174",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl175 = {
                    label = "Redigerare · Kontroll 175",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl177 = {
                    label = "Redigerare · Kontroll 177",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl191 = {
                    label = "Redigerare · Kontroll 191",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl201 = {
                    label = "Redigerare · Kontroll 201",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl202 = {
                    label = "Redigerare · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl21 = {
                    label = "Redigerare · Kontroll 21",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl32 = {
                    label = "Redigerare · Kontroll 32",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl322 = {
                    label = "Redigerare · Kontroll 322",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl33 = {
                    label = "Redigerare · Kontroll 33",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl34 = {
                    label = "Redigerare · Kontroll 34",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl35 = {
                    label = "Redigerare · Kontroll 35",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl36 = {
                    label = "Redigerare · Kontroll 36",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl37 = {
                    label = "Redigerare · Kontroll 37",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl38 = {
                    label = "Redigerare · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl44 = {
                    label = "Redigerare · Kontroll 44",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policeEditorControl73 = {
                    label = "Redigerare · Kontroll 73",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                policePrimaryColor = {
                    description = "Standardfärg för polisens jobbgrupp.",
                    label = "Primärfärg",
                },
                propPlacementConsumeItem = {
                    description = "Ta bort ett inventarieföremål när ett objekt placeras ut.",
                    label = "Förbruka objektföremål",
                },
                propPlacementEnabled = {
                    description = "Tillåt att konfigurerade polisobjekt placeras ut från föremål eller fordon.",
                    label = "Objektplacering",
                },
                propPlacementItemNames = {
                    description = "Koppla objektmodeller till inventarieföremålens namn för föremålsbaserad objektplacering.",
                    label = "Namn för objektföremål",
                },
                propPlacementRequireOnDuty = {
                    description = "Endast poliser i tjänst kan placera ut konfigurerade objekt.",
                    label = "Objekt kräver tjänst",
                },
                propPlacementReturnItem = {
                    description = "Ge tillbaka det förbrukade föremålet när ett utplacerat objekt tas bort.",
                    label = "Återlämna objektföremål",
                },
                propPlacementVehicleAccess = {
                    description = "Tillåt att jobbfordon exponerar sin konfigurerade objektsutrustning.",
                    label = "Åtkomst till fordonsobjekt",
                },
                radialEnabled = {
                    description = "Aktivera polisens radialåtgärder.",
                    label = "Polisradial",
                },
                radialHandcuffKeybindCommand = {
                    description = "Kommandonamn som registreras för snabbtangenten för handfängsel.",
                    label = "Kommando för handfängsel",
                },
                radialHandcuffKeybindDescription = {
                    description = "Beskrivning som visas för snabbtangenten för handfängsel.",
                    label = "Beskrivning för handfängsel",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Aktivera den direkta snabbtangenten för handfängsel.",
                    label = "Snabbtangent för handfängsel",
                },
                radialHandcuffKeybindKey = {
                    description = "Tangentbordstangent som används för den direkta handfängselåtgärden.",
                    label = "Tangent för handfängsel",
                },
                radialKeybindsEnabled = {
                    description = "Aktivera direkta snabbtangenter för valda radialåtgärder.",
                    label = "Direkta snabbtangenter",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Kommandonamn som registreras för snabbtangenten för att ta bort handfängsel.",
                    label = "Kommando för att ta bort handfängsel",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Beskrivning som visas för snabbtangenten att ta bort handfängsel.",
                    label = "Beskrivning för att ta bort handfängsel",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Aktivera den direkta snabbtangenten för att ta bort handfängsel.",
                    label = "Snabbtangent för att ta bort handfängsel",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Tangentbordstangent som används för den direkta åtgärden att ta bort handfängsel.",
                    label = "Tangent för att ta bort handfängsel",
                },
                socialWorkAssignRange = {
                    description = "Maximalt avstånd för att tilldela uppgifter inom socialt arbete.",
                    label = "Tilldelningsavstånd",
                },
                socialWorkDeadlineDefault = {
                    description = "Standardtidsfrist för socialt arbete i minuter. Noll inaktiverar tidsfrister.",
                    label = "Standardtidsfrist",
                },
                socialWorkDeadlineMax = {
                    description = "Högsta tidsfrist för socialt arbete i minuter. Noll inaktiverar taket.",
                    label = "Högsta tidsfrist",
                },
                socialWorkDeadlineMin = {
                    description = "Minsta tidsfrist för socialt arbete i minuter.",
                    label = "Minsta tidsfrist",
                },
                socialWorkDefaultTasks = {
                    description = "Standardantal uppgifter när tilldelning av socialt arbete öppnas.",
                    label = "Standardantal uppgifter",
                },
                socialWorkEnabled = {
                    description = "Aktivera tilldelning och uppgiftsflöden för socialt arbete.",
                    label = "Socialtjänst",
                },
                socialWorkImprisonmentJailId = {
                    description = "Fängelse-ID som används när överträdelser inom socialt arbete leder till fängelse.",
                    label = "Reservfängelse-ID",
                },
                socialWorkImprisonmentMonths = {
                    description = "Antal månader som tilldelas när överträdelser inom socialt arbete resulterar i fängelse.",
                    label = "Fängelsemånader",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Tjänstemannens namn som används för fängelseposter inom socialt arbete.",
                    label = "Tjänstemannens namn vid fängslande",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Skicka överträdare till isolering när fängelsestraff utlöses.",
                    label = "Använd isolering",
                },
                socialWorkInactivityMinutes = {
                    description = "Minuter innan påföljder för inaktivitet inom socialt arbete tillämpas.",
                    label = "Minuter för inaktivitet",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Uppgiftspåföljd som tillämpas när en spelare inom socialt arbete är inaktiv för länge.",
                    label = "Uppgiftspåföljd för inaktivitet",
                },
                socialWorkMaxTasks = {
                    description = "Högsta valbara antal uppgifter för socialt arbete.",
                    label = "Högsta antal uppgifter",
                },
                socialWorkMinTasks = {
                    description = "Minsta valbara antal uppgifter för socialt arbete.",
                    label = "Minsta antal uppgifter",
                },
                speedCamBillingEnabled = {
                    description = "Utfärda automatiska fakturor när fartkameror fångar en matchande överträdelse. Kräver att den globala funktionen Fakturering är aktiverad.",
                    label = "Automatiska böter",
                },
                speedCamBillingExcludedJobs = {
                    description = "Jobb som aldrig får automatiska fakturor från fartkameror.",
                    itemLabel = "Jobb",
                    label = "Undantagna jobb",
                },
                speedCamBillingExcludedModels = {
                    description = "Fordonens spawnnamn som aldrig får automatiska fakturor från fartkameror.",
                    itemLabel = "Modell",
                    label = "Undantagna fordonsmodeller",
                },
                speedCamBillingRules = {
                    description = "Bötesregler som används av fartkameror. Det snävast matchande överträdelseintervallet faktureras först; om ingen regel matchar används SpeedViolation-brott som reserv.",
                    label = "Bötesregler",
                },
                speedCamCameraEaseMs = {
                    description = "Hur länge det tar för vyn att glida in i fartkamerans vinkel. Lägre = kortare svängning; för lågt kan förskjuta fotot.",
                    label = "Kamerainton (ms)",
                },
                speedCamCameraFov = {
                    description = "Synfält som används för fartkamerans fotografering.",
                    label = "Kamerans synfält",
                },
                speedCamCheckIntervalMs = {
                    description = "Millisekunder mellan fartkameraskanningar.",
                    label = "Kontrollintervall",
                },
                speedCamCooldownMs = {
                    description = "Millisekunder innan samma fartkamera kan utlösas igen.",
                    label = "Utlösningsnedkylning",
                },
                speedCamDamageCooldownMs = {
                    description = "Millisekunder innan fartkameran kan skadas igen.",
                    label = "Nedkylning för skada",
                },
                speedCamDamagePerHit = {
                    description = "Hållbarhetsskada som tillämpas på fartkameror per träff.",
                    label = "Skada per träff",
                },
                speedCamDamagedModelThreshold = {
                    description = "Procent av maximal hållbarhet vid eller under vilken den skadade modellen visas. Exempel: 50 med maximal hållbarhet 200 byter modell vid 100 hållbarhet.",
                    label = "Gräns för skadad modell (%)",
                },
                speedCamDefaultLimit = {
                    description = "Standardhastighetsgräns för fartkamera.",
                    label = "Standardhastighetsgräns",
                },
                speedCamDefaultName = {
                    description = "Föreslaget visningsnamn när en fartkamera placeras. Namnet kan översättas utan att ändra inventarieföremålet eller objektmodellen.",
                    label = "Standardnamn",
                },
                speedCamDefaultTolerance = {
                    description = "Standardtolerans för fartkamera.",
                    label = "Standardtolerans",
                },
                speedCamDisassembleDistance = {
                    description = "Avstånd som används för att demontera fartkameror.",
                    label = "Demonteringsavstånd",
                },
                speedCamEnabled = {
                    description = "Aktivera bärbara fartkameror.",
                    label = "Fartkameror",
                },
                speedCamFlashColor = {
                    description = "RGBA-blixtfärg som används av fartkameror.",
                    label = "Blixtfärg",
                },
                speedCamFlashDurationMs = {
                    description = "Uttoningstid för den röda fartkameroblixten. Ställ inte in för lågt, annars blir kamerans svängning synlig.",
                    label = "Blixttid (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Avstånd på vilket fartkamerans hållbarhet visas.",
                    label = "Visningsavstånd för hållbarhet",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Millisekunder som fartkamerans hållbarhet förblir synlig.",
                    label = "Visningstid för hållbarhet",
                },
                speedCamHealthTextOffset = {
                    description = "Vertikal förskjutning som används för fartkamerans hållbarhetstext.",
                    label = "Textförskjutning för hållbarhet",
                },
                speedCamItem = {
                    description = "Exakt internt föremålsnamn i inventariet, till exempel speedcam. Ange föremålets nyckel, inte visningsnamnet; jobbets butik måste ge samma föremål.",
                    label = "Fartkamerans föremålsnamn",
                },
                speedCamMaintenanceThreshold = {
                    description = "Hållbarhetströskel där underhåll av fartkamera rekommenderas.",
                    label = "Underhållströskel",
                },
                speedCamMaxDurability = {
                    description = "Maximal hållbarhet för utplacerade fartkameror.",
                    label = "Max hållbarhet",
                },
                speedCamMaxLimit = {
                    description = "Högsta konfigurerbara hastighetsgräns för fartkamera.",
                    label = "Högsta hastighetsgräns",
                },
                speedCamMaxTolerance = {
                    description = "Högsta konfigurerbara tolerans för fartkamera.",
                    label = "Högsta tolerans",
                },
                speedCamPhotoLocale = {
                    description = "Valfri språkinställning som används för tidsstämpeln på fartkamerafoton. Lämna tomt för att använda den fotograferade spelarens lokala inställning.",
                    label = "Foto-språkinställning",
                },
                speedCamPhotoTimeZone = {
                    description = "Valfri tidszon som används för tidsstämpeln på fartkamerafoton. Lämna tomt för att använda den fotograferade spelarens lokala tidszon.",
                    label = "Fototidszon",
                },
                speedCamPoliceNotification = {
                    description = "Skicka en utryckningsavisering när fartkameror fångar överträdelser.",
                    label = "Polislarm för fartkamera",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Behandla fartkamerans utryckningsmål som en jobbgrupp.",
                    label = "Utryckningsmål är grupp",
                },
                speedCamPoliceNotificationJob = {
                    description = "Jobb- eller gruppnyckel som används för fartkamerans utryckningsaviseringar.",
                    label = "Utryckningsmål",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Meddela endast fartkamerans utryckningsmål som är i tjänst.",
                    label = "Utryckning kräver tjänst",
                },
                speedCamPoliceNotificationType = {
                    description = "Allvarlighetsgrad/typ av utryckning som används för fartkameralarm.",
                    label = "Utryckningstyp",
                },
                speedCamPropModel = {
                    description = "Spawnnamn för den oskadade kameramodellen, till exempel sky_speedcam. Ett förval väljer även de skadade och förstörda modellerna. Egna modeller måste finnas tillgängliga i spelet.",
                    label = "Objektmodell för fartkamera",
                    custom = "Egen modell",
                    choose = "Välj modell",
                    preview = "3D-förhandsvisning",
                    customPlaceholder = "Propens spawnnamn",
                    previewDescription = "Visa vald prop i spelet. Förhandsvisningen sparar inga ändringar.",
                    invalidModel = "Ange först ett giltigt propnamn.",
                    modelMissing = "Den här propmodellen finns inte i spelet.",
                    previewFailed = "Det gick inte att öppna modellens förhandsvisning.",
                    intact = "Hel propmodell",
                    previewRequiresGame = "Öppna /jobconfig i FiveM för att se propen live.",
                    previewHelp = "Pilar: flytta; PageUp/PageDown: höjd; mushjul: rotera; Enter: stäng; Backspace: avbryt.",
                    options = {
                        sky_speedcam = "Standardfartkamera",
                        sky_germ_speedcam = "Tysk fartkamera",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Spawnnamn för den skadade kameramodellen, till exempel sky_speedcam2. Använd en variant som passar den oskadade modellen.",
                    label = "Skadad objektmodell",
                },
                speedCamPropModelDestroyed = {
                    description = "Spawnnamn för modellen som visas när kamerans hållbarhet når 0, till exempel sky_speedcam1. Använd en variant som passar den oskadade modellen.",
                    label = "Förstörd objektmodell",
                },
                speedCamRepairAnimDict = {
                    description = "Animationsordlista som används vid reparation av fartkameror.",
                    label = "Animationsordlista för reparation",
                },
                speedCamRepairAnimFlag = {
                    description = "Animationsflagga som används vid reparation av fartkameror.",
                    label = "Animationsflagga för reparation",
                },
                speedCamRepairAnimName = {
                    description = "Animationsnamn som används vid reparation av fartkameror.",
                    label = "Animationsnamn för reparation",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Millisekunder innan fartkamerans reparation kan avbrytas.",
                    label = "Fördröjning för avbruten reparation",
                },
                speedCamRepairDistance = {
                    description = "Avstånd som används för att reparera fartkameror.",
                    label = "Reparationsavstånd",
                },
                speedCamRepairItem = {
                    description = "Exakt internt föremålsnamn för reparationer, till exempel fixtool. Ange föremålets nyckel, inte visningsnamnet.",
                    label = "Reparationsföremålets namn",
                },
                speedCamRepairPerTick = {
                    description = "Hållbarhet som återställs per reparationstakt för fartkamera.",
                    label = "Reparation per takt",
                },
                speedCamRepairTickMs = {
                    description = "Millisekunder mellan fartkamerans reparationstakter.",
                    label = "Reparationstakt",
                },
                speedCamStreamDistance = {
                    description = "Avstånd från spelaren i meter inom vilket kameramodeller laddas. Utanför avståndet laddas modellerna ur; sparade kameror står kvar.",
                    label = "Laddningsavstånd",
                },
                speedCamTriggerRadius = {
                    description = "Detektionsradie i meter runt kameran för fordon som kör för fort.",
                    label = "Utlösningsradie",
                },
                speedCamUseMph = {
                    description = "Visa och bearbeta fartkamerans gränser i MPH.",
                    label = "Använd MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Vapen som tillåts skada fartkameror medan begränsningen är aktiverad.",
                    itemLabel = "Vapen",
                    label = "Tillåtna vapen",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Endast listade vapen kan skada fartkameror medan detta är aktiverat.",
                    label = "Begränsning aktiverad",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Avstånd i meter innan varningar om fartkameror rensas.",
                    label = "Rensningsavstånd",
                },
                speedCameraAppDefaultApp = {
                    description = "Visa fartkameraappen som en standardapp på surfplattan.",
                    label = "Standardapp",
                },
                speedCameraAppDescription = {
                    description = "Beskrivning som visas för fartkameraappen på surfplattan.",
                    label = "Beskrivning",
                },
                speedCameraAppDeveloper = {
                    description = "Utvecklaretikett som visas för fartkameraappen på surfplattan.",
                    label = "Utvecklare",
                },
                speedCameraAppEnabled = {
                    description = "Aktivera polisens surfplatteapp för fartkameror.",
                    label = "Fartkameraapp för surfplatta",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Överrubrik som visas i fartkameraappen.",
                    label = "Överrubrik",
                },
                speedCameraAppHeaderTitle = {
                    description = "Rubrik som visas i fartkameraappen.",
                    label = "Rubrik",
                },
                speedCameraAppIcon = {
                    description = "Ikonsökväg som används för fartkameraappen på surfplattan.",
                    label = "Ikonsökväg",
                },
                speedCameraAppIdentifier = {
                    description = "Intern identifierare för fartkameraappen på surfplattan.",
                    label = "Identifierare",
                },
                speedCameraAppInFrontDot = {
                    description = "Tröskelvärde som används för att avgöra om en fartkamera befinner sig framför spelaren.",
                    label = "Riktningströskel framför",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Lägsta fordonshastighet i KMH innan varningar visas.",
                    label = "Lägsta fordonshastighet",
                },
                speedCameraAppName = {
                    description = "Visningsnamn för fartkameraappen på surfplattan.",
                    label = "Appnamn",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Avstånd i meter innan en avisering skickas om närliggande fartkameror.",
                    label = "Aviseringsavstånd",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Varna endast om fartkameror medan spelaren befinner sig i ett fordon.",
                    label = "Endast i fordon",
                },
                speedCameraAppOverlayBackground = {
                    description = "Bakgrundsfärg som används för skyltbildens överlägg.",
                    label = "Bakgrund för överlägg",
                },
                speedCameraAppOverlayBorder = {
                    description = "Kantfärg som används för skyltbildens överlägg.",
                    label = "Kant för överlägg",
                },
                speedCameraAppOverlayColor = {
                    description = "Textfärg som används för skyltbildens överlägg.",
                    label = "Färg för överlägg",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Aktivera skyltöverlägg på tagna bilder från fartkameran.",
                    label = "Överlägg aktiverat",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Teckenskala som används för skyltbildens överlägg.",
                    label = "Teckenskala för överlägg",
                },
                speedCameraAppOverlayX = {
                    description = "Normaliserad X-position för överlägget från vänster till höger.",
                    label = "Överlägg X",
                },
                speedCameraAppOverlayY = {
                    description = "Normaliserad Y-position för överlägget från topp till botten.",
                    label = "Överlägg Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Varna endast för fartkameror som befinner sig framför spelaren.",
                    label = "Kräver framför",
                },
                speedCameraAppRoute = {
                    description = "Routersökväg som öppnas av fartkameraappen på surfplattan.",
                    label = "Rutt",
                },
                speedCameraAppSize = {
                    description = "Rapporterad lagringsstorlek för fartkameraappen på surfplattan.",
                    label = "Appstorlek",
                },
                speedCameraAppSoundCoord = {
                    description = "Spela varningsljud för fartkamera vid världskoordinater.",
                    label = "Koordinatljud",
                },
                speedCameraAppSoundEnabled = {
                    description = "Aktivera varningsljud för fartkameraappen.",
                    label = "Ljud aktiverat",
                },
                speedCameraAppSoundFrontend = {
                    description = "Spela varningsljud för fartkamera på frontend-ljudkanalen.",
                    label = "Frontend-ljud",
                },
                speedCameraAppSoundLayers = {
                    description = "Antal lagrade varningsljud som spelas av fartkameraappen.",
                    label = "Ljudlager",
                },
                speedCameraAppSoundName = {
                    description = "Ljudnamn som används för varningar i fartkameraappen.",
                    label = "Ljudnamn",
                },
                speedCameraAppSoundRange = {
                    description = "Räckvidd som används för fartkameraappens varningsljud.",
                    label = "Ljudräckvidd",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Antal gånger fartkamerans varningsljud upprepas.",
                    label = "Antal upprepningar",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Millisekunder mellan upprepningar av fartkamerans varningsljud.",
                    label = "Fördröjning mellan upprepningar",
                },
                speedCameraAppSoundSet = {
                    description = "Ljuduppsättning som används för varningar i fartkameraappen.",
                    label = "Ljuduppsättning",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Konto som används för betalningar av abonnemanget på surfplattans fartkameraapp.",
                    label = "Konto",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Aktivera betalabonnemang för surfplattans fartkameraapp.",
                    label = "Abonnemang aktiverat",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Antal dagar mellan förnyelser av abonnemanget för surfplattans fartkameraapp.",
                    label = "Intervall i dagar",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Pris som debiteras för abonnemanget på surfplattans fartkameraapp.",
                    label = "Abonnemangspris",
                },
                speedCameraAppThemeAccent = {
                    description = "Accentfärg som används av fartkameraappen.",
                    label = "Accent",
                },
                speedCameraAppThemeBackground = {
                    description = "Linjär gradientbakgrund som används av fartkameraappen.",
                    label = "Bakgrund",
                },
                speedCameraAppThemeBorder = {
                    description = "Kantfärg som används av fartkameraappen.",
                    label = "Kant",
                },
                speedCameraAppThemeButtonText = {
                    description = "Knapptextens färg som används av fartkameraappen.",
                    label = "Knapptext",
                },
                speedCameraAppThemeDanger = {
                    description = "Farofärg som används av fartkameraappen.",
                    label = "Fara",
                },
                speedCameraAppThemeGhost = {
                    description = "Ghost-knappens färg som används av fartkameraappen.",
                    label = "Spöke",
                },
                speedCameraAppThemeGhostText = {
                    description = "Ghost-textens färg som används av fartkameraappen.",
                    label = "Ghost-text",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Mjuk gradientfärg som används av fartkameraappen.",
                    label = "Mjuk gradient",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Inaktiv kantfärg som används av fartkameraappen.",
                    label = "Inaktiv kant",
                },
                speedCameraAppThemeModal = {
                    description = "Bakgrundsfärg för modal som används av fartkameraappen.",
                    label = "Ändrad",
                },
                speedCameraAppThemeMutedText = {
                    description = "Nedtonad textfärg som används av fartkameraappen.",
                    label = "Nedtonad text",
                },
                speedCameraAppThemeOverlay = {
                    description = "Överläggsfärg som används av fartkameraappen.",
                    label = "Överlägg",
                },
                speedCameraAppThemePillText = {
                    description = "Kapseltextens färg som används av fartkameraappen.",
                    label = "Kapseltext",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Primär gradientens startfärg som används av fartkameraappen.",
                    label = "Primär från",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Primär gradientens slutfärg som används av fartkameraappen.",
                    label = "Primär till",
                },
                speedCameraAppThemeShadow = {
                    description = "Skuggfärg som används av fartkameraappen.",
                    label = "Skugga",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Spotlightens accentfärg som används av fartkameraappen.",
                    label = "Spotlight",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Diskret textfärg som används av fartkameraappen.",
                    label = "Diskret text",
                },
                speedCameraAppThemeSuccess = {
                    description = "Framgångsfärg som används av fartkameraappen.",
                    label = "Framgång",
                },
                speedCameraAppThemeSurface = {
                    description = "Ytfärg som används av fartkameraappen.",
                    label = "Yta",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Mjuk ytfärg som används av fartkameraappen.",
                    label = "Mjuk yta",
                },
                speedCameraAppThemeText = {
                    description = "Primär textfärg som används av fartkameraappen.",
                    label = "Texttext",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA-accentfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Accent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA-färg som används för bakgrunden i varningsgränssnittet för fartkamera.",
                    label = "Bakgrund RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA-ikonfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Ikon RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA-ikontextfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Ikontext RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Antal sekunder som varningsgränssnittet förblir synligt.",
                    label = "Sekunder för varningsgränssnitt",
                },
                speedCameraAppWarningUiSubText = {
                    description = "RGBA-undertextfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Undertext RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "RGBA-textfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Text RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "RGBA-titelfärg som används för varningsgränssnittet för fartkamera.",
                    label = "Titel RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Millisekunder mellan kontroller av spikmattors närhet.",
                    label = "Kontrollintervall",
                },
                spikeStripsEnabled = {
                    description = "Aktivera utplacerade spikmattor.",
                    label = "Spikmattor",
                },
                spikeStripsModels = {
                    description = "Objektmodeller som räknas som aktiva spikmattor.",
                    itemLabel = "Modell",
                    label = "Modeller",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Millisekunder innan skanning av spikmattor försöker igen efter ingen träff.",
                    label = "Återförsöksintervall",
                },
                spikeStripsScanDistance = {
                    description = "Avstånd som används för att skanna efter närliggande spikmattor.",
                    label = "Skanningsavstånd",
                },
                spikeStripsTriggerDistance = {
                    description = "Avstånd på vilket däck sprängs av en spikmatta.",
                    label = "Utlösningsavstånd",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Kategorietikett som används för stationsskaparens kartmarkörer.",
                    label = "Kategori för stationsmarkör",
                },
                stationCreatorBlipColor = {
                    description = "Kartmarkörens färg som används för polisstationer.",
                    label = "Färg för stationsmarkör",
                },
                stationCreatorBlipScale = {
                    description = "Skala som används för polisstationers kartmarkörer.",
                    label = "Skala för stationsmarkör",
                },
                stationCreatorBlipShortRange = {
                    description = "Visa stationsmarkörer endast på kort avstånd.",
                    label = "Kort räckvidd för stationsmarkör",
                },
                stationCreatorBlipSprite = {
                    description = "Kartmarkörens sprite som används för polisstationer.",
                    label = "Sprite för stationsmarkör",
                },
                stationCreatorBlipUseStationName = {
                    description = "Använd det konfigurerade stationsnamnet som kartmarkörens etikett.",
                    label = "Använd stationsnamn",
                },
                tabletAutoFillCitizens = {
                    description = "Förifyll medborgarregistret från framework-databasen.",
                    label = "Fyll i medborgare automatiskt",
                },
                tabletAutoFillVehicles = {
                    description = "Förifyll fordonsregistret från framework-databasen.",
                    label = "Fyll i fordon automatiskt",
                },
                tabletBolos = {
                    description = "Visa BOLO-appen.",
                    label = "BOLO",
                },
                tabletCases = {
                    description = "Visa appen för ärenden.",
                    label = "Ärenden",
                },
                tabletCitizens = {
                    description = "Visa appen för medborgarregistret.",
                    label = "Medborgare",
                },
                tabletOffences = {
                    description = "Visa appen för brott.",
                    label = "Brott",
                },
                tabletPrison = {
                    description = "Visa fängelseappen.",
                    label = "Fängelse",
                },
                tabletReportEnforcement = {
                    description = "Tillåt koppling av brott samt böter eller fängelsestraff från sparade rapporter.",
                    label = "Verkställighet från rapporter",
                },
                tabletReports = {
                    description = "Visa appen för rapporter.",
                    label = "Rapporter",
                },
                tabletSocialWork = {
                    description = "Visa appen för socialtjänst.",
                    label = "Socialtjänst",
                },
                tabletVehicles = {
                    description = "Visa appen för fordonsregistret.",
                    label = "Fordon",
                },
                tabletWarrants = {
                    description = "Visa appen för efterlysningar.",
                    label = "Efterlysningar",
                },
                tabletWeapons = {
                    description = "Visa appen för vapenregistret.",
                    label = "Vapen",
                },
                tackleCuffKey = {
                    label = "Sätt handfängsel på tacklad person",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                tackleKey = {
                    label = "Tackla",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                tackleReleaseKey = {
                    label = "Släpp tacklad person",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Millisekunder innan ytterligare ett radarlarm kan utlösas.",
                    label = "Nedkylning för larm",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Fordonsklasser som tillåts använda radarn.",
                    label = "Tillåtna fordonsklasser",
                },
                vehicleRadarAutoFastLock = {
                    description = "Flagga automatiskt mycket snabba mål i radarn.",
                    label = "Automatisk snabblåsning",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Hastighetströskel som används för automatisk snabblåsning.",
                    label = "Tröskel för snabblåsning",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Tangentbindning som används för att minska radarns hastighetsgräns.",
                    label = "Tangent för att minska gränsen",
                },
                vehicleRadarDefaultLimit = {
                    description = "Standardhastighetsgräns som används av fordonsradarn.",
                    label = "Standardgräns för radar",
                },
                vehicleRadarEnabled = {
                    description = "Aktivera patrullfordonets radar.",
                    label = "Fordonsradar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Tangentbindning som används för att öka radarns hastighetsgräns.",
                    label = "Tangent för att öka gränsen",
                },
                vehicleRadarLimitStep = {
                    description = "Mängd som ändras per justering av radarns hastighetsgräns.",
                    label = "Gränssteg",
                },
                vehicleRadarLockFrontKey = {
                    description = "Tangentbindning som används för att låsa det främre radarmålet.",
                    label = "Tangent för låsning fram",
                },
                vehicleRadarLockRearKey = {
                    description = "Tangentbindning som används för att låsa det bakre radarmålet.",
                    label = "Tangent för låsning bak",
                },
                vehicleRadarMaxLimit = {
                    description = "Högsta hastighetsgräns som tillåts i fordonsradarn.",
                    label = "Högsta radargräns",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maximal lutning som tillåts för radarns riktning.",
                    label = "Max lutningsgrader",
                },
                vehicleRadarMinLimit = {
                    description = "Lägsta hastighetsgräns som tillåts i fordonsradarn.",
                    label = "Lägsta radargräns",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Lägsta hastighet innan radarn räknar ett mål som giltigt.",
                    label = "Lägsta målhastighet",
                },
                vehicleRadarModeFrontKey = {
                    description = "Tangentbindning som används för att växla det främre radarläget.",
                    label = "Tangent för frontläge",
                },
                vehicleRadarModeRearKey = {
                    description = "Tangentbindning som används för att växla det bakre radarläget.",
                    label = "Tangent för bakläge",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Millisekunder mellan radarskanningar medan patrullfordonet är i rörelse.",
                    label = "Skanningsintervall i rörelse",
                },
                vehicleRadarPassengerControl = {
                    description = "Tillåt att passagerare kontrollerar fordonsradarn.",
                    label = "Passagerarkontroll",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Tillåt att passagerare ser speglad radardata.",
                    label = "Passagerarspegling",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Millisekunder mellan radarns synkuppdateringar för passagerare.",
                    label = "Synkintervall för passagerare",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Projektionströskel som används vid utvärdering av radarmål.",
                    label = "Projektionströskel",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Kräv fri sikt innan radarn låser ett mål.",
                    label = "Kräver fri sikt",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Kräv tjänstestatus innan fordonsradarn används.",
                    label = "Radar kräver tjänst",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Millisekunder mellan stillastående radarskanningar.",
                    label = "Skanningsintervall",
                },
                vehicleRadarScanRadius = {
                    description = "Fordonsradarns skanningsradie.",
                    label = "Skanningsradie",
                },
                vehicleRadarToggleKey = {
                    description = "Tangentbindning som används för att växla fordonsradarn.",
                    label = "Växlingstangent",
                },
                vehicleRadarUseMph = {
                    description = "Visa radarns hastighetsvärden i MPH.",
                    label = "Radar använder MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Millisekunder mellan uppdateringar av poolen med närliggande fordon.",
                    label = "Uppdatering av fordonspool",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Tangentbindning som används för XMIT/HOLD på den främre radarn.",
                    label = "Tangent för XMIT fram",
                },
                vehicleRadarXmitRearKey = {
                    description = "Tangentbindning som används för XMIT/HOLD på den bakre radarn.",
                    label = "Tangent för XMIT bak",
                },
                wheelClampConsumeItem = {
                    description = "Ta bort hjulbojeföremålet efter placering.",
                    label = "Förbruka hjulbojeföremål",
                },
                wheelClampEnabled = {
                    description = "Aktivera åtgärden för hjulboja.",
                    label = "Hjulboja",
                },
                wheelClampItem = {
                    description = "Inventarieföremål som används för att placera ut hjulbojor.",
                    label = "Hjulbojeföremål",
                },
                wheelClampPropModel = {
                    description = "Objektmodell som används för den utplacerade hjulbojan.",
                    label = "Objektmodell för hjulboja",
                },
                wheelClampRequireItem = {
                    description = "Kräv det konfigurerade hjulbojeföremålet. Behåll detta aktiverat när hjulbojans användningsläge är satt till Inventarie eller Båda.",
                    label = "Hjulboja kräver föremål",
                },
                wheelClampRequireOnDuty = {
                    description = "Kräv tjänstestatus innan hjulbojor placeras ut.",
                    label = "Hjulboja kräver tjänst",
                },
                wheelClampTyreDistance = {
                    description = "Maximalt avstånd till däcket vid placering eller svetsning av en hjulboja.",
                    label = "Däckavstånd",
                },
                wheelClampUseItem = {
                    description = "Använd radial, inventarie eller båda för placering av hjulboja. Inventarie eller Båda bör kombineras med Hjulboja kräver föremål.",
                    label = "Användningsläge för hjulboja",
                    options = {
                        both = "Båda",
                        inventory = "Inventarie",
                        radial = "Radialt",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maximalt avstånd till målfordonet när en hjulboja placeras ut.",
                    label = "Fordonsavstånd",
                },
                wheelClampWeldBurstTyre = {
                    description = "Spräng däcket efter att en hjulboja svetsats bort.",
                    label = "Spräng däck",
                },
                wheelClampWeldDurationMs = {
                    description = "Millisekunder som krävs för att svetsa bort en hjulboja.",
                    label = "Svetsningstid",
                },
                wheelClampWeldEnabled = {
                    description = "Tillåt att hjulbojor tas bort med en svets.",
                    label = "Svetsning av hjulboja",
                },
                wheelClampWeldItem = {
                    description = "Inventarieföremål som krävs för att svetsa bort hjulbojan.",
                    label = "Svetsföremål",
                },
                wheelClampWeldMinigame = {
                    description = "Kräv minispelet för hjulbojesvetsning innan borttagningen slutförs.",
                    label = "Svetsminispel",
                },
                ziptiesConsumeItem = {
                    description = "Ta bort ett buntbandsföremål när ett sätts på.",
                    label = "Förbruka buntband",
                },
                ziptiesCutterConsumeItem = {
                    description = "Ta bort klipparföremålet efter att buntband klippts av.",
                    label = "Förbruka klipparföremål",
                },
                ziptiesCutterEnabled = {
                    description = "Tillåt att buntbandsklippare tar bort buntband.",
                    label = "Buntbandsklippare",
                },
                ziptiesCutterItem = {
                    description = "Inventarieföremål som används för att klippa av buntband.",
                    label = "Klipparföremål",
                },
                ziptiesEnabled = {
                    description = "Aktivera åtgärder med buntband.",
                    label = "Buntband",
                },
                ziptiesItem = {
                    description = "Inventarieföremål som används för åtgärder med buntband.",
                    label = "Buntbandsföremål",
                },
                ziptiesRequireHandsUp = {
                    description = "Kräv att målet håller händerna upp innan buntband sätts på.",
                    label = "Buntband kräver händer upp",
                },
                ziptiesRequireItem = {
                    description = "Kräv det konfigurerade buntbandsföremålet.",
                    label = "Buntband kräver föremål",
                },
                ziptiesReturnOnRemove = {
                    description = "Återlämna ett buntbandsföremål när buntbandet tas bort.",
                    label = "Återlämna buntband",
                },
                evidenceGsrDurationSeconds = {
                    description = "Andra skottrester stannar på en spelares händer.",
                    label = "GSR varaktighet",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Förhindra GSR från att appliceras när skytten bär handskar.",
                    label = "Handskar skyddar händerna",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Vapen som inte använder krutrester.",
                    label = "Ignorerade vapen",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisekunder mellan vatten/vattenreningskontrollerna medan GSR är aktiv.",
                    label = "Kontrollintervall för tvätt",
                },
                evidenceGsrWashInRain = {
                    description = "Låt regnet avlägsna krutrester.",
                    label = "Tvätta i regn",
                },
                evidenceGsrWashInWater = {
                    description = "Låt vatten ta bort krutrester.",
                    label = "Tvätta i vatten",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam visar falsk platta",
                    description = "Visar den falska plattan i helikopterkameran.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normala verktyg visar falsk platta",
                    description = "Visar den falska plattan i vanliga polisverktyg.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar visar falsk platta",
                    description = "Visar den falska plattan på den inbyggda radarn.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Låt polisens system läsa den delade falska tallrik statsväskan.",
                    label = "Känner igen falska tallrikar",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Fordonsenhet statsväska nyckel publicerad av Mechanicjob.",
                    label = "Nyckel till statskassan",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam visar falsk platta",
                    description = "Visar den falska plattan i fasta radarrapporter.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Valfri lista över tillåtna yrken/betyg. Lämna tom så att alla kategorier av tillåtna yrken tillåts.",
                    label = "VIN lönegrader",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN yrken",
                    description = "yrkeskategorier som får använda VIN verifiering.",
                },
                fakePlateVinAudit = {
                    label = "Revision VIN kontroller",
                    description = "Sparar VIN kontroller till revisionsloggen.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN kontroll aktiverad",
                    description = "Aktiverar verifieringskommandot för fordon VIN.",
                },
                fakePlateVinCommand = {
                    label = "Kommando för VIN",
                    description = "Kommandot används för att verifiera ett fordon VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN nedkylning",
                    description = "Försening mellan två VIN kontroller.",
                },
                fakePlateVinDistance = {
                    label = "Högst VIN avstånd",
                    description = "Maximalt avstånd mellan officeren och fordonet för att kontrollera dess VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Visa falsk indikator",
                    description = "Visar en indikator när en kontroll upptäcker en falsk platta.",
                },
                fakePlateVinRequireDuty = {
                    label = "Krav på plikt",
                    description = "Kräver att officeren är i tjänst för att verifiera en VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Kräv scanner objekt",
                    description = "Kräver att det inställda skannerobjektet verifierar en VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Skannerobjekt",
                    description = "Inventariepost som krävs för att verifiera en VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Sätta fången till arbetslös när de sitter i fängelse.",
                    label = "Ta bort yrket i fängelse",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Återupprätta fångens ursprungliga yrke efter frigivningen.",
                    label = "Återställa ursprungligt yrke",
                },
                primaryColor = {
                    description = "Standardfärg för polisens jobbgrupp.",
                    label = "Grundfärg",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Låt granskare fakturera den registrerade ägaren även när den fångade plattan flaggas som falska eller klonade.",
                    label = "Tillåt misstänkta falska plåtar",
                },
                speedCamAdvancedPageSize = {
                    description = "Maximala fångster returneras per tablettsida.",
                    label = "Översikt sida storlek",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Fordonssidor vars foton kan användas för skyltigenkänning. Använd fram och/eller bak.",
                    itemLabel = "Sido",
                    label = "Erkända sidor",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Tillåt endast godkännande efter det att uppladdningen av fotot till fartkameran har slutförts.",
                    label = "Kräva fotobevis",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmeny behörighet som krävs för att godkänna eller kassera fångst. 18 är Hantera Fakturering.",
                    label = "Granskningstillstånd ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Behåll fångster vars skylt inte finns i den registrerade fordonsdatabasen.",
                    label = "Lagra oregistrerade fordon",
                },
                tabletConfiscations = {
                    description = "Visa logg över föremål som konfiskerats under spelarsökningar.",
                    label = "Beslag",
                },
                tabletSpeedcamReviews = {
                    description = "Visa appen för översyn av avancerad hastighetskamera när avancerat läge är aktiverat.",
                    label = "Hastighetskamerans översikter",
                },
                tackleCommand = {
                    description = "Kommandot registrerat för att ta itu med närmaste person. Skriv in kommandonamnet utan ett snedstreck.",
                    label = "Kommando för taggle",
                },
                tackleCuffCommand = {
                    description = "Kommandot registrerat för att manschettera personen som för närvarande hålls kvar efter en tackling. Skriv in kommandonamnet utan ett snedstreck.",
                    label = "Kommando för taggle- manschett",
                },
                tackleCuffDescription = {
                    description = "Beskrivning som visas för manschettbindningen i femm-nyckelbindningsmenyn.",
                    label = "Beskrivning av manschettknappar",
                },
                tackleDescription = {
                    description = "Beskrivning visas för att ta itu med bindningen i femM-tangentbindningsmenyn.",
                    label = "Beskrivning av tangentbindan",
                },
                tackleEnabled = {
                    description = "Aktivera att tackla den närmaste personen och hålla dem på marken.",
                    label = "Tackla",
                },
                tackleMaxDistance = {
                    description = "Maximalt avstånd till målet vid start av en tackling.",
                    label = "Spännavstånd",
                },
                tackleNeedsSprint = {
                    description = "Kräv att officeren ska sprinta innan han tar itu med en person.",
                    label = "Tackle kräver sprintning",
                },
                tackleReleaseCommand = {
                    description = "Kommandot registrerat för att släppa personen som för närvarande hålls kvar efter en tackling. Skriv in kommandonamnet utan ett snedstreck.",
                    label = "Kommando för att frigöra taggle",
                },
                tackleReleaseDescription = {
                    description = "Beskrivning visas för att ta itu med release bindning i femM-tangentbindningsmenyn.",
                    label = "Beskrivning av taggle release- tangentbinda",
                },
                tackleRequireOnDuty = {
                    description = "Kräver tjänstgöring innan en officer kan ta itu med en person.",
                    label = "Tackle kräver tjänst",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Kommandot som används för att öppna eller stänga radarlayouteditorn. Skriv in kommandonamnet utan ett snedstreck.",
                    label = "Radarlayoutkommando",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Kommandot används för att återställa den förvalda radarlayouten. Skriv in kommandonamnet utan ett snedstreck.",
                    label = "Återställ radarlayoutkommando",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Tillåter anställda att anmäla sig till tillgängliga träningspass.",
                approvalRequired = "Håller självregistreringar i väntan tills en auktoriserad instruktör godkänner dem.",
                defaultCapacity = "Standard antal platser som används när en ny träningspass skapas.",
                enabled = "Gör träningsappen tillgänglig för detta jobb.",
                requireOnDuty = "Kräver att anställda är i tjänst innan de öppnar eller använder Training App.",
                upcomingDays = "Antal framtida dagar som visas i utbildningsprogrammets schema.",
            },
            trainingFields = {
                allowSelfEnrollment = "Tillåt självregistrering",
                approvalRequired = "Kräver inskrivningsgodkännande",
                defaultCapacity = "Standardkapacitet",
                enabled = "Möjlig utbildning",
                requireOnDuty = "Krav på plikt",
                upcomingDays = "Kommande period (dagar)",
            },
            locationDescriptions = {
                jail_public_blip = "Positionen hämtas automatiskt från fängelsets spawnpunkt, eller från den första fängelseterminalen om ingen spawnpunkt har angetts.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Konsumera manschetter har ingen effekt medan manschettartikelkravet är inaktiverat.",
                wheelClampUseItemRequiresItem = "Klämanvändningsläge Inventory eller båda kräver Clamp kräver objekt för att förbli aktiverat.",
                ziptiesConsumeRequiresItem = "Konsumera zuties har ingen effekt medan zutie artikelkrav är inaktiverad.",
            },
        },
    },
    JobConfiguratorImportFailed = "Misslyckades importera config.lua-värden för '%s': %s.",
    JobConfiguratorImportHistoryFailed = "Importen lyckades, men dess historikpost kunde inte sparas.",
    JobConfiguratorImportNoData = "'%s' innehåller inga importdata för config.lua.",
    JobConfiguratorImportSuccess = "Importerade config.lua-värden för '%s': %d yrken, %d inställning, %d funktion, och %d interaktion avvikelser tillämpas.",
    JobConfiguratorTitle = "Yrkesförmedlare",
    JobConfiguratorUnknown = "Okänd yrkeskonfigurator.",
}
