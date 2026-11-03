JobConfigLocales["sky_dojjob:cn"] = {
    Nui = {
        tablet = { apps = { doj_finance = "财务" ,
                doj_conditions = "病症",
                doj_elections = "选举 选举 选举 选举",
                doj_files = "案例文件浏览器",
                doj_hearings = "听讯",
                doj_law = "法律法典",
                doj_offences = "精细目录",
                doj_shared_files = "共享文档",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "设置案件档案访问权限",
                description = "选择可访问档案的人员及其工作领域。未分配领域的职级没有访问权限。",
                status = {
                    unpublished = "权限分配尚未发布",
                    conflict = "解决重复分配",
                    disabled = "DOJ 平板已禁用",
                    incomplete = "请至少分配一个职级",
                    ready = "可以保存",
                },
                steps = {
                    tabletTitle = "启用 DOJ 平板",
                    tabletText = "必须启用平板才能打开案件档案应用。",
                    gradesTitle = "分配 DOJ 职级",
                    gradesText = "为每个应获得访问权限的职级选择且仅选择一个档案领域。",
                    publishTitle = "发布并保存",
                    publishText = "每次更改分配后，系统会自动准备新的权限分配版本。",
                },
                grades = {
                    title = "职级分配",
                    description = "每个职级选择一个领域。对于应禁止访问的职级，请选择无访问权限。",
                    search = "搜索职级",
                    conflict = "某职级被分配了多个领域。请选择一个领域或无访问权限以解决冲突。",
                    notFound = "框架中已不存在",
                    noResults = "未找到匹配的职级。",
                    empty = "未找到已配置的 DOJ 职业的职级。",
                    emptyHint = "请先在框架中创建 DOJ 职级，再重新打开配置工具。",
                    gradeColumn = "职级",
                    domainColumn = "档案领域",
                    noAccess = "无访问权限",
                    chooseDomain = "解决分配冲突",
                    assigned = "个职级已分配",
                },
                publish = {
                    saveHint = "点击顶部的保存以应用更改。随后玩家可以重新检查自己的访问权限。",
                },
            },
            registryFiles = { licenseType = "许可证类型", licenseLabel = "登记簿名称", marriages = "婚姻登记簿" },
            features = {
                dojHandovers = {
                    label = "移交",
                    description = "启用任务移交、司法裁决和执行报告。文档与共享功能仍然可用。",
                },
                dojBodycamRequests = {
                    label = "执法记录仪录像申请",
                    description = "申请警方录像。需要启用移交；已保存的录像仍可独立使用。",
                },
                dojFinance = { label = "财务", description = "派系余额、国库转账和交易记录。" },
                dojConditions = {
                    description = "启动结构性条件、证据、最后期限和违约后续行动。",
                    label = "病症",
                },
                dojCourtroom = {
                    description = "启动现场庭审、证据陈述和基于角色的房间互动。",
                    label = "审判室现场直播",
                },
                dojElections = {
                    description = "启动选举管理并在登记投票厢进行安全投票。",
                    label = "选举 选举 选举 选举",
                },
                dojHearings = {
                    description = "启动审判室的时间安排、报到和权威性的听讯状况控制。",
                    label = "听讯",
                },
                dojLegalCodes = {
                    description = "激活法律书籍、丰富文本编辑和修订历史。",
                    label = "法典法典法典",
                },
                dojOffences = {
                    description = "激活压缩犯罪目录和计算器预览 。",
                    label = "精细目录目录",
                },
                dojPrinters = {
                    description = "激活物理打印机及其运行时基础设施。",
                    label = "打印机",
                },
                dojPublicDisplays = {
                    description = "激活法院显示器的隐私过滤实时数据。",
                    label = "公共审判室展露",
                },
                dojTablet = {
                    description = "启用访问 DOJ 平板应用程序",
                    label = "DOJ 平板",
                },
                dojTaxes = {
                    description = "定期向网上玩家收取车辆税和房屋税。",
                    label = "资产资产税税",
                },
            },
            settingSections = {
                finance = "财务",
                courtroom = "审判室",
                registries = "登记册",
                courthouses = "法院法院",
                general = "一般的",
                legalCodes = "法典法典法典",
                offences = "精细目录目录",
                recordsAccess = "案件档案查阅",
                tablet = "平板电脑",
                taxes = "纳税税",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "许可证登记簿",
                    description = "选择 DOJ 可以颁发的许可证。每项许可证都有独立登记簿。删除登记项不会撤销现有许可证。",
                },
                dojRegistryAccess = {
                    ["label"] = "注册文件访问权限",
                    ["description"] = "设置 config/registry 中各登记簿的访问权限。列表为空时使用文件默认值。字段及服务端和客户端函数在 Lua 文件中编辑。",
                },
                dojTreasuryJob = { label = "国库职业", description = "其公共账户接收扣款并支付转账的职业。" },
                dojFinanceJobs = { label = "可见派系", description = "账户概览中可用的已注册职业标识。始终包含国库账户。" },
                dojFinanceLimit = { label = "交易限额", description = "每次转账或扣款的最高金额。" },
                dojFinePaymentMode = { label = "附加条件罚款支付", description = "直接银行扣款或外部账单。创建账单不表示已付款。", options = { bank = "银行支付", billing = "账单" } },
                dojFineSociety = { label = "罚款收款职业", description = "其公共账户接收附加条件罚款的职业。" },
                dojCourtroomBoardMove = {
                    label = "移动审判室板",
                    description = "抓取或释放移动版面( 例如 F) 的默认密钥。 玩家可以在 5M 密钥绑定中覆盖它。 移动是临时的, 重新启动后将重新发布 。",
                },
                dojCourtroomGavel = {
                    label = "谢尔法官",
                    description = "音效模型、 手挂、 动画、 音响和罢工模式。 变化也可以在不重新开始的情况下应用 。",
                },
                dojHearingParticipantRoles = {
                    label = "参与者作用",
                    description = "默认作用:被告、证人、陪审员、陪审法官。 在此添加自定义的小写角色键( 直至 24 保留法官。 自定义角色不允许法官或陪审团允许。",
                },
                dojWarrantTemplateCodes = {
                    label = "授权书模板代码",
                    description = "模板代码显示于 PD 司法签字和分享后签发的逮捕证。 HB,, DB,, RB. .",
                },
                dojRegistryCatalog = {
                    label = "DOJ 登记册登记册",
                    description = "启用和名称 DOJ 登记,然后确定工作准入和审批。 DOJ 任务权限仍然适用。自定义 RP 登记册在就业基地管理。",
                },
                dojCourthouseBlipCategory = {
                    description = "法院地图页使用的分类标签。",
                    label = "循环类别",
                },
                dojCourthouseBlipColor = {
                    description = "法院使用的地图颜色 。",
                    label = "闪点颜色",
                },
                dojCourthouseBlipScale = {
                    description = "法院翻页所用的地图比例尺 。",
                    label = "循环缩缩",
                },
                dojCourthouseBlipShortRange = {
                    description = "只显示短距离的法院页眉 。",
                    label = "短距离",
                },
                dojCourthouseBlipSprite = {
                    description = "法院使用的地图图示 。",
                    label = "光点精灵",
                },
                dojLegalBookItem = {
                    description = "固定法律编码版本的清册项目。 首用保存其内容和日期; 需要带有元数据的单个项目 。",
                    label = "法律法典书籍项目",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "法律书籍创建请求之间的最小秒数 。",
                    label = "创建书籍冷放",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "修改创建请求之间的最小秒数 。",
                    label = "创建修订版冷却创建",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "法律书籍删除请求之间的最小秒数。",
                    label = "删除书本冷放",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "修订删除请求之间的最低毫秒。",
                    label = "删除版本校正冷却",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "要求法律书籍之间 最小的毫秒",
                    label = "装入书簿冷放",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "法律手册清单要求之间 最小的毫秒",
                    label = "装入库冷却",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "大型文件请求使用的最低超时值。",
                    label = "大型请求超时( 毫秒)",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "法律手册缩写允许的最大字符数 。",
                    label = "缩写缩写最长长度",
                },
                dojLegalMaxBookTitleLength = {
                    description = "法律手册标题中允许的最大字符数 。",
                    label = "最大书书标题长度",
                },
                dojLegalMaxContentBytes = {
                    description = "一份完整的法律手册修订案的最大序列号。",
                    label = "最大内容大小( 字节)",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "输入遗产结构化段落时允许最大标题长度 。",
                    label = "最大遗留段落标题长度",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "在遗留进口过程中接受的有条理段落的最大数量。",
                    label = "每本书的最大遗产段落",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "修改注释中允许的最大字符数 。",
                    label = "最大订正注注解长度",
                },
                dojLegalMaxRichTextNodes = {
                    description = "在一次版本中允许的最大编辑节点数 。",
                    label = "最大丰富文本节点",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "用于转移大型法律文件的人均带宽限制。",
                    label = "以字字节/ 秒的传输率",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "法律书籍重新订购要求之间 最低的毫秒",
                    label = "重新订购书本 冷却",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "法律书籍元数据更新之间的最小秒数 。",
                    label = "更新书簿冷降",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "打开法律书时装入的最大修改数 。",
                    label = "可见修改历史",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "服务器侧计算预览之间的最小毫秒 。",
                    label = "计算计算器冷却",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "在目录请求之间最小的毫秒 。",
                    label = "加载目录冷放",
                },
                dojOffenceMaxSelection = {
                    description = "包含在计算器预览中的最大犯罪数量 。",
                    label = "最大选择",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "犯罪目录更改之间最小的毫秒。",
                    label = "目录编辑 冷调",
                },
                dojOffenceMirandaWarning = {
                    description = "精细目录中显示自定义警告。 留空以使用所选语言的标准文本 。",
                    label = "米兰达警告",
                },
                dojPrimaryColor = {
                    description = "DOJ专业组和平板电脑使用的主要颜色。",
                    label = "原色",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "这些职等与法院行政管理和登记记录有关。",
                    label = "法院行政",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "这些职等与司法记录和决定一起工作。",
                    label = "司法 司法机构",
                },
                dojRecordsMappingVersion = {
                    description = "发布对年级到记录域映射的修订版。 空值会让记录无法访问 。",
                    label = "出版物版本",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "这些职等与检方记录一起工作。",
                    label = "起诉 起诉",
                },
                dojTabletRequireDuty = {
                    description = "只有执勤的DOJ名雇员才能开通法律编码应用程序。",
                    label = "需要值班",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "直接货币直接货币",
                },
                dojTaxHouseAmount = {
                    description = "每栋房子的收费额由玩家拥有。",
                    label = "每户税",
                },
                dojTaxInitialDelaySeconds = {
                    description = "等待第一集之前的第二集,因为没有储存上一个税收周期。",
                    label = "初始延迟",
                },
                dojTaxIntervalMinutes = {
                    description = "资产税自动征收周期之间的时间间隔。",
                    label = "收集间隔间隔",
                },
                dojTaxNotifyPlayer = {
                    description = "在直接收集、提交账单或资金不足之后通知参与者。",
                    label = "通知玩家",
                },
                dojTaxPaymentMode = {
                    description = "直接使用选定的银行/资金余额,或向每个纳税人和纳税周期提交一份天空基地社会法案。",
                    label = "支付方式",
                    options = {
                        bills = "Sky Base bills",
                        direct = "银行/货币余额",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ 其配置社会账户接收所有税收的工作。",
                    label = "受援者 DOJ 工作",
                },
                dojTaxVehicleAmount = {
                    description = "每辆由玩家拥有的车辆的收费额。",
                    label = "每辆车辆征税",
                },
            },
            printers = {
                groups = {
                    paper = "纸张",
                    ink = "墨水",
                    general = "打印机",
                    printing = "打印与访问",
                    placement = "模型与位置",
                },
                actions = {
                    selectExisting = "选择现有打印机",
                    selectExistingHint = "瞄准打印机。Enter：选择 · Esc：取消",
                    add = "添加打印机",
                    open = "查看打印机",
                    place = "放置打印机",
                    setPosition = "使用当前位置",
                },
                classes = {
                    office = "办公",
                    professional = "专业",
                    standard = "标准",
                },
                description = "配置此职业的打印机、耗材、队列、访问权限和摆放位置。",
                fieldDescriptions = {
                    paperCapacity = "此职业每台打印机的最大纸张储量。",
                    paperEnabled = "启用后，此职业的打印机初始为空，需要使用统一的补充物品添加纸张。",
                    refillAmount = "使用统一的补充物品时，为此职业的打印机添加的纸张数量。",
                    refillItem = "为此职业的打印机补充纸张时消耗的背包物品内部名称。",
                },
                fields = {
                    active = "启用",
                    class = "类别",
                    heading = "朝向",
                    id = "固定标识",
                    label = "名称",
                    maxQueue = "队列容量",
                    minimumGrade = "最低职级",
                    paperCapacity = "纸张容量",
                    paperEnabled = "需要补充纸张",
                    propModel = "物件模型",
                    refillAmount = "每份补充物品的纸张数量",
                    refillItem = "补充物品",
                    deleteCopiesAfterRestart = "重启后删除副本",
                    deleteCopiesAfterRestartHint = "打印服务重启时删除尚未领取的打印件。",
                    spawnProp = "生成物件",
                    speed = "打印速度",
                    status = "状态",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "类别：{class}",
                    paper = "纸张：{paper} / {capacity}",
                    queue = "队列：{queue} / {maxQueue}",
                    status = "状态：{status}",
                    title = "打印机",
                },
                messages = {
                    grade_too_low = "你的职级不足，无法使用此打印机。",
                    invalid_amount = "补充数量无效。",
                    missingModel = "放置前请选择有效的打印机模型。",
                    missing_refill_item = "你没有配置要求的补充物品。",
                    no_refill_printer = "附近没有可访问且启用了纸张消耗的打印机。",
                    paper_capacity_exceeded = "补充后将超过纸张容量。",
                    paper_disabled = "此打印机已禁用纸张消耗。",
                    paper_full = "此打印机的纸盒已满。",
                    printer_inactive = "此打印机已停用。",
                    printer_not_found = "此打印机已不存在。",
                    refill_cooldown = "请稍等片刻再补充纸张。",
                    refilled = "已添加 {amount} 张纸。储量：{paper} / {capacity}。",
                    too_far_away = "请靠近打印机。",
                    unavailable = "打印机不可用。",
                    wrong_job = "你的职业无法使用此打印机。",
                },
                settings = {
                    description = "这些设置适用于为此职业配置的所有打印机。",
                    title = "职业通用打印机设置",
                },
                statuses = {
                    maintenance = "维护中",
                    offline = "离线",
                    online = "在线",
                },
                title = "打印机",
                values = {
                    disabled = "已禁用",
                    enabled = "已启用",
                    selectItem = "选择物品",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "配置DOJ个专业、法院地点和法律编码应用程序",
                    title = "司法部专业",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "法院",
                    entryPluralLabel = "法院法院",
                    label = "法院法院",
                },
            },
            extensions = {
                invalidSelection = "无效选项：{value}",
                trainingSettings = {
                    description = "为此作业配置培训访问、注册、批准和课程规划。",
                    label = "训练设置",
                },
            },
            locations = {
                stationPosition = "位置 / 地图标记",
                stationPositionHint = "此工作地点的中心点。如果“工作 → 地图标记”下已启用地图标记，则会在此显示。",
                addCourtroom = "新增审判室",
                courtroom = "审判室",
                courtroom_display_desk_27 = "审判室证据展示 - 27- 服务台监视器",
                courtroom_display_wall_55 = "审判室证据展示 - 55- 硬墙 TV",
                courtroom_display_wall_75 = "审判室证据展示 - 75- 硬墙 TV",
                courtroom_display_wall_100 = "审判室证据展示 - 100- 硬墙 TV",
                courtroom_display_wall_120 = "审判室证据展示 - 120- 硬墙 TV",
                courtroom_display_wall_150 = "审判室证据展示 - 150- 硬墙 TV",
                courtroom_display_board_93 = "审判室互动板- 150- 移动站",
                courtroom_display_projection = "审判室证据展示-4.5米投影屏幕",
                courtroom_judge_mic = "审判室-法官麦克风",
                courtroom_jury_room = "审判室 -- -- 陪审室",
                courtroom_room = "审判室 -- -- 观众/客厅中心",
                courtroom_witness = "审判室-证人席",
                electionBooth = "投票情况",
                publicDisplayDesk27 = "公共显示 - 27-inch服务台监视器",
                publicDisplayTerminal43 = "公共显示-43-英寸楼楼终端",
                publicDisplayWall55 = "公共显示 - 55- 硬墙 TV",
                publicDisplayWall75 = "公共显示 - 75- 硬墙 TV",
                publicDisplayWall100 = "公共显示 - 100- 硬墙 TV",
                publicDisplayWall120 = "公共显示 - 120- 硬墙 TV",
                publicDisplayWall150 = "公共显示 - 150- 硬墙 TV",
                publicDisplayProjection = "公共显示 - 4.5 m 投影屏幕",
                publicLegalCode = "《公法法典》",
            },
            settingGroups = {
                dojWarrants = {
                    label = "法院签发的逮捕证",
                },
                dojAccess = {
                    label = "访问",
                },
                dojCourthouseBlip = {
                    label = "地图页",
                },
                dojLegalBooks = {
                    label = "书本",
                },
                dojLegalContentLimits = {
                    label = "内容限制",
                },
                dojLegalItem = {
                    label = "库存物品",
                },
                dojLegalRateLimits = {
                    label = "利率限额",
                },
                dojLegalRevisions = {
                    label = "修订",
                },
                dojLegalTransfers = {
                    label = "大型文件",
                },
                dojOffenceCalculation = {
                    label = "计算器",
                },
                dojOffenceRateLimits = {
                    label = "利率限额",
                },
                dojOffenceMiranda = {
                    label = "目录指南",
                },
                dojOffenceSource = {
                    label = "目录源",
                },
                dojRecordsGradeBindings = {
                    description = "将每DOJ年级的成绩都分配给一个记录域,然后公布地图。",
                    label = "职等和记录领域",
                },
                dojTaxPayment = {
                    label = "支付",
                },
                dojTaxRates = {
                    label = "速率率率",
                },
                dojTaxSchedule = {
                    label = "时间表",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "公证合同",
                    powers_of_attorney = "委托书",
                    name_changes = "名称更改",
                    company_registry = "公司注册处",
                    association_registry = "协会登记处",
                    licensing = "许可证许可证发放",
                    administrative_decisions = "行政决定",
                    administrative_objections = "行政反对",
                },
            },
            gavel = {
                enabled = "启用",
                cooldown = "触发自上调( ms)",
                defaultPreset = "默认罢工模式",
                prop = "发射道道",
                model = "模型名称",
                bone = "手骨 ID",
                offset = "偏移(米)",
                rotation = "旋转(度)",
                presets = "罢工模式",
                single = "单次罢工",
                double = "双击",
                strikes = "罢工次数",
                interval = "罢工间隔( ms)",
                impact = "音响延迟(毫秒)",
                audio = "声音",
                asset = "音频资产资产",
                volume = "体积",
                animation = "动画片",
                dict = "动画词典",
                clip = "动画名称",
                duration = "申请持续时间(月)",
                flag = "动画旗",
                x = "X",
                y = "Y",
                z = "Z",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "允许员工自行报名参加可用的培训课程。",
                approvalRequired = "使自行注册保持待定状态，直到授权讲师批准为止。",
                defaultCapacity = "创建新培训课程时使用的默认座位数。",
                enabled = "使培训应用程序可用于此作业。",
                requireOnDuty = "要求员工在打开或使用培训应用程序之前先到岗。",
                upcomingDays = "培训应用程序时间表中显示的未来天数。",
            },
            trainingFields = {
                allowSelfEnrollment = "允许自行注册",
                approvalRequired = "需要注册批准",
                defaultCapacity = "默认容量",
                enabled = "启用训练",
                requireOnDuty = "需要值班",
                upcomingDays = "即将到来的时期（天）",
            },
        },
    },
}
