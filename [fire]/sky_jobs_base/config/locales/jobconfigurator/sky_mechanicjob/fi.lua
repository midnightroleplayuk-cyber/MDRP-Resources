JobConfigLocales["sky_mechanicjob:fi"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Siirrettävä dynamometri",
                    entryPluralLabel = "Siirrettävät dynamometrit",
                    label = "Siirrettävät dynamometrit",
                },
                workshops = {
                    entryLabel = "Työpaja",
                    entryPluralLabel = "Työpajat",
                    label = "Työpajat",
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
                crewCapacity = "Yksikön miehistön enimmäismäärä. Arvo 0 sallii rajattoman miehistön.",
                joinLocked = "Estää uusia henkilöitä liittymästä sen jälkeen, kun yksikkö on miehitetty.",
                minimumCrew = "Tämän vastesuunnitelman valittujen yksiköiden miehistön vähimmäismäärä.",
                poiId = "Pysyvä tekninen tunnus, johon hätäkeskusprofiili voi viitata kohteen nimeämisen jälkeenkin.",
                readyStatusCode = "FMS-tila, joka asetetaan resurssin tullessa hälytysvalmiiksi.",
                resourceType = "Luokittelee operatiivisen resurssin hätäkeskuksen suodatusta ja koordinointia varten.",
                respondingStatusCode = "FMS-tila, joka asetetaan resurssin vastatessa tehtävään.",
                shortLabel = "Valinnainen lyhyt nimi kuudelle radiokanavan muistipainikkeelle.",
                stationId = "Liittää yksikön hätäkeskusprofiilissa määritettyyn asemaan.",
                unitId = "Pysyvä tekninen tunnus säilyttää yksikön, vaikka kutsutunnus muuttuu.",
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
                noUnitFallback = "Ilman keskustaa tai henkilöstöyksikköä lähettää Sky-ilmoituksen kaikille päivystävälle jäsenelle.",
                radius = "Suurin etäisyys metreinä, jolla aseman tiedotus voidaan kuulla.",
                requirements = "Vastauspyyntö TYYPPI:COUNT-pareina, esimerkiksi PATROL:2,CRIMI:1.",
                statusCode = "Numeerinen FMS-tila, joka näkyy kädessä pidettävässä radiossa.",
                statusLabel = "Tämän FMS-tilan merkitys lähettäjille ja yksiköille.",
                vehicleType = "On vastattava edellisessä alaosiossa määritettyä ajoneuvotyypin koodia.",
                vehicleTypeCode = "Lyhyt yksikkökoodi, jota käytetään vastausvaatimuksissa, esimerkiksi PATROL, CRIME, EMS tai RESCUE.",
                vehicleTypeLabel = "Tämän yksikköluokan luettava nimi.",
            },
            dispatchFields = {
                crewCapacity = "Miehistökapasiteetti",
                joinLocked = "Lukitse miehistöön liittyminen",
                minimumCrew = "Miehistön vähimmäismäärä",
                poiId = "Pysyvä POI-tunnus",
                readyStatusCode = "Valmiustilan koodi",
                resourceType = "Resurssityyppi",
                respondingStatusCode = "Vastetilan koodi",
                shortLabel = "Radiomuistin nimi",
                stationId = "Asematunnus",
                unitId = "Pysyvä yksikkötunnus",
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
                name = "Nimi",
                noUnitFallback = "Ilmoita päivystävälle henkilökunnalle ilman yksiköitä",
                noneChannel = "Ei mitään / ryhmän oletus",
                note = "Huom",
                phone = "Puhelin",
                radius = "Ilmoituksen säde",
                requirements = "Vaaditut yksiköt (esimerkiksi PATROL:2, CRIME:1)",
                type = "Tyyppi",
                vehicleType = "Vastausyksikön tyyppi",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Tunnetut ilmoittajat",
                    channels = "Radiokanavat",
                    plans = "Vasteohjeet",
                    statuses = "Käytettävissä olevat FMS-tilat",
                    units = "Virtuaaliyksiköt",
                },
                active = "Hätäkeskus käytössä",
                description = "Määritä tämän työn hätäilmoitusten vastaanotto, radio, yksiköt, vasteohjeet, sijainnit ja ilmoittajatiedot.",
                inactive = "Hätäkeskus pois käytöstä",
                steps = {
                    accessText = "Ota hätäkeskus käyttöön ja määritä, voivatko tämän työn jäsenet päivystää siellä.",
                    accessTitle = "Käyttöoikeus ja vastaanotto",
                    fleetText = "Määritä radiokanavat, FMS-tilakoodit, ajoneuvotyypit ja kutsutunnukset.",
                    fleetTitle = "Radio ja kalusto",
                    responseText = "Viimeistele avainsanoilla, vastevaatimuksilla ja kiinnostavilla kohteilla.",
                    responseTitle = "Vasteohjeet",
                },
                title = "Hätäkeskus",
                warnings = {
                    channels = "Erillisiä radiokanavia ei ole; käytetään työryhmän varakanavaa.",
                    defaultChannel = "Valittua oletuskanavaa ei enää ole.",
                    disabled = "Hätäkeskus on poistettu käytöstä tältä työltä.",
                    statuses = "Vähintään yhden FMS-tilan on oltava käytettävissä, jotta yksiköitä voidaan hälyttää.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Ylläpitää tehtäväkohtaisia ilmoittajien nimiä, takaisinsoittonumeroita ja hätäkeskuksen muistiinpanoja.",
                dispatchChannels = "Määrittää radiokanavat, joihin yksiköt ja miehistölliset lähetyskeskukset voivat liittyä.",
                dispatchKeywords = "Määrittää tapahtuman avainsanat, vaaditut ajoneuvomäärät, osallistuvat työt ja valinnaisen automaattisen hälytyksen.",
                dispatchPois = "Tallentaa asemat ja yleiset sijainnit tapahtumalomakkeille ja sijaintiin perustuville asemailmoituksille.",
                dispatchStatusCodes = "Määrittää FMS-tilatunnisteet ja mitkä tilat lasketaan käytettävissä oleviksi uusille tapahtumille.",
                dispatchVehicleTypes = "Määrittää toimintasuunnitelmien käyttämät yksikköluokat, kuten partio, rikosyksikkö, hätäkeskus tai pelastus.",
                dispatchVehicles = "Määrittelee virtuaaliset lähetysajoneuvot, jotka voidaan saada miehistöä mistä tahansa ilman, että vaaditaan synnytettyä ajoneuvoa.",
            },
            diagnosticsSettings = {
                enabledLabel = "Ota ajoneuvodiagnostiikka käyttöön",
                enabledDescription = "Salli tämän työn avata ajoneuvodiagnostiikka ja korjata osia sen kautta.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Ajoneuvodiagnostiikka",
                    description = "Määritä tämän työn pääsy ajoneuvodiagnostiikkaan.",
                },
                dispatchReporters = "Tunnetut ilmoittajat",
                invalidSelection = "Virheellinen valinta: {value}",
                billingPrices = {
                    description = "Määritä laskujen hinnat huolto- ja korjaushistoriaan. Toiminta-avain on sovitettu action_key, action_type, tai työmerkkiin.",
                    label = "Laskun syyt",
                },
                billingSettings = {
                    description = "Määritä mekaanikkojen laskutuskäyttäytyminen tälle ammatille.",
                    label = "Laskutus",
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
                partsDeliveryShop = "Osatoimituskauppa",
                trainingSettings = {
                    description = "Määritä koulutuksen käyttöoikeudet, ilmoittautuminen, hyväksynnät ja kurssin suunnittelu tälle työlle.",
                    label = "Harjoitusasetukset",
                },
                tuningCostProfile = {
                    description = "Maarita taman tyopaikan performance-, ulkoasu-, vanne- ja erikoisoptioiden kustannukset.",
                    label = "Tuning-hinnat",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Vapaa kamera viritysvalikossa",
                    description = "Sallii kohdistimen piilottamisen välilyönnillä kameran vapaata liikuttamista varten. Escape sulkee valikon edelleen.",
                },
                tuningCamera = {
                    description = "Kohdistaa kameran automaattisesti valittuun osaan. Kun toiminto on pois käytöstä, käytetään tavallista pelikameraa.",
                    label = "Automaattinen virityskamera",
                },
                jgMileage = {
                    description = "Käytä JG Vehicle Mileagea, kun sen resurssi on käynnissä. Muulloin käytä Sky-kilometrimäärää. JG HUD määritetään erikseen.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Näytä valittu kilometrimäärä JG HUDissa. Toimii ilman JG Vehicle Mileagea; asenna HUD-sovitin README-ohjeen mukaan.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Ota käyttöön ylläpitäjän muokkain ja automaattiset säännöt rekisterikilville ja ajoneuvomalleille. Poistettuasi toiminnon käytöstä ota kyseiset ajoneuvot uudelleen autotallista palauttaaksesi jo käytetyt arvot.",
                    label = "Ajo-ominaisuuksien muokkain",
                },
                kuv = {
                    description = "Aloita tekninen tarkastus",
                    label = "Ajoneuvon tekninen tarkastus",
                },
                mobileDyno = {
                    description = "Ota käyttöön dynamometri, ohjaus- ja tulosnäytöt, puhallinohjain ja tablet-sovellus.",
                    label = "Siirrettävä dynamometri",
                },
                vehicleRegistration = {
                    description = "Rekisteröi / siirrä ajoneuvo",
                    label = "Ajoneuvon rekisteröinti",
                },
                antiLag = {
                    description = "Aktivoi laakasuojan asennus ja pakovaikutukset.",
                    label = "Lag-vastaisuus",
                },
                brakeOverheating = {
                    description = "Aktivoi lavastettu jarrulämpö, hehkuvat levyt, kriittiset kipinät ja lyhyt jarrutus.",
                    label = "Jarrujen ylikuumeneminen",
                },
                carryItems = {
                    description = "Vaadi toimitettujen osien kuljetus korjaamon lapi.",
                    label = "Fyysinen osien kasittely",
                },
                customHandling = {
                    description = "Aktivoi custom-ajo- ja käsittelyviritys.",
                    label = "Mukautettu käsittely",
                },
                electronicTuning = {
                    description = "Aktivoi pysyvät ECU, valaistus- ja ajoavustin-viritysvaihtoehdot.",
                    label = "Sähköinen viritys",
                },
                instantTuning = {
                    description = "Salli suora viritys sovituissa julkisissa virityspaikoissa.",
                    label = "Välitön viritys",
                },
                mileageHud = {
                    description = "Nayta ajoneuvon kilometrit ajon aikana.",
                    label = "Kilometri-HUD",
                },
                nitro = {
                    description = "Aktivoi nitron asennus ja ajoneuvon lisäkäyttö.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Ota korjaamon osatilaukset ja toimitusalueet kayttoon.",
                    label = "Osien toimitus",
                },
                selfServiceOrderNotifications = {
                    description = "Ilmoita päivystävälle työntekijälle, kun syntyy itsepalveluviritys.",
                    label = "Itsepalvelutilausilmoitukset",
                },
                stance = {
                    description = "Näytä Stance-säädöt kaikissa viritysvalikoissa ja ota käyttöön Stance Kit -kappale.",
                    label = "Alustan asento",
                },
                stanceWheelSize = {
                    description = "Näytä, tallenna ja sovella pyörän koon säätöjä Stancessa.",
                    label = "Stance-pyörän koko",
                },
                stanceWheelWidth = {
                    description = "Näytä, tallenna ja sovella pyörän leveyden säätöjä Stancessa.",
                    label = "Stance-pyörän leveys",
                },
                subscriptions = {
                    description = "Aktivoi korjaamojen maksupäätteet, johto ja asiakasalennukset.",
                    label = "Työpajan tilaukset",
                },
                twoStep = {
                    description = "Aktivoi kaksivaiheinen laukaisun ohjaus ja pakovaikutukset.",
                    label = "Kaksivaiheinen",
                },
                vehicleMaintenanceNotifications = {
                    description = "Ilmoita omistajille, kun ajoneuvo saavuttaa määritetyn huoltokynnyksen.",
                    label = "Ajoneuvon huoltoa koskevat ilmoitukset",
                },
                wheelDamage = {
                    description = "Ota realistiset rengasvauriot ja korjaukset kayttoon.",
                    label = "Renkaiden vauriot",
                },
                workshopLift = {
                    description = "Ota korjaamoiden kaytettavat nostinpisteet kayttoon.",
                    label = "Korjaamon nostin",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Sijoita piste korjaamon katsastuspaikalle. Ajoneuvon on oltava määritetyn katsastusetäisyyden sisällä teknistä tarkastusta ja rekisteröintiä varten.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Dynamometrin tulosnäytön sijainti.",
                    label = "Dynamometrin tulosnäyttö",
                },
                mobile_dyno_station = {
                    description = "Siirrettävän dynamometrin sijainti.",
                    label = "Dynamometriasema",
                },
                vehicle_registry = "Katsastus- ja rekisteröintipiste",
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
            settingGroups = {
                diagnostics = {
                    label = "Diagnostiikka",
                },
                keybinds = {
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                    label = "Näppäimet",
                },
                safety = {
                    label = "Tarkistus ja turvallisuus",
                },
                antiExploit = {
                    label = "Hyödyntämisen estäminen",
                },
                coach = {
                    label = "Telemetriavalmentaja",
                },
                cooldownMultipliers = {
                    label = "Jäähtymiskertoimet",
                },
                crashFalloff = {
                    label = "Törmäysvahingon vaimeneminen",
                },
                criticalEngine = {
                    label = "Rikkoutunut moottori",
                },
                deformation = {
                    label = "Epämuodostuminen",
                },
                fade = {
                    label = "Jarrujen tehon heikkeneminen",
                },
                features = {
                    label = "Ominaisuudet",
                },
                format = {
                    label = "Muoto",
                },
                frontalImpact = {
                    label = "Vakavat etutörmäykset",
                },
                general = {
                    label = "Yleiset",
                },
                heatMultipliers = {
                    label = "Lämpenemiskertoimet",
                },
                illegalMarket = {
                    label = "Laittomat markkinat",
                },
                integration = {
                    label = "Integraatio",
                },
                items = {
                    label = "Tavarat",
                },
                lifetime = {
                    label = "Elinikä",
                },
                limits = {
                    label = "Varastointirajat",
                },
                repairRestore = {
                    label = "Korjaa palautus",
                },
                risk = {
                    label = "Riski",
                },
                rules = {
                    label = "Säännöt",
                },
                stages = {
                    label = "Ylikuumenemisen vaiheet",
                },
                tyreRepair = {
                    label = "Renkaan korjaus",
                },
                visuals = {
                    label = "Visuaaliset tehosteet",
                },
            },
            settingSections = {
                electronicTuning = "ECU-moottoriohjelmisto",
                handlingEditor = "Ajettavuuseditori",
                mobileDyno = "Siirrettävä dynamometri",
                vehicleRegistry = "Ajoneuvon todistukset",
                advancedPricing = "Pitkälle kehitetty hinnoittelu",
                brakeOverheating = "Jarrujen ylikuumeneminen",
                carryItems = "Kanna kohteita",
                fakePlates = "Väärennetyt levyt",
                firejobVehicleFires = "Ajoneuvopalot",
                general = "Kenraali",
                instantTuning = "Välitön viritys",
                maintenanceNotifications = "Huoltoilmoitukset",
                mileageHud = "Kilometri-HUD",
                oilLeaks = "Ajoneuvon nestevuodot",
                partsTheft = "Osavarkaus",
                subscriptions = "Tilaukset",
                tuning = "Viritys",
                vehicleCare = "Ajoneuvojen huolto",
                wear = "Kuluminen",
                wheelDamage = "Renkaiden vauriot",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Lisäasetukset",
                handlingAir = "Ilma",
                handlingGeneral = "Yleiset",
                handlingRoad = "Maaliikenne",
                handlingWater = "Vesi",
            },
            settingSubsections = {
                mechanicHotkeys = "Näppäimet",
                database = "Tietokanta",
                handlingEditorGeneral = "Editorin asetukset",
                handlingMaximumCBikeHandlingData = "Moottoripyörä",
                handlingMaximumCBoatHandlingData = "Vene",
                handlingMaximumCCarHandlingData = "Auto",
                handlingMaximumCFlyingHandlingData = "Ilma-alus",
                handlingMaximumCHandlingData = "Ajoneuvon perusta",
                handlingMaximumCSeaPlaneHandlingData = "Vesitaso",
                handlingMaximumCSpecialFlightHandlingData = "Erikoislento",
                handlingMaximumCSubmarineHandlingData = "Sukellusvene",
                handlingMaximumCTrailerHandlingData = "Perävaunu",
                handlingMaximumCVehicleWeaponHandlingData = "Ajoneuvoaseet",
                keybinds = "Näppäimet",
                operation = "Käyttö",
                placementRules = "Sijoitussäännöt",
                testFlow = "Testin kulku",
                tuning = "Välittömän virityksen asetukset",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Ajoneuvon korjaus",
                    description = "Tarjoa ajoneuvon korjausta pikavirityspaikoissa.",
                },
                instantTuningRepairPrice = {
                    label = "Korjauksen hinta",
                    description = "Kiinteä korjaushinta ilman virityksen hintakerrointa.",
                },
                instantTuningWashEnabled = {
                    label = "Ajoneuvon pesu",
                    description = "Tarjoa ajoneuvon pesua pikavirityspaikoissa.",
                },
                instantTuningWashPrice = {
                    label = "Pesun hinta",
                    description = "Kiinteä pesuhinta ilman virityksen hintakerrointa.",
                },
                vehiclePriceSource = {
                    label = "Ajoneuvohintojen lähde",
                    description = "Automaattinen: SQL ESX:ssä; ajoneuvoluettelo QBCore/Qboxissa. Tietokanta: määritetty SQL-taulu kaikissa kehyksissä.",
                    options = {
                        auto = "Automaattinen (kehys)",
                        database = "Tietokanta",
                    },
                },
                vehiclePriceTable = {
                    label = "Ajoneuvohintojen taulu",
                    description = "Ostohinnat sisältävä taulu, esim. dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Spawn-nimen sarake",
                    description = "Spawn-nimet sisältävä sarake, esim. spawn_code (JG), ei näyttönimi.",
                },
                vehiclePricePriceColumn = {
                    label = "Hintasarake",
                    description = "Numeeriset ostohinnat sisältävä sarake, esim. price.",
                },
                vehiclePriceHashColumn = {
                    label = "Mallihashin sarake (valinnainen)",
                    description = "Valinnainen numeerinen hash-sarake, esim. hashkey (JG). Jätä tyhjäksi, jos hashit lasketaan spawn-nimistä.",
                },
                handlingEditorFieldMaximum = {
                    description = "Kiinteä enimmäisarvo, jonka editori hyväksyy tälle ajettavuuskentälle.",
                },
                handlingEditorFocusKey = {
                    label = "Palaa ajettavuusmuokkaimeen",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Koodatut tavut, joiden jälkeen editorin pyyntö, vastaus tai tilannevedos ilmoitetaan suureksi.",
                    label = "Suuren kuorman raja",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mittaa editorin toimintoja ja varoittaa Sky.Debug-palvelun kautta asetettujen rajojen ylittyessä.",
                    label = "Suorituskykytarkistukset",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Millisekunnit koottujen suorituskyky-yhteenvetojen välillä, kun yksityiskohtainen lokitus on käytössä.",
                    label = "Yhteenvedon aikaväli",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Millisekunnit, joiden jälkeen editorin toiminto ilmoitetaan hitaaksi.",
                    label = "Hitaan toiminnon raja",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Suurin prosenttiosuus, jonka numeerinen liukusäädin voi poiketa luetusta ajoneuvon perusarvosta ylös- tai alaspäin. Suora syöttö ja XML-tuonti säilyvät häviöttöminä. Kentän oletusarvosta poikkeava enimmäisarvo korvaa liukusäätimen ylärajan.",
                    label = "Liukusäätimen enimmäispoikkeama",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Katalysaattorin varkaus · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Katalysaattorin varkaus · Ohjain 73",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl172 = {
                    label = "Tehomittaus · Ohjain 172",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl173 = {
                    label = "Tehomittaus · Ohjain 173",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl174 = {
                    label = "Tehomittaus · Ohjain 174",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl175 = {
                    label = "Tehomittaus · Ohjain 175",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl177 = {
                    label = "Tehomittaus · Ohjain 177",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl38 = {
                    label = "Tehomittaus · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl45 = {
                    label = "Tehomittaus · Ohjain 45",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicDynoControl47 = {
                    label = "Tehomittaus · Ohjain 47",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Maalaus · Ohjain 200",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Maalaus · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Ajoneuvon hoito · Ohjain 200",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Ajoneuvon hoito · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Ajoneuvon työntäminen · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Ajoneuvon työntäminen · Ohjain 33",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Ajoneuvon työntäminen · Ohjain 34",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Ajoneuvon työntäminen · Ohjain 35",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Ajoneuvon työntäminen · Ohjain 32",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Ajoneuvon työntäminen · Ohjain 21",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Renkaanvaihto · Ohjain 200",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Renkaanvaihto · Ohjain 202",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Renkaanvaihto · Ohjain 22",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Renkaan varkaus · Ohjain 38",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Renkaan varkaus · Ohjain 73",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                mobileDynoConsumeItem = {
                    description = "Poista yksi esine onnistuneen sijoituksen jälkeen.",
                    label = "Kuluta esine",
                },
                mobileDynoCooldownMs = {
                    label = "Jäähdytyksen kesto",
                },
                mobileDynoCountdownMs = {
                    label = "Käynnistyslaskenta",
                },
                mobileDynoDuiDistance = {
                    label = "Paneelin piirtoetäisyys",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Puhallinohjaimen käyttöetäisyys",
                    description = "Etäisyys metreinä, kun käytetään fyysistä vaihdetta viilentävien tuulettimien välillä.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Täyden kuorman kesto",
                    description = "Millisekunnit kuluivat täydellä kuormalla profiileissa, joihin sisältyy täysi kuorma.",
                },
                mobileDynoHistoryLimit = {
                    label = "Historian raja",
                },
                mobileDynoInteractionDistance = {
                    label = "Paneelin käyttöetäisyys",
                },
                mobileDynoItemUseEnabled = {
                    description = "Salli dynon ja näytön sijoittaminen esineitä käyttämällä.",
                    label = "Sijoitus esineellä",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Aktiivisten istuntojen raja",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Ajoneuvon tunnistusetäisyys",
                },
                mobileDynoMonitorItem = {
                    description = "Tulosnäytön sijoittamiseen käytettävä esine.",
                    label = "Näyttöesine",
                },
                mobileDynoPersistItems = {
                    description = "Säilytä uudet sijoitukset palvelimen uudelleenkäynnistyksen jälkeen.",
                    label = "Tallenna sijoitukset",
                },
                mobileDynoPickupDistance = {
                    description = "Suurin etäisyys metreinä laitteen keräämiseksi.",
                    label = "Keräysetäisyys",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Suurin korkeusero",
                    description = "Kaikkien dynojalanjälkiluotainten suurin sallittu maankorkeuden vaihtelu metreinä.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Suurin sijoituskaltevuus",
                    description = "Maan korkein kaltevuus dynon jalanjäljen yli hyväksyttyinä asteina.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Mekaanikon on oltava työvuorossa sijoitusta ja käyttöä varten.",
                    label = "Vaadi työvuoro",
                },
                mobileDynoResultDuiDistance = {
                    label = "Tulosnäytön piirtoetäisyys",
                    description = "Suurin etäisyys metreinä, joilla erillinen tulosmittari renderoidaan.",
                },
                mobileDynoReturnItem = {
                    description = "Palauta kulutettu esine laitetta kerättäessä.",
                    label = "Palauta esine",
                },
                mobileDynoStationItem = {
                    description = "Dynon sijoittamiseen käytettävä esine.",
                    label = "Dynoesine",
                },
                mobileDynoTabletDistance = {
                    description = "Suurin etäisyys dynosta metreinä tabletin ohjaukselle ja käynnissä oleville testeille.",
                    label = "Tabletin kantama",
                },
                nitroActivationKey = {
                    label = "Pidä nitro painettuna",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                registryBikeChecks = {
                    description = "Moottoripyörän tarkastuskohdat",
                    label = "Moottoripyörän tarkastuskohdat",
                },
                registryCarChecks = {
                    description = "Auton tarkastuskohdat",
                    label = "Auton tarkastuskohdat",
                },
                registryDistance = {
                    description = "Palveluetäisyys (metriä)",
                    label = "Palveluetäisyys (metriä)",
                },
                registryKuvFee = {
                    description = "Ajoneuvon tekninen tarkastus-maksu",
                    label = "Ajoneuvon tekninen tarkastus-maksu",
                },
                registryKuvValidityDays = {
                    description = "Uusien tarkastusten voimassaolo reaaliajassa. Oletus: 30 päivää. Nykyiset päättymisajat säilyvät.",
                    label = "Tarkastuksen voimassaolo (todelliset päivät)",
                },
                registryKuvWarningDays = {
                    description = "Ennakkovaroitus (päiviä)",
                    label = "Ennakkovaroitus (päiviä)",
                },
                registryRegistrationFee = {
                    description = "Rekisteröintimaksu",
                    label = "Rekisteröintimaksu",
                },
                registryReinspectionFee = {
                    description = "Jälkitarkastusmaksu",
                    label = "Jälkitarkastusmaksu",
                },
                registryRequireKuv = {
                    description = "Vaadi voimassa oleva Ajoneuvon tekninen tarkastus rekisteröintiin",
                    label = "Vaadi voimassa oleva Ajoneuvon tekninen tarkastus rekisteröintiin",
                },
                registrySessionSeconds = {
                    description = "Vahvistusaika (sekuntia)",
                    label = "Vahvistusaika (sekuntia)",
                },
                registryTransferFee = {
                    description = "Siirtomaksu",
                    label = "Siirtomaksu",
                },
                registryVehicleTypes = {
                    description = "Sallitut ajoneuvotyypit",
                    label = "Sallitut ajoneuvotyypit",
                },
                tuningFocusKey = {
                    label = "Virityksen hiiriohjaus",
                    description = "FiveM-oletusnäppäin, esim. E, F6 tai MOUSE_BUTTON:MOUSE_RIGHT. Tyhjä tarkoittaa, ettei oletusnäppäintä ole. Pelaajat voivat muuttaa näppäimiään FiveM-asetuksissa; tallennetut omat määritykset säilyvät.",
                },
                addRevenueToSociety = {
                    description = "Talletus maksoi tilausrahaa viritysammatillisen yhteiskunnan tilille.",
                    label = "Talletustulot yhteiskunnalle",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Osien jakeluliikkeet, jotka pysyvät vapaasti ostokelpoisina, kun kehittynyt hinnoittelu on käytössä. Osien sovittaminen ei huomioi kotelointia ja whitespacea.",
                    itemLabel = "Luokka",
                    label = "Aina saatavilla olevat kategoriat",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Pidä muokatut myymäläesineet valituista kategorioista saatavilla ilman viritysmääräystä ja hinnoittele ne dynaamisen toimittajajärjestelmän kautta.",
                    label = "Aina saatavilla olevat myymälätavarat",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Tabletin tuottoanalyysissä esitettyjen päivien määrä.",
                    label = "Analyysijakso",
                },
                advancedPricingCategoryRules = {
                    description = "Toimittajan osuus, marginaali, työvoima- ja hintarajat viritysluokittain.",
                    label = "Ryhmäsäännöt",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Mekaanikon oletusmarginaali ennen luokka- ja luokkamuutoksia.",
                    label = "Oletusmarginaali",
                },
                advancedPricingDifficultyRules = {
                    description = "Kustakin viritysvaikeudesta aiheutuu lisätyövoimakustannuksia.",
                    label = "Vaikeussäännöt",
                },
                advancedPricingEnabled = {
                    description = "Laske uudelleen palvelimen virityshinnat ja, kun Osatoimitus on mahdollista, vaadi Dynasty-osien ostamista niiden erityistä viritysjärjestystä varten.",
                    label = "Aktivoi kehittynyt hinnoittelu",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Normaali virtuaalivarasto jokaiselle toimittajalle.",
                    label = "Peruskanta",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Kysyntäpisteet poistettu per kulunut päivä.",
                    label = "Päivittäinen kysyntä laskussa",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Tavarantoimittajan marginaali lisätty jokaiseen kysyntäkohtaan.",
                    label = "Kysyntämarginaali yksikköä kohti",
                },
                advancedPricingInventoryEnabled = {
                    description = "Nosta toimittajahintoja, kun virtuaalinen osake on alhainen tai kysyntä korkea.",
                    label = "Dynaaminen toimittajavarasto",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Alhaisen varaston aiheuttama toimittajan maksimimarkka.",
                    label = "Alhaisen varaston marginaali",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Osaketaso, jonka alapuolella niukkuuden hinnoittelu alkaa.",
                    label = "Alhainen varastoraja",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Vaatimusmarginaalin yläraja.",
                    label = "Maksimikysynnän markinta",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Virtuaaliyksikköjä täydennetty per kulunut päivä.",
                    label = "Päivittäinen istutus",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Maailmanlaajuinen alennuskatto mekaanikkolaskuille.",
                    label = "Maksimialennus",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Korkein sallittu mekaanikkomarginaali.",
                    label = "Enimmäismarginaali",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Maailmanlaajuinen ylin hintaraja viritysosalle.",
                    label = "Enimmäisvähittäishinta",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Merkintä, työ ja alennusrajat mekaanikkoarvosanan mukaan.",
                    label = "Mekaanista laatua koskevat säännöt",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Pienin sallittu mekaanikkomarginaali.",
                    label = "Vähimmäismarginaali",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Maailmanlaajuisesti matalampi hintaraja viritysosalle.",
                    label = "Vähimmäisvähittäishinta",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Kompaktisessa esimerkissä käytetty ajoneuvoarvo.",
                    label = "Kompakti esikatseluarvo",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Esimerkki live-esikatselun käyttämästä virityskustannusprosentista.",
                    label = "Esikatselun virityskorko",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Esimerkiksi urheilussa käytetty ajoneuvoarvo.",
                    label = "Urheiluesikatseluarvo",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Superauton esimerkissä käytetty ajoneuvon arvo.",
                    label = "Super esikatseluarvo",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minuutteja ennen kuin maksamaton hintatarjous lasketaan uudelleen.",
                    label = "Lainausaika",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Prosentti, joka on palautettu hankitun tilauksen perusteella.",
                    label = "Palautustuki",
                },
                advancedPricingRoundingStep = {
                    description = "Pyöritä jokainen Dynastyn hankintalinja tähän raha-askeleeseen.",
                    label = "Toimittajan pyöristysvaihe",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Dynasty Auto Supply veloitti asiakkaan osahinnan prosentuaalisesti.",
                    label = "Toimittajien osuus",
                },
                advancedPricingTaxPercent = {
                    description = "Veroprosentti on kirjattu erikseen hinnoittelukirjanpitoon.",
                    label = "Verot",
                },
                advancedPricingVehicleClassRules = {
                    description = "Marginaali- ja työvoimaoikaisut GTA ajoneuvoluokan mukaan.",
                    label = "Ajoneuvoluokkaa koskevat säännöt",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Jarrujen päivitysjäähdytyksen kertoimet",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Ajoneuvoluokan jäähdytyksen kertoimet",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Viive millisekunneissa jarrutuksen jälkeen ennen aktiivisen jäähdytyksen alkua.",
                    label = "Jäähdytysviive",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Kuumuus poistettiin sekunnissa, kun jarrua ei käytetä.",
                    label = "Jäähdytysnopeus",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Lämmön taso, jolla kipinät ja lyhyet jarrut hiipuvat, voi käynnistyä.",
                    label = "Kriittinen kynnys",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Mahdollisuudet 0–1 lyhyelle jarrujen katkaisulle jarrutettaessa kriittisessä lämpötilassa.",
                    label = "Epätodennäköisyys sekunnissa",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Vähennä jäähdyttelyä",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Hajoamisen enimmäiskesto",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Vähimmäishajotusaika",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Jarrujen päivityslämpökerroin",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Ajoneuvoluokan lämpökeräimet",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Peruslämpö kasvoi sekunnissa jarrutettaessa viitenopeudella.",
                    label = "Lämmönnousu",
                },
                brakeOverheatingHotThreshold = {
                    label = "Kuuma kynnys",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Ajoneuvon vähimmäisnopeus km/h ennen kuin jarrutus luo lämpöä.",
                    label = "Pienin jarrutusnopeus",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Nopeus km/h, johon määritettyä peruslämpöhyötyä sovelletaan.",
                    label = "Viitenopeus",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Suurin kipinäväli",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Pienin kipinäväli",
                },
                brakeOverheatingVisualDistance = {
                    description = "Maksimimatka metreinä hehkun ja kipinän renderointiin.",
                    label = "Näköetäisyys",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Lämmin kynnys",
                },
                carryItems = {
                    description = "Toimitettu osia, joista pitäisi tulla fyysisiä kantavia rekvisiittaa.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Moottorin suojus",
                                forklift = "Haarukkakori",
                                hand = "Käsi",
                            },
                        },
                    },
                    itemLabel = "Kantokohde",
                    label = "Kassaerät",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 ei lisää tehoa; 1,10 lisää vääntömomenttia 10 %. Koskee ajoneuvoja, joissa on tämä ECU-vaihe.",
                    label = "Vaiheen 1 vääntömomenttikerroin",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 ei lisää tehoa; 1,10 lisää vääntömomenttia 10 %. Koskee ajoneuvoja, joissa on tämä ECU-vaihe.",
                    label = "Vaiheen 2 vääntömomenttikerroin",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 ei lisää tehoa; 1,10 lisää vääntömomenttia 10 %. Koskee ajoneuvoja, joissa on tämä ECU-vaihe.",
                    label = "Vaiheen 3 vääntömomenttikerroin",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 ei lisää tehoa; 1,10 lisää vääntömomenttia 10 %. Koskee ajoneuvoja, joissa on tämä ECU-vaihe.",
                    label = "Vaiheen 4 vääntömomenttikerroin",
                },
                fakePlatesAudit = {
                    label = "Tarkastusloki",
                },
                fakePlatesBlacklist = {
                    description = "Estettyjä sanoja tai katkelmia, jotka eivät näy väärennetyissä levyissä.",
                    label = "Musta lista",
                },
                fakePlatesBlankPlateItem = {
                    description = "Käsityö-/kauppamateriaali, jota käytetään väärennettyihin levytaloussilmukoihin.",
                    label = "Tyhjennä levy",
                },
                fakePlatesCooldownMinutes = {
                    label = "Jäähdytysminuutit",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Pudotusmahdollisuus",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Kaatumislasku päällä",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Pienin kolarinopeus",
                },
                fakePlatesEnabled = {
                    description = "Anna pelaajien käyttää väärennettyjä rekisterikilpipakkauksia ajoneuvoissa.",
                    label = "Aktivoi väärät levyt",
                },
                fakePlatesExpireMinutes = {
                    description = "0 pitää väärennetyt levyt aktiivisina, kunnes käsittelyn nollaaminen tai uudelleen aloittaminen poistaa ne.",
                    label = "Pätevät minuutit",
                },
                fakePlatesExpireOnRestart = {
                    label = "Päättyy uudelleenkäynnistettäessä",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Maksutili",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Laittomat markkinat mahdollistivat",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Laiton markkinahinta",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Riskikerroin",
                },
                fakePlatesInstallDurationMs = {
                    label = "Asennuksen kesto ms",
                },
                fakePlatesItem = {
                    description = "Yhden käyttökerran tuote, joka käynnistää valelevyn asennusvirran.",
                    label = "Valelevypakkaus",
                },
                fakePlatesMaxLength = {
                    label = "Enimmäispituus",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Ajoneuvon etäisyys",
                },
                fakePlatesMinLength = {
                    label = "Vähimmäispituus",
                },
                fakePlatesPattern = {
                    description = "Lua-kuviota käytetään väärennetyn levytekstin validoimiseen, esimerkiksi ^[A-Z0-9]",
                    label = "Lua-kuvio",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Levyn sijaintietäisyys",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Estä päällekkäiset aktiiviset väärennetyt levyt",
                },
                fakePlatesPrinterItem = {
                    description = "Käsityö- ja myymälätyökalu, jota käytetään väärennettyihin levytaloussilmukoihin.",
                    label = "Levytulostimen kohde",
                },
                fakePlatesRequireEngineOff = {
                    label = "Moottorin on oltava pois päältä",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Käytä Config.Functions.CanApplyFakePlate:tä ennen asennusta.",
                    label = "Vaadi omistajaa tai avaimia",
                },
                fakePlatesRequireStopped = {
                    label = "Ajoneuvo täytyy pysäyttää",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Varattu autotalli-integraatioille, jotka kutsuvat reset-tapahtumaa/vientiä.",
                    label = "Nollaa autotalliin",
                },
                fakePlatesRiskCharacters = {
                    label = "Typo-merkit",
                },
                fakePlatesRiskEnabled = {
                    label = "Riskiluokat käytössä",
                },
                fakePlatesRiskTypoChance = {
                    label = "Typo-mahdollisuus",
                },
                fallbackVehicleValue = {
                    description = "Arvoa käytetään silloin, kun ajoneuvon hintaa ei voida ratkaista.",
                    label = "Varavaunun arvo",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Mahdollisuus 0:stä 1:een sen jälkeen, kun moottori on yhä kriittisessä tilassa.",
                    label = "Kriittinen moottoripalon mahdollisuus",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Sekunteja ennen kuin toinen rikkinäinen moottoripalo voi laukaista.",
                    label = "Kriittinen moottorin jäähdytys",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Viive millisekunneissa ennen kuin rikkinäinen moottori syttyy.",
                    label = "Kriittinen moottorin viivästys ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Anna kriittisesti vaurioituneiden moottorien sytyttää paloauton palo viivästyksen jälkeen.",
                    label = "Sytytyskatkotut moottorit",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Savutiheys, jota käytetään rikkoutuneiden moottorien palopyyntöihin.",
                    label = "Kriittinen moottorin savutiheys",
                },
                firejobVehicleFiresEnabled = {
                    description = "Anna mekaanisten työpaikkavahinkojen järjestelmien pyytää ajoneuvopaloja Firejookilta.",
                    label = "Aktivoi paloautopalot",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Vaadittu eteenpäin suuntautuvan liikkeen suhde 0:stä 1:een.",
                    label = "Eteenpäin suuntautuvan liikkeen suhde",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Mahdollisuudet 0–1, että karsintaisku sytyttää tulipalon.",
                    label = "Törmäyspalon mahdollisuus",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Sekunteja ennen kuin toinen törmäyslaukaus laukeaa.",
                    label = "Törmäyspalon jäähtyminen",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Anna voimakkaiden etutörmäysten pyytää paloautopaloa.",
                    label = "Sytytysjäljet vakavien kolarien jälkeen",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Palontorjuntapyyntöihin on käytetty savutiheyttä.",
                    label = "Iskusavun tiheys",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automaattinen käyttää aseteltua Firejob-resurssia; Vammainen estää mekaanista työtä aiheuttamasta tulipaloja.",
                    label = "Kotoutumistila",
                    options = {
                        automatic = "Automaattinen",
                        disabled = "Pois käytöstä",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Pienin mahdollinen ruumiin terveyden menetys iskun aikana.",
                    label = "Vähimmäisvaurio kehossa",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Moottorin vähimmäisterveys heikkeni törmäyksen aikana.",
                    label = "Moottorin vähimmäisvauriot",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Käytä 0:tä tämän muodonmuutostarkistuksen lopettamiseen.",
                    label = "Pienin etusormen muodonmuutos",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Pienin iskua edeltävä nopeus km/h.",
                    label = "Pienin iskunopeus",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Vaadittu nopeushäviö km/h törmäyksen aikana.",
                    label = "Pienin nopeushäviö",
                },
                firejobVehicleFiresResource = {
                    description = "Resurssi, joka vastaanottaa ajoneuvopalopyyntöjä.",
                    label = "Palomiesresurssit",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Sisäinen palvelintapahtuma, jolla mekaanikkoasiakas pyysi paloautopaloa.",
                    label = "Mekaaninen palvelintapahtuma",
                },
                freeVehicles = {
                    description = "Ajoneuvojen kutumallit, jotka saavat ilmaisia viritystilauksia.",
                    itemLabel = "Ajoneuvon malli",
                    label = "Vapaaviritysajoneuvot",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Estää Käyttö, kun kriittinen käsittely konflikti on olemassa.",
                    label = "Estä kriittiset löydökset",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Odotettu suurin hidastuvuus m/s2 valmiissa jarrutustestissä.",
                    label = "Jarrujen pienin hidastuvuus",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Mitatut näytteet vaaditaan ennen kuin Telemetria Coach arvioi juoksun.",
                    label = "Vähimmäisnäytteet",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Mitattu pyörän luisumisnopeus km/h, jolla ajohäviö ilmoitetaan.",
                    label = "Pyörän luiskahdusvaroitus",
                },
                handlingEditorDefaultTab = {
                    description = "Sivu valitaan aina, kun itsenäinen käsittelyeditori avautuu.",
                    label = "Aloitussivu",
                    options = {
                        advanced = "Edistynyt",
                        export = "Vie",
                        flags = "Liput",
                        fleet = "Laivasto",
                        inspector = "Laatat",
                        profiles = "Profiileja",
                        simple = "Yksinkertainen",
                        telemetry = "Telemetria",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Tarjoa jokaiselle käsittelyarvolle vaikutus, viitealue, oireet, niihin liittyvät kentät ja elävä tuki.",
                    label = "Kentän dokumentointi",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Etsi ja suodata lippujen nimet, tehosteet, bittipaikat ja heksadesimaalinaamarit.",
                    label = "Lippuhaku",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Etsi, tarkasta, mainosta ja palauta malli- ja levynkäsittelysäännöt.",
                    label = "Laivaston päällikkö",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Näytä ajoneuvotukikohta, asennetut viritykset, mallisääntö, rekisterikilpisääntö ja nykyinen editoriluonnos jokaiselle kentälle.",
                    label = "Tasontarkastaja",
                },
                handlingEditorMaxFleetResults = {
                    description = "Laivaston johtajalle ladatut enimmäismalli- ja rekisterikilven säännöt.",
                    label = "Laivaston tulosrajoitus",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Kullekin profiilille jätettyjen tarkistusten enimmäismäärä.",
                    label = "Profile-tarkistukset",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Kullekin hallinnoijalle säilytetään suurimmat nimetyt työtilat.",
                    label = "Henkilökohtaiset työtilat",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Luo auditoitava versio aina, kun jaettua profiilia päivitetään tai palautetaan.",
                    label = "Profiilin versiointi",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Luo avoimet sääntöpohjaiset suositukset mitatuista tietestitiedoista.",
                    label = "Telemetriavalmentaja",
                },
                handlingEditorValidatorEnabled = {
                    description = "Tunnista vaaralliset tai ristiriitaiset yhdistelmät ennen käsittelyn aloittamista.",
                    label = "Käsittelyn varmentaja",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Salli hallinnoijien pitää nimettyjen yksityisten editorien luonnokset.",
                    label = "Henkilökohtaiset työtilat",
                },
                instantTuningAllowedJobs = {
                    description = "Valinnainen maailmanlaajuinen anniskelulupalista. Jätä tyhjäksi, jotta kaikki voivat olla mukana, ellei vain mekaanikko ole käytössä.",
                    itemLabel = "Työn nimi",
                    label = "Sallitut työt",
                },
                instantTuningBlipColor = {
                    description = "GTA pilkkuväri id.",
                    label = "Blip-väri",
                },
                instantTuningBlipEnabled = {
                    description = "Näytä karttavipuja pikavirityspaikoille.",
                    label = "Blip-asento käytössä",
                },
                instantTuningBlipName = {
                    description = "Karttasivun nimi.",
                    label = "Blip-nimi",
                },
                instantTuningBlipSprite = {
                    description = "GTA slip sprite id.",
                    label = "Blip-sprite",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Käytä merkkityylistä E-vuorovaikutusta silloinkin, kun kohdetuki on käytössä.",
                    label = "Voimamerkkien vuorovaikutus",
                },
                instantTuningInteractionDistance = {
                    description = "Oletusetäisyys pikavirityspisteiden käyttöön.",
                    label = "Vuorovaikutusetäisyys",
                },
                instantTuningLabel = {
                    description = "Oletusteksti näkyy pikavirityspisteissä.",
                    label = "Oletusetiketti",
                },
                instantTuningLocations = {
                    description = "Pikavirityspisteet. Käytä 0-etäisyyttä periäksesi oletusvälin.",
                    itemLabel = "Sijainnit",
                    label = "Sijainnit",
                },
                instantTuningMarkerEnabled = {
                    description = "Piirrä maailmanmerkki välittömästi virityspaikoille.",
                    label = "Merkintä käytössä",
                },
                instantTuningMarkerType = {
                    description = "GTA merkkityyppiä, jota käytetään pikavirityksessä.",
                    label = "Merkin tyyppi",
                },
                instantTuningMechanicOnly = {
                    description = "Rajoita kaikki välittömät virityspaikat mekaanikkoammattien konfigurointiin.",
                    label = "Vain mekaanikko",
                },
                instantTuningPriceMultiplier = {
                    description = "Välittömiin virityshintoihin sovellettiin kerrointa.",
                    label = "Hintakerroin",
                },
                instantTuningProfile = {
                    description = "Määritä, mitkä viritysvaihtoehdot ovat saatavilla pikavirityspisteissä.",
                    label = "Välitön viritysasetukset",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimimin ennen kuin sama ajoneuvo voi käynnistää toisen huoltomuistutuksen.",
                    label = "Ilmoituksen jäähdyttäminen",
                },
                maintenanceNotificationsEnabled = {
                    description = "Ilmoita ajoneuvon omistajille, kun kulumisosuus saavuttaa huoltokynnyksen.",
                    label = "Käytössä",
                },
                maintenanceNotificationsThreshold = {
                    description = "Kulumisprosentti, kun kunnossapito katsotaan aiheelliseksi tai sitä pienemmäksi.",
                    label = "Kynnysarvo",
                },
                mileageHudDigits = {
                    description = "Numeroiden lukumäärä kilometrimäärässä HUD.",
                    label = "Digitsit",
                },
                mileageHudPosition = {
                    description = "Vedä kilometrimäärä HUD esimakua haluttuun näyttöasentoon.",
                    label = "Paikka",
                },
                oilLeaksCooldownSeconds = {
                    description = "Sekunteja ennen kuin toinen iskuvuoto voi laukaista.",
                    label = "Iskun jäähdyttäminen",
                },
                oilLeaksEnabled = {
                    description = "Anna vaurioituneiden polttoajoneuvojen jättää nestettä ajon aikana.",
                    label = "Aktivoi nestevuotoja",
                },
                oilLeaksEngineOilChance = {
                    description = "Normaali vuotomahdollisuus 0:stä 1:een.",
                    label = "Moottoriöljymahdollisuus",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Kriittinen vuotomahdollisuus 0:sta 1:een.",
                    label = "Kriittinen moottoriöljymahdollisuus",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Moottorin öljytila, jossa käytetään kriittistä mahdollisuutta.",
                    label = "Kriittinen moottoriöljykynnys",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Moottorin öljytila, jossa vuoto voi alkaa.",
                    label = "Moottoriöljykynnys",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Vaadittu eteenpäin suuntautuvan liikkeen suhde 0:stä 1:een.",
                    label = "Eteenpäin suuntautuvan liikkeen suhde",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Anna kovien etutörmäysten käynnistää väliaikainen moottorinestevuoto.",
                    label = "Etutörmäysvuodot",
                },
                oilLeaksImpactChance = {
                    description = "Mahdollisuudet 0–1, että karsintavaikutus aloittaa vuodon.",
                    label = "Iskun mahdollisuus",
                },
                oilLeaksImpactRadius = {
                    description = "Radius iskun aiheuttamasta nesteen alkupisteestä.",
                    label = "Törmäysvuotosäde",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimisekunnit reittipisteiden välissä.",
                    label = "Reittiväli",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Sekunteja vuoto jatkuu karsintaiskun jälkeen.",
                    label = "Iskuvuodon kesto",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Pienin mahdollinen ruumiin terveyden menetys iskun aikana.",
                    label = "Vähimmäisvaurio kehossa",
                },
                oilLeaksMinDistance = {
                    description = "Matkan vähimmäisetäisyys reittipisteiden välillä.",
                    label = "Reittietäisyys",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Moottorin vähimmäisterveys heikkeni törmäyksen aikana.",
                    label = "Moottorin vähimmäisvauriot",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Vaaditaan muodonmuutos edessä. Käytä 0 poistaaksesi tämän shekin.",
                    label = "Pienin etusormen muodonmuutos",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Pienin iskua edeltävä nopeus km/h.",
                    label = "Pienin iskunopeus",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Vaadittu nopeushäviö km/h törmäyksen aikana.",
                    label = "Pienin nopeushäviö",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Ajoneuvon vähimmäisnopeus km/h ennen nestevuotoa voi johtaa jäljille.",
                    label = "Vähimmäisnopeus",
                },
                oilLeaksRadius = {
                    description = "Radius säännöllisistä ajoneuvon nestejohtopisteistä.",
                    label = "Reitin säde",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Normaali vuotomahdollisuus 0:stä 1:een.",
                    label = "Transmission nesteen mahdollisuus",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Kriittinen vuotomahdollisuus 0:sta 1:een.",
                    label = "Kriittinen lähetysmahdollisuus",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Voimansiirtonesteen tila, jossa käytetään kriittistä mahdollisuutta.",
                    label = "Kriittinen siirtokynnys",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Voimansiirtonesteen tila, jossa vuoto voi alkaa.",
                    label = "Voimansiirtonesteen kynnys",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Ajoneuvoluokat, jotka voivat suorittaa hissiriippuvaisen tilaustyön ilman korjaamon hissiä.",
                    itemLabel = "Lisää ajoneuvoluokka",
                    label = "Noston ohitusajoneuvoluokat",
                    options = {
                        ["0"] = "Kompaktit",
                        ["1"] = "Sedanit",
                        ["10"] = "Teollinen",
                        ["11"] = "Huolto",
                        ["12"] = "Pakettiautot",
                        ["13"] = "Pyörät",
                        ["14"] = "Veneet",
                        ["15"] = "Helikopterit",
                        ["16"] = "Lentokoneet",
                        ["17"] = "Huolto",
                        ["18"] = "Hätä",
                        ["19"] = "Sotilasvoimat",
                        ["2"] = "Maasturit",
                        ["20"] = "Kaupallinen",
                        ["21"] = "Junat",
                        ["22"] = "Avoin pyörä",
                        ["3"] = "Kytkimet",
                        ["4"] = "Lihakset",
                        ["5"] = "Urheiluklassikoita",
                        ["6"] = "Urheilu",
                        ["7"] = "Super",
                        ["8"] = "Moottoripyörät",
                        ["9"] = "Maastoliikenne",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Ajoneuvojen kutumallit, joilla voidaan suorittaa hissiriippuvaiset tilaustyöt ilman korjaamohissiä.",
                    itemLabel = "Ajoneuvon malli",
                    label = "Noston ohitusajoneuvomallit",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Milliseconds, jota käytetään tilaamiseen, asentaa vaiheita, jotka eivät pyöritä minipeliä.",
                    label = "Yksinkertainen asennusaika",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Ajoneuvoluokan tunnisteet, joissa käytetään aina normaalia asentajaa ilman erikoisnosturia tai minipelivirtaa.",
                    label = "Muut kuin peliajoneuvoluokat",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Ajoneuvojen kutumallit, joissa käytetään aina normaalia mekaanikkoa, ilman erikoisnosturia tai minipelivirtaa.",
                    label = "Muut kuin peliajoneuvomallit",
                },
                partsDeliveryCompanyCard = {
                    description = "Anna osien toimitustilausten käyttää yrityksen varoja.",
                    label = "Yrityskorttimaksu",
                },
                partsDeliveryMode = {
                    description = "Pidä normaali fyysinen toimitusvirta tai lisää koko toimitus suoraan keräävän pelaajan inventaarioon.",
                    label = "Toimitusten käsittely",
                    options = {
                        player_inventory = "Pelaajien luettelo",
                        standard = "Vakiotoimitusvirta",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millisekunteja vaaditaan purkamaan valmis osatoimitus.",
                    label = "Avoin kesto",
                },
                partsDeliveryOwnCard = {
                    description = "Anna pelaajien maksaa osien toimitustilaukset omalla rahallaan.",
                    label = "Oman kortin maksu",
                },
                partsDeliveryTimeSeconds = {
                    description = "Tilausosien ja toimituksen välillä alkaa olla sekunteja.",
                    label = "Toimitusaika",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Inventaario, joka on myönnetty, kun katalysaattori varastetaan.",
                    label = "Katalyyttimuunnin",
                },
                partsTheftDealerAccount = {
                    description = "Tili, jota käytetään varastettujen osien jälleenmyyjän maksuihin, kuten rahaan tai pankkiin.",
                    label = "Jakajan maksutili",
                },
                partsTheftDealerItems = {
                    description = "Varastettuja tavaroita jakaja ostaa ja niiden voittoarvot.",
                    itemLabel = "Jälleenmyyjän tuote",
                    label = "Jakajatuotteet",
                },
                partsTheftDealerPayoutItem = {
                    description = "Inventaario on annettu, kun jakajan voittotyyppi on Tuote. Myyntihintaa käytetään erän summana.",
                    label = "Jakajan voittoerä",
                },
                partsTheftDealerPayoutType = {
                    description = "Valitse, maksaako jakaja kehystilille vai antaako se inventaarioerän.",
                    label = "Jakajan maksutyyppi",
                    options = {
                        account = "Tili",
                        item = "Esine",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Maksimi etäisyys jakajasta varastettujen osien myymiseen.",
                    label = "Jakaja myy etämyyntiä",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Sekunnit ennen samaa ajoneuvo-osaa voivat luoda uuden lähetyksen.",
                    label = "Hälytyksen viive",
                },
                partsTheftDispatchEnabled = {
                    description = "Luo poliisiasema, kun pyörä tai katalysaattori varastetaan.",
                    label = "Lähetä poliisiasema",
                },
                partsTheftDispatchJobs = {
                    description = "ammattinimikkeet, jotka saavat osia varkauksista.",
                    itemLabel = "Työn nimi",
                    label = "Hälytysammattit:**",
                },
                partsTheftDispatchMessage = {
                    description = "Viesti näkyy hätäkutsussa. Tukee {plate}, {part} ja {type}.",
                    label = "Lähetysviesti",
                },
                partsTheftDispatchTitle = {
                    description = "Hälytyksen otsikko. Tukee {plate}, {part} ja {type}.",
                    label = "Lähetyksen otsikko",
                },
                partsTheftItem = {
                    description = "Inventaario, jolla varastetaan pyöriä ja katalysaattoreita.",
                    label = "Varkaustyökalun kohde",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Poista varkaustyökalun kohde onnistuneen varkauden jälkeen.",
                    label = "Kuluta varkaustyökalua",
                },
                partsTheftStolenWheelItem = {
                    description = "Inventaario palkittiin, kun pyörät varastettiin.",
                    label = "Varastettu pyörän osa",
                },
                priceType = {
                    description = "Prosentti laskee kustannukset ajoneuvon hinnasta. Kiinteä käyttää raha-arvoja. Ajoneuvoluokka käyttää luokan hinnoittelutaulukkoa.",
                    label = "Hintatyyppi",
                    options = {
                        class = "Ajoneuvoluokka",
                        fixed = "Kiinteä",
                        percentage = "Prosenttia",
                    },
                },
                primaryColor = {
                    description = "Oletusväri mekaanikkojen ammattiryhmälle ja uusille ammateille. Käytä hex-arvoa, kuten #EDC001.",
                    label = "Pääväri",
                },
                publicUsersSeePrices = {
                    description = "Kun se on käytössä, julkiset asiakkaat maksavat tilaamisen yhteydessä. Poista tämä, jotta voit tehdä maksamattomia tilauksia mekaanikkolaskutukseen.",
                    label = "Veloita julkiset itsepalvelumääräykset",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Anna valtuutetuille pomoille mahdollisuus ostaa tilaus koko ammatilleen yrityksen varoilla.",
                    label = "Yhtiön merkitseminen",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Maksuvaluutta",
                },
                subscriptionsEnabled = {
                    description = "Aktivoi työpajatilaukset, asiakaspäätteet ja tilausalennukset.",
                    label = "Käytössä",
                },
                subscriptionsMaximumDurations = {
                    description = "Maksimikesto ja hintavaihtoehdot tilausmallia kohden.",
                    label = "Enimmäiskestot",
                },
                subscriptionsMaximumModels = {
                    description = "Maksimitilausmallit workshop voi konfiguroida tabletissa.",
                    label = "Suurimmat mallit",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Valinnainen silmukka-animaatioleike, jota käytetään, kun tilanne on tyhjä.",
                    label = "NPC smote clip",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Valinnainen animaatiosanakirja, jota käytetään, kun skenaario on tyhjä.",
                    label = "NPC emoottinen sanakirja",
                },
                subscriptionsNpcPedModel = {
                    description = "Ped-malli kutea tilauspäätteissä, esimerkiksi s_m_m_autoshop_01.",
                    label = "NPC:n oletusmalli",
                },
                subscriptionsNpcScenario = {
                    description = "Valinnainen GTA skenaario, kuten WORLD_HUMAN_CLIPBOARD. Jätä tyhjäksi käyttääksesi emote-animaatiota.",
                    label = "NPC skenaario",
                },
                tuningBlockedPlates = {
                    description = "Ajoneuvoja, joissa on jokin näistä levyistä, ei voi virittää, asentaa eikä virittää pois. Täsmääminen ei huomioi koteloa ja valkoista tilaa.",
                    itemLabel = "Rekisterikilpi",
                    label = "Tukossa olevat virityslevyt",
                },
                tuningWorkshopDistance = {
                    description = "Suurin etäisyys itsepalveluvirityspisteestä vaadittujen asennus- tai poistotoimien osalta.",
                    label = "Työpajan vaatimusetäisyys",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Vaatii virityskäskyn asennusta, jotta se käynnistyy ja valmistuu lähellä itsepalvelun virityspistettä.",
                    label = "Vaadi korjaamo asennuksille",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Vaatii viritysten poistoa, jotta itsepalveluvirityspisteen lähettyviltä voidaan aloittaa ja täydentää.",
                    label = "Vaadi korjaamo poistuksille",
                },
                vehicleCareRepairDurationMs = {
                    description = "Korjausprosessin kesto millisekunneissa.",
                    label = "Korjausten kesto",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Rentouta realistisia pyörävaurioita myös korjaustöiden yhteydessä.",
                    label = "Korjaa realistiset pyörävauriot",
                },
                vehicleCareRepairItem = {
                    description = "Ajoneuvon korjaustoimen käyttämä inventointikohde.",
                    label = "Korjaustavara",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Suurin sallittu etäisyys ajoneuvosta korjaustöiden aikana.",
                    label = "Korjauksen enimmäisetäisyys",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Poista korjauskohde käytön jälkeen.",
                    label = "Kuluta korjauskohde",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Korjataan normaalit GTA ajoneuvovauriot korjaustoimen yhteydessä.",
                    label = "Korjataan ajoneuvon vauriot",
                },
                vehicleCareRepairWearParts = {
                    description = "Valitse, mitkä käyttö- ja huolto-osat korjauserä palauttaa. Poista nesteet täältä, jos öljyn, jäähdytysnesteen, jarrunesteen tai vaihteistonesteen pitäisi vaatia diagnostiikan korjausvirtaa.",
                    itemLabel = "Pukuosa",
                    label = "Korjaussarjan entisöidyt osat",
                },
                vehicleCareWashItem = {
                    description = "Ajoneuvon pesuun käytetty inventaario.",
                    label = "Pesuaine",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Poista pesuaine käytön jälkeen.",
                    label = "Kuluta pesuaine",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Etäisyys vahattu ajoneuvo pysyy puhtaana.",
                    label = "Vaha puhtaat kilometrit",
                },
                vehicleCareWaxItem = {
                    description = "Ajoneuvon vahaamiseen käytetty inventaario.",
                    label = "Vahatuote",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Poista vahakappale käytön jälkeen.",
                    label = "Kuluta vahatuote",
                },
                vehicleClassPricing = {
                    description = "Ohita hintatyyppi ja kustannuskerroin jokaiselle GTA ajoneuvoluokalle.",
                    label = "Ajoneuvoluokan hinnoittelu",
                },
                wearParts = {
                    description = "Ajoneuvon kulutusosat, niiden elinikäinen etäisyys, vaadittu korjauserä, tuotteen kulutus ja asennusvirta.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Katalyyttimuuntaja",
                                fluid_refill = "Nestetäyttö",
                                hood_install = "Hoodin asennus",
                                oil_change = "Öljyn muutos",
                                performance = "Suorituskyky",
                                underbody_neon = "Alusvaate / nosto",
                                wheel = "Pyörä",
                            },
                        },
                    },
                    itemLabel = "Pukuosa",
                    label = "Kulutusosat",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Peruspyörän vauriokerroin.",
                    label = "Oletuskerroin",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Suodattaa epämuodostumaluotainpisteet, jotka eivät osoita takaisin ajoneuvon runkoon.",
                    label = "Luotainkulman kynnys",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Lisävoima lisäsi jokaisen iteroinnin.",
                    label = "Epämuodostumavaurioiden lisääntyminen",
                },
                wheelDamageDeformationEnabled = {
                    description = "Vangitaan ja palautetaan vartalon lommot renkaan korjausgeometrian rekonstruoinnissa.",
                    label = "Palauta muodonmuutos",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Lommojen palauttamisessa käytetään aloitusvoimaa.",
                    label = "Alkuvaiheen muodonmuutosvauriot",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximum SetVehicleDamage kulkee käytetään uudelleen lommot.",
                    label = "Epämuodostumat iteroinnit",
                },
                wheelDamageDeformationThreshold = {
                    description = "Pienin havaittu muodonmuutoskoko säilöttäväksi.",
                    label = "Epämuodostumiskynnys",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Kerrosta käytetään silloin, kun ajoneuvossa on maastopyörät.",
                    label = "Maastopyörän kerroin",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Ylimääräiset muut kuin pyörävauriot palauttavat kulkuluvat sen jälkeen, kun pyörän geometria on rakennettu uudelleen.",
                    label = "Vahingon toistuminen",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Ylimääräiset pikapassit yhä puuttuviin tai yhä täysiin renkaisiin pyörän korjauksen jälkeen.",
                    label = "Pyörätie ohittaa uudelleen",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Pidä runko, moottori, ikkunat, ovet, lika ja visuaaliset vauriot, kun renkaan korjaus palauttaa pyörän geometrian.",
                    label = "Ajoneuvojen vaurioiden säilyttäminen",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Palauta rikkoutuneet ikkunat mahdollisuuksien mukaan ilman kovaa murskausvaikutusta.",
                    label = "Hiljaiset rikkinäiset ikkunat",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Hakeudu uudelleen renkaisiin ilman, että renkaan ääni tai vaikutus alkaa uudelleen.",
                    label = "Hiljainen litteä rengas hakee uudelleen",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Suurin etäisyys vaurioituneesta tai puuttuvasta renkaasta asennusta varten.",
                    label = "Renkaan kiinnitysetäisyys",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Maksimietäisyys sijoitettuun autonjackiin poistotoimintoa varten.",
                    label = "Auton jakajan etäisyys",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Vauriokerroin GTA ajoneuvoluokkaa kohti.",
                    itemLabel = "Ajoneuvoluokka",
                    label = "Ajoneuvoluokkien kertoimet",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Estä muut ammatit, kun mekaanikkoja on työvuorossa",
                },
                allowsprint = {
                    label = "Salli juokseminen toimituslaatikoiden kanssa",
                },
            },
            tuningCategories = {
                bodywork = "Kori",
                electronics = "ECU ja ajoneuvoelektroniikka",
                engineSounds = "Moottoriäänet",
                handling = "Ajettavuus",
                lights = "Valot",
                other = "Muut",
                paint = "Maalaus",
                performance = "Suorituskyky",
                stance = "Alustan asento",
                wheels = "Vanteet",
            },
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Asiakashinta",
                description = "Esimerkki kosmeettisista laskelmista nykyisillä säännöillä.",
                labor = "Työ",
                live = "Live-esikatselu",
                margin = "Marginaali",
                sports = "Urheiluauto",
                super = "Supercar",
                supplier = "Toimittaja",
                title = "Hinnan esikatselu",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Maarita mekaanikkotyot, kaupat, ajoneuvot ja korjaamosijainnit.",
                    title = "Mekaanikkotyot",
                },
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
            fields = {
                quantity = "Määrä",
            },
            settingFieldDescriptions = {
                radialEnabled = "Avaa mekaanikon laskutus raidallisesta valikosta.",
                allowTuningInvoices = "Lähetä virityskori lähimmälle asiakkaalle. Asennus aukeaa täyden maksun jälkeen.",
                customerRange = "Maksimimatka metreinä laskujen lähettämiseen läheisille asiakkaille.",
                allowAnalytics = "Salli laskutusanalytiikka, ellei arvosanasääntö ohita sitä.",
                allowCustomPrices = "Anna mekaanikon muokata laskun sijaintihintoja ennen julkaisua.",
                allowEstimates = "Salli arviot, jotka asiakkaiden on hyväksyttävä ennen maksua.",
                allowImmediatePayment = "Salli tämän ammatin laskujen maksaminen suoraan.",
                allowManualItems = "Anna mekaanikkojen luoda mielivaltaisia laskutuspaikkoja.",
                allowPartialPayments = "Salli talletuksia ja useita maksuja kohti yhtä laskua.",
                analyticsPeriodDays = "Päivät sisältyvät laskutusanalytiikkaan.",
                defaultDueDays = "Päiviä, kunnes lasku on myöhässä.",
                depositPercent = "Vaadittu talletusprosentti laskun tai arvion julkaisemisen jälkeen.",
                enabled = "Anna tämän ammatin käyttää mekaanikkolaskutusta.",
                estimateLifetimeHours = "Tunteja ennen kuin vastaamaton arvio päättyy.",
                gradeRules = "Jokaiselle mekaanikkoluokalle on tarjolla laskurajat ja -toiminnot.",
                maxDiscountPercent = "Suurinta alennusta lasku voi saada.",
                maximumInvoiceAmount = "Maailmanlaajuinen kokonaissumma ennen luokkarajoja.",
                maximumManualItems = "Suurin mahdollinen mielivaltainen sijainti asiakirjaa kohden.",
                maximumReminders = "Maksimimuistutukset sallittu per lasku.",
                minimumInvoiceAmount = "Minimisumma arvioita ja laskuja varten.",
                minimumPartialPayment = "Pienin osamaksu lukuun ottamatta pienempää jäljellä olevaa saldoa tai talletusta.",
                reminderFee = "Maksu lisätään jokaiseen validiin muistutukseen.",
                reminderGraceDays = "Päiviä myöhässä, ennen kuin ensimmäinen muistutus on sallittu.",
                taxPercent = "Verot lisätty alennusten jälkeen.",
            },
            settingFields = {
                radialEnabled = "Laskun raidallinen toiminta",
                allowTuningInvoices = "Laskujen viritysasiakkaat",
                customerRange = "Asiakasetäisyys",
                allowAnalytics = "Kirjanpitoanalytiikka",
                allowCancellation = "Peruutus",
                allowCustomPrices = "Salli mukautetut hinnat",
                allowEstimates = "Salli arviot",
                allowImmediatePayment = "Salli välitön maksu",
                allowManualItems = "Salli omat positiot",
                allowPartialPayments = "Osittaisten maksujen salliminen",
                allowReminders = "Muistutukset",
                amount = "Määrä",
                analyticsPeriodDays = "Analyysijakso",
                bone = "Luu",
                category = "Luokka",
                classId = "Luokka ID",
                defaultDueDays = "Maksuaika (päivät)",
                depositPercent = "Talletusprosentti",
                difficulty = "Vaikeus",
                enabled = "Aktiivinen",
                estimateLifetimeHours = "Arvioitu elinikä (tunteja)",
                flow = "Asenna virta",
                grade = "Taso",
                gradeRules = "Luokitussäännöt",
                item = "Esine",
                key = "Avain",
                kilometersToZero = "Kilometrit nollaan",
                label = "Etiketti",
                laborFee = "Työvoimakustannukset",
                laborMultiplier = "Työvoimakerroin",
                marginAdjustmentPercent = "Marginaalikorjaus",
                marginPercent = "Marginaali %",
                maxDiscountPercent = "Maksimialennus",
                maximumInvoiceAmount = "Maksimilasku",
                maximumManualItems = "Oman varallisuuden enimmäismäärä",
                maximumPrice = "Maksimi",
                maximumReminders = "Maksimimuistutukset",
                minimumInvoiceAmount = "Vähimmäislasku",
                minimumPartialPayment = "Vähimmäisosamaksu",
                minimumPrice = "Vähimmäismäärä",
                multiplier = "Kertoja",
                name = "Kohteen nimi",
                partKey = "Osa-avain",
                price = "Hinta",
                priceType = "Hintatyyppi",
                prop = "Rekvisiitta",
                reason = "Syy",
                reminderFee = "Muistutusmaksu",
                reminderGraceDays = "Muistutus siirtymäajasta",
                removeAfterUse = "Kuluta esine",
                repair = "Korjaus pakkauksella",
                repairItem = "Korjaustavara",
                rx = "Kääpiö X",
                ry = "Kääpiö",
                rz = "Rot Z",
                supplierSharePercent = "Toimittaja %",
                taxPercent = "Laskujen verotus",
                transport = "Kuljetus",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Parannus",
                maximumDiscountPercent = "Suurin alennus",
            },
            settingValues = {
                air_filter = "Ilmasuodatin",
                brake_fluid = "Jarruneste",
                brake_pads = "Jarrutelineet",
                catalytic_converter = "Katalyyttimuunnin",
                clutch = "Kytkentä",
                coolant = "Jäähdytysaine",
                engine_oil = "Moottoriöljy",
                inverter = "Virranmuuntaja",
                spark_plugs = "Kipinätulpat",
                suspension = "Keskeytys",
                traction_battery = "Vetoakku",
                transmission_fluid = "Voimansiirtoneste",
                tyres = "Renkaat",
                vehicleClass_0 = "Kompaktit",
                vehicleClass_1 = "Sedanit",
                vehicleClass_10 = "Teollinen",
                vehicleClass_11 = "Huolto",
                vehicleClass_12 = "Pakettiautot",
                vehicleClass_13 = "Pyörät",
                vehicleClass_14 = "Veneet",
                vehicleClass_15 = "Helikopterit",
                vehicleClass_16 = "Lentokoneet",
                vehicleClass_17 = "Huolto",
                vehicleClass_18 = "Hätä",
                vehicleClass_19 = "Sotilasvoimat",
                vehicleClass_2 = "Maasturit",
                vehicleClass_20 = "Kaupallinen",
                vehicleClass_21 = "Junat",
                vehicleClass_22 = "Avoin pyörä",
                vehicleClass_3 = "Kytkimet",
                vehicleClass_4 = "Lihakset",
                vehicleClass_5 = "Urheiluklassikoita",
                vehicleClass_6 = "Urheilu",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Moottoripyörät",
                vehicleClass_9 = "Maastoliikenne",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Pois käytöstä",
                        [1] = "GTA Standardi",
                        [2] = "Katukäytön pakoputken paukkeet",
                        [3] = "Kilpa-ajon anti-lag",
                        [4] = "Rallin anti-lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Automaattisia vaaroja",
                    values = {
                        [0] = "Pois",
                        [1] = "Päällä",
                    },
                },
                electronic_brake_lights = {
                    label = "Jarruvalot",
                    values = {
                        [0] = "Normaali",
                        [1] = "Hätävilkutus",
                        [2] = "Pois",
                    },
                },
                electronic_engine_tune = {
                    label = "Moottoriohjelmistot",
                    values = {
                        [0] = "Varasto",
                        [1] = "Vaihe 1",
                        [2] = "Vaihe 2",
                        [3] = "Vaihe 3",
                        [4] = "Vaihe 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Ajovalon kirkkaus",
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
                    label = "Korkeat kynnykset torvella",
                    values = {
                        [0] = "Pois",
                        [1] = "Päällä",
                    },
                },
                electronic_idle_rpm = {
                    label = "Joutokäynti RPM",
                    values = {
                        [0] = "Varasto",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Sisustusvalo",
                    values = {
                        [0] = "Normaali",
                        [1] = "Punainen",
                    },
                },
                electronic_mood_color = {
                    label = "Mielialan väri",
                    values = {
                        [0] = "Pois",
                        [1] = "Punainen",
                        [10] = "Kalkki",
                        [11] = "Turkoosi",
                        [12] = "Indigo",
                        [13] = "Valkoinen",
                        [14] = "Lämmin valkoinen",
                        [15] = "Kylmä valkoinen",
                        [16] = "Amber",
                        [2] = "Sininen",
                        [3] = "Vihreä",
                        [4] = "Syan",
                        [5] = "Magenta",
                        [6] = "Keltainen",
                        [7] = "Oranssi",
                        [8] = "Violetti",
                        [9] = "Vaaleanpunainen",
                    },
                },
                electronic_mood_intensity = {
                    label = "Mielialan valovoima",
                    values = {
                        [0] = "Dim",
                        [1] = "Normaali",
                        [2] = "Kirkas",
                    },
                },
                electronic_radio_power = {
                    label = "Radiovoima",
                    values = {
                        [0] = "Pois",
                        [1] = "Päällä",
                    },
                },
                electronic_throttle_response = {
                    label = "Iskureaktio",
                    values = {
                        [0] = "Lisää vetovoimaa",
                        [1] = "Aggressiivinen",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Keulimisasetus",
                    values = {
                        [0] = "Pois",
                        [1] = "Pehmeä",
                        [2] = "Voimakkuutta",
                    },
                },
            },
            vehicleClassLabel = "Luokka {id} ({name})",
        },
    },
}
