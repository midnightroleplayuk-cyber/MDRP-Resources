JobConfigLocales["sky_ambulancejob:se"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Medicinska utlåtanden",
                sharedMedicalEvaluations = "Delade medicinska utlåtanden",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Tillat respawn",
                        description = "Styr om denna sang kan anvandas for spelar-respawn.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Konfigurera ambulansjobb, sjukhussängar, dödssystem, interaktioner och kärnfunktionsinställningar.",
                    title = "Ambulans jobb",
                },
            },
            dispatchActions = {
                currentLocation = "Använd aktuell plats",
                addChannel = "Lägg till radiokanal",
                addKeyword = "Lägg till nyckelord",
                addPoi = "Lägg till intressepunkt",
                addReporter = "Lägg till anmälare",
                addStatus = "Lägg till FMS-status",
                addVehicle = "Lägg till virtuell enhet",
                addVehicleType = "Lägg till enhetstyp",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Minst antal anställda över de enheter som valts för denna svarsplan.",
                noUnitFallback = "Utan en central eller bemannad enhet skickar en Sky-meddelande till alla medlemmar på avdelningen.",
                radius = "Maximalt avstånd i meter där stationsmeddelandet kan höras.",
                requirements = "Svarskrav som TYPE:COUNT-par, till exempel PATROL:2,CRIME:1.",
                statusCode = "Numerisk FMS-status visas på den handhållna radion.",
                statusLabel = "Betydelse av denna FMS-status för avsändare och enheter.",
                vehicleType = "Måste matcha en fordonstyp kod konfigurerad i föregående underavsnitt.",
                vehicleTypeCode = "Kort enhetskod som används i svarskrav, till exempel PATROL, CRIME, EMS eller RESCUE.",
                vehicleTypeLabel = "Läsbart namn på denna enhetskategori.",
                crewCapacity = "Högsta antalet personer som får bemanna enheten. Använd 0 för obegränsad besättning.",
                joinLocked = "Hindrar fler personer från att ansluta när enheten redan är bemannad.",
                poiId = "Beständig teknisk identifierare som centralprofiler kan använda även efter att platsen bytt namn.",
                readyStatusCode = "FMS-status som används när resursen blir tillgänglig för utlarmning.",
                resourceType = "Klassificerar den operativa resursen för ledningscentralens filter och samordning.",
                respondingStatusCode = "FMS-status som används när resursen svarar på en händelse.",
                shortLabel = "Valfri kort etikett på radions sex minnesknappar för kanaler.",
                stationId = "Kopplar enheten till en station i ledningscentralens profil.",
                unitId = "Beständig teknisk identifierare som bevarar enheten även om anropssignalen ändras.",
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
                defaultChannel = "Standard radiokanal",
                emergencyAppEnabled = "Visa i nödapp",
                enabled = "Enable Dispatch",
                icon = "Ikon",
                incidentAssessmentEnabled = "Aktivera nödbedömning",
                jobs = "Måljobb (komma separerade)",
                keywordCode = "Keyword-kod",
                label = "Etikett",
                minimumCrew = "Minsta besättning",
                name = "Namnnamn",
                noUnitFallback = "Meddela personal utan enheter",
                noneChannel = "Ingen / grupp standard",
                note = "Notera",
                phone = "Telefon",
                radius = "Tillkännagivande radie",
                requirements = "Krävda enheter (till exempel PATROL:2,CRIME:1)",
                type = "Typ",
                vehicleType = "Svar enhet typ",
                crewCapacity = "Besättningskapacitet",
                joinLocked = "Lås anslutning till besättningen",
                poiId = "Beständigt POI-ID",
                readyStatusCode = "Kod för beredskapsstatus",
                resourceType = "Resurstyp",
                respondingStatusCode = "Kod för utryckningsstatus",
                shortLabel = "Etikett för radiominne",
                stationId = "Stations-ID",
                unitId = "Beständigt enhets-ID",
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
                    statuses = "Tillgänglig FMS",
                    units = "Virtuella enheter",
                    reporters = "Kända anmälare",
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
                dispatchStatusCodes = "Konfigurerar FMS-statusetiketter och vilka statuser som gäller för nya incidenter.",
                dispatchVehicleTypes = "Definierar enhetskategorier som används av svarsplaner, t.ex. Patrol, Crime Unit, EMS eller Rescue.",
                dispatchVehicles = "Definierar virtuella sändningsfordon som kan bemannas från var som helst utan att kräva ett gyllene fordon.",
                dispatchReporters = "Hanterar anmälares namn, återuppringningsnummer och ledningsanteckningar för jobbet.",
            },
            extensions = {
                invalidSelection = "Ogiltigt val: {value}",
                trainingSettings = {
                    description = "Konfigurera utbildningsåtkomst, inskrivning, godkännanden och kursplanering för detta jobb.",
                    label = "Träningsinställningar",
                },
                dispatchReporters = "Kända anmälare",
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
            },
            features = {
                bleeding = {
                    description = "Aktivera blödningssystemet.",
                    label = "Blödning",
                },
                bodybags = {
                    description = "Aktivera kroppspåsar och kroppspåsleveransflöden.",
                    label = "Kroppsväskor",
                },
                consciousScenarioBloodPressure = {
                    description = "Tillåt blodtryckskontroller medan patienten är vid medvetande.",
                    label = "Medvetet blodtryck",
                },
                deathTimeout = {
                    description = "Aktivera dödstidens flöde.",
                    label = "Timeout för döden",
                },
                fractures = {
                    description = "Möjliggöra frakturhantering och behandling.",
                    label = "Frakturer",
                },
                knockout = {
                    description = "Aktivera knockout-systemet.",
                    label = "Knockout",
                },
                legShotRagdoll = {
                    description = "Spelaren faller vid träff i inställda ben- eller fotzoner.",
                    label = "Fall vid benskott",
                },
                pain = {
                    description = "Aktivera smärtsystemet.",
                    label = "Smärta",
                },
                respawnInBed = {
                    description = "Återuppliva återupplivade spelare i en sjukhussäng när det är tillgängligt.",
                    label = "Respawn I Säng",
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
                gang = "Gäng",
                allowInVehicle = "Tillåt i fordon",
                allowMovement = "Tillåt rörelse",
                animDict = "Animationsordbok",
                animFlag = "Animationsflagga",
                animName = "Animationsnamn",
                bleeding = "Blödning",
                cause = "Orsak",
                chance = "Chans",
                class = "Klass",
                companyPrice = "Företagspris",
                companyPricePerEmployee = "Pris per anställd",
                copayPercent = "Kostnad (i procent)",
                description = "Beskrivning",
                dictionary = "Animation ordbok",
                duration = "Varaktighet",
                durationMs = "Varaktighet (ms)",
                effect = "Effekt",
                effectDurationMs = "Effektens varaktighet (ms)",
                effectDurationSeconds = "Effektens varaktighet (sekunder)",
                enabled = "Aktiverad",
                extractionType = "Uttagstyp",
                foreignObject = "Främmande föremål",
                heal = "Läkning",
                id = "ID",
                itemName = "Objektets namn",
                key = "Nyckel",
                label = "Märka",
                lang = "Språk",
                limit = "Gräns",
                lossPerSecond = "Förlust per sekund",
                max = "Högst",
                min = "Lägsta",
                minGrade = "Minsta betyg",
                minigame = "Minispel",
                model = "Prop modell",
                name = "Jobbets namn",
                options = "Alternativ (valstyper)",
                pain = "Smärta",
                pauseBleedingSeconds = "Pausa blödning (sekunder)",
                price = "Pris",
                progressbarAllowInVehicle = "Förlopp: tillåt i fordon",
                progressbarAllowMovement = "Förlopp: tillåt rörelse",
                progressbarCanCancel = "Förlopp kan avbrytas",
                progressbarDisableCarMovement = "Förlopp: blockera fordonsrörelse",
                progressbarDisableCombat = "Förlopp: blockera strid",
                progressbarDisableMouse = "Förlopp: blockera mus",
                progressbarDisableMovement = "Förlopp: blockera rörelse",
                progressbarDisableSprint = "Förlopp: blockera sprint",
                progressbarDuration = "Förloppstid",
                progressbarEnabled = "Förloppsmätare aktiverad",
                progressbarLabel = "Förloppstext",
                progressbarUseWhileDead = "Användbar som död",
                questions = "Frågor",
                requireItems = "Kräv föremål",
                required = "Nödvändigt",
                requiresExtraction = "Kräver uttag",
                requiresOpenWound = "Kräver öppet sår",
                sort = "Ordning",
                state = "Tillstånd",
                stopBleeding = "Stoppa blödning",
                threshold = "Tröskel",
                time = "Tid",
                type = "Typ",
                useAnimation = "Använd animation",
                value = "Värde",
                zone = "Zon",
                zones = "Zoner",
                systolic = "Systoliskt blodtryck",
                diastolic = "Diastoliskt blodtryck",
                cardiacArrest = "Hjärtstopp",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Allmän",
                },
                billingRange = {
                    label = "Räckvidd",
                },
                billingReasons = {
                    label = "Orsak Förinställningar",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animering",
                },
                bodyBagAttachGeneral = {
                    label = "Bifoga",
                },
                bodyBagAttachOffsets = {
                    label = "Förskjutningar",
                },
                bodyBagAttachRotation = {
                    label = "Rotation",
                },
                bodyBagDeliveryGeneral = {
                    label = "Allmän",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Allmän",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Betalning",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Allmän",
                },
                crutchAssign = {
                    label = "Uppdrag",
                },
                crutchDuration = {
                    label = "Varaktighet",
                },
                crutchGeneral = {
                    label = "Allmän",
                },
                crutchItems = {
                    label = "Punkt",
                },
                crutchRestrictions = {
                    label = "Restriktioner",
                },
                damageHandlingBladeWeapons = {
                    label = "Bladvapen",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Blödande svartlista",
                },
                damageHandlingBleedingClasses = {
                    label = "Blödningsklasser",
                },
                damageHandlingBloodSystem = {
                    label = "Blodsystem",
                },
                damageHandlingDeathInjuries = {
                    label = "Dödsskador",
                },
                damageHandlingInjuryEffects = {
                    label = "Skadeeffekter",
                },
                damageHandlingInjuryThresholds = {
                    label = "Skadetrösklar",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Benskott ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Benskott zoner",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Levande skador frakturer",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zonchanser",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Oppna sar staplar",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Zongranser",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Levande sårklasser",
                },
                damageHandlingMedications = {
                    label = "Mediciner",
                },
                damageHandlingPainClasses = {
                    label = "Smärtklasser",
                },
                damageHandlingPainEffects = {
                    label = "Smärta effekter",
                },
                damageHandlingStatusEffects = {
                    label = "Statuseffekter",
                },
                damageHandlingVehicleDamage = {
                    label = "Fordonsskador",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Skador orsakar",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Skador",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Krockskydd för fordon",
                },
                deathAnimal = {
                    label = "Tillbakagång från djur",
                },
                deathAnimalAnimation = {
                    label = "Animation",
                },
                deathAnimation = {
                    label = "Animering",
                },
                deathGeneral = {
                    label = "Allmän",
                },
                deathModels = {
                    label = "Per modell åsidosätter",
                },
                deathScreenAiMedic = {
                    label = "Allmän",
                },
                deathScreenAiMedicAvailability = {
                    label = "Tillgänglighet",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Beteende",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Tvinga revive",
                },
                deathScreenAiMedicPayment = {
                    label = "Betalning",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Återuppliva i sängen",
                },
                deathScreenAiMedicSpawn = {
                    label = "Rom",
                },
                deathScreenAiMedicTiming = {
                    label = "Tidsschema",
                },
                deathScreenControls = {
                    label = "Kontroller",
                },
                deathScreenDamageLogs = {
                    label = "Skadeloggar",
                },
                deathScreenDimensions = {
                    label = "Mått",
                },
                deathScreenDispatch = {
                    label = "Avsändande",
                },
                deathScreenEarlyRespawn = {
                    label = "Allmän",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Tillgänglighet",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Betalning",
                },
                deathScreenGeneral = {
                    label = "Allmän",
                },
                deathScreenHospitalSelection = {
                    label = "Sjukhusval",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Urvalskamera",
                },
                deathScreenInformation = {
                    label = "Allmän",
                },
                deathScreenIntegration = {
                    label = "Integrering",
                },
                deathScreenLogs = {
                    label = "Dödsloggar",
                },
                deathScreenMinigame = {
                    label = "Minispel",
                },
                deathScreenRespawn = {
                    label = "Allmän",
                },
                deathScreenRespawnAccounts = {
                    label = "konton",
                },
                deathScreenRespawnFallback = {
                    label = "Återfallsord",
                },
                deathScreenRespawnItems = {
                    label = "Föremål",
                },
                deathScreenRespawnWeapons = {
                    label = "Vapen",
                },
                deathScreenStyle = {
                    label = "Dödsskärmsstil",
                },
                deathScreenVoice = {
                    label = "Röst",
                },
                deathTimeoutGeneral = {
                    label = "Allmän",
                },
                deathTimeoutWhitelist = {
                    label = "Vitlistade jobb",
                },
                diagnoseAnim = {
                    label = "Animering",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Fullständig läkning",
                },
                diagnoseGeneral = {
                    label = "Allmän",
                },
                doctorNpcAvailability = {
                    label = "Tillgänglighet",
                },
                doctorNpcGeneral = {
                    label = "Allmän",
                },
                doctorNpcHealOther = {
                    label = "Läka andra",
                },
                doctorNpcHealSelf = {
                    label = "Läka Jaget",
                },
                doctorNpcRanges = {
                    description = "Dessa intervall styr inte hur nära en spelare måste vara för att öppna läkarens NPC-interaktion. De gäller först efter att läkarmenyn öppnats.",
                    label = "Avstånd",
                },
                doctorNpcRevive = {
                    label = "Återuppliva",
                },
                doctorNpcReviveInBed = {
                    label = "Återuppliva i sängen",
                },
                firstAidAnimation = {
                    label = "Animering",
                },
                firstAidGeneral = {
                    label = "Allmän",
                },
                firstAidLicenseAdd = {
                    label = "Licens Lägg till",
                },
                firstAidLicenseRemove = {
                    label = "Ta bort licens",
                },
                firstAidPosition = {
                    label = "Placera",
                },
                healthInsuranceExpiration = {
                    label = "Utgång",
                },
                healthInsuranceGeneral = {
                    label = "Allmän",
                },
                healthInsurancePayment = {
                    label = "Betalning",
                },
                healthInsuranceProviders = {
                    label = "Leverantörer",
                },
                hospitalBedsBedAnimation = {
                    label = "Sänganimation",
                },
                hospitalBedsCreator = {
                    label = "Skapare",
                },
                hospitalBedsDistances = {
                    label = "Avstånd",
                },
                hospitalBedsGeneral = {
                    label = "Allmän",
                },
                hospitalBedsGetupAnimation = {
                    label = "Getup-animering",
                },
                hospitalBedsModels = {
                    label = "Modeller",
                },
                hospitalBedsOffsets = {
                    label = "Förskjutningar",
                },
                hospitalBlip = {
                    label = "Sjukhusblipp",
                },
                imagingGeneral = {
                    label = "Allmän",
                },
                imagingRanges = {
                    label = "Avstånd",
                },
                keybinds = {
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                    label = "Kortkommandon",
                },
                knockoutGeneral = {
                    label = "Allmän",
                },
                knockoutWeapons = {
                    label = "Vapen",
                },
                medicCarryAttach = {
                    label = "Bifoga",
                },
                medicCarryAttachOffsets = {
                    label = "Förskjutningar",
                },
                medicCarryAttachRotation = {
                    label = "Rotation",
                },
                medicCarryCarrierAnimation = {
                    label = "Bäraranimation",
                },
                medicCarryGeneral = {
                    label = "Allmän",
                },
                medicCarryPassengerAnimation = {
                    label = "Passageraranimering",
                },
                medicCarryRestrictions = {
                    label = "Restriktioner",
                },
                medicRevivePersistence = {
                    label = "Allmän",
                },
                medicalEvaluationRecipients = {
                    label = "Mottagaryrken",
                },
                medicalEvaluationSharing = {
                    label = "Delade fält",
                },
                medicalEvaluationTypes = {
                    label = "Utvärderingstyper",
                },
                medicalEvaluationsGeneral = {
                    label = "Allmän",
                },
                medicalWearablesArmRestrictions = {
                    label = "Begränsningar för armgips",
                },
                medicalWearablesCasts = {
                    label = "Gips",
                },
                medicalWearablesDuration = {
                    label = "Användningstid",
                },
                medicalWearablesGeneral = {
                    label = "Allmänt",
                },
                medicalWearablesHeadBandage = {
                    label = "Huvudförband",
                },
                medicalWearablesLegRestrictions = {
                    label = "Begränsningar för bengips",
                },
                medicalWearablesNeckBrace = {
                    label = "Nackkrage",
                },
                medicalWearablesOxygenMask = {
                    label = "Syrgasmask",
                },
                medicalWearablesPatientHud = {
                    label = "Patient-HUD",
                },
                medicalWearablesRemoval = {
                    label = "Borttagning",
                },
                medicalWearablesSplints = {
                    label = "Skenor",
                },
                medicalWearablesTorsoBandage = {
                    label = "Bröstkorgsförband",
                },
                minigamesCprGeneral = {
                    label = "Allmän",
                },
                minigamesEnabled = {
                    label = "Aktiverad",
                },
                minigamesVentilationGeneral = {
                    label = "Allmän",
                },
                operationsAnesthesia = {
                    label = "Anestesi",
                },
                operationsDistances = {
                    label = "Avstånd",
                },
                operationsDoctorAnimation = {
                    label = "Kirurganimation",
                },
                operationsGeneral = {
                    label = "Allmänt",
                },
                operationsPatientAnimation = {
                    label = "Patientanimation",
                },
                operationsTrainingAnimation = {
                    label = "Träningsanimation",
                },
                propPlacement = {
                    label = "Prop placering",
                },
                propPlacementItems = {
                    label = "Prop artiklar",
                },
                publicTreatmentGeneral = {
                    label = "Allmän",
                },
                publicTreatmentJobs = {
                    label = "Tillåtna jobb",
                },
                publicTreatmentRequirements = {
                    label = "Krav",
                },
                reviveRewardGeneral = {
                    label = "Allmän",
                },
                reviveRewardPayment = {
                    label = "Betalning",
                },
                selfDiagnoseGeneral = {
                    label = "Allmän",
                },
                stretcherAnimation = {
                    label = "Animering",
                },
                stretcherCarryAttach = {
                    label = "Bär Fäst",
                },
                stretcherFolded = {
                    label = "Vikt variant",
                },
                stretcherFoldedPatientAttach = {
                    label = "Vikt patientfäste",
                },
                stretcherGeneral = {
                    label = "Allmän",
                },
                stretcherHelicopter = {
                    label = "Helikopter",
                },
                stretcherPatientAttach = {
                    label = "Patient Bifoga",
                },
                stretcherTreatmentAnim = {
                    label = "Animering",
                },
                stretcherVehicleAttach = {
                    label = "Fordonsfäste",
                },
                stretcherVehicleLists = {
                    label = "Fordonsmodeller",
                },
                treatmentAnim = {
                    label = "Animering",
                },
                treatmentEnable = {
                    label = "Aktivera",
                },
                trunk = {
                    label = "Bagageutrymme",
                },
                vehiclePullGeneral = {
                    label = "Allmän",
                },
                wheelchairAssign = {
                    label = "Uppdrag",
                },
                wheelchairDuration = {
                    label = "Varaktighet",
                },
                wheelchairGeneral = {
                    label = "Allmän",
                },
                wheelchairItems = {
                    label = "Punkt",
                },
                wheelchairRestrictions = {
                    label = "Restriktioner",
                },
                xrayGeneral = {
                    label = "Allmän",
                },
                xrayRanges = {
                    label = "Avstånd",
                },
                appointmentsGeneral = {
                    label = "Allmän",
                },
                appointmentsLimits = {
                    label = "Gränser",
                },
                appointmentsNotifications = {
                    label = "Aviseringar",
                },
                appointmentsScheduling = {
                    label = "Schemaläggning",
                },
                healthCompatibility = {
                    label = "Förenlighet i hälsa",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Allmän",
                },
                minigamesRandomization = {
                    label = "Randomisering",
                },
            },
            settingSections = {
                billing = "Fakturering",
                bodyBag = "Kroppsväska",
                damageHandling = "Skadehantering",
                death = "Död",
                deathScreen = "Dödsskärm",
                diagnose = "Diagnostisera",
                doctorNpc = "Doktor NPC",
                general = "Allmän",
                healthInsurance = "Sjukförsäkring",
                hospitalBeds = "Sjukhussängar",
                knockout = "Knockout",
                medicCarry = "Bär patient",
                minigames = "Minispel",
                mobilityAid = "Rörlighetshjälpmedel",
                operations = "Operationer",
                organization = "Organisation",
                rewards = "Belöningar",
                treatment = "Behandling",
                vehiclePull = "Fordonsdrag",
            },
            settingSubsections = {
                aiMedic = "AI-sjukvårdare",
                anesthesia = "Anestesi",
                animation = "Animering",
                animations = "Animationer",
                attach = "Bifoga",
                bedAnimation = "Sänganimation",
                blood = "Blod",
                bodyBagDeliveryReward = "Belöning för liksäcksleverans",
                carrierAnimation = "Bäraranimation",
                classification = "Klassificering",
                cpr = "CPR",
                crutch = "Krycka",
                deathInjuries = "Dödsskador",
                deathScreenStyle = "Dödsskärmsstil",
                deathTimeout = "Timeout för döden",
                delivery = "Leverans",
                diagnoseAnim = "Diagnostisera animering",
                dispatch = "Avsändande",
                earlyRespawn = "Tidig återuppbyggnad",
                effects = "Effekter",
                firstAid = "Första hjälpen",
                general = "Allmän",
                getupAnimation = "Getup-animering",
                imaging = "Avbildning",
                information = "Uppgifter",
                keybinds = "Kortkommandon",
                liveDamage = "Live skada",
                logs = "Loggar",
                medicRevivePersistence = "Medicinsk återupplivningspersistens",
                medicalEvaluations = "Medicinska utlåtanden",
                medicalWearables = "Medicinska hjälpmedel",
                medications = "Mediciner",
                minigame = "Minispel",
                passengerAnimation = "Passageraranimering",
                pricing = "Prissättning",
                propPlacement = "Prop placering",
                publicTreatment = "Offentlig behandling",
                respawn = "Återupplivning",
                reviveInBed = "Återuppliva i sängen",
                reviveReward = "Återuppliva belöning",
                selfDiagnose = "Självdiagnos",
                stretcher = "Bår",
                stretcherTreatmentAnim = "Bårbehandlingsanimation",
                thresholds = "Trösklar",
                treatmentAnim = "Behandlingsanimation",
                trunk = "Bagageutrymme",
                vehicleImpact = "Fordonspåverkan",
                ventilation = "Ventilation",
                wheelchair = "Rullstol",
                xray = "Röntgen",
                appointments = "Utnämningar",
                bloodTransfusion = "Blodtransfusion",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Redigerare · Kontroll 172",
                    description = "Anpassar: Editor: Flytta upp.",
                },
                ambulanceEditorControl173 = {
                    label = "Redigerare · Kontroll 173",
                    description = "Anpassar: Editor: Flytta ner.",
                },
                ambulanceEditorControl174 = {
                    label = "Redigerare · Kontroll 174",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl175 = {
                    label = "Redigerare · Kontroll 175",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl177 = {
                    label = "Redigerare · Kontroll 177",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl201 = {
                    label = "Redigerare · Kontroll 201",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl202 = {
                    label = "Redigerare · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl21 = {
                    label = "Redigerare · Kontroll 21",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl32 = {
                    label = "Redigerare · Kontroll 32",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl33 = {
                    label = "Redigerare · Kontroll 33",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl34 = {
                    label = "Redigerare · Kontroll 34",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl35 = {
                    label = "Redigerare · Kontroll 35",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl36 = {
                    label = "Redigerare · Kontroll 36",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl37 = {
                    label = "Redigerare · Kontroll 37",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl38 = {
                    label = "Redigerare · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceEditorControl44 = {
                    label = "Redigerare · Kontroll 44",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Första hjälpen · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interaktion · Kontroll 177",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interaktion · Kontroll 201",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interaktion · Kontroll 202",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interaktion · Kontroll 21",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interaktion · Kontroll 241",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interaktion · Kontroll 242",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interaktion · Kontroll 25",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interaktion · Kontroll 32",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interaktion · Kontroll 33",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interaktion · Kontroll 34",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interaktion · Kontroll 35",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interaktion · Kontroll 36",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interaktion · Kontroll 38",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interaktion · Kontroll 44",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                billingAccount = {
                    description = "Äldre reservsamhälleskonto som används för fakturering.",
                    label = "Konto",
                },
                billingCloseOnSuccess = {
                    description = "Stäng faktureringsgränssnittet automatiskt efter en lyckad fakturering.",
                    label = "Nära framgång",
                },
                billingCurrency = {
                    description = "Valfri valutanyckel som används för faktureringsbetalningar.",
                    label = "Valuta",
                },
                billingCustomBillingReasons = {
                    description = "Tillåt läkare att ange anpassade faktureringsskäl.",
                    label = "Anpassade skäl",
                },
                billingDepositToSociety = {
                    description = "Sätt in faktureringsintäkter på samhällets konto.",
                    label = "Deposition till samhället",
                },
                billingEnabled = {
                    description = "Aktivera det medicinska faktureringssystemet.",
                    label = "Aktiverad",
                },
                billingMaxReasonLength = {
                    description = "Maximal längd för anpassade faktureringsskäl.",
                    label = "Max orsakslängd",
                },
                billingMode = {
                    description = "Välj om medicinska räkningar debiteras omedelbart, kräver bekräftelse eller använder ramfaktureringssystemet.",
                    label = "Faktureringsläge",
                    options = {
                        consent = "Betala eller tacka nej",
                        framework = "Ramproposition",
                        instant = "Omedelbar laddning",
                    },
                },
                billingRange = {
                    description = "Maximalt intervall för att hitta fakturerbara patienter.",
                    label = "Räckvidd",
                },
                billingReasonPresets = {
                    description = "Förinställda faktureringsorsaker visas i faktureringsgränssnittet.",
                    itemLabel = "Resonera",
                    label = "Förinställda skäl",
                },
                billingRefreshSeconds = {
                    description = "Sekunder mellan fakturerbara spelares uppdateringar.",
                    label = "Uppdatera sekunder",
                },
                bladeWeapons = {
                    description = "Vapennamn eller hash som ska klassas som knivskada istället för trubbigt.",
                    itemLabel = "Vapen",
                    label = "Bladvapen",
                },
                bleedingBlacklist = {
                    description = "Vapen som aldrig ska skapa levande blödningar eller öppna sår.",
                    itemLabel = "Vapen",
                    label = "Blödande svartlista",
                },
                bleedingClassesProfiles = {
                    description = "Blödningsallvarlighetsprofiler och deras blodförlusthastighet.",
                    label = "Blödningsklasser",
                },
                bloodSystemDebugLogInterval = {
                    description = "Sekunder mellan blodsystemets felsökningsloggmeddelanden.",
                    label = "Felsökningsloggintervall",
                },
                bloodSystemMaxVolume = {
                    description = "Maximalt värde för blodvolym som används av patienttillståndssystemet.",
                    label = "Max volym",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passiv blodregenerering tillämpas när patienten inte aktivt blöder.",
                    label = "Regen per sekund",
                },
                bloodSystemTickIntervalMs = {
                    description = "Server tick-intervall som används för blodförlust och återhämtningsuppdateringar.",
                    label = "Bockintervall ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Blodvolymtröskeln under vilken patienten blir medvetslös.",
                    label = "Omedveten tröskel",
                },
                bodyBagAnimationDict = {
                    description = "Animationsordbok som används för att bära en kroppsväska.",
                    label = "Animation ordbok",
                },
                bodyBagAnimationEnabled = {
                    description = "Använd en dedikerad bäranimation medan du bär en kroppsväska.",
                    label = "Aktiverad",
                },
                bodyBagAnimationFlag = {
                    description = "TaskPlayAnim-flagga som används för bäranimeringen.",
                    label = "Animation flagga",
                },
                bodyBagAnimationName = {
                    description = "Animationsklipp som används för att bära en kroppsväska.",
                    label = "Animationens namn",
                },
                bodyBagAttachBone = {
                    description = "Ped bennamn eller ben-ID som används för kroppspåsen.",
                    label = "Ben",
                },
                bodyBagAttachRx = {
                    description = "Kroppsväska fäst X rotation.",
                    label = "Fäst RX",
                },
                bodyBagAttachRy = {
                    description = "Kroppsväska fäster Y-rotation.",
                    label = "Fäst RY",
                },
                bodyBagAttachRz = {
                    description = "Kroppsväska fäster Z-rotation.",
                    label = "Fäst RZ",
                },
                bodyBagAttachX = {
                    description = "Kroppsväska fäster X offset.",
                    label = "Bifoga X",
                },
                bodyBagAttachY = {
                    description = "Kroppsväska fäster Y offset.",
                    label = "Fäst Y",
                },
                bodyBagAttachZ = {
                    description = "Kroppsväska fäster Z offset.",
                    label = "Fäst Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Språknyckel som används för hjälpprompten för avlämning av kroppspåsen.",
                    label = "Hjälpetikett nyckel",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Avstånd som används för validering av avlämning av kroppsväskor.",
                    label = "Interagera avstånd",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Kontroll-ID som används för avlämning av kroppsväskor.",
                    label = "Interagera nyckel",
                },
                bodyBagDeliveryInteraction = {
                    description = "Interaktionsmallnyckel som används för avlämning av kroppsväskor.",
                    label = "Interaktionsmall",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Kräv att läkare lämnar över kroppsväskor vid konfigurerade avlämningsställen.",
                    label = "Kräv avlämning",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Kräv att läkare är i tjänst innan kroppsväskan levereras.",
                    label = "Kräv i tjänst",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Primär kontonyckel som används för belöningar för leverans av kroppsväskor.",
                    label = "Konto",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Primär kontotyp som används för belöningar för leverans av kroppsväskor.",
                    label = "Kontotyp",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Belöningsbelopp som betalas för en kroppsväska.",
                    label = "Belopp",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Valfri anpassad valutanyckel som används för belöningar för leverans av kroppsväskor.",
                    label = "Valuta",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Betala en konfigurerad belöning efter att en kroppsväska har levererats.",
                    label = "Aktiverad",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Dra av belöningar för leverans av kroppsväskor från det delade jobbsamhället innan du betalar läkaren.",
                    label = "Betala från samhället",
                },
                bodyBagEnabled = {
                    description = "Aktivera bodybag-systemet.",
                    label = "Aktiverad",
                },
                bodyBagHidePatient = {
                    description = "Göm patienten när kroppsväskan är fastsatt.",
                    label = "Göm patienten",
                },
                bodyBagModel = {
                    description = "Prop-modell som används för kroppsväskor.",
                    label = "Modell",
                },
                bodyBagPatientAlpha = {
                    description = "Alfa appliceras på patienten medan den är kroppspackad.",
                    label = "Patient alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Maximalt avstånd för att tilldela en krycka till en annan spelare.",
                    label = "Tilldela maxavstånd",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Avutrusta kryckan automatiskt när uppdraget löper ut.",
                    label = "Auto avutrustning vid utgång",
                },
                crutchClipset = {
                    description = "Rörelseklämma appliceras när du använder kryckan.",
                    label = "Klippset",
                },
                crutchDefaultDurationMinutes = {
                    description = "Standard tilldelad krycklängd i minuter.",
                    label = "Standardvaraktighet",
                },
                crutchDisableSprint = {
                    description = "Block sprint medan en krycka är utrustad.",
                    label = "Inaktivera sprint",
                },
                crutchDisableWeapons = {
                    description = "Blockera vapenanvändning medan en krycka är utrustad.",
                    label = "Inaktivera vapen",
                },
                crutchItemName = {
                    description = "Inventeringsobjekt som används för kryckan.",
                    label = "Objektets namn",
                },
                crutchMaxDurationMinutes = {
                    description = "Maximalt tillåtna kryckuppdragslängd i minuter.",
                    label = "Max varaktighet",
                },
                crutchMinDurationMinutes = {
                    description = "Minsta tillåtna kryckuppdragslängd i minuter.",
                    label = "Min varaktighet",
                },
                crutchProp = {
                    description = "Stödmodell som används för kryckan.",
                    label = "Stötta",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekunder då enskilda träffar samlas i ett Discord-meddelande.",
                    label = "Samlingsintervall",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maximalt antal enskilda träffar i ett Discord-meddelande.",
                    label = "Träffar per meddelande",
                },
                damageLogsEnabled = {
                    description = "Skicka serverbekräftade icke-dödliga träffar till Discord.",
                    label = "Skadeloggar",
                },
                deathAnimalAnimationDictionary = {
                    description = "Animationsordbok som används för djurens fallback-dödsanimering.",
                    label = "Djurordbok",
                },
                deathAnimalAnimationName = {
                    description = "Animationsklipp som används för djurets fallback-dödsanimation.",
                    label = "Djuranimationsnamn",
                },
                deathAnimalUseAnimation = {
                    description = "Tillåt det konfigurerade djurets fallback att använda en skriptad dödsanimation.",
                    label = "Animation av djur",
                },
                deathAnimationDictionary = {
                    description = "Animationsordbok som används för standard dödsanimering.",
                    label = "Animation ordbok",
                },
                deathAnimationName = {
                    description = "Animationsklipp som används för standard dödsanimering.",
                    label = "Animationens namn",
                },
                deathInjuriesProfiles = {
                    description = "Skadeprofiler tillämpas när en spelare dör av en specifik orsak.",
                    itemLabel = "Skada",
                    label = "Dödsskador",
                },
                deathModels = {
                    description = "Åsidosätt beteende från dödsanimering per ped-modell eller modellhash.",
                    label = "Modell åsidosätter",
                },
                deathScreenAiMedicAccount = {
                    description = "Primärt konto debiteras för AI-läkaren.",
                    label = "Konto",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Sekunder läggs till i utfallstimern när AI-läkaren efterfrågas.",
                    label = "Lägg till dödstimer",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Låt AI-läkaren återuppliva dödliga sår.",
                    label = "Tillåt dödliga sår",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Avstånd där AI-läkaren stannar och närmar sig till fots.",
                    label = "Inflygningsavstånd",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Nedkylning innan AI-läkaren kan tillkallas igen.",
                    label = "Nedkylningssekunder",
                },
                deathScreenAiMedicCurrency = {
                    description = "Valfri valutanyckel som används för AI-läkarbetalningar.",
                    label = "Valuta",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Valutaformaterare som används för AI-läkarbetalningar.",
                    label = "Valutaformaterare",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Sekunder innan AI-läkaren försvinner efter målgång.",
                    label = "Despawn fördröjning",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Fördröjning innan AI-läkarutskicket börjar.",
                    label = "Leveransförsening",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Körhastighet som används av AI-medicinbilen.",
                    label = "Körhastighet",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximal körtid innan force-revive triggers.",
                    label = "Kör timeout",
                },
                deathScreenAiMedicEnabled = {
                    description = "Aktivera AI-medic-räddningsflödet.",
                    label = "Aktiverad",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Reservkonto som används när det primära AI-läkarkontot har otillräckliga medel.",
                    label = "Reservkonto",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Tvinga en återupplivning om AI-läkaren inte kan nå spelaren.",
                    label = "Tvinga återupplivning aktiverad",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "AI-medic arbetar bara när jourhavande läkare är på eller under detta antal.",
                    label = "Max läkare online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximal uppdragslängd innan force-revive utlöser.",
                    label = "Uppdrag timeout",
                },
                deathScreenAiMedicPedModel = {
                    description = "Ped-modell som används för AI-läkaren.",
                    label = "Ped modell",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Mål när den skadade spelaren själv kallar på AI-sjukvårdaren.",
                    label = "Mål för spelarens begäran",
                    options = {
                        hospital = "Sjukhus",
                        location = "Nuvarande plats",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Pris debiteras för att ringa AI-läkaren.",
                    label = "Pris",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Sekunder efter spelarens död innan en sjukvårdare kan erbjuda en AI-sjukvårdare på distans.",
                    label = "Väntetid för fjärrutskick",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Tillåt läkare att skicka AI-läkaren till en nedlagd spelare från sändningskartan och /aimedic-kommandot.",
                    label = "Fjärrsändning",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Fjärrutskick av AI-läkarmottagning fungerar bara när jourhavande läkare är på eller under detta antal.",
                    label = "Fjärrutskick max medics online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Mål när en AI-sjukvårdare skickas på distans och erbjudandet accepteras.",
                    label = "Mål för fjärrutskick",
                    options = {
                        hospital = "Sjukhus",
                        location = "Nuvarande plats",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Sekunder som spelaren har på sig att acceptera erbjudandet om en AI-sjukvårdare på distans.",
                    label = "Tidsgräns för fjärrerbjudande",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Avstånd krävs innan AI-läkaren börjar återupplivas.",
                    label = "Återuppliva avståndet",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Sekunder ägnade åt att återuppliva spelaren.",
                    label = "Återuppliva varaktighet",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleportera spelaren till en sjukhussäng istället för att återuppliva på plats.",
                    label = "Återuppliva i sängen",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Sökradie som används för att hitta en återupplivningsbädd.",
                    label = "Sängsökningsradie",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Sekunder efter döden innan AI-läkaren blir tillgänglig.",
                    label = "Sekunder tills det är tillgängligt",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximal AI medic spawn radie.",
                    label = "Spawn radie max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minsta AI medic spawn radie.",
                    label = "Spawn radie min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Fordonsmodell som används av AI-läkaren.",
                    label = "Fordonsmodell",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Röstläge när du är medvetslös: ingen, lyssna eller full.",
                    label = "Röstläge",
                    options = {
                        full = "fullt",
                        listen = "lyssna",
                        none = "ingen",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Kontrollera ID:n som förblir aktiverade när de är medvetslösa.",
                    label = "Tillåtna kontroller",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Spara automatiskt spelare om utfallstimern redan har gått ut när den var frånkopplad.",
                    label = "Auto-respawn upphörde att återansluta",
                },
                deathScreenBackgroundEnd = {
                    description = "Slutfärgen på dödsskärmens bakgrund.",
                    label = "Bakgrundsslut",
                },
                deathScreenBackgroundStart = {
                    description = "Startfärgen på dödsskärmens bakgrund.",
                    label = "Bakgrundsstart",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Sekunder innan utfallstimern löper ut.",
                    label = "Blödningstimer",
                },
                deathScreenBlockedDimensions = {
                    description = "Mått där dödsskärmens respawnflöde är blockerat.",
                    label = "Blockerade dimensioner",
                },
                deathScreenBorderColor = {
                    description = "Kantfärg som används av dödsskärmen.",
                    label = "Kantfärg",
                },
                deathScreenDispatchEnabled = {
                    description = "Skicka utskickshändelser från dödsskärmsflödet.",
                    label = "Utskick aktiverat",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Alternativa mottagare när ingen primär mottagare är vid liv och i tjänst. Lämna tomt för att alltid larma de primära jobben.",
                    itemLabel = "Jobb",
                    label = "Reservjobb",
                },
                deathScreenDispatchJobs = {
                    description = "Jobb som larmas när en utslagen spelare begär hjälp.",
                    itemLabel = "Jobb",
                    label = "Larmade jobb",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Primärt konto debiteras för tidig återuppbyggnad.",
                    label = "Konto",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Håll tidig respawn tillgänglig även för dödliga sår.",
                    label = "Tillåt dödliga sår",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Valfri valutanyckel som används för tidiga återbetalningar.",
                    label = "Valuta",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Valutaformaterare används för tidiga återbetalningar.",
                    label = "Valutaformaterare",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Aktivera betald tidig respawn.",
                    label = "Aktiverad",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Reservkonto som används när det primära kontot har otillräckliga medel.",
                    label = "Reservkonto",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Valfri etikett visas för den tidiga återbetalningen.",
                    label = "Betalningsetikett",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Pris debiteras för en tidig respawn.",
                    label = "Pris",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Tillåt endast tidig återupptagning när ingen läkare är i tjänst.",
                    label = "Kräver inga läkare",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Sekunder efter döden innan tidig respawn blir tillgänglig.",
                    label = "Sekunder tills det är tillgängligt",
                },
                deathScreenEnableKeyboard = {
                    description = "Tillåt tangentbordsanvändning på dödsskärmen.",
                    label = "Aktivera tangentbordet",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Extern röstbackend för att stänga av när den är aktiverad.",
                    label = "Externt röstsystem",
                    options = {
                        saltychat = "Ätbara slaktbiprodukter av fjäderfä",
                        yaca = "- Ja, det är jag.",
                    },
                },
                deathScreenFocusKey = {
                    label = "Musinteraktion på dödsskärmen",
                    description = "Standardtangent för FiveM, t.ex. E, F6 eller MOUSE_BUTTON:MOUSE_RIGHT. Tomt betyder ingen standardtangent. Spelare kan ändra sina tangenter i FiveM-inställningarna; sparade personliga bindningar behålls.",
                },
                deathScreenHandlingMode = {
                    description = "Använd den statiska dödsanimationen eller behåll naturlig ragdollfysik tills kroppen ligger stabilt.",
                    label = "Dödshantering",
                    options = {
                        natural = "Naturlig",
                        static = "Statisk",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Döljer dödsskärmen när MELLANSLAG växlar till spelkontroller; inaktivera detta för att behålla det tidigare synliga överlägget.",
                    label = "Dölj överlägget med spelkontroller",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Höjdförskjutning tillämpas på kamerans fokusmål.",
                    label = "Fokushöjd",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Förhandsgranska kamerans synfält.",
                    label = "Synfält",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Kursförskjutning används när förhandsgranskningskameran placeras.",
                    label = "Kursförskjutning",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Höjdförskjutning tillämpas på förhandsgranskningskameran.",
                    label = "Kamerahöjd",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Pitch tillämpas på förhandsgranskningskameran.",
                    label = "Tonhöjd",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Avstånd från förhandsgranskningskameran till spawn-punkten.",
                    label = "Kameraradie",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Använd en mjuk övergång när du öppnar sjukhusvalskameran.",
                    label = "Smidig övergång",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Tillåt spelare att välja ett sjukhus innan de återuppstår.",
                    label = "Sjukhusval",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Visa endast sjukhusval när det finns mer än ett sjukhus.",
                    label = "Kräver flera sjukhus",
                },
                deathScreenInformationEnabled = {
                    description = "Visa informationsblocket på dödsskärmen.",
                    label = "Aktiverad",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Visa dödsorsaken i informationsblocket på dödsskärmen.",
                    label = "Visa dödsorsak",
                },
                deathScreenInformationShowInjuries = {
                    description = "Visa skador i informationsblocket på dödsskärmen.",
                    label = "Visa skador",
                },
                deathScreenInformationShowKiller = {
                    description = "Visa mördarens namn i informationsblocket på dödsskärmen.",
                    label = "Visa mördare",
                },
                deathScreenInformationShowWeapon = {
                    description = "Visa vapnet i informationsblocket på dödsskärmen.",
                    label = "Visa vapen",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Vitlistade gäng",
                    description = "Välj interna namn för gäng eller fristående organisationer. Ett matchande jobb eller gäng ger tillståndet eller undantaget. Tjänstgöring krävs endast för jobb.",
                    itemLabel = "Gäng",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Jobb får se utökad dödsskärmsinformation.",
                    itemLabel = "Jobb",
                    label = "Vitlistade jobb",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximalt antal sekunder för varje uppladdning av en dödsbild.",
                    label = "Tidsgräns för skärmbild",
                },
                deathScreenLogScreenshots = {
                    description = "Ladda upp offrets och den bekräftade mördarens vy efter textloggen.",
                    label = "Skärmbilder",
                },
                deathScreenLogsEnabled = {
                    description = "Skicka en Discord-logg varje gång en spelare dör.",
                    label = "Dödsloggar",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Avstånd i meter används för att räkna en läkare som närliggande.",
                    label = "Läkare i närheten",
                },
                deathScreenMinigameEnabled = {
                    description = "Aktivera dödsskärmens minispel.",
                    label = "Aktiverad",
                },
                deathScreenMinigameUrl = {
                    description = "URL öppnad för minispelet dödsskärmen.",
                    label = "Minispel URL",
                },
                deathScreenMode = {
                    description = "Använd den inbyggda dödsskärmen eller en extern integration.",
                    label = "Skärmläge",
                    options = {
                        external = "Extern",
                        internal = "Intern",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Stäng av externa röstsystem medan spelaren är död.",
                    label = "Stäng av extern röst",
                },
                deathScreenMutedTextColor = {
                    description = "Dämpad textfärg som används av dödsskärmen.",
                    label = "Dämpad textfärg",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Skriver ut detaljerade klient- och serverorsaker medan kroppen ligger kvar i ragdoll.",
                    label = "Felsökning av naturlig ragdoll",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Stabilisera stillaliggande kroppar automatiskt eller kräv att en sjukvårdare i tjänst lägger patienten i stabilt sidoläge.",
                    label = "Naturlig stabilisering",
                    options = {
                        automatic = "Automatisk",
                        medic = "Sjukvårdare krävs",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Panelbakgrundsfärg som används av dödsskärmen.",
                    label = "Panelbakgrund",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Blockera automatisk respawn efter blödning.",
                    label = "Förhindra auto-respawn",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Blockera auto-respawn medan en läkare är i närheten.",
                    label = "Blockera när läkare är i närheten",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Blocket återupplivas efter att utfallstimern har löpt ut.",
                    label = "Förhindra återupplivning vid utgång",
                },
                deathScreenPrimaryColor = {
                    description = "Bas CSS-färg som används för dödsskärmstemat.",
                    label = "Grundfärg",
                },
                deathScreenPrimaryDark = {
                    description = "Valfri mörkare accentfärg för dödsskärmen.",
                    label = "Primär mörk",
                },
                deathScreenPrimaryStrong = {
                    description = "Valfri starkare accentfärg för dödsskärmen.",
                    label = "Primär stark",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Kurs används när stationen inte har någon riktning definierad.",
                    label = "Standardrubrik",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Alternativ respawn-rubrik används när inga sjukhuspositioner finns.",
                    label = "Fallback rubrik",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Fallback respawn X-koordinat används när inga sjukhuspositioner finns.",
                    label = "Tillbakablick X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Fallback respawn Y-koordinat används när inga sjukhuspositioner finns.",
                    label = "Reserv Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Reserv-respawn Z-koordinat används när inga sjukhuspositioner finns.",
                    label = "Tillbakablick Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Välj ett fast sjukhus för respawns. Lämna den tom för att använda närmaste sjukhus.",
                    label = "Respawn sjukhus",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Ta bort kontosaldo vid respawn.",
                    label = "Ta bort konton",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Kontonamn togs bort vid respawn.",
                    itemLabel = "Konto",
                    label = "Kontonamn",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Ta bort inventeringsartiklar vid respawn.",
                    label = "Ta bort föremål",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Inventering artiklar som hålls på respawn.",
                    itemLabel = "Punkt",
                    label = "Ignorerade objekt",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Ta bort vapenhjulsvapen vid respawn.",
                    label = "Ta bort vapen",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Vapen hålls på återuppbyggnad.",
                    itemLabel = "Vapen",
                    label = "Ignorerade vapen",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleportera spelaren till ett sjukhus vid respawn.",
                    label = "Teleportera till sjukhus",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Återuppta uttömningstimern efter återanslutningen istället för att återställa den.",
                    label = "Återuppta vid återanslutning",
                },
                deathScreenShadowLight = {
                    description = "Mjuk skuggfärg som används av dödsskärmen.",
                    label = "Skuggljus",
                },
                deathScreenShadowMid = {
                    description = "Mellanskuggfärg som används av dödsskärmen.",
                    label = "Skugga mitten",
                },
                deathScreenShowNearestMedic = {
                    description = "Visa närmaste läkare på dödsskärmen.",
                    label = "Visa närmaste läkare",
                },
                deathScreenTextColor = {
                    description = "Primär textfärg som används av dödsskärmen.",
                    label = "Textfärg",
                },
                deathScreenTextShadow = {
                    description = "Textskuggfärg som används av dödsskärmen.",
                    label = "Text skugga",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Tillämpa dödstiden efter att knockout återupplivas också.",
                    label = "Ansök på knockout",
                },
                deathTimeoutSeconds = {
                    description = "Sekunder efter en återupplivning förblir den striden inaktiverad.",
                    label = "Sekunder",
                },
                deathTimeoutShowUi = {
                    description = "Visa nedräkningsbannern för dödstiden när den är aktiv.",
                    label = "Visa UI",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Vitlistade gäng",
                    description = "Välj interna namn för gäng eller fristående organisationer. Ett matchande jobb eller gäng ger tillståndet eller undantaget. Tjänstgöring krävs endast för jobb.",
                    itemLabel = "Gäng",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Jobb undantagna från dödstidens restriktioner.",
                    itemLabel = "Jobb",
                    label = "Vitlistade jobb",
                },
                deathUseAnimation = {
                    description = "Spela den konfigurerade dödsanimationen för peds som stöds.",
                    label = "Använd animation",
                },
                diagnoseAnimClip = {
                    description = "Animationsklipp som används när diagnosen öppnades. Lämna tomt för att använda ett scenario istället.",
                    label = "Animationens namn",
                },
                diagnoseAnimDict = {
                    description = "Animationsordbok som används när diagnosen öppnas. Lämna tomt för att använda ett scenario istället.",
                    label = "Animation ordbok",
                },
                diagnoseAnimScenario = {
                    description = "Scenario som används när diagnosen öppnades. Lämna tomt för att använda dikt + klipp istället.",
                    label = "Scenario",
                },
                diagnoseCprAnimDict = {
                    description = "Animationsordbok som används för HLR.",
                    label = "Animation ordbok",
                },
                diagnoseCprAnimName = {
                    description = "Animationsklipp som används för HLR.",
                    label = "Animationens namn",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Sammanhängande diagnostid som krävs innan fullständig läkning visas.",
                    label = "Fördröjning i sekunder",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Kräv räddningsryggsäck",
                    description = "Kräv rescue_backpack för att visa den vänstra verktygsraden för undersökning. Inaktivera för att alltid visa den; föremålskraven för enskilda verktyg gäller fortfarande.",
                },
                diagnoseFullHealEnabled = {
                    description = "Tillåt fullständig läkning efter en sammanhängande diagnossession.",
                    label = "Aktiverad",
                },
                diagnoseInteractDistance = {
                    description = "Maximalt avstånd som krävs för att diagnostisera eller kroppsväska en patient.",
                    label = "Interagera avstånd",
                },
                diagnosePatientMovementMode = {
                    label = "Patientens rörelse",
                    description = "Lås patientens position medan en annan spelare har behandlingsmenyn öppen, eller tillåt rörelse och stäng menyn när behandlingsavståndet överskrids. Självdiagnos ställs in separat.",
                    options = {
                        freeze = "Lås patientens position",
                        distance = "Stäng när avståndsgränsen överskrids",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Behandlingsavstånd (m)",
                    description = "Maximalt avstånd mellan behandlaren och patienten innan behandlingsmenyn stängs i avståndsläget. Avståndet för att öppna menyn ställs in separat.",
                },
                diagnoseKey = {
                    description = "Kontroll-ID som används för att diagnostisera interaktioner.",
                    label = "Interagera nyckel",
                },
                diagnoseOpenDelayMs = {
                    description = "Fördröjning innan diagnosgränssnittet öppnas.",
                    label = "Öppen fördröjning ms",
                },
                diagnosePromptDistance = {
                    description = "Avstånd som används för att visa diagnosen.",
                    label = "Snabbt avstånd",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Varaktighet som används för behandlingsanimationer.",
                    label = "Behandlingslängd ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Sätt in läkarbetalningar på det delade samhällets konto vid direktdebitering.",
                    label = "Tillför intäkter till samhället",
                },
                doctorNpcEnabled = {
                    description = "Aktivera läkarens NPC-tjänst.",
                    label = "Aktiverad",
                },
                doctorNpcHealOtherAccount = {
                    description = "Primär kontonyckel som används för att ladda hela en annan spelare.",
                    label = "Konto",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Primär kontotyp som används för att debitera healing en annan spelare.",
                    label = "Kontotyp",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Valfri anpassad valutanyckel som används för att ladda hela en annan spelare.",
                    label = "Valuta",
                },
                doctorNpcHealOtherPrice = {
                    description = "Pris för att läka en annan spelare hos doktorn NPC.",
                    label = "Pris",
                },
                doctorNpcHealSelfAccount = {
                    description = "Primär kontonyckel som används för att ladda självläkning.",
                    label = "Konto",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Primär kontotyp som används för att ladda självläkning.",
                    label = "Kontotyp",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Valfri anpassad valutanyckel som används för att ladda självläkning.",
                    label = "Valuta",
                },
                doctorNpcHealSelfPrice = {
                    description = "Pris för att läka dig själv hos läkaren NPC.",
                    label = "Pris",
                },
                doctorNpcInteractionRange = {
                    description = "Hur nära användaren måste hålla sig till läkarens NPC när den öppna läkarmenyn används. Detta ändrar inte det initiala NPC-promptavståndet.",
                    label = "Interaktionsintervall",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Doktor NPC fungerar bara när jourhavande läkare är under denna gräns.",
                    label = "Max läkare online",
                },
                doctorNpcPatientRange = {
                    description = "Hur nära patienten måste vara läkaren NPC för att läka andra eller återuppliva till arbete efter att ha valt åtgärd.",
                    label = "Patientutbud",
                },
                doctorNpcPaymentMode = {
                    description = "Debitera spelare omedelbart eller skicka en faktura.",
                    label = "Betalningsläge",
                    options = {
                        bill = "fakturera",
                        remove = "ta bort",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Används endast för att lista närliggande spelare i doktors NPC-gränssnitt. Det tillåter inte behandling i sig.",
                    label = "Spelarens skanningsintervall",
                },
                doctorNpcReviveAccount = {
                    description = "Primär kontonyckel som används för att ladda läkaren återupplivas.",
                    label = "Konto",
                },
                doctorNpcReviveAccountType = {
                    description = "Primär kontotyp som används för att ladda läkare återupplivar.",
                    label = "Kontotyp",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Låt NPC-läkaren återuppliva dödliga eller icke återupplivningsbara skador. En utgången förblödningstid blockerar fortfarande återupplivning.",
                    label = "Tillåt dödliga skador",
                },
                doctorNpcReviveCurrency = {
                    description = "Valfri anpassad valutanyckel som används för att ladda läkaren återupplivar.",
                    label = "Valuta",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Placera återupplivade spelare i närmaste sjukhussäng efter att en läkare återupplivat.",
                    label = "Aktiverad",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maximalt avstånd som används för att hitta en närliggande sjukhussäng för läkare återupplivas.",
                    label = "Sökradie",
                },
                doctorNpcRevivePrice = {
                    description = "Pris för att återuppliva en spelare hos doktorn NPC.",
                    label = "Pris",
                },
                firstAidActionDurationMs = {
                    description = "Hur lång tid tar första hjälpen.",
                    label = "Åtgärdslängd ms",
                },
                firstAidAnimationDict = {
                    description = "Animationsordbok som används under första hjälpen-åtgärden.",
                    label = "Animation ordbok",
                },
                firstAidAnimationFlag = {
                    description = "TaskPlayAnim-flaggan användes under första hjälpen-åtgärden.",
                    label = "Animation flagga",
                },
                firstAidAnimationName = {
                    description = "Animationsklipp som användes under första hjälpen-åtgärden.",
                    label = "Animationens namn",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Sekunder läggs till patientens utblodningstimer efter första hjälpen.",
                    label = "Blödning förlängning sekunder",
                },
                firstAidEnabled = {
                    description = "Aktivera första hjälpen-funktionen för licensierade spelare.",
                    label = "Första hjälpen aktiverad",
                },
                firstAidLicense = {
                    description = "Ramlicensnamn som används för att validera tillgång till första hjälpen.",
                    label = "Licensnamn",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Låt ambulanspersonal ge första hjälpen-licensen.",
                    label = "Lägg till licens aktiverad",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Visa tilläggslicensåtgärden i den radiella menyn.",
                    label = "Lägg till licens radiell",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Kräv EMS-tjänst innan åtgärden tilläggslicens kan användas.",
                    label = "Lägg till licens kräver plikt",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Låt ambulanspersonal ta bort första hjälpen-licensen.",
                    label = "Ta bort licens aktiverad",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Visa borttagningslicensåtgärden i den radiella menyn.",
                    label = "Ta bort licens radial",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Kräv EMS-tjänst innan åtgärden för borttagning av licens kan användas.",
                    label = "Ta bort licens kräver plikt",
                },
                firstAidPositionChestOffset = {
                    description = "Bröstförskjutning används vid inriktning för första hjälpen.",
                    label = "Bröstförskjutning",
                },
                firstAidPositionSideOffset = {
                    description = "Sidoförskjutning används vid justering för första hjälpen.",
                    label = "Sidoförskjutning",
                },
                firstAidPositionZOffset = {
                    description = "Vertikal offset används vid justering för första hjälpen.",
                    label = "Z-förskjutning",
                },
                firstAidRequireLicense = {
                    description = "Kräv den konfigurerade första hjälpen-licensen innan en spelare kan använda första hjälpen.",
                    label = "Kräver licens",
                },
                firstAidTargetDistance = {
                    description = "Maximalt tillåtet avstånd för användning av första hjälpen.",
                    label = "Målavstånd",
                },
                healthInsuranceAccount = {
                    description = "Reservkontonyckel som används för försäkringsbetalningar.",
                    label = "Konto",
                },
                healthInsuranceAccountType = {
                    description = "Primär kontotyp som används för försäkringsbetalningar.",
                    label = "Kontotyp",
                },
                healthInsuranceAvailableDays = {
                    description = "Tillgängliga försäkringstider i dagar.",
                    label = "Tillgängliga dagar",
                },
                healthInsuranceCommand = {
                    description = "Chat-kommandot används för att öppna sjukförsäkringens användargränssnitt.",
                    label = "Kommando",
                },
                healthInsuranceCurrency = {
                    description = "Valfri anpassad valutanyckel som används för försäkringsbetalningar.",
                    label = "Valuta",
                },
                healthInsuranceEnabled = {
                    description = "Aktivera sjukförsäkringssystemet.",
                    label = "Aktiverad",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Tillåter behöriga anställda att ändra försäkringspriser i surfplattan. Inaktivera för att använda priserna från leverantörstabellen nedan.",
                    label = "Prishantering i surfplattan",
                },
                healthInsuranceProviders = {
                    description = "Försäkringsleverantörer erbjuds spelare.",
                    itemLabel = "Leverantör",
                    label = "Leverantörer",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Använder samma leverantörer och försäkringar för alla jobb som är registrerade i denna ambulansresurs.",
                    label = "Dela mellan ambulansjobb",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Animeringsordbok i loop medan spelaren ligger på sängen. Lämna tomt om du vill använda standardfallet för dödsanimering.",
                    label = "Animation ordbok",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Valfri manuell varaktighet för looping bed-animationen. Används endast när en anpassad sänganimation är konfigurerad.",
                    label = "Varaktighet ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim-flagga som används för looping bed-animationen. Används endast när en anpassad sänganimation är konfigurerad.",
                    label = "Animation flagga",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animationsklipp spelas i loop medan spelaren ligger på sängen. Lämna tomt om du vill använda standardfallet för dödsanimering.",
                    label = "Animationens namn",
                },
                hospitalBedsBreakDistance = {
                    description = "Avstånd efter vilket spelaren tvingas av sängen.",
                    label = "Pausavstånd",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Förhandsgranska ped-modell som används i redigeraren för sjukhussängposition.",
                    label = "Creator ped modell",
                },
                hospitalBedsEnabled = {
                    description = "Aktivera konfigurerade sjukhussänginteraktioner.",
                    label = "Aktiverad",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Animationsordbok spelas upp när spelaren reser sig från sängen. Lämna tomt för att använda standarduppställningsbeteendet.",
                    label = "Animation ordbok",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Valfri manuell varaktighet för uppstartsanimationen. Används endast när en anpassad uppstartsanimation är konfigurerad.",
                    label = "Varaktighet ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "TaskPlayAnim-flagga som används för uppstartsanimeringen. Används endast när en anpassad uppstartsanimation är konfigurerad.",
                    label = "Animation flagga",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animationsklipp spelas upp när spelaren reser sig från sängen. Lämna tomt för att använda standarduppställningsbeteendet.",
                    label = "Animationens namn",
                },
                hospitalBedsHeadingOffset = {
                    description = "Kursförskjutning tillämpas när spelaren placeras på sängen.",
                    label = "Kursförskjutning",
                },
                hospitalBedsHeightOffset = {
                    description = "Vertikal offset tillämpas när spelaren placeras på sängen.",
                    label = "Höjdförskjutning",
                },
                hospitalBedsInteractDistance = {
                    description = "Maximalt avstånd som krävs för att använda en sjukhussäng.",
                    label = "Interagera avstånd",
                },
                hospitalBedsInteractKey = {
                    description = "Kontroll-ID som används för att gå in i eller lämna en sjukhussäng.",
                    label = "Interagera nyckel",
                },
                hospitalBedsModels = {
                    description = "Världsobjektmodeller behandlade som användbara sjukhussängar.",
                    itemLabel = "Modell",
                    label = "Sängmodeller",
                },
                hospitalBedsSearchRadius = {
                    description = "Radie används för att hitta närliggande sängstöd eller konfigurerade sängar.",
                    label = "Sökradie",
                },
                hospitalBlipColor = {
                    description = "Blip färg-ID som används för sjukhuskarta blips.",
                    label = "Färg",
                },
                hospitalBlipEnabled = {
                    description = "Visa sjukhuskarta för konfigurerade sjukhuspositioner.",
                    label = "Aktiverad",
                },
                hospitalBlipName = {
                    description = "Reservnamn för sjukhusblip används när inget stationsnamn är tillgängligt.",
                    label = "Namn",
                },
                hospitalBlipScale = {
                    description = "Blip-skala som används för sjukhuskartablips.",
                    label = "Skala",
                },
                hospitalBlipSprite = {
                    description = "Blip sprite ID används för sjukhuskarta blips.",
                    label = "Räkor",
                },
                imagingInteractionRange = {
                    description = "Maximalt avstånd från bildstationen för operatören.",
                    label = "Interaktionsintervall",
                },
                imagingPatientRange = {
                    description = "Maximalt avstånd från avbildningsstationen för patienten.",
                    label = "Patientutbud",
                },
                imagingScanDurationSeconds = {
                    description = "Varaktighet i sekunder för CT- och MR-skanningsresultat.",
                    label = "Skanningens varaktighet",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Enbart visuell multiplikator för blödande överlagringseffekter.",
                    label = "Blödande överlagringsintensitet",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Enbart visuell multiplikator för smärtskärmseffekter.",
                    label = "Smärtskärmens intensitet",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Minsta procent av max hälsa förloras i en enda träff innan blödning och smärta appliceras.",
                    label = "Blödning/smärta min procent",
                },
                injuryThresholdRespectArmor = {
                    description = "Hoppa över blödningar och smärta när träffen absorberades av rustning.",
                    label = "Respektera rustning",
                },
                knockoutRegenerateDamage = {
                    description = "Återskapa knockout-skador efter att återuppbyggnadstimern har löpt ut.",
                    label = "Återskapa skador",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Sekunder över vilka knockout-skador läkts tillbaka.",
                    label = "Regenereringstid",
                },
                knockoutRespawnSeconds = {
                    description = "Sekunder innan en automatisk respawn när en spelare slås ut.",
                    label = "Respawn sekunder",
                },
                knockoutWeapons = {
                    description = "Vapennamn eller hash som borde utlösa knockout istället för hela dödsskärmen.",
                    itemLabel = "Vapen",
                    label = "Vapen",
                },
                legShotRagdollChance = {
                    description = "Procentuell chans att en giltig traff utloser ragdoll.",
                    label = "Chans",
                },
                legShotRagdollCooldownMs = {
                    description = "Minsta forsening mellan benskott-ragdolls.",
                    label = "Avkylning ms",
                },
                legShotRagdollDebug = {
                    description = "Loggar ragdoll-beslut for testning.",
                    label = "Felsökning",
                },
                legShotRagdollDurationMs = {
                    description = "Hur lange ragdollen varar.",
                    label = "Varaktighet ms",
                },
                legShotRagdollFeet = {
                    description = "Tillat att traeffar i fotterna utloser ragdoll.",
                    label = "Fotter",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Hoppa over ragdoll om rustningen absorberade traeffen.",
                    label = "Ignorera rustningstraeffar",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Tillat traeffar i vanster underben.",
                    label = "Vanster underben",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Tillat traeffar i vanster lar.",
                    label = "Vanster lar",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Endast skott far utlosa ragdoll.",
                    label = "Endast skott",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Tillat traeffar i hoger underben.",
                    label = "Hoger underben",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Tillat traeffar i hoger lar.",
                    label = "Hoger lar",
                },
                liveDamageFracturesChance = {
                    description = "Baschans att en medveten skada träffar rullar en fraktur.",
                    label = "Chans",
                },
                liveDamageFracturesEnabled = {
                    description = "Låt medvetna skador träffar rullfrakturer.",
                    label = "Aktiverad",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Minsta procent av maximal hälsa som måste förloras i en träff innan en fraktur kan uppstå.",
                    label = "Minsta skadeprocent",
                },
                liveDamageFracturesZones = {
                    description = "Per-zon sprickor risk för levande skada.",
                    label = "Zonchanser",
                },
                liveOpenWoundStacksDefault = {
                    description = "Max antal oppna sar-staplar per zon utan zon-override.",
                    label = "Standardgrans",
                },
                liveOpenWoundStacksZones = {
                    description = "Valfria gransar for oppna sar-staplar per zon.",
                    itemLabel = "Zon",
                    label = "Zongranser",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Initial blödningsklass tillämpas per levande skadeorsak.",
                    label = "Levande sårblödningsklass",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Tillåt bäraren att gå in i och köra ett fordon utan att släppa patienten.",
                    label = "Tillåt bärare i fordon",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Tillåt bärande medvetna spelare.",
                    label = "Tillåt medvetna mål",
                },
                medicCarryAllowSprint = {
                    description = "Tillåt sprint medan du bär en patient.",
                    label = "Tillåt sprint",
                },
                medicCarryAttachBone = {
                    description = "Benindex som används för att fästa den burna spelaren.",
                    label = "Fäst ben",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Bär fäst stigningsrotation.",
                    label = "Tonhöjd",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Bär fästa rullen rotation.",
                    label = "Rulla",
                },
                medicCarryAttachOffsetsX = {
                    description = "Bär fäst X offset.",
                    label = "Förskjutning X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Bär fäst Y-offset.",
                    label = "Förskjutning Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Bär fäst girrotation.",
                    label = "Gira",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Bär fäst Z offset.",
                    label = "Förskjutning Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Animationsordbok som används av läkaren när han bär en patient.",
                    label = "Animation ordbok",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "TaskPlayAnim-flaggan som används av medic carry-animationen.",
                    label = "Animation flagga",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animationsklipp som används av läkaren när han bär en patient.",
                    label = "Animationens namn",
                },
                medicCarryEnabled = {
                    description = "Aktivera medic carry-systemet.",
                    label = "Aktiverad",
                },
                medicCarryMaxDistance = {
                    description = "Maximalt avstånd som krävs för att hämta en patient.",
                    label = "Max avstånd",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Animationsordbok som används av den burna patienten.",
                    label = "Animation ordbok",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "TaskPlayAnim-flagga som används av patientanimeringen.",
                    label = "Animation flagga",
                },
                medicCarryPassengerAnimationName = {
                    description = "Animationsklipp som används av den burna patienten.",
                    label = "Animationens namn",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Använd dödsanimationen igen efter att ha tappat en medvetslös patient.",
                    label = "Använd dödsanimationen igen",
                },
                medicCarryRequireOnDuty = {
                    description = "Endast jourhavande sjukvårdare kan starta en bärare.",
                    label = "Kräv i tjänst",
                },
                medicReviveAllowFatalWounds = {
                    description = "Låt tjänstgörande sjukvårdare behandla och återuppliva dödliga eller icke återupplivningsbara skador. En utgången förblödningstid blockerar fortfarande återupplivning.",
                    label = "Tillåt dödliga skador",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Behåll olösta skador efter behandling eller checklista återupplivas.",
                    label = "Behåll skador",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Håll smärtvärdena efter behandling eller checklista återupplivas när skador bevaras.",
                    label = "Behåll smärta",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximalt avstånd används för att lista närliggande spelare när du skapar en medicinsk utvärdering.",
                    label = "I närheten av patientområde",
                },
                medicalEvaluationRecipientJobs = {
                    description = "yrken för vilka medicinska utvärderingar kan utfärdas och delas.",
                    label = "Mottagaryrken",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Tillåt de mottagande yrkena att se patientens födelsedatum.",
                    label = "Födelsedatum",
                },
                medicalEvaluationShareConclusion = {
                    description = "Låt de mottagande yrkena se den medicinska slutsatsen.",
                    label = "Gemensam slutsats",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Ge de mottagande yrkena möjlighet att se vilka utvärderingstyper som har genomförts.",
                    label = "Typer av bedömning av aktier",
                },
                medicalEvaluationShareFullName = {
                    description = "Tillåt mottagande yrken att se patientens fullständiga namn.",
                    label = "Dela hela namnet",
                },
                medicalEvaluationShareGender = {
                    description = "Tillåt mottagande yrken att se patientens kön.",
                    label = "Dela kön",
                },
                medicalEvaluationShareHeight = {
                    description = "Tillåt mottagande yrken att se patientens längd.",
                    label = "Dela höjd",
                },
                medicalEvaluationShareHobbies = {
                    description = "Tillåt mottagande yrken att se patientens fritidsaktiviteter och hobbyer.",
                    label = "Dela fritid och hobbyer",
                },
                medicalEvaluationShareIssuer = {
                    description = "Visa författarens namn. Det utfärdande jobbet visas alltid som en mapp bland delade dokument.",
                    label = "Dela författaruppgifter",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Tillåt mottagande yrken att se patientens personliga ID.",
                    label = "Dela personligt ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Tillåt mottagande yrkesutövare att se patientens yrke.",
                    label = "Dela yrke",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Tillåt de mottagande yrkena att se frågeformulärsfrågor och inspelade svar.",
                    label = "Dela frågor och svar",
                },
                medicalEvaluationShareResult = {
                    description = "Tillåt mottagande yrken att se om utvärderingen är pågående, godkänd eller underkänd.",
                    label = "Resultat av aktien",
                },
                medicalEvaluationShareWeight = {
                    description = "Låt de mottagande yrkena se patientens vikt.",
                    label = "Andelsvikt",
                },
                medicalEvaluationTypes = {
                    description = "Anpassa utvärderingstyper, frågor, svarstyper och om varje fråga är aktiv.",
                    label = "Utvärderingstyper och frågeformulär",
                    options = {
                        boolean = "Ja / Nej",
                        boolean_text = "Ja / Nej med detaljer",
                        date = "Datum",
                        multi_select = "Flera val",
                        number = "Antal",
                        rating = "Betyg",
                        select = "Ett enda val",
                        text = "Texttext",
                        textarea = "Textområde",
                        time = "Tid",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Aktivera medicinska utvärderingar i ambulanstabletten.",
                    label = "Aktiverad",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Erbjuder en permanent tid som förblir aktiv tills en sjukvårdare tar bort hjälpmedlet.",
                    label = "Tillåt tills borttaget",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Förhindrar närstridsattacker när armgips används.",
                    label = "Inaktivera närstrid",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Tvingar obeväpnat läge och förhindrar vapenbyte när armgips används.",
                    label = "Inaktivera vapen",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Tillämpar stridsbegränsningar när armgips används.",
                    label = "Aktiverat",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Behandlar den matchande frakturen när gips eller en skena appliceras.",
                    label = "Frakturkoppling",
                },
                medicalWearablesCastsEnabled = {
                    description = "Tillåter gips på vänster och höger arm och ben.",
                    label = "Aktiverat",
                },
                medicalWearablesCastsItem = {
                    description = "Föremål från inventariet som förbrukas när gips appliceras.",
                    label = "Föremål",
                },
                medicalWearablesCastsMinigame = {
                    description = "Befintligt behandlingsminispel som används för gips.",
                    label = "Minispel",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Standardtid för det medicinska hjälpmedlet i minuter. Ange 0 för tills borttaget.",
                    label = "Standardminuter",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Tidsval för medicinska hjälpmedel som visas för sjukvårdare, i minuter.",
                    label = "Tidsalternativ",
                },
                medicalWearablesEnabled = {
                    description = "Aktiverar modeller för gips, skenor, förband, nackkragar och syrgasmasker i behandlingsgränssnittet.",
                    label = "Aktiverat",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Hur ofta utgångna tidsbegränsade medicinska hjälpmedel tas bort.",
                    label = "Utgångskontroll (sekunder)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Tillåter modellen för huvudförband.",
                    label = "Aktiverat",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Föremål från inventariet som förbrukas för ett huvudförband.",
                    label = "Föremål",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Befintligt behandlingsminispel som används för huvudförband.",
                    label = "Minispel",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Förhindrar hopp när bengips används.",
                    label = "Inaktivera hopp",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Förhindrar sprint när bengips används.",
                    label = "Inaktivera sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Tvingar animationerna för skadad rörelse när bengips används.",
                    label = "Tvinga skadad gång",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Åsidosätter rörelsehastigheten när bengips används.",
                    label = "Rörelsehastighet",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Tillämpar rörelsebegränsningar när bengips används.",
                    label = "Aktiverat",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Tillåter modellen för nackkrage.",
                    label = "Aktiverat",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Föremål från inventariet som förbrukas för en nackkrage.",
                    label = "Föremål",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Befintligt behandlingsminispel som används för nackkrage.",
                    label = "Minispel",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Tillåter modellen för syrgasmask.",
                    label = "Aktiverat",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Föremål från inventariet som förbrukas för en syrgasmask.",
                    label = "Föremål",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Befintligt behandlingsminispel som används för syrgasmask.",
                    label = "Minispel",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Visar patienten aktiva medicinska hjälpmedel och återstående användningstid.",
                    label = "Aktiverat",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Väljer var patientens HUD för medicinska hjälpmedel visas.",
                    label = "Placera",
                    options = {
                        ["bottom-center"] = "Nederst i mitten",
                        ["bottom-left"] = "Nederst till vänster",
                        ["bottom-right"] = "Nederst till höger",
                        center = "Mitten",
                        ["center-left"] = "Mitten till vänster",
                        ["center-right"] = "Mitten till höger",
                        ["top-center"] = "Överst i mitten",
                        ["top-left"] = "Överst till vänster",
                        ["top-right"] = "Överst till höger",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Återställer tidsbegränsade gips, skenor, nackkragar och bröstkorgsförband efter återanslutning och omstart av resursen.",
                    label = "Beständighet för medicinska hjälpmedel",
                },
                medicalWearablesRemoval = {
                    description = "Låter sjukvårdare ta bort aktiva gips, skenor, nackkragar och bröstkorgsförband i behandlingsgränssnittet.",
                    label = "Borttagning av sjukvårdare",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Visar borttagning av medicinska hjälpmedel med det konfigurerade verktyget i behandlingsgränssnittet.",
                    label = "Borttagningsbehandling aktiverad",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Återanvändbart verktyg från inventariet som krävs för att ta bort ett medicinskt hjälpmedel.",
                    label = "Föremål",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minispel vid borttagning av medicinska hjälpmedel (standard: cast_saw).",
                    label = "Minispel",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Tillåter armskenor med slynga på vänster och höger arm.",
                    label = "Aktiverat",
                },
                medicalWearablesSplintsItem = {
                    description = "Föremål från inventariet som förbrukas när en skena appliceras.",
                    label = "Föremål",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Befintligt behandlingsminispel som används för skenor.",
                    label = "Minispel",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Tillåter modellen för bröstkorgsförband.",
                    label = "Aktiverat",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Föremål från inventariet som förbrukas för ett bröstkorgsförband.",
                    label = "Föremål",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Befintligt behandlingsminispel som används för bröstkorgsförband.",
                    label = "Minispel",
                },
                medicationsProfiles = {
                    description = "Deklarativa läkemedelsposter som används för behandling och självmedicinering.",
                    itemLabel = "Medicin",
                    label = "Mediciner",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Aktivera minispelet påseventilmask.",
                    label = "Väskventilmask",
                },
                minigamesCastSawEnabled = {
                    description = "Aktiverar gipssågsminispelet för att ta bort medicinska hjälpmedel.",
                    label = "Gipssåg",
                },
                minigamesBandageWrapEnabled = {
                    description = "Aktivera bandage wrap-minispelet.",
                    label = "Bandageomslag",
                },
                minigamesBloodPressureEnabled = {
                    description = "Aktivera blodtrycksminispelet.",
                    label = "Blodtryck",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Aktivera minispelet för blodtransfusion.",
                    label = "Blodtransfusion",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Aktivera kulutvinningsminispelet.",
                    label = "Kulutvinning",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Andning krävs under varje ventilationsfas.",
                    label = "Andetag per cykel",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Sekunder för att slutföra en kompressionsuppsättning.",
                    label = "Kompressionslängd per set",
                },
                minigamesCprCompressionWindow = {
                    description = "Tillåten offset när du slår ett kompressionsslag.",
                    label = "Kompressionsfönster",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Aktivera minispelstadiet HLR-kompressioner.",
                    label = "HLR-kompressioner",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Antal kompressioner per set.",
                    label = "Kompressioner per set",
                },
                minigamesCprCycles = {
                    description = "Hur många HLR-cykler behövs för att avsluta minispelet.",
                    label = "Cyklar",
                },
                minigamesCprEnabled = {
                    description = "Aktivera HLR-minispelet.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Nedräkning innan HLR-kompressioner startar.",
                    label = "Intro fördröjning sekunder",
                },
                minigamesCprMaxMisses = {
                    description = "Missar tillåtna innan HLR-minispelet misslyckades.",
                    label = "Max missar",
                },
                minigamesCprSetsPerCycle = {
                    description = "Hur många kompressionsset körs före ett andetag.",
                    label = "Set per cykel",
                },
                minigamesCprVentilationEnabled = {
                    description = "Aktivera minispelstadiet för HLR-ventilation.",
                    label = "HLR Ventilation",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Aktivera glukosmätaren minispel.",
                    label = "Glukosmätare",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Aktivera minispelet för pulsmätning.",
                    label = "Pulsmätning",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Aktivera minispelet med pulsoximetern.",
                    label = "Pulsoximeter",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Aktivera minispelet med saltlösningsinfusion.",
                    label = "Infusion av saltlösning",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Sekunder innan ett ventilationsförsök tar slut. Ställ in 0 för att inaktivera.",
                    label = "Andningstimeout sekunder",
                },
                minigamesVentilationEnabled = {
                    description = "Aktivera ventilationsminispelet.",
                    label = "Ventilation",
                },
                minigamesVentilationTolerance = {
                    description = "Pixelavståndstolerans vid spårning av luftflödesvågen.",
                    label = "Tolerans",
                },
                operationsBreakDistance = {
                    description = "Maximalt avstånd från deltagarna till salen innan ingreppet avbryts.",
                    label = "Avbrottsavstånd",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA-animationsordlista för kirurgen under ett riktigt ingrepp.",
                    label = "Animationsordlista för kirurg",
                },
                operationsDoctorAnimationFlag = {
                    description = "GTA-animationsflagga för kirurgen under ett riktigt ingrepp.",
                    label = "Animationsflagga för kirurg",
                },
                operationsDoctorAnimationName = {
                    description = "Animationsklipp för kirurgen under ett riktigt ingrepp.",
                    label = "Animationsnamn för kirurg",
                },
                operationsEnabled = {
                    description = "Aktiverar operationssalar och kirurgiska ingrepp.",
                    label = "Aktiverad",
                },
                operationsFadeInMs = {
                    description = "Varaktighet i millisekunder för patientens upptoning vid uppvaknande.",
                    label = "Upptoning vid uppvaknande (ms)",
                },
                operationsFadeOutMs = {
                    description = "Varaktighet i millisekunder för patientens nedtoning vid anestesi.",
                    label = "Nedtoning vid anestesi (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Längsta tid utan en giltig minispelsåtgärd innan sessionen avbryts.",
                    label = "Tidsgräns för inaktivitet (s)",
                },
                operationsInteractDistance = {
                    description = "Maximalt avstånd för att visa och använda operationssalens interaktioner.",
                    label = "Interaktionsavstånd",
                },
                operationsInteractKey = {
                    description = "Kontroll-ID för interaktion med operationsbordet och kirurgens position.",
                    label = "Interaktionsknapp",
                },
                operationsPatientAnimationDict = {
                    description = "GTA-animationsordlista för patienten under full anestesi.",
                    label = "Animationsordlista för patient",
                },
                operationsPatientAnimationFlag = {
                    description = "GTA-animationsflagga för patientens liggande animation.",
                    label = "Animationsflagga för patient",
                },
                operationsPatientAnimationName = {
                    description = "Animationsklipp för patienten under full anestesi.",
                    label = "Animationsnamn för patient",
                },
                operationsPatientRange = {
                    description = "Maximal räckvidd för att upptäcka en patient på operationsbordet.",
                    label = "Patienträckvidd",
                },
                operationsRequireOnDuty = {
                    description = "Kräver att kirurgen är i tjänst innan en operationssal används.",
                    label = "Kräv tjänstgöring",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Längsta tid som kirurgen får stanna i operationsvalet innan sessionen avbryts.",
                    label = "Tidsgräns för val (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA-animationsordlista för kirurgisk träning utan patient.",
                    label = "Animationsordlista för träning",
                },
                operationsTrainingAnimationFlag = {
                    description = "GTA-animationsflagga för den kirurgiska träningsanimationen.",
                    label = "Animationsflagga för träning",
                },
                operationsTrainingAnimationName = {
                    description = "Animationsklipp för kirurgisk träning utan patient.",
                    label = "Animationsnamn för träning",
                },
                painClassesProfiles = {
                    description = "Smärttrösklar, etiketter och efterbehandlingseffekter.",
                    label = "Smärtklasser",
                },
                painEffectsMinPainLevel = {
                    description = "Minsta smärtnivå innan smärtskärmseffekter börjar.",
                    label = "Min smärtnivå",
                },
                primaryColor = {
                    description = "Huvudfärg för EMS-gränssnittet och ambulansens jobbgrupp.",
                    label = "Grundfärg",
                },
                propPlacementConsumeItem = {
                    description = "Konsumera den matchande inventarievaran när rekvisitan placeras.",
                    label = "Konsumera föremål",
                },
                propPlacementEnabled = {
                    description = "Tillåt att konfigurerade EMS-rekvisita placeras från användbara inventarier.",
                    label = "Aktiverad",
                },
                propPlacementItemNames = {
                    description = "Mappa EMS-rekvisitamodeller till inventeringsobjektnamn för objektbaserad placering.",
                    label = "Namn på rekvisita",
                },
                propPlacementRequireOnDuty = {
                    description = "Kräv att spelaren är i tjänst innan du placerar EMS-rekvisita.",
                    label = "Kräv i tjänst",
                },
                propPlacementReturnItem = {
                    description = "Ge tillbaka det förbrukade föremålet när en placerad rekvisita tas bort.",
                    label = "Returnera objekt vid borttagning",
                },
                propPlacementVehicleAccess = {
                    description = "Tillåt trunkprops att öppna placeringsflödet istället för att endast använda föremål.",
                    label = "Tillgång till fordon",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Tillåt offentlig behandling av medvetna spelare.",
                    label = "Tillåt patienter vid medvetande",
                },
                publicTreatmentAllowedGangs = {
                    label = "Tillåtna gäng",
                    description = "Välj interna namn för gäng eller fristående organisationer. Ett matchande jobb eller gäng ger tillståndet eller undantaget. Tjänstgöring krävs endast för jobb. Valfria lägsta gänggrader. En tom lista tillåter alla grader. Föremålskraven gäller fortfarande.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Jobb som kan använda offentlig behandling utan att vara EMS.",
                    label = "Tillåtna jobb",
                },
                publicTreatmentEnabled = {
                    description = "Aktivera offentlig behandling för icke-EMS-svarare med giltig åtkomst.",
                    label = "Offentlig behandling aktiverad",
                },
                publicTreatmentInteractDistance = {
                    description = "Maximalt avstånd som krävs för att påbörja offentlig behandling.",
                    label = "Interagera avstånd",
                },
                publicTreatmentKeybind = {
                    description = "Standardinteraktionsnyckelbindning som används för offentlig behandling.",
                    label = "Keybind",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Visa behandlingsuppmaningen och aktivera dess tangent. Inaktivera detta när du använder exports eller en egen radialmeny.",
                    label = "Tangentinteraktion aktiverad",
                },
                publicTreatmentPromptDistance = {
                    description = "Avstånd som används för att visa den offentliga behandlingsuppmaningen.",
                    label = "Snabbt avstånd",
                },
                publicTreatmentRequireAllItems = {
                    description = "Kräv alla listade medicinska föremål istället för bara en.",
                    label = "Kräv alla föremål",
                },
                publicTreatmentRequiredItems = {
                    description = "Inventeringsartiklar som räknas som giltig offentlig behandlingsutrustning.",
                    itemLabel = "Punkt",
                    label = "Obligatoriska föremål",
                },
                reviveRewardAccount = {
                    description = "Primär kontonyckel som används för att återuppliva belöningsbetalningar.",
                    label = "Konto",
                },
                reviveRewardAccountType = {
                    description = "Primär kontotyp som används för att återuppliva belöningsbetalningar.",
                    label = "Kontotyp",
                },
                reviveRewardAmount = {
                    description = "Belöningsbelopp som betalas till läkaren för en återupplivning.",
                    label = "Belopp",
                },
                reviveRewardCurrency = {
                    description = "Valfri anpassad valutanyckel som används för att återuppliva belöningsbetalningar.",
                    label = "Valuta",
                },
                reviveRewardEnabled = {
                    description = "Betala en konfigurerad belöning efter en framgångsrik läkarupplivning.",
                    label = "Aktiverad",
                },
                reviveRewardPayFromSociety = {
                    description = "Dra av återupplivande belöningar från det delade jobbsamhället innan du betalar läkaren.",
                    label = "Betala från samhället",
                },
                selfDiagnoseCommand = {
                    description = "Chat-kommando används för att öppna självdiagnos.",
                    label = "Kommando",
                },
                selfDiagnoseEnabled = {
                    description = "Tillåt spelare att öppna diagnostiseringsgränssnittet på sig själva.",
                    label = "Självdiagnos aktiverad",
                },
                selfDiagnoseKeybind = {
                    description = "Standardnyckelbindning används för att öppna självdiagnos.",
                    label = "Keybind",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Fördröjning innan gränssnittet för självdiagnostik öppnas.",
                    label = "Öppen fördröjning ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Begränsa självdiagnos till endast läkarjobb.",
                    label = "Kräver läkarjobb",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Frys inte spelaren under självdiagnostik.",
                    label = "Skippa frysning på sig själv",
                },
                statusEffectsProfiles = {
                    description = "Konfigurerade skärmeffekter och trösklar för blödning, lågt blodvärde, hunger och törst.",
                    label = "Statuseffekter",
                },
                stretcherAnimDict = {
                    description = "Animationsordbok som används när du bär båren.",
                    label = "Animation dikt",
                },
                stretcherAnimName = {
                    description = "Animationsnamn som används när du bär båren.",
                    label = "Animationens namn",
                },
                stretcherAttachRx = {
                    description = "Bär fäst X-rotation för båren.",
                    label = "Fäst RX",
                },
                stretcherAttachRy = {
                    description = "Bär fäst Y-rotation för båren.",
                    label = "Fäst RY",
                },
                stretcherAttachRz = {
                    description = "Bär fäst Z-rotation för båren.",
                    label = "Fäst RZ",
                },
                stretcherAttachX = {
                    description = "Bär fäst X-offset för båren.",
                    label = "Bifoga X",
                },
                stretcherAttachY = {
                    description = "Bär fäst Y-offset för båren.",
                    label = "Fäst Y",
                },
                stretcherAttachZ = {
                    description = "Bär fäst Z-offset för båren.",
                    label = "Fäst Z",
                },
                stretcherFoldedEnabled = {
                    description = "Aktivera den valfria hopfällda bårvarianten inuti fordon.",
                    label = "Vikt aktiverat",
                },
                stretcherFoldedModel = {
                    description = "Stödmodell som används för den hopfällda bårvarianten.",
                    label = "Vikt modell",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Patientrubrik används för den vikta bårvarianten.",
                    label = "Vikt patienthuvud",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Patient fäst X-offset för den vikta båren.",
                    label = "Vik patient X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Patientfäste Y-offset för den vikta båren.",
                    label = "Vik patient Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Patientfäst Z-offset för den vikta båren.",
                    label = "Vik patient Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Interaktionsavståndsöverstyrning används för helikoptrar.",
                    label = "Helikopter interagerar avstånd",
                },
                stretcherHelicopterModels = {
                    description = "Fordonsmodeller behandlade som bårhelikoptrar.",
                    itemLabel = "Modell",
                    label = "Helikoptermodeller",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Åsidosättande av upphämtningsavstånd används för helikoptrar.",
                    label = "Helikopterupphämtningsavstånd",
                },
                stretcherInteractDistance = {
                    description = "Maximalt avstånd för interaktionsuppmaningar med bår.",
                    label = "Interagera avstånd",
                },
                stretcherItemEnabled = {
                    description = "Aktivera bårföremålet i inventariet, inklusive köp i butiken och användning.",
                    label = "Bårföremål",
                },
                stretcherItemPickupEnabled = {
                    description = "Tillåt att bårar som placerats från inventarieföremålet återförs till inventariet.",
                    label = "Föremålsupptagning",
                },
                stretcherModel = {
                    description = "Primär bårstödsmodell som används av EMS bårsystem.",
                    label = "Modell",
                },
                stretcherPatientAnimationDict = {
                    description = "Animationsordbok för patienter på båren och förhandsvisningens NPC.",
                    label = "Patientens animationsordbok",
                },
                stretcherPatientAnimationName = {
                    description = "Animationsklipp för patienter på båren och förhandsvisningens NPC.",
                    label = "Patientens animationsnamn",
                },
                stretcherPatientAttachHeading = {
                    description = "Patientrubriken används liggandes på båren.",
                    label = "Patient rubrik",
                },
                stretcherPatientAttachX = {
                    description = "Patient fäst X förskjutning på båren.",
                    label = "Patient X",
                },
                stretcherPatientAttachY = {
                    description = "Patientfäst Y-förskjutning på båren.",
                    label = "Patient Y",
                },
                stretcherPatientAttachZ = {
                    description = "Patienten fäster Z-förskjutningen på båren.",
                    label = "Patienter Z",
                },
                stretcherPickupDistance = {
                    description = "Avstånd som krävs för att plocka upp och interagera med båren.",
                    label = "Upphämtningsavstånd",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animationsklipp som används när en patient behandlas på en bår. Lämna tomt om du vill använda ett scenario eller behandlingsanimeringen.",
                    label = "Animationens namn",
                },
                stretcherTreatmentAnimDict = {
                    description = "Animationsordbok som används när en patient behandlas på en bår. Lämna tomt om du vill använda ett scenario eller behandlingsanimeringen.",
                    label = "Animation ordbok",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Valfritt scenario som används vid behandling av en patient på bår. Lämna tom för att använda dict + klipp eller behandlingsanimationens fallback.",
                    label = "Scenario",
                },
                stretcherVehicleAttachRx = {
                    description = "Fordonsfäste X-rotation för att lasta båren.",
                    label = "Fordon RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Fordonsfäste Y-rotation för lastning av båren.",
                    label = "Fordon RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Bilfäste Z-rotation för lastning av båren.",
                    label = "Fordon RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Fordonsfäste X offset för lastning av båren.",
                    label = "Fordon X",
                },
                stretcherVehicleAttachY = {
                    description = "Y-förskjutning för fordonsfäste för lastning av båren.",
                    label = "Fordon Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Bilfäste Z-offset för lastning av båren.",
                    label = "Fordon Z",
                },
                stretcherVehicleModels = {
                    description = "Fordonsmodeller får lasta båren.",
                    itemLabel = "Modell",
                    label = "Fordonsmodeller",
                },
                treatmentAnimClip = {
                    description = "Animationsklipp som används under behandling av en patient. Lämna tomt för att använda ett scenario istället.",
                    label = "Animationens namn",
                },
                treatmentAnimDict = {
                    description = "Animationsordbok som används vid behandling av en patient. Lämna tomt för att använda ett scenario istället.",
                    label = "Animation ordbok",
                },
                treatmentAnimScenario = {
                    description = "Scenario som används vid behandling av en patient. Lämna tomt för att använda dikt + klipp istället.",
                    label = "Scenario",
                },
                trunkPropsEnabled = {
                    label = "Fordonsföremål",
                    description = "Välj föremål vid ett tjänstefordon i närheten.",
                },
                trunkEnabled = {
                    description = "Aktivera fordonsbagagefunktionen för ambulansfordon.",
                    label = "Aktiverad",
                },
                vehicleDamageModifier = {
                    description = "Skademultiplikator tillämpas när spelaren befinner sig i ett fordon.",
                    label = "Fordonsskademodifierare",
                },
                vehicleImpactProtectionCauses = {
                    description = "Dödsorsaker som bör räknas som skyddade fordonspåkörningar.",
                    itemLabel = "Orsaka",
                    label = "Skador orsakar",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Förhindra att fordon i låg hastighet dödar spelaren.",
                    label = "Aktiverad",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Krockar under denna hastighet kan inte döda spelaren.",
                    label = "Dödlig hastighet km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Krockar med fordon vid eller över denna hastighet använder den normala dödsskadakonfigurationen.",
                    label = "Full skada hastighet km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Skador som uppstår när fordonets kollisionsskydd blockerar en dödsträff.",
                    itemLabel = "Skada",
                    label = "Skador",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Procent av max hälsa bevaras när en skyddad påverkan skulle ha dödat spelaren.",
                    label = "Överlevnad hälsa procent",
                },
                vehiclePullEnabled = {
                    description = "Möjliggöra att dra patienter från fordon.",
                    label = "Aktiverad",
                },
                vehiclePullMaxDistance = {
                    description = "Maximalt avstånd som krävs för att dra en patient från ett fordon.",
                    label = "Max avstånd",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maximalt avstånd för att tilldela en rullstol till en annan spelare.",
                    label = "Tilldela maxavstånd",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Avutrusta rullstolen automatiskt när uppdraget löper ut.",
                    label = "Auto avutrustning vid utgång",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Standardtilldelad rullstolslängd i minuter.",
                    label = "Standardvaraktighet",
                },
                wheelchairDisableSprint = {
                    description = "Blockera sprint när rullstolen är utrustad.",
                    label = "Inaktivera sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Blockera vapenanvändning medan rullstolen är utrustad.",
                    label = "Inaktivera vapen",
                },
                wheelchairExitControl = {
                    description = "Kontroll-ID används för att lämna rullstolen.",
                    label = "Utgångskontroll",
                },
                wheelchairItemName = {
                    description = "Inventeringsobjekt som används för rullstolen.",
                    label = "Objektets namn",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximalt tillåten rullstolstilldelningstid i minuter.",
                    label = "Max varaktighet",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minsta tillåtna rullstolstilldelningstid i minuter.",
                    label = "Min varaktighet",
                },
                wheelchairVehicle = {
                    description = "Fordonsmodell som används för rullstolen.",
                    label = "Fordonsmodell",
                },
                xrayInteractionRange = {
                    description = "Maximalt avstånd från röntgenstationen för operatören.",
                    label = "Interaktionsintervall",
                },
                xrayPatientRange = {
                    description = "Maximalt avstånd från röntgenstationen för patienten.",
                    label = "Patientutbud",
                },
                xrayScanDurationSeconds = {
                    description = "Varaktighet i sekunder för resultatet av röntgenskanning.",
                    label = "Skanningens varaktighet",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Kylning i sekunder mellan patient bokning försök.",
                    label = "Bokningsnedkylning",
                },
                appointmentsEnabled = {
                    description = "Aktivera patientbokning och den personliga sjukvårdskalendern.",
                    label = "Aktiverad",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maximalt antal dagar in i framtiden som patienterna kan boka.",
                    label = "Maximal förbokning",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maximalt antal aktiva framtida möten en patient får hålla.",
                    label = "Maximal tid per patient",
                },
                appointmentsMinLeadMinutes = {
                    description = "Minsta antal minuter mellan bokning och möte.",
                    label = "Minsta ledtid",
                },
                appointmentsNotificationApp = {
                    description = "Telefon app-identifierare som används för mötesmeddelanden.",
                    label = "App för anmälan",
                },
                appointmentsNotificationsEnabled = {
                    description = "Meddela patienterna i telefon när möten bokas eller ställs in.",
                    label = "Telefonunderrättelser",
                },
                appointmentsReasonMaxLength = {
                    description = "Maximalt antal tecken som godtas av utnämningsskäl.",
                    label = "Motiveringsteckengräns",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Varaktighet och rutnätsintervall för en ankomsttid i minuter.",
                    label = "Spelautomatens varaktighet",
                },
                enforceMaxHealth = {
                    description = "Håll spelaren maximal hälsa på 200. Inaktivera detta när en annan resurs hanterar maximal hälsa.",
                    label = "Verkställ 200 max hälsa",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Ytterligare ramlicenser ambulanspersonal kan ge eller ta bort i patientjournaler. Konfigurerad första hjälpen licens ingår alltid.",
                    itemLabel = "Licens",
                    label = "Ytterligare patientlicenser",
                },
                minigamesBandageWrapRandomization = {
                    description = "Randomisera gasbinda vägen riktning, form och proportioner.",
                    label = "Bandets omslagsvariation",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Randomisera den venösa vägen för blodtransfusioner.",
                    label = "Variation i tillgång till transfusioner",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Kräv flerstegs venös åtkomst innan flödeskontroll. Inaktiveras för den gamla enkla versionen.",
                    label = "Venous access-stadium",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Randomisera sårkanalens form, bredd och hinder.",
                    label = "Förändring av kulans extraktion",
                },
                stretcherVehicleAttachEditor = {
                    description = "Placera och rotera båren inuti en konfigurerad ambulans.",
                    label = "Fordonets fastsättning",
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
            warnings = {
                firstAidPublicTreatmentConflict = "Första hjälpen och offentlig behandling kan inte båda aktiveras samtidigt. Att spara inaktiverar båda.",
            },
            actions = {
                actionFailed = "Unable to save changes.",
                hideDetails = "Close",
                editPosition = "Edit",
                delete = "Delete",
                editDetails = "Edit",
                remove = "Delete",
            },
        },
    },
}
