JobConfigLocales["sky_crimesystem:ar"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "الأمر المباشر",
            roleDefaults = {
                title = "الرتب",
                description = "اختر الحد الأدنى للرتبة لكل صلاحية افتراضية. تتقدم صلاحيات الرتب المحفوظة في قائمة المدير.",
                bossHint = "تحتفظ رتب المدير ونائبه دائماً بكامل الصلاحيات.",
                empty = "لا توجد رتب متاحة لهذه الوظيفة بعد.",
                gradesTitle = "رتب الوظيفة",
                noDefault = "لا توجد صلاحية افتراضية",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "تُطبّق الإعدادات المشتركة على الحقول التي ترثها. تغيير قيمة في صفحة الإعدادات يحول الحقل إلى قيمة مخصصة. تحتفظ الإدخالات الحالية بقيمها.",
            weaponStreetDescription = "عند استخدام جهة اتصال لبيع المخدرات في الشارع، يمكن للخادم أحيانًا شراء سلاح مؤهل. يحدد الخادم الاختيار والسعر والدفع بالكامل.",
            weaponGroups = {
                general = "إعدادات عامة افتراضية",
                access = "إعدادات وصول افتراضية",
                collection = "إعدادات جمع افتراضية",
                production = "إعدادات إنتاج افتراضية",
                market = "إعدادات سوق افتراضية",
                delivery = "إعدادات طلب افتراضية",
                street = "بيع الأسلحة في الشوارع",
            },
            weaponOptions = {
                scrap_search = "تفتيش كومة الخردة",
                player = "لكل لاعب",
                global = "عالمي",
                money = "نقد",
                bank = "حساب بنكي",
                black_money = "أموال سوداء",
                timing = "أوقف المؤشر داخل النطاق الأمثل.",
                precision = "قم بتوقيت كل عملية قطع داخل نافذة الدقة.",
                pressure = "أوقف المكبس عند ضغطه الأمثل.",
            },

            reputation = {
                remove = "حذف",
                title = "السمعة",
                action = "الإجراء",
                points = "النقاط لكل إكمال",
                enabled = "مفعّل",
                search = "البحث عن إجراءات",
                added = "تمت إضافته",
                noResults = "لم يتم العثور على إجراءات مطابقة.",
                empty = "لا توجد إجراءات بعد. استخدم زر الإضافة لإضافة إجراء.",
                name = "اسم القاعدة",
                target = "الهدف (اختياري)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "فصائل",
                    subtitle = "تكوين وظائف الجريمة ومواقعها المشتركة.",
                    title = "نظام الجريمة",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "القاعدة الرئيسية",
                    entryPluralLabel = "القواعد الرئيسية",
                    label = "منطقة القاعدة الرئيسية",
                },
                presetTerritories = {
                    label = "المناطق المحددة مسبقاً",
                    entryLabel = "منطقة محددة مسبقاً",
                    entryPluralLabel = "المناطق المحددة مسبقاً",
                },
                customTerritories = {
                    label = "مناطق مخصصة",
                    entryLabel = "منطقة مخصصة",
                    entryPluralLabel = "مناطق مخصصة",
                },
                objectsSection = {
                    label = "أغراض الاستجواب",
                    entryLabel = "كائن",
                    entryPluralLabel = "أغراض الاستجواب",
                },
                blockedZonesSection = {
                    label = "المناطق المحظورة",
                    entryLabel = "منطقة",
                    entryPluralLabel = "المناطق المحظورة",
                },
                toolsSection = {
                    label = "أدوات",
                    entryLabel = "أداة",
                    entryPluralLabel = "أدوات",
                },
                sessionsSection = {
                    label = "جلسات الاستجواب الجارية",
                    entryLabel = "جلسة",
                    entryPluralLabel = "جلسات الاستجواب الجارية",
                },
                orphansSection = {
                    label = "عناصر يتيمة",
                    entryLabel = "كائن",
                    entryPluralLabel = "عناصر يتيمة",
                },
            },
            darknetActions = {
                currentLocation = "استخدام الموقع الحالي",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "القيم الأعلى تجعل العناية السيئة أبطأ بكثير مع الحفاظ على مكافآت قوية للعناية الجيدة.",
                    label = "منحنى استجابة العناية",
                },
                drugGrowthMaxMultiplier = {
                    description = "تم الوصول إلى الحد الأقصى لمضاعف النمو في ظل ظروف ممتازة.",
                    label = "مضاعف العناية المثالية",
                },
                drugGrowthMinMultiplier = {
                    description = "يتم استخدام مضاعف النمو عندما تكون ظروف النبات سيئة للغاية.",
                    label = "مضاعف العناية الحرجة",
                },
                drugGrowthQualityBonusMax = {
                    description = "الحد الأقصى لمكافأة النمو الإضافية الممنوحة من جودة النبات.",
                    label = "مكافأة نمو الجودة",
                },
            },
            errors = {
                invalid_role_permission_defaults = "اختر رتباً دنيا صالحة لصلاحيات الرتب.",
                base_raid_locked = "القاعدة تتعرض للمداهمة. تم قفل مواقع التخزين والإعدادات الخاصة بها.",
                base_storage_outside_zone = "يجب أن تكون جميع نقاط التخزين والخزائن وتخزين عمليات السطو داخل منطقة القاعدة.",
                base_zone_invalid_polygon = "ضع ثلاث نقاط متميزة على الأقل دون تقاطع الحواف، ثم تحقق من الارتفاع (3–200 م) وفئة التوجيه.",
                base_zone_point_limit = "تدعم منطقة القاعدة الرئيسية بحد أقصى 64 من نقاط الحدود.",
                base_zone_required = "قم بتكوين منطقة قاعدة رئيسية صالحة لهذه الوظيفة الإجرامية أولاً.",
                crime_interrogation_invalid_model = "أدخل نموذج كائن صالحًا.",
                crime_interrogation_invalid_coords = "ضع الكائن في موقع صالح.",
                crime_interrogation_invalid_zone_points = "ضع ثلاث نقاط حدود صالحة على الأقل.",
                crime_interrogation_duplicate_id = "يوجد كائن بهذا المعرّف بالفعل.",
                crime_interrogation_tool_invalid = "تحقق من تعريف الأداة.",
                crime_interrogation_tool_id_invalid = "أدخل معرّف أداة صالحًا.",
                crime_interrogation_tool_label_missing = "أدخل اسمًا للأداة.",
                crime_interrogation_effect_missing = "اضبط تأثيرًا للأداة.",
                crime_interrogation_effect_type_unknown = "اختر نوع تأثير مدعومًا.",
                crime_interrogation_effect_status_missing = "حدد الحالة التي تؤثر فيها هذه الأداة.",
                crime_interrogation_minigame_missing = "اضبط لعبة مصغرة للأداة.",
                crime_interrogation_minigame_type_unknown = "اختر نوع لعبة مصغرة مدعومًا.",
                crime_interrogation_keys_missing = "اضبط عناصر التحكم بالأداة.",
                crime_interrogation_keys_invalid = "تحقق من عناصر التحكم المحددة للأداة.",
                crime_interrogation_keys_duplicate = "عيّن كل إجراء وعنصر تحكم للأداة مرة واحدة فقط.",
                crime_interrogation_anim_invalid = "تحقق من قاموس الحركة ومقطعها للأداة.",
                crime_interrogation_anim_missing = "اضبط حركة لمستخدم الأداة.",
                crime_interrogation_occupied = "هناك شخص مقيد بالفعل بهذا الشيء.",
                crime_interrogation_not_found = "لم يعد هذا موجوداً.",
            },
            extensions = {
                baseZone = {
                    description = "ضع من 3 إلى 64 نقطة حدودية بالترتيب. تحدد أدنى نقطة يتم وضعها القاعدة؛ ويمتد الارتفاع للأعلى من هناك. يتم حفظ النقاط كمسودة؛ استخدم حفظ لتطبيق المنطقة. لا تمنع النقاط خارج المنطقة عملية الحفظ أو بدء السطو. تظل الحدود الحالية نشطة حتى تقوم بالحفظ.",
                    fields = {
                        bucket = "دلو التوجيه",
                        configured = "تم الضبط",
                        height = "الارتفاع (أمتار)",
                        radius = "نصف القطر (أمتار)",
                        x = "مركز X",
                        y = "مركز Y",
                        z = "مركز Z",
                    },
                    label = "منطقة القاعدة الرئيسية",
                },
                invalidSelection = "اختيار غير صالح: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "النقطة الرئيسية لموقع هذه الوظيفة. إذا تم تفعيل علامة الخريطة (Blip) تحت الوظيفة ← العلامات، فستظهر هنا.",
            },
            locationTypes = {
                crimeStationPosition = "موقع / علامة خريطة",
                heistCrafting = "ورشة عمل عملية السطو",
                heistStorage = "مخزن السطو",
            },
            membershipMigration = {
                cancel = "إلغاء",
                confirm = "نقل وحفظ",
                message = "سيتم نقل عضويات المنظمات الحالية إلى النموذج المختار. تظل الوظائف العادية منفصلة في الوضع المستقل.",
                title = "تغيير نموذج العضوية؟",
            },
            moneywashActions = {
                currentLocation = "استخدام الموقع الحالي",
                invalidLocations = "تحقق من المعرفات، والأسماء، واختيارات التصميم الداخلي، والإحداثيات. يحتاج كل موقع إلى معرف فريد.",
                position = "الموقع",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "نقاط البناء", description = "ضع الأجهزة المتوافقة على هذه النقاط. الإحداثيات إزاحات عن الداخل المختار." },
                mwBuildNodes = "نقاط البناء",
                moneywashPublicEquipment = { label = "معدات عامة", description = "عيّن الغسالات والمولدات والمراوح للمواقع العامة ونقاط البناء المتوافقة." },
                mwPublicEquipment = "معدات عامة",
                moneywashMaterials = { label = "مواد", description = "استخدم أسماء عناصر المخزون الدقيقة. الوزن بالغرام؛ ثبّت العناصر الناقصة في نظام المخزون." },
                mwMaterials = "مواد",
                moneywashMaterialRecipes = { label = "وصفات المواد", description = "المدخلات والمخرجات والمدة لكل وحدة. تستخدم المعالجات هذه الوصفات." },
                mwMaterialRecipes = "وصفات المواد",
                moneywashProductionRecipes = { label = "وصفات الطباعة", description = "الورق والحبر وأوقات المراحل لكل وحدة. تُدفع النقود بعد التجفيف وفحص الجودة." },
                mwProductionRecipes = "وصفات الطباعة",
                moneywashCollectors = { label = "جامعو المواد", description = "اضبط الإنتاج والأداة والانتظار والموقع لكل جامع." },
                mwCollectors = "جامعو المواد",
                moneywashProcessors = { label = "معالجو المواد", description = "اختر وصفة المواد والموقع لكل معالج." },
                mwProcessors = "معالجو المواد",

                control = "لوحة التحكم",
                editor = {
                    addBusiness = "إضافة عمل تجاري",
                    addInterior = "إضافة تصميم داخلي",
                    advanced = "التفاصيل التقنية",
                    asset_ipl = "IPL: أدخل اسم الـ IPL الدقيق وموقع التصميم الداخلي.",
                    asset_mlo = "MLO: استخدم موقع تصميم داخلي مثبت مسبقاً. الوصول يستخدم حالياً مدخل الشركة.",
                    asset_shell = "Shell: يجب أن يكون مورد النموذج مثبتاً ويعمل على الخادم.",
                    businessHelp = "قم بتسمية العمل التجاري، اختر التصميم الداخلي، وحدد سعر الشراء.",
                    businessListHelp = "إدارة المداخل وأسعار الشراء لأعمالك التجارية.",
                    businesses = "الشركات",
                    capture = "التعيين في اللعبة",
                    captureOrigin = "تعيين موقع التصميم الداخلي",
                    chooseInterior = "اختر تصميماً داخلياً",
                    coordinates = "تعديل الإحداثيات",
                    editSections = "الإعداد",
                    emptyBusinessHelp = "اربط مدخلاً على الخريطة بتصميم داخلي. يمكن لمنظماتكم بعد ذلك شراء الشركة الفارغة.",
                    emptyBusinesses = "أول شركة لك",
                    emptyInteriorHelp = "قم بربط IPL أو Shell أو MLO مثبت، ثم حدد النقاط المستخدمة في العمل التجاري.",
                    emptyInteriors = "أول تصميم داخلي لك",
                    entranceHelp = "حدد المدخل حيث يجب على اللاعبين شراء العمل التجاري والدخول إليه.",
                    freecamHelp = "كاميرا حرة: WASD للتحرك، Q/E للأعلى/الأسفل، Shift للسرعة، Ctrl للبطء. زر الفأرة الأيمن: للنظر. اسحب الأداة، R للتدوير/التحريك، Enter للتثبيت، Backspace للإلغاء.",
                    general = "عام",
                    heading = "الاتجاه",
                    interiorHelp = "اختر نوع التصميم الداخلي والأصل الخاص به.",
                    interiorListHelp = "تجهيز المساحات الفارغة. يقوم اللاعبون بوضع آلاتهم ومعداتهم الخاصة.",
                    interiors = "التصاميم الداخلية",
                    listEmpty = "لا توجد إدخالات بعد.",
                    locationTypes = "إدارة المواقع",
                    newBusiness = "عمل تجاري جديد",
                    newInterior = "تصميم داخلي جديد",
                    noResults = "لا توجد نتائج مطابقة.",
                    notSet = "لم يتم التعيين",
                    offsetHelp = "قيم الإدخال هي إزاحات عن نقطة الأصل. يتم عرض موقع العالم في الأعلى.",
                    origin = "الأصل",
                    originHelp = "موقع التصميم الداخلي. جميع النقاط الأخرى تعتمد عليه.",
                    originRequired = "قم بتعيين موقع التصميم الداخلي ضمن العام أولاً.",
                    outsideRange = "خارج نطاق {range} متر",
                    point_control = "حرك ودوّر لوحة الحائط في مكانها باستخدام الأداة. سيتم الحفاظ على ارتفاع الكائن المؤكد بدقة. قم بتبديل علامتها تحت التفاعلات ← غسيل الأموال: لوحة التحكم.",
                    point_entry = "يصل اللاعبون ويغادرون من هنا. المغادرة تعيدهم تلقائياً إلى مدخل شركتهم في الخارج.",
                    point_position = "هذه النقطة تقع خارج الشركة.",
                    point_storage = "حرك ودوّر الرف باستخدام الأداة حتى يستقر على الأرض. يمكن للأعضاء الوصول إلى المعدات المشتراة من هنا. قم بتبديل علامتها تحت التفاعلات ← غسيل الأموال: المخزن.",
                    points = "النقاط",
                    pointsHelp = "اختر نقطة وقم بتعيينها مباشرة داخل اللعبة.",
                    rangeNote = "ينطبق نطاق {range}-متر حول نقطة الأصل للتصميم الداخلي، بدون قيود على الارتفاع.",
                    remove = "إزالة",
                    repairRange = "حرك هذه النقاط لتكون أقرب إلى نقطة أصل التصميم الداخلي.",
                    saveHint = "طبق التغييرات عبر الضغط على حفظ في الأعلى.",
                    search = "بحث …",
                    set = "تعيين",
                    teleport = "النقل الفضائي",
                    viewInteriors = "عرض التصاميم الداخلية",
                    visit = "زيارة",
                    visitHint = "تحرك بحرية. اضغط Backspace للعودة إلى المحرر.",
                    visitTitle = "زيارة التصميم الداخلي",
                },
                entry = "الدخول والخروج",
                fields = {
                    mode = "نوع الدخول",
                    ownerKind = "نوع المالك",
                    productionEnabled = "توسعة الطباعة متاحة",
                    feePercent = "الرسوم (%) / -1 = عام",
                    storageCapacity = "سعة المواد (عناصر)",
                    maximumOrders = "الطلبات المتزامنة لكل لاعب",
                    gridPower = "طاقة الشبكة / 0 = مولد",
                    autoService = "صيانة عامة تلقائية",
                    maximumPendingOutputs = "أقصى دفعات معلقة",
                    placementRange = "نصف قطر الوضع (م)",
                    placementHeight = "نطاق ارتفاع الوضع (م)",
                    interiorId = "معرف الداخل",
                    equipmentId = "معرف الجهاز",
                    nodeId = "معرف نقطة البناء",
                    generatorNode = "معرف نقطة المولد",
                    maxOffset = "أقصى إزاحة للنقطة (م)",
                    maxHeight = "أقصى إزاحة رأسية (م)",
                    weight = "وزن العنصر (غ)",
                    inputItem = "مادة الإدخال",
                    secondItem = "مادة إدخال ثانية",
                    outputItem = "مادة الإخراج",
                    requiredTool = "الأداة المطلوبة",
                    baseQuality = "الجودة الأولية (%)",
                    minimumQuality = "الحد الأدنى للجودة (%)",
                    inspectionCards = "بطاقات الفحص",
                    inspectionPenalty = "فقدان الجودة لكل خطأ (%)",
                    rejectPercent = "الأوراق المرفوضة (%)",
                    accessoryModel = "نموذج الملحق",
                    accessoryMaximum = "أقصى ملحقات ظاهرة",
                    accessoryActiveOnly = "الملحقات أثناء المعالجة فقط",
                    animDict = "قاموس الحركة",
                    animClip = "مقطع الحركة",
                    cooldown = "الانتظار (ثوانٍ)",
                    minimum = "أدنى إنتاج",
                    maximum = "أقصى إنتاج",
                    productionPrice = "طباعة الأموال · سعر الشراء",
                    recipeId = "وصفة ID",
                    inputAmount = "مادة / لكل وحدة",
                    secondAmount = "مادة / لكل وحدة",
                    outputAmount = "مادة / لكل وحدة",
                    paperItem = "ورق الطباعة",
                    inkItem = "حبر الطباعة",
                    paperAmount = "ورق الطباعة / لكل وحدة",
                    inkAmount = "حبر الطباعة / لكل وحدة",
                    notesPerUnit = "أوراق نقدية / لكل وحدة",
                    valuePerNote = "نقد / أوراق نقدية",
                    maximumUnits = "وحدات (max.)",
                    printSeconds = "الطباعة / لكل وحدة (ثوانٍ)",
                    inspectionSeconds = "الفحص / لكل وحدة (ثوانٍ)",
                    rinseSeconds = "الغسل / لكل وحدة (ثوانٍ)",
                    drySeconds = "التجفيف / لكل وحدة (ثوانٍ)",
                    accessoryUnit = "أوراق نقدية / لكل وحدة",
                    accessoryX = "نموذج الملحق · X (m)",
                    accessoryY = "نموذج الملحق · Y (m)",
                    accessoryZ = "نموذج الملحق · Z (m)",
                    accessoryStep = "نموذج الملحق · Z (m)",

                    capacity = "السعة لكل دورة",
                    controlHeading = "اتجاه لوحة التحكم",
                    controlHeight = "ارتفاع التركيب فوق النقطة (متر)",
                    controlModel = "طراز لوحة الحائط",
                    controlX = "لوحة التحكم X",
                    controlY = "لوحة التحكم Y",
                    controlZ = "لوحة التحكم Z",
                    disableSets = "مجموعات الكيانات المخفية (مفصولة بفاصلة)",
                    enableSets = "مجموعات الكيانات المفعلة (مفصولة بفاصلة)",
                    entryX = "إزاحة الدخول X",
                    entryY = "إزاحة الدخول Y",
                    entryZ = "إزاحة الدخول Z",
                    heading = "اتجاه المواجهة",
                    id = "معرف فريد",
                    interior = "التصميم الداخلي",
                    ipl = "اسم IPL",
                    kind = "النوع",
                    label = "الاسم",
                    model = "اسم النموذج",
                    power = "وحدات الطاقة",
                    price = "سعر الشراء",
                    radius = "نطاق الوضع (متر)",
                    repairPrice = "سعر الإصلاح (0 = مجاني)",
                    seconds = "مدة الدورة (بالثواني)",
                    storageHeading = "اتجاه نقطة التخزين",
                    storageModel = "نموذج الرف",
                    storageX = "نقطة التخزين X",
                    storageY = "نقطة التخزين Y",
                    storageZ = "نقطة التخزين Z",
                    wear = "الاستهلاك لكل دورة (%)",
                    x = "الأصل X",
                    y = "الأصل Y",
                    z = "الأصل Z",
                },
                interactions = {
                    control = "Money Wash: لوحة التحكم",
                    storage = "Money Wash: المخزن",
                },
                item = "السجل",
                moneywashBucketStart = {
                    description = "احجز هذا النطاق حصرياً لعملية غسيل الأموال. تُطبق التغييرات عند الدخول التالي.",
                    label = "بداية نطاق النسخة",
                },
                moneywashEquipment = {
                    description = "يشتري اللاعبون الأجهزة ويضعونها. تنطبق السعة والمدة والتهالك على الغسالات. الطاقة هي إمداد المولد أو طلب الجهاز. تؤثر التغييرات على المشتريات الجديدة.",
                    label = "معدات قابلة للشراء",
                },
                moneywashInteriors = {
                    description = "إعداد تصاميم داخلية فارغة من نوع IPL أو Shell أو MLO. نقاط الدخول، ولوحة التحكم، والمخزن، وحدود البناء تعتمد على نقطة الأصل. عند المغادرة، يعود اللاعبون إلى مدخل عملهم التجاري.",
                    label = "التصاميم الداخلية (IPL أو Shell أو MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "الحد الأقصى للأجهزة ومجموعات الإصلاح المشتراة لكل شركة.",
                    label = "حد المعدات",
                },
                moneywashPreviewBucketStart = {
                    description = "تستخدم الزيارة معرف اللاعب لهذا القيمة لإنشاء نسخة مشرف خاصة. يتم حجزها بشكل منفصل عن الشركات والموارد الأخرى. تُطبق التغييرات على المعاينة التالية.",
                    label = "بداية نطاق معاينة النسخة",
                },
                moneywashProperties = {
                    description = "قم بتعيين مدخل، واختر تصميماً داخلياً، وحدد سعر الشراء. تحتفظ الشركات التي تم شراؤها بتصميمها الداخلي وتخطيطها المحفوظ.",
                    label = "مداخل العمل التجاري",
                },
                moneywashRepairShops = {
                    description = "قم بتعيين متاجر الإصلاح، والانتقال إليها، وتحديد سعر الخدمة. تقوم هذه المتاجر ببيع مجموعات الإصلاح وصيانة الآلات المخزنة.",
                    label = "مواقع المتاجر",
                },
                moneywashShops = {
                    description = "ضع متاجر للغسالات، والمولدات، والمراوح. تذهب الطلبات إلى عمل المنظمة المختار.",
                    label = "مواقع المتاجر",
                },
                mwEquipment = "متجر المعدات",
                mwInteriors = "تصاميم داخلية فارغة",
                mwProperties = "المواقع",
                mwRepairShops = "ورشة الإصلاح",
                mwSettings = "إعدادات العمل التجاري",
                names = {
                    mwPublicLaundry = "مغسلة عامة",
                    mwPaperPulp = "لب الورق",
                    mwPrintingPaper = "ورق الطباعة",
                    mwPrintingInk = "حبر الطباعة",
                    mwPaperRecipe = "صنع ورق الطباعة",
                    mwPrintingRecipe = "أوراق نقدية عادية",
                    mwPaperCollector = "جامع الورق",
                    mwInkCollector = "جامع الحبر",
                    mwPaperProcessor = "معالج الورق",
                    mwPrinter = "آلة الطباعة",
                    mwInspectionTable = "طاولة الفحص",
                    mwDryingCabinet = "خزانة التجفيف",
                    mwNode1 = "1 · الغسل",
                    mwNode2 = "2 · الغسل",
                    mwNode3 = "3 · نقاط البناء",
                    mwNode4 = "4 · الطباعة",
                    mwNode5 = "5 · الفحص",
                    mwNode6 = "6 · التجفيف",
                    mwNode7 = "7 · نقاط البناء",

                    mwInteriorWarehouse = "مستودع فارغ",
                },
                options = {
                    private = "خاص",
                    public = "عام",
                    faction = "منظمة",
                    person = "شخصية",
                    printer = "آلة الطباعة",
                    inspection = "طاولة الفحص",
                    dryer = "خزانة التجفيف",

                    fan = "مروحة",
                    generator = "مولد كهربائي",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "طقم إصلاح",
                    shell = "نموذج Shell",
                    washer = "غسالة ملابس",
                },
                origin = "الأصل",
                storage = "نقطة التخزين",
            },
            settingFields = {
                cultivationLevel = "مستوى الزراعة",
                cultivationTitle = "اسم المستوى",
                cultivationRequiredXp = "إجمالي الخبرة المطلوبة",
                cultivationAction = "الإجراء",
                cultivationXp = "الخبرة",
                cultivationCategory = "الفئة",
                cultivationEntry = "العنصر",
                cultivationRequiredLevel = "المستوى المطلوب",
                alias = "اسم مستعار",
                atmHeading = "الاتجاه",
                atmId = "ID",
                atmModel = "طراز الصراف الآلي",
                centerX = "المركز X",
                centerY = "المركز Y",
                centerZ = "المركز Z",
                deliveryMethod = "طريقة التسليم",
                description = "الوصف",
                enabled = "مُفعل",
                groupKey = "مفتاح المجموعة",
                id = "ID",
                itemLabel = "تسمية البضائع",
                itemName = "اسم عنصر الحقيبة",
                knownScammer = "محتال معروف",
                locationName = "اسم الموقع",
                observerW = "اتجاه المراقب",
                observerX = "المراقب X",
                observerY = "المراقب Y",
                observerZ = "المراقب Z",
                pedModel = "موديل شخصية الـ NPC",
                pickpocketItemChance = "النسبة (%)",
                pickpocketItemMaximum = "الحد الأقصى للمبلغ",
                pickpocketItemMinimum = "الحد الأدنى للمبلغ",
                pickpocketItemName = "اسم عنصر الحقيبة",
                quantity = "الكمية",
                radius = "نصف القطر",
                rating = "التقييم المعروض",
                ratingCount = "عدد التقييمات المعروضة",
                scamChance = "نسبة احتمال خداع التاجر (%)",
                shopCategory = "الفئة",
                shopClerkHeading = "اتجاه الموظف",
                shopClerkModel = "طراز الموظف",
                shopClerkRequired = "يتطلب وجود موظف",
                shopClerkX = "الموظف X",
                shopClerkY = "الموظف Y",
                shopClerkZ = "الموظف Z",
                shopCodeEnabled = "السماح بالفتح عبر الرمز",
                shopDrillEnabled = "السماح بالثقب",
                shopEnabled = "مفعّل",
                shopHackEnabled = "السماح بالاختراق",
                shopLocationId = "معرف المتجر",
                shopLocationLabel = "التسمية",
                shopRegisterId = "معرف السجل",
                shopSafeEnabled = "تفعيل الخزنة",
                shopSafeHeading = "اتجاه الخزنة",
                shopSafeX = "الخزنة X",
                shopSafeY = "الخزنة Y",
                shopSafeZ = "الخزنة Z",
                side = "جانب السوق",
                spawns = "نقاط ظهور الفريق",
                successfulTrades = "الصفقات الناجحة المعروضة",
                title = "عنوان العرض",
                unitPrice = "سعر الوحدة",
                verified = "تاجر موثوق",
                w = "الاتجاه",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "موقع الموظف",
                shopRegisterPosition = "موقع آلة تسجيل النقد",
                shopSafePosition = "موقع الخزنة",
                registerId = "معرّف صندوق الدفع",
                registerX = "إحداثي X لصندوق الدفع",
                registerY = "إحداثي Y لصندوق الدفع",
                registerZ = "إحداثي Z لصندوق الدفع",
                heading = "الاتجاه",
                captureLocation = "تحديد الموقع",
            },
            crimeDashboard = {
                jobs = "إدارة الفصائل والأعضاء والصلاحيات والمواقع.",
                jobCreator = "اختر فصيلاً لتعديل مواقعه ومناطقه.",
                jobsQuestion = "أين أعدّل الفصائل والمواقع؟",
                jobsAnswer = "افتح {path}، واختر فصيلاً ثم تعديل. يمكنك ضبط إعداداته ومواقعه هناك.",
                creatorsAnswer = "تجد أدوات الإنشاء ضمن {path}. تفتح هذه الروابط المحرر، وتبدأ أدوات الفصائل باختيار فصيل.",
                missingAnswer = "تعتمد أدوات الإنشاء المتاحة على المورد وإعداداته. تبدأ أدوات الفصائل بالفصيل المعني.",
                creators = {
                    mainbaseZones = "اختر فصيلاً واضبط منطقة قاعدته.",
                    presetTerritories = "راجع المناطق المحددة مسبقاً واختر المناطق المفعّلة.",
                    objectsSection = "إدارة كراسي الاستجواب وعربات الأدوات الدائمة.",
                    blockedZonesSection = "حدد المناطق التي يُمنع فيها وضع عناصر الاستجواب.",
                    toolsSection = "اضبط الأدوات المتاحة أثناء الاستجواب.",
                    sessionsSection = "اعرض الاستجوابات النشطة وأنهِ الجلسات عند الحاجة.",
                    orphansSection = "راجع عناصر الاستجواب المهجورة وأزلها.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "حدد كيفية قيام المنظمات الإجرامية بتخزين وإدارة أعضائها.",
                },
                territories = {
                    zones = "اضبط إعدادات «مناطق النفوذ» في قسم «الأقاليم».",
                    ownership = "اضبط إعدادات «الملكية» في قسم «الأقاليم».",
                    decay = "اضبط إعدادات «الاضمحلال» في قسم «الأقاليم».",
                    presence = "اضبط إعدادات «التواجد» في قسم «الأقاليم».",
                    activity = "اضبط إعدادات «تقييم النشاط» في قسم «الأقاليم».",
                    ownershipBenefits = "اضبط إعدادات «مزايا الملكية» في قسم «الأقاليم».",
                },
                graffiti = {
                    general = "اضبط إعدادات «عام» في قسم «الجرافيتي».",
                    streaming = "اضبط إعدادات «جاري التحميل» في قسم «الجرافيتي».",
                    moderation = "اضبط إعدادات «الإشراف» في قسم «الجرافيتي».",
                },
                pvpEvents = {
                    pvpAvailability = "التحكم في توفر تطبيق أحداث الـ PvP ومكان ظهوره.",
                    pvpAutomation = "تكوين الأحداث المتكررة ومعالجة البدء التلقائي.",
                    pvpRuntime = "ضبط معالجة الطلبات، والوفيات، وإعادة الظهور أثناء المباريات المباشرة.",
                    pvpModes = "تكوين وضع اللعب المحدد مسبقاً في جهاز الـ PvP اللوحي.",
                    pvpArenas = "إنشاء المنطقة الدائرية، ونقطة المراقبة، ونقاط ظهور الفريق المستخدمة في أحداث الـ PvP.",
                    pvpLimits = "تحديد حدود المكافآت وسجل الجهاز اللوحي.",
                    pvpPermissions = "ربط إدارة الأحداث والتمويل بصلاحيات ACE والوظائف.",
                    pvpTakeoverRules = "التحكم في التوافر ومتطلبات المشاركة لعمليات الاستيلاء على المختبرات وعربات التخييم.",
                    pvpTakeoverZones = "تكوين مناطق التفاعل والتنبيه والاستيلاء مع مدة كل منها.",
                    pvpTakeoverMethods = "حدد المدة التي تستغرقها كل طريقة لاقتحام مدخل ما.",
                },
                drugs = {
                    creator = "يفتح محرر المخدرات في Sky Crime ويغلق أداة إعداد الوظائف.",
                    creatorSettings = "اضبط إعدادات «إعدادات المحرر» في قسم «نظام المخدرات».",
                    interfaceHud = "اضبط إعدادات «مواضع الواجهة» في قسم «نظام المخدرات».",
                    drugsGeneral = "اضبط إعدادات «عام» في قسم «نظام المخدرات».",
                    runtimeAccess = "اضبط إعدادات «الوصول والملكية» في قسم «نظام المخدرات».",
                    runtimePayouts = "اضبط إعدادات «المدفوعات» في قسم «نظام المخدرات».",
                    runtimeDispatch = "اضبط إعدادات «العمليات والشرطة» في قسم «نظام المخدرات».",
                    performanceInactiveControlIntervalMs = "إعداد التشغيل الخاص بـ الأداء / غير نشط / التحكم / الفاصل الزمني / مللي ثانية.",
                    performanceInteractionIdleScanIntervalMs = "إعداد التشغيل الخاص بـ الأداء / تفاعل / خاملاً / فاصل الفحص / مللي ثانية.",
                    performanceInteractionPromptIntervalMs = "إعداد التشغيل الخاص بـ الأداء / تفاعل / إرشاد التفاعل / الفاصل الزمني / مللي ثانية.",
                    performanceInteractionScanIntervalMs = "إعداد التشغيل الخاص بـ الأداء / تفاعل / فاصل الفحص / مللي ثانية.",
                    performanceMinimumScanIntervalMs = "إعداد التشغيل الخاص بـ الأداء / الحد الأدنى / فاصل الفحص / مللي ثانية.",
                    performanceStreetPedActivationDistance = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / تفعيل / المسافة.",
                    performanceStreetPedIdleScanIntervalMs = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / خاملاً / فاصل الفحص / مللي ثانية.",
                    performanceStreetPedScanIntervalMs = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / فاصل الفحص / مللي ثانية.",
                    performanceWorldCachePadding = "إعداد التشغيل الخاص بـ الأداء / العالم / ذاكرة التخزين المؤقت / الهامش الإضافي.",
                    performanceWorldCacheRefreshIntervalMs = "إعداد التشغيل الخاص بـ الأداء / العالم / ذاكرة التخزين المؤقت / التحديث / الفاصل الزمني / مللي ثانية.",
                    performanceWorldIdleIntervalMs = "إعداد التشغيل الخاص بـ الأداء / العالم / خاملاً / الفاصل الزمني / مللي ثانية.",
                },
                drugProduction = {
                    qualityWeights = "اضبط إعدادات «الجودة / الأوزان» في قسم «إنتاج المخدرات».",
                    qualityTiers = "اضبط إعدادات «الجودة / مستويات الجودة» في قسم «إنتاج المخدرات».",
                    packagingGeneral = "اضبط إعدادات «عام» في قسم «إنتاج المخدرات».",
                    processingFlow = "اضبط إعدادات «سير المعالجة» في قسم «إنتاج المخدرات».",
                    processingGeneral = "اضبط إعدادات «عام» في قسم «إنتاج المخدرات».",
                },
                drugOperations = {
                    growingGeneral = "اضبط إعدادات «عام» في قسم «عمليات المخدرات».",
                    plantDefaults = "اضبط إعدادات «نبات / القيم الافتراضية» في قسم «عمليات المخدرات».",
                    harvestWindow = "اضبط إعدادات «الحصاد / النافذة الزمنية» في قسم «عمليات المخدرات».",
                    labsGeneral = "يُفعّل: المختبرات والمركبات السكنية أثناء اللعب.",
                    labRent = "اضبط إعدادات «الإيجار ودورة الحياة» في قسم «عمليات المخدرات».",
                    camperDefaults = "اضبط إعدادات «عربة التخييم» في قسم «عمليات المخدرات».",
                    labUpgrades = "المضاعف لـ مختبر / المستوى / الترقية / الأسعار.",
                    labDefaults = "اضبط إعدادات «مختبر / القيم الافتراضية» في قسم «عمليات المخدرات».",
                    powerGeneral = "اضبط إعدادات «عام» في قسم «عمليات المخدرات».",
                    generators = "اضبط إعدادات «المولدات» في قسم «عمليات المخدرات».",
                    equipmentWear = "المضاعف العام لـ تآكل المعدات / المعالجة.",
                    workersGeneral = "اضبط إعدادات «عام» في قسم «عمليات المخدرات».",
                    cultivationGeneral = "اضبط إعدادات «عام» في قسم «عمليات المخدرات».",
                    cultivationCurve = "اضبط الاسم وإجمالي الخبرة المطلوبة لكل مستوى زراعة.",
                    cultivationExperience = "اضبط مقدار خبرة الزراعة التي يمنحها كل إجراء.",
                    cultivationUnlocks = "اضبط المستوى المطلوب للحاويات والركائز والمعدات والسلالات ومستويات الماسح.",
                    powerRuntime = "الفاصل بالثواني لـ تحديث استهلاك المولدات والبصمات الكهربائية.",
                    powerHeat = "اضبط إعدادات «اهتمام الشرطة والبصمة الكهربائية» في قسم «عمليات المخدرات».",
                    powerModes = "اضبط إعدادات «الإدارة / الأوضاع» في قسم «عمليات المخدرات».",
                    powerPriorities = "اضبط إعدادات «الحمل / الأولويات» في قسم «عمليات المخدرات».",
                },
                drugMarketRisk = {
                    marketGeneral = "اضبط إعدادات «عام» في قسم «السوق والمخاطر».",
                    marketPrices = "اضبط إعدادات «الأسعار» في قسم «السوق والمخاطر».",
                    distribution = "اضبط إعدادات «التوزيع» في قسم «السوق والمخاطر».",
                    threatsGeneral = "اضبط إعدادات «عام» في قسم «السوق والمخاطر».",
                    threatHeat = "اضبط إعدادات «الضغط الأمني» في قسم «السوق والمخاطر».",
                    threatChances = "اضبط إعدادات «الاحتمالات» في قسم «السوق والمخاطر».",
                    consumptionGeneral = "اضبط إعدادات «عام» في قسم «السوق والمخاطر».",
                    consumerDecay = "اضبط إعدادات «انخفاض التحمل والإدمان» في قسم «السوق والمخاطر».",
                    consumerEffects = "اضبط إعدادات «التأثيرات والمخاطر» في قسم «السوق والمخاطر».",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "إعداد التشغيل الخاص بـ السوق الديناميكي / فترة انتظار الإجراء / ثوانٍ.",
                    dynamicMarketActionHistoryLimit = "إعداد التشغيل الخاص بـ السوق الديناميكي / فعل / حد السجل.",
                    dynamicMarketAmountSaturationWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / الكمية / التشبع / الوزن.",
                    dynamicMarketBaseIntelAccuracy = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأساسية / دقة المعلومات.",
                    dynamicMarketDefaultAverageQuality = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الافتراضية / المتوسط / الجودة.",
                    dynamicMarketDefaultResourceElasticity = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الافتراضية / مورد / المرونة.",
                    dynamicMarketDemandCenter = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطلب / القيمة الوسطية.",
                    dynamicMarketDemandPriceImpact = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطلب / السعر / التأثير.",
                    dynamicMarketDirectionThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / العتبة.",
                    dynamicMarketEnabled = "إعداد التشغيل الخاص بـ السوق الديناميكي / مفعّل.",
                    dynamicMarketEventChance = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / فرصة.",
                    dynamicMarketEventDurationMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / المدة / الدقائق.",
                    dynamicMarketEventMinimumDurationMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / الحد الأدنى / المدة / الدقائق.",
                    dynamicMarketEventStrengthMaximum = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / القوة / الحد الأقصى.",
                    dynamicMarketEventStrengthMinimum = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / القوة / الحد الأدنى.",
                    dynamicMarketEvents = "اضبط إعدادات «الأحداث» في قسم «شبكات المخدرات».",
                    dynamicMarketExactIntelReputation = "إعداد التشغيل الخاص بـ السوق الديناميكي / معلومات دقيقة / السمعة.",
                    dynamicMarketExactIntelTrust = "إعداد التشغيل الخاص بـ السوق الديناميكي / معلومات دقيقة / الثقة.",
                    dynamicMarketGlobalZoneLabel = "إعداد التشغيل الخاص بـ السوق الديناميكي / عامa40074848905d12c107f984aac5d9776 / منطقة / التسمية.",
                    dynamicMarketHistoryLimit = "إعداد التشغيل الخاص بـ السوق الديناميكي / حد السجل.",
                    dynamicMarketInitialDemand = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأولية / الطلب.",
                    dynamicMarketInitialPriceMultiplier = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأولية / مضاعف السعر.",
                    dynamicMarketIntelDemandError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الطلب / خطأ.",
                    dynamicMarketIntelMaximumAccuracy = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحد الأقصى / الدقة.",
                    dynamicMarketIntelMinimumAccuracy = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحد الأدنى / الدقة.",
                    dynamicMarketIntelPoliceError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الشرطة / خطأ.",
                    dynamicMarketIntelPriceError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / خطأ.",
                    dynamicMarketIntelPriceMaximum = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / الحد الأقصى.",
                    dynamicMarketIntelPriceMinimum = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / الحد الأدنى.",
                    dynamicMarketIntelReputationWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السمعة / الوزن.",
                    dynamicMarketIntelResourcePriceError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / مورد / السعر / خطأ.",
                    dynamicMarketIntelSaturationError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / التشبع / خطأ.",
                    dynamicMarketIntelSeedBucketSeconds = "إعداد التشغيل الخاص بـ السوق الديناميكي / فترة بذرة المعلومات العشوائية / ثوانٍ.",
                    dynamicMarketIntelStatusAccuracyThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحالة / الدقة / العتبة.",
                    dynamicMarketIntelStatusErrorThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحالة / خطأ / العتبة.",
                    dynamicMarketIntelSupplyError = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / العرض / خطأ.",
                    dynamicMarketIntelTrustWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الثقة / الوزن.",
                    dynamicMarketManipulationCooldownMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / دقائق فترة الانتظار.",
                    dynamicMarketManipulationDemandShift = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الطلب / التغير.",
                    dynamicMarketManipulationDurationMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / المدة / الدقائق.",
                    dynamicMarketManipulationHeat = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الضغط الأمني.",
                    dynamicMarketManipulationMinimumBatchAmount = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الحد الأدنى / دفعة / الكمية.",
                    dynamicMarketManipulationPaymentAccount = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / حساب الدفع.",
                    dynamicMarketManipulationPrice = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / السعر.",
                    dynamicMarketManipulationZoneHeatMultiplier = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / منطقة / الضغط الأمني / المضاعف.",
                    dynamicMarketMaximumIntelAgeMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأقصى / عمر المعلومة / الدقائق.",
                    dynamicMarketMaximumPriceMultiplier = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأقصى / مضاعف السعر.",
                    dynamicMarketMinimumIntelAgeMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / عمر المعلومة / الدقائق.",
                    dynamicMarketMinimumMetricWindowMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / المقياس / النافذة الزمنية / الدقائق.",
                    dynamicMarketMinimumPriceMultiplier = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى للسعر / المضاعف.",
                    dynamicMarketMinimumUpdateMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / التحديث / الدقائق.",
                    dynamicMarketPoliceDemandWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / الشرطة / الطلب / الوزن.",
                    dynamicMarketPolicePriceImpact = "إعداد التشغيل الخاص بـ السوق الديناميكي / الشرطة / السعر / التأثير.",
                    dynamicMarketPoorQualityDemandPenalty = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة المنخفضة / الطلب / العقوبة.",
                    dynamicMarketPoorQualityThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة المنخفضة / العتبة.",
                    dynamicMarketPremiumQualityDemandBonus = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة الممتازة / مكافأة الطلب.",
                    dynamicMarketPremiumQualityThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة الممتازة / العتبة.",
                    dynamicMarketProductionSupplyWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / الإنتاج / العرض / الوزن.",
                    dynamicMarketProductionWindowMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الإنتاج / النافذة الزمنية / الدقائق.",
                    dynamicMarketQualityCenter = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / القيمة الوسطية.",
                    dynamicMarketQualityConfidenceImpact = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / الثقة / التأثير.",
                    dynamicMarketQualityRange = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / نطاق القيم.",
                    dynamicMarketRarityBonusMaximum = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / مكافأة / الحد الأقصى.",
                    dynamicMarketRegionalGlobalWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / إقليمي / عامa40074848905d12c107f984aac5d9776 / الوزن.",
                    dynamicMarketRegionalLocalWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / إقليمي / محلي / الوزن.",
                    dynamicMarketResourceAliases = "اضبط إعدادات «مورد / الأسماء البديلة» في قسم «شبكات المخدرات».",
                    dynamicMarketResourceDirectionFallThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الاتجاه / الانخفاض / العتبة.",
                    dynamicMarketResourceDirectionRiseThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الاتجاه / الارتفاع / العتبة.",
                    dynamicMarketResources = "اضبط إعدادات «الموارد» في قسم «شبكات المخدرات».",
                    dynamicMarketSalesWindowMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / المبيعات / النافذة الزمنية / الدقائق.",
                    dynamicMarketSaturationDemandWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / التشبع / الطلب / الوزن.",
                    dynamicMarketSaturationPriceImpact = "إعداد التشغيل الخاص بـ السوق الديناميكي / التشبع / السعر / التأثير.",
                    dynamicMarketScarcityDemandWeight = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / الطلب / الوزن.",
                    dynamicMarketScarcityPriceImpact = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / السعر / التأثير.",
                    dynamicMarketSeasonEndMonths = "اضبط إعدادات «الفصل / النهاية / الأشهر» في قسم «شبكات المخدرات».",
                    dynamicMarketSeasonMultipliers = "اضبط إعدادات «الفصل / المضاعفات» في قسم «شبكات المخدرات».",
                    dynamicMarketShortageRumorThreshold = "إعداد التشغيل الخاص بـ السوق الديناميكي / النقص / الإشاعة / العتبة.",
                    dynamicMarketStatusThresholds = "اضبط إعدادات «الحالة / العتبات» في قسم «شبكات المخدرات».",
                    dynamicMarketTargetSupply = "إعداد التشغيل الخاص بـ السوق الديناميكي / هدف / العرض.",
                    dynamicMarketTrendChance = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / فرصة.",
                    dynamicMarketTrendDurationMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / المدة / الدقائق.",
                    dynamicMarketTrendMaximumStrength = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / الحد الأقصى / القوة.",
                    dynamicMarketTrendMinimumStrength = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / الحد الأدنى / القوة.",
                    dynamicMarketUpdateMinutes = "إعداد التشغيل الخاص بـ السوق الديناميكي / التحديث / الدقائق.",
                    dynamicMarketVolatilityMaximum = "إعداد التشغيل الخاص بـ السوق الديناميكي / تقلب الأسعار / الحد الأقصى.",
                    dynamicMarketVolatilityMinimum = "إعداد التشغيل الخاص بـ السوق الديناميكي / تقلب الأسعار / الحد الأدنى.",
                    dynamicMarketWeatherMultipliers = "اضبط إعدادات «الطقس / المضاعفات» في قسم «شبكات المخدرات».",
                    dynamicMarketWeatherState = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / الولاية.",
                    heatActionCooldownSeconds = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / فترة انتظار الإجراء / ثوانٍ.",
                    heatActivityRiskWeights = "اضبط إعدادات «النشاط / مخاطرة / الأوزان» في قسم «شبكات المخدرات».",
                    heatAggressiveHeatMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / أسلوب العمل العدواني / الضغط الأمني / المضاعف.",
                    heatBurnerBurnThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الهاتف المؤقت / انكشاف الهوية / العتبة.",
                    heatBurnerHeatPerWholesale = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الهاتف المؤقت / الضغط الأمني / لكل صفقة جملة.",
                    heatBurnerPhoneItem = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / هاتف مخصص للاستخدام لمرة واحدة / العنصر.",
                    heatCamperOperationalHeatMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / المضاعف.",
                    heatCamperOperationalHeatThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / العتبة.",
                    heatCamperParkedHeat = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية المتوقفة / الضغط الأمني.",
                    heatContaminatedHeatMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التلوث / الضغط الأمني / المضاعف.",
                    heatContaminatedThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التلوث / العتبة.",
                    heatCultivationFreePlants = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الزراعة / نباتات دون مخاطر إضافية.",
                    heatCultivationHeatPerPlant = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الزراعة / الضغط الأمني / لكل نبات.",
                    heatDealerHiddenMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / تاجر / مخفي / الدقائق.",
                    heatDecayPerTick = "اضبط إعدادات «الاضمحلال / لكل دورة تحديث» في قسم «شبكات المخدرات».",
                    heatEnabled = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مفعّل.",
                    heatEnforcementHeat = "اضبط إعدادات «التواجد الأمني / الضغط الأمني» في قسم «شبكات المخدرات».",
                    heatEnforcementMultipliers = "اضبط إعدادات «التواجد الأمني / المضاعفات» في قسم «شبكات المخدرات».",
                    heatEntityTypes = "اضبط إعدادات «كائن اللعبة / الأنواع» في قسم «شبكات المخدرات».",
                    heatEventCooldownMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحدث / دقائق فترة الانتظار.",
                    heatEventHistoryLimit = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحدث / حد السجل.",
                    heatLabHeatSyncThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مختبر / الضغط الأمني / المزامنة / العتبة.",
                    heatLayLowCooldownMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / دقائق فترة الانتظار.",
                    heatLayLowIdleMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / خاملاً / الدقائق.",
                    heatLayLowReduction = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / التخفيض.",
                    heatLockdownMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / إغلاق تام / الدقائق.",
                    heatMinimumDurationMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / المدة / الدقائق.",
                    heatMinimumEventCooldownSeconds = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / الحدث / فترة الانتظار (بالثواني).",
                    heatMinimumIdleSeconds = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / خاملاً / ثوانٍ.",
                    heatProcessingHeatMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المعالجة / الضغط الأمني / المضاعف.",
                    heatRiskWeights = "اضبط إعدادات «مخاطرة / الأوزان» في قسم «شبكات المخدرات».",
                    heatRotateBurnerReduction = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / تغيير الهاتف المؤقت / التخفيض.",
                    heatRouteControlMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المسار / التحكم / الدقائق.",
                    heatSaleHeat = "اضبط إعدادات «البيع / الضغط الأمني» في قسم «شبكات المخدرات».",
                    heatThresholds = "اضبط إعدادات «العتبات» في قسم «شبكات المخدرات».",
                    heatTickMinutes = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / دورة التحديث / الدقائق.",
                    heatWholesaleHeatMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / بيع الجملة / الضغط الأمني / المضاعف.",
                    heatWorkerLeakAlertRadius = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / نطاق التنبيه.",
                    heatWorkerLeakBaseChance = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القيمة الأساسية / فرصة.",
                    heatWorkerLeakFactionMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الفصيل / المضاعف.",
                    heatWorkerLeakHighSeverityThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / عالية / الخطورة / العتبة.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / فرصة / المضاعف.",
                    heatWorkerLeakLoyaltyThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / العتبة.",
                    heatWorkerLeakMaximumChance = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأقصى / فرصة.",
                    heatWorkerLeakMinimumCooldownSeconds = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأدنى / فترة الانتظار (بالثواني).",
                    heatWorkerLeakRouteMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / المسار / المضاعف.",
                    heatWorkerLeakStrengthMaximum = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأقصى.",
                    heatWorkerLeakStrengthMinimum = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأدنى.",
                    heatWorkerLeakStrengthMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / المضاعف.",
                    heatWorkerLeakStressChanceMultiplier = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / فرصة / المضاعف.",
                    heatWorkerLeakStressThreshold = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / العتبة.",
                    contactsActionCooldownSeconds = "إعداد التشغيل الخاص بـ شبكة الاتصالات / فترة انتظار الإجراء / ثوانٍ.",
                    contactsActiveHotspotCount = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عدد النقاط النشطة.",
                    contactsBurnerHintTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تلميح الهاتف المؤقت / الثقة.",
                    contactsBurnerOfferMaximumMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأقصى / المضاعف.",
                    contactsBurnerOfferMinimumMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأدنى / المضاعف.",
                    contactsBuyerCooldownMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / دقائق فترة الانتظار.",
                    contactsBuyerDeliveryDistance = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / مسافة التسليم.",
                    contactsBuyerPremiumSuccessScore = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / ممتاز / النجاح / النتيجة.",
                    contactsBuyerPremiumTrustGain = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / ممتاز / الثقة / عائد.",
                    contactsBuyerRequestHeatRiskWeight = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / الطلب / الملاحقة والمخاطر / الوزن.",
                    contactsBuyerStandardTrustGain = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / قياسي / الثقة / عائد.",
                    contactsContactActiveDelaySeconds = "اضبط إعدادات «مهلة تفعيل جهة الاتصال / ثوانٍ» في قسم «شبكات المخدرات».",
                    contactsContactDemandRange = "اضبط إعدادات «جهة الاتصال / الطلب / نطاق القيم» في قسم «شبكات المخدرات».",
                    contactsContactLossTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / جهة الاتصال / الخسارة / الثقة.",
                    contactsDarknetExactIntelMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / معلومات دقيقة / الدقائق.",
                    contactsDarknetHotspotIntelPrice = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / المنطقة النشطة / المعلومات / السعر.",
                    contactsDarknetIntelPrice = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / المعلومات / السعر.",
                    contactsDealerBasePrice = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / السعر الأساسي.",
                    contactsDealerHireCapacity = "اضبط إعدادات «تاجر / التوظيف / السعة» في قسم «شبكات المخدرات».",
                    contactsDealerHireRisk = "اضبط إعدادات «تاجر / التوظيف / مخاطرة» في قسم «شبكات المخدرات».",
                    contactsDealerHireSkill = "اضبط إعدادات «تاجر / التوظيف / مهارة» في قسم «شبكات المخدرات».",
                    contactsDealerOffers = "اضبط إعدادات «عروض الموزعين» في قسم «شبكات المخدرات».",
                    contactsDealerProtectionHours = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الحماية / الساعات.",
                    contactsDealerProtectionPrice = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الحماية / السعر.",
                    contactsDealerSaleMax = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / البيع / الحد الأقصى.",
                    contactsDealerSaleMin = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / البيع / الحد الأدنى.",
                    contactsDealerSimulation = "اضبط إعدادات «تاجر / محاكاة» في قسم «شبكات المخدرات».",
                    contactsDealerTickMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / دورة التحديث / الدقائق.",
                    contactsDealerWage = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر.",
                    contactsDealerWageDecay = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر / الاضمحلال.",
                    contactsDealerWageLoyaltyGain = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر / الولاء / عائد.",
                    contactsDealerWeaknesses = "اضبط إعدادات «تاجر / نقاط الضعف» في قسم «شبكات المخدرات».",
                    contactsDefaultContactDemand = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / الطلب.",
                    contactsDefaultContactRisk = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / مخاطرة.",
                    contactsDefaultDealerCapacity = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / السعة.",
                    contactsDefaultDealerRisk = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / مخاطرة.",
                    contactsDefaultDealerSkill = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / مهارة.",
                    contactsDefaultHotspotRadius = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / المنطقة النشطة / نصف القطر.",
                    contactsDemandResetMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / إعادة تعيين الطلب (بالدقائق).",
                    contactsEnabled = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مفعّل.",
                    contactsExactLocationTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع الدقيق / الثقة.",
                    contactsFactionDiscoveryReputation = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الفصيل / الاكتشاف / السمعة.",
                    contactsFactionHintTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الفصيل / التلميح / الثقة.",
                    contactsFailedDeliveryCooldownMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التسليم الفاشل / دقائق فترة الانتظار.",
                    contactsFakeDealEncounter = "اضبط إعدادات «صفقة وهمية / المواجهة» في قسم «شبكات المخدرات».",
                    contactsFallbackPreferredDrug = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة البديلة / المخدر المفضل.",
                    contactsFallbackProductLabel = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة البديلة / تسمية المنتج.",
                    contactsGuideBookItem = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الدليل / الكتاب / العنصر.",
                    contactsGuideBookTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الدليل / الكتاب / الثقة.",
                    contactsHireDealerPrice = "إعداد التشغيل الخاص بـ شبكة الاتصالات / توظيف موزع / السعر.",
                    contactsHistoryLimit = "إعداد التشغيل الخاص بـ شبكة الاتصالات / حد السجل.",
                    contactsHotspotIntelMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة النشطة / المعلومات / الدقائق.",
                    contactsHotspotRotationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة النشطة / التدوير / الدقائق.",
                    contactsListingDurationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الإعلان / المدة / الدقائق.",
                    contactsMaxOwnedDealers = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأقصى / مملوكة / التجار.",
                    contactsMinimumBuyerDeliveryDistance = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / مشتري / مسافة التسليم.",
                    contactsMinimumContactRotationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / تناوب الاتصال (بالدقائق).",
                    contactsMinimumDemandResetMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / إعادة تعيين الطلب (بالدقائق).",
                    contactsMinimumHeatMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الضغط الأمني / المضاعف.",
                    contactsMinimumHotspotIntelMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / المعلومات / الدقائق.",
                    contactsMinimumHotspotRadius = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / نصف القطر.",
                    contactsMinimumHotspotRotationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / التدوير / الدقائق.",
                    contactsMinimumListingDurationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الإعلان / المدة / الدقائق.",
                    contactsMinimumRewardMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى للمكافأة / المضاعف.",
                    contactsMinimumRobberyMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / السطو / المضاعف.",
                    contactsMinimumSpotPriceMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الموقع / مضاعف السعر.",
                    contactsOtherDrugPriceMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / غير ذلك / مخدر / مضاعف السعر.",
                    contactsPaymentAccount = "إعداد التشغيل الخاص بـ شبكة الاتصالات / حساب الدفع.",
                    contactsPostDeliveryDemandResetSeconds = "إعداد التشغيل الخاص بـ شبكة الاتصالات / بعد التسليم / الطلب / Reset / ثوانٍ.",
                    contactsPreferredDrugPriceMultiplier = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المخدر المفضل / مضاعف السعر.",
                    contactsRegionLocationTrust = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة / الموقع / الثقة.",
                    contactsRequestAmounts = "اضبط إعدادات «الطلب / الكميات» في قسم «شبكات المخدرات».",
                    contactsRotationMinutes = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التدوير / الدقائق.",
                    contactsSpotPools = "اضبط إعدادات «الموقع / مجموعات الاختيار» في قسم «شبكات المخدرات».",
                    contactsStreetHotspots = "اضبط إعدادات «الشارع / المناطق النشطة» في قسم «شبكات المخدرات».",
                    contactsTrustLevels = "اضبط إعدادات «الثقة / المستويات» في قسم «شبكات المخدرات».",
                    businessActionCooldownSeconds = "إعداد التشغيل الخاص بـ شبكة الأعمال / فترة انتظار الإجراء / ثوانٍ.",
                    businessBalance = "اضبط إعدادات «الرصيد» في قسم «شبكات المخدرات».",
                    businessContracts = "اضبط إعدادات «العقود» في قسم «شبكات المخدرات».",
                    businessDefaultBusinessName = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / اسم العمل التجاري.",
                    businessDefaultRankId = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / الرتبة / ID.",
                    businessDefaultStaffStyle = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / موظفون / أسلوب العمل.",
                    businessDefaultTransport = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / نقل.",
                    businessEnabled = "إعداد التشغيل الخاص بـ شبكة الأعمال / مفعّل.",
                    businessHubs = "اضبط إعدادات «مراكز التوزيع» في قسم «شبكات المخدرات».",
                    businessLimits = "اضبط إعدادات «الحدود» في قسم «شبكات المخدرات».",
                    businessPayments = "اختر الرصيد الذي سيتم استخدامه لدفع مشتريات شبكة الأعمال وتكاليف التشغيل.",
                    businessPayoutAccount = "إعداد التشغيل الخاص بـ شبكة الأعمال / المستحقات / الحساب.",
                    businessRanks = "اضبط إعدادات «الرتب» في قسم «شبكات المخدرات».",
                    businessReportDays = "إعداد التشغيل الخاص بـ شبكة الأعمال / فترة التقرير / أيام.",
                    businessRouteEndpointTypes = "اضبط إعدادات «المسار / نقطة النهاية / الأنواع» في قسم «شبكات المخدرات».",
                    businessRuntime = "اضبط إعدادات «التشغيل داخل اللعبة» في قسم «شبكات المخدرات».",
                    businessSocietyPermission = "إعداد التشغيل الخاص بـ شبكة الأعمال / المنظمة / الصلاحية.",
                    businessStaff = "اضبط إعدادات «موظفون» في قسم «شبكات المخدرات».",
                    businessTickMinutes = "إعداد التشغيل الخاص بـ شبكة الأعمال / دورة التحديث / الدقائق.",
                    businessTransports = "اضبط إعدادات «عمليات النقل» في قسم «شبكات المخدرات».",
                },
                robbery = {
                    atmAvailability = "تفعيل أو تعطيل نظام سرقة الصراف الآلي المستقل.",
                    atmLocations = "إدارة مواقع أجهزة الصراف الآلي المعتمدة من الخادم والمتاحة لعمليات السطو.",
                    atmPolice = "تكوين عدد رجال الشرطة المطلوبين أثناء الخدمة لبدء عملية السطو.",
                    atmItems = "حدد عناصر المثقاب وحبل السحب والشحنة المتفجرة المطلوبة.",
                    atmActionTimes = "حدد مدة إجراءات التركيب، والزرع، والتفجير، والنهب.",
                    atmTimeouts = "التحكم في المدة التي يظل فيها الصراف الآلي المخترق متاحاً للنهب.",
                    atmPayout = "تكوين الحساب المستهدف ونطاق المكافأة العشوائية.",
                    atmDistances = "حدد نطاقات اللاعب والمركبة المستخدمة في تفاعلات أجهزة الصراف الآلي.",
                    atmExplosionEffects = "تكوين معايير الانفجار الأصلية المستخدمة أثناء التفجير.",
                    atmDispatchAlert = "تكوين النطاق، ومدة الصلاحية، والأولوية لتنبيه الشرطة.",
                    atmDispatchRecipients = "اختر أسماء الوظائف التي تتلقى تنبيهات سرقة الصراف الآلي.",
                    shopAvailability = "تفعيل عمليات السطو وتكوين متطلبات الشرطة.",
                    shopTiming = "تكوين الترهيب، والإجراءات، ومهلة الانتظار، وفترة التبريد.",
                    shopSafe = "تكوين محاولات لوحة المفاتيح وعنصر المثقاب.",
                    shopRegisterReward = "تكوين المكافأة العشوائية لكل خزينة.",
                    shopSafeReward = "تكوين مكافأة الخزنة العشوائية.",
                    shopDispatchSettings = "تكوين المستلمين وخصائص التنبيه.",
                    shopLocationTable = "إدارة المتاجر التي يعمل بها موظفون والخزنات.",
                    pickpocketAvailability = "تفعيل الميزة، مع إمكانية قصرها على وظائف إجرامية محددة.",
                    pickpocketGameplay = "اختر مستوى التحدي واحتمالات الهروب، وطلب الطوارئ، والهجوم المضاد المستقلة.",
                    pickpocketItemRewards = "التحكم في الجيوب الفارغة وخيارات العناصر المرئية بدقة تصل إلى 0.0001 بالمئة.",
                    pickpocketMoney = "تكوين نطاق المبالغ النقدية العشوائية التي يولدها الخادم.",
                    pickpocketDistances = "تحديد مدى الـ NPC المستخدم في نظام التحديد الدائري والهدف المشترك.",
                    pickpocketRateLimits = "التحكم في تقييد الطلبات، وفترة الانتظار لكل NPC، وانتهاء صلاحية الجلسة.",
                    pickpocketDispatchSettings = "تكوين التنبيه الذي يتم إرساله عندما يتصل أحد الـ NPC بخدمات الطوارئ.",
                    heistCrafting = "حدد مقدار التفاعل المطلوب عند تصنيع معدات السطو. ينطبق هذا على المحاولات الجديدة عبر نظام الجريمة.",
                    heistCreatorMenu = "إنشاء وتعديل ونشر عمليات سطو نموذجية في صانع عمليات السطو المخصص.",
                    heistExecution = "نافذة البدء، وفترة الخمول، وفترة الانتظار لعمليات السطو.",
                    npcPoliceSupport = "يستجيب ضباط الـ NPC المسلحون سيراً على الأقدام لإنذارات السطو ويدعمون الشرطة من خلال الاشتباك مع اللصوص.",
                },
                baseRaids = {
                    baseRaids = "الوصول للمداهمة، والمتطلبات، وفئات الغنائم التي يمكن اختيارها بشكل فردي. المداهمات المفتوحة ليس لها مهلة زمنية للنقل.",
                },
                weapons = {
                    weaponCreatorMenu = "إدارة مسارات الأسلحة وغسل الأموال في منشئ واحد.",
                    weaponRuntime = "تحكم في توفر مسارات الأسلحة وصلاحيات الوصول إليها.",
                    weaponDefaultsgeneral = "اضبط إعدادات «إعدادات عامة افتراضية» في قسم «مسارات الأسلحة».",
                    weaponDefaultsaccess = "اضبط إعدادات «إعدادات وصول افتراضية» في قسم «مسارات الأسلحة».",
                    weaponDefaultscollection = "اضبط إعدادات «إعدادات جمع افتراضية» في قسم «مسارات الأسلحة».",
                    weaponDefaultsproduction = "اضبط إعدادات «إعدادات إنتاج افتراضية» في قسم «مسارات الأسلحة».",
                    weaponDefaultsmarket = "اضبط إعدادات «إعدادات سوق افتراضية» في قسم «مسارات الأسلحة».",
                    weaponDefaultsdelivery = "اضبط إعدادات «إعدادات طلب افتراضية» في قسم «مسارات الأسلحة».",
                    weaponStreet = "اضبط إعدادات «بيع الأسلحة في الشوارع» في قسم «مسارات الأسلحة».",
                },
                darknetMarket = {
                    darknetAvailability = "التحكم في تطبيق الجهاز اللوحي وموقعه.",
                    darknetEconomy = "تكوين أرصدة المحفظة، وتبادل العملات، ومعدلات الدفع.",
                    darknetListings = "تحدد الضوابط حدود الإعلانات، والأسعار، وتاريخ انتهاء الصلاحية التلقائي.",
                    darknetChat = "تحديد رسائل السوق المشفرة.",
                    darknetIdentity = "تكوين تدوير الهوية، والتحقق، وتحذيرات الاحتيال.",
                    darknetDelivery = "تكوين الاجتماعات الشخصية والصناديق القابلة للسرقة في العالم.",
                    darknetDeliveryLocations = "تكوين قوائم المواقع التي يتم تخصيصها عشوائياً لتجارات BlackBay مع الـ NPC.",
                    darknetPolice = "مجموعات الوظائف المسموح لها بنشر الفخاخ وعرض التحقيقات.",
                    darknetNpcTraders = "تجار (NPC) دائمون (بائعون ومشترون) مع مخاطرة قابلة للتكوين.",
                },
                interrogation = {
                    general = "اضبط إعدادات «عام» في قسم «استجواب».",
                    consent = "اضبط إعدادات «حماية اللاعب» في قسم «استجواب».",
                    objects = "اضبط إعدادات «الأشياء» في قسم «استجواب».",
                    grab = "اضبط إعدادات «السيطرة» في قسم «استجواب».",
                    session = "اضبط إعدادات «الجلسة» في قسم «استجواب».",
                    dispatch = "اضبط إعدادات «تنبيهات الشرطة» في قسم «استجواب».",
                    logging = "اضبط إعدادات «تسجيل السجلات» في قسم «استجواب».",
                    security = "اضبط إعدادات «الأمان» في قسم «استجواب».",
                    presentation = "اضبط إعدادات «العرض» في قسم «استجواب».",
                },
                reputation = {
                    crimeReputation = "اضبط إعدادات «السمعة» في قسم «السمعة».",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "عام", description = "تحكم في توفر مسارات الأسلحة وصلاحيات الوصول إليها." },
                weaponCreatorMenu = { label = "الخالق الأعمال غير المشروعة", description = "إدارة مسارات الأسلحة وغسل الأموال في منشئ واحد." },
                atmActionTimes = {
                    description = "حدد مدة إجراءات التركيب، والزرع، والتفجير، والنهب.",
                    label = "مدد الإجراءات",
                },
                atmAvailability = {
                    description = "تفعيل أو تعطيل نظام سرقة الصراف الآلي المستقل.",
                    label = "التوافر",
                },
                atmDispatchAlert = {
                    description = "تكوين النطاق، ومدة الصلاحية، والأولوية لتنبيه الشرطة.",
                    label = "خصائص التنبيه",
                },
                atmDispatchRecipients = {
                    description = "اختر أسماء الوظائف التي تتلقى تنبيهات سرقة الصراف الآلي.",
                    label = "المستلمون",
                },
                atmDistances = {
                    description = "حدد نطاقات اللاعب والمركبة المستخدمة في تفاعلات أجهزة الصراف الآلي.",
                    label = "مسافات التفاعل",
                },
                atmExplosionEffects = {
                    description = "تكوين معايير الانفجار الأصلية المستخدمة أثناء التفجير.",
                    label = "تأثيرات الانفجار",
                },
                atmItems = {
                    description = "حدد عناصر المثقاب وحبل السحب والشحنة المتفجرة المطلوبة.",
                    label = "العناصر المطلوبة",
                },
                atmLocations = {
                    description = "إدارة مواقع أجهزة الصراف الآلي المعتمدة من الخادم والمتاحة لعمليات السطو.",
                    label = "مواقع أجهزة الصراف الآلي",
                },
                atmPayout = {
                    description = "تكوين الحساب المستهدف ونطاق المكافأة العشوائية.",
                    label = "المستحقات",
                },
                atmPolice = {
                    description = "تكوين عدد رجال الشرطة المطلوبين أثناء الخدمة لبدء عملية السطو.",
                    label = "متطلبات الشرطة",
                },
                atmPulling = {
                    description = "تكوين الحركة المطلوبة لانتزاع الصراف الآلي من الحائط.",
                    label = "كشف السحب",
                },
                atmTimeouts = {
                    description = "التحكم في المدة التي يظل فيها الصراف الآلي المخترق متاحاً للنهب.",
                    label = "مهلة الغنائم",
                },
                baseRaids = {
                    description = "الوصول للمداهمة، والمتطلبات، وفئات الغنائم التي يمكن اختيارها بشكل فردي. المداهمات المفتوحة ليس لها مهلة زمنية للنقل.",
                    label = "مداهمات القواعد",
                },
                businessPayments = {
                    description = "اختر الرصيد الذي سيتم استخدامه لدفع مشتريات شبكة الأعمال وتكاليف التشغيل.",
                    label = "المدفوعات",
                },
                crimeMembership = {
                    description = "حدد كيفية قيام المنظمات الإجرامية بتخزين وإدارة أعضائها.",
                    label = "نموذج العضوية",
                },
                darknetAvailability = {
                    description = "التحكم في تطبيق الجهاز اللوحي وموقعه.",
                    label = "التوافر",
                },
                darknetChat = {
                    description = "تحديد رسائل السوق المشفرة.",
                    label = "دردشة خاصة",
                },
                darknetDelivery = {
                    description = "تكوين الاجتماعات الشخصية والصناديق القابلة للسرقة في العالم.",
                    label = "التسليم ونقاط التسليم الميتة",
                },
                darknetDeliveryLocations = {
                    description = "تكوين قوائم المواقع التي يتم تخصيصها عشوائياً لتجارات BlackBay مع الـ NPC.",
                    label = "مواقع التسليم",
                },
                darknetEconomy = {
                    description = "تكوين أرصدة المحفظة، وتبادل العملات، ومعدلات الدفع.",
                    label = "العملات الرقمية",
                },
                darknetIdentity = {
                    description = "تكوين تدوير الهوية، والتحقق، وتحذيرات الاحتيال.",
                    label = "الأسماء المستعارة والسمعة",
                },
                darknetListings = {
                    description = "تحدد الضوابط حدود الإعلانات، والأسعار، وتاريخ انتهاء الصلاحية التلقائي.",
                    label = "العروض وانتهاء الصلاحية",
                },
                darknetNpcTraders = {
                    description = "تجار (NPC) دائمون (بائعون ومشترون) مع مخاطرة قابلة للتكوين.",
                    label = "تجار الـ NPC",
                },
                darknetPolice = {
                    description = "مجموعات الوظائف المسموح لها بنشر الفخاخ وعرض التحقيقات.",
                    label = "وصول الشرطة",
                },
                heistCrafting = {
                    description = "حدد مقدار التفاعل المطلوب عند تصنيع معدات السطو. ينطبق هذا على المحاولات الجديدة عبر نظام الجريمة.",
                    label = "ورشة عمل عملية السطو",
                },
                heistCreatorMenu = {
                    description = "إنشاء وتعديل ونشر عمليات سطو نموذجية في صانع عمليات السطو المخصص.",
                    label = "قائمة المبدع",
                },
                heistExecution = {
                    description = "نافذة البدء، وفترة الخمول، وفترة الانتظار لعمليات السطو.",
                    label = "توقيت عملية السطو",
                },
                moneywashEconomy = {
                    description = "تفعيل الشركات وتكوين حساب الإيداع، ورسوم الخدمة، ومسافات التفاعل.",
                    label = "عام",
                },
                npcPoliceSupport = {
                    description = "يستجيب ضباط الـ NPC المسلحون سيراً على الأقدام لإنذارات السطو ويدعمون الشرطة من خلال الاشتباك مع اللصوص.",
                    label = "دعم شرطة الـ NPC",
                },
                pickpocketAvailability = {
                    description = "تفعيل الميزة، مع إمكانية قصرها على وظائف إجرامية محددة.",
                    label = "التوافر",
                },
                pickpocketDispatchSettings = {
                    description = "تكوين التنبيه الذي يتم إرساله عندما يتصل أحد الـ NPC بخدمات الطوارئ.",
                    label = "إرسال الطوارئ",
                },
                pickpocketDistances = {
                    description = "تحديد مدى الـ NPC المستخدم في نظام التحديد الدائري والهدف المشترك.",
                    label = "مسافات التفاعل",
                },
                pickpocketGameplay = {
                    description = "اختر مستوى التحدي واحتمالات الهروب، وطلب الطوارئ، والهجوم المضاد المستقلة.",
                    label = "المخاطرة واللعبة المصغرة",
                },
                pickpocketItemRewards = {
                    description = "التحكم في الجيوب الفارغة وخيارات العناصر المرئية بدقة تصل إلى 0.0001 بالمئة.",
                    label = "غنائم الجيوب المرئية",
                },
                pickpocketMoney = {
                    description = "تكوين نطاق المبالغ النقدية العشوائية التي يولدها الخادم.",
                    label = "مكافأة نقدية",
                },
                pickpocketRateLimits = {
                    description = "التحكم في تقييد الطلبات، وفترة الانتظار لكل NPC، وانتهاء صلاحية الجلسة.",
                    label = "حماية الخادم",
                },
                pvpArenas = {
                    description = "إنشاء المنطقة الدائرية، ونقطة المراقبة، ونقاط ظهور الفريق المستخدمة في أحداث الـ PvP.",
                    label = "الساحات ومناطق القتال",
                },
                pvpAutomation = {
                    description = "تكوين الأحداث المتكررة ومعالجة البدء التلقائي.",
                    label = "الأتمتة",
                },
                pvpAvailability = {
                    description = "التحكم في توفر تطبيق أحداث الـ PvP ومكان ظهوره.",
                    label = "التوافر",
                },
                pvpLimits = {
                    description = "تحديد حدود المكافآت وسجل الجهاز اللوحي.",
                    label = "الحدود والسجل",
                },
                pvpModes = {
                    description = "تكوين وضع اللعب المحدد مسبقاً في جهاز الـ PvP اللوحي.",
                    label = "أوضاع اللعب",
                },
                pvpPermissions = {
                    description = "ربط إدارة الأحداث والتمويل بصلاحيات ACE والوظائف.",
                    label = "الصلاحيات",
                },
                pvpRuntime = {
                    description = "ضبط معالجة الطلبات، والوفيات، وإعادة الظهور أثناء المباريات المباشرة.",
                    label = "وقت تشغيل الحدث",
                },
                pvpTakeoverMethods = {
                    description = "حدد المدة التي تستغرقها كل طريقة لاقتحام مدخل ما.",
                    label = "طرق الاقتحام",
                },
                pvpTakeoverRules = {
                    description = "التحكم في التوافر ومتطلبات المشاركة لعمليات الاستيلاء على المختبرات وعربات التخييم.",
                    label = "قواعد الاستيلاء",
                },
                pvpTakeoverZones = {
                    description = "تكوين مناطق التفاعل والتنبيه والاستيلاء مع مدة كل منها.",
                    label = "المناطق والتوقيت",
                },
                shopAvailability = {
                    description = "تفعيل عمليات السطو وتكوين متطلبات الشرطة.",
                    label = "التوافر",
                },
                shopDispatchSettings = {
                    description = "تكوين المستلمين وخصائص التنبيه.",
                    label = "تنبيه الشرطة",
                },
                shopLocationTable = {
                    description = "إدارة المتاجر التي يعمل بها موظفون والخزنات.",
                    label = "مواقع المتاجر",
                },
                shopRegisterReward = {
                    description = "تكوين المكافأة العشوائية لكل خزينة.",
                    label = "مكافأة الخزينة",
                },
                shopRegisterTable = {
                    description = "تعيين آلات تسجيل نقد فردية للمتاجر.",
                    label = "آلات تسجيل النقد",
                },
                shopSafe = {
                    description = "تكوين محاولات لوحة المفاتيح وعنصر المثقاب.",
                    label = "خزنة",
                },
                shopSafeReward = {
                    description = "تكوين مكافأة الخزنة العشوائية.",
                    label = "مكافأة الخزنة",
                },
                shopTiming = {
                    description = "تكوين الترهيب، والإجراءات، ومهلة الانتظار، وفترة التبريد.",
                    label = "التوقيت",
                },
            },
            settingSections = {
                weapons = "مسارات الأسلحة",
                drugs = "نظام المخدرات",
                drugProduction = "إنتاج المخدرات",
                drugOperations = "عمليات المخدرات",
                drugMarketRisk = "السوق والمخاطر",
                drugNetworks = "شبكات المخدرات",
                atmRobbery = "سطو على الصراف الآلي",
                baseRaids = "مداهمات القواعد",
                crimeOrganizations = "المنظمات",
                darknetMarket = "سوق الشبكة المظلمة",
                moneywash = "غسيل الأموال",
                pvpEvents = "PvP الفصائل",
                robbery = "السطو",
                territories = "الأقاليم",
                graffiti = "الجرافيتي",
                interrogation = "استجواب",
            },
            settingSubsections = {
                baseRaidEquipment = "المعدات المطلوبة",
                baseRaidBreach = "الاقتحام",
                baseRaidLoot = "الغنائم والمركبات",
                graffitiLimits = "القيود والإشراف",
                interrogationTechnical = "السجلات والأمان",
                atmDispatch = "إبلاغ الشرطة",
                atmEquipment = "المعدات",
                atmExplosion = "التفجير",
                atmOverview = "نظرة عامة والمواقع",
                atmRewards = "المكافآت",
                atmTiming = "التوقيت",
                atmVehicle = "المركبة والسحب",
                baseRaids = "مداهمات القواعد",
                crimeMembership = "العضوية",
                heistCreator = "مُهيكل عمليات السطو",
                npcPoliceSupport = "دعم شرطة الـ NPC",
                pickpocket = "نشل الـ NPC",
                pvpArenas = "الساحات",
                pvpEquipment = "أوضاع اللعب",
                pvpOverview = "نظرة عامة",
                pvpRuntime = "وقت تشغيل الحدث",
                pvpTakeovers = "الاستيلاء على المختبرات",
                shopRobbery = "سطو المتاجر",
                atmRobbery = "سطو على الصراف الآلي",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "مسافة التفاعل" },
                weaponDefaultGeneralPedModel = { label = "نموذج الشخصية الافتراضي" },
                weaponDefaultAccessActiveHourStart = { label = "ساعة الفتح (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "ساعة الإغلاق (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "عدد الشرطة المطلوبة في الخدمة" },
                weaponDefaultAccessPoliceJobs = { label = "وظائف الشرطة" },
                weaponDefaultCollectionDurationSeconds = { label = "المدة بالثواني" },
                weaponDefaultCollectionCooldownSeconds = { label = "فترة الانتظار بالثواني" },
                weaponDefaultCollectionCooldownScope = { label = "نطاق فترة الانتظار" },
                weaponDefaultCollectionUseMinigame = { label = "استخدام لعبة مصغرة" },
                weaponDefaultCollectionMinigame = { label = "اللعبة المصغرة" },
                weaponDefaultCollectionMinigameRounds = { label = "جولات اللعبة المصغرة" },
                weaponDefaultProductionDurationSeconds = { label = "المدة بالثواني" },
                weaponDefaultProductionSuccessChance = { label = "احتمال النجاح (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "استهلاك المواد عند الفشل" },
                weaponDefaultProductionUseMinigame = { label = "استخدام لعبة مصغرة" },
                weaponDefaultProductionMinigame = { label = "اللعبة المصغرة" },
                weaponDefaultProductionMinigameRounds = { label = "جولات اللعبة المصغرة" },
                weaponDefaultProductionQualityMin = { label = "أدنى جودة" },
                weaponDefaultProductionQualityMax = { label = "أعلى جودة" },
                weaponDefaultProductionCooldownSeconds = { label = "فترة الانتظار بالثواني" },
                weaponDefaultProductionCooldownScope = { label = "نطاق فترة الانتظار" },
                weaponDefaultMarketPayoutAccount = { label = "حساب الدفع" },
                weaponDefaultMarketPriceMultiplierMin = { label = "أدنى معامل سعر (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "أعلى معامل سعر (%)" },
                weaponDefaultMarketRestockSeconds = { label = "فترة التجديد بالثواني" },
                weaponDefaultMarketCooldownSeconds = { label = "فترة الانتظار بالثواني" },
                weaponDefaultMarketCooldownScope = { label = "نطاق فترة الانتظار" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "مهلة الطلب بالدقائق" },
                weaponDefaultDeliveryContractBonusPercent = { label = "مكافأة الطلب (%)" },
                weaponStreetEnabled = { label = "مبيعات أسلحة نادرة لمشتري الشوارع" },
                weaponStreetChance = { label = "احتمال عرض سلاح (%)" },
                weaponStreetCooldown = { label = "فترة الانتظار بالثواني" },
                weaponStreetAmount = { label = "الكمية القصوى" },
                weaponStreetPriceMin = { label = "أدنى معامل سعر (%)" },
                weaponStreetPriceMax = { label = "أعلى معامل سعر (%)" },
                weaponStreetAccount = { label = "حساب الدفع" },
                weaponStreetDirect = { label = "بيع مباشر" },
                weaponStreetBulk = { label = "بيع بالجملة" },
                weaponStreetContract = { label = "طلب الكارتل" },
                weaponSystemEnabled = { label = "نظام مسارات الأسلحة", description = "فعّل جمع الأسلحة ومعالجتها وبيعها للعصابات." },
                weaponRuntimeEnabled = { label = "إجراءات مسارات الأسلحة", description = "اسمح باستخدام مسارات الأسلحة المعدّة داخل عالم اللعبة." },
                weaponCreatorAccess = { label = "الوصول إلى منشئ الأسلحة", description = "حدد من يمكنه فتح منشئ الأسلحة.", options = { permission = "بإذن فقط", jobManagement = "إدارة الوظيفة", ownerOnly = "المالك فقط" } },
                openWeaponCreator = { label = "الخالق الأعمال غير المشروعة", description = "إدارة مسارات الأسلحة وغسل الأموال في منشئ واحد.", buttonLabel = "الخالق الأعمال غير المشروعة", unsavedTooltip = "احفظ أولاً" },

                drugCultivationProgressionEnabled = { label = "تفعيل مستويات الزراعة", description = "يفعّل خبرة الزراعة والمستويات ومتطلبات الفتح المرتبطة بالمستوى." },
                drugCultivationMaxLevel = { label = "الحد الأقصى لمستوى الزراعة", description = "أعلى مستوى زراعة يمكن الوصول إليه. المستويات الأعلى تبقى غير قابلة للوصول." },
                drugCultivationLevels = { label = "منحنى المستويات", description = "اضبط الاسم وإجمالي الخبرة المطلوبة لكل مستوى زراعة." },
                drugCultivationActionXp = { label = "مكافآت الخبرة", description = "اضبط مقدار خبرة الزراعة التي يمنحها كل إجراء." },
                drugCultivationUnlocks = { label = "فتح المستويات", description = "اضبط المستوى المطلوب للحاويات والركائز والمعدات والسلالات ومستويات الماسح." },
                reputationRewards = { label = "إجراءات السمعة", description = "أضف إجراءات وعدّل النقاط وعطّل الإدخالات أو احذفها. الإدخالات المفعّلة فقط تمنح النقاط." },
                reputationEnabled = { label = "تفعيل السمعة الإجرامية", description = "منح سمعة شخصية." },
                reputationPointsPerLevel = { label = "النقاط لكل مستوى", description = "يتطلب كل مستوى هذا العدد من النقاط الإضافية." },
                reputationMinimumJoinPoints = { label = "الحد الأدنى للسمعة للانضمام", description = "إجمالي النقاط المطلوبة للانضمام إلى فصيل إجرامي. 0 يعطّل الشرط. يحتفظ الأعضاء الحاليون بصلاحياتهم." },
                reputation_atm = { label = "سرقة صراف آلي", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_shop_register = { label = "صندوق المتجر", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_shop_safe = { label = "خزنة المتجر", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_pickpocket = { label = "النشل", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_heist = { label = "إكمال السطو", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_harvest = { label = "حصاد المخدرات", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_processing = { label = "تصنيع المخدرات", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_sale = { label = "بيع المخدرات", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_delivery = { label = "توصيل المخدرات", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_contract = { label = "عقد توزيع", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_drug_raid = { label = "غارة مخدرات", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_graffiti = { label = "كتابة على الجدران", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_moneywash = { label = "غسل الأموال", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_base_raid = { label = "غارة على القاعدة", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                reputation_pvp_win = { label = "انتصار لاعب ضد لاعب", description = "النقاط لكل عملية مكتملة بنجاح. 0 يعطّل هذه المكافأة." },
                atmChargeProp = {
                    description = "نموذج الكائن الذي يظهر على الصراف الآلي أثناء زرع العبوة المتفجرة.",
                    label = "نموذج عبوة المتفجرات",
                },
                atmConsumeDrill = {
                    description = "يستهلك العدد المحدد بعد إكمال كل نقطة ثقب في الصراف الآلي بنجاح.",
                    label = "استهلاك المثقاب",
                },
                atmDrillItem = {
                    description = "معرّف عنصر المخزون المطلوب لثقب صراف آلي منزوع. مستقل عن مثقاب خزنة المتجر.",
                    label = "عنصر المثقاب",
                },
                atmDrillItemAmount = {
                    description = "عدد عناصر المثقاب المطلوبة لكل نقطة ثقب في الصراف الآلي.",
                    label = "عدد المثاقب المطلوب",
                },
                atmDebug = {
                    description = "تكتب تشخيصات مفصلة لعملية سطو الصراف الآلي في وحدة تحكم الخادم ووحدة تحكم F8 الخاصة بالعميل.",
                    label = "سجلات تصحيح أخطاء الصراف الآلي",
                },
                atmDispatchDurationSeconds = {
                    description = "الثواني التي يظل فيها تنبيه الصراف الآلي ذا صلة بمستقبلي البلاغات.",
                    label = "مدة البلاغ",
                },
                atmDispatchEnabled = {
                    description = "يؤدي اختراق الصراف الآلي إلى إنشاء حادث في قاعدة الوظائف (Jobs Base).",
                    label = "تفعيل إرسال الشرطة",
                },
                atmDispatchJobs = {
                    description = "أسماء الوظائف المفصولة بفاصلة والتي تتلقى تنبيه الصراف الآلي (ATM).",
                    label = "وظائف البلاغات",
                },
                atmDispatchPriority = {
                    description = "قيمة الأولوية التي يتم تمريرها دون تغيير إلى نظام دمج البلاغات.",
                    label = "أولوية البلاغ",
                },
                atmDispatchRadius = {
                    description = "نطاق التنبيه التقريبي المرسل إلى نظام دمج البلاغات.",
                    label = "نطاق إرسال البلاغ",
                },
                atmEnabled = {
                    description = "يجعل أجهزة الصراف الآلي المحددة متاحة لعمليات السرقة باستخدام الحبال أو المتفجرات.",
                    label = "تفعيل سرقات الصراف الآلي",
                },
                atmExplosionCameraShake = {
                    description = "شدة اهتزاز الكاميرا للعميل الذي تسبب في الانفجار.",
                    label = "اهتزاز كاميرا الانفجار",
                },
                atmExplosionDamageScale = {
                    description = "قوة الضرر والاندفاع التي يتم تمريرها لعملية الانفجار.",
                    label = "مقياس ضرر الانفجار",
                },
                atmExplosionType = {
                    description = "نوع انفجار GTA المستخدم عند التفجير. احتفظ بالنوع الافتراضي ما لم يتم اختبار نوع آخر.",
                    label = "نوع الانفجار",
                },
                atmDrillDurationSeconds = {
                    label = "الحد الأدنى لوقت الحفر لكل برغي (ث)",
                    description = "الحد الأدنى للوقت بالثواني لكل برغي من البراغي الأربعة. فترات التبريد تطيل المحاولة. يسري على محاولات الحفر التي تبدأ بعد الحفظ.",
                },
                atmExplosiveDurationSeconds = {
                    description = "الثواني المطلوبة لزرع العبوة المتفجرة.",
                    label = "مدة زرع العبوة",
                },
                atmExplosiveItem = {
                    description = "عنصر من المخزون يتم استهلاكه بعد وضع الشحنة.",
                    label = "عنصر متفجر",
                },
                atmExplosiveItemAmount = {
                    description = "عدد عناصر المتفجرات المستهلكة لكل عبوة مزروعة.",
                    label = "كمية المتفجرات المستهلكة",
                },
                atmFuseSeconds = {
                    description = "الثواني بين الوضع والتفجير.",
                    label = "مدة الصاعق",
                },
                atmInteractionDistance = {
                    description = "أقصى نطاق لتفاعل العميل؛ إضافة التحقق من الخادم توفر هامش أمان.",
                    label = "مسافة التفاعل",
                },
                atmLocations = {
                    description = "مواقع الصراف الآلي الرسمية. المواقع التي يتم إنشاؤها باستخدام /atmtest تظل مؤقتة.",
                    itemLabel = "موقع الصراف الآلي",
                    label = "مواقع أجهزة الصراف الآلي",
                },
                atmLootDurationSeconds = {
                    description = "الثواني المطلوبة لفتح صراف آلي (ATM) تم اختراقه.",
                    label = "مدة الغنيمة",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "الحد الأقصى للثواني التي يمكن للاعب خلالها حجز الصراف الآلي أثناء فتحه؛ يتم الحفاظ عليها تلقائياً فوق مدة النهب.",
                    label = "مهلة حجز الغنائم",
                },
                atmLootWindowMinutes = {
                    description = "عدد الدقائق التي يظل فيها الصراف الآلي المقتحم قابلاً للنهب قبل نفاده.",
                    label = "نافذة الغنائم",
                },
                atmMinimumPolice = {
                    description = "عدد أعضاء مجموعة الشرطة المحددة الذين يجب أن يكونوا في الخدمة لبدء عملية السطو.",
                    label = "الحد الأدنى للشرطة",
                },
                atmPoliceGroup = {
                    description = "مجموعة وظائف sky_jobs_base التي تُحتسب ضمن متطلبات الشرطة.",
                    label = "مجموعة وظيفة الشرطة",
                },
                atmPullDistance = {
                    description = "إزاحة المركبة عن موقع الصراف الآلي المطلوبة لإتمام عملية الاقتحام.",
                    label = "مسافة السحب المطلوبة",
                },
                atmPullMinimumSpeed = {
                    description = "الحد الأدنى لسرعة المركبة بالمتر في الثانية عند الوصول إلى مسافة السحب.",
                    label = "الحد الأدنى لسرعة السحب",
                },
                atmReservationTimeoutSeconds = {
                    description = "الحد الأقصى للثواني المحجوزة أثناء قيام اللاعب بتركيب حبل أو وضع عبوة؛ يتم الاحتفاظ بها تلقائيًا فوق مدة الإجراء.",
                    label = "مهلة حجز التحضير",
                },
                atmRewardAccount = {
                    description = "اختر بين النقد وعنصر black_money.",
                    label = "نوع دفع الصراف الآلي",
                },
                atmRewardMaximum = {
                    description = "أعلى مبلغ نقدي من صراف آلي واحد؛ لا يقل أبداً عن الحد الأدنى.",
                    label = "الحد الأقصى للمكافأة",
                },
                atmRewardMinimum = {
                    description = "أقل مبلغ نقدي يتم دفعه من صراف آلي واحد.",
                    label = "الحد الأدنى للمكافأة",
                },
                atmSlingDurationSeconds = {
                    description = "عدد الثواني المطلوبة لتركيب الحبل.",
                    label = "مدة تركيب الحبل",
                },
                atmSlingItem = {
                    description = "يتطلب عنصر مخزون قابل لإعادة الاستخدام لطريقة استخدام المركبة.",
                    label = "عنصر السحب",
                },
                atmSlingItemAmount = {
                    description = "عدد عناصر الحبال التي يجب توفرها. لا يتم استهلاكها.",
                    label = "كمية الحبل المطلوبة",
                },
                atmTestScanDistance = {
                    description = "أقصى مسافة يستخدمها أمر /atmtest عند البحث عن مجسم صراف آلي مدعوم.",
                    label = "مسافة مسح اختبار الصراف الآلي",
                },
                atmVehicleMaxDistance = {
                    description = "الحد الأقصى للمسافة بين الصراف الآلي والمركبة المؤهلة عند تثبيت الحبل.",
                    label = "مسافة تثبيت المركبة",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "الحد الزمني لكل محاولة اقتحام عند نقطة تخزين (بالثواني).",
                    label = "مهلة الاقتحام (بالثواني)",
                },
                baseRaid_command = {
                    description = "اسم الأمر بدون شرطة مائلة. أعد تشغيل مورد الجريمة (crime resource) بعد تغييره.",
                    label = "أمر المداهمة",
                },
                baseRaid_crimeItem = {
                    description = "عنصر اختراق العصابة.",
                    label = "عنصر اختراق العصابة",
                },
                baseRaid_crimeVehicles = {
                    description = "الوصول لمركبات العصابة.",
                    label = "الوصول لمركبات العصابة",
                },
                baseRaid_difficulty = {
                    description = "صعوبة اختبار المهارة.",
                    label = "صعوبة اختبار المهارة",
                    options = {
                        easy = "سهل",
                        expert = "خبير",
                        hard = "صعب",
                        normal = "عادي",
                    },
                },
                baseRaid_enabled = {
                    description = "تفعيل مداهمات القواعد.",
                    label = "تفعيل مداهمات القواعد",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "مدة الانتظار عند انتهاء المداهمة دون فتح أي نقطة تخزين (بالدقائق).",
                    label = "فترة الانتظار بعد الفشل (بالدقائق)",
                },
                baseRaid_interactionDistance = {
                    description = "مسافة التفاعل مع المخزن.",
                    label = "مسافة التفاعل مع المخزن",
                },
                baseRaid_lootHeistStorage = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "مخزن غنائم السطو",
                },
                baseRaid_lootLaboratories = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "نهب مخزن المختبر",
                },
                baseRaid_lootPersonalLockers = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "نهب الخزائن الشخصية",
                },
                baseRaid_lootStorage = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "نهب المخزن",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "نهب درج التخزين (Glovebox)",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "السماح بالسحب الكامل لهذه الفئة من المخزون أثناء عملية السطو النشطة.",
                    label = "نهب صناديق السيارات",
                },
                baseRaid_minimumDefenders = {
                    description = "الحد الأدنى للمدافعين المتصلين.",
                    label = "الحد الأدنى للمدافعين المتصلين",
                },
                baseRaid_policeItem = {
                    description = "عنصر اقتحام الشرطة.",
                    label = "عنصر اختراق الشرطة",
                },
                baseRaid_policeRequireDuty = {
                    description = "يجب أن تكون الشرطة في الخدمة.",
                    label = "يجب أن تكون الشرطة في الخدمة",
                },
                baseRaid_policeVehicles = {
                    description = "الوصول لمركبات الشرطة.",
                    label = "الوصول لمركبات الشرطة",
                },
                baseRaid_protectionHours = {
                    description = "الحماية بعد النجاح (بالساعات).",
                    label = "الحماية بعد النجاح (بالساعات)",
                },
                baseRaid_requiredHits = {
                    description = "ضربات اختبار المهارة المطلوبة.",
                    label = "ضربات اختبار المهارة المطلوبة",
                },
                baseRaid_warrantItem = {
                    description = "يتم استهلاك عنصر واحد من هذه العناصر عند كل عملية مداهمة شرطة صالحة.",
                    label = "عنصر مذكرة التفتيش",
                },
                crimeMembershipMode = {
                    description = "يحافظ وضع الإطار على تكامل الوظيفة الحالية أو العصابة الأصلية. يقوم الوضع المستقل بتشغيل منظمة الجريمة في الخلفية جنبًا إلى جنب مع وظيفة اللاعب العادية وينقل العضويات الحالية تلقائيًا.",
                    label = "نموذج عضوية المنظمة",
                    options = {
                        framework = "وظيفة الإطار / عصابة",
                        independent = "منظمة مستقلة",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "الحد الأدنى لعمر الهوية قبل إمكانية إيقافها مرة أخرى.",
                    label = "فترة انتظار تغيير الاسم المستعار (بالساعات)",
                },
                darknetCurrencyCode = {
                    description = "رمز قصير يظهر لسجل العملات الرقمية الداخلي.",
                    label = "رمز العملة",
                },
                darknetDeadDropInteractionDistance = {
                    description = "المسافة المطلوبة للبحث عن صندوق والمطالبة به.",
                    label = "مسافة التفاعل مع التسليم السري",
                },
                darknetDeadDropLifetimeHours = {
                    description = "الوقت المتبقي قبل انتهاء صلاحية الصندوق غير المطالب به.",
                    label = "مدة صلاحية التسليم السري (بالساعات)",
                },
                darknetDeadDropModel = {
                    description = "موديل غرض (Prop) من GTA يتم إنشاؤه محليًا لصناديق التسليم السري المتاحة.",
                    label = "موديل صندوق التسليم السري (Dead-drop)",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "الفاصل الزمني المستخدم لتحديث الصناديق القريبة واجتماعات الـ NPC.",
                    label = "فاصل تحديث العالم (ملي ثانية)",
                },
                darknetDeadDropStreamDistance = {
                    description = "المسافة التي يتم عندها تحميل الصناديق وجهات اتصال الـ NPC.",
                    label = "مسافة ظهور التسليم السري",
                },
                darknetDropLocations = {
                    description = "يتم تعيين المواقع عشوائياً لصفقات التسليم الخفي مع الـ NPCs. قم بتكوين موقعين على الأقل.",
                    itemLabel = "موقع التسليم الخفي",
                    label = "مواقع التسليم الخفي",
                },
                darknetEnabled = {
                    description = "يجعل تطبيق تابلت السوق السوداء ونظام تشغيله متاحاً.",
                    label = "تفعيل سوق الشبكة المظلمة",
                },
                darknetExchangeBuyPrice = {
                    description = "المبلغ المخصوم من حساب الدفع مقابل عملة واحدة.",
                    label = "سعر الشراء لكل عملة",
                },
                darknetExchangeEnabled = {
                    description = "يسمح لمستخدمي BlackBay الموثقين بشراء وبيع العملات في صفحة حساباتهم.",
                    label = "تفعيل تبادل العملات",
                },
                darknetExchangeMaximumAmount = {
                    description = "أكبر كمية كاملة من العملات مقبولة في عملية تبادل واحدة.",
                    label = "الحد الأقصى للعملات لكل عملية تبادل",
                },
                darknetExchangeMinimumAmount = {
                    description = "أصغر كمية كاملة من العملات مقبولة في عملية تبادل واحدة.",
                    label = "الحد الأدنى للعملات لكل عملية تبادل",
                },
                darknetExchangePaymentAccount = {
                    description = "حساب الإطار (Framework) المستخدم لشراء العملات ومدفوعات البيع.",
                    label = "حساب دفع التبادل",
                    options = {
                        bank = "البنك",
                        black_money = "أموال قذرة",
                        money = "نقد",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "المبلغ المدفوع لحساب الدفع مقابل عملة واحدة.",
                    label = "سعر البيع لكل عملة",
                },
                darknetFaceToFaceDistance = {
                    description = "الحد الأقصى للمسافة بين كلا اللاعبين أو نقطة الـ NPC المحددة.",
                    label = "مسافة التسليم",
                },
                darknetKnownScammerReports = {
                    description = "بلاغات التداول الفريدة المطلوبة للحصول على شارة المحتال المعروف.",
                    label = "البلاغات للتحذير من المحتالين",
                },
                darknetListingExpiryHours = {
                    description = "تنتهي صلاحية العروض النشطة تلقائيًا بعد هذا العدد من الساعات.",
                    label = "مدة صلاحية العرض (بالساعات)",
                },
                darknetMaximumListingQuantity = {
                    description = "الحد الأعلى لكمية البضائع في العرض الواحد.",
                    label = "الحد الأقصى لكمية البضائع",
                },
                darknetMaximumListings = {
                    description = "الحد الأقصى للعروض لكل اسم مستعار نشط.",
                    label = "الحد الأقصى للعروض النشطة",
                },
                darknetMaximumMessageLength = {
                    description = "الحد الأقصى لعدد الأحرف في رسالة الدردشة المشفرة.",
                    label = "الحد الأقصى لطول الرسالة",
                },
                darknetMaximumUnitPrice = {
                    description = "الحد الأقصى لسعر الكريبتو للوحدة الواحدة.",
                    label = "الحد الأقصى لسعر الوحدة",
                },
                darknetMeetingLocations = {
                    description = "يتم تعيين المواقع عشوائياً لعمليات التجارة المباشرة مع الشخصيات (NPCs). قم بتكوين موقعين على الأقل.",
                    itemLabel = "موقع الاجتماع",
                    label = "مواقع الاجتماعات",
                },
                darknetNpcBuyerAliases = {
                    description = "أسماء وهمية تُخصص عشوائياً لطلبات شراء الـ NPC الجديدة. قم بتكوين اسمين مستعارين فريدين على الأقل.",
                    label = "أسماء مستعارة لمشتري الـ NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "الحد الأقصى المستخدم عند الاختيار عشوائياً لعدد طلبات شراء الـ NPC التي ستصبح نشطة.",
                    label = "الحد الأقصى لطلبات شراء الـ NPC",
                },
                darknetNpcMaximumSellListings = {
                    description = "الحد الأعلى المستخدم عند الاختيار العشوائي لعدد عروض بيع الـ NPC التي تصبح نشطة.",
                    label = "أقصى عدد لعروض بيع الـ NPC",
                },
                darknetNpcMinimumBuyListings = {
                    description = "عند تجديد سوق الـ NPC، سيبقى هذا العدد كحد أدنى من طلبات الشراء المختارة عشوائياً نشطة.",
                    label = "الحد الأدنى لطلبات شراء الـ NPC",
                },
                darknetNpcMinimumSellListings = {
                    description = "عند تجديد سوق الـ NPC، يظل هذا العدد كحد أدنى من عروض البيع المختارة عشوائياً نشطة.",
                    label = "الحد الأدنى لعروض بيع الـ NPC",
                },
                darknetNpcSellerAliases = {
                    description = "أسماء خيالية يتم تخصيصها عشوائياً لعروض بيع الـ NPC الجديدة. قم بتكوين اسمين مستعارين فريدين على الأقل.",
                    label = "أسماء مستعارة لبائعي الـ NPC",
                },
                darknetNpcTraders = {
                    description = "تكوين العروض الاصطناعية، طريقة التسليم، السمعة، واحتمالية الاحتيال.",
                    label = "مشترو وبائعو الـ NPC",
                },
                darknetPoliceGroups = {
                    description = "مفاتيح المجموعة التي يمكنها نشر عروض الطعم وعرض التحقيقات.",
                    label = "مجموعات وظائف الشرطة المصرح لها",
                },
                darknetRenewalHours = {
                    description = "الساعات التي تضاف عند قيام المالك بتجديد العرض.",
                    label = "مدة التجديد (بالساعات)",
                },
                darknetScamChance = {
                    description = "الحد الأدنى لاحتمالية قيام الـ NPC بأخذ الدفع أو البضائع دون تقديم المقابل. لا تزال احتمالية التاجر الخاصة المرتفعة سارية.",
                    label = "فرصة الاحتيال العالمية من قبل الـ NPC (%)",
                },
                darknetStarterBalance = {
                    description = "يتم تخصيص الكريبتو فقط عندما يفتح اللاعب السوق لأول مرة.",
                    label = "رصيد المحفظة الجديد",
                },
                darknetTabletOrder = {
                    description = "يتحكم في موقع سوق الشبكة المظلمة على التابلت.",
                    label = "ترتيب تطبيق التابلت",
                },
                darknetVerifiedMinimumRating = {
                    description = "الحد الأدنى لمتوسط التقييم للبائع الموثق.",
                    label = "التقييم المطلوب للتحقق",
                },
                darknetVerifiedMinimumSales = {
                    description = "المبيعات الناجحة المطلوبة قبل أن يصبح البائع موثقًا.",
                    label = "المبيعات المطلوبة للتحقق",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "يُستخدم عندما يتم ضبط مصدر الدفع على حساب اللاعب. مدفوعات المنظمة تستخدم دائماً حساب قائمة الزعيم.",
                    label = "حساب دفع اللاعب",
                    options = {
                        bank = "البنك",
                        black_money = "أموال قذرة",
                        money = "نقد",
                    },
                    requiresWarning = "يُستخدم فقط مع مصدر دفع حساب اللاعب.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "استخدام إما رصيد اللاعب المشتري أو حساب قائمة الزعيم الخاص بالمنظمة.",
                    label = "مصدر الدفع",
                    options = {
                        player = "حساب اللاعب",
                        society = "حساب المنظمة",
                    },
                },
                drugCamperLockKey = {
                    description = "يحدد المفتاح الافتراضي لقفل وفتح الكامبرات المملوكة أو المشتركة مع الفصيل. يمكن للاعبين تغييره في إعدادات المفاتيح الخاصة بهم في FiveM.",
                    label = "مفتاح قفل الكامبر الافتراضي",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "إضافة بيانات الجودة والتشغيلة إلى مخرجات الجمع بشكل افتراضي. قم بتعطيل هذا الخيار لجعل المواد الخام تتراكم (stack) بشكل طبيعي.",
                    label = "بيانات وصفية لعناصر الجمع",
                },
                drugLabAssaultAlertDuration = {
                    description = "عدد الثواني التي يظل فيها نصف قطر تنبيه المدافعين مرئيًا على الخريطة.",
                    label = "مدة تنبيه المدافعين",
                },
                drugLabAssaultAlertRadius = {
                    description = "نطاق منطقة الهجوم الذي يظهر للفصيل المدافع على الخريطة.",
                    label = "نطاق تنبيه المدافعين",
                },
                drugLabAssaultBreachRadius = {
                    description = "النطاق الذي يجب أن يبقى المهاجم ضمنه أثناء فتح المدخل.",
                    label = "نطاق الاحتفاظ عند الاقتحام",
                },
                drugLabAssaultCaptureDuration = {
                    description = "عدد الثواني التي يجب أن يسيطر فيها المهاجمون على المدخل دون مقاومة للاستيلاء على المختبر أو الكامبر.",
                    label = "مدة الاستيلاء",
                },
                drugLabAssaultCaptureRadius = {
                    description = "منطقة المدخل المستخدمة لعد المهاجمين والمدافعين المتنافسين.",
                    label = "نطاق الاستيلاء",
                },
                drugLabAssaultElectronicDuration = {
                    description = "الثواني المطلوبة لاختراق نظام المدخل.",
                    label = "مدة الاختراق الإلكتروني",
                },
                drugLabAssaultEnabled = {
                    description = "يسمح للفصائل باختراق والاستيلاء على مختبرات المنافسين والمخيمات المشتركة بين الفصائل.",
                    label = "تفعيل الاستيلاء على المختبرات والمخيمات",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "الثواني المطلوبة لاقتحام المدخل باستخدام شحنة متفجرة.",
                    label = "مدة الاقتحام المتفجر",
                },
                drugLabAssaultInteractionDistance = {
                    description = "أقصى مسافة من مدخل المختبر أو المخيم عند بدء الهجوم.",
                    label = "مسافة التفاعل عند المدخل",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "الثواني المطلوبة لثقب قفل المدخل.",
                    label = "مدة الاختراق الميكانيكي",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "عدد الأعضاء المتصلين (Online) من الفصيل المدافع المطلوب قبل بدء الهجوم.",
                    label = "الحد الأدنى للمدافعين",
                },
                drugLabAssaultRequireDuty = {
                    description = "يحتسب فقط أعضاء الفصيل المدافعين الذين هم في الخدمة حاليًا.",
                    label = "عد المدافعين المناوبين فقط",
                },
                drugProcessingInventoryMetadata = {
                    description = "إضافة بيانات الجودة والتشغيلة إلى مخرجات المعالجة بشكل افتراضي. يمكن للوصفات الفردية تجاوز هذا الإعداد.",
                    label = "بيانات وصفية لعناصر المعالجة",
                },
                graffitiItemName = {
                    description = "عنصر من المخزون مطلوب للبدء في الرش عند تفعيل شرط العنصر. يجب أن يكون العنصر موجوداً في المخزون النشط.",
                    label = "عنصر الغرافيتي المطلوب",
                },
                heistCooldownMinutes = {
                    description = "تمنع تكرار نفس المهمة بعد انتهاء محاولة (Run) مع تفاعلات فعلية وتنظيفها. القيمة صفر تلغي فترة الانتظار. عدم استخدام نافذة البدء لا يؤدي لتفعيلها.",
                    label = "فترة انتظار المهمة (بالدقائق)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "شريط تقدم لمدة خمس ثوانٍ. تُستهلك المكونات المطلوبة عند النجاح.",
                        medium = "اختر المكونات بالترتيب المعروض واجتز اختبار توقيت واحدًا لكل مكون.",
                        advanced = "تجميع كامل للجهاز للوصفات ذات ملف الجهاز؛ وإلا فاختبارا توقيت دقيقان لكل مكون.",
                    },
                    description = "بسيط: شريط تقدم لمدة خمس ثوانٍ. متوسط: اختيار المكونات واختبارات التوقيت. أقصى حد: تجميع كامل للجهاز؛ الوصفات التي لا تملك ملف تعريف للجهاز تستخدم اختبارين دقيقين للتوقيت لكل مكون.",
                    label = "تعقيد التصنيع",
                    options = {
                        advanced = "أقصى درجات التعقيد",
                        medium = "تعقيد متوسط",
                        simple = "بسيط",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "بعد التفاعل الأول، تقوم كل عملية سطو جديدة بإعادة ضبط هذا المؤقت. يؤدي انتهاء الوقت إلى إنهاء المحاولة وإزالة كائنات العالم الخاصة بها. ينطبق هذا على المحاولات الجديدة.",
                    label = "حد خمول عملية السطو (بالدقائق)",
                },
                heistStartTimeoutMinutes = {
                    description = "الوقت المتاح بعد الضغط على \"Start\" للتفاعل مع الهدف. بدون تفاعل، يتم إعادة ضبط المحاولة ويمكن البدء بها مرة أخرى. ينطبق هذا على المحاولات الجديدة.",
                    label = "الدقائق حتى أول تفاعل للمهمة",
                },
                moneywashAccount = {
                    options = {
                        bank = "البنك",
                        black_money = "أموال قذرة",
                        money = "نقد",
                    },
                },
                moneywashDirtyAccount = {
                    description = "الحساب الذي تُخصم منه أموال اللاعب غير القانونية عند بدء دورة الغسيل.",
                    label = "حساب الإيداع",
                },
                moneywashDrawDistance = {
                    description = "أقصى مسافة بالأمتار التي يتم عندها عرض مداخل الشركات والمتاجر.",
                    label = "مسافة العرض",
                },
                moneywashEnabled = {
                    description = "يجعل مشاريع غسيل الأموال المملوكة للمنظمة متاحة.",
                    label = "تفعيل غسيل الأموال",
                },
                moneywashFeePercent = {
                    description = "النسبة المئوية التي تُخصم من كل دفعة قبل دفعها للمنظمة.",
                    label = "رسوم الخدمة (%)",
                },
                moneywashInteractionDistance = {
                    description = "أقصى مسافة بالأمتار لاستخدام مداخل الشركات والمتاجر.",
                    label = "مسافة التفاعل",
                },
                npcPoliceAccuracy = {
                    description = "دقة تصويب ضباط الـ NPC من 0 إلى 100.",
                    label = "دقة التصويب",
                },
                npcPoliceArmour = {
                    description = "قيمة درع كل ضابط شرطة (NPC) من 0 إلى 100.",
                    label = "درع الجسم",
                },
                npcPoliceAtms = {
                    description = "إرسال دعم شرطة الـ NPC عند تفعيل إنذار سطو الصراف الآلي.",
                    label = "الدعم أثناء عمليات سطو الصراف الآلي",
                },
                npcPoliceDurationSeconds = {
                    description = "الحد الأقصى للوقت الذي يبقى فيه ضباط الـ NPC منتشرين بعد ظهورهم (30–900 ثانية).",
                    label = "مدة الانتشار (بالثواني)",
                },
                npcPoliceEnabled = {
                    description = "إرسال ضباط NPC مسلحين عند تفعيل إنذار السرقة. غير مفعل افتراضياً.",
                    label = "تفعيل دعم شرطة الـ NPC",
                },
                npcPoliceHeists = {
                    description = "إرسال دعم شرطة (NPC) عند تفعيل إنذار السطو.",
                    label = "الدعم أثناء عمليات السطو",
                },
                npcPoliceOfficerCount = {
                    description = "عدد ضباط الشرطة (NPC) المسلحين الذين يتم إرسالهم لكل إنذار سرقة (1–8).",
                    label = "الضباط لكل استجابة",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "الوقت بين إنذار السرقة ووصول ضباط الـ NPC (0–300 ثانية).",
                    label = "تأخير الاستجابة (بالثواني)",
                },
                npcPoliceShops = {
                    description = "إرسال دعم شرطة الـ NPC عند تفعيل إنذار سطو المتجر.",
                    label = "الدعم أثناء عمليات سطو المتاجر",
                },
                npcPoliceSpawnDistance = {
                    description = "المسافة المستهدفة من موقع السطو التي يظهر عندها ضباط الشرطة (NPC) (بين 15–150 متر).",
                    label = "مسافة الظهور (بالأمتار)",
                },
                npcPoliceWeapon = {
                    description = "السلاح الذي يتم تجهيز كل ضابط شرطة (NPC) مستجيب به. الافتراضي هو المسدس.",
                    label = "سلاح الخدمة",
                    options = {
                        WEAPON_CARBINERIFLE = "بندقية كاربين",
                        WEAPON_PISTOL = "مسدس",
                        WEAPON_PUMPSHOTGUN = "بند شوزن (Pump shotgun)",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "فتح مُهيكل عمليات السطو",
                    description = "افتح منشئ المهام (Heist Creator) وأغلق منسق الوظائف (Job Configurator).",
                    label = "مُهيكل عمليات السطو",
                    unsavedTooltip = "احفظ التغييرات أولاً",
                },
                pickpocketAggressionChance = {
                    description = "فرصة مستقلة لهجوم الـ NPC بعد محاولة فاشلة أو ملغاة أو منتهية الصلاحية.",
                    label = "فرصة الهجوم المضاد (%)",
                },
                pickpocketAlertChance = {
                    description = "فرصة مستقلة لقيام الـ NPC بالإبلاغ عن محاولة فاشلة أو ملغاة أو منتهية الصلاحية.",
                    label = "فرصة مكالمة الطوارئ (%)",
                },
                pickpocketDifficulty = {
                    description = "يتحكم في سرعة المؤشر، ومدى سرعة تقلص الهدف، وطول التسلسل، والأخطاء المسموح بها.",
                    label = "الصعوبة",
                    options = {
                        easy = "سهل",
                        expert = "خبير",
                        hard = "صعب",
                        normal = "عادي",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "الإبلاغ مرة واحدة عن كل محاولة نشل بدأت، حتى عند نجاحها وبغض النظر عن احتمال اتصال الطوارئ.",
                    label = "إرسال بلاغ دائمًا",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "عدد الثواني التي يظل فيها البلاغ متاحاً لمستقبلي البلاغات.",
                    label = "مدة الإرسال",
                },
                pickpocketDispatchJobs = {
                    description = "أسماء الوظائف المفصولة بفاصلة والتي تتلقى مكالمات الطوارئ.",
                    label = "وظائف الإرسال",
                },
                pickpocketDispatchPriority = {
                    description = "الأولوية التي يتم تمريرها دون تغيير إلى نظام الإرسال.",
                    label = "أولوية الإرسال",
                },
                pickpocketDispatchRadius = {
                    description = "نطاق التنبيه التقريبي المرسل إلى نظام الإرسال.",
                    label = "نطاق الإرسال",
                },
                pickpocketEmptyChance = {
                    description = "احتمالية أن لا يحمل الـ NPC أي غنائم قابلة للاختيار على الإطلاق.",
                    label = "احتمالية الجيوب الفارغة (%)",
                },
                pickpocketEnabled = {
                    description = "يسمح للاعبين بمحاولة نشل شخصيات الـ NPC العشوائية المؤهلة عبر الشبكة.",
                    label = "تفعيل نشل الـ NPC",
                },
                pickpocketFleeChance = {
                    description = "فرصة مستقلة لهروب الـ NPC بعد محاولة فاشلة أو ملغاة أو منتهية الصلاحية.",
                    label = "فرصة هروب الـ NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "أقصى نطاق للعميل؛ يقوم الخادم بالتحقق مع هامش مزامنة صغير.",
                    label = "مسافة التفاعل",
                },
                pickpocketItems = {
                    description = "يتحكم كل صف في فرصة ظهوره. تدعم أربعة خانات عشرية نسبة 0.0001 بالمئة.",
                    itemLabel = "فرصة ظهور العنصر",
                    label = "غنائم العنصر",
                },
                pickpocketItemsEnabled = {
                    description = "تقوم أيضًا بدمج العناصر المهيأة ضمن محتويات الجيب المرئية.",
                    label = "تفعيل غنائم العناصر",
                },
                pickpocketMaximumLootChoices = {
                    description = "الحد الأقصى لعدد فتحات النقد أو العناصر التي ينشئها الخادم والموضحة لـ NPC واحد.",
                    label = "الحد الأقصى للغنائم المرئية",
                },
                pickpocketMinigame = {
                    description = "اختر تحدياً واحداً أو التبديل عشوائياً بين التحديات الثلاثة.",
                    label = "لعبة مصغرة",
                    options = {
                        pulse = "نبضة الضغط",
                        random = "دوران عشوائي",
                        sequence = "تسلسل الاتجاهات",
                        timing = "شريط التوقيت",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "أعلى مبلغ نقدي مرئي؛ يتم الحفاظ عليه تلقائياً عند الحد الأدنى أو فوقه.",
                    label = "الحد الأقصى للنقد",
                },
                pickpocketMoneyMinimum = {
                    description = "أدنى مبلغ يتم إنشاؤه من الخادم لفتحة نقد مرئية.",
                    label = "الحد الأدنى للنقد",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "الحد الأدنى من الثواني بين طلبات البدء من لاعب واحد.",
                    label = "وقت انتظار الطلب",
                },
                pickpocketRequireCrimeJob = {
                    description = "مفعل: يضيف الإجراء فقط للوظائف المسجلة في نظام الجريمة. معطل: يزيل إجراء القائمة الدائرية المدمج ويتطلب تصدير الخادم.",
                    label = "استخدام القائمة الدائرية لوظيفة الجريمة",
                },
                pickpocketRequiredHits = {
                    description = "القيمة الأساسية لكل لعبة مصغرة. تزيد الأموال القيمة منها تدريجيًا؛ تتطلب العناصر النادرة للغاية ثماني ضربات على الأقل.",
                    label = "الحد الأدنى من الضربات",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "الثواني المتبقية قبل انتهاء صلاحية تحدي الخادم غير المكتمل.",
                    label = "مهلة الجلسة",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "حظر بعد المحاولات الملغاة أو الفاشلة؛ يظل الـ NPC الذين تم إفراغهم بنجاح غير متاحين.",
                    label = "وقت انتظار الـ NPC",
                },
                pvpAdminAce = {
                    description = "كائن ACE يمنح صلاحية الوصول إلى إدارة أحداث PvP العالمية.",
                    label = "صلاحية ACE للمسؤول",
                },
                pvpArenaReturnSeconds = {
                    description = "وقت العودة الافتراضي للفعاليات الجديدة. يمكن لقادة الفعالية تعديله عبر الجهاز اللوحي.",
                    label = "وقت العودة إلى الساحة",
                },
                pvpArenaWarningPosition = {
                    description = "يتحكم في مكان ظهور تحذير العودة إلى الساحة.",
                    label = "موقع تحذير الساحة",
                    options = {
                        bottom_center = "أسفل المنتصف",
                        bottom_left = "أسفل اليسار",
                        bottom_right = "أسفل اليمين",
                        middle_center = "منتصف الشاشة",
                        middle_left = "منتصف اليسار",
                        middle_right = "منتصف اليمين",
                        top_center = "أعلى المنتصف",
                        top_left = "أعلى اليسار",
                        top_right = "أعلى اليمين",
                    },
                },
                pvpArenas = {
                    description = "إنشاء مناطق قتال دائرية مع نقطة مراقب ونقطتين على الأقل لنقطة ظهور الفريق.",
                    itemLabel = "الساحة",
                    label = "ساحات PvP",
                },
                pvpCountdownPosition = {
                    description = "يتحكم في مكان ظهور العد التنازلي لبدء المباراة.",
                    label = "موقع العد التنازلي",
                    options = {
                        bottom_center = "أسفل المنتصف",
                        bottom_left = "أسفل اليسار",
                        bottom_right = "أسفل اليمين",
                        middle_center = "منتصف الشاشة",
                        middle_left = "منتصف اليسار",
                        middle_right = "منتصف اليمين",
                        top_center = "أعلى المنتصف",
                        top_left = "أعلى اليسار",
                        top_right = "أعلى اليمين",
                    },
                },
                pvpDefaultMode = {
                    description = "وضع اللعب المختار مسبقاً للفعاليات الجديدة.",
                    label = "وضع اللعب الافتراضي",
                    options = {
                        free_for_all = "الكل ضد الكل",
                        last_man_standing = "آخر صامد",
                        team_deathmatch = "قتال الفرق",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "العدد الافتراضي للقتلات المطلوبة للفوز في نمط Team Deathmatch أو Free For All.",
                    label = "هدف القتل الافتراضي",
                },
                pvpEventsEnabled = {
                    description = "تفعيل تطبيق جهاز الـ PvP الخاص بالفصائل وتشغيل منطق الأحداث.",
                    label = "تفعيل أحداث PvP الخاصة بالفصائل",
                },
                pvpKillfeedPosition = {
                    description = "يحدد مكان عرض عمليات الإقصاء الأخيرة.",
                    label = "موقع سجل القتل",
                    options = {
                        bottom_center = "أسفل المنتصف",
                        bottom_left = "أسفل اليسار",
                        bottom_right = "أسفل اليمين",
                        middle_center = "منتصف الشاشة",
                        middle_left = "منتصف اليسار",
                        middle_right = "منتصف اليمين",
                        top_center = "أعلى المنتصف",
                        top_left = "أعلى اليسار",
                        top_right = "أعلى اليمين",
                    },
                },
                pvpLeaderPermission = {
                    description = "صلاحية الوظيفة المطلوبة لإنشاء، وتسجيل، وبدء، وإدارة فعاليات الفصيل.",
                    label = "صلاحية قائد الفصيل",
                },
                pvpMatchDurationMinutes = {
                    description = "المدة الافتراضية بالدقائق للفعاليات الجديدة. القيمة صفر تعطل الحد الزمني.",
                    label = "مدة المباراة",
                },
                pvpMaxHistory = {
                    description = "الحد الأقصى لعدد الأحداث المنتهية أو الملغاة التي تظهر في الجهاز اللوحي.",
                    label = "سجل الأحداث المرئي",
                },
                pvpMaxRewards = {
                    description = "الحد الأقصى لعدد المكافآت المشتركة من عناصر أو أسلحة أو مركبات أو أموال لكل حدث.",
                    label = "الحد الأقصى للمكافآت الإضافية",
                },
                pvpMoneyPermission = {
                    description = "صلاحية الوظيفة مطلوبة لرسوم الدخول وأموال الجوائز.",
                    label = "صلاحية تمويل الفصيل",
                },
                pvpRequestCooldownMs = {
                    description = "الحد الأدنى من الملي ثانية بين طلبات PvP المتغيرة من لاعب واحد.",
                    label = "فترة انتظار الإجراء",
                },
                pvpRespawnDelaySeconds = {
                    description = "الثواني قبل إعادة ظهور اللاعب أو انتقاله إلى منطقة المشاهدة بعد الموت.",
                    label = "تأخير إعادة الظهور",
                },
                pvpSchedulePollSeconds = {
                    description = "الثواني بين فحص القوالب المتكررة والبدء التلقائي.",
                    label = "فاصل فحص الجدول الزمني",
                },
                pvpScoreboardPosition = {
                    description = "يتحكم في مكان ظهور لوحة النتائج المباشرة المختصرة أثناء مباريات الفصيل.",
                    label = "موقع لوحة النتائج",
                    options = {
                        bottom_center = "أسفل المنتصف",
                        bottom_left = "أسفل اليسار",
                        bottom_right = "أسفل اليمين",
                        middle_center = "منتصف الشاشة",
                        middle_left = "منتصف اليسار",
                        middle_right = "منتصف اليمين",
                        top_center = "أعلى المنتصف",
                        top_left = "أعلى اليسار",
                        top_right = "أعلى اليمين",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "يسمح لمسؤولي الـ PvP بالتسجيل والبدء يدويًا مع عضو واحد من الفصيل. قم بتعطيل هذا الخيار في خوادم الإنتاج.",
                    label = "تفعيل اختبار المسؤول الفردي",
                },
                pvpStartCountdownSeconds = {
                    description = "العد التنازلي الافتراضي للأحداث الجديدة. يمكن لقادة الحدث تغييره من الجهاز اللوحي.",
                    label = "بدء العد التنازلي",
                },
                pvpTabletOrder = {
                    description = "يتحكم في مكان ظهور تطبيق PvP الخاص بالفصيل على الجهاز اللوحي.",
                    label = "ترتيب تطبيق التابلت",
                },
                shopActiveTimeoutMinutes = {
                    description = "الدقائق المتبقية قبل فشل عملية سطو مهجورة.",
                    label = "مهلة النشاط",
                },
                shopConsumeDrill = {
                    description = "استهلاك المثقاب بعد الفتح الناجح.",
                    label = "استهلاك المثقاب",
                },
                shopConsumeHackItem = {
                    description = "استهلاك عنصر الاختراق بعد فتح الخزنة بنجاح.",
                    label = "استهلاك عنصر الاختراق",
                },
                shopCooldownMinutes = {
                    description = "الدقائق المتبقية قبل إعادة ضبط المتجر.",
                    label = "فترة انتظار المتجر",
                },
                shopDispatchAlways = {
                    description = "الإبلاغ مرة واحدة عن كل عملية سطو على متجر عند بدئها، بما في ذلك التهديد المتواصل والمتاجر التي لا تتطلب وجود بائع.",
                    label = "إرسال بلاغ دائمًا",
                },
                shopDispatchDurationSeconds = {
                    description = "الثواني التي يظل فيها التنبيه ساريًا.",
                    label = "مدة الإرسال",
                },
                shopDispatchJobs = {
                    description = "وظائف مستلمي التنبيه (مفصولة بفاصلة).",
                    label = "وظائف الإرسال",
                },
                shopDispatchPriority = {
                    description = "الأولوية المرسلة إلى غرفة العمليات.",
                    label = "أولوية الإرسال",
                },
                shopDispatchRadius = {
                    description = "نطاق تنبيه الشرطة التقريبي.",
                    label = "نطاق الإرسال",
                },
                shopDrillDurationSeconds = {
                    description = "الثواني المطلوبة لحفر الخزنة.",
                    label = "مدة حفر الخزنة",
                },
                shopDrillItem = {
                    description = "معرّف عنصر المخزون المطلوب لثقب خزائن المتاجر. مستقل عن مثقاب الصراف الآلي.",
                    label = "عنصر المثقاب",
                },
                shopDrillItemAmount = {
                    description = "عدد عناصر المثقاب المطلوبة.",
                    label = "كمية المثقاب المطلوبة",
                },
                shopEnabled = {
                    description = "تفعيل عمليات السطو في المتاجر الموظفة والمحددة مسبقاً.",
                    label = "تفعيل سرقات المتاجر",
                },
                shopHackItem = {
                    description = "العنصر المطلوب للعبة اختراق الخزنة المصغرة. يتم تفعيل طريقة الفتح بشكل منفصل لكل متجر.",
                    label = "عنصر الاختراق",
                },
                shopHackItemAmount = {
                    description = "الكمية المطلوبة من عنصر الاختراق.",
                    label = "كمية عنصر الاختراق",
                },
                shopIntimidationSeconds = {
                    description = "عدد الثواني التي يجب أن يظل فيها الموظف تحت تهديد السلاح.",
                    label = "مدة الترهيب",
                },
                shopLocations = {
                    description = "موظف واحد وصندوق نقد واحد وخزنة اختيارية لكل متجر.",
                    itemLabel = "متجر",
                    label = "مواقع المتاجر",
                },
                shopMinimumPolice = {
                    description = "عدد أعضاء مجموعة الشرطة المناوبين المطلوب لبدء العملية.",
                    label = "الحد الأدنى للشرطة",
                },
                shopPoliceGroup = {
                    description = "مجموعة الوظائف التي تُحتسب ضمن متطلبات الشرطة.",
                    label = "مجموعة وظيفة الشرطة",
                },
                shopRegisterDurationSeconds = {
                    description = "عدد الثواني المطلوبة لإفراغ الخزينة.",
                    label = "مدة نهب الخزينة",
                },
                shopRegisterRewardMaximum = {
                    description = "أعلى مبلغ يتم دفعه من الخزينة.",
                    label = "الحد الأقصى لمكافأة الخزينة",
                },
                shopRegisterRewardMinimum = {
                    description = "أدنى مبلغ يتم دفعه من الصندوق.",
                    label = "الحد الأدنى لمكافأة الكاشير",
                },
                shopRegisterRewardName = {
                    description = "اسم عنصر أو حساب اختياري.",
                    label = "اسم مكافأة الخزينة",
                },
                shopRegisterRewardSort = {
                    description = "اختر بين النقد وعنصر black_money.",
                    label = "نوع دفع صندوق النقد",
                },
                shopRegisters = {
                    description = "مواقع الخزائن المخصصة حسب معرف المتجر.",
                    itemLabel = "الخزينة",
                    label = "آلات تسجيل النقد",
                },
                shopSafeLootDurationSeconds = {
                    description = "الثواني المطلوبة لأخذ النقد بعد إدخال رمز خزنة صحيح.",
                    label = "مدة نهب الخزنة",
                },
                shopSafeRewardMaximum = {
                    description = "أعلى مبلغ صرف للخزنة.",
                    label = "الحد الأقصى لمكافأة الخزنة",
                },
                shopSafeRewardMinimum = {
                    description = "أدنى مبلغ صرف للخزنة.",
                    label = "الحد الأدنى لمكافأة الخزنة",
                },
                shopSafeRewardName = {
                    description = "اسم عنصر أو حساب اختياري.",
                    label = "اسم مكافأة الخزنة",
                },
                shopSafeRewardSort = {
                    description = "اختر بين النقد وعنصر black_money.",
                    label = "نوع دفع الخزنة",
                },
                shopThreatGraceSeconds = {
                    description = "المدة المسموح بها من المقاطعة قبل إطلاق الإنذار.",
                    label = "فترة سماح التصويب",
                },
                territoryDrugSalesEnabled = {
                    description = "المبيعات الناجحة في الشوارع للـ NPCs تمنح نفوذاً لعصابة البائع في منطقة الشارع الحالية.",
                    label = "مبيعات الـ NPC تمنح نفوذاً للمنطقة",
                },
                atmLocationMode = {
                    label = "وضع مواقع الصرافات",
                    description = "يكتشف كائنات العالم المدعومة تلقائيًا أو يستخدم المواقع المُعدّة يدويًا فقط.",
                    options = {
                        automatic = "تلقائي",
                        manual = "يدوي",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "اشتراط شرطة في الخدمة",
                    description = "يشترط العدد المحدد من رجال الشرطة في الخدمة قبل بدء سرقة الصراف الآلي.",
                },
                openDrugCreator = {
                    label = "محرر المخدرات",
                    description = "يفتح محرر المخدرات في Sky Crime ويغلق أداة إعداد الوظائف.",
                    buttonLabel = "فتح محرر المخدرات",
                    unsavedTooltip = "احفظ أولًا",
                },
                drugCreatorRuntimeDensity = {
                    label = "كثافة لوحة التشغيل",
                    description = "يحدد مدى تقارب عرض لوحة التشغيل في محرر المخدرات.",
                    options = {
                        comfortable = "مريح",
                        compact = "مدمج",
                    },
                },
                drugCreatorListDensity = {
                    label = "كثافة القائمة",
                    description = "يحدد مدى تقارب عرض قائمة الإدخالات في المحرر.",
                    options = {
                        comfortable = "مريح",
                        compact = "مدمج",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "عرض قوائم التشغيل الفارغة",
                    description = "يعرض أقسام لوحة التشغيل حتى عندما تكون خالية من الإدخالات.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "إخفاء الإدخالات المعطلة",
                    description = "يخفي إدخالات الوحدات المعطلة من قائمة محرر المخدرات.",
                },
                drugCreatorAutoGenerateId = {
                    label = "إنشاء المعرّفات تلقائيًا",
                    description = "ينشئ المعرّفات من الأسماء عند إضافة إدخالات جديدة في محرر المخدرات.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "فتح المحرر عند تبديل الوحدة",
                    description = "يفتح المحرر تلقائيًا عند تبديل الوحدة النشطة.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "لاحقة تلقائية للنسخ",
                    description = "يضيف لاحقة تلقائية عند تكرار إدخالات محرر المخدرات.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "تحديد أهداف اللعب مسبقًا تلقائيًا",
                    description = "يحدد المختبرات والدفعات المتاحة مسبقًا بشكل تلقائي.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "التركيز على المشاكل عند الفتح",
                    description = "يفتح لوحة التشغيل مع التركيز على الإدخالات التي تتطلب الانتباه.",
                },
                drugActivityHudPosition = {
                    label = "موضع واجهة النشاط",
                    description = "اسحب واجهة الوضع والحصاد إلى الموضع المطلوب على الشاشة.",
                },
                drugInteractionHudPosition = {
                    label = "موضع واجهة التفاعل",
                    description = "اسحب واجهة تفاعل النباتات والمختبرات والعربات إلى الموضع المطلوب على الشاشة.",
                },
                drugPlantStatusHudPosition = {
                    label = "موضع واجهة حالة النبات",
                    description = "اسحب واجهة حالة النبات التفصيلية إلى الموضع المطلوب على الشاشة.",
                },
                drugSystemEnabled = {
                    label = "نظام المخدرات",
                    description = "يُفعّل: إنتاج المخدرات وبيانات المحرر وواجهات اللعب لهذه الوظيفة الإجرامية.",
                },
                drugCreatorAccess = {
                    label = "الوصول إلى محرر المخدرات",
                    description = "يحدد من يمكنه فتح محرر المخدرات المتقدم.",
                    options = {
                        permission = "بإذن فقط",
                        job_management = "إدارة الوظيفة",
                        owner_only = "المالك فقط",
                    },
                },
                drugRuntimeEnabled = {
                    label = "واجهات تشغيل اللعب",
                    description = "يسمح للاعبين باستخدام إجراءات المختبر والنباتات والمعالجة والسوق داخل اللعبة.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "إنشاء المختبرات بواسطة اللاعبين",
                    description = "يسمح للاعبين ذوي صلاحية الوصول بإنشاء مختبرات من قوالب المحرر دون صلاحيات إدارة.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "الزراعة في الهواء الطلق",
                    description = "يسمح للاعبين بزراعة نباتاتهم خارج المختبرات المُعدّة.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "الحصاد الخارجي بواسطة لاعبين آخرين",
                    description = "يسمح للاعبين الآخرين بحصاد النباتات الخارجية التي لم يزرعوها.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "تحصيل ثمن شراء المختبر",
                    description = "يخصم من اللاعبين سعر الشراء المُعدّ عند إنشاء مختبر.",
                },
                drugRuntimeStrictInventory = {
                    label = "التحقق الصارم من المخزون",
                    description = "لا تستمر إجراءات اللعب إلا بعد نجاح العمليات المحددة للعناصر والأدوات والأموال.",
                },
                drugRuntimeSalePayouts = {
                    label = "البيع / المدفوعات",
                    description = "يدفع للاعبين عند بيع دفعات أو مسارات عبر نظام السوق.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "المستحقات / الحساب",
                    description = "حساب عائدات بيع المخدرات، مثل black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "إرسال / التنبيهات",
                    description = "يرسل أحداث مخاطر المخدرات إلى مركز العمليات ووظائف الشرطة المحددة.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "الشرطة / التنبيهات",
                    description = "يُخطر وظائف الشرطة المحددة عندما يتسبب حدث خطر متعلق بالمخدرات في إنذار للشرطة.",
                },
                drugBatchPrefix = {
                    label = "دفعة / البادئة",
                    description = "بادئة معرّفات دفعات المخدرات الجديدة.",
                },
                drugTestingKitAccuracy = {
                    label = "عدة اختبار / الدقة",
                    description = "مقدار التفاوت المسموح في القيم المخفية باستخدام مجموعة فحص أساسية.",
                },
                drugDecayIntervalMinutes = {
                    label = "الاضمحلال / الفاصل الزمني",
                    description = "الفاصل بالدقائق لـ فحوصات تراجع النضارة والتلوث.",
                },
                drugDefaultPackaging = {
                    label = "القيمة الافتراضية / التغليف",
                    description = "التغليف المستخدم للدفعات الخام أو المعالجة التي تُنشأ دون تحديد نوع تغليف.",
                    options = {
                        loose = "فرط",
                        baggy = "كيس صغير",
                        jar = "عبوة زجاجية",
                        vacuum = "كيس تفريغ الهواء",
                        brick = "غلاف الكتلة",
                        premium_seal = "ختم ممتاز",
                    },
                },
                drugQualityWeightQuality = {
                    label = "الجودة / الوزن",
                    description = "التأثير على الجودة النهائية: الجودة الأساسية.",
                },
                drugQualityWeightPurity = {
                    label = "النقاء / الوزن",
                    description = "التأثير على الجودة النهائية: النقاء.",
                },
                drugQualityWeightFreshness = {
                    label = "النضارة / الوزن",
                    description = "التأثير على الجودة النهائية: النضارة.",
                },
                drugQualityWeightPotency = {
                    label = "القوة / الوزن",
                    description = "التأثير على الجودة النهائية: القوة.",
                },
                drugQualityWeightStability = {
                    label = "الاستقرار / الوزن",
                    description = "التأثير على الجودة النهائية: الاستقرار.",
                },
                drugQualityWeightContamination = {
                    label = "تلوث / العقوبة",
                    description = "خصم من تقييم جودة المنتجات الملوثة.",
                },
                drugTierGoodMin = {
                    label = "جيد / المستوى / الحد الأدنى",
                    description = "الحد الأدنى للنقاط لمستوى الجودة جيد.",
                },
                drugTierPremiumMin = {
                    label = "ممتاز / المستوى / الحد الأدنى",
                    description = "الحد الأدنى للنقاط لمستوى الجودة ممتاز.",
                },
                drugTierTopShelfMin = {
                    label = "الجودة الفائقة / المستوى / الحد الأدنى",
                    description = "الحد الأدنى للنقاط لمستوى الجودة الجودة الفائقة.",
                },
                drugTierLabGradeMin = {
                    label = "الجودة المخبرية / المستوى / الحد الأدنى",
                    description = "الحد الأدنى للنقاط لمستوى الجودة الجودة المخبرية.",
                },
                drugBaggyDecayMultiplier = {
                    label = "كيس صغير / الاضمحلال",
                    description = "المضاعف لـ فقدان النضارة / الأكياس الصغيرة.",
                },
                drugJarDecayMultiplier = {
                    label = "عبوة زجاجية / الاضمحلال",
                    description = "المضاعف لـ فقدان النضارة / العبوات الزجاجية.",
                },
                drugVacuumDecayMultiplier = {
                    label = "التفريغ الهوائي / الاضمحلال",
                    description = "المضاعف لـ فقدان النضارة / أكياس تفريغ الهواء.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "ختم ممتاز / السعر",
                    description = "المضاعف لـ ممتاز / منتج مختوم / السعر.",
                },
                drugGrowingEnabled = {
                    label = "الزراعة / مفعّل",
                    description = "يُفعّل: نمو النباتات والحصاد.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "فحص موقع النباتات",
                    description = "عند التفعيل، تنتظر النباتات المزروعة في العالم فحصًا تلقائيًا للموقع بواسطة مسؤول قبل أن تنمو. عطّل الخيار للسماح بالنمو دون موافقة المسؤول.",
                },
                drugGrowthTickMinutes = {
                    label = "النمو / دورة التحديث / الدقائق",
                    description = "الفاصل بالدقائق لـ تحديثات نمو النباتات.",
                },
                drugBaseGrowthPerTick = {
                    label = "القيمة الأساسية / النمو / لكل دورة تحديث",
                    description = "النمو الأساسي قبل تأثيرات السلالة والمعدات والعناية.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "نبتة برية / الظهور مجددًا",
                    description = "مدة الانتظار بالدقائق قبل نبتة برية / الظهور مجددًا.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "إبراز النباتات البرية",
                    description = "يعرض إطارًا حول النباتات البرية الموجودة عندما يدخل اللاعب نطاق الإبراز.",
                },
                drugWildPlantHighlightDistance = {
                    label = "نطاق إبراز النباتات البرية",
                    description = "المسافة بالأمتار حول كل نبتة برية موجودة التي يظهر ضمنها إطارها.",
                },
                drugDefaultPlantWater = {
                    label = "القيمة الافتراضية / ماء",
                    description = "القيمة الأولية عند إنشاء نبتة: ماء.",
                },
                drugDefaultPlantFertilizer = {
                    label = "القيمة الافتراضية / السماد",
                    description = "القيمة الأولية عند إنشاء نبتة: السماد.",
                },
                drugDefaultPlantHealth = {
                    label = "القيمة الافتراضية / الصحة",
                    description = "القيمة الأولية عند إنشاء نبتة: الصحة.",
                },
                drugDefaultPlantMutationChance = {
                    label = "القيمة الافتراضية / فرصة الطفرة",
                    description = "احتمال الطفرة الأساسي عند عدم تحديد قيمة خاصة للسلالة.",
                },
                drugHarvestPerfectStart = {
                    label = "بداية نافذة الحصاد المثالية",
                    description = "نسبة النمو لنافذة الحصاد المثالية: البداية.",
                },
                drugHarvestPerfectEnd = {
                    label = "نهاية نافذة الحصاد المثالية",
                    description = "نسبة النمو لنافذة الحصاد المثالية: النهاية.",
                },
                drugLabsEnabled = {
                    label = "مختبرات / مفعّل",
                    description = "يُفعّل: المختبرات والمركبات السكنية أثناء اللعب.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "المختبرات لكل شخصية",
                    description = "الحد الأقصى للمختبرات الثابتة المشتراة أو المستأجرة لكل مالك. 0 يعني بلا حد؛ لا تُحتسب المركبات السكنية أو صلاحيات الوصول المشتركة.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "المختبرات لكل فصيل",
                    description = "الحد الأقصى للمختبرات الثابتة المشتراة أو المستأجرة لكل مالك. 0 يعني بلا حد؛ لا تُحتسب المركبات السكنية أو صلاحيات الوصول المشتركة.",
                },
                drugDefaultRentDays = {
                    label = "القيمة الافتراضية / أيام الإيجار",
                    description = "القيمة الافتراضية لـ مختبر / الإيجار / المدة.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "مركبة سكنية مسروقة / الدقائق",
                    description = "المدة التي تبقى خلالها المركبات السكنية المسروقة عالية المخاطر.",
                },
                drugLabRentWarningHours = {
                    label = "الإيجار / تحذير / الساعات",
                    description = "عدد الساعات قبل انتهاء إيجار المختبر التي يبدأ عندها إظهار التحذير.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "الإيجار المنتهي / الضغط الأمني",
                    description = "اهتمام الشرطة الإضافي عند انتهاء إيجار المختبر.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "عربة التخييم / تحريك / فترة الانتظار",
                    description = "مدة الانتظار بالدقائق قبل عربة التخييم / مختبر / النقل مجددًا.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "الترقية / التكلفة / المضاعف",
                    description = "المضاعف لـ مختبر / المستوى / الترقية / الأسعار.",
                },
                drugCamperBaseSlots = {
                    label = "عربة التخييم / الخانات",
                    description = "القيمة الافتراضية لـ مختبرات المركبات السكنية / خانات المعدات.",
                },
                drugCamperBaseStorage = {
                    label = "عربة التخييم / التخزين",
                    description = "القيمة الافتراضية لـ مختبرات المركبات السكنية / سعة التخزين.",
                },
                drugCamperBasePower = {
                    label = "عربة التخييم / الطاقة",
                    description = "القيمة الافتراضية لـ مختبرات المركبات السكنية / مصدر الطاقة المدمج.",
                },
                drugBasementBaseSlots = {
                    label = "القبو / الخانات",
                    description = "القيمة الافتراضية لـ مختبرات الأقبية / خانات المعدات.",
                },
                drugBasementBaseStorage = {
                    label = "القبو / التخزين",
                    description = "القيمة الافتراضية لـ مختبرات الأقبية / سعة التخزين.",
                },
                drugWarehouseBasePower = {
                    label = "المستودع / الطاقة",
                    description = "القيمة الافتراضية لـ مختبرات المستودعات / مصدر الطاقة المدمج.",
                },
                drugPowerEnabled = {
                    label = "الطاقة / نظام",
                    description = "يُفعّل: توليد الكهرباء واستهلاكها وفحوصات الحمل الزائد في المختبر.",
                },
                drugOverloadGraceSeconds = {
                    label = "الحمل الزائد / فترة السماح",
                    description = "عدد الثواني قبل أن يصبح الحمل الكهربائي الزائد خطرًا.",
                },
                drugHeatPerKilowatt = {
                    label = "الضغط الأمني / لكل كيلوواط",
                    description = "اهتمام الشرطة بالمختبر الناتج عن استهلاك الكهرباء.",
                },
                drugGeneratorT1Watts = {
                    label = "مولد T1 / واط",
                    description = "قدرة مولدات المستوى T1 بالواط.",
                },
                drugGeneratorT2Watts = {
                    label = "مولد T2 / واط",
                    description = "قدرة مولدات المستوى T2 بالواط.",
                },
                drugGeneratorT3Watts = {
                    label = "مولد T3 / واط",
                    description = "قدرة مولدات المستوى T3 بالواط.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "التآكل / المضاعف",
                    description = "المضاعف العام لـ تآكل المعدات / المعالجة.",
                },
                drugWorkersEnabled = {
                    label = "العمال / مفعّل",
                    description = "يُفعّل: الكيميائيون والمزارعون وعمال التغليف والحراسة في مختبرات المخدرات.",
                },
                drugMaxWorkersPerLab = {
                    label = "الحد الأقصى / العمال / مختبر",
                    description = "الحد الأقصى لعدد العاملين في المختبر الواحد.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "التعب من المعالجة",
                    description = "التعب المضاف إلى العمال بعد العمل التالي: خطوة المعالجة.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "الزراعة / إرهاق",
                    description = "التعب المضاف إلى المزارعون بعد العمل التالي: الحصاد أو أعمال الزراعة.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "عامل / التعافي",
                    description = "التعافي من إرهاق عند كل دورة: تحديث النمو.",
                },
                drugMarketEnabled = {
                    label = "السوق / مفعّل",
                    description = "يُفعّل: المشترون والتجار وبيع الدفعات.",
                },
                drugMarketBasePriceFallback = {
                    label = "القيمة البديلة / السعر الأساسي",
                    description = "السعر الأساسي للمخدرات التي ليس لها سعر مُعدّ خاص.",
                },
                drugMarketStreetMultiplier = {
                    label = "الشارع / المضاعف",
                    description = "المضاعف العام لـ السعر / مبيعات الشارع.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "بيع الجملة / المضاعف",
                    description = "المضاعف العام لـ السعر / بيع الجملة / الصفقات.",
                },
                drugMarketPremiumMultiplier = {
                    label = "ممتاز / المضاعف",
                    description = "المضاعف العام لـ السعر / ممتاز / المشترون.",
                },
                drugMarketHeatPerSale = {
                    label = "الضغط الأمني / البيع",
                    description = "الضغط الأمني الأساسي المضاف للمختبر عند بيع دفعة.",
                },
                drugDistributionTickMinutes = {
                    label = "التوزيع / دورة التحديث",
                    description = "الفاصل بالدقائق لـ تحديثات توزيع التجار.",
                },
                drugDistributionIntervalMinutes = {
                    label = "التوزيع / الفاصل الزمني",
                    description = "القيمة الافتراضية لـ تاجر / مدة الانتظار قبل البيع / الدقائق.",
                },
                drugDistributionMaxPerDealer = {
                    label = "الحد الأقصى / تاجر / الطلبات",
                    description = "القيمة الافتراضية لـ تاجر / الحد الأقصى لطلبات التوزيع النشطة.",
                },
                drugThreatsEnabled = {
                    label = "تهديدات / مفعّل",
                    description = "يُفعّل: انخفاض اهتمام الشرطة والمداهمات والتخريب في المختبرات.",
                },
                drugThreatTickMinutes = {
                    label = "التهديد / دورة التحديث",
                    description = "الفاصل بالدقائق لـ انخفاض اهتمام الشرطة وفحوصات المداهمات والتخريب.",
                },
                drugRaidHeatThreshold = {
                    label = "عتبة اهتمام الشرطة للمداهمات",
                    description = "الضغط الأمني المطلوب في المختبر قبل إمكانية تفعيل المداهمات.",
                },
                drugSabotageHeatThreshold = {
                    label = "عتبة اهتمام الشرطة للتخريب",
                    description = "الضغط الأمني المطلوب في المختبر قبل إمكانية تفعيل التخريب.",
                },
                drugThreatHeatDecay = {
                    label = "الضغط الأمني / الاضمحلال",
                    description = "يقلل اهتمام الشرطة بالمختبر بهذه القيمة عند كل تحديث للتهديدات.",
                },
                drugRaidChanceAtThreshold = {
                    label = "احتمال المداهمة",
                    description = "الاحتمال الأساسي لـ الهجوم عند بلوغ حد الضغط الأمني المرتبط به.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "التخريب / فرصة",
                    description = "الاحتمال الأساسي لـ التخريب عند بلوغ حد الضغط الأمني المرتبط به.",
                },
                drugConsumptionEnabled = {
                    label = "الاستهلاك مفعل",
                    description = "يُفعّل: تأثيرات المخدرات وتتبع التحمل والإدمان.",
                },
                drugDoseConsumesBatch = {
                    label = "استهلاك الدفعة عند الاستخدام",
                    description = "يزيل الدفعة المستهلكة من المخزون النشط.",
                },
                drugToleranceDecayMinutes = {
                    label = "التسامح / الاضمحلال",
                    description = "الفاصل بالدقائق لـ تحديثات انخفاض التحمل.",
                },
                drugAddictionDecayMinutes = {
                    label = "الإدمان / الاضمحلال",
                    description = "الفاصل بالدقائق لـ تحديثات انخفاض الإدمان.",
                },
                drugPotencyEffectMultiplier = {
                    label = "القوة / المضاعف",
                    description = "يحدد مدى زيادة قوة المادة لشدة التأثيرات.",
                },
                drugOverdosePotencyThreshold = {
                    label = "الجرعة الزائدة / العتبة",
                    description = "حمل المادة الفعالة المطلوب قبل بدء احتمالات الجرعة الزائدة.",
                },
                drugBaseAddictionGain = {
                    label = "القيمة الأساسية / الإدمان / عائد",
                    description = "الزيادة الأساسية في الإدمان لكل جرعة.",
                },
                drugProcessingEnabled = {
                    label = "المعالجة / مفعّل",
                    description = "يُفعّل: مهام المعالجة والتغليف ومجموعات الفحص.",
                },
                drugBatchMetadataItemKey = {
                    label = "دفعة / البيانات الوصفية / المفتاح",
                    description = "مفتاح بيانات المخزون الوصفية الذي تستخدمه التكاملات لبيانات الدفعات.",
                },
                drugDefaultProcessDuration = {
                    label = "مدة المعالجة الافتراضية",
                    description = "القيمة الافتراضية لـ المعالجة / المدة / ثوانٍ / دون قيمة خاصة للوصفة.",
                },
                drugDefaultFailureRisk = {
                    label = "القيمة الافتراضية / خطر الفشل",
                    description = "القيمة الافتراضية لـ المعالجة / خطر الفشل / دون قيمة خاصة للوصفة.",
                },
                drugPackagingDuration = {
                    label = "مدة التغليف",
                    description = "القيمة الافتراضية لـ التغليف / المدة / ثوانٍ.",
                },
                drugPowerTickSeconds = {
                    label = "الطاقة / دورة التحديث / ثوانٍ",
                    description = "الفاصل بالثواني لـ تحديث استهلاك المولدات والبصمات الكهربائية.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "البصمة الكهربائية / الضغط الأمني / الساعة",
                    description = "اهتمام الشرطة الناتج كل ساعة عن البصمة الكهربائية للمختبر.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "الحمل الزائد / الضغط الأمني / الساعة",
                    description = "الضغط الأمني الإضافي كل ساعة أثناء زيادة حمل المختبر.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "خاملاً / الضغط الأمني / الاضمحلال / الساعة",
                    description = "انخفاض اهتمام الشرطة كل ساعة ما دام المختبر بلا بصمة كهربائية نشطة.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "يدوي / الحد الأقصى / الحمل",
                    description = "قيمة الحد الأقصى / الحمل في وضع الطاقة يدوي.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "يدوي / الضغط الأمني / المضاعف",
                    description = "قيمة الضغط الأمني / المضاعف في وضع الطاقة يدوي.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "يدوي / الضجيج / المضاعف",
                    description = "قيمة الضجيج / المضاعف في وضع الطاقة يدوي.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "متوازن / الحد الأقصى / الحمل",
                    description = "قيمة الحد الأقصى / الحمل في وضع الطاقة متوازن.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "متوازن / الضغط الأمني / المضاعف",
                    description = "قيمة الضغط الأمني / المضاعف في وضع الطاقة متوازن.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "متوازن / الضجيج / المضاعف",
                    description = "قيمة الضجيج / المضاعف في وضع الطاقة متوازن.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "تسللي / الحد الأقصى / الحمل",
                    description = "قيمة الحد الأقصى / الحمل في وضع الطاقة تسللي.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "تسللي / الضغط الأمني / المضاعف",
                    description = "قيمة الضغط الأمني / المضاعف في وضع الطاقة تسللي.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "تسللي / الضجيج / المضاعف",
                    description = "قيمة الضجيج / المضاعف في وضع الطاقة تسللي.",
                },
                drugPowerPrioritySmellControl = {
                    label = "التحكم بالروائح / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: التحكم بالروائح / المعدات.",
                },
                drugPowerPriorityAirflow = {
                    label = "التهوية / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: التهوية / المعدات.",
                },
                drugPowerPrioritySecurity = {
                    label = "الأمان / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: معدات أمنية.",
                },
                drugPowerPriorityGrowing = {
                    label = "الزراعة / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: الزراعة / المعدات.",
                },
                drugPowerPriorityLight = {
                    label = "الإضاءة / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: الإضاءة / المعدات.",
                },
                drugPowerPriorityTesting = {
                    label = "الفحص / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: الفحص / المعدات.",
                },
                drugPowerPriorityPackaging = {
                    label = "التغليف / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: التغليف / المعدات.",
                },
                drugPowerPriorityChemistry = {
                    label = "كيمياء / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: كيمياء / المعدات.",
                },
                drugPowerPriorityHeating = {
                    label = "التدفئة / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: التدفئة / المعدات.",
                },
                drugPowerPriorityPressing = {
                    label = "الكبس / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: الكبس / المعدات.",
                },
                drugPowerPriorityGeneral = {
                    label = "عام / الأولوية",
                    description = "أولوية فصل الأحمال التلقائي: معدات عامة.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "الأداء / غير نشط / التحكم / الفاصل الزمني / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / غير نشط / التحكم / الفاصل الزمني / مللي ثانية.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "الأداء / تفاعل / خاملاً / فاصل الفحص / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / تفاعل / خاملاً / فاصل الفحص / مللي ثانية.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "الأداء / تفاعل / إرشاد التفاعل / الفاصل الزمني / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / تفاعل / إرشاد التفاعل / الفاصل الزمني / مللي ثانية.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "الأداء / تفاعل / فاصل الفحص / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / تفاعل / فاصل الفحص / مللي ثانية.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "الأداء / الحد الأدنى / فاصل الفحص / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / الحد الأدنى / فاصل الفحص / مللي ثانية.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / تفعيل / المسافة",
                    description = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / تفعيل / المسافة.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / خاملاً / فاصل الفحص / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / خاملاً / فاصل الفحص / مللي ثانية.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / فاصل الفحص / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / فاصل الفحص / مللي ثانية.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "الأداء / العالم / ذاكرة التخزين المؤقت / الهامش الإضافي",
                    description = "إعداد التشغيل الخاص بـ الأداء / العالم / ذاكرة التخزين المؤقت / الهامش الإضافي.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "الأداء / العالم / ذاكرة التخزين المؤقت / التحديث / الفاصل الزمني / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / العالم / ذاكرة التخزين المؤقت / التحديث / الفاصل الزمني / مللي ثانية.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "الأداء / العالم / خاملاً / الفاصل الزمني / مللي ثانية",
                    description = "إعداد التشغيل الخاص بـ الأداء / العالم / خاملاً / الفاصل الزمني / مللي ثانية.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "السوق الديناميكي / فترة انتظار الإجراء / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / فترة انتظار الإجراء / ثوانٍ.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "السوق الديناميكي / فعل / حد السجل",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / فعل / حد السجل.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "السوق الديناميكي / الكمية / التشبع / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الكمية / التشبع / الوزن.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "السوق الديناميكي / القيمة الأساسية / دقة المعلومات",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأساسية / دقة المعلومات.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "السوق الديناميكي / القيمة الافتراضية / المتوسط / الجودة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الافتراضية / المتوسط / الجودة.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "السوق الديناميكي / القيمة الافتراضية / مورد / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الافتراضية / مورد / المرونة.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "السوق الديناميكي / الطلب / القيمة الوسطية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطلب / القيمة الوسطية.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "السوق الديناميكي / الطلب / السعر / التأثير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطلب / السعر / التأثير.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "السوق الديناميكي / الاتجاه / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / العتبة.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "السوق الديناميكي / مفعّل",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مفعّل.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "السوق الديناميكي / الحدث / فرصة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / فرصة.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "السوق الديناميكي / الحدث / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / المدة / الدقائق.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "السوق الديناميكي / الحدث / الحد الأدنى / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / الحد الأدنى / المدة / الدقائق.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "السوق الديناميكي / الحدث / القوة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / القوة / الحد الأقصى.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "السوق الديناميكي / الحدث / القوة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحدث / القوة / الحد الأدنى.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "السوق الديناميكي / الأحداث / الحملة الأمنية / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحملة الأمنية / الطلب.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "السوق الديناميكي / الأحداث / الحملة الأمنية / الشرطة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحملة الأمنية / الشرطة.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "السوق الديناميكي / الأحداث / الحملة الأمنية / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحملة الأمنية / السعر.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / الطلب.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 2",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 3",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / التأثيرات / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / السعر.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "السوق الديناميكي / الأحداث / المهرجان / الملفات / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / المهرجان / الملفات / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "السوق الديناميكي / الأحداث / صراع عصابات / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / صراع عصابات / الطلب.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "السوق الديناميكي / الأحداث / صراع عصابات / الشرطة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / صراع عصابات / الشرطة.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "السوق الديناميكي / الأحداث / صراع عصابات / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / صراع عصابات / السعر.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "السوق الديناميكي / الأحداث / صراع عصابات / الملفات / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / صراع عصابات / الملفات / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "السوق الديناميكي / الأحداث / مداهمة المختبر / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / مداهمة المختبر / الطلب.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "السوق الديناميكي / الأحداث / مداهمة المختبر / الشرطة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / مداهمة المختبر / الشرطة.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "السوق الديناميكي / الأحداث / مداهمة المختبر / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / مداهمة المختبر / السعر.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "السوق الديناميكي / الأحداث / مداهمة المختبر / العرض",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / مداهمة المختبر / العرض.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / الطلب.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 2",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 3",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / التأثيرات / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / السعر.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / الملفات / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / الملفات / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "السوق الديناميكي / الأحداث / الحفلة / الملفات / 2",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / الحفلة / الملفات / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "السوق الديناميكي / الأحداث / النقص / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / النقص / الطلب.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "السوق الديناميكي / الأحداث / النقص / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / النقص / السعر.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "السوق الديناميكي / الأحداث / النقص / العرض",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الأحداث / النقص / العرض.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "السوق الديناميكي / معلومات دقيقة / السمعة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / معلومات دقيقة / السمعة.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "السوق الديناميكي / معلومات دقيقة / الثقة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / معلومات دقيقة / الثقة.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "السوق الديناميكي / عامa40074848905d12c107f984aac5d9776 / منطقة / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / عامa40074848905d12c107f984aac5d9776 / منطقة / التسمية.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "السوق الديناميكي / حد السجل",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / حد السجل.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "السوق الديناميكي / القيمة الأولية / الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأولية / الطلب.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "السوق الديناميكي / القيمة الأولية / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / القيمة الأولية / مضاعف السعر.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "السوق الديناميكي / المعلومات / الطلب / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الطلب / خطأ.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "السوق الديناميكي / المعلومات / الحد الأقصى / الدقة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحد الأقصى / الدقة.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "السوق الديناميكي / المعلومات / الحد الأدنى / الدقة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحد الأدنى / الدقة.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "السوق الديناميكي / المعلومات / الشرطة / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الشرطة / خطأ.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "السوق الديناميكي / المعلومات / السعر / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / خطأ.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "السوق الديناميكي / المعلومات / السعر / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / الحد الأقصى.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "السوق الديناميكي / المعلومات / السعر / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السعر / الحد الأدنى.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "السوق الديناميكي / المعلومات / السمعة / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / السمعة / الوزن.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "السوق الديناميكي / المعلومات / مورد / السعر / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / مورد / السعر / خطأ.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "السوق الديناميكي / المعلومات / التشبع / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / التشبع / خطأ.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "السوق الديناميكي / فترة بذرة المعلومات العشوائية / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / فترة بذرة المعلومات العشوائية / ثوانٍ.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "السوق الديناميكي / المعلومات / الحالة / الدقة / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحالة / الدقة / العتبة.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "السوق الديناميكي / المعلومات / الحالة / خطأ / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الحالة / خطأ / العتبة.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "السوق الديناميكي / المعلومات / العرض / خطأ",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / العرض / خطأ.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "السوق الديناميكي / المعلومات / الثقة / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المعلومات / الثقة / الوزن.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "السوق الديناميكي / التلاعب / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / دقائق فترة الانتظار.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "السوق الديناميكي / التلاعب / الطلب / التغير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الطلب / التغير.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "السوق الديناميكي / التلاعب / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / المدة / الدقائق.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "السوق الديناميكي / التلاعب / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الضغط الأمني.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "السوق الديناميكي / التلاعب / الحد الأدنى / دفعة / الكمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / الحد الأدنى / دفعة / الكمية.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "السوق الديناميكي / التلاعب / حساب الدفع",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / حساب الدفع.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "السوق الديناميكي / التلاعب / السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / السعر.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "السوق الديناميكي / التلاعب / منطقة / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التلاعب / منطقة / الضغط الأمني / المضاعف.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "السوق الديناميكي / الحد الأقصى / عمر المعلومة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأقصى / عمر المعلومة / الدقائق.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "السوق الديناميكي / الحد الأقصى / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأقصى / مضاعف السعر.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "السوق الديناميكي / الحد الأدنى / عمر المعلومة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / عمر المعلومة / الدقائق.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "السوق الديناميكي / الحد الأدنى / المقياس / النافذة الزمنية / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / المقياس / النافذة الزمنية / الدقائق.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "السوق الديناميكي / الحد الأدنى للسعر / المضاعف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى للسعر / المضاعف.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "السوق الديناميكي / الحد الأدنى / التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحد الأدنى / التحديث / الدقائق.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "السوق الديناميكي / الشرطة / الطلب / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الشرطة / الطلب / الوزن.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "السوق الديناميكي / الشرطة / السعر / التأثير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الشرطة / السعر / التأثير.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "السوق الديناميكي / الجودة المنخفضة / الطلب / العقوبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة المنخفضة / الطلب / العقوبة.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "السوق الديناميكي / الجودة المنخفضة / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة المنخفضة / العتبة.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "السوق الديناميكي / الجودة الممتازة / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة الممتازة / مكافأة الطلب.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "السوق الديناميكي / الجودة الممتازة / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة الممتازة / العتبة.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "السوق الديناميكي / الإنتاج / العرض / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الإنتاج / العرض / الوزن.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "السوق الديناميكي / الإنتاج / النافذة الزمنية / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الإنتاج / النافذة الزمنية / الدقائق.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "السوق الديناميكي / الجودة / القيمة الوسطية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / القيمة الوسطية.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "السوق الديناميكي / الجودة / الثقة / التأثير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / الثقة / التأثير.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "السوق الديناميكي / الجودة / نطاق القيم",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الجودة / نطاق القيم.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "السوق الديناميكي / الندرة / مكافأة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / مكافأة / الحد الأقصى.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "السوق الديناميكي / إقليمي / عامa40074848905d12c107f984aac5d9776 / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / إقليمي / عامa40074848905d12c107f984aac5d9776 / الوزن.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "السوق الديناميكي / إقليمي / محلي / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / إقليمي / محلي / الوزن.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "السوق الديناميكي / مورد / الأسماء البديلة / مخدر / التغليف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الأسماء البديلة / مخدر / التغليف.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "السوق الديناميكي / مورد / الأسماء البديلة / عبوة وقود",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الأسماء البديلة / عبوة وقود.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "السوق الديناميكي / مورد / الأسماء البديلة / زيت الآلات",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الأسماء البديلة / زيت الآلات.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "السوق الديناميكي / مورد / الأسماء البديلة / مغذيات النباتات",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الأسماء البديلة / مغذيات النباتات.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "السوق الديناميكي / مورد / الأسماء البديلة / طقم إصلاح",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الأسماء البديلة / طقم إصلاح.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "السوق الديناميكي / مورد / الاتجاه / الانخفاض / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الاتجاه / الانخفاض / العتبة.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "السوق الديناميكي / مورد / الاتجاه / الارتفاع / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / مورد / الاتجاه / الارتفاع / العتبة.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 2",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 3",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / فلتر الكربون / المخدرات المرتبطة / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "السوق الديناميكي / الموارد / مادة كيميائية أولية / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / مادة كيميائية أولية / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "السوق الديناميكي / الموارد / مادة كيميائية أولية / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / مادة كيميائية أولية / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "السوق الديناميكي / الموارد / مادة كيميائية أولية / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / مادة كيميائية أولية / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "السوق الديناميكي / الموارد / مادة كيميائية أولية / المخدرات المرتبطة / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / مادة كيميائية أولية / المخدرات المرتبطة / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "السوق الديناميكي / الموارد / مادة كيميائية أولية / المخدرات المرتبطة / 2",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / مادة كيميائية أولية / المخدرات المرتبطة / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "السوق الديناميكي / الموارد / قطع معدات / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / قطع معدات / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "السوق الديناميكي / الموارد / قطع معدات / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / قطع معدات / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "السوق الديناميكي / الموارد / قطع معدات / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / قطع معدات / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "السوق الديناميكي / الموارد / السماد / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / السماد / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "السوق الديناميكي / الموارد / السماد / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / السماد / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "السوق الديناميكي / الموارد / السماد / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / السماد / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "السوق الديناميكي / الموارد / السماد / المخدرات المرتبطة / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / السماد / المخدرات المرتبطة / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "السوق الديناميكي / الموارد / وقود المختبر / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / وقود المختبر / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "السوق الديناميكي / الموارد / وقود المختبر / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / وقود المختبر / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "السوق الديناميكي / الموارد / وقود المختبر / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / وقود المختبر / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "السوق الديناميكي / الموارد / كيس تغليف / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / كيس تغليف / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "السوق الديناميكي / الموارد / كيس تغليف / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / كيس تغليف / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "السوق الديناميكي / الموارد / كيس تغليف / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / كيس تغليف / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "السوق الديناميكي / الموارد / أصيص زرع / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / أصيص زرع / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "السوق الديناميكي / الموارد / أصيص زرع / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / أصيص زرع / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "السوق الديناميكي / الموارد / أصيص زرع / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / أصيص زرع / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "السوق الديناميكي / الموارد / أصيص زرع / المخدرات المرتبطة / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / أصيص زرع / المخدرات المرتبطة / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "السوق الديناميكي / الموارد / بذرة القنب / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / بذرة القنب / السعر الأساسي.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "السوق الديناميكي / الموارد / بذرة القنب / المرونة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / بذرة القنب / المرونة.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "السوق الديناميكي / الموارد / بذرة القنب / التسمية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / بذرة القنب / التسمية.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "السوق الديناميكي / الموارد / بذرة القنب / المخدرات المرتبطة / 1",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الموارد / بذرة القنب / المخدرات المرتبطة / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "السوق الديناميكي / المبيعات / النافذة الزمنية / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / المبيعات / النافذة الزمنية / الدقائق.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "السوق الديناميكي / التشبع / الطلب / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التشبع / الطلب / الوزن.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "السوق الديناميكي / التشبع / السعر / التأثير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التشبع / السعر / التأثير.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "السوق الديناميكي / الندرة / الطلب / الوزن",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / الطلب / الوزن.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "السوق الديناميكي / الندرة / السعر / التأثير",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الندرة / السعر / التأثير.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "السوق الديناميكي / الفصل / النهاية / الأشهر / ديسمبر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / النهاية / الأشهر / ديسمبر.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "السوق الديناميكي / الفصل / النهاية / الأشهر / الربيع",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / النهاية / الأشهر / الربيع.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "السوق الديناميكي / الفصل / النهاية / الأشهر / الصيف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / النهاية / الأشهر / الصيف.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "السوق الديناميكي / الفصل / النهاية / الأشهر / الشتاء",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / النهاية / الأشهر / الشتاء.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "السوق الديناميكي / الفصل / المضاعفات / الخريف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / المضاعفات / الخريف.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "السوق الديناميكي / الفصل / المضاعفات / الربيع",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / المضاعفات / الربيع.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "السوق الديناميكي / الفصل / المضاعفات / الصيف",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / المضاعفات / الصيف.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "السوق الديناميكي / الفصل / المضاعفات / الشتاء",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الفصل / المضاعفات / الشتاء.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "السوق الديناميكي / النقص / الإشاعة / العتبة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / النقص / الإشاعة / العتبة.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "السوق الديناميكي / الحالة / العتبات / طلب مرتفع",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحالة / العتبات / طلب مرتفع.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "السوق الديناميكي / الحالة / العتبات / مطلوب",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحالة / العتبات / مطلوب.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "السوق الديناميكي / الحالة / العتبات / طلب منخفض",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحالة / العتبات / طلب منخفض.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "السوق الديناميكي / الحالة / العتبات / مشبع",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الحالة / العتبات / مشبع.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "السوق الديناميكي / هدف / العرض",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / هدف / العرض.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "السوق الديناميكي / الاتجاه / فرصة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / فرصة.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "السوق الديناميكي / الاتجاه / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / المدة / الدقائق.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "السوق الديناميكي / الاتجاه / الحد الأقصى / القوة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / الحد الأقصى / القوة.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "السوق الديناميكي / الاتجاه / الحد الأدنى / القوة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الاتجاه / الحد الأدنى / القوة.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "السوق الديناميكي / التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / التحديث / الدقائق.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "السوق الديناميكي / تقلب الأسعار / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / تقلب الأسعار / الحد الأقصى.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "السوق الديناميكي / تقلب الأسعار / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / تقلب الأسعار / الحد الأدنى.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "السوق الديناميكي / الطقس / المضاعفات / البرد",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / المضاعفات / البرد.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "السوق الديناميكي / الطقس / المضاعفات / موجة الحر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / المضاعفات / موجة الحر.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "السوق الديناميكي / الطقس / المضاعفات / عادي",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / المضاعفات / عادي.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "السوق الديناميكي / الطقس / المضاعفات / المطر",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / المضاعفات / المطر.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "السوق الديناميكي / الطقس / المضاعفات / العاصفة",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / المضاعفات / العاصفة.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "السوق الديناميكي / الطقس / الولاية",
                    description = "إعداد التشغيل الخاص بـ السوق الديناميكي / الطقس / الولاية.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "اهتمام الشرطة والمخاطر / فترة انتظار الإجراء / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / فترة انتظار الإجراء / ثوانٍ.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الكمية",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الكمية.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / المدة / الدقائق.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الضغط الشرطي",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الضغط الشرطي.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / السمعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / السمعة.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الأمان",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / النشاط / مخاطرة / الأوزان / الأمان.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / أسلوب العمل العدواني / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / أسلوب العمل العدواني / الضغط الأمني / المضاعف.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "اهتمام الشرطة والمخاطر / الهاتف المؤقت / انكشاف الهوية / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الهاتف المؤقت / انكشاف الهوية / العتبة.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "اهتمام الشرطة والمخاطر / الهاتف المؤقت / الضغط الأمني / لكل صفقة جملة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الهاتف المؤقت / الضغط الأمني / لكل صفقة جملة.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "اهتمام الشرطة والمخاطر / هاتف مخصص للاستخدام لمرة واحدة / العنصر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / هاتف مخصص للاستخدام لمرة واحدة / العنصر.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / المضاعف.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية قيد التشغيل / الضغط الأمني / العتبة.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "اهتمام الشرطة والمخاطر / المركبة السكنية المتوقفة / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المركبة السكنية المتوقفة / الضغط الأمني.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / التلوث / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التلوث / الضغط الأمني / المضاعف.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "اهتمام الشرطة والمخاطر / التلوث / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التلوث / العتبة.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "اهتمام الشرطة والمخاطر / الزراعة / نباتات دون مخاطر إضافية",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الزراعة / نباتات دون مخاطر إضافية.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "اهتمام الشرطة والمخاطر / الزراعة / الضغط الأمني / لكل نبات",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الزراعة / الضغط الأمني / لكل نبات.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "اهتمام الشرطة والمخاطر / تاجر / مخفي / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / تاجر / مخفي / الدقائق.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / دفعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / دفعة.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / عربة التخييم",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / عربة التخييم.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / تاجر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / تاجر.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / الفصيل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / الفصيل.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / مركز التوزيع",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / مركز التوزيع.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / مختبر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / مختبر.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / اللاعب",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / اللاعب.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / المسار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / المسار.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / منطقة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الاضمحلال / لكل دورة تحديث / منطقة.",
                },
                drugAdvancedHeatEnabled = {
                    label = "اهتمام الشرطة والمخاطر / مفعّل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مفعّل.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / حرجة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / حرجة.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / عالية",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / عالية.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / منخفضة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / منخفضة.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / متوسطة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / الضغط الأمني / متوسطة.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / دفعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / دفعة.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / الفصيل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / الفصيل.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / منطقة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواجد الأمني / المضاعفات / منطقة.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / دفعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / دفعة.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / عربة التخييم",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / عربة التخييم.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / تاجر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / تاجر.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / الفصيل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / الفصيل.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / مركز التوزيع",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / مركز التوزيع.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / مختبر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / مختبر.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / اللاعب",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / اللاعب.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / المسار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / المسار.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / منطقة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / كائن اللعبة / الأنواع / منطقة.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "اهتمام الشرطة والمخاطر / الحدث / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحدث / دقائق فترة الانتظار.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "اهتمام الشرطة والمخاطر / الحدث / حد السجل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحدث / حد السجل.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "اهتمام الشرطة والمخاطر / مختبر / الضغط الأمني / المزامنة / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مختبر / الضغط الأمني / المزامنة / العتبة.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "اهتمام الشرطة والمخاطر / التواري عن الأنظار / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / دقائق فترة الانتظار.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "اهتمام الشرطة والمخاطر / التواري عن الأنظار / خاملاً / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / خاملاً / الدقائق.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "اهتمام الشرطة والمخاطر / التواري عن الأنظار / التخفيض",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / التواري عن الأنظار / التخفيض.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "اهتمام الشرطة والمخاطر / إغلاق تام / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / إغلاق تام / الدقائق.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "اهتمام الشرطة والمخاطر / الحد الأدنى / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / المدة / الدقائق.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "اهتمام الشرطة والمخاطر / الحد الأدنى / الحدث / فترة الانتظار (بالثواني)",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / الحدث / فترة الانتظار (بالثواني).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "اهتمام الشرطة والمخاطر / الحد الأدنى / خاملاً / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / الحد الأدنى / خاملاً / ثوانٍ.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / المعالجة / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المعالجة / الضغط الأمني / المضاعف.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / دفعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / دفعة.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / عربة التخييم",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / عربة التخييم.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / تاجر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / تاجر.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / الفصيل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / الفصيل.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / مركز التوزيع",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / مركز التوزيع.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / مختبر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / مختبر.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / اللاعب",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / اللاعب.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / المسار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / المسار.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / منطقة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / مخاطرة / الأوزان / منطقة.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "اهتمام الشرطة والمخاطر / تغيير الهاتف المؤقت / التخفيض",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / تغيير الهاتف المؤقت / التخفيض.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "اهتمام الشرطة والمخاطر / المسار / التحكم / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / المسار / التحكم / الدقائق.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / دفعة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / دفعة.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / عربة التخييم",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / عربة التخييم.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / تاجر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / تاجر.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / الفصيل",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / الفصيل.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / مركز التوزيع",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / مركز التوزيع.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / مختبر",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / مختبر.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / اللاعب",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / اللاعب.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / المسار",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / المسار.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / منطقة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / البيع / الضغط الأمني / منطقة.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "اهتمام الشرطة والمخاطر / العتبات / حرجة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / العتبات / حرجة.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "اهتمام الشرطة والمخاطر / العتبات / عالية",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / العتبات / عالية.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "اهتمام الشرطة والمخاطر / العتبات / إغلاق تام",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / العتبات / إغلاق تام.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "اهتمام الشرطة والمخاطر / العتبات / منخفضة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / العتبات / منخفضة.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "اهتمام الشرطة والمخاطر / العتبات / متوسطة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / العتبات / متوسطة.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "اهتمام الشرطة والمخاطر / دورة التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / دورة التحديث / الدقائق.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / بيع الجملة / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / بيع الجملة / الضغط الأمني / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / نطاق التنبيه",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / نطاق التنبيه.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القيمة الأساسية / فرصة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القيمة الأساسية / فرصة.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الفصيل / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الفصيل / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / عالية / الخطورة / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / عالية / الخطورة / العتبة.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / فرصة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / فرصة / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الولاء / العتبة.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأقصى / فرصة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأقصى / فرصة.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأدنى / فترة الانتظار (بالثواني)",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الحد الأدنى / فترة الانتظار (بالثواني).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / المسار / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / المسار / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأقصى.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / الحد الأدنى.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / القوة / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / فرصة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / فرصة / المضاعف.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / العتبة",
                    description = "إعداد التشغيل الخاص بـ اهتمام الشرطة والمخاطر / عامل / تسريب المعلومات / الإجهاد / العتبة.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "شبكة الاتصالات / فترة انتظار الإجراء / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / فترة انتظار الإجراء / ثوانٍ.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "شبكة الاتصالات / عدد النقاط النشطة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عدد النقاط النشطة.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "شبكة الاتصالات / تلميح الهاتف المؤقت / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تلميح الهاتف المؤقت / الثقة.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأقصى / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأقصى / المضاعف.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأدنى / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الهاتف المؤقت / العرض / الحد الأدنى / المضاعف.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "شبكة الاتصالات / مشتري / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / دقائق فترة الانتظار.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "شبكة الاتصالات / مشتري / مسافة التسليم",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / مسافة التسليم.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "شبكة الاتصالات / مشتري / ممتاز / النجاح / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / ممتاز / النجاح / النتيجة.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "شبكة الاتصالات / مشتري / ممتاز / الثقة / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / ممتاز / الثقة / عائد.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "شبكة الاتصالات / مشتري / الطلب / الملاحقة والمخاطر / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / الطلب / الملاحقة والمخاطر / الوزن.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "شبكة الاتصالات / مشتري / قياسي / الثقة / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مشتري / قياسي / الثقة / عائد.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "شبكة الاتصالات / مهلة تفعيل جهة الاتصال / ثوانٍ / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مهلة تفعيل جهة الاتصال / ثوانٍ / الحد الأقصى.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "شبكة الاتصالات / مهلة تفعيل جهة الاتصال / ثوانٍ / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مهلة تفعيل جهة الاتصال / ثوانٍ / الحد الأدنى.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "شبكة الاتصالات / جهة الاتصال / الطلب / نطاق القيم / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / جهة الاتصال / الطلب / نطاق القيم / الحد الأقصى.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "شبكة الاتصالات / جهة الاتصال / الطلب / نطاق القيم / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / جهة الاتصال / الطلب / نطاق القيم / الحد الأدنى.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "شبكة الاتصالات / جهة الاتصال / الخسارة / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / جهة الاتصال / الخسارة / الثقة.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "شبكة الاتصالات / الشبكة المظلمة / معلومات دقيقة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / معلومات دقيقة / الدقائق.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "شبكة الاتصالات / الشبكة المظلمة / المنطقة النشطة / المعلومات / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / المنطقة النشطة / المعلومات / السعر.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "شبكة الاتصالات / الشبكة المظلمة / المعلومات / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشبكة المظلمة / المعلومات / السعر.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "شبكة الاتصالات / تاجر / السعر الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / السعر الأساسي.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / السعة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / السعة / الحد الأقصى.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / السعة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / السعة / الحد الأدنى.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / مخاطرة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / مخاطرة / الحد الأقصى.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / مخاطرة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / مخاطرة / الحد الأدنى.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / مهارة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / مهارة / الحد الأقصى.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "شبكة الاتصالات / تاجر / التوظيف / مهارة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / التوظيف / مهارة / الحد الأدنى.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "شبكة الاتصالات / عروض الموزعين / 1 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "شبكة الاتصالات / عروض الموزعين / 1 / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 1 / العنصر.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "شبكة الاتصالات / عروض الموزعين / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 1 / التسمية.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "شبكة الاتصالات / عروض الموزعين / 1 / الحد الأدنى للثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 1 / الحد الأدنى للثقة.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "شبكة الاتصالات / عروض الموزعين / 1 / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 1 / السعر.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "شبكة الاتصالات / عروض الموزعين / 2 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "شبكة الاتصالات / عروض الموزعين / 2 / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 2 / العنصر.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "شبكة الاتصالات / عروض الموزعين / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 2 / التسمية.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "شبكة الاتصالات / عروض الموزعين / 2 / الحد الأدنى للثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 2 / الحد الأدنى للثقة.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "شبكة الاتصالات / عروض الموزعين / 2 / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 2 / السعر.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "شبكة الاتصالات / عروض الموزعين / 3 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "شبكة الاتصالات / عروض الموزعين / 3 / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 3 / العنصر.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "شبكة الاتصالات / عروض الموزعين / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 3 / التسمية.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "شبكة الاتصالات / عروض الموزعين / 3 / الحد الأدنى للثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 3 / الحد الأدنى للثقة.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "شبكة الاتصالات / عروض الموزعين / 3 / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 3 / السعر.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "شبكة الاتصالات / عروض الموزعين / 4 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "شبكة الاتصالات / عروض الموزعين / 4 / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 4 / العنصر.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "شبكة الاتصالات / عروض الموزعين / 4 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 4 / التسمية.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "شبكة الاتصالات / عروض الموزعين / 4 / الحد الأدنى للثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 4 / الحد الأدنى للثقة.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "شبكة الاتصالات / عروض الموزعين / 4 / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 4 / السعر.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "شبكة الاتصالات / عروض الموزعين / 5 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "شبكة الاتصالات / عروض الموزعين / 5 / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 5 / العنصر.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "شبكة الاتصالات / عروض الموزعين / 5 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 5 / التسمية.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "شبكة الاتصالات / عروض الموزعين / 5 / الحد الأدنى للثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 5 / الحد الأدنى للثقة.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "شبكة الاتصالات / عروض الموزعين / 5 / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / عروض الموزعين / 5 / السعر.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "شبكة الاتصالات / تاجر / الحماية / الساعات",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الحماية / الساعات.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "شبكة الاتصالات / تاجر / الحماية / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الحماية / السعر.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "شبكة الاتصالات / تاجر / البيع / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / البيع / الحد الأقصى.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "شبكة الاتصالات / تاجر / البيع / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / البيع / الحد الأدنى.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / أسلوب العمل العدواني / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / أسلوب العمل العدواني / مضاعف السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الجودة الأساسية / عامل السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الجودة الأساسية / عامل السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / كمية كبيرة / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / كمية كبيرة / مضاعف السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / المبيعات الرخيصة / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / المبيعات الرخيصة / مضاعف السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / القيمة الافتراضية / الجودة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / القيمة الافتراضية / الجودة.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / عتبة عدم الولاء",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / عتبة عدم الولاء.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الخبرة / لكل مستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الخبرة / لكل مستوى.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الخبرة / لكل وحدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الخبرة / لكل وحدة.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الحادث / الولاء / الخسارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الحادث / الولاء / الخسارة.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الحادث / الفحص العشوائي / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الحادث / الفحص العشوائي / الحد الأقصى.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / المستوى / السعر / مكافأة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / المستوى / السعر / مكافأة.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / المستوى / البيع / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / المستوى / البيع / المقسوم عليه.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الولاء / مخاطرة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الولاء / مخاطرة / الوزن.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الحد الأقصى / الحادث / فرصة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الحد الأقصى / الحادث / فرصة.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الحد الأقصى / المستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الحد الأقصى / المستوى.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / ممتاز / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / ممتاز / مضاعف السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الملف الشخصي / مخاطرة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الملف الشخصي / مخاطرة / الوزن.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الحماية / مخاطرة / التخفيض",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الحماية / مخاطرة / التخفيض.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / الجودة / السعر / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / الجودة / السعر / المقسوم عليه.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / التعافي / القيمة الأساسية / فرصة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / التعافي / القيمة الأساسية / فرصة.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / التعافي / الولاء / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / التعافي / الولاء / الوزن.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / خسارة المخزون بسبب السرقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / خسارة المخزون بسبب السرقة.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / مهارة / مخاطرة / التخفيض",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / مهارة / مخاطرة / التخفيض.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / مهارة / البيع / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / مهارة / البيع / المقسوم عليه.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / عتبة الولاء المستقر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / عتبة الولاء المستقر.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / المنطقة / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / المنطقة / مضاعف السعر.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "شبكة الاتصالات / تاجر / محاكاة / المنطقة / مخاطرة / التخفيض",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / محاكاة / المنطقة / مخاطرة / التخفيض.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "شبكة الاتصالات / تاجر / دورة التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / دورة التحديث / الدقائق.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "شبكة الاتصالات / تاجر / الأجر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "شبكة الاتصالات / تاجر / الأجر / الاضمحلال",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر / الاضمحلال.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "شبكة الاتصالات / تاجر / الأجر / الولاء / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / الأجر / الولاء / عائد.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "شبكة الاتصالات / تاجر / نقاط الضعف / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / نقاط الضعف / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "شبكة الاتصالات / تاجر / نقاط الضعف / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / نقاط الضعف / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "شبكة الاتصالات / تاجر / نقاط الضعف / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / نقاط الضعف / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "شبكة الاتصالات / تاجر / نقاط الضعف / 4",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / نقاط الضعف / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "شبكة الاتصالات / تاجر / نقاط الضعف / 5",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / تاجر / نقاط الضعف / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / الطلب.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / جهة الاتصال / مخاطرة.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "شبكة الاتصالات / التاجر الافتراضي / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / السعة.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "شبكة الاتصالات / التاجر الافتراضي / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / مخاطرة.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "شبكة الاتصالات / التاجر الافتراضي / مهارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التاجر الافتراضي / مهارة.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "شبكة الاتصالات / القيمة الافتراضية / المنطقة النشطة / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة الافتراضية / المنطقة النشطة / نصف القطر.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "شبكة الاتصالات / إعادة تعيين الطلب (بالدقائق)",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / إعادة تعيين الطلب (بالدقائق).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "شبكة الاتصالات / مفعّل",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / مفعّل.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "شبكة الاتصالات / الموقع الدقيق / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع الدقيق / الثقة.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "شبكة الاتصالات / الفصيل / الاكتشاف / السمعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الفصيل / الاكتشاف / السمعة.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "شبكة الاتصالات / الفصيل / التلميح / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الفصيل / التلميح / الثقة.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "شبكة الاتصالات / التسليم الفاشل / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التسليم الفاشل / دقائق فترة الانتظار.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / العدد",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / العدد.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / المهاجم / النماذج / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / المدة (بالثواني)",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / المدة (بالثواني).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / الشرطة / النماذج / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "شبكة الاتصالات / صفقة وهمية / المواجهة / نطاق الظهور",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / صفقة وهمية / المواجهة / نطاق الظهور.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "شبكة الاتصالات / القيمة البديلة / المخدر المفضل",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة البديلة / المخدر المفضل.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "شبكة الاتصالات / القيمة البديلة / تسمية المنتج",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / القيمة البديلة / تسمية المنتج.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "شبكة الاتصالات / الدليل / الكتاب / العنصر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الدليل / الكتاب / العنصر.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "شبكة الاتصالات / الدليل / الكتاب / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الدليل / الكتاب / الثقة.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "شبكة الاتصالات / توظيف موزع / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / توظيف موزع / السعر.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "شبكة الاتصالات / حد السجل",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / حد السجل.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "شبكة الاتصالات / المنطقة النشطة / المعلومات / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة النشطة / المعلومات / الدقائق.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "شبكة الاتصالات / المنطقة النشطة / التدوير / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة النشطة / التدوير / الدقائق.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "شبكة الاتصالات / الإعلان / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الإعلان / المدة / الدقائق.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "شبكة الاتصالات / الحد الأقصى / مملوكة / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأقصى / مملوكة / التجار.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "شبكة الاتصالات / الحد الأدنى / مشتري / مسافة التسليم",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / مشتري / مسافة التسليم.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "شبكة الاتصالات / الحد الأدنى / تناوب الاتصال (بالدقائق)",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / تناوب الاتصال (بالدقائق).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "شبكة الاتصالات / الحد الأدنى / إعادة تعيين الطلب (بالدقائق)",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / إعادة تعيين الطلب (بالدقائق).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "شبكة الاتصالات / الحد الأدنى / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / المعلومات / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / المعلومات / الدقائق.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / نصف القطر.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / التدوير / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / المنطقة النشطة / التدوير / الدقائق.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "شبكة الاتصالات / الحد الأدنى / الإعلان / المدة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الإعلان / المدة / الدقائق.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "شبكة الاتصالات / الحد الأدنى للمكافأة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى للمكافأة / المضاعف.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "شبكة الاتصالات / الحد الأدنى / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "شبكة الاتصالات / الحد الأدنى / الموقع / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الحد الأدنى / الموقع / مضاعف السعر.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "شبكة الاتصالات / غير ذلك / مخدر / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / غير ذلك / مخدر / مضاعف السعر.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "شبكة الاتصالات / حساب الدفع",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / حساب الدفع.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "شبكة الاتصالات / بعد التسليم / الطلب / Reset / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / بعد التسليم / الطلب / Reset / ثوانٍ.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "شبكة الاتصالات / المخدر المفضل / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المخدر المفضل / مضاعف السعر.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "شبكة الاتصالات / المنطقة / الموقع / الثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / المنطقة / الموقع / الثقة.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "شبكة الاتصالات / الطلب / الكميات / كمية كبيرة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / كمية كبيرة / الحد الأقصى.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "شبكة الاتصالات / الطلب / الكميات / كمية كبيرة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / كمية كبيرة / الحد الأدنى.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "شبكة الاتصالات / الطلب / الكميات / ممتاز / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / ممتاز / الحد الأقصى.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "شبكة الاتصالات / الطلب / الكميات / ممتاز / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / ممتاز / الحد الأدنى.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "شبكة الاتصالات / الطلب / الكميات / قياسي / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / قياسي / الحد الأقصى.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "شبكة الاتصالات / الطلب / الكميات / قياسي / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الطلب / الكميات / قياسي / الحد الأدنى.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "شبكة الاتصالات / التدوير / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / التدوير / الدقائق.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشارع / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / المشتري الافتراضي / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / التاجر الافتراضي / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / تاجر الشبكة / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / وسيط ممتاز / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 1 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 2 / مخاطرة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / W",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / الإحداثيات / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / التسمية.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الموقع / مجموعات الاختيار / جهة اتصال بالجملة / 3 / مخاطرة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مكافأة القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مكافأة القبول.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / النمط الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / النمط الأساسي.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مكافأة الطلب.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / التسمية.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 4",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المخدرات المفضلة / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / نصف القطر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / المنطقة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 1 / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 1 / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مكافأة القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مكافأة القبول.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / النمط الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / النمط الأساسي.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مكافأة الطلب.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / التسمية.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الحد الأدنى للجودة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / الحد الأدنى للجودة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المخدرات المفضلة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المخدرات المفضلة / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المخدرات المفضلة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المخدرات المفضلة / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / نصف القطر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / المنطقة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 2 / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 2 / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مكافأة القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مكافأة القبول.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / النمط الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / النمط الأساسي.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مكافأة الطلب.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / التسمية.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المخدرات المفضلة / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / نصف القطر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / المنطقة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 3 / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 3 / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مكافأة القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مكافأة القبول.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / النمط الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / النمط الأساسي.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مكافأة الطلب.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / التسمية.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المخدرات المفضلة / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / نصف القطر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / المنطقة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 4 / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 4 / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مكافأة القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مكافأة القبول.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / النمط الأساسي",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / النمط الأساسي.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الإحداثيات / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مكافأة الطلب",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مكافأة الطلب.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الضغط الأمني / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / الضغط الأمني / المضاعف.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / التسمية.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المخدرات المفضلة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المخدرات المفضلة / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المخدرات المفضلة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المخدرات المفضلة / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مضاعف السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / مضاعف السعر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / نصف القطر",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / نصف القطر.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / المنطقة.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "شبكة الاتصالات / الشارع / المناطق النشطة / 5 / السطو / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الشارع / المناطق النشطة / 5 / السطو / المضاعف.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "شبكة الاتصالات / الثقة / المستويات / معروف",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الثقة / المستويات / معروف.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "شبكة الاتصالات / الثقة / المستويات / موثوق",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الثقة / المستويات / موثوق.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "شبكة الاتصالات / الثقة / المستويات / جدير بالثقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الاتصالات / الثقة / المستويات / جدير بالثقة.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "شبكة الأعمال / فترة انتظار الإجراء / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / فترة انتظار الإجراء / ثوانٍ.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "شبكة الأعمال / الرصيد / القيمة الأساسية / سعر الوحدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / القيمة الأساسية / سعر الوحدة.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "شبكة الأعمال / الرصيد / حرارة الشبكة / لكل تاجر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / حرارة الشبكة / لكل تاجر.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "شبكة الأعمال / الرصيد / حرارة الشبكة / لكل مركز توزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / حرارة الشبكة / لكل مركز توزيع.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "شبكة الأعمال / الرصيد / حرارة الشبكة / لكل مسار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / حرارة الشبكة / لكل مسار.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "شبكة الأعمال / الرصيد / حرارة الشبكة / لكل موظف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / حرارة الشبكة / لكل موظف.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "شبكة الأعمال / الرصيد / الموثوقية / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / الموثوقية / عائد.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "شبكة الأعمال / الرصيد / الموثوقية / الخسارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / الموثوقية / الخسارة.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "شبكة الأعمال / الرصيد / المسار / الضغط الأمني / الاضمحلال",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرصيد / المسار / الضغط الأمني / الاضمحلال.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / عصابة / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / عصابة / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / شبكة الـ NPC / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / المنظمة / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / المنظمة / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / ممتاز / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / ممتاز / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / موزع / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / موزع / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / خاص / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / خاص / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / الكمية / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / الكمية / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / الكمية / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / الكمية / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / الحد الأدنى / الرتبة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / الحد الأدنى / الرتبة.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / الجودة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / الجودة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / الجودة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / الجودة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / المكافأة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / المكافأة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / المكافأة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / المكافأة / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / مخاطرة / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / مخاطرة / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "شبكة الأعمال / العقود / الفئات / بيع الجملة / مخاطرة / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / الفئات / بيع الجملة / مخاطرة / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "شبكة الأعمال / العقود / مسافة التسليم",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / مسافة التسليم.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "شبكة الأعمال / العقود / المدة / الدقائق / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / المدة / الدقائق / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "شبكة الأعمال / العقود / المدة / الدقائق / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / المدة / الدقائق / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / الإحداثيات / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / التسمية.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / المنطقة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / المكافأة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / المكافأة / المضاعف.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 1 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 1 / مخاطرة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / الإحداثيات / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / التسمية.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / المنطقة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / المكافأة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / المكافأة / المضاعف.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 2 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 2 / مخاطرة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / الإحداثيات / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / التسمية.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / المنطقة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / المكافأة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / المكافأة / المضاعف.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 3 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 3 / مخاطرة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / X",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / Y",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / Z",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / الإحداثيات / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / التسمية.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / المنطقة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / المنطقة.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / المكافأة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / المكافأة / المضاعف.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "شبكة الأعمال / العقود / اللقاء / النقاط / 4 / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / اللقاء / النقاط / 4 / مخاطرة.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الدفعة المقدمة / الخيارات / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "شبكة الأعمال / العقود / التفاوض / الكمية / هامش التفاوض / النسبة المئوية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الكمية / هامش التفاوض / النسبة المئوية.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "شبكة الأعمال / العقود / التفاوض / القيمة الأساسية / القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / القيمة الأساسية / القبول.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "شبكة الأعمال / العقود / التفاوض / الموعد النهائي / هامش التفاوض / النسبة المئوية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الموعد النهائي / هامش التفاوض / النسبة المئوية.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "شبكة الأعمال / العقود / التفاوض / الحد الأقصى / الجولات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الحد الأقصى / الجولات.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "شبكة الأعمال / العقود / التفاوض / الجودة / هامش التفاوض",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الجودة / هامش التفاوض.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "شبكة الأعمال / العقود / التفاوض / الرفض / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / الرفض / دقائق فترة الانتظار.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "شبكة الأعمال / العقود / التفاوض / جولة / الضغط",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التفاوض / جولة / الضغط.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "شبكة الأعمال / العقود / العرض / العدد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / العرض / العدد.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "شبكة الأعمال / العقود / التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / العقود / التحديث / الدقائق.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "شبكة الأعمال / القيمة الافتراضية / اسم العمل التجاري",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / اسم العمل التجاري.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "شبكة الأعمال / القيمة الافتراضية / الرتبة / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / الرتبة / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "شبكة الأعمال / القيمة الافتراضية / موظفون / أسلوب العمل",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / موظفون / أسلوب العمل.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "شبكة الأعمال / القيمة الافتراضية / نقل",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / القيمة الافتراضية / نقل.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "شبكة الأعمال / مفعّل",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مفعّل.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "شبكة الأعمال / مراكز التوزيع / مركز التوزيع / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / مركز التوزيع / السعة.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "شبكة الأعمال / مراكز التوزيع / مركز التوزيع / سعر الشراء",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / مركز التوزيع / سعر الشراء.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "شبكة الأعمال / مراكز التوزيع / مركز التوزيع / الأمان",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / مركز التوزيع / الأمان.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "شبكة الأعمال / مراكز التوزيع / مركز التوزيع / الصيانة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / مركز التوزيع / الصيانة.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "شبكة الأعمال / مراكز التوزيع / المخبأ / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المخبأ / السعة.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "شبكة الأعمال / مراكز التوزيع / المخبأ / سعر الشراء",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المخبأ / سعر الشراء.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "شبكة الأعمال / مراكز التوزيع / المخبأ / الأمان",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المخبأ / الأمان.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "شبكة الأعمال / مراكز التوزيع / المخبأ / الصيانة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المخبأ / الصيانة.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "شبكة الأعمال / مراكز التوزيع / المستودع / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المستودع / السعة.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "شبكة الأعمال / مراكز التوزيع / المستودع / سعر الشراء",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المستودع / سعر الشراء.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "شبكة الأعمال / مراكز التوزيع / المستودع / الأمان",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المستودع / الأمان.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "شبكة الأعمال / مراكز التوزيع / المستودع / الصيانة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / مراكز التوزيع / المستودع / الصيانة.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "شبكة الأعمال / الحدود / العقود النشطة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الحدود / العقود النشطة.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "شبكة الأعمال / الحدود / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الحدود / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "شبكة الأعمال / الحدود / دفتر الحسابات / الصفوف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الحدود / دفتر الحسابات / الصفوف.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "شبكة الأعمال / الحدود / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الحدود / المسارات.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "شبكة الأعمال / الحدود / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الحدود / موظفون.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "شبكة الأعمال / المستحقات / الحساب",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المستحقات / الحساب.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "شبكة الأعمال / الرتب / 1 / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / العقود.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "شبكة الأعمال / الرتب / 1 / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / التجار.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "شبكة الأعمال / الرتب / 1 / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "شبكة الأعمال / الرتب / 1 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "شبكة الأعمال / الرتب / 1 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / التسمية.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "شبكة الأعمال / الرتب / 1 / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / المسارات.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "شبكة الأعمال / الرتب / 1 / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / النتيجة.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "شبكة الأعمال / الرتب / 1 / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 1 / موظفون.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "شبكة الأعمال / الرتب / 2 / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / العقود.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "شبكة الأعمال / الرتب / 2 / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / التجار.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "شبكة الأعمال / الرتب / 2 / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "شبكة الأعمال / الرتب / 2 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "شبكة الأعمال / الرتب / 2 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / التسمية.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "شبكة الأعمال / الرتب / 2 / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / المسارات.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "شبكة الأعمال / الرتب / 2 / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / النتيجة.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "شبكة الأعمال / الرتب / 2 / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 2 / موظفون.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "شبكة الأعمال / الرتب / 3 / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / العقود.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "شبكة الأعمال / الرتب / 3 / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / التجار.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "شبكة الأعمال / الرتب / 3 / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "شبكة الأعمال / الرتب / 3 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "شبكة الأعمال / الرتب / 3 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / التسمية.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "شبكة الأعمال / الرتب / 3 / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / المسارات.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "شبكة الأعمال / الرتب / 3 / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / النتيجة.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "شبكة الأعمال / الرتب / 3 / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 3 / موظفون.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "شبكة الأعمال / الرتب / 4 / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / العقود.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "شبكة الأعمال / الرتب / 4 / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / التجار.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "شبكة الأعمال / الرتب / 4 / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "شبكة الأعمال / الرتب / 4 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "شبكة الأعمال / الرتب / 4 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / التسمية.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "شبكة الأعمال / الرتب / 4 / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / المسارات.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "شبكة الأعمال / الرتب / 4 / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / النتيجة.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "شبكة الأعمال / الرتب / 4 / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 4 / موظفون.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "شبكة الأعمال / الرتب / 5 / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / العقود.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "شبكة الأعمال / الرتب / 5 / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / التجار.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "شبكة الأعمال / الرتب / 5 / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "شبكة الأعمال / الرتب / 5 / ID",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "شبكة الأعمال / الرتب / 5 / التسمية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / التسمية.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "شبكة الأعمال / الرتب / 5 / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / المسارات.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "شبكة الأعمال / الرتب / 5 / النتيجة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / النتيجة.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "شبكة الأعمال / الرتب / 5 / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / الرتب / 5 / موظفون.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "شبكة الأعمال / فترة التقرير / أيام",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / فترة التقرير / أيام.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مشتري",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مشتري.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / العقد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / العقد.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / تاجر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / تاجر.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / عصابة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / عصابة.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مركز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مركز التوزيع.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مختبر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / مختبر.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / المنظمة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / المنظمة.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "شبكة الأعمال / المسار / نقطة النهاية / الأنواع / موزع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المسار / نقطة النهاية / الأنواع / موزع.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الوتيرة / الدقائق / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الوتيرة / الدقائق / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الوتيرة / الدقائق / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الوتيرة / الدقائق / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / فترة الانتظار / الحد الأدنى / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / فترة الانتظار / الحد الأدنى / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الفشل / الموثوقية / الخسارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الفشل / الموثوقية / الخسارة.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الحد الأدنى / الوتيرة / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الحد الأدنى / الوتيرة / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الحد الأدنى / اللقاء / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الحد الأدنى / اللقاء / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / غرامة العقد / النمو",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / غرامة العقد / النمو.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / غرامة العقد / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / غرامة العقد / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / الفشل / دقائق فترة الانتظار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / الفشل / دقائق فترة الانتظار.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / السعر / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / السعر / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / السعر / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الجودة / السعر / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / الجودة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / الموثوقية / الخسارة / الجودة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / السمعة / الجودة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / السمعة / الجودة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / مخاطرة / الأوزان / الفئة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / مخاطرة / الأوزان / الفئة.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / العقد / مخاطرة / الأوزان / اللقاء",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / العقد / مخاطرة / الأوزان / اللقاء.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / مركز التوزيع / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / مركز التوزيع / السعة.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / مركز التوزيع / الأمان",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / مركز التوزيع / الأمان.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / اللقاء / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / اللقاء / مخاطرة.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / الجودة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / الجودة.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / سعة المسار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / سعة المسار.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / المسار / الفاصل الزمني / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / المسار / الفاصل الزمني / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / المسار / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الافتراضية / المسار / مخاطرة.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الضغط الأمني / الاضمحلال",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الضغط الأمني / الاضمحلال.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الحمل / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الحمل / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الهجوم / التعافي / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الهجوم / التعافي / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / التكلفة / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / التكلفة / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / التكلفة / لكل مستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / التكلفة / لكل مستوى.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / الترقية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الأمان / الترقية.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / عدم الدفع / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / عدم الدفع / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / عدم الدفع / الأمان / الخسارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / عدم الدفع / الأمان / الخسارة.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الصيانة / الفاصل الزمني / الساعات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / مركز التوزيع / الصيانة / الفاصل الزمني / الساعات.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / القيمة الأولية / الموثوقية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / القيمة الأولية / الموثوقية.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الحد الأقصى / اسم العمل التجاري / الطول",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الحد الأقصى / اسم العمل التجاري / الطول.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / العقد / التسليم / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / العقد / التسليم / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / مسافة التسليم",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / مسافة التسليم.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / دفتر الحسابات / الصفوف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / دفتر الحسابات / الصفوف.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / المسار / الفاصل الزمني / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الحد الأدنى / المسار / الفاصل الزمني / الدقائق.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الدفعة المقدمة / التكلفة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الدفعة المقدمة / التكلفة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الدفعة المقدمة / السعر / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الدفعة المقدمة / السعر / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / التكلفة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / التكلفة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / هامش التفاوض / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / هامش التفاوض / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / مخاطرة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الكمية / مخاطرة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / عرض مقابل / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / عرض مقابل / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الموعد النهائي / هامش التفاوض / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الموعد النهائي / هامش التفاوض / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الحد الأقصى / القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الحد الأقصى / القبول.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الحد الأدنى / القبول",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الحد الأدنى / القبول.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / المنفعة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / المنفعة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / التكلفة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / التكلفة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / هامش التفاوض / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / هامش التفاوض / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / المكافأة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الجودة / المكافأة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الموثوقية / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الموثوقية / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / السمعة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / السمعة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة المطلوبة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة المطلوبة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة المطلوبة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة المطلوبة / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / التكلفة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / التكلفة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / المكافأة / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / المنفعة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / المنفعة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / مخاطرة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / مخاطرة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / التفاوض / الاستعجال / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / غير ذلك / الفشل / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / غير ذلك / الفشل / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الملاحقة الشخصية / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الملاحقة الشخصية / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الشرطة / الفشل / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الشرطة / الفشل / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / القيمة الأساسية / وحدات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / القيمة الأساسية / وحدات.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / كمية كبيرة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / كمية كبيرة / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / المبيعات الرخيصة / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / المبيعات الرخيصة / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / الخبرة / لكل مستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / الخبرة / لكل مستوى.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / الخبرة / لكل وحدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / الخبرة / لكل وحدة.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / مركز التوزيع / الضغط الأمني / لكل وحدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / مركز التوزيع / الضغط الأمني / لكل وحدة.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / ممتاز / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / ممتاز / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / مهارة / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / مهارة / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موزع / مهارة / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موزع / مهارة / عائد.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / المدة / القيمة الأساسية / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / المدة / القيمة الأساسية / ثوانٍ.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / المدة / لكل وحدة / ثوانٍ",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / المدة / لكل وحدة / ثوانٍ.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 4",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / الأسباب / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / القيمةa40074848905d12c107f984aac5d9776 / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الفشل / القيمةa40074848905d12c107f984aac5d9776 / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / الضغط الأمني / الكمية / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / الضغط الأمني / الكمية / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / تقليل مستوى المطاردة / التكلفة / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / تقليل مستوى المطاردة / التكلفة / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / تقليل مستوى المطاردة / التكلفة / لكل نقطة اهتمام للشرطة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / تقليل مستوى المطاردة / التكلفة / لكل نقطة اهتمام للشرطة.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / الولاء",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / الولاء.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / ناقل / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / ناقل / مخاطرة.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / مهارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / مخاطرة / الأوزان / مهارة.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / تدوير المسار / تقليل مستوى المطاردة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / تدوير المسار / تقليل مستوى المطاردة.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / تدوير المسار / مخاطرة / التخفيض",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / تدوير المسار / مخاطرة / التخفيض.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / الجودة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / الجودة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / الجودة / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / الجودة / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / مخاطرة / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / البيع / مخاطرة / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / المسار / البداية / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / المسار / البداية / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الخبرة / لكل مستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الخبرة / لكل مستوى.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الخبرة / لكل وحدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الخبرة / لكل وحدة.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الفشل / الولاء / الخسارة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / ناقل / الفشل / الولاء / الخسارة.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / ناقل / خطر الفشل / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / ناقل / خطر الفشل / عائد.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / ناقل / مهارة / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / ناقل / مهارة / عائد.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الضغط الأمني",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الضغط الأمني.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الموثوقية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الموثوقية.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / السمعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / السمعة.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الهيكل",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / النتيجة / الأوزان / الهيكل.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / السعة / القيمة الأساسية / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / السعة / القيمة الأساسية / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / الولاء / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / الولاء / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / الولاء / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / الولاء / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مخاطرة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مخاطرة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مخاطرة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مخاطرة / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مهارة / الحد الأقصى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مهارة / الحد الأقصى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مهارة / الحد الأدنى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التوظيف / مهارة / الحد الأدنى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / الولاء / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / الولاء / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / الحد الأقصى / فرصة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / الحد الأقصى / فرصة.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 4",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / النتائج / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / مخاطرة / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحادث / مخاطرة / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الولاء / الاضمحلال",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الولاء / الاضمحلال.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحد الأقصى / المستوى",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحد الأقصى / المستوى.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / خسارة الولاء بسبب الاستقطاب",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / خسارة الولاء بسبب الاستقطاب.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / التكلفة / القيمة الأساسية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / التكلفة / القيمة الأساسية.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / الساعات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / الساعات.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / الحادث / التخفيض",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / الحادث / التخفيض.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / مخاطرة / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الحماية / مخاطرة / التكلفة.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التعافي / القيمة الأساسية / فرصة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التعافي / القيمة الأساسية / فرصة.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التعافي / الولاء / الوزن",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / التعافي / الولاء / الوزن.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / القيمة الأساسية / المضاعف",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / القيمة الأساسية / المضاعف.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / الولاء / عائد",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / الولاء / عائد.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / مهارة / المقسوم عليه",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / الأجر / مهارة / المقسوم عليه.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 1",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 2",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 3",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 4",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 5",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 6",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / موظفون / نقاط الضعف / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / العقود",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / العقود.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / التجار",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / التجار.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / مراكز التوزيع",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / مراكز التوزيع.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / المسارات",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / المسارات.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / موظفون",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / التشغيل داخل اللعبة / الهيكل / الأوزان / موظفون.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "شبكة الأعمال / المنظمة / الصلاحية",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / المنظمة / الصلاحية.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "شبكة الأعمال / موظفون / موزع / القيمة الأساسية / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / موزع / القيمة الأساسية / السعة.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "شبكة الأعمال / موظفون / موزع / القيمة الأساسية / الأجر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / موزع / القيمة الأساسية / الأجر.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "شبكة الأعمال / موظفون / موزع / العمولة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / موزع / العمولة.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "شبكة الأعمال / موظفون / موزع / التوظيف / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / موزع / التوظيف / السعر.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "شبكة الأعمال / موظفون / ناقل / القيمة الأساسية / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / ناقل / القيمة الأساسية / السعة.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "شبكة الأعمال / موظفون / ناقل / القيمة الأساسية / الأجر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / ناقل / القيمة الأساسية / الأجر.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "شبكة الأعمال / موظفون / ناقل / العمولة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / ناقل / العمولة.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "شبكة الأعمال / موظفون / ناقل / التوظيف / السعر",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / موظفون / ناقل / التوظيف / السعر.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "شبكة الأعمال / دورة التحديث / الدقائق",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / دورة التحديث / الدقائق.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / طائرة / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / طائرة / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "شبكة الأعمال / عمليات النقل / طائرة / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / طائرة / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / طائرة / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / طائرة / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "شبكة الأعمال / عمليات النقل / طائرة / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / طائرة / مخاطرة.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / قارب / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / قارب / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "شبكة الأعمال / عمليات النقل / قارب / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / قارب / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / قارب / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / قارب / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "شبكة الأعمال / عمليات النقل / قارب / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / قارب / مخاطرة.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / سيارة / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيارة / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "شبكة الأعمال / عمليات النقل / سيارة / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيارة / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / سيارة / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيارة / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "شبكة الأعمال / عمليات النقل / سيارة / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيارة / مخاطرة.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / سيرًا على الأقدام / مخاطرة.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة / مخاطرة.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة صغيرة / السعة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة صغيرة / السعة.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة صغيرة / التكلفة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة صغيرة / التكلفة.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة صغيرة / مضاعف المدة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة صغيرة / مضاعف المدة.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "شبكة الأعمال / عمليات النقل / شاحنة صغيرة / مخاطرة",
                    description = "إعداد التشغيل الخاص بـ شبكة الأعمال / عمليات النقل / شاحنة صغيرة / مخاطرة.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "التكامل العام",
                        custom = "التكامل المخصص",
                        none = "معطّل",
                    },
                },
                reputationRules = {
                    label = "قواعد السمعة",
                    description = "اضبط قواعد مسماة للإجراءات وأهدافها الاختيارية. القواعد المفعلة فقط تمنح نقاطاً.",
                },
            },
            territoryMap = {
                addPoint = "أضف نقطة",
                clear = "مسح",
                create = "إنشاء",
                custom = "مناطق مخصصة",
                deletePoint = "حذف النقطة",
                eyebrow = "محرر المناطق",
                minimum = "الحد الأدنى 3",
                pointCount = "نقاط {count}",
                presets = "المناطق المحددة مسبقاً",
                shown = "تظهر على الخريطة",
                street = "الشارع",
                supply = "العرض",
                territories = "المناطق",
                type = "نوع المنطقة",
                undo = "تراجع",
            },
            shopPositionTools = {
                currentPosition = "استخدام الموقع الحالي",
                selectEntity = "اختيار العنصر",
                selectEntityHint = "وجه الليزر نحو آلة تسجيل النقد أو الخزنة. اضغط Enter: لاستخدام موقع واتجاه العنصر المحدد. Backspace: للإلغاء.",
            },
            drugSettingSubsections = {
                cultivationLevels = "مستويات الزراعة",
                general = "عام",
                runtime = "الوصول إلى إجراءات اللعب",
                quality = "الجودة",
                packaging = "التغليف",
                growing = "الزراعة",
                labs = "المختبرات والمركبات السكنية",
                power = "الطاقة والمعدات",
                workers = "العمال",
                market = "السوق والتوزيع",
                threats = "المداهمات والتخريب",
                pvpTakeovers = "الاستيلاء على المختبرات",
                consumption = "الاستهلاك",
                processing = "المعالجة",
                performance = "الأداء",
                dynamicMarket = "السوق الديناميكي",
                heat = "اهتمام الشرطة والمخاطر",
                contacts = "شبكة الاتصالات",
                business = "شبكة الأعمال",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "عام" },
                cultivationCurve = { label = "منحنى المستويات" },
                cultivationExperience = { label = "مكافآت الخبرة" },
                cultivationUnlocks = { label = "فتح المستويات" },
                creator = {
                    label = "فتح المحرر",
                },
                creatorSettings = {
                    label = "إعدادات المحرر",
                },
                interfaceHud = {
                    label = "مواضع الواجهة",
                },
                drugsGeneral = {
                    label = "عام",
                },
                runtimeAccess = {
                    label = "الوصول والملكية",
                },
                runtimePayouts = {
                    label = "المدفوعات",
                },
                runtimeDispatch = {
                    label = "العمليات والشرطة",
                },
                qualityWeights = {
                    label = "الجودة / الأوزان",
                },
                qualityTiers = {
                    label = "الجودة / مستويات الجودة",
                },
                packagingGeneral = {
                    label = "عام",
                },
                growingGeneral = {
                    label = "عام",
                },
                plantDefaults = {
                    label = "نبات / القيم الافتراضية",
                },
                harvestWindow = {
                    label = "الحصاد / النافذة الزمنية",
                },
                labsGeneral = {
                    label = "عام",
                },
                labRent = {
                    label = "الإيجار ودورة الحياة",
                },
                camperDefaults = {
                    label = "عربة التخييم",
                },
                labUpgrades = {
                    label = "الترقيات",
                },
                labDefaults = {
                    label = "مختبر / القيم الافتراضية",
                },
                powerGeneral = {
                    label = "عام",
                },
                generators = {
                    label = "المولدات",
                },
                equipmentWear = {
                    label = "المعدات",
                },
                workersGeneral = {
                    label = "عام",
                },
                marketGeneral = {
                    label = "عام",
                },
                marketPrices = {
                    label = "الأسعار",
                },
                distribution = {
                    label = "التوزيع",
                },
                threatsGeneral = {
                    label = "عام",
                },
                threatHeat = {
                    label = "الضغط الأمني",
                },
                threatChances = {
                    label = "الاحتمالات",
                },
                pvpTakeoverRules = {
                    label = "قواعد الاستيلاء",
                },
                pvpTakeoverZones = {
                    label = "المناطق & التوقيت",
                },
                pvpTakeoverMethods = {
                    label = "طرق الاقتحام",
                },
                consumptionGeneral = {
                    label = "عام",
                },
                consumerDecay = {
                    label = "انخفاض التحمل والإدمان",
                },
                consumerEffects = {
                    label = "التأثيرات والمخاطر",
                },
                processingFlow = {
                    label = "سير المعالجة",
                },
                processingGeneral = {
                    label = "عام",
                },
                powerRuntime = {
                    label = "التشغيل داخل اللعبة",
                },
                powerHeat = {
                    label = "اهتمام الشرطة والبصمة الكهربائية",
                },
                powerModes = {
                    label = "الإدارة / الأوضاع",
                },
                powerPriorities = {
                    label = "الحمل / الأولويات",
                },
                performanceInactiveControlIntervalMs = {
                    label = "غير نشط / التحكم / الفاصل الزمني / مللي ثانية",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "تفاعل / خاملاً / فاصل الفحص / مللي ثانية",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "تفاعل / إرشاد التفاعل / الفاصل الزمني / مللي ثانية",
                },
                performanceInteractionScanIntervalMs = {
                    label = "تفاعل / فاصل الفحص / مللي ثانية",
                },
                performanceMinimumScanIntervalMs = {
                    label = "الحد الأدنى / فاصل الفحص / مللي ثانية",
                },
                performanceStreetPedActivationDistance = {
                    label = "الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / تفعيل / المسافة",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / خاملاً / فاصل الفحص / مللي ثانية",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "الشارع / شخصية (بيد)a40074848905d12c107f984aac5d9776 / فاصل الفحص / مللي ثانية",
                },
                performanceWorldCachePadding = {
                    label = "العالم / ذاكرة التخزين المؤقت / الهامش الإضافي",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "العالم / ذاكرة التخزين المؤقت / التحديث / الفاصل الزمني / مللي ثانية",
                },
                performanceWorldIdleIntervalMs = {
                    label = "العالم / خاملاً / الفاصل الزمني / مللي ثانية",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "فترة انتظار الإجراء / ثوانٍ",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "فعل / حد السجل",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "الكمية / التشبع / الوزن",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "القيمة الأساسية / دقة المعلومات",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "القيمة الافتراضية / المتوسط / الجودة",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "القيمة الافتراضية / مورد / المرونة",
                },
                dynamicMarketDemandCenter = {
                    label = "الطلب / القيمة الوسطية",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "الطلب / السعر / التأثير",
                },
                dynamicMarketDirectionThreshold = {
                    label = "الاتجاه / العتبة",
                },
                dynamicMarketEnabled = {
                    label = "مفعّل",
                },
                dynamicMarketEventChance = {
                    label = "الحدث / فرصة",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "الحدث / المدة / الدقائق",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "الحدث / الحد الأدنى / المدة / الدقائق",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "الحدث / القوة / الحد الأقصى",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "الحدث / القوة / الحد الأدنى",
                },
                dynamicMarketEvents = {
                    label = "الأحداث",
                },
                dynamicMarketExactIntelReputation = {
                    label = "معلومات دقيقة / السمعة",
                },
                dynamicMarketExactIntelTrust = {
                    label = "معلومات دقيقة / الثقة",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "عامa40074848905d12c107f984aac5d9776 / منطقة / التسمية",
                },
                dynamicMarketHistoryLimit = {
                    label = "حد السجل",
                },
                dynamicMarketInitialDemand = {
                    label = "القيمة الأولية / الطلب",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "القيمة الأولية / مضاعف السعر",
                },
                dynamicMarketIntelDemandError = {
                    label = "المعلومات / الطلب / خطأ",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "المعلومات / الحد الأقصى / الدقة",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "المعلومات / الحد الأدنى / الدقة",
                },
                dynamicMarketIntelPoliceError = {
                    label = "المعلومات / الشرطة / خطأ",
                },
                dynamicMarketIntelPriceError = {
                    label = "المعلومات / السعر / خطأ",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "المعلومات / السعر / الحد الأقصى",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "المعلومات / السعر / الحد الأدنى",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "المعلومات / السمعة / الوزن",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "المعلومات / مورد / السعر / خطأ",
                },
                dynamicMarketIntelSaturationError = {
                    label = "المعلومات / التشبع / خطأ",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "فترة بذرة المعلومات العشوائية / ثوانٍ",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "المعلومات / الحالة / الدقة / العتبة",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "المعلومات / الحالة / خطأ / العتبة",
                },
                dynamicMarketIntelSupplyError = {
                    label = "المعلومات / العرض / خطأ",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "المعلومات / الثقة / الوزن",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "التلاعب / دقائق فترة الانتظار",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "التلاعب / الطلب / التغير",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "التلاعب / المدة / الدقائق",
                },
                dynamicMarketManipulationHeat = {
                    label = "التلاعب / الضغط الأمني",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "التلاعب / الحد الأدنى / دفعة / الكمية",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "التلاعب / حساب الدفع",
                },
                dynamicMarketManipulationPrice = {
                    label = "التلاعب / السعر",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "التلاعب / منطقة / الضغط الأمني / المضاعف",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "الحد الأقصى / عمر المعلومة / الدقائق",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "الحد الأقصى / مضاعف السعر",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "الحد الأدنى / عمر المعلومة / الدقائق",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "الحد الأدنى / المقياس / النافذة الزمنية / الدقائق",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "الحد الأدنى للسعر / المضاعف",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "الحد الأدنى / التحديث / الدقائق",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "الشرطة / الطلب / الوزن",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "الشرطة / السعر / التأثير",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "الجودة المنخفضة / الطلب / العقوبة",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "الجودة المنخفضة / العتبة",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "الجودة الممتازة / مكافأة الطلب",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "الجودة الممتازة / العتبة",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "الإنتاج / العرض / الوزن",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "الإنتاج / النافذة الزمنية / الدقائق",
                },
                dynamicMarketQualityCenter = {
                    label = "الجودة / القيمة الوسطية",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "الجودة / الثقة / التأثير",
                },
                dynamicMarketQualityRange = {
                    label = "الجودة / نطاق القيم",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "الندرة / مكافأة / الحد الأقصى",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "إقليمي / عامa40074848905d12c107f984aac5d9776 / الوزن",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "إقليمي / محلي / الوزن",
                },
                dynamicMarketResourceAliases = {
                    label = "مورد / الأسماء البديلة",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "مورد / الاتجاه / الانخفاض / العتبة",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "مورد / الاتجاه / الارتفاع / العتبة",
                },
                dynamicMarketResources = {
                    label = "الموارد",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "المبيعات / النافذة الزمنية / الدقائق",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "التشبع / الطلب / الوزن",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "التشبع / السعر / التأثير",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "الندرة / الطلب / الوزن",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "الندرة / السعر / التأثير",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "الفصل / النهاية / الأشهر",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "الفصل / المضاعفات",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "النقص / الإشاعة / العتبة",
                },
                dynamicMarketStatusThresholds = {
                    label = "الحالة / العتبات",
                },
                dynamicMarketTargetSupply = {
                    label = "هدف / العرض",
                },
                dynamicMarketTrendChance = {
                    label = "الاتجاه / فرصة",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "الاتجاه / المدة / الدقائق",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "الاتجاه / الحد الأقصى / القوة",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "الاتجاه / الحد الأدنى / القوة",
                },
                dynamicMarketUpdateMinutes = {
                    label = "التحديث / الدقائق",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "تقلب الأسعار / الحد الأقصى",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "تقلب الأسعار / الحد الأدنى",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "الطقس / المضاعفات",
                },
                dynamicMarketWeatherState = {
                    label = "الطقس / الولاية",
                },
                heatActionCooldownSeconds = {
                    label = "فترة انتظار الإجراء / ثوانٍ",
                },
                heatActivityRiskWeights = {
                    label = "النشاط / مخاطرة / الأوزان",
                },
                heatAggressiveHeatMultiplier = {
                    label = "أسلوب العمل العدواني / الضغط الأمني / المضاعف",
                },
                heatBurnerBurnThreshold = {
                    label = "الهاتف المؤقت / انكشاف الهوية / العتبة",
                },
                heatBurnerHeatPerWholesale = {
                    label = "الهاتف المؤقت / الضغط الأمني / لكل صفقة جملة",
                },
                heatBurnerPhoneItem = {
                    label = "هاتف مخصص للاستخدام لمرة واحدة / العنصر",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "المركبة السكنية قيد التشغيل / الضغط الأمني / المضاعف",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "المركبة السكنية قيد التشغيل / الضغط الأمني / العتبة",
                },
                heatCamperParkedHeat = {
                    label = "المركبة السكنية المتوقفة / الضغط الأمني",
                },
                heatContaminatedHeatMultiplier = {
                    label = "التلوث / الضغط الأمني / المضاعف",
                },
                heatContaminatedThreshold = {
                    label = "التلوث / العتبة",
                },
                heatCultivationFreePlants = {
                    label = "الزراعة / نباتات دون مخاطر إضافية",
                },
                heatCultivationHeatPerPlant = {
                    label = "الزراعة / الضغط الأمني / لكل نبات",
                },
                heatDealerHiddenMinutes = {
                    label = "تاجر / مخفي / الدقائق",
                },
                heatDecayPerTick = {
                    label = "الاضمحلال / لكل دورة تحديث",
                },
                heatEnabled = {
                    label = "مفعّل",
                },
                heatEnforcementHeat = {
                    label = "التواجد الأمني / الضغط الأمني",
                },
                heatEnforcementMultipliers = {
                    label = "التواجد الأمني / المضاعفات",
                },
                heatEntityTypes = {
                    label = "كائن اللعبة / الأنواع",
                },
                heatEventCooldownMinutes = {
                    label = "الحدث / دقائق فترة الانتظار",
                },
                heatEventHistoryLimit = {
                    label = "الحدث / حد السجل",
                },
                heatLabHeatSyncThreshold = {
                    label = "مختبر / الضغط الأمني / المزامنة / العتبة",
                },
                heatLayLowCooldownMinutes = {
                    label = "التواري عن الأنظار / دقائق فترة الانتظار",
                },
                heatLayLowIdleMinutes = {
                    label = "التواري عن الأنظار / خاملاً / الدقائق",
                },
                heatLayLowReduction = {
                    label = "التواري عن الأنظار / التخفيض",
                },
                heatLockdownMinutes = {
                    label = "إغلاق تام / الدقائق",
                },
                heatMinimumDurationMinutes = {
                    label = "الحد الأدنى / المدة / الدقائق",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "الحد الأدنى / الحدث / فترة الانتظار (بالثواني)",
                },
                heatMinimumIdleSeconds = {
                    label = "الحد الأدنى / خاملاً / ثوانٍ",
                },
                heatProcessingHeatMultiplier = {
                    label = "المعالجة / الضغط الأمني / المضاعف",
                },
                heatRiskWeights = {
                    label = "مخاطرة / الأوزان",
                },
                heatRotateBurnerReduction = {
                    label = "تغيير الهاتف المؤقت / التخفيض",
                },
                heatRouteControlMinutes = {
                    label = "المسار / التحكم / الدقائق",
                },
                heatSaleHeat = {
                    label = "البيع / الضغط الأمني",
                },
                heatThresholds = {
                    label = "العتبات",
                },
                heatTickMinutes = {
                    label = "دورة التحديث / الدقائق",
                },
                heatWholesaleHeatMultiplier = {
                    label = "بيع الجملة / الضغط الأمني / المضاعف",
                },
                heatWorkerLeakAlertRadius = {
                    label = "عامل / تسريب المعلومات / نطاق التنبيه",
                },
                heatWorkerLeakBaseChance = {
                    label = "عامل / تسريب المعلومات / القيمة الأساسية / فرصة",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "عامل / تسريب المعلومات / الفصيل / المضاعف",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "عامل / تسريب المعلومات / عالية / الخطورة / العتبة",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "عامل / تسريب المعلومات / الولاء / فرصة / المضاعف",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "عامل / تسريب المعلومات / الولاء / العتبة",
                },
                heatWorkerLeakMaximumChance = {
                    label = "عامل / تسريب المعلومات / الحد الأقصى / فرصة",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "عامل / تسريب المعلومات / الحد الأدنى / فترة الانتظار (بالثواني)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "عامل / تسريب المعلومات / المسار / المضاعف",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "عامل / تسريب المعلومات / القوة / الحد الأقصى",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "عامل / تسريب المعلومات / القوة / الحد الأدنى",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "عامل / تسريب المعلومات / القوة / المضاعف",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "عامل / تسريب المعلومات / الإجهاد / فرصة / المضاعف",
                },
                heatWorkerLeakStressThreshold = {
                    label = "عامل / تسريب المعلومات / الإجهاد / العتبة",
                },
                contactsActionCooldownSeconds = {
                    label = "فترة انتظار الإجراء / ثوانٍ",
                },
                contactsActiveHotspotCount = {
                    label = "عدد النقاط النشطة",
                },
                contactsBurnerHintTrust = {
                    label = "تلميح الهاتف المؤقت / الثقة",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "الهاتف المؤقت / العرض / الحد الأقصى / المضاعف",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "الهاتف المؤقت / العرض / الحد الأدنى / المضاعف",
                },
                contactsBuyerCooldownMinutes = {
                    label = "مشتري / دقائق فترة الانتظار",
                },
                contactsBuyerDeliveryDistance = {
                    label = "مشتري / مسافة التسليم",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "مشتري / ممتاز / النجاح / النتيجة",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "مشتري / ممتاز / الثقة / عائد",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "مشتري / الطلب / الملاحقة والمخاطر / الوزن",
                },
                contactsBuyerStandardTrustGain = {
                    label = "مشتري / قياسي / الثقة / عائد",
                },
                contactsContactActiveDelaySeconds = {
                    label = "مهلة تفعيل جهة الاتصال / ثوانٍ",
                },
                contactsContactDemandRange = {
                    label = "جهة الاتصال / الطلب / نطاق القيم",
                },
                contactsContactLossTrust = {
                    label = "جهة الاتصال / الخسارة / الثقة",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "الشبكة المظلمة / معلومات دقيقة / الدقائق",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "الشبكة المظلمة / المنطقة النشطة / المعلومات / السعر",
                },
                contactsDarknetIntelPrice = {
                    label = "الشبكة المظلمة / المعلومات / السعر",
                },
                contactsDealerBasePrice = {
                    label = "تاجر / السعر الأساسي",
                },
                contactsDealerHireCapacity = {
                    label = "تاجر / التوظيف / السعة",
                },
                contactsDealerHireRisk = {
                    label = "تاجر / التوظيف / مخاطرة",
                },
                contactsDealerHireSkill = {
                    label = "تاجر / التوظيف / مهارة",
                },
                contactsDealerOffers = {
                    label = "عروض الموزعين",
                },
                contactsDealerProtectionHours = {
                    label = "تاجر / الحماية / الساعات",
                },
                contactsDealerProtectionPrice = {
                    label = "تاجر / الحماية / السعر",
                },
                contactsDealerSaleMax = {
                    label = "تاجر / البيع / الحد الأقصى",
                },
                contactsDealerSaleMin = {
                    label = "تاجر / البيع / الحد الأدنى",
                },
                contactsDealerSimulation = {
                    label = "تاجر / محاكاة",
                },
                contactsDealerTickMinutes = {
                    label = "تاجر / دورة التحديث / الدقائق",
                },
                contactsDealerWage = {
                    label = "تاجر / الأجر",
                },
                contactsDealerWageDecay = {
                    label = "تاجر / الأجر / الاضمحلال",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "تاجر / الأجر / الولاء / عائد",
                },
                contactsDealerWeaknesses = {
                    label = "تاجر / نقاط الضعف",
                },
                contactsDefaultContactDemand = {
                    label = "القيمة الافتراضية / جهة الاتصال / الطلب",
                },
                contactsDefaultContactRisk = {
                    label = "القيمة الافتراضية / جهة الاتصال / مخاطرة",
                },
                contactsDefaultDealerCapacity = {
                    label = "التاجر الافتراضي / السعة",
                },
                contactsDefaultDealerRisk = {
                    label = "التاجر الافتراضي / مخاطرة",
                },
                contactsDefaultDealerSkill = {
                    label = "التاجر الافتراضي / مهارة",
                },
                contactsDefaultHotspotRadius = {
                    label = "القيمة الافتراضية / المنطقة النشطة / نصف القطر",
                },
                contactsDemandResetMinutes = {
                    label = "إعادة تعيين الطلب (بالدقائق)",
                },
                contactsEnabled = {
                    label = "مفعّل",
                },
                contactsExactLocationTrust = {
                    label = "الموقع الدقيق / الثقة",
                },
                contactsFactionDiscoveryReputation = {
                    label = "الفصيل / الاكتشاف / السمعة",
                },
                contactsFactionHintTrust = {
                    label = "الفصيل / التلميح / الثقة",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "التسليم الفاشل / دقائق فترة الانتظار",
                },
                contactsFakeDealEncounter = {
                    label = "صفقة وهمية / المواجهة",
                },
                contactsFallbackPreferredDrug = {
                    label = "القيمة البديلة / المخدر المفضل",
                },
                contactsFallbackProductLabel = {
                    label = "القيمة البديلة / تسمية المنتج",
                },
                contactsGuideBookItem = {
                    label = "الدليل / الكتاب / العنصر",
                },
                contactsGuideBookTrust = {
                    label = "الدليل / الكتاب / الثقة",
                },
                contactsHireDealerPrice = {
                    label = "توظيف موزع / السعر",
                },
                contactsHistoryLimit = {
                    label = "حد السجل",
                },
                contactsHotspotIntelMinutes = {
                    label = "المنطقة النشطة / المعلومات / الدقائق",
                },
                contactsHotspotRotationMinutes = {
                    label = "المنطقة النشطة / التدوير / الدقائق",
                },
                contactsListingDurationMinutes = {
                    label = "الإعلان / المدة / الدقائق",
                },
                contactsMaxOwnedDealers = {
                    label = "الحد الأقصى / مملوكة / التجار",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "الحد الأدنى / مشتري / مسافة التسليم",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "الحد الأدنى / تناوب الاتصال (بالدقائق)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "الحد الأدنى / إعادة تعيين الطلب (بالدقائق)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "الحد الأدنى / الضغط الأمني / المضاعف",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "الحد الأدنى / المنطقة النشطة / المعلومات / الدقائق",
                },
                contactsMinimumHotspotRadius = {
                    label = "الحد الأدنى / المنطقة النشطة / نصف القطر",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "الحد الأدنى / المنطقة النشطة / التدوير / الدقائق",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "الحد الأدنى / الإعلان / المدة / الدقائق",
                },
                contactsMinimumRewardMultiplier = {
                    label = "الحد الأدنى للمكافأة / المضاعف",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "الحد الأدنى / السطو / المضاعف",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "الحد الأدنى / الموقع / مضاعف السعر",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "غير ذلك / مخدر / مضاعف السعر",
                },
                contactsPaymentAccount = {
                    label = "حساب الدفع",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "بعد التسليم / الطلب / Reset / ثوانٍ",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "المخدر المفضل / مضاعف السعر",
                },
                contactsRegionLocationTrust = {
                    label = "المنطقة / الموقع / الثقة",
                },
                contactsRequestAmounts = {
                    label = "الطلب / الكميات",
                },
                contactsRotationMinutes = {
                    label = "التدوير / الدقائق",
                },
                contactsSpotPools = {
                    label = "الموقع / مجموعات الاختيار",
                },
                contactsStreetHotspots = {
                    label = "الشارع / المناطق النشطة",
                },
                contactsTrustLevels = {
                    label = "الثقة / المستويات",
                },
                businessActionCooldownSeconds = {
                    label = "فترة انتظار الإجراء / ثوانٍ",
                },
                businessBalance = {
                    label = "الرصيد",
                },
                businessContracts = {
                    label = "العقود",
                },
                businessDefaultBusinessName = {
                    label = "القيمة الافتراضية / اسم العمل التجاري",
                },
                businessDefaultRankId = {
                    label = "القيمة الافتراضية / الرتبة / ID",
                },
                businessDefaultStaffStyle = {
                    label = "القيمة الافتراضية / موظفون / أسلوب العمل",
                },
                businessDefaultTransport = {
                    label = "القيمة الافتراضية / نقل",
                },
                businessEnabled = {
                    label = "مفعّل",
                },
                businessHubs = {
                    label = "مراكز التوزيع",
                },
                businessLimits = {
                    label = "الحدود",
                },
                businessPayments = {
                    label = "المدفوعات",
                },
                businessPayoutAccount = {
                    label = "المستحقات / الحساب",
                },
                businessRanks = {
                    label = "الرتب",
                },
                businessReportDays = {
                    label = "فترة التقرير / أيام",
                },
                businessRouteEndpointTypes = {
                    label = "المسار / نقطة النهاية / الأنواع",
                },
                businessRuntime = {
                    label = "التشغيل داخل اللعبة",
                },
                businessSocietyPermission = {
                    label = "المنظمة / الصلاحية",
                },
                businessStaff = {
                    label = "موظفون",
                },
                businessTickMinutes = {
                    label = "دورة التحديث / الدقائق",
                },
                businessTransports = {
                    label = "عمليات النقل",
                },
            },
            territorySettings = {
                section = "الأقاليم",
                zonesGroup = "مناطق النفوذ",
                sourceLabel = "مصدر المنطقة",
                sourceDescription = "استخدم المناطق المحددة مسبقاً أو حدد مضلعات النفوذ الخاصة بك.",
                sourcePreset = "المناطق المحددة مسبقاً",
                sourceCustom = "مناطق مخصصة",
                editLabel = "محرر المناطق",
                editDescription = "قم بتحرير المناطق المستخدمة من قبل مصدر المنطقة المحدد.",
                editButton = "تحرير المناطق",
                presetSection = "المناطق المحددة مسبقاً",
                presetEntry = "منطقة محددة مسبقاً",
                customSection = "مناطق مخصصة",
                customEntry = "منطقة مخصصة",
                typeLabel = "نوع المنطقة",
                streetType = "الشارع",
                supplyType = "العرض",
                enabledLabel = "تظهر على الخريطة",
                enabledDescription = "المناطق المحددة مسبقاً وغير المفعلة تُزال من الخريطة ولا يمكن المطالبة بها.",
                zoneLabel = "حدود المنطقة",
                zoneDescription = "أضف ثلاث نقاط على الأقل بالتتابع حول حدود المنطقة.",
                ownershipGroup = "الملكية",
                decayGroup = "الاضمحلال",
                presenceGroup = "التواجد",
                activityGroup = "تقييم النشاط",
                ownershipBenefitsGroup = "مزايا الملكية",
                ownershipThresholdLabel = "حد الملكية الأدنى",
                ownershipThresholdDescription = "نسبة السيطرة التي يجب أن تتجاوزها العصابة لتمتلك المنطقة رسمياً.",
                activityFloorLabel = "الحد الأدنى الثابت للنشاط",
                activityFloorDescription = "نقاط النفوذ المطلوبة عند تعطيل الحدود القائمة على الحجم.",
                floorByZoneSizeLabel = "تغيير حجم الحد حسب حجم المنطقة",
                floorByZoneSizeDescription = "حساب الحد الأدنى لنشاط كل منطقة بناءً على مساحة المضلع بدلاً من استخدام الحد الثابت.",
                floorPointsPerSizeUnitLabel = "نقاط الحد لكل كم²",
                floorPointsPerSizeUnitDescription = "نقاط الحد الأدنى للنشاط المطلوبة لكل كيلومتر مربع من مساحة المنطقة.",
                fixedFloorRequirement = "عطّل الحدود القائمة على الحجم لتحرير الحد الأدنى الثابت للنشاط.",
                sizeFloorRequirement = "فعّل الحدود القائمة على الحجم لتحرير النقاط لكل كيلومتر مربع.",
                dailyDecayLabel = "الاضمحلال اليومي للنفوذ",
                dailyDecayDescription = "نسبة النفوذ التي يتم خصمها كل 24 ساعة.",
                presenceIntervalLabel = "فاصل الوجود",
                presenceIntervalDescription = "الدقائق بين مكافآت الوجود التلقائية للمناطق.",
                presencePointsLabel = "نقاط الوجود لكل عضو",
                presencePointsDescription = "نقاط الوجود الممنوحة لكل عضو عصابة مؤهل في كل فاصل زمني.",
                drugSalesEnabledLabel = "مبيعات الـ NPC تمنح نفوذاً للمنطقة",
                drugSalesEnabledDescription = "المبيعات الناجحة في الشوارع للـ NPCs تمنح نفوذاً لعصابة البائع في منطقة الشارع الحالية.",
                drugSalePointsLabel = "النقاط لكل مادة مخدرة مباعة",
                drugSalePointsDescription = "نقاط النفوذ الممنوحة لكل وحدة مخدرات يتم الإبلاغ عن بيعها.",
                drugSalesRequirement = "فعّل نفوذ مبيعات الـ NPC لتكوين نقاطه.",
                graffitiPointsLabel = "نقاط الغرافيتي لكل 24 ساعة",
                graffitiPointsDescription = "نقاط الوجود الممنوحة عندما يستمر الغرافيتي لمدة إجمالية قدرها 24 ساعة مسجلة.",
                streetSellingPriceBonusLabel = "مكافأة سعر البيع في الشوارع",
                streetSellingPriceBonusDescription = "النسبة المضافة إلى أسعار بيع المخدرات للمالك الرسمي لمنطقة شارع.",
                supplyProductionSpeedBonusLabel = "مكافأة سرعة إنتاج الإمدادات",
                supplyProductionSpeedBonusDescription = "النسبة المضافة إلى سرعة إنتاج المخدرات للمالك الرسمي لمنطقة إمدادات.",
                pruneToleranceLabel = "تحمل تقليم النفوذ",
                pruneToleranceDescription = "النفوذ الفعال تحت هذه القيمة يُعامل كصفر.",
            },
            graffitiSettings = {
                section = "الجرافيتي",
                generalGroup = "عام",
                streamingGroup = "جاري التحميل",
                moderationGroup = "الإشراف",
                graffitiEnabledLabel = "تفعيل الغرافيتي",
                graffitiEnabledDescription = "السماح للاعبين برش ورؤية الغرافيتي.",
                graffitiRequireItemLabel = "يتطلب عبوة رش",
                graffitiRequireItemDescription = "يحتاج اللاعبون إلى عبوة رش للقيام بالرش. خلاف ذلك، يتم استخدام أمر /graffiti.",
                graffitiChargesPerCanLabel = "عدد الرشات لكل عبوة",
                graffitiChargesPerCanDescription = "عدد رسومات الغرافيتي التي يمكن إنشاؤها باستخدام عبوة رش واحدة.",
                graffitiCooldownSecondsLabel = "فترة انتظار الرش",
                graffitiCooldownSecondsDescription = "عدد الثواني التي يجب على اللاعب انتظارها بين كل عملية رش.",
                graffitiMaxPerPlayerLabel = "الحد الأقصى للغرافيتي لكل لاعب",
                graffitiMaxPerPlayerDescription = "الحد الأقصى لرسومات الغرافيتي النشطة التي يمكن للاعب امتلاكها. 0 تعني بلا حدود.",
                graffitiMaxDistanceLabel = "أقصى مسافة للرش",
                graffitiMaxDistanceDescription = "أقصى مسافة يمكن أن يكون عليها الجدار لكي تتمكن من الرش عليه، بالأمتار.",
                graffitiSprayDurationLabel = "مدة الرش",
                graffitiSprayDurationDescription = "مدة حركة الرش (الأنيميشن)، بالملي ثانية.",
                graffitiExpiryDaysLabel = "وقت الانتهاء",
                graffitiExpiryDaysDescription = "عدد الأيام حتى يختفي الغرافيتي تلقائياً. 0 تعني أبداً.",
                graffitiTerritoryHoursLabel = "ساعات السيطرة لكل رشّة",
                graffitiTerritoryHoursDescription = "ساعات الوجود في المنطقة التي يمنحها الغرافيتي الجديد لعصابته.",
                graffitiStreamRadiusLabel = "نطاق الظهور",
                graffitiStreamRadiusDescription = "المسافة بالأمتار التي يصبح عندها الغرافيتي مرئياً للاعبين.",
                graffitiPoolSizeLabel = "حجم مجموعة الملصقات",
                graffitiPoolSizeDescription = "عدد رسومات الغرافيتي التي يتم تحميلها في وقت واحد. القيم الأعلى تستهلك أداءً أكبر.",
                graffitiReportsEnabledLabel = "تفعيل البلاغات",
                graffitiReportsEnabledDescription = "السماح للاعبين بالإبلاغ عن الغرافيتي المسيء.",
                graffitiAutoHideThresholdLabel = "حد الإخفاء التلقائي",
                graffitiAutoHideThresholdDescription = "عدد البلاغات التي تؤدي لإخفاء الغرافيتي تلقائياً. 0 لتعطيل هذه الخاصية.",
            },
            darknetSettings = {
                section = "سوق الشبكة المظلمة",
                availabilityGroup = "التوافر",
                economyGroup = "العملات الرقمية",
                listingsGroup = "العروض وانتهاء الصلاحية",
                chatGroup = "دردشة خاصة",
                identityGroup = "الأسماء المستعارة والسمعة",
                deliveryGroup = "التسليم ونقاط التسليم الميتة",
                policeGroup = "وصول الشرطة",
                npcGroup = "تجار الـ NPC",
                enabledLabel = "تفعيل سوق الشبكة المظلمة",
                enabledDescription = "يجعل تطبيق تابلت السوق السوداء ونظام تشغيله متاحاً.",
                tabletOrderLabel = "ترتيب تطبيق التابلت",
                tabletOrderDescription = "يتحكم في موقع سوق الشبكة المظلمة على التابلت.",
                currencyCodeLabel = "رمز العملة",
                currencyCodeDescription = "رمز قصير يظهر لسجل العملات الرقمية الداخلي.",
                starterBalanceLabel = "رصيد المحفظة الجديد",
                starterBalanceDescription = "يتم تخصيص العملات الرقمية فقط عندما يفتح اللاعب السوق لأول مرة.",
                exchangeEnabledLabel = "تفعيل تبادل العملات",
                exchangeEnabledDescription = "يسمح لمستخدمي BlackBay الموثقين بشراء وبيع العملات في صفحة حساباتهم.",
                exchangeAccountLabel = "حساب دفع التبادل",
                exchangeAccountDescription = "حساب الإطار (Framework) المستخدم لشراء العملات ومدفوعات البيع.",
                exchangeBuyPriceLabel = "سعر الشراء لكل عملة",
                exchangeBuyPriceDescription = "المبلغ المخصوم من حساب الدفع مقابل عملة واحدة.",
                exchangeSellPriceLabel = "سعر البيع لكل عملة",
                exchangeSellPriceDescription = "المبلغ المدفوع لحساب الدفع مقابل عملة واحدة.",
                exchangeMinimumLabel = "الحد الأدنى للعملات لكل عملية تبادل",
                exchangeMinimumDescription = "أصغر كمية كاملة من العملات مقبولة في عملية تبادل واحدة.",
                exchangeMaximumLabel = "الحد الأقصى للعملات لكل عملية تبادل",
                exchangeMaximumDescription = "أكبر كمية كاملة من العملات مقبولة في عملية تبادل واحدة.",
                accountMoney = "نقد",
                accountBank = "البنك",
                accountBlackMoney = "أموال قذرة",
                scamChanceLabel = "فرصة الاحتيال العالمية من قبل الـ NPC (%)",
                scamChanceDescription = "الحد الأدنى لاحتمالية قيام الـ NPC بأخذ الدفع أو البضائع دون تقديم المقابل. لا تزال احتمالية التاجر الخاصة المرتفعة سارية.",
                listingExpiryLabel = "مدة صلاحية العرض (بالساعات)",
                listingExpiryDescription = "تنتهي صلاحية العروض النشطة تلقائيًا بعد هذا العدد من الساعات.",
                renewalHoursLabel = "مدة التجديد (بالساعات)",
                renewalHoursDescription = "الساعات التي تضاف عند قيام المالك بتجديد العرض.",
                maximumListingsLabel = "الحد الأقصى للعروض النشطة",
                maximumListingsDescription = "الحد الأقصى للعروض لكل اسم مستعار نشط.",
                maximumQuantityLabel = "الحد الأقصى لكمية البضائع",
                maximumQuantityDescription = "الحد الأعلى لكمية البضائع في العرض الواحد.",
                maximumPriceLabel = "الحد الأقصى لسعر الوحدة",
                maximumPriceDescription = "الحد الأقصى لسعر الكريبتو للوحدة الواحدة.",
                maximumMessageLengthLabel = "الحد الأقصى لطول الرسالة",
                maximumMessageLengthDescription = "الحد الأقصى لعدد الأحرف في رسالة الدردشة المشفرة.",
                aliasCooldownLabel = "فترة انتظار تغيير الاسم المستعار (بالساعات)",
                aliasCooldownDescription = "الحد الأدنى لعمر الهوية قبل إمكانية إيقافها مرة أخرى.",
                verifiedSalesLabel = "المبيعات المطلوبة للتحقق",
                verifiedSalesDescription = "المبيعات الناجحة المطلوبة قبل أن يصبح البائع موثقًا.",
                verifiedRatingLabel = "التقييم المطلوب للتحقق",
                verifiedRatingDescription = "الحد الأدنى لمتوسط التقييم للبائع الموثق.",
                scammerReportsLabel = "البلاغات للتحذير من المحتالين",
                scammerReportsDescription = "بلاغات التداول الفريدة المطلوبة للحصول على شارة المحتال المعروف.",
                meetingDistanceLabel = "مسافة التسليم",
                meetingDistanceDescription = "الحد الأقصى للمسافة بين كلا اللاعبين أو نقطة الـ NPC المحددة.",
                dropModelLabel = "موديل صندوق التسليم السري (Dead-drop)",
                dropModelDescription = "موديل غرض (Prop) من GTA يتم إنشاؤه محليًا لصناديق التسليم السري المتاحة.",
                dropStreamLabel = "مسافة ظهور التسليم السري",
                dropStreamDescription = "المسافة التي يتم عندها تحميل الصناديق وجهات اتصال الـ NPC.",
                dropInteractionLabel = "مسافة التفاعل مع التسليم السري",
                dropInteractionDescription = "المسافة المطلوبة للبحث عن صندوق والمطالبة به.",
                dropLifetimeLabel = "مدة صلاحية التسليم السري (بالساعات)",
                dropLifetimeDescription = "الوقت المتبقي قبل انتهاء صلاحية الصندوق غير المطالب به.",
                dropPollLabel = "فاصل تحديث العالم (ملي ثانية)",
                dropPollDescription = "الفاصل الزمني المستخدم لتحديث الصناديق القريبة واجتماعات الـ NPC.",
                policeGroupsLabel = "مجموعات وظائف الشرطة المصرح لها",
                policeGroupsDescription = "مفاتيح مجموعات محرر الوظائف التي يمكنها نشر عروض الطعم والاطلاع على التحقيقات.",
                policeGroupEntry = "مجموعة الشرطة",
                groupKeyLabel = "مفتاح المجموعة",
                npcTradersLabel = "مشترو وبائعو الـ NPC",
                npcTradersDescription = "تكوين عروض الـ NPC الدائمة، وطريقة التسليم، والسمعة، واحتمالية الاحتيال.",
                npcTraderEntry = "تاجر NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "اسم مستعار",
                npcSideLabel = "جانب السوق",
                sideSell = "يبيع للاعبين",
                sideBuy = "يشتري من اللاعبين",
                npcTitleLabel = "عنوان العرض",
                npcDescriptionLabel = "الوصف",
                npcItemNameLabel = "اسم عنصر الحقيبة",
                npcItemLabelLabel = "تسمية البضائع",
                npcQuantityLabel = "الكمية",
                npcPriceLabel = "سعر الوحدة",
                npcDeliveryLabel = "طريقة التسليم",
                deliveryBoth = "لقاء وتسليم سري",
                deliveryMeeting = "مقابلة وجهاً لوجه فقط",
                deliveryDrop = "تسليم مخفي فقط",
                npcScamChanceLabel = "نسبة احتمال خداع التاجر (%)",
                npcPedModelLabel = "موديل شخصية الـ NPC",
                npcRatingLabel = "التقييم المعروض",
                npcRatingCountLabel = "عدد التقييمات المعروضة",
                npcTradesLabel = "الصفقات الناجحة المعروضة",
                npcVerifiedLabel = "تاجر موثوق",
                npcScammerLabel = "محتال معروف",
                npcEnabledLabel = "مُفعل",
            },
            interrogationSettings = {
                section = "استجواب",
                generalGroup = "عام",
                consentGroup = "حماية اللاعب",
                objectGroup = "الأشياء",
                grabGroup = "السيطرة",
                sessionGroup = "الجلسة",
                dispatchGroup = "تنبيهات الشرطة",
                loggingGroup = "تسجيل السجلات",
                securityGroup = "الأمان",
                presentationGroup = "العرض",
                enabledLabel = "تفعيل نظام الاستجواب",
                enabledDescription = "السماح للاعبين بتقييد الآخرين على كراسي الاستجواب واستخدام الأدوات عليهم.",
                consentRequiredLabel = "يتطلب الموافقة",
                consentRequiredDescription = "يمكن للاعبين الذين وافقوا فقط أن يصبحوا ضحايا. لا توجد طريقة أخرى للموافقة، لذا يجب استخدام الإعداد أدناه.",
                consentDefaultLabel = "موافقة تلقائية افتراضية",
                consentDefaultDescription = "تبدأ الشخصيات الجديدة بموافقة مفعلة بدلاً من الرفض.",
                globalIntensityLabel = "شدة التأثير",
                globalIntensityDescription = "تتحكم في تأثيرات الشاشة والجسيمات والصوت. 0 لإيقافها تماماً.",
                maxPerPlayerLabel = "الأجسام لكل لاعب",
                maxPerPlayerDescription = "عدد الكراسي والعربات التي يمكن للاعب واحد وضعها. 0 تعني بلا حدود.",
                maxGlobalLabel = "الأجسام على مستوى الخادم",
                maxGlobalDescription = "إجمالي عدد الأجسام المسموح بوضعها في وقت واحد. 0 تعني بلا حدود.",
                placementDistanceLabel = "مسافة الوضع",
                placementDistanceDescription = "أقصى مسافة يمكن وضع الجسم فيها عن اللاعب، بالمتر.",
                interactDistanceLabel = "مسافة التفاعل",
                interactDistanceDescription = "أقرب مسافة يجب أن يكون فيها اللاعب لاستخدام الكرسي أو العربة، بالمتر.",
                inactivityMinutesLabel = "الإزالة التلقائية بعد",
                inactivityMinutesDescription = "عدد دقائق عدم الاستخدام قبل اختفاء الجسم الموضوع. 0 يحافظ عليه للأبد.",
                persistObjectsLabel = "الاحتفاظ بالأجسام بعد إعادة التشغيل",
                persistObjectsDescription = "يتم استعادة الأجسام الموضوعة من قاعدة البيانات عند عودة الخادم.",
                grabEnabledLabel = "تفعيل الإمساك",
                grabEnabledDescription = "السماح للاعبين بالسيطرة على لاعب آخر وحمله بعيداً.",
                grabItemLabel = "العنصر المطلوب",
                grabItemDescription = "العنصر الذي يحتاجه المهاجم للإمساك بشخص ما. اترك الحقل فارغاً لعدم اشتراط أي عنصر.",
                grabAngleLabel = "زاوية الاقتراب",
                grabAngleDescription = "أقصى زاوية جانبية مسموح بها للاعب للوقوف خلف المهاجم مباشرة، بالدرجات.",
                grabHealthBelowLabel = "حد الصحة",
                grabHealthBelowDescription = "الضحية التي تقل صحتها عن هذا الحد يمكن الإمساك بها دون تقييدها. 0 يعطل هذه الخاصية.",
                grabCooldownLabel = "فترة الانتظار بعد الفشل",
                grabCooldownDescription = "عدد الثواني قبل إمكانية محاولة الإمساك مرة أخرى بعد فشل المحاولة.",
                grabVehiclesLabel = "المركبات المسموح بها",
                grabVehiclesDescription = "طرازات المركبات التي يمكن تحميل الضحية الممسوك بها داخلها.",
                carryEnabledLabel = "السماح بالحمل",
                carryEnabledDescription = "السماح للمهاجم بحمل الضحية على كتفه.",
                restrictVisionLabel = "تقييد رؤية الضحية",
                restrictVisionDescription = "تعتيم شاشة الضحية أثناء نقلها.",
                escapeEnabledLabel = "السماح بمحاولات الهروب",
                escapeEnabledDescription = "السماح للضحية التي يتم نقلها بمحاولة التحرر.",
                escapeSecondsLabel = "مدة الهروب",
                escapeSecondsDescription = "عدد الثواني التي يجب على الضحية فيها الضغط على المفتاح للتحرر.",
                maxDurationLabel = "المدة القصوى",
                maxDurationDescription = "عدد الدقائق التي تنتهي بعدها الجلسة تلقائياً.",
                warnMinutesLabel = "تحذير قبل النهاية",
                warnMinutesDescription = "عدد الدقائق المتبقية قبل الحد الأقصى حيث يتم تحذير الطرفين.",
                idleMinutesLabel = "التحرير عند الخمول",
                idleMinutesDescription = "عدد دقائق عدم التفاعل قبل تحرير الضحية.",
                selfReleaseMinutesLabel = "التحرر الذاتي بعد",
                selfReleaseMinutesDescription = "عدد دقائق عدم تفاعل المهاجم قبل أن تتمكن الضحية من تحرير نفسها.",
                graceSecondsLabel = "مهلة بعد قطع الاتصال",
                graceSecondsDescription = "عدد الثواني التي تظل فيها الضحية مقيدة عندما يغادر المهاجم الخادم.",
                rescueEnabledLabel = "السماح بعمليات الإنقاذ",
                rescueEnabledDescription = "السماح للاعبين غير المشاركين بتحرير الضحية المقيدة.",
                rescueSecondsLabel = "مدة الإنقاذ",
                rescueSecondsDescription = "عدد الثواني التي يحتاجها المنقذ لفك قيود الضحية.",
                rescueItemLabel = "عنصر الإنقاذ",
                rescueItemDescription = "العنصر الذي يحتاجه المنقذ. اترك الحقل فارغاً لعدم اشتراط أي عنصر.",
                allowInventoryLabel = "الضحية تحتفظ بالحقيبة",
                allowInventoryDescription = "يمكن للضحية المقيدة أن تفتح حقيبتها.",
                dispatchEnabledLabel = "تفعيل تنبيهات الشرطة",
                dispatchEnabledDescription = "الإبلاغ عن عمليات الاختطاف والاستجواب لخدمات الطوارئ.",
                dispatchAdapterLabel = "نظام التنبيه",
                dispatchAdapterDescription = "نظام الإرسال الذي يتلقى البلاغات.",
                dispatchJobsLabel = "الوظائف المستلمة",
                dispatchJobsDescription = "الوظائف التي تتلقى التنبيه.",
                dispatchGrabChanceLabel = "فرصة الإمساك",
                dispatchGrabChanceDescription = "النسبة المئوية لاحتمالية الإبلاغ عن عملية إمساك.",
                dispatchFixateChanceLabel = "فرصة التقييد",
                dispatchFixateChanceDescription = "النسبة المئوية لاحتمالية الإبلاغ عن تقييد شخص إلى كرسي.",
                dispatchToolChanceLabel = "فرصة استخدام الأدوات",
                dispatchToolChanceDescription = "النسبة المئوية لاحتمالية الإبلاغ عن استخدام أداة.",
                dispatchWitnessLabel = "تطلب وجود شاهد",
                dispatchWitnessDescription = "الإبلاغ فقط عندما يكون لاعب آخر قريباً بما يكفي للملاحظة.",
                dispatchWitnessRadiusLabel = "نطاق الشاهد",
                dispatchWitnessRadiusDescription = "مدى قرب الشاهد المطلوب، بالمتر.",
                dispatchCooldownLabel = "فترة انتظار التنبيه",
                dispatchCooldownDescription = "الثواني بين تنبيهين من نفس الجلسة.",
                dispatchInaccuracyLabel = "عدم دقة الموقع",
                dispatchInaccuracyDescription = "الأمتار التي يتم بها إزاحة الموقع المبلغ عنه عشوائياً. 0 يبلغ عن الموقع الدقيق.",
                loggingEnabledLabel = "تفعيل التسجيل",
                loggingEnabledDescription = "تسجيل عمليات الوضع، والإمساك، واستخدام الأدوات، والإطلاق، وإجراءات المسؤول.",
                logDatabaseLabel = "التسجيل في قاعدة البيانات",
                logDatabaseDescription = "كتابة كل إدخال إضافي في جدول سجل الاستجواب.",
                logRetentionLabel = "الاحتفاظ بسجلات الدخول",
                logRetentionDescription = "الأيام قبل حذف سجلات قاعدة البيانات. 0 يحتفظ بها للأبد.",
                pingToleranceLabel = "تفاوت المسافة",
                pingToleranceDescription = "الأمتار المضافة لكل فحص مسافة من جانب الخادم لامتصاص الـ Lag.",
                violationThresholdLabel = "عتبة الانتهاكات",
                violationThresholdDescription = "الانتهاكات الأمنية ضمن النافذة الزمنية قبل تفعيل رد الفعل. 0 يعطلها.",
                violationActionLabel = "رد الفعل على الانتهاكات",
                violationActionDescription = "ما يحدث بمجرد تجاوز اللاعب لعتبة الانتهاكات.",
                violationActionNone = "عدم فعل شيء",
                violationActionLog = "تسجيل فقط",
                violationActionKick = "طرد",
                violationActionCheating = "الإبلاغ كغش",
                particlesLabel = "المؤثرات الجزيئية",
                particlesDescription = "إظهار الدماء والشرر واللهب أثناء استخدام الأدوات.",
                soundLabel = "المؤثرات الصوتية",
                soundDescription = "تشغيل أصوات الأدوات للجميع في الجوار.",
                cameraWorkLabel = "حركة الكاميرا",
                cameraWorkDescription = "تحريك الكاميرا عند تقييد شخص ما وأثناء استخدام الأدوات.",
                screenEffectsLabel = "مؤثرات الشاشة",
                screenEffectsDescription = "اهتزاز، وميض، وتغبيش، وفلاتر ألوان على شاشة الضحية.",
                objectsSection = "أغراض الاستجواب",
                objectsEntry = "كائن",
                objectsEditLabel = "أغراض الاستجواب",
                objectsEditDescription = "وضع كراسي دائمة وعربات أدوات على الخريطة.",
                objectsEditButton = "تعديل الأغراض",
                objectsKindLabel = "نوع الغرض",
                objectsKindChair = "كرسي",
                objectsKindCart = "عربة أدوات",
                objectsModelLabel = "نموذج مادة",
                objectsPositionLabel = "الموقع",
                blockedZonesSection = "المناطق المحظورة",
                blockedZonesEntry = "منطقة",
                blockedZonesEditLabel = "المناطق المحظورة",
                blockedZonesEditDescription = "المناطق التي لا يُسمح فيها بوضع أي عنصر استجواب.",
                blockedZonesEditButton = "تعديل المناطق",
                blockedZonesZoneLabel = "محيط المنطقة",
                blockedZonesZoneDescription = "اسحب الزوايا لتحديد شكل المنطقة التي يُمنع وضع العناصر فيها.",
                toolsSection = "أدوات",
                toolsEntry = "أداة",
                toolsEditLabel = "أدوات",
                toolsEditDescription = "إضافة أو تعديل الأدوات التي يمكن استخدامها على الضحية.",
                toolsEditButton = "تعديل الأدوات",
                toolsItemLabel = "العنصر المطلوب",
                toolsConsumeLabel = "استهلاك مادة",
                toolsDamageLabel = "الضرر لكل استخدام",
                toolsHealthFloorLabel = "الحد الأدنى للصحة",
                toolsCooldownLabel = "وقت الانتظار بالثواني",
                toolsProgressLabel = "التقدم لكل استخدام",
                sessionsSection = "جلسات الاستجواب الجارية",
                sessionsEntry = "جلسة",
                sessionsEditLabel = "جلسات الاستجواب الجارية",
                sessionsEditDescription = "عرض من يتم استجوابه حالياً وإنهاء الجلسة إذا لزم الأمر.",
                sessionsEditButton = "عرض الجلسات",
                sessionsStateLabel = "الولاية",
                sessionsProgressLabel = "التقدم",
                orphansSection = "عناصر يتيمة",
                orphansEntry = "كائن",
                orphansEditLabel = "عناصر يتيمة",
                orphansEditDescription = "إزالة العناصر التي لم يظهر مالكها منذ فترة طويلة.",
                orphansEditButton = "تنظيف",
                sessionStates = {
                    binding = "جارٍ التقييد",
                    active = "نشط",
                    ending = "جارٍ الإنهاء",
                },
            },
        },
    },
}
