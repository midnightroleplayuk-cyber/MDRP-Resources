JobConfigLocales["sky_crimesystem:hu"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Közvetlen parancs",
            roleDefaults = {
                title = "Szerepkörök",
                description = "Válaszd ki az egyes alapértelmezett jogok minimális rangját. A főnökmenüben mentett rangjogok elsőbbséget élveznek.",
                bossHint = "A főnök és helyettese rangja mindig teljes hozzáférést kap.",
                empty = "Ehhez a munkához még nincsenek elérhető rangok.",
                gradesTitle = "Munkarangok",
                noDefault = "Nincs alapértelmezett jog",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "A közös értékek az öröklődő mezőkre vonatkoznak. A beállítási oldalon végzett módosítás egyéni értékre váltja a mezőt. A meglévő bejegyzések értékei megmaradnak.",
            weaponStreetDescription = "Drogos utcai kapcsolat használatakor a szerver időnként megfelelő fegyvert vásárolhat. A kiválasztást, árat és kifizetést a szerver határozza meg.",
            weaponGroups = {
                general = "Általános alapértékek",
                access = "Hozzáférési alapértékek",
                collection = "Gyűjtési alapértékek",
                production = "Gyártási alapértékek",
                market = "Piaci alapértékek",
                delivery = "Megbízási alapértékek",
                street = "Utcai fegyvereladás",
            },
            weaponOptions = {
                scrap_search = "Roncshalom átkutatása",
                player = "Játékosonként",
                global = "Globális",
                money = "Készpénz",
                bank = "Banki fiók",
                black_money = "Fekete pénz.",
                timing = "Állítsd meg a jelzőt a megfelelő tartományon belül.",
                precision = "Végezd el minden vágást a pontosság ablakán belül.",
                pressure = "Állítsd meg a préselt a megfelelő nyomáson.",
            },

            reputation = {
                remove = "Törlés",
                title = "Reputáció",
                action = "Akció",
                points = "Pontok teljesítésenként",
                enabled = "Engedélyezve",
                search = "Keresési műveletek",
                added = "Már hozzáadva",
                noResults = "Nem található megfelelő művelet.",
                empty = "Még nincs művelet. Használd a Plusz gombot egy művelet hozzáadásához.",
                name = "Szabály neve",
                target = "Célpont (opcionális)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Frakciók",
                    subtitle = "Konfiguráld a bűnözői foglalkozásokat és a közös helyszíneiket.",
                    title = "Bűnrendszer",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Főbázis",
                    entryPluralLabel = "Főbázisok",
                    label = "Főbázis zóna",
                },
                presetTerritories = {
                    label = "Előbeállított kerületek",
                    entryLabel = "Előbeállított kerület",
                    entryPluralLabel = "Előbeállított kerületek",
                },
                customTerritories = {
                    label = "Egyedi területek",
                    entryLabel = "Egyedi terület",
                    entryPluralLabel = "Egyedi területek",
                },
                objectsSection = {
                    label = "Kérdezői tárgyak",
                    entryLabel = "Objektum",
                    entryPluralLabel = "Kérdezői tárgyak",
                },
                blockedZonesSection = {
                    label = "Letiltott zónák",
                    entryLabel = "Zóna",
                    entryPluralLabel = "Letiltott zónák",
                },
                toolsSection = {
                    label = "Eszközök",
                    entryLabel = "Eszköz",
                    entryPluralLabel = "Eszközök",
                },
                sessionsSection = {
                    label = "Folyamatban lévő kihallgatások",
                    entryLabel = "Ülés",
                    entryPluralLabel = "Folyamatban lévő kihallgatások",
                },
                orphansSection = {
                    label = "Elhagyatott tárgyak",
                    entryLabel = "Objektum",
                    entryPluralLabel = "Elhagyatott tárgyak",
                },
            },
            darknetActions = {
                currentLocation = "Jelenlegi hely használata",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Magabb értékek jelentősen lassítják a növekedést rossz gondozás mellett, miközben kiváló gondozás esetén erős bónuszokat biztosítanak.",
                    label = "Gondozási válaszgörbe",
                },
                drugGrowthMaxMultiplier = {
                    description = "Kiváló körülmények között elért maximális növekedési szorzó.",
                    label = "Tökéletes gondozás szorzója",
                },
                drugGrowthMinMultiplier = {
                    description = "Kritikusan rossz növényi körülmények között használt növekedési szorzó.",
                    label = "Kritikus gondozás szorzója",
                },
                drugGrowthQualityBonusMax = {
                    description = "A növény minőségéből adódó maximális extra növekedési bónusz.",
                    label = "Minőségi növekedési bónusz",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Válassz érvényes minimális rangokat a szerepkörök jogaihoz.",
                base_raid_locked = "A bázist éppen lerohanták. Tárolóhelyei és konfigurációja le van tiltva.",
                base_storage_outside_zone = "Az összes tároló, fiók és heist tárolási pontnak a bázis zónáján belül kell lennie.",
                base_zone_invalid_polygon = "Helyezz el legalább három különböző pontot élek keresztezése nélkül, majd ellenőrizd a magasságot (3–200 m) és az útvonalazási dobozt.",
                base_zone_point_limit = "Egy főbázis-zóna legfeljebb 64 határpontot támogat.",
                base_zone_required = "Rendezz először egy érvényes főbázis-zónát ehhez a bűnügyi munkához.",
                crime_interrogation_invalid_model = "Adj meg egy érvényes objektummodellt.",
                crime_interrogation_invalid_coords = "Helyezd el az objektumot egy érvényes pozícióba.",
                crime_interrogation_invalid_zone_points = "Helyezz el legalább három érvényes határpontot.",
                crime_interrogation_duplicate_id = "Egy ilyen azonosítójú objektum már létezik.",
                crime_interrogation_tool_invalid = "Ellenőrizd az eszköz definícióját.",
                crime_interrogation_tool_id_invalid = "Adj meg egy érvényes eszköz-azonosítót.",
                crime_interrogation_tool_label_missing = "Adj meg egy nevet az eszköznek.",
                crime_interrogation_effect_missing = "Konfigurálj egy hatást az eszközre.",
                crime_interrogation_effect_type_unknown = "Válassz egy támogatott hatás-típust.",
                crime_interrogation_effect_status_missing = "Adj meg egy olyan státuszt, amelyet az eszköz érint.",
                crime_interrogation_minigame_missing = "Konfigurálj egy minijátékot az eszközre.",
                crime_interrogation_minigame_type_unknown = "Válassz egy támogatott minijáték-típust.",
                crime_interrogation_keys_missing = "Konfigurálj vezérléseket az eszközre.",
                crime_interrogation_keys_invalid = "Ellenőrizd az eszköz konfigurált vezérléseit.",
                crime_interrogation_keys_duplicate = "Rendezd hozzá az egyes eszköz-akciókat és vezérléseket csak egyszer.",
                crime_interrogation_anim_invalid = "Ellenőrizd az eszköz animációs könyvtárát és a klipjét.",
                crime_interrogation_anim_missing = "Konfigurálj egy animációt az eszköz használatához.",
                crime_interrogation_occupied = "Valaki már rögzítve van ehhez az objektumhoz.",
                crime_interrogation_not_found = "Ez már nem létezik.",
            },
            extensions = {
                baseZone = {
                    description = "Helyezz el 3 és 64 határpontot sorrendben. A legalsó elhelyezett pont határozza meg az alsó határt; a magasság onnan felfelé terjed. A pontokat vázlatként mented el; a zóna alkalmazásához használd a Mentés funkciót. Csak a zónán belüli tárolók, szekrények és lopási tárolók érhetők el a támadások során. A zónán kívüli pontok nem akadályozzák a mentést vagy a támadás indítását. A meglévő határok aktívak maradnak, amíg nem mented el a változtatásokat.",
                    fields = {
                        bucket = "Útvonaltervezési doboz",
                        configured = "Beállítva",
                        height = "Magasság (méter)",
                        radius = "Sugár (méter)",
                        x = "Központ X",
                        y = "Központ Y",
                        z = "Központ Z",
                    },
                    label = "Főbázis zóna",
                },
                invalidSelection = "Érvénytelen kiválasztás: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Ez a munkahely helyszínének főpontja. Ha a Munka → Jelzők alatt engedélyezve van a térképi jelző, akkor itt jelenik meg.",
            },
            locationTypes = {
                crimeStationPosition = "Helyszín / térképi jelző",
                heistCrafting = "Kincsrabló műhely",
                heistStorage = "Rablás tároló",
            },
            membershipMigration = {
                cancel = "Mégse",
                confirm = "Migrálás és mentés",
                message = "A meglévő szervezeti tagságok átkerülnek a kiválasztott modellre. A független módban a normál foglalkoztatás külön marad.",
                title = "Változtassuk a tagsági modellt?",
            },
            moneywashActions = {
                currentLocation = "Használd a jelenlegi helyszínt",
                invalidLocations = "Ellenőrizd az azonosítókat, neveket, belső választásokat és koordinátákat. Minden helyszínnek egyedi azonosítóra van szüksége.",
                position = "Pozíció",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Építési pontok", description = "Ezekre a pontokra megfelelő gépek kerülnek. A koordináták a kiválasztott belső térhez viszonyítottak." },
                mwBuildNodes = "Építési pontok",
                moneywashPublicEquipment = { label = "Nyilvános felszerelés", description = "Rendelj mosógépet, generátort és ventilátort a nyilvános helyek megfelelő pontjaihoz." },
                mwPublicEquipment = "Nyilvános felszerelés",
                moneywashMaterials = { label = "Anyagok", description = "Használj pontos leltári tárgyneveket. Tömeg grammban; telepítsd a hiányzó tárgyakat." },
                mwMaterials = "Anyagok",
                moneywashMaterialRecipes = { label = "Anyagreceptek", description = "Bemenet, kimenet és idő egységenként értendő. A feldolgozók ezeket a recepteket használják." },
                mwMaterialRecipes = "Anyagreceptek",
                moneywashProductionRecipes = { label = "Nyomtatási receptek", description = "Papír, festék és idő egységenként értendő. Készpénz csak szárítás és minőségellenőrzés után." },
                mwProductionRecipes = "Nyomtatási receptek",
                moneywashCollectors = { label = "Gyűjtők", description = "Állítsd be minden gyűjtő hozamát, eszközét, várakozását és helyét." },
                mwCollectors = "Gyűjtők",
                moneywashProcessors = { label = "Feldolgozók", description = "Válassz anyagreceptet és helyet minden feldolgozóhoz." },
                mwProcessors = "Feldolgozók",

                control = "Vezérlőpanel",
                editor = {
                    addBusiness = "Új üzlet létrehozása",
                    addInterior = "Új belső tér létrehozása",
                    advanced = "Technikai részletek",
                    asset_ipl = "IPL: Add meg a pontos IPL nevet és a belső tér pozícióját.",
                    asset_mlo = "MLO: Használd a telepített belső tér pozícióját. A jelenlegi hozzáférés az üzletbejáraton keresztül történik.",
                    asset_shell = "Shell: A modell erőforrásának telepítve és futtatva kell lennie a szerveren.",
                    businessHelp = "Nevezd el az üzletet, válaszd ki a belső teret, és állítsd be a vásárlási árat.",
                    businessListHelp = "Kezeld az üzletek bejárait és vásárlási árát.",
                    businesses = "Üzletek",
                    capture = "Helyezd el a játékban",
                    captureOrigin = "Állítsd be a belső tér pozícióját",
                    chooseInterior = "Válassz egy belső teret",
                    coordinates = "Szerkeszd a koordinátákat",
                    editSections = "Beállítás",
                    emptyBusinessHelp = "Kapcsolj össze egy térképi bejáratot egy belső térrel. A szervezeteitek így vásárolhatják meg az üres üzletet.",
                    emptyBusinesses = "Az első üzleted",
                    emptyInteriorHelp = "Kapcsolj egy IPL-t, egy Shell-t vagy egy telepített MLO-t, majd állítsd be az üzlethez tartozó pontokat.",
                    emptyInteriors = "Az első belső tér",
                    entranceHelp = "Állítsd be a belépő pontot, ahol a játékosok vásárolják és lépnek be az üzletbe.",
                    freecamHelp = "Freecam: WASD mozgat, Q/E felfelé/lefelé, Shift gyorsabb, Ctrl lassabb. Jobb egér: nézelődés. Gizmo húzása, R forgat/mozgat, Enter elhelyez, Backspace megszüntet.",
                    general = "Általános",
                    heading = "Irány",
                    interiorHelp = "Válaszd ki a belső tér típusát és a hozzá tartozó erőforrást.",
                    interiorListHelp = "Készíts elő üres tereket. A játékosok saját gépeiket és felszerelésüket helyezik el.",
                    interiors = "Belső terek",
                    listEmpty = "Még nincs bejegyzés.",
                    locationTypes = "Helyszínkezelés",
                    newBusiness = "Új üzlet",
                    newInterior = "Új belső tér",
                    noResults = "Nincs találat.",
                    notSet = "Nem beállítva",
                    offsetHelp = "A megadott értékek az origóhoz viszonyított eltolások. A világpozíció a fent látható.",
                    origin = "Origó",
                    originHelp = "A belső tér pozíciója. Az összes többi pont ehhez képest van meghatározva.",
                    originRequired = "Állítsd először a belső tér pozícióját az Általános menüpont alatt.",
                    outsideRange = "A {range} méteres körzeten kívül",
                    point_control = "Helyezd el és forgasd a falpanelt a gizmo segítségével a helyére. A megerősített objektummagasság pontosan megmarad. A jelzőt az Interakciók → Money Wash: vezérlőpanel alatt kapcsolhatod be/kikapcsolhatod.",
                    point_entry = "Itt érkeznek meg és távoznak a játékosok. A kilépés után automatikusan visszatérnek az üzlet külső belépőjéhez.",
                    point_position = "Ez a pont az üzleten kívül helyezkedik el.",
                    point_storage = "Helyezd el a polcot a gizmo segítségével, amíg a padlóra nem kerül. Itt férnek hozzá a tagok a vásárolt felszereléshez. A jelzőt az Interakciók → Money Wash: tároló alatt kapcsolhatod be/kikapcsolhatod.",
                    points = "Pontok",
                    pointsHelp = "Válassz ki egy pontot, és állítsd be közvetlenül a játékban.",
                    rangeNote = "A belső tér origójára vonatkozik a {range} méteres körzet, magassági korlátozás nélkül.",
                    remove = "Eltávolítás",
                    repairRange = "Helyezd közelebb ezeket a pontokat a belső tér origójához.",
                    saveHint = "Alkalmazzad a változtatásokat a felső Mentés gombbal.",
                    search = "Keresés …",
                    set = "Beállítva",
                    teleport = "Teleportálás",
                    viewInteriors = "Belső terek megtekintése",
                    visit = "Látogatás",
                    visitHint = "Közvetlen mozgás. Nyomj Backspace-t, ha visszatérnél az editorhoz.",
                    visitTitle = "Belső tér látogatása",
                },
                entry = "Belépés és kilépés",
                fields = {
                    mode = "Hozzáférési mód",
                    ownerKind = "Tulajdonostípus",
                    productionEnabled = "Nyomtatóbővítés elérhető",
                    feePercent = "Díj (%) / -1 = globális",
                    storageCapacity = "Raktárkapacitás (tárgy)",
                    maximumOrders = "Egyidejű rendelések játékosonként",
                    gridPower = "Hálózati teljesítmény / 0 = generátor",
                    autoService = "Automatikus nyilvános karbantartás",
                    maximumPendingOutputs = "Függő kifizetések felső határa",
                    placementRange = "Elhelyezési sugár (m)",
                    placementHeight = "Elhelyezés magasságtartománya (m)",
                    interiorId = "Belső tér azonosítója",
                    equipmentId = "Eszközazonosító",
                    nodeId = "Építési pont azonosítója",
                    generatorNode = "Generátorpont azonosítója",
                    maxOffset = "Legnagyobb ponteltérés (m)",
                    maxHeight = "Legnagyobb magassági eltérés (m)",
                    weight = "Tárgy tömege (g)",
                    inputItem = "Bemeneti anyag",
                    secondItem = "Második bemeneti anyag",
                    outputItem = "Kimeneti anyag",
                    requiredTool = "Szükséges szerszám",
                    baseQuality = "Kezdeti minőség (%)",
                    minimumQuality = "Minimális minőség (%)",
                    inspectionCards = "Ellenőrzőkártyák",
                    inspectionPenalty = "Minőségvesztés hibánként (%)",
                    rejectPercent = "Selejtezett bankjegyek (%)",
                    accessoryModel = "Kiegészítő modell",
                    accessoryMaximum = "Látható kiegészítők felső határa",
                    accessoryActiveOnly = "Kiegészítők csak feldolgozáskor",
                    animDict = "Animációs szótár",
                    animClip = "Animációs klip",
                    cooldown = "Várakozás (másodperc)",
                    minimum = "Minimális hozam",
                    maximum = "Maximális hozam",
                    productionPrice = "Pénznyomtatás · Vásárlási ár",
                    recipeId = "Recept ID",
                    inputAmount = "Anyag / egységenként",
                    secondAmount = "Anyag / egységenként",
                    outputAmount = "Anyag / egységenként",
                    paperItem = "Nyomtatópapír",
                    inkItem = "Nyomdafesték",
                    paperAmount = "Nyomtatópapír / egységenként",
                    inkAmount = "Nyomdafesték / egységenként",
                    notesPerUnit = "Bankjegyek / egységenként",
                    valuePerNote = "Készpénz / Bankjegyek",
                    maximumUnits = "Egységek (max.)",
                    printSeconds = "Nyomtatás / egységenként (Másodperc)",
                    inspectionSeconds = "Ellenőrzés / egységenként (Másodperc)",
                    rinseSeconds = "Mosás / egységenként (Másodperc)",
                    drySeconds = "Szárítás / egységenként (Másodperc)",
                    accessoryUnit = "Bankjegyek / egységenként",
                    accessoryX = "Kiegészítő modell · X (m)",
                    accessoryY = "Kiegészítő modell · Y (m)",
                    accessoryZ = "Kiegészítő modell · Z (m)",
                    accessoryStep = "Kiegészítő modell · Z (m)",

                    capacity = "Kapacitás ciklusonként",
                    controlHeading = "Vezérlőpanel címsor",
                    controlHeight = "Szerelési magasság a pont felett (m)",
                    controlModel = "Falpanel modell",
                    controlX = "Vezérlőpanel X",
                    controlY = "Vezérlőpanel Y",
                    controlZ = "Vezérlőpanel Z",
                    disableSets = "Elrejtett entitás-csoportok (vesszővel elválasztva)",
                    enableSets = "Aktivált entitás-csoportok (vesszővel elválasztva)",
                    entryX = "Belépés eltolása X",
                    entryY = "Belépés eltolása Y",
                    entryZ = "Belépés eltolása Z",
                    heading = "Nézeti irány",
                    id = "Egyedi azonosító",
                    interior = "Belső tér",
                    ipl = "IPL név",
                    kind = "Típus",
                    label = "Név",
                    model = "Modell neve",
                    power = "Energiamegységek",
                    price = "Vásárlási ár",
                    radius = "Elhelyezési sugár (m)",
                    repairPrice = "Javítási ár (0 = ingyenes)",
                    seconds = "Ciklus időtartama (másodperc)",
                    storageHeading = "Tárolási pont irányítása",
                    storageModel = "Polc modell",
                    storageX = "Tárolási pont X",
                    storageY = "Tárolási pont Y",
                    storageZ = "Tárolási pont Z",
                    wear = "Kopás per ciklus (%)",
                    x = "Origó X",
                    y = "Origó Y",
                    z = "Origó Z",
                },
                interactions = {
                    control = "Money Wash: vezérlőpanel",
                    storage = "Money Wash: tároló",
                },
                item = "Bejegyzés",
                moneywashBucketStart = {
                    description = "Ez a terület kizárólag a Money Wash rendszerének fenntartására szolgál. A változtatások a következő belépéskor lépnek érvénybe.",
                    label = "Instancia tartomány kezdete",
                },
                moneywashEquipment = {
                    description = "A játékosok vásárolják és helyezik el a berendezéseket. A kapacitás, a futtatási idő és a kopás a mosógépekre vonatkozik. Az áram a generátor teljesítménye vagy a berendezések igénye. A változtatások az új vásárlásokra vonatkoznak.",
                    label = "Vásárolható berendezések",
                },
                moneywashInteriors = {
                    description = "Üres IPL-, Shell- vagy MLO-belső terek konfigurálása. A belépési pont, a vezérlőpanel, a tároló és a felépítési határok az eredetivel vannak összefüggésben. A kilépéskor a játékos visszatér a saját üzletének bejáratához.",
                    label = "Belső terek (IPL, Shell vagy MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Maximális vásárolható berendezés és javítócsomag száma üzletenként.",
                    label = "Berendezési korlát",
                },
                moneywashPreviewBucketStart = {
                    description = "A látogatás hozzáadja a játékos azonosítóját ehhez az értékhez egy privát adminisztrációs példányhoz. Külön tartsd meg a vállalkozásoktól és más erőforrásoktól. A változtatások a következő előnézetről lépnek érvénybe.",
                    label = "Előnézeti instancia tartomány kezdete",
                },
                moneywashProperties = {
                    description = "Állíts be egy belépőt, válassz egy belső teret, és határozd meg a vásárlási árat. A vásárolt vállalkozások megtartják a mentett belső tereiket és elrendezéseiket.",
                    label = "Üzleti belépők",
                },
                moneywashRepairShops = {
                    description = "Állíts be javítóüzleteket, teleportálj oda, és határozd meg a szolgáltatási árat. Eladják a javítócsomagokat és karbantartják a tárolt gépeket.",
                    label = "Üzlet helyei",
                },
                moneywashShops = {
                    description = "Helyezz el üzleteket mosógépekhez, generátorokhoz és ventilátorokhoz. A rendelések a szervezet által kiválasztott üzletbe kerülnek.",
                    label = "Üzlet helyei",
                },
                mwEquipment = "Eszközbolt",
                mwInteriors = "Üres belső terek",
                mwProperties = "Helyek",
                mwRepairShops = "Javítóüzlet",
                mwSettings = "Üzleti beállítások",
                names = {
                    mwPublicLaundry = "Nyilvános mosoda",
                    mwPaperPulp = "Papírpép",
                    mwPrintingPaper = "Nyomtatópapír",
                    mwPrintingInk = "Nyomdafesték",
                    mwPaperRecipe = "Nyomtatópapír készítése",
                    mwPrintingRecipe = "Általános bankjegyek",
                    mwPaperCollector = "Papírgyűjtő",
                    mwInkCollector = "Festékgyűjtő",
                    mwPaperProcessor = "Papírfeldolgozó",
                    mwPrinter = "Nyomdagép",
                    mwInspectionTable = "Ellenőrzőasztal",
                    mwDryingCabinet = "Szárítószekrény",
                    mwNode1 = "1 · Mosás",
                    mwNode2 = "2 · Mosás",
                    mwNode3 = "3 · Építési pontok",
                    mwNode4 = "4 · Nyomtatás",
                    mwNode5 = "5 · Ellenőrzés",
                    mwNode6 = "6 · Szárítás",
                    mwNode7 = "7 · Építési pontok",

                    mwInteriorWarehouse = "Üres raktár",
                },
                options = {
                    private = "Magán",
                    public = "Nyilvános",
                    faction = "Szervezet",
                    person = "Karakter",
                    printer = "Nyomdagép",
                    inspection = "Ellenőrzőasztal",
                    dryer = "Szárítószekrény",

                    fan = "Ventilátor",
                    generator = "Generátor",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Javítókészlet",
                    shell = "Shell modell",
                    washer = "Mosógép",
                },
                origin = "Origó",
                storage = "Tárolási pont",
            },
            settingFields = {
                cultivationLevel = "Termesztési szint",
                cultivationTitle = "Szint címe",
                cultivationRequiredXp = "Kötelező összes XP",
                cultivationAction = "Akció",
                cultivationXp = "XP",
                cultivationCategory = "Kategória",
                cultivationEntry = "Bejegyzés",
                cultivationRequiredLevel = "Kötelező szint",
                alias = "Álnév",
                atmHeading = "Irány",
                atmId = "ID",
                atmModel = "ATM modell",
                centerX = "Központ X",
                centerY = "Központ Y",
                centerZ = "Központ Z",
                deliveryMethod = "Átvételi mód",
                description = "Leírás",
                enabled = "Engedélyezve",
                groupKey = "Csoportkulcs",
                id = "ID",
                itemLabel = "Áru címkéje",
                itemName = "Tárolóelem neve",
                knownScammer = "Ismert csaló",
                locationName = "Helyszín neve",
                observerW = "Megfigyelő irányítása",
                observerX = "Megfigyelő X",
                observerY = "Megfigyelő Y",
                observerZ = "Megfigyelő Z",
                pedModel = "NPC ped modell",
                pickpocketItemChance = "Esély (%)",
                pickpocketItemMaximum = "Maximális mennyiség",
                pickpocketItemMinimum = "Minimális mennyiség",
                pickpocketItemName = "Tárolóelem neve",
                quantity = "Mennyiség",
                radius = "Sugár",
                rating = "Megjelenített értékelés",
                ratingCount = "Megjelenített értékelések száma",
                scamChance = "Kereskedő átverési esélye (%)",
                shopCategory = "Kategória",
                shopClerkHeading = "Eladó iránya",
                shopClerkModel = "Eladó modell",
                shopClerkRequired = "Eladó szükséges",
                shopClerkX = "Eladó X",
                shopClerkY = "Eladó Y",
                shopClerkZ = "Eladó Z",
                shopCodeEnabled = "Kód megadásával nyitható",
                shopDrillEnabled = "Fúrás engedélyezve",
                shopEnabled = "Engedélyezve",
                shopHackEnabled = "Hackerelés engedélyezve",
                shopLocationId = "Áruház ID",
                shopLocationLabel = "Címke",
                shopRegisterId = "Pénztár ID",
                shopSafeEnabled = "Biztonsági doboz engedélyezve",
                shopSafeHeading = "Biztonsági doboz felirata",
                shopSafeX = "Biztonsági doboz X",
                shopSafeY = "Biztonsági doboz Y",
                shopSafeZ = "Biztonsági doboz Z",
                side = "Piac oldala",
                spawns = "Csapat spawnok",
                successfulTrades = "Megjelenített sikeres üzletek",
                title = "Ajánlat címe",
                unitPrice = "Darabonkénti ár",
                verified = "Ellenőrzött kereskedő",
                w = "Irány",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Eladó pozíció",
                shopRegisterPosition = "Pénztár pozíció",
                shopSafePosition = "Biztonsági doboz pozíció",
                registerId = "Pénztár azonosítója",
                registerX = "Pénztár X-koordinátája",
                registerY = "Pénztár Y-koordinátája",
                registerZ = "Pénztár Z-koordinátája",
                heading = "Irány",
                captureLocation = "Pozíció rögzítése",
            },
            crimeDashboard = {
                jobs = "Frakciók, tagok, jogosultságok és helyszínek kezelése.",
                jobCreator = "Válassz frakciót a helyszíneinek és területeinek szerkesztéséhez.",
                jobsQuestion = "Hol szerkeszthetem a frakciókat és a helyszíneket?",
                jobsAnswer = "Nyisd meg ezt: {path}, válassz egy frakciót, majd a Szerkesztés lehetőséget. Ott módosíthatod a beállításait és helyszíneit.",
                creatorsAnswer = "A szerkesztőket itt találod: {path}. Ezek a hivatkozások megnyitják a szerkesztőt; a frakcióeszközök használata frakcióválasztással kezdődik.",
                missingAnswer = "Az elérhető szerkesztők a kiválasztott erőforrástól és annak beállításaitól függenek. A frakcióeszközök az adott frakciónál érhetők el.",
                creators = {
                    mainbaseZones = "Válassz frakciót, és állítsd be a bázisának területét.",
                    presetTerritories = "Tekintsd át az előre megadott körzeteket, és válaszd ki az aktívakat.",
                    objectsSection = "Állandó kihallgatószékek és szerszámkocsik kezelése.",
                    blockedZonesSection = "Jelöld ki azokat a területeket, ahol nem helyezhetők el kihallgatási tárgyak.",
                    toolsSection = "Állítsd be a kihallgatások során elérhető eszközöket.",
                    sessionsSection = "Tekintsd meg a folyamatban lévő kihallgatásokat, és szükség esetén zárd le a munkameneteket.",
                    orphansSection = "Ellenőrizd és távolítsd el az elhagyott kihallgatási tárgyakat.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Válaszd ki, hogyan tárolják és kezelik a bűnöző szervezetek tagjait.",
                },
                territories = {
                    zones = "A(z) „Területi zónák” beállításai a(z) „Területek” szakaszban.",
                    ownership = "A(z) „Tulajdonlás” beállításai a(z) „Területek” szakaszban.",
                    decay = "A(z) „Fokozódás” beállításai a(z) „Területek” szakaszban.",
                    presence = "A(z) „Jelenlét” beállításai a(z) „Területek” szakaszban.",
                    activity = "A(z) „Tevékenység értékelése” beállításai a(z) „Területek” szakaszban.",
                    ownershipBenefits = "A(z) „Tulajdonosi bónuszok” beállításai a(z) „Területek” szakaszban.",
                },
                graffiti = {
                    general = "A(z) „Általános” beállításai a(z) „Graffiti” szakaszban.",
                    streaming = "A(z) „Renderelés” beállításai a(z) „Graffiti” szakaszban.",
                    moderation = "A(z) „Moderáció” beállításai a(z) „Graffiti” szakaszban.",
                },
                pvpEvents = {
                    pvpAvailability = "Szabályozza, hogy elérhető-e a PvP esemény alkalmazás, és hol jelenik meg.",
                    pvpAutomation = "Konfigurálja a visszatérő eseményeket és az automatikus indítást.",
                    pvpRuntime = "Kérelmek kezelése, halálok és újraindulások élő meccseken.",
                    pvpModes = "Konfigurálja a PvP tableten előre kiválasztott játékmódot.",
                    pvpArenas = "Létrehozza a körzati zónát, a megfigyelési pontot és a csapat szünetelő pontokat, amelyeket a PvP események használnak.",
                    pvpLimits = "Állítsa be a díjak és a tablet előzmények korlátait.",
                    pvpPermissions = "Az eseménykezelést és a pénzügyeket az ACE- és foglalkozási jogosultságokhoz rendeli.",
                    pvpTakeoverRules = "Vezérli a laboratóriumok és lakókocsik átvehetőségének elérhetőségét és a részvételi feltételeket.",
                    pvpTakeoverZones = "Állítsa be az interakció-, riasztás- és elfoglalási zónákat, valamint azok időtartamát.",
                    pvpTakeoverMethods = "Állítsa be, hogy mennyi idő alatt törhetik fel az egyes módszerekkel a bejáratot.",
                },
                drugs = {
                    creator = "Megnyitja a Sky Crime Drogkészítő menüt és bezárja a Feladat-konfigurátort.",
                    creatorSettings = "A(z) „Létrehozói beállítások” beállításai a(z) „Drogrendszer” szakaszban.",
                    interfaceHud = "A(z) „Felületi pozíciók” beállításai a(z) „Drogrendszer” szakaszban.",
                    drugsGeneral = "A(z) „Általános” beállításai a(z) „Drogrendszer” szakaszban.",
                    runtimeAccess = "A(z) „Hozzáférés és tulajdonlás” beállításai a(z) „Drogrendszer” szakaszban.",
                    runtimePayouts = "A(z) „Kifizetések” beállításai a(z) „Drogrendszer” szakaszban.",
                    runtimeDispatch = "A(z) „Leitstelle és rendőrség” beállításai a(z) „Drogrendszer” szakaszban.",
                    performanceInactiveControlIntervalMs = "A Teljesítmény / Inaktív vezérlési intervallum ms futási idejű beállítása.",
                    performanceInteractionIdleScanIntervalMs = "A Teljesítmény / Interakció üresjárati szkennelési intervallum ms futási idejű beállítása.",
                    performanceInteractionPromptIntervalMs = "A Teljesítmény / Interakció jelzési intervallum ms futási idejű beállítása.",
                    performanceInteractionScanIntervalMs = "A Teljesítmény / Interakció szkennelési intervallum ms futási idejű beállítása.",
                    performanceMinimumScanIntervalMs = "A Teljesítmény / Minimális szkennelési intervallum ms futási idejű beállítása.",
                    performanceStreetPedActivationDistance = "Futtatási beállítás a Teljesítmény / Utcai NPC aktiválási távolsághoz.",
                    performanceStreetPedIdleScanIntervalMs = "Futtatási beállítás a Teljesítmény / Utcai NPC pihenőidő ellenőrzési intervallumhoz (ms).",
                    performanceStreetPedScanIntervalMs = "Futtatási beállítás a Teljesítmény / Utcai NPC ellenőrzési intervallumhoz (ms).",
                    performanceWorldCachePadding = "A Teljesítmény / Világ gyorsítótár töltelése futási idejű beállítása.",
                    performanceWorldCacheRefreshIntervalMs = "A Teljesítmény / Világ gyorsítótár frissítési intervallum ms futási idejű beállítása.",
                    performanceWorldIdleIntervalMs = "A Teljesítmény / Világ / Üresjárati intervallum (ms) futási idejű beállítása.",
                },
                drugProduction = {
                    qualityWeights = "A(z) „Minőség súlyozása” beállításai a(z) „Drogtermelés” szakaszban.",
                    qualityTiers = "A(z) „Minőségi szintek” beállításai a(z) „Drogtermelés” szakaszban.",
                    packagingGeneral = "A(z) „Általános” beállításai a(z) „Drogtermelés” szakaszban.",
                    processingFlow = "A(z) „Folyamatmenet” beállításai a(z) „Drogtermelés” szakaszban.",
                    processingGeneral = "A(z) „Általános” beállításai a(z) „Drogtermelés” szakaszban.",
                },
                drugOperations = {
                    growingGeneral = "A(z) „Általános” beállításai a(z) „Drogüzemek” szakaszban.",
                    plantDefaults = "A(z) „Növények alapértelmezett értékei” beállításai a(z) „Drogüzemek” szakaszban.",
                    harvestWindow = "A(z) „Szüret ablaka” beállításai a(z) „Drogüzemek” szakaszban.",
                    labsGeneral = "A labor és a lakóautó futási példányainak engedélyezése.",
                    labRent = "A(z) „Bérleti díj és élettartam” beállításai a(z) „Drogüzemek” szakaszban.",
                    camperDefaults = "A(z) „Lakóautó” beállításai a(z) „Drogüzemek” szakaszban.",
                    labUpgrades = "A labor szint frissítési árának kiszámítására használt szorzó.",
                    labDefaults = "A(z) „Laborok alapértelmezett beállításai” beállításai a(z) „Drogüzemek” szakaszban.",
                    powerGeneral = "A(z) „Általános” beállításai a(z) „Drogüzemek” szakaszban.",
                    generators = "A(z) „Generátorok” beállításai a(z) „Drogüzemek” szakaszban.",
                    equipmentWear = "A feldolgozás által okozott felszerelési kopás globális szorzója.",
                    workersGeneral = "A(z) „Általános” beállításai a(z) „Drogüzemek” szakaszban.",
                    cultivationGeneral = "A(z) „Általános” beállításai a(z) „Drogüzemek” szakaszban.",
                    cultivationCurve = "Állítsa be minden termesztési szint címét és az összes XP küszöbértékét.",
                    cultivationExperience = "Állítsa be, hogy mennyi termesztési XP-t ad minden növekedési cselekvés.",
                    cultivationUnlocks = "Állítsa be a szükséges termesztési szintet konténerekhez, alapanyagokhoz, felszereléshez, fajtákhoz és szkenner szintekhez.",
                    powerRuntime = "A generátor fogyasztása és az erőforrás-signatúra frissítései közötti időköz másodpercben.",
                    powerHeat = "A(z) „Figyelem és áramjelzés” beállításai a(z) „Drogüzemek” szakaszban.",
                    powerModes = "A(z) „Kezelési módok” beállításai a(z) „Drogüzemek” szakaszban.",
                    powerPriorities = "A(z) „Terhelési prioritások” beállításai a(z) „Drogüzemek” szakaszban.",
                },
                drugMarketRisk = {
                    marketGeneral = "A(z) „Általános” beállításai a(z) „Piac és kockázat” szakaszban.",
                    marketPrices = "A(z) „Árak” beállításai a(z) „Piac és kockázat” szakaszban.",
                    distribution = "A(z) „Elosztás” beállításai a(z) „Piac és kockázat” szakaszban.",
                    threatsGeneral = "A(z) „Általános” beállításai a(z) „Piac és kockázat” szakaszban.",
                    threatHeat = "A(z) „Hőmérséklet” beállításai a(z) „Piac és kockázat” szakaszban.",
                    threatChances = "A(z) „Lehetőségek” beállításai a(z) „Piac és kockázat” szakaszban.",
                    consumptionGeneral = "A(z) „Általános” beállításai a(z) „Piac és kockázat” szakaszban.",
                    consumerDecay = "A(z) „Tolerancia és függőség csökkenése” beállításai a(z) „Piac és kockázat” szakaszban.",
                    consumerEffects = "A(z) „Hatások és kockázatok” beállításai a(z) „Piac és kockázat” szakaszban.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Futóképes beállítás a Dinamikus piac / Akció / Hűtési időhöz (másodperc).",
                    dynamicMarketActionHistoryLimit = "Futtatásidejű beállítás a Dinamikus piac / Akció / Történeti korláthoz.",
                    dynamicMarketAmountSaturationWeight = "Futtatásidejű beállítás a Dinamikus piac / Mennyiség / Piaci telítettség / Súlyhoz.",
                    dynamicMarketBaseIntelAccuracy = "Futtatásidejű beállítás a Dinamikus piac / Alapinformációk pontosságához.",
                    dynamicMarketDefaultAverageQuality = "Futtatásidejű beállítás a Dinamikus piac / Alapértelmezett átlagos minőséghez.",
                    dynamicMarketDefaultResourceElasticity = "Futtatásidejű beállítás a Dinamikus piac / Alapértelmezett erőforrás / Rugalmassághoz.",
                    dynamicMarketDemandCenter = "Futtatásidejű beállítás a Dinamikus piac / Kereslet / Központ.",
                    dynamicMarketDemandPriceImpact = "Futtatásidejű beállítás a Dinamikus piac / Kereslet / Ár / Hatáshoz.",
                    dynamicMarketDirectionThreshold = "Futtatásidejű beállítás a Dinamikus piac / Irány / Küszöbérték.",
                    dynamicMarketEnabled = "Futtatásidejű beállítás a Dinamikus piac / Engedélyezve.",
                    dynamicMarketEventChance = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Esély.",
                    dynamicMarketEventDurationMinutes = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Időtartam / Perc.",
                    dynamicMarketEventMinimumDurationMinutes = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Minimális időtartam / Perc.",
                    dynamicMarketEventStrengthMaximum = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Erő / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Erő / Minimum.",
                    dynamicMarketEvents = "A(z) „Események” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketExactIntelReputation = "Beállítás a Dinamikus piac / Pontos információ / Reputációhoz.",
                    dynamicMarketExactIntelTrust = "Beállítás a Dinamikus piac / Pontos információ / Bizalomhoz.",
                    dynamicMarketGlobalZoneLabel = "Dinamikus piac / Globális zóna címke futási beállítása.",
                    dynamicMarketHistoryLimit = "Dinamikus piac / Előzmények limit futási beállítása.",
                    dynamicMarketInitialDemand = "Dinamikus piac / Kezdeti kereslet futási beállítása.",
                    dynamicMarketInitialPriceMultiplier = "Dinamikus piac / Kezdeti árszorzó futási beállítása.",
                    dynamicMarketIntelDemandError = "Dinamikus piac / Információs kereslet hiba futási beállítása.",
                    dynamicMarketIntelMaximumAccuracy = "Dinamikus piac / Információk maximális pontossága futási beállítása.",
                    dynamicMarketIntelMinimumAccuracy = "Dinamikus piac / Információk minimális pontossága futási beállítása.",
                    dynamicMarketIntelPoliceError = "Dinamikus piac / Információs rendőrségi hiba futási beállítása.",
                    dynamicMarketIntelPriceError = "Dinamikus piac / Információs ár hiba futási beállítása.",
                    dynamicMarketIntelPriceMaximum = "Dinamikus piac / Információs ár maximum futási beállítása.",
                    dynamicMarketIntelPriceMinimum = "Dinamikus piac / Információs ár minimum futási beállítása.",
                    dynamicMarketIntelReputationWeight = "Dinamikus piac / Információs hírnév súlyozás futási beállítása.",
                    dynamicMarketIntelResourcePriceError = "Dinamikus piac / Intel erőforrás-ár hiba futásidejű beállítása.",
                    dynamicMarketIntelSaturationError = "Dinamikus piac / Intel telítettség hiba futásidejű beállítása.",
                    dynamicMarketIntelSeedBucketSeconds = "Dinamikus piac / Intel magvető kosár másodperc futásidejű beállítása.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Dinamikus piac / Intel állapot pontosság küszöb futásidejű beállítása.",
                    dynamicMarketIntelStatusErrorThreshold = "Dinamikus piac / Intel állapot hiba küszöb futásidejű beállítása.",
                    dynamicMarketIntelSupplyError = "Dinamikus piac / Intel ellátás hiba futásidejű beállítása.",
                    dynamicMarketIntelTrustWeight = "Dinamikus piac / Intel bizalom súlyozás futásidejű beállítása.",
                    dynamicMarketManipulationCooldownMinutes = "Dinamikus piac / Manipuláció hűtőidő perc futásidejű beállítása.",
                    dynamicMarketManipulationDemandShift = "Dinamikus piac / Manipuláció kereslet eltolás futásidejű beállítása.",
                    dynamicMarketManipulationDurationMinutes = "Dinamikus piac / Manipuláció időtartam perc futásidejű beállítása.",
                    dynamicMarketManipulationHeat = "Dinamikus piac / Manipuláció hőfok futásidejű beállítása.",
                    dynamicMarketManipulationMinimumBatchAmount = "Dinamikus piac / Manipuláció minimális tétel mértékegység futásidejű beállítása.",
                    dynamicMarketManipulationPaymentAccount = "Dinamikus piac / Manipuláció fizetési fiók futásidejű beállítása.",
                    dynamicMarketManipulationPrice = "Dinamikus piac / Manipuláció ár futásidejű beállítása.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Dinamikus piac / Manipuláció zóna hőfok szorzó futásidejű beállítása.",
                    dynamicMarketMaximumIntelAgeMinutes = "Dinamikus piac / Maximális intel kor perc futásidejű beállítása.",
                    dynamicMarketMaximumPriceMultiplier = "Dinamikus piac / Maximális árszorzó futásidejű beállítása.",
                    dynamicMarketMinimumIntelAgeMinutes = "Dinamikus piac / Minimális intel kor perc futásidejű beállítása.",
                    dynamicMarketMinimumMetricWindowMinutes = "Dinamikus piac / Minimális mérési ablak / Perc futási beállítása.",
                    dynamicMarketMinimumPriceMultiplier = "Dinamikus piac / Minimális árszorzó futási beállítása.",
                    dynamicMarketMinimumUpdateMinutes = "Dinamikus piac / Minimális frissítés / Perc futási beállítása.",
                    dynamicMarketPoliceDemandWeight = "Dinamikus piac / Rendőrségi igény súlyozása futási beállítása.",
                    dynamicMarketPolicePriceImpact = "Dinamikus piac / Rendőrségi árszabás hatása futási beállítása.",
                    dynamicMarketPoorQualityDemandPenalty = "Dinamikus piac / Alacsony minőségű igény büntetése futási beállítása.",
                    dynamicMarketPoorQualityThreshold = "Dinamikus piac / Alacsony minőségű küszöb futási beállítása.",
                    dynamicMarketPremiumQualityDemandBonus = "Dinamikus piac / Prémium minőségű igény bónusz futási beállítása.",
                    dynamicMarketPremiumQualityThreshold = "Dinamikus piac / Prémium minőségű küszöb futási beállítása.",
                    dynamicMarketProductionSupplyWeight = "Dinamikus piac / Termelési ellátás súlyozása futási beállítása.",
                    dynamicMarketProductionWindowMinutes = "Dinamikus piac / Termelési ablak / Perc futási beállítása.",
                    dynamicMarketQualityCenter = "Dinamikus piac / Minőség középérték futási beállítása.",
                    dynamicMarketQualityConfidenceImpact = "Dinamikus piac / Minőség bizalom hatása futási beállítása.",
                    dynamicMarketQualityRange = "Dinamikus piac / Minőség tartomány futási beállítása.",
                    dynamicMarketRarityBonusMaximum = "Dinamikus piac / Ritkaság bónusz maximum futási beállítása.",
                    dynamicMarketRegionalGlobalWeight = "Dinamikus piac / Regionális globális súlyozás futási beállítása.",
                    dynamicMarketRegionalLocalWeight = "Dinamikus piac / Regionális lokális súlyozás futási beállítása.",
                    dynamicMarketResourceAliases = "A(z) „Erőforrás aliasok” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketResourceDirectionFallThreshold = "Futtatási beállítás a Dinamikus Piac / Erőforrás-irány / Esés / Küszöbérték számára.",
                    dynamicMarketResourceDirectionRiseThreshold = "Futtatási beállítás a Dinamikus Piac / Erőforrás-irány / Emelkedés / Küszöbérték számára.",
                    dynamicMarketResources = "A(z) „Erőforrások” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketSalesWindowMinutes = "Dinamikus Piac / Eladások / Időablak / Perc futtatási idejű beállítása.",
                    dynamicMarketSaturationDemandWeight = "Dinamikus Piac / Telítettség / Kereslet / Súly futtatási idejű beállítása.",
                    dynamicMarketSaturationPriceImpact = "Dinamikus Piac / Telítettség / Ár / Hatás futtatási idejű beállítása.",
                    dynamicMarketScarcityDemandWeight = "Dinamikus Piac / Ritkaság / Kereslet / Súly futtatási idejű beállítása.",
                    dynamicMarketScarcityPriceImpact = "Dinamikus Piac / Ritkaság / Ár / Hatás futtatási idejű beállítása.",
                    dynamicMarketSeasonEndMonths = "A(z) „Évszakvégi hónapok” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketSeasonMultipliers = "A(z) „Évszaki szorzók” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketShortageRumorThreshold = "Dinamikus Piac / Hiány / Pletyka / Küszöb futtatási idejű beállítása.",
                    dynamicMarketStatusThresholds = "A(z) „Státusz küszöbértékek” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketTargetSupply = "Dinamikus piac / Cél / Ellátás futási idejű beállítása.",
                    dynamicMarketTrendChance = "Dinamikus piac / Trend / Esély futási idejű beállítása.",
                    dynamicMarketTrendDurationMinutes = "Futtárrendszer beállítás: Dinamikus piac / Trend időtartam (perc).",
                    dynamicMarketTrendMaximumStrength = "Futtárrendszer beállítás: Dinamikus piac / Trend maximális erősség.",
                    dynamicMarketTrendMinimumStrength = "Futtárrendszer beállítás: Dinamikus piac / Trend minimális erősség.",
                    dynamicMarketUpdateMinutes = "Futtárrendszer beállítás: Dinamikus piac / Frissítés perc.",
                    dynamicMarketVolatilityMaximum = "Futtárrendszer beállítás: Dinamikus piac / Volatilitás maximum.",
                    dynamicMarketVolatilityMinimum = "Futtárrendszer beállítás: Dinamikus piac / Volatilitás minimum.",
                    dynamicMarketWeatherMultipliers = "A(z) „Időjárási szorzók” beállításai a(z) „Droghálózatok” szakaszban.",
                    dynamicMarketWeatherState = "Futtárrendszer beállítás: Dinamikus piac / Időjárás állapota.",
                    heatActionCooldownSeconds = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Akció hűtési idő (másodperc).",
                    heatActivityRiskWeights = "A(z) „Tevékenység kockázati súlyai” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatAggressiveHeatMultiplier = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Aggresszív fahndozási nyomás-multiplikátor.",
                    heatBurnerBurnThreshold = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) leégési küszöb.",
                    heatBurnerHeatPerWholesale = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) fahndozási nyomás / Nagykereskedelmi üzletenként.",
                    heatBurnerPhoneItem = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) tárgy.",
                    heatCamperOperationalHeatMultiplier = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás-multiplikátor.",
                    heatCamperOperationalHeatThreshold = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás küszöb.",
                    heatCamperParkedHeat = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Parkolt lakókocsi fahndozási nyomás.",
                    heatContaminatedHeatMultiplier = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Szennyezett fahndozási nyomás-multiplikátor.",
                    heatContaminatedThreshold = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Szennyezett fahndozási nyomás-küszöb.",
                    heatCultivationFreePlants = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Ültetés / Kockázatmentes növények szinthez.",
                    heatCultivationHeatPerPlant = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Ültetés / Fahndungsnyomás növényenként szinthez.",
                    heatDealerHiddenMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Üzlet / Rejtőzködés ideje (perc) szinthez.",
                    heatDecayPerTick = "A(z) „Csökkenés ciklusonként” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatEnabled = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Engedélyezve szinthez.",
                    heatEnforcementHeat = "A(z) „Végrehajtási nyomás” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatEnforcementMultipliers = "A(z) „Végrehajtási szorzók” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatEntityTypes = "A(z) „Entitás típusok” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatEventCooldownMinutes = "Futási idejű beállítás a Hőmérséklet és Kockázat / Esemény / Hűtési idő (perc)hez.",
                    heatEventHistoryLimit = "Futási idejű beállítás a Hőmérséklet és Kockázat / Esemény / Történeti korláthoz.",
                    heatLabHeatSyncThreshold = "Futási idejű beállítás a Hőmérséklet és Kockázat / Labor / Végrehajtási nyomás szinkronizálási küszöbértékhez.",
                    heatLayLowCooldownMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Hűtési idő (perc) beállításához.",
                    heatLayLowIdleMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Üresjárati idő (perc) beállításához.",
                    heatLayLowReduction = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Csökkentés beállításához.",
                    heatLockdownMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Zárkózás / Hűtési idő (perc) beállításához.",
                    heatMinimumDurationMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális időtartam (perc) beállításához.",
                    heatMinimumEventCooldownSeconds = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális eseményhűtési idő (másodperc) beállításához.",
                    heatMinimumIdleSeconds = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális üresjárati idő (másodperc) beállításához.",
                    heatProcessingHeatMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Feldolgozási hőszorzó beállításához.",
                    heatRiskWeights = "A(z) „Kockázati súlyok” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatRotateBurnerReduction = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Égető telefon cseréje / Csökkentés számára.",
                    heatRouteControlMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Útvonal-irányítás / Perc számára.",
                    heatSaleHeat = "A(z) „Eladási nyomás” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatThresholds = "A(z) „Küszöbértékek” beállításai a(z) „Droghálózatok” szakaszban.",
                    heatTickMinutes = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Frissítési ciklus / Perc paraméterhez.",
                    heatWholesaleHeatMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Nagykereskedelmi Fahndungsnyomás-szorzó paraméterhez.",
                    heatWorkerLeakAlertRadius = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Riasztási sugár paraméterhez.",
                    heatWorkerLeakBaseChance = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Alapérték / Esély paraméterhez.",
                    heatWorkerLeakFactionMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Frakciós Szorzó paraméterhez.",
                    heatWorkerLeakHighSeverityThreshold = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Magas Súlyosság Küszöb paraméterhez.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Esély Szorzó paraméterhez.",
                    heatWorkerLeakLoyaltyThreshold = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Küszöb paraméterhez.",
                    heatWorkerLeakMaximumChance = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Maximális Esély paraméterhez.",
                    heatWorkerLeakMinimumCooldownSeconds = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Hűtési Idő (Másodperc) paraméterhez.",
                    heatWorkerLeakRouteMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Útvonal Szorzó paraméterhez.",
                    heatWorkerLeakStrengthMaximum = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Maximális paraméterhez.",
                    heatWorkerLeakStrengthMinimum = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Erő paraméterhez.",
                    heatWorkerLeakStrengthMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Szorzó paraméterhez.",
                    heatWorkerLeakStressChanceMultiplier = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Stressz Esély Szorzó paraméterhez.",
                    heatWorkerLeakStressThreshold = "Folyamatidejű beállítás a Hő és Kockázat / Munkavállalói Adatvétség Stressz Küszöbértékéhez.",
                    contactsActionCooldownSeconds = "Folyamatidei beállítás a Kontakthálózat / Akció Hűtési Időhöz (Másodperc).",
                    contactsActiveHotspotCount = "Folyamatidei beállítás a Kontakthálózat / Aktív Forrópontok Számához.",
                    contactsBurnerHintTrust = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Tipp Bizalomhoz.",
                    contactsBurnerOfferMaximumMultiplier = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Maximális Szorzóhoz.",
                    contactsBurnerOfferMinimumMultiplier = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Minimális Szorzóhoz.",
                    contactsBuyerCooldownMinutes = "Folyamatidei beállítás a Kontakthálózat / Vásárló Hűtési Időhöz (Perc).",
                    contactsBuyerDeliveryDistance = "Folyamatidei beállítás a Kontakthálózat / Vásárló Szállítási Távolsághoz.",
                    contactsBuyerPremiumSuccessScore = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Prémium Sikeres Pontszámhoz.",
                    contactsBuyerPremiumTrustGain = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Prémium Bizalom Nyereséghez.",
                    contactsBuyerRequestHeatRiskWeight = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Kérés Hő és Kockázat Súlyozáshoz.",
                    contactsBuyerStandardTrustGain = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Alapvető Bizalom Nyereséghez.",
                    contactsContactActiveDelaySeconds = "A(z) „Kontakt aktiválási késleltetés másodpercben” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsContactDemandRange = "A(z) „Kontakt kereslet tartomány” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsContactLossTrust = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Bizalomvesztéshez.",
                    contactsDarknetExactIntelMinutes = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Pontos Intel Percéhez.",
                    contactsDarknetHotspotIntelPrice = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Forrópont Intel Árhoz.",
                    contactsDarknetIntelPrice = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Intel Árhoz.",
                    contactsDealerBasePrice = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Alapárhoz.",
                    contactsDealerHireCapacity = "A(z) „Díler felvételi kapacitása” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDealerHireRisk = "A(z) „Díler felvételi kockázata” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDealerHireSkill = "A(z) „Díler felvételi készsége” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDealerOffers = "A(z) „Díler ajánlatok” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDealerProtectionHours = "Kapcsolati Hálózat / Kereskedői Védettség óráinak futási beállítása.",
                    contactsDealerProtectionPrice = "Kapcsolati Hálózat / Kereskedői Védettség árának futási beállítása.",
                    contactsDealerSaleMax = "Kapcsolati Hálózat / Kereskedői Eladás maximumának futási beállítása.",
                    contactsDealerSaleMin = "Kapcsolati Hálózat / Kereskedői Eladás minimumának futási beállítása.",
                    contactsDealerSimulation = "A(z) „Díler szimuláció” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDealerTickMinutes = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Ciklusperchez.",
                    contactsDealerWage = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Bérhez.",
                    contactsDealerWageDecay = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Bér Csökkenéséhez.",
                    contactsDealerWageLoyaltyGain = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő bére hűség nyereségéhez.",
                    contactsDealerWeaknesses = "A(z) „Díler gyengeségei” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsDefaultContactDemand = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kapcsolati kereslethez.",
                    contactsDefaultContactRisk = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kapcsolati kockázathoz.",
                    contactsDefaultDealerCapacity = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői kapacitáshoz.",
                    contactsDefaultDealerRisk = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői kockázathoz.",
                    contactsDefaultDealerSkill = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői készséghez.",
                    contactsDefaultHotspotRadius = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett forró pont sugarához.",
                    contactsDemandResetMinutes = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereslet újraindítása (perc)hez.",
                    contactsEnabled = "Futtatás idejű beállítás a Kapcsolati hálózat / Engedélyezve.",
                    contactsExactLocationTrust = "Futtatás idejű beállítás a Kapcsolati hálózat / Pontos hely / Bizalomhoz.",
                    contactsFactionDiscoveryReputation = "Futtatás idejű beállítás a Kapcsolati hálózat / Frakció felfedezés hírnevéhez.",
                    contactsFactionHintTrust = "Futtatás idejű beállítás a Kapcsolati hálózat / Frakció tipp / Bizalomhoz.",
                    contactsFailedDeliveryCooldownMinutes = "Futtatás idejű beállítás a Kapcsolati hálózat / Sikertelen szállítás várakozási idő (perc)hez.",
                    contactsFakeDealEncounter = "A(z) „Csaló üzlet találkozó” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsFallbackPreferredDrug = "Futtatási beállítás a Kapcsolati Hálózat / Visszacsatolás Preferált Drog részére.",
                    contactsFallbackProductLabel = "Futtatási beállítás a Kapcsolati Hálózat / Visszacsatolás Termékkijelző részére.",
                    contactsGuideBookItem = "Futtatási beállítás a Kapcsolati Hálózat / Útmutatókönyv Tétel részére.",
                    contactsGuideBookTrust = "Futtatási beállítás a Kapcsolati Hálózat / Útmutatókönyv Bizalom részére.",
                    contactsHireDealerPrice = "Futtatási beállítás a Kapcsolati Hálózat / Bérelt Diler Ár részére.",
                    contactsHistoryLimit = "Futtatási beállítás a Kapcsolati Hálózat / Történeti Korlát részére.",
                    contactsHotspotIntelMinutes = "Futtatási beállítás a Kapcsolati Hálózat / Forrópont Intelligencia Perc részére.",
                    contactsHotspotRotationMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Forrópont Forgatás Percéhez.",
                    contactsListingDurationMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Listázás Időtartama (perc) részére.",
                    contactsMaxOwnedDealers = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Maximális Tulajdonos Diler részére.",
                    contactsMinimumBuyerDeliveryDistance = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Vásárló Szállítási Távolság részére.",
                    contactsMinimumContactRotationMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Kapcsolat Forgatás Időtartama (perc) részére.",
                    contactsMinimumDemandResetMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Kereslet Újraindítás Időtartama (perc) részére.",
                    contactsMinimumHeatMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Figyelem Szint Szorzó részére.",
                    contactsMinimumHotspotIntelMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Információ Időtartama (perc) részére.",
                    contactsMinimumHotspotRadius = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Sugár részére.",
                    contactsMinimumHotspotRotationMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Forgatás Időtartama (perc) részére.",
                    contactsMinimumListingDurationMinutes = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Listázás Időtartama (perc) részére.",
                    contactsMinimumRewardMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Díj Szorzó részére.",
                    contactsMinimumRobberyMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Rablás Szorzó részére.",
                    contactsMinimumSpotPriceMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Helyi Ár Szorzó részére.",
                    contactsOtherDrugPriceMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Egyéb Drog Ár Szorzó részére.",
                    contactsPaymentAccount = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Fizetési Számla részére.",
                    contactsPostDeliveryDemandResetSeconds = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Szállítást követő kereslet-visszaállítás (másodperc) részére.",
                    contactsPreferredDrugPriceMultiplier = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Preferált drog Ár szorzó részére.",
                    contactsRegionLocationTrust = "A Kapcsolati hálózat / Régió / Elhelyezkedés / Bizalom futásiidős beállítása.",
                    contactsRequestAmounts = "A(z) „Kérési mennyiségek” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsRotationMinutes = "A Kapcsolati hálózat / Forgatás / Perc futásiidős beállítása.",
                    contactsSpotPools = "A(z) „Helyszíni poolok” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsStreetHotspots = "A(z) „Utcai forrópontok” beállításai a(z) „Droghálózatok” szakaszban.",
                    contactsTrustLevels = "A(z) „Bizalmi szintek” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessActionCooldownSeconds = "Időjárás beállítása a Vállalati Hálózat / Cselekvés-hűtőidő / Másodperc esetén",
                    businessBalance = "A(z) „Egyenleg” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessContracts = "A(z) „Szerződések” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessDefaultBusinessName = "Az Üzleti hálózat / Alapértelmezett üzleti név futási beállítása.",
                    businessDefaultRankId = "Az Üzleti hálózat / Alapértelmezett rang ID futási beállítása.",
                    businessDefaultStaffStyle = "Az Üzleti hálózat / Alapértelmezett személyzet stílus futási beállítása.",
                    businessDefaultTransport = "Az Üzleti hálózat / Alapértelmezett közlekedés futási beállítása.",
                    businessEnabled = "Az Üzleti hálózat / Engedélyezve futási beállítása.",
                    businessHubs = "A(z) „Központok” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessLimits = "A(z) „Korlátok” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessPayments = "Válaszd ki, melyik egyenleg fizeti ki a Hálózati Üzlet vásárlásait és üzemeltetési költségeit.",
                    businessPayoutAccount = "Üzleti hálózat / Kifizetési fiók futási idejű beállítása.",
                    businessRanks = "A(z) „Rangok” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessReportDays = "Futtatási beállítás az Üzleti Hálózat / Jelentési Napokhoz.",
                    businessRouteEndpointTypes = "A(z) „Útvonal végpont típusok” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessRuntime = "A(z) „Futtatás ideje” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessSocietyPermission = "Futtatási beállítás az Üzleti hálózat / Társadalmi engedély-hez.",
                    businessStaff = "A(z) „Személyzet” beállításai a(z) „Droghálózatok” szakaszban.",
                    businessTickMinutes = "Futtatási beállítás az Üzleti hálózat / Ciklusidő / Perc-hez.",
                    businessTransports = "A(z) „Szállítások” beállításai a(z) „Droghálózatok” szakaszban.",
                },
                robbery = {
                    atmAvailability = "Az önálló ATM rablás rendszerének engedélyezése vagy letiltása.",
                    atmLocations = "A rabláshoz elérhető, szerveren engedélyezett ATM helyszínek kezelése.",
                    atmPolice = "A rablás indításához szükséges szolgálatban lévő rendőrök beállítása.",
                    atmItems = "Állítsd be a szükséges fúró, vontatóheveder és robbanótöltet tárgyakat.",
                    atmActionTimes = "Az rögzítés, telepítés, robbantás és kifosztás cselekményeinek időtartamának beállítása.",
                    atmTimeouts = "Az áttört ATM kifosztásához rendelkezésre álló időtartamának szabályozása.",
                    atmPayout = "A célszámla és a véletlenszerű jutalom tartományának beállítása.",
                    atmDistances = "A játékos és járművel történő ATM-interakciókhoz használt határok beállítása.",
                    atmExplosionEffects = "A robbantás során használt robbanóanyag natív paraméterek konfigurálása.",
                    atmDispatchAlert = "A rendőrségi riasztás sugarának, élettartamának és prioritásának beállítása.",
                    atmDispatchRecipients = "Válaszd ki, melyik foglalkozás neve kap ATM rablási riasztást.",
                    shopAvailability = "Aktiválja a rablásokat és állítsa be a rendőrségi követelményt.",
                    shopTiming = "Állítsa be a megfélemlítést, a cselekvéseket, az időtúllépési időt és a hűtési időt.",
                    shopSafe = "Állítsa be a kódpróbákat és a fúrógép tárgyát.",
                    shopRegisterReward = "Állítsa be a véletlen jutalmat minden pultnál.",
                    shopSafeReward = "Állítsa be a véletlen pénztárcajutalmat.",
                    shopDispatchSettings = "Állítsa be a címzettjeket és a riasztási tulajdonságokat.",
                    shopLocationTable = "Vezérli a személyzettel ellátott üzleteket és a pénztárcákat.",
                    pickpocketAvailability = "Aktiválja a funkciót, és opcionálisan korlátozza a konfigurált bűnügyi foglalkozásokra.",
                    pickpocketGameplay = "Válaszd ki a kihívást és a független menekülési, vészhelyzeti hívási és ellenállási valószínűségeket.",
                    pickpocketItemRewards = "Szabályozza az üres zsebeket és a látható tárgyválasztásokat a 0,0001 százalékos határig.",
                    pickpocketMoney = "Konfigurálja a szerver által generált véletlenszerű készpénz tartományt.",
                    pickpocketDistances = "Állítsa be az NPC hatótávolságot, amelyet a közös körzati és célpontrendszer használ.",
                    pickpocketRateLimits = "Szabályozza a kérelmezési korlátozást, az NPC hűtési időt és a munkamenet lejáratát.",
                    pickpocketDispatchSettings = "Konfigurálja a figyelmeztetést, amikor egy NPC hívja a rendőrséget.",
                    heistCrafting = "Válaszd ki, mennyi erőforrás szükséges a heist felszerelés előállításához. Érvényes a Bűnügyi Rendszer összes új kísérletére.",
                    heistCreatorMenu = "Moduláris heistek létrehozása, szerkesztése és közzététele a dedikált Heist Creatorban.",
                    heistExecution = "Indítási ablak, inaktivitás és hűtési idő a heist futtatásokhoz.",
                    npcPoliceSupport = "Ez a funkció ideiglenesen letiltva van stabilitási problémák miatt, és jelenleg nem aktiválható a Foglalkozás Konfigurátorban.",
                },
                baseRaids = {
                    baseRaids = "Raid hozzáférés, előfeltételek és egyéni kiválasztható kifosztási kategóriák. Nyitott raidoknál nincs szállítási időkorlát.",
                },
                weapons = {
                    weaponCreatorMenu = "Kezeld a fegyverútvonalakat és a pénzmosást egy szerkesztőben.",
                    weaponRuntime = "Állítsa be a fegyverútvonalak elérhetőségét és hozzáférési jogosultságait.",
                    weaponDefaultsgeneral = "A(z) „Általános alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponDefaultsaccess = "A(z) „Hozzáférési alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponDefaultscollection = "A(z) „Gyűjtési alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponDefaultsproduction = "A(z) „Gyártási alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponDefaultsmarket = "A(z) „Piaci alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponDefaultsdelivery = "A(z) „Megbízási alapértékek” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                    weaponStreet = "A(z) „Utcai fegyvereladás” beállításai a(z) „Fegyverútvonalak” szakaszban.",
                },
                darknetMarket = {
                    darknetAvailability = "Igazolja a tablet alkalmazást és elhelyezését.",
                    darknetEconomy = "Konfigurálja a pénztárci egyenlegeket, a érmék árfolyamát és a fizetési rátákat.",
                    darknetListings = "Szabályozza az ajánlati korlátokat, az árakat és az automatikus lejáratot.",
                    darknetChat = "Korlátozza a titkosított piactéri üzeneteket.",
                    darknetIdentity = "Konfigurálja az identitásváltást, a hitelesítést és az átverési figyelmeztetéseket.",
                    darknetDelivery = "Konfigurálja a személyes találkozókat és a lopható dobozokat a világban.",
                    darknetDeliveryLocations = "Konfigurálja azokat a helyszíneket, amelyeket a BlackBay NPC-kereskedés során véletlenszerűen választ ki.",
                    darknetPolice = "Azok a foglalkozási csoportok, amelyek csapdákat közzétehetnek és vizsgálatokat nézhetnek meg.",
                    darknetNpcTraders = "Állandó NPC-vásárlók és -eladók konfigurálható kockázattal.",
                },
                interrogation = {
                    general = "A(z) „Általános” beállításai a(z) „Kikérdezés” szakaszban.",
                    consent = "A(z) „Játékosvédelem” beállításai a(z) „Kikérdezés” szakaszban.",
                    objects = "A(z) „Objektumok” beállításai a(z) „Kikérdezés” szakaszban.",
                    grab = "A(z) „Megszállás” beállításai a(z) „Kikérdezés” szakaszban.",
                    session = "A(z) „Adminisztrátor ACE” beállításai a(z) „Kikérdezés” szakaszban.",
                    dispatch = "A(z) „Rendőrségi figyelmeztetések” beállításai a(z) „Kikérdezés” szakaszban.",
                    logging = "A(z) „Naplózás” beállításai a(z) „Kikérdezés” szakaszban.",
                    security = "A(z) „Biztonság” beállításai a(z) „Kikérdezés” szakaszban.",
                    presentation = "A(z) „Bemutatás” beállításai a(z) „Kikérdezés” szakaszban.",
                },
                reputation = {
                    crimeReputation = "A(z) „Reputáció” beállításai a(z) „Reputáció” szakaszban.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Általános", description = "Állítsa be a fegyverútvonalak elérhetőségét és hozzáférési jogosultságait." },
                weaponCreatorMenu = { label = "Illegális üzleti Teremtő", description = "Kezeld a fegyverútvonalakat és a pénzmosást egy szerkesztőben." },
                atmActionTimes = {
                    description = "Az rögzítés, telepítés, robbantás és kifosztás cselekményeinek időtartamának beállítása.",
                    label = "Cselekmény időtartamok",
                },
                atmAvailability = {
                    description = "Az önálló ATM rablás rendszerének engedélyezése vagy letiltása.",
                    label = "Elérhetőség",
                },
                atmDispatchAlert = {
                    description = "A rendőrségi riasztás sugarának, élettartamának és prioritásának beállítása.",
                    label = "Riasztás tulajdonságai",
                },
                atmDispatchRecipients = {
                    description = "Válaszd ki, melyik foglalkozás neve kap ATM rablási riasztást.",
                    label = "Címzettek",
                },
                atmDistances = {
                    description = "A játékos és járművel történő ATM-interakciókhoz használt határok beállítása.",
                    label = "Interakciós határok",
                },
                atmExplosionEffects = {
                    description = "A robbantás során használt robbanóanyag natív paraméterek konfigurálása.",
                    label = "Robbantás hatásai",
                },
                atmItems = {
                    description = "Állítsd be a szükséges fúró, vontatóheveder és robbanótöltet tárgyakat.",
                    label = "Szükséges elemek",
                },
                atmLocations = {
                    description = "A rabláshoz elérhető, szerveren engedélyezett ATM helyszínek kezelése.",
                    label = "ATM helyszínek",
                },
                atmPayout = {
                    description = "A célszámla és a véletlenszerű jutalom tartományának beállítása.",
                    label = "Kifizetés",
                },
                atmPolice = {
                    description = "A rablás indításához szükséges szolgálatban lévő rendőrök beállítása.",
                    label = "Rendőrségi előfeltétel",
                },
                atmPulling = {
                    description = "Az falból kihúzott ATM-hoz szükséges járműmozgás beállítása.",
                    label = "Kihúzás észlelése",
                },
                atmTimeouts = {
                    description = "Az áttört ATM kifosztásához rendelkezésre álló időtartamának szabályozása.",
                    label = "Kifosztási időkorlát",
                },
                baseRaids = {
                    description = "Raid hozzáférés, előfeltételek és egyéni kiválasztható kifosztási kategóriák. Nyitott raidoknál nincs szállítási időkorlát.",
                    label = "Bázis raidok",
                },
                businessPayments = {
                    description = "Válaszd ki, melyik egyenleg fizeti ki a Hálózati Üzlet vásárlásait és üzemeltetési költségeit.",
                    label = "Kifizetések",
                },
                crimeMembership = {
                    description = "Válaszd ki, hogyan tárolják és kezelik a bűnöző szervezetek tagjait.",
                    label = "Taglétesítési modell",
                },
                darknetAvailability = {
                    description = "Igazolja a tablet alkalmazást és elhelyezését.",
                    label = "Elérhetőség",
                },
                darknetChat = {
                    description = "Korlátozza a titkosított piactéri üzeneteket.",
                    label = "Privát csevegés",
                },
                darknetDelivery = {
                    description = "Konfigurálja a személyes találkozókat és a lopható dobozokat a világban.",
                    label = "Átvétel és titkos pontok",
                },
                darknetDeliveryLocations = {
                    description = "Konfigurálja azokat a helyszíneket, amelyeket a BlackBay NPC-kereskedés során véletlenszerűen választ ki.",
                    label = "Átvételi helyek",
                },
                darknetEconomy = {
                    description = "Konfigurálja a pénztárci egyenlegeket, a érmék árfolyamát és a fizetési rátákat.",
                    label = "Kriptovaluta",
                },
                darknetIdentity = {
                    description = "Konfigurálja az identitásváltást, a hitelesítést és az átverési figyelmeztetéseket.",
                    label = "Álnévek és hírnév",
                },
                darknetListings = {
                    description = "Szabályozza az ajánlati korlátokat, az árakat és az automatikus lejáratot.",
                    label = "Ajánlatok és lejárat",
                },
                darknetNpcTraders = {
                    description = "Állandó NPC-vásárlók és -eladók konfigurálható kockázattal.",
                    label = "NPC-kereskedők",
                },
                darknetPolice = {
                    description = "Azok a foglalkozási csoportok, amelyek csapdákat közzétehetnek és vizsgálatokat nézhetnek meg.",
                    label = "Rendőrségi hozzáférés",
                },
                heistCrafting = {
                    description = "Válaszd ki, mennyi erőforrás szükséges a heist felszerelés előállításához. Érvényes a Bűnügyi Rendszer összes új kísérletére.",
                    label = "Kincsrabló műhely",
                },
                heistCreatorMenu = {
                    description = "Moduláris heistek létrehozása, szerkesztése és közzététele a dedikált Heist Creatorban.",
                    label = "Létrehozói menü",
                },
                heistExecution = {
                    description = "Indítási ablak, inaktivitás és hűtési idő a heist futtatásokhoz.",
                    label = "Heist időzítés",
                },
                moneywashEconomy = {
                    description = "Aktiválja a üzleteket és állítsa be a letét számlát, a szolgáltatási díjat és az interakciós távolságokat.",
                    label = "Általános",
                },
                npcPoliceSupport = {
                    description = "Ez a funkció ideiglenesen letiltva van stabilitási problémák miatt, és jelenleg nem aktiválható a Foglalkozás Konfigurátorban.",
                    label = "NPC rendőrtámogatás (jelenleg letiltva)",
                },
                pickpocketAvailability = {
                    description = "Aktiválja a funkciót, és opcionálisan korlátozza a konfigurált bűnügyi foglalkozásokra.",
                    label = "Elérhetőség",
                },
                pickpocketDispatchSettings = {
                    description = "Konfigurálja a figyelmeztetést, amikor egy NPC hívja a rendőrséget.",
                    label = "Vészhelyzeti diszpécserelés",
                },
                pickpocketDistances = {
                    description = "Állítsa be az NPC hatótávolságot, amelyet a közös körzati és célpontrendszer használ.",
                    label = "Interakciós határok",
                },
                pickpocketGameplay = {
                    description = "Válaszd ki a kihívást és a független menekülési, vészhelyzeti hívási és ellenállási valószínűségeket.",
                    label = "Kockázat és minijáték",
                },
                pickpocketItemRewards = {
                    description = "Szabályozza az üres zsebeket és a látható tárgyválasztásokat a 0,0001 százalékos határig.",
                    label = "Látható zsebtárgyak",
                },
                pickpocketMoney = {
                    description = "Konfigurálja a szerver által generált véletlenszerű készpénz tartományt.",
                    label = "Készpénzdíj",
                },
                pickpocketRateLimits = {
                    description = "Szabályozza a kérelmezési korlátozást, az NPC hűtési időt és a munkamenet lejáratát.",
                    label = "Szerveri védelmi intézkedések",
                },
                pvpArenas = {
                    description = "Létrehozza a körzati zónát, a megfigyelési pontot és a csapat szünetelő pontokat, amelyeket a PvP események használnak.",
                    label = "Arenák és harci zónák",
                },
                pvpAutomation = {
                    description = "Konfigurálja a visszatérő eseményeket és az automatikus indítást.",
                    label = "Automatizálás",
                },
                pvpAvailability = {
                    description = "Szabályozza, hogy elérhető-e a PvP esemény alkalmazás, és hol jelenik meg.",
                    label = "Elérhetőség",
                },
                pvpLimits = {
                    description = "Állítsa be a díjak és a tablet előzmények korlátait.",
                    label = "Korlátok és előzmények",
                },
                pvpModes = {
                    description = "Konfigurálja a PvP tableten előre kiválasztott játékmódot.",
                    label = "Játékmódok",
                },
                pvpPermissions = {
                    description = "Az eseménykezelést és a pénzügyeket az ACE- és foglalkozási jogosultságokhoz rendeli.",
                    label = "Engedélyek",
                },
                pvpRuntime = {
                    description = "Kérelmek kezelése, halálok és újraindulások élő meccseken.",
                    label = "Meccsidőtartam",
                },
                pvpTakeoverMethods = {
                    description = "Állítsa be, hogy mennyi idő alatt törhetik fel az egyes módszerekkel a bejáratot.",
                    label = "Törési módszerek",
                },
                pvpTakeoverRules = {
                    description = "Vezérli a laboratóriumok és lakókocsik átvehetőségének elérhetőségét és a részvételi feltételeket.",
                    label = "Átvételi szabályok",
                },
                pvpTakeoverZones = {
                    description = "Állítsa be az interakció-, riasztás- és elfoglalási zónákat, valamint azok időtartamát.",
                    label = "Zónák és időzítés",
                },
                shopAvailability = {
                    description = "Aktiválja a rablásokat és állítsa be a rendőrségi követelményt.",
                    label = "Elérhetőség",
                },
                shopDispatchSettings = {
                    description = "Állítsa be a címzettjeket és a riasztási tulajdonságokat.",
                    label = "Rendőrségi riasztás",
                },
                shopLocationTable = {
                    description = "Vezérli a személyzettel ellátott üzleteket és a pénztárcákat.",
                    label = "Üzleti helyek",
                },
                shopRegisterReward = {
                    description = "Állítsa be a véletlen jutalmat minden pultnál.",
                    label = "Pultjutalom",
                },
                shopRegisterTable = {
                    description = "Rendelje hozzá az egyes pultokat az üzletekhez.",
                    label = "Pénztárgépek",
                },
                shopSafe = {
                    description = "Állítsa be a kódpróbákat és a fúrógép tárgyát.",
                    label = "Pénztárca",
                },
                shopSafeReward = {
                    description = "Állítsa be a véletlen pénztárcajutalmat.",
                    label = "Pénztárcajutalom",
                },
                shopTiming = {
                    description = "Állítsa be a megfélemlítést, a cselekvéseket, az időtúllépési időt és a hűtési időt.",
                    label = "Időzítés",
                },
            },
            settingSections = {
                weapons = "Fegyverútvonalak",
                drugs = "Drogrendszer",
                drugProduction = "Drogtermelés",
                drugOperations = "Drogüzemek",
                drugMarketRisk = "Piac és kockázat",
                drugNetworks = "Droghálózatok",
                atmRobbery = "Bankautomata rablás",
                baseRaids = "Bázis raidok",
                crimeOrganizations = "Szervezetek",
                darknetMarket = "Darknet piac",
                moneywash = "Pénzmosás",
                pvpEvents = "Frakció PvP",
                robbery = "Rablás",
                territories = "Területek",
                graffiti = "Graffiti",
                interrogation = "Kikérdezés",
            },
            settingSubsections = {
                baseRaidEquipment = "Szükséges felszerelés",
                baseRaidBreach = "Behatolás",
                baseRaidLoot = "Zsákmány és járművek",
                graffitiLimits = "Korlátok és moderálás",
                interrogationTechnical = "Naplózás és biztonság",
                atmDispatch = "Rendőrségi kiírás",
                atmEquipment = "Felszerelés",
                atmExplosion = "Robbanás",
                atmOverview = "Áttekintés és helyek",
                atmRewards = "Jutalmak",
                atmTiming = "Időzítés",
                atmVehicle = "Jármű és kihúzás",
                baseRaids = "Bázis raidok",
                crimeMembership = "Tagság",
                heistCreator = "Rablótámadás-tervező",
                npcPoliceSupport = "NPC rendőrtámogatás (jelenleg letiltva)",
                pickpocket = "NPC zsebtolvajlás",
                pvpArenas = "Arénák",
                pvpEquipment = "Játékmódok",
                pvpOverview = "Áttekintés",
                pvpRuntime = "Meccsidőtartam",
                pvpTakeovers = "Laboratóriumok átvétele",
                shopRobbery = "Üzlet rablások",
                atmRobbery = "Bankautomata rablás",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Interakciós távolság" },
                weaponDefaultGeneralPedModel = { label = "Alapértelmezett NPC-modell" },
                weaponDefaultAccessActiveHourStart = { label = "Nyitási óra (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Zárási óra (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Szükséges szolgálatos rendőrök" },
                weaponDefaultAccessPoliceJobs = { label = "Rendőri munkák" },
                weaponDefaultCollectionDurationSeconds = { label = "Időtartam másodpercben" },
                weaponDefaultCollectionCooldownSeconds = { label = "Várakozás másodpercben" },
                weaponDefaultCollectionCooldownScope = { label = "Várakozás hatóköre" },
                weaponDefaultCollectionUseMinigame = { label = "Minijáték használata" },
                weaponDefaultCollectionMinigame = { label = "Minijáték" },
                weaponDefaultCollectionMinigameRounds = { label = "Minijáték körök" },
                weaponDefaultProductionDurationSeconds = { label = "Időtartam másodpercben" },
                weaponDefaultProductionSuccessChance = { label = "Siker esélye (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Alapanyagok felhasználása kudarc esetén" },
                weaponDefaultProductionUseMinigame = { label = "Minijáték használata" },
                weaponDefaultProductionMinigame = { label = "Minijáték" },
                weaponDefaultProductionMinigameRounds = { label = "Minijáték körök" },
                weaponDefaultProductionQualityMin = { label = "Minimális minőség" },
                weaponDefaultProductionQualityMax = { label = "Maximális minőség" },
                weaponDefaultProductionCooldownSeconds = { label = "Várakozás másodpercben" },
                weaponDefaultProductionCooldownScope = { label = "Várakozás hatóköre" },
                weaponDefaultMarketPayoutAccount = { label = "Kifizetési számla" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Minimális árarány (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Maximális árarány (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Feltöltési időköz másodpercben" },
                weaponDefaultMarketCooldownSeconds = { label = "Várakozás másodpercben" },
                weaponDefaultMarketCooldownScope = { label = "Várakozás hatóköre" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Megbízás határideje percben" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Megbízás bónusza (%)" },
                weaponStreetEnabled = { label = "Ritka fegyvereladás utcai vevőknek" },
                weaponStreetChance = { label = "Fegyverajánlat esélye (%)" },
                weaponStreetCooldown = { label = "Várakozás másodpercben" },
                weaponStreetAmount = { label = "Maximális mennyiség" },
                weaponStreetPriceMin = { label = "Minimális árarány (%)" },
                weaponStreetPriceMax = { label = "Maximális árarány (%)" },
                weaponStreetAccount = { label = "Kifizetési számla" },
                weaponStreetDirect = { label = "Közvetlen eladás" },
                weaponStreetBulk = { label = "Tömeges eladás" },
                weaponStreetContract = { label = "Kartellmegbízás" },
                weaponSystemEnabled = { label = "Fegyverútvonal-rendszer", description = "Engedélyezze a fegyvergyűjtést, feldolgozást és a kartelleknek történő értékesítést." },
                weaponRuntimeEnabled = { label = "Fegyverútvonal-műveletek", description = "Engedélyezze a beállított fegyverútvonalak használatát a játék világában." },
                weaponCreatorAccess = { label = "Fegyverszerkesztő hozzáférése", description = "Válassza ki, ki nyithatja meg a fegyverkészítőt.", options = { permission = "Csak engedéllyel", jobManagement = "Feladatkezelés", ownerOnly = "Csak tulajdonos" } },
                openWeaponCreator = { label = "Illegális üzleti Teremtő", description = "Kezeld a fegyverútvonalakat és a pénzmosást egy szerkesztőben.", buttonLabel = "Illegális üzleti Teremtő", unsavedTooltip = "Előbb mentse" },

                drugCultivationProgressionEnabled = {
                    label = "Aktiválja a termesztési szinteket",
                    description = "Aktiválja a termesztési XP-t, szinteket és szintalapú feloldási feltételeket.",
                },
                drugCultivationMaxLevel = {
                    label = "Maximális termesztési szint",
                    description = "Legmagasabb aktív termesztési szint. A felette konfigurált szintek elérésére nincs lehetőség.",
                },
                drugCultivationLevels = {
                    label = "Szintgörbe",
                    description = "Állítsa be minden termesztési szint címét és az összes XP küszöbértékét.",
                },
                drugCultivationActionXp = {
                    label = "XP-díjak",
                    description = "Állítsa be, hogy mennyi termesztési XP-t ad minden növekedési cselekvés.",
                },
                drugCultivationUnlocks = {
                    label = "Szintek feloldása",
                    description = "Állítsa be a szükséges termesztési szintet konténerekhez, alapanyagokhoz, felszereléshez, fajtákhoz és szkenner szintekhez.",
                },
                reputationRewards = {
                    label = "Reputációs cselekvések",
                    description = "Cselekvések hozzáadása, pontok módosítása, bejegyzések letiltása vagy törlése. Csak az engedélyezett bejegyzések adnak pontot.",
                },
                reputationEnabled = {
                    label = "Bűnözői reputáció engedélyezése",
                    description = "Személyes reputáció adományozása.",
                },
                reputationPointsPerLevel = {
                    label = "Pontok szintenként",
                    description = "Minden szinthez ekkora számú extra pont szükséges.",
                },
                reputationMinimumJoinPoints = {
                    label = "Belépéshez szükséges minimális reputáció",
                    description = "Bűnözői frakcióhoz való csatlakozáshoz szükséges összes pont. A 0 kikapcsolja a követelményt. A meglévő tagok megtartják a hozzáférést.",
                },
                reputation_atm = {
                    label = "ATM rablás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_shop_register = {
                    label = "Pénztárgép",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_shop_safe = {
                    label = "Pénztárbiztonság",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_pickpocket = {
                    label = "Zsebtolvajlás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_heist = {
                    label = "Heist befejezése",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_harvest = {
                    label = "Drog betakarítás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_processing = {
                    label = "Drogfeldolgozás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_sale = {
                    label = "Drogértékesítés",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_delivery = {
                    label = "Drogszállítás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_contract = {
                    label = "Elosztási szerződés",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_drug_raid = {
                    label = "Drog razzia",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_graffiti = {
                    label = "Graffiti",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_moneywash = {
                    label = "Pénzmosás",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_base_raid = {
                    label = "Bázis razzia",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                reputation_pvp_win = {
                    label = "PvP győzelem",
                    description = "Pontok sikeres végrehajtásért. A 0 kikapcsolja ezt a jutalmat.",
                },
                atmChargeProp = {
                    description = "Az ATM-en megjelenő objektummodell a robbanóanyag elhelyezése közben.",
                    label = "Robbanó objektum",
                },
                atmConsumeDrill = {
                    description = "Az ATM minden sikeresen befejezett fúrási pontja után elhasználja a beállított mennyiséget.",
                    label = "Fúró elhasználása",
                },
                atmDrillItem = {
                    description = "A kiszakított ATM fúrásához szükséges leltári tárgy azonosítója. A bolti széf fúrójától külön állítható.",
                    label = "Fúró tárgya",
                },
                atmDrillItemAmount = {
                    description = "Az ATM minden fúrási pontjához szükséges fúró tárgyak száma.",
                    label = "Szükséges fúrók száma",
                },
                atmDebug = {
                    description = "Részletes ATM rablási diagnosztikai adatokat ír a szerverkonzoltra és a kliens F8 konzoljára.",
                    label = "ATM hibakeresési naplók",
                },
                atmDispatchDurationSeconds = {
                    description = "Az ATM riasztás másodpercben releváns a dispatch fogyasztók számára.",
                    label = "Dispatch időtartam",
                },
                atmDispatchEnabled = {
                    description = "Létrehoz egy Jobs Bázis incidenset, ha egy ATM-et feltörnek.",
                    label = "Rendőrségi dispatch engedélyezése",
                },
                atmDispatchJobs = {
                    description = "Vesszővel elválasztott foglalkozásnevek, amelyek megkapják az ATM riasztást.",
                    label = "Dispatch munkák",
                },
                atmDispatchPriority = {
                    description = "Prioritásérték, amelyet változatlanul továbbít a dispatch integrációnak.",
                    label = "Dispatch prioritás",
                },
                atmDispatchRadius = {
                    description = "A dispatch integrációnak küldött riasztás közelítő sugara.",
                    label = "Dispatch sugár",
                },
                atmEnabled = {
                    description = "A beállított ATM-ek elérhetővé tétele szíj- és robbanóanyag rablásokhoz.",
                    label = "ATM rablások engedélyezése",
                },
                atmExplosionCameraShake = {
                    description = "A robbanást létrehozó kliens kamerarázásának intenzitása.",
                    label = "Kamerarázás",
                },
                atmExplosionDamageScale = {
                    description = "A robbanás natívnek továbbított károsodási és impulzus erősség.",
                    label = "Robbanás károsodás mértéke",
                },
                atmExplosionType = {
                    description = "A detonáció során használt GTA robbanástípus. Tartsd a alapértelmezettet, hacsak nem teszteltél más típust.",
                    label = "Robbanástípus",
                },
                atmDrillDurationSeconds = {
                    label = "Minimális fúrási idő csavaronként (mp)",
                    description = "A négy csavar mindegyikének minimális fúrási ideje másodpercben. A hűtési szünetek meghosszabbítják a próbálkozást. A mentés után indított fúrásokra érvényes.",
                },
                atmExplosiveDurationSeconds = {
                    description = "A robbanóanyag elhelyezéséhez szükséges másodpercek száma.",
                    label = "Robbanóanyag elhelyezési idő",
                },
                atmExplosiveItem = {
                    description = "A robbanóanyag elhelyezése után elfogyó készlettárgy.",
                    label = "Robbanóanyag-tárgy",
                },
                atmExplosiveItemAmount = {
                    description = "Egy elhelyezett robbanóanyaghoz szükséges robbanóanyag-tárgyak száma.",
                    label = "Elfogyó robbanóanyag-mennyiség",
                },
                atmFuseSeconds = {
                    description = "Az elhelyezés és a robbanás közötti másodpercek száma.",
                    label = "Gyújtóidő",
                },
                atmInteractionDistance = {
                    description = "Maximális ügyfél-interakciótávolság; a szerverellenőrzés biztonsági tartalékot ad hozzá.",
                    label = "Interakciótávolság",
                },
                atmLocations = {
                    description = "Hitelesített ATM-állomások. A /atmtest paranccsal létrehozott helyek ideiglenesek maradnak.",
                    itemLabel = "ATM-állomás",
                    label = "ATM helyszínek",
                },
                atmLootDurationSeconds = {
                    description = "Megszakított ATM feltöréséhez szükséges másodpercek száma.",
                    label = "Lopási időtartam",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "A maximális másodpercek száma, amit egy játékos lefoglalhat az ATM feltörése közben; ez automatikusan magasabb, mint a lopási időtartam.",
                    label = "Lopási lefoglalási időkorlát",
                },
                atmLootWindowMinutes = {
                    description = "Az időtartam percben, amíg egy feltört ATM lopható, mielőtt kiürül.",
                    label = "Lopási időablak",
                },
                atmMinimumPolice = {
                    description = "A megadott rendőrségi csoport tagjainak száma, akiknek szolgálatban kell lenniük egy lopás elindításához.",
                    label = "Minimális rendőrök",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base foglalkozási csoport számít a rendőrségi követelmények felé.",
                    label = "Rendőrségi munkacsoport",
                },
                atmPullDistance = {
                    description = "A feltörés elindításához szükséges jármű elmozdulása az ATM pozíciójától.",
                    label = "Kötelező húzó távolság",
                },
                atmPullMinimumSpeed = {
                    description = "A húzó távolság elérésénél szükséges minimális járműsebesség méter másodpercenként.",
                    label = "Minimális húzó sebesség",
                },
                atmReservationTimeoutSeconds = {
                    description = "A maximális másodpercek száma, amit egy játékos lefoglalhat, amikor egy kötelet rögzít vagy robbanóanyagot helyez el; ez automatikusan magasabb, mint a cselekvés időtartama.",
                    label = "Előkészületek lefoglalási időkorlát",
                },
                atmRewardAccount = {
                    description = "Válaszd ki, hogy a pénzautomata készpénzt vagy a black_money tárgyat fizeti ki.",
                    label = "ATM kifizetési típus",
                },
                atmRewardMaximum = {
                    description = "Egy ATM-től származó legmagasabb készpénzkifizetés; soha nem lehet alacsonyabb, mint a minimum.",
                    label = "Maximális jutalom",
                },
                atmRewardMinimum = {
                    description = "Egy ATM-től származó legalacsonyabb készpénzkifizetés.",
                    label = "Minimális jutalom",
                },
                atmSlingDurationSeconds = {
                    description = "A kötélerősítéshez szükséges másodpercek száma.",
                    label = "Kötélerősítési idő",
                },
                atmSlingItem = {
                    description = "A járműves módszerhez szükséges újrahasználható készlettárgy.",
                    label = "Kötél-tárgy",
                },
                atmSlingItemAmount = {
                    description = "A szükséges kötéltárgyak száma. Ezek nem fogyaszthatók el.",
                    label = "Kötelelő mennyiség",
                },
                atmTestScanDistance = {
                    description = "A /atmtest paranccsal végzett támogatott ATM-prop kereséséhez szükséges maximális távolság.",
                    label = "ATM-teszt-szkennelési távolság",
                },
                atmVehicleMaxDistance = {
                    description = "A kötélerősítés során az ATM és a jogosult jármű közötti maximális távolság.",
                    label = "Jármű rögzítési távolság",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Minden tárolópontra vonatkozó feltörési kísérlet időkorlátja (másodpercben).",
                    label = "Feltörési időkorlát (másodpercben)",
                },
                baseRaid_command = {
                    description = "A parancsnév a perjel nélkül. A bűnözési erőforrás újraindítása a módosítás után.",
                    label = "Raid-parancs",
                },
                baseRaid_crimeItem = {
                    description = "Gang feltörési tárgy.",
                    label = "Gang feltörési tárgy",
                },
                baseRaid_crimeVehicles = {
                    description = "Gang járműhozzáférés.",
                    label = "Gang járműhozzáférés",
                },
                baseRaid_difficulty = {
                    description = "Készségellenőrzés nehézsége.",
                    label = "Készségellenőrzés nehézsége",
                    options = {
                        easy = "Könnyű",
                        expert = "Mester",
                        hard = "Nehéz",
                        normal = "Normál",
                    },
                },
                baseRaid_enabled = {
                    description = "Bázisrajdok engedélyezése.",
                    label = "Bázisrajdok engedélyezése",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Leállási idő, ha egy raid során nem nyílt meg raktár (perc).",
                    label = "Leállási idő sikertelen kísérlet után (perc)",
                },
                baseRaid_interactionDistance = {
                    description = "Raktár-interakció távolsága.",
                    label = "Raktár-interakció távolsága",
                },
                baseRaid_lootHeistStorage = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Heist-raktár kifosztása",
                },
                baseRaid_lootLaboratories = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Labor-raktár kifosztása",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Személyes szekrények kifosztása",
                },
                baseRaid_lootStorage = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Raktár kifosztása",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Gépkocsi kesztyűtartók kifosztása",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Ez a raktárkategória teljes kiürítése engedélyezett egy aktív raid során.",
                    label = "Gépkocsi csomagtartók kifosztása",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimum online védekezők.",
                    label = "Minimum online védekezők",
                },
                baseRaid_policeItem = {
                    description = "Rendőrségi behatolási tárgy.",
                    label = "Rendőrségi behatolási tárgy",
                },
                baseRaid_policeRequireDuty = {
                    description = "A rendőrségnek szolgálatban kell lennie.",
                    label = "A rendőrségnek szolgálatban kell lennie",
                },
                baseRaid_policeVehicles = {
                    description = "Rendőrségi jármű-hozzáférés.",
                    label = "Rendőrségi jármű-hozzáférés",
                },
                baseRaid_protectionHours = {
                    description = "Védelem sikeres raid után (óra).",
                    label = "Védelem sikeres raid után (óra)",
                },
                baseRaid_requiredHits = {
                    description = "Kellő készségellenőrzési találatok.",
                    label = "Kellő készségellenőrzési találatok",
                },
                baseRaid_warrantItem = {
                    description = "Egyik tárgy kerül felhasználásra minden érvényes rendőrségi raid indulásakor.",
                    label = "Keresési parancs tárgy",
                },
                crimeMembershipMode = {
                    description = "A Framework mód megőrzi a meglévő foglalkozást vagy a helyi bűnözői integrációt. A független mód a bűnözői szervezetet a háttérben futtatja a játékos normál foglalkozása mellett, és automatikusan átvállalja a meglévő tagságokat.",
                    label = "Szervezeti tagsági modell",
                    options = {
                        framework = "Framework foglalkozás / bűnözői csoport",
                        independent = "Független szervezet",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Az azonosítók minimális kora, mielőtt újra visszavonhatók lennének.",
                    label = "Azonosítócsere leállási idő (óra)",
                },
                darknetCurrencyCode = {
                    description = "Rövid jelölő a belső kriptovaluta vezetéséhez.",
                    label = "Pénznem-kód",
                },
                darknetDeadDropInteractionDistance = {
                    description = "A doboz kereséséhez és átvételéhez szükséges távolság.",
                    label = "Titkosítási pont-interakció távolsága",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Az átvétlen maradt doboz lejárati ideje.",
                    label = "Titkosítási pont élettartama (óra)",
                },
                darknetDeadDropModel = {
                    description = "Helyileg generált GTA tárgy-modell a rendelkezésre álló titkosítási pontokhoz.",
                    label = "Titkosítási pont doboz-modell",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "A környező dobozok és NPC-összejövetelek frissítésére használt intervallum.",
                    label = "Világfrissítési intervallum (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "A dobozok és NPC-összejöveteli kapcsolatok betöltéséhez szükséges távolság.",
                    label = "Titkosítási pont betöltési távolság",
                },
                darknetDropLocations = {
                    description = "NPC-ekkel végzett Dead-Drop-kereskedésekhez véletlenszerűen kiosztott helyek. Állíts be legalább kettőt.",
                    itemLabel = "Dead-drop helyszín",
                    label = "Dead-drop helyszínek",
                },
                darknetEnabled = {
                    description = "Megtehetővé teszi a fekete piaci tablet alkalmazást és annak futtatási környezetét.",
                    label = "Fekete piac engedélyezése",
                },
                darknetExchangeBuyPrice = {
                    description = "Az egy coinért a fizetési számláról levont összeg.",
                    label = "Coin vásárlási ára",
                },
                darknetExchangeEnabled = {
                    description = "Hitelesített BlackBay felhasználóknak teszi lehetővé a coinok vásárlását és eladását a fiókoldalon.",
                    label = "Coin csere engedélyezése",
                },
                darknetExchangeMaximumAmount = {
                    description = "Egy csere során elfogadott legnagyobb egész coin mennyiség.",
                    label = "Maximális coinok csereenként",
                },
                darknetExchangeMinimumAmount = {
                    description = "Egy csere során elfogadott legkisebb egész coin mennyiség.",
                    label = "Minimális coinok csereenként",
                },
                darknetExchangePaymentAccount = {
                    description = "A coin vásárlásokhoz és eladási kifizetésekhez használt keretrendszeri fiók.",
                    label = "Csere fizetési fiók",
                    options = {
                        bank = "Bank",
                        black_money = "Koszos pénz",
                        money = "Készpénz",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Az egy coinért a fizetési számlára kifizetett összeg.",
                    label = "Coin eladási ára",
                },
                darknetFaceToFaceDistance = {
                    description = "A két játékos vagy a beállított NPC-pont közötti maximális távolság.",
                    label = "Átvételi távolság",
                },
                darknetKnownScammerReports = {
                    description = "A ismert csaló jelvényhez szükséges egyedi kereskedési jelentések száma.",
                    label = "Jelentések csaló figyelmeztetéshez",
                },
                darknetListingExpiryHours = {
                    description = "Az aktív ajánlatok automatikusan lejárnak ennyi óra elteltével.",
                    label = "Ajánlat élettartama (óra)",
                },
                darknetMaximumListingQuantity = {
                    description = "Egy ajánlatra vonatkozó felső mennyiségi korlát.",
                    label = "Maximális áru mennyiség",
                },
                darknetMaximumListings = {
                    description = "Maximális ajánlatok száma egy aktív aliasonként.",
                    label = "Maximális aktív ajánlatok",
                },
                darknetMaximumMessageLength = {
                    description = "Egy titkosított chatüzenethez tartozó maximális karakterek száma.",
                    label = "Maximális üzenet hossza",
                },
                darknetMaximumUnitPrice = {
                    description = "Egy egységre vonatkozó felső kriptovaluta ár.",
                    label = "Maximális egységár",
                },
                darknetMeetingLocations = {
                    description = "NPC-ekkel végzett személyes kereskedésekhez véletlenszerűen kiosztott helyek. Állíts be legalább kettőt.",
                    itemLabel = "Találkozó helyszín",
                    label = "Találkozó helyszínek",
                },
                darknetNpcBuyerAliases = {
                    description = "Új NPC vásárlási kérésekhez véletlenszerűen kiosztott kitalált nevek. Állíts be legalább két egyedi aliasot.",
                    label = "NPC vevő aliasok",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Használt felső korlát, amikor véletlenszerűen kiválasztjuk, hány NPC vásárlási kérés válik aktívvá.",
                    label = "Maximális NPC vásárlási kérések",
                },
                darknetNpcMaximumSellListings = {
                    description = "Használt felső korlát, amikor véletlenszerűen kiválasztjuk, hány NPC eladási ajánlat válik aktívvá.",
                    label = "Maximális NPC eladási ajánlatok",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Az NPC piac feltöltésekor legalább ennyi véletlenszerűen kiválasztott vásárlási kérés marad aktív.",
                    label = "Minimális NPC vásárlási kérések",
                },
                darknetNpcMinimumSellListings = {
                    description = "Az NPC piac feltöltésekor legalább ennyi véletlenszerűen kiválasztott eladási ajánlat marad aktív.",
                    label = "Minimális NPC eladási ajánlatok",
                },
                darknetNpcSellerAliases = {
                    description = "Új NPC eladási ajánlatokhoz véletlenszerűen kiosztott fiktív nevek. Állíts be legalább két egyedi aliasot.",
                    label = "NPC eladó aliasok",
                },
                darknetNpcTraders = {
                    description = "Szintetikus ajánlatok, átvételi mód, reputáció és csalási valószínűség beállítása.",
                    label = "NPC vevők és eladók",
                },
                darknetPoliceGroups = {
                    description = "Csoportkulcsok, amelyek engedélyezik a csalóajánlatok közzétételét és a nyomozások megtekintését.",
                    label = "Jogosult rendőri munkacsoportok",
                },
                darknetRenewalHours = {
                    description = "Órák, amelyekkel egy tulajdonos megújításkor növelheti az ajánlat érvényességét.",
                    label = "Megújítási időtartam (óra)",
                },
                darknetScamChance = {
                    description = "A minimális esélye annak, hogy egy NPC-kereskedő elfogadja a fizetést vagy az árut anélkül, hogy a visszatérő árut átadná. A kereskedőre specifikus, magasabb esély továbbra is érvényesül.",
                    label = "Globális NPC-csaló esély (%)",
                },
                darknetStarterBalance = {
                    description = "Kriptovaluta, amelyet csak akkor kap a játékos, amikor először nyitja meg a piacot.",
                    label = "Új pénztárcák kezdőegyenlege",
                },
                darknetTabletOrder = {
                    description = "Vezérli a Darknet Piac pozícióját a tablet alkalmazásban.",
                    label = "Tablet alkalmazás sorrendje",
                },
                darknetVerifiedMinimumRating = {
                    description = "A hitelesített eladók számára szükséges minimális átlagos értékelés.",
                    label = "Hitelesítéshez szükséges értékelés",
                },
                darknetVerifiedMinimumSales = {
                    description = "A hitelesítéshez szükséges sikeres eladások száma.",
                    label = "Hitelesítéshez szükséges eladások",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "A fiók használata, ha a fizetési forrás a Játékosfiókra van állítva. Szervezeti fizetések mindig a Boss Menü fiókot használják.",
                    label = "Játékos fizetési fiók",
                    options = {
                        bank = "Bank",
                        black_money = "Koszos pénz",
                        money = "Készpénz",
                    },
                    requiresWarning = "Csak a Játékosfiók fizetési forrással használható.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Használja a vásárló játékos egyenlegét vagy a szervezet Boss Menü fiókját.",
                    label = "Fizetési forrás",
                    options = {
                        player = "Játékosfiók",
                        society = "Szervezeti fiók",
                    },
                },
                drugCamperLockKey = {
                    description = "A saját vagy frakcióval megosztott kamperek zárásához és feloldásához szükséges alapértelmezett gomb beállítása. A játékosok személyre szabhatják a FiveM billentyűzethozzárendeléseiben.",
                    label = "Kamper-zár alapértelmezett gombja",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Minőségi és tételadatokat csatol a gyűjtő kimeneteihez alapértelmezetten. Tiltsa le, hogy a nyersanyagok normál módon halmozódjanak.",
                    label = "Gyűjtő tárgy metaadatai",
                },
                drugLabAssaultAlertDuration = {
                    description = "A másodpercek száma, ameddig a védő riasztási sugara látható a térképen.",
                    label = "Védő riasztás időtartama",
                },
                drugLabAssaultAlertRadius = {
                    description = "A térképen a védő frakciónak látható támadási zóna sugara.",
                    label = "Védő riasztási sugara",
                },
                drugLabAssaultBreachRadius = {
                    description = "A sugár, amelyen belül a támadónak maradnia kell, miközben a bejáratot feltöri.",
                    label = "Feltörési tartási sugara",
                },
                drugLabAssaultCaptureDuration = {
                    description = "A másodpercek száma, amelyet a támadónak a bejáratot ellenállás nélkül tartania kell ahhoz, hogy átvegye a laboratóriumot vagy a kamperet.",
                    label = "Átvételi időtartama",
                },
                drugLabAssaultCaptureRadius = {
                    description = "A bejárat területe, ahol a támadókat és a vitatkozó védőket számolják.",
                    label = "Átvételi sugár",
                },
                drugLabAssaultElectronicDuration = {
                    description = "A bejárat rendszerének feltöréséhez szükséges másodperc.",
                    label = "Elektronikus feltörés időtartama",
                },
                drugLabAssaultEnabled = {
                    description = "Lehetővé teszi a frakciók számára, hogy feltörjék és átvegyék a rivális laboratóriumokat és a frakcióval megosztott kamperet.",
                    label = "Laboratórium- és kamperátvételek engedélyezése",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "A bejárat feltöréséhez szükséges másodperc robbanó töltettel.",
                    label = "Robbanó töltettel történő feltörés időtartama",
                },
                drugLabAssaultInteractionDistance = {
                    description = "A maximális távolság a laboratórium vagy kamper bejáratától a támadás indításakor.",
                    label = "Bejárat interakciós távolsága",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "A bejárat zárjának fúrásához szükséges másodperc.",
                    label = "Mechanikus feltörés időtartama",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "A védekező frakció online tagjainak száma, amely szükséges ahhoz, hogy a támadás megkezdődhessen.",
                    label = "Minimális védők száma",
                },
                drugLabAssaultRequireDuty = {
                    description = "Csak a jelenlegi szolgálatban lévő tagok számítanak a védekező frakciónak.",
                    label = "Csak a szolgálatban lévő védők számának figyelembevétele",
                },
                drugProcessingInventoryMetadata = {
                    description = "Verőfeldolgozási eredményekhez alapértelmezetten minőségi és tételi adatok hozzáadása. Egyéni receptek felülírhatják ezt az beállítást.",
                    label = "Feldolgozási elemek metaadatai",
                },
                graffitiItemName = {
                    description = "Inventárium elem, amelyre szükség van a fújás megkezdéséhez, ha az elemkövetelmény engedélyezve van. Az elemnek jelen kell lennie az aktív inventáriumban.",
                    label = "Szükséges graffiti elem",
                },
                heistCooldownMinutes = {
                    description = "Ugyanaz a rablás le van tiltva egy valódi interakciókkal végződő és letisztított futás után. A nulla érték kikapcsolja a hűtési időt. Egy fel nem használt indítási ablak nem indítja el.",
                    label = "Rablás hűtési idő (perc)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Öt másodperces folyamatjelző. A szükséges alapanyagok siker esetén elfogynak.",
                        medium = "Válaszd ki az alapanyagokat a jelzett sorrendben, és teljesíts alapanyagonként egy időzítési próbát.",
                        advanced = "Teljes eszköz-összeszerelés eszközprofillal rendelkező recepteknél; egyébként alapanyagonként két pontos időzítési próba.",
                    },
                    description = "Egyszerű: öt másodperces haladási sáv. Közepes: alapanyag kiválasztás és időzítési ellenőrzések. Maximális: teljes eszközösszeállítás; a receptek, amelyeknek nincs eszközprofilja, két pontos időzítési ellenőrzést használnak minden alapanyagra.",
                    label = "Gyártás bonyolultsága",
                    options = {
                        advanced = "Maximális bonyolultság",
                        medium = "Közepes bonyolultság",
                        simple = "Egyszerű",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Az első interakció után minden új rablási cselekvés visszaállítja ezt az időzítőt. A lejárás véget vet a futásnak és törli annak világtárgyait. Új futásokra vonatkozik.",
                    label = "Rablás tevékenység hiányának határértéke (perc)",
                },
                heistStartTimeoutMinutes = {
                    description = "Idő a Start megnyomása után a célpontnál történő interakcióig. Interakció nélkül a futás visszaáll, és újra elindítható. Új futásokra vonatkozik.",
                    label = "Perc az első rablási interakcióig",
                },
                moneywashAccount = {
                    options = {
                        bank = "Bank",
                        black_money = "Koszos pénz",
                        money = "Készpénz",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Az a számla, amelyről a játékos piszkos pénzét levonják, amikor a mosási ciklus elindul.",
                    label = "Betéti számla",
                },
                moneywashDrawDistance = {
                    description = "A üzleti bejáratok és boltok megjelenítésének maximális távolsága méterben.",
                    label = "Megjelenítési távolság",
                },
                moneywashEnabled = {
                    description = "Elérhetővé teszi a szervezetekhez tartozó pénzmosó üzleteket.",
                    label = "Pénzmosás engedélyezése",
                },
                moneywashFeePercent = {
                    description = "A szervezetnek történő kifizetés előtt minden adagból levont százalékos mérték.",
                    label = "Szolgáltatási díj (%)",
                },
                moneywashInteractionDistance = {
                    description = "A üzleti bejáratok és boltok használatának maximális távolsága méterben.",
                    label = "Interakciótávolság",
                },
                npcPoliceAccuracy = {
                    description = "Az NPC rendőrök találatpontossága 0 és 100 között.",
                    label = "Lövési pontosság",
                },
                npcPoliceArmour = {
                    description = "Minden egyes NPC rendőr páncélértéke 0 és 100 között.",
                    label = "Testvédelem",
                },
                npcPoliceAtms = {
                    description = "NPC rendőri támogatás küldése, amikor egy ATM rablás riasztása aktiválódik.",
                    label = "Támogatás ATM-rablásoknál",
                },
                npcPoliceDurationSeconds = {
                    description = "Az NPC rendőrök bevetésben töltött maximális ideje a megjelenés után (30–900 másodperc).",
                    label = "Bevetési időtartam (másodperc)",
                },
                npcPoliceEnabled = {
                    description = "Jelenleg stabilitási problémák miatt letiltva. Ez a kapcsoló jelenleg nem aktiválhatja a funkciót.",
                    label = "NPC rendőri támogatás engedélyezése",
                },
                npcPoliceHeists = {
                    description = "NPC rendőri támogatás küldése, ha egy rablás riasztást indít.",
                    label = "Támogatás rablásoknál",
                },
                npcPoliceOfficerCount = {
                    description = "Fegyveres NPC rendőrök száma, amelyeket minden rablással kapcsolatos riasztásért küldenek (1–8).",
                    label = "Rendőrök bevetésenként",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Az idő a rablás riasztása és az NPC rendőrök megérkezése között (0–300 másodperc).",
                    label = "Reakciókésleltetés (másodperc)",
                },
                npcPoliceShops = {
                    description = "NPC rendőri támogatás küldése, ha egy bolti rablás riasztást indít.",
                    label = "Támogatás bolti rablásoknál",
                },
                npcPoliceSpawnDistance = {
                    description = "A célzott távolság a rablási helytől, ahol az NPC rendőrök megjelennek (15–150 méter).",
                    label = "Megjelenítési távolság (méter)",
                },
                npcPoliceWeapon = {
                    description = "Fegyver, amellyel minden reagáló NPC-tiszt fel van szerelve. Alapértelmezett: pisztoly.",
                    label = "Szolgálati fegyver",
                    options = {
                        WEAPON_CARBINERIFLE = "Karabély",
                        WEAPON_PISTOL = "Pisztoly",
                        WEAPON_PUMPSHOTGUN = "Dobozos puskagyalog",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Rablás-alkotó megnyitása",
                    description = "Megnyitja a Rablás-alkotót és bezárja a Feladat-konfigurátort.",
                    label = "Rablótámadás-tervező",
                    unsavedTooltip = "Változtatások mentése először",
                },
                pickpocketAggressionChance = {
                    description = "Független esély arra, hogy az NPC megtámadjon egy sikertelen, megszakított vagy lejárt kísérlet után.",
                    label = "Válaszcsapási esély (%)",
                },
                pickpocketAlertChance = {
                    description = "Független esély arra, hogy az NPC jelentést tesz egy sikertelen, megszakított vagy lejárt kísérlettel kapcsolatban.",
                    label = "Vészjelzés esélye (%)",
                },
                pickpocketDifficulty = {
                    description = "A kurzor sebességének, a célcímke zsugorodásának, a szekvencia hosszának és a tűrhető hibák számának szabályozása.",
                    label = "Nehézség",
                    options = {
                        easy = "Könnyű",
                        expert = "Mester",
                        hard = "Nehéz",
                        normal = "Normál",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Minden megkezdett zsebtolvajlási kísérletet egyszer jelentsen, siker esetén is, a segélyhívás esélyétől függetlenül.",
                    label = "Mindig küldjön riasztást",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Az időtartam, amíg a jelzés érvényes marad a diszpécseri rendszerek számára.",
                    label = "Diszpécseri időtartam",
                },
                pickpocketDispatchJobs = {
                    description = "Vesszővel elválasztott foglalkozásnevek, amelyek vészjelzést kapnak.",
                    label = "Diszpécseri munkák",
                },
                pickpocketDispatchPriority = {
                    description = "A prioritást változatlanul továbbítja a diszpécseri integrációnak.",
                    label = "Diszpécseri prioritás",
                },
                pickpocketDispatchRadius = {
                    description = "A diszpécseri integrációnak küldött közelítő riasztási sugár.",
                    label = "Diszpécseri sugár",
                },
                pickpocketEmptyChance = {
                    description = "Esély arra, hogy az NPC egyáltalán nem hordoz kiválasztható zsákmányt.",
                    label = "Üres zseb esélye (%)",
                },
                pickpocketEnabled = {
                    description = "Lehetővé teszi a játékosok számára, hogy lopkodjanak alkalmas környezeti hálózatos NPC-knél.",
                    label = "NPC lopkodás engedélyezése",
                },
                pickpocketFleeChance = {
                    description = "Független esély arra, hogy az NPC elmeneküljön egy sikertelen, megszakított vagy lejárt kísérlet után.",
                    label = "NPC elmenekülési esély (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maximális kliens-távolság; a szerver egy kis szinkronizációs margóval ellenőrzi.",
                    label = "Interakciótávolság",
                },
                pickpocketItems = {
                    description = "Minden sor a megjelenés esélyét vezérli. A 0,0001 százalékos értékhez négy tizedesjegyet támogatunk.",
                    itemLabel = "Tárgy esély",
                    label = "Tárgy zsákmány",
                },
                pickpocketItemsEnabled = {
                    description = "Emellett a konfigurált tárgyakat is a látható zsebtartalom közé dobja.",
                    label = "Tárgy zsákmány engedélyezése",
                },
                pickpocketMaximumLootChoices = {
                    description = "A szerver által generált pénz- vagy tárgy-slotok maximális száma egy NPC-re.",
                    label = "Maximális látható zsákmány",
                },
                pickpocketMinigame = {
                    description = "Válassz egy kihívást, vagy forgasd véletlenszerűen mindhárom között.",
                    label = "Kisjáték",
                    options = {
                        pulse = "Nyomási impulzus",
                        random = "Véletlenszerű forgatás",
                        sequence = "Irány-szekvencia",
                        timing = "Időzítési sáv",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "A legmagasabb látható pénzmennyiség; automatikusan megmarad a minimumon vagy felette.",
                    label = "Maximális pénz",
                },
                pickpocketMoneyMinimum = {
                    description = "A legkisebb, a szerver által generált összeg egy látható pénz-slotra.",
                    label = "Minimális pénz",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimális másodperc egy játékos által indított kérések között.",
                    label = "Kérés hűtési idő",
                },
                pickpocketRequireCrimeJob = {
                    description = "Engedélyezve: az akciót csak a regisztrált Bűnrendszer-munkákhoz adja hozzá. Letiltva: eltávolítja a beépített körkörös akciót, és a szerver exportját igényli.",
                    label = "Bűnrendszeri munka körkörös használata",
                },
                pickpocketRequiredHits = {
                    description = "Alapérték minden minijátékhoz. Értékes pénz fokozatosan növeli; rendkívül ritka tárgyak legalább nyolc találatot igényelnek.",
                    label = "Minimális találatok",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Másodperc, amíg egy befejezetlen szerveri kihívás lejár.",
                    label = "Munkamenet időtúllépés",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Zárolás megszakított vagy sikertelen kísérletek után; a sikeresen kiürített NPC-k továbbra sem elérhetők.",
                    label = "NPC hűtési idő",
                },
                pvpAdminAce = {
                    description = "ACE objektum, amely globális PvP eseménykezelési hozzáférést biztosít.",
                    label = "Adminisztrátor ACE",
                },
                pvpArenaReturnSeconds = {
                    description = "Alapértelmezett visszatérési idő az új eseményekhez. Az eseményvezetők felülírhatják ezt a tabletén.",
                    label = "Aréna visszatérési idő",
                },
                pvpArenaWarningPosition = {
                    description = "Meghatározza, hol jelenik meg az arénába való visszatérés figyelmeztetése.",
                    label = "Aréna figyelmeztetés pozíciója",
                    options = {
                        bottom_center = "Közép alul",
                        bottom_left = "Alul bal oldalon",
                        bottom_right = "Alul jobb oldalon",
                        middle_center = "Képernyő közepén",
                        middle_left = "Közép bal",
                        middle_right = "Jobb középen",
                        top_center = "Felső középen",
                        top_left = "Felső bal oldalon",
                        top_right = "Felső jobb oldalon",
                    },
                },
                pvpArenas = {
                    description = "Kör alakú harcmezőket hoz létre egy megfigyelői ponttal és legalább két csapat szülőponttal.",
                    itemLabel = "Aréna",
                    label = "PvP arénák",
                },
                pvpCountdownPosition = {
                    description = "Meghatározza, hol jelenik meg a mérkőzés kezdésére vonatkozó visszaszámlálás.",
                    label = "Visszaszámlálás pozíciója",
                    options = {
                        bottom_center = "Közép alul",
                        bottom_left = "Alul bal oldalon",
                        bottom_right = "Alul jobb oldalon",
                        middle_center = "Képernyő közepén",
                        middle_left = "Közép bal",
                        middle_right = "Jobb középen",
                        top_center = "Felső középen",
                        top_left = "Felső bal oldalon",
                        top_right = "Felső jobb oldalon",
                    },
                },
                pvpDefaultMode = {
                    description = "Új eseményekhez alapértelmezetten kiválasztott játékmód.",
                    label = "Alapértelmezett játékmód",
                    options = {
                        free_for_all = "Ingyenes mindenkinek",
                        last_man_standing = "Az utolsó álló",
                        team_deathmatch = "Csapatölés",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Alapértelmezett győzelemhez szükséges ölés száma a Csapat Halálcirkuszban vagy a Free For All-ban.",
                    label = "Alapértelmezett győzelmi cél",
                },
                pvpEventsEnabled = {
                    description = "Engedélyezi a frakció PvP táblagépes alkalmazását és az esemény futási idejét.",
                    label = "Frakció PvP események engedélyezése",
                },
                pvpKillfeedPosition = {
                    description = "Meghatározza, hol jelennek meg a legutóbbi eliminációk.",
                    label = "Eliminációs lista pozíciója",
                    options = {
                        bottom_center = "Közép alul",
                        bottom_left = "Alul bal oldalon",
                        bottom_right = "Alul jobb oldalon",
                        middle_center = "Képernyő közepén",
                        middle_left = "Közép bal",
                        middle_right = "Jobb középen",
                        top_center = "Felső középen",
                        top_left = "Felső bal oldalon",
                        top_right = "Felső jobb oldalon",
                    },
                },
                pvpLeaderPermission = {
                    description = "Munkahelyi jogosultság, amely szükséges a frakció események létrehozásához, regisztrálásához, indításához és kezeléséhez.",
                    label = "Frakcióvezetői jogosultság",
                },
                pvpMatchDurationMinutes = {
                    description = "Új események alapértelmezett időtartama percben. A nulla érték hatástalanítja az időkorlátot.",
                    label = "Mérkőzés időtartama",
                },
                pvpMaxHistory = {
                    description = "A táblagépes alkalmazáshoz visszaadott befejezett vagy megszakított események maximális száma.",
                    label = "Látható eseménytörténet",
                },
                pvpMaxRewards = {
                    description = "Egy eseményre jutó kombinált tárgy-, fegyver-, jármű- vagy pénzjutalmak maximális száma.",
                    label = "Maximális további jutalmak",
                },
                pvpMoneyPermission = {
                    description = "Munkahelyi jogosultság, amely szükséges a belépési díjakhoz és a nyereménypénzhez.",
                    label = "Frakció pénzügyi jogosultság",
                },
                pvpRequestCooldownMs = {
                    description = "Az egy játéktól származó módosító PvP kérések közötti minimális idő milliszekundumban.",
                    label = "Művelet hűtési idő",
                },
                pvpRespawnDelaySeconds = {
                    description = "Másodpercek, amíg egy játékos újrakezdődik vagy a megfigyelői területre kerül halála után.",
                    label = "Újrakezdődési késleltetés",
                },
                pvpSchedulePollSeconds = {
                    description = "Másodpercek a visszatérő sablonok és automatikus indítások ellenőrzései között.",
                    label = "Ütemterv-ellenőrzés intervalluma",
                },
                pvpScoreboardPosition = {
                    description = "Meghatározza, hol jelenik meg a kompakt élő eredménytábla a frakciós mérkőzések során.",
                    label = "Eredménytábla pozíciója",
                    options = {
                        bottom_center = "Közép alul",
                        bottom_left = "Alul bal oldalon",
                        bottom_right = "Alul jobb oldalon",
                        middle_center = "Képernyő közepén",
                        middle_left = "Közép bal",
                        middle_right = "Jobb középen",
                        top_center = "Felső középen",
                        top_left = "Felső bal oldalon",
                        top_right = "Felső jobb oldalon",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Lehetővé teszi a PvP adminisztrátoroknak, hogy regisztráljanak és manuálisan indítsanak egy frakciótaggal. Termelési környezetben tiltsd le ezt.",
                    label = "Adminisztrátori egyjátékos tesztelés engedélyezése",
                },
                pvpStartCountdownSeconds = {
                    description = "Új események alapértelmezett visszaszámlálása. Az eseményvezetők felülírhatják ezt a táblagépes alkalmazásban.",
                    label = "Indítási visszaszámlálás",
                },
                pvpTabletOrder = {
                    description = "Meghatározza, hol jelenik meg a frakció PvP alkalmazás a táblagépen.",
                    label = "Tablet alkalmazás sorrendje",
                },
                shopActiveTimeoutMinutes = {
                    description = "Perc, ameddig egy elhagyott rablás kudarcot vall.",
                    label = "Aktív időzár",
                },
                shopConsumeDrill = {
                    description = "A fúrógép elhasználása sikeres nyitás után.",
                    label = "Fúrógép elhasználása",
                },
                shopConsumeHackItem = {
                    description = "A hackelési tárgy elhasználása sikeres pultnyitás után.",
                    label = "Hackelési tárgy elhasználása",
                },
                shopCooldownMinutes = {
                    description = "A bolt újrakezdéséig hátralévő futási idő percekben.",
                    label = "Bolt várakozási idő",
                },
                shopDispatchAlways = {
                    description = "Minden boltrablást egyszer jelentsen a kezdetekor, megszakítás nélküli fenyegetésnél és kötelező eladó nélküli boltoknál is.",
                    label = "Mindig küldjön riasztást",
                },
                shopDispatchDurationSeconds = {
                    description = "Az riasztás érvényességi ideje másodpercben.",
                    label = "Diszpécseri időtartam",
                },
                shopDispatchJobs = {
                    description = "Vesszővel elválasztott riasztás-címzett foglalkozások.",
                    label = "Diszpécseri munkák",
                },
                shopDispatchPriority = {
                    description = "Dispatch felé továbbított prioritás.",
                    label = "Diszpécseri prioritás",
                },
                shopDispatchRadius = {
                    description = "Körülbelül a rendőri riasztás sugara.",
                    label = "Diszpécseri sugár",
                },
                shopDrillDurationSeconds = {
                    description = "A pult fúrásához szükséges idő másodpercben.",
                    label = "Pultfúrási időtartam",
                },
                shopDrillItem = {
                    description = "A bolti széfek fúrásához szükséges leltári tárgy azonosítója. Az ATM fúrójától külön állítható.",
                    label = "Fúró tárgy",
                },
                shopDrillItemAmount = {
                    description = "Szükséges fúró tárgyak száma.",
                    label = "Szükséges fúró mennyiség",
                },
                shopEnabled = {
                    description = "Rablások engedélyezése a beállított személyzetes boltokban.",
                    label = "Bolt-rablások engedélyezése",
                },
                shopHackItem = {
                    description = "A pult hackelési minijátékhoz szükséges tárgy. Az nyitási módszert külön kell engedélyezni minden bolt esetében.",
                    label = "Hackelési tárgy",
                },
                shopHackItemAmount = {
                    description = "A hackelési tárgy szükséges mennyisége.",
                    label = "Hackelési tárgy mennyisége",
                },
                shopIntimidationSeconds = {
                    description = "Az eladó puskával való fenyegetésének ideje másodpercben.",
                    label = "Fenyegetési időtartam",
                },
                shopLocations = {
                    description = "Üzletenként egy eladó, egy pénztárgép és egy opcionális széf.",
                    itemLabel = "Bolt",
                    label = "Üzleti helyek",
                },
                shopMinimumPolice = {
                    description = "A kezdéshez szükséges szolgálatban lévő rendőrök száma.",
                    label = "Minimális rendőrök",
                },
                shopPoliceGroup = {
                    description = "A rendőri előfeltételhez tartozó foglalkozási csoport.",
                    label = "Rendőrségi munkacsoport",
                },
                shopRegisterDurationSeconds = {
                    description = "A pult kiürítéséhez szükséges idő másodpercben.",
                    label = "Pultkiürítési időtartam",
                },
                shopRegisterRewardMaximum = {
                    description = "Legmagasabb pultnyeremény.",
                    label = "Maximális pultnyeremény",
                },
                shopRegisterRewardMinimum = {
                    description = "Legalacsonyabb pultnyeremény.",
                    label = "Minimális pultnyeremény",
                },
                shopRegisterRewardName = {
                    description = "Opcionális tárgy- vagy fiókneve.",
                    label = "Pultnyeremény neve",
                },
                shopRegisterRewardSort = {
                    description = "Válaszd ki, hogy a pultok készpénzt vagy a black_money tárgyat fizetnek-e ki.",
                    label = "Pultnyeremény típusa",
                },
                shopRegisters = {
                    description = "A bolt azonosítója alapján hozzárendelt pultok.",
                    itemLabel = "Pult",
                    label = "Pénztárgépek",
                },
                shopSafeLootDurationSeconds = {
                    description = "A pénz kinyeréséhez szükséges idő a helyes pultkód megadása után másodpercben.",
                    label = "Pultnyeremény időtartama",
                },
                shopSafeRewardMaximum = {
                    description = "Legmagasabb pultnyeremény.",
                    label = "Maximális pultnyeremény",
                },
                shopSafeRewardMinimum = {
                    description = "Legalacsonyabb pultnyeremény.",
                    label = "Minimális pultnyeremény",
                },
                shopSafeRewardName = {
                    description = "Opcionális tárgy- vagy fiókneve.",
                    label = "Pultnyeremény neve",
                },
                shopSafeRewardSort = {
                    description = "Válaszd ki, hogy a biztonsági dobozok készpénzt vagy a black_money tárgyat fizetnek-e ki.",
                    label = "Pultnyeremény kifizetési típusa",
                },
                shopThreatGraceSeconds = {
                    description = "Riasztás előtti megengedett megszakítás",
                    label = "Célzási kegyelmi idő",
                },
                territoryDrugSalesEnabled = {
                    description = "Sikeres utcai értékesítések NPC-knek befolyást adnak az eladó bandájának a jelenlegi utcai területen.",
                    label = "NPC-értékesítések területi befolyást adnak",
                },
                atmLocationMode = {
                    label = "Pénzautomata elhelyezési mód",
                    description = "Automatikusan felismeri a támogatott világobjektumokat, vagy csak manuálisan konfigurált helyeket használ.",
                    options = {
                        automatic = "Automatikus",
                        manual = "Kézi",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Rendőrség szükséges",
                    description = "A pénzautomata rablás megkezdéséhez a konfigurált számú szolgálatban lévő rendőr szükséges.",
                },
                openDrugCreator = {
                    label = "Drogkészítő menü",
                    description = "Megnyitja a Sky Crime Drogkészítő menüt és bezárja a Feladat-konfigurátort.",
                    buttonLabel = "Drogkészítő megnyitása",
                    unsavedTooltip = "Először mentés",
                },
                drugCreatorRuntimeDensity = {
                    label = "Futtatási sűrűség",
                    description = "Meghatározza, hogy milyen tömör formában jelenik meg a futtatási panel a Drogkészítőn belül.",
                    options = {
                        comfortable = "Kényelmes",
                        compact = "Kompakt",
                    },
                },
                drugCreatorListDensity = {
                    label = "Lista sűrűség",
                    description = "Meghatározza, hogy milyen tömör formában jelenik meg a létrehozói bejegyzési lista.",
                    options = {
                        comfortable = "Kényelmes",
                        compact = "Kompakt",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Üres futtató listák megjelenítése",
                    description = "A futtatási panel szakaszainak megjelenítése akkor is, ha nincs bennük bejegyzés.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Letiltott bejegyzések elrejtése",
                    description = "A Drogkészítő listájában a letiltott modulbejegyzések elrejtése.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Automatikus ID generálás",
                    description = "A Drogkészítőbe új bejegyzések létrehozásakor a bejegyzések ID-ját a neveikből generálja.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Szerkesztő megnyitása modulváltáskor",
                    description = "A szerkesztő automatikus megnyitása, amikor az aktív létrehozói modult váltják.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Okos másolási utótag",
                    description = "Automatikusan generált utótag hozzáadása a Drogkészítőbe lévő bejegyzések duplikálásakor.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Futtatási célok automatikus kiválasztása",
                    description = "A rendelkezésre álló futtatási laboratóriumok és töltések automatikus előválasztása.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Figyelemnyitás",
                    description = "A futtatási panel megnyitása a figyelmet igénylő bejegyzésekre fókuszálva.",
                },
                drugActivityHudPosition = {
                    label = "Aktivitás HUD pozíció",
                    description = "Húzd a helyezés és betakarítás HUD-ját a kívánt képernyőpozícióba.",
                },
                drugInteractionHudPosition = {
                    label = "Interakció HUD pozíció",
                    description = "Húzd a növények, laboratóriumok és kamper interakció HUD-ját a kívánt képernyőpozícióba.",
                },
                drugPlantStatusHudPosition = {
                    label = "Növényállapot HUD pozíció",
                    description = "Húzd a részletes növényállapot HUD-ját a kívánt képernyőpozícióba.",
                },
                drugSystemEnabled = {
                    label = "Drogrendszer",
                    description = "Engedélyezi a drogtermelést, a létrehozói adatokat és a futtatási API-kat ehhez a bűnözői munkahelyhez.",
                },
                drugCreatorAccess = {
                    label = "Drogkészítő hozzáférés",
                    description = "Meghatározza, ki nyithatja meg a haladó Drogkészítőt.",
                    options = {
                        permission = "Csak engedéllyel",
                        job_management = "Feladatkezelés",
                        owner_only = "Csak tulajdonos",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Futtatási API-k",
                    description = "Engedélyezi a játékosoknak az élő laboratórium, növény, feldolgozás és piac futtatási cselekvések használatát.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Játékos labor létrehozása",
                    description = "Lehetővé teszi a futási hozzáféréssel rendelkező nem admin játékosok számára, hogy laborokat hozzanak létre a létrehozói definíciókból.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Kinti ültetés",
                    description = "Lehetővé teszi a játékosok számára, hogy saját kinti ültetéseket hozzanak létre konfigurált laborokon kívül.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Közös kinti aratás",
                    description = "Lehetővé teszi, hogy más játékosok is learassák a kinti növényeket, nem csak az, aki ültette.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Labor vásárlásának számlázása",
                    description = "Számlázza a konfigurált labor vásárlási árakat, amikor a játékosok laborokat hoznak létre.",
                },
                drugRuntimeStrictInventory = {
                    label = "Szigorú készlet",
                    description = "A futási műveletek folytatásához sikeresen végre kell hajtani a konfigurált tárgyak, szerszámok és pénzkezelőket.",
                },
                drugRuntimeSalePayouts = {
                    label = "Értékesítési kifizetések",
                    description = "Fizessen a játékosoknak, ha a tétel vagy az útvonal eladásra kerül a piac futási rendszerén keresztül.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Kifizetési számla",
                    description = "A drogegységek eladásából származó kifizetésekre használt számla, például black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Diszpécser értesítések",
                    description = "A drogrizikó események továbbítása a diszpécser és a rendőri munkakör értesítéseihez.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Rendőri értesítések",
                    description = "Értesítse a konfigurált rendőri munkaköröket, ha egy drogrizikó esemény rendőri riasztást generál.",
                },
                drugBatchPrefix = {
                    label = "Tétel előtag",
                    description = "Előtag, amelyet új drogtételek generálásakor használnak.",
                },
                drugTestingKitAccuracy = {
                    label = "Tesztkészlet pontossága",
                    description = "Mekkora rejtett érték-ingadozás lehet egy alap tesztkészletnél.",
                },
                drugDecayIntervalMinutes = {
                    label = "Elromlási időköz",
                    description = "Percek a frissesség és szennyeződés elromlási ellenőrzések között.",
                },
                drugDefaultPackaging = {
                    label = "Alapértelmezett csomagolás",
                    description = "Csomagolás, amelyet akkor használnak, ha nyers vagy feldolgozott tételeket hoznak létre explicit csomagolási típus nélkül.",
                    options = {
                        loose = "Szabad",
                        baggy = "Tütös",
                        jar = "Üveg",
                        vacuum = "Vákuumzseb",
                        brick = "Blokkcsomagolás",
                        premium_seal = "Prémium lezárás",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Minőség súlyozása",
                    description = "Mennyire befolyásolja az alapminőség a végső pontszámot.",
                },
                drugQualityWeightPurity = {
                    label = "Tisztaság súlyozása",
                    description = "Mennyire befolyásolja a tisztaság a végső pontszámot.",
                },
                drugQualityWeightFreshness = {
                    label = "Frissesség súlyozása",
                    description = "Mennyire befolyásolja a frissesség a végső pontszámot.",
                },
                drugQualityWeightPotency = {
                    label = "Hatékonyság súlyozása",
                    description = "Mennyire befolyásolja a hatékonyság a végső pontszámot.",
                },
                drugQualityWeightStability = {
                    label = "Stabilitás súlyozása",
                    description = "Mennyire befolyásolja a stabilitás a végső pontszámot.",
                },
                drugQualityWeightContamination = {
                    label = "Szennyeződés büntetés",
                    description = "Negatív súly, amely szennyezett termékekre vonatkozik.",
                },
                drugTierGoodMin = {
                    label = "Jó szint minimum",
                    description = "Minimum pontszám a Jó minőséghez.",
                },
                drugTierPremiumMin = {
                    label = "Prémium szint minimum",
                    description = "Minimum pontszám a Prémium minőségi szinthez.",
                },
                drugTierTopShelfMin = {
                    label = "Prémium szint minimum",
                    description = "Minimum pontszám a Prémium minőségi szinthez.",
                },
                drugTierLabGradeMin = {
                    label = "Labor szint minimum",
                    description = "Minimum pontszám a Labor minőségi szinthez.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Zsákos rothadás",
                    description = "A zsákok frissességének csökkenésének szorzója.",
                },
                drugJarDecayMultiplier = {
                    label = "Üveges rothadás",
                    description = "Az üvegek frissességének csökkenésének szorzója.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vakuumos rothadás",
                    description = "A vakuumszákak frissességének csökkenésének szorzója.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Prémium lezárás ára",
                    description = "A prémium lezárt termékek árára vonatkozó szorzó.",
                },
                drugGrowingEnabled = {
                    label = "Növesztés engedélyezve",
                    description = "A növények növekedésének és szedése engedélyezése.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Ültetési hely ellenőrzése",
                    description = "Bekapcsolva a szabadon ültetett növények az adminisztrátor automatikus helyszínellenőrzésére várnak. Kikapcsolva adminisztrátori jóváhagyás nélkül is növekedhetnek.",
                },
                drugGrowthTickMinutes = {
                    label = "Növekedési ciklus percenként",
                    description = "Perc az automatikus növényi növekedés frissítései között.",
                },
                drugBaseGrowthPerTick = {
                    label = "Alap növekedés ciklusonként",
                    description = "Az alap növekedés értéke a fajta, a felszerelés és az ápolás módosítóinak alkalmazása előtt.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Vad növény újjáéledés",
                    description = "Perc a beállított vad növények újbóli megjelenéséhez.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Vadon élő növények kiemelése",
                    description = "Körvonalat jelenít meg a létrehozott vadon élő növényeken, amikor a játékos a kiemelési sugáron belül van.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Vadon élő növények kiemelési sugara",
                    description = "Az egyes létrehozott vadon élő növények körüli távolság méterben, amelyen belül látható a körvonaluk.",
                },
                drugDefaultPlantWater = {
                    label = "Alap víz",
                    description = "A víz értéke, amikor egy növény létrejön.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Alap trágya",
                    description = "A trágya értéke, amikor egy növény létrejön.",
                },
                drugDefaultPlantHealth = {
                    label = "Alap egészség",
                    description = "Az egészség értéke, amikor egy növény létrejön.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Alap mutáció esélye",
                    description = "Az alap mutáció esélye, ha a növénynek nincs saját fajta beállítása.",
                },
                drugHarvestPerfectStart = {
                    label = "Tökéletes szedés kezdete",
                    description = "A növekedés százaléka, ahol a legjobb szedési ablak kezdődik.",
                },
                drugHarvestPerfectEnd = {
                    label = "Tökéletes szedés vége",
                    description = "A növekedés százaléka, ahol a legjobb szedési ablak véget ér.",
                },
                drugLabsEnabled = {
                    label = "Laborok engedélyezve",
                    description = "A labor és a lakóautó futási példányainak engedélyezése.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laborok karakterenként",
                    description = "A megvásárolt vagy bérelt állandó laborok maximális száma tulajdonosonként. A 0 korlátlant jelent; a lakóautók és a megosztott hozzáférések nem számítanak.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laborok frakciónként",
                    description = "A megvásárolt vagy bérelt állandó laborok maximális száma tulajdonosonként. A 0 korlátlant jelent; a lakóautók és a megosztott hozzáférések nem számítanak.",
                },
                drugDefaultRentDays = {
                    label = "Alap bérleti napok",
                    description = "A bérelt laborok alap időtartama.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Forró lakóautó perc",
                    description = "Az ellopt lakóautóknak a kockázatos állapotban maradandó ideje.",
                },
                drugLabRentWarningHours = {
                    label = "Bérleti figyelmeztetés óra",
                    description = "Az órák száma a bérleti idő lejártáig, amikor a laborokat figyelmeztetésnek kell jelölni.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Lejárt bérlet nyomozási nyomás",
                    description = "A nyomozási nyomás, amelyet akkor kap, amikor a labor bérleti ideje lejár.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Lakóautó áthelyezési hűtési idő",
                    description = "Az órák száma, amíg ugyanazt a lakóautó laborot újra áthelyezheted.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Frissítési költség szorzó",
                    description = "A labor szint frissítési árának kiszámítására használt szorzó.",
                },
                drugCamperBaseSlots = {
                    label = "Lakóautó helyek",
                    description = "A lakóautó laborok alap felszerelési helyei.",
                },
                drugCamperBaseStorage = {
                    label = "Lakóautó tároló",
                    description = "A lakóautó laborok alap tárolókapacitása.",
                },
                drugCamperBasePower = {
                    label = "Lakóautó energia",
                    description = "A lakóautó laborok alap beépített energiája.",
                },
                drugBasementBaseSlots = {
                    label = "Alagómsi helyek",
                    description = "Alagómsi laboratóriumok alapértelmezett felszerelési helyei.",
                },
                drugBasementBaseStorage = {
                    label = "Alagómsi tároló",
                    description = "Alagómsi laboratóriumok alapértelmezett tárolókapacitása.",
                },
                drugWarehouseBasePower = {
                    label = "Raktár laboratórium teljesítmény",
                    description = "Raktár laboratóriumok alapértelmezett beépített teljesítménye.",
                },
                drugPowerEnabled = {
                    label = "Energiarendszer",
                    description = "Laboratóriumi energia-termelés, -fogyasztás és túlterhelés-ellenőrzés engedélyezése.",
                },
                drugOverloadGraceSeconds = {
                    label = "Túlterhelési tolerancia",
                    description = "Másodpercek, amíg a túlterhelt energia veszélyessé válik.",
                },
                drugHeatPerKilowatt = {
                    label = "Hőmérséklet / Kilowatt",
                    description = "Az energiafogyasztás által termelt laboratóriumi hőmérséklet.",
                },
                drugGeneratorT1Watts = {
                    label = "Generátor T1 Watt",
                    description = "T1 generátorok kimeneti teljesítménye.",
                },
                drugGeneratorT2Watts = {
                    label = "Generátor T2 Watt",
                    description = "T2 generátorok kimeneti teljesítménye.",
                },
                drugGeneratorT3Watts = {
                    label = "Generátor T3 Watt",
                    description = "T3 generátorok kimeneti teljesítménye.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Kopási szorzó",
                    description = "A feldolgozás által okozott felszerelési kopás globális szorzója.",
                },
                drugWorkersEnabled = {
                    label = "Munkavállalók engedélyezve",
                    description = "Kémikusok, növénytermesztők, csomagolók és biztonsági személyzet engedélyezése a droglaborokban.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximális munkavállalók / labor",
                    description = "Egy laborhoz rendelhető maximális munkavállalók száma.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Feldolgozási fáradtság",
                    description = "A feldolgozási lépés után a megfelelő munkavállalókhoz hozzáadott fáradtság.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Növekedési fáradtság",
                    description = "A betakarítás vagy növénytermesztési munka után a növénytermesztőkhöz hozzáadott fáradtság.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Munkavállalói regeneráció",
                    description = "A növekedési ciklusonkénti fáradtság-csökkenés.",
                },
                drugMarketEnabled = {
                    label = "Piac engedélyezve",
                    description = "Vevő, kereskedő és tétel-eladás futási ideje engedélyezése.",
                },
                drugMarketBasePriceFallback = {
                    label = "Alapár visszatérési érték",
                    description = "Az alapár, amelyet akkor használnak, ha egy drogdefiníciónak nincs egyedi ára.",
                },
                drugMarketStreetMultiplier = {
                    label = "Utcai szorzó",
                    description = "Az utcai eladások globális árszorzója.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Kiskereskedelmi szorzó",
                    description = "A kiskereskedelmi üzletek globális árszorzója.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Prémium szorzó",
                    description = "A prémium vevők globális árszorzója.",
                },
                drugMarketHeatPerSale = {
                    label = "Fajó / Eladás",
                    description = "Az alap fájó érték, amely egy tétel eladásakor a laborhoz hozzáadódik.",
                },
                drugDistributionTickMinutes = {
                    label = "Elosztási ciklus",
                    description = "Az automatikus kereskedő-elosztási frissítések közötti percenkénti időköz.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Elosztási időköz",
                    description = "A kereskedőnek szükséges alapértelmezett perc száma az eladás megkísérlése előtt.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximális kereskedő rendelések",
                    description = "A kereskedőkre vonatkozó alapértelmezett maximális aktív elosztási rendelések száma.",
                },
                drugThreatsEnabled = {
                    label = "Veszélyek engedélyezve",
                    description = "A laboratóriumi fájó-csökkenés, razzia és sabotázs események engedélyezése.",
                },
                drugThreatTickMinutes = {
                    label = "Veszély ciklus",
                    description = "Időköz a fájó-csökkenés és a razzia/sabotázás ellenőrzések között.",
                },
                drugRaidHeatThreshold = {
                    label = "Razzia-fájó",
                    description = "A laborban szükséges fájó, mielőtt a razzia-kockázatok bekövetkezhetnek.",
                },
                drugSabotageHeatThreshold = {
                    label = "Sabotázás-fájó",
                    description = "A laborban szükséges fájó, mielőtt a sabotázás-kockázatok bekövetkezhetnek.",
                },
                drugThreatHeatDecay = {
                    label = "Fájó-csökkenés",
                    description = "A laborból eltávolított fájó minden fenyegetési ciklusnál.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Razzia-kockázat",
                    description = "Alapvető razzia-kockázat, amikor elérjük a razzia-fájó küszöbértékét.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotázás-kockázat",
                    description = "Alapvető sabotázás-kockázat, amikor elérjük a sabotázás-fájó küszöbértékét.",
                },
                drugConsumptionEnabled = {
                    label = "Fogyasztás engedélyezve",
                    description = "Engedélyezi a drogok hatásait, a tolerancia és az függőség nyomon követését.",
                },
                drugDoseConsumesBatch = {
                    label = "Adag fogyasztása csomagként",
                    description = "Meghatározza, hogy a fogyasztott csomagot eltávolítják-e a futási készletből.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerancia-csökkenés",
                    description = "A tolerancia-csökkenés frissítéseinek időköze.",
                },
                drugAddictionDecayMinutes = {
                    label = "Függőség-csökkenés",
                    description = "A függőség-csökkenés frissítéseinek időköze.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potencia szorzó",
                    description = "Meghatározza, hogy mekkora mértékben növeli a hatásereje a hatás intenzitását.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Túladagolás küszöbértéke",
                    description = "A hatásereje nyomása, amely szükséges ahhoz, hogy túladagolási kockázatok történjenek.",
                },
                drugBaseAddictionGain = {
                    label = "Alapvető függőség-növekedés",
                    description = "Alapvető függőség-növekedés adagonként.",
                },
                drugProcessingEnabled = {
                    label = "Feldolgozás engedélyezve",
                    description = "Engedélyezi a feldolgozási feladatokat, a csomagolást és a tesztcsomagok futási idejét.",
                },
                drugBatchMetadataItemKey = {
                    label = "Csomag metaadatok kulcsa",
                    description = "A csomagadatokhoz használt metaadatok kulcsa az integrációk számára.",
                },
                drugDefaultProcessDuration = {
                    label = "Alapvető feldolgozási idő",
                    description = "A feldolgozási idő alapértelmezett értéke másodpercben, ha nincs egyedi időtartam.",
                },
                drugDefaultFailureRisk = {
                    label = "Alapvető hiba kockázata",
                    description = "A feldolgozási hiba kockázatának alapértelmezett értéke, ha nincs egyedi kockázat.",
                },
                drugPackagingDuration = {
                    label = "Csomagolási idő",
                    description = "A csomagolási idő alapértelmezett értéke másodpercben.",
                },
                drugPowerTickSeconds = {
                    label = "Erőforrás-frissítési ciklus másodperce",
                    description = "A generátor fogyasztása és az erőforrás-signatúra frissítései közötti időköz másodpercben.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Signatúra-hő / óra",
                    description = "Az óránként keletkező hő a laboratórium erőforrás-signatúrájából.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Túlterhelés-hő / óra",
                    description = "Az óránként keletkező további hő, amikor a laboratórium túlterhelt.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Üresjárati hő-csökkenés / óra",
                    description = "Az óránként eltávolított hő, amikor a laboratóriumnak nincs aktív erőforrás-signatúrája.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuális / Maximális terhelés",
                    description = "A manuális erőforrás-módban használt maximális terhelés.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuális / Hő szorzó",
                    description = "A manuális erőforrás-módban használt hő szorzó.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuális / Zaj szorzó",
                    description = "A kézi üzemmód által használt zajszorzó.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Egyensúlyozott / Maximális terhelés",
                    description = "Az egyensúlyozott üzemmód által használt maximális terhelés.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Egyensúlyozott / Hő szorzó",
                    description = "Az egyensúlyozott üzemmód által használt hő szorzó.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Egyensúlyozott / Zajszorzó",
                    description = "Az egyensúlyozott üzemmód által használt zajszorzó.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Rejtett / Maximális terhelés",
                    description = "A rejtett üzemmód által használt maximális terhelés.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Rejtett / Hő szorzó",
                    description = "A rejtett üzemmód által használt hő szorzó.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Rejtett / Zajszorzó",
                    description = "A rejtett üzemmód által használt zajszorzó.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Szagvezérlés / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a szagvezérlés felszereléséhez.",
                },
                drugPowerPriorityAirflow = {
                    label = "Levegőáramlás / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a levegőáramlás felszereléséhez.",
                },
                drugPowerPrioritySecurity = {
                    label = "Biztonság / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a biztonsági felszereléshez.",
                },
                drugPowerPriorityGrowing = {
                    label = "Növekedés / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a növekedés felszereléséhez.",
                },
                drugPowerPriorityLight = {
                    label = "Megvilágítás / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a megvilágítás felszereléséhez.",
                },
                drugPowerPriorityTesting = {
                    label = "Tesztelés / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a tesztelés felszereléséhez.",
                },
                drugPowerPriorityPackaging = {
                    label = "Csomagolás / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a csomagolás felszereléséhez.",
                },
                drugPowerPriorityChemistry = {
                    label = "Kémia / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a kémiai felszereléshez.",
                },
                drugPowerPriorityHeating = {
                    label = "Fűtés / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a fűtés felszereléséhez.",
                },
                drugPowerPriorityPressing = {
                    label = "Nyomtatási prioritás",
                    description = "Automatikus terheléscsökkentés prioritása a nyomtatási felszereléshez.",
                },
                drugPowerPriorityGeneral = {
                    label = "Általános / Prioritás",
                    description = "Automatikus terheléscsökkentés prioritása az általános felszereléshez.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Teljesítmény / Inaktív vezérlési intervallum ms",
                    description = "A Teljesítmény / Inaktív vezérlési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Teljesítmény / Interakció üresjárati szkennelési intervallum ms",
                    description = "A Teljesítmény / Interakció üresjárati szkennelési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Teljesítmény / Interakció jelzési intervallum ms",
                    description = "A Teljesítmény / Interakció jelzési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Teljesítmény / Interakció szkennelési intervallum ms",
                    description = "A Teljesítmény / Interakció szkennelési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Teljesítmény / Minimális szkennelési intervallum ms",
                    description = "A Teljesítmény / Minimális szkennelési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Teljesítmény / Utcai NPC aktiválási távolság",
                    description = "Futtatási beállítás a Teljesítmény / Utcai NPC aktiválási távolsághoz.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Teljesítmény / Utcai NPC pihenőidő ellenőrzési intervallum (ms)",
                    description = "Futtatási beállítás a Teljesítmény / Utcai NPC pihenőidő ellenőrzési intervallumhoz (ms).",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Teljesítmény / Utcai NPC ellenőrzési intervallum (ms)",
                    description = "Futtatási beállítás a Teljesítmény / Utcai NPC ellenőrzési intervallumhoz (ms).",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Teljesítmény / Világ gyorsítótár töltelése",
                    description = "A Teljesítmény / Világ gyorsítótár töltelése futási idejű beállítása.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Teljesítmény / Világ gyorsítótár frissítési intervallum ms",
                    description = "A Teljesítmény / Világ gyorsítótár frissítési intervallum ms futási idejű beállítása.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Teljesítmény / Világ / Üresjárati intervallum (ms)",
                    description = "A Teljesítmény / Világ / Üresjárati intervallum (ms) futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dinamikus piac / Akció / Hűtési idő (másodperc)",
                    description = "Futóképes beállítás a Dinamikus piac / Akció / Hűtési időhöz (másodperc).",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dinamikus piac / Akció / Történeti korlát",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Akció / Történeti korláthoz.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dinamikus piac / Mennyiség / Piaci telítettség / Súly",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Mennyiség / Piaci telítettség / Súlyhoz.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dinamikus piac / Alapinformációk pontossága",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Alapinformációk pontosságához.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dinamikus piac / Alapértelmezett átlagos minőség",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Alapértelmezett átlagos minőséghez.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dinamikus piac / Alapértelmezett erőforrás / Rugalmasság",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Alapértelmezett erőforrás / Rugalmassághoz.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dinamikus piac / Kereslet / Központ",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Kereslet / Központ.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dinamikus piac / Kereslet / Ár / Hatás",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Kereslet / Ár / Hatáshoz.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dinamikus piac / Irány / Küszöbérték",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Irány / Küszöbérték.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dinamikus piac / Engedélyezve",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Engedélyezve.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dinamikus piac / Esemény / Esély",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Esély.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dinamikus piac / Esemény / Időtartam / Perc",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Időtartam / Perc.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dinamikus piac / Esemény / Minimális időtartam / Perc",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Minimális időtartam / Perc.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dinamikus piac / Esemény / Erő / Maximum",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Erő / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dinamikus piac / Esemény / Erő / Minimum",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Esemény / Erő / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dinamikus piac / Események / Rendőri offenzíva / Kereslet",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Események / Rendőri offenzíva / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dinamikus piac / Események / Rendőri offenzíva / Rendőrség",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Események / Rendőri offenzíva / Rendőrség.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dinamikus piac / Események / Rendőri offenzíva / Ár",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Események / Rendőri offenzíva / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dinamikus piac / Események / Fesztivál / Kereslet",
                    description = "Futtatásidejű beállítás a Dinamikus piac / Események / Fesztivál / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dinamikus piac / Események / Fesztivál / Hatások / 1",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Fesztivál / Hatások / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dinamikus piac / Események / Fesztivál / Hatások / 2",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Fesztivál / Hatások / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dinamikus piac / Események / Fesztivál / Hatások / 3",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Fesztivál / Hatások / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dinamikus piac / Események / Fesztivál / Ár",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Fesztivál / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dinamikus piac / Események / Fesztivál / Profilok / 1",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Fesztivál / Profilok / 1-hoz.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dinamikus piac / Események / Bándok konfliktusa / Kereslet",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Bándok konfliktusa / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dinamikus piac / Események / Bándok konfliktusa / Rendőrség",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Bándok konfliktusa / Rendőrséghez.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dinamikus piac / Események / Bándok konfliktusa / Ár",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Bándok konfliktusa / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dinamikus piac / Események / Bándok konfliktusa / Profilok / 1",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Bándok konfliktusa / Profilok / 1-hoz.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dinamikus piac / Események / Labor leleplezése / Kereslet",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Labor leleplezése / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dinamikus piac / Események / Labor leleplezése / Rendőrség",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Labor leleplezése / Rendőrséghez.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dinamikus piac / Események / Labor leleplezése / Ár",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Labor leleplezése / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dinamikus piac / Események / Labor leleplezése / Ellátás",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Labor leleplezése / Ellátáshoz.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dinamikus piac / Események / Buli / Kereslet",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Buli / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dinamikus piac / Események / Buli / Hatások / 1",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Buli / Hatások / 1-hoz.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dinamikus piac / Események / Buli / Hatások / 2",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Buli / Hatások / 2-hoz.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dinamikus piac / Események / Buli / Hatások / 3",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Buli / Hatások / 3-hoz.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dinamikus piac / Események / Buli / Ár",
                    description = "Futtatáskori beállítás a Dinamikus piac / Események / Buli / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dinamikus piac / Események / Buli / Profilok / 1",
                    description = "Beállítás a Dinamikus piac / Események / Buli / Profilok / 1-hoz.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dinamikus piac / Események / Buli / Profilok / 2",
                    description = "Beállítás a Dinamikus piac / Események / Buli / Profilok / 2-hoz.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dinamikus piac / Események / Hiány / Kereslet",
                    description = "Beállítás a Dinamikus piac / Események / Hiány / Kereslethez.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dinamikus piac / Események / Hiány / Ár",
                    description = "Beállítás a Dinamikus piac / Események / Hiány / Árhoz.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dinamikus piac / Események / Hiány / Ellátás",
                    description = "Beállítás a Dinamikus piac / Események / Hiány / Ellátáshoz.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dinamikus piac / Pontos információ / Reputáció",
                    description = "Beállítás a Dinamikus piac / Pontos információ / Reputációhoz.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dinamikus piac / Pontos információ / Bizalom",
                    description = "Beállítás a Dinamikus piac / Pontos információ / Bizalomhoz.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dinamikus piac / Globális zóna címke",
                    description = "Dinamikus piac / Globális zóna címke futási beállítása.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dinamikus piac / Előzmények limit",
                    description = "Dinamikus piac / Előzmények limit futási beállítása.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dinamikus piac / Kezdeti kereslet",
                    description = "Dinamikus piac / Kezdeti kereslet futási beállítása.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dinamikus piac / Kezdeti árszorzó",
                    description = "Dinamikus piac / Kezdeti árszorzó futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dinamikus piac / Információs kereslet hiba",
                    description = "Dinamikus piac / Információs kereslet hiba futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dinamikus piac / Információk maximális pontossága",
                    description = "Dinamikus piac / Információk maximális pontossága futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dinamikus piac / Információk minimális pontossága",
                    description = "Dinamikus piac / Információk minimális pontossága futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dinamikus piac / Információs rendőrségi hiba",
                    description = "Dinamikus piac / Információs rendőrségi hiba futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dinamikus piac / Információs ár hiba",
                    description = "Dinamikus piac / Információs ár hiba futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dinamikus piac / Információs ár maximum",
                    description = "Dinamikus piac / Információs ár maximum futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dinamikus piac / Információs ár minimum",
                    description = "Dinamikus piac / Információs ár minimum futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dinamikus piac / Információs hírnév súlyozás",
                    description = "Dinamikus piac / Információs hírnév súlyozás futási beállítása.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dinamikus piac / Információs erőforrás-ár hiba",
                    description = "Dinamikus piac / Intel erőforrás-ár hiba futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dinamikus piac / Intel telítettség hiba.",
                    description = "Dinamikus piac / Intel telítettség hiba futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dinamikus piac / Intel magvető kosár másodperc.",
                    description = "Dinamikus piac / Intel magvető kosár másodperc futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dinamikus piac / Intel állapot pontosság küszöb.",
                    description = "Dinamikus piac / Intel állapot pontosság küszöb futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dinamikus piac / Intel állapot hiba küszöb.",
                    description = "Dinamikus piac / Intel állapot hiba küszöb futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dinamikus piac / Intel ellátás hiba.",
                    description = "Dinamikus piac / Intel ellátás hiba futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dinamikus piac / Intel bizalom súlyozás.",
                    description = "Dinamikus piac / Intel bizalom súlyozás futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dinamikus piac / Manipuláció hűtőidő perc.",
                    description = "Dinamikus piac / Manipuláció hűtőidő perc futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dinamikus piac / Manipuláció kereslet eltolás.",
                    description = "Dinamikus piac / Manipuláció kereslet eltolás futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dinamikus piac / Manipuláció időtartam perc.",
                    description = "Dinamikus piac / Manipuláció időtartam perc futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dinamikus piac / Manipuláció hőfok.",
                    description = "Dinamikus piac / Manipuláció hőfok futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dinamikus piac / Manipuláció minimális tétel mértékegység.",
                    description = "Dinamikus piac / Manipuláció minimális tétel mértékegység futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dinamikus piac / Manipuláció fizetési fiók.",
                    description = "Dinamikus piac / Manipuláció fizetési fiók futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dinamikus piac / Manipuláció ár.",
                    description = "Dinamikus piac / Manipuláció ár futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dinamikus piac / Manipuláció zóna hőfok szorzó.",
                    description = "Dinamikus piac / Manipuláció zóna hőfok szorzó futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dinamikus piac / Maximális intel kor perc.",
                    description = "Dinamikus piac / Maximális intel kor perc futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dinamikus piac / Maximális árszorzó.",
                    description = "Dinamikus piac / Maximális árszorzó futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dinamikus piac / Minimális intel kor perc.",
                    description = "Dinamikus piac / Minimális intel kor perc futásidejű beállítása.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dinamikus piac / Minimális mérési ablak perc.",
                    description = "Dinamikus piac / Minimális mérési ablak / Perc futási beállítása.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dinamikus piac / Minimális árszorzó",
                    description = "Dinamikus piac / Minimális árszorzó futási beállítása.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dinamikus piac / Minimális frissítés / Perc",
                    description = "Dinamikus piac / Minimális frissítés / Perc futási beállítása.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dinamikus piac / Rendőrségi igény súlyozása",
                    description = "Dinamikus piac / Rendőrségi igény súlyozása futási beállítása.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dinamikus piac / Rendőrségi árszabás hatása",
                    description = "Dinamikus piac / Rendőrségi árszabás hatása futási beállítása.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dinamikus piac / Alacsony minőségű igény büntetése",
                    description = "Dinamikus piac / Alacsony minőségű igény büntetése futási beállítása.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dinamikus piac / Alacsony minőségű küszöb",
                    description = "Dinamikus piac / Alacsony minőségű küszöb futási beállítása.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dinamikus piac / Prémium minőségű igény bónusz",
                    description = "Dinamikus piac / Prémium minőségű igény bónusz futási beállítása.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dinamikus piac / Prémium minőségű küszöb",
                    description = "Dinamikus piac / Prémium minőségű küszöb futási beállítása.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dinamikus piac / Termelési ellátás súlyozása",
                    description = "Dinamikus piac / Termelési ellátás súlyozása futási beállítása.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dinamikus piac / Termelési ablak / Perc",
                    description = "Dinamikus piac / Termelési ablak / Perc futási beállítása.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dinamikus piac / Minőség középérték",
                    description = "Dinamikus piac / Minőség középérték futási beállítása.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dinamikus piac / Minőség bizalom hatása",
                    description = "Dinamikus piac / Minőség bizalom hatása futási beállítása.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dinamikus piac / Minőség tartomány",
                    description = "Dinamikus piac / Minőség tartomány futási beállítása.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dinamikus piac / Ritkaság bónusz maximum",
                    description = "Dinamikus piac / Ritkaság bónusz maximum futási beállítása.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dinamikus piac / Regionális globális súlyozás",
                    description = "Dinamikus piac / Regionális globális súlyozás futási beállítása.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dinamikus piac / Regionális lokális súlyozás",
                    description = "Dinamikus piac / Regionális lokális súlyozás futási beállítása.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dinamikus piac / Forráshelyettesítők / Drog csomagolás",
                    description = "Futtárbefiztatás beállítása a Dinamikus Piac / Erőforrás-aliaszok / Drogcsomagolás számára.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dinamikus piac / Erőforrás-aliaszok / Üzemanyag-hordó",
                    description = "Futtárbefiztatás beállítása a Dinamikus Piac / Erőforrás-aliaszok / Üzemanyag-hordó számára.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dinamikus Piac / Erőforrás-aliaszok / Gépi olaj",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrás-aliaszok / Gépi olaj számára.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dinamikus Piac / Erőforrás-aliaszok / Növényi tápanyagok",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrás-aliaszok / Növényi tápanyagok számára.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dinamikus Piac / Erőforrás-aliaszok / Javítócsomag",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrás-aliaszok / Javítócsomag számára.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dinamikus Piac / Erőforrás-irány / Esés / Küszöbérték",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrás-irány / Esés / Küszöbérték számára.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dinamikus Piac / Erőforrás-irány / Emelkedés / Küszöbérték",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrás-irány / Emelkedés / Küszöbérték számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Alapár",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Rugalmasság",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Megnevezés",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 1",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 1 számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 2",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 2 számára.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 3",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Szén-szűrő / Kapcsolt drogok / 3 számára.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Kémiai előanyag / Alapár",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Kémiai előanyag / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Kémiai előanyag / Rugalmasság",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Kémiai előanyag / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dinamikus Piac / Erőforrások / Kémiai előanyag / Megnevezés",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Kémiai előanyag / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dinamikus Piac / Erőforrások / Kémiai előanyag / Kapcsolt drogok / 1",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Kémiai előanyag / Kapcsolt drogok / 1 számára.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dinamikus Piac / Erőforrások / Kémiai előanyag / Kapcsolt drogok / 2",
                    description = "Futtatási beállítás a Dinamikus Piac / Erőforrások / Kémiai előanyag / Kapcsolt drogok / 2 számára.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Eszköztartozékok / Alapár",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Eszközáruk / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Eszközáruk / Rugalmasság",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Eszközáruk / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dinamikus Piac / Erőforrások / Eszközáruk / Megnevezés",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Eszközáruk / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Trágya / Alapár",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Trágya / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Trágya / Rugalmasság",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Trágya / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dinamikus Piac / Erőforrások / Trágya / Megnevezés",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Trágya / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dinamikus Piac / Erőforrások / Trágya / Kapcsolt drogok / 1",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Trágya / Kapcsolt drogok / 1 számára.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Laborüzemanyag / Alapár",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Laborüzemanyag / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Laborüzemanyag / Rugalmasság",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Laborüzemanyag / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dinamikus Piac / Erőforrások / Laborüzemanyag / Megnevezés",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Laborüzemanyag / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Csomagolózsák / Alapár",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Csomagolózsák / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Csomagolózsák / Rugalmasság",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Csomagolózsák / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dinamikus Piac / Erőforrások / Csomagolózsák / Megnevezés",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Csomagolózsák / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Ültetőedény / Alapár",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Ültetőedény / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Ültetőedény / Rugalmasság",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Ültetőedény / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dinamikus Piac / Erőforrások / Ültetőedény / Megnevezés",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Ültetőedény / Megnevezés számára.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dinamikus Piac / Erőforrások / Ültetőedény / Kapcsolt drogok / 1",
                    description = "Időbenkénti beállítás a Dinamikus Piac / Erőforrások / Ültetőedény / Kapcsolt drogok / 1 számára.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dinamikus Piac / Erőforrások / Kendermag / Alapár",
                    description = "Futtatási idejű beállítás a Dinamikus Piac / Erőforrások / Kendermag / Alapár számára.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dinamikus Piac / Erőforrások / Kendermag / Rugalmasság",
                    description = "Futtatási idejű beállítás a Dinamikus Piac / Erőforrások / Kendermag / Rugalmasság számára.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dinamikus Piac / Erőforrások / Kendermag / Címke",
                    description = "Dinamikus Piac / Erőforrások / Kendermag / Címke futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dinamikus Piac / Erőforrások / Kendermag / Kapcsolt drogok / 1",
                    description = "Dinamikus Piac / Erőforrások / Kendermag / Kapcsolt drogok / 1 futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dinamikus Piac / Eladások / Időablak / Perc",
                    description = "Dinamikus Piac / Eladások / Időablak / Perc futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dinamikus Piac / Telítettség / Kereslet / Súly",
                    description = "Dinamikus Piac / Telítettség / Kereslet / Súly futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dinamikus Piac / Telítettség / Ár / Hatás",
                    description = "Dinamikus Piac / Telítettség / Ár / Hatás futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dinamikus Piac / Ritkaság / Kereslet / Súly",
                    description = "Dinamikus Piac / Ritkaság / Kereslet / Súly futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dinamikus Piac / Ritkaság / Ár / Hatás",
                    description = "Dinamikus Piac / Ritkaság / Ár / Hatás futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dinamikus Piac / Évszak / Vége / Hónap / December",
                    description = "Dinamikus Piac / Évszak / Vége / Hónap / December futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dinamikus Piac / Évszak / Vége / Hónap / Tavasz",
                    description = "Dinamikus Piac / Évszak / Vége / Hónap / Tavasz futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dinamikus Piac / Évszak / Vége / Hónap / Nyár",
                    description = "Dinamikus Piac / Évszak / Vége / Hónap / Nyár futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dinamikus Piac / Évszak / Vége / Hónap / Tél",
                    description = "Dinamikus Piac / Évszak / Vége / Hónap / Tél futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dinamikus Piac / Évszak / Szorzók / Ősz",
                    description = "Dinamikus Piac / Évszak / Szorzók / Ősz futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dinamikus Piac / Évszak / Szorzók / Tavasz",
                    description = "Dinamikus Piac / Évszak / Szorzók / Tavasz futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dinamikus Piac / Évszak / Szorzók / Nyár",
                    description = "Dinamikus Piac / Évszak / Szorzók / Nyár futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dinamikus Piac / Évszak / Szorzók / Tél",
                    description = "Dinamikus Piac / Évszak / Szorzók / Tél futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dinamikus Piac / Hiány / Pletyka / Küszöb",
                    description = "Dinamikus Piac / Hiány / Pletyka / Küszöb futtatási idejű beállítása.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dinamikus piac / Statusz / Küszöbértékek / Magas kereslet",
                    description = "Dinamikus piac / Statusz / Küszöbértékek / Magas kereslet futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dinamikus piac / Statusz / Küszöbértékek / Forró",
                    description = "Dinamikus piac / Statusz / Küszöbértékek / Forró futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dinamikus piac / Statusz / Küszöbértékek / Alacsony kereslet",
                    description = "Dinamikus piac / Statusz / Küszöbértékek / Alacsony kereslet futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dinamikus piac / Statusz / Küszöbértékek / Telített",
                    description = "Dinamikus piac / Statusz / Küszöbértékek / Telített futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dinamikus piac / Cél / Ellátás",
                    description = "Dinamikus piac / Cél / Ellátás futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dinamikus piac / Trend / Esély",
                    description = "Dinamikus piac / Trend / Esély futási idejű beállítása.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dinamikus piac / Trend / Időtartam / Perc",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Trend időtartam (perc).",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dinamikus piac / Trend maximális erősség",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Trend maximális erősség.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dinamikus piac / Trend minimális erősség",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Trend minimális erősség.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dinamikus piac / Frissítés perc",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Frissítés perc.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dinamikus piac / Volatilitás maximum",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Volatilitás maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dinamikus piac / Volatilitás minimum",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Volatilitás minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dinamikus piac / Időjárás-multiplikátorok / Hideg",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás-multiplikátorok / Hideg.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dinamikus piac / Időjárás-multiplikátorok / Hőhullám",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás-multiplikátorok / Hőhullám.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dinamikus piac / Időjárás-multiplikátorok / Normál",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás-multiplikátorok / Normál.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dinamikus piac / Időjárás-multiplikátorok / Eső",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás-multiplikátorok / Eső.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dinamikus piac / Időjárás-multiplikátorok / Vihar",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás-multiplikátorok / Vihar.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dinamikus piac / Időjárás állapota",
                    description = "Futtárrendszer beállítás: Dinamikus piac / Időjárás állapota.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Fogás & Kockázat / Akció hűtési idő (másodperc)",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Akció hűtési idő (másodperc).",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Mennyiség",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Mennyiség.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Időtartam (perc)",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Időtartam (perc).",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Rendőrségi nyomás",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Rendőrségi nyomás.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Reputáció",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Reputáció.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Biztonság",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Tevékenység kockázati súlyok / Biztonság.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Fahndozási nyomás & Kockázat / Aggresszív fahndozási nyomás-multiplikátor",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Aggresszív fahndozási nyomás-multiplikátor.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Fahndozási nyomás & Kockázat / Burner (dobozos telefon) leégési küszöb",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) leégési küszöb.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Fahndozási nyomás & Kockázat / Burner (dobozos telefon) fahndozási nyomás / Nagykereskedelmi üzletenként",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) fahndozási nyomás / Nagykereskedelmi üzletenként.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Fahndozási nyomás & Kockázat / Burner (dobozos telefon) tárgy",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Burner (dobozos telefon) tárgy.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás-multiplikátor",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás-multiplikátor.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás küszöb",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Lakókocsi üzemelési fahndozási nyomás küszöb.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Fahndungsnyomás és Kockázat / Parkolt lakókocsi hőmérséklete",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Parkolt lakókocsi fahndozási nyomás.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Szennyezett hőmérséklet-szorzó",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Szennyezett fahndozási nyomás-multiplikátor.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Fahndungsnyomás és Kockázat / Szennyezett hőmérséklet-szint",
                    description = "Futtárrendszer beállítás: Fahndozási nyomás & Kockázat / Szennyezett fahndozási nyomás-küszöb.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Fahndozási nyomás & Kockázat / Ültetésmentes növények",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Ültetés / Kockázatmentes növények szinthez.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Fahndungsnyomás és Kockázat / Ültetés / Fahndungsnyomás növényenként",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Ültetés / Fahndungsnyomás növényenként szinthez.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Üzlet / Rejtőzködés ideje (perc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Üzlet / Rejtőzködés ideje (perc) szinthez.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Tétel",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Tétel szinthez.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Lakókocsi",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Lakókocsi szinthez.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Üzlet",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Üzlet szinthez.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Frakció",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Frakció szinthez.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Központ",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Központ szinthez.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Labor",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Labor szinthez.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Játékos",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Játékos szinthez.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Útvonal",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Útvonal szinthez.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Fahndungsnyomás és Kockázat / Romlás per ciklus / Zóna",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Romlás per ciklus / Zóna szinthez.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Fahndungsnyomás és Kockázat / Engedélyezve",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Engedélyezve szinthez.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Kritikus",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Kritikus szinthez.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Magas",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Magas szinthez.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Alacsony",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Végrehajtási nyomás / Alacsony szinthez.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Hőmérséklet és Kockázat / Végrehajtási nyomás / Közepes",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Végrehajtási nyomás / Közepes szinthez.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Hőmérséklet és Kockázat / Végrehajtási szorzók / Tétel",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Végrehajtási szorzók / Tétel szinthez.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Hőmérséklet és Kockázat / Végrehajtási szorzók / Frakció",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Végrehajtási szorzók / Frakció szinthez.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Hőmérséklet és Kockázat / Végrehajtási szorzók / Zóna",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Végrehajtási szorzók / Zóna szinthez.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Tétel",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Tételhez.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Lakókocsi",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Lakókocsihoz.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Értékesítő",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Értékesítőhöz.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Frakció",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Frakcióhoz.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Központ",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Központokhoz.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Labor",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Laborhoz.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Játékos",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Játékosokhoz.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Útvonal",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Útvonalakhoz.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Hőmérséklet és Kockázat / Entitástípusok / Zóna",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Entitástípusok / Zónákhoz.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Hőmérséklet és Kockázat / Esemény / Hűtési idő (perc)",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Esemény / Hűtési idő (perc)hez.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Hőmérséklet és Kockázat / Esemény / Történeti korlát",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Esemény / Történeti korláthoz.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Hőmérséklet és Kockázat / Labor / Végrehajtási nyomás szinkronizálási küszöbérték",
                    description = "Futási idejű beállítás a Hőmérséklet és Kockázat / Labor / Végrehajtási nyomás szinkronizálási küszöbértékhez.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Hőmérséklet és Kockázat / Elrejtés / Hűtési idő (perc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Hűtési idő (perc) beállításához.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Elrejtés / Üresjárati idő (perc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Üresjárati idő (perc) beállításához.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Fahndungsnyomás és Kockázat / Elrejtés / Csökkentés",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Elrejtés / Csökkentés beállításához.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Zárkózás / Hűtési idő (perc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Zárkózás / Hűtési idő (perc) beállításához.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Minimális időtartam (perc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális időtartam (perc) beállításához.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Fahndungsnyomás és Kockázat / Minimális eseményhűtési idő (másodperc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális eseményhűtési idő (másodperc) beállításához.",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Fahndungsnyomás és Kockázat / Minimális üresjárati idő (másodperc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Minimális üresjárati idő (másodperc) beállításához.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Feldolgozási hőszorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Feldolgozási hőszorzó beállításához.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Tétel",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Tétel beállításához.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Lakókocsi",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Lakókocsi beállításához.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Értékesítő",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Értékesítő beállításához.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Frakció",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Frakció beállításához.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Központ",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Központ beállításához.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Labor",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Labor beállításához.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Játékos",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Játékos beállításához.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Útvonal",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Útvonal beállításához.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Fahndungsnyomás és Kockázat / Kockázati súlyozások / Zóna",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Kockázati súlyozások / Zóna beállításához.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Fahndungsnyomás és Kockázat / Égető telefon cseréje / Csökkentés",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Égető telefon cseréje / Csökkentés számára.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Útvonal-irányítás / Perc",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Útvonal-irányítás / Perc számára.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Tétel",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Tétel számára.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Kamper",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Kamper számára.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Forgalmazó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Forgalmazó számára.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Frakció",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Frakció számára.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Központ",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Központ számára.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Labor",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Labor számára.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Játékos",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Játékos számára.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Útvonal",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Útvonal számára.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Zóna",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Eladás / Fahndungsnyomás / Zóna számára.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Fahndungsnyomás és Kockázat / Küszöbértékek / Kritikus",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Küszöbértékek / Kritikus számára.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Fahndungsnyomás és Kockázat / Küszöbértékek / Magas",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Küszöbértékek / Magas számára.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Fahndungsnyomás és Kockázat / Küszöbértékek / Lezárás",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Küszöbértékek / Lezárás számára.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Fahndungsnyomás és Kockázat / Küszöbértékek / Alacsony",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Küszöbértékek / Alacsony számára.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Fahndungsnyomás és Kockázat / Küszöbértékek / Közepes",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Küszöbértékek / Közepes számára.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Fahndungsnyomás és Kockázat / Ciklusidő / Perc",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Frissítési ciklus / Perc paraméterhez.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Nagykereskedelmi Fahndungsnyomás-szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Nagykereskedelmi Fahndungsnyomás-szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Riasztási sugár",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Riasztási sugár paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Alapérték / Esély",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Alapérték / Esély paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Frakciós Szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Frakciós Szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Magas Súlyosság Küszöb",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Magas Súlyosság Küszöb paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Esély Szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Esély Szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Küszöb",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Hűség Küszöb paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Maximális Esély",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Maximális Esély paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Hűtési Idő (Másodperc)",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Hűtési Idő (Másodperc) paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Útvonal Szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Útvonal Szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Maximális",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Maximális paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Erő",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Minimális Erő paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Erő Szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Stressz Esély Szorzó",
                    description = "Folyamatos beállítás a Fahndungsnyomás és Kockázat / Munkatársi adatleak / Stressz Esély Szorzó paraméterhez.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Fahndungsnyomás és Kockázat / Munkatársi adatleak / Stressz Küszöb",
                    description = "Folyamatidejű beállítás a Hő és Kockázat / Munkavállalói Adatvétség Stressz Küszöbértékéhez.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Kontakthálózat / Akció Hűtési Idő (Másodperc)",
                    description = "Folyamatidei beállítás a Kontakthálózat / Akció Hűtési Időhöz (Másodperc).",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Kontakthálózat / Aktív Forrópontok Száma",
                    description = "Folyamatidei beállítás a Kontakthálózat / Aktív Forrópontok Számához.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Kapcsolati Hálózat / Előfizetői Telefon Tipp Bizalom",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Tipp Bizalomhoz.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Maximális Szorzó",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Maximális Szorzóhoz.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Minimális Szorzó",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Előfizetői Telefon Ajánlat Minimális Szorzóhoz.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Kontakthálózat / Vásárló Hűtési Idő (Perc)",
                    description = "Folyamatidei beállítás a Kontakthálózat / Vásárló Hűtési Időhöz (Perc).",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Kontakthálózat / Vásárló Szállítási Távolság",
                    description = "Folyamatidei beállítás a Kontakthálózat / Vásárló Szállítási Távolsághoz.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Kapcsolati Hálózat / Vásárló Prémium Sikeres Pontszám",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Prémium Sikeres Pontszámhoz.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Kapcsolati Hálózat / Vásárló Prémium Bizalom Nyereség",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Prémium Bizalom Nyereséghez.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Kapcsolati Hálózat / Vásárló Kérés Hő és Kockázat Súlyozás",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Kérés Hő és Kockázat Súlyozáshoz.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Kapcsolati Hálózat / Vásárló Alapvető Bizalom Nyereség",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Vásárló Alapvető Bizalom Nyereséghez.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Kapcsolati Hálózat / Kapcsolat Aktív Késleltetés Másodpercek / Maximum",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Aktív Késleltetés Másodpercek / Maximumhoz.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Kapcsolati Hálózat / Kapcsolat Aktív Késleltetés Másodpercek / Minimum",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Aktív Késleltetés Másodpercek / Minimumhoz.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Kapcsolati Hálózat / Kapcsolat Igényszint / Maximum",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Igényszint / Maximumhoz.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Kapcsolati Hálózat / Kapcsolat Igényszint / Minimum",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Igényszint / Minimumhoz.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Kapcsolati Hálózat / Kapcsolat Bizalomvesztés",
                    description = "Folyamatidejű beállítás a Kapcsolati Hálózat / Kapcsolat Bizalomvesztéshez.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Kapcsolati Hálózat / Darknet Pontos Információ Perc",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Pontos Intel Percéhez.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Kapcsolati Hálózat / Darknet Forrópont Intel Ár",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Forrópont Intel Árhoz.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Kapcsolati Hálózat / Darknet Intel Ár",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Darknet Intel Árhoz.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Kapcsolati Hálózat / Kereskedő Alapár",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Alapárhoz.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Kapacitás / Maximum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Kapacitás / Maximumhoz.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Kapacitás / Minimum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Kapacitás / Minimumhoz.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Kockázat / Maximum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Kockázat / Maximumhoz.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Kockázat / Minimum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Kockázat / Minimumhoz.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Készség / Maximum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Készség / Maximumhoz.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Kapcsolati Hálózat / Kereskedő Felvétel Készség / Minimum",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Felvétel Készség / Minimumhoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Id",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Id-hoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Tétel",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Tételhez.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Felirat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Felirathoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Minimális Bizalom",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Minimális Bizalomhoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Ár",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 1 / Árhoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Id",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Id-hoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Tétel",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Tételhez.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Felirat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Kereskedő Ajánlatok / 2 / Felirathoz.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 2 / Minimális bizalom",
                    description = "Minimális bizalom beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 2",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 2 / Ár",
                    description = "Ár beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 2",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 3 / Id",
                    description = "Id. beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 3",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 3 / Tétel",
                    description = "Tétel beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 3",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 3 / Címke",
                    description = "Címke beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 3",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 3 / Minimális bizalom",
                    description = "Minimális bizalom beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 3",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 3 / Ár",
                    description = "Ár beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 3",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 4 / Id",
                    description = "Id. beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 4",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 4 / Tétel",
                    description = "Tétel beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 4",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 4 / Címke",
                    description = "Címke beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 4",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 4 / Minimális bizalom",
                    description = "Minimális bizalom beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 4",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 4 / Ár",
                    description = "Ár beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 4",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 5 / Id",
                    description = "Id. beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 5",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 5 / Tétel",
                    description = "Tétel beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 5",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 5 / Címke",
                    description = "Címke beállítási érték a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 5",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 5 / Minimális bizalom",
                    description = "Minimális bizalom beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 5",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Kapcsolati Hálózat / Kereskedői Ajánlatok / 5 / Ár",
                    description = "Ár beállítási értéke a Kapcsolati Hálózat / Kereskedői Ajánlatokhoz / 5",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Kapcsolati Hálózat / Kereskedői Védettség Órák",
                    description = "Kapcsolati Hálózat / Kereskedői Védettség óráinak futási beállítása.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Kapcsolati Hálózat / Kereskedői Védettség ára",
                    description = "Kapcsolati Hálózat / Kereskedői Védettség árának futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Kapcsolati Hálózat / Kereskedői Eladás maximuma",
                    description = "Kapcsolati Hálózat / Kereskedői Eladás maximumának futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Kapcsolati Hálózat / Kereskedői Eladás minimuma",
                    description = "Kapcsolati Hálózat / Kereskedői Eladás minimumának futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Aggresszív árszorzó",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Aggresszív árszorzó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Alapminőség árszorzó",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Alapminőség árszorzó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Nagykereskedelmi árszorzó",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Nagykereskedelmi árszorzó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Olcsó árszorzó",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Olcsó árszorzó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Alapértelmezett minőség",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Alapértelmezett minőség futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Hűtlenség küszöbértéke",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Hűtlenség küszöbértéke futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti tapasztalat",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti tapasztalat futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Egységenkénti tapasztalat",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Egységenkénti tapasztalat futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Incidensből eredő hűségvesztés",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Incidensből eredő hűségvesztés futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Maximális incidens-eredmény",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Maximális incidens-eredmény futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti árbónusz",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti árbónusz futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti eladási osztó",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Szintenkénti eladási osztó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Hűségvesztés kockázati súlya",
                    description = "Kapcsolati Hálózat / Kereskedő szimuláció / Hűségvesztés kockázati súlya futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Kapcsolati Hálózat / Kereskedő szimuláció / Maximális incidens esélye",
                    description = "A Kapcsolati Hálózat / Kereskedő Szimuláció / Maximális incidens esélye futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Kontakthálózat / Kereskedő szimuláció / Maximális szint",
                    description = "A Kontakthálózat / Kereskedő szimuláció / Maximális szint futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Prémium Árszorzó",
                    description = "A Kapcsolati Hálózat / Kereskedő Szimuláció / Prémium Árszorzó futási beállítása.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Profil Kockázati Súly",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Profil Kockázati Súlyhoz.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Védelmi Kockázatcsökkentés",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Védelmi Kockázatcsökkentéshez.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Minőségi Ár Osztó",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Minőségi Ár Osztóhoz.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Helyreállítás Alapesély",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Helyreállítás Alapesélyhez.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Helyreállítás Hűség Súlyozás",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Helyreállítás Hűség Súlyozásához.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Meglopott Áruvesztés",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Meglopott Áruvesztéshez.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Készség Kockázatcsökkentés",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Készség Kockázatcsökkentéshez.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Készség Eladás Osztó",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Készség Eladás Osztóhoz.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Stabil Hűség Küszöb",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Stabil Hűség Küszöbhez.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Területi Árszorzó",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Területi Árszorzóhoz.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Kapcsolati Hálózat / Kereskedő Szimuláció / Területi Kockázatcsökkentés",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Szimuláció / Területi Kockázatcsökkentéshez.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Kapcsolati Hálózat / Kereskedő Ciklusperc",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Ciklusperchez.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Kapcsolati Hálózat / Kereskedő Bér",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Bérhez.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Kapcsolati Hálózat / Kereskedő Bér Csökkenés",
                    description = "Futási beállítás a Kapcsolati Hálózat / Kereskedő Bér Csökkenéséhez.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Kapcsolati hálózat / Kereskedő bére hűség nyereség",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő bére hűség nyereségéhez.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Kapcsolati hálózat / Kereskedő gyengeségek / 1",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő gyengeségek / 1-hez.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Kapcsolati hálózat / Kereskedő gyengeségek / 2",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő gyengeségek / 2-höz.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Kapcsolati hálózat / Kereskedő gyengeségek / 3",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő gyengeségek / 3-hoz.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Kapcsolati hálózat / Kereskedő gyengeségek / 4",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő gyengeségek / 4-hez.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Kapcsolati hálózat / Kereskedő gyengeségek / 5",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereskedő gyengeségek / 5-höz.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Kapcsolati hálózat / Alapértelmezett kapcsolati kereslet",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kapcsolati kereslethez.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Kapcsolati hálózat / Alapértelmezett kapcsolati kockázat",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kapcsolati kockázathoz.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Kapcsolati hálózat / Alapértelmezett kereskedői kapacitás",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői kapacitáshoz.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Kapcsolati hálózat / Alapértelmezett kereskedői kockázat",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői kockázathoz.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Kapcsolati hálózat / Alapértelmezett kereskedői készség",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett kereskedői készséghez.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Kapcsolati hálózat / Alapértelmezett forró pont sugara",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Alapértelmezett forró pont sugarához.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Kapcsolati hálózat / Kereslet újraindítása (perc)",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Kereslet újraindítása (perc)hez.",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Kapcsolati hálózat / Engedélyezve",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Engedélyezve.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Kapcsolati hálózat / Pontos hely / Bizalom",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Pontos hely / Bizalomhoz.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Kapcsolati hálózat / Frakció felfedezés hírneve",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Frakció felfedezés hírnevéhez.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Kapcsolati hálózat / Frakció tipp / Bizalom",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Frakció tipp / Bizalomhoz.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Kapcsolati hálózat / Sikertelen szállítás várakozási idő (perc)",
                    description = "Futtatás idejű beállítás a Kapcsolati hálózat / Sikertelen szállítás várakozási idő (perc)hez.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Szám",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Számhoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 1",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 1-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 2",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 2-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 3",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Támadók / Modellek / 3-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Időtartam (Másodperc)",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Időtartam (Másodperc)hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 1",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 1-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 2",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 2-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 3",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Rendőrök / Modellek / 3-hoz.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Spawn Sugara",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Hamis Üzleti Kapcsolat / Találkozás / Spawn Sugara-hoz.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Kapcsolati Hálózat / Alternatív Előnyben Részesített Drog",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Visszacsatolás Preferált Drog részére.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Kapcsolati Hálózat / Visszacsatolás Termékkijelző",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Visszacsatolás Termékkijelző részére.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Kapcsolati Hálózat / Útmutatókönyv Tétel",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Útmutatókönyv Tétel részére.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Kapcsolati Hálózat / Útmutatókönyv Bizalom",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Útmutatókönyv Bizalom részére.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Kapcsolati Hálózat / Bérelt Diler Ár",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Bérelt Diler Ár részére.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Kapcsolati Hálózat / Történeti Korlát",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Történeti Korlát részére.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Kapcsolati Hálózat / Forrópont Intelligencia Perc",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Forrópont Intelligencia Perc részére.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Kapcsolati Hálózat / Forrópont Forgatás Perc",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Forrópont Forgatás Percéhez.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Kapcsolati Hálózat / Listázás Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Listázás Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Kapcsolati Hálózat / Maximális Tulajdonos Diler",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Maximális Tulajdonos Diler részére.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Kapcsolati Hálózat / Minimális Vásárló Szállítási Távolság",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Vásárló Szállítási Távolság részére.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Kapcsolati Hálózat / Minimális Kapcsolat Forgatás Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Kapcsolat Forgatás Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Kapcsolati Hálózat / Minimális Kereslet Újraindítás Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Kereslet Újraindítás Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Kapcsolati Hálózat / Minimális Figyelem Szint Szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Figyelem Szint Szorzó részére.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Kapcsolati Hálózat / Minimális Forrópont Információ Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Információ Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Kapcsolati Hálózat / Minimális Forrópont Sugár",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Sugár részére.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Kapcsolati Hálózat / Minimális Forrópont Forgatás Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Forrópont Forgatás Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Kapcsolati Hálózat / Minimális Listázás Időtartama (perc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Listázás Időtartama (perc) részére.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Kapcsolati Hálózat / Minimális Díj Szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Díj Szorzó részére.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Kapcsolati Hálózat / Minimális Rablás Szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Rablás Szorzó részére.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Minimális Helyi Ár Szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Minimális Helyi Ár Szorzó részére.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Egyéb Drog Ár Szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Egyéb Drog Ár Szorzó részére.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Kapcsolati Hálózat / Fizetési Számla",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Fizetési Számla részére.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Kapcsolati Hálózat / Szállítást követő kereslet-visszaállítás (másodperc)",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Szállítást követő kereslet-visszaállítás (másodperc) részére.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Kapcsolati Hálózat / Preferált drog Ár szorzó",
                    description = "Futtatás idején alkalmazott beállítás a Kapcsolati Hálózat / Preferált drog Ár szorzó részére.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Kapcsolati hálózat / Régió / Elhelyezkedés / Bizalom",
                    description = "A Kapcsolati hálózat / Régió / Elhelyezkedés / Bizalom futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Nagykereskedelmi / Maximum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Nagykereskedelmi / Maximum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Nagykereskedelmi / Minimum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Nagykereskedelmi / Minimum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Premium / Maximum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Premium / Maximum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Premium / Minimum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Premium / Minimum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Standard / Maximum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Standard / Maximum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Kapcsolati hálózat / Kérelem / Mennyiségek / Standard / Minimum",
                    description = "A Kapcsolati hálózat / Kérelem / Mennyiségek / Standard / Minimum futásiidős beállítása.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Kapcsolati hálózat / Forgatás / Perc",
                    description = "A Kapcsolati hálózat / Forgatás / Perc futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / X",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / X futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / Y",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / Y futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / Z",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / Z futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / W",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Koordináták / W futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Címke",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Címke futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Ár szorzó",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Ár szorzó futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Régió",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Régió futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Kockázat",
                    description = "A Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 1 / Kockázat futásiidős beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Címke",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Címke.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Árfolyam-szorzó",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Árszorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Régió",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 2 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 2 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Címke",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Címke.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Árfolyam-szorzó",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Árszorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Kapcsolati Hálózat / Elhelyezési Tüskék / Sarokkereskedő / 3 / Régió",
                    description = "Futtatási beállítás a Kapcsolati hálózat / Elhelyezkedési poolok / Sarokkereskedő / 3 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Sarokkereskedő / 3 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Sarokkereskedő / 3 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Megnevezés",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Árszorzó",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Árszorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Régió",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 1 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Megnevezés",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Helyzethalmazok / Alapértelmezett vevő / 2 / Árszorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 2 / Árfolyam-szorzó részére.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 2 / Régió",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 2 / Régió részére.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 2 / Kockázat",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 2 / Kockázat részére.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / X",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / X részére.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / Y",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / Y részére.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / Z",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / W",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Megnevezés",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Árfolyam-szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Árfolyam-szorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Régió",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Kockázat",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett vevő / 3 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / X",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / Y",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / Z",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / W",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Elhelyezési Pótlékok / Alapértelmezett eladó / 1 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Megnevezés",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Árszorzó",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Árszorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Régió",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Kockázat",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 1 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / X",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / Y",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / Z",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / W",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Megnevezés",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Árszorzó",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Árszorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Régió",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Kockázat",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 2 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / X",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / Y",
                    description = "Futtáshelyi beállítás a Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / Z",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / Z futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / W",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Koordináták / W futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Címke",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Címke futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Árfolyam-szorzó",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Árfolyam-szorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Régió",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Régió futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Kockázat",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Alapértelmezett kereskedő / 3 / Kockázat futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / X",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / X futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / Y",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / Y futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / Z",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / Z futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / W",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Koordináták / W futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Címke",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Címke futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Árfolyam-szorzó",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Árfolyam-szorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Régió",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Régió futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Kockázat",
                    description = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 1 / Kockázat futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Kapcsolati hálózat / Elhelyezési csomópontok / Hálózati kereskedő / 2 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Címke",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Címke.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Ár-szorzó",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Ár-szorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Régió",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 2 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Címke",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Címke.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Ár-szorzó",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Ár-szorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Régió",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Kapcsolati Hálózat / Helyszín-pótlások / Hálózati kereskedő / 3 / Kockázat",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Hálózati kereskedő / 3 / Kockázat futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / X",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / X futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / Y",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / Y futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / Z",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / Z futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / W",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Koordináták / W futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Megnevezés",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Megnevezés futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Ár-szorzó",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Ár-szorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Régió",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Régió futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Kockázat",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 1 / Kockázat futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / X",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / X futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / Y",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / Y futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / Z",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / Z futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / W",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Koordináták / W futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Megnevezés",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Megnevezés futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Ár-szorzó",
                    description = "A Kontakthálózat / Elhelyezési csomópontok / Prémium közvetítő / 2 / Ár-szorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 2 / Régió",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 2 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 2 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 2 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Megnevezés",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Ár-szorzó",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Ár-szorzó.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Régió",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Régió.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Kockázat",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Prémium Ügynök / 3 / Kockázat.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / X",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / Y",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / Z",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / W",
                    description = "Futtatási beállítás a Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Koordináták / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Kapcsolati Hálózat / Piaci Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Megnevezés",
                    description = "Futtáskor beállított érték a Kapcsolati Hálózat / Spot Pótlékok / Nagykereskedelmi Kapcsolat / 1 / Megnevezés.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Ár szorzó",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Ár szorzó futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Régió",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Régió futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Kockázat",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 1 / Kockázat futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / X",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / X futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / Y",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / Y futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / Z",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / Z futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / W",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Koordináták / W futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Megnevezés",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Megnevezés futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Ár szorzó",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Ár szorzó futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Régió",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Régió futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Kockázat",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 2 / Kockázat futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 3 / Koordináták / X",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 3 / Koordináták / X futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 3 / Koordináták / Y",
                    description = "A Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 3 / Koordináták / Y futáskor beállított értéke.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Kapcsolati hálózat / Spot Pótlékok / Nagykereskedelmi kapcsolat / 3 / Koordináták / Z",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Koordináták / Z futáskori beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Koordináták / W",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Koordináták / W futáskori beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Megnevezés",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Megnevezés futáskori beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Árszorzó",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Árszorzó futáskori beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Régió",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Régió futáskori beállítása.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Kockázat",
                    description = "A Kapcsolati hálózat / Elhelyezési poolok / Nagykereskedelmi kapcsolat / 3 / Kockázat futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Fogadási bónusz",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Fogadási bónusz futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Archetípus",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Archetípus futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / X",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / X futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / Y",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / Y futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / Z",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Koordináták / Z futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Kereslet bónusz",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Kereslet bónusz futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Forrófok-szorzó",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Forrófok-szorzó futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Azonosító",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Azonosító futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Megnevezés",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Megnevezés futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Kedvelt drogok / 1",
                    description = "A Kapcsolati hálózat / Utcai forró pontok / 1 / Kedvelt drogok / 1 futáskori beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Kapcsolati hálózat / Utcai forró pontok / 1 / Kedvelt drogok / 2",
                    description = "A Kontakthálózat / Utcai forró pontok / 1 / Kedvenc drogok / 2 futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Kontakthálózat / Utcai forró pontok / 1 / Kedvenc drogok / 3",
                    description = "A Kontakthálózat / Utcai forró pontok / 1 / Kedvenc drogok / 3 futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Kontakthálózat / Utcai forró pontok / 1 / Kedvenc drogok / 4",
                    description = "A Kontakthálózat / Utcai forró pontok / 1 / Kedvenc drogok / 4 futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Kontakthálózat / Utcai forró pontok / 1 / Árszorzó",
                    description = "A Kontakthálózat / Utcai forró pontok / 1 / Árszorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Kontakthálózat / Utcai forró pontok / 1 / Sugár",
                    description = "A Kontakthálózat / Utcai forró pontok / 1 / Sugár futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Kontakthálózat / Utcai forró pontok / 1 / Régió",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 1 / Régió futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 1 / Rablás szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati hálózat / Utcai Forrópontok / 1 / Rablás szorzó elemhez.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Elfogadási bónusz",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Elfogadási bónusz futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Alaptípus",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Alaptípus futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / X",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / X futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / Y",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / Y futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / Z",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Koordináták / Z futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kereslet bónusz",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kereslet bónusz futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Fahndungsdruck / Szorzó",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Fahndungsdruck / Szorzó futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / ID",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / ID futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Megnevezés",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Megnevezés futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Minimális minőség",
                    description = "A Kapcsolati Hálózat / Utcai Forrópontok / 2 / Minimális minőség futási idejű beállítása.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kedvenc Drogok / 1",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kedvenc Drogok / 1 számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kedvenc Drogok / 2",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 2 / Kedvenc Drogok / 2 számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Árszorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 2 / Árszorzó számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Sugár",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 2 / Sugár számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 2 / Régió",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 2 / Régió számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 2 / Rablás szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati hálózat / Utcai Forrópontok / 2 / Rablás szorzó elemhez.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Elfogadási bónusz",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Elfogadási bónusz számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Alaptípus",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Alaptípus számára.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / X",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / Y",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / Z",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kereslet bónusz",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kereslet bónusz.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Fahndalási nyomás / Szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Fahndalási nyomás / Szorzó.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Azonosító",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Azonosító.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Felirat",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Felirat.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 1",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 2",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 3",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Kedvenc drogok / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Ár szorzó",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Ár szorzó.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Sugár",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Sugár.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Régió",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Régió.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 3 / Rablás szorzó",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 3 / Rablás szorzó.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Elfogadási bónusz",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Elfogadási bónusz.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Archetípus",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Archetípus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / X",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / Y",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / Z",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Koordináták / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Kereslet bónusz",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Kereslet bónusz.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Figyelem szorzó",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Figyelem szorzó.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 4 / Azonosító",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 4 / Címke",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Megnevezés.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 4 / Preferált drogok / 1",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Kedvenc Drogok / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 4 / Preferált drogok / 2",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Kedvenc Drogok / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Kapcsolati hálózat / Utcai Forrópontok / 4 / Kedvelt drogok / 3",
                    description = "Futtási beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Kedvenc Drogok / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Ár szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Árszorzó részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Sugár",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Sugár részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Régió",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Régió részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 4 / Rablás szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 4 / Rablás szorzó részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Elfogadási bónusz",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Elfogadási bónusz részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Alaptípus",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Alaptípus részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / X",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / X részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / Y",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / Y részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / Z",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Koordináták / Z részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Kereslet bónusz",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Kereslet bónusz részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Figyelem szorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Figyelem szorzó részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / ID",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / ID részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Címke",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Címke részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Preferált drogok / 1",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Preferált drogok / 1 részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Preferált drogok / 2",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Preferált drogok / 2 részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Árszorzó",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Árszorzó részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Sugár",
                    description = "Futtatási idejű beállítás a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Sugár részére.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Régió",
                    description = "Időjárás beállítása a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Régió esetén",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Kapcsolati Hálózat / Utcai Forrópontok / 5 / Rablás-szorzó",
                    description = "Időjárás beállítása a Kapcsolati Hálózat / Utcai Forrópontok / 5 / Rablás-szorzó esetén",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Kapcsolati Hálózat / Bizalomszintek / Ismert",
                    description = "Időjárás beállítása a Kapcsolati Hálózat / Bizalomszintek / Ismert esetén",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Kapcsolati Hálózat / Bizalomszintek / Megbízható",
                    description = "Időjárás beállítása a Kapcsolati Hálózat / Bizalomszintek / Megbízható esetén",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Kapcsolati Hálózat / Bizalomszintek / Megbízott",
                    description = "Időjárás beállítása a Kapcsolati Hálózat / Bizalomszintek / Megbízott esetén",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Vállalati Hálózat / Cselekvés-hűtőidő / Másodperc",
                    description = "Időjárás beállítása a Vállalati Hálózat / Cselekvés-hűtőidő / Másodperc esetén",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Vállalati Hálózat / Egyenleg / Alapár / Egységár",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Alapár / Egységár esetén",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Vállalati Hálózat / Egyenleg / Hálózati nyomás / Értékesítőnként",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Hálózati nyomás / Értékesítőnként esetén",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Vállalati Hálózat / Egyenleg / Hálózati nyomás / Központonként",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Hálózati nyomás / Központonként esetén",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Vállalati Hálózat / Egyenleg / Hálózati nyomás / Útvonalanként",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Hálózati nyomás / Útvonalanként esetén",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Vállalati Hálózat / Egyenleg / Hálózati nyomás / Munkatársanként",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Hálózati nyomás / Munkatársanként esetén",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Vállalati Hálózat / Egyenleg / Megbízhatóság / Nyereség",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Megbízhatóság / Nyereség esetén",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Vállalati Hálózat / Egyenleg / Megbízhatóság / Kár",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Megbízhatóság / Kár esetén",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Vállalati Hálózat / Egyenleg / Útvonalnyomás / Csökkenés",
                    description = "Időjárás beállítása a Vállalati Hálózat / Egyenleg / Útvonalnyomás / Csökkenés esetén",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Vállalati Hálózat / Szerződések / Kategóriák / Gang / Mennyiség / 1",
                    description = "Időjárás beállítás a Vállalati Hálózat / Szerződések / Kategóriák / Banda / Mennyiség / 1 esetén",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Vállalati Hálózat / Szerződések / Kategóriák / Banda / Mennyiség / 2",
                    description = "Időjárás beállítás a Vállalati Hálózat / Szerződések / Kategóriák / Banda / Mennyiség / 2 esetén",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Vállalati Hálózat / Szerződések / Kategóriák / Banda / Minimális rang",
                    description = "Időjárás beállítás a Vállalati Hálózat / Szerződések / Kategóriák / Banda / Minimális rang esetén",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / minőség / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / minőség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / minőség / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / minőség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / jutalom / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / jutalom / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / jutalom / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / jutalom / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / kockázat / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / kockázat / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / banda / kockázat / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / banda / kockázat / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / mennyiség / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / mennyiség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / mennyiség / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / mennyiség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / minimális rang",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / minimális rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / minőség / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / minőség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / minőség / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / minőség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / jutalom / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / jutalom / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / jutalom / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / jutalom / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / kockázat / 1",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / kockázat / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / NPC hálózat / kockázat / 2",
                    description = "Futtatási beállítás: üzleti hálózat / szerződések / kategóriák / NPC hálózat / kockázat / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / mennyiség / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / mennyiség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / mennyiség / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / mennyiség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / minimális rang",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / minimális rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / minőség / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / minőség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / minőség / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / minőség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / jutalom / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / jutalom / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / jutalom / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / jutalom / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / kockázat / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / kockázat / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / szervezet / kockázat / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / szervezet / kockázat / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / mennyiség / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / mennyiség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / mennyiség / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / mennyiség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / minimális rang",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / minimális rang.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / minőség / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / minőség / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / minőség / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / minőség / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / jutalom / 1",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / jutalom / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Üzleti hálózat / szerződések / kategóriák / prémium / jutalom / 2",
                    description = "Futtatási beállítás üzleti hálózat / szerződések / kategóriák / prémium / jutalom / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Prémium / Kockázat / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Prémium / Kockázat / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Prémium / Kockázat / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Prémium / Kockázat / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Mennyiség / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Mennyiség / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Mennyiség / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Mennyiség / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minimális rang",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minimális rang futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minőség / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minőség / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minőség / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Minőség / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Díjazás / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Díjazás / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Díjazás / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Díjazás / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Kockázat / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Kockázat / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Kockázat / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Kiskereskedő / Kockázat / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Mennyiség / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Mennyiség / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Mennyiség / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Mennyiség / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minimális rang",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minimális rang futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minőség / 1",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minőség / 1 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minőség / 2",
                    description = "Futtárbázis / Ügyletek / Kategóriák / Különleges / Minőség / 2 futtási beállítás",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Díj / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Díj / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Díj / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Díj / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Kockázat / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Kockázat / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Kockázat / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Különleges / Kockázat / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Mennyiség / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Mennyiség / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Mennyiség / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Mennyiség / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minimális rang",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minimális rang futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minőség / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minőség / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minőség / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Minőség / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Díj / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Díj / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Díj / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Díj / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Kockázat / 1",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Kockázat / 1 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Kockázat / 2",
                    description = "Üzleti Hálózat / Szerződések / Kategóriák / Nagykereskedelem / Kockázat / 2 futási beállítás.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Üzleti Hálózat / Szerződések / Szállítási távolság",
                    description = "Futási beállítás az Üzleti Hálózat / Szerződések / Szállítási távolsághoz.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Üzleti Hálózat / Szerződések / Időtartam / Perc / Maximum",
                    description = "Futási beállítás az Üzleti Hálózat / Szerződések / Időtartam / Perc / Maximumhoz.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Üzleti Hálózat / Szerződések / Időtartam / Perc / Minimum",
                    description = "Futási beállítás az Üzleti Hálózat / Szerződések / Időtartam / Perc / Minimumhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / X",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / X-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / Y",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / Y-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / Z",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Koordináták / Z-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / ID",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / ID-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Megnevezés",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Megnevezéshez.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Régió",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Régióhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Díj / Szorzó",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Díj / Szorzóhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Kockázat",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 1 / Kockázathoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / X",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / X-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / Y",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / Y-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / Z",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Koordináták / Z-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / ID",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / ID-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Megnevezés",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Megnevezéshez.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Régió",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Régióhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Díj / Szorzó",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Díj / Szorzóhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Kockázat",
                    description = "Időben futó beállítás az Üzleti Hálózat / Szerződések / Találkozási pontok / 2 / Kockázathoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / X",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / X-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / Y",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / Y-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / Z",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Koordináták / Z-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / ID",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / ID-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Megnevezés",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Megnevezéshez.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Régió",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Régióhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Díj-szorzó",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Díj-szorzóhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 3 / Kockázat",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 3 / Kockázathoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / X",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / X-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / Y",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / Y-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / Z",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Koordináták / Z-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / ID",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / ID-hoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Megnevezés",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Megnevezéshez.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Régió",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Régióhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Díj-szorzó",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Díj-szorzóhoz.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Üzleti Hálózat / Szerződések / Találkozók / 4 / Kockázat",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Szerződések / Találkozók / 4 / Kockázathoz.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Üzleti Hálózat / Szerződések / Megállapodás / Előleg / Opciók / 1",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Előleg / Opciók / 1 futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Előleg / Opciók / 2",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Előleg / Opciók / 2 futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Előleg / Opciók / 3",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Előleg / Opciók / 3 futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Mennyiség / Rugalmasság / Százalék",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Mennyiség / Rugalmasság / Százalék futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Alap elfogadási szint",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Alap elfogadási szint futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Határidő / Rugalmasság / Százalék",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Határidő / Rugalmasság / Százalék futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Maximális körök",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Maximális körök futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Minőség / Rugalmasság",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Minőség / Rugalmasság futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Elutasítás / Hűtési idő (perc)",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Elutasítás / Hűtési idő (perc) futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Üzleti hálózat / Szerződések / Megállapodás / Környomás",
                    description = "Az Üzleti hálózat / Szerződések / Megállapodás / Környomás futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Üzleti hálózat / Szerződések / Ajánlatok száma",
                    description = "Az Üzleti hálózat / Szerződések / Ajánlatok száma futási beállítása.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Üzleti hálózat / Szerződések / Frissítési idő (perc)",
                    description = "Az Üzleti hálózat / Szerződések / Frissítési idő (perc) futási beállítása.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Üzleti hálózat / Alapértelmezett üzleti név",
                    description = "Az Üzleti hálózat / Alapértelmezett üzleti név futási beállítása.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Üzleti hálózat / Alapértelmezett rang ID",
                    description = "Az Üzleti hálózat / Alapértelmezett rang ID futási beállítása.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Üzleti hálózat / Alapértelmezett személyzet stílus",
                    description = "Az Üzleti hálózat / Alapértelmezett személyzet stílus futási beállítása.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Üzleti hálózat / Alapértelmezett közlekedés",
                    description = "Az Üzleti hálózat / Alapértelmezett közlekedés futási beállítása.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Üzleti hálózat / Engedélyezve",
                    description = "Az Üzleti hálózat / Engedélyezve futási beállítása.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Üzleti hálózat / Központok / Szállítóközpont / Kapacitás",
                    description = "Az Üzleti hálózat / Központok / Szállítóközpont / Kapacitás futási beállítás.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Üzleti hálózat / Központok / Szállítóközpont / Vevési ár",
                    description = "Üzleti hálózat / Központok / Szállítóközpont / Vevési ár futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Üzleti hálózat / Központok / Szállítóközpont / Biztonság",
                    description = "Üzleti hálózat / Központok / Szállítóközpont / Biztonság futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Üzleti hálózat / Központok / Szállítóközpont / Karbantartás",
                    description = "Üzleti hálózat / Központok / Szállítóközpont / Karbantartás futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Üzleti hálózat / Központok / Tároló / Kapacitás",
                    description = "Üzleti hálózat / Központok / Tároló / Kapacitás futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Üzleti hálózat / Központok / Tároló / Vevési ár",
                    description = "Üzleti hálózat / Központok / Tároló / Vevési ár futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Üzleti hálózat / Központok / Tároló / Biztonság",
                    description = "Üzleti hálózat / Központok / Tároló / Biztonság futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Üzleti hálózat / Központok / Tároló / Karbantartás",
                    description = "Üzleti hálózat / Központok / Tároló / Karbantartás futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Üzleti hálózat / Központok / Raktár / Kapacitás",
                    description = "Üzleti hálózat / Központok / Raktár / Kapacitás futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Üzleti hálózat / Központok / Raktár / Vevési ár",
                    description = "Üzleti hálózat / Központok / Raktár / Vevési ár futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Üzleti hálózat / Központok / Raktár / Biztonság",
                    description = "Üzleti hálózat / Központok / Raktár / Biztonság futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Üzleti hálózat / Központok / Raktár / Karbantartás",
                    description = "Üzleti hálózat / Központok / Raktár / Karbantartás futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Üzleti hálózat / Korlátok / Aktív szerződések",
                    description = "Üzleti hálózat / Korlátok / Aktív szerződések futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Üzleti hálózat / Korlátok / Központok",
                    description = "Üzleti hálózat / Korlátok / Központok futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Üzleti hálózat / Korlátok / Könyvelési sorok",
                    description = "Üzleti hálózat / Korlátok / Könyvelési sorok futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Üzleti hálózat / Korlátok / Útvonalak",
                    description = "Üzleti hálózat / Korlátok / Útvonalak futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Üzleti hálózat / Korlátok / Személyzet",
                    description = "Üzleti hálózat / Korlátok / Személyzet futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Üzleti hálózat / Kifizetési fiók",
                    description = "Üzleti hálózat / Kifizetési fiók futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Üzleti hálózat / Rangsorok / 1 / Szerződések",
                    description = "Üzleti hálózat / Rangsorok / 1 / Szerződések futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Üzleti hálózat / Rangsorok / 1 / Értékesítők",
                    description = "Üzleti hálózat / Rangsorok / 1 / Értékesítők futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Üzleti hálózat / Rangsorok / 1 / Központok",
                    description = "Üzleti hálózat / Rangsorok / 1 / Központok futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Üzleti hálózat / Rangsorok / 1 / ID",
                    description = "Üzleti hálózat / Rangsorok / 1 / ID futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Üzleti hálózat / Rangsorok / 1 / Megnevezés",
                    description = "Üzleti hálózat / Rangsorok / 1 / Megnevezés futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Üzleti hálózat / Rangsorok / 1 / Útvonalak",
                    description = "Üzleti hálózat / Rangsorok / 1 / Útvonalak futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Üzleti hálózat / rangok / 1 / pontszám",
                    description = "Üzleti hálózat / Rangsorok / 1 / Pontszám futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Üzleti hálózat / rangok / 1 / személyzet",
                    description = "Üzleti hálózat / Rangsorok / 1 / Személyzet futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Üzleti hálózat / rangok / 2 / szerződések",
                    description = "Üzleti hálózat / Rangsorok / 2 / Szerződések futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Üzleti hálózat / rangok / 2 / kereskedők",
                    description = "Üzleti hálózat / Rangsorok / 2 / Kereskedők futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Üzleti hálózat / rangok / 2 / központok",
                    description = "Üzleti hálózat / Rangsorok / 2 / Központok futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Üzleti hálózat / rangok / 2 / azonosító",
                    description = "Üzleti hálózat / Rangsorok / 2 / Azonosító futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Üzleti hálózat / rangok / 2 / jelölés",
                    description = "Üzleti hálózat / Rangsorok / 2 / Jelölés futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Üzleti hálózat / rangok / 2 / útvonalak",
                    description = "Üzleti hálózat / Rangsorok / 2 / Útvonalak futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Üzleti hálózat / rangok / 2 / pontszám",
                    description = "Üzleti hálózat / Rangsorok / 2 / Pontszám futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Üzleti hálózat / rangok / 2 / személyzet",
                    description = "Üzleti hálózat / Rangsorok / 2 / Személyzet futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Üzleti hálózat / rangok / 3 / szerződések",
                    description = "Üzleti hálózat / Rangsorok / 3 / Szerződések futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Üzleti hálózat / rangok / 3 / kereskedők",
                    description = "Üzleti hálózat / Rangsorok / 3 / Kereskedők futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Üzleti hálózat / rangok / 3 / központok",
                    description = "Üzleti hálózat / Rangsorok / 3 / Központok futási idejű beállítása.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Üzleti hálózat / rangok / 3 / azonosító",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 3 / azonosítójához.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Üzleti hálózat / rangok / 3 / jelölés",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 3 / jelöléséhez.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Üzleti hálózat / rangok / 3 / útvonalak",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 3 / útvonalaihoz.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Üzleti hálózat / rangok / 3 / pontszám",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 3 / pontszámához.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Üzleti hálózat / rangok / 3 / személyzet",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 3 / személyzetéhez.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Üzleti hálózat / rangok / 4 / szerződések",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / szerződéseihöz.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Üzleti hálózat / rangok / 4 / kereskedők",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / kereskedőihöz.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Üzleti hálózat / rangok / 4 / központok",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / központjaihoz.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Üzleti hálózat / rangok / 4 / azonosító",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / azonosítójához.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Üzleti hálózat / rangok / 4 / jelölés",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / jelöléséhez.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Üzleti hálózat / rangok / 4 / útvonalak",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / útvonalaihoz.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Üzleti Hálózat / Rangsorok / 4 / Pontszám",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / pontszámához.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Üzleti Hálózat / Rangsorok / 4 / Személyzet",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 4 / személyzetéhez.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Szerződések",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / szerződéseihöz.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Dealerek",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / kereskedőihöz.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Központok",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / központjaihoz.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Azonosító",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / azonosítójához.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Megnevezés",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / jelöléséhez.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Útvonalak",
                    description = "Futtatási beállítás az Üzleti hálózat / rangok / 5 / útvonalaihoz.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Pontszám",
                    description = "Futtatási beállítás az Üzleti Hálózat / Rangsorok / 5 / Pontszámhoz.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Üzleti Hálózat / Rangsorok / 5 / Személyzet",
                    description = "Futtatási beállítás az Üzleti Hálózat / Rangsorok / 5 / Személyzethez.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Üzleti Hálózat / Jelentési Napok",
                    description = "Futtatási beállítás az Üzleti Hálózat / Jelentési Napokhoz.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Vásárló",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Vásárlóhoz.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Szerződés",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Szerződéshez.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Dealer",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Dealerekhez.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Bűnözőcsoport",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Bűnözőcsoportokhoz.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Központ",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Központokhoz.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Labor",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Laborhoz.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Szervezet",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Szervezetekhez.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Üzleti Hálózat / Útvonal / Célpont / Típusok / Kiskereskedő",
                    description = "Futtatási beállítás az Üzleti Hálózat / Útvonal / Célpont / Típusok / Kiskereskedőkhöz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Ritmus / Perc / Maximum",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Ritmus / Perc / Maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Ritmus / Perc / Minimum",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Ritmus / Perc / Minimumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Hűtési idő / Minimum / Perc",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Hűtési idő / Minimum / Perc.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Kudarc / Megbízhatóság / Veszteség",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Kudarc / Megbízhatóság / Veszteség.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Minimum / Ütem / Perc",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Minimum / Ütem / Perc.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Üzleti Hálózat / Futtatás / Szerződés / Minimum / Találkozó / Szorzó",
                    description = "Futtatási beállítás az Üzleti Hálózat / Futtatás / Szerződés / Minimum / Találkozó / Szorzó.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Üzleti hálózat / futás / szerződés bírság növekedés",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés bírság növekedéshez.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Üzleti hálózat / futás / szerződés bírság szorzó",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés bírság szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Üzleti hálózat / futás / szerződés minőség kudarc hűtési idő perc",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés minőség kudarc hűtési idő perc-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Üzleti hálózat / futás / szerződés minőség ár alapérték",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés minőség ár alapértékhez.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Üzleti hálózat / futás / szerződés minőség ár osztó",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés minőség ár osztóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Üzleti hálózat / futás / szerződés megbízhatóság veszteség alapérték",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés megbízhatóság veszteség alapértékhez.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Üzleti hálózat / futás / szerződés megbízhatóság veszteség maximum",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés megbízhatóság veszteség maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Üzleti hálózat / futás / szerződés megbízhatóság veszteség minőség súly",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés megbízhatóság veszteség minőség súlyhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Üzleti hálózat / futás / szerződés hírnév minőség súly",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés hírnév minőség súlyhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Üzleti hálózat / futás / szerződés kockázat súlyok kategória",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés kockázat súlyok kategóriához.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Üzleti hálózat / futás / szerződés kockázat súlyok találkozó",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / szerződés kockázat súlyok találkozóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Üzleti hálózat / futás / alapértelmezett központ kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / alapértelmezett központ kapacitáshoz.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Üzleti hálózat / futás / alapértelmezett központ biztonság",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / alapértelmezett központ biztonsághoz.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Üzleti hálózat / futás / alapértelmezett találkozó kockázat",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / alapértelmezett találkozó kockázathoz.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Üzleti hálózat / futás / alapértelmezett minőség",
                    description = "Futtatási beállítás az Üzleti hálózat / futás / alapértelmezett minőséghez.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Üzleti hálózat / futás / alapértelmezett útvonal kapacitás",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Alapértelmezett Útvonal Kapacitáshoz.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Üzleti Hálózat / Futtatási idő / Alapértelmezett Útvonal Intervallum Perc",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Alapértelmezett Útvonal Intervallum Perc.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Üzleti Hálózat / Játékmenet / Alapértelmezett Útvonal Kockázat",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Alapértelmezett Útvonal Kockázathoz.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Fahndungsnyomás Elhalványulás",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Fahndungsnyomás Elhalványuláshoz.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Terhelés Fahndungsnyomás",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Terhelés Fahndungsnyomáshoz.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Támadás Felépülés Perc",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Támadás Felépülés Perc.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Biztonság Költség Alapérték",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Biztonság Költség Alapértékhez.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Biztonság Költség Szintenként",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Biztonság Költség Szintenként.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Biztonság Maximum",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Biztonság Maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Biztonság Frissítés",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Biztonság Frissítéshez.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Fizetetlen Fahndungsnyomás",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Fizetetlen Fahndungsnyomás.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Fizetetlen Biztonságvesztés",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Fizetetlen Biztonságvesztés.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Üzleti Hálózat / Futtatási idő / Központ Karbantartás Intervallum Óra",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Központ Karbantartás Intervallum Órához.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Üzleti Hálózat / Futtatási idő / Kezdeti Megbízhatóság",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Kezdeti Megbízhatósághoz.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Üzleti Hálózat / Futtatási idő / Maximum Üzleti Nevezés Hossz",
                    description = "Futtatási idejű beállítás az Üzleti Hálózat / Futtatási idő / Maximum Üzleti Nevezés Hosszához.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Üzleti Hálózat / Futtatási idő / Minimum Szerződés Szállítás Perc",
                    description = "Időbeli beállítás az Üzleti Hálózat / Játékmenet / Minimum Szerződés Szállítás Percéhez.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Üzleti Hálózat / Játékmenet / Minimum Szállítási Távolság",
                    description = "Időbeli beállítás az Üzleti Hálózat / Játékmenet / Minimum Szállítási Távolsághoz.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Üzleti Hálózat / Játékmenet / Minimum Könyvelési Sorok",
                    description = "Időbeli beállítás az Üzleti Hálózat / Játékmenet / Minimum Könyvelési Sorokhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Üzleti hálózat / Játékmenet / Minimális útvonalintervallum (perc)",
                    description = "Üzleti hálózat / Játékmenet / Minimális útvonalintervallum (perc) beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás előlegköltség-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás előlegköltség-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás előlegár-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás előlegár-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás mennyiségköltség-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás mennyiségköltség-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás mennyiség rugalmassági maximum",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás mennyiség rugalmassági maximum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás mennyiségkockázat-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás mennyiségkockázat-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás ellenajánlat-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás ellenajánlat-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás határidő rugalmassági maximum",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás határidő rugalmassági maximum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás maximális elfogadása",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás maximális elfogadás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás minimális elfogadása",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás minimális elfogadás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás minőség előny-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás minőség előny-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás minőség költség-súlyozás",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás minőség költség-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Üzleti hálózat / Játékmenet / Megállapodás minőség rugalmassági maximum",
                    description = "Üzleti hálózat / Játékmenet / Megállapodás minőség rugalmassági maximum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás minősége jutalom-súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás minősége jutalom-súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás megbízhatósága súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás megbízhatósága súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás hírneve súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás hírneve súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás kért jutalma maximum",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás kért jutalma maximum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás kért jutalma minimum",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás kért jutalma minimum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás jutalomköltsége súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás jutalomköltsége súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás jutalma maximum",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás jutalma maximum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás jutalma minimum",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás jutalma minimum beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás sürgettség alapértéke",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás sürgettség alapértéke beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése haszon súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése haszon súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése kockázat súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése kockázat súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Megállapodás sürgetése súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Üzleti hálózat / Futtatási idő / Egyéb sikertelen próbálkozás nyomás",
                    description = "Üzleti hálózat / Futtatási idő / Egyéb sikertelen próbálkozás nyomás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Személyes nyomás súlyozás",
                    description = "Üzleti hálózat / Futtatási idő / Személyes nyomás súlyozás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Üzleti hálózat / Futtatási idő / Rendőrségi sikertelen próbálkozás nyomás",
                    description = "Üzleti hálózat / Futtatási idő / Rendőrségi sikertelen próbálkozás nyomás beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Üzleti hálózat / Futtatási idő / Eladó alapértelmezett egységek",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Alapértelmezett Egységekhez.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Nagykereskedelmi Szorzó",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Nagykereskedelmi Szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Olcsó Szorzó",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Olcsó Szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Tapasztalat Szintenként",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Tapasztalat Szintenként.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Tapasztalat Egységenként",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Tapasztalat Egységenként.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Központ Nyomás Egységenként",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Központ Nyomás Egységenként.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Prémium Szorzó",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Prémium Szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Készség Osztó",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Készség Osztó.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Üzleti Hálózat / Időfuttatás / Pusher Készség Nyereség",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Pusher Készség Nyereség.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Időtartam Alapértelmezett Másodperc",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Időtartam Alapértelmezett Másodperc.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Időtartam Egységenkénti Másodperc",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Időtartam Egységenkénti Másodperc.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 1",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 2",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 3",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 4",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Kudarc Okai / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Üzleti hálózat / Futtatás / Útvonal-sikertelenség-érték szorzó",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Útvonal-sikertelenség-érték szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Nyomás Mennyiség Osztó",
                    description = "Időfuttatási beállítás az Üzleti Hálózat / Időfuttatás / Útvonal Nyomás Mennyiség Osztó.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Üzleti Hálózat / Időfuttatás / Útvonal Nyomás Csökkentés Alapértelmezett Költség",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal nyomásszint csökkentés alapérték futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal nyomásszint csökkentés egységnyi költség",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal nyomásszint csökkentés egységnyi költség futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázat maximum",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázat maximum futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázat minimum",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázat minimum futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Nyomás",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Nyomás futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Hűség",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Hűség futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Futár kockázat",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Futár kockázat futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Készség",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal kockázati súlyozás / Készség futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal váltás nyomásszint csökkentés",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal váltás nyomásszint csökkentés futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal váltás kockázat csökkentés",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal váltás kockázat csökkentés futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés minőségi alapérték",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés minőségi alapérték futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés minőségi osztó",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés minőségi osztó futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés kockázati osztó",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal értékesítés kockázati osztó futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Üzleti hálózat / Futtatási idő / Útvonal indulási nyomásszint",
                    description = "Üzleti hálózat / Futtatási idő / Útvonal indulási nyomásszint futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Üzleti hálózat / Futtatási idő / Futár tapasztalat / Szintenként",
                    description = "Üzleti hálózat / Futtatási idő / Futár tapasztalat / Szintenként futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Üzleti hálózat / Futtatási idő / Futár tapasztalat / Egységenként",
                    description = "Üzleti hálózat / Futtatási idő / Futár tapasztalat / Egységenként futtató beállítás.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Üzleti Hálózat / Futtatás / Kurír / Sikertelenség / Hűségvesztés",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Kurír / Sikertelenség / Hűségvesztéséhez.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Üzleti Hálózat / Futtatás / Kurír / Sikertelenség / Kockázatnövekedés",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Kurír / Sikertelenség / Kockázatnövekedéséhez.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Üzleti Hálózat / Futtatás / Kurír / Készségnövekedés",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Kurír / Készségnövekedéséhez.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Hőfok",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Hőfokhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Megbízhatóság",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Megbízhatósághoz.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Reputáció",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Reputációhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Struktúra",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Pontszám-súlyozások / Struktúrához.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Kapacitás / Alapérték / Szorzó",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Kapacitás / Alapérték / Szorzójához.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Hűség / Maximum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Hűség / Maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Hűség / Minimum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Hűség / Minimumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Kockázat / Maximum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Kockázat / Maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Kockázat / Minimum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Kockázat / Minimumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Készség / Maximum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Készség / Maximumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Készség / Minimum",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Felvétele / Készség / Minimumhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Incidens / Hűség / Súly",
                    description = "Időbeni beállítás az Üzleti Hálózat / Futtatás / Személyzet / Incidens / Hűség / Súlyhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Üzleti Hálózat / Futtatás / Személyzet / Incidens / Maximum / Esély",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Maximum / Esély futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 1",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 1 futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 2",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 2 futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 3",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 3 futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 4",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Eredmények / 4 futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Kockázat / Súly",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Incidens / Kockázat / Súly futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Hűség / Csökkenés",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Hűség / Csökkenés futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Maximum / Szint",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Maximum / Szint futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Abvervált hűségvesztés",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Abvervált hűségvesztés futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Alapköltség",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Alapköltség futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Óra",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Óra futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Incidens / Csökkentés",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Incidens / Csökkentés futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Kockázat / Költség",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Védelem / Kockázat / Költség futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Felépülés / Alapesély",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Felépülés / Alapesély futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Felépülés / Hűség / Súly",
                    description = "Üzleti hálózat / Futtatási idő / Személyzet / Felépülés / Hűség / Súly futtatási beállítása.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Üzleti hálózat / Futtatási idő / Személyzet / Bér / Alapköltség / Szorzó",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti béralapozó szorzóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti béralapozó hűségnyereség",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti béralapozó hűségnyereséghez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti béralapozó készségosztó",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti béralapozó készségosztóhoz.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 1",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 1-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 2",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 2-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 3",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 3-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 4",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 4-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 5",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 5-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 6",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Személyzeti gyengeségek / 6-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Üzleti hálózat / Futtatás / Strukturális súlyozások / Szerződések",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Strukturális súlyozások / Szerződések-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Üzleti hálózat / Futtatás / Strukturális súlyozások / Dealerek",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Strukturális súlyozások / Dealerek-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Üzleti hálózat / Futtatás / Strukturális súlyozások / Központok",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Strukturális súlyozások / Központok-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Üzleti hálózat / Futtatás / Strukturális súlyozások / Útvonalak",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Strukturális súlyozások / Útvonalak-hez.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Üzleti hálózat / Futtatás / Strukturális súlyozások / Személyzet",
                    description = "Futtatási beállítás az Üzleti hálózat / Futtatás / Strukturális súlyozások / Személyzet-hez.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Üzleti hálózat / Társadalmi engedély",
                    description = "Futtatási beállítás az Üzleti hálózat / Társadalmi engedély-hez.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Üzleti hálózat / Személyzet / Pusher / Alapkapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Pusher / Alapkapacitás-hez.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Üzleti hálózat / Személyzet / Pusher / Alapbér",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Kereskedő / Alapbér-hez.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Üzleti hálózat / Személyzet / Kereskedő / Bizottság",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Kereskedő / Bizottság-hez.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Üzleti hálózat / Személyzet / Kereskedő / Bérleti ár",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Kereskedő / Bérleti ár-hez.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Üzleti hálózat / Személyzet / Futár / Alapkapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Futár / Alapkapacitás-hez.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Üzleti hálózat / Személyzet / Futár / Alapfizetés",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Futár / Alapfizetés-hez.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Üzleti hálózat / Személyzet / Futár / Bizottság",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Futár / Bizottság-hez.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Üzleti hálózat / Személyzet / Futár / Bérleti ár",
                    description = "Futtatási beállítás az Üzleti hálózat / Személyzet / Futár / Bérleti ár-hez.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Üzleti hálózat / Ciklusidő / Perc",
                    description = "Futtatási beállítás az Üzleti hálózat / Ciklusidő / Perc-hez.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Üzleti hálózat / Szállítások / Repülőgép / Kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Repülőgép / Kapacitás-hez.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Üzleti hálózat / Szállítások / Repülőgép / Költség",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Repülőgép / Költség-hez.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Üzleti hálózat / Szállítások / Repülőgép / Időtényező",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Repülőgép / Időtényező-hez.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Üzleti hálózat / Szállítások / Repülőgép / Kockázat",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Repülőgép / Kockázat-hez.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Üzleti hálózat / Szállítások / Hajó / Kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Hajó / Kapacitás-hez.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Üzleti hálózat / Szállítások / Hajó / Költség",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Hajó / Költség-hez.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Üzleti hálózat / Szállítások / Hajó / Időtényező",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Hajó / Időtényező-hez.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Üzleti hálózat / Szállítások / Hajó / Kockázat",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Hajó / Kockázat-hez.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Üzleti hálózat / Szállítások / Autó / Kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Autó / Kapacitás-hez.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Üzleti hálózat / Szállítások / Autó / Költség",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Autó / Költség számára.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Üzleti Hálózat / Szállítások / Autó / Időtényező",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Autó / Időtényező számára.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Üzleti Hálózat / Szállítások / Autó / Kockázat",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Autó / Kockázat számára.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Üzleti Hálózat / Szállítások / Gyalog / Kapacitás",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Gyalog / Kapacitás számára.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Üzleti Hálózat / Szállítások / Gyalog / Költség",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Gyalog / Költség számára.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Üzleti Hálózat / Szállítások / Gyalog / Időtényező",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Gyalog / Időtényező számára.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Üzleti Hálózat / Szállítások / Gyalog / Kockázat",
                    description = "Futtatási beállítás az Üzleti Hálózat / Szállítások / Gyalog / Kockázat számára.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Kapacitás számára.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Költség",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Költség számára.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Időtényező",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Időtényező számára.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Kockázat",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Kockázat számára.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Kapacitás",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Kapacitás számára.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Költség",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Költség számára.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Időtényező",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Időtényező számára.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Üzleti hálózat / Szállítások / Teherautó / Kockázat",
                    description = "Futtatási beállítás az Üzleti hálózat / Szállítások / Teherautó / Kockázat számára.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Általános integráció",
                        custom = "Egyedi integráció",
                        none = "Letiltva",
                    },
                },
                reputationRules = {
                    label = "Hírnévszabályok",
                    description = "Nevesített szabályok beállítása műveletekhez és opcionális célpontokhoz. Csak az engedélyezett szabályok adnak pontot.",
                },
            },
            territoryMap = {
                addPoint = "Pont hozzáadása",
                clear = "Törlés",
                create = "Létrehozás",
                custom = "Egyedi területek",
                deletePoint = "Pont törlése",
                eyebrow = "Terület szerkesztő",
                minimum = "Minimális 3",
                pointCount = "{count} pont",
                presets = "Előbeállított kerületek",
                shown = "Megjelenítés a térképen",
                street = "Utca",
                supply = "Ellátás",
                territories = "Területek",
                type = "Területtípus",
                undo = "Visszavonás",
            },
            shopPositionTools = {
                currentPosition = "Jelenlegi pozíció használata",
                selectEntity = "Entitás kiválasztása",
                selectEntityHint = "A lézerrel célozz meg egy pénztárat vagy trezort. Entér: a kijelölt tárgy pozícióját és irányát használja. Backspace: megszakítás.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Termesztési szintek",
                general = "Általános",
                runtime = "Futtatás idejű hozzáférés",
                quality = "Minőség",
                packaging = "Csomagolás",
                growing = "Termesztés",
                labs = "Laborok és lakókocsik",
                power = "Erőforrás és felszerelés",
                workers = "Munkavállalók",
                market = "Piac és elosztás",
                threats = "Razzia és sabotázás",
                pvpTakeovers = "Laborok elfoglalása",
                consumption = "Fogyasztás",
                processing = "Feldolgozás",
                performance = "Teljesítmény",
                dynamicMarket = "Dinamikus piac",
                heat = "Figyelem és kockázat",
                contacts = "Kapcsolati hálózat",
                business = "Üzleti hálózat",
            },
            drugSettingGroups = {
                cultivationGeneral = {
                    label = "Általános",
                },
                cultivationCurve = {
                    label = "Szintgörbe",
                },
                cultivationExperience = {
                    label = "XP-díjak",
                },
                cultivationUnlocks = {
                    label = "Szintek feloldása",
                },
                creator = {
                    label = "Létrehozói menü",
                },
                creatorSettings = {
                    label = "Létrehozói beállítások",
                },
                interfaceHud = {
                    label = "Felületi pozíciók",
                },
                drugsGeneral = {
                    label = "Általános",
                },
                runtimeAccess = {
                    label = "Hozzáférés és tulajdonlás",
                },
                runtimePayouts = {
                    label = "Kifizetések",
                },
                runtimeDispatch = {
                    label = "Leitstelle és rendőrség",
                },
                qualityWeights = {
                    label = "Minőség súlyozása",
                },
                qualityTiers = {
                    label = "Minőségi szintek",
                },
                packagingGeneral = {
                    label = "Általános",
                },
                growingGeneral = {
                    label = "Általános",
                },
                plantDefaults = {
                    label = "Növények alapértelmezett értékei",
                },
                harvestWindow = {
                    label = "Szüret ablaka",
                },
                labsGeneral = {
                    label = "Általános",
                },
                labRent = {
                    label = "Bérleti díj és élettartam",
                },
                camperDefaults = {
                    label = "Lakóautó",
                },
                labUpgrades = {
                    label = "Frissítések",
                },
                labDefaults = {
                    label = "Laborok alapértelmezett beállításai",
                },
                powerGeneral = {
                    label = "Általános",
                },
                generators = {
                    label = "Generátorok",
                },
                equipmentWear = {
                    label = "Eszközök",
                },
                workersGeneral = {
                    label = "Általános",
                },
                marketGeneral = {
                    label = "Általános",
                },
                marketPrices = {
                    label = "Árak",
                },
                distribution = {
                    label = "Elosztás",
                },
                threatsGeneral = {
                    label = "Általános",
                },
                threatHeat = {
                    label = "Hőmérséklet",
                },
                threatChances = {
                    label = "Lehetőségek",
                },
                pvpTakeoverRules = {
                    label = "Elfoglalási szabályok",
                },
                pvpTakeoverZones = {
                    label = "Zónák és időzítés",
                },
                pvpTakeoverMethods = {
                    label = "Behatolási módszerek",
                },
                consumptionGeneral = {
                    label = "Általános",
                },
                consumerDecay = {
                    label = "Tolerancia és függőség csökkenése",
                },
                consumerEffects = {
                    label = "Hatások és kockázatok",
                },
                processingFlow = {
                    label = "Folyamatmenet",
                },
                processingGeneral = {
                    label = "Általános",
                },
                powerRuntime = {
                    label = "Futtatás ideje",
                },
                powerHeat = {
                    label = "Figyelem és áramjelzés",
                },
                powerModes = {
                    label = "Kezelési módok",
                },
                powerPriorities = {
                    label = "Terhelési prioritások",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inaktív vezérlési intervallum (ms)",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interakció üresjárati szkennelési intervalluma (ms)",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interakció jelzési intervalluma (ms)",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interakció szkennelési intervalluma (ms)",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum szkennelési intervallum (ms)",
                },
                performanceStreetPedActivationDistance = {
                    label = "Utcai NPC aktiválási távolság",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Utcai NPC pihenőidő ellenőrzési intervallum (ms)",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Utcai NPC ellenőrzési intervallum (ms)",
                },
                performanceWorldCachePadding = {
                    label = "Világ gyorsítótár párnázása",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Világ gyorsítótár frissítési intervalluma (ms)",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Világ üresjárati intervalluma (ms)",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Akció hűtési ideje (másodperc)",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Akció előzmények korlátja",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Mennyiség telítési súlya",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Alap intelligencia pontossága",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Alapértelmezett átlagos minőség",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Alapértelmezett erőforrás rugalmassága",
                },
                dynamicMarketDemandCenter = {
                    label = "Kereslet középpontja",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Kereslet árfolyam-hatása",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Irány küszöbértéke",
                },
                dynamicMarketEnabled = {
                    label = "Engedélyezve",
                },
                dynamicMarketEventChance = {
                    label = "Esemény esélye",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Esemény időtartama (perc)",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Esemény minimum időtartama (perc)",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Esemény maximum ereje",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Esemény minimum ereje",
                },
                dynamicMarketEvents = {
                    label = "Események",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Pontos információ hírnév",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Pontos információ bizalom",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Globális zónajelzés",
                },
                dynamicMarketHistoryLimit = {
                    label = "Előzmények korlátja",
                },
                dynamicMarketInitialDemand = {
                    label = "Kezdeti kereslet",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Kezdeti árszorzó",
                },
                dynamicMarketIntelDemandError = {
                    label = "Információ kereslet hiba",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Információ maximum pontossága",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Információ minimum pontossága",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Információ rendőrségi hiba",
                },
                dynamicMarketIntelPriceError = {
                    label = "Információ árkülönbség",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Információ árkülönbség maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Információ minimális ára",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Információ hírnév súlya",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Információ erőforrás árkülönbség",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Információ telítettség hiba",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Információ magvető kosár másodpercek",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Információ státusz pontosság küszöbértéke",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Információ státusz hiba küszöbértéke",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Információ ellátás hiba",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Információ bizalom súlya",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipuláció lehűlési idő perc",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipuláció kereslet eltolódás",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipuláció időtartam perc",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipuláció keresési nyomás",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipuláció minimális tétel mérete",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipuláció fizetési fiók",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipuláció ár",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipuláció zóna keresési nyomás szorzója",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum információ kor perc",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum árszorzó",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum információ kor perc",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum mérési ablak perc",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minimum árszorzó",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum frissítés perc",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Rendőrség kereslet súlya",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Rendőrség árkihatás",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Gyenge minőségű kereslet büntetés",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Gyenge minőség küszöbértéke",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Prémium minőségű kereslet bónusz",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Prémium minőség küszöbértéke",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Termelési ellátás súlya",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Termelési ablak perc",
                },
                dynamicMarketQualityCenter = {
                    label = "Minőség középérték",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Minőség bizalom hatása",
                },
                dynamicMarketQualityRange = {
                    label = "Minőség tartomány",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Ritkaság bónusz maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Régió globális súlya",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Régió helyi súlya",
                },
                dynamicMarketResourceAliases = {
                    label = "Erőforrás aliasok",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Erőforrás irányának csökkenési küszöbértéke",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Erőforrás irányának növekedési küszöbértéke",
                },
                dynamicMarketResources = {
                    label = "Erőforrások",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Eladási időablak (perc)",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Telítettség keresleti súlya",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Telítettség árfolyamhatása",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Hiány keresleti súlya",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Hiány árfolyamhatása",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Évszakvégi hónapok",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Évszaki szorzók",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Hiányra vonatkozó pletyka küszöbértéke",
                },
                dynamicMarketStatusThresholds = {
                    label = "Státusz küszöbértékek",
                },
                dynamicMarketTargetSupply = {
                    label = "Célkészlet",
                },
                dynamicMarketTrendChance = {
                    label = "Trend esélye",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Trend időtartama (perc)",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Trend maximális erőssége",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Trend minimális erőssége",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Frissítési idő (perc)",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatilitás maximuma",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatilitás minimuma",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Időjárási szorzók",
                },
                dynamicMarketWeatherState = {
                    label = "Időjárási állapot",
                },
                heatActionCooldownSeconds = {
                    label = "Akció hűtési ideje (másodperc)",
                },
                heatActivityRiskWeights = {
                    label = "Tevékenység kockázati súlyai",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Aggresszív nyomás szorzó",
                },
                heatBurnerBurnThreshold = {
                    label = "Égető telefon felfedési küszöbértéke",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Égető telefon nyomása nagykereskedésenként",
                },
                heatBurnerPhoneItem = {
                    label = "Égető telefon tárgy",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Kempingező működési nyomás szorzó",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Kempingező működési nyomás küszöbértéke",
                },
                heatCamperParkedHeat = {
                    label = "Kempingező parkolási nyomása",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Szennyezett anyag nyomás szorzó",
                },
                heatContaminatedThreshold = {
                    label = "Szennyezett anyag küszöbértéke",
                },
                heatCultivationFreePlants = {
                    label = "Termesztés: kockázatmentes növények",
                },
                heatCultivationHeatPerPlant = {
                    label = "Termesztés nyomása növényenként",
                },
                heatDealerHiddenMinutes = {
                    label = "Árusító rejtőzködési ideje (perc)",
                },
                heatDecayPerTick = {
                    label = "Csökkenés ciklusonként",
                },
                heatEnabled = {
                    label = "Engedélyezve",
                },
                heatEnforcementHeat = {
                    label = "Végrehajtási nyomás",
                },
                heatEnforcementMultipliers = {
                    label = "Végrehajtási szorzók",
                },
                heatEntityTypes = {
                    label = "Entitás típusok",
                },
                heatEventCooldownMinutes = {
                    label = "Esemény hűtési ideje (perc)",
                },
                heatEventHistoryLimit = {
                    label = "Esemény történeti korlát",
                },
                heatLabHeatSyncThreshold = {
                    label = "Labor nyomásszinkronizációs küszöbértéke",
                },
                heatLayLowCooldownMinutes = {
                    label = "Rejtőzködés hűtési ideje (perc)",
                },
                heatLayLowIdleMinutes = {
                    label = "Rejtőzködés pihenőideje (perc)",
                },
                heatLayLowReduction = {
                    label = "Rejtőzködés csökkentése",
                },
                heatLockdownMinutes = {
                    label = "Zárórást (perc)",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimális időtartam (perc)",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimális esemény hűtési ideje (másodperc)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimális pihenőidő (másodperc)",
                },
                heatProcessingHeatMultiplier = {
                    label = "Feldolgozás nyomás szorzó",
                },
                heatRiskWeights = {
                    label = "Kockázati súlyok",
                },
                heatRotateBurnerReduction = {
                    label = "Égető telefon váltásának csökkentése",
                },
                heatRouteControlMinutes = {
                    label = "Útvonal-irányítás (perc)",
                },
                heatSaleHeat = {
                    label = "Eladási nyomás",
                },
                heatThresholds = {
                    label = "Küszöbértékek",
                },
                heatTickMinutes = {
                    label = "Ciklus időtartam (perc)",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Nagykereskedelmi nyomás szorzó",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Munkavállaló információs szivárgás riasztási sugara",
                },
                heatWorkerLeakBaseChance = {
                    label = "Munkavállaló információs szivárgás alap esélye",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Munkavállaló információs szivárgás frakciós szorzója",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Munkavállaló információs szivárgás magas súlyosságú küszöbértéke",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Munkavállaló információs szivárgás lojalitás esély szorzója",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Munkavállaló információs szivárgás lojalitás küszöbértéke",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Munkavállaló információs szivárgás maximális esélye",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Munkavállaló információs szivárgás minimális hűtési ideje másodpercben",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Munkavállaló információs szivárgás útvonal szorzója",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Munkavállaló információs szivárgás erősség maximuma",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Munkavállaló információs szivárgás erősség minimuma",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Munkavállaló információs szivárgás erősség szorzója",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Munkavállaló információs szivárgás stressz esély szorzója",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Munkavállaló információs szivárgás stressz küszöbértéke",
                },
                contactsActionCooldownSeconds = {
                    label = "Akció hűtési ideje (másodperc)",
                },
                contactsActiveHotspotCount = {
                    label = "Aktív forró pontok száma",
                },
                contactsBurnerHintTrust = {
                    label = "Egyszerűsített telefon tanácsadó bizalma",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Egyszerűsített telefon ajánlat maximum szorzója",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Egyszerűsített telefon ajánlat minimum szorzója",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Vevő hűtési ideje percben",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Vevő szállítási távolság",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Vevő prémium siker pontszám",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Vevő prémium bizalom nyereség",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Vevő kérés nyomás és kockázat súlya",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Vevő szabványos bizalom nyeresége",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Kontakt aktiválási késleltetés másodpercben",
                },
                contactsContactDemandRange = {
                    label = "Kontakt kereslet tartomány",
                },
                contactsContactLossTrust = {
                    label = "Kontakt elvesztett bizalma",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet pontos információk ideje percben",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet forró pont információ ára",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet információ ára",
                },
                contactsDealerBasePrice = {
                    label = "Díler alapára",
                },
                contactsDealerHireCapacity = {
                    label = "Díler felvételi kapacitása",
                },
                contactsDealerHireRisk = {
                    label = "Díler felvételi kockázata",
                },
                contactsDealerHireSkill = {
                    label = "Díler felvételi készsége",
                },
                contactsDealerOffers = {
                    label = "Díler ajánlatok",
                },
                contactsDealerProtectionHours = {
                    label = "Díler védelmi ideje órákban",
                },
                contactsDealerProtectionPrice = {
                    label = "Díler védelmi ára",
                },
                contactsDealerSaleMax = {
                    label = "Díler eladás maximuma",
                },
                contactsDealerSaleMin = {
                    label = "Díler eladás minimuma",
                },
                contactsDealerSimulation = {
                    label = "Díler szimuláció",
                },
                contactsDealerTickMinutes = {
                    label = "Díler frissítési lépés ideje percben",
                },
                contactsDealerWage = {
                    label = "Díler bére",
                },
                contactsDealerWageDecay = {
                    label = "Díler bérfelhagyás",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Díler bérlójalitás nyeresége",
                },
                contactsDealerWeaknesses = {
                    label = "Díler gyengeségei",
                },
                contactsDefaultContactDemand = {
                    label = "Alapértelmezett vevő kereslet",
                },
                contactsDefaultContactRisk = {
                    label = "Alapértelmezett vevő kockázat",
                },
                contactsDefaultDealerCapacity = {
                    label = "Alapértelmezett díler kapacitás",
                },
                contactsDefaultDealerRisk = {
                    label = "Alapértelmezett díler kockázat",
                },
                contactsDefaultDealerSkill = {
                    label = "Alapértelmezett díler készség",
                },
                contactsDefaultHotspotRadius = {
                    label = "Alapértelmezett forrópont sugár",
                },
                contactsDemandResetMinutes = {
                    label = "Kereslet visszaállítása (perc)",
                },
                contactsEnabled = {
                    label = "Engedélyezve",
                },
                contactsExactLocationTrust = {
                    label = "Pontos helyszín bizalma",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Frakció felfedezés hírneve",
                },
                contactsFactionHintTrust = {
                    label = "Frakció tipp bizalma",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Sikertelen kézbesítés hűtési ideje (perc)",
                },
                contactsFakeDealEncounter = {
                    label = "Csaló üzlet találkozó",
                },
                contactsFallbackPreferredDrug = {
                    label = "Alapértelmezett kedvezett drog",
                },
                contactsFallbackProductLabel = {
                    label = "Alapértelmezett termékjelzés",
                },
                contactsGuideBookItem = {
                    label = "Útmutató könyv tárgy",
                },
                contactsGuideBookTrust = {
                    label = "Útmutató könyv bizalma",
                },
                contactsHireDealerPrice = {
                    label = "Díler bérlési ára",
                },
                contactsHistoryLimit = {
                    label = "Előzmények korlátja",
                },
                contactsHotspotIntelMinutes = {
                    label = "Forrópont információk ideje (perc)",
                },
                contactsHotspotRotationMinutes = {
                    label = "Forrópont rotációs ideje (perc)",
                },
                contactsListingDurationMinutes = {
                    label = "Listázás időtartama (perc)",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximális birtokolt díler",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimális vevő kézbesítési távolság",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimális kapcsolati rotáció ideje (perc)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimális kereslet visszaállítás ideje (perc)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimális nyomás szorzó",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimális forrópont információk ideje (perc)",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimális forrópont sugár",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimális forrópont rotációs ideje (perc)",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimális listázási időtartam (perc)",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimális jutalom szorzó",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimális rablás szorzó",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimális helyszíni ár szorzó",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Egyéb drog ár szorzó",
                },
                contactsPaymentAccount = {
                    label = "Fizetési fiók",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Kézbesítés utáni kereslet visszaállítása (másodperc)",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Preferált drog ár szorzó",
                },
                contactsRegionLocationTrust = {
                    label = "Régió helyszín bizalma",
                },
                contactsRequestAmounts = {
                    label = "Kérési mennyiségek",
                },
                contactsRotationMinutes = {
                    label = "Rotációs idő (perc)",
                },
                contactsSpotPools = {
                    label = "Helyszíni poolok",
                },
                contactsStreetHotspots = {
                    label = "Utcai forrópontok",
                },
                contactsTrustLevels = {
                    label = "Bizalmi szintek",
                },
                businessActionCooldownSeconds = {
                    label = "Akció hűtési ideje (másodperc)",
                },
                businessBalance = {
                    label = "Egyenleg",
                },
                businessContracts = {
                    label = "Szerződések",
                },
                businessDefaultBusinessName = {
                    label = "Alapértelmezett üzlet neve",
                },
                businessDefaultRankId = {
                    label = "Alapértelmezett rang ID",
                },
                businessDefaultStaffStyle = {
                    label = "Alapértelmezett személyzet stílus",
                },
                businessDefaultTransport = {
                    label = "Alapértelmezett szállítás",
                },
                businessEnabled = {
                    label = "Engedélyezve",
                },
                businessHubs = {
                    label = "Központok",
                },
                businessLimits = {
                    label = "Korlátok",
                },
                businessPayments = {
                    label = "Kifizetések",
                },
                businessPayoutAccount = {
                    label = "Kifizetési számla",
                },
                businessRanks = {
                    label = "Rangok",
                },
                businessReportDays = {
                    label = "Jelentési napok",
                },
                businessRouteEndpointTypes = {
                    label = "Útvonal végpont típusok",
                },
                businessRuntime = {
                    label = "Futtatás ideje",
                },
                businessSocietyPermission = {
                    label = "Szervezet engedély",
                },
                businessStaff = {
                    label = "Személyzet",
                },
                businessTickMinutes = {
                    label = "Ciklus időtartam (perc)",
                },
                businessTransports = {
                    label = "Szállítások",
                },
            },
            territorySettings = {
                section = "Területek",
                zonesGroup = "Területi zónák",
                sourceLabel = "Zóna forrás",
                sourceDescription = "Használd a védett kerületi sablonokat vagy definiálj saját területi poligonokat.",
                sourcePreset = "Előbeállított kerületek",
                sourceCustom = "Egyedi területek",
                editLabel = "Terület szerkesztő",
                editDescription = "Szerkeszd a kiválasztott zónaforrás által használt kerületeket.",
                editButton = "Kerület szerkesztése",
                presetSection = "Előbeállított kerületek",
                presetEntry = "Előbeállított kerület",
                customSection = "Egyedi területek",
                customEntry = "Egyedi terület",
                typeLabel = "Kerület típusa",
                streetType = "Utca",
                supplyType = "Ellátás",
                enabledLabel = "Megjelenítés a térképen",
                enabledDescription = "Letiltott kerületek eltávolításra kerülnek a térképről, és nem foglalhatók le.",
                zoneLabel = "Kerület határa",
                zoneDescription = "Adj hozzá legalább három pontot sorrendben a kerület határa körül.",
                ownershipGroup = "Tulajdonlás",
                decayGroup = "Fokozódás",
                presenceGroup = "Jelenlét",
                activityGroup = "Tevékenység értékelése",
                ownershipBenefitsGroup = "Tulajdonosi bónuszok",
                ownershipThresholdLabel = "Tulajdonosi küszöb",
                ownershipThresholdDescription = "Az a kontrollszázalék, amelyet egy gengsztercsoportnak felülmúlnia kell, hogy hivatalosan birtokoljon egy területet.",
                activityFloorLabel = "Rögzített tevékenységi alapküszöb",
                activityFloorDescription = "A méretalapú alapküszöbök letiltása esetén szükséges befolyáspontok száma.",
                floorByZoneSizeLabel = "Alapküszöb skálázása a zónaméret alapján",
                floorByZoneSizeDescription = "A terület tevékenységi alapküszöbének kiszámítása a poligon felülete alapján, nem pedig a rögzített küszöb használatával.",
                floorPointsPerSizeUnitLabel = "Pontok négyzetkilométerenként",
                floorPointsPerSizeUnitDescription = "A terület felületének minden négyzetkilométerére szükséges tevékenységi pontok száma.",
                fixedFloorRequirement = "A méretalapú alapküszöbök letiltása a rögzített tevékenységi alapküszöb szerkesztéséhez.",
                sizeFloorRequirement = "A méretalapú alapküszöbök engedélyezése a négyzetkilométerenkénti pontok szerkesztéséhez.",
                dailyDecayLabel = "Napi befolyáscsökkenés",
                dailyDecayDescription = "A befolyás százalékos csökkenése minden 24 órában.",
                presenceIntervalLabel = "Jelenlét intervallum",
                presenceIntervalDescription = "Az automatikus területi jelenléti jutalmak közötti percek száma.",
                presencePointsLabel = "Pontok tagonként",
                presencePointsDescription = "Jelenléti pontok minden jogosult gengsztercsoport-tag számára intervallumonként.",
                drugSalesEnabledLabel = "NPC-értékesítések területi befolyást adnak",
                drugSalesEnabledDescription = "Sikeres utcai értékesítések NPC-knek befolyást adnak az eladó bandájának a jelenlegi utcai területen.",
                drugSalePointsLabel = "Pontok eladott drog egységenként",
                drugSalePointsDescription = "Befolyáspontok jutalma minden olyan drog egységért, amelyet eladottnak jelentettek.",
                drugSalesRequirement = "NPC-kereskedelmi befolyás engedélyezése a pontok beállításához.",
                graffitiPointsLabel = "Graffiti pontok 24 óránként",
                graffitiPointsDescription = "Jelenléti pontok jutalma, ha egy graffiti összesen 24 jelentett órán át létezik.",
                streetSellingPriceBonusLabel = "Utcai eladási ár bónusz",
                streetSellingPriceBonusDescription = "A Street terület hivatalos tulajdonosára vonatkozó eladási árakra vonatkozó százalékos bónusz.",
                supplyProductionSpeedBonusLabel = "Ellátási termelési sebesség bónusz",
                supplyProductionSpeedBonusDescription = "A Supply terület hivatalos tulajdonosára vonatkozó drogtermelési sebességre vonatkozó százalékos bónusz.",
                pruneToleranceLabel = "Befolyás-tisztítási tűrés",
                pruneToleranceDescription = "Ez az alatti értékű hatékony befolyást nullának tekintjük.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Általános",
                streamingGroup = "Renderelés",
                moderationGroup = "Moderáció",
                graffitiEnabledLabel = "Graffiti engedélyezése",
                graffitiEnabledDescription = "Lehetővé teszi a játékosok számára a graffiti felhúzását és megtekintését.",
                graffitiRequireItemLabel = "Sprühdóza szükséges",
                graffitiRequireItemDescription = "A játékosoknak szükségük van egy spray doboz elemre a felhúzáshoz. Ellenkező esetben a /graffiti parancsot használjuk.",
                graffitiChargesPerCanLabel = "Töltetek dobozonként",
                graffitiChargesPerCanDescription = "Hány graffitit lehet felhúzni egyetlen spray dobozzal.",
                graffitiCooldownSecondsLabel = "Spray doboz hűtési idő",
                graffitiCooldownSecondsDescription = "A játékosnak várnia kell ezeket a másodperceket két sprayezés között.",
                graffitiMaxPerPlayerLabel = "Max. graffiti játékosonként",
                graffitiMaxPerPlayerDescription = "Egy játékos által birtokolható maximális aktív graffiti száma. A 0 a korlátlanat jelenti.",
                graffitiMaxDistanceLabel = "Max. spray távolság",
                graffitiMaxDistanceDescription = "A falaktól mért távolság, amelynél még rá lehet festeni, méterben.",
                graffitiSprayDurationLabel = "Festés időtartama",
                graffitiSprayDurationDescription = "A festés animációja tartóssága, milliszekundumban.",
                graffitiExpiryDaysLabel = "Lejárat ideje",
                graffitiExpiryDaysDescription = "A napok száma, amíg a graffitik automatikusan eltűnnek. A 0 azt jelenti, hogy soha.",
                graffitiTerritoryHoursLabel = "Territórium-órák sprayezésenként",
                graffitiTerritoryHoursDescription = "A friss graffitik által a bűnözőcsoportjuknak biztosított territórium-órák száma.",
                graffitiStreamRadiusLabel = "Sugárzás sugara",
                graffitiStreamRadiusDescription = "Az a mért távolság, amelynél a graffitik láthatóvá válnak a játékosok számára.",
                graffitiPoolSizeLabel = "Decal-tároló mérete",
                graffitiPoolSizeDescription = "Hány graffitik kerül egyszerre renderelésre. A nagyobb értékek több teljesítményt igényelnek.",
                graffitiReportsEnabledLabel = "Jelentések engedélyezése",
                graffitiReportsEnabledDescription = "Lehetővé teszi a játékosok számára, hogy sértő graffitiket jelezzenek.",
                graffitiAutoHideThresholdLabel = "Automatikus elrejtés küszöbértéke",
                graffitiAutoHideThresholdDescription = "A graffitik automatikus elrejtéséhez szükséges jelentések száma. A 0 kikapcsolja ezt.",
            },
            darknetSettings = {
                section = "Darknet piac",
                availabilityGroup = "Elérhetőség",
                economyGroup = "Kriptovaluta",
                listingsGroup = "Ajánlatok és lejárat",
                chatGroup = "Privát csevegés",
                identityGroup = "Álnévek és hírnév",
                deliveryGroup = "Átvétel és titkos pontok",
                policeGroup = "Rendőrségi hozzáférés",
                npcGroup = "NPC-kereskedők",
                enabledLabel = "Fekete piac engedélyezése",
                enabledDescription = "Megtehetővé teszi a fekete piaci tablet alkalmazást és annak futtatási környezetét.",
                tabletOrderLabel = "Tablet alkalmazás sorrendje",
                tabletOrderDescription = "Vezérli a Darknet Piac pozícióját a tablet alkalmazásban.",
                currencyCodeLabel = "Pénznem-kód",
                currencyCodeDescription = "Rövid jelölő a belső kriptovaluta vezetéséhez.",
                starterBalanceLabel = "Új pénztárcák kezdőegyenlege",
                starterBalanceDescription = "Kriptovaluta, amelyet csak akkor kap a játékos, amikor először nyitja meg a piacot.",
                exchangeEnabledLabel = "Coin csere engedélyezése",
                exchangeEnabledDescription = "Hitelesített BlackBay felhasználóknak teszi lehetővé a coinok vásárlását és eladását a fiókoldalon.",
                exchangeAccountLabel = "Csere fizetési fiók",
                exchangeAccountDescription = "A coin vásárlásokhoz és eladási kifizetésekhez használt keretrendszeri fiók.",
                exchangeBuyPriceLabel = "Coin vásárlási ára",
                exchangeBuyPriceDescription = "Az egy coinért a fizetési számláról levont összeg.",
                exchangeSellPriceLabel = "Coin eladási ára",
                exchangeSellPriceDescription = "Az egy coinért a fizetési számlára kifizetett összeg.",
                exchangeMinimumLabel = "Minimális coinok csereenként",
                exchangeMinimumDescription = "Egy csere során elfogadott legkisebb egész coin mennyiség.",
                exchangeMaximumLabel = "Maximális coinok csereenként",
                exchangeMaximumDescription = "Egy csere során elfogadott legnagyobb egész coin mennyiség.",
                accountMoney = "Készpénz",
                accountBank = "Bank",
                accountBlackMoney = "Koszos pénz",
                scamChanceLabel = "Globális NPC-csaló esély (%)",
                scamChanceDescription = "A minimális esélye annak, hogy egy NPC-kereskedő elfogadja a fizetést vagy az árut anélkül, hogy a visszatérő árut átadná. A kereskedőre specifikus, magasabb esély továbbra is érvényesül.",
                listingExpiryLabel = "Ajánlat élettartama (óra)",
                listingExpiryDescription = "Az aktív ajánlatok automatikusan lejárnak ennyi óra elteltével.",
                renewalHoursLabel = "Megújítási időtartam (óra)",
                renewalHoursDescription = "Órák, amelyekkel egy tulajdonos megújításkor növelheti az ajánlat érvényességét.",
                maximumListingsLabel = "Maximális aktív ajánlatok",
                maximumListingsDescription = "Maximális ajánlatok száma egy aktív aliasonként.",
                maximumQuantityLabel = "Maximális áru mennyiség",
                maximumQuantityDescription = "Egy ajánlatra vonatkozó felső mennyiségi korlát.",
                maximumPriceLabel = "Maximális egységár",
                maximumPriceDescription = "Egy egységre vonatkozó felső kriptovaluta ár.",
                maximumMessageLengthLabel = "Maximális üzenet hossza",
                maximumMessageLengthDescription = "Egy titkosított chatüzenethez tartozó maximális karakterek száma.",
                aliasCooldownLabel = "Azonosítócsere leállási idő (óra)",
                aliasCooldownDescription = "Az azonosítók minimális kora, mielőtt újra visszavonhatók lennének.",
                verifiedSalesLabel = "Hitelesítéshez szükséges eladások",
                verifiedSalesDescription = "A hitelesítéshez szükséges sikeres eladások száma.",
                verifiedRatingLabel = "Hitelesítéshez szükséges értékelés",
                verifiedRatingDescription = "A hitelesített eladók számára szükséges minimális átlagos értékelés.",
                scammerReportsLabel = "Jelentések csaló figyelmeztetéshez",
                scammerReportsDescription = "A ismert csaló jelvényhez szükséges egyedi kereskedési jelentések száma.",
                meetingDistanceLabel = "Átvételi távolság",
                meetingDistanceDescription = "A két játékos vagy a beállított NPC-pont közötti maximális távolság.",
                dropModelLabel = "Titkosítási pont doboz-modell",
                dropModelDescription = "Helyileg generált GTA tárgy-modell a rendelkezésre álló titkosítási pontokhoz.",
                dropStreamLabel = "Titkosítási pont betöltési távolság",
                dropStreamDescription = "A dobozok és NPC-összejöveteli kapcsolatok betöltéséhez szükséges távolság.",
                dropInteractionLabel = "Titkosítási pont-interakció távolsága",
                dropInteractionDescription = "A doboz kereséséhez és átvételéhez szükséges távolság.",
                dropLifetimeLabel = "Titkosítási pont élettartama (óra)",
                dropLifetimeDescription = "Az átvétlen maradt doboz lejárati ideje.",
                dropPollLabel = "Világfrissítési intervallum (ms)",
                dropPollDescription = "A környező dobozok és NPC-összejövetelek frissítésére használt intervallum.",
                policeGroupsLabel = "Jogosult rendőri munkacsoportok",
                policeGroupsDescription = "A bűnözőcsoportok kulcsai, amelyek közzétehetik a csábító ajánlatokat és megtekinthetik a nyomozásokat.",
                policeGroupEntry = "Rendőrcsoport",
                groupKeyLabel = "Csoportkulcs",
                npcTradersLabel = "NPC vevők és eladók",
                npcTradersDescription = "Konfigurálja a tartós NPC-ajánlatokat, az átadási módot, a hírnév szintjét és a csalási valószínűséget.",
                npcTraderEntry = "NPC kereskedő",
                npcIdLabel = "ID",
                npcAliasLabel = "Álnév",
                npcSideLabel = "Piac oldala",
                sideSell = "Eladás játékosoknak",
                sideBuy = "Vásárlás játékosoktól",
                npcTitleLabel = "Ajánlat címe",
                npcDescriptionLabel = "Leírás",
                npcItemNameLabel = "Tárolóelem neve",
                npcItemLabelLabel = "Áru címkéje",
                npcQuantityLabel = "Mennyiség",
                npcPriceLabel = "Darabonkénti ár",
                npcDeliveryLabel = "Átvételi mód",
                deliveryBoth = "Találkozó és Dead Drop",
                deliveryMeeting = "Csak személyes találkozó",
                deliveryDrop = "Csak Dead Drop",
                npcScamChanceLabel = "Kereskedő átverési esélye (%)",
                npcPedModelLabel = "NPC ped modell",
                npcRatingLabel = "Megjelenített értékelés",
                npcRatingCountLabel = "Megjelenített értékelések száma",
                npcTradesLabel = "Megjelenített sikeres üzletek",
                npcVerifiedLabel = "Ellenőrzött kereskedő",
                npcScammerLabel = "Ismert csaló",
                npcEnabledLabel = "Engedélyezve",
            },
            interrogationSettings = {
                section = "Kikérdezés",
                generalGroup = "Általános",
                consentGroup = "Játékosvédelem",
                objectGroup = "Objektumok",
                grabGroup = "Megszállás",
                sessionGroup = "Adminisztrátor ACE",
                dispatchGroup = "Rendőrségi figyelmeztetések",
                loggingGroup = "Naplózás",
                securityGroup = "Biztonság",
                presentationGroup = "Bemutatás",
                enabledLabel = "Interrogációs rendszer engedélyezése",
                enabledDescription = "Lehetővé teszi a játékosok számára, hogy másokat foglyul ejtsenek és eszközöket használjanak rajtuk.",
                consentRequiredLabel = "Belépés szükséges",
                consentRequiredDescription = "Csak azok a játékosok válhatnak áldozattá, akik beleegyeztek. Nincs külön funkció a beleegyezéshez; használja a lentebb lévő beállítást.",
                consentDefaultLabel = "Alapértelmezett beleegyezés",
                consentDefaultDescription = "Az új karakterek alapértelmezetten beleegyeznek, nem tagadnak.",
                globalIntensityLabel = "Hatás intenzitása",
                globalIntensityDescription = "Skálázza a képernyőhatásokat, a részecskéket és a hangot. A 0 teljesen kikapcsolja őket.",
                maxPerPlayerLabel = "Objektumok játékosonként",
                maxPerPlayerDescription = "Hány szék és kocsit helyezhet el egy játékos. A 0 azt jelenti, hogy korlátlan.",
                maxGlobalLabel = "Objektumok szerver szinten",
                maxGlobalDescription = "A egyszerre engedélyezett összes elhelyezett objektum száma. A 0 azt jelenti, hogy korlátlan.",
                placementDistanceLabel = "Elhelyezés távolsága",
                placementDistanceDescription = "Az a mért távolság, amelynél egy objektum elhelyezhető a játékosától.",
                interactDistanceLabel = "Interakciótávolság",
                interactDistanceDescription = "Az a mért távolság, amelynél egy játékosnak állnia kell a székhez vagy kocsinhoz.",
                inactivityMinutesLabel = "Automatikus eltávolítás után",
                inactivityMinutesDescription = "A nem használt idő perc száma, amíg egy elhelyezett objektum eltűnik. A 0 azt jelenti, hogy örökké megőrzi.",
                persistObjectsLabel = "Objektumok megtartása újraindítás után",
                persistObjectsDescription = "Az elhelyezett objektumok visszaállnak a adatbázisból, amikor a szerver újra indul.",
                grabEnabledLabel = "Megszállás engedélyezése",
                grabEnabledDescription = "Lehetővé teszi, hogy a játékosok legyőzzenek és ellopjanak egy másik játékost.",
                grabItemLabel = "Kötelező tárgy",
                grabItemDescription = "A támadónak ehhez a tárgyhöz kell a megragadáshoz. Hagyd üresen, ha nincs szükség tárgyra.",
                grabAngleLabel = "Megközelítési szög",
                grabAngleDescription = "Annak a szöge, hogy a támadó közvetlen hátuljától hány fokkal oldalra állhat.",
                grabHealthBelowLabel = "Életküszöb",
                grabHealthBelowDescription = "Ez az életküszöb alatti áldozatot meg lehet ragadni anélkül, hogy megkötöznék. A 0 letiltja ezt.",
                grabCooldownLabel = "Hibás kísérlet utáni várakozási idő",
                grabCooldownDescription = "A sikertelen ragadás után eltelt másodpercek száma a következő kísérlet előtt.",
                grabVehiclesLabel = "Engedélyezett járművek",
                grabVehiclesDescription = "A megragadott áldozat betehető járművek típusai.",
                carryEnabledLabel = "Hordozás engedélyezése",
                carryEnabledDescription = "A támadó hordozhatja az áldozatot a vállán.",
                restrictVisionLabel = "Az áldozat látómezőjének korlátozása",
                restrictVisionDescription = "Az áldozat képernyőjének elhomályosítása a szállítás közben.",
                escapeEnabledLabel = "Kibújási kísérletek engedélyezése",
                escapeEnabledDescription = "Lehetővé teszi, hogy a szállított áldozat megpróbáljon kiszabadulni.",
                escapeSecondsLabel = "Kibújási időtartam",
                escapeSecondsDescription = "Az áldozatnak tartania kell a gombot a szabadulásához szükséges másodpercek száma.",
                maxDurationLabel = "Maximum időtartam",
                maxDurationDescription = "Az órák száma, amely után a kihallgatás automatikusan lezárul.",
                warnMinutesLabel = "Figyelmeztetés a lezárás előtt",
                warnMinutesDescription = "Az órák száma a limit előtt, amikor mindkét fél figyelmeztetést kap.",
                idleMinutesLabel = "Szabadonengedés inaktivitás esetén",
                idleMinutesDescription = "Az órák száma, amely után az áldozat szabadul, ha nincs interakció.",
                selfReleaseMinutesLabel = "Önfelszabadulás után",
                selfReleaseMinutesDescription = "Az órák száma, amely után az áldozat önmagát szabadíthatja meg, ha nincs támadó interakció.",
                graceSecondsLabel = "Kezdeményezés után a kapcsolódás megszakításakor",
                graceSecondsDescription = "Az áldozat kötöttsége másodpercekben, amikor a támadó elhagyja a szervert.",
                rescueEnabledLabel = "Mentés engedélyezése",
                rescueEnabledDescription = "Az érintetlen játékosok szabadíthatják fel a megkötözött áldozatot.",
                rescueSecondsLabel = "Mentés időtartama",
                rescueSecondsDescription = "A mentőnek szükséges másodpercek száma az áldozat felszabadításához.",
                rescueItemLabel = "Mentés tárgya",
                rescueItemDescription = "A mentőnek szükséges tárgy. Hagyd üresen, ha nincs szükség tárgyra.",
                allowInventoryLabel = "Az áldozat megtartja az inventárt",
                allowInventoryDescription = "A megkötözött áldozat továbbra is megnyithatja az inventárját.",
                dispatchEnabledLabel = "Rendőrségi figyelmeztetések engedélyezése",
                dispatchEnabledDescription = "Az elrablásokról és kihallgatásokról értesíti a mentőszolgálatot.",
                dispatchAdapterLabel = "Figyelmeztető rendszer",
                dispatchAdapterDescription = "Melyik rendőrségi rendszer kapja az értesítéseket.",
                dispatchJobsLabel = "Értesített munkák",
                dispatchJobsDescription = "Az értesítést kapó munkák.",
                dispatchGrabChanceLabel = "Ragadás esélye",
                dispatchGrabChanceDescription = "Az esély százaléka, hogy a ragadást bejelentik.",
                dispatchFixateChanceLabel = "Kötés esélye",
                dispatchFixateChanceDescription = "Az esély százaléka, hogy valakit székhez kötnek.",
                dispatchToolChanceLabel = "Eszköz használata esélye",
                dispatchToolChanceDescription = "Az eszköz használatának bejelentésének esélye százalékban.",
                dispatchWitnessLabel = "Kötelező tanú",
                dispatchWitnessDescription = "Csak akkor jelentse be, ha egy másik játékos elég közel van, hogy észrevegye.",
                dispatchWitnessRadiusLabel = "Tanú sugara",
                dispatchWitnessRadiusDescription = "Annak a tanúnak a távolsága méterben, aminek lennie kell.",
                dispatchCooldownLabel = "Riasztás hűtési ideje",
                dispatchCooldownDescription = "Másodperc két azonos ülésszakbeli riasztás között.",
                dispatchInaccuracyLabel = "Helyzetbeli pontatlanság",
                dispatchInaccuracyDescription = "Annak a bejelentett helynek a méterben mért véletlenszerű eltolása. A 0 a pontos pontot jelenti be.",
                loggingEnabledLabel = "Naplózás engedélyezése",
                loggingEnabledDescription = "Elhelyezések, fogások, eszközhasználat, felengedések és adminisztratív beavatkozások rögzítése.",
                logDatabaseLabel = "Adatbázisba írás",
                logDatabaseDescription = "Minden bejegyzés további írásának a kihallgatási napló táblájába.",
                logRetentionLabel = "Naplóbejegyzések megőrzése",
                logRetentionDescription = "Napok, amíg az adatbázisbeli naplóbejegyzéseket nem törlik. A 0 örökre megőrzi őket.",
                pingToleranceLabel = "Távolsági tűréshatár",
                pingToleranceDescription = "Méter, amely minden szerveroldali távolsági ellenőrzéshez hozzáadódik a késleltetés elnyelésére.",
                violationThresholdLabel = "Sértés küszöbértéke",
                violationThresholdDescription = "Biztonsági sértések a reakció kiváltásáig tartó ablakon belül. A 0 kikapcsolja.",
                violationActionLabel = "Reakció a sértésekre",
                violationActionDescription = "Mi történik, amikor egy játékos átlépi a sértés küszöbértékét.",
                violationActionNone = "Semmit ne tegyen",
                violationActionLog = "Csak naplozzon",
                violationActionKick = "Kijelentés",
                violationActionCheating = "Csaltként jelentés",
                particlesLabel = "Részecskeeffektek",
                particlesDescription = "Vér, szikra és lángok megjelenítése az eszközhasználat során.",
                soundLabel = "Hanghatások",
                soundDescription = "Eszközhangok lejátszása mindenkinek, aki közel van.",
                cameraWorkLabel = "Kameramunka",
                cameraWorkDescription = "A kamera mozgatása valakinek a megkötésekor és az eszközhasználat során.",
                screenEffectsLabel = "Képernyőeffektek",
                screenEffectsDescription = "Rázás, felvillanás, elmosódás és szűrők az áldozat képernyőjén.",
                objectsSection = "Kérdezői tárgyak",
                objectsEntry = "Objektum",
                objectsEditLabel = "Kérdezői tárgyak",
                objectsEditDescription = "Állandó székek és eszközágyak elhelyezése a térképen.",
                objectsEditButton = "Objektumok szerkesztése",
                objectsKindLabel = "Objektum típusa",
                objectsKindChair = "Szék",
                objectsKindCart = "Eszközszekér",
                objectsModelLabel = "Prop modell",
                objectsPositionLabel = "Pozíció",
                blockedZonesSection = "Letiltott zónák",
                blockedZonesEntry = "Zóna",
                blockedZonesEditLabel = "Letiltott zónák",
                blockedZonesEditDescription = "Olyan területek, ahol nem helyezhető el kihallgatási objektum.",
                blockedZonesEditButton = "Zónák szerkesztése",
                blockedZonesZoneLabel = "Zónaképlet",
                blockedZonesZoneDescription = "A sarkok húzásával alakítsa ki azt a területet, ahol az elhelyezés nem megengedett.",
                toolsSection = "Eszközök",
                toolsEntry = "Eszköz",
                toolsEditLabel = "Eszközök",
                toolsEditDescription = "Azok az eszközök hozzáadása vagy beállítása, amelyeket az áldozaton használhatunk.",
                toolsEditButton = "Eszközök szerkesztése",
                toolsItemLabel = "Kötelező tárgy",
                toolsConsumeLabel = "Tárgy elfogyasztása",
                toolsDamageLabel = "Károsodás használatonként",
                toolsHealthFloorLabel = "Életminimum",
                toolsCooldownLabel = "Hűtési idő másodpercben",
                toolsProgressLabel = "Folyamat használatonként",
                sessionsSection = "Folyamatban lévő kihallgatások",
                sessionsEntry = "Ülés",
                sessionsEditLabel = "Folyamatban lévő kihallgatások",
                sessionsEditDescription = "Lásd, ki van jelenleg kihallgatás alatt, és szükség esetén véget vet neki.",
                sessionsEditButton = "Sessziók megjelenítése",
                sessionsStateLabel = "Állapot",
                sessionsProgressLabel = "Folyamat",
                orphansSection = "Elhagyatott tárgyak",
                orphansEntry = "Objektum",
                orphansEditLabel = "Elhagyatott tárgyak",
                orphansEditDescription = "Objektumok eltávolítása, amelyek tulajdonosát már régóta nem látták.",
                orphansEditButton = "Takarítás",
                sessionStates = {
                    binding = "Kötözött",
                    active = "Aktív",
                    ending = "Befejeződő",
                },
            },
        },
    },
}
