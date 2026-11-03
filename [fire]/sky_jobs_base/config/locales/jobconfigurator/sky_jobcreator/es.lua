JobConfigLocales["sky_jobcreator:es"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Estaciones", entryLabel = "Estación", entryPluralLabel = "Estaciones" } },
            jobDocuments = {
                title = "Registro de documentos",
                description = "Leer e imprimir los documentos de este trabajo.",
                templates = "Plantillas",
                hint = "Usa {{CUSTOMER}} para los campos. {{AUTHOR}}, {{JOB}} y {{DATE}} se rellenan automáticamente.",
                key = "Clave técnica",
                label = "Plantilla",
                body = "Texto de la plantilla",
                active = "Activa",
                enabled = "Registro de documentos",
            },
            configs = {
                sky_jobscreator = { title = "las profesiones Creador", subtitle = "Gestiona trabajos, rangos y valores predeterminados para nuevas entradas." },
                sky_jobscreator_gangs = { title = "Creador de pandillas", subtitle = "Gestiona bandas nativas y sus rangos." },
            },
            extensions = {
                billingSettings = { label = "Facturación", description = "Permitir que este trabajo emita nuevas facturas. Las facturas existentes siguen disponibles." },
                billingPrices = { label = "Catálogo de facturas", description = "Motivos y precios para las facturas de este trabajo.", itemLabel = "Concepto de factura" },
            },
            billingFields = {
                enabled = "Emitir facturas", reason = "Identificador del motivo", label = "Nombre visible", amount = "Importe",
            },
            settingSections = {
                creatorDefaults = "Nuevos trabajos",
                creatorGrades = "Rangos predeterminados",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Tipo de trabajo predeterminado",
                    description = "Clasificación del framework para nuevos trabajos QBCore/Qbox, por ejemplo civ, police o ems.",
                },
                creatorDefaultDuty = {
                    label = "Empezar de servicio",
                    description = "Estado de servicio inicial de los nuevos trabajos QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Pagar fuera de servicio",
                    description = "Regla salarial inicial fuera de servicio para nuevos trabajos QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Nombre técnico del rango",
                    description = "Nombre interno predeterminado del rango 0. Usa letras minúsculas sin acentos, números y guiones bajos. El nombre boss está reservado para el rango 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Nombre visible del rango",
                    description = "Nombre visible predeterminado del primer rango de un trabajo o banda nuevos.",
                },
                creatorInitialGradeSalary = {
                    label = "Salario inicial",
                    description = "Salario predeterminado para los rangos de un nuevo trabajo. Las bandas no reciben salario.",
                },
                creatorInitialGradeBoss = {
                    label = "Acceso de jefe",
                    description = "Permiso inicial de jefe para el rango 1 de nuevos trabajos y bandas QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Acceso a la cuenta del trabajo",
                    description = "Permiso bancario inicial del rango 1 de nuevos trabajos QBCore/Qbox. Las bandas no usan este permiso.",
                },
            },
        },
    },
}

