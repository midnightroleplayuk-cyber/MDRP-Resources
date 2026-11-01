JobConfigLocales["sky_dojjob:en"] = {
    Nui = {
        tablet = {
            apps = {
                doj_finance = "Finance",
                doj_conditions = "Conditions",
                doj_elections = "Elections",
                doj_files = "Case File Explorer",
                doj_hearings = "Hearings",
                doj_law = "Legal Codes",
                doj_offences = "Fine Catalogue",
                doj_shared_files = "Shared Documents",
            },
        },
        workshopConfig = {
            registryFiles = {
                licenseType = "License type",
                licenseLabel = "Register name",
                marriages = "Marriage register",
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Configure DOJ jobs, courthouse locations, and the legal-code app.",
                    title = "Department of Justice Jobs",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Courthouse",
                    entryPluralLabel = "Courthouses",
                    label = "Courthouses",
                },
            },
            extensions = {
                invalidSelection = "Invalid selection: {value}",
                trainingSettings = {
                    description = "Configure training access, enrollment, approvals, and course planning for this job.",
                    label = "Training settings",
                },
            },
            features = {
                dojHandovers = {
                    label = "Handovers",
                    description = "Enable handovers, judicial decisions and execution reports. Documents and sharing remain available.",
                },
                dojBodycamRequests = {
                    label = "Bodycam requests",
                    description = "Request police footage. Requires Handovers; saved recordings remain available independently.",
                },
                dojFinance = {
                    label = "Finance",
                    description = "Faction balances, treasury transfers and transaction history.",
                },
                dojConditions = {
                    description = "Enable structured conditions, evidence, deadlines, and violation follow-up.",
                    label = "Conditions",
                },
                dojCourtroom = {
                    description = "Enable secure live courtroom sessions, evidence presentation, and role-based room interactions.",
                    label = "Live courtroom",
                },
                dojElections = {
                    description = "Enable election administration and secure voting at registered voting booths.",
                    label = "Elections",
                },
                dojHearings = {
                    description = "Enable courtroom scheduling, check-in, and authoritative hearing status controls.",
                    label = "Hearings",
                },
                dojLegalCodes = {
                    description = "Enable legal books, rich-text editing, and revision history.",
                    label = "Legal codes",
                },
                dojOffences = {
                    description = "Enable the compact offence catalogue and calculator preview.",
                    label = "Fine catalogue",
                },
                dojPrinters = {
                    description = "Enable physical printers and their runtime infrastructure.",
                    label = "Printers",
                },
                dojPublicDisplays = {
                    description = "Enable privacy-filtered live data for courthouse displays.",
                    label = "Public courtroom displays",
                },
                dojTablet = {
                    description = "Enable access to the DOJ tablet apps.",
                    label = "DOJ tablet",
                },
                dojTaxes = {
                    description = "Periodically collect vehicle and house taxes from online players.",
                    label = "Asset taxes",
                },
            },
            locations = {
                stationPosition = "Location / map blip",
                stationPositionHint = "Main point of this job location. If the map blip is enabled under Job → Blips, it appears here.",
                addCourtroom = "Add Courtroom",
                courtroom = "Courtroom",
                courtroom_display_desk_27 = "Courtroom evidence display – 27-inch desk monitor",
                courtroom_display_wall_55 = "Courtroom evidence display – 55-inch wall TV",
                courtroom_display_wall_75 = "Courtroom evidence display – 75-inch wall TV",
                courtroom_display_wall_100 = "Courtroom evidence display – 100-inch wall TV",
                courtroom_display_wall_120 = "Courtroom evidence display – 120-inch wall TV",
                courtroom_display_wall_150 = "Courtroom evidence display – 150-inch wall TV",
                courtroom_display_board_93 = "Courtroom interactive board – 150-inch mobile stand",
                courtroom_display_projection = "Courtroom evidence display – 4.5 m projection screen",
                courtroom_judge_mic = "Courtroom – judge microphone",
                courtroom_jury_room = "Courtroom – jury room",
                courtroom_room = "Courtroom – audience / room center",
                courtroom_witness = "Courtroom – witness stand",
                electionBooth = "Voting Booth",
                publicDisplayDesk27 = "Public Display – 27-inch Desk Monitor",
                publicDisplayTerminal43 = "Public Display – 43-inch Floor Terminal",
                publicDisplayWall55 = "Public Display – 55-inch Wall TV",
                publicDisplayWall75 = "Public Display – 75-inch Wall TV",
                publicDisplayWall100 = "Public Display – 100-inch Wall TV",
                publicDisplayWall120 = "Public Display – 120-inch Wall TV",
                publicDisplayWall150 = "Public Display – 150-inch Wall TV",
                publicDisplayProjection = "Public Display – 4.5 m Projection Screen",
                publicLegalCode = "Public Legal Code",
            },
            printers = {
                groups = {
                    paper = "Paper",
                    ink = "Ink",
                    general = "Printer",
                    printing = "Printing & access",
                    placement = "Model & placement",
                },
                actions = {
                    selectExisting = "Select existing printer",
                    selectExistingHint = "Aim at the printer. Enter: select · Esc: cancel",
                    add = "Add printer",
                    open = "Inspect printer",
                    place = "Place printer",
                    setPosition = "Use current location",
                },
                classes = {
                    office = "Office",
                    professional = "Professional",
                    standard = "Standard",
                },
                description = "Configure printers, supplies, queues, access and placement for this job.",
                fieldDescriptions = {
                    paperCapacity = "Maximum paper stock used by every printer in this job.",
                    paperEnabled = "When enabled, every printer in this job starts empty and requires the shared refill item.",
                    refillAmount = "Paper added to any printer in this job when the shared refill item is used.",
                    refillItem = "Internal inventory item name consumed when any printer in this job is refilled.",
                },
                fields = {
                    active = "Active",
                    class = "Class",
                    heading = "Heading",
                    id = "Stable ID",
                    label = "Label",
                    maxQueue = "Queue capacity",
                    minimumGrade = "Minimum grade",
                    paperCapacity = "Paper capacity",
                    paperEnabled = "Require paper refills",
                    propModel = "Prop model",
                    refillAmount = "Paper per refill item",
                    refillItem = "Refill item",
                    deleteCopiesAfterRestart = "Delete copies after restart",
                    deleteCopiesAfterRestartHint = "Clear uncollected printouts when the printer service restarts.",
                    spawnProp = "Spawn prop",
                    speed = "Print speed",
                    status = "Status",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Class: {class}",
                    paper = "Paper: {paper} / {capacity}",
                    queue = "Queue: {queue} / {maxQueue}",
                    status = "Status: {status}",
                    title = "Printer",
                },
                messages = {
                    grade_too_low = "Your grade is too low for this printer.",
                    invalid_amount = "The refill amount is invalid.",
                    missingModel = "Select a valid printer prop model before placement.",
                    missing_refill_item = "You do not have the configured refill item.",
                    no_refill_printer = "No accessible paper-enabled printer is nearby.",
                    paper_capacity_exceeded = "The paper capacity would be exceeded.",
                    paper_disabled = "Paper stock is disabled for this printer.",
                    paper_full = "This printer's paper stock is already full.",
                    printer_inactive = "This printer is inactive.",
                    printer_not_found = "The printer no longer exists.",
                    refill_cooldown = "Wait briefly before refilling again.",
                    refilled = "Added {amount} paper. Stock: {paper} / {capacity}.",
                    too_far_away = "Move closer to the printer.",
                    unavailable = "Printer unavailable.",
                    wrong_job = "You do not belong to this printer's job.",
                },
                settings = {
                    description = "These settings apply to every printer configured for this job.",
                    title = "Job-wide printer settings",
                },
                statuses = {
                    maintenance = "Maintenance",
                    offline = "Offline",
                    online = "Online",
                },
                title = "Printers",
                values = {
                    disabled = "Disabled",
                    enabled = "Enabled",
                    selectItem = "Select item",
                },
            },
            recordsAccessGuide = {
                description = "Choose who can access records and which domain they work in. Grades without an assignment have no access.",
                grades = {
                    assigned = "grades assigned",
                    chooseDomain = "Resolve assignment",
                    conflict = "A grade has more than one assignment. Select one domain or No access to resolve it.",
                    description = "Select one domain per grade. Choose No access for grades that should stay locked out.",
                    domainColumn = "Records domain",
                    empty = "No grades were found for the configured DOJ job.",
                    emptyHint = "Create the DOJ grades in your framework first, then reopen the configurator.",
                    gradeColumn = "Grade",
                    noAccess = "No access",
                    noResults = "No matching grade found.",
                    notFound = "No longer present in the framework",
                    search = "Search grades",
                    title = "Grade assignments",
                },
                publish = {
                    saveHint = "Click Save at the top to apply your changes. Players can then check their access again.",
                },
                status = {
                    conflict = "Resolve duplicate assignments",
                    disabled = "DOJ tablet disabled",
                    incomplete = "Assign at least one grade",
                    ready = "Ready to save",
                    unpublished = "Mapping not published yet",
                },
                steps = {
                    gradesText = "Click exactly one records domain for every grade that should receive access.",
                    gradesTitle = "Assign DOJ grades",
                    publishText = "A new mapping version is prepared automatically after every assignment change.",
                    publishTitle = "Publish and save",
                    tabletText = "The tablet must be enabled to open the case-file apps.",
                    tabletTitle = "Enable the DOJ tablet",
                },
                title = "Set up case-file access",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Court-issued warrants",
                },
                dojAccess = {
                    label = "Access",
                },
                dojCourthouseBlip = {
                    label = "Map blip",
                },
                dojLegalBooks = {
                    label = "Books",
                },
                dojLegalContentLimits = {
                    label = "Content limits",
                },
                dojLegalItem = {
                    label = "Inventory item",
                },
                dojLegalRateLimits = {
                    label = "Rate limits",
                },
                dojLegalRevisions = {
                    label = "Revisions",
                },
                dojLegalTransfers = {
                    label = "Large documents",
                },
                dojOffenceCalculation = {
                    label = "Calculator",
                },
                dojOffenceRateLimits = {
                    label = "Rate limits",
                },
                dojOffenceMiranda = {
                    label = "Catalogue guidance",
                },
                dojOffenceSource = {
                    label = "Catalogue source",
                },
                dojRecordsGradeBindings = {
                    description = "Assign every available DOJ grade to exactly one records domain, then publish the mapping.",
                    label = "Grades and records domains",
                },
                dojTaxPayment = {
                    label = "Payment",
                },
                dojTaxRates = {
                    label = "Rates",
                },
                dojTaxSchedule = {
                    label = "Schedule",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Notarial contracts",
                    powers_of_attorney = "Powers of attorney",
                    name_changes = "Name changes",
                    company_registry = "Company registry",
                    association_registry = "Association registry",
                    licensing = "Licensing",
                    administrative_decisions = "Administrative decisions",
                    administrative_objections = "Administrative objections",
                },
            },
            settingSections = {
                finance = "Finance",
                courtroom = "Courtroom",
                registries = "Registry",
                courthouses = "Courthouses",
                general = "General",
                legalCodes = "Legal codes",
                offences = "Fine catalogue",
                recordsAccess = "Case-file access",
                tablet = "Tablet",
                taxes = "Taxes",
            },
            gavel = {
                enabled = "Enabled",
                cooldown = "Trigger cooldown (ms)",
                defaultPreset = "Default strike pattern",
                prop = "Gavel prop",
                model = "Model name",
                bone = "Hand bone ID",
                offset = "Offset (metres)",
                rotation = "Rotation (degrees)",
                presets = "Strike patterns",
                single = "Single strike",
                double = "Double strike",
                strikes = "Number of strikes",
                interval = "Strike interval (ms)",
                impact = "Sound delay (ms)",
                audio = "Sound",
                asset = "Audio asset",
                volume = "Volume",
                animation = "Animation",
                dict = "Animation dictionary",
                clip = "Animation name",
                duration = "Motion duration (ms)",
                flag = "Animation flags",
                x = "X",
                y = "Y",
                z = "Z",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "License registers",
                    description = "Choose which licenses DOJ may issue. Each entry appears as its own register. Existing licenses are kept when an entry is removed.",
                },
                dojRegistryAccess = {
                    label = "Registry file access",
                    description = "Override access for registers from config/registry. An empty list uses the file defaults. Fields and server/client functions are edited in the Lua files.",
                },
                dojTreasuryJob = {
                    label = "Treasury job",
                    description = "Job whose society account receives collections and pays transfers.",
                },
                dojFinanceJobs = {
                    label = "Visible factions",
                    description = "Registered job keys available in the account overview. The treasury is always included.",
                },
                dojFinanceLimit = {
                    label = "Transfer limit",
                    description = "Maximum amount per transfer or collection.",
                },
                dojFinePaymentMode = {
                    label = "Condition fine payment",
                    description = "Direct bank payment or external invoice. Creating an invoice does not confirm payment.",
                    options = {
                        bank = "Bank payment",
                        billing = "Invoice",
                    },
                },
                dojFineSociety = {
                    label = "Fine recipient",
                    description = "Job whose society account receives condition fines.",
                },
                dojCourtroomBoardMove = {
                    label = "Move courtroom board",
                    description = "Default key to grab or release a mobile board (e.g. F). Players can override it in FiveM key bindings. Movement is temporary and resets after restart.",
                },
                dojCourtroomGavel = {
                    label = "Judge gavel",
                    description = "Gavel model, hand attachment, animation, sound and strike patterns. Changes also apply without restarting.",
                },
                dojHearingParticipantRoles = {
                    label = "Participant roles",
                    description = "Default roles: defendant, witness, juror, judge. Add custom lowercase role keys here (up to 24 characters, underscores allowed). Keep judge. Custom roles do not grant judge or jury permissions.",
                },
                dojWarrantTemplateCodes = {
                    label = "Warrant template codes",
                    description = "Template codes shown under PD Warrants after judicial signature and sharing. Defaults: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registers",
                    description = "Enable and name DOJ registers, then set job access and clearance. Existing DOJ role permissions still apply. Custom RP registers are managed in Jobs Base.",
                },
                dojCourthouseBlipCategory = {
                    description = "Category label used for courthouse map blips.",
                    label = "Blip category",
                },
                dojCourthouseBlipColor = {
                    description = "Map color used for courthouses.",
                    label = "Blip color",
                },
                dojCourthouseBlipScale = {
                    description = "Map scale used for courthouse blips.",
                    label = "Blip scale",
                },
                dojCourthouseBlipShortRange = {
                    description = "Only show courthouse blips at short range.",
                    label = "Short range",
                },
                dojCourthouseBlipSprite = {
                    description = "Map sprite used for courthouses.",
                    label = "Blip sprite",
                },
                dojLegalBookItem = {
                    description = "Inventory item for a fixed legal-code edition. First use saves its contents and date; requires individual items with metadata.",
                    label = "Legal-code book item",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimum milliseconds between legal-book creation requests.",
                    label = "Create book cooldown",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimum milliseconds between revision creation requests.",
                    label = "Create revision cooldown",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimum milliseconds between legal-book deletion requests.",
                    label = "Delete book cooldown",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimum milliseconds between revision deletion requests.",
                    label = "Delete revision cooldown",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimum milliseconds between requests for a legal book.",
                    label = "Load book cooldown",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimum milliseconds between requests for the legal-book list.",
                    label = "Load library cooldown",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Minimum timeout used for large document requests.",
                    label = "Large request timeout in milliseconds",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Maximum number of characters allowed in a legal-book abbreviation.",
                    label = "Maximum abbreviation length",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Maximum number of characters allowed in a legal-book title.",
                    label = "Maximum book title length",
                },
                dojLegalMaxContentBytes = {
                    description = "Maximum serialized size of one complete legal-book revision.",
                    label = "Maximum content size in bytes",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Maximum title length accepted while importing legacy structured paragraphs.",
                    label = "Maximum legacy paragraph title length",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Maximum number of structured paragraphs accepted during legacy imports.",
                    label = "Maximum legacy paragraphs per book",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Maximum number of characters allowed in a revision note.",
                    label = "Maximum revision note length",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Maximum number of editor nodes allowed in one revision.",
                    label = "Maximum rich-text nodes",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Per-player bandwidth limit used to transfer large legal documents.",
                    label = "Transfer rate in bytes per second",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimum milliseconds between legal-book reorder requests.",
                    label = "Reorder books cooldown",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minimum milliseconds between legal-book metadata updates.",
                    label = "Update book cooldown",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Maximum number of revisions loaded when opening a legal book.",
                    label = "Visible revision history",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimum milliseconds between server-side calculator previews.",
                    label = "Calculator cooldown",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimum milliseconds between catalogue requests.",
                    label = "Load catalogue cooldown",
                },
                dojOffenceMaxSelection = {
                    description = "Maximum number of offences included in one calculator preview.",
                    label = "Maximum selection",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minimum milliseconds between changes to the offence catalogue.",
                    label = "Catalogue edit cooldown",
                },
                dojOffenceMirandaWarning = {
                    description = "Custom warning shown in the fine catalogue. Leave empty to use the standard text in the selected language.",
                    label = "Miranda warning",
                },
                dojPrimaryColor = {
                    description = "Main color used by the DOJ job group and tablet.",
                    label = "Primary color",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "These grades work with court administration and registry records.",
                    label = "Court administration",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "These grades work with judicial records and decisions.",
                    label = "Judiciary",
                },
                dojRecordsMappingVersion = {
                    description = "Published revision of the grade-to-records-domain mapping. An empty value keeps records access disabled.",
                    label = "Publication version",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "These grades work with prosecution records.",
                    label = "Prosecution",
                },
                dojTabletRequireDuty = {
                    description = "Only on-duty DOJ employees may open the legal-code app.",
                    label = "Require duty",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Direct currency",
                },
                dojTaxHouseAmount = {
                    description = "Amount charged for each house owned by a player.",
                    label = "Tax per house",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Seconds to wait before the first collection when no previous tax cycle is stored.",
                    label = "Initial delay",
                },
                dojTaxIntervalMinutes = {
                    description = "Minutes between automatic asset-tax collection cycles.",
                    label = "Collection interval",
                },
                dojTaxNotifyPlayer = {
                    description = "Notify players after a direct collection, a bill submission, or insufficient funds.",
                    label = "Notify players",
                },
                dojTaxPaymentMode = {
                    description = "Use the selected bank/money balance directly or submit one Sky Base society bill per taxable player and tax cycle.",
                    label = "Payment method",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Bank / money balance",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ job whose configured society account receives all collected tax revenue.",
                    label = "Recipient DOJ job",
                },
                dojTaxVehicleAmount = {
                    description = "Amount charged for each vehicle owned by a player.",
                    label = "Tax per vehicle",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Allows employees to enroll themselves in available training sessions.",
                approvalRequired = "Keeps self-enrollments pending until an authorized instructor approves them.",
                defaultCapacity = "Default number of seats used when a new training session is created.",
                enabled = "Makes the Training App available to this job.",
                requireOnDuty = "Requires employees to be on duty before opening or using the Training App.",
                upcomingDays = "Number of future days shown in the Training App schedule.",
            },
            trainingFields = {
                allowSelfEnrollment = "Allow self-enrollment",
                approvalRequired = "Require enrollment approval",
                defaultCapacity = "Default capacity",
                enabled = "Enable training",
                requireOnDuty = "Require duty",
                upcomingDays = "Upcoming period (days)",
            },
        },
    },
}
