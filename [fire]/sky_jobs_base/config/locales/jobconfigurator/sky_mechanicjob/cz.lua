JobConfigLocales["sky_mechanicjob:cz"] = {
    Nui = {
        workshopConfig = {
            settingFields = {
                radialEnabled = "Faktura v radiálním menu",
                allowTuningInvoices = "Fakturovat tuning zákazníkům",
                customerRange = "Vzdálenost zákazníka",
                allowAnalytics = "Účetní analýza",
                allowCancellation = "Zrušení",
                allowCustomPrices = "Povolit ceny na zakázku",
                allowEstimates = "Povolit odhady",
                allowImmediatePayment = "Povolit okamžitou platbu",
                allowManualItems = "Povolit vlastní pozice",
                allowPartialPayments = "Povolit částečné platby",
                allowReminders = "Upomínky",
                amount = "Množství",
                analyticsPeriodDays = "Období analýzy",
                bone = "Kost",
                category = "Kategorie",
                classId = "Třída ID",
                defaultDueDays = "Platební lhůta (dny)",
                depositPercent = "Vklad procenta",
                difficulty = "Obtížnost",
                enabled = "Aktivováno",
                estimateLifetimeHours = "Odhad doby životnosti (hodiny)",
                flow = "Instalovat tok",
                grade = "Stupeň",
                gradeRules = "Pravidla stupně",
                item = "Předmět",
                key = "Klíč",
                kilometersToZero = "Kilometry až nula",
                label = "Označení",
                laborFee = "Náklady práce",
                laborMultiplier = "Násobitel práce",
                marginAdjustmentPercent = "Úprava marže",
                marginPercent = "Rezerva %",
                maxDiscountPercent = "Maximální sleva",
                maximumInvoiceAmount = "Maximální faktura",
                maximumManualItems = "Maximální vlastní pozice",
                maximumPrice = "Maximální",
                maximumReminders = "Maximální upomínky",
                minimumInvoiceAmount = "Minimální faktura",
                minimumPartialPayment = "Minimální částečná platba",
                minimumPrice = "Min.",
                multiplier = "Násobitel",
                name = "Název položky",
                partKey = "Klíč části",
                price = "Cena",
                priceType = "Typ ceny",
                prop = "Objekt",
                reason = "Důvod",
                reminderFee = "Poplatek za upomínku",
                reminderGraceDays = "Upomínková lhůta",
                removeAfterUse = "Spotřebovat předmět",
                repair = "Opravy se soupravou",
                repairItem = "Předmět opravy",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Dodavatel %",
                taxPercent = "Daň z faktur",
                transport = "Doprava",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Vylepšení",
                maximumDiscountPercent = "Maximální sleva",
            },
            settingFieldDescriptions = {
                radialEnabled = "Otevřít fakturaci dílny z radiálního menu.",
                allowTuningInvoices = "Odeslat fakturu za tuningový košík nejbližšímu zákazníkovi. Montáž se zpřístupní po úplném zaplacení.",
                customerRange = "Maximální vzdálenost v metrech pro vystavení faktury zákazníkům v okolí.",
                allowAnalytics = "Povolit fakturaci analýzy, pokud to pravidlo stupně nepřepíše.",
                allowCustomPrices = "Umožnit mechanikům upravit ceny faktur.",
                allowEstimates = "Povolit odhady, které musí zákazníci přijmout před zaplacením.",
                allowImmediatePayment = "Povolit zaplacení faktur z této profese přímo.",
                allowManualItems = "Umožnit mechanikům vytvářet libovolné fakturační pozice.",
                allowPartialPayments = "Povolit vklady a více plateb na jednu fakturu.",
                analyticsPeriodDays = "Dny zahrnuté do fakturační analýzy.",
                defaultDueDays = "Dny, než faktura přijde pozdě.",
                depositPercent = "Požadované procento vkladu po vystavení faktury nebo je přijat odhad.",
                enabled = "Dovolte této profesi používat mechanický fakturace.",
                estimateLifetimeHours = "Hodiny před tím, než vyprší nezodpovězený odhad.",
                gradeRules = "Limity faktur a akce dostupné pro každou mechanickou třídu.",
                maxDiscountPercent = "Největší slevu může obdržet faktura.",
                maximumInvoiceAmount = "Celkový maximální součet před limitem stupně.",
                maximumManualItems = "Maximální libovolné pozice na dokument.",
                maximumReminders = "Maximální přípustné upomínky na fakturu.",
                minimumInvoiceAmount = "Minimální součet odhadů a faktur.",
                minimumPartialPayment = "Nejmenší částečná platba, s výjimkou menšího zbývajícího zůstatku nebo vkladu.",
                reminderFee = "Poplatek přidán každý platný připomenutí.",
                reminderGraceDays = "Dny zpoždění před první připomenutí je povoleno.",
                taxPercent = "Daň přidaná po slevách.",
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Instalace mobilního dynamometru",
                    entryPluralLabel = "Instalace mobilního dynamometru",
                    label = "Instalace mobilního dynamometru",
                },
                workshops = {
                    entryLabel = "Seminář",
                    entryPluralLabel = "Workshopy",
                    label = "Workshopy",
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
                crewCapacity = "Nejvyšší počet členů jednotky. Hodnota 0 znamená neomezenou posádku.",
                joinLocked = "Po obsazení jednotky zabrání připojení dalších členů.",
                minimumCrew = "Nejnižší počet členů ve vybraných jednotkách tohoto výjezdového plánu.",
                poiId = "Stálý technický identifikátor, na který lze odkazovat i po přejmenování bodu zájmu.",
                readyStatusCode = "Stav FMS použitý, když je prostředek připraven k vyslání.",
                resourceType = "Zařadí operační prostředek pro filtrování a koordinaci dispečinku.",
                respondingStatusCode = "Stav FMS použitý, když prostředek vyjíždí k události.",
                shortLabel = "Volitelný krátký popisek na šesti tlačítkách paměti rádiových kanálů.",
                stationId = "Přiřadí jednotku ke stanici nastavené v profilu dispečinku.",
                unitId = "Stálý technický identifikátor zachová jednotku i po změně volacího znaku.",
                autoAlarm = "Při vytvoření incidentu okamžitě přiřadí odpovídající dostupné jednotky.",
                available = "Jednotky v tomto stavu mohou být navrženy a přiřazeny k novému incidentu.",
                averageResponseSpeedKmh = "Vypočítá zobrazený odhad příjezdu z přímé vzdálenosti.",
                callsign = "Jedinečný rádiový volací znak zobrazený, když hráči obsluhují tuto virtuální jednotku.",
                centerEnabled = "Umožňuje oprávněným členům ve službě obsluhovat dispečink.",
                channelId = "ID rádiového kanálu pro PMA Voice, SaltyChat a YACA. Číselná ID jako 2500 zůstávají nezměněna; PMA Voice mapuje textová ID na stabilní číslo.",
                channelLabel = "Čitelný název kanálu zobrazený dispečerům a jednotkám.",
                defaultChannel = "Dispečeři se k tomuto kanálu připojují na začátku směny. Jednotky se připojují ručně na kartě Rádio. Chcete-li použít výchozí nastavení skupiny úloh, vyberte možnost Žádná.",
                emergencyAppEnabled = "Umožňuje vybrat tuto úlohu jako veřejnou službu v aplikaci Tísňové volání.",
                enabled = "Zpřístupní tuto úlohu aplikaci Dispatch a incidentům mezi úlohami.",
                icon = "Vyberte ikonu zobrazenou pro tuto kategorii jednotek v aplikaci Dispatch.",
                incidentAssessmentEnabled = "Zobrazuje lékařské otázky a otázky týkající se posouzení nebezpečí v celém příjmu incidentů.",
                jobs = "Další názvy úloh, které přijímají incidenty pomocí tohoto klíčového slova.",
                noUnitFallback = "Bez střediska nebo personální jednotky odešle oznámení Sky všem členům ve službě.",
                radius = "Maximální vzdálenost v metrech, na kterou lze slyšet hlášení stanice.",
                requirements = "Odpovězte na poptávku jako páry TYPE:COUNT, například PATROL:2,CRIME:1.",
                statusCode = "Číselný stav FMS zobrazený na ručním rádiu.",
                statusLabel = "Význam tohoto stavu FMS pro dispečery a jednotky.",
                vehicleType = "Musí odpovídat kódu typu vozidla nakonfigurovanému v předchozí podsekci.",
                vehicleTypeCode = "Krátký kód jednotky používaný v požadavcích na odezvu, například PATROL, CRIME, EMS nebo RESCUE.",
                vehicleTypeLabel = "Čitelný název této kategorie jednotek.",
            },
            dispatchFields = {
                crewCapacity = "Kapacita posádky",
                joinLocked = "Uzamknout připojení posádky",
                minimumCrew = "Minimální posádka",
                poiId = "Stálé ID bodu zájmu",
                readyStatusCode = "Kód stavu připravenosti",
                resourceType = "Typ prostředku",
                respondingStatusCode = "Kód stavu výjezdu",
                shortLabel = "Popisek paměti rádia",
                stationId = "ID stanice",
                unitId = "Stálé ID jednotky",
                address = "Adresa",
                autoAlarm = "Automatický alarm",
                available = "K dispozici k odeslání",
                averageResponseSpeedKmh = "Odhadovaná rychlost odezvy (km/h)",
                callsign = "Volací značka",
                category = "Kategorie",
                centerEnabled = "Povolit dispečink",
                channelId = "ID kanálu",
                code = "Kód",
                defaultChannel = "Výchozí rádiový kanál",
                emergencyAppEnabled = "Zobrazit v aplikaci Emergency App",
                enabled = "Povolit odeslání",
                icon = "Ikona",
                incidentAssessmentEnabled = "Povolit vyhodnocení stavu nouze",
                jobs = "Cílové úlohy (oddělené čárkami)",
                keywordCode = "Kód klíčového slova",
                label = "Štítek",
                name = "Jméno",
                noUnitFallback = "Informujte zaměstnance ve službě bez jednotek",
                noneChannel = "Žádné / výchozí skupina",
                note = "Poznámka",
                phone = "Telefon",
                radius = "Poloměr oznámení",
                requirements = "Požadované jednotky (například PATROL:2,CRIME:1)",
                type = "Typ",
                vehicleType = "Typ jednotky odpovědi",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Známí oznamovatelé",
                    channels = "Rádiové kanály",
                    plans = "Zásahové plány",
                    statuses = "Dostupné stavy FMS",
                    units = "Virtuální jednotky",
                },
                active = "Dispečink aktivní",
                description = "Nastavte pro tuto práci příjem tísňových hlášení, vysílačky, jednotky, zásahové plány, místa a údaje oznamovatelů.",
                inactive = "Dispečink vypnutý",
                steps = {
                    accessText = "Zapněte dispečink a určete, zda může tato práce obsazovat dispečerské centrum.",
                    accessTitle = "Přístup a příjem hlášení",
                    fleetText = "Nastavte kanály, stavové kódy FMS, typy vozidel a volací znaky.",
                    fleetTitle = "Vysílačky a vozový park",
                    responseText = "Dokončete nastavení klíčovými slovy, požadavky na zásah a body zájmu.",
                    responseTitle = "Zásahové plány",
                },
                title = "Dispečink",
                warnings = {
                    channels = "Nejsou nastaveny žádné vlastní rádiové kanály; použije se záložní kanál skupiny prací.",
                    defaultChannel = "Vybraný výchozí kanál již neexistuje.",
                    disabled = "Dispečink je pro tuto práci vypnutý.",
                    statuses = "Alespoň jeden stav FMS musí být dostupný, aby bylo možné jednotky poplachovat.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Spravuje jména oznamovatelů, telefonní čísla a poznámky dispečinku pro tuto profesi.",
                dispatchChannels = "Definuje rádiové kanály, ke kterým se mohou připojit jednotky a personální dispečinky.",
                dispatchKeywords = "Definuje klíčová slova incidentu, požadovaný počet vozidel, zúčastněné úlohy a volitelný automatický alarm.",
                dispatchPois = "Ukládá stanice a společná místa pro formuláře incidentů a hlášení stanic podle polohy.",
                dispatchStatusCodes = "Konfiguruje štítky stavu FMS a které stavy se počítají jako dostupné pro nové incidenty.",
                dispatchVehicleTypes = "Definuje kategorie jednotek používané plány reakce, jako je Patrol, Crime Unit, EMS nebo Rescue.",
                dispatchVehicles = "Definuje virtuální expediční vozidla, která mohou být obsluhována odkudkoli, aniž by bylo nutné vytvořit vozidlo.",
            },
            diagnosticsSettings = {
                enabledLabel = "Povolit diagnostiku vozidel",
                enabledDescription = "Umožní této práci otevřít diagnostiku vozidel a opravovat v ní součásti.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnostika vozidel",
                    description = "Nastavte přístup této práce k diagnostice vozidel.",
                },
                dispatchReporters = "Známí oznamovatelé",
                invalidSelection = "Neplatná volba: {value}",
                billingPrices = {
                    description = "Nastavte ceny faktur pro záznamy z historie údržby a oprav. Akční klíč se shoduje s action_key, action_type, nebo pracovní štítek.",
                    label = "Fakturační důvody",
                },
                billingSettings = {
                    description = "Nastavte mechanik fakturační chování pro tuto profesi.",
                    label = "Faktury",
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
                partsDeliveryShop = "Prodejna náhradních dílů",
                trainingSettings = {
                    description = "Nakonfigurujte přístup ke školení, registraci, schválení a plánování kurzu pro tuto úlohu.",
                    label = "Nastavení tréninku",
                },
                tuningCostProfile = {
                    description = "Nakonfigurujte výkon, vzhled, kolo a náklady na speciální možnosti této úlohy. Náklady podporujú požadované pole položek a objekty postupného upgradu.",
                    label = "Ceny tuningu",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Volná kamera v nabídce tuningu",
                    description = "Povolí skrytí kurzoru mezerníkem pro volný pohyb kamery. Escape nadále zavírá nabídku.",
                },
                tuningCamera = {
                    description = "Automaticky zaměří kameru na vybraný díl. Po vypnutí zůstane běžná herní kamera.",
                    label = "Automatická kamera tuningu",
                },
                jgMileage = {
                    description = "Používat JG Vehicle Mileage, když jeho resource běží. Jinak používat nájezd Sky. JG HUD se nastavuje samostatně.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Zobrazovat zvolený nájezd v JG HUD. Funguje bez JG Vehicle Mileage; nainstalujte adaptér HUD podle README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Povolí editor pro správce a automatická pravidla podle registrační značky a modelu. Po vypnutí dotčená vozidla znovu vyzvedněte z garáže, aby se obnovily dříve použité hodnoty.",
                    label = "Editor jízdních vlastností",
                },
                kuv = {
                    description = "Zahájit technickou prohlídku",
                    label = "Technická prohlídka vozidla",
                },
                mobileDyno = {
                    description = "Povolí mobilní dynamometr, fyzický ovládací a výsledkový displej, ovladač ventilátorů a tablet.",
                    label = "Mobilní dynamometr",
                },
                vehicleRegistration = {
                    description = "Registrovat / převést vozidlo",
                    label = "Registrace vozidla",
                },
                antiLag = {
                    description = "Povolit instalaci proti zpoždění a výfukové efekty.",
                    label = "Anti- Lag",
                },
                brakeOverheating = {
                    description = "Aktivujte jevištní brzdové teplo, zářící disky, kritické jiskry a krátké brzdy vyblednou.",
                    label = "Přehřátí brzd",
                },
                carryItems = {
                    description = "Požadovat přepravu dodaných dílů přes dílnu.",
                    label = "Manipulace s fyzickými díly",
                },
                customHandling = {
                    description = "Povolit vlastní ladění hnacího ústrojí a ovládání.",
                    label = "Vlastní manipulace",
                },
                electronicTuning = {
                    description = "Aktivujte trvalé ECU, možnosti doladění osvětlení a pomoci řidiče.",
                    label = "Elektronické ladění",
                },
                instantTuning = {
                    description = "Povolit přímé ladění na nakonfigurovaných veřejných místech ladění.",
                    label = "Okamžité ladění",
                },
                mileageHud = {
                    description = "Zobrazovat informace o ujetých kilometrech vozidla během jízdy.",
                    label = "Nejlépe HUD",
                },
                nitro = {
                    description = "Povolit instalaci nitro a použití pohonu vozidla.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Povolte objednávky dodávek dílenských dílů a doručovací prostory.",
                    label = "Dodávka dílů",
                },
                selfServiceOrderNotifications = {
                    description = "Informujte zaměstnance ve službě, když je vytvořen samoobslužný tuningový řád.",
                    label = "Oznámení o samoobslužné objednávce",
                },
                stance = {
                    description = "Zobrazit Stance úpravy ve všech ladění menu a povolit položku Stance Kit.",
                    label = "Postoj vozidla",
                },
                stanceWheelSize = {
                    description = "Zobrazit, uložit a aplikovat nastavení velikosti kola ve Stance.",
                    label = "Velikost tanečního kola",
                },
                stanceWheelWidth = {
                    description = "Zobrazit, uložit a aplikovat nastavení šířky kola ve Stance.",
                    label = "Šířka tanečního kola",
                },
                subscriptions = {
                    description = "Aktivovat předplatné workshop terminály, management a zákaznické slevy.",
                    label = "Předplatné workshopů",
                },
                twoStep = {
                    description = "Povolit dvoufázové ovládání spouštění a efekty výfuku.",
                    label = "Dvoustupňový",
                },
                vehicleMaintenanceNotifications = {
                    description = "Informujte majitele, až jejich vozidlo dosáhne konfigurovaného prahu údržby.",
                    label = "Oznámení o údržbě vozidla",
                },
                wheelDamage = {
                    description = "Umožněte realistické poškození a opravy kol.",
                    label = "Poškození kola",
                },
                workshopLift = {
                    description = "Povolit použitelnou zvedací karoserii nakonfigurované v dílnách.",
                    label = "Dílenský výtah",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Umístěte bod na kontrolní stanoviště dílny. Pro technickou kontrolu a registraci musí být vozidlo v nastavené vzdálenosti od stanoviště.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Umístění monitoru výsledků dynamometru.",
                    label = "Monitor výsledků dynamometru",
                },
                mobile_dyno_station = {
                    description = "Umístění mobilního dynamometru.",
                    label = "Stanice mobilního dynamometru",
                },
                vehicle_registry = "Místo technické kontroly a registrace",
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
            settingGroups = {
                diagnostics = {
                    label = "Diagnostika",
                },
                keybinds = {
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                    label = "Klávesové zkratky",
                },
                safety = {
                    label = "Ověření a bezpečnost",
                },
                antiExploit = {
                    label = "Ochrana proti zneužití",
                },
                coach = {
                    label = "Trenér telemetrie",
                },
                cooldownMultipliers = {
                    label = "Násobitele chlazení",
                },
                crashFalloff = {
                    label = "Útlum poškození při nárazu",
                },
                criticalEngine = {
                    label = "Zlomený motor",
                },
                deformation = {
                    label = "Deformace",
                },
                fade = {
                    label = "Slábnutí brzd při přehřátí",
                },
                features = {
                    label = "Vlastnosti",
                },
                format = {
                    label = "Formát",
                },
                frontalImpact = {
                    label = "Těžký čelní náraz",
                },
                general = {
                    label = "Obecné",
                },
                heatMultipliers = {
                    label = "Násobitele zahřívání",
                },
                illegalMarket = {
                    label = "Nezákonný trh",
                },
                integration = {
                    label = "Integrace",
                },
                items = {
                    label = "Předměty",
                },
                lifetime = {
                    label = "Život",
                },
                limits = {
                    label = "Mezní hodnoty pro ukládání",
                },
                repairRestore = {
                    label = "Obnovit opravy",
                },
                risk = {
                    label = "Riziko",
                },
                rules = {
                    label = "Pravidla",
                },
                stages = {
                    label = "Stupně přehřátí",
                },
                tyreRepair = {
                    label = "Opravy pneumatik",
                },
                visuals = {
                    label = "Vizuální efekty",
                },
            },
            settingSections = {
                electronicTuning = "Software motoru ECU",
                handlingEditor = "Editor jízdních vlastností",
                mobileDyno = "Mobilní dynamometr",
                vehicleRegistry = "Doklady vozidla",
                advancedPricing = "Pokročilé ceny",
                brakeOverheating = "Přehřátí brzd",
                carryItems = "Neste položky",
                fakePlates = "Falešné desky",
                firejobVehicleFires = "Požáry vozidla",
                general = "Generál",
                instantTuning = "Okamžité ladění",
                maintenanceNotifications = "Oznámení o údržbě",
                mileageHud = "Nejlépe HUD",
                oilLeaks = "Průniky kapalin ve vozidle",
                partsTheft = "Krádeže dílů",
                subscriptions = "Předplatná",
                tuning = "Ladění",
                vehicleCare = "Péče o vozidlo",
                wear = "Opotřebení",
                wheelDamage = "Poškození kola",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Další",
                handlingAir = "Vzduch",
                handlingGeneral = "Obecné",
                handlingRoad = "Silnice",
                handlingWater = "Voda",
            },
            settingSubsections = {
                mechanicHotkeys = "Klávesové zkratky",
                database = "Databáze",
                handlingEditorGeneral = "Nastavení editoru",
                handlingMaximumCBikeHandlingData = "Motocykl",
                handlingMaximumCBoatHandlingData = "Loď",
                handlingMaximumCCarHandlingData = "Auto",
                handlingMaximumCFlyingHandlingData = "Letadlo",
                handlingMaximumCHandlingData = "Základ vozidla",
                handlingMaximumCSeaPlaneHandlingData = "Hydroplán",
                handlingMaximumCSpecialFlightHandlingData = "Speciální let",
                handlingMaximumCSubmarineHandlingData = "Ponorka",
                handlingMaximumCTrailerHandlingData = "Přívěs",
                handlingMaximumCVehicleWeaponHandlingData = "Zbraně vozidla",
                keybinds = "Klávesové zkratky",
                operation = "Provoz",
                placementRules = "Pravidla umístění",
                testFlow = "Průběh testu",
                tuning = "Možnosti okamžitého tuningu",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Oprava vozidla",
                    description = "Nabízet opravu vozidla na místech okamžitého tuningu.",
                },
                instantTuningRepairPrice = {
                    label = "Cena opravy",
                    description = "Pevná cena opravy bez násobitele ceny tuningu.",
                },
                instantTuningWashEnabled = {
                    label = "Mytí vozidla",
                    description = "Nabízet mytí vozidla na místech okamžitého tuningu.",
                },
                instantTuningWashPrice = {
                    label = "Cena mytí",
                    description = "Pevná cena mytí bez násobitele ceny tuningu.",
                },
                vehiclePriceSource = {
                    label = "Zdroj cen vozidel",
                    description = "Automaticky: SQL pro ESX; katalog vozidel pro QBCore/Qbox. Databáze: nastavená SQL tabulka pro každý framework.",
                    options = {
                        auto = "Automaticky (framework)",
                        database = "Databáze",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabulka cen vozidel",
                    description = "Tabulka s nákupními cenami, např. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Sloupec názvu spawnu",
                    description = "Sloupec názvů spawnu, např. spawn_code (JG), nikoli zobrazovaného názvu.",
                },
                vehiclePricePriceColumn = {
                    label = "Sloupec ceny",
                    description = "Sloupec číselných nákupních cen, např. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Sloupec hashe modelu (volitelný)",
                    description = "Volitelný sloupec číselných hashů, např. hashkey (JG). Nechte prázdný pro výpočet hashů z názvů spawnu.",
                },
                handlingEditorFieldMaximum = {
                    description = "Pevná maximální hodnota, kterou editor pro toto pole jízdních vlastností přijme.",
                },
                handlingEditorFocusKey = {
                    label = "Návrat do editoru jízdních vlastností",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Počet zakódovaných bajtů, po kterém je požadavek, odpověď nebo snímek editoru označen jako velký.",
                    label = "Limit velkého objemu dat",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Měří operace editoru a přes Sky.Debug varuje při překročení nastavených limitů.",
                    label = "Kontroly výkonu",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Počet milisekund mezi souhrnnými přehledy výkonu při zapnutém podrobném protokolování.",
                    label = "Interval souhrnu výkonu",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Počet milisekund, po kterém je operace editoru označena jako pomalá.",
                    label = "Limit pomalé operace",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Nejvyšší procentní odchylka číselného posuvníku nad nebo pod načtenou základní hodnotu vozidla. Přímé zadání a import XML zůstávají bezeztrátové. Maximum pole odlišné od výchozí hodnoty nahrazuje horní mez posuvníku.",
                    label = "Maximální odchylka posuvníku",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Krádež katalyzátoru · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Krádež katalyzátoru · Ovládání 73",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl172 = {
                    label = "Výkonová brzda · Ovládání 172",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl173 = {
                    label = "Výkonová brzda · Ovládání 173",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl174 = {
                    label = "Výkonová brzda · Ovládání 174",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl175 = {
                    label = "Výkonová brzda · Ovládání 175",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl177 = {
                    label = "Výkonová brzda · Ovládání 177",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl38 = {
                    label = "Výkonová brzda · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl45 = {
                    label = "Výkonová brzda · Ovládání 45",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicDynoControl47 = {
                    label = "Výkonová brzda · Ovládání 47",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Lakování · Ovládání 200",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Lakování · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Péče o vozidlo · Ovládání 200",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Péče o vozidlo · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Tlačení vozidla · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Tlačení vozidla · Ovládání 33",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Tlačení vozidla · Ovládání 34",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Tlačení vozidla · Ovládání 35",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Tlačení vozidla · Ovládání 32",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Tlačení vozidla · Ovládání 21",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Výměna kola · Ovládání 200",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Výměna kola · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Výměna kola · Ovládání 22",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Krádež kola · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Krádež kola · Ovládání 73",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                mobileDynoConsumeItem = {
                    description = "Po úspěšném umístění odebrat jeden předmět.",
                    label = "Spotřebovat předmět",
                },
                mobileDynoCooldownMs = {
                    label = "Doba chlazení",
                },
                mobileDynoCountdownMs = {
                    label = "Odpočet spuštění",
                },
                mobileDynoDuiDistance = {
                    label = "Vzdálenost vykreslení panelu",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Vzdálenost ovladače ventilátorů",
                    description = "Vzdálenost v metrech pro použití fyzického přepínače mezi chladicími ventilátory.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Doba plného zatížení",
                    description = "Milisekundy vynaložené při trvalém plném zatížení v profilech, které zahrnují fázi plného naložení.",
                },
                mobileDynoHistoryLimit = {
                    label = "Limit historie",
                },
                mobileDynoInteractionDistance = {
                    label = "Vzdálenost ovládání panelu",
                },
                mobileDynoItemUseEnabled = {
                    description = "Povolit umístění dynometru a monitoru použitím předmětů.",
                    label = "Umístění pomocí předmětu",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limit aktivních relací",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Vzdálenost připojení vozidla",
                },
                mobileDynoMonitorItem = {
                    description = "Předmět inventáře pro umístění monitoru výsledků.",
                    label = "Předmět monitoru",
                },
                mobileDynoPersistItems = {
                    description = "Zachovat nově umístěné vybavení po restartu serveru.",
                    label = "Ukládat umístění",
                },
                mobileDynoPickupDistance = {
                    description = "Maximální vzdálenost v metrech pro sbalení vybavení.",
                    label = "Vzdálenost sbalení",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Maximální rozdíl výšky",
                    description = "Maximální odchylka výšky země v metrech přijímaná napříč všemi sondami stopy dyno.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Maximální sklon umístění",
                    description = "Maximální sklon země ve stupních přijat přes dyno stopu.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Mechanici musí být při umístění a obsluze ve službě.",
                    label = "Vyžadovat službu",
                },
                mobileDynoResultDuiDistance = {
                    label = "Vzdálenost výsledkového displeje",
                    description = "Maximální vzdálenost v metrech, ve kterých se provádí samostatný monitor výsledků.",
                },
                mobileDynoReturnItem = {
                    description = "Při sbalení vrátit spotřebovaný předmět.",
                    label = "Vrátit předmět",
                },
                mobileDynoStationItem = {
                    description = "Předmět inventáře pro umístění dynometru.",
                    label = "Předmět dynometru",
                },
                mobileDynoTabletDistance = {
                    description = "Maximální vzdálenost od dynometru v metrech pro ovládání tabletem a aktivní testy.",
                    label = "Dosah tabletu",
                },
                nitroActivationKey = {
                    label = "Podržet nitro",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                registryBikeChecks = {
                    description = "Kontrolní body motocyklů",
                    label = "Kontrolní body motocyklů",
                },
                registryCarChecks = {
                    description = "Kontrolní body automobilů",
                    label = "Kontrolní body automobilů",
                },
                registryDistance = {
                    description = "Servisní vzdálenost (metry)",
                    label = "Servisní vzdálenost (metry)",
                },
                registryKuvFee = {
                    description = "Poplatek Technická prohlídka vozidla",
                    label = "Poplatek Technická prohlídka vozidla",
                },
                registryKuvValidityDays = {
                    description = "Platnost nových prohlídek v reálném čase. Výchozí: 30 dní. Stávající data vypršení se nemění.",
                    label = "Platnost prohlídky (reálné dny)",
                },
                registryKuvWarningDays = {
                    description = "Předběžné upozornění (dny)",
                    label = "Předběžné upozornění (dny)",
                },
                registryRegistrationFee = {
                    description = "Registrační poplatek",
                    label = "Registrační poplatek",
                },
                registryReinspectionFee = {
                    description = "Poplatek za opakovanou prohlídku",
                    label = "Poplatek za opakovanou prohlídku",
                },
                registryRequireKuv = {
                    description = "Vyžadovat platnou Technická prohlídka vozidla pro registraci",
                    label = "Vyžadovat platnou Technická prohlídka vozidla pro registraci",
                },
                registrySessionSeconds = {
                    description = "Doba potvrzení (sekundy)",
                    label = "Doba potvrzení (sekundy)",
                },
                registryTransferFee = {
                    description = "Poplatek za převod",
                    label = "Poplatek za převod",
                },
                registryVehicleTypes = {
                    description = "Povolené typy vozidel",
                    label = "Povolené typy vozidel",
                },
                tuningFocusKey = {
                    label = "Ovládání tuningu myší",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                addRevenueToSociety = {
                    description = "Vklad zaplatil ladění objednávky peníze do ladění profesní společnosti účet.",
                    label = "Příjmy z vkladů pro společnost",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Dodávky dílů shop kategorie, které zůstávají volně prospěšné, zatímco pokročilé ceny jsou povoleny. Matching ignoruje pouzdro a bílý prostor.",
                    itemLabel = "Kategorie",
                    label = "Kategorie, které jsou vždy dostupné",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Udržujte nakonfigurované položky z vybraných kategorií k dispozici bez doladění objednávky a ceny je prostřednictvím dynamického dodavatelského systému.",
                    label = "Vždy dostupné položky do obchodu",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Počet dnů uvedených v analýze zisku ve formě tablet.",
                    label = "Období analýzy",
                },
                advancedPricingCategoryRules = {
                    description = "Podíl dodavatele, marže, pracovní síla a cenové hranice podle kategorie ladění.",
                    label = "Pravidla kategorie",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Výchozí mechanická marže před úpravami třídy a stupně.",
                    label = "Výchozí marže",
                },
                advancedPricingDifficultyRules = {
                    description = "Dodatečné náklady na pracovní sílu pro každou obtížnost ladění.",
                    label = "Pravidla obtížnosti",
                },
                advancedPricingEnabled = {
                    description = "Přepočítejte ceny ladění na serveru a, je-li povoleno Dodání dílů, vyžadují zakoupení dynastie součástí pro jejich konkrétní objednávku ladění.",
                    label = "Aktivovat pokročilé ceny",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normální virtuální zásoby pro každou dodavatelskou položku.",
                    label = "Základní zásoby",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Poptávkové body odstraněny za uplynulý den.",
                    label = "Denní pokles poptávky",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Dodavatelské markup přidán pro každý bod poptávky.",
                    label = "Přirážka poptávky na jednotku",
                },
                advancedPricingInventoryEnabled = {
                    description = "Zvýšit ceny dodavatelů, když virtuální akcie jsou nízké nebo poptávka je vysoká.",
                    label = "Dynamická zásoba dodavatelů",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Maximální přirážka dodavatele způsobená nízkými zásobami.",
                    label = "Přirážka při nízké zásobě",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Úroveň zásob pod úrovní, pod kterou začíná cena za nedostatek.",
                    label = "Nízkonákladový práh",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Horní hranice pro přirážku poptávky.",
                    label = "Maximální přirážka poptávky",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtuální jednotky doplněné o uplynulý den.",
                    label = "Denní doplňování",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Globální diskontní strop pro mechanické faktury.",
                    label = "Maximální sleva",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Nejvyšší povolenou mechanickou marži.",
                    label = "Maximální rozpětí",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Globální horní hranice cen pro ladění.",
                    label = "Maximální maloobchodní cena",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Značky, pracovní a diskontní hranice podle stupně mechaniky.",
                    label = "Mechanická pravidla",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Nejnižší povolenou mechanickou marži.",
                    label = "Minimální marže",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Globální hranice nižší ceny pro tuningovou část.",
                    label = "Minimální maloobchodní cena",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Hodnota vozidla použitá pro kompaktní příklad.",
                    label = "Kompaktní hodnota náhledu",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Příklad ladění náklady procento používané živý náhled.",
                    label = "Rychlost ladění náhledu",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Hodnota vozidla použitá pro sportovní příklad.",
                    label = "Hodnota náhledu sportu",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Hodnota vozidla použitá pro příklad superauta.",
                    label = "Super náhledová hodnota",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuty před tím, než se přepočítá neplacená cena.",
                    label = "Životnost citátu",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Procentní podíl vrácený za objednanou část.",
                    label = "Náhrada",
                },
                advancedPricingRoundingStep = {
                    description = "Kolem každé dynastie zadávací linka na tento krok peněz.",
                    label = "Krok zaokrouhlování dodavatele",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Procentní podíl ceny části zákazníka účtované společností Dynasty Auto Supply.",
                    label = "Podíl dodavatele",
                },
                advancedPricingTaxPercent = {
                    description = "Daňové procento uložené samostatně v cenovém účetnictví.",
                    label = "Daň",
                },
                advancedPricingVehicleClassRules = {
                    description = "Okraje a úpravy pracovních sil do GTA třídy vozidla.",
                    label = "Pravidla třídy vozidla",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Upgrade brzdy násobiče chlazení",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Násobitele chlazení třídy vozidla",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Zpoždění v milisekundách po brzdění před začátkem aktivního chlazení.",
                    label = "Zpoždění chlazení",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Teplo odstraněné za sekundu, zatímco brzda se nepoužívá.",
                    label = "Rychlost chlazení",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Teplo na které jiskry a krátké brzdy mohou začít.",
                    label = "Kritický práh",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Šance od 0 do 1 pro krátké vypínání brzd při brzdění při kritickém teple.",
                    label = "Slábnoucí šance za sekundu",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Ochlazování zatemnění",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Maximální délka blednutí",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Minimální délka blednutí",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Upgrade brzd, násobiče tepla",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Násobiče tepla třídy vozidla",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Základní teplo získané za sekundu při brzdění při referenčních otáčkách.",
                    label = "Přínos tepla",
                },
                brakeOverheatingHotThreshold = {
                    label = "Teplý práh",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Minimální rychlost vozidla v km/h před brzděním vytváří teplo.",
                    label = "Minimální brzdné otáčky",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Rychlost v km/h, při které se uplatňuje konfigurovaný základní tepelný zisk.",
                    label = "Referenční otáčky",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Maximální interval jiskry",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Minimální interval jiskry",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maximální vzdálenost v metrech pro záře a jiskření.",
                    label = "Vizuální vzdálenost",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Teplý práh",
                },
                carryItems = {
                    description = "Doručené části, které by se měly stát fyzicky nošené rekvizity.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Zvedák motoru",
                                forklift = "vysokozdvižný vozík",
                                hand = "Ruka",
                            },
                        },
                    },
                    itemLabel = "Nosit položku",
                    label = "Nosit položky",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 nepřidává výkon; 1,10 zvyšuje točivý moment o 10 %. Platí pro vozidla s tímto stupněm ECU.",
                    label = "Násobitel točivého momentu pro stupeň 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 nepřidává výkon; 1,10 zvyšuje točivý moment o 10 %. Platí pro vozidla s tímto stupněm ECU.",
                    label = "Násobitel točivého momentu pro stupeň 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 nepřidává výkon; 1,10 zvyšuje točivý moment o 10 %. Platí pro vozidla s tímto stupněm ECU.",
                    label = "Násobitel točivého momentu pro stupeň 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 nepřidává výkon; 1,10 zvyšuje točivý moment o 10 %. Platí pro vozidla s tímto stupněm ECU.",
                    label = "Násobitel točivého momentu pro stupeň 4",
                },
                fakePlatesAudit = {
                    label = "Protokol auditu",
                },
                fakePlatesBlacklist = {
                    description = "Blokovaná slova nebo fragmenty, které se nemohou objevit ve falešných deskách.",
                    label = "Černý seznam",
                },
                fakePlatesBlankPlateItem = {
                    description = "Materiál řemesel/shopu používaný pro smyčky s umělými deskami.",
                    label = "Prázdná deska",
                },
                fakePlatesCooldownMinutes = {
                    label = "Minuty prodlevy",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Padá šance.",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Srážka povolena",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Minimální rychlost nárazu",
                },
                fakePlatesEnabled = {
                    description = "Povolit hráčům používat falešné sady na vozidla.",
                    label = "Aktivovat falešné desky",
                },
                fakePlatesExpireMinutes = {
                    description = "0 udržuje falešné desky aktivní až do resetování nebo restartu manipulace je odstraní.",
                    label = "Vyplňte minuty.",
                },
                fakePlatesExpireOnRestart = {
                    label = "Vyplňte při restartu",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Platební účet",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Nelegální trh povolen",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Nelegální tržní cena",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Násobitel rizika",
                },
                fakePlatesInstallDurationMs = {
                    label = "Nainstalovat délku ms",
                },
                fakePlatesItem = {
                    description = "Jednoúčelová položka, která spustí tok umělé instalace desky.",
                    label = "Falešná sada desek",
                },
                fakePlatesMaxLength = {
                    label = "Maximální délka",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Vzdálenost od vozidla",
                },
                fakePlatesMinLength = {
                    label = "Minimální délka",
                },
                fakePlatesPattern = {
                    description = "Lua vzor použitý k potvrzení falešného textu desky, například ^[A-Z0-9]+$.",
                    label = "Lua vzor",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Vzdálenost polohy desky",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Blokovat duplikát aktivních falešných desek",
                },
                fakePlatesPrinterItem = {
                    description = "Nástroj řemesel/shopu používaný pro falešné smyčky ekonomiky desek.",
                    label = "Položka tiskárny desky",
                },
                fakePlatesRequireEngineOff = {
                    label = "Motor musí být vypnutý",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Před instalací použijte Config.Functions.CanApplyFakePlate.",
                    label = "požadovat vlastníka nebo klíče",
                },
                fakePlatesRequireStopped = {
                    label = "Vozidlo musí být zastaveno",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Vyhrazeno pro garážové integrace, které volají reset událost/export.",
                    label = "Obnovit garážový obchod",
                },
                fakePlatesRiskCharacters = {
                    label = "Typové znaky",
                },
                fakePlatesRiskEnabled = {
                    label = "Povolená typa rizika",
                },
                fakePlatesRiskTypoChance = {
                    label = "Typo šance",
                },
                fallbackVehicleValue = {
                    description = "Hodnota použitá v případě, že nelze vyřešit cenu vozidla.",
                    label = "Zpětná hodnota vozidla",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Pravděpodobnost od 0 do 1 po motoru zůstává kritická.",
                    label = "Kritická šance na požár motoru",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Vteřinku, než se spustí další rozbitý motor.",
                    label = "Kritické chlazení motoru",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Zpoždění v milisekundách, než se rozbije motor.",
                    label = "Kritické zpoždění motoru ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Nechte kriticky poškozené motory zapálit požár hasičského vozidla po zpoždění.",
                    label = "Ignitové rozbité motory",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Hustota kouře používaná pro požadavky na rozbitý motor.",
                    label = "Kritická hustota kouře motoru",
                },
                firejobVehicleFiresEnabled = {
                    description = "Povolit mechanikobu poškození systémy požádat o vozidlo požáry z Ohňostroj.",
                    label = "Aktivovat požáry hasičských vozidel",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Požadovaný poměr pohybu vpřed od 0 do 1.",
                    label = "Poměr pohybu dopředu",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Šance od 0 do 1, že kvalifikační dopad začne hořet.",
                    label = "Nárazová šance.",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Vteřinku, než se spustí další náraz.",
                    label = "Ochlazování nárazového ohně",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Nechte silné čelní nehody požádat o požár hasičského vozidla.",
                    label = "Ignit po těžkých nehodách",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Hustota kouře používaná pro požadavky na havarované požáry.",
                    label = "Hustota nárazu",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automaticky používá nakonfigurovaný Ohnivý zdroj; Bezbariérový zabraňuje mechaniku v vytváření požárů.",
                    label = "Režim integrace",
                    options = {
                        automatic = "Automaticky",
                        disabled = "Zakázáno",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Minimální tělesný stav ztracený během nárazu.",
                    label = "Minimální poškození těla",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Minimální zdraví motoru během nárazu ztraceno.",
                    label = "Minimální poškození motoru",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Použijte 0 k vypnutí této deformační kontroly.",
                    label = "Minimální přední deformace",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Minimální rychlost před nárazem v km/h.",
                    label = "Minimální rychlost nárazu",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Požadovaná ztráta rychlosti v km/h během nárazu.",
                    label = "Minimální ztráta rychlosti",
                },
                firejobVehicleFiresResource = {
                    description = "Zdroj, který přijímá požadavky na oheň ve vozidle.",
                    label = "Ohnivý zdroj",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Událost interního serveru, kterou mechanik klient použil k žádosti o požár hasičského vozidla.",
                    label = "Mechanická událost serveru",
                },
                freeVehicles = {
                    description = "Modely potěru vozidel, které dostávají zdarma objednávky na ladění.",
                    itemLabel = "Model vozidla",
                    label = "Bezplatná tuningová vozidla",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Prevent Apply while a critical handling conflict exist.",
                    label = "Blokování kritických zjištění",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Pro dokončenou zkoušku brzdění se očekává maximální zpomalení v m/s2.",
                    label = "Minimální zpomalení brzdy",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Měřené vzorky požadované před telemetrickým trenérem vyhodnotí běh.",
                    label = "Minimální vzorky",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Měřená rychlost prokluzu kola v km/h, při které se vykazuje ztráta trakce.",
                    label = "Varování při překlopení kola",
                },
                handlingEditorDefaultTab = {
                    description = "Stránka zvolena vždy, když se otevře samostatný Handling Editor.",
                    label = "Spustit stránku",
                    options = {
                        advanced = "Pokročilý",
                        export = "Vývoz",
                        flags = "Příznaky",
                        fleet = "Loďstvo",
                        inspector = "Vrstvy",
                        profiles = "Profily",
                        simple = "Jednoduchý",
                        telemetry = "Telemetrie",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Poskytněte efekt, referenční rozsah, symptomy, související pole a živou podporu pro každou manipulační hodnotu.",
                    label = "Oborová dokumentace",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Vyhledávání a filtrování názvů vlajek, efektů, poloh bitů a hexadecimálních masek.",
                    label = "Vyhledávání vlajek",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Vyhledávání, kontrola, podpora a obnovení modelu a pravidla pro manipulaci s deskami.",
                    label = "Správce loďstva",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Zobrazit základnu vozidla, nainstalován vlastní ladění, pravidlo modelu, pravidlo desky a aktuální návrh editoru pro každé pole.",
                    label = "Inspektor vrstvy",
                },
                handlingEditorMaxFleetResults = {
                    description = "Maximum modelu a poznávaček nabitých do Fleet Manager.",
                    label = "Mezní hodnota výsledků flotily",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Maximální počet revizí uložených pro každý profil.",
                    label = "Revize profilů",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Maximum pojmenovaných pracovních prostor uchovaných pro každého správce.",
                    label = "Osobní pracovní prostory",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Vytvořit auditovatelnou revizi pokaždé, když je aktualizován nebo obnoven sdílený profil.",
                    label = "Verze profilu",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Vytvořit transparentní doporučení založená na pravidlech z naměřených údajů o silničních zkouškách.",
                    label = "Trenér telemetrie",
                },
                handlingEditorValidatorEnabled = {
                    description = "Před použitím je detekovat nebezpečné nebo protichůdné kombinace.",
                    label = "Potvrzovač manipulace",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Povolit administrátorům, aby si nechali pojmenované soukromé návrhy editoru.",
                    label = "Osobní pracovní prostory",
                },
                instantTuningAllowedJobs = {
                    description = "Volitelný globální seznam povolených. Ponechte prázdné, chcete-li povolit všechny, pokud není povolena pouze mechanika.",
                    itemLabel = "Název zaměstnání",
                    label = "Povolené úlohy",
                },
                instantTuningBlipColor = {
                    description = "ID barvy značky na mapě GTA.",
                    label = "Barva skluzu",
                },
                instantTuningBlipEnabled = {
                    description = "Zobrazit mapu blips pro okamžité ladění umístění.",
                    label = "Blip povolen",
                },
                instantTuningBlipName = {
                    description = "Jméno \"Mapa blip.\"",
                    label = "Název smyčky",
                },
                instantTuningBlipSprite = {
                    description = "ID ikony značky na mapě GTA.",
                    label = "Ikona značky na mapě",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Použijte interakci ve stylu E značky i při zapnuté cílové podpoře.",
                    label = "Interakce značky síly",
                },
                instantTuningInteractionDistance = {
                    description = "Výchozí vzdálenost pro použití bodů okamžitého ladění.",
                    label = "Interakční vzdálenost",
                },
                instantTuningLabel = {
                    description = "Výchozí text zobrazený při okamžitém ladění bodů.",
                    label = "Výchozí štítek",
                },
                instantTuningLocations = {
                    description = "Instantní body ladění. Pomocí 0 vzdálenost zdědit výchozí interakční vzdálenost.",
                    itemLabel = "Umístění",
                    label = "Umístění",
                },
                instantTuningMarkerEnabled = {
                    description = "Nakreslete světovou značku v místě okamžitého ladění.",
                    label = "Značka povolena",
                },
                instantTuningMarkerType = {
                    description = "GTA typ značky používaný pro umístění okamžitého ladění.",
                    label = "Typ značky",
                },
                instantTuningMechanicOnly = {
                    description = "Omezit všechna místa okamžitého ladění nakonfigurované mechanické profese.",
                    label = "Pouze mechanik",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplikátor aplikovaný na ceny okamžitého ladění.",
                    label = "Násobitel ceny",
                },
                instantTuningProfile = {
                    description = "Nastavte, které možnosti ladění jsou k dispozici při okamžitém ladění bodů.",
                    label = "Možnosti okamžitého ladění",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimum minut před tím, než stejné vozidlo může spustit další připomenutí údržby.",
                    label = "Ochlazování oznámení",
                },
                maintenanceNotificationsEnabled = {
                    description = "Oznamte majitelům vozidel, že část opotřebení dosáhne prahu údržby.",
                    label = "Povoleno",
                },
                maintenanceNotificationsThreshold = {
                    description = "Noste procento nebo méně, které je považováno za dlužnou údržbu.",
                    label = "Splatný práh",
                },
                mileageHudDigits = {
                    description = "Počet číslic uvedených v kilometrech HUD.",
                    label = "Digity",
                },
                mileageHudPosition = {
                    description = "Přetáhněte kilometry HUD náhled do požadované polohy obrazovky.",
                    label = "Pozice",
                },
                oilLeaksCooldownSeconds = {
                    description = "Vteřinku, než se spustí další únik.",
                    label = "Ochlazování nárazu",
                },
                oilLeaksEnabled = {
                    description = "Nechte poškozená spalovací vozidla zanechat tekutinu při řízení.",
                    label = "Aktivovat úniky tekutiny",
                },
                oilLeaksEngineOilChance = {
                    description = "Normální šance na únik z 0 do 1.",
                    label = "Šance na motorový olej",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kritická šance na únik z 0 do 1.",
                    label = "Kritická šance na motorový olej",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Stav motorového oleje, při kterém nebo pod kterým se používá kritická šance.",
                    label = "Kritický práh obsahu motorového oleje",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Stav motorového oleje, pod nebo pod kterým může dojít k úniku.",
                    label = "Práh motorového oleje",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Požadovaný poměr pohybu vpřed od 0 do 1.",
                    label = "Poměr pohybu dopředu",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Nechte těžké čelní dopady nastartovat dočasný únik tekutiny motoru.",
                    label = "Úniky čelního nárazu",
                },
                oilLeaksImpactChance = {
                    description = "Šance od 0 do 1, že kvalifikační dopad začíná únik.",
                    label = "Šance na únik nárazu",
                },
                oilLeaksImpactRadius = {
                    description = "Radius počátečního bodu tekutiny vytvořeného nárazem.",
                    label = "Poloměr nárazu",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimálně sekundy mezi body.",
                    label = "Interval stezky",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Sekunda úniku pokračuje po kvalifikačním dopadu.",
                    label = "Doba netěsnosti nárazu",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Minimální tělesný stav ztracený během nárazu.",
                    label = "Minimální poškození těla",
                },
                oilLeaksMinDistance = {
                    description = "Minimální ujetá vzdálenost mezi body trasy.",
                    label = "Vzdálenost stezky",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Minimální zdraví motoru během nárazu ztraceno.",
                    label = "Minimální poškození motoru",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Požadovaná přední deformace. Použijte 0 k vypnutí této kontroly.",
                    label = "Minimální přední deformace",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Minimální rychlost před nárazem v km/h.",
                    label = "Minimální rychlost nárazu",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Požadovaná ztráta rychlosti v km/h během nárazu.",
                    label = "Minimální ztráta rychlosti",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Minimální rychlost vozidla v km/h před únikem kapaliny může vytvořit stopu.",
                    label = "Minimální rychlost",
                },
                oilLeaksRadius = {
                    description = "Radius pravidelných vodovodních bodů.",
                    label = "Poloměr koleje",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normální šance na únik z 0 do 1.",
                    label = "Šance na přenos tekutin",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kritická šance na únik z 0 do 1.",
                    label = "Kritická možnost přenosu",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Stav přenosové kapaliny v nebo pod kterým se používá kritická šance.",
                    label = "Kritický práh přenosu",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Kondiční tekutina, při níž nebo pod níž může dojít k úniku.",
                    label = "Práh přenosové kapaliny",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Třídy vozidel, které mohou dokončit objednávky závislé na výtahu bez výtahu v dílně.",
                    itemLabel = "Přidat třídu vozidla",
                    label = "Třída výtahového bypassu vozidla",
                    options = {
                        ["0"] = "Kompakty",
                        ["1"] = "Sedani",
                        ["10"] = "Průmyslové",
                        ["11"] = "Zásobování",
                        ["12"] = "Dodávky",
                        ["13"] = "Cykly",
                        ["14"] = "Lodě",
                        ["15"] = "Vrtulníky",
                        ["16"] = "Letadla",
                        ["17"] = "Servis",
                        ["18"] = "Stav nouze",
                        ["19"] = "vojenská",
                        ["2"] = "SUV",
                        ["20"] = "Obchodní",
                        ["21"] = "Vlaky",
                        ["22"] = "Otevřít kolo",
                        ["3"] = "Páry",
                        ["4"] = "svalovina",
                        ["5"] = "Sportovní klasika",
                        ["6"] = "Sport",
                        ["7"] = "Super.",
                        ["8"] = "Motocykly",
                        ["9"] = "Terénní",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modely potěru vozidel, které mohou dokončit objednávky závislé na vlecích bez výtahu.",
                    itemLabel = "Model vozidla",
                    label = "Modely výtahových bypassů",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milisekundy používané pro objednávku instalovat kroky, které nevedou minigame.",
                    label = "Jednoduchá doba instalace",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "ID třídy vozidla, které vždy používají normální mechanickou instalaci bez specializovaného výtahu nebo minigame toky.",
                    label = "Třída vozidel bez minigamu",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modely potěru vozidel, které vždy používají normální mechanickou instalaci bez specializovaného výtahu nebo miniherních toků.",
                    label = "Modely vozidel jiných než minigame",
                },
                partsDeliveryCompanyCard = {
                    description = "Povolit dodávky dílů k využití firemních fondů.",
                    label = "Platba kartou společnosti",
                },
                partsDeliveryMode = {
                    description = "Udržujte standardní fyzickou dodávku nebo přidejte plnou dodávku přímo do inventáře hráče.",
                    label = "Dodávková manipulace",
                    options = {
                        player_inventory = "Inventář hráčů",
                        standard = "Standardní dodací tok",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Milisekundy potřebné k vybalení připravených dílů dodávky.",
                    label = "Otevřené trvání",
                },
                partsDeliveryOwnCard = {
                    description = "Umožnit hráčům platit dodávky dílů vlastními penězi.",
                    label = "Vlastní platba kartou",
                },
                partsDeliveryTimeSeconds = {
                    description = "Sekundy mezi objednáním dílů a dodávkou se připravují.",
                    label = "Doba dodání",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventární položka udělena při krádeži katalyzátoru.",
                    label = "Položka Catalytického převodníku",
                },
                partsTheftDealerAccount = {
                    description = "Účet používaný pro prodejci kradených dílů výplaty, jako jsou peníze nebo banka.",
                    label = "Výplatní účet prodejce",
                },
                partsTheftDealerItems = {
                    description = "Ukradené položky, které bude prodejce kupovat a jejich výplatní hodnoty.",
                    itemLabel = "Položka \"obchodník\"",
                    label = "Dealer položky",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventární položka uvedená v případě, kdy dealer typ výplaty je položka. Prodejní cena se používá jako částka položky.",
                    label = "Položka pro výplatu dealerů",
                },
                partsTheftDealerPayoutType = {
                    description = "Vyberte si, zda prodejce zaplatí na rámcový účet nebo uvede položku inventáře.",
                    label = "Typ výplaty dealerů",
                    options = {
                        account = "Účet",
                        item = "Předmět",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maximální vzdálenost od dealera k prodeji kradených dílů.",
                    label = "Obchodník prodává vzdálenost",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Vteřinku před tím, než ta samá část vozidla může vytvořit další expedici.",
                    label = "Prodleva dispečinku",
                },
                partsTheftDispatchEnabled = {
                    description = "Vytvořit policejní dispečer při krádeži kola nebo katalyzátoru.",
                    label = "Pošlete policejní zprávu.",
                },
                partsTheftDispatchJobs = {
                    description = "názvy povolání, které dostávají části krádeže expedice.",
                    itemLabel = "Název zaměstnání",
                    label = "Pracovní úkoly dispečinku",
                },
                partsTheftDispatchMessage = {
                    description = "Zpráva zobrazená v hlášení. Podpora {plate}, {part}, a {type}.",
                    label = "Zpráva o odeslání",
                },
                partsTheftDispatchTitle = {
                    description = "Název zobrazený v upozornění o odeslání. {plate}, {part}a {type}.",
                    label = "Název expedice",
                },
                partsTheftItem = {
                    description = "Inventurní položka používaná k krádeži kol a katalyzátorů.",
                    label = "Krádež nástrojová položka",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Odeberte nástroj krádeže po úspěšné krádeži akce.",
                    label = "Nástroj pro krádež hltanu",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventární položka oceněná při krádeži kol.",
                    label = "Ukradený předmět kola",
                },
                priceType = {
                    description = "Procentní podíl počítá náklady z ceny vozidla. Pevné používá peněžní hodnoty. Třída vozidla používá třídní cenovou tabulku.",
                    label = "Typ ceny",
                    options = {
                        class = "Třída vozidla",
                        fixed = "Pevné",
                        percentage = "Procentní podíl",
                    },
                },
                primaryColor = {
                    description = "Výchozí barva pro mechanickou skupinu povolání a nové profese. Použijte hex hodnotu, jako je #EDC001.",
                    label = "Základní barva",
                },
                publicUsersSeePrices = {
                    description = "Pokud je to povoleno, platí veřejné zákazníky při objednávce. Zakázat to vytvořit nezaplacené objednávky pro mechanickou fakturaci.",
                    label = "Obviňte veřejné samoobslužné objednávky",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Povolit autorizovaným šéfům nákup předplatného pro celou svou profesi pomocí firemních fondů.",
                    label = "Předplatné společností",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Platební měna",
                },
                subscriptionsEnabled = {
                    description = "Aktivujte předplatné dílny, zákaznické terminály a slevy na předplatné.",
                    label = "Povoleno",
                },
                subscriptionsMaximumDurations = {
                    description = "Maximální doba trvání a cenové možnosti na model předplatného.",
                    label = "Maximální doba trvání",
                },
                subscriptionsMaximumModels = {
                    description = "Maximální modely předplatného, které lze nakonfigurovat v tabletu.",
                    label = "Maximální modely",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Volitelný smyčcový animační klip použitý při prázdném scénáři.",
                    label = "NPC emote klip",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Volitelný animační slovník používaný při prázdném scénáři.",
                    label = "NPC emote slovník",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped model vyplodil na ústředně terminálů, například s_m_autoshop_01.",
                    label = "Výchozí model NPC",
                },
                subscriptionsNpcScenario = {
                    description = "Volitelné GTA scénář, jako je WORLD_HUMAN_CLIPBOARD. Nechte prázdné použít emote animace.",
                    label = "Scénář NPC",
                },
                tuningBlockedPlates = {
                    description = "Vozidla s jednou z těchto desek nelze naladit, nainstalovat nebo odstranit ladění. Shodující se ignoruje obal a bílý prostor.",
                    itemLabel = "SPZ",
                    label = "Zablokované ladicí desky",
                },
                tuningWorkshopDistance = {
                    description = "Maximální vzdálenost od samoobslužného bodu ladění pro požadované instalační nebo odstraňovací akce.",
                    label = "Workshop požadované vzdálenosti",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Vyžaduje instalaci objednávky ladění pro spuštění a dokončení v blízkosti samoobslužného ladění.",
                    label = "Vyžaduje dílnu pro instalace",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Vyžaduje odstranění ladění, aby bylo možné začít a dokončit v blízkosti samoobslužného ladění.",
                    label = "Vyžadovat dílnu pro odstraňování",
                },
                vehicleCareRepairDurationMs = {
                    description = "Doba trvání opravy v milisekundách.",
                    label = "Doba trvání opravy",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Také resetovat realistické poškození kola při použití opravy akce.",
                    label = "Opravit realistické poškození kola",
                },
                vehicleCareRepairItem = {
                    description = "Inventurní položka používaná při opravě vozidla.",
                    label = "Předmět opravy",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Maximální vzdálenost od vozidla při opravě.",
                    label = "Oprava max. vzdálenost",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Po použití odstraňte opravenku.",
                    label = "Konzumní opravy položky",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Opravte normální poškození vozidla GTA při použití opravy.",
                    label = "Opravit poškození vozidla",
                },
                vehicleCareRepairWearParts = {
                    description = "Vyberte si, které opotřebení a servis části opravy položka obnovuje. Zakázat tekutiny zde, pokud olej, chladicí kapaliny, brzdové kapaliny, nebo převodová kapalina by měla vyžadovat diagnostické opravy průtok.",
                    itemLabel = "Nosit část",
                    label = "Renovované části opravny",
                },
                vehicleCareWashItem = {
                    description = "Inventurní položka použitá k mytí vozidla.",
                    label = "Umýt položku",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Po použití odstraňte umyvadlo.",
                    label = "Konzumní mycí položka",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Vzdálenost voskovaného vozidla zůstává čistá.",
                    label = "Vosk čisté kilometry",
                },
                vehicleCareWaxItem = {
                    description = "Inventurní položka použitá k voskování vozidla.",
                    label = "Vosková položka",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Po použití odstraňte voskovou položku.",
                    label = "Položka vosku z hlávky",
                },
                vehicleClassPricing = {
                    description = "Přeškrtněte typ ceny a násobitel nákladů pro každou třídu vozidel GTA.",
                    label = "Ceny za třídu vozidel",
                },
                wearParts = {
                    description = "Díly opotřebení vozidla, jejich doživotní vzdálenost, požadované opravy, spotřeba předmětů a instalační průtok.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalytický převodník",
                                fluid_refill = "Náplň tekutin",
                                hood_install = "Nainstalovat Hood",
                                oil_change = "Změna oleje",
                                performance = "Výkon",
                                underbody_neon = "Podvozek / výtah",
                                wheel = "Kolo",
                            },
                        },
                    },
                    itemLabel = "Nosit část",
                    label = "Části a součásti oděvů",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Násobitel poškození základního kola.",
                    label = "Výchozí násobitel",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtrační deformační sonda ukazuje, které neukazují zpět na těleso vozidla.",
                    label = "Práh úhlu sondy",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Další síla přidala každou obnovu iterace.",
                    label = "Zvýšení poškození deformací",
                },
                wheelDamageDeformationEnabled = {
                    description = "Zachytit a obnovit promáčknutí těla během geometrie opravy pneumatik znovu.",
                    label = "Obnovit deformaci",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Startovací síla použitá při obnově promáčknutí.",
                    label = "Počáteční poškození deformace",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximální propustky SetVozidloPoškození slouží k obnově promáčknutí.",
                    label = "Deformační iterace",
                },
                wheelDamageDeformationThreshold = {
                    description = "Minimální deformační velikost pro uložení.",
                    label = "Deformační práh",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Násobič používaný při jízdě na terénních kolech.",
                    label = "Násobitel terénních kol",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra instantní poškození kola obnovení prochází po geometrie kola je přestavěn.",
                    label = "Škody znovu projdou",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Extra instantní průchody pro stále chybějící nebo nehybné pneumatiky po opravě kola.",
                    label = "Dálkové průchody pro stav kola",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Udržujte tělo, motor, okna, dveře, nečistoty a vizuální poškození, když opravy pneumatik obnovuje geometrie kola.",
                    label = "Zachovat poškození vozidla",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Obnovit rozbitá okna bez hlasitého rozbít efekt, pokud je to možné.",
                    label = "Tichá rozbitá okna",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Znovu nasadit stále nafukovací pneumatiky, aniž by spustily nový pop zvuk nebo efekt pneumatiky.",
                    label = "Tichá plochá pneumatika se znovu naplní",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Maximální vzdálenost od poškozené nebo chybějící pneumatiky pro činnost při montáži.",
                    label = "Vzdálenost připojení pneumatiky",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maximální vzdálenost od umístěné auto jack pro odstranění akce.",
                    label = "Auto jack odebrat vzdálenost",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Násobitele škod podle třídy vozidla GTA.",
                    itemLabel = "Třída vozidla",
                    label = "Násobiče třídy vozidla",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Blokovat jiné profese, když jsou mechanici ve službě",
                },
                allowsprint = {
                    label = "Povolit sprint s doručovacími krabicemi",
                },
            },
            tuningCategories = {
                bodywork = "Karoserie",
                electronics = "ECU a elektronika vozidla",
                engineSounds = "Zvuky motoru",
                handling = "Jízdní vlastnosti",
                lights = "Světla",
                other = "Ostatní",
                paint = "Lakování",
                performance = "Výkon",
                stance = "Postoj vozidla",
                wheels = "Kola",
            },
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Cena pro zákazníka",
                description = "Příklad kosmetického výpočtu s použitím aktuálních pravidel.",
                labor = "Práce",
                live = "Živý náhled",
                margin = "Marže",
                sports = "Sportovní auto",
                super = "Supercar",
                supplier = "Dodavatel",
                title = "Náhled ceny",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Nakonfigurujte úlohy mechaniků, obchodů, vozidel a umístění dílen.",
                    title = "Práce mechanika",
                },
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
            fields = {
                quantity = "Množství",
            },
            settingValues = {
                air_filter = "Vzduchový filtr",
                brake_fluid = "Brzdová kapalina",
                brake_pads = "Brzdové destičky",
                catalytic_converter = "Katalytický konvertor",
                clutch = "Spojka",
                coolant = "Chladicí kapalina",
                engine_oil = "Motorový olej",
                inverter = "Power Invertor",
                spark_plugs = "Zapalovací svíčky",
                suspension = "Pozastavení",
                traction_battery = "Trakční baterie",
                transmission_fluid = "Převodová kapalina",
                tyres = "Pneumatiky",
                vehicleClass_0 = "Kompakty",
                vehicleClass_1 = "Sedani",
                vehicleClass_10 = "Průmyslové",
                vehicleClass_11 = "Zásobování",
                vehicleClass_12 = "Dodávky",
                vehicleClass_13 = "Cykly",
                vehicleClass_14 = "Lodě",
                vehicleClass_15 = "Vrtulníky",
                vehicleClass_16 = "Letadla",
                vehicleClass_17 = "Servis",
                vehicleClass_18 = "Stav nouze",
                vehicleClass_19 = "vojenská",
                vehicleClass_2 = "SUV",
                vehicleClass_20 = "Obchodní",
                vehicleClass_21 = "Vlaky",
                vehicleClass_22 = "Otevřít kolo",
                vehicleClass_3 = "Páry",
                vehicleClass_4 = "svalovina",
                vehicleClass_5 = "Sportovní klasika",
                vehicleClass_6 = "Sport",
                vehicleClass_7 = "Super.",
                vehicleClass_8 = "Motocykly",
                vehicleClass_9 = "Terénní",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "Anti- Lag",
                    values = {
                        [0] = "Zakázáno",
                        [1] = "GTA standard",
                        [2] = "Pouliční práskání",
                        [3] = "Závodní Anti-Lag",
                        [4] = "Anti-lag pro rally",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automatické výstražné blinkry",
                    values = {
                        [0] = "Vypnuto",
                        [1] = "Zapnuto",
                    },
                },
                electronic_brake_lights = {
                    label = "Brzdová světla",
                    values = {
                        [0] = "Normálně",
                        [1] = "Nouzové blikání",
                        [2] = "Vypnuto",
                    },
                },
                electronic_engine_tune = {
                    label = "Software motoru",
                    values = {
                        [0] = "Zásoby",
                        [1] = "Fáze 1",
                        [2] = "Fáze 2",
                        [3] = "Fáze 3",
                        [4] = "Fáze 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Jas světlometů",
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
                    label = "Dálková světla při troubení",
                    values = {
                        [0] = "Vypnuto",
                        [1] = "Zapnuto",
                    },
                },
                electronic_idle_rpm = {
                    label = "Volnoběžné otáčky",
                    values = {
                        [0] = "Zásoby",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Vnitřní osvětlení",
                    values = {
                        [0] = "Normálně",
                        [1] = "Červená",
                    },
                },
                electronic_mood_color = {
                    label = "Barva světla nálady",
                    values = {
                        [0] = "Vypnuto",
                        [1] = "Červená",
                        [10] = "Limetková",
                        [11] = "Tyrkysová",
                        [12] = "Indigo",
                        [13] = "Bílá",
                        [14] = "Teplá bílá",
                        [15] = "Studená bílá",
                        [16] = "Jantarová",
                        [2] = "Modrá",
                        [3] = "Zelená",
                        [4] = "Azurová",
                        [5] = "Purpurová",
                        [6] = "Žlutá",
                        [7] = "Oranžová",
                        [8] = "Fialová",
                        [9] = "Růžová",
                    },
                },
                electronic_mood_intensity = {
                    label = "Jas ambientního osvětlení",
                    values = {
                        [0] = "Tlumené",
                        [1] = "Normálně",
                        [2] = "Jasné",
                    },
                },
                electronic_radio_power = {
                    label = "Napájení rádia",
                    values = {
                        [0] = "Vypnuto",
                        [1] = "Zapnuto",
                    },
                },
                electronic_throttle_response = {
                    label = "Odezva plynu",
                    values = {
                        [0] = "Více trakce",
                        [1] = "Agresivní",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Nastavení wheelie",
                    values = {
                        [0] = "Vypnuto",
                        [1] = "Jemné",
                        [2] = "Intenzivní",
                    },
                },
            },
            vehicleClassLabel = "Třída {id} ({name})",
        },
    },
}
