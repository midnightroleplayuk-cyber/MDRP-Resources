JobConfigLocales["sky_jobcreator:ru"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "Станции", entryLabel = "Станция", entryPluralLabel = "Станции" } },
            jobDocuments = {
                title = "Реестр документов",
                description = "Чтение и печать документов этой работы.",
                templates = "Шаблоны",
                hint = "Для полей используйте {{CUSTOMER}}. {{AUTHOR}}, {{JOB}} и {{DATE}} заполняются автоматически.",
                key = "Технический ключ",
                label = "Шаблон",
                body = "Текст шаблона",
                active = "Активен",
                enabled = "Реестр документов",
            },
            configs = {
                sky_jobscreator = { title = "Творец", subtitle = "Управляйте работами, рангами и значениями по умолчанию для новых записей." },
                sky_jobscreator_gangs = { title = "Создатель банды", subtitle = "Управляйте нативными бандами и их рангами." },
            },
            extensions = {
                billingSettings = { label = "Счета", description = "Разрешить этой работе выставлять новые счета. Существующие счета остаются доступными." },
                billingPrices = { label = "Каталог счетов", description = "Причины и цены для счетов этой работы.", itemLabel = "Позиция счёта" },
            },
            billingFields = {
                enabled = "Выставлять счета", reason = "Код причины", label = "Отображаемое имя", amount = "Сумма",
            },
            settingSections = {
                creatorDefaults = "Новые работы",
                creatorGrades = "Стандартные ранги",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "Тип работы по умолчанию",
                    description = "Классификация фреймворка для новых работ QBCore/Qbox, например civ, police или ems.",
                },
                creatorDefaultDuty = {
                    label = "Начинать на службе",
                    description = "Начальное состояние службы для новых работ QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "Зарплата вне службы",
                    description = "Начальное правило выплаты зарплаты вне службы для новых работ QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "Техническое имя ранга",
                    description = "Внутреннее имя ранга 0 по умолчанию. Используйте строчные латинские буквы, цифры и подчёркивания. Имя boss зарезервировано для ранга 1.",
                },
                creatorInitialGradeLabel = {
                    label = "Отображаемое имя ранга",
                    description = "Отображаемое имя первого ранга новой работы или банды по умолчанию.",
                },
                creatorInitialGradeSalary = {
                    label = "Начальная зарплата",
                    description = "Зарплата по умолчанию для рангов новой работы. Банды не получают зарплату.",
                },
                creatorInitialGradeBoss = {
                    label = "Права руководителя",
                    description = "Начальный флаг руководителя для ранга 1 новых работ и банд QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "Доступ к счёту работы",
                    description = "Начальные банковские права ранга 1 новых работ QBCore/Qbox. Банды не используют эти права.",
                },
            },
        },
    },
}

