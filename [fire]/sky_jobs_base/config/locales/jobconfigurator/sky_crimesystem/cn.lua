JobConfigLocales["sky_crimesystem:cn"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "直接命令",
            roleDefaults = {
                title = "职级",
                description = "为每项默认权限选择最低职级。管理菜单中保存的职级权限优先。",
                bossHint = "首领和副首领职级始终拥有全部权限。",
                empty = "此职业尚无可用职级。",
                gradesTitle = "职业职级",
                noDefault = "默认不授予",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "共享默认设置适用于继承字段。在设置页面修改数值会将该字段切换为自定义值。现有条目保留原值。",
            weaponStreetDescription = "使用毒品街头联系人时，服务器偶尔会收购符合条件的武器。选择、价格和付款均由服务器决定。",
            weaponGroups = {
                general = "通用默认值",
                access = "访问默认值",
                collection = "采集默认值",
                production = "生产默认值",
                market = "市场默认值",
                delivery = "订单默认值",
                street = "街头武器销售",
            },
            weaponOptions = {
                scrap_search = "搜索废料堆",
                player = "每位玩家",
                global = "全局",
                money = "现金",
                bank = "银行账户",
                black_money = "黑钱",
                timing = "将指针停在最佳范围内。",
                precision = "在精密窗口期内完成每次切割。",
                pressure = "在最佳压力下停止压机。",
            },

            reputation = {
                remove = "删除",
                title = "声望",
                action = "行动",
                points = "每次完成的点数",
                enabled = "启用",
                search = "搜索行动",
                added = "已添加",
                noResults = "未找到匹配的行动。",
                empty = "尚无行动。点击加号添加行动。",
                name = "规则名称",
                target = "目标（可选）",
            },
            configs = {
                sky_crimesystem = {
                    entries = "派系",
                    subtitle = "配置犯罪工作及其共享位置。",
                    title = "犯罪系统",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "主基地",
                    entryPluralLabel = "主基地",
                    label = "主基地区域",
                },
                presetTerritories = {
                    label = "预设区域",
                    entryLabel = "预设区域",
                    entryPluralLabel = "预设区域",
                },
                customTerritories = {
                    label = "自定义领地",
                    entryLabel = "自定义领地",
                    entryPluralLabel = "自定义领地",
                },
                objectsSection = {
                    label = "审讯道具",
                    entryLabel = "道具",
                    entryPluralLabel = "审讯道具",
                },
                blockedZonesSection = {
                    label = "禁区",
                    entryLabel = "区域",
                    entryPluralLabel = "禁区",
                },
                toolsSection = {
                    label = "工具",
                    entryLabel = "工具",
                    entryPluralLabel = "工具",
                },
                sessionsSection = {
                    label = "进行中的审讯",
                    entryLabel = "审讯",
                    entryPluralLabel = "进行中的审讯",
                },
                orphansSection = {
                    label = "孤立对象",
                    entryLabel = "道具",
                    entryPluralLabel = "孤立对象",
                },
            },
            darknetActions = {
                currentLocation = "使用当前位置",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "较高的数值会使护理不善时的生长速度大幅减慢，同时保留良好的护理带来的强力加成。",
                    label = "护理反应曲线",
                },
                drugGrowthMaxMultiplier = {
                    description = "在极佳条件下达到最大生长倍率。",
                    label = "完美护理倍率",
                },
                drugGrowthMinMultiplier = {
                    description = "当植物状况极差时使用的生长倍率。",
                    label = "关键护理倍率",
                },
                drugGrowthQualityBonusMax = {
                    description = "由植物品质提供的最大额外生长加成。",
                    label = "品质生长加成",
                },
            },
            errors = {
                invalid_role_permission_defaults = "请为职级权限选择有效的最低职级。",
                base_raid_locked = "基地正在被突袭。其储藏位置和配置已被锁定。",
                base_storage_outside_zone = "所有储藏点、储物柜和劫案储藏点必须位于基地区域内。",
                base_zone_invalid_polygon = "放置至少三个互不交叉的顶点，然后检查高度 (3–200 m) 和路由桶。",
                base_zone_point_limit = "主基地区域最多支持 64 个边界点。",
                base_zone_required = "请先为该犯罪职位配置一个有效的主基地区域。",
                crime_interrogation_invalid_model = "请输入有效的物体模型。",
                crime_interrogation_invalid_coords = "请将物体放置在有效位置。",
                crime_interrogation_invalid_zone_points = "请至少放置三个有效边界点。",
                crime_interrogation_duplicate_id = "此标识符对应的物体已存在。",
                crime_interrogation_tool_invalid = "请检查工具定义。",
                crime_interrogation_tool_id_invalid = "请输入有效的工具标识符。",
                crime_interrogation_tool_label_missing = "请输入工具名称。",
                crime_interrogation_effect_missing = "请为工具配置效果。",
                crime_interrogation_effect_type_unknown = "请选择受支持的效果类型。",
                crime_interrogation_effect_status_missing = "请指定此工具影响的状态。",
                crime_interrogation_minigame_missing = "请为工具配置小游戏。",
                crime_interrogation_minigame_type_unknown = "请选择受支持的小游戏类型。",
                crime_interrogation_keys_missing = "请配置工具控制键。",
                crime_interrogation_keys_invalid = "请检查工具配置的控制键。",
                crime_interrogation_keys_duplicate = "每个工具动作和控制键只能分配一次。",
                crime_interrogation_anim_invalid = "请检查工具动画字典和片段。",
                crime_interrogation_anim_missing = "请为工具使用者配置动画。",
                crime_interrogation_occupied = "已有人员被固定在物体上。",
                crime_interrogation_not_found = "该物体已不存在。",
            },
            extensions = {
                baseZone = {
                    description = "按顺序放置 3 至 64 个边界点。最低点决定底部；高度从该点向上延伸。点位将作为草稿保存；使用“保存”来应用该区域。在突袭期间，只有区域内的储物箱、保险柜和劫案仓库在区域内是可访问的。区域外的点位不会阻止保存或开始突袭。在保存之前，现有的边界保持有效。",
                    fields = {
                        bucket = "路由桶",
                        configured = "已配置",
                        height = "高度 (米)",
                        radius = "半径 (米)",
                        x = "中心 X",
                        y = "中心 Y",
                        z = "中心 Z",
                    },
                    label = "主基地区域",
                },
                invalidSelection = "无效选择：{value}",
            },
            locationDescriptions = {
                crimeStationPosition = "此工作地点的中心点。如果“工作 → 地图标记”下已启用地图标记，则会在此显示。",
            },
            locationTypes = {
                crimeStationPosition = "位置 / 地图标记",
                heistCrafting = "劫掠任务车间",
                heistStorage = "劫案仓库",
            },
            membershipMigration = {
                cancel = "取消",
                confirm = "迁移并保存",
                message = "现有的组织成员身份将被迁移到所选的模型中。在独立模式下，常规雇佣关系保持不变。",
                title = "更改成员身份模型？",
            },
            moneywashActions = {
                currentLocation = "使用当前位置",
                invalidLocations = "请检查 ID、名称、室内选择和坐标。每个位置都需要一个唯一的 ID。",
                position = "位置",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "建造点", description = "在这些点放置兼容设备。坐标相对于所选室内原点。" },
                mwBuildNodes = "建造点",
                moneywashPublicEquipment = { label = "公共设备", description = "将洗衣机、发电机和风扇分配至公共地点的兼容建造点。" },
                mwPublicEquipment = "公共设备",
                moneywashMaterials = { label = "材料", description = "使用准确的库存物品名。重量以克计算；请在库存系统安装缺失物品。" },
                mwMaterials = "材料",
                moneywashMaterialRecipes = { label = "材料配方", description = "输入、输出和时长按单位计算，加工点使用这些配方。" },
                mwMaterialRecipes = "材料配方",
                moneywashProductionRecipes = { label = "印刷配方", description = "纸张、油墨及各阶段时长按单位计算。干燥和质检完成后才支付现金。" },
                mwProductionRecipes = "印刷配方",
                moneywashCollectors = { label = "采集点", description = "为每个采集点设置产量、工具、冷却时间和世界坐标。" },
                mwCollectors = "采集点",
                moneywashProcessors = { label = "加工点", description = "为每个加工点选择材料配方和世界坐标。" },
                mwProcessors = "加工点",

                control = "控制面板",
                editor = {
                    addBusiness = "添加企业",
                    addInterior = "添加室内",
                    advanced = "技术细节",
                    asset_ipl = "IPL：输入准确的 IPL 名称和室内位置。",
                    asset_mlo = "MLO：使用已安装室内的位置。当前访问通过企业入口进行。",
                    asset_shell = "Shell：其模型资源必须已在服务器上安装并运行。",
                    businessHelp = "为企业命名，选择其室内并设置购买价格。",
                    businessListHelp = "管理您企业的入口和购买价格。",
                    businesses = "企业",
                    capture = "在游戏中设置",
                    captureOrigin = "设置室内位置",
                    chooseInterior = "选择一个室内",
                    coordinates = "编辑坐标",
                    editSections = "设置",
                    emptyBusinessHelp = "将地图入口链接到室内。随后你的组织即可购买该空置企业。",
                    emptyBusinesses = "你的第一个企业",
                    emptyInteriorHelp = "连接一个 IPL、一个 Shell 或一个已安装的 MLO，然后设置该企业使用的点位。",
                    emptyInteriors = "你的第一个室内",
                    entranceHelp = "设置玩家购买并进入该企业的入口。",
                    freecamHelp = "自由视角：WASD 移动，Q/E 上下，Shift 加速，Ctrl 减速。鼠标右键：观察。拖动操作轴，R 旋转/移动，Enter 放置，Backspace 取消。",
                    general = "常规",
                    heading = "朝向",
                    interiorHelp = "选择室内类型及其资产。",
                    interiorListHelp = "准备空置空间。玩家将自行放置自己的机器和设备。",
                    interiors = "室内",
                    listEmpty = "暂无记录。",
                    locationTypes = "位置管理",
                    newBusiness = "新企业",
                    newInterior = "新室内",
                    noResults = "无匹配条目。",
                    notSet = "未设置",
                    offsetHelp = "输入值是相对于原点的偏移量。世界坐标显示在上方。",
                    origin = "原点",
                    originHelp = "室内位置。所有其他点均相对于此点。",
                    originRequired = "请先在“常规”下设置室内位置。",
                    outsideRange = "超出 {range} 米范围",
                    point_control = "使用操作轴将墙板移动并旋转到就绪位置。确认后的物体高度将被精确保留。在“交互 → 洗钱业务：控制面板”下切换其标记。",
                    point_entry = "玩家在此进入和离开。离开时会自动返回到他们在室外的企业入口。",
                    point_position = "此点位于企业范围之外。",
                    point_storage = "使用操作轴移动并旋转架子，直到其平放在地面上。成员在此处取用购买的设备。在“交互 → 洗钱业务：仓库”下切换其标记。",
                    points = "分数",
                    pointsHelp = "选择一个点并在游戏中直接设置。",
                    rangeNote = "在室内原点周围适用 {range} 米的范围，且无高度限制。",
                    remove = "移除",
                    repairRange = "将这些点移向更靠近室内原点的位置。",
                    saveHint = "点击顶部的“保存”以应用更改。",
                    search = "搜索 …",
                    set = "已设置",
                    teleport = "传送",
                    viewInteriors = "查看室内",
                    visit = "访问",
                    visitHint = "自由移动。按 Backspace 返回编辑器。",
                    visitTitle = "进入室内",
                },
                entry = "入口与出口",
                fields = {
                    mode = "访问模式",
                    ownerKind = "所有者类型",
                    productionEnabled = "可购买印钞扩建",
                    feePercent = "手续费 (%) / -1 = 全局",
                    storageCapacity = "库存容量（物品）",
                    maximumOrders = "每位玩家同时订单数",
                    gridPower = "电网功率 / 0 = 发电机",
                    autoService = "自动维护公共机器",
                    maximumPendingOutputs = "最大待领取款项",
                    placementRange = "放置半径（米）",
                    placementHeight = "放置高度范围（米）",
                    interiorId = "室内 ID",
                    equipmentId = "设备 ID",
                    nodeId = "建造点 ID",
                    generatorNode = "发电机点 ID",
                    maxOffset = "最大点偏移（米）",
                    maxHeight = "最大高度偏移（米）",
                    weight = "物品重量（克）",
                    inputItem = "输入材料",
                    secondItem = "第二输入材料",
                    outputItem = "输出材料",
                    requiredTool = "所需工具",
                    baseQuality = "初始质量 (%)",
                    minimumQuality = "最低质量 (%)",
                    inspectionCards = "检查卡片数",
                    inspectionPenalty = "每次错误的质量损失 (%)",
                    rejectPercent = "淘汰钞票 (%)",
                    accessoryModel = "附加模型",
                    accessoryMaximum = "最大可见附加物",
                    accessoryActiveOnly = "仅加工时显示附加物",
                    animDict = "动画字典",
                    animClip = "动画片段",
                    cooldown = "冷却时间（秒）",
                    minimum = "最少产量",
                    maximum = "最大产量",
                    productionPrice = "印钞 · 购买价格",
                    recipeId = "配方 ID",
                    inputAmount = "材料 / 每单位",
                    secondAmount = "材料 / 每单位",
                    outputAmount = "材料 / 每单位",
                    paperItem = "印刷纸",
                    inkItem = "印刷油墨",
                    paperAmount = "印刷纸 / 每单位",
                    inkAmount = "印刷油墨 / 每单位",
                    notesPerUnit = "钞票 / 每单位",
                    valuePerNote = "现金 / 钞票",
                    maximumUnits = "单位 (max.)",
                    printSeconds = "印刷 / 每单位 (秒)",
                    inspectionSeconds = "检查 / 每单位 (秒)",
                    rinseSeconds = "清洗 / 每单位 (秒)",
                    drySeconds = "干燥 / 每单位 (秒)",
                    accessoryUnit = "钞票 / 每单位",
                    accessoryX = "附加模型 · X (m)",
                    accessoryY = "附加模型 · Y (m)",
                    accessoryZ = "附加模型 · Z (m)",
                    accessoryStep = "附加模型 · Z (m)",

                    capacity = "单次循环容量",
                    controlHeading = "控制面板朝向",
                    controlHeight = "高于点位的安装高度 (m)",
                    controlModel = "墙板模型",
                    controlX = "控制面板 X",
                    controlY = "控制面板 Y",
                    controlZ = "控制面板 Z",
                    disableSets = "隐藏实体集 (用逗号分隔)",
                    enableSets = "启用的实体集 (用逗号分隔)",
                    entryX = "入口偏移 X",
                    entryY = "入口偏移 Y",
                    entryZ = "入口偏移 Z",
                    heading = "朝向",
                    id = "唯一 ID",
                    interior = "室内布局",
                    ipl = "IPL 名称",
                    kind = "类型",
                    label = "姓名",
                    model = "模型名称",
                    power = "电力单位",
                    price = "购买价格",
                    radius = "放置半径 (m)",
                    repairPrice = "维修价格 (0 = 免费)",
                    seconds = "循环持续时间 (秒)",
                    storageHeading = "储藏点朝向",
                    storageModel = "货架模型",
                    storageX = "储藏点 X",
                    storageY = "储藏点 Y",
                    storageZ = "储藏点 Z",
                    wear = "每次循环磨损 (%)",
                    x = "原点 X",
                    y = "原点 Y",
                    z = "原点 Z",
                },
                interactions = {
                    control = "洗钱业务：控制面板",
                    storage = "洗钱业务：仓库",
                },
                item = "记录",
                moneywashBucketStart = {
                    description = "将此范围专门预留给洗钱业务。更改将在下次进入时生效。",
                    label = "实例范围起点",
                },
                moneywashEquipment = {
                    description = "玩家购买并放置设备。洗衣机具有容量、持续时间和磨损属性。电力取决于发电机供应或设备需求。更改将影响新的购买。",
                    label = "可购买设备",
                },
                moneywashInteriors = {
                    description = "配置空白的 IPL、Shell 或 MLO 室内。入口、控制面板、储藏室和建造范围均相对于原点。离开后玩家将返回其企业入口。",
                    label = "室内 (IPL、Shell 或 MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "每个业务可购买的设备和维修包的最大数量。",
                    label = "设备限制",
                },
                moneywashPreviewBucketStart = {
                    description = "访问将为私人管理员实例将此值加上玩家 ID。请将其与业务和其他资源分开预留。更改将应用于下次预览。",
                    label = "预览实例范围开始",
                },
                moneywashProperties = {
                    description = "设置入口、选择室内布局并设定购买价格。已购买的商业场所将保留其保存的室内布局和陈设。",
                    label = "商业入口",
                },
                moneywashRepairShops = {
                    description = "设置维修店、传送至该处并设置服务价格。它们销售维修包并维护存放的机器。",
                    label = "商店位置",
                },
                moneywashShops = {
                    description = "为洗衣机、发电机和风扇放置商店。订单将发送至组织所选的企业。",
                    label = "商店位置",
                },
                mwEquipment = "设备商店",
                mwInteriors = "空白室内",
                mwProperties = "位置",
                mwRepairShops = "维修店",
                mwSettings = "企业设置",
                names = {
                    mwPublicLaundry = "公共洗钱点",
                    mwPaperPulp = "纸浆",
                    mwPrintingPaper = "印刷纸",
                    mwPrintingInk = "印刷油墨",
                    mwPaperRecipe = "制造印刷纸",
                    mwPrintingRecipe = "普通钞票",
                    mwPaperCollector = "纸浆采集点",
                    mwInkCollector = "油墨采集点",
                    mwPaperProcessor = "纸张加工点",
                    mwPrinter = "印刷机",
                    mwInspectionTable = "检查台",
                    mwDryingCabinet = "干燥柜",
                    mwNode1 = "1 · 清洗",
                    mwNode2 = "2 · 清洗",
                    mwNode3 = "3 · 建造点",
                    mwNode4 = "4 · 印刷",
                    mwNode5 = "5 · 检查",
                    mwNode6 = "6 · 干燥",
                    mwNode7 = "7 · 建造点",

                    mwInteriorWarehouse = "空仓库",
                },
                options = {
                    private = "私人",
                    public = "公共",
                    faction = "组织",
                    person = "角色",
                    printer = "印刷机",
                    inspection = "检查台",
                    dryer = "干燥柜",

                    fan = "风扇",
                    generator = "发电机",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "维修包",
                    shell = "Shell 模型",
                    washer = "洗衣机",
                },
                origin = "原点",
                storage = "储藏点",
            },
            settingFields = {
                cultivationLevel = "种植等级",
                cultivationTitle = "等级名称",
                cultivationRequiredXp = "所需总经验",
                cultivationAction = "操作",
                cultivationXp = "经验",
                cultivationCategory = "类别",
                cultivationEntry = "条目",
                cultivationRequiredLevel = "所需等级",
                alias = "别名",
                atmHeading = "朝向",
                atmId = "ID",
                atmModel = "ATM 型号",
                centerX = "中心 X",
                centerY = "中心 Y",
                centerZ = "中心 Z",
                deliveryMethod = "交付方式",
                description = "描述",
                enabled = "已启用",
                groupKey = "组密钥",
                id = "ID",
                itemLabel = "商品标签",
                itemName = "库存物品名称",
                knownScammer = "已知骗子",
                locationName = "位置名称",
                observerW = "观察者朝向",
                observerX = "观察者 X",
                observerY = "观察者 Y",
                observerZ = "观察者 Z",
                pedModel = "NPC Ped 模型",
                pickpocketItemChance = "概率 (%)",
                pickpocketItemMaximum = "最大金额",
                pickpocketItemMinimum = "最小金额",
                pickpocketItemName = "库存物品名称",
                quantity = "数量",
                radius = "半径",
                rating = "显示评分",
                ratingCount = "显示评分数量",
                scamChance = "交易商诈骗概率 (%)",
                shopCategory = "类别",
                shopClerkHeading = "店员朝向",
                shopClerkModel = "店员型号",
                shopClerkRequired = "需要店员",
                shopClerkX = "店员 X",
                shopClerkY = "店员 Y",
                shopClerkZ = "店员 Z",
                shopCodeEnabled = "允许使用密码开启",
                shopDrillEnabled = "允许钻孔",
                shopEnabled = "启用",
                shopHackEnabled = "允许黑客攻击",
                shopLocationId = "商店 ID",
                shopLocationLabel = "标签",
                shopRegisterId = "收银机 ID",
                shopSafeEnabled = "保险箱已启用",
                shopSafeHeading = "保险箱朝向",
                shopSafeX = "保险箱 X",
                shopSafeY = "保险箱 Y",
                shopSafeZ = "保险箱 Z",
                side = "市场端",
                spawns = "团队生成点",
                successfulTrades = "显示的成功交易",
                title = "报价标题",
                unitPrice = "单价",
                verified = "验证交易商",
                w = "朝向",
                x = "X",
                y = "是",
                z = "Z",
                shopClerkPosition = "店员位置",
                shopRegisterPosition = "收银机位置",
                shopSafePosition = "保险箱位置",
                registerId = "收银机 ID",
                registerX = "收银机 X 坐标",
                registerY = "收银机 Y 坐标",
                registerZ = "收银机 Z 坐标",
                heading = "朝向",
                captureLocation = "获取位置",
            },
            crimeDashboard = {
                jobs = "管理帮派、成员、权限和地点。",
                jobCreator = "选择一个帮派以编辑其地点和区域。",
                jobsQuestion = "在哪里编辑帮派和地点？",
                jobsAnswer = "打开 {path}，选择一个帮派，然后点击编辑。在那里可以配置其设置和地点。",
                creatorsAnswer = "可在 {path} 中找到创建工具。这些链接会打开编辑器；帮派工具需要先选择帮派。",
                missingAnswer = "可用的创建工具取决于所选资源及其设置。帮派工具从对应帮派开始。",
                creators = {
                    mainbaseZones = "选择一个帮派并配置其基地范围。",
                    presetTerritories = "查看预设区域并选择启用哪些区域。",
                    objectsSection = "管理永久放置的审讯椅和工具车。",
                    blockedZonesSection = "定义禁止放置审讯物件的区域。",
                    toolsSection = "配置审讯期间可用的工具。",
                    sessionsSection = "查看正在进行的审讯，并在需要时结束会话。",
                    orphansSection = "查看并移除废弃的审讯物件。",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "选择犯罪组织存储和管理其成员的方式。",
                },
                territories = {
                    zones = "配置“领地”中的“领地区域”设置。",
                    ownership = "配置“领地”中的“所有权”设置。",
                    decay = "配置“领地”中的“衰减”设置。",
                    presence = "配置“领地”中的“存在感”设置。",
                    activity = "配置“领地”中的“活动评分”设置。",
                    ownershipBenefits = "配置“领地”中的“所有权收益”设置。",
                },
                graffiti = {
                    general = "配置“涂鸦”中的“常规”设置。",
                    streaming = "配置“涂鸦”中的“正在渲染”设置。",
                    moderation = "配置“涂鸦”中的“审核”设置。",
                },
                pvpEvents = {
                    pvpAvailability = "控制 PvP 事件 App 是否可用及其显示位置。",
                    pvpAutomation = "配置循环事件和自动启动处理。",
                    pvpRuntime = "调整实时比赛中的请求处理、死亡和重生。",
                    pvpModes = "配置 PvP 平板电脑中预选的游戏模式。",
                    pvpArenas = "创建 PvP 事件使用的圆形区域、观察点和团队出生点。",
                    pvpLimits = "设置奖励和平板电脑历史记录限制。",
                    pvpPermissions = "将地图事件管理和财务分配给 ACE 和职位权限。",
                    pvpTakeoverRules = "控制实验室和露营地接管的可用性及参与要求。",
                    pvpTakeoverZones = "配置交互、警报和占领区域及其持续时间。",
                    pvpTakeoverMethods = "配置每种破门方式所需的时间。",
                },
                drugs = {
                    creator = "打开 Sky Crime 毒品编辑器并关闭职业配置器。",
                    creatorSettings = "配置“毒品系统”中的“编辑器设置”设置。",
                    interfaceHud = "配置“毒品系统”中的“界面位置”设置。",
                    drugsGeneral = "配置“毒品系统”中的“常规”设置。",
                    runtimeAccess = "配置“毒品系统”中的“权限与所有权”设置。",
                    runtimePayouts = "配置“毒品系统”中的“结算款”设置。",
                    runtimeDispatch = "配置“毒品系统”中的“调度与警察”设置。",
                    performanceInactiveControlIntervalMs = "性能 / 未激活 / 控制 / 间隔 / 毫秒的运行设置。",
                    performanceInteractionIdleScanIntervalMs = "性能 / 交互 / 空闲 / 扫描间隔 / 毫秒的运行设置。",
                    performanceInteractionPromptIntervalMs = "性能 / 交互 / 交互提示 / 间隔 / 毫秒的运行设置。",
                    performanceInteractionScanIntervalMs = "性能 / 交互 / 扫描间隔 / 毫秒的运行设置。",
                    performanceMinimumScanIntervalMs = "性能 / 最小值 / 扫描间隔 / 毫秒的运行设置。",
                    performanceStreetPedActivationDistance = "性能 / 街道 / 佩德 / 激活 / 距离的运行设置。",
                    performanceStreetPedIdleScanIntervalMs = "性能 / 街道 / 佩德 / 空闲 / 扫描间隔 / 毫秒的运行设置。",
                    performanceStreetPedScanIntervalMs = "性能 / 街道 / 佩德 / 扫描间隔 / 毫秒的运行设置。",
                    performanceWorldCachePadding = "性能 / 世界 / 缓存 / 额外边距的运行设置。",
                    performanceWorldCacheRefreshIntervalMs = "性能 / 世界 / 缓存 / 刷新 / 间隔 / 毫秒的运行设置。",
                    performanceWorldIdleIntervalMs = "性能 / 世界 / 空闲 / 间隔 / 毫秒的运行设置。",
                },
                drugProduction = {
                    qualityWeights = "配置“毒品生产”中的“质量 / 权重”设置。",
                    qualityTiers = "配置“毒品生产”中的“质量 / 品质等级”设置。",
                    packagingGeneral = "配置“毒品生产”中的“常规”设置。",
                    processingFlow = "配置“毒品生产”中的“加工流程”设置。",
                    processingGeneral = "配置“毒品生产”中的“常规”设置。",
                },
                drugOperations = {
                    growingGeneral = "配置“毒品经营”中的“常规”设置。",
                    plantDefaults = "配置“毒品经营”中的“植物 / 默认值”设置。",
                    harvestWindow = "配置“毒品经营”中的“收获 / 时间窗口”设置。",
                    labsGeneral = "启用：实验室与房车的游戏运行功能。",
                    labRent = "配置“毒品经营”中的“租赁与生命周期”设置。",
                    camperDefaults = "配置“毒品经营”中的“房车”设置。",
                    labUpgrades = "实验室 / 等级 / 升级 / 价格的倍率。",
                    labDefaults = "配置“毒品经营”中的“实验室 / 默认值”设置。",
                    powerGeneral = "配置“毒品经营”中的“常规”设置。",
                    generators = "配置“毒品经营”中的“发电机”设置。",
                    equipmentWear = "设备磨损 / 加工的全局倍率。",
                    workersGeneral = "配置“毒品经营”中的“常规”设置。",
                    cultivationGeneral = "配置“毒品经营”中的“常规”设置。",
                    cultivationCurve = "配置每个种植等级的名称和所需总经验。",
                    cultivationExperience = "配置每种植操作获得的种植经验。",
                    cultivationUnlocks = "配置容器、基质、设备、品种和扫描器层级所需的种植等级。",
                    powerRuntime = "发电机消耗与用电特征更新的间隔，单位为秒。",
                    powerHeat = "配置“毒品经营”中的“警方关注与用电特征”设置。",
                    powerModes = "配置“毒品经营”中的“管理 / 模式”设置。",
                    powerPriorities = "配置“毒品经营”中的“负载 / 优先级”设置。",
                },
                drugMarketRisk = {
                    marketGeneral = "配置“市场与风险”中的“常规”设置。",
                    marketPrices = "配置“市场与风险”中的“价格”设置。",
                    distribution = "配置“市场与风险”中的“分销”设置。",
                    threatsGeneral = "配置“市场与风险”中的“常规”设置。",
                    threatHeat = "配置“市场与风险”中的“警方关注度”设置。",
                    threatChances = "配置“市场与风险”中的“概率”设置。",
                    consumptionGeneral = "配置“市场与风险”中的“常规”设置。",
                    consumerDecay = "配置“市场与风险”中的“耐受与成瘾消退”设置。",
                    consumerEffects = "配置“市场与风险”中的“效果与风险”设置。",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "动态市场 / 动作冷却时间 / 秒的运行设置。",
                    dynamicMarketActionHistoryLimit = "动态市场 / 行动 / 历史记录上限的运行设置。",
                    dynamicMarketAmountSaturationWeight = "动态市场 / 数量 / 饱和度 / 权重的运行设置。",
                    dynamicMarketBaseIntelAccuracy = "动态市场 / 基础值 / 情报准确度的运行设置。",
                    dynamicMarketDefaultAverageQuality = "动态市场 / 默认值 / 平均值 / 质量的运行设置。",
                    dynamicMarketDefaultResourceElasticity = "动态市场 / 默认值 / 资源 / 弹性的运行设置。",
                    dynamicMarketDemandCenter = "动态市场 / 需求 / 中心值的运行设置。",
                    dynamicMarketDemandPriceImpact = "动态市场 / 需求 / 价格 / 影响的运行设置。",
                    dynamicMarketDirectionThreshold = "动态市场 / 方向 / 阈值的运行设置。",
                    dynamicMarketEnabled = "动态市场 / 启用的运行设置。",
                    dynamicMarketEventChance = "动态市场 / 事件 / 概率的运行设置。",
                    dynamicMarketEventDurationMinutes = "动态市场 / 事件 / 时长 / 分钟的运行设置。",
                    dynamicMarketEventMinimumDurationMinutes = "动态市场 / 事件 / 最小值 / 时长 / 分钟的运行设置。",
                    dynamicMarketEventStrengthMaximum = "动态市场 / 事件 / 强度 / 最大值的运行设置。",
                    dynamicMarketEventStrengthMinimum = "动态市场 / 事件 / 强度 / 最小值的运行设置。",
                    dynamicMarketEvents = "配置“毒品网络”中的“活动”设置。",
                    dynamicMarketExactIntelReputation = "动态市场 / 精确情报 / 声望的运行设置。",
                    dynamicMarketExactIntelTrust = "动态市场 / 精确情报 / 信任的运行设置。",
                    dynamicMarketGlobalZoneLabel = "动态市场 / 全球的 / 区域 / 标签的运行设置。",
                    dynamicMarketHistoryLimit = "动态市场 / 历史记录上限的运行设置。",
                    dynamicMarketInitialDemand = "动态市场 / 初始值 / 需求的运行设置。",
                    dynamicMarketInitialPriceMultiplier = "动态市场 / 初始值 / 价格倍数的运行设置。",
                    dynamicMarketIntelDemandError = "动态市场 / 情报 / 需求 / 错误的运行设置。",
                    dynamicMarketIntelMaximumAccuracy = "动态市场 / 情报 / 最大值 / 准确度的运行设置。",
                    dynamicMarketIntelMinimumAccuracy = "动态市场 / 情报 / 最小值 / 准确度的运行设置。",
                    dynamicMarketIntelPoliceError = "动态市场 / 情报 / 警察 / 错误的运行设置。",
                    dynamicMarketIntelPriceError = "动态市场 / 情报 / 价格 / 错误的运行设置。",
                    dynamicMarketIntelPriceMaximum = "动态市场 / 情报 / 价格 / 最大值的运行设置。",
                    dynamicMarketIntelPriceMinimum = "动态市场 / 情报 / 价格 / 最小值的运行设置。",
                    dynamicMarketIntelReputationWeight = "动态市场 / 情报 / 声望 / 权重的运行设置。",
                    dynamicMarketIntelResourcePriceError = "动态市场 / 情报 / 资源 / 价格 / 错误的运行设置。",
                    dynamicMarketIntelSaturationError = "动态市场 / 情报 / 饱和度 / 错误的运行设置。",
                    dynamicMarketIntelSeedBucketSeconds = "动态市场 / 情报随机种子窗口 / 秒的运行设置。",
                    dynamicMarketIntelStatusAccuracyThreshold = "动态市场 / 情报 / 状态 / 准确度 / 阈值的运行设置。",
                    dynamicMarketIntelStatusErrorThreshold = "动态市场 / 情报 / 状态 / 错误 / 阈值的运行设置。",
                    dynamicMarketIntelSupplyError = "动态市场 / 情报 / 供应 / 错误的运行设置。",
                    dynamicMarketIntelTrustWeight = "动态市场 / 情报 / 信任 / 权重的运行设置。",
                    dynamicMarketManipulationCooldownMinutes = "动态市场 / 操纵 / 冷却分钟数的运行设置。",
                    dynamicMarketManipulationDemandShift = "动态市场 / 操纵 / 需求 / 偏移的运行设置。",
                    dynamicMarketManipulationDurationMinutes = "动态市场 / 操纵 / 时长 / 分钟的运行设置。",
                    dynamicMarketManipulationHeat = "动态市场 / 操纵 / 警方关注度的运行设置。",
                    dynamicMarketManipulationMinimumBatchAmount = "动态市场 / 操纵 / 最小值 / 批次 / 数量的运行设置。",
                    dynamicMarketManipulationPaymentAccount = "动态市场 / 操纵 / 付款账户的运行设置。",
                    dynamicMarketManipulationPrice = "动态市场 / 操纵 / 价格的运行设置。",
                    dynamicMarketManipulationZoneHeatMultiplier = "动态市场 / 操纵 / 区域 / 警方关注度 / 倍率的运行设置。",
                    dynamicMarketMaximumIntelAgeMinutes = "动态市场 / 最大值 / 情报时效 / 分钟的运行设置。",
                    dynamicMarketMaximumPriceMultiplier = "动态市场 / 最大值 / 价格倍数的运行设置。",
                    dynamicMarketMinimumIntelAgeMinutes = "动态市场 / 最小值 / 情报时效 / 分钟的运行设置。",
                    dynamicMarketMinimumMetricWindowMinutes = "动态市场 / 最小值 / 指标 / 时间窗口 / 分钟的运行设置。",
                    dynamicMarketMinimumPriceMultiplier = "动态市场 / 最低价格 / 倍率的运行设置。",
                    dynamicMarketMinimumUpdateMinutes = "动态市场 / 最小值 / 更新 / 分钟的运行设置。",
                    dynamicMarketPoliceDemandWeight = "动态市场 / 警察 / 需求 / 权重的运行设置。",
                    dynamicMarketPolicePriceImpact = "动态市场 / 警察 / 价格 / 影响的运行设置。",
                    dynamicMarketPoorQualityDemandPenalty = "动态市场 / 低质量 / 需求 / 惩罚的运行设置。",
                    dynamicMarketPoorQualityThreshold = "动态市场 / 低质量 / 阈值的运行设置。",
                    dynamicMarketPremiumQualityDemandBonus = "动态市场 / 优质质量 / 需求加成的运行设置。",
                    dynamicMarketPremiumQualityThreshold = "动态市场 / 优质质量 / 阈值的运行设置。",
                    dynamicMarketProductionSupplyWeight = "动态市场 / 生产 / 供应 / 权重的运行设置。",
                    dynamicMarketProductionWindowMinutes = "动态市场 / 生产 / 时间窗口 / 分钟的运行设置。",
                    dynamicMarketQualityCenter = "动态市场 / 质量 / 中心值的运行设置。",
                    dynamicMarketQualityConfidenceImpact = "动态市场 / 质量 / 信心 / 影响的运行设置。",
                    dynamicMarketQualityRange = "动态市场 / 质量 / 数值范围的运行设置。",
                    dynamicMarketRarityBonusMaximum = "动态市场 / 稀有度 / 奖金 / 最大值的运行设置。",
                    dynamicMarketRegionalGlobalWeight = "动态市场 / 地区性 / 全球的 / 权重的运行设置。",
                    dynamicMarketRegionalLocalWeight = "动态市场 / 地区性 / 本地 / 权重的运行设置。",
                    dynamicMarketResourceAliases = "配置“毒品网络”中的“资源 / 别名”设置。",
                    dynamicMarketResourceDirectionFallThreshold = "动态市场 / 资源 / 方向 / 下降 / 阈值的运行设置。",
                    dynamicMarketResourceDirectionRiseThreshold = "动态市场 / 资源 / 方向 / 上升 / 阈值的运行设置。",
                    dynamicMarketResources = "配置“毒品网络”中的“资源”设置。",
                    dynamicMarketSalesWindowMinutes = "动态市场 / 销售 / 时间窗口 / 分钟的运行设置。",
                    dynamicMarketSaturationDemandWeight = "动态市场 / 饱和度 / 需求 / 权重的运行设置。",
                    dynamicMarketSaturationPriceImpact = "动态市场 / 饱和度 / 价格 / 影响的运行设置。",
                    dynamicMarketScarcityDemandWeight = "动态市场 / 稀缺程度 / 需求 / 权重的运行设置。",
                    dynamicMarketScarcityPriceImpact = "动态市场 / 稀缺程度 / 价格 / 影响的运行设置。",
                    dynamicMarketSeasonEndMonths = "配置“毒品网络”中的“季节 / 结束 / 月份”设置。",
                    dynamicMarketSeasonMultipliers = "配置“毒品网络”中的“季节 / 倍率”设置。",
                    dynamicMarketShortageRumorThreshold = "动态市场 / 短缺 / 传闻 / 阈值的运行设置。",
                    dynamicMarketStatusThresholds = "配置“毒品网络”中的“状态 / 阈值”设置。",
                    dynamicMarketTargetSupply = "动态市场 / 目标 / 供应的运行设置。",
                    dynamicMarketTrendChance = "动态市场 / 趋势 / 概率的运行设置。",
                    dynamicMarketTrendDurationMinutes = "动态市场 / 趋势 / 时长 / 分钟的运行设置。",
                    dynamicMarketTrendMaximumStrength = "动态市场 / 趋势 / 最大值 / 强度的运行设置。",
                    dynamicMarketTrendMinimumStrength = "动态市场 / 趋势 / 最小值 / 强度的运行设置。",
                    dynamicMarketUpdateMinutes = "动态市场 / 更新 / 分钟的运行设置。",
                    dynamicMarketVolatilityMaximum = "动态市场 / 价格波动 / 最大值的运行设置。",
                    dynamicMarketVolatilityMinimum = "动态市场 / 价格波动 / 最小值的运行设置。",
                    dynamicMarketWeatherMultipliers = "配置“毒品网络”中的“天气 / 倍率”设置。",
                    dynamicMarketWeatherState = "动态市场 / 天气 / 状态的运行设置。",
                    heatActionCooldownSeconds = "警方关注与风险 / 动作冷却时间 / 秒的运行设置。",
                    heatActivityRiskWeights = "配置“毒品网络”中的“活动 / 风险 / 权重”设置。",
                    heatAggressiveHeatMultiplier = "警方关注与风险 / 激进模式 / 警方关注度 / 倍率的运行设置。",
                    heatBurnerBurnThreshold = "警方关注与风险 / 一次性手机 / 暴露 / 阈值的运行设置。",
                    heatBurnerHeatPerWholesale = "警方关注与风险 / 一次性手机 / 警方关注度 / 每笔批发交易的运行设置。",
                    heatBurnerPhoneItem = "警方关注与风险 / 一次性手机 / 物品的运行设置。",
                    heatCamperOperationalHeatMultiplier = "警方关注与风险 / 运行中的房车 / 警方关注度 / 倍率的运行设置。",
                    heatCamperOperationalHeatThreshold = "警方关注与风险 / 运行中的房车 / 警方关注度 / 阈值的运行设置。",
                    heatCamperParkedHeat = "警方关注与风险 / 停放中的房车 / 警方关注度的运行设置。",
                    heatContaminatedHeatMultiplier = "警方关注与风险 / 污染 / 警方关注度 / 倍率的运行设置。",
                    heatContaminatedThreshold = "警方关注与风险 / 污染 / 阈值的运行设置。",
                    heatCultivationFreePlants = "警方关注与风险 / 种植 / 不增加风险的植物的运行设置。",
                    heatCultivationHeatPerPlant = "警方关注与风险 / 种植 / 警方关注度 / 每株植物的运行设置。",
                    heatDealerHiddenMinutes = "警方关注与风险 / 经销商 / 隐藏 / 分钟的运行设置。",
                    heatDecayPerTick = "配置“毒品网络”中的“衰减 / 每次更新”设置。",
                    heatEnabled = "警方关注与风险 / 启用的运行设置。",
                    heatEnforcementHeat = "配置“毒品网络”中的“警方存在 / 警方关注度”设置。",
                    heatEnforcementMultipliers = "配置“毒品网络”中的“警方存在 / 倍率”设置。",
                    heatEntityTypes = "配置“毒品网络”中的“游戏实体 / 类型”设置。",
                    heatEventCooldownMinutes = "警方关注与风险 / 事件 / 冷却分钟数的运行设置。",
                    heatEventHistoryLimit = "警方关注与风险 / 事件 / 历史记录上限的运行设置。",
                    heatLabHeatSyncThreshold = "警方关注与风险 / 实验室 / 警方关注度 / 同步 / 阈值的运行设置。",
                    heatLayLowCooldownMinutes = "警方关注与风险 / 避风头 / 冷却分钟数的运行设置。",
                    heatLayLowIdleMinutes = "警方关注与风险 / 避风头 / 空闲 / 分钟的运行设置。",
                    heatLayLowReduction = "警方关注与风险 / 避风头 / 减少量的运行设置。",
                    heatLockdownMinutes = "警方关注与风险 / 封锁 / 分钟的运行设置。",
                    heatMinimumDurationMinutes = "警方关注与风险 / 最小值 / 时长 / 分钟的运行设置。",
                    heatMinimumEventCooldownSeconds = "警方关注与风险 / 最小值 / 事件 / 冷却时间（秒）的运行设置。",
                    heatMinimumIdleSeconds = "警方关注与风险 / 最小值 / 空闲 / 秒的运行设置。",
                    heatProcessingHeatMultiplier = "警方关注与风险 / 加工 / 警方关注度 / 倍率的运行设置。",
                    heatRiskWeights = "配置“毒品网络”中的“风险 / 权重”设置。",
                    heatRotateBurnerReduction = "警方关注与风险 / 更换一次性手机 / 减少量的运行设置。",
                    heatRouteControlMinutes = "警方关注与风险 / 路线 / 控制 / 分钟的运行设置。",
                    heatSaleHeat = "配置“毒品网络”中的“销售 / 警方关注度”设置。",
                    heatThresholds = "配置“毒品网络”中的“阈值”设置。",
                    heatTickMinutes = "警方关注与风险 / 更新周期 / 分钟的运行设置。",
                    heatWholesaleHeatMultiplier = "警方关注与风险 / 批发 / 警方关注度 / 倍率的运行设置。",
                    heatWorkerLeakAlertRadius = "警方关注与风险 / 工人 / 信息泄露 / 警报半径的运行设置。",
                    heatWorkerLeakBaseChance = "警方关注与风险 / 工人 / 信息泄露 / 基础值 / 概率的运行设置。",
                    heatWorkerLeakFactionMultiplier = "警方关注与风险 / 工人 / 信息泄露 / 帮派 / 倍率的运行设置。",
                    heatWorkerLeakHighSeverityThreshold = "警方关注与风险 / 工人 / 信息泄露 / 高 / 严重程度 / 阈值的运行设置。",
                    heatWorkerLeakLoyaltyChanceMultiplier = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 概率 / 倍率的运行设置。",
                    heatWorkerLeakLoyaltyThreshold = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 阈值的运行设置。",
                    heatWorkerLeakMaximumChance = "警方关注与风险 / 工人 / 信息泄露 / 最大值 / 概率的运行设置。",
                    heatWorkerLeakMinimumCooldownSeconds = "警方关注与风险 / 工人 / 信息泄露 / 最小值 / 冷却时间（秒）的运行设置。",
                    heatWorkerLeakRouteMultiplier = "警方关注与风险 / 工人 / 信息泄露 / 路线 / 倍率的运行设置。",
                    heatWorkerLeakStrengthMaximum = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最大值的运行设置。",
                    heatWorkerLeakStrengthMinimum = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最小值的运行设置。",
                    heatWorkerLeakStrengthMultiplier = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 倍率的运行设置。",
                    heatWorkerLeakStressChanceMultiplier = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 概率 / 倍率的运行设置。",
                    heatWorkerLeakStressThreshold = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 阈值的运行设置。",
                    contactsActionCooldownSeconds = "联系人网络 / 动作冷却时间 / 秒的运行设置。",
                    contactsActiveHotspotCount = "联系人网络 / 活跃热点数量的运行设置。",
                    contactsBurnerHintTrust = "联系人网络 / 临时手机提示 / 信任的运行设置。",
                    contactsBurnerOfferMaximumMultiplier = "联系人网络 / 一次性手机 / 报价 / 最大值 / 倍率的运行设置。",
                    contactsBurnerOfferMinimumMultiplier = "联系人网络 / 一次性手机 / 报价 / 最小值 / 倍率的运行设置。",
                    contactsBuyerCooldownMinutes = "联系人网络 / 买家 / 冷却分钟数的运行设置。",
                    contactsBuyerDeliveryDistance = "联系人网络 / 买家 / 送达距离的运行设置。",
                    contactsBuyerPremiumSuccessScore = "联系人网络 / 买家 / 高级 / 成功 / 分数的运行设置。",
                    contactsBuyerPremiumTrustGain = "联系人网络 / 买家 / 高级 / 信任 / 增益的运行设置。",
                    contactsBuyerRequestHeatRiskWeight = "联系人网络 / 买家 / 请求 / 热度与风险 / 权重的运行设置。",
                    contactsBuyerStandardTrustGain = "联系人网络 / 买家 / 标准型 / 信任 / 增益的运行设置。",
                    contactsContactActiveDelaySeconds = "配置“毒品网络”中的“联系人激活延迟 / 秒”设置。",
                    contactsContactDemandRange = "配置“毒品网络”中的“联系方式 / 需求 / 数值范围”设置。",
                    contactsContactLossTrust = "联系人网络 / 联系方式 / 亏损 / 信任的运行设置。",
                    contactsDarknetExactIntelMinutes = "联系人网络 / 暗网 / 精确情报 / 分钟的运行设置。",
                    contactsDarknetHotspotIntelPrice = "联系人网络 / 暗网 / 热点 / 情报 / 价格的运行设置。",
                    contactsDarknetIntelPrice = "联系人网络 / 暗网 / 情报 / 价格的运行设置。",
                    contactsDealerBasePrice = "联系人网络 / 经销商 / 基础价格的运行设置。",
                    contactsDealerHireCapacity = "配置“毒品网络”中的“经销商 / 雇用 / 容量”设置。",
                    contactsDealerHireRisk = "配置“毒品网络”中的“经销商 / 雇用 / 风险”设置。",
                    contactsDealerHireSkill = "配置“毒品网络”中的“经销商 / 雇用 / 技能”设置。",
                    contactsDealerOffers = "配置“毒品网络”中的“经销商报价”设置。",
                    contactsDealerProtectionHours = "联系人网络 / 经销商 / 保护 / 小时的运行设置。",
                    contactsDealerProtectionPrice = "联系人网络 / 经销商 / 保护 / 价格的运行设置。",
                    contactsDealerSaleMax = "联系人网络 / 经销商 / 销售 / 最大值的运行设置。",
                    contactsDealerSaleMin = "联系人网络 / 经销商 / 销售 / 最小值的运行设置。",
                    contactsDealerSimulation = "配置“毒品网络”中的“经销商 / 模拟”设置。",
                    contactsDealerTickMinutes = "联系人网络 / 经销商 / 更新周期 / 分钟的运行设置。",
                    contactsDealerWage = "联系人网络 / 经销商 / 工资的运行设置。",
                    contactsDealerWageDecay = "联系人网络 / 经销商 / 工资 / 衰减的运行设置。",
                    contactsDealerWageLoyaltyGain = "联系人网络 / 经销商 / 工资 / 忠诚度 / 增益的运行设置。",
                    contactsDealerWeaknesses = "配置“毒品网络”中的“经销商 / 弱点”设置。",
                    contactsDefaultContactDemand = "联系人网络 / 默认值 / 联系方式 / 需求的运行设置。",
                    contactsDefaultContactRisk = "联系人网络 / 默认值 / 联系方式 / 风险的运行设置。",
                    contactsDefaultDealerCapacity = "联系人网络 / 默认贩子 / 容量的运行设置。",
                    contactsDefaultDealerRisk = "联系人网络 / 默认贩子 / 风险的运行设置。",
                    contactsDefaultDealerSkill = "联系人网络 / 默认贩子 / 技能的运行设置。",
                    contactsDefaultHotspotRadius = "联系人网络 / 默认值 / 热点 / 半径的运行设置。",
                    contactsDemandResetMinutes = "联系人网络 / 需求重置（分钟）的运行设置。",
                    contactsEnabled = "联系人网络 / 启用的运行设置。",
                    contactsExactLocationTrust = "联系人网络 / 精确位置 / 信任的运行设置。",
                    contactsFactionDiscoveryReputation = "联系人网络 / 帮派 / 发现 / 声望的运行设置。",
                    contactsFactionHintTrust = "联系人网络 / 帮派 / 线索 / 信任的运行设置。",
                    contactsFailedDeliveryCooldownMinutes = "联系人网络 / 交付失败 / 冷却分钟数的运行设置。",
                    contactsFakeDealEncounter = "配置“毒品网络”中的“虚假交易 / 遭遇”设置。",
                    contactsFallbackPreferredDrug = "联系人网络 / 备用值 / 首选毒品的运行设置。",
                    contactsFallbackProductLabel = "联系人网络 / 备用值 / 产品名称的运行设置。",
                    contactsGuideBookItem = "联系人网络 / 指南 / 书籍 / 物品的运行设置。",
                    contactsGuideBookTrust = "联系人网络 / 指南 / 书籍 / 信任的运行设置。",
                    contactsHireDealerPrice = "联系人网络 / 雇佣代理商 / 价格的运行设置。",
                    contactsHistoryLimit = "联系人网络 / 历史记录上限的运行设置。",
                    contactsHotspotIntelMinutes = "联系人网络 / 热点 / 情报 / 分钟的运行设置。",
                    contactsHotspotRotationMinutes = "联系人网络 / 热点 / 轮换 / 分钟的运行设置。",
                    contactsListingDurationMinutes = "联系人网络 / 上架商品 / 时长 / 分钟的运行设置。",
                    contactsMaxOwnedDealers = "联系人网络 / 最大值 / 已持有 / 毒贩的运行设置。",
                    contactsMinimumBuyerDeliveryDistance = "联系人网络 / 最小值 / 买家 / 送达距离的运行设置。",
                    contactsMinimumContactRotationMinutes = "联系人网络 / 最小值 / 接触轮换（分钟）的运行设置。",
                    contactsMinimumDemandResetMinutes = "联系人网络 / 最小值 / 需求重置（分钟）的运行设置。",
                    contactsMinimumHeatMultiplier = "联系人网络 / 最小值 / 警方关注度 / 倍率的运行设置。",
                    contactsMinimumHotspotIntelMinutes = "联系人网络 / 最小值 / 热点 / 情报 / 分钟的运行设置。",
                    contactsMinimumHotspotRadius = "联系人网络 / 最小值 / 热点 / 半径的运行设置。",
                    contactsMinimumHotspotRotationMinutes = "联系人网络 / 最小值 / 热点 / 轮换 / 分钟的运行设置。",
                    contactsMinimumListingDurationMinutes = "联系人网络 / 最小值 / 上架商品 / 时长 / 分钟的运行设置。",
                    contactsMinimumRewardMultiplier = "联系人网络 / 最低奖励 / 倍率的运行设置。",
                    contactsMinimumRobberyMultiplier = "联系人网络 / 最小值 / 抢劫 / 倍率的运行设置。",
                    contactsMinimumSpotPriceMultiplier = "联系人网络 / 最小值 / 地点 / 价格倍数的运行设置。",
                    contactsOtherDrugPriceMultiplier = "联系人网络 / 其他 / 毒品 / 价格倍数的运行设置。",
                    contactsPaymentAccount = "联系人网络 / 付款账户的运行设置。",
                    contactsPostDeliveryDemandResetSeconds = "联系人网络 / 交付后 / 需求 / Reset / 秒的运行设置。",
                    contactsPreferredDrugPriceMultiplier = "联系人网络 / 首选毒品 / 价格倍数的运行设置。",
                    contactsRegionLocationTrust = "联系人网络 / 地区 / 地点 / 信任的运行设置。",
                    contactsRequestAmounts = "配置“毒品网络”中的“请求 / 数量”设置。",
                    contactsRotationMinutes = "联系人网络 / 轮换 / 分钟的运行设置。",
                    contactsSpotPools = "配置“毒品网络”中的“地点 / 候选池”设置。",
                    contactsStreetHotspots = "配置“毒品网络”中的“街道 / 热点”设置。",
                    contactsTrustLevels = "配置“毒品网络”中的“信任 / 等级”设置。",
                    businessActionCooldownSeconds = "商业网络 / 动作冷却时间 / 秒的运行设置。",
                    businessBalance = "配置“毒品网络”中的“余额”设置。",
                    businessContracts = "配置“毒品网络”中的“合同”设置。",
                    businessDefaultBusinessName = "商业网络 / 默认值 / 业务名称的运行设置。",
                    businessDefaultRankId = "商业网络 / 默认值 / 等级 / ID的运行设置。",
                    businessDefaultStaffStyle = "商业网络 / 默认值 / 工作人员 / 工作方式的运行设置。",
                    businessDefaultTransport = "商业网络 / 默认值 / 运输的运行设置。",
                    businessEnabled = "商业网络 / 启用的运行设置。",
                    businessHubs = "配置“毒品网络”中的“分销中心”设置。",
                    businessLimits = "配置“毒品网络”中的“限制”设置。",
                    businessPayments = "选择哪个余额用于支付商业网络采购及运营成本。",
                    businessPayoutAccount = "商业网络 / 付款 / 账户的运行设置。",
                    businessRanks = "配置“毒品网络”中的“职级”设置。",
                    businessReportDays = "商业网络 / 报告周期 / 天的运行设置。",
                    businessRouteEndpointTypes = "配置“毒品网络”中的“路线 / 终点 / 类型”设置。",
                    businessRuntime = "配置“毒品网络”中的“游戏运行”设置。",
                    businessSocietyPermission = "商业网络 / 组织 / 权限的运行设置。",
                    businessStaff = "配置“毒品网络”中的“工作人员”设置。",
                    businessTickMinutes = "商业网络 / 更新周期 / 分钟的运行设置。",
                    businessTransports = "配置“毒品网络”中的“运输”设置。",
                },
                robbery = {
                    atmAvailability = "启用或禁用独立的 ATM 抢劫系统。",
                    atmLocations = "管理服务器授权的、可用于抢劫的 ATM 位置。",
                    atmPolice = "配置开始抢劫所需的在岗警察人数。",
                    atmItems = "设置所需的钻机、拖拽带和炸药物品。",
                    atmActionTimes = "设置安装、放置、引爆和搜刮行动的持续时间。",
                    atmTimeouts = "控制被撬开的 ATM 可供搜刮的时长。",
                    atmPayout = "配置目标账户和随机奖励范围。",
                    atmDistances = "设置 ATM 交互时玩家和车辆的范围。",
                    atmExplosionEffects = "配置爆炸发生时使用的原生爆炸参数。",
                    atmDispatchAlert = "配置警方警报的半径、持续时间和优先级。",
                    atmDispatchRecipients = "选择哪些工作可以接收 ATM 抢劫警报。",
                    shopAvailability = "启用抢劫并配置警方要求。",
                    shopTiming = "配置威慑、行动、超时和冷却时间。",
                    shopSafe = "配置密码输入尝试次数和电钻道具。",
                    shopRegisterReward = "配置每个收银机（register）的随机奖励。",
                    shopSafeReward = "配置随机保险箱奖励。",
                    shopDispatchSettings = "配置接收者和警报属性。",
                    shopLocationTable = "管理有店员的零售场所和保险箱。",
                    pickpocketAvailability = "启用此功能，并可选择性地将其限制在配置的犯罪职位内。",
                    pickpocketGameplay = "选择挑战难度以及独立的逃跑、报警和反击概率。",
                    pickpocketItemRewards = "控制空口袋和可见物品的选择，精确至 0.0001 百分比。",
                    pickpocketMoney = "配置服务器生成的随机现金范围。",
                    pickpocketDistances = "设置共享径向菜单和目标系统所使用的 NPC 范围。",
                    pickpocketRateLimits = "控制请求节流、单个 NPC 的冷却时间以及会话过期。",
                    pickpocketDispatchSettings = "配置 NPC 拨打紧急服务时发送的警报。",
                    heistCrafting = "选择制作劫掠装备所需的交互程度。适用于整个犯罪系统中的新尝试。",
                    heistCreatorMenu = "在专属的劫案策划器中创建、编辑和发布模块化劫案。",
                    heistExecution = "劫掠行动的开始窗口、不活跃时间及冷却时间。",
                    npcPoliceSupport = "武装的 NPC 警员会徒步响应抢劫警报，并通过交火对抗劫匪来支援警方。",
                },
                baseRaids = {
                    baseRaids = "突袭权限、要求及可单独选择的战利品类别。开放式突袭没有运输时间限制。",
                },
                weapons = {
                    weaponCreatorMenu = "在一个创建器中管理武器路线和洗钱业务。",
                    weaponRuntime = "控制武器路线的可用性和访问权限。",
                    weaponDefaultsgeneral = "配置“武器路线”中的“通用默认值”设置。",
                    weaponDefaultsaccess = "配置“武器路线”中的“访问默认值”设置。",
                    weaponDefaultscollection = "配置“武器路线”中的“采集默认值”设置。",
                    weaponDefaultsproduction = "配置“武器路线”中的“生产默认值”设置。",
                    weaponDefaultsmarket = "配置“武器路线”中的“市场默认值”设置。",
                    weaponDefaultsdelivery = "配置“武器路线”中的“订单默认值”设置。",
                    weaponStreet = "配置“武器路线”中的“街头武器销售”设置。",
                },
                darknetMarket = {
                    darknetAvailability = "控制平板电脑应用及其放置位置。",
                    darknetEconomy = "配置钱包余额、代币兑换和支付汇率。",
                    darknetListings = "控制广告限制、价格和自动过期。",
                    darknetChat = "限制加密市场消息。",
                    darknetIdentity = "配置身份轮换、验证和诈骗警告。",
                    darknetDelivery = "配置线下会面和可窃取的地图箱子。",
                    darknetDeliveryLocations = "配置 BlackBay NPC 交易时随机分配的地点池。",
                    darknetPolice = "允许发布陷阱和查看调查的职位组。",
                    darknetNpcTraders = "具有可配置风险的持久 NPC 买家和卖家。",
                },
                interrogation = {
                    general = "配置“审讯”中的“常规”设置。",
                    consent = "配置“审讯”中的“玩家保护”设置。",
                    objects = "配置“审讯”中的“对象”设置。",
                    grab = "配置“审讯”中的“制服”设置。",
                    session = "配置“审讯”中的“环节”设置。",
                    dispatch = "配置“审讯”中的“警方警报”设置。",
                    logging = "配置“审讯”中的“日志记录”设置。",
                    security = "配置“审讯”中的“安全”设置。",
                    presentation = "配置“审讯”中的“展示界面”设置。",
                },
                reputation = {
                    crimeReputation = "配置“声望”中的“声望”设置。",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "常规", description = "控制武器路线的可用性和访问权限。" },
                weaponCreatorMenu = { label = "非法商业非法制造者", description = "在一个创建器中管理武器路线和洗钱业务。" },
                atmActionTimes = {
                    description = "设置安装、放置、引爆和搜刮行动的持续时间。",
                    label = "行动持续时间",
                },
                atmAvailability = {
                    description = "启用或禁用独立的 ATM 抢劫系统。",
                    label = "可用性",
                },
                atmDispatchAlert = {
                    description = "配置警方警报的半径、持续时间和优先级。",
                    label = "警报属性",
                },
                atmDispatchRecipients = {
                    description = "选择哪些工作可以接收 ATM 抢劫警报。",
                    label = "接收者",
                },
                atmDistances = {
                    description = "设置 ATM 交互时玩家和车辆的范围。",
                    label = "交互距离",
                },
                atmExplosionEffects = {
                    description = "配置爆炸发生时使用的原生爆炸参数。",
                    label = "爆炸效果",
                },
                atmItems = {
                    description = "设置所需的钻机、拖拽带和炸药物品。",
                    label = "所需物品",
                },
                atmLocations = {
                    description = "管理服务器授权的、可用于抢劫的 ATM 位置。",
                    label = "ATM 位置",
                },
                atmPayout = {
                    description = "配置目标账户和随机奖励范围。",
                    label = "付款",
                },
                atmPolice = {
                    description = "配置开始抢劫所需的在岗警察人数。",
                    label = "警方要求",
                },
                atmPulling = {
                    description = "配置将 ATM 从墙上扯下所需的移动量。",
                    label = "拉拽检测",
                },
                atmTimeouts = {
                    description = "控制被撬开的 ATM 可供搜刮的时长。",
                    label = "搜刮超时",
                },
                baseRaids = {
                    description = "突袭权限、要求及可单独选择的战利品类别。开放式突袭没有运输时间限制。",
                    label = "基地突袭",
                },
                businessPayments = {
                    description = "选择哪个余额用于支付商业网络采购及运营成本。",
                    label = "支付方式",
                },
                crimeMembership = {
                    description = "选择犯罪组织存储和管理其成员的方式。",
                    label = "会员模式",
                },
                darknetAvailability = {
                    description = "控制平板电脑应用及其放置位置。",
                    label = "可用性",
                },
                darknetChat = {
                    description = "限制加密市场消息。",
                    label = "私聊",
                },
                darknetDelivery = {
                    description = "配置线下会面和可窃取的地图箱子。",
                    label = "交付与死信箱",
                },
                darknetDeliveryLocations = {
                    description = "配置 BlackBay NPC 交易时随机分配的地点池。",
                    label = "交接地点",
                },
                darknetEconomy = {
                    description = "配置钱包余额、代币兑换和支付汇率。",
                    label = "加密货币",
                },
                darknetIdentity = {
                    description = "配置身份轮换、验证和诈骗警告。",
                    label = "别名与声望",
                },
                darknetListings = {
                    description = "控制广告限制、价格和自动过期。",
                    label = "报价与有效期",
                },
                darknetNpcTraders = {
                    description = "具有可配置风险的持久 NPC 买家和卖家。",
                    label = "NPC 交易者",
                },
                darknetPolice = {
                    description = "允许发布陷阱和查看调查的职位组。",
                    label = "警方权限",
                },
                heistCrafting = {
                    description = "选择制作劫掠装备所需的交互程度。适用于整个犯罪系统中的新尝试。",
                    label = "劫掠任务车间",
                },
                heistCreatorMenu = {
                    description = "在专属的劫案策划器中创建、编辑和发布模块化劫案。",
                    label = "策划菜单",
                },
                heistExecution = {
                    description = "劫掠行动的开始窗口、不活跃时间及冷却时间。",
                    label = "劫掠时长",
                },
                moneywashEconomy = {
                    description = "启用商业场所并配置存款账户、服务费及交互距离。",
                    label = "常规",
                },
                npcPoliceSupport = {
                    description = "武装的 NPC 警员会徒步响应抢劫警报，并通过交火对抗劫匪来支援警方。",
                    label = "NPC 警力支援",
                },
                pickpocketAvailability = {
                    description = "启用此功能，并可选择性地将其限制在配置的犯罪职位内。",
                    label = "可用性",
                },
                pickpocketDispatchSettings = {
                    description = "配置 NPC 拨打紧急服务时发送的警报。",
                    label = "紧急调度",
                },
                pickpocketDistances = {
                    description = "设置共享径向菜单和目标系统所使用的 NPC 范围。",
                    label = "交互距离",
                },
                pickpocketGameplay = {
                    description = "选择挑战难度以及独立的逃跑、报警和反击概率。",
                    label = "风险与小游戏",
                },
                pickpocketItemRewards = {
                    description = "控制空口袋和可见物品的选择，精确至 0.0001 百分比。",
                    label = "可见口袋战利品",
                },
                pickpocketMoney = {
                    description = "配置服务器生成的随机现金范围。",
                    label = "现金酬劳",
                },
                pickpocketRateLimits = {
                    description = "控制请求节流、单个 NPC 的冷却时间以及会话过期。",
                    label = "服务器防护",
                },
                pvpArenas = {
                    description = "创建 PvP 事件使用的圆形区域、观察点和团队出生点。",
                    label = "竞技场与战斗区域",
                },
                pvpAutomation = {
                    description = "配置循环事件和自动启动处理。",
                    label = "自动化",
                },
                pvpAvailability = {
                    description = "控制 PvP 事件 App 是否可用及其显示位置。",
                    label = "可用性",
                },
                pvpLimits = {
                    description = "设置奖励和平板电脑历史记录限制。",
                    label = "限制与历史记录",
                },
                pvpModes = {
                    description = "配置 PvP 平板电脑中预选的游戏模式。",
                    label = "游戏模式",
                },
                pvpPermissions = {
                    description = "将地图事件管理和财务分配给 ACE 和职位权限。",
                    label = "权限",
                },
                pvpRuntime = {
                    description = "调整实时比赛中的请求处理、死亡和重生。",
                    label = "运行时间",
                },
                pvpTakeoverMethods = {
                    description = "配置每种破门方式所需的时间。",
                    label = "破门方式",
                },
                pvpTakeoverRules = {
                    description = "控制实验室和露营地接管的可用性及参与要求。",
                    label = "接管规则",
                },
                pvpTakeoverZones = {
                    description = "配置交互、警报和占领区域及其持续时间。",
                    label = "区域与时间",
                },
                shopAvailability = {
                    description = "启用抢劫并配置警方要求。",
                    label = "可用性",
                },
                shopDispatchSettings = {
                    description = "配置接收者和警报属性。",
                    label = "警方警报",
                },
                shopLocationTable = {
                    description = "管理有店员的零售场所和保险箱。",
                    label = "商店位置",
                },
                shopRegisterReward = {
                    description = "配置每个收银机（register）的随机奖励。",
                    label = "收银机奖励",
                },
                shopRegisterTable = {
                    description = "将单个收银机分配给商店。",
                    label = "收银机",
                },
                shopSafe = {
                    description = "配置密码输入尝试次数和电钻道具。",
                    label = "保险箱",
                },
                shopSafeReward = {
                    description = "配置随机保险箱奖励。",
                    label = "保险箱奖励",
                },
                shopTiming = {
                    description = "配置威慑、行动、超时和冷却时间。",
                    label = "时间设置",
                },
            },
            settingSections = {
                weapons = "武器路线",
                drugs = "毒品系统",
                drugProduction = "毒品生产",
                drugOperations = "毒品经营",
                drugMarketRisk = "市场与风险",
                drugNetworks = "毒品网络",
                atmRobbery = "ATM 抢劫",
                baseRaids = "基地突袭",
                crimeOrganizations = "组织",
                darknetMarket = "暗网市场",
                moneywash = "洗钱",
                pvpEvents = "阵营 PvP",
                robbery = "抢劫",
                territories = "领地",
                graffiti = "涂鸦",
                interrogation = "审讯",
            },
            settingSubsections = {
                baseRaidEquipment = "所需装备",
                baseRaidBreach = "破门",
                baseRaidLoot = "战利品与载具",
                graffitiLimits = "限制与审核",
                interrogationTechnical = "日志与安全",
                atmDispatch = "警察派遣",
                atmEquipment = "设备",
                atmExplosion = "爆炸",
                atmOverview = "概览与位置",
                atmRewards = "奖励",
                atmTiming = "时间设置",
                atmVehicle = "车辆与扯下",
                baseRaids = "基地突袭",
                crimeMembership = "成员身份",
                heistCreator = "劫掠任务创建器",
                npcPoliceSupport = "NPC 警力支援",
                pickpocket = "NPC 扒窃",
                pvpArenas = "竞技场",
                pvpEquipment = "游戏模式",
                pvpOverview = "概述",
                pvpRuntime = "运行时间",
                pvpTakeovers = "实验室占领",
                shopRobbery = "商店抢劫",
                atmRobbery = "ATM 抢劫",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "交互距离" },
                weaponDefaultGeneralPedModel = { label = "默认NPC模型" },
                weaponDefaultAccessActiveHourStart = { label = "开放时间（UTC）" },
                weaponDefaultAccessActiveHourEnd = { label = "关闭时间（UTC）" },
                weaponDefaultAccessPoliceRequired = { label = "所需在岗警察人数" },
                weaponDefaultAccessPoliceJobs = { label = "警察职业" },
                weaponDefaultCollectionDurationSeconds = { label = "时长（秒）" },
                weaponDefaultCollectionCooldownSeconds = { label = "冷却时间（秒）" },
                weaponDefaultCollectionCooldownScope = { label = "冷却范围" },
                weaponDefaultCollectionUseMinigame = { label = "使用小游戏" },
                weaponDefaultCollectionMinigame = { label = "小游戏" },
                weaponDefaultCollectionMinigameRounds = { label = "小游戏轮数" },
                weaponDefaultProductionDurationSeconds = { label = "时长（秒）" },
                weaponDefaultProductionSuccessChance = { label = "成功率（%）" },
                weaponDefaultProductionFailureConsumesInputs = { label = "失败时消耗材料" },
                weaponDefaultProductionUseMinigame = { label = "使用小游戏" },
                weaponDefaultProductionMinigame = { label = "小游戏" },
                weaponDefaultProductionMinigameRounds = { label = "小游戏轮数" },
                weaponDefaultProductionQualityMin = { label = "最低品质" },
                weaponDefaultProductionQualityMax = { label = "最高品质" },
                weaponDefaultProductionCooldownSeconds = { label = "冷却时间（秒）" },
                weaponDefaultProductionCooldownScope = { label = "冷却范围" },
                weaponDefaultMarketPayoutAccount = { label = "付款账户" },
                weaponDefaultMarketPriceMultiplierMin = { label = "最低价格系数（%）" },
                weaponDefaultMarketPriceMultiplierMax = { label = "最高价格系数（%）" },
                weaponDefaultMarketRestockSeconds = { label = "补货间隔（秒）" },
                weaponDefaultMarketCooldownSeconds = { label = "冷却时间（秒）" },
                weaponDefaultMarketCooldownScope = { label = "冷却范围" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "订单期限（分钟）" },
                weaponDefaultDeliveryContractBonusPercent = { label = "订单奖励（%）" },
                weaponStreetEnabled = { label = "向街头买家出售稀有武器" },
                weaponStreetChance = { label = "武器报价概率（%）" },
                weaponStreetCooldown = { label = "冷却时间（秒）" },
                weaponStreetAmount = { label = "最大数量" },
                weaponStreetPriceMin = { label = "最低价格系数（%）" },
                weaponStreetPriceMax = { label = "最高价格系数（%）" },
                weaponStreetAccount = { label = "付款账户" },
                weaponStreetDirect = { label = "直接出售" },
                weaponStreetBulk = { label = "批量出售" },
                weaponStreetContract = { label = "犯罪集团订单" },
                weaponSystemEnabled = { label = "启用武器路线", description = "启用武器收集、加工和向犯罪集团销售。" },
                weaponRuntimeEnabled = { label = "启用武器操作", description = "允许在游戏世界中使用已配置的武器路线。" },
                weaponCreatorAccess = { label = "武器创建器访问权限", description = "选择谁可以打开武器创建器。", options = { permission = "仅限有权限者", jobManagement = "职业管理", ownerOnly = "仅所有者" } },
                openWeaponCreator = { label = "非法商业非法制造者", description = "在一个创建器中管理武器路线和洗钱业务。", buttonLabel = "非法商业非法制造者", unsavedTooltip = "请先保存" },

                drugCultivationProgressionEnabled = { label = "启用种植等级", description = "启用种植经验、等级和基于等级的解锁要求。" },
                drugCultivationMaxLevel = { label = "最高种植等级", description = "可达到的最高种植等级，高于该值的等级无法达到。" },
                drugCultivationLevels = { label = "等级曲线", description = "配置每个种植等级的名称和所需总经验。" },
                drugCultivationActionXp = { label = "经验奖励", description = "配置每种植操作获得的种植经验。" },
                drugCultivationUnlocks = { label = "等级解锁", description = "配置容器、基质、设备、品种和扫描器层级所需的种植等级。" },
                reputationRewards = { label = "声望行动", description = "添加行动、修改点数、禁用或删除条目。只有启用的条目才会给予点数。" },
                reputationEnabled = { label = "启用犯罪声望", description = "奖励个人声望。" },
                reputationPointsPerLevel = { label = "每级所需点数", description = "每升一级需要增加的点数。" },
                reputationMinimumJoinPoints = { label = "加入所需最低声望", description = "加入犯罪帮派所需的总点数。设为0可禁用要求。现有成员保留权限。" },
                reputation_atm = { label = "抢劫自动取款机", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_shop_register = { label = "商店收银机", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_shop_safe = { label = "商店保险柜", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_pickpocket = { label = "扒窃", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_heist = { label = "完成抢劫任务", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_harvest = { label = "收获毒品", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_processing = { label = "加工毒品", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_sale = { label = "出售毒品", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_delivery = { label = "运送毒品", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_contract = { label = "分销合同", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_drug_raid = { label = "毒品突袭", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_graffiti = { label = "涂鸦", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_moneywash = { label = "洗钱", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_base_raid = { label = "基地突袭", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                reputation_pvp_win = { label = "PvP胜利", description = "每次成功完成行动奖励的点数。设为0可禁用该奖励。" },
                atmChargeProp = {
                    description = "在安装爆炸物期间，ATM 上显示的物体模型。",
                    label = "炸药道具",
                },
                atmConsumeDrill = {
                    description = "每成功完成一个自动取款机钻孔点后，消耗设定数量的钻机物品。",
                    label = "消耗钻机",
                },
                atmDrillItem = {
                    description = "钻开被拖离原位的自动取款机所需的库存物品 ID。与商店保险柜的钻机独立设置。",
                    label = "钻机物品",
                },
                atmDrillItemAmount = {
                    description = "每个自动取款机钻孔点所需的钻机物品数量。",
                    label = "所需钻机数量",
                },
                atmDebug = {
                    description = "将详细的 ATM 抢劫诊断信息写入服务器控制台和客户端 F8 控制台。",
                    label = "ATM 调试日志",
                },
                atmDispatchDurationSeconds = {
                    description = "ATM 警报对调度接收者保持有效的时间（秒）。",
                    label = "调度时长",
                },
                atmDispatchEnabled = {
                    description = "当 ATM 被破解时，创建一个 Job Base 事件。",
                    label = "启用警察调度",
                },
                atmDispatchJobs = {
                    description = "接收 ATM 警报的、以逗号分隔的职位名称。",
                    label = "调度职位",
                },
                atmDispatchPriority = {
                    description = "原封不动传递给调度集成的优先级数值。",
                    label = "调度优先级",
                },
                atmDispatchRadius = {
                    description = "发送给调度集成系统的近似警报半径。",
                    label = "调度半径",
                },
                atmEnabled = {
                    description = "使配置的 ATM 可用于套索抢劫和爆炸抢劫。",
                    label = "启用 ATM 抢劫",
                },
                atmExplosionCameraShake = {
                    description = "引发爆炸的客户端的相机抖动强度。",
                    label = "爆炸相机抖动",
                },
                atmExplosionDamageScale = {
                    description = "传递给爆炸原生程序的伤害与冲击强度。",
                    label = "爆炸伤害倍率",
                },
                atmExplosionType = {
                    description = "引爆时使用的 GTA 爆炸类型。除非已测试过其他类型，否则请保持默认设置。",
                    label = "爆炸类型",
                },
                atmDrillDurationSeconds = {
                    label = "每颗螺丝的最短钻孔时间（秒）",
                    description = "四颗螺丝中每颗螺丝的最短钻孔时间，单位为秒。冷却暂停会延长操作时间。仅对保存后新开始的钻孔尝试生效。",
                },
                atmExplosiveDurationSeconds = {
                    description = "安装爆炸物所需的秒数。",
                    label = "安装炸药时长",
                },
                atmExplosiveItem = {
                    description = "放置炸药后消耗的库存物品。",
                    label = "爆破物品",
                },
                atmExplosiveItemAmount = {
                    description = "放置一枚炸药所需的消耗炸药道具数量。",
                    label = "消耗的炸药量",
                },
                atmFuseSeconds = {
                    description = "放置与引爆之间的秒数。",
                    label = "引信持续时间",
                },
                atmInteractionDistance = {
                    description = "最大客户端交互范围；服务器验证会增加安全余量。",
                    label = "交互距离",
                },
                atmLocations = {
                    description = "正式生产环境的 ATM 位置。使用 /atmtest 创建的位置为临时位置。",
                    itemLabel = "ATM 位置",
                    label = "ATM 位置",
                },
                atmLootDurationSeconds = {
                    description = "撬开被爆破的 ATM 所需的秒数。",
                    label = "搜刮持续时间",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "玩家在打开 ATM 时可预留 ATM 的最大秒数；该值将自动保持高于搜刮持续时间。",
                    label = "搜刮预留超时",
                },
                atmLootWindowMinutes = {
                    description = "被破拆的 ATM 在耗尽前保持可搜刮状态的分钟数。",
                    label = "搜刮时间窗口",
                },
                atmMinimumPolice = {
                    description = "开始抢劫所需的配置警察组中处于执勤状态的成员人数。",
                    label = "最低警察人数",
                },
                atmPoliceGroup = {
                    description = "用于警察要求的 sky_jobs_base 职位组。",
                    label = "警察职位组",
                },
                atmPullDistance = {
                    description = "完成破拆所需的车辆偏离 ATM 位置的距离。",
                    label = "所需拉拽距离",
                },
                atmPullMinimumSpeed = {
                    description = "达到拉拽距离时的最低车辆速度（米/秒）。",
                    label = "最低拉拽速度",
                },
                atmReservationTimeoutSeconds = {
                    description = "玩家安装吊索或放置炸弹时保留的最长秒数；将自动保持高于动作持续时间。",
                    label = "准备预约超时",
                },
                atmRewardAccount = {
                    description = "选择现金或 black_money 物品。",
                    label = "ATM 支付类型",
                },
                atmRewardMaximum = {
                    description = "单台 ATM 的最高现金赔付额；永远不会低于最小值。",
                    label = "最高奖励",
                },
                atmRewardMinimum = {
                    description = "单台 ATM 的最低现金赔付。",
                    label = "最低奖励",
                },
                atmSlingDurationSeconds = {
                    description = "安装吊带所需的秒数。",
                    label = "安装吊带持续时间",
                },
                atmSlingItem = {
                    description = "车辆作业法所需的重复使用库存物品。",
                    label = "挂载物品",
                },
                atmSlingItemAmount = {
                    description = "必须存在的吊带道具数量。这些道具不会被消耗。",
                    label = "所需的吊带数量",
                },
                atmTestScanDistance = {
                    description = "使用 /atmtest 搜索支持的 ATM 道具时的最大距离。",
                    label = "ATM 测试扫描距离",
                },
                atmVehicleMaxDistance = {
                    description = "挂载吊带时，ATM 与符合条件的车辆之间的最大距离。",
                    label = "车辆挂载距离",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "每次在储藏点撬锁的时限（秒）。",
                    label = "破门超时（秒）",
                },
                baseRaid_command = {
                    description = "不带斜杠的指令名称。更改后请重启 crime 资源。",
                    label = "突袭指令",
                },
                baseRaid_crimeItem = {
                    description = "帮派破袭物品。",
                    label = "帮派破袭物品",
                },
                baseRaid_crimeVehicles = {
                    description = "帮派车辆权限。",
                    label = "帮派车辆权限",
                },
                baseRaid_difficulty = {
                    description = "技能检查难度。",
                    label = "技能检查难度",
                    options = {
                        easy = "简单",
                        expert = "专家",
                        hard = "困难",
                        normal = "普通",
                    },
                },
                baseRaid_enabled = {
                    description = "启用基地突袭。",
                    label = "启用基地突袭",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "突袭结束时未打开任何储藏点的冷却时间（分钟）。",
                    label = "失败后的冷却时间 (分钟)",
                },
                baseRaid_interactionDistance = {
                    description = "储物交互距离。",
                    label = "储物交互距离",
                },
                baseRaid_lootHeistStorage = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "劫掠战赃库",
                },
                baseRaid_lootLaboratories = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "搜刮实验室存储",
                },
                baseRaid_lootPersonalLockers = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "搜刮个人储物柜",
                },
                baseRaid_lootStorage = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "搜刮存储",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "搜刮手套箱",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "允许在进行中的劫掠期间完全提取此库存类别。",
                    label = "搜刮车辆后备箱",
                },
                baseRaid_minimumDefenders = {
                    description = "最低在线防守者人数。",
                    label = "最低在线防守者",
                },
                baseRaid_policeItem = {
                    description = "警察入侵物品。",
                    label = "警察入侵物品",
                },
                baseRaid_policeRequireDuty = {
                    description = "警察必须在岗。",
                    label = "警察必须在岗",
                },
                baseRaid_policeVehicles = {
                    description = "警车权限。",
                    label = "警车权限",
                },
                baseRaid_protectionHours = {
                    description = "成功后的保护时间（小时）。",
                    label = "成功后的保护时间（小时）",
                },
                baseRaid_requiredHits = {
                    description = "所需的技能检查命中数。",
                    label = "所需的技能检查命中数",
                },
                baseRaid_warrantItem = {
                    description = "每次有效的警察突袭开始时，会消耗其中一个道具。",
                    label = "搜查令道具",
                },
                crimeMembershipMode = {
                    description = "框架模式保留现有的工作或原生帮派集成。独立模式会在玩家正常工作的同时在后台运行犯罪组织，并自动迁移现有的成员身份。",
                    label = "组织成员模式",
                    options = {
                        framework = "框架工作 / 帮派",
                        independent = "独立组织",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "身份在可以再次注销前所需的最低存续时间。",
                    label = "别名变更冷却时间 (小时)",
                },
                darknetCurrencyCode = {
                    description = "用于内部加密货币账本的简短标签。",
                    label = "货币代码",
                },
                darknetDeadDropInteractionDistance = {
                    description = "搜索并领取箱子所需的距离。",
                    label = "死信箱交互距离",
                },
                darknetDeadDropLifetimeHours = {
                    description = "未领取箱子过期前的时长。",
                    label = "死信箱有效期 (小时)",
                },
                darknetDeadDropModel = {
                    description = "用于可用死信箱的本地生成的 GTA 道具模型。",
                    label = "死信箱箱体模型",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "用于刷新附近箱子和 NPC 会面的间隔时间。",
                    label = "世界刷新间隔 (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "箱子和 NPC 会面点开始加载的距离。",
                    label = "死信箱流式传输距离",
                },
                darknetDropLocations = {
                    description = "与 NPC 进行死信箱交易时随机分配的位置。至少配置两个。",
                    itemLabel = "死信箱位置",
                    label = "死信箱位置",
                },
                darknetEnabled = {
                    description = "使黑市平板应用及其运行逻辑生效。",
                    label = "启用暗网市场",
                },
                darknetExchangeBuyPrice = {
                    description = "每枚代币从支付账户扣除的金额。",
                    label = "代币买入价",
                },
                darknetExchangeEnabled = {
                    description = "允许已认证的 BlackBay 用户在个人账户页面买卖代币。",
                    label = "启用代币兑换",
                },
                darknetExchangeMaximumAmount = {
                    description = "单次兑换所接受的最大整数代币数量。",
                    label = "单次兑换最高代币数",
                },
                darknetExchangeMinimumAmount = {
                    description = "单次兑换所接受的最小整数代币数量。",
                    label = "单次兑换最低代币数",
                },
                darknetExchangePaymentAccount = {
                    description = "用于代币购买和销售结算的框架账户。",
                    label = "兑换支付账户",
                    options = {
                        bank = "银行",
                        black_money = "脏钱",
                        money = "现金",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "每枚代币支付到支付账户的金额。",
                    label = "代币卖出价",
                },
                darknetFaceToFaceDistance = {
                    description = "两名玩家之间或与配置的 NPC 地点之间的最大距离。",
                    label = "交货距离",
                },
                darknetKnownScammerReports = {
                    description = "获得“已知骗子”徽章所需的唯一交易举报数。",
                    label = "骗子警告举报数",
                },
                darknetListingExpiryHours = {
                    description = "活跃报价将在指定小时数后自动过期。",
                    label = "报价有效期 (小时)",
                },
                darknetMaximumListingQuantity = {
                    description = "单个报价的最大商品数量限制。",
                    label = "最大商品数量",
                },
                darknetMaximumListings = {
                    description = "每个活跃别名的最大报价数。",
                    label = "最大活跃报价数",
                },
                darknetMaximumMessageLength = {
                    description = "每条加密聊天消息的最大字符数。",
                    label = "最大消息长度",
                },
                darknetMaximumUnitPrice = {
                    description = "单个单位的最高加密货币价格。",
                    label = "最高单价",
                },
                darknetMeetingLocations = {
                    description = "与 NPC 进行面对面交易时随机分配的地点。请至少配置两个。",
                    itemLabel = "会面地点",
                    label = "会面地点",
                },
                darknetNpcBuyerAliases = {
                    description = "随机分配给新 NPC 购买请求的虚构名称。请配置至少两个唯一的别名。",
                    label = "NPC 买家别名",
                },
                darknetNpcMaximumBuyListings = {
                    description = "随机选择激活 NPC 购买请求数量时的上限值。",
                    label = "NPC 最大购买请求数",
                },
                darknetNpcMaximumSellListings = {
                    description = "在随机选择激活的 NPC 销售报价数量时使用的上限。",
                    label = "NPC 最大销售报价数",
                },
                darknetNpcMinimumBuyListings = {
                    description = "当 NPC 市场刷新时，至少保留这么多随机选中的购买请求处于激活状态。",
                    label = "最少 NPC 购买请求",
                },
                darknetNpcMinimumSellListings = {
                    description = "当 NPC 市场补货时，至少保留这么多随机选中的出售项目保持激活状态。",
                    label = "最少 NPC 出售项目",
                },
                darknetNpcSellerAliases = {
                    description = "随机分配给新 NPC 销售报价的虚构名称。请至少配置两个唯一的别名。",
                    label = "NPC 卖家别名",
                },
                darknetNpcTraders = {
                    description = "配置合成品报价、交付方式、声望和诈骗概率。",
                    label = "NPC 买家与卖家",
                },
                darknetPoliceGroups = {
                    description = "可发布诱饵报价并查看调查结果的帮派密钥。",
                    label = "授权警察职业组",
                },
                darknetRenewalHours = {
                    description = "所有者续期报价时增加的小时数。",
                    label = "续期时长 (小时)",
                },
                darknetScamChance = {
                    description = "NPC 在交易中拿走付款或货物却不交付回报的最低概率。更高的交易者特定概率仍然有效。",
                    label = "全局 NPC 诈骗概率 (%)",
                },
                darknetStarterBalance = {
                    description = "仅在玩家首次打开市场时分配加密货币。",
                    label = "新钱包余额",
                },
                darknetTabletOrder = {
                    description = "控制暗网市场在平板电脑上的显示位置。",
                    label = "平板应用排序",
                },
                darknetVerifiedMinimumRating = {
                    description = "验证卖家所需的最低平均评分。",
                    label = "验证所需的评分",
                },
                darknetVerifiedMinimumSales = {
                    description = "卖家成为验证卖家之前所需的成功销售次数。",
                    label = "验证所需的销售额",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "当支付来源设置为玩家账户时使用的账户。组织支付始终使用 Boss 菜单账户。",
                    label = "玩家支付账户",
                    options = {
                        bank = "银行",
                        black_money = "脏钱",
                        money = "现金",
                    },
                    requiresWarning = "仅在支付来源设置为玩家账户时使用。",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "使用购买玩家的余额或组织的 Boss 菜单账户。",
                    label = "支付来源",
                    options = {
                        player = "玩家账户",
                        society = "组织账户",
                    },
                },
                drugCamperLockKey = {
                    description = "设置锁定和解锁个人或阵营共享房车的默认按键。玩家可以在 FiveM 按键绑定中进行自定义。",
                    label = "房车锁默认按键",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "是",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "默认向采集产出物添加质量和批次数据。禁用此项可使原材料正常堆叠。",
                    label = "采集物品元数据",
                },
                drugLabAssaultAlertDuration = {
                    description = "防守方警报半径在地图上保持可见的秒数。",
                    label = "防守方警报持续时间",
                },
                drugLabAssaultAlertRadius = {
                    description = "在地图上向防守方显示的攻击区域半径。",
                    label = "防守者警报半径",
                },
                drugLabAssaultBreachRadius = {
                    description = "攻击者在破门时必须保持在半径范围内的距离。",
                    label = "破门停留半径",
                },
                drugLabAssaultCaptureDuration = {
                    description = "攻击者必须无干扰地控制入口以占领实验室或房车所需的秒数。",
                    label = "占领持续时间",
                },
                drugLabAssaultCaptureRadius = {
                    description = "用于统计攻击者和对抗防守者的入口区域。",
                    label = "占领半径",
                },
                drugLabAssaultElectronicDuration = {
                    description = "破解入口系统所需的秒数。",
                    label = "电子入侵持续时间",
                },
                drugLabAssaultEnabled = {
                    description = "允许帮派入侵并占领竞争对手的实验室及帮派共用的露营车。",
                    label = "启用实验室与露营车占领",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "使用炸药爆破入口所需的秒数。",
                    label = "爆破持续时间",
                },
                drugLabAssaultInteractionDistance = {
                    description = "开始攻击时，距离实验室或营地入口的最大距离。",
                    label = "入口交互距离",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "钻开入口锁所需的秒数。",
                    label = "机械入侵持续时间",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "在攻击开始前，防守方阵营必须有足够数量的成员在线。",
                    label = "最低防守人数",
                },
                drugLabAssaultRequireDuty = {
                    description = "仅计算当前正在值班的防守方帮派成员。",
                    label = "仅计算在岗防守者",
                },
                drugProcessingInventoryMetadata = {
                    description = "默认将质量和批次数据附加到处理产出物中。单个配方可以覆盖此设置。",
                    label = "处理物品元数据",
                },
                graffitiItemName = {
                    description = "当启用道具需求时，开始喷漆所需的库存道具。该道具必须存在于当前库存中。",
                    label = "所需的涂鸦道具",
                },
                heistCooldownMinutes = {
                    description = "在一次包含实际交互的抢劫任务结束并清理后，将锁定同一场抢劫。设置为零可禁用冷却时间。未使用的启动窗口不会触发冷却。",
                    label = "劫掠冷却时间（分钟）",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "显示五秒进度条，成功后消耗所需材料。",
                        medium = "按显示顺序选择材料，每种材料需通过一次时机判定。",
                        advanced = "带设备配置的配方需要完整组装设备；其他配方每种材料需通过两次精确时机判定。",
                    },
                    description = "简单：五秒进度条。中等：食材选择与时机检测。最高：完整的设备组装；不含设备配置文件的配方，每种食材需进行两次精确的时机检测。",
                    label = "制作复杂度",
                    options = {
                        advanced = "最高复杂度",
                        medium = "中等复杂度",
                        simple = "简单",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "在首次交互后，每次新的劫掠行动都会重置此计时器。超时将结束该次行动并清除其世界对象。适用于新的劫掠行动。",
                    label = "劫掠不活跃限制（分钟）",
                },
                heistStartTimeoutMinutes = {
                    description = "按下“开始”后到在目标处进行交互的时间。若未进行交互，则该次行动将重置并可以重新开始。适用于新行动。",
                    label = "距离首次劫掠交互的分钟数",
                },
                moneywashAccount = {
                    options = {
                        bank = "银行",
                        black_money = "脏钱",
                        money = "现金",
                    },
                },
                moneywashDirtyAccount = {
                    description = "当洗钱周期开始时，从中扣除玩家黑钱的账户。",
                    label = "存款账户",
                },
                moneywashDrawDistance = {
                    description = "显示企业入口和商店的最大距离（米）。",
                    label = "显示距离",
                },
                moneywashEnabled = {
                    description = "使组织拥有的洗钱业务可用。",
                    label = "启用洗钱",
                },
                moneywashFeePercent = {
                    description = "在向组织支付之前，从每批次中扣除的百分比。",
                    label = "服务费 (%)",
                },
                moneywashInteractionDistance = {
                    description = "使用企业入口和商店的最大距离（米）。",
                    label = "交互距离",
                },
                npcPoliceAccuracy = {
                    description = "NPC 警员在 0 到 100 之间的精准度。",
                    label = "射击精准度",
                },
                npcPoliceArmour = {
                    description = "每名 NPC 警员的护甲值，范围从 0 到 100。",
                    label = "防弹衣",
                },
                npcPoliceAtms = {
                    description = "当触发 ATM 抢劫警报时，派遣 NPC 警察支援。",
                    label = "ATM 抢劫支援",
                },
                npcPoliceDurationSeconds = {
                    description = "NPC 警员在生成后保持部署状态的最长时间 (30–900 秒)。",
                    label = "部署持续时间 (秒)",
                },
                npcPoliceEnabled = {
                    description = "当触发抢劫警报时，派遣武装 NPC 警员。默认禁用。",
                    label = "启用 NPC 警察支援",
                },
                npcPoliceHeists = {
                    description = "当劫掠警报触发时，派遣 NPC 警察支援。",
                    label = "劫掠任务支援",
                },
                npcPoliceOfficerCount = {
                    description = "每次抢劫警报派遣的武装 NPC 警员数量 (1–8)。",
                    label = "每次响应的警员人数",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "抢劫警报与 NPC 警员到达之间的时间 (0–300 秒)。",
                    label = "响应延迟 (秒)",
                },
                npcPoliceShops = {
                    description = "当触发商店抢劫警报时，派遣 NPC 警察支援。",
                    label = "商店抢劫支援",
                },
                npcPoliceSpawnDistance = {
                    description = "NPC 警员生成的距离劫持地点的目标距离 (15–150 米)。",
                    label = "生成距离（米）",
                },
                npcPoliceWeapon = {
                    description = "每名响应的 NPC 警员所装备的武器。默认为手枪。",
                    label = "配枪",
                    options = {
                        WEAPON_CARBINERIFLE = "卡宾步枪",
                        WEAPON_PISTOL = "手枪",
                        WEAPON_PUMPSHOTGUN = "泵动式散弹枪",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "打开劫掠任务创建器",
                    description = "打开 Heist Creator 并关闭 Job Configurator。",
                    label = "劫掠任务创建器",
                    unsavedTooltip = "请先保存更改",
                },
                pickpocketAggressionChance = {
                    description = "在尝试失败、取消或超时后，NPC 发起攻击的独立概率。",
                    label = "反击概率 (%)",
                },
                pickpocketAlertChance = {
                    description = "NPC 报告失败、取消或过期尝试的独立概率。",
                    label = "报警概率 (%)",
                },
                pickpocketDifficulty = {
                    description = "控制光标速度、目标缩小速度、序列长度以及容许的错误次数。",
                    label = "难度",
                    options = {
                        easy = "简单",
                        expert = "专家",
                        hard = "困难",
                        normal = "普通",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "每次扒窃开始时报告一次，包括成功的尝试，不受报警概率影响。",
                    label = "始终发送警情",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "报告对调度接收者保持有效的时间（秒）。",
                    label = "调度持续时间",
                },
                pickpocketDispatchJobs = {
                    description = "以逗号分隔的接收紧急呼叫的职位名称。",
                    label = "调度职位",
                },
                pickpocketDispatchPriority = {
                    description = "原样传递给调度集成的优先级。",
                    label = "调度优先级",
                },
                pickpocketDispatchRadius = {
                    description = "发送至调度集成的近似警报半径。",
                    label = "调度半径",
                },
                pickpocketEmptyChance = {
                    description = "NPC 完全没有可选择战利品的概率。",
                    label = "空手概率 (%)",
                },
                pickpocketEnabled = {
                    description = "允许玩家尝试扒窃符合条件的网络环境 NPC。",
                    label = "启用 NPC 扒窃",
                },
                pickpocketFleeChance = {
                    description = "在尝试失败、取消或超时后，NPC 逃跑的独立概率。",
                    label = "NPC 逃跑概率 (%)",
                },
                pickpocketInteractionDistance = {
                    description = "最大客户端范围；服务器会带有一个微小的同步余量进行验证。",
                    label = "交互距离",
                },
                pickpocketItems = {
                    description = "每一行控制其出现的概率。支持小数点后四位，即 0.0001 百分比。",
                    itemLabel = "物品概率",
                    label = "物品战利品",
                },
                pickpocketItemsEnabled = {
                    description = "同时将配置的物品随机加入到可见的口袋物品中。",
                    label = "启用物品搜刮",
                },
                pickpocketMaximumLootChoices = {
                    description = "单个 NPC 显示的服务器生成的现金或物品槽位的最大数量。",
                    label = "最大可见战利品",
                },
                pickpocketMinigame = {
                    description = "选择一种挑战，或在所有三种挑战中随机轮换。",
                    label = "小游戏",
                    options = {
                        pulse = "压力脉冲",
                        random = "随机旋转",
                        sequence = "方向序列",
                        timing = "时机条",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "最高可见现金金额；将自动保持在不低于最低金额的状态。",
                    label = "最大现金",
                },
                pickpocketMoneyMinimum = {
                    description = "可见现金槽位中服务器生成的最低金额。",
                    label = "最小现金",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "同一玩家发起请求之间的最小间隔秒数。",
                    label = "请求冷却时间",
                },
                pickpocketRequireCrimeJob = {
                    description = "启用：仅将动作添加到已注册的犯罪系统职位中。禁用：移除内置的径向菜单动作并需要服务器导出。",
                    label = "使用犯罪职位径向菜单",
                },
                pickpocketRequiredHits = {
                    description = "每个小游戏的基准值。高价值现金会按步长提高该值；极稀有物品至少需要八次命中。",
                    label = "最低命中次数",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "未完成的服务端挑战过期前的秒数。",
                    label = "会话超时",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "取消或失败尝试后的锁定；成功清空的 NPC 将保持不可用状态。",
                    label = "NPC 冷却时间",
                },
                pvpAdminAce = {
                    description = "授予全局 PvP 事件管理权限的 ACE 对象。",
                    label = "管理员 ACE",
                },
                pvpArenaReturnSeconds = {
                    description = "新事件的默认返回时间。活动负责人可以在平板电脑中进行覆盖设置。",
                    label = "竞技场返回时间",
                },
                pvpArenaWarningPosition = {
                    description = "控制“返回竞技场”警告的显示位置。",
                    label = "竞技场警告位置",
                    options = {
                        bottom_center = "底部居中",
                        bottom_left = "左下角",
                        bottom_right = "右下角",
                        middle_center = "屏幕中心",
                        middle_left = "左侧中间",
                        middle_right = "右侧中间",
                        top_center = "顶部居中",
                        top_left = "左上角",
                        top_right = "右上角",
                    },
                },
                pvpArenas = {
                    description = "创建带有观察点和至少两个队伍出生点的圆形战斗区域。",
                    itemLabel = "竞技场",
                    label = "PvP 竞技场",
                },
                pvpCountdownPosition = {
                    description = "控制比赛开始倒计时的显示位置。",
                    label = "倒计时位置",
                    options = {
                        bottom_center = "底部居中",
                        bottom_left = "左下角",
                        bottom_right = "右下角",
                        middle_center = "屏幕中心",
                        middle_left = "左侧中间",
                        middle_right = "右侧中间",
                        top_center = "顶部居中",
                        top_left = "左上角",
                        top_right = "右上角",
                    },
                },
                pvpDefaultMode = {
                    description = "新活动预选的游戏模式。",
                    label = "默认游戏模式",
                    options = {
                        free_for_all = "自由对战",
                        last_man_standing = "最后存活者",
                        team_deathmatch = "团队死亡竞赛",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "团队死亡竞赛或自由对战获胜所需的默认击杀数。",
                    label = "默认击杀目标",
                },
                pvpEventsEnabled = {
                    description = "使帮派 PvP 平板应用和事件运行时可用。",
                    label = "启用帮派 PvP 事件",
                },
                pvpKillfeedPosition = {
                    description = "控制最近击杀信息的显示位置。",
                    label = "击杀信息流位置",
                    options = {
                        bottom_center = "底部居中",
                        bottom_left = "左下角",
                        bottom_right = "右下角",
                        middle_center = "屏幕中心",
                        middle_left = "左侧中间",
                        middle_right = "右侧中间",
                        top_center = "顶部居中",
                        top_left = "左上角",
                        top_right = "右上角",
                    },
                },
                pvpLeaderPermission = {
                    description = "创建、注册、开始及管理帮派活动的所需职位权限。",
                    label = "帮派首领权限",
                },
                pvpMatchDurationMinutes = {
                    description = "新事件的默认持续时间（以分钟为单位）。设置为零可禁用时间限制。",
                    label = "比赛时长",
                },
                pvpMaxHistory = {
                    description = "返回平板电脑的已完成或已取消事件的最大数量。",
                    label = "可见事件历史",
                },
                pvpMaxRewards = {
                    description = "每次事件中物品、武器、车辆或金钱奖励组合的最大数量。",
                    label = "最大额外奖励",
                },
                pvpMoneyPermission = {
                    description = "进入费和奖金所需的职位权限。",
                    label = "帮派财务权限",
                },
                pvpRequestCooldownMs = {
                    description = "单个玩家进行 PvP 请求变更之间的最小毫秒数。",
                    label = "动作冷却时间",
                },
                pvpRespawnDelaySeconds = {
                    description = "玩家死亡后复活或移动到观察区域前的秒数。",
                    label = "复活延迟",
                },
                pvpSchedulePollSeconds = {
                    description = "循环模板与自动开始检查之间的秒数。",
                    label = "计划检查间隔",
                },
                pvpScoreboardPosition = {
                    description = "控制帮派比赛期间紧凑型实时计分板的显示位置。",
                    label = "计分板位置",
                    options = {
                        bottom_center = "底部居中",
                        bottom_left = "左下角",
                        bottom_right = "右下角",
                        middle_center = "屏幕中心",
                        middle_left = "左侧中间",
                        middle_right = "右侧中间",
                        top_center = "顶部居中",
                        top_left = "左上角",
                        top_right = "右上角",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "允许 PvP 管理员注册并与一名帮派成员手动开始。在正式服务器上请禁用此项。",
                    label = "启用管理员单人测试",
                },
                pvpStartCountdownSeconds = {
                    description = "新创建事件的默认倒计时。事件负责人可以在平板电脑中进行覆盖设置。",
                    label = "开始倒计时",
                },
                pvpTabletOrder = {
                    description = "控制帮派 PvP 应用在平板电脑上的显示位置。",
                    label = "平板应用排序",
                },
                shopActiveTimeoutMinutes = {
                    description = "被放弃的抢劫任务失败前的分钟数。",
                    label = "激活超时",
                },
                shopConsumeDrill = {
                    description = "成功开启后消耗电钻。",
                    label = "消耗电钻",
                },
                shopConsumeHackItem = {
                    description = "在成功打开保险箱后消耗黑客道具。",
                    label = "消耗黑客道具",
                },
                shopCooldownMinutes = {
                    description = "商店重置前的运行分钟数。",
                    label = "商店冷却时间",
                },
                shopDispatchAlways = {
                    description = "每次商店抢劫开始时报告一次，包括持续威胁店员以及无需店员的商店。",
                    label = "始终发送警情",
                },
                shopDispatchDurationSeconds = {
                    description = "警报保持有效的秒数。",
                    label = "调度持续时间",
                },
                shopDispatchJobs = {
                    description = "以逗号分隔的警报接收者职位。",
                    label = "调度职位",
                },
                shopDispatchPriority = {
                    description = "传递给调度中心的优先级。",
                    label = "调度优先级",
                },
                shopDispatchRadius = {
                    description = "近似的警察警报半径。",
                    label = "调度半径",
                },
                shopDrillDurationSeconds = {
                    description = "钻开保险箱所需的秒数。",
                    label = "保险箱钻孔时长",
                },
                shopDrillItem = {
                    description = "钻开商店保险柜所需的库存物品 ID。与自动取款机的钻机独立设置。",
                    label = "电钻道具",
                },
                shopDrillItemAmount = {
                    description = "所需的电钻道具数量。",
                    label = "所需的电钻数量",
                },
                shopEnabled = {
                    description = "允许在已配置的有店员商店进行抢劫。",
                    label = "启用商店抢劫",
                },
                shopHackItem = {
                    description = "保险箱黑客小游戏所需的物品。为每个商店单独启用开启方式。",
                    label = "黑客物品",
                },
                shopHackItemAmount = {
                    description = "黑客道具所需的数量。",
                    label = "黑客道具数量",
                },
                shopIntimidationSeconds = {
                    description = "店员必须被枪口指着的时间（秒）。",
                    label = "威慑持续时间",
                },
                shopLocations = {
                    description = "每家商店设有一名店员、一个收银台和一个可选保险箱。",
                    itemLabel = "商店",
                    label = "商店位置",
                },
                shopMinimumPolice = {
                    description = "开始任务所需的在岗警力成员人数。",
                    label = "最低警力",
                },
                shopPoliceGroup = {
                    description = "用于计算警察要求的职位组。",
                    label = "警察职位组",
                },
                shopRegisterDurationSeconds = {
                    description = "清空收银台所需的秒数。",
                    label = "收银台搜刮持续时间",
                },
                shopRegisterRewardMaximum = {
                    description = "收银台最高赔付。",
                    label = "收银台最大奖励",
                },
                shopRegisterRewardMinimum = {
                    description = "最低收银赔付。",
                    label = "最低收银奖励",
                },
                shopRegisterRewardName = {
                    description = "可选的物品或账户名称。",
                    label = "收银机奖励名称",
                },
                shopRegisterRewardSort = {
                    description = "选择现金或 black_money 物品。",
                    label = "收银机支付类型",
                },
                shopRegisters = {
                    description = "按商店 ID 分配的收银机位置。",
                    itemLabel = "收银机",
                    label = "收银机",
                },
                shopSafeLootDurationSeconds = {
                    description = "输入有效保险箱密码后，取走现金所需的秒数。",
                    label = "保险箱搜刮持续时间",
                },
                shopSafeRewardMaximum = {
                    description = "最高保险箱赔付额。",
                    label = "最高保险箱奖励",
                },
                shopSafeRewardMinimum = {
                    description = "最低保险赔付金额。",
                    label = "最低保险奖励",
                },
                shopSafeRewardName = {
                    description = "可选的物品或账户名称。",
                    label = "保险箱奖励名称",
                },
                shopSafeRewardSort = {
                    description = "选择现金或 black_money 物品。",
                    label = "保险箱支付类型",
                },
                shopThreatGraceSeconds = {
                    description = "警报前的允许中断时间。",
                    label = "瞄准宽容期",
                },
                territoryDrugSalesEnabled = {
                    description = "在当前街道领地内向 NPC 成功进行街头销售，将为销售者的帮派提供影响力。",
                    label = "NPC 销售可提供领地影响力",
                },
                atmLocationMode = {
                    label = "取款机位置模式",
                    description = "自动识别受支持的世界物体，或仅使用手动配置的地点。",
                    options = {
                        automatic = "自动",
                        manual = "手动",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "要求警察在岗",
                    description = "开始抢劫自动取款机前，必须达到配置的在岗警察人数。",
                },
                openDrugCreator = {
                    label = "毒品编辑器",
                    description = "打开 Sky Crime 毒品编辑器并关闭职业配置器。",
                    buttonLabel = "打开毒品编辑器",
                    unsavedTooltip = "请先保存",
                },
                drugCreatorRuntimeDensity = {
                    label = "运行面板密度",
                    description = "控制毒品编辑器运行面板的紧凑程度。",
                    options = {
                        comfortable = "舒适",
                        compact = "紧凑型",
                    },
                },
                drugCreatorListDensity = {
                    label = "列表密度",
                    description = "控制编辑器条目列表的紧凑程度。",
                    options = {
                        comfortable = "舒适",
                        compact = "紧凑型",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "显示空运行列表",
                    description = "即使没有条目也显示运行面板分区。",
                },
                drugCreatorHideDisabledEntries = {
                    label = "隐藏已禁用条目",
                    description = "在毒品编辑器列表中隐藏已禁用的模块条目。",
                },
                drugCreatorAutoGenerateId = {
                    label = "自动生成标识符",
                    description = "在毒品编辑器中创建条目时，根据名称生成标识符。",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "切换模块时打开编辑器",
                    description = "切换当前模块时自动打开编辑器。",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "副本自动名称后缀",
                    description = "复制毒品编辑器条目时自动添加名称后缀。",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "自动预选游戏目标",
                    description = "自动预选可用实验室和批次。",
                },
                drugCreatorAttentionOnOpen = {
                    label = "打开时关注问题",
                    description = "打开运行面板并优先显示需要关注的条目。",
                },
                drugActivityHudPosition = {
                    label = "活动界面位置",
                    description = "将放置与采集界面拖动到所需的屏幕位置。",
                },
                drugInteractionHudPosition = {
                    label = "交互界面位置",
                    description = "将植物、实验室和露营车交互界面拖动到所需的屏幕位置。",
                },
                drugPlantStatusHudPosition = {
                    label = "植物状态界面位置",
                    description = "将详细植物状态界面拖动到所需的屏幕位置。",
                },
                drugSystemEnabled = {
                    label = "毒品系统",
                    description = "启用：此犯罪职业的毒品生产、编辑器数据与运行接口。",
                },
                drugCreatorAccess = {
                    label = "毒品编辑器权限",
                    description = "控制谁可以打开高级毒品编辑器。",
                    options = {
                        permission = "仅限有权限者",
                        job_management = "职业管理",
                        owner_only = "仅所有者",
                    },
                },
                drugRuntimeEnabled = {
                    label = "运行接口",
                    description = "允许玩家使用游戏中的实验室、植物、加工和市场操作。",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "玩家创建实验室",
                    description = "允许有系统访问权限的普通玩家使用编辑器模板创建实验室。",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "室外种植",
                    description = "允许玩家在已配置实验室之外进行自有室外种植。",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "允许其他玩家收获室外作物",
                    description = "允许其他玩家收获并非自己种植的室外植物。",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "收取实验室购买费用",
                    description = "玩家创建实验室时收取配置的购买价格。",
                },
                drugRuntimeStrictInventory = {
                    label = "严格验证库存操作",
                    description = "仅在配置的物品、工具和资金操作成功后，才继续运行操作。",
                },
                drugRuntimeSalePayouts = {
                    label = "销售 / 结算款",
                    description = "通过市场系统出售批次或路线时向玩家支付款项。",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "付款 / 账户",
                    description = "毒品销售款的结算账户，例如 black_money。",
                },
                drugRuntimeDispatchEnabled = {
                    label = "派遣 / 警报",
                    description = "将毒品风险事件发送至调度中心和已配置的警察职业。",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "警察 / 通知",
                    description = "毒品风险事件触发警报时，通知已配置的警察职业。",
                },
                drugBatchPrefix = {
                    label = "批次 / 前缀",
                    description = "新生成毒品批次标识符的前缀。",
                },
                drugTestingKitAccuracy = {
                    label = "测试套装 / 准确度",
                    description = "基础检测套件对隐藏数值允许的误差范围。",
                },
                drugDecayIntervalMinutes = {
                    label = "衰减 / 间隔",
                    description = "新鲜度及污染消退检查的间隔，单位为分钟。",
                },
                drugDefaultPackaging = {
                    label = "默认值 / 包装",
                    description = "创建原料或加工批次时，未明确指定包装类型所使用的默认包装。",
                    options = {
                        loose = "散装",
                        baggy = "小袋",
                        jar = "罐子",
                        vacuum = "真空袋",
                        brick = "压块包装",
                        premium_seal = "高级密封",
                    },
                },
                drugQualityWeightQuality = {
                    label = "质量 / 权重",
                    description = "对最终品质的影响：基础质量。",
                },
                drugQualityWeightPurity = {
                    label = "纯度 / 权重",
                    description = "对最终品质的影响：纯度。",
                },
                drugQualityWeightFreshness = {
                    label = "新鲜度 / 权重",
                    description = "对最终品质的影响：新鲜度。",
                },
                drugQualityWeightPotency = {
                    label = "效力 / 权重",
                    description = "对最终品质的影响：效力。",
                },
                drugQualityWeightStability = {
                    label = "稳定性 / 权重",
                    description = "对最终品质的影响：稳定性。",
                },
                drugQualityWeightContamination = {
                    label = "污染 / 惩罚",
                    description = "对受污染产品质量评分施加的扣分权重。",
                },
                drugTierGoodMin = {
                    label = "良好 / 等级 / 最小值",
                    description = "品质等级良好所需的最低分数。",
                },
                drugTierPremiumMin = {
                    label = "高级 / 等级 / 最小值",
                    description = "品质等级高级所需的最低分数。",
                },
                drugTierTopShelfMin = {
                    label = "顶级质量 / 等级 / 最小值",
                    description = "品质等级顶级质量所需的最低分数。",
                },
                drugTierLabGradeMin = {
                    label = "实验室级 / 等级 / 最小值",
                    description = "品质等级实验室级所需的最低分数。",
                },
                drugBaggyDecayMultiplier = {
                    label = "小袋 / 衰减",
                    description = "新鲜度下降 / 小袋的倍率。",
                },
                drugJarDecayMultiplier = {
                    label = "罐子 / 衰减",
                    description = "新鲜度下降 / 罐子的倍率。",
                },
                drugVacuumDecayMultiplier = {
                    label = "真空 / 衰减",
                    description = "新鲜度下降 / 真空袋的倍率。",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "高级密封 / 价格",
                    description = "高级 / 密封产品 / 价格的倍率。",
                },
                drugGrowingEnabled = {
                    label = "种植 / 启用",
                    description = "启用：植物生长与收获。",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "植物种植位置检查",
                    description = "启用后，自由种植的植物需等待管理员自动检查种植位置才能生长。关闭后，无需管理员批准即可生长。",
                },
                drugGrowthTickMinutes = {
                    label = "生长率 / 更新周期 / 分钟",
                    description = "植物生长更新的间隔，单位为分钟。",
                },
                drugBaseGrowthPerTick = {
                    label = "基础值 / 生长率 / 每次更新",
                    description = "应用品种、设备和护理修正前的基础生长量。",
                },
                drugWildPlantRespawnMinutes = {
                    label = "野生植物 / 重新生成",
                    description = "野生植物 / 重新生成之前的等待时间，单位为分钟。",
                },
                drugWildPlantHighlightEnabled = {
                    label = "高亮野生植物",
                    description = "玩家进入高亮范围时，为已生成的野生植物显示轮廓。",
                },
                drugWildPlantHighlightDistance = {
                    label = "野生植物高亮半径",
                    description = "每株已生成野生植物周围显示轮廓的距离，单位为米。",
                },
                drugDefaultPlantWater = {
                    label = "默认值 / 水",
                    description = "创建植物时的初始值：水。",
                },
                drugDefaultPlantFertilizer = {
                    label = "默认值 / 肥料",
                    description = "创建植物时的初始值：肥料。",
                },
                drugDefaultPlantHealth = {
                    label = "默认值 / 健康状况",
                    description = "创建植物时的初始值：健康状况。",
                },
                drugDefaultPlantMutationChance = {
                    label = "默认值 / 变异概率",
                    description = "品种未指定独立数值时使用的基础变异概率。",
                },
                drugHarvestPerfectStart = {
                    label = "最佳收获窗口起点",
                    description = "最佳收获窗口的生长百分比：开始。",
                },
                drugHarvestPerfectEnd = {
                    label = "最佳收获窗口终点",
                    description = "最佳收获窗口的生长百分比：结束。",
                },
                drugLabsEnabled = {
                    label = "实验室 / 启用",
                    description = "启用：实验室与房车的游戏运行功能。",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "每个角色的实验室上限",
                    description = "每个所有者可购买或租用的固定实验室数量上限。0 表示不限；房车和共享访问权限不计入。",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "每个阵营的实验室上限",
                    description = "每个所有者可购买或租用的固定实验室数量上限。0 表示不限；房车和共享访问权限不计入。",
                },
                drugDefaultRentDays = {
                    label = "默认值 / 租赁天数",
                    description = "实验室 / 租金 / 时长的默认值。",
                },
                drugCamperHotVehicleMinutes = {
                    label = "被盗房车 / 分钟",
                    description = "被盗房车保持高风险状态的时间。",
                },
                drugLabRentWarningHours = {
                    label = "租金 / 警报 / 小时",
                    description = "实验室租约到期前多少小时开始显示警告。",
                },
                drugLabRentExpiredHeatGain = {
                    label = "租约到期 / 警方关注度",
                    description = "实验室租约到期时增加的警方关注度。",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "房车 / 移动 / 冷却时间",
                    description = "房车 / 实验室 / 再次移动之前的等待时间，单位为分钟。",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "升级 / 费用 / 倍率",
                    description = "实验室 / 等级 / 升级 / 价格的倍率。",
                },
                drugCamperBaseSlots = {
                    label = "房车 / 插槽",
                    description = "房车实验室 / 设备槽位的默认值。",
                },
                drugCamperBaseStorage = {
                    label = "房车 / 储物",
                    description = "房车实验室 / 存储容量的默认值。",
                },
                drugCamperBasePower = {
                    label = "房车 / 电力",
                    description = "房车实验室 / 内置供电的默认值。",
                },
                drugBasementBaseSlots = {
                    label = "地下室 / 插槽",
                    description = "地下室实验室 / 设备槽位的默认值。",
                },
                drugBasementBaseStorage = {
                    label = "地下室 / 储物",
                    description = "地下室实验室 / 存储容量的默认值。",
                },
                drugWarehouseBasePower = {
                    label = "仓库 / 电力",
                    description = "仓库实验室 / 内置供电的默认值。",
                },
                drugPowerEnabled = {
                    label = "电力 / 系统",
                    description = "启用：实验室发电、耗电与过载检查。",
                },
                drugOverloadGraceSeconds = {
                    label = "过载 / 宽限期",
                    description = "电力过载变得危险前的宽限秒数。",
                },
                drugHeatPerKilowatt = {
                    label = "警方关注度 / 每千瓦",
                    description = "用电量产生的实验室警方关注度。",
                },
                drugGeneratorT1Watts = {
                    label = "发电机 T1 / 瓦特",
                    description = "T1级发电机的功率，单位为瓦。",
                },
                drugGeneratorT2Watts = {
                    label = "发电机 T2 / 瓦特",
                    description = "T2级发电机的功率，单位为瓦。",
                },
                drugGeneratorT3Watts = {
                    label = "发电机 T3 / 瓦特",
                    description = "T3级发电机的功率，单位为瓦。",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "磨损 / 倍率",
                    description = "设备磨损 / 加工的全局倍率。",
                },
                drugWorkersEnabled = {
                    label = "员工 / 启用",
                    description = "启用：毒品实验室中的化学师、种植工、包装工与安保人员。",
                },
                drugMaxWorkersPerLab = {
                    label = "最大值 / 员工 / 实验室",
                    description = "每个实验室最多可分配的工人数。",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "加工疲劳",
                    description = "员工完成以下工作后增加的疲劳值：加工步骤。",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "种植 / 疲劳度",
                    description = "种植工完成以下工作后增加的疲劳值：收获或种植工作。",
                },
                drugWorkerRecoveryPerTick = {
                    label = "工人 / 恢复",
                    description = "每次生长更新恢复的疲劳度数值。",
                },
                drugMarketEnabled = {
                    label = "市场 / 启用",
                    description = "启用：买家、贩子与批次销售。",
                },
                drugMarketBasePriceFallback = {
                    label = "备用值 / 基础价格",
                    description = "未配置独立价格的毒品所使用的基础价格。",
                },
                drugMarketStreetMultiplier = {
                    label = "街道 / 倍率",
                    description = "价格 / 街头销售的全局倍率。",
                },
                drugMarketWholesaleMultiplier = {
                    label = "批发 / 倍率",
                    description = "价格 / 批发 / 交易的全局倍率。",
                },
                drugMarketPremiumMultiplier = {
                    label = "高级 / 倍率",
                    description = "价格 / 高级 / 买家的全局倍率。",
                },
                drugMarketHeatPerSale = {
                    label = "警方关注度 / 销售",
                    description = "出售一批货物时实验室增加的基础警方关注度。",
                },
                drugDistributionTickMinutes = {
                    label = "分销 / 更新周期",
                    description = "贩子分销更新的间隔，单位为分钟。",
                },
                drugDistributionIntervalMinutes = {
                    label = "分销 / 间隔",
                    description = "经销商 / 出售前等待时间 / 分钟的默认值。",
                },
                drugDistributionMaxPerDealer = {
                    label = "最大值 / 经销商 / 订单",
                    description = "经销商 / 最多同时生效的分销订单数的默认值。",
                },
                drugThreatsEnabled = {
                    label = "威胁 / 启用",
                    description = "启用：实验室警方关注消退、突袭与破坏事件。",
                },
                drugThreatTickMinutes = {
                    label = "威胁 / 更新周期",
                    description = "警方关注消退以及突袭与破坏检查的间隔，单位为分钟。",
                },
                drugRaidHeatThreshold = {
                    label = "突袭所需警方关注阈值",
                    description = "触发突袭所需的实验室警方关注度。",
                },
                drugSabotageHeatThreshold = {
                    label = "破坏所需警方关注阈值",
                    description = "触发破坏所需的实验室警方关注度。",
                },
                drugThreatHeatDecay = {
                    label = "警方关注度 / 衰减",
                    description = "每次威胁更新时，实验室警方关注度减少的数值。",
                },
                drugRaidChanceAtThreshold = {
                    label = "突袭概率",
                    description = "达到对应警方关注度阈值后，袭击的基础概率。",
                },
                drugSabotageChanceAtThreshold = {
                    label = "破坏 / 概率",
                    description = "达到对应警方关注度阈值后，破坏的基础概率。",
                },
                drugConsumptionEnabled = {
                    label = "消耗已启用",
                    description = "启用：毒品效果以及耐受和成瘾追踪。",
                },
                drugDoseConsumesBatch = {
                    label = "使用时消耗批次",
                    description = "从当前库存中移除已消耗的批次。",
                },
                drugToleranceDecayMinutes = {
                    label = "容差 / 衰减",
                    description = "耐受消退更新的间隔，单位为分钟。",
                },
                drugAddictionDecayMinutes = {
                    label = "成瘾性 / 衰减",
                    description = "成瘾消退更新的间隔，单位为分钟。",
                },
                drugPotencyEffectMultiplier = {
                    label = "效力 / 倍率",
                    description = "决定药效强度对效果烈度的提升程度。",
                },
                drugOverdosePotencyThreshold = {
                    label = "过量 / 阈值",
                    description = "达到此药效负荷后才开始进行过量判定。",
                },
                drugBaseAddictionGain = {
                    label = "基础值 / 成瘾性 / 增益",
                    description = "每剂基础成瘾增量。",
                },
                drugProcessingEnabled = {
                    label = "加工 / 启用",
                    description = "启用：加工任务、包装与检测套件。",
                },
                drugBatchMetadataItemKey = {
                    label = "批次 / 元数据 / 钥匙",
                    description = "集成系统用于批次数据的库存元数据键。",
                },
                drugDefaultProcessDuration = {
                    label = "默认加工时长",
                    description = "加工 / 时长 / 秒 / 无配方自定义值的默认值。",
                },
                drugDefaultFailureRisk = {
                    label = "默认值 / 失败风险",
                    description = "加工 / 失败风险 / 无配方自定义值的默认值。",
                },
                drugPackagingDuration = {
                    label = "包装时长",
                    description = "包装 / 时长 / 秒的默认值。",
                },
                drugPowerTickSeconds = {
                    label = "电力 / 更新周期 / 秒",
                    description = "发电机消耗与用电特征更新的间隔，单位为秒。",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "用电特征 / 警方关注度 / 小时",
                    description = "实验室用电特征每小时产生的警方关注度。",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "过载 / 警方关注度 / 小时",
                    description = "实验室过载时每小时额外增加的警方关注度。",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "空闲 / 警方关注度 / 衰减 / 小时",
                    description = "实验室没有活跃用电特征时，每小时减少的警方关注度。",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "手动 / 最大值 / 负载",
                    description = "能源模式手动的最大值 / 负载。",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "手动 / 警方关注度 / 倍率",
                    description = "能源模式手动的警方关注度 / 倍率。",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "手动 / 噪音 / 倍率",
                    description = "能源模式手动的噪音 / 倍率。",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "平衡 / 最大值 / 负载",
                    description = "能源模式平衡的最大值 / 负载。",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "平衡 / 警方关注度 / 倍率",
                    description = "能源模式平衡的警方关注度 / 倍率。",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "平衡 / 噪音 / 倍率",
                    description = "能源模式平衡的噪音 / 倍率。",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "隐蔽 / 最大值 / 负载",
                    description = "能源模式隐蔽的最大值 / 负载。",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "隐蔽 / 警方关注度 / 倍率",
                    description = "能源模式隐蔽的警方关注度 / 倍率。",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "隐蔽 / 噪音 / 倍率",
                    description = "能源模式隐蔽的噪音 / 倍率。",
                },
                drugPowerPrioritySmellControl = {
                    label = "气味控制 / 优先级",
                    description = "自动负载切除优先级：气味控制 / 设备。",
                },
                drugPowerPriorityAirflow = {
                    label = "通风 / 优先级",
                    description = "自动负载切除优先级：通风 / 设备。",
                },
                drugPowerPrioritySecurity = {
                    label = "安全 / 优先级",
                    description = "自动负载切除优先级：安保设备。",
                },
                drugPowerPriorityGrowing = {
                    label = "种植 / 优先级",
                    description = "自动负载切除优先级：种植 / 设备。",
                },
                drugPowerPriorityLight = {
                    label = "照明 / 优先级",
                    description = "自动负载切除优先级：照明 / 设备。",
                },
                drugPowerPriorityTesting = {
                    label = "检测 / 优先级",
                    description = "自动负载切除优先级：检测 / 设备。",
                },
                drugPowerPriorityPackaging = {
                    label = "包装 / 优先级",
                    description = "自动负载切除优先级：包装 / 设备。",
                },
                drugPowerPriorityChemistry = {
                    label = "化学 / 优先级",
                    description = "自动负载切除优先级：化学 / 设备。",
                },
                drugPowerPriorityHeating = {
                    label = "加热 / 优先级",
                    description = "自动负载切除优先级：加热 / 设备。",
                },
                drugPowerPriorityPressing = {
                    label = "压制 / 优先级",
                    description = "自动负载切除优先级：压制 / 设备。",
                },
                drugPowerPriorityGeneral = {
                    label = "常规 / 优先级",
                    description = "自动负载切除优先级：通用设备。",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "性能 / 未激活 / 控制 / 间隔 / 毫秒",
                    description = "性能 / 未激活 / 控制 / 间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "性能 / 交互 / 空闲 / 扫描间隔 / 毫秒",
                    description = "性能 / 交互 / 空闲 / 扫描间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "性能 / 交互 / 交互提示 / 间隔 / 毫秒",
                    description = "性能 / 交互 / 交互提示 / 间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "性能 / 交互 / 扫描间隔 / 毫秒",
                    description = "性能 / 交互 / 扫描间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "性能 / 最小值 / 扫描间隔 / 毫秒",
                    description = "性能 / 最小值 / 扫描间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "性能 / 街道 / 佩德 / 激活 / 距离",
                    description = "性能 / 街道 / 佩德 / 激活 / 距离的运行设置。",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "性能 / 街道 / 佩德 / 空闲 / 扫描间隔 / 毫秒",
                    description = "性能 / 街道 / 佩德 / 空闲 / 扫描间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "性能 / 街道 / 佩德 / 扫描间隔 / 毫秒",
                    description = "性能 / 街道 / 佩德 / 扫描间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "性能 / 世界 / 缓存 / 额外边距",
                    description = "性能 / 世界 / 缓存 / 额外边距的运行设置。",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "性能 / 世界 / 缓存 / 刷新 / 间隔 / 毫秒",
                    description = "性能 / 世界 / 缓存 / 刷新 / 间隔 / 毫秒的运行设置。",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "性能 / 世界 / 空闲 / 间隔 / 毫秒",
                    description = "性能 / 世界 / 空闲 / 间隔 / 毫秒的运行设置。",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "动态市场 / 动作冷却时间 / 秒",
                    description = "动态市场 / 动作冷却时间 / 秒的运行设置。",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "动态市场 / 行动 / 历史记录上限",
                    description = "动态市场 / 行动 / 历史记录上限的运行设置。",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "动态市场 / 数量 / 饱和度 / 权重",
                    description = "动态市场 / 数量 / 饱和度 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "动态市场 / 基础值 / 情报准确度",
                    description = "动态市场 / 基础值 / 情报准确度的运行设置。",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "动态市场 / 默认值 / 平均值 / 质量",
                    description = "动态市场 / 默认值 / 平均值 / 质量的运行设置。",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "动态市场 / 默认值 / 资源 / 弹性",
                    description = "动态市场 / 默认值 / 资源 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "动态市场 / 需求 / 中心值",
                    description = "动态市场 / 需求 / 中心值的运行设置。",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "动态市场 / 需求 / 价格 / 影响",
                    description = "动态市场 / 需求 / 价格 / 影响的运行设置。",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "动态市场 / 方向 / 阈值",
                    description = "动态市场 / 方向 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "动态市场 / 启用",
                    description = "动态市场 / 启用的运行设置。",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "动态市场 / 事件 / 概率",
                    description = "动态市场 / 事件 / 概率的运行设置。",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "动态市场 / 事件 / 时长 / 分钟",
                    description = "动态市场 / 事件 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "动态市场 / 事件 / 最小值 / 时长 / 分钟",
                    description = "动态市场 / 事件 / 最小值 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "动态市场 / 事件 / 强度 / 最大值",
                    description = "动态市场 / 事件 / 强度 / 最大值的运行设置。",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "动态市场 / 事件 / 强度 / 最小值",
                    description = "动态市场 / 事件 / 强度 / 最小值的运行设置。",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "动态市场 / 活动 / 警方严打 / 需求",
                    description = "动态市场 / 活动 / 警方严打 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "动态市场 / 活动 / 警方严打 / 警察",
                    description = "动态市场 / 活动 / 警方严打 / 警察的运行设置。",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "动态市场 / 活动 / 警方严打 / 价格",
                    description = "动态市场 / 活动 / 警方严打 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "动态市场 / 活动 / 节庆 / 需求",
                    description = "动态市场 / 活动 / 节庆 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "动态市场 / 活动 / 节庆 / 效果 / 1",
                    description = "动态市场 / 活动 / 节庆 / 效果 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "动态市场 / 活动 / 节庆 / 效果 / 2",
                    description = "动态市场 / 活动 / 节庆 / 效果 / 2的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "动态市场 / 活动 / 节庆 / 效果 / 3",
                    description = "动态市场 / 活动 / 节庆 / 效果 / 3的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "动态市场 / 活动 / 节庆 / 价格",
                    description = "动态市场 / 活动 / 节庆 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "动态市场 / 活动 / 节庆 / 配置档案 / 1",
                    description = "动态市场 / 活动 / 节庆 / 配置档案 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "动态市场 / 活动 / 帮派冲突 / 需求",
                    description = "动态市场 / 活动 / 帮派冲突 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "动态市场 / 活动 / 帮派冲突 / 警察",
                    description = "动态市场 / 活动 / 帮派冲突 / 警察的运行设置。",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "动态市场 / 活动 / 帮派冲突 / 价格",
                    description = "动态市场 / 活动 / 帮派冲突 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "动态市场 / 活动 / 帮派冲突 / 配置档案 / 1",
                    description = "动态市场 / 活动 / 帮派冲突 / 配置档案 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "动态市场 / 活动 / 实验室突袭 / 需求",
                    description = "动态市场 / 活动 / 实验室突袭 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "动态市场 / 活动 / 实验室突袭 / 警察",
                    description = "动态市场 / 活动 / 实验室突袭 / 警察的运行设置。",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "动态市场 / 活动 / 实验室突袭 / 价格",
                    description = "动态市场 / 活动 / 实验室突袭 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "动态市场 / 活动 / 实验室突袭 / 供应",
                    description = "动态市场 / 活动 / 实验室突袭 / 供应的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "动态市场 / 活动 / 派对 / 需求",
                    description = "动态市场 / 活动 / 派对 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "动态市场 / 活动 / 派对 / 效果 / 1",
                    description = "动态市场 / 活动 / 派对 / 效果 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "动态市场 / 活动 / 派对 / 效果 / 2",
                    description = "动态市场 / 活动 / 派对 / 效果 / 2的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "动态市场 / 活动 / 派对 / 效果 / 3",
                    description = "动态市场 / 活动 / 派对 / 效果 / 3的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "动态市场 / 活动 / 派对 / 价格",
                    description = "动态市场 / 活动 / 派对 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "动态市场 / 活动 / 派对 / 配置档案 / 1",
                    description = "动态市场 / 活动 / 派对 / 配置档案 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "动态市场 / 活动 / 派对 / 配置档案 / 2",
                    description = "动态市场 / 活动 / 派对 / 配置档案 / 2的运行设置。",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "动态市场 / 活动 / 短缺 / 需求",
                    description = "动态市场 / 活动 / 短缺 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "动态市场 / 活动 / 短缺 / 价格",
                    description = "动态市场 / 活动 / 短缺 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "动态市场 / 活动 / 短缺 / 供应",
                    description = "动态市场 / 活动 / 短缺 / 供应的运行设置。",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "动态市场 / 精确情报 / 声望",
                    description = "动态市场 / 精确情报 / 声望的运行设置。",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "动态市场 / 精确情报 / 信任",
                    description = "动态市场 / 精确情报 / 信任的运行设置。",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "动态市场 / 全球的 / 区域 / 标签",
                    description = "动态市场 / 全球的 / 区域 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "动态市场 / 历史记录上限",
                    description = "动态市场 / 历史记录上限的运行设置。",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "动态市场 / 初始值 / 需求",
                    description = "动态市场 / 初始值 / 需求的运行设置。",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "动态市场 / 初始值 / 价格倍数",
                    description = "动态市场 / 初始值 / 价格倍数的运行设置。",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "动态市场 / 情报 / 需求 / 错误",
                    description = "动态市场 / 情报 / 需求 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "动态市场 / 情报 / 最大值 / 准确度",
                    description = "动态市场 / 情报 / 最大值 / 准确度的运行设置。",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "动态市场 / 情报 / 最小值 / 准确度",
                    description = "动态市场 / 情报 / 最小值 / 准确度的运行设置。",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "动态市场 / 情报 / 警察 / 错误",
                    description = "动态市场 / 情报 / 警察 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "动态市场 / 情报 / 价格 / 错误",
                    description = "动态市场 / 情报 / 价格 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "动态市场 / 情报 / 价格 / 最大值",
                    description = "动态市场 / 情报 / 价格 / 最大值的运行设置。",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "动态市场 / 情报 / 价格 / 最小值",
                    description = "动态市场 / 情报 / 价格 / 最小值的运行设置。",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "动态市场 / 情报 / 声望 / 权重",
                    description = "动态市场 / 情报 / 声望 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "动态市场 / 情报 / 资源 / 价格 / 错误",
                    description = "动态市场 / 情报 / 资源 / 价格 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "动态市场 / 情报 / 饱和度 / 错误",
                    description = "动态市场 / 情报 / 饱和度 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "动态市场 / 情报随机种子窗口 / 秒",
                    description = "动态市场 / 情报随机种子窗口 / 秒的运行设置。",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "动态市场 / 情报 / 状态 / 准确度 / 阈值",
                    description = "动态市场 / 情报 / 状态 / 准确度 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "动态市场 / 情报 / 状态 / 错误 / 阈值",
                    description = "动态市场 / 情报 / 状态 / 错误 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "动态市场 / 情报 / 供应 / 错误",
                    description = "动态市场 / 情报 / 供应 / 错误的运行设置。",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "动态市场 / 情报 / 信任 / 权重",
                    description = "动态市场 / 情报 / 信任 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "动态市场 / 操纵 / 冷却分钟数",
                    description = "动态市场 / 操纵 / 冷却分钟数的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "动态市场 / 操纵 / 需求 / 偏移",
                    description = "动态市场 / 操纵 / 需求 / 偏移的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "动态市场 / 操纵 / 时长 / 分钟",
                    description = "动态市场 / 操纵 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "动态市场 / 操纵 / 警方关注度",
                    description = "动态市场 / 操纵 / 警方关注度的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "动态市场 / 操纵 / 最小值 / 批次 / 数量",
                    description = "动态市场 / 操纵 / 最小值 / 批次 / 数量的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "动态市场 / 操纵 / 付款账户",
                    description = "动态市场 / 操纵 / 付款账户的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "动态市场 / 操纵 / 价格",
                    description = "动态市场 / 操纵 / 价格的运行设置。",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "动态市场 / 操纵 / 区域 / 警方关注度 / 倍率",
                    description = "动态市场 / 操纵 / 区域 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "动态市场 / 最大值 / 情报时效 / 分钟",
                    description = "动态市场 / 最大值 / 情报时效 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "动态市场 / 最大值 / 价格倍数",
                    description = "动态市场 / 最大值 / 价格倍数的运行设置。",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "动态市场 / 最小值 / 情报时效 / 分钟",
                    description = "动态市场 / 最小值 / 情报时效 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "动态市场 / 最小值 / 指标 / 时间窗口 / 分钟",
                    description = "动态市场 / 最小值 / 指标 / 时间窗口 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "动态市场 / 最低价格 / 倍率",
                    description = "动态市场 / 最低价格 / 倍率的运行设置。",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "动态市场 / 最小值 / 更新 / 分钟",
                    description = "动态市场 / 最小值 / 更新 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "动态市场 / 警察 / 需求 / 权重",
                    description = "动态市场 / 警察 / 需求 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "动态市场 / 警察 / 价格 / 影响",
                    description = "动态市场 / 警察 / 价格 / 影响的运行设置。",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "动态市场 / 低质量 / 需求 / 惩罚",
                    description = "动态市场 / 低质量 / 需求 / 惩罚的运行设置。",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "动态市场 / 低质量 / 阈值",
                    description = "动态市场 / 低质量 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "动态市场 / 优质质量 / 需求加成",
                    description = "动态市场 / 优质质量 / 需求加成的运行设置。",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "动态市场 / 优质质量 / 阈值",
                    description = "动态市场 / 优质质量 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "动态市场 / 生产 / 供应 / 权重",
                    description = "动态市场 / 生产 / 供应 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "动态市场 / 生产 / 时间窗口 / 分钟",
                    description = "动态市场 / 生产 / 时间窗口 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "动态市场 / 质量 / 中心值",
                    description = "动态市场 / 质量 / 中心值的运行设置。",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "动态市场 / 质量 / 信心 / 影响",
                    description = "动态市场 / 质量 / 信心 / 影响的运行设置。",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "动态市场 / 质量 / 数值范围",
                    description = "动态市场 / 质量 / 数值范围的运行设置。",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "动态市场 / 稀有度 / 奖金 / 最大值",
                    description = "动态市场 / 稀有度 / 奖金 / 最大值的运行设置。",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "动态市场 / 地区性 / 全球的 / 权重",
                    description = "动态市场 / 地区性 / 全球的 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "动态市场 / 地区性 / 本地 / 权重",
                    description = "动态市场 / 地区性 / 本地 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "动态市场 / 资源 / 别名 / 毒品 / 包装",
                    description = "动态市场 / 资源 / 别名 / 毒品 / 包装的运行设置。",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "动态市场 / 资源 / 别名 / 燃料罐",
                    description = "动态市场 / 资源 / 别名 / 燃料罐的运行设置。",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "动态市场 / 资源 / 别名 / 机器油",
                    description = "动态市场 / 资源 / 别名 / 机器油的运行设置。",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "动态市场 / 资源 / 别名 / 植物养分",
                    description = "动态市场 / 资源 / 别名 / 植物养分的运行设置。",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "动态市场 / 资源 / 别名 / 维修包",
                    description = "动态市场 / 资源 / 别名 / 维修包的运行设置。",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "动态市场 / 资源 / 方向 / 下降 / 阈值",
                    description = "动态市场 / 资源 / 方向 / 下降 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "动态市场 / 资源 / 方向 / 上升 / 阈值",
                    description = "动态市场 / 资源 / 方向 / 上升 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 基础价格",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 弹性",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 标签",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 1",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 2",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 2的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 3",
                    description = "动态市场 / 资源 / 活性炭过滤器 / 关联毒品 / 3的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "动态市场 / 资源 / 化学前体 / 基础价格",
                    description = "动态市场 / 资源 / 化学前体 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "动态市场 / 资源 / 化学前体 / 弹性",
                    description = "动态市场 / 资源 / 化学前体 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "动态市场 / 资源 / 化学前体 / 标签",
                    description = "动态市场 / 资源 / 化学前体 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "动态市场 / 资源 / 化学前体 / 关联毒品 / 1",
                    description = "动态市场 / 资源 / 化学前体 / 关联毒品 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "动态市场 / 资源 / 化学前体 / 关联毒品 / 2",
                    description = "动态市场 / 资源 / 化学前体 / 关联毒品 / 2的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "动态市场 / 资源 / 设备零件 / 基础价格",
                    description = "动态市场 / 资源 / 设备零件 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "动态市场 / 资源 / 设备零件 / 弹性",
                    description = "动态市场 / 资源 / 设备零件 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "动态市场 / 资源 / 设备零件 / 标签",
                    description = "动态市场 / 资源 / 设备零件 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "动态市场 / 资源 / 肥料 / 基础价格",
                    description = "动态市场 / 资源 / 肥料 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "动态市场 / 资源 / 肥料 / 弹性",
                    description = "动态市场 / 资源 / 肥料 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "动态市场 / 资源 / 肥料 / 标签",
                    description = "动态市场 / 资源 / 肥料 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "动态市场 / 资源 / 肥料 / 关联毒品 / 1",
                    description = "动态市场 / 资源 / 肥料 / 关联毒品 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "动态市场 / 资源 / 实验室燃料 / 基础价格",
                    description = "动态市场 / 资源 / 实验室燃料 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "动态市场 / 资源 / 实验室燃料 / 弹性",
                    description = "动态市场 / 资源 / 实验室燃料 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "动态市场 / 资源 / 实验室燃料 / 标签",
                    description = "动态市场 / 资源 / 实验室燃料 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "动态市场 / 资源 / 包装袋 / 基础价格",
                    description = "动态市场 / 资源 / 包装袋 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "动态市场 / 资源 / 包装袋 / 弹性",
                    description = "动态市场 / 资源 / 包装袋 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "动态市场 / 资源 / 包装袋 / 标签",
                    description = "动态市场 / 资源 / 包装袋 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "动态市场 / 资源 / 花盆 / 基础价格",
                    description = "动态市场 / 资源 / 花盆 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "动态市场 / 资源 / 花盆 / 弹性",
                    description = "动态市场 / 资源 / 花盆 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "动态市场 / 资源 / 花盆 / 标签",
                    description = "动态市场 / 资源 / 花盆 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "动态市场 / 资源 / 花盆 / 关联毒品 / 1",
                    description = "动态市场 / 资源 / 花盆 / 关联毒品 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "动态市场 / 资源 / 大麻种子 / 基础价格",
                    description = "动态市场 / 资源 / 大麻种子 / 基础价格的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "动态市场 / 资源 / 大麻种子 / 弹性",
                    description = "动态市场 / 资源 / 大麻种子 / 弹性的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "动态市场 / 资源 / 大麻种子 / 标签",
                    description = "动态市场 / 资源 / 大麻种子 / 标签的运行设置。",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "动态市场 / 资源 / 大麻种子 / 关联毒品 / 1",
                    description = "动态市场 / 资源 / 大麻种子 / 关联毒品 / 1的运行设置。",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "动态市场 / 销售 / 时间窗口 / 分钟",
                    description = "动态市场 / 销售 / 时间窗口 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "动态市场 / 饱和度 / 需求 / 权重",
                    description = "动态市场 / 饱和度 / 需求 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "动态市场 / 饱和度 / 价格 / 影响",
                    description = "动态市场 / 饱和度 / 价格 / 影响的运行设置。",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "动态市场 / 稀缺程度 / 需求 / 权重",
                    description = "动态市场 / 稀缺程度 / 需求 / 权重的运行设置。",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "动态市场 / 稀缺程度 / 价格 / 影响",
                    description = "动态市场 / 稀缺程度 / 价格 / 影响的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "动态市场 / 季节 / 结束 / 月份 / 十二月",
                    description = "动态市场 / 季节 / 结束 / 月份 / 十二月的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "动态市场 / 季节 / 结束 / 月份 / 春季",
                    description = "动态市场 / 季节 / 结束 / 月份 / 春季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "动态市场 / 季节 / 结束 / 月份 / 夏季",
                    description = "动态市场 / 季节 / 结束 / 月份 / 夏季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "动态市场 / 季节 / 结束 / 月份 / 冬季",
                    description = "动态市场 / 季节 / 结束 / 月份 / 冬季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "动态市场 / 季节 / 倍率 / 秋季",
                    description = "动态市场 / 季节 / 倍率 / 秋季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "动态市场 / 季节 / 倍率 / 春季",
                    description = "动态市场 / 季节 / 倍率 / 春季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "动态市场 / 季节 / 倍率 / 夏季",
                    description = "动态市场 / 季节 / 倍率 / 夏季的运行设置。",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "动态市场 / 季节 / 倍率 / 冬季",
                    description = "动态市场 / 季节 / 倍率 / 冬季的运行设置。",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "动态市场 / 短缺 / 传闻 / 阈值",
                    description = "动态市场 / 短缺 / 传闻 / 阈值的运行设置。",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "动态市场 / 状态 / 阈值 / 高需求",
                    description = "动态市场 / 状态 / 阈值 / 高需求的运行设置。",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "动态市场 / 状态 / 阈值 / 热度",
                    description = "动态市场 / 状态 / 阈值 / 热度的运行设置。",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "动态市场 / 状态 / 阈值 / 低需求",
                    description = "动态市场 / 状态 / 阈值 / 低需求的运行设置。",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "动态市场 / 状态 / 阈值 / 已饱和",
                    description = "动态市场 / 状态 / 阈值 / 已饱和的运行设置。",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "动态市场 / 目标 / 供应",
                    description = "动态市场 / 目标 / 供应的运行设置。",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "动态市场 / 趋势 / 概率",
                    description = "动态市场 / 趋势 / 概率的运行设置。",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "动态市场 / 趋势 / 时长 / 分钟",
                    description = "动态市场 / 趋势 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "动态市场 / 趋势 / 最大值 / 强度",
                    description = "动态市场 / 趋势 / 最大值 / 强度的运行设置。",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "动态市场 / 趋势 / 最小值 / 强度",
                    description = "动态市场 / 趋势 / 最小值 / 强度的运行设置。",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "动态市场 / 更新 / 分钟",
                    description = "动态市场 / 更新 / 分钟的运行设置。",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "动态市场 / 价格波动 / 最大值",
                    description = "动态市场 / 价格波动 / 最大值的运行设置。",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "动态市场 / 价格波动 / 最小值",
                    description = "动态市场 / 价格波动 / 最小值的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "动态市场 / 天气 / 倍率 / 寒冷",
                    description = "动态市场 / 天气 / 倍率 / 寒冷的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "动态市场 / 天气 / 倍率 / 热浪",
                    description = "动态市场 / 天气 / 倍率 / 热浪的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "动态市场 / 天气 / 倍率 / 普通",
                    description = "动态市场 / 天气 / 倍率 / 普通的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "动态市场 / 天气 / 倍率 / 雨",
                    description = "动态市场 / 天气 / 倍率 / 雨的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "动态市场 / 天气 / 倍率 / 风暴",
                    description = "动态市场 / 天气 / 倍率 / 风暴的运行设置。",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "动态市场 / 天气 / 状态",
                    description = "动态市场 / 天气 / 状态的运行设置。",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "警方关注与风险 / 动作冷却时间 / 秒",
                    description = "警方关注与风险 / 动作冷却时间 / 秒的运行设置。",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "警方关注与风险 / 活动 / 风险 / 权重 / 数量",
                    description = "警方关注与风险 / 活动 / 风险 / 权重 / 数量的运行设置。",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "警方关注与风险 / 活动 / 风险 / 权重 / 时长 / 分钟",
                    description = "警方关注与风险 / 活动 / 风险 / 权重 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "警方关注与风险 / 活动 / 风险 / 权重 / 警力压力",
                    description = "警方关注与风险 / 活动 / 风险 / 权重 / 警力压力的运行设置。",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "警方关注与风险 / 活动 / 风险 / 权重 / 声望",
                    description = "警方关注与风险 / 活动 / 风险 / 权重 / 声望的运行设置。",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "警方关注与风险 / 活动 / 风险 / 权重 / 安全",
                    description = "警方关注与风险 / 活动 / 风险 / 权重 / 安全的运行设置。",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "警方关注与风险 / 激进模式 / 警方关注度 / 倍率",
                    description = "警方关注与风险 / 激进模式 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "警方关注与风险 / 一次性手机 / 暴露 / 阈值",
                    description = "警方关注与风险 / 一次性手机 / 暴露 / 阈值的运行设置。",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "警方关注与风险 / 一次性手机 / 警方关注度 / 每笔批发交易",
                    description = "警方关注与风险 / 一次性手机 / 警方关注度 / 每笔批发交易的运行设置。",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "警方关注与风险 / 一次性手机 / 物品",
                    description = "警方关注与风险 / 一次性手机 / 物品的运行设置。",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "警方关注与风险 / 运行中的房车 / 警方关注度 / 倍率",
                    description = "警方关注与风险 / 运行中的房车 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "警方关注与风险 / 运行中的房车 / 警方关注度 / 阈值",
                    description = "警方关注与风险 / 运行中的房车 / 警方关注度 / 阈值的运行设置。",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "警方关注与风险 / 停放中的房车 / 警方关注度",
                    description = "警方关注与风险 / 停放中的房车 / 警方关注度的运行设置。",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "警方关注与风险 / 污染 / 警方关注度 / 倍率",
                    description = "警方关注与风险 / 污染 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "警方关注与风险 / 污染 / 阈值",
                    description = "警方关注与风险 / 污染 / 阈值的运行设置。",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "警方关注与风险 / 种植 / 不增加风险的植物",
                    description = "警方关注与风险 / 种植 / 不增加风险的植物的运行设置。",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "警方关注与风险 / 种植 / 警方关注度 / 每株植物",
                    description = "警方关注与风险 / 种植 / 警方关注度 / 每株植物的运行设置。",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "警方关注与风险 / 经销商 / 隐藏 / 分钟",
                    description = "警方关注与风险 / 经销商 / 隐藏 / 分钟的运行设置。",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 批次",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 批次的运行设置。",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 房车",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 房车的运行设置。",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 经销商",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 经销商的运行设置。",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 帮派",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 帮派的运行设置。",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 分销中心",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 分销中心的运行设置。",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 实验室",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 实验室的运行设置。",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 玩家",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 玩家的运行设置。",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 路线",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 路线的运行设置。",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "警方关注与风险 / 衰减 / 每次更新 / 区域",
                    description = "警方关注与风险 / 衰减 / 每次更新 / 区域的运行设置。",
                },
                drugAdvancedHeatEnabled = {
                    label = "警方关注与风险 / 启用",
                    description = "警方关注与风险 / 启用的运行设置。",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "警方关注与风险 / 警方存在 / 警方关注度 / 临界",
                    description = "警方关注与风险 / 警方存在 / 警方关注度 / 临界的运行设置。",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "警方关注与风险 / 警方存在 / 警方关注度 / 高",
                    description = "警方关注与风险 / 警方存在 / 警方关注度 / 高的运行设置。",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "警方关注与风险 / 警方存在 / 警方关注度 / 低",
                    description = "警方关注与风险 / 警方存在 / 警方关注度 / 低的运行设置。",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "警方关注与风险 / 警方存在 / 警方关注度 / 中",
                    description = "警方关注与风险 / 警方存在 / 警方关注度 / 中的运行设置。",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "警方关注与风险 / 警方存在 / 倍率 / 批次",
                    description = "警方关注与风险 / 警方存在 / 倍率 / 批次的运行设置。",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "警方关注与风险 / 警方存在 / 倍率 / 帮派",
                    description = "警方关注与风险 / 警方存在 / 倍率 / 帮派的运行设置。",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "警方关注与风险 / 警方存在 / 倍率 / 区域",
                    description = "警方关注与风险 / 警方存在 / 倍率 / 区域的运行设置。",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 批次",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 批次的运行设置。",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 房车",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 房车的运行设置。",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 经销商",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 经销商的运行设置。",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 帮派",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 帮派的运行设置。",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 分销中心",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 分销中心的运行设置。",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 实验室",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 实验室的运行设置。",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 玩家",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 玩家的运行设置。",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 路线",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 路线的运行设置。",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "警方关注与风险 / 游戏实体 / 类型 / 区域",
                    description = "警方关注与风险 / 游戏实体 / 类型 / 区域的运行设置。",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "警方关注与风险 / 事件 / 冷却分钟数",
                    description = "警方关注与风险 / 事件 / 冷却分钟数的运行设置。",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "警方关注与风险 / 事件 / 历史记录上限",
                    description = "警方关注与风险 / 事件 / 历史记录上限的运行设置。",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "警方关注与风险 / 实验室 / 警方关注度 / 同步 / 阈值",
                    description = "警方关注与风险 / 实验室 / 警方关注度 / 同步 / 阈值的运行设置。",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "警方关注与风险 / 避风头 / 冷却分钟数",
                    description = "警方关注与风险 / 避风头 / 冷却分钟数的运行设置。",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "警方关注与风险 / 避风头 / 空闲 / 分钟",
                    description = "警方关注与风险 / 避风头 / 空闲 / 分钟的运行设置。",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "警方关注与风险 / 避风头 / 减少量",
                    description = "警方关注与风险 / 避风头 / 减少量的运行设置。",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "警方关注与风险 / 封锁 / 分钟",
                    description = "警方关注与风险 / 封锁 / 分钟的运行设置。",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "警方关注与风险 / 最小值 / 时长 / 分钟",
                    description = "警方关注与风险 / 最小值 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "警方关注与风险 / 最小值 / 事件 / 冷却时间（秒）",
                    description = "警方关注与风险 / 最小值 / 事件 / 冷却时间（秒）的运行设置。",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "警方关注与风险 / 最小值 / 空闲 / 秒",
                    description = "警方关注与风险 / 最小值 / 空闲 / 秒的运行设置。",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "警方关注与风险 / 加工 / 警方关注度 / 倍率",
                    description = "警方关注与风险 / 加工 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "警方关注与风险 / 风险 / 权重 / 批次",
                    description = "警方关注与风险 / 风险 / 权重 / 批次的运行设置。",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "警方关注与风险 / 风险 / 权重 / 房车",
                    description = "警方关注与风险 / 风险 / 权重 / 房车的运行设置。",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "警方关注与风险 / 风险 / 权重 / 经销商",
                    description = "警方关注与风险 / 风险 / 权重 / 经销商的运行设置。",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "警方关注与风险 / 风险 / 权重 / 帮派",
                    description = "警方关注与风险 / 风险 / 权重 / 帮派的运行设置。",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "警方关注与风险 / 风险 / 权重 / 分销中心",
                    description = "警方关注与风险 / 风险 / 权重 / 分销中心的运行设置。",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "警方关注与风险 / 风险 / 权重 / 实验室",
                    description = "警方关注与风险 / 风险 / 权重 / 实验室的运行设置。",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "警方关注与风险 / 风险 / 权重 / 玩家",
                    description = "警方关注与风险 / 风险 / 权重 / 玩家的运行设置。",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "警方关注与风险 / 风险 / 权重 / 路线",
                    description = "警方关注与风险 / 风险 / 权重 / 路线的运行设置。",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "警方关注与风险 / 风险 / 权重 / 区域",
                    description = "警方关注与风险 / 风险 / 权重 / 区域的运行设置。",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "警方关注与风险 / 更换一次性手机 / 减少量",
                    description = "警方关注与风险 / 更换一次性手机 / 减少量的运行设置。",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "警方关注与风险 / 路线 / 控制 / 分钟",
                    description = "警方关注与风险 / 路线 / 控制 / 分钟的运行设置。",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 批次",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 批次的运行设置。",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 房车",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 房车的运行设置。",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 经销商",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 经销商的运行设置。",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 帮派",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 帮派的运行设置。",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 分销中心",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 分销中心的运行设置。",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 实验室",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 实验室的运行设置。",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 玩家",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 玩家的运行设置。",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 路线",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 路线的运行设置。",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "警方关注与风险 / 销售 / 警方关注度 / 区域",
                    description = "警方关注与风险 / 销售 / 警方关注度 / 区域的运行设置。",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "警方关注与风险 / 阈值 / 临界",
                    description = "警方关注与风险 / 阈值 / 临界的运行设置。",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "警方关注与风险 / 阈值 / 高",
                    description = "警方关注与风险 / 阈值 / 高的运行设置。",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "警方关注与风险 / 阈值 / 封锁",
                    description = "警方关注与风险 / 阈值 / 封锁的运行设置。",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "警方关注与风险 / 阈值 / 低",
                    description = "警方关注与风险 / 阈值 / 低的运行设置。",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "警方关注与风险 / 阈值 / 中",
                    description = "警方关注与风险 / 阈值 / 中的运行设置。",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "警方关注与风险 / 更新周期 / 分钟",
                    description = "警方关注与风险 / 更新周期 / 分钟的运行设置。",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "警方关注与风险 / 批发 / 警方关注度 / 倍率",
                    description = "警方关注与风险 / 批发 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 警报半径",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 警报半径的运行设置。",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 基础值 / 概率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 基础值 / 概率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 帮派 / 倍率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 帮派 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 高 / 严重程度 / 阈值",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 高 / 严重程度 / 阈值的运行设置。",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 概率 / 倍率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 概率 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 阈值",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 忠诚度 / 阈值的运行设置。",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 最大值 / 概率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 最大值 / 概率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 最小值 / 冷却时间（秒）",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 最小值 / 冷却时间（秒）的运行设置。",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 路线 / 倍率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 路线 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最大值",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最大值的运行设置。",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最小值",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 最小值的运行设置。",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 倍率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 强度 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 概率 / 倍率",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 概率 / 倍率的运行设置。",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 阈值",
                    description = "警方关注与风险 / 工人 / 信息泄露 / 压力 / 阈值的运行设置。",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "联系人网络 / 动作冷却时间 / 秒",
                    description = "联系人网络 / 动作冷却时间 / 秒的运行设置。",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "联系人网络 / 活跃热点数量",
                    description = "联系人网络 / 活跃热点数量的运行设置。",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "联系人网络 / 临时手机提示 / 信任",
                    description = "联系人网络 / 临时手机提示 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "联系人网络 / 一次性手机 / 报价 / 最大值 / 倍率",
                    description = "联系人网络 / 一次性手机 / 报价 / 最大值 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "联系人网络 / 一次性手机 / 报价 / 最小值 / 倍率",
                    description = "联系人网络 / 一次性手机 / 报价 / 最小值 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "联系人网络 / 买家 / 冷却分钟数",
                    description = "联系人网络 / 买家 / 冷却分钟数的运行设置。",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "联系人网络 / 买家 / 送达距离",
                    description = "联系人网络 / 买家 / 送达距离的运行设置。",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "联系人网络 / 买家 / 高级 / 成功 / 分数",
                    description = "联系人网络 / 买家 / 高级 / 成功 / 分数的运行设置。",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "联系人网络 / 买家 / 高级 / 信任 / 增益",
                    description = "联系人网络 / 买家 / 高级 / 信任 / 增益的运行设置。",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "联系人网络 / 买家 / 请求 / 热度与风险 / 权重",
                    description = "联系人网络 / 买家 / 请求 / 热度与风险 / 权重的运行设置。",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "联系人网络 / 买家 / 标准型 / 信任 / 增益",
                    description = "联系人网络 / 买家 / 标准型 / 信任 / 增益的运行设置。",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "联系人网络 / 联系人激活延迟 / 秒 / 最大值",
                    description = "联系人网络 / 联系人激活延迟 / 秒 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "联系人网络 / 联系人激活延迟 / 秒 / 最小值",
                    description = "联系人网络 / 联系人激活延迟 / 秒 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "联系人网络 / 联系方式 / 需求 / 数值范围 / 最大值",
                    description = "联系人网络 / 联系方式 / 需求 / 数值范围 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "联系人网络 / 联系方式 / 需求 / 数值范围 / 最小值",
                    description = "联系人网络 / 联系方式 / 需求 / 数值范围 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "联系人网络 / 联系方式 / 亏损 / 信任",
                    description = "联系人网络 / 联系方式 / 亏损 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "联系人网络 / 暗网 / 精确情报 / 分钟",
                    description = "联系人网络 / 暗网 / 精确情报 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "联系人网络 / 暗网 / 热点 / 情报 / 价格",
                    description = "联系人网络 / 暗网 / 热点 / 情报 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "联系人网络 / 暗网 / 情报 / 价格",
                    description = "联系人网络 / 暗网 / 情报 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "联系人网络 / 经销商 / 基础价格",
                    description = "联系人网络 / 经销商 / 基础价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "联系人网络 / 经销商 / 雇用 / 容量 / 最大值",
                    description = "联系人网络 / 经销商 / 雇用 / 容量 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "联系人网络 / 经销商 / 雇用 / 容量 / 最小值",
                    description = "联系人网络 / 经销商 / 雇用 / 容量 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "联系人网络 / 经销商 / 雇用 / 风险 / 最大值",
                    description = "联系人网络 / 经销商 / 雇用 / 风险 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "联系人网络 / 经销商 / 雇用 / 风险 / 最小值",
                    description = "联系人网络 / 经销商 / 雇用 / 风险 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "联系人网络 / 经销商 / 雇用 / 技能 / 最大值",
                    description = "联系人网络 / 经销商 / 雇用 / 技能 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "联系人网络 / 经销商 / 雇用 / 技能 / 最小值",
                    description = "联系人网络 / 经销商 / 雇用 / 技能 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "联系人网络 / 经销商报价 / 1 / ID",
                    description = "联系人网络 / 经销商报价 / 1 / ID的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "联系人网络 / 经销商报价 / 1 / 物品",
                    description = "联系人网络 / 经销商报价 / 1 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "联系人网络 / 经销商报价 / 1 / 标签",
                    description = "联系人网络 / 经销商报价 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "联系人网络 / 经销商报价 / 1 / 最低信任度",
                    description = "联系人网络 / 经销商报价 / 1 / 最低信任度的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "联系人网络 / 经销商报价 / 1 / 价格",
                    description = "联系人网络 / 经销商报价 / 1 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "联系人网络 / 经销商报价 / 2 / ID",
                    description = "联系人网络 / 经销商报价 / 2 / ID的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "联系人网络 / 经销商报价 / 2 / 物品",
                    description = "联系人网络 / 经销商报价 / 2 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "联系人网络 / 经销商报价 / 2 / 标签",
                    description = "联系人网络 / 经销商报价 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "联系人网络 / 经销商报价 / 2 / 最低信任度",
                    description = "联系人网络 / 经销商报价 / 2 / 最低信任度的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "联系人网络 / 经销商报价 / 2 / 价格",
                    description = "联系人网络 / 经销商报价 / 2 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "联系人网络 / 经销商报价 / 3 / ID",
                    description = "联系人网络 / 经销商报价 / 3 / ID的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "联系人网络 / 经销商报价 / 3 / 物品",
                    description = "联系人网络 / 经销商报价 / 3 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "联系人网络 / 经销商报价 / 3 / 标签",
                    description = "联系人网络 / 经销商报价 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "联系人网络 / 经销商报价 / 3 / 最低信任度",
                    description = "联系人网络 / 经销商报价 / 3 / 最低信任度的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "联系人网络 / 经销商报价 / 3 / 价格",
                    description = "联系人网络 / 经销商报价 / 3 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "联系人网络 / 经销商报价 / 4 / ID",
                    description = "联系人网络 / 经销商报价 / 4 / ID的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "联系人网络 / 经销商报价 / 4 / 物品",
                    description = "联系人网络 / 经销商报价 / 4 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "联系人网络 / 经销商报价 / 4 / 标签",
                    description = "联系人网络 / 经销商报价 / 4 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "联系人网络 / 经销商报价 / 4 / 最低信任度",
                    description = "联系人网络 / 经销商报价 / 4 / 最低信任度的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "联系人网络 / 经销商报价 / 4 / 价格",
                    description = "联系人网络 / 经销商报价 / 4 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "联系人网络 / 经销商报价 / 5 / ID",
                    description = "联系人网络 / 经销商报价 / 5 / ID的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "联系人网络 / 经销商报价 / 5 / 物品",
                    description = "联系人网络 / 经销商报价 / 5 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "联系人网络 / 经销商报价 / 5 / 标签",
                    description = "联系人网络 / 经销商报价 / 5 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "联系人网络 / 经销商报价 / 5 / 最低信任度",
                    description = "联系人网络 / 经销商报价 / 5 / 最低信任度的运行设置。",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "联系人网络 / 经销商报价 / 5 / 价格",
                    description = "联系人网络 / 经销商报价 / 5 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "联系人网络 / 经销商 / 保护 / 小时",
                    description = "联系人网络 / 经销商 / 保护 / 小时的运行设置。",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "联系人网络 / 经销商 / 保护 / 价格",
                    description = "联系人网络 / 经销商 / 保护 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "联系人网络 / 经销商 / 销售 / 最大值",
                    description = "联系人网络 / 经销商 / 销售 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "联系人网络 / 经销商 / 销售 / 最小值",
                    description = "联系人网络 / 经销商 / 销售 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "联系人网络 / 经销商 / 模拟 / 激进模式 / 价格倍数",
                    description = "联系人网络 / 经销商 / 模拟 / 激进模式 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "联系人网络 / 经销商 / 模拟 / 基础质量 / 价格系数",
                    description = "联系人网络 / 经销商 / 模拟 / 基础质量 / 价格系数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "联系人网络 / 经销商 / 模拟 / 大宗 / 价格倍数",
                    description = "联系人网络 / 经销商 / 模拟 / 大宗 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "联系人网络 / 经销商 / 模拟 / 低价销售 / 价格倍数",
                    description = "联系人网络 / 经销商 / 模拟 / 低价销售 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "联系人网络 / 经销商 / 模拟 / 默认值 / 质量",
                    description = "联系人网络 / 经销商 / 模拟 / 默认值 / 质量的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "联系人网络 / 经销商 / 模拟 / 不忠阈值",
                    description = "联系人网络 / 经销商 / 模拟 / 不忠阈值的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "联系人网络 / 经销商 / 模拟 / 经验 / 每级",
                    description = "联系人网络 / 经销商 / 模拟 / 经验 / 每级的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "联系人网络 / 经销商 / 模拟 / 经验 / 每单位",
                    description = "联系人网络 / 经销商 / 模拟 / 经验 / 每单位的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "联系人网络 / 经销商 / 模拟 / 事件 / 忠诚度 / 亏损",
                    description = "联系人网络 / 经销商 / 模拟 / 事件 / 忠诚度 / 亏损的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "联系人网络 / 经销商 / 模拟 / 事件 / 随机判定 / 最大值",
                    description = "联系人网络 / 经销商 / 模拟 / 事件 / 随机判定 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "联系人网络 / 经销商 / 模拟 / 层级 / 价格 / 奖金",
                    description = "联系人网络 / 经销商 / 模拟 / 层级 / 价格 / 奖金的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "联系人网络 / 经销商 / 模拟 / 层级 / 销售 / 除数",
                    description = "联系人网络 / 经销商 / 模拟 / 层级 / 销售 / 除数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "联系人网络 / 经销商 / 模拟 / 忠诚度 / 风险 / 权重",
                    description = "联系人网络 / 经销商 / 模拟 / 忠诚度 / 风险 / 权重的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "联系人网络 / 经销商 / 模拟 / 最大值 / 事件 / 概率",
                    description = "联系人网络 / 经销商 / 模拟 / 最大值 / 事件 / 概率的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "联系人网络 / 经销商 / 模拟 / 最大值 / 层级",
                    description = "联系人网络 / 经销商 / 模拟 / 最大值 / 层级的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "联系人网络 / 经销商 / 模拟 / 高级 / 价格倍数",
                    description = "联系人网络 / 经销商 / 模拟 / 高级 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "联系人网络 / 经销商 / 模拟 / 简介 / 风险 / 权重",
                    description = "联系人网络 / 经销商 / 模拟 / 简介 / 风险 / 权重的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "联系人网络 / 经销商 / 模拟 / 保护 / 风险 / 减少量",
                    description = "联系人网络 / 经销商 / 模拟 / 保护 / 风险 / 减少量的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "联系人网络 / 经销商 / 模拟 / 质量 / 价格 / 除数",
                    description = "联系人网络 / 经销商 / 模拟 / 质量 / 价格 / 除数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "联系人网络 / 经销商 / 模拟 / 恢复 / 基础值 / 概率",
                    description = "联系人网络 / 经销商 / 模拟 / 恢复 / 基础值 / 概率的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "联系人网络 / 经销商 / 模拟 / 恢复 / 忠诚度 / 权重",
                    description = "联系人网络 / 经销商 / 模拟 / 恢复 / 忠诚度 / 权重的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "联系人网络 / 经销商 / 模拟 / 被抢造成的库存损失",
                    description = "联系人网络 / 经销商 / 模拟 / 被抢造成的库存损失的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "联系人网络 / 经销商 / 模拟 / 技能 / 风险 / 减少量",
                    description = "联系人网络 / 经销商 / 模拟 / 技能 / 风险 / 减少量的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "联系人网络 / 经销商 / 模拟 / 技能 / 销售 / 除数",
                    description = "联系人网络 / 经销商 / 模拟 / 技能 / 销售 / 除数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "联系人网络 / 经销商 / 模拟 / 稳定忠诚阈值",
                    description = "联系人网络 / 经销商 / 模拟 / 稳定忠诚阈值的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "联系人网络 / 经销商 / 模拟 / 领地 / 价格倍数",
                    description = "联系人网络 / 经销商 / 模拟 / 领地 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "联系人网络 / 经销商 / 模拟 / 领地 / 风险 / 减少量",
                    description = "联系人网络 / 经销商 / 模拟 / 领地 / 风险 / 减少量的运行设置。",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "联系人网络 / 经销商 / 更新周期 / 分钟",
                    description = "联系人网络 / 经销商 / 更新周期 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "联系人网络 / 经销商 / 工资",
                    description = "联系人网络 / 经销商 / 工资的运行设置。",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "联系人网络 / 经销商 / 工资 / 衰减",
                    description = "联系人网络 / 经销商 / 工资 / 衰减的运行设置。",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "联系人网络 / 经销商 / 工资 / 忠诚度 / 增益",
                    description = "联系人网络 / 经销商 / 工资 / 忠诚度 / 增益的运行设置。",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "联系人网络 / 经销商 / 弱点 / 1",
                    description = "联系人网络 / 经销商 / 弱点 / 1的运行设置。",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "联系人网络 / 经销商 / 弱点 / 2",
                    description = "联系人网络 / 经销商 / 弱点 / 2的运行设置。",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "联系人网络 / 经销商 / 弱点 / 3",
                    description = "联系人网络 / 经销商 / 弱点 / 3的运行设置。",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "联系人网络 / 经销商 / 弱点 / 4",
                    description = "联系人网络 / 经销商 / 弱点 / 4的运行设置。",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "联系人网络 / 经销商 / 弱点 / 5",
                    description = "联系人网络 / 经销商 / 弱点 / 5的运行设置。",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "联系人网络 / 默认值 / 联系方式 / 需求",
                    description = "联系人网络 / 默认值 / 联系方式 / 需求的运行设置。",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "联系人网络 / 默认值 / 联系方式 / 风险",
                    description = "联系人网络 / 默认值 / 联系方式 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "联系人网络 / 默认贩子 / 容量",
                    description = "联系人网络 / 默认贩子 / 容量的运行设置。",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "联系人网络 / 默认贩子 / 风险",
                    description = "联系人网络 / 默认贩子 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "联系人网络 / 默认贩子 / 技能",
                    description = "联系人网络 / 默认贩子 / 技能的运行设置。",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "联系人网络 / 默认值 / 热点 / 半径",
                    description = "联系人网络 / 默认值 / 热点 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "联系人网络 / 需求重置（分钟）",
                    description = "联系人网络 / 需求重置（分钟）的运行设置。",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "联系人网络 / 启用",
                    description = "联系人网络 / 启用的运行设置。",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "联系人网络 / 精确位置 / 信任",
                    description = "联系人网络 / 精确位置 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "联系人网络 / 帮派 / 发现 / 声望",
                    description = "联系人网络 / 帮派 / 发现 / 声望的运行设置。",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "联系人网络 / 帮派 / 线索 / 信任",
                    description = "联系人网络 / 帮派 / 线索 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "联系人网络 / 交付失败 / 冷却分钟数",
                    description = "联系人网络 / 交付失败 / 冷却分钟数的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 数量",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 数量的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 1",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 1的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 2",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 2的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 3",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 攻击者 / 模型 / 3的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 持续时间（秒）",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 持续时间（秒）的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 1",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 1的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 2",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 2的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 3",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 警察 / 模型 / 3的运行设置。",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "联系人网络 / 虚假交易 / 遭遇 / 生成半径",
                    description = "联系人网络 / 虚假交易 / 遭遇 / 生成半径的运行设置。",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "联系人网络 / 备用值 / 首选毒品",
                    description = "联系人网络 / 备用值 / 首选毒品的运行设置。",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "联系人网络 / 备用值 / 产品名称",
                    description = "联系人网络 / 备用值 / 产品名称的运行设置。",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "联系人网络 / 指南 / 书籍 / 物品",
                    description = "联系人网络 / 指南 / 书籍 / 物品的运行设置。",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "联系人网络 / 指南 / 书籍 / 信任",
                    description = "联系人网络 / 指南 / 书籍 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "联系人网络 / 雇佣代理商 / 价格",
                    description = "联系人网络 / 雇佣代理商 / 价格的运行设置。",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "联系人网络 / 历史记录上限",
                    description = "联系人网络 / 历史记录上限的运行设置。",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "联系人网络 / 热点 / 情报 / 分钟",
                    description = "联系人网络 / 热点 / 情报 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "联系人网络 / 热点 / 轮换 / 分钟",
                    description = "联系人网络 / 热点 / 轮换 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "联系人网络 / 上架商品 / 时长 / 分钟",
                    description = "联系人网络 / 上架商品 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "联系人网络 / 最大值 / 已持有 / 毒贩",
                    description = "联系人网络 / 最大值 / 已持有 / 毒贩的运行设置。",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "联系人网络 / 最小值 / 买家 / 送达距离",
                    description = "联系人网络 / 最小值 / 买家 / 送达距离的运行设置。",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "联系人网络 / 最小值 / 接触轮换（分钟）",
                    description = "联系人网络 / 最小值 / 接触轮换（分钟）的运行设置。",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "联系人网络 / 最小值 / 需求重置（分钟）",
                    description = "联系人网络 / 最小值 / 需求重置（分钟）的运行设置。",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "联系人网络 / 最小值 / 警方关注度 / 倍率",
                    description = "联系人网络 / 最小值 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "联系人网络 / 最小值 / 热点 / 情报 / 分钟",
                    description = "联系人网络 / 最小值 / 热点 / 情报 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "联系人网络 / 最小值 / 热点 / 半径",
                    description = "联系人网络 / 最小值 / 热点 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "联系人网络 / 最小值 / 热点 / 轮换 / 分钟",
                    description = "联系人网络 / 最小值 / 热点 / 轮换 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "联系人网络 / 最小值 / 上架商品 / 时长 / 分钟",
                    description = "联系人网络 / 最小值 / 上架商品 / 时长 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "联系人网络 / 最低奖励 / 倍率",
                    description = "联系人网络 / 最低奖励 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "联系人网络 / 最小值 / 抢劫 / 倍率",
                    description = "联系人网络 / 最小值 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "联系人网络 / 最小值 / 地点 / 价格倍数",
                    description = "联系人网络 / 最小值 / 地点 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "联系人网络 / 其他 / 毒品 / 价格倍数",
                    description = "联系人网络 / 其他 / 毒品 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "联系人网络 / 付款账户",
                    description = "联系人网络 / 付款账户的运行设置。",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "联系人网络 / 交付后 / 需求 / Reset / 秒",
                    description = "联系人网络 / 交付后 / 需求 / Reset / 秒的运行设置。",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "联系人网络 / 首选毒品 / 价格倍数",
                    description = "联系人网络 / 首选毒品 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "联系人网络 / 地区 / 地点 / 信任",
                    description = "联系人网络 / 地区 / 地点 / 信任的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "联系人网络 / 请求 / 数量 / 大宗 / 最大值",
                    description = "联系人网络 / 请求 / 数量 / 大宗 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "联系人网络 / 请求 / 数量 / 大宗 / 最小值",
                    description = "联系人网络 / 请求 / 数量 / 大宗 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "联系人网络 / 请求 / 数量 / 高级 / 最大值",
                    description = "联系人网络 / 请求 / 数量 / 高级 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "联系人网络 / 请求 / 数量 / 高级 / 最小值",
                    description = "联系人网络 / 请求 / 数量 / 高级 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "联系人网络 / 请求 / 数量 / 标准型 / 最大值",
                    description = "联系人网络 / 请求 / 数量 / 标准型 / 最大值的运行设置。",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "联系人网络 / 请求 / 数量 / 标准型 / 最小值",
                    description = "联系人网络 / 请求 / 数量 / 标准型 / 最小值的运行设置。",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "联系人网络 / 轮换 / 分钟",
                    description = "联系人网络 / 轮换 / 分钟的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 街头贩子 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认买家 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 默认贩子 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 网络贩子 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 高级中间人 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 1 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 2 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / X",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / 是",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / Z",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / W",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 坐标 / W的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 标签",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 价格倍数",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 地区",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 风险",
                    description = "联系人网络 / 地点 / 候选池 / 批发联系人 / 3 / 风险的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 接受奖励",
                    description = "联系人网络 / 街道 / 热点 / 1 / 接受奖励的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 基础类型",
                    description = "联系人网络 / 街道 / 热点 / 1 / 基础类型的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 坐标 / X",
                    description = "联系人网络 / 街道 / 热点 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 坐标 / 是",
                    description = "联系人网络 / 街道 / 热点 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 坐标 / Z",
                    description = "联系人网络 / 街道 / 热点 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 需求加成",
                    description = "联系人网络 / 街道 / 热点 / 1 / 需求加成的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 警方关注度 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 1 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "联系人网络 / 街道 / 热点 / 1 / ID",
                    description = "联系人网络 / 街道 / 热点 / 1 / ID的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 标签",
                    description = "联系人网络 / 街道 / 热点 / 1 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 1",
                    description = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 1的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 2",
                    description = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 2的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 3",
                    description = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 3的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 4",
                    description = "联系人网络 / 街道 / 热点 / 1 / 偏好毒品 / 4的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 价格倍数",
                    description = "联系人网络 / 街道 / 热点 / 1 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 半径",
                    description = "联系人网络 / 街道 / 热点 / 1 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 地区",
                    description = "联系人网络 / 街道 / 热点 / 1 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 1 / 抢劫 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 1 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 接受奖励",
                    description = "联系人网络 / 街道 / 热点 / 2 / 接受奖励的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 基础类型",
                    description = "联系人网络 / 街道 / 热点 / 2 / 基础类型的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 坐标 / X",
                    description = "联系人网络 / 街道 / 热点 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 坐标 / 是",
                    description = "联系人网络 / 街道 / 热点 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 坐标 / Z",
                    description = "联系人网络 / 街道 / 热点 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 需求加成",
                    description = "联系人网络 / 街道 / 热点 / 2 / 需求加成的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 警方关注度 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 2 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "联系人网络 / 街道 / 热点 / 2 / ID",
                    description = "联系人网络 / 街道 / 热点 / 2 / ID的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 标签",
                    description = "联系人网络 / 街道 / 热点 / 2 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 最低质量",
                    description = "联系人网络 / 街道 / 热点 / 2 / 最低质量的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 偏好毒品 / 1",
                    description = "联系人网络 / 街道 / 热点 / 2 / 偏好毒品 / 1的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 偏好毒品 / 2",
                    description = "联系人网络 / 街道 / 热点 / 2 / 偏好毒品 / 2的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 价格倍数",
                    description = "联系人网络 / 街道 / 热点 / 2 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 半径",
                    description = "联系人网络 / 街道 / 热点 / 2 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 地区",
                    description = "联系人网络 / 街道 / 热点 / 2 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 2 / 抢劫 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 2 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 接受奖励",
                    description = "联系人网络 / 街道 / 热点 / 3 / 接受奖励的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 基础类型",
                    description = "联系人网络 / 街道 / 热点 / 3 / 基础类型的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 坐标 / X",
                    description = "联系人网络 / 街道 / 热点 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 坐标 / 是",
                    description = "联系人网络 / 街道 / 热点 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 坐标 / Z",
                    description = "联系人网络 / 街道 / 热点 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 需求加成",
                    description = "联系人网络 / 街道 / 热点 / 3 / 需求加成的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 警方关注度 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 3 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "联系人网络 / 街道 / 热点 / 3 / ID",
                    description = "联系人网络 / 街道 / 热点 / 3 / ID的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 标签",
                    description = "联系人网络 / 街道 / 热点 / 3 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 1",
                    description = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 1的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 2",
                    description = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 2的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 3",
                    description = "联系人网络 / 街道 / 热点 / 3 / 偏好毒品 / 3的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 价格倍数",
                    description = "联系人网络 / 街道 / 热点 / 3 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 半径",
                    description = "联系人网络 / 街道 / 热点 / 3 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 地区",
                    description = "联系人网络 / 街道 / 热点 / 3 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 3 / 抢劫 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 3 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 接受奖励",
                    description = "联系人网络 / 街道 / 热点 / 4 / 接受奖励的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 基础类型",
                    description = "联系人网络 / 街道 / 热点 / 4 / 基础类型的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 坐标 / X",
                    description = "联系人网络 / 街道 / 热点 / 4 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 坐标 / 是",
                    description = "联系人网络 / 街道 / 热点 / 4 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 坐标 / Z",
                    description = "联系人网络 / 街道 / 热点 / 4 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 需求加成",
                    description = "联系人网络 / 街道 / 热点 / 4 / 需求加成的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 警方关注度 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 4 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "联系人网络 / 街道 / 热点 / 4 / ID",
                    description = "联系人网络 / 街道 / 热点 / 4 / ID的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 标签",
                    description = "联系人网络 / 街道 / 热点 / 4 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 1",
                    description = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 1的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 2",
                    description = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 2的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 3",
                    description = "联系人网络 / 街道 / 热点 / 4 / 偏好毒品 / 3的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 价格倍数",
                    description = "联系人网络 / 街道 / 热点 / 4 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 半径",
                    description = "联系人网络 / 街道 / 热点 / 4 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 地区",
                    description = "联系人网络 / 街道 / 热点 / 4 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 4 / 抢劫 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 4 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 接受奖励",
                    description = "联系人网络 / 街道 / 热点 / 5 / 接受奖励的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 基础类型",
                    description = "联系人网络 / 街道 / 热点 / 5 / 基础类型的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 坐标 / X",
                    description = "联系人网络 / 街道 / 热点 / 5 / 坐标 / X的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 坐标 / 是",
                    description = "联系人网络 / 街道 / 热点 / 5 / 坐标 / 是的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 坐标 / Z",
                    description = "联系人网络 / 街道 / 热点 / 5 / 坐标 / Z的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 需求加成",
                    description = "联系人网络 / 街道 / 热点 / 5 / 需求加成的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 警方关注度 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 5 / 警方关注度 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "联系人网络 / 街道 / 热点 / 5 / ID",
                    description = "联系人网络 / 街道 / 热点 / 5 / ID的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 标签",
                    description = "联系人网络 / 街道 / 热点 / 5 / 标签的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 偏好毒品 / 1",
                    description = "联系人网络 / 街道 / 热点 / 5 / 偏好毒品 / 1的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 偏好毒品 / 2",
                    description = "联系人网络 / 街道 / 热点 / 5 / 偏好毒品 / 2的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 价格倍数",
                    description = "联系人网络 / 街道 / 热点 / 5 / 价格倍数的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 半径",
                    description = "联系人网络 / 街道 / 热点 / 5 / 半径的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 地区",
                    description = "联系人网络 / 街道 / 热点 / 5 / 地区的运行设置。",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "联系人网络 / 街道 / 热点 / 5 / 抢劫 / 倍率",
                    description = "联系人网络 / 街道 / 热点 / 5 / 抢劫 / 倍率的运行设置。",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "联系人网络 / 信任 / 等级 / 已知",
                    description = "联系人网络 / 信任 / 等级 / 已知的运行设置。",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "联系人网络 / 信任 / 等级 / 可靠",
                    description = "联系人网络 / 信任 / 等级 / 可靠的运行设置。",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "联系人网络 / 信任 / 等级 / 值得信赖",
                    description = "联系人网络 / 信任 / 等级 / 值得信赖的运行设置。",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "商业网络 / 动作冷却时间 / 秒",
                    description = "商业网络 / 动作冷却时间 / 秒的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "商业网络 / 余额 / 基础值 / 单价",
                    description = "商业网络 / 余额 / 基础值 / 单价的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "商业网络 / 余额 / 网络热度 / 每名贩子",
                    description = "商业网络 / 余额 / 网络热度 / 每名贩子的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "商业网络 / 余额 / 网络热度 / 每个配送中心",
                    description = "商业网络 / 余额 / 网络热度 / 每个配送中心的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "商业网络 / 余额 / 网络热度 / 每条路线",
                    description = "商业网络 / 余额 / 网络热度 / 每条路线的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "商业网络 / 余额 / 网络热度 / 每名员工",
                    description = "商业网络 / 余额 / 网络热度 / 每名员工的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "商业网络 / 余额 / 可靠性 / 增益",
                    description = "商业网络 / 余额 / 可靠性 / 增益的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "商业网络 / 余额 / 可靠性 / 亏损",
                    description = "商业网络 / 余额 / 可靠性 / 亏损的运行设置。",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "商业网络 / 余额 / 路线 / 警方关注度 / 衰减",
                    description = "商业网络 / 余额 / 路线 / 警方关注度 / 衰减的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 帮派 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 帮派 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / NPC网络 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / NPC网络 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 组织 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 组织 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 组织 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 组织 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 组织 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 组织 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 组织 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 组织 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 组织 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 组织 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 高级 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 高级 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 高级 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 高级 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 高级 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 高级 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 高级 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 高级 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 高级 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 高级 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 推销员 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 推销员 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 特殊 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 特殊 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 数量 / 1",
                    description = "商业网络 / 合同 / 类别 / 批发 / 数量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 数量 / 2",
                    description = "商业网络 / 合同 / 类别 / 批发 / 数量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 最小值 / 等级",
                    description = "商业网络 / 合同 / 类别 / 批发 / 最小值 / 等级的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 质量 / 1",
                    description = "商业网络 / 合同 / 类别 / 批发 / 质量 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 质量 / 2",
                    description = "商业网络 / 合同 / 类别 / 批发 / 质量 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 奖励 / 1",
                    description = "商业网络 / 合同 / 类别 / 批发 / 奖励 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 奖励 / 2",
                    description = "商业网络 / 合同 / 类别 / 批发 / 奖励 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 风险 / 1",
                    description = "商业网络 / 合同 / 类别 / 批发 / 风险 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "商业网络 / 合同 / 类别 / 批发 / 风险 / 2",
                    description = "商业网络 / 合同 / 类别 / 批发 / 风险 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "商业网络 / 合同 / 送达距离",
                    description = "商业网络 / 合同 / 送达距离的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "商业网络 / 合同 / 时长 / 分钟 / 最大值",
                    description = "商业网络 / 合同 / 时长 / 分钟 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "商业网络 / 合同 / 时长 / 分钟 / 最小值",
                    description = "商业网络 / 合同 / 时长 / 分钟 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / X",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / X的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / 是",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / 是的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / Z",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 坐标 / Z的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / ID",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 标签",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 地区",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 地区的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 奖励 / 倍率",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 奖励 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 1 / 风险",
                    description = "商业网络 / 合同 / 会面 / 分数 / 1 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / X",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / X的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / 是",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / 是的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / Z",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 坐标 / Z的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / ID",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 标签",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 地区",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 地区的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 奖励 / 倍率",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 奖励 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 2 / 风险",
                    description = "商业网络 / 合同 / 会面 / 分数 / 2 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / X",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / X的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / 是",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / 是的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / Z",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 坐标 / Z的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / ID",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 标签",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 地区",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 地区的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 奖励 / 倍率",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 奖励 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 3 / 风险",
                    description = "商业网络 / 合同 / 会面 / 分数 / 3 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / X",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / X的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / 是",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / 是的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / Z",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 坐标 / Z的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / ID",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 标签",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 地区",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 地区的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 奖励 / 倍率",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 奖励 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "商业网络 / 合同 / 会面 / 分数 / 4 / 风险",
                    description = "商业网络 / 合同 / 会面 / 分数 / 4 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 1",
                    description = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 2",
                    description = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 3",
                    description = "商业网络 / 合同 / 谈判 / 预付款 / 选项 / 3的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "商业网络 / 合同 / 谈判 / 数量 / 协商空间 / 百分比",
                    description = "商业网络 / 合同 / 谈判 / 数量 / 协商空间 / 百分比的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "商业网络 / 合同 / 谈判 / 基础值 / 接受率",
                    description = "商业网络 / 合同 / 谈判 / 基础值 / 接受率的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "商业网络 / 合同 / 谈判 / 截止日期 / 协商空间 / 百分比",
                    description = "商业网络 / 合同 / 谈判 / 截止日期 / 协商空间 / 百分比的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "商业网络 / 合同 / 谈判 / 最大值 / 轮次",
                    description = "商业网络 / 合同 / 谈判 / 最大值 / 轮次的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "商业网络 / 合同 / 谈判 / 质量 / 协商空间",
                    description = "商业网络 / 合同 / 谈判 / 质量 / 协商空间的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "商业网络 / 合同 / 谈判 / 拒绝 / 冷却分钟数",
                    description = "商业网络 / 合同 / 谈判 / 拒绝 / 冷却分钟数的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "商业网络 / 合同 / 谈判 / 回合 / 压力",
                    description = "商业网络 / 合同 / 谈判 / 回合 / 压力的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "商业网络 / 合同 / 报价 / 数量",
                    description = "商业网络 / 合同 / 报价 / 数量的运行设置。",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "商业网络 / 合同 / 刷新 / 分钟",
                    description = "商业网络 / 合同 / 刷新 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "商业网络 / 默认值 / 业务名称",
                    description = "商业网络 / 默认值 / 业务名称的运行设置。",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "商业网络 / 默认值 / 等级 / ID",
                    description = "商业网络 / 默认值 / 等级 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "商业网络 / 默认值 / 工作人员 / 工作方式",
                    description = "商业网络 / 默认值 / 工作人员 / 工作方式的运行设置。",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "商业网络 / 默认值 / 运输",
                    description = "商业网络 / 默认值 / 运输的运行设置。",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "商业网络 / 启用",
                    description = "商业网络 / 启用的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "商业网络 / 分销中心 / 配送中心 / 容量",
                    description = "商业网络 / 分销中心 / 配送中心 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "商业网络 / 分销中心 / 配送中心 / 购买价格",
                    description = "商业网络 / 分销中心 / 配送中心 / 购买价格的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "商业网络 / 分销中心 / 配送中心 / 安全",
                    description = "商业网络 / 分销中心 / 配送中心 / 安全的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "商业网络 / 分销中心 / 配送中心 / 维护费用",
                    description = "商业网络 / 分销中心 / 配送中心 / 维护费用的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "商业网络 / 分销中心 / 藏匿点 / 容量",
                    description = "商业网络 / 分销中心 / 藏匿点 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "商业网络 / 分销中心 / 藏匿点 / 购买价格",
                    description = "商业网络 / 分销中心 / 藏匿点 / 购买价格的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "商业网络 / 分销中心 / 藏匿点 / 安全",
                    description = "商业网络 / 分销中心 / 藏匿点 / 安全的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "商业网络 / 分销中心 / 藏匿点 / 维护费用",
                    description = "商业网络 / 分销中心 / 藏匿点 / 维护费用的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "商业网络 / 分销中心 / 仓库 / 容量",
                    description = "商业网络 / 分销中心 / 仓库 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "商业网络 / 分销中心 / 仓库 / 购买价格",
                    description = "商业网络 / 分销中心 / 仓库 / 购买价格的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "商业网络 / 分销中心 / 仓库 / 安全",
                    description = "商业网络 / 分销中心 / 仓库 / 安全的运行设置。",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "商业网络 / 分销中心 / 仓库 / 维护费用",
                    description = "商业网络 / 分销中心 / 仓库 / 维护费用的运行设置。",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "商业网络 / 限制 / 生效合同",
                    description = "商业网络 / 限制 / 生效合同的运行设置。",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "商业网络 / 限制 / 分销中心",
                    description = "商业网络 / 限制 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "商业网络 / 限制 / 账本 / 条目",
                    description = "商业网络 / 限制 / 账本 / 条目的运行设置。",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "商业网络 / 限制 / 路线",
                    description = "商业网络 / 限制 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "商业网络 / 限制 / 工作人员",
                    description = "商业网络 / 限制 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "商业网络 / 付款 / 账户",
                    description = "商业网络 / 付款 / 账户的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "商业网络 / 职级 / 1 / 合同",
                    description = "商业网络 / 职级 / 1 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "商业网络 / 职级 / 1 / 毒贩",
                    description = "商业网络 / 职级 / 1 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "商业网络 / 职级 / 1 / 分销中心",
                    description = "商业网络 / 职级 / 1 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "商业网络 / 职级 / 1 / ID",
                    description = "商业网络 / 职级 / 1 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "商业网络 / 职级 / 1 / 标签",
                    description = "商业网络 / 职级 / 1 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "商业网络 / 职级 / 1 / 路线",
                    description = "商业网络 / 职级 / 1 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "商业网络 / 职级 / 1 / 分数",
                    description = "商业网络 / 职级 / 1 / 分数的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "商业网络 / 职级 / 1 / 工作人员",
                    description = "商业网络 / 职级 / 1 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "商业网络 / 职级 / 2 / 合同",
                    description = "商业网络 / 职级 / 2 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "商业网络 / 职级 / 2 / 毒贩",
                    description = "商业网络 / 职级 / 2 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "商业网络 / 职级 / 2 / 分销中心",
                    description = "商业网络 / 职级 / 2 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "商业网络 / 职级 / 2 / ID",
                    description = "商业网络 / 职级 / 2 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "商业网络 / 职级 / 2 / 标签",
                    description = "商业网络 / 职级 / 2 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "商业网络 / 职级 / 2 / 路线",
                    description = "商业网络 / 职级 / 2 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "商业网络 / 职级 / 2 / 分数",
                    description = "商业网络 / 职级 / 2 / 分数的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "商业网络 / 职级 / 2 / 工作人员",
                    description = "商业网络 / 职级 / 2 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "商业网络 / 职级 / 3 / 合同",
                    description = "商业网络 / 职级 / 3 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "商业网络 / 职级 / 3 / 毒贩",
                    description = "商业网络 / 职级 / 3 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "商业网络 / 职级 / 3 / 分销中心",
                    description = "商业网络 / 职级 / 3 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "商业网络 / 职级 / 3 / ID",
                    description = "商业网络 / 职级 / 3 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "商业网络 / 职级 / 3 / 标签",
                    description = "商业网络 / 职级 / 3 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "商业网络 / 职级 / 3 / 路线",
                    description = "商业网络 / 职级 / 3 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "商业网络 / 职级 / 3 / 分数",
                    description = "商业网络 / 职级 / 3 / 分数的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "商业网络 / 职级 / 3 / 工作人员",
                    description = "商业网络 / 职级 / 3 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "商业网络 / 职级 / 4 / 合同",
                    description = "商业网络 / 职级 / 4 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "商业网络 / 职级 / 4 / 毒贩",
                    description = "商业网络 / 职级 / 4 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "商业网络 / 职级 / 4 / 分销中心",
                    description = "商业网络 / 职级 / 4 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "商业网络 / 职级 / 4 / ID",
                    description = "商业网络 / 职级 / 4 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "商业网络 / 职级 / 4 / 标签",
                    description = "商业网络 / 职级 / 4 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "商业网络 / 职级 / 4 / 路线",
                    description = "商业网络 / 职级 / 4 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "商业网络 / 职级 / 4 / 分数",
                    description = "商业网络 / 职级 / 4 / 分数的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "商业网络 / 职级 / 4 / 工作人员",
                    description = "商业网络 / 职级 / 4 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "商业网络 / 职级 / 5 / 合同",
                    description = "商业网络 / 职级 / 5 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "商业网络 / 职级 / 5 / 毒贩",
                    description = "商业网络 / 职级 / 5 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "商业网络 / 职级 / 5 / 分销中心",
                    description = "商业网络 / 职级 / 5 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "商业网络 / 职级 / 5 / ID",
                    description = "商业网络 / 职级 / 5 / ID的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "商业网络 / 职级 / 5 / 标签",
                    description = "商业网络 / 职级 / 5 / 标签的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "商业网络 / 职级 / 5 / 路线",
                    description = "商业网络 / 职级 / 5 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "商业网络 / 职级 / 5 / 分数",
                    description = "商业网络 / 职级 / 5 / 分数的运行设置。",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "商业网络 / 职级 / 5 / 工作人员",
                    description = "商业网络 / 职级 / 5 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "商业网络 / 报告周期 / 天",
                    description = "商业网络 / 报告周期 / 天的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 买家",
                    description = "商业网络 / 路线 / 终点 / 类型 / 买家的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 合同",
                    description = "商业网络 / 路线 / 终点 / 类型 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 经销商",
                    description = "商业网络 / 路线 / 终点 / 类型 / 经销商的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 帮派",
                    description = "商业网络 / 路线 / 终点 / 类型 / 帮派的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 分销中心",
                    description = "商业网络 / 路线 / 终点 / 类型 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 实验室",
                    description = "商业网络 / 路线 / 终点 / 类型 / 实验室的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 组织",
                    description = "商业网络 / 路线 / 终点 / 类型 / 组织的运行设置。",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "商业网络 / 路线 / 终点 / 类型 / 推销员",
                    description = "商业网络 / 路线 / 终点 / 类型 / 推销员的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "商业网络 / 游戏运行 / 合同 / 频率 / 分钟 / 最大值",
                    description = "商业网络 / 游戏运行 / 合同 / 频率 / 分钟 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "商业网络 / 游戏运行 / 合同 / 频率 / 分钟 / 最小值",
                    description = "商业网络 / 游戏运行 / 合同 / 频率 / 分钟 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "商业网络 / 游戏运行 / 合同 / 冷却时间 / 最小值 / 分钟",
                    description = "商业网络 / 游戏运行 / 合同 / 冷却时间 / 最小值 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "商业网络 / 游戏运行 / 合同 / 失败 / 可靠性 / 亏损",
                    description = "商业网络 / 游戏运行 / 合同 / 失败 / 可靠性 / 亏损的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "商业网络 / 游戏运行 / 合同 / 最小值 / 频率 / 分钟",
                    description = "商业网络 / 游戏运行 / 合同 / 最小值 / 频率 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "商业网络 / 游戏运行 / 合同 / 最小值 / 会面 / 倍率",
                    description = "商业网络 / 游戏运行 / 合同 / 最小值 / 会面 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "商业网络 / 游戏运行 / 合同违约金 / 生长率",
                    description = "商业网络 / 游戏运行 / 合同违约金 / 生长率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "商业网络 / 游戏运行 / 合同违约金 / 倍率",
                    description = "商业网络 / 游戏运行 / 合同违约金 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "商业网络 / 游戏运行 / 合同 / 质量 / 失败 / 冷却分钟数",
                    description = "商业网络 / 游戏运行 / 合同 / 质量 / 失败 / 冷却分钟数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "商业网络 / 游戏运行 / 合同 / 质量 / 价格 / 基础值",
                    description = "商业网络 / 游戏运行 / 合同 / 质量 / 价格 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "商业网络 / 游戏运行 / 合同 / 质量 / 价格 / 除数",
                    description = "商业网络 / 游戏运行 / 合同 / 质量 / 价格 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 基础值",
                    description = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 最大值",
                    description = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 质量 / 权重",
                    description = "商业网络 / 游戏运行 / 合同 / 可靠性 / 亏损 / 质量 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "商业网络 / 游戏运行 / 合同 / 声望 / 质量 / 权重",
                    description = "商业网络 / 游戏运行 / 合同 / 声望 / 质量 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "商业网络 / 游戏运行 / 合同 / 风险 / 权重 / 类别",
                    description = "商业网络 / 游戏运行 / 合同 / 风险 / 权重 / 类别的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "商业网络 / 游戏运行 / 合同 / 风险 / 权重 / 会面",
                    description = "商业网络 / 游戏运行 / 合同 / 风险 / 权重 / 会面的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "商业网络 / 游戏运行 / 默认值 / 分销中心 / 容量",
                    description = "商业网络 / 游戏运行 / 默认值 / 分销中心 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "商业网络 / 游戏运行 / 默认值 / 分销中心 / 安全",
                    description = "商业网络 / 游戏运行 / 默认值 / 分销中心 / 安全的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "商业网络 / 游戏运行 / 默认值 / 会面 / 风险",
                    description = "商业网络 / 游戏运行 / 默认值 / 会面 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "商业网络 / 游戏运行 / 默认值 / 质量",
                    description = "商业网络 / 游戏运行 / 默认值 / 质量的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "商业网络 / 游戏运行 / 默认值 / 路线容量",
                    description = "商业网络 / 游戏运行 / 默认值 / 路线容量的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "商业网络 / 游戏运行 / 默认值 / 路线 / 间隔 / 分钟",
                    description = "商业网络 / 游戏运行 / 默认值 / 路线 / 间隔 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "商业网络 / 游戏运行 / 默认值 / 路线 / 风险",
                    description = "商业网络 / 游戏运行 / 默认值 / 路线 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 警方关注度 / 衰减",
                    description = "商业网络 / 游戏运行 / 分销中心 / 警方关注度 / 衰减的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 负载 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 分销中心 / 负载 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 袭击 / 恢复 / 分钟",
                    description = "商业网络 / 游戏运行 / 分销中心 / 袭击 / 恢复 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 安全 / 费用 / 基础值",
                    description = "商业网络 / 游戏运行 / 分销中心 / 安全 / 费用 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 安全 / 费用 / 每级",
                    description = "商业网络 / 游戏运行 / 分销中心 / 安全 / 费用 / 每级的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 安全 / 最大值",
                    description = "商业网络 / 游戏运行 / 分销中心 / 安全 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 安全 / 升级",
                    description = "商业网络 / 游戏运行 / 分销中心 / 安全 / 升级的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 未付款 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 分销中心 / 未付款 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 未付款 / 安全 / 亏损",
                    description = "商业网络 / 游戏运行 / 分销中心 / 未付款 / 安全 / 亏损的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "商业网络 / 游戏运行 / 分销中心 / 维护费用 / 间隔 / 小时",
                    description = "商业网络 / 游戏运行 / 分销中心 / 维护费用 / 间隔 / 小时的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "商业网络 / 游戏运行 / 初始值 / 可靠性",
                    description = "商业网络 / 游戏运行 / 初始值 / 可靠性的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "商业网络 / 游戏运行 / 最大值 / 业务名称 / 长度",
                    description = "商业网络 / 游戏运行 / 最大值 / 业务名称 / 长度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "商业网络 / 游戏运行 / 最小值 / 合同 / 送达 / 分钟",
                    description = "商业网络 / 游戏运行 / 最小值 / 合同 / 送达 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "商业网络 / 游戏运行 / 最小值 / 送达距离",
                    description = "商业网络 / 游戏运行 / 最小值 / 送达距离的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "商业网络 / 游戏运行 / 最小值 / 账本 / 条目",
                    description = "商业网络 / 游戏运行 / 最小值 / 账本 / 条目的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "商业网络 / 游戏运行 / 最小值 / 路线 / 间隔 / 分钟",
                    description = "商业网络 / 游戏运行 / 最小值 / 路线 / 间隔 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 预付款 / 费用 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 预付款 / 费用 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 预付款 / 价格 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 预付款 / 价格 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 数量 / 费用 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 数量 / 费用 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "商业网络 / 游戏运行 / 谈判 / 数量 / 协商空间 / 最大值",
                    description = "商业网络 / 游戏运行 / 谈判 / 数量 / 协商空间 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 数量 / 风险 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 数量 / 风险 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 还价 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 还价 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "商业网络 / 游戏运行 / 谈判 / 截止日期 / 协商空间 / 最大值",
                    description = "商业网络 / 游戏运行 / 谈判 / 截止日期 / 协商空间 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "商业网络 / 游戏运行 / 谈判 / 最大值 / 接受率",
                    description = "商业网络 / 游戏运行 / 谈判 / 最大值 / 接受率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "商业网络 / 游戏运行 / 谈判 / 最小值 / 接受率",
                    description = "商业网络 / 游戏运行 / 谈判 / 最小值 / 接受率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 质量 / 收益 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 质量 / 收益 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 质量 / 费用 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 质量 / 费用 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "商业网络 / 游戏运行 / 谈判 / 质量 / 协商空间 / 最大值",
                    description = "商业网络 / 游戏运行 / 谈判 / 质量 / 协商空间 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 质量 / 奖励 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 质量 / 奖励 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 可靠性 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 可靠性 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 声望 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 声望 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "商业网络 / 游戏运行 / 谈判 / 要求的报酬 / 最大值",
                    description = "商业网络 / 游戏运行 / 谈判 / 要求的报酬 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "商业网络 / 游戏运行 / 谈判 / 要求的报酬 / 最小值",
                    description = "商业网络 / 游戏运行 / 谈判 / 要求的报酬 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 奖励 / 费用 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 奖励 / 费用 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "商业网络 / 游戏运行 / 谈判 / 奖励 / 最大值",
                    description = "商业网络 / 游戏运行 / 谈判 / 奖励 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "商业网络 / 游戏运行 / 谈判 / 奖励 / 最小值",
                    description = "商业网络 / 游戏运行 / 谈判 / 奖励 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 基础值",
                    description = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 收益 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 收益 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 风险 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 风险 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 权重",
                    description = "商业网络 / 游戏运行 / 谈判 / 紧迫程度 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "商业网络 / 游戏运行 / 其他 / 失败 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 其他 / 失败 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "商业网络 / 游戏运行 / 个人热度 / 权重",
                    description = "商业网络 / 游戏运行 / 个人热度 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "商业网络 / 游戏运行 / 警察 / 失败 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 警察 / 失败 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "商业网络 / 游戏运行 / 推销员 / 基础值 / 单位",
                    description = "商业网络 / 游戏运行 / 推销员 / 基础值 / 单位的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "商业网络 / 游戏运行 / 推销员 / 大宗 / 倍率",
                    description = "商业网络 / 游戏运行 / 推销员 / 大宗 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "商业网络 / 游戏运行 / 推销员 / 低价销售 / 倍率",
                    description = "商业网络 / 游戏运行 / 推销员 / 低价销售 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "商业网络 / 游戏运行 / 推销员 / 经验 / 每级",
                    description = "商业网络 / 游戏运行 / 推销员 / 经验 / 每级的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "商业网络 / 游戏运行 / 推销员 / 经验 / 每单位",
                    description = "商业网络 / 游戏运行 / 推销员 / 经验 / 每单位的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "商业网络 / 游戏运行 / 推销员 / 分销中心 / 警方关注度 / 每单位",
                    description = "商业网络 / 游戏运行 / 推销员 / 分销中心 / 警方关注度 / 每单位的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "商业网络 / 游戏运行 / 推销员 / 高级 / 倍率",
                    description = "商业网络 / 游戏运行 / 推销员 / 高级 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "商业网络 / 游戏运行 / 推销员 / 技能 / 除数",
                    description = "商业网络 / 游戏运行 / 推销员 / 技能 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "商业网络 / 游戏运行 / 推销员 / 技能 / 增益",
                    description = "商业网络 / 游戏运行 / 推销员 / 技能 / 增益的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "商业网络 / 游戏运行 / 路线 / 时长 / 基础值 / 秒",
                    description = "商业网络 / 游戏运行 / 路线 / 时长 / 基础值 / 秒的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "商业网络 / 游戏运行 / 路线 / 时长 / 每单位 / 秒",
                    description = "商业网络 / 游戏运行 / 路线 / 时长 / 每单位 / 秒的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 1",
                    description = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 2",
                    description = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 3",
                    description = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 3的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 4",
                    description = "商业网络 / 游戏运行 / 路线 / 失败 / 死亡原因 / 4的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "商业网络 / 游戏运行 / 路线 / 失败 / 价值 / 倍率",
                    description = "商业网络 / 游戏运行 / 路线 / 失败 / 价值 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "商业网络 / 游戏运行 / 路线 / 警方关注度 / 数量 / 除数",
                    description = "商业网络 / 游戏运行 / 路线 / 警方关注度 / 数量 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "商业网络 / 游戏运行 / 路线 / 热度降低 / 费用 / 基础值",
                    description = "商业网络 / 游戏运行 / 路线 / 热度降低 / 费用 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "商业网络 / 游戏运行 / 路线 / 热度降低 / 费用 / 每点警方关注度",
                    description = "商业网络 / 游戏运行 / 路线 / 热度降低 / 费用 / 每点警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 最大值",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 最小值",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 忠诚度",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 忠诚度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 跑腿员 / 风险",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 跑腿员 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 技能",
                    description = "商业网络 / 游戏运行 / 路线 / 风险 / 权重 / 技能的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "商业网络 / 游戏运行 / 路线轮换 / 热度降低",
                    description = "商业网络 / 游戏运行 / 路线轮换 / 热度降低的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "商业网络 / 游戏运行 / 路线轮换 / 风险 / 减少量",
                    description = "商业网络 / 游戏运行 / 路线轮换 / 风险 / 减少量的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "商业网络 / 游戏运行 / 路线 / 销售 / 基础品质",
                    description = "商业网络 / 游戏运行 / 路线 / 销售 / 基础品质的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "商业网络 / 游戏运行 / 路线 / 销售 / 质量 / 除数",
                    description = "商业网络 / 游戏运行 / 路线 / 销售 / 质量 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "商业网络 / 游戏运行 / 路线 / 销售 / 风险 / 除数",
                    description = "商业网络 / 游戏运行 / 路线 / 销售 / 风险 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "商业网络 / 游戏运行 / 路线 / 开始 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 路线 / 开始 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "商业网络 / 游戏运行 / 跑腿员 / 经验 / 每级",
                    description = "商业网络 / 游戏运行 / 跑腿员 / 经验 / 每级的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "商业网络 / 游戏运行 / 跑腿员 / 经验 / 每单位",
                    description = "商业网络 / 游戏运行 / 跑腿员 / 经验 / 每单位的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "商业网络 / 游戏运行 / 跑腿员 / 失败 / 忠诚度 / 亏损",
                    description = "商业网络 / 游戏运行 / 跑腿员 / 失败 / 忠诚度 / 亏损的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "商业网络 / 游戏运行 / 跑腿员 / 失败风险 / 增益",
                    description = "商业网络 / 游戏运行 / 跑腿员 / 失败风险 / 增益的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "商业网络 / 游戏运行 / 跑腿员 / 技能 / 增益",
                    description = "商业网络 / 游戏运行 / 跑腿员 / 技能 / 增益的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "商业网络 / 游戏运行 / 分数 / 权重 / 警方关注度",
                    description = "商业网络 / 游戏运行 / 分数 / 权重 / 警方关注度的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "商业网络 / 游戏运行 / 分数 / 权重 / 可靠性",
                    description = "商业网络 / 游戏运行 / 分数 / 权重 / 可靠性的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "商业网络 / 游戏运行 / 分数 / 权重 / 声望",
                    description = "商业网络 / 游戏运行 / 分数 / 权重 / 声望的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "商业网络 / 游戏运行 / 分数 / 权重 / 结构",
                    description = "商业网络 / 游戏运行 / 分数 / 权重 / 结构的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 容量 / 基础值 / 倍率",
                    description = "商业网络 / 游戏运行 / 工作人员 / 容量 / 基础值 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 忠诚度 / 最大值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 忠诚度 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 忠诚度 / 最小值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 忠诚度 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 风险 / 最大值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 风险 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 风险 / 最小值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 风险 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 技能 / 最大值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 技能 / 最大值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 技能 / 最小值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 雇用 / 技能 / 最小值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 忠诚度 / 权重",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 忠诚度 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 最大值 / 概率",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 最大值 / 概率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 1",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 2",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 3",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 3的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 4",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 结果 / 4的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 事件 / 风险 / 权重",
                    description = "商业网络 / 游戏运行 / 工作人员 / 事件 / 风险 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 忠诚度 / 衰减",
                    description = "商业网络 / 游戏运行 / 工作人员 / 忠诚度 / 衰减的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 最大值 / 层级",
                    description = "商业网络 / 游戏运行 / 工作人员 / 最大值 / 层级的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 挖角造成的忠诚损失",
                    description = "商业网络 / 游戏运行 / 工作人员 / 挖角造成的忠诚损失的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 保护 / 费用 / 基础值",
                    description = "商业网络 / 游戏运行 / 工作人员 / 保护 / 费用 / 基础值的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 保护 / 小时",
                    description = "商业网络 / 游戏运行 / 工作人员 / 保护 / 小时的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 保护 / 事件 / 减少量",
                    description = "商业网络 / 游戏运行 / 工作人员 / 保护 / 事件 / 减少量的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 保护 / 风险 / 费用",
                    description = "商业网络 / 游戏运行 / 工作人员 / 保护 / 风险 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 恢复 / 基础值 / 概率",
                    description = "商业网络 / 游戏运行 / 工作人员 / 恢复 / 基础值 / 概率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 恢复 / 忠诚度 / 权重",
                    description = "商业网络 / 游戏运行 / 工作人员 / 恢复 / 忠诚度 / 权重的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 工资 / 基础值 / 倍率",
                    description = "商业网络 / 游戏运行 / 工作人员 / 工资 / 基础值 / 倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 工资 / 忠诚度 / 增益",
                    description = "商业网络 / 游戏运行 / 工作人员 / 工资 / 忠诚度 / 增益的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 工资 / 技能 / 除数",
                    description = "商业网络 / 游戏运行 / 工作人员 / 工资 / 技能 / 除数的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 1",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 1的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 2",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 2的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 3",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 3的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 4",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 4的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 5",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 5的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 6",
                    description = "商业网络 / 游戏运行 / 工作人员 / 弱点 / 6的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "商业网络 / 游戏运行 / 结构 / 权重 / 合同",
                    description = "商业网络 / 游戏运行 / 结构 / 权重 / 合同的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "商业网络 / 游戏运行 / 结构 / 权重 / 毒贩",
                    description = "商业网络 / 游戏运行 / 结构 / 权重 / 毒贩的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "商业网络 / 游戏运行 / 结构 / 权重 / 分销中心",
                    description = "商业网络 / 游戏运行 / 结构 / 权重 / 分销中心的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "商业网络 / 游戏运行 / 结构 / 权重 / 路线",
                    description = "商业网络 / 游戏运行 / 结构 / 权重 / 路线的运行设置。",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "商业网络 / 游戏运行 / 结构 / 权重 / 工作人员",
                    description = "商业网络 / 游戏运行 / 结构 / 权重 / 工作人员的运行设置。",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "商业网络 / 组织 / 权限",
                    description = "商业网络 / 组织 / 权限的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "商业网络 / 工作人员 / 推销员 / 基础值 / 容量",
                    description = "商业网络 / 工作人员 / 推销员 / 基础值 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "商业网络 / 工作人员 / 推销员 / 基础值 / 工资",
                    description = "商业网络 / 工作人员 / 推销员 / 基础值 / 工资的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "商业网络 / 工作人员 / 推销员 / 佣金",
                    description = "商业网络 / 工作人员 / 推销员 / 佣金的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "商业网络 / 工作人员 / 推销员 / 雇用 / 价格",
                    description = "商业网络 / 工作人员 / 推销员 / 雇用 / 价格的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "商业网络 / 工作人员 / 跑腿员 / 基础值 / 容量",
                    description = "商业网络 / 工作人员 / 跑腿员 / 基础值 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "商业网络 / 工作人员 / 跑腿员 / 基础值 / 工资",
                    description = "商业网络 / 工作人员 / 跑腿员 / 基础值 / 工资的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "商业网络 / 工作人员 / 跑腿员 / 佣金",
                    description = "商业网络 / 工作人员 / 跑腿员 / 佣金的运行设置。",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "商业网络 / 工作人员 / 跑腿员 / 雇用 / 价格",
                    description = "商业网络 / 工作人员 / 跑腿员 / 雇用 / 价格的运行设置。",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "商业网络 / 更新周期 / 分钟",
                    description = "商业网络 / 更新周期 / 分钟的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "商业网络 / 运输 / 飞机 / 容量",
                    description = "商业网络 / 运输 / 飞机 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "商业网络 / 运输 / 飞机 / 费用",
                    description = "商业网络 / 运输 / 飞机 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "商业网络 / 运输 / 飞机 / 持续时间倍率",
                    description = "商业网络 / 运输 / 飞机 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "商业网络 / 运输 / 飞机 / 风险",
                    description = "商业网络 / 运输 / 飞机 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "商业网络 / 运输 / 船只 / 容量",
                    description = "商业网络 / 运输 / 船只 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "商业网络 / 运输 / 船只 / 费用",
                    description = "商业网络 / 运输 / 船只 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "商业网络 / 运输 / 船只 / 持续时间倍率",
                    description = "商业网络 / 运输 / 船只 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "商业网络 / 运输 / 船只 / 风险",
                    description = "商业网络 / 运输 / 船只 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "商业网络 / 运输 / 轿车 / 容量",
                    description = "商业网络 / 运输 / 轿车 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "商业网络 / 运输 / 轿车 / 费用",
                    description = "商业网络 / 运输 / 轿车 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "商业网络 / 运输 / 轿车 / 持续时间倍率",
                    description = "商业网络 / 运输 / 轿车 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "商业网络 / 运输 / 轿车 / 风险",
                    description = "商业网络 / 运输 / 轿车 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "商业网络 / 运输 / 步行 / 容量",
                    description = "商业网络 / 运输 / 步行 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "商业网络 / 运输 / 步行 / 费用",
                    description = "商业网络 / 运输 / 步行 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "商业网络 / 运输 / 步行 / 持续时间倍率",
                    description = "商业网络 / 运输 / 步行 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "商业网络 / 运输 / 步行 / 风险",
                    description = "商业网络 / 运输 / 步行 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "商业网络 / 运输 / 卡车 / 容量",
                    description = "商业网络 / 运输 / 卡车 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "商业网络 / 运输 / 卡车 / 费用",
                    description = "商业网络 / 运输 / 卡车 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "商业网络 / 运输 / 卡车 / 持续时间倍率",
                    description = "商业网络 / 运输 / 卡车 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "商业网络 / 运输 / 卡车 / 风险",
                    description = "商业网络 / 运输 / 卡车 / 风险的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "商业网络 / 运输 / 面包车 / 容量",
                    description = "商业网络 / 运输 / 面包车 / 容量的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "商业网络 / 运输 / 面包车 / 费用",
                    description = "商业网络 / 运输 / 面包车 / 费用的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "商业网络 / 运输 / 面包车 / 持续时间倍率",
                    description = "商业网络 / 运输 / 面包车 / 持续时间倍率的运行设置。",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "商业网络 / 运输 / 面包车 / 风险",
                    description = "商业网络 / 运输 / 面包车 / 风险的运行设置。",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "通用集成",
                        custom = "自定义集成",
                        none = "已禁用",
                    },
                },
                reputationRules = {
                    label = "声望规则",
                    description = "配置具有名称的行动规则及可选目标。只有已启用的规则会奖励声望点数。",
                },
            },
            territoryMap = {
                addPoint = "添加点",
                clear = "清除",
                create = "创建",
                custom = "自定义领地",
                deletePoint = "删除点",
                eyebrow = "领地编辑器",
                minimum = "最少 3",
                pointCount = "{count} 点",
                presets = "预设区域",
                shown = "在地图上显示",
                street = "街道",
                supply = "供应",
                territories = "领土",
                type = "领土类型",
                undo = "撤销",
            },
            shopPositionTools = {
                currentPosition = "使用当前位置",
                selectEntity = "选择物体",
                selectEntityHint = "将激光对准收银机或保险箱。回车：使用所选物体的坐标和朝向。退格：取消。",
            },
            drugSettingSubsections = {
                cultivationLevels = "种植等级",
                general = "常规",
                runtime = "游戏操作权限",
                quality = "质量",
                packaging = "包装",
                growing = "种植",
                labs = "实验室与房车",
                power = "电力与设备",
                workers = "员工",
                market = "市场与分销",
                threats = "突袭与破坏",
                pvpTakeovers = "实验室占领",
                consumption = "使用",
                processing = "加工",
                performance = "性能",
                dynamicMarket = "动态市场",
                heat = "警方关注与风险",
                contacts = "联系人网络",
                business = "商业网络",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "常规" },
                cultivationCurve = { label = "等级曲线" },
                cultivationExperience = { label = "经验奖励" },
                cultivationUnlocks = { label = "等级解锁" },
                creator = {
                    label = "打开编辑器",
                },
                creatorSettings = {
                    label = "编辑器设置",
                },
                interfaceHud = {
                    label = "界面位置",
                },
                drugsGeneral = {
                    label = "常规",
                },
                runtimeAccess = {
                    label = "权限与所有权",
                },
                runtimePayouts = {
                    label = "结算款",
                },
                runtimeDispatch = {
                    label = "调度与警察",
                },
                qualityWeights = {
                    label = "质量 / 权重",
                },
                qualityTiers = {
                    label = "质量 / 品质等级",
                },
                packagingGeneral = {
                    label = "常规",
                },
                growingGeneral = {
                    label = "常规",
                },
                plantDefaults = {
                    label = "植物 / 默认值",
                },
                harvestWindow = {
                    label = "收获 / 时间窗口",
                },
                labsGeneral = {
                    label = "常规",
                },
                labRent = {
                    label = "租赁与生命周期",
                },
                camperDefaults = {
                    label = "房车",
                },
                labUpgrades = {
                    label = "升级项",
                },
                labDefaults = {
                    label = "实验室 / 默认值",
                },
                powerGeneral = {
                    label = "常规",
                },
                generators = {
                    label = "发电机",
                },
                equipmentWear = {
                    label = "设备",
                },
                workersGeneral = {
                    label = "常规",
                },
                marketGeneral = {
                    label = "常规",
                },
                marketPrices = {
                    label = "价格",
                },
                distribution = {
                    label = "分销",
                },
                threatsGeneral = {
                    label = "常规",
                },
                threatHeat = {
                    label = "警方关注度",
                },
                threatChances = {
                    label = "概率",
                },
                pvpTakeoverRules = {
                    label = "接管规则",
                },
                pvpTakeoverZones = {
                    label = "区域 & 时间设置",
                },
                pvpTakeoverMethods = {
                    label = "破门方式",
                },
                consumptionGeneral = {
                    label = "常规",
                },
                consumerDecay = {
                    label = "耐受与成瘾消退",
                },
                consumerEffects = {
                    label = "效果与风险",
                },
                processingFlow = {
                    label = "加工流程",
                },
                processingGeneral = {
                    label = "常规",
                },
                powerRuntime = {
                    label = "游戏运行",
                },
                powerHeat = {
                    label = "警方关注与用电特征",
                },
                powerModes = {
                    label = "管理 / 模式",
                },
                powerPriorities = {
                    label = "负载 / 优先级",
                },
                performanceInactiveControlIntervalMs = {
                    label = "未激活 / 控制 / 间隔 / 毫秒",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "交互 / 空闲 / 扫描间隔 / 毫秒",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "交互 / 交互提示 / 间隔 / 毫秒",
                },
                performanceInteractionScanIntervalMs = {
                    label = "交互 / 扫描间隔 / 毫秒",
                },
                performanceMinimumScanIntervalMs = {
                    label = "最小值 / 扫描间隔 / 毫秒",
                },
                performanceStreetPedActivationDistance = {
                    label = "街道 / 佩德 / 激活 / 距离",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "街道 / 佩德 / 空闲 / 扫描间隔 / 毫秒",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "街道 / 佩德 / 扫描间隔 / 毫秒",
                },
                performanceWorldCachePadding = {
                    label = "世界 / 缓存 / 额外边距",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "世界 / 缓存 / 刷新 / 间隔 / 毫秒",
                },
                performanceWorldIdleIntervalMs = {
                    label = "世界 / 空闲 / 间隔 / 毫秒",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "动作冷却时间 / 秒",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "行动 / 历史记录上限",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "数量 / 饱和度 / 权重",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "基础值 / 情报准确度",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "默认值 / 平均值 / 质量",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "默认值 / 资源 / 弹性",
                },
                dynamicMarketDemandCenter = {
                    label = "需求 / 中心值",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "需求 / 价格 / 影响",
                },
                dynamicMarketDirectionThreshold = {
                    label = "方向 / 阈值",
                },
                dynamicMarketEnabled = {
                    label = "启用",
                },
                dynamicMarketEventChance = {
                    label = "事件 / 概率",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "事件 / 时长 / 分钟",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "事件 / 最小值 / 时长 / 分钟",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "事件 / 强度 / 最大值",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "事件 / 强度 / 最小值",
                },
                dynamicMarketEvents = {
                    label = "活动",
                },
                dynamicMarketExactIntelReputation = {
                    label = "精确情报 / 声望",
                },
                dynamicMarketExactIntelTrust = {
                    label = "精确情报 / 信任",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "全球的 / 区域 / 标签",
                },
                dynamicMarketHistoryLimit = {
                    label = "历史记录上限",
                },
                dynamicMarketInitialDemand = {
                    label = "初始值 / 需求",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "初始值 / 价格倍数",
                },
                dynamicMarketIntelDemandError = {
                    label = "情报 / 需求 / 错误",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "情报 / 最大值 / 准确度",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "情报 / 最小值 / 准确度",
                },
                dynamicMarketIntelPoliceError = {
                    label = "情报 / 警察 / 错误",
                },
                dynamicMarketIntelPriceError = {
                    label = "情报 / 价格 / 错误",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "情报 / 价格 / 最大值",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "情报 / 价格 / 最小值",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "情报 / 声望 / 权重",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "情报 / 资源 / 价格 / 错误",
                },
                dynamicMarketIntelSaturationError = {
                    label = "情报 / 饱和度 / 错误",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "情报随机种子窗口 / 秒",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "情报 / 状态 / 准确度 / 阈值",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "情报 / 状态 / 错误 / 阈值",
                },
                dynamicMarketIntelSupplyError = {
                    label = "情报 / 供应 / 错误",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "情报 / 信任 / 权重",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "操纵 / 冷却分钟数",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "操纵 / 需求 / 偏移",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "操纵 / 时长 / 分钟",
                },
                dynamicMarketManipulationHeat = {
                    label = "操纵 / 警方关注度",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "操纵 / 最小值 / 批次 / 数量",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "操纵 / 付款账户",
                },
                dynamicMarketManipulationPrice = {
                    label = "操纵 / 价格",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "操纵 / 区域 / 警方关注度 / 倍率",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "最大值 / 情报时效 / 分钟",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "最大值 / 价格倍数",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "最小值 / 情报时效 / 分钟",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "最小值 / 指标 / 时间窗口 / 分钟",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "最低价格 / 倍率",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "最小值 / 更新 / 分钟",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "警察 / 需求 / 权重",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "警察 / 价格 / 影响",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "低质量 / 需求 / 惩罚",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "低质量 / 阈值",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "优质质量 / 需求加成",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "优质质量 / 阈值",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "生产 / 供应 / 权重",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "生产 / 时间窗口 / 分钟",
                },
                dynamicMarketQualityCenter = {
                    label = "质量 / 中心值",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "质量 / 信心 / 影响",
                },
                dynamicMarketQualityRange = {
                    label = "质量 / 数值范围",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "稀有度 / 奖金 / 最大值",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "地区性 / 全球的 / 权重",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "地区性 / 本地 / 权重",
                },
                dynamicMarketResourceAliases = {
                    label = "资源 / 别名",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "资源 / 方向 / 下降 / 阈值",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "资源 / 方向 / 上升 / 阈值",
                },
                dynamicMarketResources = {
                    label = "资源",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "销售 / 时间窗口 / 分钟",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "饱和度 / 需求 / 权重",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "饱和度 / 价格 / 影响",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "稀缺程度 / 需求 / 权重",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "稀缺程度 / 价格 / 影响",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "季节 / 结束 / 月份",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "季节 / 倍率",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "短缺 / 传闻 / 阈值",
                },
                dynamicMarketStatusThresholds = {
                    label = "状态 / 阈值",
                },
                dynamicMarketTargetSupply = {
                    label = "目标 / 供应",
                },
                dynamicMarketTrendChance = {
                    label = "趋势 / 概率",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "趋势 / 时长 / 分钟",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "趋势 / 最大值 / 强度",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "趋势 / 最小值 / 强度",
                },
                dynamicMarketUpdateMinutes = {
                    label = "更新 / 分钟",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "价格波动 / 最大值",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "价格波动 / 最小值",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "天气 / 倍率",
                },
                dynamicMarketWeatherState = {
                    label = "天气 / 状态",
                },
                heatActionCooldownSeconds = {
                    label = "动作冷却时间 / 秒",
                },
                heatActivityRiskWeights = {
                    label = "活动 / 风险 / 权重",
                },
                heatAggressiveHeatMultiplier = {
                    label = "激进模式 / 警方关注度 / 倍率",
                },
                heatBurnerBurnThreshold = {
                    label = "一次性手机 / 暴露 / 阈值",
                },
                heatBurnerHeatPerWholesale = {
                    label = "一次性手机 / 警方关注度 / 每笔批发交易",
                },
                heatBurnerPhoneItem = {
                    label = "一次性手机 / 物品",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "运行中的房车 / 警方关注度 / 倍率",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "运行中的房车 / 警方关注度 / 阈值",
                },
                heatCamperParkedHeat = {
                    label = "停放中的房车 / 警方关注度",
                },
                heatContaminatedHeatMultiplier = {
                    label = "污染 / 警方关注度 / 倍率",
                },
                heatContaminatedThreshold = {
                    label = "污染 / 阈值",
                },
                heatCultivationFreePlants = {
                    label = "种植 / 不增加风险的植物",
                },
                heatCultivationHeatPerPlant = {
                    label = "种植 / 警方关注度 / 每株植物",
                },
                heatDealerHiddenMinutes = {
                    label = "经销商 / 隐藏 / 分钟",
                },
                heatDecayPerTick = {
                    label = "衰减 / 每次更新",
                },
                heatEnabled = {
                    label = "启用",
                },
                heatEnforcementHeat = {
                    label = "警方存在 / 警方关注度",
                },
                heatEnforcementMultipliers = {
                    label = "警方存在 / 倍率",
                },
                heatEntityTypes = {
                    label = "游戏实体 / 类型",
                },
                heatEventCooldownMinutes = {
                    label = "事件 / 冷却分钟数",
                },
                heatEventHistoryLimit = {
                    label = "事件 / 历史记录上限",
                },
                heatLabHeatSyncThreshold = {
                    label = "实验室 / 警方关注度 / 同步 / 阈值",
                },
                heatLayLowCooldownMinutes = {
                    label = "避风头 / 冷却分钟数",
                },
                heatLayLowIdleMinutes = {
                    label = "避风头 / 空闲 / 分钟",
                },
                heatLayLowReduction = {
                    label = "避风头 / 减少量",
                },
                heatLockdownMinutes = {
                    label = "封锁 / 分钟",
                },
                heatMinimumDurationMinutes = {
                    label = "最小值 / 时长 / 分钟",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "最小值 / 事件 / 冷却时间（秒）",
                },
                heatMinimumIdleSeconds = {
                    label = "最小值 / 空闲 / 秒",
                },
                heatProcessingHeatMultiplier = {
                    label = "加工 / 警方关注度 / 倍率",
                },
                heatRiskWeights = {
                    label = "风险 / 权重",
                },
                heatRotateBurnerReduction = {
                    label = "更换一次性手机 / 减少量",
                },
                heatRouteControlMinutes = {
                    label = "路线 / 控制 / 分钟",
                },
                heatSaleHeat = {
                    label = "销售 / 警方关注度",
                },
                heatThresholds = {
                    label = "阈值",
                },
                heatTickMinutes = {
                    label = "更新周期 / 分钟",
                },
                heatWholesaleHeatMultiplier = {
                    label = "批发 / 警方关注度 / 倍率",
                },
                heatWorkerLeakAlertRadius = {
                    label = "工人 / 信息泄露 / 警报半径",
                },
                heatWorkerLeakBaseChance = {
                    label = "工人 / 信息泄露 / 基础值 / 概率",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "工人 / 信息泄露 / 帮派 / 倍率",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "工人 / 信息泄露 / 高 / 严重程度 / 阈值",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "工人 / 信息泄露 / 忠诚度 / 概率 / 倍率",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "工人 / 信息泄露 / 忠诚度 / 阈值",
                },
                heatWorkerLeakMaximumChance = {
                    label = "工人 / 信息泄露 / 最大值 / 概率",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "工人 / 信息泄露 / 最小值 / 冷却时间（秒）",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "工人 / 信息泄露 / 路线 / 倍率",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "工人 / 信息泄露 / 强度 / 最大值",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "工人 / 信息泄露 / 强度 / 最小值",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "工人 / 信息泄露 / 强度 / 倍率",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "工人 / 信息泄露 / 压力 / 概率 / 倍率",
                },
                heatWorkerLeakStressThreshold = {
                    label = "工人 / 信息泄露 / 压力 / 阈值",
                },
                contactsActionCooldownSeconds = {
                    label = "动作冷却时间 / 秒",
                },
                contactsActiveHotspotCount = {
                    label = "活跃热点数量",
                },
                contactsBurnerHintTrust = {
                    label = "临时手机提示 / 信任",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "一次性手机 / 报价 / 最大值 / 倍率",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "一次性手机 / 报价 / 最小值 / 倍率",
                },
                contactsBuyerCooldownMinutes = {
                    label = "买家 / 冷却分钟数",
                },
                contactsBuyerDeliveryDistance = {
                    label = "买家 / 送达距离",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "买家 / 高级 / 成功 / 分数",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "买家 / 高级 / 信任 / 增益",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "买家 / 请求 / 热度与风险 / 权重",
                },
                contactsBuyerStandardTrustGain = {
                    label = "买家 / 标准型 / 信任 / 增益",
                },
                contactsContactActiveDelaySeconds = {
                    label = "联系人激活延迟 / 秒",
                },
                contactsContactDemandRange = {
                    label = "联系方式 / 需求 / 数值范围",
                },
                contactsContactLossTrust = {
                    label = "联系方式 / 亏损 / 信任",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "暗网 / 精确情报 / 分钟",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "暗网 / 热点 / 情报 / 价格",
                },
                contactsDarknetIntelPrice = {
                    label = "暗网 / 情报 / 价格",
                },
                contactsDealerBasePrice = {
                    label = "经销商 / 基础价格",
                },
                contactsDealerHireCapacity = {
                    label = "经销商 / 雇用 / 容量",
                },
                contactsDealerHireRisk = {
                    label = "经销商 / 雇用 / 风险",
                },
                contactsDealerHireSkill = {
                    label = "经销商 / 雇用 / 技能",
                },
                contactsDealerOffers = {
                    label = "经销商报价",
                },
                contactsDealerProtectionHours = {
                    label = "经销商 / 保护 / 小时",
                },
                contactsDealerProtectionPrice = {
                    label = "经销商 / 保护 / 价格",
                },
                contactsDealerSaleMax = {
                    label = "经销商 / 销售 / 最大值",
                },
                contactsDealerSaleMin = {
                    label = "经销商 / 销售 / 最小值",
                },
                contactsDealerSimulation = {
                    label = "经销商 / 模拟",
                },
                contactsDealerTickMinutes = {
                    label = "经销商 / 更新周期 / 分钟",
                },
                contactsDealerWage = {
                    label = "经销商 / 工资",
                },
                contactsDealerWageDecay = {
                    label = "经销商 / 工资 / 衰减",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "经销商 / 工资 / 忠诚度 / 增益",
                },
                contactsDealerWeaknesses = {
                    label = "经销商 / 弱点",
                },
                contactsDefaultContactDemand = {
                    label = "默认值 / 联系方式 / 需求",
                },
                contactsDefaultContactRisk = {
                    label = "默认值 / 联系方式 / 风险",
                },
                contactsDefaultDealerCapacity = {
                    label = "默认贩子 / 容量",
                },
                contactsDefaultDealerRisk = {
                    label = "默认贩子 / 风险",
                },
                contactsDefaultDealerSkill = {
                    label = "默认贩子 / 技能",
                },
                contactsDefaultHotspotRadius = {
                    label = "默认值 / 热点 / 半径",
                },
                contactsDemandResetMinutes = {
                    label = "需求重置（分钟）",
                },
                contactsEnabled = {
                    label = "启用",
                },
                contactsExactLocationTrust = {
                    label = "精确位置 / 信任",
                },
                contactsFactionDiscoveryReputation = {
                    label = "帮派 / 发现 / 声望",
                },
                contactsFactionHintTrust = {
                    label = "帮派 / 线索 / 信任",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "交付失败 / 冷却分钟数",
                },
                contactsFakeDealEncounter = {
                    label = "虚假交易 / 遭遇",
                },
                contactsFallbackPreferredDrug = {
                    label = "备用值 / 首选毒品",
                },
                contactsFallbackProductLabel = {
                    label = "备用值 / 产品名称",
                },
                contactsGuideBookItem = {
                    label = "指南 / 书籍 / 物品",
                },
                contactsGuideBookTrust = {
                    label = "指南 / 书籍 / 信任",
                },
                contactsHireDealerPrice = {
                    label = "雇佣代理商 / 价格",
                },
                contactsHistoryLimit = {
                    label = "历史记录上限",
                },
                contactsHotspotIntelMinutes = {
                    label = "热点 / 情报 / 分钟",
                },
                contactsHotspotRotationMinutes = {
                    label = "热点 / 轮换 / 分钟",
                },
                contactsListingDurationMinutes = {
                    label = "上架商品 / 时长 / 分钟",
                },
                contactsMaxOwnedDealers = {
                    label = "最大值 / 已持有 / 毒贩",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "最小值 / 买家 / 送达距离",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "最小值 / 接触轮换（分钟）",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "最小值 / 需求重置（分钟）",
                },
                contactsMinimumHeatMultiplier = {
                    label = "最小值 / 警方关注度 / 倍率",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "最小值 / 热点 / 情报 / 分钟",
                },
                contactsMinimumHotspotRadius = {
                    label = "最小值 / 热点 / 半径",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "最小值 / 热点 / 轮换 / 分钟",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "最小值 / 上架商品 / 时长 / 分钟",
                },
                contactsMinimumRewardMultiplier = {
                    label = "最低奖励 / 倍率",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "最小值 / 抢劫 / 倍率",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "最小值 / 地点 / 价格倍数",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "其他 / 毒品 / 价格倍数",
                },
                contactsPaymentAccount = {
                    label = "付款账户",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "交付后 / 需求 / Reset / 秒",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "首选毒品 / 价格倍数",
                },
                contactsRegionLocationTrust = {
                    label = "地区 / 地点 / 信任",
                },
                contactsRequestAmounts = {
                    label = "请求 / 数量",
                },
                contactsRotationMinutes = {
                    label = "轮换 / 分钟",
                },
                contactsSpotPools = {
                    label = "地点 / 候选池",
                },
                contactsStreetHotspots = {
                    label = "街道 / 热点",
                },
                contactsTrustLevels = {
                    label = "信任 / 等级",
                },
                businessActionCooldownSeconds = {
                    label = "动作冷却时间 / 秒",
                },
                businessBalance = {
                    label = "余额",
                },
                businessContracts = {
                    label = "合同",
                },
                businessDefaultBusinessName = {
                    label = "默认值 / 业务名称",
                },
                businessDefaultRankId = {
                    label = "默认值 / 等级 / ID",
                },
                businessDefaultStaffStyle = {
                    label = "默认值 / 工作人员 / 工作方式",
                },
                businessDefaultTransport = {
                    label = "默认值 / 运输",
                },
                businessEnabled = {
                    label = "启用",
                },
                businessHubs = {
                    label = "分销中心",
                },
                businessLimits = {
                    label = "限制",
                },
                businessPayments = {
                    label = "支付方式",
                },
                businessPayoutAccount = {
                    label = "付款 / 账户",
                },
                businessRanks = {
                    label = "职级",
                },
                businessReportDays = {
                    label = "报告周期 / 天",
                },
                businessRouteEndpointTypes = {
                    label = "路线 / 终点 / 类型",
                },
                businessRuntime = {
                    label = "游戏运行",
                },
                businessSocietyPermission = {
                    label = "组织 / 权限",
                },
                businessStaff = {
                    label = "工作人员",
                },
                businessTickMinutes = {
                    label = "更新周期 / 分钟",
                },
                businessTransports = {
                    label = "运输",
                },
            },
            territorySettings = {
                section = "领地",
                zonesGroup = "领地区域",
                sourceLabel = "区域来源",
                sourceDescription = "使用受保护的预设区域或定义您自己的领地多边形。",
                sourcePreset = "预设区域",
                sourceCustom = "自定义领地",
                editLabel = "领地编辑器",
                editDescription = "编辑所选区域来源所使用的区域。",
                editButton = "编辑领地",
                presetSection = "预设区域",
                presetEntry = "预设区域",
                customSection = "自定义领地",
                customEntry = "自定义领地",
                typeLabel = "领地类型",
                streetType = "街道",
                supplyType = "供应",
                enabledLabel = "在地图上显示",
                enabledDescription = "禁用的预设区域将从地图上移除且无法被占领。",
                zoneLabel = "领地边界",
                zoneDescription = "请沿领地边界按顺序至少设置三个点。",
                ownershipGroup = "所有权",
                decayGroup = "衰减",
                presenceGroup = "存在感",
                activityGroup = "活动评分",
                ownershipBenefitsGroup = "所有权收益",
                ownershipThresholdLabel = "所有权门槛",
                ownershipThresholdDescription = "帮派必须超过的控制百分比，方可正式拥有该领地。",
                activityFloorLabel = "固定活动底线",
                activityFloorDescription = "当基于大小的底线被禁用时，所需的计算影响力点数。",
                floorByZoneSizeLabel = "按区域大小缩放底线",
                floorByZoneSizeDescription = "根据多边形面积计算每个领地的活动底线，而非使用固定底线。",
                floorPointsPerSizeUnitLabel = "每平方公里底线点数",
                floorPointsPerSizeUnitDescription = "每个平方公里的领地面积所需的活动底线点数。",
                fixedFloorRequirement = "禁用基于大小的底线以编辑固定活动底线。",
                sizeFloorRequirement = "启用基于大小的底线以编辑每平方公里的点数。",
                dailyDecayLabel = "每日影响力衰减",
                dailyDecayDescription = "每 24 小时移除的百分比影响力。",
                presenceIntervalLabel = "存在间隔",
                presenceIntervalDescription = "自动发放领地存在奖励之间的时间间隔（分钟）。",
                presencePointsLabel = "每名成员的存在点数",
                presencePointsDescription = "每个间隔发放给每位符合条件的帮派成员的存在点数。",
                drugSalesEnabledLabel = "NPC 销售可提供领地影响力",
                drugSalesEnabledDescription = "在当前街道领地内向 NPC 成功进行街头销售，将为销售者的帮派提供影响力。",
                drugSalePointsLabel = "每件毒品销售点数",
                drugSalePointsDescription = "每件被报告售出的毒品单位获得的影响力点数。",
                drugSalesRequirement = "启用 NPC 销售影响力以配置其点数。",
                graffitiPointsLabel = "每 24 小时涂鸦点数",
                graffitiPointsDescription = "当一个涂鸦累计存在 24 个报告小时后，发放存在点数。",
                streetSellingPriceBonusLabel = "街头销售价格加成",
                streetSellingPriceBonusDescription = "街道领地正式所有者的毒品销售价格百分比加成。",
                supplyProductionSpeedBonusLabel = "供应生产速度加成",
                supplyProductionSpeedBonusDescription = "供应领地正式所有者的毒品生产速度百分比加成。",
                pruneToleranceLabel = "影响力修剪容差",
                pruneToleranceDescription = "低于此值的有效影响力将被视为零。",
            },
            graffitiSettings = {
                section = "涂鸦",
                generalGroup = "常规",
                streamingGroup = "正在渲染",
                moderationGroup = "审核",
                graffitiEnabledLabel = "启用涂鸦",
                graffitiEnabledDescription = "允许玩家喷涂和查看涂鸦。",
                graffitiRequireItemLabel = "需要喷漆罐",
                graffitiRequireItemDescription = "玩家需要喷漆罐物品才能进行喷涂。否则将使用 /graffiti 命令。",
                graffitiChargesPerCanLabel = "每罐喷涂次数",
                graffitiChargesPerCanDescription = "单个喷漆罐可以创作的涂鸦数量。",
                graffitiCooldownSecondsLabel = "喷漆冷却时间",
                graffitiCooldownSecondsDescription = "玩家两次喷漆之间必须等待的秒数。",
                graffitiMaxPerPlayerLabel = "每个玩家最大喷漆数",
                graffitiMaxPerPlayerDescription = "单个玩家可以拥有的最大活跃喷漆数。0 表示无限制。",
                graffitiMaxDistanceLabel = "最大喷漆距离",
                graffitiMaxDistanceDescription = "以米为单位，喷漆时墙壁的最远距离。",
                graffitiSprayDurationLabel = "喷漆持续时间",
                graffitiSprayDurationDescription = "喷漆动画持续的时间（毫秒）。",
                graffitiExpiryDaysLabel = "有效期",
                graffitiExpiryDaysDescription = "喷漆自动消失前的天数。0 表示永不消失。",
                graffitiTerritoryHoursLabel = "每次喷漆增加的领地时长",
                graffitiTerritoryHoursDescription = "新喷漆为所属帮派提供的领地存在时长（小时）。",
                graffitiStreamRadiusLabel = "流式渲染半径",
                graffitiStreamRadiusDescription = "玩家可以看到喷漆的距离（米）。",
                graffitiPoolSizeLabel = "贴图池大小",
                graffitiPoolSizeDescription = "同时渲染的喷漆数量。数值越高，性能消耗越大。",
                graffitiReportsEnabledLabel = "启用举报",
                graffitiReportsEnabledDescription = "允许玩家举报违规喷漆。",
                graffitiAutoHideThresholdLabel = "自动隐藏阈值",
                graffitiAutoHideThresholdDescription = "触发喷漆自动隐藏所需的举报数量。0 表示禁用此功能。",
            },
            darknetSettings = {
                section = "暗网市场",
                availabilityGroup = "可用性",
                economyGroup = "加密货币",
                listingsGroup = "报价与有效期",
                chatGroup = "私聊",
                identityGroup = "别名与声望",
                deliveryGroup = "交付与死信箱",
                policeGroup = "警方权限",
                npcGroup = "NPC 交易者",
                enabledLabel = "启用暗网市场",
                enabledDescription = "使黑市平板应用及其运行逻辑生效。",
                tabletOrderLabel = "平板应用排序",
                tabletOrderDescription = "控制暗网市场在平板电脑上的显示位置。",
                currencyCodeLabel = "货币代码",
                currencyCodeDescription = "用于内部加密货币账本的简短标签。",
                starterBalanceLabel = "新钱包余额",
                starterBalanceDescription = "仅在玩家首次打开市场时分配加密货币。",
                exchangeEnabledLabel = "启用代币兑换",
                exchangeEnabledDescription = "允许已认证的 BlackBay 用户在个人账户页面买卖代币。",
                exchangeAccountLabel = "兑换支付账户",
                exchangeAccountDescription = "用于代币购买和销售结算的框架账户。",
                exchangeBuyPriceLabel = "代币买入价",
                exchangeBuyPriceDescription = "每枚代币从支付账户扣除的金额。",
                exchangeSellPriceLabel = "代币卖出价",
                exchangeSellPriceDescription = "每枚代币支付到支付账户的金额。",
                exchangeMinimumLabel = "单次兑换最低代币数",
                exchangeMinimumDescription = "单次兑换所接受的最小整数代币数量。",
                exchangeMaximumLabel = "单次兑换最高代币数",
                exchangeMaximumDescription = "单次兑换所接受的最大整数代币数量。",
                accountMoney = "现金",
                accountBank = "银行",
                accountBlackMoney = "脏钱",
                scamChanceLabel = "全局 NPC 诈骗概率 (%)",
                scamChanceDescription = "NPC 在交易中拿走付款或货物却不交付回报的最低概率。更高的交易者特定概率仍然有效。",
                listingExpiryLabel = "报价有效期 (小时)",
                listingExpiryDescription = "活跃报价将在指定小时数后自动过期。",
                renewalHoursLabel = "续期时长 (小时)",
                renewalHoursDescription = "所有者续期报价时增加的小时数。",
                maximumListingsLabel = "最大活跃报价数",
                maximumListingsDescription = "每个活跃别名的最大报价数。",
                maximumQuantityLabel = "最大商品数量",
                maximumQuantityDescription = "单个报价的最大商品数量限制。",
                maximumPriceLabel = "最高单价",
                maximumPriceDescription = "单个单位的最高加密货币价格。",
                maximumMessageLengthLabel = "最大消息长度",
                maximumMessageLengthDescription = "每条加密聊天消息的最大字符数。",
                aliasCooldownLabel = "别名变更冷却时间 (小时)",
                aliasCooldownDescription = "身份在可以再次注销前所需的最低存续时间。",
                verifiedSalesLabel = "验证所需的销售额",
                verifiedSalesDescription = "卖家成为验证卖家之前所需的成功销售次数。",
                verifiedRatingLabel = "验证所需的评分",
                verifiedRatingDescription = "验证卖家所需的最低平均评分。",
                scammerReportsLabel = "骗子警告举报数",
                scammerReportsDescription = "获得“已知骗子”徽章所需的唯一交易举报数。",
                meetingDistanceLabel = "交货距离",
                meetingDistanceDescription = "两名玩家之间或与配置的 NPC 地点之间的最大距离。",
                dropModelLabel = "死信箱箱体模型",
                dropModelDescription = "用于可用死信箱的本地生成的 GTA 道具模型。",
                dropStreamLabel = "死信箱流式传输距离",
                dropStreamDescription = "箱子和 NPC 会面点开始加载的距离。",
                dropInteractionLabel = "死信箱交互距离",
                dropInteractionDescription = "搜索并领取箱子所需的距离。",
                dropLifetimeLabel = "死信箱有效期 (小时)",
                dropLifetimeDescription = "未领取箱子过期前的时长。",
                dropPollLabel = "世界刷新间隔 (ms)",
                dropPollDescription = "用于刷新附近箱子和 NPC 会面的间隔时间。",
                policeGroupsLabel = "授权警察职业组",
                policeGroupsDescription = "可以发布诱饵报价并查看调查的职业配置组密钥。",
                policeGroupEntry = "警察组",
                groupKeyLabel = "组密钥",
                npcTradersLabel = "NPC 买家与卖家",
                npcTradersDescription = "配置持久化合成报价、交付方式、声誉和诈骗概率。",
                npcTraderEntry = "NPC 交易商",
                npcIdLabel = "ID",
                npcAliasLabel = "别名",
                npcSideLabel = "市场端",
                sideSell = "向玩家出售",
                sideBuy = "从玩家处购买",
                npcTitleLabel = "报价标题",
                npcDescriptionLabel = "描述",
                npcItemNameLabel = "库存物品名称",
                npcItemLabelLabel = "商品标签",
                npcQuantityLabel = "数量",
                npcPriceLabel = "单价",
                npcDeliveryLabel = "交付方式",
                deliveryBoth = "会面与死信箱",
                deliveryMeeting = "仅限面交",
                deliveryDrop = "仅限死信箱",
                npcScamChanceLabel = "交易商诈骗概率 (%)",
                npcPedModelLabel = "NPC Ped 模型",
                npcRatingLabel = "显示评分",
                npcRatingCountLabel = "显示评分数量",
                npcTradesLabel = "显示成功交易数",
                npcVerifiedLabel = "验证交易商",
                npcScammerLabel = "已知骗子",
                npcEnabledLabel = "已启用",
            },
            interrogationSettings = {
                section = "审讯",
                generalGroup = "常规",
                consentGroup = "玩家保护",
                objectGroup = "对象",
                grabGroup = "制服",
                sessionGroup = "环节",
                dispatchGroup = "警方警报",
                loggingGroup = "日志记录",
                securityGroup = "安全",
                presentationGroup = "展示界面",
                enabledLabel = "启用审讯",
                enabledDescription = "允许玩家将他人绑在审讯椅上并对其使用工具。",
                consentRequiredLabel = "需要征得同意",
                consentRequiredDescription = "只有选择加入的玩家才能成为受害者。不再有单独的同意功能，需使用下方的设置。",
                consentDefaultLabel = "默认选择加入",
                consentDefaultDescription = "新角色默认处于已同意状态，而非拒绝状态。",
                globalIntensityLabel = "效果强度",
                globalIntensityDescription = "缩放屏幕效果、粒子和声音。0 将完全关闭它们。",
                maxPerPlayerLabel = "每位玩家的对象数",
                maxPerPlayerDescription = "每位玩家最多可放置的椅子和推车数量。0 表示无限制。",
                maxGlobalLabel = "全服务器对象总数",
                maxGlobalDescription = "同时允许放置的对象总数。0 表示无限制。",
                placementDistanceLabel = "放置距离",
                placementDistanceDescription = "物体可以放置在距离玩家多远的范围内（单位：米）。",
                interactDistanceLabel = "交互距离",
                interactDistanceDescription = "玩家必须靠近椅子或推车多少距离才能使用（单位：米）。",
                inactivityMinutesLabel = "超时自动移除",
                inactivityMinutesDescription = "放置物品在无人使用多少分钟后会消失。0 将永久保留该物品。",
                persistObjectsLabel = "重启后保留对象",
                persistObjectsDescription = "服务器重启后，放置的对象将从数据库中恢复。",
                grabEnabledLabel = "启用抓取",
                grabEnabledDescription = "允许玩家通过武力制服并扛走另一名玩家。",
                grabItemLabel = "所需物品",
                grabItemDescription = "攻击者抓取他人所需的物品。留空则表示不需要物品。",
                grabAngleLabel = "接近角度",
                grabAngleDescription = "攻击者可以站在目标正后方侧向多少度范围内（单位：度）。",
                grabHealthBelowLabel = "生命值阈值",
                grabHealthBelowDescription = "生命值低于此数值的受害者可以在未被束缚的情况下被抓取。0 可禁用此功能。",
                grabCooldownLabel = "失败后的冷却时间",
                grabCooldownDescription = "抓取失败后，再次尝试抓取所需的秒数。",
                grabVehiclesLabel = "允许的载具",
                grabVehiclesDescription = "被抓取的受害者可以被装入的载具型号。",
                carryEnabledLabel = "允许扛行",
                carryEnabledDescription = "允许攻击者将受害者扛在肩上。",
                restrictVisionLabel = "限制受害者视野",
                restrictVisionDescription = "在运输受害者时，使其屏幕变黑。",
                escapeEnabledLabel = "允许挣脱尝试",
                escapeEnabledDescription = "让被运输的受害者尝试挣脱束缚。",
                escapeSecondsLabel = "挣脱持续时间",
                escapeSecondsDescription = "受害者必须按住按键多少秒才能挣脱。",
                maxDurationLabel = "最大持续时间",
                maxDurationDescription = "审讯自动结束前的分钟数。",
                warnMinutesLabel = "结束前的警告",
                warnMinutesDescription = "在达到限制前多少分钟，双方都会收到警告。",
                idleMinutesLabel = "闲置时释放",
                idleMinutesDescription = "在没有任何互动的情况下，多少分钟后受害者将被释放。",
                selfReleaseMinutesLabel = "无攻击者互动后自动释放",
                selfReleaseMinutesDescription = "在攻击者停止互动多少分钟后，受害者可以自行挣脱。",
                graceSecondsLabel = "断开连接后的宽限期",
                graceSecondsDescription = "当攻击者离开服务器时，受害者保持被捆绑状态的秒数。",
                rescueEnabledLabel = "允许营救",
                rescueEnabledDescription = "允许无关玩家释放被捆绑的受害者。",
                rescueSecondsLabel = "营救持续时间",
                rescueSecondsDescription = "营救者解开受害者束缚所需的秒数。",
                rescueItemLabel = "营救所需物品",
                rescueItemDescription = "营救者所需的物品。留空则表示不需要物品。",
                allowInventoryLabel = "受害者保留物品栏",
                allowInventoryDescription = "被捆绑的受害者仍可以打开其物品栏。",
                dispatchEnabledLabel = "启用警察警报",
                dispatchEnabledDescription = "向紧急服务部门报告绑架和审讯事件。",
                dispatchAdapterLabel = "警报系统",
                dispatchAdapterDescription = "接收报告的调度系统。",
                dispatchJobsLabel = "接收任务",
                dispatchJobsDescription = "接收警报的任务/职业。",
                dispatchGrabChanceLabel = "抓取触发概率",
                dispatchGrabChanceDescription = "触发抓取警报的百分比概率。",
                dispatchFixateChanceLabel = "捆绑成功率",
                dispatchFixateChanceDescription = "将人捆绑在椅子上的行为被举报的概率。",
                dispatchToolChanceLabel = "工具使用成功率",
                dispatchToolChanceDescription = "使用工具的行为被举报的概率。",
                dispatchWitnessLabel = "需要目击者",
                dispatchWitnessDescription = "仅在有其他玩家足够近并能察觉时才进行举报。",
                dispatchWitnessRadiusLabel = "目击者半径",
                dispatchWitnessRadiusDescription = "目击者必须靠近的距离（单位：米）。",
                dispatchCooldownLabel = "警报冷却时间",
                dispatchCooldownDescription = "同一场审讯中两次警报之间的时间间隔（单位：秒）。",
                dispatchInaccuracyLabel = "位置偏差",
                dispatchInaccuracyDescription = "举报位置随机偏移的距离（单位：米）。0 会报告精确位置。",
                loggingEnabledLabel = "启用日志",
                loggingEnabledDescription = "记录放置、抓取、工具使用、释放及管理员操作。",
                logDatabaseLabel = "写入数据库",
                logDatabaseDescription = "同时将每条记录写入审讯日志表。",
                logRetentionLabel = "保留日志条目",
                logRetentionDescription = "数据库日志条目被清理前的天数。0 会永久保留它们。",
                pingToleranceLabel = "距离容差",
                pingToleranceDescription = "在每次服务器端距离检查中增加的距离（单位：米），用于抵消延迟影响。",
                violationThresholdLabel = "违规阈值",
                violationThresholdDescription = "在触发反应前，窗口期内允许的违规次数。0 会禁用此功能。",
                violationActionLabel = "违规反应",
                violationActionDescription = "当玩家超过违规阈值时会发生的情况。",
                violationActionNone = "不执行任何操作",
                violationActionLog = "仅记录日志",
                violationActionKick = "踢出",
                violationActionCheating = "举报为作弊",
                particlesLabel = "粒子效果",
                particlesDescription = "在使用工具时显示血液、火花和火焰。",
                soundLabel = "音效",
                soundDescription = "为附近的玩家播放工具音效。",
                cameraWorkLabel = "镜头效果",
                cameraWorkDescription = "在捆绑某人及使用工具时移动镜头。",
                screenEffectsLabel = "屏幕效果",
                screenEffectsDescription = "受害者屏幕上的震动、闪烁、模糊和色彩滤镜。",
                objectsSection = "审讯道具",
                objectsEntry = "道具",
                objectsEditLabel = "审讯道具",
                objectsEditDescription = "在地图上放置永久性的椅子和工具车。",
                objectsEditButton = "编辑道具",
                objectsKindLabel = "道具类型",
                objectsKindChair = "椅子",
                objectsKindCart = "工具车",
                objectsModelLabel = "道具模型",
                objectsPositionLabel = "位置",
                blockedZonesSection = "禁区",
                blockedZonesEntry = "区域",
                blockedZonesEditLabel = "禁区",
                blockedZonesEditDescription = "禁止放置审讯道具的区域。",
                blockedZonesEditButton = "编辑区域",
                blockedZonesZoneLabel = "区域轮廓",
                blockedZonesZoneDescription = "拖动角点来设定禁止放置道具的区域。",
                toolsSection = "工具",
                toolsEntry = "工具",
                toolsEditLabel = "工具",
                toolsEditDescription = "添加或调整可在受害者身上使用的工具。",
                toolsEditButton = "编辑工具",
                toolsItemLabel = "所需物品",
                toolsConsumeLabel = "消耗物品",
                toolsDamageLabel = "单次使用伤害",
                toolsHealthFloorLabel = "生命值下限",
                toolsCooldownLabel = "冷却时间（秒）",
                toolsProgressLabel = "每次使用进度",
                sessionsSection = "进行中的审讯",
                sessionsEntry = "审讯",
                sessionsEditLabel = "进行中的审讯",
                sessionsEditDescription = "查看当前正在进行的审讯，并在需要时终止它。",
                sessionsEditButton = "显示审讯",
                sessionsStateLabel = "状态",
                sessionsProgressLabel = "进度",
                orphansSection = "孤立对象",
                orphansEntry = "道具",
                orphansEditLabel = "孤立对象",
                orphansEditDescription = "移除所有者已长时间未在线的对象。",
                orphansEditButton = "清理",
                sessionStates = {
                    binding = "正在束缚",
                    active = "进行中",
                    ending = "正在结束",
                },
            },
        },
    },
}
