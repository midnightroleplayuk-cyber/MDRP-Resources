JobConfigLocales["sky_jobcreator:ar"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "المحطات", entryLabel = "محطة", entryPluralLabel = "المحطات" } },
            jobDocuments = {
                title = "سجل المستندات",
                description = "قراءة وطباعة مستندات هذه الوظيفة.",
                templates = "القوالب",
                hint = "استخدم {{CUSTOMER}} لحقول الإدخال. يتم ملء {{AUTHOR}} و{{JOB}} و{{DATE}} تلقائيًا.",
                key = "المعرّف التقني",
                label = "القالب",
                body = "نص القالب",
                active = "نشط",
                enabled = "سجل المستندات",
            },
            configs = {
                sky_jobscreator = { title = "المهن الخالق", subtitle = "إدارة الوظائف والرتب والإعدادات الافتراضية للإدخالات الجديدة." },
                sky_jobscreator_gangs = { title = "عصابة الخالق", subtitle = "إدارة العصابات الأصلية ورتبها." },
            },
            extensions = {
                billingSettings = { label = "الفواتير", description = "السماح لهذه الوظيفة بإصدار فواتير جديدة. تظل الفواتير الحالية متاحة." },
                billingPrices = { label = "كتالوج الفواتير", description = "أسباب وأسعار الفواتير لهذه الوظيفة.", itemLabel = "بند فاتورة" },
            },
            billingFields = {
                enabled = "إصدار الفواتير", reason = "معرّف السبب", label = "اسم العرض", amount = "المبلغ",
            },
            settingSections = {
                creatorDefaults = "الوظائف الجديدة",
                creatorGrades = "الرتب الافتراضية",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "نوع الوظيفة الافتراضي",
                    description = "تصنيف الإطار للوظائف الجديدة في QBCore/Qbox، مثل civ أو police أو ems.",
                },
                creatorDefaultDuty = {
                    label = "البدء أثناء الخدمة",
                    description = "حالة الخدمة الأولية للوظائف الجديدة في QBCore/Qbox.",
                },
                creatorOffDutyPay = {
                    label = "راتب خارج الخدمة",
                    description = "قاعدة دفع الراتب خارج الخدمة للوظائف الجديدة في QBCore/Qbox.",
                },
                creatorInitialGradeName = {
                    label = "اسم الرتبة التقني",
                    description = "الاسم الداخلي الافتراضي للرتبة 0. استخدم أحرفًا إنجليزية صغيرة وأرقامًا وشرطات سفلية. الاسم boss محجوز للرتبة 1.",
                },
                creatorInitialGradeLabel = {
                    label = "اسم عرض الرتبة",
                    description = "اسم العرض الافتراضي لأول رتبة في وظيفة أو عصابة جديدة.",
                },
                creatorInitialGradeSalary = {
                    label = "الراتب الأولي",
                    description = "الراتب الافتراضي لرتب الوظيفة الجديدة. لا تحصل العصابات على راتب.",
                },
                creatorInitialGradeBoss = {
                    label = "صلاحية المدير",
                    description = "صلاحية المدير الأولية للرتبة 1 في الوظائف والعصابات الجديدة في QBCore/Qbox.",
                },
                creatorInitialGradeBankAuth = {
                    label = "صلاحية حساب الوظيفة",
                    description = "صلاحية الحساب الأولية للرتبة 1 في وظائف QBCore/Qbox الجديدة. لا تستخدم العصابات هذه الصلاحية.",
                },
            },
        },
    },
}

