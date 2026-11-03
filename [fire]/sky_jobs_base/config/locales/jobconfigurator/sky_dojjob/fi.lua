JobConfigLocales["sky_dojjob:fi"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Talous" ,
                doj_conditions = "Diagnoosit",
                doj_elections = "Vaalit",
                doj_files = "Tapauskansioiden selaus",
                doj_hearings = "Kuulemiset",
                doj_law = "Oikeudelliset lait",
                doj_offences = "Hieno luettelo",
                doj_shared_files = "Jaetut asiakirjat",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Asiakirjojen käyttöoikeuksien määritys",
                description = "Valitse, kuka pääsee tietoihin ja millä osa-alueella hän työskentelee. Määrittämättömillä arvoasteilla ei ole käyttöoikeutta.",
                status = {
                    unpublished = "Määritystä ei ole vielä julkaistu",
                    conflict = "Ratkaise päällekkäiset määritykset",
                    disabled = "DOJ-tabletti on poistettu käytöstä",
                    incomplete = "Määritä vähintään yksi arvoaste",
                    ready = "Valmis tallennettavaksi",
                },
                steps = {
                    tabletTitle = "Ota DOJ-tabletti käyttöön",
                    tabletText = "Tabletin on oltava käytössä, jotta asiakirjasovellukset voidaan avata.",
                    gradesTitle = "Määritä DOJ-arvoasteet",
                    gradesText = "Valitse tasan yksi tietojen osa-alue jokaiselle arvoasteelle, jolle haluat antaa käyttöoikeuden.",
                    publishTitle = "Julkaise ja tallenna",
                    publishText = "Uusi määritysversio valmistellaan automaattisesti jokaisen määritysmuutoksen jälkeen.",
                },
                grades = {
                    title = "Arvoasteiden määritykset",
                    description = "Valitse yksi osa-alue arvoastetta kohti. Valitse Ei käyttöoikeutta arvoasteille, joiden pääsy tulee estää.",
                    search = "Hae arvoasteita",
                    conflict = "Arvoasteella on useita määrityksiä. Valitse yksi osa-alue tai Ei käyttöoikeutta ratkaistaksesi ristiriidan.",
                    notFound = "Ei enää löydy ohjelmistokehyksestä",
                    noResults = "Vastaavaa arvoastetta ei löytynyt.",
                    empty = "Määritetylle DOJ-työlle ei löytynyt arvoasteita.",
                    emptyHint = "Luo ensin DOJ-arvoasteet ohjelmistokehykseen ja avaa sitten määritystyökalu uudelleen.",
                    gradeColumn = "Arvoaste",
                    domainColumn = "Tietojen osa-alue",
                    noAccess = "Ei käyttöoikeutta",
                    chooseDomain = "Ratkaise määritys",
                    assigned = "määritettyä arvoastetta",
                },
                publish = {
                    saveHint = "Ota muutokset käyttöön napsauttamalla ylhäältä Tallenna. Pelaajat voivat sen jälkeen tarkistaa käyttöoikeutensa uudelleen.",
                },
            },
            registryFiles = { licenseType = "Lupatyyppi", licenseLabel = "Rekisterin nimi", marriages = "Avioliittorekisteri" },
            features = {
                dojHandovers = {
                    label = "Siirrot",
                    description = "Ottaa käyttöön siirrot, oikeuden päätökset ja täytäntöönpanoraportit. Asiakirjat ja jakaminen pysyvät käytettävissä.",
                },
                dojBodycamRequests = {
                    label = "Kehokamerapyynnöt",
                    description = "Pyydä poliisin tallenteita. Edellyttää siirtoja; tallennetut videot pysyvät erikseen käytettävissä.",
                },
                dojFinance = { label = "Talous", description = "Ryhmittymien saldot, valtion tilisiirrot ja tapahtumahistoria." },
                dojConditions = {
                    description = "Aktivoi jäsennellyt olosuhteet, todisteet, määräajat ja rikkomisten seuranta.",
                    label = "Diagnoosit",
                },
                dojCourtroom = {
                    description = "Aktivoi turvalliset live-istunnot, todiste-esittely ja roolipohjainen huonevuorovaikutus.",
                    label = "Suora oikeussali",
                },
                dojElections = {
                    description = "Aktivoi vaalihallinto ja turvallinen äänestys rekisteröidyissä äänestyskopeissa.",
                    label = "Vaalit",
                },
                dojHearings = {
                    description = "Aktivoi oikeussalin aikataulutus, sisäänkirjautuminen ja arvovaltainen kuulonhallinta.",
                    label = "Kuulemiset",
                },
                dojLegalCodes = {
                    description = "Aktivoi lakikirjat, runsaan tekstin editointi ja revisiohistoria.",
                    label = "Oikeudelliset säännöt",
                },
                dojOffences = {
                    description = "Aktivoi kompakti rikosluettelo ja laskimen esikatselu.",
                    label = "Hieno luettelo",
                },
                dojPrinters = {
                    description = "Aktivoi fyysiset tulostimet ja niiden käyttöajan infrastruktuuri.",
                    label = "Tulostimet",
                },
                dojPublicDisplays = {
                    description = "Aktivoi yksityisyyssuodatetut live-tiedot oikeustalon näyttöihin.",
                    label = "Julkiset oikeussalinäytökset",
                },
                dojTablet = {
                    description = "Aktivoi pääsy DOJ tablettisovellukseen.",
                    label = "DOJ tabletti",
                },
                dojTaxes = {
                    description = "Kerää säännöllisesti ajoneuvo- ja asuntoverot nettipelaajilta.",
                    label = "Omaisuusverot",
                },
            },
            settingSections = {
                finance = "Talous",
                courtroom = "Oikeussali",
                registries = "Rekisteri",
                courthouses = "Oikeustalot",
                general = "Kenraali",
                legalCodes = "Oikeudelliset säännöt",
                offences = "Hieno luettelo",
                recordsAccess = "Tapauskansioon pääsy",
                tablet = "Tabletti",
                taxes = "Verot",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Luparekisterit",
                    description = "Valitse luvat, joita DOJ saa myöntää. Jokainen merkintä näkyy omana rekisterinään. Merkinnän poistaminen ei peruuta nykyisiä lupia.",
                },
                dojRegistryAccess = {
                    ["label"] = "Rekisteritiedostojen käyttöoikeudet",
                    ["description"] = "Muuta config/registry-rekisterien käyttöoikeuksia. Tyhjä luettelo käyttää tiedostojen oletuksia. Kenttiä ja palvelin- ja asiakastoimintoja muokataan Lua-tiedostoissa.",
                },
                dojTreasuryJob = { label = "Valtion tilin työ", description = "Työ, jonka yhteistili vastaanottaa perinnät ja maksaa siirrot." },
                dojFinanceJobs = { label = "Näkyvät ryhmittymät", description = "Tilinäkymän rekisteröityjen töiden avaimet. Valtion tili sisältyy aina." },
                dojFinanceLimit = { label = "Tapahtumaraja", description = "Yhden siirron tai perinnän enimmäissumma." },
                dojFinePaymentMode = { label = "Ehtosakkojen maksu", description = "Suora pankkimaksu tai ulkoinen lasku. Laskun luonti ei vahvista maksua.", options = { bank = "Pankkimaksu", billing = "Lasku" } },
                dojFineSociety = { label = "Sakkojen vastaanottaja", description = "Työ, jonka yhteistili vastaanottaa ehtosakot." },
                dojCourtroomBoardMove = {
                    label = "Siirrä oikeussalin levyä",
                    description = "Oletusavain mobiililevyn (esim. F) nappaamiseen tai vapauttamiseen. Pelaajat voivat ohittaa sen FiveM-avainsidonnassa. Liike on väliaikainen ja nollautuu uudelleen käynnistämisen jälkeen.",
                },
                dojCourtroomGavel = {
                    label = "Tuomari nuiji",
                    description = "Gavel-malli, käsien kiinnitys, animaatio, ääni- ja lakkokuviot. Muutokset pätevät myös ilman käynnistämistä uudelleen.",
                },
                dojHearingParticipantRoles = {
                    label = "Osallistujan roolit",
                    description = "Oletusroolit: vastaaja, todistaja, valamies, tuomari. Lisää tähän henkilökohtaiset pienet rooliavaimet (jopa 24 merkkiä, alleviivaa). Pidä tuomari. Muotiroolit eivät anna tuomarille tai valamiehistölle oikeuksia.",
                },
                dojWarrantTemplateCodes = {
                    label = "Osto-oikeusmallin koodit",
                    description = "Mallikoodit esitetään kohdassa PD Oikeudellisen allekirjoituksen ja jakamisen jälkeen. Oletukset: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ rekisterit",
                    description = "Aktivoi ja nimeä DOJ rekisteriä, sitten aseta ammattiin pääsy ja pääsy. Nykyiset DOJ roolioikeudet ovat edelleen voimassa. Ammateissa hallinnoidaan Custom RP rekisteriä.",
                },
                dojCourthouseBlipCategory = {
                    description = "Oikeustalon karttojen pilkkuihin käytetään kategoriamerkintää.",
                    label = "Blip-luokka",
                },
                dojCourthouseBlipColor = {
                    description = "Oikeustaloissa käytetty karttaväri.",
                    label = "Blip-väri",
                },
                dojCourthouseBlipScale = {
                    description = "Oikeustalon pisteissä käytetty kartta-asteikko.",
                    label = "Blip-asteikko",
                },
                dojCourthouseBlipShortRange = {
                    description = "Vain lähietäisyydeltä.",
                    label = "Lyhyt kantama",
                },
                dojCourthouseBlipSprite = {
                    description = "Oikeustaloissa käytetty karttasprite.",
                    label = "Blip-sprite",
                },
                dojLegalBookItem = {
                    description = "Inventointikohde kiinteään lakikoodiversioon. Ensikäyttö tallentaa sen sisällön ja päivämäärän; vaatii yksittäisiä kohteita, joissa on metatiedot.",
                    label = "Oikeudellisen koodin kirjan kohta",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimi millisekunteja lakikirjojen luomispyyntöjen välillä.",
                    label = "Luo kirjan viileneminen",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Pienin millisekunti tarkistuspyyntöjen välillä.",
                    label = "Luo revision jäähdytys",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Laillisten kirjojen poistopyyntöjen välissä on vähintään millisekuntia.",
                    label = "Poista kirjan viileneminen",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Muutoksen poistopyyntöjen välissä on vähintään millisekunnit.",
                    label = "Poista revision jäähdytys",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Vähintään millisekuntia lakikirjan pyytämisen välillä.",
                    label = "Lataa kirjan jäähdytys",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Vähintään millisekuntia lakikirjojen listaa koskevien pyyntöjen välillä.",
                    label = "Lataa kirjaston jäähdytys",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Pienin mahdollinen loma suurissa asiakirjapyynnöissä.",
                    label = "Suuri pyyntöaika millisekunneissa",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Lakikirjan lyhenteessä sallittujen merkkien enimmäismäärä.",
                    label = "Lyhenteen enimmäispituus",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Lakikirjan otsikossa sallittujen merkkien enimmäismäärä.",
                    label = "Kirjan nimen enimmäispituus",
                },
                dojLegalMaxContentBytes = {
                    description = "Korkein mahdollinen sarjakoko yhdestä täydellisestä lakikirjan versiosta.",
                    label = "Enimmäispitoisuus tavuina",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Otsan enimmäispituus hyväksytty tuotaessa vanhoja jäsenneltyjä kappaleita.",
                    label = "Perittyjen kappaleiden enimmäispituus",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Perinnöllisen tuonnin aikana hyväksyttyjen strukturoitujen kappaleiden enimmäismäärä.",
                    label = "Perinnön kappaleiden enimmäismäärä kirjaa kohden",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Revisiotiedotteessa sallittujen merkkien enimmäismäärä.",
                    label = "Mukautuksen enimmäispituus",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Muokkainsolmujen enimmäismäärä sallitaan yhdessä versiossa.",
                    label = "Maksimi rikkaan tekstin solmut",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Pelaajakohtainen kaistanleveysraja, jota käytetään suurten oikeudellisten asiakirjojen siirtämiseen.",
                    label = "Siirtonopeus tavuina sekunnissa",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Vähintään millisekuntia lakikirjojen uudelleentilauspyyntöjen välillä.",
                    label = "Tilaa kirjat uudelleen viilenemään",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Vähintään millisekuntia lakikirjojen metatietojen päivitysten välillä.",
                    label = "Päivitä kirjan jäähdytys",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Lakikirjan avaamisen yhteydessä ladattujen versioiden enimmäismäärä.",
                    label = "Näkyvä tarkistushistoria",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimi millisekuntia palvelinpuolisten laskinten esikatselujen välillä.",
                    label = "Laskinjäähdytys",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Vähintään millisekuntia luettelopyyntöjen välillä.",
                    label = "Lataa luettelo jäähdytettynä",
                },
                dojOffenceMaxSelection = {
                    description = "Yhdessä laskimen esikatselussa on mukana eniten rikoksia.",
                    label = "Maksimivalinta",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Vähintään millisekuntia rikosluettelon muutosten välillä.",
                    label = "Katalogin muokkausjäähdytys",
                },
                dojOffenceMirandaWarning = {
                    description = "Hienossa kuvastossa on oma varoitus. Jätä tyhjäksi, jos haluat käyttää vakiotekstiä valitsemallasi kielellä.",
                    label = "Miranda- varoitus",
                },
                dojPrimaryColor = {
                    description = "DOJ ammattiryhmän ja tabletin käyttämä pääväri.",
                    label = "Pääväri",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Nämä arvosanat toimivat tuomioistuimen hallinnon ja rekisteritietojen parissa.",
                    label = "Tuomioistuimen hallinto",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Nämä arvosanat toimivat oikeudenkäyntiasiakirjojen ja päätösten parissa.",
                    label = "Oikeuslaitos",
                },
                dojRecordsMappingVersion = {
                    description = "Julkaistu versio grade-to-records-domain-kartoituksesta. Tyhjä arvo pitää tietueet pois käytöstä.",
                    label = "Julkaisuversio",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Arvosanat toimivat syyttäjän tietojen mukaan.",
                    label = "Syyte",
                },
                dojTabletRequireDuty = {
                    description = "Vain työvuorossa olevat DOJ työntekijää voivat avata lakikoodisovelluksen.",
                    label = "Vaadi tulli",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Suora valuutta",
                },
                dojTaxHouseAmount = {
                    description = "Jokaisesta pelaajan omistamasta talosta veloitetaan summa.",
                    label = "Vero asuntoa kohti",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Sekunteja, jotka odottavat ensimmäistä perimistä, kun aiempaa verosykliä ei ole tallennettu.",
                    label = "Alkuperäinen viivästys",
                },
                dojTaxIntervalMinutes = {
                    description = "Automaattisten varainkeräyssyklien väliset minuutit.",
                    label = "Keräysväli",
                },
                dojTaxNotifyPlayer = {
                    description = "Ilmoita pelaajille suoran keräyksen, laskun tai varojen riittämättömyyden jälkeen.",
                    label = "Ilmoita pelaajille",
                },
                dojTaxPaymentMode = {
                    description = "Käytä valittua pankki-/rahasaldoa suoraan tai lähetä yksi Sky Base -yhteiskuntalasku verotettavaa pelaajaa ja verosykliä kohti.",
                    label = "Maksutapa",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Pankki / rahasaldo",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ ammattikunta, jonka laskennallinen yhteiskuntatili saa kaikki verotulot.",
                    label = "Vastaanottaja DOJ ammatti",
                },
                dojTaxVehicleAmount = {
                    description = "Jokaisesta pelaajan omistamasta ajoneuvosta veloitetaan summa.",
                    label = "Vero ajoneuvoa kohti",
                },
            },
            printers = {
                groups = {
                    paper = "Paperi",
                    ink = "Muste",
                    general = "Tulostin",
                    printing = "Tulostus ja käyttöoikeudet",
                    placement = "Malli ja sijainti",
                },
                actions = {
                    selectExisting = "Valitse olemassa oleva tulostin",
                    selectExistingHint = "Tähtää tulostimeen. Enter: valitse · Esc: peruuta",
                    add = "Lisää tulostin",
                    open = "Tarkasta tulostin",
                    place = "Sijoita tulostin",
                    setPosition = "Käytä nykyistä sijaintia",
                },
                classes = {
                    office = "Toimisto",
                    professional = "Ammattilainen",
                    standard = "Tavallinen",
                },
                description = "Määritä tämän työn tulostimet, tarvikkeet, jonot, käyttöoikeudet ja sijoittelu.",
                fieldDescriptions = {
                    paperCapacity = "Jokaisen tämän työn tulostimen paperin enimmäismäärä.",
                    paperEnabled = "Kun asetus on käytössä, tämän työn tulostimet aloittavat tyhjinä ja tarvitsevat yhteisen täyttöesineen.",
                    refillAmount = "Paperimäärä, joka lisätään tämän työn tulostimeen yhteistä täyttöesinettä käytettäessä.",
                    refillItem = "Varastoesineen sisäinen nimi. Esine kulutetaan, kun tämän työn tulostin täytetään.",
                },
                fields = {
                    active = "Käytössä",
                    class = "Luokka",
                    heading = "Suunta",
                    id = "Pysyvä tunniste",
                    label = "Nimi",
                    maxQueue = "Jonon kapasiteetti",
                    minimumGrade = "Vähimmäisarvo",
                    paperCapacity = "Paperikapasiteetti",
                    paperEnabled = "Vaadi paperin lisäämistä",
                    propModel = "Objektin malli",
                    refillAmount = "Paperia täyttöesineestä",
                    refillItem = "Täyttöesine",
                    deleteCopiesAfterRestart = "Poista kopiot uudelleenkäynnistyksessä",
                    deleteCopiesAfterRestartHint = "Poista noutamattomat tulosteet, kun tulostuspalvelu käynnistyy uudelleen.",
                    spawnProp = "Luo objekti",
                    speed = "Tulostusnopeus",
                    status = "Tila",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Luokka: {class}",
                    paper = "Paperi: {paper} / {capacity}",
                    queue = "Jono: {queue} / {maxQueue}",
                    status = "Tila: {status}",
                    title = "Tulostin",
                },
                messages = {
                    grade_too_low = "Arvosi ei riitä tämän tulostimen käyttämiseen.",
                    invalid_amount = "Täyttömäärä ei kelpaa.",
                    missingModel = "Valitse kelvollinen tulostinmalli ennen sijoittamista.",
                    missing_refill_item = "Sinulla ei ole määritettyä täyttöesinettä.",
                    no_refill_printer = "Lähellä ei ole käytettävissä olevaa paperia kuluttavaa tulostinta.",
                    paper_capacity_exceeded = "Paperikapasiteetti ylittyisi.",
                    paper_disabled = "Paperin kulutus ei ole käytössä tässä tulostimessa.",
                    paper_full = "Tämän tulostimen paperilokero on jo täynnä.",
                    printer_inactive = "Tämä tulostin ei ole käytössä.",
                    printer_not_found = "Tulostinta ei enää ole.",
                    refill_cooldown = "Odota hetki ennen seuraavaa täyttöä.",
                    refilled = "Lisättiin {amount} arkkia. Varasto: {paper} / {capacity}.",
                    too_far_away = "Siirry lähemmäs tulostinta.",
                    unavailable = "Tulostin ei ole käytettävissä.",
                    wrong_job = "Työsi ei oikeuta tämän tulostimen käyttöön.",
                },
                settings = {
                    description = "Nämä asetukset koskevat kaikkia tälle työlle määritettyjä tulostimia.",
                    title = "Työn yhteiset tulostinasetukset",
                },
                statuses = {
                    maintenance = "Huolto",
                    offline = "Ei yhteyttä",
                    online = "Yhteydessä",
                },
                title = "Tulostimet",
                values = {
                    disabled = "Pois käytöstä",
                    enabled = "Käytössä",
                    selectItem = "Valitse esine",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Määritä DOJ ammattia, oikeustalon paikat ja lakikoodisovellus.",
                    title = "Oikeusministeriö",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Oikeustalo",
                    entryPluralLabel = "Oikeustalot",
                    label = "Oikeustalot",
                },
            },
            extensions = {
                invalidSelection = "Virheellinen valinta: {value}",
                trainingSettings = {
                    description = "Määritä koulutuksen käyttöoikeudet, ilmoittautuminen, hyväksynnät ja kurssin suunnittelu tälle työlle.",
                    label = "Harjoitusasetukset",
                },
            },
            locations = {
                stationPosition = "Sijainti / kartan blip",
                stationPositionHint = "Tämän työpaikan pääpiste. Jos kartan blip on käytössä kohdassa Job → Blips, se näkyy tässä.",
                addCourtroom = "Lisää tuomioistuinsali",
                courtroom = "Oikeussali",
                courtroom_display_desk_27 = "Oikeuden todistenäyttö – 27 tuuman työpöytämonitori",
                courtroom_display_wall_55 = "Näytön näyttö oikeudessa – 55 tuuman seinä TV",
                courtroom_display_wall_75 = "Näytön näyttö oikeudessa – 75 tuuman seinä TV",
                courtroom_display_wall_100 = "Näytön näyttö oikeudessa – 100 tuuman seinä TV",
                courtroom_display_wall_120 = "Näytön näyttö oikeudessa – 120 tuuman seinä TV",
                courtroom_display_wall_150 = "Näytön näyttö oikeudessa – 150 tuuman seinä TV",
                courtroom_display_board_93 = "Courtroomin vuorovaikutteinen levy – 150 tuuman mobiiliteline",
                courtroom_display_projection = "Tuomioistuinnäytön näyttö – 4.5 m projektorinäyttö",
                courtroom_judge_mic = "Oikeussali – tuomarin mikrofoni",
                courtroom_jury_room = "Oikeussali – valamiehistön sali",
                courtroom_room = "Hovihuone – yleisöä / huonekeskus",
                courtroom_witness = "Oikeushuone – todistajan paikka",
                electionBooth = "Äänestysluettelo",
                publicDisplayDesk27 = "Julkinen näyttö – 27 tuuman desk Monitor",
                publicDisplayTerminal43 = "Julkinen näyttö – 43 tuuman lattiaterminaali",
                publicDisplayWall55 = "Julkinen näyttö – 55 tuuman seinä TV",
                publicDisplayWall75 = "Julkinen näyttö – 75 tuuman seinä TV",
                publicDisplayWall100 = "Julkinen näyttö – 100 tuuman seinä TV",
                publicDisplayWall120 = "Julkinen näyttö – 120 tuuman seinä TV",
                publicDisplayWall150 = "Julkinen näyttö – 150 tuuman seinä TV",
                publicDisplayProjection = "Julkinen näyttö – 4.5 m Projektorinäyttö",
                publicLegalCode = "Julkiset oikeussäännöt",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Tuomioistuimen määräykset",
                },
                dojAccess = {
                    label = "Pääsy",
                },
                dojCourthouseBlip = {
                    label = "Kartan poikkeama",
                },
                dojLegalBooks = {
                    label = "Kirjat",
                },
                dojLegalContentLimits = {
                    label = "Sisältörajat",
                },
                dojLegalItem = {
                    label = "Inventaarion esine",
                },
                dojLegalRateLimits = {
                    label = "Verorajat",
                },
                dojLegalRevisions = {
                    label = "Tarkistukset",
                },
                dojLegalTransfers = {
                    label = "Suuret asiakirjat",
                },
                dojOffenceCalculation = {
                    label = "Laskin",
                },
                dojOffenceRateLimits = {
                    label = "Verorajat",
                },
                dojOffenceMiranda = {
                    label = "Katalogiohjeistus",
                },
                dojOffenceSource = {
                    label = "Luettelon lähde",
                },
                dojRecordsGradeBindings = {
                    description = "Aseta jokainen saatavilla oleva DOJ-luokka täsmälleen yhteen tietuealueeseen ja julkaise sitten kartoitus.",
                    label = "Luokat ja tietueet",
                },
                dojTaxPayment = {
                    label = "Maksu",
                },
                dojTaxRates = {
                    label = "Taksat",
                },
                dojTaxSchedule = {
                    label = "Aikataulu",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notariaattisopimukset",
                    powers_of_attorney = "Asianajovalta",
                    name_changes = "Nimien muutokset",
                    company_registry = "Yhtiörekisteri",
                    association_registry = "Yhdistysrekisteri",
                    licensing = "Lisenssit",
                    administrative_decisions = "Hallinnolliset päätökset",
                    administrative_objections = "Hallinnolliset vastaväitteet",
                },
            },
            gavel = {
                enabled = "Käytössä",
                cooldown = "Käynnistysjäähdytys (ms)",
                defaultPreset = "Oletuslakkokuvio",
                prop = "Laattateline",
                model = "Mallin nimi",
                bone = "Käsiluu ID",
                offset = "Offset (metriä)",
                rotation = "Pyöriminen (asteet)",
                presets = "Iskukuviot",
                single = "Yksi lakko",
                double = "Tuplaisku",
                strikes = "Lakkojen määrä",
                interval = "Iskuväli (ms)",
                impact = "Ääniviive (ms)",
                audio = "Ääni",
                asset = "Äänite",
                volume = "Äänenvoimakkuus",
                animation = "Animaatio",
                dict = "Animaatio sanakirja",
                clip = "Animaation nimi",
                duration = "Liikkeen kesto (ms)",
                flag = "Animaatioliput",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Mahdollistaa työntekijöiden ilmoittautumisen saatavilla oleviin koulutustilaisuuksiin.",
                approvalRequired = "Pitää itse ilmoittautumiset vireillä, kunnes valtuutettu ohjaaja hyväksyy ne.",
                defaultCapacity = "Uusi harjoituskerta luotaessa käytettyjen istumapaikkojen oletusmäärä.",
                enabled = "Tarjoaa koulutussovelluksen tähän työhön.",
                requireOnDuty = "Edellyttää työntekijöiden olevan päivystyksessä ennen koulutussovelluksen avaamista tai käyttöä.",
                upcomingDays = "Koulutussovelluksen aikataulussa näkyvä tulevien päivien määrä.",
            },
            trainingFields = {
                allowSelfEnrollment = "Salli itse ilmoittautuminen",
                approvalRequired = "Vaadi rekisteröinnin hyväksyntä",
                defaultCapacity = "Oletuskapasiteetti",
                enabled = "Ota koulutus käyttöön",
                requireOnDuty = "Vaadi tulli",
                upcomingDays = "Tuleva ajanjakso (päiviä)",
            },
        },
    },
}
