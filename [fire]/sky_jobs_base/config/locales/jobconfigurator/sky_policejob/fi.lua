JobConfigLocales["sky_policejob:fi"] = {
    JobConfiguratorComingSoon = "Tämä työn konfiguraattori on tulossa pian.",
    JobConfiguratorNoPermission = "Sinulla ei ole oikeutta käyttää tätä komentoa.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Määritä poliisiasemat, kaupat, esineet, ajoneuvot, asemat ja ydinominaisuuksien asetukset.",
                    title = "Poliisin työt",
                },
            },
            dispatchActions = {
                addChannel = "Lisää radiokanava",
                addKeyword = "Lisää avainsana",
                addPoi = "Lisää kohde",
                addReporter = "Lisää ilmoittaja",
                addStatus = "Lisää FMS-tila",
                addVehicle = "Lisää virtuaaliyksikkö",
                addVehicleType = "Lisää yksikkötyyppi",
                currentLocation = "Käytä nykyistä sijaintia",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Määrittää välittömästi vastaavat käytettävissä olevat yksiköt, kun tapahtuma luodaan.",
                available = "Tässä tilassa olevia yksiköitä voidaan ehdottaa ja määrittää uudelle tapahtumalle.",
                averageResponseSpeedKmh = "Laskee näytetyn saapumisarvion suoran etäisyyden perusteella.",
                callsign = "Ainutlaatuinen radiokutsu, joka näytetään, kun pelaajat työskentelevät tässä virtuaaliyksikössä.",
                centerEnabled = "Sallii päivystävän valtuutetun jäsenen työskennellä lähetyskeskuksessa.",
                channelId = "Radiokanavan tunnus PMA Voicelle, SaltyChatille ja YACA:lle. Numeeriset tunnukset, kuten 2500, pysyvät ennallaan; PMA Voice kartoittaa tekstitunnukset vakaaseen numeroon.",
                channelLabel = "Luettavissa oleva kanavan nimi näytetään lähettäjille ja yksiköille.",
                crewCapacity = "Yksikön miehistön enimmäismäärä. Arvo 0 sallii rajattoman miehistön.",
                defaultChannel = "Työnvälittäjät liittyvät tähän kanavaan aloittaessaan työvuoronsa. Yksiköt liittyvät manuaalisesti Radio-välilehdeltä. Valitse Ei mitään, jos haluat käyttää työryhmän oletusasetusta.",
                emergencyAppEnabled = "Tekee tästä työstä valittavan julkisena palveluna Hätäpuhelinsovelluksessa.",
                enabled = "Asettaa tämän työn Dispatch App -sovelluksen ja työnvälisten tapahtumien saataville.",
                icon = "Valitse Dispatch-sovelluksessa tälle yksikkökategorialle näkyvä kuvake.",
                incidentAssessmentEnabled = "Näyttää lääketieteellisiä ja vaaranarviointikysymyksiä koko tapahtuman tiedot.",
                jobs = "Muita töiden nimiä, jotka vastaanottavat tämän avainsanan avulla tapahtuvia tapahtumia.",
                joinLocked = "Estää uusia henkilöitä liittymästä sen jälkeen, kun yksikkö on miehitetty.",
                minimumCrew = "Tämän vastesuunnitelman valittujen yksiköiden miehistön vähimmäismäärä.",
                noUnitFallback = "Ilman keskustaa tai henkilöstöyksikköä lähettää Sky-ilmoituksen kaikille päivystävälle jäsenelle.",
                poiId = "Pysyvä tekninen tunnus, johon hätäkeskusprofiili voi viitata kohteen nimeämisen jälkeenkin.",
                radius = "Suurin etäisyys metreinä, jolla aseman tiedotus voidaan kuulla.",
                readyStatusCode = "FMS-tila, joka asetetaan resurssin tullessa hälytysvalmiiksi.",
                requirements = "Vastauspyyntö TYYPPI:COUNT-pareina, esimerkiksi PATROL:2,CRIMI:1.",
                resourceType = "Luokittelee operatiivisen resurssin hätäkeskuksen suodatusta ja koordinointia varten.",
                respondingStatusCode = "FMS-tila, joka asetetaan resurssin vastatessa tehtävään.",
                shortLabel = "Valinnainen lyhyt nimi kuudelle radiokanavan muistipainikkeelle.",
                stationId = "Liittää yksikön hätäkeskusprofiilissa määritettyyn asemaan.",
                statusCode = "Numeerinen FMS-tila, joka näkyy kädessä pidettävässä radiossa.",
                statusLabel = "Tämän FMS-tilan merkitys lähettäjille ja yksiköille.",
                unitId = "Pysyvä tekninen tunnus säilyttää yksikön, vaikka kutsutunnus muuttuu.",
                vehicleType = "On vastattava edellisessä alaosiossa määritettyä ajoneuvotyypin koodia.",
                vehicleTypeCode = "Lyhyt yksikkökoodi, jota käytetään vastausvaatimuksissa, esimerkiksi PATROL, CRIME, EMS tai RESCUE.",
                vehicleTypeLabel = "Tämän yksikköluokan luettava nimi.",
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
                crewCapacity = "Miehistökapasiteetti",
                defaultChannel = "Oletusradiokanava",
                emergencyAppEnabled = "Näytä hätäsovelluksessa",
                enabled = "Ota lähetys käyttöön",
                icon = "Kuvake",
                incidentAssessmentEnabled = "Ota hätätilanteen arviointi käyttöön",
                jobs = "Kohdetyöt (pilkuilla erotettuna)",
                joinLocked = "Lukitse miehistöön liittyminen",
                keywordCode = "Avainsanakoodi",
                label = "Etiketti",
                minimumCrew = "Miehistön vähimmäismäärä",
                name = "Nimi",
                noUnitFallback = "Ilmoita päivystävälle henkilökunnalle ilman yksiköitä",
                noneChannel = "Ei mitään / ryhmän oletus",
                note = "Huom",
                phone = "Puhelin",
                poiId = "Pysyvä POI-tunnus",
                radius = "Ilmoituksen säde",
                readyStatusCode = "Valmiustilan koodi",
                requirements = "Vaaditut yksiköt (esimerkiksi PATROL:2, CRIME:1)",
                resourceType = "Resurssityyppi",
                respondingStatusCode = "Vastetilan koodi",
                shortLabel = "Radiomuistin nimi",
                stationId = "Asematunnus",
                type = "Tyyppi",
                unitId = "Pysyvä yksikkötunnus",
                vehicleType = "Vastausyksikön tyyppi",
                radioButton = "Nappi",
                radioButtonAction = "Nappitoiminta",
                radioButtonStatus = "FMS Tila",
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
                    reporters = "Tunnetut ilmoittajat",
                    statuses = "Saatavilla FMS",
                    units = "Virtuaaliyksiköt",
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
                dispatchReporters = "Ylläpitää tehtäväkohtaisia ilmoittajien nimiä, takaisinsoittonumeroita ja hätäkeskuksen muistiinpanoja.",
                dispatchStatusCodes = "Määrittää FMS-tilatunnisteet ja mitkä tilat lasketaan käytettävissä oleviksi uusille tapahtumille.",
                dispatchVehicleTypes = "Määrittää toimintasuunnitelmien käyttämät yksikköluokat, kuten partio, rikosyksikkö, hätäkeskus tai pelastus.",
                dispatchVehicles = "Määrittelee virtuaaliset lähetysajoneuvot, jotka voidaan saada miehistöä mistä tahansa ilman, että vaaditaan synnytettyä ajoneuvoa.",
                dispatchRadioButtons = "Asettaa kullekin fyysiselle toimintopainikkeelle keskitetyn ennalta määritetyn toiminnan.",
                dispatchRadioFmsKeys = "Asettaa FMS statuksen fyysisille numeroavaimille. Näppäimistössä tapahtuu vain FMS muutosta.",
            },
            extensions = {
                caseNumbering = {
                    label = "Tapausnumerot",
                    description = "Määritä tämän työn automaattiset tapausnumerot.",
                    fields = {
                        prefix = {
                            label = "Tapauksen etuliite",
                            description = "Uusien tapausten etuliite, kuten LSPD tai LSCSD. Enintään 16 merkkiä, jotka muunnetaan isoiksi kirjaimiksi; tyhjänä käytetään CASE. Nykyiset ja käsin annetut numerot säilyvät.",
                        },
                    },
                },
                dispatchReporters = "Tunnetut ilmoittajat",
                invalidSelection = "Virheellinen valinta: {value}",
                trainingSettings = {
                    description = "Määritä koulutuksen käyttöoikeudet, ilmoittautuminen, hyväksynnät ja kurssin suunnittelu tälle työlle.",
                    label = "Harjoitusasetukset",
                },
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
                dispatchRadioButtons = "Radiotoiminnon painikkeet",
                dispatchRadioFmsKeys = "FMS Avaintehtävä",
            },
            features = {
                billing = {
                    description = "Ota käyttöön poliisin laskutustoiminnot.",
                    label = "Laskutus",
                },
                devices = {
                    description = "Ota käyttöön asennettavat valvontalaitteet.",
                    label = "CCTV ja nopeuskamerat",
                },
                evidence = {
                    description = "Ota käyttöön todistevarasto, kenttätodisteet ja skannerin toiminnot.",
                    label = "Todisteet",
                },
                impound = {
                    description = "Ota käyttöön takavarikkoalueen toiminnot.",
                    label = "Takavarikointi",
                },
                jail = {
                    description = "Ota käyttöön vankeustuomiot ja vankien tehtävät.",
                    label = "Vankila",
                },
                propPlacement = {
                    description = "Ota käyttöön määritettävät poliisiesineet ja ajoneuvojen esinevarustukset.",
                    label = "Esineiden sijoittelu",
                },
                radial = {
                    description = "Ota käyttöön poliisin toimintopyörän toiminnot, kuten takavarikointi ja pyöränlukko.",
                    label = "Toimintopyörä",
                },
                restraints = {
                    description = "Ota käyttöön käsiraudat, siimapannat, nilkkaraudat ja päähuput.",
                    label = "Rajoitteet",
                },
                socialWork = {
                    description = "Ota käyttöön sosiaalityön määrääminen ja tehtävät.",
                    label = "Sosiaalityö",
                },
                tablet = {
                    description = "Ota käyttöön tämän resurssin määrittämät poliisin tablettisovellukset.",
                    label = "Poliisin tabletti",
                },
                tracking = {
                    description = "Ota käyttöön GPS-seurantalaitteet ja nilkkarannekkeet.",
                    label = "Seuranta",
                },
                vehicleRadar = {
                    description = "Ota käyttöön partioajoneuvon radar.",
                    label = "Ajoneuvon radar",
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
                gangMinimumGrade = "Vähimmäisarvo",
                gang = "Jengi",
                component = "Komponentti",
                description = "Kuvaus",
                fineAmount = "Sakon määrä",
                itemName = "Tavaran nimi",
                length = "Pituus",
                max = "Maks",
                maxOverKmh = "Enint. ylitys",
                min = "Minimi",
                minOverKmh = "Väh. ylitys",
                model = "Esineen malli",
                propModel = "Esineen malli",
                reason = "Syy",
                vehicleClass = "Luokka",
            },
            settingGroups = {
                access = {
                    label = "Käyttöoikeus",
                },
                animation = {
                    label = "Animaatio",
                },
                ankleMonitor = {
                    label = "Nilkkaranneke",
                },
                ankleMonitorAccess = {
                    label = "Nilkkarannekkeen käyttöoikeus",
                },
                ankleMonitorPlacement = {
                    label = "Nilkkarannekkeen kiinnitys",
                },
                ankleMonitorZone = {
                    label = "Nilkkarannekkeen alue",
                },
                ankleMonitorZoneVisual = {
                    label = "Nilkkarannekkeen alueen visuaalit",
                },
                assignment = {
                    label = "Määrääminen",
                },
                blip = {
                    label = "Aseman karttamerkki",
                },
                carry = {
                    label = "Kantaminen",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV:n kestävyys",
                },
                cctvPlacement = {
                    label = "CCTV:n sijoittelu",
                },
                cctvRepair = {
                    label = "CCTV:n korjaus",
                },
                cctvRepairAnimation = {
                    label = "CCTV:n korjausanimaatio",
                },
                clamp = {
                    label = "Pyöränlukko",
                },
                clampWeld = {
                    label = "Pyöränlukon hitsaus",
                },
                cleanup = {
                    label = "Siivous",
                },
                collection = {
                    label = "Kerääminen",
                },
                controls = {
                    label = "Ohjaimet",
                },
                creator = {
                    label = "Luoja",
                },
                crimeSceneTape = {
                    label = "Rikospaikan eristysnauha",
                },
                crimeSceneTapeAccess = {
                    label = "Eristysnauhan käyttöoikeus",
                },
                crimeSceneTapeInventory = {
                    label = "Eristysnauhan inventaari",
                },
                crimeSceneTapeLength = {
                    label = "Nauhan pituus",
                },
                crimeSceneTapePlacement = {
                    label = "Eristysnauhan sijoittaminen",
                },
                database = {
                    label = "Tietokanta",
                },
                delivery = {
                    label = "Toimitus",
                },
                detection = {
                    label = "Tunnistus",
                },
                dispatch = {
                    label = "Hälytys",
                },
                escape = {
                    label = "Pakeneminen",
                },
                escort = {
                    label = "Saattaminen",
                },
                evidenceStorage = {
                    label = "Todistevarasto",
                },
                fastLock = {
                    label = "Automaattinen pikalukitus",
                },
                general = {
                    label = "Yleiset",
                },
                gpsTracker = {
                    label = "GPS-seurain",
                },
                gpsTrackerAccess = {
                    label = "GPS-seurannan käyttöoikeus",
                },
                gpsTrackerPlacement = {
                    label = "GPS-seurannan sijoittelu",
                },
                gpsTrackerTiming = {
                    label = "GPS-seurannan ajoitus",
                },
                handcuffs = {
                    label = "Käsiraudat",
                },
                handsUp = {
                    label = "Kädet ylös",
                },
                header = {
                    label = "Otsikko",
                },
                impound = {
                    label = "Takavarikointi",
                },
                imprisonment = {
                    label = "Vankeus",
                },
                jailCanteenGeneral = {
                    label = "Vankilan kanttiini",
                },
                jailCanteenPackage = {
                    label = "Kanttiinin ruokapaketti",
                },
                jailCarry = {
                    label = "Kantotyö",
                },
                jailCarryInspection = {
                    label = "Kantolaatikon tarkistus",
                },
                jailCleaning = {
                    label = "Siivoustyö",
                },
                jailCleaningIllegalFinds = {
                    label = "Kiellettyjen tavaroiden löydöt",
                },
                jailCleaningOutline = {
                    label = "Siivouksen ääriviiva",
                },
                jailDoctor = {
                    label = "Vankilalääkäri",
                },
                jailElectricalCodes = {
                    label = "Sähkökeskuksen koodit",
                },
                jailElectricalGeneral = {
                    label = "Vankilan sähkökeskus",
                },
                jailElectricalPenalties = {
                    label = "Sähkökeskuksen rangaistukset",
                },
                jailElectricalRewards = {
                    label = "Sähkökeskuksen palkkiot",
                },
                jailInmatesAlcoholic = {
                    label = "Alkoholistivanki",
                },
                jailInmatesCodeList = {
                    label = "Ilmiantajavanki",
                },
                jailInmatesDrugDealer = {
                    label = "Huumekauppiasvanki",
                },
                jailInmatesWireCutter = {
                    label = "Työkaluvälittäjävanki",
                },
                jailJobs = {
                    label = "Vankilatyöt",
                },
                jailOutfitFemale = {
                    label = "Naisten asu",
                },
                jailOutfitMale = {
                    label = "Miesten asu",
                },
                keybinds = {
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                    label = "Näppäimet",
                },
                keybindsHandcuff = {
                    label = "Käsirautojen pikanäppäin",
                },
                keybindsUnhandcuff = {
                    label = "Käsirautojen poiston pikanäppäin",
                },
                marker = {
                    label = "Merkki",
                },
                markerColor = {
                    label = "Merkin väri",
                },
                mugshotAnimation = {
                    label = "Tunnistekuvan animaatio",
                },
                mugshotBoard = {
                    label = "Tunnistekuvan taulu",
                },
                mugshotCameraCoords = {
                    label = "Tunnistekuvan kameran sijainti",
                },
                mugshotCameraRotation = {
                    label = "Tunnistekuvan kameran kierto",
                },
                mugshotGeneral = {
                    label = "Tunnistekuva",
                },
                mugshotMetadata = {
                    label = "Tunnistekuvan metatiedot",
                },
                mugshotPosition = {
                    label = "Tunnistekuvan sijainti",
                },
                mugshotTiming = {
                    label = "Tunnistekuvan ajoitus",
                },
                officerDown = {
                    label = "Virkamies alas",
                },
                outfit = {
                    label = "Asu",
                },
                overlay = {
                    label = "Rekisterikilven peittokuva",
                },
                payment = {
                    label = "Maksu",
                },
                paymentFlow = {
                    label = "Maksuprosessi",
                },
                penalties = {
                    label = "Rangaistukset",
                },
                playerSearch = {
                    label = "Henkilöntarkastus",
                },
                playerSearchAnimation = {
                    label = "Henkilöntarkastuksen animaatio",
                },
                props = {
                    label = "Esineet",
                },
                reasons = {
                    label = "Syyt",
                },
                release = {
                    label = "Vapautus",
                },
                restore = {
                    label = "Palautus",
                },
                rules = {
                    label = "Säännöt",
                },
                scan = {
                    label = "Skannaus",
                },
                scanner = {
                    label = "Skanneri",
                },
                sentence = {
                    label = "Tuomio",
                },
                shotsFired = {
                    label = "Laukauksia ammuttu",
                },
                sound = {
                    label = "Ääni",
                },
                speedcam = {
                    label = "Nopeuskamerat",
                },
                speedcamBilling = {
                    label = "Nopeuskameran laskutus",
                },
                speedcamDispatch = {
                    label = "Nopeuskameran hälytys",
                },
                speedcamDurability = {
                    label = "Nopeuskameran kestävyys",
                },
                speedcamPlacement = {
                    label = "Nopeuskameran sijoittelu",
                },
                speedcamRepair = {
                    label = "Nopeuskameran korjaus",
                },
                speedcamRepairAnimation = {
                    label = "Nopeuskameran korjausanimaatio",
                },
                speedcamTiming = {
                    label = "Nopeuskameran ajoitus",
                },
                speedcamVisual = {
                    label = "Nopeuskameran visuaalit",
                },
                speedcams = {
                    label = "Nopeuskamerat",
                },
                storage = {
                    label = "Säilytys",
                },
                subscription = {
                    label = "Sovellustilaus",
                },
                tasks = {
                    label = "Tehtävät",
                },
                theme = {
                    label = "Teema",
                },
                timing = {
                    label = "Ajoitus",
                },
                warningUi = {
                    label = "Varoituskäyttöliittymä",
                },
                world = {
                    label = "Maailma",
                },
                zipties = {
                    label = "Siimapannat",
                },
                ziptiesCutter = {
                    label = "Siimapantojen leikkuri",
                },
                cctvMotionDetection = {
                    label = "Liikkeentunnistus",
                },
                cctvMotionDispatch = {
                    label = "Liikkeentunnistuslähetys",
                },
                cctvMotionTiming = {
                    label = "Motion Detection Ajoitus",
                },
                display = {
                    label = "Näyttö",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Raportit",
                },
                speedcamAdvanced = {
                    label = "Lisänopeuskamera",
                },
                tackle = {
                    label = "Taklaus",
                },
                vin = {
                    label = "VIN Tarkastus",
                },
            },
            settingSections = {
                radarGun = "Tutkapistooli",
                billing = "Laskutus",
                cctv = "CCTV",
                dispatch = "Hälytykset",
                equipment = "Varusteet",
                evidence = "Todisteet",
                impound = "Takavarikointi",
                jail = "Vankila",
                radar = "Ajoneuvon radar",
                radial = "Toimintopyörä",
                restraints = "Rajoitteet",
                socialWork = "Sosiaalityö",
                speedCamera = "Nopeuskamera",
                spikeStrips = "Piikkimatot",
                stations = "Asemat",
                tablet = "Tablettisovellukset",
                tracking = "Seuranta",
                fakePlates = "Väärennetyt levyt",
                general = "Kenraali",
            },
            settingSubsections = {
                app = "Nopeuskamerasovellus",
                apps = "Sovellukset",
                billing = "Laskutus",
                canteen = "Vankilan kanttiini",
                dispatch = "Hälytykset",
                durability = "Kestävyys",
                electrical = "Vankilan sähkökeskus",
                general = "Yleiset",
                handcuffs = "Käsiraudat ja nippusiteet",
                inmates = "Vangit",
                jobs = "Vankilatyöt",
                keybinds = "Näppäimet",
                motionDetection = "Liikkeentunnistus",
                mugshot = "Tunnistekuva",
                placement = "Sijoittelu",
                repair = "Korjaus",
                timing = "Ajoitus",
                visuals = "Visuaalit",
            },
            settings = {
                radarGunClearKey = { label = "Tutkapistooli: Tyhjennä mittaus" },
                radarGunToggleUiKey = { label = "Tutkapistooli: Vaihda käyttöliittymää" },
                radarGunNoTargetHoldMs = { label = "Kohteen säilytysaika (ms)" },
                radarGunMinimumReading = { label = "Pienin näytettävä nopeus" },
                radarGunSpeedSmoothing = { label = "Nopeuden tasoitus (0–1)" },
                radarGunBeamRadius = { label = "Säteen leveys (m)" },
                radarGunRefreshRateMs = { label = "Mittausväli (ms)" },
                radarGunUseMph = { label = "Käytä MPH-yksikköä", description = "Näytä tutkapistoolin mittaukset maileina tunnissa kilometrien tunnissa sijaan." },
                radarGunRange = { label = "Mittausetäisyys", description = "Enimmäisetäisyys metreinä, jolta tutkapistooli tunnistaa ajoneuvot." },
                radarGunRequireOnDuty = { label = "Vaadi työvuoro", description = "Vaadi poliisin olevan työvuorossa ennen ajoneuvojen mittaamista tutkapistoolilla." },
                radarGunAllowedJobs = { label = "Sallitut työt tai ryhmät", description = "police kattaa kaikki määritetyt poliisityöt; myös suorat työnimet käyvät. Tyhjä luettelo poistaa työrajoitukset.", itemLabel = "Työ tai ryhmä" },
                radarGunEnabled = { label = "Tutkapistooli", description = "Ota kädessä pidettävä SKY SR-2 -tutkapistooli käyttöön." },
                fakePlateVinAllowedGangs = {
                    label = "Sallitut jengit",
                    description = "Valitse jengien tai itsenäisten organisaatioiden sisäiset nimet. Vastaava työ tai jengi antaa luvan tai poikkeuksen. Työvuorovaatimus koskee vain töitä.",
                    itemLabel = "Jengi",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Jengien vähimmäisarvot",
                    description = "Valinnaiset jengien vähimmäisarvot. Tyhjä lista sallii kaikki arvot. Tavaroita koskevat vaatimukset ovat edelleen voimassa.",
                },

                speedCamProcessingMode = {
                    description = "Valitse välitön veloitus, maksu määritetyssä määräajassa tai vain poliisin tarkistus.",
                    label = "Käsittelytapa",
                    options = {
                        instant = "Veloita heti",
                        later = "Maksa myöhemmin (oletus)",
                        review = "Vain poliisin tarkistus",
                    },
                },
                tabletRegistry = { label = "Rekisteri", description = "Ota mukautetut RP-rekisterit käyttöön File Explorerissa. Henkilö- ja ajoneuvoasiakirjat pysyvät erikseen käytettävissä." },
                tabletFiles = { label = "Tiedostoselain", description = "Kokoaa poliisin asiakirjat tiedostoselaimeen. DOJ-asiakirjat näkyvät vain, kun DOJ on käytössä." },
                ankleMonitorAnimDurationMs = {
                    description = "Millisekunnit, jotka nilkkarannekkeen kiinnittämiseen kuluu.",
                    label = "Laittamisen kesto",
                },
                ankleMonitorAnimScenario = {
                    description = "Skenaario, joka toistetaan nilkkarannekkeen kiinnittämisen aikana.",
                    label = "Laittamisen skenaario",
                },
                ankleMonitorAttachBone = {
                    description = "Ped-luu, johon nilkkarannekkeen esine kiinnitetään.",
                    label = "Kiinnitysluu",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Poista nilkkarannekkeen tavara kiinnittämisen jälkeen.",
                    label = "Kuluta nilkkaranneke",
                },
                ankleMonitorCutItem = {
                    description = "Nilkkarannekkeiden poistamiseen käytettävä varaston tavara.",
                    label = "Katkaisutavara",
                },
                ankleMonitorEnabled = {
                    description = "Ota käyttöön nilkkarannekkeen kiinnittäminen.",
                    label = "Nilkkaranneke",
                },
                ankleMonitorItem = {
                    description = "Nilkkarannekkeiden kiinnittämiseen käytettävä varaston tavara.",
                    label = "Nilkkarannekkeen tavara",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Millisekunnit nilkkarannekkeen karttapäivitysten välillä.",
                    label = "Kartan päivitysväli",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Säilyttää nilkkavalvontalaitteet tietokannassa valvotun pelaajan katkaistessa yhteyden, jotta ne palautetaan uudelleenyhdistämisen ja palvelimen uudelleenkäynnistyksen jälkeen.",
                    label = "Säilytä yhteyden katketessa",
                },
                ankleMonitorPlaceDistance = {
                    description = "Suurin etäisyys nilkkarannekkeen kiinnittämiseen.",
                    label = "Kiinnitysetäisyys",
                },
                ankleMonitorPropModel = {
                    description = "Nilkkarannekkeen visuaalissa käytettävä esinemalli.",
                    label = "Esinemalli",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen nilkkarannekkeiden käyttöä.",
                    label = "Nilkkaranneke vaatii työvuoron",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Vaadi, että pelaaja kuuluu poliisiryhmään ennen nilkkarannekkeiden käyttöä.",
                    label = "Nilkkaranneke vaatii poliisin työn",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Palauta nilkkarannekkeen tavara, kun se poistetaan.",
                    label = "Palauta ranneke poistettaessa",
                },
                ankleMonitorWarningSeconds = {
                    description = "Varoitusaika ennen nilkkarannekkeen aluerikkomuksen ilmoittamista.",
                    label = "Alueen varoitussekunnit",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Millisekunnit nilkkarannekkeen alueen varoituspiippausten välillä.",
                    label = "Alueen piippausväli",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Äänen nimi, jota käytetään nilkkarannekkeen aluevaroituksissa.",
                    label = "Piippausääni",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Äänisarja, jota käytetään nilkkarannekkeen aluevaroituksissa.",
                    label = "Piippausäänisarja",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Nilkkarannekkeen aluemerkeissä käytettävä läpinäkyvyysarvo.",
                    label = "Merkin läpinäkyvyys",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Karttamerkin väri, kun kohde on sallitun alueen sisällä.",
                    label = "Sallitun alueen merkin väri",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Karttamerkin väri, kun kohde poistuu sallitulta alueelta.",
                    label = "Poistumisen merkin väri",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Millisekunnit nilkkarannekkeen aluetarkistusten välillä.",
                    label = "Alueen tarkistusväli",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Sekunnit ennen kuin uusi nilkkarannekkeen aluehälytys voidaan lähettää.",
                    label = "Alueen hälytyksen jäähdytys",
                },
                ankleMonitorZoneEnabled = {
                    description = "Ota käyttöön nilkkarannekkeen aluetarkistukset.",
                    label = "Nilkkarannekkeen alueet",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Karttamerkin kuvake, jota käytetään nilkkarannekkeen aluemerkeissä.",
                    label = "Alueen merkin kuvake",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Nilkkarannekkeen alueen ääriviivoissa käytettävä säde.",
                    label = "Ääriviivan säde",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Nilkkarannekkeen alueen ääriviivoissa käytettävä askelkoko.",
                    label = "Ääriviivan askel",
                },
                billingAccount = {
                    description = "Varatili, jota käytetään, kun työllä ei ole määritettyä yritystiliä.",
                    label = "Varatili yritykselle",
                },
                billingCloseOnSuccess = {
                    description = "Sulje laskutuksen käyttöliittymä, kun lasku on laadittu.",
                    label = "Sulje onnistumisen jälkeen",
                },
                billingCurrency = {
                    description = "Laskutuksessa käytettävä valuutta-avain. Jätä tyhjäksi käyttääksesi oletusvaluuttaa.",
                    label = "Valuutta",
                },
                billingCustomReasons = {
                    description = "Salli mukautetut laskutussyyt pelkkien esiasetusten sijaan.",
                    label = "Mukautetut syyt",
                },
                billingDepositToSociety = {
                    description = "Talleta laskutuksen tulot työn yritystilille.",
                    label = "Talleta yritykselle",
                },
                billingMaxReasonLength = {
                    description = "Mukautetun laskutussyyn suurin sallittu merkkimäärä.",
                    label = "Syyn pituus",
                },
                billingMode = {
                    description = "Valitse, veloittaako poliisin lasku heti, vaatiiko se kansalaisen vahvistuksen, vai käytetäänkö frameworkin laskutusjärjestelmää.",
                    label = "Laskutustapa",
                    options = {
                        consent = "Maksa tai kieltäydy",
                        framework = "Frameworkin lasku",
                        instant = "Välitön veloitus",
                    },
                },
                billingRange = {
                    description = "Suurin kohde-etäisyys poliisilaskujen laatimiseen.",
                    label = "Laskutusetäisyys",
                },
                billingReasonPresets = {
                    description = "Laskutuksen käyttöliittymässä näytettävät esiasetetut laskutussyyt.",
                    itemLabel = "Syy",
                    label = "Syyn esiasetukset",
                },
                billingRefreshSeconds = {
                    description = "Kohteen päivitysväli, kun laskutuksen käyttöliittymä on auki.",
                    label = "Päivitys sekunneissa",
                },
                billingShowRecipientName = {
                    description = "Näytä kansalaisen nimi sakkoluonnoksissa ja kuiteissa.",
                    label = "Näytä vastaanottajan nimi",
                },
                carryAllowCarrierInVehicle = {
                    description = "Salli kantajan nousta ajoneuvoon ja ajaa laskematta kannettavaa pelaajaa alas.",
                    label = "Salli kantaja ajoneuvoon",
                },
                carryAllowConscious = {
                    description = "Salli tajuissaan olevien kohteiden kantaminen.",
                    label = "Salli tajuissaan olevien kantaminen",
                },
                carryAllowSprint = {
                    description = "Salli juokseminen kannettaessa toista pelaajaa.",
                    label = "Salli juokseminen kantaessa",
                },
                carryEnabled = {
                    description = "Ota käyttöön pelaajien kantaminen.",
                    label = "Kantaminen",
                },
                carryMaxDistance = {
                    description = "Suurin etäisyys pelaajan kantamisen aloittamiseen.",
                    label = "Kantoetäisyys",
                },
                carryRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen kantamisen aloittamista.",
                    label = "Kantaminen vaatii työvuoron",
                },
                cctvDamageCooldownMs = {
                    description = "Millisekunnit ennen kuin CCTV-vahinkoa voidaan aiheuttaa uudelleen.",
                    label = "Vahingon jäähdytys",
                },
                cctvDamagePerHit = {
                    description = "CCTV-kameroihin kohdistuva kestävyysvahinko per osuma.",
                    label = "Vahinko per osuma",
                },
                cctvDefaultName = {
                    description = "Asennettujen CCTV-kameroiden oletusnäyttönimi.",
                    label = "CCTV:n oletusnimi",
                },
                cctvDefaultPitch = {
                    description = "CCTV-sijoittelun oletusarvoinen kameran kallistus.",
                    label = "Oletuskallistus",
                },
                cctvDisassembleDistance = {
                    description = "Etäisyys, jota käytetään CCTV-kameroiden purkamiseen.",
                    label = "Purkuetäisyys",
                },
                cctvEnabled = {
                    description = "Ota käyttöön CCTV-kameroiden sijoittelu ja striimaus.",
                    label = "CCTV-kamerat",
                },
                cctvHealthDisplayDistance = {
                    description = "Etäisyys, jolla CCTV:n kunto näytetään.",
                    label = "Kunnon näyttöetäisyys",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Millisekunnit, joina CCTV:n kunto pysyy näkyvissä.",
                    label = "Kunnon näyttöaika",
                },
                cctvHealthTextOffset = {
                    description = "CCTV:n kuntotekstissä käytettävä pystysuuntainen siirtymä.",
                    label = "Kuntotekstin siirtymä",
                },
                cctvHeightStep = {
                    description = "CCTV-kameroiden sijoittelussa käytettävä korkeusaskel.",
                    label = "Korkeusaskel",
                },
                cctvItem = {
                    description = "CCTV-kameroiden sijoittamiseen käytettävä varaston tavara.",
                    label = "CCTV-tavara",
                },
                cctvMaintenanceThreshold = {
                    description = "Kestävyysraja, jonka jälkeen CCTV-huoltoa suositellaan.",
                    label = "Huoltoraja",
                },
                cctvMaxDurability = {
                    description = "CCTV-kameran suurin kestävyys.",
                    label = "CCTV:n kestävyys",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Sekunnit ennen kuin kamera voi luoda uuden liikehälytyksen.",
                    label = "Hälytyksen viive",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Millisekunnit asiakaspuolen liikeskannausten välillä.",
                    label = "Tarkistusväli",
                },
                cctvMotionClientCooldownMs = {
                    description = "Millisekunnit ennen kuin sama asiakas voi ilmoittaa samasta kamerasta uudelleen.",
                    label = "Asiakkaan ilmoitusviive",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Ota liikehälytykset automaattisesti käyttöön uusissa CCTV-kameroissa.",
                    label = "Uudet kamerat oletuksena käyttöön",
                },
                cctvMotionDetectionEnabled = {
                    description = "Ota käyttöön kamerakohtaiset liikkeentunnistuksen hälytykset.",
                    label = "Liikehälytykset",
                },
                cctvMotionDetectionRadius = {
                    description = "Liikkeentunnistuksen enimmäisetäisyys metreinä.",
                    label = "Tunnistussäde",
                },
                cctvMotionFieldOfView = {
                    description = "Liikkeentunnistuskartion kulma asteina.",
                    label = "Näkökenttä",
                },
                cctvMotionJobs = {
                    description = "Työnimet tai työryhmät, jotka vastaanottavat CCTV-liikehälytykset.",
                    itemLabel = "Työ tai ryhmä",
                    label = "Hälytyksen työt",
                },
                cctvMotionMinimumSpeed = {
                    description = "Kohteen vähimmäisnopeus metreinä sekunnissa, jotta se lasketaan liikkeeksi.",
                    label = "Liikkeen vähimmäisnopeus",
                },
                cctvMoveStep = {
                    description = "CCTV-kameroiden sijoittelussa käytettävä liikutusaskel.",
                    label = "Liikutusaskel",
                },
                cctvPropModel = {
                    description = "Asennetuissa CCTV-kameroissa käytettävä esinemalli.",
                    label = "CCTV-esinemalli",
                },
                cctvRepairAnimDict = {
                    description = "CCTV-kameroiden korjaamisen aikana käytettävä animaatiokirjasto.",
                    label = "Korjausanimaation kirjasto",
                },
                cctvRepairAnimFlag = {
                    description = "CCTV-kameroiden korjaamisen aikana käytettävä animaation lippu.",
                    label = "Korjausanimaation lippu",
                },
                cctvRepairAnimName = {
                    description = "CCTV-kameroiden korjaamisen aikana käytettävä animaation nimi.",
                    label = "Korjausanimaation nimi",
                },
                cctvRepairCancelDelayMs = {
                    description = "Millisekunnit ennen kuin CCTV-korjaus voidaan perua.",
                    label = "Korjauksen perumisviive",
                },
                cctvRepairDistance = {
                    description = "Etäisyys, jota käytetään CCTV-kameroiden korjaamiseen.",
                    label = "Korjausetäisyys",
                },
                cctvRepairItem = {
                    description = "CCTV-kameroiden korjaamiseen käytettävä varaston tavara.",
                    label = "Korjaustavara",
                },
                cctvRepairPerTick = {
                    description = "Kestävyys, joka palautuu per CCTV-korjausjakso.",
                    label = "Korjaus per jakso",
                },
                cctvRepairTickMs = {
                    description = "Millisekunnit CCTV-korjauksen jaksojen välillä.",
                    label = "Korjauksen jakso",
                },
                cctvRotateStep = {
                    description = "CCTV-kameroiden sijoittelussa käytettävä kiertoaskel.",
                    label = "Kiertoaskel",
                },
                cctvStreamDistance = {
                    description = "Etäisyys, jota käytetään CCTV-kameroiden lataamiseen.",
                    label = "Latausetäisyys",
                },
                cctvViewOffset = {
                    description = "CCTV:n suoratoiston renderöinnissä käytettävä näkymän siirtymä.",
                    label = "Näkymän siirtymä",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Luo nauhan suuntaisen törmäysesteen, jotta pelaajat eivät voi kävellä sen läpi.",
                    label = "Nauhan estävä törmäys",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Poista yksi eristysnauhatavara varastosta onnistuneen sijoittamisen jälkeen.",
                    label = "Kuluta eristysnauha",
                },
                crimeSceneTapeDynamic = {
                    description = "Anna nauhan reagoida fysiikkaan ja painovoimaan sen sijaan, että se lukitaan paikalleen.",
                    label = "Dynaaminen fysiikka",
                },
                crimeSceneTapeEnabled = {
                    description = "Salli rikospaikan eristysnauhan sijoittaminen varastotavaraa käyttämällä.",
                    label = "Rikospaikan eristysnauha",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Vain sallitut ammatit saavat poistaa nauhan, ja vaadittaessa heidän on oltava työvuorossa.",
                    label = "Rajoita poistamista",
                },
                crimeSceneTapeItem = {
                    description = "Varastotavaran nimi, joka käynnistää rikospaikan eristysnauhan sijoittamisen.",
                    label = "Eristysnauhan tavara",
                },
                crimeSceneTapeJobs = {
                    description = "Ammatit, jotka saavat käyttää rikospaikan eristysnauhaa.",
                    itemLabel = "Ammatti",
                    label = "Sallitut ammatit",
                },
                crimeSceneTapeLabel = {
                    description = "Rikospaikan eristysnauhasta sijoittamisen aikana näytettävä nimi.",
                    label = "Eristysnauhan nimi",
                },
                crimeSceneTapeLengthStep = {
                    description = "Metreissä määritetty askel, johon valittu nauhan pituus pyöristetään.",
                    label = "Pituusaskel",
                },
                crimeSceneTapeMaxLength = {
                    description = "Pisin sallittu etäisyys kahden nauhatolpan välillä metreinä.",
                    label = "Nauhan enimmäispituus",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Kummankin päätepisteen suurin etäisyys nauhaa sijoittavasta poliisista.",
                    label = "Suurin sijoitusetäisyys",
                },
                crimeSceneTapeMinLength = {
                    description = "Lyhin sallittu etäisyys kahden nauhatolpan välillä metreinä.",
                    label = "Nauhan vähimmäispituus",
                },
                crimeSceneTapeModel = {
                    description = "Sijoitetussa rikospaikan eristysnauhassa käytettävän esinemallin nimi.",
                    label = "Eristysnauhan malli",
                },
                crimeSceneTapePostModel = {
                    description = "Molemmissa nauhatolpissa käytettävä esinemalli.",
                    label = "Tolpan malli",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Enimmäisetäisyys, jolta sijoitettu rikospaikan eristysnauha voidaan poistaa.",
                    label = "Poistoetäisyys",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Vain sallittujen ammattien työvuorossa olevat jäsenet saavat sijoittaa nauhan.",
                    label = "Vaadi työvuoro",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Palauta kulutettu tavara, kun sijoitettu eristysnauha poistetaan.",
                    label = "Palauta tavara poistettaessa",
                },
                crimeSceneTapeSag = {
                    description = "Nauhan suurin alaspäin suuntautuva riippuma tolppien välillä metreinä.",
                    label = "Nauhan riippuma",
                },
                crimeSceneTapeSections = {
                    description = "Valitun pituuden kokoamiseen käytettävät natiivit nauhaosuuksien mallit.",
                    itemLabel = "Nauhaosuus",
                    label = "Nauhaosuudet",
                },
                crimeSceneTapeShowPosts = {
                    description = "Luo näkyvät tukitolpat säädettävän rikospaikkanauhan molempiin päihin.",
                    label = "Näytä nauhan tolpat",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Etäisyys, jonka sisällä sijoitettu rikospaikan eristysnauha ladataan.",
                    label = "Latausetäisyys",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Nauhan korkeus valittujen maanpinnan pisteiden yläpuolella.",
                    label = "Nauhan korkeus",
                },
                crimeSceneTapeVariableLength = {
                    description = "Antaa poliisien määrittää alku- ja loppupisteen ja sijoittaa rikospaikan eristysnauhan säädettävän pituisena.",
                    label = "Muuttuva nauhan pituus",
                },
                crimeSceneTapeZOffset = {
                    description = "Eristysnauhan malliin sijoitettaessa käytettävä pystysuuntainen siirtymä.",
                    label = "Korkeussiirtymä",
                },
                cuffsAnimDict = {
                    description = "Rajoitetuille pelaajille käytettävä animaatiokirjasto.",
                    label = "Animaatiokirjasto",
                },
                cuffsAnimFlag = {
                    description = "Rajoitetuille pelaajille käytettävä animaation lippu.",
                    label = "Animaation lippu",
                },
                cuffsAnimName = {
                    description = "Rajoitetuille pelaajille käytettävä animaation nimi.",
                    label = "Animaation nimi",
                },
                cuffsConsumeItem = {
                    description = "Poista käsirautatavara, kun raudat laitetaan.",
                    label = "Kuluta raudat",
                },
                cuffsEnabled = {
                    description = "Ota käyttöön käsirautojen toiminnot.",
                    label = "Käsiraudat",
                },
                cuffsEscapeEnabled = {
                    description = "Ota käyttöön rautojen pakenemisen minipeli.",
                    label = "Rautojen pakeneminen",
                },
                cuffsEscapeKeyPool = {
                    description = "Näppäimet, jotka voivat esiintyä rautojen pakenemisen minipelissä.",
                    itemLabel = "Näppäin",
                    label = "Pakenemisen näppäinvalikoima",
                },
                cuffsEscapeRounds = {
                    description = "Rautojen pakenemisen minipelissä vaadittavien kierrosten määrä.",
                    label = "Pakenemisen kierrokset",
                },
                cuffsEscapeWindowMs = {
                    description = "Millisekunnit, jotka on käytettävissä yhtä pakenemisen syöteikkunaa kohden.",
                    label = "Pakenemisen aikaikkuna",
                },
                cuffsHandsUpEnabled = {
                    description = "Ota käyttöön rautojen ja siimapantojen käyttämä kädet ylhäällä -tila.",
                    label = "Kädet ylös",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Sekunnit, jotka kädet ylös -näppäintä on pidettävä pohjassa ennen aktivointia.",
                    label = "Kädet ylös -painalluksen kesto",
                },
                cuffsHandsUpKey = {
                    description = "Näppäimistön näppäin, jota käytetään käsien nostamiseen ylös.",
                    label = "Kädet ylös -näppäin",
                },
                cuffsItem = {
                    description = "Käsirautojen toiminnoissa käytettävä varaston tavara.",
                    label = "Rautojen tavara",
                },
                cuffsMaxDistance = {
                    description = "Suurin kohde-etäisyys rautojen toiminnoille.",
                    label = "Rautojen etäisyys",
                },
                cuffsRequireItem = {
                    description = "Vaadi määritetty käsirautatavara.",
                    label = "Raudat vaativat tavaran",
                },
                cuffsRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen käsirautojen laittamista.",
                    label = "Raudat vaativat työvuoron",
                },
                cuffsReturnOnRemove = {
                    description = "Palauta käsirautatavara, kun raudat poistetaan.",
                    label = "Palauta raudat",
                },
                dispatchOfficerDownEnabled = {
                    description = "Lähetä hälytys, kun työvuorossa oleva virkamies kaatuu.",
                    label = "Virkamies alas -hälytykset",
                },
                dispatchOfficerDownJobs = {
                    description = "Työt, joiden tulisi vastaanottaa virkamies alas -hälytyksiä.",
                    itemLabel = "Työ",
                    label = "Virkamies alas -hälytyksen työt",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Ilmoita vain pelaajille, jotka ovat parhaillaan työvuorossa.",
                    label = "Virkamies alas vaatii työvuoron",
                },
                dispatchShotsFiredChance = {
                    description = "Todennäköisyys välillä 0.0–1.0, jolla havaittu laukaus luo hälytyksen.",
                    label = "Hälytyksen todennäköisyys",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Sekunnit ennen kuin sama pelaaja voi laukaista uuden laukaushälytyksen.",
                    label = "Laukausten jäähdytys",
                },
                dispatchShotsFiredEnabled = {
                    description = "Ota käyttöön laukausten hälytysilmoitukset.",
                    label = "Laukausten hälytykset",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Aseet, jotka eivät laukaise laukaushälytyksiä.",
                    itemLabel = "Ase",
                    label = "Ohitetut aseet",
                },
                dispatchShotsFiredJobs = {
                    description = "Työt, joiden tulisi vastaanottaa laukaushälytyksiä.",
                    itemLabel = "Työ",
                    label = "Laukausten hälytystyöt",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Ilmoita vain pelaajille, jotka ovat parhaillaan työvuorossa.",
                    label = "Laukaukset vaativat työvuoron",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Luo hälytysmerkintä, kun laukauksia havaitaan.",
                    label = "Lähetä laukaushälytys",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Todennäköisyys välillä 0.0–1.0, jolla havaittu vaimennettu laukaus luo hälytyksen.",
                    label = "Vaimennetun laukauksen hälytystodennäköisyys",
                },
                escortEnabled = {
                    description = "Ota käyttöön pelaajien saattaminen.",
                    label = "Saattaminen",
                },
                escortMaxDistance = {
                    description = "Suurin etäisyys pelaajan saattamisen aloittamiseen.",
                    label = "Saattoetäisyys",
                },
                escortRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen pelaajien saattamista.",
                    label = "Saattaminen vaatii työvuoron",
                },
                escortVehicleDistance = {
                    description = "Suurin etäisyys saatettavan pelaajan sijoittamiseksi ajoneuvoon.",
                    label = "Saatettavan ajoneuvoetäisyys",
                },
                evidenceBloodDamageThreshold = {
                    description = "Pienin vahinkoraja ennen kuin veritodiste luodaan.",
                    label = "Veren vahinkoraja",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Millisekunnit ennen kuin toinen hylsy voidaan luoda.",
                    label = "Hylsyn jäähdytys",
                },
                evidenceCasingMergeRadius = {
                    description = "Säde, jota käytetään lähekkäisten hylsyjen yhdistämiseen.",
                    label = "Hylsyjen yhdistämissäde",
                },
                evidenceCleanupIntervalMs = {
                    description = "Millisekunnit todisteiden siivouskierrosten välillä.",
                    label = "Siivousväli",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Sekunnit ennen kuin kenttätodisteet vanhenevat automaattisesti.",
                    label = "Siivouksen elinaika",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Puhdistusaine kaikille",
                    description = "Salli kaikkien poistaa jälkiä vetyperoksidilla. Poista käytöstä käyttääksesi työ- ja jengilistoja.",
                },
                evidenceCleanerJobs = {
                    label = "Puhdistusaineen työt",
                    description = "Sallitut sisäiset nimet, kun julkinen käyttö on poistettu käytöstä. Työn tai jengin vastaavuus sallii käytön; tyhjät listat estävät sen.",
                    itemLabel = "Työ",
                },
                evidenceCleanerGangs = {
                    label = "Puhdistusaineen jengit",
                    description = "Sallitut sisäiset nimet, kun julkinen käyttö on poistettu käytöstä. Työn tai jengin vastaavuus sallii käytön; tyhjät listat estävät sen.",
                    itemLabel = "Jengi",
                },
                evidenceCollectDistance = {
                    description = "Etäisyys, jota käytetään kenttätodisteiden keräämiseen.",
                    label = "Keräysetäisyys",
                },
                evidenceDiscoverDistance = {
                    description = "Etäisyys, jota käytetään lähellä olevien todistemerkkien löytämiseen.",
                    label = "Löytöetäisyys",
                },
                evidenceFieldEnabled = {
                    description = "Ota käyttöön todisteiden luominen ja kerääminen kentällä.",
                    label = "Kenttätodisteet",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Ase, jota käytetään todisteiden tarkastamiseen ja paljastamiseen kentällä.",
                    label = "Taskulampun ase",
                },
                evidenceGloveFreeHands = {
                    description = "Käsikomponenttien tunnukset, joita ei katsota hansikkaiden käytöksi.",
                    label = "Paljaat kädet",
                },
                evidenceMarkerColor = {
                    description = "Kenttätodisteiden merkeissä käytettävä RGBA-väri.",
                    label = "Merkin väri",
                },
                evidenceMarkerDrawDistance = {
                    description = "Kenttätodisteiden merkeissä käytettävä piirtoetäisyys.",
                    label = "Piirtoetäisyys",
                },
                evidenceMarkerOffset = {
                    description = "Kenttätodisteiden merkin pystysuuntainen siirtymä.",
                    label = "Siirtymä",
                },
                evidenceMarkerScaleX = {
                    description = "Kenttätodisteiden merkin X-skaala.",
                    label = "X-skaala",
                },
                evidenceMarkerScaleY = {
                    description = "Kenttätodisteiden merkin Y-skaala.",
                    label = "Y-skaala",
                },
                evidenceMarkerScaleZ = {
                    description = "Kenttätodisteiden merkin Z-skaala.",
                    label = "Z-skaala",
                },
                evidenceMarkerType = {
                    description = "Kenttätodisteissa käytettävä merkkityyppi.",
                    label = "Merkin tyyppi",
                },
                evidenceMaxCreateDistance = {
                    description = "Suurin etäisyys todistemerkintöjen luomiseen.",
                    label = "Luontietäisyys",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Millisekunnit, jotka sylkinäytteen suostumukselle on aikaa.",
                    label = "Sylkinäytteen suostumuksen aikakatkaisu",
                },
                evidenceScannerDistance = {
                    description = "Etäisyys, jota käytetään todisteskannerin vuorovaikutuksiin.",
                    label = "Skannerin etäisyys",
                },
                evidenceScannerDurationMs = {
                    description = "Sormenjälki-/skannaustoiminnon kesto millisekunteina.",
                    label = "Skannerin kesto",
                },
                evidenceStorageMaxCompartments = {
                    description = "Todistevaraston lokeroiden suurin määrä.",
                    label = "Varaston lokerot",
                },
                gpsTrackerBeepDistance = {
                    description = "Etäisyys, jolla GPS-seuraimen piippauspalaute tulee merkitykselliseksi.",
                    label = "Piippausetäisyys",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Millisekunnit piippausten välillä kaukana seuraimesta.",
                    label = "Kaukopiippauksen väli",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Millisekunnit piippausten välillä lähellä seurainta.",
                    label = "Lähipiippauksen väli",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Poista seurantalaitteen tavara sijoittamisen jälkeen.",
                    label = "Kuluta GPS-seurain",
                },
                gpsTrackerEnabled = {
                    description = "Ota käyttöön ajoneuvon GPS-seurainten sijoittelu ja skannaus.",
                    label = "GPS-seurain",
                },
                gpsTrackerItem = {
                    description = "GPS-seurainten sijoittamiseen käytettävä varaston tavara.",
                    label = "Seurantalaitteen tavara",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Millisekunnit seuraimen karttapäivitysten välillä.",
                    label = "Kartan päivitysväli",
                },
                gpsTrackerPlaceDistance = {
                    description = "Suurin etäisyys GPS-seuraimen sijoittamiseen ajoneuvoon.",
                    label = "Sijoitusetäisyys",
                },
                gpsTrackerRemoveDistance = {
                    description = "Suurin etäisyys sijoitetun GPS-seuraimen poistamiseen.",
                    label = "Poistoetäisyys",
                },
                gpsTrackerRemoveKey = {
                    description = "Ohjauskoodi, jota käytetään sijoitetun GPS-seuraimen poistamiseen.",
                    label = "Poiston näppäin",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen GPS-seurainten käyttöä.",
                    label = "GPS vaatii työvuoron",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Vaadi, että pelaaja kuuluu poliisiryhmään ennen GPS-seurainten käyttöä.",
                    label = "GPS vaatii poliisin työn",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Palauta seurantalaitteen tavara, kun se poistetaan.",
                    label = "Palauta seurain poistettaessa",
                },
                gpsTrackerScanDistance = {
                    description = "Suurin etäisyys seurainten skannaamiseen.",
                    label = "GPS-skannauksen etäisyys",
                },
                gpsTrackerScanDurationMs = {
                    description = "Millisekunnit, jotka GPS-seuraimen skannaamiseen kuluu.",
                    label = "Skannauksen kesto",
                },
                gpsTrackerScannerWeapon = {
                    description = "Ase tai työkalu, jota käytetään GPS-seurainten etsimiseen.",
                    label = "Skannerin ase",
                },
                impoundAccount = {
                    description = "Tili, jota käytetään takavarikoiden vapautusten veloittamiseen.",
                    label = "Maksutili",
                },
                impoundCreatorVehicleModel = {
                    description = "Ajoneuvomalli, joka näytetään takavarikon luojan esikatselussa.",
                    label = "Luojan ajoneuvomalli",
                },
                impoundCustomGarageEnabled = {
                    description = "Käytä mukautettua tallin takavarikointiliittymää, jos saatavilla.",
                    label = "Mukautettu tallin takavarikointi",
                },
                impoundDefaultPrice = {
                    description = "Takavarikon vapautuksen oletushinta.",
                    label = "Oletushinta",
                },
                impoundDeliveryDistance = {
                    description = "Etäisyys, jota käytetään takavarikon toimituksen vuorovaikutuksiin.",
                    label = "Toimitusetäisyys",
                },
                impoundDeliveryMarker = {
                    description = "Takavarikon toimituksissa käytettävä merkkiasetus.",
                    label = "Toimituksen merkki",
                },
                impoundEnabled = {
                    description = "Ota käyttöön takavarikoinnin toiminnot.",
                    label = "Takavarikointi",
                },
                impoundMarker = {
                    description = "Takavarikon vuorovaikutuksissa käytettävä merkkiasetus.",
                    label = "Takavarikon merkki",
                },
                impoundRadialEnabled = {
                    description = "Ota käyttöön takavarikoinnin toimintopyörän toiminnot.",
                    label = "Takavarikkotoiminto",
                },
                impoundRadialRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen takavarikoinnin toimintopyörän toiminnon käyttöä.",
                    label = "Takavarikointi vaatii työvuoron",
                },
                impoundRadialVehicleDistance = {
                    description = "Suurin etäisyys kohdeajoneuvoon toimintopyörän takavarikointitoiminnoissa.",
                    label = "Takavarikoinnin ajoneuvoetäisyys",
                },
                impoundReleaseDistance = {
                    description = "Etäisyys, jota käytetään takavarikon vapautuksen vuorovaikutuksiin.",
                    label = "Vapautusetäisyys",
                },
                impoundReleaseKey = {
                    description = "Ohjauskoodi, jota käytetään takavarikoitujen ajoneuvojen vapauttamiseen.",
                    label = "Vapautuksen näppäin",
                },
                impoundRequireDelivery = {
                    description = "Vaadi toimitus määritettyyn takavarikointipaikkaan.",
                    label = "Vaadi toimitus",
                },
                impoundStorageBasePrice = {
                    description = "Säilytyksessä olevien takavarikoitujen ajoneuvojen vapautuksen perushinta.",
                    label = "Säilytyksen perushinta",
                },
                impoundStorageDailyFee = {
                    description = "Lisämaksu takavarikon säilytyksestä per määritetty päivä.",
                    label = "Säilytyksen päivämaksu",
                },
                impoundStorageDaySeconds = {
                    description = "Kuinka monta sekuntia lasketaan yhdeksi säilytyksen laskutuspäiväksi.",
                    label = "Säilytyspäivän sekunnit",
                },
                impoundStorageEnabled = {
                    description = "Ota käyttöön maksullinen takavarikon säilytyksen käsittely.",
                    label = "Takavarikon säilytys",
                },
                jailAssignRange = {
                    description = "Suurin etäisyys kohteen määräämiseen vankilaan.",
                    label = "Määräysetäisyys",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minuutit, jotka vangin on odotettava ennen seuraavan kanttiinipaketin lunastamista.",
                    label = "Jäähdytysminuutit",
                },
                jailCanteenPackage = {
                    description = "Vankilan kanttiinipaketin myöntämät tavarat.",
                    label = "Kanttiinipaketti",
                },
                jailCellStreamDistance = {
                    description = "Etäisyys, jota käytetään eristyssellin esineiden lataamiseen.",
                    label = "Sellin latausetäisyys",
                },
                jailClearInventory = {
                    description = "Tyhjennä pelaajan varasto, kun hänet lähetetään vankilaan.",
                    label = "Tyhjennä varasto",
                },
                jailDefaultMonths = {
                    description = "Oletusarvoinen vankeusaika, kun määräämisen käyttöliittymä avataan.",
                    label = "Oletuskuukaudet",
                },
                jailDispatchJobs = {
                    description = "Työt, joiden tulisi vastaanottaa vankilahälytyksiä.",
                    itemLabel = "Työ",
                    label = "Hälytyksen kohdetyöt",
                },
                jailDoctorHealEvent = {
                    description = "Palvelin- tai asiakastapahtuma, joka laukaistaan, kun vankilalääkäri parantaa vangin.",
                    label = "Parannustapahtuma",
                },
                jailElectricalCodeListItem = {
                    description = "Varaston tavara, joka vaaditaan luotujen sähkökoodien paljastamiseen.",
                    label = "Koodilistan tavara",
                },
                jailElectricalCodeMax = {
                    description = "Sähkökeskuksen satunnaisen koodin suurin arvo.",
                    label = "Suurin koodi",
                },
                jailElectricalCodeMin = {
                    description = "Sähkökeskuksen satunnaisen koodin pienin arvo.",
                    label = "Pienin koodi",
                },
                jailElectricalCodesCount = {
                    description = "Kuinka monta ehdokaskoodia sähkökeskukselle luodaan.",
                    label = "Koodien määrä",
                },
                jailElectricalEnabled = {
                    description = "Ota käyttöön vankilan sähkökeskuksen pakenemisen minipeli.",
                    label = "Sähkökeskus",
                },
                jailElectricalPinLength = {
                    description = "Sähkökeskuksen PIN-koodeissa käytettävien numeroiden määrä.",
                    label = "PIN-koodin pituus",
                },
                jailElectricalPropModel = {
                    description = "Vankilan sähkökeskuksessa käytettävä maailman esinemalli.",
                    label = "Esinemalli",
                },
                jailElectricalShockDamage = {
                    description = "Vahinko, joka aiheutuu, kun vanki epäonnistuu sähkösekvenssissä.",
                    label = "Sähköiskun vahinko",
                },
                jailElectricalShockRagdollMs = {
                    description = "Millisekunnit, joina vanki on kaatuneena sähköiskun jälkeen.",
                    label = "Sähköiskun kaatuminen",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Tuomiosta vähennettävät minuutit onnistuneen sähköpakoyrityksen jälkeen.",
                    label = "Onnistumisen lyhennysminuutit",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Alkoholistivangin kaupankäynnissä vaadittava määrä.",
                    label = "Vaadittu määrä",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Alkoholistivangin kaupankäynnissä vaadittava tavara.",
                    label = "Vaadittu tavara",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Alkoholistivangin kaupankäynnin palkinnon määrä.",
                    label = "Palkinnon määrä",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Alkoholistivangin kaupankäynnin palkintotavara.",
                    label = "Palkintotavara",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Alkoholistivangin kaupankäynnissä näytettävä palkinnon nimike.",
                    label = "Palkinnon nimike",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Ilmiantajavangin kaupankäynnissä vaadittava määrä.",
                    label = "Vaadittu määrä",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Ilmiantajavangin kaupankäynnissä vaadittava tavara.",
                    label = "Vaadittu tavara",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Ilmiantajavangin kaupankäynnin palkinnon määrä.",
                    label = "Palkinnon määrä",
                },
                jailInmateCodeListRewardItem = {
                    description = "Ilmiantajavangin kaupankäynnin palkintotavara.",
                    label = "Palkintotavara",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Ilmiantajavangin kaupankäynnissä näytettävä palkinnon nimike.",
                    label = "Palkinnon nimike",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Huumekauppiasvangin kaupankäynnissä hyväksyttävät tavarat.",
                    label = "Hyväksytyt tavarat",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Huumekauppiasvangin kaupankäynnissä vaadittava määrä.",
                    label = "Vaadittu määrä",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Huumekauppiasvangin kaupankäynnin palkinnon määrä.",
                    label = "Palkinnon määrä",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Huumekauppiasvangin kaupankäynnin palkintotavara.",
                    label = "Palkintotavara",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Huumekauppiasvangin kaupankäynnissä näytettävä palkinnon nimike.",
                    label = "Palkinnon nimike",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Salli siivouksessa löydettyjen kiellettyjen tavaroiden käyttö huumekauppiasvangin kaupankäynnissä.",
                    label = "Käytä siivouksen kiellettyjä tavaroita",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Työkaluvälittäjävangin kaupankäynnissä vaadittava määrä.",
                    label = "Vaadittu määrä",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Työkaluvälittäjävangin kaupankäynnissä vaadittava tavara.",
                    label = "Vaadittu tavara",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Työkaluvälittäjävangin kaupankäynnin palkinnon määrä.",
                    label = "Palkinnon määrä",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Työkaluvälittäjävangin kaupankäynnin palkintotavara.",
                    label = "Palkintotavara",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Työkaluvälittäjävangin kaupankäynnissä näytettävä palkinnon nimike.",
                    label = "Palkinnon nimike",
                },
                jailJobsCarryBoxModel = {
                    description = "Vankilan kantotyön laatikossa käytettävä esinemalli.",
                    label = "Kantolaatikon malli",
                },
                jailJobsCarryDropoffKey = {
                    description = "Ohjauskoodi, jota käytetään kantotyön laatikoiden pudottamiseen.",
                    label = "Kantotyön pudotusnäppäin",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Vankilan kantotyön pudotussäde.",
                    label = "Pudotussäde",
                },
                jailJobsCarryInspectKey = {
                    description = "Ohjauskoodi, jota käytetään kantotyön laatikoiden tarkastamiseen.",
                    label = "Tarkastusnäppäin",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Romutavarat, joita voi löytää kantotyön laatikoita tarkastettaessa.",
                    label = "Romutavarat tarkastuksessa",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Todennäköisyys saada käyttökelpoinen palkinto laatikoita tarkastettaessa.",
                    label = "Käyttökelpoisen löydön todennäköisyys",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Käyttökelpoiset tavarat, joita voi löytää kantotyön laatikoita tarkastettaessa.",
                    label = "Käyttökelpoiset tarkastustavarat",
                },
                jailJobsCarryInteractDistance = {
                    description = "Vankilan kantotyön vuorovaikutusetäisyys.",
                    label = "Kantotyön vuorovaikutusetäisyys",
                },
                jailJobsCarryMaxDistance = {
                    description = "Suurin sallittu etäisyys vankilan kantotyön etenemiselle.",
                    label = "Kantotyön enimmäisetäisyys",
                },
                jailJobsCarryPickupKey = {
                    description = "Ohjauskoodi, jota käytetään kantotyön laatikoiden poimimiseen.",
                    label = "Kantotyön nostonäppäin",
                },
                jailJobsCarryPickupOffset = {
                    description = "Siirtymäobjekti, jota käytetään kantotyön noutopaikassa.",
                    label = "Nostopaikan siirtymä",
                },
                jailJobsCarryTimeReduction = {
                    description = "Tuomion lyhennys kantotyön suorittamisesta.",
                    label = "Kantotyön ajanlyhennys",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Ohjauskoodi, jota käytetään vankilan jäteastialla.",
                    label = "Jäteastian näppäin",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Vankilan siivouksen jäteastian esineen malli.",
                    label = "Jäteastian malli",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Todennäköisyys löytää kiellettyä tavaraa siivotessa.",
                    label = "Kiellettyjen tavaroiden todennäköisyys",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Tavarat, joita voi löytää siivotessa vankilassa.",
                    label = "Kiellettyjen löytöjen tavarat",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Kiellettyjen löytöjen kehotteiden aikakatkaisu millisekunteina.",
                    label = "Löydön kehotteen aikakatkaisu",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Etäisyys, jota käytetään siivousroskien vuorovaikutukseen.",
                    label = "Siivouksen vuorovaikutusetäisyys",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Suurin etäisyys ennen kuin siivousesineet nollautuvat tai katoavat.",
                    label = "Siivouksen enimmäisetäisyys",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Vankilan siivouksen samanaikaisten roskaesineiden enimmäismäärä.",
                    label = "Roskaesineiden enimmäismäärä",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Pienin etäisyys keskipisteestä siivousroskien luomiselle.",
                    label = "Pienin spawn-säde",
                },
                jailJobsCleaningPickupKey = {
                    description = "Ohjauskoodi, jota käytetään vankilan siivousroskien poimimiseen.",
                    label = "Siivouksen nostonäppäin",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Millisekunnit siivousroskien luontiyritysten välillä.",
                    label = "Roskien spawn-väli",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Säde, jota käytetään siivousroskien esineiden luomiseen.",
                    label = "Roskien spawn-säde",
                },
                jailJobsCleaningTrashModels = {
                    description = "Vankilan siivoustyössä käytettävät roskaesineiden mallit.",
                    itemLabel = "Malli",
                    label = "Roskien mallit",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Vankilan siivousroskaesineissä käytettävä RGBA-ääriviivaväri.",
                    label = "Ääriviivan väri",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Ota käyttöön ääriviivat vankilan siivousroskaesineissä.",
                    label = "Roskien ääriviiva",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "Vankilan siivousroskien ääriviivoissa käytettävä sävytin (shader) ID.",
                    label = "Ääriviivan sävytin",
                },
                jailJobsTimeReduction = {
                    description = "Tuomion lyhennys siivoustyön suorittamisesta.",
                    label = "Siivouksen ajanlyhennys",
                },
                jailJobsTrashGoal = {
                    description = "Roskien määrä, joka vaaditaan siivoustyön suorittamiseen.",
                    label = "Siivouksen roskatavoite",
                },
                jailMaxMonths = {
                    description = "Suurin valittavissa oleva vankeusaika.",
                    label = "Enimmäiskuukaudet",
                },
                jailMinMonths = {
                    description = "Pienin valittavissa oleva vankeusaika.",
                    label = "Vähimmäiskuukaudet",
                },
                jailMonthMinutes = {
                    description = "Reaaliaikaminuutit, jotka vastaavat yhtä vankilakuukautta.",
                    label = "Minuuttia kuukaudessa",
                },
                jailObjectStreamDistance = {
                    description = "Etäisyys, jota käytetään pysyvien vankilamaailman objektien lataamiseen.",
                    label = "Objektien latausetäisyys",
                },
                jailOutfitApplyDelayMs = {
                    description = "Viive liittymisen jälkeen ennen kuin vankilan asu asetetaan.",
                    label = "Asun asettamisen viive",
                },
                jailOutfitEnabled = {
                    description = "Ota käyttöön vankilan asut.",
                    label = "Vankilan asu",
                },
                jailOutfitFemaleArms = {
                    description = "Naisten vankilan asun käsivarsikomponentti.",
                    label = "Käsivarret",
                },
                jailOutfitFemaleChain1 = {
                    description = "Naisten vankilan asun ketjun malli (drawable).",
                    label = "Ketju 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Naisten vankilan asun ketjun tekstuuri.",
                    label = "Ketju 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Naisten vankilan asun tarrojen malli (drawable).",
                    label = "Tarrat 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Naisten vankilan asun tarrojen tekstuuri.",
                    label = "Tarrat 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Naisten vankilan asun silmälasien malli (drawable, -1 poistaa silmälasit).",
                    label = "Silmälasit 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Naisten vankilan asun silmälasien tekstuuri.",
                    label = "Silmälasit 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Naisten vankilan asun kypärän malli (drawable).",
                    label = "Kypärä 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Naisten vankilan asun kypärän tekstuuri.",
                    label = "Kypärä 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Naisten vankilan asun housujen malli (drawable).",
                    label = "Housut 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Naisten vankilan asun housujen tekstuuri.",
                    label = "Housut 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Naisten vankilan asun kenkien malli (drawable).",
                    label = "Kengät 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Naisten vankilan asun kenkien tekstuuri.",
                    label = "Kengät 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Naisten vankilan asun yläosan malli (drawable).",
                    label = "Yläosa 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Naisten vankilan asun yläosan tekstuuri.",
                    label = "Yläosa 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Naisten vankilan asun T-paidan malli (drawable).",
                    label = "T-paita 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Naisten vankilan asun T-paidan tekstuuri.",
                    label = "T-paita 2",
                },
                jailOutfitMaleArms = {
                    description = "Miesten vankilan asun käsivarsikomponentti.",
                    label = "Käsivarret",
                },
                jailOutfitMaleChain1 = {
                    description = "Miesten vankilan asun ketjun malli (drawable).",
                    label = "Ketju 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Miesten vankilan asun ketjun tekstuuri.",
                    label = "Ketju 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Miesten vankilan asun tarrojen malli (drawable).",
                    label = "Tarrat 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Miesten vankilan asun tarrojen tekstuuri.",
                    label = "Tarrat 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Miesten vankilan asun silmälasien malli (drawable, -1 poistaa silmälasit).",
                    label = "Silmälasit 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Miesten vankilan asun silmälasien tekstuuri.",
                    label = "Silmälasit 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Miesten vankilan asun kypärän malli (drawable).",
                    label = "Kypärä 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Miesten vankilan asun kypärän tekstuuri.",
                    label = "Kypärä 2",
                },
                jailOutfitMalePants1 = {
                    description = "Miesten vankilan asun housujen malli (drawable).",
                    label = "Housut 1",
                },
                jailOutfitMalePants2 = {
                    description = "Miesten vankilan asun housujen tekstuuri.",
                    label = "Housut 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Miesten vankilan asun kenkien malli (drawable).",
                    label = "Kengät 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Miesten vankilan asun kenkien tekstuuri.",
                    label = "Kengät 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Miesten vankilan asun yläosan malli (drawable).",
                    label = "Yläosa 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Miesten vankilan asun yläosan tekstuuri.",
                    label = "Yläosa 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Miesten vankilan asun T-paidan malli (drawable).",
                    label = "T-paita 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Miesten vankilan asun T-paidan tekstuuri.",
                    label = "T-paita 2",
                },
                jailRequireJailTerminal = {
                    description = "Salli poliisin määräämä vankeus vain valitun vankilan terminaalin lähellä.",
                    label = "Vaadi vankilaterminaali",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Palauta tallennettu siviiliasu, kun vanki pakenee.",
                    label = "Palauta asu paon yhteydessä",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Armonaika palautuksen jälkeen, ennen kuin spawn-korjaus lakkaa vaikuttamasta.",
                    label = "Palautuksen korjausikkuna",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teleporttaa palautetut vangit takaisin vankilan spawniin, jos he lataantuvat vankila-alueen ulkopuolella.",
                    label = "Teleporttaa palautetut vangit",
                },
                jailTerminalRange = {
                    description = "Poliisin enimmäisetäisyys valitun vankilan terminaalista.",
                    label = "Vankilaterminaalin etäisyys",
                },
                jailZoneExitGraceMs = {
                    description = "Armonaika ennen kuin vankila-alueelta poistuminen lasketaan pakoksi.",
                    label = "Alueelta poistumisen armonaika",
                },
                mugshotAnimDict = {
                    description = "Tunnistekuvan ottamisen aikana käytettävä animaatiokirjasto.",
                    label = "Animaatiokirjasto",
                },
                mugshotAnimFlag = {
                    description = "Tunnistekuvan ottamisen aikana käytettävä animaation lippu.",
                    label = "Animaation lippu",
                },
                mugshotAnimName = {
                    description = "Tunnistekuvan ottamisen aikana käytettävä animaation nimi.",
                    label = "Animaation nimi",
                },
                mugshotBoardHeader = {
                    description = "Tunnistekuvan taulussa näytettävä pääotsikko.",
                    label = "Taulun otsikko",
                },
                mugshotBoardSubheader = {
                    description = "Tunnistekuvan taulussa näytettävä varaotsikko.",
                    label = "Taulun alaotsikko",
                },
                mugshotCameraCoordsX = {
                    description = "Tunnistekuvissa käytettävä kameran maailman X-koordinaatti.",
                    label = "Kamera X",
                },
                mugshotCameraCoordsY = {
                    description = "Tunnistekuvissa käytettävä kameran maailman Y-koordinaatti.",
                    label = "Kamera Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Tunnistekuvissa käytettävä kameran maailman Z-koordinaatti.",
                    label = "Kamera Z",
                },
                mugshotCameraFov = {
                    description = "Tunnistekuvien ottamisessa käytettävä kuvakulma.",
                    label = "Kameran kuvakulma",
                },
                mugshotCameraRotX = {
                    description = "Tunnistekuvissa käytettävä kameran X-kierto.",
                    label = "Kierto X",
                },
                mugshotCameraRotY = {
                    description = "Tunnistekuvissa käytettävä kameran Y-kierto.",
                    label = "Kierto Y",
                },
                mugshotCameraRotZ = {
                    description = "Tunnistekuvissa käytettävä kameran Z-kierto.",
                    label = "Kierto Z",
                },
                mugshotCaptureTimeout = {
                    description = "Suurin sallittu millisekuntimäärä tunnistekuvan ottamisen callback-kutsuille.",
                    label = "Kuvauksen aikakatkaisu",
                },
                mugshotEnabled = {
                    description = "Ota käyttöön tunnistekuvan ottaminen vankilaan saapuessa.",
                    label = "Tunnistekuvan ottaminen",
                },
                mugshotHeading = {
                    description = "Tunnistekuvan ottamisen aikana käytettävä suunta.",
                    label = "Suunta",
                },
                mugshotLocationX = {
                    description = "Tunnistekuvan ottamisessa käytettävä maailman X-koordinaatti.",
                    label = "Sijainti X",
                },
                mugshotLocationY = {
                    description = "Tunnistekuvan ottamisessa käytettävä maailman Y-koordinaatti.",
                    label = "Sijainti Y",
                },
                mugshotLocationZ = {
                    description = "Tunnistekuvan ottamisessa käytettävä maailman Z-koordinaatti.",
                    label = "Sijainti Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Tallennetun tunnistekuvan metatiedoissa käytettävä kuvausmuoto.",
                    label = "Metatiedon kuvaus",
                },
                mugshotMetadataName = {
                    description = "Tallennetun tunnistekuvan varaston metatiedon nimi.",
                    label = "Metatiedon nimi",
                },
                mugshotWaitMs = {
                    description = "Millisekunnit, jotka odotetaan ennen tunnistekuvan ottamista.",
                    label = "Odotus millisekunteina",
                },
                playerSearchAnimDict = {
                    description = "Henkilöntarkastuksissa käytettävä animaatiokirjasto.",
                    label = "Animaatiokirjasto",
                },
                playerSearchAnimFlag = {
                    description = "Henkilöntarkastuksissa käytettävä animaation lippu.",
                    label = "Animaation lippu",
                },
                playerSearchAnimName = {
                    description = "Henkilöntarkastuksissa käytettävä animaation nimi.",
                    label = "Animaation nimi",
                },
                playerSearchDurationMs = {
                    description = "Henkilöntarkastuksen esikatselun kesto millisekunteina.",
                    label = "Tarkastuksen kesto",
                },
                playerSearchEnabled = {
                    description = "Ota käyttöön henkilöntarkastuksen esikatselutoiminto.",
                    label = "Henkilöntarkastus",
                },
                playerSearchRange = {
                    description = "Suurin etäisyys henkilöntarkastuksen aloittamiseen.",
                    label = "Tarkastusetäisyys",
                },
                playerSearchScenario = {
                    description = "Skenaario, jota käytetään, kun erillistä tarkastusanimaatiota ei toisteta.",
                    label = "Tarkastuksen skenaario",
                },
                policeBillingControl200 = {
                    label = "Laskutus · Ohjain 200",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeBillingControl322 = {
                    label = "Laskutus · Ohjain 322",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl10 = {
                    label = "Muokkain · Ohjain 10",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl11 = {
                    label = "Muokkain · Ohjain 11",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl172 = {
                    label = "Muokkain · Ohjain 172",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl173 = {
                    label = "Muokkain · Ohjain 173",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl174 = {
                    label = "Muokkain · Ohjain 174",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl175 = {
                    label = "Muokkain · Ohjain 175",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl177 = {
                    label = "Muokkain · Ohjain 177",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl191 = {
                    label = "Muokkain · Ohjain 191",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl201 = {
                    label = "Muokkain · Ohjain 201",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl202 = {
                    label = "Muokkain · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl21 = {
                    label = "Muokkain · Ohjain 21",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl32 = {
                    label = "Muokkain · Ohjain 32",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl322 = {
                    label = "Muokkain · Ohjain 322",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl33 = {
                    label = "Muokkain · Ohjain 33",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl34 = {
                    label = "Muokkain · Ohjain 34",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl35 = {
                    label = "Muokkain · Ohjain 35",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl36 = {
                    label = "Muokkain · Ohjain 36",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl37 = {
                    label = "Muokkain · Ohjain 37",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl38 = {
                    label = "Muokkain · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl44 = {
                    label = "Muokkain · Ohjain 44",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policeEditorControl73 = {
                    label = "Muokkain · Ohjain 73",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                policePrimaryColor = {
                    description = "Poliisin työryhmän oletusväri.",
                    label = "Pääväri",
                },
                propPlacementConsumeItem = {
                    description = "Poista yksi tavara varastosta, kun esine sijoitetaan.",
                    label = "Kuluta esinetavara",
                },
                propPlacementEnabled = {
                    description = "Salli määritettyjen poliisiesineiden sijoittaminen tavaroista tai ajoneuvoista.",
                    label = "Esineiden sijoittelu",
                },
                propPlacementItemNames = {
                    description = "Yhdistä esinemallit varaston tavaranimiin tavarapohjaista esineiden sijoittelua varten.",
                    label = "Esineiden tavaranimet",
                },
                propPlacementRequireOnDuty = {
                    description = "Vain työvuorossa olevat virkamiehet voivat sijoittaa määritettyjä esineitä.",
                    label = "Esineet vaativat työvuoron",
                },
                propPlacementReturnItem = {
                    description = "Anna kulutettu tavara takaisin, kun sijoitettu esine poistetaan.",
                    label = "Palauta esinetavara",
                },
                propPlacementVehicleAccess = {
                    description = "Salli työajoneuvojen tarjota niille määritetty esinevarustus.",
                    label = "Ajoneuvon esineiden käyttöoikeus",
                },
                radialEnabled = {
                    description = "Ota käyttöön poliisin toimintopyörän toiminnot.",
                    label = "Poliisin toimintopyörä",
                },
                radialHandcuffKeybindCommand = {
                    description = "Käsirautojen pikanäppäimelle rekisteröity komennon nimi.",
                    label = "Käsirautojen komento",
                },
                radialHandcuffKeybindDescription = {
                    description = "Käsirautojen pikanäppäimelle näytettävä kuvaus.",
                    label = "Käsirautojen kuvaus",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Ota käyttöön suora pikanäppäin käsirautojen laittamiseen.",
                    label = "Käsirautojen pikanäppäin",
                },
                radialHandcuffKeybindKey = {
                    description = "Näppäimistön näppäin, jota käytetään suoraan käsirautojen laittamiseen.",
                    label = "Käsirautojen näppäin",
                },
                radialKeybindsEnabled = {
                    description = "Ota käyttöön suorat pikanäppäimet valituille toimintopyörän toiminnoille.",
                    label = "Suorat pikanäppäimet",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Käsirautojen poiston pikanäppäimelle rekisteröity komennon nimi.",
                    label = "Käsirautojen poiston komento",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Käsirautojen poiston pikanäppäimelle näytettävä kuvaus.",
                    label = "Käsirautojen poiston kuvaus",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Ota käyttöön suora pikanäppäin käsirautojen poistamiseen.",
                    label = "Käsirautojen poiston pikanäppäin",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Näppäimistön näppäin, jota käytetään suoraan käsirautojen poistamiseen.",
                    label = "Käsirautojen poiston näppäin",
                },
                socialWorkAssignRange = {
                    description = "Suurin etäisyys sosiaalityötehtävien määräämiseen.",
                    label = "Määräysetäisyys",
                },
                socialWorkDeadlineDefault = {
                    description = "Oletusarvoinen sosiaalityön määräaika minuutteina. Nolla poistaa määräajat käytöstä.",
                    label = "Oletusmääräaika",
                },
                socialWorkDeadlineMax = {
                    description = "Sosiaalityön suurin määräaika minuutteina. Nolla poistaa ylärajan.",
                    label = "Enimmäismääräaika",
                },
                socialWorkDeadlineMin = {
                    description = "Sosiaalityön pienin määräaika minuutteina.",
                    label = "Vähimmäismääräaika",
                },
                socialWorkDefaultTasks = {
                    description = "Oletusarvoinen tehtävämäärä sosiaalityön määräämisen käyttöliittymää avattaessa.",
                    label = "Oletustehtävät",
                },
                socialWorkEnabled = {
                    description = "Ota käyttöön sosiaalityön määräämisen ja tehtävien toiminnot.",
                    label = "Sosiaalityö",
                },
                socialWorkImprisonmentJailId = {
                    description = "Vankilan tunnus, jota käytetään, kun sosiaalityön rikkomukset johtavat vankeuteen.",
                    label = "Varavankilan tunnus",
                },
                socialWorkImprisonmentMonths = {
                    description = "Kuukaudet, jotka määrätään, kun sosiaalityön rikkomukset johtavat vankilaan.",
                    label = "Vankeuskuukaudet",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Virkamiehen nimi, jota käytetään sosiaalityön vankeuden merkinnöissä.",
                    label = "Vankeuden virkamiehen nimi",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Lähetä rikkojat eristykseen, kun vankeus laukeaa.",
                    label = "Käytä eristystä",
                },
                socialWorkInactivityMinutes = {
                    description = "Minuutit ennen kuin sosiaalityön passiivisuusrangaistukset astuvat voimaan.",
                    label = "Passiivisuusminuutit",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Tehtäväsakko, joka annetaan sosiaalityöntekijän pysyessä liian kauan passiivisena.",
                    label = "Passiivisuuden tehtäväsakko",
                },
                socialWorkMaxTasks = {
                    description = "Suurin valittavissa oleva sosiaalityötehtävien määrä.",
                    label = "Enimmäistehtävät",
                },
                socialWorkMinTasks = {
                    description = "Pienin valittavissa oleva sosiaalityötehtävien määrä.",
                    label = "Vähimmäistehtävät",
                },
                speedCamBillingEnabled = {
                    description = "Anna automaattinen lasku, kun nopeuskamera havaitsee vastaavan rikkomuksen. Vaatii, että yleinen Laskutus-ominaisuus on käytössä.",
                    label = "Automaattiset sakot",
                },
                speedCamBillingExcludedJobs = {
                    description = "Työt, jotka eivät koskaan saa automaattisia nopeuskameralaskuja.",
                    itemLabel = "Työ",
                    label = "Poissuljetut työt",
                },
                speedCamBillingExcludedModels = {
                    description = "Ajoneuvojen spawn-nimet, jotka eivät koskaan saa automaattisia nopeuskameralaskuja.",
                    itemLabel = "Malli",
                    label = "Poissuljetut ajoneuvomallit",
                },
                speedCamBillingRules = {
                    description = "Nopeuskameroiden käyttämät sakkosäännöt. Tarkimmin sopiva ylitysalue laskutetaan ensin; jos yksikään sääntö ei täsmää, käytetään SpeedViolation-rikkomuksia varajärjestelmänä.",
                    label = "Sakkosäännöt",
                },
                speedCamCameraEaseMs = {
                    description = "Kuinka kauan näkymän siirtyminen nopeuskameran kulmaan kestää. Pienempi = lyhyempi heilahdus; liian pieni voi aiheuttaa kuvan väärän kohdistuksen.",
                    label = "Kameran siirtymä (ms)",
                },
                speedCamCameraFov = {
                    description = "Nopeuskameran kuvauksissa käytettävä kuvakulma.",
                    label = "Kameran kuvakulma",
                },
                speedCamCheckIntervalMs = {
                    description = "Millisekunnit nopeuskameran skannausten välillä.",
                    label = "Tarkistusväli",
                },
                speedCamCooldownMs = {
                    description = "Millisekunnit ennen kuin sama nopeuskamera voi laueta uudelleen.",
                    label = "Laukaisun jäähdytys",
                },
                speedCamDamageCooldownMs = {
                    description = "Millisekunnit ennen kuin nopeuskameran vahinkoa voidaan aiheuttaa uudelleen.",
                    label = "Vahingon jäähdytys",
                },
                speedCamDamagePerHit = {
                    description = "Nopeuskameroihin kohdistuva kestävyysvahinko per osuma.",
                    label = "Vahinko per osuma",
                },
                speedCamDamagedModelThreshold = {
                    description = "Enimmäiskestävyyden prosenttiosuus, jonka kohdalla tai alapuolella näytetään vaurioitunut malli. Esimerkki: arvo 50 ja enimmäiskestävyys 200 vaihtavat mallin kestävyyden ollessa 100.",
                    label = "Vaurioituneen mallin raja (%)",
                },
                speedCamDefaultLimit = {
                    description = "Nopeuskameran oletusnopeusraja.",
                    label = "Oletusnopeusraja",
                },
                speedCamDefaultName = {
                    description = "Ehdotettu näyttönimi kameraa sijoitettaessa. Nimen voi kääntää muuttamatta inventaarion tavaraa tai objektimallia.",
                    label = "Oletusnimi",
                },
                speedCamDefaultTolerance = {
                    description = "Nopeuskameran oletustoleranssi.",
                    label = "Oletustoleranssi",
                },
                speedCamDisassembleDistance = {
                    description = "Etäisyys, jota käytetään nopeuskameroiden purkamiseen.",
                    label = "Purkuetäisyys",
                },
                speedCamEnabled = {
                    description = "Ota käyttöön kannettavat nopeuskamerat.",
                    label = "Nopeuskamerat",
                },
                speedCamFlashColor = {
                    description = "Nopeuskameroiden käyttämä RGBA-salamaväri.",
                    label = "Salaman väri",
                },
                speedCamFlashDurationMs = {
                    description = "Punaisen nopeuskameran salaman häivytysaika. Älä aseta liian pieneksi, tai kameran heilahdus tulee näkyväksi.",
                    label = "Salaman kesto (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Etäisyys, jolla nopeuskameran kunto näytetään.",
                    label = "Kunnon näyttöetäisyys",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Millisekunnit, joina nopeuskameran kunto pysyy näkyvissä.",
                    label = "Kunnon näyttöaika",
                },
                speedCamHealthTextOffset = {
                    description = "Nopeuskameran kuntotekstissä käytettävä pystysuuntainen siirtymä.",
                    label = "Kuntotekstin siirtymä",
                },
                speedCamItem = {
                    description = "Tavaran tarkka sisäinen nimi inventaariossa, esim. speedcam. Käytä tavaran avainta, älä näyttönimeä; työn kaupan on annettava sama tavara.",
                    label = "Kameratavaran nimi",
                },
                speedCamMaintenanceThreshold = {
                    description = "Kestävyysraja, jonka jälkeen nopeuskameran huoltoa suositellaan.",
                    label = "Huoltoraja",
                },
                speedCamMaxDurability = {
                    description = "Asennettujen nopeuskameroiden suurin kestävyys.",
                    label = "Suurin kestävyys",
                },
                speedCamMaxLimit = {
                    description = "Suurin määritettävissä oleva nopeuskameran raja.",
                    label = "Suurin nopeusraja",
                },
                speedCamMaxTolerance = {
                    description = "Suurin määritettävissä oleva nopeuskameran toleranssi.",
                    label = "Suurin toleranssi",
                },
                speedCamPhotoLocale = {
                    description = "Valinnainen kieliasetus, jota käytetään nopeuskamerakuvien aikaleimassa. Jätä tyhjäksi käyttääksesi kuvatun pelaajan paikallista kieliasetusta.",
                    label = "Kuvan kieliasetus",
                },
                speedCamPhotoTimeZone = {
                    description = "Valinnainen aikavyöhyke, jota käytetään nopeuskamerakuvien aikaleimassa. Jätä tyhjäksi käyttääksesi kuvatun pelaajan paikallista aikavyöhykettä.",
                    label = "Kuvan aikavyöhyke",
                },
                speedCamPoliceNotification = {
                    description = "Lähetä hälytysilmoitus, kun nopeuskamera havaitsee rikkomuksia.",
                    label = "Nopeuskameran poliisihälytys",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Käsittele nopeuskameran hälytyskohde työryhmänä.",
                    label = "Hälytyksen kohde on ryhmä",
                },
                speedCamPoliceNotificationJob = {
                    description = "Työ- tai ryhmäavain, jota käytetään nopeuskameran hälytysilmoituksiin.",
                    label = "Hälytyksen kohde",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Ilmoita vain nopeuskameran hälytyskohteille, jotka ovat työvuorossa.",
                    label = "Hälytys vaatii työvuoron",
                },
                speedCamPoliceNotificationType = {
                    description = "Hälytyksen vakavuus/tyyppi, jota käytetään nopeuskameravaroituksissa.",
                    label = "Hälytyksen tyyppi",
                },
                speedCamPropModel = {
                    description = "Ehjän kameran objektimallin luontinimi, esim. sky_speedcam. Esiasetus valitsee myös vaurioituneen ja tuhoutuneen mallin. Omien mallien on oltava käytettävissä pelissä.",
                    label = "Nopeuskameran esinemalli",
                    custom = "Mukautettu malli",
                    choose = "Valitse malli",
                    preview = "3D-esikatselu",
                    customPlaceholder = "Propin spawn-nimi",
                    previewDescription = "Näytä valittu prop pelissä. Esikatselu ei tallenna muutoksia.",
                    invalidModel = "Anna ensin kelvollinen propin nimi.",
                    modelMissing = "Tämä prop-malli ei ole käytettävissä pelissä.",
                    previewFailed = "Mallin esikatselua ei voitu avata.",
                    intact = "Ehjä prop-malli",
                    previewRequiresGame = "Avaa /jobconfig FiveM:ssä nähdäksesi propin livenä.",
                    previewHelp = "Nuolet: siirrä; PageUp/PageDown: korkeus; rulla: kierrä; Enter: sulje; Backspace: peruuta.",
                    options = {
                        sky_speedcam = "Vakiotutka",
                        sky_germ_speedcam = "Saksalainen tutka",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Vaurioituneen kameran objektimallin luontinimi, esim. sky_speedcam2. Valitse ehjää mallia vastaava versio.",
                    label = "Vaurioituneen esineen malli",
                },
                speedCamPropModelDestroyed = {
                    description = "Kameran kestävyyden laskiessa nollaan näytettävän mallin luontinimi, esim. sky_speedcam1. Valitse ehjää mallia vastaava versio.",
                    label = "Tuhoutuneen esineen malli",
                },
                speedCamRepairAnimDict = {
                    description = "Nopeuskameroiden korjaamisen aikana käytettävä animaatiokirjasto.",
                    label = "Korjausanimaation kirjasto",
                },
                speedCamRepairAnimFlag = {
                    description = "Nopeuskameroiden korjaamisen aikana käytettävä animaation lippu.",
                    label = "Korjausanimaation lippu",
                },
                speedCamRepairAnimName = {
                    description = "Nopeuskameroiden korjaamisen aikana käytettävä animaation nimi.",
                    label = "Korjausanimaation nimi",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Millisekunnit ennen kuin nopeuskameran korjaus voidaan perua.",
                    label = "Korjauksen perumisviive",
                },
                speedCamRepairDistance = {
                    description = "Etäisyys, jota käytetään nopeuskameroiden korjaamiseen.",
                    label = "Korjausetäisyys",
                },
                speedCamRepairItem = {
                    description = "Korjaustavaran tarkka sisäinen nimi, esim. fixtool. Käytä tavaran avainta, älä näyttönimeä.",
                    label = "Korjaustavaran nimi",
                },
                speedCamRepairPerTick = {
                    description = "Kestävyys, joka palautuu per nopeuskameran korjausjakso.",
                    label = "Korjaus per jakso",
                },
                speedCamRepairTickMs = {
                    description = "Millisekunnit nopeuskameran korjausjaksojen välillä.",
                    label = "Korjauksen jakso",
                },
                speedCamStreamDistance = {
                    description = "Etäisyys pelaajasta metreinä, jonka sisällä kameraobjektit ladataan. Kauempana objektit poistetaan näkyvistä; tallennetut kamerat pysyvät sijoitettuina.",
                    label = "Latausetäisyys",
                },
                speedCamTriggerRadius = {
                    description = "Ylinopeutta ajavien ajoneuvojen tunnistussäde kameran ympärillä metreinä.",
                    label = "Laukaisusäde",
                },
                speedCamUseMph = {
                    description = "Näytä ja käsittele nopeuskameran rajat MPH-yksikössä.",
                    label = "Käytä MPH-yksikköä",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Aseet, joilla saa vahingoittaa nopeuskameroita, kun rajoitus on käytössä.",
                    itemLabel = "Ase",
                    label = "Sallitut aseet",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Vain listatut aseet voivat vahingoittaa nopeuskameroita, kun tämä on käytössä.",
                    label = "Rajoitus käytössä",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Etäisyys metreinä ennen nopeuskameravaroitusten poistamista.",
                    label = "Poistoetäisyys",
                },
                speedCameraAppDefaultApp = {
                    description = "Näytä nopeuskamerasovellus tabletin oletussovelluksena.",
                    label = "Oletussovellus",
                },
                speedCameraAppDescription = {
                    description = "Nopeuskameran tablettisovelluksessa näytettävä kuvaus.",
                    label = "Kuvaus",
                },
                speedCameraAppDeveloper = {
                    description = "Nopeuskameran tablettisovelluksessa näytettävä kehittäjän nimike.",
                    label = "Kehittäjä",
                },
                speedCameraAppEnabled = {
                    description = "Ota käyttöön poliisin tabletin nopeuskamerasovellus.",
                    label = "Nopeuskameran tablettisovellus",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Nopeuskamerasovelluksessa näytettävä otsikon yläteksti.",
                    label = "Otsikon yläteksti",
                },
                speedCameraAppHeaderTitle = {
                    description = "Nopeuskamerasovelluksessa näytettävä otsikkoteksti.",
                    label = "Otsikon teksti",
                },
                speedCameraAppIcon = {
                    description = "Nopeuskameran tablettisovelluksessa käytettävä kuvakkeen polku.",
                    label = "Kuvakkeen polku",
                },
                speedCameraAppIdentifier = {
                    description = "Nopeuskameran tablettisovelluksen sisäinen tunniste.",
                    label = "Tunniste",
                },
                speedCameraAppInFrontDot = {
                    description = "Pistetuloraja, jota käytetään sen määrittämiseen, onko nopeuskamera pelaajan edessä.",
                    label = "Edessäolon pistetuloraja",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Pienin ajoneuvon nopeus ennen kuin varoitukset näytetään.",
                    label = "Vähimmäisnopeus",
                },
                speedCameraAppName = {
                    description = "Nopeuskameran tablettisovelluksen näyttönimi.",
                    label = "Sovelluksen nimi",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Etäisyys metreinä ennen ilmoitusta lähellä olevista nopeuskameroista.",
                    label = "Ilmoitusetäisyys",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Varoita nopeuskameroista vain, kun pelaaja on ajoneuvossa.",
                    label = "Vain ajoneuvossa",
                },
                speedCameraAppOverlayBackground = {
                    description = "Rekisterikilven peittokuvassa käytettävä taustaväri.",
                    label = "Peittokuvan tausta",
                },
                speedCameraAppOverlayBorder = {
                    description = "Rekisterikilven peittokuvassa käytettävä reunuksen väri.",
                    label = "Peittokuvan reunus",
                },
                speedCameraAppOverlayColor = {
                    description = "Rekisterikilven peittokuvassa käytettävä tekstiväri.",
                    label = "Peittokuvan väri",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Ota käyttöön rekisterikilven peittokuvat kuvatuissa nopeuskamerakuvissa.",
                    label = "Peittokuva käytössä",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Rekisterikilven peittokuvassa käytettävä fontin skaala.",
                    label = "Peittokuvan fontin skaala",
                },
                speedCameraAppOverlayX = {
                    description = "Normalisoitu peittokuvan X-sijainti vasemmalta oikealle.",
                    label = "Peittokuva X",
                },
                speedCameraAppOverlayY = {
                    description = "Normalisoitu peittokuvan Y-sijainti ylhäältä alas.",
                    label = "Peittokuva Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Varoita vain nopeuskameroista, jotka ovat pelaajan edessä.",
                    label = "Vaadi edessä oleminen",
                },
                speedCameraAppRoute = {
                    description = "Reitittimen polku, jonka nopeuskameran tablettisovellus avaa.",
                    label = "Reitti",
                },
                speedCameraAppSize = {
                    description = "Nopeuskameran tablettisovelluksen ilmoitettu tallennuskoko.",
                    label = "Sovelluksen koko",
                },
                speedCameraAppSoundCoord = {
                    description = "Toista nopeuskamerasovelluksen varoitusäänet maailman koordinaateissa.",
                    label = "Koordinaattiääni",
                },
                speedCameraAppSoundEnabled = {
                    description = "Ota käyttöön varoitusäänet nopeuskamerasovellukselle.",
                    label = "Ääni käytössä",
                },
                speedCameraAppSoundFrontend = {
                    description = "Toista nopeuskamerasovelluksen varoitusäänet käyttöliittymän äänikanavalla.",
                    label = "Käyttöliittymän ääni",
                },
                speedCameraAppSoundLayers = {
                    description = "Nopeuskamerasovelluksen toistamien kerrostettujen varoitusäänien määrä.",
                    label = "Äänikerrokset",
                },
                speedCameraAppSoundName = {
                    description = "Nopeuskamerasovelluksen varoituksissa käytettävän äänen nimi.",
                    label = "Äänen nimi",
                },
                speedCameraAppSoundRange = {
                    description = "Nopeuskamerasovelluksen varoitusäänissä käytettävä kantama.",
                    label = "Äänen kantama",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Kuinka monta kertaa nopeuskameran varoitusääni toistetaan.",
                    label = "Toistokerrat",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Millisekunnit nopeuskameran varoitusäänen toistojen välillä.",
                    label = "Toiston viive",
                },
                speedCameraAppSoundSet = {
                    description = "Nopeuskamerasovelluksen varoituksissa käytettävä äänisarja.",
                    label = "Äänisarja",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Tili, jota käytetään tabletin nopeuskamerasovelluksen tilausmaksuihin.",
                    label = "Tili",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Ota käyttöön maksulliset tilaukset tabletin nopeuskamerasovellukselle.",
                    label = "Tilaus käytössä",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Päivät tabletin nopeuskamerasovelluksen tilauksen uusimisten välillä.",
                    label = "Väli päivissä",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Tabletin nopeuskamerasovelluksen tilauksesta veloitettava hinta.",
                    label = "Tilauksen hinta",
                },
                speedCameraAppThemeAccent = {
                    description = "Nopeuskamerasovelluksen käyttämä korostusväri.",
                    label = "Korostusväri",
                },
                speedCameraAppThemeBackground = {
                    description = "Nopeuskamerasovelluksen käyttämä lineaarinen liukuvärjätty tausta.",
                    label = "Tausta",
                },
                speedCameraAppThemeBorder = {
                    description = "Nopeuskamerasovelluksen käyttämä reunuksen väri.",
                    label = "Reunus",
                },
                speedCameraAppThemeButtonText = {
                    description = "Nopeuskamerasovelluksen käyttämä painikkeen tekstiväri.",
                    label = "Painikkeen teksti",
                },
                speedCameraAppThemeDanger = {
                    description = "Nopeuskamerasovelluksen käyttämä vaaraväri.",
                    label = "Vaara",
                },
                speedCameraAppThemeGhost = {
                    description = "Nopeuskamerasovelluksen käyttämä haamupainikkeen väri.",
                    label = "Haamupainike",
                },
                speedCameraAppThemeGhostText = {
                    description = "Nopeuskamerasovelluksen käyttämä haamupainikkeen tekstiväri.",
                    label = "Haamutekstiväri",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Nopeuskamerasovelluksen käyttämä pehmeä liukuvärjäysväri.",
                    label = "Pehmeä liukuväri",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Nopeuskamerasovelluksen käyttämä passiivisen reunuksen väri.",
                    label = "Passiivinen reunus",
                },
                speedCameraAppThemeModal = {
                    description = "Nopeuskamerasovelluksen käyttämä modaali-ikkunan taustaväri.",
                    label = "Modaali-ikkuna",
                },
                speedCameraAppThemeMutedText = {
                    description = "Nopeuskamerasovelluksen käyttämä vaimennettu tekstiväri.",
                    label = "Vaimennettu teksti",
                },
                speedCameraAppThemeOverlay = {
                    description = "Nopeuskamerasovelluksen käyttämä peittokuvan väri.",
                    label = "Peittokuva",
                },
                speedCameraAppThemePillText = {
                    description = "Nopeuskamerasovelluksen käyttämä pilleritekstin väri.",
                    label = "Pilleritekstin väri",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Nopeuskamerasovelluksen käyttämä ensisijaisen liukuvärjäyksen alkuväri.",
                    label = "Ensisijaisen liu'un alku",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Nopeuskamerasovelluksen käyttämä ensisijaisen liukuvärjäyksen loppuväri.",
                    label = "Ensisijaisen liu'un loppu",
                },
                speedCameraAppThemeShadow = {
                    description = "Nopeuskamerasovelluksen käyttämä varjon väri.",
                    label = "Varjo",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Nopeuskamerasovelluksen käyttämä valokeilan korostusväri.",
                    label = "Valokeila",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Nopeuskamerasovelluksen käyttämä hienovarainen tekstiväri.",
                    label = "Hienovarainen teksti",
                },
                speedCameraAppThemeSuccess = {
                    description = "Nopeuskamerasovelluksen käyttämä onnistumisen väri.",
                    label = "Onnistuminen",
                },
                speedCameraAppThemeSurface = {
                    description = "Nopeuskamerasovelluksen käyttämä pintaväri.",
                    label = "Pinta",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Nopeuskamerasovelluksen käyttämä pehmeä pintaväri.",
                    label = "Pehmeä pinta",
                },
                speedCameraAppThemeText = {
                    description = "Nopeuskamerasovelluksen käyttämä ensisijainen tekstiväri.",
                    label = "Teksti",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-korostusväri.",
                    label = "Korostus RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Nopeuskameran varoituskäyttöliittymän taustassa käytettävä RGBA-väri.",
                    label = "Tausta RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-kuvakeväri.",
                    label = "Kuvake RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-kuvaketekstin väri.",
                    label = "Kuvakkeen teksti RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Sekunnit, joina varoituskäyttöliittymä pysyy näkyvissä.",
                    label = "Varoituksen näyttöaika",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-alatekstin väri.",
                    label = "Alateksti RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-tekstiväri.",
                    label = "Teksti RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Nopeuskameran varoituskäyttöliittymän käyttämä RGBA-otsikkoväri.",
                    label = "Otsikko RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Millisekunnit piikkimaton läheisyystarkistusten välillä.",
                    label = "Tarkistusväli",
                },
                spikeStripsEnabled = {
                    description = "Ota käyttöön asetetut piikkimatot.",
                    label = "Piikkimatot",
                },
                spikeStripsModels = {
                    description = "Esinemallit, joita käsitellään aktiivisina piikkimattoina.",
                    itemLabel = "Malli",
                    label = "Mallit",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Millisekunnit ennen kuin piikkimaton skannaus yritetään uudelleen ilman osumaa.",
                    label = "Uudelleenyritysväli",
                },
                spikeStripsScanDistance = {
                    description = "Etäisyys, jota käytetään lähellä olevien piikkimattojen skannaamiseen.",
                    label = "Skannausetäisyys",
                },
                spikeStripsTriggerDistance = {
                    description = "Etäisyys, jolla piikkimatto puhkaisee renkaat.",
                    label = "Laukaisuetäisyys",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Kategorian nimike, jota käytetään aseman luojan karttamerkeissä.",
                    label = "Aseman karttamerkin kategoria",
                },
                stationCreatorBlipColor = {
                    description = "Poliisiasemilla käytettävä karttamerkin väri.",
                    label = "Aseman karttamerkin väri",
                },
                stationCreatorBlipScale = {
                    description = "Poliisiaseman karttamerkeissä käytettävä koko.",
                    label = "Aseman karttamerkin koko",
                },
                stationCreatorBlipShortRange = {
                    description = "Näytä aseman karttamerkit vain lyhyellä etäisyydellä.",
                    label = "Aseman karttamerkin lyhyt kantama",
                },
                stationCreatorBlipSprite = {
                    description = "Poliisiasemilla käytettävä karttamerkin kuvake (sprite).",
                    label = "Aseman karttamerkin kuvake",
                },
                stationCreatorBlipUseStationName = {
                    description = "Käytä määritettyä aseman nimeä karttamerkin nimikkeenä.",
                    label = "Käytä aseman nimeä",
                },
                tabletAutoFillCitizens = {
                    description = "Esitäytä kansalaisrekisteri frameworkin tietokannasta.",
                    label = "Täytä kansalaiset automaattisesti",
                },
                tabletAutoFillVehicles = {
                    description = "Esitäytä ajoneuvorekisteri frameworkin tietokannasta.",
                    label = "Täytä ajoneuvot automaattisesti",
                },
                tabletBolos = {
                    description = "Näytä BOLO-sovellus.",
                    label = "BOLOt",
                },
                tabletCases = {
                    description = "Näytä tapaukset-sovellus.",
                    label = "Tapaukset",
                },
                tabletCitizens = {
                    description = "Näytä kansalaisrekisterin sovellus.",
                    label = "Kansalaiset",
                },
                tabletConfiscations = {
                    description = "Näytä henkilöntarkastuksissa takavarikoitujen esineiden rekisteri.",
                    label = "Takavarikot",
                },
                tabletOffences = {
                    description = "Näytä rikokset-sovellus.",
                    label = "Rikokset",
                },
                tabletPrison = {
                    description = "Näytä vankila-sovellus.",
                    label = "Vankila",
                },
                tabletReportEnforcement = {
                    description = "Salli rikosten liittäminen sekä sakkojen tai vankeustuomioiden antaminen tallennetuista raporteista.",
                    label = "Raporttien täytäntöönpano",
                },
                tabletReports = {
                    description = "Näytä raportit-sovellus.",
                    label = "Raportit",
                },
                tabletSocialWork = {
                    description = "Näytä sosiaalityön sovellus.",
                    label = "Sosiaalityö",
                },
                tabletVehicles = {
                    description = "Näytä ajoneuvorekisterin sovellus.",
                    label = "Ajoneuvot",
                },
                tabletWarrants = {
                    description = "Näytä vangitsemismääräykset-sovellus.",
                    label = "Vangitsemismääräykset",
                },
                tabletWeapons = {
                    description = "Näytä aserekisterin sovellus.",
                    label = "Aseet",
                },
                tackleCuffKey = {
                    label = "Kahlitse taklattu henkilö",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                tackleKey = {
                    label = "Taklaus",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                tackleReleaseKey = {
                    label = "Vapauta taklattu henkilö",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Millisekunnit ennen kuin uusi radarihälytys voidaan antaa.",
                    label = "Hälytyksen jäähdytys",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Ajoneuvoluokat, jotka saavat käyttää radaria.",
                    label = "Sallitut ajoneuvoluokat",
                },
                vehicleRadarAutoFastLock = {
                    description = "Merkitse automaattisesti hyvin nopeat kohteet radarissa.",
                    label = "Automaattinen pikalukitus",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Nopeusraja, jota käytetään automaattisessa pikalukituksessa.",
                    label = "Pikalukituksen raja",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Näppäinsidonta, jota käytetään radarin nopeusrajan laskemiseen.",
                    label = "Rajan laskunäppäin",
                },
                vehicleRadarDefaultLimit = {
                    description = "Ajoneuvon radarin käyttämä oletusnopeusraja.",
                    label = "Radarin oletusraja",
                },
                vehicleRadarEnabled = {
                    description = "Ota käyttöön partioajoneuvon radar.",
                    label = "Ajoneuvon radar",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Näppäinsidonta, jota käytetään radarin nopeusrajan nostamiseen.",
                    label = "Rajan nostonäppäin",
                },
                vehicleRadarLimitStep = {
                    description = "Määrä, joka muuttuu jokaisella radarin rajan säädöllä.",
                    label = "Rajan askel",
                },
                vehicleRadarLockFrontKey = {
                    description = "Näppäinsidonta, jota käytetään etu-radarin kohteen lukitsemiseen.",
                    label = "Etulukituksen näppäin",
                },
                vehicleRadarLockRearKey = {
                    description = "Näppäinsidonta, jota käytetään taka-radarin kohteen lukitsemiseen.",
                    label = "Takalukituksen näppäin",
                },
                vehicleRadarMaxLimit = {
                    description = "Ajoneuvon radarissa sallittu suurin nopeusraja.",
                    label = "Radarin enimmäisraja",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Suurin sallittu kallistus radarin kohdistuksessa.",
                    label = "Suurin kallistuskulma",
                },
                vehicleRadarMinLimit = {
                    description = "Ajoneuvon radarissa sallittu pienin nopeusraja.",
                    label = "Radarin vähimmäisraja",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Pienin nopeus, ennen kuin radar pitää kohdetta kelvollisena.",
                    label = "Kohteen vähimmäisnopeus",
                },
                vehicleRadarModeFrontKey = {
                    description = "Näppäinsidonta, jota käytetään etu-radarin tilan vaihtamiseen.",
                    label = "Etutilan näppäin",
                },
                vehicleRadarModeRearKey = {
                    description = "Näppäinsidonta, jota käytetään taka-radarin tilan vaihtamiseen.",
                    label = "Takatilan näppäin",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Millisekunnit radarin skannausten välillä, kun partioajoneuvo liikkuu.",
                    label = "Liikkeessä olevan skannauksen väli",
                },
                vehicleRadarPassengerControl = {
                    description = "Salli matkustajien hallita ajoneuvon radaria.",
                    label = "Matkustajan hallinta",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Salli matkustajien nähdä peilattua radardataa.",
                    label = "Matkustajan peilinäkymä",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Millisekunnit radarin synkronointipäivitysten välillä matkustajille.",
                    label = "Matkustajan synkronointiväli",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Projektioraja, jota käytetään radarin kohteiden arvioinnissa.",
                    label = "Projektioraja",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Vaadi esteetön näköyhteys ennen kuin radar lukittuu kohteeseen.",
                    label = "Vaadi näköyhteys",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen ajoneuvon radarin käyttöä.",
                    label = "Radar vaatii työvuoron",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Millisekunnit paikallaan olevan radarin skannausten välillä.",
                    label = "Skannausväli",
                },
                vehicleRadarScanRadius = {
                    description = "Ajoneuvon radarin skannaussäde.",
                    label = "Skannaussäde",
                },
                vehicleRadarToggleKey = {
                    description = "Näppäinsidonta, jota käytetään ajoneuvon radarin kytkemiseen.",
                    label = "Kytkennän näppäin",
                },
                vehicleRadarUseMph = {
                    description = "Näytä radarin nopeusarvot MPH-yksikössä.",
                    label = "Radar käyttää MPH-yksikköä",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Millisekunnit lähellä olevien ajoneuvojen poolin päivitysten välillä.",
                    label = "Ajoneuvopoolin päivitys",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Näppäinsidonta, jota käytetään etu-radarin XMIT/HOLD-toimintoon.",
                    label = "Etu-XMIT-näppäin",
                },
                vehicleRadarXmitRearKey = {
                    description = "Näppäinsidonta, jota käytetään taka-radarin XMIT/HOLD-toimintoon.",
                    label = "Taka-XMIT-näppäin",
                },
                wheelClampConsumeItem = {
                    description = "Poista pyöränlukon tavara kiinnittämisen jälkeen.",
                    label = "Kuluta lukon tavara",
                },
                wheelClampEnabled = {
                    description = "Ota käyttöön pyöränlukon toiminto.",
                    label = "Pyöränlukko",
                },
                wheelClampItem = {
                    description = "Pyöränlukon kiinnittämiseen käytettävä varaston tavara.",
                    label = "Lukon tavara",
                },
                wheelClampPropModel = {
                    description = "Kiinnitetyssä pyöränlukossa käytettävä esinemalli.",
                    label = "Lukon esinemalli",
                },
                wheelClampRequireItem = {
                    description = "Vaadi määritetty pyöränlukon tavara. Pidä käytössä, kun lukon käyttötapa on asetettu Varastoon tai Molemmat.",
                    label = "Lukko vaatii tavaran",
                },
                wheelClampRequireOnDuty = {
                    description = "Vaadi työvuorossa oleminen ennen pyöränlukkojen kiinnittämistä.",
                    label = "Lukko vaatii työvuoron",
                },
                wheelClampTyreDistance = {
                    description = "Suurin etäisyys renkaaseen lukkoa kiinnitettäessä tai hitsattaessa.",
                    label = "Renkaan etäisyys",
                },
                wheelClampUseItem = {
                    description = "Käytä toimintopyörää, varastoa tai molempia pyöränlukon kiinnittämiseen. Varasto tai Molemmat tulisi yhdistää asetukseen Lukko vaatii tavaran.",
                    label = "Lukon käyttötapa",
                    options = {
                        both = "Molemmat",
                        inventory = "Varasto",
                        radial = "Toimintopyörä",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Suurin etäisyys kohdeajoneuvoon lukkoa kiinnitettäessä.",
                    label = "Ajoneuvon etäisyys",
                },
                wheelClampWeldBurstTyre = {
                    description = "Puhkaise rengas, kun lukko on hitsattu irti.",
                    label = "Puhkaise rengas",
                },
                wheelClampWeldDurationMs = {
                    description = "Millisekunnit, jotka vaaditaan lukon poistamiseen hitsaamalla.",
                    label = "Hitsauksen kesto",
                },
                wheelClampWeldEnabled = {
                    description = "Salli pyöränlukkojen poistaminen hitsauslaitteella.",
                    label = "Lukon hitsaus",
                },
                wheelClampWeldItem = {
                    description = "Lukon hitsaukseen vaadittava varaston tavara.",
                    label = "Hitsauslaitteen tavara",
                },
                wheelClampWeldMinigame = {
                    description = "Vaadi lukon hitsauksen minipeli ennen poiston valmistumista.",
                    label = "Hitsauksen minipeli",
                },
                ziptiesConsumeItem = {
                    description = "Poista siimapantatavara, kun se laitetaan.",
                    label = "Kuluta siimapanta",
                },
                ziptiesCutterConsumeItem = {
                    description = "Poista leikkurin tavara siimapannan katkaisun jälkeen.",
                    label = "Kuluta leikkurin tavara",
                },
                ziptiesCutterEnabled = {
                    description = "Salli lankaleikkurin käyttö siimapantojen katkaisemiseen.",
                    label = "Siimapantojen leikkuri",
                },
                ziptiesCutterItem = {
                    description = "Siimapantojen katkaisemiseen käytettävä varaston tavara.",
                    label = "Leikkurin tavara",
                },
                ziptiesEnabled = {
                    description = "Ota käyttöön siimapantojen toiminnot.",
                    label = "Siimapannat",
                },
                ziptiesItem = {
                    description = "Siimapantojen toiminnoissa käytettävä varaston tavara.",
                    label = "Siimapannan tavara",
                },
                ziptiesRequireHandsUp = {
                    description = "Vaadi kädet ylhäällä -tila ennen siimapannan laittamista.",
                    label = "Siimapanta vaatii kädet ylös",
                },
                ziptiesRequireItem = {
                    description = "Vaadi määritetty siimapantatavara.",
                    label = "Siimapannat vaativat tavaran",
                },
                ziptiesReturnOnRemove = {
                    description = "Palauta siimapantatavara, kun siimapanta poistetaan.",
                    label = "Palauta siimapanta",
                },
                evidenceGsrDurationSeconds = {
                    description = "Sekunnin ruutijäämiä jää pelaajan käsiin.",
                    label = "GSR kesto",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Estä GSR:n käyttö, kun ampuja käyttää käsineitä.",
                    label = "Käsineet suojaavat käsiä",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Aseet, joissa ei ole ruutijäämiä.",
                    label = "Aseet huomioimatta",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisekunteja veden ja veden puhdistuksen välillä, kun taas GSR on aktiivinen.",
                    label = "Pesun tarkistusväli",
                },
                evidenceGsrWashInRain = {
                    description = "Anna sateen poistaa ruutijäämiä.",
                    label = "Sateessa peseytyminen",
                },
                evidenceGsrWashInWater = {
                    description = "Anna veden poistaa ruutijäämiä.",
                    label = "Huuhtele vedessä",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam näyttää valelevyn",
                    description = "Näyttää valelevyn helikopterin kamerassa.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Normaalit työkalut näyttävät valelevyn",
                    description = "Näyttää valelevyn poliisin vakiotyökaluissa.",
                },
                fakePlateRadarDisplay = {
                    label = "Tutka näyttää valelevyn",
                    description = "Näyttää väärennetyn levyn tutkassa.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Anna poliisin järjestelmien lukea jaettua väärennettyä levylaukkua.",
                    label = "Tunnista väärennetyt levyt",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Mechanicjobin julkaiseman ajoneuvon tilapussiavaimen.",
                    label = "Tilapussin avain",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam näyttää valelevyn",
                    description = "Näyttää valelevyn kiinteissä tutkaraporteissa.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Vapaaehtoinen ammatti / luokan sallijaluettelo. Jätä tyhjäksi sallittujen ammattien kaikki arvosanat.",
                    label = "VIN arvosanat",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN ammattia",
                    description = "Ammatit saavat käyttää VIN-varmennusta.",
                },
                fakePlateVinAudit = {
                    label = "Tarkastus VIN tarkastusta",
                    description = "Säästää VIN tarkastusta tarkastuslokiin.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN tarkastus sallittu",
                    description = "Mahdollistaa ajoneuvon VIN varmistuskäskyn.",
                },
                fakePlateVinCommand = {
                    label = "VIN komento",
                    description = "Komento vahvisti auton VIN:n.",
                },
                fakePlateVinCooldown = {
                    label = "VIN jäähdyttäminen",
                    description = "Viivästys kahden VIN tarkastuksen välillä.",
                },
                fakePlateVinDistance = {
                    label = "VIN max etäisyys",
                    description = "Virkailijan ja ajoneuvon välinen enimmäisetäisyys sen VIN:n tarkistamiseksi.",
                },
                fakePlateVinIndicator = {
                    label = "Näytä väärä osoitin",
                    description = "Näyttää ilmaisimen, kun tarkastus havaitsee valelevyn.",
                },
                fakePlateVinRequireDuty = {
                    label = "Vaadi tulli",
                    description = "Upseerin on oltava virantoimituksessa VIN:n tarkistamiseksi.",
                },
                fakePlateVinRequireScanner = {
                    label = "Vaadi skannerikohde",
                    description = "Vaatii määritettyä skanneriobjektia VIN:n tarkistamiseksi.",
                },
                fakePlateVinScannerItem = {
                    label = "Scanner-kohde",
                    description = "Inventaario, joka vaaditaan VIN:n tarkistamiseksi.",
                },
                jailRemoveJobOnJail = {
                    description = "Vanki joutuu työttömäksi, kun hänet vangitaan.",
                    label = "Poista ammatti vankilassa",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Palauta vangin alkuperäinen ammatti vapautumisen jälkeen.",
                    label = "Palauta alkuperäinen ammatti",
                },
                primaryColor = {
                    description = "Poliisin työryhmän oletusväri.",
                    label = "Pääväri",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Anna arvioijien laskuttaa rekisteröityä omistajaa silloinkin, kun kiinniotettu levy on merkitty väärennetyksi tai kloonatuksi.",
                    label = "Salli epäiltyjen väärennettyjen rekisterikilpien käyttö",
                },
                speedCamAdvancedPageSize = {
                    description = "Maksimikaappaukset palautettiin per tablettisivu.",
                    label = "Kertaussivun koko",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Ajoneuvon sivut, joiden kuvia voidaan käyttää kilpien tunnistamiseen. Käytä etu- ja/tai takaosaa.",
                    itemLabel = "Sivu",
                    label = "Tunnustetut puolet",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Salli hyväksyntä vasta sen jälkeen, kun nopeuskamerakuva on lähetetty.",
                    label = "Vaadi kuvatodisteita",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu-lupa vaaditaan kaappausten hyväksymiseen tai hylkäämiseen. 18 on Manage Billing.",
                    label = "Uudelleentarkastelulupa ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Pidä tallenteet, joiden rekisterikilpiä ei ole rekisteröityjen ajoneuvojen tietokannassa.",
                    label = "Rekisteröimättömien ajoneuvojen säilyttäminen",
                },
                tabletSpeedcamReviews = {
                    description = "Näytä kehittyneen nopeuskameran tarkistussovellus, kun kehittynyt tila on käytössä.",
                    label = "Nopeuskameran arvostelut",
                },
                tackleCommand = {
                    description = "Komento ilmoittautui lähintä henkilöä vastaan. Syötä komentonimi ilman viiltämistä.",
                    label = "Vastaa komentoon",
                },
                tackleCuffCommand = {
                    description = "Komento kirjautui rautoihin taklauksen jälkeen. Syötä komennon nimi ilman viivaa.",
                    label = "Taklaa kalvosinkomentoa",
                },
                tackleCuffDescription = {
                    description = "Kuvaus taklausrannekkeen sidonnasta FiveM key sizes -valikossa.",
                    label = "Taklaa käsiraudan keybind kuvaus",
                },
                tackleDescription = {
                    description = "Kuvaus taklaussitovuutta varten FiveM-avainsitoutumisvalikossa.",
                    label = "Taklaa keybind-kuvaus",
                },
                tackleEnabled = {
                    description = "Aktivoi lähin henkilö ja pidä hänet maassa.",
                    label = "Taklaus",
                },
                tackleMaxDistance = {
                    description = "Maksimietäisyys kohteeseen taklauksen alkaessa.",
                    label = "Taklausetäisyys",
                },
                tackleNeedsSprint = {
                    description = "Vaadi poliisia juoksemaan ennen kuin hän taklaa ihmistä.",
                    label = "Taklaus vaatii kiritystä",
                },
                tackleReleaseCommand = {
                    description = "Komento ilmoittautui taklauksen jälkeen hallussa olevan henkilön vapauttamiseksi. Syötä komennon nimi ilman viivaa.",
                    label = "Taklaa vapautuskomentoa",
                },
                tackleReleaseDescription = {
                    description = "Description for the settle release size in the FiveM key sizes menu.",
                    label = "Tackle release keybind kuvaus",
                },
                tackleRequireOnDuty = {
                    description = "Vaadi virkavelvollisuutta, ennen kuin poliisi voi ottaa henkilön puheeksi.",
                    label = "Taklaus vaatii velvollisuuden",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Komento käytti tutkan asettelueditorin avaamiseen tai sulkemiseen. Anna komennon nimi ilman viivausta.",
                    label = "Tutka-asettelukomento",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Komentoa käytettiin palauttamaan oletustutkan asettelu. Anna komennon nimi ilman viivausta.",
                    label = "Nollaa tutkan asettelukomento",
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
            locationDescriptions = {
                jail_public_blip = "Sijainti otetaan automaattisesti vankilan ilmestymispisteestä tai ensimmäisestä vankilapäätteestä, jos ilmestymispistettä ei ole asetettu.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Kuluta käsiraudat eivät vaikuta, kun taas kalvosinnapit on poistettu käytöstä.",
                wheelClampUseItemRequiresItem = "Simpukan käyttötila Inventaario tai molemmat vaativat Clampin käytön.",
                ziptiesConsumeRequiresItem = "Kuluttaa vetoketjut ei ole vaikutusta, kun ziptie tuote vaatimus on pois päältä.",
            },
        },
    },
    JobConfiguratorImportFailed = "Config.lua-arvojen tuominen \"%s\": %s.",
    JobConfiguratorImportHistoryFailed = "Tuonti onnistui, mutta sen historiaa ei voitu tallentaa.",
    JobConfiguratorImportNoData = "\"%s\" ei anna config.lua-tuontitietoja.",
    JobConfiguratorImportSuccess = "Tuodut config.lua-arvot vuosille '%s': %d ammattia, %d-asetus, %d-ominaisuus ja %d vuorovaikutuspoikkeamaa.",
    JobConfiguratorTitle = "Ammattikonfiguraattori",
    JobConfiguratorUnknown = "Tuntematon ammatti konfiguraattori.",
}
