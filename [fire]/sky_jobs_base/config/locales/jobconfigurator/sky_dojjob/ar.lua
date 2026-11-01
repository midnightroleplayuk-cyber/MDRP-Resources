JobConfigLocales["sky_dojjob:ar"] = {
    Nui = {
        tablet = { apps = { doj_finance = "المالية" ,
                doj_conditions = "الشروط",
                doj_elections = "الانتخابات",
                doj_files = "مستكشف ملفات الحالة",
                doj_hearings = "جلسات الاستماع",
                doj_law = "رموز قانونية",
                doj_offences = "كتالوج غرامة",
                doj_shared_files = "المستندات المشتركة",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "إعداد الوصول إلى ملفات القضايا",
                description = "حدد من يمكنه الوصول إلى السجلات ومجال عمله. الرتب غير المعيّنة لا تملك صلاحية الوصول.",
                status = {
                    unpublished = "لم يُنشر توزيع الصلاحيات بعد",
                    conflict = "عالج التعيينات المكررة",
                    disabled = "لوحة DOJ معطلة",
                    incomplete = "عيّن رتبة واحدة على الأقل",
                    ready = "جاهز للحفظ",
                },
                steps = {
                    tabletTitle = "تفعيل لوحة DOJ",
                    tabletText = "يجب تفعيل اللوحة لفتح تطبيقات ملفات القضايا.",
                    gradesTitle = "تعيين رتب DOJ",
                    gradesText = "اختر مجال سجلات واحدًا لكل رتبة يجب أن تحصل على صلاحية الوصول.",
                    publishTitle = "النشر والحفظ",
                    publishText = "يُجهّز إصدار جديد من توزيع الصلاحيات تلقائيًا بعد كل تغيير في التعيينات.",
                },
                grades = {
                    title = "تعيينات الرتب",
                    description = "اختر مجالًا واحدًا لكل رتبة. اختر بدون وصول للرتب التي يجب أن يبقى وصولها محظورًا.",
                    search = "البحث عن الرتب",
                    conflict = "إحدى الرتب معيّنة لأكثر من مجال. اختر مجالًا واحدًا أو بدون وصول لحل التعارض.",
                    notFound = "لم تعد موجودة في إطار العمل",
                    noResults = "لا توجد رتبة مطابقة.",
                    empty = "لم تُعثر على رتب للوظيفة المحددة في DOJ.",
                    emptyHint = "أنشئ رتب DOJ في إطار العمل أولًا، ثم أعد فتح أداة الإعداد.",
                    gradeColumn = "الرتبة",
                    domainColumn = "مجال السجلات",
                    noAccess = "بدون وصول",
                    chooseDomain = "حل التعيين",
                    assigned = "رتب معيّنة",
                },
                publish = {
                    saveHint = "انقر على حفظ في الأعلى لتطبيق التغييرات. يمكن للاعبين بعدها إعادة التحقق من صلاحية وصولهم.",
                },
            },
            registryFiles = { licenseType = "نوع الترخيص", licenseLabel = "اسم السجل", marriages = "سجل الزواج" },
            features = {
                dojHandovers = {
                    label = "الإحالات",
                    description = "يفعّل الإحالات والقرارات القضائية وتقارير التنفيذ. تبقى المستندات والمشاركة متاحة.",
                },
                dojBodycamRequests = {
                    label = "طلبات تسجيلات كاميرا الجسم",
                    description = "اطلب تسجيلات الشرطة. يتطلب الإحالات؛ تبقى التسجيلات المحفوظة متاحة بشكل مستقل.",
                },
                dojFinance = { label = "المالية", description = "أرصدة الفصائل وتحويلات الخزينة وسجل المعاملات." },
                dojConditions = {
                    description = "تفعيل الظروف المنظمة والأدلة والمواعيد النهائية ومتابعة الانتهاكات.",
                    label = "الشروط",
                },
                dojCourtroom = {
                    description = "تفعيل جلسات قاعة المحكمة الحية الآمنة، وعرض الأدلة، والتفاعلات غرفة القائم على الدور.",
                    label = "قاعة محكمة حية",
                },
                dojElections = {
                    description = "تفعيل إدارة الانتخابات وتأمين التصويت في أكشاك التصويت المسجلة.",
                    label = "الانتخابات",
                },
                dojHearings = {
                    description = "تفعيل جدولة قاعة المحكمة ، وتسجيل الوصول ، وضوابط حالة السمع الموثوقة.",
                    label = "جلسات الاستماع",
                },
                dojLegalCodes = {
                    description = "تفعيل الكتب القانونية وتحرير النصوص الغنية وتاريخ المراجعة.",
                    label = "المدونات القانونية",
                },
                dojOffences = {
                    description = "تفعيل كتالوج الجريمة المدمجة ومعاينة آلة حاسبة.",
                    label = "كتالوج فاين",
                },
                dojPrinters = {
                    description = "تفعيل الطابعات المادية والبنية التحتية وقت التشغيل.",
                    label = "الطابعات",
                },
                dojPublicDisplays = {
                    description = "تفعيل البيانات الحية تصفية الخصوصية لشاشات المحكمة.",
                    label = "عروض قاعة المحكمة العامة",
                },
                dojTablet = {
                    description = "تفعيل الوصول إلى تطبيقات الكمبيوتر اللوحي DOJ.",
                    label = "DOJ قرص",
                },
                dojTaxes = {
                    description = "جمع ضرائب المركبات والمنزل بشكل دوري من اللاعبين عبر الإنترنت.",
                    label = "ضرائب الأصول",
                },
            },
            settingSections = {
                finance = "المالية",
                courtroom = "قاعة المحكمة",
                registries = "السجل",
                courthouses = "دور المحاكم",
                general = "عام",
                legalCodes = "المدونات القانونية",
                offences = "كتالوج فاين",
                recordsAccess = "الوصول إلى ملف القضية",
                tablet = "تابلت",
                taxes = "الضرائب",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "سجلات التراخيص",
                    description = "اختر التراخيص التي يحق لوزارة العدل إصدارها. يظهر كل إدخال كسجل مستقل. حذف الإدخال لا يلغي التراخيص الحالية.",
                },
                dojRegistryAccess = {
                    ["label"] = "الوصول إلى ملفات السجل",
                    ["description"] = "عدّل الوصول إلى السجلات في config/registry. تستخدم القائمة الفارغة إعدادات الملفات الافتراضية. تُعدّل الحقول ووظائف الخادم والعميل في ملفات Lua.",
                },
                dojTreasuryJob = { label = "وظيفة الخزينة", description = "الوظيفة التي يستقبل حسابها المشترك التحصيلات ويدفع التحويلات." },
                dojFinanceJobs = { label = "الفصائل الظاهرة", description = "معرّفات الوظائف المسجلة في عرض الحسابات. يظهر حساب الخزينة دائمًا." },
                dojFinanceLimit = { label = "حد المعاملة", description = "الحد الأقصى لكل تحويل أو تحصيل." },
                dojFinePaymentMode = { label = "دفع غرامات الشروط", description = "دفع بنكي مباشر أو فاتورة خارجية. إنشاء الفاتورة لا يؤكد الدفع.", options = { bank = "دفع بنكي", billing = "فاتورة" } },
                dojFineSociety = { label = "مستلم الغرامات", description = "الوظيفة التي يستقبل حسابها المشترك غرامات الشروط." },
                dojCourtroomBoardMove = {
                    label = "نقل قاعة المحكمة المجلس",
                    description = "المفتاح الافتراضي لانتزاع أو إطلاق لوحة متنقلة (على سبيل المثال F). يمكن للاعبين تجاوزها في روابط مفاتيح FiveM. الحركة مؤقتة ويتم إعادة تعيينها بعد إعادة التشغيل.",
                },
                dojCourtroomGavel = {
                    label = "القاضي helel",
                    description = "نموذج Gavel ، مرفق اليد ، الرسوم المتحركة ، أنماط الصوت والإضراب. تنطبق التغييرات أيضًا دون إعادة التشغيل.",
                },
                dojHearingParticipantRoles = {
                    label = "أدوار المشاركين",
                    description = "الأدوار الافتراضية: المدعى عليه ، الشاهد ، المحلف ، القاضي. أضف مفاتيح أدوار صغيرة مخصصة هنا (حتى 24 حرفًا ، يُسمح بالأسفل). حافظ على القاضي. الأدوار المخصصة لا تمنح أذونات القاضي أو هيئة المحلفين.",
                },
                dojWarrantTemplateCodes = {
                    label = "رموز قالب أمر",
                    description = "رموز القوالب الموضحة تحت PD أمر بعد التوقيع القضائي والمشاركة. الافتراضيات: HB ، DB ، RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ سجلات",
                    description = "تفعيل وتسمية سجلات DOJ ، ثم تعيين الوصول إلى المهنة والتخليص. لا تزال أذونات الدور الحالية DOJ سارية. تتم إدارة سجلات RP المخصصة في قاعدة المهن.",
                },
                dojCourthouseBlipCategory = {
                    description = "تسمية الفئة المستخدمة لمحات خريطة المحكمة.",
                    label = "فئة Blip",
                },
                dojCourthouseBlipColor = {
                    description = "لون الخريطة المستخدمة في المحاكم.",
                    label = "لون Blip",
                },
                dojCourthouseBlipScale = {
                    description = "مقياس الخريطة المستخدمة لمحات المحكمة.",
                    label = "مقياس Blip",
                },
                dojCourthouseBlipShortRange = {
                    description = "لا تظهر سوى لقطات من المحكمة على المدى القصير.",
                    label = "قصير المدى",
                },
                dojCourthouseBlipSprite = {
                    description = "خريطة العفريت المستخدمة في المحاكم.",
                    label = "نمط الأيقونة (Blip sprite)a40074848905d12c107f984aac5d9776",
                },
                dojLegalBookItem = {
                    description = "عنصر المخزون لإصدار رمز قانوني ثابت. الاستخدام الأول يحفظ محتوياته وتاريخه ؛ يتطلب عناصر فردية مع البيانات الوصفية.",
                    label = "بند كتاب الشفرة القانونية",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات إنشاء الكتب القانونية.",
                    label = "إنشاء كتاب cooldown",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات إنشاء المراجعة.",
                    label = "إنشاء تنقيح cooldown",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات حذف الكتب القانونية.",
                    label = "حذف كتاب cooldown",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات حذف المراجعة.",
                    label = "احذف تنقيح cooldown",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات الحصول على كتاب قانوني.",
                    label = "تحميل كتاب cooldown",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات الحصول على قائمة الكتب القانونية.",
                    label = "تحميل مكتبة cooldown",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "الحد الأدنى من المهلة الزمنية المستخدمة لطلبات الوثائق الكبيرة.",
                    label = "مهلة طلب كبيرة في ميلي ثانية",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "الحد الأقصى لعدد الأحرف المسموح بها في اختصار الكتاب القانوني.",
                    label = "أقصى طول للاختصار",
                },
                dojLegalMaxBookTitleLength = {
                    description = "الحد الأقصى لعدد الأحرف المسموح بها في عنوان الكتاب القانوني.",
                    label = "الحد الأقصى لطول عنوان الكتاب",
                },
                dojLegalMaxContentBytes = {
                    description = "الحد الأقصى للحجم التسلسلي لنسخة واحدة كاملة من الكتاب القانوني.",
                    label = "الحد الأقصى لحجم المحتوى بالبايت",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "الحد الأقصى لطول العنوان المقبول أثناء استيراد الفقرات الهيكلية القديمة.",
                    label = "الحد الأقصى لطول عنوان الفقرة القديمة",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "الحد الأقصى لعدد الفقرات المنظمة المقبولة خلال الواردات القديمة.",
                    label = "الحد الأقصى للفقرات الموروثة لكل كتاب",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "الحد الأقصى لعدد الأحرف المسموح بها في ملاحظة المراجعة.",
                    label = "الحد الأقصى لطول مذكرة المراجعة",
                },
                dojLegalMaxRichTextNodes = {
                    description = "الحد الأقصى لعدد عقد المحرر المسموح بها في تنقيح واحد.",
                    label = "الحد الأقصى لعقد النص الغني",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "الحد الأقصى لعرض النطاق الترددي لكل لاعب يستخدم لنقل الوثائق القانونية الكبيرة.",
                    label = "معدل النقل بالبايت في الثانية",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات إعادة ترتيب الكتب القانونية.",
                    label = "إعادة ترتيب الكتب cooldown",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين تحديثات البيانات الوصفية القانونية للكتاب.",
                    label = "تحديث كتاب cooldown",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "الحد الأقصى لعدد المراجعات التي تم تحميلها عند فتح كتاب قانوني.",
                    label = "تاريخ المراجعة المرئية",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "الحد الأدنى ميلي ثانية بين المعاينات آلة حاسبة من جانب الخادم.",
                    label = "آلة حاسبة cooldown",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين طلبات الفهرس.",
                    label = "تحميل كتالوج cooldown",
                },
                dojOffenceMaxSelection = {
                    description = "الحد الأقصى لعدد الجرائم المدرجة في معاينة آلة حاسبة واحدة.",
                    label = "الحد الأقصى للاختيار",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "الحد الأدنى من ميلي ثانية بين التغييرات في كتالوج الجريمة.",
                    label = "كتالوج تحرير cooldown",
                },
                dojOffenceMirandaWarning = {
                    description = "تحذير مخصص يظهر في الفهرس الدقيق. اترك فارغًا لاستخدام النص القياسي في اللغة المحددة.",
                    label = "تحذير ميراندا",
                },
                dojPrimaryColor = {
                    description = "اللون الرئيسي المستخدمة من قبل DOJ مجموعة المهنة والكمبيوتر اللوحي.",
                    label = "اللون الأساسي",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "هذه الدرجات تعمل مع إدارة المحكمة وسجلات السجل.",
                    label = "إدارة المحكمة",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "هذه الدرجات تعمل مع السجلات والقرارات القضائية.",
                    label = "السلطة القضائية",
                },
                dojRecordsMappingVersion = {
                    description = "نشر تنقيح من الصف إلى السجلات نطاق التعيين. قيمة فارغة تبقي السجلات الوصول إلى تعطيل.",
                    label = "إصدار المنشور",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "هذه الدرجات تعمل مع سجلات الادعاء.",
                    label = "الادعاء",
                },
                dojTabletRequireDuty = {
                    description = "فقط على واجب DOJ الموظفين قد فتح التطبيق رمز قانوني.",
                    label = "يتطلب واجبًا",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "العملة المباشرة",
                },
                dojTaxHouseAmount = {
                    description = "يتم فرض رسوم على كل منزل يملكه لاعب.",
                    label = "الضريبة لكل منزل",
                },
                dojTaxInitialDelaySeconds = {
                    description = "الثواني للانتظار قبل التحصيل الأول عندما لا يتم تخزين دورة ضريبية سابقة.",
                    label = "التأخير الأولي",
                },
                dojTaxIntervalMinutes = {
                    description = "دقائق بين دورات تحصيل ضريبة الأصول التلقائي.",
                    label = "فترة الجمع",
                },
                dojTaxNotifyPlayer = {
                    description = "إخطار اللاعبين بعد التحصيل المباشر أو تقديم فاتورة أو عدم كفاية الأموال.",
                    label = "إعلام اللاعبين",
                },
                dojTaxPaymentMode = {
                    description = "استخدم رصيد البنك / المال المحدد مباشرة أو قدم فاتورة واحدة من مجتمع قاعدة سكاي لكل لاعب خاضع للضريبة ودورة ضريبية.",
                    label = "طريقة الدفع",
                    options = {
                        bills = "Sky Base bills",
                        direct = "رصيد البنك / المال",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ مهنة يتلقى حساب المجتمع الذي تم تكوينه جميع إيرادات الضرائب التي تم جمعها.",
                    label = "DOJ مهنة المستلم",
                },
                dojTaxVehicleAmount = {
                    description = "المبلغ المدفوع عن كل سيارة يملكها لاعب.",
                    label = "الضريبة لكل مركبة",
                },
            },
            printers = {
                groups = {
                    paper = "الورق",
                    ink = "الحبر",
                    general = "الطابعة",
                    printing = "الطباعة والوصول",
                    placement = "المجسم والموضع",
                },
                actions = {
                    selectExisting = "اختيار طابعة موجودة",
                    selectExistingHint = "وجّه نحو الطابعة. Enter: اختيار · Esc: إلغاء",
                    add = "إضافة طابعة",
                    open = "فحص الطابعة",
                    place = "وضع الطابعة",
                    setPosition = "استخدام الموقع الحالي",
                },
                classes = {
                    office = "مكتبية",
                    professional = "احترافية",
                    standard = "قياسية",
                },
                description = "إعداد الطابعات والمستلزمات وقوائم الانتظار والوصول والمواضع لهذه الوظيفة.",
                fieldDescriptions = {
                    paperCapacity = "الحد الأقصى لمخزون الورق في كل طابعة لهذه الوظيفة.",
                    paperEnabled = "عند التفعيل، تبدأ طابعات هذه الوظيفة فارغة وتتطلب عنصر التعبئة المشترك.",
                    refillAmount = "كمية الورق المضافة إلى طابعة لهذه الوظيفة عند استخدام عنصر التعبئة المشترك.",
                    refillItem = "الاسم الداخلي لعنصر المخزون الذي يُستهلك عند تعبئة طابعة لهذه الوظيفة.",
                },
                fields = {
                    active = "مفعّلة",
                    class = "الفئة",
                    heading = "الاتجاه",
                    id = "معرّف ثابت",
                    label = "الاسم",
                    maxQueue = "سعة قائمة الانتظار",
                    minimumGrade = "الرتبة الدنيا",
                    paperCapacity = "سعة الورق",
                    paperEnabled = "اشتراط تعبئة الورق",
                    propModel = "نموذج المجسم",
                    refillAmount = "كمية الورق لكل عنصر تعبئة",
                    refillItem = "عنصر التعبئة",
                    deleteCopiesAfterRestart = "حذف النسخ بعد إعادة التشغيل",
                    deleteCopiesAfterRestartHint = "حذف المطبوعات غير المستلمة عند إعادة تشغيل خدمة الطباعة.",
                    spawnProp = "إنشاء المجسم",
                    speed = "سرعة الطباعة",
                    status = "الحالة",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "الفئة: {class}",
                    paper = "الورق: {paper} / {capacity}",
                    queue = "قائمة الانتظار: {queue} / {maxQueue}",
                    status = "الحالة: {status}",
                    title = "الطابعة",
                },
                messages = {
                    grade_too_low = "رتبتك لا تسمح باستخدام هذه الطابعة.",
                    invalid_amount = "كمية التعبئة غير صالحة.",
                    missingModel = "اختر نموذج طابعة صالحًا قبل وضعه.",
                    missing_refill_item = "ليس لديك عنصر التعبئة المحدد.",
                    no_refill_printer = "لا توجد طابعة متاحة قريبة تتطلب الورق.",
                    paper_capacity_exceeded = "ستتجاوز الكمية سعة الورق.",
                    paper_disabled = "استهلاك الورق معطّل لهذه الطابعة.",
                    paper_full = "درج الورق في هذه الطابعة ممتلئ بالفعل.",
                    printer_inactive = "هذه الطابعة معطّلة.",
                    printer_not_found = "لم تعد هذه الطابعة موجودة.",
                    refill_cooldown = "انتظر قليلًا قبل التعبئة مرة أخرى.",
                    refilled = "تمت إضافة {amount} ورقة. المخزون: {paper} / {capacity}.",
                    too_far_away = "اقترب من الطابعة.",
                    unavailable = "الطابعة غير متاحة.",
                    wrong_job = "وظيفتك لا تسمح باستخدام هذه الطابعة.",
                },
                settings = {
                    description = "تنطبق هذه الإعدادات على جميع الطابعات المخصصة لهذه الوظيفة.",
                    title = "إعدادات الطابعات المشتركة للوظيفة",
                },
                statuses = {
                    maintenance = "صيانة",
                    offline = "غير متصلة",
                    online = "متصلة",
                },
                title = "الطابعات",
                values = {
                    disabled = "معطّل",
                    enabled = "مفعّل",
                    selectItem = "اختيار عنصر",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "تكوين DOJ المهن، ومواقع المحكمة، والتطبيق القانوني رمز.",
                    title = "وزارة العدل المهن",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "دار المحكمة",
                    entryPluralLabel = "دور المحاكم",
                    label = "دور المحاكم",
                },
            },
            extensions = {
                invalidSelection = "اختيار غير صالح: {value}",
                trainingSettings = {
                    description = "قم بتكوين الوصول إلى التدريب والتسجيل والموافقات وتخطيط الدورة التدريبية لهذه الوظيفة.",
                    label = "إعدادات التدريب",
                },
            },
            locations = {
                stationPosition = "موقع / علامة خريطة",
                stationPositionHint = "النقطة الرئيسية لموقع هذه الوظيفة. إذا تم تفعيل علامة الخريطة (Blip) تحت الوظيفة ← العلامات، فستظهر هنا.",
                addCourtroom = "إضافة قاعة المحكمة",
                courtroom = "قاعة المحكمة",
                courtroom_display_desk_27 = "عرض أدلة قاعة المحكمة - 27 بوصة رصد مكتب",
                courtroom_display_wall_55 = "عرض أدلة قاعة المحكمة - 55 بوصة الجدار TV",
                courtroom_display_wall_75 = "عرض أدلة قاعة المحكمة - 75 بوصة الجدار TV",
                courtroom_display_wall_100 = "عرض أدلة قاعة المحكمة - 100 بوصة الجدار TV",
                courtroom_display_wall_120 = "عرض أدلة قاعة المحكمة - 120 بوصة الجدار TV",
                courtroom_display_wall_150 = "عرض أدلة قاعة المحكمة - 150 بوصة الجدار TV",
                courtroom_display_board_93 = "المجلس التفاعلي قاعة المحكمة – 150 بوصة موقف المحمول",
                courtroom_display_projection = "عرض أدلة قاعة المحكمة - شاشة عرض 4.5 م",
                courtroom_judge_mic = "قاعة المحكمة - ميكروفون القاضي",
                courtroom_jury_room = "قاعة المحكمة – قاعة هيئة المحلفين",
                courtroom_room = "قاعة المحكمة - الجمهور / مركز الغرفة",
                courtroom_witness = "قاعة المحكمة – منصة الشهود",
                electionBooth = "بوث التصويت",
                publicDisplayDesk27 = "العرض العام - 27 بوصة مكتب مراقب",
                publicDisplayTerminal43 = "العرض العام - 43 بوصة محطة الطابق",
                publicDisplayWall55 = "العرض العام - 55 بوصة الجدار TV",
                publicDisplayWall75 = "العرض العام - 75 بوصة الجدار TV",
                publicDisplayWall100 = "العرض العام - 100 بوصة الجدار TV",
                publicDisplayWall120 = "العرض العام - 120 بوصة الجدار TV",
                publicDisplayWall150 = "العرض العام - 150 بوصة الجدار TV",
                publicDisplayProjection = "العرض العام - 4.5 م شاشة الإسقاط",
                publicLegalCode = "المدونة القانونية العامة",
            },
            settingGroups = {
                dojWarrants = {
                    label = "الأوامر القضائية",
                },
                dojAccess = {
                    label = "الوصول",
                },
                dojCourthouseBlip = {
                    label = "خريطة blip",
                },
                dojLegalBooks = {
                    label = "الكتب",
                },
                dojLegalItem = {
                    label = "عنصر الحقيبة",
                },
                dojLegalRateLimits = {
                    label = "حدود السعر",
                },
                dojLegalRevisions = {
                    label = "التنقيحات",
                },
                dojLegalTransfers = {
                    label = "وثائق كبيرة",
                },
                dojOffenceCalculation = {
                    label = "الحاسبة",
                },
                dojOffenceRateLimits = {
                    label = "حدود السعر",
                },
                dojOffenceMiranda = {
                    label = "إرشادات الفهرس",
                },
                dojOffenceSource = {
                    label = "مصدر الفهرس",
                },
                dojRecordsGradeBindings = {
                    description = "قم بتعيين كل درجة DOJ متاحة إلى نطاق سجلات واحد بالضبط ، ثم نشر التعيين.",
                    label = "نطاقات الدرجات والسجلات",
                },
                dojTaxPayment = {
                    label = "طريقة الدفع",
                },
                dojTaxRates = {
                    label = "الأسعار",
                },
                dojTaxSchedule = {
                    label = "الجدول الزمني",
                },
                dojLegalContentLimits = {
                    label = "حدود المحتوى",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "عقود موثقة",
                    powers_of_attorney = "توكيل رسمي",
                    name_changes = "تغييرات الاسم",
                    company_registry = "سجل الشركة",
                    association_registry = "سجل رابطة التسجيل",
                    licensing = "الترخيص",
                    administrative_decisions = "القرارات الإدارية",
                    administrative_objections = "الاعتراضات الإدارية",
                },
            },
            gavel = {
                enabled = "مفعّل",
                cooldown = "تبريد الزناد (ms)",
                defaultPreset = "نمط الإضراب الافتراضي",
                prop = "دعامة Gavel",
                model = "اسم النموذج",
                bone = "العظام اليد ID",
                offset = "الأوفست (بالمتر)",
                rotation = "دوران (درجة)",
                presets = "أنماط الإضراب",
                single = "إضراب واحد",
                double = "إضراب مزدوج",
                strikes = "عدد الإضرابات",
                interval = "فترة الإضراب (ms)",
                impact = "تأخير الصوت (مللي ثانية)",
                audio = "الصوت",
                asset = "أصول الصوت",
                volume = "مقدار",
                animation = "الحركة",
                dict = "قاموس الحركة",
                clip = "اسم الحركة",
                duration = "مدة الحركة (ms)",
                flag = "أعلام الرسوم المتحركة",
                x = "X",
                y = "Y",
                z = "Z",
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
        },
    },
}
