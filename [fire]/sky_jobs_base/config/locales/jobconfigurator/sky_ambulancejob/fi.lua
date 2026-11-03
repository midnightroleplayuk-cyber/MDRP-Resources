JobConfigLocales["sky_ambulancejob:fi"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Lääketieteelliset lausunnot",
                sharedMedicalEvaluations = "Jaetut lääkärinlausunnot",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Salli respawn",
                        description = "Maarittaa voiko taman sangyn valita pelaajan respawn-paikaksi.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Määritä ambulanssityöt, sairaalasängyt, kuolemajärjestelmät, vuorovaikutukset ja ydintoimintojen asetukset.",
                    title = "Ambulanssin työt",
                },
            },
            dispatchActions = {
                currentLocation = "Käytä nykyistä sijaintia",
                addChannel = "Lisää radiokanava",
                addKeyword = "Lisää avainsana",
                addPoi = "Lisää kohde",
                addReporter = "Lisää ilmoittaja",
                addStatus = "Lisää FMS-tila",
                addVehicle = "Lisää virtuaaliyksikkö",
                addVehicleType = "Lisää yksikkötyyppi",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Määrittää välittömästi vastaavat käytettävissä olevat yksiköt, kun tapahtuma luodaan.",
                available = "Tässä tilassa olevia yksiköitä voidaan ehdottaa ja määrittää uudelle tapahtumalle.",
                averageResponseSpeedKmh = "Laskee näytetyn saapumisarvion suoran etäisyyden perusteella.",
                callsign = "Ainutlaatuinen radiokutsu, joka näytetään, kun pelaajat työskentelevät tässä virtuaaliyksikössä.",
                centerEnabled = "Sallii päivystävän valtuutetun jäsenen työskennellä lähetyskeskuksessa.",
                channelId = "Radiokanavan tunnus PMA Voicelle, SaltyChatille ja YACA:lle. Numeeriset tunnukset, kuten 2500, pysyvät ennallaan; PMA Voice kartoittaa tekstitunnukset vakaaseen numeroon.",
                channelLabel = "Luettavissa oleva kanavan nimi näytetään lähettäjille ja yksiköille.",
                defaultChannel = "Työnvälittäjät liittyvät tähän kanavaan aloittaessaan työvuoronsa. Yksiköt liittyvät manuaalisesti Radio-välilehdeltä. Valitse Ei mitään, jos haluat käyttää työryhmän oletusasetusta.",
                emergencyAppEnabled = "Tekee tästä työstä valittavan julkisena palveluna Hätäpuhelinsovelluksessa.",
                enabled = "Asettaa tämän työn Dispatch App -sovelluksen ja työnvälisten tapahtumien saataville.",
                icon = "Valitse Dispatch-sovelluksessa tälle yksikkökategorialle näkyvä kuvake.",
                incidentAssessmentEnabled = "Näyttää lääketieteellisiä ja vaaranarviointikysymyksiä koko tapahtuman tiedot.",
                jobs = "Muita töiden nimiä, jotka vastaanottavat tämän avainsanan avulla tapahtuvia tapahtumia.",
                minimumCrew = "Vähimmäismäärä tähän vastaussuunnitelmaan valituissa yksiköissä.",
                noUnitFallback = "Ilman keskustaa tai henkilöstöyksikköä lähettää Sky-ilmoituksen kaikille päivystävälle jäsenelle.",
                radius = "Suurin etäisyys metreinä, jolla aseman tiedotus voidaan kuulla.",
                requirements = "Vastauspyyntö TYYPPI:COUNT-pareina, esimerkiksi PATROL:2,CRIMI:1.",
                statusCode = "Numeerinen FMS-tila, joka näkyy kädessä pidettävässä radiossa.",
                statusLabel = "Tämän FMS-tilan merkitys lähettäjille ja yksiköille.",
                vehicleType = "On vastattava edellisessä alaosiossa määritettyä ajoneuvotyypin koodia.",
                vehicleTypeCode = "Lyhyt yksikkökoodi, jota käytetään vastausvaatimuksissa, esimerkiksi PATROL, CRIME, EMS tai RESCUE.",
                vehicleTypeLabel = "Tämän yksikköluokan luettava nimi.",
                crewCapacity = "Yksikön miehistön enimmäismäärä. Arvo 0 sallii rajattoman miehistön.",
                joinLocked = "Estää uusia henkilöitä liittymästä sen jälkeen, kun yksikkö on miehitetty.",
                poiId = "Pysyvä tekninen tunnus, johon hätäkeskusprofiili voi viitata kohteen nimeämisen jälkeenkin.",
                readyStatusCode = "FMS-tila, joka asetetaan resurssin tullessa hälytysvalmiiksi.",
                resourceType = "Luokittelee operatiivisen resurssin hätäkeskuksen suodatusta ja koordinointia varten.",
                respondingStatusCode = "FMS-tila, joka asetetaan resurssin vastatessa tehtävään.",
                shortLabel = "Valinnainen lyhyt nimi kuudelle radiokanavan muistipainikkeelle.",
                stationId = "Liittää yksikön hätäkeskusprofiilissa määritettyyn asemaan.",
                unitId = "Pysyvä tekninen tunnus säilyttää yksikön, vaikka kutsutunnus muuttuu.",
            },
            dispatchFields = {
                address = "Osoite",
                autoAlarm = "Automaattinen hälytys",
                available = "Lähetettävissä",
                averageResponseSpeedKmh = "Arvioitu vastenopeus (km/h)",
                callsign = "Kutsumerkki",
                category = "Luokka",
                centerEnabled = "Ota välityskeskus käyttöön",
                channelId = "Kanavan tunnus",
                code = "Koodi",
                defaultChannel = "Oletusradiokanava",
                emergencyAppEnabled = "Näytä hätäsovelluksessa",
                enabled = "Ota lähetys käyttöön",
                icon = "Kuvake",
                incidentAssessmentEnabled = "Ota hätätilanteen arviointi käyttöön",
                jobs = "Kohdetyöt (pilkuilla erotettuna)",
                keywordCode = "Avainsanakoodi",
                label = "Etiketti",
                minimumCrew = "Miehistön vähimmäismäärä",
                name = "Nimi",
                noUnitFallback = "Ilmoita päivystävälle henkilökunnalle ilman yksiköitä",
                noneChannel = "Ei mitään / ryhmän oletus",
                note = "Huom",
                phone = "Puhelin",
                radius = "Ilmoituksen säde",
                requirements = "Vaaditut yksiköt (esimerkiksi PATROL:2, CRIME:1)",
                type = "Tyyppi",
                vehicleType = "Vastausyksikön tyyppi",
                crewCapacity = "Miehistökapasiteetti",
                joinLocked = "Lukitse miehistöön liittyminen",
                poiId = "Pysyvä POI-tunnus",
                readyStatusCode = "Valmiustilan koodi",
                resourceType = "Resurssityyppi",
                respondingStatusCode = "Vastetilan koodi",
                shortLabel = "Radiomuistin nimi",
                stationId = "Asematunnus",
                unitId = "Pysyvä yksikkötunnus",
            },
            dispatchIconOptions = {
                crime = "Rikosyksikkö",
                emergency = "Hätäyksikkö",
                ems = "EMS-yksikkö",
                fire = "Paloyksikkö",
                heavy = "Raskas yksikkö",
                k9 = "K-9-yksikkö",
                medical = "Sairaanhoitoyksikkö",
                patrol = "Partio",
                rescue = "Pelastusyksikkö",
                service = "Palveluyksikkö",
                supervisor = "Valvoja",
                tactical = "Taktinen yksikkö",
            },
            dispatchNavigation = {
                active = "Lähetys käynnissä",
                description = "Määritä tätä työtä varten hätävastaanotto, radio, yksiköt, toimintasuunnitelmat, sijainnit ja toimittajatiedot.",
                inactive = "Lähetys poistettu käytöstä",
                steps = {
                    accessText = "Ota lähetys käyttöön ja päätä, voiko tämä työ työllistää välityskeskuksen.",
                    accessTitle = "Pääsy ja hätäotto",
                    fleetText = "Määritä kanavat, FMS-tilakoodit, ajoneuvotyypit ja kutsumerkit.",
                    fleetTitle = "Radio ja laivasto",
                    responseText = "Viimeistele avainsanat, vastausvaatimukset ja POI-kohteet.",
                    responseTitle = "Vastaussuunnitelmat",
                },
                summary = {
                    channels = "Radiokanavat",
                    plans = "Vastaussuunnitelmat",
                    statuses = "Saatavilla FMS",
                    units = "Virtuaaliyksiköt",
                    reporters = "Tunnetut ilmoittajat",
                },
                title = "Lähetys",
                warnings = {
                    channels = "Ei ole olemassa erityisiä radiokanavia. työryhmän varakanavaa käytetään.",
                    defaultChannel = "Valittua oletuskanavaa ei enää ole.",
                    disabled = "Lähetys on poistettu käytöstä tässä työssä.",
                    statuses = "Vähintään yhden FMS-tilan on oltava saatavilla, jotta yksiköt voivat hälyttää.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Määrittää radiokanavat, joihin yksiköt ja miehistölliset lähetyskeskukset voivat liittyä.",
                dispatchKeywords = "Määrittää tapahtuman avainsanat, vaaditut ajoneuvomäärät, osallistuvat työt ja valinnaisen automaattisen hälytyksen.",
                dispatchPois = "Tallentaa asemat ja yleiset sijainnit tapahtumalomakkeille ja sijaintiin perustuville asemailmoituksille.",
                dispatchStatusCodes = "Määrittää FMS-tilatunnisteet ja mitkä tilat lasketaan käytettävissä oleviksi uusille tapahtumille.",
                dispatchVehicleTypes = "Määrittää toimintasuunnitelmien käyttämät yksikköluokat, kuten partio, rikosyksikkö, hätäkeskus tai pelastus.",
                dispatchVehicles = "Määrittelee virtuaaliset lähetysajoneuvot, jotka voidaan saada miehistöä mistä tahansa ilman, että vaaditaan synnytettyä ajoneuvoa.",
                dispatchReporters = "Ylläpitää tehtäväkohtaisia ilmoittajien nimiä, takaisinsoittonumeroita ja hätäkeskuksen muistiinpanoja.",
            },
            extensions = {
                invalidSelection = "Virheellinen valinta: {value}",
                trainingSettings = {
                    description = "Määritä koulutuksen käyttöoikeudet, ilmoittautuminen, hyväksynnät ja kurssin suunnittelu tälle työlle.",
                    label = "Harjoitusasetukset",
                },
                dispatchReporters = "Tunnetut ilmoittajat",
                dispatchChannels = "Radiokanavat",
                dispatchKeywords = "Asiasanat ja vastaussuunnitelmat",
                dispatchPois = "LÄHTÖPOIKEUDET",
                dispatchSettings = {
                    description = "Määritä lähetysyhteys, hätävarasisäänotto ja oletusradiokanava.",
                    label = "Lähetyksen asetukset",
                },
                dispatchStatusCodes = "Tilakoodit",
                dispatchVehicleTypes = "Välitysajoneuvotyypit",
                dispatchVehicles = "Lähtökalustoa koskevat tiedot",
                emptyDescription = "Luo ensimmäinen merkintä yllä olevalla lisäyspainikkeella.",
                emptyTitle = "Mitään ei ole vielä määritetty",
            },
            features = {
                bleeding = {
                    description = "Ota verenvuotojärjestelmä käyttöön.",
                    label = "Verenvuoto",
                },
                bodybags = {
                    description = "Ota käyttöön vartalopussien ja vartalopussien toimitusvirrat.",
                    label = "Vartalolaukut",
                },
                consciousScenarioBloodPressure = {
                    description = "Salli verenpaineen mittaukset potilaan ollessa tajuissaan.",
                    label = "Tietoinen verenpaine",
                },
                deathTimeout = {
                    description = "Ota kuoleman aikakatkaisuvirta käyttöön.",
                    label = "Kuoleman aikakatkaisu",
                },
                fractures = {
                    description = "Ota murtumien käsittely ja hoito käyttöön.",
                    label = "Murtumia",
                },
                knockout = {
                    description = "Ota knockout-järjestelmä käyttöön.",
                    label = "Pudotus",
                },
                legShotRagdoll = {
                    description = "Pelaaja kaatuu osumasta määritettyihin jalan tai jalkaterän alueisiin.",
                    label = "Kaatuminen jalkaosumasta",
                },
                pain = {
                    description = "Ota kipujärjestelmä käyttöön.",
                    label = "Kipu",
                },
                respawnInBed = {
                    description = "Respawn elvytti pelaajat sairaalavuoteessa, kun mahdollista.",
                    label = "Respawn sängyssä",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Työn näyttäminen hätäpuhelusovelluksessa edellyttää, että hälytystoiminto on käytössä. Ota se käyttöön tai poista työn näkyvyys hätäpuhelusovelluksessa hälytysasetuksista.",
                dispatchJobNotCovered = "Mikään käytössä oleva hätäkeskus ei kata työtä ”{job}”. Lisää ”{job}” tiedostossa sky_jobs_base/config/config.lua sopivan Config.Dispatch.centers-profiilin coveredJobs-listaan ja käynnistä sky_jobs_base uudelleen. Asetusten palauttaminen ei muuta tätä määritystä.",
                invalidDispatchChannels = "Radiokanavien tunnusten on oltava yksilöllisiä ja jokaisella kanavalla on oltava kelvollinen nimi.",
                invalidDispatchDefaultChannel = "Oletusradiokanavaa ei ole olemassa. Valitse hälytysasetuksissa olemassa oleva kanava tai ”Ei mitään”.",
                invalidDispatchKeywords = "Vastesuunnitelmilla on oltava yksilölliset koodit ja kelvolliset TYYPPI:MÄÄRÄ-vaatimukset.",
                invalidDispatchPois = "Kohteiden tunnusten, nimien ja koordinaattien on oltava kelvollisia ja yksilöllisiä.",
                invalidDispatchRadioButtons = "Tarkista radion toimintopainikkeet: käytä kutakin tuettua painiketta vain kerran ja valitse toiminto sen luettelosta.",
                invalidDispatchRadioFmsKeys = "Tarkista radion FMS-näppäimet: käytä kutakin näppäintä (0-9, * tai #) vain kerran ja määritä sille olemassa oleva tilakoodi tai jätä se määrittämättä.",
                invalidDispatchReadyStatus = "Valitse hälytysasetuksissa valmiuden tilakoodi, joka on merkitty saatavilla olevaksi tilakoodien luettelossa.",
                invalidDispatchReporters = "Tunnettujen ilmoittajien tiedot ylittävät sallitun määrän tai kenttien pituudet.",
                invalidDispatchRespondingStatus = "Valitse hälytysasetuksissa tehtävälle lähdön tilakoodi, joka on merkitty varatuksi tilakoodien luettelossa.",
                invalidDispatchSettings = "Valitse olemassa oleva vapaa valmiustila, varattu vastetila ja kelvollinen oletuskanava.",
                invalidDispatchStatusCodes = "FMS-koodien on oltava yksilöllisiä ja vähintään yhden tilan on oltava vapaa.",
                invalidDispatchVehicleTypes = "Vasteyksiköiden tyyppikoodien on oltava yksilöllisiä ja täydellisiä.",
                invalidDispatchVehicles = "Yksikkötunnusten ja kutsutunnusten on oltava yksilöllisiä ja kaikkien tyyppi- ja asemaviittausten on oltava olemassa.",
            },
            settingFields = {
                gang = "Jengi",
                allowInVehicle = "Salli ajoneuvossa",
                allowMovement = "Salli liikkuminen",
                animDict = "Animaatiosanakirja",
                animFlag = "Animaatiolippu",
                animName = "Animaation nimi",
                bleeding = "Verenvuoto",
                cause = "Syy",
                chance = "Todennäköisyys",
                class = "Luokka",
                companyPrice = "Yrityshinta",
                companyPricePerEmployee = "Hinta työntekijää kohden",
                copayPercent = "Copay %",
                description = "Kuvaus",
                dictionary = "Animaatio sanakirja",
                duration = "Kesto",
                durationMs = "Kesto (ms)",
                effect = "Vaikutus",
                effectDurationMs = "Vaikutuksen kesto (ms)",
                effectDurationSeconds = "Vaikutuksen kesto (sekuntia)",
                enabled = "Aktiivinen",
                extractionType = "Poistotyyppi",
                foreignObject = "Vieras esine",
                heal = "Parannus",
                id = "ID",
                itemName = "Kohteen nimi",
                key = "Avain",
                label = "Etiketti",
                lang = "Kieli",
                limit = "Raja",
                lossPerSecond = "Menetys sekunnissa",
                max = "Maksimi",
                min = "Vähimmäismäärä",
                minGrade = "Min arvosana",
                minigame = "Minipeli",
                model = "Prop malli",
                name = "Työn nimi",
                options = "Vaihtoehdot (valintatyypit)",
                pain = "Kipu",
                pauseBleedingSeconds = "Keskeytä verenvuoto (sekuntia)",
                price = "Hinta",
                progressbarAllowInVehicle = "Edistyminen: salli ajoneuvossa",
                progressbarAllowMovement = "Edistyminen: salli liikkuminen",
                progressbarCanCancel = "Edistyminen peruutettavissa",
                progressbarDisableCarMovement = "Edistyminen: estä ajoneuvon liike",
                progressbarDisableCombat = "Edistyminen: estä taistelu",
                progressbarDisableMouse = "Edistyminen: estä hiiri",
                progressbarDisableMovement = "Edistyminen: estä liike",
                progressbarDisableSprint = "Edistyminen: estä juoksu",
                progressbarDuration = "Edistymisen kesto",
                progressbarEnabled = "Edistymispalkki käytössä",
                progressbarLabel = "Edistymispalkin teksti",
                progressbarUseWhileDead = "Käytettävissä kuolleena",
                questions = "Kysymyksiä",
                requireItems = "Vaadi kohteita",
                required = "Vaaditaan",
                requiresExtraction = "Vaatii poiston",
                requiresOpenWound = "Vaatii avohaavan",
                sort = "Järjestys",
                state = "Tila",
                stopBleeding = "Pysäytä verenvuoto",
                threshold = "Kynnys",
                time = "Aika",
                type = "Tyyppi",
                useAnimation = "Käytä animaatiota",
                value = "Arvo",
                zone = "Alue",
                zones = "Alueet",
                systolic = "Systolinen verenpaine",
                diastolic = "Diastolinen verenpaine",
                cardiacArrest = "Sydänpysähdys",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Kenraali",
                },
                billingRange = {
                    label = "Alue",
                },
                billingReasons = {
                    label = "Syy Esiasetukset",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animaatio",
                },
                bodyBagAttachGeneral = {
                    label = "Liittää",
                },
                bodyBagAttachOffsets = {
                    label = "Offsetit",
                },
                bodyBagAttachRotation = {
                    label = "Kierto",
                },
                bodyBagDeliveryGeneral = {
                    label = "Kenraali",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Kenraali",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Maksu",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Kenraali",
                },
                crutchAssign = {
                    label = "Tehtävä",
                },
                crutchDuration = {
                    label = "Kesto",
                },
                crutchGeneral = {
                    label = "Kenraali",
                },
                crutchItems = {
                    label = "Tuote",
                },
                crutchRestrictions = {
                    label = "Rajoitukset",
                },
                damageHandlingBladeWeapons = {
                    label = "Terä-aseet",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Verenvuoto musta lista",
                },
                damageHandlingBleedingClasses = {
                    label = "Verenvuotoluokat",
                },
                damageHandlingBloodSystem = {
                    label = "Verijärjestelmä",
                },
                damageHandlingDeathInjuries = {
                    label = "Kuoleman vammat",
                },
                damageHandlingInjuryEffects = {
                    label = "Vahinkovaikutukset",
                },
                damageHandlingInjuryThresholds = {
                    label = "Loukkaantumiskynnykset",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Jalkalaukaus-ragdoll",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Jalkalaukausalueet",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Elävien vaurioiden murtumat",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Alueen mahdollisuudet",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Avohaavapinot",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Aluerajat",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Live haavaluokat",
                },
                damageHandlingMedications = {
                    label = "Lääkkeet",
                },
                damageHandlingPainClasses = {
                    label = "Kipuluokat",
                },
                damageHandlingPainEffects = {
                    label = "Kipuvaikutukset",
                },
                damageHandlingStatusEffects = {
                    label = "Tilatehosteet",
                },
                damageHandlingVehicleDamage = {
                    label = "Ajoneuvon vauriot",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Vahinkojen syyt",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Vammat",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Ajoneuvojen törmäyssuoja",
                },
                deathAnimal = {
                    label = "Eläinten peräänajo",
                },
                deathAnimalAnimation = {
                    label = "Eläinanimaatio",
                },
                deathAnimation = {
                    label = "Animaatio",
                },
                deathGeneral = {
                    label = "Kenraali",
                },
                deathModels = {
                    label = "Mallin ohitukset",
                },
                deathScreenAiMedic = {
                    label = "Kenraali",
                },
                deathScreenAiMedicAvailability = {
                    label = "Saatavuus",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Käyttäytyminen",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Voiman elvyttäminen",
                },
                deathScreenAiMedicPayment = {
                    label = "Maksu",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Revive Sängyssä",
                },
                deathScreenAiMedicSpawn = {
                    label = "Spawn",
                },
                deathScreenAiMedicTiming = {
                    label = "Ajoitus",
                },
                deathScreenControls = {
                    label = "Säätimet",
                },
                deathScreenDamageLogs = {
                    label = "Vahinkolokit",
                },
                deathScreenDimensions = {
                    label = "Mitat",
                },
                deathScreenDispatch = {
                    label = "Lähettää",
                },
                deathScreenEarlyRespawn = {
                    label = "Kenraali",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Saatavuus",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Maksu",
                },
                deathScreenGeneral = {
                    label = "Kenraali",
                },
                deathScreenHospitalSelection = {
                    label = "Sairaalan valinta",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Kameran valinta",
                },
                deathScreenInformation = {
                    label = "Kenraali",
                },
                deathScreenIntegration = {
                    label = "Integraatio",
                },
                deathScreenLogs = {
                    label = "Kuolemalokit",
                },
                deathScreenMinigame = {
                    label = "Minipeli",
                },
                deathScreenRespawn = {
                    label = "Kenraali",
                },
                deathScreenRespawnAccounts = {
                    label = "Tilit",
                },
                deathScreenRespawnFallback = {
                    label = "Varakoordinaatit",
                },
                deathScreenRespawnItems = {
                    label = "Tuotteet",
                },
                deathScreenRespawnWeapons = {
                    label = "Aseet",
                },
                deathScreenStyle = {
                    label = "Death Screen -tyyli",
                },
                deathScreenVoice = {
                    label = "Ääni",
                },
                deathTimeoutGeneral = {
                    label = "Kenraali",
                },
                deathTimeoutWhitelist = {
                    label = "Sallitut työpaikat",
                },
                diagnoseAnim = {
                    label = "Animaatio",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Täysi parannus",
                },
                diagnoseGeneral = {
                    label = "Kenraali",
                },
                doctorNpcAvailability = {
                    label = "Saatavuus",
                },
                doctorNpcGeneral = {
                    label = "Kenraali",
                },
                doctorNpcHealOther = {
                    label = "Paranna muut",
                },
                doctorNpcHealSelf = {
                    label = "Paranna itsesi",
                },
                doctorNpcRanges = {
                    description = "Nämä alueet eivät hallitse sitä, kuinka lähellä pelaajan tulee olla lääkärin NPC-vuorovaikutuksen avaamiseksi. Ne tulevat voimaan vasta lääkärivalikon avauduttua.",
                    label = "Alueet",
                },
                doctorNpcRevive = {
                    label = "Elvyttää",
                },
                doctorNpcReviveInBed = {
                    label = "Revive Sängyssä",
                },
                firstAidAnimation = {
                    label = "Animaatio",
                },
                firstAidGeneral = {
                    label = "Kenraali",
                },
                firstAidLicenseAdd = {
                    label = "Lisenssi Lisää",
                },
                firstAidLicenseRemove = {
                    label = "Lisenssi Poista",
                },
                firstAidPosition = {
                    label = "asema",
                },
                healthInsuranceExpiration = {
                    label = "Vanheneminen",
                },
                healthInsuranceGeneral = {
                    label = "Kenraali",
                },
                healthInsurancePayment = {
                    label = "Maksu",
                },
                healthInsuranceProviders = {
                    label = "Palveluntarjoajat",
                },
                hospitalBedsBedAnimation = {
                    label = "Bed Animaatio",
                },
                hospitalBedsCreator = {
                    label = "Luoja",
                },
                hospitalBedsDistances = {
                    label = "Etäisyydet",
                },
                hospitalBedsGeneral = {
                    label = "Kenraali",
                },
                hospitalBedsGetupAnimation = {
                    label = "Getup-animaatio",
                },
                hospitalBedsModels = {
                    label = "Mallit",
                },
                hospitalBedsOffsets = {
                    label = "Offsetit",
                },
                hospitalBlip = {
                    label = "Sairaala Blip",
                },
                imagingGeneral = {
                    label = "Kenraali",
                },
                imagingRanges = {
                    label = "Alueet",
                },
                keybinds = {
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                    label = "Näppäimet",
                },
                knockoutGeneral = {
                    label = "Kenraali",
                },
                knockoutWeapons = {
                    label = "Aseet",
                },
                medicCarryAttach = {
                    label = "Liittää",
                },
                medicCarryAttachOffsets = {
                    label = "Offsetit",
                },
                medicCarryAttachRotation = {
                    label = "Kierto",
                },
                medicCarryCarrierAnimation = {
                    label = "Carrier-animaatio",
                },
                medicCarryGeneral = {
                    label = "Kenraali",
                },
                medicCarryPassengerAnimation = {
                    label = "Matkustaja-animaatio",
                },
                medicCarryRestrictions = {
                    label = "Rajoitukset",
                },
                medicRevivePersistence = {
                    label = "Kenraali",
                },
                medicalEvaluationRecipients = {
                    label = "Vastaanottajan ammatit",
                },
                medicalEvaluationSharing = {
                    label = "Jaetut kentät",
                },
                medicalEvaluationTypes = {
                    label = "Arviointityypit",
                },
                medicalEvaluationsGeneral = {
                    label = "Kenraali",
                },
                medicalWearablesArmRestrictions = {
                    label = "Käsikipsin rajoitukset",
                },
                medicalWearablesCasts = {
                    label = "Kipsit",
                },
                medicalWearablesDuration = {
                    label = "Käyttöaika",
                },
                medicalWearablesGeneral = {
                    label = "Yleiset",
                },
                medicalWearablesHeadBandage = {
                    label = "Pääside",
                },
                medicalWearablesLegRestrictions = {
                    label = "Jalkakipsin rajoitukset",
                },
                medicalWearablesNeckBrace = {
                    label = "Niskatuki",
                },
                medicalWearablesOxygenMask = {
                    label = "Happimaski",
                },
                medicalWearablesPatientHud = {
                    label = "Potilaan HUD",
                },
                medicalWearablesRemoval = {
                    label = "Poistaminen",
                },
                medicalWearablesSplints = {
                    label = "Lastat",
                },
                medicalWearablesTorsoBandage = {
                    label = "Vartaloside",
                },
                minigamesCprGeneral = {
                    label = "Kenraali",
                },
                minigamesEnabled = {
                    label = "Käytössä",
                },
                minigamesVentilationGeneral = {
                    label = "Kenraali",
                },
                operationsAnesthesia = {
                    label = "Anestesia",
                },
                operationsDistances = {
                    label = "Etäisyydet",
                },
                operationsDoctorAnimation = {
                    label = "Kirurgin animaatio",
                },
                operationsGeneral = {
                    label = "Yleiset",
                },
                operationsPatientAnimation = {
                    label = "Potilaan animaatio",
                },
                operationsTrainingAnimation = {
                    label = "Harjoitusanimaatio",
                },
                propPlacement = {
                    label = "Prop Sijoitus",
                },
                propPlacementItems = {
                    label = "Prop kohteet",
                },
                publicTreatmentGeneral = {
                    label = "Kenraali",
                },
                publicTreatmentJobs = {
                    label = "Sallitut työpaikat",
                },
                publicTreatmentRequirements = {
                    label = "Vaatimukset",
                },
                reviveRewardGeneral = {
                    label = "Kenraali",
                },
                reviveRewardPayment = {
                    label = "Maksu",
                },
                selfDiagnoseGeneral = {
                    label = "Kenraali",
                },
                stretcherAnimation = {
                    label = "Animaatio",
                },
                stretcherCarryAttach = {
                    label = "Kanna kiinnitys",
                },
                stretcherFolded = {
                    label = "Taitettu Variantti",
                },
                stretcherFoldedPatientAttach = {
                    label = "Taitettu potilasliitin",
                },
                stretcherGeneral = {
                    label = "Kenraali",
                },
                stretcherHelicopter = {
                    label = "Helikopteri",
                },
                stretcherPatientAttach = {
                    label = "Potilasliite",
                },
                stretcherTreatmentAnim = {
                    label = "Animaatio",
                },
                stretcherVehicleAttach = {
                    label = "Ajoneuvon kiinnitys",
                },
                stretcherVehicleLists = {
                    label = "Ajoneuvomallit",
                },
                treatmentAnim = {
                    label = "Animaatio",
                },
                treatmentEnable = {
                    label = "Ota käyttöön",
                },
                trunk = {
                    label = "Runko",
                },
                vehiclePullGeneral = {
                    label = "Kenraali",
                },
                wheelchairAssign = {
                    label = "Tehtävä",
                },
                wheelchairDuration = {
                    label = "Kesto",
                },
                wheelchairGeneral = {
                    label = "Kenraali",
                },
                wheelchairItems = {
                    label = "Tuote",
                },
                wheelchairRestrictions = {
                    label = "Rajoitukset",
                },
                xrayGeneral = {
                    label = "Kenraali",
                },
                xrayRanges = {
                    label = "Alueet",
                },
                appointmentsGeneral = {
                    label = "Kenraali",
                },
                appointmentsLimits = {
                    label = "Rajat",
                },
                appointmentsNotifications = {
                    label = "Ilmoitukset",
                },
                appointmentsScheduling = {
                    label = "Aikataulutus",
                },
                healthCompatibility = {
                    label = "Terveysyhteensopivuus",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Kenraali",
                },
                minigamesRandomization = {
                    label = "Satunnaistaminen",
                },
            },
            settingSections = {
                billing = "Laskutus",
                bodyBag = "Ruumispussi",
                damageHandling = "Vahinkojen käsittely",
                death = "Kuolema",
                deathScreen = "Kuoleman näyttö",
                diagnose = "Diagnoosi",
                doctorNpc = "Tohtori NPC",
                general = "Kenraali",
                healthInsurance = "Sairausvakuutus",
                hospitalBeds = "Sairaalan sängyt",
                knockout = "Pudotus",
                medicCarry = "Lääkinnällinen kanto",
                minigames = "Minipelejä",
                mobilityAid = "Liikkumisen apuvälineet",
                operations = "Leikkaukset",
                organization = "Organisaatio",
                rewards = "Palkinnot",
                treatment = "Hoito",
                vehiclePull = "Ajoneuvon vetäminen",
            },
            settingSubsections = {
                aiMedic = "AI Lääkäri",
                anesthesia = "Anestesia",
                animation = "Animaatio",
                animations = "Animaatiot",
                attach = "Liittää",
                bedAnimation = "Bed Animaatio",
                blood = "Veri",
                bodyBagDeliveryReward = "Body Bag Toimituspalkinto",
                carrierAnimation = "Carrier-animaatio",
                classification = "Luokitus",
                cpr = "CPR",
                crutch = "Kainalosauva",
                deathInjuries = "Kuoleman vammat",
                deathScreenStyle = "Death Screen -tyyli",
                deathTimeout = "Kuoleman aikakatkaisu",
                delivery = "Toimitus",
                diagnoseAnim = "Diagnosoi animaatio",
                dispatch = "Lähettää",
                earlyRespawn = "Varhainen herääminen",
                effects = "Tehosteet",
                firstAid = "Ensiapu",
                general = "Kenraali",
                getupAnimation = "Getup-animaatio",
                imaging = "Kuvantaminen",
                information = "Tiedot",
                keybinds = "Näppäimet",
                liveDamage = "Elävät vahingot",
                logs = "Lokit",
                medicRevivePersistence = "Lääkinnällinen elvytys kestää",
                medicalEvaluations = "Lääketieteelliset lausunnot",
                medicalWearables = "Hoitoapuvälineet",
                medications = "Lääkkeet",
                minigame = "Minipeli",
                passengerAnimation = "Matkustaja-animaatio",
                pricing = "Hinnoittelu",
                propPlacement = "Prop Sijoitus",
                publicTreatment = "Julkinen hoito",
                respawn = "Herää",
                reviveInBed = "Revive Sängyssä",
                reviveReward = "Elvytä palkinto",
                selfDiagnose = "Itsediagnoosi",
                stretcher = "Paarit",
                stretcherTreatmentAnim = "Stretcher Treatment -animaatio",
                thresholds = "Kynnykset",
                treatmentAnim = "Hoito-animaatio",
                trunk = "Runko",
                vehicleImpact = "Ajoneuvon vaikutus",
                ventilation = "Ilmanvaihto",
                wheelchair = "Pyörätuoli",
                xray = "X-Ray",
                appointments = "Tapaamiset",
                bloodTransfusion = "Verensiirto",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Muokkain · Ohjain 172",
                    description = "Asetukset: Editori: Siirry eteenpäin.",
                },
                ambulanceEditorControl173 = {
                    label = "Muokkain · Ohjain 173",
                    description = "Asetukset: Editori: Siirry alas.",
                },
                ambulanceEditorControl174 = {
                    label = "Muokkain · Ohjain 174",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl175 = {
                    label = "Muokkain · Ohjain 175",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl177 = {
                    label = "Muokkain · Ohjain 177",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl201 = {
                    label = "Muokkain · Ohjain 201",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl202 = {
                    label = "Muokkain · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl21 = {
                    label = "Muokkain · Ohjain 21",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl32 = {
                    label = "Muokkain · Ohjain 32",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl33 = {
                    label = "Muokkain · Ohjain 33",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl34 = {
                    label = "Muokkain · Ohjain 34",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl35 = {
                    label = "Muokkain · Ohjain 35",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl36 = {
                    label = "Muokkain · Ohjain 36",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl37 = {
                    label = "Muokkain · Ohjain 37",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl38 = {
                    label = "Muokkain · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceEditorControl44 = {
                    label = "Muokkain · Ohjain 44",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Ensiapu · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Vuorovaikutus · Ohjain 177",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Vuorovaikutus · Ohjain 201",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Vuorovaikutus · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Vuorovaikutus · Ohjain 21",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Vuorovaikutus · Ohjain 241",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Vuorovaikutus · Ohjain 242",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Vuorovaikutus · Ohjain 25",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Vuorovaikutus · Ohjain 32",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Vuorovaikutus · Ohjain 33",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Vuorovaikutus · Ohjain 34",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Vuorovaikutus · Ohjain 35",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Vuorovaikutus · Ohjain 36",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Vuorovaikutus · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Vuorovaikutus · Ohjain 44",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                billingAccount = {
                    description = "Laskutukseen käytetty perinteinen varayhteisötili.",
                    label = "Tili",
                },
                billingCloseOnSuccess = {
                    description = "Sulje laskutuskäyttöliittymä automaattisesti onnistuneen laskun jälkeen.",
                    label = "Lähellä menestystä",
                },
                billingCurrency = {
                    description = "Valinnainen valuuttaavain, jota käytetään laskutusmaksuihin.",
                    label = "Valuutta",
                },
                billingCustomBillingReasons = {
                    description = "Salli lääkäreiden syöttää mukautettuja laskutussyitä.",
                    label = "Mukautetut syyt",
                },
                billingDepositToSociety = {
                    description = "Talleta laskutustulot yhdistyksen tilille.",
                    label = "Talletus yhteiskunnalle",
                },
                billingEnabled = {
                    description = "Ota lääketieteen laskutusjärjestelmä käyttöön.",
                    label = "Käytössä",
                },
                billingMaxReasonLength = {
                    description = "Muokatun laskutussyiden enimmäispituus.",
                    label = "Syyn enimmäispituus",
                },
                billingMode = {
                    description = "Valitse, veloitetaanko lääkelaskut välittömästi, vaativatko ne vahvistuksen vai käytäkö laskutuskehysjärjestelmää.",
                    label = "Laskutustila",
                    options = {
                        consent = "Maksa tai hylkää",
                        framework = "Puitelaki",
                        instant = "Välitön lataus",
                    },
                },
                billingRange = {
                    description = "Maksimialue laskutettavien potilaiden löytämiseen.",
                    label = "Alue",
                },
                billingReasonPresets = {
                    description = "Esiasetetut laskutussyyt näkyvät laskutuksen käyttöliittymässä.",
                    itemLabel = "Syy",
                    label = "Syyn esiasetukset",
                },
                billingRefreshSeconds = {
                    description = "Sekunnit laskutettavan pelaajan päivitysten välillä.",
                    label = "Päivitä sekuntia",
                },
                bladeWeapons = {
                    description = "Aseiden nimet tai tiivisteet, jotka tulisi luokitella veitsen vaurioiksi tylsyyden sijaan.",
                    itemLabel = "Ase",
                    label = "Terä-aseet",
                },
                bleedingBlacklist = {
                    description = "Aseet, joiden ei pitäisi koskaan aiheuttaa verenvuotoa tai avoimia haavoja.",
                    itemLabel = "Ase",
                    label = "Verenvuoto musta lista",
                },
                bleedingClassesProfiles = {
                    description = "Verenvuodon vakavuusprofiilit ja niiden verenhukka.",
                    label = "Verenvuototunnit",
                },
                bloodSystemDebugLogInterval = {
                    description = "Verijärjestelmän virheenkorjauslokiviestien välinen aika.",
                    label = "Virheenkorjauslokin aikaväli",
                },
                bloodSystemMaxVolume = {
                    description = "Potilastilajärjestelmän käyttämä suurin veritilavuuden arvo.",
                    label = "Suurin äänenvoimakkuus",
                },
                bloodSystemRegenPerSecond = {
                    description = "Passiivinen veren regeneraatio, jota käytetään, kun potilas ei vuoda aktiivisesti.",
                    label = "Regen sekunnissa",
                },
                bloodSystemTickIntervalMs = {
                    description = "Palvelimen tarkistusväli, jota käytetään verenhukan ja palautuksen päivityksiin.",
                    label = "Tikkuväli ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Veritilavuuden kynnys, jonka alapuolella potilas menettää tajuntansa.",
                    label = "Tajuton kynnys",
                },
                bodyBagAnimationDict = {
                    description = "Animaatiosanakirja, jota käytetään ruumislaukun kantamiseen.",
                    label = "Animaatio sanakirja",
                },
                bodyBagAnimationEnabled = {
                    description = "Käytä erityistä kantoanimaatiota, kun kannat vartalolaukkua.",
                    label = "Käytössä",
                },
                bodyBagAnimationFlag = {
                    description = "Kantoanimaatiossa käytetty TaskPlayAnim-lippu.",
                    label = "Animaatio lippu",
                },
                bodyBagAnimationName = {
                    description = "Animaatioklipsi, jota käytetään vartalokassin kantamiseen.",
                    label = "Animaation nimi",
                },
                bodyBagAttachBone = {
                    description = "Ped-luun nimi tai luun tunnus, jota käytetään ruumispussin kiinnitykseen.",
                    label = "Luu",
                },
                bodyBagAttachRx = {
                    description = "Body bag kiinnittää X kierto.",
                    label = "Kiinnitä RX",
                },
                bodyBagAttachRy = {
                    description = "Body bag kiinnitys Y-kierto.",
                    label = "Kiinnitä RY",
                },
                bodyBagAttachRz = {
                    description = "Body bag kiinnittää Z-kierto.",
                    label = "Kiinnitä RZ",
                },
                bodyBagAttachX = {
                    description = "Body bag kiinnitys X offset.",
                    label = "Kiinnitä X",
                },
                bodyBagAttachY = {
                    description = "Body bag kiinnitys Y offset.",
                    label = "Kiinnitä Y",
                },
                bodyBagAttachZ = {
                    description = "Body bag kiinnittää Z offset.",
                    label = "Kiinnitä Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Ruumislaukun palautuskehotteessa käytetty kieliavain.",
                    label = "Ohjetarra-avain",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Etäisyys, jota käytetään vartalopussin luovutuksen vahvistamiseen.",
                    label = "Vuorovaikutusetäisyys",
                },
                bodyBagDeliveryInteractKey = {
                    description = "Ohjaustunnus, jota käytetään vartalopussin luovutusvuorovaikutuksiin.",
                    label = "Vuorovaikutusnäppäin",
                },
                bodyBagDeliveryInteraction = {
                    description = "Vuorovaikutusmalliavain, jota käytetään vartalokassin luovuttamiseen.",
                    label = "Vuorovaikutusmalli",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Vaadi lääkäreitä luovuttamaan ruumispussit määritellyissä luovutuspisteissä.",
                    label = "Vaadi palautus",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Vaadi lääkäreitä päivystykseen ennen ruumispussin toimittamista.",
                    label = "Vaadi päivystyksessä",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Ensisijainen tiliavain, jota käytetään vartalopussin toimituspalkkioihin.",
                    label = "Tili",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Ensisijainen tilityyppi, jota käytetään vartalopussin toimituspalkkioihin.",
                    label = "Tilin tyyppi",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Palkintosumma, joka maksetaan vartalopussin toimituksesta.",
                    label = "Määrä",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään vartalopussin toimituspalkkioihin.",
                    label = "Valuutta",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Maksa määritetty palkinto, kun vartalopussi on toimitettu.",
                    label = "Käytössä",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Vähennä vartalopussin toimituspalkkiot yhteisestä työyhteisöstä ennen kuin maksat lääkärille.",
                    label = "Palkkaa yhteiskunnalta",
                },
                bodyBagEnabled = {
                    description = "Ota vartalopussijärjestelmä käyttöön.",
                    label = "Käytössä",
                },
                bodyBagHidePatient = {
                    description = "Piilota potilaan ped, kun vartalopussi on kiinnitettynä.",
                    label = "Piilota potilas",
                },
                bodyBagModel = {
                    description = "Vartalopusseihin käytetty tukimalli.",
                    label = "Malli",
                },
                bodyBagPatientAlpha = {
                    description = "Alfa levitettiin potilaaseen vartalopussissa.",
                    label = "Potilas alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Suurin etäisyys kainalosauvojen määrittämiseksi toiselle pelaajalle.",
                    label = "Määritä maksimietäisyys",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Irrota kainalosauva automaattisesti, kun toimeksianto päättyy.",
                    label = "Automaattinen laitteiden purkaminen vanhentuessa",
                },
                crutchClipset = {
                    description = "Liikkeenpidike kiinnitetty kainalosauvaa käytettäessä.",
                    label = "Leikesarja",
                },
                crutchDefaultDurationMinutes = {
                    description = "Oletusarvoisesti määritetty kainalosauvojen kesto minuutteina.",
                    label = "Oletuskesto",
                },
                crutchDisableSprint = {
                    description = "Estä sprintti, kun kainalosauva on varustettu.",
                    label = "Poista sprintti käytöstä",
                },
                crutchDisableWeapons = {
                    description = "Estä aseen käyttö, kun kainalosauva on varustettu.",
                    label = "Poista aseet käytöstä",
                },
                crutchItemName = {
                    description = "Varastossa käytetty tavara.",
                    label = "Kohteen nimi",
                },
                crutchMaxDurationMinutes = {
                    description = "Sallittu kainalosauvojen enimmäiskesto minuutteina.",
                    label = "Max kesto",
                },
                crutchMinDurationMinutes = {
                    description = "Pienin sallittu kainalosauvojen kesto minuutteina.",
                    label = "Minimikesto",
                },
                crutchProp = {
                    description = "Sauvaan käytetty potkurimalli.",
                    label = "Rekvisiitta",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Sekunnit, joiden aikana yksittäiset osumat kootaan yhteen viestiin.",
                    label = "Koontiväli",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Yksittäisten osumien enimmäismäärä Discord-viestissä.",
                    label = "Osumia viestissä",
                },
                damageLogsEnabled = {
                    description = "Lähetä palvelimen vahvistamat ei-kuolettavat osumat Discordiin.",
                    label = "Vahinkolokit",
                },
                deathAnimalAnimationDictionary = {
                    description = "Animaatiosanakirja, jota käytetään eläinten varakuoleman animaatiossa.",
                    label = "Eläinten sanakirja",
                },
                deathAnimalAnimationName = {
                    description = "Animaatioleike, jota käytetään eläinten varakuoleman animaatiossa.",
                    label = "Eläimen animaation nimi",
                },
                deathAnimalUseAnimation = {
                    description = "Salli määritetyn eläimen varaosan käyttää käsikirjoitettua kuolemaanimaatiota.",
                    label = "Eläinanimaatio",
                },
                deathAnimationDictionary = {
                    description = "Animaatiosanakirja, jota käytetään kuoleman oletusanimaatiossa.",
                    label = "Animaatio sanakirja",
                },
                deathAnimationName = {
                    description = "Animaatioleike, jota käytetään kuoleman oletusanimaatiossa.",
                    label = "Animaation nimi",
                },
                deathInjuriesProfiles = {
                    description = "Loukkaantumisprofiileja käytetään, kun pelaaja kuolee tietystä syystä.",
                    itemLabel = "Vahinko",
                    label = "Kuolemanvammat",
                },
                deathModels = {
                    description = "Ohita kuolemaanimaatiokäyttäytyminen ped-mallin tai mallin tiivisteen mukaan.",
                    label = "Malli ohittaa",
                },
                deathScreenAiMedicAccount = {
                    description = "Tekoälylääkärin ensisijainen tili.",
                    label = "Tili",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Sekunnit lisätään vuodatusajastimeen, kun tekoälylääkäriä pyydetään.",
                    label = "Lisää kuoleman ajastin",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Anna tekoälylääkärin elvyttää kuolemaan johtaneet haavat.",
                    label = "Salli tappavat haavat",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Etäisyys, jolla tekoälylääkäri pysähtyy ja lähestyy kävellen.",
                    label = "Lähestymisetäisyys",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Jäähdytys ennen kuin tekoälylääkäri voidaan kutsua uudelleen.",
                    label = "Jäähdytyksen sekuntia",
                },
                deathScreenAiMedicCurrency = {
                    description = "Valinnainen valuuttaavain, jota käytetään tekoälylääkärin maksuihin.",
                    label = "Valuutta",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Tekoälylääkäreiden maksuihin käytetty valuuttaformaatti.",
                    label = "Valuutan muotoilija",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Sekuntia ennen kuin tekoälylääkäri lopettaa loppunsa.",
                    label = "Despawn viive",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Viive ennen kuin tekoälylääkärin lähetys alkaa.",
                    label = "Lähetyksen viive",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Tekoälyajoneuvon käyttämä ajonopeus.",
                    label = "Ajonopeus",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Enimmäisajoaika ennen pakotettua elvytyslaukaisua.",
                    label = "Ajon aikakatkaisu",
                },
                deathScreenAiMedicEnabled = {
                    description = "Ota tekoälyn pelastusvirta käyttöön.",
                    label = "Käytössä",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Varatiliä käytetään, kun ensisijaisella tekoälylääkäritilillä ei ole riittävästi varoja.",
                    label = "Varatili",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Pakota elvytys, jos tekoälylääkäri ei tavoita soitinta.",
                    label = "Pakota elvytys käytössä",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "AI medic toimii vain silloin, kun päivystävät lääkärit ovat tämän määrän tasolla tai sen alapuolella.",
                    label = "Max lääkärit verkossa",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Tehtävän enimmäiskesto ennen pakko-elvyttämistä.",
                    label = "Tehtävän aikakatkaisu",
                },
                deathScreenAiMedicPedModel = {
                    description = "Ped-malli, jota käytetään tekoälylääkärille.",
                    label = "Ped malli",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Kohde, kun kaatunut pelaaja kutsuu AI-lääkärin itse.",
                    label = "Pelaajapyynnön kohde",
                    options = {
                        hospital = "Sairaala",
                        location = "Nykyinen sijainti",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Tekoälylääkärille soittamisesta veloitetaan hinta.",
                    label = "Hinta",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Sekunnit pelaajan kuolemasta ennen kuin lääkäri voi tarjota etä-AI-lääkäriä.",
                    label = "Etälähetyksen odotus",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Salli lääkäreiden lähettää tekoälylääkäri kaatuneelle pelaajalle lähetyskartalta ja /aimedic-komennosta.",
                    label = "Etälähetys",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "Tekoälylääkäreiden etälähetys toimii vain silloin, kun päivystävät lääkärit ovat tämän määrän tasolla tai sen alapuolella.",
                    label = "Enintään lääkäreiden etälähetys verkossa",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Kohde, kun etä-AI-lääkäri lähetetään ja hyväksytään.",
                    label = "Etälähetyksen kohde",
                    options = {
                        hospital = "Sairaala",
                        location = "Nykyinen sijainti",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Sekunnit, joiden aikana pelaaja voi hyväksyä etä-AI-lääkärin tarjouksen.",
                    label = "Etätarjouksen aikakatkaisu",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Etäisyys vaaditaan ennen kuin tekoälylääkäri alkaa elpyä.",
                    label = "Elvytä etäisyys",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Pelaajan elvyttämiseen käytetty sekunti.",
                    label = "Elvytyksen kesto",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teleportoi pelaaja sairaalasänkyyn sen sijaan, että elvytät paikan päällä.",
                    label = "Herätä sängyssä",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Elvyttävän sängyn löytämiseen käytetty hakusäde.",
                    label = "Sängyn hakusäde",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Sekunteja kuoleman jälkeen ennen kuin tekoälylääkäri tulee saataville.",
                    label = "Sekuntia käytettävissä",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Tekoälylääkärin suurin syntysäde.",
                    label = "Kutusäde max",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Tekoälylääkärin vähimmäissäde.",
                    label = "Kutusäde min",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Tekoälylääkärin käyttämä ajoneuvomalli.",
                    label = "Ajoneuvon malli",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Äänitila tajuttomana: ei mitään, kuuntele tai täynnä.",
                    label = "Äänitila",
                    options = {
                        full = "koko",
                        listen = "kuunnella",
                        none = "ei yhtään",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Ohjaustunnukset, jotka pysyvät käytössä tajuttomana.",
                    label = "Sallitut säätimet",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Palauttaa pelaajat automaattisesti uudelleen, jos vuotoajastin on jo umpeutunut, kun yhteys katkaistiin.",
                    label = "Auto-respawn vanhentunut yhdistäminen uudelleen",
                },
                deathScreenBackgroundEnd = {
                    description = "Kuoleman näytön taustan loppuväri.",
                    label = "Tausta loppu",
                },
                deathScreenBackgroundStart = {
                    description = "Kuoleman näytön taustan aloitusväri.",
                    label = "Aloitus taustalla",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Sekuntia ennen kuin tyhjennysajastin umpeutuu.",
                    label = "Tyhjennysajastin",
                },
                deathScreenBlockedDimensions = {
                    description = "Mitat, joissa kuolemanäytön uudelleensyntymisvirta on estetty.",
                    label = "Estetyt mitat",
                },
                deathScreenBorderColor = {
                    description = "Kuolemanäytön käyttämä reunaväri.",
                    label = "Reunuksen väri",
                },
                deathScreenDispatchEnabled = {
                    description = "Lähetä lähetystapahtumat kuolemannäytön virtauksesta.",
                    label = "Lähetys käytössä",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Varavastaanottajat, kun yksikään ensisijainen vastaanottaja ei ole elossa ja työvuorossa. Jätä tyhjäksi, jos hälytys lähetetään aina ensisijaisille tehtäville.",
                    itemLabel = "Tehtävä",
                    label = "Varatehtävät",
                },
                deathScreenDispatchJobs = {
                    description = "Työt, jotka hälytetään, kun toimintakyvytön pelaaja pyytää apua.",
                    itemLabel = "Työ",
                    label = "Hälytettävät työt",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Ensisijainen tili, joka veloitetaan varhaisesta uudelleensyntymisestä.",
                    label = "Tili",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Pidä varhainen respawn saatavilla jopa kuolemaan johtavien haavojen varalta.",
                    label = "Salli tappavat haavat",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Valinnainen valuuttaavain, jota käytetään varhaisiin uudelleensyntymismaksuihin.",
                    label = "Valuutta",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Valuutan muotoilija, jota käytetään varhaisiin uudelleensyntymismaksuihin.",
                    label = "Valuutan muotoilija",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Ota käyttöön maksettu varhainen uudelleensyntyminen.",
                    label = "Käytössä",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Varatiliä käytetään, kun ensisijaisella tilillä ei ole riittävästi varoja.",
                    label = "Varatili",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Valinnainen tarra, joka näytetään varhaisen uudelleensyntymismaksun yhteydessä.",
                    label = "Maksun etiketti",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Hinta veloitetaan varhaisesta uudelleensyntymisestä.",
                    label = "Hinta",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Salli varhainen uudelleensyntyminen vain, kun lääkäreitä ei ole päivystetty.",
                    label = "Ei vaadi lääkäreitä",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Sekunteja kuoleman jälkeen ennen kuin varhainen uudelleensyntyminen tulee saataville.",
                    label = "Sekuntia käytettävissä",
                },
                deathScreenEnableKeyboard = {
                    description = "Salli näppäimistön käyttö kuolemannäytössä.",
                    label = "Ota näppäimistö käyttöön",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Ulkoinen taustaääni mykistyy, kun se on käytössä.",
                    label = "Ulkoinen äänijärjestelmä",
                    options = {
                        saltychat = "Saltychat",
                        yaca = "yaca",
                    },
                },
                deathScreenFocusKey = {
                    label = "Kuolemanäkymän hiiriohjaus",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                deathScreenHandlingMode = {
                    description = "Käytä staattista kuolinanimaatiota tai säilytä luonnollinen ragdoll-fysiikka, kunnes keho on vakaa.",
                    label = "Kuoleman käsittely",
                    options = {
                        natural = "Luonnollinen",
                        static = "Staattinen",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Piilottaa kuolinruudun, kun VÄLILYÖNTI vaihtaa pelin ohjaimiin; poista asetus käytöstä säilyttääksesi aiemman näkyvän näkymän.",
                    label = "Piilota näkymä peliohjaimilla",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Korkeuspoikkeama käytetty kameran tarkennuskohteeseen.",
                    label = "Tarkennuksen korkeus",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Esikatsele kameran näkökenttää.",
                    label = "Näkökenttä",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Esikatselukameraa asetettaessa käytetään suunnan siirtymää.",
                    label = "Suuntapoikkeama",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Esikatselukamerassa käytetty korkeuspoikkeama.",
                    label = "Kameran korkeus",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Äänenkorkeus kohdistettu esikatselukameraan.",
                    label = "Piki",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Etäisyys esikatselukamerasta syntypisteeseen.",
                    label = "Kameran säde",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Käytä sujuvaa siirtymää, kun avaat sairaalan valintakameran.",
                    label = "Tasainen siirtymä",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Anna pelaajien valita sairaala ennen uudelleensyntymistä.",
                    label = "Sairaalan valinta",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Näytä sairaalavalinta vain, jos sairaalassa on useampi kuin yksi.",
                    label = "Vaatii useita sairaaloita",
                },
                deathScreenInformationEnabled = {
                    description = "Näytä tietolohko kuolemannäytössä.",
                    label = "Käytössä",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Näytä kuolinsyy kuolemannäytön tietolohkossa.",
                    label = "Näytä kuolinsyy",
                },
                deathScreenInformationShowInjuries = {
                    description = "Näytä vammat kuolemannäytön tietolohkossa.",
                    label = "Näytä vammat",
                },
                deathScreenInformationShowKiller = {
                    description = "Näytä tappajan nimi kuolemannäytön tietolohkossa.",
                    label = "Näytä tappaja",
                },
                deathScreenInformationShowWeapon = {
                    description = "Näytä ase kuolemannäytön tietolohkossa.",
                    label = "Näytä ase",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Hyväksytyt jengit",
                    description = "Valitse jengien tai itsenäisten organisaatioiden sisäiset nimet. Vastaava työ tai jengi antaa luvan tai poikkeuksen. Työvuorovaatimus koskee vain töitä.",
                    itemLabel = "Jengi",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Työpaikat saavat nähdä laajennetun kuolemannäytön tiedot.",
                    itemLabel = "Työ",
                    label = "Sallitut työpaikat",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Kunkin kuolemakuvan latauksen enimmäisaika sekunteina.",
                    label = "Kuvakaappauksen aikakatkaisu",
                },
                deathScreenLogScreenshots = {
                    description = "Lataa uhrin ja vahvistetun tappajan näkymät tekstilokin jälkeen.",
                    label = "Kuvakaappaukset",
                },
                deathScreenLogsEnabled = {
                    description = "Lähetä Discord-loki aina pelaajan kuollessa.",
                    label = "Kuolemalokit",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Etäisyys metreinä, jota käytettiin lääkärin laskemiseen lähellä olevaksi.",
                    label = "Lääkäri lähistöllä",
                },
                deathScreenMinigameEnabled = {
                    description = "Ota kuolemanäytön minipeli käyttöön.",
                    label = "Käytössä",
                },
                deathScreenMinigameUrl = {
                    description = "URL avattu kuolemannäytön minipelille.",
                    label = "Minipelin URL-osoite",
                },
                deathScreenMode = {
                    description = "Käytä sisäänrakennettua kuolemanäkymää tai ulkoista integraatiota.",
                    label = "Näyttötila",
                    options = {
                        external = "Ulkoinen",
                        internal = "Sisäinen",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Mykistä ulkoiset äänijärjestelmät, kun soitin on kuollut.",
                    label = "Mykistä ulkoinen ääni",
                },
                deathScreenMutedTextColor = {
                    description = "Kuolinnäytön käyttämä mykistetty tekstiväri.",
                    label = "Mykistetty tekstin väri",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Tulostaa yksityiskohtaiset asiakas- ja palvelinsyyt, kun keho pysyy ragdoll-tilassa.",
                    label = "Luonnollisen ragdollin vianjäljitys",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Vakauta paikalleen jäänyt keho automaattisesti tai vaadi työvuorossa oleva lääkintähenkilö asettamaan potilas kylkiasentoon.",
                    label = "Luonnollinen vakautus",
                    options = {
                        automatic = "Automaattinen",
                        medic = "Lääkintähenkilö vaaditaan",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Kuolemanäytön käyttämä paneelin taustaväri.",
                    label = "Paneelin tausta",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Estä automaattinen uudelleensyntyminen vuotamisen jälkeen.",
                    label = "Estä automaattinen uudelleensyntyminen",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Estä automaattinen respawn, kun lääkäri on lähellä.",
                    label = "Estä, kun lääkäri on lähellä",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Esto herää uudelleen, kun tyhjennysajastin umpeutuu.",
                    label = "Estä elpyminen voimassaolon päätyttyä",
                },
                deathScreenPrimaryColor = {
                    description = "CSS-perusväri, jota käytetään kuolemannäytön teemassa.",
                    label = "Pääväri",
                },
                deathScreenPrimaryDark = {
                    description = "Valinnainen tummempi korostusväri kuolemannäytölle.",
                    label = "Ensisijainen tumma",
                },
                deathScreenPrimaryStrong = {
                    description = "Valinnainen vahvempi korostusväri kuolemannäytölle.",
                    label = "Ensisijainen vahva",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Suunta käytetään, kun asemalle ei ole määritetty suuntaa.",
                    label = "Oletusotsikko",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Vararespawn-otsikkoa käytetään, kun sairaalapaikkoja ei ole.",
                    label = "Vara-otsikko",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Vararespawn X-koordinaatti, jota käytetään, kun sairaalapaikkoja ei ole.",
                    label = "Vara X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Vararespawn Y-koordinaatti, jota käytetään, kun sairaalapaikkoja ei ole.",
                    label = "Vara Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Vararespawn Z-koordinaatti, jota käytetään, kun sairaalapaikkoja ei ole.",
                    label = "Vara Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Valitse uudelleensyntymistä varten kiinteä sairaala. Jätä se tyhjäksi käyttääksesi lähintä sairaalaa.",
                    label = "Respawn sairaala",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Poista tilisaldot uudelleensyntymisen yhteydessä.",
                    label = "Poista tilit",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Tilien nimet poistettiin uudelleensyntymisen yhteydessä.",
                    itemLabel = "Tili",
                    label = "Tilien nimet",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Poista varastotuotteet uudelleensyntymisen yhteydessä.",
                    label = "Poista kohteita",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Varastotuotteet, joita pidettiin uudelleen syntymässä.",
                    itemLabel = "Tuote",
                    label = "Ohitetut kohteet",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Poista asepyörän aseet uudelleensyntyessä.",
                    label = "Poista aseet",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Aseet syntyivät uudelleen.",
                    itemLabel = "Ase",
                    label = "Aseet huomioimatta",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teleportoi pelaaja sairaalaan uudelleensyntymisen yhteydessä.",
                    label = "Teleportaa sairaalaan",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Jatka vuodatusajastinta uudelleenkytkennän jälkeen sen nollaamisen sijaan.",
                    label = "Jatka yhteyden muodostamisen yhteydessä",
                },
                deathScreenShadowLight = {
                    description = "Pehmeä varjoväri, jota kuolemanäyttö käyttää.",
                    label = "Varjon valo",
                },
                deathScreenShadowMid = {
                    description = "Kuolemannäytön käyttämä keskivarjon väri.",
                    label = "Varjo keskellä",
                },
                deathScreenShowNearestMedic = {
                    description = "Näytä lähin lääkäri kuolemannäytöllä.",
                    label = "Näytä lähin lääkäri",
                },
                deathScreenTextColor = {
                    description = "Ensisijainen tekstin väri, jota kuolemanäyttö käyttää.",
                    label = "Tekstin väri",
                },
                deathScreenTextShadow = {
                    description = "Kuolemanäytön käyttämä tekstin varjoväri.",
                    label = "Tekstin varjo",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Käytä kuoleman aikakatkaisua myös knockout-elvytyksen jälkeen.",
                    label = "Levitä knockoutissa",
                },
                deathTimeoutSeconds = {
                    description = "Sekuntia elvyttämisen jälkeen taistelu pysyy poissa käytöstä.",
                    label = "Sekuntia",
                },
                deathTimeoutShowUi = {
                    description = "Näytä kuoleman aikakatkaisun lähtölaskentabanneri aktiivisena.",
                    label = "Näytä käyttöliittymä",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Hyväksytyt jengit",
                    description = "Valitse jengien tai itsenäisten organisaatioiden sisäiset nimet. Vastaava työ tai jengi antaa luvan tai poikkeuksen. Työvuorovaatimus koskee vain töitä.",
                    itemLabel = "Jengi",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Työpaikat on vapautettu kuoleman aikakatkaisurajoituksista.",
                    itemLabel = "Työ",
                    label = "Sallitut työpaikat",
                },
                deathUseAnimation = {
                    description = "Toista määritetty kuolemaanimaatio tuetuille pedeille.",
                    label = "Käytä animaatiota",
                },
                diagnoseAnimClip = {
                    description = "Diagnoosia avattaessa käytetty animaatioleike. Jätä tyhjäksi, jos haluat käyttää sen sijaan skenaariota.",
                    label = "Animaation nimi",
                },
                diagnoseAnimDict = {
                    description = "Animaatiosanakirja, jota käytettiin diagnoosia avattaessa. Jätä tyhjäksi, jos haluat käyttää sen sijaan skenaariota.",
                    label = "Animaatio sanakirja",
                },
                diagnoseAnimScenario = {
                    description = "Diagnoosia avattaessa käytetty skenaario. Jätä tyhjäksi, jos haluat käyttää sen sijaan dict + clip -näppäintä.",
                    label = "Skenaario",
                },
                diagnoseCprAnimDict = {
                    description = "Elvytykseen käytetty animaatiosanakirja.",
                    label = "Animaatio sanakirja",
                },
                diagnoseCprAnimName = {
                    description = "Elvytykseen käytetty animaatioleike.",
                    label = "Animaation nimi",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Täyden parannuksen näyttämiseen vaadittu yhtäjaksoinen diagnoosiaika.",
                    label = "Viive sekunteina",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Vaadi pelastusreppu",
                    description = "Vaadi rescue_backpack vasemman tutkimustyökalupalkin näyttämiseen. Poista käytöstä, jotta palkki näkyy aina; yksittäisten työkalujen esinevaatimukset pysyvät voimassa.",
                },
                diagnoseFullHealEnabled = {
                    description = "Sallii täyden parannuksen yhtäjaksoisen diagnoosin jälkeen.",
                    label = "Käytössä",
                },
                diagnoseInteractDistance = {
                    description = "Enimmäisetäisyys, joka vaaditaan diagnoosin tekemiseen tai potilaan pussitukseen.",
                    label = "Vuorovaikutusetäisyys",
                },
                diagnosePatientMovementMode = {
                    label = "Potilaan liikkuminen",
                    description = "Estä potilaan liikkuminen toisen pelaajan pitäessä hoitovalikkoa auki tai salli liikkuminen ja sulje valikko hoitoetäisyyden ylittyessä. Itsediagnoosin asetukset määritetään erikseen.",
                    options = {
                        freeze = "Estä potilaan liikkuminen",
                        distance = "Sulje etäisyysrajan ylittyessä",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Hoitoetäisyys (m)",
                    description = "Hoitavan pelaajan ja potilaan enimmäisetäisyys, jonka ylittyessä hoitovalikko sulkeutuu etäisyystilassa. Valikon avaamisetäisyys määritetään erikseen.",
                },
                diagnoseKey = {
                    description = "Kontrollitunnus, jota käytetään vuorovaikutusten diagnosointiin.",
                    label = "Vuorovaikutusnäppäin",
                },
                diagnoseOpenDelayMs = {
                    description = "Viive ennen diagnoosin käyttöliittymän avautumista.",
                    label = "Avausviive ms",
                },
                diagnosePromptDistance = {
                    description = "Diagnoosikehotteen näyttämiseen käytetty etäisyys.",
                    label = "Nopea etäisyys",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Hoitoanimaatioissa käytetty kesto.",
                    label = "Hoidon kesto ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Talleta lääkärimaksut osakeyhdistyksen tilille, kun laskutat suoraan.",
                    label = "Lisää tuloja yhteiskunnalle",
                },
                doctorNpcEnabled = {
                    description = "Ota lääkärin NPC-palvelu käyttöön.",
                    label = "Käytössä",
                },
                doctorNpcHealOtherAccount = {
                    description = "Ensisijainen tiliavain, jota käytetään toisen pelaajan parantamisen veloittamiseen.",
                    label = "Tili",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Ensisijainen tilityyppi, jolla veloitetaan toisen pelaajan parantaminen.",
                    label = "Tilin tyyppi",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään toisen pelaajan parantamisen veloittamiseen.",
                    label = "Valuutta",
                },
                doctorNpcHealOtherPrice = {
                    description = "Hinta toisen pelaajan parantamisesta lääkärin NPC:ssä.",
                    label = "Hinta",
                },
                doctorNpcHealSelfAccount = {
                    description = "Ensisijainen tiliavain, jota käytetään itseparannuksen veloittamiseen.",
                    label = "Tili",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Ensisijainen tilityyppi, jota käytetään itseparannuksen veloittamiseen.",
                    label = "Tilin tyyppi",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään itseparannuksen lataamiseen.",
                    label = "Valuutta",
                },
                doctorNpcHealSelfPrice = {
                    description = "Hinta parantaa itseäsi lääkärissä NPC.",
                    label = "Hinta",
                },
                doctorNpcInteractionRange = {
                    description = "Kuinka lähellä käyttäjän on pysyttävä lääkärin NPC:ssä, kun hän käyttää avointa lääkärivalikkoa. Tämä ei muuta alkuperäistä NPC-kehotteen etäisyyttä.",
                    label = "Vuorovaikutusalue",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Doctor NPC toimii vain, kun päivystävät lääkärit ovat tämän rajan alapuolella.",
                    label = "Max lääkärit verkossa",
                },
                doctorNpcPatientRange = {
                    description = "Kuinka lähellä potilaan tulee olla lääkärin NPC:tä parantaakseen muita tai elvyttääkseen toimiakseen toimenpiteen valinnan jälkeen.",
                    label = "Potilasalue",
                },
                doctorNpcPaymentMode = {
                    description = "Veloita pelaajia välittömästi tai lähetä lasku.",
                    label = "Maksutapa",
                    options = {
                        bill = "laskuttaa",
                        remove = "poistaa",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Käytetään vain lähellä olevien pelaajien luetteloimiseen lääkärin NPC-käyttöliittymässä. Se ei salli hoitoa itsestään.",
                    label = "Soittimen skannausalue",
                },
                doctorNpcReviveAccount = {
                    description = "Ensisijainen tiliavain, jolla laskutetaan lääkärin elvytyksiä.",
                    label = "Tili",
                },
                doctorNpcReviveAccountType = {
                    description = "Ensisijainen tilityyppi, jolla veloitetaan lääkärin elvytyksiä.",
                    label = "Tilin tyyppi",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Salli NPC-lääkärin elvyttää kuolettavia tai elvytyskelvottomia vammoja. Vuotoajan umpeutuminen estää edelleen elvytyksen.",
                    label = "Salli kuolettavat vammat",
                },
                doctorNpcReviveCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään lääkärin elvytyksen lataamiseen.",
                    label = "Valuutta",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Aseta elvytetyt pelaajat lähimpään sairaalasänkyyn lääkärin elvyttämisen jälkeen.",
                    label = "Käytössä",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Suurin etäisyys, jolla löydetään läheinen sairaalasänky lääkärin elvyttämistä varten.",
                    label = "Haun säde",
                },
                doctorNpcRevivePrice = {
                    description = "Hinta tohtori NPC:n pelaajan elvyttämisestä.",
                    label = "Hinta",
                },
                firstAidActionDurationMs = {
                    description = "Kuinka kauan ensiaputoimenpide kestää.",
                    label = "Toiminnon kesto ms",
                },
                firstAidAnimationDict = {
                    description = "Animaatiosanakirja, jota käytetään ensiaputoimenpiteen aikana.",
                    label = "Animaatio sanakirja",
                },
                firstAidAnimationFlag = {
                    description = "Ensiaputoimenpiteen aikana käytetty TaskPlayAnim-lippu.",
                    label = "Animaatio lippu",
                },
                firstAidAnimationName = {
                    description = "Ensiaputoimenpiteen aikana käytetty animaatioleike.",
                    label = "Animaation nimi",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Sekunnit lisätään potilaan verenvuotoajastimeen ensiavun jälkeen.",
                    label = "Bleedout-pidennys sekuntia",
                },
                firstAidEnabled = {
                    description = "Ota ensiapuominaisuus käyttöön lisensoiduille pelaajille.",
                    label = "Ensiapu käytössä",
                },
                firstAidLicense = {
                    description = "Puitelisenssin nimi, jota käytetään ensiavun saannin vahvistamiseen.",
                    label = "Lisenssin nimi",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Anna ambulanssihenkilökunnan antaa ensiapulupa.",
                    label = "Lisää lisenssi käytössä",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Näytä lisälisenssitoiminto säteittäisessä valikossa.",
                    label = "Lisää lisenssi radial",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Vaadi EMS-toimintaa ennen kuin lisälisenssitoimintoa voidaan käyttää.",
                    label = "Lisää lisenssi edellyttää tullia",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Anna ambulanssihenkilökunnan poistaa ensiapulupa.",
                    label = "Poista lisenssi käytössä",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Näytä lisenssinpoistotoiminto säteittäisessä valikossa.",
                    label = "Poista lisenssiradiaali",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Vaadi EMS-toimintaa ennen kuin poista-lisenssi -toimintoa voidaan käyttää.",
                    label = "Lisenssin poistaminen edellyttää tullia",
                },
                firstAidPositionChestOffset = {
                    description = "Rintapoikkeamaa käytetään ensiapua varten kohdistettaessa.",
                    label = "Rintakehän siirtymä",
                },
                firstAidPositionSideOffset = {
                    description = "Sivupoikkeamaa käytetään kohdistamisessa ensiapua varten.",
                    label = "Sivupoikkeama",
                },
                firstAidPositionZOffset = {
                    description = "Pystysuuntainen siirtymä, jota käytetään kohdistamisessa ensiapua varten.",
                    label = "Z-offset",
                },
                firstAidRequireLicense = {
                    description = "Vaadi määritetty ensiapulisenssi ennen kuin pelaaja voi käyttää ensiapua.",
                    label = "Vaadi lisenssi",
                },
                firstAidTargetDistance = {
                    description = "Suurin sallittu etäisyys ensiapua varten.",
                    label = "Tavoiteetäisyys",
                },
                healthInsuranceAccount = {
                    description = "Varatilin avain, jota käytetään vakuutusmaksuihin.",
                    label = "Tili",
                },
                healthInsuranceAccountType = {
                    description = "Ensisijainen tilityyppi, jota käytetään vakuutusmaksuihin.",
                    label = "Tilin tyyppi",
                },
                healthInsuranceAvailableDays = {
                    description = "Vakuutusajat päivinä.",
                    label = "Vapaat päivät",
                },
                healthInsuranceCommand = {
                    description = "Chat-komentoa käytetään sairausvakuutuksen käyttöliittymän avaamiseen.",
                    label = "Komento",
                },
                healthInsuranceCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään vakuutusmaksuihin.",
                    label = "Valuutta",
                },
                healthInsuranceEnabled = {
                    description = "Ota sairausvakuutusjärjestelmä käyttöön.",
                    label = "Käytössä",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Sallii valtuutettujen työntekijöiden muuttaa vakuutushintoja tabletissa. Poista käytöstä käyttääksesi alla olevan palveluntarjoajataulukon hintoja.",
                    label = "Hintojen hallinta tabletissa",
                },
                healthInsuranceProviders = {
                    description = "Pelaajille tarjotut vakuutuksenantajat.",
                    itemLabel = "Palveluntarjoaja",
                    label = "Palveluntarjoajat",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Käyttää samoja palveluntarjoajia ja vakuutuksia kaikissa tähän ensihoitoresurssiin rekisteröidyissä töissä.",
                    label = "Jaa ensihoitotöiden kesken",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Animaatiosanakirjaa pyöritetään pelaajan makaaessa sängyllä. Jätä tyhjäksi, jos haluat käyttää oletusarvoista kuolemaanimaatiota.",
                    label = "Animaatio sanakirja",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Valinnainen manuaalinen kesto silmukkasänky-animaatiolle. Käytetään vain, kun mukautettu sänkyanimaatio on määritetty.",
                    label = "Kesto ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "TaskPlayAnim-lippu, jota käytetään silmukan sänky-animaatiossa. Käytetään vain, kun mukautettu sänkyanimaatio on määritetty.",
                    label = "Animaatio lippu",
                },
                hospitalBedsBedAnimationName = {
                    description = "Animaatioleike silmukassa, kun soitin makaa sängyllä. Jätä tyhjäksi, jos haluat käyttää oletusarvoista kuolemaanimaatiota.",
                    label = "Animaation nimi",
                },
                hospitalBedsBreakDistance = {
                    description = "Etäisyys, jonka jälkeen pelaaja pakotetaan pois sängystä.",
                    label = "Taukoetäisyys",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Esikatsele sairaalasänkyjen sijainnin editorissa käytettyä ped-mallia.",
                    label = "Creator ped malli",
                },
                hospitalBedsEnabled = {
                    description = "Ota käyttöön määritetyt sairaalavuodevuorovaikutukset.",
                    label = "Käytössä",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Animaatiosanakirja, jota pelataan, kun pelaaja nousee sängystä. Jätä tyhjäksi, jos haluat käyttää oletusarvoista seisontatoimintoa.",
                    label = "Animaatio sanakirja",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Valinnainen manuaalinen kesto nousuanimaatiolle. Käytetään vain, kun mukautettu käynnistysanimaatio on määritetty.",
                    label = "Kesto ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "TaskPlayAnim-lippu, jota käytetään nousuanimaatiossa. Käytetään vain, kun mukautettu käynnistysanimaatio on määritetty.",
                    label = "Animaatio lippu",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Animaatioleike, joka toistetaan, kun pelaaja nousee ylös sängystä. Jätä tyhjäksi, jos haluat käyttää oletusarvoista seisontatoimintoa.",
                    label = "Animaation nimi",
                },
                hospitalBedsHeadingOffset = {
                    description = "Suuntapoikkeama käytetään, kun soitin asetetaan sängylle.",
                    label = "Suuntapoikkeama",
                },
                hospitalBedsHeightOffset = {
                    description = "Pystysuuntainen siirtymä, kun soitin asetetaan sängylle.",
                    label = "Korkeuspoikkeama",
                },
                hospitalBedsInteractDistance = {
                    description = "Sairaalavuoteen käyttöön vaadittava enimmäisetäisyys.",
                    label = "Vuorovaikutusetäisyys",
                },
                hospitalBedsInteractKey = {
                    description = "Kontrollitunnus, jota käytetään sairaalasänkyyn menemiseen tai sieltä poistumiseen.",
                    label = "Vuorovaikutusnäppäin",
                },
                hospitalBedsModels = {
                    description = "Maailman esinemalleja käsitelty käyttökelpoisina sairaalasänkyinä.",
                    itemLabel = "Malli",
                    label = "Sänkymallit",
                },
                hospitalBedsSearchRadius = {
                    description = "Säteellä etsittiin lähellä olevat sängyn rekvisiitta tai konfiguroidut sängyt.",
                    label = "Haun säde",
                },
                hospitalBlipColor = {
                    description = "Blip-väritunnus, jota käytetään sairaalakartan blipeissä.",
                    label = "Väri",
                },
                hospitalBlipEnabled = {
                    description = "Näytä sairaalakartan merkit konfiguroiduille sairaalapaikoille.",
                    label = "Käytössä",
                },
                hospitalBlipName = {
                    description = "Varasairaalalipun nimeä käytetään, kun aseman nimeä ei ole saatavilla.",
                    label = "Nimi",
                },
                hospitalBlipScale = {
                    description = "Sairaalakarttojen mittakaava.",
                    label = "Mittakaava",
                },
                hospitalBlipSprite = {
                    description = "Blip sprite -tunnus, jota käytetään sairaalan karttablipseihin.",
                    label = "Kuvake",
                },
                imagingInteractionRange = {
                    description = "Käyttäjän suurin etäisyys kuvantamisasemasta.",
                    label = "Vuorovaikutusalue",
                },
                imagingPatientRange = {
                    description = "Potilaan enimmäisetäisyys kuvantamisasemasta.",
                    label = "Potilasalue",
                },
                imagingScanDurationSeconds = {
                    description = "CT- ja MRI-tulosten kesto sekunneissa.",
                    label = "Skannauksen kesto",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Vain visuaalinen kerroin verenvuotopeittoefekteille.",
                    label = "Verenvuotokerroksen intensiteetti",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Vain visuaalinen kerroin kipunäytön tehosteille.",
                    label = "Kipunäytön intensiteetti",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Pienin prosenttiosuus maksimiterveydestä, joka menetetään yhdellä osumalla ennen verenvuodon ja kivun levittämistä.",
                    label = "Verenvuoto/kipu min prosenttia",
                },
                injuryThresholdRespectArmor = {
                    description = "Ohita verenvuoto ja kipu, kun panssari absorboi osuman.",
                    label = "Kunnioita panssaria",
                },
                knockoutRegenerateDamage = {
                    description = "Regeneroi knockout-vauriot uudelleensyntymisajastimen umpeutumisen jälkeen.",
                    label = "Regeneroi vahinko",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Sekuntia, jonka aikana knockout-vauriot parantuvat takaisin.",
                    label = "Regeneroinnin kesto",
                },
                knockoutRespawnSeconds = {
                    description = "Sekuntia ennen automaattista uudelleensyntymistä, kun pelaaja putoaa.",
                    label = "Respawn sekuntia",
                },
                knockoutWeapons = {
                    description = "Aseiden nimet tai tiivisteet, joiden pitäisi laukaista tyrmäys koko kuolemannäytön sijaan.",
                    itemLabel = "Ase",
                    label = "Aseet",
                },
                legShotRagdollChance = {
                    description = "Prosenttimahdollisuus sille, etta osuma kaynnistaa ragdollin.",
                    label = "Mahdollisuus",
                },
                legShotRagdollCooldownMs = {
                    description = "Vahimmaisviive jalkalaukaus-ragdollien valilla.",
                    label = "Jäähdytys ms",
                },
                legShotRagdollDebug = {
                    description = "Kirjaa ragdoll-paatokset testausta varten.",
                    label = "Vianetsintä",
                },
                legShotRagdollDurationMs = {
                    description = "Kuinka kauan ragdoll kestaa.",
                    label = "Kesto ms",
                },
                legShotRagdollFeet = {
                    description = "Salli jalkateran osumat ragdollin laukaisijana.",
                    label = "Jalat",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Ohita ragdoll, jos haarniska absorboi osuman.",
                    label = "Ohita haarniskaosumat",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Salli osumat vasempaan saareen.",
                    label = "Vasen saari",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Salli osumat vasempaan ylaosaan jalkaa.",
                    label = "Vasen ylaosa jalka",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Vain laukaukset voivat kaynnistaa ragdollin.",
                    label = "Vain laukaukset",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Salli osumat oikeaan saareen.",
                    label = "Oikea saari",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Salli osumat oikeaan ylaosaan jalkaa.",
                    label = "Oikea ylaosa jalka",
                },
                liveDamageFracturesChance = {
                    description = "Perustodennäköisyys, että tietoinen vahinko osuu murtumaan.",
                    label = "Mahdollisuus",
                },
                liveDamageFracturesEnabled = {
                    description = "Salli tietoisten vaurioiden osuminen rullamurtumiin.",
                    label = "Käytössä",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Yhden osuman on vähennettävä vähintään tämä osuus enimmäisterveydestä ennen murtuman mahdollisuutta.",
                    label = "Vähimmäisvahinko prosentteina",
                },
                liveDamageFracturesZones = {
                    description = "Vyöhykekohtainen murtumamahdollisuudet elävälle vauriolle.",
                    label = "Alueen mahdollisuudet",
                },
                liveOpenWoundStacksDefault = {
                    description = "Avohaavapinojen enimmismaara per alue ilman aluekohtaista asetusta.",
                    label = "Oletusraja",
                },
                liveOpenWoundStacksZones = {
                    description = "Valinnaiset avohaavapinojen rajat alueittain.",
                    itemLabel = "Vyöhyke",
                    label = "Aluerajat",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Alkuperäinen verenvuotoluokka, jota sovelletaan elävän vaurion syyn mukaan.",
                    label = "Elävän haavan verenvuotoluokka",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Salli kantajan nousta ajoneuvoon ja ajaa laskematta potilasta alas.",
                    label = "Salli kantaja ajoneuvoon",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Salli tietoisten pelaajien kuljettaminen.",
                    label = "Salli tietoiset kohteet",
                },
                medicCarryAllowSprint = {
                    description = "Salli sprintti potilasta kantaessasi.",
                    label = "Salli sprintti",
                },
                medicCarryAttachBone = {
                    description = "Luuindeksi, jota käytetään kannettavan soittimen kiinnittämiseen.",
                    label = "Kiinnitä luu",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Kanna kiinnityskulman kiertoa.",
                    label = "Piki",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Kanna kiinnitysrullan kierto.",
                    label = "Rullaa",
                },
                medicCarryAttachOffsetsX = {
                    description = "Kanna liitä X offset.",
                    label = "Offset X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Kanna kiinnitys Y offset.",
                    label = "Poikkeama Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Kantoliittimen kiertosuunta.",
                    label = "Yrttikaali",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Kanna kiinnitys Z offset.",
                    label = "Ojenna Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Animaatiosanakirja, jota lääkäri käyttää potilasta kantaessaan.",
                    label = "Animaatio sanakirja",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Lääkärin käyttämä TaskPlayAnim-lippu.",
                    label = "Animaatio lippu",
                },
                medicCarryCarrierAnimationName = {
                    description = "Animaatioleike, jota lääkäri käyttää potilasta kantaessaan.",
                    label = "Animaation nimi",
                },
                medicCarryEnabled = {
                    description = "Ota lääketieteen kantojärjestelmä käyttöön.",
                    label = "Käytössä",
                },
                medicCarryMaxDistance = {
                    description = "Suurin etäisyys, joka vaaditaan potilaan hakemiseen.",
                    label = "Max etäisyys",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Kannettavan potilaan käyttämä animaatiosanakirja.",
                    label = "Animaatio sanakirja",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "TaskPlayAnim-lippu, jota kantoi potilasanimaatio.",
                    label = "Animaatio lippu",
                },
                medicCarryPassengerAnimationName = {
                    description = "Kannettavan potilaan käyttämä animaatioleike.",
                    label = "Animaation nimi",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Käytä kuolemaanimaatiota uudelleen tajuttoman potilaan pudottamisen jälkeen.",
                    label = "Käytä kuolemaanimaatiota uudelleen",
                },
                medicCarryRequireOnDuty = {
                    description = "Vain päivystävät lääkärit voivat aloittaa kuljetuksen.",
                    label = "Vaadi päivystyksessä",
                },
                medicReviveAllowFatalWounds = {
                    description = "Salli työvuorossa olevien ensihoitajien hoitaa ja elvyttää kuolettavia tai elvytyskelvottomia vammoja. Vuotoajan umpeutuminen estää edelleen elvytyksen.",
                    label = "Salli kuolettavat vammat",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Säilytä ratkaisemattomat vammat hoidon jälkeen tai tarkistuslista elvyttää.",
                    label = "Pidä vammat",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Säilytä kipuarvot hoidon jälkeen tai tarkistuslista elpyy, kun vammat säilyvät.",
                    label = "Pidä kipu",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Maksimimatka, jota käytetään läheisten pelaajien luettelemiseen lääketieteellistä arviointia luotaessa.",
                    label = "Lähistöllä potilasalue",
                },
                medicalEvaluationRecipientJobs = {
                    description = "ammatteja, joista voidaan tehdä lääketieteellisiä arviointeja ja joista voidaan jakaa.",
                    label = "Vastaanottavat työt",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Anna vastaanottaja-ammattien katsoa potilaan syntymäaika.",
                    label = "Osuus syntymäajasta",
                },
                medicalEvaluationShareConclusion = {
                    description = "Anna vastaanottaja-ammattien nähdä lääkärin päätelmä.",
                    label = "Osuuspäätelmä",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Anna vastaanottaja-ammattien katsoa, mitkä arviointityypit on suoritettu.",
                    label = "Osakkeiden arviointityypit",
                },
                medicalEvaluationShareFullName = {
                    description = "Anna vastaanottajan ammattihenkilöiden nähdä potilaan koko nimi.",
                    label = "Jaa koko nimi",
                },
                medicalEvaluationShareGender = {
                    description = "Anna vastaanottaja-ammattien nähdä potilaan sukupuoli.",
                    label = "Jakaudu sukupuolen mukaan",
                },
                medicalEvaluationShareHeight = {
                    description = "Anna vastaanottaja-ammattien nähdä potilaan pituus.",
                    label = "Jakautumiskorkeus",
                },
                medicalEvaluationShareHobbies = {
                    description = "Anna vastaanottaja-ammattien katsoa potilaan vapaa-ajanviettoa ja harrastuksia.",
                    label = "Jaa vapaa-aikaa ja harrastuksia",
                },
                medicalEvaluationShareIssuer = {
                    description = "Näytä tekijän nimi. Julkaiseva työ näkyy aina jaettujen asiakirjojen kansiona.",
                    label = "Jaa tekijän tiedot",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Anna vastaanottaja-ammattien katsoa potilaan henkilökohtaista ID:tä.",
                    label = "Jaa henkilökohtaiset ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Anna vastaanottaja-ammattien katsoa potilaan ammattia.",
                    label = "Osakeammatit",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Anna vastaanottaja-ammattilaisten nähdä kyselykysymyksiä ja tallennettuja vastauksia.",
                    label = "Jaa kysymyksiä ja vastauksia",
                },
                medicalEvaluationShareResult = {
                    description = "Anna vastaanottaja-ammattien katsoa, onko arviointi kesken, läpäissyt vai epäonnistunut.",
                    label = "Osaketulos",
                },
                medicalEvaluationShareWeight = {
                    description = "Anna vastaanottaja-ammattien nähdä potilaan paino.",
                    label = "Osakkeen paino",
                },
                medicalEvaluationTypes = {
                    description = "Määrittele arviointityypit, kysymykset, vastaustyypit ja se, onko jokainen kysymys aktiivinen.",
                    label = "Arviointityypit ja kyselyt",
                    options = {
                        boolean = "Kyllä / Ei",
                        boolean_text = "Kyllä / Ei yksityiskohtaisesti",
                        date = "Päivämäärä",
                        multi_select = "Monivalintaisuus",
                        number = "Numero",
                        rating = "Arvosana",
                        select = "Yksi vaihtoehto",
                        text = "Teksti",
                        textarea = "Tekstialue",
                        time = "Aika",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Aktivoi ambulanssitaulun lääketieteelliset arvioinnit.",
                    label = "Käytössä",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Tarjoaa pysyvän keston, joka jatkuu, kunnes ensihoitaja poistaa apuvälineen.",
                    label = "Salli poistamiseen asti",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Estää lähitaisteluhyökkäykset käsikipsin ollessa käytössä.",
                    label = "Estä lähitaistelu",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Pakottaa aseettomaksi ja estää aseen vaihtamisen käsikipsin ollessa käytössä.",
                    label = "Estä aseet",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Rajoittaa taistelua käsikipsin ollessa käytössä.",
                    label = "Käytössä",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Hoitaa sopivan murtuman, kun kipsi tai lasta asetetaan.",
                    label = "Murtumaintegraatio",
                },
                medicalWearablesCastsEnabled = {
                    description = "Sallii kipsit vasempaan ja oikeaan käteen sekä jalkaan.",
                    label = "Käytössä",
                },
                medicalWearablesCastsItem = {
                    description = "Kipsiä asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesCastsMinigame = {
                    description = "Kipseille käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Hoitoapuvälineen oletuskesto minuutteina. Arvo 0 tarkoittaa poistamiseen asti.",
                    label = "Oletusminuutit",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Ensihoitajille näytettävät hoitoapuvälineen kestot minuutteina.",
                    label = "Kestovaihtoehdot",
                },
                medicalWearablesEnabled = {
                    description = "Ottaa kipsi-, lasta-, side-, niskatuki- ja happimaskimallit käyttöön hoitonäkymässä.",
                    label = "Käytössä",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Kuinka usein vanhentuneet ajastetut hoitoapuvälineet poistetaan.",
                    label = "Voimassaolon tarkistus (sekuntia)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Sallii pääsidemallin.",
                    label = "Käytössä",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Pääsidettä asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Pääsiteelle käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Estää hyppäämisen jalkakipsin ollessa käytössä.",
                    label = "Estä hyppy",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Estää juoksemisen jalkakipsin ollessa käytössä.",
                    label = "Estä juoksu",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Pakottaa loukkaantuneen liikeanimaation jalkakipsin ollessa käytössä.",
                    label = "Pakota loukkaantunut kävely",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Korvaa liikkumisnopeuden jalkakipsin ollessa käytössä.",
                    label = "Liikkumisnopeus",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Rajoittaa liikkumista jalkakipsin ollessa käytössä.",
                    label = "Käytössä",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Sallii niskatukimallin.",
                    label = "Käytössä",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Niskatukea asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Niskatuelle käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Sallii happimaskimallin.",
                    label = "Käytössä",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Happimaskia asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Happimaskille käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Näyttää potilaalle aktiiviset hoitovälineet ja jäljellä olevan käyttöajan.",
                    label = "Käytössä",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Valitse potilaan hoitoväline-HUDin sijainti.",
                    label = "Sijainti",
                    options = {
                        ["bottom-center"] = "Alhaalla keskellä",
                        ["bottom-left"] = "Alhaalla vasemmalla",
                        ["bottom-right"] = "Alhaalla oikealla",
                        center = "Keskellä",
                        ["center-left"] = "Keskellä vasemmalla",
                        ["center-right"] = "Keskellä oikealla",
                        ["top-center"] = "Ylhäällä keskellä",
                        ["top-left"] = "Ylhäällä vasemmalla",
                        ["top-right"] = "Ylhäällä oikealla",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Palauttaa ajastetut kipsit, lastat, niskatuet ja vartalositeet uudelleenyhdistämisen ja resurssin uudelleenkäynnistyksen jälkeen.",
                    label = "Hoitoapuvälineiden säilyminen",
                },
                medicalWearablesRemoval = {
                    description = "Sallii ensihoitajien poistaa aktiiviset kipsit, lastat, niskatuet ja vartalositeet hoitonäkymässä.",
                    label = "Ensihoitajan poisto",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Näyttää hoitoapuvälineen poistamisen määritetyllä työkalulla hoitonäkymässä.",
                    label = "Poistohoito käytössä",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Hoitoapuvälineen poistamiseen tarvittava uudelleenkäytettävä varastotyökalu.",
                    label = "Esine",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minipeli lääkinnällisten apuvälineiden poistossa (oletus: cast_saw).",
                    label = "Minipeli",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Sallii kantosidelastat vasempaan ja oikeaan käteen.",
                    label = "Käytössä",
                },
                medicalWearablesSplintsItem = {
                    description = "Lastaa asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Lastoille käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Sallii vartalosidemallin.",
                    label = "Käytössä",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Vartalosidettä asetettaessa kulutettava varastoesine.",
                    label = "Esine",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Vartalositeelle käytettävä olemassa oleva hoitominipeli.",
                    label = "Minipeli",
                },
                medicationsProfiles = {
                    description = "Hoitoon ja itsehoitoon käytetyt ilmoitetut lääkemerkinnät.",
                    itemLabel = "Lääkitys",
                    label = "Lääkkeet",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Ota pussiventtiilimaskin minipeli käyttöön.",
                    label = "Pussiventtiilin maski",
                },
                minigamesCastSawEnabled = {
                    description = "Ottaa kipsisahaminipelin käyttöön lääkinnällisten apuvälineiden poistossa.",
                    label = "Kipsisaha",
                },
                minigamesBandageWrapEnabled = {
                    description = "Ota bandage wrap -minipeli käyttöön.",
                    label = "Kytkentäpaperi",
                },
                minigamesBloodPressureEnabled = {
                    description = "Ota verenpaineen minipeli käyttöön.",
                    label = "Verenpaine",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Ota verensiirron minipeli käyttöön.",
                    label = "Verensiirto",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Ota luodinpoistominipeli käyttöön.",
                    label = "Luodin poisto",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Hengitys vaaditaan jokaisen tuuletusvaiheen aikana.",
                    label = "Hengityksiä sykliä kohden",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Sekuntia yhden pakkaussarjan suorittamiseen.",
                    label = "Kompression kesto sarjaa kohti",
                },
                minigamesCprCompressionWindow = {
                    description = "Sallittu siirtymä puristuslyönnin osuessa.",
                    label = "Pakkausikkuna",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Ota käyttöön CPR-kompressioiden minipelivaihe.",
                    label = "Elvytyskompressiot",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Pakkausten lukumäärä sarjaa kohti.",
                    label = "Kompressiot per sarja",
                },
                minigamesCprCycles = {
                    description = "Kuinka monta elvytysjaksoa tarvitaan minipelin loppuun saattamiseksi.",
                    label = "Pyörät",
                },
                minigamesCprEnabled = {
                    description = "Ota CPR-minipeli käyttöön.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Lähtölaskenta ennen elvytyskompressioiden alkamista.",
                    label = "Intro viive sekunteja",
                },
                minigamesCprMaxMisses = {
                    description = "Poissaolot sallitaan ennen epäonnistumista elvytys-minipelissä.",
                    label = "Max kaipaa",
                },
                minigamesCprSetsPerCycle = {
                    description = "Kuinka monta puristussarjaa suoritetaan ennen hengitysvaihetta.",
                    label = "Sarja per sykli",
                },
                minigamesCprVentilationEnabled = {
                    description = "Ota käyttöön CPR-hengitysminipelivaihe.",
                    label = "CPR-hengitys",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Ota glukoosimittarin minipeli käyttöön.",
                    label = "Glukoosimittari",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Ota pulssimittauksen minipeli käyttöön.",
                    label = "Pulssin mittaus",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Ota pulssioksimetriminipeli käyttöön.",
                    label = "Pulssioksimetri",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Ota suolaliuoksen infuusiominipeli käyttöön.",
                    label = "Suolaliuos infuusio",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Sekuntia ennen tuuletusyritystä aikakatkaistaan. Aseta 0 poistaaksesi käytöstä.",
                    label = "Hengitysaikakatkaisu sekunteja",
                },
                minigamesVentilationEnabled = {
                    description = "Ota ventilaatiominipeli käyttöön.",
                    label = "Ilmanvaihto",
                },
                minigamesVentilationTolerance = {
                    description = "Pikselien etäisyyden toleranssi ilmavirran aaltoa jäljitettäessä.",
                    label = "Toleranssi",
                },
                operationsBreakDistance = {
                    description = "Enimmäisetäisyys osallistujista saliin ennen toimenpiteen keskeyttämistä.",
                    label = "Keskeytysetäisyys",
                },
                operationsDoctorAnimationDict = {
                    description = "GTA-animaatiosanakirja kirurgille oikean toimenpiteen aikana.",
                    label = "Kirurgianimaation sanakirja",
                },
                operationsDoctorAnimationFlag = {
                    description = "Kirurgin oikean toimenpiteen animaation GTA-animaatiolippu.",
                    label = "Kirurgianimaation lippu",
                },
                operationsDoctorAnimationName = {
                    description = "Animaatioleike kirurgille oikean toimenpiteen aikana.",
                    label = "Kirurgianimaation nimi",
                },
                operationsEnabled = {
                    description = "Ottaa leikkaussalit ja kirurgiset toimenpiteet käyttöön.",
                    label = "Käytössä",
                },
                operationsFadeInMs = {
                    description = "Potilaan näytön palautumisen kesto millisekunteina heräämisen aikana.",
                    label = "Heräämisen häivytys (ms)",
                },
                operationsFadeOutMs = {
                    description = "Potilaan näytön pimennyksen kesto millisekunteina anestesian aikana.",
                    label = "Anestesian häivytys (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Enimmäisaika ilman hyväksyttyä minipelitoimintoa ennen istunnon keskeyttämistä.",
                    label = "Toimettomuuden aikaraja (s)",
                },
                operationsInteractDistance = {
                    description = "Enimmäisetäisyys leikkaussalin vuorovaikutusten näyttämiseen ja käyttämiseen.",
                    label = "Vuorovaikutusetäisyys",
                },
                operationsInteractKey = {
                    description = "Ohjaustunnus leikkauspöydän ja kirurgin paikan vuorovaikutuksiin.",
                    label = "Vuorovaikutusnäppäin",
                },
                operationsPatientAnimationDict = {
                    description = "GTA-animaatiosanakirja potilaalle, joka makaa yleisanestesiassa.",
                    label = "Potilasanimaation sanakirja",
                },
                operationsPatientAnimationFlag = {
                    description = "Makaavan potilasanimaation GTA-animaatiolippu.",
                    label = "Potilasanimaation lippu",
                },
                operationsPatientAnimationName = {
                    description = "Animaatioleike potilaalle, joka makaa yleisanestesiassa.",
                    label = "Potilasanimaation nimi",
                },
                operationsPatientRange = {
                    description = "Enimmäisetäisyys leikkauspöydällä olevan potilaan tunnistamiseen.",
                    label = "Potilaan tunnistusalue",
                },
                operationsRequireOnDuty = {
                    description = "Vaatii kirurgin olevan työvuorossa ennen leikkaussalin käyttöä.",
                    label = "Vaadi työvuoro",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Enimmäisaika, jonka kirurgi voi viipyä toimenpiteen valinnassa ennen istunnon keskeyttämistä.",
                    label = "Valinnan aikaraja (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "GTA-animaatiosanakirja leikkausharjoitukseen ilman potilasta.",
                    label = "Harjoitusanimaation sanakirja",
                },
                operationsTrainingAnimationFlag = {
                    description = "Leikkausharjoituksen GTA-animaatiolippu.",
                    label = "Harjoitusanimaation lippu",
                },
                operationsTrainingAnimationName = {
                    description = "Animaatioleike leikkausharjoitukseen ilman potilasta.",
                    label = "Harjoitusanimaation nimi",
                },
                painClassesProfiles = {
                    description = "Kipukynnykset, etiketit ja jälkikäsittelyvaikutukset.",
                    label = "Kipuluokat",
                },
                painEffectsMinPainLevel = {
                    description = "Minimi kivun taso ennen kipunäytön vaikutusten alkamista.",
                    label = "Minimaalinen kiputaso",
                },
                primaryColor = {
                    description = "Ensihoidon käyttöliittymän ja työryhmän pääväri.",
                    label = "Pääväri",
                },
                propPlacementConsumeItem = {
                    description = "Käytä vastaavaa varastotavaraa, kun tuki on asetettu.",
                    label = "Kulutettava tuote",
                },
                propPlacementEnabled = {
                    description = "Salli määritettyjen EMS-tarvikkeiden sijoittaminen käytettävissä olevista varastotuotteista.",
                    label = "Käytössä",
                },
                propPlacementItemNames = {
                    description = "Yhdistä EMS-tarvikemallit varastonimikkeiden nimiin tuotepohjaista sijoittelua varten.",
                    label = "Prop kohteiden nimet",
                },
                propPlacementRequireOnDuty = {
                    description = "Vaadi pelaajaa päivystykseen ennen kuin asetat EMS-rekvisiitta.",
                    label = "Vaadi päivystyksessä",
                },
                propPlacementReturnItem = {
                    description = "Anna kulutettu tuote takaisin, kun asetettu tuki on poistettu.",
                    label = "Palauta tuote poistettaessa",
                },
                propPlacementVehicleAccess = {
                    description = "Salli runko-osien avata sijoittelun kulku vain kohteiden käytön sijaan.",
                    label = "Ajoneuvon pääsy",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Salli tietoisten pelaajien julkinen kohtelu.",
                    label = "Salli tajuissaan olevat potilaat",
                },
                publicTreatmentAllowedGangs = {
                    label = "Sallitut jengit",
                    description = "Valitse jengien tai itsenäisten organisaatioiden sisäiset nimet. Vastaava työ tai jengi antaa luvan tai poikkeuksen. Työvuorovaatimus koskee vain töitä. Valinnaiset jengien vähimmäisarvot. Tyhjä lista sallii kaikki arvot. Tavaroita koskevat vaatimukset ovat edelleen voimassa.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Työpaikat, joissa voidaan käyttää julkista hoitoa ilman, että ne ovat EMS.",
                    label = "Sallitut työt",
                },
                publicTreatmentEnabled = {
                    description = "Ota käyttöön julkinen hoito muille kuin EMS-vastaajille, joilla on kelvollinen käyttöoikeus.",
                    label = "Julkinen hoito käytössä",
                },
                publicTreatmentInteractDistance = {
                    description = "Julkisen hoidon aloittamiseen vaadittava enimmäisetäisyys.",
                    label = "Vuorovaikutusetäisyys",
                },
                publicTreatmentKeybind = {
                    description = "Julkiseen hoitoon käytetty oletusvuorovaikutusnäppäinyhdistelmä.",
                    label = "Näppäimistö",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Näytä hoitokehote ja ota sen näppäin käyttöön. Poista käytöstä, kun käytät export-kutsuja tai omaa säteittäistä valikkoa.",
                    label = "Näppäinvuorovaikutus käytössä",
                },
                publicTreatmentPromptDistance = {
                    description = "Etäisyys, jota käytettiin näyttämään julkisen hoitokehotuksen.",
                    label = "Nopea etäisyys",
                },
                publicTreatmentRequireAllItems = {
                    description = "Vaadi jokaista lueteltua lääketieteellistä tuotetta yhden sijasta.",
                    label = "Vaadi kaikki tuotteet",
                },
                publicTreatmentRequiredItems = {
                    description = "Varastotuotteet, jotka lasketaan kelvollisiksi julkisiksi hoitovälineiksi.",
                    itemLabel = "Tuote",
                    label = "Vaaditut kohteet",
                },
                reviveRewardAccount = {
                    description = "Ensisijainen tiliavain, jota käytetään palkkioiden maksamiseen.",
                    label = "Tili",
                },
                reviveRewardAccountType = {
                    description = "Ensisijainen tilityyppi, jota käytetään palkkioiden maksamiseen.",
                    label = "Tilin tyyppi",
                },
                reviveRewardAmount = {
                    description = "Lääkärille maksettu palkkio elvyttämisestä.",
                    label = "Määrä",
                },
                reviveRewardCurrency = {
                    description = "Valinnainen mukautettu valuuttaavain, jota käytetään palkintomaksujen elvyttämiseen.",
                    label = "Valuutta",
                },
                reviveRewardEnabled = {
                    description = "Maksa määritetty palkkio onnistuneen lääkärin elvyttämisen jälkeen.",
                    label = "Käytössä",
                },
                reviveRewardPayFromSociety = {
                    description = "Vähennä elvytyspalkkiot yhteisestä työyhteisöstä ennen kuin maksat lääkärille.",
                    label = "Palkkaa yhteiskunnalta",
                },
                selfDiagnoseCommand = {
                    description = "Chat-komentoa käytetään itsediagnoosin avaamiseen.",
                    label = "Komento",
                },
                selfDiagnoseEnabled = {
                    description = "Salli pelaajien avata diagnoosin käyttöliittymä itse.",
                    label = "Itsediagnoosi käytössä",
                },
                selfDiagnoseKeybind = {
                    description = "Oletusnäppäinyhdistelmä, jota käytetään itsediagnoosin avaamiseen.",
                    label = "Näppäimistö",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Viive ennen kuin itsediagnoosin käyttöliittymä avautuu.",
                    label = "Avausviive ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Rajoita itsediagnoosi vain lääkintätehtäviin.",
                    label = "Edellyttää lääkärin työtä",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Älä jäädytä soitinta itsediagnoosin aikana.",
                    label = "Ohita jäädytys itsestäsi",
                },
                statusEffectsProfiles = {
                    description = "Määritetyt näytön tehosteet ja kynnykset verenvuodolle, alhaiselle verenvuodolle, nälälle ja janolle.",
                    label = "Tilatehosteet",
                },
                stretcherAnimDict = {
                    description = "Animaatiosanakirja, jota käytetään paaria kantaessa.",
                    label = "Animaation sanelu",
                },
                stretcherAnimName = {
                    description = "Animaationimi, jota on käytetty paaria kantaessa.",
                    label = "Animaation nimi",
                },
                stretcherAttachRx = {
                    description = "Kanna kiinnittimen X kierto paaria varten.",
                    label = "Kiinnitä RX",
                },
                stretcherAttachRy = {
                    description = "Kanna kiinnittimen Y-kiertoa paareille.",
                    label = "Kiinnitä RY",
                },
                stretcherAttachRz = {
                    description = "Kanna kiinnittimen Z-kiertoa paareille.",
                    label = "Kiinnitä RZ",
                },
                stretcherAttachX = {
                    description = "Kanna kiinnitys X offset paareille.",
                    label = "Kiinnitä X",
                },
                stretcherAttachY = {
                    description = "Kanna kiinnitys Y offset paareille.",
                    label = "Kiinnitä Y",
                },
                stretcherAttachZ = {
                    description = "Kanna kiinnitys Z offset paareja varten.",
                    label = "Kiinnitä Z",
                },
                stretcherFoldedEnabled = {
                    description = "Ota käyttöön lisävarusteena saatava taitettu paarit ajoneuvoissa.",
                    label = "Taitettu käytössä",
                },
                stretcherFoldedModel = {
                    description = "Pohjamalli, jota käytetään taitetussa paarissa.",
                    label = "Taitettu malli",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Potilaan otsikkoa käytetään taitetussa paarissa.",
                    label = "Taitettu potilaan otsake",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Potilas kiinnittää X-offsetin taitettuun paariin.",
                    label = "Taitettu potilas X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Potilas kiinnittää Y-offsetin taitettuun paariin.",
                    label = "Taitettu potilas Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Potilas kiinnittää Z-offsetin taitettuun paariin.",
                    label = "Taitettu potilas Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Vuorovaikutusetäisyyden ohitus, jota käytetään helikoptereissa.",
                    label = "Helikopterin vuorovaikutusetäisyys",
                },
                stretcherHelicopterModels = {
                    description = "Paarihelikoptereina käsitellyt ajoneuvomallit.",
                    itemLabel = "Malli",
                    label = "Helikopteri mallit",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Noutoetäisyyden ohitus, jota käytetään helikoptereissa.",
                    label = "Helikopterin noutoetäisyys",
                },
                stretcherInteractDistance = {
                    description = "Paarien vuorovaikutuskehotteiden enimmäisetäisyys.",
                    label = "Vuorovaikutusetäisyys",
                },
                stretcherItemEnabled = {
                    description = "Ota paarien varastoesine käyttöön, mukaan lukien ostaminen kaupasta ja käyttäminen.",
                    label = "Paariesine",
                },
                stretcherItemPickupEnabled = {
                    description = "Salli varastoesineestä käyttöön otettujen paarien palauttaminen varastoon.",
                    label = "Esineen palautus",
                },
                stretcherModel = {
                    description = "EMS-paarijärjestelmän käyttämä ensisijainen paarien potkurimalli.",
                    label = "Malli",
                },
                stretcherPatientAnimationDict = {
                    description = "Paaripotilaiden ja esikatselun NPC-hahmon animaatiosanakirja.",
                    label = "Potilaan animaatiosanakirja",
                },
                stretcherPatientAnimationName = {
                    description = "Paaripotilaiden ja esikatselun NPC-hahmon animaatioleike.",
                    label = "Potilaan animaation nimi",
                },
                stretcherPatientAttachHeading = {
                    description = "Potilaan suuntaa käytetään paareilla makaaessaan.",
                    label = "Potilaan otsikko",
                },
                stretcherPatientAttachX = {
                    description = "Potilas kiinnittää X-offsetin paariin.",
                    label = "Potilas X",
                },
                stretcherPatientAttachY = {
                    description = "Potilas kiinnittää Y-offsetin paariin.",
                    label = "Potilas Y",
                },
                stretcherPatientAttachZ = {
                    description = "Potilas kiinnittää Z-offsetin paariin.",
                    label = "Potilas Z",
                },
                stretcherPickupDistance = {
                    description = "Etäisyys, joka tarvitaan paarien poimimiseen ja vuorovaikutukseen niiden kanssa.",
                    label = "Noutoetäisyys",
                },
                stretcherTreatmentAnimClip = {
                    description = "Animaatioleike, jota käytetään hoidettaessa potilasta paareilla. Jätä tyhjäksi, jos haluat käyttää skenaariota tai hoitoanimaatiota.",
                    label = "Animaation nimi",
                },
                stretcherTreatmentAnimDict = {
                    description = "Animaatiosanakirja, jota käytetään hoidettaessa potilasta paareilla. Jätä tyhjäksi, jos haluat käyttää skenaariota tai hoitoanimaatiota.",
                    label = "Animaatio sanakirja",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Valinnainen skenaario, jota käytetään hoidettaessa potilasta paareilla. Jätä tyhjäksi, jos haluat käyttää dict + clip -toimintoa tai hoitoanimaatiota.",
                    label = "Skenaario",
                },
                stretcherVehicleAttachRx = {
                    description = "Kiinnitä ajoneuvoon X-kierto paarien lastaamista varten.",
                    label = "Ajoneuvon RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Ajoneuvokiinnikkeen Y-kierto paarien lastaamista varten.",
                    label = "Ajoneuvo RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Ajoneuvokiinnityksen Z-kierto paarien lastaamista varten.",
                    label = "Ajoneuvo RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Ajoneuvokiinnitys X-offset paarien lastaamista varten.",
                    label = "Ajoneuvo X",
                },
                stretcherVehicleAttachY = {
                    description = "Ajoneuvokiinnitys Y offset paarien lastaamista varten.",
                    label = "Ajoneuvo Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Ajoneuvokiinnitys Z-offset paarien lastaamista varten.",
                    label = "Ajoneuvo Z",
                },
                stretcherVehicleModels = {
                    description = "Ajoneuvomallit saivat lastata paarit.",
                    itemLabel = "Malli",
                    label = "Ajoneuvojen mallit",
                },
                treatmentAnimClip = {
                    description = "Animaatioleike, jota käytetään potilaan hoidossa. Jätä tyhjäksi, jos haluat käyttää sen sijaan skenaariota.",
                    label = "Animaation nimi",
                },
                treatmentAnimDict = {
                    description = "Animaatiosanakirja, jota käytetään potilaan hoidossa. Jätä tyhjäksi, jos haluat käyttää sen sijaan skenaariota.",
                    label = "Animaatio sanakirja",
                },
                treatmentAnimScenario = {
                    description = "Potilasta hoidettaessa käytetty skenaario. Jätä tyhjäksi, jos haluat käyttää sen sijaan dict + clip -näppäintä.",
                    label = "Skenaario",
                },
                trunkPropsEnabled = {
                    label = "Ajoneuvon esineet",
                    description = "Valitse esineet läheisen työajoneuvon luona.",
                },
                trunkEnabled = {
                    description = "Ota ajoneuvon tavaratilan ominaisuus käyttöön ambulanssiajoneuvoissa.",
                    label = "Käytössä",
                },
                vehicleDamageModifier = {
                    description = "Vahinkokerroin sovellettu, kun soitin on ajoneuvossa.",
                    label = "Ajoneuvon vaurioiden muuntaja",
                },
                vehicleImpactProtectionCauses = {
                    description = "Kuolemansyyt, jotka pitäisi laskea suojatuiksi ajoneuvotörmäyksiksi.",
                    itemLabel = "Aiheuttaa",
                    label = "Vahinko aiheuttaa",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Estä hitaiden ajoneuvojen törmäykset tappamasta pelaajaa.",
                    label = "Käytössä",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Tämän nopeuden alapuolella olevat ajoneuvon törmäykset eivät voi tappaa pelaajaa.",
                    label = "Tappava nopeus km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Ajoneuvon törmäykset tällä tai sitä suuremmalla nopeudella käyttävät normaalia kuolemantapauskokoonpanoa.",
                    label = "Täysi vaurio nopeus km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Loukkaantumiset, kun ajoneuvon törmäyssuoja estää kuolemaan johtavan iskun.",
                    itemLabel = "Vahinko",
                    label = "Vammat",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Prosenttiosuus maksimiterveydestä, joka säilyy, kun suojattu isku olisi tappanut pelaajan.",
                    label = "Selviytymisterveysprosentti",
                },
                vehiclePullEnabled = {
                    description = "Salli potilaiden vetäminen ajoneuvoista.",
                    label = "Käytössä",
                },
                vehiclePullMaxDistance = {
                    description = "Suurin etäisyys, joka tarvitaan potilaan vetämiseen ajoneuvosta.",
                    label = "Max etäisyys",
                },
                wheelchairAssignMaxDistance = {
                    description = "Suurin etäisyys pyörätuolin määrittämiseksi toiselle pelaajalle.",
                    label = "Määritä maksimietäisyys",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Poista pyörätuoli automaattisesti, kun toimeksianto päättyy.",
                    label = "Automaattinen laitteiden purkaminen vanhentuessa",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Pyörätuolin oletuskesto minuutteina.",
                    label = "Oletuskesto",
                },
                wheelchairDisableSprint = {
                    description = "Estä sprintti, kun pyörätuoli on varustettu.",
                    label = "Poista sprintti käytöstä",
                },
                wheelchairDisableWeapons = {
                    description = "Estä aseen käyttö, kun pyörätuoli on varustettu.",
                    label = "Poista aseet käytöstä",
                },
                wheelchairExitControl = {
                    description = "Pyörätuolista poistumiseen käytetty ohjaustunnus.",
                    label = "Poistu hallinnasta",
                },
                wheelchairItemName = {
                    description = "Pyörätuoliin käytetty tavara.",
                    label = "Kohteen nimi",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Suurin sallittu pyörätuolitehtävän kesto minuutteina.",
                    label = "Max kesto",
                },
                wheelchairMinDurationMinutes = {
                    description = "Pyörätuolitehtävän vähimmäiskesto minuutteina.",
                    label = "Minimikesto",
                },
                wheelchairVehicle = {
                    description = "Pyörätuoliin käytetty ajoneuvomalli.",
                    label = "Ajoneuvon malli",
                },
                xrayInteractionRange = {
                    description = "Käyttäjän suurin etäisyys röntgenasemasta.",
                    label = "Vuorovaikutusalue",
                },
                xrayPatientRange = {
                    description = "Potilaan enimmäisetäisyys röntgenasemasta.",
                    label = "Potilasalue",
                },
                xrayScanDurationSeconds = {
                    description = "Röntgenkuvaustuloksen kesto sekunneissa.",
                    label = "Skannauksen kesto",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Jäähdytys sekunneissa potilasvarausyritysten välillä.",
                    label = "Varausten jäähdyttäminen",
                },
                appointmentsEnabled = {
                    description = "Aktivoi potilasvaraus ja henkilökohtainen lääkärikalenteri.",
                    label = "Käytössä",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Suurin mahdollinen määrä päiviä tulevaisuuteen, että potilaat voivat varata.",
                    label = "Suurin mahdollinen ennakkovaraus",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Potilaan tulevien aktiivisten tapaamisten enimmäismäärä.",
                    label = "Enimmäisaika potilasta kohti",
                },
                appointmentsMinLeadMinutes = {
                    description = "Varauksen ja ajanvarauksen välinen vähimmäisminuuttimäärä.",
                    label = "Minimiajoaika",
                },
                appointmentsNotificationApp = {
                    description = "Puhelinsovelluksen tunniste, jota käytetään nimitysilmoituksissa.",
                    label = "Ilmoitussovellus",
                },
                appointmentsNotificationsEnabled = {
                    description = "Ilmoita puhelimella, kun tapaamiset on varattu tai peruutettu.",
                    label = "Puhelinilmoitukset",
                },
                appointmentsReasonMaxLength = {
                    description = "Nimitys syystä hyväksyttyjen merkkien enimmäismäärä.",
                    label = "Syy-merkkiraja",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Ajanvarausajan kesto ja vuoroväli minuutteina.",
                    label = "Lähtö- ja saapumisaika",
                },
                enforceMaxHealth = {
                    description = "Pidä pelaajan terveys maksimissaan 200:ssä. Poista tämä käytöstä, kun toinen resurssi hoitaa maksimaalista terveyttä.",
                    label = "Tehosta 200 maksimaalista terveyttä",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Ambulanssihenkilökunta voi antaa tai poistaa lisäpuitteita potilastiedoissa. Asetettu ensiapulupa on aina mukana.",
                    itemLabel = "Lisenssi",
                    label = "Lisäpotilasluvat",
                },
                minigamesBandageWrapRandomization = {
                    description = "Satunnaista harsopolkujen suunta, muoto ja mittasuhteet.",
                    label = "Lantakäärön vaihtelu",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Satunnaista verensiirron laskimotie.",
                    label = "Verensiirtoon pääsyn vaihtelu",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Vaadi monivaiheinen laskimon sisäänpääsy ennen virtauksen säätöä. Vanhan yksinkertaisen version pois käytöstä.",
                    label = "Laskimoon pääsyvaihe",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Satunnaista haavan muoto, leveys ja tukkeumat.",
                    label = "Luodin uuttovariaatio",
                },
                stretcherVehicleAttachEditor = {
                    description = "Aseta paarit paikalleen ja pyöritä niitä konfiguroidussa ambulanssissa.",
                    label = "Ajoneuvon kiinnitys",
                },
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
            warnings = {
                firstAidPublicTreatmentConflict = "Ensiapua ja julkista hoitoa ei voi ottaa käyttöön samanaikaisesti. Tallentaminen poistaa molemmat käytöstä.",
            },
            actions = {
                actionFailed = "Unable to save changes.",
                hideDetails = "Close",
                editPosition = "Edit",
                delete = "Delete",
                editDetails = "Edit",
                remove = "Delete",
            },
        },
    },
}
