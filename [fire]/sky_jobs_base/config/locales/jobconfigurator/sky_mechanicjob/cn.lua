JobConfigLocales["sky_mechanicjob:cn"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "移动马力机设施",
                    entryPluralLabel = "移动马力机设施",
                    label = "移动马力机设施",
                },
                workshops = {
                    entryLabel = "工作坊",
                    entryPluralLabel = "研讨会",
                    label = "研讨会",
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
                crewCapacity = "可加入此单位的最大人员数；填 0 表示不限制。",
                joinLocked = "单位有人值守后，禁止其他人员继续加入。",
                minimumCrew = "此响应方案所选单位必须达到的最低人员数。",
                poiId = "稳定技术标识；地点重命名后，中心配置仍可引用它。",
                readyStatusCode = "资源进入可调度状态时应用的 FMS 状态。",
                resourceType = "为调度筛选和协同标记此作战资源的类别。",
                respondingStatusCode = "资源响应警情时应用的 FMS 状态。",
                shortLabel = "显示在六个无线电频道存储键上的可选短标签。",
                stationId = "将此单位关联到调度中心配置中的站点。",
                unitId = "即使无线电呼号改变，也用于保留该单位的稳定技术标识。",
                autoAlarm = "创建事件后立即分配匹配的可用单位。",
                available = "处于此状态的单位可能会被建议并分配给新事件。",
                averageResponseSpeedKmh = "根据直线距离计算显示的预计到达时间。",
                callsign = "当玩家配置此虚拟单位时，会显示独特的无线电呼号。",
                centerEnabled = "允许授权值班人员为调度中心配备人员。",
                channelId = "PMA Voice、SaltyChat 和 YACA 的无线电频道 ID。数字ID如2500保持不变； PMA Voice 将文本 ID 映射到稳定的号码。",
                channelLabel = "向调度员和单位显示的可读频道名称。",
                defaultChannel = "调度员在开始轮班时加入此频道。从“无线电”选项卡手动加入单位。选择“无”以使用作业组默认值。",
                emergencyAppEnabled = "使该工作可以在紧急电话应用程序中选择为公共服务。",
                enabled = "使此作业可用于调度应用程序和跨作业事件。",
                icon = "选择调度应用程序中该单位类别显示的图标。",
                incidentAssessmentEnabled = "显示完整事件记录中的医疗和危险评估问题。",
                jobs = "使用此关键字接收事件的其他作业名称。",
                noUnitFallback = "在没有中心或人员单位的情况下，向所有值班成员发送 Sky 通知。",
                radius = "可以听到电台广播的最大距离（以米为单位）。",
                requirements = "响应需求为 TYPE:COUNT 对，例如 PATROL:2,CRIME:1。",
                statusCode = "手持无线电上显示数字 FMS 状态。",
                statusLabel = "此 FMS 状态对于调度员和单位的含义。",
                vehicleType = "必须与上一小节中配置的车辆类型代码匹配。",
                vehicleTypeCode = "响应要求中使用的短单位代码，例如 PATROL、CRIME、EMS 或 RESCUE。",
                vehicleTypeLabel = "该单位类别的可读名称。",
            },
            dispatchFields = {
                crewCapacity = "乘员容量",
                joinLocked = "锁定乘员加入",
                minimumCrew = "最低乘员数",
                poiId = "稳定 POI ID",
                readyStatusCode = "就绪状态代码",
                resourceType = "资源类型",
                respondingStatusCode = "出动状态代码",
                shortLabel = "电台存储标签",
                stationId = "站点 ID",
                unitId = "稳定单位 ID",
                address = "地址",
                autoAlarm = "自动报警",
                available = "可供发货",
                averageResponseSpeedKmh = "预计响应速度（公里/小时）",
                callsign = "呼号",
                category = "类别",
                centerEnabled = "启用调度中心",
                channelId = "频道 ID",
                code = "代码",
                defaultChannel = "默认广播频道",
                emergencyAppEnabled = "在紧急应用程序中显示",
                enabled = "启用调度",
                icon = "图标",
                incidentAssessmentEnabled = "启用紧急评估",
                jobs = "目标职位（逗号分隔）",
                keywordCode = "关键字代码",
                label = "标签",
                name = "姓名",
                noUnitFallback = "通知无单位值班人员",
                noneChannel = "无/组默认",
                note = "注意",
                phone = "电话",
                radius = "公告半径",
                requirements = "所需单位（例如巡逻：2，犯罪：1）",
                type = "类型",
                vehicleType = "响应单元类型",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "已知报警人",
                    channels = "无线电频道",
                    plans = "响应方案",
                    statuses = "可用的 FMS 状态",
                    units = "虚拟单位",
                },
                active = "调度已启用",
                description = "配置此职业的紧急事件接报、无线电、单位、响应方案、地点和报警人资料。",
                inactive = "调度已禁用",
                steps = {
                    accessText = "启用调度，并决定此职业的人员是否可以在调度中心值班。",
                    accessTitle = "权限与接报",
                    fleetText = "配置频道、FMS 状态代码、车辆类型和呼号。",
                    fleetTitle = "无线电与车队",
                    responseText = "最后配置关键词、响应要求和兴趣点。",
                    responseTitle = "响应方案",
                },
                title = "调度中心",
                warnings = {
                    channels = "没有明确配置无线电频道；将使用职业组的备用频道。",
                    defaultChannel = "所选的默认频道已不存在。",
                    disabled = "此职业的调度功能已禁用。",
                    statuses = "必须至少有一个可用的 FMS 状态，才能向单位发出警报。",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "管理该职业的报警人姓名、回拨号码和调度备注。",
                dispatchChannels = "定义单位和人员调度中心可以加入的无线电频道。",
                dispatchKeywords = "定义事件关键字、所需车辆数量、参与作业和可选的自动警报。",
                dispatchPois = "存储事件表格和基于位置的电台公告的电台和公共位置。",
                dispatchStatusCodes = "配置 FMS 状态标签以及哪些状态算作可用于新事件。",
                dispatchVehicleTypes = "定义响应计划使用的单位类别，例如巡逻、犯罪单位、EMS 或救援。",
                dispatchVehicles = "定义虚拟调度车辆，可以在任何地方配备人员，而不需要生成车辆。",
            },
            diagnosticsSettings = {
                enabledLabel = "启用车辆诊断",
                enabledDescription = "允许此职业打开车辆诊断并通过诊断界面维修部件。",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "车辆诊断",
                    description = "配置此职业的车辆诊断访问权限。",
                },
                dispatchReporters = "已知报警人",
                invalidSelection = "无效选项：{value}",
                billingPrices = {
                    description = "配置维护和修理历史记录的发票价格。 动作密钥与action_key、 action_type或工作标签匹配 。",
                    label = "计费价格",
                },
                billingSettings = {
                    description = "为这个职业配置机械计费行为",
                    label = "账单",
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
                partsDeliveryShop = "分批交货商店",
                trainingSettings = {
                    description = "为此作业配置培训访问、注册、批准和课程规划。",
                    label = "训练设置",
                },
                tuningCostProfile = {
                    description = "配置此专业的性能、 外观、 轮子和特殊选项成本。 成本支持需要项目阵列和分阶段升级对象 。",
                    label = "计票价格",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "改装菜单自由视角",
                    description = "允许按空格键隐藏光标并自由移动视角。Escape 仍可关闭菜单。",
                },
                tuningCamera = {
                    description = "自动将镜头移向所选部件。关闭后使用普通游戏镜头。",
                    label = "自动改装镜头",
                },
                jgMileage = {
                    description = "当 JG Vehicle Mileage 资源运行时使用其里程，否则使用 Sky 里程。JG HUD 单独配置。",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "在 JG HUD 中显示所选里程。不需要 JG Vehicle Mileage；请按 README 安装 HUD 适配器。",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "启用管理员编辑器及按车牌和车型自动应用的操控规则。停用后，请将受影响的车辆重新停入并驶出车库，以清除已应用的数值。",
                    label = "操控编辑器",
                },
                kuv = {
                    description = "开始技术检验",
                    label = "车辆技术检验",
                },
                mobileDyno = {
                    description = "启用可放置的高级移动马力机、控制与结果屏幕、风扇控制器和平板应用。",
                    label = "移动马力机",
                },
                vehicleRegistration = {
                    description = "登记或过户车辆",
                    label = "车辆登记",
                },
                antiLag = {
                    description = "实现防滞后安装和排气效果。",
                    label = "抗滞后",
                },
                brakeOverheating = {
                    description = "启动级制动热、光碟、临界火花和短刹退缩。",
                    label = "刹车过热",
                },
                carryItems = {
                    description = "要求交付的零件通过车间进行运输。",
                    label = "物理零件处理",
                },
                customHandling = {
                    description = "启用自定义传动系统和操控调整。",
                    label = "定制处理",
                },
                electronicTuning = {
                    description = "激活持续ECU、照明和司机协助调试选项。",
                    label = "电子发票",
                },
                instantTuning = {
                    description = "允许在配置的公共调谐位置进行直接调谐。",
                    label = "即时调音",
                },
                mileageHud = {
                    description = "行驶时显示车辆里程信息。",
                    label = "里程平视显示器",
                },
                nitro = {
                    description = "启用硝基安装和车辆增压使用。",
                    label = "硝基",
                },
                partsDelivery = {
                    description = "启用车间零件交货订单和交货站。",
                    label = "零件交付",
                },
                selfServiceOrderNotifications = {
                    description = "在建立自助调试令时通知在职雇员。",
                    label = "自助订单通知",
                },
                stance = {
                    description = "在所有调试菜单中显示调制调整, 并启用 Stance Kit 项 。",
                    label = "车身姿态",
                },
                stanceWheelSize = {
                    description = "在 Stance 中显示、保存和应用轮式大小调整。",
                    label = "Stance 轮轮体大小",
                },
                stanceWheelWidth = {
                    description = "在 Stance 中显示、保存和应用轮宽度调整。",
                    label = "Stance 轮宽度",
                },
                subscriptions = {
                    description = "启动车间订阅终端、管理和客户折扣。",
                    label = "讲习班订阅",
                },
                twoStep = {
                    description = "启用两步发射控制和排气效果。",
                    label = "两步法",
                },
                vehicleMaintenanceNotifications = {
                    description = "车辆达到配置保养门槛时通知所有者。",
                    label = "车辆维修通知",
                },
                wheelDamage = {
                    description = "实现真实的车轮损坏和修复。",
                    label = "车轮损坏",
                },
                workshopLift = {
                    description = "启用车间中配置的可用提升点。",
                    label = "车间电梯",
                },
            },
            locationDescriptions = {
                vehicle_registry = "将此点设置在维修厂的检验工位。进行车辆技术检验和登记时，车辆必须处于设定的检验距离内。",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "放置马力机结果屏幕的位置。",
                    label = "马力机结果屏幕",
                },
                mobile_dyno_station = {
                    description = "放置移动马力机的位置。",
                    label = "移动马力机站",
                },
                vehicle_registry = "车辆检验与登记点",
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
            settingGroups = {
                diagnostics = {
                    label = "诊断",
                },
                keybinds = {
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                    label = "按键设置",
                },
                safety = {
                    label = "验证与安全",
                },
                antiExploit = {
                    label = "反剥削",
                },
                coach = {
                    label = "遥测教练",
                },
                cooldownMultipliers = {
                    label = "冷却系数",
                },
                crashFalloff = {
                    label = "崩溃坠落",
                },
                criticalEngine = {
                    label = "断断引擎",
                },
                deformation = {
                    label = "变形",
                },
                fade = {
                    label = "刹车热衰减",
                },
                features = {
                    label = "特征",
                },
                format = {
                    label = "格式格式格式格式",
                },
                frontalImpact = {
                    label = "严重前线影响",
                },
                general = {
                    label = "通用",
                },
                heatMultipliers = {
                    label = "升温系数",
                },
                illegalMarket = {
                    label = "非法市场",
                },
                integration = {
                    label = "集成",
                },
                items = {
                    label = "物品",
                },
                lifetime = {
                    label = "使用寿命",
                },
                limits = {
                    label = "储存限制",
                },
                repairRestore = {
                    label = "修理恢复",
                },
                risk = {
                    label = "风险",
                },
                rules = {
                    label = "规则",
                },
                stages = {
                    label = "过热阶段",
                },
                tyreRepair = {
                    label = "轮胎修理",
                },
                visuals = {
                    label = "视觉效果",
                },
            },
            settingSections = {
                electronicTuning = "ECU 发动机程序",
                handlingEditor = "操控编辑器",
                mobileDyno = "移动马力机",
                vehicleRegistry = "车辆证明",
                advancedPricing = "高级定价",
                brakeOverheating = "刹车过热",
                carryItems = "随运物品",
                fakePlates = "假白白板",
                firejobVehicleFires = "车辆失火",
                general = "一般的",
                instantTuning = "即时调音",
                maintenanceNotifications = "维修维修通知",
                mileageHud = "里程平视显示器",
                oilLeaks = "车辆液体漏漏漏",
                partsTheft = "部件盗窃",
                subscriptions = "订阅",
                tuning = "调整",
                vehicleCare = "车辆看车",
                wear = "磨损",
                wheelDamage = "车轮损坏",
            },
            settingSubsectionGroups = {
                handlingAdditional = "附加",
                handlingAir = "空中",
                handlingGeneral = "常规",
                handlingRoad = "陆地",
                handlingWater = "水上",
            },
            settingSubsections = {
                mechanicHotkeys = "按键设置",
                database = "数据库",
                handlingEditorGeneral = "编辑器设置",
                handlingMaximumCBikeHandlingData = "摩托车",
                handlingMaximumCBoatHandlingData = "船舶",
                handlingMaximumCCarHandlingData = "汽车",
                handlingMaximumCFlyingHandlingData = "飞机",
                handlingMaximumCHandlingData = "车辆基础",
                handlingMaximumCSeaPlaneHandlingData = "水上飞机",
                handlingMaximumCSpecialFlightHandlingData = "特殊飞行",
                handlingMaximumCSubmarineHandlingData = "潜艇",
                handlingMaximumCTrailerHandlingData = "拖车",
                handlingMaximumCVehicleWeaponHandlingData = "车载武器",
                keybinds = "按键设置",
                operation = "运行",
                placementRules = "放置规则",
                testFlow = "测试流程",
                tuning = "即时改装选项",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "车辆维修",
                    description = "在即时改装点提供车辆维修服务。",
                },
                instantTuningRepairPrice = {
                    label = "维修价格",
                    description = "固定维修价格，不受改装价格倍率影响。",
                },
                instantTuningWashEnabled = {
                    label = "车辆清洗",
                    description = "在即时改装点提供车辆清洗服务。",
                },
                instantTuningWashPrice = {
                    label = "清洗价格",
                    description = "固定清洗价格，不受改装价格倍率影响。",
                },
                vehiclePriceSource = {
                    label = "车辆价格来源",
                    description = "自动：ESX 使用 SQL；QBCore/Qbox 使用车辆目录。数据库：所有框架使用配置的 SQL 表。",
                    options = {
                        auto = "自动（框架）",
                        database = "数据库",
                    },
                },
                vehiclePriceTable = {
                    label = "车辆价格表",
                    description = "包含购买价格的表，例如 dealership_vehicles（JG）。",
                },
                vehiclePriceModelColumn = {
                    label = "生成名称列",
                    description = "包含车辆生成名称的列，例如 spawn_code（JG），不是显示名称。",
                },
                vehiclePricePriceColumn = {
                    label = "价格列",
                    description = "包含数值购买价格的列，例如 price。",
                },
                vehiclePriceHashColumn = {
                    label = "模型哈希列（可选）",
                    description = "可选的数值哈希列，例如 hashkey（JG）。留空时根据车辆生成名称计算哈希。",
                },
                handlingEditorFieldMaximum = {
                    description = "编辑器为此操控字段接受的硬性最大值。",
                },
                handlingEditorFocusKey = {
                    label = "返回操控编辑器",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "编辑器请求、响应或快照的编码字节数超过此值后将被报告为过大。",
                    label = "大负载阈值",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "测量编辑器操作，并在超过配置限制时通过 Sky.Debug 发出警告。",
                    label = "性能检查",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "启用详细调试日志时，两次汇总性能报告之间的毫秒数。",
                    label = "性能汇总间隔",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "操控编辑器操作超过此毫秒数后将被报告为缓慢。",
                    label = "慢操作阈值",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "数值滑块相对于已读取车辆基础值可上下调整的最大百分比。直接输入和 XML 导入不会被截断。 单独设置且不同于默认值的字段上限会替代滑块的上端点。",
                    label = "滑块最大偏差",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "催化器盗窃 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "催化器盗窃 · 控制 73",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl172 = {
                    label = "测功机 · 控制 172",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl173 = {
                    label = "测功机 · 控制 173",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl174 = {
                    label = "测功机 · 控制 174",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl175 = {
                    label = "测功机 · 控制 175",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl177 = {
                    label = "测功机 · 控制 177",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl38 = {
                    label = "测功机 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl45 = {
                    label = "测功机 · 控制 45",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicDynoControl47 = {
                    label = "测功机 · 控制 47",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicSprayPaintControl200 = {
                    label = "喷漆 · 控制 200",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicSprayPaintControl202 = {
                    label = "喷漆 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehicleCareControl200 = {
                    label = "车辆养护 · 控制 200",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehicleCareControl202 = {
                    label = "车辆养护 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "推动车辆 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "推动车辆 · 控制 33",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "推动车辆 · 控制 34",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "推动车辆 · 控制 35",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "推动车辆 · 控制 32",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "推动车辆 · 控制 21",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicWheelChangeControl200 = {
                    label = "换轮 · 控制 200",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicWheelChangeControl202 = {
                    label = "换轮 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicWheelChangeControl22 = {
                    label = "换轮 · 控制 22",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "车轮盗窃 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "车轮盗窃 · 控制 73",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                mobileDynoConsumeItem = {
                    description = "成功放置后移除一个物品。",
                    label = "消耗物品",
                },
                mobileDynoCooldownMs = {
                    label = "冷却时长",
                },
                mobileDynoCountdownMs = {
                    label = "启动倒计时",
                },
                mobileDynoDuiDistance = {
                    label = "面板渲染距离",
                },
                mobileDynoFanInteractionDistance = {
                    label = "风扇控制器交互距离",
                    description = "冷却扇之间使用物理开关的距离(米)",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "满负荷持续时间",
                    description = "在包含满载阶段的剖面图中持续全负荷消耗的毫秒。",
                },
                mobileDynoHistoryLimit = {
                    label = "历史记录上限",
                },
                mobileDynoInteractionDistance = {
                    label = "面板交互距离",
                },
                mobileDynoItemUseEnabled = {
                    description = "允许使用库存物品放置测功机和显示器。",
                    label = "使用物品放置",
                },
                mobileDynoMaxActiveSessions = {
                    label = "活动会话上限",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "车辆连接距离",
                },
                mobileDynoMonitorItem = {
                    description = "用于放置结果显示器的库存物品。",
                    label = "显示器物品",
                },
                mobileDynoPersistItems = {
                    description = "服务器重启后保留新放置的设备。",
                    label = "保存放置位置",
                },
                mobileDynoPickupDistance = {
                    description = "拾取设备的最大距离，单位为米。",
                    label = "拾取距离",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "最大高度差",
                    description = "所有堤坝足迹探勘器都可接受最大高度的地面高度变化。",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "最大放置坡度",
                    description = "山堤足迹之间最大地面坡度为可接受度。",
                },
                mobileDynoRequireOnDuty = {
                    description = "机械师必须在岗才能放置和操作设备。",
                    label = "要求在岗",
                },
                mobileDynoResultDuiDistance = {
                    label = "结果屏幕渲染距离",
                    description = "独立结果显示器的最大距离(米)。",
                },
                mobileDynoReturnItem = {
                    description = "收起设备时归还之前消耗的物品。",
                    label = "归还物品",
                },
                mobileDynoStationItem = {
                    description = "用于放置测功机的库存物品。",
                    label = "测功机物品",
                },
                mobileDynoTabletDistance = {
                    description = "使用平板控制和进行测试时，距离测功机的最大距离，单位为米。",
                    label = "平板操作范围",
                },
                nitroActivationKey = {
                    label = "按住氮气加速",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                registryBikeChecks = {
                    description = "摩托车检查项目",
                    label = "摩托车检查项目",
                },
                registryCarChecks = {
                    description = "汽车检查项目",
                    label = "汽车检查项目",
                },
                registryDistance = {
                    description = "服务距离（米）",
                    label = "服务距离（米）",
                },
                registryKuvFee = {
                    description = "车辆技术检验费用",
                    label = "车辆技术检验费用",
                },
                registryKuvValidityDays = {
                    description = "新检验按现实时间计算，默认30天。现有证明的到期时间保持不变。",
                    label = "检验有效期（现实天数）",
                },
                registryKuvWarningDays = {
                    description = "预警时间（天）",
                    label = "预警时间（天）",
                },
                registryRegistrationFee = {
                    description = "登记费用",
                    label = "登记费用",
                },
                registryReinspectionFee = {
                    description = "复检费用",
                    label = "复检费用",
                },
                registryRequireKuv = {
                    description = "登记时要求有效车辆技术检验",
                    label = "登记时要求有效车辆技术检验",
                },
                registrySessionSeconds = {
                    description = "确认时限（秒）",
                    label = "确认时限（秒）",
                },
                registryTransferFee = {
                    description = "过户费用",
                    label = "过户费用",
                },
                registryVehicleTypes = {
                    description = "允许的车辆类型",
                    label = "允许的车辆类型",
                },
                tuningFocusKey = {
                    label = "改装界面鼠标交互",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                addRevenueToSociety = {
                    description = "存款付的调频汇票汇入调频专业社会账户。",
                    label = "社会存款收入",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "允许在提前定价的同时可以自由购买的零部件交付商店类别。 匹配时忽略外壳和空白 。",
                    itemLabel = "类别",
                    label = "总是可用类别",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "保持从选定类别中配置的商店项目,不需调制订单,并通过动态供应商系统定价。",
                    label = "始终可用商店用品",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "平板电脑利润分析所示天数。",
                    label = "分析周期",
                },
                advancedPricingCategoryRules = {
                    description = "供应商份额、利润、劳动力和价格的界限,通过调整类别。",
                    label = "类别规则",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "班级和职等调整前的默认机械工差。",
                    label = "默认差值",
                },
                advancedPricingDifficultyRules = {
                    description = "每次调试困难都增加人工成本。",
                    label = "困难规则",
                },
                advancedPricingEnabled = {
                    description = "重新计算服务器上的调整价格,并在能够交付部件时,要求购买旧部件,以取得特定的调制订单。",
                    label = "激活预先定价",
                },
                advancedPricingInventoryBaseStock = {
                    description = "每个供应商物品的正常虚拟库存。",
                    label = "基地库存",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "每天切除需求点。",
                    label = "每日需求衰变",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "每个需求点都增加了供应商加价。",
                    label = "单位需求增长",
                },
                advancedPricingInventoryEnabled = {
                    description = "当虚拟股票低或需求高时,供应商价格上升。",
                    label = "动态供应商存量",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "低库存造成最大供应商加价。",
                    label = "低库存加价",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "库存水平,紧缺物价开始上涨。",
                    label = "低库存阈值",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "需求标记的上边界 。",
                    label = "最大需求标记",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "每天补充虚拟单位。",
                    label = "每日膳食",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "机械发票全球贴现上限。",
                    label = "最高折扣",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "最高允许的机械机修间隔。",
                    label = "最大幅度",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "调频部分的全球上限价格。",
                    label = "最高零售价格",
                },
                advancedPricingMechanicGradeRules = {
                    description = "机械师等级的标记、劳动和折扣界限。",
                    label = "机械级规则",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "最低许可的机械机修间隔。",
                    label = "最低差值",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "调音部分的全球较低价格界限。",
                    label = "最低零售价格",
                },
                advancedPricingPreviewCompactValue = {
                    description = "用于契约示例的车辆价值。",
                    label = "压缩预预览值",
                },
                advancedPricingPreviewCostPercent = {
                    description = "现场预览所使用的调整成本百分比示例。",
                    label = "预预览调调率",
                },
                advancedPricingPreviewSportsValue = {
                    description = "体育范例使用的车辆价值。",
                    label = "体育预览值",
                },
                advancedPricingPreviewSuperValue = {
                    description = "超级汽车范例所用的车辆价值。",
                    label = "超级预览值",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "在未支付价格报价被重新计算之前的分钟。",
                    label = "引号寿命",
                },
                advancedPricingReturnRefundPercent = {
                    description = "采购定购部分退款百分比。",
                    label = "退回退退退退",
                },
                advancedPricingRoundingStep = {
                    description = "每一个王朝采购线都绕到这个钱的阶梯上",
                    label = "供应商四舍四入",
                },
                advancedPricingSupplierSharePercent = {
                    description = "由王朝汽车供应公司收取的客户部分价格的百分比。",
                    label = "供应商份额",
                },
                advancedPricingTaxPercent = {
                    description = "在定价会计中单独储存的税收百分比。",
                    label = "纳税税税税税",
                },
                advancedPricingVehicleClassRules = {
                    description = "边际和劳动力调整 GTA 车辆类。",
                    label = "车辆级细则",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "刹车升级冷压乘数",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "车辆级冷压乘数",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "活动冷却开始之前的制动后延迟( 毫秒) 。",
                    label = "缓缓延迟",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "不使用刹车时每秒取热。",
                    label = "冷却速率",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "热水平,火花和刹车短时间减退可以开始。",
                    label = "关键临界门槛值",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "可能来自 0 至 1 短时间刹车停车 和紧要关头的刹车",
                    label = "每秒失去机会",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "淡化冷却",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "最大淡减持续时间",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "最小淡减时间",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "制动升级加热增热乘数",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "车辆级车级加热乘数",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "以参考速度制动时,每秒获得基地热量。",
                    label = "热热增益",
                },
                brakeOverheatingHotThreshold = {
                    label = "热门槛值",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "制动前最低车速(公里/小时)产生热量。",
                    label = "最低制动速度",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "应用配置基本热增速的千米/小时速度。",
                    label = "参考速度",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "最大火花间隔",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "最低火花间隔",
                },
                brakeOverheatingVisualDistance = {
                    description = "最大距离,以米计,以发光和点火。",
                    label = "视觉距离",
                },
                brakeOverheatingWarmThreshold = {
                    label = "热临界值",
                },
                carryItems = {
                    description = "所交付的部件应该成为实际携带的道具。",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "引擎潮热",
                                forklift = "叉车",
                                hand = "手手手手",
                            },
                        },
                    },
                    itemLabel = "随运物品",
                    label = "携带物品",
                },
                ecuEngineTorqueStage1 = {
                    description = "1.00 表示不增加动力；1.10 表示扭矩增加 10%。适用于安装此 ECU 阶段的车辆。",
                    label = "第 1 阶段扭矩倍率",
                },
                ecuEngineTorqueStage2 = {
                    description = "1.00 表示不增加动力；1.10 表示扭矩增加 10%。适用于安装此 ECU 阶段的车辆。",
                    label = "第 2 阶段扭矩倍率",
                },
                ecuEngineTorqueStage3 = {
                    description = "1.00 表示不增加动力；1.10 表示扭矩增加 10%。适用于安装此 ECU 阶段的车辆。",
                    label = "第 3 阶段扭矩倍率",
                },
                ecuEngineTorqueStage4 = {
                    description = "1.00 表示不增加动力；1.10 表示扭矩增加 10%。适用于安装此 ECU 阶段的车辆。",
                    label = "第 4 阶段扭矩倍率",
                },
                fakePlatesAudit = {
                    label = "审核日志",
                },
                fakePlatesBlacklist = {
                    description = "无法出现在假牌盘中的封隔单词或碎片 。",
                    label = "黑名单",
                },
                fakePlatesBlankPlateItem = {
                    description = "用于伪造板块经济循环的手工艺/车间材料。",
                    label = "空白板板物品",
                },
                fakePlatesCooldownMinutes = {
                    label = "冷却分钟数",
                },
                fakePlatesCrashFalloffChance = {
                    label = "A. 失 失 机",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "崩溃坠落启用",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "最小崩溃速度",
                },
                fakePlatesEnabled = {
                    description = "允许玩家在车辆上使用假牌袋。",
                    label = "激活假牌",
                },
                fakePlatesExpireMinutes = {
                    description = "0 在重置或重新开始处理之前, 假牌盘保持活动状态 。",
                    label = "过期分钟",
                },
                fakePlatesExpireOnRestart = {
                    label = "重新启动时过期",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "付款账户",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "建立非法市场",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "非法市场价格",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "风险倍率",
                },
                fakePlatesInstallDurationMs = {
                    label = "安装持续时间 ms",
                },
                fakePlatesItem = {
                    description = "启动假板板安装流程的一次性物品",
                    label = "假板装具袋物品",
                },
                fakePlatesMaxLength = {
                    label = "最长长度",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "车辆距离",
                },
                fakePlatesMinLength = {
                    label = "最短长度",
                },
                fakePlatesPattern = {
                    description = "Lua模式用于验证假板纸文字,例如_____________________[A-Z0-9]+$。",
                    label = "Lua 模式",
                },
                fakePlatesPlateInstallDistance = {
                    label = "牌盘位置距离",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "区块重复活动假板",
                },
                fakePlatesPrinterItem = {
                    description = "用于伪造板块经济循环的手工艺/车间工具。",
                    label = "Chate 打印机项目",
                },
                fakePlatesRequireEngineOff = {
                    label = "引擎必须关闭",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "在允许安装前先使用Config.Functions.CanApplyFakePlate。",
                    label = "需要所有者或密钥",
                },
                fakePlatesRequireStopped = {
                    label = "必须拦截车辆",
                },
                fakePlatesResetOnGarageStore = {
                    description = "保留用于称为重置事件/出口的车库整合。",
                    label = "车库商店重置",
                },
                fakePlatesRiskCharacters = {
                    label = "Typo 字符",
                },
                fakePlatesRiskEnabled = {
                    label = "启用了风险打分",
                },
                fakePlatesRiskTypoChance = {
                    label = "泰波机会",
                },
                fallbackVehicleValue = {
                    description = "车辆价格无法解决时使用的价值。",
                    label = "后备车辆价值",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "可能来自 0 至 1 在引擎仍然关键后。",
                    label = "关键引擎消防机会",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "再过几秒钟 引擎失火就会触发",
                    label = "关键引擎冷却",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "在引擎失灵前延迟几毫秒",
                    label = "关键引擎延迟 ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "允许严重损坏的引擎在延误后开始消防车火灾。",
                    label = "Ignite 破损引擎",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "发动机失火时使用的烟雾密度。",
                    label = "关键发动机烟雾密度",
                },
                firejobVehicleFiresEnabled = {
                    description = "允许机械工工伤系统要求消防车起火。",
                    label = "消防车起火",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "所需前向变动比率 0 至 1. .",
                    label = "前进运动比率",
                },
                firejobVehicleFiresImpactChance = {
                    description = "可能来自 0 至 1 符合条件的撞击起火",
                    label = "撞击火灾机会",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "再过几秒钟 撞击火就会触发",
                    label = "撞击火灾冷降",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "允许强烈的正面事故要求消防车开火。",
                    label = "严重撞车事故后",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "坠机引发火灾时使用的烟雾密度。",
                    label = "影响烟烟烟密度",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "自动使用配置的消防资源; 残疾人防止机械工产生火灾。",
                    label = "融合模式",
                    options = {
                        automatic = "自动",
                        disabled = "已禁用",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "影响期间损失的最低身体健康水平。",
                    label = "最小身体损害",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "在撞击中损失了最低引擎健康。",
                    label = "最小发动机损坏",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "使用0 禁用此变形检查 。",
                    label = "最小前端变形",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "最小影响前速度(公里/小时)",
                    label = "最小撞击速度",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "撞击期间按公里/小时计算的所需速度损失。",
                    label = "最低速度损失",
                },
                firejobVehicleFiresResource = {
                    description = "接收车辆消防请求的资源。",
                    label = "消防工作资源",
                },
                firejobVehicleFiresServerEvent = {
                    description = "技工客户使用内部服务器事件要求消防车起火。",
                    label = "机械服务器活动",
                },
                freeVehicles = {
                    description = "免费调试的车辆产卵模型。",
                    itemLabel = "车辆型号",
                    label = "免费调制车辆",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "在关键处理冲突时加以预防。",
                    label = "关键成果块",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "完成制动测试时,预期最大减速为 m/s2 。",
                    label = "最小减速减速",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "遥测教练评估一次运行之前需要测量样品。",
                    label = "最低样本",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "以报告牵引力损失的公里/小时测量的轮滑速度。",
                    label = "轮滑警告",
                },
                handlingEditorDefaultTab = {
                    description = "当独立处理编辑器打开时选择页面。",
                    label = "开始页面",
                    options = {
                        advanced = "高级",
                        export = "导出",
                        flags = "旗旗",
                        fleet = "舰队",
                        inspector = "层层",
                        profiles = "配置简介",
                        simple = "简单",
                        telemetry = "遥测",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "为每种处理价值提供效果、参考范围、症状、相关领域和现场支持。",
                    label = "外地文件",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "搜索和过滤标志名称、效果、位位位置和十六进制面具。",
                    label = "国旗搜索",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "搜索、检查、推广和恢复模式和牌照处理规则。",
                    label = "车队管理员",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "显示每个字段的车辆基地、安装的自定义调试、示范规则、车牌规则和当前编辑草稿。",
                    label = "图层检查员",
                },
                handlingEditorMaxFleetResults = {
                    description = "舰队主管已装载了最大型号和车牌规则。",
                    label = "车队结果限制",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "每个剖面图保留的最大修改次数 。",
                    label = "简介修订",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "每个管理员保留最大命名工作空间 。",
                    label = "个人工作空间",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "每当共享配置得到更新或恢复时, 创建可审计的修订 。",
                    label = "配置配置版本",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "根据经测量的道路测试数据提出透明的、基于规则的建议。",
                    label = "遥测教练",
                },
                handlingEditorValidatorEnabled = {
                    description = "在采用处理前先检测不安全或相互矛盾的组合。",
                    label = "处理验证器",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "允许管理员保存命名的私人编辑草稿 。",
                    label = "个人工作空间",
                },
                instantTuningAllowedJobs = {
                    description = "可选的全局允许列表。留空以允许所有人，除非启用了仅限机械师。",
                    itemLabel = "职业名称",
                    label = "允许的工作",
                },
                instantTuningBlipColor = {
                    description = "GTA blip 颜色id.",
                    label = "闪点颜色",
                },
                instantTuningBlipEnabled = {
                    description = "显示即时调试位置的映射 。",
                    label = "已启用循环",
                },
                instantTuningBlipName = {
                    description = "地图页名 。",
                    label = "剪贴名称",
                },
                instantTuningBlipSprite = {
                    description = "GTA blip 符号 ID 。",
                    label = "光点精灵",
                },
                instantTuningForceMarkerInteraction = {
                    description = "即使在目标支持启用时也使用标记式 E 互动 。",
                    label = "力标记交互",
                },
                instantTuningInteractionDistance = {
                    description = "使用即时调试点的默认距离 。",
                    label = "交互距离",
                },
                instantTuningLabel = {
                    description = "在即时调试点显示默认文本 。",
                    label = "默认标签",
                },
                instantTuningLocations = {
                    description = "即时调整点。 使用0 距离来继承默认交互距离 。",
                    itemLabel = "位置",
                    label = "位置",
                },
                instantTuningMarkerEnabled = {
                    description = "在即时调时位置绘制世界标记 。",
                    label = "已启用标记",
                },
                instantTuningMarkerType = {
                    description = "用于即时调频地点的GTA标记类型。",
                    label = "标记类型",
                },
                instantTuningMechanicOnly = {
                    description = "将所有即时调频地点限制在配置的机械工专业。",
                    label = "仅机械",
                },
                instantTuningPriceMultiplier = {
                    description = "乘数应用于即时调整价格。",
                    label = "价格倍率",
                },
                instantTuningProfile = {
                    description = "在即时调试点可使用调试选项的配置 。",
                    label = "即时调试选项",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "最短几分钟前 同一辆车 能够触发另一个维修提醒。",
                    label = "通知冷却",
                },
                maintenanceNotificationsEnabled = {
                    description = "当一个磨损部件达到维护门槛时,通知车主。",
                    label = "启用",
                },
                maintenanceNotificationsThreshold = {
                    description = "以认为应予维修或低于应维修的百分比为单位。",
                    label = "到期门槛值",
                },
                mileageHudDigits = {
                    description = "里程HUD中显示的数字数。",
                    label = "位数",
                },
                mileageHudPosition = {
                    description = "将里程HUD预览拖到所需的屏幕位置。",
                    label = "位置",
                },
                oilLeaksCooldownSeconds = {
                    description = "再过几秒钟 撞击泄漏就会触发",
                    label = "冲击冷降",
                },
                oilLeaksEnabled = {
                    description = "允许损坏的燃烧车在驾驶时留下液体。",
                    label = "激活液体泄漏",
                },
                oilLeaksEngineOilChance = {
                    description = "正常漏泄机会 0 至 1. .",
                    label = "发动机机油机机机机",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "关键漏漏机会 0 至 1. .",
                    label = "关键机油机机机机机会",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "发动机机油状况在或低于使用关键机率时或低于该条件。",
                    label = "关键发动机机油门槛值",
                },
                oilLeaksEngineOilThreshold = {
                    description = "引擎机油状况 开始泄漏时或下方",
                    label = "引擎机油门槛值",
                },
                oilLeaksForwardMotionRatio = {
                    description = "所需前向变动比率 0 至 1. .",
                    label = "前进运动比率",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "允许严重的前方撞击引发临时引擎液体泄漏。",
                    label = "正面撞击泄漏",
                },
                oilLeaksImpactChance = {
                    description = "可能来自 0 至 1 限定撞击开始泄漏",
                    label = "影响漏漏机会",
                },
                oilLeaksImpactRadius = {
                    description = "撞击产生的初始流体点半径。",
                    label = "撞击溢溢半径",
                },
                oilLeaksIntervalSeconds = {
                    description = "足迹点之间的最低秒数",
                    label = "轨轨迹间隔",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "第二次泄漏 继续 后,合格影响。",
                    label = "影响泄漏期",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "影响期间损失的最低身体健康水平。",
                    label = "最小身体损害",
                },
                oilLeaksMinDistance = {
                    description = "足迹点之间的最低行走距离。",
                    label = "轨迹距离",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "在撞击中损失了最低引擎健康。",
                    label = "最小发动机损坏",
                },
                oilLeaksMinFrontDeformation = {
                    description = "需要的前部变形。 使用 0 禁用此项检查。",
                    label = "最小前端变形",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "最小影响前速度(公里/小时)",
                    label = "最小撞击速度",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "撞击期间按公里/小时计算的所需速度损失。",
                    label = "最低速度损失",
                },
                oilLeaksMinSpeedKmh = {
                    description = "车辆最低速度以公里/小时为单位,然后液体泄漏才能产生痕迹。",
                    label = "最低速度",
                },
                oilLeaksRadius = {
                    description = "正常车辆液体跟踪点的半径。",
                    label = "轨迹半径",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "正常漏泄机会 0 至 1. .",
                    label = "传送流动机会",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "关键漏漏机会 0 至 1. .",
                    label = "关键传输机率",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "在关键机会使用时或低于该临界机会的传输流体条件。",
                    label = "关键传输阈值",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "传输流体状况,在或低于该条件时,泄漏可开始发生。",
                    label = "输流流体输液阈值",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "车辆班无需车间电梯即可完成从上而下的工作。",
                    itemLabel = "加上车辆类",
                    label = "电梯绕越车辆班",
                    options = {
                        ["0"] = "契约契约",
                        ["1"] = "塞达人",
                        ["10"] = "工业级",
                        ["11"] = "公用设施",
                        ["12"] = "面包车",
                        ["13"] = "周期",
                        ["14"] = "船船",
                        ["15"] = "直升机 直升机",
                        ["16"] = "计划计划",
                        ["17"] = "服务",
                        ["18"] = "紧急情况",
                        ["19"] = "军事",
                        ["2"] = "越越越越",
                        ["20"] = "商业商业",
                        ["21"] = "列火车",
                        ["22"] = "开放轮",
                        ["3"] = "结结结",
                        ["4"] = "肌肉",
                        ["5"] = "体育经典",
                        ["6"] = "体育 体育体育 体育 运动",
                        ["7"] = "超级",
                        ["8"] = "摩托车",
                        ["9"] = "越野",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "车辆产卵模型可以在没有车间电梯的情况下完成依赖升降的订单工作。",
                    itemLabel = "车辆型号",
                    label = "电梯绕越车型",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "用于订单安装不运行小型游戏的阶梯的 Milliconos 。",
                    label = "简单安装持续时间",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "车辆类身份证总是使用正常的机械安装,没有专用电梯或小型游乐场。",
                    label = "非微型游戏车类",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "车辆产卵模型总是使用正常的机械设备安装,没有专用电梯或小型游戏流程。",
                    label = "非微型游戏型车型",
                },
                partsDeliveryCompanyCard = {
                    description = "允许分批交货订单使用公司资金。",
                    label = "公司贺卡付款",
                },
                partsDeliveryMode = {
                    description = "保持标准实际交付流程或将全部交付直接添加到采集播放器的库存中。",
                    label = "交付处理",
                    options = {
                        player_inventory = "玩家库存",
                        standard = "标准交付流量",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "拆卸快件需要的米秒。",
                    label = "开放期限",
                },
                partsDeliveryOwnCard = {
                    description = "允许玩家用他们自己的钱 支付零件交付订单",
                    label = "自行支付信用卡",
                },
                partsDeliveryTimeSeconds = {
                    description = "订货零件和交货准备之间的秒数",
                    label = "交付时间",
                },
                partsTheftCatalyticConverterItem = {
                    description = "当催化转换器被盗时,就授予库存项目。",
                    label = "催化转换器项目",
                },
                partsTheftDealerAccount = {
                    description = "用于被窃零件交易商付款的账户,如货币或银行。",
                    label = "交易人付款账户",
                },
                partsTheftDealerItems = {
                    description = "交易商将购买的被盗物品及其付款价值。",
                    itemLabel = "发牌器项目",
                    label = "发牌器项目",
                },
                partsTheftDealerPayoutItem = {
                    description = "当经销商付款类型是物品时给定存货项。销售价格作为物品数额使用。",
                    label = "交易商付款项目",
                },
                partsTheftDealerPayoutType = {
                    description = "选择交易商是向框架账户支付还是给一个盘点项目。",
                    label = "交易商付款类型",
                    options = {
                        account = "帐户",
                        item = "物品",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "与经销商的最大距离 出售被盗零件。",
                    label = "发牌商卖远路",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "再过几秒 同一车辆零件 就能制造另一个调度了",
                    label = "调度冷却",
                },
                partsTheftDispatchEnabled = {
                    description = "当车轮或催化转换器被盗时,建立警察调度系统。",
                    label = "派遣警察",
                },
                partsTheftDispatchJobs = {
                    description = "收到零件盗窃邮件的专业名称。",
                    itemLabel = "职业名称",
                    label = "调度职位",
                },
                partsTheftDispatchMessage = {
                    description = "发送提示时显示消息。 支持 {plate},, {part}, 和 {type}. .",
                    label = "发送信息",
                },
                partsTheftDispatchTitle = {
                    description = "调度提示时显示的标题。 支持 {plate},, {part}, 和 {type}. .",
                    label = "发件人标题",
                },
                partsTheftItem = {
                    description = "用于偷盗车轮和催化转换器的库存物品。",
                    label = "ft 工具项",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "成功采取盗窃行动后删除盗窃工具项。",
                    label = "合并盗窃工具",
                },
                partsTheftStolenWheelItem = {
                    description = "当轮轮被偷时,就给予库存项目。",
                    label = "被盗轮式物品",
                },
                priceType = {
                    description = "百分比根据车辆价格计算成本; 固定用途货币价值; 车辆类别使用类别定价表。",
                    label = "价格类型",
                    options = {
                        class = "车辆类",
                        fixed = "固定",
                        percentage = "百分比百分比百分比百分比",
                    },
                },
                primaryColor = {
                    description = "机械工职业组和新职业组的默认颜色。 使用 six 值, 如 # EDC001 。",
                    label = "原色",
                },
                publicUsersSeePrices = {
                    description = "启用时, 公共客户在订购时支付费用 。 禁用此选项以创建未支付的机械计费订单 。",
                    label = "收取公共自助服务订单",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "允许获得授权的老板使用公司资金为其整个职业购买订阅费。",
                    label = "公司订阅",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "支付货币",
                },
                subscriptionsEnabled = {
                    description = "启动讲习班订阅、客户终端和订阅折扣。",
                    label = "启用",
                },
                subscriptionsMaximumDurations = {
                    description = "每个订阅模式的最大期限和价格选择。",
                    label = "最长期限",
                },
                subscriptionsMaximumModels = {
                    description = "讲习班可在平板板上配置的最大订阅模式。",
                    label = "最大模型",
                },
                subscriptionsNpcEmoteClip = {
                    description = "假设情景为空时使用的可选循环动画剪辑 。",
                    label = "NPC 薄片",
                },
                subscriptionsNpcEmoteDict = {
                    description = "假设情景为空时使用的可选动画字典 。",
                    label = "NPC mote 词典",
                },
                subscriptionsNpcPedModel = {
                    description = "例如,在订阅终端(s_m_m_autoshop_01)生成的Ped型号。",
                    label = "默认NPC模型",
                },
                subscriptionsNpcScenario = {
                    description = "任择 GTA World_HUMAN_CLIPBOARD 等假设情景。 留空以使用 mote 动画 。",
                    label = "NPC 假设情景",
                },
                tuningBlockedPlates = {
                    description = "带有这些牌照之一的车辆无法调制、安装或调换。 匹配的忽略外壳和白色空间 。",
                    itemLabel = "车牌",
                    label = "封隔的调音盘",
                },
                tuningWorkshopDistance = {
                    description = "所需安装或清除行动与自用调试点之间的最大距离。",
                    label = "讲习班要求距离",
                },
                tuningWorkshopRequireForInstall = {
                    description = "要求调试订单装置在自助调试点附近启动和完成。",
                    label = "安装需要的车间",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "要求调整清除量,以启动和完成接近自用调试点的工作。",
                    label = "清除要求讲习班",
                },
                vehicleCareRepairDurationMs = {
                    description = "修复进度持续时间(毫秒)",
                    label = "维修期限",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "在使用修复行动时,还重置现实的轮子损坏。",
                    label = "修复现实的轮车损坏",
                },
                vehicleCareRepairItem = {
                    description = "车辆修理行动使用的库存物品。",
                    label = "维修物品",
                },
                vehicleCareRepairMaxDistance = {
                    description = "修理时距离车辆的最大距离。",
                    label = "最大修理距离",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "使用后删除修理项目。",
                    label = "组装修理物品",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "正常修理 GTA 使用修理行动时损坏车辆。",
                    label = "固定车辆损坏",
                },
                vehicleCareRepairWearParts = {
                    description = "选择修理项目要恢复的磨损和保养部件。 如果油、冷却剂、制动油或传输液需要诊断性修复流程, 此处禁用液体 。",
                    itemLabel = "部分服装",
                    label = "修理包修复部件",
                },
                vehicleCareWashItem = {
                    description = "洗车用的库存物品",
                    label = "洗涤物品",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "使用后删除洗涤项。",
                    label = "组装洗涤物品",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "蜡光车辆保持距离干净。",
                    label = "瓦克斯清洁公里",
                },
                vehicleCareWaxItem = {
                    description = "用来给车辆打蜡的库存物品。",
                    label = "轴轴物品",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "使用后删除蜡项。",
                    label = "组装蜡项",
                },
                vehicleClassPricing = {
                    description = "重覆每种价格类型和成本乘数 GTA 车辆类。",
                    label = "车辆级定价",
                },
                wearParts = {
                    description = "车辆佩戴部件、其使用寿命距离、所需修理物品、物品消耗和安装流程。",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "催化转换器",
                                fluid_refill = "流流再充填",
                                hood_install = "Hood 安装安装",
                                oil_change = "石油变化",
                                performance = "性能",
                                underbody_neon = "下体/升升",
                                wheel = "轮轮轮",
                            },
                        },
                    },
                    itemLabel = "部分服装",
                    label = "服装零部件",
                },
                wheelDamageDefaultMultiplier = {
                    description = "底轮损坏乘数。",
                    label = "默认默认乘数",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "过滤器变形探测点不指向车辆身体。",
                    label = "勘探角阈值",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "每次恢复迭代都增加了额外的力。",
                    label = "变形损坏增加数",
                },
                wheelDamageDeformationEnabled = {
                    description = "在轮胎修复期间进行几何重建时,截取并恢复体积。",
                    label = "恢复变形",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "恢复缩进时使用起始力 。",
                    label = "初始变形损坏",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "用于重建缩进的 最大 SetViclucDamage 通行证 。",
                    label = "变形迭代",
                },
                wheelDamageDeformationThreshold = {
                    description = "要存储的最小检测到的变形大小 。",
                    label = "变形阈值",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "当车辆有越野轮时使用的乘数。",
                    label = "越野轮乘数",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "轮子几何学重建后,非轮子超速损坏恢复通过。",
                    label = "损坏重新使用通行证",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "轮子修理后,轮胎的漏气或充气轮胎的超速传票。",
                    label = "轮状重新申请通行证",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "当轮胎修理重建轮式几何结构时,保持身体、发动机、窗户、门、门、土和视觉损坏。",
                    label = "保全车辆损坏",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "尽可能恢复破碎的窗户,不产生响亮的撞击效果。",
                    label = "静静破碎的窗户",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "在不引发新轮胎爆破声或效应的情况下,重新使用轮胎的轮胎。",
                    label = "重新使用无声平板轮胎",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "挂载动作与损坏或丢失轮胎的最大距离。",
                    label = "轮胎附加距离",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "移动动作的最大距离离已放置的车牌插件 。",
                    label = "车牌车去掉距离",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "损失乘数每 GTA 车辆类。",
                    itemLabel = "车辆类",
                    label = "车辆级乘数乘数",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "有技工值班时禁止其他职业维修",
                },
                allowsprint = {
                    label = "允许携带送货箱时冲刺",
                },
            },
            tuningCategories = {
                bodywork = "车身",
                electronics = "ECU 与车辆电子系统",
                engineSounds = "引擎声浪",
                handling = "操控",
                lights = "灯光",
                other = "其他",
                paint = "喷漆",
                performance = "性能",
                stance = "车身姿态",
                wheels = "车轮",
            },
            advancedPricingPreview = {
                compact = "丰田/契约",
                customer = "客户价格",
                description = "使用当前规则的示例计算。",
                labor = "劳工",
                live = "实时预览",
                margin = "保证金",
                sports = "运动车",
                super = "超车",
                supplier = "供应商",
                title = "价格预览",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "配置机械工职业、商店、车辆和车间地点。",
                    title = "机械职业",
                },
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
            fields = {
                quantity = "数量",
            },
            settingFieldDescriptions = {
                radialEnabled = "从无线电菜单上打开机修帐单",
                allowTuningInvoices = "将调试篮寄给最近的客户。安装在全额付款后打开锁。",
                customerRange = "向附近客户开具发票的最大距离(米)。",
                allowAnalytics = "允许计费分析,除非等级规则压倒它。",
                allowCustomPrices = "允许机械师在开具发票时编辑发票物价。",
                allowEstimates = "允许客户在付款前必须接受的估计数。",
                allowImmediatePayment = "允许直接支付该职业的发票。",
                allowManualItems = "允许机械师任意制造发票状况。",
                allowPartialPayments = "允许向一张发票存款和多次付款。",
                analyticsPeriodDays = "计费分析中包含的天数 。",
                defaultDueDays = "直至发票过期。",
                depositPercent = "在开具发票或接受估计数后,按规定交存百分比。",
                enabled = "允许该职业使用机械计费。",
                estimateLifetimeHours = "未答复的估计数到期前数小时。",
                gradeRules = "每个技工职等都有发票限额和行动。",
                maxDiscountPercent = "发票可能得到最大的折扣。",
                maximumInvoiceAmount = "职等限额之前全球最高总数。",
                maximumManualItems = "每个文件的最大任意位置。",
                maximumReminders = "允许每张发票发出最大提醒通知。",
                minimumInvoiceAmount = "估计数和发票最低总数。",
                minimumPartialPayment = "小额部分付款,不包括较小的剩余余额或存款。",
                reminderFee = "每一份有效的催复通知都加上费用。",
                reminderGraceDays = "第一次催复之前已逾期的天数。",
                taxPercent = "减价后加税。",
            },
            settingFields = {
                radialEnabled = "发票辐射动作",
                allowTuningInvoices = "发票调节客户",
                customerRange = "客户距离",
                allowAnalytics = "会计分析",
                allowCancellation = "注销",
                allowCustomPrices = "允许自订价格",
                allowEstimates = "允许估计数",
                allowImmediatePayment = "允许立即支付",
                allowManualItems = "允许自己的职位",
                allowPartialPayments = "允许部分支付",
                allowReminders = "提醒提醒",
                amount = "数量",
                analyticsPeriodDays = "分析周期",
                bone = "骨",
                category = "类别",
                classId = "班级 ID",
                defaultDueDays = "付款期(日)",
                depositPercent = "存款百分比",
                difficulty = "难度",
                enabled = "已启用",
                estimateLifetimeHours = "估计寿命(小时)",
                flow = "安装流程",
                grade = "等级",
                gradeRules = "职等规则",
                item = "物品",
                key = "键",
                kilometersToZero = "至零的公里数",
                label = "标签",
                laborFee = "劳动力成本成本",
                laborMultiplier = "劳动乘数乘数",
                marginAdjustmentPercent = "边值调整",
                marginPercent = "边差%",
                maxDiscountPercent = "最高折扣",
                maximumInvoiceAmount = "最高发票发票",
                maximumManualItems = "最大自职位数",
                maximumPrice = "最大值",
                maximumReminders = "最大提醒提醒提醒",
                minimumInvoiceAmount = "最低发票",
                minimumPartialPayment = "最低部分支付额",
                minimumPrice = "最小值",
                multiplier = "乘数器",
                name = "商品名称",
                partKey = "密钥部分",
                price = "价格",
                priceType = "价格类型",
                prop = "支柱",
                reason = "事由",
                reminderFee = "提醒费用",
                reminderGraceDays = "提醒宽限期",
                removeAfterUse = "消耗物品",
                repair = "使用包件修理",
                repairItem = "维修物品",
                rx = "旋转X",
                ry = "罗约Y",
                rz = "旋转 Z",
                supplierSharePercent = "供应商%",
                taxPercent = "发票税",
                transport = "运输",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "升级",
                maximumDiscountPercent = "最大折扣",
            },
            settingValues = {
                air_filter = "空气过滤器",
                brake_fluid = "刹力流",
                brake_pads = "刹制帕",
                catalytic_converter = "催化转换器",
                clutch = "克隆",
                coolant = "冷却剂",
                engine_oil = "发动机机油",
                inverter = "电源反转器",
                spark_plugs = "火花插件",
                suspension = "暂停适用",
                traction_battery = "D. 电 电 台",
                transmission_fluid = "流流传输",
                tyres = "轮胎",
                vehicleClass_0 = "契约契约",
                vehicleClass_1 = "塞达人",
                vehicleClass_10 = "工业级",
                vehicleClass_11 = "公用设施",
                vehicleClass_12 = "面包车",
                vehicleClass_13 = "周期",
                vehicleClass_14 = "船船",
                vehicleClass_15 = "直升机 直升机",
                vehicleClass_16 = "计划计划",
                vehicleClass_17 = "服务",
                vehicleClass_18 = "紧急情况",
                vehicleClass_19 = "军事",
                vehicleClass_2 = "越越越越",
                vehicleClass_20 = "商业商业",
                vehicleClass_21 = "列火车",
                vehicleClass_22 = "开放轮",
                vehicleClass_3 = "结结结",
                vehicleClass_4 = "肌肉",
                vehicleClass_5 = "体育经典",
                vehicleClass_6 = "体育 体育体育 体育 运动",
                vehicleClass_7 = "超级",
                vehicleClass_8 = "摩托车",
                vehicleClass_9 = "越野",
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
            tuningOptions = {
                antilag_enabled = {
                    label = "抗滞后",
                    values = {
                        [0] = "已禁用",
                        [1] = "GTA 标准标准标准",
                        [2] = "街头流行",
                        [3] = "反种族、反民族",
                        [4] = "拉里反同性恋组织",
                    },
                },
                electronic_automatic_hazards = {
                    label = "自动危险",
                    values = {
                        [0] = "关",
                        [1] = "开",
                    },
                },
                electronic_brake_lights = {
                    label = "制动灯光",
                    values = {
                        [0] = "普通",
                        [1] = "紧急闪电",
                        [2] = "关",
                    },
                },
                electronic_engine_tune = {
                    label = "引擎软件",
                    values = {
                        [0] = "库存",
                        [1] = "阶段 1",
                        [2] = "阶段 2",
                        [3] = "阶段 3",
                        [4] = "阶段 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "头灯亮度",
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
                    label = "非洲之角高光束",
                    values = {
                        [0] = "关",
                        [1] = "开",
                    },
                },
                electronic_idle_rpm = {
                    label = "空空闲 RPM",
                    values = {
                        [0] = "库存",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "内地浅",
                    values = {
                        [0] = "普通",
                        [1] = "红色",
                    },
                },
                electronic_mood_color = {
                    label = "摩德浅色",
                    values = {
                        [0] = "关",
                        [1] = "红色",
                        [10] = "石灰",
                        [11] = "青色",
                        [12] = "印地哥",
                        [13] = "白白",
                        [14] = "温暖的白",
                        [15] = "寒冷白",
                        [16] = "琥珀",
                        [2] = "蓝色",
                        [3] = "绿色",
                        [4] = "青色",
                        [5] = "品红",
                        [6] = "黄色",
                        [7] = "橙色",
                        [8] = "紫色",
                        [9] = "粉色",
                    },
                },
                electronic_mood_intensity = {
                    label = "摩德光亮强度",
                    values = {
                        [0] = "迪 丁",
                        [1] = "普通",
                        [2] = "亮亮",
                    },
                },
                electronic_radio_power = {
                    label = "无线电无线电台",
                    values = {
                        [0] = "关",
                        [1] = "开",
                    },
                },
                electronic_throttle_response = {
                    label = "压缩反应",
                    values = {
                        [0] = "更多的电车公司",
                        [1] = "激进",
                    },
                },
                electronic_wheelie_tune = {
                    label = "轮轮轮音",
                    values = {
                        [0] = "关",
                        [1] = "软软",
                        [2] = "强烈",
                    },
                },
            },
            vehicleClassLabel = "班级 {id} ( ( ) ({name})",
        },
    },
}
