JobConfigLocales["sky_mechanicjob:hu"] = {
    Nui = {
        workshopConfig = {
            advancedPricingPreview = {
                compact = "Honda / Kompakt",
                customer = "Ár",
                description = "Példa kozmetikai számítás a jelenlegi szabályok alapján.",
                labor = "Munkadíj",
                live = "Élő előnézet",
                margin = "Haszon",
                sports = "Sportautó",
                super = "Superautó",
                supplier = "Beszállító",
                title = "Ár előnézet",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Konfigurálja a mechanikus munkahelyeket, üzleteket, járműveket és műhelyhelyszíneket.",
                    title = "Mechanikus Munkahelyek",
                },
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Mobil dinamométer telepítése",
                    entryPluralLabel = "Mobil dinamométer telepítések",
                    label = "Mobil dinamométer telepítések",
                },
                workshops = {
                    entryLabel = "Műhely",
                    entryPluralLabel = "Műhelyek",
                    label = "Műhelyek",
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
            diagnosticsSettings = {
                enabledLabel = "Járműdiagnosztika engedélyezése",
                enabledDescription = "Engedélyezi ennek a munkának a járműdiagnosztika megnyitását és az alkatrészek javítását azon keresztül.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Járműdiagnosztika",
                    description = "A munka járműdiagnosztikai hozzáférésének beállítása.",
                },
                billingPrices = {
                    description = "Konfigurálja a karbantartási és javítási előzménybejegyzések számlázási árát. A cselekvési kulcs a action_key, action_type vagy a munkajelölés ellenőrzésével egyeztet.",
                    label = "Számlázási árak",
                },
                billingSettings = {
                    description = "Konfigurálja ezt a munkahely mechanikus számlázási viselkedését.",
                    label = "Számlázás",
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
                partsDeliveryShop = "Részlethozzáállítási üzlet",
                trainingSettings = {
                    description = "Konfigurálja az oktatási hozzáférést, regisztrációt, jóváhagyásokat és tanfolyamtervezést ehhez a munkahelyhez.",
                    label = "Oktatási beállítások",
                },
                tuningCostProfile = {
                    description = "Konfigurálja ezt a munkahely teljesítmény-, megjelenés-, kerék- és speciális opciók költségeit. A költségek támogatják a szükséges elem-tömböket és a fokozatban lévő frissítési objektumokat.",
                    label = "Tuning Árak",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Szabad kamera a tuningmenüben",
                    description = "Engedélyezi a kurzor elrejtését a szóközzel a kamera szabad mozgatásához. Az Escape továbbra is bezárja a menüt.",
                },
                tuningCamera = {
                    description = "Automatikusan a kiválasztott alkatrészre irányítja a kamerát. Kikapcsolva a normál játékkamera marad aktív.",
                    label = "Automatikus tuningkamera",
                },
                jgMileage = {
                    description = "A JG Vehicle Mileage használata, amíg az erőforrás fut. Egyébként a Sky kilométeradatait használja. A JG HUD külön állítható be.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "A kiválasztott kilométeradat megjelenítése a JG HUD-ban. JG Vehicle Mileage nélkül is működik; telepítsd a HUD-adaptert a README alapján.",
                    label = "JG HUD",
                },
                antiLag = {
                    description = "Engedélyezi az anti-lag telepítést és a kipufogóeffekteket.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Engedélyezi a fokozatos fékmelegedést, a izzó korongokat, a kritikus szikrákat és a rövid fékcsökkenést.",
                    label = "Fékmelegedés",
                },
                carryItems = {
                    description = "A szállított alkatrészeket a műhelyen keresztül kell szállítani.",
                    label = "Fizikai Részletek Kezelése",
                },
                customHandling = {
                    description = "Engedélyezi a testreszabott hajtáslánc- és kezelhetőség-tuningot.",
                    label = "Testreszabott Kezelhetőség",
                },
                electronicTuning = {
                    description = "Engedélyezi a tartós ECU-, világítás- és vezető-asszisztens tuning opciókat.",
                    label = "Elektronikus Tuning",
                },
                handlingEditor = {
                    description = "Az admin szerkesztő és az automatikus szabályok engedélyezése a rendszámok és járműmodellek számára. A kikapcsolás után az érintett járművek újjáélesztése szükséges a már alkalmazott értékek visszaállításához.",
                    label = "Járműkezelés-szerkesztő",
                },
                instantTuning = {
                    description = "Lehetővé teszi a közvetlen tuningot a konfigurált nyilvános tuninghelyeken.",
                    label = "Azonnali Tuning",
                },
                kuv = {
                    description = "A technikai vizsgálatok engedélyezése a mechanikusok és rendőrök számára. A kikapcsolás elrejti a kapcsolódó cselekvéseket, és megőrzi a meglévő feljegyzéseket.",
                    label = "Jármű műszaki vizsgálata",
                },
                mileageHud = {
                    description = "Jármű kilométeróra-információ megjelenítése vezetés közben.",
                    label = "Kilométer HUD",
                },
                mobileDyno = {
                    description = "A helyhez rögzíthető fejlett mobil dinamométer, a fizikai vezérlő és eredménykijelző, a ventilátorvezérlő és a tablet alkalmazás engedélyezése.",
                    label = "Mobilizációs dinamó",
                },
                nitro = {
                    description = "Engedélyezi a nitro telepítését és a jármű boost használatát.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Engedélyezi a műhelyi alkatrész-szállítási rendeléseket és a kiszállítási zónákat.",
                    label = "Alkatrészek szállítása",
                },
                selfServiceOrderNotifications = {
                    description = "Értesíti a szolgálatban lévő alkalmazottakat, ha önálló tuningrendelés kerül létrehozásra.",
                    label = "Önálló rendelés értesítések",
                },
                stance = {
                    description = "A Stance beállítások megjelenítése minden tuningmenüben és a Stance Kit elem engedélyezése.",
                    label = "Stance",
                },
                stanceWheelSize = {
                    description = "A kerék méretének beállításainak megjelenítése, mentése és alkalmazása a Stance-ben.",
                    label = "Stance kerékméret",
                },
                stanceWheelWidth = {
                    description = "A kerék szélességének beállításainak megjelenítése, mentése és alkalmazása a Stance-ben.",
                    label = "Stance kerékszélesség",
                },
                subscriptions = {
                    description = "Engedélyezi a műhelyi előfizetési terminálokat, az előfizetés-kezelést és az ügyfélek kedvezményeit.",
                    label = "Műhely előfizetések",
                },
                twoStep = {
                    description = "Engedélyezi a kétlépéses indításkontrollt és a kipufogóeffekteket.",
                    label = "Kétlépcsős",
                },
                vehicleMaintenanceNotifications = {
                    description = "Értesítse a tulajdonosokat, amikor járművük eléri a beállított karbantartási küszöbértéket.",
                    label = "Jármű-karbantartási értesítések",
                },
                vehicleRegistration = {
                    description = "A járműjegyzékezés engedélyezése a mechanikusok és rendőrök számára, függetlenül a technikai vizsgálatoktól.",
                    label = "Járműbejegyzés",
                },
                wheelDamage = {
                    description = "Valósághű keréksérülések és javítások engedélyezése.",
                    label = "Keréksérülés",
                },
                workshopLift = {
                    description = "A műhelyekben konfigurált, használható emelőpontok engedélyezése.",
                    label = "Műhely emelő",
                },
            },
            fields = {
                quantity = "Mennyiség",
            },
            locationDescriptions = {
                vehicle_registry = "Helyezd a pontot a műhely vizsgálati öblébe. A járműnek a beállított vizsgálati távolságon belül kell lennie a technikai vizsgálatokhoz és a járműjegyzékezéshez.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "A dinamométer eredmények monitorának elhelyezkedése.",
                    label = "Dinamométer eredmények monitora",
                },
                mobile_dyno_station = {
                    description = "A mobil dinamométer állomás elhelyezkedése.",
                    label = "Mobil dinamométer állomás",
                },
                vehicle_registry = "Járművizsgálati és -bejegyzési pont",
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
            settingFieldDescriptions = {
                radialEnabled = "Mechanikus számlázás megnyitása a radiális menüből.",
                allowTuningInvoices = "Küldje a tuning kosarat a legközelebbi ügyfélnek. A telepítés a teljes kifizetés után nyílik meg.",
                customerRange = "Maximális távolság méterben a közeli ügyfelek számlázásához.",
                allowAnalytics = "Számlázási elemzések engedélyezése, hacsak egy rangszabály nem felülírja.",
                allowCustomPrices = "Engedélyezze a mechanikusoknak a számlapozíciók árainak módosítását a kiállítás előtt.",
                allowEstimates = "Engedélyezze az árajánlatokat, amelyeket az ügyfeleknek a kifizetés előtt el kell fogadniuk.",
                allowImmediatePayment = "Engedélyezze, hogy ennek a munkának a számláit közvetlenül fizethessék ki.",
                allowManualItems = "Engedélyezze a mechanikusoknak a tetszőleges számlapozíciók létrehozását.",
                allowPartialPayments = "Engedélyezze az előlegeket és a több részletre történő fizetést egyetlen számlára.",
                analyticsPeriodDays = "Napok száma a számlázási elemzésben.",
                defaultDueDays = "Napok, amíg egy számla lejárttá válik.",
                depositPercent = "Kötelező előleg százaléka a számla kiállítása vagy az árajánlat elfogadása után.",
                enabled = "Engedélyezze, hogy ez a munkahely használja a mechanikus számlázást.",
                estimateLifetimeHours = "Órák száma, amíg egy megválaszolatlan árajánlat lejár.",
                gradeRules = "Számlakorlátok és minden mechanikai rang számára elérhető műveletek.",
                maxDiscountPercent = "A számla által kapható legnagyobb kedvezmény.",
                maximumInvoiceAmount = "Globális maximális összeg a rangkorlátok előtt.",
                maximumManualItems = "Maximális tetszőleges pozíciók száma dokumentumonként.",
                maximumReminders = "Maximális emlékeztetők száma számlánként.",
                minimumInvoiceAmount = "Minimális összeg árajánlatokhoz és számlákhoz.",
                minimumPartialPayment = "Legkisebb részletfizetés, kivéve a kisebb hátralékot vagy előleget.",
                reminderFee = "Díj, amelyet minden érvényes emlékeztető hozzáad.",
                reminderGraceDays = "Késedelmes napok száma, mielőtt az első emlékeztető megengedett lenne.",
                taxPercent = "Adó, amely a kedvezmények után kerül hozzáadásra.",
            },
            settingFields = {
                radialEnabled = "Számla radiális művelet",
                allowTuningInvoices = "Tuning ügyfelek számlázása",
                customerRange = "Ügyfél távolsága",
                allowAnalytics = "Számviteli elemzések",
                allowCancellation = "Mégintés",
                allowCustomPrices = "Egyedi árak engedélyezése",
                allowEstimates = "Árajánlatok engedélyezése",
                allowImmediatePayment = "Azonnali kifizetés engedélyezése",
                allowManualItems = "Egyedi pozíciók engedélyezése",
                allowPartialPayments = "Részleges kifizetések engedélyezése",
                allowReminders = "Emlékeztetők",
                amount = "Mennyiség",
                analyticsPeriodDays = "Elemzési időszak",
                bone = "Csont",
                category = "Kategória",
                classId = "Osztályazonosító",
                defaultDueDays = "Kifizetési határidő (nap)",
                depositPercent = "Részletarány",
                difficulty = "Nehézség",
                enabled = "Engedélyezve",
                estimateLifetimeHours = "Becslés élettartama (óra)",
                flow = "Telepítési folyamat",
                grade = "Rang",
                gradeRules = "Rangsabályok",
                item = "Tárgy",
                key = "Kulcs",
                kilometersToZero = "Zéróig tartó távolság",
                label = "Címke",
                laborFee = "Munkadíj",
                laborMultiplier = "Munkadíj-szorzó",
                marginAdjustmentPercent = "Margó-korrekció",
                marginPercent = "Margó %",
                maxDiscountPercent = "Maximális kedvezmény",
                maximumInvoiceAmount = "Maximális számlaösszeg",
                maximumManualItems = "Maximális egyedi pozíciók",
                maximumPrice = "Maximális",
                maximumReminders = "Maximális emlékeztetők",
                minimumInvoiceAmount = "Minimális számlaösszeg",
                minimumPartialPayment = "Minimális részleges kifizetés",
                minimumPrice = "Minimális",
                multiplier = "Szorzó",
                name = "Tárgy neve",
                partKey = "Részkulcs",
                price = "Ár",
                priceType = "Ártípus",
                prop = "Tárgy",
                reason = "Indok",
                reminderFee = "Emlékeztető díj",
                reminderGraceDays = "Emlékeztető kegyelmi időszak",
                removeAfterUse = "Tárgy elfogyasztása",
                repair = "Javítás készlettel",
                repairItem = "Javítási tárgy",
                rx = "Rotáció X",
                ry = "Rotáció Y",
                rz = "Rotáció Z",
                supplierSharePercent = "Szállító %",
                taxPercent = "Számlaadó",
                transport = "Szállítás",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Fejlesztés",
                maximumDiscountPercent = "Maximális kedvezmény",
            },
            settingGroups = {
                antiExploit = {
                    label = "Exploit-védelem",
                },
                coach = {
                    label = "Telemetria-Edző",
                },
                cooldownMultipliers = {
                    label = "Hűlési szorzók",
                },
                crashFalloff = {
                    label = "Ütközési veszteség",
                },
                criticalEngine = {
                    label = "Tönkrement motor",
                },
                deformation = {
                    label = "Deformáció",
                },
                diagnostics = {
                    label = "Diagnosztika",
                },
                fade = {
                    label = "Fékhatás csökkenése",
                },
                features = {
                    label = "Funkciók",
                },
                format = {
                    label = "Formátum",
                },
                frontalImpact = {
                    label = "Súlyos frontális ütközés",
                },
                general = {
                    label = "Általános",
                },
                heatMultipliers = {
                    label = "Melegedési szorzók",
                },
                illegalMarket = {
                    label = "Illegális piac",
                },
                integration = {
                    label = "Integráció",
                },
                items = {
                    label = "Tárgyak",
                },
                keybinds = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Billentyűzések",
                },
                lifetime = {
                    label = "Élettartam",
                },
                limits = {
                    label = "Tárolási korlátok",
                },
                repairRestore = {
                    label = "Javítás és visszaállítás",
                },
                risk = {
                    label = "Kockázat",
                },
                rules = {
                    label = "Szabályzat",
                },
                safety = {
                    label = "Érvényesítés és biztonság",
                },
                stages = {
                    label = "Túlmelegedési fokozatok",
                },
                tyreRepair = {
                    label = "Gumiabroncs-javítás",
                },
                visuals = {
                    label = "Vizuális effektek",
                },
            },
            settingSections = {
                electronicTuning = "ECU motorszoftver",
                advancedPricing = "Haladó árak",
                brakeOverheating = "Fékmelegedés",
                carryItems = "Vihető tárgyak",
                fakePlates = "Hamis rendszámok",
                firejobVehicleFires = "Járműtüzek",
                general = "Általános",
                handlingEditor = "Járműkezelés-szerkesztő",
                instantTuning = "Azonnali Tuning",
                maintenanceNotifications = "Karbantartási értesítések",
                mileageHud = "Kilométer HUD",
                mobileDyno = "Mobilizációs dinamó",
                oilLeaks = "Járműfolyadék-szivárgások",
                partsTheft = "Alkatrások lopása",
                subscriptions = "Előfizetések",
                tuning = "Hangolás",
                vehicleCare = "Járműgondozás",
                vehicleRegistry = "Járműigazolások",
                wear = "Elhasználtság",
                wheelDamage = "Keréksérülés",
            },
            settingSubsectionGroups = {
                handlingAdditional = "További",
                handlingAir = "Levegő",
                handlingGeneral = "Általános",
                handlingRoad = "Út",
                handlingWater = "Víz",
            },
            settingSubsections = {
                mechanicHotkeys = "Billentyűzések",
                database = "Adatbázis",
                handlingEditorGeneral = "Szerkesztői beállítások",
                handlingMaximumCBikeHandlingData = "Motorkerékpár",
                handlingMaximumCBoatHandlingData = "Hajó",
                handlingMaximumCCarHandlingData = "Autó",
                handlingMaximumCFlyingHandlingData = "Repülőgép",
                handlingMaximumCHandlingData = "Járműalap",
                handlingMaximumCSeaPlaneHandlingData = "Vízisípkész",
                handlingMaximumCSpecialFlightHandlingData = "Speciális repülés",
                handlingMaximumCSubmarineHandlingData = "Alvízi",
                handlingMaximumCTrailerHandlingData = "Trailer",
                handlingMaximumCVehicleWeaponHandlingData = "Járműfegyverek",
                keybinds = "Billentyűzések",
                operation = "Működés",
                placementRules = "Elhelyezési szabályok",
                testFlow = "Tesztmenet",
                tuning = "Azonnali tuning beállításai",
            },
            settingValues = {
                air_filter = "Légszűrő",
                brake_fluid = "Fékfolyadék",
                brake_pads = "Fékbetétek",
                catalytic_converter = "Katalizátor",
                clutch = "Kuplung",
                coolant = "Hűtőfolyadék",
                engine_oil = "Motorolaj",
                inverter = "Inverter",
                spark_plugs = "Gyújtógyertyák",
                suspension = "Felfüggesztés",
                traction_battery = "Vontatási akkumulátor",
                transmission_fluid = "Sebességváltó folyadék",
                tyres = "Gumiabroncsok",
                vehicleClass_0 = "Kompaktok",
                vehicleClass_1 = "Limuzinok",
                vehicleClass_10 = "Ipari",
                vehicleClass_11 = "Haszongépjárművek",
                vehicleClass_12 = "Teherautók",
                vehicleClass_13 = "Kerékpárok",
                vehicleClass_14 = "Hajók",
                vehicleClass_15 = "Helikopterek",
                vehicleClass_16 = "Repülőgépek",
                vehicleClass_17 = "Szerviz",
                vehicleClass_18 = "Mentőjárművek",
                vehicleClass_19 = "Katonai",
                vehicleClass_2 = "SUV-k",
                vehicleClass_20 = "Kereskedelmi",
                vehicleClass_21 = "Vonatok",
                vehicleClass_22 = "Nyílt kerék",
                vehicleClass_3 = "Kupék",
                vehicleClass_4 = "Muscle-autók",
                vehicleClass_5 = "Sportklasszikusok",
                vehicleClass_6 = "Sportautók",
                vehicleClass_7 = "Supersportok",
                vehicleClass_8 = "Motorkerékpárok",
                vehicleClass_9 = "Terep",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Járműjavítás",
                    description = "Járműjavítás biztosítása az azonnali tuning helyszínein.",
                },
                instantTuningRepairPrice = {
                    label = "Javítás ára",
                    description = "Rögzített javítási ár a tuning árszorzója nélkül.",
                },
                instantTuningWashEnabled = {
                    label = "Járműmosás",
                    description = "Járműmosás biztosítása az azonnali tuning helyszínein.",
                },
                instantTuningWashPrice = {
                    label = "Mosás ára",
                    description = "Rögzített mosási ár a tuning árszorzója nélkül.",
                },
                vehiclePriceSource = {
                    label = "Járműárak forrása",
                    description = "Automatikus: SQL az ESX esetén; járműkatalógus a QBCore/Qbox esetén. Adatbázis: beállított SQL-tábla minden keretrendszernél.",
                    options = {
                        auto = "Automatikus (keretrendszer)",
                        database = "Adatbázis",
                    },
                },
                vehiclePriceTable = {
                    label = "Járműárak táblája",
                    description = "Vételárakat tartalmazó tábla, pl. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Spawnnév oszlopa",
                    description = "Spawnneveket tartalmazó oszlop, pl. spawn_code (JG), nem a megjelenített név.",
                },
                vehiclePricePriceColumn = {
                    label = "Ár oszlopa",
                    description = "Számszerű vételárakat tartalmazó oszlop, pl. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Modellhash oszlopa (opcionális)",
                    description = "Opcionális numerikus hashoszlop, pl. hashkey (JG). Hagyja üresen a hashértékek spawnnevekből történő kiszámításához.",
                },
                addRevenueToSociety = {
                    description = "A fizetett tuning megrendelésekért kapott pénz betétele a tuning munkaközösség számlájára.",
                    label = "Befizetés a társaságnak",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Azok a kategóriák a Részszállító üzletben, amelyek szabadon megvásárolhatók maradnak, ha a Haladó árazás be van kapcsolva. Az egyezés figyelmen kívül hagyja a betűk nagyságát és a szóközöket.",
                    itemLabel = "Kategória",
                    label = "Mindig elérhető kategóriák",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "A kiválasztott kategóriákban konfigurált üzlettárgyak elérhetővé tétele tuningmegrendelés nélkül, valamint ezek árazása a dinamikus szállítórendszeren keresztül.",
                    label = "Mindig elérhető üzlettárgyak",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "A táblagépen megjelenített profitanalízis napjainak száma.",
                    label = "Elemzési időszak",
                },
                advancedPricingCategoryRules = {
                    description = "Beszállítói részesedés, haszonkulcs, munkaerőköltség és árhatárok tuning kategóriák szerint.",
                    label = "Kategória-szabályok",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Alapértelmezett mechanikus haszonkulcs a kategória és rang beállítások előtt.",
                    label = "Alapértelmezett margó",
                },
                advancedPricingDifficultyRules = {
                    description = "Tuningnehezítési szintenkénti további munkaerőköltség.",
                    label = "Nehezítési szabályok",
                },
                advancedPricingEnabled = {
                    description = "A tuningárak újraszámítása a szerveren, és ha a Részszállítás be van kapcsolva, a Dynasty alkatrészek megvásárlásának kötelezővé tétele a specifikus tuningmegrendeléshez.",
                    label = "Haladó árazás engedélyezése",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normál virtuális készlet minden szállítói cikkhez.",
                    label = "Alapkészlet",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Naponta eltelt időre vonatkozóan levont keresletpontok.",
                    label = "Napi keresletcsökkenés",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Szállítói felár minden keresletpontért.",
                    label = "Keresletfelár egységenként",
                },
                advancedPricingInventoryEnabled = {
                    description = "A szállítói árak emelése, ha a virtuális készlet alacsony vagy a kereslet magas.",
                    label = "Dinamikus szállítói készlet",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Alacsony készlet miatti szállítói felár maximuma",
                    label = "Alacsony készlet-felár",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Az a készletszint, amely alatt a ritkaság-felár beindul",
                    label = "Alacsony készlet küszöbérték",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "A kereslet-felár felső határa",
                    label = "Maximum kereslet-felár",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Naponta utántöltött virtuális egységek száma",
                    label = "Napi utántöltés",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globális rabattfelsőhatár a mechanikus számlákhoz",
                    label = "Maximum rabatt",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "A mechanikusok számára megengedett legmagasabb haszonkulcs.",
                    label = "Maximum margó",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Globális felső árhatár egy tuning alkatrészre",
                    label = "Maximum kiskereskedelmi ár",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Mechanikus rangonkénti felár, munkaerőköltség és rabatt határai",
                    label = "Mechanikus rangszabályok",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "A mechanikusok számára megengedett legalacsonyabb haszonkulcs.",
                    label = "Minimum margó",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Globális alsó árhatár egy tuning alkatrészre",
                    label = "Minimum kiskereskedelmi ár",
                },
                advancedPricingPreviewCompactValue = {
                    description = "A kompakt példa esetén használt járműérték",
                    label = "Kompakt előnézeti érték",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Az élő előnézet által használt tuning költség százaléka",
                    label = "Előnézeti tuning ráta",
                },
                advancedPricingPreviewSportsValue = {
                    description = "A sportautó példa esetén használt járműérték",
                    label = "Sportautó előnézeti érték",
                },
                advancedPricingPreviewSuperValue = {
                    description = "A szuperautó példa esetén használt járműérték",
                    label = "Szuperautó előnézeti érték",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "A fizetetlen árajánlat újraszámolásához szükséges perc",
                    label = "Ajánlat élettartama",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Visszatérítési százalék egy beszerzett, megrendeléshez kötött alkatrész esetén",
                    label = "Visszavételi visszatérítés",
                },
                advancedPricingRoundingStep = {
                    description = "Kerekítési lépés a Dynasty beszerzési sorokhoz",
                    label = "Szállító kerekítési lépése",
                },
                advancedPricingSupplierSharePercent = {
                    description = "A Dynasty Auto Supply által a részegység árából származtatott százalék",
                    label = "Szállítói részesedés",
                },
                advancedPricingTaxPercent = {
                    description = "A árazó könyvelésben külön tárolt adószázalék",
                    label = "Adó",
                },
                advancedPricingVehicleClassRules = {
                    description = "GTA járműosztályonkénti margó- és munkaerő-korrekciók",
                    label = "Járműosztály szabályok",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Fékfrissítés utáni késleltetés szorzói",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Járműosztályonkénti késleltetés szorzói",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "A fékezést követő késleltetés milliszekundumban, mielőtt a hűtés elindul",
                    label = "Hűtési késleltetés",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Másodpercenként eltávolított hő, ha a fék nem használatban van",
                    label = "Hűtési sebesség",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "A szikrázás és rövid fékhiány kezdődésének hőmérsékleti küszöbe",
                    label = "Kritikus küszöb",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "0 és 1 közötti esély egy rövid fékhiányra kritikus hőmérsékleten fékezéskor.",
                    label = "Elhalványulás esélye másodpercenként",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Elhalványulás késleltetési ideje",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maximális elhalványulási időtartam",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minimális elhalványulási időtartam",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Fékfrissítés utáni hőmérséklet szorzói",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Járműosztályonkénti hőmérséklet szorzói",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Alap hőmérséklet másodpercenként fékezéskor referenciasebességnél.",
                    label = "Hőmérséklet növekedés",
                },
                brakeOverheatingHotThreshold = {
                    label = "Meleg küszöbérték",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Minimális járműsebesség km/h-ban, amely alatt fékezéskor hő keletkezik.",
                    label = "Minimális fékezési sebesség",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Sebesség km/h-ban, amelyen a beállított alap hőmérséklet növekedés érvényesül.",
                    label = "Referenciasebesség",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maximális szikraintervallum",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minimális szikraintervallum",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximális távolság méterben a izzás és szikra megjelenítéséhez.",
                    label = "Látótávolság",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Meleg küszöbérték",
                },
                carryItems = {
                    description = "Olyan alkatrészek, amelyeket fizikai tárgyként kell szállítani.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Motor emelő",
                                forklift = "Villás emelő",
                                hand = "Kéz",
                            },
                        },
                    },
                    itemLabel = "Szállítható tárgy",
                    label = "Szállítható tárgyak",
                },
                ecuEngineTorqueStage1 = {
                    description = "Az 1,00 nem ad extra erőt; az 1,10 10%-kal növeli a nyomatékot. Az adott ECU-szinttel rendelkező járművekre érvényes.",
                    label = "Nyomatékszorzó, 1. szint",
                },
                ecuEngineTorqueStage2 = {
                    description = "Az 1,00 nem ad extra erőt; az 1,10 10%-kal növeli a nyomatékot. Az adott ECU-szinttel rendelkező járművekre érvényes.",
                    label = "Nyomatékszorzó, 2. szint",
                },
                ecuEngineTorqueStage3 = {
                    description = "Az 1,00 nem ad extra erőt; az 1,10 10%-kal növeli a nyomatékot. Az adott ECU-szinttel rendelkező járművekre érvényes.",
                    label = "Nyomatékszorzó, 3. szint",
                },
                ecuEngineTorqueStage4 = {
                    description = "Az 1,00 nem ad extra erőt; az 1,10 10%-kal növeli a nyomatékot. Az adott ECU-szinttel rendelkező járművekre érvényes.",
                    label = "Nyomatékszorzó, 4. szint",
                },
                fakePlatesAudit = {
                    label = "Audit napló",
                },
                fakePlatesBlacklist = {
                    description = "Blokkolt szavak vagy szavazatok, amelyek nem jelenhetnek meg hamis rendszámokon.",
                    label = "Fekete lista",
                },
                fakePlatesBlankPlateItem = {
                    description = "A hamis rendszámok gazdasági köréhez használt előállítási/üzleti anyag.",
                    label = "Üres rendszám tárgy",
                },
                fakePlatesCooldownMinutes = {
                    label = "Hűtési idő percben",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Veszteség esélye",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Baleseti veszteség engedélyezve",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minimális baleseti sebesség",
                },
                fakePlatesEnabled = {
                    description = "Engedélyezi a játékosoknak, hogy hamis rendszám készleteket használjanak járműveken.",
                    label = "Hamis rendszámok engedélyezése",
                },
                fakePlatesExpireMinutes = {
                    description = "0 megtartja a hamis rendszámokat aktívan, amíg a visszaállítás vagy a újraindítás kezelése nem távolítja el őket.",
                    label = "Lejáratási idő percben",
                },
                fakePlatesExpireOnRestart = {
                    label = "Újraindításkor lejár",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Fizetési fiók.",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Illegális piac engedélyezve",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Illegális piaci ár",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Kockázati szorzó",
                },
                fakePlatesInstallDurationMs = {
                    label = "Telepítési idő ms-ben",
                },
                fakePlatesItem = {
                    description = "Egyszer használatos tárgy, amely elindítja a hamis rendszám telepítési folyamatot.",
                    label = "Hamis rendszám készlet tárgy",
                },
                fakePlatesMaxLength = {
                    label = "Maximális hossz",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Jármű távolság",
                },
                fakePlatesMinLength = {
                    label = "Minimális hossz",
                },
                fakePlatesPattern = {
                    description = "Lua minta a hamis rendszám szöveg érvényesítéséhez, például ^[A-Z0-9]+$.",
                    label = "Lua minta",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Rendszám elhelyezési távolság",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Dupla aktív hamis rendszám blokkolása",
                },
                fakePlatesPrinterItem = {
                    description = "A hamis rendszám-gazdálkodási körökhez használt előállítási/üzleti eszköz.",
                    label = "Rendszám-nyomtató tárgy",
                },
                fakePlatesRequireEngineOff = {
                    label = "A motor ki kell, hogy legyen kapcsolva",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Használja a Config.Functions.CanApplyFakePlate-t a telepítés engedélyezése előtt.",
                    label = "Tulajdonos vagy kulcs szükséges",
                },
                fakePlatesRequireStopped = {
                    label = "A jármű meg kell, hogy álljon",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Garázs-integrációkhoz fenntartva, amelyek a reset eseményt vagy az exportot hívják meg.",
                    label = "Visszaállítás a garázs tárolásakor",
                },
                fakePlatesRiskCharacters = {
                    label = "Betűzési hibajelölők",
                },
                fakePlatesRiskEnabled = {
                    label = "Betűzési hiba kockázat engedélyezve",
                },
                fakePlatesRiskTypoChance = {
                    label = "Betűzési hiba esélye",
                },
                fallbackVehicleValue = {
                    description = "Érték, amelyet akkor használnak, ha járműár nem határozható meg.",
                    label = "Helyettesítő járműérték",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Esély a 0-tól a 1-ig, miután a motor kritikus állapotban marad.",
                    label = "Kritikus motorégés esélye",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Második hibás motorégés kiváltásához szükséges másodperc.",
                    label = "Kritikus motor hűtési idő",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Késleltetés milliszekundumban, amíg egy sérült motor lángra kap.",
                    label = "Kritikus motor késleltetése ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Engedélyezi, hogy a kritikusan sérült motorok késleltetéssel indítsanak egy Firejob járműégést.",
                    label = "Hibás motorok meggyújtása",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Füstsűrűség a hibás motor miatti tűz kérésekhez.",
                    label = "Kritikus motorfüstsűrűség",
                },
                firejobVehicleFiresEnabled = {
                    description = "Engedélyezi, hogy a Mechanicjob sérülési rendszerei Firejob járműtűz kérést tegyenek.",
                    label = "Firejob járműtűzek engedélyezése",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Kötelező előrehaladási arány 0 és 1 között.",
                    label = "Előrehaladási arány",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Esély (0 és 1 között), hogy egy jogosult ütközés tüzet indítson.",
                    label = "Ütközési tűz esélye",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Másodpercek, amíg egy újabb ütközési tűz kiváltható.",
                    label = "Ütközési tűz hűtési idő",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Engedélyezi, hogy a súlyos frontális balesetek Firejob járműtűz kérést tegyenek.",
                    label = "Meggyújtás súlyos balesetek után",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Füstsűrűség az ütközés miatti tűz kérésekhez.",
                    label = "Ütközési füstsűrűség",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatikus: a konfigurált Firejob erőforrást használja; Letiltva megakadályozza, hogy a Mechanicjob tüzet hozzon létre.",
                    label = "Integrációs mód",
                    options = {
                        automatic = "Automatikus",
                        disabled = "Letiltva",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimális elvesztett karosszéria-egészség az ütközés során.",
                    label = "Minimális karosszéria-kár",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimális elvesztett motor-egészség az ütközés során.",
                    label = "Minimális motor-kár",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Használja a 0-t a deformációs ellenőrzés letiltásához.",
                    label = "Minimális frontdeformáció",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimális ütközési sebesség km/h-ban.",
                    label = "Minimális ütközési sebesség",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Kötelező sebességvesztés km/h-ban az ütközés során.",
                    label = "Minimális sebességvesztés",
                },
                firejobVehicleFiresResource = {
                    description = "Erőforrás, amely a járműtűz kéréseket kapja.",
                    label = "Firejob erőforrás",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Belső szerveresemény, amelyet a Mechanic kliens használ a Firejob járműtűz kéréséhez.",
                    label = "Mechanic szerveresemény",
                },
                freeVehicles = {
                    description = "Olyan járműmodellek, amelyek ingyenes tuningmegrendeléseket kapnak.",
                    itemLabel = "Járműmodell",
                    label = "Ingyenes tuning járművek",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Megakadályozza az Alkalmazást, amíg kritikus handling-konfliktus áll fenn.",
                    label = "Kritikus találatok blokkolása",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Várható maximális lassulás m/s²-ban egy befejezett fékteszthez.",
                    label = "Minimális fék lassulás",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Mérési minták száma, amelyre szükség van, mielőtt a Telemetria Edző kiértékel egy futást.",
                    label = "Minimális mintaszám",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Mért kerékcsúszás sebessége km/h-ban, amelynél a tapadásvesztést jelentik.",
                    label = "Kerékcsúszás figyelmeztetés",
                },
                handlingEditorDefaultTab = {
                    description = "Az oldal, amely kiválasztásra kerül, amikor a független Handling Szerkesztő megnyílik.",
                    label = "Kezdő oldal",
                    options = {
                        advanced = "Haladó",
                        export = "Exportálás",
                        flags = "Jelzők",
                        fleet = "Flotta",
                        inspector = "Rétegek",
                        profiles = "Profilok",
                        simple = "Egyszerű",
                        telemetry = "Telemetria",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Bünteti a hatás, a referencia-tartomány, a tünetek, a kapcsolódó mezők és az élő támogatás minden kezelésértékre.",
                    label = "Mező dokumentáció",
                },
                handlingEditorFieldMaximum = {
                    description = "A szerkesztő által elfogadott fix maximumérték ehhez a kezelési mezőhöz.",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Keresd és szűrd a jelzőneveket, hatásokat, bitpozíciókat és hexadecimális maszkokat.",
                    label = "Jelző keresés",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Keresd, vizsgálja meg, emelje és állítsa vissza a modell- és rendszám-szabályokat.",
                    label = "Járműpark-kezelő",
                },
                handlingEditorFocusKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Vissza a kezelési szerkesztőhöz",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Mutasd a jármű bázist, a telepített egyedi tuningot, a modellszabályt, a rendszámszabályt és a jelenlegi szerkesztői tervezetet minden mezőhöz.",
                    label = "Réteg vizsgáló",
                },
                handlingEditorMaxFleetResults = {
                    description = "A Fleet Manager-be betöltött maximális modell- és rendszámszabályok száma.",
                    label = "Flotta eredménylimit",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Minden profilhoz megőrzött maximális revíziók száma.",
                    label = "Profil revíziók",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Minden adminisztrátorhoz megőrzött maximális elnevezett munkaterületek száma.",
                    label = "Személyes munkaterületek",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Kódolt bytek, amelyek után egy szerkesztői kérés, válasz vagy pillanatkép nagy méretűnek jelenthető be.",
                    label = "Nagy terheltségű küldemény küszöbértéke",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "A szerkesztői műveletek mérésével figyelmeztet a Sky.Debug-on keresztül, ha a beállított határokat túllépik.",
                    label = "Teljesítményellenőrzések",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "A részletes hibakeresési naplózás engedélyezése esetén az összesített műveleti összefoglalók közötti milliszekundumok száma.",
                    label = "Összefoglalási intervallum",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Az a milliszekundumok száma, amely után egy mért Handling Editor művelet lassúnak minősül.",
                    label = "Lassú művelet küszöbértéke",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Hozz létre egy auditálható revíziót, amikor egy megosztott profilt frissítenek vagy visszaállítanak.",
                    label = "Profil verziókezelés",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "A numerikus csúszka maximális százalékos eltérése a rögzített jármű alaptól felfelé vagy lefelé. A közvetlen bevitel és az XML-import veszteségmentes marad. A nem alapértelmezett mező maximumértéke felülírja a csúszka felső végpontját.",
                    label = "Maximális csúszka-elmozdulás",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Hozz létre átlátható, szabályalapú ajánlásokat a mért úteszteli adatokból.",
                    label = "Telemetria-Edző",
                },
                handlingEditorValidatorEnabled = {
                    description = "Felderítsd a veszélyes vagy ellentmondásos kombinációkat, mielőtt a kezelést alkalmaznák.",
                    label = "Kezelés érvényesítő",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Engedélyezd az adminisztrátoroknak, hogy elnevezett privát szerkesztői tervezeteket tartsanak meg.",
                    label = "Személyes munkaterületek",
                },
                instantTuningAllowedJobs = {
                    description = "Opcionális globális engedélyezett lista. Hagyd üresen, hogy mindenkinek engedélyezd, hacsak a csak mechanikus nem van engedélyezve.",
                    itemLabel = "Foglalkozás neve",
                    label = "Engedélyezett foglalkozások",
                },
                instantTuningBlipColor = {
                    description = "GTA blip színazonosító.",
                    label = "Blip szín",
                },
                instantTuningBlipEnabled = {
                    description = "Mutasd a térképi blipeket a gyors tuning helyszíneken.",
                    label = "Blip engedélyezve",
                },
                instantTuningBlipName = {
                    description = "Térképi blip neve.",
                    label = "Blip név",
                },
                instantTuningBlipSprite = {
                    description = "GTA blip sprite azonosító.",
                    label = "Jelkép",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Használd a jelzős E interakciót akkor is, ha a cél támogatás engedélyezve van.",
                    label = "Jelző interakció kényszerítése",
                },
                instantTuningInteractionDistance = {
                    description = "Alapértelmezett távolság a gyors tuning pontok használatához.",
                    label = "Interakciótávolság",
                },
                instantTuningLabel = {
                    description = "Alapértelmezett szöveg a gyors tuning pontokon.",
                    label = "Alapértelmezett felirat",
                },
                instantTuningLocations = {
                    description = "Gyors tuning pontok. 0 távolság esetén örökli az alapértelmezett interakciós távolságot.",
                    itemLabel = "Helyszínek",
                    label = "Helyszínek",
                },
                instantTuningMarkerEnabled = {
                    description = "Világmegjelölő megjelenítése az azonnali tuning helyeken.",
                    label = "Jelző engedélyezve",
                },
                instantTuningMarkerType = {
                    description = "GTA jelző típusa a gyors tuning helyszínekhez.",
                    label = "Jelzőtípus",
                },
                instantTuningMechanicOnly = {
                    description = "Szűkítsd le az összes gyors tuning helyszínt a konfigurált mechanikus munkákra.",
                    label = "Csak mechanikus",
                },
                instantTuningPriceMultiplier = {
                    description = "A szorzó, amely az azonnali tuning árakra vonatkozik.",
                    label = "Árszorzó",
                },
                instantTuningProfile = {
                    description = "Konfiguráld, mely tuning lehetőségek állnak rendelkezésre a gyors tuning pontokon.",
                    label = "Gyors tuning lehetőségek",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "A legkisebb percszám, amíg ugyanaz a jármű újra karbantartási figyelmeztetést indíthat.",
                    label = "Figyelmeztetés hűtési idő",
                },
                maintenanceNotificationsEnabled = {
                    description = "Értesítsd a járműtulajdonosokat, amikor egy alkatrész eléri a karbantartási küszöbértéket.",
                    label = "Engedélyezve",
                },
                maintenanceNotificationsThreshold = {
                    description = "Az a kopás százalékos érték, amelyenél vagy alatt a karbantartás esedékessé válik.",
                    label = "Esedékesség küszöbérték",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Katalizátorlopás · E",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Katalizátorlopás · X",
                },
                mechanicDynoControl172 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · FEL",
                },
                mechanicDynoControl173 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · LE",
                },
                mechanicDynoControl174 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · BAL",
                },
                mechanicDynoControl175 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · JOBB",
                },
                mechanicDynoControl177 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · VISSZA",
                },
                mechanicDynoControl38 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · E",
                },
                mechanicDynoControl45 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · R",
                },
                mechanicDynoControl47 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Próbaáll · G",
                },
                mechanicSprayPaintControl200 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Sprayozás · KILÉPÉS",
                },
                mechanicSprayPaintControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Sprayozás · KILÉPÉS",
                },
                mechanicVehicleCareControl200 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Járműgondozás · KILÉPÉS",
                },
                mechanicVehicleCareControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Járműgondozás · KILÉPÉS",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolása · E",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolása · L",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolása · K",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolása · J",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolása · F",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Jármű tolatása · LSHIFT",
                },
                mechanicWheelChangeControl200 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Kerekek cseréje · KILÉPÉS",
                },
                mechanicWheelChangeControl202 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Kerekek cseréje · KILÉPÉS",
                },
                mechanicWheelChangeControl22 = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Kerékcsere · SPACE",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Keréklopás · E",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Keréklopás · X",
                },
                mileageHudDigits = {
                    description = "A kilométeróra HUD-on megjelenített számjegyek száma.",
                    label = "Számjegyek",
                },
                mileageHudPosition = {
                    description = "Húzd a kilométeróra HUD előnézetét a kívánt képernyőpozícióba.",
                    label = "Pozíció",
                },
                mobileDynoConsumeItem = {
                    description = "Egy elem eltávolítása sikeres elhelyezés után.",
                    label = "Tárgy elfogyasztása",
                },
                mobileDynoCooldownMs = {
                    label = "Hűtési időtartam",
                },
                mobileDynoCountdownMs = {
                    label = "Indítási visszaszámlálás",
                },
                mobileDynoDuiDistance = {
                    label = "Panel renderelési távolság",
                },
                mobileDynoFanInteractionDistance = {
                    description = "A hűtőventilátorok közötti fizikai kapcsoló használatához szükséges távolság méterben.",
                    label = "Ventilátorvezérlés távolsága",
                },
                mobileDynoFullLoadDurationMs = {
                    description = "A tartós teljes terhelés alatt eltöltött milliszekundumok száma a teljes terhelési szakaszt tartalmazó profilokban.",
                    label = "Teljes terheltségű időtartam",
                },
                mobileDynoHistoryLimit = {
                    label = "Történeti korlát",
                },
                mobileDynoInteractionDistance = {
                    label = "Panel-interakciós távolság",
                },
                mobileDynoItemUseEnabled = {
                    description = "A dynó és a monitor elhelyezésének engedélyezése inventár-tárgy használatával.",
                    label = "Tárgy-elhelyezés",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Aktív munkamenetek maximális száma",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Jármű-elkapás távolsága",
                },
                mobileDynoMonitorItem = {
                    description = "Az eredmény-monitor elhelyezéséhez szükséges inventár-tárgy.",
                    label = "Monitor-tárgy",
                },
                mobileDynoPersistItems = {
                    description = "Az új elhelyezések mentése szerverújraindítások között.",
                    label = "Elhelyezések mentése",
                },
                mobileDynoPickupDistance = {
                    description = "A felszerelés felvételének maximális távolsága méterben.",
                    label = "Felvételi távolság",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    description = "A maximális földmagasság-változás méterben, amelyet az összes próbaáll érzékelő elfogad.",
                    label = "Maximális magasságváltozás",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    description = "A maximális földszög, amelyet az összes próbaáll elfogad.",
                    label = "Maximális elhelyezési dőlésszög",
                },
                mobileDynoRequireOnDuty = {
                    description = "A mechanikusoknak szolgálatban kell lenniük az elhelyezéshez és üzemeltetéshez.",
                    label = "Szolgálati kötelezettség",
                },
                mobileDynoResultDuiDistance = {
                    description = "A külön eredménymonitor megjelenítésének maximális távolsága méterben.",
                    label = "Eredmény-kijelző távolsága",
                },
                mobileDynoReturnItem = {
                    description = "A felhasznált tárgy visszaadása a felszerelés felvételekor.",
                    label = "Tárgy visszaadása",
                },
                mobileDynoStationItem = {
                    description = "Az inventárban található elem a dynó elhelyezéséhez.",
                    label = "Dyno-tárgy",
                },
                mobileDynoTabletDistance = {
                    description = "A tablet vezérléséhez és a futó tesztekhez megengedett maximális távolság a dynótól méterben.",
                    label = "Tablet működési távolság",
                },
                nitroActivationKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Nitro tartása",
                },
                oilLeaksCooldownSeconds = {
                    description = "A másodperc száma, amíg egy új ütközési szivárgás ki nem indulhat.",
                    label = "Ütközés hűtési idő",
                },
                oilLeaksEnabled = {
                    description = "Engedélyezi, hogy a sérült belsőégésű járművek folyadékot hagynak hátra vezetés közben.",
                    label = "Folyadékszivárgások engedélyezése",
                },
                oilLeaksEngineOilChance = {
                    description = "Normál szivárgás esélye 0 és 1 között.",
                    label = "Motorolaj esélye",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kritikus szivárgás esélye 0 és 1 között.",
                    label = "Kritikus motorolaj esélye",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Az a motorolaj állapot, amelyenél vagy alatta a kritikus esélyt használjuk.",
                    label = "Kritikus motorolaj küszöbérték",
                },
                oilLeaksEngineOilThreshold = {
                    description = "A motorolaj állapota, amelyen vagy alatta szivárgás kezdődhet.",
                    label = "Motorolaj küszöbérték",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Kötelező előrehaladási arány 0 és 1 között.",
                    label = "Előrehaladási arány",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Engedélyezi, hogy a súlyos frontális ütközések ideiglenes motorfolyadék-szivárgást okozzanak.",
                    label = "Frontális ütközés szivárgás",
                },
                oilLeaksImpactChance = {
                    description = "0 és 1 közötti esélye annak, hogy egy jogosult ütközés elindít egy szivárgást.",
                    label = "Ütközés szivárgás esélye",
                },
                oilLeaksImpactRadius = {
                    description = "Az ütközés által létrehozott első folyadékpont sugara.",
                    label = "Ütközés szivárgás sugara",
                },
                oilLeaksIntervalSeconds = {
                    description = "A legkisebb másodpercek száma a nyomkövetési pontok között.",
                    label = "Nyomkövetési intervallum",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Az a másodpercek száma, amennyi ideig egy szivárgás tart egy jogosult ütközés után.",
                    label = "Ütközés szivárgás időtartama",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimális elvesztett karosszéria-egészség az ütközés során.",
                    label = "Minimális karosszéria-kár",
                },
                oilLeaksMinDistance = {
                    description = "A legkisebb megtett távolság a nyomkövetési pontok között.",
                    label = "Nyomkövetési távolság",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimális elvesztett motor-egészség az ütközés során.",
                    label = "Minimális motor-kár",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Kötelező frontális deformáció. Használd a 0-t, hogy ezt az ellenőrzést letiltsd.",
                    label = "Minimális frontdeformáció",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimális ütközési sebesség km/h-ban.",
                    label = "Minimális ütközési sebesség",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Kötelező sebességvesztés km/h-ban az ütközés során.",
                    label = "Minimális sebességvesztés",
                },
                oilLeaksMinSpeedKmh = {
                    description = "A folyadék-szivárgás nyomkövetésének elindításához szükséges minimális járműsebesség km/h-ban.",
                    label = "Minimális sebesség",
                },
                oilLeaksRadius = {
                    description = "A szabványos járműfolyadék-nomkövetési pontok sugara.",
                    label = "Nyomkövetési sugár",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normál szivárgás esélye 0 és 1 között.",
                    label = "Getriebefolyadék-szivárgás esélye",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kritikus szivárgás esélye 0 és 1 között.",
                    label = "Kritikus getriebefolyadék esélye",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "A getriebefolyadék szintje, amelyenél vagy alatta a kritikus esélyt használják.",
                    label = "Kritikus getriebefolyadék-szint",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "A getriebefolyadék szintje, amelyenél vagy alatta egy szivárgás elindulhat.",
                    label = "Getriebefolyadék-szint",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Azok a járműosztályok, amelyek emelőfüggő feladatokat végezhetnek workshop-emelő nélkül.",
                    itemLabel = "Járműosztály hozzáadása",
                    label = "Emelő-bypass járműosztályok",
                    options = {
                        ["0"] = "Kompaktok",
                        ["1"] = "Limuzinok",
                        ["10"] = "Ipari járművek",
                        ["11"] = "Haszongépjárművek",
                        ["12"] = "Teherautók",
                        ["13"] = "Kerékpárok",
                        ["14"] = "Hajók",
                        ["15"] = "Helikopterek",
                        ["16"] = "Repülőgépek",
                        ["17"] = "Szerviz",
                        ["18"] = "Mentőjárművek",
                        ["19"] = "Katonai járművek",
                        ["2"] = "SUV-k",
                        ["20"] = "Kereskedelmi",
                        ["21"] = "Vonatok",
                        ["22"] = "Nyílt kerék",
                        ["3"] = "Kupék",
                        ["4"] = "Muscle-autók",
                        ["5"] = "Sportklasszikusok",
                        ["6"] = "Sportautók",
                        ["7"] = "Supersportok",
                        ["8"] = "Motorkerékpárok",
                        ["9"] = "Terepjáró",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Azok a járműspawn-modellek, amelyek emelőfüggő feladatokat végezhetnek workshop-emelő nélkül.",
                    itemLabel = "Járműmodell",
                    label = "Emelő-bypass járműmodellek",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milliszekundumok a nem minijátékos feladat-beállítási lépésekhez.",
                    label = "Egyszerű beállítási időtartam",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Azok a járműosztály-azonosítók, amelyek mindig a normál mechanikus beállítást használják speciális emelő vagy minijáték nélkül.",
                    label = "Nem minijátékos járműosztályok",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Azok a járműspawn-modellek, amelyek mindig a normál mechanikus beállítást használják speciális emelő vagy minijáték nélkül.",
                    label = "Nem minijátékos járműmodellek",
                },
                partsDeliveryCompanyCard = {
                    description = "Engedélyezi az alkatrész-átviteli rendelések vállalati alapok használatát.",
                    label = "Vállalati kártyás fizetés",
                },
                partsDeliveryMode = {
                    description = "Tartsa a szabványos fizikai átviteli folyamatot, vagy adja hozzá a teljes átvételt közvetlenül az összegyűjtő játékos inventárjába.",
                    label = "Átviteli kezelés",
                    options = {
                        player_inventory = "Játékos inventár",
                        standard = "Szabványos átviteli folyamat",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Az alkatrész-átvitel kibontásához szükséges milliszekundumok.",
                    label = "Kibontási időtartam",
                },
                partsDeliveryOwnCard = {
                    description = "Engedélyezi a játékosoknak, hogy saját pénzzel fizessenek alkatrész-átviteli rendelésekért.",
                    label = "Saját kártyás fizetés",
                },
                partsDeliveryTimeSeconds = {
                    description = "A részek megrendelése és a kézbesítés készenléte közötti másodpercek száma.",
                    label = "Kézbesítési idő",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Az inventárba kerülő tárgy, amikor egy katalizátort lopnak el.",
                    label = "Katalizátor-tárgy",
                },
                partsTheftDealerAccount = {
                    description = "A lopott alkatrészekért járó kifizetéshez használt fiók, például pénz vagy bank.",
                    label = "Kifizetési fiók (kereskedő)",
                },
                partsTheftDealerItems = {
                    description = "A kereskedő által megvásárolt lopott tárgyak és azok kifizetési értékei.",
                    itemLabel = "Händler-tárgy",
                    label = "Händler-tárgyak",
                },
                partsTheftDealerPayoutItem = {
                    description = "Az inventárba kerülő tárgy, amikor a kifizetési típus Tárgy. Az eladási ár a tárgy mennyiségét határozza meg.",
                    label = "Kifizetési tárgy",
                },
                partsTheftDealerPayoutType = {
                    description = "Válaszd ki, hogy a kereskedő egy keretrendszeri fiókra fizet-e, vagy ad-e inventár-tárgyat.",
                    label = "Kifizetési típus",
                    options = {
                        account = "fiók",
                        item = "Tárgy",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "A lopott alkatrészek eladásához szükséges maximális távolság a kereskedőtől.",
                    label = "Eladási távolság",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Másodpercek, amíg ugyanaz a járműalkatrész újra rendőrségi kiindulási feladatot indíthat.",
                    label = "Riasztás várakozási idő",
                },
                partsTheftDispatchEnabled = {
                    description = "Rendőrségi kiindulási feladat indítása, amikor egy kereket vagy katalizátort lopnak el.",
                    label = "Rendőrségi kiindulási feladat küldése",
                },
                partsTheftDispatchJobs = {
                    description = "Azok a foglalkozások, amelyek rendőrségi kiindulási feladatokat kapnak lopott alkatrészek miatt.",
                    itemLabel = "Foglalkozás neve",
                    label = "Diszpécseri munkák",
                },
                partsTheftDispatchMessage = {
                    description = "A rendőrségi kiindulási feladat figyelmeztetésén megjelenő üzenet. Támogatja a {plate}, {part} és {type} tokeneket.",
                    label = "Rendőrségi kiindulási feladat-üzenet",
                },
                partsTheftDispatchTitle = {
                    description = "A rendőrségi kiindulási feladat figyelmeztetésén megjelenő cím. Támogatja a {plate}, {part} és {type} tokeneket.",
                    label = "Rendőrségi kiindulási feladat-cím",
                },
                partsTheftItem = {
                    description = "Az inventárba kerülő tárgy, amelyet a kerekek és katalizátorok lopásához használnak.",
                    label = "Lopási eszköz-tárgy",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Távolítsd el a lopási eszköz-tárgyat egy sikeres lopási cselekmény után.",
                    label = "Lopási eszköz felhasználása",
                },
                partsTheftStolenWheelItem = {
                    description = "Az inventárba kerülő tárgy, amikor kereket lopnak el.",
                    label = "Lopott kerék-tárgy",
                },
                priceType = {
                    description = "A százalék a járműár alapján számolja ki a költségeket. A fix összeg pénzértéket használ. A járműosztály az osztályos árazási táblázatot használja.",
                    label = "Ártípus",
                    options = {
                        class = "Járműosztály",
                        fixed = "Fix összeg",
                        percentage = "Százalék",
                    },
                },
                primaryColor = {
                    description = "A szerelői munkacsoport és az új munkák alapértelmezett színe. Használj egy hex értéket, például #EDC001.",
                    label = "Elsődleges szín",
                },
                publicUsersSeePrices = {
                    description = "Ha engedélyezve van, a nyilvános ügyfelek fizetnek megrendelés közben. Tiltsd le, hogy fizetetlen megrendeléseket hozhass létre a mechanikus számlázásához.",
                    label = "Nyilvános önálló kiszolgálású megrendelések számlázása",
                },
                registryBikeChecks = {
                    description = "Motoros vizsgálati pontok",
                    label = "Motoros vizsgálati pontok",
                },
                registryCarChecks = {
                    description = "Autó vizsgálati pontok",
                    label = "Autó vizsgálati pontok",
                },
                registryDistance = {
                    description = "Szerviz távolság (méter)",
                    label = "Szerviz távolság (méter)",
                },
                registryKuvFee = {
                    description = "Járműtechnikai vizsgálat díja",
                    label = "Járműtechnikai vizsgálat díja",
                },
                registryKuvValidityDays = {
                    description = "Új vizsgálatok érvényessége valós időben. Alapértelmezett: 30 nap. A meglévő lejárati dátumok megmaradnak.",
                    label = "Vizsgálat érvényessége (valós időbeli napok)",
                },
                registryKuvWarningDays = {
                    description = "Figyelmeztetési időszak (napok)",
                    label = "Figyelmeztetési időszak (napok)",
                },
                registryRegistrationFee = {
                    description = "Regisztrációs díj",
                    label = "Regisztrációs díj",
                },
                registryReinspectionFee = {
                    description = "Újraellenőrzési díj",
                    label = "Újraellenőrzési díj",
                },
                registryRequireKuv = {
                    description = "Érvényes járműtechnikai vizsgálat igényelése a regisztrációhoz",
                    label = "Érvényes járműtechnikai vizsgálat igényelése a regisztrációhoz",
                },
                registrySessionSeconds = {
                    description = "Megerősítési időtartam (másodpercek)",
                    label = "Megerősítési időtartam (másodpercek)",
                },
                registryTransferFee = {
                    description = "Átírás díja",
                    label = "Átírás díja",
                },
                registryVehicleTypes = {
                    description = "Engedélyezett járműtípusok",
                    label = "Engedélyezett járműtípusok",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Engedélyezd, hogy a jogosult főnökök vállalati pénzből előfizetést vásároljanak az egész foglalkozásukra.",
                    label = "Vállalati előfizetések",
                },
                subscriptionsCurrency = {
                    description = "A sky_base pénznem, amelyet az előfizetések vásárlásához használnak, például bank.",
                    label = "Fizetési pénznem",
                },
                subscriptionsEnabled = {
                    description = "Engedélyezd a műhelyelőfizetéseket, ügyfélterminálokat és előfizetési kedvezményeket.",
                    label = "Engedélyezve",
                },
                subscriptionsMaximumDurations = {
                    description = "Minden előfizetési modellre vonatkozó maximális időtartam- és árlehetőségek.",
                    label = "Maximális időtartamok",
                },
                subscriptionsMaximumModels = {
                    description = "A maximális előfizetési modellek száma, amelyeket egy műhely a tabletben konfigurálhat.",
                    label = "Maximális modellek",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Opcionális, ismétlődő animációs klip, amelyet akkor használnak, amikor a szcenárió üres.",
                    label = "NPC emote klip",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Opcionális animációs szótár, amelyet üres szcenárió esetén használnak.",
                    label = "NPC emote szótár",
                },
                subscriptionsNpcPedModel = {
                    description = "NPC modell, amelyet az előfizetési termináloknál generálnak, például s_m_m_autoshop_01.",
                    label = "NPC ped modell",
                },
                subscriptionsNpcScenario = {
                    description = "Opcionális GTA szcenárió, például WORLD_HUMAN_CLIPBOARD. Hagyd üresen, ha az emote animációt szeretnéd használni.",
                    label = "NPC szcenárió",
                },
                tuningBlockedPlates = {
                    description = "Ezekkel a rendszámokkal rendelkező járműveket nem lehet tuningolni, tuningot telepíteni vagy tuningot eltávolítani. Az egyezés figyelmen kívül hagyja a nagy- és kisbetűket, valamint a szóközöket.",
                    itemLabel = "Rendszám",
                    label = "Tuningot letiltott rendszámok",
                },
                tuningFocusKey = {
                    description = "Alapértelmezett FiveM billentyűkombináció, például E, F6 vagy MOUSE_BUTTON:MOUSE_RIGHT. Üres azt jelenti, hogy nincs alapértelmezett gomb. A játékosok a FiveM beállításaiban módosíthatják a saját billentyűzeteiket; a mentett játékos billentyűzetei megmaradnak.",
                    label = "Tuning egér-interakció",
                },
                tuningWorkshopDistance = {
                    description = "A maximális távolság egy önálló tuningponttól a szükséges telepítési vagy eltávolítási műveletekhez.",
                    label = "Műhelyi távolság",
                },
                tuningWorkshopRequireForInstall = {
                    description = "A tuningtelepítéseknek közel kell lenniük egy önálló tuningponthoz, hogy elinduljanak és befejeződjenek.",
                    label = "Műhely szükséges a telepítéshez",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "A tuningeltávolításoknak közel kell lenniük egy önálló tuningponthoz, hogy elinduljanak és befejeződjenek.",
                    label = "Műhely szükséges az eltávolításhoz",
                },
                vehicleCareRepairDurationMs = {
                    description = "A javítási folyamat időtartama milliszekundumban.",
                    label = "Javítási időtartam",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "A javítási művelet során a realisztikus kereksérülések is visszaállnak.",
                    label = "Realisztikus kereksérülések javítása",
                },
                vehicleCareRepairItem = {
                    description = "A járműjavítási művelet által használt inventár-tárgy.",
                    label = "Javítási tárgy",
                },
                vehicleCareRepairMaxDistance = {
                    description = "A maximális távolság a járműhöz a javítás során.",
                    label = "Max. javítási távolság",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "A javítási tárgy eltávolítása használat után.",
                    label = "Javítási tárgy felhasználása",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "A jármű normál GTA sérüléseinek javítása a javítási művelet során.",
                    label = "Járműsérülés javítása",
                },
                vehicleCareRepairWearParts = {
                    description = "Válaszd ki, mely kopási és szerviz alkatrészeket helyreállítja a javítási tárgy. Tiltsd le a folyadékokat, ha az olaj, hűtőfolyadék, fékfolyadék vagy áttéti folyadék a diagnosztikai javítási folyamatot igényli.",
                    itemLabel = "Kopó alkatrész",
                    label = "A javítószett által helyreállított alkatrészek",
                },
                vehicleCareWashItem = {
                    description = "A jármű mosásához használt inventár-tárgy.",
                    label = "Mosó tárgy",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "A mosó tárgy eltávolítása használat után.",
                    label = "Mosó tárgy felhasználása",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "A viaszolt jármű tisztán maradó távolsága.",
                    label = "Viaszolt tisztaság kilométerben",
                },
                vehicleCareWaxItem = {
                    description = "A jármű viaszolásához használt inventár-tárgy.",
                    label = "Viaszoló tárgy",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Használat után távolítsd el a viasz tárgyat.",
                    label = "Viasz tárgy felhasználása",
                },
                vehicleClassPricing = {
                    description = "A GTA járműosztályok mindegyikére felülírja az ár típusát és a költségszorzót.",
                    label = "Járműosztályok árazása",
                },
                wearParts = {
                    description = "Jármű kopási alkatrészek, élettartamuk távolsága, szükséges javítási tárgy, tárgy-fogyasztás és telepítési folyamat.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalizátor",
                                fluid_refill = "Folyadék utántöltése",
                                hood_install = "Motorhaube beszerelése",
                                oil_change = "Olajcsere",
                                performance = "Teljesítmény",
                                underbody_neon = "Alváz / emelő",
                                wheel = "Kerék",
                            },
                        },
                    },
                    itemLabel = "Kopó alkatrész",
                    label = "Kopó alkatrészek",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Alapértelmezett kereksérülés-szorzó",
                    label = "Alapértelmezett szorzó",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Szűri a torzulás-érzékelési pontokat, amelyek nem mutatnak vissza a járműtestre.",
                    label = "Érzékelési szög küszöbérték",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Minden helyreállítási ciklusban hozzáadott extra erő.",
                    label = "Torzulási sérülés növelése",
                },
                wheelDamageDeformationEnabled = {
                    description = "A karosszéria bemélyedéseinek rögzítése és helyreállítása a kerékjavítás geometriai újjáépítése során.",
                    label = "Torzulás helyreállítása",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "A bemélyedések helyreállításához használt kezdőerő.",
                    label = "Kezdeti torzulási sérülés",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "A bemélyedések újjáépítéséhez használt maximális SetVehicleDamage-hívások száma.",
                    label = "Torzulási iterációk",
                },
                wheelDamageDeformationThreshold = {
                    description = "A tároláshoz szükséges minimális érzékelt torzulási mérték.",
                    label = "Torzulási küszöbérték",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Szorzó, ha a jármű terepjáró kerekeket használ.",
                    label = "Terepjáró kerekek szorzója",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "A kerékgeometria újjáépítése után végrehajtott további azonnali nem-kereksérülés-helyreállítási ciklusok.",
                    label = "Sérülés újralkalmazási ciklusok",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "A kerékjavítása után a továbbra is hiányzó vagy teljesen lapos kerekekre végzett további azonnali ciklusok.",
                    label = "Kerékállapot újralkalmazási ciklusok",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "A karosszéria-, motor-, ablak-, ajtó-, szennyeződés- és vizuális sérülések megőrzése a kerékgeometria újjáépítése során.",
                    label = "Járműsérülések megőrzése",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "A törött ablakok csendes helyreállítása, ahol lehetséges, hangos csörömpölés nélkül.",
                    label = "Csendes törött ablakok",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "A továbbra is lapos kerekek csendes újralkalmazása új kerekkopogó hang vagy effektus nélkül.",
                    label = "Csendes lapos kerék újralkalmazása",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "A szerelési akcióhoz szükséges maximális távolság a sérült vagy hiányzó keréktől.",
                    label = "Kerék szerelési távolsága",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "A leválasztási akcióhoz szükséges maximális távolság a felhelyezett emelőtől.",
                    label = "Emelő leválasztási távolsága",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Sérülés-szorzók minden GTA járműosztályra.",
                    itemLabel = "Járműosztály",
                    label = "Járműosztály-szorzók",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Más munkák tiltása, ha szerelők vannak szolgálatban",
                },
                allowsprint = {
                    label = "Sprint engedélyezése szállítódobozokkal",
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
            tuningCategories = {
                bodywork = "Karosszéria és kinézet",
                electronics = "ECU és járműelektronika",
                engineSounds = "Motorhangok",
                handling = "Kezelés",
                lights = "Fények",
                other = "Egyéb",
                paint = "Festék",
                performance = "Teljesítmény",
                stance = "Stance",
                wheels = "Kerekek",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "Anti-Lag",
                    values = {
                        [0] = "Letiltva",
                        [1] = "GTA alap",
                        [2] = "Utcai durrogás",
                        [3] = "Verseny Anti-Lag",
                        [4] = "Rallye Anti-Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatikus vészvillogó",
                    values = {
                        [0] = "Ki",
                        [1] = "Be",
                    },
                },
                electronic_brake_lights = {
                    label = "Féklámpák",
                    values = {
                        [0] = "Normál",
                        [1] = "Vészfék-villogó",
                        [2] = "Ki",
                    },
                },
                electronic_engine_tune = {
                    label = "Motorvezérlő szoftver",
                    values = {
                        [0] = "Gyári",
                        [1] = "1. fokozat",
                        [2] = "2. fokozat",
                        [3] = "3. fokozat",
                        [4] = "4. fokozat",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Fényszórók fényereje",
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
                    label = "Főfény a szirénázáskor",
                    values = {
                        [0] = "Ki",
                        [1] = "Be",
                    },
                },
                electronic_idle_rpm = {
                    label = "Alapjárati fordulat",
                    values = {
                        [0] = "Gyári",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Belső világítás",
                    values = {
                        [0] = "Normál",
                        [1] = "Piros",
                    },
                },
                electronic_mood_color = {
                    label = "Hangulatvilágítás színe",
                    values = {
                        [0] = "Ki",
                        [1] = "Piros",
                        [10] = "Lime",
                        [11] = "Türkiz",
                        [12] = "Indigó",
                        [13] = "Fehér",
                        [14] = "Meleg fehér",
                        [15] = "Hideg fehér",
                        [16] = "Borostyán",
                        [2] = "Kék",
                        [3] = "Zöld",
                        [4] = "Cián",
                        [5] = "Magenta",
                        [6] = "Sárga",
                        [7] = "Narancs",
                        [8] = "Lila",
                        [9] = "Rózsaszín",
                    },
                },
                electronic_mood_intensity = {
                    label = "Hangulatvilágítás intenzitása",
                    values = {
                        [0] = "Halvány",
                        [1] = "Normál",
                        [2] = "Erős",
                    },
                },
                electronic_radio_power = {
                    label = "Rádió tápellátása",
                    values = {
                        [0] = "Ki",
                        [1] = "Be",
                    },
                },
                electronic_throttle_response = {
                    label = "Gázreakció",
                    values = {
                        [0] = "Több tapadás",
                        [1] = "Agresszív",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Wheelie hangolás",
                    values = {
                        [0] = "Ki",
                        [1] = "Lágy",
                        [2] = "Intenzív",
                    },
                },
            },
            vehicleClassLabel = "{id}. osztály ({name})",
        },
    },
}
