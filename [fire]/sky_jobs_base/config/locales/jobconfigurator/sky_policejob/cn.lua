JobConfigLocales["sky_policejob:cn"] = {
    JobConfiguratorComingSoon = "此职业配置器即将推出。",
    JobConfiguratorNoPermission = "你没有权限使用此命令。",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "配置警察部门、商店、道具、车辆、警局以及核心功能设置。",
                    title = "警察职业",
                },
            },
            dispatchActions = {
                addChannel = "添加无线电频道",
                addKeyword = "添加关键词",
                addPoi = "添加地点",
                addReporter = "添加报警人",
                addStatus = "添加 FMS 状态",
                addVehicle = "添加虚拟单位",
                addVehicleType = "添加单位类型",
                currentLocation = "使用当前位置",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "创建事件后立即分配匹配的可用单位。",
                available = "处于此状态的单位可能会被建议并分配给新事件。",
                averageResponseSpeedKmh = "根据直线距离计算显示的预计到达时间。",
                callsign = "当玩家配置此虚拟单位时，会显示独特的无线电呼号。",
                centerEnabled = "允许授权值班人员为调度中心配备人员。",
                channelId = "PMA Voice、SaltyChat 和 YACA 的无线电频道 ID。数字ID如2500保持不变； PMA Voice 将文本 ID 映射到稳定的号码。",
                channelLabel = "向调度员和单位显示的可读频道名称。",
                crewCapacity = "可加入此单位的最大人员数；填 0 表示不限制。",
                defaultChannel = "调度员在开始轮班时加入此频道。从“无线电”选项卡手动加入单位。选择“无”以使用作业组默认值。",
                emergencyAppEnabled = "使该工作可以在紧急电话应用程序中选择为公共服务。",
                enabled = "使此作业可用于调度应用程序和跨作业事件。",
                icon = "选择调度应用程序中该单位类别显示的图标。",
                incidentAssessmentEnabled = "显示完整事件记录中的医疗和危险评估问题。",
                jobs = "使用此关键字接收事件的其他作业名称。",
                joinLocked = "单位有人值守后，禁止其他人员继续加入。",
                minimumCrew = "此响应方案所选单位必须达到的最低人员数。",
                noUnitFallback = "在没有中心或人员单位的情况下，向所有值班成员发送 Sky 通知。",
                poiId = "稳定技术标识；地点重命名后，中心配置仍可引用它。",
                radius = "可以听到电台广播的最大距离（以米为单位）。",
                readyStatusCode = "资源进入可调度状态时应用的 FMS 状态。",
                requirements = "响应需求为 TYPE:COUNT 对，例如 PATROL:2,CRIME:1。",
                resourceType = "为调度筛选和协同标记此作战资源的类别。",
                respondingStatusCode = "资源响应警情时应用的 FMS 状态。",
                shortLabel = "显示在六个无线电频道存储键上的可选短标签。",
                stationId = "将此单位关联到调度中心配置中的站点。",
                statusCode = "手持无线电上显示数字 FMS 状态。",
                statusLabel = "此 FMS 状态对于调度员和单位的含义。",
                unitId = "即使无线电呼号改变，也用于保留该单位的稳定技术标识。",
                vehicleType = "必须与上一小节中配置的车辆类型代码匹配。",
                vehicleTypeCode = "响应要求中使用的短单位代码，例如 PATROL、CRIME、EMS 或 RESCUE。",
                vehicleTypeLabel = "该单位类别的可读名称。",
            },
            dispatchFields = {
                address = "地址",
                autoAlarm = "自动报警",
                available = "可供发货",
                averageResponseSpeedKmh = "预计响应速度（公里/小时）",
                callsign = "呼号",
                category = "类别",
                centerEnabled = "启用调度中心",
                channelId = "频道 ID",
                code = "代码",
                crewCapacity = "乘员容量",
                defaultChannel = "默认广播频道",
                emergencyAppEnabled = "在紧急应用程序中显示",
                enabled = "启用调度",
                icon = "图标",
                incidentAssessmentEnabled = "启用紧急评估",
                jobs = "目标职位（逗号分隔）",
                joinLocked = "锁定乘员加入",
                keywordCode = "关键字代码",
                label = "标签",
                minimumCrew = "最低乘员数",
                name = "姓名",
                noUnitFallback = "通知无单位值班人员",
                noneChannel = "无/组默认",
                note = "注意",
                phone = "电话",
                poiId = "稳定 POI ID",
                radius = "公告半径",
                readyStatusCode = "就绪状态代码",
                requirements = "所需单位（例如巡逻：2，犯罪：1）",
                resourceType = "资源类型",
                respondingStatusCode = "出动状态代码",
                shortLabel = "电台存储标签",
                stationId = "站点 ID",
                type = "类型",
                unitId = "稳定单位 ID",
                vehicleType = "响应单元类型",
                radioButton = "按钮按钮键",
                radioButtonAction = "按钮动作",
                radioButtonStatus = "FMS 状况状况状况状况",
            },
            dispatchIconOptions = {
                crime = "犯罪科",
                emergency = "应急小组",
                ems = "EMS 单位",
                fire = "消防队",
                heavy = "重型单位",
                k9 = "K-9 单位",
                medical = "医疗单位",
                patrol = "巡逻",
                rescue = "救援队",
                service = "服务单位",
                supervisor = "主管",
                tactical = "战术部队",
            },
            dispatchNavigation = {
                active = "调度活动",
                description = "为此作业配置紧急入口、无线电、单位、响应计划、位置和报告者数据。",
                inactive = "调度已禁用",
                steps = {
                    accessText = "启用调度并决定该作业是否可以配备调度中心。",
                    accessTitle = "通道和紧急接收",
                    fleetText = "配置频道、FMS 状态代码、车辆类型和呼号。",
                    fleetTitle = "无线电和车队",
                    responseText = "填写关键字、回复要求和兴趣点。",
                    responseTitle = "应对计划",
                },
                summary = {
                    channels = "广播频道",
                    plans = "应对计划",
                    reporters = "已知报警人",
                    statuses = "可用的 FMS",
                    units = "虚拟单位",
                },
                title = "调度",
                warnings = {
                    channels = "不存在显式无线电信道；将使用作业组后备通道。",
                    defaultChannel = "所选的默认频道不再存在。",
                    disabled = "此作业已禁用调度。",
                    statuses = "必须至少有一种 FMS 状态可用，以便可以向设备发出警报。",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "定义单位和人员调度中心可以加入的无线电频道。",
                dispatchKeywords = "定义事件关键字、所需车辆数量、参与作业和可选的自动警报。",
                dispatchPois = "存储事件表格和基于位置的电台公告的电台和公共位置。",
                dispatchReporters = "管理该职业的报警人姓名、回拨号码和调度备注。",
                dispatchStatusCodes = "配置 FMS 状态标签以及哪些状态算作可用于新事件。",
                dispatchVehicleTypes = "定义响应计划使用的单位类别，例如巡逻、犯罪单位、EMS 或救援。",
                dispatchVehicles = "定义虚拟调度车辆，可以在任何地方配备人员，而不需要生成车辆。",
                dispatchRadioButtons = "设置每个物理函数按钮的中央预定义动作。",
                dispatchRadioFmsKeys = "指派 FMS 键盘仅运行 FMS 变化。",
            },
            extensions = {
                caseNumbering = {
                    label = "案件编号",
                    description = "配置此职业的自动案件编号。",
                    fields = {
                        prefix = {
                            label = "案件前缀",
                            description = "新案件的前缀，例如 LSPD 或 LSCSD。最多 16 个字符，自动转为大写；留空时使用 CASE。现有编号和手动指定的编号保持不变。",
                        },
                    },
                },
                dispatchReporters = "已知报警人",
                invalidSelection = "无效选项：{value}",
                trainingSettings = {
                    description = "为此作业配置培训访问、注册、批准和课程规划。",
                    label = "训练设置",
                },
                dispatchChannels = "广播频道",
                dispatchKeywords = "关键词和应急计划",
                dispatchPois = "派送聚物",
                dispatchSettings = {
                    description = "配置调度访问、紧急接收和默认的无线电频道。",
                    label = "调度设置",
                },
                dispatchStatusCodes = "身份代码",
                dispatchVehicleTypes = "调度车型型",
                dispatchVehicles = "调度车队数据",
                emptyDescription = "使用上面的添加按钮创建第一个条目。",
                emptyTitle = "尚未配置",
                dispatchRadioButtons = "无线电函数按钮",
                dispatchRadioFmsKeys = "FMS 密钥指定",
            },
            features = {
                billing = {
                    description = "启用警方开单流程。",
                    label = "账单",
                },
                devices = {
                    description = "启用可部署的执法设备。",
                    label = "CCTV 与测速摄像头",
                },
                evidence = {
                    description = "启用证据存储、现场证据和扫描仪流程。",
                    label = "证据",
                },
                impound = {
                    description = "启用扣押场流程。",
                    label = "扣押",
                },
                jail = {
                    description = "启用监禁判决和囚犯活动。",
                    label = "监狱",
                },
                propPlacement = {
                    description = "启用可配置的警用道具和车辆道具装备。",
                    label = "道具放置",
                },
                radial = {
                    description = "启用扣押、车轮夹等警用轮盘操作。",
                    label = "轮盘操作",
                },
                restraints = {
                    description = "启用手铐、束线带、脚镣和头套。",
                    label = "拘束",
                },
                socialWork = {
                    description = "启用社会工作指派和任务活动。",
                    label = "社会工作",
                },
                tablet = {
                    description = "启用由本资源配置的警用平板应用。",
                    label = "警用平板",
                },
                tracking = {
                    description = "启用 GPS 追踪器和电子脚环。",
                    label = "追踪",
                },
                vehicleRadar = {
                    description = "启用巡逻车雷达。",
                    label = "车载雷达",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "要在紧急呼叫应用中显示此职业，必须先启用调度功能。请在调度设置中启用调度，或关闭“在紧急呼叫应用中显示”。",
                dispatchJobNotCovered = "没有启用的调度中心负责职业“{job}”。请在 sky_jobs_base/config/config.lua 中，将“{job}”加入相应 Config.Dispatch.centers 配置的 coveredJobs 列表，然后重启 sky_jobs_base。重置设置不会改变此分配。",
                invalidDispatchChannels = "无线电频道 ID 必须唯一，并且每个频道都需要有效名称。",
                invalidDispatchDefaultChannel = "默认无线电频道不存在。请在调度设置中选择已有频道或“无”。",
                invalidDispatchKeywords = "响应方案代码必须唯一，并使用有效的 类型:数量 要求。",
                invalidDispatchPois = "地点 ID、名称和坐标必须有效且唯一。",
                invalidDispatchRadioButtons = "请检查无线电功能按钮：每个受支持的按钮只能出现一次，并从其列表中选择操作。",
                invalidDispatchRadioFmsKeys = "请检查无线电 FMS 按键：每个按键（0-9、* 或 #）只能出现一次，并且必须分配已有的状态代码，或保持未分配。",
                invalidDispatchReadyStatus = "请在调度设置中选择一个在状态代码列表中标记为可用的就绪状态代码。",
                invalidDispatchReporters = "已知报警人数据超过允许的条目数或字段长度。",
                invalidDispatchRespondingStatus = "请在调度设置中选择一个在状态代码列表中标记为不可用的出动状态代码。",
                invalidDispatchSettings = "请选择已存在且可用的就绪状态、不可用的出动状态以及有效的默认频道。",
                invalidDispatchStatusCodes = "FMS 代码必须唯一，并且至少一个状态必须可用。",
                invalidDispatchVehicleTypes = "响应单位类型代码必须唯一且填写完整。",
                invalidDispatchVehicles = "单位 ID 和呼号必须唯一，所有单位类型及站点引用必须存在。",
            },
            settingFields = {
                gangMinimumGrade = "最低等级",
                gang = "帮派",
                component = "组件",
                description = "描述",
                fineAmount = "罚款金额",
                itemName = "物品名称",
                length = "长度",
                max = "最大",
                maxOverKmh = "最大超速",
                min = "最小",
                minOverKmh = "最小超速",
                model = "道具模型",
                propModel = "道具模型",
                reason = "事由",
                vehicleClass = "类别",
            },
            settingGroups = {
                access = {
                    label = "权限",
                },
                animation = {
                    label = "动画",
                },
                ankleMonitor = {
                    label = "电子脚环",
                },
                ankleMonitorAccess = {
                    label = "电子脚环权限",
                },
                ankleMonitorPlacement = {
                    label = "电子脚环佩戴",
                },
                ankleMonitorZone = {
                    label = "电子脚环区域",
                },
                ankleMonitorZoneVisual = {
                    label = "电子脚环区域视觉",
                },
                assignment = {
                    label = "判决",
                },
                blip = {
                    label = "警局图标",
                },
                carry = {
                    label = "背负",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "CCTV 耐久度",
                },
                cctvPlacement = {
                    label = "CCTV 放置",
                },
                cctvRepair = {
                    label = "CCTV 维修",
                },
                cctvRepairAnimation = {
                    label = "CCTV 维修动画",
                },
                clamp = {
                    label = "车轮夹",
                },
                clampWeld = {
                    label = "夹具焊除",
                },
                cleanup = {
                    label = "清理",
                },
                collection = {
                    label = "采集",
                },
                controls = {
                    label = "控制",
                },
                creator = {
                    label = "创建器",
                },
                crimeSceneTape = {
                    label = "犯罪现场警戒带",
                },
                crimeSceneTapeAccess = {
                    label = "警戒带权限",
                },
                crimeSceneTapeInventory = {
                    label = "警戒带物品",
                },
                crimeSceneTapeLength = {
                    label = "警戒带长度",
                },
                crimeSceneTapePlacement = {
                    label = "警戒带放置",
                },
                database = {
                    label = "数据库",
                },
                delivery = {
                    label = "送达",
                },
                detection = {
                    label = "检测",
                },
                dispatch = {
                    label = "调度",
                },
                escape = {
                    label = "挣脱",
                },
                escort = {
                    label = "押送",
                },
                evidenceStorage = {
                    label = "证据存储",
                },
                fastLock = {
                    label = "自动快速锁定",
                },
                general = {
                    label = "通用",
                },
                gpsTracker = {
                    label = "GPS 追踪器",
                },
                gpsTrackerAccess = {
                    label = "GPS 追踪器权限",
                },
                gpsTrackerPlacement = {
                    label = "GPS 追踪器放置",
                },
                gpsTrackerTiming = {
                    label = "GPS 追踪器时间设置",
                },
                handcuffs = {
                    label = "手铐",
                },
                handsUp = {
                    label = "举手",
                },
                header = {
                    label = "页眉",
                },
                impound = {
                    label = "扣押",
                },
                imprisonment = {
                    label = "监禁",
                },
                jailCanteenGeneral = {
                    label = "监狱小卖部",
                },
                jailCanteenPackage = {
                    label = "小卖部物资包",
                },
                jailCarry = {
                    label = "搬运工作",
                },
                jailCarryInspection = {
                    label = "搬运检查",
                },
                jailCleaning = {
                    label = "清洁工作",
                },
                jailCleaningIllegalFinds = {
                    label = "违禁品发现",
                },
                jailCleaningOutline = {
                    label = "清洁轮廓",
                },
                jailDoctor = {
                    label = "监狱医生",
                },
                jailElectricalCodes = {
                    label = "配电密码",
                },
                jailElectricalGeneral = {
                    label = "监狱配电",
                },
                jailElectricalPenalties = {
                    label = "配电处罚",
                },
                jailElectricalRewards = {
                    label = "配电奖励",
                },
                jailInmatesAlcoholic = {
                    label = "酗酒囚犯",
                },
                jailInmatesCodeList = {
                    label = "线人囚犯",
                },
                jailInmatesDrugDealer = {
                    label = "毒贩囚犯",
                },
                jailInmatesWireCutter = {
                    label = "工具贩子囚犯",
                },
                jailJobs = {
                    label = "监狱工作",
                },
                jailOutfitFemale = {
                    label = "女性服装",
                },
                jailOutfitMale = {
                    label = "男性服装",
                },
                keybinds = {
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                    label = "按键设置",
                },
                keybindsHandcuff = {
                    label = "上铐按键",
                },
                keybindsUnhandcuff = {
                    label = "解铐按键",
                },
                marker = {
                    label = "标记",
                },
                markerColor = {
                    label = "标记颜色",
                },
                mugshotAnimation = {
                    label = "入案照片动画",
                },
                mugshotBoard = {
                    label = "入案照片板牌",
                },
                mugshotCameraCoords = {
                    label = "入案照片相机位置",
                },
                mugshotCameraRotation = {
                    label = "入案照片相机旋转",
                },
                mugshotGeneral = {
                    label = "入案照片",
                },
                mugshotMetadata = {
                    label = "入案照片元数据",
                },
                mugshotPosition = {
                    label = "入案照片位置",
                },
                mugshotTiming = {
                    label = "入案照片时间设置",
                },
                officerDown = {
                    label = "警员倒地",
                },
                outfit = {
                    label = "服装",
                },
                overlay = {
                    label = "车牌叠加层",
                },
                payment = {
                    label = "支付",
                },
                paymentFlow = {
                    label = "支付流程",
                },
                penalties = {
                    label = "处罚",
                },
                playerSearch = {
                    label = "搜身",
                },
                playerSearchAnimation = {
                    label = "搜身动画",
                },
                props = {
                    label = "道具物品",
                },
                reasons = {
                    label = "事由",
                },
                release = {
                    label = "取车",
                },
                restore = {
                    label = "恢复",
                },
                rules = {
                    label = "规则",
                },
                scan = {
                    label = "扫描",
                },
                scanner = {
                    label = "扫描仪",
                },
                sentence = {
                    label = "刑期",
                },
                shotsFired = {
                    label = "枪击",
                },
                sound = {
                    label = "声音",
                },
                speedcam = {
                    label = "测速摄像头",
                },
                speedcamBilling = {
                    label = "测速摄像头账单",
                },
                speedcamDispatch = {
                    label = "测速摄像头调度",
                },
                speedcamDurability = {
                    label = "测速摄像头耐久度",
                },
                speedcamPlacement = {
                    label = "测速摄像头放置",
                },
                speedcamRepair = {
                    label = "测速摄像头维修",
                },
                speedcamRepairAnimation = {
                    label = "测速摄像头维修动画",
                },
                speedcamTiming = {
                    label = "测速摄像头时间设置",
                },
                speedcamVisual = {
                    label = "测速摄像头视觉效果",
                },
                speedcams = {
                    label = "测速摄像头",
                },
                storage = {
                    label = "寄存",
                },
                subscription = {
                    label = "应用订阅",
                },
                tasks = {
                    label = "任务",
                },
                theme = {
                    label = "主题",
                },
                timing = {
                    label = "时间设置",
                },
                warningUi = {
                    label = "警告界面",
                },
                world = {
                    label = "世界",
                },
                zipties = {
                    label = "束线带",
                },
                ziptiesCutter = {
                    label = "束线带剪",
                },
                cctvMotionDetection = {
                    label = "运动检测",
                },
                cctvMotionDispatch = {
                    label = "动议侦测调度",
                },
                cctvMotionTiming = {
                    label = "动议侦查时间",
                },
                display = {
                    label = "显示",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "报告",
                },
                speedcamAdvanced = {
                    label = "高级高速摄像机",
                },
                tackle = {
                    label = "扑倒",
                },
                vin = {
                    label = "VIN 支票支票支票支票",
                },
            },
            settingSections = {
                radarGun = "手持测速雷达",
                billing = "账单",
                cctv = "CCTV",
                dispatch = "调度",
                equipment = "装备",
                evidence = "证据",
                impound = "扣押",
                jail = "监狱",
                radar = "车载雷达",
                radial = "轮盘操作",
                restraints = "拘束",
                socialWork = "社会工作",
                speedCamera = "测速摄像头",
                spikeStrips = "阻车钉",
                stations = "警局",
                tablet = "平板应用",
                tracking = "追踪",
                fakePlates = "假白白板",
                general = "一般的",
            },
            settingSubsections = {
                app = "测速摄像头应用",
                apps = "应用",
                billing = "账单",
                canteen = "监狱小卖部",
                dispatch = "调度",
                durability = "耐久度",
                electrical = "监狱配电",
                general = "通用",
                handcuffs = "手铐和扎带",
                inmates = "囚犯",
                jobs = "监狱工作",
                keybinds = "按键设置",
                motionDetection = "运动检测",
                mugshot = "入案照片",
                placement = "放置",
                repair = "维修",
                timing = "时间设置",
                visuals = "视觉效果",
            },
            settings = {
                radarGunClearKey = { label = "雷达测速枪：清除读数" },
                radarGunToggleUiKey = { label = "雷达测速枪：切换界面" },
                radarGunNoTargetHoldMs = { label = "目标保留时间（毫秒）" },
                radarGunMinimumReading = { label = "最低显示速度" },
                radarGunSpeedSmoothing = { label = "速度平滑系数（0–1）" },
                radarGunBeamRadius = { label = "光束半径（米）" },
                radarGunRefreshRateMs = { label = "测量间隔（毫秒）" },
                radarGunUseMph = { label = "使用 MPH", description = "使用英里每小时而非公里每小时显示测速结果。" },
                radarGunRange = { label = "测量范围", description = "测速雷达可探测车辆的最大距离（米）。" },
                radarGunRequireOnDuty = { label = "要求执勤", description = "要求警员执勤后才能使用测速雷达测量车辆。" },
                radarGunAllowedJobs = { label = "允许的职业或组", description = "使用 police 包含所有已配置的警察职业，也可直接填写职业名称。列表为空时不限制职业。", itemLabel = "职业或组" },
                radarGunEnabled = { label = "手持测速雷达", description = "启用手持式 SKY SR-2 测速雷达。" },
                fakePlateVinAllowedGangs = {
                    label = "允许的帮派",
                    description = "选择帮派或独立组织的内部名称。职业或帮派匹配即可获得相应权限或豁免。值勤要求仅适用于职业。",
                    itemLabel = "帮派",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "帮派最低等级",
                    description = "可选的帮派最低等级。为空时允许所有等级。物品要求仍然有效。",
                },

                speedCamProcessingMode = {
                    description = "选择立即扣款、按配置期限延期付款或仅供警员审核。",
                    label = "处理方式",
                    options = {
                        instant = "立即扣款",
                        later = "延期付款（默认）",
                        review = "仅供警员审核",
                    },
                },
                tabletRegistry = { label = "登记册", description = "在 File Explorer 中启用自定义 RP 登记册。公民和车辆档案仍可单独使用。" },
                tabletFiles = { label = "文件资源管理器", description = "在文件资源管理器中集中显示警务记录。仅在 DOJ 运行时显示 DOJ 文件。" },
                ankleMonitorAnimDurationMs = {
                    description = "佩戴电子脚环所需的毫秒数。",
                    label = "使用时长",
                },
                ankleMonitorAnimScenario = {
                    description = "佩戴电子脚环时播放的场景动画。",
                    label = "使用场景动画",
                },
                ankleMonitorAttachBone = {
                    description = "附加电子脚环道具使用的 Ped 骨骼。",
                    label = "附加骨骼",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "佩戴后移除电子脚环物品。",
                    label = "消耗电子脚环",
                },
                ankleMonitorCutItem = {
                    description = "拆除电子脚环使用的背包物品。",
                    label = "剪除物品",
                },
                ankleMonitorEnabled = {
                    description = "启用电子脚环佩戴。",
                    label = "电子脚环",
                },
                ankleMonitorItem = {
                    description = "佩戴电子脚环使用的背包物品。",
                    label = "电子脚环物品",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "电子脚环地图更新之间的毫秒数。",
                    label = "地图更新间隔",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "受监控玩家断线时将电子脚环保留在数据库中，以便在重新连接或服务器重启后恢复。",
                    label = "断线后保留",
                },
                ankleMonitorPlaceDistance = {
                    description = "佩戴电子脚环的最大距离。",
                    label = "佩戴距离",
                },
                ankleMonitorPropModel = {
                    description = "电子脚环外观使用的道具模型。",
                    label = "道具模型",
                },
                ankleMonitorRequireOnDuty = {
                    description = "使用电子脚环前需要处于值班状态。",
                    label = "电子脚环需值班",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "使用电子脚环前玩家需属于警察组。",
                    label = "电子脚环需警察职业",
                },
                ankleMonitorReturnOnRemove = {
                    description = "拆除电子脚环时返还电子脚环物品。",
                    label = "拆除时返还电子脚环",
                },
                ankleMonitorWarningSeconds = {
                    description = "电子脚环区域违规被调度上报前的警告时间。",
                    label = "区域警告秒数",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "电子脚环区域警告蜂鸣之间的毫秒数。",
                    label = "区域蜂鸣间隔",
                },
                ankleMonitorZoneBeepSound = {
                    description = "电子脚环区域警告使用的音效名称。",
                    label = "蜂鸣音效",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "电子脚环区域警告使用的音效集。",
                    label = "蜂鸣音效集",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "电子脚环区域图标使用的透明度值。",
                    label = "图标透明度",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "目标位于允许区域内时使用的图标颜色。",
                    label = "允许区域图标颜色",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "目标离开允许区域时使用的图标颜色。",
                    label = "越界图标颜色",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "电子脚环区域检查之间的毫秒数。",
                    label = "区域检查间隔",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "可再次发送电子脚环区域调度前的秒数。",
                    label = "区域调度冷却",
                },
                ankleMonitorZoneEnabled = {
                    description = "启用电子脚环区域检查。",
                    label = "电子脚环区域",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "电子脚环区域标记使用的地图图标样式。",
                    label = "区域标签图标样式",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "电子脚环区域轮廓使用的半径。",
                    label = "轮廓半径",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "电子脚环区域轮廓使用的步长。",
                    label = "轮廓步长",
                },
                billingAccount = {
                    description = "职业未配置公司账户时使用的备用账户。",
                    label = "备用公司账户",
                },
                billingCloseOnSuccess = {
                    description = "账单开具成功后关闭开单界面。",
                    label = "成功后关闭",
                },
                billingCurrency = {
                    description = "开单使用的货币键。留空则使用默认货币。",
                    label = "货币",
                },
                billingCustomReasons = {
                    description = "允许自定义开单事由，而不仅限于预设。",
                    label = "自定义事由",
                },
                billingDepositToSociety = {
                    description = "将开单收入存入职业公司账户。",
                    label = "存入公账",
                },
                billingMaxReasonLength = {
                    description = "自定义开单事由的最大字符数。",
                    label = "事由长度",
                },
                billingMode = {
                    description = "选择警方账单是立即扣款、需要市民确认，还是使用框架账单系统。",
                    label = "开单模式",
                    options = {
                        consent = "支付或拒绝",
                        framework = "框架账单",
                        instant = "立即扣款",
                    },
                },
                billingRange = {
                    description = "开具警方账单的最大目标距离。",
                    label = "开单距离",
                },
                billingReasonPresets = {
                    description = "开单界面中显示的预设开单事由。",
                    itemLabel = "事由",
                    label = "预设事由",
                },
                billingRefreshSeconds = {
                    description = "开单界面打开时的目标刷新间隔。",
                    label = "刷新秒数",
                },
                billingShowRecipientName = {
                    description = "在罚单预览和收据上显示市民姓名。",
                    label = "显示收款人姓名",
                },
                carryAllowCarrierInVehicle = {
                    description = "允许携带者在不放下玩家的情况下进入并驾驶车辆。",
                    label = "允许携带者进入车辆",
                },
                carryAllowConscious = {
                    description = "允许背负清醒的目标。",
                    label = "背负清醒目标",
                },
                carryAllowSprint = {
                    description = "背负其他玩家时允许冲刺。",
                    label = "背负时允许冲刺",
                },
                carryEnabled = {
                    description = "启用背负玩家。",
                    label = "背负",
                },
                carryMaxDistance = {
                    description = "开始背负玩家的最大距离。",
                    label = "背负距离",
                },
                carryRequireOnDuty = {
                    description = "开始背负前需要处于值班状态。",
                    label = "背负需值班",
                },
                cctvDamageCooldownMs = {
                    description = "CCTV 可再次受到伤害前的毫秒数。",
                    label = "伤害冷却",
                },
                cctvDamagePerHit = {
                    description = "CCTV 摄像头每次被击中扣除的耐久度。",
                    label = "每次命中伤害",
                },
                cctvDefaultName = {
                    description = "已部署 CCTV 摄像头的默认显示名称。",
                    label = "CCTV 默认名称",
                },
                cctvDefaultPitch = {
                    description = "CCTV 放置的默认相机俯仰角。",
                    label = "默认俯仰角",
                },
                cctvDisassembleDistance = {
                    description = "拆卸 CCTV 摄像头使用的距离。",
                    label = "拆卸距离",
                },
                cctvEnabled = {
                    description = "启用 CCTV 摄像头的放置和画面传输。",
                    label = "CCTV 摄像头",
                },
                cctvHealthDisplayDistance = {
                    description = "显示 CCTV 耐久度的距离。",
                    label = "耐久显示距离",
                },
                cctvHealthDisplayDurationMs = {
                    description = "CCTV 耐久度保持可见的毫秒数。",
                    label = "耐久显示时长",
                },
                cctvHealthTextOffset = {
                    description = "CCTV 耐久度文字使用的垂直偏移。",
                    label = "耐久文字偏移",
                },
                cctvHeightStep = {
                    description = "调整 CCTV 摄像头位置时使用的高度步长。",
                    label = "高度步长",
                },
                cctvItem = {
                    description = "放置 CCTV 摄像头使用的背包物品。",
                    label = "CCTV 物品",
                },
                cctvMaintenanceThreshold = {
                    description = "建议进行 CCTV 维护的耐久度阈值。",
                    label = "维护阈值",
                },
                cctvMaxDurability = {
                    description = "CCTV 摄像头的最大耐久度。",
                    label = "CCTV 耐久度",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "摄像头再次创建移动调度前的秒数。",
                    label = "调度冷却",
                },
                cctvMotionCheckIntervalMs = {
                    description = "客户端移动扫描之间的毫秒数。",
                    label = "扫描间隔",
                },
                cctvMotionClientCooldownMs = {
                    description = "同一客户端再次报告同一摄像头前的毫秒数。",
                    label = "客户端报告冷却",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "为新放置的 CCTV 摄像头自动开启移动警报。",
                    label = "新摄像头默认开启",
                },
                cctvMotionDetectionEnabled = {
                    description = "启用每台 CCTV 摄像头的移动侦测调度警报。",
                    label = "移动侦测警报",
                },
                cctvMotionDetectionRadius = {
                    description = "移动侦测的最大距离（米）。",
                    label = "侦测半径",
                },
                cctvMotionFieldOfView = {
                    description = "移动侦测锥形范围的角度。",
                    label = "视野角度",
                },
                cctvMotionJobs = {
                    description = "接收 CCTV 移动调度的职业名称或职业组键。",
                    itemLabel = "职业或组",
                    label = "调度职业",
                },
                cctvMotionMinimumSpeed = {
                    description = "被视为移动所需的最低实体速度（米/秒）。",
                    label = "最低移动速度",
                },
                cctvMoveStep = {
                    description = "调整 CCTV 摄像头位置时使用的移动步长。",
                    label = "移动步长",
                },
                cctvPropModel = {
                    description = "已部署 CCTV 摄像头使用的道具模型。",
                    label = "CCTV 道具模型",
                },
                cctvRepairAnimDict = {
                    description = "维修 CCTV 摄像头时使用的动画字典。",
                    label = "维修动画字典",
                },
                cctvRepairAnimFlag = {
                    description = "维修 CCTV 摄像头时使用的动画标志。",
                    label = "维修动画标志",
                },
                cctvRepairAnimName = {
                    description = "维修 CCTV 摄像头时使用的动画名称。",
                    label = "维修动画名称",
                },
                cctvRepairCancelDelayMs = {
                    description = "可取消 CCTV 维修前的毫秒数。",
                    label = "维修取消延迟",
                },
                cctvRepairDistance = {
                    description = "维修 CCTV 摄像头使用的距离。",
                    label = "维修距离",
                },
                cctvRepairItem = {
                    description = "维修 CCTV 摄像头使用的背包物品。",
                    label = "维修物品",
                },
                cctvRepairPerTick = {
                    description = "每个 CCTV 维修节拍恢复的耐久度。",
                    label = "每次维修量",
                },
                cctvRepairTickMs = {
                    description = "CCTV 维修节拍之间的毫秒数。",
                    label = "维修间隔",
                },
                cctvRotateStep = {
                    description = "调整 CCTV 摄像头位置时使用的旋转步长。",
                    label = "旋转步长",
                },
                cctvStreamDistance = {
                    description = "加载 CCTV 摄像头使用的距离。",
                    label = "加载距离",
                },
                cctvViewOffset = {
                    description = "CCTV 实时画面渲染使用的视角偏移。",
                    label = "视角偏移",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "沿警戒带生成阻挡碰撞区域，使玩家无法直接穿过。",
                    label = "警戒带阻挡碰撞",
                },
                crimeSceneTapeConsumeItem = {
                    description = "成功放置后从背包中移除一个警戒带物品。",
                    label = "消耗警戒带物品",
                },
                crimeSceneTapeDynamic = {
                    description = "使警戒带受物理和重力影响，而不是固定在原位。",
                    label = "动态物理",
                },
                crimeSceneTapeEnabled = {
                    description = "允许使用背包物品放置犯罪现场警戒带。",
                    label = "犯罪现场警戒带",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "仅允许获准职业的人员拆除警戒带，并在启用时要求其正在值班。",
                    label = "限制拆除权限",
                },
                crimeSceneTapeItem = {
                    description = "用于开始放置犯罪现场警戒带的背包物品名称。",
                    label = "警戒带物品",
                },
                crimeSceneTapeJobs = {
                    description = "可以使用犯罪现场警戒带的职业名称。",
                    itemLabel = "职业",
                    label = "允许使用的职业",
                },
                crimeSceneTapeLabel = {
                    description = "放置过程中显示的犯罪现场警戒带名称。",
                    label = "警戒带显示名称",
                },
                crimeSceneTapeLengthStep = {
                    description = "所选警戒带长度取整到的增量（米）。",
                    label = "长度步长",
                },
                crimeSceneTapeMaxLength = {
                    description = "两个警戒带立柱之间允许的最长距离（米）。",
                    label = "最大警戒带长度",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "任一端点与放置警戒带的警员之间允许的最大距离。",
                    label = "最大放置距离",
                },
                crimeSceneTapeMinLength = {
                    description = "两个警戒带立柱之间允许的最短距离（米）。",
                    label = "最小警戒带长度",
                },
                crimeSceneTapeModel = {
                    description = "放置犯罪现场警戒带时使用的道具模型名称。",
                    label = "警戒带模型",
                },
                crimeSceneTapePostModel = {
                    description = "用于警戒带两端立柱的道具模型。",
                    label = "立柱模型",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "可以拆除已放置犯罪现场警戒带的最大距离。",
                    label = "拆除距离",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "仅允许正在值班且职业获准的人员放置警戒带。",
                    label = "需要值班",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "拆除已放置的警戒带时返还此前消耗的物品。",
                    label = "拆除时返还物品",
                },
                crimeSceneTapeSag = {
                    description = "警戒带在两个立柱之间允许的最大向下垂度（米）。",
                    label = "警戒带下垂量",
                },
                crimeSceneTapeSections = {
                    description = "用于组合所选长度的原生警戒带分段模型。",
                    itemLabel = "警戒带分段",
                    label = "警戒带分段",
                },
                crimeSceneTapeShowPosts = {
                    description = "在可变长度犯罪现场警戒带两端生成可见支撑立柱。",
                    label = "显示警戒带立柱",
                },
                crimeSceneTapeStreamDistance = {
                    description = "已放置犯罪现场警戒带的加载显示距离。",
                    label = "加载距离",
                },
                crimeSceneTapeTapeHeight = {
                    description = "警戒带高于所选地面点的高度。",
                    label = "警戒带高度",
                },
                crimeSceneTapeVariableLength = {
                    description = "允许警员设置起点和终点，以可调长度放置犯罪现场警戒带。",
                    label = "可变警戒带长度",
                },
                crimeSceneTapeZOffset = {
                    description = "放置警戒带模型时应用的垂直位置偏移。",
                    label = "垂直偏移",
                },
                cuffsAnimDict = {
                    description = "被拘束玩家使用的动画字典。",
                    label = "动画字典",
                },
                cuffsAnimFlag = {
                    description = "被拘束玩家使用的动画标志。",
                    label = "动画标志",
                },
                cuffsAnimName = {
                    description = "被拘束玩家使用的动画名称。",
                    label = "动画名称",
                },
                cuffsConsumeItem = {
                    description = "上铐时移除手铐物品。",
                    label = "消耗手铐",
                },
                cuffsEnabled = {
                    description = "启用手铐操作。",
                    label = "手铐",
                },
                cuffsEscapeEnabled = {
                    description = "启用挣脱手铐小游戏。",
                    label = "挣脱手铐",
                },
                cuffsEscapeKeyPool = {
                    description = "挣脱手铐小游戏中可能出现的按键。",
                    itemLabel = "按键",
                    label = "挣脱按键池",
                },
                cuffsEscapeRounds = {
                    description = "挣脱手铐小游戏所需的回合数。",
                    label = "挣脱回合数",
                },
                cuffsEscapeWindowMs = {
                    description = "每个挣脱输入窗口允许的毫秒数。",
                    label = "挣脱窗口",
                },
                cuffsHandsUpEnabled = {
                    description = "启用手铐和束线带使用的举手状态。",
                    label = "举手",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "触发举手前需按住按键的秒数。",
                    label = "举手按住秒数",
                },
                cuffsHandsUpKey = {
                    description = "举起双手使用的键盘按键。",
                    label = "举手按键",
                },
                cuffsItem = {
                    description = "手铐操作使用的背包物品。",
                    label = "手铐物品",
                },
                cuffsMaxDistance = {
                    description = "手铐操作的最大目标距离。",
                    label = "上铐距离",
                },
                cuffsRequireItem = {
                    description = "需要配置的手铐物品。",
                    label = "手铐需物品",
                },
                cuffsRequireOnDuty = {
                    description = "上铐前需要处于值班状态。",
                    label = "手铐需值班",
                },
                cuffsReturnOnRemove = {
                    description = "解铐时返还手铐物品。",
                    label = "返还手铐",
                },
                dispatchOfficerDownEnabled = {
                    description = "值班警员倒地时发送调度警报。",
                    label = "警员倒地警报",
                },
                dispatchOfficerDownJobs = {
                    description = "应接收警员倒地调度的职业。",
                    itemLabel = "职业",
                    label = "警员倒地职业",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "仅通知当前处于值班状态的玩家。",
                    label = "警员倒地需值班",
                },
                dispatchShotsFiredChance = {
                    description = "检测到枪声后创建警报的概率，范围为 0.0 至 1.0。",
                    label = "枪击警报概率",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "同一玩家可再次触发枪击警报前的秒数。",
                    label = "枪击冷却",
                },
                dispatchShotsFiredEnabled = {
                    description = "启用枪击调度警报。",
                    label = "枪击警报",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "不应触发枪击警报的武器。",
                    itemLabel = "武器",
                    label = "忽略武器",
                },
                dispatchShotsFiredJobs = {
                    description = "应接收枪击调度的职业。",
                    itemLabel = "职业",
                    label = "枪击职业",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "仅通知当前处于值班状态的玩家。",
                    label = "枪击需值班",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "检测到枪击时创建调度条目。",
                    label = "发送枪击调度",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "检测到消音枪声后创建警报的概率，范围为 0.0 至 1.0。",
                    label = "消音枪声警报概率",
                },
                escortEnabled = {
                    description = "启用押送玩家。",
                    label = "押送",
                },
                escortMaxDistance = {
                    description = "开始押送玩家的最大距离。",
                    label = "押送距离",
                },
                escortRequireOnDuty = {
                    description = "押送玩家前需要处于值班状态。",
                    label = "押送需值班",
                },
                escortVehicleDistance = {
                    description = "将被押送玩家放入车辆的最大距离。",
                    label = "押送车辆距离",
                },
                evidenceBloodDamageThreshold = {
                    description = "生成血迹证据所需的最低伤害阈值。",
                    label = "血迹伤害阈值",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "可生成下一枚弹壳前的毫秒数。",
                    label = "弹壳冷却",
                },
                evidenceCasingMergeRadius = {
                    description = "合并附近弹壳使用的半径。",
                    label = "弹壳合并半径",
                },
                evidenceCleanupIntervalMs = {
                    description = "证据清理批次之间的毫秒数。",
                    label = "清理间隔",
                },
                evidenceCleanupTtlSeconds = {
                    description = "现场证据自动过期前的秒数。",
                    label = "清理存活时间",
                },
                evidenceCleanerAllowEveryone = {
                    label = "向所有人开放清洁剂",
                    description = "允许所有人使用过氧化氢清除痕迹。关闭后使用职业和帮派名单。",
                },
                evidenceCleanerJobs = {
                    label = "清洁剂职业名单",
                    description = "关闭公开使用时允许的内部名称。职业或帮派匹配即可使用；名单为空时禁止使用。",
                    itemLabel = "职业",
                },
                evidenceCleanerGangs = {
                    label = "清洁剂帮派名单",
                    description = "关闭公开使用时允许的内部名称。职业或帮派匹配即可使用；名单为空时禁止使用。",
                    itemLabel = "帮派",
                },
                evidenceCollectDistance = {
                    description = "采集现场证据使用的距离。",
                    label = "采集距离",
                },
                evidenceDiscoverDistance = {
                    description = "发现附近证据标记使用的距离。",
                    label = "发现距离",
                },
                evidenceFieldEnabled = {
                    description = "启用现场证据的生成与采集。",
                    label = "现场证据",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "在现场检查和显现证据使用的武器。",
                    label = "手电筒武器",
                },
                evidenceGloveFreeHands = {
                    description = "视为未佩戴手套的手部组件 ID。",
                    label = "裸手组件",
                },
                evidenceMarkerColor = {
                    description = "现场证据标记使用的 RGBA 颜色。",
                    label = "标记颜色",
                },
                evidenceMarkerDrawDistance = {
                    description = "现场证据标记的绘制距离。",
                    label = "绘制距离",
                },
                evidenceMarkerOffset = {
                    description = "现场证据标记的垂直偏移。",
                    label = "偏移",
                },
                evidenceMarkerScaleX = {
                    description = "现场证据标记的 X 轴缩放。",
                    label = "X 缩放",
                },
                evidenceMarkerScaleY = {
                    description = "现场证据标记的 Y 轴缩放。",
                    label = "Y 缩放",
                },
                evidenceMarkerScaleZ = {
                    description = "现场证据标记的 Z 轴缩放。",
                    label = "Z 缩放",
                },
                evidenceMarkerType = {
                    description = "现场证据使用的标记类型。",
                    label = "标记类型",
                },
                evidenceMaxCreateDistance = {
                    description = "创建证据记录的最大距离。",
                    label = "生成距离",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "唾液样本同意的允许毫秒数。",
                    label = "唾液采样同意超时",
                },
                evidenceScannerDistance = {
                    description = "证据扫描仪交互使用的距离。",
                    label = "扫描仪距离",
                },
                evidenceScannerDurationMs = {
                    description = "指纹/扫描仪操作时长（毫秒）。",
                    label = "扫描仪时长",
                },
                evidenceStorageMaxCompartments = {
                    description = "证据存储隔间的最大数量。",
                    label = "存储隔间",
                },
                gpsTrackerBeepDistance = {
                    description = "GPS 追踪器蜂鸣提示开始生效的距离。",
                    label = "蜂鸣距离",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "远离追踪器时蜂鸣之间的毫秒数。",
                    label = "远距蜂鸣间隔",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "靠近追踪器时蜂鸣之间的毫秒数。",
                    label = "近距蜂鸣间隔",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "放置后移除追踪器物品。",
                    label = "消耗 GPS 追踪器",
                },
                gpsTrackerEnabled = {
                    description = "启用车辆 GPS 追踪器的放置和扫描。",
                    label = "GPS 追踪器",
                },
                gpsTrackerItem = {
                    description = "放置 GPS 追踪器使用的背包物品。",
                    label = "追踪器物品",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "追踪器地图更新之间的毫秒数。",
                    label = "地图更新间隔",
                },
                gpsTrackerPlaceDistance = {
                    description = "在车辆上放置 GPS 追踪器的最大距离。",
                    label = "放置距离",
                },
                gpsTrackerRemoveDistance = {
                    description = "拆除已放置 GPS 追踪器的最大距离。",
                    label = "拆除距离",
                },
                gpsTrackerRemoveKey = {
                    description = "拆除已放置 GPS 追踪器使用的控制代码。",
                    label = "拆除按键",
                },
                gpsTrackerRequireOnDuty = {
                    description = "使用 GPS 追踪器前需要处于值班状态。",
                    label = "GPS 需值班",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "使用 GPS 追踪器前玩家需属于警察组。",
                    label = "GPS 需警察职业",
                },
                gpsTrackerReturnOnRemove = {
                    description = "拆除追踪器时返还追踪器物品。",
                    label = "拆除时返还追踪器",
                },
                gpsTrackerScanDistance = {
                    description = "扫描追踪器的最大距离。",
                    label = "GPS 扫描距离",
                },
                gpsTrackerScanDurationMs = {
                    description = "扫描 GPS 追踪器所需的毫秒数。",
                    label = "扫描时长",
                },
                gpsTrackerScannerWeapon = {
                    description = "扫描 GPS 追踪器使用的武器或工具。",
                    label = "扫描武器",
                },
                impoundAccount = {
                    description = "扣押取车收费使用的账户。",
                    label = "支付账户",
                },
                impoundCreatorVehicleModel = {
                    description = "扣押创建器预览显示的车辆模型。",
                    label = "创建器车辆模型",
                },
                impoundCustomGarageEnabled = {
                    description = "可用时使用自定义车库扣押接口。",
                    label = "自定义车库扣押",
                },
                impoundDefaultPrice = {
                    description = "默认的扣押取车价格。",
                    label = "默认价格",
                },
                impoundDeliveryDistance = {
                    description = "扣押送达交互使用的距离。",
                    label = "送达距离",
                },
                impoundDeliveryMarker = {
                    description = "扣押送达使用的标记配置。",
                    label = "送达标记",
                },
                impoundEnabled = {
                    description = "启用扣押流程。",
                    label = "扣押",
                },
                impoundMarker = {
                    description = "扣押交互使用的标记配置。",
                    label = "扣押标记",
                },
                impoundRadialEnabled = {
                    description = "启用轮盘扣押操作。",
                    label = "扣押操作",
                },
                impoundRadialRequireOnDuty = {
                    description = "使用轮盘扣押操作前需要处于值班状态。",
                    label = "扣押需值班",
                },
                impoundRadialVehicleDistance = {
                    description = "轮盘扣押操作到目标车辆的最大距离。",
                    label = "扣押车辆距离",
                },
                impoundReleaseDistance = {
                    description = "扣押取车交互使用的距离。",
                    label = "取车距离",
                },
                impoundReleaseKey = {
                    description = "取回被扣押车辆使用的控制代码。",
                    label = "取车按键",
                },
                impoundRequireDelivery = {
                    description = "要求将车辆送达已配置的扣押场。",
                    label = "需要送达",
                },
                impoundStorageBasePrice = {
                    description = "寄存扣押车辆的基础取车价格。",
                    label = "寄存基础价格",
                },
                impoundStorageDailyFee = {
                    description = "每个计费日额外收取的扣押寄存费用。",
                    label = "寄存日费",
                },
                impoundStorageDaySeconds = {
                    description = "多少秒计为一个寄存计费日。",
                    label = "寄存日秒数",
                },
                impoundStorageEnabled = {
                    description = "启用付费扣押寄存处理。",
                    label = "扣押寄存",
                },
                jailAssignRange = {
                    description = "将目标送入监狱的最大距离。",
                    label = "判决距离",
                },
                jailCanteenCooldownMinutes = {
                    description = "囚犯再次领取小卖部物资包前需等待的分钟数。",
                    label = "冷却分钟数",
                },
                jailCanteenPackage = {
                    description = "监狱小卖部物资包发放的物品。",
                    label = "小卖部物资包",
                },
                jailCellStreamDistance = {
                    description = "单独牢房道具加载使用的距离。",
                    label = "牢房加载距离",
                },
                jailClearInventory = {
                    description = "玩家入狱时清空其背包。",
                    label = "清空背包",
                },
                jailDefaultMonths = {
                    description = "打开判决界面时的默认监禁时长。",
                    label = "默认月数",
                },
                jailDispatchJobs = {
                    description = "应接收监狱调度的职业。",
                    itemLabel = "职业",
                    label = "调度职业",
                },
                jailDoctorHealEvent = {
                    description = "监狱医生治疗囚犯时触发的服务端或客户端事件。",
                    label = "治疗事件",
                },
                jailElectricalCodeListItem = {
                    description = "查看生成的配电密码所需的背包物品。",
                    label = "密码单物品",
                },
                jailElectricalCodeMax = {
                    description = "配电箱随机密码的最大值。",
                    label = "最大密码",
                },
                jailElectricalCodeMin = {
                    description = "配电箱随机密码的最小值。",
                    label = "最小密码",
                },
                jailElectricalCodesCount = {
                    description = "为配电箱生成的候选密码数量。",
                    label = "密码数量",
                },
                jailElectricalEnabled = {
                    description = "启用监狱配电箱越狱小游戏。",
                    label = "配电箱",
                },
                jailElectricalPinLength = {
                    description = "配电箱 PIN 码使用的位数。",
                    label = "PIN 长度",
                },
                jailElectricalPropModel = {
                    description = "监狱配电箱使用的世界道具模型。",
                    label = "道具模型",
                },
                jailElectricalShockDamage = {
                    description = "囚犯配电序列失败时受到的伤害。",
                    label = "电击伤害",
                },
                jailElectricalShockRagdollMs = {
                    description = "触电后瘫倒的毫秒数。",
                    label = "电击瘫倒",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "配电箱越狱尝试成功后减去的刑期分钟数。",
                    label = "成功减刑分钟数",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "酗酒囚犯交易所需的数量。",
                    label = "所需数量",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "酗酒囚犯交易所需的物品。",
                    label = "所需物品",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "酗酒囚犯交易的奖励数量。",
                    label = "奖励数量",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "酗酒囚犯交易的奖励物品。",
                    label = "奖励物品",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "酗酒囚犯交易显示的奖励标签。",
                    label = "奖励标签",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "线人囚犯交易所需的数量。",
                    label = "所需数量",
                },
                jailInmateCodeListRequiredItem = {
                    description = "线人囚犯交易所需的物品。",
                    label = "所需物品",
                },
                jailInmateCodeListRewardAmount = {
                    description = "线人囚犯交易的奖励数量。",
                    label = "奖励数量",
                },
                jailInmateCodeListRewardItem = {
                    description = "线人囚犯交易的奖励物品。",
                    label = "奖励物品",
                },
                jailInmateCodeListRewardLabel = {
                    description = "线人囚犯交易显示的奖励标签。",
                    label = "奖励标签",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "毒贩囚犯交易接受的物品。",
                    label = "接受的物品",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "毒贩囚犯交易所需的数量。",
                    label = "所需数量",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "毒贩囚犯交易的奖励数量。",
                    label = "奖励数量",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "毒贩囚犯交易的奖励物品。",
                    label = "奖励物品",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "毒贩囚犯交易显示的奖励标签。",
                    label = "奖励标签",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "允许监狱清洁时发现的违禁品计入毒贩囚犯交易。",
                    label = "使用清洁违禁品",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "工具贩子囚犯交易所需的数量。",
                    label = "所需数量",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "工具贩子囚犯交易所需的物品。",
                    label = "所需物品",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "工具贩子囚犯交易的奖励数量。",
                    label = "奖励数量",
                },
                jailInmateWireCutterRewardItem = {
                    description = "工具贩子囚犯交易的奖励物品。",
                    label = "奖励物品",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "工具贩子囚犯交易显示的奖励标签。",
                    label = "奖励标签",
                },
                jailJobsCarryBoxModel = {
                    description = "监狱搬运工作箱子使用的道具模型。",
                    label = "搬运箱模型",
                },
                jailJobsCarryDropoffKey = {
                    description = "放下搬运工作箱子使用的控制代码。",
                    label = "搬运放置按键",
                },
                jailJobsCarryDropoffRadius = {
                    description = "监狱搬运工作的放置半径。",
                    label = "放置半径",
                },
                jailJobsCarryInspectKey = {
                    description = "检查搬运工作箱子使用的控制代码。",
                    label = "检查按键",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "检查搬运工作箱子时可能发现的废品物品。",
                    label = "废品检查物品",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "检查箱子时获得可用战利品奖励的几率。",
                    label = "可用战利品几率",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "检查搬运工作箱子时可能发现的可用物品。",
                    label = "可用检查物品",
                },
                jailJobsCarryInteractDistance = {
                    description = "监狱搬运工作的交互距离。",
                    label = "搬运交互距离",
                },
                jailJobsCarryMaxDistance = {
                    description = "监狱搬运工作进行所允许的最大距离。",
                    label = "搬运最大距离",
                },
                jailJobsCarryPickupKey = {
                    description = "拾取搬运工作箱子使用的控制代码。",
                    label = "搬运拾取按键",
                },
                jailJobsCarryPickupOffset = {
                    description = "搬运工作拾取位置使用的偏移对象。",
                    label = "拾取偏移",
                },
                jailJobsCarryTimeReduction = {
                    description = "完成监狱搬运工作获得的刑期减免。",
                    label = "搬运减刑",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "在监狱垃圾箱处使用的控制代码。",
                    label = "垃圾箱按键",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "监狱清洁垃圾箱道具使用的模型。",
                    label = "垃圾箱模型",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "清洁时发现违禁品的几率。",
                    label = "违禁品发现几率",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "在监狱清洁时可能发现的物品。",
                    label = "违禁品物品",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "违禁品发现提示的超时时间（毫秒）。",
                    label = "发现提示超时",
                },
                jailJobsCleaningInteractDistance = {
                    description = "清洁垃圾交互使用的距离。",
                    label = "清洁交互距离",
                },
                jailJobsCleaningMaxDistance = {
                    description = "清洁道具重置或消失前的最大距离。",
                    label = "清洁最大距离",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "监狱清洁同时存在的垃圾道具上限。",
                    label = "最大垃圾道具数",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "清洁垃圾生成点到中心的最小距离。",
                    label = "最小生成半径",
                },
                jailJobsCleaningPickupKey = {
                    description = "拾取监狱清洁垃圾使用的控制代码。",
                    label = "清洁拾取按键",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "清洁垃圾生成尝试之间的毫秒数。",
                    label = "垃圾生成间隔",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "生成清洁垃圾道具使用的半径。",
                    label = "垃圾生成半径",
                },
                jailJobsCleaningTrashModels = {
                    description = "监狱清洁工作使用的垃圾道具模型。",
                    itemLabel = "模型",
                    label = "垃圾模型",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "监狱清洁垃圾道具轮廓使用的 RGBA 颜色。",
                    label = "轮廓颜色",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "为监狱清洁垃圾道具启用轮廓高亮。",
                    label = "垃圾轮廓",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "监狱清洁垃圾轮廓使用的着色器 ID。",
                    label = "轮廓着色器",
                },
                jailJobsTimeReduction = {
                    description = "完成监狱清洁工作获得的刑期减免。",
                    label = "清洁减刑",
                },
                jailJobsTrashGoal = {
                    description = "完成监狱清洁工作所需的垃圾数量。",
                    label = "清洁垃圾目标",
                },
                jailMaxMonths = {
                    description = "可选择的最长监禁时长。",
                    label = "最长月数",
                },
                jailMinMonths = {
                    description = "可选择的最短监禁时长。",
                    label = "最短月数",
                },
                jailMonthMinutes = {
                    description = "一个监狱月对应的现实分钟数。",
                    label = "每月分钟数",
                },
                jailObjectStreamDistance = {
                    description = "持久监狱世界物体加载使用的距离。",
                    label = "物体加载距离",
                },
                jailOutfitApplyDelayMs = {
                    description = "加入后到应用监狱服装之间的延迟。",
                    label = "服装应用延迟",
                },
                jailOutfitEnabled = {
                    description = "启用监狱服装。",
                    label = "监狱服装",
                },
                jailOutfitFemaleArms = {
                    description = "女性监狱服装手臂组件。",
                    label = "手臂",
                },
                jailOutfitFemaleChain1 = {
                    description = "女性监狱服装项链样式（drawable）。",
                    label = "项链 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "女性监狱服装项链纹理。",
                    label = "项链 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "女性监狱服装贴饰样式（drawable）。",
                    label = "贴饰 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "女性监狱服装贴饰纹理。",
                    label = "贴饰 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "女性监狱服装眼镜样式（drawable，-1 移除眼镜）。",
                    label = "眼镜 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "女性监狱服装眼镜纹理。",
                    label = "眼镜 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "女性监狱服装头盔样式（drawable）。",
                    label = "头盔 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "女性监狱服装头盔纹理。",
                    label = "头盔 2",
                },
                jailOutfitFemalePants1 = {
                    description = "女性监狱服装裤子样式（drawable）。",
                    label = "裤子 1",
                },
                jailOutfitFemalePants2 = {
                    description = "女性监狱服装裤子纹理。",
                    label = "裤子 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "女性监狱服装鞋子样式（drawable）。",
                    label = "鞋子 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "女性监狱服装鞋子纹理。",
                    label = "鞋子 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "女性监狱服装上身样式（drawable）。",
                    label = "上身 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "女性监狱服装上身纹理。",
                    label = "上身 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "女性监狱服装 T恤样式（drawable）。",
                    label = "T恤 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "女性监狱服装 T恤纹理。",
                    label = "T恤 2",
                },
                jailOutfitMaleArms = {
                    description = "男性监狱服装手臂组件。",
                    label = "手臂",
                },
                jailOutfitMaleChain1 = {
                    description = "男性监狱服装项链样式（drawable）。",
                    label = "项链 1",
                },
                jailOutfitMaleChain2 = {
                    description = "男性监狱服装项链纹理。",
                    label = "项链 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "男性监狱服装贴饰样式（drawable）。",
                    label = "贴饰 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "男性监狱服装贴饰纹理。",
                    label = "贴饰 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "男性监狱服装眼镜样式（drawable，-1 移除眼镜）。",
                    label = "眼镜 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "男性监狱服装眼镜纹理。",
                    label = "眼镜 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "男性监狱服装头盔样式（drawable）。",
                    label = "头盔 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "男性监狱服装头盔纹理。",
                    label = "头盔 2",
                },
                jailOutfitMalePants1 = {
                    description = "男性监狱服装裤子样式（drawable）。",
                    label = "裤子 1",
                },
                jailOutfitMalePants2 = {
                    description = "男性监狱服装裤子纹理。",
                    label = "裤子 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "男性监狱服装鞋子样式（drawable）。",
                    label = "鞋子 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "男性监狱服装鞋子纹理。",
                    label = "鞋子 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "男性监狱服装上身样式（drawable）。",
                    label = "上身 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "男性监狱服装上身纹理。",
                    label = "上身 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "男性监狱服装 T恤样式（drawable）。",
                    label = "T恤 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "男性监狱服装 T恤纹理。",
                    label = "T恤 2",
                },
                jailRequireJailTerminal = {
                    description = "仅允许警员在所选监狱终端附近执行监禁。",
                    label = "需要监狱终端",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "囚犯越狱时恢复保存的平民服装。",
                    label = "越狱时恢复服装",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "恢复后出生点校正停止生效前的宽限窗口。",
                    label = "恢复校正窗口",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "恢复的囚犯若在监狱区域外加载，则将其传送回监狱出生点。",
                    label = "传送恢复的囚犯",
                },
                jailTerminalRange = {
                    description = "警员与所选监狱终端之间的最大距离。",
                    label = "监狱终端距离",
                },
                jailZoneExitGraceMs = {
                    description = "离开监狱区域被计为越狱前的宽限窗口。",
                    label = "区域离开宽限",
                },
                mugshotAnimDict = {
                    description = "入案照片拍摄时使用的动画字典。",
                    label = "动画字典",
                },
                mugshotAnimFlag = {
                    description = "入案照片拍摄时使用的动画标志。",
                    label = "动画标志",
                },
                mugshotAnimName = {
                    description = "入案照片拍摄时使用的动画名称。",
                    label = "动画名称",
                },
                mugshotBoardHeader = {
                    description = "入案照片板牌上显示的主标题。",
                    label = "板牌主标题",
                },
                mugshotBoardSubheader = {
                    description = "入案照片板牌上显示的备用副标题。",
                    label = "板牌副标题",
                },
                mugshotCameraCoordsX = {
                    description = "入案照片相机使用的世界 X 坐标。",
                    label = "相机 X",
                },
                mugshotCameraCoordsY = {
                    description = "入案照片相机使用的世界 Y 坐标。",
                    label = "相机 Y",
                },
                mugshotCameraCoordsZ = {
                    description = "入案照片相机使用的世界 Z 坐标。",
                    label = "相机 Z",
                },
                mugshotCameraFov = {
                    description = "入案照片拍摄使用的视场角。",
                    label = "相机视场角",
                },
                mugshotCameraRotX = {
                    description = "入案照片相机的 X 轴旋转。",
                    label = "旋转 X",
                },
                mugshotCameraRotY = {
                    description = "入案照片相机的 Y 轴旋转。",
                    label = "旋转 Y",
                },
                mugshotCameraRotZ = {
                    description = "入案照片相机的 Z 轴旋转。",
                    label = "旋转 Z",
                },
                mugshotCaptureTimeout = {
                    description = "入案照片拍摄回调允许的最大毫秒数。",
                    label = "拍摄超时",
                },
                mugshotEnabled = {
                    description = "在入狱登记时启用入案照片拍摄。",
                    label = "入案照片拍摄",
                },
                mugshotHeading = {
                    description = "入案照片拍摄时应用的朝向。",
                    label = "朝向",
                },
                mugshotLocationX = {
                    description = "入案照片拍摄使用的世界 X 坐标。",
                    label = "位置 X",
                },
                mugshotLocationY = {
                    description = "入案照片拍摄使用的世界 Y 坐标。",
                    label = "位置 Y",
                },
                mugshotLocationZ = {
                    description = "入案照片拍摄使用的世界 Z 坐标。",
                    label = "位置 Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "存储的入案照片元数据使用的描述格式。",
                    label = "元数据描述",
                },
                mugshotMetadataName = {
                    description = "存储的入案照片使用的背包元数据名称。",
                    label = "元数据名称",
                },
                mugshotWaitMs = {
                    description = "拍摄入案照片前等待的毫秒数。",
                    label = "等待毫秒数",
                },
                playerSearchAnimDict = {
                    description = "搜身时使用的动画字典。",
                    label = "动画字典",
                },
                playerSearchAnimFlag = {
                    description = "搜身时使用的动画标志。",
                    label = "动画标志",
                },
                playerSearchAnimName = {
                    description = "搜身时使用的动画名称。",
                    label = "动画名称",
                },
                playerSearchDurationMs = {
                    description = "搜身预览的时长（毫秒）。",
                    label = "搜身时长",
                },
                playerSearchEnabled = {
                    description = "启用搜身预览流程。",
                    label = "搜身",
                },
                playerSearchRange = {
                    description = "开始搜身的最大距离。",
                    label = "搜身距离",
                },
                playerSearchScenario = {
                    description = "未播放指定搜身动画时使用的场景动画。",
                    label = "搜身场景动画",
                },
                policeBillingControl200 = {
                    label = "账单 · 控制 200",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeBillingControl322 = {
                    label = "账单 · 控制 322",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl10 = {
                    label = "编辑器 · 控制 10",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl11 = {
                    label = "编辑器 · 控制 11",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl172 = {
                    label = "编辑器 · 控制 172",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl173 = {
                    label = "编辑器 · 控制 173",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl174 = {
                    label = "编辑器 · 控制 174",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl175 = {
                    label = "编辑器 · 控制 175",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl177 = {
                    label = "编辑器 · 控制 177",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl191 = {
                    label = "编辑器 · 控制 191",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl201 = {
                    label = "编辑器 · 控制 201",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl202 = {
                    label = "编辑器 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl21 = {
                    label = "编辑器 · 控制 21",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl32 = {
                    label = "编辑器 · 控制 32",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl322 = {
                    label = "编辑器 · 控制 322",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl33 = {
                    label = "编辑器 · 控制 33",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl34 = {
                    label = "编辑器 · 控制 34",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl35 = {
                    label = "编辑器 · 控制 35",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl36 = {
                    label = "编辑器 · 控制 36",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl37 = {
                    label = "编辑器 · 控制 37",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl38 = {
                    label = "编辑器 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl44 = {
                    label = "编辑器 · 控制 44",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policeEditorControl73 = {
                    label = "编辑器 · 控制 73",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                policePrimaryColor = {
                    description = "警察职业组的默认颜色。",
                    label = "主颜色",
                },
                propPlacementConsumeItem = {
                    description = "从背包放置道具时移除一个对应物品。",
                    label = "消耗道具物品",
                },
                propPlacementEnabled = {
                    description = "允许通过物品或车辆放置已配置的警用道具。",
                    label = "道具放置",
                },
                propPlacementItemNames = {
                    description = "将道具模型映射到背包物品名称，用于基于物品的道具放置。",
                    label = "道具物品名称",
                },
                propPlacementRequireOnDuty = {
                    description = "仅值班警员可以放置已配置的道具。",
                    label = "道具需值班",
                },
                propPlacementReturnItem = {
                    description = "移除已放置的道具时返还被消耗的物品。",
                    label = "返还道具物品",
                },
                propPlacementVehicleAccess = {
                    description = "允许职业车辆提供其配置的道具装备。",
                    label = "车辆道具存取",
                },
                radialEnabled = {
                    description = "启用警用轮盘操作。",
                    label = "警用轮盘",
                },
                radialHandcuffKeybindCommand = {
                    description = "为上铐按键绑定注册的命令名称。",
                    label = "上铐命令",
                },
                radialHandcuffKeybindDescription = {
                    description = "上铐按键绑定显示的说明。",
                    label = "上铐说明",
                },
                radialHandcuffKeybindEnabled = {
                    description = "启用直接上铐按键绑定。",
                    label = "上铐按键",
                },
                radialHandcuffKeybindKey = {
                    description = "直接上铐操作使用的键盘按键。",
                    label = "上铐按键键位",
                },
                radialKeybindsEnabled = {
                    description = "为选定的轮盘操作启用直接按键绑定。",
                    label = "直接按键绑定",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "为解铐按键绑定注册的命令名称。",
                    label = "解铐命令",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "解铐按键绑定显示的说明。",
                    label = "解铐说明",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "启用直接解铐按键绑定。",
                    label = "解铐按键",
                },
                radialUnhandcuffKeybindKey = {
                    description = "直接解铐操作使用的键盘按键。",
                    label = "解铐按键键位",
                },
                socialWorkAssignRange = {
                    description = "指派社会工作任务的最大距离。",
                    label = "指派距离",
                },
                socialWorkDeadlineDefault = {
                    description = "默认社会工作期限（分钟）。零表示禁用期限。",
                    label = "默认期限",
                },
                socialWorkDeadlineMax = {
                    description = "社会工作的最长期限（分钟）。零表示不设上限。",
                    label = "最长期限",
                },
                socialWorkDeadlineMin = {
                    description = "社会工作的最短期限（分钟）。",
                    label = "最短期限",
                },
                socialWorkDefaultTasks = {
                    description = "打开社会工作指派界面时的默认任务数量。",
                    label = "默认任务",
                },
                socialWorkEnabled = {
                    description = "启用社会工作的指派和任务流程。",
                    label = "社会工作",
                },
                socialWorkImprisonmentJailId = {
                    description = "社会工作违规导致监禁时使用的监狱 ID。",
                    label = "备用监狱 ID",
                },
                socialWorkImprisonmentMonths = {
                    description = "社会工作违规导致入狱时判处的月数。",
                    label = "监禁月数",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "社会工作监禁记录使用的警员名称。",
                    label = "监禁警员名称",
                },
                socialWorkImprisonmentSolitary = {
                    description = "触发监禁时将违规者送入单独监禁。",
                    label = "使用单独监禁",
                },
                socialWorkInactivityMinutes = {
                    description = "触发社会工作不活跃处罚前的分钟数。",
                    label = "不活跃分钟数",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "社会工作玩家长时间不活跃时增加的任务处罚。",
                    label = "不活跃任务处罚",
                },
                socialWorkMaxTasks = {
                    description = "可选择的最多社会工作任务数。",
                    label = "最多任务",
                },
                socialWorkMinTasks = {
                    description = "可选择的最少社会工作任务数。",
                    label = "最少任务",
                },
                speedCamBillingEnabled = {
                    description = "测速摄像头捕获匹配违法行为时自动开具账单。需要启用全局“账单”功能。",
                    label = "自动罚款",
                },
                speedCamBillingExcludedJobs = {
                    description = "永远不会收到测速摄像头自动账单的职业。",
                    itemLabel = "职业",
                    label = "豁免职业",
                },
                speedCamBillingExcludedModels = {
                    description = "永远不会收到测速摄像头自动账单的车辆生成名称。",
                    itemLabel = "模型",
                    label = "豁免车辆模型",
                },
                speedCamBillingRules = {
                    description = "测速摄像头使用的罚款规则。优先按最贴近匹配的超速范围计费；若无规则匹配，则回退使用 SpeedViolation 违法行为。",
                    label = "罚款规则",
                },
                speedCamCameraEaseMs = {
                    description = "视角切入测速摄像头角度的过渡时长。数值越低摆动越短；过低可能导致照片错位。",
                    label = "相机过渡（毫秒）",
                },
                speedCamCameraFov = {
                    description = "测速摄像头拍摄使用的视场角。",
                    label = "相机视场角",
                },
                speedCamCheckIntervalMs = {
                    description = "测速摄像头扫描之间的毫秒数。",
                    label = "检查间隔",
                },
                speedCamCooldownMs = {
                    description = "同一测速摄像头可再次触发前的毫秒数。",
                    label = "触发冷却",
                },
                speedCamDamageCooldownMs = {
                    description = "测速摄像头可再次受到伤害前的毫秒数。",
                    label = "伤害冷却",
                },
                speedCamDamagePerHit = {
                    description = "测速摄像头每次被击中扣除的耐久度。",
                    label = "每次命中伤害",
                },
                speedCamDamagedModelThreshold = {
                    description = "耐久度降至最大耐久度的此百分比或以下时，显示损坏模型。例如最大耐久度为 200，设置为 50，则在耐久度 100 时切换。",
                    label = "损坏模型阈值 (%)",
                },
                speedCamDefaultLimit = {
                    description = "测速摄像头的默认限速。",
                    label = "默认限速",
                },
                speedCamDefaultName = {
                    description = "放置测速摄像头时建议使用的显示名称。可以翻译此名称，不会改变物品栏物品或道具模型。",
                    label = "默认名称",
                },
                speedCamDefaultTolerance = {
                    description = "测速摄像头的默认容差。",
                    label = "默认容差",
                },
                speedCamDisassembleDistance = {
                    description = "拆卸测速摄像头使用的距离。",
                    label = "拆卸距离",
                },
                speedCamEnabled = {
                    description = "启用便携式测速摄像头。",
                    label = "测速摄像头",
                },
                speedCamFlashColor = {
                    description = "测速摄像头使用的 RGBA 闪光颜色。",
                    label = "闪光颜色",
                },
                speedCamFlashDurationMs = {
                    description = "红色测速闪光的淡出时间。不要设置得过低，否则相机摆动会变得可见。",
                    label = "闪光时长（毫秒）",
                },
                speedCamHealthDisplayDistance = {
                    description = "显示测速摄像头耐久度的距离。",
                    label = "耐久显示距离",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "测速摄像头耐久度保持可见的毫秒数。",
                    label = "耐久显示时长",
                },
                speedCamHealthTextOffset = {
                    description = "测速摄像头耐久度文字使用的垂直偏移。",
                    label = "耐久文字偏移",
                },
                speedCamItem = {
                    description = "物品栏中准确的内部物品名，例如 speedcam。填写物品键名，而不是显示名称；职业商店必须发放同一物品。",
                    label = "测速摄像头物品名",
                },
                speedCamMaintenanceThreshold = {
                    description = "建议进行测速摄像头维护的耐久度阈值。",
                    label = "维护阈值",
                },
                speedCamMaxDurability = {
                    description = "已部署测速摄像头的最大耐久度。",
                    label = "最大耐久度",
                },
                speedCamMaxLimit = {
                    description = "可配置的测速摄像头最大限速。",
                    label = "最大限速",
                },
                speedCamMaxTolerance = {
                    description = "可配置的测速摄像头最大容差。",
                    label = "最大容差",
                },
                speedCamPhotoLocale = {
                    description = "测速照片时间戳使用的可选区域设置。留空则使用被拍摄玩家的本地区域设置。",
                    label = "照片区域设置",
                },
                speedCamPhotoTimeZone = {
                    description = "测速照片时间戳使用的可选时区。留空则使用被拍摄玩家的本地时区。",
                    label = "照片时区",
                },
                speedCamPoliceNotification = {
                    description = "测速摄像头捕获违规时发送调度通知。",
                    label = "测速摄像头警方警报",
                },
                speedCamPoliceNotificationGroup = {
                    description = "将测速摄像头调度目标视为职业组。",
                    label = "调度目标为组",
                },
                speedCamPoliceNotificationJob = {
                    description = "测速摄像头调度通知使用的职业或组键。",
                    label = "调度目标",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "仅通知处于值班状态的测速摄像头调度目标。",
                    label = "调度需值班",
                },
                speedCamPoliceNotificationType = {
                    description = "测速摄像头警报使用的调度严重级别/类型。",
                    label = "调度类型",
                },
                speedCamPropModel = {
                    description = "完好摄像头道具的生成名称，例如 sky_speedcam。选择预设也会设置损坏和毁坏模型。自定义模型必须在游戏中可用。",
                    label = "测速摄像头道具模型",
                    custom = "自定义模型",
                    choose = "选择模型",
                    preview = "3D 预览",
                    customPlaceholder = "物件生成名称",
                    previewDescription = "在游戏中查看所选物件。预览不会保存更改。",
                    invalidModel = "请先输入有效的物件生成名称。",
                    modelMissing = "游戏中找不到该物件模型。",
                    previewFailed = "无法打开模型预览。",
                    intact = "完好物件模型",
                    previewRequiresGame = "在 FiveM 中打开 /jobconfig 以实时查看物件。",
                    previewHelp = "方向键移动；PageUp/PageDown 调整高度；滚轮旋转；Enter 关闭；Backspace 取消。",
                    options = {
                        sky_speedcam = "标准测速仪",
                        sky_germ_speedcam = "德式测速仪",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "损坏摄像头道具的生成名称，例如 sky_speedcam2。请选择与完好模型配套的版本。",
                    label = "受损道具模型",
                },
                speedCamPropModelDestroyed = {
                    description = "摄像头耐久度降至 0 时使用的模型生成名称，例如 sky_speedcam1。请选择与完好模型配套的版本。",
                    label = "损毁道具模型",
                },
                speedCamRepairAnimDict = {
                    description = "维修测速摄像头时使用的动画字典。",
                    label = "维修动画字典",
                },
                speedCamRepairAnimFlag = {
                    description = "维修测速摄像头时使用的动画标志。",
                    label = "维修动画标志",
                },
                speedCamRepairAnimName = {
                    description = "维修测速摄像头时使用的动画名称。",
                    label = "维修动画名称",
                },
                speedCamRepairCancelDelayMs = {
                    description = "可取消测速摄像头维修前的毫秒数。",
                    label = "维修取消延迟",
                },
                speedCamRepairDistance = {
                    description = "维修测速摄像头使用的距离。",
                    label = "维修距离",
                },
                speedCamRepairItem = {
                    description = "维修所用物品准确的内部名称，例如 fixtool。填写物品键名，而不是显示名称。",
                    label = "维修物品名",
                },
                speedCamRepairPerTick = {
                    description = "每个测速摄像头维修节拍恢复的耐久度。",
                    label = "每次维修量",
                },
                speedCamRepairTickMs = {
                    description = "测速摄像头维修节拍之间的毫秒数。",
                    label = "维修间隔",
                },
                speedCamStreamDistance = {
                    description = "加载摄像头道具的玩家距离，单位为米。超出此距离后会卸载道具；已保存的摄像头仍保留在原位。",
                    label = "加载距离",
                },
                speedCamTriggerRadius = {
                    description = "摄像头周围检测超速车辆的半径，单位为米。",
                    label = "触发半径",
                },
                speedCamUseMph = {
                    description = "以 MPH 显示和处理测速摄像头限速。",
                    label = "使用 MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "限制启用时允许损坏测速摄像头的武器。",
                    itemLabel = "武器",
                    label = "允许的武器",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "启用后仅列出的武器可以损坏测速摄像头。",
                    label = "限制启用",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "清除测速摄像头警告前的距离（米）。",
                    label = "清除距离",
                },
                speedCameraAppDefaultApp = {
                    description = "将测速摄像头应用作为平板默认应用显示。",
                    label = "默认应用",
                },
                speedCameraAppDescription = {
                    description = "测速摄像头平板应用显示的描述。",
                    label = "描述",
                },
                speedCameraAppDeveloper = {
                    description = "测速摄像头平板应用显示的开发者标签。",
                    label = "开发者",
                },
                speedCameraAppEnabled = {
                    description = "启用警用平板的测速摄像头应用。",
                    label = "测速摄像头平板应用",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "测速摄像头应用中显示的页眉小标题。",
                    label = "页眉小标题",
                },
                speedCameraAppHeaderTitle = {
                    description = "测速摄像头应用中显示的页眉标题。",
                    label = "页眉标题",
                },
                speedCameraAppIcon = {
                    description = "测速摄像头平板应用使用的图标路径。",
                    label = "图标路径",
                },
                speedCameraAppIdentifier = {
                    description = "测速摄像头平板应用的内部标识符。",
                    label = "标识符",
                },
                speedCameraAppInFrontDot = {
                    description = "判断测速摄像头是否位于玩家前方使用的点积阈值。",
                    label = "前方点积阈值",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "显示警告前的最低车速（KMH）。",
                    label = "最低车速",
                },
                speedCameraAppName = {
                    description = "测速摄像头平板应用的显示名称。",
                    label = "应用名称",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "提醒附近测速摄像头前的距离（米）。",
                    label = "提醒距离",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "仅在玩家位于车内时提醒测速摄像头。",
                    label = "仅在车内",
                },
                speedCameraAppOverlayBackground = {
                    description = "车牌图像叠加层使用的背景颜色。",
                    label = "叠加层背景",
                },
                speedCameraAppOverlayBorder = {
                    description = "车牌图像叠加层使用的边框颜色。",
                    label = "叠加层边框",
                },
                speedCameraAppOverlayColor = {
                    description = "车牌图像叠加层使用的文字颜色。",
                    label = "叠加层颜色",
                },
                speedCameraAppOverlayEnabled = {
                    description = "在测速摄像头拍摄的图像上启用车牌叠加显示。",
                    label = "叠加层启用",
                },
                speedCameraAppOverlayFontScale = {
                    description = "车牌图像叠加层使用的字体缩放。",
                    label = "叠加层字体缩放",
                },
                speedCameraAppOverlayX = {
                    description = "从左到右的归一化叠加层 X 位置。",
                    label = "叠加层 X",
                },
                speedCameraAppOverlayY = {
                    description = "从上到下的归一化叠加层 Y 位置。",
                    label = "叠加层 Y",
                },
                speedCameraAppRequireInFront = {
                    description = "仅提醒位于玩家前方的测速摄像头。",
                    label = "仅限前方",
                },
                speedCameraAppRoute = {
                    description = "测速摄像头平板应用打开的路由路径。",
                    label = "路由",
                },
                speedCameraAppSize = {
                    description = "测速摄像头平板应用报告的存储大小。",
                    label = "应用大小",
                },
                speedCameraAppSoundCoord = {
                    description = "在世界坐标处播放测速摄像头警告音效。",
                    label = "坐标音效",
                },
                speedCameraAppSoundEnabled = {
                    description = "为测速摄像头应用启用警告音效。",
                    label = "声音启用",
                },
                speedCameraAppSoundFrontend = {
                    description = "在前端音频通道播放测速摄像头警告音效。",
                    label = "前端音效",
                },
                speedCameraAppSoundLayers = {
                    description = "测速摄像头应用播放的叠加警告音效数量。",
                    label = "音效层数",
                },
                speedCameraAppSoundName = {
                    description = "测速摄像头应用警告使用的音效名称。",
                    label = "音效名称",
                },
                speedCameraAppSoundRange = {
                    description = "测速摄像头应用警告音效使用的范围。",
                    label = "音效范围",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "测速摄像头警告音效重复的次数。",
                    label = "重复次数",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "测速摄像头警告音效重复之间的毫秒数。",
                    label = "重复延迟",
                },
                speedCameraAppSoundSet = {
                    description = "测速摄像头应用警告使用的音效集。",
                    label = "音效集",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "平板测速摄像头应用订阅付款使用的账户。",
                    label = "账户",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "为平板测速摄像头应用启用付费订阅。",
                    label = "订阅启用",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "平板测速摄像头应用订阅续费之间的天数。",
                    label = "间隔天数",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "平板测速摄像头应用订阅收取的价格。",
                    label = "订阅价格",
                },
                speedCameraAppThemeAccent = {
                    description = "测速摄像头应用使用的强调色。",
                    label = "强调色",
                },
                speedCameraAppThemeBackground = {
                    description = "测速摄像头应用使用的线性渐变背景。",
                    label = "背景",
                },
                speedCameraAppThemeBorder = {
                    description = "测速摄像头应用使用的边框颜色。",
                    label = "边框",
                },
                speedCameraAppThemeButtonText = {
                    description = "测速摄像头应用使用的按钮文字颜色。",
                    label = "按钮文字",
                },
                speedCameraAppThemeDanger = {
                    description = "测速摄像头应用使用的危险色。",
                    label = "危险",
                },
                speedCameraAppThemeGhost = {
                    description = "测速摄像头应用使用的幽灵按钮颜色。",
                    label = "幽灵按钮",
                },
                speedCameraAppThemeGhostText = {
                    description = "测速摄像头应用使用的幽灵按钮文字颜色。",
                    label = "幽灵文字",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "测速摄像头应用使用的柔和渐变颜色。",
                    label = "柔和渐变",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "测速摄像头应用使用的非活动边框颜色。",
                    label = "非活动边框",
                },
                speedCameraAppThemeModal = {
                    description = "测速摄像头应用使用的弹窗背景颜色。",
                    label = "弹窗",
                },
                speedCameraAppThemeMutedText = {
                    description = "测速摄像头应用使用的弱化文字颜色。",
                    label = "弱化文字",
                },
                speedCameraAppThemeOverlay = {
                    description = "测速摄像头应用使用的叠加层颜色。",
                    label = "叠加层",
                },
                speedCameraAppThemePillText = {
                    description = "测速摄像头应用使用的胶囊标签文字颜色。",
                    label = "胶囊标签文字",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "测速摄像头应用使用的主渐变起始颜色。",
                    label = "主渐变起始",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "测速摄像头应用使用的主渐变结束颜色。",
                    label = "主渐变结束",
                },
                speedCameraAppThemeShadow = {
                    description = "测速摄像头应用使用的阴影颜色。",
                    label = "阴影",
                },
                speedCameraAppThemeSpotlight = {
                    description = "测速摄像头应用使用的聚光强调色。",
                    label = "聚光",
                },
                speedCameraAppThemeSubtleText = {
                    description = "测速摄像头应用使用的次要文字颜色。",
                    label = "次要文字",
                },
                speedCameraAppThemeSuccess = {
                    description = "测速摄像头应用使用的成功色。",
                    label = "成功",
                },
                speedCameraAppThemeSurface = {
                    description = "测速摄像头应用使用的表面颜色。",
                    label = "表面",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "测速摄像头应用使用的柔和表面颜色。",
                    label = "柔和表面",
                },
                speedCameraAppThemeText = {
                    description = "测速摄像头应用使用的主要文字颜色。",
                    label = "文字",
                },
                speedCameraAppWarningUiAccent = {
                    description = "测速摄像头警告界面使用的 RGBA 强调色。",
                    label = "强调 RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "测速摄像头警告界面背景使用的 RGBA 颜色。",
                    label = "背景 RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "测速摄像头警告界面使用的 RGBA 图标颜色。",
                    label = "图标 RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "测速摄像头警告界面使用的 RGBA 图标文字颜色。",
                    label = "图标文字 RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "警告界面保持可见的秒数。",
                    label = "警告界面秒数",
                },
                speedCameraAppWarningUiSubText = {
                    description = "测速摄像头警告界面使用的 RGBA 副文字颜色。",
                    label = "副文字 RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "测速摄像头警告界面使用的 RGBA 文字颜色。",
                    label = "文字 RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "测速摄像头警告界面使用的 RGBA 标题颜色。",
                    label = "标题 RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "阻车钉距离检查之间的毫秒数。",
                    label = "检查间隔",
                },
                spikeStripsEnabled = {
                    description = "启用布设的阻车钉。",
                    label = "阻车钉",
                },
                spikeStripsModels = {
                    description = "被视为有效阻车钉的道具模型。",
                    itemLabel = "模型",
                    label = "模型",
                },
                spikeStripsRetryIntervalMs = {
                    description = "未匹配后阻车钉扫描重试前的毫秒数。",
                    label = "重试间隔",
                },
                spikeStripsScanDistance = {
                    description = "扫描附近阻车钉使用的距离。",
                    label = "扫描距离",
                },
                spikeStripsTriggerDistance = {
                    description = "轮胎被阻车钉刺破的距离。",
                    label = "触发距离",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "警局创建器图标使用的分类标签。",
                    label = "警局图标分类",
                },
                stationCreatorBlipColor = {
                    description = "警局使用的地图图标颜色。",
                    label = "警局图标颜色",
                },
                stationCreatorBlipScale = {
                    description = "警局地图图标使用的缩放比例。",
                    label = "警局图标缩放",
                },
                stationCreatorBlipShortRange = {
                    description = "仅在近距离显示警局地图图标。",
                    label = "警局图标短距显示",
                },
                stationCreatorBlipSprite = {
                    description = "警局使用的地图图标样式（sprite）。",
                    label = "警局图标样式",
                },
                stationCreatorBlipUseStationName = {
                    description = "将配置的警局名称用作地图图标标签。",
                    label = "使用警局名称",
                },
                tabletAutoFillCitizens = {
                    description = "从框架数据库预填市民档案。",
                    label = "自动填充市民",
                },
                tabletAutoFillVehicles = {
                    description = "从框架数据库预填车辆档案。",
                    label = "自动填充车辆",
                },
                tabletBolos = {
                    description = "显示 BOLO（协查通告）应用。",
                    label = "BOLO",
                },
                tabletCases = {
                    description = "显示案件应用。",
                    label = "案件",
                },
                tabletCitizens = {
                    description = "显示市民档案应用。",
                    label = "市民",
                },
                tabletOffences = {
                    description = "显示违法行为应用。",
                    label = "违法行为",
                },
                tabletPrison = {
                    description = "显示监狱应用。",
                    label = "监狱",
                },
                tabletReportEnforcement = {
                    description = "允许警员在已保存的报告中关联违法行为并开具罚款或执行监禁。",
                    label = "报告执法",
                },
                tabletReports = {
                    description = "显示报告应用。",
                    label = "报告",
                },
                tabletSocialWork = {
                    description = "显示社会工作应用。",
                    label = "社会工作",
                },
                tabletVehicles = {
                    description = "显示车辆档案应用。",
                    label = "车辆",
                },
                tabletWarrants = {
                    description = "显示逮捕令应用。",
                    label = "逮捕令",
                },
                tabletWeapons = {
                    description = "显示武器档案应用。",
                    label = "武器",
                },
                tackleCuffKey = {
                    label = "铐住被扑倒的人",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                tackleKey = {
                    label = "扑倒",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                tackleReleaseKey = {
                    label = "放开被扑倒的人",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "可发出下一次雷达警报前的毫秒数。",
                    label = "警报冷却",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "允许使用雷达的车辆类别。",
                    label = "允许的车辆类别",
                },
                vehicleRadarAutoFastLock = {
                    description = "在雷达中自动标记速度极快的目标。",
                    label = "自动快速锁定",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "自动快速锁定使用的速度阈值。",
                    label = "快速锁定阈值",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "降低雷达限速使用的按键映射。",
                    label = "降低限速按键",
                },
                vehicleRadarDefaultLimit = {
                    description = "车载雷达使用的默认限速。",
                    label = "默认雷达限速",
                },
                vehicleRadarEnabled = {
                    description = "启用巡逻车雷达。",
                    label = "车载雷达",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "提高雷达限速使用的按键映射。",
                    label = "提高限速按键",
                },
                vehicleRadarLimitStep = {
                    description = "每次调整雷达限速的变化量。",
                    label = "限速步长",
                },
                vehicleRadarLockFrontKey = {
                    description = "锁定前雷达目标使用的按键映射。",
                    label = "前锁定按键",
                },
                vehicleRadarLockRearKey = {
                    description = "锁定后雷达目标使用的按键映射。",
                    label = "后锁定按键",
                },
                vehicleRadarMaxLimit = {
                    description = "车载雷达允许的最大限速。",
                    label = "最大雷达限速",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "雷达锁定目标允许的最大俯仰角。",
                    label = "最大俯仰角度",
                },
                vehicleRadarMinLimit = {
                    description = "车载雷达允许的最小限速。",
                    label = "最小雷达限速",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "雷达将目标视为有效前的最低速度。",
                    label = "最低目标速度",
                },
                vehicleRadarModeFrontKey = {
                    description = "切换前雷达模式使用的按键映射。",
                    label = "前雷达模式按键",
                },
                vehicleRadarModeRearKey = {
                    description = "切换后雷达模式使用的按键映射。",
                    label = "后雷达模式按键",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "巡逻车行驶时雷达扫描之间的毫秒数。",
                    label = "移动扫描间隔",
                },
                vehicleRadarPassengerControl = {
                    description = "允许乘客控制车载雷达。",
                    label = "乘客控制",
                },
                vehicleRadarPassengerEnabled = {
                    description = "允许乘客查看镜像的雷达数据。",
                    label = "乘客镜像",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "为乘客同步雷达数据之间的毫秒数。",
                    label = "乘客同步间隔",
                },
                vehicleRadarProjectionThreshold = {
                    description = "评估雷达目标时使用的投影阈值。",
                    label = "投影阈值",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "雷达锁定目标前需要无遮挡视线。",
                    label = "需要视线",
                },
                vehicleRadarRequireOnDuty = {
                    description = "使用车载雷达前需要处于值班状态。",
                    label = "雷达需值班",
                },
                vehicleRadarScanIntervalMs = {
                    description = "静止状态下雷达扫描之间的毫秒数。",
                    label = "扫描间隔",
                },
                vehicleRadarScanRadius = {
                    description = "车载雷达的扫描半径。",
                    label = "扫描半径",
                },
                vehicleRadarToggleKey = {
                    description = "开关车载雷达使用的按键映射。",
                    label = "开关按键",
                },
                vehicleRadarUseMph = {
                    description = "以 MPH 显示雷达速度值。",
                    label = "雷达使用 MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "附近车辆池刷新之间的毫秒数。",
                    label = "车辆池刷新",
                },
                vehicleRadarXmitFrontKey = {
                    description = "前雷达 XMIT/HOLD 使用的按键映射。",
                    label = "前 XMIT 按键",
                },
                vehicleRadarXmitRearKey = {
                    description = "后雷达 XMIT/HOLD 使用的按键映射。",
                    label = "后 XMIT 按键",
                },
                wheelClampConsumeItem = {
                    description = "放置后移除车轮夹物品。",
                    label = "消耗夹具物品",
                },
                wheelClampEnabled = {
                    description = "启用车轮夹操作。",
                    label = "车轮夹",
                },
                wheelClampItem = {
                    description = "放置车轮夹使用的背包物品。",
                    label = "夹具物品",
                },
                wheelClampPropModel = {
                    description = "放置的车轮夹使用的道具模型。",
                    label = "夹具道具模型",
                },
                wheelClampRequireItem = {
                    description = "需要配置的车轮夹物品。当夹具使用方式设为“背包”或“两者”时请保持启用。",
                    label = "夹具需物品",
                },
                wheelClampRequireOnDuty = {
                    description = "放置车轮夹前需要处于值班状态。",
                    label = "夹具需值班",
                },
                wheelClampTyreDistance = {
                    description = "放置或焊除夹具时到轮胎的最大距离。",
                    label = "轮胎距离",
                },
                wheelClampUseItem = {
                    description = "通过轮盘、背包或两者放置车轮夹。“背包”或“两者”应与“夹具需物品”搭配使用。",
                    label = "夹具使用方式",
                    options = {
                        both = "两者",
                        inventory = "背包",
                        radial = "轮盘",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "放置夹具时到目标车辆的最大距离。",
                    label = "车辆距离",
                },
                wheelClampWeldBurstTyre = {
                    description = "夹具被焊除后使轮胎爆裂。",
                    label = "爆胎",
                },
                wheelClampWeldDurationMs = {
                    description = "通过焊接拆除夹具所需的毫秒数。",
                    label = "焊接时长",
                },
                wheelClampWeldEnabled = {
                    description = "允许使用焊枪拆除车轮夹。",
                    label = "夹具焊除",
                },
                wheelClampWeldItem = {
                    description = "焊除夹具所需的背包物品。",
                    label = "焊枪物品",
                },
                wheelClampWeldMinigame = {
                    description = "拆除完成前需要通过夹具焊接小游戏。",
                    label = "焊接小游戏",
                },
                ziptiesConsumeItem = {
                    description = "使用束线带时移除一个束线带物品。",
                    label = "消耗束线带",
                },
                ziptiesCutterConsumeItem = {
                    description = "剪断束线带后移除剪线物品。",
                    label = "消耗剪线物品",
                },
                ziptiesCutterEnabled = {
                    description = "允许使用剪线钳剪断束线带。",
                    label = "束线带剪",
                },
                ziptiesCutterItem = {
                    description = "剪断束线带使用的背包物品。",
                    label = "剪线物品",
                },
                ziptiesEnabled = {
                    description = "启用束线带操作。",
                    label = "束线带",
                },
                ziptiesItem = {
                    description = "束线带操作使用的背包物品。",
                    label = "束线带物品",
                },
                ziptiesRequireHandsUp = {
                    description = "使用束线带前目标需处于举手状态。",
                    label = "束线带需举手",
                },
                ziptiesRequireItem = {
                    description = "需要配置的束线带物品。",
                    label = "束线带需物品",
                },
                ziptiesReturnOnRemove = {
                    description = "解除束线带时返还一个束线带物品。",
                    label = "返还束线带",
                },
                evidenceGsrDurationSeconds = {
                    description = "枪声残存留在玩家手上",
                    label = "GSR 持续时间",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "枪手戴手套时防止GSR被施用。",
                    label = "手套保护手",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "不使用枪弹残留的武器。",
                    label = "被忽视的武器",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "水/雨水净化检查与 GSR 活动中。",
                    label = "洗刷检查间隔",
                },
                evidenceGsrWashInRain = {
                    description = "雨水可以消除枪弹残留物。",
                    label = "在雨中洗",
                },
                evidenceGsrWashInWater = {
                    description = "水可以去除枪弹残留物。",
                    label = "在水中洗涤",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam 显示假盘子",
                    description = "在直升机摄像机上显示假板。",
                },
                fakePlateNormalToolsDisplay = {
                    label = "普通工具显示假牌",
                    description = "在标准警察工具中显示假牌。",
                },
                fakePlateRadarDisplay = {
                    label = "雷达显示假板",
                    description = "在机载雷达上显示假板。",
                },
                fakePlateRecognitionEnabled = {
                    description = "允许警方系统读取共享的假车牌国家邮袋。",
                    label = "识别假牌",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "汽车实体国家邮袋钥匙由机械人出版。",
                    label = "国家包密钥",
                },
                fakePlateSpeedCamDisplay = {
                    label = "高速显示假车牌",
                    description = "在固定雷达报告中显示假板。",
                },
                fakePlateVinAllowedGrades = {
                    description = "可选职业/职等许可名单:留空,允许允许职业的所有级别。",
                    label = "VIN 职等",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN 工作职位",
                    description = "允许使用VIN核查的行业。",
                },
                fakePlateVinAudit = {
                    label = "审计审计审计审计的审计审计审计审计 VIN 支票支票支票",
                    description = "将VIN项检查保存在审计日志上。",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN 已启用检查",
                    description = "启用VIN号核查指令",
                },
                fakePlateVinCommand = {
                    label = "VIN 命令命令命令",
                    description = "用于核实一辆车辆VIN的指挥中心。",
                },
                fakePlateVinCooldown = {
                    label = "VIN 冷却",
                    description = "两者之间的延迟 VIN 检查。",
                },
                fakePlateVinDistance = {
                    label = "VIN 最大距离",
                    description = "警官与车辆之间的最大距离,以核实其VIN。",
                },
                fakePlateVinIndicator = {
                    label = "显示假显示指示器",
                    description = "检查发现假板时显示指示器。",
                },
                fakePlateVinRequireDuty = {
                    label = "需要值班",
                    description = "要求值班干事核实VIN。",
                },
                fakePlateVinRequireScanner = {
                    label = "需要扫描仪",
                    description = "需要配置的扫描仪对象来校验 VIN. .",
                },
                fakePlateVinScannerItem = {
                    label = "扫描器物品",
                    description = "核查VIN号物品所需的库存物品。",
                },
                jailRemoveJobOnJail = {
                    description = "囚犯入狱时,请安排他们失业。",
                    label = "取消在监狱的职业",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "释放后恢复犯人原来的职业 禁止他们失业",
                    label = "恢复原有职业",
                },
                primaryColor = {
                    description = "警察职业组的默认颜色。",
                    label = "原色",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "允许审查员向注册车主开账单,即使被捕获的车牌被标为假牌或克隆。",
                    label = "允许可疑假牌",
                },
                speedCamAdvancedPageSize = {
                    description = "每平面页返回的最大捕捉量。",
                    label = "审查页面大小",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "其照片可用于识别车牌的车面,使用前方和/或后方。",
                    itemLabel = "侧边",
                    label = "公认的各方",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "仅允许在速度相机照片上传完成后批准 。",
                    label = "需要照片证据",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu 批准或丢弃捕获所需的许可。 18 是管理账单。",
                    label = "审核许可 ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "继续捕捉登记在册车辆数据库中没有车牌的人。",
                    label = "储存未登记车辆",
                },
                tabletConfiscations = {
                    description = "显示在玩家搜索过程中没收的项目日志 。",
                    label = "没收物品",
                },
                tabletSpeedcamReviews = {
                    description = "当启用高级模式时, 显示高级速度相机审查程序 。",
                    label = "高速摄影机审查",
                },
                tackleCommand = {
                    description = "已经注册命令, 以与最接近的人联系。 输入命令名称时不使用斜线 。",
                    label = "处理命令",
                },
                tackleCuffCommand = {
                    description = "注册命令, 用于将目前被绑在钩子后的人铐住。 输入命令名称时不使用斜线 。",
                    label = "处理手铐指令",
                },
                tackleCuffDescription = {
                    description = "在 FiveM 键绑定菜单中显示钩手铐绑定的描述 。",
                    label = "处理手铐键盘描述",
                },
                tackleDescription = {
                    description = "在 FiveM 键绑定菜单中显示绑定钩的描述 。",
                    label = "处理按键列描述",
                },
                tackleEnabled = {
                    description = "启动定位最接近的人 并把他们放在地上",
                    label = "扑倒",
                },
                tackleMaxDistance = {
                    description = "启动钩子时距离目标的最大距离 。",
                    label = "处理距离",
                },
                tackleNeedsSprint = {
                    description = "要求警员在抓人前先冲刺",
                    label = "处理需要冲刺",
                },
                tackleReleaseCommand = {
                    description = "注册命令, 以释放目前被绑在钩子后的人。 输入命令名称, 不带斜线 。",
                    label = "处理释放命令",
                },
                tackleReleaseDescription = {
                    description = "在 FiveM 键绑定菜单中显示绑定的钩子释放的描述 。",
                    label = "处理释放密钥串描述",
                },
                tackleRequireOnDuty = {
                    description = "官员在对一个人进行追捕之前,必须说明责任国。",
                    label = "处理需要责任",
                },
                vehicleRadarCustomizeCommand = {
                    description = "用于打开或关闭雷达布局编辑器的命令。输入命令名称时不使用斜线。",
                    label = "雷达布局命令",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "用于恢复默认雷达布局的命令。输入命令名称时不使用斜线。",
                    label = "重设雷达布局命令",
                },
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
            locationDescriptions = {
                jail_public_blip = "位置自动取自监狱出生点；未设置时使用第一个监狱终端。",
            },
            warnings = {
                cuffsConsumeRequiresItem = "装上手铐没有效果,而袖扣物品的要求则被禁用。",
                wheelClampUseItemRequiresItem = "使用 Clamp 使用模式库存, 或者 两者都需要 Cramp 要求项目保持启用 。",
                ziptiesConsumeRequiresItem = "折叠拉链无效, 而拉链项要求被禁用 。",
            },
        },
    },
    JobConfiguratorImportFailed = "导入 config.lua 值为 ' 失败%s': %s. .",
    JobConfiguratorImportHistoryFailed = "导入成功, 但无法保存历史条目 。",
    JobConfiguratorImportNoData = "' '%s提供不配置 lua 导入数据 。",
    JobConfiguratorImportSuccess = "导入的 config.lua 值%s': %d 工作, %d 设置, %d 特性, 和 %d 应用的交互偏差。",
    JobConfiguratorTitle = "作业配置器",
    JobConfiguratorUnknown = "未知的职业配置器 。",
}
