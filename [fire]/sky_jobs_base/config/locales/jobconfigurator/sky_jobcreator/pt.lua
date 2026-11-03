JobConfigLocales["sky_jobcreator:pt"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Estações", entryLabel = "Estação", entryPluralLabel = "Estações" } },
            jobDocuments = {
                title = "Registo de documentos",
                description = "Ler e imprimir os documentos deste emprego.",
                templates = "Modelos",
                hint = "Use {{CUSTOMER}} para campos. {{AUTHOR}}, {{JOB}} e {{DATE}} são preenchidos automaticamente.",
                key = "Chave técnica",
                label = "Modelo",
                body = "Texto do modelo",
                active = "Ativo",
                enabled = "Registo de documentos",
            },
            configs = {
                sky_jobscreator = { title = "Profissões Criador", subtitle = "Gerencie empregos, cargos e valores padrão para novos registros." },
                sky_jobscreator_gangs = { title = "Criador de gangues", subtitle = "Gerencie gangues nativas e seus cargos." },
            },
            extensions = {
                billingSettings = { label = "Faturação", description = "Permitir que este trabalho emita novas faturas. As faturas existentes continuam disponíveis." },
                billingPrices = { label = "Catálogo de faturas", description = "Motivos e preços das faturas deste trabalho.", itemLabel = "Item da fatura" },
            },
            billingFields = {
                enabled = "Emitir faturas", reason = "Identificador do motivo", label = "Nome apresentado", amount = "Valor",
            },
            settingSections = {
                creatorDefaults = "Novos empregos",
                creatorGrades = "Patentes padrão",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Tipo de emprego padrão",
                    description = "Classificação do framework para novos empregos QBCore/Qbox, por exemplo civ, police ou ems.",
                },
                creatorDefaultDuty = {
                    label = "Começar em serviço",
                    description = "Estado de serviço inicial dos novos empregos QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Salário fora de serviço",
                    description = "Regra salarial inicial fora de serviço para novos empregos QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Nome técnico do cargo",
                    description = "Nome interno padrão do cargo 0. Use letras minúsculas sem acentos, números e sublinhados. O nome boss está reservado para o nível 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Nome exibido do cargo",
                    description = "Nome exibido padrão do primeiro cargo de um novo emprego ou gangue.",
                },
                creatorInitialGradeSalary = {
                    label = "Salário inicial",
                    description = "Salário padrão para as patentes de um novo emprego. Gangues não recebem salário.",
                },
                creatorInitialGradeBoss = {
                    label = "Acesso de chefe",
                    description = "Permissão inicial de chefe para o cargo 1 de novos empregos e gangues QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Acesso à conta do emprego",
                    description = "Permissão bancária inicial do cargo 1 de novos empregos QBCore/Qbox. Gangues não usam esta permissão.",
                },
            },
        },
    },
}

