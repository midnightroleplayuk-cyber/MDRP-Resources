JobConfigLocales["sky_jobcreator:it"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stazioni", entryLabel = "Stazione", entryPluralLabel = "Stazioni" } },
            jobDocuments = {
                title = "Registro documenti",
                description = "Leggere e stampare i documenti di questo lavoro.",
                templates = "Modelli",
                hint = "Usa {{CUSTOMER}} per i campi. {{AUTHOR}}, {{JOB}} e {{DATE}} vengono compilati automaticamente.",
                key = "Chiave tecnica",
                label = "Modello",
                body = "Testo del modello",
                active = "Attivo",
                enabled = "Registro documenti",
            },
            configs = {
                sky_jobscreator = { title = "Creatore di professioni", subtitle = "Gestisci lavori, gradi e valori predefiniti delle nuove voci." },
                sky_jobscreator_gangs = { title = "Creatore di gang", subtitle = "Gestisci gang native e relativi gradi." },
            },
            extensions = {
                billingSettings = { label = "Fatturazione", description = "Consenti a questo lavoro di emettere nuove fatture. Le fatture esistenti restano disponibili." },
                billingPrices = { label = "Catalogo fatture", description = "Motivi e prezzi delle fatture di questo lavoro.", itemLabel = "Voce della fattura" },
            },
            billingFields = {
                enabled = "Emetti fatture", reason = "Identificatore del motivo", label = "Nome visualizzato", amount = "Importo",
            },
            settingSections = {
                creatorDefaults = "Nuovi lavori",
                creatorGrades = "Gradi predefiniti",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Tipo di lavoro predefinito",
                    description = "Classificazione del framework per nuovi lavori QBCore/Qbox, ad esempio civ, police o ems.",
                },
                creatorDefaultDuty = {
                    label = "Inizia in servizio",
                    description = "Stato di servizio iniziale dei nuovi lavori QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Stipendio fuori servizio",
                    description = "Regola iniziale di pagamento fuori servizio dei nuovi lavori QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Nome tecnico del grado",
                    description = "Nome interno predefinito del grado 0. Usa lettere minuscole senza accenti, numeri e trattini bassi. Il nome boss è riservato al grado 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Nome visualizzato del grado",
                    description = "Nome visualizzato predefinito del primo grado di un nuovo lavoro o gang.",
                },
                creatorInitialGradeSalary = {
                    label = "Stipendio iniziale",
                    description = "Stipendio predefinito per i gradi di un nuovo lavoro. Le gang non ricevono uno stipendio.",
                },
                creatorInitialGradeBoss = {
                    label = "Accesso da capo",
                    description = "Permesso iniziale da capo per il grado 1 di nuovi lavori e gang QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Accesso al conto del lavoro",
                    description = "Autorizzazione bancaria iniziale del grado 1 dei nuovi lavori QBCore/Qbox. Le gang non usano questo permesso.",
                },
            },
        },
    },
}

