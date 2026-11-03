JobConfigLocales["sky_ambulancejob:hu"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Orvosi értékelések",
                sharedMedicalEvaluations = "Megosztott orvosi értékelések",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Feltámasztás engedélyezése",
                        description = "Meghatározza, hogy a játékosok feltámasztásához használható-e ez az ágy.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Konfigurálj mentőállomást, kórházi ágyakat, halálrendszereket, interakciókat és alapvető funkcióbeállításokat.",
                    title = "Mentőállomás foglalkozások",
                },
            },
            dispatchActions = {
                addChannel = "Rádiócsatorna hozzáadása",
                addKeyword = "Kulcsszó hozzáadása",
                addPoi = "POI hozzáadása",
                addReporter = "Jelentő hozzáadása",
                addStatus = "FMS állapot hozzáadása",
                addVehicle = "Virtuális egység hozzáadása",
                addVehicleType = "Egység típus hozzáadása",
                currentLocation = "Jelenlegi hely használata",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Egy esemény létrehozásakor azonnal hozzárendeli a megfelelő elérhető egységeket.",
                available = "Ezen státusszal rendelkező egységek javasolhatók és hozzárendelhetők egy új eseményhez.",
                averageResponseSpeedKmh = "A megjelenített érkezési becslést a légvonalbeli távolságból számítja ki.",
                callsign = "Egyedi rádióhívóazonosító, amely akkor jelenik meg, ha játékosok betöltik ezt a virtuális egységet.",
                centerEnabled = "Lehetővé teszi a jogosult szolgálatban lévő tagok számára, hogy betöltsék a központot.",
                channelId = "Rádiócsatorna-azonosító a PMA Voice, SaltyChat és YACA számára. Számas azonosítók, például a 2500 változatlanok maradnak; a PMA Voice a szöveges azonosítókat egy stabil számra leképezi.",
                channelLabel = "Olvasható csatornanév, amely a diszpécsernek és az egységeknek jelenik meg.",
                crewCapacity = "Ennek az egységnek a személyzete számára elérhető maximális létszám. Korlátlan személyzet esetén használd a 0-át.",
                defaultChannel = "Meghatározza ennek a válaszfeladatsornak a háttér-csatornáját, ha nincs kifejezetten kiválasztva csatorna. Az egységek továbbra is manuálisan csatlakoznak. A Nincs opció a feladatsor-csoport alapértelmezett beállítását használja.",
                emergencyAppEnabled = "Megjeleníti ezt a feladatot kiválasztható közszolgáltatásként a Vészhelyzet telefonos alkalmazásban.",
                enabled = "Elérhetővé teszi ezt a feladatot a Diszpécser alkalmazásban és a feladatokon átívelő eseményeknél.",
                icon = "Válaszd ki az ikont, amely ennek az egységkategóriának a Diszpécser alkalmazásban jelenik meg.",
                incidentAssessmentEnabled = "Megjeleníti az orvosi és veszélyfelmérő kérdéseket a teljes eseményfelvétel során.",
                jobs = "További feladatnevek, amelyek ezt a kulcsszót használva kapnak eseményeket.",
                joinLocked = "Megakadályozza, hogy további személyzet csatlakozzon, miután ezt az egységet betöltötték.",
                minimumCrew = "A minimális létszám a választervhez kiválasztott egységek között.",
                noUnitFallback = "Központ vagy betöltött egység hiányában Sky értesítést küld az összes szolgálatban lévő tagnak.",
                poiId = "Stabil műszaki azonosító, amelyre a központprofilok akkor is hivatkozhatnak, ha a POI neve megváltozik.",
                radius = "A maximális távolság méterben, amelyen belül a központ bejelentése hallható.",
                readyStatusCode = "Az FMS státusz, amely akkor kerül beállításra, ha ez az erőforrás készen áll a riasztásra.",
                requirements = "A válaszigény TÍPUS:SZÁM párok formájában, például PATROL:2,CRIME:1.",
                resourceType = "Besorolja az üzemeltetési erőforrást a diszpécser szűrők és koordináció számára.",
                respondingStatusCode = "Ez az erőforrás eseményre történő válaszadásakor alkalmazott FMS-státusz.",
                shortLabel = "A hat rádiócsatorna-emlékező gombon megjelenő opcionális rövid címke.",
                stationId = "Ez az egység hozzárendelése a diszpécserközpont profiljában beállított állomáshoz.",
                statusCode = "A kézi rádión megjelenő numerikus FMS-státusz.",
                statusLabel = "Ennek az FMS-státusznak a jelentése a diszpécserek és az egységek számára.",
                unitId = "Stabil technikai azonosító, amely megőrzi ezt az egységet akkor is, ha a hívójele megváltozik.",
                vehicleType = "Meg kell egyeznie az előző részben konfigurált járműtípus-kóddal.",
                vehicleTypeCode = "Rövid egységkód, amelyet a válaszadási követelményekben használnak, például PATROL, CRIME, EMS vagy RESCUE.",
                vehicleTypeLabel = "Ennek az egységtípusnak az olvasható neve.",
            },
            dispatchFields = {
                address = "Cím",
                autoAlarm = "Automatikus riasztás",
                available = "Elérhető a diszpécser számára",
                averageResponseSpeedKmh = "Becsült válaszadási sebesség (km/h)",
                callsign = "Kódnév",
                category = "Kategória",
                centerEnabled = "Diszpécserközpont engedélyezése",
                channelId = "Csatornaazonosító",
                code = "Kód",
                crewCapacity = "Legénységkapacitás",
                defaultChannel = "Alapértelmezett rádiócsatorna",
                emergencyAppEnabled = "Megjelenítés az Emergency alkalmazásban",
                enabled = "Diszpécser engedélyezése",
                icon = "Ikon",
                incidentAssessmentEnabled = "Vészhelyzeti értékelés engedélyezése",
                jobs = "Célzott foglalkozások (vesszővel elválasztva)",
                joinLocked = "Legénység csatlakozásának zárolása",
                keywordCode = "Kulcsszavas kód",
                label = "Címke",
                minimumCrew = "Minimum legénység",
                name = "Név",
                noUnitFallback = "Értesítsd a szolgálatban lévő, egység nélküli személyzetet",
                noneChannel = "Nincs / csoport alapértelmezett",
                note = "Megjegyzés",
                phone = "Telefon",
                poiId = "Stabil POI azonosító",
                radius = "Hirdetési sugár",
                readyStatusCode = "Készenléti státusz kód",
                requirements = "Szükséges egységek (például PATROL:2,CRIME:1)",
                resourceType = "Erőforrás típusa",
                respondingStatusCode = "Válaszadási státusz kód",
                shortLabel = "Rádióemlékező címkéje",
                stationId = "Állomás azonosító",
                type = "Típus",
                unitId = "Stabil egység azonosító",
                vehicleType = "Válaszadó egység típusa",
            },
            dispatchIconOptions = {
                crime = "Bűnügyi egység",
                emergency = "Vészhelyzeti egység",
                ems = "EMS egység",
                fire = "Tűzoltó egység",
                heavy = "Nehéz egység",
                k9 = "K-9 egység",
                medical = "Orvosi egység",
                patrol = "Kiszervezés",
                rescue = "Mentő egység",
                service = "Szolgáltatási egység",
                supervisor = "Főnök egység",
                tactical = "Taktikai egység",
            },
            dispatchNavigation = {
                active = "Diszpécser aktív",
                description = "Konfigurálja a vészhelyzeti felvételt, a rádiót, az egységeket, a választerveket, a helyeket és a jelentési adatokat ehhez a munkához.",
                inactive = "Diszpécser letiltva",
                steps = {
                    accessText = "Engedélyezze a Diszpécsert, és vezérelje a nyilvános vészhelyzeti felvételt és a visszalépési viselkedést ehhez a válaszadó munkához.",
                    accessTitle = "Hozzáférés és vészhelyzeti felvétel",
                    fleetText = "Konfigurálja a csatornákat, az FMS státuszokat, a járműtípusokat és a hívóneveket.",
                    fleetTitle = "Rádió és járműflotta",
                    responseText = "Zárja le kulcsszavakkal, válaszadási követelményekkel és POI-kkal.",
                    responseTitle = "Reakcióterv",
                },
                summary = {
                    channels = "Rádiócsatornák",
                    plans = "Reakcióterv",
                    reporters = "Ismert jelentkezők",
                    statuses = "Elérhető FMS",
                    units = "Virtuális egységek",
                },
                title = "Ügyelet",
                warnings = {
                    channels = "Nincsenek egyértelmű rádiócsatornák; a munkacsoport alapértelmezett csatornája lesz használva.",
                    defaultChannel = "A kiválasztott alapértelmezett csatorna már nem létezik.",
                    disabled = "A Dispatch letiltva ehhez a munkához.",
                    statuses = "Legalább egy FMS státusznak rendelkezésre kell állnia, hogy az egységek riaszthatók legyenek.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Meghatározza a rádiócsatornákat, amelyekre az egységek és a személyzettel ellátott irányítóközpontok csatlakozhatnak.",
                dispatchKeywords = "Meghatározza a vészhelyzeti kulcsszavakat, a szükséges járműszámot, a részt vevő munkákat és az opcionális automatikus riasztást.",
                dispatchPois = "Tárolja az állomásokat és a gyakori helyeket incidensformulárokhoz és helyhez kötött állomás-hírekhez.",
                dispatchReporters = "Kezeli a munkához tartozó hívóneveket, visszahívó számokat és irányítószolgálati jegyzeteket.",
                dispatchStatusCodes = "Konfigurálja az FMS státuszfeliratokat és meghatározza, mely státuszok számítanak elérhetőnek új incidensekhez.",
                dispatchVehicleTypes = "Definiálja a beavatkozási tervben használt egységkategóriákat, például Patrólya, Bűnügyi Osztály, EMS vagy Mentés.",
                dispatchVehicles = "Definiálja a virtuális irányítószolgálati járműveket, amelyeket bárhonnan besorolhatók anélkül, hogy generálni kellene őket.",
            },
            extensions = {
                dispatchChannels = "Rádiócsatornák",
                dispatchKeywords = "Kulcsszavak és beavatkozási tervek",
                dispatchPois = "Irányítószolgálati POI-k",
                dispatchReporters = "Ismert jelentkezők",
                dispatchSettings = {
                    description = "Konfigurálja az irányítószolgálati hozzáférést, a sürgősségi fogadást és az alapértelmezett rádiócsatornát.",
                    label = "Irányítószolgálati beállítások",
                },
                dispatchStatusCodes = "Státusz kódok",
                dispatchVehicleTypes = "Irányítószolgálati járműtípusok",
                dispatchVehicles = "Irányítószolgálati flottadatok",
                emptyDescription = "Használd a fenti gombot az első bejegyzés létrehozásához.",
                emptyTitle = "Még nincs konfigurálva",
                invalidSelection = "Érvénytelen kiválasztás: {value}",
                trainingSettings = {
                    description = "Konfigurálja az oktatási hozzáférést, regisztrációt, jóváhagyásokat és tanfolyamtervezést ehhez a munkahelyhez.",
                    label = "Oktatási beállítások",
                },
            },
            features = {
                bleeding = {
                    description = "Engedélyezi a vérzéskezelő rendszert.",
                    label = "Vérzés",
                },
                bodybags = {
                    description = "Engedélyezi a holttestzsákokat és azok szállítási folyamatait.",
                    label = "Holttestzsákok",
                },
                consciousScenarioBloodPressure = {
                    description = "Engedélyezi a vérnyomásmérést, amikor a beteg éber.",
                    label = "Vérnyomás éber állapotban",
                },
                deathTimeout = {
                    description = "Engedélyezi a halál időzítő folyamatát.",
                    label = "Halál időzítő",
                },
                fractures = {
                    description = "Engedélyezi a törések kezelését.",
                    label = "Törések",
                },
                knockout = {
                    description = "Engedélyezi a knock-out rendszert.",
                    label = "Knock-out",
                },
                legShotRagdoll = {
                    description = "A játékosok esnek, ha lőttek a beállított láb- vagy lábfej-zónákba.",
                    label = "Láb-lövés ragdoll",
                },
                pain = {
                    description = "Engedélyezi a fájdalomrendszer.",
                    label = "Fájdalom",
                },
                respawnInBed = {
                    description = "Újjáélesztett játékosok újjászületése kórházi ágyon, ha elérhető.",
                    label = "Újjászületés ágyon",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Ez a munkahely csak akkor jelenik meg az Sürgősségi App-ban, ha az Irányítószolgálat engedélyezve van. Engedélyezd az Irányítószolgálatot, vagy kapcsold ki az „Mutatás az Sürgősségi App-ban” opciót az Irányítószolgálati beállításokban.",
                dispatchJobNotCovered = "Nincs engedélyezett diszpécserközpont, amely lefedné a(z) \"{job}\" munkát. A sky_jobs_base/config/config.lua fájlban add hozzá a(z) \"{job}\" értéket a coveredJobs listához a megfelelő Config.Dispatch.centers profilban, majd indítsd újra a sky_jobs_base nevű szoftver erőforrást. A beállítások alaphelyzetbe állítása nem módosítja ezt a hozzárendelést.",
                invalidDispatchChannels = "A rádiócsatorna-azonosítók egyediaknak kell lenniük, és minden csatornának érvényes feliratnak kell lennie.",
                invalidDispatchDefaultChannel = "Az alapértelmezett rádiócsatorna nem létezik. Válassz ki egy meglévő csatornát vagy a „Nincs”-t az Irányítószolgálati beállításokban.",
                invalidDispatchKeywords = "A beavatkozási terveknek egyedi kódokat és érvényes TÍPUS:SZÁM követelményeket kell tartalmazniuk.",
                invalidDispatchPois = "A POI-azonosítók, nevek és koordináták érvényesek és egyediaknak kell lenniük.",
                invalidDispatchRadioButtons = "Ellenőrizd a rádió funkciógombokat: minden támogatott gombot csak egyszer használj, és válassz ki egy műveletet a listájából.",
                invalidDispatchRadioFmsKeys = "Ellenőrizd a rádió FMS billentyűket: minden billentyűt (0-9, * vagy #) csak egyszer használj, és rendelj hozzá egy meglévő státusz kódhoz, vagy hagyd üresen.",
                invalidDispatchReadyStatus = "Válassz ki egy készenléti státusz kódot az Irányítószolgálati beállításokban, amely a Státusz kódok alatt elérhetőnek van jelölve.",
                invalidDispatchReporters = "Az ismert jelentők adatai túllépik az engedélyezett bejegyzések számát vagy a mezőhosszakat.",
                invalidDispatchRespondingStatus = "Az Irányítószolgálati beállításokban válassz ki egy olyan válaszoló státusz-kódot, amelyet a Státusz kódok alatt elérhetetlennek jelöltek.",
                invalidDispatchSettings = "Válassz egy meglévő elérhető készenléti státuszt, egy elérhetetlen válaszoló státuszt és egy érvényes alapértelmezett csatornát.",
                invalidDispatchStatusCodes = "Az FMS-kódoknak egyedieknek kell lenniük, és legalább egy státusznak elérhetőnek kell lennie.",
                invalidDispatchVehicleTypes = "Az egységtípus kódjainak egyedieknek és teljesnek kell lenniük.",
                invalidDispatchVehicles = "Az egység-azonosítók és a hívójelneveknek egyedieknek kell lenniük, továbbá minden egységtípusra és állomásra vonatkozó hivatkozásnak meg kell lennie.",
            },
            settingFields = {
                gang = "Banda",
                allowInVehicle = "Engedélyezett a járműben",
                allowMovement = "Engedélyezett a mozgás",
                animDict = "Animációs szótár",
                animFlag = "Animációs jelző",
                animName = "Animáció neve",
                bleeding = "Vérzés",
                cause = "Ok",
                chance = "Lehetőség",
                class = "Osztály",
                companyPrice = "Vállalati ár",
                companyPricePerEmployee = "Ár alkalmazottanként",
                copayPercent = "Közreterhelés %",
                description = "Leírás",
                dictionary = "Animációs szótár",
                duration = "Időtartam",
                durationMs = "Időtartam (ms)",
                effect = "Hatás",
                effectDurationMs = "Hatás időtartama (ms)",
                effectDurationSeconds = "Hatás időtartama (másodperc)",
                enabled = "Engedélyezve",
                extractionType = "Kivonás típusa",
                foreignObject = "Idegen tárgy",
                heal = "Gyógyulás",
                id = "ID",
                itemName = "Tárgy neve",
                key = "Billentyű",
                label = "Címke",
                lang = "Nyelv",
                limit = "Korlát",
                lossPerSecond = "Veszteség másodpercenként",
                max = "Maximális",
                min = "Minimális",
                minGrade = "Min. rang",
                minigame = "Minijáték",
                model = "Prop modell",
                name = "Foglalkozás neve",
                options = "Opciók (választási típusok)",
                pain = "Fájdalom",
                pauseBleedingSeconds = "Vérzés felfüggesztése (másodpercek)",
                price = "Ár",
                progressbarAllowInVehicle = "Folyamat: járműben engedélyezett",
                progressbarAllowMovement = "Folyamat: mozgás engedélyezve",
                progressbarCanCancel = "A folyamat megszakítható",
                progressbarDisableCarMovement = "Folyamat: járműmozgás letiltva",
                progressbarDisableCombat = "Folyamat: harc letiltva",
                progressbarDisableMouse = "Folyamat: egér letiltva",
                progressbarDisableMovement = "Folyamat: mozgás letiltva",
                progressbarDisableSprint = "Folyamat: szaladás letiltva",
                progressbarDuration = "Folyamat időtartama",
                progressbarEnabled = "Folyamatsáv engedélyezve",
                progressbarLabel = "Folyamatsáv felirata",
                progressbarUseWhileDead = "A folyamat használható halott állapotban is",
                questions = "Kérdések",
                requireItems = "Tárgyak szükségesek",
                required = "Kötelező",
                requiresExtraction = "Kivonás szükséges",
                requiresOpenWound = "Nyílt seb szükséges",
                sort = "Rendezés",
                state = "Állapot",
                stopBleeding = "Vérzés leállítása",
                threshold = "Küszöbérték",
                time = "Idő",
                type = "Típus",
                useAnimation = "Animáció használata",
                value = "Érték",
                zone = "Zóna",
                zones = "Zónák",
                systolic = "Szisztolés vérnyomás",
                diastolic = "Diasztolés vérnyomás",
                cardiacArrest = "Szívmegállás",
            },
            settingGroups = {
                appointmentsGeneral = {
                    label = "Általános",
                },
                appointmentsLimits = {
                    label = "Korlátok",
                },
                appointmentsNotifications = {
                    label = "Értesítések",
                },
                appointmentsScheduling = {
                    label = "Ütemezés",
                },
                billingGeneral = {
                    label = "Általános",
                },
                billingRange = {
                    label = "Hatótáv",
                },
                billingReasons = {
                    label = "Okok előzetes beállításai",
                },
                billingUi = {
                    label = "Felület",
                },
                bodyBagAnimation = {
                    label = "Animáció",
                },
                bodyBagAttachGeneral = {
                    label = "Csatolás",
                },
                bodyBagAttachOffsets = {
                    label = "Eltolások",
                },
                bodyBagAttachRotation = {
                    label = "Forgatás",
                },
                bodyBagDeliveryGeneral = {
                    label = "Általános",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Általános",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Fizetés",
                },
                bodyBagDeliveryUi = {
                    label = "Felület",
                },
                bodyBagGeneral = {
                    label = "Általános",
                },
                crutchAssign = {
                    label = "Rendezés",
                },
                crutchDuration = {
                    label = "Időtartam",
                },
                crutchGeneral = {
                    label = "Általános",
                },
                crutchItems = {
                    label = "Tárgy",
                },
                crutchRestrictions = {
                    label = "Korlátozások",
                },
                damageHandlingBladeWeapons = {
                    label = "Vágófegyverek",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Vérzés tiltólista",
                },
                damageHandlingBleedingClasses = {
                    label = "Vérzési osztályok",
                },
                damageHandlingBloodSystem = {
                    label = "Vérrendszer",
                },
                damageHandlingDeathInjuries = {
                    label = "Halálos sérülések",
                },
                damageHandlingInjuryEffects = {
                    label = "Sérülési effektek",
                },
                damageHandlingInjuryThresholds = {
                    label = "Sérülési küszöbértékek",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Lábszúrás ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Lábszúrás ragdoll zónák",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Aktív sérülés törések",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zóna esélyek",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Nyílt sebek csomagjai",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Zóna limitok",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Aktív sebek vérzési osztályai",
                },
                damageHandlingMedications = {
                    label = "Gyógyszerek",
                },
                damageHandlingPainClasses = {
                    label = "Fájdalom osztályok",
                },
                damageHandlingPainEffects = {
                    label = "Fájdalom effektek",
                },
                damageHandlingStatusEffects = {
                    label = "Állapot effektek",
                },
                damageHandlingVehicleDamage = {
                    label = "Jármű sérülések",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Sérülés okai",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Sérülések",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Járműütközés védelem",
                },
                deathAnimal = {
                    label = "Állat visszakapcsolás",
                },
                deathAnimalAnimation = {
                    label = "Állat animáció",
                },
                deathAnimation = {
                    label = "Animáció",
                },
                deathGeneral = {
                    label = "Általános",
                },
                deathModels = {
                    label = "Modell felülírások",
                },
                deathScreenAiMedic = {
                    label = "Általános",
                },
                deathScreenAiMedicAvailability = {
                    label = "Elérhetőség",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Viselkedés",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Kényszerített feltámasztás",
                },
                deathScreenAiMedicPayment = {
                    label = "Fizetés",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Feltámasztás ágyban",
                },
                deathScreenAiMedicSpawn = {
                    label = "Spawn",
                },
                deathScreenAiMedicTiming = {
                    label = "Időzítés",
                },
                deathScreenControls = {
                    label = "Vezérlés",
                },
                deathScreenDamageLogs = {
                    label = "Sérülés naplók",
                },
                deathScreenDimensions = {
                    label = "Dimenziók",
                },
                deathScreenDispatch = {
                    label = "Ügyelet",
                },
                deathScreenEarlyRespawn = {
                    label = "Általános",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Elérhetőség",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Fizetés",
                },
                deathScreenGeneral = {
                    label = "Általános",
                },
                deathScreenHospitalSelection = {
                    label = "Kórház kiválasztása",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Kiválasztás kamera",
                },
                deathScreenInformation = {
                    label = "Általános",
                },
                deathScreenIntegration = {
                    label = "Integráció",
                },
                deathScreenLogs = {
                    label = "Halálozási naplók",
                },
                deathScreenMinigame = {
                    label = "Minijáték",
                },
                deathScreenRespawn = {
                    label = "Általános",
                },
                deathScreenRespawnAccounts = {
                    label = "Fiókok",
                },
                deathScreenRespawnFallback = {
                    label = "Visszakapcsolás koordináták",
                },
                deathScreenRespawnItems = {
                    label = "Tárgyak",
                },
                deathScreenRespawnWeapons = {
                    label = "Fegyverek",
                },
                deathScreenStyle = {
                    label = "Halálképernyő stílus",
                },
                deathScreenVoice = {
                    label = "Hang",
                },
                deathTimeoutGeneral = {
                    label = "Általános",
                },
                deathTimeoutWhitelist = {
                    label = "Fehérlistás foglalkozások",
                },
                diagnoseAnim = {
                    label = "Animáció",
                },
                diagnoseCpr = {
                    label = "Szív-masszázs",
                },
                diagnoseFullHeal = {
                    label = "Teljes gyógyulás",
                },
                diagnoseGeneral = {
                    label = "Általános",
                },
                doctorNpcAvailability = {
                    label = "Elérhetőség",
                },
                doctorNpcGeneral = {
                    label = "Általános",
                },
                doctorNpcHealOther = {
                    label = "Másik gyógyítása",
                },
                doctorNpcHealSelf = {
                    label = "Öngyógyítás",
                },
                doctorNpcRanges = {
                    description = "Ezek a tartományok nem szabályozzák, hogy milyen közel kell lennie egy játékosnak ahhoz, hogy megnyissa az orvos NPC-interakciót. Csak akkor lépnek érvénybe, miután megnyílt az orvos menü.",
                    label = "Tartományok",
                },
                doctorNpcRevive = {
                    label = "Élesztés",
                },
                doctorNpcReviveInBed = {
                    label = "Feltámasztás ágyban",
                },
                firstAidAnimation = {
                    label = "Animáció",
                },
                firstAidGeneral = {
                    label = "Általános",
                },
                firstAidLicenseAdd = {
                    label = "Engedély hozzáadása",
                },
                firstAidLicenseRemove = {
                    label = "Engedély eltávolítása",
                },
                firstAidPosition = {
                    label = "Pozíció",
                },
                healthCompatibility = {
                    label = "Egészség-kompatibilitás",
                },
                healthInsuranceExpiration = {
                    label = "Lejárat",
                },
                healthInsuranceGeneral = {
                    label = "Általános",
                },
                healthInsurancePayment = {
                    label = "Fizetés",
                },
                healthInsuranceProviders = {
                    label = "Szolgáltatók",
                },
                hospitalBedsBedAnimation = {
                    label = "Ágy animáció",
                },
                hospitalBedsCreator = {
                    label = "Készítő",
                },
                hospitalBedsDistances = {
                    label = "Távolságok",
                },
                hospitalBedsGeneral = {
                    label = "Általános",
                },
                hospitalBedsGetupAnimation = {
                    label = "Felszállás animáció",
                },
                hospitalBedsModels = {
                    label = "Modellek",
                },
                hospitalBedsOffsets = {
                    label = "Eltolások",
                },
                hospitalBlip = {
                    label = "Kórház jelző",
                },
                imagingGeneral = {
                    label = "Általános",
                },
                imagingRanges = {
                    label = "Tartományok",
                },
                keybinds = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Billentyűzések",
                },
                knockoutGeneral = {
                    label = "Általános",
                },
                knockoutWeapons = {
                    label = "Fegyverek",
                },
                medicCarryAttach = {
                    label = "Csatolás",
                },
                medicCarryAttachOffsets = {
                    label = "Eltolások",
                },
                medicCarryAttachRotation = {
                    label = "Forgatás",
                },
                medicCarryCarrierAnimation = {
                    label = "Hordozás animáció",
                },
                medicCarryGeneral = {
                    label = "Általános",
                },
                medicCarryPassengerAnimation = {
                    label = "Utast animáció",
                },
                medicCarryRestrictions = {
                    label = "Korlátozások",
                },
                medicRevivePersistence = {
                    label = "Általános",
                },
                medicalEvaluationRecipients = {
                    label = "Célpontok",
                },
                medicalEvaluationSharing = {
                    label = "Megosztott mezők",
                },
                medicalEvaluationTypes = {
                    label = "Értékelési típusok",
                },
                medicalEvaluationsGeneral = {
                    label = "Általános",
                },
                medicalWearablesArmRestrictions = {
                    label = "Karcsontorlási korlátozások",
                },
                medicalWearablesCasts = {
                    label = "Gipszok",
                },
                medicalWearablesDuration = {
                    label = "Hordozási időtartam",
                },
                medicalWearablesGeneral = {
                    label = "Általános",
                },
                medicalWearablesHeadBandage = {
                    label = "Fej kötés",
                },
                medicalWearablesLegRestrictions = {
                    label = "Lábszár csonttörési korlátozások",
                },
                medicalWearablesNeckBrace = {
                    label = "Nyakfűző",
                },
                medicalWearablesOxygenMask = {
                    label = "Oxigénmaszk",
                },
                medicalWearablesPatientHud = {
                    label = "Páciens HUD",
                },
                medicalWearablesRemoval = {
                    label = "Eltávolítás",
                },
                medicalWearablesSplints = {
                    label = "Csonttörési rögzítők",
                },
                medicalWearablesTorsoBandage = {
                    label = "Törzs kötés",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Általános",
                },
                minigamesCprGeneral = {
                    label = "Általános",
                },
                minigamesEnabled = {
                    label = "Engedélyezve",
                },
                minigamesRandomization = {
                    label = "Véletlenszerűsítés",
                },
                minigamesVentilationGeneral = {
                    label = "Általános",
                },
                operationsAnesthesia = {
                    label = "Aneszteziás",
                },
                operationsDistances = {
                    label = "Távolságok",
                },
                operationsDoctorAnimation = {
                    label = "Orvos animáció",
                },
                operationsGeneral = {
                    label = "Általános",
                },
                operationsPatientAnimation = {
                    label = "Páciens animáció",
                },
                operationsTrainingAnimation = {
                    label = "Tréning animáció",
                },
                propPlacement = {
                    label = "Prop elhelyezése",
                },
                propPlacementItems = {
                    label = "Prop tárgyak",
                },
                publicTreatmentGeneral = {
                    label = "Általános",
                },
                publicTreatmentJobs = {
                    label = "Engedélyezett foglalkozások",
                },
                publicTreatmentRequirements = {
                    label = "Követelmények",
                },
                reviveRewardGeneral = {
                    label = "Általános",
                },
                reviveRewardPayment = {
                    label = "Fizetés",
                },
                selfDiagnoseGeneral = {
                    label = "Általános",
                },
                stretcherAnimation = {
                    label = "Animáció",
                },
                stretcherCarryAttach = {
                    label = "Hordozás csatlakoztatása",
                },
                stretcherFolded = {
                    label = "Behajtott változat",
                },
                stretcherFoldedPatientAttach = {
                    label = "Behajtott páciens csatlakoztatása",
                },
                stretcherGeneral = {
                    label = "Általános",
                },
                stretcherHelicopter = {
                    label = "Helikopter",
                },
                stretcherPatientAttach = {
                    label = "Páciens csatlakoztatása",
                },
                stretcherTreatmentAnim = {
                    label = "Animáció",
                },
                stretcherVehicleAttach = {
                    label = "Jármű csatlakoztatása",
                },
                stretcherVehicleLists = {
                    label = "Járműmodellek",
                },
                treatmentAnim = {
                    label = "Animáció",
                },
                treatmentEnable = {
                    label = "Engedélyezés",
                },
                trunk = {
                    label = "Csomagtér",
                },
                vehiclePullGeneral = {
                    label = "Általános",
                },
                wheelchairAssign = {
                    label = "Rendezés",
                },
                wheelchairDuration = {
                    label = "Időtartam",
                },
                wheelchairGeneral = {
                    label = "Általános",
                },
                wheelchairItems = {
                    label = "Tárgy",
                },
                wheelchairRestrictions = {
                    label = "Korlátozások",
                },
                xrayGeneral = {
                    label = "Általános",
                },
                xrayRanges = {
                    label = "Tartományok",
                },
            },
            settingSections = {
                billing = "Számlázás",
                bodyBag = "Holttestzsák",
                damageHandling = "Sérülések kezelése",
                death = "Halál",
                deathScreen = "Halálképernyő",
                diagnose = "Diagnosztika",
                doctorNpc = "Orvosi NPC",
                general = "Általános",
                healthInsurance = "Egészségbiztosítás",
                hospitalBeds = "Kórházi ágyak",
                knockout = "Knock-out",
                medicCarry = "Orvos által szállított",
                minigames = "Minijátékok",
                mobilityAid = "Mobilitási segédeszközök",
                operations = "Műveletek",
                organization = "Szervezet",
                rewards = "Díjak",
                treatment = "Kezelés",
                vehiclePull = "Járműhúzás",
            },
            settingSubsections = {
                aiMedic = "AI Orvos",
                anesthesia = "Aneszteziás",
                animation = "Animáció",
                animations = "Animációk",
                appointments = "Időpontok",
                attach = "Csatolás",
                bedAnimation = "Ágy animáció",
                blood = "Vér",
                bloodTransfusion = "Vérátadás",
                bodyBagDeliveryReward = "Hullaszállítási díj",
                carrierAnimation = "Hordozás animáció",
                classification = "Osztályozás",
                cpr = "Szív-masszázs",
                crutch = "Támaszbot",
                deathInjuries = "Halálos sérülések",
                deathScreenStyle = "Halálképernyő stílus",
                deathTimeout = "Halál időzítő",
                delivery = "Kézbesítés",
                diagnoseAnim = "Diagnosztikai animáció",
                dispatch = "Ügyelet",
                earlyRespawn = "Korai újjászületés",
                effects = "Effektek",
                firstAid = "Elsősegély",
                general = "Általános",
                getupAnimation = "Felszállás animáció",
                imaging = "Képalkotás",
                information = "Információ",
                keybinds = "Billentyűzések",
                liveDamage = "Élővélt sérülés",
                logs = "Naplók",
                medicRevivePersistence = "Orvosi újjáélesztés tartóssága",
                medicalEvaluations = "Orvosi értékelések",
                medicalWearables = "Orvosi viselhető eszközök",
                medications = "Gyógyszerek",
                minigame = "Minijáték",
                passengerAnimation = "Utast animáció",
                pricing = "Árazás",
                propPlacement = "Prop elhelyezése",
                publicTreatment = "Nyilvános kezelés",
                respawn = "Újjászületés",
                reviveInBed = "Feltámasztás ágyban",
                reviveReward = "Újjáélesztási díj",
                selfDiagnose = "Öndiagnosztika",
                stretcher = "Hordágy",
                stretcherTreatmentAnim = "Hordágyas kezelési animáció",
                thresholds = "Küszöbértékek",
                treatmentAnim = "Kezelési animáció",
                trunk = "Csomagtér",
                vehicleImpact = "Járműütközés",
                ventilation = "Légzésműteti ellátás",
                wheelchair = "Kerekesszék",
                xray = "Röntgen",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Szerkesztő: Felfelé",
                    description = "Konfigurálja: Szerkesztő: Felfelé.",
                },
                ambulanceEditorControl173 = {
                    label = "Szerkesztő: Lefelé",
                    description = "Konfigurálja: Szerkesztő: Lefelé.",
                },
                ambulanceEditorControl174 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BALRA",
                },
                ambulanceEditorControl175 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · JOBBRA",
                },
                ambulanceEditorControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                ambulanceEditorControl201 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                ambulanceEditorControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                ambulanceEditorControl21 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL SHIFT",
                },
                ambulanceEditorControl32 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · W",
                },
                ambulanceEditorControl33 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · S",
                },
                ambulanceEditorControl34 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · A",
                },
                ambulanceEditorControl35 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · D",
                },
                ambulanceEditorControl36 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL CTRL",
                },
                ambulanceEditorControl37 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · TAB",
                },
                ambulanceEditorControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · E",
                },
                ambulanceEditorControl44 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Q",
                },
                ambulanceFirstAidControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Elsősegély · E",
                },
                ambulanceStretcherEditorControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · Vissza",
                },
                ambulanceStretcherEditorControl201 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · Vissza",
                },
                ambulanceStretcherEditorControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · KILÉPÉS",
                },
                ambulanceStretcherEditorControl21 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · BAL SHIFT",
                },
                ambulanceStretcherEditorControl241 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · IOM_WHEEL_UP",
                },
                ambulanceStretcherEditorControl242 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · IOM_WHEEL_DOWN",
                },
                ambulanceStretcherEditorControl25 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · MOUSE_RIGHT",
                },
                ambulanceStretcherEditorControl32 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · W",
                },
                ambulanceStretcherEditorControl33 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · S",
                },
                ambulanceStretcherEditorControl34 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · A",
                },
                ambulanceStretcherEditorControl35 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · D",
                },
                ambulanceStretcherEditorControl36 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · BAL CTRL",
                },
                ambulanceStretcherEditorControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · E",
                },
                ambulanceStretcherEditorControl44 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Interakció · Q",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Várakozási idő másodpercben a betegfoglalási kísérletek között.",
                    label = "Foglalási várakozási idő",
                },
                appointmentsEnabled = {
                    description = "Engedélyezi a betegfoglalásokat és a személyes mentőkalendárt.",
                    label = "Engedélyezve",
                },
                appointmentsMaxAdvanceDays = {
                    description = "A maximális előre tervezhető napok száma, amelyre a betegek foglalhatnak.",
                    label = "Maximális előfoglalási idő",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "A maximális egyidejű, aktív jövőbeli foglalások száma egy beteg számára.",
                    label = "Maximális foglalások egy betegre",
                },
                appointmentsMinLeadMinutes = {
                    description = "A foglalás és az időpont közötti minimális percek száma.",
                    label = "Minimális előzetes idő",
                },
                appointmentsNotificationApp = {
                    description = "A telefonos alkalmazás azonosítója a foglalási értesítésekhez.",
                    label = "Értesítő alkalmazás",
                },
                appointmentsNotificationsEnabled = {
                    description = "Értesíti a betegeket a telefonjukon, amikor foglalást végeznek vagy érvénytelenítenek.",
                    label = "Telefonos értesítések",
                },
                appointmentsReasonMaxLength = {
                    description = "A foglalási ok megadásához megengedett maximális karakterek száma.",
                    label = "Ok karakterkorlátja",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Az időpont időtartama és rácsintervalluma percben.",
                    label = "Időpont hossza",
                },
                billingAccount = {
                    description = "A számlázáshoz használt, elavult társadalmi fiók.",
                    label = "fiók",
                },
                billingCloseOnSuccess = {
                    description = "Zárja be automatikusan a számlázási felületet sikeres számlázás után.",
                    label = "Zárás siker esetén",
                },
                billingCurrency = {
                    description = "Opcionális pénznemkulcs a számlázási fizetésekhez.",
                    label = "Pénznem",
                },
                billingCustomBillingReasons = {
                    description = "Engedélyezi a mentők számára a testreszabott számlázási okok megadását.",
                    label = "Egyedi okok",
                },
                billingDepositToSociety = {
                    description = "A számlázási bevételt a társadalmi fiókba utalja.",
                    label = "Átutalás a társasági fiókba",
                },
                billingEnabled = {
                    description = "Engedélyezi az orvosi számlázási rendszert.",
                    label = "Engedélyezve",
                },
                billingMaxReasonLength = {
                    description = "A testreszabott számlázási okok maximális hossza.",
                    label = "Maximális okhossz",
                },
                billingMode = {
                    description = "Válassza ki, hogy az orvosi számlák azonnal levonásra kerüljenek, megerősítést igényeljenek, vagy a keretrendszer számlázási rendszerét használják.",
                    label = "Számlázási mód",
                    options = {
                        consent = "Fizet vagy utasít el",
                        framework = "Keretrendszeri számla",
                        instant = "Azonnali levonás",
                    },
                },
                billingRange = {
                    description = "A számlázható betegek keresésének maximális hatótávolsága.",
                    label = "Hatótáv",
                },
                billingReasonPresets = {
                    description = "Előre beállított számlázási okok, amelyeket a számlázási felületen jelenít meg a rendszer.",
                    itemLabel = "Indok",
                    label = "Okok előbeállításai",
                },
                billingRefreshSeconds = {
                    description = "Másodpercek a számlázható játékosok frissítése között.",
                    label = "Frissítési másodpercek",
                },
                bladeWeapons = {
                    description = "Fegyvernevek vagy hash-ek, amelyeket éles vágásos sérülésnek kell minősíteni, nem pedig tompa ütésnek.",
                    itemLabel = "Fegyver",
                    label = "Éles vágásos fegyverek",
                },
                bleedingBlacklist = {
                    description = "Fegyverek, amelyek soha nem okozhatnak élő vérzést vagy nyitott sebet.",
                    itemLabel = "Fegyver",
                    label = "Vérzés kizárólista",
                },
                bleedingClassesProfiles = {
                    description = "Vérzés súlyossági profiljai és vérveszteségi rátájuk.",
                    label = "Vérzési osztályok",
                },
                bloodSystemDebugLogInterval = {
                    description = "Másodpercek a vérrendszer hibakeresési naplóüzenetei között.",
                    label = "Hibakeresési napló intervallum",
                },
                bloodSystemMaxVolume = {
                    description = "Maximum vértérfogat érték, amelyet a betegállapot-rendszer használ.",
                    label = "Maximális térfogat",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passzív vérregeneráció, amikor a beteg nem vérzik aktívan.",
                    label = "Regeneráció másodpercenként",
                },
                bloodSystemTickIntervalMs = {
                    description = "Szerver tick intervallum a vérveszteség és helyreállítás frissítésekhez.",
                    label = "Tick intervallum (ms)",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Vértérfogat küszöbérték, amely alatt a beteg eszméletlen lesz.",
                    label = "Eszméletlenség küszöbérték",
                },
                bodyBagAnimationDict = {
                    description = "Animációs szótár, amelyet a holttestzsák hordozásához használnak.",
                    label = "Animációs szótár",
                },
                bodyBagAnimationEnabled = {
                    description = "Kiemelt hordozási animáció használata holttestzsák hordozás közben.",
                    label = "Engedélyezve",
                },
                bodyBagAnimationFlag = {
                    description = "A hordozási animációhoz használt TaskPlayAnim jelző.",
                    label = "Animációs jelző",
                },
                bodyBagAnimationName = {
                    description = "Animációs vágás, amelyet a holttestzsák hordozásához használnak.",
                    label = "Animáció neve",
                },
                bodyBagAttachBone = {
                    description = "Ped csontnév vagy csontazonosító, amelyet a holttestzsák rögzítéséhez használnak.",
                    label = "Csont",
                },
                bodyBagAttachRx = {
                    description = "X forgatás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés X",
                },
                bodyBagAttachRy = {
                    description = "Y forgatás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés Y",
                },
                bodyBagAttachRz = {
                    description = "Z forgatás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés Z",
                },
                bodyBagAttachX = {
                    description = "X eltolás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés X",
                },
                bodyBagAttachY = {
                    description = "Y eltolás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés Y",
                },
                bodyBagAttachZ = {
                    description = "Z eltolás a holttestzsák rögzítéséhez.",
                    label = "Rögzítés Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Locale kulcs, amelyet a holttestzsák leadási segítségkéréshez használnak.",
                    label = "Segítség címké kulcs",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Távolság, amelyet a holttestzsák leadásának ellenőrzéséhez használnak.",
                    label = "Interakciós távolság",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Holttestzsák-átadás",
                },
                bodyBagDeliveryInteraction = {
                    description = "A holttestzsák-leadásokhoz használt interakciós sablon kulcsa.",
                    label = "Interakciós sablon",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Kötelező, hogy a mentők a konfigurált leadási pontokon adják át a holttestzsákokat.",
                    label = "Átadás kötelező",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Kötelező, hogy a mentők szolgálatban legyenek a holttestzsák-átadás előtt.",
                    label = "Szolgálat kötelező",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "A holttestzsák-átadás jutalmához használt elsődleges fiók kulcsa.",
                    label = "fiók",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "A holttestzsák-átadás jutalmához használt elsődleges fiók típusa.",
                    label = "Fiók típusa",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "A holttestzsák-szállításért fizetett jutalom összege.",
                    label = "Összeg",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Opcionális, egyedi pénznem kulcsa a holttestzsák-átadás jutalmához.",
                    label = "Pénznem",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Jutalom kifizetése egy sikeresen végrehajtott holttestzsák-átadás után.",
                    label = "Engedélyezve",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "A holttestzsák-átadás jutalmának levonása a közös munkaközösségi fiókból a mentő kifizetése előtt.",
                    label = "Fiókból történő kifizetés",
                },
                bodyBagEnabled = {
                    description = "A holttestzsák-rendszer engedélyezése.",
                    label = "Engedélyezve",
                },
                bodyBagHidePatient = {
                    description = "A beteg ped elrejtése, amíg a holttestzsák csatlakoztatva van.",
                    label = "Beteg elrejtése",
                },
                bodyBagModel = {
                    description = "A holttestzsákokhoz használt prop modell.",
                    label = "Modell",
                },
                bodyBagPatientAlpha = {
                    description = "A betegen alkalmazott átlátszóság, amikor a hullatáskban van.",
                    label = "Beteg átlátszósága",
                },
                crutchAssignMaxDistance = {
                    description = "A bot másik játékosnak történő kiosztásának maximális távolsága.",
                    label = "Kiosztás maximális távolsága",
                },
                crutchAutoUnequipOnExpire = {
                    description = "A bot automatikus levetése, amikor a kiosztás lejárt.",
                    label = "Automatikus levetés lejáratkor",
                },
                crutchClipset = {
                    description = "A bot használatával alkalmazott mozgási clipset.",
                    label = "Clipset",
                },
                crutchDefaultDurationMinutes = {
                    description = "A bot alapértelmezett kiosztási ideje percben.",
                    label = "Alapértelmezett időtartam",
                },
                crutchDisableSprint = {
                    description = "A bot használatával a sprintelés blokkolása.",
                    label = "Sprintelés letiltása",
                },
                crutchDisableWeapons = {
                    description = "A bot használatával a fegyverhasználat blokkolása.",
                    label = "Fegyverek letiltása",
                },
                crutchItemName = {
                    description = "A botra használt inventár tárgy neve.",
                    label = "Tárgy neve",
                },
                crutchMaxDurationMinutes = {
                    description = "A bot kiosztásának maximálisan megengedett időtartama percben.",
                    label = "Maximális időtartam",
                },
                crutchMinDurationMinutes = {
                    description = "A bot kiosztásának minimálisan megengedett időtartama percben.",
                    label = "Minimális időtartam",
                },
                crutchProp = {
                    description = "A botra használt prop modell.",
                    label = "Tárgy",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Az egyes találatok egy Discord üzenetbe gyűjtésének időtartama másodpercben.",
                    label = "Gyűjtési intervallum",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Egy Discord üzenetbe belefoglalt egyes találatok maximális száma.",
                    label = "Találatok üzenetenként",
                },
                damageLogsEnabled = {
                    description = "A szerver által megerősített, nem halálos játékos-találatok elküldése a Discordra.",
                    label = "Kártalajegyzőkönyvek",
                },
                deathAnimalAnimationDictionary = {
                    description = "Az állati kitérés halálanimációhoz használt animációs szótár.",
                    label = "Állat-szótár",
                },
                deathAnimalAnimationName = {
                    description = "Az állat-alternatív halálanimációhoz használt animációs kliplista.",
                    label = "Állat animáció neve",
                },
                deathAnimalUseAnimation = {
                    description = "Engedélyezi, hogy a konfigurált állat-alternatíva skriptelt halálanimációt használjon.",
                    label = "Állat animáció",
                },
                deathAnimationDictionary = {
                    description = "Az alapértelmezett halálanimációhoz használt animációs szótár.",
                    label = "Animációs szótár",
                },
                deathAnimationName = {
                    description = "Az alapértelmezett halálanimációhoz használt animációs klip.",
                    label = "Animáció neve",
                },
                deathInjuriesProfiles = {
                    description = "Olyan sérülési profilok, amelyeket alkalmaznak, amikor egy játékos egy adott okból meghal.",
                    itemLabel = "Sérülés",
                    label = "Halálos sérülések",
                },
                deathModels = {
                    description = "A halálanimáció viselkedésének felülírása ped modell vagy modell hash alapján.",
                    label = "Modell felülírások",
                },
                deathScreenAiMedicAccount = {
                    description = "Az AI mentő főlegeltetett számlája.",
                    label = "fiók",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "A vérzéses időzítőhöz hozzáadott másodpercek, amikor az AI mentőt kérik.",
                    label = "Halál időzítő hozzáadása",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Engedélyezi, hogy az AI mentő életre keltsen halálos sérüléseknél is.",
                    label = "Halálos sérülések engedélyezése",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "A távolság, ahol az AI mentő megáll és gyalog közeledik.",
                    label = "Megközelítési távolság",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Várakozási idő, amíg az AI mentőt újra hívni lehet.",
                    label = "Várakozási idő (másodperc)",
                },
                deathScreenAiMedicCurrency = {
                    description = "Opcionális pénznem-kulcs az AI mentő fizetéseihez.",
                    label = "Pénznem",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Pénznem-formázó az AI mentő fizetéseihez.",
                    label = "Pénznem-formázó",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Másodperc, ameddig az AI mentő megjelenik a befejezés után, mielőtt eltűnne.",
                    label = "Eltűnés késleltetése",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Késleltetés, amíg az AI mentő küldése el nem indul.",
                    label = "Küldési késleltetés",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Az AI mentő járművel használt sebesség.",
                    label = "Vezetési sebesség",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximális vezetési idő, amíg a kényszerített életre kelés be nem indul.",
                    label = "Vezetési időzítő",
                },
                deathScreenAiMedicEnabled = {
                    description = "Az AI mentő mentési folyamatának engedélyezése.",
                    label = "Engedélyezve",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Alternatív számla, ha az AI mentő fő számlája nem rendelkezik elegendő pénzzel.",
                    label = "Alternatív számla",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Kényszerített életre kelés, ha az AI mentő nem éri el a játékost.",
                    label = "Kényszerített életre kelés engedélyezve",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "Az AI mentő csak akkor működik, ha a szolgálatban lévő mentők száma nem haladja meg ezt az értéket.",
                    label = "Maximális online mentők",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximális küldés idő, amíg a kényszerített életre kelés be nem indul.",
                    label = "Küldés időzítő",
                },
                deathScreenAiMedicPedModel = {
                    description = "Az AI mentőhöz használt ped modell.",
                    label = "Személy modell",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Cél, amikor a leejtett játékos maga hívja az AI mentőt.",
                    label = "Játékos kérés célja",
                    options = {
                        hospital = "Kórház",
                        location = "Jelenlegi hely",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Az AI mentő hívásáért felszámított díj.",
                    label = "Ár",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Másodperc a beteg halála után, amíg egy mentő nem kínálhat távoli AI mentőt.",
                    label = "Távoli küldés várakozási ideje",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Engedélyezi, hogy a mentők az AI mentőt a küldési térképről és a /aimedic parancsból is elküldjék egy leejtett játékoshoz.",
                    label = "Távoli küldés",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "A távoli AI mentő küldése csak akkor működik, ha a szolgálatban álló mentők száma nem haladja meg ezt az értéket.",
                    label = "Távoli küldés: maximális online mentők száma",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Cél, amelyet a távoli AI mentő használ, ha elküldik és elfogadnak.",
                    label = "Távoli küldés célja",
                    options = {
                        hospital = "Kórház",
                        location = "Jelenlegi hely",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Az idő, ameddig a betegnek elfogadnia kell a távoli AI mentő ajánlatát.",
                    label = "Ajánlat lejárati idő",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "A szükséges távolság, amíg az AI-orvos elkezdi a feltámasztást.",
                    label = "Feltámasztási távolság",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "A feltámasztás időtartama.",
                    label = "Feltámasztás időtartama",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "A játékost átküldi egy kórházi ágyra a helyszíni feltámasztás helyett.",
                    label = "Feltámasztás ágyon",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "A feltámasztó ágy kereséséhez használt sugár.",
                    label = "Ágy-keresési sugár",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Az idő, amelyik a halál után telik el, amíg az AI-orvos elérhetővé válik.",
                    label = "Idő az elérhetőségig",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximális AI-orvos megjelenítési sugár.",
                    label = "Maximális megjelenítési sugár",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimális AI-orvos megjelenítési sugár.",
                    label = "Minimális megjelenítési sugár",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Az AI-orvos által használt járműmodell.",
                    label = "Járműmodell",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Hangmód eszméletlen állapotban: nincs, csak hallgatás vagy teljes.",
                    label = "Hangmód",
                    options = {
                        full = "Teljes",
                        listen = "Csak hallgatás",
                        none = "Nincs",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Azok a vezérlések, amelyek eszméletlen állapotban is aktívak maradnak.",
                    label = "Engedélyezett vezérlések",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Automatikus újjáéledés, ha a vérzéses időzítő már lejárt a kapcsolat megszakadása közben.",
                    label = "Automatikus újjáéledés lejárt kapcsolattartás esetén",
                },
                deathScreenBackgroundEnd = {
                    description = "A halálképernyő hátterének végső színe.",
                    label = "Háttér vége",
                },
                deathScreenBackgroundStart = {
                    description = "A halálképernyő hátterének kezdő színe.",
                    label = "Háttér kezdete",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Az idő, amelyik a vérzéses időzítő lejárta előtt telik el.",
                    label = "Vérzéses időzítő",
                },
                deathScreenBlockedDimensions = {
                    description = "Azok a dimenziók, ahol a halálképernyő újjáéledési folyamata blokkolva van.",
                    label = "Blokkolt dimenziók",
                },
                deathScreenBorderColor = {
                    description = "A halálképernyő által használt keret színe.",
                    label = "Keret színe",
                },
                deathScreenDispatchEnabled = {
                    description = "Dispatch események küldése a halálképernyő folyamataiból.",
                    label = "Dispatch engedélyezve",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Pótló munkahelyek, ha nincs élő és szolgálatban álló elsődleges munkahely. Hagyd üresen, hogy mindig az elsődleges munkahelyeket figyelmeztessük.",
                    itemLabel = "Foglalkozás",
                    label = "Pótló munkahelyek",
                },
                deathScreenDispatchJobs = {
                    description = "Azok a munkahelyek, amelyeket figyelmeztetünk, ha egy elesett játékos segítséget kér.",
                    itemLabel = "Foglalkozás",
                    label = "Figyelmeztetett munkahelyek",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Az elsődleges fiók, amelyet a korai újjáéledésért terhelnek.",
                    label = "fiók",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "A korai újjáéledés elérhetővé tétele halálos sérülések esetén is.",
                    label = "Halálos sérülések engedélyezése",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Opcionális pénznemkulcs a korai újjáéledés fizetéseinek kezelésére.",
                    label = "Pénznem",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Pénznem-formázó a korai újjászületés fizetéseinek kezelésére.",
                    label = "Pénznem-formázó",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Fizetős korai újjászületés engedélyezése.",
                    label = "Engedélyezve",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Pótló fiók, amelyet akkor használnak, ha a fő fiók nem rendelkezik elegendő egyenleggel.",
                    label = "Alternatív számla",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Opcionális felirat a korai újjászületés fizetésére.",
                    label = "Fizetési felirat",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "A korai újjászületés díja.",
                    label = "Ár",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Csak akkor engedélyezze a korai újjászületést, ha nincs szolgálatban orvos.",
                    label = "Nincs orvos szükséges",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Másodpercek a halál után, amíg a korai újjászületés elérhetővé válik.",
                    label = "Idő az elérhetőségig",
                },
                deathScreenEnableKeyboard = {
                    description = "Billentyűzet használata engedélyezése a halálképernyőn.",
                    label = "Billentyűzet engedélyezése",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Külső hangrendszer, amelyet engedélyezés esetén némítanak.",
                    label = "Külső hangrendszer",
                    options = {
                        saltychat = "SaltyChat",
                        yaca = "YACA",
                    },
                },
                deathScreenFocusKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Halálképernyő: egérhasználat",
                },
                deathScreenHandlingMode = {
                    description = "A statikus halálanimáció használata vagy a természetes ragdoll-fizika megőrzése, amíg a test stabilizálódik.",
                    label = "Halálkezelés",
                    options = {
                        natural = "Természetes",
                        static = "Statikus",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Az átfedés elrejtése, amikor a játékvezérlésre váltunk (LEERTASTE); tiltsa le ezt az opciót, hogy megőrizze a korábbi látható átfedést.",
                    label = "Átfedés elrejtése játékvezérléskor",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "A kamerafókusz-célpontjára alkalmazott magasságeltolódás.",
                    label = "Fókuszmagasság",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Előnézeti kamera látószöge.",
                    label = "Látószög",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Az előnézeti kamera elhelyezéséhez használt irányeltolódás.",
                    label = "Irányeltolódás",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Az előnézeti kamerára alkalmazott magasságeltolódás.",
                    label = "Kameramagasság",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Az előnézeti kamerára alkalmazott dőlés.",
                    label = "Dőlésszög",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Az előnézeti kamera és a spawnpont közötti távolság.",
                    label = "Kameraradius",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Lágy átmenet használata a kórházi kiválasztó kamera megnyitásakor.",
                    label = "Lágy átmenet",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Engedélyezze, hogy a játékosok kórházat válasszanak újjászületés előtt.",
                    label = "Kórházi kiválasztás",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Csak akkor jelenítsen meg kórházi kiválasztást, ha több mint egy kórház létezik.",
                    label = "Több kórház szükséges",
                },
                deathScreenInformationEnabled = {
                    description = "A halálképernyőn az információs blokk megjelenítése.",
                    label = "Engedélyezve",
                },
                deathScreenInformationShowDeathCause = {
                    description = "A halál oka megjelenítése a halálképernyő információs blokkjában.",
                    label = "Halál oka megjelenítése",
                },
                deathScreenInformationShowInjuries = {
                    description = "Sérülések megjelenítése a halálképernyő információs blokkjában.",
                    label = "Sérülések megjelenítése",
                },
                deathScreenInformationShowKiller = {
                    description = "A gyilkos neve megjelenítése a halálképernyő információs blokkjában.",
                    label = "Gyilkos megjelenítése",
                },
                deathScreenInformationShowWeapon = {
                    description = "A fegyver megjelenítése a halálképernyő információs blokkjában.",
                    label = "Fegyver megjelenítése",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Engedélyezési listán szereplő bandák",
                    description = "Válaszd a bandák vagy független szervezetek belső neveit. Az egyező foglalkozás vagy banda engedélyt vagy kivételt ad. A szolgálati követelmény csak a foglalkozásokra érvényes.",
                    itemLabel = "Banda",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Csak a megengedett foglalkozások láthatják a halálképernyő kiterjesztett adatait.",
                    itemLabel = "Foglalkozás",
                    label = "Fehérlistázott foglalkozások",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximális másodpercek száma minden egyes halálképernyő-felvétel feltöltéséhez.",
                    label = "Képernyőfelvétel időtúllépése",
                },
                deathScreenLogScreenshots = {
                    description = "Töltse fel az áldozat és a megerősített gyilkos szemszögéből készült képernyőfelvevételeket a szöveges haláljegyzőkönyv után.",
                    label = "Képernyőfelvevések",
                },
                deathScreenLogsEnabled = {
                    description = "Küldjön Discord-jegyzőkönyvet minden játékos halála esetén.",
                    label = "Haláljegyzőkönyvek",
                },
                deathScreenMedicNearbyRadius = {
                    description = "A mentőnek a közelben lévőnek számításhoz használt távolság méterben.",
                    label = "Mentő közelben lévő sugara",
                },
                deathScreenMinigameEnabled = {
                    description = "A halálképernyő minijáték engedélyezése.",
                    label = "Engedélyezve",
                },
                deathScreenMinigameUrl = {
                    description = "URL, amely a halálképernyő minijáték megnyitásakor betöltődik.",
                    label = "Minijáték URL",
                },
                deathScreenMode = {
                    description = "A halálképernyő csomagolt vagy külső integráció használatát jelzi.",
                    label = "Képernyő mód",
                    options = {
                        external = "Külső",
                        internal = "Belső",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "A külső hangrendszerek némítása, amíg a játékos élettelen.",
                    label = "Külső hang némítása",
                },
                deathScreenMutedTextColor = {
                    description = "A halálképernyő által használt némított szövegszín.",
                    label = "Némított szövegszín",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Részletes kliens- és szerveri okok kiírása, amíg egy természetes halállal elhunyt test ragdoll állapotban marad.",
                    label = "Természetes ragdoll hibakeresés",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "A leültetett természetes halállal elhunyt testek automatikus stabilizálása, vagy egy szolgálatban lévő mentő elhelyezése a stabil oldalfekvésben.",
                    label = "Természetes stabilizálás",
                    options = {
                        automatic = "Automatikus",
                        medic = "Mentő szükséges",
                    },
                },
                deathScreenPanelBackground = {
                    description = "A halálképernyő által használt panel háttérszín.",
                    label = "Panel háttér",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Az automatikus újjáéledés blokkolása vérzés után.",
                    label = "Automatikus újjáéledés megakadályozása",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Az automatikus újjáéledés blokkolása, amíg egy mentő közelben van.",
                    label = "Blokkolás, ha mentő közelben van",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Az újjáéledés blokkolása a vérzés-timer lejárta után.",
                    label = "Újjáéledés megakadályozása lejártnál",
                },
                deathScreenPrimaryColor = {
                    description = "A halálképernyő témájához használt alap CSS szín.",
                    label = "Elsődleges szín",
                },
                deathScreenPrimaryDark = {
                    description = "Opcionális sötétebb hangsúlyozó szín a halálképernyőhöz.",
                    label = "Elsődleges sötét",
                },
                deathScreenPrimaryStrong = {
                    description = "Opcionális erősebb hangsúlyozó szín a halálképernyőhöz.",
                    label = "Elsődleges erős",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Használt irány, ha az állomásnak nincs meghatározott iránya.",
                    label = "Alapértelmezett irány",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Visszaeséses újjáéledési irány, ha nem léteznek kórházi pozíciók.",
                    label = "Visszaeséses irány",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Visszaeséses újjáéledési X koordináta, ha nem léteznek kórházi pozíciók.",
                    label = "Visszaeséses X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Visszaeséses újjáéledési Y koordináta, ha nem léteznek kórházi pozíciók.",
                    label = "Visszaeséses Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Visszaeséses újjáéledési Z koordináta, ha nem léteznek kórházi pozíciók.",
                    label = "Visszaeséses Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Válassz egy rögzített kórházat az újjáéledéshez. Hagyd üresen a legközelebbi kórház használatához.",
                    label = "Újjáéledési kórház",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Számfejezetek törlése újjáéledéskor.",
                    label = "Számfejezetek törlése",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Újjáéledéskor törlendő számlanév.",
                    itemLabel = "fiók",
                    label = "Számlanevek",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Inventárum elemek törlése újjáéledéskor.",
                    label = "Elemek törlése",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Újjáéledéskor megmaradó inventárum elemek.",
                    itemLabel = "Tárgy",
                    label = "Kivett elemek",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Fegyverkerék fegyvereinek törlése újjáéledéskor.",
                    label = "Fegyverek törlése",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Újjáéledéskor megmaradó fegyverek.",
                    itemLabel = "Fegyver",
                    label = "Kivett fegyverek",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "A játékos teleportálása egy kórházba újjáéledéskor.",
                    label = "Teleportálás kórházba",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "A vérzéses időzítő folytatása újracsatlakozás után a visszaállítás helyett.",
                    label = "Folytatás újracsatlakozáskor",
                },
                deathScreenShadowLight = {
                    description = "A halálképernyő által használt puha árnyék színe.",
                    label = "Árnyék fény",
                },
                deathScreenShadowMid = {
                    description = "A halálképernyő által használt közepes árnyék színe.",
                    label = "Árnyék közepes",
                },
                deathScreenShowNearestMedic = {
                    description = "A legközelebbi mentő megjelenítése a halálképernyőn.",
                    label = "Legközelebbi mentő megjelenítése",
                },
                deathScreenTextColor = {
                    description = "A halálképernyő által használt elsődleges szövegszín.",
                    label = "Szövegszín",
                },
                deathScreenTextShadow = {
                    description = "A halálképernyő által használt szövegárnyék színe.",
                    label = "Szövegárnyék",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "A halálidőkorlát alkalmazása a megsemmisítés utáni élesztésnél is.",
                    label = "Alkalmazás megsemmisítéskor",
                },
                deathTimeoutSeconds = {
                    description = "Másodpercek egy élesztés után, amíg a harc letiltva marad.",
                    label = "Másodpercek",
                },
                deathTimeoutShowUi = {
                    description = "A halálidőkorlát lefutó sávjának megjelenítése, amíg aktív.",
                    label = "UI megjelenítése",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Engedélyezési listán szereplő bandák",
                    description = "Válaszd a bandák vagy független szervezetek belső neveit. Az egyező foglalkozás vagy banda engedélyt vagy kivételt ad. A szolgálati követelmény csak a foglalkozásokra érvényes.",
                    itemLabel = "Banda",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "A halálidőkorlát korlátozásaitól mentes feladatok.",
                    itemLabel = "Foglalkozás",
                    label = "Fehérlistázott foglalkozások",
                },
                deathUseAnimation = {
                    description = "A konfigurált halálanimáció lejátszása támogatott peds esetén.",
                    label = "Animáció használata",
                },
                diagnoseAnimClip = {
                    description = "Diagnosztika megnyitásakor használt animációs klip. Hagyd üresen, ha ehelyett egy forgatókönyvet szeretnél használni.",
                    label = "Animáció neve",
                },
                diagnoseAnimDict = {
                    description = "Diagnosztika megnyitásakor használt animációs szótár. Hagyd üresen, ha ehelyett egy forgatókönyvet szeretnél használni.",
                    label = "Animációs szótár",
                },
                diagnoseAnimScenario = {
                    description = "Diagnózis megnyitásakor használt forgatókönyv. Hagyd üresen a szótár + klip használata helyett.",
                    label = "Szituáció",
                },
                diagnoseCprAnimDict = {
                    description = "A CPR-hez használt animációs szótár.",
                    label = "Animációs szótár",
                },
                diagnoseCprAnimName = {
                    description = "A CPR-hez használt animációs klip.",
                    label = "Animáció neve",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "A teljes gyógyulás megjelenéséhez szükséges folyamatos diagnózis időtartama.",
                    label = "Késleltetés (másodperc)",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Mentőhátizsák megkövetelése",
                    description = "A bal oldali vizsgálati eszköztár megjelenítéséhez rescue_backpack szükséges. Kikapcsolva az eszköztár mindig látható; az egyes eszközök tárgykövetelményei továbbra is érvényesek.",
                },
                diagnoseFullHealEnabled = {
                    description = "Teljes gyógyulás engedélyezése egy folyamatos diagnózis után.",
                    label = "Engedélyezve",
                },
                diagnoseInteractDistance = {
                    description = "A beteg diagnosztizálásához vagy a holttestzsákba helyezéséhez szükséges maximális távolság.",
                    label = "Interakciós távolság",
                },
                diagnosePatientMovementMode = {
                    label = "Betegek mozgása",
                    description = "A beteg befagyasztása, amíg egy másik játékos nyitva tartja a kezelési menüt, vagy a mozgás engedélyezése és a menü bezárása, ha a kezelési távolságot túllépi. Az ön-diagnosztika külön konfigurálható.",
                    options = {
                        freeze = "Befagyasztás",
                        distance = "Bezárás a távolsághatár elérésekor",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Kezelési távolság (m)",
                    description = "A kezelő játékos és a beteg közötti maximális távolság a távolsági üzemmódban, mielőtt a kezelési menü bezárul. A nyitási távolság külön állítható be.",
                },
                diagnoseKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Diagnosztikai interakció",
                },
                diagnoseOpenDelayMs = {
                    description = "Késleltetés a diagnosztikai felület megnyitása előtt.",
                    label = "Nyitási késleltetés (ms)",
                },
                diagnosePromptDistance = {
                    description = "A diagnosztikai felugró ablak megjelenítéséhez használt távolság.",
                    label = "Felugró ablak távolsága",
                },
                diagnoseTreatmentDurationMs = {
                    description = "A kezelési animációkhoz használt időtartam.",
                    label = "Kezelési időtartam (ms)",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Az orvos díjainak betöltése a közös társasági fiókba közvetlen levonás esetén.",
                    label = "Bevételek a társasági fiókba",
                },
                doctorNpcEnabled = {
                    description = "Az orvos NPC szolgáltatás engedélyezése.",
                    label = "Engedélyezve",
                },
                doctorNpcHealOtherAccount = {
                    description = "Fő fiók kulcsa egy másik játékos gyógyításának levonásához.",
                    label = "fiók",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Fő fiók típusa egy másik játékos gyógyításának levonásához.",
                    label = "Fiók típusa",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Opcionális egyedi pénznem kulcsa egy másik játékos gyógyításának levonásához.",
                    label = "Pénznem",
                },
                doctorNpcHealOtherPrice = {
                    description = "Ár egy másik játékos gyógyítására az orvos NPC-nél.",
                    label = "Ár",
                },
                doctorNpcHealSelfAccount = {
                    description = "Fő fiók kulcsa a saját gyógyításának levonásához.",
                    label = "fiók",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Fő fiók típusa a saját gyógyításának levonásához.",
                    label = "Fiók típusa",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Opcionális egyedi pénznem kulcsa a saját gyógyításának levonásához.",
                    label = "Pénznem",
                },
                doctorNpcHealSelfPrice = {
                    description = "Ár a saját gyógyítására az orvos NPC-nél.",
                    label = "Ár",
                },
                doctorNpcInteractionRange = {
                    description = "Annak a távolságnak a meghatározása, amennyire a felhasználónak az orvos NPC-hez kell maradnia az orvos menü megnyitása közben. Ez nem változtatja meg az első NPC felugró ablak távolságát.",
                    label = "Interakciós tartomány",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Az orvos NPC csak akkor működik, ha a szolgálatban lévő mentők száma ennél a határnál alacsonyabb.",
                    label = "Maximális online mentők",
                },
                doctorNpcPatientRange = {
                    description = "Annak a távolságnak a meghatározása, amennyire a páciensnek az orvos NPC-hez kell lennie, hogy a más gyógyítása vagy feltámasztása működjön az akció kiválasztása után.",
                    label = "Páciens tartomány",
                },
                doctorNpcPaymentMode = {
                    description = "Játékosok azonnali terhelése vagy számla küldése.",
                    label = "Fizetési mód",
                    options = {
                        bill = "Számla",
                        remove = "Azonnali levonás",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Csak a közelben lévő játékosok felsorolására szolgál az orvos NPC felületén. Önmagában nem engedélyez kezelést.",
                    label = "Játékos szkennelési tartomány",
                },
                doctorNpcReviveAccount = {
                    description = "Fő fiók kulcsa az orvos feltámasztásának levonásához.",
                    label = "fiók",
                },
                doctorNpcReviveAccountType = {
                    description = "Fő fiók típusa az orvos feltámasztásának levonásához.",
                    label = "Fiók típusa",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Az orvos NPC engedélyezi a halálos vagy nem feltámasztható sérülésekkel rendelkező páciensek feltámasztását. A lejárt vérzés továbbra is blokkolt marad.",
                    label = "Halálos sérülések engedélyezése",
                },
                doctorNpcReviveCurrency = {
                    description = "Opcionális egyedi pénznem kulcsa az orvos feltámasztásának levonásához.",
                    label = "Pénznem",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "A feltámasztott játékosok elhelyezése a legközelebbi kórházi ágyon az orvos feltámasztása után.",
                    label = "Engedélyezve",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "A legközelebbi kórházi ágy megtalálásához használt maximális távolság az orvos feltámasztásaihoz.",
                    label = "Keresési sugár",
                },
                doctorNpcRevivePrice = {
                    description = "Ár egy játékos feltámasztására az orvos NPC-nél.",
                    label = "Ár",
                },
                enforceMaxHealth = {
                    description = "A játékos maximális egészségének megőrzése 200 szinten. Tiltsa le, ha egy másik erőforrás kezeli a maximális egészséget.",
                    label = "200 maximális egészség kényszerítése",
                },
                firstAidActionDurationMs = {
                    description = "Az elsősegélynyújtási akció időtartama.",
                    label = "Akció időtartama (ms)",
                },
                firstAidAnimationDict = {
                    description = "Az elsősegélynyújtási akció során használt animációs szótár.",
                    label = "Animációs szótár",
                },
                firstAidAnimationFlag = {
                    description = "Az elsősegélynyújtási akció során használt TaskPlayAnim jelző.",
                    label = "Animációs jelző",
                },
                firstAidAnimationName = {
                    description = "Az elsősegélynyújtási akció során használt animációs klip.",
                    label = "Animáció neve",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Az elsősegélynyújtás után a páciens vérzésidőhöz hozzáadott másodpercek.",
                    label = "Vérzésidő-hosszabbítás másodpercben",
                },
                firstAidEnabled = {
                    description = "Az elsősegélynyújtás funkció engedélyezése engedéllyel rendelkező játékosok számára.",
                    label = "Az elsősegélynyújtás engedélyezve",
                },
                firstAidLicense = {
                    description = "A keretrendszer engedélynév, amelyet az elsősegélynyújtás hozzáférésének érvényesítésére használnak.",
                    label = "Engedélynév",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Lehetővé teszi a mentőszemélyzet számára, hogy engedélyezett engedélyeket adjon ki a betegnyilvántartásokban. A radiális akció csak az elsősegélynyújtás engedélyét adja ki.",
                    label = "Engedélykiadás engedélyezve",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Az engedélykiadási akció megjelenítése a radiális menüben.",
                    label = "Engedélykiadás a radiális menüben",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "EMS szolgálat szükséges az engedélykiadási akció használata előtt.",
                    label = "Engedélykiadás szolgálatot igényel",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "További keretrendszer-engedélyek, amelyeket a mentőszemélyzet kiadhat vagy törölhet a betegnyilvántartásokban. A konfigurált elsősegélynyújtás engedélye mindig benne van.",
                    itemLabel = "Engedély",
                    label = "További betegengedélyek",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Lehetővé teszi, hogy a mentőszemélyzet törölje a jóváhagyott engedélyeket a betegkártyákról. A radiális művelet csak az elsősegély-engedélyt törli.",
                    label = "Engedély törlése engedélyezve",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "A licenc törlésének megjelenítése a radiális menüben.",
                    label = "Engedély törlése a radiális menüben",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "EMS szolgálat szükséges a licenc törlésének használatához.",
                    label = "Engedély törlése szolgálatot igényel",
                },
                firstAidPositionChestOffset = {
                    description = "Mellkas eltolás az elsősegély nyújtásához való igazításkor.",
                    label = "Mellkas eltolás",
                },
                firstAidPositionSideOffset = {
                    description = "Oldalirányú eltolás az elsősegély nyújtásához való igazításkor.",
                    label = "Oldalirányú eltolás",
                },
                firstAidPositionZOffset = {
                    description = "Függőleges eltolás az elsősegély nyújtásához való igazításkor.",
                    label = "Z eltolás",
                },
                firstAidRequireLicense = {
                    description = "A beállított elsősegély-engedély szükséges ahhoz, hogy egy játékos elsősegélyt nyújthasson.",
                    label = "Engedély szükséges",
                },
                firstAidTargetDistance = {
                    description = "Az elsősegély nyújtásához megengedett maximális távolság.",
                    label = "Cél távolsága",
                },
                healthInsuranceAccount = {
                    description = "Biztosítási kifizetéseknél használt tartalék fiókkulcs.",
                    label = "fiók",
                },
                healthInsuranceAccountType = {
                    description = "Biztosítási kifizetéseknél használt elsődleges fióktípus.",
                    label = "Fiók típusa",
                },
                healthInsuranceAvailableDays = {
                    description = "Elérhető biztosítási időszakok napokban.",
                    label = "Elérhető napok",
                },
                healthInsuranceCommand = {
                    description = "Chat parancs a biztosítási felület megnyitásához.",
                    label = "Parancs",
                },
                healthInsuranceCurrency = {
                    description = "Opcionális egyedi valutakulcs a biztosítási kifizetéseknél.",
                    label = "Pénznem",
                },
                healthInsuranceEnabled = {
                    description = "Egészségbiztosítási rendszer engedélyezése.",
                    label = "Engedélyezve",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Lehetővé teszi a jogosult alkalmazottak számára a biztosítási díjak módosítását a tableten. Tiltsd le, ha a lenti szolgáltatótáblázatból származó árakat szeretnéd érvényesíteni.",
                    label = "Tabletes árrögzítés",
                },
                healthInsuranceProviders = {
                    description = "Játékosoknak kínált biztosítók.",
                    itemLabel = "Szolgáltató",
                    label = "Szolgáltatók",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Ugyanazok a biztosítók és biztosítási kötvények használata minden, ebben a mentő erőforrásban regisztrált munkahelyre.",
                    label = "Megosztás a mentő munkahelyek között",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Animációszótár, amely ciklikusan fut, miközben a játékos az ágyban fekszik. Hagyd üresen a halál alapértelmezett animációjának használatához.",
                    label = "Animációs szótár",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Opcionális manuális időtartam a ciklikus ágy-animációhoz. Csak akkor használatos, ha egyedi ágy-animáció van beállítva.",
                    label = "Időtartam (ms)",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim jelző a ciklikus ágy-animációhoz. Csak akkor használatos, ha egyedi ágy-animáció van beállítva.",
                    label = "Animációs jelző",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animációszelet, amely ciklikusan fut, miközben a játékos az ágyban fekszik. Hagyd üresen a halál alapértelmezett animációjának használatához.",
                    label = "Animáció neve",
                },
                hospitalBedsBreakDistance = {
                    description = "A távolság, amely után a játékost kényszerítik az ágyból.",
                    label = "Távolság a szakadáshoz",
                },
                hospitalBedsCreatorPedModel = {
                    description = "A kórházi ágy pozíciós szerkesztőjében használt ped modell előnézete.",
                    label = "Szerkesztő ped modell",
                },
                hospitalBedsEnabled = {
                    description = "A beállított kórházi ágy-interakciók engedélyezése.",
                    label = "Engedélyezve",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "A játékos ágyról való felállásakor lejátszott animációs könyvtár. Hagyd üresen, hogy a felállás alapértelmezett viselkedését használja.",
                    label = "Animációs szótár",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Opcionális manuális időtartam a felállás animációhoz. Csak akkor használatos, ha egyéni felállás animáció van beállítva.",
                    label = "Időtartam (ms)",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "A felállás animációhoz használt TaskPlayAnim jelző. Csak akkor használatos, ha egyéni felállás animáció van beállítva.",
                    label = "Animációs jelző",
                },
                hospitalBedsGetupAnimationName = {
                    description = "A játékos ágyról való felállásakor lejátszott animációs klip. Hagyd üresen, hogy a felállás alapértelmezett viselkedését használja.",
                    label = "Animáció neve",
                },
                hospitalBedsHeadingOffset = {
                    description = "A játékos ágyra helyezésekor alkalmazott iránytű-offset.",
                    label = "Irányeltolódás",
                },
                hospitalBedsHeightOffset = {
                    description = "A játékos ágyra helyezésekor alkalmazott függőleges offset.",
                    label = "Magasság-offset",
                },
                hospitalBedsInteractDistance = {
                    description = "A kórházi ágy használatához szükséges maximális távolság.",
                    label = "Interakciós távolság",
                },
                hospitalBedsInteractKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Kórházi ágy-interakció",
                },
                hospitalBedsModels = {
                    description = "A használatos kórházi ágyként kezelt világobjektum modellek.",
                    itemLabel = "Modell",
                    label = "Ágy modellek",
                },
                hospitalBedsSearchRadius = {
                    description = "A közelben lévő ágy-propok vagy beállított ágyak kereséséhez használt sugár.",
                    label = "Keresési sugár",
                },
                hospitalBlipColor = {
                    description = "A kórházi térképi blip-ekhez használt blip színazonosító.",
                    label = "Szín",
                },
                hospitalBlipEnabled = {
                    description = "A beállított kórházi pozíciókhoz tartozó térképi blip-ek megjelenítése.",
                    label = "Engedélyezve",
                },
                hospitalBlipName = {
                    description = "A kórházi bliphez használt tartalék név, ha a stáció neve nem érhető el.",
                    label = "Név",
                },
                hospitalBlipScale = {
                    description = "A kórházi térképi blip-ekhez használt blip méret.",
                    label = "Skála",
                },
                hospitalBlipSprite = {
                    description = "A kórházi térképi blip-ekhez használt blip sprite-azonosító.",
                    label = "Szimbólum",
                },
                imagingInteractionRange = {
                    description = "A képalkotó állomástól a kezelőhöz szükséges maximális távolság.",
                    label = "Interakciós tartomány",
                },
                imagingPatientRange = {
                    description = "A képalkotó állomástól a pácienshez szükséges maximális távolság.",
                    label = "Páciens tartomány",
                },
                imagingScanDurationSeconds = {
                    description = "A CT és MRI leletekhez szükséges idő másodpercben.",
                    label = "Scan időtartam",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Kizárólag vizuális szorzó a vérzés overlay-effektjeihez.",
                    label = "Vérzés overlay intenzitás",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Kizárólag vizuális szorzó a fájdalom képernyő-effektjeihez.",
                    label = "Fájdalom képernyő intenzitás",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "A vérzés és fájdalom alkalmazása előtt egyetlen ütésben elvesztett maximális egészség legalább százaléka.",
                    label = "Vérzés/fájdalom minimális százalék",
                },
                injuryThresholdRespectArmor = {
                    description = "A vérzés és fájdalom kihagyása, ha az ütés páncél által elnyelt.",
                    label = "Páncél tiszteletben tartása",
                },
                knockoutRegenerateDamage = {
                    description = "A knock-out károsodás regenerálása a respawn-timer lejárta után.",
                    label = "Károsodás regenerálása",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "A knock-out károsodás gyógyulására fordított másodpercek száma.",
                    label = "Regeneráció időtartama",
                },
                knockoutRespawnSeconds = {
                    description = "A játékos knock-outja esetén az automatikus respawnig tartó másodpercek száma.",
                    label = "Respawn másodpercek",
                },
                knockoutWeapons = {
                    description = "A teljes halálképernyő helyett knock-out-ot kiváltó fegyvernevek vagy hash-ek.",
                    itemLabel = "Fegyver",
                    label = "Fegyverek",
                },
                legShotRagdollChance = {
                    description = "Az egyező találat ragdollt kiváltó százalékos esélye.",
                    label = "Lehetőség",
                },
                legShotRagdollCooldownMs = {
                    description = "A lábsérülés miatti ragdoll-állapotok közötti minimális késleltetés.",
                    label = "Cooldown ms",
                },
                legShotRagdollDebug = {
                    description = "A lábsérülés miatti ragdoll-döntések naplózása tesztelés céljából.",
                    label = "Nyomkövetés",
                },
                legShotRagdollDurationMs = {
                    description = "A ragdoll állapotának időtartama.",
                    label = "Időtartam ms",
                },
                legShotRagdollFeet = {
                    description = "Lábütések engedélyezése ragdoll aktiválásához.",
                    label = "Láb",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Ragdoll kihagyása, ha a páncél elnyelte az ütést.",
                    label = "Páncélütések figyelmen kívül hagyása",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Ütés engedélyezése a bal alsó lábszáron.",
                    label = "Bal alsó lábszár",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Ütés engedélyezése a bal felső lábszáron.",
                    label = "Bal felső lábszár",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Csak a lőfegyverek által okozott találatok váltsák ki a ragdollt.",
                    label = "Csak lőnések",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Ütés engedélyezése a jobb alsó lábszáron.",
                    label = "Jobb alsó lábszár",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Ütés engedélyezése a jobb felső lábszáron.",
                    label = "Jobb felső lábszár",
                },
                liveDamageFracturesChance = {
                    description = "Az alap esélye annak, hogy egy tudatban lévő játékost érő sérülés törést okoz.",
                    label = "Esély",
                },
                liveDamageFracturesEnabled = {
                    description = "Tudatban lévő játékosok sérüléseiből adódó törések engedélyezése.",
                    label = "Engedélyezve",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "A maximális egészség elvesztésének minimális százaléka egy találat során, amely szükséges ahhoz, hogy törés keletkezzen.",
                    label = "Minimális sérülési százalék",
                },
                liveDamageFracturesZones = {
                    description = "Zónánkénti törési esélyek tudatos sérülések esetén.",
                    label = "Zónai esélyek",
                },
                liveOpenWoundStacksDefault = {
                    description = "A nyitott sebek alapértelmezett maximális szorzószáma zónánként, ha nincs zónai felülírás.",
                    label = "Alapértelmezett limit",
                },
                liveOpenWoundStacksZones = {
                    description = "Opcionális nyitott sebek maximális szorzószáma zónánként.",
                    itemLabel = "Zóna",
                    label = "Zónai limitok",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Kezdeti vérzési osztályok, amelyeket az életben maradó sérülések okai alkalmaznak.",
                    label = "Élő sebek vérzési osztálya",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "A hordozó engedélyezése járműbe lépésére és vezetésére anélkül, hogy a beteget le kellene tenni.",
                    label = "Hordozó a járműben",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Tudatos játékosok hordozásának engedélyezése.",
                    label = "Tudatos célpontok engedélyezése",
                },
                medicCarryAllowSprint = {
                    description = "Sprintelés engedélyezése beteggel a hordozásban.",
                    label = "Sprintelés engedélyezése",
                },
                medicCarryAttachBone = {
                    description = "A hordozott játékos rögzítéséhez használt csontindex.",
                    label = "Rögzítő csont",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Hordozás rögzítésének dőlésszöge.",
                    label = "Dőlésszög",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Hordozás rögzítésének forgásszöge.",
                    label = "Forgás",
                },
                medicCarryAttachOffsetsX = {
                    description = "Hordozás rögzítésének X eltolása.",
                    label = "X eltolás",
                },
                medicCarryAttachOffsetsY = {
                    description = "Hordozás rögzítésének Y eltolása.",
                    label = "Eltolás Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Hordozás rögzítésének csavarodási szöge.",
                    label = "Csavarodás",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Hordozás rögzítésének Z eltolása.",
                    label = "Z eltolás",
                },
                medicCarryCarrierAnimationDict = {
                    description = "A mentő által a beteg hordozásakor használt animációs szótár.",
                    label = "Animációs szótár",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "A mentő hordozó animációjához használt TaskPlayAnim jelző.",
                    label = "Animációs jelző",
                },
                medicCarryCarrierAnimationName = {
                    description = "A mentő által a beteg hordozásakor használt animációs vágány.",
                    label = "Animáció neve",
                },
                medicCarryEnabled = {
                    description = "A mentő hordozó rendszerének engedélyezése.",
                    label = "Engedélyezve",
                },
                medicCarryMaxDistance = {
                    description = "A beteg felvételéhez szükséges maximális távolság.",
                    label = "Maximális távolság",
                },
                medicCarryPassengerAnimationDict = {
                    description = "A hordozott beteg által használt animációs szótár.",
                    label = "Animációs szótár",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "A hordozott beteg animációjához használt TaskPlayAnim jelző.",
                    label = "Animációs jelző",
                },
                medicCarryPassengerAnimationName = {
                    description = "A hordozott beteg által használt animációs kliplista.",
                    label = "Animáció neve",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Élesítsd újra a halál animációját egy eszméletlen beteg leengedése után.",
                    label = "Halál animáció újraindítása",
                },
                medicCarryRequireOnDuty = {
                    description = "Csak szolgálatban lévő mentők indíthatnak hordozást.",
                    label = "Szolgálat kötelező",
                },
                medicReviveAllowFatalWounds = {
                    description = "Engedélyezi a szolgálatban lévő mentők számára a halálos vagy újraélethetetlen sérülések kezelését és újraélesztését. A lejárt vérzés továbbra is blokkolt marad.",
                    label = "Halálos sérülések engedélyezése",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Tartsd meg a megoldatlan sérüléseket a kezelés vagy lista alapú újraélesztés után.",
                    label = "Sérülések megtartása",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Tartsd meg a fájdalomértékeket a kezelés vagy lista alapú újraélesztés után, ha a sérüléseket megőrizzük.",
                    label = "Fájdalom megtartása",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximális távolság a betegek listázásához orvosi értékelés létrehozásakor.",
                    label = "Közelben lévő beteg körzete",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Azok a foglalkozások, amelyekre orvosi értékelést kiállíthatnak és megoszthatnak.",
                    label = "Célmunkakörök",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg születési dátumának megtekintését.",
                    label = "Születési dátum megosztása",
                },
                medicalEvaluationShareConclusion = {
                    description = "Engedélyezi az érintett foglalkozások számára a orvosi következtetés megtekintését.",
                    label = "Következtetés megosztása",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Engedélyezi az érintett foglalkozások számára a végrehajtott értékeléstípusok megtekintését.",
                    label = "Értékeléstípusok megosztása",
                },
                medicalEvaluationShareFullName = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg teljes nevének megtekintését.",
                    label = "Teljes név megosztása",
                },
                medicalEvaluationShareGender = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg nemének megtekintését.",
                    label = "Nem megosztása",
                },
                medicalEvaluationShareHeight = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg magasságának megtekintését.",
                    label = "Magasság megosztása",
                },
                medicalEvaluationShareHobbies = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg szabadidős tevékenységeinek és hobbjainak megtekintését.",
                    label = "Szabadidő és hobbi megosztása",
                },
                medicalEvaluationShareIssuer = {
                    description = "A szerző nevének megjelenítése. A kiállító foglalkozás mappája mindig látható a Megosztott dokumentumok között.",
                    label = "Szerzői adatok megosztása",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg személyi igazolványi azonosítójának megtekintését.",
                    label = "Személyi igazolvány megosztása",
                },
                medicalEvaluationShareProfession = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg szakmájának megtekintését.",
                    label = "Szakma megosztása",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Engedélyezi az érintett foglalkozások számára a kérdőíves kérdések és rögzített válaszok megtekintését.",
                    label = "Kérdések és válaszok megosztása",
                },
                medicalEvaluationShareResult = {
                    description = "Engedélyezi az érintett foglalkozások számára az értékelés állapotának (várakozó, sikeres, sikertelen) megtekintését.",
                    label = "Eredmény megosztása",
                },
                medicalEvaluationShareWeight = {
                    description = "Engedélyezi az érintett foglalkozások számára a beteg súlyának megtekintését.",
                    label = "Súly megosztása",
                },
                medicalEvaluationTypes = {
                    description = "Konfigurálja az értékeléstípusokat, kérdéseket, válaszlehetőségeket és az egyes kérdések aktív állapotát.",
                    label = "Értékeléstípusok és kérdőívek",
                    options = {
                        boolean = "Igen / Nem",
                        boolean_text = "Igen / Nem részletekkel",
                        date = "Dátum",
                        multi_select = "Többválasztós",
                        number = "Szám",
                        rating = "Értékelés",
                        select = "Egyszerű választós",
                        text = "Szöveg",
                        textarea = "Szövegtartomány",
                        time = "Idő",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Engedélyezi az orvosi értékeléseket a mentő tabletben.",
                    label = "Engedélyezve",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Állandó időtartamot biztosít, amely akkor is aktív marad, amíg egy mentőorvos nem távolítja el az orvosi segédeszközt.",
                    label = "Eltávolításig engedélyezve",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Megakadályozza a közelharcos támadásokat, amíg egy karöntet van felszerelve.",
                    label = "Közeli harc letiltása",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Kényszeríti a fegyver nélküli állapotot és megakadályozza a fegyvert váltást, amíg egy karöntet van felszerelve.",
                    label = "Fegyverek letiltása",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Alkalmazza a harc korlátozásait, amíg egy karöntet van felszerelve.",
                    label = "Engedélyezve",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Kezeli a megfelelő töréseket, amikor egy gipsz vagy sín kerül felhelyezésre.",
                    label = "Törés integráció",
                },
                medicalWearablesCastsEnabled = {
                    description = "Engedélyezi a bal/jobb kar- és lábönteteket.",
                    label = "Engedélyezve",
                },
                medicalWearablesCastsItem = {
                    description = "Inventáriumi tárgy, amely egy gipsz felhelyezésekor elhasználódik.",
                    label = "Tárgy",
                },
                medicalWearablesCastsMinigame = {
                    description = "Meglévő kezelési minijáték gipszekhez.",
                    label = "Minijáték",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Az orvosi segédeszköz alapértelmezett időtartama percben. 0 beállítása esetén az eltávolításig érvényes.",
                    label = "Alapértelmezett perc",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "A mentőorvosok számára megjelenő orvosi segédeszköz-időtartam-választási lehetőségek percben.",
                    label = "Időtartam-választási lehetőségek",
                },
                medicalWearablesEnabled = {
                    description = "Engedélyezi a gipsz, sín, kötés, nyakfűző és oxigénmaszk propokat a kezelési felületen.",
                    label = "Engedélyezve",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Az lejárt időzített orvosi segédeszközök eltávolításának gyakorisága.",
                    label = "Lejárati ellenőrzés másodpercben",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Engedélyezi a fejkötés propját.",
                    label = "Engedélyezve",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Inventáriumi tárgy, amelyet egy fejkötéshez használnak fel.",
                    label = "Tárgy",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Meglévő kezelési minijáték egy fejkötéshez.",
                    label = "Minijáték",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Megakadályozza az ugrást, amíg lábgipsz van felszerelve.",
                    label = "Ugrás letiltása",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Megakadályozza a szaladást, amíg lábgipsz van felszerelve.",
                    label = "Sprintelés letiltása",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Kényszeríti a sérült mozgási animációkat, amíg lábgipsz van felszerelve.",
                    label = "Sérült járás kényszerítése",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Mozgási sebesség felülírása, amíg lábgipsz van felszerelve.",
                    label = "Mozgási sebesség",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Alkalmazza a mozgási korlátozásokat, amíg egy lábszáröntet van felszerelve.",
                    label = "Engedélyezve",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Engedélyezi a nyakpánt propját.",
                    label = "Engedélyezve",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Inventáriumi tárgy, amelyet egy nyakpánthoz használnak fel.",
                    label = "Tárgy",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Meglévő kezelési minijáték egy nyakpánthoz.",
                    label = "Minijáték",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Engedélyezi az oxigénmaszk propját.",
                    label = "Engedélyezve",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Inventáriumi tárgy, amelyet egy oxigénmaszkhöz használnak fel.",
                    label = "Tárgy",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Meglévő kezelési minijáték egy oxigénmaszkhoz.",
                    label = "Minijáték",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Megjeleníti a betegeknek az aktív orvosi segédeszközeiket és a hátralévő viselési időt.",
                    label = "Engedélyezve",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Válassza ki, hol jelenjen meg a beteg orvosi segédeszköz UI-ja.",
                    label = "Pozíció",
                    options = {
                        ["bottom-center"] = "Alul középen",
                        ["bottom-left"] = "Alul bal oldalon",
                        ["bottom-right"] = "Alul jobb oldalon",
                        center = "Középre",
                        ["center-left"] = "Középen bal oldalon",
                        ["center-right"] = "Középen jobb oldalon",
                        ["top-center"] = "Felső középen",
                        ["top-left"] = "Felső bal oldalon",
                        ["top-right"] = "Felső jobb oldalon",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Visszaállítja az időzített gipszeket, rögzítő sínöket, nyakpántokat és törzskötéseket az újracsatlakozások és erőforrás-újraindítások után.",
                    label = "Orvosi segédeszközök tartósítása",
                },
                medicalWearablesRemoval = {
                    description = "Engedje meg a mentőknek, hogy a kezelési felületen eltávolítsák az aktív gipszeket, rögzítő sínöket, nyakpántokat és törzskötéseket.",
                    label = "Mentős eltávolítás",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Jelenítse meg a kezelési felületen az orvosi segédeszközök eltávolítását a beállított eszközzel.",
                    label = "Eltávolítási kezelés engedélyezve",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "A gyógyászati eszköz eltávolításához szükséges a újrahasználható tárolóeszköz.",
                    label = "Tárgy",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minijáték az orvosi segédeszközök eltávolításakor (alapértelmezés: cast_saw).",
                    label = "Minijáték",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Engedje meg a bal és jobb karra szánt karfelfüggesztő sínöket.",
                    label = "Engedélyezve",
                },
                medicalWearablesSplintsItem = {
                    description = "A sín felhelyezéséhez felhasznált tárolóeszköz.",
                    label = "Tárgy",
                },
                medicalWearablesSplintsMinigame = {
                    description = "A sínre szolgáló meglévő kezelési minijáték.",
                    label = "Minijáték",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Engedje meg a törzskötés propját.",
                    label = "Engedélyezve",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "A törzskötéshez felhasznált tárolóeszköz.",
                    label = "Tárgy",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "A törzskötéshez szolgáló meglévő kezelési minijáték.",
                    label = "Minijáték",
                },
                medicationsProfiles = {
                    description = "A kezelésre és öngyógyításra szolgáló deklaratív gyógyszerbejegyzések.",
                    itemLabel = "Gyógyszer",
                    label = "Gyógyszerek",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Engedélyezze a légzőzsák-minijátékot.",
                    label = "Légzőzsák",
                },
                minigamesCastSawEnabled = {
                    description = "Bekapcsolja a fűrészes minijátékot az orvosi segédeszközök eltávolításához.",
                    label = "Gipszfűrész",
                },
                minigamesBandageWrapEnabled = {
                    description = "Engedélyezze a kötszerfeltekercselés minijátékot.",
                    label = "Kötésfeltekercselés",
                },
                minigamesBandageWrapRandomization = {
                    description = "Változtassa meg véletlenszerűen a kötszerút irányát, alakját és arányait.",
                    label = "Kötésfeltekercselés változat",
                },
                minigamesBloodPressureEnabled = {
                    description = "Engedélyezze a vérnyomás-minijátékot.",
                    label = "Vérnyomás",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Változtassa meg véletlenszerűen az érrendszeri hozzáférés útját a vérátömlesztéshez.",
                    label = "Vérátömlesztési hozzáférés változat",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Engedélyezze a vérátömlesztés minijátékot.",
                    label = "Vérátadás",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "A véráramlási szabályozás előtt a több lépésből álló érrendszeri hozzáférési eljárást igényli. Tiltsa le a régi egyszerű verzióhoz.",
                    label = "Érrendszeri hozzáférés szakasz",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Engedélyezze a golyóeltávolítás minijátékot.",
                    label = "Golyóeltávolítás",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Változtassa meg véletlenszerűen a sebcsatorna alakját, szélességét és akadályait.",
                    label = "Golyóeltávolítás változat",
                },
                minigamesCprBreathsPerCycle = {
                    description = "A légzési ciklusokhoz szükséges lélegzetvételek száma.",
                    label = "Lélegzetvételek ciklusonként",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "A kompressziós sorozat befejezéséhez szükséges másodpercek.",
                    label = "Kompressziós sorozat időtartama",
                },
                minigamesCprCompressionWindow = {
                    description = "Engedélyezett eltolás a kompressziós ütem elérésénél.",
                    label = "Kompressziós ablak",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Engedélyezze a CPR kompressziós minijáték szakaszát.",
                    label = "CPR Kompressziók",
                },
                minigamesCprCompressionsPerSet = {
                    description = "A kompressziós sorozatonkénti kompressziók száma.",
                    label = "Kompressziók sorozatonként",
                },
                minigamesCprCycles = {
                    description = "Hány CPR ciklus szükséges a minijáték befejezéséhez.",
                    label = "Ciklusok",
                },
                minigamesCprEnabled = {
                    description = "Engedélyezze a CPR minijátékot.",
                    label = "Szív-masszázs",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Visszaszámlálás a CPR kompressziók megkezdése előtt.",
                    label = "Bevezető késleltetés (másodperc)",
                },
                minigamesCprMaxMisses = {
                    description = "Engedélyezett hibák száma a CPR minijáték kudarcához.",
                    label = "Maximális elütés",
                },
                minigamesCprSetsPerCycle = {
                    description = "Hány összenyomási ciklus fut le egy légzési szakasz előtt.",
                    label = "Ciklusonkénti összenyomások száma",
                },
                minigamesCprVentilationEnabled = {
                    description = "Engedélyezi a CPR légzési minijáték szakaszát.",
                    label = "CPR Légzés",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Engedélyezi a vércukormérő minijátékot.",
                    label = "Vércukormérő",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Engedélyezi a pulzusszámoló minijátékot.",
                    label = "Pulzusszámolás",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Engedélyezi a pulzusszaturációs mérő minijátékot.",
                    label = "Pulzusszaturációs mérő",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Engedélyezi a sóoldatos infúzió minijátékot.",
                    label = "Sóoldatos infúzió",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Hány másodperccel lejár a szellőzési kísérlet. Állítsd 0-ra a letiltáshoz.",
                    label = "Légzési időtúllépés (másodperc)",
                },
                minigamesVentilationEnabled = {
                    description = "Engedélyezi a szellőzési minijátékot.",
                    label = "Légzésműteti ellátás",
                },
                minigamesVentilationTolerance = {
                    description = "Pixel távolsági tűrés a légáramlás hullámának követésekor.",
                    label = "Tolerancia",
                },
                operationsBreakDistance = {
                    description = "A résztvevők maximális távolsága a szobától a beavatkozás megszakítása előtt.",
                    label = "Megszakítási távolság",
                },
                operationsDoctorAnimationDict = {
                    description = "A sebész élő beavatkozás során használt GTA animációs szótára.",
                    label = "Sebész animációs szótár",
                },
                operationsDoctorAnimationFlag = {
                    description = "A sebész élő beavatkozási animációjára alkalmazott GTA animációs jelző.",
                    label = "Sebész animációs jelző",
                },
                operationsDoctorAnimationName = {
                    description = "A sebész élő beavatkozás során használt animációs klip.",
                    label = "Sebész animáció neve",
                },
                operationsEnabled = {
                    description = "Engedélyezi az operációs szobákat és a sebészeti beavatkozásokat.",
                    label = "Engedélyezve",
                },
                operationsFadeInMs = {
                    description = "A beteg ébredési képernyő beolvadásának időtartama milliszekundumban.",
                    label = "Ébredés beolvadása (ms)",
                },
                operationsFadeOutMs = {
                    description = "A beteg érzéstelenítő képernyő elhalványulásának időtartama milliszekundumban.",
                    label = "Érzéstelenítés elhalványulása (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "A maximális idő egy érvényes minijáték-művelet nélkül, mielőtt a munkamenet megszakadna.",
                    label = "Inaktivitás időtúllépés (másodperc)",
                },
                operationsInteractDistance = {
                    description = "A maximális távolság az operációs szoba interakciók megjelenítéséhez és használatához.",
                    label = "Interakciós távolság",
                },
                operationsInteractKey = {
                    description = "A használt vezérlőazonosító az operációs asztallal és a sebész pozíciójával való interakcióhoz.",
                    label = "Interakciós gomb",
                },
                operationsPatientAnimationDict = {
                    description = "A teljes érzéstelenítés alatt fekvő betegre alkalmazott GTA animációs szótár.",
                    label = "Beteg animációs szótár",
                },
                operationsPatientAnimationFlag = {
                    description = "A beteg fekvő animációjára alkalmazott GTA animációs jelző.",
                    label = "Beteg animációs jelző",
                },
                operationsPatientAnimationName = {
                    description = "A beteg teljes érzéstelenítés alatt fekvésére használt animációs klip.",
                    label = "Beteg animáció neve",
                },
                operationsPatientRange = {
                    description = "A beteg az operációs asztalon fekvésének érzékeléséhez használt maximális hatótávolság.",
                    label = "Beteg hatótávolság",
                },
                operationsRequireOnDuty = {
                    description = "Kötelező, hogy a sebészek szolgálatban legyenek az operációs szoba használatához.",
                    label = "Szolgálat kötelező",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "A maximális idő, amelyet a sebész a beavatkozási kiválasztásban tölthet, mielőtt a munkamenet megszakadna.",
                    label = "Kiválasztás időtúllépés (másodperc)",
                },
                operationsTrainingAnimationDict = {
                    description = "A beteg nélküli sebészeti képzéshez használt GTA animációs szótár.",
                    label = "Tréning animációs szótár",
                },
                operationsTrainingAnimationFlag = {
                    description = "A sebészeti tréninganimációhoz alkalmazott GTA animációs zászló.",
                    label = "Tréning animációs zászló",
                },
                operationsTrainingAnimationName = {
                    description = "A beteg nélküli sebészeti tréninghez használt animációs klip.",
                    label = "Tréning animáció neve",
                },
                painClassesProfiles = {
                    description = "Fájdumegyek, címkék és utófeldolgozási effektek.",
                    label = "Fájdum osztályok",
                },
                painEffectsMinPainLevel = {
                    description = "A képernyőeffektek beindulásához szükséges minimális fájdalom szint.",
                    label = "Min. fájdalom szint",
                },
                primaryColor = {
                    description = "A mentős felület és munkacsoport fő színe.",
                    label = "Elsődleges szín",
                },
                propPlacementConsumeItem = {
                    description = "A tárgy elhelyezésekor a megfelelő készlettárgy elhasználása.",
                    label = "Tárgy elhasználása",
                },
                propPlacementEnabled = {
                    description = "A konfigurált ELS-tárgyak elhelyezése használható készlettárgyakból.",
                    label = "Engedélyezve",
                },
                propPlacementItemNames = {
                    description = "ELS-tárgymodellek hozzárendelése készlettárgy-nevekhez tárgy-alapú elhelyezéshez.",
                    label = "Tárgy-nevek",
                },
                propPlacementRequireOnDuty = {
                    description = "A játékosnak szolgálatban kell lennie az ELS-tárgyak elhelyezése előtt.",
                    label = "Szolgálat kötelező",
                },
                propPlacementReturnItem = {
                    description = "A tárgy visszaadása, amikor egy elhelyezett tárgyat eltávolítják.",
                    label = "Tárgy visszaadása eltávolításkor",
                },
                propPlacementVehicleAccess = {
                    description = "A csomagtéridő-tárgyaknak engedélyezve a helyezés folyamatának megnyitása, nem csak tárgyként használva.",
                    label = "Jármű hozzáférés",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Az éber játékosoknál engedélyezett nyilvános kezelés.",
                    label = "Éber betegek engedélyezése",
                },
                publicTreatmentAllowedGangs = {
                    label = "Engedélyezett bandák",
                    description = "Válaszd a bandák vagy független szervezetek belső neveit. Az egyező foglalkozás vagy banda engedélyt vagy kivételt ad. A szolgálati követelmény csak a foglalkozásokra érvényes. Opcionális minimális bandarangi követelmények. Üres lista esetén minden rang engedélyezett. A tárgykövetelmények továbbra is érvényesek.",
                },
                publicTreatmentAllowedJobs = {
                    description = "A nyilvános kezeléshez jogosult nem-ELS válaszoló munkák.",
                    label = "Engedélyezett foglalkozások",
                },
                publicTreatmentEnabled = {
                    description = "Nyilvános kezelés engedélyezése jogosult nem-ELS válaszolóknak.",
                    label = "Nyilvános kezelés engedélyezve",
                },
                publicTreatmentInteractDistance = {
                    description = "A nyilvános kezelés indításához szükséges maximális távolság.",
                    label = "Interakciós távolság",
                },
                publicTreatmentKeybind = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Elsősegély nyújtása",
                },
                publicTreatmentInteractionEnabled = {
                    description = "A kezelési felhívás megjelenítése és a hozzá tartozó billentyű engedélyezése. Exportok vagy egyéni sugárzó menü használatakor tiltsa le.",
                    label = "Billentyűzet-interakció engedélyezve",
                },
                publicTreatmentPromptDistance = {
                    description = "A nyilvános kezelési felhívás megjelenítéséhez használt távolság.",
                    label = "Felugró ablak távolsága",
                },
                publicTreatmentRequireAllItems = {
                    description = "Minden felsorolt orvosi tárgy megkövetelése, nem csak egy.",
                    label = "Minden tárgy megkövetelése",
                },
                publicTreatmentRequiredItems = {
                    description = "A nyilvános kezeléshez szükséges készlettárgyak.",
                    itemLabel = "Tárgy",
                    label = "Szükséges tárgyak",
                },
                reviveRewardAccount = {
                    description = "A feltámasztási jutalomfizetésekhez használt elsődleges fiók kulcs.",
                    label = "fiók",
                },
                reviveRewardAccountType = {
                    description = "A feltámasztási jutalomfizetésekhez használt elsődleges fiók típus.",
                    label = "Fiók típusa",
                },
                reviveRewardAmount = {
                    description = "A feltámasztásért a mentőnek kifizetett jutalom összege.",
                    label = "Összeg",
                },
                reviveRewardCurrency = {
                    description = "Opcionális egyéni pénznem kulcsa a feltámasztási jutalomfizetésekhez.",
                    label = "Pénznem",
                },
                reviveRewardEnabled = {
                    description = "Jutalom kifizetése sikeres mentő-feltámasztás után.",
                    label = "Engedélyezve",
                },
                reviveRewardPayFromSociety = {
                    description = "A feltámasztási jutalmak levonása a munkák közös társasági fiókjaiból a mentő fizetése előtt.",
                    label = "Fiókból történő kifizetés",
                },
                selfDiagnoseCommand = {
                    description = "A saját diagnózis megnyitásához használt chat parancs.",
                    label = "Parancs",
                },
                selfDiagnoseEnabled = {
                    description = "A játékosok számára engedélyezett saját diagnózis felület megnyitása.",
                    label = "Saját diagnózis engedélyezve",
                },
                selfDiagnoseKeybind = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Saját diagnózis billentyű",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "A saját diagnózis felület megnyitásához szükséges késleltetés.",
                    label = "Nyitási késleltetés (ms)",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "A saját diagnózis korlátozása kizárólag mentő munkákra.",
                    label = "Mentő munka megkövetelése",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "A játékos nem fagy le a saját diagnózis során.",
                    label = "Önfagyasztás átlépése",
                },
                statusEffectsProfiles = {
                    description = "Beállított képernyőeffektek és küszöbértékek vérzésre, alacsony vérállapotra, éhségre és szomjúságra.",
                    label = "Státuszhatások",
                },
                stretcherAnimDict = {
                    description = "A hordágy hordozása közben használt animációs szótár.",
                    label = "Animációs szótár",
                },
                stretcherAnimName = {
                    description = "A hordágy hordozása közben használt animáció neve.",
                    label = "Animáció neve",
                },
                stretcherAttachRx = {
                    description = "A hordágy hordozásához tartozó X tengely körüli elforgatás.",
                    label = "Rögzítés X",
                },
                stretcherAttachRy = {
                    description = "A hordágy hordozásához tartozó Y tengely körüli elforgatás.",
                    label = "Rögzítés Y",
                },
                stretcherAttachRz = {
                    description = "A hordágy hordozásához tartozó Z tengely körüli elforgatás.",
                    label = "Rögzítés Z",
                },
                stretcherAttachX = {
                    description = "A hordágy hordozásához tartozó X tengely menti eltolás.",
                    label = "Rögzítés X",
                },
                stretcherAttachY = {
                    description = "A hordágy hordozásához tartozó Y tengely menti eltolás.",
                    label = "Rögzítés Y",
                },
                stretcherAttachZ = {
                    description = "A hordágy hordozásához tartozó Z tengely menti eltolás.",
                    label = "Rögzítés Z",
                },
                stretcherFoldedEnabled = {
                    description = "Az járművekben használatos, opcionálisan összecsukható hordágy-variáns engedélyezése.",
                    label = "Összecsukott engedélyezve",
                },
                stretcherFoldedModel = {
                    description = "Az összecsukott hordágy-variánshoz használt prop-modell.",
                    label = "Összecsukott modell",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Az összecsukott hordágy-variánshoz használt páciens iránya.",
                    label = "Összecsukott páciens iránya",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Az összecsukott hordágyhoz tartozó páciens X tengely menti eltolás.",
                    label = "Összecsukott páciens X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Az összecsukott hordágyhoz tartozó páciens Y tengely menti eltolás.",
                    label = "Összecsukott páciens Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Az összecsukott hordágyhoz tartozó páciens Z tengely menti eltolás.",
                    label = "Összecsukott páciens Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Helikopterekre használt interakciós távolság-átírás.",
                    label = "Helikopter interakciós távolság",
                },
                stretcherHelicopterModels = {
                    description = "Hordágy-helikopterként kezelt járműmodellek.",
                    itemLabel = "Modell",
                    label = "Helikopter modellek",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Helikopterekre használt felvételi távolság-átírás.",
                    label = "Helikopter felvételi távolság",
                },
                stretcherInteractDistance = {
                    description = "A hordágy interakciós felugrók maximális távolsága.",
                    label = "Interakciós távolság",
                },
                stretcherItemEnabled = {
                    description = "A hordágy-inventár-tárgy engedélyezése, beleértve a bolti vásárlást és használatot.",
                    label = "Hordágy-tárgy",
                },
                stretcherItemPickupEnabled = {
                    description = "Engedélyezi a hordágyak visszavételét az inventárba, ha azokat az inventár-tárgyból helyezték el.",
                    label = "Tárgy felvétele",
                },
                stretcherModel = {
                    description = "Az EMS hordágy-rendszer által használt elsődleges hordágy-prop-modell.",
                    label = "Modell",
                },
                stretcherPatientAnimationDict = {
                    description = "A hordágy-páciensekre és az előnézeti NPC-re használt animációs szótár.",
                    label = "Páciens animációs szótár",
                },
                stretcherPatientAnimationName = {
                    description = "A hordágy-páciensekre és az előnézeti NPC-re használt animációs klip neve.",
                    label = "Páciens animációs név",
                },
                stretcherPatientAttachHeading = {
                    description = "A hordágyon fekvő páciens irány.",
                    label = "Páciens irány",
                },
                stretcherPatientAttachX = {
                    description = "A hordágyon lévő páciens X tengely menti eltolása.",
                    label = "Páciens X",
                },
                stretcherPatientAttachY = {
                    description = "A hordágyon lévő páciens Y tengely menti eltolása.",
                    label = "Páciens Y",
                },
                stretcherPatientAttachZ = {
                    description = "A hordágyon lévő páciens Z tengely menti eltolása.",
                    label = "Páciens Z",
                },
                stretcherPickupDistance = {
                    description = "A hordágy felvétele és vele való interakcióhoz szükséges távolság.",
                    label = "Felvételi távolság",
                },
                stretcherTreatmentAnimClip = {
                    description = "A hordágyon lévő beteg kezeléséhez használt animációs klip. Hagyd üresen, hogy egy forgatókönyvet vagy a kezelési animáció alapértelmezett változatát használja.",
                    label = "Animáció neve",
                },
                stretcherTreatmentAnimDict = {
                    description = "A hordágyon lévő beteg kezeléséhez használt animációs könyvtár. Hagyd üresen, hogy egy forgatókönyvet vagy a kezelési animáció alapértelmezett változatát használja.",
                    label = "Animációs szótár",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Opcionális forgatókönyv a hordágyon lévő beteg kezeléséhez. Hagyd üresen, hogy a könyvtár + klipet vagy a kezelési animáció alapértelmezett változatát használja.",
                    label = "Szituáció",
                },
                stretcherVehicleAttachEditor = {
                    description = "A hordágy pozicionálása és elforgatása egy beállított mentőautóban.",
                    label = "Járműcsatlakoztatás",
                },
                stretcherVehicleAttachRx = {
                    description = "A hordágy betöltéséhez szükséges jármű X tengely körüli elforgatása.",
                    label = "Jármű X elforgatás",
                },
                stretcherVehicleAttachRy = {
                    description = "A hordágy betöltéséhez szükséges jármű Y tengely körüli elforgatása.",
                    label = "Jármű Y elforgatás",
                },
                stretcherVehicleAttachRz = {
                    description = "A hordágy betöltéséhez szükséges jármű Z tengely körüli elforgatása.",
                    label = "Jármű Z elforgatás",
                },
                stretcherVehicleAttachX = {
                    description = "A hordágy betöltéséhez szükséges jármű X tengely menti eltolása.",
                    label = "Jármű X eltolás",
                },
                stretcherVehicleAttachY = {
                    description = "A hordágy betöltéséhez szükséges jármű Y tengely menti eltolása.",
                    label = "Jármű Y eltolás",
                },
                stretcherVehicleAttachZ = {
                    description = "A hordágy betöltéséhez szükséges jármű Z tengely menti eltolása.",
                    label = "Jármű Z eltolás",
                },
                stretcherVehicleModels = {
                    description = "A hordágyat betölthető járműmodellek.",
                    itemLabel = "Modell",
                    label = "Járműmodellek",
                },
                treatmentAnimClip = {
                    description = "A beteg kezeléséhez használt animációs klip. Hagyd üresen, hogy egy forgatókönyvet használjon.",
                    label = "Animáció neve",
                },
                treatmentAnimDict = {
                    description = "A beteg kezeléséhez használt animációs könyvtár. Hagyd üresen, hogy egy forgatókönyvet használjon.",
                    label = "Animációs szótár",
                },
                treatmentAnimScenario = {
                    description = "A beteg kezeléséhez használt forgatókönyv. Hagyd üresen, hogy a könyvtár + klipet használja.",
                    label = "Szituáció",
                },
                trunkPropsEnabled = {
                    label = "Járműkellékek",
                    description = "Válassz kellékeket egy közeli szolgálati járműnél.",
                },
                trunkEnabled = {
                    description = "A mentőautók csomagtér-funkciójának engedélyezése.",
                    label = "Engedélyezve",
                },
                vehicleDamageModifier = {
                    description = "A járműben tartózkodó játékosra alkalmazott sérülési szorzó.",
                    label = "Járműsérülési szorzó",
                },
                vehicleImpactProtectionCauses = {
                    description = "Azok a halálok, amelyek védett járműbalesetnek minősülnek.",
                    itemLabel = "Ok",
                    label = "Sérülés okai",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Megakadályozza, hogy az alacsony sebességű járműbalesetek megöljék a játékost.",
                    label = "Engedélyezve",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Ennél a sebességnél alacsonyabb sebességű járműbalesetek nem ölhetik meg a játékost.",
                    label = "Halálos sebesség (km/h)",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Ennél a sebességnél vagy ennél nagyobb sebességű járműbalesetek a normál halálos sérülési konfigurációt használják.",
                    label = "Teljes sérülés sebessége (km/h)",
                },
                vehicleImpactProtectionInjuries = {
                    description = "A sérülések, amelyeket alkalmaznak, amikor a járműbaleset-védelem megakadályoz egy halálos találatot.",
                    itemLabel = "Sérülés",
                    label = "Sérülések",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "A maximális egészségből megmaradó százaléka, amikor egy védett ütközés megölte volna a játékost.",
                    label = "Életben maradási egészségi százalék",
                },
                vehiclePullEnabled = {
                    description = "A betegek kivezetésének engedélyezése járművekből.",
                    label = "Engedélyezve",
                },
                vehiclePullMaxDistance = {
                    description = "A beteg kivezetéséhez szükséges maximális távolság.",
                    label = "Maximális távolság",
                },
                wheelchairAssignMaxDistance = {
                    description = "A kerekesszék másik játékosnak történő kiosztásához szükséges maximális távolság.",
                    label = "Kiosztás maximális távolsága",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "A kerekesszék automatikus levetése, amikor a kiosztás lejárt.",
                    label = "Automatikus levetés lejáratkor",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "A kerekesszék alapértelmezett kiosztási ideje percben.",
                    label = "Alapértelmezett időtartam",
                },
                wheelchairDisableSprint = {
                    description = "A kerekesszék használat közbeni futásblokkolás.",
                    label = "Sprintelés letiltása",
                },
                wheelchairDisableWeapons = {
                    description = "A kerekesszék használat közbeni fegyverhasználat blokkolása.",
                    label = "Fegyverek letiltása",
                },
                wheelchairExitControl = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Kikerül a kerekesszékből",
                },
                wheelchairItemName = {
                    description = "A kerekesszékhez használt inventár tárgy.",
                    label = "Tárgy neve",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximálisan megengedett kerekességes beosztás időtartama percben.",
                    label = "Maximális időtartam",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimálisan megengedett kerekességes beosztás időtartama percben.",
                    label = "Minimális időtartam",
                },
                wheelchairVehicle = {
                    description = "A kerekességhöz használt járműmodell.",
                    label = "Járműmodell",
                },
                xrayInteractionRange = {
                    description = "A kezelő maximális távolsága az röntgenállomástól.",
                    label = "Interakciós tartomány",
                },
                xrayPatientRange = {
                    description = "A beteg maximális távolsága az röntgenállomástól.",
                    label = "Páciens tartomány",
                },
                xrayScanDurationSeconds = {
                    description = "Az röntgenfelvétel eredményének megjelenítési ideje másodpercben.",
                    label = "Scan időtartam",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Lehetővé teszi, hogy a munkavállalók önszervezésben jelentkezzenek be a elérhető képzésekre.",
                approvalRequired = "Az önszervezési jelentkezéseket csak egy jogosult oktató hagyja jóvá.",
                defaultCapacity = "Alapértelmezett ülőhelyek száma egy új képzés létrehozásakor.",
                enabled = "Megtehetővé teszi a képzési alkalmazást ehhez a munkához.",
                requireOnDuty = "A munkavállalóknak szolgálatban kell lenniük a képzési alkalmazás megnyitása vagy használata előtt.",
                upcomingDays = "A képzési alkalmazás naptárában megjelenő jövőbeli napok száma.",
            },
            trainingFields = {
                allowSelfEnrollment = "Önszervezés engedélyezése",
                approvalRequired = "Jelentkezési jóváhagyás szükséges",
                defaultCapacity = "Alapkapacitás",
                enabled = "Képzés engedélyezése",
                requireOnDuty = "Szolgálati kötelezettség",
                upcomingDays = "Jövőbeli időszak (napok)",
            },
            warnings = {
                firstAidPublicTreatmentConflict = "Az Elsősegély és a Nyilvános Kezelés egyszerre nem aktiválható. A mentés során mindkettő le lesz tiltva.",
            },
        },
    },
}
