JobConfigLocales["sky_mechanicjob:se"] = {
    Nui = {
        workshopConfig = {
            settingFields = {
                radialEnabled = "Faktura i radialmenyn",
                allowTuningInvoices = "Fakturera tuningkunder",
                customerRange = "Kundavstånd",
                allowAnalytics = "Redovisningsanalys",
                allowCancellation = "Återkallelse",
                allowCustomPrices = "Tillåt anpassade priser",
                allowEstimates = "Tillåt uppskattningar",
                allowImmediatePayment = "Tillåt omedelbar betalning",
                allowManualItems = "Tillåt egna positioner",
                allowPartialPayments = "Tillåt delbetalningar",
                allowReminders = "Påminnelser",
                amount = "Belopp",
                analyticsPeriodDays = "Analysperiod",
                bone = "Ben",
                category = "Kategori",
                classId = "Klass ID",
                defaultDueDays = "Betalningstid (dagar)",
                depositPercent = "Inlåning i procent",
                difficulty = "Svårighet",
                enabled = "Aktiverad",
                estimateLifetimeHours = "Uppskattningslivslängd (timmar)",
                flow = "Installera flöde",
                grade = "Grad",
                gradeRules = "Gradregler",
                item = "Föremål",
                key = "Nyckel",
                kilometersToZero = "Kilometer till noll",
                label = "Märka",
                laborFee = "Arbetskostnad",
                laborMultiplier = "Arbetsmultiplikator",
                marginAdjustmentPercent = "Marginaljustering",
                marginPercent = "Marginal för",
                maxDiscountPercent = "Maximal rabatt",
                maximumInvoiceAmount = "Högsta faktura",
                maximumManualItems = "Maximala egna positioner",
                maximumPrice = "Högst",
                maximumReminders = "Maximala påminnelser",
                minimumInvoiceAmount = "Minsta faktura",
                minimumPartialPayment = "Minsta delbetalning",
                minimumPrice = "Lägsta",
                multiplier = "Multiplikator",
                name = "Föremålsnamn",
                partKey = "Delnyckel",
                price = "Pris",
                priceType = "Pristyp",
                prop = "Rekvisita",
                reason = "Orsak",
                reminderFee = "Påminnelseavgift",
                reminderGraceDays = "Tidsfrist för påminnelser",
                removeAfterUse = "Förbruka föremål",
                repair = "Reparation med satsen",
                repairItem = "Reparationsföremål",
                rx = "Rotera X",
                ry = "Rott Y",
                rz = "Rotera Z",
                supplierSharePercent = "Leverantör %",
                taxPercent = "Faktureringsskatt",
                transport = "Transporter",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Uppgradering",
                maximumDiscountPercent = "Maximal rabatt",
            },
            settingFieldDescriptions = {
                radialEnabled = "Öppna verkstadens fakturering från radialmenyn.",
                allowTuningInvoices = "Fakturera tuningkorgen till närmaste kund. Monteringen blir tillgänglig efter full betalning.",
                customerRange = "Maximalt avstånd i meter för att fakturera kunder i närheten.",
                allowAnalytics = "Tillåt faktureringsanalys om inte en gradregel överskrider den.",
                allowCustomPrices = "Tillåt mekaniker att redigera faktura position priser innan utfärdande.",
                allowEstimates = "Tillåt uppskattningar som kunderna måste acceptera före betalning.",
                allowImmediatePayment = "Tillåt att fakturor från detta yrke betalas direkt.",
                allowManualItems = "Tillåt mekaniker att skapa godtyckliga fakturapositioner.",
                allowPartialPayments = "Tillåt insättningar och flera betalningar mot en faktura.",
                analyticsPeriodDays = "Dagar som ingår i faktureringsanalys.",
                defaultDueDays = "Dagar tills en faktura blir försenad.",
                depositPercent = "Depositionsprocent efter det att en faktura har utfärdats eller en uppskattning godtas.",
                enabled = "Låt detta yrke att använda mekaniker fakturering.",
                estimateLifetimeHours = "Timmar innan en obesvarad uppskattning går ut.",
                gradeRules = "Faktureringsbegränsningar och åtgärder tillgängliga för varje mekaniker.",
                maxDiscountPercent = "Största rabatt en faktura kan få.",
                maximumInvoiceAmount = "Total totalsumma före betygsgränserna.",
                maximumManualItems = "Maximala godtyckliga positioner per dokument.",
                maximumReminders = "Maximala påminnelser tillåts per faktura.",
                minimumInvoiceAmount = "Minimibelopp för uppskattningar och fakturor.",
                minimumPartialPayment = "Minsta delbetalning, exklusive ett mindre återstående saldo eller en mindre deposition.",
                reminderFee = "Avgift som läggs till av varje giltig påminnelse.",
                reminderGraceDays = "Dagar för sent innan den första påminnelsen är tillåten.",
                taxPercent = "Skatt tillagd efter rabatter.",
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Mobil dyno-installation",
                    entryPluralLabel = "Mobila dyno-installationer",
                    label = "Mobila dyno-installationer",
                },
                workshops = {
                    entryLabel = "Verkstad",
                    entryPluralLabel = "Verkstäder",
                    label = "Verkstäder",
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
                crewCapacity = "Högsta antalet personer som får bemanna enheten. Använd 0 för obegränsad besättning.",
                joinLocked = "Hindrar fler personer från att ansluta när enheten redan är bemannad.",
                minimumCrew = "Minsta antal personer i enheterna som väljs för denna insatsplan.",
                poiId = "Beständig teknisk identifierare som centralprofiler kan använda även efter att platsen bytt namn.",
                readyStatusCode = "FMS-status som används när resursen blir tillgänglig för utlarmning.",
                resourceType = "Klassificerar den operativa resursen för ledningscentralens filter och samordning.",
                respondingStatusCode = "FMS-status som används när resursen svarar på en händelse.",
                shortLabel = "Valfri kort etikett på radions sex minnesknappar för kanaler.",
                stationId = "Kopplar enheten till en station i ledningscentralens profil.",
                unitId = "Beständig teknisk identifierare som bevarar enheten även om anropssignalen ändras.",
                autoAlarm = "Omedelbart tilldelas matchande tillgängliga enheter när en incident skapas.",
                available = "Enheter i denna status kan föreslås och tilldelas en ny incident.",
                averageResponseSpeedKmh = "Beräknar den visade ankomstuppskattningen från rakt avstånd.",
                callsign = "Unikt radiosamtal visas när spelare bemannar denna virtuella enhet.",
                centerEnabled = "Tillåter auktoriserade tjänstemän att bemanna ett avsändningscenter.",
                channelId = "Radiokanal ID för PMA Voice, SaltyChat och YACA. Numeriska ID som 2500 förblir oförändrade; PMA Voice kartlägger text-ID till ett stabilt nummer.",
                channelLabel = "Läsbart kanalnamn som visas för avsändare och enheter.",
                defaultChannel = "Dispatchers går med i den här kanalen när de startar sitt skift. Enheter går manuellt från Radio-fliken. Välj Ingen att använda arbetsgruppsstandarden.",
                emergencyAppEnabled = "Gör det här jobbet valbart som en offentlig tjänst i nödtelefonappen.",
                enabled = "Gör detta jobb tillgängligt för Dispatch App och cross-job incidenter.",
                icon = "Välj ikonen som visas för denna enhetskategori i Dispatch App.",
                incidentAssessmentEnabled = "Visar frågor om medicinsk och farlig bedömning i hela incidentintaget.",
                jobs = "Ytterligare jobbnamn som får incidenter med hjälp av detta sökord.",
                noUnitFallback = "Utan en central eller bemannad enhet skickar en Sky-meddelande till alla medlemmar på avdelningen.",
                radius = "Maximalt avstånd i meter där stationsmeddelandet kan höras.",
                requirements = "Svarskrav som TYPE:COUNT-par, till exempel PATROL:2,CRIME:1.",
                statusCode = "Numerisk FMS-status visas på den handhållna radion.",
                statusLabel = "Betydelse av denna FMS-status för avsändare och enheter.",
                vehicleType = "Måste matcha en fordonstyp kod konfigurerad i föregående underavsnitt.",
                vehicleTypeCode = "Kort enhetskod som används i svarskrav, till exempel PATROL, CRIME, EMS eller RESCUE.",
                vehicleTypeLabel = "Läsbart namn på denna enhetskategori.",
            },
            dispatchFields = {
                crewCapacity = "Besättningskapacitet",
                joinLocked = "Lås anslutning till besättningen",
                minimumCrew = "Minsta besättning",
                poiId = "Beständigt POI-ID",
                readyStatusCode = "Kod för beredskapsstatus",
                resourceType = "Resurstyp",
                respondingStatusCode = "Kod för utryckningsstatus",
                shortLabel = "Etikett för radiominne",
                stationId = "Stations-ID",
                unitId = "Beständigt enhets-ID",
                address = "Adress",
                autoAlarm = "Automatiskt larm",
                available = "Tillgänglig för Dispatch",
                averageResponseSpeedKmh = "Uppskattad responshastighet (km/h)",
                callsign = "Anropssignal",
                category = "Kategori",
                centerEnabled = "Aktivera Dispatch Center",
                channelId = "Kanal ID",
                code = "Kodkod",
                defaultChannel = "Standard radiokanal",
                emergencyAppEnabled = "Visa i nödapp",
                enabled = "Enable Dispatch",
                icon = "Ikon",
                incidentAssessmentEnabled = "Aktivera nödbedömning",
                jobs = "Måljobb (komma separerade)",
                keywordCode = "Keyword-kod",
                label = "Etikett",
                name = "Namnnamn",
                noUnitFallback = "Meddela personal utan enheter",
                noneChannel = "Ingen / grupp standard",
                note = "Notera",
                phone = "Telefon",
                radius = "Tillkännagivande radie",
                requirements = "Krävda enheter (till exempel PATROL:2,CRIME:1)",
                type = "Typ",
                vehicleType = "Svar enhet typ",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Kända anmälare",
                    channels = "Radiokanaler",
                    plans = "Insatsplaner",
                    statuses = "Tillgängliga FMS-statusar",
                    units = "Virtuella enheter",
                },
                active = "Larmcentral aktiv",
                description = "Konfigurera mottagning av nödsamtal, radio, enheter, insatsplaner, platser och anmälaruppgifter för det här jobbet.",
                inactive = "Larmcentral inaktiverad",
                steps = {
                    accessText = "Aktivera larmcentralen och ange om personal från det här jobbet får bemanna den.",
                    accessTitle = "Åtkomst och larmmottagning",
                    fleetText = "Konfigurera kanaler, FMS-statuskoder, fordonstyper och anropssignaler.",
                    fleetTitle = "Radio och fordonspark",
                    responseText = "Slutför med nyckelord, insatskrav och intressepunkter.",
                    responseTitle = "Insatsplaner",
                },
                title = "Larmcentral",
                warnings = {
                    channels = "Inga egna radiokanaler finns; jobbgruppens reservkanal kommer att användas.",
                    defaultChannel = "Den valda standardkanalen finns inte längre.",
                    disabled = "Larmcentralen är inaktiverad för det här jobbet.",
                    statuses = "Minst en FMS-status måste vara tillgänglig för att enheter ska kunna larmas.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Hanterar anmälares namn, återuppringningsnummer och ledningsanteckningar för jobbet.",
                dispatchChannels = "Definierar de radiokanaler som enheter och bemannade sändningscentra kan ansluta sig.",
                dispatchKeywords = "Definierar incident sökord, obligatoriska fordonsräkningar, deltagande jobb och valfri automatisk alarmering.",
                dispatchPois = "Butiksstationer och gemensamma platser för incidentformulär och positionsbaserade stationsmeddelanden.",
                dispatchStatusCodes = "Konfigurerar FMS-statusetiketter och vilka statuser som gäller för nya incidenter.",
                dispatchVehicleTypes = "Definierar enhetskategorier som används av svarsplaner, t.ex. Patrol, Crime Unit, EMS eller Rescue.",
                dispatchVehicles = "Definierar virtuella sändningsfordon som kan bemannas från var som helst utan att kräva ett gyllene fordon.",
            },
            diagnosticsSettings = {
                enabledLabel = "Aktivera fordonsdiagnostik",
                enabledDescription = "Tillåt det här jobbet att öppna fordonsdiagnostik och reparera delar där.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Fordonsdiagnostik",
                    description = "Konfigurera det här jobbets åtkomst till fordonsdiagnostik.",
                },
                dispatchReporters = "Kända anmälare",
                invalidSelection = "Ogiltigt val: {value}",
                billingPrices = {
                    description = "Konfigurera fakturapriser för poster i underhålls- och reparationshistorik. Åtgärdsnyckeln matchas mot action_key, action_type, eller arbetsetiketten.",
                    label = "Faktureringsorsaker",
                },
                billingSettings = {
                    description = "Anpassa mekaniker fakturering beteende för detta yrke.",
                    label = "Fakturering",
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
                partsDeliveryShop = "Del-leveransbutik",
                trainingSettings = {
                    description = "Konfigurera utbildningsåtkomst, inskrivning, godkännanden och kursplanering för detta jobb.",
                    label = "Träningsinställningar",
                },
                tuningCostProfile = {
                    description = "Konfigurera kostnader for prestanda, utseende, hjul och specialalternativ for detta jobb.",
                    label = "Tuningpriser",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Fri kamera i tuningmenyn",
                    description = "Tillåt att mellanslag döljer markören för fri kamerarörelse. Escape stänger fortfarande menyn.",
                },
                tuningCamera = {
                    description = "Riktar automatiskt kameran mot den valda delen. När funktionen är avstängd används den vanliga spelkameran.",
                    label = "Automatisk tuningkamera",
                },
                jgMileage = {
                    description = "Använd JG Vehicle Mileage när resursen körs. Använd annars Skys körsträcka. JG HUD konfigureras separat.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Visa den valda körsträckan i JG HUD. Fungerar utan JG Vehicle Mileage; installera HUD-adaptern enligt README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Aktivera administratörsredigeraren och automatiska regler för registreringsskyltar och fordonsmodeller. Hämta berörda fordon ur garaget igen efter avstängning för att återställa redan tillämpade värden.",
                    label = "Köregenskapsredigerare",
                },
                kuv = {
                    description = "Starta teknisk kontroll",
                    label = "Teknisk fordonskontroll",
                },
                mobileDyno = {
                    description = "Aktiverar den mobila dynamometern, kontroll- och resultatskärmar, fläktreglage och surfplatta.",
                    label = "Mobil dynamometer",
                },
                vehicleRegistration = {
                    description = "Registrera / överför fordon",
                    label = "Fordonsregistrering",
                },
                antiLag = {
                    description = "Aktivera anti-lagning och avgaseffekter.",
                    label = "Anti-lag",
                },
                brakeOverheating = {
                    description = "Aktivera iscensatt bromsvärme, glödande skivor, kritiska gnistor och kort broms bleknar.",
                    label = "Bromsöverhettning",
                },
                carryItems = {
                    description = "Krav att levererade delar transporteras genom verkstaden.",
                    label = "Fysisk delhantering",
                },
                customHandling = {
                    description = "Aktivera anpassad drivlina och hantering tuning.",
                    label = "Egen hantering",
                },
                electronicTuning = {
                    description = "Aktivera ihållande ECU, belysning och förarassistans inställningsalternativ.",
                    label = "Elektronisk avstämning",
                },
                instantTuning = {
                    description = "Tillåt direkt inställning på inställda offentliga inställningsplatser.",
                    label = "Snabb avstämning",
                },
                mileageHud = {
                    description = "Visa fordonsmiltal under korning.",
                    label = "Mil-HUD",
                },
                nitro = {
                    description = "Aktivera nitro installation och fordon öka användningen.",
                    label = "Nitro Ordförande",
                },
                partsDelivery = {
                    description = "Aktivera verkstadens delbestallningar och leveransplatser.",
                    label = "Del-leverans",
                },
                selfServiceOrderNotifications = {
                    description = "Meddela anställda som är i tjänst när en självbetjäningsorder skapas.",
                    label = "Självbetjäning ordermeddelanden",
                },
                stance = {
                    description = "Visa Stance-justeringar i alla inställningsmenyer och aktivera alternativet Stance Kit.",
                    label = "Stance Ordförande",
                },
                stanceWheelSize = {
                    description = "Visa, spara och tillämpa hjulstorleksjusteringar i Stance.",
                    label = "Stance Wheel storlek",
                },
                stanceWheelWidth = {
                    description = "Visa, spara och tillämpa hjulbreddsjusteringar i Stance.",
                    label = "Sträckhjulets bredd",
                },
                subscriptions = {
                    description = "Aktivera verkstadsprenumeration terminaler, ledning och kundrabatter.",
                    label = "Workshop-prenumerationer",
                },
                twoStep = {
                    description = "Aktivera tvåstegs startkontroll och avgaseffekter.",
                    label = "Tvåsteg",
                },
                vehicleMaintenanceNotifications = {
                    description = "Meddela ägarna när deras fordon når den inställda underhållströskeln.",
                    label = "Meddelanden om fordonsunderhåll",
                },
                wheelDamage = {
                    description = "Aktivera realistiska hjulskador och reparationer.",
                    label = "Hjulskador",
                },
                workshopLift = {
                    description = "Aktivera anvandbara lyftpunkter i verkstader.",
                    label = "Verkstadslyft",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Placera punkten på verkstadens besiktningsplats. Fordonet måste vara inom det inställda besiktningsavståndet för teknisk besiktning och registrering.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Placering av dyno-resultatskärmen.",
                    label = "Dyno-resultatskärm",
                },
                mobile_dyno_station = {
                    description = "Placering av den mobila dyno-stationen.",
                    label = "Mobil dyno-station",
                },
                vehicle_registry = "Besiktnings- och registreringsplats",
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
            settingGroups = {
                diagnostics = {
                    label = "Diagnostik",
                },
                keybinds = {
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                    label = "Kortkommandon",
                },
                safety = {
                    label = "Validering och säkerhet",
                },
                antiExploit = {
                    label = "Antiutnyttjande",
                },
                coach = {
                    label = "Telemetritränare",
                },
                cooldownMultipliers = {
                    label = "Kylningsfaktorer",
                },
                crashFalloff = {
                    label = "Kraschfall",
                },
                criticalEngine = {
                    label = "Bruten motor",
                },
                deformation = {
                    label = "Deformation",
                },
                fade = {
                    label = "Försämrad bromsverkan vid överhettning",
                },
                features = {
                    label = "Funktioner",
                },
                format = {
                    label = "Format",
                },
                frontalImpact = {
                    label = "Svår frontkollision",
                },
                general = {
                    label = "Allmänt",
                },
                heatMultipliers = {
                    label = "Uppvärmningsfaktorer",
                },
                illegalMarket = {
                    label = "Olaglig marknad",
                },
                integration = {
                    label = "Integrering",
                },
                items = {
                    label = "Föremål",
                },
                lifetime = {
                    label = "Livstid",
                },
                limits = {
                    label = "Lagringsgränser",
                },
                repairRestore = {
                    label = "Reparation Återställ",
                },
                risk = {
                    label = "Risker",
                },
                rules = {
                    label = "Regler",
                },
                stages = {
                    label = "Överhettningsnivåer",
                },
                tyreRepair = {
                    label = "Reparation av däck",
                },
                visuals = {
                    label = "Visuella effekter",
                },
            },
            settingSections = {
                electronicTuning = "ECU-motorprogramvara",
                handlingEditor = "Väghållningsredigerare",
                mobileDyno = "Mobil dynamometer",
                vehicleRegistry = "Fordonsintyg",
                advancedPricing = "Avancerad prissättning",
                brakeOverheating = "Bromsöverhettning",
                carryItems = "Bär objekt",
                fakePlates = "Falska plattor",
                firejobVehicleFires = "Fordonsbrand",
                general = "Allmän",
                instantTuning = "Snabb avstämning",
                maintenanceNotifications = "Underhållsanmälan",
                mileageHud = "Mil-HUD",
                oilLeaks = "Fordonets vätskeläckage",
                partsTheft = "Delar till stöld",
                subscriptions = "Abonnemang",
                tuning = "Trimning",
                vehicleCare = "Fordonsvård",
                wear = "Slitage",
                wheelDamage = "Hjulskador",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Övrigt",
                handlingAir = "Luft",
                handlingGeneral = "Allmänt",
                handlingRoad = "Väg",
                handlingWater = "Vatten",
            },
            settingSubsections = {
                mechanicHotkeys = "Kortkommandon",
                database = "Databas",
                handlingEditorGeneral = "Redigerarinställningar",
                handlingMaximumCBikeHandlingData = "Motorcykel",
                handlingMaximumCBoatHandlingData = "Båt",
                handlingMaximumCCarHandlingData = "Bil",
                handlingMaximumCFlyingHandlingData = "Flygplan",
                handlingMaximumCHandlingData = "Fordonsbas",
                handlingMaximumCSeaPlaneHandlingData = "Sjöflygplan",
                handlingMaximumCSpecialFlightHandlingData = "Specialflyg",
                handlingMaximumCSubmarineHandlingData = "Ubåt",
                handlingMaximumCTrailerHandlingData = "Släpvagn",
                handlingMaximumCVehicleWeaponHandlingData = "Fordonsvapen",
                keybinds = "Kortkommandon",
                operation = "Drift",
                placementRules = "Placeringsregler",
                testFlow = "Testflöde",
                tuning = "Alternativ för direkt trimning",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Fordonsreparation",
                    description = "Erbjud reparation vid platser för direkt trimning.",
                },
                instantTuningRepairPrice = {
                    label = "Reparationspris",
                    description = "Fast reparationspris utan trimningens prismultiplikator.",
                },
                instantTuningWashEnabled = {
                    label = "Fordonstvätt",
                    description = "Erbjud tvätt vid platser för direkt trimning.",
                },
                instantTuningWashPrice = {
                    label = "Tvättpris",
                    description = "Fast tvättpris utan trimningens prismultiplikator.",
                },
                vehiclePriceSource = {
                    label = "Källa för fordonspriser",
                    description = "Automatiskt: SQL för ESX; fordonskatalog för QBCore/Qbox. Databas: konfigurerad SQL-tabell för alla ramverk.",
                    options = {
                        auto = "Automatiskt (ramverk)",
                        database = "Databas",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabell för fordonspriser",
                    description = "Tabell med inköpspriser, t.ex. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Kolumn för spawnnamn",
                    description = "Kolumn med spawnnamn, t.ex. spawn_code (JG), inte visningsnamnet.",
                },
                vehiclePricePriceColumn = {
                    label = "Priskolumn",
                    description = "Kolumn med numeriska inköpspriser, t.ex. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Kolumn för modellhash (valfri)",
                    description = "Valfri numerisk hashkolumn, t.ex. hashkey (JG). Lämna tom för att beräkna hash från spawnnamn.",
                },
                handlingEditorFieldMaximum = {
                    description = "Hårt maxvärde som redigeraren accepterar för detta väghållningsfält.",
                },
                handlingEditorFocusKey = {
                    label = "Återgå till köregenskapsredigeraren",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Antal kodade byte innan en begäran, ett svar eller en ögonblicksbild rapporteras som stor.",
                    label = "Gräns för stor nyttolast",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mäter redigerarens åtgärder och varnar via Sky.Debug när konfigurerade gränser överskrids.",
                    label = "Prestandakontroller",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Antal millisekunder mellan samlade prestandasammanfattningar när detaljerad loggning är aktiv.",
                    label = "Sammanfattningsintervall",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Antal millisekunder innan en åtgärd i redigeraren rapporteras som långsam.",
                    label = "Gräns för långsam åtgärd",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Högsta procent som ett numeriskt reglage får flyttas över eller under den inlästa fordonsbasen. Direktinmatning och XML-import förblir förlustfria. Ett fältmaximum som avviker från standardvärdet ersätter reglagets övre gräns.",
                    label = "Maximal reglageavvikelse",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Katalysatorstöld · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Katalysatorstöld · Kontroll 73",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl172 = {
                    label = "Effektmätning · Kontroll 172",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl173 = {
                    label = "Effektmätning · Kontroll 173",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl174 = {
                    label = "Effektmätning · Kontroll 174",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl175 = {
                    label = "Effektmätning · Kontroll 175",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl177 = {
                    label = "Effektmätning · Kontroll 177",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl38 = {
                    label = "Effektmätning · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl45 = {
                    label = "Effektmätning · Kontroll 45",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicDynoControl47 = {
                    label = "Effektmätning · Kontroll 47",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Lackering · Kontroll 200",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Lackering · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Fordonsvård · Kontroll 200",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Fordonsvård · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Knuffa fordon · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Knuffa fordon · Kontroll 33",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Knuffa fordon · Kontroll 34",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Knuffa fordon · Kontroll 35",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Knuffa fordon · Kontroll 32",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Knuffa fordon · Kontroll 21",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Hjulbyte · Kontroll 200",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Hjulbyte · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Hjulbyte · Kontroll 22",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Hjulstöld · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Hjulstöld · Kontroll 73",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                mobileDynoConsumeItem = {
                    description = "Ta bort ett föremål efter lyckad placering.",
                    label = "Förbruka föremål",
                },
                mobileDynoCooldownMs = {
                    label = "Nedkylningstid",
                },
                mobileDynoCountdownMs = {
                    label = "Startnedräkning",
                },
                mobileDynoDuiDistance = {
                    label = "Panelens renderingsavstånd",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Fläktreglagets avstånd",
                    description = "Avstånd i meter för användning av den fysiska omkopplaren mellan kylfläktarna.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Fullasttid",
                    description = "Millisekunder som används för att hålla full last i profiler som inkluderar en full belastningssteg.",
                },
                mobileDynoHistoryLimit = {
                    label = "Historikgräns",
                },
                mobileDynoInteractionDistance = {
                    label = "Panelens interaktionsavstånd",
                },
                mobileDynoItemUseEnabled = {
                    description = "Tillåt placering av dyno och monitor genom att använda föremål.",
                    label = "Placering med föremål",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Gräns för aktiva sessioner",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Fordonsdetekteringsavstånd",
                },
                mobileDynoMonitorItem = {
                    description = "Inventarieföremål för att placera en resultatmonitor.",
                    label = "Monitorföremål",
                },
                mobileDynoPersistItems = {
                    description = "Behåll nya placeringar efter omstart av servern.",
                    label = "Spara placeringar",
                },
                mobileDynoPickupDistance = {
                    description = "Största avstånd i meter för att plocka upp utrustningen.",
                    label = "Avstånd för upphämtning",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Maximal höjdskillnad",
                    description = "Maximal markhöjdsvariation i meter accepteras för alla dynofotsonder.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Maximal placeringslutning",
                    description = "Maximal marklutning i grader accepteras över dynoavtrycket.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Mekaniker måste vara i tjänst för placering och användning.",
                    label = "Kräv tjänst",
                },
                mobileDynoResultDuiDistance = {
                    label = "Resultatskärmens renderingsavstånd",
                    description = "Maximalt avstånd i meter vid vilket den separata resultatmätaren återges.",
                },
                mobileDynoReturnItem = {
                    description = "Återlämna det förbrukade föremålet när utrustningen plockas upp.",
                    label = "Återlämna föremål",
                },
                mobileDynoStationItem = {
                    description = "Inventarieföremål för att placera en dyno.",
                    label = "Dynoföremål",
                },
                mobileDynoTabletDistance = {
                    description = "Största avstånd från dynon i meter för styrning med surfplatta och aktiva tester.",
                    label = "Räckvidd för surfplatta",
                },
                nitroActivationKey = {
                    label = "Håll nitro",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                registryBikeChecks = {
                    description = "Kontrollpunkter för motorcykel",
                    label = "Kontrollpunkter för motorcykel",
                },
                registryCarChecks = {
                    description = "Kontrollpunkter för bil",
                    label = "Kontrollpunkter för bil",
                },
                registryDistance = {
                    description = "Serviceavstånd (meter)",
                    label = "Serviceavstånd (meter)",
                },
                registryKuvFee = {
                    description = "Teknisk fordonskontroll-avgift",
                    label = "Teknisk fordonskontroll-avgift",
                },
                registryKuvValidityDays = {
                    description = "Giltighet för nya kontroller i verklig tid. Standard: 30 dagar. Befintliga slutdatum behålls.",
                    label = "Kontrollens giltighet (verkliga dagar)",
                },
                registryKuvWarningDays = {
                    description = "Förvarning (dagar)",
                    label = "Förvarning (dagar)",
                },
                registryRegistrationFee = {
                    description = "Registreringsavgift",
                    label = "Registreringsavgift",
                },
                registryReinspectionFee = {
                    description = "Avgift för efterkontroll",
                    label = "Avgift för efterkontroll",
                },
                registryRequireKuv = {
                    description = "Kräv giltig Teknisk fordonskontroll för registrering",
                    label = "Kräv giltig Teknisk fordonskontroll för registrering",
                },
                registrySessionSeconds = {
                    description = "Bekräftelsetid (sekunder)",
                    label = "Bekräftelsetid (sekunder)",
                },
                registryTransferFee = {
                    description = "Överföringsavgift",
                    label = "Överföringsavgift",
                },
                registryVehicleTypes = {
                    description = "Tillåtna fordonstyper",
                    label = "Tillåtna fordonstyper",
                },
                tuningFocusKey = {
                    label = "Musinteraktion för trimning",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                addRevenueToSociety = {
                    description = "Insättning betald stämorder pengar till tuning profession society konto.",
                    label = "Inlåning till samhället",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Delar leverans butikskategorier som förblir fritt purchasable medan avancerad prissättning är aktiverat. Matchning ignorerar hölje och blanktecken.",
                    itemLabel = "Kategori",
                    label = "Alltid tillgängliga kategorier",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Behåll konfigurerade butiksobjekt från de valda kategorierna tillgängliga utan en stämorder och prissätt dem genom det dynamiska leverantörssystemet.",
                    label = "Alltid tillgängliga butiksobjekt",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Antal dagar som visas i analysen av tablettens vinst.",
                    label = "Analysperiod",
                },
                advancedPricingCategoryRules = {
                    description = "Leverantörsandel, marginal, arbets- och prisgränser per inställningskategori.",
                    label = "Kategoriregler",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Förvald mekanikmarginal före klass- och betygsjusteringar.",
                    label = "Förvald marginal",
                },
                advancedPricingDifficultyRules = {
                    description = "Ytterligare arbetskostnad för varje tuning svårighet.",
                    label = "Svårighetsregler",
                },
                advancedPricingEnabled = {
                    description = "Räkna om stämpriserna på servern och, när Parts Delivery är aktiverat, kräva Dynasty delar för att köpas för deras specifika inställningsorder.",
                    label = "Aktivera avancerad prissättning",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normal virtuell lager för varje leverantör objekt.",
                    label = "Basbestånd",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Efterfrågan punkter avlägsnas per förfluten dag.",
                    label = "Daglig efterfrågans förfall",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Leverantörsmärkning läggs till för varje efterfrågepunkt.",
                    label = "Efterfrågan per enhet",
                },
                advancedPricingInventoryEnabled = {
                    description = "Höja leverantörspriserna när virtuella lager är låga eller efterfrågan är hög.",
                    label = "Dynamiskt leverantörslager",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maximal leverantörsmärkning orsakad av lågt lager.",
                    label = "Markering för låga lager",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Lagernivå under vilken bristen på prissättning börjar.",
                    label = "Tröskelvärde för låga lager",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Övre gräns för efterfrågemarkeringen.",
                    label = "Maximalt behovspåslag",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtuella enheter påfyllning per förfluten dag.",
                    label = "Daglig utsättning",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globalt rabatttak för mekanikfakturor.",
                    label = "Maximal rabatt",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Högsta tillåtna mekanikmarginal.",
                    label = "Högsta marginal",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Global övre prisgräns för en stämdel.",
                    label = "Högsta försäljningspris",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Markup, arbetskraft och rabatterade gränser per mekaniker.",
                    label = "Regler för mekanikklass",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Lägsta tillåtna mekanikmarginal.",
                    label = "Lägsta marginal",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Global lägre prisgräns för en stämdel.",
                    label = "Lägsta detaljhandelspris",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Fordonsvärde som används för det kompakta exemplet.",
                    label = "Kompakt förhandsgranskningsvärde",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Exempel på tuning kostnad procent som används av live förhandsvisning.",
                    label = "Förhandsgranskning av inställningsfrekvens",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Fordonsvärde som används för sportexempel.",
                    label = "Förhandsgranskningsvärde för sport",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Fordonsvärde som används för superbilexemplet.",
                    label = "Superförhandsgranskningsvärde",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Protokoll innan en obetald prisoffert omräknas.",
                    label = "Citatets livslängd",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Procentuell återbetalning för en upphandlad orderbunden del.",
                    label = "Återbetalning",
                },
                advancedPricingRoundingStep = {
                    description = "Runt varje Dynasty upphandling linje till detta pengasteg.",
                    label = "Avrundning av leverantörer",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Procentandel av kundens delpris debiteras av Dynasty Auto Supply.",
                    label = "Leverantörsandel",
                },
                advancedPricingTaxPercent = {
                    description = "Skatteprocent som lagras separat i prissättningsredovisningen.",
                    label = "Skatt",
                },
                advancedPricingVehicleClassRules = {
                    description = "Marginal- och arbetsjusteringar efter GTA fordonsklass.",
                    label = "Regler för fordonsklass",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Multiplikatorer för bromsuppgradering",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Multiplikatorer för nedkylning av fordonsklass",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Fördröjning i millisekunder efter bromsning innan aktiv kylning påbörjas.",
                    label = "Kylförsening",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Värme borttagen per sekund medan bromsen inte används.",
                    label = "Kylhastighet",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Värmenivå vid vilken gnistor och korta bromsar kan börja.",
                    label = "Kritisk tröskel",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Chans från 0 till 1 för kort bromsavstängning under bromsning vid kritisk värme.",
                    label = "Fade chans per sekund",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Avfasa nedkylning",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maximal blekningstid",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minsta blekningstid",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Värmemultiplikatorer för bromsuppgradering",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Värmemultiplikatorer för fordonsklass",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Basvärme som erhålls per sekund vid bromsning med referenshastighet.",
                    label = "Värmevinst",
                },
                brakeOverheatingHotThreshold = {
                    label = "Varm tröskel",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Fordonets lägsta hastighet i km/h före bromsning skapar värme.",
                    label = "Minsta bromshastighet",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Hastighet i km/tim vid vilken den inställda basvärmevinsten tillämpas.",
                    label = "Referensvarvtal",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maximalt tändintervall",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minsta tändintervall",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximalt avstånd i meter för glöd och gnistrening.",
                    label = "Synavstånd",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Varm tröskel",
                },
                carryItems = {
                    description = "Levererade delar som ska bli fysiskt bär rekvisita.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Motor Hoist",
                                forklift = "Gaffeltruck",
                                hand = "Hand",
                            },
                        },
                    },
                    itemLabel = "Bärbar post",
                    label = "Tillgångsposter",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 ger ingen extra effekt; 1,10 ökar vridmomentet med 10 %. Gäller fordon med detta ECU-steg.",
                    label = "Vridmomentsfaktor för steg 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 ger ingen extra effekt; 1,10 ökar vridmomentet med 10 %. Gäller fordon med detta ECU-steg.",
                    label = "Vridmomentsfaktor för steg 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 ger ingen extra effekt; 1,10 ökar vridmomentet med 10 %. Gäller fordon med detta ECU-steg.",
                    label = "Vridmomentsfaktor för steg 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 ger ingen extra effekt; 1,10 ökar vridmomentet med 10 %. Gäller fordon med detta ECU-steg.",
                    label = "Vridmomentsfaktor för steg 4",
                },
                fakePlatesAudit = {
                    label = "Revisionslogg",
                },
                fakePlatesBlacklist = {
                    description = "Blockerade ord eller fragment som inte kan visas i falska plattor.",
                    label = "Svart lista",
                },
                fakePlatesBlankPlateItem = {
                    description = "Craft/shop material som används för falska plattor ekonomi loopar.",
                    label = "Blank platta objekt",
                },
                fakePlatesCooldownMinutes = {
                    label = "Nedkylningsminuter",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Fallskärmshoppning",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Kraschfall aktiverad",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minsta kraschhastighet",
                },
                fakePlatesEnabled = {
                    description = "Tillåt spelare att använda falska tallrikskit på fordon.",
                    label = "Aktivera falska plåtar",
                },
                fakePlatesExpireMinutes = {
                    description = "0 håller falska plattor aktiva tills återställning eller omstart hantering tar bort dem.",
                    label = "Utrym minuter",
                },
                fakePlatesExpireOnRestart = {
                    label = "Utgå vid omstart",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Betalkonto",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Olaglig marknad möjlig",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Olagligt marknadspris",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Riskomultiplikator",
                },
                fakePlatesInstallDurationMs = {
                    label = "Installera varaktighet ms",
                },
                fakePlatesItem = {
                    description = "Engångsobjekt som startar den falska plattans installationsflöde.",
                    label = "Falska tallrikssats objekt",
                },
                fakePlatesMaxLength = {
                    label = "Maximal längd",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Fordonsavstånd",
                },
                fakePlatesMinLength = {
                    label = "Minsta längd",
                },
                fakePlatesPattern = {
                    description = "Lua mönster som används för att validera falska platta text, till exempel ^[A-Z0-9- Ja, det gör jag.",
                    label = "Lua- mönster",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Plåtens lägesavstånd",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Blockera dubblett aktiva falska plattor",
                },
                fakePlatesPrinterItem = {
                    description = "Hantverk/handel verktyg som används för falska plattor ekonomi loopar.",
                    label = "Skrivarobjekt för plattor",
                },
                fakePlatesRequireEngineOff = {
                    label = "Motorn måste vara avstängd",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Använd Config.Functions.CanApplyFakePlate innan montering tillåts.",
                    label = "Kräv ägare eller nycklar",
                },
                fakePlatesRequireStopped = {
                    label = "Fordonet måste stoppas",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Reserverad för garageintegrationer som kallar återställningshändelse/export.",
                    label = "Återställ i garagebutiken",
                },
                fakePlatesRiskCharacters = {
                    label = "Typ av tecken",
                },
                fakePlatesRiskEnabled = {
                    label = "Risktyp aktiverad",
                },
                fakePlatesRiskTypoChance = {
                    label = "Typo- chans",
                },
                fallbackVehicleValue = {
                    description = "Värde som används när inget fordonspris kan lösas.",
                    label = "Värde för reservfordon",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Chansen från 0 till 1 efter motorn är fortfarande kritisk.",
                    label = "Kritisk motor brand chans",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Sekunder innan ytterligare en trasig motor kan utlösas.",
                    label = "Kritisk nedkylning av motorn",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Fördröjning i millisekunder innan en trasig motor kan antändas.",
                    label = "Kritisk motorfördröjning ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Tillåt kritiskt skadade motorer att starta en brand på ett fordon efter en försening.",
                    label = "Ignit trasiga motorer",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Röktäthet som används för brandförfrågningar med trasig motor.",
                    label = "Kritisk motorröktäthet",
                },
                firejobVehicleFiresEnabled = {
                    description = "Låt Mechanicjob skador system för att begära fordon bränder från Firejob.",
                    label = "Aktivera eldsvåda fordon",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Krävs för framåtriktad rörelse från 0 till 1.",
                    label = "Främre rörelseförhållande",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Chansen från 0 till 1 att en kvalificerande kollision startar en brand.",
                    label = "Slag av eldsvåda",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Sekunder innan en annan träff avfyrar.",
                    label = "Nedkylning av kollisionsbrand",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Låt starka frontalolyckor begära en eldsvåda.",
                    label = "Ignite efter svåra krascher",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Röktäthet som används för olycksutlösta brandkrav.",
                    label = "Islagsröktäthet",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatiskt använder den inställda Firejob resursen; Inaktiverad förhindrar Mechanicjob från att skapa bränder.",
                    label = "Integrationsläge",
                    options = {
                        automatic = "Automatisk",
                        disabled = "Inaktiverad",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minsta kroppshälsa som gått förlorad under kollisionen.",
                    label = "Minsta kroppsskada",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minsta motorhälsa som gått förlorad under kollisionen.",
                    label = "Minsta motorskada",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Använd 0 för att inaktivera denna deformationskontroll.",
                    label = "Minsta främre deformation",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minsta hastighet före kollision i km/h.",
                    label = "Minsta islagshastighet",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Obligatorisk hastighetsförlust i km/tim under islaget.",
                    label = "Lägsta hastighetsförlust",
                },
                firejobVehicleFiresResource = {
                    description = "Resurs som tar emot förfrågningar om fordonsbrand.",
                    label = "Firejob- resurs",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Intern server händelse som används av mekanikern klienten för att begära en Firejob fordon brand.",
                    label = "Mekanisk serverhändelse",
                },
                freeVehicles = {
                    description = "Fordon leker modeller som tar emot gratis stämorder.",
                    itemLabel = "Fordonets modell",
                    label = "Fri inställning av fordon",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Förhindra Applicera medan en kritisk hantering konflikt existerar.",
                    label = "Blockera kritiska resultat",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Förväntad maximal retardation i m/s2 för en slutförd bromsprovning.",
                    label = "Minsta bromsretardation",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Mätta prover som krävs innan Telemetri Coach utvärderar en körning.",
                    label = "Minsta urval",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Mätt hjulförslitningshastighet i km/h vid vilken dragförlust rapporteras.",
                    label = "Varning för hjulsläp",
                },
                handlingEditorDefaultTab = {
                    description = "Sidan vald när den fristående hanteringseditorn öppnas.",
                    label = "Startsida",
                    options = {
                        advanced = "Avancerad",
                        export = "Exportera",
                        flags = "Flaggor",
                        fleet = "Flotta",
                        inspector = "Lager",
                        profiles = "Profiler",
                        simple = "Enkel",
                        telemetry = "Telemetri",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Ge effekt, referensintervall, symtom, relaterade fält och live-stöd för varje hanteringsvärde.",
                    label = "Fältdokumentation",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Sök och filtrera flagga namn, effekter, bit positioner och hexadecimal masker.",
                    label = "Flaggsökning",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Sök, inspektera, främja och återställa regler för modell- och plåthantering.",
                    label = "Ledare för flottan",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Visa fordonsbasen, installerad anpassad inställning, modellregel, skyltregel och aktuellt editor utkast för varje fält.",
                    label = "Lagerinspektör",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maximala modell- och skyltregler lastade till Fleet Manager.",
                    label = "Gräns för flottans resultat",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maximalt antal revideringar som behålls för varje profil.",
                    label = "Översyn av profilen",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maximala namngivna arbetsytor som behålls för varje administratör.",
                    label = "Personliga arbetsutrymmen",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Skapa en granskningsbar revidering när en delad profil uppdateras eller återställs.",
                    label = "Profilversioner",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Skapa transparenta regelbaserade rekommendationer från uppmätta vägtestdata.",
                    label = "Telemetritränare",
                },
                handlingEditorValidatorEnabled = {
                    description = "Upptäck osäkra eller motstridiga kombinationer innan hantering appliceras.",
                    label = "Validator för hantering",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Tillåt administratörer att behålla namngivna privata editor utkast.",
                    label = "Personliga arbetsutrymmen",
                },
                instantTuningAllowedJobs = {
                    description = "Valfri global tillståndslista. Lämna tom för att tillåta alla om inte enbart mekaniker är aktiverad.",
                    itemLabel = "Yrkesnamn",
                    label = "Tillåtna jobb",
                },
                instantTuningBlipColor = {
                    description = "GTA blip färg ID.",
                    label = "Blixtfärg",
                },
                instantTuningBlipEnabled = {
                    description = "Visa kartblixtar för omedelbar inställning av platser.",
                    label = "Blixten aktiverad",
                },
                instantTuningBlipName = {
                    description = "Kartans namn.",
                    label = "Blip-namn",
                },
                instantTuningBlipSprite = {
                    description = "ID för GTA-kartmarkeringens ikon.",
                    label = "Blip sprite Ordförande",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Använd markörstil E-interaktion även när målstödet är aktiverat.",
                    label = "Kraftmarkörinteraktion",
                },
                instantTuningInteractionDistance = {
                    description = "Förvalt avstånd för att använda omedelbar inställningspunkter.",
                    label = "Interaktionsavstånd",
                },
                instantTuningLabel = {
                    description = "Förvald text visas vid omedelbar inställning.",
                    label = "Förvald etikett",
                },
                instantTuningLocations = {
                    description = "Direkt inställningspunkter. Använd 0 avstånd för att ärva standard interaktionsavståndet.",
                    itemLabel = "Platser",
                    label = "Platser",
                },
                instantTuningMarkerEnabled = {
                    description = "Rita en världsmarkör på ögonblickliga stämplatser.",
                    label = "Markör aktiverad",
                },
                instantTuningMarkerType = {
                    description = "GTA markörtyp som används för omedelbar inställning.",
                    label = "Markörtyp",
                },
                instantTuningMechanicOnly = {
                    description = "Begränsa alla platser för omedelbar inställning till konfigurerade mekanikyrken.",
                    label = "Endast mekanisk",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplikator tillämpas på omedelbar inställning priser.",
                    label = "Prismultiplikator",
                },
                instantTuningProfile = {
                    description = "Konfigurera vilka inställningsalternativ som finns tillgängliga vid omedelbar inställning.",
                    label = "Alternativ för omedelbar avstämning",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minsta minuter innan samma fordon kan utlösa en annan påminnelse om underhåll.",
                    label = "Avkylning av anmälan",
                },
                maintenanceNotificationsEnabled = {
                    description = "Meddela fordonsägare när en slitdel når underhållströskeln.",
                    label = "Aktiverad",
                },
                maintenanceNotificationsThreshold = {
                    description = "Använd procentuell andel vid eller under vilken underhåll anses vara förfallet.",
                    label = "Tröskelvärde",
                },
                mileageHudDigits = {
                    description = "Antal siffror som visas i körsträckan HUD.",
                    label = "Styckningsdelar",
                },
                mileageHudPosition = {
                    description = "Dra körsträcka HUD förhandsvisning till önskad skärmposition.",
                    label = "Placera",
                },
                oilLeaksCooldownSeconds = {
                    description = "Sekunder innan ytterligare en läcka kan utlösas.",
                    label = "Nedkylning av påverkan",
                },
                oilLeaksEnabled = {
                    description = "Låt skadade förbränningsfordon lämna vätska under körning.",
                    label = "Aktivera vätskeläckage",
                },
                oilLeaksEngineOilChance = {
                    description = "Normal läcka chans från 0 till 1.",
                    label = "Risk för motorolja",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kritisk läcka chans från 0 till 1.",
                    label = "Kritisk motor olje chans",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Motoroljekondition vid eller under vilken den kritiska risken används.",
                    label = "Tröskelvärde för kritisk motorolja",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Motoroljekondition vid eller under vilken en läcka kan starta.",
                    label = "Tröskelvärde för motorolja",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Krävs för framåtriktad rörelse från 0 till 1.",
                    label = "Främre rörelseförhållande",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Låt svåra frontalkollisioner starta en tillfällig motor vätska läcka.",
                    label = "Islagsläckage framifrån",
                },
                oilLeaksImpactChance = {
                    description = "Chansen från 0 till 1 att en kvalificerande kollision startar en läcka.",
                    label = "Olycka med kollisionsläckage",
                },
                oilLeaksImpactRadius = {
                    description = "Radius från den första vätskepunkten skapad av ett slag.",
                    label = "Islagsutsläppsradie",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimum sekunder mellan ledpunkterna.",
                    label = "Spårintervall",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Sekunder en läcka fortsätter efter en kvalificerande träff.",
                    label = "Läckage varaktighet",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minsta kroppshälsa som gått förlorad under kollisionen.",
                    label = "Minsta kroppsskada",
                },
                oilLeaksMinDistance = {
                    description = "Minsta tillryggalagda avstånd mellan leden.",
                    label = "Spåravstånd",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minsta motorhälsa som gått förlorad under kollisionen.",
                    label = "Minsta motorskada",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Obligatorisk främre deformation. Använd 0 för att inaktivera denna kontroll.",
                    label = "Minsta främre deformation",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minsta hastighet före kollision i km/h.",
                    label = "Minsta islagshastighet",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Obligatorisk hastighetsförlust i km/tim under islaget.",
                    label = "Lägsta hastighetsförlust",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minsta fordonshastighet i km/h innan ett vätskeläckage kan skapa ett spår.",
                    label = "Lägsta hastighet",
                },
                oilLeaksRadius = {
                    description = "Radius av vanliga fordon fluid trail punkter.",
                    label = "Spårradie",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normal läcka chans från 0 till 1.",
                    label = "Överföringsvätska chans",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kritisk läcka chans från 0 till 1.",
                    label = "Kritisk överföringschans",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Överföringsvätskekondition vid eller under vilken den kritiska chansen används.",
                    label = "Tröskelvärde för kritisk överföring",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Transmissionsvätskans tillstånd vid eller under vilket en läcka kan starta.",
                    label = "Tröskelvärde för överföringsvätska",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Fordonsklasser som kan slutföra hissberoende orderarbete utan verkstadslift.",
                    itemLabel = "Lägg till fordonsklass",
                    label = "Klasser av lyftpassagefordon",
                    options = {
                        ["0"] = "Kompakter",
                        ["1"] = "Sedaner",
                        ["10"] = "Industriell",
                        ["11"] = "Nytta",
                        ["12"] = "Vantar",
                        ["13"] = "Cyklar",
                        ["14"] = "Båtar",
                        ["15"] = "Helikoptrar",
                        ["16"] = "Flygplan",
                        ["17"] = "Underhåll",
                        ["18"] = "Nödsituation",
                        ["19"] = "Militära",
                        ["2"] = "SUV:er",
                        ["20"] = "Kommersiella",
                        ["21"] = "Tåg",
                        ["22"] = "Öppna hjul",
                        ["3"] = "Kupéer och påsar",
                        ["4"] = "Njure",
                        ["5"] = "Sportklassiker",
                        ["6"] = "Idrott",
                        ["7"] = "Överlägset",
                        ["8"] = "Motorcyklar",
                        ["9"] = "Terräng",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Fordonslekverksmodeller som kan slutföra hissberoende orderarbete utan verkstadslyft.",
                    itemLabel = "Fordonets modell",
                    label = "Fordonsmodeller för lyftpassage",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millisekunder som används för beställning installera steg som inte kör ett minispel.",
                    label = "Enkel installationstid",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Fordon klass ID som alltid använder den normala mekaniker installera utan specialiserade lyft eller minigame flöden.",
                    label = "Fordonsklasser som inte är minispel",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Fordon lek modeller som alltid använder den normala mekaniker installera utan specialiserade lyft eller minigame flöden.",
                    label = "Fordonsmodeller som inte är minispel",
                },
                partsDeliveryCompanyCard = {
                    description = "Tillåt leveransorder för delar att använda företagsfonder.",
                    label = "Betalning av företagskort",
                },
                partsDeliveryMode = {
                    description = "Behåll det normala fysiska leveransflödet eller lägg till den fullständiga leveransen direkt till den samlande spelarens lager.",
                    label = "Leveranshantering",
                    options = {
                        player_inventory = "Spelarinventering",
                        standard = "Standardflöde för leverans",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millisekunder som krävs för att packa upp en färdig leverans.",
                    label = "Öppen varaktighet",
                },
                partsDeliveryOwnCard = {
                    description = "Låt spelare att betala delar leveransbeställningar med sina egna pengar.",
                    label = "Betalning med eget kort",
                },
                partsDeliveryTimeSeconds = {
                    description = "Sekunder mellan beställning av delar och leveransen blir redo.",
                    label = "Leveranstid",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventeringsobjekt som tilldelas när en katalysator stjäls.",
                    label = "Katalytisk omformare",
                },
                partsTheftDealerAccount = {
                    description = "Konto som används för stulna delar återförsäljare utbetalningar, såsom pengar eller bank.",
                    label = "Utbetalningskonto för återförsäljare",
                },
                partsTheftDealerItems = {
                    description = "Stulna objekt dealern kommer att köpa och deras utbetalningsvärden.",
                    itemLabel = "Handlarobjekt",
                    label = "Försäljningsobjekt",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventariepost som anges när dealern utbetalningstyp är objekt. Försäljningspriset används som objektet belopp.",
                    label = "Givarens utbetalningsobjekt",
                },
                partsTheftDealerPayoutType = {
                    description = "Välj om dealern betalar in i ett ramkonto eller ger en inventariepost.",
                    label = "Typ av utbetalning för återförsäljare",
                    options = {
                        account = "Konto",
                        item = "Föremål",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maximalt avstånd från återförsäljaren för att sälja stulna delar.",
                    label = "Dealer säljavstånd",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Sekunder före samma fordonsdel kan skapa en annan sändning.",
                    label = "Dispatchpaus",
                },
                partsTheftDispatchEnabled = {
                    description = "Skapa en polisstation när ett hjul eller katalysator stjäls.",
                    label = "Skicka polispost",
                },
                partsTheftDispatchJobs = {
                    description = "Yrkesnamn som tar emot delar från stölder.",
                    itemLabel = "Yrkesnamn",
                    label = "Utryckningsjobb",
                },
                partsTheftDispatchMessage = {
                    description = "Meddelande visas på larmet. Stöder {plate}, {part}, och {type}.",
                    label = "Sändningsmeddelande",
                },
                partsTheftDispatchTitle = {
                    description = "Titeln visas på larmet. Stöder {plate}, {part} och {type}.",
                    label = "Sändningsnamn",
                },
                partsTheftItem = {
                    description = "Inventeringsobjekt som används för att stjäla hjul och katalysatorer.",
                    label = "Stöldverktygsobjekt",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Ta bort stöldverktyget objekt efter en lyckad stöld åtgärd.",
                    label = "Konsumera stöldverktyg",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventeringsobjekt som delas ut när hjul stjäls.",
                    label = "Stulna hjul objekt",
                },
                priceType = {
                    description = "Procent beräknar kostnader från fordonspriset. Fasta använder pengar värden. Fordonsklass använder klass pristabell.",
                    label = "Pristyp",
                    options = {
                        class = "Fordonsklass",
                        fixed = "Fasta",
                        percentage = "Procent",
                    },
                },
                primaryColor = {
                    description = "Standardfärg för mekanikergruppen och nya yrken. Använd ett hexvärde som #EDC001.",
                    label = "Grundfärg",
                },
                publicUsersSeePrices = {
                    description = "När det är aktiverat betalar offentliga kunder vid beställning. Inaktivera detta för att skapa obetalda order för mekaniker fakturering.",
                    label = "Ta ut offentliga självbetjäningsorder",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Tillåt auktoriserade chefer att köpa ett abonnemang för hela sitt yrke med hjälp av företagsfonder.",
                    label = "Företagsprenumerationer",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Betalningsvaluta",
                },
                subscriptionsEnabled = {
                    description = "Aktivera verkstadsprenumerationer, kundterminaler och abonnemangsrabatter.",
                    label = "Aktiverad",
                },
                subscriptionsMaximumDurations = {
                    description = "Maximal varaktighet och prisalternativ per abonnemangsmodell.",
                    label = "Maximala varaktigheter",
                },
                subscriptionsMaximumModels = {
                    description = "Maximala prenumerationsmodeller en verkstad kan konfigurera i surfplattan.",
                    label = "Maximalt antal modeller",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Valfri loopning animation klipp som används när scenariot är tomt.",
                    label = "NPC emote klipp",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Valfri animeringsordbok som används när scenariot är tomt.",
                    label = "NPC emote ordbok",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped-modellen uppkom vid abonnemangsterminaler, till exempel s_m_m_autoshop_01.",
                    label = "Standardmodell för NPC",
                },
                subscriptionsNpcScenario = {
                    description = "Valfritt GTA scenario som WORLD_HUMAN_CLIPBOARD. Lämna tomt för att använda emote animation.",
                    label = "NPC-scenario",
                },
                tuningBlockedPlates = {
                    description = "Fordon med en av dessa plattor kan inte ställas in, installeras eller få stämning bort. Matchning ignorerar hölje och blanktecken.",
                    itemLabel = "Registreringsnummer",
                    label = "Blockerade stämplattor",
                },
                tuningWorkshopDistance = {
                    description = "Maximalt avstånd från en självbetjäningsinställning för nödvändiga installations- eller borttagningsåtgärder.",
                    label = "Kravavstånd till verkstaden",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Kräva stämordning installerar för att starta och slutföra nära en självbetjänings inställningspunkt.",
                    label = "Kräv verkstad för installationer",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Kräva stämning borttagningar för att starta och slutföra nära en självbetjäning inställningspunkt.",
                    label = "Kräv verkstad för borttagningar",
                },
                vehicleCareRepairDurationMs = {
                    description = "Reparera framsteg i millisekunder.",
                    label = "Reparationstid",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Återställ även realistiska hjulskador när du använder reparationen.",
                    label = "Fixa realistiska hjulskador",
                },
                vehicleCareRepairItem = {
                    description = "Inventeringsobjekt som används för reparation av fordon.",
                    label = "Reparationsföremål",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maximalt avstånd från fordonet under reparation.",
                    label = "Reparation max avstånd",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Ta bort reparationsartikeln efter användning.",
                    label = "Konsumera reparationsobjekt",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Reparation normal GTA fordonsskada vid användning av reparation åtgärd.",
                    label = "Rätta till skador på fordonet",
                },
                vehicleCareRepairWearParts = {
                    description = "Välj vilka slitage- och servicedelar reparationsobjektet återställer. Inaktivera vätskor här om olja, kylvätska, bromsvätska eller transmissionsvätska bör kräva diagnostik reparationsflöde.",
                    itemLabel = "Bära del",
                    label = "Reparationssats restaurerade delar",
                },
                vehicleCareWashItem = {
                    description = "Inventeringsobjekt som används för att tvätta ett fordon.",
                    label = "Tvättobjekt",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Ta av tvättmedlet efter användning.",
                    label = "Konsumera tvätt objekt",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Avstånd ett vaxat fordon håller sig rent.",
                    label = "Vax rena kilometer",
                },
                vehicleCareWaxItem = {
                    description = "Inventeringsobjekt som används för att vaxa ett fordon.",
                    label = "Vaxpost",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Ta bort vaxartikeln efter användning.",
                    label = "Konsumera vax objekt",
                },
                vehicleClassPricing = {
                    description = "Överskrid pristypen och kostnadsmultiplikatorn för varje GTA-fordonsklass.",
                    label = "Prissättning för fordonsklass",
                },
                wearParts = {
                    description = "Fordonsslitagedelar, deras livslängd avstånd, erforderliga reparationsobjekt, objektförbrukning, och installera flöde.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalytisk omformare",
                                fluid_refill = "Vätskepåfyllning",
                                hood_install = "Installering av huva",
                                oil_change = "Oljebyte",
                                performance = "Prestanda",
                                underbody_neon = "Underrede/lyft",
                                wheel = "Hjul",
                            },
                        },
                    },
                    itemLabel = "Bära del",
                    label = "Bärbara delar",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Multiplikator för skador på grundhjulet.",
                    label = "Förvald multiplikator",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtrerar deformationssondpunkter som inte pekar tillbaka till fordonets kaross.",
                    label = "Tröskelvärde för provvinkel",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Ytterligare kraft läggs till varje återställa iteration.",
                    label = "Ökning av deformationsskador",
                },
                wheelDamageDeformationEnabled = {
                    description = "Fånga och återställa karosser under reparation av däckgeometrin.",
                    label = "Återställ deformation",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Startkraft som används för att återställa bucklor.",
                    label = "Ursprunglig deformationsskada",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximala Set VehicleDamage passerar används för att återuppbygga bucklor.",
                    label = "Deformerande iterationer",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minsta upptäckta deformationsstorlek att lagra.",
                    label = "Deformationströskel",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplikator används när fordonet har off-road hjul.",
                    label = "Multiplikator för off-road-hjul",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra omedelbar icke-hjulskada återställa passerar efter hjul geometri byggs om.",
                    label = "Skadeersättningspassager",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Extra snabbpass för stillbilds- eller stillbildsdäck efter reparation av ett hjul.",
                    label = "Hjultillståndsåteranvändande passerkort",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Behåll kaross, motor, fönster, dörrar, smuts och visuell skada när däckreparationen bygger upp hjulets geometri.",
                    label = "Bevara fordonsskador",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Återställa trasiga fönster utan hög smäll effekt där det är möjligt.",
                    label = "Tysta trasiga fönster",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Återanvänd stillbildsdäck utan att utlösa ett nytt popljud eller en ny effekt.",
                    label = "Tyst, plant däck återanvänds",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maximalt avstånd från det skadade eller saknade däcket för monteringsåtgärden.",
                    label = "Däckets fästavstånd",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maximalt avstånd från det placerade biluttaget för borttagningen.",
                    label = "Biluttag tar bort avstånd",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Skademultiplikatorer per GTA fordonsklass.",
                    itemLabel = "Fordonsklass",
                    label = "Multiplikatorer för fordonsklass",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Blockera andra yrken när mekaniker är i tjänst",
                },
                allowsprint = {
                    label = "Tillåt sprint med leveranslådor",
                },
            },
            tuningCategories = {
                bodywork = "Kaross",
                electronics = "ECU och fordonselektronik",
                engineSounds = "Motorljud",
                handling = "Väghållning",
                lights = "Belysning",
                other = "Övrigt",
                paint = "Lackering",
                performance = "Prestanda",
                stance = "Stance Ordförande",
                wheels = "Hjul",
            },
            advancedPricingPreview = {
                compact = "Honda / Kompakt",
                customer = "Kundpris",
                description = "Exempel på kosmetisk beräkning med hjälp av gällande regler.",
                labor = "Arbete",
                live = "Live Preview",
                margin = "Marginal",
                sports = "Sportbil",
                super = "Supercar Ordförande",
                supplier = "Leverantör",
                title = "Pris förhandsgranskning",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Konfigurera mekanikjobb, butiker, fordon och verkstadsplatser.",
                    title = "Mekanikjobb",
                },
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
            fields = {
                quantity = "Antal",
            },
            settingValues = {
                air_filter = "Luftfilter",
                brake_fluid = "Bromsvätska",
                brake_pads = "Bromsbelägg",
                catalytic_converter = "Katalysator",
                clutch = "Koppling",
                coolant = "Kylvätska",
                engine_oil = "Motorolja",
                inverter = "Strömomvandlare",
                spark_plugs = "Tändstift",
                suspension = "Fjädring",
                traction_battery = "Traktionsbatteri",
                transmission_fluid = "Transmissionsolja",
                tyres = "Däck",
                vehicleClass_0 = "Kompakter",
                vehicleClass_1 = "Sedaner",
                vehicleClass_10 = "Industriell",
                vehicleClass_11 = "Nytta",
                vehicleClass_12 = "Vantar",
                vehicleClass_13 = "Cyklar",
                vehicleClass_14 = "Båtar",
                vehicleClass_15 = "Helikoptrar",
                vehicleClass_16 = "Flygplan",
                vehicleClass_17 = "Underhåll",
                vehicleClass_18 = "Nödsituation",
                vehicleClass_19 = "Militära",
                vehicleClass_2 = "SUV:er",
                vehicleClass_20 = "Kommersiella",
                vehicleClass_21 = "Tåg",
                vehicleClass_22 = "Öppna hjul",
                vehicleClass_3 = "Kupéer och påsar",
                vehicleClass_4 = "Njure",
                vehicleClass_5 = "Sportklassiker",
                vehicleClass_6 = "Idrott",
                vehicleClass_7 = "Överlägset",
                vehicleClass_8 = "Motorcyklar",
                vehicleClass_9 = "Terräng",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Inaktiverad",
                        [1] = "GTA-standard",
                        [2] = "Gatpuffar",
                        [3] = "Racing Anti-Lag",
                        [4] = "Rally Anti- Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatiska varningsblinkers",
                    values = {
                        [0] = "Av",
                        [1] = "På",
                    },
                },
                electronic_brake_lights = {
                    label = "Bromsljus",
                    values = {
                        [0] = "Normalt",
                        [1] = "Nödbromsblinkning",
                        [2] = "Av",
                    },
                },
                electronic_engine_tune = {
                    label = "Motorprogramvara",
                    values = {
                        [0] = "Original",
                        [1] = "Steg 1",
                        [2] = "Steg 2",
                        [3] = "Steg 3",
                        [4] = "Steg 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Strålkastarstyrka",
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
                    label = "Helljus vid signalhorn",
                    values = {
                        [0] = "Av",
                        [1] = "På",
                    },
                },
                electronic_idle_rpm = {
                    label = "Tomgångsvarv",
                    values = {
                        [0] = "Original",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Innerbelysning",
                    values = {
                        [0] = "Normalt",
                        [1] = "Röd",
                    },
                },
                electronic_mood_color = {
                    label = "Humörljusfärg",
                    values = {
                        [0] = "Av",
                        [1] = "Röd",
                        [10] = "Kalk",
                        [11] = "Turkos",
                        [12] = "Indigo Ordförande",
                        [13] = "Vit",
                        [14] = "Varmvit",
                        [15] = "Kallvit",
                        [16] = "Bärnsten",
                        [2] = "Blå",
                        [3] = "Grön",
                        [4] = "Kryddnejlikor",
                        [5] = "Magenta Ordförande",
                        [6] = "Gul",
                        [7] = "Rödbetor",
                        [8] = "Lila",
                        [9] = "Rosa",
                    },
                },
                electronic_mood_intensity = {
                    label = "Stämningsljusstyrka",
                    values = {
                        [0] = "Dämpad",
                        [1] = "Normalt",
                        [2] = "Stark",
                    },
                },
                electronic_radio_power = {
                    label = "Radioström",
                    values = {
                        [0] = "Av",
                        [1] = "På",
                    },
                },
                electronic_throttle_response = {
                    label = "Gasrespons",
                    values = {
                        [0] = "Mer grepp",
                        [1] = "Aggressiv",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie-inställning",
                    values = {
                        [0] = "Av",
                        [1] = "Mjuk",
                        [2] = "Intensiv",
                    },
                },
            },
            vehicleClassLabel = "Klass {id} ({name})",
        },
    },
}
