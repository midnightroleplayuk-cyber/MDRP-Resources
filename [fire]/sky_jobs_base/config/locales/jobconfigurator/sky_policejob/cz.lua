JobConfigLocales["sky_policejob:cz"] = {
    JobConfiguratorComingSoon = "Tento konfigurátor práce bude brzy k dispozici.",
    JobConfiguratorNoPermission = "Nemáte oprávnění použít tento příkaz.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Nakonfigurujte policejní stanice, obchody, rekvizity, vozidla a nastavení základních funkcí.",
                    title = "Policie",
                },
            },
            dispatchActions = {
                addChannel = "Přidat rádiový kanál",
                addKeyword = "Přidat klíčové slovo",
                addPoi = "Přidat bod zájmu",
                addReporter = "Přidat oznamovatele",
                addStatus = "Přidat stav FMS",
                addVehicle = "Přidat virtuální jednotku",
                addVehicleType = "Přidat typ jednotky",
                currentLocation = "Použít aktuální polohu",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Při vytvoření incidentu okamžitě přiřadí odpovídající dostupné jednotky.",
                available = "Jednotky v tomto stavu mohou být navrženy a přiřazeny k novému incidentu.",
                averageResponseSpeedKmh = "Vypočítá zobrazený odhad příjezdu z přímé vzdálenosti.",
                callsign = "Jedinečný rádiový volací znak zobrazený, když hráči obsluhují tuto virtuální jednotku.",
                centerEnabled = "Umožňuje oprávněným členům ve službě obsluhovat dispečink.",
                channelId = "ID rádiového kanálu pro PMA Voice, SaltyChat a YACA. Číselná ID jako 2500 zůstávají nezměněna; PMA Voice mapuje textová ID na stabilní číslo.",
                channelLabel = "Čitelný název kanálu zobrazený dispečerům a jednotkám.",
                crewCapacity = "Nejvyšší počet členů jednotky. Hodnota 0 znamená neomezenou posádku.",
                defaultChannel = "Dispečeři se k tomuto kanálu připojují na začátku směny. Jednotky se připojují ručně na kartě Rádio. Chcete-li použít výchozí nastavení skupiny úloh, vyberte možnost Žádná.",
                emergencyAppEnabled = "Umožňuje vybrat tuto úlohu jako veřejnou službu v aplikaci Tísňové volání.",
                enabled = "Zpřístupní tuto úlohu aplikaci Dispatch a incidentům mezi úlohami.",
                icon = "Vyberte ikonu zobrazenou pro tuto kategorii jednotek v aplikaci Dispatch.",
                incidentAssessmentEnabled = "Zobrazuje lékařské otázky a otázky týkající se posouzení nebezpečí v celém příjmu incidentů.",
                jobs = "Další názvy úloh, které přijímají incidenty pomocí tohoto klíčového slova.",
                joinLocked = "Po obsazení jednotky zabrání připojení dalších členů.",
                minimumCrew = "Nejnižší počet členů ve vybraných jednotkách tohoto výjezdového plánu.",
                noUnitFallback = "Bez střediska nebo personální jednotky odešle oznámení Sky všem členům ve službě.",
                poiId = "Stálý technický identifikátor, na který lze odkazovat i po přejmenování bodu zájmu.",
                radius = "Maximální vzdálenost v metrech, na kterou lze slyšet hlášení stanice.",
                readyStatusCode = "Stav FMS použitý, když je prostředek připraven k vyslání.",
                requirements = "Odpovězte na poptávku jako páry TYPE:COUNT, například PATROL:2,CRIME:1.",
                resourceType = "Zařadí operační prostředek pro filtrování a koordinaci dispečinku.",
                respondingStatusCode = "Stav FMS použitý, když prostředek vyjíždí k události.",
                shortLabel = "Volitelný krátký popisek na šesti tlačítkách paměti rádiových kanálů.",
                stationId = "Přiřadí jednotku ke stanici nastavené v profilu dispečinku.",
                statusCode = "Číselný stav FMS zobrazený na ručním rádiu.",
                statusLabel = "Význam tohoto stavu FMS pro dispečery a jednotky.",
                unitId = "Stálý technický identifikátor zachová jednotku i po změně volacího znaku.",
                vehicleType = "Musí odpovídat kódu typu vozidla nakonfigurovanému v předchozí podsekci.",
                vehicleTypeCode = "Krátký kód jednotky používaný v požadavcích na odezvu, například PATROL, CRIME, EMS nebo RESCUE.",
                vehicleTypeLabel = "Čitelný název této kategorie jednotek.",
            },
            dispatchFields = {
                address = "Adresa",
                autoAlarm = "Automatický alarm",
                available = "K dispozici k odeslání",
                averageResponseSpeedKmh = "Odhadovaná rychlost odezvy (km/h)",
                callsign = "Volací značka",
                category = "Kategorie",
                centerEnabled = "Povolit dispečink",
                channelId = "ID kanálu",
                code = "Kód",
                crewCapacity = "Kapacita posádky",
                defaultChannel = "Výchozí rádiový kanál",
                emergencyAppEnabled = "Zobrazit v aplikaci Emergency App",
                enabled = "Povolit odeslání",
                icon = "Ikona",
                incidentAssessmentEnabled = "Povolit vyhodnocení stavu nouze",
                jobs = "Cílové úlohy (oddělené čárkami)",
                joinLocked = "Uzamknout připojení posádky",
                keywordCode = "Kód klíčového slova",
                label = "Štítek",
                minimumCrew = "Minimální posádka",
                name = "Jméno",
                noUnitFallback = "Informujte zaměstnance ve službě bez jednotek",
                noneChannel = "Žádné / výchozí skupina",
                note = "Poznámka",
                phone = "Telefon",
                poiId = "Stálé ID bodu zájmu",
                radius = "Poloměr oznámení",
                readyStatusCode = "Kód stavu připravenosti",
                requirements = "Požadované jednotky (například PATROL:2,CRIME:1)",
                resourceType = "Typ prostředku",
                respondingStatusCode = "Kód stavu výjezdu",
                shortLabel = "Popisek paměti rádia",
                stationId = "ID stanice",
                type = "Typ",
                unitId = "Stálé ID jednotky",
                vehicleType = "Typ jednotky odpovědi",
                radioButton = "Tlačítko",
                radioButtonAction = "Činnost tlačítka",
                radioButtonStatus = "FMS Stav",
            },
            dispatchIconOptions = {
                crime = "Kriminální jednotka",
                emergency = "Pohotovostní jednotka",
                ems = "Jednotka EMS",
                fire = "Požární jednotka",
                heavy = "Těžká jednotka",
                k9 = "Jednotka K-9",
                medical = "Lékařská jednotka",
                patrol = "Hlídka",
                rescue = "Záchranná jednotka",
                service = "Servisní jednotka",
                supervisor = "Vedoucí",
                tactical = "Taktická jednotka",
            },
            dispatchNavigation = {
                active = "Odeslání aktivní",
                description = "Nakonfigurujte nouzový příjem, rádio, jednotky, plány odezvy, umístění a data reportérů pro tuto úlohu.",
                inactive = "Odesílání zakázáno",
                steps = {
                    accessText = "Povolte odesílání a rozhodněte, zda tato úloha může obsluhovat dispečink.",
                    accessTitle = "Přístup a nouzový příjem",
                    fleetText = "Konfigurace kanálů, stavových kódů FMS, typů vozidel a volacích značek.",
                    fleetTitle = "Rádio a flotila",
                    responseText = "Dokončete pomocí klíčových slov, požadavků na odezvu a bodů zájmu.",
                    responseTitle = "Plány odezvy",
                },
                summary = {
                    channels = "Rozhlasové kanály",
                    plans = "Plány odezvy",
                    reporters = "Známí oznamovatelé",
                    statuses = "Dostupné FMS",
                    units = "Virtuální jednotky",
                },
                title = "Odeslání",
                warnings = {
                    channels = "Neexistují žádné explicitní rádiové kanály; bude použit záložní kanál pracovní skupiny.",
                    defaultChannel = "Vybraný výchozí kanál již neexistuje.",
                    disabled = "Odesílání je pro tuto úlohu zakázáno.",
                    statuses = "Musí být k dispozici alespoň jeden stav FMS, aby bylo možné spustit alarm.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Definuje rádiové kanály, ke kterým se mohou připojit jednotky a personální dispečinky.",
                dispatchKeywords = "Definuje klíčová slova incidentu, požadovaný počet vozidel, zúčastněné úlohy a volitelný automatický alarm.",
                dispatchPois = "Ukládá stanice a společná místa pro formuláře incidentů a hlášení stanic podle polohy.",
                dispatchReporters = "Spravuje jména oznamovatelů, telefonní čísla a poznámky dispečinku pro tuto profesi.",
                dispatchStatusCodes = "Konfiguruje štítky stavu FMS a které stavy se počítají jako dostupné pro nové incidenty.",
                dispatchVehicleTypes = "Definuje kategorie jednotek používané plány reakce, jako je Patrol, Crime Unit, EMS nebo Rescue.",
                dispatchVehicles = "Definuje virtuální expediční vozidla, která mohou být obsluhována odkudkoli, aniž by bylo nutné vytvořit vozidlo.",
                dispatchRadioButtons = "Nastaví centrálně nastavenou akci pro každé fyzické funkční tlačítko.",
                dispatchRadioFmsKeys = "Přiřadí FMS status na fyzické číselné klávesy. Keypad provádí pouze FMS změny.",
            },
            extensions = {
                caseNumbering = {
                    label = "Čísla případů",
                    description = "Nastavení automatických čísel případů pro tuto práci.",
                    fields = {
                        prefix = {
                            label = "Prefix případu",
                            description = "Prefix nových případů, například LSPD nebo LSCSD. Nejvýše 16 znaků, převedených na velká písmena; prázdné pole použije CASE. Stávající a ručně zadaná čísla zůstanou zachována.",
                        },
                    },
                },
                dispatchReporters = "Známí oznamovatelé",
                invalidSelection = "Neplatná volba: {value}",
                trainingSettings = {
                    description = "Nakonfigurujte přístup ke školení, registraci, schválení a plánování kurzu pro tuto úlohu.",
                    label = "Nastavení tréninku",
                },
                dispatchChannels = "Rozhlasové kanály",
                dispatchKeywords = "Klíčová slova a plány odezvy",
                dispatchPois = "Dispečink POI",
                dispatchSettings = {
                    description = "Nastavte dispečerský přístup, nouzový příjem a výchozí rádiový kanál.",
                    label = "Nastavení odeslání",
                },
                dispatchStatusCodes = "Kódy stavu",
                dispatchVehicleTypes = "Vyšlete typy vozidel",
                dispatchVehicles = "Údaje o expedici flotily",
                emptyDescription = "Pomocí tlačítka Přidat výše vytvořte první položku.",
                emptyTitle = "Zatím není nic nakonfigurováno",
                dispatchRadioButtons = "Knoflíky pro radiovou funkci",
                dispatchRadioFmsKeys = "FMS Klíčové přiřazení",
            },
            features = {
                billing = {
                    description = "Povolit postupy policejního účtování.",
                    label = "Fakturace",
                },
                devices = {
                    description = "Povolit nasaditelná donucovací zařízení.",
                    label = "CCTV a rychlostní kamery",
                },
                evidence = {
                    description = "Povolit úložiště důkazů, terénní důkazy a procesy skenování.",
                    label = "Důkazy",
                },
                impound = {
                    description = "Povolit procesy odtahového depa.",
                    label = "Odtah",
                },
                jail = {
                    description = "Povolit přidělování trestů a činnosti vězňů.",
                    label = "Vězení",
                },
                propPlacement = {
                    description = "Povolit konfigurovatelné policejní rekvizity a výbavu rekvizit vozidel.",
                    label = "Umístění rekvizit",
                },
                radial = {
                    description = "Povolit policejní radiální akce, jako je odtah a nasazení botičky.",
                    label = "Radiální akce",
                },
                restraints = {
                    description = "Povolit pouta, stahovací pásky, pouta na nohy a kuklu.",
                    label = "Omezovací prostředky",
                },
                socialWork = {
                    description = "Povolit přidělování a úkoly veřejně prospěšných prací.",
                    label = "Veřejně prospěšné práce",
                },
                tablet = {
                    description = "Povolit aplikace policejního tabletu nakonfigurované tímto zdrojem.",
                    label = "Policejní tablet",
                },
                tracking = {
                    description = "Povolit GPS lokátory a elektronické náramky.",
                    label = "Sledování",
                },
                vehicleRadar = {
                    description = "Povolit radar hlídkových vozidel.",
                    label = "Palubní radar",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Zobrazení této práce v tísňové aplikaci vyžaduje zapnutý dispečink. Zapněte dispečink nebo v jeho nastavení vypněte zobrazení v tísňové aplikaci.",
                dispatchJobNotCovered = "Žádný aktivní dispečink nepokrývá práci „{job}“. V sky_jobs_base/config/config.lua přidejte „{job}“ do coveredJobs v příslušném profilu Config.Dispatch.centers a restartujte sky_jobs_base. Obnovení nastavení toto přiřazení nemění.",
                invalidDispatchChannels = "ID rádiových kanálů musí být jedinečná a každý kanál musí mít platný název.",
                invalidDispatchDefaultChannel = "Výchozí rádiový kanál neexistuje. V nastavení dispečinku vyberte existující kanál nebo „Žádný“.",
                invalidDispatchKeywords = "Výjezdové plány musí mít jedinečné kódy a platné požadavky TYP:POČET.",
                invalidDispatchPois = "ID, názvy a souřadnice bodů zájmu musí být platné a jedinečné.",
                invalidDispatchRadioButtons = "Zkontrolujte funkční tlačítka rádia: každé podporované tlačítko použijte jen jednou a vyberte akci z jeho seznamu.",
                invalidDispatchRadioFmsKeys = "Zkontrolujte klávesy FMS rádia: každou klávesu (0-9, * nebo #) použijte jen jednou a přiřaďte jí existující stavový kód nebo ji nechte nepřiřazenou.",
                invalidDispatchReadyStatus = "V nastavení dispečinku vyberte kód připravenosti, který je v seznamu stavových kódů označen jako dostupný.",
                invalidDispatchReporters = "Data známých oznamovatelů překračují povolený počet položek nebo délku polí.",
                invalidDispatchRespondingStatus = "V nastavení dispečinku vyberte kód výjezdu, který je v seznamu stavových kódů označen jako nedostupný.",
                invalidDispatchSettings = "Vyberte existující dostupný stav připravenosti, nedostupný stav výjezdu a platný výchozí kanál.",
                invalidDispatchStatusCodes = "Kódy FMS musí být jedinečné a alespoň jeden stav musí být dostupný.",
                invalidDispatchVehicleTypes = "Kódy typů výjezdových jednotek musí být jedinečné a úplné.",
                invalidDispatchVehicles = "ID jednotek a volací znaky musí být jedinečné a odkazy na typy i stanice musí existovat.",
            },
            settingFields = {
                gangMinimumGrade = "Minimální hodnost",
                gang = "Gang",
                component = "Komponenta",
                description = "Popis",
                fineAmount = "Výše pokuty",
                itemName = "Název předmětu",
                length = "Délka",
                max = "Max.",
                maxOverKmh = "Max. překročení",
                min = "Min",
                minOverKmh = "Min. překročení",
                model = "Model rekvizity",
                propModel = "Model rekvizity",
                reason = "Důvod",
                vehicleClass = "Třída",
            },
            settingGroups = {
                access = {
                    label = "Přístup",
                },
                animation = {
                    label = "Animace",
                },
                ankleMonitor = {
                    label = "Elektronický náramek",
                },
                ankleMonitorAccess = {
                    label = "Přístup k elektronickému náramku",
                },
                ankleMonitorPlacement = {
                    label = "Nasazení elektronického náramku",
                },
                ankleMonitorZone = {
                    label = "Zóna elektronického náramku",
                },
                ankleMonitorZoneVisual = {
                    label = "Vzhled zóny elektronického náramku",
                },
                assignment = {
                    label = "Přiřazení",
                },
                blip = {
                    label = "Ikona stanice",
                },
                carry = {
                    label = "Nošení",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Odolnost CCTV",
                },
                cctvPlacement = {
                    label = "Umístění CCTV",
                },
                cctvRepair = {
                    label = "Oprava CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animace opravy CCTV",
                },
                clamp = {
                    label = "Botička",
                },
                clampWeld = {
                    label = "Odřezávání botičky",
                },
                cleanup = {
                    label = "Úklid",
                },
                collection = {
                    label = "Sběr",
                },
                controls = {
                    label = "Ovládání",
                },
                creator = {
                    label = "Tvůrce",
                },
                crimeSceneTape = {
                    label = "Páska místa činu",
                },
                crimeSceneTapeAccess = {
                    label = "Přístup k pásce",
                },
                crimeSceneTapeInventory = {
                    label = "Inventář pásky",
                },
                crimeSceneTapeLength = {
                    label = "Délka pásky",
                },
                crimeSceneTapePlacement = {
                    label = "Umístění pásky",
                },
                database = {
                    label = "Databáze",
                },
                delivery = {
                    label = "Doručení",
                },
                detection = {
                    label = "Detekce",
                },
                dispatch = {
                    label = "Dispečink",
                },
                escape = {
                    label = "Útěk",
                },
                escort = {
                    label = "Doprovod",
                },
                evidenceStorage = {
                    label = "Úložiště důkazů",
                },
                fastLock = {
                    label = "Automatické rychlé zaměření",
                },
                general = {
                    label = "Obecné",
                },
                gpsTracker = {
                    label = "GPS lokátor",
                },
                gpsTrackerAccess = {
                    label = "Přístup ke GPS lokátoru",
                },
                gpsTrackerPlacement = {
                    label = "Umístění GPS lokátoru",
                },
                gpsTrackerTiming = {
                    label = "Časování GPS lokátoru",
                },
                handcuffs = {
                    label = "Pouta",
                },
                handsUp = {
                    label = "Ruce nahoru",
                },
                header = {
                    label = "Záhlaví",
                },
                impound = {
                    label = "Odtah",
                },
                imprisonment = {
                    label = "Uvěznění",
                },
                jailCanteenGeneral = {
                    label = "Vězeňská kantýna",
                },
                jailCanteenPackage = {
                    label = "Balíček kantýny",
                },
                jailCarry = {
                    label = "Přenášecí práce",
                },
                jailCarryInspection = {
                    label = "Kontrola nákladu",
                },
                jailCleaning = {
                    label = "Úklidová práce",
                },
                jailCleaningIllegalFinds = {
                    label = "Nálezy kontrabandu",
                },
                jailCleaningOutline = {
                    label = "Obrys úklidu",
                },
                jailDoctor = {
                    label = "Vězeňský lékař",
                },
                jailElectricalCodes = {
                    label = "Kódy rozvaděče",
                },
                jailElectricalGeneral = {
                    label = "Vězeňský rozvaděč",
                },
                jailElectricalPenalties = {
                    label = "Postihy rozvaděče",
                },
                jailElectricalRewards = {
                    label = "Odměny rozvaděče",
                },
                jailInmatesAlcoholic = {
                    label = "Vězeň alkoholik",
                },
                jailInmatesCodeList = {
                    label = "Vězeň informátor",
                },
                jailInmatesDrugDealer = {
                    label = "Vězeň dealer",
                },
                jailInmatesWireCutter = {
                    label = "Vězeň pašerák nářadí",
                },
                jailJobs = {
                    label = "Vězeňské práce",
                },
                jailOutfitFemale = {
                    label = "Dámské oblečení",
                },
                jailOutfitMale = {
                    label = "Pánské oblečení",
                },
                keybinds = {
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                    label = "Klávesové zkratky",
                },
                keybindsHandcuff = {
                    label = "Klávesa spoutání",
                },
                keybindsUnhandcuff = {
                    label = "Klávesa sejmutí pout",
                },
                marker = {
                    label = "Značka",
                },
                markerColor = {
                    label = "Barva značky",
                },
                mugshotAnimation = {
                    label = "Animace fotografie",
                },
                mugshotBoard = {
                    label = "Tabule s fotografií",
                },
                mugshotCameraCoords = {
                    label = "Pozice kamery pro fotografii",
                },
                mugshotCameraRotation = {
                    label = "Rotace kamery pro fotografii",
                },
                mugshotGeneral = {
                    label = "Identifikační fotografie",
                },
                mugshotMetadata = {
                    label = "Metadata fotografie",
                },
                mugshotPosition = {
                    label = "Pozice fotografie",
                },
                mugshotTiming = {
                    label = "Časování fotografie",
                },
                officerDown = {
                    label = "Policista v ohrožení",
                },
                outfit = {
                    label = "Oblečení",
                },
                overlay = {
                    label = "Překryv SPZ",
                },
                payment = {
                    label = "Platba",
                },
                paymentFlow = {
                    label = "Proces platby",
                },
                penalties = {
                    label = "Postihy",
                },
                playerSearch = {
                    label = "Prohlídka hráče",
                },
                playerSearchAnimation = {
                    label = "Animace prohlídky",
                },
                props = {
                    label = "Rekvizity",
                },
                reasons = {
                    label = "Důvody",
                },
                release = {
                    label = "Vyzvednutí",
                },
                restore = {
                    label = "Obnovení",
                },
                rules = {
                    label = "Pravidla",
                },
                scan = {
                    label = "Sken",
                },
                scanner = {
                    label = "Skener",
                },
                sentence = {
                    label = "Trest",
                },
                shotsFired = {
                    label = "Výstřely",
                },
                sound = {
                    label = "Zvuk",
                },
                speedcam = {
                    label = "Rychlostní kamery",
                },
                speedcamBilling = {
                    label = "Účtování rychlostní kamery",
                },
                speedcamDispatch = {
                    label = "Dispečink rychlostní kamery",
                },
                speedcamDurability = {
                    label = "Odolnost rychlostní kamery",
                },
                speedcamPlacement = {
                    label = "Umístění rychlostní kamery",
                },
                speedcamRepair = {
                    label = "Oprava rychlostní kamery",
                },
                speedcamRepairAnimation = {
                    label = "Animace opravy rychlostní kamery",
                },
                speedcamTiming = {
                    label = "Časování rychlostní kamery",
                },
                speedcamVisual = {
                    label = "Vzhled rychlostní kamery",
                },
                speedcams = {
                    label = "Rychlostní kamery",
                },
                storage = {
                    label = "Úložiště",
                },
                subscription = {
                    label = "Předplatné aplikace",
                },
                tasks = {
                    label = "Úkoly",
                },
                theme = {
                    label = "Motiv",
                },
                timing = {
                    label = "Časování",
                },
                warningUi = {
                    label = "Varovné rozhraní",
                },
                world = {
                    label = "Svět",
                },
                zipties = {
                    label = "Stahovací pásky",
                },
                ziptiesCutter = {
                    label = "Nůžky na stahovací pásky",
                },
                cctvMotionDetection = {
                    label = "Detekce pohybu",
                },
                cctvMotionDispatch = {
                    label = "Dispečink detekce pohybu",
                },
                cctvMotionTiming = {
                    label = "Čas detekce pohybu",
                },
                display = {
                    label = "Displej",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Hlášení",
                },
                speedcamAdvanced = {
                    label = "Pokročilá kamera rychlosti",
                },
                tackle = {
                    label = "Srazeni",
                },
                vin = {
                    label = "Kontrola VIN",
                },
            },
            settingSections = {
                radarGun = "Radarová pistole",
                billing = "Fakturace",
                cctv = "CCTV",
                dispatch = "Dispečink",
                equipment = "Vybavení",
                evidence = "Důkazy",
                impound = "Odtah",
                jail = "Vězení",
                radar = "Palubní radar",
                radial = "Radiální akce",
                restraints = "Omezovací prostředky",
                socialWork = "Veřejně prospěšné práce",
                speedCamera = "Rychlostní kamera",
                spikeStrips = "Hřebíkové pásy",
                stations = "Stanice",
                tablet = "Aplikace tabletu",
                tracking = "Sledování",
                fakePlates = "Falešné desky",
                general = "Generál",
            },
            settingSubsections = {
                app = "Aplikace rychlostní kamery",
                apps = "Aplikace",
                billing = "Fakturace",
                canteen = "Vězeňská kantýna",
                dispatch = "Dispečink",
                durability = "Odolnost",
                electrical = "Vězeňský rozvaděč",
                general = "Obecné",
                handcuffs = "Pouta a stahovací pásky",
                inmates = "Vězni",
                jobs = "Vězeňské práce",
                keybinds = "Klávesové zkratky",
                motionDetection = "Detekce pohybu",
                mugshot = "Identifikační fotografie",
                placement = "Umístění",
                repair = "Oprava",
                timing = "Časování",
                visuals = "Vzhled",
            },
            settings = {
                radarGunClearKey = { label = "Radarová pistole: Vymazat měření" },
                radarGunToggleUiKey = { label = "Radarová pistole: Přepnout rozhraní" },
                radarGunNoTargetHoldMs = { label = "Doba uchování cíle (ms)" },
                radarGunMinimumReading = { label = "Nejnižší zobrazovaná rychlost" },
                radarGunSpeedSmoothing = { label = "Vyhlazení rychlosti (0–1)" },
                radarGunBeamRadius = { label = "Poloměr paprsku (m)" },
                radarGunRefreshRateMs = { label = "Interval měření (ms)" },
                radarGunUseMph = { label = "Používat MPH", description = "Zobrazuje měření radarové pistole v mílích za hodinu místo kilometrů za hodinu." },
                radarGunRange = { label = "Dosah měření", description = "Maximální vzdálenost v metrech, na kterou radarová pistole rozpozná vozidlo." },
                radarGunRequireOnDuty = { label = "Vyžadovat službu", description = "Vyžaduje, aby byl policista ve službě, než může radarovou pistolí měřit vozidla." },
                radarGunAllowedJobs = { label = "Povolené práce nebo skupiny", description = "police zahrnuje všechny nastavené policejní práce; lze zadat i přímé názvy. Prázdný seznam ruší omezení prací.", itemLabel = "Práce nebo skupina" },
                radarGunEnabled = { label = "Radarová pistole", description = "Zapne ruční radarovou pistoli SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Povolené gangy",
                    description = "Vyberte interní názvy gangů nebo nezávislých organizací. Shoda práce nebo gangu udělí oprávnění nebo výjimku. Povinná služba platí pouze pro práce.",
                    itemLabel = "Gang",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Minimální hodnosti gangů",
                    description = "Volitelné minimální hodnosti gangů. Prázdný seznam povoluje všechny hodnosti. Požadavky na předměty stále platí.",
                },

                speedCamProcessingMode = {
                    description = "Zvolte okamžité stržení, platbu v nastavené lhůtě nebo pouze kontrolu policistou.",
                    label = "Způsob zpracování",
                    options = {
                        instant = "Strhnout ihned",
                        later = "Zaplatit později (výchozí)",
                        review = "Pouze kontrola policistou",
                    },
                },
                tabletRegistry = { label = "Registr", description = "Povolit vlastní RP registry ve File Exploreru. Spisy občanů a vozidel zůstávají dostupné samostatně." },
                tabletFiles = { label = "Průzkumník souborů", description = "Sdružuje policejní záznamy v průzkumníku souborů. Dokumenty DOJ se zobrazují pouze při aktivním DOJ." },
                ankleMonitorAnimDurationMs = {
                    description = "Počet milisekund strávených nasazováním elektronického náramku.",
                    label = "Doba nasazení",
                },
                ankleMonitorAnimScenario = {
                    description = "Scénář přehrávaný při nasazování elektronického náramku.",
                    label = "Scénář nasazení",
                },
                ankleMonitorAttachBone = {
                    description = "Kost postavy (ped) použitá k připojení rekvizity elektronického náramku.",
                    label = "Připojovací kost",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Odebrat předmět náramku po nasazení.",
                    label = "Spotřebovat náramek",
                },
                ankleMonitorCutItem = {
                    description = "Předmět z inventáře použitý k odstranění elektronického náramku.",
                    label = "Předmět pro odstřihnutí",
                },
                ankleMonitorEnabled = {
                    description = "Povolit nasazování elektronického náramku.",
                    label = "Elektronický náramek",
                },
                ankleMonitorItem = {
                    description = "Předmět z inventáře použitý k nasazení elektronického náramku.",
                    label = "Předmět náramku",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Počet milisekund mezi aktualizacemi mapy elektronického náramku.",
                    label = "Interval aktualizace mapy",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Zachová elektronické náramky v databázi, když se sledovaní hráči odpojí, aby se obnovily po opětovném připojení a restartu serveru.",
                    label = "Zachovat po odpojení",
                },
                ankleMonitorPlaceDistance = {
                    description = "Maximální vzdálenost pro nasazení elektronického náramku.",
                    label = "Vzdálenost pro nasazení",
                },
                ankleMonitorPropModel = {
                    description = "Model rekvizity použitý pro vzhled elektronického náramku.",
                    label = "Model rekvizity",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Vyžadovat stav služby před použitím elektronických náramků.",
                    label = "Náramek vyžaduje službu",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Vyžadovat, aby hráč patřil do policejní skupiny před použitím elektronických náramků.",
                    label = "Náramek vyžaduje policejní práci",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Vrátit předmět náramku při jeho odstranění.",
                    label = "Vrátit náramek při odstranění",
                },
                ankleMonitorWarningSeconds = {
                    description = "Doba varování před nahlášením porušení zóny elektronického náramku dispečinku.",
                    label = "Sekundy varování zóny",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Počet milisekund mezi varovnými pípnutími zóny elektronického náramku.",
                    label = "Interval pípání zóny",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Název zvuku použitého pro varování zóny elektronického náramku.",
                    label = "Zvuk pípání",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Sada zvuků použitá pro varování zóny elektronického náramku.",
                    label = "Sada zvuků pípání",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Hodnota průhlednosti použitá pro ikony zóny elektronického náramku.",
                    label = "Průhlednost ikony",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Barva ikony použitá, když se cíl nachází uvnitř povolené oblasti.",
                    label = "Barva ikony povolené zóny",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Barva ikony použitá, když cíl opustí povolenou oblast.",
                    label = "Barva ikony vyloučené zóny",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Počet milisekund mezi kontrolami zóny elektronického náramku.",
                    label = "Interval kontroly zóny",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Počet sekund před odesláním dalšího hlášení o zóně elektronického náramku.",
                    label = "Prodleva dispečinku zóny",
                },
                ankleMonitorZoneEnabled = {
                    description = "Povolit kontroly zón elektronického náramku.",
                    label = "Zóny elektronického náramku",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Vzhled ikony (blip) použitý pro značky zóny elektronického náramku.",
                    label = "Vzhled ikony zóny",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Poloměr použitý pro obrysy zóny elektronického náramku.",
                    label = "Poloměr obrysu",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Velikost kroku použitá pro obrysy zóny elektronického náramku.",
                    label = "Krok obrysu",
                },
                billingAccount = {
                    description = "Záložní účet použitý, pokud práce nemá nakonfigurovaný účet společnosti.",
                    label = "Záložní účet společnosti",
                },
                billingCloseOnSuccess = {
                    description = "Zavřít rozhraní účtování po vystavení účtu.",
                    label = "Zavřít po úspěchu",
                },
                billingCurrency = {
                    description = "Klíč měny použitý pro účtování. Ponechte prázdné pro výchozí měnu.",
                    label = "Měna",
                },
                billingCustomReasons = {
                    description = "Povolit vlastní důvody účtování místo pouze předvoleb.",
                    label = "Vlastní důvody",
                },
                billingDepositToSociety = {
                    description = "Ukládat příjmy z účtování na účet společnosti dané práce.",
                    label = "Vklad do společnosti",
                },
                billingMaxReasonLength = {
                    description = "Maximální počet znaků pro vlastní důvod účtování.",
                    label = "Délka důvodu",
                },
                billingMode = {
                    description = "Zvolte, zda policejní účty strhávají platbu okamžitě, vyžadují potvrzení od občana, nebo používají systém účtování rámce.",
                    label = "Režim účtování",
                    options = {
                        consent = "Zaplatit nebo odmítnout",
                        framework = "Účet rámce",
                        instant = "Okamžitá platba",
                    },
                },
                billingRange = {
                    description = "Maximální vzdálenost k cíli pro vystavení policejního účtu.",
                    label = "Dosah účtování",
                },
                billingReasonPresets = {
                    description = "Předvolené důvody účtování zobrazené v rozhraní účtování.",
                    itemLabel = "Důvod",
                    label = "Předvolby důvodů",
                },
                billingRefreshSeconds = {
                    description = "Interval obnovení cíle, dokud je otevřené rozhraní účtování.",
                    label = "Sekundy obnovení",
                },
                billingShowRecipientName = {
                    description = "Zobrazit jméno občana v náhledech pokut a na účtenkách.",
                    label = "Zobrazit jméno příjemce",
                },
                carryAllowCarrierInVehicle = {
                    description = "Umožní nosiči nastoupit a řídit vozidlo bez položení neseného hráče.",
                    label = "Povolit nosiči vozidlo",
                },
                carryAllowConscious = {
                    description = "Povolit nošení cílů při vědomí.",
                    label = "Nošení při vědomí",
                },
                carryAllowSprint = {
                    description = "Povolit sprint při nošení jiného hráče.",
                    label = "Povolit sprint při nošení",
                },
                carryEnabled = {
                    description = "Povolit nošení hráčů.",
                    label = "Nošení",
                },
                carryMaxDistance = {
                    description = "Maximální vzdálenost pro zahájení nošení hráče.",
                    label = "Vzdálenost pro nošení",
                },
                carryRequireOnDuty = {
                    description = "Vyžadovat stav služby před zahájením nošení.",
                    label = "Nošení vyžaduje službu",
                },
                cctvDamageCooldownMs = {
                    description = "Počet milisekund, než může CCTV znovu utrpět poškození.",
                    label = "Prodleva poškození",
                },
                cctvDamagePerHit = {
                    description = "Poškození odolnosti způsobené kameře CCTV za jeden zásah.",
                    label = "Poškození za zásah",
                },
                cctvDefaultName = {
                    description = "Výchozí zobrazovaný název pro nasazené kamery CCTV.",
                    label = "Výchozí název CCTV",
                },
                cctvDefaultPitch = {
                    description = "Výchozí sklon kamery pro umístění CCTV.",
                    label = "Výchozí sklon",
                },
                cctvDisassembleDistance = {
                    description = "Vzdálenost použitá k demontáži kamer CCTV.",
                    label = "Vzdálenost demontáže",
                },
                cctvEnabled = {
                    description = "Povolit umísťování a přenos kamer CCTV.",
                    label = "Kamery CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Vzdálenost, při které se zobrazuje stav odolnosti CCTV.",
                    label = "Vzdálenost zobrazení stavu",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Počet milisekund, po které zůstává viditelný stav odolnosti CCTV.",
                    label = "Doba zobrazení stavu",
                },
                cctvHealthTextOffset = {
                    description = "Svislé odsazení použité pro text stavu odolnosti CCTV.",
                    label = "Odsazení textu stavu",
                },
                cctvHeightStep = {
                    description = "Krok výšky použitý při umísťování kamer CCTV.",
                    label = "Krok výšky",
                },
                cctvItem = {
                    description = "Předmět z inventáře použitý k umístění kamer CCTV.",
                    label = "Předmět CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Práh odolnosti, při kterém se doporučuje údržba CCTV.",
                    label = "Práh údržby",
                },
                cctvMaxDurability = {
                    description = "Maximální odolnost kamery CCTV.",
                    label = "Odolnost CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Počet sekund, než může kamera vytvořit další hlášení pohybu.",
                    label = "Prodleva dispečinku",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Počet milisekund mezi klientskými kontrolami pohybu.",
                    label = "Interval skenování",
                },
                cctvMotionClientCooldownMs = {
                    description = "Počet milisekund, než může jeden klient znovu nahlásit stejnou kameru.",
                    label = "Prodleva hlášení klienta",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Automaticky zapnout upozornění na pohyb u nově umístěných kamer CCTV.",
                    label = "Nové kamery ve výchozím stavu aktivní",
                },
                cctvMotionDetectionEnabled = {
                    description = "Povolit dispečerská upozornění na pohyb pro jednotlivé kamery CCTV.",
                    label = "Upozornění na pohyb",
                },
                cctvMotionDetectionRadius = {
                    description = "Maximální vzdálenost detekce pohybu v metrech.",
                    label = "Poloměr detekce",
                },
                cctvMotionFieldOfView = {
                    description = "Úhel kuželu detekce pohybu ve stupních.",
                    label = "Zorné pole",
                },
                cctvMotionJobs = {
                    description = "Názvy jobů nebo klíče skupin jobů, které přijímají hlášení pohybu CCTV.",
                    itemLabel = "Job nebo skupina",
                    label = "Dispečerské joby",
                },
                cctvMotionMinimumSpeed = {
                    description = "Minimální rychlost objektu v metrech za sekundu, která se počítá jako pohyb.",
                    label = "Minimální rychlost pohybu",
                },
                cctvMoveStep = {
                    description = "Krok pohybu použitý při umísťování kamer CCTV.",
                    label = "Krok posunu",
                },
                cctvPropModel = {
                    description = "Model rekvizity použitý pro nasazené kamery CCTV.",
                    label = "Model rekvizity CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Slovník animací použitý při opravě kamer CCTV.",
                    label = "Slovník animací opravy",
                },
                cctvRepairAnimFlag = {
                    description = "Příznak animace použitý při opravě kamer CCTV.",
                    label = "Příznak animace opravy",
                },
                cctvRepairAnimName = {
                    description = "Název animace použité při opravě kamer CCTV.",
                    label = "Název animace opravy",
                },
                cctvRepairCancelDelayMs = {
                    description = "Počet milisekund, než lze opravu CCTV zrušit.",
                    label = "Prodleva zrušení opravy",
                },
                cctvRepairDistance = {
                    description = "Vzdálenost použitá k opravě kamer CCTV.",
                    label = "Vzdálenost opravy",
                },
                cctvRepairItem = {
                    description = "Předmět z inventáře použitý k opravě kamer CCTV.",
                    label = "Předmět opravy",
                },
                cctvRepairPerTick = {
                    description = "Odolnost obnovená za každý krok opravy CCTV.",
                    label = "Oprava za krok",
                },
                cctvRepairTickMs = {
                    description = "Počet milisekund mezi jednotlivými kroky opravy CCTV.",
                    label = "Interval opravy",
                },
                cctvRotateStep = {
                    description = "Krok otočení použitý při umísťování kamer CCTV.",
                    label = "Krok otočení",
                },
                cctvStreamDistance = {
                    description = "Vzdálenost použitá pro načítání kamer CCTV.",
                    label = "Vzdálenost načítání",
                },
                cctvViewOffset = {
                    description = "Odsazení pohledu použité pro zobrazení živého přenosu z CCTV.",
                    label = "Odsazení pohledu",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Vytvoří podél pásky blokující kolizní bariéru, aby jí hráči nemohli procházet.",
                    label = "Blokující kolize pásky",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Po úspěšném umístění odebrat z inventáře jeden předmět pásky.",
                    label = "Spotřebovat předmět pásky",
                },
                crimeSceneTapeDynamic = {
                    description = "Nechat pásku reagovat na fyziku a gravitaci namísto pevného ukotvení.",
                    label = "Dynamická fyzika",
                },
                crimeSceneTapeEnabled = {
                    description = "Povolit umísťování pásky místa činu pomocí předmětu z inventáře.",
                    label = "Páska místa činu",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Pásku smějí odstranit pouze povolené profese a při aktivním požadavku jen ve službě.",
                    label = "Omezit odstranění",
                },
                crimeSceneTapeItem = {
                    description = "Název předmětu v inventáři, který spustí umísťování pásky místa činu.",
                    label = "Předmět pásky",
                },
                crimeSceneTapeJobs = {
                    description = "Názvy profesí, které smějí používat pásku místa činu.",
                    itemLabel = "Profese",
                    label = "Povolené profese",
                },
                crimeSceneTapeLabel = {
                    description = "Zobrazovaný název pásky místa činu během umísťování.",
                    label = "Popisek pásky",
                },
                crimeSceneTapeLengthStep = {
                    description = "Přírůstek v metrech, na který se zaokrouhlí zvolená délka pásky.",
                    label = "Krok délky",
                },
                crimeSceneTapeMaxLength = {
                    description = "Nejdelší povolená vzdálenost mezi dvěma sloupky pásky v metrech.",
                    label = "Maximální délka pásky",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Maximální vzdálenost kteréhokoli koncového bodu od policisty, který pásku umisťuje.",
                    label = "Maximální vzdálenost umístění",
                },
                crimeSceneTapeMinLength = {
                    description = "Nejkratší povolená vzdálenost mezi dvěma sloupky pásky v metrech.",
                    label = "Minimální délka pásky",
                },
                crimeSceneTapeModel = {
                    description = "Název modelu rekvizity použitého pro umístěnou pásku místa činu.",
                    label = "Model pásky",
                },
                crimeSceneTapePostModel = {
                    description = "Model rekvizity použitý pro oba sloupky pásky.",
                    label = "Model sloupku",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Maximální vzdálenost pro odstranění umístěné pásky místa činu.",
                    label = "Vzdálenost odstranění",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Pásku smějí umísťovat pouze členové povolených profesí ve službě.",
                    label = "Vyžadovat službu",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Při odstranění umístěné pásky vrátit spotřebovaný předmět.",
                    label = "Vrátit předmět při odstranění",
                },
                crimeSceneTapeSag = {
                    description = "Maximální prověšení pásky mezi sloupky směrem dolů v metrech.",
                    label = "Prověšení pásky",
                },
                crimeSceneTapeSections = {
                    description = "Nativní modely úseků pásky použité k sestavení zvolené délky.",
                    itemLabel = "Úsek pásky",
                    label = "Úseky pásky",
                },
                crimeSceneTapeShowPosts = {
                    description = "Vytvoří viditelné podpěrné sloupky na obou koncích pásky místa činu s proměnnou délkou.",
                    label = "Zobrazit sloupky pásky",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Vzdálenost, ve které se umístěná páska místa činu načítá.",
                    label = "Vzdálenost načítání",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Výška pásky nad vybranými body na zemi.",
                    label = "Výška pásky",
                },
                crimeSceneTapeVariableLength = {
                    description = "Umožní policistům určit počáteční a koncový bod a umístit pásku místa činu v nastavitelné délce.",
                    label = "Proměnná délka pásky",
                },
                crimeSceneTapeZOffset = {
                    description = "Svislý posun použitý při umístění modelu pásky.",
                    label = "Výškový posun",
                },
                cuffsAnimDict = {
                    description = "Slovník animací použitý pro spoutané hráče.",
                    label = "Slovník animací",
                },
                cuffsAnimFlag = {
                    description = "Příznak animace použitý pro spoutané hráče.",
                    label = "Příznak animace",
                },
                cuffsAnimName = {
                    description = "Název animace použité pro spoutané hráče.",
                    label = "Název animace",
                },
                cuffsConsumeItem = {
                    description = "Odebrat předmět pout při nasazení.",
                    label = "Spotřebovat pouta",
                },
                cuffsEnabled = {
                    description = "Povolit akce spoutání.",
                    label = "Pouta",
                },
                cuffsEscapeEnabled = {
                    description = "Povolit minihru útěku z pout.",
                    label = "Útěk z pout",
                },
                cuffsEscapeKeyPool = {
                    description = "Klávesy, které se mohou objevit v minihře útěku z pout.",
                    itemLabel = "Klávesa",
                    label = "Sada kláves útěku",
                },
                cuffsEscapeRounds = {
                    description = "Počet kol vyžadovaných v minihře útěku z pout.",
                    label = "Počet kol útěku",
                },
                cuffsEscapeWindowMs = {
                    description = "Počet milisekund povolených na jedno vstupní okno v minihře útěku z pout.",
                    label = "Časové okno útěku",
                },
                cuffsHandsUpEnabled = {
                    description = "Povolit stav ruce nahoru používaný pouty a stahovacími páskami.",
                    label = "Ruce nahoru",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Počet sekund, po které musí být klávesa ruce nahoru podržena před aktivací.",
                    label = "Sekundy podržení ruce nahoru",
                },
                cuffsHandsUpKey = {
                    description = "Klávesa na klávesnici použitá ke zvednutí rukou.",
                    label = "Klávesa ruce nahoru",
                },
                cuffsItem = {
                    description = "Předmět z inventáře použitý pro akce spoutání.",
                    label = "Předmět pout",
                },
                cuffsMaxDistance = {
                    description = "Maximální vzdálenost k cíli pro akce spoutání.",
                    label = "Vzdálenost pro spoutání",
                },
                cuffsRequireItem = {
                    description = "Vyžadovat nakonfigurovaný předmět pout.",
                    label = "Pouta vyžadují předmět",
                },
                cuffsRequireOnDuty = {
                    description = "Vyžadovat stav služby před spoutáním.",
                    label = "Pouta vyžadují službu",
                },
                cuffsReturnOnRemove = {
                    description = "Vrátit předmět pout při jejich sejmutí.",
                    label = "Vrátit pouta",
                },
                dispatchOfficerDownEnabled = {
                    description = "Odeslat hlášení dispečinku, když policista ve službě upadne do bezvědomí.",
                    label = "Hlášení policista v ohrožení",
                },
                dispatchOfficerDownJobs = {
                    description = "Práce, které mají dostávat hlášení o policistovi v ohrožení.",
                    itemLabel = "Práce",
                    label = "Práce pro hlášení policista v ohrožení",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Upozornit pouze hráče, kteří jsou aktuálně ve službě.",
                    label = "Hlášení policista v ohrožení vyžaduje službu",
                },
                dispatchShotsFiredChance = {
                    description = "Pravděpodobnost od 0.0 do 1.0, že detekovaný výstřel vytvoří upozornění.",
                    label = "Pravděpodobnost upozornění",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Počet sekund, po kterých může stejný hráč znovu spustit hlášení o výstřelech.",
                    label = "Prodleva hlášení výstřelů",
                },
                dispatchShotsFiredEnabled = {
                    description = "Povolit hlášení dispečinku o výstřelech.",
                    label = "Hlášení výstřelů",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Zbraně, které by neměly spouštět hlášení o výstřelech.",
                    itemLabel = "Zbraň",
                    label = "Ignorované zbraně",
                },
                dispatchShotsFiredJobs = {
                    description = "Práce, které mají dostávat hlášení o výstřelech.",
                    itemLabel = "Práce",
                    label = "Práce pro hlášení výstřelů",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Upozornit pouze hráče, kteří jsou aktuálně ve službě.",
                    label = "Hlášení výstřelů vyžaduje službu",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Vytvořit záznam dispečinku při zjištění výstřelů.",
                    label = "Odeslat hlášení o výstřelech",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Pravděpodobnost od 0.0 do 1.0, že tlumený výstřel vytvoří upozornění.",
                    label = "Pravděpodobnost upozornění na tlumený výstřel",
                },
                escortEnabled = {
                    description = "Povolit doprovázení hráčů.",
                    label = "Doprovod",
                },
                escortMaxDistance = {
                    description = "Maximální vzdálenost pro zahájení doprovodu hráče.",
                    label = "Vzdálenost pro doprovod",
                },
                escortRequireOnDuty = {
                    description = "Vyžadovat stav služby před doprovázením hráčů.",
                    label = "Doprovod vyžaduje službu",
                },
                escortVehicleDistance = {
                    description = "Maximální vzdálenost pro umístění doprovázeného hráče do vozidla.",
                    label = "Vzdálenost pro doprovod do vozidla",
                },
                evidenceBloodDamageThreshold = {
                    description = "Minimální práh poškození před vytvořením důkazu krve.",
                    label = "Práh poškození pro krev",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Počet milisekund před vytvořením další nábojnice.",
                    label = "Prodleva vzniku nábojnice",
                },
                evidenceCasingMergeRadius = {
                    description = "Poloměr použitý pro sloučení blízkých nábojnic.",
                    label = "Poloměr sloučení nábojnic",
                },
                evidenceCleanupIntervalMs = {
                    description = "Počet milisekund mezi průchody úklidu důkazů.",
                    label = "Interval úklidu",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Počet sekund, po kterých terénní důkazy automaticky vyprší.",
                    label = "Životnost před úklidem",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Čistič pro všechny",
                    description = "Povolit všem odstraňovat stopy peroxidem vodíku. Vypněte pro použití seznamů prací a gangů.",
                },
                evidenceCleanerJobs = {
                    label = "Práce pro čistič",
                    description = "Interní názvy povolené při vypnutém veřejném přístupu. Shoda práce nebo gangu povolí přístup; prázdné seznamy jej zakážou.",
                    itemLabel = "Práce",
                },
                evidenceCleanerGangs = {
                    label = "Gangy pro čistič",
                    description = "Interní názvy povolené při vypnutém veřejném přístupu. Shoda práce nebo gangu povolí přístup; prázdné seznamy jej zakážou.",
                    itemLabel = "Gang",
                },
                evidenceCollectDistance = {
                    description = "Vzdálenost použitá pro sběr terénních důkazů.",
                    label = "Vzdálenost sběru",
                },
                evidenceDiscoverDistance = {
                    description = "Vzdálenost použitá k objevení blízkých značek důkazů.",
                    label = "Vzdálenost objevení",
                },
                evidenceFieldEnabled = {
                    description = "Povolit vytváření a sběr důkazů v terénu.",
                    label = "Terénní důkazy",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Zbraň použitá k prohledávání a odhalování důkazů v terénu.",
                    label = "Zbraň svítilny",
                },
                evidenceGloveFreeHands = {
                    description = "ID komponent rukou považovaných za nenošení rukavic.",
                    label = "Holé ruce bez rukavic",
                },
                evidenceMarkerColor = {
                    description = "Barva RGBA použitá pro značky terénních důkazů.",
                    label = "Barva značky",
                },
                evidenceMarkerDrawDistance = {
                    description = "Dohledová vzdálenost použitá pro značky terénních důkazů.",
                    label = "Dohledová vzdálenost",
                },
                evidenceMarkerOffset = {
                    description = "Svislé odsazení značky použité pro terénní důkazy.",
                    label = "Odsazení",
                },
                evidenceMarkerScaleX = {
                    description = "Měřítko X značky použité pro terénní důkazy.",
                    label = "Měřítko X",
                },
                evidenceMarkerScaleY = {
                    description = "Měřítko Y značky použité pro terénní důkazy.",
                    label = "Měřítko Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Měřítko Z značky použité pro terénní důkazy.",
                    label = "Měřítko Z",
                },
                evidenceMarkerType = {
                    description = "Typ značky použitý pro terénní důkazy.",
                    label = "Typ značky",
                },
                evidenceMaxCreateDistance = {
                    description = "Maximální vzdálenost pro vytváření záznamů důkazů.",
                    label = "Vzdálenost pro vytvoření",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Počet milisekund povolených pro souhlas s odběrem vzorku slin.",
                    label = "Časový limit souhlasu se slinami",
                },
                evidenceScannerDistance = {
                    description = "Vzdálenost použitá pro interakce se skenerem důkazů.",
                    label = "Vzdálenost skeneru",
                },
                evidenceScannerDurationMs = {
                    description = "Doba trvání akce otisků/skeneru v milisekundách.",
                    label = "Doba skeneru",
                },
                evidenceStorageMaxCompartments = {
                    description = "Maximální počet přihrádek úložiště důkazů.",
                    label = "Přihrádky úložiště",
                },
                gpsTrackerBeepDistance = {
                    description = "Vzdálenost, od které se stává relevantní zpětná vazba pípání GPS lokátoru.",
                    label = "Vzdálenost pípání",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Počet milisekund mezi pípnutími při vzdálení se od lokátoru.",
                    label = "Interval pípání zdálky",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Počet milisekund mezi pípnutími při přiblížení k lokátoru.",
                    label = "Interval pípání zblízka",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Odebrat předmět lokátoru po umístění.",
                    label = "Spotřebovat GPS lokátor",
                },
                gpsTrackerEnabled = {
                    description = "Povolit umísťování a skenování GPS lokátoru na vozidlech.",
                    label = "GPS lokátor",
                },
                gpsTrackerItem = {
                    description = "Předmět z inventáře použitý k umístění GPS lokátoru.",
                    label = "Předmět lokátoru",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Počet milisekund mezi aktualizacemi mapy lokátoru.",
                    label = "Interval aktualizace mapy",
                },
                gpsTrackerPlaceDistance = {
                    description = "Maximální vzdálenost pro umístění GPS lokátoru na vozidlo.",
                    label = "Vzdálenost pro umístění",
                },
                gpsTrackerRemoveDistance = {
                    description = "Maximální vzdálenost pro odstranění umístěného GPS lokátoru.",
                    label = "Vzdálenost pro odstranění",
                },
                gpsTrackerRemoveKey = {
                    description = "Kód ovládání použitý k odstranění umístěného GPS lokátoru.",
                    label = "Klávesa pro odstranění",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Vyžadovat stav služby před použitím GPS lokátorů.",
                    label = "GPS vyžaduje službu",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Vyžadovat, aby hráč patřil do policejní skupiny před použitím GPS lokátorů.",
                    label = "GPS vyžaduje policejní práci",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Vrátit předmět lokátoru při jeho odstranění.",
                    label = "Vrátit lokátor při odstranění",
                },
                gpsTrackerScanDistance = {
                    description = "Maximální vzdálenost pro skenování lokátorů.",
                    label = "Vzdálenost skenování GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Počet milisekund strávených skenováním GPS lokátoru.",
                    label = "Doba skenování",
                },
                gpsTrackerScannerWeapon = {
                    description = "Zbraň nebo nástroj použitý ke skenování GPS lokátorů.",
                    label = "Zbraň skeneru",
                },
                impoundAccount = {
                    description = "Účet použitý k účtování vyzvednutí z odtahu.",
                    label = "Platební účet",
                },
                impoundCreatorVehicleModel = {
                    description = "Model vozidla zobrazený v náhledu tvůrce odtahu.",
                    label = "Model vozidla tvůrce",
                },
                impoundCustomGarageEnabled = {
                    description = "Použít vlastní rozhraní garáže pro odtah, pokud je dostupné.",
                    label = "Vlastní rozhraní odtahu z garáže",
                },
                impoundDefaultPrice = {
                    description = "Výchozí cena za vyzvednutí z odtahu.",
                    label = "Výchozí cena",
                },
                impoundDeliveryDistance = {
                    description = "Vzdálenost použitá pro interakce doručení na odtah.",
                    label = "Vzdálenost doručení",
                },
                impoundDeliveryMarker = {
                    description = "Konfigurace značky použitá pro doručení na odtah.",
                    label = "Značka doručení",
                },
                impoundEnabled = {
                    description = "Povolit procesy odtahu.",
                    label = "Odtah",
                },
                impoundMarker = {
                    description = "Konfigurace značky použitá pro interakce s odtahem.",
                    label = "Značka odtahu",
                },
                impoundRadialEnabled = {
                    description = "Povolit radiální akce odtahu.",
                    label = "Akce odtahu",
                },
                impoundRadialRequireOnDuty = {
                    description = "Vyžadovat stav služby před použitím radiální akce odtahu.",
                    label = "Odtah vyžaduje službu",
                },
                impoundRadialVehicleDistance = {
                    description = "Maximální vzdálenost k cílovému vozidlu pro radiální akci odtahu.",
                    label = "Vzdálenost odtahovaného vozidla",
                },
                impoundReleaseDistance = {
                    description = "Vzdálenost použitá pro interakce vyzvednutí z odtahu.",
                    label = "Vzdálenost vyzvednutí",
                },
                impoundReleaseKey = {
                    description = "Kód ovládání použitý k vyzvednutí odtažených vozidel.",
                    label = "Klávesa vyzvednutí",
                },
                impoundRequireDelivery = {
                    description = "Vyžadovat doručení do nakonfigurovaného odtahového depa.",
                    label = "Vyžadovat doručení",
                },
                impoundStorageBasePrice = {
                    description = "Základní cena vyzvednutí uskladněných odtažených vozidel.",
                    label = "Základní cena skladování",
                },
                impoundStorageDailyFee = {
                    description = "Dodatečný poplatek za skladování na odtahu za každý nakonfigurovaný den.",
                    label = "Denní poplatek za skladování",
                },
                impoundStorageDaySeconds = {
                    description = "Kolik sekund se počítá jako jeden zúčtovací den skladování.",
                    label = "Sekundy skladovacího dne",
                },
                impoundStorageEnabled = {
                    description = "Povolit zpracování placeného skladování na odtahu.",
                    label = "Zpoplatněné parkování na odtahu",
                },
                jailAssignRange = {
                    description = "Maximální vzdálenost pro poslání cíle do vězení.",
                    label = "Dosah přiřazení",
                },
                jailCanteenCooldownMinutes = {
                    description = "Počet minut, které musí vězeň čekat před dalším vyzvednutím balíčku z kantýny.",
                    label = "Minuty prodlevy",
                },
                jailCanteenPackage = {
                    description = "Předměty poskytnuté balíčkem vězeňské kantýny.",
                    label = "Balíček kantýny",
                },
                jailCellStreamDistance = {
                    description = "Vzdálenost použitá pro načítání rekvizit samotky.",
                    label = "Vzdálenost načítání cely",
                },
                jailClearInventory = {
                    description = "Vyprázdnit inventář hráče při jeho poslání do vězení.",
                    label = "Vyprázdnit inventář",
                },
                jailDefaultMonths = {
                    description = "Výchozí délka trestu při otevření rozhraní přiřazení.",
                    label = "Výchozí počet měsíců",
                },
                jailDispatchJobs = {
                    description = "Práce, které mají dostávat hlášení dispečinku z vězení.",
                    itemLabel = "Práce",
                    label = "Práce pro dispečink",
                },
                jailDoctorHealEvent = {
                    description = "Serverová nebo klientská událost spouštěná, když vězeňský lékař vyléčí vězně.",
                    label = "Událost léčby",
                },
                jailElectricalCodeListItem = {
                    description = "Předmět z inventáře vyžadovaný k odhalení vygenerovaných kódů rozvaděče.",
                    label = "Předmět seznamu kódů",
                },
                jailElectricalCodeMax = {
                    description = "Nejvyšší hodnota náhodného kódu pro rozvaděč.",
                    label = "Maximální kód",
                },
                jailElectricalCodeMin = {
                    description = "Nejnižší hodnota náhodného kódu pro rozvaděč.",
                    label = "Minimální kód",
                },
                jailElectricalCodesCount = {
                    description = "Kolik kandidátních kódů se vygeneruje pro rozvaděč.",
                    label = "Počet kódů",
                },
                jailElectricalEnabled = {
                    description = "Povolit minihru útěku pomocí rozvaděče.",
                    label = "Rozvaděč",
                },
                jailElectricalPinLength = {
                    description = "Počet číslic použitých pro PIN kódy rozvaděče.",
                    label = "Délka PIN kódu",
                },
                jailElectricalPropModel = {
                    description = "Model herní rekvizity použitý pro vězeňský rozvaděč.",
                    label = "Model rekvizity",
                },
                jailElectricalShockDamage = {
                    description = "Poškození způsobené, pokud vězeň neuspěje v elektrické sekvenci.",
                    label = "Poškození zásahem elektrickým proudem",
                },
                jailElectricalShockRagdollMs = {
                    description = "Počet milisekund ochromení (ragdoll) po zásahu elektrickým proudem.",
                    label = "Doba ochromení zásahem",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Počet minut trestu odečtených po úspěšném pokusu o útěk pomocí rozvaděče.",
                    label = "Minuty zkrácení při úspěchu",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Množství vyžadované pro obchod s vězněm alkoholikem.",
                    label = "Požadované množství",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Předmět vyžadovaný pro obchod s vězněm alkoholikem.",
                    label = "Požadovaný předmět",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Množství odměny za obchod s vězněm alkoholikem.",
                    label = "Množství odměny",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Odměnový předmět za obchod s vězněm alkoholikem.",
                    label = "Odměnový předmět",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Popisek odměny zobrazený u obchodu s vězněm alkoholikem.",
                    label = "Popisek odměny",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Množství vyžadované pro obchod s vězněm informátorem.",
                    label = "Požadované množství",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Předmět vyžadovaný pro obchod s vězněm informátorem.",
                    label = "Požadovaný předmět",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Množství odměny za obchod s vězněm informátorem.",
                    label = "Množství odměny",
                },
                jailInmateCodeListRewardItem = {
                    description = "Odměnový předmět za obchod s vězněm informátorem.",
                    label = "Odměnový předmět",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Popisek odměny zobrazený u obchodu s vězněm informátorem.",
                    label = "Popisek odměny",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Předměty přijímané pro obchod s vězněm dealerem.",
                    label = "Přijímané předměty",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Množství vyžadované pro obchod s vězněm dealerem.",
                    label = "Požadované množství",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Množství odměny za obchod s vězněm dealerem.",
                    label = "Množství odměny",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Odměnový předmět za obchod s vězněm dealerem.",
                    label = "Odměnový předmět",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Popisek odměny zobrazený u obchodu s vězněm dealerem.",
                    label = "Popisek odměny",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Umožnit, aby kontraband nalezený při úklidu ve vězení platil pro obchod s vězněm dealerem.",
                    label = "Použít kontraband z úklidu",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Množství vyžadované pro obchod s vězněm pašerákem nářadí.",
                    label = "Požadované množství",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Předmět vyžadovaný pro obchod s vězněm pašerákem nářadí.",
                    label = "Požadovaný předmět",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Množství odměny za obchod s vězněm pašerákem nářadí.",
                    label = "Množství odměny",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Odměnový předmět za obchod s vězněm pašerákem nářadí.",
                    label = "Odměnový předmět",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Popisek odměny zobrazený u obchodu s vězněm pašerákem nářadí.",
                    label = "Popisek odměny",
                },
                jailJobsCarryBoxModel = {
                    description = "Model rekvizity použitý pro bednu při přenášecí práci ve vězení.",
                    label = "Model bedny",
                },
                jailJobsCarryDropoffKey = {
                    description = "Kód ovládání použitý k odložení beden při přenášecí práci.",
                    label = "Klávesa odložení nákladu",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Poloměr místa odložení pro přenášecí práci ve vězení.",
                    label = "Poloměr místa odložení",
                },
                jailJobsCarryInspectKey = {
                    description = "Kód ovládání použitý ke kontrole beden při přenášecí práci.",
                    label = "Klávesa kontroly",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Nepoužitelné předměty, které lze nalézt při kontrole beden při přenášecí práci.",
                    label = "Nepoužitelné předměty kontroly",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Šance na použitelnou odměnu při kontrole beden.",
                    label = "Šance na použitelný nález",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Použitelné předměty, které lze nalézt při kontrole beden při přenášecí práci.",
                    label = "Použitelné předměty kontroly",
                },
                jailJobsCarryInteractDistance = {
                    description = "Interakční vzdálenost pro přenášecí práci ve vězení.",
                    label = "Interakční vzdálenost přenášení",
                },
                jailJobsCarryMaxDistance = {
                    description = "Maximální povolená vzdálenost pro postup přenášecí práce ve vězení.",
                    label = "Maximální vzdálenost přenášení",
                },
                jailJobsCarryPickupKey = {
                    description = "Kód ovládání použitý k sebrání beden při přenášecí práci.",
                    label = "Klávesa sebrání nákladu",
                },
                jailJobsCarryPickupOffset = {
                    description = "Objekt odsazení použitý pro místo sebrání nákladu.",
                    label = "Odsazení místa sebrání",
                },
                jailJobsCarryTimeReduction = {
                    description = "Zkrácení trestu za dokončení přenášecí práce ve vězení.",
                    label = "Zkrácení trestu za přenášení",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Kód ovládání použitý u vězeňské popelnice.",
                    label = "Klávesa popelnice",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Model použitý pro rekvizitu vězeňské popelnice.",
                    label = "Model popelnice",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Šance na nalezení kontrabandu při úklidu.",
                    label = "Šance na nález kontrabandu",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Předměty, které lze nalézt při úklidu ve vězení.",
                    label = "Předměty nálezu kontrabandu",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Časový limit pro výzvy o nálezu kontrabandu v milisekundách.",
                    label = "Časový limit výzvy nálezu",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Vzdálenost použitá pro interakci s odpadky při úklidu.",
                    label = "Interakční vzdálenost úklidu",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Maximální vzdálenost, po jejímž překročení se rekvizity úklidu resetují nebo zmizí.",
                    label = "Maximální vzdálenost úklidu",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Maximální počet současně existujících rekvizit odpadků při úklidu ve vězení.",
                    label = "Maximální počet rekvizit odpadků",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Minimální vzdálenost od středu pro generování odpadků při úklidu.",
                    label = "Minimální poloměr generování",
                },
                jailJobsCleaningPickupKey = {
                    description = "Kód ovládání použitý k sebrání odpadků při úklidu ve vězení.",
                    label = "Klávesa sebrání při úklidu",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Počet milisekund mezi pokusy o generování odpadků při úklidu.",
                    label = "Interval generování odpadků",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Poloměr použitý pro generování rekvizit odpadků při úklidu.",
                    label = "Poloměr generování odpadků",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modely rekvizit odpadků použité pro úklidovou práci ve vězení.",
                    itemLabel = "Vzor",
                    label = "Modely odpadků",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Barva RGBA obrysu použitá pro rekvizity odpadků při úklidu ve vězení.",
                    label = "Barva obrysu",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Povolit obrysy na rekvizitách odpadků při úklidu ve vězení.",
                    label = "Obrys odpadků",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID shaderu použitého pro obrysy odpadků při úklidu ve vězení.",
                    label = "Shader obrysu",
                },
                jailJobsTimeReduction = {
                    description = "Zkrácení trestu za dokončení úklidové práce ve vězení.",
                    label = "Zkrácení trestu za úklid",
                },
                jailJobsTrashGoal = {
                    description = "Počet odpadků potřebných k dokončení úklidové práce ve vězení.",
                    label = "Cíl množství odpadků",
                },
                jailMaxMonths = {
                    description = "Maximální volitelná délka trestu.",
                    label = "Maximální počet měsíců",
                },
                jailMinMonths = {
                    description = "Minimální volitelná délka trestu.",
                    label = "Minimální počet měsíců",
                },
                jailMonthMinutes = {
                    description = "Počet reálných minut odpovídajících jednomu vězeňskému měsíci.",
                    label = "Minut na měsíc",
                },
                jailObjectStreamDistance = {
                    description = "Vzdálenost použitá pro načítání trvalých herních objektů vězení.",
                    label = "Vzdálenost načítání objektů",
                },
                jailOutfitApplyDelayMs = {
                    description = "Zpoždění po připojení, než se aplikuje vězeňské oblečení.",
                    label = "Zpoždění aplikace oblečení",
                },
                jailOutfitEnabled = {
                    description = "Povolit vězeňské oblečení.",
                    label = "Vězeňské oblečení",
                },
                jailOutfitFemaleArms = {
                    description = "Komponenta rukou dámského vězeňského oblečení.",
                    label = "Ruce",
                },
                jailOutfitFemaleChain1 = {
                    description = "Model řetízku dámského vězeňského oblečení.",
                    label = "Řetízek 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Textura řetízku dámského vězeňského oblečení.",
                    label = "Řetízek 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Model nášivek dámského vězeňského oblečení.",
                    label = "Nášivky 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Textura nášivek dámského vězeňského oblečení.",
                    label = "Nášivky 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Model brýlí dámského vězeňského oblečení (-1 odstraní brýle).",
                    label = "Brýle 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Textura brýlí dámského vězeňského oblečení.",
                    label = "Brýle 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Model helmy dámského vězeňského oblečení.",
                    label = "Helma 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Textura helmy dámského vězeňského oblečení.",
                    label = "Helma 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Model kalhot dámského vězeňského oblečení.",
                    label = "Kalhoty 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Textura kalhot dámského vězeňského oblečení.",
                    label = "Kalhoty 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Model bot dámského vězeňského oblečení.",
                    label = "Boty 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Textura bot dámského vězeňského oblečení.",
                    label = "Boty 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Model trupu dámského vězeňského oblečení.",
                    label = "Trup 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Textura trupu dámského vězeňského oblečení.",
                    label = "Trup 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Model trička dámského vězeňského oblečení.",
                    label = "Tričko 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Textura trička dámského vězeňského oblečení.",
                    label = "Tričko 2",
                },
                jailOutfitMaleArms = {
                    description = "Komponenta rukou pánského vězeňského oblečení.",
                    label = "Ruce",
                },
                jailOutfitMaleChain1 = {
                    description = "Model řetízku pánského vězeňského oblečení.",
                    label = "Řetízek 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Textura řetízku pánského vězeňského oblečení.",
                    label = "Řetízek 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Model nášivek pánského vězeňského oblečení.",
                    label = "Nášivky 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Textura nášivek pánského vězeňského oblečení.",
                    label = "Nášivky 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Model brýlí pánského vězeňského oblečení (-1 odstraní brýle).",
                    label = "Brýle 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Textura brýlí pánského vězeňského oblečení.",
                    label = "Brýle 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Model helmy pánského vězeňského oblečení.",
                    label = "Helma 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Textura helmy pánského vězeňského oblečení.",
                    label = "Helma 2",
                },
                jailOutfitMalePants1 = {
                    description = "Model kalhot pánského vězeňského oblečení.",
                    label = "Kalhoty 1",
                },
                jailOutfitMalePants2 = {
                    description = "Textura kalhot pánského vězeňského oblečení.",
                    label = "Kalhoty 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Model bot pánského vězeňského oblečení.",
                    label = "Boty 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Textura bot pánského vězeňského oblečení.",
                    label = "Boty 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Model trupu pánského vězeňského oblečení.",
                    label = "Trup 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Textura trupu pánského vězeňského oblečení.",
                    label = "Trup 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Model trička pánského vězeňského oblečení.",
                    label = "Tričko 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Textura trička pánského vězeňského oblečení.",
                    label = "Tričko 2",
                },
                jailRequireJailTerminal = {
                    description = "Povolit policistům ukládat trest vězení pouze poblíž terminálu vybrané věznice.",
                    label = "Vyžadovat vězeňský terminál",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Obnovit uložené civilní oblečení, pokud vězeň uteče.",
                    label = "Obnovit oblečení při útěku",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Ochranné okno po obnovení, po jehož uplynutí přestane platit korekce spawnu.",
                    label = "Okno korekce obnovení",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleportovat obnovené vězně zpět na spawn ve vězení, pokud se načtou mimo zónu vězení.",
                    label = "Teleportovat obnovené vězně",
                },
                jailTerminalRange = {
                    description = "Maximální vzdálenost policisty od terminálu vybrané věznice.",
                    label = "Dosah vězeňského terminálu",
                },
                jailZoneExitGraceMs = {
                    description = "Ochranné okno před tím, než se opuštění zóny vězení počítá jako útěk.",
                    label = "Ochranná doba opuštění zóny",
                },
                mugshotAnimDict = {
                    description = "Slovník animací použitý při pořizování fotografie.",
                    label = "Slovník animací",
                },
                mugshotAnimFlag = {
                    description = "Příznak animace použitý při pořizování fotografie.",
                    label = "Příznak animace",
                },
                mugshotAnimName = {
                    description = "Název animace použité při pořizování fotografie.",
                    label = "Název animace",
                },
                mugshotBoardHeader = {
                    description = "Hlavní nadpis zobrazený na tabuli s fotografií.",
                    label = "Hlavička tabule",
                },
                mugshotBoardSubheader = {
                    description = "Záložní podnadpis zobrazený na tabuli s fotografií.",
                    label = "Podnadpis tabule",
                },
                mugshotCameraCoordsX = {
                    description = "Souřadnice světa X kamery použitá pro fotografie.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Souřadnice světa Y kamery použitá pro fotografie.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Souřadnice světa Z kamery použitá pro fotografie.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Zorné pole použité pro pořízení fotografie.",
                    label = "Zorné pole kamery",
                },
                mugshotCameraRotX = {
                    description = "Rotace X kamery použitá pro fotografie.",
                    label = "Rotace X",
                },
                mugshotCameraRotY = {
                    description = "Rotace Y kamery použitá pro fotografie.",
                    label = "Rotace Y",
                },
                mugshotCameraRotZ = {
                    description = "Rotace Z kamery použitá pro fotografie.",
                    label = "Rotace Z",
                },
                mugshotCaptureTimeout = {
                    description = "Maximální počet milisekund povolený pro callback pořízení fotografie.",
                    label = "Časový limit pořízení",
                },
                mugshotEnabled = {
                    description = "Povolit pořízení identifikační fotografie při příjmu do vězení.",
                    label = "Pořízení identifikační fotografie",
                },
                mugshotHeading = {
                    description = "Natočení použité při pořizování fotografie.",
                    label = "Natočení",
                },
                mugshotLocationX = {
                    description = "Souřadnice světa X použitá pro pořízení fotografie.",
                    label = "Poloha X",
                },
                mugshotLocationY = {
                    description = "Souřadnice světa Y použitá pro pořízení fotografie.",
                    label = "Poloha Y",
                },
                mugshotLocationZ = {
                    description = "Souřadnice světa Z použitá pro pořízení fotografie.",
                    label = "Poloha Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Formát popisu použitý pro uložená metadata fotografie.",
                    label = "Popis metadat",
                },
                mugshotMetadataName = {
                    description = "Název metadat inventáře použitý pro uloženou fotografii.",
                    label = "Název metadat",
                },
                mugshotWaitMs = {
                    description = "Počet milisekund čekání před vyfocením.",
                    label = "Milisekundy čekání",
                },
                playerSearchAnimDict = {
                    description = "Slovník animací použitý při prohlídkách hráče.",
                    label = "Slovník animací",
                },
                playerSearchAnimFlag = {
                    description = "Příznak animace použitý při prohlídkách hráče.",
                    label = "Příznak animace",
                },
                playerSearchAnimName = {
                    description = "Název animace použité při prohlídkách hráče.",
                    label = "Název animace",
                },
                playerSearchDurationMs = {
                    description = "Doba náhledu prohlídky hráče v milisekundách.",
                    label = "Doba trvání prohlídky",
                },
                playerSearchEnabled = {
                    description = "Povolit proces náhledu prohlídky hráče.",
                    label = "Prohlídka hráče",
                },
                playerSearchRange = {
                    description = "Maximální vzdálenost pro zahájení prohlídky hráče.",
                    label = "Dosah prohlídky",
                },
                playerSearchScenario = {
                    description = "Scénář použitý, pokud není přehrávána žádná explicitní animace prohlídky.",
                    label = "Scénář prohlídky",
                },
                policeBillingControl200 = {
                    label = "Fakturace · Ovládání 200",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeBillingControl322 = {
                    label = "Fakturace · Ovládání 322",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl10 = {
                    label = "Editor · Ovládání 10",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl11 = {
                    label = "Editor · Ovládání 11",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl172 = {
                    label = "Editor · Ovládání 172",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl173 = {
                    label = "Editor · Ovládání 173",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl174 = {
                    label = "Editor · Ovládání 174",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl175 = {
                    label = "Editor · Ovládání 175",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl177 = {
                    label = "Editor · Ovládání 177",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl191 = {
                    label = "Editor · Ovládání 191",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl201 = {
                    label = "Editor · Ovládání 201",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl202 = {
                    label = "Editor · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl21 = {
                    label = "Editor · Ovládání 21",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl32 = {
                    label = "Editor · Ovládání 32",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl322 = {
                    label = "Editor · Ovládání 322",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl33 = {
                    label = "Editor · Ovládání 33",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl34 = {
                    label = "Editor · Ovládání 34",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl35 = {
                    label = "Editor · Ovládání 35",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl36 = {
                    label = "Editor · Ovládání 36",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl37 = {
                    label = "Editor · Ovládání 37",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl38 = {
                    label = "Editor · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl44 = {
                    label = "Editor · Ovládání 44",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policeEditorControl73 = {
                    label = "Editor · Ovládání 73",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                policePrimaryColor = {
                    description = "Výchozí barva skupiny policejních povolání.",
                    label = "Hlavní barva",
                },
                propPlacementConsumeItem = {
                    description = "Odebrat jeden předmět z inventáře při umístění rekvizity.",
                    label = "Spotřebovat předmět rekvizity",
                },
                propPlacementEnabled = {
                    description = "Umožnit umístění nakonfigurovaných policejních rekvizit z předmětů nebo vozidel.",
                    label = "Umístění rekvizit",
                },
                propPlacementItemNames = {
                    description = "Mapování modelů rekvizit na názvy předmětů v inventáři pro umísťování na základě předmětů.",
                    label = "Názvy předmětů rekvizit",
                },
                propPlacementRequireOnDuty = {
                    description = "Rekvizity mohou umísťovat pouze policisté ve službě.",
                    label = "Rekvizity vyžadují službu",
                },
                propPlacementReturnItem = {
                    description = "Vrátit spotřebovaný předmět zpět při odstranění umístěné rekvizity.",
                    label = "Vrátit předmět rekvizity",
                },
                propPlacementVehicleAccess = {
                    description = "Umožnit pracovním vozidlům zpřístupnit jejich nakonfigurovanou výbavu rekvizit.",
                    label = "Přístup k rekvizitám vozidla",
                },
                radialEnabled = {
                    description = "Povolit radiální akce policie.",
                    label = "Policejní radiální nabídka",
                },
                radialHandcuffKeybindCommand = {
                    description = "Název příkazu zaregistrovaného pro klávesu spoutání.",
                    label = "Příkaz pro spoutání",
                },
                radialHandcuffKeybindDescription = {
                    description = "Popis zobrazený u klávesové zkratky spoutání.",
                    label = "Popis spoutání",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Povolit přímou klávesovou zkratku pro spoutání.",
                    label = "Klávesa pro spoutání",
                },
                radialHandcuffKeybindKey = {
                    description = "Klávesa na klávesnici použitá pro přímou akci spoutání.",
                    label = "Klávesa spoutání",
                },
                radialKeybindsEnabled = {
                    description = "Povolit přímé klávesové zkratky pro vybrané radiální akce.",
                    label = "Přímé klávesové zkratky",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Název příkazu zaregistrovaného pro klávesu sejmutí pout.",
                    label = "Příkaz pro sejmutí pout",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Popis zobrazený u klávesové zkratky sejmutí pout.",
                    label = "Popis sejmutí pout",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Povolit přímou klávesovou zkratku pro sejmutí pout.",
                    label = "Klávesa pro sejmutí pout",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Klávesa na klávesnici použitá pro přímou akci sejmutí pout.",
                    label = "Klávesa sejmutí pout",
                },
                socialWorkAssignRange = {
                    description = "Maximální vzdálenost pro přiřazení úkolů veřejně prospěšných prací.",
                    label = "Dosah přiřazení",
                },
                socialWorkDeadlineDefault = {
                    description = "Výchozí lhůta veřejně prospěšných prací v minutách. Nula lhůty vypíná.",
                    label = "Výchozí lhůta",
                },
                socialWorkDeadlineMax = {
                    description = "Maximální lhůta veřejně prospěšných prací v minutách. Nula vypíná horní limit.",
                    label = "Maximální lhůta",
                },
                socialWorkDeadlineMin = {
                    description = "Minimální lhůta veřejně prospěšných prací v minutách.",
                    label = "Minimální lhůta",
                },
                socialWorkDefaultTasks = {
                    description = "Výchozí počet úkolů při otevření přiřazení veřejně prospěšných prací.",
                    label = "Výchozí počet úkolů",
                },
                socialWorkEnabled = {
                    description = "Povolit přiřazování a plnění úkolů veřejně prospěšných prací.",
                    label = "Veřejně prospěšné práce",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID vězení použité, pokud porušení veřejně prospěšných prací vede k uvěznění.",
                    label = "Záložní ID vězení",
                },
                socialWorkImprisonmentMonths = {
                    description = "Počet měsíců přiřazených, pokud porušení veřejně prospěšných prací vede do vězení.",
                    label = "Měsíce uvěznění",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Jméno policisty použité pro záznamy o uvěznění z veřejně prospěšných prací.",
                    label = "Jméno policisty pro uvěznění",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Poslat porušitele na samotku, pokud dojde k uvěznění.",
                    label = "Použít samotku",
                },
                socialWorkInactivityMinutes = {
                    description = "Počet minut, po kterých se uplatní postihy za nečinnost při veřejně prospěšných pracích.",
                    label = "Minuty nečinnosti",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Postih v podobě úkolů uplatněný, pokud je hráč u veřejně prospěšných prací příliš dlouho neaktivní.",
                    label = "Postih za nečinnost",
                },
                socialWorkMaxTasks = {
                    description = "Maximální volitelný počet úkolů veřejně prospěšných prací.",
                    label = "Maximální počet úkolů",
                },
                socialWorkMinTasks = {
                    description = "Minimální volitelný počet úkolů veřejně prospěšných prací.",
                    label = "Minimální počet úkolů",
                },
                speedCamBillingEnabled = {
                    description = "Vystavit automatický účet, když rychlostní kamera zachytí odpovídající přestupek. Vyžaduje povolenou globální funkci Fakturace.",
                    label = "Automatické pokuty",
                },
                speedCamBillingExcludedJobs = {
                    description = "Zaměstnání, která nikdy neobdrží automatické účty z rychlostních kamer.",
                    itemLabel = "Zaměstnání",
                    label = "Vyloučená zaměstnání",
                },
                speedCamBillingExcludedModels = {
                    description = "Názvy modelů vozidel, které nikdy neobdrží automatické účty z rychlostních kamer.",
                    itemLabel = "Vzor",
                    label = "Vyloučené modely vozidel",
                },
                speedCamBillingRules = {
                    description = "Pravidla pokut použitá rychlostními kamerami. Nejprve se účtuje nejužší odpovídající rozsah překročení; pokud žádné pravidlo neodpovídá, jako záloha se použije přestupek SpeedViolation.",
                    label = "Pravidla pokut",
                },
                speedCamCameraEaseMs = {
                    description = "Jak dlouho trvá přechod pohledu do úhlu rychlostní kamery. Nižší hodnota = kratší pohyb; příliš nízká hodnota může způsobit nesouosost fotografie.",
                    label = "Přechod kamery (ms)",
                },
                speedCamCameraFov = {
                    description = "Zorné pole použité pro záběry rychlostní kamery.",
                    label = "Zorné pole kamery",
                },
                speedCamCheckIntervalMs = {
                    description = "Počet milisekund mezi skenováním rychlostní kamery.",
                    label = "Interval kontroly",
                },
                speedCamCooldownMs = {
                    description = "Počet milisekund, než může stejná rychlostní kamera znovu spustit záznam.",
                    label = "Prodleva spuštění",
                },
                speedCamDamageCooldownMs = {
                    description = "Počet milisekund, než může rychlostní kamera znovu utrpět poškození.",
                    label = "Prodleva poškození",
                },
                speedCamDamagePerHit = {
                    description = "Poškození odolnosti způsobené rychlostní kameře za jeden zásah.",
                    label = "Poškození za zásah",
                },
                speedCamDamagedModelThreshold = {
                    description = "Procento maximální odolnosti, při kterém nebo pod kterým se zobrazí poškozený model. Příklad: 50 při maximální odolnosti 200 přepne model při odolnosti 100.",
                    label = "Práh poškozeného modelu (%)",
                },
                speedCamDefaultLimit = {
                    description = "Výchozí limit rychlostní kamery.",
                    label = "Výchozí rychlostní limit",
                },
                speedCamDefaultName = {
                    description = "Navrhovaný zobrazovaný název při umístění radaru. Název lze přeložit bez změny předmětu v inventáři nebo modelu objektu.",
                    label = "Výchozí název",
                },
                speedCamDefaultTolerance = {
                    description = "Výchozí tolerance rychlostní kamery.",
                    label = "Výchozí tolerance",
                },
                speedCamDisassembleDistance = {
                    description = "Vzdálenost použitá k demontáži rychlostních kamer.",
                    label = "Vzdálenost demontáže",
                },
                speedCamEnabled = {
                    description = "Povolit přenosné rychlostní kamery.",
                    label = "Rychlostní kamery",
                },
                speedCamFlashColor = {
                    description = "Barva RGBA záblesku použitá rychlostními kamerami.",
                    label = "Barva záblesku",
                },
                speedCamFlashDurationMs = {
                    description = "Doba odeznění červeného záblesku rychlostní kamery. Nenastavujte příliš nízko, jinak bude viditelný pohyb kamery.",
                    label = "Doba záblesku (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Vzdálenost, při které se zobrazuje stav odolnosti rychlostní kamery.",
                    label = "Vzdálenost zobrazení stavu",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Počet milisekund, po které zůstává viditelný stav odolnosti rychlostní kamery.",
                    label = "Doba zobrazení stavu",
                },
                speedCamHealthTextOffset = {
                    description = "Svislé odsazení použité pro text stavu odolnosti rychlostní kamery.",
                    label = "Odsazení textu stavu",
                },
                speedCamItem = {
                    description = "Přesný interní název předmětu v inventáři, např. speedcam. Zadejte klíč předmětu, nikoli zobrazovaný název; obchod práce musí vydávat stejný předmět.",
                    label = "Název předmětu radaru",
                },
                speedCamMaintenanceThreshold = {
                    description = "Práh odolnosti, při kterém se doporučuje údržba rychlostní kamery.",
                    label = "Práh údržby",
                },
                speedCamMaxDurability = {
                    description = "Maximální odolnost nasazených rychlostních kamer.",
                    label = "Maximální odolnost",
                },
                speedCamMaxLimit = {
                    description = "Maximální nastavitelný limit rychlostní kamery.",
                    label = "Maximální rychlostní limit",
                },
                speedCamMaxTolerance = {
                    description = "Maximální nastavitelná tolerance rychlostní kamery.",
                    label = "Maximální tolerance",
                },
                speedCamPhotoLocale = {
                    description = "Volitelné jazykové nastavení použité pro časové razítko na fotografiích rychlostní kamery. Ponechte prázdné pro použití místního nastavení vyfoceného hráče.",
                    label = "Jazykové nastavení fotografie",
                },
                speedCamPhotoTimeZone = {
                    description = "Volitelné časové pásmo použité pro časové razítko na fotografiích rychlostní kamery. Ponechte prázdné pro použití místního časového pásma vyfoceného hráče.",
                    label = "Časové pásmo fotografie",
                },
                speedCamPoliceNotification = {
                    description = "Odeslat hlášení dispečinku, když rychlostní kamera zachytí přestupek.",
                    label = "Policejní hlášení rychlostní kamery",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Považovat cíl hlášení rychlostní kamery za skupinu práce.",
                    label = "Cíl hlášení je skupina",
                },
                speedCamPoliceNotificationJob = {
                    description = "Klíč práce nebo skupiny použitý pro hlášení dispečinku rychlostní kamery.",
                    label = "Cíl hlášení",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Upozornit pouze cíle hlášení rychlostní kamery, kteří jsou ve službě.",
                    label = "Hlášení vyžaduje službu",
                },
                speedCamPoliceNotificationType = {
                    description = "Závažnost/typ hlášení použitý pro varování rychlostní kamery.",
                    label = "Typ hlášení",
                },
                speedCamPropModel = {
                    description = "Název pro vytvoření nepoškozeného modelu radaru, např. sky_speedcam. Předvolba nastaví také poškozený a zničený model. Vlastní modely musí být ve hře dostupné.",
                    label = "Model rekvizity rychlostní kamery",
                    custom = "Vlastní model",
                    choose = "Vybrat model",
                    preview = "3D náhled",
                    customPlaceholder = "Spawn název objektu",
                    previewDescription = "Zobrazí vybraný objekt ve hře. Náhled neukládá změny.",
                    invalidModel = "Nejdříve zadejte platný název objektu.",
                    modelMissing = "Tento model není ve hře dostupný.",
                    previewFailed = "Náhled modelu se nepodařilo otevřít.",
                    intact = "Nepoškozený model",
                    previewRequiresGame = "Otevřete /jobconfig ve FiveM pro živý náhled objektu.",
                    previewHelp = "Šipky: pohyb; PageUp/PageDown: výška; kolečko: otáčení; Enter: zavřít; Backspace: zrušit.",
                    options = {
                        sky_speedcam = "Standardní radar",
                        sky_germ_speedcam = "Německý radar",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Název pro vytvoření poškozeného modelu radaru, např. sky_speedcam2. Použijte variantu odpovídající nepoškozenému modelu.",
                    label = "Model poškozené rekvizity",
                },
                speedCamPropModelDestroyed = {
                    description = "Název modelu zobrazeného při odolnosti radaru 0, např. sky_speedcam1. Použijte variantu odpovídající nepoškozenému modelu.",
                    label = "Model zničené rekvizity",
                },
                speedCamRepairAnimDict = {
                    description = "Slovník animací použitý při opravě rychlostních kamer.",
                    label = "Slovník animací opravy",
                },
                speedCamRepairAnimFlag = {
                    description = "Příznak animace použitý při opravě rychlostních kamer.",
                    label = "Příznak animace opravy",
                },
                speedCamRepairAnimName = {
                    description = "Název animace použité při opravě rychlostních kamer.",
                    label = "Název animace opravy",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Počet milisekund, než lze opravu rychlostní kamery zrušit.",
                    label = "Prodleva zrušení opravy",
                },
                speedCamRepairDistance = {
                    description = "Vzdálenost použitá k opravě rychlostních kamer.",
                    label = "Vzdálenost opravy",
                },
                speedCamRepairItem = {
                    description = "Přesný interní název předmětu pro opravu, např. fixtool. Zadejte klíč předmětu, nikoli zobrazovaný název.",
                    label = "Název předmětu pro opravu",
                },
                speedCamRepairPerTick = {
                    description = "Odolnost obnovená za každý krok opravy rychlostní kamery.",
                    label = "Oprava za krok",
                },
                speedCamRepairTickMs = {
                    description = "Počet milisekund mezi jednotlivými kroky opravy rychlostní kamery.",
                    label = "Interval opravy",
                },
                speedCamStreamDistance = {
                    description = "Vzdálenost od hráče v metrech, ve které se načítají objekty radarů. Mimo tuto vzdálenost se objekty uvolní; uložené radary zůstávají umístěné.",
                    label = "Vzdálenost načítání",
                },
                speedCamTriggerRadius = {
                    description = "Poloměr detekce rychle jedoucích vozidel kolem radaru v metrech.",
                    label = "Spouštěcí poloměr",
                },
                speedCamUseMph = {
                    description = "Zobrazovat a zpracovávat limity rychlostní kamery v MPH.",
                    label = "Použít MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Zbraně, kterými lze poškodit rychlostní kamery, dokud je omezení povoleno.",
                    itemLabel = "Zbraň",
                    label = "Povolené zbraně",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Pokud je povoleno, poškodit rychlostní kamery mohou pouze uvedené zbraně.",
                    label = "Omezení povoleno",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Vzdálenost v metrech před zrušením varování o rychlostní kameře.",
                    label = "Vzdálenost zrušení",
                },
                speedCameraAppDefaultApp = {
                    description = "Zobrazit aplikaci rychlostní kamery jako výchozí aplikaci tabletu.",
                    label = "Výchozí aplikace",
                },
                speedCameraAppDescription = {
                    description = "Popis zobrazený u aplikace rychlostní kamery v tabletu.",
                    label = "Popis",
                },
                speedCameraAppDeveloper = {
                    description = "Popisek vývojáře zobrazený u aplikace rychlostní kamery v tabletu.",
                    label = "Vývojář",
                },
                speedCameraAppEnabled = {
                    description = "Povolit aplikaci rychlostní kamery v policejním tabletu.",
                    label = "Aplikace rychlostní kamery v tabletu",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Podnadpis záhlaví zobrazený v aplikaci rychlostní kamery.",
                    label = "Podnadpis záhlaví",
                },
                speedCameraAppHeaderTitle = {
                    description = "Titulek záhlaví zobrazený v aplikaci rychlostní kamery.",
                    label = "Titulek záhlaví",
                },
                speedCameraAppIcon = {
                    description = "Cesta k ikoně použitá pro aplikaci rychlostní kamery v tabletu.",
                    label = "Cesta k ikoně",
                },
                speedCameraAppIdentifier = {
                    description = "Interní identifikátor aplikace rychlostní kamery v tabletu.",
                    label = "Identifikátor",
                },
                speedCameraAppInFrontDot = {
                    description = "Práh skalárního součinu použitý k určení, zda je rychlostní kamera před hráčem.",
                    label = "Práh skalárního součinu vpředu",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Minimální rychlost vozidla v km/h, od které se zobrazují varování.",
                    label = "Minimální rychlost vozidla",
                },
                speedCameraAppName = {
                    description = "Zobrazovaný název aplikace rychlostní kamery v tabletu.",
                    label = "Název aplikace",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Vzdálenost v metrech před upozorněním na blízkou rychlostní kameru.",
                    label = "Vzdálenost upozornění",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Varovat před rychlostními kamerami pouze tehdy, když je hráč ve vozidle.",
                    label = "Pouze ve vozidle",
                },
                speedCameraAppOverlayBackground = {
                    description = "Barva pozadí použitá pro překryv obrázku SPZ.",
                    label = "Pozadí překryvu",
                },
                speedCameraAppOverlayBorder = {
                    description = "Barva okraje použitá pro překryv obrázku SPZ.",
                    label = "Okraj překryvu",
                },
                speedCameraAppOverlayColor = {
                    description = "Barva textu použitá pro překryv obrázku SPZ.",
                    label = "Barva překryvu",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Povolit překryv obrázku SPZ na zachycených snímcích rychlostní kamery.",
                    label = "Překryv povolen",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Měřítko písma použité pro překryv obrázku SPZ.",
                    label = "Měřítko písma překryvu",
                },
                speedCameraAppOverlayX = {
                    description = "Normalizovaná pozice X překryvu zleva doprava.",
                    label = "Překryv X",
                },
                speedCameraAppOverlayY = {
                    description = "Normalizovaná pozice Y překryvu shora dolů.",
                    label = "Překryv Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Varovat pouze před rychlostními kamerami, které jsou před hráčem.",
                    label = "Vyžadovat vpředu",
                },
                speedCameraAppRoute = {
                    description = "Cesta routeru otevíraná aplikací rychlostní kamery v tabletu.",
                    label = "Trasa",
                },
                speedCameraAppSize = {
                    description = "Nahlašovaná velikost úložiště aplikace rychlostní kamery v tabletu.",
                    label = "Velikost aplikace",
                },
                speedCameraAppSoundCoord = {
                    description = "Přehrávat varovné zvuky rychlostní kamery na herních souřadnicích.",
                    label = "Zvuk na souřadnicích",
                },
                speedCameraAppSoundEnabled = {
                    description = "Povolit varovné zvuky pro aplikaci rychlostní kamery.",
                    label = "Zvuk povolen",
                },
                speedCameraAppSoundFrontend = {
                    description = "Přehrávat varovné zvuky rychlostní kamery na zvukovém kanálu frontendu.",
                    label = "Zvuk frontendu",
                },
                speedCameraAppSoundLayers = {
                    description = "Počet vrstvených varovných zvuků přehrávaných aplikací rychlostní kamery.",
                    label = "Vrstvy zvuku",
                },
                speedCameraAppSoundName = {
                    description = "Název zvuku použitý pro varování aplikace rychlostní kamery.",
                    label = "Název zvuku",
                },
                speedCameraAppSoundRange = {
                    description = "Dosah použitý pro varovné zvuky aplikace rychlostní kamery.",
                    label = "Dosah zvuku",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Počet opakování varovného zvuku rychlostní kamery.",
                    label = "Počet opakování",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Počet milisekund mezi opakováními varovného zvuku rychlostní kamery.",
                    label = "Prodleva opakování",
                },
                speedCameraAppSoundSet = {
                    description = "Sada zvuků použitá pro varování aplikace rychlostní kamery.",
                    label = "Sada zvuků",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Účet použitý pro platby předplatného aplikace rychlostní kamery v tabletu.",
                    label = "Účet",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Povolit placené předplatné pro aplikaci rychlostní kamery v tabletu.",
                    label = "Předplatné povoleno",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Počet dní mezi obnovením předplatného aplikace rychlostní kamery v tabletu.",
                    label = "Interval ve dnech",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Cena účtovaná za předplatné aplikace rychlostní kamery v tabletu.",
                    label = "Cena předplatného",
                },
                speedCameraAppThemeAccent = {
                    description = "Akcentová barva použitá aplikací rychlostní kamery.",
                    label = "Akcent",
                },
                speedCameraAppThemeBackground = {
                    description = "Lineární přechodové pozadí použité aplikací rychlostní kamery.",
                    label = "Pozadí",
                },
                speedCameraAppThemeBorder = {
                    description = "Barva okraje použitá aplikací rychlostní kamery.",
                    label = "Okraj",
                },
                speedCameraAppThemeButtonText = {
                    description = "Barva textu tlačítka použitá aplikací rychlostní kamery.",
                    label = "Text tlačítka",
                },
                speedCameraAppThemeDanger = {
                    description = "Barva nebezpečí použitá aplikací rychlostní kamery.",
                    label = "Nebezpečí",
                },
                speedCameraAppThemeGhost = {
                    description = "Barva průhledného tlačítka použitá aplikací rychlostní kamery.",
                    label = "Průhledné tlačítko",
                },
                speedCameraAppThemeGhostText = {
                    description = "Barva textu průhledného tlačítka použitá aplikací rychlostní kamery.",
                    label = "Text průhledného tlačítka",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Barva jemného přechodu použitá aplikací rychlostní kamery.",
                    label = "Jemný přechod",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Barva neaktivního okraje použitá aplikací rychlostní kamery.",
                    label = "Neaktivní okraj",
                },
                speedCameraAppThemeModal = {
                    description = "Barva pozadí modálního okna použitá aplikací rychlostní kamery.",
                    label = "Modální okno",
                },
                speedCameraAppThemeMutedText = {
                    description = "Barva ztlumeného textu použitá aplikací rychlostní kamery.",
                    label = "Ztlumený text",
                },
                speedCameraAppThemeOverlay = {
                    description = "Barva překryvu použitá aplikací rychlostní kamery.",
                    label = "Překryv",
                },
                speedCameraAppThemePillText = {
                    description = "Barva textu štítku (pill) použitá aplikací rychlostní kamery.",
                    label = "Text štítku",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Počáteční barva hlavního přechodu použitá aplikací rychlostní kamery.",
                    label = "Hlavní přechod od",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Koncová barva hlavního přechodu použitá aplikací rychlostní kamery.",
                    label = "Hlavní přechod do",
                },
                speedCameraAppThemeShadow = {
                    description = "Barva stínu použitá aplikací rychlostní kamery.",
                    label = "Stín",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Barva zvýraznění (spotlight) použitá aplikací rychlostní kamery.",
                    label = "Zvýraznění",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Barva jemného textu použitá aplikací rychlostní kamery.",
                    label = "Jemný text",
                },
                speedCameraAppThemeSuccess = {
                    description = "Barva úspěchu použitá aplikací rychlostní kamery.",
                    label = "Úspěch",
                },
                speedCameraAppThemeSurface = {
                    description = "Barva povrchu použitá aplikací rychlostní kamery.",
                    label = "Povrch",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Barva jemného povrchu použitá aplikací rychlostní kamery.",
                    label = "Jemný povrch",
                },
                speedCameraAppThemeText = {
                    description = "Hlavní barva textu použitá aplikací rychlostní kamery.",
                    label = "Text",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Akcentová barva RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Akcent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Barva RGBA použitá pro pozadí varovného rozhraní rychlostní kamery.",
                    label = "Pozadí RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Barva ikony RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Ikona RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Barva textu ikony RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Text ikony RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Počet sekund, po které zůstává varovné rozhraní viditelné.",
                    label = "Sekundy zobrazení varování",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Barva podtextu RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Podtext RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Barva textu RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Text RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Barva titulku RGBA použitá pro varovné rozhraní rychlostní kamery.",
                    label = "Titulek RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Počet milisekund mezi kontrolami blízkosti hřebíkového pásu.",
                    label = "Interval kontroly",
                },
                spikeStripsEnabled = {
                    description = "Povolit nasazené hřebíkové pásy.",
                    label = "Hřebíkové pásy",
                },
                spikeStripsModels = {
                    description = "Modely rekvizit považované za aktivní hřebíkové pásy.",
                    itemLabel = "Vzor",
                    label = "Modely",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Počet milisekund před opakováním skenování hřebíkového pásu po neúspěšném pokusu.",
                    label = "Interval opakování",
                },
                spikeStripsScanDistance = {
                    description = "Vzdálenost použitá ke skenování blízkých hřebíkových pásů.",
                    label = "Vzdálenost skenování",
                },
                spikeStripsTriggerDistance = {
                    description = "Vzdálenost, při které hřebíkový pás propíchne pneumatiky.",
                    label = "Spouštěcí vzdálenost",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Popisek kategorie použitý pro ikony stanic v tvůrci.",
                    label = "Kategorie ikony stanice",
                },
                stationCreatorBlipColor = {
                    description = "Barva mapové ikony použitá pro policejní stanice.",
                    label = "Barva ikony stanice",
                },
                stationCreatorBlipScale = {
                    description = "Měřítko použité pro ikony policejních stanic.",
                    label = "Velikost ikony stanice",
                },
                stationCreatorBlipShortRange = {
                    description = "Zobrazit ikony stanic pouze na krátkou vzdálenost.",
                    label = "Krátký dosah ikony stanice",
                },
                stationCreatorBlipSprite = {
                    description = "Vzhled ikony (sprite) na mapě použitý pro policejní stanice.",
                    label = "Vzhled ikony stanice",
                },
                stationCreatorBlipUseStationName = {
                    description = "Použít nakonfigurovaný název stanice jako popisek mapové ikony.",
                    label = "Použít název stanice",
                },
                tabletAutoFillCitizens = {
                    description = "Předvyplnit evidenci občanů z databáze rámce.",
                    label = "Automatické vyplnění občanů",
                },
                tabletAutoFillVehicles = {
                    description = "Předvyplnit evidenci vozidel z databáze rámce.",
                    label = "Automatické vyplnění vozidel",
                },
                tabletBolos = {
                    description = "Zobrazit aplikaci pátrání.",
                    label = "Pátrání (BOLO)",
                },
                tabletCases = {
                    description = "Zobrazit aplikaci případů.",
                    label = "Případy",
                },
                tabletCitizens = {
                    description = "Zobrazit aplikaci evidence občanů.",
                    label = "Občané",
                },
                tabletConfiscations = {
                    description = "Zobrazit záznamy předmětů zabavených při osobních prohlídkách.",
                    label = "Zabavené předměty",
                },
                tabletOffences = {
                    description = "Zobrazit aplikaci přestupků.",
                    label = "Přestupky",
                },
                tabletPrison = {
                    description = "Zobrazit aplikaci vězení.",
                    label = "Vězení",
                },
                tabletReportEnforcement = {
                    description = "Povolit přiřazení přestupků a udělení pokut nebo trestů z uložených hlášení.",
                    label = "Vymáhání z hlášení",
                },
                tabletReports = {
                    description = "Zobrazit aplikaci hlášení.",
                    label = "Hlášení",
                },
                tabletSocialWork = {
                    description = "Zobrazit aplikaci veřejně prospěšných prací.",
                    label = "Veřejně prospěšné práce",
                },
                tabletVehicles = {
                    description = "Zobrazit aplikaci evidence vozidel.",
                    label = "Vozidla",
                },
                tabletWarrants = {
                    description = "Zobrazit aplikaci zatykačů.",
                    label = "Zatykače",
                },
                tabletWeapons = {
                    description = "Zobrazit aplikaci evidence zbraní.",
                    label = "Zbraně",
                },
                tackleCuffKey = {
                    label = "Spoutat sraženou osobu",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                tackleKey = {
                    label = "Sražení",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                tackleReleaseKey = {
                    label = "Pustit sraženou osobu",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Počet milisekund, než lze vyvolat další upozornění radaru.",
                    label = "Prodleva upozornění",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Třídy vozidel, které smí používat radar.",
                    label = "Povolené třídy vozidel",
                },
                vehicleRadarAutoFastLock = {
                    description = "Automaticky označit velmi rychlé cíle v radaru.",
                    label = "Automatické rychlé zaměření",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Rychlostní práh použitý pro automatické rychlé zaměření.",
                    label = "Práh rychlého zaměření",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Mapování klávesy použité ke snížení rychlostního limitu radaru.",
                    label = "Klávesa snížení limitu",
                },
                vehicleRadarDefaultLimit = {
                    description = "Výchozí rychlostní limit použitý palubním radarem.",
                    label = "Výchozí limit radaru",
                },
                vehicleRadarEnabled = {
                    description = "Povolit palubní radar hlídkového vozidla.",
                    label = "Palubní radar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Mapování klávesy použité ke zvýšení rychlostního limitu radaru.",
                    label = "Klávesa zvýšení limitu",
                },
                vehicleRadarLimitStep = {
                    description = "Hodnota změny při jedné úpravě limitu radaru.",
                    label = "Krok limitu",
                },
                vehicleRadarLockFrontKey = {
                    description = "Mapování klávesy použité k zaměření předního cíle radaru.",
                    label = "Klávesa předního zaměření",
                },
                vehicleRadarLockRearKey = {
                    description = "Mapování klávesy použité k zaměření zadního cíle radaru.",
                    label = "Klávesa zadního zaměření",
                },
                vehicleRadarMaxLimit = {
                    description = "Maximální rychlostní limit povolený v palubním radaru.",
                    label = "Maximální limit radaru",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Maximální sklon povolený pro zaměřování radarem.",
                    label = "Maximální stupně sklonu",
                },
                vehicleRadarMinLimit = {
                    description = "Minimální rychlostní limit povolený v palubním radaru.",
                    label = "Minimální limit radaru",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Minimální rychlost, od které radar považuje cíl za platný.",
                    label = "Minimální rychlost cíle",
                },
                vehicleRadarModeFrontKey = {
                    description = "Mapování klávesy použité k přepnutí předního režimu radaru.",
                    label = "Klávesa předního režimu",
                },
                vehicleRadarModeRearKey = {
                    description = "Mapování klávesy použité k přepnutí zadního režimu radaru.",
                    label = "Klávesa zadního režimu",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Počet milisekund mezi skenováním radaru, když se hlídkové vozidlo pohybuje.",
                    label = "Interval skenování za jízdy",
                },
                vehicleRadarPassengerControl = {
                    description = "Umožnit spolujezdcům ovládat palubní radar.",
                    label = "Ovládání spolujezdcem",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Umožnit spolujezdcům zobrazit zrcadlená data radaru.",
                    label = "Zrcadlení pro spolujezdce",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Počet milisekund mezi aktualizacemi synchronizace radaru pro spolujezdce.",
                    label = "Interval synchronizace pro spolujezdce",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Práh projekce použitý při vyhodnocování cílů radaru.",
                    label = "Práh projekce",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Vyžadovat volnou přímou viditelnost před uzamčením cíle radarem.",
                    label = "Vyžadovat přímou viditelnost",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Vyžadovat stav služby před použitím palubního radaru.",
                    label = "Radar vyžaduje službu",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Počet milisekund mezi skenováním radaru ve stacionárním režimu.",
                    label = "Interval skenování",
                },
                vehicleRadarScanRadius = {
                    description = "Poloměr skenování palubního radaru.",
                    label = "Poloměr skenování",
                },
                vehicleRadarToggleKey = {
                    description = "Mapování klávesy použité k zapnutí/vypnutí palubního radaru.",
                    label = "Klávesa přepnutí",
                },
                vehicleRadarUseMph = {
                    description = "Zobrazovat hodnoty rychlosti radaru v MPH.",
                    label = "Radar používá MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Počet milisekund mezi obnovením fronty blízkých vozidel.",
                    label = "Obnovení fronty vozidel",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Mapování klávesy použité pro přední XMIT/HOLD radaru.",
                    label = "Klávesa předního XMIT",
                },
                vehicleRadarXmitRearKey = {
                    description = "Mapování klávesy použité pro zadní XMIT/HOLD radaru.",
                    label = "Klávesa zadního XMIT",
                },
                wheelClampConsumeItem = {
                    description = "Odebrat předmět botičky po nasazení.",
                    label = "Spotřebovat předmět botičky",
                },
                wheelClampEnabled = {
                    description = "Povolit akci nasazení botičky.",
                    label = "Botička na kolo",
                },
                wheelClampItem = {
                    description = "Předmět z inventáře použitý pro nasazení botičky.",
                    label = "Předmět botičky",
                },
                wheelClampPropModel = {
                    description = "Model rekvizity použitý pro umístěnou botičku.",
                    label = "Model botičky",
                },
                wheelClampRequireItem = {
                    description = "Vyžadovat nakonfigurovaný předmět botičky. Ponechte povoleno, pokud je režim použití botičky nastaven na Inventář nebo Obojí.",
                    label = "Botička vyžaduje předmět",
                },
                wheelClampRequireOnDuty = {
                    description = "Vyžadovat stav služby před nasazením botičky.",
                    label = "Botička vyžaduje službu",
                },
                wheelClampTyreDistance = {
                    description = "Maximální vzdálenost k pneumatice při nasazování nebo odřezávání botičky.",
                    label = "Vzdálenost od pneumatiky",
                },
                wheelClampUseItem = {
                    description = "Použít radiální nabídku, inventář nebo obojí pro nasazení botičky. Inventář nebo Obojí by mělo být spárováno s nastavením Botička vyžaduje předmět.",
                    label = "Režim použití botičky",
                    options = {
                        both = "Obojí",
                        inventory = "Inventář",
                        radial = "Radiální nabídka",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Maximální vzdálenost k cílovému vozidlu při nasazování botičky.",
                    label = "Vzdálenost od vozidla",
                },
                wheelClampWeldBurstTyre = {
                    description = "Prasknout pneumatiku po odřezání botičky.",
                    label = "Prasknutí pneumatiky",
                },
                wheelClampWeldDurationMs = {
                    description = "Počet milisekund potřebných k odstranění botičky odřezáním.",
                    label = "Doba odřezávání",
                },
                wheelClampWeldEnabled = {
                    description = "Umožnit odstranění botičky pomocí řezacího hořáku.",
                    label = "Odřezávání botičky",
                },
                wheelClampWeldItem = {
                    description = "Předmět z inventáře vyžadovaný pro odřezání botičky.",
                    label = "Předmět řezacího hořáku",
                },
                wheelClampWeldMinigame = {
                    description = "Vyžadovat minihru odřezávání botičky před dokončením odstranění.",
                    label = "Minihra při odřezávání",
                },
                ziptiesConsumeItem = {
                    description = "Odebrat předmět stahovací pásky při nasazení.",
                    label = "Spotřebovat stahovací pásky",
                },
                ziptiesCutterConsumeItem = {
                    description = "Odebrat předmět nůžek po přestřižení stahovacích pásek.",
                    label = "Spotřebovat předmět nůžek",
                },
                ziptiesCutterEnabled = {
                    description = "Umožnit odstranění stahovacích pásek pomocí kleští na dráty.",
                    label = "Nůžky na stahovací pásky",
                },
                ziptiesCutterItem = {
                    description = "Předmět z inventáře použitý k přestřižení stahovacích pásek.",
                    label = "Předmět nůžek",
                },
                ziptiesEnabled = {
                    description = "Povolit akce se stahovacími páskami.",
                    label = "Stahovací pásky",
                },
                ziptiesItem = {
                    description = "Předmět z inventáře použitý pro akce se stahovacími páskami.",
                    label = "Předmět stahovací pásky",
                },
                ziptiesRequireHandsUp = {
                    description = "Vyžadovat stav ruce nahoru před nasazením stahovací pásky.",
                    label = "Stahovací pásky vyžadují ruce nahoru",
                },
                ziptiesRequireItem = {
                    description = "Vyžadovat nakonfigurovaný předmět stahovací pásky.",
                    label = "Stahovací pásky vyžadují předmět",
                },
                ziptiesReturnOnRemove = {
                    description = "Vrátit předmět stahovací pásky při jejím sejmutí.",
                    label = "Vrátit stahovací pásky",
                },
                evidenceGsrDurationSeconds = {
                    description = "Zbytky střelného prachu zůstávají na rukou hráče.",
                    label = "Doba trvání GSR",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Zabránit GSR být aplikován, když střelec nosí rukavice.",
                    label = "Rukavice chrání ruce",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Zbraně, které nepoužívají zbytky střelného prachu.",
                    label = "Ignorované zbraně",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milisekundy mezi čištěním vody a deště, zatímco GSR je aktivní.",
                    label = "Interval kontroly mytí",
                },
                evidenceGsrWashInRain = {
                    description = "Nechte déšť odstranit zbytky střelného prachu.",
                    label = "Mytí v dešti",
                },
                evidenceGsrWashInWater = {
                    description = "Nechte vodu odstranit zbytky střelného prachu.",
                    label = "Mytí ve vodě",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam ukazuje falešný talíř.",
                    description = "Zobrazí falešnou desku v helikoptéře.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normální nástroje ukazují falešný talíř",
                    description = "Zobrazí falešný talíř ve standardních policejních nástrojích.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar ukazuje falešný štítek.",
                    description = "Zobrazí falešnou desku na palubním radaru.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Dovolte policejním systémům přečíst sdílenou falešnou desku.",
                    label = "Poznávám falešné značky.",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Klíč pro stavbag vozidla zveřejněný mechanikou.",
                    label = "Statebag klíč",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam ukazuje falešný talíř",
                    description = "Zobrazí falešnou desku v pevných radarových hlášeních.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Volitelné povolání/třídní povolení-seznam. Nechat prázdné, aby všechny stupně povolených povolání.",
                    label = "VIN stupňů",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN povolání",
                    description = "Profesionální profese mohou používat ověřování VIN.",
                },
                fakePlateVinAudit = {
                    label = "Audit VIN kontroly",
                    description = "Šetří VIN šeky do kontrolního protokolu.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN kontrola povolena",
                    description = "Povolí příkaz k ověření vozidla VIN.",
                },
                fakePlateVinCommand = {
                    label = "Příkaz VIN",
                    description = "Příkaz používaný k ověření vozidla VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN chlazení",
                    description = "Zpoždění mezi dvěma VIN kontrolami.",
                },
                fakePlateVinDistance = {
                    label = "VIN max. vzdálenost",
                    description = "Maximální vzdálenost mezi důstojníkem a vozidlem k ověření jeho VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Zobrazit falešný indikátor",
                    description = "Zobrazí ukazatel, když kontrola zjistí falešný štítek.",
                },
                fakePlateVinRequireDuty = {
                    label = "Vyžadovat povinnost",
                    description = "Vyžaduje, aby byl důstojník ve službě, aby ověřil VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Vyžadovat položku skeneru",
                    description = "Vyžaduje nakonfigurovaný objekt skeneru k ověření VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Položka skeneru",
                    description = "Inventurní položka požadovaná k ověření VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Pošlete vězně do vězení, aby byl nezaměstnaný.",
                    label = "Odstranit povolání ve vězení",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Obnovit původní profesi vězně po propuštění.",
                    label = "Obnovit původní povolání",
                },
                primaryColor = {
                    description = "Výchozí barva skupiny policejních povolání.",
                    label = "Základní barva",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Povolit recenzentům fakturovat registrovaného majitele, i když je zachycená deska označena jako falešná nebo klonovaná.",
                    label = "Povolit podezřelé falešné značky",
                },
                speedCamAdvancedPageSize = {
                    description = "Maximální zachycení vráceno na stránku tabletu.",
                    label = "Velikost recenze stránky",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Boky vozidla, jejichž fotografie mohou být použity pro rozpoznávání desek. Používejte přední a/nebo zadní.",
                    itemLabel = "Strana",
                    label = "Rozpoznané strany",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Umožnit schválení pouze po dokončení nahrávání fotek rychlostních kamer.",
                    label = "Vyžadovat fotodokumentaci",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu povolení potřebné ke schválení nebo odstranění zajetí. 18 je Správa fakturace.",
                    label = "Povolení k přezkumu ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Udržujte záznamy, jejichž poznávací značka není přítomna v registrované databázi vozidel.",
                    label = "Uložit neregistrovaná vozidla",
                },
                tabletSpeedcamReviews = {
                    description = "Pokud je zapnutý pokročilý režim, zobrazte pokročilou aplikaci recenze rychlostních kamer.",
                    label = "Recenze rychlostních kamer",
                },
                tackleCommand = {
                    description = "Příkaz registrovaný pro řešení nejbližší osoby. Zadejte název příkazu bez lomítka.",
                    label = "Tackle příkaz",
                },
                tackleCuffCommand = {
                    description = "Příkaz registrovaný pro spoutání osoby, která je v současné době držena po útoku. Zadejte název příkazu bez lomítka.",
                    label = "Příkaz manžetové manžety",
                },
                tackleCuffDescription = {
                    description = "Popis zobrazený pro manžetové pouta v nabídce klíčů FiveM.",
                    label = "Tackle manžeta keybind popis",
                },
                tackleDescription = {
                    description = "Popis zobrazený pro vazbu na kladkostroje v nabídce FiveM key links.",
                    label = "Tackle keybind popis",
                },
                tackleEnabled = {
                    description = "Aktivujte řešení nejbližší osoby a držte je na zemi.",
                    label = "Srazeni",
                },
                tackleMaxDistance = {
                    description = "Maximální vzdálenost k cíli při startu stíhačky.",
                    label = "Vzdálenost vleků",
                },
                tackleNeedsSprint = {
                    description = "Vyžadovat, aby policista sprintoval, než někoho zmlátí.",
                    label = "Tackle vyžaduje sprint",
                },
                tackleReleaseCommand = {
                    description = "Příkaz registrovaný pro propuštění osoby, která je v současné době držena po souboji. Zadejte název příkazu bez lomítka.",
                    label = "Příkaz k uvolnění Tackle",
                },
                tackleReleaseDescription = {
                    description = "Popis zobrazený pro vázání pro uvolnění hardwaru v nabídce FiveM key.",
                    label = "Tackle release keybind popis",
                },
                tackleRequireOnDuty = {
                    description = "Vyžadovat stát služby, než se důstojník dokáže vypořádat s člověkem.",
                    label = "Tackle vyžaduje povinnost.",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Příkaz používaný k otevření nebo uzavření editoru rozložení radaru. Zadejte název příkazu bez lomítka.",
                    label = "Příkaz uspořádání radaru",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Příkaz použitý k obnovení výchozího uspořádání radaru. Zadejte název příkazu bez lomítka.",
                    label = "Obnovit příkaz k uspořádání radaru",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Umožňuje zaměstnancům přihlásit se na dostupná školení.",
                approvalRequired = "Ponechává nevyřízené vlastní registrace, dokud je neschválí autorizovaný instruktor.",
                defaultCapacity = "Výchozí počet sedadel použitých při vytvoření nového tréninku.",
                enabled = "Zpřístupní aplikaci Training pro tuto úlohu.",
                requireOnDuty = "Vyžaduje, aby zaměstnanci měli službu před otevřením nebo použitím aplikace Training.",
                upcomingDays = "Počet budoucích dnů zobrazených v plánu aplikace Training.",
            },
            trainingFields = {
                allowSelfEnrollment = "Povolit samoregistraci",
                approvalRequired = "Vyžadovat schválení registrace",
                defaultCapacity = "Výchozí kapacita",
                enabled = "Povolit školení",
                requireOnDuty = "Vyžadovat povinnost",
                upcomingDays = "Nadcházející období (dny)",
            },
            locationDescriptions = {
                jail_public_blip = "Pozice se automaticky přebírá z bodu objevení vězňů, případně z prvního vězeňského terminálu.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Konzumní manžety nemají žádný účinek, zatímco požadavky na manžetové položky jsou zakázány.",
                wheelClampUseItemRequiresItem = "Režim použití svorek Inventář nebo obojí vyžaduje, aby položka zůstala zapnuta.",
                ziptiesConsumeRequiresItem = "Konzumní zipties nemá žádný vliv, zatímco ziptie požadavek položky je zakázán.",
            },
        },
    },
    JobConfiguratorImportFailed = "Nepodařilo se importovat hodnoty config.lua pro '%s': %s.",
    JobConfiguratorImportHistoryFailed = "Dovoz uspěl, ale jeho zápis do historie nemohl být uložen.",
    JobConfiguratorImportNoData = "\"%s\" neposkytuje data pro import config.lua.",
    JobConfiguratorImportSuccess = "Importované konfigur.lua hodnoty pro '%s': %d profese, %d nastavení, %d funkce, a %d interakce odchylky použity.",
    JobConfiguratorTitle = "Konfigurátor práce",
    JobConfiguratorUnknown = "Konfigurátor Neznámá profese.",
}
