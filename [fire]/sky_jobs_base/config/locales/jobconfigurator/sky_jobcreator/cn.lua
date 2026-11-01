JobConfigLocales["sky_jobcreator:cn"] = {
    Nui = {
        workshopConfig = {
            creatorSections = { stations = { label = "站点", entryLabel = "站点", entryPluralLabel = "站点" } },
            jobDocuments = {
                title = "文档登记",
                description = "查看并打印此职业的文档。",
                templates = "模板",
                hint = "使用 {{CUSTOMER}} 创建输入字段。{{AUTHOR}}、{{JOB}} 和 {{DATE}} 将自动填写。",
                key = "技术标识",
                label = "模板",
                body = "模板正文",
                active = "启用",
                enabled = "文档登记",
            },
            configs = {
                sky_jobscreator = { title = "创业者", subtitle = "管理职业、等级和新条目的默认值。" },
                sky_jobscreator_gangs = { title = "黑帮创造者", subtitle = "管理原生帮派及其等级。" },
            },
            extensions = {
                billingSettings = { label = "账单", description = "允许此职业开具新账单。现有账单仍可查看。" },
                billingPrices = { label = "账单目录", description = "此职业开具账单时使用的原因和价格。", itemLabel = "账单项目" },
            },
            billingFields = {
                enabled = "开具账单", reason = "原因标识", label = "显示名称", amount = "金额",
            },
            settingSections = {
                creatorDefaults = "新职业",
                creatorGrades = "默认等级",
            },
            settings = {
                creatorDefaultJobType = {
                    label = "默认职业类型",
                    description = "新 QBCore/Qbox 职业的框架分类，例如 civ、police 或 ems。",
                },
                creatorDefaultDuty = {
                    label = "默认在岗",
                    description = "新建 QBCore/Qbox 职业的初始值班状态。",
                },
                creatorOffDutyPay = {
                    label = "离岗时支付工资",
                    description = "新 QBCore/Qbox 职业的初始离岗工资规则。",
                },
                creatorInitialGradeName = {
                    label = "等级内部名称",
                    description = "等级 0 的默认内部名称。只能使用小写英文字母、数字和下划线。 名称 boss 保留给等级 1。",
                },
                creatorInitialGradeLabel = {
                    label = "等级显示名称",
                    description = "新职业或帮派第一个等级的默认显示名称。",
                },
                creatorInitialGradeSalary = {
                    label = "初始工资",
                    description = "新职业各等级的默认薪资。帮派不领取薪资。",
                },
                creatorInitialGradeBoss = {
                    label = "主管权限",
                    description = "新 QBCore/Qbox 职业和帮派等级 1 的初始主管标记。",
                },
                creatorInitialGradeBankAuth = {
                    label = "组织账户权限",
                    description = "新 QBCore/Qbox 职业等级 1 的初始银行权限。帮派不使用此职业权限。",
                },
            },
        },
    },
}

