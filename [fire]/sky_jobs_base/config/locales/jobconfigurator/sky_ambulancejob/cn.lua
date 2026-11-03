JobConfigLocales["sky_ambulancejob:cn"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "医疗评估",
                sharedMedicalEvaluations = "共享医疗评估",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "允许重生",
                        description = "控制该病床是否可作为玩家重生点。",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "配置救护车工作、病床、死亡系统、交互和核心功能设置。",
                    title = "救护车工作",
                },
            },
            dispatchActions = {
                currentLocation = "使用当前位置",
                addChannel = "添加无线电频道",
                addKeyword = "添加关键词",
                addPoi = "添加地点",
                addReporter = "添加报警人",
                addStatus = "添加 FMS 状态",
                addVehicle = "添加虚拟单位",
                addVehicleType = "添加单位类型",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "为此响应计划选定的各单位的最低人员数量。",
                noUnitFallback = "在没有中心或人员单位的情况下，向所有值班成员发送 Sky 通知。",
                radius = "可以听到电台广播的最大距离（以米为单位）。",
                requirements = "响应需求为 TYPE:COUNT 对，例如 PATROL:2,CRIME:1。",
                statusCode = "手持无线电上显示数字 FMS 状态。",
                statusLabel = "此 FMS 状态对于调度员和单位的含义。",
                vehicleType = "必须与上一小节中配置的车辆类型代码匹配。",
                vehicleTypeCode = "响应要求中使用的短单位代码，例如 PATROL、CRIME、EMS 或 RESCUE。",
                vehicleTypeLabel = "该单位类别的可读名称。",
                crewCapacity = "可加入此单位的最大人员数；填 0 表示不限制。",
                joinLocked = "单位有人值守后，禁止其他人员继续加入。",
                poiId = "稳定技术标识；地点重命名后，中心配置仍可引用它。",
                readyStatusCode = "资源进入可调度状态时应用的 FMS 状态。",
                resourceType = "为调度筛选和协同标记此作战资源的类别。",
                respondingStatusCode = "资源响应警情时应用的 FMS 状态。",
                shortLabel = "显示在六个无线电频道存储键上的可选短标签。",
                stationId = "将此单位关联到调度中心配置中的站点。",
                unitId = "即使无线电呼号改变，也用于保留该单位的稳定技术标识。",
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
                defaultChannel = "默认广播频道",
                emergencyAppEnabled = "在紧急应用程序中显示",
                enabled = "启用调度",
                icon = "图标",
                incidentAssessmentEnabled = "启用紧急评估",
                jobs = "目标职位（逗号分隔）",
                keywordCode = "关键字代码",
                label = "标签",
                minimumCrew = "最低船员人数",
                name = "姓名",
                noUnitFallback = "通知无单位值班人员",
                noneChannel = "无/组默认",
                note = "注意",
                phone = "电话",
                radius = "公告半径",
                requirements = "所需单位（例如巡逻：2，犯罪：1）",
                type = "类型",
                vehicleType = "响应单元类型",
                crewCapacity = "乘员容量",
                joinLocked = "锁定乘员加入",
                poiId = "稳定 POI ID",
                readyStatusCode = "就绪状态代码",
                resourceType = "资源类型",
                respondingStatusCode = "出动状态代码",
                shortLabel = "电台存储标签",
                stationId = "站点 ID",
                unitId = "稳定单位 ID",
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
                    statuses = "可用的 FMS",
                    units = "虚拟单位",
                    reporters = "已知报警人",
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
                dispatchStatusCodes = "配置 FMS 状态标签以及哪些状态算作可用于新事件。",
                dispatchVehicleTypes = "定义响应计划使用的单位类别，例如巡逻、犯罪单位、EMS 或救援。",
                dispatchVehicles = "定义虚拟调度车辆，可以在任何地方配备人员，而不需要生成车辆。",
                dispatchReporters = "管理该职业的报警人姓名、回拨号码和调度备注。",
            },
            extensions = {
                invalidSelection = "无效选项：{value}",
                trainingSettings = {
                    description = "为此作业配置培训访问、注册、批准和课程规划。",
                    label = "训练设置",
                },
                dispatchReporters = "已知报警人",
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
            },
            features = {
                bleeding = {
                    description = "启用出血系统。",
                    label = "出血",
                },
                bodybags = {
                    description = "启用裹尸袋和裹尸袋运送流程。",
                    label = "裹尸袋",
                },
                consciousScenarioBloodPressure = {
                    description = "在患者意识清醒时进行血压检查。",
                    label = "清醒血压",
                },
                deathTimeout = {
                    description = "启用死亡超时流程。",
                    label = "死亡超时",
                },
                fractures = {
                    description = "实现骨折处理和治疗。",
                    label = "骨折",
                },
                knockout = {
                    description = "启用淘汰赛系统。",
                    label = "昏死",
                },
                legShotRagdoll = {
                    description = "命中配置的腿部或脚部区域时使玩家倒地。",
                    label = "腿部中弹倒地",
                },
                pain = {
                    description = "启用疼痛系统。",
                    label = "疼痛",
                },
                respawnInBed = {
                    description = "当可用时，让复活后的玩家在医院病床上重生。",
                    label = "在床上重生",
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
                resetPendingSave = "设置已重置。请保存以应用更改。",
            },
            settingFields = {
                gang = "帮派",
                allowInVehicle = "允许在车内使用",
                allowMovement = "允许移动",
                animDict = "动画字典",
                animFlag = "动画标志",
                animName = "动画名称",
                bleeding = "出血",
                cause = "原因",
                chance = "概率",
                class = "类别",
                companyPrice = "公司价格",
                companyPricePerEmployee = "每名员工价格",
                copayPercent = "共付额%",
                description = "描述",
                dictionary = "动画词典",
                duration = "持续时间",
                durationMs = "持续时间（毫秒）",
                effect = "效果",
                effectDurationMs = "效果持续时间（毫秒）",
                effectDurationSeconds = "效果持续时间（秒）",
                enabled = "已启用",
                extractionType = "取出类型",
                foreignObject = "异物",
                heal = "治疗",
                id = "ID",
                itemName = "商品名称",
                key = "键",
                label = "标签",
                lang = "语言",
                limit = "限制",
                lossPerSecond = "每秒损失",
                max = "最大值",
                min = "最小值",
                minGrade = "最低等级",
                minigame = "小游戏",
                model = "道具模型",
                name = "职位名称",
                options = "选项(选择类型)",
                pain = "疼痛",
                pauseBleedingSeconds = "暂停出血（秒）",
                price = "价格",
                progressbarAllowInVehicle = "进度期间允许在车内",
                progressbarAllowMovement = "进度期间允许移动",
                progressbarCanCancel = "允许取消进度",
                progressbarDisableCarMovement = "进度期间禁用车辆移动",
                progressbarDisableCombat = "进度期间禁用战斗",
                progressbarDisableMouse = "进度期间禁用鼠标",
                progressbarDisableMovement = "进度期间禁用移动",
                progressbarDisableSprint = "进度期间禁用冲刺",
                progressbarDuration = "进度持续时间",
                progressbarEnabled = "启用进度条",
                progressbarLabel = "进度条文本",
                progressbarUseWhileDead = "死亡时允许使用进度",
                questions = "问 提问 问 问 问题",
                requireItems = "需要物品",
                required = "必需",
                requiresExtraction = "需要取出异物",
                requiresOpenWound = "需要开放性伤口",
                sort = "顺序",
                state = "状态",
                stopBleeding = "止血",
                threshold = "阈值",
                time = "时间",
                type = "类型",
                useAnimation = "使用动画",
                value = "值",
                zone = "区域",
                zones = "区域",
                systolic = "收缩压",
                diastolic = "舒张压",
                cardiacArrest = "心脏骤停",
            },
            settingGroups = {
                billingGeneral = {
                    label = "一般的",
                },
                billingRange = {
                    label = "范围",
                },
                billingReasons = {
                    label = "原因预设",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "动画片",
                },
                bodyBagAttachGeneral = {
                    label = "附",
                },
                bodyBagAttachOffsets = {
                    label = "偏移量",
                },
                bodyBagAttachRotation = {
                    label = "旋转",
                },
                bodyBagDeliveryGeneral = {
                    label = "一般的",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "一般的",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "支付",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "一般的",
                },
                crutchAssign = {
                    label = "任务",
                },
                crutchDuration = {
                    label = "期间",
                },
                crutchGeneral = {
                    label = "一般的",
                },
                crutchItems = {
                    label = "物品",
                },
                crutchRestrictions = {
                    label = "限制",
                },
                damageHandlingBladeWeapons = {
                    label = "刀刃武器",
                },
                damageHandlingBleedingBlacklist = {
                    label = "出血黑名单",
                },
                damageHandlingBleedingClasses = {
                    label = "放血课程",
                },
                damageHandlingBloodSystem = {
                    label = "血液系统",
                },
                damageHandlingDeathInjuries = {
                    label = "死亡受伤",
                },
                damageHandlingInjuryEffects = {
                    label = "伤害影响",
                },
                damageHandlingInjuryThresholds = {
                    label = "伤害阈值",
                },
                damageHandlingLegShotRagdoll = {
                    label = "腿部中弹布娃娃效果",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "腿部中弹区域",
                },
                damageHandlingLiveDamageFractures = {
                    label = "活损伤骨折",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "区域机会",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "开放性伤口层数",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "伤口区域",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "活伤课程",
                },
                damageHandlingMedications = {
                    label = "药物",
                },
                damageHandlingPainClasses = {
                    label = "疼痛课程",
                },
                damageHandlingPainEffects = {
                    label = "疼痛效应",
                },
                damageHandlingStatusEffects = {
                    label = "状态效果",
                },
                damageHandlingVehicleDamage = {
                    label = "车辆损坏",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "损坏原因",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "受伤",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "车辆碰撞保护",
                },
                deathAnimal = {
                    label = "动物后备",
                },
                deathAnimalAnimation = {
                    label = "动物动画",
                },
                deathAnimation = {
                    label = "动画片",
                },
                deathGeneral = {
                    label = "一般的",
                },
                deathModels = {
                    label = "每个模型覆盖",
                },
                deathScreenAiMedic = {
                    label = "一般的",
                },
                deathScreenAiMedicAvailability = {
                    label = "可用性",
                },
                deathScreenAiMedicBehaviour = {
                    label = "行为",
                },
                deathScreenAiMedicForceRevive = {
                    label = "强制复活",
                },
                deathScreenAiMedicPayment = {
                    label = "支付",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "在床上恢复活力",
                },
                deathScreenAiMedicSpawn = {
                    label = "生成",
                },
                deathScreenAiMedicTiming = {
                    label = "定时",
                },
                deathScreenControls = {
                    label = "控制",
                },
                deathScreenDamageLogs = {
                    label = "伤害日志",
                },
                deathScreenDimensions = {
                    label = "方面",
                },
                deathScreenDispatch = {
                    label = "派遣",
                },
                deathScreenEarlyRespawn = {
                    label = "一般的",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "可用性",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "支付",
                },
                deathScreenGeneral = {
                    label = "一般的",
                },
                deathScreenHospitalSelection = {
                    label = "医院选择",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "选择相机",
                },
                deathScreenInformation = {
                    label = "一般的",
                },
                deathScreenIntegration = {
                    label = "集成",
                },
                deathScreenLogs = {
                    label = "死亡日志",
                },
                deathScreenMinigame = {
                    label = "小游戏",
                },
                deathScreenRespawn = {
                    label = "一般的",
                },
                deathScreenRespawnAccounts = {
                    label = "账户",
                },
                deathScreenRespawnFallback = {
                    label = "后备坐标",
                },
                deathScreenRespawnItems = {
                    label = "项目",
                },
                deathScreenRespawnWeapons = {
                    label = "武器",
                },
                deathScreenStyle = {
                    label = "死亡画面风格",
                },
                deathScreenVoice = {
                    label = "嗓音",
                },
                deathTimeoutGeneral = {
                    label = "一般的",
                },
                deathTimeoutWhitelist = {
                    label = "白名单职位",
                },
                diagnoseAnim = {
                    label = "动画片",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "完全治疗",
                },
                diagnoseGeneral = {
                    label = "一般的",
                },
                doctorNpcAvailability = {
                    label = "可用性",
                },
                doctorNpcGeneral = {
                    label = "一般的",
                },
                doctorNpcHealOther = {
                    label = "治愈他人",
                },
                doctorNpcHealSelf = {
                    label = "治愈自我",
                },
                doctorNpcRanges = {
                    description = "这些范围不控制玩家必须距离多近才能打开医生 NPC 互动。它们仅在医生菜单打开后适用。",
                    label = "范围",
                },
                doctorNpcRevive = {
                    label = "复活",
                },
                doctorNpcReviveInBed = {
                    label = "在床上恢复活力",
                },
                firstAidAnimation = {
                    label = "动画片",
                },
                firstAidGeneral = {
                    label = "一般的",
                },
                firstAidLicenseAdd = {
                    label = "许可证添加",
                },
                firstAidLicenseRemove = {
                    label = "许可证删除",
                },
                firstAidPosition = {
                    label = "位置",
                },
                healthInsuranceExpiration = {
                    label = "到期日",
                },
                healthInsuranceGeneral = {
                    label = "一般的",
                },
                healthInsurancePayment = {
                    label = "支付",
                },
                healthInsuranceProviders = {
                    label = "供应商",
                },
                hospitalBedsBedAnimation = {
                    label = "床动画",
                },
                hospitalBedsCreator = {
                    label = "创作者",
                },
                hospitalBedsDistances = {
                    label = "距离",
                },
                hospitalBedsGeneral = {
                    label = "一般的",
                },
                hospitalBedsGetupAnimation = {
                    label = "起床动画",
                },
                hospitalBedsModels = {
                    label = "型号",
                },
                hospitalBedsOffsets = {
                    label = "偏移量",
                },
                hospitalBlip = {
                    label = "医院突发事件",
                },
                imagingGeneral = {
                    label = "一般的",
                },
                imagingRanges = {
                    label = "范围",
                },
                keybinds = {
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                    label = "按键设置",
                },
                knockoutGeneral = {
                    label = "一般的",
                },
                knockoutWeapons = {
                    label = "武器",
                },
                medicCarryAttach = {
                    label = "附",
                },
                medicCarryAttachOffsets = {
                    label = "偏移量",
                },
                medicCarryAttachRotation = {
                    label = "旋转",
                },
                medicCarryCarrierAnimation = {
                    label = "航母动画",
                },
                medicCarryGeneral = {
                    label = "一般的",
                },
                medicCarryPassengerAnimation = {
                    label = "乘客动画",
                },
                medicCarryRestrictions = {
                    label = "限制",
                },
                medicRevivePersistence = {
                    label = "一般的",
                },
                medicalEvaluationRecipients = {
                    label = "受援职业",
                },
                medicalEvaluationSharing = {
                    label = "共享字段",
                },
                medicalEvaluationTypes = {
                    label = "评价类型",
                },
                medicalEvaluationsGeneral = {
                    label = "一般的",
                },
                medicalWearablesArmRestrictions = {
                    label = "手臂石膏限制",
                },
                medicalWearablesCasts = {
                    label = "石膏",
                },
                medicalWearablesDuration = {
                    label = "佩戴时长",
                },
                medicalWearablesGeneral = {
                    label = "常规",
                },
                medicalWearablesHeadBandage = {
                    label = "头部绷带",
                },
                medicalWearablesLegRestrictions = {
                    label = "腿部石膏限制",
                },
                medicalWearablesNeckBrace = {
                    label = "颈托",
                },
                medicalWearablesOxygenMask = {
                    label = "氧气面罩",
                },
                medicalWearablesPatientHud = {
                    label = "患者界面",
                },
                medicalWearablesRemoval = {
                    label = "移除",
                },
                medicalWearablesSplints = {
                    label = "夹板",
                },
                medicalWearablesTorsoBandage = {
                    label = "躯干绷带",
                },
                minigamesCprGeneral = {
                    label = "一般的",
                },
                minigamesEnabled = {
                    label = "启用",
                },
                minigamesVentilationGeneral = {
                    label = "一般的",
                },
                operationsAnesthesia = {
                    label = "麻醉",
                },
                operationsDistances = {
                    label = "距离",
                },
                operationsDoctorAnimation = {
                    label = "医生动画",
                },
                operationsGeneral = {
                    label = "常规",
                },
                operationsPatientAnimation = {
                    label = "患者动画",
                },
                operationsTrainingAnimation = {
                    label = "训练动画",
                },
                propPlacement = {
                    label = "道具放置",
                },
                propPlacementItems = {
                    label = "道具物品",
                },
                publicTreatmentGeneral = {
                    label = "一般的",
                },
                publicTreatmentJobs = {
                    label = "允许的工作",
                },
                publicTreatmentRequirements = {
                    label = "要求",
                },
                reviveRewardGeneral = {
                    label = "一般的",
                },
                reviveRewardPayment = {
                    label = "支付",
                },
                selfDiagnoseGeneral = {
                    label = "一般的",
                },
                stretcherAnimation = {
                    label = "动画片",
                },
                stretcherCarryAttach = {
                    label = "随身携带",
                },
                stretcherFolded = {
                    label = "折叠变体",
                },
                stretcherFoldedPatientAttach = {
                    label = "折叠式患者连接器",
                },
                stretcherGeneral = {
                    label = "一般的",
                },
                stretcherHelicopter = {
                    label = "直升机",
                },
                stretcherPatientAttach = {
                    label = "病人附着",
                },
                stretcherTreatmentAnim = {
                    label = "动画片",
                },
                stretcherVehicleAttach = {
                    label = "车辆附加",
                },
                stretcherVehicleLists = {
                    label = "车型",
                },
                treatmentAnim = {
                    label = "动画片",
                },
                treatmentEnable = {
                    label = "使能够",
                },
                trunk = {
                    label = "树干",
                },
                vehiclePullGeneral = {
                    label = "一般的",
                },
                wheelchairAssign = {
                    label = "任务",
                },
                wheelchairDuration = {
                    label = "期间",
                },
                wheelchairGeneral = {
                    label = "一般的",
                },
                wheelchairItems = {
                    label = "物品",
                },
                wheelchairRestrictions = {
                    label = "限制",
                },
                xrayGeneral = {
                    label = "一般的",
                },
                xrayRanges = {
                    label = "范围",
                },
                appointmentsGeneral = {
                    label = "一般的",
                },
                appointmentsLimits = {
                    label = "限制",
                },
                appointmentsNotifications = {
                    label = "通知",
                },
                appointmentsScheduling = {
                    label = "日程安排",
                },
                healthCompatibility = {
                    label = "健康兼容性",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "一般的",
                },
                minigamesRandomization = {
                    label = "随机化",
                },
            },
            settingSections = {
                billing = "计费",
                bodyBag = "裹尸袋",
                damageHandling = "损坏处理",
                death = "死亡",
                deathScreen = "死亡画面",
                diagnose = "诊断",
                doctorNpc = "医生 NPC",
                general = "一般的",
                healthInsurance = "健康保险",
                hospitalBeds = "医院病床",
                knockout = "昏死",
                medicCarry = "医疗携带",
                minigames = "小游戏",
                mobilityAid = "行动辅助工具",
                operations = "手术",
                organization = "组织",
                rewards = "奖励",
                treatment = "治疗",
                vehiclePull = "车辆拉力",
            },
            settingSubsections = {
                aiMedic = "人工智能医生",
                anesthesia = "麻醉",
                animation = "动画片",
                animations = "动画",
                attach = "附",
                bedAnimation = "床动画",
                blood = "血",
                bodyBagDeliveryReward = "裹尸袋运送奖励",
                carrierAnimation = "航母动画",
                classification = "分类",
                cpr = "心肺复苏",
                crutch = "拐杖",
                deathInjuries = "死亡受伤",
                deathScreenStyle = "死亡画面风格",
                deathTimeout = "死亡超时",
                delivery = "送货",
                diagnoseAnim = "诊断动画",
                dispatch = "派遣",
                earlyRespawn = "早期重生",
                effects = "效果",
                firstAid = "急救",
                general = "一般的",
                getupAnimation = "起床动画",
                imaging = "影像学",
                information = "信息",
                keybinds = "按键设置",
                liveDamage = "实时伤害",
                logs = "日志",
                medicRevivePersistence = "医生复活持久性",
                medicalEvaluations = "医疗评估",
                medicalWearables = "医疗辅助装备",
                medications = "药物",
                minigame = "小游戏",
                passengerAnimation = "乘客动画",
                pricing = "定价",
                propPlacement = "道具放置",
                publicTreatment = "公共待遇",
                respawn = "重生",
                reviveInBed = "在床上恢复活力",
                reviveReward = "复活奖励",
                selfDiagnose = "自诊断",
                stretcher = "担架",
                stretcherTreatmentAnim = "担架治疗动画",
                thresholds = "阈值",
                treatmentAnim = "治疗动画",
                trunk = "树干",
                vehicleImpact = "车辆碰撞",
                ventilation = "通风",
                wheelchair = "轮椅",
                xray = "X 光",
                appointments = "约会",
                bloodTransfusion = "输血",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "编辑器 · 控制 172",
                    description = "配置:编辑: 向上移动 。",
                },
                ambulanceEditorControl173 = {
                    label = "编辑器 · 控制 173",
                    description = "配置: 编辑器: 向下移动 。",
                },
                ambulanceEditorControl174 = {
                    label = "编辑器 · 控制 174",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl175 = {
                    label = "编辑器 · 控制 175",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl177 = {
                    label = "编辑器 · 控制 177",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl201 = {
                    label = "编辑器 · 控制 201",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl202 = {
                    label = "编辑器 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl21 = {
                    label = "编辑器 · 控制 21",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl32 = {
                    label = "编辑器 · 控制 32",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl33 = {
                    label = "编辑器 · 控制 33",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl34 = {
                    label = "编辑器 · 控制 34",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl35 = {
                    label = "编辑器 · 控制 35",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl36 = {
                    label = "编辑器 · 控制 36",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl37 = {
                    label = "编辑器 · 控制 37",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl38 = {
                    label = "编辑器 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceEditorControl44 = {
                    label = "编辑器 · 控制 44",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceFirstAidControl38 = {
                    label = "急救 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "交互 · 控制 177",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "交互 · 控制 201",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "交互 · 控制 202",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "交互 · 控制 21",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "交互 · 控制 241",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "交互 · 控制 242",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "交互 · 控制 25",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "交互 · 控制 32",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "交互 · 控制 33",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "交互 · 控制 34",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "交互 · 控制 35",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "交互 · 控制 36",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "交互 · 控制 38",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "交互 · 控制 44",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                billingAccount = {
                    description = "用于计费的旧后备社会帐户。",
                    label = "帐户",
                },
                billingCloseOnSuccess = {
                    description = "计费成功后自动关闭计费界面。",
                    label = "离成功很近了",
                },
                billingCurrency = {
                    description = "用于计费付款的可选货币键。",
                    label = "货币",
                },
                billingCustomBillingReasons = {
                    description = "允许医务人员输入自定义计费原因。",
                    label = "定制原因",
                },
                billingDepositToSociety = {
                    description = "将计费收入存入社会账户。",
                    label = "向社会存款",
                },
                billingEnabled = {
                    description = "启用医疗计费系统。",
                    label = "启用",
                },
                billingMaxReasonLength = {
                    description = "自定义计费原因的最大长度。",
                    label = "最大原因长度",
                },
                billingMode = {
                    description = "选择医疗账单是立即收费、需要确认还是使用框架计费系统。",
                    label = "计费方式",
                    options = {
                        consent = "付款或拒绝",
                        framework = "框架法案",
                        instant = "即时充电",
                    },
                },
                billingRange = {
                    description = "查找可计费患者的最大范围。",
                    label = "范围",
                },
                billingReasonPresets = {
                    description = "计费 UI 中显示的预设计费原因。",
                    itemLabel = "原因",
                    label = "原因预设",
                },
                billingRefreshSeconds = {
                    description = "可计费玩家刷新之间的秒数。",
                    label = "刷新秒数",
                },
                bladeWeapons = {
                    description = "武器名称或哈希值应归类为刀伤害而不是钝器伤害。",
                    itemLabel = "武器",
                    label = "刀刃武器",
                },
                bleedingBlacklist = {
                    description = "武器绝不能造成流血或开放性伤口。",
                    itemLabel = "武器",
                    label = "出血黑名单",
                },
                bleedingClassesProfiles = {
                    description = "出血严重程度及其失血率。",
                    label = "放血课程",
                },
                bloodSystemDebugLogInterval = {
                    description = "血液系统调试日志消息之间的秒数。",
                    label = "调试日志间隔",
                },
                bloodSystemMaxVolume = {
                    description = "患者状态系统使用的最大血容量值。",
                    label = "最大音量",
                },
                bloodSystemRegenPerSecond = {
                    description = "当患者不主动出血时应用被动血液再生。",
                    label = "每秒再生",
                },
                bloodSystemTickIntervalMs = {
                    description = "用于失血和恢复更新的服务器刻度间隔。",
                    label = "刻度间隔毫秒",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "血容量阈值，低于该阈值患者就会失去知觉。",
                    label = "无意识阈值",
                },
                bodyBagAnimationDict = {
                    description = "用于携带裹尸袋的动画词典。",
                    label = "动画词典",
                },
                bodyBagAnimationEnabled = {
                    description = "携带裹尸袋时使用专用的携带动画。",
                    label = "启用",
                },
                bodyBagAnimationFlag = {
                    description = "TaskPlayAnim 标志用于进行动画。",
                    label = "动画旗帜",
                },
                bodyBagAnimationName = {
                    description = "用于携带裹尸袋的动画剪辑。",
                    label = "动画名称",
                },
                bodyBagAttachBone = {
                    description = "用于尸体袋附件的 Ped 骨骼名称或骨骼 ID。",
                    label = "骨",
                },
                bodyBagAttachRx = {
                    description = "尸袋附 X 旋转。",
                    label = "连接接收端",
                },
                bodyBagAttachRy = {
                    description = "尸袋附Y旋转。",
                    label = "附上RY",
                },
                bodyBagAttachRz = {
                    description = "尸袋附有 Z 轴旋转。",
                    label = "连接RZ",
                },
                bodyBagAttachX = {
                    description = "尸袋连接 X 偏移。",
                    label = "附上X",
                },
                bodyBagAttachY = {
                    description = "尸袋附有 Y 偏移。",
                    label = "附上Y",
                },
                bodyBagAttachZ = {
                    description = "尸袋附有 Z 偏移。",
                    label = "连接Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "用于尸体袋投放帮助提示的区域设置键。",
                    label = "帮助标签键",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "用于尸体袋投放验证的距离。",
                    label = "互动距离",
                },
                bodyBagDeliveryInteractKey = {
                    description = "用于尸体袋投放交互的控制 ID。",
                    label = "互动键",
                },
                bodyBagDeliveryInteraction = {
                    description = "用于遗体袋投放的交互模板键。",
                    label = "交互模板",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "要求医务人员在配置的投放点移交裹尸袋。",
                    label = "需要下车",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "要求医务人员在运尸袋交付前值班。",
                    label = "需要值班",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "用于尸体袋递送奖励的主帐户密钥。",
                    label = "帐户",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "用于尸体袋递送奖励的主要帐户类型。",
                    label = "账户类型",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "运送尸袋所支付的奖励金额。",
                    label = "数量",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "可选的自定义货币钥匙用于尸体袋交付奖励。",
                    label = "货币",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "裹尸袋交付完成后支付配置的奖励。",
                    label = "启用",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "在支付医务人员费用之前，从共享工作协会中扣除裹尸袋运送奖励。",
                    label = "来自社会的付出",
                },
                bodyBagEnabled = {
                    description = "启用裹尸袋系统。",
                    label = "启用",
                },
                bodyBagHidePatient = {
                    description = "连接裹尸袋时，将患者隐藏起来。",
                    label = "隐藏病人",
                },
                bodyBagModel = {
                    description = "用于裹尸袋的道具模型。",
                    label = "模型",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha 在装尸袋时应用于患者。",
                    label = "阿尔法病人",
                },
                crutchAssignMaxDistance = {
                    description = "将拐杖分配给其他玩家的最大距离。",
                    label = "指定最大距离",
                },
                crutchAutoUnequipOnExpire = {
                    description = "任务到期时自动卸下拐杖。",
                    label = "到期时自动取消装备",
                },
                crutchClipset = {
                    description = "使用拐杖时应用的运动剪辑集。",
                    label = "剪辑集",
                },
                crutchDefaultDurationMinutes = {
                    description = "默认分配的拐杖持续时间（以分钟为单位）。",
                    label = "默认持续时间",
                },
                crutchDisableSprint = {
                    description = "配备拐杖时阻止冲刺。",
                    label = "禁用冲刺",
                },
                crutchDisableWeapons = {
                    description = "装备拐杖时阻止武器使用。",
                    label = "禁用武器",
                },
                crutchItemName = {
                    description = "用于拐杖的库存物品。",
                    label = "商品名称",
                },
                crutchMaxDurationMinutes = {
                    description = "允许拐杖分配的最长持续时间（以分钟为单位）。",
                    label = "最长持续时间",
                },
                crutchMinDurationMinutes = {
                    description = "允许的最短拐杖分配持续时间（以分钟为单位）。",
                    label = "最短持续时间",
                },
                crutchProp = {
                    description = "用于拐杖的道具模型。",
                    label = "支柱",
                },
                damageLogBatchIntervalSeconds = {
                    description = "将单次命中合并到一条 Discord 消息中的秒数。",
                    label = "批处理间隔",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "每条 Discord 消息包含的最大单次命中数。",
                    label = "每条消息命中数",
                },
                damageLogsEnabled = {
                    description = "将服务器确认的非致命玩家命中发送到 Discord。",
                    label = "伤害日志",
                },
                deathAnimalAnimationDictionary = {
                    description = "用于动物后备死亡动画的动画字典。",
                    label = "动物词典",
                },
                deathAnimalAnimationName = {
                    description = "用于动物备用死亡动画的动画剪辑。",
                    label = "动物动画名称",
                },
                deathAnimalUseAnimation = {
                    description = "允许配置的动物后备使用脚本化的死亡动画。",
                    label = "动物动画",
                },
                deathAnimationDictionary = {
                    description = "用于默认死亡动画的动画字典。",
                    label = "动画词典",
                },
                deathAnimationName = {
                    description = "用于默认死亡动画的动画剪辑。",
                    label = "动画名称",
                },
                deathInjuriesProfiles = {
                    description = "当球员因特定原因死亡时，将应用受伤情况。",
                    itemLabel = "受伤",
                    label = "死亡伤害",
                },
                deathModels = {
                    description = "覆盖每个 ped 模型或模型哈希的死亡动画行为。",
                    label = "模型覆盖",
                },
                deathScreenAiMedicAccount = {
                    description = "为 AI 医生收取的主要帐户费用。",
                    label = "帐户",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "当需要 AI 医生时，向出血计时器添加秒数。",
                    label = "添加死亡计时器",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "让人工智能医生能够挽救致命的伤口。",
                    label = "允许致命伤",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "人工智能医生步行停止和接近的距离。",
                    label = "接近距离",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "再次呼叫人工智能医生之前需要冷却。",
                    label = "冷却秒数",
                },
                deathScreenAiMedicCurrency = {
                    description = "用于人工智能医疗支付的可选货币密钥。",
                    label = "货币",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "用于人工智能医疗支付的货币格式化程序。",
                    label = "货币格式化程序",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "人工智能医生完成后消失前几秒。",
                    label = "消失延迟",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "AI 医疗派遣开始前的延迟。",
                    label = "发货延迟",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "人工智能医疗车使用的行驶速度。",
                    label = "行驶速度",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "强制恢复触发前的最大驱动时间。",
                    label = "驱动器超时",
                },
                deathScreenAiMedicEnabled = {
                    description = "启用 AI 医疗救援流程。",
                    label = "启用",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "当主要AI医疗账户资金不足时使用后备账户。",
                    label = "后备帐户",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "如果人工智能医生无法到达玩家，则强制复活。",
                    label = "强制恢复已启用",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "人工智能医疗人员仅在值班医疗人员等于或低于此计数时工作。",
                    label = "最大医生在线",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "强制复活触发前的最长任务持续时间。",
                    label = "任务超时",
                },
                deathScreenAiMedicPedModel = {
                    description = "用于 AI 医生的 Ped 模型。",
                    label = "佩德模型",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "倒地玩家自行呼叫 AI 医生时使用的目的地。",
                    label = "玩家请求目的地",
                    options = {
                        hospital = "医院",
                        location = "当前位置",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "呼叫人工智能医生的费用。",
                    label = "价格",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "玩家死亡后，医护人员可以提供远程 AI 医生前需要等待的秒数。",
                    label = "远程派遣等待时间",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "允许医务人员通过调度地图和 /aimedic 命令将 AI 医务人员发送给倒下的玩家。",
                    label = "远程调度",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "远程人工智能医疗调度仅在值班医疗人员等于或低于此计数时才有效。",
                    label = "在线远程调度最大医疗人员",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "远程 AI 医生被派遣并接受时使用的目的地。",
                    label = "远程派遣目的地",
                    options = {
                        hospital = "医院",
                        location = "当前位置",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "玩家接受远程 AI 医生提议的可用秒数。",
                    label = "远程提议超时",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "AI 医生开始苏醒之前所需的距离。",
                    label = "复活距离",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "复活玩家所花费的秒数。",
                    label = "复活持续时间",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "将玩家传送到医院病床上，而不是当场复活。",
                    label = "躺在床上苏醒",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "用于寻找复活床的搜索半径。",
                    label = "床搜索半径",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "死亡后几秒钟，人工智能医生才可以提供帮助。",
                    label = "可用秒数",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "AI 医疗兵的最大生成半径。",
                    label = "最大生成半径",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "最小人工智能医疗兵生成半径。",
                    label = "最小生成半径",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "AI 医生使用的车辆模型。",
                    label = "车辆型号",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "无意识时的语音模式：无、聆听或完整。",
                    label = "语音模式",
                    options = {
                        full = "满的",
                        listen = "听",
                        none = "没有任何",
                    },
                },
                deathScreenAllowedControls = {
                    description = "控制在无意识时保持启用状态的 ID。",
                    label = "允许的控制",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "如果在断开连接时出血计时器已过期，则自动重生玩家。",
                    label = "自动重生过期重新连接",
                },
                deathScreenBackgroundEnd = {
                    description = "死亡屏幕背景的结束颜色。",
                    label = "背景结束",
                },
                deathScreenBackgroundStart = {
                    description = "死亡屏幕背景的起始颜色。",
                    label = "后台启动",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "出血计时器到期前的秒数。",
                    label = "出血定时器",
                },
                deathScreenBlockedDimensions = {
                    description = "死亡屏幕重生流被阻止的维度。",
                    label = "封锁尺寸",
                },
                deathScreenBorderColor = {
                    description = "死亡屏幕使用的边框颜色。",
                    label = "边框颜色",
                },
                deathScreenDispatchEnabled = {
                    description = "从死亡屏幕流发送调度事件。",
                    label = "已启用调度",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "当主要接收职业中没有存活且在岗的人员时，改为通知这些职业。留空则始终通知主要职业。",
                    itemLabel = "职业",
                    label = "备用职业",
                },
                deathScreenDispatchJobs = {
                    description = "玩家倒地请求帮助时接收警报的职业。",
                    itemLabel = "职业",
                    label = "接收警报的职业",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "主要帐户因提前重生而收费。",
                    label = "帐户",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "即使是致命伤也能尽早重生。",
                    label = "允许致命伤",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "用于早期重生付款的可选货币密钥。",
                    label = "货币",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "用于早期重生付款的货币格式化程序。",
                    label = "货币格式化程序",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "启用付费早期重生。",
                    label = "启用",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "当主账户资金不足时使用的后备账户。",
                    label = "后备帐户",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "显示用于早期重生付款的可选标签。",
                    label = "付款标签",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "提前重生的价格。",
                    label = "价格",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "只允许在没有医务人员值班时提前重生。",
                    label = "无需医护人员",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "死亡后数秒后即可提前重生。",
                    label = "可用秒数",
                },
                deathScreenEnableKeyboard = {
                    description = "允许在死亡屏幕上使用键盘。",
                    label = "启用键盘",
                },
                deathScreenExternalVoiceSystem = {
                    description = "启用后外部语音后端静音。",
                    label = "外部语音系统",
                    options = {
                        saltychat = "咸味的聊天",
                        yaca = "亚卡",
                    },
                },
                deathScreenFocusKey = {
                    label = "死亡画面鼠标交互",
                    description = "FiveM 默认按键，例如 E、F6 或 MOUSE_BUTTON:MOUSE_RIGHT。留空表示不设置默认按键。玩家可在 FiveM 设置中自行修改，已保存的个人按键设置会被保留。",
                },
                deathScreenHandlingMode = {
                    description = "使用静态死亡动画，或保留自然布娃娃物理效果直到身体稳定。",
                    label = "死亡处理",
                    options = {
                        natural = "自然",
                        static = "静态",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "按下空格键切换到游戏控制时隐藏死亡界面；禁用此选项可保留原有的可见界面。",
                    label = "使用游戏控制时隐藏界面",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "应用于相机对焦目标的高度偏移。",
                    label = "焦点高度",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "预览相机视野。",
                    label = "视野",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "放置预览相机时使用的航向偏移。",
                    label = "航向偏移",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "应用于预览相机的高度偏移。",
                    label = "相机高度",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "应用于预览相机的俯仰。",
                    label = "沥青",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "从预览相机到生成点的距离。",
                    label = "相机半径",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "打开医院选择相机时使用平滑过渡。",
                    label = "平滑过渡",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "允许玩家在重生前选择医院。",
                    label = "医院选择",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "仅当存在多家医院时才显示医院选择。",
                    label = "需要多家医院",
                },
                deathScreenInformationEnabled = {
                    description = "在死亡屏幕上显示信息块。",
                    label = "启用",
                },
                deathScreenInformationShowDeathCause = {
                    description = "在死亡屏幕信息块中显示死亡原因。",
                    label = "显示死亡原因",
                },
                deathScreenInformationShowInjuries = {
                    description = "在死亡屏幕信息块中显示伤害。",
                    label = "显示受伤情况",
                },
                deathScreenInformationShowKiller = {
                    description = "在死亡屏幕信息块中显示杀手姓名。",
                    label = "表演杀手",
                },
                deathScreenInformationShowWeapon = {
                    description = "在死亡屏幕信息块中显示武器。",
                    label = "显示武器",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "帮派白名单",
                    description = "选择帮派或独立组织的内部名称。职业或帮派匹配即可获得相应权限或豁免。值勤要求仅适用于职业。",
                    itemLabel = "帮派",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "允许乔布斯查看扩展的死亡屏幕信息。",
                    itemLabel = "工作",
                    label = "白名单职位",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "每次死亡截图上传允许的最长秒数。",
                    label = "截图超时",
                },
                deathScreenLogScreenshots = {
                    description = "文本死亡日志发送后，上传受害者和已确认击杀者的视角截图。",
                    label = "截图",
                },
                deathScreenLogsEnabled = {
                    description = "玩家死亡时发送 Discord 日志。",
                    label = "死亡日志",
                },
                deathScreenMedicNearbyRadius = {
                    description = "用于将医务人员算作附近的距离（以米为单位）。",
                    label = "半径附近的医疗兵",
                },
                deathScreenMinigameEnabled = {
                    description = "启用死亡屏幕小游戏。",
                    label = "启用",
                },
                deathScreenMinigameUrl = {
                    description = "为死亡屏幕迷你游戏打开的 URL。",
                    label = "小游戏网址",
                },
                deathScreenMode = {
                    description = "使用内置死亡界面或外部集成。",
                    label = "屏幕模式",
                    options = {
                        external = "外部",
                        internal = "内置",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "当玩家死亡时，将外部语音系统静音。",
                    label = "静音外部声音",
                },
                deathScreenMutedTextColor = {
                    description = "死亡屏幕使用的静音文本颜色。",
                    label = "静音文本颜色",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "当自然死亡角色保持布娃娃状态时，输出详细的客户端和服务器原因。",
                    label = "自然布娃娃调试",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "自动稳定停止移动的自然死亡角色，或要求值班医护人员将其置于稳定侧卧位。",
                    label = "自然状态稳定方式",
                    options = {
                        automatic = "自动",
                        medic = "需要医护人员",
                    },
                },
                deathScreenPanelBackground = {
                    description = "死亡屏幕使用的面板背景颜色。",
                    label = "面板背景",
                },
                deathScreenPreventAutoRespawn = {
                    description = "阻止出血后自动重生。",
                    label = "防止自动重生",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "当医生在附近时阻止自动重生。",
                    label = "当医生在附近时进行阻止",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "溢出计时器到期后，块会复活。",
                    label = "防止过期复活",
                },
                deathScreenPrimaryColor = {
                    description = "用于死亡屏幕主题的基本 CSS 颜色。",
                    label = "原色",
                },
                deathScreenPrimaryDark = {
                    description = "死亡屏幕可选较暗的强调色。",
                    label = "原色暗",
                },
                deathScreenPrimaryStrong = {
                    description = "死亡屏幕可选更强的强调色。",
                    label = "初级强",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "当电台未定义航向时使用的航向。",
                    label = "默认标题",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "当不存在医院位置时使用后备重生方向。",
                    label = "备用标题",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "当不存在医院位置时使用后备重生 X 坐标。",
                    label = "回退X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "当不存在医院位置时使用后备重生 Y 坐标。",
                    label = "回退 Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "当不存在医院位置时使用后备重生 Z 坐标。",
                    label = "后备 Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "选择固定医院进行重生。将其留空以使用最近的医院。",
                    label = "重生医院",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "重生时删除帐户余额。",
                    label = "删除帐户",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "帐户名称在重生时被删除。",
                    itemLabel = "帐户",
                    label = "账户名称",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "重生时移除库存物品。",
                    label = "删除项目",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "库存物品不断重生。",
                    itemLabel = "物品",
                    label = "被忽略的项目",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "重生时移除武器轮武器。",
                    label = "移除武器",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "武器不断重生。",
                    itemLabel = "武器",
                    label = "被忽视的武器",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "重生时将玩家传送到医院。",
                    label = "传送到医院",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "重新连接后恢复出血计时器而不是重置它。",
                    label = "重新连接时恢复",
                },
                deathScreenShadowLight = {
                    description = "死亡屏幕使用的柔和阴影颜色。",
                    label = "阴影光",
                },
                deathScreenShadowMid = {
                    description = "死亡屏幕使用的中阴影颜色。",
                    label = "暗影中",
                },
                deathScreenShowNearestMedic = {
                    description = "在死亡屏幕上显示最近的医生。",
                    label = "显示最近的医生",
                },
                deathScreenTextColor = {
                    description = "死亡屏幕使用的主要文本颜色。",
                    label = "文字颜色",
                },
                deathScreenTextShadow = {
                    description = "死亡屏幕使用的文本阴影颜色。",
                    label = "文字阴影",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "淘汰赛复活后也适用死亡超时。",
                    label = "适用于淘汰赛",
                },
                deathTimeoutSeconds = {
                    description = "复活后数秒，战斗仍处于禁用状态。",
                    label = "秒数",
                },
                deathTimeoutShowUi = {
                    description = "活动时显示死亡超时倒计时横幅。",
                    label = "显示用户界面",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "帮派白名单",
                    description = "选择帮派或独立组织的内部名称。职业或帮派匹配即可获得相应权限或豁免。值勤要求仅适用于职业。",
                    itemLabel = "帮派",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "作业不受死亡超时限制。",
                    itemLabel = "工作",
                    label = "白名单职位",
                },
                deathUseAnimation = {
                    description = "为受支持的 ped 播放配置的死亡动画。",
                    label = "使用动画",
                },
                diagnoseAnimClip = {
                    description = "打开诊断时使用的动画剪辑。留空以使用场景代替。",
                    label = "动画名称",
                },
                diagnoseAnimDict = {
                    description = "打开诊断时使用的动画字典。留空以使用场景代替。",
                    label = "动画词典",
                },
                diagnoseAnimScenario = {
                    description = "打开诊断时使用的场景。留空以使用 dict + Clip 代替。",
                    label = "设想",
                },
                diagnoseCprAnimDict = {
                    description = "用于心肺复苏的动画词典。",
                    label = "动画词典",
                },
                diagnoseCprAnimName = {
                    description = "用于心肺复苏的动画剪辑。",
                    label = "动画名称",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "完全治疗操作出现前所需的持续诊断时间。",
                    label = "延迟（秒）",
                },
                diagnoseRequireRescueBackpack = {
                    label = "需要急救背包",
                    description = "需要持有 rescue_backpack 才能显示左侧检查工具栏。关闭后始终显示；各工具自身的物品要求仍然生效。",
                },
                diagnoseFullHealEnabled = {
                    description = "允许在持续诊断后完全恢复患者生命值。",
                    label = "启用",
                },
                diagnoseInteractDistance = {
                    description = "诊断或裹尸所需的最大距离。",
                    label = "互动距离",
                },
                diagnosePatientMovementMode = {
                    label = "患者移动",
                    description = "其他玩家打开治疗菜单时冻结患者，或允许患者移动并在超出治疗距离时关闭菜单。自我诊断单独设置。",
                    options = {
                        freeze = "冻结患者",
                        distance = "超出距离时关闭",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "治疗距离（米）",
                    description = "距离模式下，治疗者与患者之间允许的最大距离，超出后关闭治疗菜单。打开菜单的距离单独设置。",
                },
                diagnoseKey = {
                    description = "用于诊断交互的控制 ID。",
                    label = "互动键",
                },
                diagnoseOpenDelayMs = {
                    description = "诊断 UI 打开之前的延迟。",
                    label = "打开延迟毫秒",
                },
                diagnosePromptDistance = {
                    description = "用于显示诊断提示的距离。",
                    label = "提示距离",
                },
                diagnoseTreatmentDurationMs = {
                    description = "用于治疗动画的持续时间。",
                    label = "治疗持续时间 ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "直接收费时将医生付款存入共享社会账户。",
                    label = "为社会增加收入",
                },
                doctorNpcEnabled = {
                    description = "启用医生NPC服务。",
                    label = "启用",
                },
                doctorNpcHealOtherAccount = {
                    description = "主帐户密钥用于治疗其他玩家。",
                    label = "帐户",
                },
                doctorNpcHealOtherAccountType = {
                    description = "用于收取治疗其他玩家费用的主要帐户类型。",
                    label = "账户类型",
                },
                doctorNpcHealOtherCurrency = {
                    description = "可选的自定义货币键用于治疗其他玩家。",
                    label = "货币",
                },
                doctorNpcHealOtherPrice = {
                    description = "在医生 NPC 处治疗另一名玩家的价格。",
                    label = "价格",
                },
                doctorNpcHealSelfAccount = {
                    description = "用于进行自我修复的主帐户密钥。",
                    label = "帐户",
                },
                doctorNpcHealSelfAccountType = {
                    description = "用于收取自我修复费用的主要帐户类型。",
                    label = "账户类型",
                },
                doctorNpcHealSelfCurrency = {
                    description = "可选的自定义货币密钥用于充电自我修复。",
                    label = "货币",
                },
                doctorNpcHealSelfPrice = {
                    description = "在NPC医生处治愈自己的价格。",
                    label = "价格",
                },
                doctorNpcInteractionRange = {
                    description = "使用开放的医生菜单时，用户必须与医生 NPC 保持多近的距离。这不会改变初始 NPC 提示距离。",
                    label = "互动范围",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "NPC 医生仅在值班医务人员低于此限制时工作。",
                    label = "最大医生在线",
                },
                doctorNpcPatientRange = {
                    description = "选择行动后，患者与医生 NPC 的距离必须有多近才能治愈他人或恢复工作。",
                    label = "患者范围",
                },
                doctorNpcPaymentMode = {
                    description = "立即向玩家收费或发送发票。",
                    label = "支付方式",
                    options = {
                        bill = "账单",
                        remove = "消除",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "仅用于在医生 NPC UI 中列出附近的玩家。它本身不允许治疗。",
                    label = "玩家扫描范围",
                },
                doctorNpcReviveAccount = {
                    description = "用于向医生苏醒收费的主帐户密钥。",
                    label = "帐户",
                },
                doctorNpcReviveAccountType = {
                    description = "用于向医生苏醒收费的主要帐户类型。",
                    label = "账户类型",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "允许医生 NPC 复苏有致命或不可复苏伤势的患者。失血倒计时到期后仍不可复苏。",
                    label = "允许致命伤",
                },
                doctorNpcReviveCurrency = {
                    description = "可选的自定义货币键用于向医生苏醒收费。",
                    label = "货币",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "医生苏醒后，将苏醒的玩家放到最近的医院病床上。",
                    label = "启用",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "为医生苏醒寻找附近医院床位所用的最大距离。",
                    label = "搜索半径",
                },
                doctorNpcRevivePrice = {
                    description = "在医生 NPC 处复活玩家的价格。",
                    label = "价格",
                },
                firstAidActionDurationMs = {
                    description = "急救行动需要多长时间。",
                    label = "动作持续时间ms",
                },
                firstAidAnimationDict = {
                    description = "急救行动中使用的动画词典。",
                    label = "动画词典",
                },
                firstAidAnimationFlag = {
                    description = "急救行动期间使用的 TaskPlayAnim 标志。",
                    label = "动画旗帜",
                },
                firstAidAnimationName = {
                    description = "急救行动期间使用的动画剪辑。",
                    label = "动画名称",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "急救后患者的失血计时器增加了秒数。",
                    label = "出血延长秒数",
                },
                firstAidEnabled = {
                    description = "为获得许可的玩家启用急救功能。",
                    label = "启用急救",
                },
                firstAidLicense = {
                    description = "用于验证急救访问的框架许可证名称。",
                    label = "许可证名称",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "允许救护人员颁发急救执照。",
                    label = "添加许可证已启用",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "在径向菜单中显示添加许可证操作。",
                    label = "添加径向许可证",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "在使用添加许可证操作之前需要 EMS 值班。",
                    label = "添加许可证要求义务",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "允许救护人员吊销急救执照。",
                    label = "删除已启用的许可证",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "在径向菜单中显示删除许可证操​​作。",
                    label = "删除径向许可证",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "在使用删除许可证操​​作之前需要 EMS 值班。",
                    label = "取消许可证要求义务",
                },
                firstAidPositionChestOffset = {
                    description = "急救时对齐胸部时使用的胸部偏移。",
                    label = "胸部偏移",
                },
                firstAidPositionSideOffset = {
                    description = "急救时对齐时使用的侧向偏移。",
                    label = "侧面偏移",
                },
                firstAidPositionZOffset = {
                    description = "急救时对齐时使用的垂直偏移。",
                    label = "Z 轴偏移",
                },
                firstAidRequireLicense = {
                    description = "玩家需要先配置急救许可证才能使用急救。",
                    label = "需要许可证",
                },
                firstAidTargetDistance = {
                    description = "急救使用所允许的最大距离。",
                    label = "目标距离",
                },
                healthInsuranceAccount = {
                    description = "用于保险付款的后备帐户密钥。",
                    label = "帐户",
                },
                healthInsuranceAccountType = {
                    description = "用于保险付款的主要账户类型。",
                    label = "账户类型",
                },
                healthInsuranceAvailableDays = {
                    description = "可用的保险期限（以天为单位）。",
                    label = "可用天数",
                },
                healthInsuranceCommand = {
                    description = "用于打开健康保险 UI 的聊天命令。",
                    label = "命令",
                },
                healthInsuranceCurrency = {
                    description = "用于保险付款的可选自定义货币键。",
                    label = "货币",
                },
                healthInsuranceEnabled = {
                    description = "启动健康保险制度。",
                    label = "启用",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "允许获授权的员工在平板中更改保险价格。禁用后将强制使用下方供应商表中的价格。",
                    label = "平板价格管理",
                },
                healthInsuranceProviders = {
                    description = "保险提供商为玩家提供服务。",
                    itemLabel = "供应商",
                    label = "供应商",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "为此救护资源中注册的所有工作使用相同的保险提供商和保单。",
                    label = "在救护工作间共享",
                },
                hospitalBedsBedAnimationDict = {
                    description = "当玩家躺在床上时，动画词典会循环播放。留空以使用默认的死亡动画后备。",
                    label = "动画词典",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "循环床动画的可选手动持续时间。仅在配置自定义床动画时使用。",
                    label = "持续时间毫秒",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "用于循环床动画的 TaskPlayAnim 标志。仅在配置自定义床动画时使用。",
                    label = "动画旗帜",
                },
                hospitalBedsBedAnimationName = {
                    description = "当玩家躺在床上时，动画剪辑会循环播放。留空以使用默认的死亡动画后备。",
                    label = "动画名称",
                },
                hospitalBedsBreakDistance = {
                    description = "玩家被迫下床的距离。",
                    label = "断裂距离",
                },
                hospitalBedsCreatorPedModel = {
                    description = "预览医院床位编辑器中使用的 ped 模型。",
                    label = "创建者 ped 模型",
                },
                hospitalBedsEnabled = {
                    description = "启用已配置的病床交互。",
                    label = "启用",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "玩家从床上起床时播放的动画字典。留空以使用默认的站立行为。",
                    label = "动画词典",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "起床动画的可选手动持续时间。仅在配置自定义起身动画时使用。",
                    label = "持续时间毫秒",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "用于起身动画的 TaskPlayAnim 标志。仅在配置自定义起身动画时使用。",
                    label = "动画旗帜",
                },
                hospitalBedsGetupAnimationName = {
                    description = "玩家从床上起来时播放的动画剪辑。留空以使用默认的站立行为。",
                    label = "动画名称",
                },
                hospitalBedsHeadingOffset = {
                    description = "将玩家放在床上时应用航向偏移。",
                    label = "航向偏移",
                },
                hospitalBedsHeightOffset = {
                    description = "将玩家放在床上时应用的垂直偏移。",
                    label = "高度偏移",
                },
                hospitalBedsInteractDistance = {
                    description = "使用医院病床所需的最大距离。",
                    label = "互动距离",
                },
                hospitalBedsInteractKey = {
                    description = "用于进入或离开病床的控制 ID。",
                    label = "互动键",
                },
                hospitalBedsModels = {
                    description = "世界对象模型被视为可用的医院床位。",
                    itemLabel = "模型",
                    label = "床型",
                },
                hospitalBedsSearchRadius = {
                    description = "用于查找附近的床道具或配置的床的半径。",
                    label = "搜索半径",
                },
                hospitalBlipColor = {
                    description = "用于医院地图光点的光点颜色 ID。",
                    label = "颜色",
                },
                hospitalBlipEnabled = {
                    description = "显示配置的医院位置的医院地图光点。",
                    label = "启用",
                },
                hospitalBlipName = {
                    description = "当没有可用的车站名称时使用后备医院点名称。",
                    label = "姓名",
                },
                hospitalBlipScale = {
                    description = "用于医院地图光点的光点比例。",
                    label = "规模",
                },
                hospitalBlipSprite = {
                    description = "用于医院地图光点的光点精灵 ID。",
                    label = "雪碧",
                },
                imagingInteractionRange = {
                    description = "操作员距成像站的最大距离。",
                    label = "互动范围",
                },
                imagingPatientRange = {
                    description = "患者距成像站的最大距离。",
                    label = "患者范围",
                },
                imagingScanDurationSeconds = {
                    description = "CT 和 MRI 扫描结果的持续时间（以秒为单位）。",
                    label = "扫描持续时间",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "用于出血叠加效果的纯视觉乘数。",
                    label = "出血覆盖强度",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "疼痛屏幕效果的纯视觉乘数。",
                    label = "痛屏强度",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "在施加出血和疼痛之前，单次击中损失的最大生命值的最小百分比。",
                    label = "出血/疼痛最小百分比",
                },
                injuryThresholdRespectArmor = {
                    description = "当击中被护甲吸收时，跳过流血和疼痛。",
                    label = "尊铠",
                },
                knockoutRegenerateDamage = {
                    description = "重生计时器到期后重新产生击倒伤害。",
                    label = "恢复伤害",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "击倒伤害恢复的秒数。",
                    label = "再生持续时间",
                },
                knockoutRespawnSeconds = {
                    description = "玩家被击倒后自动重生前的几秒。",
                    label = "重生秒数",
                },
                knockoutWeapons = {
                    description = "应该触发击倒而不是完整死亡屏幕的武器名称或哈希值。",
                    itemLabel = "武器",
                    label = "武器",
                },
                legShotRagdollChance = {
                    description = "腿部中弹后触发布娃娃效果的概率。",
                    label = "触发概率",
                },
                legShotRagdollCooldownMs = {
                    description = "两次腿部中弹布娃娃效果之间的最短时间。",
                    label = "冷却时间（毫秒）",
                },
                legShotRagdollDebug = {
                    description = "显示腿部中弹布娃娃效果的调试信息。",
                    label = "调试模式",
                },
                legShotRagdollDurationMs = {
                    description = "布娃娃效果的持续时间。",
                    label = "持续时间（毫秒）",
                },
                legShotRagdollFeet = {
                    description = "脚部中弹时启用布娃娃效果。",
                    label = "脚部",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "命中护甲时不触发布娃娃效果。",
                    label = "忽略护甲命中",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "左小腿中弹时启用此效果。",
                    label = "左小腿",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "左大腿中弹时启用此效果。",
                    label = "左大腿",
                },
                legShotRagdollOnlyGunshots = {
                    description = "仅在枪击造成伤害时触发此效果。",
                    label = "仅限枪伤",
                },
                legShotRagdollRightLowerLeg = {
                    description = "右小腿中弹时启用此效果。",
                    label = "右小腿",
                },
                legShotRagdollRightUpperLeg = {
                    description = "右大腿中弹时启用此效果。",
                    label = "右大腿",
                },
                liveDamageFracturesChance = {
                    description = "有意识的伤害击中造成骨折的基本几率。",
                    label = "机会",
                },
                liveDamageFracturesEnabled = {
                    description = "允许有意识的伤害击中滚动骨折。",
                    label = "启用",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "单次击中必须损失的最大生命值百分比，达到后才可能造成骨折。",
                    label = "最低伤害百分比",
                },
                liveDamageFracturesZones = {
                    description = "每个区域的断裂造成实时伤害的几率。",
                    label = "区域机会",
                },
                liveOpenWoundStacksDefault = {
                    description = "未配置身体区域时使用的开放性伤口层数。",
                    label = "默认伤口层数",
                },
                liveOpenWoundStacksZones = {
                    description = "为各身体区域配置开放性伤口层数。",
                    itemLabel = "区域",
                    label = "区域伤口层数",
                },
                liveWoundBleedingClassProfiles = {
                    description = "根据实时伤害原因应用初始出血等级。",
                    label = "活伤流血班",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "允许携带者在不放下患者的情况下进入并驾驶车辆。",
                    label = "允许携带者进入车辆",
                },
                medicCarryAllowConsciousTargets = {
                    description = "允许携带有意识的玩家。",
                    label = "允许有意识的目标",
                },
                medicCarryAllowSprint = {
                    description = "允许在携带患者时进行冲刺。",
                    label = "允许冲刺",
                },
                medicCarryAttachBone = {
                    description = "用于连接携带的玩家的骨骼索引。",
                    label = "连接骨头",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "进行附加俯仰旋转。",
                    label = "沥青",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "进行附辊旋转。",
                    label = "卷",
                },
                medicCarryAttachOffsetsX = {
                    description = "进行附加 X 偏移。",
                    label = "偏移 X",
                },
                medicCarryAttachOffsetsY = {
                    description = "进行附加 Y 偏移。",
                    label = "偏移 Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "携带附加偏航旋转。",
                    label = "偏航",
                },
                medicCarryAttachOffsetsZ = {
                    description = "携带附加 Z 偏移。",
                    label = "偏移 Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "医护人员在运送病人时使用的动画词典。",
                    label = "动画词典",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "医疗人员携带动画使用的 TaskPlayAnim 标志。",
                    label = "动画旗帜",
                },
                medicCarryCarrierAnimationName = {
                    description = "医护人员在搬运病人时使用的动画剪辑。",
                    label = "动画名称",
                },
                medicCarryEnabled = {
                    description = "启用医疗携带系统。",
                    label = "启用",
                },
                medicCarryMaxDistance = {
                    description = "接载患者所需的最大距离。",
                    label = "最大距离",
                },
                medicCarryPassengerAnimationDict = {
                    description = "被携带的病人使用的动画词典。",
                    label = "动画词典",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "所携带的病人动画使用的TaskPlayAnim标志。",
                    label = "动画旗帜",
                },
                medicCarryPassengerAnimationName = {
                    description = "被携带的患者使用的动画剪辑。",
                    label = "动画名称",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "放下失去知觉的病人后重新应用死亡动画。",
                    label = "重新应用死亡动画",
                },
                medicCarryRequireOnDuty = {
                    description = "只有值班医务人员才能开始搬运。",
                    label = "需要值班",
                },
                medicReviveAllowFatalWounds = {
                    description = "允许值班医护人员治疗并复苏有致命或不可复苏伤势的患者。失血倒计时到期后仍不可复苏。",
                    label = "允许致命伤",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "保留未解决的伤势经过治疗或检查表恢复。",
                    label = "保持伤势",
                },
                medicRevivePersistenceKeepPain = {
                    description = "治疗后保留疼痛值，或者当损伤保留时检查表会恢复。",
                    label = "保持疼痛",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "创建医疗评估时, 用于列出附近玩家的最大距离 。",
                    label = "近近病人范围",
                },
                medicalEvaluationRecipientJobs = {
                    description = "可发布和分享医疗评价的专业。",
                    label = "受援职业",
                },
                medicalEvaluationShareBirthDate = {
                    description = "接受治疗的专业可以查看病人的出生日期。",
                    label = "出生日期 出生日期",
                },
                medicalEvaluationShareConclusion = {
                    description = "允许受援行业看到医学结论。",
                    label = "股份结算",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "接受评价的行业可查看哪些评价类型。",
                    label = "共享评价类型",
                },
                medicalEvaluationShareFullName = {
                    description = "接受治疗的职业可以看到病人的全名。",
                    label = "共享全名",
                },
                medicalEvaluationShareGender = {
                    description = "接受服务的职业可以看到病人的性别。",
                    label = "男女比例比例",
                },
                medicalEvaluationShareHeight = {
                    description = "让受助职业看到病人的身高",
                    label = "共享高度",
                },
                medicalEvaluationShareHobbies = {
                    description = "接受服务的专业可以参观病人的休闲活动和爱好活动。",
                    label = "共享休闲和爱好",
                },
                medicalEvaluationShareIssuer = {
                    description = "显示作者姓名。签发职业始终显示为共享文档中的文件夹。",
                    label = "分享作者信息",
                },
                medicalEvaluationSharePersonalId = {
                    description = "接受者的职业可以看病人的个人情况ID。",
                    label = "分享个人 ID",
                },
                medicalEvaluationShareProfession = {
                    description = "接受治疗的职业可以看病人的职业。",
                    label = "职业 职业",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "允许受援行业看到问卷问题和记录的答复。",
                    label = "分享问答",
                },
                medicalEvaluationShareResult = {
                    description = "允许接受评价的行业检查评价是否有待进行、通过或失败。",
                    label = "共享结果",
                },
                medicalEvaluationShareWeight = {
                    description = "接受职业可以看到病人的体重。",
                    label = "份额权重",
                },
                medicalEvaluationTypes = {
                    description = "配置评价类型、问题、回答类型以及每个问题是否活跃。",
                    label = "评价类型和调查表",
                    options = {
                        boolean = "是 / 否",
                        boolean_text = "是/否,附有详细情况",
                        date = "日期",
                        multi_select = "多重选择",
                        number = "数字",
                        rating = "评分",
                        select = "单人选择",
                        text = "文本",
                        textarea = "文本区域",
                        time = "时间",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "启动救护车药片的医疗评估",
                    label = "启用",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "提供永久时长，直到医护人员移除医疗辅助装备为止。",
                    label = "允许持续到移除",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "佩戴手臂石膏时禁止近战攻击。",
                    label = "禁用近战",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "佩戴手臂石膏时强制徒手并禁止切换武器。",
                    label = "禁用武器",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "佩戴手臂石膏时应用战斗限制。",
                    label = "启用",
                },
                medicalWearablesAutoFromFractures = {
                    description = "使用石膏或夹板时治疗匹配的骨折。",
                    label = "骨折联动",
                },
                medicalWearablesCastsEnabled = {
                    description = "允许在左右手臂和腿部使用石膏。",
                    label = "启用",
                },
                medicalWearablesCastsItem = {
                    description = "使用石膏时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesCastsMinigame = {
                    description = "石膏使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "医疗辅助装备的默认时长（分钟）。设为 0 表示持续到移除。",
                    label = "默认分钟数",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "向医护人员显示的医疗辅助装备时长选项（分钟）。",
                    label = "时长选项",
                },
                medicalWearablesEnabled = {
                    description = "在治疗界面中启用石膏、夹板、绷带、颈托和氧气面罩模型。",
                    label = "启用",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "检查并移除已到期医疗辅助装备的频率。",
                    label = "到期检查间隔（秒）",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "允许使用头部绷带模型。",
                    label = "启用",
                },
                medicalWearablesHeadBandageItem = {
                    description = "使用头部绷带时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "头部绷带使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "佩戴腿部石膏时禁止跳跃。",
                    label = "禁用跳跃",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "佩戴腿部石膏时禁止冲刺。",
                    label = "禁用冲刺",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "佩戴腿部石膏时强制使用受伤移动动画组。",
                    label = "强制受伤步态",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "佩戴腿部石膏时覆盖移动速度。",
                    label = "移动速度",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "佩戴腿部石膏时应用移动限制。",
                    label = "启用",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "允许使用颈托模型。",
                    label = "启用",
                },
                medicalWearablesNeckBraceItem = {
                    description = "使用颈托时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "颈托使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "允许使用氧气面罩模型。",
                    label = "启用",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "使用氧气面罩时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "氧气面罩使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "向患者显示当前医疗辅助用品及剩余佩戴时间。",
                    label = "启用",
                },
                medicalWearablesPatientHudPosition = {
                    description = "选择患者医疗辅助用品界面的显示位置。",
                    label = "位置",
                    options = {
                        ["bottom-center"] = "底部居中",
                        ["bottom-left"] = "左下",
                        ["bottom-right"] = "右下",
                        center = "居中",
                        ["center-left"] = "左侧居中",
                        ["center-right"] = "右侧居中",
                        ["top-center"] = "顶部居中",
                        ["top-left"] = "左上",
                        ["top-right"] = "右上",
                    },
                },
                medicalWearablesPersistence = {
                    description = "玩家重新连接或资源重启后恢复有时限的石膏、夹板、颈托和躯干绷带。",
                    label = "医疗辅助装备持久化",
                },
                medicalWearablesRemoval = {
                    description = "允许医护人员在治疗界面中移除有效的石膏、夹板、颈托和躯干绷带。",
                    label = "医护移除",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "在治疗界面中显示使用已配置工具移除医疗辅助装备的选项。",
                    label = "启用移除治疗",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "移除医疗辅助装备时所需的可重复使用背包工具。",
                    label = "物品",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "移除医疗辅助器具时的小游戏（默认为 cast_saw）。",
                    label = "小游戏",
                },
                medicalWearablesSplintsEnabled = {
                    description = "允许使用左右手臂悬带夹板。",
                    label = "启用",
                },
                medicalWearablesSplintsItem = {
                    description = "使用夹板时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesSplintsMinigame = {
                    description = "夹板使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "允许使用躯干绷带模型。",
                    label = "启用",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "使用躯干绷带时消耗的背包物品。",
                    label = "物品",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "躯干绷带使用的现有治疗小游戏。",
                    label = "小游戏",
                },
                medicationsProfiles = {
                    description = "用于治疗和自我药疗的声明性药物条目。",
                    itemLabel = "药物",
                    label = "药物",
                },
                minigamesBagValveMaskEnabled = {
                    description = "启用袋阀面罩小游戏。",
                    label = "袋阀面罩",
                },
                minigamesCastSawEnabled = {
                    description = "启用移除医疗辅助器具时的石膏锯小游戏。",
                    label = "石膏锯",
                },
                minigamesBandageWrapEnabled = {
                    description = "启用绷带包裹小游戏。",
                    label = "绷带包扎",
                },
                minigamesBloodPressureEnabled = {
                    description = "启用血压小游戏。",
                    label = "血压",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "启用输血小游戏。",
                    label = "输血",
                },
                minigamesBulletExtractionEnabled = {
                    description = "启用子弹提取小游戏。",
                    label = "子弹提取",
                },
                minigamesCprBreathsPerCycle = {
                    description = "每个通气阶段所需的呼吸。",
                    label = "每个周期的呼吸次数",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "数秒内完成一次压缩形变。",
                    label = "每组压缩持续时间",
                },
                minigamesCprCompressionWindow = {
                    description = "达到压缩节拍时允许偏移。",
                    label = "压缩窗口",
                },
                minigamesCprCompressionsEnabled = {
                    description = "启用 CPR 按压迷你游戏阶段。",
                    label = "心肺复苏按压",
                },
                minigamesCprCompressionsPerSet = {
                    description = "每组按压次数。",
                    label = "每组按压次数",
                },
                minigamesCprCycles = {
                    description = "完成迷你游戏需要多少次心肺复苏周期。",
                    label = "周期",
                },
                minigamesCprEnabled = {
                    description = "启用心肺复苏小游戏。",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "心肺复苏开始前的倒计时。",
                    label = "简介延迟秒数",
                },
                minigamesCprMaxMisses = {
                    description = "心肺复苏小游戏失败之前允许失误。",
                    label = "最大失误次数",
                },
                minigamesCprSetsPerCycle = {
                    description = "在呼吸阶段之前运行多少次压缩组。",
                    label = "每个周期的组数",
                },
                minigamesCprVentilationEnabled = {
                    description = "启用心肺复苏通气小游戏阶段。",
                    label = "心肺复苏通气",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "启用血糖仪小游戏。",
                    label = "血糖仪",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "启用脉搏测量小游戏。",
                    label = "脉冲测量",
                },
                minigamesPulseOximeterEnabled = {
                    description = "启用脉搏血氧计小游戏。",
                    label = "脉搏血氧仪",
                },
                minigamesSalineInfusionEnabled = {
                    description = "启用盐水输注小游戏。",
                    label = "生理盐水输液",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "通气尝试超时前的几秒。设置 0 禁用。",
                    label = "呼吸超时秒数",
                },
                minigamesVentilationEnabled = {
                    description = "启用通风小游戏。",
                    label = "通风",
                },
                minigamesVentilationTolerance = {
                    description = "追踪气流波时的像素距离容差。",
                    label = "宽容",
                },
                operationsBreakDistance = {
                    description = "参与者离开手术室多远后将中止手术。",
                    label = "中止距离",
                },
                operationsDoctorAnimationDict = {
                    description = "医生实施真实手术时使用的 GTA 动画字典。",
                    label = "医生动画字典",
                },
                operationsDoctorAnimationFlag = {
                    description = "应用于医生真实手术动画的 GTA 动画标志。",
                    label = "医生动画标志",
                },
                operationsDoctorAnimationName = {
                    description = "医生实施真实手术时使用的动画片段。",
                    label = "医生动画名称",
                },
                operationsEnabled = {
                    description = "启用手术室和外科手术功能。",
                    label = "启用",
                },
                operationsFadeInMs = {
                    description = "患者苏醒时屏幕淡入的持续时间，单位为毫秒。",
                    label = "苏醒淡入时间（毫秒）",
                },
                operationsFadeOutMs = {
                    description = "患者接受麻醉时屏幕淡出的持续时间，单位为毫秒。",
                    label = "麻醉淡出时间（毫秒）",
                },
                operationsIdleTimeoutSeconds = {
                    description = "未收到有效小游戏操作时允许等待的最长时间，超时后会中止本次会话。",
                    label = "操作空闲超时（秒）",
                },
                operationsInteractDistance = {
                    description = "显示和使用手术室交互的最大距离。",
                    label = "交互距离",
                },
                operationsInteractKey = {
                    description = "用于与手术台和医生位置交互的控制 ID。",
                    label = "交互键",
                },
                operationsPatientAnimationDict = {
                    description = "患者在全身麻醉下躺卧时使用的 GTA 动画字典。",
                    label = "患者动画字典",
                },
                operationsPatientAnimationFlag = {
                    description = "应用于患者躺卧动画的 GTA 动画标志。",
                    label = "患者动画标志",
                },
                operationsPatientAnimationName = {
                    description = "患者在全身麻醉下躺卧时使用的动画片段。",
                    label = "患者动画名称",
                },
                operationsPatientRange = {
                    description = "检测躺在手术台上的患者时使用的最大范围。",
                    label = "患者检测范围",
                },
                operationsRequireOnDuty = {
                    description = "要求外科医生在使用手术室前处于在岗状态。",
                    label = "要求在岗",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "外科医生可停留在手术选择界面的最长时间，超时后会中止本次会话。",
                    label = "选择超时（秒）",
                },
                operationsTrainingAnimationDict = {
                    description = "无患者手术训练所使用的 GTA 动画字典。",
                    label = "训练动画字典",
                },
                operationsTrainingAnimationFlag = {
                    description = "应用于手术训练动画的 GTA 动画标志。",
                    label = "训练动画标志",
                },
                operationsTrainingAnimationName = {
                    description = "无患者手术训练所使用的动画片段。",
                    label = "训练动画名称",
                },
                painClassesProfiles = {
                    description = "疼痛阈值、标签和后处理效果。",
                    label = "疼痛课程",
                },
                painEffectsMinPainLevel = {
                    description = "疼痛屏幕效果开始前的最低疼痛水平。",
                    label = "最低疼痛程度",
                },
                primaryColor = {
                    description = "急救界面和救护职业组的主颜色。",
                    label = "原色",
                },
                propPlacementConsumeItem = {
                    description = "放置道具后消耗匹配的库存物品。",
                    label = "消耗物品",
                },
                propPlacementEnabled = {
                    description = "允许从可用的库存物品中放置已配置的 EMS 道具。",
                    label = "启用",
                },
                propPlacementItemNames = {
                    description = "将 EMS 道具模型映射到库存物品名称，以进行基于物品的放置。",
                    label = "道具名称",
                },
                propPlacementRequireOnDuty = {
                    description = "要求玩家在放置EMS道具前值班。",
                    label = "需要值班",
                },
                propPlacementReturnItem = {
                    description = "当放置的道具被移除时，将消耗的物品归还。",
                    label = "删除后返回项目",
                },
                propPlacementVehicleAccess = {
                    description = "允许主干道具打开放置流程，而不是仅使用物品。",
                    label = "车辆通行",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "允许对有意识的玩家进行公开治疗。",
                    label = "让意识清醒的患者",
                },
                publicTreatmentAllowedGangs = {
                    label = "允许的帮派",
                    description = "选择帮派或独立组织的内部名称。职业或帮派匹配即可获得相应权限或豁免。值勤要求仅适用于职业。 可选的帮派最低等级。为空时允许所有等级。物品要求仍然有效。",
                },
                publicTreatmentAllowedJobs = {
                    description = "可能使用公共待遇但不属于 EMS 的工作。",
                    label = "允许的工作",
                },
                publicTreatmentEnabled = {
                    description = "为具有有效访问权限的非 EMS 响应者提供公共治疗。",
                    label = "启用公共治疗",
                },
                publicTreatmentInteractDistance = {
                    description = "开始公共治疗所需的最大距离。",
                    label = "互动距离",
                },
                publicTreatmentKeybind = {
                    description = "用于公共处理的默认交互键绑定。",
                    label = "按键绑定",
                },
                publicTreatmentInteractionEnabled = {
                    description = "显示治疗提示并启用对应按键。使用导出函数或自定义径向菜单时请关闭。",
                    label = "启用按键交互",
                },
                publicTreatmentPromptDistance = {
                    description = "用于显示公众治疗提示的距离。",
                    label = "提示距离",
                },
                publicTreatmentRequireAllItems = {
                    description = "要求列出所有列出的医疗物品，而不是仅一种。",
                    label = "需要所有项目",
                },
                publicTreatmentRequiredItems = {
                    description = "盘点算作有效公共治疗装备的物品。",
                    itemLabel = "物品",
                    label = "必填项目",
                },
                reviveRewardAccount = {
                    description = "用于恢复奖励支付的主帐户密钥。",
                    label = "帐户",
                },
                reviveRewardAccountType = {
                    description = "用于恢复奖励支付的主要帐户类型。",
                    label = "账户类型",
                },
                reviveRewardAmount = {
                    description = "支付给医生复活的奖励金额。",
                    label = "数量",
                },
                reviveRewardCurrency = {
                    description = "用于恢复奖励支付的可选自定义货币密钥。",
                    label = "货币",
                },
                reviveRewardEnabled = {
                    description = "医疗兵成功复活后支付配置的奖励。",
                    label = "启用",
                },
                reviveRewardPayFromSociety = {
                    description = "在支付医疗费用之前，从共享职业社会中扣除复活奖励。",
                    label = "来自社会的付出",
                },
                selfDiagnoseCommand = {
                    description = "聊天命令用于打开自我诊断。",
                    label = "命令",
                },
                selfDiagnoseEnabled = {
                    description = "允许玩家自行打开诊断用户界面。",
                    label = "自诊断已启用",
                },
                selfDiagnoseKeybind = {
                    description = "默认按键绑定用于打开自我诊断。",
                    label = "按键绑定",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "自诊断 UI 打开之前的延迟。",
                    label = "打开延迟毫秒",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "将自我诊断仅限于医疗工作。",
                    label = "需要医生工作",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "自诊断时请勿冻结播放器。",
                    label = "跳过自我冻结",
                },
                statusEffectsProfiles = {
                    description = "配置出血、低血、饥饿和口渴的屏幕效果和阈值。",
                    label = "状态效果",
                },
                stretcherAnimDict = {
                    description = "搬运担架时使用的动画词典。",
                    label = "动画词典",
                },
                stretcherAnimName = {
                    description = "搬运担架时使用的动画名称。",
                    label = "动画名称",
                },
                stretcherAttachRx = {
                    description = "携带担架的 X 旋转附件。",
                    label = "连接接收端",
                },
                stretcherAttachRy = {
                    description = "携带担架的 Y 旋转附件。",
                    label = "附上RY",
                },
                stretcherAttachRz = {
                    description = "为担架携带 Z 轴旋转附件。",
                    label = "连接RZ",
                },
                stretcherAttachX = {
                    description = "携带担架的 X 偏移连接件。",
                    label = "附上X",
                },
                stretcherAttachY = {
                    description = "携带担架的附加 Y 偏移。",
                    label = "附上Y",
                },
                stretcherAttachZ = {
                    description = "携带担架的附加 Z 偏移。",
                    label = "连接Z",
                },
                stretcherFoldedEnabled = {
                    description = "在车内启用可选的折叠担架变体。",
                    label = "折叠启用",
                },
                stretcherFoldedModel = {
                    description = "用于折叠担架变体的道具模型。",
                    label = "折叠模型",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "用于折叠担架变体的患者方向。",
                    label = "折叠患者标题",
                },
                stretcherFoldedPatientAttachX = {
                    description = "患者为折叠担架安装 X 偏移。",
                    label = "折叠患者 X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "患者为折叠担架附加 Y 偏移。",
                    label = "折叠患者 Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "患者为折叠担架安装 Z 轴偏移。",
                    label = "折叠患者 Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "用于直升机的交互距离覆盖。",
                    label = "直升机交互距离",
                },
                stretcherHelicopterModels = {
                    description = "车辆模型被视为担架直升机。",
                    itemLabel = "模型",
                    label = "直升机模型",
                },
                stretcherHelicopterPickupDistance = {
                    description = "用于直升机的拾取距离覆盖。",
                    label = "直升机接送距离",
                },
                stretcherInteractDistance = {
                    description = "担架交互提示的最大距离。",
                    label = "互动距离",
                },
                stretcherItemEnabled = {
                    description = "启用担架库存物品，包括在商店购买和使用。",
                    label = "担架物品",
                },
                stretcherItemPickupEnabled = {
                    description = "允许将通过库存物品部署的担架收回库存。",
                    label = "物品回收",
                },
                stretcherModel = {
                    description = "EMS 担架系统使用的主要担架支柱模型。",
                    label = "模型",
                },
                stretcherPatientAnimationDict = {
                    description = "担架患者和预览 NPC 使用的动画字典。",
                    label = "患者动画字典",
                },
                stretcherPatientAnimationName = {
                    description = "担架患者和预览 NPC 使用的动画片段。",
                    label = "患者动画名称",
                },
                stretcherPatientAttachHeading = {
                    description = "患者躺在担架上时使用的头向。",
                    label = "患者方向",
                },
                stretcherPatientAttachX = {
                    description = "患者将 X 偏移连接到担架上。",
                    label = "患者X",
                },
                stretcherPatientAttachY = {
                    description = "患者将 Y 偏移连接到担架上。",
                    label = "患者Y",
                },
                stretcherPatientAttachZ = {
                    description = "患者将 Z 轴偏移固定在担架上。",
                    label = "病人Z",
                },
                stretcherPickupDistance = {
                    description = "拿起担架并与担架互动所需的距离。",
                    label = "接送距离",
                },
                stretcherTreatmentAnimClip = {
                    description = "在担架上治疗病人时使用的动画剪辑。留空以使用场景或处理动画后备。",
                    label = "动画名称",
                },
                stretcherTreatmentAnimDict = {
                    description = "治疗担架上的病人时使用的动画词典。留空以使用场景或处理动画后备。",
                    label = "动画词典",
                },
                stretcherTreatmentAnimScenario = {
                    description = "治疗担架上的病人时使用的可选场景。留空以使用 dict + 剪辑或处理动画后备。",
                    label = "设想",
                },
                stretcherVehicleAttachRx = {
                    description = "车辆附有 X 轴旋转以装载担架。",
                    label = "车辆接收",
                },
                stretcherVehicleAttachRy = {
                    description = "车辆附有 Y 旋转以装载担架。",
                    label = "车辆RY",
                },
                stretcherVehicleAttachRz = {
                    description = "车辆附有 Z 轴旋转以装载担架。",
                    label = "车辆RZ",
                },
                stretcherVehicleAttachX = {
                    description = "用于装载担架的车辆附加 X 偏移。",
                    label = "车辆X",
                },
                stretcherVehicleAttachY = {
                    description = "用于装载担架的车辆附加 Y 偏移。",
                    label = "车辆 Y",
                },
                stretcherVehicleAttachZ = {
                    description = "用于装载担架的车辆附加 Z 偏移。",
                    label = "车辆Z",
                },
                stretcherVehicleModels = {
                    description = "允许装载担架的车型。",
                    itemLabel = "模型",
                    label = "车型",
                },
                treatmentAnimClip = {
                    description = "治疗病人时使用的动画剪辑。留空以使用场景代替。",
                    label = "动画名称",
                },
                treatmentAnimDict = {
                    description = "治疗病人时使用的动画词典。留空以使用场景代替。",
                    label = "动画词典",
                },
                treatmentAnimScenario = {
                    description = "治疗病人时使用的场景。留空以使用 dict + Clip 代替。",
                    label = "设想",
                },
                trunkPropsEnabled = {
                    label = "车辆道具",
                    description = "在附近的公务车辆旁选择道具。",
                },
                trunkEnabled = {
                    description = "启用救护车的车辆后备箱功能。",
                    label = "启用",
                },
                vehicleDamageModifier = {
                    description = "当玩家在车内时，伤害倍数会受到影响。",
                    label = "车辆伤害修正",
                },
                vehicleImpactProtectionCauses = {
                    description = "应算作受保护车辆影响的死亡原因。",
                    itemLabel = "原因",
                    label = "损坏原因",
                },
                vehicleImpactProtectionEnabled = {
                    description = "防止低速车辆撞击导致玩家死亡。",
                    label = "启用",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "低于此速度的车辆撞击不会杀死玩家。",
                    label = "致命速度 公里/小时",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "在此速度或以上的车辆碰撞采用正常的死亡伤害配置。",
                    label = "满伤速度km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "当车辆碰撞保护装置阻止致命撞击时造成伤害。",
                    itemLabel = "受伤",
                    label = "受伤",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "当受保护的撞击会杀死玩家时保留的最大生命值的百分比。",
                    label = "生存健康百分比",
                },
                vehiclePullEnabled = {
                    description = "能够将患者从车辆中拉出。",
                    label = "启用",
                },
                vehiclePullMaxDistance = {
                    description = "将患者从车辆中拉出所需的最大距离。",
                    label = "最大距离",
                },
                wheelchairAssignMaxDistance = {
                    description = "为其他玩家分配轮椅的最大距离。",
                    label = "指定最大距离",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "分配到期时自动卸下轮椅。",
                    label = "到期时自动取消装备",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "默认分配的轮椅持续时间（以分钟为单位）。",
                    label = "默认持续时间",
                },
                wheelchairDisableSprint = {
                    description = "配备轮椅时阻止冲刺。",
                    label = "禁用冲刺",
                },
                wheelchairDisableWeapons = {
                    description = "配备轮椅时阻止使用武器。",
                    label = "禁用武器",
                },
                wheelchairExitControl = {
                    description = "用于离开轮椅的控制 ID。",
                    label = "退出控制",
                },
                wheelchairItemName = {
                    description = "用于轮椅的库存物品。",
                    label = "商品名称",
                },
                wheelchairMaxDurationMinutes = {
                    description = "允许的轮椅分配最长持续时间（以分钟为单位）。",
                    label = "最长持续时间",
                },
                wheelchairMinDurationMinutes = {
                    description = "允许的最短轮椅分配持续时间（以分钟为单位）。",
                    label = "最短持续时间",
                },
                wheelchairVehicle = {
                    description = "用于轮椅的车辆模型。",
                    label = "车辆型号",
                },
                xrayInteractionRange = {
                    description = "操作员距 X 射线站的最大距离。",
                    label = "互动范围",
                },
                xrayPatientRange = {
                    description = "患者距 X 射线站的最大距离。",
                    label = "患者范围",
                },
                xrayScanDurationSeconds = {
                    description = "X 射线扫描结果的持续时间（以秒为单位）。",
                    label = "扫描持续时间",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "病人订票尝试之间 每隔几秒钟就冷却下来",
                    label = "订定冷却",
                },
                appointmentsEnabled = {
                    description = "激活病人预约 和个人医疗日历。",
                    label = "启用",
                },
                appointmentsMaxAdvanceDays = {
                    description = "病人未来可能预定的最大天数。",
                    label = "最大预先预订",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "患者可能持有的现任任命期最长未来人数。",
                    label = "每名病人的最长预约时间",
                },
                appointmentsMinLeadMinutes = {
                    description = "预约和预约之间的最低分钟数 。",
                    label = "最低周转时间",
                },
                appointmentsNotificationApp = {
                    description = "用于预约通知的电话应用程序识别码。",
                    label = "通知应用程序",
                },
                appointmentsNotificationsEnabled = {
                    description = "预约预约或取消时,请通过电话通知病人。",
                    label = "电话通知",
                },
                appointmentsReasonMaxLength = {
                    description = "因任用原因最多可接受字符数。",
                    label = "原因字符限制",
                },
                appointmentsSlotDurationMinutes = {
                    description = "任期和任用时间段的网格间隔以分钟计。",
                    label = "空档时间",
                },
                enforceMaxHealth = {
                    description = "保持玩家最大健康值200。 当另一资源管理最大健康时禁用此功能 。",
                    label = "执行 200 最大健康",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "额外的救护人员在病历中可以提供或删除额外的框架许可证,所配置的急救许可证总是包括在内。",
                    itemLabel = "许可证许可证许可证",
                    label = "额外病人执照",
                },
                minigamesBandageWrapRandomization = {
                    description = "随机调整纱布路径方向、形状和比例。",
                    label = "带状包装变异",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "随机选择输血的静脉注射路径",
                    label = "输聚获取变异",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "需要多步静态访问程序才能控制流量。 禁用旧的简单版本 。",
                    label = "通灵进入阶段",
                },
                minigamesBulletExtractionRandomization = {
                    description = "将伤口的运河形状 宽度和障碍物随机调整",
                    label = "弹头提取变异",
                },
                stretcherVehicleAttachEditor = {
                    description = "将担架在配置的救护车内旋转",
                    label = "车辆附件",
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
            warnings = {
                firstAidPublicTreatmentConflict = "急救和公共治疗不能同时启用。保存会禁用两者。",
            },
            actions = {
                actionFailed = "操作失败。",
                delete = "删除",
                duplicate = "复制",
                editDetails = "编辑详情和区域",
                editPosition = "编辑位置",
                hideDetails = "隐藏详情",
                remove = "移除",
            },
            creator = {
                createFailed = "创建条目失败。",
                creating = "正在创建...",
                deleteFailed = "删除条目失败。",
                emptySubtitle = "添加第一个条目以开始配置此功能。",
                emptyTitle = "尚未配置条目。",
                saveFailed = "保存条目失败。",
                sectionMissing = "此配置区域不可用。",
            },
            damageHandling = {
                chips = {
                    bleeding = "出血",
                    chance = "概率",
                    pain = "疼痛",
                    state = "状态",
                    zones = "区域",
                },
                deathInjuries = {
                    causesTitle = "死亡原因",
                    entriesLabel = "伤情条目",
                    groupsLabel = "伤情组",
                    noCausesDescription = "为此伤情组添加至少一个死亡原因。",
                    noCausesTitle = "未配置死亡原因",
                    noEntriesDescription = "向此组添加第一个伤情条目。",
                    noEntriesTitle = "未配置伤情条目",
                    noSelectionDescription = "选择一个伤情组以编辑其条目和死亡原因。",
                    noSelectionTitle = "未选择伤情组",
                },
                vehicleImpact = {
                    emptyDescription = "添加第一个车辆撞击伤情。",
                    emptyTitle = "未配置车辆撞击伤情",
                    zoneHint = "选择此伤情可影响的身体区域。",
                },
            },
            fields = {
                allowedValues = "允许的值",
                blockedValues = "禁止的值",
            },
            gradient = {
                angle = "角度",
                from = "起始颜色",
                fromStop = "起始位置",
                to = "结束颜色",
                toStop = "结束位置",
            },
            placeholders = {
                valueRule = "输入一个值",
            },
            search = {
                contextEntry = "条目：{entry}",
                contextSection = "区域：{section}",
                empty = "没有匹配的设置。",
                open = "打开",
                placeholder = "搜索设置...",
                subtitle = "在此急救职业配置中查找设置。",
                title = "搜索配置",
            },
            vehicleAttachEditor = {
                instructions = "使用移动和旋转控制调整物体。按 Enter 保存，按 Backspace 取消。",
                missingModel = "请先选择一个有效的模型。",
                offset = "位置偏移",
                placementFailed = "无法打开物体放置编辑器。",
                placementSaved = "物体位置已保存。",
                rotation = "旋转",
            },
        },
    },
}
