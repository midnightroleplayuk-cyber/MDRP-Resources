JobConfigLocales["sky_jobcreator:fi"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Asemat", entryLabel = "Asema", entryPluralLabel = "Asemat" } },
            jobDocuments = {
                title = "Asiakirjarekisteri",
                description = "Lue ja tulosta tämän työn asiakirjoja.",
                templates = "Pohjat",
                hint = "Käytä kentissä {{CUSTOMER}}. {{AUTHOR}}, {{JOB}} ja {{DATE}} täytetään automaattisesti.",
                key = "Tekninen avain",
                label = "Pohja",
                body = "Pohjan teksti",
                active = "Aktiivinen",
                enabled = "Asiakirjarekisteri",
            },
            configs = {
                sky_jobscreator = { title = "ammatteja Luoja", subtitle = "Hallitse töitä, arvoja ja uusien merkintöjen oletuksia." },
                sky_jobscreator_gangs = { title = "Jengiluoja", subtitle = "Hallitse alkuperäisiä jengejä ja niiden arvoja." },
            },
            extensions = {
                billingSettings = { label = "Laskutus", description = "Salli tämän työn lähettää uusia laskuja. Nykyiset laskut säilyvät saatavilla." },
                billingPrices = { label = "Laskuluettelo", description = "Tämän työn laskuissa käytettävät syyt ja hinnat.", itemLabel = "Laskurivi" },
            },
            billingFields = {
                enabled = "Lähetä laskuja", reason = "Syyn tunniste", label = "Näyttönimi", amount = "Summa",
            },
            settingSections = {
                creatorDefaults = "Uudet työt",
                creatorGrades = "Oletusarvot",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Työn oletustyyppi",
                    description = "Uusien QBCore/Qbox-töiden luokitus, esimerkiksi civ, police tai ems.",
                },
                creatorDefaultDuty = {
                    label = "Aloita työvuorossa",
                    description = "Uusien QBCore/Qbox-töiden alkuperäinen työvuorotila.",
                },
                creatorOffDutyPay = {
                    label = "Palkka työvuoron ulkopuolella",
                    description = "Uusien QBCore/Qbox-töiden alkuperäinen palkkasääntö työvuoron ulkopuolella.",
                },
                creatorInitialGradeName = {
                    label = "Arvon tekninen nimi",
                    description = "Arvon 0 oletusarvoinen sisäinen nimi. Käytä pieniä ASCII-kirjaimia, numeroita ja alaviivoja. Nimi boss on varattu arvolle 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Arvon näyttönimi",
                    description = "Uuden työn tai jengin ensimmäisen arvon oletusnimi.",
                },
                creatorInitialGradeSalary = {
                    label = "Aloituspalkka",
                    description = "Uuden työn arvojen oletuspalkka. Jengit eivät saa palkkaa.",
                },
                creatorInitialGradeBoss = {
                    label = "Johtajan oikeudet",
                    description = "Uusien QBCore/Qbox-töiden ja jengien arvon 1 alkuperäinen johtajaoikeus.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Työn tilin käyttöoikeus",
                    description = "Uusien QBCore/Qbox-töiden arvon 1 alkuperäinen pankkioikeus. Jengit eivät käytä tätä oikeutta.",
                },
            },
        },
    },
}

