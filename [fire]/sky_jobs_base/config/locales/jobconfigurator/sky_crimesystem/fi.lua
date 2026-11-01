JobConfigLocales["sky_crimesystem:fi"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Suora komento",
            roleDefaults = {
                title = "Roolit",
                description = "Valitse kunkin oletusoikeuden vähimmäisarvo. Pomovalikkoon tallennetut arvojen oikeudet ovat ensisijaisia.",
                bossHint = "Pomon ja apulaispomon arvoilla on aina täydet oikeudet.",
                empty = "Tälle työlle ei ole vielä saatavilla arvoja.",
                gradesTitle = "Työn arvoasteet",
                noDefault = "Ei oletusoikeutta",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Yhteiset oletukset koskevat niitä käyttäviä kenttiä. Arvon muuttaminen asetussivulla vaihtaa kentän omaan arvoon. Nykyiset merkinnät säilyttävät arvonsa.",
            weaponStreetDescription = "Huumeiden katukontaktin yhteydessä palvelin voi joskus ostaa kelvollisen aseen. Valinta, hinta ja maksu päätetään palvelimella.",
            weaponGroups = {
                general = "Yleiset oletukset",
                access = "Pääsyn oletukset",
                collection = "Keräyksen oletukset",
                production = "Tuotannon oletukset",
                market = "Markkinoiden oletukset",
                delivery = "Tilausten oletukset",
                street = "Aseiden katumyynti",
            },
            weaponOptions = {
                scrap_search = "Tutki romukasaa",
                player = "Pelaajakohtainen",
                global = "Globaali",
                money = "Käteinen",
                bank = "Pankkitili",
                black_money = "Musta raha",
                timing = "Pysäytä osoitin optimaalisella alueella.",
                precision = "Tee jokainen leikkaus tarkkuusikkunan sisällä.",
                pressure = "Pysäytä puristin optimaalisessa paineessa.",
            },

            reputation = {
                remove = "Poista",
                title = "Maine",
                action = "Toiminto",
                points = "Pisteet suorituksesta",
                enabled = "Käytössä",
                search = "Hae toimintoja",
                added = "Jo lisätty",
                noResults = "Vastaavia toimintoja ei löytynyt.",
                empty = "Ei vielä toimintoja. Lisää toiminto pluspainikkeella.",
                name = "Säännön nimi",
                target = "Kohde (valinnainen)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Fraktiot",
                    subtitle = "Konfiguroi rikollisuustehtävät ja niiden yhteiset sijainnit.",
                    title = "Rikosjärjestelmä",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Päämaja",
                    entryPluralLabel = "Päämajat",
                    label = "Päämajan vyöhyke",
                },
                presetTerritories = {
                    label = "Esiasetellut piirit",
                    entryLabel = "Esiaseteltu piiri",
                    entryPluralLabel = "Esiasetellut piirit",
                },
                customTerritories = {
                    label = "Omat territoriot",
                    entryLabel = "Oma territorio",
                    entryPluralLabel = "Omat territoriot",
                },
                objectsSection = {
                    label = "Kuulusteluobjektit",
                    entryLabel = "Objekti",
                    entryPluralLabel = "Kuulusteluobjektit",
                },
                blockedZonesSection = {
                    label = "Estetyt vyöhykkeet",
                    entryLabel = "Vyöhyke",
                    entryPluralLabel = "Estetyt vyöhykkeet",
                },
                toolsSection = {
                    label = "Työkalut",
                    entryLabel = "Työkalu",
                    entryPluralLabel = "Työkalut",
                },
                sessionsSection = {
                    label = "Käynnissä olevat kuulustelut",
                    entryLabel = "Kuulustelu",
                    entryPluralLabel = "Käynnissä olevat kuulustelut",
                },
                orphansSection = {
                    label = "Orvoksi jääneet objektit",
                    entryLabel = "Objekti",
                    entryPluralLabel = "Orvoksi jääneet objektit",
                },
            },
            darknetActions = {
                currentLocation = "Käytä nykyistä sijaintia",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Korkeammat arvot hidastavat kasvua huonon hoidon aikana, mutta säilyttävät vahvat bonukset hyvästä hoidosta.",
                    label = "Hoitovastekuvaaja",
                },
                drugGrowthMaxMultiplier = {
                    description = "Maksimikasvun kertoimella saavutetaan erinomaiset olosuhteet.",
                    label = "Täydellisen hoidon kerroin",
                },
                drugGrowthMinMultiplier = {
                    description = "Kasvun kerronimäärä käytetään, kun kasvin olosuhteet ovat kriittisen huonot.",
                    label = "Kriittisen hoidon kerroin",
                },
                drugGrowthQualityBonusMax = {
                    description = "Kasvin laadun antama enimmäislisäkasvubonus.",
                    label = "Laadun tuoma kasvubonus",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Valitse roolien oikeuksille kelvolliset vähimmäisarvot.",
                base_raid_locked = "Tukikohtaa hyödynnetään. Sen varastopaikat ja konfiguraatiot on lukittu.",
                base_storage_outside_zone = "Kaikkien varastojen, säilytystilojen ja ryöstövarastojen on oltava tukikohdan vyöhykkeen sisällä.",
                base_zone_invalid_polygon = "Aseta vähintään kolme erillistä pistettä ilman, että reunat risteävät, ja tarkista sitten korkeus (3–200 m) ja reitityskategoria.",
                base_zone_point_limit = "Päätukikohdan vyöhyke tukee enintään 64 rajapistettä.",
                base_zone_required = "Määritä ensin voimassa oleva päätukikohdan vyöhyke tälle rikostöille.",
                crime_interrogation_invalid_model = "Anna kelvollinen objektimalli.",
                crime_interrogation_invalid_coords = "Sijoita objekti kelvolliseen sijaintiin.",
                crime_interrogation_invalid_zone_points = "Aseta vähintään kolme kelvollista rajapistettä.",
                crime_interrogation_duplicate_id = "Tällä tunnuksella on jo objekti.",
                crime_interrogation_tool_invalid = "Tarkista työkalun määritys.",
                crime_interrogation_tool_id_invalid = "Anna kelvollinen työkalutunnus.",
                crime_interrogation_tool_label_missing = "Anna työkalulle nimi.",
                crime_interrogation_effect_missing = "Määritä työkalun vaikutus.",
                crime_interrogation_effect_type_unknown = "Valitse tuettu vaikutustyyppi.",
                crime_interrogation_effect_status_missing = "Määritä tila, johon työkalu vaikuttaa.",
                crime_interrogation_minigame_missing = "Määritä työkalun minipeli.",
                crime_interrogation_minigame_type_unknown = "Valitse tuettu minipelityyppi.",
                crime_interrogation_keys_missing = "Määritä työkalun ohjaimet.",
                crime_interrogation_keys_invalid = "Tarkista työkalun määritetyt ohjaimet.",
                crime_interrogation_keys_duplicate = "Määritä jokainen työkalun toiminto ja ohjain vain kerran.",
                crime_interrogation_anim_invalid = "Tarkista työkalun animaatiokirjasto ja leike.",
                crime_interrogation_anim_missing = "Määritä animaatio työkalun käyttäjälle.",
                crime_interrogation_occupied = "Joku on jo sidottu tähän esineeseen.",
                crime_interrogation_not_found = "Sitä ei ole enää olemassa.",
            },
            extensions = {
                baseZone = {
                    description = "Aseta 3–64 rajapistettä järjestyksessä. Alin asetettu piste määrittää pohjan; korkeus ulottuu siitä ylöspäin. Pisteet tallennetaan luonnoksena; käytä Tallenna-painiketta soveltaaksesi vyöhykkeen. Vain vyöhykkeen sisällä olevat varastot, säilikköt ja heist-varastot ovat saavutettavissa ratsioiden aikana. Pisteet vyöhykkeen ulkopuolella eivät estä tallentamista tai ratsian aloittamista. Nykyiset rajat pysyvät aktiivisina, kunnes tallennat.",
                    fields = {
                        bucket = "Routing-bucket",
                        configured = "Konfiguroitu",
                        height = "Korkeus (metriä)",
                        radius = "Säde (metriä)",
                        x = "Keskiö X",
                        y = "Keskiö Y",
                        z = "Keskiö Z",
                    },
                    label = "Päämajan vyöhyke",
                },
                invalidSelection = "Virheellinen valinta: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Tämän työpaikan pääpiste. Jos kartan blip on käytössä kohdassa Job → Blips, se näkyy tässä.",
            },
            locationTypes = {
                crimeStationPosition = "Sijainti / kartan blip",
                heistCrafting = "Ryöstön työpaja",
                heistStorage = "Ryöstövarasto",
            },
            membershipMigration = {
                cancel = "Peruuta",
                confirm = "Migroi ja tallenna",
                message = "Olemassa olevat organisaation jäsenyydet migroidaan valittuun malliin. Normaalit työsuhteet säilyvät erillisinä itsenäisessä tilassa.",
                title = "Muuta jäsenyysmallia?",
            },
            moneywashActions = {
                currentLocation = "Käytä nykyistä sijaintia",
                invalidLocations = "Tarkista ID:t, nimet, sisätilavalinnat ja koordinaatit. Jokainen sijainti tarvitsee yksilöllisen ID:n.",
                position = "Paikka",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Rakennuspisteet", description = "Sijoita sopivat laitteet pisteille. Koordinaatit ovat suhteessa valittuun sisätilaan." },
                mwBuildNodes = "Rakennuspisteet",
                moneywashPublicEquipment = { label = "Julkiset laitteet", description = "Liitä pesukoneet, generaattorit ja tuulettimet julkisiin kohteisiin ja sopiviin pisteisiin." },
                mwPublicEquipment = "Julkiset laitteet",
                moneywashMaterials = { label = "Materiaalit", description = "Käytä tarkkoja inventaarionimiä. Paino grammoina; asenna puuttuvat esineet inventaarioon." },
                mwMaterials = "Materiaalit",
                moneywashMaterialRecipes = { label = "Materiaalireseptit", description = "Syötteet, tuotokset ja aika koskevat yhtä yksikköä. Jalostajat käyttävät reseptejä." },
                mwMaterialRecipes = "Materiaalireseptit",
                moneywashProductionRecipes = { label = "Painoreseptit", description = "Paperi, väri ja ajat koskevat yhtä yksikköä. Käteinen maksetaan kuivauksen ja laaduntarkastuksen jälkeen." },
                mwProductionRecipes = "Painoreseptit",
                moneywashCollectors = { label = "Keräyspisteet", description = "Määritä jokaisen keräyspisteen tuotto, työkalut, odotusaika ja sijainti." },
                mwCollectors = "Keräyspisteet",
                moneywashProcessors = { label = "Jalostuspisteet", description = "Valitse materiaaliresepti ja sijainti jokaiselle jalostuspisteelle." },
                mwProcessors = "Jalostuspisteet",

                control = "Ohjauspaneeli",
                editor = {
                    addBusiness = "Lisää yritys",
                    addInterior = "Lisää sisätila",
                    advanced = "Tekniset tiedot",
                    asset_ipl = "IPL: Syötä tarkka IPL-nimi ja sisätilan sijainti.",
                    asset_mlo = "MLO: Käytä asennetun sisätilan sijaintia. Pääsy tapahtuu tällä hetkellä yrityksen sisäänkäynnin kautta.",
                    asset_shell = "Shell: Sen malliresurssin on oltava asennettuna ja käynnissä palvelimella.",
                    businessHelp = "Nimeä yritys, valitse sen sisätila ja aseta ostohinta.",
                    businessListHelp = "Hallinnoi yrityksesi sisäänkäyntejä ja ostohintoja.",
                    businesses = "Yritykset",
                    capture = "Aseta pelissä",
                    captureOrigin = "Aseta sisätilan sijainti",
                    chooseInterior = "Valit sisätila",
                    coordinates = "Muokkaa koordinaatteja",
                    editSections = "Pystytys",
                    emptyBusinessHelp = "Linkitä kartan sisäänkäynti sisätilaan. Organisaatiosi voi tämän jälkeen ostaa tyhjän yrityksen.",
                    emptyBusinesses = "Ensimmäinen yrityksesi",
                    emptyInteriorHelp = "Yhdistä IPL, shell tai asennettu MLO, ja aseta sen jälkeen yrityksen käyttämät pisteet.",
                    emptyInteriors = "Ensimmäinen sisätilasi",
                    entranceHelp = "Aseta sisäänkäynti siihen, mistä pelaajat ostavat ja astuvat yritykseen.",
                    freecamHelp = "Freecam: WASD liikkuminen, Q/E ylös/alas, Shift nopeampi, Ctrl hitaampi. Hiiren oikea: katse. Raahaa gizmoa, R pyöritys/siirto, Enter aseta, Backspace peruuta.",
                    general = "Yleinen",
                    heading = "Suunta",
                    interiorHelp = "Valitse sisätilan tyyppi ja sen omaisuuserä.",
                    interiorListHelp = "Valmistele tyhjät tilat. Pelaajat sijoittavat omat koneensa ja laitteensa itse.",
                    interiors = "Sisätilat",
                    listEmpty = "Ei merkintöjä.",
                    locationTypes = "Sijaintien hallinta",
                    newBusiness = "Uusi yritys",
                    newInterior = "Uusi sisätila",
                    noResults = "Ei vastaavia merkintöjä.",
                    notSet = "Ei asetettu",
                    offsetHelp = "Syötetyt arvot ovat etäisyyksiä origosta. Maailman sijainti näytetään ylhäällä.",
                    origin = "Alkuperä",
                    originHelp = "Sisätilan sijainti. Kaikki muut pisteet ovat suhteessa siihen.",
                    originRequired = "Aseta sisätilan sijainti ensin kohdassa Yleiset.",
                    outsideRange = "{range} metrin alueen ulkopuolella",
                    point_control = "Siirrä ja käännä seinäpaneeli paikoilleen gizmon avulla. Vahvistettu kohteen korkeus säilytetään tarkasti. Vaihda sen merkki Interactions → Money Wash: control panel -kohdassa.",
                    point_entry = "Pelaajat saapuvat ja poistuvat täältä. Poistuminen palauttaa heidät automaattisesti yrityksen ulkopuolella olevalle sisäänkäynnille.",
                    point_position = "Tämä piste on yrityksen ulkopuolella.",
                    point_storage = "Siirrä ja käännä hylly gizmon avulla, kunnes se lepää lattialla. Jäsenet käyttävät ostettuja laitteita tästä. Vaihda sen merkki Interactions → Money Wash: storage -kohdassa.",
                    points = "Pisteet",
                    pointsHelp = "Valitse piste ja aseta se suoraan pelissä.",
                    rangeNote = "{range}-metrin säde sisätilan alkupisteen ympärillä on voimassa, ilman korkeusrajoitusta.",
                    remove = "Poista",
                    repairRange = "Siirrä nämä pisteet lähemmäs sisätilojen alkupistettä.",
                    saveHint = "Tallenna muutokset ylhäältä Save-painikkeella.",
                    search = "Etsi …",
                    set = "Aseta",
                    teleport = "Teleportti",
                    viewInteriors = "Näytä sisätilat",
                    visit = "Tarkastele",
                    visitHint = "Liikkuminen on vapaata. Paina Backspace palataksesi editoriin.",
                    visitTitle = "Sisätilan vierailu",
                },
                entry = "Sisään- ja uloskäynti",
                fields = {
                    mode = "Pääsytila",
                    ownerKind = "Omistajatyyppi",
                    productionEnabled = "Painolaajennus saatavilla",
                    feePercent = "Maksu (%) / -1 = yleinen",
                    storageCapacity = "Varaston kapasiteetti (esineet)",
                    maximumOrders = "Samanaikaiset tilaukset pelaajaa kohti",
                    gridPower = "Sähköverkon teho / 0 = generaattori",
                    autoService = "Automaattinen julkinen huolto",
                    maximumPendingOutputs = "Maksamattomien maksujen enimmäismäärä",
                    placementRange = "Sijoitussäde (m)",
                    placementHeight = "Sijoituksen korkeusalue (m)",
                    interiorId = "Sisätilan ID",
                    equipmentId = "Laitteen ID",
                    nodeId = "Rakennuspisteen ID",
                    generatorNode = "Generaattoripisteen ID",
                    maxOffset = "Suurin etäisyys pisteestä (m)",
                    maxHeight = "Suurin korkeusero (m)",
                    weight = "Esineen paino (g)",
                    inputItem = "Syötemateriaali",
                    secondItem = "Toinen syötemateriaali",
                    outputItem = "Tuotosmateriaali",
                    requiredTool = "Tarvittava työkalu",
                    baseQuality = "Alkulaatu (%)",
                    minimumQuality = "Vähimmäislaatu (%)",
                    inspectionCards = "Tarkastuskortit",
                    inspectionPenalty = "Laadun menetys virheestä (%)",
                    rejectPercent = "Hylätyt setelit (%)",
                    accessoryModel = "Lisäosan malli",
                    accessoryMaximum = "Näkyvien lisäosien enimmäismäärä",
                    accessoryActiveOnly = "Lisäosat vain käsittelyssä",
                    animDict = "Animaatiosanakirja",
                    animClip = "Animaatiojakso",
                    cooldown = "Odotusaika (sekuntia)",
                    minimum = "Vähimmäistuotto",
                    maximum = "Enimmäistuotto",
                    productionPrice = "Rahan painaminen · Hankintahinta",
                    recipeId = "Resepti ID",
                    inputAmount = "Materiaali / yksikköä kohti",
                    secondAmount = "Materiaali / yksikköä kohti",
                    outputAmount = "Materiaali / yksikköä kohti",
                    paperItem = "Painopaperi",
                    inkItem = "Painoväri",
                    paperAmount = "Painopaperi / yksikköä kohti",
                    inkAmount = "Painoväri / yksikköä kohti",
                    notesPerUnit = "Setelit / yksikköä kohti",
                    valuePerNote = "Käteinen / Setelit",
                    maximumUnits = "Yksiköt (max.)",
                    printSeconds = "Painatus / yksikköä kohti (Sekunnit)",
                    inspectionSeconds = "Tarkastus / yksikköä kohti (Sekunnit)",
                    rinseSeconds = "Pesu / yksikköä kohti (Sekunnit)",
                    drySeconds = "Kuivaus / yksikköä kohti (Sekunnit)",
                    accessoryUnit = "Setelit / yksikköä kohti",
                    accessoryX = "Lisäosan malli · X (m)",
                    accessoryY = "Lisäosan malli · Y (m)",
                    accessoryZ = "Lisäosan malli · Z (m)",
                    accessoryStep = "Lisäosan malli · Z (m)",

                    capacity = "Kapasiteetti per sykli",
                    controlHeading = "Ohjauspaneelin suunta",
                    controlHeight = "Asennuskorkeus pisteen yläpuolella (m)",
                    controlModel = "Seinäpaneelin malli",
                    controlX = "Ohjauspaneeli X",
                    controlY = "Ohjauspaneeli Y",
                    controlZ = "Ohjauspaneeli Z",
                    disableSets = "Piilotetut entiteettiset (eroteltu pilkulla)",
                    enableSets = "Oletusarvoiset entiteettisarjat (eroteltu pilkulla)",
                    entryX = "Sisäänkäynnin siirtymä X",
                    entryY = "Sisäänkäynnin siirtymä Y",
                    entryZ = "Sisäänkäynnin siirtymä Z",
                    heading = "Suunta",
                    id = "Yksilöllinen ID",
                    interior = "Sisätila",
                    ipl = "IPL-nimi",
                    kind = "Tyyppi",
                    label = "Nimi",
                    model = "Mallin nimi",
                    power = "Virtayksiköt",
                    price = "Hankintahinta",
                    radius = "Sijoitussäde (m)",
                    repairPrice = "Korjaushinta (0 = ilmainen)",
                    seconds = "Syklin kesto (sekuntia)",
                    storageHeading = "Varastopisteen suunta",
                    storageModel = "Hyllymalli",
                    storageX = "Varastopiste X",
                    storageY = "Varastopiste Y",
                    storageZ = "Varastopiste Z",
                    wear = "Kuluminen per sykli (%)",
                    x = "Alkupiste X",
                    y = "Alkupiste Y",
                    z = "Alkupiste Z",
                },
                interactions = {
                    control = "Money Wash: ohjauspaneeli",
                    storage = "Money Wash: varasto",
                },
                item = "Merkintä",
                moneywashBucketStart = {
                    description = "Varaa tämä alue yksinomaan rahanpesua varten. Muutokset astuvat voimaan seuraavalla saapumisella.",
                    label = "Instanssialueen alku",
                },
                moneywashEquipment = {
                    description = "Pelaajat ostavat ja sijoittavat laitteita. Kapasiteetti, kesto ja kuluminen koskevat pesureita. Virta on generaattorin tarjontaa tai laitteen kysyntää. Muutokset vaikuttavat uusiin ostoihin.",
                    label = "Ostettava varustus",
                },
                moneywashInteriors = {
                    description = "Määritä tyhjät IPL-, shell- tai MLO-sisätilat. Sisäänkäynti, ohjauspaneeli, varasto ja rakennusrajat ovat suhteessa alkupisteeseen. Poistuminen palauttaa pelaajat heidän yrityksensä sisäänkäynnille.",
                    label = "Sisätilat (IPL, shell tai MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Enimmäismäärä ostettuja laitteita ja korjaussarjoja per yritys.",
                    label = "Laiterajoitus",
                },
                moneywashPreviewBucketStart = {
                    description = "Visit käyttää tätä arvoa ja pelaajan ID:tä yksityistä admin-instanssia varten. Varaa se erikseen yrityksistä ja muista resursseista. Muutokset astuvat voimaan seuraavassa esikatselussa.",
                    label = "Esikatseluinstanssin alueen alku",
                },
                moneywashProperties = {
                    description = "Aseta sisäänkäynti, valitse sisätila ja määritä ostohinta. Ostetut toimipisteet säilyttävät tallennetun sisätilansa ja pohjarakenteensa.",
                    label = "Toimipisteen sisäänkäynnit",
                },
                moneywashRepairShops = {
                    description = "Aseta korjaamot, teleporttaa niihin ja aseta huoltopreisi. Ne myyvät korjaussarjoja ja huoltavat varastossa olevia koneita.",
                    label = "Kauppojen sijainnit",
                },
                moneywashShops = {
                    description = "Sijoita kauppoja pesureille, generaattoreille ja tuulettimille. Tilaukset menevät organisaation valitsemaan yritykseen.",
                    label = "Kauppojen sijainnit",
                },
                mwEquipment = "Laitteiden kauppa",
                mwInteriors = "Tyhjät sisätilat",
                mwProperties = "Sijainnit",
                mwRepairShops = "Korjaamo",
                mwSettings = "Yrityksen asetukset",
                names = {
                    mwPublicLaundry = "Julkinen pesula",
                    mwPaperPulp = "Paperimassa",
                    mwPrintingPaper = "Painopaperi",
                    mwPrintingInk = "Painoväri",
                    mwPaperRecipe = "Valmista painopaperia",
                    mwPrintingRecipe = "Tavalliset setelit",
                    mwPaperCollector = "Paperinkerääjä",
                    mwInkCollector = "Värinkerääjä",
                    mwPaperProcessor = "Paperinjalostaja",
                    mwPrinter = "Painokone",
                    mwInspectionTable = "Tarkastuspöytä",
                    mwDryingCabinet = "Kuivauskaappi",
                    mwNode1 = "1 · Pesu",
                    mwNode2 = "2 · Pesu",
                    mwNode3 = "3 · Rakennuspisteet",
                    mwNode4 = "4 · Painatus",
                    mwNode5 = "5 · Tarkastus",
                    mwNode6 = "6 · Kuivaus",
                    mwNode7 = "7 · Rakennuspisteet",

                    mwInteriorWarehouse = "Tyhjä varasto",
                },
                options = {
                    private = "Yksityinen",
                    public = "Julkinen",
                    faction = "Organisaatio",
                    person = "Hahmo",
                    printer = "Painokone",
                    inspection = "Tarkastuspöytä",
                    dryer = "Kuivauskaappi",

                    fan = "Tuuletin",
                    generator = "Generaattori",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Korjaussarja",
                    shell = "Shell-malli",
                    washer = "Pesukone",
                },
                origin = "Alkuperä",
                storage = "Varastopiste",
            },
            settingFields = {
                cultivationLevel = "Kasvatustaso",
                cultivationTitle = "Tason nimi",
                cultivationRequiredXp = "Vaadittu kokonais-XP",
                cultivationAction = "Toiminto",
                cultivationXp = "XP",
                cultivationCategory = "Luokka",
                cultivationEntry = "Kohde",
                cultivationRequiredLevel = "Vaadittu taso",
                alias = "Nimimerkki",
                atmHeading = "Suunta",
                atmId = "ID",
                atmModel = "Pankkiautomaatin malli",
                centerX = "Keskiö X",
                centerY = "Keskipiste Y",
                centerZ = "Keskiö Z",
                deliveryMethod = "Toimitustapa",
                description = "Kuvaus",
                enabled = "Aktiivinen",
                groupKey = "Ryhmän avain",
                id = "ID",
                itemLabel = "Tavaran nimi",
                itemName = "Inventaarion esineen nimi",
                knownScammer = "Tunnettu huijari",
                locationName = "Sijainnin nimi",
                observerW = "Observer-suunta",
                observerX = "Tarkkailija X",
                observerY = "Tarkkailija Y",
                observerZ = "Tarkkailija Z",
                pedModel = "NPC-ped-malli",
                pickpocketItemChance = "Mahdollisuus (%)",
                pickpocketItemMaximum = "Enimmäismäärä",
                pickpocketItemMinimum = "Minimimäärä",
                pickpocketItemName = "Inventaarion esineen nimi",
                quantity = "Määrä",
                radius = "Säde",
                rating = "Näytetty arvosana",
                ratingCount = "Näytetty arvosanojen määrä",
                scamChance = "Kauppiaan huijausmahdollisuus (%)",
                shopCategory = "Luokka",
                shopClerkHeading = "Myyjän suunta",
                shopClerkModel = "Myyjän malli",
                shopClerkRequired = "Myyjä vaaditaan",
                shopClerkX = "Myyjä X",
                shopClerkY = "Myyjä Y",
                shopClerkZ = "Myyjä Z",
                shopCodeEnabled = "Salli avaaminen koodilla",
                shopDrillEnabled = "Salli poraus",
                shopEnabled = "Käytössä",
                shopHackEnabled = "Salli hakkerointi",
                shopLocationId = "Kaupan ID",
                shopLocationLabel = "Nimike",
                shopRegisterId = "Kassatunnus",
                shopSafeEnabled = "Safe käytössä",
                shopSafeHeading = "Safe-suunta",
                shopSafeX = "Turvallinen X",
                shopSafeY = "Turvallinen Y",
                shopSafeZ = "Turvallinen Z",
                side = "Markkinapuoli",
                spawns = "Tiimin spawnit",
                successfulTrades = "Näytetyt onnistuneet kaupat",
                title = "Tarjouksen otsikko",
                unitPrice = "Yksikköhinta",
                verified = "Vahvistettu kauppias",
                w = "Suunta",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Myyjän sijainti",
                shopRegisterPosition = "Kassan sijainti",
                shopSafePosition = "Kassakaapin sijainti",
                registerId = "Kassakoneen tunnus",
                registerX = "Kassakoneen X-koordinaatti",
                registerY = "Kassakoneen Y-koordinaatti",
                registerZ = "Kassakoneen Z-koordinaatti",
                heading = "Suunta",
                captureLocation = "Tallenna sijainti",
            },
            crimeDashboard = {
                jobs = "Hallitse ryhmittymiä, jäseniä, oikeuksia ja sijainteja.",
                jobCreator = "Valitse ryhmittymä muokataksesi sen sijainteja ja alueita.",
                jobsQuestion = "Missä muokkaan ryhmittymiä ja sijainteja?",
                jobsAnswer = "Avaa {path}, valitse ryhmittymä ja valitse Muokkaa. Voit määrittää sen asetukset ja sijainnit siellä.",
                creatorsAnswer = "Editorit löytyvät kohdasta {path}. Linkit avaavat editorin; ryhmittymien työkalut alkavat ryhmittymän valinnasta.",
                missingAnswer = "Käytettävissä olevat editorit riippuvat valitusta resurssista ja sen asetuksista. Ryhmittymien työkalut aloitetaan kyseisestä ryhmittymästä.",
                creators = {
                    mainbaseZones = "Valitse ryhmittymä ja määritä sen tukikohdan alue.",
                    presetTerritories = "Tarkista valmiit alueet ja valitse, mitkä ovat käytössä.",
                    objectsSection = "Hallitse pysyviä kuulustelutuoleja ja työkalukärryjä.",
                    blockedZonesSection = "Määritä alueet, joille kuulusteluesineitä ei voi sijoittaa.",
                    toolsSection = "Määritä kuulusteluissa käytettävissä olevat työkalut.",
                    sessionsSection = "Tarkastele käynnissä olevia kuulusteluja ja päätä istuntoja tarvittaessa.",
                    orphansSection = "Tarkista ja poista hylätyt kuulusteluesineet.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Valitse, miten rikollisjärjestöt tallentavat ja hallinnoivat jäseniään.",
                },
                territories = {
                    zones = "Määritä kohdan ”Territoriovyöhykkeet” asetukset osiossa ”Alueet”.",
                    ownership = "Määritä kohdan ”Omistus” asetukset osiossa ”Alueet”.",
                    decay = "Määritä kohdan ”Rakenne” asetukset osiossa ”Alueet”.",
                    presence = "Määritä kohdan ”Läsnäolo” asetukset osiossa ”Alueet”.",
                    activity = "Määritä kohdan ”Aktiivisuuden pisteytys” asetukset osiossa ”Alueet”.",
                    ownershipBenefits = "Määritä kohdan ”Omistajuusetu” asetukset osiossa ”Alueet”.",
                },
                graffiti = {
                    general = "Määritä kohdan ”Yleinen” asetukset osiossa ”Graffiti”.",
                    streaming = "Määritä kohdan ”Renderöinti” asetukset osiossa ”Graffiti”.",
                    moderation = "Määritä kohdan ”Moderaatio” asetukset osiossa ”Graffiti”.",
                },
                pvpEvents = {
                    pvpAvailability = "Hallitse, onko PvP-tapahtumasovellus käytettävissä ja missä se näkyy.",
                    pvpAutomation = "Määritä toistuvat tapahtumat ja automaattinen aloitusprosessi.",
                    pvpRuntime = "Säädä pyyntöjen käsittelyä, kuolemia ja uudelleensyntymisiä käynnissä olevien otteluiden aikana.",
                    pvpModes = "Määritä PvP-tabletissa esivalittu pelitila.",
                    pvpArenas = "Luo pyöreä taistelualue, tarkkailupiste ja joukkueiden spawn-pisteet PvP-tapahtumia varten.",
                    pvpLimits = "Aseta palkkio- ja tablettihistorian rajat.",
                    pvpPermissions = "Yhdistä tapahtumien hallinta ja talous ACE- ja työtehtäväoikeuksiin.",
                    pvpTakeoverRules = "Hallitse laboratorion ja camperin valtauksille asetettavissa olevia saatavuus- ja osallistumisvaatimuksia.",
                    pvpTakeoverZones = "Määritä vuorovaikutus-, hälytys- ja valtaus-alueet niiden kestoja myöten.",
                    pvpTakeoverMethods = "Määritä, kuinka kauan kukin menetelmä kestää sisäänkäynnin murtaaminen.",
                },
                drugs = {
                    creator = "Avaa Sky Crime -huume-editorin ja sulkee työmääritysten editorin.",
                    creatorSettings = "Määritä kohdan ”Editorin asetukset” asetukset osiossa ”Huumejärjestelmä”.",
                    interfaceHud = "Määritä kohdan ”Käyttöliittymän sijainnit” asetukset osiossa ”Huumejärjestelmä”.",
                    drugsGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumejärjestelmä”.",
                    runtimeAccess = "Määritä kohdan ”Käyttöoikeus ja omistus” asetukset osiossa ”Huumejärjestelmä”.",
                    runtimePayouts = "Määritä kohdan ”Maksut” asetukset osiossa ”Huumejärjestelmä”.",
                    runtimeDispatch = "Määritä kohdan ”Hätäkeskus ja poliisi” asetukset osiossa ”Huumejärjestelmä”.",
                    performanceInactiveControlIntervalMs = "Toiminta-asetus: Suorituskyky / Epäaktiivinen / Ohjaus / Aikaväli / ms.",
                    performanceInteractionIdleScanIntervalMs = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Tyhjäkäynti / Tarkistusväli / ms.",
                    performanceInteractionPromptIntervalMs = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Vuorovaikutuskehotus / Aikaväli / ms.",
                    performanceInteractionScanIntervalMs = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Tarkistusväli / ms.",
                    performanceMinimumScanIntervalMs = "Toiminta-asetus: Suorituskyky / Vähimmäisarvo / Tarkistusväli / ms.",
                    performanceStreetPedActivationDistance = "Toiminta-asetus: Suorituskyky / Katu / Ped / Aktivointi / Etäisyys.",
                    performanceStreetPedIdleScanIntervalMs = "Toiminta-asetus: Suorituskyky / Katu / Ped / Tyhjäkäynti / Tarkistusväli / ms.",
                    performanceStreetPedScanIntervalMs = "Toiminta-asetus: Suorituskyky / Katu / Ped / Tarkistusväli / ms.",
                    performanceWorldCachePadding = "Toiminta-asetus: Suorituskyky / Maailma / Välimuisti / Lisämarginaali.",
                    performanceWorldCacheRefreshIntervalMs = "Toiminta-asetus: Suorituskyky / Maailma / Välimuisti / Päivitys / Aikaväli / ms.",
                    performanceWorldIdleIntervalMs = "Toiminta-asetus: Suorituskyky / Maailma / Tyhjäkäynti / Aikaväli / ms.",
                },
                drugProduction = {
                    qualityWeights = "Määritä kohdan ”Laatu / Painotukset” asetukset osiossa ”Huumeiden tuotanto”.",
                    qualityTiers = "Määritä kohdan ”Laatu / Laatutasot” asetukset osiossa ”Huumeiden tuotanto”.",
                    packagingGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumeiden tuotanto”.",
                    processingFlow = "Määritä kohdan ”Käsittelyprosessi” asetukset osiossa ”Huumeiden tuotanto”.",
                    processingGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumeiden tuotanto”.",
                },
                drugOperations = {
                    growingGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumetoiminta”.",
                    plantDefaults = "Määritä kohdan ”Kasvi / Oletusarvot” asetukset osiossa ”Huumetoiminta”.",
                    harvestWindow = "Määritä kohdan ”Sadonkorjuu / Aikaikkuna” asetukset osiossa ”Huumetoiminta”.",
                    labsGeneral = "Ottaa käyttöön: laboratoriot ja matkailuautot pelissä.",
                    labRent = "Määritä kohdan ”Vuokra ja elinkaari” asetukset osiossa ”Huumetoiminta”.",
                    camperDefaults = "Määritä kohdan ”Asuntovaunu” asetukset osiossa ”Huumetoiminta”.",
                    labUpgrades = "Kerroin: Laboratorio / Taso / Parannus / Hinnat.",
                    labDefaults = "Määritä kohdan ”Laboratorio / Oletusarvot” asetukset osiossa ”Huumetoiminta”.",
                    powerGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumetoiminta”.",
                    generators = "Määritä kohdan ”Generaattorit” asetukset osiossa ”Huumetoiminta”.",
                    equipmentWear = "Yleinen kerroin: Varusteiden kuluminen / Prosessointi.",
                    workersGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Huumetoiminta”.",
                    cultivationGeneral = "Määritä kohdan ”Yleiset” asetukset osiossa ”Huumetoiminta”.",
                    cultivationCurve = "Määritä jokaisen kasvatustason nimi ja vaadittu kokonais-XP.",
                    cultivationExperience = "Määritä kunkin kasvatustoiminnon antama kasvatus-XP.",
                    cultivationUnlocks = "Määritä vaadittu taso astioille, kasvualustoille, laitteille, lajikkeille ja skanneritasoille.",
                    powerRuntime = "Aikaväli sekunteina: generaattorien kulutuksen ja sähköjälkien päivitys.",
                    powerHeat = "Määritä kohdan ”Poliisin huomio ja sähköjälki” asetukset osiossa ”Huumetoiminta”.",
                    powerModes = "Määritä kohdan ”Hallinta / Tilat” asetukset osiossa ”Huumetoiminta”.",
                    powerPriorities = "Määritä kohdan ”Kuormitus / Prioriteetit” asetukset osiossa ”Huumetoiminta”.",
                },
                drugMarketRisk = {
                    marketGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Markkinat ja riskit”.",
                    marketPrices = "Määritä kohdan ”Hinnat” asetukset osiossa ”Markkinat ja riskit”.",
                    distribution = "Määritä kohdan ”Jakelu” asetukset osiossa ”Markkinat ja riskit”.",
                    threatsGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Markkinat ja riskit”.",
                    threatHeat = "Määritä kohdan ”Poliisin huomio” asetukset osiossa ”Markkinat ja riskit”.",
                    threatChances = "Määritä kohdan ”Todennäköisyydet” asetukset osiossa ”Markkinat ja riskit”.",
                    consumptionGeneral = "Määritä kohdan ”Yleinen” asetukset osiossa ”Markkinat ja riskit”.",
                    consumerDecay = "Määritä kohdan ”Sietokyvyn ja riippuvuuden väheneminen” asetukset osiossa ”Markkinat ja riskit”.",
                    consumerEffects = "Määritä kohdan ”Vaikutukset ja riskit” asetukset osiossa ”Markkinat ja riskit”.",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Toiminta-asetus: Dynaaminen markkina / Toiminnon viive / sekuntia.",
                    dynamicMarketActionHistoryLimit = "Toiminta-asetus: Dynaaminen markkina / Toiminta / Historian raja.",
                    dynamicMarketAmountSaturationWeight = "Toiminta-asetus: Dynaaminen markkina / Määrä / Kyllästys / Painotus.",
                    dynamicMarketBaseIntelAccuracy = "Toiminta-asetus: Dynaaminen markkina / Perusarvo / Tiedustelun tarkkuus.",
                    dynamicMarketDefaultAverageQuality = "Toiminta-asetus: Dynaaminen markkina / Oletusarvo / Keskiarvo / Laatu.",
                    dynamicMarketDefaultResourceElasticity = "Toiminta-asetus: Dynaaminen markkina / Oletusarvo / Resurssi / Joustavuus.",
                    dynamicMarketDemandCenter = "Toiminta-asetus: Dynaaminen markkina / Kysyntä / Keskiarvo.",
                    dynamicMarketDemandPriceImpact = "Toiminta-asetus: Dynaaminen markkina / Kysyntä / Hinta / Vaikutus.",
                    dynamicMarketDirectionThreshold = "Toiminta-asetus: Dynaaminen markkina / Suunta / Kynnysarvo.",
                    dynamicMarketEnabled = "Toiminta-asetus: Dynaaminen markkina / Käytössä.",
                    dynamicMarketEventChance = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Mahdollisuus.",
                    dynamicMarketEventDurationMinutes = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Kesto / Minuutit.",
                    dynamicMarketEventMinimumDurationMinutes = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Vähimmäisarvo / Kesto / Minuutit.",
                    dynamicMarketEventStrengthMaximum = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Voimakkuus / Enimmäisarvo.",
                    dynamicMarketEventStrengthMinimum = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Voimakkuus / Vähimmäisarvo.",
                    dynamicMarketEvents = "Määritä kohdan ”Tapahtumat” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketExactIntelReputation = "Toiminta-asetus: Dynaaminen markkina / Tarkat tiedot / Maine.",
                    dynamicMarketExactIntelTrust = "Toiminta-asetus: Dynaaminen markkina / Tarkat tiedot / Luottamus.",
                    dynamicMarketGlobalZoneLabel = "Toiminta-asetus: Dynaaminen markkina / Global / Vyöhyke / Nimike.",
                    dynamicMarketHistoryLimit = "Toiminta-asetus: Dynaaminen markkina / Historian raja.",
                    dynamicMarketInitialDemand = "Toiminta-asetus: Dynaaminen markkina / Alkuarvo / Kysyntä.",
                    dynamicMarketInitialPriceMultiplier = "Toiminta-asetus: Dynaaminen markkina / Alkuarvo / Hintakerroin.",
                    dynamicMarketIntelDemandError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Kysyntä / Virhe.",
                    dynamicMarketIntelMaximumAccuracy = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Enimmäisarvo / Tarkkuus.",
                    dynamicMarketIntelMinimumAccuracy = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Vähimmäisarvo / Tarkkuus.",
                    dynamicMarketIntelPoliceError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Poliisi / Virhe.",
                    dynamicMarketIntelPriceError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Virhe.",
                    dynamicMarketIntelPriceMaximum = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Enimmäisarvo.",
                    dynamicMarketIntelPriceMinimum = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Vähimmäisarvo.",
                    dynamicMarketIntelReputationWeight = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Maine / Painotus.",
                    dynamicMarketIntelResourcePriceError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Resurssi / Hinta / Virhe.",
                    dynamicMarketIntelSaturationError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Kyllästys / Virhe.",
                    dynamicMarketIntelSeedBucketSeconds = "Toiminta-asetus: Dynaaminen markkina / Tietojen satunnaissiemenen aikaväli / sekuntia.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tila / Tarkkuus / Kynnysarvo.",
                    dynamicMarketIntelStatusErrorThreshold = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tila / Virhe / Kynnysarvo.",
                    dynamicMarketIntelSupplyError = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tarvike / Virhe.",
                    dynamicMarketIntelTrustWeight = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Luottamus / Painotus.",
                    dynamicMarketManipulationCooldownMinutes = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Jäähdytysminuutit.",
                    dynamicMarketManipulationDemandShift = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Kysyntä / Muutos.",
                    dynamicMarketManipulationDurationMinutes = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Kesto / Minuutit.",
                    dynamicMarketManipulationHeat = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Poliisin huomio.",
                    dynamicMarketManipulationMinimumBatchAmount = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Vähimmäisarvo / Erä / Määrä.",
                    dynamicMarketManipulationPaymentAccount = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Maksutili.",
                    dynamicMarketManipulationPrice = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Hinta.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Vyöhyke / Poliisin huomio / Kerroin.",
                    dynamicMarketMaximumIntelAgeMinutes = "Toiminta-asetus: Dynaaminen markkina / Enimmäisarvo / Tiedustelun ikä / Minuutit.",
                    dynamicMarketMaximumPriceMultiplier = "Toiminta-asetus: Dynaaminen markkina / Enimmäisarvo / Hintakerroin.",
                    dynamicMarketMinimumIntelAgeMinutes = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Tiedustelun ikä / Minuutit.",
                    dynamicMarketMinimumMetricWindowMinutes = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Mittari / Aikaikkuna / Minuutit.",
                    dynamicMarketMinimumPriceMultiplier = "Toiminta-asetus: Dynaaminen markkina / Minimihinta / Kerroin.",
                    dynamicMarketMinimumUpdateMinutes = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Päivitys / Minuutit.",
                    dynamicMarketPoliceDemandWeight = "Toiminta-asetus: Dynaaminen markkina / Poliisi / Kysyntä / Painotus.",
                    dynamicMarketPolicePriceImpact = "Toiminta-asetus: Dynaaminen markkina / Poliisi / Hinta / Vaikutus.",
                    dynamicMarketPoorQualityDemandPenalty = "Toiminta-asetus: Dynaaminen markkina / Heikko laatu / Kysyntä / Vähennys.",
                    dynamicMarketPoorQualityThreshold = "Toiminta-asetus: Dynaaminen markkina / Heikko laatu / Kynnysarvo.",
                    dynamicMarketPremiumQualityDemandBonus = "Toiminta-asetus: Dynaaminen markkina / Huippulaatu / Kysyntäbonus.",
                    dynamicMarketPremiumQualityThreshold = "Toiminta-asetus: Dynaaminen markkina / Huippulaatu / Kynnysarvo.",
                    dynamicMarketProductionSupplyWeight = "Toiminta-asetus: Dynaaminen markkina / Tuotanto / Tarvike / Painotus.",
                    dynamicMarketProductionWindowMinutes = "Toiminta-asetus: Dynaaminen markkina / Tuotanto / Aikaikkuna / Minuutit.",
                    dynamicMarketQualityCenter = "Toiminta-asetus: Dynaaminen markkina / Laatu / Keskiarvo.",
                    dynamicMarketQualityConfidenceImpact = "Toiminta-asetus: Dynaaminen markkina / Laatu / Luottamus / Vaikutus.",
                    dynamicMarketQualityRange = "Toiminta-asetus: Dynaaminen markkina / Laatu / Arvoalue.",
                    dynamicMarketRarityBonusMaximum = "Toiminta-asetus: Dynaaminen markkina / Harvinaisuus / Palkkio / Enimmäisarvo.",
                    dynamicMarketRegionalGlobalWeight = "Toiminta-asetus: Dynaaminen markkina / Alueellinen / Global / Painotus.",
                    dynamicMarketRegionalLocalWeight = "Toiminta-asetus: Dynaaminen markkina / Alueellinen / Paikallinen / Painotus.",
                    dynamicMarketResourceAliases = "Määritä kohdan ”Resurssi / Vaihtoehtoiset nimet” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketResourceDirectionFallThreshold = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Suunta / Lasku / Kynnysarvo.",
                    dynamicMarketResourceDirectionRiseThreshold = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Suunta / Nousu / Kynnysarvo.",
                    dynamicMarketResources = "Määritä kohdan ”Resurssit” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketSalesWindowMinutes = "Toiminta-asetus: Dynaaminen markkina / Myynti / Aikaikkuna / Minuutit.",
                    dynamicMarketSaturationDemandWeight = "Toiminta-asetus: Dynaaminen markkina / Kyllästys / Kysyntä / Painotus.",
                    dynamicMarketSaturationPriceImpact = "Toiminta-asetus: Dynaaminen markkina / Kyllästys / Hinta / Vaikutus.",
                    dynamicMarketScarcityDemandWeight = "Toiminta-asetus: Dynaaminen markkina / Niukkuus / Kysyntä / Painotus.",
                    dynamicMarketScarcityPriceImpact = "Toiminta-asetus: Dynaaminen markkina / Niukkuus / Hinta / Vaikutus.",
                    dynamicMarketSeasonEndMonths = "Määritä kohdan ”Vuodenaika / Loppu / Kuukaudet” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketSeasonMultipliers = "Määritä kohdan ”Vuodenaika / Kertoimet” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketShortageRumorThreshold = "Toiminta-asetus: Dynaaminen markkina / Puute / Huhu / Kynnysarvo.",
                    dynamicMarketStatusThresholds = "Määritä kohdan ”Tila / Kynnysarvot” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketTargetSupply = "Toiminta-asetus: Dynaaminen markkina / Kohde / Tarvike.",
                    dynamicMarketTrendChance = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Mahdollisuus.",
                    dynamicMarketTrendDurationMinutes = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Kesto / Minuutit.",
                    dynamicMarketTrendMaximumStrength = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Enimmäisarvo / Voimakkuus.",
                    dynamicMarketTrendMinimumStrength = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Vähimmäisarvo / Voimakkuus.",
                    dynamicMarketUpdateMinutes = "Toiminta-asetus: Dynaaminen markkina / Päivitys / Minuutit.",
                    dynamicMarketVolatilityMaximum = "Toiminta-asetus: Dynaaminen markkina / Hintavaihtelu / Enimmäisarvo.",
                    dynamicMarketVolatilityMinimum = "Toiminta-asetus: Dynaaminen markkina / Hintavaihtelu / Vähimmäisarvo.",
                    dynamicMarketWeatherMultipliers = "Määritä kohdan ”Sää / Kertoimet” asetukset osiossa ”Huumeverkostot”.",
                    dynamicMarketWeatherState = "Toiminta-asetus: Dynaaminen markkina / Sää / Tila.",
                    heatActionCooldownSeconds = "Toiminta-asetus: Poliisin huomio ja riski / Toiminnon viive / sekuntia.",
                    heatActivityRiskWeights = "Määritä kohdan ”Toiminta / Riski / Painotukset” asetukset osiossa ”Huumeverkostot”.",
                    heatAggressiveHeatMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Aggressiivinen toimintatapa / Poliisin huomio / Kerroin.",
                    heatBurnerBurnThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Kertakäyttöpuhelin / Paljastuminen / Kynnysarvo.",
                    heatBurnerHeatPerWholesale = "Toiminta-asetus: Poliisin huomio ja riski / Kertakäyttöpuhelin / Poliisin huomio / Tukkukauppaa kohti.",
                    heatBurnerPhoneItem = "Toiminta-asetus: Poliisin huomio ja riski / Puhdeleva puhelin / Esine.",
                    heatCamperOperationalHeatMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kerroin.",
                    heatCamperOperationalHeatThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kynnysarvo.",
                    heatCamperParkedHeat = "Toiminta-asetus: Poliisin huomio ja riski / Pysäköity matkailuauto / Poliisin huomio.",
                    heatContaminatedHeatMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Saastuminen / Poliisin huomio / Kerroin.",
                    heatContaminatedThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Saastuminen / Kynnysarvo.",
                    heatCultivationFreePlants = "Toiminta-asetus: Poliisin huomio ja riski / Viljely / Kasvit ilman lisäriskiä.",
                    heatCultivationHeatPerPlant = "Toiminta-asetus: Poliisin huomio ja riski / Viljely / Poliisin huomio / Kasvia kohti.",
                    heatDealerHiddenMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Jälleenmyyjä / piilotettu / Minuutit.",
                    heatDecayPerTick = "Määritä kohdan ”Rakenne / Päivitysjaksoa kohti” asetukset osiossa ”Huumeverkostot”.",
                    heatEnabled = "Toiminta-asetus: Poliisin huomio ja riski / Käytössä.",
                    heatEnforcementHeat = "Määritä kohdan ”Poliisin läsnäolo / Poliisin huomio” asetukset osiossa ”Huumeverkostot”.",
                    heatEnforcementMultipliers = "Määritä kohdan ”Poliisin läsnäolo / Kertoimet” asetukset osiossa ”Huumeverkostot”.",
                    heatEntityTypes = "Määritä kohdan ”Peliobjekti / Tyypit” asetukset osiossa ”Huumeverkostot”.",
                    heatEventCooldownMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Tapahtuma / Jäähdytysminuutit.",
                    heatEventHistoryLimit = "Toiminta-asetus: Poliisin huomio ja riski / Tapahtuma / Historian raja.",
                    heatLabHeatSyncThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Laboratorio / Poliisin huomio / Synkronointi / Kynnysarvo.",
                    heatLayLowCooldownMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Jäähdytysminuutit.",
                    heatLayLowIdleMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Tyhjäkäynti / Minuutit.",
                    heatLayLowReduction = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Vähennys.",
                    heatLockdownMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Lukitus / Minuutit.",
                    heatMinimumDurationMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Kesto / Minuutit.",
                    heatMinimumEventCooldownSeconds = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Tapahtuma / Lepoväli (sekuntia).",
                    heatMinimumIdleSeconds = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Tyhjäkäynti / sekuntia.",
                    heatProcessingHeatMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Prosessointi / Poliisin huomio / Kerroin.",
                    heatRiskWeights = "Määritä kohdan ”Riski / Painotukset” asetukset osiossa ”Huumeverkostot”.",
                    heatRotateBurnerReduction = "Toiminta-asetus: Poliisin huomio ja riski / Vaihda kertakäyttöpuhelin / Vähennys.",
                    heatRouteControlMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Reitti / Ohjaus / Minuutit.",
                    heatSaleHeat = "Määritä kohdan ”Myynti / Poliisin huomio” asetukset osiossa ”Huumeverkostot”.",
                    heatThresholds = "Määritä kohdan ”Kynnysarvot” asetukset osiossa ”Huumeverkostot”.",
                    heatTickMinutes = "Toiminta-asetus: Poliisin huomio ja riski / Päivitysjakso / Minuutit.",
                    heatWholesaleHeatMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Tukkukauppa / Poliisin huomio / Kerroin.",
                    heatWorkerLeakAlertRadius = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Hälytyssäde.",
                    heatWorkerLeakBaseChance = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Perusarvo / Mahdollisuus.",
                    heatWorkerLeakFactionMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Faktio / Kerroin.",
                    heatWorkerLeakHighSeverityThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Korkea / Vakavuus / Kynnysarvo.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Mahdollisuus / Kerroin.",
                    heatWorkerLeakLoyaltyThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Kynnysarvo.",
                    heatWorkerLeakMaximumChance = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Enimmäisarvo / Mahdollisuus.",
                    heatWorkerLeakMinimumCooldownSeconds = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Vähimmäisarvo / Lepoväli (sekuntia).",
                    heatWorkerLeakRouteMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Reitti / Kerroin.",
                    heatWorkerLeakStrengthMaximum = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Enimmäisarvo.",
                    heatWorkerLeakStrengthMinimum = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Vähimmäisarvo.",
                    heatWorkerLeakStrengthMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Kerroin.",
                    heatWorkerLeakStressChanceMultiplier = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Mahdollisuus / Kerroin.",
                    heatWorkerLeakStressThreshold = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Kynnysarvo.",
                    contactsActionCooldownSeconds = "Toiminta-asetus: Kontaktiverkosto / Toiminnon viive / sekuntia.",
                    contactsActiveHotspotCount = "Toiminta-asetus: Kontaktiverkosto / Aktiivisten kohteiden määrä.",
                    contactsBurnerHintTrust = "Toiminta-asetus: Kontaktiverkosto / Pöytäpuhelin-vihje / Luottamus.",
                    contactsBurnerOfferMaximumMultiplier = "Toiminta-asetus: Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Enimmäisarvo / Kerroin.",
                    contactsBurnerOfferMinimumMultiplier = "Toiminta-asetus: Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Vähimmäisarvo / Kerroin.",
                    contactsBuyerCooldownMinutes = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Jäähdytysminuutit.",
                    contactsBuyerDeliveryDistance = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Toimitusetäisyys.",
                    contactsBuyerPremiumSuccessScore = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Premium / Onnistuminen / Pistemäärä.",
                    contactsBuyerPremiumTrustGain = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Premium / Luottamus / saanto.",
                    contactsBuyerRequestHeatRiskWeight = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Pyyntö / Poliisi & etsintäpaino / Painotus.",
                    contactsBuyerStandardTrustGain = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Standardi / Luottamus / saanto.",
                    contactsContactActiveDelaySeconds = "Määritä kohdan ”Kontaktin aktivointiviive / sekuntia” asetukset osiossa ”Huumeverkostot”.",
                    contactsContactDemandRange = "Määritä kohdan ”Yhteystiedot / Kysyntä / Arvoalue” asetukset osiossa ”Huumeverkostot”.",
                    contactsContactLossTrust = "Toiminta-asetus: Kontaktiverkosto / Yhteystiedot / Tappio / Luottamus.",
                    contactsDarknetExactIntelMinutes = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Tarkat tiedot / Minuutit.",
                    contactsDarknetHotspotIntelPrice = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Keskittymä / Tiedustelutiedot / Hinta.",
                    contactsDarknetIntelPrice = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Tiedustelutiedot / Hinta.",
                    contactsDealerBasePrice = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Perushinta.",
                    contactsDealerHireCapacity = "Määritä kohdan ”Jälleenmyyjä / Palkkaaminen / kapasiteetti” asetukset osiossa ”Huumeverkostot”.",
                    contactsDealerHireRisk = "Määritä kohdan ”Jälleenmyyjä / Palkkaaminen / Riski” asetukset osiossa ”Huumeverkostot”.",
                    contactsDealerHireSkill = "Määritä kohdan ”Jälleenmyyjä / Palkkaaminen / Taito” asetukset osiossa ”Huumeverkostot”.",
                    contactsDealerOffers = "Määritä kohdan ”Jälleenmyyjän tarjoukset” asetukset osiossa ”Huumeverkostot”.",
                    contactsDealerProtectionHours = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Suojaus / Tunnit.",
                    contactsDealerProtectionPrice = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Suojaus / Hinta.",
                    contactsDealerSaleMax = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Myynti / Enimmäisarvo.",
                    contactsDealerSaleMin = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Myynti / Vähimmäisarvo.",
                    contactsDealerSimulation = "Määritä kohdan ”Jälleenmyyjä / Simulaatio” asetukset osiossa ”Huumeverkostot”.",
                    contactsDealerTickMinutes = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Päivitysjakso / Minuutit.",
                    contactsDealerWage = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka.",
                    contactsDealerWageDecay = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka / Rakenne.",
                    contactsDealerWageLoyaltyGain = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka / Uskollisuus / saanto.",
                    contactsDealerWeaknesses = "Määritä kohdan ”Jälleenmyyjä / Heikkoudet” asetukset osiossa ”Huumeverkostot”.",
                    contactsDefaultContactDemand = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Yhteystiedot / Kysyntä.",
                    contactsDefaultContactRisk = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Yhteystiedot / Riski.",
                    contactsDefaultDealerCapacity = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / kapasiteetti.",
                    contactsDefaultDealerRisk = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / Riski.",
                    contactsDefaultDealerSkill = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / Taito.",
                    contactsDefaultHotspotRadius = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Keskittymä / Säde.",
                    contactsDemandResetMinutes = "Toiminta-asetus: Kontaktiverkosto / Kysynnän nollaus (minuuttia).",
                    contactsEnabled = "Toiminta-asetus: Kontaktiverkosto / Käytössä.",
                    contactsExactLocationTrust = "Toiminta-asetus: Kontaktiverkosto / Tarkka sijainti / Luottamus.",
                    contactsFactionDiscoveryReputation = "Toiminta-asetus: Kontaktiverkosto / Faktio / Löytäminen / Maine.",
                    contactsFactionHintTrust = "Toiminta-asetus: Kontaktiverkosto / Faktio / Vihje / Luottamus.",
                    contactsFailedDeliveryCooldownMinutes = "Toiminta-asetus: Kontaktiverkosto / Epäonnistunut toimitus / Jäähdytysminuutit.",
                    contactsFakeDealEncounter = "Määritä kohdan ”Valekauppa / Kohtaaminen” asetukset osiossa ”Huumeverkostot”.",
                    contactsFallbackPreferredDrug = "Toiminta-asetus: Kontaktiverkosto / Vara-arvo / Suosittu huume.",
                    contactsFallbackProductLabel = "Toiminta-asetus: Kontaktiverkosto / Vara-arvo / Tuotteen nimi.",
                    contactsGuideBookItem = "Toiminta-asetus: Kontaktiverkosto / Opas / Kirja / Esine.",
                    contactsGuideBookTrust = "Toiminta-asetus: Kontaktiverkosto / Opas / Kirja / Luottamus.",
                    contactsHireDealerPrice = "Toiminta-asetus: Kontaktiverkosto / Palkkaa jälleenmyyjä / Hinta.",
                    contactsHistoryLimit = "Toiminta-asetus: Kontaktiverkosto / Historian raja.",
                    contactsHotspotIntelMinutes = "Toiminta-asetus: Kontaktiverkosto / Keskittymä / Tiedustelutiedot / Minuutit.",
                    contactsHotspotRotationMinutes = "Toiminta-asetus: Kontaktiverkosto / Keskittymä / Vaihto / Minuutit.",
                    contactsListingDurationMinutes = "Toiminta-asetus: Kontaktiverkosto / Ilmoitus / Kesto / Minuutit.",
                    contactsMaxOwnedDealers = "Toiminta-asetus: Kontaktiverkosto / Enimmäisarvo / Omistettu / Jälleenmyyjät.",
                    contactsMinimumBuyerDeliveryDistance = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ostaja / Toimitusetäisyys.",
                    contactsMinimumContactRotationMinutes = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Kontakti-vuoro (minuuttia).",
                    contactsMinimumDemandResetMinutes = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Kysynnän nollaus (minuuttia).",
                    contactsMinimumHeatMultiplier = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Poliisin huomio / Kerroin.",
                    contactsMinimumHotspotIntelMinutes = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Tiedustelutiedot / Minuutit.",
                    contactsMinimumHotspotRadius = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Säde.",
                    contactsMinimumHotspotRotationMinutes = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Vaihto / Minuutit.",
                    contactsMinimumListingDurationMinutes = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ilmoitus / Kesto / Minuutit.",
                    contactsMinimumRewardMultiplier = "Toiminta-asetus: Kontaktiverkosto / Minimipalkkio / Kerroin.",
                    contactsMinimumRobberyMultiplier = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ryöstö / Kerroin.",
                    contactsMinimumSpotPriceMultiplier = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Sijainti / Hintakerroin.",
                    contactsOtherDrugPriceMultiplier = "Toiminta-asetus: Kontaktiverkosto / Muu / Huume / Hintakerroin.",
                    contactsPaymentAccount = "Toiminta-asetus: Kontaktiverkosto / Maksutili.",
                    contactsPostDeliveryDemandResetSeconds = "Toiminta-asetus: Kontaktiverkosto / Toimituksen jälkeen / Kysyntä / Reset / sekuntia.",
                    contactsPreferredDrugPriceMultiplier = "Toiminta-asetus: Kontaktiverkosto / Suosittu huume / Hintakerroin.",
                    contactsRegionLocationTrust = "Toiminta-asetus: Kontaktiverkosto / Alue / Sijainti / Luottamus.",
                    contactsRequestAmounts = "Määritä kohdan ”Pyyntö / Määrät” asetukset osiossa ”Huumeverkostot”.",
                    contactsRotationMinutes = "Toiminta-asetus: Kontaktiverkosto / Vaihto / Minuutit.",
                    contactsSpotPools = "Määritä kohdan ”Sijainti / Valintaryhmät” asetukset osiossa ”Huumeverkostot”.",
                    contactsStreetHotspots = "Määritä kohdan ”Katu / Keskittymät” asetukset osiossa ”Huumeverkostot”.",
                    contactsTrustLevels = "Määritä kohdan ”Luottamus / Tasot” asetukset osiossa ”Huumeverkostot”.",
                    businessActionCooldownSeconds = "Toiminta-asetus: Yritysverkosto / Toiminnon viive / sekuntia.",
                    businessBalance = "Määritä kohdan ”Saldo” asetukset osiossa ”Huumeverkostot”.",
                    businessContracts = "Määritä kohdan ”Sopimukset” asetukset osiossa ”Huumeverkostot”.",
                    businessDefaultBusinessName = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Yrityksen nimi.",
                    businessDefaultRankId = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Arvo / ID.",
                    businessDefaultStaffStyle = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Henkilöstö / Työtapa.",
                    businessDefaultTransport = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Kuljetus.",
                    businessEnabled = "Toiminta-asetus: Yritysverkosto / Käytössä.",
                    businessHubs = "Määritä kohdan ”Jakelukeskukset” asetukset osiossa ”Huumeverkostot”.",
                    businessLimits = "Määritä kohdan ”Rajat” asetukset osiossa ”Huumeverkostot”.",
                    businessPayments = "Valitse, mikä saldo maksaa Business Network -ostot ja käyttökustannukset.",
                    businessPayoutAccount = "Toiminta-asetus: Yritysverkosto / Maksu / Tili.",
                    businessRanks = "Määritä kohdan ”Arvot” asetukset osiossa ”Huumeverkostot”.",
                    businessReportDays = "Toiminta-asetus: Yritysverkosto / Raportointijakso / päivää.",
                    businessRouteEndpointTypes = "Määritä kohdan ”Reitti / Päätepiste / Tyypit” asetukset osiossa ”Huumeverkostot”.",
                    businessRuntime = "Määritä kohdan ”Toiminta pelissä” asetukset osiossa ”Huumeverkostot”.",
                    businessSocietyPermission = "Toiminta-asetus: Yritysverkosto / Organisaatio / Käyttöoikeus.",
                    businessStaff = "Määritä kohdan ”Henkilöstö” asetukset osiossa ”Huumeverkostot”.",
                    businessTickMinutes = "Toiminta-asetus: Yritysverkosto / Päivitysjakso / Minuutit.",
                    businessTransports = "Määritä kohdan ”Kuljetukset” asetukset osiossa ”Huumeverkostot”.",
                },
                robbery = {
                    atmAvailability = "Ota itsenäinen pankkiautomaattiryöstöjärjestelmä käyttöön tai poista se käytöstä.",
                    atmLocations = "Hallitse palvelinvaltuuttamia pankkiautomaattien sijainteja, jotka ovat saatavilla ryöstöjä varten.",
                    atmPolice = "Määritä palveluksessa olevien poliisien määrä ryöstön aloittamiseksi.",
                    atmItems = "Määritä tarvittavat poran, vetoliinan ja räjähdepanoksen esineet.",
                    atmActionTimes = "Aseta kiinnittämisen, asettamisen, räjäyttämisen ja ryöstämisen kesto.",
                    atmTimeouts = "Määritä, kuinka kauan murrettu pankkiautomaatti on saatavilla saaliin keräämistä varten.",
                    atmPayout = "Määritä kohdetili ja satunnainen palkkiorajaus.",
                    atmDistances = "Aseta pelaaja- ja ajoneuvoväli pankkiautomaattien vuorovaikutusta varten.",
                    atmExplosionEffects = "Konfiguroi räjähdyksen natiiviparametrit, joita käytetään räjähdyksen aikana.",
                    atmDispatchAlert = "Määritä poliisihälytyksen säde, kesto ja prioriteetti.",
                    atmDispatchRecipients = "Valitse, mitkä työtehtävät saavat ilmoituksen pankkiautomaattiryöstöstä.",
                    shopAvailability = "Ota ryöstöt käyttöön ja määritä poliisivaatimus.",
                    shopTiming = "Määritä pelottelu, toiminnot, aikataulu ja jäähdytysaika.",
                    shopSafe = "Määritä näppäimistön yrityskerrat ja poraus-esine.",
                    shopRegisterReward = "Määritä kunkin kassan satunnainen palkinto.",
                    shopSafeReward = "Määritä satunnainen kassakaapin palkinto.",
                    shopDispatchSettings = "Määritä vastaanottajat ja hälytysominaisuudet.",
                    shopLocationTable = "Hallitse miehitettyjä vähittäiskauppoja ja kassakaappeja.",
                    pickpocketAvailability = "Ota ominaisuus käyttöön ja rajoita se valinnaisesti määritettyihin rikostöihin.",
                    pickpocketGameplay = "Valitse haaste sekä itsenäiset pako-, hätäpuhelu- ja vastaisku-todennäköisyydet.",
                    pickpocketItemRewards = "Hallitse tyhjiä taskuja ja näkyviä esinevalintoja 0.0001 prosenttiin asti.",
                    pickpocketMoney = "Määritä palvelimen luoma satunnainen käteismääräalue.",
                    pickpocketDistances = "Aseta NPC-kantama, jota käytetään jaetussa kehävalikossa ja kohdistusjärjestelmässä.",
                    pickpocketRateLimits = "Hallitse pyyntöjen rajoitusta, NPC-kohtaista jäähdytysaikaa ja istunnon vanhentumista.",
                    pickpocketDispatchSettings = "Määritä hälytys, joka lähetetään, kun NPC soittaa hätänumeroon.",
                    heistCrafting = "Valitse, kuinka paljon vuorovaikutusta ryöstövarusteiden valmistus vaatii. Koskee uusia yrityksiä koko Crime Systemin alueella.",
                    heistCreatorMenu = "Luo, muokkaa ja julkaise modulaarisia ryöstöjä erillisessä Heist Creatorissa.",
                    heistExecution = "Aloitusikkuna, toimettomuus ja cooldown ryöstöyrityksille.",
                    npcPoliceSupport = "Aseistetut NPC-poliisit reagoivat jalkaisin ryöstöhälytyksiin ja tukevat poliisia taistelemalla ryöstäjiä vastaan.",
                },
                baseRaids = {
                    baseRaids = "Pääsy ratsioihin, vaatimukset ja erikseen valittavat saalisluokat. Avoimilla ratsioilla ei ole kuljetuksen aikarajaa.",
                },
                weapons = {
                    weaponCreatorMenu = "Hallitse asereittejä ja rahanpesua yhdessä editorissa.",
                    weaponRuntime = "Hallitse asereittien saatavuutta ja käyttöoikeuksia.",
                    weaponDefaultsgeneral = "Määritä kohdan ”Yleiset oletukset” asetukset osiossa ”Asereitit”.",
                    weaponDefaultsaccess = "Määritä kohdan ”Pääsyn oletukset” asetukset osiossa ”Asereitit”.",
                    weaponDefaultscollection = "Määritä kohdan ”Keräyksen oletukset” asetukset osiossa ”Asereitit”.",
                    weaponDefaultsproduction = "Määritä kohdan ”Tuotannon oletukset” asetukset osiossa ”Asereitit”.",
                    weaponDefaultsmarket = "Määritä kohdan ”Markkinoiden oletukset” asetukset osiossa ”Asereitit”.",
                    weaponDefaultsdelivery = "Määritä kohdan ”Tilausten oletukset” asetukset osiossa ”Asereitit”.",
                    weaponStreet = "Määritä kohdan ”Aseiden katumyynti” asetukset osiossa ”Asereitit”.",
                },
                darknetMarket = {
                    darknetAvailability = "Hallitsee tablettisovellusta ja sen sijoittelua.",
                    darknetEconomy = "Konfiguroi lompakon saldot, kolikonvaihto ja maksukannat.",
                    darknetListings = "Hallitsoittimet tarjoavat rajoituksia, hintoja ja automaattisen vanhentumisen.",
                    darknetChat = "Rajoittaa salattuja markkinapaikan viestejä.",
                    darknetIdentity = "Konfiguroi identiteetin vaihtuminen, varmentaminen ja huijausvaroitukset.",
                    darknetDelivery = "Konfiguroi fyysiset tapaamiset ja maailmassa varastettavat laatikot.",
                    darknetDeliveryLocations = "Konfiguroi sijaintipoolit, joista BlackBay valitsee satunnaisesti NPC-kaupankäynnissä.",
                    darknetPolice = "Työtehtäväryhmät, jotka saavat julkaista ansoja ja tarkastella tutkimuksia.",
                    darknetNpcTraders = "Pysyvät NPC-ostajat ja -myyjät konfiguroidulla riskillä.",
                },
                interrogation = {
                    general = "Määritä kohdan ”Yleinen” asetukset osiossa ”Kuulustelu”.",
                    consent = "Määritä kohdan ”Pelaajansuojaus” asetukset osiossa ”Kuulustelu”.",
                    objects = "Määritä kohdan ”Kohteet” asetukset osiossa ”Kuulustelu”.",
                    grab = "Määritä kohdan ”Kiinniotto” asetukset osiossa ”Kuulustelu”.",
                    session = "Määritä kohdan ”Istunto” asetukset osiossa ”Kuulustelu”.",
                    dispatch = "Määritä kohdan ”Poliisihälytykset” asetukset osiossa ”Kuulustelu”.",
                    logging = "Määritä kohdan ”Lokitus” asetukset osiossa ”Kuulustelu”.",
                    security = "Määritä kohdan ”Turvallisuus” asetukset osiossa ”Kuulustelu”.",
                    presentation = "Määritä kohdan ”Esitys” asetukset osiossa ”Kuulustelu”.",
                },
                reputation = {
                    crimeReputation = "Määritä kohdan ”Maine” asetukset osiossa ”Maine”.",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Yleinen", description = "Hallitse asereittien saatavuutta ja käyttöoikeuksia." },
                weaponCreatorMenu = { label = "Laiton liiketoiminnan luoja", description = "Hallitse asereittejä ja rahanpesua yhdessä editorissa." },
                atmActionTimes = {
                    description = "Aseta kiinnittämisen, asettamisen, räjäyttämisen ja ryöstämisen kesto.",
                    label = "Toiminnan kesto",
                },
                atmAvailability = {
                    description = "Ota itsenäinen pankkiautomaattiryöstöjärjestelmä käyttöön tai poista se käytöstä.",
                    label = "Käytettävyys",
                },
                atmDispatchAlert = {
                    description = "Määritä poliisihälytyksen säde, kesto ja prioriteetti.",
                    label = "Hälytysominaisuudet",
                },
                atmDispatchRecipients = {
                    description = "Valitse, mitkä työtehtävät saavat ilmoituksen pankkiautomaattiryöstöstä.",
                    label = "Vastaanottajat",
                },
                atmDistances = {
                    description = "Aseta pelaaja- ja ajoneuvoväli pankkiautomaattien vuorovaikutusta varten.",
                    label = "Vuorovaikutusetäisyydet",
                },
                atmExplosionEffects = {
                    description = "Konfiguroi räjähdyksen natiiviparametrit, joita käytetään räjähdyksen aikana.",
                    label = "Räjähdysvaikutukset",
                },
                atmItems = {
                    description = "Määritä tarvittavat poran, vetoliinan ja räjähdepanoksen esineet.",
                    label = "Vaaditut esineet",
                },
                atmLocations = {
                    description = "Hallitse palvelinvaltuuttamia pankkiautomaattien sijainteja, jotka ovat saatavilla ryöstöjä varten.",
                    label = "Pankkiautomaatin sijainnit",
                },
                atmPayout = {
                    description = "Määritä kohdetili ja satunnainen palkkiorajaus.",
                    label = "Maksu",
                },
                atmPolice = {
                    description = "Määritä palveluksessa olevien poliisien määrä ryöstön aloittamiseksi.",
                    label = "Poliisivaatimus",
                },
                atmPulling = {
                    description = "Määritä liike, jota tarvitaan pankkiautomaatin repimiseksi irti seinästä.",
                    label = "Riemaisun tunnistus",
                },
                atmTimeouts = {
                    description = "Määritä, kuinka kauan murrettu pankkiautomaatti on saatavilla saaliin keräämistä varten.",
                    label = "Saaliin aikataulu",
                },
                baseRaids = {
                    description = "Pääsy ratsioihin, vaatimukset ja erikseen valittavat saalisluokat. Avoimilla ratsioilla ei ole kuljetuksen aikarajaa.",
                    label = "Base-raidit",
                },
                businessPayments = {
                    description = "Valitse, mikä saldo maksaa Business Network -ostot ja käyttökustannukset.",
                    label = "Maksut",
                },
                crimeMembership = {
                    description = "Valitse, miten rikollisjärjestöt tallentavat ja hallinnoivat jäseniään.",
                    label = "Jäsenyysmalli",
                },
                darknetAvailability = {
                    description = "Hallitsee tablettisovellusta ja sen sijoittelua.",
                    label = "Käytettävyys",
                },
                darknetChat = {
                    description = "Rajoittaa salattuja markkinapaikan viestejä.",
                    label = "Yksityischat",
                },
                darknetDelivery = {
                    description = "Konfiguroi fyysiset tapaamiset ja maailmassa varastettavat laatikot.",
                    label = "Luovutukset ja Dead Dropit",
                },
                darknetDeliveryLocations = {
                    description = "Konfiguroi sijaintipoolit, joista BlackBay valitsee satunnaisesti NPC-kaupankäynnissä.",
                    label = "Luovutuspisteet",
                },
                darknetEconomy = {
                    description = "Konfiguroi lompakon saldot, kolikonvaihto ja maksukannat.",
                    label = "Kryptovaluutta",
                },
                darknetIdentity = {
                    description = "Konfiguroi identiteetin vaihtuminen, varmentaminen ja huijausvaroitukset.",
                    label = "Aliakset ja maine",
                },
                darknetListings = {
                    description = "Hallitsoittimet tarjoavat rajoituksia, hintoja ja automaattisen vanhentumisen.",
                    label = "Ilmoitukset ja vanhentuminen",
                },
                darknetNpcTraders = {
                    description = "Pysyvät NPC-ostajat ja -myyjät konfiguroidulla riskillä.",
                    label = "NPC-kauppiaat",
                },
                darknetPolice = {
                    description = "Työtehtäväryhmät, jotka saavat julkaista ansoja ja tarkastella tutkimuksia.",
                    label = "Poliisin pääsy",
                },
                heistCrafting = {
                    description = "Valitse, kuinka paljon vuorovaikutusta ryöstövarusteiden valmistus vaatii. Koskee uusia yrityksiä koko Crime Systemin alueella.",
                    label = "Ryöstön työpaja",
                },
                heistCreatorMenu = {
                    description = "Luo, muokkaa ja julkaise modulaarisia ryöstöjä erillisessä Heist Creatorissa.",
                    label = "Creator-valikko",
                },
                heistExecution = {
                    description = "Aloitusikkuna, toimettomuus ja cooldown ryöstöyrityksille.",
                    label = "Ryöstön ajoitus",
                },
                moneywashEconomy = {
                    description = "Ota liiketoiminnat käyttöön ja määritä talletustili, palvelumaksu ja vuorovaikutusetäisyydet.",
                    label = "Yleinen",
                },
                npcPoliceSupport = {
                    description = "Aseistetut NPC-poliisit reagoivat jalkaisin ryöstöhälytyksiin ja tukevat poliisia taistelemalla ryöstäjiä vastaan.",
                    label = "NPC-poliisi-tuki",
                },
                pickpocketAvailability = {
                    description = "Ota ominaisuus käyttöön ja rajoita se valinnaisesti määritettyihin rikostöihin.",
                    label = "Käytettävyys",
                },
                pickpocketDispatchSettings = {
                    description = "Määritä hälytys, joka lähetetään, kun NPC soittaa hätänumeroon.",
                    label = "Hätäkeskuksen hälytys",
                },
                pickpocketDistances = {
                    description = "Aseta NPC-kantama, jota käytetään jaetussa kehävalikossa ja kohdistusjärjestelmässä.",
                    label = "Vuorovaikutusetäisyydet",
                },
                pickpocketGameplay = {
                    description = "Valitse haaste sekä itsenäiset pako-, hätäpuhelu- ja vastaisku-todennäköisyydet.",
                    label = "Riski ja minipeli",
                },
                pickpocketItemRewards = {
                    description = "Hallitse tyhjiä taskuja ja näkyviä esinevalintoja 0.0001 prosenttiin asti.",
                    label = "Näkyvä taskusaalis",
                },
                pickpocketMoney = {
                    description = "Määritä palvelimen luoma satunnainen käteismääräalue.",
                    label = "Kassapalkkio",
                },
                pickpocketRateLimits = {
                    description = "Hallitse pyyntöjen rajoitusta, NPC-kohtaista jäähdytysaikaa ja istunnon vanhentumista.",
                    label = "Palvelimen suojaukset",
                },
                pvpArenas = {
                    description = "Luo pyöreä taistelualue, tarkkailupiste ja joukkueiden spawn-pisteet PvP-tapahtumia varten.",
                    label = "Areena ja taistelualueet",
                },
                pvpAutomation = {
                    description = "Määritä toistuvat tapahtumat ja automaattinen aloitusprosessi.",
                    label = "Automaatio",
                },
                pvpAvailability = {
                    description = "Hallitse, onko PvP-tapahtumasovellus käytettävissä ja missä se näkyy.",
                    label = "Käytettävyys",
                },
                pvpLimits = {
                    description = "Aseta palkkio- ja tablettihistorian rajat.",
                    label = "Rajat ja historia",
                },
                pvpModes = {
                    description = "Määritä PvP-tabletissa esivalittu pelitila.",
                    label = "Pelitilat",
                },
                pvpPermissions = {
                    description = "Yhdistä tapahtumien hallinta ja talous ACE- ja työtehtäväoikeuksiin.",
                    label = "Oikeudet",
                },
                pvpRuntime = {
                    description = "Säädä pyyntöjen käsittelyä, kuolemia ja uudelleensyntymisiä käynnissä olevien otteluiden aikana.",
                    label = "Tapahtuman kesto",
                },
                pvpTakeoverMethods = {
                    description = "Määritä, kuinka kauan kukin menetelmä kestää sisäänkäynnin murtaaminen.",
                    label = "Murtautumismenetelmät",
                },
                pvpTakeoverRules = {
                    description = "Hallitse laboratorion ja camperin valtauksille asetettavissa olevia saatavuus- ja osallistumisvaatimuksia.",
                    label = "Valtaus säännöt",
                },
                pvpTakeoverZones = {
                    description = "Määritä vuorovaikutus-, hälytys- ja valtaus-alueet niiden kestoja myöten.",
                    label = "Vyöhykkeet ja ajoitus",
                },
                shopAvailability = {
                    description = "Ota ryöstöt käyttöön ja määritä poliisivaatimus.",
                    label = "Käytettävyys",
                },
                shopDispatchSettings = {
                    description = "Määritä vastaanottajat ja hälytysominaisuudet.",
                    label = "Poliisihälytys",
                },
                shopLocationTable = {
                    description = "Hallitse miehitettyjä vähittäiskauppoja ja kassakaappeja.",
                    label = "Kauppojen sijainnit",
                },
                shopRegisterReward = {
                    description = "Määritä kunkin kassan satunnainen palkinto.",
                    label = "Kassapalkinto",
                },
                shopRegisterTable = {
                    description = "Määritä yksittäiset kassat kaupoille.",
                    label = "Kassat",
                },
                shopSafe = {
                    description = "Määritä näppäimistön yrityskerrat ja poraus-esine.",
                    label = "Kassakaappi",
                },
                shopSafeReward = {
                    description = "Määritä satunnainen kassakaapin palkinto.",
                    label = "Kassakaapin palkkio",
                },
                shopTiming = {
                    description = "Määritä pelottelu, toiminnot, aikataulu ja jäähdytysaika.",
                    label = "Ajoitus",
                },
            },
            settingSections = {
                weapons = "Asereitit",
                drugs = "Huumejärjestelmä",
                drugProduction = "Huumeiden tuotanto",
                drugOperations = "Huumetoiminta",
                drugMarketRisk = "Markkinat ja riskit",
                drugNetworks = "Huumeverkostot",
                atmRobbery = "ATM-ryöstö",
                baseRaids = "Base-raidit",
                crimeOrganizations = "Organisaatiot",
                darknetMarket = "Darknet-markkinat",
                moneywash = "Rahanpesu",
                pvpEvents = "Ryhmien välinen PvP",
                robbery = "Ryöstö",
                territories = "Alueet",
                graffiti = "Graffiti",
                interrogation = "Kuulustelu",
            },
            settingSubsections = {
                baseRaidEquipment = "Tarvittavat varusteet",
                baseRaidBreach = "Murtautuminen",
                baseRaidLoot = "Saalis ja ajoneuvot",
                graffitiLimits = "Rajoitukset ja moderointi",
                interrogationTechnical = "Lokitus ja turvallisuus",
                atmDispatch = "Poliisin hälytys",
                atmEquipment = "Laitteet",
                atmExplosion = "Räjähdys",
                atmOverview = "Yleiskatsaus & sijainnit",
                atmRewards = "Palkkiot",
                atmTiming = "Ajoitus",
                atmVehicle = "Ajoneuvo & raahaaminen",
                baseRaids = "Base-raidit",
                crimeMembership = "Jäsenyys",
                heistCreator = "Heist-luoja",
                npcPoliceSupport = "NPC-poliisi-tuki",
                pickpocket = "NPC-taskuvarkaudet",
                pvpArenas = "Areena",
                pvpEquipment = "Pelitilat",
                pvpOverview = "Yleiskatsaus",
                pvpRuntime = "Tapahtuman kesto",
                pvpTakeovers = "Laboratorion valtaukset",
                shopRobbery = "Kaupparötöt",
                atmRobbery = "ATM-ryöstö",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Vuorovaikutusetäisyys" },
                weaponDefaultGeneralPedModel = { label = "NPC:n oletusmalli" },
                weaponDefaultAccessActiveHourStart = { label = "Aukeamisaika (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Sulkemisaika (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Vaaditut päivystävät poliisit" },
                weaponDefaultAccessPoliceJobs = { label = "Poliisityöt" },
                weaponDefaultCollectionDurationSeconds = { label = "Kesto sekunteina" },
                weaponDefaultCollectionCooldownSeconds = { label = "Odotusaika sekunteina" },
                weaponDefaultCollectionCooldownScope = { label = "Odotusajan laajuus" },
                weaponDefaultCollectionUseMinigame = { label = "Käytä minipeliä" },
                weaponDefaultCollectionMinigame = { label = "Minipeli" },
                weaponDefaultCollectionMinigameRounds = { label = "Minipelin kierrokset" },
                weaponDefaultProductionDurationSeconds = { label = "Kesto sekunteina" },
                weaponDefaultProductionSuccessChance = { label = "Onnistumistodennäköisyys (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Kuluta ainekset epäonnistuessa" },
                weaponDefaultProductionUseMinigame = { label = "Käytä minipeliä" },
                weaponDefaultProductionMinigame = { label = "Minipeli" },
                weaponDefaultProductionMinigameRounds = { label = "Minipelin kierrokset" },
                weaponDefaultProductionQualityMin = { label = "Vähimmäislaatu" },
                weaponDefaultProductionQualityMax = { label = "Enimmäislaatu" },
                weaponDefaultProductionCooldownSeconds = { label = "Odotusaika sekunteina" },
                weaponDefaultProductionCooldownScope = { label = "Odotusajan laajuus" },
                weaponDefaultMarketPayoutAccount = { label = "Maksutili" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Vähimmäishintakerroin (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Enimmäishintakerroin (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Täydennysväli sekunteina" },
                weaponDefaultMarketCooldownSeconds = { label = "Odotusaika sekunteina" },
                weaponDefaultMarketCooldownScope = { label = "Odotusajan laajuus" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Tilauksen määräaika minuutteina" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Tilausbonus (%)" },
                weaponStreetEnabled = { label = "Harvinaiset asekaupat katuostajille" },
                weaponStreetChance = { label = "Asetarjouksen todennäköisyys (%)" },
                weaponStreetCooldown = { label = "Odotusaika sekunteina" },
                weaponStreetAmount = { label = "Enimmäismäärä" },
                weaponStreetPriceMin = { label = "Vähimmäishintakerroin (%)" },
                weaponStreetPriceMax = { label = "Enimmäishintakerroin (%)" },
                weaponStreetAccount = { label = "Maksutili" },
                weaponStreetDirect = { label = "Suoramyynti" },
                weaponStreetBulk = { label = "Erämyynti" },
                weaponStreetContract = { label = "Kartellitilaus" },
                weaponSystemEnabled = { label = "Asereittijärjestelmä", description = "Ota aseiden kerääminen, käsittely ja myynti kartelleille käyttöön." },
                weaponRuntimeEnabled = { label = "Asereittien toiminnot", description = "Salli määritettyjen asereittien käyttö pelimaailmassa." },
                weaponCreatorAccess = { label = "Ase-editorin käyttöoikeus", description = "Valitse, kuka saa avata ase-editorin.", options = { permission = "Vain käyttöoikeudella", jobManagement = "Työn hallinta", ownerOnly = "Vain omistaja" } },
                openWeaponCreator = { label = "Laiton liiketoiminnan luoja", description = "Hallitse asereittejä ja rahanpesua yhdessä editorissa.", buttonLabel = "Laiton liiketoiminnan luoja", unsavedTooltip = "Tallenna ensin" },

                drugCultivationProgressionEnabled = { label = "Ota kasvatustasot käyttöön", description = "Ottaa käyttöön kasvatus-XP:n, tasot ja tasokohtaiset avausvaatimukset." },
                drugCultivationMaxLevel = { label = "Kasvatuksen enimmäistaso", description = "Korkein saavutettava kasvatustaso. Sen yläpuolisia tasoja ei voi saavuttaa." },
                drugCultivationLevels = { label = "Tasokäyrä", description = "Määritä jokaisen kasvatustason nimi ja vaadittu kokonais-XP." },
                drugCultivationActionXp = { label = "XP-palkinnot", description = "Määritä kunkin kasvatustoiminnon antama kasvatus-XP." },
                drugCultivationUnlocks = { label = "Tasojen avaukset", description = "Määritä vaadittu taso astioille, kasvualustoille, laitteille, lajikkeille ja skanneritasoille." },
                reputationRewards = { label = "Mainetoiminnot", description = "Lisää toimintoja, muuta pisteitä ja poista merkintöjä käytöstä tai kokonaan. Vain käytössä olevat merkinnät antavat pisteitä." },
                reputationEnabled = { label = "Ota rikollismaine käyttöön", description = "Myönnä henkilökohtaista mainetta." },
                reputationPointsPerLevel = { label = "Pisteet tasoa kohti", description = "Jokainen taso vaatii tämän verran lisäpisteitä." },
                reputationMinimumJoinPoints = { label = "Liittymisen vähimmäismaine", description = "Rikollisryhmittymään liittymiseen vaadittu kokonaispistemäärä. 0 poistaa vaatimuksen. Nykyiset jäsenet säilyttävät pääsyn." },
                reputation_atm = { label = "Pankkiautomaattiryöstö", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_shop_register = { label = "Kaupan kassa", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_shop_safe = { label = "Kaupan kassakaappi", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_pickpocket = { label = "Taskuvarkaus", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_heist = { label = "Ryöstön suoritus", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_harvest = { label = "Huumesato", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_processing = { label = "Huumeiden käsittely", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_sale = { label = "Huumemyynti", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_delivery = { label = "Huumetoimitus", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_contract = { label = "Jakelusopimus", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_drug_raid = { label = "Huumeratsia", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_graffiti = { label = "Graffiti", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_moneywash = { label = "Rahanpesu", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_base_raid = { label = "Tukikohdan ryöstö", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                reputation_pvp_win = { label = "PvP-voitto", description = "Pisteet onnistuneesta suorituksesta. 0 poistaa tämän palkinnon." },
                atmChargeProp = {
                    description = "Objektimalli, joka näytetään pankkiautomaatissa, kun räjähde on asetettu.",
                    label = "Räjähdeobjekti",
                },
                atmConsumeDrill = {
                    description = "Kuluttaa asetetun määrän jokaisen onnistuneesti suoritetun pankkiautomaatin porauspisteen jälkeen.",
                    label = "Kuluta pora",
                },
                atmDrillItem = {
                    description = "Inventaarioesineen tunnus, joka tarvitaan irrotetun pankkiautomaatin poraamiseen. Eri asetus kuin kaupan kassakaapin pora.",
                    label = "Poran esine",
                },
                atmDrillItemAmount = {
                    description = "Kunkin pankkiautomaatin porauspisteen vaatima poraesineiden määrä.",
                    label = "Vaadittu porien määrä",
                },
                atmDebug = {
                    description = "Kirjoittaa yksityiskohtaiset pankkiautomaattiryöstön diagnostiikat palvelinkonsoliin ja asiakasohjelman F8-konsoliin.",
                    label = "Pankkiautomaatin debug-lokit",
                },
                atmDispatchDurationSeconds = {
                    description = "Sekunnit, jotka pankkiautomaatin hälytys pysyy relevanttina hälytyskeskuksen vastaanottajille.",
                    label = "Hälytyskesto",
                },
                atmDispatchEnabled = {
                    description = "Luo ryhmän tukikohdan (Jobs Base) välikohtaus, kun pankkiautomaatti murretaan.",
                    label = "Ota käyttöön poliisin hälytys",
                },
                atmDispatchJobs = {
                    description = "Pilkuilla erotetut tehtävien nimet, jotka saavat pankkiautomaattihälytyksen.",
                    label = "Hälytystehtävät",
                },
                atmDispatchPriority = {
                    description = "Prioriteettiarvo, joka välitetään muuttumattomana hälytysintegraatioon.",
                    label = "Hälytysprioriteetti",
                },
                atmDispatchRadius = {
                    description = "Arvioitu hälytyssäde, joka lähetetään hälytysintegraatioon.",
                    label = "Hälytyssäde",
                },
                atmEnabled = {
                    description = "Tekee konfiguroiduista pankkiautomaateista käytettäviä langan ja räjähde-ryöstöihin.",
                    label = "Ota käyttöön pankkiautomaattiryöstöt",
                },
                atmExplosionCameraShake = {
                    description = "Kameraluun voimakkuus räjähdyksen aiheuttavalle klieentille.",
                    label = "Räjähdyksen kameravärinä",
                },
                atmExplosionDamageScale = {
                    description = "Vaurio- ja impulssivoimakkuus, joka välitetään räjähdys-natiiville.",
                    label = "Räjähdysvaurion skaala",
                },
                atmExplosionType = {
                    description = "GTA-räjähdystyyppi, jota käytetään räjähdyksessä. Pidä oletuksena, ellei toista tyyppiä ole testattu.",
                    label = "Räjähdystyyppi",
                },
                atmDrillDurationSeconds = {
                    label = "Porauksen vähimmäisaika ruuvia kohti (s)",
                    description = "Vähimmäisaika sekunteina kullekin neljästä ruuvista. Jäähdytystauot pidentävät yritystä. Koskee tallentamisen jälkeen aloitettuja porausyrityksiä.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Sekunnit, jotka tarvitaan räjähdeasetelman asettamiseen.",
                    label = "Räjähdeasetelman kesto",
                },
                atmExplosiveItem = {
                    description = "Inventaarioesine, joka kuluu, kun räjähde on asetettu.",
                    label = "Räjähde-esine",
                },
                atmExplosiveItemAmount = {
                    description = "Kulutettujen räjähdetavarakappaleiden määrä yhtä asetettua laadetta kohden.",
                    label = "Kulutettu räjähdemäärä",
                },
                atmFuseSeconds = {
                    description = "Sekunnit asetuksen ja räjähdyksen välillä.",
                    label = "Sytytysaika",
                },
                atmInteractionDistance = {
                    description = "Asiakaspään vuorovaikutusalueen maksimi; palvelinvalidoinnissa on turvamarginaali.",
                    label = "Vuorovaikutusetäisyys",
                },
                atmLocations = {
                    description = "Viralliset tuotantopankkiautomaatit. /atmtest-komennolla luodut sijainnit ovat tilapäisiä.",
                    itemLabel = "Pankkiautomaatin sijainti",
                    label = "Pankkiautomaatin sijainnit",
                },
                atmLootDurationSeconds = {
                    description = "Sekunnit, jotka tarvitaan murretun pankkiautomaatin avaamiseen.",
                    label = "Saaliin kesto",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Enimmäissekunnit, jonka pelaaja voi varata ATM:n avatessaan; pidetään automaattisesti loot-keston yläpuolella.",
                    label = "Loot-varauksen aikakatkaisu",
                },
                atmLootWindowMinutes = {
                    description = "Minuutit, jonka murrettu ATM pysyy lootattavana ennen kuin se tyhjenee.",
                    label = "Loot-ikkuna",
                },
                atmMinimumPolice = {
                    description = "Konfiguroidun poliisiryhmän työntekijöiden määrä, joka on oltava palveluksessa ryöstön aloittamiseksi.",
                    label = "Minimipoliisi",
                },
                atmPoliceGroup = {
                    description = "sky_jobs_base työryhmää lasketaan poliisin vaatimukseen kuuluvaan määrään.",
                    label = "Poliisiryhmä",
                },
                atmPullDistance = {
                    description = "Ajoneuvon siirtymä ATM-sijainnista, joka vaaditaan murron suorittamiseen.",
                    label = "Vaadittu vetäisyetäisyys",
                },
                atmPullMinimumSpeed = {
                    description = "Minimaalinopeus metreinä sekunnissa, kun vetosuodatin on saavuttanut tavoitedistanssinsa.",
                    label = "Minimipurkunopeus",
                },
                atmReservationTimeoutSeconds = {
                    description = "Enimmäissekunnit, jotka varataan, kun pelaaja asentaa hihnan tai latauksen; pidetään automaattisesti pidempänä kuin toiminnon kesto.",
                    label = "Valmistelun varausaikakatko",
                },
                atmRewardAccount = {
                    description = "Valitse käteinen tai black_money-esine.",
                    label = "Pankkiautomaatin maksutapa",
                },
                atmRewardMaximum = {
                    description = "Korkein käteismaksu yhdestä pankkiautomaatista; ei koskaan pienempi kuin minimi.",
                    label = "Maksimipalkkio",
                },
                atmRewardMinimum = {
                    description = "Alin käteismaksu yhdestä ATM:stä.",
                    label = "Minimipalkkio",
                },
                atmSlingDurationSeconds = {
                    description = "Kääreen kiinnittämiseen tarvittavat sekunnit.",
                    label = "Kääreen kiinnityksen kesto",
                },
                atmSlingItem = {
                    description = "Uudelleenkäytettävä inventaari-esine ajoneuvomenetelmää varten.",
                    label = "Sling-esine",
                },
                atmSlingItemAmount = {
                    description = "Tarvittavien kääreiden määrä. Niitä ei kuluteta.",
                    label = "Vaadittu kääreiden määrä",
                },
                atmTestScanDistance = {
                    description = "Maksimietäisyys, jolla /atmtest etsii tuettua pankkiautomaattitavaraa.",
                    label = "Pankkiautomaatin testiskannauksen etäisyys",
                },
                atmVehicleMaxDistance = {
                    description = "ATM:n ja soveltuvan ajoneuvon välinen enimmäisetäisyys, kun kiinnitetään vaijeri.",
                    label = "Ajoneuvon kiinnitysetäisyys",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Jokaisen varaston murtamisyrityksen aikaraja (sekunteina).",
                    label = "Murtautumisen aikaraja (sekunnit)",
                },
                baseRaid_command = {
                    description = "Komento ilman vinoviivaa. Käynnistä crime-resurssi uudelleen muutoksen jälkeen.",
                    label = "Ryöstymiskomento",
                },
                baseRaid_crimeItem = {
                    description = "Jengin murtoesine.",
                    label = "Jengin murtoesine",
                },
                baseRaid_crimeVehicles = {
                    description = "Jengin ajoneuvojen käyttöoikeus.",
                    label = "Jengin ajoneuvojen käyttöoikeus",
                },
                baseRaid_difficulty = {
                    description = "Skillcheck-vaikeustaso.",
                    label = "Skillcheck-vaikeustaso",
                    options = {
                        easy = "Helppo",
                        expert = "Asiantuntija",
                        hard = "Vaikea",
                        normal = "Normaali",
                    },
                },
                baseRaid_enabled = {
                    description = "Ota tukikohdatutkimukset (Base raids) käyttöön.",
                    label = "Ota tukikohdatutkimukset (Base raids) käyttöön",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Odotusaika, kun ratsia päättyy avaamatta yhtään varastoa (minuutteina).",
                    label = "Jälleenlatausaika epäonnistumisen jälkeen (minuuttia)",
                },
                baseRaid_interactionDistance = {
                    description = "Varaston vuorovaikutusetäisyys.",
                    label = "Varaston vuorovaikutusetäisyys",
                },
                baseRaid_lootHeistStorage = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Ryöstisaaliin varasto",
                },
                baseRaid_lootLaboratories = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Loot-laboratorion varasto",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Lootaa henkilökohtaiset säilytyslokerot",
                },
                baseRaid_lootStorage = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Loot-varasto",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Lootaa hansikaslokerot",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Salli tämän varastoluokan täydellinen tyhjentäminen aktiivisen ryöstön aikana.",
                    label = "Lootaa ajoneuvojen tavaratilat",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimimäärä paikalla olevia puolustajia.",
                    label = "Minimimäärä paikalla olevia puolustajia",
                },
                baseRaid_policeItem = {
                    description = "Poliisin murtaustuote.",
                    label = "Poliisin murtoesine",
                },
                baseRaid_policeRequireDuty = {
                    description = "Poliisin on oltava palveluksessa.",
                    label = "Poliisin on oltava palveluksessa",
                },
                baseRaid_policeVehicles = {
                    description = "Poliisikäyttöoikeus.",
                    label = "Poliisikäyttöoikeus",
                },
                baseRaid_protectionHours = {
                    description = "Suoja onnistumisen jälkeen (tunnit).",
                    label = "Suoja onnistumisen jälkeen (tunnit)",
                },
                baseRaid_requiredHits = {
                    description = "Vaadittavat skillcheck-osumat.",
                    label = "Vaadittavat skillcheck-osumat",
                },
                baseRaid_warrantItem = {
                    description = "Yhtä näistä tuotteista kulutetaan jokaisen voimassa olevan poliisin ratsian alkaessa.",
                    label = "Etsintämääräys-tuote",
                },
                crimeMembershipMode = {
                    description = "Framework-tila säilyttää olemassa olevan työn tai natiivin jengiyhteyden. Itsenäinen tila pyörittää rikollisorganisaatiota taustalla pelaajan normaalin työn rinnalla ja siirtää olemassa olevat jäsenyydet automaattisesti.",
                    label = "Organisaation jäsenyysmalli",
                    options = {
                        framework = "Framework-työ / jengi",
                        independent = "Itsenäinen organisaatio",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Identiteetin vähimmäisikä ennen kuin se voidaan poistaa käytöstä uudelleen.",
                    label = "Aliaksen vaihtoväli (tuntia)",
                },
                darknetCurrencyCode = {
                    description = "Lyhyt tunniste sisäiselle kryptovaluuttatilille.",
                    label = "Valuuttakoodi",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Etäisyys, joka vaaditaan laatikon tutkimiseen ja lunastamiseen.",
                    label = "Dead-drop-vuorovaikutusetäisyys",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Aika, jonka jälkeen lunastamaton laatikko vanhenee.",
                    label = "Dead-drop-kesto (tuntia)",
                },
                darknetDeadDropModel = {
                    description = "GTA-prop-malli, joka luodaan paikallisesti saatavilla olevia dead droppeja varten.",
                    label = "Dead-drop-laatikon malli",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Väli, jota käytetään lähellä olevien laatikoiden ja NPC-tapaamisten päivittämiseen.",
                    label = "Maailman päivitysväli (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Etäisyys, jolla laatikot ja NPC-tapaamiskontaktit ladataan.",
                    label = "Dead-drop-latausetäisyys",
                },
                darknetDropLocations = {
                    description = "Sijainnit, jotka määritetään satunnaisesti NPC-dead-drop-kauppoihin. Määritä vähintään kaksi.",
                    itemLabel = "Dead-drop-sijainti",
                    label = "Dead-drop-sijainnit",
                },
                darknetEnabled = {
                    description = "Aktivoi mustan pörssin tablettisovellus ja sen taustaprosessi.",
                    label = "Ota Darknet-markkinat käyttöön",
                },
                darknetExchangeBuyPrice = {
                    description = "Määrä, joka veloitetaan maksutililtä yhdestä kolikosta.",
                    label = "Ostopreki per kolikko",
                },
                darknetExchangeEnabled = {
                    description = "Sallii tunnistautuneiden BlackBay-käyttäjien ostaa ja myydä kolikoita omalla tilisivullaan.",
                    label = "Ota kolikoiden vaihto käyttöön",
                },
                darknetExchangeMaximumAmount = {
                    description = "Suurin hyväksytty kokonaiskolikoiden määrä yhdessä vaihdossa.",
                    label = "Maksimi-kolikot per vaihto",
                },
                darknetExchangeMinimumAmount = {
                    description = "Pienin hyväksytty kokonaiskolikoiden määrä yhdessä vaihdossa.",
                    label = "Minimi-kolikot per vaihto",
                },
                darknetExchangePaymentAccount = {
                    description = "Framework-tili, jota käytetään kolikoiden ostoihin ja myyntien maksuihin.",
                    label = "Kolikoiden vaihdon maksutili",
                    options = {
                        bank = "Pankki",
                        black_money = "Likainen raha",
                        money = "Käteinen",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Yhdelle kolikolle maksun tilille maksettava summa.",
                    label = "Myyntihinta per kolikko",
                },
                darknetFaceToFaceDistance = {
                    description = "Maksimietäisyys molempien pelaajien tai konfiguroidun NPC-pisteen välillä.",
                    label = "Luovutusetäisyys",
                },
                darknetKnownScammerReports = {
                    description = "Ainutlaatuiset kauppailmoitukset tunnetun huijarin merkin saamiseksi.",
                    label = "Ilmoitukset huijarivaroitusta varten",
                },
                darknetListingExpiryHours = {
                    description = "Aktiiviset tarjoukset vanhenevat automaattisesti näiden tuntien jälkeen.",
                    label = "Tarjouksen voimassaolo (tuntia)",
                },
                darknetMaximumListingQuantity = {
                    description = "Yläraja yhden tarjouksen tavaramäärälle.",
                    label = "Tavaroiden enimmäismäärä",
                },
                darknetMaximumListings = {
                    description = "Maksimimäärä tarjouksia per aktiivinen alias.",
                    label = "Maksimimäärä aktiivisia tarjouksia",
                },
                darknetMaximumMessageLength = {
                    description = "Maksimimerkkimäärä salattuun chatviestiin.",
                    label = "Maksimi viestin pituus",
                },
                darknetMaximumUnitPrice = {
                    description = "Yläraja kryptohinnalle per yksikkö.",
                    label = "Maksimiyksikköhinta",
                },
                darknetMeetingLocations = {
                    description = "Paikat, jotka on määritetty satunnaisesti NPC-kasvokkaisiin kaupankäynteihin. Määritä vähintään kaksi.",
                    itemLabel = "Tapaamispaikka",
                    label = "Tapaamispaikat",
                },
                darknetNpcBuyerAliases = {
                    description = "Fiktiiviset nimet, jotka jaetaan satunnaisesti uusille NPC-ostopyynnöille. Määritä vähintään kaksi yksilöllistä nimimerkkiä.",
                    label = "NPC-ostajien nimimerkit",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Yläraja, jota käytetään satunnaisesti valittaessa, kuinka monta NPC-ostopyyntöä on aktiivisena.",
                    label = "Enimmäismäärä NPC-ostopyyntöjä",
                },
                darknetNpcMaximumSellListings = {
                    description = "Yläraja, jota käytetään satunnaisesti valittaessa, kuinka monta NPC-myynti-ilmoitusta on aktiivisia.",
                    label = "Enimmäismäärä NPC-myynti-ilmoituksia",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Kun NPC-markkinat täydennetään, vähintään tämän verran satunnaisesti valittuja ostopyyntöjä pysyy aktiivisena.",
                    label = "Minimimäärä NPC-ostopyyntöjä",
                },
                darknetNpcMinimumSellListings = {
                    description = "Kun NPC-markkinat täydennetään, vähintään tämän verran satunnaisesti valittuja myyntitarjouksia pysyy aktiivisena.",
                    label = "Minimimäärä NPC-myyntitarjouksia",
                },
                darknetNpcSellerAliases = {
                    description = "Fiktiiviset nimet, jotka määritetään satunnaisesti uusille NPC-myynti-ilmoituksille. Määritä vähintään kaksi uniikkia nimimerkkiä.",
                    label = "NPC-myyjien nimimerkit",
                },
                darknetNpcTraders = {
                    description = "Konfiguroi synteettiset tarjoukset, toimitustapa, maine ja huijausprosentti.",
                    label = "NPC-ostajat ja -myyjät",
                },
                darknetPoliceGroups = {
                    description = "Ryhmäavaimet, joilla voi julkaista houkutuskohteita ja tarkastella tutkimuksia.",
                    label = "Valtuutetut poliisiryhmät",
                },
                darknetRenewalHours = {
                    description = "Lisätunnit, kun omistaja uudistaa tarjouksen.",
                    label = "Uudistuksen kesto (tuntia)",
                },
                darknetScamChance = {
                    description = "Minimimahdollisuus, että NPC-kauppa ottaa maksun tai tavarat toimittamatta vastinetta. Korkeampi kauppakohtainen todennäköisyys on edelleen voimassa.",
                    label = "Globaali NPC-huijausmahdollisuus (%)",
                },
                darknetStarterBalance = {
                    description = "Krypto myönnetään vain, kun pelaaja avaa markkinat ensimmäistä kertaa.",
                    label = "Uuden lompakon saldo",
                },
                darknetTabletOrder = {
                    description = "Määrittää Darknet-markkinoiden sijainnin tabletilla.",
                    label = "Tablettisovelluksen järjestys",
                },
                darknetVerifiedMinimumRating = {
                    description = "Minimiarvosana vahvistetulle myyjälle.",
                    label = "Vahvistamiseen vaadittu luokitus",
                },
                darknetVerifiedMinimumSales = {
                    description = "Tarvittavat onnistuneet myynnit, ennen kuin myyjä voi tulla vahvistetuksi.",
                    label = "Vahvistamiseen vaadittavat myynnit",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Tili, jota käytetään, kun maksutavaksi on asetettu pelaajan tili. Organisaation maksut käyttävät aina Boss Menu -tiliä.",
                    label = "Pelaajan pankkitili",
                    options = {
                        bank = "Pankki",
                        black_money = "Likainen raha",
                        money = "Käteinen",
                    },
                    requiresWarning = "Käytetään vain pelaajan pankkitilin maksutapana.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Käytä joko ostavan pelaajan saldoa tai organisaation Boss Menu -tiliä.",
                    label = "Maksutapa",
                    options = {
                        player = "Pelaajan tili",
                        society = "Organisaation tili",
                    },
                },
                drugCamperLockKey = {
                    description = "Asettaa oletusnäppäimen omien tai factionin yhteisten asuntovaunujen lukitsemiseen ja avaamiseen. Pelaajat voivat muuttaa tämän FiveM-näppäinkuvauksissaan.",
                    label = "Asuntovaunun lukon oletusnäppäin",
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
                    description = "Lisää oletuksena laatu- ja erätiedot keräilytuotosten metatietoihin. Poista tämä käytöstä, jotta raaka-aineet voivat pinoutua normaalisti.",
                    label = "Keräilyesineen metatiedot",
                },
                drugLabAssaultAlertDuration = {
                    description = "Sekunnit, jonka ajan puolustajan hälytysalue pysyy näkyvissä kartalla.",
                    label = "Puolustajan hälytyksen kesto",
                },
                drugLabAssaultAlertRadius = {
                    description = "Hyökkäysalueen säde, joka näytetään puolustavalle factionille kartalla.",
                    label = "Puolustajan hälytyssäde",
                },
                drugLabAssaultBreachRadius = {
                    description = "Säde, jonka sisällä hyökkääjän on pysyttävä avatessaan sisäänkäynnin.",
                    label = "Murtovaiheen säde",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Sekunnit, jotka hyökkääjien on pidettävä sisäänkäynti hallussaan valtaamaan laboratorio tai asuntovaunu.",
                    label = "Valtauksen kesto",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Sisäänkäynnin alue, jolla lasketaan hyökkääjät ja vastustavat puolustajat.",
                    label = "Valtaussäde",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Sekunnit, jotka sisäänkäynnin järjestelmän hakkerointi vaatii.",
                    label = "Elektronisen murron kesto",
                },
                drugLabAssaultEnabled = {
                    description = "Sallii ryhmien murtautua ja vallata vastustajien laboratorioita sekä ryhmille yhteisiä leirialueita.",
                    label = "Ota käyttöön laboratorion ja leirialueen valtaus",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Sekunnit, jotka tarvitaan sisäänkäynnin murtaamiseen räjähdeaineella.",
                    label = "Räjähdysmurron kesto",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Maksimietäisyys laboratorion tai leirialueen sisäänkäynnistä hyökkäystä aloitettaessa.",
                    label = "Sisäänkäynnin vuorovaikutusetäisyys",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Sekunnit, jotka sisäänkäynnin lukon poraaminen vaatii.",
                    label = "Mekaanisen murron kesto",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Puolustavan factionin jäsenten on oltava onlineina ennen kuin hyökkäys voi alkaa.",
                    label = "Minimipuolustajat",
                },
                drugLabAssaultRequireDuty = {
                    description = "Laskee vain puolustavan ryhmän jäsenet, jotka ovat parhaillaan palveluksessa.",
                    label = "Laske vain palveluksessa olevat puolustajat",
                },
                drugProcessingInventoryMetadata = {
                    description = "Lisää prosessointituloksiin oletusarvoisesti laatu- ja erätiedot. Yksittäiset reseptit voivat ylikirjoittaa tämän asetuksen.",
                    label = "Prosessointi-itemien metatiedot",
                },
                graffitiItemName = {
                    description = "Inventaariotavara, jota tarvitaan sprayaamisen aloittamiseen, kun tavaravaatimus on käytössä. Tavaran on oltava aktiivisessa inventaariossa.",
                    label = "Vaadittu graffititavara",
                },
                heistCooldownMinutes = {
                    description = "Estää saman heistin suorituksen jälkeen, kun todelliset vuorovaikutukset on päättynyt ja siivous tehty. Nolla poistaa viiveen käytöstä. Käyttämätön aloitusikkuna ei laukaise sitä.",
                    label = "Heistin viiveaika (minuuttia)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Viiden sekunnin edistymispalkki. Tarvittavat ainekset kulutetaan onnistumisen yhteydessä.",
                        medium = "Valitse ainekset näytetyssä järjestyksessä ja läpäise yksi ajoitustesti ainesosaa kohti.",
                        advanced = "Täysi laitteen kokoaminen resepteille, joilla on laiteprofiili; muille kaksi tarkkaa ajoitustestiä ainesosaa kohti.",
                    },
                    description = "Yksinkertainen: viiden sekunnin edistymispalkki. Keskitaso: ainesosien valinta ja ajoitusmittaukset. Maksimi: täysi laitteen kokoaminen; reseptit ilman laiteprofiilia käyttävät kaksi tarkkaa ajoitusmittausta per ainesosa.",
                    label = "Crafting-vaikeustaso",
                    options = {
                        advanced = "Maksimaalinen vaikeusaste",
                        medium = "Keskitason vaikeusaste",
                        simple = "Yksinkertainen",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Ensimmäisen vuorovaikutuksen jälkeen jokainen uusi heist-toiminto nollaa tämän ajastimen. Aikajakson päättyminen lopettaa runin ja poistaa sen maailmaobjektit. Koskee uusia runsia.",
                    label = "Heist-inaktiivisuusraja (minuuttia)",
                },
                heistStartTimeoutMinutes = {
                    description = "Aika Start-painikkeen painamisen jälkeen kohteessa vuorovaikutukseen. Ilman vuorovaikutusta suoritus nollautuu ja sen voi aloittaa uudelleen. Koskee uusia suorituksia.",
                    label = "Minuutit ensimmäiseen heist-vuorovaikutukseen",
                },
                moneywashAccount = {
                    options = {
                        bank = "Pankki",
                        black_money = "Likainen raha",
                        money = "Käteinen",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Tili, jolta pelaajan likainen raha poistetaan, kun pesuprosessi alkaa.",
                    label = "Talletustili",
                },
                moneywashDrawDistance = {
                    description = "Maksimietäisyys metreinä, jolla yritysten sisäänkäynnit ja kaupat näytetään.",
                    label = "Näkyvyysetäisyys",
                },
                moneywashEnabled = {
                    description = "Tekee organisaation omista rahanpesuyrityksistä käytettäviä.",
                    label = "Ota käyttöön rahanpesu",
                },
                moneywashFeePercent = {
                    description = "Prosenttiosuus, joka vähennetään jokaisesta erästä ennen maksun suorittamista organisaatiolle.",
                    label = "Palvelumaksu (%)",
                },
                moneywashInteractionDistance = {
                    description = "Maksimietäisyys metreinä yritysten sisäänkäyntien ja kauppojen käyttöön.",
                    label = "Vuorovaikutusetäisyys",
                },
                npcPoliceAccuracy = {
                    description = "NPC-poliisien tarkkuus välillä 0 - 100.",
                    label = "Aukkotarkkuus",
                },
                npcPoliceArmour = {
                    description = "Jokaisen NPC-poliisioikeuden panssarimäärä välillä 0–100.",
                    label = "Suojaliivi",
                },
                npcPoliceAtms = {
                    description = "Lähetetään NPC-poliisiapua, kun pankkiautomaattiryöstön hälytys laukeaa.",
                    label = "Poliisi-NPC-tuki pankkiautomaattiryöstöissä",
                },
                npcPoliceDurationSeconds = {
                    description = "Enimmäisaika, jonka NPC-poliisit pysyvät operaatiossa syntymisensä jälkeen (30–900 sekuntia).",
                    label = "Operaation kesto (sekunnit)",
                },
                npcPoliceEnabled = {
                    description = "Lähetetään aseistetut NPC-poliisit, kun ryöstöhälytys laukeaa. Poistettu käytöstä oletuksena.",
                    label = "Ota käyttöön NPC-poliisituki",
                },
                npcPoliceHeists = {
                    description = "Lähetä NPC-poliisiapua, kun ryöstöhälytys laukeaa.",
                    label = "Tuki ryöstöjen aikana",
                },
                npcPoliceOfficerCount = {
                    description = "Kuinka monta aseistettua NPC-poliisia lähetetään per ryöstöhälytys (1–8).",
                    label = "Poliiseja per hälytys",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Aika ryöstöhälytyksen ja NPC-poliisien saapumisen välillä (0–300 sekuntia).",
                    label = "Vasteaika (sekunnit)",
                },
                npcPoliceShops = {
                    description = "Lähetä NPC-poliisituki, kun kaupparyöstön hälytys laukeaa.",
                    label = "Tuki kaupparyöstöihin",
                },
                npcPoliceSpawnDistance = {
                    description = "Etäisyys ryöstöpaikasta, jolla NPC-poliisit spawnaavat (15–150 metriä).",
                    label = "Spawn-etäisyys (metriä)",
                },
                npcPoliceWeapon = {
                    description = "Ase, joka on jokaisella paikalle saapuvalla NPC-poliisilla. Oletusarvo on pistooli.",
                    label = "Palvelusase",
                    options = {
                        WEAPON_CARBINERIFLE = "Carbine-kivääri",
                        WEAPON_PISTOL = "Pistooli",
                        WEAPON_PUMPSHOTGUN = "Pumppuhaulikka",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Avaa Heist-luoja",
                    description = "Avaa Heist Creator ja sulje Job Configurator.",
                    label = "Heist-luoja",
                    unsavedTooltip = "Tallenna muutokset ensin",
                },
                pickpocketAggressionChance = {
                    description = "Itsenäinen mahdollisuus, että NPC hyökkää epäonnistuneen, peruutetun tai vanhentuneen yrityksen jälkeen.",
                    label = "Vastahyökkäysmahdollisuus (%)",
                },
                pickpocketAlertChance = {
                    description = "Itsenäinen mahdollisuus, että NPC ilmoittaa epäonnistuneesta, peruutetusta tai vanhentuneesta yrityksestä.",
                    label = "Hälytysmahdollisuus (%)",
                },
                pickpocketDifficulty = {
                    description = "Säätelee kohdistimen nopeutta, kohteen pienenemista, sarjan pituutta ja sallittuja virheitä.",
                    label = "Vaikeus",
                    options = {
                        easy = "Helppo",
                        expert = "Asiantuntija",
                        hard = "Vaikea",
                        normal = "Normaali",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Ilmoita jokaisesta aloitetusta taskuvarkausyrityksestä kerran, myös onnistuneesta, hätäpuhelun todennäköisyydestä riippumatta.",
                    label = "Lähetä aina hälytys",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Sekunnit, joiden ajan raportti on relevantti hälytyskeskuksen vastaanottajille.",
                    label = "Hälytyksen kesto",
                },
                pickpocketDispatchJobs = {
                    description = "Pilkuilla erotetut ammattinimikkeet, jotka vastaanottavat hätäpuhelut.",
                    label = "Hälytysammattit:**",
                },
                pickpocketDispatchPriority = {
                    description = "Prioriteetti, joka välitetään muuttumattomana hälytysintegraatioon.",
                    label = "Hälytysprioriteetti",
                },
                pickpocketDispatchRadius = {
                    description = "Hälytyssäde, joka lähetetään hälytysintegraatioon.",
                    label = "Hälytyssäde",
                },
                pickpocketEmptyChance = {
                    description = "Mahdollisuus, että NPC:llä ei ole lainkaan valittavissa olevaa lootia.",
                    label = "Tyhjät taskut -mahdollisuus (%)",
                },
                pickpocketEnabled = {
                    description = "Sallii pelaajien yrittää taskuvarkautta kelvollisilta, satunnaisilta ja synkronoiduilta NPC-hahmoilta.",
                    label = "Ota käyttöön NPC-taskuvarkaudet",
                },
                pickpocketFleeChance = {
                    description = "Itsenäinen mahdollisuus, että NPC pakenee epäonnistuneen, peruutetun tai vanhentuneen yrityksen jälkeen.",
                    label = "NPC:n pakenemismahdollisuus (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Maksimiklientin kantama; palvelin validoi sen pienellä synkronointivälillä.",
                    label = "Vuorovaikutusetäisyys",
                },
                pickpocketItems = {
                    description = "Jokainen rivi määrittää sen esiintymistodennäköisyyden. Neljä desimaalia tukee arvoa 0.0001 prosenttia.",
                    itemLabel = "Esine mahdollisuus",
                    label = "Saalis",
                },
                pickpocketItemsEnabled = {
                    description = "Lisää konfiguroidut esineet myös näkyviin taskun sisältöön.",
                    label = "Ota käyttöön esineiden ryöstö",
                },
                pickpocketMaximumLootChoices = {
                    description = "Palvelinpuolen luomien käteinen- tai esine-pistokkeiden enimmäismäärä yhdelle NPC:lle.",
                    label = "Maksimimäärä näkyvää saalista",
                },
                pickpocketMinigame = {
                    description = "Valitse yksi haaste tai pyöritä satunnaisesti kaikkien kolmen välillä.",
                    label = "Minipeli",
                    options = {
                        pulse = "Paineaalto",
                        random = "Satunnainen rotaatio",
                        sequence = "Suuntajärjestys",
                        timing = "Ajoituspalkki",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Korkein näkyvä käteismäärä; pidetään automaattisesti vähintään minimitasolla.",
                    label = "Maksimikäteinen",
                },
                pickpocketMoneyMinimum = {
                    description = "Alin palvelinpuolen luoma määrä näkyvälle käteispistokkeelle.",
                    label = "Minimikäteinen",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Minimisekunnit yhden pelaajan aloituspyyntöjen välillä.",
                    label = "Pyynnön viive",
                },
                pickpocketRequireCrimeJob = {
                    description = "Auki: lisää toiminto vain rekisteröidyille Crime System -työille. Pois: poistaa sisäänrakennetun sädevalikkotoiminnon ja vaatii palvelin-exportin.",
                    label = "Käytä Crime-työn sädevalikkoa",
                },
                pickpocketRequiredHits = {
                    description = "Perusarvo kaikille minipeleille. Arvokas käteinen nostaa arvoa vaiheittain; erittäin harvinaiset esineet vaativat vähintään kahdeksan osumaa.",
                    label = "Minimimäärä osumia",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Sekunnit ennen kuin keskeneräinen palvelinhaaste vanhenee.",
                    label = "Istunnon aikakatkaisu",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Lukitus peruutettujen tai epäonnistuneiden yritysten jälkeen; onnistuneesti tyhjennetyt NPC:t pysyvät poissa käytöstä.",
                    label = "NPC-viive",
                },
                pvpAdminAce = {
                    description = "ACE-objekti, joka antaa pääsyn globaaliin PvP-tapahtumien hallintaan.",
                    label = "Ylläpitäjän ACE-oikeus",
                },
                pvpArenaReturnSeconds = {
                    description = "Oletuspaluuaika uusille tapahtumille. Tapahtumajohtajat voivat muuttaa sitä tabletilta.",
                    label = "Arena-paluuaika",
                },
                pvpArenaWarningPosition = {
                    description = "Määrittää, missä arenaan palaamista koskeva varoitus näytetään.",
                    label = "Arena-varoituspaikka",
                    options = {
                        bottom_center = "Alakeskellä",
                        bottom_left = "Vasen alakulma",
                        bottom_right = "Oikea alakulma",
                        middle_center = "Näytön keskellä",
                        middle_left = "Vasen keskikohta",
                        middle_right = "Oikea keskikohta",
                        top_center = "Yläkeskellä",
                        top_left = "Vasen yläkulma",
                        top_right = "Oikea yläkulma",
                    },
                },
                pvpArenas = {
                    description = "Luo pyöreitä taistelualueita, joissa on tarkkailupiste ja vähintään kaksi tiimin spawn-pistettä.",
                    itemLabel = "Areena",
                    label = "PvP-areenat",
                },
                pvpCountdownPosition = {
                    description = "Määrittää, missä ottelun alkulaskuri näkyy.",
                    label = "Laskurin sijainti",
                    options = {
                        bottom_center = "Alakeskellä",
                        bottom_left = "Vasen alakulma",
                        bottom_right = "Oikea alakulma",
                        middle_center = "Näytön keskellä",
                        middle_left = "Vasen keskikohta",
                        middle_right = "Oikea keskikohta",
                        top_center = "Yläkeskellä",
                        top_left = "Vasen yläkulma",
                        top_right = "Oikea yläkulma",
                    },
                },
                pvpDefaultMode = {
                    description = "Uusille tapahtumille esivalittu pelimuoto.",
                    label = "Oletuspelimuoto",
                    options = {
                        free_for_all = "Jokainen vastaan kaikki",
                        last_man_standing = "Viimeinen selviytyjä",
                        team_deathmatch = "Joukkueiden väliset taistelut",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Oletusmäärä tappoja, jotka vaaditaan Team Deathmatchin tai Free For Allin voittamiseen.",
                    label = "Oletusarvoinen tappokohde",
                },
                pvpEventsEnabled = {
                    description = "Aktivoi faction-PvP-tabletti-sovellus ja tapahtumien ajonaikainen logiikka.",
                    label = "Ota käyttöön faction-PvP-tapahtumat",
                },
                pvpKillfeedPosition = {
                    description = "Määrittää, missä viimeisimmät eliminoinnit näytetään.",
                    label = "Killfeed-sijainti",
                    options = {
                        bottom_center = "Alakeskellä",
                        bottom_left = "Vasen alakulma",
                        bottom_right = "Oikea alakulma",
                        middle_center = "Näytön keskellä",
                        middle_left = "Vasen keskikohta",
                        middle_right = "Oikea keskikohta",
                        top_center = "Yläkeskellä",
                        top_left = "Vasen yläkulma",
                        top_right = "Oikea yläkulma",
                    },
                },
                pvpLeaderPermission = {
                    description = "Työtehtäväkohtaiset oikeudet ryhmätapahtumien luomiseen, rekisteröimiseen, aloittamiseen ja hallinnointiin.",
                    label = "Ryhmän johtajan oikeudet",
                },
                pvpMatchDurationMinutes = {
                    description = "Oletuskesto minuutteina uusille tapahtumille. Nolla poistaa aikarajan.",
                    label = "Ottelun kesto",
                },
                pvpMaxHistory = {
                    description = "Tabletille palautettavien päättyneiden tai peruttujen tapahtumien enimmäismäärä.",
                    label = "Näkyvä tapahtumahistoria",
                },
                pvpMaxRewards = {
                    description = "Yhdistettyjen esine-, ase-, ajoneuvo- tai rahapalkkioiden enimmäismäärä per tapahtuma.",
                    label = "Enimmäismäärä lisäpalkkioita",
                },
                pvpMoneyPermission = {
                    description = "Työtehtäväkohtaiset oikeudet sisäänpääsymaksuja ja palkintorahoja varten.",
                    label = "Ryhmän talousoikeudet",
                },
                pvpRequestCooldownMs = {
                    description = "Minimimillisekunnit yhden pelaajan PvP-pyyntöjen välillä.",
                    label = "Toiminnon viive",
                },
                pvpRespawnDelaySeconds = {
                    description = "Sekunnit ennen kuin pelaaja respawnaa tai siirtyy tarkkailualueelle kuoleman jälkeen.",
                    label = "Respawn-viive",
                },
                pvpSchedulePollSeconds = {
                    description = "Sekunnit toistuvien mallien ja automaattisten aloitusten tarkistusten välillä.",
                    label = "Aikataulun tarkistusväli",
                },
                pvpScoreboardPosition = {
                    description = "Määrittää, missä kompakti live-tulostaulukko näkyy ryhmäotteluiden aikana.",
                    label = "Tulostaulukon sijainti",
                    options = {
                        bottom_center = "Alakeskellä",
                        bottom_left = "Vasen alakulma",
                        bottom_right = "Oikea alakulma",
                        middle_center = "Näytön keskellä",
                        middle_left = "Vasen keskikohta",
                        middle_right = "Oikea keskikohta",
                        top_center = "Yläkeskellä",
                        top_left = "Vasen yläkulma",
                        top_right = "Oikea yläkulma",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Sallii PvP-ylläpitäjien rekisteröitymisen ja manuaalisen aloituksen yhden ryhmän jäsenen kanssa. Poista käytöstä tuotantopalvelimilla.",
                    label = "Ota käyttöön ylläpitäjän yksittäistesti",
                },
                pvpStartCountdownSeconds = {
                    description = "Oletuslaskuri uusille tapahtumille. Tapahtuman johtaja voi ylikirjoittaa sen tabletilla.",
                    label = "Aloituslaskuri",
                },
                pvpTabletOrder = {
                    description = "Määrittää, missä faction-PvP-sovellus näkyy tabletilla.",
                    label = "Tablettisovelluksen järjestys",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minuutit, ennen kuin hylätty ryöstö epäonnistuu.",
                    label = "Aktiivisuuden aikakatkaisu",
                },
                shopConsumeDrill = {
                    description = "Kuluta pora onnistuneen avaamisen jälkeen.",
                    label = "Kuluta pora",
                },
                shopConsumeHackItem = {
                    description = "Käytä hakkerointiesinettä sen jälkeen, kun kassakaappi on avattu onnistuneesti.",
                    label = "Käytä hakkerointiesinettä",
                },
                shopCooldownMinutes = {
                    description = "Minuutit ennen kaupan nollautumista (vain ajon aikana).",
                    label = "Kaupan jäähdytysaika",
                },
                shopDispatchAlways = {
                    description = "Ilmoita jokaisesta kaupparyöstöstä kerran sen alkaessa, myös keskeytymättömässä uhkailussa ja kaupoissa, joissa myyjää ei vaadita.",
                    label = "Lähetä aina hälytys",
                },
                shopDispatchDurationSeconds = {
                    description = "Sekunnit, jonka ajan hälytys pysyy voimassa.",
                    label = "Hälytyksen kesto",
                },
                shopDispatchJobs = {
                    description = "Hälytyksen vastaanottajien työt (eroteltuna pilkulla).",
                    label = "Hälytysammattit:**",
                },
                shopDispatchPriority = {
                    description = "Prioriteetti, joka välitetään hälytykseen.",
                    label = "Hälytysprioriteetti",
                },
                shopDispatchRadius = {
                    description = "Arvioitu poliisin hälytyssäde.",
                    label = "Hälytyssäde",
                },
                shopDrillDurationSeconds = {
                    description = "Sekunnit, jotka tarvitaan kassakaapin poraamiseen.",
                    label = "Kassakaapin porauskesto",
                },
                shopDrillItem = {
                    description = "Inventaarioesineen tunnus, joka tarvitaan kauppojen kassakaappien poraamiseen. Eri asetus kuin pankkiautomaatin pora.",
                    label = "Pora-tuote",
                },
                shopDrillItemAmount = {
                    description = "Tarvittavien poraustavarakappaleiden määrä.",
                    label = "Vaadittu porausmäärä",
                },
                shopEnabled = {
                    description = "Mahdollistaa ryöstöt konfiguroiduissa myymälöissä, joissa on henkilökuntaa.",
                    label = "Ota kaupparyöstöt käyttöön",
                },
                shopHackItem = {
                    description = "Tarvittava esine kassakaapin hakkerointiminipeliin. Ota avausmenetelmä käyttöön erikseen jokaiselle kaupalle.",
                    label = "Hakkerointiesine",
                },
                shopHackItemAmount = {
                    description = "Hakkeroitavan esineen vaadittu määrä.",
                    label = "Hakkeroitavan esineen määrä",
                },
                shopIntimidationSeconds = {
                    description = "Sekunnit, joiden ajan myyjän on pysyttävä aseella uhkauspisteessä.",
                    label = "Pelottelun kesto",
                },
                shopLocations = {
                    description = "Yksi myyjä, yksi kassa ja valinnainen kassakaappi jokaiseen kauppaan.",
                    itemLabel = "Kauppa",
                    label = "Kauppojen sijainnit",
                },
                shopMinimumPolice = {
                    description = "Palveluksessa olevien poliisiryhmän jäsenten määrä, joka vaaditaan aloittamiseen.",
                    label = "Minimipoliisit",
                },
                shopPoliceGroup = {
                    description = "Poliisivaatimukseen laskettava työtehtäväryhmä.",
                    label = "Poliisiryhmä",
                },
                shopRegisterDurationSeconds = {
                    description = "Sekunnit, jotka kassan tyhjentäminen vaatii.",
                    label = "Kassan lootauksen kesto",
                },
                shopRegisterRewardMaximum = {
                    description = "Korkein kassamaksu.",
                    label = "Kassan enimmäispalkkio",
                },
                shopRegisterRewardMinimum = {
                    description = "Alin kassapalkkio.",
                    label = "Minimi-kassapalkkio",
                },
                shopRegisterRewardName = {
                    description = "Valinnainen esineen tai tilin nimi.",
                    label = "Kassan palkkion nimi",
                },
                shopRegisterRewardSort = {
                    description = "Valitse käteinen tai black_money-esine.",
                    label = "Kassan maksutapa",
                },
                shopRegisters = {
                    description = "Kaupan ID:n perusteella määritetyt kassapaikat.",
                    itemLabel = "Kassa",
                    label = "Kassat",
                },
                shopSafeLootDurationSeconds = {
                    description = "Sekunnit, jotka vaaditaan käteisen ottamiseen oikean koodin syöttämisen jälkeen.",
                    label = "Kassakaapin ryöstöaika",
                },
                shopSafeRewardMaximum = {
                    description = "Korkein kassapalkkio.",
                    label = "Maksimissaan turvallinen palkkio",
                },
                shopSafeRewardMinimum = {
                    description = "Alin kassapalkkio.",
                    label = "Minimissään turvallinen palkkio",
                },
                shopSafeRewardName = {
                    description = "Valinnainen esineen tai tilin nimi.",
                    label = "Kassakaapin palkkion nimi",
                },
                shopSafeRewardSort = {
                    description = "Valitse käteinen tai black_money-esine.",
                    label = "Kassakaapin maksutapa",
                },
                shopThreatGraceSeconds = {
                    description = "Sallittu keskeytys ennen hälytystä.",
                    label = "Tähtäyssuojatila",
                },
                territoryDrugSalesEnabled = {
                    description = "Onnistuneet katukaupat NPC:ille antavat myyjän jengille vaikutusvaltaa nykyisellä katualueella.",
                    label = "NPC-myynnit antavat territorion vaikutusvaltaa",
                },
                atmLocationMode = {
                    label = "Pankkiautomaattien sijaintitila",
                    description = "Tunnistaa tuetut maailman objektit automaattisesti tai käyttää vain käsin määritettyjä sijainteja.",
                    options = {
                        automatic = "Automaattinen",
                        manual = "Manuaalinen",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Vaadi poliiseja palveluksessa",
                    description = "Vaatii määritetyn määrän poliiseja palveluksessa ennen pankkiautomaattiryöstöä.",
                },
                openDrugCreator = {
                    label = "Huume-editori",
                    description = "Avaa Sky Crime -huume-editorin ja sulkee työmääritysten editorin.",
                    buttonLabel = "Avaa huume-editori",
                    unsavedTooltip = "Tallenna ensin",
                },
                drugCreatorRuntimeDensity = {
                    label = "Toimintapaneelin tiiviys",
                    description = "Määrittää huume-editorin toimintapaneelin tiiviyden.",
                    options = {
                        comfortable = "Väljä",
                        compact = "Kompakti",
                    },
                },
                drugCreatorListDensity = {
                    label = "Luettelon tiiviys",
                    description = "Määrittää editorin merkintäluettelon tiiviyden.",
                    options = {
                        comfortable = "Väljä",
                        compact = "Kompakti",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Näytä tyhjät toimintaluettelot",
                    description = "Näyttää toimintapaneelin osiot myös ilman tietueita.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Piilota käytöstä poistetut tietueet",
                    description = "Piilottaa käytöstä poistetut moduulitietueet huume-editorin luettelosta.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Luo tunnukset automaattisesti",
                    description = "Luo tunnukset nimistä, kun huume-editoriin lisätään uusia tietueita.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Avaa editori moduulia vaihdettaessa",
                    description = "Avaa editorin automaattisesti aktiivista moduulia vaihdettaessa.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Kopioiden automaattinen nimiliite",
                    description = "Lisää automaattisen päätteen huume-editorin merkintöjä kopioitaessa.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Esivalitse pelikohteet automaattisesti",
                    description = "Esivalitsee käytettävissä olevat laboratoriot ja erät automaattisesti.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Keskity ongelmiin avatessa",
                    description = "Avaa toimintapaneelin painottaen huomiota vaativia tietueita.",
                },
                drugActivityHudPosition = {
                    label = "Toiminto-HUDin sijainti",
                    description = "Vedä sijoitus- ja keräys-HUD haluttuun kohtaan näytöllä.",
                },
                drugInteractionHudPosition = {
                    label = "Vuorovaikutus-HUDin sijainti",
                    description = "Vedä kasvien, laboratorioiden ja asuntoautojen vuorovaikutus-HUD haluttuun kohtaan.",
                },
                drugPlantStatusHudPosition = {
                    label = "Kasvin tila-HUDin sijainti",
                    description = "Vedä kasvin yksityiskohtainen tila-HUD haluttuun kohtaan näytöllä.",
                },
                drugSystemEnabled = {
                    label = "Huumejärjestelmä",
                    description = "Ottaa käyttöön: huumeiden tuotanto, editoritiedot ja pelirajapinnat tälle rikollistyölle.",
                },
                drugCreatorAccess = {
                    label = "Huume-editorin käyttöoikeus",
                    description = "Määrittää, kuka voi avata edistyneen huume-editorin.",
                    options = {
                        permission = "Vain käyttöoikeudella",
                        job_management = "Työn hallinta",
                        owner_only = "Vain omistaja",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Pelitoimintojen rajapinnat",
                    description = "Sallii pelaajien käyttää laboratorio-, kasvi-, käsittely- ja markkinatoimintoja pelissä.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Pelaajien laboratorioiden luonti",
                    description = "Sallii järjestelmään pääsevien pelaajien luoda laboratorioita editorin malleista ilman ylläpitäjän oikeuksia.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Ulkokasvatus",
                    description = "Sallii pelaajien omat ulkoviljelmät määritettyjen laboratorioiden ulkopuolella.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Muiden pelaajien ulkosadonkorjuu",
                    description = "Sallii muiden pelaajien korjata ulkokasveja, joita he eivät itse istuttaneet.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Veloita laboratorion osto",
                    description = "Veloittaa pelaajilta määritetyn ostohinnan laboratorion luonnissa.",
                },
                drugRuntimeStrictInventory = {
                    label = "Tarkista inventaariotoiminnot tiukasti",
                    description = "Toiminnot jatkuvat vain, jos määritetyt esine-, työkalu- ja rahatoiminnot onnistuvat.",
                },
                drugRuntimeSalePayouts = {
                    label = "Myynti / Maksut",
                    description = "Maksaa pelaajille, kun eriä tai reittejä myydään markkinajärjestelmän kautta.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Maksu / Tili",
                    description = "Huumeiden myyntitulojen tili, esimerkiksi black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Lähettää / Hälytykset",
                    description = "Välittää huumeisiin liittyvät riskitapahtumat hätäkeskukselle ja määritetyille poliisitehtäville.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Poliisi / Ilmoitukset",
                    description = "Ilmoittaa määritetyille poliisitehtäville, kun huumeriskitapahtuma aiheuttaa poliisihälytyksen.",
                },
                drugBatchPrefix = {
                    label = "Erä / Etuliite",
                    description = "Uusien huume-erien tunnusten etuliite.",
                },
                drugTestingKitAccuracy = {
                    label = "Testisarja / Tarkkuus",
                    description = "Perustestipakkauksen piilotettujen arvojen sallittu vaihtelu.",
                },
                drugDecayIntervalMinutes = {
                    label = "Rakenne / Aikaväli",
                    description = "Aikaväli minuutteina: tuoreuden ja saastumisen vähenemisen tarkistukset.",
                },
                drugDefaultPackaging = {
                    label = "Oletusarvo / Pakkaus",
                    description = "Pakkaus raaoille tai käsitellyille erille, joille ei ole määritetty pakkaustyyppiä.",
                    options = {
                        loose = "Irtotavara",
                        baggy = "Pussi",
                        jar = "Purkki",
                        vacuum = "Tyhjiöpussi",
                        brick = "Lohkon kääre",
                        premium_seal = "Premiumsinetti",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Laatu / Painotus",
                    description = "Vaikutus lopulliseen laatuun: Peruslaatu.",
                },
                drugQualityWeightPurity = {
                    label = "Puhtaus / Painotus",
                    description = "Vaikutus lopulliseen laatuun: Puhtaus.",
                },
                drugQualityWeightFreshness = {
                    label = "Tuoreus / Painotus",
                    description = "Vaikutus lopulliseen laatuun: Tuoreus.",
                },
                drugQualityWeightPotency = {
                    label = "Teho / Painotus",
                    description = "Vaikutus lopulliseen laatuun: Teho.",
                },
                drugQualityWeightStability = {
                    label = "Stabiilisuus / Painotus",
                    description = "Vaikutus lopulliseen laatuun: Stabiilisuus.",
                },
                drugQualityWeightContamination = {
                    label = "Kontaminaatio / Vähennys",
                    description = "Laatupisteiden vähennys saastuneille tuotteille.",
                },
                drugTierGoodMin = {
                    label = "Hyvä / Taso / Vähimmäisarvo",
                    description = "Laatutason vähimmäispisteet: Hyvä.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Taso / Vähimmäisarvo",
                    description = "Laatutason vähimmäispisteet: Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Paras laatu / Taso / Vähimmäisarvo",
                    description = "Laatutason vähimmäispisteet: Paras laatu.",
                },
                drugTierLabGradeMin = {
                    label = "Laboratoriolaatu / Taso / Vähimmäisarvo",
                    description = "Laatutason vähimmäispisteet: Laboratoriolaatu.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Pussi / Rakenne",
                    description = "Kerroin: tuoreuden heikkeneminen / Pussit.",
                },
                drugJarDecayMultiplier = {
                    label = "Purkki / Rakenne",
                    description = "Kerroin: tuoreuden heikkeneminen / Purkit.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Tyhjiö / Rakenne",
                    description = "Kerroin: tuoreuden heikkeneminen / Tyhjiöpussit.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Premiumsinetti / Hinta",
                    description = "Kerroin: Premium / Sinetöity tuote / Hinta.",
                },
                drugGrowingEnabled = {
                    label = "Kasvatus / Käytössä",
                    description = "Ottaa käyttöön: kasvien kasvu ja sadonkorjuu.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Kasvien sijainnin tarkistus",
                    description = "Kun asetus on käytössä, vapaasti istutetut kasvit odottavat ylläpitäjän automaattista sijaintitarkistusta. Poista asetus käytöstä salliaksesi kasvun ilman ylläpitäjän hyväksyntää.",
                },
                drugGrowthTickMinutes = {
                    label = "Kasvu / Päivitysjakso / Minuutit",
                    description = "Aikaväli minuutteina: kasvien kasvupäivitykset.",
                },
                drugBaseGrowthPerTick = {
                    label = "Perusarvo / Kasvu / Päivitysjaksoa kohti",
                    description = "Peruskasvu ennen lajikkeen, varusteiden ja hoidon vaikutusta.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Villikasvi / Uudelleenilmestyminen",
                    description = "Odotusaika minuutteina: Villikasvi / Uudelleenilmestyminen.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Korosta villikasveja",
                    description = "Näyttää luotujen villikasvien ääriviivat, kun pelaaja tulee korostussäteelle.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Villikasvien korostussäde",
                    description = "Etäisyys metreinä jokaisen luodun villikasvin ympärillä, jolla sen ääriviivat näkyvät.",
                },
                drugDefaultPlantWater = {
                    label = "Oletusarvo / Vesi",
                    description = "Alkuarvo kasvin luonnissa: Vesi.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Oletusarvo / Lannoite",
                    description = "Alkuarvo kasvin luonnissa: Lannoite.",
                },
                drugDefaultPlantHealth = {
                    label = "Oletusarvo / Terveys",
                    description = "Alkuarvo kasvin luonnissa: Terveys.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Oletusarvo / Mutaatiotodennäköisyys",
                    description = "Mutaation perustodennäköisyys, jos lajikkeella ei ole omaa arvoa.",
                },
                drugHarvestPerfectStart = {
                    label = "Parhaan sadonkorjuuajan alku",
                    description = "Kasvuprosentti parhaalle sadonkorjuuajalle: Alku.",
                },
                drugHarvestPerfectEnd = {
                    label = "Parhaan sadonkorjuuajan loppu",
                    description = "Kasvuprosentti parhaalle sadonkorjuuajalle: Loppu.",
                },
                drugLabsEnabled = {
                    label = "Laboratoriot / Käytössä",
                    description = "Ottaa käyttöön: laboratoriot ja matkailuautot pelissä.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratorioita hahmoa kohti",
                    description = "Ostettujen tai vuokrattujen kiinteiden laboratorioiden enimmäismäärä omistajaa kohti. 0 tarkoittaa rajoittamatonta; matkailuautot ja jaetut käyttöoikeudet eivät kuulu määrään.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratorioita ryhmittymää kohti",
                    description = "Ostettujen tai vuokrattujen kiinteiden laboratorioiden enimmäismäärä omistajaa kohti. 0 tarkoittaa rajoittamatonta; matkailuautot ja jaetut käyttöoikeudet eivät kuulu määrään.",
                },
                drugDefaultRentDays = {
                    label = "Oletusarvo / Vuokrapäivät",
                    description = "Oletusarvo: Laboratorio / Vuokra / Kesto.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Varastettu matkailuauto / Minuutit",
                    description = "Aika, jonka varastettujen matkailuautojen riski pysyy koholla.",
                },
                drugLabRentWarningHours = {
                    label = "Vuokra / Varoitus / Tunnit",
                    description = "Kuinka monta tuntia ennen laboratorion vuokra-ajan päättymistä varoitus näytetään.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Päättynyt vuokra / Poliisin huomio",
                    description = "Poliisin huomion lisäys laboratorion vuokra-ajan päättyessä.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Asuntovaunu / Siirrä / Odotusaika",
                    description = "Odotusaika minuutteina: Asuntovaunu / Laboratorio / Uudelleensiirto.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Parannus / Hinta / Kerroin",
                    description = "Kerroin: Laboratorio / Taso / Parannus / Hinnat.",
                },
                drugCamperBaseSlots = {
                    label = "Asuntovaunu / Paikat",
                    description = "Oletusarvo: matkailuautolaboratoriot / laitepaikat.",
                },
                drugCamperBaseStorage = {
                    label = "Asuntovaunu / Varasto",
                    description = "Oletusarvo: matkailuautolaboratoriot / Varastokapasiteetti.",
                },
                drugCamperBasePower = {
                    label = "Asuntovaunu / Virta",
                    description = "Oletusarvo: matkailuautolaboratoriot / Sisäinen virransyöttö.",
                },
                drugBasementBaseSlots = {
                    label = "Kellarilaboratorio / Paikat",
                    description = "Oletusarvo: kellarilaboratoriot / laitepaikat.",
                },
                drugBasementBaseStorage = {
                    label = "Kellarilaboratorio / Varasto",
                    description = "Oletusarvo: kellarilaboratoriot / Varastokapasiteetti.",
                },
                drugWarehouseBasePower = {
                    label = "Varasto / Virta",
                    description = "Oletusarvo: varastolaboratoriot / Sisäinen virransyöttö.",
                },
                drugPowerEnabled = {
                    label = "Virta / Järjestelmä",
                    description = "Ottaa käyttöön: laboratorion sähköntuotanto, sähkönkulutus ja ylikuormitustarkistukset.",
                },
                drugOverloadGraceSeconds = {
                    label = "Ylikuormitus / Armonaika",
                    description = "Sekunteja ennen kuin sähköylikuorma muuttuu vaaralliseksi.",
                },
                drugHeatPerKilowatt = {
                    label = "Poliisin huomio / Kilowattia kohti",
                    description = "Sähkönkulutuksen laboratoriolle aiheuttama poliisin huomio.",
                },
                drugGeneratorT1Watts = {
                    label = "Generaattori T1 / Wattia",
                    description = "Tason T1 generaattorien teho watteina.",
                },
                drugGeneratorT2Watts = {
                    label = "Generaattori T2 / Wattia",
                    description = "Tason T2 generaattorien teho watteina.",
                },
                drugGeneratorT3Watts = {
                    label = "Generaattori T3 / Wattia",
                    description = "Tason T3 generaattorien teho watteina.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Kuluminen / Kerroin",
                    description = "Yleinen kerroin: Varusteiden kuluminen / Prosessointi.",
                },
                drugWorkersEnabled = {
                    label = "Työntekijät / Käytössä",
                    description = "Ottaa käyttöön: huumelaboratorioiden kemistit, kasvattajat, pakkaajat ja vartijat.",
                },
                drugMaxWorkersPerLab = {
                    label = "Enimmäisarvo / Työntekijät / Laboratorio",
                    description = "Työntekijöiden enimmäismäärä laboratoriota kohti.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Käsittelyn aiheuttama väsymys",
                    description = "Lisäväsymys ryhmälle Työntekijät seuraavan työn jälkeen: Käsittelyvaihe.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Kasvatus / Väsymys",
                    description = "Lisäväsymys ryhmälle Kasvattajat seuraavan työn jälkeen: Sadonkorjuu tai kasvatus.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Työntekijä / Palautuminen",
                    description = "Palautuminen — Väsymys, jokaisella päivityksellä: Kasvupäivitys.",
                },
                drugMarketEnabled = {
                    label = "Markkinat / Käytössä",
                    description = "Ottaa käyttöön: ostajat, kauppiaat ja erämyynti.",
                },
                drugMarketBasePriceFallback = {
                    label = "Vara-arvo / Perushinta",
                    description = "Huumeiden perushinta, kun omaa hintaa ei ole määritetty.",
                },
                drugMarketStreetMultiplier = {
                    label = "Katu / Kerroin",
                    description = "Yleinen kerroin: Hinta / Katukauppa.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Tukkukauppa / Kerroin",
                    description = "Yleinen kerroin: Hinta / Tukkukauppa / Kaupat.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Kerroin",
                    description = "Yleinen kerroin: Hinta / Premium / Ostajat.",
                },
                drugMarketHeatPerSale = {
                    label = "Poliisin huomio / Myynti",
                    description = "Laboratorion poliisin perushuomion kasvu erää myytäessä.",
                },
                drugDistributionTickMinutes = {
                    label = "Jakelu / Päivitysjakso",
                    description = "Aikaväli minuutteina: kauppiaiden jakelupäivitykset.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Jakelu / Aikaväli",
                    description = "Oletusarvo: Jälleenmyyjä / Odotus ennen myyntiä / Minuutit.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Enimmäisarvo / Jälleenmyyjä / Tilauslistat",
                    description = "Oletusarvo: Jälleenmyyjä / aktiivisten jakelutilausten enimmäismäärä.",
                },
                drugThreatsEnabled = {
                    label = "Uhkailut / Käytössä",
                    description = "Ottaa käyttöön: laboratorioiden poliisihuomion väheneminen, ratsiat ja sabotaasit.",
                },
                drugThreatTickMinutes = {
                    label = "Uhka / Päivitysjakso",
                    description = "Aikaväli minuutteina: poliisihuomion väheneminen sekä ratsia- ja sabotaasitarkistukset.",
                },
                drugRaidHeatThreshold = {
                    label = "Ratsian poliisihuomion kynnys",
                    description = "Laboratorion poliisin huomion kynnys tapahtumalle: Ryöstöt.",
                },
                drugSabotageHeatThreshold = {
                    label = "Sabotaasin poliisihuomion kynnys",
                    description = "Laboratorion poliisin huomion kynnys tapahtumalle: Sabotaasi.",
                },
                drugThreatHeatDecay = {
                    label = "Poliisin huomio / Rakenne",
                    description = "Vähentää laboratorion poliisihuomiota tällä arvolla jokaisen uhkapäivityksen yhteydessä.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Ratsian todennäköisyys",
                    description = "Tapahtuman Hyökkäys perustodennäköisyys, kun vastaava poliisin huomion kynnys saavutetaan.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotaasi / Mahdollisuus",
                    description = "Tapahtuman Sabotaasi perustodennäköisyys, kun vastaava poliisin huomion kynnys saavutetaan.",
                },
                drugConsumptionEnabled = {
                    label = "Kulutus käytössä",
                    description = "Ottaa käyttöön: huumeiden vaikutukset sekä sietokyvyn ja riippuvuuden seuranta.",
                },
                drugDoseConsumesBatch = {
                    label = "Kuluta erä käytettäessä",
                    description = "Poistaa käytetyn erän aktiivisesta varastosta.",
                },
                drugToleranceDecayMinutes = {
                    label = "Sallittu poikkeama / Rakenne",
                    description = "Aikaväli minuutteina: sietokyvyn vähenemisen päivitykset.",
                },
                drugAddictionDecayMinutes = {
                    label = "Riippuvuus / Rakenne",
                    description = "Aikaväli minuutteina: riippuvuuden vähenemisen päivitykset.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Teho / Kerroin",
                    description = "Määrittää, kuinka paljon vahvuus lisää vaikutusten voimakkuutta.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Yliannostus / Kynnysarvo",
                    description = "Vaadittu ainekuormitus ennen yliannostuksen todennäköisyystarkistuksia.",
                },
                drugBaseAddictionGain = {
                    label = "Perusarvo / Riippuvuus / saanto",
                    description = "Riippuvuuden peruskasvu annosta kohti.",
                },
                drugProcessingEnabled = {
                    label = "Prosessointi / Käytössä",
                    description = "Ottaa käyttöön: käsittelytyöt, pakkaaminen ja testipakkaukset.",
                },
                drugBatchMetadataItemKey = {
                    label = "Erä / Metatiedot / Avain",
                    description = "Inventaarion metatietoavain, jota integraatiot käyttävät erätietoihin.",
                },
                drugDefaultProcessDuration = {
                    label = "Käsittelyn oletuskesto",
                    description = "Oletusarvo: Prosessointi / Kesto / sekuntia / Ilman reseptin omaa arvoa.",
                },
                drugDefaultFailureRisk = {
                    label = "Oletusarvo / Epäonnistumisen riski",
                    description = "Oletusarvo: Prosessointi / Epäonnistumisen riski / Ilman reseptin omaa arvoa.",
                },
                drugPackagingDuration = {
                    label = "Pakkausaika",
                    description = "Oletusarvo: Pakkaus / Kesto / sekuntia.",
                },
                drugPowerTickSeconds = {
                    label = "Virta / Päivitysjakso / sekuntia",
                    description = "Aikaväli sekunteina: generaattorien kulutuksen ja sähköjälkien päivitys.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Sähköjälki / Poliisin huomio / Tunti",
                    description = "Laboratorion sähköjäljen tunnissa aiheuttama poliisin huomio.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Ylikuormitus / Poliisin huomio / Tunti",
                    description = "Poliisin lisähuomio tunnissa laboratorion ylikuormituksen aikana.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Tyhjäkäynti / Poliisin huomio / Rakenne / Tunti",
                    description = "Poliisin huomion väheneminen tunnissa, kun laboratoriolla ei ole aktiivista sähköjälkeä.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuaalinen / Enimmäisarvo / Kuormitus",
                    description = "Energiatilan Manuaalinen arvo: Enimmäisarvo / Kuormitus.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuaalinen / Poliisin huomio / Kerroin",
                    description = "Energiatilan Manuaalinen arvo: Poliisin huomio / Kerroin.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuaalinen / Melu / Kerroin",
                    description = "Energiatilan Manuaalinen arvo: Melu / Kerroin.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Tasapainoinen / Enimmäisarvo / Kuormitus",
                    description = "Energiatilan Tasapainoinen arvo: Enimmäisarvo / Kuormitus.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Tasapainoinen / Poliisin huomio / Kerroin",
                    description = "Energiatilan Tasapainoinen arvo: Poliisin huomio / Kerroin.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Tasapainoinen / Melu / Kerroin",
                    description = "Energiatilan Tasapainoinen arvo: Melu / Kerroin.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Hiiviskely / Enimmäisarvo / Kuormitus",
                    description = "Energiatilan Hiiviskely arvo: Enimmäisarvo / Kuormitus.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Hiiviskely / Poliisin huomio / Kerroin",
                    description = "Energiatilan Hiiviskely arvo: Poliisin huomio / Kerroin.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Hiiviskely / Melu / Kerroin",
                    description = "Energiatilan Hiiviskely arvo: Melu / Kerroin.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Hajunhallinta / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Hajunhallinta / Laitteet.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ilmanvaihto / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Ilmanvaihto / Laitteet.",
                },
                drugPowerPrioritySecurity = {
                    label = "Turvallisuus / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Turvavarusteet.",
                },
                drugPowerPriorityGrowing = {
                    label = "Kasvatus / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Kasvatus / Laitteet.",
                },
                drugPowerPriorityLight = {
                    label = "Valaistus / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Valaistus / Laitteet.",
                },
                drugPowerPriorityTesting = {
                    label = "Testaus / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Testaus / Laitteet.",
                },
                drugPowerPriorityPackaging = {
                    label = "Pakkaus / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Pakkaus / Laitteet.",
                },
                drugPowerPriorityChemistry = {
                    label = "Kemia / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Kemia / Laitteet.",
                },
                drugPowerPriorityHeating = {
                    label = "Lämmitys / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Lämmitys / Laitteet.",
                },
                drugPowerPriorityPressing = {
                    label = "Puristaminen / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Puristaminen / Laitteet.",
                },
                drugPowerPriorityGeneral = {
                    label = "Yleinen / Prioriteetti",
                    description = "Automaattisen kuormanpudotuksen prioriteetti: Yleiset laitteet.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Suorituskyky / Epäaktiivinen / Ohjaus / Aikaväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Epäaktiivinen / Ohjaus / Aikaväli / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Suorituskyky / Vuorovaikutus / Tyhjäkäynti / Tarkistusväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Tyhjäkäynti / Tarkistusväli / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Suorituskyky / Vuorovaikutus / Vuorovaikutuskehotus / Aikaväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Vuorovaikutuskehotus / Aikaväli / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Suorituskyky / Vuorovaikutus / Tarkistusväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Vuorovaikutus / Tarkistusväli / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Suorituskyky / Vähimmäisarvo / Tarkistusväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Vähimmäisarvo / Tarkistusväli / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Suorituskyky / Katu / Ped / Aktivointi / Etäisyys",
                    description = "Toiminta-asetus: Suorituskyky / Katu / Ped / Aktivointi / Etäisyys.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Suorituskyky / Katu / Ped / Tyhjäkäynti / Tarkistusväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Katu / Ped / Tyhjäkäynti / Tarkistusväli / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Suorituskyky / Katu / Ped / Tarkistusväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Katu / Ped / Tarkistusväli / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Suorituskyky / Maailma / Välimuisti / Lisämarginaali",
                    description = "Toiminta-asetus: Suorituskyky / Maailma / Välimuisti / Lisämarginaali.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Suorituskyky / Maailma / Välimuisti / Päivitys / Aikaväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Maailma / Välimuisti / Päivitys / Aikaväli / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Suorituskyky / Maailma / Tyhjäkäynti / Aikaväli / ms",
                    description = "Toiminta-asetus: Suorituskyky / Maailma / Tyhjäkäynti / Aikaväli / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Dynaaminen markkina / Toiminnon viive / sekuntia",
                    description = "Toiminta-asetus: Dynaaminen markkina / Toiminnon viive / sekuntia.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Dynaaminen markkina / Toiminta / Historian raja",
                    description = "Toiminta-asetus: Dynaaminen markkina / Toiminta / Historian raja.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Dynaaminen markkina / Määrä / Kyllästys / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Määrä / Kyllästys / Painotus.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Dynaaminen markkina / Perusarvo / Tiedustelun tarkkuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Perusarvo / Tiedustelun tarkkuus.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Dynaaminen markkina / Oletusarvo / Keskiarvo / Laatu",
                    description = "Toiminta-asetus: Dynaaminen markkina / Oletusarvo / Keskiarvo / Laatu.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Dynaaminen markkina / Oletusarvo / Resurssi / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Oletusarvo / Resurssi / Joustavuus.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Dynaaminen markkina / Kysyntä / Keskiarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Kysyntä / Keskiarvo.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Dynaaminen markkina / Kysyntä / Hinta / Vaikutus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Kysyntä / Hinta / Vaikutus.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Dynaaminen markkina / Suunta / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Suunta / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Dynaaminen markkina / Käytössä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Käytössä.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Dynaaminen markkina / Tapahtuma / Mahdollisuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Mahdollisuus.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Dynaaminen markkina / Tapahtuma / Kesto / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Kesto / Minuutit.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Dynaaminen markkina / Tapahtuma / Vähimmäisarvo / Kesto / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Vähimmäisarvo / Kesto / Minuutit.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Dynaaminen markkina / Tapahtuma / Voimakkuus / Enimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Voimakkuus / Enimmäisarvo.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Dynaaminen markkina / Tapahtuma / Voimakkuus / Vähimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtuma / Voimakkuus / Vähimmäisarvo.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Poliisi",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Poliisi.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Poliisioperaatio / Hinta.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 2",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 3",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Vaikutukset / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Hinta.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Dynaaminen markkina / Tapahtumat / Festivaali / Profiilit / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Festivaali / Profiilit / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Poliisi",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Poliisi.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Hinta.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Profiilit / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Jengien välinen konflikti / Profiilit / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Poliisi",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Poliisi.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Hinta.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Tarvike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Laboratorioratsia / Tarvike.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 2",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 3",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Vaikutukset / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Hinta.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Profiilit / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Profiilit / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Dynaaminen markkina / Tapahtumat / Juhla / Profiilit / 2",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Juhla / Profiilit / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Dynaaminen markkina / Tapahtumat / Puute / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Puute / Kysyntä.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Dynaaminen markkina / Tapahtumat / Puute / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Puute / Hinta.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Dynaaminen markkina / Tapahtumat / Puute / Tarvike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tapahtumat / Puute / Tarvike.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Dynaaminen markkina / Tarkat tiedot / Maine",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tarkat tiedot / Maine.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Dynaaminen markkina / Tarkat tiedot / Luottamus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tarkat tiedot / Luottamus.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Dynaaminen markkina / Global / Vyöhyke / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Global / Vyöhyke / Nimike.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Dynaaminen markkina / Historian raja",
                    description = "Toiminta-asetus: Dynaaminen markkina / Historian raja.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Dynaaminen markkina / Alkuarvo / Kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Alkuarvo / Kysyntä.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Dynaaminen markkina / Alkuarvo / Hintakerroin",
                    description = "Toiminta-asetus: Dynaaminen markkina / Alkuarvo / Hintakerroin.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Kysyntä / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Kysyntä / Virhe.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Enimmäisarvo / Tarkkuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Enimmäisarvo / Tarkkuus.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Vähimmäisarvo / Tarkkuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Vähimmäisarvo / Tarkkuus.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Poliisi / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Poliisi / Virhe.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Hinta / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Virhe.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Hinta / Enimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Enimmäisarvo.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Hinta / Vähimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Hinta / Vähimmäisarvo.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Maine / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Maine / Painotus.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Resurssi / Hinta / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Resurssi / Hinta / Virhe.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Kyllästys / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Kyllästys / Virhe.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Dynaaminen markkina / Tietojen satunnaissiemenen aikaväli / sekuntia",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tietojen satunnaissiemenen aikaväli / sekuntia.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Tila / Tarkkuus / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tila / Tarkkuus / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Tila / Virhe / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tila / Virhe / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Tarvike / Virhe",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Tarvike / Virhe.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Dynaaminen markkina / Tiedustelutiedot / Luottamus / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tiedustelutiedot / Luottamus / Painotus.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Dynaaminen markkina / Manipulointi / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Jäähdytysminuutit.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Dynaaminen markkina / Manipulointi / Kysyntä / Muutos",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Kysyntä / Muutos.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Dynaaminen markkina / Manipulointi / Kesto / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Kesto / Minuutit.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Dynaaminen markkina / Manipulointi / Poliisin huomio",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Poliisin huomio.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Dynaaminen markkina / Manipulointi / Vähimmäisarvo / Erä / Määrä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Vähimmäisarvo / Erä / Määrä.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Dynaaminen markkina / Manipulointi / Maksutili",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Maksutili.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Dynaaminen markkina / Manipulointi / Hinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Hinta.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Dynaaminen markkina / Manipulointi / Vyöhyke / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Dynaaminen markkina / Manipulointi / Vyöhyke / Poliisin huomio / Kerroin.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Dynaaminen markkina / Enimmäisarvo / Tiedustelun ikä / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Enimmäisarvo / Tiedustelun ikä / Minuutit.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Dynaaminen markkina / Enimmäisarvo / Hintakerroin",
                    description = "Toiminta-asetus: Dynaaminen markkina / Enimmäisarvo / Hintakerroin.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Dynaaminen markkina / Vähimmäisarvo / Tiedustelun ikä / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Tiedustelun ikä / Minuutit.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Dynaaminen markkina / Vähimmäisarvo / Mittari / Aikaikkuna / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Mittari / Aikaikkuna / Minuutit.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Dynaaminen markkina / Minimihinta / Kerroin",
                    description = "Toiminta-asetus: Dynaaminen markkina / Minimihinta / Kerroin.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Dynaaminen markkina / Vähimmäisarvo / Päivitys / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vähimmäisarvo / Päivitys / Minuutit.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Dynaaminen markkina / Poliisi / Kysyntä / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Poliisi / Kysyntä / Painotus.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Dynaaminen markkina / Poliisi / Hinta / Vaikutus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Poliisi / Hinta / Vaikutus.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Dynaaminen markkina / Heikko laatu / Kysyntä / Vähennys",
                    description = "Toiminta-asetus: Dynaaminen markkina / Heikko laatu / Kysyntä / Vähennys.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Dynaaminen markkina / Heikko laatu / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Heikko laatu / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Dynaaminen markkina / Huippulaatu / Kysyntäbonus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Huippulaatu / Kysyntäbonus.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Dynaaminen markkina / Huippulaatu / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Huippulaatu / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Dynaaminen markkina / Tuotanto / Tarvike / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tuotanto / Tarvike / Painotus.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Dynaaminen markkina / Tuotanto / Aikaikkuna / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tuotanto / Aikaikkuna / Minuutit.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Dynaaminen markkina / Laatu / Keskiarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Laatu / Keskiarvo.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Dynaaminen markkina / Laatu / Luottamus / Vaikutus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Laatu / Luottamus / Vaikutus.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Dynaaminen markkina / Laatu / Arvoalue",
                    description = "Toiminta-asetus: Dynaaminen markkina / Laatu / Arvoalue.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Dynaaminen markkina / Harvinaisuus / Palkkio / Enimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Harvinaisuus / Palkkio / Enimmäisarvo.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Dynaaminen markkina / Alueellinen / Global / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Alueellinen / Global / Painotus.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Dynaaminen markkina / Alueellinen / Paikallinen / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Alueellinen / Paikallinen / Painotus.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Huume / Pakkaus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Huume / Pakkaus.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Polttoainekanisteri",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Polttoainekanisteri.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Koneöljy",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Koneöljy.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Kasvien ravinteet",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Kasvien ravinteet.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Korjaussarja",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Vaihtoehtoiset nimet / Korjaussarja.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Dynaaminen markkina / Resurssi / Suunta / Lasku / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Suunta / Lasku / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Dynaaminen markkina / Resurssi / Suunta / Nousu / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssi / Suunta / Nousu / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 2",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 3",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Hiilisuodatin / Liitetyt huumeet / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Liitetyt huumeet / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Liitetyt huumeet / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Liitetyt huumeet / 2",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kemiallinen lähtöaine / Liitetyt huumeet / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Laitteiston osat / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laitteiston osat / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Laitteiston osat / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laitteiston osat / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Dynaaminen markkina / Resurssit / Laitteiston osat / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laitteiston osat / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Lannoite / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Lannoite / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Lannoite / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Lannoite / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Dynaaminen markkina / Resurssit / Lannoite / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Lannoite / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Dynaaminen markkina / Resurssit / Lannoite / Liitetyt huumeet / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Lannoite / Liitetyt huumeet / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Laboratorion polttoaine / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Pakkauspussi / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Pakkauspussi / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Pakkauspussi / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Pakkauspussi / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Dynaaminen markkina / Resurssit / Pakkauspussi / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Pakkauspussi / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Istutusruukku / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Istutusruukku / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Istutusruukku / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Istutusruukku / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Dynaaminen markkina / Resurssit / Istutusruukku / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Istutusruukku / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Dynaaminen markkina / Resurssit / Istutusruukku / Liitetyt huumeet / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Istutusruukku / Liitetyt huumeet / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Dynaaminen markkina / Resurssit / Kannabiksen siemen / Perushinta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kannabiksen siemen / Perushinta.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Dynaaminen markkina / Resurssit / Kannabiksen siemen / Joustavuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kannabiksen siemen / Joustavuus.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Dynaaminen markkina / Resurssit / Kannabiksen siemen / Nimike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kannabiksen siemen / Nimike.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Dynaaminen markkina / Resurssit / Kannabiksen siemen / Liitetyt huumeet / 1",
                    description = "Toiminta-asetus: Dynaaminen markkina / Resurssit / Kannabiksen siemen / Liitetyt huumeet / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Dynaaminen markkina / Myynti / Aikaikkuna / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Myynti / Aikaikkuna / Minuutit.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Dynaaminen markkina / Kyllästys / Kysyntä / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Kyllästys / Kysyntä / Painotus.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Dynaaminen markkina / Kyllästys / Hinta / Vaikutus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Kyllästys / Hinta / Vaikutus.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Dynaaminen markkina / Niukkuus / Kysyntä / Painotus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Niukkuus / Kysyntä / Painotus.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Dynaaminen markkina / Niukkuus / Hinta / Vaikutus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Niukkuus / Hinta / Vaikutus.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Joulukuu",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Joulukuu.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Kevät",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Kevät.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Kesä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Kesä.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Talvi",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Loppu / Kuukaudet / Talvi.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Dynaaminen markkina / Vuodenaika / Kertoimet / Syksy",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Kertoimet / Syksy.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Dynaaminen markkina / Vuodenaika / Kertoimet / Kevät",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Kertoimet / Kevät.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Dynaaminen markkina / Vuodenaika / Kertoimet / Kesä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Kertoimet / Kesä.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Dynaaminen markkina / Vuodenaika / Kertoimet / Talvi",
                    description = "Toiminta-asetus: Dynaaminen markkina / Vuodenaika / Kertoimet / Talvi.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Dynaaminen markkina / Puute / Huhu / Kynnysarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Puute / Huhu / Kynnysarvo.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Dynaaminen markkina / Tila / Kynnysarvot / Korkea kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tila / Kynnysarvot / Korkea kysyntä.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Dynaaminen markkina / Tila / Kynnysarvot / Etsitty",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tila / Kynnysarvot / Etsitty.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Dynaaminen markkina / Tila / Kynnysarvot / Matala kysyntä",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tila / Kynnysarvot / Matala kysyntä.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Dynaaminen markkina / Tila / Kynnysarvot / Ylitarjonta",
                    description = "Toiminta-asetus: Dynaaminen markkina / Tila / Kynnysarvot / Ylitarjonta.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Dynaaminen markkina / Kohde / Tarvike",
                    description = "Toiminta-asetus: Dynaaminen markkina / Kohde / Tarvike.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Dynaaminen markkina / Suuntaus / Mahdollisuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Mahdollisuus.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Dynaaminen markkina / Suuntaus / Kesto / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Kesto / Minuutit.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Dynaaminen markkina / Suuntaus / Enimmäisarvo / Voimakkuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Enimmäisarvo / Voimakkuus.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Dynaaminen markkina / Suuntaus / Vähimmäisarvo / Voimakkuus",
                    description = "Toiminta-asetus: Dynaaminen markkina / Suuntaus / Vähimmäisarvo / Voimakkuus.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Dynaaminen markkina / Päivitys / Minuutit",
                    description = "Toiminta-asetus: Dynaaminen markkina / Päivitys / Minuutit.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Dynaaminen markkina / Hintavaihtelu / Enimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Hintavaihtelu / Enimmäisarvo.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Dynaaminen markkina / Hintavaihtelu / Vähimmäisarvo",
                    description = "Toiminta-asetus: Dynaaminen markkina / Hintavaihtelu / Vähimmäisarvo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Dynaaminen markkina / Sää / Kertoimet / Kylmyys",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Kertoimet / Kylmyys.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Dynaaminen markkina / Sää / Kertoimet / Helleaalto",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Kertoimet / Helleaalto.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Dynaaminen markkina / Sää / Kertoimet / Normaali",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Kertoimet / Normaali.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Dynaaminen markkina / Sää / Kertoimet / Sade",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Kertoimet / Sade.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Dynaaminen markkina / Sää / Kertoimet / Myrsky",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Kertoimet / Myrsky.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Dynaaminen markkina / Sää / Tila",
                    description = "Toiminta-asetus: Dynaaminen markkina / Sää / Tila.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Poliisin huomio ja riski / Toiminnon viive / sekuntia",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminnon viive / sekuntia.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Määrä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Määrä.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Kesto / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Kesto / Minuutit.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Poliisin paine",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Poliisin paine.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Maine",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Maine.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Turvallisuus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Toiminta / Riski / Painotukset / Turvallisuus.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Poliisin huomio ja riski / Aggressiivinen toimintatapa / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Aggressiivinen toimintatapa / Poliisin huomio / Kerroin.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Poliisin huomio ja riski / Kertakäyttöpuhelin / Paljastuminen / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kertakäyttöpuhelin / Paljastuminen / Kynnysarvo.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Poliisin huomio ja riski / Kertakäyttöpuhelin / Poliisin huomio / Tukkukauppaa kohti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kertakäyttöpuhelin / Poliisin huomio / Tukkukauppaa kohti.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Poliisin huomio ja riski / Puhdeleva puhelin / Esine",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Puhdeleva puhelin / Esine.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kerroin.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Matkailuauto toiminnassa / Poliisin huomio / Kynnysarvo.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Poliisin huomio ja riski / Pysäköity matkailuauto / Poliisin huomio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Pysäköity matkailuauto / Poliisin huomio.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Poliisin huomio ja riski / Saastuminen / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Saastuminen / Poliisin huomio / Kerroin.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Poliisin huomio ja riski / Saastuminen / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Saastuminen / Kynnysarvo.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Poliisin huomio ja riski / Viljely / Kasvit ilman lisäriskiä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Viljely / Kasvit ilman lisäriskiä.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Poliisin huomio ja riski / Viljely / Poliisin huomio / Kasvia kohti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Viljely / Poliisin huomio / Kasvia kohti.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Poliisin huomio ja riski / Jälleenmyyjä / piilotettu / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Jälleenmyyjä / piilotettu / Minuutit.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Erä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Erä.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Asuntovaunu",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Asuntovaunu.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Jälleenmyyjä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Jälleenmyyjä.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Faktio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Faktio.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Jakelukeskus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Jakelukeskus.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Laboratorio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Laboratorio.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Pelaaja",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Pelaaja.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Reitti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Reitti.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Vyöhyke",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Rakenne / Päivitysjaksoa kohti / Vyöhyke.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Poliisin huomio ja riski / Käytössä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Käytössä.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Kriittinen",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Kriittinen.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Korkea",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Korkea.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Matala",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Matala.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Keskikokoinen",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Poliisin huomio / Keskikokoinen.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Erä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Erä.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Faktio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Faktio.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Vyöhyke",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Poliisin läsnäolo / Kertoimet / Vyöhyke.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Erä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Erä.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Asuntovaunu",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Asuntovaunu.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Jälleenmyyjä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Jälleenmyyjä.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Faktio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Faktio.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Jakelukeskus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Jakelukeskus.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Laboratorio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Laboratorio.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Pelaaja",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Pelaaja.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Reitti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Reitti.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Poliisin huomio ja riski / Peliobjekti / Tyypit / Vyöhyke",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Peliobjekti / Tyypit / Vyöhyke.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Poliisin huomio ja riski / Tapahtuma / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Tapahtuma / Jäähdytysminuutit.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Poliisin huomio ja riski / Tapahtuma / Historian raja",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Tapahtuma / Historian raja.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Poliisin huomio ja riski / Laboratorio / Poliisin huomio / Synkronointi / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Laboratorio / Poliisin huomio / Synkronointi / Kynnysarvo.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Poliisin huomio ja riski / Piiloutuminen / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Jäähdytysminuutit.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Poliisin huomio ja riski / Piiloutuminen / Tyhjäkäynti / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Tyhjäkäynti / Minuutit.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Poliisin huomio ja riski / Piiloutuminen / Vähennys",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Piiloutuminen / Vähennys.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Poliisin huomio ja riski / Lukitus / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Lukitus / Minuutit.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Poliisin huomio ja riski / Vähimmäisarvo / Kesto / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Kesto / Minuutit.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Poliisin huomio ja riski / Vähimmäisarvo / Tapahtuma / Lepoväli (sekuntia)",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Tapahtuma / Lepoväli (sekuntia).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Poliisin huomio ja riski / Vähimmäisarvo / Tyhjäkäynti / sekuntia",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Vähimmäisarvo / Tyhjäkäynti / sekuntia.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Poliisin huomio ja riski / Prosessointi / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Prosessointi / Poliisin huomio / Kerroin.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Erä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Erä.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Asuntovaunu",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Asuntovaunu.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Jälleenmyyjä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Jälleenmyyjä.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Faktio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Faktio.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Jakelukeskus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Jakelukeskus.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Laboratorio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Laboratorio.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Pelaaja",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Pelaaja.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Reitti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Reitti.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Poliisin huomio ja riski / Riski / Painotukset / Vyöhyke",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Riski / Painotukset / Vyöhyke.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Poliisin huomio ja riski / Vaihda kertakäyttöpuhelin / Vähennys",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Vaihda kertakäyttöpuhelin / Vähennys.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Poliisin huomio ja riski / Reitti / Ohjaus / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Reitti / Ohjaus / Minuutit.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Erä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Erä.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Asuntovaunu",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Asuntovaunu.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Jälleenmyyjä",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Jälleenmyyjä.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Faktio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Faktio.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Jakelukeskus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Jakelukeskus.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Laboratorio",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Laboratorio.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Pelaaja",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Pelaaja.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Reitti",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Reitti.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Poliisin huomio ja riski / Myynti / Poliisin huomio / Vyöhyke",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Myynti / Poliisin huomio / Vyöhyke.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Poliisin huomio ja riski / Kynnysarvot / Kriittinen",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kynnysarvot / Kriittinen.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Poliisin huomio ja riski / Kynnysarvot / Korkea",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kynnysarvot / Korkea.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Poliisin huomio ja riski / Kynnysarvot / Lukitus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kynnysarvot / Lukitus.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Poliisin huomio ja riski / Kynnysarvot / Matala",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kynnysarvot / Matala.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Poliisin huomio ja riski / Kynnysarvot / Keskikokoinen",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Kynnysarvot / Keskikokoinen.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Poliisin huomio ja riski / Päivitysjakso / Minuutit",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Päivitysjakso / Minuutit.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Poliisin huomio ja riski / Tukkukauppa / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Tukkukauppa / Poliisin huomio / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Hälytyssäde",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Hälytyssäde.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Perusarvo / Mahdollisuus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Perusarvo / Mahdollisuus.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Faktio / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Faktio / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Korkea / Vakavuus / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Korkea / Vakavuus / Kynnysarvo.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Mahdollisuus / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Mahdollisuus / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Uskollisuus / Kynnysarvo.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Enimmäisarvo / Mahdollisuus",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Enimmäisarvo / Mahdollisuus.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Vähimmäisarvo / Lepoväli (sekuntia)",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Vähimmäisarvo / Lepoväli (sekuntia).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Reitti / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Reitti / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Enimmäisarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Enimmäisarvo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Vähimmäisarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Vähimmäisarvo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Voimakkuus / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Mahdollisuus / Kerroin",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Mahdollisuus / Kerroin.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Kynnysarvo",
                    description = "Toiminta-asetus: Poliisin huomio ja riski / Työntekijä / Tietovuoto / Stressi / Kynnysarvo.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Kontaktiverkosto / Toiminnon viive / sekuntia",
                    description = "Toiminta-asetus: Kontaktiverkosto / Toiminnon viive / sekuntia.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Kontaktiverkosto / Aktiivisten kohteiden määrä",
                    description = "Toiminta-asetus: Kontaktiverkosto / Aktiivisten kohteiden määrä.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Kontaktiverkosto / Pöytäpuhelin-vihje / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pöytäpuhelin-vihje / Luottamus.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Enimmäisarvo / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Enimmäisarvo / Kerroin.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Vähimmäisarvo / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Kertakäyttöpuhelin / Tarjous / Vähimmäisarvo / Kerroin.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Kontaktiverkosto / Ostaja / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Jäähdytysminuutit.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Kontaktiverkosto / Ostaja / Toimitusetäisyys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Toimitusetäisyys.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Kontaktiverkosto / Ostaja / Premium / Onnistuminen / Pistemäärä",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Premium / Onnistuminen / Pistemäärä.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Kontaktiverkosto / Ostaja / Premium / Luottamus / saanto",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Premium / Luottamus / saanto.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Kontaktiverkosto / Ostaja / Pyyntö / Poliisi & etsintäpaino / Painotus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Pyyntö / Poliisi & etsintäpaino / Painotus.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Kontaktiverkosto / Ostaja / Standardi / Luottamus / saanto",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ostaja / Standardi / Luottamus / saanto.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Kontaktiverkosto / Kontaktin aktivointiviive / sekuntia / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Kontaktin aktivointiviive / sekuntia / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Kontaktiverkosto / Kontaktin aktivointiviive / sekuntia / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Kontaktin aktivointiviive / sekuntia / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Kontaktiverkosto / Yhteystiedot / Kysyntä / Arvoalue / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Yhteystiedot / Kysyntä / Arvoalue / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Kontaktiverkosto / Yhteystiedot / Kysyntä / Arvoalue / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Yhteystiedot / Kysyntä / Arvoalue / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Kontaktiverkosto / Yhteystiedot / Tappio / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Yhteystiedot / Tappio / Luottamus.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Kontaktiverkosto / Pimeä verkko / Tarkat tiedot / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Tarkat tiedot / Minuutit.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Kontaktiverkosto / Pimeä verkko / Keskittymä / Tiedustelutiedot / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Keskittymä / Tiedustelutiedot / Hinta.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Kontaktiverkosto / Pimeä verkko / Tiedustelutiedot / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pimeä verkko / Tiedustelutiedot / Hinta.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Perushinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Perushinta.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / kapasiteetti / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / kapasiteetti / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / kapasiteetti / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / kapasiteetti / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Riski / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Riski / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Riski / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Riski / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Taito / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Taito / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Taito / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkkaaminen / Taito / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Esine.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Nimike.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Minimiluottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Minimiluottamus.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 1 / Hinta.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Esine.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Nimike.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Minimiluottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Minimiluottamus.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 2 / Hinta.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Esine.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Nimike.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Minimiluottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Minimiluottamus.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 3 / Hinta.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Esine.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Nimike.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Minimiluottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Minimiluottamus.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 4 / Hinta.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Esine.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Nimike.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Minimiluottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Minimiluottamus.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjän tarjoukset / 5 / Hinta.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Suojaus / Tunnit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Suojaus / Tunnit.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Suojaus / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Suojaus / Hinta.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Myynti / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Myynti / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Myynti / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Myynti / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Aggressiivinen toimintatapa / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Aggressiivinen toimintatapa / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Peruslaatu / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Peruslaatu / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Määrä / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Määrä / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Halpamyynti / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Halpamyynti / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Oletusarvo / Laatu",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Oletusarvo / Laatu.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Epäuskollisuuden kynnys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Epäuskollisuuden kynnys.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Kokemus / Tasoa kohti",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Kokemus / Tasoa kohti.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Kokemus / Yksikköä kohti",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Kokemus / Yksikköä kohti.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Välikohtaus / Uskollisuus / Tappio",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Välikohtaus / Uskollisuus / Tappio.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Välikohtaus / Satunnaistarkistus / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Välikohtaus / Satunnaistarkistus / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taso / Hinta / Palkkio",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taso / Hinta / Palkkio.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taso / Myynti / Jakaja",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taso / Myynti / Jakaja.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Uskollisuus / Riski / Painotus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Uskollisuus / Riski / Painotus.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Enimmäisarvo / Välikohtaus / Mahdollisuus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Enimmäisarvo / Välikohtaus / Mahdollisuus.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Enimmäisarvo / Taso",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Enimmäisarvo / Taso.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Premium / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Premium / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Profiili / Riski / Painotus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Profiili / Riski / Painotus.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Suojaus / Riski / Vähennys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Suojaus / Riski / Vähennys.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Laatu / Hinta / Jakaja",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Laatu / Hinta / Jakaja.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Palautuminen / Perusarvo / Mahdollisuus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Palautuminen / Perusarvo / Mahdollisuus.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Palautuminen / Uskollisuus / Painotus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Palautuminen / Uskollisuus / Painotus.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Ryöstön varastotappio",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Ryöstön varastotappio.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taito / Riski / Vähennys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taito / Riski / Vähennys.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taito / Myynti / Jakaja",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Taito / Myynti / Jakaja.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Vakaan uskollisuuden kynnys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Vakaan uskollisuuden kynnys.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Alue / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Alue / Hintakerroin.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Alue / Riski / Vähennys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Simulaatio / Alue / Riski / Vähennys.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Päivitysjakso / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Päivitysjakso / Minuutit.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkka",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkka / Rakenne",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka / Rakenne.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Palkka / Uskollisuus / saanto",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Palkka / Uskollisuus / saanto.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 4",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 5",
                    description = "Toiminta-asetus: Kontaktiverkosto / Jälleenmyyjä / Heikkoudet / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Kontaktiverkosto / Oletusarvo / Yhteystiedot / Kysyntä",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Yhteystiedot / Kysyntä.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Kontaktiverkosto / Oletusarvo / Yhteystiedot / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Yhteystiedot / Riski.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Kontaktiverkosto / Oletuskauppias / kapasiteetti",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / kapasiteetti.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Kontaktiverkosto / Oletuskauppias / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / Riski.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Kontaktiverkosto / Oletuskauppias / Taito",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletuskauppias / Taito.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Kontaktiverkosto / Oletusarvo / Keskittymä / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Oletusarvo / Keskittymä / Säde.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Kontaktiverkosto / Kysynnän nollaus (minuuttia)",
                    description = "Toiminta-asetus: Kontaktiverkosto / Kysynnän nollaus (minuuttia).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Kontaktiverkosto / Käytössä",
                    description = "Toiminta-asetus: Kontaktiverkosto / Käytössä.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Kontaktiverkosto / Tarkka sijainti / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Tarkka sijainti / Luottamus.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Kontaktiverkosto / Faktio / Löytäminen / Maine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Faktio / Löytäminen / Maine.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Kontaktiverkosto / Faktio / Vihje / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Faktio / Vihje / Luottamus.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Kontaktiverkosto / Epäonnistunut toimitus / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Epäonnistunut toimitus / Jäähdytysminuutit.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Lukumäärä",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Lukumäärä.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Hyökkääjä / Mallit / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Kesto (sekuntia)",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Kesto (sekuntia).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Poliisi / Mallit / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Kontaktiverkosto / Valekauppa / Kohtaaminen / Spawn-säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Valekauppa / Kohtaaminen / Spawn-säde.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Kontaktiverkosto / Vara-arvo / Suosittu huume",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vara-arvo / Suosittu huume.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Kontaktiverkosto / Vara-arvo / Tuotteen nimi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vara-arvo / Tuotteen nimi.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Kontaktiverkosto / Opas / Kirja / Esine",
                    description = "Toiminta-asetus: Kontaktiverkosto / Opas / Kirja / Esine.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Kontaktiverkosto / Opas / Kirja / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Opas / Kirja / Luottamus.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Kontaktiverkosto / Palkkaa jälleenmyyjä / Hinta",
                    description = "Toiminta-asetus: Kontaktiverkosto / Palkkaa jälleenmyyjä / Hinta.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Kontaktiverkosto / Historian raja",
                    description = "Toiminta-asetus: Kontaktiverkosto / Historian raja.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Kontaktiverkosto / Keskittymä / Tiedustelutiedot / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Keskittymä / Tiedustelutiedot / Minuutit.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Kontaktiverkosto / Keskittymä / Vaihto / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Keskittymä / Vaihto / Minuutit.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Kontaktiverkosto / Ilmoitus / Kesto / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Ilmoitus / Kesto / Minuutit.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Kontaktiverkosto / Enimmäisarvo / Omistettu / Jälleenmyyjät",
                    description = "Toiminta-asetus: Kontaktiverkosto / Enimmäisarvo / Omistettu / Jälleenmyyjät.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Ostaja / Toimitusetäisyys",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ostaja / Toimitusetäisyys.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Kontakti-vuoro (minuuttia)",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Kontakti-vuoro (minuuttia).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Kysynnän nollaus (minuuttia)",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Kysynnän nollaus (minuuttia).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Tiedustelutiedot / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Tiedustelutiedot / Minuutit.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Säde.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Vaihto / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Keskittymä / Vaihto / Minuutit.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Ilmoitus / Kesto / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ilmoitus / Kesto / Minuutit.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Kontaktiverkosto / Minimipalkkio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Minimipalkkio / Kerroin.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Kontaktiverkosto / Vähimmäisarvo / Sijainti / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vähimmäisarvo / Sijainti / Hintakerroin.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Kontaktiverkosto / Muu / Huume / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Muu / Huume / Hintakerroin.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Kontaktiverkosto / Maksutili",
                    description = "Toiminta-asetus: Kontaktiverkosto / Maksutili.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Kontaktiverkosto / Toimituksen jälkeen / Kysyntä / Reset / sekuntia",
                    description = "Toiminta-asetus: Kontaktiverkosto / Toimituksen jälkeen / Kysyntä / Reset / sekuntia.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Kontaktiverkosto / Suosittu huume / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Suosittu huume / Hintakerroin.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Kontaktiverkosto / Alue / Sijainti / Luottamus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Alue / Sijainti / Luottamus.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Määrä / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Määrä / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Määrä / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Määrä / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Premium / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Premium / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Premium / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Premium / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Standardi / Enimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Standardi / Enimmäisarvo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Kontaktiverkosto / Pyyntö / Määrät / Standardi / Vähimmäisarvo",
                    description = "Toiminta-asetus: Kontaktiverkosto / Pyyntö / Määrät / Standardi / Vähimmäisarvo.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Kontaktiverkosto / Vaihto / Minuutit",
                    description = "Toiminta-asetus: Kontaktiverkosto / Vaihto / Minuutit.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Katukauppias / 3 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletusostaja / 3 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Oletuskauppias / 3 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Verkostokauppias / 3 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Premiumvälittäjä / 3 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 1 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 2 / Riski.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / W",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Koordinaatit / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Nimike.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Alue.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Riski",
                    description = "Toiminta-asetus: Kontaktiverkosto / Sijainti / Valintaryhmät / Tukkukontakti / 3 / Riski.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Hyväksymisbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Hyväksymisbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Perustyyppi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Perustyyppi.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Kysyntäbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Kysyntäbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Nimike.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 4",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Suositut huumeet / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Hintakerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Säde.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Alue.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 1 / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 1 / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Hyväksymisbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Hyväksymisbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Perustyyppi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Perustyyppi.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Kysyntäbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Kysyntäbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Nimike.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Minimilaatu",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Minimilaatu.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Suositut huumeet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Suositut huumeet / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Suositut huumeet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Suositut huumeet / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Hintakerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Säde.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Alue.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 2 / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 2 / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Hyväksymisbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Hyväksymisbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Perustyyppi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Perustyyppi.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Kysyntäbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Kysyntäbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Nimike.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Suositut huumeet / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Hintakerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Säde.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Alue.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 3 / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 3 / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Hyväksymisbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Hyväksymisbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Perustyyppi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Perustyyppi.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Kysyntäbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Kysyntäbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Nimike.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 3",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Suositut huumeet / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Hintakerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Säde.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Alue.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 4 / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 4 / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Hyväksymisbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Hyväksymisbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Perustyyppi",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Perustyyppi.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / X",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Koordinaatit / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Kysyntäbonus",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Kysyntäbonus.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Poliisin huomio / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Poliisin huomio / Kerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / ID",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Nimike",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Nimike.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Suositut huumeet / 1",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Suositut huumeet / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Suositut huumeet / 2",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Suositut huumeet / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Hintakerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Hintakerroin.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Säde",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Säde.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Alue",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Alue.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Kontaktiverkosto / Katu / Keskittymät / 5 / Ryöstö / Kerroin",
                    description = "Toiminta-asetus: Kontaktiverkosto / Katu / Keskittymät / 5 / Ryöstö / Kerroin.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Kontaktiverkosto / Luottamus / Tasot / Tunnettu",
                    description = "Toiminta-asetus: Kontaktiverkosto / Luottamus / Tasot / Tunnettu.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Kontaktiverkosto / Luottamus / Tasot / Luotettava",
                    description = "Toiminta-asetus: Kontaktiverkosto / Luottamus / Tasot / Luotettava.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Kontaktiverkosto / Luottamus / Tasot / Luotettu",
                    description = "Toiminta-asetus: Kontaktiverkosto / Luottamus / Tasot / Luotettu.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Yritysverkosto / Toiminnon viive / sekuntia",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminnon viive / sekuntia.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Yritysverkosto / Saldo / Perusarvo / Yksikköhinta",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Perusarvo / Yksikköhinta.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Yritysverkosto / Saldo / Verkoston kuumuus / Kauppiasta kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Verkoston kuumuus / Kauppiasta kohti.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Yritysverkosto / Saldo / Verkoston kuumuus / Jakelukeskusta kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Verkoston kuumuus / Jakelukeskusta kohti.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Yritysverkosto / Saldo / Verkoston kuumuus / Reittiä kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Verkoston kuumuus / Reittiä kohti.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Yritysverkosto / Saldo / Verkoston kuumuus / Työntekijää kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Verkoston kuumuus / Työntekijää kohti.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Yritysverkosto / Saldo / Luotettavuus / saanto",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Luotettavuus / saanto.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Yritysverkosto / Saldo / Luotettavuus / Tappio",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Luotettavuus / Tappio.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Yritysverkosto / Saldo / Reitti / Poliisin huomio / Rakenne",
                    description = "Toiminta-asetus: Yritysverkosto / Saldo / Reitti / Poliisin huomio / Rakenne.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / jengi / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / jengi / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / NPC-verkosto / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Organisaatio / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Organisaatio / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Premium / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Premium / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Myyjä / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Myyjä / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Erityinen / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Erityinen / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Määrä / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Määrä / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Määrä / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Määrä / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Vähimmäisarvo / Arvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Vähimmäisarvo / Arvo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Laatu / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Laatu / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Laatu / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Laatu / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Palkkio / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Palkkio / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Palkkio / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Palkkio / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Riski / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Riski / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Riski / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Luokat / Tukkukauppa / Riski / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Yritysverkosto / Sopimukset / Toimitusetäisyys",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Toimitusetäisyys.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Yritysverkosto / Sopimukset / Kesto / Minuutit / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Kesto / Minuutit / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Yritysverkosto / Sopimukset / Kesto / Minuutit / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Kesto / Minuutit / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / X",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Koordinaatit / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Nimike.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Alue",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Alue.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Palkkio / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Palkkio / Kerroin.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 1 / Riski.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / X",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Koordinaatit / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Nimike.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Alue",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Alue.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Palkkio / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Palkkio / Kerroin.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 2 / Riski.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / X",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Koordinaatit / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Nimike.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Alue",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Alue.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Palkkio / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Palkkio / Kerroin.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 3 / Riski.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / X",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / Y",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / Z",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Koordinaatit / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Nimike.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Alue",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Alue.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Palkkio / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Palkkio / Kerroin.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tapaaminen / Pisteet / 4 / Riski.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 3",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Ennakko / Asetukset / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Määrä / Neuvotteluvara / Prosentti",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Määrä / Neuvotteluvara / Prosentti.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Perusarvo / Hyväksyntä",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Perusarvo / Hyväksyntä.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Määräaika / Neuvotteluvara / Prosentti",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Määräaika / Neuvotteluvara / Prosentti.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Enimmäisarvo / Kierrokset",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Enimmäisarvo / Kierrokset.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Laatu / Neuvotteluvara",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Laatu / Neuvotteluvara.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Hylkäys / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Hylkäys / Jäähdytysminuutit.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Yritysverkosto / Sopimukset / Neuvottelu / Kierros / Paine",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Neuvottelu / Kierros / Paine.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Yritysverkosto / Sopimukset / Tarjous / Lukumäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Tarjous / Lukumäärä.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Yritysverkosto / Sopimukset / Päivitys / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Sopimukset / Päivitys / Minuutit.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Yritysverkosto / Oletusarvo / Yrityksen nimi",
                    description = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Yrityksen nimi.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Yritysverkosto / Oletusarvo / Arvo / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Arvo / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Yritysverkosto / Oletusarvo / Henkilöstö / Työtapa",
                    description = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Henkilöstö / Työtapa.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Yritysverkosto / Oletusarvo / Kuljetus",
                    description = "Toiminta-asetus: Yritysverkosto / Oletusarvo / Kuljetus.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Yritysverkosto / Käytössä",
                    description = "Toiminta-asetus: Yritysverkosto / Käytössä.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Yritysverkosto / Jakelukeskukset / Jakelukeskus / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Jakelukeskus / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Yritysverkosto / Jakelukeskukset / Jakelukeskus / Hankintahinta",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Jakelukeskus / Hankintahinta.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Yritysverkosto / Jakelukeskukset / Jakelukeskus / Turvallisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Jakelukeskus / Turvallisuus.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Yritysverkosto / Jakelukeskukset / Jakelukeskus / Ylläpito",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Jakelukeskus / Ylläpito.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Yritysverkosto / Jakelukeskukset / Kätkö / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Kätkö / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Yritysverkosto / Jakelukeskukset / Kätkö / Hankintahinta",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Kätkö / Hankintahinta.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Yritysverkosto / Jakelukeskukset / Kätkö / Turvallisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Kätkö / Turvallisuus.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Yritysverkosto / Jakelukeskukset / Kätkö / Ylläpito",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Kätkö / Ylläpito.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Yritysverkosto / Jakelukeskukset / Varasto / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Varasto / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Yritysverkosto / Jakelukeskukset / Varasto / Hankintahinta",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Varasto / Hankintahinta.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Yritysverkosto / Jakelukeskukset / Varasto / Turvallisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Varasto / Turvallisuus.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Yritysverkosto / Jakelukeskukset / Varasto / Ylläpito",
                    description = "Toiminta-asetus: Yritysverkosto / Jakelukeskukset / Varasto / Ylläpito.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Yritysverkosto / Rajat / Aktiiviset sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Rajat / Aktiiviset sopimukset.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Yritysverkosto / Rajat / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Rajat / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Yritysverkosto / Rajat / Kirjanpito / Rivit",
                    description = "Toiminta-asetus: Yritysverkosto / Rajat / Kirjanpito / Rivit.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Yritysverkosto / Rajat / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Rajat / Reitit.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Yritysverkosto / Rajat / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Rajat / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Yritysverkosto / Maksu / Tili",
                    description = "Toiminta-asetus: Yritysverkosto / Maksu / Tili.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Yritysverkosto / Arvot / 1 / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Yritysverkosto / Arvot / 1 / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Yritysverkosto / Arvot / 1 / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Yritysverkosto / Arvot / 1 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Yritysverkosto / Arvot / 1 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Nimike.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Yritysverkosto / Arvot / 1 / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Reitit.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Yritysverkosto / Arvot / 1 / Pistemäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Pistemäärä.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Yritysverkosto / Arvot / 1 / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 1 / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Yritysverkosto / Arvot / 2 / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Yritysverkosto / Arvot / 2 / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Yritysverkosto / Arvot / 2 / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Yritysverkosto / Arvot / 2 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Yritysverkosto / Arvot / 2 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Nimike.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Yritysverkosto / Arvot / 2 / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Reitit.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Yritysverkosto / Arvot / 2 / Pistemäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Pistemäärä.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Yritysverkosto / Arvot / 2 / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 2 / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Yritysverkosto / Arvot / 3 / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Yritysverkosto / Arvot / 3 / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Yritysverkosto / Arvot / 3 / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Yritysverkosto / Arvot / 3 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Yritysverkosto / Arvot / 3 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Nimike.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Yritysverkosto / Arvot / 3 / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Reitit.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Yritysverkosto / Arvot / 3 / Pistemäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Pistemäärä.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Yritysverkosto / Arvot / 3 / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 3 / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Yritysverkosto / Arvot / 4 / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Yritysverkosto / Arvot / 4 / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Yritysverkosto / Arvot / 4 / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Yritysverkosto / Arvot / 4 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Yritysverkosto / Arvot / 4 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Nimike.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Yritysverkosto / Arvot / 4 / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Reitit.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Yritysverkosto / Arvot / 4 / Pistemäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Pistemäärä.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Yritysverkosto / Arvot / 4 / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 4 / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Yritysverkosto / Arvot / 5 / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Yritysverkosto / Arvot / 5 / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Yritysverkosto / Arvot / 5 / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Yritysverkosto / Arvot / 5 / ID",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Yritysverkosto / Arvot / 5 / Nimike",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Nimike.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Yritysverkosto / Arvot / 5 / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Reitit.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Yritysverkosto / Arvot / 5 / Pistemäärä",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Pistemäärä.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Yritysverkosto / Arvot / 5 / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Arvot / 5 / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Yritysverkosto / Raportointijakso / päivää",
                    description = "Toiminta-asetus: Yritysverkosto / Raportointijakso / päivää.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Ostaja",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Ostaja.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Sopimus",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Sopimus.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Jälleenmyyjä",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Jälleenmyyjä.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / jengi",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / jengi.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Jakelukeskus",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Jakelukeskus.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Laboratorio",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Laboratorio.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Organisaatio",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Organisaatio.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Yritysverkosto / Reitti / Päätepiste / Tyypit / Myyjä",
                    description = "Toiminta-asetus: Yritysverkosto / Reitti / Päätepiste / Tyypit / Myyjä.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Toistuvuus / Minuutit / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Toistuvuus / Minuutit / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Toistuvuus / Minuutit / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Toistuvuus / Minuutit / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Odotusaika / Vähimmäisarvo / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Odotusaika / Vähimmäisarvo / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Epäonnistuminen / Luotettavuus / Tappio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Epäonnistuminen / Luotettavuus / Tappio.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Vähimmäisarvo / Toistuvuus / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Vähimmäisarvo / Toistuvuus / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Vähimmäisarvo / Tapaaminen / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Vähimmäisarvo / Tapaaminen / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimussakko / Kasvu",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimussakko / Kasvu.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimussakko / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimussakko / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Epäonnistuminen / Jäähdytysminuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Epäonnistuminen / Jäähdytysminuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Hinta / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Hinta / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Hinta / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Laatu / Hinta / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Laatu / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Luotettavuus / Tappio / Laatu / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Maine / Laatu / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Maine / Laatu / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Riski / Painotukset / Luokka",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Riski / Painotukset / Luokka.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Yritysverkosto / Toiminta pelissä / Sopimus / Riski / Painotukset / Tapaaminen",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Sopimus / Riski / Painotukset / Tapaaminen.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Jakelukeskus / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Jakelukeskus / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Jakelukeskus / Turvallisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Jakelukeskus / Turvallisuus.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Tapaaminen / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Tapaaminen / Riski.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Laatu",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Laatu.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Reittikapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Reittikapasiteetti.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Reitti / Aikaväli / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Reitti / Aikaväli / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Yritysverkosto / Toiminta pelissä / Oletusarvo / Reitti / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Oletusarvo / Reitti / Riski.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Poliisin huomio / Rakenne",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Poliisin huomio / Rakenne.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Kuormitus / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Kuormitus / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Hyökkäys / Palautuminen / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Hyökkäys / Palautuminen / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Hinta / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Hinta / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Hinta / Tasoa kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Hinta / Tasoa kohti.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Parannus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Turvallisuus / Parannus.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Maksamatta jättäminen / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Maksamatta jättäminen / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Maksamatta jättäminen / Turvallisuus / Tappio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Maksamatta jättäminen / Turvallisuus / Tappio.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Yritysverkosto / Toiminta pelissä / Jakelukeskus / Ylläpito / Aikaväli / Tunnit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Jakelukeskus / Ylläpito / Aikaväli / Tunnit.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Yritysverkosto / Toiminta pelissä / Alkuarvo / Luotettavuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Alkuarvo / Luotettavuus.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Yritysverkosto / Toiminta pelissä / Enimmäisarvo / Yrityksen nimi / Pituus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Enimmäisarvo / Yrityksen nimi / Pituus.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Sopimus / Toimitus / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Sopimus / Toimitus / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Toimitusetäisyys",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Toimitusetäisyys.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Kirjanpito / Rivit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Kirjanpito / Rivit.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Reitti / Aikaväli / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Vähimmäisarvo / Reitti / Aikaväli / Minuutit.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Ennakko / Hinta / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Ennakko / Hinta / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Ennakko / Hinta / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Ennakko / Hinta / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Hinta / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Hinta / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Neuvotteluvara / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Neuvotteluvara / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Riski / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Määrä / Riski / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Vastatarjous / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Vastatarjous / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Määräaika / Neuvotteluvara / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Määräaika / Neuvotteluvara / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Enimmäisarvo / Hyväksyntä",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Enimmäisarvo / Hyväksyntä.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Vähimmäisarvo / Hyväksyntä",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Vähimmäisarvo / Hyväksyntä.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Hyöty / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Hyöty / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Hinta / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Hinta / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Neuvotteluvara / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Neuvotteluvara / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Palkkio / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Laatu / Palkkio / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Luotettavuus / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Luotettavuus / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Maine / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Maine / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Pyydetty palkkio / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Pyydetty palkkio / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Pyydetty palkkio / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Pyydetty palkkio / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Hinta / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Hinta / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Palkkio / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Hyöty / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Hyöty / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Riski / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Riski / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Neuvottelu / Kiireellisyys / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Muu / Epäonnistuminen / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Muu / Epäonnistuminen / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilökohtainen huomio / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilökohtainen huomio / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Poliisi / Epäonnistuminen / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Poliisi / Epäonnistuminen / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Perusarvo / yksikköä",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Perusarvo / yksikköä.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Määrä / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Määrä / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Halpamyynti / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Halpamyynti / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Kokemus / Tasoa kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Kokemus / Tasoa kohti.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Kokemus / Yksikköä kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Kokemus / Yksikköä kohti.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Jakelukeskus / Poliisin huomio / Yksikköä kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Jakelukeskus / Poliisin huomio / Yksikköä kohti.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Premium / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Premium / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Taito / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Taito / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Yritysverkosto / Toiminta pelissä / Myyjä / Taito / saanto",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Myyjä / Taito / saanto.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Kesto / Perusarvo / sekuntia",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Kesto / Perusarvo / sekuntia.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Kesto / Yksikköä kohti / sekuntia",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Kesto / Yksikköä kohti / sekuntia.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 3",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 4",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Syyt / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Arvo / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Epäonnistuminen / Arvo / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Poliisin huomio / Määrä / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Poliisin huomio / Määrä / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Etsintäpaineen väheneminen / Hinta / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Etsintäpaineen väheneminen / Hinta / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Etsintäpaineen väheneminen / Hinta / Poliisihuomion pistettä kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Etsintäpaineen väheneminen / Hinta / Poliisihuomion pistettä kohti.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Uskollisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Uskollisuus.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Kuljettaja / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Kuljettaja / Riski.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Taito",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Riski / Painotukset / Taito.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Yritysverkosto / Toiminta pelissä / Reittien kierto / Etsintäpaineen väheneminen",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reittien kierto / Etsintäpaineen väheneminen.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Yritysverkosto / Toiminta pelissä / Reittien kierto / Riski / Vähennys",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reittien kierto / Riski / Vähennys.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Laadun perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Laadun perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Laatu / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Laatu / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Riski / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Myynti / Riski / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Reitti / Alku / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Reitti / Alku / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Yritysverkosto / Toiminta pelissä / Kuljettaja / Kokemus / Tasoa kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Kuljettaja / Kokemus / Tasoa kohti.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Yritysverkosto / Toiminta pelissä / Kuljettaja / Kokemus / Yksikköä kohti",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Kuljettaja / Kokemus / Yksikköä kohti.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Yritysverkosto / Toiminta pelissä / Kuljettaja / Epäonnistuminen / Uskollisuus / Tappio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Kuljettaja / Epäonnistuminen / Uskollisuus / Tappio.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Yritysverkosto / Toiminta pelissä / Kuljettaja / Epäonnistumisen riski / saanto",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Kuljettaja / Epäonnistumisen riski / saanto.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Yritysverkosto / Toiminta pelissä / Kuljettaja / Taito / saanto",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Kuljettaja / Taito / saanto.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Poliisin huomio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Poliisin huomio.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Luotettavuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Luotettavuus.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Maine",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Maine.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Rakenne",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Pistemäärä / Painotukset / Rakenne.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / kapasiteetti / Perusarvo / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / kapasiteetti / Perusarvo / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Uskollisuus / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Uskollisuus / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Uskollisuus / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Uskollisuus / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Riski / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Riski / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Riski / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Riski / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Taito / Enimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Taito / Enimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Taito / Vähimmäisarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkkaaminen / Taito / Vähimmäisarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Uskollisuus / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Uskollisuus / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Enimmäisarvo / Mahdollisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Enimmäisarvo / Mahdollisuus.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 3",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 4",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Tulokset / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Riski / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Välikohtaus / Riski / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Uskollisuus / Rakenne",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Uskollisuus / Rakenne.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Enimmäisarvo / Taso",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Enimmäisarvo / Taso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Kilpailevan rekrytoinnin uskollisuustappio",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Kilpailevan rekrytoinnin uskollisuustappio.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Hinta / Perusarvo",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Hinta / Perusarvo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Tunnit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Tunnit.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Välikohtaus / Vähennys",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Välikohtaus / Vähennys.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Riski / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Suojaus / Riski / Hinta.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palautuminen / Perusarvo / Mahdollisuus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palautuminen / Perusarvo / Mahdollisuus.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palautuminen / Uskollisuus / Painotus",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palautuminen / Uskollisuus / Painotus.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Perusarvo / Kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Perusarvo / Kerroin.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Uskollisuus / saanto",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Uskollisuus / saanto.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Taito / Jakaja",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Palkka / Taito / Jakaja.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 1",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 2",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 3",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 4",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 5",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 6",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Henkilöstö / Heikkoudet / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Sopimukset",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Sopimukset.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Jälleenmyyjät",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Jälleenmyyjät.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Jakelukeskukset",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Jakelukeskukset.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Reitit",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Reitit.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Henkilöstö",
                    description = "Toiminta-asetus: Yritysverkosto / Toiminta pelissä / Rakenne / Painotukset / Henkilöstö.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Yritysverkosto / Organisaatio / Käyttöoikeus",
                    description = "Toiminta-asetus: Yritysverkosto / Organisaatio / Käyttöoikeus.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Yritysverkosto / Henkilöstö / Myyjä / Perusarvo / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Myyjä / Perusarvo / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Yritysverkosto / Henkilöstö / Myyjä / Perusarvo / Palkka",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Myyjä / Perusarvo / Palkka.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Yritysverkosto / Henkilöstö / Myyjä / Provisio",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Myyjä / Provisio.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Yritysverkosto / Henkilöstö / Myyjä / Palkkaaminen / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Myyjä / Palkkaaminen / Hinta.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Yritysverkosto / Henkilöstö / Kuljettaja / Perusarvo / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Kuljettaja / Perusarvo / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Yritysverkosto / Henkilöstö / Kuljettaja / Perusarvo / Palkka",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Kuljettaja / Perusarvo / Palkka.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Yritysverkosto / Henkilöstö / Kuljettaja / Provisio",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Kuljettaja / Provisio.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Yritysverkosto / Henkilöstö / Kuljettaja / Palkkaaminen / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Henkilöstö / Kuljettaja / Palkkaaminen / Hinta.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Yritysverkosto / Päivitysjakso / Minuutit",
                    description = "Toiminta-asetus: Yritysverkosto / Päivitysjakso / Minuutit.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Lentokone / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Lentokone / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Yritysverkosto / Kuljetukset / Lentokone / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Lentokone / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Lentokone / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Lentokone / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Yritysverkosto / Kuljetukset / Lentokone / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Lentokone / Riski.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Vene / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Vene / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Yritysverkosto / Kuljetukset / Vene / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Vene / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Vene / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Vene / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Yritysverkosto / Kuljetukset / Vene / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Vene / Riski.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Auto / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Auto / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Yritysverkosto / Kuljetukset / Auto / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Auto / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Auto / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Auto / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Yritysverkosto / Kuljetukset / Auto / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Auto / Riski.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Jalan / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Jalan / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Yritysverkosto / Kuljetukset / Jalan / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Jalan / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Jalan / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Jalan / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Yritysverkosto / Kuljetukset / Jalan / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Jalan / Riski.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Kuorma-auto / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Kuorma-auto / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Yritysverkosto / Kuljetukset / Kuorma-auto / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Kuorma-auto / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Kuorma-auto / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Kuorma-auto / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Yritysverkosto / Kuljetukset / Kuorma-auto / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Kuorma-auto / Riski.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Yritysverkosto / Kuljetukset / Pakettiauto / kapasiteetti",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Pakettiauto / kapasiteetti.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Yritysverkosto / Kuljetukset / Pakettiauto / Hinta",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Pakettiauto / Hinta.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Yritysverkosto / Kuljetukset / Pakettiauto / Keston kerroin",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Pakettiauto / Keston kerroin.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Yritysverkosto / Kuljetukset / Pakettiauto / Riski",
                    description = "Toiminta-asetus: Yritysverkosto / Kuljetukset / Pakettiauto / Riski.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Yleinen integraatio",
                        custom = "Oma integraatio",
                        none = "Pois käytöstä",
                    },
                },
                reputationRules = {
                    label = "Maineen säännöt",
                    description = "Määritä nimetyt säännöt toiminnoille ja valinnaisille kohteille. Vain käytössä olevat säännöt antavat pisteitä.",
                },
            },
            territoryMap = {
                addPoint = "Lisää kohta",
                clear = "Tyhjennä",
                create = "Luo",
                custom = "Omat alueet",
                deletePoint = "Poista kohta",
                eyebrow = "Alueeditori",
                minimum = "Vähintään 3",
                pointCount = "{count} pistettä",
                presets = "Esiasetellut piirit",
                shown = "Näytetään kartalla",
                street = "Katu",
                supply = "Tarvike",
                territories = "Alueet",
                type = "Aluetyyppi",
                undo = "Peruuta",
            },
            shopPositionTools = {
                currentPosition = "Käytä nykyistä sijaintia",
                selectEntity = "Valitse kohde",
                selectEntityHint = "Suuntaa laseri kassaan tai kassakaappiin. Enter: käytä ympäröidyn esineen sijaintia ja suuntaa. Backspace: peruuta.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Kasvatustasot",
                general = "Yleinen",
                runtime = "Pelitoimintojen käyttöoikeus",
                quality = "Laatu",
                packaging = "Pakkaus",
                growing = "Kasvatus",
                labs = "Laboratoriot ja matkailuautot",
                power = "Virransyöttö ja laitteet",
                workers = "Työntekijät",
                market = "Markkinat ja jakelu",
                threats = "Ratsiat ja sabotaasi",
                pvpTakeovers = "Laboratorion valtaukset",
                consumption = "Käyttö",
                processing = "Prosessointi",
                performance = "Suorituskyky",
                dynamicMarket = "Dynaaminen markkina",
                heat = "Poliisin huomio ja riski",
                contacts = "Kontaktiverkosto",
                business = "Yritysverkosto",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Yleiset" },
                cultivationCurve = { label = "Tasokäyrä" },
                cultivationExperience = { label = "XP-palkinnot" },
                cultivationUnlocks = { label = "Tasojen avaukset" },
                creator = {
                    label = "Avaa editori",
                },
                creatorSettings = {
                    label = "Editorin asetukset",
                },
                interfaceHud = {
                    label = "Käyttöliittymän sijainnit",
                },
                drugsGeneral = {
                    label = "Yleinen",
                },
                runtimeAccess = {
                    label = "Käyttöoikeus ja omistus",
                },
                runtimePayouts = {
                    label = "Maksut",
                },
                runtimeDispatch = {
                    label = "Hätäkeskus ja poliisi",
                },
                qualityWeights = {
                    label = "Laatu / Painotukset",
                },
                qualityTiers = {
                    label = "Laatu / Laatutasot",
                },
                packagingGeneral = {
                    label = "Yleinen",
                },
                growingGeneral = {
                    label = "Yleinen",
                },
                plantDefaults = {
                    label = "Kasvi / Oletusarvot",
                },
                harvestWindow = {
                    label = "Sadonkorjuu / Aikaikkuna",
                },
                labsGeneral = {
                    label = "Yleinen",
                },
                labRent = {
                    label = "Vuokra ja elinkaari",
                },
                camperDefaults = {
                    label = "Asuntovaunu",
                },
                labUpgrades = {
                    label = "Parannukset",
                },
                labDefaults = {
                    label = "Laboratorio / Oletusarvot",
                },
                powerGeneral = {
                    label = "Yleinen",
                },
                generators = {
                    label = "Generaattorit",
                },
                equipmentWear = {
                    label = "Laitteet",
                },
                workersGeneral = {
                    label = "Yleinen",
                },
                marketGeneral = {
                    label = "Yleinen",
                },
                marketPrices = {
                    label = "Hinnat",
                },
                distribution = {
                    label = "Jakelu",
                },
                threatsGeneral = {
                    label = "Yleinen",
                },
                threatHeat = {
                    label = "Poliisin huomio",
                },
                threatChances = {
                    label = "Todennäköisyydet",
                },
                pvpTakeoverRules = {
                    label = "Valtaus säännöt",
                },
                pvpTakeoverZones = {
                    label = "Alueet & Ajoitus",
                },
                pvpTakeoverMethods = {
                    label = "Murtautumismenetelmät",
                },
                consumptionGeneral = {
                    label = "Yleinen",
                },
                consumerDecay = {
                    label = "Sietokyvyn ja riippuvuuden väheneminen",
                },
                consumerEffects = {
                    label = "Vaikutukset ja riskit",
                },
                processingFlow = {
                    label = "Käsittelyprosessi",
                },
                processingGeneral = {
                    label = "Yleinen",
                },
                powerRuntime = {
                    label = "Toiminta pelissä",
                },
                powerHeat = {
                    label = "Poliisin huomio ja sähköjälki",
                },
                powerModes = {
                    label = "Hallinta / Tilat",
                },
                powerPriorities = {
                    label = "Kuormitus / Prioriteetit",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Epäaktiivinen / Ohjaus / Aikaväli / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Vuorovaikutus / Tyhjäkäynti / Tarkistusväli / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Vuorovaikutus / Vuorovaikutuskehotus / Aikaväli / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Vuorovaikutus / Tarkistusväli / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Vähimmäisarvo / Tarkistusväli / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Katu / Ped / Aktivointi / Etäisyys",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Katu / Ped / Tyhjäkäynti / Tarkistusväli / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Katu / Ped / Tarkistusväli / ms",
                },
                performanceWorldCachePadding = {
                    label = "Maailma / Välimuisti / Lisämarginaali",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Maailma / Välimuisti / Päivitys / Aikaväli / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Maailma / Tyhjäkäynti / Aikaväli / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Toiminnon viive / sekuntia",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Toiminta / Historian raja",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Määrä / Kyllästys / Painotus",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Perusarvo / Tiedustelun tarkkuus",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Oletusarvo / Keskiarvo / Laatu",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Oletusarvo / Resurssi / Joustavuus",
                },
                dynamicMarketDemandCenter = {
                    label = "Kysyntä / Keskiarvo",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Kysyntä / Hinta / Vaikutus",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Suunta / Kynnysarvo",
                },
                dynamicMarketEnabled = {
                    label = "Käytössä",
                },
                dynamicMarketEventChance = {
                    label = "Tapahtuma / Mahdollisuus",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Tapahtuma / Kesto / Minuutit",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Tapahtuma / Vähimmäisarvo / Kesto / Minuutit",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Tapahtuma / Voimakkuus / Enimmäisarvo",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Tapahtuma / Voimakkuus / Vähimmäisarvo",
                },
                dynamicMarketEvents = {
                    label = "Tapahtumat",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Tarkat tiedot / Maine",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Tarkat tiedot / Luottamus",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Vyöhyke / Nimike",
                },
                dynamicMarketHistoryLimit = {
                    label = "Historian raja",
                },
                dynamicMarketInitialDemand = {
                    label = "Alkuarvo / Kysyntä",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Alkuarvo / Hintakerroin",
                },
                dynamicMarketIntelDemandError = {
                    label = "Tiedustelutiedot / Kysyntä / Virhe",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Tiedustelutiedot / Enimmäisarvo / Tarkkuus",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Tiedustelutiedot / Vähimmäisarvo / Tarkkuus",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Tiedustelutiedot / Poliisi / Virhe",
                },
                dynamicMarketIntelPriceError = {
                    label = "Tiedustelutiedot / Hinta / Virhe",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Tiedustelutiedot / Hinta / Enimmäisarvo",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Tiedustelutiedot / Hinta / Vähimmäisarvo",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Tiedustelutiedot / Maine / Painotus",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Tiedustelutiedot / Resurssi / Hinta / Virhe",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Tiedustelutiedot / Kyllästys / Virhe",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Tietojen satunnaissiemenen aikaväli / sekuntia",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Tiedustelutiedot / Tila / Tarkkuus / Kynnysarvo",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Tiedustelutiedot / Tila / Virhe / Kynnysarvo",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Tiedustelutiedot / Tarvike / Virhe",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Tiedustelutiedot / Luottamus / Painotus",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulointi / Jäähdytysminuutit",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulointi / Kysyntä / Muutos",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulointi / Kesto / Minuutit",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulointi / Poliisin huomio",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulointi / Vähimmäisarvo / Erä / Määrä",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulointi / Maksutili",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulointi / Hinta",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulointi / Vyöhyke / Poliisin huomio / Kerroin",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Enimmäisarvo / Tiedustelun ikä / Minuutit",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Enimmäisarvo / Hintakerroin",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Vähimmäisarvo / Tiedustelun ikä / Minuutit",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Vähimmäisarvo / Mittari / Aikaikkuna / Minuutit",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Minimihinta / Kerroin",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Vähimmäisarvo / Päivitys / Minuutit",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Poliisi / Kysyntä / Painotus",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Poliisi / Hinta / Vaikutus",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Heikko laatu / Kysyntä / Vähennys",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Heikko laatu / Kynnysarvo",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Huippulaatu / Kysyntäbonus",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Huippulaatu / Kynnysarvo",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Tuotanto / Tarvike / Painotus",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Tuotanto / Aikaikkuna / Minuutit",
                },
                dynamicMarketQualityCenter = {
                    label = "Laatu / Keskiarvo",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Laatu / Luottamus / Vaikutus",
                },
                dynamicMarketQualityRange = {
                    label = "Laatu / Arvoalue",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Harvinaisuus / Palkkio / Enimmäisarvo",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Alueellinen / Global / Painotus",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Alueellinen / Paikallinen / Painotus",
                },
                dynamicMarketResourceAliases = {
                    label = "Resurssi / Vaihtoehtoiset nimet",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Resurssi / Suunta / Lasku / Kynnysarvo",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Resurssi / Suunta / Nousu / Kynnysarvo",
                },
                dynamicMarketResources = {
                    label = "Resurssit",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Myynti / Aikaikkuna / Minuutit",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Kyllästys / Kysyntä / Painotus",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Kyllästys / Hinta / Vaikutus",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Niukkuus / Kysyntä / Painotus",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Niukkuus / Hinta / Vaikutus",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Vuodenaika / Loppu / Kuukaudet",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Vuodenaika / Kertoimet",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Puute / Huhu / Kynnysarvo",
                },
                dynamicMarketStatusThresholds = {
                    label = "Tila / Kynnysarvot",
                },
                dynamicMarketTargetSupply = {
                    label = "Kohde / Tarvike",
                },
                dynamicMarketTrendChance = {
                    label = "Suuntaus / Mahdollisuus",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Suuntaus / Kesto / Minuutit",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Suuntaus / Enimmäisarvo / Voimakkuus",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Suuntaus / Vähimmäisarvo / Voimakkuus",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Päivitys / Minuutit",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Hintavaihtelu / Enimmäisarvo",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Hintavaihtelu / Vähimmäisarvo",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Sää / Kertoimet",
                },
                dynamicMarketWeatherState = {
                    label = "Sää / Tila",
                },
                heatActionCooldownSeconds = {
                    label = "Toiminnon viive / sekuntia",
                },
                heatActivityRiskWeights = {
                    label = "Toiminta / Riski / Painotukset",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Aggressiivinen toimintatapa / Poliisin huomio / Kerroin",
                },
                heatBurnerBurnThreshold = {
                    label = "Kertakäyttöpuhelin / Paljastuminen / Kynnysarvo",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Kertakäyttöpuhelin / Poliisin huomio / Tukkukauppaa kohti",
                },
                heatBurnerPhoneItem = {
                    label = "Puhdeleva puhelin / Esine",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Matkailuauto toiminnassa / Poliisin huomio / Kerroin",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Matkailuauto toiminnassa / Poliisin huomio / Kynnysarvo",
                },
                heatCamperParkedHeat = {
                    label = "Pysäköity matkailuauto / Poliisin huomio",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Saastuminen / Poliisin huomio / Kerroin",
                },
                heatContaminatedThreshold = {
                    label = "Saastuminen / Kynnysarvo",
                },
                heatCultivationFreePlants = {
                    label = "Viljely / Kasvit ilman lisäriskiä",
                },
                heatCultivationHeatPerPlant = {
                    label = "Viljely / Poliisin huomio / Kasvia kohti",
                },
                heatDealerHiddenMinutes = {
                    label = "Jälleenmyyjä / piilotettu / Minuutit",
                },
                heatDecayPerTick = {
                    label = "Rakenne / Päivitysjaksoa kohti",
                },
                heatEnabled = {
                    label = "Käytössä",
                },
                heatEnforcementHeat = {
                    label = "Poliisin läsnäolo / Poliisin huomio",
                },
                heatEnforcementMultipliers = {
                    label = "Poliisin läsnäolo / Kertoimet",
                },
                heatEntityTypes = {
                    label = "Peliobjekti / Tyypit",
                },
                heatEventCooldownMinutes = {
                    label = "Tapahtuma / Jäähdytysminuutit",
                },
                heatEventHistoryLimit = {
                    label = "Tapahtuma / Historian raja",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratorio / Poliisin huomio / Synkronointi / Kynnysarvo",
                },
                heatLayLowCooldownMinutes = {
                    label = "Piiloutuminen / Jäähdytysminuutit",
                },
                heatLayLowIdleMinutes = {
                    label = "Piiloutuminen / Tyhjäkäynti / Minuutit",
                },
                heatLayLowReduction = {
                    label = "Piiloutuminen / Vähennys",
                },
                heatLockdownMinutes = {
                    label = "Lukitus / Minuutit",
                },
                heatMinimumDurationMinutes = {
                    label = "Vähimmäisarvo / Kesto / Minuutit",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Vähimmäisarvo / Tapahtuma / Lepoväli (sekuntia)",
                },
                heatMinimumIdleSeconds = {
                    label = "Vähimmäisarvo / Tyhjäkäynti / sekuntia",
                },
                heatProcessingHeatMultiplier = {
                    label = "Prosessointi / Poliisin huomio / Kerroin",
                },
                heatRiskWeights = {
                    label = "Riski / Painotukset",
                },
                heatRotateBurnerReduction = {
                    label = "Vaihda kertakäyttöpuhelin / Vähennys",
                },
                heatRouteControlMinutes = {
                    label = "Reitti / Ohjaus / Minuutit",
                },
                heatSaleHeat = {
                    label = "Myynti / Poliisin huomio",
                },
                heatThresholds = {
                    label = "Kynnysarvot",
                },
                heatTickMinutes = {
                    label = "Päivitysjakso / Minuutit",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Tukkukauppa / Poliisin huomio / Kerroin",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Työntekijä / Tietovuoto / Hälytyssäde",
                },
                heatWorkerLeakBaseChance = {
                    label = "Työntekijä / Tietovuoto / Perusarvo / Mahdollisuus",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Työntekijä / Tietovuoto / Faktio / Kerroin",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Työntekijä / Tietovuoto / Korkea / Vakavuus / Kynnysarvo",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Työntekijä / Tietovuoto / Uskollisuus / Mahdollisuus / Kerroin",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Työntekijä / Tietovuoto / Uskollisuus / Kynnysarvo",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Työntekijä / Tietovuoto / Enimmäisarvo / Mahdollisuus",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Työntekijä / Tietovuoto / Vähimmäisarvo / Lepoväli (sekuntia)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Työntekijä / Tietovuoto / Reitti / Kerroin",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Työntekijä / Tietovuoto / Voimakkuus / Enimmäisarvo",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Työntekijä / Tietovuoto / Voimakkuus / Vähimmäisarvo",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Työntekijä / Tietovuoto / Voimakkuus / Kerroin",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Työntekijä / Tietovuoto / Stressi / Mahdollisuus / Kerroin",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Työntekijä / Tietovuoto / Stressi / Kynnysarvo",
                },
                contactsActionCooldownSeconds = {
                    label = "Toiminnon viive / sekuntia",
                },
                contactsActiveHotspotCount = {
                    label = "Aktiivisten kohteiden määrä",
                },
                contactsBurnerHintTrust = {
                    label = "Pöytäpuhelin-vihje / Luottamus",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Kertakäyttöpuhelin / Tarjous / Enimmäisarvo / Kerroin",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Kertakäyttöpuhelin / Tarjous / Vähimmäisarvo / Kerroin",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Ostaja / Jäähdytysminuutit",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Ostaja / Toimitusetäisyys",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Ostaja / Premium / Onnistuminen / Pistemäärä",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Ostaja / Premium / Luottamus / saanto",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Ostaja / Pyyntö / Poliisi & etsintäpaino / Painotus",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Ostaja / Standardi / Luottamus / saanto",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Kontaktin aktivointiviive / sekuntia",
                },
                contactsContactDemandRange = {
                    label = "Yhteystiedot / Kysyntä / Arvoalue",
                },
                contactsContactLossTrust = {
                    label = "Yhteystiedot / Tappio / Luottamus",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Pimeä verkko / Tarkat tiedot / Minuutit",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Pimeä verkko / Keskittymä / Tiedustelutiedot / Hinta",
                },
                contactsDarknetIntelPrice = {
                    label = "Pimeä verkko / Tiedustelutiedot / Hinta",
                },
                contactsDealerBasePrice = {
                    label = "Jälleenmyyjä / Perushinta",
                },
                contactsDealerHireCapacity = {
                    label = "Jälleenmyyjä / Palkkaaminen / kapasiteetti",
                },
                contactsDealerHireRisk = {
                    label = "Jälleenmyyjä / Palkkaaminen / Riski",
                },
                contactsDealerHireSkill = {
                    label = "Jälleenmyyjä / Palkkaaminen / Taito",
                },
                contactsDealerOffers = {
                    label = "Jälleenmyyjän tarjoukset",
                },
                contactsDealerProtectionHours = {
                    label = "Jälleenmyyjä / Suojaus / Tunnit",
                },
                contactsDealerProtectionPrice = {
                    label = "Jälleenmyyjä / Suojaus / Hinta",
                },
                contactsDealerSaleMax = {
                    label = "Jälleenmyyjä / Myynti / Enimmäisarvo",
                },
                contactsDealerSaleMin = {
                    label = "Jälleenmyyjä / Myynti / Vähimmäisarvo",
                },
                contactsDealerSimulation = {
                    label = "Jälleenmyyjä / Simulaatio",
                },
                contactsDealerTickMinutes = {
                    label = "Jälleenmyyjä / Päivitysjakso / Minuutit",
                },
                contactsDealerWage = {
                    label = "Jälleenmyyjä / Palkka",
                },
                contactsDealerWageDecay = {
                    label = "Jälleenmyyjä / Palkka / Rakenne",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Jälleenmyyjä / Palkka / Uskollisuus / saanto",
                },
                contactsDealerWeaknesses = {
                    label = "Jälleenmyyjä / Heikkoudet",
                },
                contactsDefaultContactDemand = {
                    label = "Oletusarvo / Yhteystiedot / Kysyntä",
                },
                contactsDefaultContactRisk = {
                    label = "Oletusarvo / Yhteystiedot / Riski",
                },
                contactsDefaultDealerCapacity = {
                    label = "Oletuskauppias / kapasiteetti",
                },
                contactsDefaultDealerRisk = {
                    label = "Oletuskauppias / Riski",
                },
                contactsDefaultDealerSkill = {
                    label = "Oletuskauppias / Taito",
                },
                contactsDefaultHotspotRadius = {
                    label = "Oletusarvo / Keskittymä / Säde",
                },
                contactsDemandResetMinutes = {
                    label = "Kysynnän nollaus (minuuttia)",
                },
                contactsEnabled = {
                    label = "Käytössä",
                },
                contactsExactLocationTrust = {
                    label = "Tarkka sijainti / Luottamus",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Faktio / Löytäminen / Maine",
                },
                contactsFactionHintTrust = {
                    label = "Faktio / Vihje / Luottamus",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Epäonnistunut toimitus / Jäähdytysminuutit",
                },
                contactsFakeDealEncounter = {
                    label = "Valekauppa / Kohtaaminen",
                },
                contactsFallbackPreferredDrug = {
                    label = "Vara-arvo / Suosittu huume",
                },
                contactsFallbackProductLabel = {
                    label = "Vara-arvo / Tuotteen nimi",
                },
                contactsGuideBookItem = {
                    label = "Opas / Kirja / Esine",
                },
                contactsGuideBookTrust = {
                    label = "Opas / Kirja / Luottamus",
                },
                contactsHireDealerPrice = {
                    label = "Palkkaa jälleenmyyjä / Hinta",
                },
                contactsHistoryLimit = {
                    label = "Historian raja",
                },
                contactsHotspotIntelMinutes = {
                    label = "Keskittymä / Tiedustelutiedot / Minuutit",
                },
                contactsHotspotRotationMinutes = {
                    label = "Keskittymä / Vaihto / Minuutit",
                },
                contactsListingDurationMinutes = {
                    label = "Ilmoitus / Kesto / Minuutit",
                },
                contactsMaxOwnedDealers = {
                    label = "Enimmäisarvo / Omistettu / Jälleenmyyjät",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Vähimmäisarvo / Ostaja / Toimitusetäisyys",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Vähimmäisarvo / Kontakti-vuoro (minuuttia)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Vähimmäisarvo / Kysynnän nollaus (minuuttia)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Vähimmäisarvo / Poliisin huomio / Kerroin",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Vähimmäisarvo / Keskittymä / Tiedustelutiedot / Minuutit",
                },
                contactsMinimumHotspotRadius = {
                    label = "Vähimmäisarvo / Keskittymä / Säde",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Vähimmäisarvo / Keskittymä / Vaihto / Minuutit",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Vähimmäisarvo / Ilmoitus / Kesto / Minuutit",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Minimipalkkio / Kerroin",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Vähimmäisarvo / Ryöstö / Kerroin",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Vähimmäisarvo / Sijainti / Hintakerroin",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Muu / Huume / Hintakerroin",
                },
                contactsPaymentAccount = {
                    label = "Maksutili",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Toimituksen jälkeen / Kysyntä / Reset / sekuntia",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Suosittu huume / Hintakerroin",
                },
                contactsRegionLocationTrust = {
                    label = "Alue / Sijainti / Luottamus",
                },
                contactsRequestAmounts = {
                    label = "Pyyntö / Määrät",
                },
                contactsRotationMinutes = {
                    label = "Vaihto / Minuutit",
                },
                contactsSpotPools = {
                    label = "Sijainti / Valintaryhmät",
                },
                contactsStreetHotspots = {
                    label = "Katu / Keskittymät",
                },
                contactsTrustLevels = {
                    label = "Luottamus / Tasot",
                },
                businessActionCooldownSeconds = {
                    label = "Toiminnon viive / sekuntia",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Sopimukset",
                },
                businessDefaultBusinessName = {
                    label = "Oletusarvo / Yrityksen nimi",
                },
                businessDefaultRankId = {
                    label = "Oletusarvo / Arvo / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Oletusarvo / Henkilöstö / Työtapa",
                },
                businessDefaultTransport = {
                    label = "Oletusarvo / Kuljetus",
                },
                businessEnabled = {
                    label = "Käytössä",
                },
                businessHubs = {
                    label = "Jakelukeskukset",
                },
                businessLimits = {
                    label = "Rajat",
                },
                businessPayments = {
                    label = "Maksut",
                },
                businessPayoutAccount = {
                    label = "Maksu / Tili",
                },
                businessRanks = {
                    label = "Arvot",
                },
                businessReportDays = {
                    label = "Raportointijakso / päivää",
                },
                businessRouteEndpointTypes = {
                    label = "Reitti / Päätepiste / Tyypit",
                },
                businessRuntime = {
                    label = "Toiminta pelissä",
                },
                businessSocietyPermission = {
                    label = "Organisaatio / Käyttöoikeus",
                },
                businessStaff = {
                    label = "Henkilöstö",
                },
                businessTickMinutes = {
                    label = "Päivitysjakso / Minuutit",
                },
                businessTransports = {
                    label = "Kuljetukset",
                },
            },
            territorySettings = {
                section = "Alueet",
                zonesGroup = "Territoriovyöhykkeet",
                sourceLabel = "Vyöhykkeen lähde",
                sourceDescription = "Käytä suojattuja esiaseteltuja piirejä tai määritä omat territoriopolygonisi.",
                sourcePreset = "Esiasetellut piirit",
                sourceCustom = "Omat territoriot",
                editLabel = "Territorion muokkain",
                editDescription = "Muokkaa valitun vyöhykkeen lähteen käyttämiä piirejä.",
                editButton = "Muokkaa territorioita",
                presetSection = "Esiasetellut piirit",
                presetEntry = "Esiaseteltu piiri",
                customSection = "Omat territoriot",
                customEntry = "Oma territorio",
                typeLabel = "Territoriotyyppi",
                streetType = "Katu",
                supplyType = "Tarvike",
                enabledLabel = "Näytetään kartalla",
                enabledDescription = "Poistetut esiasetellut piirit poistetaan kartalta, eikä niitä voi vallata.",
                zoneLabel = "Territorion raja",
                zoneDescription = "Lisää vähintään kolme pistettä peräkkäin territorion rajan ympärille.",
                ownershipGroup = "Omistus",
                decayGroup = "Rakenne",
                presenceGroup = "Läsnäolo",
                activityGroup = "Aktiivisuuden pisteytys",
                ownershipBenefitsGroup = "Omistajuusetu",
                ownershipThresholdLabel = "Omistajuuskynnys",
                ownershipThresholdDescription = "Hallintoprosentti, jonka jengin on ylitettävä omistaakseen territorion virallisesti.",
                activityFloorLabel = "Kiinteä aktiivisuuden alaraja",
                activityFloorDescription = "Vaadittavat vaikutuspisteet, kun kokoon perustuvat alarajat on poistettu käytöstä.",
                floorByZoneSizeLabel = "Skaalaa alaraja vyöhykkeen koon mukaan",
                floorByZoneSizeDescription = "Laskee kunkin territorion aktiivisuuden alarajan sen polygonipinta-alan perusteella kiinteän alarajan sijaan.",
                floorPointsPerSizeUnitLabel = "Alarajapisteet per km²",
                floorPointsPerSizeUnitDescription = "Vaadittavat aktiivisuuspisteet jokaista territorion neliökilometriä kohden.",
                fixedFloorRequirement = "Poista kokoon perustuvat alarajat muokataksesi kiinteää aktiivisuuden alarajaa.",
                sizeFloorRequirement = "Ota kokoon perustuvat alarajat käyttöön muokataksesi pisteitä per neliökilometri.",
                dailyDecayLabel = "Päivittäinen vaikutuksen väheneminen",
                dailyDecayDescription = "Vaikutuksesta poistuva prosenttiosuus 24 tunnin välein.",
                presenceIntervalLabel = "Läsnäolointervalli",
                presenceIntervalDescription = "Minuutit automaattisten läsnäolopisteiden välillä.",
                presencePointsLabel = "Läsnäolopisteet per jäsen",
                presencePointsDescription = "Läsnäolopisteet, jotka kukin oikeutettu jengin jäsen saa per intervalli.",
                drugSalesEnabledLabel = "NPC-myynnit antavat territorion vaikutusvaltaa",
                drugSalesEnabledDescription = "Onnistuneet katukaupat NPC:ille antavat myyjän jengille vaikutusvaltaa nykyisellä katualueella.",
                drugSalePointsLabel = "Pisteet per myyty huume",
                drugSalePointsDescription = "Vaikutuspisteet jokaisesta myydyksi ilmoitetusta huumeyksiköstä.",
                drugSalesRequirement = "Ota NPC-myynnin vaikutus käyttöön muokataksesi sen pisteitä.",
                graffitiPointsLabel = "Graffitipisteet per 24 tuntia",
                graffitiPointsDescription = "Läsnäolopisteet, kun yksi graffiti on ollut olemassa yhteensä 24 ilmoitettua tuntia.",
                streetSellingPriceBonusLabel = "Katukaupan hinnan bonus",
                streetSellingPriceBonusDescription = "Lisätty prosenttiosuus huumeiden myyntihintoihin katualueen viralliselle omistajalle.",
                supplyProductionSpeedBonusLabel = "Tarvikkeiden tuotantonopeuden bonus",
                supplyProductionSpeedBonusDescription = "Lisätty prosenttiosuus huumeiden tuotantonopeuteen tarviketerritorion viralliselle omistajalle.",
                pruneToleranceLabel = "Vaikutuksen karsimisen sietokyky",
                pruneToleranceDescription = "Tehollinen vaikutus alle tämän arvon katsotaan nollaksi.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Yleinen",
                streamingGroup = "Renderöinti",
                moderationGroup = "Moderaatio",
                graffitiEnabledLabel = "Ota graffitit käyttöön",
                graffitiEnabledDescription = "Salli pelaajien sprayata ja tarkastella graffiteja.",
                graffitiRequireItemLabel = "Vaatii spray-tölkin",
                graffitiRequireItemDescription = "Pelaajien on käytettävä spray-tölkkiä sprayatessaan. Muussa tapauksessa käytetään /graffiti-komentoa.",
                graffitiChargesPerCanLabel = "Lataukset per tölkki",
                graffitiChargesPerCanDescription = "Kuinka monta graffitia yhdellä spray-tölkillä voi tehdä.",
                graffitiCooldownSecondsLabel = "Spray-viive",
                graffitiCooldownSecondsDescription = "Sekunnit, jotka pelaajan on odotettava spraytausten välillä.",
                graffitiMaxPerPlayerLabel = "Max. graffitit per pelaaja",
                graffitiMaxPerPlayerDescription = "Enimmäismäärä aktiivisia graffiteja, joita yksi pelaaja voi omistaa. 0 tarkoittaa rajoitonta.",
                graffitiMaxDistanceLabel = "Max. spray-etäisyys",
                graffitiMaxDistanceDescription = "Kuinka kaukana seinä voi olla, jotta siihen voi vielä sprayata, metreinä.",
                graffitiSprayDurationLabel = "Spray-kesto",
                graffitiSprayDurationDescription = "Kuinka kauan spray-animaatio kestää, millisekunteina.",
                graffitiExpiryDaysLabel = "Vanhentumisaika",
                graffitiExpiryDaysDescription = "Päivät, ennen kuin graffiti katoaa automaattisesti. 0 tarkoittaa ei koskaan.",
                graffitiTerritoryHoursLabel = "Alueen tuntitunnit per spray",
                graffitiTerritoryHoursDescription = "Alueen läsnäoloaika (tunnit), jonka tuore graffiti antaa gangilleen.",
                graffitiStreamRadiusLabel = "Stream-säde",
                graffitiStreamRadiusDescription = "Etäisyys metreinä, jolla graffitit tulevat pelaajien näkyville.",
                graffitiPoolSizeLabel = "Decal-poolin koko",
                graffitiPoolSizeDescription = "Kuinka monta graffitia renderöidään kerralla. Korkeammat arvot kuluttavat enemmän suorituskykyä.",
                graffitiReportsEnabledLabel = "Ota raportit käyttöön",
                graffitiReportsEnabledDescription = "Salli pelaajien raportoida loukkaavia graffiteja.",
                graffitiAutoHideThresholdLabel = "Automaattisen piilottamisen kynnys",
                graffitiAutoHideThresholdDescription = "Raporttien määrä, joka piilottaa graffitin automaattisesti. 0 poistaa tämän käytöstä.",
            },
            darknetSettings = {
                section = "Darknet-markkinat",
                availabilityGroup = "Käytettävyys",
                economyGroup = "Kryptovaluutta",
                listingsGroup = "Ilmoitukset ja vanhentuminen",
                chatGroup = "Yksityischat",
                identityGroup = "Aliakset ja maine",
                deliveryGroup = "Luovutukset ja Dead Dropit",
                policeGroup = "Poliisin pääsy",
                npcGroup = "NPC-kauppiaat",
                enabledLabel = "Ota Darknet-markkinat käyttöön",
                enabledDescription = "Aktivoi mustan pörssin tablettisovellus ja sen taustaprosessi.",
                tabletOrderLabel = "Tablettisovelluksen järjestys",
                tabletOrderDescription = "Määrittää Darknet-markkinoiden sijainnin tabletilla.",
                currencyCodeLabel = "Valuuttakoodi",
                currencyCodeDescription = "Lyhyt tunniste sisäiselle kryptovaluuttatilille.",
                starterBalanceLabel = "Uuden lompakon saldo",
                starterBalanceDescription = "Kryptovaluuttaa myönnetään vain, kun pelaaja avaa markkinat ensimmäistä kertaa.",
                exchangeEnabledLabel = "Ota kolikoiden vaihto käyttöön",
                exchangeEnabledDescription = "Sallii tunnistautuneiden BlackBay-käyttäjien ostaa ja myydä kolikoita omalla tilisivullaan.",
                exchangeAccountLabel = "Kolikoiden vaihdon maksutili",
                exchangeAccountDescription = "Framework-tili, jota käytetään kolikoiden ostoihin ja myyntien maksuihin.",
                exchangeBuyPriceLabel = "Ostopreki per kolikko",
                exchangeBuyPriceDescription = "Määrä, joka veloitetaan maksutililtä yhdestä kolikosta.",
                exchangeSellPriceLabel = "Myyntihinta per kolikko",
                exchangeSellPriceDescription = "Yhdelle kolikolle maksun tilille maksettava summa.",
                exchangeMinimumLabel = "Minimi-kolikot per vaihto",
                exchangeMinimumDescription = "Pienin hyväksytty kokonaiskolikoiden määrä yhdessä vaihdossa.",
                exchangeMaximumLabel = "Maksimi-kolikot per vaihto",
                exchangeMaximumDescription = "Suurin hyväksytty kokonaiskolikoiden määrä yhdessä vaihdossa.",
                accountMoney = "Käteinen",
                accountBank = "Pankki",
                accountBlackMoney = "Likainen raha",
                scamChanceLabel = "Globaali NPC-huijausmahdollisuus (%)",
                scamChanceDescription = "Minimimahdollisuus, että NPC-kauppa ottaa maksun tai tavarat toimittamatta vastinetta. Korkeampi kauppakohtainen todennäköisyys on edelleen voimassa.",
                listingExpiryLabel = "Tarjouksen voimassaolo (tuntia)",
                listingExpiryDescription = "Aktiiviset tarjoukset vanhenevat automaattisesti näiden tuntien jälkeen.",
                renewalHoursLabel = "Uudistuksen kesto (tuntia)",
                renewalHoursDescription = "Lisätunnit, kun omistaja uudistaa tarjouksen.",
                maximumListingsLabel = "Maksimimäärä aktiivisia tarjouksia",
                maximumListingsDescription = "Maksimimäärä tarjouksia per aktiivinen alias.",
                maximumQuantityLabel = "Tavaroiden enimmäismäärä",
                maximumQuantityDescription = "Yläraja yhden tarjouksen tavaramäärälle.",
                maximumPriceLabel = "Maksimiyksikköhinta",
                maximumPriceDescription = "Yläraja kryptohinnalle per yksikkö.",
                maximumMessageLengthLabel = "Maksimi viestin pituus",
                maximumMessageLengthDescription = "Maksimimerkkimäärä salattuun chatviestiin.",
                aliasCooldownLabel = "Aliaksen vaihtoväli (tuntia)",
                aliasCooldownDescription = "Identiteetin vähimmäisikä ennen kuin se voidaan poistaa käytöstä uudelleen.",
                verifiedSalesLabel = "Vahvistamiseen vaadittavat myynnit",
                verifiedSalesDescription = "Tarvittavat onnistuneet myynnit, ennen kuin myyjä voi tulla vahvistetuksi.",
                verifiedRatingLabel = "Vahvistamiseen vaadittu luokitus",
                verifiedRatingDescription = "Minimiarvosana vahvistetulle myyjälle.",
                scammerReportsLabel = "Ilmoitukset huijarivaroitusta varten",
                scammerReportsDescription = "Ainutlaatuiset kauppailmoitukset tunnetun huijarin merkin saamiseksi.",
                meetingDistanceLabel = "Luovutusetäisyys",
                meetingDistanceDescription = "Maksimietäisyys molempien pelaajien tai konfiguroidun NPC-pisteen välillä.",
                dropModelLabel = "Dead-drop-laatikon malli",
                dropModelDescription = "GTA-prop-malli, joka luodaan paikallisesti saatavilla olevia dead droppeja varten.",
                dropStreamLabel = "Dead-drop-latausetäisyys",
                dropStreamDescription = "Etäisyys, jolla laatikot ja NPC-tapaamiskontaktit ladataan.",
                dropInteractionLabel = "Dead-drop-vuorovaikutusetäisyys",
                dropInteractionDescription = "Etäisyys, joka vaaditaan laatikon tutkimiseen ja lunastamiseen.",
                dropLifetimeLabel = "Dead-drop-kesto (tuntia)",
                dropLifetimeDescription = "Aika, jonka jälkeen lunastamaton laatikko vanhenee.",
                dropPollLabel = "Maailman päivitysväli (ms)",
                dropPollDescription = "Väli, jota käytetään lähellä olevien laatikoiden ja NPC-tapaamisten päivittämiseen.",
                policeGroupsLabel = "Valtuutetut poliisiryhmät",
                policeGroupsDescription = "Job Configurator -ryhmän avaimet, jotka voivat julkaista syöttitarjouksia ja tarkastella tutkimuksia.",
                policeGroupEntry = "Poliisiryhmä",
                groupKeyLabel = "Ryhmän avain",
                npcTradersLabel = "NPC-ostajat ja -myyjät",
                npcTradersDescription = "Konfiguroi pysyvät synteettiset tarjoukset, toimitustapa, maine ja huijaus-todennäköisyys.",
                npcTraderEntry = "NPC-kauppias",
                npcIdLabel = "ID",
                npcAliasLabel = "Nimimerkki",
                npcSideLabel = "Markkinapuoli",
                sideSell = "Myy pelaajille",
                sideBuy = "Osta pelaajilta",
                npcTitleLabel = "Tarjouksen otsikko",
                npcDescriptionLabel = "Kuvaus",
                npcItemNameLabel = "Inventaarion esineen nimi",
                npcItemLabelLabel = "Tavaran nimi",
                npcQuantityLabel = "Määrä",
                npcPriceLabel = "Yksikköhinta",
                npcDeliveryLabel = "Toimitustapa",
                deliveryBoth = "Tapaaminen ja dead drop",
                deliveryMeeting = "Vain kasvokkain",
                deliveryDrop = "Vain dead drop",
                npcScamChanceLabel = "Kauppiaan huijausmahdollisuus (%)",
                npcPedModelLabel = "NPC-ped-malli",
                npcRatingLabel = "Näytetty arvosana",
                npcRatingCountLabel = "Näytetty arvosanojen määrä",
                npcTradesLabel = "Näytetyt onnistuneet kaupat",
                npcVerifiedLabel = "Vahvistettu kauppias",
                npcScammerLabel = "Tunnettu huijari",
                npcEnabledLabel = "Aktiivinen",
            },
            interrogationSettings = {
                section = "Kuulustelu",
                generalGroup = "Yleinen",
                consentGroup = "Pelaajansuojaus",
                objectGroup = "Kohteet",
                grabGroup = "Kiinniotto",
                sessionGroup = "Istunto",
                dispatchGroup = "Poliisihälytykset",
                loggingGroup = "Lokitus",
                securityGroup = "Turvallisuus",
                presentationGroup = "Esitys",
                enabledLabel = "Ota kuulustelujärjestelmä käyttöön",
                enabledDescription = "Salli pelaajien sitoa muita kuulustelutuoleihin ja käyttää heihin työkaluja.",
                consentRequiredLabel = "Vaatii suostumuksen",
                consentRequiredDescription = "Vain pelaajat, jotka ovat antaneet suostumuksensa, voivat joutua uhreiksi. Suostumus ei enää tapahdu automaattisesti, joten tämä vaatii alla olevan asetuksen.",
                consentDefaultLabel = "Oletuksena suostumus annettu",
                consentDefaultDescription = "Uudet hahmot aloittavat suostumus annettu -tilassa sen sijaan, että se olisi kieltäytynyt.",
                globalIntensityLabel = "Vaikutuksen voimakkuus",
                globalIntensityDescription = "Säädätää näyttöefektejä, partikkeleita ja ääntä. 0 kytkee ne kokonaan pois.",
                maxPerPlayerLabel = "Kohteita per pelaaja",
                maxPerPlayerDescription = "Kuinka monta tuolia ja kärryä yksi pelaaja saa asettaa. 0 tarkoittaa rajoitonta.",
                maxGlobalLabel = "Kohteita koko palvelimella",
                maxGlobalDescription = "Kuinka monta asetettua kohdetta on sallittu kerrallaan. 0 tarkoittaa rajoitonta.",
                placementDistanceLabel = "Sijoitusetäisyys",
                placementDistanceDescription = "Kuinka kaukana pelaajasta kohde saa olla, metreinä.",
                interactDistanceLabel = "Vuorovaikutusetäisyys",
                interactDistanceDescription = "Kuinka lähellä pelaajan on oltava käyttääkseen tuolia tai kärryä, metreinä.",
                inactivityMinutesLabel = "Automaattinen poisto",
                inactivityMinutesDescription = "Minuutteja ilman käyttöä, ennen kuin asetettu kohde katoaa. 0 pitää sen ikuisesti.",
                persistObjectsLabel = "Säilytä kohteet uudelleenkäynnistyksen jälkeen",
                persistObjectsDescription = "Asetetut kohteet palautetaan tietokannasta, kun palvelin käynnistyy uudelleen.",
                grabEnabledLabel = "Ota kiinni -toiminto päälle",
                grabEnabledDescription = "Salli pelaajien ylivoimistaa ja kantaa toinen pelaaja pois.",
                grabItemLabel = "Vaadittu esine",
                grabItemDescription = "Esine, jota hyökkääjä tarvitsee kantaakseen jonkun. Jätä tyhjäksi, jos mitään ei vaadita.",
                grabAngleLabel = "Lähestymiskulma",
                grabAngleDescription = "Kuinka monta astetta hyökkääjän on oltava sivussa suoraan takaa.",
                grabHealthBelowLabel = "Terveysraja",
                grabHealthBelowDescription = "Uhri, jonka terveys on tämän alapuolella, voidaan ottaa kiinni ilman sitomista. 0 poistaa tämän käytöstä.",
                grabCooldownLabel = "Viive epäonnistumisen jälkeen",
                grabCooldownDescription = "Sekunnit, ennen kuin epäonnistuneen kiinnioton voi yrittää uudelleen.",
                grabVehiclesLabel = "Sallitut ajoneuvot",
                grabVehiclesDescription = "Ajoneuvomallit, joihin kiinniotettu uhri voidaan lastata.",
                carryEnabledLabel = "Salli kantaminen",
                carryEnabledDescription = "Hyökkääjä voi kantaa uhrin olkapäällään.",
                restrictVisionLabel = "Rajoita uhrin näkökenttää",
                restrictVisionDescription = "Pimentää uhrin näytön kuljetuksen aikana.",
                escapeEnabledLabel = "Salli pakoyritykset",
                escapeEnabledDescription = "Salli kuljetettavan uhrin yrittää vapautua.",
                escapeSecondsLabel = "Pakoaika",
                escapeSecondsDescription = "Sekunnit, jotka uhrin on pidettävä näppäintä vapautuakseen.",
                maxDurationLabel = "Enimmäiskesto",
                maxDurationDescription = "Minuutit, joiden jälkeen istunto päättyy itsestään.",
                warnMinutesLabel = "Varoitus ennen loppua",
                warnMinutesDescription = "Minuutit ennen rajaa, jolloin molemmat osapuolet varoitetaan.",
                idleMinutesLabel = "Vapautus toimettomuuden jälkeen",
                idleMinutesDescription = "Minuutit ilman mitään vuorovaikutusta, ennen kuin uhri vapautetaan.",
                selfReleaseMinutesLabel = "Itsevapautuminen",
                selfReleaseMinutesDescription = "Minuutit ilman hyökkääjän vuorovaikutusta, ennen kuin uhri voi vapauttaa itsensä.",
                graceSecondsLabel = "Arma-aika katkaisun jälkeen",
                graceSecondsDescription = "Sekunnit, jotka uhri pysyy sidottuna, kun hyökkääjä poistuu palvelimelta.",
                rescueEnabledLabel = "Salli pelastukset",
                rescueEnabledDescription = "Salli sivullisten pelastaa sidottu uhri.",
                rescueSecondsLabel = "Pelastusaika",
                rescueSecondsDescription = "Sekunnit, jotka pelastajalta kuluu uhrin vapauttamiseen.",
                rescueItemLabel = "Pelastus-esine",
                rescueItemDescription = "Esine, jota pelastaja tarvitsee. Jätä tyhjäksi, jos mitään ei vaadita.",
                allowInventoryLabel = "Uhri säilyttää inventaarion",
                allowInventoryDescription = "Sidottu uhri voi edelleen avata inventaarionsa.",
                dispatchEnabledLabel = "Ota poliisihälytykset käyttöön",
                dispatchEnabledDescription = "Ilmoita kidnappauksista ja kuulusteluista hätäkeskukselle.",
                dispatchAdapterLabel = "Hälytysjärjestelmä",
                dispatchAdapterDescription = "Järjestelmä, joka vastaanottaa ilmoitukset.",
                dispatchJobsLabel = "Vastaanottavat roolit",
                dispatchJobsDescription = "Roolit, jotka saavat hälytyksen.",
                dispatchGrabChanceLabel = "Mahdollisuus kiinniottoon",
                dispatchGrabChanceDescription = "Prosentuaalinen mahdollisuus, että kiinniotto ilmoitetaan.",
                dispatchFixateChanceLabel = "Mahdollisuus sitomiseen",
                dispatchFixateChanceDescription = "Prosentuaalinen mahdollisuus, että tuolilla sitominen ilmoitetaan.",
                dispatchToolChanceLabel = "Mahdollisuus työkalun käyttöön",
                dispatchToolChanceDescription = "Prosentuaalinen mahdollisuus, että työkalun käyttö ilmoitetaan.",
                dispatchWitnessLabel = "Vaatii todistajan",
                dispatchWitnessDescription = "Ilmoita vain, kun toinen pelaaja on tarpeeksi lähellä huomatakseen sen.",
                dispatchWitnessRadiusLabel = "Todistajan säde",
                dispatchWitnessRadiusDescription = "Kuinka lähellä todistajan on oltava, metreinä.",
                dispatchCooldownLabel = "Hälytyksen viive",
                dispatchCooldownDescription = "Sekuntien määrä kahden saman istunnon hälytyksen välillä.",
                dispatchInaccuracyLabel = "Sijainnin epätarkkuus",
                dispatchInaccuracyDescription = "Metrit, joilla ilmoitettu sijainti siirretään satunnaisesti. 0 ilmoittaa tarkan sijainnin.",
                loggingEnabledLabel = "Ota lokitus käyttöön",
                loggingEnabledDescription = "Tallentaa sijoitukset, kiinniotot, työkalun käytön, vapautukset ja ylläpidon toimet.",
                logDatabaseLabel = "Kirjaa tietokantaan",
                logDatabaseDescription = "Kirjoittaa lisäksi jokaisen merkinnän kuulustelulokiin.",
                logRetentionLabel = "Säilytä lokimerkinnät",
                logRetentionDescription = "Päivien määrä, ennen kuin tietokannan lokimerkinnät poistetaan. 0 säilyttää ne ikuisesti.",
                pingToleranceLabel = "Etäisyystoleranssi",
                pingToleranceDescription = "Metrit, jotka lisätään jokaiseen palvelinpuolen etäisyystarkistukseen viiveen tasaamiseksi.",
                violationThresholdLabel = "Rikkomuskynnys",
                violationThresholdDescription = "Turvallisuusrikkomukset aikajaksolla ennen kuin reaktio aktivoituu. 0 poistaa sen käytöstä.",
                violationActionLabel = "Reaktio rikkomuksiin",
                violationActionDescription = "Mitä tapahtuu, kun pelaaja ylittää rikkomuskynnyksen.",
                violationActionNone = "Älä tee mitään",
                violationActionLog = "Vain lokitus",
                violationActionKick = "Potku",
                violationActionCheating = "Ilmoita huijauksesta",
                particlesLabel = "Hiukkasjäljet",
                particlesDescription = "Näytä veri, kipinät ja liekit työkalun käytön aikana.",
                soundLabel = "Ääniefektit",
                soundDescription = "Toista työkalun äänet kaikille lähistöllä oleville.",
                cameraWorkLabel = "Kameratyö",
                cameraWorkDescription = "Liikuta kameraa, kun sidotaan joku tai käytetään työkalua.",
                screenEffectsLabel = "Näytöstehosteet",
                screenEffectsDescription = "Tärinä, välähdys, sumentaminen ja värisuodattimet uhrin näytöllä.",
                objectsSection = "Kuulusteluobjektit",
                objectsEntry = "Objekti",
                objectsEditLabel = "Kuulusteluobjektit",
                objectsEditDescription = "Aseta pysyvät tuolit ja työkalukärryt kartalle.",
                objectsEditButton = "Muokkaa objekteja",
                objectsKindLabel = "Objektityyppi",
                objectsKindChair = "Tuoli",
                objectsKindCart = "Työkalukärry",
                objectsModelLabel = "Prop-malli",
                objectsPositionLabel = "Paikka",
                blockedZonesSection = "Estetyt vyöhykkeet",
                blockedZonesEntry = "Vyöhyke",
                blockedZonesEditLabel = "Estetyt vyöhykkeet",
                blockedZonesEditDescription = "Alueet, joille ei saa sijoittaa kuulusteluobjektia.",
                blockedZonesEditButton = "Muokkaa vyöhykkeitä",
                blockedZonesZoneLabel = "Vyöhykkeen ääriviivat",
                blockedZonesZoneDescription = "Raahaa kulmia määrittääksesi alueen, jolle sijoittaminen on kielletty.",
                toolsSection = "Työkalut",
                toolsEntry = "Työkalu",
                toolsEditLabel = "Työkalut",
                toolsEditDescription = "Lisää tai muokkaa uhriin käytettävissä olevia työkaluja.",
                toolsEditButton = "Muokkaa työkaluja",
                toolsItemLabel = "Vaadittu esine",
                toolsConsumeLabel = "Kuluta esine",
                toolsDamageLabel = "Vaurio per käyttö",
                toolsHealthFloorLabel = "Terveysalaraja",
                toolsCooldownLabel = "Jälleenlatausaika sekunteina",
                toolsProgressLabel = "Edistys per käyttö",
                sessionsSection = "Käynnissä olevat kuulustelut",
                sessionsEntry = "Kuulustelu",
                sessionsEditLabel = "Käynnissä olevat kuulustelut",
                sessionsEditDescription = "Näet, ketua kuulustellaan parhaillaan, ja voit lopettaa sen tarvittaessa.",
                sessionsEditButton = "Näytä kuulustelut",
                sessionsStateLabel = "Tila",
                sessionsProgressLabel = "Edistyminen",
                orphansSection = "Orvoksi jääneet objektit",
                orphansEntry = "Objekti",
                orphansEditLabel = "Orvoksi jääneet objektit",
                orphansEditDescription = "Poista objektit, joiden omistajaa ei ole nähty pitkään aikaan.",
                orphansEditButton = "Siivous",
                sessionStates = {
                    binding = "Sitominen",
                    active = "Aktiivinen",
                    ending = "Päättyminen",
                },
            },
        },
    },
}
