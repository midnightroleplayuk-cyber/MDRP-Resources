JobConfigLocales["sky_mechanicjob:ar"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "منشأة داينو متنقل",
                    entryPluralLabel = "منشآت الداينو المتنقل",
                    label = "منشآت الداينو المتنقل",
                },
                workshops = {
                    entryLabel = "ورشة عمل",
                    entryPluralLabel = "ورش العمل",
                    label = "ورش العمل",
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
                crewCapacity = "أقصى عدد من الأفراد الذين يمكنهم شغل الوحدة. استخدم 0 لطاقم غير محدود.",
                joinLocked = "يمنع أفرادًا إضافيين من الانضمام بعد شغل الوحدة.",
                minimumCrew = "الحد الأدنى لعدد الأفراد في الوحدات المختارة لخطة الاستجابة.",
                poiId = "معرّف تقني ثابت يمكن لملفات المحطات الرجوع إليه حتى بعد تغيير اسم نقطة الاهتمام.",
                readyStatusCode = "حالة FMS التي تُطبّق عندما يصبح المورد جاهزًا للتوجيه.",
                resourceType = "يصنّف المورد التشغيلي لاستخدامه في مرشحات مركز التوجيه والتنسيق.",
                respondingStatusCode = "حالة FMS التي تُطبّق عندما يستجيب المورد لبلاغ.",
                shortLabel = "اسم مختصر اختياري يظهر على أزرار ذاكرة قنوات الراديو الستة.",
                stationId = "يربط هذه الوحدة بمحطة مضبوطة في ملف مركز التوجيه.",
                unitId = "معرّف تقني ثابت يحافظ على الوحدة حتى عند تغيير نداء الراديو.",
                autoAlarm = "يقوم فورًا بتعيين الوحدات المطابقة المتاحة عند إنشاء حادثة.",
                available = "قد يتم اقتراح الوحدات في هذه الحالة وتعيينها لحادث جديد.",
                averageResponseSpeedKmh = "لحساب تقدير الوصول المعروض من مسافة الخط المستقيم.",
                callsign = "تظهر إشارة نداء الراديو الفريدة عندما يقوم اللاعبون بتوظيف هذه الوحدة الافتراضية.",
                centerEnabled = "يسمح للأعضاء المناوبين المعتمدين بتوظيف مركز إرسال.",
                channelId = "معرف قناة الراديو لـ PMA Voice وSaltyChat وYACA. تظل المعرفات الرقمية مثل 2500 دون تغيير؛ يقوم PMA Voice بتعيين معرفات نصية إلى رقم ثابت.",
                channelLabel = "يظهر اسم القناة المقروء للمرسلين والوحدات.",
                defaultChannel = "ينضم المرسلون إلى هذه القناة عند بدء مناوبتهم. تنضم الوحدات يدويًا من علامة التبويب \"الراديو\". حدد لا شيء لاستخدام الإعداد الافتراضي لمجموعة المهام.",
                emergencyAppEnabled = "يجعل هذه الوظيفة قابلة للتحديد كخدمة عامة في تطبيق هاتف الطوارئ.",
                enabled = "يجعل هذه الوظيفة متاحة لتطبيق Dispatch والحوادث المشتركة بين الوظائف.",
                icon = "حدد الرمز الموضح لفئة الوحدة هذه في تطبيق Dispatch.",
                incidentAssessmentEnabled = "يعرض الأسئلة الطبية وتقييم المخاطر في تناول الحادث بالكامل.",
                jobs = "أسماء الوظائف الإضافية التي تتلقى حوادث باستخدام هذه الكلمة الأساسية.",
                noUnitFallback = "بدون مركز أو وحدة عاملة، يرسل إشعار Sky إلى جميع الأعضاء المناوبين.",
                radius = "أقصى مسافة بالأمتار يمكن من خلالها سماع إعلان المحطة.",
                requirements = "طلب الاستجابة كأزواج TYPE:COUNT، على سبيل المثال PATROL:2،CRIME:1.",
                statusCode = "تظهر حالة FMS الرقمية على الراديو المحمول باليد.",
                statusLabel = "معنى حالة FMS للمرسلين والوحدات.",
                vehicleType = "يجب أن يتطابق مع رمز نوع السيارة الذي تم تكوينه في القسم الفرعي السابق.",
                vehicleTypeCode = "رمز الوحدة القصير المستخدم في متطلبات الاستجابة، على سبيل المثال PATROL أو CRIME أو EMS أو RESCUE.",
                vehicleTypeLabel = "الاسم المقروء لفئة الوحدة هذه.",
            },
            dispatchFields = {
                crewCapacity = "سعة الطاقم",
                joinLocked = "قفل انضمام الطاقم",
                minimumCrew = "الحد الأدنى للطاقم",
                poiId = "معرّف نقطة الاهتمام الثابت",
                readyStatusCode = "رمز حالة الجاهزية",
                resourceType = "نوع المورد",
                respondingStatusCode = "رمز حالة الاستجابة",
                shortLabel = "اسم ذاكرة الراديو",
                stationId = "معرّف المحطة",
                unitId = "معرّف الوحدة الثابت",
                address = "العنوان",
                autoAlarm = "إنذار تلقائي",
                available = "متاح للإرسال",
                averageResponseSpeedKmh = "سرعة الاستجابة المقدرة (كم/ساعة)",
                callsign = "إشارة النداء",
                category = "الفئة",
                centerEnabled = "تمكين مركز الإرسال",
                channelId = "معرف القناة",
                code = "الكود",
                defaultChannel = "قناة الراديو الافتراضية",
                emergencyAppEnabled = "عرض في تطبيق الطوارئ",
                enabled = "تمكين الإرسال",
                icon = "أيقونة",
                incidentAssessmentEnabled = "تمكين تقييم الطوارئ",
                jobs = "المهام المستهدفة (مفصولة بفواصل)",
                keywordCode = "رمز الكلمة الرئيسية",
                label = "التسمية",
                name = "الاسم",
                noUnitFallback = "قم بإخطار الموظفين المناوبين بدون وحدات",
                noneChannel = "لا يوجد / المجموعة الافتراضية",
                note = "ملاحظة",
                phone = "الهاتف",
                radius = "نطاق الإعلان",
                requirements = "الوحدات المطلوبة (على سبيل المثال PATROL:2,CRIME:1)",
                type = "النوع",
                vehicleType = "نوع وحدة الاستجابة",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "المبلّغون المعروفون",
                    channels = "قنوات الاتصال",
                    plans = "خطط الاستجابة",
                    statuses = "حالات FMS المتاحة",
                    units = "وحدات افتراضية",
                },
                active = "مركز البلاغات مفعّل",
                description = "اضبط استقبال البلاغات الطارئة والاتصالات اللاسلكية والوحدات وخطط الاستجابة والمواقع وبيانات المبلّغين لهذه الوظيفة.",
                inactive = "مركز البلاغات معطّل",
                steps = {
                    accessText = "فعّل مركز البلاغات وحدد ما إذا كان بإمكان موظفي هذه الوظيفة العمل فيه.",
                    accessTitle = "الوصول واستقبال البلاغات",
                    fleetText = "اضبط قنوات الاتصال ورموز حالة FMS وأنواع المركبات ونداءات الوحدات.",
                    fleetTitle = "الاتصالات والأسطول",
                    responseText = "أكمل الإعداد بالكلمات المفتاحية ومتطلبات الاستجابة ونقاط الاهتمام.",
                    responseTitle = "خطط الاستجابة",
                },
                title = "مركز البلاغات",
                warnings = {
                    channels = "لا توجد قنوات اتصال محددة؛ ستُستخدم القناة الاحتياطية لمجموعة الوظائف.",
                    defaultChannel = "القناة الافتراضية المحددة لم تعد موجودة.",
                    disabled = "مركز البلاغات معطّل لهذه الوظيفة.",
                    statuses = "يجب أن تتوفر حالة FMS واحدة على الأقل حتى يمكن استنفار الوحدات.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "يدير أسماء المبلّغين وأرقام معاودة الاتصال وملاحظات مركز التوجيه الخاصة بالوظيفة.",
                dispatchChannels = "يحدد قنوات الراديو التي يمكن للوحدات ومراكز إرسال الموظفين الانضمام إليها.",
                dispatchKeywords = "يحدد الكلمات الرئيسية للحوادث، وأعداد المركبات المطلوبة، والمهام المشاركة، والإنذار التلقائي الاختياري.",
                dispatchPois = "يقوم بتخزين المحطات والمواقع المشتركة لنماذج الحوادث وإعلانات المحطات القائمة على الموقع.",
                dispatchStatusCodes = "يقوم بتكوين تسميات حالة FMS والحالات التي تعتبر متاحة للحوادث الجديدة.",
                dispatchVehicleTypes = "يحدد فئات الوحدات المستخدمة بواسطة خطط الاستجابة، مثل الدورية أو وحدة الجريمة أو EMS أو الإنقاذ.",
                dispatchVehicles = "يحدد مركبات الإرسال الافتراضية التي يمكن تجهيزها من أي مكان دون الحاجة إلى مركبة منشورة.",
            },
            diagnosticsSettings = {
                enabledLabel = "تفعيل تشخيص المركبات",
                enabledDescription = "السماح لهذه الوظيفة بفتح تشخيص المركبات وإصلاح الأجزاء من خلاله.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "تشخيص المركبات",
                    description = "إعداد إمكانية الوصول إلى تشخيص المركبات لهذه الوظيفة.",
                },
                dispatchReporters = "المبلّغون المعروفون",
                invalidSelection = "اختيار غير صالح: {value}",
                billingPrices = {
                    description = "تكوين أسعار الفاتورة لإدخالات تاريخ الصيانة والإصلاح. يتم مطابقة مفتاح الإجراء مع action_key أو action_type أو علامة العمل.",
                    label = "أسباب الفواتير",
                },
                billingSettings = {
                    description = "تكوين سلوك الفوترة ميكانيكي لهذه المهنة.",
                    label = "الفواتير",
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
                partsDeliveryShop = "قم بتسليم القطع إلى المتجرa40074848905d12c107f984aac5d9776",
                trainingSettings = {
                    description = "قم بتكوين الوصول إلى التدريب والتسجيل والموافقات وتخطيط الدورة التدريبية لهذه الوظيفة.",
                    label = "إعدادات التدريب",
                },
                tuningCostProfile = {
                    description = "قم بتهيئة تكاليف الأداء، والمظهر، والعناصر، والخيارات الخاصة بهذه الوظيفة. a40074848905d12c107f984aac5d9776تدعم التكاليف مصفوفات العناصر الأساسية وكائنات المراحل الترقية.a40074848905d12c107f984aac5d9776",
                    label = "ضبط الأسعارa40074848905d12c107f984aac5d9776",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "الكاميرا الحرة في قائمة التعديل",
                    description = "السماح بإخفاء المؤشر بمفتاح المسافة لتحريك الكاميرا بحرية. يظل Escape يغلق القائمة.",
                },
                tuningCamera = {
                    description = "توجيه الكاميرا تلقائياً نحو الجزء المحدد. عند التعطيل تبقى كاميرا اللعب العادية.",
                    label = "كاميرا التعديل التلقائية",
                },
                jgMileage = {
                    description = "استخدم JG Vehicle Mileage كمصدر للمسافة عندما يكون المورد قيد التشغيل. بخلاف ذلك تُستخدم مسافة Sky. يتم إعداد JG HUD بشكل منفصل.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "اعرض المسافة المحددة في JG HUD. يعمل دون JG Vehicle Mileage؛ ثبّت محول HUD حسب README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "تفعيل محرر المسؤول وقواعد التحكم التلقائية للوحات والطرازات. بعد التعطيل، أعد إخراج المركبات المتأثرة من المرآب لإزالة القيم المطبقة سابقًا.",
                    label = "محرر التحكم",
                },
                kuv = {
                    description = "بدء الفحص الفني",
                    label = "الفحص الفني للمركبة",
                },
                mobileDyno = {
                    description = "تفعيل جهاز قياس القوة المتنقل ولوحتي التحكم والنتائج ووحدة تحكم المراوح وتطبيق الجهاز اللوحي.",
                    label = "جهاز داينو متنقل",
                },
                vehicleRegistration = {
                    description = "تسجيل المركبة أو نقلها",
                    label = "تسجيل المركبة",
                },
                antiLag = {
                    description = "تفعيل نظام تعطيل تأخير التوربو العادم.a40074848905d12c107f984aac5d9776",
                    label = "مانع تأخير التوربو (Anti-Lag)a40074848905d12c107f984aac5d9776",
                },
                brakeOverheating = {
                    description = "قم بتنشيط حرارة الفرامل المتدرجة ، والأقراص المتوهجة ، والشرر الحرج ، وتتلاشى الفرامل القصيرة.",
                    label = "ارتفاع درجة حرارة الفرامل",
                },
                carryItems = {
                    description = "طلبات قطع المسلمة عبر الورشة.a40074848905d12c107f984aac5d9776",
                    label = "سوء الحالة الاجتماعيةa40074848905d12c107f984aac5d9776",
                },
                customHandling = {
                    description = "تفعيل ضبط نظام الحركة والقيادة.a40074848905d12c107f984aac5d9776",
                    label = "قيادة مخصصةa40074848905d12c107f984aac5d9776",
                },
                electronicTuning = {
                    description = "تفعيل ECU المستمر ، والإضاءة وخيارات ضبط مساعدة السائق.",
                    label = "ضبط الإلكترونية",
                },
                instantTuning = {
                    description = "وبالتالي بالضبط في المواقع العامة الضبط.a40074848905d12c107f984aac5d9776",
                    label = "ضبط فوريa40074848905d12c107f984aac5d9776",
                },
                mileageHud = {
                    description = "عرض معلومات عداد مسافات الكاميرا أثناء القيادة.a40074848905d12c107f984aac5d9776",
                    label = "عداد المسافات (HUD)a40074848905d12c107f984aac5d9776",
                },
                nitro = {
                    description = "تفعيل تركيب الضوء الجديد .a40074848905d12c107f984aac5d9776",
                    label = "نيترو (نيترو)a40074848905d12c107f984aac5d9776",
                },
                partsDelivery = {
                    description = "تفعيل طلبات تسليم قطع الورشة ومنصات اسطنبول.a40074848905d12c107f984aac5d9776",
                    label = "قطع الغيارa40074848905d12c107f984aac5d9776",
                },
                selfServiceOrderNotifications = {
                    description = "إخطار الموظفين أثناء الخدمة عند إنشاء أمر ضبط الخدمة الذاتية.",
                    label = "إشعارات أوامر الخدمة الذاتية",
                },
                stance = {
                    description = "أظهر تعديلات Stance في جميع قوائم الضبط وقم بتمكين عنصر Stance Kit.",
                    label = "وضعية السيارة",
                },
                stanceWheelSize = {
                    description = "عرض وحفظ وتطبيق تعديلات حجم العجلات في Stance.",
                    label = "حجم عجلة Stance",
                },
                stanceWheelWidth = {
                    description = "اعرض واحفظ وطبق تعديلات عرض العجلات في Stance.",
                    label = "عرض عجلة Stance",
                },
                subscriptions = {
                    description = "تفعيل محطات الاشتراك في ورشة العمل والإدارة وخصومات العملاء.",
                    label = "الاشتراكات في حلقات العمل",
                },
                twoStep = {
                    description = "تفعيل نظام التحكم في الانطلاق المدمر.a40074848905d12c107f984aac5d9776",
                    label = "وحدة تحكم الانطلاق (خطوتين)a40074848905d12c107f984aac5d9776",
                },
                vehicleMaintenanceNotifications = {
                    description = "إخطار المالكين عندما تصل سيارتهم إلى عتبة الصيانة المحددة.",
                    label = "إخطارات صيانة المركبات",
                },
                wheelDamage = {
                    description = "تفعيل العناصر التصنيعية الحديثة بشكل واقعي.a40074848905d12c107f984aac5d9776",
                    label = "اتصالات الهاتفيةa40074848905d12c107f984aac5d9776",
                },
                workshopLift = {
                    description = "تفعيل نقاط الرفع الذكية للاستخدام والمكونة في الورش.a40074848905d12c107f984aac5d9776",
                    label = "ورشة رافعةa40074848905d12c107f984aac5d9776",
                },
            },
            locationDescriptions = {
                vehicle_registry = "ضع النقطة في منطقة الفحص بالورشة. يجب أن تكون المركبة ضمن مسافة الفحص المحددة لإجراء الفحص الفني وتسجيل المركبة.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "موضع شاشة نتائج الداينو.",
                    label = "شاشة نتائج الداينو",
                },
                mobile_dyno_station = {
                    description = "موضع جهاز الداينو المتنقل.",
                    label = "محطة داينو متنقلة",
                },
                vehicle_registry = "نقطة الفحص الفني وتسجيل المركبات",
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
            settingGroups = {
                diagnostics = {
                    label = "التشخيص",
                },
                keybinds = {
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                    label = "اختصارات المفاتيح",
                },
                safety = {
                    label = "التحقق والسلامة",
                },
                antiExploit = {
                    label = "مكافحة استغلال",
                },
                coach = {
                    label = "مدرب القياس عن بعد",
                },
                cooldownMultipliers = {
                    label = "معاملات التبريد",
                },
                crashFalloff = {
                    label = "تحطم Falloff",
                },
                criticalEngine = {
                    label = "محرك مكسور",
                },
                deformation = {
                    label = "تشوهات",
                },
                fade = {
                    label = "ضعف الفرامل بسبب الحرارة",
                },
                features = {
                    label = "المميزاتa40074848905d12c107f984aac5d9776",
                },
                format = {
                    label = "تنسيق",
                },
                frontalImpact = {
                    label = "تأثير الجبهة الشديدة",
                },
                general = {
                    label = "عام",
                },
                heatMultipliers = {
                    label = "معاملات الحرارة",
                },
                illegalMarket = {
                    label = "السوق غير المشروعة",
                },
                integration = {
                    label = "التكامل",
                },
                items = {
                    label = "العناصر",
                },
                lifetime = {
                    label = "مدى الحياة",
                },
                limits = {
                    label = "حدود التخزين",
                },
                repairRestore = {
                    label = "إصلاح استعادة",
                },
                risk = {
                    label = "مخاطرة",
                },
                rules = {
                    label = "القواعد",
                },
                stages = {
                    label = "مراحل ارتفاع الحرارة",
                },
                tyreRepair = {
                    label = "إصلاح الإطارات",
                },
                visuals = {
                    label = "المؤثرات البصرية",
                },
            },
            settingSections = {
                electronicTuning = "برمجيات محرك ECU",
                handlingEditor = "محرر التحكم",
                mobileDyno = "جهاز داينو متنقل",
                vehicleRegistry = "وثائق المركبة",
                advancedPricing = "التسعير المتقدم",
                brakeOverheating = "ارتفاع درجة حرارة الفرامل",
                carryItems = "حمل العناصر",
                fakePlates = "لوحات وهمية",
                firejobVehicleFires = "حرائق المركبات",
                general = "عام",
                instantTuning = "ضبط فوريa40074848905d12c107f984aac5d9776",
                maintenanceNotifications = "إشعارات الصيانة",
                mileageHud = "عداد المسافات (HUD)a40074848905d12c107f984aac5d9776",
                oilLeaks = "تسرب السوائل المركبات",
                partsTheft = "أجزاء سرقة أجزاء",
                subscriptions = "الاشتراكات",
                tuning = "الضبط",
                vehicleCare = "العناية بالسيارات",
                wear = "التآكل",
                wheelDamage = "اتصالات الهاتفيةa40074848905d12c107f984aac5d9776",
            },
            settingSubsectionGroups = {
                handlingAdditional = "إضافي",
                handlingAir = "الجو",
                handlingGeneral = "عام",
                handlingRoad = "البر",
                handlingWater = "الماء",
            },
            settingSubsections = {
                mechanicHotkeys = "اختصارات المفاتيح",
                database = "قاعدة البيانات",
                handlingEditorGeneral = "إعدادات المحرر",
                handlingMaximumCBikeHandlingData = "الدراجة النارية",
                handlingMaximumCBoatHandlingData = "القارب",
                handlingMaximumCCarHandlingData = "السيارة",
                handlingMaximumCFlyingHandlingData = "الطائرة",
                handlingMaximumCHandlingData = "أساس المركبة",
                handlingMaximumCSeaPlaneHandlingData = "الطائرة المائية",
                handlingMaximumCSpecialFlightHandlingData = "الطيران الخاص",
                handlingMaximumCSubmarineHandlingData = "الغواصة",
                handlingMaximumCTrailerHandlingData = "المقطورة",
                handlingMaximumCVehicleWeaponHandlingData = "أسلحة المركبة",
                keybinds = "اختصارات المفاتيح",
                operation = "التشغيل",
                placementRules = "قواعد الوضع",
                testFlow = "تسلسل الاختبار",
                tuning = "خيارات التعديل الفوري",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "إصلاح المركبة",
                    description = "إتاحة إصلاح المركبات في مواقع التعديل الفوري.",
                },
                instantTuningRepairPrice = {
                    label = "سعر الإصلاح",
                    description = "سعر ثابت للإصلاح دون مضاعف أسعار التعديل.",
                },
                instantTuningWashEnabled = {
                    label = "غسل المركبة",
                    description = "إتاحة غسل المركبات في مواقع التعديل الفوري.",
                },
                instantTuningWashPrice = {
                    label = "سعر الغسل",
                    description = "سعر ثابت للغسل دون مضاعف أسعار التعديل.",
                },
                vehiclePriceSource = {
                    label = "مصدر أسعار المركبات",
                    description = "تلقائي: SQL في ESX؛ كتالوج المركبات في QBCore/Qbox. قاعدة البيانات: جدول SQL المحدد في جميع أطر العمل.",
                    options = {
                        auto = "تلقائي (إطار العمل)",
                        database = "قاعدة البيانات",
                    },
                },
                vehiclePriceTable = {
                    label = "جدول أسعار المركبات",
                    description = "الجدول الذي يحتوي على أسعار الشراء، مثل dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "عمود اسم الاستدعاء",
                    description = "عمود أسماء استدعاء المركبات، مثل spawn_code (JG)، وليس الاسم المعروض.",
                },
                vehiclePricePriceColumn = {
                    label = "عمود السعر",
                    description = "عمود أسعار الشراء الرقمية، مثل price.",
                },
                vehiclePriceHashColumn = {
                    label = "عمود هاش الطراز (اختياري)",
                    description = "عمود هاش رقمي اختياري، مثل hashkey (JG). اتركه فارغاً لحساب الهاش من أسماء الاستدعاء.",
                },
                handlingEditorFieldMaximum = {
                    description = "الحد الأقصى الصارم الذي يقبله المحرر لحقل التحكم هذا.",
                },
                handlingEditorFocusKey = {
                    label = "العودة إلى محرر القيادة",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "عدد البايتات المشفرة الذي تُبلغ بعده طلبات المحرر أو ردوده أو لقطاته على أنها كبيرة.",
                    label = "حد الحمولة الكبيرة",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "يقيس عمليات المحرر ويحذر عبر Sky.Debug عند تجاوز الحدود المضبوطة.",
                    label = "فحوصات الأداء",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "عدد المللي ثانية بين ملخصات الأداء المجمعة عند تفعيل سجلات التصحيح المفصلة.",
                    label = "فاصل ملخص الأداء",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "عدد المللي ثانية الذي تُبلغ بعده عملية محرر التحكم على أنها بطيئة.",
                    label = "حد العملية البطيئة",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "أقصى نسبة مئوية يمكن أن يتحرك بها شريط التمرير الرقمي أعلى أو أسفل قيمة المركبة الأساسية المقروءة. يظل الإدخال المباشر واستيراد XML دون فقدان. الحد الأقصى للحقل إذا اختلف عن الافتراضي يحل محل الحد العلوي لشريط التمرير.",
                    label = "أقصى انحراف لشريط التمرير",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "سرقة المحول الحفاز · التحكم 38",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "سرقة المحول الحفاز · التحكم 73",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl172 = {
                    label = "منصة قياس القدرة · التحكم 172",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl173 = {
                    label = "منصة قياس القدرة · التحكم 173",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl174 = {
                    label = "منصة قياس القدرة · التحكم 174",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl175 = {
                    label = "منصة قياس القدرة · التحكم 175",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl177 = {
                    label = "منصة قياس القدرة · التحكم 177",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl38 = {
                    label = "منصة قياس القدرة · التحكم 38",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl45 = {
                    label = "منصة قياس القدرة · التحكم 45",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicDynoControl47 = {
                    label = "منصة قياس القدرة · التحكم 47",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicSprayPaintControl200 = {
                    label = "الطلاء · التحكم 200",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicSprayPaintControl202 = {
                    label = "الطلاء · التحكم 202",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehicleCareControl200 = {
                    label = "العناية بالمركبة · التحكم 200",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehicleCareControl202 = {
                    label = "العناية بالمركبة · التحكم 202",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "دفع المركبة · التحكم 38",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "دفع المركبة · التحكم 33",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "دفع المركبة · التحكم 34",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "دفع المركبة · التحكم 35",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "دفع المركبة · التحكم 32",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "دفع المركبة · التحكم 21",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicWheelChangeControl200 = {
                    label = "تغيير العجلة · التحكم 200",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicWheelChangeControl202 = {
                    label = "تغيير العجلة · التحكم 202",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicWheelChangeControl22 = {
                    label = "تغيير العجلة · التحكم 22",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "سرقة العجلة · التحكم 38",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "سرقة العجلة · التحكم 73",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                mobileDynoConsumeItem = {
                    description = "إزالة عنصر واحد بعد نجاح الوضع.",
                    label = "استهلاك العنصر",
                },
                mobileDynoCooldownMs = {
                    label = "مدة التبريد",
                },
                mobileDynoCountdownMs = {
                    label = "العد التنازلي",
                },
                mobileDynoDuiDistance = {
                    label = "مسافة عرض اللوحة",
                },
                mobileDynoFanInteractionDistance = {
                    label = "مسافة وحدة تحكم المراوح",
                    description = "المسافة بالأمتار لاستخدام التبديل المادي بين مراوح التبريد.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "مدة الحمل الكامل",
                    description = "ميلي ثانية تنفق في حمولة كاملة مستدامة في التشكيلات التي تشمل مرحلة التحميل الكامل.",
                },
                mobileDynoHistoryLimit = {
                    label = "حد السجل",
                },
                mobileDynoInteractionDistance = {
                    label = "مسافة استخدام اللوحة",
                },
                mobileDynoItemUseEnabled = {
                    description = "السماح بوضع جهاز القياس والشاشة باستخدام عناصر المخزون.",
                    label = "الوضع باستخدام العناصر",
                },
                mobileDynoMaxActiveSessions = {
                    label = "حد الجلسات النشطة",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "مسافة التقاط المركبة",
                },
                mobileDynoMonitorItem = {
                    description = "عنصر المخزون المستخدم لوضع شاشة النتائج.",
                    label = "عنصر الشاشة",
                },
                mobileDynoPersistItems = {
                    description = "الاحتفاظ بالمعدات الجديدة بعد إعادة تشغيل الخادم.",
                    label = "حفظ مواضع المعدات",
                },
                mobileDynoPickupDistance = {
                    description = "أقصى مسافة بالأمتار لالتقاط المعدات.",
                    label = "مسافة الالتقاط",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "أقصى تفاوت للارتفاع",
                    description = "أقصى تباين في ارتفاع الأرض بالأمتار المقبولة في جميع تحقيقات بصمة dyno.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "أقصى ميل للسطح",
                    description = "أقصى منحدر أرضي بالدرجات المقبولة عبر بصمة dyno.",
                },
                mobileDynoRequireOnDuty = {
                    description = "يجب أن يكون الميكانيكي في الخدمة لوضع المعدات وتشغيلها.",
                    label = "اشتراط الخدمة",
                },
                mobileDynoResultDuiDistance = {
                    label = "مسافة عرض النتائج",
                    description = "الحد الأقصى للمسافة بالأمتار التي يتم فيها عرض شاشة النتائج المنفصلة.",
                },
                mobileDynoReturnItem = {
                    description = "إعادة العنصر المستهلك عند التقاط المعدات.",
                    label = "إعادة العنصر",
                },
                mobileDynoStationItem = {
                    description = "عنصر المخزون المستخدم لوضع جهاز القياس.",
                    label = "عنصر جهاز القياس",
                },
                mobileDynoTabletDistance = {
                    description = "أقصى مسافة من جهاز القياس بالأمتار للتحكم باللوحي والاختبارات الجارية.",
                    label = "مدى الجهاز اللوحي",
                },
                nitroActivationKey = {
                    label = "الضغط المستمر للنيترو",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                registryBikeChecks = {
                    description = "بنود فحص الدراجات النارية",
                    label = "بنود فحص الدراجات النارية",
                },
                registryCarChecks = {
                    description = "بنود فحص السيارات",
                    label = "بنود فحص السيارات",
                },
                registryDistance = {
                    description = "مسافة الخدمة بالأمتار",
                    label = "مسافة الخدمة بالأمتار",
                },
                registryKuvFee = {
                    description = "رسوم الفحص الفني للمركبة",
                    label = "رسوم الفحص الفني للمركبة",
                },
                registryKuvValidityDays = {
                    description = "صلاحية الفحوص الجديدة بالوقت الفعلي. الافتراضي: 30 يوماً. تبقى مواعيد الانتهاء الحالية دون تغيير.",
                    label = "صلاحية الفحص (أيام فعلية)",
                },
                registryKuvWarningDays = {
                    description = "مهلة التنبيه بالأيام",
                    label = "مهلة التنبيه بالأيام",
                },
                registryRegistrationFee = {
                    description = "رسوم التسجيل",
                    label = "رسوم التسجيل",
                },
                registryReinspectionFee = {
                    description = "رسوم إعادة الفحص",
                    label = "رسوم إعادة الفحص",
                },
                registryRequireKuv = {
                    description = "اشتراط الفحص الفني للمركبة صالح للتسجيل",
                    label = "اشتراط الفحص الفني للمركبة صالح للتسجيل",
                },
                registrySessionSeconds = {
                    description = "مهلة التأكيد بالثواني",
                    label = "مهلة التأكيد بالثواني",
                },
                registryTransferFee = {
                    description = "رسوم النقل",
                    label = "رسوم النقل",
                },
                registryVehicleTypes = {
                    description = "أنواع المركبات المسموحة",
                    label = "أنواع المركبات المسموحة",
                },
                tuningFocusKey = {
                    label = "التفاعل بالفأرة في التعديل",
                    description = "تعيين FiveM الافتراضي، مثل E أو F6 أو MOUSE_BUTTON:MOUSE_RIGHT. الحقل الفارغ يعني عدم وجود مفتاح افتراضي. يستطيع اللاعبون تغيير تعييناتهم في إعدادات FiveM مع الاحتفاظ بالتعيينات المحفوظة.",
                },
                addRevenueToSociety = {
                    description = "إيداع دفع ضبط النظام المال في حساب جمعية مهنة ضبط.",
                    label = "إيرادات الودائع إلى المجتمع",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "فئات متاجر تسليم قطع الغيار التي تظل قابلة للشراء بحرية في حين يتم تمكين التسعير المتقدم. مطابقة يتجاهل غلاف ومساحة بيضاء.",
                    itemLabel = "الفئة",
                    label = "الفئات المتوفرة دائماً",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "احتفظ بعناصر المتجر التي تم تكوينها من الفئات المحددة المتاحة دون طلب ضبط وقم بتسعيرها من خلال نظام المورد الديناميكي.",
                    label = "عناصر متجر متوفرة دائماً",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "عدد الأيام الموضحة في تحليل أرباح الكمبيوتر اللوحي.",
                    label = "فترة التحليلات",
                },
                advancedPricingCategoryRules = {
                    description = "حصة المورد والهامش وحدود العمل والأسعار حسب الفئة.",
                    label = "قواعد الفئة",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "هامش ميكانيكي افتراضي قبل تعديلات الصف والصف.",
                    label = "الهامش الافتراضي",
                },
                advancedPricingDifficultyRules = {
                    description = "تكلفة العمالة الإضافية لكل صعوبة ضبط.",
                    label = "قواعد الصعوبة",
                },
                advancedPricingEnabled = {
                    description = "إعادة حساب ضبط الأسعار على الخادم و، عندما يتم تمكين تسليم أجزاء، تتطلب أجزاء سلالة ليتم شراؤها لترتيب ضبط محددة.",
                    label = "تفعيل التسعير المتقدم",
                },
                advancedPricingInventoryBaseStock = {
                    description = "المخزون الظاهري العادي لكل بند المورد.",
                    label = "المخزون الأساسي",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "إزالة نقاط الطلب في اليوم المنقضي.",
                    label = "تسوس الطلب اليومي",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "إضافة علامات المورد لكل نقطة الطلب.",
                    label = "زيادة الطلب لكل وحدة",
                },
                advancedPricingInventoryEnabled = {
                    description = "رفع أسعار الموردين عندما يكون المخزون الافتراضي منخفضا أو الطلب مرتفعا.",
                    label = "مخزون المورد الديناميكي",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "الحد الأقصى لعلامات المورد الناجمة عن انخفاض المخزون.",
                    label = "ترميز الأسهم المنخفضة",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "مستوى المخزون دون الذي يبدأ تسعير الندرة.",
                    label = "عتبة الأسهم المنخفضة",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "الحدود العليا لترميز الطلب.",
                    label = "الحد الأقصى لترميز الطلب",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "الوحدات الافتراضية تجدد في اليوم المنقضي.",
                    label = "إعادة تخزين اليومي",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "سقف الخصم العالمي للفواتير الميكانيكية.",
                    label = "أقصى خصم",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "أعلى هامش ميكانيكي مسموح به.",
                    label = "الهامش الأقصى",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "حدود السعر العلوي العالمي لجزء ضبط.",
                    label = "الحد الأقصى لسعر التجزئة",
                },
                advancedPricingMechanicGradeRules = {
                    description = "حدود العلامات والعمل والخصم حسب درجة ميكانيكي.",
                    label = "قواعد الصف الميكانيكية",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "أدنى هامش ميكانيكي مسموح به.",
                    label = "الحد الأدنى الهامش",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "حدود السعر العالمية المنخفضة لجزء الضبط.",
                    label = "الحد الأدنى لسعر التجزئة",
                },
                advancedPricingPreviewCompactValue = {
                    description = "قيمة السيارة المستخدمة للمثال المضغوط.",
                    label = "قيمة المعاينة المدمجة",
                },
                advancedPricingPreviewCostPercent = {
                    description = "مثال ضبط نسبة التكلفة المستخدمة من قبل المعاينة الحية.",
                    label = "معدل ضبط المعاينة",
                },
                advancedPricingPreviewSportsValue = {
                    description = "قيمة السيارة المستخدمة في المثال الرياضي.",
                    label = "قيمة المعاينة الرياضية",
                },
                advancedPricingPreviewSuperValue = {
                    description = "قيمة السيارة المستخدمة لمثال السوبر.",
                    label = "قيمة المعاينة الفائقة",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "دقائق قبل إعادة حساب السعر غير المدفوع.",
                    label = "اقتبس عمر",
                },
                advancedPricingReturnRefundPercent = {
                    description = "النسبة المئوية المستردة لجزء من أمر الشراء.",
                    label = "استرداد المرتجع",
                },
                advancedPricingRoundingStep = {
                    description = "جولة كل خط المشتريات سلالة لهذه الخطوة المال.",
                    label = "خطوة تقريب المورد",
                },
                advancedPricingSupplierSharePercent = {
                    description = "النسبة المئوية لسعر جزء العميل الذي تفرضه Dynasty Auto Supply.",
                    label = "حصة المورد",
                },
                advancedPricingTaxPercent = {
                    description = "نسبة الضريبة المخزنة بشكل منفصل في محاسبة التسعير.",
                    label = "الضريبة",
                },
                advancedPricingVehicleClassRules = {
                    description = "تعديلات الهامش والعمل من قبل GTA فئة السيارة.",
                    label = "قواعد فئة السيارة",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "مضاعِفات تبريد رفع مستوى الفرامل",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "مضاعِفات تبريد فئة المركبات",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "تأخير في ميلي ثانية بعد الكبح قبل بدء التبريد النشط.",
                    label = "تأخير التبريد",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "يتم إزالة الحرارة في الثانية الواحدة بينما لا يتم استخدام الفرامل.",
                    label = "معدل التبريد",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "مستوى الحرارة الذي الشرر والفرامل قصيرة تتلاشى يمكن أن تبدأ.",
                    label = "العتبة الحرجة",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "فرصة من 0 إلى 1 لقطع الفرامل قصيرة أثناء الكبح في الحرارة الحرجة.",
                    label = "تتلاشى فرصة في الثانية الواحدة",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "تتلاشى برودداون",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "الحد الأقصى لمدة التلاشي",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "الحد الأدنى لمدة التلاشي",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "مضاعِفات الحرارة لترقية الفرامل",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "مضاعفات الحرارة فئة السيارة",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "الحرارة الأساسية المكتسبة في الثانية الواحدة أثناء الكبح بسرعة الإشارة.",
                    label = "كسب الحرارة",
                },
                brakeOverheatingHotThreshold = {
                    label = "العتبة الساخنة",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "الحد الأدنى لسرعة السيارة في كم / ساعة قبل الكبح يخلق الحرارة.",
                    label = "الحد الأدنى لسرعة الكبح",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "السرعة بالكيلومتر/الساعة التي يتم فيها تطبيق اكتساب الحرارة الأساسي المهيأ.",
                    label = "السرعة المرجعية",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "الحد الأقصى فاصل شرارة",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "الحد الأدنى فاصل شرارة",
                },
                brakeOverheatingVisualDistance = {
                    description = "المسافة القصوى بالأمتار للتوهج وتقديم الشرارة.",
                    label = "المسافة البصرية",
                },
                brakeOverheatingWarmThreshold = {
                    label = "عتبة دافئة",
                },
                carryItems = {
                    description = "تسليم الأجزاء التي ينبغي أن تصبح المادية الدعائم المحمولة.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "رافعة المحرك",
                                forklift = "رافعة شوكية",
                                hand = "اليد",
                            },
                        },
                    },
                    itemLabel = "حمل البند",
                    label = "بنود حمل",
                },
                ecuEngineTorqueStage1 = {
                    description = "1.00 يعني عدم إضافة تعزيز؛ و1.10 يضيف 10% إلى عزم الدوران. ينطبق على المركبات التي تستخدم هذه المرحلة من ECU.",
                    label = "معامل عزم الدوران للمرحلة 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1.00 يعني عدم إضافة تعزيز؛ و1.10 يضيف 10% إلى عزم الدوران. ينطبق على المركبات التي تستخدم هذه المرحلة من ECU.",
                    label = "معامل عزم الدوران للمرحلة 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1.00 يعني عدم إضافة تعزيز؛ و1.10 يضيف 10% إلى عزم الدوران. ينطبق على المركبات التي تستخدم هذه المرحلة من ECU.",
                    label = "معامل عزم الدوران للمرحلة 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1.00 يعني عدم إضافة تعزيز؛ و1.10 يضيف 10% إلى عزم الدوران. ينطبق على المركبات التي تستخدم هذه المرحلة من ECU.",
                    label = "معامل عزم الدوران للمرحلة 4",
                },
                fakePlatesAudit = {
                    label = "سجل التدقيق",
                },
                fakePlatesBlacklist = {
                    description = "حجب الكلمات أو الشظايا التي لا يمكن أن تظهر في لوحات وهمية.",
                    label = "القائمة السوداء",
                },
                fakePlatesBlankPlateItem = {
                    description = "الحرف / متجر المواد المستخدمة لحلقات الاقتصاد لوحة وهمية.",
                    label = "بند لوحة فارغة",
                },
                fakePlatesCooldownMinutes = {
                    label = "دقائق فترة الانتظار",
                },
                fakePlatesCrashFalloffChance = {
                    label = "فرصة Falloff",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "مكّن الانهيار الانهيار",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "الحد الأدنى لسرعة التصادم",
                },
                fakePlatesEnabled = {
                    description = "السماح للاعبين باستخدام مجموعات لوحة وهمية على المركبات.",
                    label = "تنشيط لوحات وهمية",
                },
                fakePlatesExpireMinutes = {
                    description = "0 يبقي لوحات وهمية نشطة حتى إعادة تعيين أو إعادة تشغيل التعامل مع يزيل لهم.",
                    label = "دقائق انتهاء الصلاحية",
                },
                fakePlatesExpireOnRestart = {
                    label = "انتهاء الصلاحية عند إعادة التشغيل",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "حساب الدفع",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "تمكين السوق غير القانونية",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "سعر السوق غير القانوني",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "مضاعف المخاطر",
                },
                fakePlatesInstallDurationMs = {
                    label = "مدة التثبيت ms",
                },
                fakePlatesItem = {
                    description = "عنصر الاستخدام الواحد الذي يبدأ تدفق تركيب لوحة وهمية.",
                    label = "لوحة وهمية كيت البند",
                },
                fakePlatesMaxLength = {
                    label = "أقصى طول",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "مسافة المركبة",
                },
                fakePlatesMinLength = {
                    label = "الحد الأدنى للطول",
                },
                fakePlatesPattern = {
                    description = "يستخدم نمط Lua للتحقق من صحة نص اللوحة المزيف ، على سبيل المثال [A-Z0-9]  $.",
                    label = "نمط لوا",
                },
                fakePlatesPlateInstallDistance = {
                    label = "المسافة موقف لوحة",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "كتلة لوحات وهمية نشطة مكررة",
                },
                fakePlatesPrinterItem = {
                    description = "أداة حرفة / متجر تستخدم لحلقات الاقتصاد لوحة وهمية.",
                    label = "عنصر الطابعة لوحة",
                },
                fakePlatesRequireEngineOff = {
                    label = "يجب إطفاء المحرك",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "استخدم Config.Functions.CanApplyFakePlate قبل السماح بالتثبيت.",
                    label = "تتطلب المالك أو المفاتيح",
                },
                fakePlatesRequireStopped = {
                    label = "يجب إيقاف السيارة.",
                },
                fakePlatesResetOnGarageStore = {
                    description = "محجوز لعمليات تكامل المرآب التي تستدعي إعادة تعيين الحدث / التصدير.",
                    label = "إعادة تعيين على مخزن المرآب",
                },
                fakePlatesRiskCharacters = {
                    label = "أحرف تايبو",
                },
                fakePlatesRiskEnabled = {
                    label = "تم تمكين الأخطاء المطبعية للمخاطر",
                },
                fakePlatesRiskTypoChance = {
                    label = "فرصة تايبو",
                },
                fallbackVehicleValue = {
                    description = "القيمة المستخدمة عندما لا يمكن حل أي سعر السيارة.",
                    label = "قيمة السيارة الاحتياطية",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "فرصة من 0 إلى 1 بعد أن يظل المحرك حرجًا.",
                    label = "فرصة حريق المحرك الحرجة",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "ثوانٍ قبل أن يندلع حريق آخر بمحرك مكسور",
                    label = "تبريد المحرك الحرج",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "تأخير في ميلي ثانية قبل محرك مكسور يمكن أن تشتعل.",
                    label = "تأخير المحرك الحرج MS",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "السماح للمحركات المتضررة بشكل خطير لبدء حريق سيارة Firejob بعد تأخير.",
                    label = "إشعال المحركات المكسورة",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "كثافة الدخان المستخدمة لطلبات حريق المحرك المكسور.",
                    label = "كثافة دخان المحرك الحرجة",
                },
                firejobVehicleFiresEnabled = {
                    description = "السماح أنظمة الأضرار الميكانيكية وظيفة لطلب حرائق المركبات من Firejob.",
                    label = "تفعيل حرائق المركبات Firejob",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "نسبة الحركة إلى الأمام المطلوبة من 0 إلى 1.",
                    label = "نسبة الحركة إلى الأمام",
                },
                firejobVehicleFiresImpactChance = {
                    description = "فرصة من 0 إلى 1 أن تأثير مؤهل يبدأ حريق.",
                    label = "فرصة تأثير النار",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "ثوان قبل أن يندلع حريق آخر.",
                    label = "تأثير التبريد النار",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "السماح لحوادث أمامية قوية بطلب حريق سيارة Firejob.",
                    label = "إشعال بعد حوادث شديدة",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "كثافة الدخان المستخدمة لطلبات إطلاق النار الناجمة عن التصادم.",
                    label = "تأثير كثافة الدخان",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "التلقائي يستخدم الموارد Firejob تكوين؛ تعطيل يمنع Mechanicjob من خلق الحرائق.",
                    label = "وضع التكامل",
                    options = {
                        automatic = "تلقائي",
                        disabled = "معطل",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "فقدان الحد الأدنى من صحة الجسم أثناء التأثير.",
                    label = "الحد الأدنى من تلف الجسم",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "فقدان الحد الأدنى لصحة المحرك أثناء الاصطدام.",
                    label = "الحد الأدنى من تلف المحرك",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "استخدم 0 لتعطيل فحص التشوه هذا.",
                    label = "الحد الأدنى من تشوه الجبهة",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "الحد الأدنى لسرعة ما قبل الاصطدام بالكيلومتر/ساعة.",
                    label = "الحد الأدنى لسرعة التأثير",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "فقدان السرعة المطلوبة في كم / ساعة أثناء الاصطدام.",
                    label = "الحد الأدنى من فقدان السرعة",
                },
                firejobVehicleFiresResource = {
                    description = "المصدر الذي يتلقى طلبات حرائق المركبات.",
                    label = "الموارد Firejob",
                },
                firejobVehicleFiresServerEvent = {
                    description = "حدث خادم داخلي يستخدمه العميل الميكانيكي لطلب حريق سيارة Firejob.",
                    label = "حدث خادم ميكانيكي",
                },
                freeVehicles = {
                    description = "نماذج تفرخ السيارة التي تتلقى أوامر ضبط مجانية.",
                    itemLabel = "طراز المركبة",
                    label = "مركبات ضبط مجانية",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "منع تطبيق في حين وجود صراع التعامل الحرجة موجودة.",
                    label = "حجب النتائج الحرجة",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "أقصى تباطؤ متوقع في m / s2 لاختبار الكبح المكتمل.",
                    label = "الحد الأدنى من تباطؤ الفرامل",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "العينات المقاسة المطلوبة قبل أن يقوم مدرب القياس عن بعد بتقييم المدى.",
                    label = "الحد الأدنى من العينات",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "تقاس سرعة انزلاق العجلة بالكيلومتر في الساعة عند الإبلاغ عن فقدان الجر.",
                    label = "تحذير زلة عجلة",
                },
                handlingEditorDefaultTab = {
                    description = "يتم تحديد الصفحة عند فتح محرر المناولة المستقل.",
                    label = "صفحة البداية",
                    options = {
                        advanced = "متقدم",
                        export = "تصدير",
                        flags = "أعلام",
                        fleet = "أسطول",
                        inspector = "طبقات الطبقات",
                        profiles = "الملامح",
                        simple = "بسيط",
                        telemetry = "القياس عن بعد",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "توفير التأثير والنطاق المرجعي والأعراض والمجالات ذات الصلة والدعم المباشر لكل قيمة معالجة.",
                    label = "الوثائق الميدانية",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "البحث وتصفية أسماء العلم، والآثار، مواقف بت والأقنعة ست عشرية.",
                    label = "بحث العلم",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "البحث والتفتيش والترويج واستعادة نموذج وقواعد التعامل مع لوحة.",
                    label = "مدير الأسطول",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "عرض قاعدة السيارة ، ضبط مخصص مثبت ، قاعدة الطراز ، قاعدة اللوحة ومشروع المحرر الحالي لكل حقل.",
                    label = "مفتش طبقة",
                },
                handlingEditorMaxFleetResults = {
                    description = "الحد الأقصى للنموذج وقواعد اللوحة المحملة في مدير الأسطول.",
                    label = "حد نتيجة الأسطول",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "الحد الأقصى لعدد المراجعات المحتفظ بها لكل ملف تعريف.",
                    label = "تنقيحات الملف الشخصي",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "الحد الأقصى لمساحات العمل المحددة المحتفظ بها لكل مسؤول.",
                    label = "مساحات العمل الشخصية",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "قم بإنشاء مراجعة قابلة للتدقيق كلما تم تحديث ملف تعريف مشترك أو استعادته.",
                    label = "إصدار الملف الشخصي",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "إنشاء توصيات شفافة تستند إلى القواعد من بيانات اختبار الطريق المقاسة.",
                    label = "مدرب القياس عن بعد",
                },
                handlingEditorValidatorEnabled = {
                    description = "الكشف عن تركيبات غير آمنة أو متناقضة قبل تطبيق المناولة.",
                    label = "مدقق المناولة",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "السماح للمسؤولين بالاحتفاظ بمسودات المحرر الخاص المسماة.",
                    label = "مساحات العمل الشخصية",
                },
                instantTuningAllowedJobs = {
                    description = "قائمة سماح اختيارية عامة. a40074848905d12c107f984aac5d9776اتركها تسمح للسماح بما لم يتم تفعيل الخيار 'للميكانيكي فقط'.a40074848905d12c107f984aac5d9776",
                    itemLabel = "اسم الوظيفة",
                    label = "الوظيفة لهاa40074848905d12c107f984aac5d9776",
                },
                instantTuningBlipColor = {
                    description = "GTA بليب لون معرف.",
                    label = "لون Blip",
                },
                instantTuningBlipEnabled = {
                    description = "اعرض خريطة blips لمواقع ضبط فورية.",
                    label = "تمكين Blip",
                },
                instantTuningBlipName = {
                    description = "خريطة blip اسم.",
                    label = "اسم Blip",
                },
                instantTuningBlipSprite = {
                    description = "GTA blip sprite معرف.",
                    label = "نمط الأيقونة (Blip sprite)a40074848905d12c107f984aac5d9776",
                },
                instantTuningForceMarkerInteraction = {
                    description = "استخدام التفاعل على غرار علامة E حتى عندما يتم تمكين دعم الهدف.",
                    label = "فرض التفاعل عبر العلامةa40074848905d12c107f984aac5d9776",
                },
                instantTuningInteractionDistance = {
                    description = "المسافة الافتراضية لاستخدام نقاط ضبط فورية.",
                    label = "مسافة التفاعل",
                },
                instantTuningLabel = {
                    description = "النص الافتراضي يظهر في نقاط ضبط فورية.",
                    label = "التسميةa40074848905d12c107f984aac5d9776",
                },
                instantTuningLocations = {
                    description = "نقاط ضبط فورية. استخدم مسافة 0 لترث مسافة التفاعل الافتراضية.",
                    itemLabel = "المواقع",
                    label = "المواقع",
                },
                instantTuningMarkerEnabled = {
                    description = "رسم علامة العالم في مواقع ضبط لحظة.",
                    label = "تم تمكين العلامة",
                },
                instantTuningMarkerType = {
                    description = "GTA نوع علامة تستخدم لمواقع ضبط لحظة.",
                    label = "نوع العلامة التجاريةa40074848905d12c107f984aac5d9776",
                },
                instantTuningMechanicOnly = {
                    description = "تقييد جميع مواقع الضبط الفوري للمهن الميكانيكية التي تم تكوينها.",
                    label = "ميكانيكي فقط",
                },
                instantTuningPriceMultiplier = {
                    description = "المضاعف المطبق على أسعار الضبط للرصيد.a40074848905d12c107f984aac5d9776",
                    label = "مضاعف السعر",
                },
                instantTuningProfile = {
                    description = "اضبط خيارات الضبط المتوفرة في نقاط الضبط الفورية.",
                    label = "خيارات ضبط فورية",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "دقائق على الأقل قبل نفس السيارة يمكن أن تؤدي إلى تذكير صيانة آخر.",
                    label = "تهدأ الإشعارات",
                },
                maintenanceNotificationsEnabled = {
                    description = "قم بإخطار مالكي السيارات عندما يصل جزء التآكل إلى عتبة الصيانة.",
                    label = "مفعّل",
                },
                maintenanceNotificationsThreshold = {
                    description = "نسبة ارتداء في أو أقل التي تعتبر الصيانة المستحقة.",
                    label = "العتبة الواجبة",
                },
                mileageHudDigits = {
                    description = "عدد الأرقام الموضحة في عدد الأميال HUD.",
                    label = "ارقام",
                },
                mileageHudPosition = {
                    description = "اسحب المسافة المقطوعة HUD معاينة إلى موضع الشاشة المطلوب.",
                    label = "الموقع",
                },
                oilLeaksCooldownSeconds = {
                    description = "ثوان قبل تسرب تأثير آخر يمكن أن يؤدي.",
                    label = "تأثير التبريد",
                },
                oilLeaksEnabled = {
                    description = "السماح لسيارات الاحتراق التالفة بترك السوائل خلفها أثناء القيادة.",
                    label = "تفعيل تسرب السوائل",
                },
                oilLeaksEngineOilChance = {
                    description = "فرصة تسرب طبيعية من 0 إلى 1.",
                    label = "فرصة زيت المحرك",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "فرصة تسرب حرجة من 0 إلى 1.",
                    label = "فرصة حرجة لزيت المحرك",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "حالة زيت المحرك عند أو أقل من استخدام الفرصة الحرجة.",
                    label = "عتبة زيت المحرك الحرجة",
                },
                oilLeaksEngineOilThreshold = {
                    description = "حالة زيت المحرك عند أو أقل يمكن أن يبدأ فيها التسرب.",
                    label = "عتبة زيت المحرك",
                },
                oilLeaksForwardMotionRatio = {
                    description = "نسبة الحركة إلى الأمام المطلوبة من 0 إلى 1.",
                    label = "نسبة الحركة إلى الأمام",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "السماح بتأثيرات أمامية شديدة لبدء تسرب مؤقت لسائل المحرك.",
                    label = "تسرب تأثير أمامي",
                },
                oilLeaksImpactChance = {
                    description = "فرصة من 0 إلى 1 أن تأثير مؤهل يبدأ تسرب.",
                    label = "فرصة تسرب تأثير",
                },
                oilLeaksImpactRadius = {
                    description = "نصف القطر من نقطة السائل الأولية التي تم إنشاؤها بواسطة تأثير.",
                    label = "تأثير قطر التسرب",
                },
                oilLeaksIntervalSeconds = {
                    description = "الحد الأدنى للثواني بين نقاط الدرب.",
                    label = "الفاصل الزمني تريل",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "يستمر التسرب بعد ثوانٍ من تأثير التصفيات.",
                    label = "مدة تسرب التأثير",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "فقدان الحد الأدنى من صحة الجسم أثناء التأثير.",
                    label = "الحد الأدنى من تلف الجسم",
                },
                oilLeaksMinDistance = {
                    description = "الحد الأدنى المسافة المقطوعة بين نقاط درب.",
                    label = "المسافة درب",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "فقدان الحد الأدنى لصحة المحرك أثناء الاصطدام.",
                    label = "الحد الأدنى من تلف المحرك",
                },
                oilLeaksMinFrontDeformation = {
                    description = "مطلوب تشوه الجبهة. استخدام 0 لتعطيل هذا الاختيار.",
                    label = "الحد الأدنى من تشوه الجبهة",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "الحد الأدنى لسرعة ما قبل الاصطدام بالكيلومتر/ساعة.",
                    label = "الحد الأدنى لسرعة التأثير",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "فقدان السرعة المطلوبة في كم / ساعة أثناء الاصطدام.",
                    label = "الحد الأدنى من فقدان السرعة",
                },
                oilLeaksMinSpeedKmh = {
                    description = "الحد الأدنى لسرعة السيارة في كم / ساعة قبل تسرب السوائل يمكن أن تخلق درب.",
                    label = "الحد الأدنى للسرعة",
                },
                oilLeaksRadius = {
                    description = "نصف القطر من نقاط درب السوائل السيارة العادية.",
                    label = "نصف قطر تريل",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "فرصة تسرب طبيعية من 0 إلى 1.",
                    label = "انتقال فرصة السائل",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "فرصة تسرب حرجة من 0 إلى 1.",
                    label = "فرصة انتقال حرجة",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "حالة سائل ناقل الحركة عند أو دون استخدام الفرصة الحرجة.",
                    label = "عتبة الإرسال الحرجة",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "حالة سائل ناقل الحركة عند أو أقل يمكن أن يبدأ فيها التسرب.",
                    label = "عتبة سائل ناقل الحركة",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "فئات المركبات التي يمكن إكمال العمل النظام تعتمد على رفع دون رفع ورشة عمل.",
                    itemLabel = "إضافة فئة السيارة",
                    label = "رفع فئات المركبات الالتفافية",
                    options = {
                        ["0"] = "المواثيق",
                        ["1"] = "سيدان",
                        ["10"] = "صناعي",
                        ["11"] = "المرافق",
                        ["12"] = "فانس",
                        ["13"] = "دوراتها",
                        ["14"] = "للقوارب",
                        ["15"] = "طائرات الهليكوبتر",
                        ["16"] = "الطائرات الطائرة",
                        ["17"] = "خدمة",
                        ["18"] = "الطوارئ",
                        ["19"] = "الأفراد العسكريون",
                        ["2"] = "سيارات الدفع الرباعي",
                        ["20"] = "تجاري",
                        ["21"] = "قطارات",
                        ["22"] = "عجلة مفتوحة",
                        ["3"] = "كوبيه",
                        ["4"] = "العضلات",
                        ["5"] = "الكلاسيكية الرياضية",
                        ["6"] = "الرياضة الرياضية",
                        ["7"] = "سوبر سوبر",
                        ["8"] = "دراجات نارية",
                        ["9"] = "الطرق الوعرة",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "نماذج تفرخ السيارة التي يمكن أن تكمل العمل النظام المعتمد على رفع دون رفع ورشة عمل.",
                    itemLabel = "طراز المركبة",
                    label = "رفع نماذج المركبات الالتفافية",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "ميلي ثانية تستخدم لتثبيت النظام الخطوات التي لا تعمل لعبة مصغرة.",
                    label = "مدة تثبيت بسيطة",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "معرفات فئة السيارة التي تستخدم دائمًا التثبيت الميكانيكي العادي دون رفع متخصص أو تدفقات Minigame.",
                    label = "فئات المركبات غير المصغرة",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "نماذج تفرخ السيارة التي تستخدم دائما تثبيت ميكانيكي العادي دون رفع المتخصصة أو تدفقات minigame.",
                    label = "نماذج المركبات غير المصغرة",
                },
                partsDeliveryCompanyCard = {
                    description = "السماح لأوامر تسليم الأجزاء باستخدام أموال الشركة.",
                    label = "دفع بطاقة الشركة",
                },
                partsDeliveryMode = {
                    description = "الحفاظ على تدفق التسليم المادي القياسي أو إضافة التسليم الكامل مباشرة إلى مخزون لاعب جمع.",
                    label = "مناولة التسليم",
                    options = {
                        player_inventory = "مخزون اللاعب",
                        standard = "تدفق التسليم القياسية",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "ميلي ثانية المطلوبة لتفريغ تسليم أجزاء جاهزة.",
                    label = "المدة المفتوحة",
                },
                partsDeliveryOwnCard = {
                    description = "السماح للاعبين بدفع أوامر تسليم قطع الغيار بأموالهم الخاصة.",
                    label = "الدفع بالبطاقة الخاصة",
                },
                partsDeliveryTimeSeconds = {
                    description = "ثواني بين طلب أجزاء والتسليم تصبح جاهزة.",
                    label = "موعد التسليم",
                },
                partsTheftCatalyticConverterItem = {
                    description = "بند المخزون الممنوح عند سرقة المحول الحفاز.",
                    label = "عنصر المحول الحفاز",
                },
                partsTheftDealerAccount = {
                    description = "حساب يستخدم لدفعات تاجر أجزاء مسروقة، مثل المال أو البنك.",
                    label = "حساب دفع تعويضات تاجر",
                },
                partsTheftDealerItems = {
                    description = "العناصر المسروقة التي سيشتريها الموزع وقيم الدفع الخاصة بهم.",
                    itemLabel = "البند تاجر",
                    label = "عناصر تاجر",
                },
                partsTheftDealerPayoutItem = {
                    description = "البند المخزون نظرا عندما يكون نوع دفع تعويضات تاجر هو البند. يتم استخدام سعر البيع كمبلغ البند.",
                    label = "البند دفع تعويضات تاجر",
                },
                partsTheftDealerPayoutType = {
                    description = "اختر ما إذا كان التاجر يدفع في حساب إطار أو يعطي عنصر المخزون.",
                    label = "تاجر نوع دفع تعويضات",
                    options = {
                        account = "الحساب",
                        item = "عنصر",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "المسافة القصوى من التاجر لبيع الأجزاء المسروقة.",
                    label = "تاجر بيع المسافة",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "ثوان قبل جزء السيارة نفسه يمكن أن تخلق إرسال آخر.",
                    label = "مهلة البلاغ",
                },
                partsTheftDispatchEnabled = {
                    description = "إنشاء إرسال الشرطة عند سرقة عجلة أو محول حفاز.",
                    label = "إرسال إرسال الشرطة",
                },
                partsTheftDispatchJobs = {
                    description = "الأسماء المهنية التي تتلقى أجزاء سرقة الإرساليات.",
                    itemLabel = "اسم الوظيفة",
                    label = "وظائف الإرسال",
                },
                partsTheftDispatchMessage = {
                    description = "رسالة تظهر على تنبيه الإرسال. يدعم {plate} و {part} و {type}.",
                    label = "إرسال الرسالة",
                },
                partsTheftDispatchTitle = {
                    description = "العنوان هو مبين في تنبيه الإرسال. يدعم {plate} و {part} و {type}.",
                    label = "عنوان الإرسالية",
                },
                partsTheftItem = {
                    description = "بند المخزون تستخدم لسرقة العجلات والمحولات الحفازة.",
                    label = "سرقة أداة البند",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "قم بإزالة أداة السرقة بعد إجراء سرقة ناجح.",
                    label = "تستهلك أداة سرقة",
                },
                partsTheftStolenWheelItem = {
                    description = "يتم منح عنصر المخزون عند سرقة العجلات.",
                    label = "عنصر العجلة المسروقة",
                },
                priceType = {
                    description = "النسبة المئوية تحسب التكاليف من سعر السيارة. الثابتة تستخدم قيم المال. فئة السيارة تستخدم جدول التسعير الطبقي.",
                    label = "نوع السعر",
                    options = {
                        class = "فئة السيارة",
                        fixed = "ثابت",
                        percentage = "النسبة المئوية",
                    },
                },
                primaryColor = {
                    description = "اللون الافتراضي لمجموعة مهنة ميكانيكي والمهن الجديدة. استخدام قيمة عرافة مثل EDC001.",
                    label = "اللون الأساسي",
                },
                publicUsersSeePrices = {
                    description = "عند تمكين ، يدفع العملاء العامون أثناء الطلب. تعطيل هذا لإنشاء أوامر غير مدفوعة للفواتير الميكانيكية.",
                    label = "شحن أوامر الخدمة الذاتية العامة",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "السماح للرؤساء المخولين بشراء اشتراك لمهنتهم بأكملها باستخدام أموال الشركة.",
                    label = "اشتراكات الشركات",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "عملة الدفع",
                },
                subscriptionsEnabled = {
                    description = "تفعيل اشتراكات ورشة العمل ومحطات العملاء وخصومات الاشتراك.",
                    label = "مفعّل",
                },
                subscriptionsMaximumDurations = {
                    description = "المدة القصوى وخيارات السعر لكل نموذج اشتراك.",
                    label = "المدة القصوى",
                },
                subscriptionsMaximumModels = {
                    description = "نماذج الاشتراك القصوى ورشة عمل يمكن تكوين في الكمبيوتر اللوحي.",
                    label = "نماذج الحد الأقصى",
                },
                subscriptionsNpcEmoteClip = {
                    description = "يتم استخدام مقطع الرسوم المتحركة الاختياري عندما يكون السيناريو فارغًا.",
                    label = "NPC مقطع إيموت",
                },
                subscriptionsNpcEmoteDict = {
                    description = "يستخدم قاموس الرسوم المتحركة الاختياري عندما يكون السيناريو فارغًا.",
                    label = "NPC إموتي القاموس",
                },
                subscriptionsNpcPedModel = {
                    description = "نموذج بيد ولدت في محطات الاشتراك، على سبيل المثال s_m_m_autoshop_01.",
                    label = "نموذج الشخصية الافتراضي",
                },
                subscriptionsNpcScenario = {
                    description = "سيناريو GTA اختياري مثل WORLD_HUMAN_CLIPBOARD. اترك فارغًا لاستخدام الرسوم المتحركة emote.",
                    label = "سيناريو NPC",
                },
                tuningBlockedPlates = {
                    description = "لا يمكن ضبط المركبات التي تحتوي على إحدى هذه اللوحات أو تثبيتها أو إزالتها. مطابقة يتجاهل غلاف ومساحة بيضاء.",
                    itemLabel = "اللوحة",
                    label = "لوحات ضبط المحظورة",
                },
                tuningWorkshopDistance = {
                    description = "المسافة القصوى من نقطة ضبط الخدمة الذاتية لإجراءات التثبيت أو الإزالة المطلوبة.",
                    label = "متطلبات ورشة العمل المسافة",
                },
                tuningWorkshopRequireForInstall = {
                    description = "تتطلب تثبيت أمر الضبط لبدء وإكمال بالقرب من نقطة ضبط الخدمة الذاتية.",
                    label = "تتطلب ورشة عمل للتثبيت",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "تتطلب ضبط عمليات الإزالة لبدء وإكمال بالقرب من نقطة ضبط الخدمة الذاتية.",
                    label = "تتطلب ورشة عمل لعمليات الإزالة",
                },
                vehicleCareRepairDurationMs = {
                    description = "مدة التقدم إصلاح في ميلي ثانية.",
                    label = "مدة الإصلاح",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "قم أيضًا بإعادة ضبط تلف العجلة الواقعي عند استخدام إجراء الإصلاح.",
                    label = "إصلاح الضرر عجلة واقعية",
                },
                vehicleCareRepairItem = {
                    description = "بند المخزون المستخدمة من قبل إجراءات إصلاح المركبات.",
                    label = "عنصر الإصلاح",
                },
                vehicleCareRepairMaxDistance = {
                    description = "المسافة القصوى من السيارة أثناء التصليح.",
                    label = "إصلاح المسافة ماكس",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "إزالة عنصر الإصلاح بعد الاستخدام.",
                    label = "البند إصلاح تستهلك",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "إصلاح تلف السيارة العادي GTA عند استخدام إجراء الإصلاح.",
                    label = "إصلاح تلف السيارة",
                },
                vehicleCareRepairWearParts = {
                    description = "اختر أجزاء التآكل والخدمة التي يستعيدها عنصر الإصلاح. قم بتعطيل السوائل هنا إذا كان الزيت أو سائل التبريد أو سائل الفرامل أو سائل النقل يتطلب تدفق إصلاح التشخيص.",
                    itemLabel = "جزء ارتداء",
                    label = "إصلاح عدة استعادة أجزاء",
                },
                vehicleCareWashItem = {
                    description = "بند المخزون تستخدم لغسل السيارة.",
                    label = "غسل البند",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "إزالة عنصر الغسيل بعد الاستخدام.",
                    label = "تستهلك غسل البند",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "المسافة تظل السيارة المشمعة نظيفة.",
                    label = "الشمع نظيفة كيلومتر",
                },
                vehicleCareWaxItem = {
                    description = "بند المخزون تستخدم لشمع السيارة.",
                    label = "عنصر الشمع",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "إزالة عنصر الشمع بعد الاستخدام.",
                    label = "تستهلك الشمع البند",
                },
                vehicleClassPricing = {
                    description = "تجاوز نوع السعر ومضاعف التكلفة لكل فئة مركبة GTA.",
                    label = "تسعير فئة السيارة",
                },
                wearParts = {
                    description = "أجزاء ارتداء السيارة ، مسافة عمرهم ، عنصر الإصلاح المطلوب ، استهلاك العنصر ، وتدفق التثبيت.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "محول حفاز",
                                fluid_refill = "إعادة تعبئة السوائل",
                                hood_install = "تثبيت هود",
                                oil_change = "تغيير الزيت",
                                performance = "الأداء",
                                underbody_neon = "Underbody / رفع",
                                wheel = "عجلة",
                            },
                        },
                    },
                    itemLabel = "جزء ارتداء",
                    label = "أجزاء ارتداء",
                },
                wheelDamageDefaultMultiplier = {
                    description = "مضاعف تلف عجلة القاعدة.",
                    label = "المضاعف الافتراضي",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "مرشحات تشوه نقاط التحقيق التي لا تشير إلى جسم السيارة.",
                    label = "عتبة زاوية التحقيق",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "وأضاف قوة إضافية كل استعادة التكرار.",
                    label = "زيادة الضرر التشوه",
                },
                wheelDamageDeformationEnabled = {
                    description = "التقاط واستعادة خدوش الجسم أثناء إعادة بناء هندسة إصلاح الإطارات.",
                    label = "استعادة تشوه",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "بدء القوة المستخدمة عند استعادة الخدوش.",
                    label = "الضرر تشوه الأولي",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "الحد الأقصى SetVehicleDamage يمر تستخدم لإعادة بناء الخدوش.",
                    label = "تكرارات التشوه",
                },
                wheelDamageDeformationThreshold = {
                    description = "الحد الأدنى الكشف عن حجم تشوه لتخزين.",
                    label = "عتبة التشوه",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "يتم استخدام المضاعف عندما يكون للمركبة عجلات على الطرق الوعرة.",
                    label = "مضاعف العجلات على الطرق الوعرة",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "إضافية فورية غير عجلة الضرر استعادة يمر بعد إعادة بناء هندسة عجلة.",
                    label = "الأضرار إعادة تطبيق يمر",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "تمريرات فورية إضافية للإطارات التي لا تزال مفقودة أو لا تزال مسطحة بعد إصلاح العجلة.",
                    label = "حالة العجلة إعادة تطبيق يمر",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "حافظ على الجسم والمحرك والنوافذ والأبواب والأوساخ والأضرار البصرية عندما يعيد إصلاح الإطارات بناء هندسة العجلات.",
                    label = "الحفاظ على تلف السيارة",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "استعادة النوافذ المكسورة دون تأثير تحطيم بصوت عال حيثما كان ذلك ممكنا.",
                    label = "نوافذ مكسورة هادئة",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "أعد تطبيق الإطارات الثابتة المسطحة دون إحداث صوت أو تأثير جديد للإطارات.",
                    label = "إعادة تطبيق الإطارات المسطحة الصامتة",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "المسافة القصوى من الإطار التالف أو المفقود لإجراء التثبيت.",
                    label = "صور إرفاق المسافة",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "المسافة القصوى من جاك السيارة وضعت لإجراء إزالة.",
                    label = "جاك سيارة جاك إزالة المسافة",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "مضاعفات الأضرار لكل فئة مركبة GTA.",
                    itemLabel = "فئة السيارة",
                    label = "مضاعفات فئة المركبات",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "منع الوظائف الأخرى عندما يكون الميكانيكيون في الخدمة",
                },
                allowsprint = {
                    label = "السماح بالركض أثناء حمل صناديق التسليم",
                },
            },
            tuningCategories = {
                bodywork = "هيكل السيارة",
                electronics = "وحدة التحكم وإلكترونيات السيارة",
                engineSounds = "أصوات المحرك",
                handling = "التحكم",
                lights = "الإضاءة",
                other = "أخرى",
                paint = "الطلاء",
                performance = "الأداء",
                stance = "وضعية السيارة",
                wheels = "العجلات",
            },
            advancedPricingPreview = {
                compact = "هوندا / المدمجة",
                customer = "سعر العميل",
                description = "مثال على الحساب التجميلي باستخدام القواعد الحالية.",
                labor = "العمل",
                live = "معاينة مباشرة",
                margin = "الهامش",
                sports = "سيارة رياضية",
                super = "سوبركار",
                supplier = "المورد",
                title = "معاينة السعر",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "قم بتكوين وظائف الميكانيكي، التجارة، المركبات، ومواقع الورش.a40074848905d12c107f984aac5d9776",
                    title = "وظائف الميكانيكيa40074848905d12c107f984aac5d9776",
                },
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
            fields = {
                quantity = "الكمية",
            },
            settingFieldDescriptions = {
                radialEnabled = "فتح الفواتير ميكانيكي من القائمة شعاعي.",
                allowTuningInvoices = "أرسل سلة الضبط إلى أقرب عميل. يفتح التثبيت بعد الدفع الكامل.",
                customerRange = "المسافة القصوى بالأمتار لإصدار الفواتير للعملاء القريبين.",
                allowAnalytics = "السماح بتحليلات الفوترة ما لم تتجاوزها قاعدة الصف.",
                allowCustomPrices = "السماح للميكانيكا لتحرير أسعار موقف الفاتورة قبل الإصدار.",
                allowEstimates = "السماح بالتقديرات التي يجب على العملاء قبولها قبل الدفع.",
                allowImmediatePayment = "السماح بدفع الفواتير من هذه المهنة مباشرة.",
                allowManualItems = "السماح للميكانيكا بإنشاء مواقف فاتورة تعسفية.",
                allowPartialPayments = "السماح بالودائع والمدفوعات المتعددة تجاه فاتورة واحدة.",
                analyticsPeriodDays = "الأيام المدرجة في تحليلات الفواتير.",
                defaultDueDays = "أيام حتى تصبح الفاتورة متأخرة.",
                depositPercent = "نسبة الإيداع المطلوبة بعد إصدار الفاتورة أو قبول التقدير.",
                enabled = "السماح لهذه المهنة باستخدام الفواتير الميكانيكية.",
                estimateLifetimeHours = "قبل ساعات من انتهاء صلاحية التقدير الذي لم يتم الرد عليه.",
                gradeRules = "حدود الفاتورة والإجراءات المتاحة لكل درجة ميكانيكي.",
                maxDiscountPercent = "أكبر خصم قد تتلقاه الفاتورة.",
                maximumInvoiceAmount = "الحد الأقصى العالمي الإجمالي قبل حدود الصف.",
                maximumManualItems = "أقصى المواقف التعسفية لكل وثيقة.",
                maximumReminders = "الحد الأقصى للتذكير المسموح به لكل فاتورة.",
                minimumInvoiceAmount = "الحد الأدنى الإجمالي للتقديرات والفواتير.",
                minimumPartialPayment = "أصغر دفعة جزئية ، باستثناء رصيد أو وديعة متبقية أصغر.",
                reminderFee = "وكل آية فيها ذكر وتذكير.",
                reminderGraceDays = "تأخر أيام قبل أن يسمح للتذكير الأول.",
                taxPercent = "الضريبة المضافة بعد الخصومات.",
            },
            settingFields = {
                radialEnabled = "الفاتورة شعاعي العمل",
                allowTuningInvoices = "فاتورة ضبط العملاء",
                customerRange = "مسافة العميل",
                allowAnalytics = "تحليلات المحاسبة",
                allowCancellation = "الإلغاء",
                allowCustomPrices = "السماح بالأسعار المخصصة",
                allowEstimates = "السماح بالتقديرات",
                allowImmediatePayment = "السماح بالدفع الفوري",
                allowManualItems = "السماح بالمناصب الخاصة",
                allowPartialPayments = "السماح بالمدفوعات الجزئية",
                allowReminders = "تذكيرات",
                amount = "الكمية",
                analyticsPeriodDays = "فترة التحليلات",
                bone = "العظمة (العظم)a40074848905d12c107f984aac5d9776",
                category = "الفئة",
                classId = "فئة ID",
                defaultDueDays = "مدة الدفع (أيام)",
                depositPercent = "نسبة الإيداع",
                difficulty = "الصعوبة",
                enabled = "مُفعل",
                estimateLifetimeHours = "العمر التقديري (بالساعات)",
                flow = "تثبيت التدفق",
                grade = "الدرجة",
                gradeRules = "قواعد الصف",
                item = "عنصر",
                key = "المفتاح",
                kilometersToZero = "كيلومتر إلى صفر",
                label = "التسمية",
                laborFee = "تكلفة العمالة",
                laborMultiplier = "مضاعف العمل",
                marginAdjustmentPercent = "تسوية الهامش",
                marginPercent = "الهامش %",
                maxDiscountPercent = "أقصى خصم",
                maximumInvoiceAmount = "الفاتورة القصوى",
                maximumManualItems = "الحد الأقصى من المناصب الخاصة",
                maximumPrice = "الحد الأقصى",
                maximumReminders = "الحد الأقصى للتذكير",
                minimumInvoiceAmount = "الحد الأدنى من الفاتورة",
                minimumPartialPayment = "الحد الأدنى للدفع الجزئي",
                minimumPrice = "الحد الأدنى",
                multiplier = "مضاعِف",
                name = "اسم العنصر",
                partKey = "مفتاح الجزء",
                price = "السعر",
                priceType = "نوع السعر",
                prop = "غرض",
                reason = "السبب",
                reminderFee = "رسوم التذكير",
                reminderGraceDays = "فترة سماح للتذكير",
                removeAfterUse = "استهلاك مادة",
                repair = "إصلاح مع عدة",
                repairItem = "عنصر الإصلاح",
                rx = "روت X",
                ry = "روت Y",
                rz = "روت زد",
                supplierSharePercent = "المورد %",
                taxPercent = "ضريبة الفاتورة",
                transport = "نقل",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "ترقية",
                maximumDiscountPercent = "الخصم الأقصى",
            },
            settingValues = {
                air_filter = "فلتر الهواء",
                brake_fluid = "سائل الفرامل",
                brake_pads = "وسادات الفرامل",
                catalytic_converter = "المحول الحفاز",
                clutch = "مخلب",
                coolant = "المبردات",
                engine_oil = "زيت المحرك",
                inverter = "السلطة العاكس",
                spark_plugs = "المقابس شرارة",
                suspension = "تعليق",
                traction_battery = "بطارية الجر",
                transmission_fluid = "سائل ناقل الحركة",
                tyres = "الإطارات",
                vehicleClass_0 = "المواثيق",
                vehicleClass_1 = "سيدان",
                vehicleClass_10 = "صناعي",
                vehicleClass_11 = "المرافق",
                vehicleClass_12 = "فانس",
                vehicleClass_13 = "دوراتها",
                vehicleClass_14 = "للقوارب",
                vehicleClass_15 = "طائرات الهليكوبتر",
                vehicleClass_16 = "الطائرات الطائرة",
                vehicleClass_17 = "خدمة",
                vehicleClass_18 = "الطوارئ",
                vehicleClass_19 = "الأفراد العسكريون",
                vehicleClass_2 = "سيارات الدفع الرباعي",
                vehicleClass_20 = "تجاري",
                vehicleClass_21 = "قطارات",
                vehicleClass_22 = "عجلة مفتوحة",
                vehicleClass_3 = "كوبيه",
                vehicleClass_4 = "العضلات",
                vehicleClass_5 = "الكلاسيكية الرياضية",
                vehicleClass_6 = "الرياضة الرياضية",
                vehicleClass_7 = "سوبر سوبر",
                vehicleClass_8 = "دراجات نارية",
                vehicleClass_9 = "الطرق الوعرة",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "مانع تأخير التوربو (Anti-Lag)a40074848905d12c107f984aac5d9776",
                    values = {
                        [0] = "معطل",
                        [1] = "GTA قياسي",
                        [2] = "شارع بوبس",
                        [3] = "سباق مكافحة لاغ",
                        [4] = "رالي مكافحة لاغ",
                    },
                },
                electronic_automatic_hazards = {
                    label = "المخاطر التلقائية",
                    values = {
                        [0] = "إيقاف",
                        [1] = "تشغيل",
                    },
                },
                electronic_brake_lights = {
                    label = "أضواء الفرامل",
                    values = {
                        [0] = "عادي",
                        [1] = "فلاش الطوارئ",
                        [2] = "إيقاف",
                    },
                },
                electronic_engine_tune = {
                    label = "برامج المحرك",
                    values = {
                        [0] = "المخزون",
                        [1] = "المرحلة 1",
                        [2] = "المرحلة 2",
                        [3] = "المرحلة 3",
                        [4] = "المرحلة 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "سطوع المصباح العلوي",
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
                    label = "الشعاع العالي على القرن",
                    values = {
                        [0] = "إيقاف",
                        [1] = "تشغيل",
                    },
                },
                electronic_idle_rpm = {
                    label = "الخمول RPM",
                    values = {
                        [0] = "المخزون",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "الداخلية الخفيفة",
                    values = {
                        [0] = "عادي",
                        [1] = "أحمرa40074848905d12c107f984aac5d9776",
                    },
                },
                electronic_mood_color = {
                    label = "المزاج ضوء اللون",
                    values = {
                        [0] = "إيقاف",
                        [1] = "أحمرa40074848905d12c107f984aac5d9776",
                        [10] = "الجير",
                        [11] = "تيل",
                        [12] = "إنديغو",
                        [13] = "الأبيض",
                        [14] = "أبيض دافئ",
                        [15] = "أبيض بارد",
                        [16] = "العنبر",
                        [2] = "أزرق أزرقa40074848905d12c107f984aac5d9776",
                        [3] = "-a40074848905d12c107f984aac5d9776",
                        [4] = "سيان",
                        [5] = "ماجينتا",
                        [6] = "أصفر",
                        [7] = "البرتقال",
                        [8] = "الأرجواني",
                        [9] = "وردي",
                    },
                },
                electronic_mood_intensity = {
                    label = "شدة ضوء المزاج",
                    values = {
                        [0] = "ديم Dim",
                        [1] = "عادي",
                        [2] = "برايت",
                    },
                },
                electronic_radio_power = {
                    label = "راديو السلطة",
                    values = {
                        [0] = "إيقاف",
                        [1] = "تشغيل",
                    },
                },
                electronic_throttle_response = {
                    label = "خنق الاستجابة",
                    values = {
                        [0] = "المزيد من الجر",
                        [1] = "عدواني",
                    },
                },
                electronic_wheelie_tune = {
                    label = "ويلي تون",
                    values = {
                        [0] = "إيقاف",
                        [1] = "لينة",
                        [2] = "مكثفاً",
                    },
                },
            },
            vehicleClassLabel = "فئة {id} ({name})",
        },
    },
}
