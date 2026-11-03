JobConfigLocales["sky_firejob:hu"] = {
    Nui = {
        workshopConfig = {
            configs = {
                sky_firejob = {
                    subtitle = "Konfiguráld a tűzoltó munkaköröket, a gyújtószerszámok működését, a járműtűzeket, a műszaki mentést, az NPC-mentési folyamatokat, a tűzoltóállomásokat és a misszióalkotó beállításait.",
                    title = "Tűzoltó munkakörök",
                },
            },
            creatorSections = {
                fireStations = {
                    entryLabel = "Tűzoltóállomás",
                    entryPluralLabel = "Tűzoltóállomások",
                    label = "Tűzoltóállomások",
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
            extinguisherMaintenanceStates = {
                checked = "Ellenőrzött",
                damaged = "Sérült",
                empty = "Üres",
                missing = "Nincs tűzoltó készülék",
            },
            extinguisherMountStates = {
                empty = "Üres tartó",
                mounted = "Rögzített tűzoltó készülék",
            },
            features = {
                waterMonitor = {
                    description = "Nagyobb tűzek oltása folyamatos vízsugárral és beállítható dőlésszöggel. Egy ellátócső szükséges a tűzoltó járműhöz, amely tankvízzel, hidránnal vagy szivattyúval van felszerelve.",
                    label = "Vízszóró",
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
            misc = {
                defaultFireTruckLabel = "Tűzoltóautó",
                fireStationCategoryLabel = "Tűzoltóállomás",
                fireStationEntryLabel = "Tűzoltóállomás",
                fireStationPosition = "Tűzoltóállomás pozíciója",
                fireStationsTitle = "Tűzoltóállomások",
                hoseConnectionEditorTitle = "Sugárcső-csatlakozás szerkesztő",
                hydrantConnectionEditorTitle = "Hidráns-csatlakozás szerkesztő",
                pumpIntakeEditorTitle = "Szivattyú-beömlő szerkesztő",
                pumpOutletEditorTitle = "Szivattyú-kifolyó szerkesztő",
                pumpPanelAccessEditorTitle = "Szivattyúpanel hozzáférési szerkesztő",
                scbaRefillBlipLabel = "SCBA utántöltés",
                scbaRefillStationLabel = "SCBA utántöltő állomás",
            },
            settingFields = {
                cannonId = "Vízágyú azonosítója",
                cannonLabel = "Vízágyú neve",
                reason = "Indok",
                airBottleSlots = "Levegőpalack-helyek",
                amount = "Összeg",
                automatic = "Automatikus",
                canSpread = "Elterjedhet",
                component = "Komponens",
                connection = "Kapcsolat",
                currentPosition = "Jelenlegi pozíció",
                delete = "Törlés",
                description = "Leírás",
                dispatchJobs = "Diszpécseri munkák",
                drawables = "Rajzok",
                enabled = "Engedélyezve",
                fillLevel = "Töltöttségi szint",
                fireType = "Tűz típusa",
                foamTankEnabled = "Habtartály",
                foamTankSize = "Hab liter",
                gearKey = "Típus",
                hydrantConnection = "Hidráns-csatlakozás",
                hydrantRx = "Tűzcsap X tengely körüli forgatása",
                hydrantRy = "Tűzcsap Y tengely körüli forgatása",
                hydrantRz = "Tűzcsap Z tengely körüli forgatása",
                hydrantX = "Tűzcsap X pozíció",
                hydrantY = "Tűzcsap Y pozíció",
                hydrantZ = "Tűzcsap Z pozíció",
                id = "ID",
                igniteDistance = "Gyújtási távolság",
                intensity = "Intenzitás",
                job = "Munkahely",
                jobs = "Szolgálati munkák",
                key = "Billentyű",
                label = "Címke",
                location = "Helyszín",
                maintenanceStatus = "Karbantartás",
                minOnDuty = "Szolgálatra szükség van",
                minimum = "Online minimum",
                mission = "Művelet",
                model = "Modell",
                name = "Név",
                prop = "Tárgy",
                pumpConnections = "Szivattyúkapcsolatok",
                pumpDischargeCount = "Szivattyúkilövések",
                pumpIntake1Connection = "Bemenet 1",
                pumpIntake1Label = "Bemenet 1 – Megnevezés",
                pumpIntake1Rx = "Bemenet 1 – Forgás X",
                pumpIntake1Ry = "Bemenet 1 – Forgás Y",
                pumpIntake1Rz = "Bemenet 1 – Forgás Z",
                pumpIntake1X = "Bemenet 1 – X",
                pumpIntake1Y = "Bemenet 1 – Y",
                pumpIntake1Z = "Bemenet 1 – Z",
                pumpIntake2Connection = "Bemenet 2",
                pumpIntake2Label = "Bemenet 2 – Megnevezés",
                pumpIntake2Rx = "Bemenet 2 – Forgás X",
                pumpIntake2Ry = "Bemenet 2 – Forgás Y",
                pumpIntake2Rz = "Bemenet 2 – Forgás Z",
                pumpIntake2X = "Bemenet 2 – X",
                pumpIntake2Y = "Bemenet 2 – Y",
                pumpIntake2Z = "Bemenet 2 – Z",
                pumpIntakeCount = "Szivattyúbemenetek",
                pumpOutlet1Connection = "Kimenet 1",
                pumpOutlet1Label = "Kimenet 1 – Megnevezés",
                pumpOutlet1Rx = "Kimenet 1 – Forgás X",
                pumpOutlet1Ry = "Kimenet 1 – Forgás Y",
                pumpOutlet1Rz = "Kimenet 1 – Forgás Z",
                pumpOutlet1X = "Kimenet 1 – X",
                pumpOutlet1Y = "Kimenet 1 – Y",
                pumpOutlet1Z = "Kimenet 1 – Z",
                pumpOutlet2Connection = "Kimenet 2",
                pumpOutlet2Label = "Kimenet 2 – Megnevezés",
                pumpOutlet2Rx = "Kimenet 2 – Forgás X",
                pumpOutlet2Ry = "Kimenet 2 – Forgás Y",
                pumpOutlet2Rz = "Kimenet 2 – Forgás Z",
                pumpOutlet2X = "Kimenet 2 – X",
                pumpOutlet2Y = "Kimenet 2 – Y",
                pumpOutlet2Z = "Kimenet 2 – Z",
                pumpOutlet3Connection = "Kimenet 3",
                pumpOutlet3Label = "Kimenet 3 – Megnevezés",
                pumpOutlet3Rx = "Kimenet 3 – Forgás X",
                pumpOutlet3Ry = "Kimenet 3 – Forgás Y",
                pumpOutlet3Rz = "Kimenet 3 – Forgás Z",
                pumpOutlet3X = "Kimenet 3 – X",
                pumpOutlet3Y = "Kimenet 3 – Y",
                pumpOutlet3Z = "Kimenet 3 – Z",
                pumpOutlet4Connection = "Kimenet 4",
                pumpOutlet4Label = "Kimenet 4 – Megnevezés",
                pumpOutlet4Rx = "Kimenet 4 – Forgás X",
                pumpOutlet4Ry = "Kimenet 4 – Forgás Y",
                pumpOutlet4Rz = "Kimenet 4 – Forgás Z",
                pumpOutlet4X = "Kimenet 4 – X",
                pumpOutlet4Y = "Kimenet 4 – Y",
                pumpOutlet4Z = "Kimenet 4 – Z",
                pumpPanelAccess = "Csővezérlés hozzáférése",
                pumpPanelConfigured = "Panel konfigurálva",
                pumpPanelSize = "Panel mérete",
                pumpPanelX = "X. panel",
                pumpPanelY = "Y panel",
                pumpPanelZ = "Z panel",
                resource = "Erőforrás",
                rx = "Rotáció X",
                ry = "Rotáció Y",
                rz = "Rotáció Z",
                scenario = "Művelet",
                sourceScale = "Forrás skálázása",
                state = "Hordozó állapota",
                teleport = "Teleportálás",
                textures = "Textúrák",
                turretBone = "Cső csont",
                turretMuzzleOffsetX = "Műszájrész eltolás X",
                turretMuzzleOffsetY = "Műszájrész eltolás Y",
                turretMuzzleOffsetZ = "Műszájrész eltolás Z",
                turretOffsetX = "Torny eltolás X",
                turretOffsetY = "Torny eltolás Y",
                turretOffsetZ = "Torny eltolás Z",
                turretTipOffset = "Csőcsúcs távolság",
                waterGravityScale = "Víz gravitációja",
                waterTankEnabled = "Víz tartály",
                waterTankSize = "Víz mennyiség literben",
                waterVelocity = "Víz sebessége",
                weather = "Időjárás típusa",
                x = "X",
                y = "Y",
                z = "Z",
                zOffset = "Z eltolás",
            },
            settingGroups = {
                billing = {
                    label = "Számlák",
                },
                absorbentMinigame = {
                    description = "Szívóanyag szétterjesztéses kisjáték vezérlése.",
                    label = "Szívóanyag kisjáték",
                },
                access = {
                    label = "Hozzáférés",
                },
                air = {
                    label = "Légzési levegő",
                },
                airItem = {
                    label = "Légzőgáz palack tárgy",
                },
                airRefill = {
                    label = "Légzőgáz utántöltés",
                },
                ambulance = {
                    label = "Katasztrófavédelem",
                },
                animals = {
                    label = "Állatmentés",
                },
                attachment = {
                    label = "Csatlakozó",
                },
                automaticMissionDispatch = {
                    description = "Automatikusan és manuálisan indított küldetésekhez történő riasztások létrehozásának vezérlése.",
                    label = "Diszpécser",
                },
                automaticMissionJobs = {
                    description = "Ezeket a foglalkozásokat használja, ha egy küldetésnek nincs küldetés-specifikus foglalkozása.",
                    label = "Alapértelmezett szolgálati foglalkozások",
                },
                automaticMissionList = {
                    description = "A Misszióalkotó összes küldetése automatikusan felsorolásra kerül.",
                    label = "Elérhető küldetések",
                },
                automaticMissionTiming = {
                    description = "Vezérli, hogy mikor próbálja meg a programozó elindítani egy automatikus küldetést.",
                    label = "Automatikus indító",
                },
                breathing = {
                    label = "Légzés",
                },
                breathingClothing = {
                    label = "Légzésvédelmi ruha",
                },
                burnDamage = {
                    label = "Égési sérülés",
                },
                cleanup = {
                    description = "Szükséges tisztítási tárgyak, tárgyfelhasználás és visszalépési előrehaladási idő vezérlése.",
                    label = "Tisztítási folyamat",
                },
                consumption = {
                    label = "Fogyasztás",
                },
                creator = {
                    label = "Készítő",
                },
                detection = {
                    label = "Érzékelés",
                },
                dispatch = {
                    label = "Ügyelet",
                },
                distance = {
                    label = "Távolságok",
                },
                dump = {
                    label = "Vízlerakás",
                },
                effects = {
                    label = "Effektek",
                },
                engineBehavior = {
                    label = "Járműbiztonság",
                },
                engineOutput = {
                    label = "Motorerő",
                },
                engineRetention = {
                    label = "Motorleállás",
                },
                enterAnimation = {
                    label = "Belépő animáció",
                },
                exitAnimation = {
                    label = "Kilépő animáció",
                },
                explosion = {
                    label = "Robbanás",
                },
                external = {
                    label = "Külső",
                },
                extinguish = {
                    label = "Oltás",
                },
                extinguisher = {
                    label = "Tűzoltó",
                },
                femaleBreathingClothing = {
                    label = "Légzésvédelmi ruha",
                },
                femaleHeatClothing = {
                    label = "Hővédő ruha",
                },
                femaleProtectiveMaskClothing = {
                    label = "Arcvédő maszkos ruha",
                },
                fieldFlow = {
                    label = "Bevetési folyamat",
                },
                fireExtinguishFeedback = {
                    label = "Tűzoltó visszajelzés",
                },
                fireParticles = {
                    label = "Tűz és füst",
                },
                fireReward = {
                    description = "Meghatározza a társaság számlájára utalt összeget, amikor egy önálló tüzet teljesen eloltanak.",
                    label = "Tűzkielégítés",
                },
                fireRewardJobs = {
                    description = "Azok a munkakörök, amelyek társaságai megkapják az önálló tűzoltás díját. Minden munkakör a beállított társasági számláját használja.",
                    label = "Tűzkielégítési foglalkozások",
                },
                fireSoundAmbient = {
                    label = "Tűz környezeti hangok",
                },
                fireSoundChainsaw = {
                    label = "Láncfűrész",
                },
                fireSoundFlare = {
                    label = "Jelzőhang",
                },
                fireThirst = {
                    label = "Szomjúság tűz esetén",
                },
                flow = {
                    label = "Folyamat",
                },
                flowBehavior = {
                    label = "Áramlási viselkedés",
                },
                foamRefill = {
                    label = "Hab utántöltés",
                },
                foamRefillVisual = {
                    label = "Hab utántöltés vizuális",
                },
                fullFireStage = {
                    label = "Teljes tűzstádium",
                },
                general = {
                    label = "Általános",
                },
                glassMinigame = {
                    description = "Vezérli a járműablak gyenge pontjának minijátékát.",
                    label = "Ablak minijáték",
                },
                groundActionAnimation = {
                    label = "Földi kezelési animáció",
                },
                hazard = {
                    description = "Vezérli az olajfolt csúszási veszélyét, intenzitását és az automatikus eltávolítási küszöbértékeket.",
                    label = "Veszélyeztetettség finomhangolása",
                },
                heat = {
                    label = "Hő",
                },
                heatClothing = {
                    label = "Hővédő ruha",
                },
                heatStress = {
                    label = "Hőterhelés",
                },
                helicopters = {
                    label = "Helikopterek",
                },
                hoseGrounding = {
                    label = "Földelés",
                },
                hosePerformance = {
                    label = "Teljesítmény",
                },
                hoseProp = {
                    label = "Cső prop",
                },
                hosePropGeometry = {
                    label = "Prop geometria",
                },
                hoseSimulation = {
                    label = "Szimuláció",
                },
                hydrantSupply = {
                    label = "Hydráns ellátás",
                },
                hydrants = {
                    label = "Tűzcsapok",
                },
                idleAnimation = {
                    label = "Üzemeltetési animáció",
                },
                ignition = {
                    label = "Új menütűzek",
                },
                interaction = {
                    label = "Interakció",
                },
                item = {
                    label = "Tárgy",
                },
                items = {
                    label = "Tárgyak",
                },
                keybinds = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Billentyűzések",
                },
                landing = {
                    label = "Légitárból érkezés",
                },
                limits = {
                    label = "Korlátok",
                },
                maintenance = {
                    label = "Állapot",
                },
                maintenanceAccess = {
                    label = "Hozzáférés",
                },
                manual = {
                    label = "Kézi gyújtás",
                },
                manualOnly = {
                    label = "Csak kézi",
                },
                nozzle = {
                    label = "Cső fúvóka",
                },
                nozzleAttachment = {
                    label = "Cső csatlakozás",
                },
                nozzleBend = {
                    label = "Csatlakozás hajlítása",
                },
                nozzleDirection = {
                    label = "Kilépési irány",
                },
                nozzlePlacement = {
                    label = "Földi elhelyezés",
                },
                npcFireReactions = {
                    label = "NPC tűzreakciók",
                },
                npcFireReactionsModes = {
                    label = "NPC reakciós módok",
                },
                offsets = {
                    label = "Csatlakozási eltolások",
                },
                oilReward = {
                    description = "Meghatározza a társaság számlájára utalt összeget, amikor egy olajfoltot eltakarítanak.",
                    label = "Olaj-kifizetés",
                },
                oilRewardJobs = {
                    description = "Olyan munkaszervezetek, amelyek olajtisztítási kifizetéseket kapnak. Minden munkaszervezet a beállított közös számláját használja.",
                    label = "Olajtisztítási munkaszervezetek",
                },
                placement = {
                    label = "Elhelyezés",
                },
                playerEntrapment = {
                    label = "Játékos elakadása",
                },
                portablePumpSupply = {
                    label = "Tragható szivattyú ellátás",
                },
                pressureControl = {
                    label = "Nyomáskontroll",
                },
                pressureLimits = {
                    label = "Nyomáskorlátok",
                },
                progression = {
                    label = "Fejlődés",
                },
                propGeneral = {
                    label = "Tárgy gyújtási pontjai",
                },
                propLimits = {
                    label = "Gyújtási forrás korlátok",
                },
                propList = {
                    label = "Lehetséges gyújtási források",
                },
                props = {
                    label = "Objektumok",
                },
                protectiveMask = {
                    label = "Erdei tűzvédő maszk",
                },
                protectiveMaskClothing = {
                    label = "Arcvédő maszkos ruha",
                },
                protectiveMaskItem = {
                    label = "Védőmaszk tárgy",
                },
                pump = {
                    label = "Pumpa",
                },
                pumpDamage = {
                    label = "Szivattyú károsodás",
                },
                pumpIntakeHose = {
                    label = "Befogó cső",
                },
                pumpPanelGeneral = {
                    description = "Választás az egyszerű automatikus és a fejlett kézi szivattyúvezérlés között.",
                    label = "Panel mód",
                },
                pumpTargets = {
                    label = "Csatlakozási célpontok",
                },
                rainFire = {
                    label = "Tűz viselkedés",
                },
                rainGeneral = {
                    label = "Általános",
                },
                rainVisuals = {
                    label = "Vizuális megjelenítés",
                },
                rainWeather = {
                    label = "Időjárás intenzitás",
                },
                random = {
                    label = "Véletlen",
                },
                randomJobs = {
                    label = "Véletlen munkahelyek",
                },
                reignition = {
                    label = "Újragyulladás",
                },
                release = {
                    label = "Kiadás",
                },
                render = {
                    label = "Láthatóság",
                },
                requirements = {
                    label = "Követelmények",
                },
                rescueReward = {
                    description = "Szabályozza azt a kifizetést a munkaszervezet számlájára, amely egy megmentési feladat befejezésekor jár.",
                    label = "Mentési kifizetés",
                },
                rescueRewardJobs = {
                    description = "Olyan munkaszervezetek, amelyek megmentési kifizetéseket kapnak. Minden munkaszervezet a beállított közös számláját használja.",
                    label = "Megmentési munkaszervezetek",
                },
                restock = {
                    label = "Újratöltés",
                },
                rpmRange = {
                    label = "Fordulatszám-tartomány",
                },
                seatbelt = {
                    description = "Vezérli a beakadt beteg övlevágó minijátékát.",
                    label = "Övlevágó minijáték",
                },
                smallFireStage = {
                    label = "Kis tűz fázisa",
                },
                smokeStage = {
                    label = "Füst fázisa",
                },
                spreaderMinigame = {
                    description = "Vezérli az ajtószélesítő nyomás minijátékát.",
                    label = "Ajtószélesítő minijáték",
                },
                standaloneAccidents = {
                    label = "Egyedi balesetek",
                },
                standaloneResult = {
                    label = "Egyedi eredmény",
                },
                standaloneThresholds = {
                    label = "Egyedi küszöbértékek",
                },
                stream = {
                    label = "Vízáram",
                },
                sweepMinigame = {
                    description = "Vezérli az olajseprű minijátékát.",
                    label = "Olajseprű minijáték",
                },
                tankFill = {
                    label = "Tartály feltöltése",
                },
                tankSupply = {
                    label = "Járműtartály-ellátás",
                },
                targets = {
                    label = "Célpontok",
                },
                thermalWarnings = {
                    label = "Hőmérséklet figyelmeztetések",
                },
                timing = {
                    label = "Időzítés",
                },
                treeBase = {
                    description = "Alapértelmezett beállítások a fákra vonatkozó beavatkozásokhoz: aktiválás, szolgálati kötelezettség, modell és spawn távolság.",
                    label = "Esemény",
                },
                treeBlip = {
                    description = "Térképi jelölő aktív fákra vonatkozó beavatkozások esetén.",
                    label = "Térképi jelölő",
                },
                treeCarry = {
                    description = "Hordott fa modell, csont, eltolások és mozgáskeverés a darabok hordásakor.",
                    label = "Hordott tárgy",
                },
                treeCarryAnimation = {
                    description = "Animációs könyvtár, név és zászló a fák hordásakor.",
                    label = "Hordás animáció",
                },
                treeDispatch = {
                    description = "Meghatározza, hogy a fákra vonatkozó beavatkozások küldenek-e parancsot, és melyik foglalkozások kapják meg.",
                    label = "Ügyelet",
                },
                treeDropMarker = {
                    description = "Jelölőstílus és szín a fa lerakási pontján.",
                    label = "Lerakási jelölő",
                },
                treeDropZone = {
                    description = "Helyi eltolás, sugár és takarítási tartomány a lerakott fadarabokra.",
                    label = "Lerakási zóna",
                },
                treeInteractionMarker = {
                    description = "Jelölőstílus és szín a fa interakciós pontján.",
                    label = "Faszúró jelölő",
                },
                treeInteractionPoint = {
                    description = "Interakciós távolság és helyi pozíció, ahol a játékosok elkezdenek fát fűrészelni.",
                    label = "Faszúró pont",
                },
                treeLogSpawn = {
                    description = "Létrehozott fadarabok száma, modellje, elhelyezkedése és felvételi távolsága.",
                    label = "Fa darabok",
                },
                treeReward = {
                    description = "Szabályozza azt a kifizetést a munkaszervezet számlájára, amely egy kidőlt fa teljes eltakarításakor jár.",
                    label = "Fa kifizetés",
                },
                treeRewardJobs = {
                    description = "Olyan munkaszervezetek, amelyek kidőlt fák eltakarításáért járó kifizetéseket kapnak. Minden munkaszervezet a beállított közös számláját használja.",
                    label = "Faeltakarítási munkaszervezetek",
                },
                treeSawAnimation = {
                    description = "Animációs könyvtár, név és zászló a fűrészelés közben.",
                    label = "Fűrészelés animáció",
                },
                treeSawAttach = {
                    description = "Finomhangolás a láncfűrész pozíciójára, forgatására, ütközésre és csatlakozási viselkedésére.",
                    label = "Láncfűrész csatlakoztatása",
                },
                treeSawMinigame = {
                    description = "Hány fűrészelési szakaszt kell teljesíteni a fadarabok eltakarítása előtt.",
                    label = "Fűrészelés minijáték",
                },
                treeSawTool = {
                    description = "Modell és csont a fűrészelés közben tartott láncfűrésznél.",
                    label = "Láncfűrészes prop",
                },
                types = {
                    label = "Típusok",
                },
                usage = {
                    label = "Tárgy és parancs",
                },
                vehicle = {
                    label = "Jármű indítása",
                },
                vehicleBend = {
                    label = "Jármű csatlakozási görbület",
                },
                vehicleEntrapment = {
                    label = "Jármű becsapódása",
                },
                vehiclePumpBehavior = {
                    label = "Szivattyú és motor viselkedése",
                },
                vehicleSmokeClasses = {
                    label = "Védett járműtípusok",
                },
                vehicleSmokeProtection = {
                    label = "Jármű füstvédelem",
                },
                vehicleState = {
                    label = "Jármű állapota",
                },
                vehicleTransfer = {
                    label = "Jármű vízáthelyezés",
                },
                vehicleTransferBehavior = {
                    label = "Áthelyezési viselkedés",
                },
                vehicleTransferSourceOffset = {
                    label = "Forráscsatlakozó",
                },
                vehicleTransferTargetOffset = {
                    label = "Célcsatlakozó",
                },
                vehicles = {
                    label = "Járművek",
                },
                water = {
                    label = "Víz",
                },
                waterCannon = {
                    label = "Jármű vízsugárzó",
                },
                waterReaction = {
                    label = "Vízreakció",
                },
            },
            settingSections = {
                billing = "Számlák",
                activeOilSpills = "Aktív olajfoltok",
                automaticMissions = "Automatikus küldetések",
                consumption = "Fogyasztás",
                effects = "Effektek",
                extinguishFeedback = "Visszajelzés",
                extinguishing = "Oltás",
                fire = "Elbocsátás",
                foamRefill = "Habszer feltöltése",
                foamRefillVisual = "Habszer feltöltésének vizuális megjelenítése",
                general = "Általános",
                heliBucket = "Vízvödör",
                hose = "Vízcső",
                hydrants = "Tűzcsapok",
                interiorExtinguishers = "Belső oltószerek",
                lighter = "Gyufa",
                minigames = "Minijátékok",
                npcRescue = "NPC-mentés",
                oilCleanup = "Takarítás",
                oilGeneral = "Általános",
                oilHazard = "Kockázat",
                oilSpills = "Olajszivárgás",
                protectiveGear = "Védőfelszerelés",
                pump = "Pumpa",
                pumpPanel = "Szivattyúpanelek",
                rain = "Eső",
                reignition = "Újragyulladás",
                rendering = "Rendszerezés",
                rescueCushion = "Mentőmatrac",
                rewardFire = "Tűzjutalom",
                rewardOil = "Olajjutalom",
                rewardRescue = "Mentésjutalom",
                rewardTree = "Fajutalom",
                rewards = "Díjak",
                scenarioCreator = "Küldetéskészítő",
                sounds = "Hangok",
                spread = "Tűz terjedése",
                treeDispatch = "Ügyelet",
                treeDrop = "Leadás",
                treeGeneral = "Általános",
                treeInteraction = "Interakció",
                treeLogs = "Törzsfák",
                treeSaw = "Fűrészelés",
                trees = "Fák",
                vehicleEntrapment = "Jármű-bezárlás",
                vehicleFires = "Járműtüzek",
                vehicleRescue = "Járműmentés",
                vehicles = "Járművek",
                waterMonitor = "Vízszóró",
            },
            settingSubsections = {
                weaponIgnition = "Fegyverek okozta tüzek",
                activeOilSpills = "Aktív olajfoltok",
                consumption = "Fogyasztás",
                engineSafety = "Motor és biztonság",
                extinguishFeedback = "Visszajelzés",
                extinguisherCustomMounts = "Egyedi tartók",
                extinguisherGeneral = "Általános",
                extinguisherMaintenance = "Karbantartás",
                extinguisherMounts = "Tartók és töltés",
                extinguisherPlacement = "Elhelyezés",
                extinguishing = "Oltás",
                femaleClothing = "Női ruha",
                foamRefill = "Habszer feltöltése",
                foamRefillVisual = "Habszer feltöltésének vizuális megjelenítése",
                general = "Általános",
                hydrants = "Tűzcsapok",
                hydraulics = "Hidraulika",
                keybinds = "Billentyűzések",
                maleClothing = "Férfi ruha",
                minigameGlass = "Üveg",
                minigameOilAbsorbent = "Olajelszívó",
                minigameOilSweep = "Olajseprő",
                minigameSaw = "Fűrészelés",
                minigameSeatbelt = "Biztonsági öv",
                minigameSpreader = "Ajtószélesítő",
                nozzle = "Szórófej",
                oilCleanup = "Takarítás",
                oilGeneral = "Általános",
                oilHazard = "Kockázat",
                pressure = "Nyomás és fordulatszám",
                pump = "Pumpa",
                rain = "Eső",
                reignition = "Újragyulladás",
                rendering = "Rendszerezés",
                reward = "Díj",
                rewardFire = "Tűzjutalom",
                rewardOil = "Olajjutalom",
                rewardRescue = "Mentésjutalom",
                rewardTree = "Fajutalom",
                simulation = "Szimuláció",
                sounds = "Hangok",
                spread = "Tűz terjedése",
                treeDispatch = "Diszpécser",
                treeDrop = "Leszállóhely",
                treeGeneral = "Általános",
                treeInteraction = "Fák és interakció",
                treeLogs = "Fadarabok",
                vehicleFires = "Járműtüzek",
                vehicleTransfer = "Járműátadás",
                vehicles = "Járművek",
                visuals = "Vizuális megjelenítés",
            },
            settings = {
                fireWeaponIgnitionEnabled = {
                    label = "Fegyverek okozta tüzek engedélyezése",
                    description = "Sky-tüzeket hoz létre a felsorolt fegyverekből. Hagyd kikapcsolva, amíg a tűzoltóság készen nem áll. A meglévő tüzeket és a GTA saját lángjait nem érinti.",
                },
                fireWeaponIgnitionWeapons = {
                    label = "Tüzet okozó fegyverek",
                    description = "Fegyvernevek, pl. WEAPON_MOLOTOV vagy WEAPON_FLAREGUN. Az üres lista letiltja a fegyverek okozta tüzeket. A lövedékeknek vagy becsapódásoknak észlelhetőnek kell lenniük.",
                },
                hoseHollowNozzleGroundOffset = {
                    label = "Üreges sugarú sugárcső talajhoz viszonyított eltolása",
                },
                hoseNozzleModel = {
                    label = "Sugárcső modellje",
                    choose = "Modell kiválasztása",
                    intact = "Sugárcső modellje",
                    description = "Válaszd a normál vagy az EU sugárcsövet. A modellváltás visszavonja a kihelyezett támadó tömlőket.",
                    preview = "3D előnézet",
                    previewDescription = "A valódi kellék megtekintése a játékban. A választást külön mentsd el.",
                    previewHelp = "Nyilak: mozgatás, Page Up/Down: magasság, egérgörgő: forgatás, Enter: bezárás, Backspace: megszakítás.",
                    invalidModel = "Érvénytelen kellékmodell.",
                    modelMissing = "Ez a kellék nem érhető el a játékban.",
                    previewFailed = "Az előnézet nem nyitható meg.",
                    previewRequiresGame = "Nyisd meg a /jobconfig parancsot a FiveM-ben az előnézethez.",
                    options = {
                        normal = "Normál sugárcső",
                        hohlstrahlrohr = "EU sugárcső",
                    },
                },
                fireBillingEnabled = {
                    label = "Számlák engedélyezése",
                    description = "Lehetővé teszi a szolgálatban lévő tűzoltók számára, hogy a sugaras menüből számlákat állítsanak ki.",
                },
                fireBillingMode = {
                    label = "Számlázórendszer",
                    description = "A Sky Base szolgáltatóját használja (alapértelmezetten Sky), vagy helyi készpénzes/kártyás fizetést.",
                    options = {
                        consent = "Készpénz vagy kártya",
                        framework = "Sky Base számlázási szolgáltató",
                    },
                },
                fireBillingReasons = {
                    label = "Számlázási okok",
                    description = "Kiválasztható okok és árak. Több ok kombinálható.",
                    itemLabel = "Indok",
                },
                fireBillingRange = {
                    label = "Címzett távolsága",
                    description = "Az adó és a fogadó közötti maximális távolság méterben.",
                },
                fireBillingMaxAmount = {
                    label = "Maximális számlaösszeg",
                    description = "Egyetlen számlára vonatkozó felső korlát, belső és külső számlázás esetén is.",
                },
                airBottleSlots = {
                    description = "Konfigurálja: A levegőpalack-helyeket.",
                    label = "Levegőpalack-helyek",
                },
                canSpread = {
                    description = "Lehetővé teszi, hogy itt indított tűz a Firejob-terjedési rendszeren keresztül terjedjen.",
                    label = "Tűzterjedés engedélyezése",
                },
                connection = {
                    description = "Konfigurálja: A kapcsolatot.",
                    label = "Kapcsolat",
                },
                customExtinguisherMounts = {
                    description = "Állandó egyedi tartók az aktuális oltószerekkel és karbantartási állapottal.",
                    label = "Elhelyezett oltószertartók",
                },
                deckGunSprayGamepadKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tartsd a fedélzeti ágyú permetezését",
                },
                deckGunSprayKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tartsd a fedélzeti ágyú permetezését",
                },
                drawables = {
                    description = "Konfigurálja: A megjelenítőket.",
                    label = "Rajzok",
                },
                fireBreathingAirEnabled = {
                    description = "Veszi a véges levegőnyomást a SCBA viselésekor.",
                    label = "Henger levegő használata",
                },
                fireBreathingCapacitySeconds = {
                    description = "Beállítás: Légzőkapacitás másodpercekben.",
                    label = "Légzőkapacitás másodpercekben",
                },
                fireBreathingComponents = {
                    description = "Maszk és levegőhenger alkatrészek szabályai. A megjeleníthető elemek elfogadnak bármilyen, anyNonDefault, egy számot, vagy vesszővel elválasztott számokat.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireBreathingCriticalPercent = {
                    description = "Beállítás: Kritikus levegőszint százalékban.",
                    label = "Kritikus levegőszint százalékban",
                },
                fireBreathingHeatConsumption = {
                    description = "Beállítás: Hőfogyasztás.",
                    label = "Hőfogyasztás",
                },
                fireBreathingHudUpdateInterval = {
                    description = "Beállítás: HUD frissítési intervalluma.",
                    label = "HUD frissítési intervallum",
                },
                fireBreathingIdleConsumption = {
                    description = "Beállítás: Üresjárati fogyasztás.",
                    label = "Üresjáratos fogyasztás",
                },
                fireBreathingItemEnabled = {
                    description = "A konfigurált inventártárgy kötelező a SCBA használata előtt.",
                    label = "Henger tárgy szükséges",
                },
                fireBreathingItemName = {
                    description = "Beállítás: Hengertárgy neve.",
                    label = "Hengertárgy neve",
                },
                fireBreathingItemSaveInterval = {
                    description = "Beállítás: Nyomásmentés intervalluma.",
                    label = "Nyomásmentési intervallum",
                },
                fireBreathingItemSavePressure = {
                    description = "Beállítás: Nyomásmetaadatok mentése.",
                    label = "Nyomásmetadata mentése",
                },
                fireBreathingJumpingConsumption = {
                    description = "Beállítás: Ugrási fogyasztás.",
                    label = "Ugrásos fogyasztás",
                },
                fireBreathingLowPercent = {
                    description = "Beállítás: Alacsony levegőszint százalékban.",
                    label = "Alacsony levegőszint százalékban",
                },
                fireBreathingMaskForceFirstPerson = {
                    description = "Az elsőszemélyű kamerát kényszeríti, amíg a maszk réteg aktív.",
                    label = "Elsőszemélyű nézet kényszerítése",
                },
                fireBreathingMaskOverlayEnabled = {
                    description = "Megjeleníti az elsőszemélyű maszk réteget, amíg a légvédelem aktív.",
                    label = "Maszk átfedés",
                },
                fireBreathingPressureBar = {
                    description = "Beállítás: Teljes nyomásos oszlop.",
                    label = "Teljes nyomásos oszlop",
                },
                fireBreathingProps = {
                    description = "Beállítás: Kötelező kellékek.",
                    itemLabel = "Tárgy",
                    label = "Kötelező kellékek",
                },
                fireBreathingRefillEnabled = {
                    description = "A henger tárgynak nyomásmetaadatokkal kell rendelkeznie. Az töltőállomásokat a tűztervezővel kell elhelyezni.",
                    label = "Utánpótló állomások engedélyezése",
                },
                fireBreathingRefillRate = {
                    description = "Beállítás: Másodpercenkénti töltési sebesség oszlop.",
                    label = "Másodpercenkénti töltési sebesség oszlop",
                },
                fireBreathingRunningConsumption = {
                    description = "Beállítás: Futási fogyasztás.",
                    label = "Futásos fogyasztás",
                },
                fireBreathingSmokeConsumption = {
                    description = "Beállítás: Füstfogyasztás.",
                    label = "Füstfogyasztás",
                },
                fireBreathingSmokeMultiplier = {
                    description = "A füstexpozíció, amely a SCBA aktív állapotában is elérheti a játékost.",
                    label = "Füstexpozíció szorzó",
                },
                fireBreathingSprintingConsumption = {
                    description = "Beállítás: Sprintelési fogyasztás.",
                    label = "Sprinteléses fogyasztás",
                },
                fireBreathingToxicConsumption = {
                    description = "Beállítás: Mérgező anyag fogyasztása.",
                    label = "Mérgező anyag fogyasztása",
                },
                fireBreathingToxicMultiplier = {
                    description = "A SCBA-hoz fenntartott mérgező expozíció finomhangolása.",
                    label = "Mérgező füst expozíció szorzó",
                },
                fireEditorControl14 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · IOM_WHEEL_DOWN",
                },
                fireEditorControl15 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · IOM_WHEEL_UP",
                },
                fireEditorControl174 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BALRA",
                },
                fireEditorControl175 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · JOBBRA",
                },
                fireEditorControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                fireEditorControl191 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                fireEditorControl199 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · P",
                },
                fireEditorControl200 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                fireEditorControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                fireEditorControl21 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL SHIFT",
                },
                fireEditorControl24 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · MOUSE_LEFT",
                },
                fireEditorControl25 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · MOUSE_RIGHT",
                },
                fireEditorControl32 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · W",
                },
                fireEditorControl322 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                fireEditorControl33 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · S",
                },
                fireEditorControl34 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · A",
                },
                fireEditorControl35 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · D",
                },
                fireEditorControl36 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL CTRL",
                },
                fireEditorControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · E",
                },
                fireEditorControl44 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Q",
                },
                fireEditorControl45 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · R",
                },
                fireExtinguishFeedbackAlpha = {
                    description = "A szimbólum átlátszósága 0 és 255 között.",
                    label = "Tűzoltási visszajelzés átlátszósága",
                },
                fireExtinguishFeedbackEnabled = {
                    description = "Megjeleníti a láng szimbólumot a tűz felett, amikor azt kioltják.",
                    label = "Tűzoltási visszajelző szimbólum engedélyezése",
                },
                fireExtinguishFeedbackHeight = {
                    description = "A szimbólum rajzolásának helye felett lévő függőleges eltolás.",
                    label = "Tűzoltási visszajelzés magassága",
                },
                fireExtinguishFeedbackMaxScale = {
                    description = "A legnagyobb szimbólumméret, amikor a tűzoltás éppen elkezdődik.",
                    label = "Tűzoltási visszajelzés maximális mérete",
                },
                fireExtinguishFeedbackMinScale = {
                    description = "A legkisebb szimbólumméret, amikor a tűzoltás szinte befejeződött.",
                    label = "Tűzoltási visszajelzés minimális mérete",
                },
                fireExtinguisherEffectiveness = {
                    description = "A tűzoltó által alkalmazott univerzális hatékonysági szorzó.",
                    label = "Tűzoltó hatékonysága",
                },
                fireExtinguisherEnabled = {
                    description = "Lehetővé teszi, hogy a WEAPON_FIREEXTINGUISHER minden típusú tüzet oltson.",
                    label = "Tűzoltó engedélyezése",
                },
                fireExtinguisherHitRadius = {
                    description = "Konfigurálja: a tűzoltó találati sugarát.",
                    label = "Tűzoltó találati sugara",
                },
                fireExtinguisherProgressPerSecond = {
                    description = "Konfigurálja: a tűzoltó oltási sebességét.",
                    label = "Tűzoltó oltási sebessége",
                },
                fireExtinguisherRange = {
                    description = "Konfigurálja: a tűzoltó hatótávolságát.",
                    label = "Tűzoltó hatótávolsága",
                },
                fireFemaleBreathingComponents = {
                    description = "Szabályok a női maszk és levegőhenger komponenseire vonatkozóan.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireFemaleBreathingProps = {
                    description = "Beállítás: Kötelező kellékek.",
                    itemLabel = "Tárgy",
                    label = "Kötelező kellékek",
                },
                fireFemaleHeatComponents = {
                    description = "Szabályok a női hővédő ruházat komponenseire vonatkozóan.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireFemaleHeatProps = {
                    description = "Beállítás: Kötelező kellékek.",
                    itemLabel = "Tárgy",
                    label = "Kötelező kellékek",
                },
                fireFemaleProtectiveMaskComponents = {
                    description = "Szabályok a női komponensekre vonatkozóan, amelyek a vadszentélyvédő maszk felszerelésekor lépnek érvénybe.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireFemaleProtectiveMaskProps = {
                    description = "Konfigurálja: a kötelező tárgyakat.",
                    itemLabel = "Tárgy",
                    label = "Kötelező tárgyak",
                },
                fireFirstSpreadDelaySeconds = {
                    description = "A gyújtástól számított minimális idő, amíg a tűz elterjedhet.",
                    label = "Az első elterjedés késleltetése másodpercben",
                },
                fireFlameScaleMultiplier = {
                    description = "Látható lángméret. A 1 a normál méret; érvényes az aktív tüzekre, és nem változtatja meg a kioltási nehézséget.",
                    label = "Lángméret-szorzó",
                },
                fireGearEnabled = {
                    description = "Be- és kikapcsolja a ruha, SCBA és hővédelem ellenőrzéseit.",
                    label = "Védelmi felszerelés engedélyezése",
                },
                fireHeatBurnDurationMultiplier = {
                    description = "Konfigurálja: a égési idő szorzóját.",
                    label = "Égési idő szorzója",
                },
                fireHeatComponents = {
                    description = "Szabályok a védőruha komponenseire vonatkozóan. A rajzolatok elfogadhatók: bármelyik, bármelyik nem alapértelmezett, egy szám vagy vesszővel elválasztott számok.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireHeatIgnite = {
                    description = "Konfigurálja: a védelem mellett történő gyújtást.",
                    label = "Védelem mellett történő gyújtás",
                },
                fireHeatProps = {
                    description = "Beállítás: Kötelező kellékek.",
                    itemLabel = "Tárgy",
                    label = "Kötelező kellékek",
                },
                fireHeatResistancePercent = {
                    description = "Teljes tűzoltóruha egyszerű védelmi ereje. A 0 nincs csökkentés, a 100 pedig nem okoz közvetlen tűzsebzést.",
                    label = "Hőállóság százaléka",
                },
                fireHeatStressBurnLevel = {
                    description = "Konfigurálja: az égési szintet.",
                    label = "Égési szint",
                },
                fireHeatStressDamageInterval = {
                    description = "Konfigurálja: a hősebzés intervallumát.",
                    label = "Hősebzés intervalluma",
                },
                fireHeatStressDirectFlameDistance = {
                    description = "Konfigurálja: a közvetlen láng távolságát.",
                    label = "Közvetlen láng távolsága",
                },
                fireHeatStressEnabled = {
                    description = "Konfigurálja: a hőstressz engedélyezését.",
                    label = "Hőstressz engedélyezése",
                },
                fireHeatStressExposurePower = {
                    description = "Magasabb értékek lassítják a hőfelhalmozódást, ha a játékos közel van, de nem közvetlenül a tűzben van.",
                    label = "Távolsági hőgörbe",
                },
                fireHeatStressFullHeatDistance = {
                    description = "Konfigurálja: a teljes hő távolságát.",
                    label = "Teljes hő távolsága",
                },
                fireHeatStressInitialGainMultiplier = {
                    description = "Szorzó, amíg a maghőmérséklet még alacsony.",
                    label = "Kezdeti hőfelvétel szorzója",
                },
                fireHeatStressMaxDistance = {
                    description = "Konfigurálja: a hőstressz maximális távolságát.",
                    label = "Maximális hőstressz-távolság",
                },
                fireHeatStressProgressionPower = {
                    description = "Magabb értékek lassítják a korai növekedést, majd később gyorsítják a felgyorsulást.",
                    label = "Hőfokozódás görbéje",
                },
                fireHeatStressProtectedDamage = {
                    description = "Konfigurálja: Védelem elleni kárt.",
                    label = "Védelem elleni kár",
                },
                fireHeatStressProtectedDamageLevel = {
                    description = "Konfigurálja: Védelem elleni kár szintje.",
                    label = "Védelem elleni kár szintje",
                },
                fireHeatStressProtectedDecay = {
                    description = "Konfigurálja: Védelem elleni romlást.",
                    label = "Védelem elleni romlás",
                },
                fireHeatStressProtectedDirectFlameDistance = {
                    description = "Konfigurálja: Védelem elleni közvetlen lángtávolságot.",
                    label = "Védelem elleni közvetlen lángtávolság",
                },
                fireHeatStressProtectedGain = {
                    description = "Konfigurálja: Védelem elleni hőnyerést.",
                    label = "Védelem elleni hőnyerés",
                },
                fireHeatStressUnprotectedDamage = {
                    description = "Konfigurálja: Védelem nélküli kárt.",
                    label = "Védelem nélküli kár",
                },
                fireHeatStressUnprotectedDamageLevel = {
                    description = "Konfigurálja: Védelem nélküli kár szintjét.",
                    label = "Védelem nélküli kár szintje",
                },
                fireHeatStressUnprotectedDecay = {
                    description = "Konfigurálja: Védelem nélküli romlást.",
                    label = "Védelem nélküli romlás",
                },
                fireHeatStressUnprotectedDirectFlameDistance = {
                    description = "Konfigurálja: Védelem nélküli közvetlen lángtávolságot.",
                    label = "Védelem nélküli közvetlen lángtávolság",
                },
                fireHeatStressUnprotectedGain = {
                    description = "Konfigurálja: Védelem nélküli hőnyerést.",
                    label = "Védelem nélküli hőnyerés",
                },
                fireIgnitionGrowthSeconds = {
                    description = "Másodpercek, amíg egy újonnan elhelyezett menütűz eléri a teljes profil méretét. Érvényes új tüzekre.",
                    label = "Kezdeti növekedési időtartam",
                },
                fireIgnitionStartScale = {
                    description = "Alapértelmezett kezdeti lángméret a tűzmenüben. A 1-nél kisebb értékek a teljes profil méretig nőnek.",
                    label = "Kezdeti méret a tűzmenüben",
                },
                fireInteriorExtinguishersControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Falra szerelt tűzoltó · E",
                },
                fireMaxFlameSources = {
                    description = "Kliensszintű korlát minden tűzre. A közeli lángok élvezik a prioritást; a kisebb korlátok több részecsketárhelyet hagynak a vízsugaraknak.",
                    label = "Maximális látható lángforrás",
                },
                fireMaxFlamesPerFire = {
                    description = "Egy tűzben lévő maximális lángok száma.",
                    label = "Maximális lángok száma tűzönként",
                },
                fireMaxSmokeSources = {
                    description = "Kliensszintű korlát a megosztott füstoszlopokhoz és a belső füstszemcsékhez. A közelben lévő források élvezik a prioritást.",
                    label = "Maximális látható füstforrás",
                },
                fireMaxSpreadDistance = {
                    description = "Új láng megjelenésének maximális távolsága egy meglévő lángtól.",
                    label = "Maximális terjedési távolság",
                },
                fireMinSpreadDistance = {
                    description = "Új láng megjelenésének minimális távolsága egy meglévő lángtól.",
                    label = "Minimális terjedési távolság",
                },
                fireNozzleProgressPerSecond = {
                    description = "Másodpercenként alkalmazott vízzel történő oltási előrehaladás.",
                    label = "Szórófeje oltási sebessége",
                },
                fireNozzleRange = {
                    description = "A csőszórófeje által elérhető maximális távolság a tűzre.",
                    label = "Szórófeje oltási hatótávolsága",
                },
                firePropIgnitionControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Objektum gyújtása · BACK",
                },
                firePropIgnitionControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Objektum gyújtása · E",
                },
                fireProtectiveMaskComponents = {
                    description = "Alkalmazott alkatrész-szabályok, amikor a vadszélvész-szemüveg viselése be van kapcsolva.",
                    itemLabel = "Komponens",
                    label = "Kötelező ruhadarabok",
                },
                fireProtectiveMaskEnabled = {
                    description = "Engedélyezi a újrahasznosítható szűrős maszkot vadszélvész-füstre hengeres levegő nélkül.",
                    label = "Védelmi maszk engedélyezése",
                },
                fireProtectiveMaskForceFirstPerson = {
                    description = "Első személyű kamerát kényszerít, amíg a védőmaszk felülete aktív.",
                    label = "Elsőszemélyű nézet kényszerítése",
                },
                fireProtectiveMaskItemEnabled = {
                    description = "Megköveteli a konfigurált inventártárgyat, mielőtt a védőmaszk használható lenne.",
                    label = "Védőmaszk-tárgy megkövetelése",
                },
                fireProtectiveMaskItemName = {
                    description = "Konfigurálja: Védőmaszk-tárgy neve.",
                    label = "Védőmaszk-tárgy neve",
                },
                fireProtectiveMaskOverlayEnabled = {
                    description = "Megjeleníti az első személyű maszkfelületet, amíg a védőmaszk aktív.",
                    label = "Maszk átfedés",
                },
                fireProtectiveMaskProps = {
                    description = "Konfigurálja: a kötelező tárgyakat.",
                    itemLabel = "Tárgy",
                    label = "Kötelező tárgyak",
                },
                fireProtectiveMaskSmokeMultiplier = {
                    description = "Füstexpozíció, amely akkor is eléri a játékost, amikor a védőmaszk aktív.",
                    label = "Füstkitetési szorzó",
                },
                fireProtectiveMaskToxicMultiplier = {
                    description = "Toxikus expozíció, amely akkor is eléri a játékost. Magasabb értékek esetén SCBA szükséges veszélyes füst esetén.",
                    label = "Toxikus füst expozíciós szorzó",
                },
                fireRainEnabled = {
                    description = "Hozzájárul, hogy az eső hatással legyen a külső tüzekre.",
                    label = "Esőhatások engedélyezése",
                },
                fireRainFlameScale = {
                    description = "Vizuális lángméret teljes esőintenzitásnál.",
                    label = "Lángméret esőben",
                },
                fireRainLargeFireSpreadMultiplier = {
                    description = "Szorzó a nagy külső tüzek terjedésére teljes esőintenzitásnál.",
                    label = "Nagy tüzek terjedésének szorzója",
                },
                fireRainMinimumIntensity = {
                    description = "Az eső értékei ez a küszöb alatt nincs hatással.",
                    label = "Minimum esőintenzitás",
                },
                fireRainSmallFireMaxFlames = {
                    description = "Az eső ki tudja oltani a külső tüzeket, amíg a lángok száma el nem éri ezt a számot.",
                    label = "Kis tüzek maximum lángjai",
                },
                fireRainSmallFireProgressPerSecond = {
                    description = "Oltási előrehaladás másodpercenként teljes időjárás-intenzitásnál.",
                    label = "Kis tüzek oltási sebessége",
                },
                fireRainSmokeScale = {
                    description = "Vizuális füstméret teljes esőintenzitásnál.",
                    label = "Füstméret esőben",
                },
                fireRainWeatherIntensity = {
                    description = "Esőhatás intenzitása minden GTA időjárástípusra 0,0-tól 1,0-ig.",
                    itemLabel = "Időjárás",
                    label = "Időjárás intenzitás",
                },
                fireReignitionChancePercent = {
                    description = "Százalékos esély, amely minden alkalommal megvan, amikor egy gyúlékony láng kioltásra kerül.",
                    label = "Újraéledés esélye százalékban",
                },
                fireReignitionDelaySeconds = {
                    description = "Másodpercek az oltás és a kis visszatérő láng között.",
                    label = "Újraéledés késleltetése másodpercben",
                },
                fireReignitionEnabled = {
                    description = "Lehetővé teszi, hogy az oltott gyúlékony lángok rövid késleltetés után újra fellobbannak.",
                    label = "Újraéledés engedélyezése",
                },
                fireReignitionExtinguishRequiredPercent = {
                    description = "Százalék a normál oltási előrehaladásból, amely szükséges ahhoz, hogy egy újra fellobbant láng végleg kioltva legyen.",
                    label = "Végleges kioltás újraéledés után százalékban",
                },
                fireReignitionFinalExtinguishHoldSeconds = {
                    description = "Másodpercek, amíg az oltás folytatódik teljes előrehaladás után, mielőtt egy újra fellobbant láng végleg kioltva lenne.",
                    label = "Végleges kioltás tartási ideje",
                },
                fireReignitionGrowthPerSecond = {
                    description = "Mennyivel nő az újra fellobbant láng mérete másodpercenként, amíg el nem éri a teljes méretet.",
                    label = "Növekedés másodpercenként",
                },
                fireReignitionNearImpactAccuracy = {
                    description = "Oltási pontosság, amelyet akkor használnak, ha csak az ütközés közel van egy újra fellobbant mini-lánghoz.",
                    label = "Közeli ütközési pontosság",
                },
                fireReignitionNearImpactTolerance = {
                    description = "Extra méterek egy újra fellobbant mini-láng körül, ahol egy majdnem megfelelő becsapódás továbbra is érvényesnek számít.",
                    label = "Közel ütközési tolerancia",
                },
                fireReignitionStartScale = {
                    description = "Skálázási szorzó, amelyet akkor használnak, amikor a láng először újra fellobban.",
                    label = "Kezdő lángméret",
                },
                fireRenderDistance = {
                    description = "Megosztott maximális render távolság lángokhoz és füstökhöz.",
                    label = "Láng és füst render távolsága",
                },
                fireSmokeDensityMultiplier = {
                    description = "Szorozza a látható füst átlátszatlanságát: a 0 elrejti a füstöt, a 1 normál, a 2 pedig növeli az átlátszatlanságot a maximumáig. A füst okozta károk változatlanok maradnak.",
                    label = "Füst átlátszatlanság-szorzó",
                },
                fireSmokeScaleMultiplier = {
                    description = "Felfelé szálló füstoszlopok látható mérete. A 1 a normál méret; érvényes az aktív füstre.",
                    label = "Füstméret-szorzó",
                },
                fireSmokeWindResponse = {
                    description = "Annak mértéke, hogy milyen erősen követi a csomagolt füst az időjárás szélét. A profil megváltoztatása újraindítja a füstoszlopokat.",
                    label = "Füst szélreagálása",
                    options = {
                        gentle = "Enyhe",
                        none = "Nincs szélhatás",
                        normal = "Normál",
                        strong = "Erős",
                    },
                },
                fireSoundChainsawEnabled = {
                    description = "Lejátsza a láncfűrészhangot 3D-ben, amikor egy játékos egy lehajtott fát fűrészel.",
                    label = "Fűrészhang engedélyezése",
                },
                fireSoundChainsawRange = {
                    description = "A fűrészhang hallható távolsága méterben.",
                    label = "Fűrészhang hatótávolsága",
                },
                fireSoundChainsawVolume = {
                    description = "Maximális hangerő a 3D fűrészhanghoz.",
                    label = "Fűrészhang hangerője",
                },
                fireSoundFireAmbientEnabled = {
                    description = "Lejátsza a tüzek típusához igazított térbeli tűzhangokat.",
                    label = "Tűz környezeti hang engedélyezése",
                },
                fireSoundFireAmbientRange = {
                    description = "A játékosok által hallható aktív tüzek távolsága méterben.",
                    label = "Tűz környezeti hang hatótávolsága",
                },
                fireSoundFireAmbientVolume = {
                    description = "Mesterhangerő minden térbeli tűzhanghoz: 0 = csendes, 1 = teljes. A változtatások érvényesülnek az aktív tüzekre is.",
                    label = "Tűz környezeti hang hangerője",
                },
                fireSoundFireFlareEnabled = {
                    description = "Lejátsza a rövid flare-hangot vízi reakciók során.",
                    label = "Flare-hang engedélyezése",
                },
                fireSoundFireFlareRange = {
                    description = "A vízi reakciós flare-hangok hallható távolsága méterben.",
                    label = "Flare-hang hatótávolsága",
                },
                fireSoundFireFlareVolume = {
                    description = "Maximális hangerő a vízi reakciós flare-hanghoz.",
                    label = "Flare-hang hangerője",
                },
                fireSpreadAttemptsPerTick = {
                    description = "Lehetséges terjedési pozíciók száma, amelyeket minden terjedési frissítés során ellenőriznek.",
                    label = "Terjedési kísérletek frissítésenként",
                },
                fireSpreadEnabled = {
                    description = "Lehetővé teszi az aktív tüzek számára, hogy további lángokat hozzanak létre gyúlékony környezetben.",
                    label = "Tűzterjedés engedélyezése",
                },
                fireSpreadIntervalSeconds = {
                    description = "Alapintervallum a terjedési frissítések között. Alacsonyabb értékek gyakrabban futtatják a terjedési ellenőrzéseket.",
                    label = "Terjedési intervallum másodpercben",
                },
                fireThirstEnabled = {
                    description = "Növeli a szomjúságfogyasztást, amíg a játékos tűzmelegnek van kitéve.",
                    label = "Növekedett szomjúság engedélyezése",
                },
                fireThirstMinimumBaseLossPerMinute = {
                    description = "Minimum szomjúságvesztés, amelyet a szorzó alapjaként használnak, ha a keretrendszer aránya túl kicsi ahhoz, hogy észrevehető legyen.",
                    label = "Minimum alapvesztés per perc",
                },
                fireThirstMultiplier = {
                    description = "Szorozza meg a normál szomjúságvesztést, amíg a játékos tűzmelegnek van kitéve.",
                    label = "Szomjúság szorzója",
                },
                fireThirstUpdateInterval = {
                    description = "Időköz a keretrendszer állapotellenőrzések között, amíg a játékos tűzmelegnek van kitéve.",
                    label = "Állapotellenőrzés időköze ms",
                },
                fireType = {
                    description = "Meghatározza, melyik Firejob tűzprofil kerül alkalmazásra az adott gyújtási forrásnál.",
                    label = "Gyújtási forrás típusa",
                },
                fireWaterMonitorControl172 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · FEL",
                },
                fireWaterMonitorControl173 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · LE",
                },
                fireWaterMonitorControl174 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · BAL",
                },
                fireWaterMonitorControl175 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · JOBB",
                },
                fireWaterMonitorControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · HÁTRA",
                },
                fireWaterMonitorControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · KILÉPÉS",
                },
                fireWaterMonitorControl24 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · MOUSE_LEFT",
                },
                fireWaterMonitorControl241 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · IOM_WHEEL_UP",
                },
                fireWaterMonitorControl242 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · IOM_WHEEL_DOWN",
                },
                fireWaterMonitorControl25 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Víztorony · MOUSE_RIGHT",
                },
                firetruckHudCursorKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tartsd a tűzoltóautó HUD egérművelet gombját",
                },
                firetruckHudToggleKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tűzoltóautó HUD be/ki váltása",
                },
                firetruckWaterCannonEnabled = {
                    description = "Lehetővé teszi a támogatott járműveken található beépített vízsugarak használatát a tűzoltáshoz.",
                    label = "Járművízsugár engedélyezése",
                },
                firetruckWaterCannonMinRange = {
                    description = "A rögzített járművízsugár minimális elérhető távolsága, mivel nem tud teljesen lefelé célozni.",
                    label = "Vízsugár minimális hatótávolsága",
                },
                firetruckWaterCannonModels = {
                    description = "Minden vízágyú külön sor. A tető- és első vízágyúnál ismételd meg a modellt, modellenként egyedi azonosítóval és a megfelelő csőcsonttal. A meglévő bejegyzések azonosítója deckGun. Minden vízágyúnak modellenként egyedi azonosító kell (1-48 ékezet nélküli betű, szám, aláhúzás vagy kötőjel).",
                    itemLabel = "Vízágyú",
                    label = "Járművek vízágyúi",
                },
                firetruckWaterCannonProgressPerSecond = {
                    description = "A járművízsugarak által másodpercenként elért tűzoltási előrehaladás.",
                    label = "Vízsugár tűzoltási sebessége",
                },
                foamTankEnabled = {
                    description = "Konfigurálja: Habtartály.",
                    label = "Habtartály",
                },
                foamTankSize = {
                    description = "Konfigurálja: Hab liter.",
                    label = "Hab liter",
                },
                gearKey = {
                    options = {
                        helmet = "Sisak",
                        mask = "Maszk",
                        other = "Egyéb (nincs védelem)",
                        pants = "Nadrág",
                        shoes = "Cipő",
                        top = "Felső",
                    },
                },
                heatLevelHudPosition = {
                    description = "A hőterhelés HUD paneljának pozíciója.",
                    label = "Hőterhelés panel pozíció",
                },
                heliBucketAllowedJobs = {
                    description = "Hagyj üresen, hogy engedélyezd az összes ebben a Firejobban konfigurált munkát.",
                    itemLabel = "Foglalkozás",
                    label = "Engedélyezett foglalkozások",
                },
                heliBucketAttachDistance = {
                    description = "A helikopter rögzítési pontja és a kosár közötti maximális távolság a csatlakoztatáskor.",
                    label = "Maximális csatlakoztatási távolság",
                },
                heliBucketAttachKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Helikopter kosár csatlakoztatása/leválasztása",
                },
                heliBucketAutoAttachOnGround = {
                    description = "Automatikusan csatlakoztat egy közelben lévő, földön lévő kosart, ha a helikopter hatótávolságon belül van.",
                    label = "Automatikus kötélcsatlakoztatás földön",
                },
                heliBucketBucketOffsetX = {
                    description = "A helyi X pozíció, ahol a kötél a kosárhoz csatlakozik.",
                    label = "Kosár kötél eltolás X",
                },
                heliBucketBucketOffsetY = {
                    description = "A helyi Y pozíció, ahol a kötél a kosárhoz csatlakozik.",
                    label = "Kosár kötél eltolás Y",
                },
                heliBucketBucketOffsetZ = {
                    description = "A helyi Z pozíció, ahol a kötél a kosárhoz csatlakozik.",
                    label = "Kosár kötél eltolás Z",
                },
                heliBucketCommand = {
                    description = "Parancsnév schrägstrich nélkül, például waterbucket.",
                    label = "Parancs",
                },
                heliBucketCommandEnabled = {
                    description = "Lehetővé teszi a Vízkosár elhelyezését parancs segítségével anélkül, hogy tárgy lenne szükséges.",
                    label = "Parancs használata engedélyezése",
                },
                heliBucketConsumeItem = {
                    description = "Egy konfigurált tárgy eltávolítása a sikeres elhelyezés után.",
                    label = "Tárgy elfogyasztása elhelyezésnél",
                },
                heliBucketDetachMaxGroundDistance = {
                    description = "A kosár leválasztásának engedélyezett maximális magassága a földről.",
                    label = "Maximális leválasztási magasság",
                },
                heliBucketDumpEnabled = {
                    description = "Lehetővé teszi a tárolt víz leeresztését a kosárból.",
                    label = "Víz leeresztés engedélyezése",
                },
                heliBucketDumpHitRadius = {
                    description = "A lecsapódó vizeszlop körüli sugár, amely befolyásolhatja a tüzeket.",
                    label = "Érintési sugár",
                },
                heliBucketDumpJetScale = {
                    description = "A kosár alatti fő vízjet vizuális mérete.",
                    label = "Fúvóka mérete",
                },
                heliBucketDumpKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Helikopter kosár víze leeresztése",
                },
                heliBucketDumpLitersPerSecond = {
                    description = "Másodpercenként leeresztett tárolt víz mennyisége.",
                    label = "Másodpercenként leeresztett liter",
                },
                heliBucketDumpProgressPerSecond = {
                    description = "A vizeszlopban lévő tüzekre alkalmazott alapoltóerő.",
                    label = "Másodpercenkénti oltási haladás",
                },
                heliBucketDumpRayLength = {
                    description = "A kosár alatt a tüzek kereséséhez ellenőrzött maximális lefelé irányuló távolság.",
                    label = "Sugárhossz",
                },
                heliBucketDumpSprayScale = {
                    description = "A kosár alatti széles vízpermet effekt vizuális mérete.",
                    label = "Permet mérete",
                },
                heliBucketEnabled = {
                    description = "Lehetővé teszi a Vízkosár elhelyezését, helikopterhez való csatlakoztatását, feltöltését és leeresztését.",
                    label = "Vízkosár engedélyezése",
                },
                heliBucketGroundAttachDistance = {
                    description = "A kosár és a föld közötti maximális magasság, amely automatikus csatlakoztatáshoz megengedett.",
                    label = "Földi csatlakoztatási távolság",
                },
                heliBucketHelicopterOffsets = {
                    description = "Kötél rögzítési pozíció helikoptermodell szerint; a default a helyettesítő modellként szolgál.",
                    itemLabel = "Eltolás",
                    label = "Helikopter kötéltávolságok",
                },
                heliBucketHelicopters = {
                    description = "Olyan helikoptermodellek, amelyekhez rögzíthető a víztartály.",
                    itemLabel = "Helikopter",
                    label = "Engedélyezett helikoptermodellek",
                },
                heliBucketItem = {
                    description = "Inventárelem, amellyel a víztartály elhelyezhető.",
                    label = "Tárgy neve",
                },
                heliBucketItemEnabled = {
                    description = "Lehetővé teszi a víztartály elhelyezését a beállított inventárelem használatával.",
                    label = "Elem használata engedélyezése",
                },
                heliBucketLabel = {
                    description = "Név, amely interakciókban és értesítésekben jelenik meg.",
                    label = "Megjelenítendő címke",
                },
                heliBucketModel = {
                    description = "A víztartályhoz létrehozott prop modell.",
                    label = "Tartály prop modell",
                },
                heliBucketMovingStreamDistance = {
                    description = "Maximális szinkronizációs távolság, miközben a víztartály rögzítve van és mozog.",
                    label = "Mozgáskor történő streaming távolság",
                },
                heliBucketPickupDistance = {
                    description = "Maximális távolság, amennyire egy rögzítetlen víztartály felvehető.",
                    label = "Felvételi távolság",
                },
                heliBucketRequireOnDuty = {
                    description = "Csak az engedélyezett munkakörben szolgálatot teljesítő tagok használhatják a víztartályt.",
                    label = "Szolgálat kötelező",
                },
                heliBucketRequirePilot = {
                    description = "A játékosnak a helikopter pilótaülésén kell ülnie a tartály vezérléséhez.",
                    label = "Pilótaülés megkövetelése",
                },
                heliBucketReturnItemOnRemove = {
                    description = "Egy beállított elemet ad vissza, amikor a víztartályt felveszik.",
                    label = "Elem visszaadása felvételekor",
                },
                heliBucketRopeLength = {
                    description = "A helikoptert és a víztartályt összekötő kötél hossza.",
                    label = "Kötél hossza",
                },
                heliBucketRopeType = {
                    description = "A tartálykapcsolathoz használt GTA köteltípus-azonosító.",
                    label = "Köteltípus",
                },
                heliBucketStreamDistance = {
                    description = "Maximális szinkronizációs távolság, miközben a víztartály áll.",
                    label = "Streaming távolság",
                },
                heliBucketWaterCapacityLiters = {
                    description = "A tartály által tárolható maximális vízmennyiség.",
                    label = "Tárolókapacitás literben",
                },
                heliBucketWaterCheckIntervalMs = {
                    description = "Az intervallum milliszekundumban a tartály vízbe merülésének ellenőrzései között.",
                    label = "Vízellenőrzési intervallum ms-ban",
                },
                heliBucketWaterEnabled = {
                    description = "Lehetővé teszi a víztartálynak a víz begyűjtését, ha víz alá merül.",
                    label = "Vízfeltöltés engedélyezése",
                },
                heliBucketWaterFillRateLitersPerSecond = {
                    description = "A másodpercenként hozzáadott vízmennyiség, amíg a tartály víz alatt van.",
                    label = "Feltöltési sebesség liter másodpercenként",
                },
                heliBucketZOffset = {
                    description = "A tartály propjának a földre helyezésekor alkalmazott függőleges korrekció.",
                    label = "Föld Z eltolás",
                },
                hoseAddPointDistance = {
                    description = "A szükséges mozgási távolság egy új csőpont hozzáadása előtt.",
                    label = "Új pont távolsága",
                },
                hoseDeployDistance = {
                    description = "A cső kiengedésének maximális távolsága a járműtől.",
                    label = "Kiengedési távolság",
                },
                hoseFoamLitersPerSecond = {
                    description = "A habtartály ürülési sebessége habpermetezés közben.",
                    label = "Hab liter másodpercenként",
                },
                hoseFoamRefillAnimDict = {
                    description = "A hab feltöltésekor használt animációs könyvtár.",
                    label = "Hab feltöltés anim könyvtár",
                },
                hoseFoamRefillAnimFlag = {
                    description = "A hab feltöltési feladathoz használt animációs lejátszás jelző.",
                    label = "Hab feltöltés anim jelző",
                },
                hoseFoamRefillAnimName = {
                    description = "A hab utántöltésekor használt animációs klip.",
                    label = "Hab feltöltés anim neve",
                },
                hoseFoamRefillBone = {
                    description = "A feltöltő prop-hoz csatolandó ped csont.",
                    label = "Hab feltöltés csont",
                },
                hoseFoamRefillDistance = {
                    description = "A feltöltés közbeni maximális távolság a járműhöz.",
                    label = "Hab feltöltés távolság",
                },
                hoseFoamRefillDurationMs = {
                    description = "Egy feltöltési művelet előrehaladásának időtartama.",
                    label = "Hab feltöltés időtartama ms",
                },
                hoseFoamRefillEnabled = {
                    description = "Engedélyezi a jármű habtartályainak feltöltését egy inventáriumtárggyal.",
                    label = "Hab feltöltés engedélyezése",
                },
                hoseFoamRefillItem = {
                    description = "A habtartály feltöltéséhez szükséges inventáriumtárgy.",
                    label = "Hab feltöltés tárgy",
                },
                hoseFoamRefillLiters = {
                    description = "Annak a mennyisége, hogy hány liter habot ad hozzá egy doboz a jármű tartályához.",
                    label = "Hab feltöltés liter",
                },
                hoseFoamRefillOffsetRx = {
                    description = "Dőlésszög rotáció a feltöltő prop-hoz.",
                    label = "Hab feltöltés rotáció X",
                },
                hoseFoamRefillOffsetRy = {
                    description = "Kanyarodási rotáció a feltöltő prop-hoz.",
                    label = "Hab feltöltés rotáció Y",
                },
                hoseFoamRefillOffsetRz = {
                    description = "Forgási rotáció a feltöltő prop-hoz.",
                    label = "Hab feltöltés rotáció Z",
                },
                hoseFoamRefillOffsetX = {
                    description = "Horizontális kézi eltolás a feltöltő prop-hoz.",
                    label = "Hab feltöltés eltolás X",
                },
                hoseFoamRefillOffsetY = {
                    description = "Előre vagy hátra irányuló kézi eltolás a feltöltő prop-hoz.",
                    label = "Hab feltöltés eltolás Y",
                },
                hoseFoamRefillOffsetZ = {
                    description = "Vertikális kézi eltolás a feltöltő prop-hoz.",
                    label = "Hab feltöltés eltolás Z",
                },
                hoseFoamRefillProp = {
                    description = "A kézen látható prop a habtartály feltöltése közben.",
                    label = "Hab feltöltés prop",
                },
                hoseFoamRefillRequireOnDuty = {
                    description = "Csak a jelenlegi szolgálatban lévő játékosok tölthetik fel a habtartályokat.",
                    label = "Szolgálati kötelezettség a hab feltöltéséhez",
                },
                hoseFoamWaterLitersPerSecond = {
                    description = "A wassertartály ürülési sebessége habpermetezés közben külső ellátás nélkül.",
                    label = "Hab víz liter másodpercenként",
                },
                hoseGroundActionAnimationDict = {
                    description = "Konfigurálja: Animációs szótár.",
                    label = "Animációs szótár",
                },
                hoseGroundActionAnimationDurationMs = {
                    description = "Az animáció teljes időtartama milliszekundumban.",
                    label = "Animációs időtartam",
                },
                hoseGroundActionAnimationEnabled = {
                    description = "Animáció lejátszása a támadócső le- és felvételekor.",
                    label = "Kezelési animáció engedélyezése",
                },
                hoseGroundActionAnimationFlag = {
                    description = "Konfigurálja: Animációs jelzőt.",
                    label = "Animációs jelző",
                },
                hoseGroundActionAnimationLayDownName = {
                    description = "Konfigurálja: Lehelyezési animációt.",
                    label = "Lehelyezési animáció",
                },
                hoseGroundActionAnimationPickUpName = {
                    description = "Konfigurálja: Felvételi animációt.",
                    label = "Felvételi animáció",
                },
                hoseGroundActionAnimationTransitionMs = {
                    description = "Az időpont milliszekundumban, amikor a csőszóró fej átvált a kéz és a föld között.",
                    label = "Objektumátmeneti idő",
                },
                hoseGroundOffset = {
                    description = "Vertikális eltolás, amelyet akkor alkalmazunk, amikor új csőpontokat helyezünk el a földön.",
                    label = "Cső-föld eltolás",
                },
                hoseGroundedNozzleHeadingOffset = {
                    description = "A játékos nézési irányához hozzáadott kanyarodási korrekció a csőszóró fej lehelyezésekor.",
                    label = "Földön lévő csőszóró fej irányeltolása",
                },
                hoseGroundedNozzleOffset = {
                    description = "Vertikális korrekció a fegyver objektumára a földre való elhelyezése után. Negatív értékek lejjebb helyezik.",
                    label = "Földön lévő csőszóró fej eltolása",
                },
                hoseGroundedNozzlePitch = {
                    description = "A csőszóró fej modeljét a földre való sima lehelyezéséhez használt dőlés.",
                    label = "Földön lévő csőszóró fej dőlése",
                },
                hoseGroundedNozzleRoll = {
                    description = "A földhöz rögzített fúvóka modelljére alkalmazott dőlési korrekció.",
                    label = "Földhöz rögzített fúvóka dőlése",
                },
                hoseHydrantConnectDistance = {
                    description = "A maximális távolság egy tűzcsap objektumhoz az ellátóvonal csatlakoztatásakor.",
                    label = "Tűzcsap csatlakozási távolság",
                },
                hoseHydrants = {
                    description = "Az objektummodellek, amelyeket tűzcsapnak azonosítanak a csőcsatlakozásokhoz és a térképhez.",
                    itemLabel = "Víztűzcsap",
                    label = "Tűzcsap objektummodellek",
                },
                hoseMaxLength = {
                    description = "A maximális csőhossz méterben, mielőtt a csőszóró fej leválik.",
                    label = "Maximális csőhossz",
                },
                hoseNozzleBendDistance = {
                    description = "A távolság, amelyet a cső görbületének kialakításához használunk a csőszóró fej mögött.",
                    label = "Csőszóró fej görbületi távolság",
                },
                hoseNozzleExitDirectionX = {
                    description = "A helyi X irány, amelyben a cső kilép a csőszóró fejből.",
                    label = "Kilépési irány X",
                },
                hoseNozzleExitDirectionY = {
                    description = "A helyi Y irány, amelyben a cső kilép a csőszóró fejből.",
                    label = "Kilépési irány Y",
                },
                hoseNozzleExitDirectionZ = {
                    description = "A helyi Z irány, amelyben a cső kilép a csőszóró fejből.",
                    label = "Kilépési irány Z",
                },
                hoseNozzleExitLength = {
                    description = "A cső egyenes hossza a csőszóró fejből kilépve az első görbület előtt.",
                    label = "Csőszóró fej kilépési hossza",
                },
                hoseNozzleOffsetX = {
                    description = "A cső csatlakozásának X eltolása a csőszóró fej fegyverén.",
                    label = "Csőszóró fej eltolása X",
                },
                hoseNozzleOffsetY = {
                    description = "A cső csatlakozásának Y eltolása a csőszóró fej fegyverén.",
                    label = "Csőszóró fej eltolása Y",
                },
                hoseNozzleOffsetZ = {
                    description = "A cső csatlakozásának Z eltolása a csőszóró fej fegyverén.",
                    label = "Csőszóró fej eltolása Z",
                },
                hoseDividing = {
                    description = "Bekapcsolja a lehelyezhető háromágú osztót, a külön szelepeket és a vízáramlást. Alapértelmezésben kikapcsolva.",
                    label = "Tömlőosztó",
                },
                hosePerformanceMode = {
                    description = "A High End mód prioritást ad a leggyengébb csőmozgásnak. A Performance mód csökkenti a csőfrissítéseket és csökkenti a kliens terhelését.",
                    label = "Cső teljesítmény mód",
                    options = {
                        high_end = "Magas végű",
                        performance = "Teljesítmény",
                    },
                },
                hosePropBaseLength = {
                    description = "A csőszegmens modell eredeti hossza a méretezés előtt.",
                    label = "Prop-bázis hossza",
                },
                hosePropBaseRadius = {
                    description = "A csőszegmens modell eredeti sugara a méretezés előtt.",
                    label = "Prop-bázis sugara",
                },
                hosePropLengthRatio = {
                    description = "A csőszegmens modell méretezésekor alkalmazott hossz-korrekció.",
                    label = "Prop-hossz arány",
                },
                hosePropRoll = {
                    description = "A csőszegmens modellre alkalmazott Roll-korrekció fokban.",
                    label = "Prop-roll",
                },
                hosePropsEnabled = {
                    description = "Látható csőszegmens-objektumok megjelenítése a csőszóró fej használata közben. A tűzcsap-ellátóvonalak akkor is megjelennek, ha ez letiltva van.",
                    label = "Csőcsap-objektumok renderelése",
                },
                hosePumpConnectDistance = {
                    description = "A távolság, amelyet a szivattyú környezeti vízből való szívóképtelenségének ellenőrzésére használnak.",
                    label = "Szivattyú-csatlakozási távolság",
                },
                hosePumpControlIdlePressure = {
                    description = "A szivattyúvezérlő létrehozásakor használt nyomás.",
                    label = "Kezdő nyomás",
                },
                hosePumpControlIdleRpm = {
                    description = "A szivattyú-motor fordulatszáma a legkisebb nyomáson.",
                    label = "Alapjárati fordulat",
                },
                hosePumpControlMaxPressure = {
                    description = "A fejlett szivattyúpanelen beállítható maximális nyomás.",
                    label = "Maximális nyomás",
                },
                hosePumpControlMaxRpm = {
                    description = "A szivattyú-motor fordulatszáma a maximális nyomáson.",
                    label = "Maximális fordulatszám",
                },
                hosePumpControlMinPressure = {
                    description = "A kimenethez szükséges minimális nyomás a vízellátáshoz.",
                    label = "Minimális nyomás",
                },
                hosePumpControlPresetPressure = {
                    description = "A Preset gomb által kiválasztott nyomás és a normál áramlás referenciája.",
                    label = "Preset nyomás",
                },
                hosePumpControlPressureStep = {
                    description = "Egy gombnyomással hozzáadott vagy levont PSI.",
                    label = "Nyomáslépés",
                },
                hosePumpControlTankFillLitersPerSecond = {
                    description = "A Tanktöltés aktív állapotában másodpercenként a járműtankba áramló vízmennyiség.",
                    label = "Tanktöltés liter/másodperc",
                },
                hosePumpEnabled = {
                    description = "A szivattyú természetes vízből való szívóképtelenségének engedélyezése.",
                    label = "Tragható szivattyú engedélyezése",
                },
                hosePumpIntakeExtraLength = {
                    description = "A felismert vízfelszínbe nyúló további szívócső-hossz.",
                    label = "További szívóhossz",
                },
                hosePumpIntakeSubmergeDepth = {
                    description = "A szívócső végpontjának mélysége a felismert vízfelszín alatt.",
                    label = "Szívócső-beáztatási mélység",
                },
                hosePumpItem = {
                    description = "Az inventárumból használt tárgy, amely közvetlenül indítja a tragható szivattyút.",
                    label = "Szivattyú-tárgy neve",
                },
                hosePumpItemEnabled = {
                    description = "A konfigurált szivattyú-tárgy regisztrálása, hogy annak használata a tragható szivattyú elhelyezését indítsa el.",
                    label = "Szivattyú-tárgy-használat engedélyezése",
                },
                hosePumpItemRequired = {
                    description = "A játékosoknak viselniük kell a konfigurált szivattyú-tárgyat, mielőtt tragható szivattyú-ellátást indíthatnának.",
                    label = "Szivattyú-tárgy kötelező",
                },
                hosePumpModel = {
                    description = "A tragható szívószivattyúként megjelenített objektum.",
                    label = "Szivattyú-objektum modell",
                },
                hosePumpNaturalWaterEnabled = {
                    description = "A tragható szivattyú engedélyezése folyók, tavak és egyéb felismert vízfelszínekhez való szívóképtelenséghez.",
                    label = "Természetes vízből való szívóképtelenség engedélyezése.",
                },
                hosePumpPanelStyle = {
                    description = "Az Egyszerű mód automatikus szivattyúvezérlést használ egy bevitellel és egy kivevéssel. A Fejlett mód manuális vezérlést engedélyez legfeljebb két bevitellel és négy kivevéssel.",
                    label = "Szivattyúpanel",
                    options = {
                        enhanced = "Fejlett panel",
                        simple = "Egyszerű panel",
                    },
                },
                hosePumpTargetDistance = {
                    description = "A játékos és a konfigurált szivattyú-csatlakozási cél közötti maximális távolság.",
                    label = "Cél-interakciós távolság",
                },
                hosePumpTargetSize = {
                    description = "Sugár minden szivattyúkapcsolási célpontjához.",
                    label = "Célpont sugara",
                },
                hosePumpWaterProbeDepth = {
                    description = "Annak a mértéke, hogy meddig keresünk vizet minden érzékelőpont alatt.",
                    label = "Szivattyúvíz-érzékelőmélység",
                },
                hosePumpWaterProbeDistance = {
                    description = "Annak a mértéke, hogy meddig keresünk vizet a szivattyú elhelyezési pontja körüli területen.",
                    label = "Szivattyúvíz-érzékelőtávolság",
                },
                hoseRadius = {
                    description = "A csőszakaszok megjelenített sugara.",
                    label = "Cső sugara",
                },
                hoseRelaxPasses = {
                    description = "A cső simításához frissítésonként használt korlátozási lépések száma.",
                    label = "Simítási lépések",
                },
                hoseSegmentLength = {
                    description = "A szimulált csőpontok közötti céltávolság.",
                    label = "Szakasz hossza",
                },
                hoseSegmentOverlap = {
                    description = "A szomszédos csőelemek közötti vizuális átfedés a hézagok elrejtésére.",
                    label = "Szakasz átfedés",
                },
                hoseSegmentProp = {
                    description = "Az összes látható csőszakasz megjelenítéséhez használt modell.",
                    label = "Szakasz elem",
                },
                hoseSegmentUpdateDistance = {
                    description = "A minimális mozgás, amely után a megjelenített csőszakaszok újjáépítésre kerülnek.",
                    label = "Szakasz frissítési távolság",
                },
                hoseUpdateInterval = {
                    description = "A csőszimuláció alapértelmezett frissítési időközének értéke milliszekundumban.",
                    label = "Frissítési időköz",
                },
                hoseVehicleBendDistance = {
                    description = "A távolság, amely a járműnél lévő csőhajlítás kialakításához szükséges.",
                    label = "Jármű-hajlítás távolsága",
                },
                hoseVehicleExitLength = {
                    description = "A járműkapcsolópontról induló egyenes csőszakasz hossza.",
                    label = "Járműkimeneti hossz",
                },
                hoseVehiclePumpBehaviorActiveRpm = {
                    description = "A járműszivattyú aktív állapotában alkalmazott fordulatszámérték. Használd a 0.0 és 1.0 értékeket.",
                    label = "Aktív fordulatszám",
                },
                hoseVehiclePumpBehaviorAmbientTemperature = {
                    description = "A legalsó szivattyúhőmérséklet és hűtési céltartalom Celsius-fokban.",
                    label = "Környezeti hőmérséklet",
                },
                hoseVehiclePumpBehaviorCavitationTemperatureGain = {
                    description = "A teljes kavitációhoz hozzáadott céltartalom.",
                    label = "Kavitációs hőmérséklet-növekedés",
                },
                hoseVehiclePumpBehaviorCriticalTemperature = {
                    description = "Az a szivattyúhőmérséklet, amelytől kezdve a kritikus figyelmeztetés megjelenik.",
                    label = "Kritikus hőmérséklet",
                },
                hoseVehiclePumpBehaviorDamageTemperature = {
                    description = "Az a szivattyúhőmérséklet, amely felett a motor károsodása kezdődik.",
                    label = "Károsodási hőmérséklet",
                },
                hoseVehiclePumpBehaviorDryRunDamagePerSecond = {
                    description = "A motor károsodása másodpercenként száraz futás közben.",
                    label = "Szárazfutási károsodás/másodperc",
                },
                hoseVehiclePumpBehaviorDryRunTemperature = {
                    description = "A szivattyú víz nélkül történő működésének céltartalma.",
                    label = "Szárazfutási hőmérséklet",
                },
                hoseVehiclePumpBehaviorEnabled = {
                    description = "A motorok üzemben tartását és a szivattyú fordulatszámának vezérlését biztosítja, amikor a csőrendszerek használják a járművet.",
                    label = "Szivattyúviselkedés engedélyezése",
                },
                hoseVehiclePumpBehaviorEngagementMaxSpeed = {
                    description = "A szivattyú bekapcsolható maximális járműsebesség méterben másodpercenként.",
                    label = "Maximális kapcsolási sebesség",
                },
                hoseVehiclePumpBehaviorEngineDamageEnabled = {
                    description = "Engedélyezi a túlfűtést és a száraz futást a járműmotor károsodásához. Alapértelmezés szerint letiltva; a szivattyúfigyelmeztetések aktívak maradnak.",
                    label = "Szivattyúmotor-károsodás",
                },
                hoseVehiclePumpBehaviorFuelPercentPerMinute = {
                    description = "A szivattyú működése során percenként felhasznált alapüzemanyag-százalék.",
                    label = "Üzemanyag-százalék/perc",
                },
                hoseVehiclePumpBehaviorImmobilizePumpVehicles = {
                    description = "Megakadályozza a szivattyú aktív állapotában lévő járművezetést.",
                    label = "Jármű zárolása szivattyúzás közben",
                },
                hoseVehiclePumpBehaviorImmobilizeTransferVehicles = {
                    description = "Megakadályozza, hogy a járművek elinduljanak, amíg egy járműről járműre vezető átviteli vonal csatlakoztatva van.",
                    label = "Átviteli járművek zárolása",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringPump = {
                    description = "A forrásjármű motorjának futtatva tartása, miközben kézi csövekből vagy vízfúrókból permeteznek.",
                    label = "Motor bekapcsolva permetezés közben",
                },
                hoseVehiclePumpBehaviorKeepEngineOnDuringTransfer = {
                    description = "A járműmotorok futtatva tartása, amíg egy átviteli vonal csatlakoztatva van.",
                    label = "Motor bekapcsolva átvitel közben",
                },
                hoseVehiclePumpBehaviorKeepEngineOnWhenAbandoned = {
                    description = "A konfigurált pumpáló járművek motorjának futtatva tartása, miután a sofőr kiszáll.",
                    label = "Motor bekapcsolva elhagyás után",
                },
                hoseVehiclePumpBehaviorMaxEngineDamagePerSecond = {
                    description = "A pumpáló stressz által másodpercenként okozott maximális motor-károsodás.",
                    label = "Maximális károsodás/másodperc",
                },
                hoseVehiclePumpBehaviorOverloadWarningLoad = {
                    description = "A motorterhelési arány, amelyen a túltöltési figyelmeztetés megjelenik.",
                    label = "Túltöltési figyelmeztetési terhelés",
                },
                hoseVehiclePumpBehaviorRpmEnabled = {
                    description = "A jármű fordulatszámának növelése, miközben kézi csövekből vagy vízfúrókból permeteznek ebből a járműből.",
                    label = "Pumpáló fordulatszám növelése",
                },
                hoseVehiclePumpBehaviorThermalResponse = {
                    description = "Annak a sebességének meghatározása, amellyel a pumpa hőmérséklete a számított célhőmérséklet felé közelít.",
                    label = "Hőmérsékleti válasz",
                },
                hoseVehiclePumpBehaviorUpdateMs = {
                    description = "Annak a gyakoriságának meghatározása, amellyel a kliens újraalkalmazza a motor-, zárolási és fordulatszám-viselkedést milliszekundumban.",
                    label = "Frissítési intervallum",
                },
                hoseVehiclePumpBehaviorWarningTemperature = {
                    description = "A pumpahőmérséklet, amelyen a túlmelegedési figyelmeztetés megjelenik.",
                    label = "Figyelmeztető hőmérséklet",
                },
                hoseVehiclePumpHydraulicsCavitationStartRatio = {
                    description = "A kavitáció kezdődő forráskapacitás aránya.",
                    label = "Kavitációs kezdő arány",
                },
                hoseVehiclePumpHydraulicsFrictionLossPsiPerTenMeters = {
                    description = "A tíz méter aktív csőre eső nyomáscsökkenés.",
                    label = "Súrlódási veszteség PSI per 10 m",
                },
                hoseVehiclePumpHydraulicsHydrantIntakePressure = {
                    description = "A hidránt által szolgáltatott beviteli nyomás PSI-ban.",
                    label = "Hidránt beviteli nyomás",
                },
                hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond = {
                    description = "A hidránt által szolgáltatott maximális vízáramlás liter másodpercenként.",
                    label = "Hidránt teljesítmény",
                },
                hoseVehiclePumpHydraulicsPumpIntakePressure = {
                    description = "A hordozható pumpa által szolgáltatott beviteli nyomás PSI-ban.",
                    label = "Pumpa beviteli nyomás",
                },
                hoseVehiclePumpHydraulicsPumpSupplyGpm = {
                    description = "A hordozható pumpa által szolgáltatott maximális vízáramlás.",
                    label = "Pumpa ellátás GPM",
                },
                hoseVehiclePumpHydraulicsTankIntakePressure = {
                    description = "A járműtároló által szolgáltatott beviteli nyomás PSI-ban.",
                    label = "Tároló beviteli nyomás",
                },
                hoseVehiclePumpHydraulicsTankSupplyGpm = {
                    description = "A járműtároló által szolgáltatott maximális vízáramlás.",
                    label = "Tároló ellátás GPM",
                },
                hoseVehicleTransferAllowExternalSource = {
                    description = "Egy a hidránthoz vagy pumpához csatlakoztatott forrásjármű feltöltheti a célt anélkül, hogy saját tárolóját ürítené.",
                    label = "Külső forrás engedélyezése",
                },
                hoseVehicleTransferConnectDistance = {
                    description = "A játékos és a csatlakoztatható átviteli vonal közötti maximális távolság.",
                    label = "Csatlakozási távolság",
                },
                hoseVehicleTransferDisconnectWhenSourceEmpty = {
                    description = "Az átvitel automatikus megszakítása, amikor a forrás tartálya üres.",
                    label = "Megállás, ha a forrás üres",
                },
                hoseVehicleTransferDisconnectWhenTargetFull = {
                    description = "Az átvitel automatikus megszakítása, amikor a cél tartálya tele van.",
                    label = "Megállás, ha a cél tele van",
                },
                hoseVehicleTransferEnabled = {
                    description = "Egy csővonal lehetővé teszi a víz átvitelét egyik tűzoltó jármű tárolójából a másikba.",
                    label = "Járműátvitel engedélyezése",
                },
                hoseVehicleTransferLitersPerSecond = {
                    description = "A forrásjárműből a céljárműbe másodpercenként átvitt vízmennyiség.",
                    label = "Liter másodpercenként",
                },
                hoseVehicleTransferMaxLength = {
                    description = "A két összekapcsolt jármű közötti maximális távolság.",
                    label = "Maximális csőhossz",
                },
                hoseVehicleTransferRequireOnDuty = {
                    description = "Csak szolgálatban lévő tűzoltók hozhatnak létre jármű közötti vízátvitelt.",
                    label = "Szolgálat kötelező",
                },
                hoseVehicleTransferSourceDirectionX = {
                    description = "Konfigurálja: Forrás irány X.",
                    label = "Forrás irány X",
                },
                hoseVehicleTransferSourceDirectionY = {
                    description = "Konfigurálja: Forrás irány Y.",
                    label = "Forrás irány Y",
                },
                hoseVehicleTransferSourceDirectionZ = {
                    description = "Konfigurálja: Forrás irány Z.",
                    label = "Forrás irány Z",
                },
                hoseVehicleTransferSourceOffsetX = {
                    description = "Konfigurálja: Forrás X.",
                    label = "Forrás X",
                },
                hoseVehicleTransferSourceOffsetY = {
                    description = "Konfigurálja: Forrás Y.",
                    label = "Forrás Y",
                },
                hoseVehicleTransferSourceOffsetZ = {
                    description = "Konfigurálja: Forrás Z.",
                    label = "Forrás Z",
                },
                hoseVehicleTransferTargetDirectionX = {
                    description = "Konfigurálja: Cél irány X.",
                    label = "Cél irány X",
                },
                hoseVehicleTransferTargetDirectionY = {
                    description = "Konfigurálja: Cél irány Y.",
                    label = "Cél irány Y",
                },
                hoseVehicleTransferTargetDirectionZ = {
                    description = "Konfigurálja: Cél irány Z.",
                    label = "Cél irány Z",
                },
                hoseVehicleTransferTargetOffsetX = {
                    description = "Konfigurálja: Cél X.",
                    label = "Cél X",
                },
                hoseVehicleTransferTargetOffsetY = {
                    description = "Konfigurálja: Cél Y.",
                    label = "Cél Y",
                },
                hoseVehicleTransferTargetOffsetZ = {
                    description = "Konfigurálja: Cél Z.",
                    label = "Cél Z",
                },
                hoseVehicleTransferTickMs = {
                    description = "Aktív csővezetékek szerverfrissítési intervalluma.",
                    label = "Transfer-tick ms",
                },
                hoseVehicles = {
                    description = "Szivattyúpanellel, tartállyal és egyenként beállítható befolyó- és kifolyókapcsolattal rendelkező járműmodellek.",
                    itemLabel = "Jármű",
                    label = "Szivattyújárművek",
                },
                hoseWaterLitersPerSecond = {
                    description = "Tartályvíz-áramlás sebessége locsolás közben külső ellátás nélkül.",
                    label = "Víz liter másodpercenként",
                },
                hydrantConnection = {
                    description = "Konfigurálja: Tűzcsőkapcsolat.",
                    label = "Hidráns-csatlakozás",
                },
                hydrantRx = {
                    description = "Konfigurálja: Tűzcső RX.",
                    label = "Tűzcső RX",
                },
                hydrantRy = {
                    description = "Konfigurálja: Tűzcső RY.",
                    label = "Tűzcső RY",
                },
                hydrantRz = {
                    description = "Konfigurálja: Tűzcső RZ.",
                    label = "Tűzcső RZ",
                },
                hydrantX = {
                    description = "Konfigurálja: Tűzcső X.",
                    label = "Tűzcsap X pozíció",
                },
                hydrantY = {
                    description = "Konfigurálja: Tűzcső Y.",
                    label = "Tűzcsap Y pozíció",
                },
                hydrantZ = {
                    description = "Konfigurálja: Tűzcső Z.",
                    label = "Tűzcsap Z pozíció",
                },
                igniteDistance = {
                    description = "Annak a távolságának megadása, amilyen közel kell lennie a játékosnak a gyújtóforráshoz, hogy elhelyezze azt.",
                    label = "Gyújtóforrás távolsága",
                },
                interiorExtinguishersAllowedJobs = {
                    description = "Hagyja üresen, hogy minden foglalkozást engedélyezzen. Kapcsolja ki a 'Szolgálat szükséges' beállítást, hogy mindenki elvegye és utántölthesse a tűzoltóeszközöket.",
                    itemLabel = "Foglalkozás",
                    label = "Engedélyezett foglalkozások",
                },
                interiorExtinguishersEmptyMountHeadingOffset = {
                    description = "Modellspecifikus dőlésszög-korrekció az üres tartóra.",
                    label = "Tartó dőlésszög-korrekció",
                },
                interiorExtinguishersEmptyMountModel = {
                    description = "A helyén megjelenítve a kiegészítő, ha a tűzoltó hiányzik.",
                    label = "Üres tartó modell",
                },
                interiorExtinguishersEmptyMountOffsetX = {
                    description = "A kiegészítő forgatása után alkalmazott helyi bal/jobbrés. Negatív értékek balra tolják.",
                    label = "Tartó X eltolás",
                },
                interiorExtinguishersEmptyMountOffsetY = {
                    description = "A kiegészítő forgatása után alkalmazott helyi előre/hátrátrés.",
                    label = "Tartó Y eltolás",
                },
                interiorExtinguishersEmptyMountOffsetZ = {
                    description = "A kiegészítő forgatása után alkalmazott helyi függőleges eltolás.",
                    label = "Tartó Z eltolás",
                },
                interiorExtinguishersEmptyMountStreamDistance = {
                    description = "Az üres tűzoltó-tartók betöltésének hatótávolsága.",
                    label = "Tartó betöltési távolság",
                },
                interiorExtinguishersEmptyThresholdPercent = {
                    description = "Az a töltöttségi százalék, amely alatt a tűzoltó üresnek minősül.",
                    label = "Ürességi küszöb százalék",
                },
                interiorExtinguishersEnabled = {
                    description = "Lehetővé teszi, hogy a tűzoltók a belső terekben elhelyezett tűzoltó-kiegészítőket vegyék fel.",
                    label = "Felvétel engedélyezése",
                },
                interiorExtinguishersFullAmmo = {
                    description = "A 100 százalékos töltöttségnek megfelelő nyers fegyver-műanyag, százalékos metaadatok nélküli készleteknél.",
                    label = "Telt tűzoltó műanyaga",
                },
                interiorExtinguishersInteractionDistance = {
                    description = "Az E gomb lenyomásának maximális távolsága a tűzoltó-kiegészítőhöz képest.",
                    label = "Felvételi távolság",
                },
                interiorExtinguishersItem = {
                    description = "Egy tárgy vagy fegyver, amelyet felvenni és elfogyasztani kell, amikor egy tartót feltöltünk.",
                    label = "Tárolóelem",
                },
                interiorExtinguishersLabel = {
                    description = "A felvételi és feltöltési interakciókban megjelenített név.",
                    label = "Megjelenítendő címke",
                },
                interiorExtinguishersMaintenanceAllowedJobs = {
                    description = "További munkák, amelyek használhatják a tűzoltó körkörös akciókat. A tűzoltó-munkák mindig szerepelnek.",
                    itemLabel = "Foglalkozás",
                    label = "Körkörös és karbantartási munkák",
                },
                interiorExtinguishersMaintenanceEnabled = {
                    description = "Követi az üres és sérült tűzoltók állapotát.",
                    label = "Karbantartási állapotok engedélyezése",
                },
                interiorExtinguishersMaintenanceRequireOnDuty = {
                    description = "Az engedélyezett karbantartási munkáknak szolgálatban kell lenniük.",
                    label = "Szolgálat kötelező",
                },
                interiorExtinguishersModels = {
                    description = "A belső térben elhelyezhető objektum-modellek.",
                    itemLabel = "Modell",
                    label = "Tűzoltó-kiegészítő modellek",
                },
                interiorExtinguishersNoDutyJobs = {
                    description = "Ezekben a munkákban lévő tűzoltókat szolgálat nélkül is felvehetik és feltölthetik.",
                    itemLabel = "Foglalkozás",
                    label = "Szolgálat nélküli munkák",
                },
                interiorExtinguishersPickupDurationMs = {
                    description = "Az animáció és a folyamat időtartama a tűzoltó felvétele előtt.",
                    label = "Felvételi időtartam ms",
                },
                interiorExtinguishersPlacementAllowedJobs = {
                    description = "Hagyja üresen a általános tűzoltó-munkák vagy az összes konfigurált tűzoltó-munka használatához.",
                    itemLabel = "Foglalkozás",
                    label = "Elhelyezési munkák",
                },
                interiorExtinguishersPlacementConsumeItem = {
                    description = "Pontosan egy szerelőkészletet távolít el csak akkor, ha az elhelyezés sikeres.",
                    label = "Tárgy elfogyasztása elhelyezésnél",
                },
                interiorExtinguishersPlacementDynamic = {
                    description = "Fizikát engedélyez a felhelyezett tűzoltóra.",
                    label = "Dinamikus kiegészítő",
                },
                interiorExtinguishersPlacementEnabled = {
                    description = "Lehetővé teszi, hogy a jogosult tűzoltók tűzoltó-szerelőkészleteket helyezzék el a világban.",
                    label = "Elhelyezés engedélyezése",
                },
                interiorExtinguishersPlacementItem = {
                    description = "A kész tűzoltó-szerelőkészlet elhelyezésének elindítására szolgáló készlet-tárgy.",
                    label = "Elhelyezési tárgy",
                },
                interiorExtinguishersPlacementModel = {
                    description = "A szabadon elhelyezett tűzoltókészülékekhez használt objektum-modell.",
                    label = "Elhelyezett kiegészítő modell",
                },
                interiorExtinguishersPlacementPickupDistance = {
                    description = "A lefektetett tűzoltókészülék eltávolításának maximális távolsága.",
                    label = "Felvételi távolság",
                },
                interiorExtinguishersPlacementRequireOnDuty = {
                    description = "Csak szolgálatban lévő tűzoltók helyezhetnek el és távolíthatnak el tűzoltókészülékeket.",
                    label = "Szolgálat szükséges az elhelyezéshez",
                },
                interiorExtinguishersPlacementReturnItem = {
                    description = "Visszaadja a szerelőkészletet, amikor a lefektetett kiegészítőt eltávolítják.",
                    label = "Elem visszaadása felvételekor",
                },
                interiorExtinguishersPlacementStreamDistance = {
                    description = "Az elhelyezett tűzoltókészülék betöltésének hatótávolsága.",
                    label = "Streaming-távolság",
                },
                interiorExtinguishersPlacementWallEnabled = {
                    description = "A tűzoltókészüléket a felhelyezési sugárhúzó által kiválasztott függőleges felületekhez igazítja.",
                    label = "Falra helyezés engedélyezése",
                },
                interiorExtinguishersPlacementWallHeadingOffset = {
                    description = "A tűzoltókészülék a fal igazítása után a függőleges tengelye körül forog.",
                    label = "Fal forgási korrekció",
                },
                interiorExtinguishersPlacementWallOffset = {
                    description = "A tűzoltókészüléket a kijelölt fal felületének normálisa mentén a faltól távolabbra helyezi.",
                    label = "Fal távolság",
                },
                interiorExtinguishersPlacementZOffset = {
                    description = "A lefektetett tűzoltókészülékre alkalmazott függőleges eltolás.",
                    label = "Földi Z eltolás",
                },
                interiorExtinguishersRequireOnDuty = {
                    description = "Csak a megengedett foglalkozásokban szolgálatban álló tagok vehetik ki és tölthetik fel újra a tűzoltókészülékeket.",
                    label = "Szolgálat kötelező",
                },
                interiorExtinguishersRestoreDistance = {
                    description = "A tűzoltóval a gomb lenyomásakor a lefektetett tartóhoz mért maximális távolság.",
                    label = "Töltési távolság",
                },
                interiorExtinguishersRestoreDurationMs = {
                    description = "Az animáció és a folyamat időtartama a tűzoltó-tárgy elfogyasztása előtt.",
                    label = "Töltési időtartam ms",
                },
                interiorExtinguishersScanDistance = {
                    description = "A játékos körül lévő objektumkeresési sugár.",
                    label = "Keresési távolság",
                },
                label = {
                    description = "Konfigurálja: Felirat.",
                    label = "Címke",
                },
                lighterAnimationDict = {
                    description = "A gyújtó beültetése közben használt animációs szótár.",
                    label = "Animációs szótár",
                },
                lighterAnimationDurationMs = {
                    description = "Mennyi ideig tart a gyújtó animációja és a folyamat, mielőtt a gyújtó be van ültetve.",
                    label = "Animációs időtartam ms",
                },
                lighterAnimationFlag = {
                    description = "A gyújtó animációhoz használt TaskPlayAnim jelző.",
                    label = "Animációs jelző",
                },
                lighterAnimationName = {
                    description = "A gyújtó beültetése közben használt animációs klip.",
                    label = "Animációs név",
                },
                lighterConsumeItem = {
                    description = "A sikeres gyújtás után elfogyasztja a konfigurált gyújtó tárgyat.",
                    label = "Gyújtó tárgy elfogyasztása",
                },
                lighterCooldownSeconds = {
                    description = "Közös hűtési idő a gyújtó tárgyakhoz és járművekhez való használati lehetőségei között.",
                    label = "Hűtési idő másodperc",
                },
                lighterIgniteDelaySeconds = {
                    description = "Késleltetés a sikeres gyújtás és a tényleges tűz keletkezése között, hogy a játékosnak legyen ideje elmenekülni.",
                    label = "Gyújtási késleltetés másodperc",
                },
                lighterItem = {
                    description = "Az inventárban lévő tárgy, amelyet a járművekre és más konfigurált gyújtási forrásokra történő gyújtáshoz használnak.",
                    label = "Gyújtó tárgy",
                },
                lighterVehicleEnabled = {
                    description = "Engedélyezi, hogy a gyújtó tárgy meggyújtsa a közelben lévő járműveket.",
                    label = "Jármű-gyújtás engedélyezése",
                },
                lighterVehicleMaxDistance = {
                    description = "A járműhöz mért maximális távolság a gyújtó elhelyezéséhez.",
                    label = "Jármű-gyújtási távolság",
                },
                lighterVehicleOffsetX = {
                    description = "A telepített járműtűz pozíciójához használt helyi X eltolás.",
                    label = "Járműtűz eltolás X",
                },
                lighterVehicleOffsetY = {
                    description = "A telepített járműtűz pozíciójához használt helyi Y eltolás.",
                    label = "Járműtűz eltolás Y",
                },
                lighterVehicleOffsetZ = {
                    description = "A telepített járműtűz pozíciójához használt helyi Z eltolás.",
                    label = "Járműtűz eltolás Z",
                },
                lighterVehicleRequireOnDuty = {
                    description = "Csak akkor engedélyezi a jármű-gyújtást, ha a játékos a konfigurált tűzoltó foglalkozásban szolgálatban áll.",
                    label = "Tűzoltó szolgálat szükséges",
                },
                lighterVehicleRequiredJobs = {
                    description = "Ha kitöltve, a jármű-gyújtás csak akkor működik, ha a konfigurált számú konkrét foglalkozás online van.",
                    itemLabel = "Foglalkozás",
                    label = "Kötelező online foglalkozások",
                },
                lighterVehicleSourceScale = {
                    description = "A gyújtóval járműveken indított tűzökre alkalmazott skálázási szorzó.",
                    label = "Járműtűz mérete",
                },
                npcFireReactionsCooldownMs = {
                    description = "Késleltetés, amíg ugyanaz az NPC újra reagálhat egy tűzre.",
                    label = "NPC reakció hűtési idő ms",
                },
                npcFireReactionsDurationMs = {
                    description = "Mennyi ideig tart egy aktív NPC-reakció, mielőtt lejár.",
                    label = "NPC-reakció időtartama ms",
                },
                npcFireReactionsEnabled = {
                    description = "Lehetővé teszi, hogy a közelben lévő környezeti polgárok pánikba essenek vagy aktív tűzeket filmezhessenek.",
                    label = "NPC tűzreakciók engedélyezése",
                },
                npcFireReactionsFilmChance = {
                    description = "0,0 és 1,0 közötti esély arra, hogy egy alkalmas NPC filmezzen helyett, hogy semmit sem csinálna.",
                    label = "Telefonnal való filmzés esélye",
                },
                npcFireReactionsFilmEnabled = {
                    description = "Lehetővé teszi, hogy a megfelelő polgárok megálljanak és közel lévő tűzeket filmeljenek telefonjukkal.",
                    label = "Telefonnal való filmzés engedélyezése",
                },
                npcFireReactionsFilmRadius = {
                    description = "Ezen a távolságon belül lévő NPC-k telefonjukkal filmezhetik a tüzet.",
                    label = "NPC filmzési sugár",
                },
                npcFireReactionsFleeDistance = {
                    description = "Mennyire messzire menekülnek a pánikba eső NPC-k a tűz elől.",
                    label = "NPC menekülési távolság",
                },
                npcFireReactionsMaxTrackedPeds = {
                    description = "Meghatározza, hogy hány NPC-t vezérelhet a reakciórendszer egyszerre.",
                    label = "Maximális reagáló NPC-k száma",
                },
                npcFireReactionsPanicEnabled = {
                    description = "Lehetővé teszi, hogy a közelben lévő polgárok pánikba essenek és elmeneküljenek, ha a tűz túl közel kerül hozzájuk.",
                    label = "Pánikreakciók engedélyezése",
                },
                npcFireReactionsPanicRadius = {
                    description = "Ezen a távolságon belül lévő NPC-k előnyben részesítik a pánikot és a menekülést.",
                    label = "NPC pánikus sugár",
                },
                npcFireReactionsRadius = {
                    description = "Az a maximális távolság egy tűz és egy NPC között, amelyen belül az NPC egyáltalán reagálhat.",
                    label = "NPC reakció sugara",
                },
                npcFireReactionsUpdateInterval = {
                    description = "Meghatározza, hogy milyen gyakran keresi a rendszer a megfelelő NPC-ket az aktív tűzek közelében.",
                    label = "NPC reakció frissítési intervallum ms",
                },
                npcRescueAnimalEntrapmentEnabled = {
                    description = "Konfigurálja: Állatcsapdázást.",
                    label = "Állatcsapdázás",
                },
                npcRescueAnimalEntrapmentPanicChance = {
                    description = "Konfigurálja: A becsapdázott állat pánikolási esélyét.",
                    label = "Becsapdázott állat pánikolási esélye",
                },
                npcRescueAnimalTreeEnabled = {
                    description = "Konfigurálja: Állat fán / magasban.",
                    label = "Állat fán / magasban",
                },
                npcRescueAnimalTreePanicChance = {
                    description = "Konfigurálja: A fán lévő állat pánikolási esélyét.",
                    label = "A fán lévő állat pánikolási esélye",
                },
                npcRescueAnimalWaterEnabled = {
                    description = "Konfigurálja: Az állatok vízimentését.",
                    label = "Vízimentés állatoknak",
                },
                npcRescueAnimalWaterPanicChance = {
                    description = "Konfigurálja: A vízben lévő állat pánikolási esélyét.",
                    label = "A vízben lévő állat pánikolási esélye",
                },
                npcRescueBicycleEnabled = {
                    description = "Konfigurálja: Vidéki kerékpáros balesetet.",
                    label = "Vidéki kerékpáros baleset",
                },
                npcRescueDropoffRadius = {
                    description = "A szükséges távolság, hogy a megmentett beteget átadhassa a mentőautónak.",
                    label = "Leszállási sugár",
                },
                npcRescueEnabled = {
                    description = "NPC mentőmissziók és feladatfolyamatok engedélyezése.",
                    label = "Engedélyezve",
                },
                npcRescueFieldExtractionDurationMs = {
                    description = "Konfigurálja: Az alapértelmezett mentés/evakuálás időtartamát ms-ben.",
                    label = "Alapértelmezett mentés/evakuálás időtartama ms",
                },
                npcRescueFieldStabilizationDurationMs = {
                    description = "Konfigurálja: Az alapértelmezett stabilizálás időtartamát ms-ben.",
                    label = "Alapértelmezett stabilizálás időtartama ms",
                },
                npcRescueForestEnabled = {
                    description = "Konfigurálja: Erdőben történő sérülést / erdőmentést.",
                    label = "Erdőben történő sérülés / erdőmentés",
                },
                npcRescueRubbleEnabled = {
                    description = "Konfigurálja: Romokba ragadást / rommentést.",
                    label = "Romokba ragadás / rommentés",
                },
                npcRescueSearchRadius = {
                    description = "A járművekhez nem kapcsolódó mentőszínterekhez használt keresési sugár.",
                    label = "Keresési sugár",
                },
                oilAbsorbentBrushRadius = {
                    description = "A felszívó minijátékban egy felszívószóró mozgás sugara.",
                    label = "Szórás sugara",
                },
                oilAbsorbentGranulesPerMove = {
                    description = "Hány felszívó szemcsét hoz létre minden érvényes mozgáslépés.",
                    label = "Szemcsék mozgásonként",
                },
                oilAbsorbentMinigameEnabled = {
                    description = "Az egyszerű kötés akciót a felszívó szórás minijátékra cseréli.",
                    label = "Felszívó minijáték engedélyezése",
                },
                oilAbsorbentRequiredCoverage = {
                    description = "Mekkora része kell, hogy legyen lefedve a kifolyásnak ahhoz, hogy a felszívási fázis sikeres legyen.",
                    label = "Kötelező lefedettség",
                },
                oilCleanupAbsorbentItem = {
                    description = "Az olajtisztítás felszívási fázisához szükséges inventártárgy.",
                    label = "Felszívó tárgy",
                },
                oilCleanupAllowedJobs = {
                    description = "A fehérlistán szereplő munkák az ebben a tűzoltómunkában konfiguráltakon kívül is eltüntethetik az olajfolyásokat.",
                    label = "További engedélyezett munkák",
                },
                oilCleanupBindDurationMs = {
                    description = "Helyettesítő előrehaladási időtartam, ha a felszívó minijáték letiltva.",
                    label = "Helyettesítő kötés időtartama ms",
                },
                oilCleanupBroomItem = {
                    description = "A megkötött olajfolyás felsepréséhez szükséges inventártárgy.",
                    label = "Seprű tárgy",
                },
                oilCleanupConsumeAbsorbent = {
                    description = "Egy felszívó tárgyat használ el sikeres használat esetén.",
                    label = "Felszívó tárgy felhasználása",
                },
                oilCleanupConsumeBroom = {
                    description = "Felhasználja a konfigurált seprű tárgyat a sikeres tisztítás után.",
                    label = "Seprű tárgy felhasználása",
                },
                oilCleanupRequireOnDuty = {
                    description = "Az engedélyezett tisztítófoglalkozások minden tagjának szolgálatban kell lennie.",
                    label = "Szolgálat kötelező",
                },
                oilCleanupSweepDurationMs = {
                    description = "Helyettesítő előrehaladási időtartam, ha a seprő minijáték letiltva van.",
                    label = "Helyettesítő seprési időtartam ms-ben",
                },
                oilSpillsActive = {
                    description = "Aktív olajfolyások élő listája teleportálási és törlési akciókkal.",
                    label = "Aktív olajfolyások",
                },
                oilSpillsDefaultIntensity = {
                    description = "Alapértelmezett veszélyességi intenzitás újonnan létrehozott olajfolyásokhoz.",
                    label = "Alapértelmezett intenzitás",
                },
                oilSpillsDeleteOnRestart = {
                    description = "A tárolt olajfolyások törlése erőforrásindításkor a visszaállításuk helyett.",
                    label = "Törlés újraindításkor",
                },
                oilSpillsEnabled = {
                    description = "Engedélyezi az olajfoltokat, a csúszást és a takarítást. Az ütközések vagy kopás után automatikusan keletkező olajszivárgásokhoz a Sky Mechanic vagy egy másik csatlakoztatott erőforrás szükséges.",
                    label = "Olajszivárgás-rendszer engedélyezése",
                },
                oilSpillsInteractionDistance = {
                    description = "A kölcsönhatáshoz és az olajfolyás eltüntetéséhez szükséges távolság.",
                    label = "Interakciótávolság",
                },
                oilSpillsLifetimeMinutes = {
                    description = "Mennyi ideig maradnak aktívak a nem eltüntetett olajfolyások, mielőtt lejárnának.",
                    label = "Élettartam percben",
                },
                oilSpillsMaxActive = {
                    description = "A egyszerre létezhető szinkronizált olajfolyások maximális száma.",
                    label = "Maximális aktív olajfolyások",
                },
                oilSpillsObjectGroundOffset = {
                    description = "A folyófelület jobb illeszkedéséhez alkalmazott földrajzi eltolás az olajfolyás objektumokra.",
                    label = "Objektum földrajzi eltolás",
                },
                oilSpillsRemoveBelow = {
                    description = "Az olajfolyásokat automatikusan eltüntetik, ha az intenzitásuk ez alatt az érték alatt esik.",
                    label = "Eltávolítás alacsonyabb intenzitásnál",
                },
                oilSpillsResetIds = {
                    buttonLabel = "Azonosítók visszaállítása",
                    description = "Újra számozza az összes aktív olajfolyást 1-től kezdve, részek nélkül, és szinkronizálja minden játékost.",
                    label = "Olajfolyás azonosítók visszaállítása",
                },
                oilSpillsSlipRadius = {
                    description = "A sugár, amelyen belül a játékosok és a pedek csúszhatnak az olajfolyáson.",
                    label = "Csúszás sugara",
                },
                oilSweepBrushRadius = {
                    description = "A seprési előrehaladáshoz hozzájáruló seprővonal körüli sugár.",
                    label = "Seprési sugár",
                },
                oilSweepMaxSidewaysRatio = {
                    description = "A seprővonal figyelmen kívül hagyása előtt megengedett maximális oldalsó mozgási arány.",
                    label = "Oldalsó tolerancia",
                },
                oilSweepMinStrokeDistance = {
                    description = "A seprővonal előrehaladásának hozzáadása előtt szükséges minimális kurzortávolság.",
                    label = "Minimális seprési távolság",
                },
                oilSweepMinUpwardDelta = {
                    description = "Egy érvényes seprőmozdulathoz szükséges minimális felfelé irányuló mozgás.",
                    label = "Minimális felfelé irányuló mozgás",
                },
                oilSweepMinigameEnabled = {
                    description = "A seprő minijáték váltja fel az egyszerű seprési előrehaladás sávját.",
                    label = "Seprő minijáték engedélyezése",
                },
                oilSweepRequiredProgress = {
                    description = "A kötött olajfolt eltávolításához szükséges előrehaladás 0.0-tól 1.0-ig.",
                    label = "Szükséges seprési előrehaladás",
                },
                oilSweepToolWidth = {
                    description = "A seprő minijátékban megjelenített seprőkép szélessége.",
                    label = "Seprőkép szélessége",
                },
                playerEntrapmentAllowOffDuty = {
                    description = "A minimális online személyzet ellenőrzésekor a konfigurált szolgálaton kívüli megfelelő munkát is beleszámolja.",
                    label = "Szolgálaton kívüli munkák számlálása",
                },
                playerEntrapmentAutoReleaseWhenRepaired = {
                    description = "Beállítás: Megjavításkor szabadon engedés.",
                    label = "Megjavításkor szabadon engedés",
                },
                playerEntrapmentBaseChance = {
                    description = "Beállítás: Alapvető esély.",
                    label = "Alapvető esély",
                },
                playerEntrapmentCooldownSeconds = {
                    description = "Beállítás: Hűtési idő másodpercek.",
                    label = "Hűtési idő másodperc",
                },
                playerEntrapmentDoorOverviewEnabled = {
                    description = "A bezáródott HUD-ban egy kis járművet mutat, amely sérült, nyitott és használható kilépési ajtókkal rendelkezik.",
                    label = "Ajtóátlátás megjelenítése",
                },
                playerEntrapmentEnabled = {
                    description = "A játékosok elegendő járműkárosodás vagy felborulás után bezáródhatnak.",
                    label = "Játékos bezáródás engedélyezése",
                },
                playerEntrapmentHudEnabled = {
                    description = "Beállítás: Bezáródott HUD megjelenítése.",
                    label = "Bezáródott HUD megjelenítése",
                },
                playerEntrapmentMinBodyHealthLoss = {
                    description = "Az egy ütközés során legalább elvesztett testegészség, amely a bezáródás aktiválódásához szükséges. Alacsonyabb értékek könnyebben aktiválják.",
                    label = "Minimális testkárosodás",
                },
                playerEntrapmentMinEngineHealthLoss = {
                    description = "Az egy ütközés során legalább elvesztett motorégség, amely a bezáródás aktiválódásához szükséges. Alacsonyabb értékek könnyebben aktiválják.",
                    label = "Minimális motorkárosodás",
                },
                playerEntrapmentPreventExit = {
                    description = "Beállítás: Jármű elhagyásának blokkolása.",
                    label = "Jármű elhagyásának blokkolása",
                },
                playerEntrapmentReleaseOnAnyDoor = {
                    description = "Beállítás: Bármely nyitott ajtó utáni szabadon engedés.",
                    label = "Bármely nyitott ajtó utáni szabadon engedés",
                },
                playerEntrapmentRepairedBodyHealthThreshold = {
                    description = "Beállítás: Megjavítási küszöb (test).",
                    label = "Megjavítási küszöb (test)",
                },
                playerEntrapmentRepairedEngineHealthThreshold = {
                    description = "Beállítás: Megjavítási küszöb (motor).",
                    label = "Megjavítási küszöb (motor)",
                },
                playerEntrapmentRepairedMaxRoll = {
                    description = "Beállítás: Megjavítási maximális felborulási szög.",
                    label = "Megjavítási maximális felborulási szög",
                },
                playerEntrapmentRequiredJobs = {
                    description = "Ha itt vannak bejegyzések, a járműbekapcsolódás csak akkor indul el, ha a konfigurált számú konkrét munka online van.",
                    itemLabel = "Munkahely",
                    label = "Kötelező online munkák",
                },
                playerEntrapmentRolloverBonusChance = {
                    description = "Beállítás: Felborulási bónusz esély.",
                    label = "Felborulási bónusz esély",
                },
                playerEntrapmentRolloverMinRoll = {
                    description = "Beállítás: Felborulási küszöb.",
                    label = "Felborulási küszöb",
                },
                propIgnitionDuplicateDistance = {
                    description = "Megakadályozza, hogy túl közel egy meglévő tűzhez helyezzen el egy új gyújtást.",
                    label = "Minimális távolság a meglévő tűzhöz",
                },
                propIgnitionEnabled = {
                    description = "Engedélyezi, hogy kiválasztott objektumokat és rögzített gyújtási forrásokat használjon a gyújtóval elhelyezett gyújtásokhoz.",
                    label = "Objektumgyújtási pontok engedélyezése",
                },
                propIgnitionHighlightEnabled = {
                    description = "A gyújtó keresése közben a megfelelő gyújtási forrásokat keretbe veszi.",
                    label = "Gyújtási pontok kiemelése",
                },
                propIgnitionMaxActiveFires = {
                    description = "Ezekből a gyújtási pontokból egyszerre létező maximális aktív tűzök száma.",
                    label = "Maximális aktív objektumtűzök",
                },
                propIgnitionProps = {
                    description = "Olyan objektummodellek vagy rögzített gyújtási források, ahol a gyújtóval elhelyezett gyújtást használhat.",
                    itemLabel = "Gyújtási forrás",
                    label = "Lehetséges gyújtási források",
                },
                propIgnitionRequireLineOfSight = {
                    description = "Csak szabad látóvonalú gyújtási pontok kerülhetnek kiemelésre és használhatók.",
                    label = "Kötelező szabad látóvonal",
                },
                propIgnitionScanDistance = {
                    description = "Az a sugár, amelyen belül a környéken lévő lehetséges gyújtási pontok érzékelhetők.",
                    label = "Gyújtási pontok keresési sugara",
                },
                propIgnitionScanDurationMs = {
                    description = "Az az időtartam, ameddig az érzékelt gyújtási pontok kiemelve maradnak, mielőtt a keresés automatikusan lezárul.",
                    label = "Kiemelés időtartama ms",
                },
                pumpDischargeCount = {
                    description = "Beállítás: Szivattyú kiszerelések.",
                    label = "Szivattyú kiszerelések",
                },
                rescueCushionAllowedJobs = {
                    description = "Hagyja üresen, hogy az összes beállított tűzoltói munkahely elhelyezhesse a mentőpárnát.",
                    itemLabel = "Foglalkozás",
                    label = "Engedélyezett foglalkozások",
                },
                rescueCushionConsumeItem = {
                    description = "Egy mentőpárnát eltávolít a táskából elhelyezéskor.",
                    label = "Tárgy felhasználása elhelyezéskor",
                },
                rescueCushionEnabled = {
                    description = "A mentőpárna rendszer teljes be- vagy kikapcsolása.",
                    label = "Mentőpárna engedélyezése",
                },
                rescueCushionItem = {
                    description = "A táskában lévő tárgy, amivel a mentőpárna elhelyezhető.",
                    label = "Tárgy neve",
                },
                rescueCushionLabel = {
                    description = "A elhelyezett mentőpárna objektumának megjelenített neve.",
                    label = "Címke",
                },
                rescueCushionLandingHeight = {
                    description = "A párnától mért maximális magasságkülönbség, amely alatt a leszállási védelem még érvényes.",
                    label = "Leszállási magasság",
                },
                rescueCushionLandingRadius = {
                    description = "A párnát körülvevő vízszintes sugár, amelyen belül a zuhanó játékosok védettek.",
                    label = "Leszállási sugár",
                },
                rescueCushionModel = {
                    description = "A világobjektum modell, amely a párnát elhelyezéskor megjelenik.",
                    label = "Objektum modell",
                },
                rescueCushionPickupDistance = {
                    description = "A távolság, ameddig a játékosnak közel kell lennie a elhelyezett mentőpárna felvételéhez.",
                    label = "Felvételi távolság",
                },
                rescueCushionRequireOnDuty = {
                    description = "Csak a szolgálatban lévő tűzoltók helyezhetik el a mentőpárnát.",
                    label = "Szolgálat kötelező",
                },
                rescueCushionReturnItemOnRemove = {
                    description = "Visszaadja a beállított tárgyat a játékosnak, amikor a elhelyezett párnát felveszi.",
                    label = "Tárgy visszaadása felvételkor",
                },
                rescueCushionStreamDistance = {
                    description = "A távolság, ameddig a elhelyezett mentőpárna objektum megjelenik a közeli játékosok számára.",
                    label = "Streaming-távolság",
                },
                rescueCushionZOffset = {
                    description = "A generált mentőpárna objektumra alkalmazott függőleges eltolás.",
                    label = "Elhelyezési Z eltolás",
                },
                rx = {
                    description = "Beállítja: RX.",
                    label = "RX",
                },
                ry = {
                    description = "Beállítja: RY.",
                    label = "RY",
                },
                rz = {
                    description = "Beállítja: RZ.",
                    label = "RZ",
                },
                scbaHudPosition = {
                    description = "A légzőkészülék manométer HUD pozíciója.",
                    label = "Manométer pozíciója",
                },
                scenarioAutomaticMissions = {
                    description = "Engedélyezi az automatikus indítást minden misszióhoz, beállítja a szükséges szolgálatban lévő tagok számát, kiválasztja azokat a munkahelyeket, amelyek számításba jönnek az adott misszióhoz, és kiválasztja, mely munkahelyek kapják a riasztást. Az üres listák a globális szolgálati vagy riasztási munkahelyeket használják.",
                    itemLabel = "Művelet",
                    label = "Elérhető missziók",
                },
                scenarioCreatorAllowRescue = {
                    description = "Lehetővé teszi a misszióalkotó számára, hogy betegeket és állatokat megmentő feladatokat helyezzen el.",
                    label = "Mentés fül",
                },
                scenarioCreatorAllowVehicleFire = {
                    description = "Lehetővé teszi a misszióalkotó számára, hogy beállított égő járműveket helyezzen el.",
                    label = "Járműtűz fül",
                },
                scenarioCreatorEnabled = {
                    description = "A tűzoltó misszióalkotó és a központi eszközök engedélyezése.",
                    label = "Engedélyezve",
                },
                scenarioCreatorOpenMenu = {
                    buttonLabel = "Misszióalkotó megnyitása",
                    description = "A Sky Fire Misszióalkotó menü megnyitása és a Munkahely Konfigurátor bezárása.",
                    label = "Misszióalkotó menü",
                    unsavedTooltip = "Először mentés",
                },
                scenarioDispatchEnabled = {
                    description = "Létrehoz egy sky_jobs_base riasztást, amikor egy misszió elindul.",
                    label = "Riasztás küldése",
                },
                scenarioDispatchJobs = {
                    description = "Használatra kerül, ha egy misszióhoz nincs beállítva saját riasztási munkahely.",
                    itemLabel = "Munkahely",
                    label = "Riasztási cél munkahelyek",
                },
                scenarioRandomChance = {
                    description = "Valószínűség intervallumonként 0,0 és 1,0 között.",
                    label = "Kiváltási esély",
                },
                scenarioRandomEnabled = {
                    description = "A beállított időköz után automatikusan elindít egy engedélyezett küldetést.",
                    label = "Automatikus küldetések engedélyezése",
                },
                scenarioRandomSelectionMode = {
                    description = "A véletlen rotáció minden jelenleg megfelelő bevetést egyszer indít el az ismétlés előtt. A teljesen véletlen kiválasztás engedi az ismétléseket.",
                    label = "Bevetések kiválasztása",
                    options = {
                        rotation = "Véletlen rotáció",
                        random = "Teljesen véletlen",
                    },
                },
                scenarioRandomIntervalMax = {
                    description = "Konfigurálja: Maximális időköz perc.",
                    label = "Maximális időköz perc",
                },
                scenarioRandomIntervalMin = {
                    description = "Konfigurálja: Minimális időköz perc.",
                    label = "Minimális időköz perc",
                },
                scenarioRandomJobs = {
                    description = "Ha a kiválasztott küldetésnek nincs saját, küldetés-specifikus állása, akkor ezeknek az állásoknak a szolgálatban lévő játékói számítanak.",
                    itemLabel = "Foglalkozás",
                    label = "Alapértelmezett szolgálati foglalkozások",
                },
                scenarioRandomManualOnly = {
                    description = "Konfigurálja: Csak manuálisan indítható küldetések.",
                    label = "Csak manuálisan indítható küldetések",
                },
                smokePoisoningEnabled = {
                    description = "Be- vagy kikapcsolja a füstexpozíciót, a füstmérgezést és a kapcsolódó füsthatásokat.",
                    label = "Füstmérgezés engedélyezése",
                },
                smokeVehicleClosedExposureMultiplier = {
                    description = "Füstexpozíció szorzó, amíg az összes releváns oldalszél érintetlen.",
                    label = "Zárt jármű füstszorzó",
                },
                smokeVehicleExposureMultiplier = {
                    description = "Füstexpozíció szorzó, amint egy védett jármű elveszíti az ablakvédelmét, vagy nem védett járműtípusok esetén.",
                    label = "Törött vagy nyitott jármű füstszorzó",
                },
                smokeVehicleProtectAutomobiles = {
                    description = "Konfigurálja: Autók védelme.",
                    label = "Autók védelme",
                },
                smokeVehicleProtectBoats = {
                    description = "Konfigurálja: Hajók védelme.",
                    label = "Hajók védelme",
                },
                smokeVehicleProtectCycles = {
                    description = "Konfigurálja: Kerékpárok védelme.",
                    label = "Kerékpárok védelme",
                },
                smokeVehicleProtectHelicopters = {
                    description = "Konfigurálja: Helikopterek védelme.",
                    label = "Helikopterek védelme",
                },
                smokeVehicleProtectMotorcycles = {
                    description = "Konfigurálja: Motorkerékpárok védelme.",
                    label = "Motorkerékpárok védelme",
                },
                smokeVehicleProtectPlanes = {
                    description = "Konfigurálja: Repülőgépek védelme.",
                    label = "Repülőgépek védelme",
                },
                smokeVehicleProtectionEnabled = {
                    description = "Lehetővé teszi, hogy a konfigurált járműtípusok megvédjék az utasokat a füsttől, amíg a jármű zárt marad.",
                    label = "Jármű füstvédelem engedélyezése",
                },
                smokeWarningHudPosition = {
                    description = "A füstmérgezés HUD sávának pozíciója.",
                    label = "Füstmérgezés sáv pozíciója",
                },
                societyRewardFireEnabled = {
                    description = "Globális kapcsoló a társaság kifizetéseinek bekapcsolásához egy tűz eloltása után.",
                    label = "Tűz kifizetések engedélyezése",
                },
                societyRewardFireJobs = {
                    description = "Konfigurálja külön-külön minden állást a saját engedélyezett állapotával és kifizetési összegével. Írd be az állás nevét; a konfigurált társasági számlája kapja meg a pénzt.",
                    itemLabel = "Foglalkozás",
                    label = "Tűz jutalom állások",
                },
                societyRewardFireScenarioEnabled = {
                    description = "Fizeti a tűzjutalmat akkor is, ha egy Mission Creator küldetéshez tartozó tüzet oltanak el.",
                    label = "Küldetés tűzek kifizetése",
                },
                societyRewardOilEnabled = {
                    description = "Globális kapcsoló a társaság kifizetéseinek bekapcsolásához egy olajszennyezés eltakarítása után.",
                    label = "Olaj kifizetések engedélyezése",
                },
                societyRewardOilJobs = {
                    description = "Konfigurálja külön-külön minden állást a saját engedélyezett állapotával és kifizetési összegével. Írd be az állás nevét; a konfigurált társasági számlája kapja meg a pénzt.",
                    itemLabel = "Foglalkozás",
                    label = "Olaj jutalom munkák",
                },
                societyRewardOilScenarioEnabled = {
                    description = "A misszióteremtő missziójához tartozó olajfolt eltakarítása esetén is kifizeti az olajjutalmat.",
                    label = "Missziós olajfoltok kifizetése",
                },
                societyRewardRescueEnabled = {
                    description = "Globális kapcsoló a társaság kifizetéseinek engedélyezésére egy mentési feladat befejezése után.",
                    label = "Mentési kifizetések engedélyezése",
                },
                societyRewardRescueJobs = {
                    description = "Konfigurálja külön-külön minden állást a saját engedélyezett állapotával és kifizetési összegével. Írd be az állás nevét; a konfigurált társasági számlája kapja meg a pénzt.",
                    itemLabel = "Foglalkozás",
                    label = "Mentési jutalom munkák",
                },
                societyRewardRescueScenarioEnabled = {
                    description = "Egy mentőfeladat befejezésekor a Mission Creator-misszióhoz tartozó mentőjutalom is kifizetésre kerül.",
                    label = "Mentőfeladatok kifizetése",
                },
                societyRewardTreeEnabled = {
                    description = "Globális kapcsoló a Society-jutalom kifizetésére egy lehullott fa eltakarítása után.",
                    label = "Fa-jutalom kifizetésének engedélyezése",
                },
                societyRewardTreeJobs = {
                    description = "Konfigurálja külön-külön minden állást a saját engedélyezett állapotával és kifizetési összegével. Írd be az állás nevét; a konfigurált társasági számlája kapja meg a pénzt.",
                    itemLabel = "Foglalkozás",
                    label = "Fa-jutalom munkák",
                },
                societyRewardTreeScenarioEnabled = {
                    description = "Egy lehullott fa eltakarításakor a Mission Creator-misszióhoz tartozó fa-jutalom is kifizetésre kerül.",
                    label = "Missionsfák kifizetése",
                },
                sourceScale = {
                    description = "Ez az égési forrásnál keletkező tűzre alkalmazott skálázási szorzó.",
                    label = "Keletkező tűz mérete",
                },
                textures = {
                    description = "Konfigurálja: Textúrák.",
                    label = "Textúrák",
                },
                trappedRescueAllowAnyDoor = {
                    description = "Konfigurálja: Bármilyen eltávolított ajtó engedélyezése.",
                    label = "Bármilyen eltávolított ajtó engedélyezése",
                },
                trappedRescueAllowCarry = {
                    description = "Konfigurálja: Mentett személy viselése engedélyezése.",
                    label = "Mentett személy viselése engedélyezése",
                },
                trappedRescueAllowDrop = {
                    description = "Konfigurálja: Személy leengedése engedélyezése.",
                    label = "Személy leengedése engedélyezése",
                },
                trappedRescueAmbulanceFreeze = {
                    description = "Konfigurálja: Ambulancia befagyasztása.",
                    label = "Ambulancia befagyasztása",
                },
                trappedRescueAmbulanceInvincible = {
                    description = "Konfigurálja: Megsemmisíthetetlen ambulancia.",
                    label = "Megsemmisíthetetlen ambulancia",
                },
                trappedRescueAmbulanceLights = {
                    description = "Konfigurálja: Mentőfények engedélyezése.",
                    label = "Mentőfények engedélyezése",
                },
                trappedRescueAmbulanceOpenRearDoors = {
                    description = "Konfigurálja: Hátsó ajtók kinyitása.",
                    label = "Hátsó ajtók kinyitása",
                },
                trappedRescueDropoffRadius = {
                    description = "Konfigurálja: Ambulancia letéti sugár.",
                    label = "Ambulancia letéti sugár",
                },
                trappedRescueEnabled = {
                    description = "Engedélyezi a személy- és állatmentési feladatokat a szcenáriók alapján.",
                    label = "NPC-mentési feladatok engedélyezése",
                },
                trappedRescueExtractionDurationMs = {
                    description = "Konfigurálja: Járműkivonás időtartama ms.",
                    label = "Járműkivonás időtartama ms",
                },
                trappedRescueForceGain = {
                    description = "Konfigurálja: Erőnyerés másodpercenként.",
                    label = "Erőnyerés másodpercenként",
                },
                trappedRescueForceLoss = {
                    description = "Konfigurálja: Erővesztés másodpercenként.",
                    label = "Erővesztés másodpercenként",
                },
                trappedRescueForceMax = {
                    description = "Konfigurálja: Jó húzás maximuma.",
                    label = "Jó húzás maximuma",
                },
                trappedRescueForceMin = {
                    description = "Konfigurálja: Jó húzás minimuma.",
                    label = "Jó húzás minimuma",
                },
                trappedRescueInteractionDistance = {
                    description = "Konfigurálja: NPC-interakciós távolság.",
                    label = "NPC-interakciós távolság",
                },
                trappedRescueJamChance = {
                    description = "Konfigurálja: Övzárak elakadásának esélye.",
                    label = "Övzárak elakadásának esélye",
                },
                trappedRescueMaxMisses = {
                    description = "Konfigurálja: Engedélyezett sikertelen húzások.",
                    label = "Engedélyezett sikertelen húzások",
                },
                trappedRescuePullsRequired = {
                    description = "Konfigurálja: Kötelező erős húzások.",
                    label = "Kötelező erős húzások",
                },
                trappedRescueReliefHoldMs = {
                    description = "Konfigurálja: Nyomófeszültség tartási idő ms.",
                    label = "Nyomófeszültség tartási idő ms",
                },
                trappedRescueReliefZoneMax = {
                    description = "Beállítja: Tónus zóna maximum.",
                    label = "Tónus zóna maximum",
                },
                trappedRescueReliefZoneMin = {
                    description = "Beállítja: Tónus zóna minimum.",
                    label = "Tónus zóna minimum",
                },
                trappedRescueRequireDoor = {
                    description = "Beállítja: Eltávolított ajtó szükséges.",
                    label = "Eltávolított ajtó szükséges",
                },
                trappedRescueRequireGlass = {
                    description = "Beállítja: Törött ablak szükséges.",
                    label = "Törött ablak szükséges",
                },
                trappedRescueRequireMatchingSide = {
                    description = "Beállítja: Az ablaknak a beteg oldalához kell illeszkednie.",
                    label = "Az ablaknak a beteg oldalához kell illeszkednie",
                },
                trappedRescueRequireOnDuty = {
                    description = "Beállítja: Szolgálatban kell lenni.",
                    label = "Szolgálat kötelező",
                },
                trappedRescueSeatbeltDurationMs = {
                    description = "Beállítja: Időlimit ms.",
                    label = "Időlimit ms",
                },
                trappedRescueSeatbeltEnabled = {
                    description = "Beállítja: Övminijáték engedélyezése.",
                    label = "Övminijáték engedélyezése",
                },
                treeBlipColor = {
                    description = "Beállítja: Blip szín.",
                    label = "Blip szín",
                },
                treeBlipLabel = {
                    description = "Beállítja: Blip felirat.",
                    label = "Blip felirat",
                },
                treeBlipScale = {
                    description = "Beállítja: Blip méret.",
                    label = "Blip méret",
                },
                treeBlipSprite = {
                    description = "Beállítja: Blip ikon.",
                    label = "Blip ikon",
                },
                treeCarryAnimDict = {
                    description = "Beállítja: Hordozási animáció könyvtár.",
                    label = "Hordozási animáció könyvtár",
                },
                treeCarryAnimFlag = {
                    description = "Beállítja: Hordozási animáció zászló.",
                    label = "Hordozási animáció zászló",
                },
                treeCarryAnimName = {
                    description = "Beállítja: Hordozási animáció neve.",
                    label = "Hordozási animáció neve",
                },
                treeCarryMoveBlend = {
                    description = "Beállítja: Hordozási mozgás keverése.",
                    label = "Hordozási mozgás keverése",
                },
                treeCarryOffsetRx = {
                    description = "Beállítja: Hordozási forgatás X.",
                    label = "Hordozási forgatás X",
                },
                treeCarryOffsetRy = {
                    description = "Beállítja: Hordozási forgatás Y.",
                    label = "Hordozási forgatás Y",
                },
                treeCarryOffsetRz = {
                    description = "Beállítja: Hordozási forgatás Z.",
                    label = "Hordozási forgatás Z",
                },
                treeCarryOffsetX = {
                    description = "Beállítja: Hordozási eltolás X.",
                    label = "Hordozási eltolás X",
                },
                treeCarryOffsetY = {
                    description = "Beállítja: Hordozási eltolás Y.",
                    label = "Hordozási eltolás Y",
                },
                treeCarryOffsetZ = {
                    description = "Beállítja: Hordozási eltolás Z.",
                    label = "Hordozási eltolás Z",
                },
                treeCarryProp = {
                    description = "Beállítja: Hordozott tárgy modell.",
                    label = "Hordozott prop modell",
                },
                treeCarryPropBone = {
                    description = "Beállítja: Hordozási csont.",
                    label = "Hordozási csont",
                },
                treeDispatchEnabled = {
                    description = "Beállítja: Fa-üzenet küldése.",
                    label = "Fa-üzenet küldése",
                },
                treeDispatchJobs = {
                    description = "Beállítja: Célzott munkák üzenetének küldése.",
                    itemLabel = "Foglalkozás",
                    label = "Célzott munkák üzenetének küldése",
                },
                treeDropCleanupRadius = {
                    description = "A lerakott faelemek eltávolításra kerülnek, ha nincs játékos ebben a tartományban.",
                    label = "Takarítási sugár",
                },
                treeDropMarkerA = {
                    description = "Beállítja: Jelölő átlátszósága.",
                    label = "Jelölő átlátszósága",
                },
                treeDropMarkerB = {
                    description = "Beállítja: Jelölő kék.",
                    label = "Marker kék",
                },
                treeDropMarkerG = {
                    description = "Beállítja: Jelölő zöld.",
                    label = "Marker zöld",
                },
                treeDropMarkerHeight = {
                    description = "Beállítja: Jelölő magassága.",
                    label = "Marker magasság",
                },
                treeDropMarkerR = {
                    description = "Beállítja: Jelölő vörös.",
                    label = "Marker piros",
                },
                treeDropMarkerType = {
                    description = "Beállítja: Jelölő típusa.",
                    label = "Jelzőtípus",
                },
                treeDropOffsetX = {
                    description = "Helyi oldalirányú eltolás az áthajtott fa mellől.",
                    label = "Leszállási eltolás X",
                },
                treeDropOffsetY = {
                    description = "Helyi eltolás a fa irányában.",
                    label = "Leszállási eltolás Y",
                },
                treeDropOffsetZ = {
                    description = "Függőleges leszállási eltolás.",
                    label = "Leszállási eltolás Z",
                },
                treeDropRadius = {
                    description = "Beállítja: Leszállási sugár.",
                    label = "Leengedési sugár",
                },
                treeEnabled = {
                    description = "Beállítja: Áthajtott fa események engedélyezése.",
                    label = "Áthajtott fa események engedélyezése",
                },
                treeInteractionDistance = {
                    description = "Beállítja: Interakciós távolság.",
                    label = "Interakciótávolság",
                },
                treeInteractionOffsetX = {
                    description = "Helyi oldalirányú eltolás a fa modell mellől.",
                    label = "Vágási pont eltolás X",
                },
                treeInteractionOffsetY = {
                    description = "Helyi hosszirányú eltolás a fa modell mellől.",
                    label = "Vágási pont eltolás Y",
                },
                treeInteractionOffsetZ = {
                    description = "Függőleges eltolás a fa modell mellől.",
                    label = "Vágási pont eltolás Z",
                },
                treeMarkerA = {
                    description = "Beállítja: Jelölő átlátszósága.",
                    label = "Jelölő átlátszósága",
                },
                treeMarkerB = {
                    description = "Beállítja: Jelölő kék.",
                    label = "Marker kék",
                },
                treeMarkerG = {
                    description = "Beállítja: Jelölő zöld.",
                    label = "Marker zöld",
                },
                treeMarkerHeight = {
                    description = "Beállítja: Jelölő magassága.",
                    label = "Marker magasság",
                },
                treeMarkerR = {
                    description = "Beállítja: Jelölő vörös.",
                    label = "Marker piros",
                },
                treeMarkerSize = {
                    description = "Beállítja: Jelölő mérete.",
                    label = "Marker méret",
                },
                treeMarkerType = {
                    description = "Beállítja: Jelölő típusa.",
                    label = "Jelzőtípus",
                },
                treePickupDistance = {
                    description = "Beállítja: Felvételi távolság.",
                    label = "Felvételi távolság",
                },
                treePieceCount = {
                    description = "Beállítja: Faanyagdarabok száma.",
                    label = "Faanyagdarabok száma",
                },
                treePieceModel = {
                    description = "Beállítja: Faanyagdarab modell.",
                    label = "Darab modell naplózása",
                },
                treePieceSpacing = {
                    description = "Beállítja: Faanyagdarabok távolsága.",
                    label = "Darabok távolsága naplózása",
                },
                treePropModel = {
                    description = "Az áthajtott fához generált objektummodell.",
                    label = "Áthajtott fa modell",
                },
                treeRequireOnDuty = {
                    description = "Beállítja: Szolgálatban kell lenni.",
                    label = "Szolgálat kötelező",
                },
                treeSawAnimDict = {
                    description = "Beállítja: Animációs könyvtár.",
                    label = "Animációs könyvtár",
                },
                treeSawAnimFlag = {
                    description = "Konfigurálja: Animációs jelzőt.",
                    label = "Animációs jelző",
                },
                treeSawAnimName = {
                    description = "Beállítja: Animáció neve.",
                    label = "Animáció neve",
                },
                treeSawCollision = {
                    description = "Beállítja: Prop ütközés engedélyezése.",
                    label = "Prop ütközés engedélyezése",
                },
                treeSawIsPed = {
                    description = "Beállítja: Pedhez rögzítés.",
                    label = "Pedhez rögzítés",
                },
                treeSawOffsetRx = {
                    description = "Beállítja: Láncfűrész forgatás X.",
                    label = "Láncfűrészes forgatás X",
                },
                treeSawOffsetRy = {
                    description = "Beállítja: Láncfűrész forgatás Y.",
                    label = "Láncfűrészes forgatás Y",
                },
                treeSawOffsetRz = {
                    description = "Beállítja: Láncfűrész forgatás Z.",
                    label = "Láncfűrészes forgatás Z",
                },
                treeSawOffsetX = {
                    description = "Beállítja: Láncfűrész eltolás X.",
                    label = "Láncfűrész eltolás X",
                },
                treeSawOffsetY = {
                    description = "Beállítja: Láncfűrész eltolás Y.",
                    label = "Láncfűrész eltolás Y",
                },
                treeSawOffsetZ = {
                    description = "Beállítja: Láncfűrész eltolás Z.",
                    label = "Láncfűrész eltolás Z",
                },
                treeSawProp = {
                    description = "Beállítás: Láncfűrész prop modell.",
                    label = "Láncfűrész prop modell",
                },
                treeSawPropBone = {
                    description = "Beállítás: Láncfűrész csont.",
                    label = "Láncfűrészes csont",
                },
                treeSawRotationOrder = {
                    description = "Beállítás: Forgatási sorrend.",
                    label = "Forgatási sorrend",
                },
                treeSawSections = {
                    description = "Beállítás: Szükséges fűrészelési szakaszok.",
                    label = "Szükséges fűrészrészletek",
                },
                treeSawSoftPinning = {
                    description = "Beállítás: Lágy rögzítés használata.",
                    label = "Laz rögzítés használata",
                },
                treeSawSyncRotation = {
                    description = "Beállítás: Forgatás szinkronizálása.",
                    label = "Forgatás szinkronizálása",
                },
                treeSpawnRange = {
                    description = "A hálózatos fá akkor jelenik meg, amikor egy játékos belép ebbe a tartományba.",
                    label = "Generálási tartomány",
                },
                vehicleFiresBurnDamageBreakWindows = {
                    description = "Beállítás: Üvegek törése teljes lángolás esetén.",
                    label = "Üvegek törése teljes lángolás esetén",
                },
                vehicleFiresBurnDamageBurstTyres = {
                    description = "Beállítás: Kerekek szúrása teljes lángolás esetén.",
                    label = "Kerekek szúrása teljes lángolás esetén",
                },
                vehicleFiresBurnDamageDeformation = {
                    description = "Beállítás: Optikai torzítás ereje.",
                    label = "Optikai torzítás ereje",
                },
                vehicleFiresBurnDamageEnabled = {
                    description = "Lépcsőzetesen károsítja és torzítja az égő járművet a késleltetett robbanás előtt.",
                    label = "Jármű károsítása égetés közben",
                },
                vehicleFiresBurnDamageFullBodyHealth = {
                    description = "Beállítás: Karosszéria egészségének állapota teljes lángolás esetén.",
                    label = "Karosszéria egészségének állapota teljes lángolás esetén",
                },
                vehicleFiresBurnDamageIntervalSeconds = {
                    description = "Másodpercek a további károsodási ciklusok között a teljes lángolás szakaszában.",
                    label = "Teljes lángolás károsodási intervalluma",
                },
                vehicleFiresBurnDamageMinimumBodyHealth = {
                    description = "Beállítás: Minimális karosszéria egészségének állapota robbanás előtt.",
                    label = "Minimális karosszéria egészségének állapota robbanás előtt",
                },
                vehicleFiresBurnDamagePerTick = {
                    description = "Beállítás: Karosszéria károsodása ciklusonként.",
                    label = "Karosszéria károsodása ciklusonként",
                },
                vehicleFiresBurnDamageSmallBodyHealth = {
                    description = "Beállítás: Karosszéria egészségének állapota kis lángolás esetén.",
                    label = "Karosszéria egészségének állapota kis lángolás esetén",
                },
                vehicleFiresCanExtinguishFoam = {
                    description = "Lehetővé teszi, hogy a csőből vagy járműellátásból származó hab oltsa el ezt a járműtűz-anyagot.",
                    label = "Habbal oltás",
                },
                vehicleFiresCanExtinguishWater = {
                    description = "Lehetővé teszi, hogy a csővíz, a jármű vízágyúi és a helikopter vödörvíze oltsa el ezt a járműtűz-anyagot.",
                    label = "Vízzel oltás",
                },
                vehicleFiresCanExtinguishWaterMonitor = {
                    description = "Lehetővé teszi, hogy a hordozható vízágyú oltsa el ezt a járműtűz-anyagot.",
                    label = "Vízágyúval oltás",
                },
                vehicleFiresDuplicateDistance = {
                    description = "Megakadályozza, hogy egy másik járműtűz keletkezzen túl közel egy meglévőhöz.",
                    label = "Duplikátum távolság",
                },
                vehicleFiresEnabled = {
                    description = "A járműtűz rendszerének engedélyezése.",
                    label = "Engedélyezve",
                },
                vehicleFiresEngineHealth = {
                    description = "300 vagy magasabb értéknél tartandó, hogy megakadályozza a GTA natív járműtűzét és a korai robbanást.",
                    label = "Motor állapota égetés közben",
                },
                vehicleFiresEngineOff = {
                    description = "Beállítás: Motor kikapcsolása.",
                    label = "Motor kikapcsolása",
                },
                vehicleFiresExplosionCameraShake = {
                    description = "Beállítás: Kamerarázás.",
                    label = "Kamerarázás",
                },
                vehicleFiresExplosionDamageScale = {
                    description = "Beállítás: Robbanás károsodási skálája.",
                    label = "Robbanás károsodási skálája",
                },
                vehicleFiresExplosionDelaySeconds = {
                    description = "Másodpercek, amíg egy égő jármű robban.",
                    label = "Robbanás késleltetése másodpercben",
                },
                vehicleFiresExplosionEnabled = {
                    description = "A járművek nem robbannak azonnal; ez vezérli az opcionális késleltetett robbanást.",
                    label = "Késleltetett robbanás engedélyezése",
                },
                vehicleFiresExplosionPostBurnSeconds = {
                    description = "Másodpercek, amíg a megsemmisült jármű a robbanás után tovább ég.",
                    label = "Égési időtartam robbanás után",
                },
                vehicleFiresExplosionRemoveFire = {
                    description = "Távolítja el a tüzet a beállított utóégési időtartam után. Letiltás korlátlan romhalmaz-tűz esetén.",
                    label = "Tűz eltávolítása utóégetés után",
                },
                vehicleFiresExplosionType = {
                    description = "Beállítás: Robbanás típusa.",
                    label = "Robbanás típusa",
                },
                vehicleFiresExternalAllowedResources = {
                    description = "Források, amelyek a külső hookon keresztül járműtűzöket hozhatnak létre.",
                    itemLabel = "Erőforrás",
                    label = "Engedélyezett források",
                },
                vehicleFiresExternalEnabled = {
                    description = "Mechanicjob vagy engedélyezett szkripteknek engedélyezi a Firejob járműtűzök létrehozását.",
                    label = "Külső létrehozás engedélyezése",
                },
                vehicleFiresExternalMaxSourceDistance = {
                    description = "A külső trigger koordináták és a jármű közötti maximális távolság.",
                    label = "Maximális forrás-távolság",
                },
                vehicleFiresFireType = {
                    description = "A járműtűz létrehozásakor használt tűzforrás típusa.",
                    label = "Tűz típusa",
                },
                vehicleFiresFoamEffectiveness = {
                    description = "Magasabb értékek gyorsabban oltják ki a habbal a járműtűzöket.",
                    label = "Hab hatékonysága",
                },
                vehicleFiresKeepUndriveable = {
                    description = "Beállítás: A jármű vezethetetlen állapotának fenntartása.",
                    label = "A jármű vezethetetlen állapotának fenntartása",
                },
                vehicleFiresManualConsumeItem = {
                    description = "Beállítás: A gyújtóeszköz elhasználódása.",
                    label = "Gyújtó tárgy elfogyasztása",
                },
                vehicleFiresManualEnabled = {
                    description = "Lehetővé teszi a játékosoknak a közelben lévő járművek manuális meggyújtását.",
                    label = "Kézi gyújtás",
                },
                vehicleFiresManualItem = {
                    description = "A manuális járműgyújtáshoz szükséges inventár-tárgy.",
                    label = "Gyújtóeszköz",
                },
                vehicleFiresManualMaxDistance = {
                    description = "Beállítás: A maximális gyújtótávolság.",
                    label = "Maximális gyújtótávolság",
                },
                vehicleFiresManualSourceScale = {
                    description = "Beállítás: A manuális gyújtás tűz méretaránya.",
                    label = "Manuális gyújtás tűz méretaránya",
                },
                vehicleFiresMaterial = {
                    description = "A jármű üzemanyag-viselkedéséhez használt anyagprofil.",
                    label = "Tűz anyaga",
                },
                vehicleFiresMaxActive = {
                    description = "Beállítás: A maximális aktív járműtűzök száma.",
                    label = "Maximális aktív járműtűzök száma",
                },
                vehicleFiresPetrolTankHealth = {
                    description = "A 1000 értéket tartja meg, így csak a konfigurált Firejob robbanás pusztíthatja el a járművet.",
                    label = "Tartály állapota égés közben",
                },
                vehicleFiresProgressionEnabled = {
                    description = "A járműtűzök füsttel kezdődnek, kis tűzzé nőnek, majd teljes intenzitást érnek el.",
                    label = "Lépcsőzetes járműtűz engedélyezése",
                },
                vehicleFiresProgressionExplosionAfterFullFire = {
                    description = "A füst és a kis tűz időtartamát adja hozzá a konfigurált robbanás-késleltetés megkezdése előtt.",
                    label = "Tűz robbanás-timer a teljes égés után",
                },
                vehicleFiresProgressionFullIntensity = {
                    description = "Konfigurálja: A teljes tűz intenzitását.",
                    label = "Teljes tűz intenzitása",
                },
                vehicleFiresProgressionFullSize = {
                    description = "Konfigurálja: A teljes tűz méretét.",
                    label = "Teljes tűz mérete",
                },
                vehicleFiresProgressionFullSmokeDensity = {
                    description = "Konfigurálja: A teljes tűz füst sűrűségét.",
                    label = "Teljes tűz füst sűrűsége",
                },
                vehicleFiresProgressionSmallDurationSeconds = {
                    description = "Konfigurálja: A kis tűz időtartamát másodpercben.",
                    label = "Kis tűz időtartama másodpercben",
                },
                vehicleFiresProgressionSmallIntensity = {
                    description = "Konfigurálja: A kis tűz intenzitását.",
                    label = "Kis tűz intenzitása",
                },
                vehicleFiresProgressionSmallSize = {
                    description = "Konfigurálja: A kis tűz méretét.",
                    label = "Kis tűz mérete",
                },
                vehicleFiresProgressionSmallSmokeDensity = {
                    description = "Konfigurálja: A kis tűz füst sűrűségét.",
                    label = "Kis tűz füst sűrűsége",
                },
                vehicleFiresProgressionSmallSourceScale = {
                    description = "Konfigurálja: A kis tűz méretarányát.",
                    label = "Kis tűz méretaránya",
                },
                vehicleFiresProgressionSmokeDensity = {
                    description = "Konfigurálja: A füstfázis sűrűségét.",
                    label = "Füstfázis sűrűsége",
                },
                vehicleFiresProgressionSmokeDurationSeconds = {
                    description = "Konfigurálja: A füst időtartamát másodpercben.",
                    label = "Füst időtartama másodpercben",
                },
                vehicleFiresProgressionSmokeIntensity = {
                    description = "Konfigurálja: A füstfázis intenzitását.",
                    label = "Füstfázis intenzitása",
                },
                vehicleFiresProgressionSmokeSize = {
                    description = "Konfigurálja: A füstfázis méretét.",
                    label = "Füstfázis mérete",
                },
                vehicleFiresProgressionSmokeSourceScale = {
                    description = "Tartsa nagyon alacsonyan, ha elsősorban füstöt és alig látható lángokat szeretne.",
                    label = "Füstfázis lángméretaránya",
                },
                vehicleFiresServerCooldownSeconds = {
                    description = "Globális várakozási idő a kézi gyújtószerszám használatához.",
                    label = "Szerverközpontú gyújtási várakozási idő",
                },
                vehicleFiresSourceScale = {
                    description = "Konfigurálja: Az alapértelmezett tűz méretarányát.",
                    label = "Alapértelmezett tűz méretaránya",
                },
                vehicleFiresStandaloneAllowNpcVehicles = {
                    description = "Konfigurálja: NPC járművek engedélyezése.",
                    label = "NPC járművek engedélyezése",
                },
                vehicleFiresStandaloneChance = {
                    description = "Konfigurálja: Az ütközéses tűz esélyét.",
                    label = "Ütközéses tűz esélye",
                },
                vehicleFiresStandaloneCooldownSeconds = {
                    description = "Konfigurálja: Az ütközéses várakozási időt másodpercben.",
                    label = "Ütközéses várakozási idő másodpercben",
                },
                vehicleFiresStandaloneEnabled = {
                    description = "Engedélyezi, hogy a Firejob súlyos balesetekből származó járműtűzöket hozzon létre Mechanicjob nélkül.",
                    label = "Engedélyezi az önálló baleseteket",
                },
                vehicleFiresStandaloneForwardMotionRatio = {
                    description = "Konfigurálja: Az előrehaladási arányt.",
                    label = "Előrehaladási arány",
                },
                vehicleFiresStandaloneIgnoreElectric = {
                    description = "Konfigurálja: Az elektromos járművek figyelmen kívül hagyása.",
                    label = "Elektromos járművek figyelmen kívül hagyása",
                },
                vehicleFiresStandaloneMechanicResources = {
                    description = "Olyan erőforrások, amelyek kikapcsolják a visszatérő ütközésfelismerést, amikor futnak.",
                    itemLabel = "Erőforrás",
                    label = "Mechanic erőforrások",
                },
                vehicleFiresStandaloneMinBodyHealthLoss = {
                    description = "Konfigurálja: A minimális karosszériakárosodást.",
                    label = "Minimális testkárosodás",
                },
                vehicleFiresStandaloneMinEngineHealthLoss = {
                    description = "Konfigurálja: A minimális motorkárosodást.",
                    label = "Minimális motorkárosodás",
                },
                vehicleFiresStandaloneMinImpactSpeedKmh = {
                    description = "Beállítja: A minimális ütközési sebességet.",
                    label = "Minimális ütközési sebesség",
                },
                vehicleFiresStandaloneMinSpeedDropKmh = {
                    description = "Beállítja: A minimális sebességvesztést.",
                    label = "Minimális sebességvesztés",
                },
                vehicleFiresStandaloneMode = {
                    description = "A fallback csak akkor fut, ha a konfigurált mechanic erőforrások nem aktívak. Mindig fut a Mechanicjob mellett. A letiltás csak a kézi, külső vagy mechanikus aktiválókat tartja meg.",
                    label = "Önálló mód",
                    options = {
                        always = "Mindig",
                        disabled = "Letiltva",
                        fallback = "Visszavonulás",
                    },
                },
                vehicleFiresStandaloneRequireDriver = {
                    description = "Beállítja: A játékos sofőr követelménye.",
                    label = "Játékos sofőr követelménye",
                },
                vehicleFiresStandaloneServerMaxDistance = {
                    description = "A maximálisan megengedett játékos távolság az ütközési koordinátákhoz.",
                    label = "Szerveri maximális távolság",
                },
                vehicleFiresStandaloneSmokeDensity = {
                    description = "Beállítja: Az ütközéses füst sűrűségét.",
                    label = "Ütközéses füst sűrűsége",
                },
                vehicleFiresStandaloneSourceScale = {
                    description = "Beállítja: Az ütközéses tűz méretét.",
                    label = "Ütközéses tűz mérete",
                },
                vehicleFiresWaterEffectiveness = {
                    description = "Használja a 0-t, hogy a víz ne oltsa ki a jármű üzemanyag-tűzeit.",
                    label = "Víz hatékonysága",
                },
                vehicleFiresWaterReactionChance = {
                    description = "Beállítja: A reakció esélyét.",
                    label = "Reakció esélye",
                },
                vehicleFiresWaterReactionEnabled = {
                    description = "Engedélyezi, hogy a víz a jármű üzemanyag-tűzeit terjedéshez, füstöléshez vagy robbanáshoz vezesse a lentebb felsorolt értékek alapján.",
                    label = "A víz rontja a helyzetet",
                },
                vehicleFiresWaterReactionExplosionChance = {
                    description = "Beállítja: A robbanási reakció esélyét.",
                    label = "Explosziós reakció esélye",
                },
                vehicleFiresWaterReactionInterval = {
                    description = "Konfigurálja: Reakciós intervallum ms.",
                    label = "Reakciós intervallum ms",
                },
                vehicleFiresWaterReactionSmokeIncrease = {
                    description = "Konfigurálja: Füstnövekedés.",
                    label = "Füstnövekedés",
                },
                vehicleFiresWaterReactionSpreadCount = {
                    description = "Konfigurálja: Szóródási szám.",
                    label = "Szóródási szám",
                },
                vehicleRescueAllowMissionCreatorVehicles = {
                    description = "Engedélyezi, hogy a Tűz Misszióalkotó által elhelyezett járművek mentési célponttá váljanak.",
                    label = "Misszióalkotó járművei",
                },
                vehicleRescueAllowStateBag = {
                    description = "Külső szkriptek megjelölhetik a járműveket az Entity(vehicle).state[configuredKey] = true beállítással.",
                    label = "State-bag jelző engedélyezése",
                },
                vehicleRescueAllowWorldVehicles = {
                    description = "Engedélyezi, hogy a világban lévő normál sérült járművek mentési célponttá váljanak.",
                    label = "Világi járművek",
                },
                vehicleRescueBreakDoorOnComplete = {
                    description = "Konfigurálja: GTA ajtó törése sikeresen.",
                    label = "GTA ajtó törése sikeresen",
                },
                vehicleRescueBreakWindowOnComplete = {
                    description = "Konfigurálja: GTA ablak törése sikeresen.",
                    label = "GTA ablak törése sikeresen",
                },
                vehicleRescueDoorLabel = {
                    description = "Interakciós felirat, amely megjelenik egy jármű ajtajának kinyitására.",
                    label = "Ajtó interakciós felirat",
                },
                vehicleRescueDoorWheelLabel = {
                    description = "Használd a %s helykitöltőt az érzékelt ajtó oldal feliratához.",
                    label = "Ajtó kerekes felirat",
                },
                vehicleRescueEnabled = {
                    description = "Engedélyezi a technikai mentési interakciókat járműveken.",
                    label = "Engedélyezve",
                },
                vehicleRescueGlassDurationMs = {
                    description = "Konfigurálja: Időtartam (ms).",
                    label = "Időtartam ms",
                },
                vehicleRescueGlassGoodZone = {
                    description = "Konfigurálja: Jó zóna.",
                    label = "Jó zóna",
                },
                vehicleRescueGlassHammerItem = {
                    description = "A járműablakok betöréséhez szükséges készlettárgy.",
                    label = "Ablaktörő kalapács",
                },
                vehicleRescueGlassHammerProp = {
                    description = "Konfigurálja: Ablaktörő kalapács modell.",
                    label = "Ablaktörő kalapács modell",
                },
                vehicleRescueGlassHitPoints = {
                    description = "Konfigurálja: Gyenge pontok.",
                    label = "Gyenge pontok",
                },
                vehicleRescueGlassLabel = {
                    description = "Interakciós felirat a járműablak betöréséhez.",
                    label = "Ablak betörésének interakciós felirata",
                },
                vehicleRescueGlassMaxMisses = {
                    description = "Konfigurálja: Megengedett hibák.",
                    label = "Megengedett hibák",
                },
                vehicleRescueGlassMinigameEnabled = {
                    description = "Konfigurálja: Ablak minijáték engedélyezése.",
                    label = "Ablak minijáték engedélyezése",
                },
                vehicleRescueGlassMistakePenalty = {
                    description = "Konfigurálja: Hiba büntetőütések.",
                    label = "Hiba büntetőütések",
                },
                vehicleRescueGlassPerfectZone = {
                    description = "Konfigurálja: Tökéletes zóna.",
                    label = "Tökéletes zóna",
                },
                vehicleRescueGlassRequiredHits = {
                    description = "Konfigurálja: Szükséges találatok.",
                    label = "Szükséges találatok",
                },
                vehicleRescueGlassWheelLabel = {
                    description = "Használd a %s helykitöltőt az érzékelt ajtó oldal feliratához.",
                    label = "Ablak betörésének kerekes felirata",
                },
                vehicleRescueInteractionDistance = {
                    description = "Beállítja: Interakciós távolság.",
                    label = "Interakciótávolság",
                },
                vehicleRescueMaxScanDistance = {
                    description = "Konfigurálja: Jármű szkennelési távolság.",
                    label = "Jármű szkennelési távolság",
                },
                vehicleRescuePatientAccessibleAfterAnyDoor = {
                    description = "Beállítja a jármű mentési állapotát elérhetővé, amint bármelyik ajtó eltávolításra kerül.",
                    label = "Páciens elérhetővé válik egy ajtó eltávolítása után",
                },
                vehicleRescuePlayerEntrapmentEnabled = {
                    description = "Játékosok bezárása súlyosan sérült járművekben, amíg a mentési hozzáférés létre nem jön.",
                    label = "Játékos elakadása",
                },
                vehicleRescueRequireMatchingGlassForDoor = {
                    description = "Az ajtónyitás interakciós pontja csak akkor jelenik meg, ha a megfelelő oldali ablak eltávolításra került.",
                    label = "Az ajtóhoz illeszkedő üveg szükséges",
                },
                vehicleRescueRequireOnDuty = {
                    description = "Csak szolgálatban lévő tűzoltók törhetik be az üveget és nyithatják fel az ajtókat.",
                    label = "Szolgálat kötelező",
                },
                vehicleRescueSpreaderDecayPerTick = {
                    description = "Konfigurálja: Romlás per tick.",
                    label = "Romlás per tick",
                },
                vehicleRescueSpreaderDurationMs = {
                    description = "Konfigurálja: Időtartam (ms).",
                    label = "Időtartam ms",
                },
                vehicleRescueSpreaderItem = {
                    description = "A járműajtók széttolásához szükséges készlettárgy.",
                    label = "Széttoló tárgy",
                },
                vehicleRescueSpreaderMaxPumpPower = {
                    description = "Konfigurálja: Jó pumpa maximális teljesítménye.",
                    label = "Jó pumpa maximális teljesítménye",
                },
                vehicleRescueSpreaderMinPumpPower = {
                    description = "Konfigurálja: Jó pumpa minimális teljesítménye.",
                    label = "Jó pumpa minimális teljesítménye",
                },
                vehicleRescueSpreaderMinigameEnabled = {
                    description = "Konfigurálja: Széttoló minijáték engedélyezése.",
                    label = "Széttoló minijáték engedélyezése",
                },
                vehicleRescueSpreaderOverPressurePenalty = {
                    description = "Konfigurálja: Túlnyomás büntetés.",
                    label = "Túlnyomás büntetés",
                },
                vehicleRescueSpreaderPressureGain = {
                    description = "Konfigurálja: Nyomásnyereség.",
                    label = "Nyomásnyereség",
                },
                vehicleRescueSpreaderPressureLoss = {
                    description = "Konfigurálja: Nyomásveszteség.",
                    label = "Nyomásveszteség",
                },
                vehicleRescueSpreaderProgressPerTick = {
                    description = "Konfigurálja: Haladás per tick.",
                    label = "Haladás per tick",
                },
                vehicleRescueSpreaderProp = {
                    description = "Konfigurálja: Széttoló modell.",
                    label = "Kinyító tárgy",
                },
                vehicleRescueSpreaderPumpsRequired = {
                    description = "Az ajtó körülbelül 3 és 5 jó kinyitó pumpa után távolítódik el.",
                    label = "Kötelező pumpaciklusok",
                },
                vehicleRescueSpreaderRequiredProgress = {
                    description = "Beállítás: Kötelező haladás.",
                    label = "Kötelező haladás",
                },
                vehicleRescueSpreaderSweetSpotMax = {
                    description = "Beállítás: Nyomás érzékeny zóna maximum.",
                    label = "Nyomás érzékeny zóna maximum",
                },
                vehicleRescueSpreaderSweetSpotMin = {
                    description = "Beállítás: Nyomás érzékeny zóna minimum.",
                    label = "Nyomás érzékeny zóna minimum",
                },
                vehicleRescueStateBagKey = {
                    description = "Beállítás: Állapot-táskakulcs.",
                    label = "Állapot-táskakulcs",
                },
                vehicleRescueWorldBodyHealthThreshold = {
                    description = "Beállítás: Karosszéria egészség küszöbértéke.",
                    label = "Karosszéria egészség küszöbértéke",
                },
                vehicleRescueWorldEngineHealthThreshold = {
                    description = "Beállítás: Motor egészség küszöbértéke.",
                    label = "Motor egészség küszöbértéke",
                },
                vehicleRescueWorldRequiresDamage = {
                    description = "Ha engedélyezve van, a normál világjárműveknek a beállított küszöbértékek alatt kell sérültek lenniük.",
                    label = "A világjárműveknek sérülésre van szükségük",
                },
                waterMonitorAllowedJobs = {
                    description = "Hagyj üresen, hogy engedélyezd az összes ebben a Firejobban konfigurált munkát.",
                    itemLabel = "Foglalkozás",
                    label = "Engedélyezett foglalkozások",
                },
                waterMonitorCommand = {
                    description = "Parancsnév schrägstrich nélkül, például watermonitor.",
                    label = "Parancs",
                },
                waterMonitorCommandEnabled = {
                    description = "Lehetővé teszi a víztornyó elhelyezését tárgy nélkül a parancs segítségével.",
                    label = "Parancs használata engedélyezése",
                },
                waterMonitorConsumeItem = {
                    description = "Egy konfigurált tárgy eltávolítása a sikeres elhelyezés után.",
                    label = "Tárgy elfogyasztása elhelyezésnél",
                },
                waterMonitorEnabled = {
                    description = "Engedélyezi a hordozható víztornyó elhelyezését és üzemeltetését.",
                    label = "Víztornyó engedélyezése",
                },
                waterMonitorEnterAnimDict = {
                    description = "Animációs könyvtár betöltése, amikor egy játékos elindítja a víztornyó üzemeltetését.",
                    label = "Könyvtár",
                },
                waterMonitorEnterAnimDurationMs = {
                    description = "Az animáció időtartama milliszekundumban; -1 használatával nincs időkorlát.",
                    label = "Időtartam ms",
                },
                waterMonitorEnterAnimName = {
                    description = "Az üzemelési pozícióba lépéskor lejátszott animációs klip.",
                    label = "Animáció neve",
                },
                waterMonitorExitAnimDict = {
                    description = "Animációs szótár betöltése, amikor a játékos abbahagyja a víztornyó működtetését.",
                    label = "Könyvtár",
                },
                waterMonitorExitAnimDurationMs = {
                    description = "A kilépési animáció időtartama milliszekundumban; -1 használata esetén nincs időkorlát.",
                    label = "Időtartam ms",
                },
                waterMonitorExitAnimName = {
                    description = "Az animációs vágány, amely a víztornyó elhagyásakor lejátszódik.",
                    label = "Animáció neve",
                },
                waterMonitorIdleAnimDict = {
                    description = "Az animációs szótár, amely a víztornyó működtetése közben használatos.",
                    label = "Könyvtár",
                },
                waterMonitorIdleAnimDurationMs = {
                    description = "A működési animáció időtartama milliszekundumban; -1 használata esetén folyamatosan aktív marad.",
                    label = "Időtartam ms",
                },
                waterMonitorIdleAnimName = {
                    description = "A víztornyó működtetése közben használt ismétlődő animációs vágány.",
                    label = "Animáció neve",
                },
                waterMonitorInteractionDistance = {
                    description = "A víztornyó maximális távolsága, amelyről működtethető.",
                    label = "Interakciótávolság",
                },
                waterMonitorItem = {
                    description = "Az inventárból használt tárgy a víztornyó elhelyezéséhez.",
                    label = "Tárgy neve",
                },
                waterMonitorItemEnabled = {
                    description = "Lehetővé teszi a víztornyó elhelyezését a beállított inventáriumi tárgy használatával.",
                    label = "Elem használata engedélyezése",
                },
                waterMonitorLabel = {
                    description = "Név, amely interakciókban és értesítésekben jelenik meg.",
                    label = "Megjelenítendő címke",
                },
                waterMonitorModel = {
                    description = "A víztornyóhoz létrehozott prop modell.",
                    label = "Objektum modell",
                },
                waterMonitorPickupDistance = {
                    description = "A felhelyezett víztornyó maximális távolsága, amelyről felvehető.",
                    label = "Felvételi távolság",
                },
                waterMonitorRequireOnDuty = {
                    description = "Csak a megengedett foglalkozás tagjait engedi használni a víztornyót, ha szolgálatban vannak.",
                    label = "Szolgálat kötelező",
                },
                waterMonitorReturnItemOnRemove = {
                    description = "Egy beállított tárgyat ad vissza, amikor a víztornyó felvehető.",
                    label = "Elem visszaadása felvételekor",
                },
                waterMonitorStreamDistance = {
                    description = "A felhelyezett víztornyók szinkronizálásának és megjelenítésének maximális távolsága.",
                    label = "Streaming távolság",
                },
                waterMonitorStreamHitRadius = {
                    description = "A vízsugár körüli sugár, amelyben egy tüzet lehet érinteni.",
                    label = "Érintési sugár",
                },
                waterMonitorStreamMinRange = {
                    description = "A víztornyó célzásakor használt minimális sugártávolság.",
                    label = "Minimális hatótávolság",
                },
                waterMonitorStreamProgressPerSecond = {
                    description = "Alapértelmezés szerinti oltóerő a sugárral érintett tüzekre.",
                    label = "Másodpercenkénti oltási haladás",
                },
                waterMonitorStreamRange = {
                    description = "A vízsugár maximális távolsága méterben.",
                    label = "Hatótáv",
                },
                waterMonitorStreamTrajectorySegments = {
                    description = "A görbült vízsugár útvonalának számításához használt szegmensek száma.",
                    label = "Útvonal-szegmensek",
                },
                waterMonitorStreamWaterGravityScale = {
                    description = "Vezérli, hogy a gravitáció milyen erősen görbíti a vízsugarat lefelé.",
                    label = "Gravitációs skála",
                },
                waterMonitorStreamWaterLitersPerSecond = {
                    description = "A csatlakoztatott ellátásból felhasznált víz mennyisége a permetezés közben.",
                    label = "Víz liter másodpercenként",
                },
                waterMonitorStreamWaterVelocity = {
                    description = "A vízsugár útvonalának számításához használt kezdeti sebesség.",
                    label = "Víz sebessége",
                },
                waterMonitorZOffset = {
                    description = "Vertikális korrekció a prop földön elhelyezésekor.",
                    label = "Föld Z eltolás",
                },
                waterTankEnabled = {
                    description = "Beállítás: Víztartály.",
                    label = "Víz tartály",
                },
                waterTankSize = {
                    description = "Beállítás: Víz liter.",
                    label = "Víz mennyiség literben",
                },
                x = {
                    description = "Beállítás: X.",
                    label = "X",
                },
                y = {
                    description = "Beállítás: Y.",
                    label = "Y",
                },
                z = {
                    description = "Beállítás: Z.",
                    label = "Z",
                },
                zOffset = {
                    description = "Vertikális eltolás, hogy a létrehozott tűz megfelelően helyezkedjen el a kiválasztott gyújtóforrásnál.",
                    label = "Tűz magasságának eltolása",
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
        },
    },
}
