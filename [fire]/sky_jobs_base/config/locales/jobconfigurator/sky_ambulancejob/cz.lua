JobConfigLocales["sky_ambulancejob:cz"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Lékařské posudky",
                sharedMedicalEvaluations = "Sdílené lékařské posudky",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Povolit respawn",
                        description = "Urci, zda lze toto luzko vybrat pro respawn hrace.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Nakonfigurujte úlohy ambulance, nemocniční lůžka, systémy smrti, interakce a nastavení základních funkcí.",
                    title = "Ambulance zaměstnání",
                },
            },
            dispatchActions = {
                currentLocation = "Použít aktuální polohu",
                addChannel = "Přidat rádiový kanál",
                addKeyword = "Přidat klíčové slovo",
                addPoi = "Přidat bod zájmu",
                addReporter = "Přidat oznamovatele",
                addStatus = "Přidat stav FMS",
                addVehicle = "Přidat virtuální jednotku",
                addVehicleType = "Přidat typ jednotky",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Minimální počet personálu v jednotkách vybraných pro tento plán odezvy.",
                noUnitFallback = "Bez střediska nebo personální jednotky odešle oznámení Sky všem členům ve službě.",
                radius = "Maximální vzdálenost v metrech, na kterou lze slyšet hlášení stanice.",
                requirements = "Odpovězte na poptávku jako páry TYPE:COUNT, například PATROL:2,CRIME:1.",
                statusCode = "Číselný stav FMS zobrazený na ručním rádiu.",
                statusLabel = "Význam tohoto stavu FMS pro dispečery a jednotky.",
                vehicleType = "Musí odpovídat kódu typu vozidla nakonfigurovanému v předchozí podsekci.",
                vehicleTypeCode = "Krátký kód jednotky používaný v požadavcích na odezvu, například PATROL, CRIME, EMS nebo RESCUE.",
                vehicleTypeLabel = "Čitelný název této kategorie jednotek.",
                crewCapacity = "Nejvyšší počet členů jednotky. Hodnota 0 znamená neomezenou posádku.",
                joinLocked = "Po obsazení jednotky zabrání připojení dalších členů.",
                poiId = "Stálý technický identifikátor, na který lze odkazovat i po přejmenování bodu zájmu.",
                readyStatusCode = "Stav FMS použitý, když je prostředek připraven k vyslání.",
                resourceType = "Zařadí operační prostředek pro filtrování a koordinaci dispečinku.",
                respondingStatusCode = "Stav FMS použitý, když prostředek vyjíždí k události.",
                shortLabel = "Volitelný krátký popisek na šesti tlačítkách paměti rádiových kanálů.",
                stationId = "Přiřadí jednotku ke stanici nastavené v profilu dispečinku.",
                unitId = "Stálý technický identifikátor zachová jednotku i po změně volacího znaku.",
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
                defaultChannel = "Výchozí rádiový kanál",
                emergencyAppEnabled = "Zobrazit v aplikaci Emergency App",
                enabled = "Povolit odeslání",
                icon = "Ikona",
                incidentAssessmentEnabled = "Povolit vyhodnocení stavu nouze",
                jobs = "Cílové úlohy (oddělené čárkami)",
                keywordCode = "Kód klíčového slova",
                label = "Štítek",
                minimumCrew = "Minimální posádka",
                name = "Jméno",
                noUnitFallback = "Informujte zaměstnance ve službě bez jednotek",
                noneChannel = "Žádné / výchozí skupina",
                note = "Poznámka",
                phone = "Telefon",
                radius = "Poloměr oznámení",
                requirements = "Požadované jednotky (například PATROL:2,CRIME:1)",
                type = "Typ",
                vehicleType = "Typ jednotky odpovědi",
                crewCapacity = "Kapacita posádky",
                joinLocked = "Uzamknout připojení posádky",
                poiId = "Stálé ID bodu zájmu",
                readyStatusCode = "Kód stavu připravenosti",
                resourceType = "Typ prostředku",
                respondingStatusCode = "Kód stavu výjezdu",
                shortLabel = "Popisek paměti rádia",
                stationId = "ID stanice",
                unitId = "Stálé ID jednotky",
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
                    statuses = "Dostupné FMS",
                    units = "Virtuální jednotky",
                    reporters = "Známí oznamovatelé",
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
                dispatchStatusCodes = "Konfiguruje štítky stavu FMS a které stavy se počítají jako dostupné pro nové incidenty.",
                dispatchVehicleTypes = "Definuje kategorie jednotek používané plány reakce, jako je Patrol, Crime Unit, EMS nebo Rescue.",
                dispatchVehicles = "Definuje virtuální expediční vozidla, která mohou být obsluhována odkudkoli, aniž by bylo nutné vytvořit vozidlo.",
                dispatchReporters = "Spravuje jména oznamovatelů, telefonní čísla a poznámky dispečinku pro tuto profesi.",
            },
            extensions = {
                invalidSelection = "Neplatná volba: {value}",
                trainingSettings = {
                    description = "Nakonfigurujte přístup ke školení, registraci, schválení a plánování kurzu pro tuto úlohu.",
                    label = "Nastavení tréninku",
                },
                dispatchReporters = "Známí oznamovatelé",
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
            },
            features = {
                bleeding = {
                    description = "Aktivujte odvzdušňovací systém.",
                    label = "Krvácející",
                },
                bodybags = {
                    description = "Povolit vaky na tělo a toky doručení vaků na tělo.",
                    label = "Vaky na tělo",
                },
                consciousScenarioBloodPressure = {
                    description = "Umožněte kontroly krevního tlaku, když je pacient při vědomí.",
                    label = "Vědomý krevní tlak",
                },
                deathTimeout = {
                    description = "Povolit tok časového limitu smrti.",
                    label = "Časový limit smrti",
                },
                fractures = {
                    description = "Umožňují manipulaci a ošetření zlomenin.",
                    label = "Zlomeniny",
                },
                knockout = {
                    description = "Povolte vyřazovací systém.",
                    label = "Knokaut",
                },
                legShotRagdoll = {
                    description = "Po zásahu nastavených oblastí nohou nebo chodidel hráč upadne.",
                    label = "Pád po zásahu nohy",
                },
                pain = {
                    description = "Aktivujte systém bolesti.",
                    label = "Bolest",
                },
                respawnInBed = {
                    description = "Respawn oživil hráče na nemocničním lůžku, když byl k dispozici.",
                    label = "Respawn V Posteli",
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
                gang = "Gang",
                allowInVehicle = "Povolit ve vozidle",
                allowMovement = "Povolit pohyb",
                animDict = "Animační slovník",
                animFlag = "Příznak animace",
                animName = "Název animace",
                bleeding = "Krvácení",
                cause = "Příčina",
                chance = "Šance",
                class = "Třída",
                companyPrice = "Cena pro firmu",
                companyPricePerEmployee = "Cena za zaměstnance",
                copayPercent = "Copay %",
                description = "Popis",
                dictionary = "Animační slovník",
                duration = "Doba trvání",
                durationMs = "Doba trvání (ms)",
                effect = "Efekt",
                effectDurationMs = "Doba efektu (ms)",
                effectDurationSeconds = "Doba efektu (sekundy)",
                enabled = "Aktivováno",
                extractionType = "Typ extrakce",
                foreignObject = "Cizí těleso",
                heal = "Léčení",
                id = "ID",
                itemName = "Název položky",
                key = "Klíč",
                label = "Označení",
                lang = "Jazyk",
                limit = "Limit",
                lossPerSecond = "Ztráta za sekundu",
                max = "Maximální",
                min = "Min.",
                minGrade = "Min. stupeň",
                minigame = "Minihra",
                model = "Model rekvizity",
                name = "Název práce",
                options = "Možnosti (typy výběru)",
                pain = "Bolest",
                pauseBleedingSeconds = "Pozastavit krvácení (sekundy)",
                price = "Cena",
                progressbarAllowInVehicle = "Průběh: povolit ve vozidle",
                progressbarAllowMovement = "Průběh: povolit pohyb",
                progressbarCanCancel = "Průběh lze zrušit",
                progressbarDisableCarMovement = "Průběh: zakázat pohyb vozidla",
                progressbarDisableCombat = "Průběh: zakázat boj",
                progressbarDisableMouse = "Průběh: zakázat myš",
                progressbarDisableMovement = "Průběh: zakázat pohyb",
                progressbarDisableSprint = "Průběh: zakázat sprint",
                progressbarDuration = "Doba průběhu",
                progressbarEnabled = "Ukazatel průběhu zapnut",
                progressbarLabel = "Text průběhu",
                progressbarUseWhileDead = "Použitelné po smrti",
                questions = "Otázky",
                requireItems = "Vyžadovat položky",
                required = "Vyžadováno",
                requiresExtraction = "Vyžaduje extrakci",
                requiresOpenWound = "Vyžaduje otevřenou ránu",
                sort = "Pořadí",
                state = "Stav",
                stopBleeding = "Zastavit krvácení",
                threshold = "Práh",
                time = "Čas",
                type = "Typ",
                useAnimation = "Použijte animaci",
                value = "Hodnota",
                zone = "Zóna",
                zones = "Zóny",
                systolic = "Systolický tlak",
                diastolic = "Diastolický tlak",
                cardiacArrest = "Srdeční zástava",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Generál",
                },
                billingRange = {
                    label = "Rozsah",
                },
                billingReasons = {
                    label = "Důvod Předvolby",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animace",
                },
                bodyBagAttachGeneral = {
                    label = "Připojit",
                },
                bodyBagAttachOffsets = {
                    label = "Ofsety",
                },
                bodyBagAttachRotation = {
                    label = "Otáčení",
                },
                bodyBagDeliveryGeneral = {
                    label = "Generál",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Generál",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Platba",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Generál",
                },
                crutchAssign = {
                    label = "Úkol",
                },
                crutchDuration = {
                    label = "Trvání",
                },
                crutchGeneral = {
                    label = "Generál",
                },
                crutchItems = {
                    label = "Položka",
                },
                crutchRestrictions = {
                    label = "Omezení",
                },
                damageHandlingBladeWeapons = {
                    label = "Čepelové zbraně",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Černá listina krvácení",
                },
                damageHandlingBleedingClasses = {
                    label = "Kurzy krvácení",
                },
                damageHandlingBloodSystem = {
                    label = "Krevní systém",
                },
                damageHandlingDeathInjuries = {
                    label = "Smrtelná zranění",
                },
                damageHandlingInjuryEffects = {
                    label = "Účinky zranění",
                },
                damageHandlingInjuryThresholds = {
                    label = "Prahové hodnoty zranění",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll po zasahu nohy",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zony zasahu nohy",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Živé poškození zlomeniny",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Zónové šance",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Stacky otevrenych ran",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limity zon",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Kurzy živých ran",
                },
                damageHandlingMedications = {
                    label = "Léky",
                },
                damageHandlingPainClasses = {
                    label = "Třídy bolesti",
                },
                damageHandlingPainEffects = {
                    label = "Účinky na bolest",
                },
                damageHandlingStatusEffects = {
                    label = "Stavové efekty",
                },
                damageHandlingVehicleDamage = {
                    label = "Poškození vozidla",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Příčiny poškození",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Zranění",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Ochrana proti nárazu vozidla",
                },
                deathAnimal = {
                    label = "Zvířecí ústup",
                },
                deathAnimalAnimation = {
                    label = "Animace zvířat",
                },
                deathAnimation = {
                    label = "Animace",
                },
                deathGeneral = {
                    label = "Generál",
                },
                deathModels = {
                    label = "Přepsání podle modelu",
                },
                deathScreenAiMedic = {
                    label = "Generál",
                },
                deathScreenAiMedicAvailability = {
                    label = "Dostupnost",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Chování",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Vynutit oživení",
                },
                deathScreenAiMedicPayment = {
                    label = "Platba",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Oživte v posteli",
                },
                deathScreenAiMedicSpawn = {
                    label = "Potěr",
                },
                deathScreenAiMedicTiming = {
                    label = "Načasování",
                },
                deathScreenControls = {
                    label = "Ovládací prvky",
                },
                deathScreenDamageLogs = {
                    label = "Záznamy poškození",
                },
                deathScreenDimensions = {
                    label = "Rozměry",
                },
                deathScreenDispatch = {
                    label = "Odeslat",
                },
                deathScreenEarlyRespawn = {
                    label = "Generál",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Dostupnost",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Platba",
                },
                deathScreenGeneral = {
                    label = "Generál",
                },
                deathScreenHospitalSelection = {
                    label = "Výběr nemocnice",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Výběr fotoaparátu",
                },
                deathScreenInformation = {
                    label = "Generál",
                },
                deathScreenIntegration = {
                    label = "Integrace",
                },
                deathScreenLogs = {
                    label = "Záznamy úmrtí",
                },
                deathScreenMinigame = {
                    label = "Minihra",
                },
                deathScreenRespawn = {
                    label = "Generál",
                },
                deathScreenRespawnAccounts = {
                    label = "Účty",
                },
                deathScreenRespawnFallback = {
                    label = "Záložní Coords",
                },
                deathScreenRespawnItems = {
                    label = "Položky",
                },
                deathScreenRespawnWeapons = {
                    label = "Zbraně",
                },
                deathScreenStyle = {
                    label = "Styl obrazovky smrti",
                },
                deathScreenVoice = {
                    label = "Hlas",
                },
                deathTimeoutGeneral = {
                    label = "Generál",
                },
                deathTimeoutWhitelist = {
                    label = "Práce na seznamu povolených",
                },
                diagnoseAnim = {
                    label = "Animace",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Úplné vyléčení",
                },
                diagnoseGeneral = {
                    label = "Generál",
                },
                doctorNpcAvailability = {
                    label = "Dostupnost",
                },
                doctorNpcGeneral = {
                    label = "Generál",
                },
                doctorNpcHealOther = {
                    label = "Léčit jiné",
                },
                doctorNpcHealSelf = {
                    label = "Vyléčit se",
                },
                doctorNpcRanges = {
                    description = "Tyto rozsahy neurčují, jak blízko musí být hráč, aby otevřel interakci lékaře NPC. Platí pouze po otevření nabídky lékaře.",
                    label = "Rozsahy",
                },
                doctorNpcRevive = {
                    label = "Oživit",
                },
                doctorNpcReviveInBed = {
                    label = "Oživte v posteli",
                },
                firstAidAnimation = {
                    label = "Animace",
                },
                firstAidGeneral = {
                    label = "Generál",
                },
                firstAidLicenseAdd = {
                    label = "Licence Přidat",
                },
                firstAidLicenseRemove = {
                    label = "Licence Odebrat",
                },
                firstAidPosition = {
                    label = "Pozice",
                },
                healthInsuranceExpiration = {
                    label = "Vypršení platnosti",
                },
                healthInsuranceGeneral = {
                    label = "Generál",
                },
                healthInsurancePayment = {
                    label = "Platba",
                },
                healthInsuranceProviders = {
                    label = "Poskytovatelé",
                },
                hospitalBedsBedAnimation = {
                    label = "Animace postele",
                },
                hospitalBedsCreator = {
                    label = "Tvůrce",
                },
                hospitalBedsDistances = {
                    label = "Vzdálenosti",
                },
                hospitalBedsGeneral = {
                    label = "Generál",
                },
                hospitalBedsGetupAnimation = {
                    label = "Animace Getup",
                },
                hospitalBedsModels = {
                    label = "Modelky",
                },
                hospitalBedsOffsets = {
                    label = "Ofsety",
                },
                hospitalBlip = {
                    label = "Nemocnice Blip",
                },
                imagingGeneral = {
                    label = "Generál",
                },
                imagingRanges = {
                    label = "Rozsahy",
                },
                keybinds = {
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                    label = "Klávesové zkratky",
                },
                knockoutGeneral = {
                    label = "Generál",
                },
                knockoutWeapons = {
                    label = "Zbraně",
                },
                medicCarryAttach = {
                    label = "Připojit",
                },
                medicCarryAttachOffsets = {
                    label = "Ofsety",
                },
                medicCarryAttachRotation = {
                    label = "Otáčení",
                },
                medicCarryCarrierAnimation = {
                    label = "Carrier Animace",
                },
                medicCarryGeneral = {
                    label = "Generál",
                },
                medicCarryPassengerAnimation = {
                    label = "Animace pro cestující",
                },
                medicCarryRestrictions = {
                    label = "Omezení",
                },
                medicRevivePersistence = {
                    label = "Generál",
                },
                medicalEvaluationRecipients = {
                    label = "Profese příjemců",
                },
                medicalEvaluationSharing = {
                    label = "Sdílená pole",
                },
                medicalEvaluationTypes = {
                    label = "Typy hodnocení",
                },
                medicalEvaluationsGeneral = {
                    label = "Generál",
                },
                medicalWearablesArmRestrictions = {
                    label = "Omezení sádry na ruce",
                },
                medicalWearablesCasts = {
                    label = "Sádry",
                },
                medicalWearablesDuration = {
                    label = "Doba nošení",
                },
                medicalWearablesGeneral = {
                    label = "Obecné",
                },
                medicalWearablesHeadBandage = {
                    label = "Obvaz hlavy",
                },
                medicalWearablesLegRestrictions = {
                    label = "Omezení sádry na noze",
                },
                medicalWearablesNeckBrace = {
                    label = "Krční límec",
                },
                medicalWearablesOxygenMask = {
                    label = "Kyslíková maska",
                },
                medicalWearablesPatientHud = {
                    label = "HUD pacienta",
                },
                medicalWearablesRemoval = {
                    label = "Odstranění",
                },
                medicalWearablesSplints = {
                    label = "Dlahy",
                },
                medicalWearablesTorsoBandage = {
                    label = "Obvaz trupu",
                },
                minigamesCprGeneral = {
                    label = "Generál",
                },
                minigamesEnabled = {
                    label = "Povoleno",
                },
                minigamesVentilationGeneral = {
                    label = "Generál",
                },
                operationsAnesthesia = {
                    label = "Anestezie",
                },
                operationsDistances = {
                    label = "Vzdálenosti",
                },
                operationsDoctorAnimation = {
                    label = "Animace chirurga",
                },
                operationsGeneral = {
                    label = "Obecné",
                },
                operationsPatientAnimation = {
                    label = "Animace pacienta",
                },
                operationsTrainingAnimation = {
                    label = "Animace výcviku",
                },
                propPlacement = {
                    label = "Umístění rekvizit",
                },
                propPlacementItems = {
                    label = "Prop položky",
                },
                publicTreatmentGeneral = {
                    label = "Generál",
                },
                publicTreatmentJobs = {
                    label = "Povolené úlohy",
                },
                publicTreatmentRequirements = {
                    label = "Požadavky",
                },
                reviveRewardGeneral = {
                    label = "Generál",
                },
                reviveRewardPayment = {
                    label = "Platba",
                },
                selfDiagnoseGeneral = {
                    label = "Generál",
                },
                stretcherAnimation = {
                    label = "Animace",
                },
                stretcherCarryAttach = {
                    label = "Připojit",
                },
                stretcherFolded = {
                    label = "Složená varianta",
                },
                stretcherFoldedPatientAttach = {
                    label = "Složený nástavec pro pacienta",
                },
                stretcherGeneral = {
                    label = "Generál",
                },
                stretcherHelicopter = {
                    label = "Helikoptéra",
                },
                stretcherPatientAttach = {
                    label = "Připojit pacienta",
                },
                stretcherTreatmentAnim = {
                    label = "Animace",
                },
                stretcherVehicleAttach = {
                    label = "Připevnění vozidla",
                },
                stretcherVehicleLists = {
                    label = "Modely vozidel",
                },
                treatmentAnim = {
                    label = "Animace",
                },
                treatmentEnable = {
                    label = "Umožnit",
                },
                trunk = {
                    label = "Kufr",
                },
                vehiclePullGeneral = {
                    label = "Generál",
                },
                wheelchairAssign = {
                    label = "Úkol",
                },
                wheelchairDuration = {
                    label = "Trvání",
                },
                wheelchairGeneral = {
                    label = "Generál",
                },
                wheelchairItems = {
                    label = "Položka",
                },
                wheelchairRestrictions = {
                    label = "Omezení",
                },
                xrayGeneral = {
                    label = "Generál",
                },
                xrayRanges = {
                    label = "Rozsahy",
                },
                appointmentsGeneral = {
                    label = "Generál",
                },
                appointmentsLimits = {
                    label = "Limity",
                },
                appointmentsNotifications = {
                    label = "Oznámení",
                },
                appointmentsScheduling = {
                    label = "Plánování",
                },
                healthCompatibility = {
                    label = "Zdravotní kompatibilita",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Generál",
                },
                minigamesRandomization = {
                    label = "Náhodná úprava",
                },
            },
            settingSections = {
                billing = "Fakturace",
                bodyBag = "Vak na tělo",
                damageHandling = "Zpracování poškození",
                death = "Smrt",
                deathScreen = "Obrazovka smrti",
                diagnose = "Diagnostikovat",
                doctorNpc = "Doktor NPC",
                general = "Generál",
                healthInsurance = "zdravotní pojištění",
                hospitalBeds = "Nemocniční lůžka",
                knockout = "Knokaut",
                medicCarry = "Medik Carry",
                minigames = "Minihry",
                mobilityAid = "Mobilní pomůcky",
                operations = "Operace",
                organization = "Organizace",
                rewards = "Odměny",
                treatment = "Zacházení",
                vehiclePull = "Tah vozidla",
            },
            settingSubsections = {
                aiMedic = "AI Medik",
                anesthesia = "Anestezie",
                animation = "Animace",
                animations = "Animace",
                attach = "Připojit",
                bedAnimation = "Animace postele",
                blood = "Krev",
                bodyBagDeliveryReward = "Odměna za doručení tělesné tašky",
                carrierAnimation = "Carrier Animace",
                classification = "Klasifikace",
                cpr = "CPR",
                crutch = "Berle",
                deathInjuries = "Smrtelná zranění",
                deathScreenStyle = "Styl obrazovky smrti",
                deathTimeout = "Časový limit smrti",
                delivery = "Dodání",
                diagnoseAnim = "Diagnostikujte animaci",
                dispatch = "Odeslat",
                earlyRespawn = "Brzy Respawn",
                effects = "Efekty",
                firstAid = "První pomoc",
                general = "Generál",
                getupAnimation = "Animace Getup",
                imaging = "Zobrazování",
                information = "Informace",
                keybinds = "Klávesové zkratky",
                liveDamage = "Živé poškození",
                logs = "Záznamy",
                medicRevivePersistence = "Medic Revive Perzistence",
                medicalEvaluations = "Lékařské posudky",
                medicalWearables = "Zdravotní pomůcky",
                medications = "Léky",
                minigame = "Minihra",
                passengerAnimation = "Animace pro cestující",
                pricing = "Ceny",
                propPlacement = "Umístění rekvizit",
                publicTreatment = "Veřejné zacházení",
                respawn = "Respawn předseda",
                reviveInBed = "Oživte v posteli",
                reviveReward = "Oživit odměnu",
                selfDiagnose = "Samodiagnostika",
                stretcher = "Nosítka",
                stretcherTreatmentAnim = "Animace ošetření nosítky",
                thresholds = "Prahové hodnoty",
                treatmentAnim = "Léčba animace",
                trunk = "Kufr",
                vehicleImpact = "Náraz vozidla",
                ventilation = "Větrání",
                wheelchair = "Invalidní vozík",
                xray = "X-ray",
                appointments = "Schůzky",
                bloodTransfusion = "Krevní transfuze",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor · Ovládání 172",
                    description = "Nastavuje: Editor: Move up.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor · Ovládání 173",
                    description = "Nastavuje: Editor: Move down.",
                },
                ambulanceEditorControl174 = {
                    label = "Editor · Ovládání 174",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl175 = {
                    label = "Editor · Ovládání 175",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl177 = {
                    label = "Editor · Ovládání 177",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl201 = {
                    label = "Editor · Ovládání 201",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl202 = {
                    label = "Editor · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl21 = {
                    label = "Editor · Ovládání 21",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl32 = {
                    label = "Editor · Ovládání 32",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl33 = {
                    label = "Editor · Ovládání 33",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl34 = {
                    label = "Editor · Ovládání 34",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl35 = {
                    label = "Editor · Ovládání 35",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl36 = {
                    label = "Editor · Ovládání 36",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl37 = {
                    label = "Editor · Ovládání 37",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl38 = {
                    label = "Editor · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceEditorControl44 = {
                    label = "Editor · Ovládání 44",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceFirstAidControl38 = {
                    label = "První pomoc · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interakce · Ovládání 177",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interakce · Ovládání 201",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interakce · Ovládání 202",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interakce · Ovládání 21",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interakce · Ovládání 241",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interakce · Ovládání 242",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interakce · Ovládání 25",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interakce · Ovládání 32",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interakce · Ovládání 33",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interakce · Ovládání 34",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interakce · Ovládání 35",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interakce · Ovládání 36",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interakce · Ovládání 38",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interakce · Ovládání 44",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                billingAccount = {
                    description = "Starší záložní účet společnosti používaný pro fakturaci.",
                    label = "Účet",
                },
                billingCloseOnSuccess = {
                    description = "Po úspěšném vyúčtování automaticky zavřete uživatelské rozhraní fakturace.",
                    label = "Blízko úspěchu",
                },
                billingCurrency = {
                    description = "Volitelný měnový klíč používaný pro fakturační platby.",
                    label = "Měna",
                },
                billingCustomBillingReasons = {
                    description = "Umožněte lékařům zadat vlastní fakturační důvody.",
                    label = "Vlastní důvody",
                },
                billingDepositToSociety = {
                    description = "Vložit příjmy z fakturace na účet společnosti.",
                    label = "Vklad do společnosti",
                },
                billingEnabled = {
                    description = "Povolit lékařský fakturační systém.",
                    label = "Povoleno",
                },
                billingMaxReasonLength = {
                    description = "Maximální délka vlastních fakturačních důvodů.",
                    label = "Maximální délka důvodu",
                },
                billingMode = {
                    description = "Vyberte si, zda se účty za lékařskou péči účtují okamžitě, vyžadují potvrzení nebo použijte rámcový fakturační systém.",
                    label = "Režim účtování",
                    options = {
                        consent = "Zaplaťte nebo odmítněte",
                        framework = "Rámcový návrh zákona",
                        instant = "Okamžité nabití",
                    },
                },
                billingRange = {
                    description = "Maximální rozsah pro nalezení zúčtovatelných pacientů.",
                    label = "Rozsah",
                },
                billingReasonPresets = {
                    description = "Přednastavené důvody fakturace zobrazené v uživatelském rozhraní fakturace.",
                    itemLabel = "Důvod",
                    label = "Předvolby důvodu",
                },
                billingRefreshSeconds = {
                    description = "Sekundy mezi aktualizacemi účtovaného hráče.",
                    label = "Obnovit sekundy",
                },
                bladeWeapons = {
                    description = "Názvy zbraní nebo hashe, které by měly být klasifikovány jako poškození nožem místo tupého.",
                    itemLabel = "Zbraň",
                    label = "Čepelové zbraně",
                },
                bleedingBlacklist = {
                    description = "Zbraně, které by nikdy neměly způsobit živé krvácení nebo otevřené rány.",
                    itemLabel = "Zbraň",
                    label = "Černá listina krvácení",
                },
                bleedingClassesProfiles = {
                    description = "Profily závažnosti krvácení a jejich ztráta krve.",
                    label = "Kurzy krvácení",
                },
                bloodSystemDebugLogInterval = {
                    description = "Vteřiny mezi zprávami protokolu ladění krevního systému.",
                    label = "Interval protokolu ladění",
                },
                bloodSystemMaxVolume = {
                    description = "Maximální hodnota objemu krve používaná systémem stavu pacienta.",
                    label = "Maximální hlasitost",
                },
                bloodSystemRegenPerSecond = {
                    description = "Pasivní regenerace krve se aplikuje, když pacient aktivně nekrvácí.",
                    label = "Regenerace za sekundu",
                },
                bloodSystemTickIntervalMs = {
                    description = "Interval zatržení serveru používaný pro aktualizace ztráty krve a obnovení.",
                    label = "Interval tikání ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Práh objemu krve, pod kterým pacient upadá do bezvědomí.",
                    label = "Nevědomý práh",
                },
                bodyBagAnimationDict = {
                    description = "Animační slovník používaný pro nošení tašky na tělo.",
                    label = "Animační slovník",
                },
                bodyBagAnimationEnabled = {
                    description = "Při přenášení tašky na tělo použijte speciální animaci nošení.",
                    label = "Povoleno",
                },
                bodyBagAnimationFlag = {
                    description = "Příznak TaskPlayAnim používaný pro animaci přenosu.",
                    label = "Vlajka animace",
                },
                bodyBagAnimationName = {
                    description = "Animační klip používaný k nošení tašky na tělo.",
                    label = "Název animace",
                },
                bodyBagAttachBone = {
                    description = "Název kosti nebo ID kosti používané pro připevnění vaku na tělo.",
                    label = "Kost",
                },
                bodyBagAttachRx = {
                    description = "Připevnění vaku na tělo X rotace.",
                    label = "Připojte RX",
                },
                bodyBagAttachRy = {
                    description = "Připevnění vaku na tělo Y rotace.",
                    label = "Připojte RY",
                },
                bodyBagAttachRz = {
                    description = "Připevnění vaku na tělo Z rotace.",
                    label = "Připojte RZ",
                },
                bodyBagAttachX = {
                    description = "Připevnění vaku na tělo X posunuté.",
                    label = "Připojit X",
                },
                bodyBagAttachY = {
                    description = "Připevnění vaku na tělo Y offset.",
                    label = "Připojte Y",
                },
                bodyBagAttachZ = {
                    description = "Připevnění vaku na tělo Z offset.",
                    label = "Připojit Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Místní klíč používaný pro výzvu nápovědy k odevzdání vaku na tělo.",
                    label = "Klíč štítku nápovědy",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Vzdálenost použitá pro ověření shození tělesného vaku.",
                    label = "Interaktivní vzdálenost",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Kontrolní ID používané pro interakce s odložením tělesného vaku.",
                    label = "Interaktivní klíč",
                },
                bodyBagDeliveryInteraction = {
                    description = "Klíč šablony interakce používaný pro odevzdání vaků na tělo.",
                    label = "Šablona interakce",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Vyžadujte, aby zdravotníci odevzdali vaky na těla na nakonfigurovaných místech odevzdání.",
                    label = "Vyžadovat odvoz",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Vyžadujte, aby byli zdravotníci ve službě před dodáním vaku na tělo.",
                    label = "Vyžadovat ve službě",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Primární klíč účtu používaný pro odměny za doručení zavazadel.",
                    label = "Účet",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Primární typ účtu používaný pro odměny za doručení zavazadel.",
                    label = "Typ účtu",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Částka odměny vyplacená za doručení vaku na tělo.",
                    label = "Množství",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Volitelný vlastní měnový klíč používaný pro odměny za doručení zavazadel.",
                    label = "Měna",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Zaplaťte nakonfigurovanou odměnu po dokončení doručení vaku na tělo.",
                    label = "Povoleno",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Než zaplatíte zdravotníkovi, odečtěte odměny za doručení vaků od společnosti sdílené práce.",
                    label = "Platit od společnosti",
                },
                bodyBagEnabled = {
                    description = "Aktivujte systém vaků na tělo.",
                    label = "Povoleno",
                },
                bodyBagHidePatient = {
                    description = "Skryjte pacienta ped, zatímco je připojen vak na tělo.",
                    label = "Skrýt pacienta",
                },
                bodyBagModel = {
                    description = "Prop model používaný pro vaky na tělo.",
                    label = "Vzor",
                },
                bodyBagPatientAlpha = {
                    description = "Alfa se aplikovala na pacienta, když byl v pytlích.",
                    label = "Alfa pacienta",
                },
                crutchAssignMaxDistance = {
                    description = "Maximální vzdálenost pro přidělení berle jinému hráči.",
                    label = "Přiřaďte maximální vzdálenost",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Automaticky vybavit berličku, když vyprší úkol.",
                    label = "Automatické odbavení po vypršení platnosti",
                },
                crutchClipset = {
                    description = "Pohybový klips aplikovaný při používání berle.",
                    label = "Zatmění",
                },
                crutchDefaultDurationMinutes = {
                    description = "Výchozí přiřazená doba trvání berličky v minutách.",
                    label = "Výchozí doba trvání",
                },
                crutchDisableSprint = {
                    description = "Blokový sprint s osazenou berlí.",
                    label = "Zakázat sprint",
                },
                crutchDisableWeapons = {
                    description = "Blokujte použití zbraně, když je vybavena berlou.",
                    label = "Zakázat zbraně",
                },
                crutchItemName = {
                    description = "Položka inventáře použitá pro berličku.",
                    label = "Název položky",
                },
                crutchMaxDurationMinutes = {
                    description = "Maximální povolená doba trvání přiřazení berličky v minutách.",
                    label = "Maximální doba trvání",
                },
                crutchMinDurationMinutes = {
                    description = "Minimální povolená doba trvání přidělení o berlích v minutách.",
                    label = "Min. trvání",
                },
                crutchProp = {
                    description = "Prop model použitý pro berle.",
                    label = "Podpěra",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekundy, po které se jednotlivé zásahy shromažďují do jedné zprávy.",
                    label = "Interval dávky",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Maximální počet jednotlivých zásahů v jedné zprávě Discordu.",
                    label = "Zásahů ve zprávě",
                },
                damageLogsEnabled = {
                    description = "Odesílat serverem potvrzené nesmrtící zásahy hráčů na Discord.",
                    label = "Záznamy poškození",
                },
                deathAnimalAnimationDictionary = {
                    description = "Animační slovník používaný pro animaci zpětné smrti zvířat.",
                    label = "Slovník zvířat",
                },
                deathAnimalAnimationName = {
                    description = "Animační klip použitý pro animaci nouzové smrti zvířete.",
                    label = "Název zvířecí animace",
                },
                deathAnimalUseAnimation = {
                    description = "Umožněte nakonfigurovanému nouzovému zvířeti použít naskriptovanou animaci smrti.",
                    label = "Animace zvířat",
                },
                deathAnimationDictionary = {
                    description = "Animační slovník používaný pro výchozí animaci smrti.",
                    label = "Animační slovník",
                },
                deathAnimationName = {
                    description = "Animační klip použitý pro výchozí animaci smrti.",
                    label = "Název animace",
                },
                deathInjuriesProfiles = {
                    description = "Profily zranění se použijí, když hráč zemře z konkrétní příčiny.",
                    itemLabel = "Zranění",
                    label = "Smrtelná zranění",
                },
                deathModels = {
                    description = "Přepsat chování animace smrti podle modelu ped nebo modelu hash.",
                    label = "Přepisy modelu",
                },
                deathScreenAiMedicAccount = {
                    description = "Primární účet účtovaný za zdravotníka AI.",
                    label = "Účet",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Sekundy přidané do časovače krvácení, když je požádán lékař AI.",
                    label = "Přidejte časovač smrti",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Umožněte zdravotníkovi AI oživit smrtelná zranění.",
                    label = "Povolit smrtelné rány",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Vzdálenost, na které se zdravotník AI zastaví a přiblíží pěšky.",
                    label = "Vzdálenost přiblížení",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Cooldown, než bude možné znovu zavolat zdravotníka AI.",
                    label = "Cooldown sekundy",
                },
                deathScreenAiMedicCurrency = {
                    description = "Volitelný měnový klíč používaný pro platby zdravotníků AI.",
                    label = "Měna",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Formátovač měn používaný pro platby zdravotníků AI.",
                    label = "Formátovač měn",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Sekundy předtím, než se medik AI po dokončení spustí.",
                    label = "Despawn zpoždění",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Zpoždění, než začne vysílání AI medika.",
                    label = "Zpoždění odeslání",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Rychlost jízdy používaná AI medikem.",
                    label = "Rychlost jízdy",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Maximální doba jízdy, než se spustí nucené oživení.",
                    label = "Časový limit jízdy",
                },
                deathScreenAiMedicEnabled = {
                    description = "Povolte záchranný tok AI medika.",
                    label = "Povoleno",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Záložní účet používaný, když primární účet zdravotníka AI nemá dostatek prostředků.",
                    label = "Záložní účet",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Vynuťte oživení, pokud AI medik nemůže dosáhnout hráče.",
                    label = "Vynutit oživení povoleno",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "AI medik funguje pouze tehdy, když jsou zdravotníci ve službě na tomto počtu nebo pod ním.",
                    label = "Max medici online",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Maximální doba trvání mise před aktivací silového oživení.",
                    label = "Časový limit mise",
                },
                deathScreenAiMedicPedModel = {
                    description = "Model Ped používaný pro AI medika.",
                    label = "Model Ped",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Cíl použitý, když si zraněný hráč zavolá AI medika.",
                    label = "Cíl žádosti hráče",
                    options = {
                        hospital = "Nemocnice",
                        location = "Aktuální poloha",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Cena účtovaná za volání zdravotníka AI.",
                    label = "Cena",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Počet sekund od smrti hráče, než může zdravotník nabídnout vzdáleného AI medika.",
                    label = "Čekání na vzdálené vyslání",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Umožněte medikům poslat medika AI sestřelenému hráči z mapy odeslání a příkazu /aimedic.",
                    label = "Vzdálená expedice",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Vzdálené odesílání zdravotníků AI funguje pouze tehdy, když jsou zdravotníci ve službě na tomto počtu nebo pod ním.",
                    label = "Vzdálené odeslání max mediků online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Cíl použitý po odeslání a přijetí vzdáleného AI medika.",
                    label = "Cíl vzdáleného vyslání",
                    options = {
                        hospital = "Nemocnice",
                        location = "Aktuální poloha",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Počet sekund, během kterých může hráč přijmout nabídku vzdáleného AI medika.",
                    label = "Časový limit vzdálené nabídky",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Požadovaná vzdálenost, než medik AI začne oživovat.",
                    label = "Oživte vzdálenost",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Vteřiny strávené oživováním hráče.",
                    label = "Oživte trvání",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleportujte hráče na nemocniční lůžko namísto oživování na místě.",
                    label = "Oživte se v posteli",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Vyhledávací rádius používaný k nalezení oživovací postele.",
                    label = "Poloměr vyhledávání postele",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Sekundy po smrti, než bude AI medik dostupný.",
                    label = "Sekundy do dostupnosti",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Maximální poloměr spawnování AI medika.",
                    label = "Poloměr spawn max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Minimální rádius spawn medika AI.",
                    label = "Poloměr potěru min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Model vozidla používaný zdravotníkem AI.",
                    label = "Model vozidla",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Hlasový režim v bezvědomí: žádný, poslech nebo plný.",
                    label = "Hlasový režim",
                    options = {
                        full = "plný",
                        listen = "poslouchat",
                        none = "žádný",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Kontrolujte ID, která zůstanou zapnutá, když jste v bezvědomí.",
                    label = "Povolené kontroly",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Automaticky respawnovat hráče, pokud časovač krvácení již vypršel při odpojení.",
                    label = "Platnost automatického obnovení vypršela a znovu se připojte",
                },
                deathScreenBackgroundEnd = {
                    description = "Koncová barva pozadí obrazovky smrti.",
                    label = "Konec pozadí",
                },
                deathScreenBackgroundStart = {
                    description = "Počáteční barva pozadí obrazovky smrti.",
                    label = "Začátek na pozadí",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Sekundy před vypršením časovače propouštění.",
                    label = "Časovač krvácení",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimenze, kde je blokován tok respawnu obrazovky smrti.",
                    label = "Blokované rozměry",
                },
                deathScreenBorderColor = {
                    description = "Barva ohraničení použitá na obrazovce smrti.",
                    label = "Barva ohraničení",
                },
                deathScreenDispatchEnabled = {
                    description = "Odešlete události odeslání z toku obrazovky smrti.",
                    label = "Odesílání povoleno",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Náhradní příjemci, pokud žádný hlavní příjemce není naživu a ve službě. Ponechte prázdné pro vždy stejné hlavní příjemce.",
                    itemLabel = "Zaměstnání",
                    label = "Záložní zaměstnání",
                },
                deathScreenDispatchJobs = {
                    description = "Práce upozorněné, když hráč v bezvědomí požádá o pomoc.",
                    itemLabel = "Práce",
                    label = "Upozorněné práce",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Primární účet účtován za předčasné znovuzrození.",
                    label = "Účet",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Mějte k dispozici brzký respawn i pro smrtelná zranění.",
                    label = "Povolit smrtelné rány",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Volitelný měnový klíč používaný pro včasné respawnové platby.",
                    label = "Měna",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Formátovač měn používaný pro platby za předčasné respawn.",
                    label = "Formátovač měn",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Povolit placené předčasné respawn.",
                    label = "Povoleno",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Záložní účet používaný, když primární účet nemá dostatek prostředků.",
                    label = "Záložní účet",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Volitelný štítek zobrazený pro platbu za předčasné respawn.",
                    label = "Platební štítek",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Cena účtovaná za předčasný respawn.",
                    label = "Cena",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Včasné znovuzrození povolte pouze tehdy, když nejsou ve službě žádní zdravotníci.",
                    label = "Nevyžadují žádné mediky",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Sekundy po smrti, než bude k dispozici brzký respawn.",
                    label = "Sekundy do dostupnosti",
                },
                deathScreenEnableKeyboard = {
                    description = "Povolit použití klávesnice na obrazovce smrti.",
                    label = "Povolit klávesnici",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Externí hlasový backend pro ztlumení, když je povoleno.",
                    label = "Externí hlasový systém",
                    options = {
                        saltychat = "saltychat",
                        yaca = "YacaCity in Germany",
                    },
                },
                deathScreenFocusKey = {
                    label = "Ovládání myší na obrazovce smrti",
                    description = "Výchozí klávesa FiveM, např. E, F6 nebo MOUSE_BUTTON:MOUSE_RIGHT. Prázdná hodnota znamená žádnou výchozí klávesu. Hráči mohou měnit přiřazení v nastavení FiveM; uložená osobní přiřazení zůstanou zachována.",
                },
                deathScreenHandlingMode = {
                    description = "Použije statickou animaci smrti nebo zachová přirozenou ragdoll fyziku, dokud se tělo neustálí.",
                    label = "Zpracování smrti",
                    options = {
                        natural = "Přirozené",
                        static = "Statické",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Skryje obrazovku smrti poté, co MEZERNÍK přepne na ovládání hry; vypnutím zachováte původní viditelný překryv.",
                    label = "Skrýt překryv při ovládání hry",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Výškový posun aplikovaný na cíl ostření kamery.",
                    label = "Výška zaostření",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Náhled zorného pole kamery.",
                    label = "Zorné pole",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Odsazení směru používané při umístění kamery náhledu.",
                    label = "Odsazení nadpisu",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Výškový posun použitý na kameru náhledu.",
                    label = "Výška kamery",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Rozteč aplikovaná na kameru náhledu.",
                    label = "Rozteč",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Vzdálenost od kamery náhledu k bodu spawn.",
                    label = "Poloměr kamery",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Při otevírání kamery pro výběr nemocnice použijte plynulý přechod.",
                    label = "Hladký přechod",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Umožněte hráčům vybrat si nemocnici před znovuzrozením.",
                    label = "Výběr nemocnice",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Výběr nemocnice zobrazit pouze v případě, že existuje více než jedna nemocnice.",
                    label = "Vyžaduje více nemocnic",
                },
                deathScreenInformationEnabled = {
                    description = "Ukažte informační blok na obrazovce smrti.",
                    label = "Povoleno",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Ukažte příčinu smrti v informačním bloku obrazovky smrti.",
                    label = "Ukaž příčinu smrti",
                },
                deathScreenInformationShowInjuries = {
                    description = "Zobrazit zranění v informačním bloku obrazovky smrti.",
                    label = "Ukaž zranění",
                },
                deathScreenInformationShowKiller = {
                    description = "Ukažte jméno vraha v informačním bloku obrazovky smrti.",
                    label = "Ukaž vraha",
                },
                deathScreenInformationShowWeapon = {
                    description = "Ukažte zbraň v informačním bloku obrazovky smrti.",
                    label = "Ukaž zbraň",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangy na bílé listině",
                    description = "Vyberte interní názvy gangů nebo nezávislých organizací. Shoda práce nebo gangu udělí oprávnění nebo výjimku. Povinná služba platí pouze pro práce.",
                    itemLabel = "Gang",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Úkolům bylo umožněno vidět informace o rozšířené obrazovce smrti.",
                    itemLabel = "Práce",
                    label = "Práce na seznamu povolených",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Maximální počet sekund pro nahrání každého snímku úmrtí.",
                    label = "Časový limit snímku",
                },
                deathScreenLogScreenshots = {
                    description = "Po textovém záznamu nahrát pohled oběti a potvrzeného zabijáka.",
                    label = "Snímky obrazovky",
                },
                deathScreenLogsEnabled = {
                    description = "Při každém úmrtí hráče odeslat záznam na Discord.",
                    label = "Záznamy úmrtí",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Vzdálenost v metrech používaná k počítání zdravotníka jako blízkého.",
                    label = "Lékař v blízkém okruhu",
                },
                deathScreenMinigameEnabled = {
                    description = "Povolte minihru na obrazovce smrti.",
                    label = "Povoleno",
                },
                deathScreenMinigameUrl = {
                    description = "Otevřená adresa URL pro minihru s obrazovkou smrti.",
                    label = "URL minihry",
                },
                deathScreenMode = {
                    description = "Použije vestavěnou obrazovku smrti nebo externí integraci.",
                    label = "Režim obrazovky",
                    options = {
                        external = "Externí",
                        internal = "Interní",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Ztlumte externí hlasové systémy, když je přehrávač mrtvý.",
                    label = "Ztlumit externí hlas",
                },
                deathScreenMutedTextColor = {
                    description = "Ztlumená barva textu použitá na obrazovce smrti.",
                    label = "Ztlumená barva textu",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Vypisuje podrobné důvody na klientovi a serveru, dokud tělo zůstává v ragdollu.",
                    label = "Ladění přirozeného ragdollu",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Automaticky stabilizuje nehybné tělo po přirozené smrti, nebo vyžaduje zdravotníka ve službě, který pacienta uloží do stabilizované polohy.",
                    label = "Přirozená stabilizace",
                    options = {
                        automatic = "Automaticky",
                        medic = "Vyžadován zdravotník",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Barva pozadí panelu použitá na obrazovce smrti.",
                    label = "Pozadí panelu",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Zablokujte automatické znovuzrození po úniku.",
                    label = "Zabránit automatickému obnovení",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Blokujte auto-respawn, když je medik nablízku.",
                    label = "Blokujte, když je lékař poblíž",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Blok se obnoví po vypršení časovače propouštění.",
                    label = "Zabraňte oživení po uplynutí doby platnosti",
                },
                deathScreenPrimaryColor = {
                    description = "Základní barva CSS použitá pro motiv obrazovky smrti.",
                    label = "Základní barva",
                },
                deathScreenPrimaryDark = {
                    description = "Volitelná tmavší akcentní barva pro obrazovku smrti.",
                    label = "Primární tmavé",
                },
                deathScreenPrimaryStrong = {
                    description = "Volitelná silnější akcentní barva pro obrazovku smrti.",
                    label = "Primárně silný",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Kurz se používá, když stanice nemá definovaný kurz.",
                    label = "Výchozí nadpis",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Záložní respawnové záhlaví se používá, když neexistují žádné nemocniční pozice.",
                    label = "Záložní nadpis",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Záložní respawn X souřadnice se používá, když neexistují žádné nemocniční pozice.",
                    label = "Záložní X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Souřadnice Y záložního respawnu se používá, když neexistují žádné pozice v nemocnici.",
                    label = "Záložní Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Záložní respawn Z souřadnice se používá, když neexistují žádné pozice nemocnice.",
                    label = "Záložní Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Vyberte si pevnou nemocnici pro respawny. Nechte jej prázdný, abyste mohli použít nejbližší nemocnici.",
                    label = "Respawn nemocnice",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Odstraňte zůstatky na účtu při respawnu.",
                    label = "Odebrat účty",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Názvy účtů odstraněny při respawnu.",
                    itemLabel = "Účet",
                    label = "Názvy účtů",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Odstraňte položky inventáře při respawnu.",
                    label = "Odstraňte položky",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Předměty inventáře uchovávané při respawnu.",
                    itemLabel = "Položka",
                    label = "Ignorované položky",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Odstraňte zbraně z kola zbraně při respawnu.",
                    label = "Odstraňte zbraně",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Zbraně držené při respawnu.",
                    itemLabel = "Zbraň",
                    label = "Ignorované zbraně",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleportujte hráče do nemocnice při respawnu.",
                    label = "Teleportujte se do nemocnice",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Obnovte časovač spouštění po opětovném připojení namísto jeho resetování.",
                    label = "Obnovit při opětovném připojení",
                },
                deathScreenShadowLight = {
                    description = "Barva měkkého stínu použitá na obrazovce smrti.",
                    label = "Stínové světlo",
                },
                deathScreenShadowMid = {
                    description = "Barva středního stínu použitá na obrazovce smrti.",
                    label = "Stín uprostřed",
                },
                deathScreenShowNearestMedic = {
                    description = "Ukažte nejbližšímu lékaři na obrazovce smrti.",
                    label = "Ukažte nejbližšího lékaře",
                },
                deathScreenTextColor = {
                    description = "Primární barva textu použitá na obrazovce smrti.",
                    label = "Barva textu",
                },
                deathScreenTextShadow = {
                    description = "Barva stínu textu použitá na obrazovce smrti.",
                    label = "Textový stín",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Použijte časový limit smrti po oživení knockoutu.",
                    label = "Aplikujte při vyřazení",
                },
                deathTimeoutSeconds = {
                    description = "Sekundy po oživení zůstane boj deaktivován.",
                    label = "Sekundy",
                },
                deathTimeoutShowUi = {
                    description = "Zobrazovat banner odpočítávání časového limitu smrti, když je aktivní.",
                    label = "Zobrazit uživatelské rozhraní",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangy na bílé listině",
                    description = "Vyberte interní názvy gangů nebo nezávislých organizací. Shoda práce nebo gangu udělí oprávnění nebo výjimku. Povinná služba platí pouze pro práce.",
                    itemLabel = "Gang",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Úlohy vyňaté z omezení časového limitu smrti.",
                    itemLabel = "Práce",
                    label = "Práce na seznamu povolených",
                },
                deathUseAnimation = {
                    description = "Přehrajte si nakonfigurovanou animaci smrti pro podporované pedy.",
                    label = "Použijte animaci",
                },
                diagnoseAnimClip = {
                    description = "Animační klip použitý při otevírání diagnostiky. Chcete-li místo toho použít scénář, ponechte prázdné.",
                    label = "Název animace",
                },
                diagnoseAnimDict = {
                    description = "Animační slovník používaný při otevírání diagnózy. Chcete-li místo toho použít scénář, ponechte prázdné.",
                    label = "Animační slovník",
                },
                diagnoseAnimScenario = {
                    description = "Scénář použitý při otevírání diagnostiky. Chcete-li místo toho použít příkaz dict + clip, ponechte prázdné.",
                    label = "Scénář",
                },
                diagnoseCprAnimDict = {
                    description = "Animační slovník používaný pro KPR.",
                    label = "Animační slovník",
                },
                diagnoseCprAnimName = {
                    description = "Animační klip používaný pro KPR.",
                    label = "Název animace",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Doba nepřerušené diagnostiky před zobrazením úplného vyléčení.",
                    label = "Prodleva v sekundách",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Vyžadovat záchranářský batoh",
                    description = "Pro zobrazení levé lišty vyšetřovacích nástrojů vyžadovat rescue_backpack. Po vypnutí se lišta zobrazuje vždy; požadavky jednotlivých nástrojů na předměty zůstávají v platnosti.",
                },
                diagnoseFullHealEnabled = {
                    description = "Povolí úplné vyléčení po nepřerušené diagnostice.",
                    label = "Povoleno",
                },
                diagnoseInteractDistance = {
                    description = "Maximální vzdálenost potřebná k diagnóze nebo uložení pacienta do vaku.",
                    label = "Interaktivní vzdálenost",
                },
                diagnosePatientMovementMode = {
                    label = "Pohyb pacienta",
                    description = "Znehybněte pacienta, dokud má jiný hráč otevřenou nabídku ošetření, nebo povolte pohyb a zavřete nabídku při překročení vzdálenosti ošetření. Vlastní diagnostika se nastavuje samostatně.",
                    options = {
                        freeze = "Znehybnit pacienta",
                        distance = "Zavřít při překročení vzdálenosti",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Vzdálenost ošetření (m)",
                    description = "Maximální vzdálenost mezi ošetřujícím hráčem a pacientem, po jejímž překročení se nabídka v režimu vzdálenosti zavře. Vzdálenost pro otevření se nastavuje samostatně.",
                },
                diagnoseKey = {
                    description = "ID kontroly používané pro diagnostiku interakcí.",
                    label = "Interaktivní klíč",
                },
                diagnoseOpenDelayMs = {
                    description = "Zpoždění, než se otevře diagnostické uživatelské rozhraní.",
                    label = "Zpoždění otevření ms",
                },
                diagnosePromptDistance = {
                    description = "Vzdálenost použitá k zobrazení výzvy k diagnóze.",
                    label = "Okamžitá vzdálenost",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Doba trvání animací ošetření.",
                    label = "Délka léčby ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Při přímém účtování vkládejte platby lékaře na sdílený účet společnosti.",
                    label = "Přidejte příjmy společnosti",
                },
                doctorNpcEnabled = {
                    description = "Povolte službu NPC lékaře.",
                    label = "Povoleno",
                },
                doctorNpcHealOtherAccount = {
                    description = "Primární klíč účtu používaný k účtování léčení jiného hráče.",
                    label = "Účet",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Primární typ účtu používaný k účtování léčení jiného hráče.",
                    label = "Typ účtu",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Volitelný klíč vlastní měny používaný k účtování léčení jiného hráče.",
                    label = "Měna",
                },
                doctorNpcHealOtherPrice = {
                    description = "Cena za uzdravení jiného hráče u lékaře NPC.",
                    label = "Cena",
                },
                doctorNpcHealSelfAccount = {
                    description = "Primární klíč účtu používaný k účtování self-heal.",
                    label = "Účet",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Primární typ účtu používaný k účtování samoléčení.",
                    label = "Typ účtu",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Volitelný klíč vlastní měny používaný k účtování samoléčení.",
                    label = "Měna",
                },
                doctorNpcHealSelfPrice = {
                    description = "Cena za uzdravení u lékaře NPC.",
                    label = "Cena",
                },
                doctorNpcInteractionRange = {
                    description = "Jak blízko musí uživatel zůstat od NPC lékaře při používání otevřené nabídky lékaře. Toto nemění počáteční vzdálenost výzvy NPC.",
                    label = "Interakční rozsah",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Doctor NPC funguje pouze tehdy, když jsou zdravotníci ve službě pod tímto limitem.",
                    label = "Max medici online",
                },
                doctorNpcPatientRange = {
                    description = "Jak blízko musí být pacient k lékaři NPC, aby mohl léčit jiné nebo oživit, aby fungoval po výběru akce.",
                    label = "Rozsah pacientů",
                },
                doctorNpcPaymentMode = {
                    description = "Nabijte hráče okamžitě nebo pošlete fakturu.",
                    label = "Platební režim",
                    options = {
                        bill = "účtovat",
                        remove = "odstranit",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Používá se pouze pro seznam blízkých hráčů v uživatelském rozhraní NPC lékaře. Samo o sobě léčbu neumožňuje.",
                    label = "Rozsah skenování přehrávače",
                },
                doctorNpcReviveAccount = {
                    description = "Primární klíč účtu používaný k účtování lékařských oživení.",
                    label = "Účet",
                },
                doctorNpcReviveAccountType = {
                    description = "Primární typ účtu používaný k účtování lékařských oživení.",
                    label = "Typ účtu",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Umožní lékaři NPC oživit pacienty se smrtelnými nebo neoživitelnými zraněními. Po vypršení doby vykrvácení zůstává oživení zablokováno.",
                    label = "Povolit smrtelná zranění",
                },
                doctorNpcReviveCurrency = {
                    description = "Volitelný vlastní měnový klíč používaný k účtování lékařských oživení.",
                    label = "Měna",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Po oživení lékaře umístěte oživené hráče na nejbližší nemocniční lůžko.",
                    label = "Povoleno",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Maximální vzdálenost použitá k nalezení blízkého nemocničního lůžka pro oživení lékaře.",
                    label = "Vyhledávací okruh",
                },
                doctorNpcRevivePrice = {
                    description = "Cena za oživení hráče u lékaře NPC.",
                    label = "Cena",
                },
                firstAidActionDurationMs = {
                    description = "Jak dlouho trvá zásah první pomoci.",
                    label = "Doba trvání akce ms",
                },
                firstAidAnimationDict = {
                    description = "Animační slovník používaný během akce první pomoci.",
                    label = "Animační slovník",
                },
                firstAidAnimationFlag = {
                    description = "Příznak TaskPlayAnim použitý během akce první pomoci.",
                    label = "Vlajka animace",
                },
                firstAidAnimationName = {
                    description = "Animační klip použitý během akce první pomoci.",
                    label = "Název animace",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Sekundy přidané do časovače krvácení pacienta po první pomoci.",
                    label = "Sekundy prodloužení krvácení",
                },
                firstAidEnabled = {
                    description = "Povolit funkci první pomoci pro licencované hráče.",
                    label = "První pomoc povolena",
                },
                firstAidLicense = {
                    description = "Název rámcové licence používaný k ověření přístupu první pomoci.",
                    label = "Název licence",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Umožněte personálu záchranné služby vydat průkaz první pomoci.",
                    label = "Přidání licence povoleno",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Zobrazit akci přidání licence v radiální nabídce.",
                    label = "Přidat licenční radiál",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Před použitím akce přidání licence vyžadovat povinnost EMS.",
                    label = "Přidat licenci vyžaduje povinnost",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Umožněte personálu sanitky odebrat průkaz první pomoci.",
                    label = "Odebrání licence povoleno",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Zobrazit akci odebrání licence v radiální nabídce.",
                    label = "Odstraňte licenční radiál",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Před použitím akce odebrání licence vyžadovat povinnost EMS.",
                    label = "Odebrat licenci vyžaduje povinnost",
                },
                firstAidPositionChestOffset = {
                    description = "Odsazení hrudníku používané při vyrovnávání pro první pomoc.",
                    label = "Odsazení hrudníku",
                },
                firstAidPositionSideOffset = {
                    description = "Boční odsazení používané při vyrovnávání pro první pomoc.",
                    label = "Boční odsazení",
                },
                firstAidPositionZOffset = {
                    description = "Vertikální offset používaný při vyrovnávání pro první pomoc.",
                    label = "Offset Z",
                },
                firstAidRequireLicense = {
                    description = "Než hráč může použít první pomoc, vyžadujte nakonfigurovanou licenci první pomoci.",
                    label = "Vyžadovat licenci",
                },
                firstAidTargetDistance = {
                    description = "Maximální povolená vzdálenost pro použití první pomoci.",
                    label = "Cílová vzdálenost",
                },
                healthInsuranceAccount = {
                    description = "Klíč záložního účtu používaný pro platby pojištění.",
                    label = "Účet",
                },
                healthInsuranceAccountType = {
                    description = "Primární typ účtu používaný pro platby pojištění.",
                    label = "Typ účtu",
                },
                healthInsuranceAvailableDays = {
                    description = "Dostupné doby pojištění ve dnech.",
                    label = "Dostupné dny",
                },
                healthInsuranceCommand = {
                    description = "Příkaz chat používaný k otevření uživatelského rozhraní zdravotního pojištění.",
                    label = "Příkaz",
                },
                healthInsuranceCurrency = {
                    description = "Volitelný klíč vlastní měny používaný pro platby pojištění.",
                    label = "Měna",
                },
                healthInsuranceEnabled = {
                    description = "Aktivujte systém zdravotního pojištění.",
                    label = "Povoleno",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Umožní oprávněným zaměstnancům měnit ceny pojištění v tabletu. Vypnutím se vynutí ceny z níže uvedené tabulky poskytovatelů.",
                    label = "Správa cen v tabletu",
                },
                healthInsuranceProviders = {
                    description = "Poskytovatelé pojištění nabízení hráčům.",
                    itemLabel = "Poskytovatel",
                    label = "Poskytovatelé",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Použije stejné poskytovatele a pojistky pro všechny profese registrované v tomto záchranářském prostředku.",
                    label = "Sdílet mezi záchranářskými profesemi",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Zatímco hráč leží na posteli, proběhl ve smyčce animační slovník. Chcete-li použít výchozí záložní animaci smrti, ponechte prázdné.",
                    label = "Animační slovník",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Volitelná manuální doba trvání animace smyčkového lůžka. Používá se pouze v případě, že je nakonfigurována vlastní animace postele.",
                    label = "Doba trvání ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Příznak TaskPlayAnim používaný pro animaci lůžka ve smyčce. Používá se pouze v případě, že je nakonfigurována vlastní animace postele.",
                    label = "Vlajka animace",
                },
                hospitalBedsBedAnimationName = {
                    description = "Zatímco hráč leží na posteli, přehrával se ve smyčce animovaný klip. Chcete-li použít výchozí záložní animaci smrti, ponechte prázdné.",
                    label = "Název animace",
                },
                hospitalBedsBreakDistance = {
                    description = "Vzdálenost, po které je hráč vytlačen z postele.",
                    label = "Zlomová vzdálenost",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Náhled modelu ped použitého v editoru polohy nemocničního lůžka.",
                    label = "Tvůrce modelu ped",
                },
                hospitalBedsEnabled = {
                    description = "Povolit nakonfigurované interakce s nemocničním lůžkem.",
                    label = "Povoleno",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Animovaný slovník se přehraje, když hráč vstane z postele. Chcete-li použít výchozí chování při vstávání, ponechte prázdné.",
                    label = "Animační slovník",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Volitelná manuální doba trvání animace vstávání. Používá se pouze v případě, že je nakonfigurována vlastní animace.",
                    label = "Doba trvání ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Příznak TaskPlayAnim používaný pro animaci spouštění. Používá se pouze v případě, že je nakonfigurována vlastní animace.",
                    label = "Vlajka animace",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animovaný klip se přehraje, když hráč vstane z postele. Chcete-li použít výchozí chování při vstávání, ponechte prázdné.",
                    label = "Název animace",
                },
                hospitalBedsHeadingOffset = {
                    description = "Při umístění přehrávače na postel byl použit posun směru.",
                    label = "Odsazení nadpisu",
                },
                hospitalBedsHeightOffset = {
                    description = "Vertikální posun použitý při umístění přehrávače na postel.",
                    label = "Výškový posun",
                },
                hospitalBedsInteractDistance = {
                    description = "Maximální vzdálenost nutná pro použití nemocničního lůžka.",
                    label = "Interaktivní vzdálenost",
                },
                hospitalBedsInteractKey = {
                    description = "ID kontroly používané pro vstup nebo opuštění nemocničního lůžka.",
                    label = "Interaktivní klíč",
                },
                hospitalBedsModels = {
                    description = "Modely světových objektů zacházené jako použitelná nemocniční lůžka.",
                    itemLabel = "Vzor",
                    label = "Modely postelí",
                },
                hospitalBedsSearchRadius = {
                    description = "Radius se používá k nalezení blízkých rekvizit nebo konfigurovaných postelí.",
                    label = "Vyhledávací okruh",
                },
                hospitalBlipColor = {
                    description = "ID barvy blip používané pro blizky s mapou nemocnice.",
                    label = "Barva",
                },
                hospitalBlipEnabled = {
                    description = "Zobrazit výřezy nemocniční mapy pro nakonfigurované pozice nemocnice.",
                    label = "Povoleno",
                },
                hospitalBlipName = {
                    description = "Záložní název nemocnice blip použitý, když není k dispozici žádný název stanice.",
                    label = "Jméno",
                },
                hospitalBlipScale = {
                    description = "Blip měřítko používané pro bloky nemocničních map.",
                    label = "Měřítko",
                },
                hospitalBlipSprite = {
                    description = "Blip sprite ID používané pro blizky s mapou nemocnice.",
                    label = "Skřítek",
                },
                imagingInteractionRange = {
                    description = "Maximální vzdálenost od zobrazovací stanice pro operátora.",
                    label = "Interakční rozsah",
                },
                imagingPatientRange = {
                    description = "Maximální vzdálenost od zobrazovací stanice pro pacienta.",
                    label = "Rozsah pacientů",
                },
                imagingScanDurationSeconds = {
                    description = "Doba trvání v sekundách pro výsledky skenování CT a MRI.",
                    label = "Délka skenování",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Pouze vizuální multiplikátor pro efekty překrytí krvácení.",
                    label = "Intenzita překrytí krvácení",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Pouze vizuální multiplikátor pro efekty obrazovky bolesti.",
                    label = "Intenzita obrazovky bolesti",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Minimální procento maximální ztráty zdraví při jediném zásahu před aplikací krvácení a bolesti.",
                    label = "Krvácení/bolest min procent",
                },
                injuryThresholdRespectArmor = {
                    description = "Přeskočte krvácení a bolest, když byl zásah absorbován brněním.",
                    label = "Respektujte brnění",
                },
                knockoutRegenerateDamage = {
                    description = "Obnovte poškození knockoutem po vypršení časovače respawnu.",
                    label = "Regenerovat poškození",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Vteřiny, během kterých se poškození knockoutem vyléčí zpět.",
                    label = "Doba regenerace",
                },
                knockoutRespawnSeconds = {
                    description = "Sekundy před automatickým respawnem, když je hráč vyřazen.",
                    label = "Respawn sekund",
                },
                knockoutWeapons = {
                    description = "Názvy zbraní nebo hashe, které by měly vyvolat knockout místo úplné obrazovky smrti.",
                    itemLabel = "Zbraň",
                    label = "Zbraně",
                },
                legShotRagdollChance = {
                    description = "Procentualni sance, ze odpovidajici zasah spusti ragdoll.",
                    label = "Sance",
                },
                legShotRagdollCooldownMs = {
                    description = "Minimalni prodleva mezi ragdolly po zasahu nohy.",
                    label = "Chladící ms",
                },
                legShotRagdollDebug = {
                    description = "Zapisuje rozhodnuti ragdollu pro testovani.",
                    label = "Ladění",
                },
                legShotRagdollDurationMs = {
                    description = "Jak dlouho ragdoll trva.",
                    label = "Trvani ms",
                },
                legShotRagdollFeet = {
                    description = "Povoli, aby zasah chodidla spustil ragdoll.",
                    label = "Chodidla",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Preskoci ragdoll, kdyz zasah pohltilo brneni.",
                    label = "Ignorovat zasahy do brneni",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Povoli zasahy do leve dolni nohy.",
                    label = "Leva dolni noha",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Povoli zasahy do leve horni nohy.",
                    label = "Leva horni noha",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Ragdoll spousti jen strelne zasahy.",
                    label = "Jen strelne zasahy",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Povoli zasahy do prave dolni nohy.",
                    label = "Prava dolni noha",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Povoli zasahy do prave horni nohy.",
                    label = "Prava horni noha",
                },
                liveDamageFracturesChance = {
                    description = "Základní šance, že vědomý zásah způsobí zlomeninu.",
                    label = "Šance",
                },
                liveDamageFracturesEnabled = {
                    description = "Umožněte vědomým zásahům poškození, aby odvalily zlomeniny.",
                    label = "Povoleno",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Minimální procento maximálního zdraví ztracené jedním zásahem, aby mohla vzniknout zlomenina.",
                    label = "Minimální procento poškození",
                },
                liveDamageFracturesZones = {
                    description = "Pravděpodobnost zlomení v jednotlivých zónách pro živé poškození.",
                    label = "Zónové šance",
                },
                liveOpenWoundStacksDefault = {
                    description = "Maximalni pocet stacku otevrenych ran na zonu bez vlastniho nastaveni.",
                    label = "Vychozi limit",
                },
                liveOpenWoundStacksZones = {
                    description = "Volitelne limity stacku otevrenych ran podle zony.",
                    itemLabel = "Zóna",
                    label = "Limity zon",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Počáteční třída krvácení aplikovaná na živé poškození.",
                    label = "Třída krvácení z živé rány",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Umožní nosiči nastoupit a řídit vozidlo bez položení pacienta.",
                    label = "Povolit nosiči vozidlo",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Umožněte nošení vědomých hráčů.",
                    label = "Povolit vědomé cíle",
                },
                medicCarryAllowSprint = {
                    description = "Umožněte sprintovat při přenášení pacienta.",
                    label = "Povolit sprint",
                },
                medicCarryAttachBone = {
                    description = "Kostní index sloužící k uchycení neseného přehrávače.",
                    label = "Připevněte kost",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Carry attachment pitch rotation.",
                    label = "Rozteč",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Otočení role nosiče.",
                    label = "Role",
                },
                medicCarryAttachOffsetsX = {
                    description = "Carry attachment X offset.",
                    label = "Odsazení X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Nosný držák Y offset.",
                    label = "Offset Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Noste rotaci náklonu držáku.",
                    label = "Jawstar name",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Carry attachment Z offset.",
                    label = "Offset Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Animační slovník používaný zdravotníkem při přenášení pacienta.",
                    label = "Animační slovník",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Příznak TaskPlayAnim používaný medikem nesou animaci.",
                    label = "Vlajka animace",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animační klip používaný zdravotníkem při přenášení pacienta.",
                    label = "Název animace",
                },
                medicCarryEnabled = {
                    description = "Aktivujte systém přenášení mediků.",
                    label = "Povoleno",
                },
                medicCarryMaxDistance = {
                    description = "Maximální vzdálenost potřebná k vyzvednutí pacienta.",
                    label = "Maximální vzdálenost",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Animační slovník používaný neseným pacientem.",
                    label = "Animační slovník",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Příznak TaskPlayAnim používaný nesenou animací pacienta.",
                    label = "Vlajka animace",
                },
                medicCarryPassengerAnimationName = {
                    description = "Animační klip používaný neseným pacientem.",
                    label = "Název animace",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Po upuštění pacienta v bezvědomí znovu použijte animaci smrti.",
                    label = "Znovu použijte animaci smrti",
                },
                medicCarryRequireOnDuty = {
                    description = "Přenášet mohou pouze zdravotníci ve službě.",
                    label = "Vyžadovat ve službě",
                },
                medicReviveAllowFatalWounds = {
                    description = "Umožní zdravotníkům ve službě ošetřit a oživit pacienty se smrtelnými nebo neoživitelnými zraněními. Po vypršení doby vykrvácení zůstává oživení zablokováno.",
                    label = "Povolit smrtelná zranění",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Nevyřešená zranění po ošetření nebo oživení kontrolního seznamu ponechejte.",
                    label = "Udržujte zranění",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Udržujte hodnoty bolesti po léčbě nebo se kontrolní seznam oživí, když jsou zranění zachována.",
                    label = "Udržujte bolest",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maximální vzdálenost používaná pro seznam blízkých hráčů při vytváření lékařského hodnocení.",
                    label = "Nedaleko dosahu pacientů",
                },
                medicalEvaluationRecipientJobs = {
                    description = "povolání, pro která lze vydávat a sdílet lékařské hodnocení.",
                    label = "Příjemci podle zaměstnání",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Umožněte přijímajícím profesím vidět datum narození pacienta.",
                    label = "Datum narození",
                },
                medicalEvaluationShareConclusion = {
                    description = "Umožněte přijímajícím profesím vidět lékařský závěr.",
                    label = "Závěr o podílu",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Umožňuje přijímajícím profesím zjistit, které typy hodnocení byly provedeny.",
                    label = "Typy hodnocení akcií",
                },
                medicalEvaluationShareFullName = {
                    description = "Umožněte přijímajícím profesím vidět celé jméno pacienta.",
                    label = "Sdílet celé jméno",
                },
                medicalEvaluationShareGender = {
                    description = "Umožněte přijímajícím profesím vidět pohlaví pacienta.",
                    label = "Sdílet pohlaví",
                },
                medicalEvaluationShareHeight = {
                    description = "Umožněte přijímajícím profesím vidět výšku pacienta.",
                    label = "Výška podílu",
                },
                medicalEvaluationShareHobbies = {
                    description = "Umožněte přijímajícím profesím, aby viděla volnočasové aktivity a koníčky pacienta.",
                    label = "Sdílet volný čas a koníčky",
                },
                medicalEvaluationShareIssuer = {
                    description = "Zobrazit jméno autora. Vydávající zaměstnání zůstává viditelné jako složka sdílených dokumentů.",
                    label = "Sdílet údaje autora",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Umožněte přijímajícím profesím vidět pacientovu osobní ID.",
                    label = "Sdílet osobní ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Umožněte přijímajícím profesím vidět pacientovu profesi.",
                    label = "Profesionální podíl",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Povolit přijímajícím profesím vidět otázky dotazníku a zaznamenané odpovědi.",
                    label = "Podělte se o otázky a odpovědi",
                },
                medicalEvaluationShareResult = {
                    description = "Umožňuje přijímajícím profesím zjistit, zda hodnocení probíhá, prošlo nebo selhalo.",
                    label = "Výsledek podílu",
                },
                medicalEvaluationShareWeight = {
                    description = "Umožněte přijímajícím profesím vidět pacientovu váhu.",
                    label = "Hmotnost akcií",
                },
                medicalEvaluationTypes = {
                    description = "Nastavit typy hodnocení, otázky, typy odpovědí a zda je každá otázka aktivní.",
                    label = "Druhy hodnocení a dotazníky",
                    options = {
                        boolean = "Ano / Ne",
                        boolean_text = "Ano / Ne s detaily",
                        date = "Datum",
                        multi_select = "Mnohonásobná volba",
                        number = "Číslo",
                        rating = "Hodnocení",
                        select = "Jediná volba",
                        text = "Text",
                        textarea = "Oblast textu",
                        time = "Čas",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Aktivujte lékařské vyšetření v tabletu sanitky.",
                    label = "Povoleno",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Nabídne trvalou dobu, která zůstane aktivní, dokud zdravotník pomůcku neodstraní.",
                    label = "Povolit do odstranění",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Zabrání útokům zblízka při nasazené sádře na ruce.",
                    label = "Zakázat boj zblízka",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Vynutí boj beze zbraně a zabrání přepínání zbraní při nasazené sádře na ruce.",
                    label = "Zakázat zbraně",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Použije bojová omezení při nasazené sádře na ruce.",
                    label = "Povoleno",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Při nasazení sádry nebo dlahy ošetří odpovídající zlomeninu.",
                    label = "Propojení se zlomeninami",
                },
                medicalWearablesCastsEnabled = {
                    description = "Povolí sádry na levou a pravou ruku i nohu.",
                    label = "Povoleno",
                },
                medicalWearablesCastsItem = {
                    description = "Předmět z inventáře spotřebovaný při nasazení sádry.",
                    label = "Předmět",
                },
                medicalWearablesCastsMinigame = {
                    description = "Existující léčebná minihra používaná pro sádry.",
                    label = "Minihra",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Výchozí doba zdravotní pomůcky v minutách. Hodnota 0 znamená do odstranění.",
                    label = "Výchozí minuty",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Doby zdravotní pomůcky nabízené zdravotníkům v minutách.",
                    label = "Možnosti doby",
                },
                medicalWearablesEnabled = {
                    description = "Povolí modely sádry, dlahy, obvazu, límce a kyslíkové masky v nabídce ošetření.",
                    label = "Povoleno",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Jak často se odstraňují časované zdravotní pomůcky po vypršení.",
                    label = "Kontrola vypršení (sekundy)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Povolí model obvazu hlavy.",
                    label = "Povoleno",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Předmět z inventáře spotřebovaný pro obvaz hlavy.",
                    label = "Předmět",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Existující léčebná minihra používaná pro obvaz hlavy.",
                    label = "Minihra",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Zabrání skákání při nasazené sádře na noze.",
                    label = "Zakázat skok",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Zabrání sprintu při nasazené sádře na noze.",
                    label = "Zakázat sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Vynutí zraněnou sadu pohybu při nasazené sádře na noze.",
                    label = "Vynutit zraněnou chůzi",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Přepíše rychlost pohybu při nasazené sádře na noze.",
                    label = "Rychlost pohybu",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Použije omezení pohybu při nasazené sádře na noze.",
                    label = "Povoleno",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Povolí model krčního límce.",
                    label = "Povoleno",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Předmět z inventáře spotřebovaný pro krční límec.",
                    label = "Předmět",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Existující léčebná minihra používaná pro krční límec.",
                    label = "Minihra",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Povolí model kyslíkové masky.",
                    label = "Povoleno",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Předmět z inventáře spotřebovaný pro kyslíkovou masku.",
                    label = "Předmět",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Existující léčebná minihra používaná pro kyslíkovou masku.",
                    label = "Minihra",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Zobrazuje pacientům aktivní zdravotní pomůcky a zbývající dobu nošení.",
                    label = "Zapnuto",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Určuje umístění HUD zdravotních pomůcek pacienta.",
                    label = "Pozice",
                    options = {
                        ["bottom-center"] = "Dole uprostřed",
                        ["bottom-left"] = "Dole vlevo",
                        ["bottom-right"] = "Dole vpravo",
                        center = "Uprostřed",
                        ["center-left"] = "Uprostřed vlevo",
                        ["center-right"] = "Uprostřed vpravo",
                        ["top-center"] = "Nahoře uprostřed",
                        ["top-left"] = "Nahoře vlevo",
                        ["top-right"] = "Nahoře vpravo",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Obnoví časované sádry, dlahy, krční límce a obvazy trupu po opětovném připojení nebo restartu resource.",
                    label = "Trvalost zdravotních pomůcek",
                },
                medicalWearablesRemoval = {
                    description = "Umožní zdravotníkům odstranit aktivní sádry, dlahy, krční límce a obvazy trupu v nabídce ošetření.",
                    label = "Odstranění zdravotníkem",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Zobrazí odstranění zdravotní pomůcky nastaveným nástrojem v nabídce ošetření.",
                    label = "Odstranění v ošetření povoleno",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Opakovaně použitelný nástroj z inventáře potřebný k odstranění zdravotní pomůcky.",
                    label = "Předmět",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minihra při odstraňování zdravotních pomůcek (výchozí: cast_saw).",
                    label = "Minihra",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Povolí závěsné dlahy na levou a pravou ruku.",
                    label = "Povoleno",
                },
                medicalWearablesSplintsItem = {
                    description = "Předmět z inventáře spotřebovaný při nasazení dlahy.",
                    label = "Předmět",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Existující léčebná minihra používaná pro dlahy.",
                    label = "Minihra",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Povolí model obvazu trupu.",
                    label = "Povoleno",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Předmět z inventáře spotřebovaný pro obvaz trupu.",
                    label = "Předmět",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Existující léčebná minihra používaná pro obvaz trupu.",
                    label = "Minihra",
                },
                medicationsProfiles = {
                    description = "Deklarativní záznamy léků používané pro léčbu a samoléčbu.",
                    itemLabel = "Léky",
                    label = "Léky",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Povolte minihru masky ventilu vaku.",
                    label = "Maska ventilového vaku",
                },
                minigamesCastSawEnabled = {
                    description = "Zapne minihru s pilou při odstraňování zdravotních pomůcek.",
                    label = "Pila na sádru",
                },
                minigamesBandageWrapEnabled = {
                    description = "Povolte minihru bandáže.",
                    label = "Obvazový zábal",
                },
                minigamesBloodPressureEnabled = {
                    description = "Povolte minihru krevního tlaku.",
                    label = "Krevní tlak",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Povolte minihru krevní transfuze.",
                    label = "Krevní transfuze",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Povolte minihru na extrakci střel.",
                    label = "Extrakce kulky",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Během každé ventilační fáze jsou vyžadovány nádechy.",
                    label = "Nádechů za cyklus",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Sekundy na dokončení jedné kompresní sady.",
                    label = "Doba komprese na sadu",
                },
                minigamesCprCompressionWindow = {
                    description = "Povolený offset při zasažení kompresního rytmu.",
                    label = "Kompresní okno",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Povolte fázi minihry komprese CPR.",
                    label = "KPR komprese",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Počet stlačení na sadu.",
                    label = "Komprese na sadu",
                },
                minigamesCprCycles = {
                    description = "Kolik cyklů KPR je potřeba k dokončení minihry.",
                    label = "Cykly",
                },
                minigamesCprEnabled = {
                    description = "Povolte minihru CPR.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Odpočítávání před zahájením kompresí KPR.",
                    label = "Vteřiny zpoždění úvodu",
                },
                minigamesCprMaxMisses = {
                    description = "Chyby jsou povoleny před selháním minihry CPR.",
                    label = "Max chybí",
                },
                minigamesCprSetsPerCycle = {
                    description = "Kolik kompresních sad proběhne před dechovou fází.",
                    label = "Sady za cyklus",
                },
                minigamesCprVentilationEnabled = {
                    description = "Povolte fázi minihry ventilace KPR.",
                    label = "CPR ventilace",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Povolte minihru glukometru.",
                    label = "Glukometr",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Povolte minihru měření tepu.",
                    label = "Měření pulsu",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Povolte minihru pulzního oxymetru.",
                    label = "Pulzní oxymetr",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Povolte minihru infuze fyziologického roztoku.",
                    label = "Infuze fyziologického roztoku",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Sekundy před vypršením časového limitu pokusu o ventilaci. Nastavte 0 pro deaktivaci.",
                    label = "Sekundy časového limitu dechu",
                },
                minigamesVentilationEnabled = {
                    description = "Zapněte ventilační minihru.",
                    label = "Větrání",
                },
                minigamesVentilationTolerance = {
                    description = "Tolerance vzdálenosti pixelů při sledování vlny proudění vzduchu.",
                    label = "Tolerance",
                },
                operationsBreakDistance = {
                    description = "Maximální vzdálenost účastníků od sálu před přerušením zákroku.",
                    label = "Vzdálenost přerušení",
                },
                operationsDoctorAnimationDict = {
                    description = "Slovník animací GTA pro chirurga během skutečného zákroku.",
                    label = "Slovník animace chirurga",
                },
                operationsDoctorAnimationFlag = {
                    description = "Příznak animace GTA použitý pro chirurga během skutečného zákroku.",
                    label = "Příznak animace chirurga",
                },
                operationsDoctorAnimationName = {
                    description = "Animační klip pro chirurga během skutečného zákroku.",
                    label = "Název animace chirurga",
                },
                operationsEnabled = {
                    description = "Povolí operační sály a chirurgické zákroky.",
                    label = "Povoleno",
                },
                operationsFadeInMs = {
                    description = "Doba rozjasnění obrazovky pacienta při probuzení v milisekundách.",
                    label = "Rozjasnění při probuzení (ms)",
                },
                operationsFadeOutMs = {
                    description = "Doba zatmívání obrazovky pacienta při anestezii v milisekundách.",
                    label = "Zatmívání při anestezii (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Maximální doba bez platné akce minihry, po které se relace ukončí.",
                    label = "Časový limit nečinnosti (s)",
                },
                operationsInteractDistance = {
                    description = "Maximální vzdálenost pro zobrazení a použití interakcí v operačním sále.",
                    label = "Vzdálenost interakce",
                },
                operationsInteractKey = {
                    description = "ID ovládacího prvku pro interakci s operačním stolem a pozicí chirurga.",
                    label = "Klávesa interakce",
                },
                operationsPatientAnimationDict = {
                    description = "Slovník animací GTA pro pacienta ležícího v celkové anestezii.",
                    label = "Slovník animace pacienta",
                },
                operationsPatientAnimationFlag = {
                    description = "Příznak animace GTA použitý pro animaci ležícího pacienta.",
                    label = "Příznak animace pacienta",
                },
                operationsPatientAnimationName = {
                    description = "Animační klip pro pacienta ležícího v celkové anestezii.",
                    label = "Název animace pacienta",
                },
                operationsPatientRange = {
                    description = "Maximální dosah pro zjištění pacienta ležícího na operačním stole.",
                    label = "Dosah pacienta",
                },
                operationsRequireOnDuty = {
                    description = "Vyžaduje, aby chirurgové byli před použitím operačního sálu ve službě.",
                    label = "Vyžadovat službu",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Maximální doba, po kterou může chirurg zůstat ve výběru zákroku, než se relace ukončí.",
                    label = "Časový limit výběru (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Slovník animací GTA pro chirurgický výcvik bez pacienta.",
                    label = "Slovník výcvikové animace",
                },
                operationsTrainingAnimationFlag = {
                    description = "Příznak animace GTA použitý pro chirurgický výcvik.",
                    label = "Příznak výcvikové animace",
                },
                operationsTrainingAnimationName = {
                    description = "Animační klip pro chirurgický výcvik bez pacienta.",
                    label = "Název výcvikové animace",
                },
                painClassesProfiles = {
                    description = "Práh bolesti, štítky a efekty následného zpracování.",
                    label = "Třídy bolesti",
                },
                painEffectsMinPainLevel = {
                    description = "Minimální úroveň bolesti před spuštěním efektů obrazovky bolesti.",
                    label = "Minimální úroveň bolesti",
                },
                primaryColor = {
                    description = "Hlavní barva rozhraní EMS a skupiny záchranářských povolání.",
                    label = "Základní barva",
                },
                propPlacementConsumeItem = {
                    description = "Po umístění rekvizity spotřebujte odpovídající položku inventáře.",
                    label = "Konzumujte položku",
                },
                propPlacementEnabled = {
                    description = "Povolit umístění nakonfigurovaných rekvizit EMS z použitelných položek inventáře.",
                    label = "Povoleno",
                },
                propPlacementItemNames = {
                    description = "Mapujte modely podpěr EMS na názvy inventárních položek pro umístění na základě položek.",
                    label = "Názvy rekvizit",
                },
                propPlacementRequireOnDuty = {
                    description = "Před umístěním rekvizit EMS požadujte, aby byl hráč ve službě.",
                    label = "Vyžadovat ve službě",
                },
                propPlacementReturnItem = {
                    description = "Vraťte spotřebovaný předmět, když je odstraněna umístěná rekvizita.",
                    label = "Vraťte položku při odebrání",
                },
                propPlacementVehicleAccess = {
                    description = "Umožněte rekvizitám kmene otevřít tok umístění namísto použití pouze pro položky.",
                    label = "Přístup k vozidlu",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Povolit veřejné zacházení s uvědomělými hráči.",
                    label = "Umožněte pacientům při vědomí",
                },
                publicTreatmentAllowedGangs = {
                    label = "Povolené gangy",
                    description = "Vyberte interní názvy gangů nebo nezávislých organizací. Shoda práce nebo gangu udělí oprávnění nebo výjimku. Povinná služba platí pouze pro práce. Volitelné minimální hodnosti gangů. Prázdný seznam povoluje všechny hodnosti. Požadavky na předměty stále platí.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Práce, které mohou využívat veřejné ošetření, aniž by byly EMS.",
                    label = "Povolené úlohy",
                },
                publicTreatmentEnabled = {
                    description = "Povolit veřejné zacházení pro osoby, které nereagují na EMS s platným přístupem.",
                    label = "Léčba veřejnosti povolena",
                },
                publicTreatmentInteractDistance = {
                    description = "Maximální vzdálenost potřebná k zahájení veřejné léčby.",
                    label = "Interaktivní vzdálenost",
                },
                publicTreatmentKeybind = {
                    description = "Výchozí interakční klávesa používaná pro veřejné zacházení.",
                    label = "Keybind",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Zobrazí výzvu k ošetření a povolí příslušnou klávesu. Při použití exportů nebo vlastního kruhového menu tuto možnost vypněte.",
                    label = "Interakce klávesou povolena",
                },
                publicTreatmentPromptDistance = {
                    description = "Vzdálenost použitá k zobrazení výzvy k ošetření veřejnosti.",
                    label = "Okamžitá vzdálenost",
                },
                publicTreatmentRequireAllItems = {
                    description = "Vyžadujte každou uvedenou lékařskou položku namísto pouze jedné.",
                    label = "Vyžadovat všechny položky",
                },
                publicTreatmentRequiredItems = {
                    description = "Položky inventáře, které se počítají jako platné veřejné ošetřovací zařízení.",
                    itemLabel = "Položka",
                    label = "Požadované položky",
                },
                reviveRewardAccount = {
                    description = "Primární klíč účtu používaný k oživení výplat odměn.",
                    label = "Účet",
                },
                reviveRewardAccountType = {
                    description = "Primární typ účtu používaný k oživení výplat odměn.",
                    label = "Typ účtu",
                },
                reviveRewardAmount = {
                    description = "Částka odměny vyplacená zdravotníkovi za oživení.",
                    label = "Množství",
                },
                reviveRewardCurrency = {
                    description = "Volitelný klíč vlastní měny používaný k oživení výplat odměn.",
                    label = "Měna",
                },
                reviveRewardEnabled = {
                    description = "Zaplaťte nakonfigurovanou odměnu po úspěšném oživení medika.",
                    label = "Povoleno",
                },
                reviveRewardPayFromSociety = {
                    description = "Než zaplatíte medikovi, odečtěte si odměny za oživení od společnosti sdílené práce.",
                    label = "Platit od společnosti",
                },
                selfDiagnoseCommand = {
                    description = "Chat příkaz používaný k otevření vlastní diagnostiky.",
                    label = "Příkaz",
                },
                selfDiagnoseEnabled = {
                    description = "Umožněte hráčům otevřít diagnostické uživatelské rozhraní na sobě.",
                    label = "Samodiagnostika povolena",
                },
                selfDiagnoseKeybind = {
                    description = "Výchozí klávesová zkratka používaná k otevření vlastní diagnostiky.",
                    label = "Keybind",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Zpoždění před otevřením uživatelského rozhraní pro vlastní diagnostiku.",
                    label = "Zpoždění otevření ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Autodiagnostiku omezte pouze na lékařské práce.",
                    label = "Vyžadovat práci lékaře",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Během vlastní diagnostiky přehrávač nezmrazujte.",
                    label = "Přeskočit zmrazení na sebe",
                },
                statusEffectsProfiles = {
                    description = "Nakonfigurované efekty obrazovky a prahové hodnoty pro krvácení, nízkou hladinu krve, hlad a žízeň.",
                    label = "Stavové efekty",
                },
                stretcherAnimDict = {
                    description = "Animační slovník používaný při nošení nosítka.",
                    label = "Animační diktát",
                },
                stretcherAnimName = {
                    description = "Název animace používaný při nošení nosítek.",
                    label = "Název animace",
                },
                stretcherAttachRx = {
                    description = "Noste uchycení X rotace pro nosítka.",
                    label = "Připojte RX",
                },
                stretcherAttachRy = {
                    description = "Noste uchycení Y rotace pro nosítka.",
                    label = "Připojte RY",
                },
                stretcherAttachRz = {
                    description = "Noste uchycení Z rotace pro nosítka.",
                    label = "Připojte RZ",
                },
                stretcherAttachX = {
                    description = "Noste držák X offset pro nosítka.",
                    label = "Připojit X",
                },
                stretcherAttachY = {
                    description = "Noste odsazení držáku Y pro nosítka.",
                    label = "Připojte Y",
                },
                stretcherAttachZ = {
                    description = "Noste držák Z offset pro nosítka.",
                    label = "Připojit Z",
                },
                stretcherFoldedEnabled = {
                    description = "Povolte volitelnou variantu složených nosítek uvnitř vozidel.",
                    label = "Skládání povoleno",
                },
                stretcherFoldedModel = {
                    description = "Prop model použitý pro variantu složených nosítek.",
                    label = "Skládaný model",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Hlava pacienta použitá pro variantu složených nosítek.",
                    label = "Složená hlavička pacienta",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Pacient připevněte X offset pro složená nosítka.",
                    label = "Složený pacient X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Pacient připevní Y offset pro složená nosítka.",
                    label = "Složený pacient Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Pacient připevněte Z offset pro složená nosítka.",
                    label = "Složený pacient Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Přepsání interakční vzdálenosti používané pro vrtulníky.",
                    label = "Interaktivní vzdálenost vrtulníku",
                },
                stretcherHelicopterModels = {
                    description = "Modely vozidel považovány za nosné vrtulníky.",
                    itemLabel = "Vzor",
                    label = "Modely vrtulníků",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Přepsání vzdálenosti vyzvednutí používané pro vrtulníky.",
                    label = "Vzdálenost vyzvednutí vrtulníkem",
                },
                stretcherInteractDistance = {
                    description = "Maximální vzdálenost pro výzvy k interakci s nosítky.",
                    label = "Interaktivní vzdálenost",
                },
                stretcherItemEnabled = {
                    description = "Povolí inventární předmět nosítek včetně nákupu v obchodě a použití.",
                    label = "Předmět nosítek",
                },
                stretcherItemPickupEnabled = {
                    description = "Umožní vrátit nosítka použitá z inventáře zpět do inventáře.",
                    label = "Vyzvednutí předmětu",
                },
                stretcherModel = {
                    description = "Primární model podpěry nosítek používaný systémem nosítek EMS.",
                    label = "Vzor",
                },
                stretcherPatientAnimationDict = {
                    description = "Slovník animace pro pacienty na nosítkách a NPC v náhledu.",
                    label = "Slovník animace pacienta",
                },
                stretcherPatientAnimationName = {
                    description = "Animační klip pro pacienty na nosítkách a NPC v náhledu.",
                    label = "Název animace pacienta",
                },
                stretcherPatientAttachHeading = {
                    description = "Hlavička pacienta se používá vleže na nosítkách.",
                    label = "Hlava pacienta",
                },
                stretcherPatientAttachX = {
                    description = "Pacient připevní X offset na nosítka.",
                    label = "Pacient X",
                },
                stretcherPatientAttachY = {
                    description = "Pacient připevní Y offset na nosítka.",
                    label = "Pacient Y",
                },
                stretcherPatientAttachZ = {
                    description = "Pacient připevněte Z offset na nosítka.",
                    label = "Pacient Z",
                },
                stretcherPickupDistance = {
                    description = "Vzdálenost potřebná k vyzvednutí nosítek a interakci s nimi.",
                    label = "Vzdálenost vyzvednutí",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animační klip používaný při ošetřování pacienta na nosítkách. Chcete-li použít scénář nebo záložní animaci ošetření, ponechte prázdné.",
                    label = "Název animace",
                },
                stretcherTreatmentAnimDict = {
                    description = "Animační slovník používaný při ošetřování pacienta na nosítkách. Chcete-li použít scénář nebo záložní animaci ošetření, ponechte prázdné.",
                    label = "Animační slovník",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Volitelný scénář používaný při ošetřování pacienta na nosítkách. Chcete-li použít příkaz dict + klip nebo záložní animaci ošetření, ponechte prázdné.",
                    label = "Scénář",
                },
                stretcherVehicleAttachRx = {
                    description = "Připevnění vozidla X rotace pro naložení nosítek.",
                    label = "Vozidlo RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Připevněte vozidlo otočením do Y pro naložení nosítek.",
                    label = "Vozidlo RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Upevněte vozidlo do Z rotace pro naložení nosítek.",
                    label = "Vozidlo RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Upevněte vozidlo X offset pro naložení nosítek.",
                    label = "Vozidlo X",
                },
                stretcherVehicleAttachY = {
                    description = "Připevnění vozidla Y offset pro naložení nosítek.",
                    label = "Vozidlo Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Upevňovací zařízení vozidla odsazení v Z pro naložení nosítek.",
                    label = "Vozidlo Z",
                },
                stretcherVehicleModels = {
                    description = "Modely vozidel umožňují naložení nosítek.",
                    itemLabel = "Vzor",
                    label = "Modely vozidel",
                },
                treatmentAnimClip = {
                    description = "Animační klip používaný při léčbě pacienta. Chcete-li místo toho použít scénář, ponechte prázdné.",
                    label = "Název animace",
                },
                treatmentAnimDict = {
                    description = "Animační slovník používaný při léčbě pacienta. Chcete-li místo toho použít scénář, ponechte prázdné.",
                    label = "Animační slovník",
                },
                treatmentAnimScenario = {
                    description = "Scénář použitý při léčbě pacienta. Chcete-li místo toho použít příkaz dict + clip, ponechte prázdné.",
                    label = "Scénář",
                },
                trunkPropsEnabled = {
                    label = "Objekty vozidla",
                    description = "Vyber objekty u blízkého služebního vozidla.",
                },
                trunkEnabled = {
                    description = "Povolte funkci kufru vozidla pro sanitní vozidla.",
                    label = "Povoleno",
                },
                vehicleDamageModifier = {
                    description = "Multiplikátor poškození je použit, když je hráč uvnitř vozidla.",
                    label = "Modifikátor poškození vozidla",
                },
                vehicleImpactProtectionCauses = {
                    description = "Příčiny smrti, které by se měly počítat jako chráněné nárazy vozidla.",
                    itemLabel = "Příčina",
                    label = "Poškození způsobuje",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Zabraňte zabití hráče nárazy vozidla při nízké rychlosti.",
                    label = "Povoleno",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Nárazy vozidel pod touto rychlostí nemohou hráče zabít.",
                    label = "Smrtelná rychlost km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Nárazy vozidla při této rychlosti nebo vyšší používají normální konfiguraci se smrtí.",
                    label = "Plná rychlost poškození km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Zranění při nárazu vozidla blokuje smrtelný zásah.",
                    itemLabel = "Zranění",
                    label = "Zranění",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Procento maximálního zachovaného zdraví, když by chráněný dopad zabil hráče.",
                    label = "Procento zdraví pro přežití",
                },
                vehiclePullEnabled = {
                    description = "Umožnit vytahování pacientů z vozidel.",
                    label = "Povoleno",
                },
                vehiclePullMaxDistance = {
                    description = "Maximální vzdálenost potřebná k vytažení pacienta z vozidla.",
                    label = "Maximální vzdálenost",
                },
                wheelchairAssignMaxDistance = {
                    description = "Maximální vzdálenost pro přidělení invalidního vozíku jinému hráči.",
                    label = "Přiřaďte maximální vzdálenost",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Automaticky odbavte invalidní vozík, když vyprší přidělení.",
                    label = "Automatické odbavení po vypršení platnosti",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Výchozí přiřazená doba trvání invalidního vozíku v minutách.",
                    label = "Výchozí doba trvání",
                },
                wheelchairDisableSprint = {
                    description = "Blokový sprint, když je invalidní vozík vybaven.",
                    label = "Zakázat sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Zablokujte použití zbraně, když je invalidní vozík vybaven.",
                    label = "Zakázat zbraně",
                },
                wheelchairExitControl = {
                    description = "ID kontroly používané k opuštění invalidního vozíku.",
                    label = "Ovládání výstupu",
                },
                wheelchairItemName = {
                    description = "Položka inventáře použitá pro invalidní vozík.",
                    label = "Název položky",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Maximální povolená doba přidělení invalidního vozíku v minutách.",
                    label = "Maximální doba trvání",
                },
                wheelchairMinDurationMinutes = {
                    description = "Minimální povolená doba přidělení invalidního vozíku v minutách.",
                    label = "Min. trvání",
                },
                wheelchairVehicle = {
                    description = "Model vozidla použitý pro invalidní vozík.",
                    label = "Model vozidla",
                },
                xrayInteractionRange = {
                    description = "Maximální vzdálenost od RTG stanice pro operátora.",
                    label = "Interakční rozsah",
                },
                xrayPatientRange = {
                    description = "Maximální vzdálenost od RTG stanice pro pacienta.",
                    label = "Rozsah pacientů",
                },
                xrayScanDurationSeconds = {
                    description = "Doba trvání v sekundách pro výsledek rentgenového skenování.",
                    label = "Délka skenování",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Vychladnout během několika sekund mezi pokusy o rezervaci pacientů.",
                    label = "Rezervace chladu",
                },
                appointmentsEnabled = {
                    description = "Aktivujte rezervaci pacienta a osobní zdravotník kalendář.",
                    label = "Povoleno",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Maximální počet dní do budoucnosti, které si pacienti mohou rezervovat.",
                    label = "Maximální rezervace předem",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Maximální počet aktivních budoucích schůzek, které pacient může vykonat.",
                    label = "Maximální počet jmenování na pacienta",
                },
                appointmentsMinLeadMinutes = {
                    description = "Minimální počet minut mezi rezervací a jmenováním.",
                    label = "Minimální doba vedení",
                },
                appointmentsNotificationApp = {
                    description = "Identifikátor aplikace telefonu používaný pro oznámení o jmenování.",
                    label = "Informační aplikace",
                },
                appointmentsNotificationsEnabled = {
                    description = "Upozorněte pacienty na telefonu, když jsou objednány nebo zrušeny.",
                    label = "Telefonní oznámení",
                },
                appointmentsReasonMaxLength = {
                    description = "Maximální počet znaků přijatých z důvodu jmenování.",
                    label = "Mez důvodové znaky",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Doba trvání a časový interval nastavení slotu v minutách.",
                    label = "Doba trvání slotu",
                },
                enforceMaxHealth = {
                    description = "Udržujte hráče maximální zdraví na 200. Zakázat to, když jiný zdroj řídí maximální zdraví.",
                    label = "Enforce 200 max. zdraví",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Další rámcové licence ambulance zaměstnanci mohou dát nebo odstranit v pacientových záznamech. Konfigurovaná licence první pomoci je vždy zahrnuta.",
                    itemLabel = "Licence",
                    label = "Další licence pacientů",
                },
                minigamesBandageWrapRandomization = {
                    description = "Náhodný směr gázy, tvar a proporce.",
                    label = "Variace obvazového zábalu",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Randomizovat cestu žilního přístupu k transfuzi krve.",
                    label = "Variace přístupu k transfuzi",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Vyžadujte postup vícestupňového venózního přístupu před řízením průtoku. Zakázat pro starou jednoduchou verzi.",
                    label = "Venózní přístupová fáze",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Randomizujte tvar průplavu, šířku a překážky.",
                    label = "Variace extrakce střely",
                },
                stretcherVehicleAttachEditor = {
                    description = "Postavte se a otočte nosítka uvnitř konfigurované sanitky.",
                    label = "Uchycení vozidla",
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
            warnings = {
                firstAidPublicTreatmentConflict = "První pomoc a veřejná léčba nelze aktivovat současně. Uložením se obojí zakáže.",
            },
        },
    },
}
