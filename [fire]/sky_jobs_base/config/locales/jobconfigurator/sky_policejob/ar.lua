JobConfigLocales["sky_policejob:ar"] = {
    JobConfiguratorComingSoon = "منظم هذه الوظيفة قادم قريباً.",
    JobConfiguratorNoPermission = "ليس لديك صلاحية لاستخدام هذا الأمر.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "تهيئة أقسام الشرطة والمتاجر والدعامات والمركبات والمحطات وإعدادات الميزات الأساسية.",
                    title = "وظائف الشرطة",
                },
            },
            dispatchActions = {
                addChannel = "إضافة قناة راديو",
                addKeyword = "إضافة كلمة مفتاحية",
                addPoi = "إضافة نقطة اهتمام",
                addReporter = "إضافة مبلّغ",
                addStatus = "إضافة حالة FMS",
                addVehicle = "إضافة وحدة افتراضية",
                addVehicleType = "إضافة نوع وحدة",
                currentLocation = "استخدم الموقع الحالي",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "يقوم فورًا بتعيين الوحدات المطابقة المتاحة عند إنشاء حادثة.",
                available = "قد يتم اقتراح الوحدات في هذه الحالة وتعيينها لحادث جديد.",
                averageResponseSpeedKmh = "لحساب تقدير الوصول المعروض من مسافة الخط المستقيم.",
                callsign = "تظهر إشارة نداء الراديو الفريدة عندما يقوم اللاعبون بتوظيف هذه الوحدة الافتراضية.",
                centerEnabled = "يسمح للأعضاء المناوبين المعتمدين بتوظيف مركز إرسال.",
                channelId = "معرف قناة الراديو لـ PMA Voice وSaltyChat وYACA. تظل المعرفات الرقمية مثل 2500 دون تغيير؛ يقوم PMA Voice بتعيين معرفات نصية إلى رقم ثابت.",
                channelLabel = "يظهر اسم القناة المقروء للمرسلين والوحدات.",
                crewCapacity = "أقصى عدد من الأفراد الذين يمكنهم شغل الوحدة. استخدم 0 لطاقم غير محدود.",
                defaultChannel = "ينضم المرسلون إلى هذه القناة عند بدء مناوبتهم. تنضم الوحدات يدويًا من علامة التبويب \"الراديو\". حدد لا شيء لاستخدام الإعداد الافتراضي لمجموعة المهام.",
                emergencyAppEnabled = "يجعل هذه الوظيفة قابلة للتحديد كخدمة عامة في تطبيق هاتف الطوارئ.",
                enabled = "يجعل هذه الوظيفة متاحة لتطبيق Dispatch والحوادث المشتركة بين الوظائف.",
                icon = "حدد الرمز الموضح لفئة الوحدة هذه في تطبيق Dispatch.",
                incidentAssessmentEnabled = "يعرض الأسئلة الطبية وتقييم المخاطر في تناول الحادث بالكامل.",
                jobs = "أسماء الوظائف الإضافية التي تتلقى حوادث باستخدام هذه الكلمة الأساسية.",
                joinLocked = "يمنع أفرادًا إضافيين من الانضمام بعد شغل الوحدة.",
                minimumCrew = "الحد الأدنى لعدد الأفراد في الوحدات المختارة لخطة الاستجابة.",
                noUnitFallback = "بدون مركز أو وحدة عاملة، يرسل إشعار Sky إلى جميع الأعضاء المناوبين.",
                poiId = "معرّف تقني ثابت يمكن لملفات المحطات الرجوع إليه حتى بعد تغيير اسم نقطة الاهتمام.",
                radius = "أقصى مسافة بالأمتار يمكن من خلالها سماع إعلان المحطة.",
                readyStatusCode = "حالة FMS التي تُطبّق عندما يصبح المورد جاهزًا للتوجيه.",
                requirements = "طلب الاستجابة كأزواج TYPE:COUNT، على سبيل المثال PATROL:2،CRIME:1.",
                resourceType = "يصنّف المورد التشغيلي لاستخدامه في مرشحات مركز التوجيه والتنسيق.",
                respondingStatusCode = "حالة FMS التي تُطبّق عندما يستجيب المورد لبلاغ.",
                shortLabel = "اسم مختصر اختياري يظهر على أزرار ذاكرة قنوات الراديو الستة.",
                stationId = "يربط هذه الوحدة بمحطة مضبوطة في ملف مركز التوجيه.",
                statusCode = "تظهر حالة FMS الرقمية على الراديو المحمول باليد.",
                statusLabel = "معنى حالة FMS للمرسلين والوحدات.",
                unitId = "معرّف تقني ثابت يحافظ على الوحدة حتى عند تغيير نداء الراديو.",
                vehicleType = "يجب أن يتطابق مع رمز نوع السيارة الذي تم تكوينه في القسم الفرعي السابق.",
                vehicleTypeCode = "رمز الوحدة القصير المستخدم في متطلبات الاستجابة، على سبيل المثال PATROL أو CRIME أو EMS أو RESCUE.",
                vehicleTypeLabel = "الاسم المقروء لفئة الوحدة هذه.",
            },
            dispatchFields = {
                address = "العنوان",
                autoAlarm = "إنذار تلقائي",
                available = "متاح للإرسال",
                averageResponseSpeedKmh = "سرعة الاستجابة المقدرة (كم/ساعة)",
                callsign = "إشارة النداء",
                category = "الفئة",
                centerEnabled = "تمكين مركز الإرسال",
                channelId = "معرف القناة",
                code = "الكود",
                crewCapacity = "سعة الطاقم",
                defaultChannel = "قناة الراديو الافتراضية",
                emergencyAppEnabled = "عرض في تطبيق الطوارئ",
                enabled = "تمكين الإرسال",
                icon = "أيقونة",
                incidentAssessmentEnabled = "تمكين تقييم الطوارئ",
                jobs = "المهام المستهدفة (مفصولة بفواصل)",
                joinLocked = "قفل انضمام الطاقم",
                keywordCode = "رمز الكلمة الرئيسية",
                label = "التسمية",
                minimumCrew = "الحد الأدنى للطاقم",
                name = "الاسم",
                noUnitFallback = "قم بإخطار الموظفين المناوبين بدون وحدات",
                noneChannel = "لا يوجد / المجموعة الافتراضية",
                note = "ملاحظة",
                phone = "الهاتف",
                poiId = "معرّف نقطة الاهتمام الثابت",
                radius = "نطاق الإعلان",
                readyStatusCode = "رمز حالة الجاهزية",
                requirements = "الوحدات المطلوبة (على سبيل المثال PATROL:2,CRIME:1)",
                resourceType = "نوع المورد",
                respondingStatusCode = "رمز حالة الاستجابة",
                shortLabel = "اسم ذاكرة الراديو",
                stationId = "معرّف المحطة",
                type = "النوع",
                unitId = "معرّف الوحدة الثابت",
                vehicleType = "نوع وحدة الاستجابة",
                radioButton = "زر زر",
                radioButtonAction = "زر العمل",
                radioButtonStatus = "FMS الحالة",
            },
            dispatchIconOptions = {
                crime = "وحدة الجريمة",
                emergency = "وحدة الطوارئ",
                ems = "وحدة EMS",
                fire = "وحدة الإطفاء",
                heavy = "الوحدة الثقيلة",
                k9 = "وحدة K-9",
                medical = "الوحدة الطبية",
                patrol = "دورية",
                rescue = "وحدة الإنقاذ",
                service = "وحدة الخدمة",
                supervisor = "المشرف",
                tactical = "الوحدة التكتيكية",
            },
            dispatchNavigation = {
                active = "الإرسال نشط",
                description = "قم بتكوين مدخل الطوارئ والراديو والوحدات وخطط الاستجابة والمواقع وبيانات المراسل لهذه المهمة.",
                inactive = "تم تعطيل الإرسال",
                steps = {
                    accessText = "قم بتمكين الإرسال وتحديد ما إذا كانت هذه الوظيفة يمكنها توظيف مركز إرسال.",
                    accessTitle = "الوصول ومدخل الطوارئ",
                    fleetText = "تكوين القنوات ورموز حالة FMS وأنواع المركبات وإشارات الاتصال.",
                    fleetTitle = "الراديو والأسطول",
                    responseText = "أنهي بالكلمات الرئيسية ومتطلبات الاستجابة والنقاط المهمة.",
                    responseTitle = "خطط الاستجابة",
                },
                summary = {
                    channels = "قنوات الراديو",
                    plans = "خطط الاستجابة",
                    reporters = "المبلّغون المعروفون",
                    statuses = "متاح FMS",
                    units = "الوحدات الافتراضية",
                },
                title = "إرسال",
                warnings = {
                    channels = "لا توجد قنوات راديو صريحة؛ سيتم استخدام القناة الاحتياطية لمجموعة الوظائف.",
                    defaultChannel = "القناة الافتراضية المحددة لم تعد موجودة.",
                    disabled = "تم تعطيل الإرسال لهذه المهمة.",
                    statuses = "يجب أن تتوفر حالة FMS واحدة على الأقل حتى يمكن إنذار الوحدات.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "يحدد قنوات الراديو التي يمكن للوحدات ومراكز إرسال الموظفين الانضمام إليها.",
                dispatchKeywords = "يحدد الكلمات الرئيسية للحوادث، وأعداد المركبات المطلوبة، والمهام المشاركة، والإنذار التلقائي الاختياري.",
                dispatchPois = "يقوم بتخزين المحطات والمواقع المشتركة لنماذج الحوادث وإعلانات المحطات القائمة على الموقع.",
                dispatchReporters = "يدير أسماء المبلّغين وأرقام معاودة الاتصال وملاحظات مركز التوجيه الخاصة بالوظيفة.",
                dispatchStatusCodes = "يقوم بتكوين تسميات حالة FMS والحالات التي تعتبر متاحة للحوادث الجديدة.",
                dispatchVehicleTypes = "يحدد فئات الوحدات المستخدمة بواسطة خطط الاستجابة، مثل الدورية أو وحدة الجريمة أو EMS أو الإنقاذ.",
                dispatchVehicles = "يحدد مركبات الإرسال الافتراضية التي يمكن تجهيزها من أي مكان دون الحاجة إلى مركبة منشورة.",
                dispatchRadioButtons = "تعيين الإجراء المحدد مسبقًا مركزيًا لكل زر دالة فيزيائية.",
                dispatchRadioFmsKeys = "يعين حالة FMS لمفاتيح الأرقام الفعلية. لوحة المفاتيح ينفذ فقط FMS التغييرات.",
            },
            extensions = {
                caseNumbering = {
                    label = "أرقام القضايا",
                    description = "إعداد أرقام القضايا التلقائية لهذه الوظيفة.",
                    fields = {
                        prefix = {
                            label = "بادئة القضية",
                            description = "بادئة القضايا الجديدة، مثل LSPD أو LSCSD. حتى 16 حرفاً تُحوّل إلى أحرف كبيرة؛ يُستخدم CASE إذا تُرك الحقل فارغاً. تبقى الأرقام الحالية والمحددة يدوياً دون تغيير.",
                        },
                    },
                },
                dispatchReporters = "المبلّغون المعروفون",
                invalidSelection = "اختيار غير صالح: {value}",
                trainingSettings = {
                    description = "قم بتكوين الوصول إلى التدريب والتسجيل والموافقات وتخطيط الدورة التدريبية لهذه الوظيفة.",
                    label = "إعدادات التدريب",
                },
                dispatchChannels = "قنوات الراديو",
                dispatchKeywords = "الكلمات المفتاحية وخطط الاستجابة",
                dispatchPois = "POIs الإرسال",
                dispatchSettings = {
                    description = "تكوين وصول الإرسال ، ومدخول الطوارئ ، وقناة الراديو الافتراضية.",
                    label = "إعدادات الإرسالName",
                },
                dispatchStatusCodes = "رموز الحالة",
                dispatchVehicleTypes = "أنواع مركبات الإرسال",
                dispatchVehicles = "إرسال بيانات الأسطول",
                emptyDescription = "استخدم زر الإضافة أعلاه لإنشاء الإدخال الأول.",
                emptyTitle = "لم يتم تكوين أي شيء حتى الآن",
                dispatchRadioButtons = "أزرار وظيفة الراديو",
                dispatchRadioFmsKeys = "FMS تعيين مفتاح",
            },
            features = {
                billing = {
                    description = "تفعيل مسارات إصدار فواتير الشرطة.",
                    label = "الفواتير",
                },
                devices = {
                    description = "تفعيل أجهزة الإنفاذ القابلة للنشر.",
                    label = "كاميرات المراقبة وكاميرات السرعة",
                },
                evidence = {
                    description = "تفعيل تخزين الأدلة والأدلة الميدانية ومسارات الماسح الضوئي.",
                    label = "الأدلة",
                },
                impound = {
                    description = "تفعيل مسارات ساحة الحجز.",
                    label = "الحجز",
                },
                jail = {
                    description = "تفعيل إسناد الأحكام وأنشطة النزلاء.",
                    label = "السجن",
                },
                propPlacement = {
                    description = "تفعيل دعامات الشرطة القابلة للتهيئة وتجهيزات دعامات المركبات.",
                    label = "وضع الدعامات",
                },
                radial = {
                    description = "تفعيل إجراءات الشرطة الدائرية مثل الحجز وقفل العجلة.",
                    label = "إجراءات القائمة الدائرية",
                },
                restraints = {
                    description = "تفعيل الأصفاد والأربطة البلاستيكية وقيود الساقين وأكياس الرأس.",
                    label = "أدوات التقييد",
                },
                socialWork = {
                    description = "تفعيل إسناد العمل الاجتماعي وأنشطة المهام.",
                    label = "العمل الاجتماعي",
                },
                tablet = {
                    description = "تفعيل تطبيقات الجهاز اللوحي للشرطة المهيأة بواسطة هذا المورد.",
                    label = "الجهاز اللوحي للشرطة",
                },
                tracking = {
                    description = "تفعيل متتبعات GPS وأساور الكاحل.",
                    label = "التتبع",
                },
                vehicleRadar = {
                    description = "تفعيل رادار مركبة الدورية.",
                    label = "رادار المركبة",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "يتطلب عرض هذه الوظيفة في تطبيق الطوارئ تفعيل نظام الإرسال. فعّل نظام الإرسال أو أوقف عرض الوظيفة في تطبيق الطوارئ من إعدادات الإرسال.",
                dispatchJobNotCovered = "لا يغطي أي مركز إرسال مفعّل الوظيفة «{job}». في sky_jobs_base/config/config.lua، أضف «{job}» إلى coveredJobs في الملف التعريفي المناسب ضمن Config.Dispatch.centers، ثم أعد تشغيل sky_jobs_base. إعادة ضبط الإعدادات لا تغيّر هذا التعيين.",
                invalidDispatchChannels = "يجب أن تكون معرّفات قنوات الراديو فريدة وأن تحمل كل قناة اسمًا صالحًا.",
                invalidDispatchDefaultChannel = "قناة الراديو الافتراضية غير موجودة. اختر قناة موجودة أو «لا شيء» في إعدادات الإرسال.",
                invalidDispatchKeywords = "يجب أن تكون رموز خطط الاستجابة فريدة وأن تستخدم متطلبات صالحة بصيغة النوع:العدد.",
                invalidDispatchPois = "يجب أن تكون معرّفات نقاط الاهتمام وأسماؤها وإحداثياتها صالحة وفريدة.",
                invalidDispatchRadioButtons = "تحقق من أزرار وظائف الراديو: استخدم كل زر مدعوم مرة واحدة فقط، واختر إجراءً من قائمته.",
                invalidDispatchRadioFmsKeys = "تحقق من مفاتيح FMS للراديو: استخدم كل مفتاح (0-9 أو * أو #) مرة واحدة فقط، وعيّن له رمز حالة موجودًا أو اتركه دون تعيين.",
                invalidDispatchReadyStatus = "اختر رمز حالة الجاهزية في إعدادات الإرسال، على أن يكون محددًا كمتاح في قائمة رموز الحالة.",
                invalidDispatchReporters = "تتجاوز بيانات المبلّغين المعروفين العدد المسموح أو أطوال الحقول.",
                invalidDispatchRespondingStatus = "اختر رمز حالة التوجه إلى البلاغ في إعدادات الإرسال، على أن يكون محددًا كغير متاح في قائمة رموز الحالة.",
                invalidDispatchSettings = "اختر حالة جاهزية موجودة ومتاحة، وحالة استجابة غير متاحة، وقناة افتراضية صالحة.",
                invalidDispatchStatusCodes = "يجب أن تكون رموز FMS فريدة وأن تتوفر حالة واحدة على الأقل.",
                invalidDispatchVehicleTypes = "يجب أن تكون رموز أنواع وحدات الاستجابة فريدة ومكتملة.",
                invalidDispatchVehicles = "يجب أن تكون معرّفات الوحدات ونداءاتها فريدة وأن تكون مراجع النوع والمحطة صالحة.",
            },
            settingFields = {
                gangMinimumGrade = "الحد الأدنى للرتبة",
                gang = "عصابة",
                component = "المكون",
                description = "الوصف",
                fineAmount = "مبلغ الغرامة",
                itemName = "اسم العنصر",
                length = "الطول",
                max = "الحد الأقصى",
                maxOverKmh = "الحد الأقصى للتجاوز",
                min = "الحد الأدنى",
                minOverKmh = "الحد الأدنى للتجاوز",
                model = "نموذج الدعامة",
                propModel = "نموذج الدعامة",
                reason = "السبب",
                vehicleClass = "الفئة",
            },
            settingGroups = {
                access = {
                    label = "الصلاحية",
                },
                animation = {
                    label = "الحركة",
                },
                ankleMonitor = {
                    label = "سوار الكاحل",
                },
                ankleMonitorAccess = {
                    label = "صلاحية سوار الكاحل",
                },
                ankleMonitorPlacement = {
                    label = "وضع سوار الكاحل",
                },
                ankleMonitorZone = {
                    label = "منطقة سوار الكاحل",
                },
                ankleMonitorZoneVisual = {
                    label = "مظاهر منطقة سوار الكاحل",
                },
                assignment = {
                    label = "الإسناد",
                },
                blip = {
                    label = "علامة المحطة على الخريطة",
                },
                carry = {
                    label = "الحمل",
                },
                cctv = {
                    label = "كاميرات المراقبة",
                },
                cctvDurability = {
                    label = "متانة كاميرات المراقبة",
                },
                cctvPlacement = {
                    label = "وضع كاميرات المراقبة",
                },
                cctvRepair = {
                    label = "إصلاح كاميرات المراقبة",
                },
                cctvRepairAnimation = {
                    label = "حركة إصلاح كاميرات المراقبة",
                },
                clamp = {
                    label = "قفل العجلة",
                },
                clampWeld = {
                    label = "لحام قفل العجلة",
                },
                cleanup = {
                    label = "التنظيف",
                },
                collection = {
                    label = "الجمع",
                },
                controls = {
                    label = "عناصر التحكم",
                },
                creator = {
                    label = "المنشئ",
                },
                crimeSceneTape = {
                    label = "شريط مسرح الجريمة",
                },
                crimeSceneTapeAccess = {
                    label = "صلاحيات الشريط",
                },
                crimeSceneTapeInventory = {
                    label = "مخزون الشريط",
                },
                crimeSceneTapeLength = {
                    label = "طول الشريط",
                },
                crimeSceneTapePlacement = {
                    label = "وضع الشريط",
                },
                database = {
                    label = "قاعدة البيانات",
                },
                delivery = {
                    label = "التسليم",
                },
                detection = {
                    label = "الكشف",
                },
                dispatch = {
                    label = "الاستدعاء",
                },
                escape = {
                    label = "الهروب",
                },
                escort = {
                    label = "المرافقة",
                },
                evidenceStorage = {
                    label = "مخزن الأدلة",
                },
                fastLock = {
                    label = "القفل السريع التلقائي",
                },
                general = {
                    label = "عام",
                },
                gpsTracker = {
                    label = "متتبع GPS",
                },
                gpsTrackerAccess = {
                    label = "صلاحية متتبع GPS",
                },
                gpsTrackerPlacement = {
                    label = "وضع متتبع GPS",
                },
                gpsTrackerTiming = {
                    label = "توقيت متتبع GPS",
                },
                handcuffs = {
                    label = "الأصفاد",
                },
                handsUp = {
                    label = "رفع اليدين",
                },
                header = {
                    label = "الترويسة",
                },
                impound = {
                    label = "الحجز",
                },
                imprisonment = {
                    label = "السجن",
                },
                jailCanteenGeneral = {
                    label = "مقصف السجن",
                },
                jailCanteenPackage = {
                    label = "حزمة المقصف",
                },
                jailCarry = {
                    label = "وظيفة النقل",
                },
                jailCarryInspection = {
                    label = "فحص النقل",
                },
                jailCleaning = {
                    label = "وظيفة التنظيف",
                },
                jailCleaningIllegalFinds = {
                    label = "الاكتشافات الممنوعة",
                },
                jailCleaningOutline = {
                    label = "الخطوط التوضيحية للتنظيف",
                },
                jailDoctor = {
                    label = "طبيب السجن",
                },
                jailElectricalCodes = {
                    label = "رموز الكهرباء",
                },
                jailElectricalGeneral = {
                    label = "كهرباء السجن",
                },
                jailElectricalPenalties = {
                    label = "عقوبات الكهرباء",
                },
                jailElectricalRewards = {
                    label = "مكافآت الكهرباء",
                },
                jailInmatesAlcoholic = {
                    label = "نزيل مدمن كحول",
                },
                jailInmatesCodeList = {
                    label = "نزيل مخبر",
                },
                jailInmatesDrugDealer = {
                    label = "نزيل تاجر مخدرات",
                },
                jailInmatesWireCutter = {
                    label = "نزيل جالب الأدوات",
                },
                jailJobs = {
                    label = "وظائف السجن",
                },
                jailOutfitFemale = {
                    label = "زي الإناث",
                },
                jailOutfitMale = {
                    label = "زي الذكور",
                },
                keybinds = {
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                    label = "اختصارات المفاتيح",
                },
                keybindsHandcuff = {
                    label = "اختصار التكبيل",
                },
                keybindsUnhandcuff = {
                    label = "اختصار فك التكبيل",
                },
                marker = {
                    label = "العلامة",
                },
                markerColor = {
                    label = "لون العلامة",
                },
                mugshotAnimation = {
                    label = "حركة صورة الحجز",
                },
                mugshotBoard = {
                    label = "لوحة صورة الحجز",
                },
                mugshotCameraCoords = {
                    label = "موقع كاميرا صورة الحجز",
                },
                mugshotCameraRotation = {
                    label = "دوران كاميرا صورة الحجز",
                },
                mugshotGeneral = {
                    label = "صورة الحجز",
                },
                mugshotMetadata = {
                    label = "بيانات صورة الحجز الوصفية",
                },
                mugshotPosition = {
                    label = "موقع صورة الحجز",
                },
                mugshotTiming = {
                    label = "توقيت صورة الحجز",
                },
                officerDown = {
                    label = "ضابط مصاب",
                },
                outfit = {
                    label = "الزي",
                },
                overlay = {
                    label = "طبقة اللوحة",
                },
                payment = {
                    label = "الدفع",
                },
                paymentFlow = {
                    label = "مسار الدفع",
                },
                penalties = {
                    label = "العقوبات",
                },
                playerSearch = {
                    label = "تفتيش اللاعب",
                },
                playerSearchAnimation = {
                    label = "حركة تفتيش اللاعب",
                },
                props = {
                    label = "عناصر الدعامات",
                },
                reasons = {
                    label = "الأسباب",
                },
                release = {
                    label = "الإطلاق",
                },
                restore = {
                    label = "الاستعادة",
                },
                rules = {
                    label = "القواعد",
                },
                scan = {
                    label = "المسح",
                },
                scanner = {
                    label = "الماسح الضوئي",
                },
                sentence = {
                    label = "الحكم",
                },
                shotsFired = {
                    label = "إطلاق نار",
                },
                sound = {
                    label = "الصوت",
                },
                speedcam = {
                    label = "كاميرات السرعة",
                },
                speedcamBilling = {
                    label = "فوترة كاميرا السرعة",
                },
                speedcamDispatch = {
                    label = "استدعاء كاميرا السرعة",
                },
                speedcamDurability = {
                    label = "متانة كاميرا السرعة",
                },
                speedcamPlacement = {
                    label = "وضع كاميرا السرعة",
                },
                speedcamRepair = {
                    label = "إصلاح كاميرا السرعة",
                },
                speedcamRepairAnimation = {
                    label = "حركة إصلاح كاميرا السرعة",
                },
                speedcamTiming = {
                    label = "توقيت كاميرا السرعة",
                },
                speedcamVisual = {
                    label = "مظاهر كاميرا السرعة",
                },
                speedcams = {
                    label = "كاميرات السرعة",
                },
                storage = {
                    label = "التخزين",
                },
                subscription = {
                    label = "اشتراك التطبيق",
                },
                tasks = {
                    label = "المهام",
                },
                theme = {
                    label = "المظهر",
                },
                timing = {
                    label = "التوقيت",
                },
                warningUi = {
                    label = "واجهة التحذير",
                },
                world = {
                    label = "العالم",
                },
                zipties = {
                    label = "الأربطة البلاستيكية",
                },
                ziptiesCutter = {
                    label = "قاطعة الأربطة البلاستيكية",
                },
                cctvMotionDetection = {
                    label = "اكتشاف الحركة",
                },
                cctvMotionDispatch = {
                    label = "كشف الحركة الإرسال",
                },
                cctvMotionTiming = {
                    label = "توقيت كشف الحركة",
                },
                display = {
                    label = "العرض",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "التقارير",
                },
                speedcamAdvanced = {
                    label = "كاميرا متقدمة السرعة",
                },
                tackle = {
                    label = "طرح الشخص أرضًا",
                },
                vin = {
                    label = "VIN تحقق",
                },
            },
            settingSections = {
                radarGun = "مسدس الرادار",
                billing = "الفواتير",
                cctv = "كاميرات المراقبة",
                dispatch = "الاستدعاء",
                equipment = "المعدات",
                evidence = "الأدلة",
                impound = "الحجز",
                jail = "السجن",
                radar = "رادار المركبة",
                radial = "إجراءات القائمة الدائرية",
                restraints = "أدوات التقييد",
                socialWork = "العمل الاجتماعي",
                speedCamera = "كاميرا السرعة",
                spikeStrips = "مسامير تفجير الإطارات",
                stations = "المحطات",
                tablet = "تطبيقات الجهاز اللوحي",
                tracking = "التتبع",
                fakePlates = "لوحات وهمية",
                general = "عام",
            },
            settingSubsections = {
                app = "تطبيق كاميرا السرعة",
                apps = "التطبيقات",
                billing = "الفواتير",
                canteen = "مقصف السجن",
                dispatch = "الاستدعاء",
                durability = "المتانة",
                electrical = "كهرباء السجن",
                general = "عام",
                handcuffs = "الأصفاد والأربطة البلاستيكية",
                inmates = "نزلاء السجن",
                jobs = "وظائف السجن",
                keybinds = "اختصارات المفاتيح",
                motionDetection = "اكتشاف الحركة",
                mugshot = "صورة الحجز",
                placement = "الوضع",
                repair = "الإصلاح",
                timing = "التوقيت",
                visuals = "المظاهر البصرية",
            },
            settings = {
                radarGunClearKey = { label = "مسدس الرادار: مسح القراءة" },
                radarGunToggleUiKey = { label = "مسدس الرادار: تبديل الواجهة" },
                radarGunNoTargetHoldMs = { label = "مدة حفظ الهدف (مللي ثانية)" },
                radarGunMinimumReading = { label = "أدنى سرعة معروضة" },
                radarGunSpeedSmoothing = { label = "تنعيم السرعة (0–1)" },
                radarGunBeamRadius = { label = "نصف قطر الشعاع (م)" },
                radarGunRefreshRateMs = { label = "فاصل القياس (مللي ثانية)" },
                radarGunUseMph = { label = "استخدام MPH", description = "عرض قياسات مسدس الرادار بالميل في الساعة بدلاً من الكيلومتر في الساعة." },
                radarGunRange = { label = "نطاق القياس", description = "أقصى مسافة يمكن لمسدس الرادار عندها اكتشاف المركبات بالأمتار." },
                radarGunRequireOnDuty = { label = "يتطلب الخدمة", description = "اشتراط أن يكون الضابط في الخدمة قبل قياس سرعة المركبات بمسدس الرادار." },
                radarGunAllowedJobs = { label = "الوظائف أو المجموعات المسموح بها", description = "استخدم police لجميع وظائف الشرطة المضبوطة أو أسماء الوظائف مباشرة. القائمة الفارغة تلغي قيود الوظائف.", itemLabel = "الوظيفة أو المجموعة" },
                radarGunEnabled = { label = "مسدس الرادار", description = "تفعيل مسدس الرادار اليدوي SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "العصابات المسموحة",
                    description = "اختر الأسماء الداخلية للعصابات أو المنظمات المستقلة. تطابق الوظيفة أو العصابة يمنح الإذن أو الإعفاء. شرط الخدمة ينطبق على الوظائف فقط.",
                    itemLabel = "عصابة",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "الحد الأدنى لرتب العصابات",
                    description = "رتب عصابات دنيا اختيارية. القائمة الفارغة تسمح بكل الرتب. متطلبات العناصر تبقى سارية.",
                },

                speedCamProcessingMode = {
                    description = "اختر الخصم الفوري أو الدفع خلال المهلة المحددة أو مراجعة الضابط فقط.",
                    label = "وضع المعالجة",
                    options = {
                        instant = "خصم فوري",
                        later = "الدفع لاحقًا (افتراضي)",
                        review = "مراجعة الضابط فقط",
                    },
                },
                tabletRegistry = { label = "السجل", description = "تفعيل سجلات RP المخصصة في File Explorer. تظل ملفات المواطنين والمركبات متاحة بشكل منفصل." },
                tabletFiles = { label = "مستكشف الملفات", description = "يجمع سجلات الشرطة في مستكشف الملفات. تظهر مستندات وزارة العدل فقط عندما تكون مفعلة." },
                ankleMonitorAnimDurationMs = {
                    description = "المللي ثانية المستغرقة في تطبيق سوار الكاحل.",
                    label = "مدة التطبيق",
                },
                ankleMonitorAnimScenario = {
                    description = "السيناريو الذي يتم تشغيله أثناء تطبيق سوار الكاحل.",
                    label = "سيناريو التطبيق",
                },
                ankleMonitorAttachBone = {
                    description = "عظمة الشخصية المستخدمة لتثبيت دعامة سوار الكاحل.",
                    label = "عظمة التثبيت",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "إزالة عنصر سوار الكاحل بعد وضعه.",
                    label = "استهلاك سوار الكاحل",
                },
                ankleMonitorCutItem = {
                    description = "عنصر الحقيبة المستخدم لإزالة أسورة الكاحل.",
                    label = "عنصر القطع",
                },
                ankleMonitorEnabled = {
                    description = "تفعيل وضع أسورة الكاحل.",
                    label = "سوار الكاحل",
                },
                ankleMonitorItem = {
                    description = "عنصر الحقيبة المستخدم لوضع أسورة الكاحل.",
                    label = "عنصر سوار الكاحل",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "المللي ثانية بين تحديثات خريطة سوار الكاحل.",
                    label = "فاصل تحديث الخريطة",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "يحتفظ بأساور المراقبة في قاعدة البيانات عند قطع اتصال اللاعبين المراقبين لاستعادتها بعد إعادة الاتصال أو إعادة تشغيل الخادم.",
                    label = "الاحتفاظ بعد قطع الاتصال",
                },
                ankleMonitorPlaceDistance = {
                    description = "أقصى مسافة لوضع سوار الكاحل.",
                    label = "مسافة الوضع",
                },
                ankleMonitorPropModel = {
                    description = "نموذج الدعامة المستخدم لمظهر سوار الكاحل.",
                    label = "نموذج الدعامة",
                },
                ankleMonitorRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل استخدام أسورة الكاحل.",
                    label = "سوار الكاحل يتطلب الخدمة",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "يتطلب انتماء اللاعب إلى مجموعة الشرطة قبل استخدام أسورة الكاحل.",
                    label = "سوار الكاحل يتطلب وظيفة الشرطة",
                },
                ankleMonitorReturnOnRemove = {
                    description = "إعادة عنصر سوار الكاحل عند إزالته.",
                    label = "إعادة سوار الكاحل عند الإزالة",
                },
                ankleMonitorWarningSeconds = {
                    description = "وقت التحذير قبل إرسال استدعاء بخرق منطقة سوار الكاحل.",
                    label = "ثواني تحذير المنطقة",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "المللي ثانية بين صفيرات تحذير منطقة سوار الكاحل.",
                    label = "فاصل صفير المنطقة",
                },
                ankleMonitorZoneBeepSound = {
                    description = "اسم الصوت المستخدم لتحذيرات منطقة سوار الكاحل.",
                    label = "صوت الصفير",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "مجموعة الصوت المستخدمة لتحذيرات منطقة سوار الكاحل.",
                    label = "مجموعة صوت الصفير",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "قيمة الشفافية المستخدمة لعلامات منطقة سوار الكاحل.",
                    label = "شفافية العلامة",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "لون العلامة المستخدم عندما يكون الهدف داخل المنطقة المسموح بها.",
                    label = "لون العلامة المسموح",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "لون العلامة المستخدم عندما يغادر الهدف المنطقة المسموح بها.",
                    label = "لون العلامة المستبعد",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "المللي ثانية بين فحوصات منطقة سوار الكاحل.",
                    label = "فاصل فحص المنطقة",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "الثواني قبل إمكانية إرسال استدعاء آخر لمنطقة سوار الكاحل.",
                    label = "فترة انتظار استدعاء المنطقة",
                },
                ankleMonitorZoneEnabled = {
                    description = "تفعيل فحوصات منطقة سوار الكاحل.",
                    label = "مناطق سوار الكاحل",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "رمز العلامة المستخدم لعلامات منطقة سوار الكاحل.",
                    label = "رمز علامة المنطقة",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "نصف القطر المستخدم لخطوط منطقة سوار الكاحل التوضيحية.",
                    label = "نصف قطر الخط التوضيحي",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "حجم الخطوة المستخدم لخطوط منطقة سوار الكاحل التوضيحية.",
                    label = "خطوة الخط التوضيحي",
                },
                billingAccount = {
                    description = "الحساب الاحتياطي المستخدم عندما لا تملك الوظيفة حساب شركة مهيأ.",
                    label = "حساب الشركة الاحتياطي",
                },
                billingCloseOnSuccess = {
                    description = "إغلاق واجهة الفوترة بعد إصدار الفاتورة.",
                    label = "الإغلاق بعد النجاح",
                },
                billingCurrency = {
                    description = "مفتاح العملة المستخدم للفوترة. اتركه فارغاً لاستخدام العملة الافتراضية.",
                    label = "العملة",
                },
                billingCustomReasons = {
                    description = "السماح بأسباب فوترة مخصصة بدلاً من الاقتصار على الأسباب الجاهزة.",
                    label = "أسباب مخصصة",
                },
                billingDepositToSociety = {
                    description = "إيداع إيرادات الفوترة في حساب شركة الوظيفة.",
                    label = "الإيداع في حساب الشركة",
                },
                billingMaxReasonLength = {
                    description = "أقصى عدد أحرف لأسباب الفوترة المخصصة.",
                    label = "طول السبب",
                },
                billingMode = {
                    description = "اختر ما إذا كانت فواتير الشرطة تُخصم فوراً، أو تتطلب موافقة المواطن، أو تستخدم نظام فوترة الإطار.",
                    label = "وضع الفوترة",
                    options = {
                        consent = "الدفع أو الرفض",
                        framework = "فاتورة الإطار",
                        instant = "خصم فوري",
                    },
                },
                billingRange = {
                    description = "أقصى مسافة للهدف لإصدار فواتير الشرطة.",
                    label = "نطاق الفوترة",
                },
                billingReasonPresets = {
                    description = "أسباب الفوترة الجاهزة المعروضة في واجهة الفوترة.",
                    itemLabel = "السبب",
                    label = "الأسباب الجاهزة",
                },
                billingRefreshSeconds = {
                    description = "فاصل تحديث الهدف أثناء فتح واجهة الفوترة.",
                    label = "ثواني التحديث",
                },
                billingShowRecipientName = {
                    description = "إظهار اسم المواطن في معاينات المخالفات والإيصالات.",
                    label = "إظهار اسم المستلم",
                },
                carryAllowCarrierInVehicle = {
                    description = "السماح للحامل بدخول وقيادة مركبة دون إنزال اللاعب المحمول.",
                    label = "السماح للحامل بدخول المركبة",
                },
                carryAllowConscious = {
                    description = "السماح بحمل الأهداف الواعية.",
                    label = "حمل الأهداف الواعية",
                },
                carryAllowSprint = {
                    description = "السماح بالركض أثناء حمل لاعب آخر.",
                    label = "السماح بالركض أثناء الحمل",
                },
                carryEnabled = {
                    description = "تفعيل حمل اللاعبين.",
                    label = "الحمل",
                },
                carryMaxDistance = {
                    description = "أقصى مسافة لبدء حمل لاعب.",
                    label = "مسافة الحمل",
                },
                carryRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل بدء الحمل.",
                    label = "الحمل يتطلب الخدمة",
                },
                cctvDamageCooldownMs = {
                    description = "المللي ثانية قبل إمكانية تطبيق ضرر آخر على كاميرا المراقبة.",
                    label = "فترة انتظار الضرر",
                },
                cctvDamagePerHit = {
                    description = "ضرر المتانة المطبق على كاميرات المراقبة لكل إصابة.",
                    label = "الضرر لكل إصابة",
                },
                cctvDefaultName = {
                    description = "الاسم المعروض الافتراضي لكاميرات المراقبة المنشورة.",
                    label = "الاسم الافتراضي لكاميرا المراقبة",
                },
                cctvDefaultPitch = {
                    description = "ميلان الكاميرا الافتراضي لوضع كاميرا المراقبة.",
                    label = "الميلان الافتراضي",
                },
                cctvDisassembleDistance = {
                    description = "المسافة المستخدمة لتفكيك كاميرات المراقبة.",
                    label = "مسافة التفكيك",
                },
                cctvEnabled = {
                    description = "تفعيل وضع وبث كاميرات المراقبة.",
                    label = "كاميرات المراقبة",
                },
                cctvHealthDisplayDistance = {
                    description = "المسافة التي تُعرض عندها سلامة كاميرا المراقبة.",
                    label = "مسافة عرض السلامة",
                },
                cctvHealthDisplayDurationMs = {
                    description = "المللي ثانية التي تبقى فيها سلامة كاميرا المراقبة مرئية.",
                    label = "مدة عرض السلامة",
                },
                cctvHealthTextOffset = {
                    description = "الإزاحة الرأسية المستخدمة لنص سلامة كاميرا المراقبة.",
                    label = "إزاحة نص السلامة",
                },
                cctvHeightStep = {
                    description = "خطوة الارتفاع المستخدمة عند وضع كاميرات المراقبة.",
                    label = "خطوة الارتفاع",
                },
                cctvItem = {
                    description = "عنصر الحقيبة المستخدم لوضع كاميرات المراقبة.",
                    label = "عنصر كاميرا المراقبة",
                },
                cctvMaintenanceThreshold = {
                    description = "عتبة المتانة التي يُنصح عندها بصيانة كاميرا المراقبة.",
                    label = "عتبة الصيانة",
                },
                cctvMaxDurability = {
                    description = "أقصى متانة لكاميرا المراقبة.",
                    label = "متانة كاميرا المراقبة",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "عدد الثواني قبل أن تنشئ الكاميرا بلاغ حركة آخر.",
                    label = "مهلة البلاغ",
                },
                cctvMotionCheckIntervalMs = {
                    description = "المدة بالمللي ثانية بين عمليات فحص الحركة على العميل.",
                    label = "فاصل الفحص",
                },
                cctvMotionClientCooldownMs = {
                    description = "المدة بالمللي ثانية قبل أن يتمكن العميل من الإبلاغ عن الكاميرا نفسها مجددًا.",
                    label = "مهلة بلاغ العميل",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "تفعيل تنبيهات الحركة تلقائيًا لكاميرات المراقبة الجديدة.",
                    label = "تفعيل الكاميرات الجديدة افتراضيًا",
                },
                cctvMotionDetectionEnabled = {
                    description = "تفعيل بلاغات اكتشاف الحركة لكل كاميرا مراقبة.",
                    label = "تنبيهات اكتشاف الحركة",
                },
                cctvMotionDetectionRadius = {
                    description = "أقصى مسافة لاكتشاف الحركة بالمتر.",
                    label = "نطاق الاكتشاف",
                },
                cctvMotionFieldOfView = {
                    description = "زاوية مخروط اكتشاف الحركة بالدرجات.",
                    label = "زاوية الرؤية",
                },
                cctvMotionJobs = {
                    description = "أسماء الوظائف أو مجموعات الوظائف التي تستقبل بلاغات حركة كاميرات المراقبة.",
                    itemLabel = "وظيفة أو مجموعة",
                    label = "وظائف البلاغ",
                },
                cctvMotionMinimumSpeed = {
                    description = "السرعة الدنيا بالمتر في الثانية لاعتبار الكيان متحركًا.",
                    label = "الحد الأدنى لسرعة الحركة",
                },
                cctvMoveStep = {
                    description = "خطوة الحركة المستخدمة عند وضع كاميرات المراقبة.",
                    label = "خطوة الحركة",
                },
                cctvPropModel = {
                    description = "نموذج الدعامة المستخدم لكاميرات المراقبة المنشورة.",
                    label = "نموذج دعامة كاميرا المراقبة",
                },
                cctvRepairAnimDict = {
                    description = "قاموس الحركة المستخدم أثناء إصلاح كاميرات المراقبة.",
                    label = "قاموس حركة الإصلاح",
                },
                cctvRepairAnimFlag = {
                    description = "علامة الحركة المستخدمة أثناء إصلاح كاميرات المراقبة.",
                    label = "علامة حركة الإصلاح",
                },
                cctvRepairAnimName = {
                    description = "اسم الحركة المستخدم أثناء إصلاح كاميرات المراقبة.",
                    label = "اسم حركة الإصلاح",
                },
                cctvRepairCancelDelayMs = {
                    description = "المللي ثانية قبل إمكانية إلغاء إصلاح كاميرا المراقبة.",
                    label = "تأخير إلغاء الإصلاح",
                },
                cctvRepairDistance = {
                    description = "المسافة المستخدمة لإصلاح كاميرات المراقبة.",
                    label = "مسافة الإصلاح",
                },
                cctvRepairItem = {
                    description = "عنصر الحقيبة المستخدم لإصلاح كاميرات المراقبة.",
                    label = "عنصر الإصلاح",
                },
                cctvRepairPerTick = {
                    description = "المتانة المستعادة في كل دورة إصلاح لكاميرا المراقبة.",
                    label = "الإصلاح لكل دورة",
                },
                cctvRepairTickMs = {
                    description = "المللي ثانية بين دورات إصلاح كاميرا المراقبة.",
                    label = "دورة الإصلاح",
                },
                cctvRotateStep = {
                    description = "خطوة الدوران المستخدمة عند وضع كاميرات المراقبة.",
                    label = "خطوة الدوران",
                },
                cctvStreamDistance = {
                    description = "المسافة المستخدمة لتحميل كاميرات المراقبة.",
                    label = "مسافة التحميل",
                },
                cctvViewOffset = {
                    description = "إزاحة العرض المستخدمة لعرض البث المباشر لكاميرا المراقبة.",
                    label = "إزاحة العرض",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "ينشئ حاجز تصادم مانعاً على امتداد الشريط كي لا يتمكن اللاعبون من المرور من خلاله.",
                    label = "حاجز تصادم للشريط",
                },
                crimeSceneTapeConsumeItem = {
                    description = "إزالة عنصر شريط واحد من الحقيبة بعد وضعه بنجاح.",
                    label = "استهلاك عنصر الشريط",
                },
                crimeSceneTapeDynamic = {
                    description = "جعل الشريط يتفاعل مع الفيزياء والجاذبية بدلاً من تثبيته في مكانه.",
                    label = "فيزياء ديناميكية",
                },
                crimeSceneTapeEnabled = {
                    description = "تفعيل وضع شريط مسرح الجريمة باستخدام عنصر من الحقيبة.",
                    label = "شريط مسرح الجريمة",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "السماح فقط للوظائف المصرح بها، ومع شرط الخدمة إن كان مفعلاً، بإزالة الشريط.",
                    label = "تقييد الإزالة",
                },
                crimeSceneTapeItem = {
                    description = "اسم عنصر الحقيبة الذي يبدأ وضع شريط مسرح الجريمة.",
                    label = "عنصر الشريط",
                },
                crimeSceneTapeJobs = {
                    description = "أسماء الوظائف المسموح لها باستخدام شريط مسرح الجريمة.",
                    itemLabel = "وظيفة",
                    label = "الوظائف المسموح بها",
                },
                crimeSceneTapeLabel = {
                    description = "الاسم المعروض لشريط مسرح الجريمة أثناء وضعه.",
                    label = "تسمية الشريط",
                },
                crimeSceneTapeLengthStep = {
                    description = "مقدار الزيادة بالأمتار الذي يُقرّب إليه طول الشريط المحدد.",
                    label = "خطوة طول الشريط",
                },
                crimeSceneTapeMaxLength = {
                    description = "أطول مسافة مسموح بها بين عمودي الشريط بالأمتار.",
                    label = "الحد الأقصى لطول الشريط",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "أقصى مسافة لأي نقطة نهاية عن الضابط الذي يضع الشريط.",
                    label = "أقصى مسافة للوضع",
                },
                crimeSceneTapeMinLength = {
                    description = "أقصر مسافة مسموح بها بين عمودي الشريط بالأمتار.",
                    label = "الحد الأدنى لطول الشريط",
                },
                crimeSceneTapeModel = {
                    description = "اسم نموذج المجسم المستخدم لشريط مسرح الجريمة الموضوع.",
                    label = "نموذج الشريط",
                },
                crimeSceneTapePostModel = {
                    description = "نموذج الدعامة المستخدم لعمودي الشريط.",
                    label = "نموذج عمود الشريط",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "أقصى مسافة يمكن منها إزالة شريط مسرح الجريمة الموضوع.",
                    label = "مسافة الإزالة",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "السماح فقط لأفراد الوظائف المصرح بها وهم في الخدمة بوضع الشريط.",
                    label = "يتطلب أن تكون في الخدمة",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "إعادة عنصر الشريط المستهلك عند إزالة الشريط الموضوع.",
                    label = "إعادة العنصر عند الإزالة",
                },
                crimeSceneTapeSag = {
                    description = "أقصى ترهل إلى الأسفل للشريط بين العمودين بالأمتار.",
                    label = "ترهل الشريط",
                },
                crimeSceneTapeSections = {
                    description = "نماذج مقاطع الشريط الأصلية المستخدمة لتجميع الطول المحدد.",
                    itemLabel = "مقطع شريط",
                    label = "مقاطع الشريط",
                },
                crimeSceneTapeShowPosts = {
                    description = "ينشئ أعمدة دعم مرئية عند طرفي شريط مسرح الجريمة متغير الطول.",
                    label = "إظهار أعمدة الشريط",
                },
                crimeSceneTapeStreamDistance = {
                    description = "المسافة التي يتم ضمنها تحميل شريط مسرح الجريمة الموضوع.",
                    label = "مسافة البث",
                },
                crimeSceneTapeTapeHeight = {
                    description = "ارتفاع الشريط فوق نقطتي الأرض المحددتين.",
                    label = "ارتفاع الشريط",
                },
                crimeSceneTapeVariableLength = {
                    description = "يسمح للضباط بتحديد نقطتي البداية والنهاية لوضع شريط مسرح الجريمة بطول قابل للتعديل.",
                    label = "طول شريط متغير",
                },
                crimeSceneTapeZOffset = {
                    description = "الإزاحة الرأسية المطبقة عند وضع نموذج الشريط.",
                    label = "إزاحة الارتفاع",
                },
                cuffsAnimDict = {
                    description = "قاموس الحركة المستخدم للاعبين المقيدين.",
                    label = "قاموس الحركة",
                },
                cuffsAnimFlag = {
                    description = "علامة الحركة المستخدمة للاعبين المقيدين.",
                    label = "علامة الحركة",
                },
                cuffsAnimName = {
                    description = "اسم الحركة المستخدم للاعبين المقيدين.",
                    label = "اسم الحركة",
                },
                cuffsConsumeItem = {
                    description = "إزالة عنصر الأصفاد عند تطبيق التكبيل.",
                    label = "استهلاك الأصفاد",
                },
                cuffsEnabled = {
                    description = "تفعيل إجراءات التكبيل.",
                    label = "الأصفاد",
                },
                cuffsEscapeEnabled = {
                    description = "تفعيل لعبة الهروب من الأصفاد المصغرة.",
                    label = "الهروب من الأصفاد",
                },
                cuffsEscapeKeyPool = {
                    description = "المفاتيح التي يمكن أن تظهر في لعبة الهروب من الأصفاد المصغرة.",
                    itemLabel = "المفتاح",
                    label = "مجموعة مفاتيح الهروب",
                },
                cuffsEscapeRounds = {
                    description = "عدد الجولات المطلوبة في لعبة الهروب من الأصفاد المصغرة.",
                    label = "جولات الهروب",
                },
                cuffsEscapeWindowMs = {
                    description = "المللي ثانية المسموح بها لكل نافذة إدخال في محاولة الهروب.",
                    label = "نافذة الهروب",
                },
                cuffsHandsUpEnabled = {
                    description = "تفعيل حالة رفع اليدين المستخدمة مع الأصفاد والأربطة البلاستيكية.",
                    label = "رفع اليدين",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "الثواني التي يجب الضغط خلالها على مفتاح رفع اليدين قبل التفعيل.",
                    label = "ثواني الضغط المطولة لرفع اليدين",
                },
                cuffsHandsUpKey = {
                    description = "مفتاح لوحة المفاتيح المستخدم لرفع اليدين.",
                    label = "مفتاح رفع اليدين",
                },
                cuffsItem = {
                    description = "عنصر الحقيبة المستخدم لإجراءات التكبيل.",
                    label = "عنصر الأصفاد",
                },
                cuffsMaxDistance = {
                    description = "أقصى مسافة للهدف لإجراءات التكبيل.",
                    label = "مسافة التكبيل",
                },
                cuffsRequireItem = {
                    description = "يتطلب عنصر الأصفاد المهيأ.",
                    label = "الأصفاد تتطلب عنصراً",
                },
                cuffsRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل التكبيل.",
                    label = "الأصفاد تتطلب الخدمة",
                },
                cuffsReturnOnRemove = {
                    description = "إعادة عنصر الأصفاد عند إزالة التكبيل.",
                    label = "إعادة الأصفاد",
                },
                dispatchOfficerDownEnabled = {
                    description = "إرسال تنبيه استدعاء عند سقوط ضابط قيد الخدمة.",
                    label = "تنبيهات ضابط مصاب",
                },
                dispatchOfficerDownJobs = {
                    description = "الوظائف التي يجب أن تتلقى استدعاءات ضابط مصاب.",
                    itemLabel = "الوظيفة",
                    label = "وظائف تنبيه الضابط المصاب",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "إشعار اللاعبين قيد الخدمة فقط.",
                    label = "تنبيه الضابط المصاب يتطلب الخدمة",
                },
                dispatchShotsFiredChance = {
                    description = "احتمال من 0.0 إلى 1.0 لإنشاء تنبيه عند اكتشاف إطلاق نار.",
                    label = "احتمال التنبيه",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "الثواني قبل أن يتمكن نفس اللاعب من تفعيل تنبيه إطلاق نار آخر.",
                    label = "فترة انتظار إطلاق النار",
                },
                dispatchShotsFiredEnabled = {
                    description = "تفعيل تنبيهات استدعاء إطلاق النار.",
                    label = "تنبيهات إطلاق النار",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "الأسلحة التي لا ينبغي أن تفعّل تنبيهات إطلاق النار.",
                    itemLabel = "السلاح",
                    label = "الأسلحة المتجاهلة",
                },
                dispatchShotsFiredJobs = {
                    description = "الوظائف التي يجب أن تتلقى استدعاءات إطلاق النار.",
                    itemLabel = "الوظيفة",
                    label = "وظائف تنبيه إطلاق النار",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "إشعار اللاعبين قيد الخدمة فقط.",
                    label = "تنبيه إطلاق النار يتطلب الخدمة",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "إنشاء مدخلات استدعاء عند اكتشاف إطلاق نار.",
                    label = "إرسال استدعاء إطلاق النار",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "احتمال من 0.0 إلى 1.0 لإنشاء تنبيه عند اكتشاف طلقة مكتومة.",
                    label = "احتمال تنبيه إطلاق النار المكتوم",
                },
                escortEnabled = {
                    description = "تفعيل مرافقة اللاعبين.",
                    label = "المرافقة",
                },
                escortMaxDistance = {
                    description = "أقصى مسافة لبدء مرافقة لاعب.",
                    label = "مسافة المرافقة",
                },
                escortRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل مرافقة اللاعبين.",
                    label = "المرافقة تتطلب الخدمة",
                },
                escortVehicleDistance = {
                    description = "أقصى مسافة لوضع لاعب مرافَق داخل مركبة.",
                    label = "مسافة مركبة المرافقة",
                },
                evidenceBloodDamageThreshold = {
                    description = "أدنى حد ضرر قبل إنشاء دليل دم.",
                    label = "حد ضرر الدم",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "المللي ثانية قبل إمكانية إنشاء ظرف فارغ آخر.",
                    label = "فترة انتظار الظرف الفارغ",
                },
                evidenceCasingMergeRadius = {
                    description = "نصف القطر المستخدم لدمج الأظرف الفارغة القريبة.",
                    label = "نصف قطر دمج الأظرف",
                },
                evidenceCleanupIntervalMs = {
                    description = "المللي ثانية بين جولات تنظيف الأدلة.",
                    label = "فاصل التنظيف",
                },
                evidenceCleanupTtlSeconds = {
                    description = "الثواني قبل انتهاء صلاحية الأدلة الميدانية تلقائياً.",
                    label = "مدة صلاحية التنظيف",
                },
                evidenceCleanerAllowEveryone = {
                    label = "إتاحة المنظف للجميع",
                    description = "السماح للجميع بإزالة الآثار باستخدام بيروكسيد الهيدروجين. عطّل الخيار لاستخدام قوائم الوظائف والعصابات.",
                },
                evidenceCleanerJobs = {
                    label = "وظائف المنظف",
                    description = "الأسماء الداخلية المسموحة عند تعطيل الوصول العام. تطابق الوظيفة أو العصابة يسمح بالوصول؛ القوائم الفارغة تمنعه.",
                    itemLabel = "وظيفة",
                },
                evidenceCleanerGangs = {
                    label = "عصابات المنظف",
                    description = "الأسماء الداخلية المسموحة عند تعطيل الوصول العام. تطابق الوظيفة أو العصابة يسمح بالوصول؛ القوائم الفارغة تمنعه.",
                    itemLabel = "عصابة",
                },
                evidenceCollectDistance = {
                    description = "المسافة المستخدمة لجمع الأدلة الميدانية.",
                    label = "مسافة الجمع",
                },
                evidenceDiscoverDistance = {
                    description = "المسافة المستخدمة لاكتشاف علامات الأدلة القريبة.",
                    label = "مسافة الاكتشاف",
                },
                evidenceFieldEnabled = {
                    description = "تفعيل إنشاء وجمع الأدلة في الميدان.",
                    label = "الأدلة الميدانية",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "السلاح المستخدم لفحص وكشف الأدلة في الميدان.",
                    label = "سلاح المصباح اليدوي",
                },
                evidenceGloveFreeHands = {
                    description = "معرفات مكونات اليد التي تُعامل على أنها بلا قفازات.",
                    label = "أيدٍ بلا قفازات",
                },
                evidenceMarkerColor = {
                    description = "لون RGBA المستخدم لعلامات الأدلة الميدانية.",
                    label = "لون العلامة",
                },
                evidenceMarkerDrawDistance = {
                    description = "مسافة الرسم المستخدمة لعلامات الأدلة الميدانية.",
                    label = "مسافة الرسم",
                },
                evidenceMarkerOffset = {
                    description = "إزاحة العلامة الرأسية المستخدمة للأدلة الميدانية.",
                    label = "الإزاحة",
                },
                evidenceMarkerScaleX = {
                    description = "مقياس X للعلامة المستخدم للأدلة الميدانية.",
                    label = "مقياس X",
                },
                evidenceMarkerScaleY = {
                    description = "مقياس Y للعلامة المستخدم للأدلة الميدانية.",
                    label = "مقياس Y",
                },
                evidenceMarkerScaleZ = {
                    description = "مقياس Z للعلامة المستخدم للأدلة الميدانية.",
                    label = "مقياس Z",
                },
                evidenceMarkerType = {
                    description = "نوع العلامة المستخدم للأدلة الميدانية.",
                    label = "نوع العلامة",
                },
                evidenceMaxCreateDistance = {
                    description = "أقصى مسافة لإنشاء سجلات الأدلة.",
                    label = "مسافة الإنشاء",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "المللي ثانية المسموح بها لموافقة عينة اللعاب.",
                    label = "مهلة موافقة عينة اللعاب",
                },
                evidenceScannerDistance = {
                    description = "المسافة المستخدمة لتفاعلات ماسح الأدلة الضوئي.",
                    label = "مسافة الماسح الضوئي",
                },
                evidenceScannerDurationMs = {
                    description = "مدة إجراء بصمة الإصبع/الماسح الضوئي بالمللي ثانية.",
                    label = "مدة الماسح الضوئي",
                },
                evidenceStorageMaxCompartments = {
                    description = "أقصى عدد من حجرات تخزين الأدلة.",
                    label = "حجرات التخزين",
                },
                gpsTrackerBeepDistance = {
                    description = "المسافة التي تصبح عندها ملاحظات صفير متتبع GPS ذات أهمية.",
                    label = "مسافة الصفير",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "المللي ثانية بين الصفيرات عند الابتعاد عن المتتبع.",
                    label = "فاصل الصفير البعيد",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "المللي ثانية بين الصفيرات عند الاقتراب من المتتبع.",
                    label = "فاصل الصفير القريب",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "إزالة عنصر المتتبع بعد وضعه.",
                    label = "استهلاك متتبع GPS",
                },
                gpsTrackerEnabled = {
                    description = "تفعيل وضع ومسح متتبعات GPS للمركبات.",
                    label = "متتبع GPS",
                },
                gpsTrackerItem = {
                    description = "عنصر الحقيبة المستخدم لوضع متتبعات GPS.",
                    label = "عنصر المتتبع",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "المللي ثانية بين تحديثات خريطة المتتبع.",
                    label = "فاصل تحديث الخريطة",
                },
                gpsTrackerPlaceDistance = {
                    description = "أقصى مسافة لوضع متتبع GPS على مركبة.",
                    label = "مسافة الوضع",
                },
                gpsTrackerRemoveDistance = {
                    description = "أقصى مسافة لإزالة متتبع GPS موضوع.",
                    label = "مسافة الإزالة",
                },
                gpsTrackerRemoveKey = {
                    description = "رمز التحكم المستخدم لإزالة متتبع GPS موضوع.",
                    label = "مفتاح الإزالة",
                },
                gpsTrackerRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل استخدام متتبعات GPS.",
                    label = "GPS يتطلب الخدمة",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "يتطلب انتماء اللاعب إلى مجموعة الشرطة قبل استخدام متتبعات GPS.",
                    label = "GPS يتطلب وظيفة الشرطة",
                },
                gpsTrackerReturnOnRemove = {
                    description = "إعادة عنصر المتتبع عند إزالته.",
                    label = "إعادة المتتبع عند الإزالة",
                },
                gpsTrackerScanDistance = {
                    description = "أقصى مسافة للمسح بحثاً عن المتتبعات.",
                    label = "مسافة مسح GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "المللي ثانية المستغرقة في المسح بحثاً عن متتبع GPS.",
                    label = "مدة المسح",
                },
                gpsTrackerScannerWeapon = {
                    description = "السلاح أو الأداة المستخدمة للمسح بحثاً عن متتبعات GPS.",
                    label = "سلاح الماسح الضوئي",
                },
                impoundAccount = {
                    description = "الحساب المستخدم لفرض رسوم إطلاق سراح المركبات المحجوزة.",
                    label = "حساب الدفع",
                },
                impoundCreatorVehicleModel = {
                    description = "نموذج المركبة المعروض بواسطة معاينة منشئ الحجز.",
                    label = "نموذج مركبة المنشئ",
                },
                impoundCustomGarageEnabled = {
                    description = "استخدام واجهة حجز كراج مخصصة عند توفرها.",
                    label = "حجز كراج مخصص",
                },
                impoundDefaultPrice = {
                    description = "السعر الافتراضي لإطلاق سراح مركبة محجوزة.",
                    label = "السعر الافتراضي",
                },
                impoundDeliveryDistance = {
                    description = "المسافة المستخدمة لتفاعلات تسليم الحجز.",
                    label = "مسافة التسليم",
                },
                impoundDeliveryMarker = {
                    description = "تهيئة العلامة المستخدمة لتسليمات الحجز.",
                    label = "علامة التسليم",
                },
                impoundEnabled = {
                    description = "تفعيل مسارات الحجز.",
                    label = "الحجز",
                },
                impoundMarker = {
                    description = "تهيئة العلامة المستخدمة لتفاعلات الحجز.",
                    label = "علامة الحجز",
                },
                impoundRadialEnabled = {
                    description = "تفعيل إجراءات الحجز في القائمة الدائرية.",
                    label = "إجراء الحجز",
                },
                impoundRadialRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل استخدام إجراء الحجز الدائري.",
                    label = "الحجز يتطلب الخدمة",
                },
                impoundRadialVehicleDistance = {
                    description = "أقصى مسافة إلى المركبة المستهدفة لإجراءات الحجز الدائرية.",
                    label = "مسافة مركبة الحجز",
                },
                impoundReleaseDistance = {
                    description = "المسافة المستخدمة لتفاعلات إطلاق سراح الحجز.",
                    label = "مسافة الإطلاق",
                },
                impoundReleaseKey = {
                    description = "رمز التحكم المستخدم لإطلاق سراح المركبات المحجوزة.",
                    label = "مفتاح الإطلاق",
                },
                impoundRequireDelivery = {
                    description = "يتطلب التسليم إلى ساحة حجز مهيأة.",
                    label = "يتطلب التسليم",
                },
                impoundStorageBasePrice = {
                    description = "سعر الإطلاق الأساسي للمركبات المحجوزة المخزنة.",
                    label = "سعر المخزن الأساسي",
                },
                impoundStorageDailyFee = {
                    description = "رسوم المخزن الإضافية لكل يوم مهيأ.",
                    label = "رسوم المخزن اليومية",
                },
                impoundStorageDaySeconds = {
                    description = "عدد الثواني التي تُحتسب كيوم فوترة واحد للمخزن.",
                    label = "ثواني اليوم في المخزن",
                },
                impoundStorageEnabled = {
                    description = "تفعيل معالجة مخزن الحجز المدفوع.",
                    label = "مخزن الحجز",
                },
                jailAssignRange = {
                    description = "أقصى مسافة لإرسال هدف إلى السجن.",
                    label = "نطاق الإسناد",
                },
                jailCanteenCooldownMinutes = {
                    description = "الدقائق التي يجب على النزيل الانتظار قبل المطالبة بحزمة مقصف أخرى.",
                    label = "دقائق فترة الانتظار",
                },
                jailCanteenPackage = {
                    description = "العناصر الممنوحة بواسطة حزمة مقصف السجن.",
                    label = "حزمة المقصف",
                },
                jailCellStreamDistance = {
                    description = "المسافة المستخدمة لتحميل دعامات الزنزانة الانفرادية.",
                    label = "مسافة تحميل الزنزانة",
                },
                jailClearInventory = {
                    description = "إفراغ حقيبة اللاعب عند إرساله إلى السجن.",
                    label = "إفراغ الحقيبة",
                },
                jailDefaultMonths = {
                    description = "مدة السجن الافتراضية عند فتح واجهة الإسناد.",
                    label = "الأشهر الافتراضية",
                },
                jailDispatchJobs = {
                    description = "الوظائف التي يجب أن تتلقى استدعاءات السجن.",
                    itemLabel = "الوظيفة",
                    label = "وظائف الاستدعاء",
                },
                jailDoctorHealEvent = {
                    description = "الحدث من جانب الخادم أو العميل الذي يتم تشغيله عند معالجة طبيب السجن لأحد النزلاء.",
                    label = "حدث العلاج",
                },
                jailElectricalCodeListItem = {
                    description = "عنصر الحقيبة المطلوب لكشف الرموز الكهربائية المولدة.",
                    label = "عنصر قائمة الرموز",
                },
                jailElectricalCodeMax = {
                    description = "أعلى قيمة رمز عشوائي لصندوق الكهرباء.",
                    label = "أقصى رمز",
                },
                jailElectricalCodeMin = {
                    description = "أقل قيمة رمز عشوائي لصندوق الكهرباء.",
                    label = "أدنى رمز",
                },
                jailElectricalCodesCount = {
                    description = "عدد الرموز المرشحة المولدة لصندوق الكهرباء.",
                    label = "عدد الرموز",
                },
                jailElectricalEnabled = {
                    description = "تفعيل لعبة الهروب عبر الكهرباء المصغرة.",
                    label = "صندوق الكهرباء",
                },
                jailElectricalPinLength = {
                    description = "عدد الأرقام المستخدمة لرموز صندوق الكهرباء السرية.",
                    label = "طول الرمز السري",
                },
                jailElectricalPropModel = {
                    description = "نموذج دعامة العالم المستخدم لصندوق كهرباء السجن.",
                    label = "نموذج الدعامة",
                },
                jailElectricalShockDamage = {
                    description = "الضرر الواقع عندما يفشل النزيل في تسلسل الكهرباء.",
                    label = "ضرر الصدمة",
                },
                jailElectricalShockRagdollMs = {
                    description = "المللي ثانية للسقوط بعد صدمة كهربائية.",
                    label = "سقوط الصدمة",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "دقائق الحكم المزالة بعد محاولة هروب كهربائي ناجحة.",
                    label = "دقائق تخفيض النجاح",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "الكمية المطلوبة لمقايضة نزيل مدمن الكحول.",
                    label = "الكمية المطلوبة",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "العنصر المطلوب لمقايضة نزيل مدمن الكحول.",
                    label = "العنصر المطلوب",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "كمية المكافأة لمقايضة نزيل مدمن الكحول.",
                    label = "كمية المكافأة",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "عنصر المكافأة لمقايضة نزيل مدمن الكحول.",
                    label = "عنصر المكافأة",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "تسمية المكافأة المعروضة لمقايضة نزيل مدمن الكحول.",
                    label = "تسمية المكافأة",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "الكمية المطلوبة لمقايضة نزيل المخبر.",
                    label = "الكمية المطلوبة",
                },
                jailInmateCodeListRequiredItem = {
                    description = "العنصر المطلوب لمقايضة نزيل المخبر.",
                    label = "العنصر المطلوب",
                },
                jailInmateCodeListRewardAmount = {
                    description = "كمية المكافأة لمقايضة نزيل المخبر.",
                    label = "كمية المكافأة",
                },
                jailInmateCodeListRewardItem = {
                    description = "عنصر المكافأة لمقايضة نزيل المخبر.",
                    label = "عنصر المكافأة",
                },
                jailInmateCodeListRewardLabel = {
                    description = "تسمية المكافأة المعروضة لمقايضة نزيل المخبر.",
                    label = "تسمية المكافأة",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "العناصر المقبولة لمقايضة نزيل تاجر المخدرات.",
                    label = "العناصر المقبولة",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "الكمية المطلوبة لمقايضة نزيل تاجر المخدرات.",
                    label = "الكمية المطلوبة",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "كمية المكافأة لمقايضة نزيل تاجر المخدرات.",
                    label = "كمية المكافأة",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "عنصر المكافأة لمقايضة نزيل تاجر المخدرات.",
                    label = "عنصر المكافأة",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "تسمية المكافأة المعروضة لمقايضة نزيل تاجر المخدرات.",
                    label = "تسمية المكافأة",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "السماح باحتساب الممنوعات المكتشفة أثناء تنظيف السجن ضمن مقايضة نزيل تاجر المخدرات.",
                    label = "استخدام ممنوعات التنظيف",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "الكمية المطلوبة لمقايضة نزيل جالب الأدوات.",
                    label = "الكمية المطلوبة",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "العنصر المطلوب لمقايضة نزيل جالب الأدوات.",
                    label = "العنصر المطلوب",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "كمية المكافأة لمقايضة نزيل جالب الأدوات.",
                    label = "كمية المكافأة",
                },
                jailInmateWireCutterRewardItem = {
                    description = "عنصر المكافأة لمقايضة نزيل جالب الأدوات.",
                    label = "عنصر المكافأة",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "تسمية المكافأة المعروضة لمقايضة نزيل جالب الأدوات.",
                    label = "تسمية المكافأة",
                },
                jailJobsCarryBoxModel = {
                    description = "نموذج الدعامة المستخدم لصندوق وظيفة نقل السجن.",
                    label = "نموذج صندوق النقل",
                },
                jailJobsCarryDropoffKey = {
                    description = "رمز التحكم المستخدم لتسليم صناديق وظيفة النقل.",
                    label = "مفتاح تسليم النقل",
                },
                jailJobsCarryDropoffRadius = {
                    description = "نصف قطر التسليم لوظيفة نقل السجن.",
                    label = "نصف قطر التسليم",
                },
                jailJobsCarryInspectKey = {
                    description = "رمز التحكم المستخدم لفحص صناديق وظيفة النقل.",
                    label = "مفتاح الفحص",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "العناصر التافهة التي يمكن العثور عليها عند فحص صناديق وظيفة النقل.",
                    label = "عناصر الفحص التافهة",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "فرصة الحصول على مكافأة غنيمة قابلة للاستخدام عند فحص الصناديق.",
                    label = "فرصة الغنيمة القابلة للاستخدام",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "العناصر القابلة للاستخدام التي يمكن العثور عليها عند فحص صناديق وظيفة النقل.",
                    label = "عناصر الفحص القابلة للاستخدام",
                },
                jailJobsCarryInteractDistance = {
                    description = "مسافة التفاعل لوظيفة نقل السجن.",
                    label = "مسافة تفاعل النقل",
                },
                jailJobsCarryMaxDistance = {
                    description = "أقصى مسافة مسموح بها لتقدم وظيفة نقل السجن.",
                    label = "أقصى مسافة للنقل",
                },
                jailJobsCarryPickupKey = {
                    description = "رمز التحكم المستخدم لالتقاط صناديق وظيفة النقل.",
                    label = "مفتاح التقاط النقل",
                },
                jailJobsCarryPickupOffset = {
                    description = "جسم الإزاحة المستخدم لموقع التقاط وظيفة النقل.",
                    label = "إزاحة الالتقاط",
                },
                jailJobsCarryTimeReduction = {
                    description = "تخفيض الحكم عند إكمال وظيفة نقل السجن.",
                    label = "تخفيض وقت النقل",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "رمز التحكم المستخدم عند حاوية قمامة السجن.",
                    label = "مفتاح حاوية القمامة",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "النموذج المستخدم لدعامة حاوية قمامة تنظيف السجن.",
                    label = "نموذج حاوية القمامة",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "فرصة العثور على ممنوعات أثناء التنظيف.",
                    label = "فرصة اكتشاف الممنوعات",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "العناصر التي يمكن العثور عليها أثناء التنظيف في السجن.",
                    label = "عناصر الاكتشافات الممنوعة",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "مهلة رسائل اكتشاف الممنوعات بالمللي ثانية.",
                    label = "مهلة رسالة الاكتشاف",
                },
                jailJobsCleaningInteractDistance = {
                    description = "المسافة المستخدمة للتفاعل مع قمامة التنظيف.",
                    label = "مسافة تفاعل التنظيف",
                },
                jailJobsCleaningMaxDistance = {
                    description = "أقصى مسافة قبل إعادة ضبط دعامات التنظيف أو اختفائها.",
                    label = "أقصى مسافة للتنظيف",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "أقصى عدد متزامن لدعامات القمامة في تنظيف السجن.",
                    label = "أقصى عدد لدعامات القمامة",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "أدنى مسافة من المركز لتوليد قمامة التنظيف.",
                    label = "أدنى نصف قطر للظهور",
                },
                jailJobsCleaningPickupKey = {
                    description = "رمز التحكم المستخدم لالتقاط قمامة تنظيف السجن.",
                    label = "مفتاح التقاط التنظيف",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "المللي ثانية بين محاولات توليد قمامة التنظيف.",
                    label = "فاصل ظهور القمامة",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "نصف القطر المستخدم لتوليد دعامات قمامة التنظيف.",
                    label = "نصف قطر ظهور القمامة",
                },
                jailJobsCleaningTrashModels = {
                    description = "نماذج دعامات القمامة المستخدمة لوظيفة تنظيف السجن.",
                    itemLabel = "النموذج",
                    label = "نماذج القمامة",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "لون RGBA للخط التوضيحي المستخدم لدعامات قمامة تنظيف السجن.",
                    label = "لون الخط التوضيحي",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "تفعيل الخطوط التوضيحية على دعامات قمامة تنظيف السجن.",
                    label = "الخط التوضيحي للقمامة",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "معرف المُظلل المستخدم لخطوط قمامة تنظيف السجن التوضيحية.",
                    label = "مُظلل الخط التوضيحي",
                },
                jailJobsTimeReduction = {
                    description = "تخفيض الحكم عند إكمال وظيفة تنظيف السجن.",
                    label = "تخفيض وقت التنظيف",
                },
                jailJobsTrashGoal = {
                    description = "عدد عناصر القمامة اللازمة لإكمال وظيفة تنظيف السجن.",
                    label = "هدف قمامة التنظيف",
                },
                jailMaxMonths = {
                    description = "أطول مدة سجن يمكن اختيارها.",
                    label = "الحد الأقصى من الأشهر",
                },
                jailMinMonths = {
                    description = "أقل مدة سجن يمكن اختيارها.",
                    label = "الحد الأدنى من الأشهر",
                },
                jailMonthMinutes = {
                    description = "دقائق الوقت الفعلي التي يمثلها شهر سجن واحد.",
                    label = "دقائق لكل شهر",
                },
                jailObjectStreamDistance = {
                    description = "المسافة المستخدمة لتحميل أجسام عالم السجن الدائمة.",
                    label = "مسافة تحميل الأجسام",
                },
                jailOutfitApplyDelayMs = {
                    description = "التأخير بعد الانضمام قبل تطبيق زي السجن.",
                    label = "تأخير تطبيق الزي",
                },
                jailOutfitEnabled = {
                    description = "تفعيل أزياء السجن.",
                    label = "زي السجن",
                },
                jailOutfitFemaleArms = {
                    description = "مكون ذراعي زي السجن للإناث.",
                    label = "الذراعان",
                },
                jailOutfitFemaleChain1 = {
                    description = "نموذج سلسلة زي السجن للإناث.",
                    label = "السلسلة 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "نسيج سلسلة زي السجن للإناث.",
                    label = "السلسلة 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "نموذج شعارات زي السجن للإناث.",
                    label = "الشعارات 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "نسيج شعارات زي السجن للإناث.",
                    label = "الشعارات 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "نموذج نظارات زي السجن للإناث (استخدم -1 لإزالة النظارات).",
                    label = "النظارات 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "نسيج نظارات زي السجن للإناث.",
                    label = "النظارات 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "نموذج خوذة زي السجن للإناث.",
                    label = "الخوذة 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "نسيج خوذة زي السجن للإناث.",
                    label = "الخوذة 2",
                },
                jailOutfitFemalePants1 = {
                    description = "نموذج بنطال زي السجن للإناث.",
                    label = "البنطال 1",
                },
                jailOutfitFemalePants2 = {
                    description = "نسيج بنطال زي السجن للإناث.",
                    label = "البنطال 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "نموذج حذاء زي السجن للإناث.",
                    label = "الحذاء 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "نسيج حذاء زي السجن للإناث.",
                    label = "الحذاء 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "نموذج جذع زي السجن للإناث.",
                    label = "الجذع 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "نسيج جذع زي السجن للإناث.",
                    label = "الجذع 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "نموذج قميص زي السجن للإناث.",
                    label = "قميص 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "نسيج قميص زي السجن للإناث.",
                    label = "قميص 2",
                },
                jailOutfitMaleArms = {
                    description = "مكون ذراعي زي السجن للذكور.",
                    label = "الذراعان",
                },
                jailOutfitMaleChain1 = {
                    description = "نموذج سلسلة زي السجن للذكور.",
                    label = "السلسلة 1",
                },
                jailOutfitMaleChain2 = {
                    description = "نسيج سلسلة زي السجن للذكور.",
                    label = "السلسلة 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "نموذج شعارات زي السجن للذكور.",
                    label = "الشعارات 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "نسيج شعارات زي السجن للذكور.",
                    label = "الشعارات 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "نموذج نظارات زي السجن للذكور (استخدم -1 لإزالة النظارات).",
                    label = "النظارات 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "نسيج نظارات زي السجن للذكور.",
                    label = "النظارات 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "نموذج خوذة زي السجن للذكور.",
                    label = "الخوذة 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "نسيج خوذة زي السجن للذكور.",
                    label = "الخوذة 2",
                },
                jailOutfitMalePants1 = {
                    description = "نموذج بنطال زي السجن للذكور.",
                    label = "البنطال 1",
                },
                jailOutfitMalePants2 = {
                    description = "نسيج بنطال زي السجن للذكور.",
                    label = "البنطال 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "نموذج حذاء زي السجن للذكور.",
                    label = "الحذاء 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "نسيج حذاء زي السجن للذكور.",
                    label = "الحذاء 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "نموذج جذع زي السجن للذكور.",
                    label = "الجذع 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "نسيج جذع زي السجن للذكور.",
                    label = "الجذع 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "نموذج قميص زي السجن للذكور.",
                    label = "قميص 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "نسيج قميص زي السجن للذكور.",
                    label = "قميص 2",
                },
                jailRequireJailTerminal = {
                    description = "السماح بأحكام السجن التي يصدرها الضباط فقط بالقرب من محطة السجن المحدد.",
                    label = "اشتراط محطة السجن",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "استعادة الزي المدني المحفوظ عند هروب أحد النزلاء.",
                    label = "استعادة الزي عند الهروب",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "فترة السماح بعد الاستعادة قبل توقف تصحيح نقطة الظهور عن التطبيق.",
                    label = "نافذة تصحيح الاستعادة",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "نقل النزلاء المستعادين إلى نقطة ظهور السجن إذا تم تحميلهم خارج منطقة السجن.",
                    label = "نقل النزلاء المستعادين",
                },
                jailTerminalRange = {
                    description = "أقصى مسافة للضابط من محطة السجن المحدد.",
                    label = "نطاق محطة السجن",
                },
                jailZoneExitGraceMs = {
                    description = "فترة السماح قبل احتساب مغادرة منطقة السجن كهروب.",
                    label = "فترة سماح مغادرة المنطقة",
                },
                mugshotAnimDict = {
                    description = "قاموس الحركة المستخدم أثناء التقاط صورة الحجز.",
                    label = "قاموس الحركة",
                },
                mugshotAnimFlag = {
                    description = "علامة الحركة المستخدمة أثناء التقاط صورة الحجز.",
                    label = "علامة الحركة",
                },
                mugshotAnimName = {
                    description = "اسم الحركة المستخدم أثناء التقاط صورة الحجز.",
                    label = "اسم الحركة",
                },
                mugshotBoardHeader = {
                    description = "الترويسة الرئيسية المعروضة على لوحة صورة الحجز.",
                    label = "ترويسة اللوحة",
                },
                mugshotBoardSubheader = {
                    description = "الترويسة الفرعية الاحتياطية المعروضة على لوحة صورة الحجز.",
                    label = "ترويسة اللوحة الفرعية",
                },
                mugshotCameraCoordsX = {
                    description = "إحداثي X لعالم الكاميرا المستخدم لصور الحجز.",
                    label = "كاميرا X",
                },
                mugshotCameraCoordsY = {
                    description = "إحداثي Y لعالم الكاميرا المستخدم لصور الحجز.",
                    label = "كاميرا Y",
                },
                mugshotCameraCoordsZ = {
                    description = "إحداثي Z لعالم الكاميرا المستخدم لصور الحجز.",
                    label = "كاميرا Z",
                },
                mugshotCameraFov = {
                    description = "مجال الرؤية المستخدم لالتقاط صور الحجز.",
                    label = "مجال رؤية الكاميرا",
                },
                mugshotCameraRotX = {
                    description = "دوران الكاميرا X المستخدم لصور الحجز.",
                    label = "دوران X",
                },
                mugshotCameraRotY = {
                    description = "دوران الكاميرا Y المستخدم لصور الحجز.",
                    label = "دوران Y",
                },
                mugshotCameraRotZ = {
                    description = "دوران الكاميرا Z المستخدم لصور الحجز.",
                    label = "دوران Z",
                },
                mugshotCaptureTimeout = {
                    description = "أقصى مللي ثانية مسموح بها لاستدعاءات التقاط صورة الحجز.",
                    label = "مهلة الالتقاط",
                },
                mugshotEnabled = {
                    description = "تفعيل التقاط صورة الحجز أثناء إدخال السجن.",
                    label = "التقاط صورة الحجز",
                },
                mugshotHeading = {
                    description = "الاتجاه المطبق أثناء التقاط صورة الحجز.",
                    label = "الاتجاه",
                },
                mugshotLocationX = {
                    description = "إحداثي X للعالم المستخدم لالتقاط صورة الحجز.",
                    label = "الموقع X",
                },
                mugshotLocationY = {
                    description = "إحداثي Y للعالم المستخدم لالتقاط صورة الحجز.",
                    label = "الموقع Y",
                },
                mugshotLocationZ = {
                    description = "إحداثي Z للعالم المستخدم لالتقاط صورة الحجز.",
                    label = "الموقع Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "تنسيق الوصف المستخدم للبيانات الوصفية لصورة الحجز المخزنة.",
                    label = "وصف البيانات الوصفية",
                },
                mugshotMetadataName = {
                    description = "اسم البيانات الوصفية للحقيبة المستخدم لصورة الحجز المخزنة.",
                    label = "اسم البيانات الوصفية",
                },
                mugshotWaitMs = {
                    description = "المللي ثانية للانتظار قبل التقاط صورة الحجز.",
                    label = "المللي ثانية للانتظار",
                },
                playerSearchAnimDict = {
                    description = "قاموس الحركة المستخدم أثناء تفتيش اللاعبين.",
                    label = "قاموس الحركة",
                },
                playerSearchAnimFlag = {
                    description = "علامة الحركة المستخدمة أثناء تفتيش اللاعبين.",
                    label = "علامة الحركة",
                },
                playerSearchAnimName = {
                    description = "اسم الحركة المستخدم أثناء تفتيش اللاعبين.",
                    label = "اسم الحركة",
                },
                playerSearchDurationMs = {
                    description = "مدة معاينة تفتيش اللاعب بالمللي ثانية.",
                    label = "مدة التفتيش",
                },
                playerSearchEnabled = {
                    description = "تفعيل مسار معاينة تفتيش اللاعب.",
                    label = "تفتيش اللاعب",
                },
                playerSearchRange = {
                    description = "أقصى مسافة لبدء تفتيش لاعب.",
                    label = "نطاق التفتيش",
                },
                playerSearchScenario = {
                    description = "السيناريو المستخدم عند عدم تشغيل حركة تفتيش صريحة.",
                    label = "سيناريو التفتيش",
                },
                policeBillingControl200 = {
                    label = "الفواتير · التحكم 200",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeBillingControl322 = {
                    label = "الفواتير · التحكم 322",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl10 = {
                    label = "المحرر · التحكم 10",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl11 = {
                    label = "المحرر · التحكم 11",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl172 = {
                    label = "المحرر · التحكم 172",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl173 = {
                    label = "المحرر · التحكم 173",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl174 = {
                    label = "المحرر · التحكم 174",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl175 = {
                    label = "المحرر · التحكم 175",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl177 = {
                    label = "المحرر · التحكم 177",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl191 = {
                    label = "المحرر · التحكم 191",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl201 = {
                    label = "المحرر · التحكم 201",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl202 = {
                    label = "المحرر · التحكم 202",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl21 = {
                    label = "المحرر · التحكم 21",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl32 = {
                    label = "المحرر · التحكم 32",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl322 = {
                    label = "المحرر · التحكم 322",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl33 = {
                    label = "المحرر · التحكم 33",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl34 = {
                    label = "المحرر · التحكم 34",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl35 = {
                    label = "المحرر · التحكم 35",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl36 = {
                    label = "المحرر · التحكم 36",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl37 = {
                    label = "المحرر · التحكم 37",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl38 = {
                    label = "المحرر · التحكم 38",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl44 = {
                    label = "المحرر · التحكم 44",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policeEditorControl73 = {
                    label = "المحرر · التحكم 73",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                policePrimaryColor = {
                    description = "اللون الافتراضي لمجموعة وظائف الشرطة.",
                    label = "اللون الأساسي",
                },
                propPlacementConsumeItem = {
                    description = "إزالة عنصر واحد من الحقيبة عند وضع دعامة.",
                    label = "استهلاك عنصر الدعامة",
                },
                propPlacementEnabled = {
                    description = "السماح بوضع دعامات الشرطة المهيأة من العناصر أو المركبات.",
                    label = "وضع الدعامات",
                },
                propPlacementItemNames = {
                    description = "ربط نماذج الدعامات بأسماء عناصر الحقيبة لوضع الدعامات المعتمد على العناصر.",
                    label = "أسماء عناصر الدعامات",
                },
                propPlacementRequireOnDuty = {
                    description = "فقط الضباط قيد الخدمة يمكنهم وضع الدعامات المهيأة.",
                    label = "الدعامات تتطلب الخدمة",
                },
                propPlacementReturnItem = {
                    description = "إعادة العنصر المستهلك عند إزالة الدعامة الموضوعة.",
                    label = "إعادة عنصر الدعامة",
                },
                propPlacementVehicleAccess = {
                    description = "السماح لمركبات الوظيفة بإتاحة تجهيزة الدعامات المهيأة الخاصة بها.",
                    label = "صلاحية دعامة المركبة",
                },
                radialEnabled = {
                    description = "تفعيل إجراءات القائمة الدائرية للشرطة.",
                    label = "القائمة الدائرية للشرطة",
                },
                radialHandcuffKeybindCommand = {
                    description = "اسم الأمر المسجل لاختصار التكبيل.",
                    label = "أمر التكبيل",
                },
                radialHandcuffKeybindDescription = {
                    description = "الوصف المعروض لاختصار التكبيل.",
                    label = "وصف التكبيل",
                },
                radialHandcuffKeybindEnabled = {
                    description = "تفعيل اختصار التكبيل المباشر.",
                    label = "اختصار التكبيل",
                },
                radialHandcuffKeybindKey = {
                    description = "مفتاح لوحة المفاتيح المستخدم لإجراء التكبيل المباشر.",
                    label = "مفتاح التكبيل",
                },
                radialKeybindsEnabled = {
                    description = "تفعيل اختصارات لوحة المفاتيح المباشرة لإجراءات دائرية محددة.",
                    label = "اختصارات مباشرة",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "اسم الأمر المسجل لاختصار فك التكبيل.",
                    label = "أمر فك التكبيل",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "الوصف المعروض لاختصار فك التكبيل.",
                    label = "وصف فك التكبيل",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "تفعيل اختصار فك التكبيل المباشر.",
                    label = "اختصار فك التكبيل",
                },
                radialUnhandcuffKeybindKey = {
                    description = "مفتاح لوحة المفاتيح المستخدم لإجراء فك التكبيل المباشر.",
                    label = "مفتاح فك التكبيل",
                },
                socialWorkAssignRange = {
                    description = "أقصى مسافة لإسناد مهام العمل الاجتماعي.",
                    label = "نطاق الإسناد",
                },
                socialWorkDeadlineDefault = {
                    description = "الموعد النهائي الافتراضي للعمل الاجتماعي بالدقائق. الصفر يعطل المواعيد النهائية.",
                    label = "الموعد النهائي الافتراضي",
                },
                socialWorkDeadlineMax = {
                    description = "أقصى موعد نهائي للعمل الاجتماعي بالدقائق. الصفر يلغي الحد الأقصى.",
                    label = "أقصى موعد نهائي",
                },
                socialWorkDeadlineMin = {
                    description = "أدنى موعد نهائي للعمل الاجتماعي بالدقائق.",
                    label = "أدنى موعد نهائي",
                },
                socialWorkDefaultTasks = {
                    description = "عدد المهام الافتراضي عند فتح واجهة إسناد العمل الاجتماعي.",
                    label = "المهام الافتراضية",
                },
                socialWorkEnabled = {
                    description = "تفعيل مسارات إسناد ومهام العمل الاجتماعي.",
                    label = "العمل الاجتماعي",
                },
                socialWorkImprisonmentJailId = {
                    description = "معرف السجن المستخدم عندما تؤدي مخالفات العمل الاجتماعي إلى السجن.",
                    label = "معرف السجن الاحتياطي",
                },
                socialWorkImprisonmentMonths = {
                    description = "الأشهر المسندة عندما تؤدي مخالفات العمل الاجتماعي إلى السجن.",
                    label = "أشهر السجن",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "اسم الضابط المستخدم في سجلات سجن العمل الاجتماعي.",
                    label = "اسم ضابط السجن",
                },
                socialWorkImprisonmentSolitary = {
                    description = "إرسال المخالفين إلى الحبس الانفرادي عند تفعيل السجن.",
                    label = "استخدام الحبس الانفرادي",
                },
                socialWorkInactivityMinutes = {
                    description = "الدقائق قبل تطبيق عقوبات عدم نشاط العمل الاجتماعي.",
                    label = "دقائق عدم النشاط",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "عقوبة المهام المطبقة عندما يبقى لاعب العمل الاجتماعي غير نشط لفترة طويلة.",
                    label = "عقوبة مهام عدم النشاط",
                },
                socialWorkMaxTasks = {
                    description = "أكبر عدد مهام عمل اجتماعي يمكن اختياره.",
                    label = "الحد الأقصى من المهام",
                },
                socialWorkMinTasks = {
                    description = "أقل عدد مهام عمل اجتماعي يمكن اختياره.",
                    label = "الحد الأدنى من المهام",
                },
                speedCamBillingEnabled = {
                    description = "إصدار فواتير تلقائية عندما تلتقط كاميرات السرعة مخالفة مطابقة. يتطلب تفعيل ميزة الفواتير العامة.",
                    label = "الغرامات التلقائية",
                },
                speedCamBillingExcludedJobs = {
                    description = "الوظائف التي لا تتلقى فواتير تلقائية من كاميرات السرعة مطلقًا.",
                    itemLabel = "وظيفة",
                    label = "الوظائف المستثناة",
                },
                speedCamBillingExcludedModels = {
                    description = "أسماء طرازات المركبات التي لا تتلقى فواتير تلقائية من كاميرات السرعة مطلقًا.",
                    itemLabel = "طراز",
                    label = "طرازات المركبات المستثناة",
                },
                speedCamBillingRules = {
                    description = "قواعد الغرامة المستخدمة بواسطة كاميرات السرعة. يُفوتر أضيق نطاق تجاوز مطابق أولاً؛ وإذا لم تطابق أي قاعدة، تُستخدم مخالفات تجاوز السرعة كبديل احتياطي.",
                    label = "قواعد الغرامة",
                },
                speedCamCameraEaseMs = {
                    description = "المدة التي تنتقل خلالها الرؤية إلى زاوية كاميرا السرعة. كلما انخفضت القيمة قصرت الحركة؛ وإذا انخفضت أكثر من اللازم قد تُخل بمحاذاة الصورة.",
                    label = "انتقال الكاميرا (مللي ثانية)",
                },
                speedCamCameraFov = {
                    description = "مجال الرؤية المستخدم لالتقاطات كاميرا السرعة.",
                    label = "مجال رؤية الكاميرا",
                },
                speedCamCheckIntervalMs = {
                    description = "المللي ثانية بين عمليات مسح كاميرا السرعة.",
                    label = "فاصل الفحص",
                },
                speedCamCooldownMs = {
                    description = "المللي ثانية قبل أن تتمكن نفس كاميرا السرعة من التفعيل مرة أخرى.",
                    label = "فترة انتظار التفعيل",
                },
                speedCamDamageCooldownMs = {
                    description = "المللي ثانية قبل إمكانية تطبيق ضرر آخر على كاميرا السرعة.",
                    label = "فترة انتظار الضرر",
                },
                speedCamDamagePerHit = {
                    description = "ضرر المتانة المطبق على كاميرات السرعة لكل إصابة.",
                    label = "الضرر لكل إصابة",
                },
                speedCamDamagedModelThreshold = {
                    description = "النسبة المئوية من المتانة القصوى التي يُعرض عندها النموذج المتضرر أو تحتها. مثال: القيمة 50 مع متانة قصوى 200 تعني التبديل عند متانة 100.",
                    label = "حد النموذج المتضرر (%)",
                },
                speedCamDefaultLimit = {
                    description = "حد كاميرا السرعة الافتراضي.",
                    label = "حد السرعة الافتراضي",
                },
                speedCamDefaultName = {
                    description = "اسم العرض المقترح عند وضع كاميرا السرعة. يمكن ترجمة هذا الاسم دون تغيير عنصر المخزون أو نموذج الكاميرا.",
                    label = "الاسم الافتراضي",
                },
                speedCamDefaultTolerance = {
                    description = "تسامح كاميرا السرعة الافتراضي.",
                    label = "التسامح الافتراضي",
                },
                speedCamDisassembleDistance = {
                    description = "المسافة المستخدمة لتفكيك كاميرات السرعة.",
                    label = "مسافة التفكيك",
                },
                speedCamEnabled = {
                    description = "تفعيل كاميرات السرعة المحمولة.",
                    label = "كاميرات السرعة",
                },
                speedCamFlashColor = {
                    description = "لون RGBA للوميض المستخدم بواسطة كاميرات السرعة.",
                    label = "لون الوميض",
                },
                speedCamFlashDurationMs = {
                    description = "زمن تلاشي وميض كاميرا السرعة الأحمر. لا تضبطه منخفضاً جداً وإلا أصبحت حركة الكاميرا مرئية.",
                    label = "مدة الوميض (مللي ثانية)",
                },
                speedCamHealthDisplayDistance = {
                    description = "المسافة التي تُعرض عندها سلامة كاميرا السرعة.",
                    label = "مسافة عرض السلامة",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "المللي ثانية التي تبقى فيها سلامة كاميرا السرعة مرئية.",
                    label = "مدة عرض السلامة",
                },
                speedCamHealthTextOffset = {
                    description = "الإزاحة الرأسية المستخدمة لنص سلامة كاميرا السرعة.",
                    label = "إزاحة نص السلامة",
                },
                speedCamItem = {
                    description = "اسم العنصر الداخلي الدقيق في المخزون، مثل speedcam. أدخل مفتاح العنصر وليس اسم العرض؛ ويجب أن يمنح متجر الوظيفة العنصر نفسه.",
                    label = "اسم عنصر كاميرا السرعة",
                },
                speedCamMaintenanceThreshold = {
                    description = "عتبة المتانة التي يُنصح عندها بصيانة كاميرا السرعة.",
                    label = "عتبة الصيانة",
                },
                speedCamMaxDurability = {
                    description = "أقصى متانة لكاميرات السرعة المنشورة.",
                    label = "أقصى متانة",
                },
                speedCamMaxLimit = {
                    description = "أقصى حد سرعة قابل للتهيئة لكاميرا السرعة.",
                    label = "أقصى حد للسرعة",
                },
                speedCamMaxTolerance = {
                    description = "أقصى تسامح قابل للتهيئة لكاميرا السرعة.",
                    label = "أقصى تسامح",
                },
                speedCamPhotoLocale = {
                    description = "اللغة الاختيارية المستخدمة للطابع الزمني على صور كاميرا السرعة. اتركها فارغة لاستخدام اللغة المحلية للاعب الذي التُقطت له الصورة.",
                    label = "لغة الصورة",
                },
                speedCamPhotoTimeZone = {
                    description = "المنطقة الزمنية الاختيارية المستخدمة للطابع الزمني على صور كاميرا السرعة. اتركها فارغة لاستخدام المنطقة الزمنية المحلية للاعب الذي التُقطت له الصورة.",
                    label = "المنطقة الزمنية للصورة",
                },
                speedCamPoliceNotification = {
                    description = "إرسال إشعار استدعاء عندما تلتقط كاميرات السرعة مخالفات.",
                    label = "تنبيه شرطة كاميرا السرعة",
                },
                speedCamPoliceNotificationGroup = {
                    description = "معاملة هدف استدعاء كاميرا السرعة كمجموعة وظيفة.",
                    label = "هدف الاستدعاء مجموعة",
                },
                speedCamPoliceNotificationJob = {
                    description = "مفتاح الوظيفة أو المجموعة المستخدم لإشعارات استدعاء كاميرا السرعة.",
                    label = "هدف الاستدعاء",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "إشعار أهداف استدعاء كاميرا السرعة قيد الخدمة فقط.",
                    label = "الاستدعاء يتطلب الخدمة",
                },
                speedCamPoliceNotificationType = {
                    description = "شدة/نوع الاستدعاء المستخدم لتنبيهات كاميرا السرعة.",
                    label = "نوع الاستدعاء",
                },
                speedCamPropModel = {
                    description = "اسم استدعاء نموذج الكاميرا السليم، مثل sky_speedcam. يحدد الخيار الجاهز أيضًا النموذجين المتضرر والمدمر. يجب أن تكون النماذج المخصصة متاحة داخل اللعبة.",
                    label = "نموذج دعامة كاميرا السرعة",
                    custom = "نموذج مخصص",
                    choose = "اختر نموذجًا",
                    preview = "معاينة ثلاثية الأبعاد",
                    customPlaceholder = "اسم ظهور العنصر",
                    previewDescription = "اعرض العنصر المحدد داخل اللعبة. المعاينة لا تحفظ التغييرات.",
                    invalidModel = "أدخل اسم عنصر صالحًا أولًا.",
                    modelMissing = "هذا النموذج غير متاح داخل اللعبة.",
                    previewFailed = "تعذر فتح معاينة النموذج.",
                    intact = "نموذج العنصر السليم",
                    previewRequiresGame = "افتح /jobconfig في FiveM لعرض العنصر مباشرة.",
                    previewHelp = "الأسهم للتحريك، PageUp/PageDown للارتفاع، عجلة الفأرة للتدوير، Enter للإغلاق، Backspace للإلغاء.",
                    options = {
                        sky_speedcam = "رادار قياسي",
                        sky_germ_speedcam = "رادار ألماني",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "اسم استدعاء نموذج الكاميرا المتضرر، مثل sky_speedcam2. اختر نسخة تتوافق مع النموذج السليم.",
                    label = "نموذج الدعامة التالفة",
                },
                speedCamPropModelDestroyed = {
                    description = "اسم استدعاء النموذج المستخدم عند وصول متانة الكاميرا إلى 0، مثل sky_speedcam1. اختر نسخة تتوافق مع النموذج السليم.",
                    label = "نموذج الدعامة المدمرة",
                },
                speedCamRepairAnimDict = {
                    description = "قاموس الحركة المستخدم أثناء إصلاح كاميرات السرعة.",
                    label = "قاموس حركة الإصلاح",
                },
                speedCamRepairAnimFlag = {
                    description = "علامة الحركة المستخدمة أثناء إصلاح كاميرات السرعة.",
                    label = "علامة حركة الإصلاح",
                },
                speedCamRepairAnimName = {
                    description = "اسم الحركة المستخدم أثناء إصلاح كاميرات السرعة.",
                    label = "اسم حركة الإصلاح",
                },
                speedCamRepairCancelDelayMs = {
                    description = "المللي ثانية قبل إمكانية إلغاء إصلاح كاميرا السرعة.",
                    label = "تأخير إلغاء الإصلاح",
                },
                speedCamRepairDistance = {
                    description = "المسافة المستخدمة لإصلاح كاميرات السرعة.",
                    label = "مسافة الإصلاح",
                },
                speedCamRepairItem = {
                    description = "اسم العنصر الداخلي الدقيق المستخدم للإصلاح، مثل fixtool. أدخل مفتاح العنصر وليس اسم العرض.",
                    label = "اسم عنصر الإصلاح",
                },
                speedCamRepairPerTick = {
                    description = "المتانة المستعادة في كل دورة إصلاح لكاميرا السرعة.",
                    label = "الإصلاح لكل دورة",
                },
                speedCamRepairTickMs = {
                    description = "المللي ثانية بين دورات إصلاح كاميرا السرعة.",
                    label = "دورة الإصلاح",
                },
                speedCamStreamDistance = {
                    description = "المسافة من اللاعب بالأمتار التي تُحمّل ضمنها نماذج الكاميرات. تُزال النماذج من العرض خارج هذه المسافة، وتبقى الكاميرات المحفوظة في أماكنها.",
                    label = "مسافة التحميل",
                },
                speedCamTriggerRadius = {
                    description = "نصف قطر رصد المركبات المسرعة بالأمتار حول الكاميرا.",
                    label = "نصف قطر التفعيل",
                },
                speedCamUseMph = {
                    description = "عرض ومعالجة حدود كاميرا السرعة بوحدة ميل/الساعة.",
                    label = "استخدام MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "الأسلحة المسموح لها بإتلاف كاميرات السرعة أثناء تفعيل التقييد.",
                    itemLabel = "السلاح",
                    label = "الأسلحة المسموحة",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "فقط الأسلحة المدرجة يمكنها إتلاف كاميرات السرعة أثناء تفعيل هذا الخيار.",
                    label = "تفعيل التقييد",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "المسافة بالأمتار قبل إلغاء تحذيرات كاميرا السرعة.",
                    label = "مسافة الإلغاء",
                },
                speedCameraAppDefaultApp = {
                    description = "إظهار تطبيق كاميرا السرعة كتطبيق افتراضي على الجهاز اللوحي.",
                    label = "التطبيق الافتراضي",
                },
                speedCameraAppDescription = {
                    description = "الوصف المعروض لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "الوصف",
                },
                speedCameraAppDeveloper = {
                    description = "تسمية المطور المعروضة لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "المطور",
                },
                speedCameraAppEnabled = {
                    description = "تفعيل تطبيق كاميرا السرعة على الجهاز اللوحي للشرطة.",
                    label = "تطبيق كاميرا السرعة على الجهاز اللوحي",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "العنوان الفرعي العلوي المعروض في تطبيق كاميرا السرعة.",
                    label = "العنوان الفرعي العلوي",
                },
                speedCameraAppHeaderTitle = {
                    description = "عنوان الترويسة المعروض في تطبيق كاميرا السرعة.",
                    label = "عنوان الترويسة",
                },
                speedCameraAppIcon = {
                    description = "مسار الأيقونة المستخدم لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "مسار الأيقونة",
                },
                speedCameraAppIdentifier = {
                    description = "المعرف الداخلي لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "المعرف",
                },
                speedCameraAppInFrontDot = {
                    description = "عتبة الضرب النقطي المستخدمة لتحديد ما إذا كانت كاميرا السرعة أمام اللاعب.",
                    label = "عتبة النقطة الأمامية",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "أدنى سرعة للمركبة بالكيلومتر/الساعة قبل إظهار التحذيرات.",
                    label = "أدنى سرعة للمركبة",
                },
                speedCameraAppName = {
                    description = "الاسم المعروض لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "اسم التطبيق",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "المسافة بالأمتار قبل التنبيه بشأن كاميرات السرعة القريبة.",
                    label = "مسافة التنبيه",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "التحذير من كاميرات السرعة فقط أثناء وجود اللاعب داخل مركبة.",
                    label = "فقط داخل المركبة",
                },
                speedCameraAppOverlayBackground = {
                    description = "لون الخلفية المستخدم لطبقة صورة اللوحة العلوية.",
                    label = "خلفية الطبقة العلوية",
                },
                speedCameraAppOverlayBorder = {
                    description = "لون الحدود المستخدم لطبقة صورة اللوحة العلوية.",
                    label = "حدود الطبقة العلوية",
                },
                speedCameraAppOverlayColor = {
                    description = "لون النص المستخدم لطبقة صورة اللوحة العلوية.",
                    label = "لون الطبقة العلوية",
                },
                speedCameraAppOverlayEnabled = {
                    description = "تفعيل طبقة عرض اللوحة على صور كاميرا السرعة الملتقطة.",
                    label = "تفعيل الطبقة العلوية",
                },
                speedCameraAppOverlayFontScale = {
                    description = "مقياس الخط المستخدم لطبقة صورة اللوحة العلوية.",
                    label = "مقياس خط الطبقة العلوية",
                },
                speedCameraAppOverlayX = {
                    description = "موقع الطبقة العلوية X المُطبَّع من اليسار إلى اليمين.",
                    label = "الطبقة العلوية X",
                },
                speedCameraAppOverlayY = {
                    description = "موقع الطبقة العلوية Y المُطبَّع من الأعلى إلى الأسفل.",
                    label = "الطبقة العلوية Y",
                },
                speedCameraAppRequireInFront = {
                    description = "التحذير فقط من كاميرات السرعة الموجودة أمام اللاعب.",
                    label = "يتطلب أن تكون أمامية",
                },
                speedCameraAppRoute = {
                    description = "مسار التوجيه الذي يفتحه تطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "المسار",
                },
                speedCameraAppSize = {
                    description = "حجم التخزين المُبلغ عنه لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "حجم التطبيق",
                },
                speedCameraAppSoundCoord = {
                    description = "تشغيل أصوات تحذير كاميرا السرعة عند إحداثيات العالم.",
                    label = "صوت الإحداثيات",
                },
                speedCameraAppSoundEnabled = {
                    description = "تفعيل أصوات التحذير لتطبيق كاميرا السرعة.",
                    label = "تفعيل الصوت",
                },
                speedCameraAppSoundFrontend = {
                    description = "تشغيل أصوات تحذير كاميرا السرعة على قناة صوت الواجهة الأمامية.",
                    label = "صوت الواجهة الأمامية",
                },
                speedCameraAppSoundLayers = {
                    description = "عدد طبقات أصوات التحذير التي يشغلها تطبيق كاميرا السرعة.",
                    label = "طبقات الصوت",
                },
                speedCameraAppSoundName = {
                    description = "اسم الصوت المستخدم لتحذيرات تطبيق كاميرا السرعة.",
                    label = "اسم الصوت",
                },
                speedCameraAppSoundRange = {
                    description = "النطاق المستخدم لأصوات تحذير تطبيق كاميرا السرعة.",
                    label = "نطاق الصوت",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "عدد مرات تكرار صوت تحذير كاميرا السرعة.",
                    label = "عدد التكرار",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "المللي ثانية بين تكرارات صوت تحذير كاميرا السرعة.",
                    label = "تأخير التكرار",
                },
                speedCameraAppSoundSet = {
                    description = "مجموعة الصوت المستخدمة لتحذيرات تطبيق كاميرا السرعة.",
                    label = "مجموعة الصوت",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "الحساب المستخدم لمدفوعات اشتراك تطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "الحساب",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "تفعيل الاشتراكات المدفوعة لتطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "تفعيل الاشتراك",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "الأيام بين تجديدات اشتراك تطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "أيام الفاصل",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "السعر المفروض لاشتراك تطبيق كاميرا السرعة على الجهاز اللوحي.",
                    label = "سعر الاشتراك",
                },
                speedCameraAppThemeAccent = {
                    description = "لون التمييز المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "لون التمييز",
                },
                speedCameraAppThemeBackground = {
                    description = "الخلفية المتدرجة الخطية المستخدمة بواسطة تطبيق كاميرا السرعة.",
                    label = "الخلفية",
                },
                speedCameraAppThemeBorder = {
                    description = "لون الحدود المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الحدود",
                },
                speedCameraAppThemeButtonText = {
                    description = "لون نص الزر المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "نص الزر",
                },
                speedCameraAppThemeDanger = {
                    description = "لون الخطر المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الخطر",
                },
                speedCameraAppThemeGhost = {
                    description = "لون الزر الشبحي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الزر الشبحي",
                },
                speedCameraAppThemeGhostText = {
                    description = "لون نص الزر الشبحي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "نص الزر الشبحي",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "لون التدرج الناعم المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "التدرج الناعم",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "لون الحدود غير النشطة المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الحدود غير النشطة",
                },
                speedCameraAppThemeModal = {
                    description = "لون خلفية النافذة المنبثقة المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "النافذة المنبثقة",
                },
                speedCameraAppThemeMutedText = {
                    description = "لون النص الخافت المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "النص الخافت",
                },
                speedCameraAppThemeOverlay = {
                    description = "لون الطبقة العلوية المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الطبقة العلوية",
                },
                speedCameraAppThemePillText = {
                    description = "لون نص شارة الحبة المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "نص شارة الحبة",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "لون بداية التدرج الأساسي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "بداية التدرج الأساسي",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "لون نهاية التدرج الأساسي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "نهاية التدرج الأساسي",
                },
                speedCameraAppThemeShadow = {
                    description = "لون الظل المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "الظل",
                },
                speedCameraAppThemeSpotlight = {
                    description = "لون تمييز بؤرة الضوء المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "بؤرة الضوء",
                },
                speedCameraAppThemeSubtleText = {
                    description = "لون النص الثانوي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "النص الثانوي",
                },
                speedCameraAppThemeSuccess = {
                    description = "لون النجاح المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "النجاح",
                },
                speedCameraAppThemeSurface = {
                    description = "لون السطح المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "السطح",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "لون السطح الناعم المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "السطح الناعم",
                },
                speedCameraAppThemeText = {
                    description = "لون النص الأساسي المستخدم بواسطة تطبيق كاميرا السرعة.",
                    label = "النص",
                },
                speedCameraAppWarningUiAccent = {
                    description = "لون تمييز RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "تمييز RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "لون RGBA المستخدم لخلفية واجهة تحذير كاميرا السرعة.",
                    label = "خلفية RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "لون أيقونة RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "أيقونة RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "لون نص الأيقونة RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "نص الأيقونة RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "الثواني التي تبقى فيها واجهة التحذير مرئية.",
                    label = "ثواني واجهة التحذير",
                },
                speedCameraAppWarningUiSubText = {
                    description = "لون النص الفرعي RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "النص الفرعي RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "لون النص RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "النص RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "لون العنوان RGBA المستخدم لواجهة تحذير كاميرا السرعة.",
                    label = "العنوان RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "المللي ثانية بين فحوصات قرب مسامير تفجير الإطارات.",
                    label = "فاصل الفحص",
                },
                spikeStripsEnabled = {
                    description = "تفعيل مسامير تفجير الإطارات المنشورة.",
                    label = "مسامير تفجير الإطارات",
                },
                spikeStripsModels = {
                    description = "نماذج الدعامات التي تُعامل كمسامير تفجير إطارات نشطة.",
                    itemLabel = "النموذج",
                    label = "النماذج",
                },
                spikeStripsRetryIntervalMs = {
                    description = "المللي ثانية قبل إعادة محاولة مسح مسامير تفجير الإطارات بعد عدم التطابق.",
                    label = "فاصل إعادة المحاولة",
                },
                spikeStripsScanDistance = {
                    description = "المسافة المستخدمة للمسح بحثاً عن مسامير تفجير الإطارات القريبة.",
                    label = "مسافة المسح",
                },
                spikeStripsTriggerDistance = {
                    description = "المسافة التي يتم عندها تفجير الإطارات بواسطة مسمار تفجير الإطارات.",
                    label = "مسافة التفعيل",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "تسمية الفئة المستخدمة لعلامات منشئ المحطات على الخريطة.",
                    label = "فئة علامة المحطة",
                },
                stationCreatorBlipColor = {
                    description = "لون علامة الخريطة المستخدم لمحطات الشرطة.",
                    label = "لون علامة المحطة",
                },
                stationCreatorBlipScale = {
                    description = "الحجم المستخدم لعلامات محطات الشرطة.",
                    label = "حجم علامة المحطة",
                },
                stationCreatorBlipShortRange = {
                    description = "إظهار علامات المحطة فقط على مدى قصير.",
                    label = "علامة المحطة قصيرة المدى",
                },
                stationCreatorBlipSprite = {
                    description = "رمز العلامة على الخريطة المستخدم لمحطات الشرطة.",
                    label = "رمز علامة المحطة",
                },
                stationCreatorBlipUseStationName = {
                    description = "استخدام اسم المحطة المهيأ كتسمية لعلامة الخريطة.",
                    label = "استخدام اسم المحطة",
                },
                tabletAutoFillCitizens = {
                    description = "تعبئة سجل المواطنين مسبقاً من قاعدة بيانات الإطار.",
                    label = "التعبئة التلقائية للمواطنين",
                },
                tabletAutoFillVehicles = {
                    description = "تعبئة سجل المركبات مسبقاً من قاعدة بيانات الإطار.",
                    label = "التعبئة التلقائية للمركبات",
                },
                tabletBolos = {
                    description = "إظهار تطبيق بلاغات البحث.",
                    label = "بلاغات البحث (BOLO)",
                },
                tabletCases = {
                    description = "إظهار تطبيق القضايا.",
                    label = "القضايا",
                },
                tabletCitizens = {
                    description = "إظهار تطبيق سجل المواطنين.",
                    label = "المواطنون",
                },
                tabletConfiscations = {
                    description = "إظهار سجل الأغراض المصادرة أثناء تفتيش الأشخاص.",
                    label = "المصادرات",
                },
                tabletOffences = {
                    description = "إظهار تطبيق المخالفات.",
                    label = "المخالفات",
                },
                tabletPrison = {
                    description = "إظهار تطبيق السجن.",
                    label = "السجن",
                },
                tabletReportEnforcement = {
                    description = "السماح بربط المخالفات وإصدار الغرامات أو أحكام السجن من التقارير المحفوظة.",
                    label = "تنفيذ أحكام التقارير",
                },
                tabletReports = {
                    description = "إظهار تطبيق التقارير.",
                    label = "التقارير",
                },
                tabletSocialWork = {
                    description = "إظهار تطبيق العمل الاجتماعي.",
                    label = "العمل الاجتماعي",
                },
                tabletVehicles = {
                    description = "إظهار تطبيق سجل المركبات.",
                    label = "المركبات",
                },
                tabletWarrants = {
                    description = "إظهار تطبيق مذكرات التوقيف.",
                    label = "مذكرات التوقيف",
                },
                tabletWeapons = {
                    description = "إظهار تطبيق سجل الأسلحة.",
                    label = "الأسلحة",
                },
                tackleCuffKey = {
                    label = "تكبيل الشخص المطروح",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                tackleKey = {
                    label = "طرح الشخص أرضًا",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                tackleReleaseKey = {
                    label = "إطلاق سراح الشخص المطروح",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "المللي ثانية قبل إمكانية إطلاق تنبيه رادار آخر.",
                    label = "فترة انتظار التنبيه",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "فئات المركبات المسموح لها باستخدام الرادار.",
                    label = "فئات المركبات المسموحة",
                },
                vehicleRadarAutoFastLock = {
                    description = "وضع علامة تلقائياً على الأهداف السريعة جداً في الرادار.",
                    label = "القفل السريع التلقائي",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "عتبة السرعة المستخدمة للقفل السريع التلقائي.",
                    label = "عتبة القفل السريع",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "ربط المفتاح المستخدم لخفض حد سرعة الرادار.",
                    label = "مفتاح خفض الحد",
                },
                vehicleRadarDefaultLimit = {
                    description = "حد السرعة الافتراضي المستخدم بواسطة رادار المركبة.",
                    label = "حد الرادار الافتراضي",
                },
                vehicleRadarEnabled = {
                    description = "تفعيل رادار مركبة الدورية.",
                    label = "رادار المركبة",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "ربط المفتاح المستخدم لزيادة حد سرعة الرادار.",
                    label = "مفتاح زيادة الحد",
                },
                vehicleRadarLimitStep = {
                    description = "المقدار الذي يتغير في كل تعديل لحد الرادار.",
                    label = "خطوة الحد",
                },
                vehicleRadarLockFrontKey = {
                    description = "ربط المفتاح المستخدم لقفل هدف الرادار الأمامي.",
                    label = "مفتاح القفل الأمامي",
                },
                vehicleRadarLockRearKey = {
                    description = "ربط المفتاح المستخدم لقفل هدف الرادار الخلفي.",
                    label = "مفتاح القفل الخلفي",
                },
                vehicleRadarMaxLimit = {
                    description = "أقصى حد سرعة مسموح به في رادار المركبة.",
                    label = "أقصى حد للرادار",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "أقصى ميلان مسموح به لاستهداف الرادار.",
                    label = "أقصى درجات الميلان",
                },
                vehicleRadarMinLimit = {
                    description = "أدنى حد سرعة مسموح به في رادار المركبة.",
                    label = "أدنى حد للرادار",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "أدنى سرعة قبل أن يعتبر الرادار الهدف صالحاً.",
                    label = "أدنى سرعة للهدف",
                },
                vehicleRadarModeFrontKey = {
                    description = "ربط المفتاح المستخدم للتبديل إلى وضع الرادار الأمامي.",
                    label = "مفتاح الوضع الأمامي",
                },
                vehicleRadarModeRearKey = {
                    description = "ربط المفتاح المستخدم للتبديل إلى وضع الرادار الخلفي.",
                    label = "مفتاح الوضع الخلفي",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "المللي ثانية بين عمليات مسح الرادار أثناء تحرك مركبة الدورية.",
                    label = "فاصل المسح أثناء الحركة",
                },
                vehicleRadarPassengerControl = {
                    description = "السماح للركاب بالتحكم في رادار المركبة.",
                    label = "تحكم الراكب",
                },
                vehicleRadarPassengerEnabled = {
                    description = "السماح للركاب بعرض بيانات الرادار المعكوسة.",
                    label = "مرآة الراكب",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "المللي ثانية بين تحديثات مزامنة الرادار للركاب.",
                    label = "فاصل مزامنة الراكب",
                },
                vehicleRadarProjectionThreshold = {
                    description = "عتبة الإسقاط المستخدمة عند تقييم أهداف الرادار.",
                    label = "عتبة الإسقاط",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "يتطلب خط رؤية واضحاً قبل أن يقفل الرادار على هدف.",
                    label = "يتطلب خط رؤية",
                },
                vehicleRadarRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل استخدام رادار المركبة.",
                    label = "الرادار يتطلب الخدمة",
                },
                vehicleRadarScanIntervalMs = {
                    description = "المللي ثانية بين عمليات مسح الرادار الثابت.",
                    label = "فاصل المسح",
                },
                vehicleRadarScanRadius = {
                    description = "نصف قطر مسح رادار المركبة.",
                    label = "نصف قطر المسح",
                },
                vehicleRadarToggleKey = {
                    description = "ربط المفتاح المستخدم لتبديل رادار المركبة.",
                    label = "مفتاح التبديل",
                },
                vehicleRadarUseMph = {
                    description = "عرض قيم سرعة الرادار بوحدة ميل/الساعة.",
                    label = "الرادار يستخدم MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "المللي ثانية بين تحديثات مجمع المركبات القريبة.",
                    label = "تحديث مجمع المركبات",
                },
                vehicleRadarXmitFrontKey = {
                    description = "ربط المفتاح المستخدم للإرسال/التعليق الأمامي للرادار.",
                    label = "مفتاح الإرسال الأمامي",
                },
                vehicleRadarXmitRearKey = {
                    description = "ربط المفتاح المستخدم للإرسال/التعليق الخلفي للرادار.",
                    label = "مفتاح الإرسال الخلفي",
                },
                wheelClampConsumeItem = {
                    description = "إزالة عنصر قفل العجلة بعد وضعه.",
                    label = "استهلاك عنصر القفل",
                },
                wheelClampEnabled = {
                    description = "تفعيل إجراء قفل العجلة.",
                    label = "قفل العجلة",
                },
                wheelClampItem = {
                    description = "عنصر الحقيبة المستخدم لوضع قفل العجلة.",
                    label = "عنصر القفل",
                },
                wheelClampPropModel = {
                    description = "نموذج الدعامة المستخدم لقفل العجلة الموضوع.",
                    label = "نموذج دعامة القفل",
                },
                wheelClampRequireItem = {
                    description = "يتطلب عنصر قفل العجلة المهيأ. أبقِ هذا مفعلاً عندما يكون وضع استخدام القفل مضبوطاً على الحقيبة أو كليهما.",
                    label = "القفل يتطلب عنصراً",
                },
                wheelClampRequireOnDuty = {
                    description = "يتطلب حالة الخدمة قبل وضع أقفال العجلات.",
                    label = "القفل يتطلب الخدمة",
                },
                wheelClampTyreDistance = {
                    description = "أقصى مسافة إلى الإطار عند وضع القفل أو لحامه.",
                    label = "مسافة الإطار",
                },
                wheelClampUseItem = {
                    description = "استخدام القائمة الدائرية أو الحقيبة أو كليهما لوضع قفل العجلة. يجب اقتران الحقيبة أو كليهما مع «القفل يتطلب عنصراً».",
                    label = "وضع استخدام القفل",
                    options = {
                        both = "كلاهما",
                        inventory = "الحقيبة",
                        radial = "القائمة الدائرية",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "أقصى مسافة إلى المركبة المستهدفة عند وضع القفل.",
                    label = "مسافة المركبة",
                },
                wheelClampWeldBurstTyre = {
                    description = "تفجير الإطار بعد لحام القفل وإزالته.",
                    label = "تفجير الإطار",
                },
                wheelClampWeldDurationMs = {
                    description = "المللي ثانية المطلوبة لإزالة القفل عن طريق اللحام.",
                    label = "مدة اللحام",
                },
                wheelClampWeldEnabled = {
                    description = "السماح بإزالة أقفال العجلات باستخدام أداة لحام.",
                    label = "لحام القفل",
                },
                wheelClampWeldItem = {
                    description = "عنصر الحقيبة المطلوب للحام القفل.",
                    label = "عنصر أداة اللحام",
                },
                wheelClampWeldMinigame = {
                    description = "تتطلب لعبة لحام القفل المصغرة قبل اكتمال الإزالة.",
                    label = "لعبة اللحام المصغرة",
                },
                ziptiesConsumeItem = {
                    description = "إزالة عنصر رباط بلاستيكي عند تطبيقه.",
                    label = "استهلاك الأربطة البلاستيكية",
                },
                ziptiesCutterConsumeItem = {
                    description = "إزالة عنصر القاطعة بعد قطع الأربطة البلاستيكية.",
                    label = "استهلاك عنصر القاطعة",
                },
                ziptiesCutterEnabled = {
                    description = "السماح بقاطعات الأسلاك لإزالة الأربطة البلاستيكية.",
                    label = "قاطعة الأربطة البلاستيكية",
                },
                ziptiesCutterItem = {
                    description = "عنصر الحقيبة المستخدم لقطع الأربطة البلاستيكية.",
                    label = "عنصر القاطعة",
                },
                ziptiesEnabled = {
                    description = "تفعيل إجراءات الأربطة البلاستيكية.",
                    label = "الأربطة البلاستيكية",
                },
                ziptiesItem = {
                    description = "عنصر الحقيبة المستخدم لإجراءات الأربطة البلاستيكية.",
                    label = "عنصر الرباط البلاستيكي",
                },
                ziptiesRequireHandsUp = {
                    description = "يتطلب حالة رفع اليدين قبل تطبيق الأربطة البلاستيكية.",
                    label = "الأربطة البلاستيكية تتطلب رفع اليدين",
                },
                ziptiesRequireItem = {
                    description = "يتطلب عنصر الرباط البلاستيكي المهيأ.",
                    label = "الأربطة البلاستيكية تتطلب عنصراً",
                },
                ziptiesReturnOnRemove = {
                    description = "إعادة عنصر الرباط البلاستيكي عند إزالته.",
                    label = "إعادة الأربطة البلاستيكية",
                },
                evidenceGsrDurationSeconds = {
                    description = "تبقى بقايا طلقات نارية ثانية على أيدي لاعب.",
                    label = "مدة GSR",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "منع GSR من التطبيق عندما يرتدي مطلق النار قفازات.",
                    label = "قفازات حماية اليدين",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "الأسلحة التي لا تطبق بقايا الطلقات النارية.",
                    label = "الأسلحة المتجاهلة",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "ميلي ثانية بين فحوصات تنظيف المياه / المطر بينما GSR نشط.",
                    label = "غسل الفاصل الزمني الاختيار غسل",
                },
                evidenceGsrWashInRain = {
                    description = "السماح المطر لإزالة بقايا الطلقات النارية.",
                    label = "غسل في المطر",
                },
                evidenceGsrWashInWater = {
                    description = "السماح للماء لإزالة بقايا الطلقات النارية.",
                    label = "غسل في الماء",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam يظهر لوحة وهمية",
                    description = "يعرض لوحة وهمية في كاميرا طائرة هليكوبتر.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "تظهر الأدوات العادية لوحة وهمية",
                    description = "يعرض لوحة وهمية في أدوات الشرطة القياسية.",
                },
                fakePlateRadarDisplay = {
                    label = "يظهر الرادار لوحة وهمية",
                    description = "يعرض لوحة وهمية على الرادار على متن الطائرة.",
                },
                fakePlateRecognitionEnabled = {
                    description = "اسمح لأنظمة الشرطة بقراءة الحقيبة المزورة المشتركة.",
                    label = "التعرف على لوحات وهمية",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "مفتاح حقيبة كيان السيارة التي نشرتها Mechanicjob.",
                    label = "مفتاح حقيبة الدولة",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam يظهر لوحة وهمية",
                    description = "يعرض لوحة وهمية في تقارير الرادار الثابتة.",
                },
                fakePlateVinAllowedGrades = {
                    description = "المهنة / الصف الاختياري قائمة السماح. اتركها فارغة للسماح لجميع درجات المهن المسموح بها.",
                    label = "VIN الدرجات",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN مهن",
                    description = "المهن المسموح لها باستخدام التحقق VIN.",
                },
                fakePlateVinAudit = {
                    label = "مراجعة الحسابات VIN الشيكات",
                    description = "يحفظ VIN الشيكات إلى سجل مراجعة الحسابات.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN تحقق تمكين",
                    description = "تمكين قيادة التحقق من السيارة VIN.",
                },
                fakePlateVinCommand = {
                    label = "VIN أمر",
                    description = "القيادة المستخدمة للتحقق من مركبة VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN كولدوون",
                    description = "تأخير بين اثنين من الشيكات VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN أقصى مسافة",
                    description = "المسافة القصوى بين الضابط والمركبة للتحقق من VIN.",
                },
                fakePlateVinIndicator = {
                    label = "اعرض مؤشر مزيف",
                    description = "يعرض مؤشرًا عندما يكتشف الاختيار لوحة مزيفة.",
                },
                fakePlateVinRequireDuty = {
                    label = "يتطلب واجبًا",
                    description = "يتطلب من الضابط أن يكون على واجب للتحقق من VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "تتطلب عنصر الماسح الضوئي",
                    description = "يتطلب كائن الماسح الضوئي تكوين للتحقق من VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "بند الماسح الضوئي",
                    description = "عنصر المخزون المطلوب للتحقق من VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "وضع السجين للعاطلين عن العمل عندما يتم سجنهم.",
                    label = "إزالة مهنة في السجن",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "استعادة مهنة السجين الأصلية بعد الإفراج عنه. عاجزة عن إبقائهم عاطلين عن العمل.",
                    label = "استعادة المهنة الأصلية",
                },
                primaryColor = {
                    description = "اللون الافتراضي لمجموعة وظائف الشرطة.",
                    label = "اللون الأساسي",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "السماح للمراجعين بفاتورة المالك المسجل حتى عندما يتم وضع علامة على اللوحة التي تم التقاطها على أنها مزيفة أو مستنسخة.",
                    label = "السماح لوحات وهمية يشتبه",
                },
                speedCamAdvancedPageSize = {
                    description = "الحد الأقصى لالتقاط عاد لكل صفحة قرص.",
                    label = "مراجعة حجم الصفحة",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "جوانب السيارة التي يمكن استخدام صورها للتعرف على اللوحة. استخدم الأمامي و / أو الخلفي.",
                    itemLabel = "الجانب",
                    label = "الجوانب المعترف بها",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "لا تسمح بالموافقة إلا بعد اكتمال تحميل صورة كاميرا السرعة.",
                    label = "تتطلب أدلة الصورة",
                },
                speedCamAdvancedReviewPermission = {
                    description = "إذن Bossmenu المطلوب للموافقة أو تجاهل التقاطات. 18 هو إدارة الفواتير.",
                    label = "إذن مراجعة ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "الاحتفاظ بالتقاطات التي لوحة غير موجودة في قاعدة بيانات المركبات المسجلة.",
                    label = "تخزين المركبات غير المسجلة",
                },
                tabletSpeedcamReviews = {
                    description = "أظهر تطبيق مراجعة كاميرا السرعة المتقدمة عند تمكين الوضع المتقدم.",
                    label = "استعراض كاميرا السرعة",
                },
                tackleCommand = {
                    description = "القيادة مسجلة للتعامل مع أقرب شخص. أدخل اسم الأمر دون مائل.",
                    label = "التعامل مع الأوامر",
                },
                tackleCuffCommand = {
                    description = "القيادة المسجلة لتقييد الشخص المحتجز حاليا بعد معالجة. أدخل اسم الأمر دون شرطة مائلة.",
                    label = "معالجة أمر الكفة",
                },
                tackleCuffDescription = {
                    description = "الوصف المعروض لربط الكفة في قائمة الارتباطات الرئيسية FiveM.",
                    label = "معالجة الكفة كيبيند الوصف",
                },
                tackleDescription = {
                    description = "الوصف المعروض لربط المعالجة في قائمة الارتباطات الرئيسية FiveM.",
                    label = "معالجة keybind الوصف",
                },
                tackleEnabled = {
                    description = "تفعيل التعامل مع أقرب شخص والاحتفاظ بها على الأرض.",
                    label = "طرح الشخص أرضًا",
                },
                tackleMaxDistance = {
                    description = "المسافة القصوى إلى الهدف عند بدء معالجة.",
                    label = "معالجة المسافة",
                },
                tackleNeedsSprint = {
                    description = "تتطلب من الضابط أن يركض قبل التعامل مع شخص.",
                    label = "معالجة يتطلب الركض",
                },
                tackleReleaseCommand = {
                    description = "القيادة المسجلة لإطلاق سراح الشخص المحتجز حاليا بعد معالجة. أدخل اسم الأمر دون شرطة مائلة.",
                    label = "معالجة أمر الإفراج",
                },
                tackleReleaseDescription = {
                    description = "الوصف المعروض لإصدار معالجة ملزمة في قائمة الارتباطات الرئيسية FiveM.",
                    label = "معالجة الافراج عن وصف keybind",
                },
                tackleRequireOnDuty = {
                    description = "تتطلب واجب الدولة قبل ضابط يمكن التعامل مع شخص.",
                    label = "معالجة يتطلب واجب",
                },
                vehicleRadarCustomizeCommand = {
                    description = "يستخدم الأمر لفتح أو إغلاق محرر تخطيط الرادار. أدخل اسم الأمر بدون شرطة مائلة.",
                    label = "أمر تخطيط الرادار",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "يستخدم الأمر لاستعادة تخطيط الرادار الافتراضي. أدخل اسم الأمر بدون شرطة مائلة.",
                    label = "إعادة تعيين أمر تخطيط الرادار",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "يسمح للموظفين بتسجيل أنفسهم في الدورات التدريبية المتاحة.",
                approvalRequired = "يبقي التسجيلات الذاتية معلقة حتى يوافق عليها مدرس معتمد.",
                defaultCapacity = "العدد الافتراضي للمقاعد المستخدمة عند إنشاء جلسة تدريب جديدة.",
                enabled = "يجعل تطبيق التدريب متاحًا لهذه الوظيفة.",
                requireOnDuty = "يتطلب من الموظفين أن يكونوا في الخدمة قبل فتح تطبيق التدريب أو استخدامه.",
                upcomingDays = "عدد الأيام المستقبلية الموضحة في جدول تطبيق التدريب.",
            },
            trainingFields = {
                allowSelfEnrollment = "السماح بالتسجيل الذاتي",
                approvalRequired = "يتطلب موافقة التسجيل",
                defaultCapacity = "السعة الافتراضية",
                enabled = "تمكين التدريب",
                requireOnDuty = "يتطلب واجبًا",
                upcomingDays = "الفترة القادمة (أيام)",
            },
            locationDescriptions = {
                jail_public_blip = "يُحدد الموقع تلقائيًا من نقطة ظهور السجناء، أو من أول محطة للسجن إذا لم تُضبط نقطة الظهور.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "تستهلك الأصفاد ليس له أي تأثير في حين يتم تعطيل شرط البند الكفة.",
                wheelClampUseItemRequiresItem = "وضع استخدام المشبك المخزون أو كلا يتطلب المشبك يتطلب البند للبقاء تمكين.",
                ziptiesConsumeRequiresItem = "zipties الاستهلاك ليس له أي تأثير في حين يتم تعطيل شرط البند ziptite.",
            },
        },
    },
    JobConfiguratorImportFailed = "فشل استيراد قيم config.lua لـ '%s': %s.",
    JobConfiguratorImportHistoryFailed = "نجحت عملية الاستيراد ، لكن لم يتم حفظ إدخال تاريخها.",
    JobConfiguratorImportNoData = "'%s' لا يوفر بيانات استيراد config.lua.",
    JobConfiguratorImportSuccess = "قيم config.lua المستوردة لـ '%s': %d المهن ، وإعداد %d ، وميزة %d ، وانحرافات التفاعل %d المطبقة.",
    JobConfiguratorTitle = "تهيئة الوظائفa40074848905d12c107f984aac5d9776",
    JobConfiguratorUnknown = "غير معروف التكوين المهنة.",
}
