JobConfigLocales["sky_policejob:hu"] = {
    JobConfiguratorComingSoon = "Ez a munkakör-konfigurátor hamarosan elérhető lesz.",
    JobConfiguratorImportFailed = "A '%s' nevű beállítások config.lua értékeinek importálása sikertelen: %s.",
    JobConfiguratorImportHistoryFailed = "Az import sikeres volt, de a történeti bejegyzés nem menthető.",
    JobConfiguratorImportNoData = "A '%s' névre nincs regisztrálva config.lua importadatok.",
    JobConfiguratorImportSuccess = "A '%s' beállítások config.lua értékei importálva: %d állás, %d beállítás, %d funkció és %d interakció eltérés alkalmazva.",
    JobConfiguratorNoPermission = "Nincs jogosultságod erre a parancsra.",
    JobConfiguratorTitle = "Munkahely-konfigurator",
    JobConfiguratorUnknown = "Ismeretlen állás-konfigurator.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Konfigurálja a rendőrségi osztályokat, üzleteket, tárgyakat, járműveket, állomásokat és a központi funkciók beállításait.",
                    title = "Rendőrségi munkakörök",
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
                radioButton = "Gomb",
                radioButtonAction = "Gomb akció",
                radioButtonStatus = "FMS állapot",
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
                dispatchRadioButtons = "Meghatározza a központi előírt akciókat minden fizikai funkciógombhoz.",
                dispatchRadioFmsKeys = "FMS állapotot rendel a fizikai számjegyekhez. A billentyűzet csak FMS-váltásokat végez.",
            },
            extensions = {
                caseNumbering = {
                    label = "Ügyszámok",
                    description = "Konfigurálja az automatikus ügyszámokat ehhez a munkakörhöz.",
                    fields = {
                        prefix = {
                            label = "Ügyszám előtag",
                            description = "Előtag új ügyekhez, például LSPD vagy LSCSD. Legfeljebb 16 karakter, nagybetűvé alakítva; ha üres, akkor CASE-t használ. A meglévő és manuálisan hozzárendelt számok változatlanok maradnak.",
                        },
                    },
                },
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
                dispatchRadioButtons = "Rádió funkciógombok",
                dispatchRadioFmsKeys = "FMS billentyű-beosztás",
            },
            features = {
                billing = {
                    description = "Rendőrségi számlázási folyamatok engedélyezése.",
                    label = "Számlázás",
                },
                devices = {
                    description = "Beépíthető végrehajtási eszközök engedélyezése.",
                    label = "CCTV és sebességkamerák",
                },
                evidence = {
                    description = "Bizonyítéktárolás, helyszíni bizonyítékok és szkennelő folyamatok engedélyezése.",
                    label = "Bizonyítékok",
                },
                impound = {
                    description = "Rendőri elkobzási teleki folyamatok engedélyezése.",
                    label = "Rendőri elkobzási telek",
                },
                jail = {
                    description = "Börtönbeosztás és fogvatartottak tevékenységeinek engedélyezése.",
                    label = "Börtön",
                },
                propPlacement = {
                    description = "Konfigurálható rendőrségi tárgyak és jármű-tárgyi felszerelések engedélyezése.",
                    label = "Prop elhelyezése",
                },
                radial = {
                    description = "Rendőri körmenü funkciók engedélyezése, például jármű elkobzása és kerékbilincs használata.",
                    label = "Kerékmenü műveletek",
                },
                restraints = {
                    description = "Bilincsek, plasztik bilincs, lábfogók és fejzsákok engedélyezése.",
                    label = "Korlátozók",
                },
                socialWork = {
                    description = "Szociális munkák és feladatok kiosztásának engedélyezése.",
                    label = "Szociális munka",
                },
                tablet = {
                    description = "Ez az erőforrás által konfigurált rendőri tablet alkalmazások engedélyezése.",
                    label = "Rendőri Tablet",
                },
                tracking = {
                    description = "GPS-nyomkövetők és bokafigyelők engedélyezése.",
                    label = "Követés",
                },
                vehicleRadar = {
                    description = "Közlekedési rendőrségi járművek radarjának engedélyezése.",
                    label = "Jármű-radar",
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
                gangMinimumGrade = "Minimális rang",
                gang = "Banda",
                component = "Komponens",
                description = "Leírás",
                fineAmount = "Bírság összege",
                itemName = "Tárgy neve",
                length = "Hossz",
                max = "Max.",
                maxOverKmh = "Max. túllépés",
                min = "Min.",
                minOverKmh = "Min. túllépés",
                model = "Prop modell",
                propModel = "Prop modell",
                reason = "Indok",
                vehicleClass = "Osztály",
            },
            settingGroups = {
                access = {
                    label = "Hozzáférés",
                },
                animation = {
                    label = "Animáció",
                },
                ankleMonitor = {
                    label = "Bokafigyelő",
                },
                ankleMonitorAccess = {
                    label = "Bokafigyelő hozzáférés",
                },
                ankleMonitorPlacement = {
                    label = "Bokafigyelő felhelyezése",
                },
                ankleMonitorZone = {
                    label = "Bokafigyelő zóna",
                },
                ankleMonitorZoneVisual = {
                    label = "Bokafigyelő zóna vizuális megjelenítése",
                },
                assignment = {
                    label = "Rendezés",
                },
                blip = {
                    label = "Stáció jelző",
                },
                carry = {
                    label = "Hordozás",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV állóképesség",
                },
                cctvMotionDetection = {
                    label = "Mozgásérzékelés",
                },
                cctvMotionDispatch = {
                    label = "Mozgásérzékelő riasztás",
                },
                cctvMotionTiming = {
                    label = "Mozgásérzékelés időzítés",
                },
                cctvPlacement = {
                    label = "CCTV elhelyezése",
                },
                cctvRepair = {
                    label = "CCTV javítás",
                },
                cctvRepairAnimation = {
                    label = "CCTV javítás animáció",
                },
                clamp = {
                    label = "Radkoral",
                },
                clampWeld = {
                    label = "Radkoral hegesztése",
                },
                cleanup = {
                    label = "Takarítás",
                },
                collection = {
                    label = "Gyűjtés",
                },
                controls = {
                    label = "Vezérlés",
                },
                creator = {
                    label = "Készítő",
                },
                crimeSceneTape = {
                    label = "Bűnügyi szalag",
                },
                crimeSceneTapeAccess = {
                    label = "Szalag hozzáférés",
                },
                crimeSceneTapeInventory = {
                    label = "Szalag készlet",
                },
                crimeSceneTapeLength = {
                    label = "Szalag hossza",
                },
                crimeSceneTapePlacement = {
                    label = "Szalag elhelyezése",
                },
                database = {
                    label = "Adatbázis",
                },
                delivery = {
                    label = "Kézbesítés",
                },
                detection = {
                    label = "Érzékelés",
                },
                dispatch = {
                    label = "Ügyelet",
                },
                display = {
                    label = "Kijelző",
                },
                escape = {
                    label = "Elmenekülés",
                },
                escort = {
                    label = "Eskortálás",
                },
                evidenceStorage = {
                    label = "Bűnügyi raktár",
                },
                fastLock = {
                    label = "Autó gyorszár",
                },
                general = {
                    label = "Általános",
                },
                gpsTracker = {
                    label = "GPS nyomonkövető",
                },
                gpsTrackerAccess = {
                    label = "GPS-nyomkövető hozzáférés",
                },
                gpsTrackerPlacement = {
                    label = "GPS-nyomkövető elhelyezése",
                },
                gpsTrackerTiming = {
                    label = "GPS-nyomkövető időzítés",
                },
                gsr = {
                    label = "GSR",
                },
                handcuffs = {
                    label = "Bilincsek",
                },
                handsUp = {
                    label = "Kézek fel!",
                },
                header = {
                    label = "Fejléc",
                },
                impound = {
                    label = "Rendőri elkobzási telek",
                },
                imprisonment = {
                    label = "Börtönbe zárás",
                },
                jailCanteenGeneral = {
                    label = "Börtön kantina",
                },
                jailCanteenPackage = {
                    label = "Kantinas csomag",
                },
                jailCarry = {
                    label = "Visszavitt hordágy",
                },
                jailCarryInspection = {
                    label = "Visszavitt ellenőrzés",
                },
                jailCleaning = {
                    label = "Takarítási feladat",
                },
                jailCleaningIllegalFinds = {
                    label = "Illegális találmányok",
                },
                jailCleaningOutline = {
                    label = "Takarítási keret",
                },
                jailDoctor = {
                    label = "Börtöndoktor",
                },
                jailElectricalCodes = {
                    label = "Börtön elektromos kódok",
                },
                jailElectricalGeneral = {
                    label = "Börtön elektromos",
                },
                jailElectricalPenalties = {
                    label = "Elektromos büntetések",
                },
                jailElectricalRewards = {
                    label = "Börtön elektromos jutalmak",
                },
                jailInmatesAlcoholic = {
                    label = "Alkoholos fogoly",
                },
                jailInmatesCodeList = {
                    label = "Informátoros fogoly",
                },
                jailInmatesDrugDealer = {
                    label = "Drogkereskedő fogoly",
                },
                jailInmatesWireCutter = {
                    label = "Eszközszállító fogoly",
                },
                jailJobs = {
                    label = "Börtön munkák",
                },
                jailOutfitFemale = {
                    label = "Női ruha",
                },
                jailOutfitMale = {
                    label = "Férfi ruha",
                },
                keybinds = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Billentyűzések",
                },
                keybindsHandcuff = {
                    label = "Bilincs gomb",
                },
                keybindsUnhandcuff = {
                    label = "Bilincs feloldása gomb",
                },
                marker = {
                    label = "Jelölő",
                },
                markerColor = {
                    label = "Jelző szín",
                },
                mugshotAnimation = {
                    label = "Fotózás animáció",
                },
                mugshotBoard = {
                    label = "Fotózás tábla",
                },
                mugshotCameraCoords = {
                    label = "Fotózás kamera pozíció",
                },
                mugshotCameraRotation = {
                    label = "Fotózás kamera forgatás",
                },
                mugshotGeneral = {
                    label = "Fotózás",
                },
                mugshotMetadata = {
                    label = "Fotózás metaadatok",
                },
                mugshotPosition = {
                    label = "Fotózás pozíció",
                },
                mugshotTiming = {
                    label = "Fotózás időzítés",
                },
                officerDown = {
                    label = "Rendőrtiszt sérülése",
                },
                outfit = {
                    label = "Kijelölt egység",
                },
                overlay = {
                    label = "Rendszám átfedés",
                },
                payment = {
                    label = "Fizetés",
                },
                paymentFlow = {
                    label = "Fizetési folyamat",
                },
                penalties = {
                    label = "Büntetések",
                },
                playerSearch = {
                    label = "Játékos átkutatása",
                },
                playerSearchAnimation = {
                    label = "Játékos átkutatás animációja",
                },
                props = {
                    label = "Prop tárgyak",
                },
                reasons = {
                    label = "Indoklás",
                },
                release = {
                    label = "Kiadás",
                },
                reports = {
                    label = "Jelentések",
                },
                restore = {
                    label = "Visszaállítás",
                },
                rules = {
                    label = "Szabályzat",
                },
                scan = {
                    label = "Szkennelés",
                },
                scanner = {
                    label = "Rendszámolvasó",
                },
                sentence = {
                    label = "Büntetés",
                },
                shotsFired = {
                    label = "Lővések",
                },
                sound = {
                    label = "Hang",
                },
                speedcam = {
                    label = "Sebességfelmérők",
                },
                speedcamAdvanced = {
                    label = "Haladó sebességmérő",
                },
                speedcamBilling = {
                    label = "Sebességfelmérő számlázás",
                },
                speedcamDispatch = {
                    label = "Sebességmérő riasztás",
                },
                speedcamDurability = {
                    label = "Sebességfelmérő állóképesség",
                },
                speedcamPlacement = {
                    label = "Sebességfelmérő elhelyezése",
                },
                speedcamRepair = {
                    label = "Sebességfelmérő javítása",
                },
                speedcamRepairAnimation = {
                    label = "Sebességfelmérő javítás animáció",
                },
                speedcamTiming = {
                    label = "Sebességfelmérő időzítés",
                },
                speedcamVisual = {
                    label = "Sebességfelmérő megjelenés",
                },
                speedcams = {
                    label = "Sebességfelmérők",
                },
                storage = {
                    label = "Tároló",
                },
                subscription = {
                    label = "Alkalmazás előfizetés",
                },
                tackle = {
                    label = "Rángatás",
                },
                tasks = {
                    label = "Feladatok",
                },
                theme = {
                    label = "Téma",
                },
                timing = {
                    label = "Időzítés",
                },
                vin = {
                    label = "VIN ellenőrzés",
                },
                warningUi = {
                    label = "Figyelmeztető felület",
                },
                world = {
                    label = "Világ",
                },
                zipties = {
                    label = "Plasztik bilincs",
                },
                ziptiesCutter = {
                    label = "Plasztik bilincs vágó",
                },
            },
            settingSections = {
                radarGun = "Radar",
                billing = "Számlázás",
                cctv = "CCTV",
                dispatch = "Ügyelet",
                equipment = "Felszerelés",
                evidence = "Bizonyítékok",
                fakePlates = "Hamis rendszámok",
                general = "Általános",
                impound = "Rendőri elkobzási telek",
                jail = "Börtön",
                radar = "Jármű-radar",
                radial = "Kerékmenü műveletek",
                restraints = "Korlátozók",
                socialWork = "Szociális munka",
                speedCamera = "Sebességmérő kamera",
                spikeStrips = "Szöges sávok",
                stations = "Központok",
                tablet = "Tablet alkalmazások",
                tracking = "Követés",
            },
            settingSubsections = {
                app = "Sebességfelmérő alkalmazás",
                apps = "Alkalmazások",
                billing = "Számlázás",
                canteen = "Börtön kantina",
                dispatch = "Ügyelet",
                durability = "Állóképesség",
                electrical = "Börtön elektromos",
                general = "Általános",
                handcuffs = "Bilincsek és plasztik bilincsek",
                inmates = "Börtön foglyai",
                jobs = "Börtön munkák",
                keybinds = "Billentyűzések",
                motionDetection = "Mozgásérzékelés",
                mugshot = "Fotózás",
                placement = "Elhelyezés",
                repair = "Javítás",
                timing = "Időzítés",
                visuals = "Megjelenés",
            },
            settings = {
                radarGunClearKey = { label = "Radar: Mérési érték törlése" },
                radarGunToggleUiKey = { label = "Radar: Felület váltása" },
                radarGunNoTargetHoldMs = { label = "Célpont megtartási ideje (ms)" },
                radarGunMinimumReading = { label = "Legkisebb kijelzett sebesség" },
                radarGunSpeedSmoothing = { label = "Sebességsimítás (0–1)" },
                radarGunBeamRadius = { label = "Sugárnyaláb sugara (m)" },
                radarGunRefreshRateMs = { label = "Mérési időköz (ms)" },
                radarGunUseMph = { label = "MPH használata", description = "A radar sebességkijelzése mérföld/órában kilométer/óra helyett." },
                radarGunRange = { label = "Mérési hatótáv", description = "A radar legnagyobb érzékelési távolsága méterben." },
                radarGunRequireOnDuty = { label = "Szolgálat szükséges", description = "A radar használatához szolgálatban kell lenni." },
                radarGunAllowedJobs = { label = "Engedélyezett munkák vagy csoportok", description = "A police az összes beállított rendőri munkát jelenti; közvetlen munkanevek is megadhatók. Az üres lista feloldja a munkaköri korlátozást.", itemLabel = "Munka vagy csoport" },
                radarGunEnabled = { label = "Kézi radar", description = "A SKY SR-2 kézi radar engedélyezése." },
                tabletRegistry = {
                    label = "Nyilvántartás",
                    description = "Kézzel beállítható RP-regiszterek engedélyezése a Fájlkezelőben. A polgári és járművek nyilvántartása külön marad elérhető.",
                },
                tabletFiles = {
                    label = "Fájlböngésző",
                    description = "A polgári nyilvántartásokat csoportosítja a Fájlkezelőben. A DOJ-dokumentumok csak akkor jelennek meg, ha a DOJ fut.",
                },
                ankleMonitorAnimDurationMs = {
                    description = "A bokafigura felhelyezéséhez szükséges milliszekundum.",
                    label = "Felhelyezés időtartama",
                },
                ankleMonitorAnimScenario = {
                    description = "A bokafigura felhelyezése közben lejátszott szcenárió.",
                    label = "Felhelyezési szcenárió",
                },
                ankleMonitorAttachBone = {
                    description = "A bokafigura propjának rögzítéséhez használt ped csont.",
                    label = "Rögzítő csont",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "A bokafigura eltávolítása a felhelyezés után.",
                    label = "Bokafigura elhasználása",
                },
                ankleMonitorCutItem = {
                    description = "A bokafigurák eltávolítására szolgáló inventár tárgy.",
                    label = "Vágó tárgy",
                },
                ankleMonitorEnabled = {
                    description = "A bokafigura felhelyezésének engedélyezése.",
                    label = "Bokafigura",
                },
                ankleMonitorItem = {
                    description = "A bokafigurák felhelyezésére szolgáló inventár tárgy.",
                    label = "Bokafigura tárgy",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "A bokafigura térképfrissítések közötti időköz.",
                    label = "Térképfrissítési időköz",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "A bokafigurák megtartása az adatbázisban, ha a figyelés alatt lévő játékosok lekapcsolnak, hogy újraállítsák őket az újraindítás után.",
                    label = "Megőrzés lekapcsolás után",
                },
                ankleMonitorPlaceDistance = {
                    description = "A bokafigura felhelyezésének maximális távolsága.",
                    label = "Felhelyezési távolság",
                },
                ankleMonitorPropModel = {
                    description = "A bokafigura vizuális megjelenítéséhez használt prop modell.",
                    label = "Prop modell",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Nyomkövető használata előtt szolgálati állapot szükséges",
                    label = "A nyomkövető használata szolgálati állapotot igényel",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "A játékosnak a rendőrségi csoportban kell lennie a bokafigurák használata előtt.",
                    label = "A bokafigura rendőri munkakört igényel",
                },
                ankleMonitorReturnOnRemove = {
                    description = "A bokafigura visszaadása eltávolításkor.",
                    label = "Bokafigura visszaadása eltávolításkor",
                },
                ankleMonitorWarningSeconds = {
                    description = "Figyelmeztetési idő, mielőtt egy nyomkövető sávról való kilépés miatt riasztás érkezik.",
                    label = "Zónafigyelmeztetési másodpercek",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Időköz a bokafigura zónafigyelmeztető csipogásai között.",
                    label = "Zónacsipogási időköz",
                },
                ankleMonitorZoneBeepSound = {
                    description = "A bokafigura zónafigyelmeztetésekhez használt hang neve.",
                    label = "Csipogó hang",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "A bokafigura zónafigyelmeztetésekhez használt hangkészlet.",
                    label = "Csipogó hangkészlet",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "A bokafigura zóna blipjeihez használt alfaérték.",
                    label = "Blip alfaérték",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "A cél a megengedett zónán belüli helyzetben használt blip szín.",
                    label = "Megengedett blip szín",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "A cél a megengedett zónát elhagyó helyzetben használt blip szín.",
                    label = "Kizárt blip szín",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Időköz a bokafigura zónaellenőrzések között.",
                    label = "Zónaellenőrzési időköz",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Másodpercek, amíg egy újabb nyomkövető zóna-riasztás küldhető.",
                    label = "Zónaszegés-bejelentés hűtőidő",
                },
                ankleMonitorZoneEnabled = {
                    description = "A bokafigura zónaellenőrzések engedélyezése.",
                    label = "Bokafigura zónák",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Blip-sprite, amelyet a bokafigura zónajelzőkhez használnak.",
                    label = "Zónajelző sprite",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "A bokafigura zóna kereteinek meghatározásához használt sugár.",
                    label = "Keret sugara",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "A bokafigura zóna kereteinek meghatározásához használt lépésköz.",
                    label = "Keret lépésköze",
                },
                billingAccount = {
                    description = "A társadalmi fiók hiányában használt tartalékfiók.",
                    label = "Tartalék társadalmi fiók",
                },
                billingCloseOnSuccess = {
                    description = "A számlázási felület bezárása számla kiállítását követően.",
                    label = "Bezárás sikeresen",
                },
                billingCurrency = {
                    description = "A számlázáshoz használt pénznemkulcs. Hagyd üresen az alapértelmezett pénznem használatához.",
                    label = "Pénznem",
                },
                billingCustomReasons = {
                    description = "Egyedi számlázási okok engedélyezése az előre beállítottak helyett.",
                    label = "Egyedi okok",
                },
                billingDepositToSociety = {
                    description = "A számlázási bevétel befizetése a társadalmi fiókba.",
                    label = "Átutalás a társasági fiókba",
                },
                billingMaxReasonLength = {
                    description = "Az egyedi számlázási okok maximális karakterhossza.",
                    label = "Ok hossza",
                },
                billingMode = {
                    description = "Válaszd ki, hogy a rendőrségi számlák azonnal kerülnek-e levonásra, polgári megerősítést igényelnek-e, vagy a keretrendszer számlázási rendszerét használják.",
                    label = "Számlázási mód",
                    options = {
                        consent = "Fizet vagy utasít el",
                        framework = "Keretrendszeri számla",
                        instant = "Azonnali levonás",
                    },
                },
                billingRange = {
                    description = "A rendőrségi számlák kiállításához szükséges maximális céltávolság.",
                    label = "Számlázási hatótávolság",
                },
                billingReasonPresets = {
                    description = "Előre beállított számlázási okok, amelyeket a számlázási felületen jelenít meg a rendszer.",
                    itemLabel = "Indok",
                    label = "Okok előbeállításai",
                },
                billingRefreshSeconds = {
                    description = "A számlázási felület megnyitása közbeni célfrissítési időköz.",
                    label = "Frissítési másodpercek",
                },
                billingShowRecipientName = {
                    description = "A jegyvázlatokon és számlákon a címzett neve megjelenítése.",
                    label = "Címzett neve megjelenítése",
                },
                carryAllowCarrierInVehicle = {
                    description = "A szállító engedélyezése járműbe lépésére és vezetésére anélkül, hogy leengedné a szállított játékost.",
                    label = "Hordozó a járműben",
                },
                carryAllowConscious = {
                    description = "Élő célok szállítása engedélyezése.",
                    label = "Élő célok szállítása",
                },
                carryAllowSprint = {
                    description = "Sprintelés engedélyezése másik játékos szállítása közben.",
                    label = "Sprintelés szállításkor",
                },
                carryEnabled = {
                    description = "Játékosok szállítása engedélyezése.",
                    label = "Hordozás",
                },
                carryMaxDistance = {
                    description = "A játékos szállítása indításához szükséges maximális távolság.",
                    label = "Szállítási távolság",
                },
                carryRequireOnDuty = {
                    description = "Szolgálati állapot követelménye a szállítási kísérlet megkezdése előtt.",
                    label = "A szállításhoz szolgálati állapot szükséges",
                },
                cctvDamageCooldownMs = {
                    description = "Az időköz, amely alatt a CCTV-kamera sérülése újra alkalmazható.",
                    label = "Sérülési várakozási idő",
                },
                cctvDamagePerHit = {
                    description = "Minden egyes találatra a CCTV-kamerák tartósságát érvényesülő sérülés.",
                    label = "Sérülés együttesen",
                },
                cctvDefaultName = {
                    description = "Az üzemeltetett CCTV-kamerák alapértelmezett megjelenítési neve.",
                    label = "CCTV alapértelmezett név",
                },
                cctvDefaultPitch = {
                    description = "Alapértelmezett kamera dőlésszög a CCTV elhelyezéséhez.",
                    label = "Alapértelmezett emelés",
                },
                cctvDisassembleDistance = {
                    description = "A CCTV-kamerák szétbontásához használt távolság.",
                    label = "Szétbontási távolság",
                },
                cctvEnabled = {
                    description = "A CCTV-kamera-telepítés és közvetítés engedélyezése.",
                    label = "CCTV-kamerák",
                },
                cctvHealthDisplayDistance = {
                    description = "A CCTV-állapot megjelenítéséhez szükséges távolság.",
                    label = "Állapot megjelenítési távolság",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Az időtartam, amely alatt a CCTV-állapot látható marad.",
                    label = "Állapot megjelenítési időtartam",
                },
                cctvHealthTextOffset = {
                    description = "A CCTV-egészségi szöveghez használt függőleges eltolás.",
                    label = "Egészségi szöveg eltolása",
                },
                cctvHeightStep = {
                    description = "A CCTV-kamerák pozicionálásához használt magassági lépés.",
                    label = "Magassági lépés",
                },
                cctvItem = {
                    description = "A CCTV-kamerák elhelyezéséhez használt inventár-tárgy.",
                    label = "CCTV-tárgy",
                },
                cctvMaintenanceThreshold = {
                    description = "Az a tartóssági küszöb, ahol a CCTV-karbantartás javasolt.",
                    label = "Karbantartási küszöb",
                },
                cctvMaxDurability = {
                    description = "A CCTV-kamera maximális tartóssága.",
                    label = "CCTV-tartósság",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "A kamera által létrehozható további mozgásértesítés előtti másodpercek száma.",
                    label = "Riasztás várakozási idő",
                },
                cctvMotionCheckIntervalMs = {
                    description = "A kliens oldali mozgásellenőrzések közötti milliszekundumok száma.",
                    label = "Ellenőrzési intervallum",
                },
                cctvMotionClientCooldownMs = {
                    description = "Az a milliszekundumok száma, amíg egy kliens ugyanazt a kamerát újra jelentheti.",
                    label = "Kliens jelentési cooldown",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Újonnan elhelyezett CCTV-kamerákhoz automatikusan mozgásértesítések engedélyezése.",
                    label = "Új kamerák alapértelmezett engedélyezése",
                },
                cctvMotionDetectionEnabled = {
                    description = "Kamera-specifikus mozgásérzékelési értesítések engedélyezése.",
                    label = "Mozgásérzékelési értesítések",
                },
                cctvMotionDetectionRadius = {
                    description = "A mozgásérzékelés maximális távolsága méterben.",
                    label = "Érzékelési sugár",
                },
                cctvMotionFieldOfView = {
                    description = "A mozgásérzékelési kúp szöge fokban.",
                    label = "Látószög",
                },
                cctvMotionJobs = {
                    description = "A CCTV-mozgásértesítéseket kapó munkanév vagy munkacsoport kulcsok.",
                    itemLabel = "Munkakör vagy csoport",
                    label = "Diszpécseri munkák",
                },
                cctvMotionMinimumSpeed = {
                    description = "Az a minimális sebesség méter másodpercenként, ami mozgásnak számít.",
                    label = "Minimális mozgási sebesség",
                },
                cctvMoveStep = {
                    description = "A CCTV-kamerák pozicionálásához használt mozgási lépés.",
                    label = "Mozgási lépés",
                },
                cctvPropModel = {
                    description = "Az elhelyezett CCTV-kamerákhoz használt prop-modell.",
                    label = "CCTV-prop-modell",
                },
                cctvRepairAnimDict = {
                    description = "A CCTV-kamerák javításához használt animációs szótár.",
                    label = "Javítási animációs szótár",
                },
                cctvRepairAnimFlag = {
                    description = "A CCTV-kamerák javításához használt animációs jelző.",
                    label = "Javítási animációs jelző",
                },
                cctvRepairAnimName = {
                    description = "A CCTV-kamerák javításához használt animációs név.",
                    label = "Javítási animációs név",
                },
                cctvRepairCancelDelayMs = {
                    description = "Az a milliszekundumok száma, amíg a CCTV-javítás megszakítható.",
                    label = "Javítás megszakításának késleltetése",
                },
                cctvRepairDistance = {
                    description = "A CCTV-kamerák javításához használt távolság.",
                    label = "Javítási távolság",
                },
                cctvRepairItem = {
                    description = "A CCTV-kamerák javításához használt inventár-tárgy.",
                    label = "Javítási tárgy",
                },
                cctvRepairPerTick = {
                    description = "A CCTV-javítási ciklusonként helyreállított tartósság.",
                    label = "Javítás ciklusonként",
                },
                cctvRepairTickMs = {
                    description = "A CCTV-javítási ciklusok közötti milliszekundumok száma.",
                    label = "Javítási ciklus",
                },
                cctvRotateStep = {
                    description = "A CCTV-kamerák pozicionálásához használt forgási lépés.",
                    label = "Forgási lépés",
                },
                cctvStreamDistance = {
                    description = "A CCTV-kamerák streamingjéhez használt távolság.",
                    label = "Stream távolság",
                },
                cctvViewOffset = {
                    description = "A CCTV élő kamera rendereléséhez használt nézeteltolás.",
                    label = "Nézeteltolás",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Blokkoló ütközési akadályt hoz létre a szalag mentén, így a játékosok nem léphetnek át rajta.",
                    label = "Blokkoló szalag-ütközés",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Egy szalagtárgy eltávolítása az inventárból a sikeres elhelyezés után.",
                    label = "Szalagtárgy fogyasztása",
                },
                crimeSceneTapeDynamic = {
                    description = "Engedi, hogy a szalag a fizikára és a gravitációra reagáljon, helyett, hogy rögzítve tartaná.",
                    label = "Dinamikus fizika",
                },
                crimeSceneTapeEnabled = {
                    description = "A bűnügyi helyszíni szalag elhelyezése inventárból származó tárgyból.",
                    label = "Bűnügyi helyszíni szalag",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Csak engedélyezett foglalkozások tagjai távolíthatják el a szalagot; ha engedélyezve van, akkor szolgálatban kell lenniük.",
                    label = "Eltávolítás korlátozása",
                },
                crimeSceneTapeItem = {
                    description = "Az inventárbeli tárgy neve, amely elindítja a bűnügyi helyszíni szalag elhelyezését.",
                    label = "Szalagtárgy",
                },
                crimeSceneTapeJobs = {
                    description = "Engedélyezett foglalkozások, amelyek használhatják a bűnügyi helyszíni szalagot.",
                    itemLabel = "Foglalkozás",
                    label = "Engedélyezett foglalkozások",
                },
                crimeSceneTapeLabel = {
                    description = "A bűnügyi helyszíni szalag nevének megjelenítése az elhelyezés során.",
                    label = "Szalag felirata",
                },
                crimeSceneTapeLengthStep = {
                    description = "A kiválasztott szalaghossz kerekítésének méterben kifejezett lépésköze.",
                    label = "Hossz lépésköze",
                },
                crimeSceneTapeMaxLength = {
                    description = "A két szalagpótló közötti legnagyobb megengedett távolság méterben.",
                    label = "Maximális szalaghossz",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "A szalagot elhelyező tisztviselőtől mért legnagyobb távolság bármelyik végpontig.",
                    label = "Maximális elhelyezési távolság",
                },
                crimeSceneTapeMinLength = {
                    description = "A két szalagpótló közötti legkisebb megengedett távolság méterben.",
                    label = "Minimális szalaghossz",
                },
                crimeSceneTapeModel = {
                    description = "A elhelyezett bűnügyi helyszíni szalaghoz használt prop modell neve.",
                    label = "Szalag modell",
                },
                crimeSceneTapePostModel = {
                    description = "Mindkét szalagpótlóhoz használt prop modell.",
                    label = "Pótló modell",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "A elhelyezett bűnügyi helyszíni szalag eltávolításához szükséges legnagyobb távolság.",
                    label = "Eltávolítási távolság",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Csak a megengedett foglalkozások szolgálatban lévő tagjai helyezhetik el a szalagot.",
                    label = "Szolgálat kötelező",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "A fogyasztott tárgy visszaadása, amikor a elhelyezett szalagot eltávolítják.",
                    label = "Tárgy visszaadása eltávolításkor",
                },
                crimeSceneTapeSag = {
                    description = "A szalag lefelé történő legnagyobb lebegése a pótlók között méterben.",
                    label = "Szalag lebegése",
                },
                crimeSceneTapeSections = {
                    description = "A kiválasztott hossz összeállításához használt natív szalagszakasz-modellek.",
                    itemLabel = "Szalagszakasz",
                    label = "Szalagszakaszok",
                },
                crimeSceneTapeShowPosts = {
                    description = "Látható támaszpótlókat hoz létre a változó hosszúságú bűnügyi helyszíni szalag mindkét végén.",
                    label = "Szalagpótlók megjelenítése",
                },
                crimeSceneTapeStreamDistance = {
                    description = "A elhelyezett bűnügyi helyszíni szalag betöltésének távolsága.",
                    label = "Streaming-távolság",
                },
                crimeSceneTapeTapeHeight = {
                    description = "A szalag magassága a kiválasztott földi pontok felett.",
                    label = "Szalag magassága",
                },
                crimeSceneTapeVariableLength = {
                    description = "Engedi a tisztviselőknek, hogy kezdő- és végpontot állítsanak be a bűnügyi helyszíni szalag változó hosszúságú elhelyezéséhez.",
                    label = "Változó szalaghossz",
                },
                crimeSceneTapeZOffset = {
                    description = "Vertikális eltolás a szalagmodell elhelyezésekor.",
                    label = "Magasság-offset",
                },
                cuffsAnimDict = {
                    description = "A korlátozott játékosokhoz használt animációs szótár.",
                    label = "Animációs szótár",
                },
                cuffsAnimFlag = {
                    description = "A korlátozott játékosokhoz használt animációs jelző.",
                    label = "Animációs jelző",
                },
                cuffsAnimName = {
                    description = "A korlátozott játékosokhoz használt animáció neve.",
                    label = "Animáció neve",
                },
                cuffsConsumeItem = {
                    description = "A bilincs tárgy eltávolítása, ha bilincseket alkalmaznak.",
                    label = "Bilincsek használata",
                },
                cuffsEnabled = {
                    description = "Bilincs műveletek engedélyezése.",
                    label = "Bilincsek",
                },
                cuffsEscapeEnabled = {
                    description = "A bilincsekből való menekülés minijátékának engedélyezése.",
                    label = "Bilincsből való menekülés",
                },
                cuffsEscapeKeyPool = {
                    description = "A bilincsből való menekülés minijátékában megjelenő billentyűk.",
                    itemLabel = "Billentyű",
                    label = "Menekülési billentyűkészlet",
                },
                cuffsEscapeRounds = {
                    description = "A bilincsből való menekülés minijátékában szükséges körök száma.",
                    label = "Menekülési körök",
                },
                cuffsEscapeWindowMs = {
                    description = "Engedélyezett milliszekundumok a bilincsből való menekülés bemeneti ablakánként.",
                    label = "Menekülési ablak",
                },
                cuffsHandsUpEnabled = {
                    description = "A bilincsek és a plasztik bilincsek által használt kézfelémelés állapot engedélyezése.",
                    label = "Kézfelémelés",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "A kézfelémelés aktiválásához szükséges nyomóidő másodpercben.",
                    label = "Kézfelémelés tartási idő",
                },
                cuffsHandsUpKey = {
                    description = "A kézfelémeléshez használt billentyűzet-gomb.",
                    label = "Kézfelémelés gomb",
                },
                cuffsItem = {
                    description = "A bilincs műveletekhez használt inventár-tárgy.",
                    label = "Bilincs tárgy",
                },
                cuffsMaxDistance = {
                    description = "A bilincs műveletekhez szükséges maximális céltávolság.",
                    label = "Bilincs távolság",
                },
                cuffsRequireItem = {
                    description = "A konfigurált bilincs tárgy használata kötelező.",
                    label = "Bilincs tárgy szükséges",
                },
                cuffsRequireOnDuty = {
                    description = "Szolgálati státusz szükséges a bilincselés előtt.",
                    label = "Bilincselés igényel szolgálatot",
                },
                cuffsReturnOnRemove = {
                    description = "A bilincs tárgy visszaadása a bilincs eltávolításakor.",
                    label = "Bilincs visszaadása",
                },
                dispatchOfficerDownEnabled = {
                    description = "Dispatch-riasztás küldése, ha egy szolgálatban lévő rendőr kiesik.",
                    label = "Rendőrkiesés riasztások",
                },
                dispatchOfficerDownJobs = {
                    description = "Azok a foglalkozások, amelyek rendőrkiesés esetén kapnak riasztást.",
                    itemLabel = "Foglalkozás",
                    label = "Rendőrkiesés foglalkozások",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Csak a jelenleg szolgálatban lévő játékosok értesítése.",
                    label = "Rendőrkiesés igényel szolgálatot",
                },
                dispatchShotsFiredChance = {
                    description = "0.0 és 1.0 közötti esély arra, hogy egy észlelt lövés riasztást generáljon.",
                    label = "Riasztási esély",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "A másodperc száma, amíg ugyanaz a játékos újra lövés-riasztást indíthat.",
                    label = "Lövés hűtési idő",
                },
                dispatchShotsFiredEnabled = {
                    description = "Lövés-riasztások engedélyezése.",
                    label = "Lövés-riasztások",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Azok a fegyverek, amelyek nem indítanak lövés-riasztást.",
                    itemLabel = "Fegyver",
                    label = "Figyelmen kívül hagyott fegyverek",
                },
                dispatchShotsFiredJobs = {
                    description = "Azok a foglalkozások, amelyek lövés esetén kapnak riasztást.",
                    itemLabel = "Foglalkozás",
                    label = "Lövés foglalkozások",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Csak a jelenleg szolgálatban lévő játékosok értesítése.",
                    label = "Lövés igényel szolgálatot",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Lövés észlelésekor Dispatch-bejegyzések létrehozása.",
                    label = "Lövésjelek Dispatch küldése",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "0.0 és 1.0 közötti esélye annak, hogy egy elnyomott lövés riasztást vált ki.",
                    label = "Elnyomott riasztás esélye",
                },
                escortEnabled = {
                    description = "Játékosok kísérésének engedélyezése.",
                    label = "Eskortálás",
                },
                escortMaxDistance = {
                    description = "A játékos kísérésének megkezdéséhez szükséges maximális távolság.",
                    label = "Kísérési távolság",
                },
                escortRequireOnDuty = {
                    description = "Kísérés előtt szolgálati állapot megkövetelése.",
                    label = "Kíséréshez szolgálati állapot szükséges",
                },
                escortVehicleDistance = {
                    description = "A kísért játékos járműbe ültetéséhez szükséges maximális távolság.",
                    label = "Kísérési jármű-távolság",
                },
                evidenceBloodDamageThreshold = {
                    description = "A véres nyomok létrehozásához szükséges minimális sérülési küszöb.",
                    label = "Vérnyomok küszöbe",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Két lőszerhüvely létrehozása közötti idő (milliszekundumban).",
                    label = "Hüvely-hűlés",
                },
                evidenceCasingMergeRadius = {
                    description = "Közel lévő lőszerhüvelyek egyesítéséhez használt sugár.",
                    label = "Hüvely-egyesítési sugár",
                },
                evidenceCleanupIntervalMs = {
                    description = "Bizonyíték-takarítási ciklusok közötti idő milliszekundumban.",
                    label = "Takarítási intervallum",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Másodpercek, amíg a helyszíni bizonyítékok automatikusan elévülnek.",
                    label = "Takarítási TTL",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Tisztítószer mindenkinek",
                    description = "Mindenki eltüntetheti a nyomokat hidrogén-peroxiddal. Kapcsold ki a foglalkozás- és bandalisták használatához.",
                },
                evidenceCleanerJobs = {
                    label = "Tisztítószert használó foglalkozások",
                    description = "Engedélyezett belső nevek kikapcsolt nyilvános hozzáférésnél. A foglalkozás vagy banda egyezése engedélyezi a használatot; az üres listák tiltják.",
                    itemLabel = "Foglalkozás",
                },
                evidenceCleanerGangs = {
                    label = "Tisztítószert használó bandák",
                    description = "Engedélyezett belső nevek kikapcsolt nyilvános hozzáférésnél. A foglalkozás vagy banda egyezése engedélyezi a használatot; az üres listák tiltják.",
                    itemLabel = "Banda",
                },
                evidenceCollectDistance = {
                    description = "A helyszínen található fizikai bizonyítékok összegyűjtéséhez használt távolság.",
                    label = "Gyűjtési távolság",
                },
                evidenceDiscoverDistance = {
                    description = "Közel lévő bizonyítékmárkerek felfedezéséhez használt távolság.",
                    label = "Felfedezési távolság",
                },
                evidenceFieldEnabled = {
                    description = "Engedélyezze a helyszíni bizonyítékok létrehozását és gyűjtését.",
                    label = "Helyszíni bizonyíték",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Ez a fegyver szolgál a helyszínen található bizonyítékok vizsgálatára és feltárására.",
                    label = "Zseblámpa-fegyver",
                },
                evidenceGloveFreeHands = {
                    description = "Kézkomponens-azonosítók, amelyeket kesztyű nélküli kéznek tekintünk.",
                    label = "Kesztyű nélküli kéz",
                },
                evidenceGsrDurationSeconds = {
                    description = "Másodpercek, ameddig a lövés maradványai a játékos kezén maradnak.",
                    label = "GSR időtartam",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Megakadályozza a GSR alkalmazását, ha a lövő kesztyűt visel.",
                    label = "Kesztyűk védik a kezeket",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Olyan fegyverek, amelyek nem hagynak lövés maradványt.",
                    label = "Figyelmen kívül hagyott fegyverek",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisekunder a víz/eső tisztítási ellenőrzések között, amíg a GSR aktív.",
                    label = "Tisztítási ellenőrzés intervalluma",
                },
                evidenceGsrWashInRain = {
                    description = "Lehetővé teszi, hogy az eső eltávolítsa a lövés maradványait.",
                    label = "Tisztítás esőben",
                },
                evidenceGsrWashInWater = {
                    description = "Lehetővé teszi, hogy a víz eltávolítsa a lövés maradványait.",
                    label = "Tisztítás vízben",
                },
                evidenceMarkerColor = {
                    description = "A helyszíni bizonyítékok jelölőinek használt RGBA szín.",
                    label = "Márker színe",
                },
                evidenceMarkerDrawDistance = {
                    description = "A helyszíni bizonyítékok jelölőinek megjelenítési távolsága.",
                    label = "Megjelenítési távolság",
                },
                evidenceMarkerOffset = {
                    description = "A helyszíni bizonyítékokhoz használt függőleges eltolás.",
                    label = "Eltolás",
                },
                evidenceMarkerScaleX = {
                    description = "A Marker X skálája a helyszíni bizonyítékokhoz használt.",
                    label = "X skálázás",
                },
                evidenceMarkerScaleY = {
                    description = "A helyszíni bizonyítékokhoz használt jelölő Y skálája.",
                    label = "Y skálázás",
                },
                evidenceMarkerScaleZ = {
                    description = "A Z-tengelybeli skálázás a helyszíni bizonyítékok jelölőjéhez.",
                    label = "Z skálázás",
                },
                evidenceMarkerType = {
                    description = "A helyszíni bizonyítékokhoz használt jelölőtípus.",
                    label = "Márker típusa",
                },
                evidenceMaxCreateDistance = {
                    description = "Bizonyíték-bejegyzések létrehozásához szükséges maximális távolság.",
                    label = "Létrehozási távolság",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Nyálmintavételhez szükséges engedélyezési idő (milliszekundumban).",
                    label = "Nyál-engedélyezési idő",
                },
                evidenceScannerDistance = {
                    description = "Bizonyítékszkennerekkel való interakciókhoz használt távolság.",
                    label = "Szkennertávolság",
                },
                evidenceScannerDurationMs = {
                    description = "Ujjlenyomat/szkennelési művelet időtartama (milliszekundumban).",
                    label = "Scanner időtartama",
                },
                evidenceStorageMaxCompartments = {
                    description = "A maximális bizonyítéktárolókompartimentek száma.",
                    label = "Tárolókompartimentek",
                },
                fakePlateHeliDisplay = {
                    label = "Helikamera mutatja a hamis rendszámot",
                    description = "Megjeleníti a hamis rendszámot a helikamerában.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normál eszközök mutatják a hamis rendszámot",
                    description = "Megjeleníti a hamis rendszámot a szabványos rendőri eszközökben.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar mutatja a hamis rendszámot",
                    description = "Megjeleníti a hamis rendszámot a fedélzeti radaron.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Lehetővé teszi a rendőri rendszerek számára a megosztott hamis rendszám statebag olvasását.",
                    label = "Hamis rendszámok felismerése",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "A Mechanicjob által közzétett jármű-entitás statebag kulcsa.",
                    label = "Statebag kulcs",
                },
                fakePlateSpeedCamDisplay = {
                    label = "A sebességmérő hamis rendszámot mutat.",
                    description = "Megjeleníti a hamis rendszámot a rögzített radar jelentésekben.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Opcionális engedélyezett állás/rang lista. Hagyja üresen az engedélyezett állások minden rangjának lehetővé tételéhez.",
                    label = "VIN rangok",
                },
                fakePlateVinAllowedGangs = {
                    label = "Engedélyezett bandák",
                    description = "Válaszd a bandák vagy független szervezetek belső neveit. Az egyező foglalkozás vagy banda engedélyt vagy kivételt ad. A szolgálati követelmény csak a foglalkozásokra érvényes.",
                    itemLabel = "Banda",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Bandák minimális rangjai",
                    description = "Opcionális minimális bandarangi követelmények. Üres lista esetén minden rang engedélyezett. A tárgykövetelmények továbbra is érvényesek.",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN állások",
                    description = "Azoknak az állásoknak a listája, amelyek használhatják a VIN-ellenőrzést.",
                },
                fakePlateVinAudit = {
                    label = "VIN ellenőrzések auditálása",
                    description = "Mentés a VIN-ellenőrzések audit naplóba.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN ellenőrzés engedélyezve",
                    description = "Engedélyezi a jármű VIN-ellenőrzés parancsát.",
                },
                fakePlateVinCommand = {
                    label = "VIN parancs",
                    description = "Parancs a jármű VIN-ellenőrzéséhez.",
                },
                fakePlateVinCooldown = {
                    label = "VIN hűvösödési idő",
                    description = "Késleltetés két VIN-ellenőrzés között.",
                },
                fakePlateVinDistance = {
                    label = "VIN maximális távolság",
                    description = "A rendőr és a jármű közötti maximális távolság a VIN-ellenőrzéshez.",
                },
                fakePlateVinIndicator = {
                    label = "Hamis jelző megjelenítése",
                    description = "Megjelenít egy jelzőt, ha egy ellenőrzés hamis rendszámot észlel.",
                },
                fakePlateVinRequireDuty = {
                    label = "Szolgálati kötelezettség",
                    description = "Megköveteli, hogy a rendőr szolgálatban legyen a VIN-ellenőrzéshez.",
                },
                fakePlateVinRequireScanner = {
                    label = "Olvasható eszköz szükséges",
                    description = "Megköveteli a konfigurált olvasó eszközt a VIN-ellenőrzéshez.",
                },
                fakePlateVinScannerItem = {
                    label = "Olvasó eszköz",
                    description = "Tárolóelem, amely szükséges a VIN-ellenőrzéshez.",
                },
                gpsTrackerBeepDistance = {
                    description = "A távolság, ahol a GPS-nyomkövető csipogási visszajelzése relevánssá válik.",
                    label = "Csipogási távolság",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "A csipogások közötti milliszekundumok száma, ha távol van egy nyomkövetőtől.",
                    label = "Távoli csipogási intervallum",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "A csipogások közötti milliszekundumok száma, ha közel van egy nyomkövetőhöz.",
                    label = "Közel csipogási intervallum",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "A nyomkövető tárgy eltávolítása elhelyezés után.",
                    label = "GPS-nyomkövető felhasználása",
                },
                gpsTrackerEnabled = {
                    description = "A járművön lévő GPS-nyomkövető elhelyezése és szkennelése engedélyezése.",
                    label = "GPS-nyomkövető",
                },
                gpsTrackerItem = {
                    description = "A GPS-nyomkövetők elhelyezésére használt inventár-tárgy.",
                    label = "Nyomkövető tárgy",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "A nyomkövető térképfrissítések közötti milliszekundumok száma.",
                    label = "Térképfrissítési időköz",
                },
                gpsTrackerPlaceDistance = {
                    description = "A maximális távolság, amelyen egy GPS-nyomkövető elhelyezhető egy járműre.",
                    label = "Elhelyezési távolság",
                },
                gpsTrackerRemoveDistance = {
                    description = "A maximális távolság, amelyen egy elhelyezett GPS-nyomkövető eltávolítható.",
                    label = "Eltávolítási távolság",
                },
                gpsTrackerRemoveKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "GPS-nyomkövető eltávolítása",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Szolgálati állapot követelménye a GPS-nyomkövetők használata előtt.",
                    label = "GPS szolgálatot igényel",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "A játékosnak a rendőrségi csoportban kell lennie a GPS-nyomkövetők használata előtt.",
                    label = "GPS rendőri munkát igényel",
                },
                gpsTrackerReturnOnRemove = {
                    description = "A nyomkövető tárgy visszaadása eltávolításakor.",
                    label = "Nyomkövető visszaadása eltávolításkor",
                },
                gpsTrackerScanDistance = {
                    description = "A nyomkövetők szkennelésére használt maximális távolság.",
                    label = "GPS szkennelési távolság",
                },
                gpsTrackerScanDurationMs = {
                    description = "A GPS-nyomkövető szkennelésére fordított milliszekundumok száma.",
                    label = "Scan időtartam",
                },
                gpsTrackerScannerWeapon = {
                    description = "A GPS-nyomkövetők keresésére használt fegyver vagy eszköz.",
                    label = "Szkennelő fegyver",
                },
                impoundAccount = {
                    description = "A számla, amelyről a rendőri elkobzási telekről történő járművisszavétel díja levonásra kerül.",
                    label = "Fizetési fiók.",
                },
                impoundCreatorVehicleModel = {
                    description = "A lefoglaló létrehozó előnézetében megjelenített járműmodell.",
                    label = "Létrehozó járműmodell",
                },
                impoundCustomGarageEnabled = {
                    description = "Egyéni garázs lefoglalási felület használata, ha elérhető.",
                    label = "Egyéni garázs lefoglalás",
                },
                impoundDefaultPrice = {
                    description = "Alapértelmezett járműkivezetési díj a rendőri elkobzási telekről.",
                    label = "Alapértelmezett ár",
                },
                impoundDeliveryDistance = {
                    description = "A lefoglalási kézbesítési interakciókhoz használt távolság.",
                    label = "Kézbesítési távolság",
                },
                impoundDeliveryMarker = {
                    description = "A lefoglalási kézbesítésekhez használt jelölő konfiguráció.",
                    label = "Kézbesítési jelölő",
                },
                impoundEnabled = {
                    description = "A lefoglalási munkafolyamatok engedélyezése.",
                    label = "Rendőri elkobzási telek",
                },
                impoundMarker = {
                    description = "A lefoglalási interakciókhoz használt jelölő konfiguráció.",
                    label = "Lefoglalási jelölő",
                },
                impoundRadialEnabled = {
                    description = "A körmenüs lefoglalási műveletek engedélyezése.",
                    label = "Lefoglalási művelet",
                },
                impoundRadialRequireOnDuty = {
                    description = "Szolgálati állapot követelménye a körmenüs lefoglalási művelet használata előtt.",
                    label = "Lefoglalás szolgálati állapotot igényel",
                },
                impoundRadialVehicleDistance = {
                    description = "A körmenüs lefoglalási műveletekhez megengedett maximális távolság a célgépjárműtől.",
                    label = "Lefoglalási távolság",
                },
                impoundReleaseDistance = {
                    description = "A lefoglalásból való kiadás interakciókhoz használt távolság.",
                    label = "Kiadási távolság",
                },
                impoundReleaseKey = {
                    description = "A lefoglalt járművek kiadásához használt vezérlő kód.",
                    label = "Kiadási gomb",
                },
                impoundRequireDelivery = {
                    description = "Kötelező kézbesítés egy beállított rendőri elkobzási telekre.",
                    label = "Kézbesítés kötelező",
                },
                impoundStorageBasePrice = {
                    description = "Alap kiadási ár a tárolt lefoglalt járművekhez.",
                    label = "Tárolási alapár",
                },
                impoundStorageDailyFee = {
                    description = "További tárolási díj minden beállított napra.",
                    label = "Tárolási napi díj",
                },
                impoundStorageDaySeconds = {
                    description = "Hány másodperc számít egy tárolási számlázási napnak.",
                    label = "Tárolási nap másodpercben",
                },
                impoundStorageEnabled = {
                    description = "Díjköteles lefoglalási tárolás kezelése engedélyezése.",
                    label = "Lefoglalási tárolás",
                },
                jailAssignRange = {
                    description = "A cél börtönbe helyezéséhez megengedett maximális távolság.",
                    label = "Helyezési távolság",
                },
                jailCanteenCooldownMinutes = {
                    description = "Perc, amit egy fogvatartottnak várnia kell, mielőtt újabb konyhai csomagot igényelhetne.",
                    label = "Visszaszámlálás percekben",
                },
                jailCanteenPackage = {
                    description = "A börtöni konyhai csomag által biztosított tárgyak.",
                    label = "Konyhai csomag",
                },
                jailCellStreamDistance = {
                    description = "A magánzárkák prop töltéséhez használt távolság.",
                    label = "Zárka töltési távolság",
                },
                jailClearInventory = {
                    description = "A játékos inventoryjének ürítése börtönbe küldéskor.",
                    label = "Inventory ürítése",
                },
                jailDefaultMonths = {
                    description = "Alapértelmezett börtöni időtartam a hozzárendelési UI megnyitásakor.",
                    label = "Alapértelmezett hónapok",
                },
                jailDispatchJobs = {
                    description = "Azok a foglalkozások, amelyek börtöni riasztásokat kapnak.",
                    itemLabel = "Foglalkozás",
                    label = "Diszpécseri munkák",
                },
                jailDoctorHealEvent = {
                    description = "Szerver vagy kliens esemény, amely akkor indul el, amikor a börtöni orvos meggyógyítja a fogvatartottat.",
                    label = "Gyógyulási esemény",
                },
                jailElectricalCodeListItem = {
                    description = "Inventory tétel, amely szükséges a generált elektromos kódok feltárásához.",
                    label = "Kódlista tétel",
                },
                jailElectricalCodeMax = {
                    description = "Legmagasabb véletlenszerű kódérték az elektromos dobozhoz.",
                    label = "Maximális kód",
                },
                jailElectricalCodeMin = {
                    description = "Az elektromos doboz legkisebb véletlenszerű kódértéke.",
                    label = "Minimális kód",
                },
                jailElectricalCodesCount = {
                    description = "Hány lehetséges kód generálódik az elektromos dobozhoz.",
                    label = "Kódok száma",
                },
                jailElectricalEnabled = {
                    description = "Engedélyezi a börtön elektromos szökési minijátékát.",
                    label = "Elektromos doboz",
                },
                jailElectricalPinLength = {
                    description = "Az elektromos doboz PIN-kódjához használt számjegyek száma.",
                    label = "PIN hossza",
                },
                jailElectricalPropModel = {
                    description = "A börtön elektromos dobozához használt világobjektum modell.",
                    label = "Prop modell",
                },
                jailElectricalShockDamage = {
                    description = "A sérülés, amely akkor keletkezik, ha egy fogvatartott nem teljesíti az elektromos szekvenciát.",
                    label = "Áramütés sérülése",
                },
                jailElectricalShockRagdollMs = {
                    description = "A ragdoll állapot másodpercmásodperce az áramütés után.",
                    label = "Áramütés ragdoll",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "A büntetésből levont percek száma egy sikeres elektromos szökési kísérlet után.",
                    label = "Siker esetén levont percek",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Az alkoholist fogoly kereskedéséhez szükséges mennyiség.",
                    label = "Szükséges mennyiség",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Az alkoholos fogoly kereskedéséhez szükséges tárgy.",
                    label = "Szükséges tárgy",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Az alkoholos fogoly kereskedéséért járó jutalom összege.",
                    label = "Jutalom összege",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Az alkoholos fogoly kereskedéséért járó jutalom tárgya.",
                    label = "Jutalom tárgya",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Az alkoholos fogoly kereskedéshez megjelenített jutalom felirata.",
                    label = "Jutalom felirata",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Az informátor fogoly kereskedéséhez szükséges mennyiség.",
                    label = "Szükséges mennyiség",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Az informátor fogoly kereskedéséhez szükséges tárgy.",
                    label = "Szükséges tárgy",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Az informátor fogoly kereskedéséért járó jutalom összege.",
                    label = "Jutalom összege",
                },
                jailInmateCodeListRewardItem = {
                    description = "Az informátor fogoly kereskedéséért járó jutalom tárgya.",
                    label = "Jutalom tárgya",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Az informátor fogoly kereskedéshez megjelenített jutalom felirata.",
                    label = "Jutalom felirata",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Elfogadott tárgyak a drogdíler fogoly kereskedéséhez.",
                    label = "Elfogadott tárgyak",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "A drogdíler fogoly kereskedéséhez szükséges mennyiség.",
                    label = "Szükséges mennyiség",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "A drogdíler fogoly kereskedéséért járó jutalom összege.",
                    label = "Jutalom összege",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "A drogdíler fogoly kereskedéséért járó jutalom tárgya.",
                    label = "Jutalom tárgya",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "A drogdíler fogoly kereskedéshez megjelenített jutalom felirata.",
                    label = "Jutalom felirata",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Engedélyezi, hogy a börtön takarításakor talált csempészcikkek számítsanak a drogdíler fogoly kereskedéséhez.",
                    label = "Takarítási csempészcikkek használata",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "A szerszámos fogoly kereskedéséhez szükséges mennyiség.",
                    label = "Szükséges mennyiség",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "A szerszámos fogoly kereskedéséhez szükséges tárgy.",
                    label = "Szükséges tárgy",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "A szerszámos fogoly kereskedéséért járó jutalom összege.",
                    label = "Jutalom összege",
                },
                jailInmateWireCutterRewardItem = {
                    description = "A szerszámos fogoly kereskedéséért járó jutalom tárgya.",
                    label = "Jutalom tárgya",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "A szerszámos fogoly kereskedéséhez megjelenített jutalom felirata.",
                    label = "Jutalom felirata",
                },
                jailJobsCarryBoxModel = {
                    description = "A börtöni hordozási feladathoz használt prop modell.",
                    label = "Hordozási doboz modell",
                },
                jailJobsCarryDropoffKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Börtön munka: leadás",
                },
                jailJobsCarryDropoffRadius = {
                    description = "A hordozási börtön feladat leadási sugara.",
                    label = "Leadási sugár",
                },
                jailJobsCarryInspectKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Börtön munka: vizsgálat",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "A hordozási feladat dobozainak vizsgálatakor talált szemét tárgyak.",
                    label = "Szemét vizsgálati tárgyak",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Hasznos zsákmány esélye a dobozok vizsgálatakor.",
                    label = "Hasznos zsákmány esélye",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "A hordozási feladat dobozainak vizsgálatakor talált hasznos tárgyak.",
                    label = "Hasznos vizsgálati tárgyak",
                },
                jailJobsCarryInteractDistance = {
                    description = "A hordozási börtön feladat interakciós távolsága.",
                    label = "Hordozási interakciós távolság",
                },
                jailJobsCarryMaxDistance = {
                    description = "A hordozási börtön feladat előrehaladásához megengedett maximális távolság.",
                    label = "Hordozási maximális távolság",
                },
                jailJobsCarryPickupKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Börtön munka: felvétel",
                },
                jailJobsCarryPickupOffset = {
                    description = "A hordozási feladat felvételi helyéhez használt eltolási objektum.",
                    label = "Felvételi eltolás",
                },
                jailJobsCarryTimeReduction = {
                    description = "A hordozási börtön feladat befejezéséért járó büntetés csökkenése.",
                    label = "Hordozási időcsökkentés",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Takarítás: elhelyezés",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "A börtöni takarítási kuka propjához használt modell.",
                    label = "Kuka modell",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "A takarítás során talált tiltott tárgyak esélye.",
                    label = "Tiltott tárgy találati esélye",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "A börtöni takarítás során talált tárgyak.",
                    label = "Tiltott tárgy találatok tárgyai",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "A tiltott tárgy találati felugró ablak időtúllépése milliszekundumban.",
                    label = "Találati felugró ablak időtúllépése",
                },
                jailJobsCleaningInteractDistance = {
                    description = "A takarítási szemét interakciójához használt távolság.",
                    label = "Takarítási interakciós távolság",
                },
                jailJobsCleaningMaxDistance = {
                    description = "A maximális távolság, amelynél a takarítási propok visszaállnak vagy eltűnnek.",
                    label = "Takarítási maximális távolság",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "A börtöni takarításhoz egyszerre megjelenő maximális szemét propok száma.",
                    label = "Maximális szemét propok",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "A takarítási szemét megjelenésének minimális távolsága a középponttól.",
                    label = "Minimális megjelenési sugár",
                },
                jailJobsCleaningPickupKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Takarítás: felvétel",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "A takarítási szemét megjelenési kísérletek közötti idő milliszekundumban.",
                    label = "Szemét megjelenési intervallum",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "A tisztítási szemét prop-objektumok generálásához használt sugár.",
                    label = "Szemét generálási sugár",
                },
                jailJobsCleaningTrashModels = {
                    description = "A börtöni takarítási feladathoz használt szemét prop-modelljei.",
                    itemLabel = "Modell",
                    label = "Szemét modellek",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Az RGBA kontúrszín, amelyet a börtöni takarítási szemét prop-objektumokhoz használnak.",
                    label = "Kontúrszín",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Kontúrok engedélyezése a börtöni takarítási szemét prop-objektumokon.",
                    label = "Szemét kontúr",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "A börtöni takarítási szemét kontúrokhoz használt shader azonosító.",
                    label = "Kontúr shader",
                },
                jailJobsTimeReduction = {
                    description = "A börtöni takarítási feladat befejezéséért járó börtöncsökkenés.",
                    label = "Takarítási időcsökkentés",
                },
                jailJobsTrashGoal = {
                    description = "A börtöni takarítási feladat befejezéséhez szükséges szemét tárgyak száma.",
                    label = "Takarítási szemét cél",
                },
                jailMaxMonths = {
                    description = "A kiválasztható börtöni tartózkodás maximális ideje.",
                    label = "Maximális hónapok",
                },
                jailMinMonths = {
                    description = "A kiválasztható börtöni tartózkodás minimális ideje.",
                    label = "Minimális hónapok",
                },
                jailMonthMinutes = {
                    description = "Az a valós idejű percek száma, amely egy börtöni hónapnak felel meg.",
                    label = "Percek hónapra",
                },
                jailObjectStreamDistance = {
                    description = "A távolság, amelyet a tartós börtöni világobjektumok streamingjéhez használnak.",
                    label = "Objektum stream távolság",
                },
                jailOutfitApplyDelayMs = {
                    description = "A késleltetés a csatlakozás után, mielőtt a börtöni ruházatot felvennék.",
                    label = "Ruházat felvételi késleltetés",
                },
                jailOutfitEnabled = {
                    description = "Börtöni ruházatok engedélyezése.",
                    label = "Börtöni ruházat",
                },
                jailOutfitFemaleArms = {
                    description = "A női börtöni ruházat kar-komponense.",
                    label = "Karok",
                },
                jailOutfitFemaleChain1 = {
                    description = "Női börtönruha lánc drawable.",
                    label = "Lánc 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "A női börtöni ruházat lánc textúrája.",
                    label = "Lánc 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Női börtönruha matricák drawable.",
                    label = "Decal 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "A női börtöni ruházat decal textúrája.",
                    label = "Decal 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Női börtönruha szemüveg drawable (a -1 eltávolítja a szemüveget).",
                    label = "Szemüveg 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "A női börtöni ruházat szemüveg textúrája.",
                    label = "Szemüveg 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Női börtönruha sisak drawable.",
                    label = "Fejvédő 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "A női börtöni ruházat sisak textúrája.",
                    label = "Fejvédő 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Női börtönruha nadrág drawable.",
                    label = "Nadrág 1",
                },
                jailOutfitFemalePants2 = {
                    description = "A női börtöni ruházat nadrág textúrája.",
                    label = "Nadrág 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Női börtönruha cipő drawable.",
                    label = "Cipő 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "A női börtöni ruházat lábbeli textúrája.",
                    label = "Cipő 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Női börtönruha törzs drawable.",
                    label = "Törzs 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "A női börtöni ruházat törzs textúrája.",
                    label = "Törzs 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Női börtönruha póló drawable.",
                    label = "Póló 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Póló textúra a női börtönruhához.",
                    label = "Póló 2",
                },
                jailOutfitMaleArms = {
                    description = "Férfi börtönruha kar alkatrésze.",
                    label = "Karok",
                },
                jailOutfitMaleChain1 = {
                    description = "Lánc drawable a férfi börtönruhához.",
                    label = "Lánc 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Lánc textúra a férfi börtönruhához.",
                    label = "Lánc 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Decal drawable a férfi börtönruhához.",
                    label = "Decal 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Decal textúra a férfi börtönruhához.",
                    label = "Decal 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Szemüveg drawable a férfi börtönruhához (-1 eltávolítja a szemüveget).",
                    label = "Szemüveg 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Szemüveg textúra a férfi börtönruhához.",
                    label = "Szemüveg 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Védősisak drawable a férfi börtönruhához.",
                    label = "Fejvédő 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Védősisak textúra a férfi börtönruhához.",
                    label = "Fejvédő 2",
                },
                jailOutfitMalePants1 = {
                    description = "Nadrág drawable a férfi börtönruhához.",
                    label = "Nadrág 1",
                },
                jailOutfitMalePants2 = {
                    description = "Nadrág textúra a férfi börtönruhához.",
                    label = "Nadrág 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Lábbeli drawable a férfi börtönruhához.",
                    label = "Cipő 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Lábbeli textúra a férfi börtönruhához.",
                    label = "Cipő 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Törzs drawable a férfi börtönruhához.",
                    label = "Törzs 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Törzs textúra a férfi börtönruhához.",
                    label = "Törzs 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Póló drawable a férfi börtönruhához.",
                    label = "Póló 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Póló textúra a férfi börtönruhához.",
                    label = "Póló 2",
                },
                jailRemoveJobOnJail = {
                    description = "A börtönbe zárt fogvatartott munkanélkülivé tétele.",
                    label = "Állás törlése bebörtönzéskor",
                },
                jailRequireJailTerminal = {
                    description = "Csak a kiválasztott börtön termináljához közel engedélyezett a rendőr által kiszabott börtönbüntetés.",
                    label = "Börtön terminál szükséges",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "A fogvatartott eredeti állásának visszaállítása a szabadulás után. Tiltsa le, hogy munkanélküli maradjon.",
                    label = "Eredeti állás visszaállítása",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "A mentett civil ruházat visszaállítása, amikor egy fogoly kiszabadul.",
                    label = "Ruházat visszaállítása kiszabadulás esetén",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Kezelési ablak a visszaállítás után, mielőtt a spawn korrekció megszűnik érvényesülni.",
                    label = "Korrekciós ablak visszaállításhoz",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "A visszaállított fogoly teleportálása vissza a börtön spawnjába, ha a börtön zónáján kívül tölt be.",
                    label = "Visszaállított fogoly teleportálása",
                },
                jailTerminalRange = {
                    description = "A rendőr maximális távolsága a kiválasztott börtön termináljától.",
                    label = "Börtön terminál hatótávolsága",
                },
                jailZoneExitGraceMs = {
                    description = "A kegyelmi időszak, amely lejárta előtt a börtönzóna elhagyása nem minősül szökésnek.",
                    label = "Zónakilépési tolerancia",
                },
                mugshotAnimDict = {
                    description = "Animációs szótár, amelyet a letartóztatási fényképezés során használnak.",
                    label = "Animációs szótár",
                },
                mugshotAnimFlag = {
                    description = "Animációs jelző, amelyet a letartóztatási fényképezés során használnak.",
                    label = "Animációs jelző",
                },
                mugshotAnimName = {
                    description = "Animációs név, amelyet a letartóztatási fényképezés során használnak.",
                    label = "Animáció neve",
                },
                mugshotBoardHeader = {
                    description = "Főcím, amelyet a letartóztatási fényképtáblán jelenítenek meg.",
                    label = "Tábla-cím",
                },
                mugshotBoardSubheader = {
                    description = "Pótcím, amelyet a letartóztatási fényképtáblán jelenítenek meg.",
                    label = "Tábla-aláírás",
                },
                mugshotCameraCoordsX = {
                    description = "Kamera világkoordinátája (X) a letartóztatási fényképezéshez.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Kamera világkoordinátája (Y) a letartóztatási fényképezéshez.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Kamera világkoordinátája (Z) a letartóztatási fényképezéshez.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Látószög a letartóztatási fényképezéshez.",
                    label = "Kamera látószög",
                },
                mugshotCameraRotX = {
                    description = "Kamera X tengely körüli forgatása a letartóztatási fényképezéshez.",
                    label = "Forgatás X",
                },
                mugshotCameraRotY = {
                    description = "Kamera Y tengely körüli forgatása a letartóztatási fényképezéshez.",
                    label = "Forgatás Y",
                },
                mugshotCameraRotZ = {
                    description = "Kamera Z tengely körüli forgatása a letartóztatási fényképezéshez.",
                    label = "Forgatás Z",
                },
                mugshotCaptureTimeout = {
                    description = "A letartóztatási fényképezés visszahívási függvényeihez engedélyezett maximális millimásodperc.",
                    label = "Felvételi időkorlát",
                },
                mugshotEnabled = {
                    description = "Engedélyezi a letartóztatási fényképezést a börtönbevitel során.",
                    label = "Letartóztatási fényképezés",
                },
                mugshotHeading = {
                    description = "A letartóztatási fényképezés során alkalmazott irány.",
                    label = "Irány",
                },
                mugshotLocationX = {
                    description = "A letartóztatási fényképezéshez használt világkoordináta (X).",
                    label = "Helyszín X",
                },
                mugshotLocationY = {
                    description = "A letartóztatási fényképezéshez használt világkoordináta (Y).",
                    label = "Helyszín Y",
                },
                mugshotLocationZ = {
                    description = "A letartóztatási fényképezéshez használt világkoordináta (Z).",
                    label = "Helyszín Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Leírásformátum, amelyet a tárolt letartóztatási fényképek metaadataihoz használnak.",
                    label = "Metaadatok leírása",
                },
                mugshotMetadataName = {
                    description = "Inventár-metaadatok neve, amelyet a tárolt letartóztatási fényképhez használnak.",
                    label = "Metaadatok neve",
                },
                mugshotWaitMs = {
                    description = "Várakozási idő millimásodpercben a letartóztatási fénykép felvétele előtt.",
                    label = "Várakozási idő",
                },
                playerSearchAnimDict = {
                    description = "Animációs szótár, amelyet a játékosok átkutatása során használnak.",
                    label = "Animációs szótár",
                },
                playerSearchAnimFlag = {
                    description = "Animációs jelző, amelyet a játékosok átkutatása során használnak.",
                    label = "Animációs jelző",
                },
                playerSearchAnimName = {
                    description = "Animációs név, amelyet a játékosok átkutatása során használnak.",
                    label = "Animáció neve",
                },
                playerSearchDurationMs = {
                    description = "A játékos átkutatásának előnézetének időtartama millimásodpercben.",
                    label = "Átkutatás időtartama",
                },
                playerSearchEnabled = {
                    description = "Engedélyezi a játékos átkutatásának előnézeti munkafolyamatát.",
                    label = "Játékos átkutatása",
                },
                playerSearchRange = {
                    description = "Maximális távolság a játékos átkutatásának indításához.",
                    label = "Átkutatási hatótávolság",
                },
                playerSearchScenario = {
                    description = "Szenárió, amelyet akkor használnak, ha nincs lejátsszva explicit átkutatási animáció.",
                    label = "Átkutatási szcenárió",
                },
                policeBillingControl200 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Számlázás · ESCAPE",
                },
                policeBillingControl322 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Számlázás · ESCAPE",
                },
                policeEditorControl10 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · PAGEUP",
                },
                policeEditorControl11 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · PAGEDOWN",
                },
                policeEditorControl172 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · UP",
                },
                policeEditorControl173 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · DOWN",
                },
                policeEditorControl174 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BALRA",
                },
                policeEditorControl175 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · JOBBRA",
                },
                policeEditorControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                policeEditorControl191 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                policeEditorControl201 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Vissza",
                },
                policeEditorControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                policeEditorControl21 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL SHIFT",
                },
                policeEditorControl32 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · W",
                },
                policeEditorControl322 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · KILÉPÉS",
                },
                policeEditorControl33 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · S",
                },
                policeEditorControl34 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · A",
                },
                policeEditorControl35 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · D",
                },
                policeEditorControl36 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · BAL CTRL",
                },
                policeEditorControl37 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · TAB",
                },
                policeEditorControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · E",
                },
                policeEditorControl44 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · Q",
                },
                policeEditorControl73 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Szerkesztő · X",
                },
                policePrimaryColor = {
                    description = "A rendőri munkacsoport alapértelmezett színe.",
                    label = "Elsődleges szín",
                },
                primaryColor = {
                    description = "A rendőri munkacsoport alapértelmezett színe.",
                    label = "Elsődleges szín",
                },
                propPlacementConsumeItem = {
                    description = "Egy tárgyak eltávolítása az inventárból, amikor egy tárgyat elhelyeznek az inventárból.",
                    label = "Tárgy elhasználása",
                },
                propPlacementEnabled = {
                    description = "Engedélyezi a konfigurált rendőri tárgyak elhelyezését tárgyakból vagy járművekből.",
                    label = "Tárgy-elhelyezés",
                },
                propPlacementItemNames = {
                    description = "Prop modellek hozzárendelése inventáriumi tárgynevekhez a tárgy-alapú prop elhelyezéshez.",
                    label = "Tárgy-nevek",
                },
                propPlacementRequireOnDuty = {
                    description = "Csak szolgálatban lévő rendőrök helyezhetnek el konfigurált propokat.",
                    label = "Propokhoz szolgálat szükséges",
                },
                propPlacementReturnItem = {
                    description = "A tárgy visszaadása, amikor egy elhelyezett tárgyat eltávolítják.",
                    label = "Prop tárgy visszaadása",
                },
                propPlacementVehicleAccess = {
                    description = "Engedélyezi a munkahelyi járművek konfigurált prop felszerelésének megjelenítését.",
                    label = "Jármű prop hozzáférés",
                },
                radialEnabled = {
                    description = "Rendőri radiál akciók engedélyezése.",
                    label = "Rendőri radiálmenü",
                },
                radialHandcuffKeybindCommand = {
                    description = "A bilincs billentyűparancshoz regisztrált parancs neve.",
                    label = "Bilincs parancs",
                },
                radialHandcuffKeybindDescription = {
                    description = "A bilincs billentyűparancshoz megjelenített leírás.",
                    label = "Bilincs leírás",
                },
                radialHandcuffKeybindEnabled = {
                    description = "A közvetlen bilincs billentyűparancs engedélyezése.",
                    label = "Bilincs billentyűparancs",
                },
                radialHandcuffKeybindKey = {
                    description = "A közvetlen bilincs akcióhoz használt billentyűzet gomb.",
                    label = "Bilincs gomb",
                },
                radialKeybindsEnabled = {
                    description = "Közvetlen billentyűparancsok engedélyezése a kiválasztott radiál akciókhoz.",
                    label = "Közvetlen billentyűparancsok",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "A bilincslevétel billentyűparancshoz regisztrált parancs neve.",
                    label = "Bilincslevétel parancs",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "A bilincslevétel billentyűparancshoz megjelenített leírás.",
                    label = "Bilincslevétel leírás",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "A közvetlen bilincslevétel billentyűparancs engedélyezése.",
                    label = "Bilincslevétel billentyűparancs",
                },
                radialUnhandcuffKeybindKey = {
                    description = "A közvetlen bilincslevétel akcióhoz használt billentyűzet gomb.",
                    label = "Bilincslevétel gomb",
                },
                socialWorkAssignRange = {
                    description = "A szociális munkafeladatok kiosztásának maximális távolsága.",
                    label = "Helyezési távolság",
                },
                socialWorkDeadlineDefault = {
                    description = "Az alapértelmezett szociális munkához rendelhető határidő percben. A nulla érték letiltja a határidőket.",
                    label = "Alapértelmezett határidő",
                },
                socialWorkDeadlineMax = {
                    description = "A szociális munkához rendelhető maximális határidő percben. A nulla érték letiltja a felső korlátot.",
                    label = "Maximális határidő",
                },
                socialWorkDeadlineMin = {
                    description = "A szociális munkához rendelhető minimális határidő percben.",
                    label = "Minimális határidő",
                },
                socialWorkDefaultTasks = {
                    description = "Az alapértelmezett feladatok száma a szociális munkakiosztás megnyitásakor.",
                    label = "Alapértelmezett feladatok",
                },
                socialWorkEnabled = {
                    description = "A szociális munkakiosztás és feladatfolyamatok engedélyezése.",
                    label = "Szociális munka",
                },
                socialWorkImprisonmentJailId = {
                    description = "A börtön azonosító, amelyet akkor használnak, ha a szociális munkával kapcsolatos szabálysértések bebörtönzést vonnak maguk után.",
                    label = "Tartalék börtön azonosító",
                },
                socialWorkImprisonmentMonths = {
                    description = "Azok az hónapok, amelyek a szociális munkával kapcsolatos szabálysértések miatt járnak, ha azok bebörtönzést vonnak maguk után.",
                    label = "Bebörtönzés hónapjai",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "A rendőr neve, amelyet a szociális munkával kapcsolatos bebörtönzési bejegyzésekhez használnak.",
                    label = "Bebörtönzési rendőr neve",
                },
                socialWorkImprisonmentSolitary = {
                    description = "A szabálysértőket magánzárkába küldik, ha a bebörtönzés beindul.",
                    label = "Magánzárka használata",
                },
                socialWorkInactivityMinutes = {
                    description = "Percek, amíg a szociális munkával kapcsolatos inaktivitási büntetések hatályba lépnek.",
                    label = "Inaktivitási percek",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Feladatbüntetés, amely akkor lép életbe, ha egy szociális munkás túl hosszú ideig inaktív.",
                    label = "Inaktivitási feladatbüntetés",
                },
                socialWorkMaxTasks = {
                    description = "Választható szociális munkafeladatok maximális száma.",
                    label = "Maximális feladatok",
                },
                socialWorkMinTasks = {
                    description = "Választható szociális munkafeladatok minimális száma.",
                    label = "Minimum feladatok",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Engedélyezi a számlázást a regisztrált tulajdonosnak, még akkor is, ha a lefotózott rendszám hamisnak vagy klónnak van jelölve.",
                    label = "Gyanús hamis rendszámok engedélyezése",
                },
                speedCamProcessingMode = {
                    description = "Válasszon azonnali levonást, fizetést a beállított határidővel vagy kizárólag rendőri ellenőrzést.",
                    label = "Feldolgozási mód",
                    options = {
                        instant = "Azonnali levonás",
                        later = "Fizetés később (alapértelmezett)",
                        review = "Csak rendőri ellenőrzés",
                    },
                },
                speedCamAdvancedPageSize = {
                    description = "Maximális felvétel száma tablet oldalanként.",
                    label = "Átnézési oldal mérete",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Azok a járműoldalak, amelyek fotóit használhatja a rendszámfelismeréshez. Használja az elülsőt és/vagy a hátsót.",
                    itemLabel = "Oldal",
                    label = "Felismert oldalak",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Csak engedélyezés a sebességkamerás felvétel feltöltésének befejezése után.",
                    label = "Képi bizonyíték szükséges",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Boss Menü jogosultság szükséges a felvételek jóváhagyásához vagy elutasításához. 18 a Számlázás kezelése.",
                    label = "Átnézési jogosultság azonosító",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "A felvételek megtartása, ha a rendszám nincs jelen a regisztrált járműadatbázisban.",
                    label = "Nem regisztrált járművek tárolása",
                },
                speedCamBillingEnabled = {
                    description = "Automatikus számlák kiállítása, amikor sebességmérők megfelelő szabályszegést rögzítenek. A globális számlázási funkció bekapcsolva kell legyen.",
                    label = "Automatikus bírságok",
                },
                speedCamBillingExcludedJobs = {
                    description = "Azok a munkák, amelyek soha nem kapnak automatikus sebességmérő számlát.",
                    itemLabel = "Foglalkozás",
                    label = "Kizárt munkák",
                },
                speedCamBillingExcludedModels = {
                    description = "Azok a járműspawn nevek, amelyek soha nem kapnak automatikus sebességmérő-bírságot.",
                    itemLabel = "Modell",
                    label = "Kizárt járműmodellek",
                },
                speedCamBillingRules = {
                    description = "A sebességmérők által használt bírságrendeletek. A legpontosabban illeszkedő túllépési tartományt először számlázzák ki; ha nincs illeszkedő rendelet, a „Sebesség túllépése",
                    label = "Bírsági szabályok",
                },
                speedCamCameraEaseMs = {
                    description = "Az idő, amely alatt a nézet a sebességmérő szögébe áll. Alacsonyabb érték = rövidebb mozgás; túl alacsony érték eltolhatja a képet.",
                    label = "Kamera átmenet (ms)",
                },
                speedCamCameraFov = {
                    description = "A sebességmérő felvételekhez használt látómező.",
                    label = "Kamera látószög",
                },
                speedCamCheckIntervalMs = {
                    description = "A sebességmérő szkennelések közötti időmilliszekundumok.",
                    label = "Ellenőrzési időköz",
                },
                speedCamCooldownMs = {
                    description = "Az időmilliszekundumok, ameddig el kell telnie, mire ugyanaz a sebességmérő újra aktiválódhat.",
                    label = "Aktiválási késleltetés",
                },
                speedCamDamageCooldownMs = {
                    description = "Az időmilliszekundumok, ameddig el kell telnie, mire a sebességmérők által okozott kár újra alkalmazható.",
                    label = "Sérülési várakozási idő",
                },
                speedCamDamagePerHit = {
                    description = "A sebességmérőkre egy ütésenként okozott tartóssági kár.",
                    label = "Sérülés együttesen",
                },
                speedCamDamagedModelThreshold = {
                    description = "A maximális tartósság százaléka, amelynél vagy amely alatt a sérült modell jelenik meg. Példa: 50-es érték és 200-as maximális tartósság esetén 100-as tartósságnál vált.",
                    label = "Sérült modell küszöbe (%)",
                },
                speedCamDefaultLimit = {
                    description = "A sebességmérők alapértelmezett sebességkorlátja.",
                    label = "Alapértelmezett sebességkorlát",
                },
                speedCamDefaultName = {
                    description = "A kamera elhelyezésekor javasolt megjelenített név. Lefordítható az inventoryban lévő tárgy vagy az objektummodell módosítása nélkül.",
                    label = "Alapértelmezett név",
                },
                speedCamDefaultTolerance = {
                    description = "A sebességmérők alapértelmezett toleranciája.",
                    label = "Alapértelmezett tolerancia",
                },
                speedCamDisassembleDistance = {
                    description = "A sebességmérők szétszereléséhez használt távolság.",
                    label = "Szétbontási távolság",
                },
                speedCamEnabled = {
                    description = "Hordozható sebességmérők engedélyezése.",
                    label = "Sebességmérők",
                },
                speedCamFlashColor = {
                    description = "Az RGBA szín, amelyet a sebességmérők a villanásukhoz használnak.",
                    label = "Villanás színe",
                },
                speedCamFlashDurationMs = {
                    description = "A piros sebességmérő-villanás eltűnési ideje. Ne állítsd túl alacsonyra, különben a kamera mozgása láthatóvá válik.",
                    label = "Villanás időtartama (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Az a távolság, amelyen belül a sebességmérő állapotát jelenítjük meg.",
                    label = "Állapot megjelenítési távolság",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Az a időtartam (milliszekundumban), ameddig a sebességmérő állapotának megjelenítése látható.",
                    label = "Állapot megjelenítési időtartam",
                },
                speedCamHealthTextOffset = {
                    description = "A sebességkamerák állapotjelzéséhez használt függőleges eltolás.",
                    label = "Egészségi szöveg eltolása",
                },
                speedCamItem = {
                    description = "A tárgy pontos belső neve az inventoryban, például speedcam. A tárgy kulcsát add meg, ne a megjelenített nevét; a munkakör boltjának ugyanezt a tárgyat kell adnia.",
                    label = "Kamera tárgyneve",
                },
                speedCamMaintenanceThreshold = {
                    description = "Az a tartósságküszöb, amelyen a sebességkamera karbantartása javasolt.",
                    label = "Karbantartási küszöb",
                },
                speedCamMaxDurability = {
                    description = "A telepített sebességkamerák maximális tartóssága.",
                    label = "Max. tartósság",
                },
                speedCamMaxLimit = {
                    description = "A sebességkamerák konfigurálható maximális határa.",
                    label = "Maximális sebességkorlát",
                },
                speedCamMaxTolerance = {
                    description = "A sebességkamerák konfigurálható maximális toleranciája.",
                    label = "Max. tolerancia",
                },
                speedCamPhotoLocale = {
                    description = "Opcionális helyi beállítás a sebességkamera-fotók időbélyegéhez. Hagyd üresen, hogy a lefotózott játékos helyi beállítását használjuk.",
                    label = "Fénykép helyi beállítása",
                },
                speedCamPhotoTimeZone = {
                    description = "Az időbélyegre használt opcionális időzóna. Hagyja üresen, hogy a lefényképezett játékos helyi időzónáját használja.",
                    label = "Fénykép időzóna",
                },
                speedCamPoliceNotification = {
                    description = "Üzenetet küld a Dispatch-nek, amikor a sebességmérők jogsértést rögzítenek.",
                    label = "Sebességmérő rendőri figyelmeztetés",
                },
                speedCamPoliceNotificationGroup = {
                    description = "A sebességmérő Dispatch-célcsoportjának kezelése mint munkacsoport.",
                    label = "Dispatch-cél csoport",
                },
                speedCamPoliceNotificationJob = {
                    description = "A sebességmérő Dispatch-értesítésekhez használt munkacsoport vagy csoport kulcs.",
                    label = "Dispatch-cél",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Csak a szolgálatban lévő sebességmérő Dispatch-célok értesítése.",
                    label = "A Dispatch szolgálatot igényel",
                },
                speedCamPoliceNotificationType = {
                    description = "A sebességmérő figyelmeztetésekhez használt Dispatch-fokozat/típus.",
                    label = "Dispatch-típus",
                },
                speedCamPropModel = {
                    description = "Az ép kameraobjektum létrehozási neve, például sky_speedcam. Az előbeállítás a sérült és a megsemmisült modellt is kiválasztja. Az egyéni modelleknek elérhetőnek kell lenniük a játékban.",
                    label = "Sebességmérő Prop-modell",
                    custom = "Egyéni modell",
                    choose = "Modell kiválasztása",
                    preview = "3D előnézet",
                    customPlaceholder = "Prop spawn neve",
                    previewDescription = "A kiválasztott prop megjelenítése a játékban. Az előnézet nem ment.",
                    invalidModel = "Először adj meg egy érvényes prop nevet.",
                    modelMissing = "Ez a prop modell nem érhető el a játékban.",
                    previewFailed = "Nem sikerült megnyitni a modell előnézetét.",
                    intact = "Ép prop modell",
                    previewRequiresGame = "Nyisd meg a /jobconfig menüt FiveM-ben az élő előnézethez.",
                    previewHelp = "Nyilak: mozgatás; PageUp/PageDown: magasság; görgő: forgatás; Enter: bezárás; Backspace: mégse.",
                    options = {
                        sky_speedcam = "Alap sebességmérő",
                        sky_germ_speedcam = "Német sebességmérő",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "A sérült kameraobjektum létrehozási neve, például sky_speedcam2. Az ép modellhez illő változatot válassz.",
                    label = "Sérült Prop-modell",
                },
                speedCamPropModelDestroyed = {
                    description = "A 0 tartósságú kamerához megjelenített modell létrehozási neve, például sky_speedcam1. Az ép modellhez illő változatot válassz.",
                    label = "Megsemmisült Prop-modell",
                },
                speedCamRepairAnimDict = {
                    description = "A sebességmérők javításához használt Animációs szótár.",
                    label = "Javítási animációs szótár",
                },
                speedCamRepairAnimFlag = {
                    description = "A sebességmérők javításához használt Animációs jelző.",
                    label = "Javítási animációs jelző",
                },
                speedCamRepairAnimName = {
                    description = "A sebességmérők javításához használt Animáció neve.",
                    label = "Javítási animációs név",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Az idő, amely alatt a sebességmérő javítása megszakítható (milliszekundumban).",
                    label = "Javítás megszakításának késleltetése",
                },
                speedCamRepairDistance = {
                    description = "A sebességmérők javításához használt távolság.",
                    label = "Javítási távolság",
                },
                speedCamRepairItem = {
                    description = "A javításhoz használt tárgy pontos belső neve, például fixtool. A tárgy kulcsát add meg, ne a megjelenített nevét.",
                    label = "Javítási tárgy neve",
                },
                speedCamRepairPerTick = {
                    description = "A sebességmérő javításánként visszaállított tartósság.",
                    label = "Javítás ciklusonként",
                },
                speedCamRepairTickMs = {
                    description = "A sebességmérő javítási ciklusok közötti idő (milliszekundumban).",
                    label = "Javítási ciklus",
                },
                speedCamStreamDistance = {
                    description = "A játékostól mért távolság méterben, amelyen belül a kameraobjektumok betöltődnek. Ezen kívül az objektumok eltűnnek; a mentett kamerák a helyükön maradnak.",
                    label = "Stream távolság",
                },
                speedCamTriggerRadius = {
                    description = "A gyorshajtó járművek észlelési sugara méterben a kamera körül.",
                    label = "Kilöktető sugár",
                },
                speedCamUseMph = {
                    description = "A sebességmérő korlátok MPH-ben történő megjelenítése és feldolgozása.",
                    label = "MPH használata",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "A korlátozás engedélyezésekor azok a fegyverek, amelyek károsíthatják a sebességmérőket.",
                    itemLabel = "Fegyver",
                    label = "Engedélyezett fegyverek",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Csak a felsorolt fegyverek károsíthatják a sebességmérőket, ha ez engedélyezve van.",
                    label = "A korlátozás engedélyezve",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "A sebességmérő figyelmeztetések törléséhez használt távolság méterben.",
                    label = "Törlési távolság",
                },
                speedCameraAppDefaultApp = {
                    description = "A sebességmérő alkalmazás megjelenítése alapértelmezett tablet-alkalmazásként.",
                    label = "Alapértelmezett alkalmazás",
                },
                speedCameraAppDescription = {
                    description = "A sebességmérő tablet-alkalmazáshoz tartozó leírás.",
                    label = "Leírás",
                },
                speedCameraAppDeveloper = {
                    description = "A sebességmérő tablet-alkalmazáshoz tartozó fejlesztői felirat.",
                    label = "Fejlesztő",
                },
                speedCameraAppEnabled = {
                    description = "A rendőri tablet sebességmérő alkalmazásának engedélyezése.",
                    label = "Sebességmérő tablet-alkalmazás",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "A sebességmérő alkalmazásban megjelenítő fejléc felső szövege.",
                    label = "Fejléc felső szövege",
                },
                speedCameraAppHeaderTitle = {
                    description = "A sebességmérő alkalmazásban megjelenítő fejléc címe.",
                    label = "Fejléc címe",
                },
                speedCameraAppIcon = {
                    description = "Az ikonútvonal, amelyet a sebességmérő tablet alkalmazás használ.",
                    label = "Ikonútvonal",
                },
                speedCameraAppIdentifier = {
                    description = "A sebességmérő tablet alkalmazás belső azonosítója.",
                    label = "Azonosító",
                },
                speedCameraAppInFrontDot = {
                    description = "A sebességmérő előtti helyzet meghatározásához használt pontszorzó küszöbérték.",
                    label = "Előtti pontszorzó",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "A figyelmeztetések megjelenítéséhez szükséges minimális járműsebesség km/h-ban.",
                    label = "Minimális járműsebesség",
                },
                speedCameraAppName = {
                    description = "A sebességmérő tablet alkalmazás megjelenítési neve.",
                    label = "Alkalmazás neve",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "A távolság méterben, amelyig előre figyelmeztetni kell a közelgő sebességmérőkről.",
                    label = "Figyelmeztetési távolság",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Csak akkor figyelmeztet a sebességmérőkről, ha a játékos járműben van.",
                    label = "Csak járműben",
                },
                speedCameraAppOverlayBackground = {
                    description = "A rendszámkép felirat háttérszíne.",
                    label = "Felülírás háttér",
                },
                speedCameraAppOverlayBorder = {
                    description = "A rendszámkép felirat keretszíne.",
                    label = "Felülírás keret",
                },
                speedCameraAppOverlayColor = {
                    description = "A rendszámkép felirat szövegszíne.",
                    label = "Felülírás színe",
                },
                speedCameraAppOverlayEnabled = {
                    description = "A lefotózott sebességmérőképeken megjelenő rendszámkép felirat engedélyezése.",
                    label = "Felülírás engedélyezve",
                },
                speedCameraAppOverlayFontScale = {
                    description = "A lemezképfelülírás betűméret-skálázása.",
                    label = "Felülírás betűméret-skálázása",
                },
                speedCameraAppOverlayX = {
                    description = "A balról jobbra haladó normalizált felülírás X pozíciója.",
                    label = "Réteg X",
                },
                speedCameraAppOverlayY = {
                    description = "A felülről lefelé haladó normalizált felülírás Y pozíciója.",
                    label = "Réteg Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Csak akkor figyelmeztet, ha a sebességmérő a játékos előtt van.",
                    label = "Előtli elvárás",
                },
                speedCameraAppRoute = {
                    description = "Az útvonalítóútvonal, amelyet a sebességmérő tablet alkalmazás megnyit.",
                    label = "Útvonal",
                },
                speedCameraAppSize = {
                    description = "A sebességmérő tablet alkalmazás által jelentett tárhelyméret.",
                    label = "Alkalmazás mérete",
                },
                speedCameraAppSoundCoord = {
                    description = "A sebességmérő figyelmeztetőhangok lejátszása világkoordinátákon.",
                    label = "Koordinátahang",
                },
                speedCameraAppSoundEnabled = {
                    description = "A sebességmérő alkalmazás figyelmeztetőhangjainak engedélyezése.",
                    label = "Hang engedélyezve",
                },
                speedCameraAppSoundFrontend = {
                    description = "A sebességmérő figyelmeztetőhangok lejátszása a frontend hangcsatornán.",
                    label = "Frontend hang",
                },
                speedCameraAppSoundLayers = {
                    description = "A sebességmérő alkalmazás által lejátszott rétegzett figyelmeztetőhangok száma.",
                    label = "Hangrétegek",
                },
                speedCameraAppSoundName = {
                    description = "A sebességmérő alkalmazás figyelmeztetéseihez használt hangnév.",
                    label = "Hangnév",
                },
                speedCameraAppSoundRange = {
                    description = "A sebességmérő alkalmazás figyelmeztetőhangjainak tartománya.",
                    label = "Hangtartomány",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "A sebességmérő figyelmeztetőhang ismétlésszáma.",
                    label = "Ismétlés száma",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "A sebességmérő figyelmeztetőhang ismétlései közötti millimásodpercek száma.",
                    label = "Ismétlés késleltetése",
                },
                speedCameraAppSoundSet = {
                    description = "A sebességmérő alkalmazás figyelmeztetéseihez használt hangkészlet.",
                    label = "Hangkészlet",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "A tablet sebességkamerás alkalmazás előfizetésének fizetéseinek kiszolgálásához használt fiók.",
                    label = "fiók",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Engedélyezi a tablet sebességkamerás alkalmazás fizetős előfizetését.",
                    label = "Az előfizetés engedélyezve",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "A tablet sebességkamerás alkalmazás előfizetésének újrakezdésének időköze napokban.",
                    label = "Időköz (nap)",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "A tablet sebességkamerás alkalmazás előfizetésének díja.",
                    label = "Előfizetési díj",
                },
                speedCameraAppThemeAccent = {
                    description = "A sebességkamerás alkalmazás által használt hangsúlyozó szín.",
                    label = "Kiemelés",
                },
                speedCameraAppThemeBackground = {
                    description = "A sebességkamerás alkalmazás által használt lineáris gradiens háttér.",
                    label = "Háttér",
                },
                speedCameraAppThemeBorder = {
                    description = "A sebességkamerás alkalmazás által használt keret színe.",
                    label = "Keret",
                },
                speedCameraAppThemeButtonText = {
                    description = "A sebességkamerás alkalmazás által használt gomb szövegszíne.",
                    label = "Gomb szöveg",
                },
                speedCameraAppThemeDanger = {
                    description = "A sebességkamerás alkalmazás által használt veszély színe.",
                    label = "Veszély",
                },
                speedCameraAppThemeGhost = {
                    description = "A sebességkamerás alkalmazás által használt átlátszó gomb színe.",
                    label = "Szellem",
                },
                speedCameraAppThemeGhostText = {
                    description = "A sebességkamerás alkalmazás által használt átlátszó szöveg színe.",
                    label = "Átlátszó szöveg",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "A sebességkamerás alkalmazás által használt lágy gradiens szín.",
                    label = "Lágy gradiens",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "A sebességkamerás alkalmazás által használt inaktív keret színe.",
                    label = "Inaktív keret",
                },
                speedCameraAppThemeModal = {
                    description = "A sebességkamerás alkalmazás által használt modális ablak háttér színe.",
                    label = "Modális",
                },
                speedCameraAppThemeMutedText = {
                    description = "A sebességkamerás alkalmazás által használt sötétített szöveg színe.",
                    label = "Sötétített szöveg",
                },
                speedCameraAppThemeOverlay = {
                    description = "A sebességkamerás alkalmazás által használt átfedő réteg színe.",
                    label = "Réteg",
                },
                speedCameraAppThemePillText = {
                    description = "A sebességkamerás alkalmazás által használt kapszula szöveg színe.",
                    label = "Kapszula szöveg",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "A sebességkamerás alkalmazás által használt elsődleges gradiens kezdő színe.",
                    label = "Elsődleges kezdő",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "A sebességkamerás alkalmazás által használt elsődleges gradiens vég színe.",
                    label = "Elsődleges vég",
                },
                speedCameraAppThemeShadow = {
                    description = "A sebességkamerás alkalmazás által használt árnyék színe.",
                    label = "Árnyék",
                },
                speedCameraAppThemeSpotlight = {
                    description = "A sebességkamerás alkalmazás által használt reflektor hangsúlyozó színe.",
                    label = "Fény",
                },
                speedCameraAppThemeSubtleText = {
                    description = "A sebességkamerás alkalmazás által használt finom szöveg színe.",
                    label = "Finom szöveg",
                },
                speedCameraAppThemeSuccess = {
                    description = "A sebességkamerás alkalmazás által használt siker színe.",
                    label = "Siker",
                },
                speedCameraAppThemeSurface = {
                    description = "A sebességkamerás alkalmazás által használt felület színe.",
                    label = "Felület",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "A sebességkamerás alkalmazás által használt lágy felület színe.",
                    label = "Lágy felület",
                },
                speedCameraAppThemeText = {
                    description = "A sebességkamerás alkalmazás által használt elsődleges szöveg színe.",
                    label = "Szöveg",
                },
                speedCameraAppWarningUiAccent = {
                    description = "RGBA hangsúlyozó szín a sebességkamerás figyelmeztető felület számára.",
                    label = "Kiemelés RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "RGBA szín a sebességkamerás figyelmeztető felület háttérének számára.",
                    label = "Háttér RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "RGBA ikon szín a sebességkamerás figyelmeztető felület számára.",
                    label = "Ikon RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "RGBA ikon szöveg színe a sebességkamerás figyelmeztető felület számára.",
                    label = "Icon szöveg RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "A figyelmeztető felület láthatóságának időtartama (másodpercben).",
                    label = "Figyelmeztető felület időtartama",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Az RGBA alapszövegszín, amelyet a sebességkamera figyelmeztető felület használ.",
                    label = "Alapszöveg RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Az RGBA szövegszín, amelyet a sebességkamera figyelmeztető felület használ.",
                    label = "Szöveg RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Az RGBA címszín, amelyet a sebességkamera figyelmeztető felület használ.",
                    label = "Cím RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "A tüskeszalagok közelségének ellenőrzései közötti idő (milliszekundumban).",
                    label = "Ellenőrzési időköz",
                },
                spikeStripsEnabled = {
                    description = "Az elhelyezett tüskeszalagok engedélyezése.",
                    label = "Tüskeszalagok",
                },
                spikeStripsModels = {
                    description = "A tüskeszalagként kezelt tárgymodellek.",
                    itemLabel = "Modell",
                    label = "Modellek",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Az idő (milliszekundumban), ameddig a tüskeszalag-keresés újrapróbálkozása nem történik, ha nincs találat.",
                    label = "Újrapróbálkozási intervallum",
                },
                spikeStripsScanDistance = {
                    description = "A tüskeszalagok keresésére használt távolság.",
                    label = "Keresési távolság",
                },
                spikeStripsTriggerDistance = {
                    description = "A távolság, amelyen a tüskeszalag felrobbantja a kereket.",
                    label = "Kiváltási távolság",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "A kategória címkéje, amelyet az állomás-alkotó jelzőkre használnak.",
                    label = "Állomás jelző kategória",
                },
                stationCreatorBlipColor = {
                    description = "A rendőrállomásokhoz használt térképi jelző színe.",
                    label = "Állomás jelző színe",
                },
                stationCreatorBlipScale = {
                    description = "A rendőrállomás jelzőkre használt méretarány.",
                    label = "Állomás jelző méretaránya",
                },
                stationCreatorBlipShortRange = {
                    description = "Csak rövid hatótávolságon jelenítsen meg állomás jelzőket.",
                    label = "Állomás jelző rövid hatótávolság",
                },
                stationCreatorBlipSprite = {
                    description = "A rendőrállomásokhoz használt térképi jelző sprite.",
                    label = "Állomás jelző sprite",
                },
                stationCreatorBlipUseStationName = {
                    description = "A konfigurált állomásnevet használja a térképi jelző címkéjéhez.",
                    label = "Állomásnevet használ",
                },
                tabletAutoFillCitizens = {
                    description = "A polgárok nyilvántartása előtöltése a keretrendszer adatbázisából.",
                    label = "Polgárok előtöltése",
                },
                tabletAutoFillVehicles = {
                    description = "A járművek nyilvántartása előtöltése a keretrendszer adatbázisából.",
                    label = "Járművek előtöltése",
                },
                tabletBolos = {
                    description = "A BOLO alkalmazás megjelenítése.",
                    label = "BOLO-k",
                },
                tabletCases = {
                    description = "A fájlok alkalmazás megjelenítése.",
                    label = "Ügyek",
                },
                tabletCitizens = {
                    description = "A polgárok nyilvántartása alkalmazás megjelenítése.",
                    label = "Polgárok",
                },
                tabletConfiscations = {
                    description = "A játékosok átkutatása során elkobzott tárgyak naplójának megjelenítése.",
                    label = "Elkobzások",
                },
                tabletOffences = {
                    description = "A szabályszegések alkalmazás megjelenítése.",
                    label = "Bűncselekmények",
                },
                tabletPrison = {
                    description = "A börtön alkalmazás megjelenítése.",
                    label = "Börtön",
                },
                tabletReportEnforcement = {
                    description = "Engedélyezi a tisztek számára, hogy szabályszegéseket rendeljenek gyanúsítottakhoz, és pénzbírságot vagy börtönbüntetést rendeljenek el a mentett jelentésekből.",
                    label = "Jelentés végrehajtás",
                },
                tabletReports = {
                    description = "A jelentések alkalmazás megjelenítése.",
                    label = "Jelentések",
                },
                tabletSocialWork = {
                    description = "A szociális munka alkalmazás megjelenítése.",
                    label = "Szociális munka",
                },
                tabletSpeedcamReviews = {
                    description = "A haladó sebességkamerás átnézési alkalmazás megjelenítése, ha a haladó mód engedélyezve van.",
                    label = "Sebességkamerás átnézés",
                },
                tabletVehicles = {
                    description = "A járművek nyilvántartása alkalmazás megjelenítése.",
                    label = "Járművek",
                },
                tabletWarrants = {
                    description = "A letartóztatási parancsok alkalmazás megjelenítése.",
                    label = "Hajthatóságok",
                },
                tabletWeapons = {
                    description = "A fegyverek nyilvántartása alkalmazás megjelenítése.",
                    label = "Fegyverek",
                },
                tackleCommand = {
                    description = "Parancs a legközelebbi személy lehozására. Adja meg a parancsnevet a / jel nélkül.",
                    label = "Lehozás parancs",
                },
                tackleCuffCommand = {
                    description = "Parancs a legközelebbi személy bilincselésére a lehozás után. Adja meg a parancsnevet a / jel nélkül.",
                    label = "Lehozás bilincselési parancs",
                },
                tackleCuffDescription = {
                    description = "Leírás a lehozás bilincseléséhez a FiveM billentyűparancsok menüjében.",
                    label = "Lehozás bilincselési billentyűparancs leírása",
                },
                tackleCuffKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Földre vett személy bilincselése",
                },
                tackleDescription = {
                    description = "Leírás a lehozáshoz a FiveM billentyűparancsok menüjében.",
                    label = "Lehozás billentyűparancs leírása",
                },
                tackleEnabled = {
                    description = "Engedélyezi a legközelebbi személy lehozását és a földön tartását.",
                    label = "Lehozás",
                },
                tackleKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tackolás",
                },
                tackleMaxDistance = {
                    description = "Maximális távolság a célig a lehozás indításakor.",
                    label = "Lehozás távolsága",
                },
                tackleNeedsSprint = {
                    description = "A rendőrnek futnia kell a lehozás előtt.",
                    label = "Lehozás futást igényel",
                },
                tackleReleaseCommand = {
                    description = "Parancs a lehozott személy elengedéséhez. Adja meg a parancsnevet a / jel nélkül.",
                    label = "Lehozás elengedési parancs",
                },
                tackleReleaseDescription = {
                    description = "Leírás a lehozás elengedéséhez a FiveM billentyűparancsok menüjében.",
                    label = "Lehozás elengedési billentyűparancs leírása",
                },
                tackleReleaseKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tackolt személy elengedése",
                },
                tackleRequireOnDuty = {
                    description = "A rendőrnek szolgálatban kell lennie, mielőtt lehozhat egy személyt.",
                    label = "Lehozás szolgálatot igényel",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Az idő, amíg a következő radarfigyelmeztetés megjelenhet.",
                    label = "Figyelmeztetés-hűtőidő",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "A radar használatára jogosult járműosztályok.",
                    label = "Engedélyezett járműosztályok",
                },
                vehicleRadarAutoFastLock = {
                    description = "Automatikus jelzés a nagyon gyors célokra a radaron.",
                    label = "Automatikus gyorszárasítás",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "A gyorszárasításhoz használt sebességhatár.",
                    label = "Gyorszárasítási határérték",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Parancs a radar elrendezés szerkesztőjének megnyitásához vagy bezárásához. Adja meg a parancsnevet a / jel nélkül.",
                    label = "Radar elrendezés parancs",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Határérték csökkentése",
                },
                vehicleRadarDefaultLimit = {
                    description = "A járműradar alapértelmezett sebességhatára.",
                    label = "Alapértelmezett radarhatár",
                },
                vehicleRadarEnabled = {
                    description = "A járőrjármű radarjának engedélyezése.",
                    label = "Járműradar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Határérték növelése",
                },
                vehicleRadarLimitStep = {
                    description = "A radarhatárérték változása minden beállításkor.",
                    label = "Határérték-lépés",
                },
                vehicleRadarLockFrontKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Elülső zárolás",
                },
                vehicleRadarLockRearKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Hátsó zárolás",
                },
                vehicleRadarMaxLimit = {
                    description = "A járműradarban engedélyezett maximális sebességhatár.",
                    label = "Maximális radarhatár",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "A radar célzásához engedélyezett maximális dőlésszög.",
                    label = "Maximális dőlésszög",
                },
                vehicleRadarMinLimit = {
                    description = "A járműradarban engedélyezett minimális sebességhatár.",
                    label = "Minimális radarhatár",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "A minimális sebesség, amelynél a radar érvényes célt észlel.",
                    label = "Minimális célssebesség",
                },
                vehicleRadarModeFrontKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Elülső mód",
                },
                vehicleRadarModeRearKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Hátsó mód",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Az idő a jármű mozgása közbeni radarfelmérések között.",
                    label = "Mozgás közbeni felmérésintervallum",
                },
                vehicleRadarPassengerControl = {
                    description = "A utasok számára engedélyezett járműradar-vezérlés.",
                    label = "Utas vezérlés",
                },
                vehicleRadarPassengerEnabled = {
                    description = "A utasok számára engedélyezett tükörképezett radaradatok megtekintése.",
                    label = "Utas tükrözés",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Az idő a utasok számára készült radar-szinkronizálások között.",
                    label = "Utas szinkronizálási intervallum",
                },
                vehicleRadarProjectionThreshold = {
                    description = "A radarcélok értékeléséhez használt projekciós határérték.",
                    label = "Projekciós határérték",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Tiszta látóvonal szükségessége a radar zárolása előtt.",
                    label = "Látóvonal szükségessége",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Szolgálati állapot szükségessége a járműradar használatához.",
                    label = "A radar szolgálatot igényel",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Parancs az alapértelmezett radar elrendezés helyreállításához. Adja meg a parancsnevet a / jel nélkül.",
                    label = "Radar elrendezés visszaállítása parancs",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Az idő a álló jármű radarfelmérései között.",
                    label = "Felmérésintervallum",
                },
                vehicleRadarScanRadius = {
                    description = "A járműradar felmérési sugara.",
                    label = "Felmérési sugár",
                },
                vehicleRadarToggleKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Kapcsoló",
                },
                vehicleRadarUseMph = {
                    description = "A radar sebességértékeinek MPH-ben való megjelenítése.",
                    label = "A radar MPH-ben használ",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "A közelben lévő járművek tárolójának frissítések közötti idő (milliszekundban).",
                    label = "Járműtároló frissítése",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Elülső küldés/tartás",
                },
                vehicleRadarXmitRearKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Radar: Hátsó küldés/tartás",
                },
                wheelClampConsumeItem = {
                    description = "A kerékcsavarzó tárgy eltávolítása elhelyezése után.",
                    label = "Csavarzó tárgy felhasználása",
                },
                wheelClampEnabled = {
                    description = "A kerékcsavarzó funkció engedélyezése.",
                    label = "Kerékzár alkalmazása",
                },
                wheelClampItem = {
                    description = "A kerékcsavarzó elhelyezéséhez használt tárgyatartó elem.",
                    label = "Csavarzó tárgy",
                },
                wheelClampPropModel = {
                    description = "Az elhelyezett kerékcsavarzóhoz használt prop-modell.",
                    label = "Csavarzó prop-modell",
                },
                wheelClampRequireItem = {
                    description = "A beállított kerékcsavarzó tárgy megkövetelése. Engedélyezve kell hagyni, ha a használati mód az Inventár vagy Mindkettő.",
                    label = "A kerékcsavarzó tárgy megkövetelése",
                },
                wheelClampRequireOnDuty = {
                    description = "A kerékcsavarzó elhelyezése előtt a szolgálati állapot megkövetelése.",
                    label = "A kerékcsavarzó szolgálatot követel meg",
                },
                wheelClampTyreDistance = {
                    description = "A maximális távolság a kerektől a kerékcsavarzó elhelyezése vagy hegesztése közben.",
                    label = "Kerék távolsága",
                },
                wheelClampUseItem = {
                    description = "A kerékcsavarzó elhelyezéséhez használható a sugárirányú menü, az inventár vagy mindkettő. Az Inventár vagy Mindkettő beállítást a Kerékcsavarzó tárgy megkövetelése opcióval kell párosítani.",
                    label = "Kerékcsavarzó használati mód",
                    options = {
                        both = "Mindkettő",
                        inventory = "Inventár",
                        radial = "Kerékmenü",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "A maximális távolság a célcélú járműhöz a kerékcsavarzó elhelyezése közben.",
                    label = "Jármű távolság",
                },
                wheelClampWeldBurstTyre = {
                    description = "A kerék felrobbantása, miután a kerékcsavarzót elhegesztették.",
                    label = "Kerék felrobbantása",
                },
                wheelClampWeldDurationMs = {
                    description = "A kerékcsavarzó hegesztéssel történő eltávolításához szükséges idő (milliszekundban).",
                    label = "Hegesztési időtartam",
                },
                wheelClampWeldEnabled = {
                    description = "A kerékcsavarzók hegesztővel történő eltávolításának engedélyezése.",
                    label = "Kerékcsavarzó hegesztése",
                },
                wheelClampWeldItem = {
                    description = "A kerékcsavarzó hegesztéséhez szükséges tárgyatartó elem.",
                    label = "Hegesztő tárgy",
                },
                wheelClampWeldMinigame = {
                    description = "A kerékcsavarzó eltávolításának befejezése előtt a hegesztő minijáték megkövetelése.",
                    label = "Hegesztő minijáték",
                },
                ziptiesConsumeItem = {
                    description = "Egy ziptie tárgy eltávolítása, amikor az fel van alkalmazva.",
                    label = "Ziptie tárgyak felhasználása",
                },
                ziptiesCutterConsumeItem = {
                    description = "A ziptie-ek levágása után a vágó tárgy eltávolítása.",
                    label = "Vágó tárgy felhasználása",
                },
                ziptiesCutterEnabled = {
                    description = "A ziptie-ek levágásának engedélyezése drótsérrel.",
                    label = "Ziptie vágó",
                },
                ziptiesCutterItem = {
                    description = "A ziptie-ek levágásához használt tárgyatartó elem.",
                    label = "Vágó tárgy",
                },
                ziptiesEnabled = {
                    description = "A ziptie funkciók engedélyezése.",
                    label = "Plasztik bilincs",
                },
                ziptiesItem = {
                    description = "A ziptie funkciókhoz használt tárgyatartó elem.",
                    label = "Ziptie tárgy",
                },
                ziptiesRequireHandsUp = {
                    description = "A ziptie-ek felhelyezése előtt a kézfogás megkövetelése.",
                    label = "Ziptie-ekhez kézfogás",
                },
                ziptiesRequireItem = {
                    description = "A beállított ziptie tárgy megkövetelése.",
                    label = "Ziptie-ek tárgyat követelik meg",
                },
                ziptiesReturnOnRemove = {
                    description = "Egy ziptie tárgy visszaadása, amikor a ziptie-ek eltávolításra kerülnek.",
                    label = "Zipties visszaadása",
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
                cuffsConsumeRequiresItem = "A bilincsek fogyasztása nem hat, ha a bilincs tárgy követelménye letiltva van.",
                wheelClampUseItemRequiresItem = "A Clamp használati módja (Inventár vagy Mindkettő) megköveteli, hogy a Clamp tárgy követelménye aktív maradjon.",
                ziptiesConsumeRequiresItem = "A plasztik bilincsek fogyasztása nem hat, ha a plasztik bilincs tárgy követelménye letiltva van.",
            },
            locationDescriptions = {
                jail_public_blip = "A hely automatikusan a börtön spawnjából, vagy ha nincs beállítva spawn, az első börtön terminálból kerül kiválasztásra.",
            },
        },
    },
}
