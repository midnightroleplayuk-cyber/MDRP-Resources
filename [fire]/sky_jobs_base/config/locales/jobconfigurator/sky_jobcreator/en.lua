JobConfigLocales["sky_jobcreator:en"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Stations", entryLabel = "Station", entryPluralLabel = "Stations" } },
            jobDocuments = {
                title = "Document registry",
                description = "Read and print this job’s documents.",
                templates = "Templates",
                hint = "Use {{CUSTOMER}} for input fields. {{AUTHOR}}, {{JOB}} and {{DATE}} are filled automatically.",
                key = "Technical key",
                label = "Template",
                body = "Template text",
                active = "Active",
                enabled = "Document registry",
            },
            configs = {
                sky_jobscreator = { title = "Jobs Creator", subtitle = "Manage jobs, ranks and creation defaults." },
                sky_jobscreator_gangs = { title = "Gang Creator", subtitle = "Manage native gangs and ranks." },
            },
            extensions = {
                billingSettings = { label = "Billing", description = "Allow this job to issue new invoices. Existing invoices remain available." },
                billingPrices = { label = "Invoice catalogue", description = "Reasons and prices used when issuing invoices for this job.", itemLabel = "Invoice item" },
            },
            billingFields = {
                enabled = "Issue invoices", reason = "Reason key", label = "Display name", amount = "Amount",
            },
            settingSections = {
                creatorDefaults = "New jobs",
                creatorGrades = "Default grades",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Default job classification",
                    description = "Framework classification for new QBCore/Qbox jobs, for example civ, police or ems.",
                },
                creatorDefaultDuty = {
                    label = "Start on duty",
                    description = "Default for new QBCore/Qbox jobs: players start on duty when assigned the job. On login, it applies only with ForceJobDefaultDutyAtLogin enabled. The separate off-duty job is configured independently.",
                },
                creatorOffDutyPay = {
                    label = "Pay while off duty",
                    description = "Initial framework payroll rule for new QBCore/Qbox jobs.",
                },
                creatorInitialGradeName = {
                    label = "Grade name",
                    description = "Default internal name of rank 0. Use lowercase letters, numbers and underscores. The name boss is reserved for grade 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Grade label",
                    description = "Default label for grade 0 of a new job or gang.",
                },
                creatorInitialGradeSalary = {
                    label = "Initial salary",
                    description = "Default salary for new job grades. Gangs receive no salary.",
                },
                creatorInitialGradeBoss = {
                    label = "Boss access",
                    description = "Initial boss flag for rank 1 of new QBCore/Qbox jobs and gangs.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Society bank access",
                    description = "Initial bank authorization for rank 1 of new QBCore/Qbox jobs. Gangs do not use this job flag.",
                },
            },
        },
    },
}

