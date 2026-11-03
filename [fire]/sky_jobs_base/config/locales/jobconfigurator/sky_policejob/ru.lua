JobConfigLocales["sky_policejob:ru"] = {
    JobConfiguratorComingSoon = "Этот конфигуратор работ скоро будет доступен.",
    JobConfiguratorNoPermission = "У вас нет прав для использования этой команды.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Настройте отделения полиции, магазины, объекты, транспорт, участки и основные функции ресурса.",
                    title = "Полицейские работы",
                },
            },
            dispatchActions = {
                addChannel = "Добавить радиоканал",
                addKeyword = "Добавить ключевое слово",
                addPoi = "Добавить точку интереса",
                addReporter = "Добавить заявителя",
                addStatus = "Добавить статус FMS",
                addVehicle = "Добавить виртуальный экипаж",
                addVehicleType = "Добавить тип экипажа",
                currentLocation = "Используйте текущее местоположение",
            },
            dispatchFieldDescriptions = {
                autoAlarm = "Немедленно назначает соответствующие доступные единицы при создании инцидента.",
                available = "Подразделения в этом статусе могут быть предложены и назначены для нового инцидента.",
                averageResponseSpeedKmh = "Вычисляет отображаемую оценку прибытия с прямого расстояния.",
                callsign = "Уникальный радиосигнал, показываемый, когда игроки обслуживают этот виртуальный блок.",
                centerEnabled = "Позволяет уполномоченным дежурным членам укомплектовать диспетчерский центр.",
                channelId = "Радиоканальный идентификатор для PMA Voice, SaltyChat и YACA. Числовые идентификаторы, такие как 2500, остаются неизменными; PMA Voice отображает текстовые идентификаторы на стабильное число.",
                channelLabel = "Считываемое название канала, показанное диспетчерам и подразделениям.",
                crewCapacity = "Максимальное число сотрудников в экипаже. Значение 0 снимает ограничение.",
                defaultChannel = "Диспетчеры присоединяются к этому каналу, когда начинают смену. Подразделения подключаются вручную со вкладки Радио. Выберите Нет, чтобы использовать дефолт группы работы.",
                emergencyAppEnabled = "Делает эту работу выбираемой в качестве государственной службы в приложении телефона экстренной помощи.",
                enabled = "Делает эту работу доступной для приложения Dispatch и инцидентов с перекрестными заданиями.",
                icon = "Выберите значок, показанный для этой категории блоков в приложении Dispatch.",
                incidentAssessmentEnabled = "Показывает медицинские вопросы и вопросы оценки опасности при полном потреблении инцидента.",
                jobs = "Дополнительные имена вакансий, которые получают инциденты с использованием этого ключевого слова.",
                joinLocked = "Запрещает новым сотрудникам присоединяться после комплектования экипажа.",
                minimumCrew = "Минимальное число сотрудников в экипажах, выбранных для этого плана реагирования.",
                noUnitFallback = "Без центра или укомплектованного подразделения Sky отправляет уведомление всем дежурным членам.",
                poiId = "Постоянный технический идентификатор, доступный профилям диспетчерской после переименования точки.",
                radius = "Максимальное расстояние в метрах, на котором можно услышать объявление станции.",
                readyStatusCode = "Статус FMS, устанавливаемый при готовности ресурса к направлению.",
                requirements = "Требование отклика в виде пар типа: счет, например, PATROL:2, CRIME:1.",
                resourceType = "Классифицирует оперативный ресурс для фильтров и координации диспетчерской.",
                respondingStatusCode = "Статус FMS, устанавливаемый при выезде ресурса на происшествие.",
                shortLabel = "Необязательная короткая метка на шести кнопках памяти радиоканалов.",
                stationId = "Связывает экипаж со станцией, настроенной в профиле диспетчерской.",
                statusCode = "Числовой статус FMS, показанный на портативном радио.",
                statusLabel = "Значение этого статуса ФМС для диспетчеров и подразделений.",
                unitId = "Постоянный технический идентификатор сохраняет экипаж при изменении позывного.",
                vehicleType = "Должен соответствовать коду типа транспортного средства, сконфигурированному в предыдущем подразделе.",
                vehicleTypeCode = "Короткий единичный код, используемый в ответных требованиях, например, PATROL, CRIME, EMS или RESCUE.",
                vehicleTypeLabel = "Удобочитаемое название данной категории.",
            },
            dispatchFields = {
                address = "Адрес",
                autoAlarm = "Автоматическая сигнализация",
                available = "Доступно для отправки",
                averageResponseSpeedKmh = "Расчетная скорость реагирования (км/ч)",
                callsign = "Звонок",
                category = "Категория",
                centerEnabled = "Включить диспетчерский центр",
                channelId = "Идентификатор канала",
                code = "Код",
                crewCapacity = "Вместимость экипажа",
                defaultChannel = "Радиоканал по умолчанию",
                emergencyAppEnabled = "Показать в Emergency App",
                enabled = "Позволяет отправлять",
                icon = "Икона",
                incidentAssessmentEnabled = "Возможность проведения экстренной оценки",
                jobs = "Целевая работа (комма разделена)",
                joinLocked = "Запретить присоединение к экипажу",
                keywordCode = "Ключевой код",
                label = "Этикетка",
                minimumCrew = "Минимальный экипаж",
                name = "Имя",
                noUnitFallback = "Уведомлять дежурный персонал без подразделений",
                noneChannel = "Ни один / групповой дефолт",
                note = "Примечание",
                phone = "Телефон",
                poiId = "Постоянный ID точки интереса",
                radius = "Радиус объявления",
                readyStatusCode = "Код статуса готовности",
                requirements = "Необходимые единицы (например, PATROL:2, CRIME:1)",
                resourceType = "Тип ресурса",
                respondingStatusCode = "Код статуса выезда",
                shortLabel = "Метка памяти рации",
                stationId = "ID станции",
                type = "Тип",
                unitId = "Постоянный ID экипажа",
                vehicleType = "Тип блока реагирования",
                radioButton = "Кнопка",
                radioButtonAction = "Кнопка действия",
                radioButtonStatus = "Статус FMS",
            },
            dispatchIconOptions = {
                crime = "Отдел по борьбе с преступностью",
                emergency = "Аварийный блок",
                ems = "Подразделение СЭМ",
                fire = "Пожарная группа",
                heavy = "Тяжелая часть",
                k9 = "Блок К-9",
                medical = "Медицинский отдел",
                patrol = "Патруль",
                rescue = "Спасательная группа",
                service = "Подразделение обслуживания",
                supervisor = "Наблюдатель",
                tactical = "Тактическая единица",
            },
            dispatchNavigation = {
                active = "Активный диспетчер",
                description = "Настройте аварийный прием, радио, блоки, планы реагирования, местоположения и данные репортеров для этой работы.",
                inactive = "Диспетчер отключен",
                steps = {
                    accessText = "Включите отправку и решите, может ли эта работа укомплектовать диспетчерский центр.",
                    accessTitle = "Доступ и аварийный прием",
                    fleetText = "Настройка каналов, кодов состояния FMS, типов транспортных средств и позывных.",
                    fleetTitle = "Радио и флот",
                    responseText = "Закончите с ключевыми словами, требованиями к ответу и POI.",
                    responseTitle = "Планы реагирования",
                },
                summary = {
                    channels = "Радиоканалы",
                    plans = "Планы реагирования",
                    reporters = "Известные заявители",
                    statuses = "Доступны FMS",
                    units = "Виртуальные единицы",
                },
                title = "Отправка",
                warnings = {
                    channels = "Никаких явных радиоканалов не существует; будет использоваться резервный канал для рабочих групп.",
                    defaultChannel = "Выбранный по умолчанию канал больше не существует.",
                    disabled = "Диспетчер отключен для этой работы.",
                    statuses = "По крайней мере, один статус FMS должен быть доступен, чтобы устройства могли быть встревожены.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Определяет радиоканалы, к которым могут присоединиться подразделения и укомплектованные диспетчерские центры.",
                dispatchKeywords = "Определяет ключевые слова инцидента, необходимые подсчеты транспортных средств, участвующие рабочие места и дополнительную автоматическую тревогу.",
                dispatchPois = "Хранит станции и общие места для форм инцидентов и объявлений станций на основе местоположения.",
                dispatchReporters = "Управляет именами заявителей, номерами обратного вызова и заметками диспетчерской для этой службы.",
                dispatchStatusCodes = "Настраивает ярлыки статуса FMS и какие статусы считаются доступными для новых инцидентов.",
                dispatchVehicleTypes = "Определяет категории подразделений, используемые планами реагирования, такими как патруль, подразделение по борьбе с преступностью, EMS или Спасение.",
                dispatchVehicles = "Определяет виртуальные диспетчерские транспортные средства, которые могут быть укомплектованы из любого места, не требуя нерестового транспортного средства.",
                dispatchRadioButtons = "Устанавливает централизованно предопределённое действие для каждой кнопки физической функции.",
                dispatchRadioFmsKeys = "Присвоить статус FMS физическим числам. Клавиатура выполняет только FMS изменения.",
            },
            extensions = {
                caseNumbering = {
                    label = "Номера дел",
                    description = "Настройка автоматических номеров дел для этой работы.",
                    fields = {
                        prefix = {
                            label = "Префикс дела",
                            description = "Префикс новых дел, например LSPD или LSCSD. До 16 символов с переводом в верхний регистр; пустое поле означает CASE. Существующие и назначенные вручную номера сохраняются.",
                        },
                    },
                },
                dispatchReporters = "Известные заявители",
                invalidSelection = "Недопустимый выбор: {value}",
                trainingSettings = {
                    description = "Настройте доступ к обучению, зачисление, утверждения и планирование курса для этой работы.",
                    label = "Условия обучения",
                },
                dispatchChannels = "Радиоканалы",
                dispatchKeywords = "Ключевые слова и планы действий",
                dispatchPois = "Диспетчерские ПОИ",
                dispatchSettings = {
                    description = "Настроить доступ к диспетчеру, аварийный вход и радиоканал по умолчанию.",
                    label = "Параметры диспетчерской",
                },
                dispatchStatusCodes = "Коды состояния",
                dispatchVehicleTypes = "Типы диспетчерских транспортных средств",
                dispatchVehicles = "Данные о диспетчерском парке",
                emptyDescription = "Используйте кнопку добавления выше, чтобы создать первую запись.",
                emptyTitle = "Пока ничего не настроено",
                dispatchRadioButtons = "Кнопки радиосвязи",
                dispatchRadioFmsKeys = "FMS Назначение ключей",
            },
            features = {
                billing = {
                    description = "Включить процессы выставления счетов полицией.",
                    label = "Выставление счетов",
                },
                devices = {
                    description = "Включить развёртываемые устройства правопорядка.",
                    label = "CCTV и камеры контроля скорости",
                },
                evidence = {
                    description = "Включить хранилище улик, полевые улики и работу со сканером.",
                    label = "Улики",
                },
                impound = {
                    description = "Включить процессы работы штрафстоянки.",
                    label = "Штрафстоянка",
                },
                jail = {
                    description = "Включить назначение тюремного заключения и активности заключённых.",
                    label = "Тюрьма",
                },
                propPlacement = {
                    description = "Включить настраиваемые полицейские объекты и комплекты объектов транспорта.",
                    label = "Размещение объектов",
                },
                radial = {
                    description = "Включить полицейские круговые действия, такие как эвакуация и блокировка колеса.",
                    label = "Круговые действия",
                },
                restraints = {
                    description = "Включить наручники, стяжки, фиксаторы для ног и мешки на голову.",
                    label = "Средства сдерживания",
                },
                socialWork = {
                    description = "Включить назначение и выполнение заданий общественных работ.",
                    label = "Общественные работы",
                },
                tablet = {
                    description = "Включить приложения полицейского планшета, настроенные этим ресурсом.",
                    label = "Полицейский планшет",
                },
                tracking = {
                    description = "Включить GPS-трекеры и электронные браслеты.",
                    label = "Отслеживание",
                },
                vehicleRadar = {
                    description = "Включить радар патрульного транспорта.",
                    label = "Радар транспорта",
                },
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Для отображения этой работы в приложении экстренных вызовов должна быть включена диспетчерская система. Включите её или отключите отображение в приложении экстренных вызовов в настройках диспетчерской.",
                dispatchJobNotCovered = "Ни один активный диспетчерский центр не обслуживает работу «{job}». В sky_jobs_base/config/config.lua добавьте «{job}» в coveredJobs нужного профиля Config.Dispatch.centers, затем перезапустите sky_jobs_base. Сброс настроек не меняет эту привязку.",
                invalidDispatchChannels = "ID радиоканалов должны быть уникальными, и каждому каналу нужна корректная метка.",
                invalidDispatchDefaultChannel = "Радиоканал по умолчанию не существует. В настройках диспетчерской выберите существующий канал или «Нет».",
                invalidDispatchKeywords = "Планы реагирования должны иметь уникальные коды и корректные требования ТИП:КОЛИЧЕСТВО.",
                invalidDispatchPois = "ID, названия и координаты точек интереса должны быть корректными и уникальными.",
                invalidDispatchRadioButtons = "Проверьте функциональные кнопки рации: используйте каждую поддерживаемую кнопку только один раз и выберите действие из её списка.",
                invalidDispatchRadioFmsKeys = "Проверьте клавиши FMS рации: используйте каждую клавишу (0-9, * или #) только один раз и назначьте существующий код статуса либо оставьте её без назначения.",
                invalidDispatchReadyStatus = "В настройках диспетчерской выберите код готовности, отмеченный как доступный в списке кодов статуса.",
                invalidDispatchReporters = "Данные известных заявителей превышают допустимое число записей или длину полей.",
                invalidDispatchRespondingStatus = "В настройках диспетчерской выберите код выезда на вызов, отмеченный как недоступный в списке кодов статуса.",
                invalidDispatchSettings = "Выберите существующий доступный статус готовности, недоступный статус выезда и допустимый канал по умолчанию.",
                invalidDispatchStatusCodes = "Коды FMS должны быть уникальными, и хотя бы один статус должен быть доступным.",
                invalidDispatchVehicleTypes = "Коды типов экипажей реагирования должны быть уникальными и заполненными.",
                invalidDispatchVehicles = "ID и позывные экипажей должны быть уникальными, а ссылки на типы и станции — существовать.",
            },
            settingFields = {
                gangMinimumGrade = "Минимальный ранг",
                gang = "Банда",
                component = "Компонент",
                description = "Описание",
                fineAmount = "Сумма штрафа",
                itemName = "Название предмета",
                length = "Длина",
                max = "Макс.",
                maxOverKmh = "Макс. превышение",
                min = "Мин.",
                minOverKmh = "Мин. превышение",
                model = "Модель объекта",
                propModel = "Модель объекта",
                reason = "Причина",
                vehicleClass = "Класс",
            },
            settingGroups = {
                access = {
                    label = "Доступ",
                },
                animation = {
                    label = "Анимация",
                },
                ankleMonitor = {
                    label = "Электронный браслет",
                },
                ankleMonitorAccess = {
                    label = "Доступ к электронному браслету",
                },
                ankleMonitorPlacement = {
                    label = "Установка электронного браслета",
                },
                ankleMonitorZone = {
                    label = "Зона электронного браслета",
                },
                ankleMonitorZoneVisual = {
                    label = "Визуальные эффекты зоны браслета",
                },
                assignment = {
                    label = "Назначение",
                },
                blip = {
                    label = "Метка участка",
                },
                carry = {
                    label = "Перенос",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Прочность CCTV",
                },
                cctvPlacement = {
                    label = "Размещение CCTV",
                },
                cctvRepair = {
                    label = "Ремонт CCTV",
                },
                cctvRepairAnimation = {
                    label = "Анимация ремонта CCTV",
                },
                clamp = {
                    label = "Блокиратор колеса",
                },
                clampWeld = {
                    label = "Сварка блокиратора",
                },
                cleanup = {
                    label = "Очистка",
                },
                collection = {
                    label = "Сбор",
                },
                controls = {
                    label = "Управление",
                },
                creator = {
                    label = "Редактор",
                },
                crimeSceneTape = {
                    label = "Лента места преступления",
                },
                crimeSceneTapeAccess = {
                    label = "Доступ к ленте",
                },
                crimeSceneTapeInventory = {
                    label = "Инвентарь ленты",
                },
                crimeSceneTapeLength = {
                    label = "Длина ленты",
                },
                crimeSceneTapePlacement = {
                    label = "Установка ленты",
                },
                database = {
                    label = "База данных",
                },
                delivery = {
                    label = "Доставка",
                },
                detection = {
                    label = "Обнаружение",
                },
                dispatch = {
                    label = "Диспетчеризация",
                },
                escape = {
                    label = "Освобождение",
                },
                escort = {
                    label = "Сопровождение",
                },
                evidenceStorage = {
                    label = "Хранилище улик",
                },
                fastLock = {
                    label = "Автобыстрый захват",
                },
                general = {
                    label = "Общее",
                },
                gpsTracker = {
                    label = "GPS-трекер",
                },
                gpsTrackerAccess = {
                    label = "Доступ к GPS-трекеру",
                },
                gpsTrackerPlacement = {
                    label = "Размещение GPS-трекера",
                },
                gpsTrackerTiming = {
                    label = "Тайминги GPS-трекера",
                },
                handcuffs = {
                    label = "Наручники",
                },
                handsUp = {
                    label = "Руки вверх",
                },
                header = {
                    label = "Заголовок",
                },
                impound = {
                    label = "Штрафстоянка",
                },
                imprisonment = {
                    label = "Заключение",
                },
                jailCanteenGeneral = {
                    label = "Тюремная столовая",
                },
                jailCanteenPackage = {
                    label = "Продуктовый набор столовой",
                },
                jailCarry = {
                    label = "Работа по переноске",
                },
                jailCarryInspection = {
                    label = "Осмотр при переноске",
                },
                jailCleaning = {
                    label = "Уборочные работы",
                },
                jailCleaningIllegalFinds = {
                    label = "Находки контрабанды",
                },
                jailCleaningOutline = {
                    label = "Контур уборки",
                },
                jailDoctor = {
                    label = "Тюремный врач",
                },
                jailElectricalCodes = {
                    label = "Коды электрощитка",
                },
                jailElectricalGeneral = {
                    label = "Электрощиток тюрьмы",
                },
                jailElectricalPenalties = {
                    label = "Штрафы электрощитка",
                },
                jailElectricalRewards = {
                    label = "Награды электрощитка",
                },
                jailInmatesAlcoholic = {
                    label = "Заключённый: Алкоголик",
                },
                jailInmatesCodeList = {
                    label = "Заключённый: Информатор",
                },
                jailInmatesDrugDealer = {
                    label = "Заключённый: Наркодилер",
                },
                jailInmatesWireCutter = {
                    label = "Заключённый: Поставщик инструментов",
                },
                jailJobs = {
                    label = "Тюремные работы",
                },
                jailOutfitFemale = {
                    label = "Женская одежда",
                },
                jailOutfitMale = {
                    label = "Мужская одежда",
                },
                keybinds = {
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                    label = "Клавиши",
                },
                keybindsHandcuff = {
                    label = "Клавиша наручников",
                },
                keybindsUnhandcuff = {
                    label = "Клавиша снятия наручников",
                },
                marker = {
                    label = "Маркер",
                },
                markerColor = {
                    label = "Цвет маркера",
                },
                mugshotAnimation = {
                    label = "Анимация фото задержания",
                },
                mugshotBoard = {
                    label = "Табличка фото задержания",
                },
                mugshotCameraCoords = {
                    label = "Позиция камеры фото задержания",
                },
                mugshotCameraRotation = {
                    label = "Поворот камеры фото задержания",
                },
                mugshotGeneral = {
                    label = "Фото задержания",
                },
                mugshotMetadata = {
                    label = "Метаданные фото задержания",
                },
                mugshotPosition = {
                    label = "Позиция фото задержания",
                },
                mugshotTiming = {
                    label = "Тайминги фото задержания",
                },
                officerDown = {
                    label = "Офицер ранен",
                },
                outfit = {
                    label = "Одежда",
                },
                overlay = {
                    label = "Наложение номерного знака",
                },
                payment = {
                    label = "Оплата",
                },
                paymentFlow = {
                    label = "Процесс оплаты",
                },
                penalties = {
                    label = "Штрафы",
                },
                playerSearch = {
                    label = "Обыск игрока",
                },
                playerSearchAnimation = {
                    label = "Анимация обыска",
                },
                props = {
                    label = "Предметы-объекты",
                },
                reasons = {
                    label = "Причины",
                },
                release = {
                    label = "Выдача",
                },
                restore = {
                    label = "Восстановление",
                },
                rules = {
                    label = "Правила",
                },
                scan = {
                    label = "Сканирование",
                },
                scanner = {
                    label = "Сканер",
                },
                sentence = {
                    label = "Срок",
                },
                shotsFired = {
                    label = "Стрельба",
                },
                sound = {
                    label = "Звук",
                },
                speedcam = {
                    label = "Камеры контроля скорости",
                },
                speedcamBilling = {
                    label = "Счета камеры контроля скорости",
                },
                speedcamDispatch = {
                    label = "Диспетчеризация камеры контроля скорости",
                },
                speedcamDurability = {
                    label = "Прочность камеры контроля скорости",
                },
                speedcamPlacement = {
                    label = "Размещение камеры контроля скорости",
                },
                speedcamRepair = {
                    label = "Ремонт камеры контроля скорости",
                },
                speedcamRepairAnimation = {
                    label = "Анимация ремонта камеры контроля скорости",
                },
                speedcamTiming = {
                    label = "Тайминги камеры контроля скорости",
                },
                speedcamVisual = {
                    label = "Визуальные эффекты камеры контроля скорости",
                },
                speedcams = {
                    label = "Камеры контроля скорости",
                },
                storage = {
                    label = "Хранилище",
                },
                subscription = {
                    label = "Подписка на приложение",
                },
                tasks = {
                    label = "Задания",
                },
                theme = {
                    label = "Тема",
                },
                timing = {
                    label = "Тайминги",
                },
                warningUi = {
                    label = "Интерфейс предупреждения",
                },
                world = {
                    label = "Мир",
                },
                zipties = {
                    label = "Стяжки",
                },
                ziptiesCutter = {
                    label = "Резак стяжек",
                },
                cctvMotionDetection = {
                    label = "Обнаружение движения",
                },
                cctvMotionDispatch = {
                    label = "Диспетчер обнаружения движения",
                },
                cctvMotionTiming = {
                    label = "Время обнаружения движения",
                },
                display = {
                    label = "Дисплей",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Отчёты",
                },
                speedcamAdvanced = {
                    label = "Камера повышенной скорости",
                },
                tackle = {
                    label = "Сбить с ног",
                },
                vin = {
                    label = "Проверка VIN",
                },
            },
            settingSections = {
                radarGun = "Радар-пистолет",
                billing = "Счета",
                cctv = "CCTV",
                dispatch = "Диспетчеризация",
                equipment = "Снаряжение",
                evidence = "Улики",
                impound = "Штрафстоянка",
                jail = "Тюрьма",
                radar = "Радар транспорта",
                radial = "Круговые действия",
                restraints = "Средства сдерживания",
                socialWork = "Общественные работы",
                speedCamera = "Камера контроля скорости",
                spikeStrips = "Шипованные ленты",
                stations = "Участки",
                tablet = "Приложения планшета",
                tracking = "Отслеживание",
                fakePlates = "Поддельные таблички",
                general = "Общее",
            },
            settingSubsections = {
                app = "Приложение камеры контроля скорости",
                apps = "Приложения",
                billing = "Счета",
                canteen = "Тюремная столовая",
                dispatch = "Диспетчеризация",
                durability = "Прочность",
                electrical = "Электрощиток тюрьмы",
                general = "Общее",
                handcuffs = "Наручники и стяжки",
                inmates = "Заключённые",
                jobs = "Тюремные работы",
                keybinds = "Клавиши",
                motionDetection = "Обнаружение движения",
                mugshot = "Фото задержания",
                placement = "Размещение",
                repair = "Ремонт",
                timing = "Тайминги",
                visuals = "Визуальные эффекты",
            },
            settings = {
                radarGunClearKey = { label = "Радар: Сбросить показания" },
                radarGunToggleUiKey = { label = "Радар: Переключить интерфейс" },
                radarGunNoTargetHoldMs = { label = "Время удержания цели (мс)" },
                radarGunMinimumReading = { label = "Минимальная отображаемая скорость" },
                radarGunSpeedSmoothing = { label = "Сглаживание скорости (0–1)" },
                radarGunBeamRadius = { label = "Радиус луча (м)" },
                radarGunRefreshRateMs = { label = "Интервал измерений (мс)" },
                radarGunUseMph = { label = "Использовать MPH", description = "Показывает измерения в милях в час вместо километров в час." },
                radarGunRange = { label = "Дальность измерения", description = "Максимальное расстояние в метрах, на котором радарный пистолет обнаруживает автомобили." },
                radarGunRequireOnDuty = { label = "Требовать дежурство", description = "Требует, чтобы сотрудник был на дежурстве перед измерением скорости автомобилей." },
                radarGunAllowedJobs = { label = "Разрешённые работы или группы", description = "police включает все настроенные полицейские работы; также можно указать прямые названия. Пустой список снимает ограничения по работе.", itemLabel = "Работа или группа" },
                radarGunEnabled = { label = "Радар-пистолет", description = "Включает ручной радар-пистолет SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Разрешённые банды",
                    description = "Выберите внутренние имена банд или независимых организаций. Совпадение профессии или банды даёт разрешение или исключение. Дежурство требуется только для профессий.",
                    itemLabel = "Банда",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Минимальные ранги банд",
                    description = "Необязательные минимальные ранги банд. Пустой список разрешает все ранги. Требования к предметам сохраняются.",
                },

                speedCamProcessingMode = {
                    description = "Выберите немедленное списание, оплату в настроенный срок или только проверку сотрудником.",
                    label = "Режим обработки",
                    options = {
                        instant = "Списать сразу",
                        later = "Оплатить позже (по умолчанию)",
                        review = "Только проверка сотрудником",
                    },
                },
                tabletRegistry = { label = "Реестр", description = "Включить пользовательские RP-реестры в File Explorer. Дела граждан и автомобилей остаются доступны отдельно." },
                tabletFiles = { label = "Проводник", description = "Объединяет полицейские записи в проводнике. Документы DOJ доступны только при работающем DOJ." },
                ankleMonitorAnimDurationMs = {
                    description = "Миллисекунды, затрачиваемые на установку электронного браслета.",
                    label = "Длительность применения",
                },
                ankleMonitorAnimScenario = {
                    description = "Сценарий, воспроизводимый при установке электронного браслета.",
                    label = "Сценарий применения",
                },
                ankleMonitorAttachBone = {
                    description = "Кость модели персонажа, используемая для крепления объекта электронного браслета.",
                    label = "Кость крепления",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Удалять предмет электронного браслета после установки.",
                    label = "Расходовать браслет",
                },
                ankleMonitorCutItem = {
                    description = "Предмет инвентаря, используемый для снятия электронных браслетов.",
                    label = "Предмет для срезания",
                },
                ankleMonitorEnabled = {
                    description = "Включить установку электронных браслетов.",
                    label = "Электронный браслет",
                },
                ankleMonitorItem = {
                    description = "Предмет инвентаря, используемый для установки электронных браслетов.",
                    label = "Предмет электронного браслета",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Миллисекунды между обновлениями электронного браслета на карте.",
                    label = "Интервал обновления карты",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Сохраняет электронные браслеты в базе данных при отключении отслеживаемых игроков, чтобы восстановить их после повторного подключения или перезапуска сервера.",
                    label = "Сохранять после отключения",
                },
                ankleMonitorPlaceDistance = {
                    description = "Максимальное расстояние для установки электронного браслета.",
                    label = "Дистанция установки",
                },
                ankleMonitorPropModel = {
                    description = "Модель объекта, используемая для визуального отображения электронного браслета.",
                    label = "Модель объекта",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Требовать статус смены перед использованием электронных браслетов.",
                    label = "Браслет требует смены",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Требовать, чтобы игрок состоял в полицейской группе, для использования электронных браслетов.",
                    label = "Браслет требует полицейскую работу",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Возвращать предмет электронного браслета при его снятии.",
                    label = "Возврат браслета при снятии",
                },
                ankleMonitorWarningSeconds = {
                    description = "Время предупреждения перед отправкой диспетчеру нарушения зоны электронного браслета.",
                    label = "Секунды предупреждения зоны",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Миллисекунды между предупреждающими сигналами зоны электронного браслета.",
                    label = "Интервал сигнала зоны",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Название звука, используемого для предупреждений зоны электронного браслета.",
                    label = "Звук сигнала",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Набор звуков, используемый для предупреждений зоны электронного браслета.",
                    label = "Набор звуков сигнала",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Значение прозрачности, используемое для меток зоны электронного браслета.",
                    label = "Прозрачность метки",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Цвет метки, используемый, когда цель находится внутри разрешённой зоны.",
                    label = "Цвет метки разрешённой зоны",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Цвет метки, используемый, когда цель покидает разрешённую зону.",
                    label = "Цвет метки запрещённой зоны",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Миллисекунды между проверками зоны электронного браслета.",
                    label = "Интервал проверки зоны",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Секунды перед тем, как можно отправить ещё одно уведомление диспетчеру о зоне.",
                    label = "Перезарядка диспетчеризации зоны",
                },
                ankleMonitorZoneEnabled = {
                    description = "Включить проверки зоны электронного браслета.",
                    label = "Зоны электронного браслета",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Спрайт метки, используемый для маркеров зоны электронного браслета.",
                    label = "Спрайт метки зоны",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Радиус, используемый для контуров зоны электронного браслета.",
                    label = "Радиус контура",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Размер шага, используемый для контуров зоны электронного браслета.",
                    label = "Шаг контура",
                },
                billingAccount = {
                    description = "Резервный счёт, используемый, если у работы не настроен счёт организации.",
                    label = "Резервный счёт организации",
                },
                billingCloseOnSuccess = {
                    description = "Закрывать интерфейс выставления счетов после успешного выставления счёта.",
                    label = "Закрыть после успеха",
                },
                billingCurrency = {
                    description = "Ключ валюты, используемый для выставления счетов. Оставьте пустым для использования валюты по умолчанию.",
                    label = "Валюта",
                },
                billingCustomReasons = {
                    description = "Разрешить произвольные причины выставления счёта вместо только предустановленных.",
                    label = "Произвольные причины",
                },
                billingDepositToSociety = {
                    description = "Зачислять доход от счетов на счёт организации работы.",
                    label = "Зачислять в организацию",
                },
                billingMaxReasonLength = {
                    description = "Максимальное количество символов для произвольных причин счёта.",
                    label = "Длина причины",
                },
                billingMode = {
                    description = "Выберите, будут ли полицейские счета списываться мгновенно, требовать подтверждения гражданина или использовать систему счетов фреймворка.",
                    label = "Режим выставления счетов",
                    options = {
                        consent = "Оплатить или отклонить",
                        framework = "Счёт фреймворка",
                        instant = "Мгновенное списание",
                    },
                },
                billingRange = {
                    description = "Максимальное расстояние до цели для выставления полицейских счетов.",
                    label = "Дистанция выставления счёта",
                },
                billingReasonPresets = {
                    description = "Предустановленные причины счетов, отображаемые в интерфейсе выставления счетов.",
                    itemLabel = "Причина",
                    label = "Предустановленные причины",
                },
                billingRefreshSeconds = {
                    description = "Интервал обновления цели, пока открыт интерфейс выставления счетов.",
                    label = "Секунды обновления",
                },
                billingShowRecipientName = {
                    description = "Показывать имя гражданина в предварительном просмотре штрафа и на квитанции.",
                    label = "Показывать имя получателя",
                },
                carryAllowCarrierInVehicle = {
                    description = "Разрешает носителю войти в транспорт и управлять им, не опуская игрока.",
                    label = "Разрешить носителю транспорт",
                },
                carryAllowConscious = {
                    description = "Разрешить переноску целей, находящихся в сознании.",
                    label = "Переносить в сознании",
                },
                carryAllowSprint = {
                    description = "Разрешить бег во время переноски другого игрока.",
                    label = "Разрешить бег при переносе",
                },
                carryEnabled = {
                    description = "Включить перенос игроков.",
                    label = "Перенос",
                },
                carryMaxDistance = {
                    description = "Максимальное расстояние для начала переноса игрока.",
                    label = "Дистанция переноса",
                },
                carryRequireOnDuty = {
                    description = "Требовать статус смены перед началом переноса.",
                    label = "Перенос требует смены",
                },
                cctvDamageCooldownMs = {
                    description = "Миллисекунды перед тем, как урон CCTV может быть применён снова.",
                    label = "Перезарядка урона",
                },
                cctvDamagePerHit = {
                    description = "Урон прочности, наносимый камере CCTV за один удар.",
                    label = "Урон за удар",
                },
                cctvDefaultName = {
                    description = "Отображаемое имя по умолчанию для установленных камер CCTV.",
                    label = "Название CCTV по умолчанию",
                },
                cctvDefaultPitch = {
                    description = "Наклон камеры по умолчанию для установки CCTV.",
                    label = "Наклон по умолчанию",
                },
                cctvDisassembleDistance = {
                    description = "Расстояние, используемое для разборки камер CCTV.",
                    label = "Дистанция разборки",
                },
                cctvEnabled = {
                    description = "Включить размещение и трансляцию камер CCTV.",
                    label = "Камеры CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Расстояние, на котором отображается прочность CCTV.",
                    label = "Дистанция отображения прочности",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Миллисекунды, в течение которых прочность CCTV остаётся видимой.",
                    label = "Длительность отображения прочности",
                },
                cctvHealthTextOffset = {
                    description = "Вертикальное смещение, используемое для текста прочности CCTV.",
                    label = "Смещение текста прочности",
                },
                cctvHeightStep = {
                    description = "Шаг изменения высоты, используемый при позиционировании камер CCTV.",
                    label = "Шаг высоты",
                },
                cctvItem = {
                    description = "Предмет инвентаря, используемый для размещения камер CCTV.",
                    label = "Предмет CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Порог прочности, при котором рекомендуется обслуживание CCTV.",
                    label = "Порог обслуживания",
                },
                cctvMaxDurability = {
                    description = "Максимальная прочность камеры CCTV.",
                    label = "Прочность CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Количество секунд до следующего диспетчерского оповещения от камеры.",
                    label = "Задержка диспетчера",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Количество миллисекунд между клиентскими проверками движения.",
                    label = "Интервал сканирования",
                },
                cctvMotionClientCooldownMs = {
                    description = "Количество миллисекунд до повторного отчёта клиента об одной камере.",
                    label = "Задержка отчёта клиента",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Автоматически включать оповещения о движении для новых камер CCTV.",
                    label = "Новые камеры включены по умолчанию",
                },
                cctvMotionDetectionEnabled = {
                    description = "Включить диспетчерские оповещения о движении для каждой камеры CCTV.",
                    label = "Оповещения о движении",
                },
                cctvMotionDetectionRadius = {
                    description = "Максимальная дистанция обнаружения движения в метрах.",
                    label = "Радиус обнаружения",
                },
                cctvMotionFieldOfView = {
                    description = "Угол конуса обнаружения движения в градусах.",
                    label = "Поле зрения",
                },
                cctvMotionJobs = {
                    description = "Названия работ или групп, получающих оповещения CCTV о движении.",
                    itemLabel = "Работа или группа",
                    label = "Работы диспетчера",
                },
                cctvMotionMinimumSpeed = {
                    description = "Минимальная скорость объекта в метрах в секунду, считающаяся движением.",
                    label = "Минимальная скорость движения",
                },
                cctvMoveStep = {
                    description = "Шаг перемещения, используемый при позиционировании камер CCTV.",
                    label = "Шаг перемещения",
                },
                cctvPropModel = {
                    description = "Модель объекта, используемая для установленных камер CCTV.",
                    label = "Модель объекта CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Словарь анимации, используемый при ремонте камер CCTV.",
                    label = "Словарь анимации ремонта",
                },
                cctvRepairAnimFlag = {
                    description = "Флаг анимации, используемый при ремонте камер CCTV.",
                    label = "Флаг анимации ремонта",
                },
                cctvRepairAnimName = {
                    description = "Название анимации, используемое при ремонте камер CCTV.",
                    label = "Название анимации ремонта",
                },
                cctvRepairCancelDelayMs = {
                    description = "Миллисекунды перед тем, как ремонт CCTV можно отменить.",
                    label = "Задержка отмены ремонта",
                },
                cctvRepairDistance = {
                    description = "Расстояние, используемое для ремонта камер CCTV.",
                    label = "Дистанция ремонта",
                },
                cctvRepairItem = {
                    description = "Предмет инвентаря, используемый для ремонта камер CCTV.",
                    label = "Предмет ремонта",
                },
                cctvRepairPerTick = {
                    description = "Прочность, восстанавливаемая за каждый тик ремонта CCTV.",
                    label = "Ремонт за тик",
                },
                cctvRepairTickMs = {
                    description = "Миллисекунды между тиками ремонта CCTV.",
                    label = "Тик ремонта",
                },
                cctvRotateStep = {
                    description = "Шаг поворота, используемый при позиционировании камер CCTV.",
                    label = "Шаг поворота",
                },
                cctvStreamDistance = {
                    description = "Расстояние, используемое для загрузки камер CCTV.",
                    label = "Дистанция загрузки",
                },
                cctvViewOffset = {
                    description = "Смещение обзора, используемое для отображения прямой трансляции CCTV.",
                    label = "Смещение обзора",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Создаёт вдоль ленты блокирующий коллизионный барьер, чтобы игроки не могли пройти сквозь неё.",
                    label = "Блокирующая коллизия ленты",
                },
                crimeSceneTapeConsumeItem = {
                    description = "После успешной установки удалить один предмет ленты из инвентаря.",
                    label = "Расходовать предмет ленты",
                },
                crimeSceneTapeDynamic = {
                    description = "Позволить ленте реагировать на физику и гравитацию вместо фиксации на месте.",
                    label = "Динамическая физика",
                },
                crimeSceneTapeEnabled = {
                    description = "Разрешить установку ленты места преступления с помощью предмета из инвентаря.",
                    label = "Лента места преступления",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Снимать ленту могут только разрешённые профессии и, если это требуется, только сотрудники на дежурстве.",
                    label = "Ограничить снятие",
                },
                crimeSceneTapeItem = {
                    description = "Название предмета в инвентаре, который запускает установку ленты места преступления.",
                    label = "Предмет ленты",
                },
                crimeSceneTapeJobs = {
                    description = "Названия профессий, которым разрешено использовать ленту места преступления.",
                    itemLabel = "Профессия",
                    label = "Разрешённые профессии",
                },
                crimeSceneTapeLabel = {
                    description = "Отображаемое название ленты места преступления во время установки.",
                    label = "Подпись ленты",
                },
                crimeSceneTapeLengthStep = {
                    description = "Шаг в метрах, до которого округляется выбранная длина ленты.",
                    label = "Шаг длины",
                },
                crimeSceneTapeMaxLength = {
                    description = "Максимально допустимое расстояние между двумя стойками ленты в метрах.",
                    label = "Максимальная длина ленты",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Максимальное расстояние от любой конечной точки до сотрудника, устанавливающего ленту.",
                    label = "Максимальная дистанция установки",
                },
                crimeSceneTapeMinLength = {
                    description = "Минимально допустимое расстояние между двумя стойками ленты в метрах.",
                    label = "Минимальная длина ленты",
                },
                crimeSceneTapeModel = {
                    description = "Название модели объекта для установленной ленты места преступления.",
                    label = "Модель ленты",
                },
                crimeSceneTapePostModel = {
                    description = "Модель объекта, используемая для обеих стоек ленты.",
                    label = "Модель стойки",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Максимальное расстояние, с которого можно снять установленную ленту места преступления.",
                    label = "Дистанция снятия",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Устанавливать ленту могут только находящиеся на дежурстве сотрудники разрешённых профессий.",
                    label = "Требовать дежурство",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Возвращать израсходованный предмет при снятии установленной ленты.",
                    label = "Возвращать предмет при снятии",
                },
                crimeSceneTapeSag = {
                    description = "Максимальное провисание ленты вниз между стойками в метрах.",
                    label = "Провисание ленты",
                },
                crimeSceneTapeSections = {
                    description = "Нативные модели секций ленты, из которых собирается выбранная длина.",
                    itemLabel = "Секция ленты",
                    label = "Секции ленты",
                },
                crimeSceneTapeShowPosts = {
                    description = "Создаёт видимые опорные стойки на обоих концах ленты места преступления изменяемой длины.",
                    label = "Показывать стойки ленты",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Расстояние, в пределах которого загружается установленная лента места преступления.",
                    label = "Дистанция загрузки",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Высота ленты над выбранными точками поверхности.",
                    label = "Высота ленты",
                },
                crimeSceneTapeVariableLength = {
                    description = "Позволяет сотрудникам задать начальную и конечную точки и установить ленту регулируемой длины.",
                    label = "Изменяемая длина ленты",
                },
                crimeSceneTapeZOffset = {
                    description = "Вертикальное смещение при установке модели ленты.",
                    label = "Смещение по высоте",
                },
                cuffsAnimDict = {
                    description = "Словарь анимации, используемый для связанных игроков.",
                    label = "Словарь анимации",
                },
                cuffsAnimFlag = {
                    description = "Флаг анимации, используемый для связанных игроков.",
                    label = "Флаг анимации",
                },
                cuffsAnimName = {
                    description = "Название анимации, используемое для связанных игроков.",
                    label = "Название анимации",
                },
                cuffsConsumeItem = {
                    description = "Удалять предмет наручников при надевании.",
                    label = "Расходовать наручники",
                },
                cuffsEnabled = {
                    description = "Включить действия с наручниками.",
                    label = "Наручники",
                },
                cuffsEscapeEnabled = {
                    description = "Включить мини-игру освобождения от наручников.",
                    label = "Освобождение от наручников",
                },
                cuffsEscapeKeyPool = {
                    description = "Клавиши, которые могут появляться в мини-игре освобождения от наручников.",
                    itemLabel = "Клавиша",
                    label = "Пул клавиш освобождения",
                },
                cuffsEscapeRounds = {
                    description = "Количество раундов, необходимых в мини-игре освобождения от наручников.",
                    label = "Раунды освобождения",
                },
                cuffsEscapeWindowMs = {
                    description = "Миллисекунды, допустимые на каждое окно ввода при освобождении от наручников.",
                    label = "Окно освобождения",
                },
                cuffsHandsUpEnabled = {
                    description = "Включить состояние поднятых рук, используемое наручниками и стяжками.",
                    label = "Руки вверх",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Количество секунд удержания клавиши поднятия рук перед активацией.",
                    label = "Секунды удержания рук вверх",
                },
                cuffsHandsUpKey = {
                    description = "Клавиша клавиатуры, используемая для поднятия рук.",
                    label = "Клавиша поднятия рук",
                },
                cuffsItem = {
                    description = "Предмет инвентаря, используемый для действий с наручниками.",
                    label = "Предмет наручников",
                },
                cuffsMaxDistance = {
                    description = "Максимальное расстояние до цели для действий с наручниками.",
                    label = "Дистанция наручников",
                },
                cuffsRequireItem = {
                    description = "Требовать настроенный предмет наручников.",
                    label = "Наручники требуют предмет",
                },
                cuffsRequireOnDuty = {
                    description = "Требовать статус смены перед надеванием наручников.",
                    label = "Наручники требуют смены",
                },
                cuffsReturnOnRemove = {
                    description = "Возвращать предмет наручников при снятии.",
                    label = "Возврат наручников",
                },
                dispatchOfficerDownEnabled = {
                    description = "Отправлять оповещение диспетчеру, когда офицер на смене ранен.",
                    label = "Оповещения об офицере ранен",
                },
                dispatchOfficerDownJobs = {
                    description = "Работы, которые должны получать диспетчеризацию об офицере ранен.",
                    itemLabel = "Работа",
                    label = "Работы для оповещений об офицере",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Уведомлять только игроков, находящихся в данный момент на смене.",
                    label = "Оповещение об офицере требует смены",
                },
                dispatchShotsFiredChance = {
                    description = "Вероятность от 0.0 до 1.0 того, что обнаруженный выстрел создаст оповещение.",
                    label = "Вероятность оповещения",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Секунды перед тем, как тот же игрок может вызвать ещё одно оповещение о стрельбе.",
                    label = "Перезарядка оповещения о стрельбе",
                },
                dispatchShotsFiredEnabled = {
                    description = "Включить диспетчерские оповещения о стрельбе.",
                    label = "Оповещения о стрельбе",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Оружие, которое не должно вызывать оповещения о стрельбе.",
                    itemLabel = "Оружие",
                    label = "Игнорируемое оружие",
                },
                dispatchShotsFiredJobs = {
                    description = "Работы, которые должны получать диспетчеризацию о стрельбе.",
                    itemLabel = "Работа",
                    label = "Работы для оповещений о стрельбе",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Уведомлять только игроков, находящихся в данный момент на смене.",
                    label = "Оповещение о стрельбе требует смены",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Создавать записи диспетчеризации при обнаружении стрельбы.",
                    label = "Отправлять диспетчеризацию о стрельбе",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Вероятность от 0.0 до 1.0 того, что обнаруженный выстрел с глушителем создаст оповещение.",
                    label = "Вероятность оповещения о выстреле с глушителем",
                },
                escortEnabled = {
                    description = "Включить сопровождение игроков.",
                    label = "Сопровождение",
                },
                escortMaxDistance = {
                    description = "Максимальное расстояние для начала сопровождения игрока.",
                    label = "Дистанция сопровождения",
                },
                escortRequireOnDuty = {
                    description = "Требовать статус смены перед сопровождением игроков.",
                    label = "Сопровождение требует смены",
                },
                escortVehicleDistance = {
                    description = "Максимальное расстояние для посадки сопровождаемого игрока в транспорт.",
                    label = "Дистанция посадки в транспорт",
                },
                evidenceBloodDamageThreshold = {
                    description = "Минимальный порог урона перед созданием улики в виде следов крови.",
                    label = "Порог урона для крови",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Миллисекунды перед тем, как может быть создана ещё одна гильза.",
                    label = "Перезарядка создания гильзы",
                },
                evidenceCasingMergeRadius = {
                    description = "Радиус, используемый для объединения близлежащих гильз.",
                    label = "Радиус объединения гильз",
                },
                evidenceCleanupIntervalMs = {
                    description = "Миллисекунды между проходами очистки улик.",
                    label = "Интервал очистки",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Секунды до автоматического исчезновения полевых улик.",
                    label = "Время жизни для очистки",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Очиститель для всех",
                    description = "Разрешить всем удалять следы перекисью водорода. Отключите для использования списков профессий и банд.",
                },
                evidenceCleanerJobs = {
                    label = "Профессии для очистителя",
                    description = "Разрешённые внутренние имена без общего доступа. Совпадение профессии или банды разрешает доступ; пустые списки запрещают его.",
                    itemLabel = "Профессия",
                },
                evidenceCleanerGangs = {
                    label = "Банды для очистителя",
                    description = "Разрешённые внутренние имена без общего доступа. Совпадение профессии или банды разрешает доступ; пустые списки запрещают его.",
                    itemLabel = "Банда",
                },
                evidenceCollectDistance = {
                    description = "Расстояние, используемое для сбора полевых улик.",
                    label = "Дистанция сбора",
                },
                evidenceDiscoverDistance = {
                    description = "Расстояние, используемое для обнаружения ближайших маркеров улик.",
                    label = "Дистанция обнаружения",
                },
                evidenceFieldEnabled = {
                    description = "Включить создание и сбор улик на месте.",
                    label = "Полевые улики",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Оружие, используемое для осмотра и выявления улик на месте.",
                    label = "Оружие фонарика",
                },
                evidenceGloveFreeHands = {
                    description = "ID компонентов рук, которые считаются не носящими перчатки.",
                    label = "Компоненты рук без перчаток",
                },
                evidenceMarkerColor = {
                    description = "Цвет RGBA, используемый для маркеров полевых улик.",
                    label = "Цвет маркера",
                },
                evidenceMarkerDrawDistance = {
                    description = "Дистанция отрисовки, используемая для маркеров полевых улик.",
                    label = "Дистанция отрисовки",
                },
                evidenceMarkerOffset = {
                    description = "Вертикальное смещение маркера, используемое для полевых улик.",
                    label = "Смещение",
                },
                evidenceMarkerScaleX = {
                    description = "Масштаб маркера по оси X для полевых улик.",
                    label = "Масштаб X",
                },
                evidenceMarkerScaleY = {
                    description = "Масштаб маркера по оси Y для полевых улик.",
                    label = "Масштаб Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Масштаб маркера по оси Z для полевых улик.",
                    label = "Масштаб Z",
                },
                evidenceMarkerType = {
                    description = "Тип маркера, используемый для полевых улик.",
                    label = "Тип маркера",
                },
                evidenceMaxCreateDistance = {
                    description = "Максимальное расстояние для создания записей улик.",
                    label = "Дистанция создания",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Миллисекунды, допустимые для согласия на взятие образца слюны.",
                    label = "Тайм-аут согласия на слюну",
                },
                evidenceScannerDistance = {
                    description = "Расстояние, используемое для взаимодействия со сканером улик.",
                    label = "Дистанция сканера",
                },
                evidenceScannerDurationMs = {
                    description = "Длительность действия дактилоскопа/сканера в миллисекундах.",
                    label = "Длительность сканера",
                },
                evidenceStorageMaxCompartments = {
                    description = "Максимальное количество отсеков хранилища улик.",
                    label = "Отсеки хранилища",
                },
                gpsTrackerBeepDistance = {
                    description = "Расстояние, на котором звуковой сигнал GPS-трекера становится актуальным.",
                    label = "Дистанция сигнала",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Миллисекунды между сигналами при удалении от трекера.",
                    label = "Интервал сигнала вдали",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Миллисекунды между сигналами при приближении к трекеру.",
                    label = "Интервал сигнала вблизи",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Удалять предмет трекера после установки.",
                    label = "Расходовать GPS-трекер",
                },
                gpsTrackerEnabled = {
                    description = "Включить установку и сканирование GPS-трекеров транспорта.",
                    label = "GPS-трекер",
                },
                gpsTrackerItem = {
                    description = "Предмет инвентаря, используемый для установки GPS-трекеров.",
                    label = "Предмет трекера",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Миллисекунды между обновлениями трекера на карте.",
                    label = "Интервал обновления карты",
                },
                gpsTrackerPlaceDistance = {
                    description = "Максимальное расстояние для установки GPS-трекера на транспорт.",
                    label = "Дистанция установки",
                },
                gpsTrackerRemoveDistance = {
                    description = "Максимальное расстояние для снятия установленного GPS-трекера.",
                    label = "Дистанция снятия",
                },
                gpsTrackerRemoveKey = {
                    description = "Код управления, используемый для снятия установленного GPS-трекера.",
                    label = "Клавиша снятия",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Требовать статус смены перед использованием GPS-трекеров.",
                    label = "GPS требует смены",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Требовать, чтобы игрок состоял в полицейской группе, для использования GPS-трекеров.",
                    label = "GPS требует полицейскую работу",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Возвращать предмет трекера при его снятии.",
                    label = "Возврат трекера при снятии",
                },
                gpsTrackerScanDistance = {
                    description = "Максимальное расстояние для сканирования трекеров.",
                    label = "Дистанция сканирования GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Миллисекунды, затрачиваемые на сканирование GPS-трекера.",
                    label = "Длительность сканирования",
                },
                gpsTrackerScannerWeapon = {
                    description = "Оружие или инструмент, используемый для поиска GPS-трекеров.",
                    label = "Оружие сканера",
                },
                impoundAccount = {
                    description = "Счёт, используемый для списания оплаты за выдачу со штрафстоянки.",
                    label = "Счёт оплаты",
                },
                impoundCreatorVehicleModel = {
                    description = "Модель транспорта, отображаемая в предпросмотре редактора штрафстоянки.",
                    label = "Модель транспорта редактора",
                },
                impoundCustomGarageEnabled = {
                    description = "Использовать пользовательский интерфейс гаража эвакуации, если он доступен.",
                    label = "Пользовательский гараж эвакуации",
                },
                impoundDefaultPrice = {
                    description = "Цена выдачи со штрафстоянки по умолчанию.",
                    label = "Цена по умолчанию",
                },
                impoundDeliveryDistance = {
                    description = "Расстояние, используемое для взаимодействий доставки на штрафстоянку.",
                    label = "Дистанция доставки",
                },
                impoundDeliveryMarker = {
                    description = "Настройка маркера, используемая для доставки на штрафстоянку.",
                    label = "Маркер доставки",
                },
                impoundEnabled = {
                    description = "Включить процессы работы штрафстоянки.",
                    label = "Штрафстоянка",
                },
                impoundMarker = {
                    description = "Настройка маркера, используемая для взаимодействий со штрафстоянкой.",
                    label = "Маркер штрафстоянки",
                },
                impoundRadialEnabled = {
                    description = "Включить круговые действия эвакуации.",
                    label = "Действие эвакуации",
                },
                impoundRadialRequireOnDuty = {
                    description = "Требовать статус смены перед использованием кругового действия эвакуации.",
                    label = "Эвакуация требует смены",
                },
                impoundRadialVehicleDistance = {
                    description = "Максимальное расстояние до целевого транспорта для круговых действий эвакуации.",
                    label = "Дистанция эвакуации транспорта",
                },
                impoundReleaseDistance = {
                    description = "Расстояние, используемое для взаимодействий выдачи со штрафстоянки.",
                    label = "Дистанция выдачи",
                },
                impoundReleaseKey = {
                    description = "Код управления, используемый для выдачи эвакуированного транспорта.",
                    label = "Клавиша выдачи",
                },
                impoundRequireDelivery = {
                    description = "Требовать доставку на настроенную штрафстоянку.",
                    label = "Требовать доставку",
                },
                impoundStorageBasePrice = {
                    description = "Базовая цена выдачи для хранящегося на штрафстоянке транспорта.",
                    label = "Базовая цена хранения",
                },
                impoundStorageDailyFee = {
                    description = "Дополнительная плата за хранение на штрафстоянке за каждый настроенный день.",
                    label = "Дневная плата за хранение",
                },
                impoundStorageDaySeconds = {
                    description = "Сколько секунд засчитывается как один расчётный день хранения.",
                    label = "Секунд в дне хранения",
                },
                impoundStorageEnabled = {
                    description = "Включить обработку платного хранения на штрафстоянке.",
                    label = "Платное хранение на штрафстоянке",
                },
                jailAssignRange = {
                    description = "Максимальное расстояние для отправки цели в тюрьму.",
                    label = "Дистанция назначения",
                },
                jailCanteenCooldownMinutes = {
                    description = "Минуты, которые заключённый должен подождать перед получением следующего продуктового набора столовой.",
                    label = "Минуты перезарядки",
                },
                jailCanteenPackage = {
                    description = "Предметы, выдаваемые продуктовым набором тюремной столовой.",
                    label = "Продуктовый набор столовой",
                },
                jailCellStreamDistance = {
                    description = "Расстояние, используемое для загрузки объектов одиночной камеры.",
                    label = "Дистанция загрузки камеры",
                },
                jailClearInventory = {
                    description = "Очищать инвентарь игрока при отправке в тюрьму.",
                    label = "Очистка инвентаря",
                },
                jailDefaultMonths = {
                    description = "Срок заключения по умолчанию при открытии интерфейса назначения.",
                    label = "Месяцев по умолчанию",
                },
                jailDispatchJobs = {
                    description = "Работы, которые должны получать уведомления диспетчера о тюрьме.",
                    itemLabel = "Работа",
                    label = "Работы для диспетчеризации",
                },
                jailDoctorHealEvent = {
                    description = "Серверное или клиентское событие, вызываемое при лечении заключённого тюремным врачом.",
                    label = "Событие лечения",
                },
                jailElectricalCodeListItem = {
                    description = "Предмет инвентаря, необходимый для раскрытия сгенерированных кодов электрощитка.",
                    label = "Предмет списка кодов",
                },
                jailElectricalCodeMax = {
                    description = "Наибольшее случайное значение кода для электрощитка.",
                    label = "Максимальный код",
                },
                jailElectricalCodeMin = {
                    description = "Наименьшее случайное значение кода для электрощитка.",
                    label = "Минимальный код",
                },
                jailElectricalCodesCount = {
                    description = "Сколько кандидатных кодов генерируется для электрощитка.",
                    label = "Количество кодов",
                },
                jailElectricalEnabled = {
                    description = "Включить мини-игру побега через электрощиток.",
                    label = "Электрощиток",
                },
                jailElectricalPinLength = {
                    description = "Количество цифр, используемое для PIN-кодов электрощитка.",
                    label = "Длина PIN-кода",
                },
                jailElectricalPropModel = {
                    description = "Модель мирового объекта, используемая для тюремного электрощитка.",
                    label = "Модель объекта",
                },
                jailElectricalShockDamage = {
                    description = "Урон, наносимый при неудачной попытке электрической последовательности.",
                    label = "Урон от удара током",
                },
                jailElectricalShockRagdollMs = {
                    description = "Миллисекунды рэгдолла после удара током.",
                    label = "Рэгдолл от удара током",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Минуты срока, вычитаемые после успешной попытки побега через электрощиток.",
                    label = "Минуты сокращения за успех",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Количество, необходимое для обмена с заключённым-алкоголиком.",
                    label = "Требуемое количество",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Предмет, необходимый для обмена с заключённым-алкоголиком.",
                    label = "Требуемый предмет",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Количество награды за обмен с заключённым-алкоголиком.",
                    label = "Количество награды",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Предмет награды за обмен с заключённым-алкоголиком.",
                    label = "Предмет награды",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Название награды, отображаемое для обмена с заключённым-алкоголиком.",
                    label = "Название награды",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Количество, необходимое для обмена с заключённым-информатором.",
                    label = "Требуемое количество",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Предмет, необходимый для обмена с заключённым-информатором.",
                    label = "Требуемый предмет",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Количество награды за обмен с заключённым-информатором.",
                    label = "Количество награды",
                },
                jailInmateCodeListRewardItem = {
                    description = "Предмет награды за обмен с заключённым-информатором.",
                    label = "Предмет награды",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Название награды, отображаемое для обмена с заключённым-информатором.",
                    label = "Название награды",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Предметы, принимаемые в обмене с заключённым-наркодилером.",
                    label = "Принимаемые предметы",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Количество, необходимое для обмена с заключённым-наркодилером.",
                    label = "Требуемое количество",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Количество награды за обмен с заключённым-наркодилером.",
                    label = "Количество награды",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Предмет награды за обмен с заключённым-наркодилером.",
                    label = "Предмет награды",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Название награды, отображаемое для обмена с заключённым-наркодилером.",
                    label = "Название награды",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Разрешить контрабанде, найденной во время тюремной уборки, засчитываться в обмене с заключённым-наркодилером.",
                    label = "Использовать контрабанду с уборки",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Количество, необходимое для обмена с заключённым-поставщиком инструментов.",
                    label = "Требуемое количество",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Предмет, необходимый для обмена с заключённым-поставщиком инструментов.",
                    label = "Требуемый предмет",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Количество награды за обмен с заключённым-поставщиком инструментов.",
                    label = "Количество награды",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Предмет награды за обмен с заключённым-поставщиком инструментов.",
                    label = "Предмет награды",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Название награды, отображаемое для обмена с заключённым-поставщиком инструментов.",
                    label = "Название награды",
                },
                jailJobsCarryBoxModel = {
                    description = "Модель объекта, используемая для коробки тюремной работы по переноске.",
                    label = "Модель коробки",
                },
                jailJobsCarryDropoffKey = {
                    description = "Код управления, используемый для сдачи коробок работы по переноске.",
                    label = "Клавиша сдачи груза",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Радиус сдачи груза для тюремной работы по переноске.",
                    label = "Радиус сдачи груза",
                },
                jailJobsCarryInspectKey = {
                    description = "Код управления, используемый для осмотра коробок работы по переноске.",
                    label = "Клавиша осмотра",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Бесполезные предметы, которые можно найти при осмотре коробок работы по переноске.",
                    label = "Бесполезные предметы осмотра",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Шанс получить полезную награду при осмотре коробок.",
                    label = "Шанс полезной находки",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Полезные предметы, которые можно найти при осмотре коробок работы по переноске.",
                    label = "Полезные предметы осмотра",
                },
                jailJobsCarryInteractDistance = {
                    description = "Дистанция взаимодействия для тюремной работы по переноске.",
                    label = "Дистанция взаимодействия переноски",
                },
                jailJobsCarryMaxDistance = {
                    description = "Максимально допустимое расстояние для прогресса тюремной работы по переноске.",
                    label = "Макс. дистанция переноски",
                },
                jailJobsCarryPickupKey = {
                    description = "Код управления, используемый для подбора коробок работы по переноске.",
                    label = "Клавиша подбора груза",
                },
                jailJobsCarryPickupOffset = {
                    description = "Объект смещения, используемый для места подбора работы по переноске.",
                    label = "Смещение подбора",
                },
                jailJobsCarryTimeReduction = {
                    description = "Сокращение срока за выполнение тюремной работы по переноске.",
                    label = "Сокращение срока за переноску",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Код управления, используемый у тюремного контейнера для мусора.",
                    label = "Клавиша контейнера",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Модель, используемая для объекта контейнера тюремной уборки.",
                    label = "Модель контейнера",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Шанс найти контрабанду во время уборки.",
                    label = "Шанс найти запрещённое",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Предметы, которые можно найти во время уборки в тюрьме.",
                    label = "Предметы находок",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Тайм-аут для запросов о находке контрабанды в миллисекундах.",
                    label = "Тайм-аут запроса находки",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Расстояние, используемое для взаимодействия с мусором при уборке.",
                    label = "Дистанция взаимодействия при уборке",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Максимальное расстояние перед сбросом или исчезновением объектов уборки.",
                    label = "Макс. дистанция уборки",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Максимальное одновременное количество объектов мусора для тюремной уборки.",
                    label = "Максимум объектов мусора",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Минимальное расстояние от центра для появления мусора для уборки.",
                    label = "Минимальный радиус появления",
                },
                jailJobsCleaningPickupKey = {
                    description = "Код управления, используемый для подбора тюремного мусора при уборке.",
                    label = "Клавиша подбора при уборке",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Миллисекунды между попытками появления мусора для уборки.",
                    label = "Интервал появления мусора",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Радиус, используемый для появления объектов мусора для уборки.",
                    label = "Радиус появления мусора",
                },
                jailJobsCleaningTrashModels = {
                    description = "Модели объектов мусора, используемые для тюремной работы по уборке.",
                    itemLabel = "Модель",
                    label = "Модели мусора",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Цвет RGBA контура, используемый для объектов мусора тюремной уборки.",
                    label = "Цвет контура",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Включить контуры на объектах мусора тюремной уборки.",
                    label = "Контур мусора",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID шейдера, используемый для контуров мусора тюремной уборки.",
                    label = "Шейдер контура",
                },
                jailJobsTimeReduction = {
                    description = "Сокращение срока за выполнение тюремной работы по уборке.",
                    label = "Сокращение срока за уборку",
                },
                jailJobsTrashGoal = {
                    description = "Количество мусора, необходимое для завершения тюремной работы по уборке.",
                    label = "Цель по мусору для уборки",
                },
                jailMaxMonths = {
                    description = "Максимальный доступный для выбора срок заключения.",
                    label = "Максимум месяцев",
                },
                jailMinMonths = {
                    description = "Минимальный доступный для выбора срок заключения.",
                    label = "Минимум месяцев",
                },
                jailMonthMinutes = {
                    description = "Количество реальных минут, представляющих один тюремный месяц.",
                    label = "Минут в месяце",
                },
                jailObjectStreamDistance = {
                    description = "Расстояние, используемое для загрузки постоянных мировых объектов тюрьмы.",
                    label = "Дистанция загрузки объектов",
                },
                jailOutfitApplyDelayMs = {
                    description = "Задержка после присоединения перед применением тюремной одежды.",
                    label = "Задержка применения одежды",
                },
                jailOutfitEnabled = {
                    description = "Включить тюремную одежду.",
                    label = "Тюремная одежда",
                },
                jailOutfitFemaleArms = {
                    description = "Компонент рук женской тюремной одежды.",
                    label = "Руки",
                },
                jailOutfitFemaleChain1 = {
                    description = "Модель цепочки женской тюремной одежды.",
                    label = "Цепочка 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Текстура цепочки женской тюремной одежды.",
                    label = "Цепочка 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Модель декалей женской тюремной одежды.",
                    label = "Декали 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Текстура декалей женской тюремной одежды.",
                    label = "Декали 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Модель очков женской тюремной одежды (-1 убирает очки).",
                    label = "Очки 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Текстура очков женской тюремной одежды.",
                    label = "Очки 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Модель шлема женской тюремной одежды.",
                    label = "Шлем 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Текстура шлема женской тюремной одежды.",
                    label = "Шлем 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Модель штанов женской тюремной одежды.",
                    label = "Штаны 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Текстура штанов женской тюремной одежды.",
                    label = "Штаны 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Модель обуви женской тюремной одежды.",
                    label = "Обувь 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Текстура обуви женской тюремной одежды.",
                    label = "Обувь 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Модель торса женской тюремной одежды.",
                    label = "Торс 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Текстура торса женской тюремной одежды.",
                    label = "Торс 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Модель футболки женской тюремной одежды.",
                    label = "Футболка 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Текстура футболки женской тюремной одежды.",
                    label = "Футболка 2",
                },
                jailOutfitMaleArms = {
                    description = "Компонент рук мужской тюремной одежды.",
                    label = "Руки",
                },
                jailOutfitMaleChain1 = {
                    description = "Модель цепочки мужской тюремной одежды.",
                    label = "Цепочка 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Текстура цепочки мужской тюремной одежды.",
                    label = "Цепочка 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Модель декалей мужской тюремной одежды.",
                    label = "Декали 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Текстура декалей мужской тюремной одежды.",
                    label = "Декали 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Модель очков мужской тюремной одежды (-1 убирает очки).",
                    label = "Очки 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Текстура очков мужской тюремной одежды.",
                    label = "Очки 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Модель шлема мужской тюремной одежды.",
                    label = "Шлем 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Текстура шлема мужской тюремной одежды.",
                    label = "Шлем 2",
                },
                jailOutfitMalePants1 = {
                    description = "Модель штанов мужской тюремной одежды.",
                    label = "Штаны 1",
                },
                jailOutfitMalePants2 = {
                    description = "Текстура штанов мужской тюремной одежды.",
                    label = "Штаны 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Модель обуви мужской тюремной одежды.",
                    label = "Обувь 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Текстура обуви мужской тюремной одежды.",
                    label = "Обувь 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Модель торса мужской тюремной одежды.",
                    label = "Торс 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Текстура торса мужской тюремной одежды.",
                    label = "Торс 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Модель футболки мужской тюремной одежды.",
                    label = "Футболка 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Текстура футболки мужской тюремной одежды.",
                    label = "Футболка 2",
                },
                jailRequireJailTerminal = {
                    description = "Разрешать офицерам отправлять в тюрьму только рядом с терминалом выбранной тюрьмы.",
                    label = "Требовать тюремный терминал",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Восстанавливать сохранённую гражданскую одежду при побеге заключённого.",
                    label = "Восстанавливать одежду при побеге",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Льготный период после восстановления, в течение которого продолжает применяться коррекция точки появления.",
                    label = "Окно коррекции восстановления",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Телепортировать восстановленных заключённых обратно к точке появления тюрьмы, если они загружаются вне зоны тюрьмы.",
                    label = "Телепортировать восстановленных заключённых",
                },
                jailTerminalRange = {
                    description = "Максимальное расстояние офицера до терминала выбранной тюрьмы.",
                    label = "Дистанция до терминала",
                },
                jailZoneExitGraceMs = {
                    description = "Льготный период перед тем, как выход из зоны тюрьмы засчитывается как побег.",
                    label = "Льготное время выхода из зоны",
                },
                mugshotAnimDict = {
                    description = "Словарь анимации, используемый во время съёмки фото задержания.",
                    label = "Словарь анимации",
                },
                mugshotAnimFlag = {
                    description = "Флаг анимации, используемый во время съёмки фото задержания.",
                    label = "Флаг анимации",
                },
                mugshotAnimName = {
                    description = "Название анимации, используемое во время съёмки фото задержания.",
                    label = "Название анимации",
                },
                mugshotBoardHeader = {
                    description = "Основной заголовок, отображаемый на табличке фото задержания.",
                    label = "Заголовок таблички",
                },
                mugshotBoardSubheader = {
                    description = "Резервный подзаголовок, отображаемый на табличке фото задержания.",
                    label = "Подзаголовок таблички",
                },
                mugshotCameraCoordsX = {
                    description = "Мировая координата X камеры, используемая для фото задержания.",
                    label = "Камера X",
                },
                mugshotCameraCoordsY = {
                    description = "Мировая координата Y камеры, используемая для фото задержания.",
                    label = "Камера Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Мировая координата Z камеры, используемая для фото задержания.",
                    label = "Камера Z",
                },
                mugshotCameraFov = {
                    description = "Угол обзора, используемый для съёмки фото задержания.",
                    label = "Угол обзора камеры",
                },
                mugshotCameraRotX = {
                    description = "Поворот камеры по оси X для фото задержания.",
                    label = "Поворот X",
                },
                mugshotCameraRotY = {
                    description = "Поворот камеры по оси Y для фото задержания.",
                    label = "Поворот Y",
                },
                mugshotCameraRotZ = {
                    description = "Поворот камеры по оси Z для фото задержания.",
                    label = "Поворот Z",
                },
                mugshotCaptureTimeout = {
                    description = "Максимальное количество миллисекунд, допустимое для колбэков съёмки фото задержания.",
                    label = "Тайм-аут съёмки",
                },
                mugshotEnabled = {
                    description = "Включить съёмку фото задержания при оформлении в тюрьму.",
                    label = "Съёмка фото задержания",
                },
                mugshotHeading = {
                    description = "Направление, применяемое во время съёмки фото задержания.",
                    label = "Направление",
                },
                mugshotLocationX = {
                    description = "Мировая координата X, используемая для съёмки фото задержания.",
                    label = "Позиция X",
                },
                mugshotLocationY = {
                    description = "Мировая координата Y, используемая для съёмки фото задержания.",
                    label = "Позиция Y",
                },
                mugshotLocationZ = {
                    description = "Мировая координата Z, используемая для съёмки фото задержания.",
                    label = "Позиция Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Формат описания, используемый для метаданных сохранённого фото задержания.",
                    label = "Описание метаданных",
                },
                mugshotMetadataName = {
                    description = "Название метаданных инвентаря, используемое для сохранённого фото задержания.",
                    label = "Название метаданных",
                },
                mugshotWaitMs = {
                    description = "Миллисекунды ожидания перед съёмкой фото задержания.",
                    label = "Ожидание в миллисекундах",
                },
                playerSearchAnimDict = {
                    description = "Словарь анимации, используемый во время обыска игрока.",
                    label = "Словарь анимации",
                },
                playerSearchAnimFlag = {
                    description = "Флаг анимации, используемый во время обыска игрока.",
                    label = "Флаг анимации",
                },
                playerSearchAnimName = {
                    description = "Название анимации, используемое во время обыска игрока.",
                    label = "Название анимации",
                },
                playerSearchDurationMs = {
                    description = "Длительность предпросмотра обыска игрока в миллисекундах.",
                    label = "Длительность обыска",
                },
                playerSearchEnabled = {
                    description = "Включить процесс предварительного просмотра обыска игрока.",
                    label = "Обыск игрока",
                },
                playerSearchRange = {
                    description = "Максимальное расстояние для начала обыска игрока.",
                    label = "Дистанция обыска",
                },
                playerSearchScenario = {
                    description = "Сценарий, используемый, если не воспроизводится явная анимация обыска.",
                    label = "Сценарий обыска",
                },
                policeBillingControl200 = {
                    label = "Счета · Управление 200",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeBillingControl322 = {
                    label = "Счета · Управление 322",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl10 = {
                    label = "Редактор · Управление 10",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl11 = {
                    label = "Редактор · Управление 11",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl172 = {
                    label = "Редактор · Управление 172",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl173 = {
                    label = "Редактор · Управление 173",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl174 = {
                    label = "Редактор · Управление 174",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl175 = {
                    label = "Редактор · Управление 175",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl177 = {
                    label = "Редактор · Управление 177",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl191 = {
                    label = "Редактор · Управление 191",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl201 = {
                    label = "Редактор · Управление 201",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl202 = {
                    label = "Редактор · Управление 202",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl21 = {
                    label = "Редактор · Управление 21",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl32 = {
                    label = "Редактор · Управление 32",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl322 = {
                    label = "Редактор · Управление 322",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl33 = {
                    label = "Редактор · Управление 33",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl34 = {
                    label = "Редактор · Управление 34",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl35 = {
                    label = "Редактор · Управление 35",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl36 = {
                    label = "Редактор · Управление 36",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl37 = {
                    label = "Редактор · Управление 37",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl38 = {
                    label = "Редактор · Управление 38",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl44 = {
                    label = "Редактор · Управление 44",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policeEditorControl73 = {
                    label = "Редактор · Управление 73",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                policePrimaryColor = {
                    description = "Цвет по умолчанию для группы полицейских работ.",
                    label = "Основной цвет",
                },
                propPlacementConsumeItem = {
                    description = "Удалять один предмет инвентаря при размещении объекта.",
                    label = "Расходовать предмет объекта",
                },
                propPlacementEnabled = {
                    description = "Разрешить размещение настроенных полицейских объектов из предметов или транспорта.",
                    label = "Размещение объектов",
                },
                propPlacementItemNames = {
                    description = "Сопоставление моделей объектов с названиями предметов инвентаря для размещения объектов на основе предметов.",
                    label = "Названия предметов объектов",
                },
                propPlacementRequireOnDuty = {
                    description = "Только сотрудники на смене могут размещать настроенные объекты.",
                    label = "Объекты требуют смены",
                },
                propPlacementReturnItem = {
                    description = "Возвращать израсходованный предмет при удалении размещённого объекта.",
                    label = "Возврат предмета объекта",
                },
                propPlacementVehicleAccess = {
                    description = "Разрешить служебному транспорту предоставлять настроенный комплект объектов.",
                    label = "Доступ к объектам транспорта",
                },
                radialEnabled = {
                    description = "Включить полицейские круговые действия.",
                    label = "Полицейское круговое меню",
                },
                radialHandcuffKeybindCommand = {
                    description = "Название команды, зарегистрированной для клавиши наручников.",
                    label = "Команда наручников",
                },
                radialHandcuffKeybindDescription = {
                    description = "Описание, отображаемое для клавиши наручников.",
                    label = "Описание клавиши наручников",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Включить прямую клавишу для надевания наручников.",
                    label = "Клавиша наручников",
                },
                radialHandcuffKeybindKey = {
                    description = "Клавиша клавиатуры, используемая для прямого действия наручников.",
                    label = "Клавиша наручников",
                },
                radialKeybindsEnabled = {
                    description = "Включить прямые клавиши для выбранных круговых действий.",
                    label = "Прямые клавиши",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Название команды, зарегистрированной для клавиши снятия наручников.",
                    label = "Команда снятия наручников",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Описание, отображаемое для клавиши снятия наручников.",
                    label = "Описание клавиши снятия наручников",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Включить прямую клавишу для снятия наручников.",
                    label = "Клавиша снятия наручников",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Клавиша клавиатуры, используемая для прямого действия снятия наручников.",
                    label = "Клавиша снятия наручников",
                },
                socialWorkAssignRange = {
                    description = "Максимальное расстояние для назначения заданий общественных работ.",
                    label = "Дистанция назначения",
                },
                socialWorkDeadlineDefault = {
                    description = "Срок общественных работ по умолчанию в минутах. Ноль отключает сроки.",
                    label = "Срок по умолчанию",
                },
                socialWorkDeadlineMax = {
                    description = "Максимальный срок общественных работ в минутах. Ноль отключает ограничение.",
                    label = "Максимальный срок",
                },
                socialWorkDeadlineMin = {
                    description = "Минимальный срок общественных работ в минутах.",
                    label = "Минимальный срок",
                },
                socialWorkDefaultTasks = {
                    description = "Количество заданий по умолчанию при открытии назначения общественных работ.",
                    label = "Заданий по умолчанию",
                },
                socialWorkEnabled = {
                    description = "Включить назначение и выполнение заданий общественных работ.",
                    label = "Общественные работы",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID тюрьмы, используемый, когда нарушения общественных работ приводят к заключению.",
                    label = "Резервный ID тюрьмы",
                },
                socialWorkImprisonmentMonths = {
                    description = "Количество месяцев, назначаемых при заключении в результате нарушений общественных работ.",
                    label = "Месяцев заключения",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Имя офицера, используемое в записях заключения за общественные работы.",
                    label = "Имя офицера заключения",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Отправлять нарушителей в одиночную камеру при заключении.",
                    label = "Использовать одиночное заключение",
                },
                socialWorkInactivityMinutes = {
                    description = "Минуты бездействия перед применением штрафов за бездействие в общественных работах.",
                    label = "Минуты бездействия",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Штраф в виде заданий, применяемый, когда игрок общественных работ слишком долго бездействует.",
                    label = "Штраф заданий за бездействие",
                },
                socialWorkMaxTasks = {
                    description = "Максимальное доступное для выбора количество заданий общественных работ.",
                    label = "Максимум заданий",
                },
                socialWorkMinTasks = {
                    description = "Минимальное доступное для выбора количество заданий общественных работ.",
                    label = "Минимум заданий",
                },
                speedCamBillingEnabled = {
                    description = "Выставлять автоматические счета, когда камера контроля скорости фиксирует соответствующее правонарушение. Требует включённой глобальной функции «Выставление счетов».",
                    label = "Автоматические штрафы",
                },
                speedCamBillingExcludedJobs = {
                    description = "Профессии, которые никогда не получают автоматические счета от камер контроля скорости.",
                    itemLabel = "Профессия",
                    label = "Исключённые профессии",
                },
                speedCamBillingExcludedModels = {
                    description = "Названия моделей транспорта, которые никогда не получают автоматические счета от камер контроля скорости.",
                    itemLabel = "Модель",
                    label = "Исключённые модели транспорта",
                },
                speedCamBillingRules = {
                    description = "Правила штрафов, используемые камерами контроля скорости. Сначала применяется наиболее точно совпадающий диапазон превышения; если ни одно правило не подходит, в качестве резерва используются правонарушения SpeedViolation.",
                    label = "Правила штрафов",
                },
                speedCamCameraEaseMs = {
                    description = "Как долго обзор плавно переходит к углу камеры контроля скорости. Меньшее значение — короче движение; слишком низкое может привести к смещению фото.",
                    label = "Плавность камеры (мс)",
                },
                speedCamCameraFov = {
                    description = "Угол обзора, используемый для съёмки камерой контроля скорости.",
                    label = "Угол обзора камеры",
                },
                speedCamCheckIntervalMs = {
                    description = "Миллисекунды между сканированиями камеры контроля скорости.",
                    label = "Интервал проверки",
                },
                speedCamCooldownMs = {
                    description = "Миллисекунды перед тем, как та же камера контроля скорости может сработать снова.",
                    label = "Перезарядка срабатывания",
                },
                speedCamDamageCooldownMs = {
                    description = "Миллисекунды перед тем, как урон камере контроля скорости может быть применён снова.",
                    label = "Перезарядка урона",
                },
                speedCamDamagePerHit = {
                    description = "Урон прочности, наносимый камере контроля скорости за один удар.",
                    label = "Урон за удар",
                },
                speedCamDamagedModelThreshold = {
                    description = "Процент максимальной прочности, при котором или ниже которого показывается повреждённая модель. Пример: значение 50 при максимальной прочности 200 переключает модель при прочности 100.",
                    label = "Порог повреждённой модели (%)",
                },
                speedCamDefaultLimit = {
                    description = "Ограничение скорости камеры контроля скорости по умолчанию.",
                    label = "Ограничение скорости по умолчанию",
                },
                speedCamDefaultName = {
                    description = "Предлагаемое отображаемое название при установке камеры. Его можно перевести без изменения предмета в инвентаре или модели объекта.",
                    label = "Название по умолчанию",
                },
                speedCamDefaultTolerance = {
                    description = "Допуск камеры контроля скорости по умолчанию.",
                    label = "Допуск по умолчанию",
                },
                speedCamDisassembleDistance = {
                    description = "Расстояние, используемое для разборки камер контроля скорости.",
                    label = "Дистанция разборки",
                },
                speedCamEnabled = {
                    description = "Включить портативные камеры контроля скорости.",
                    label = "Камеры контроля скорости",
                },
                speedCamFlashColor = {
                    description = "Цвет RGBA вспышки, используемый камерами контроля скорости.",
                    label = "Цвет вспышки",
                },
                speedCamFlashDurationMs = {
                    description = "Время затухания красной вспышки камеры контроля скорости. Не устанавливайте слишком низкое значение, иначе движение камеры станет заметным.",
                    label = "Длительность вспышки (мс)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Расстояние, на котором отображается прочность камеры контроля скорости.",
                    label = "Дистанция отображения прочности",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Миллисекунды, в течение которых прочность камеры контроля скорости остаётся видимой.",
                    label = "Длительность отображения прочности",
                },
                speedCamHealthTextOffset = {
                    description = "Вертикальное смещение, используемое для текста прочности камеры контроля скорости.",
                    label = "Смещение текста прочности",
                },
                speedCamItem = {
                    description = "Точное внутреннее имя предмета в инвентаре, например speedcam. Укажите ключ предмета, а не отображаемое название; магазин работы должен выдавать тот же предмет.",
                    label = "Имя предмета камеры",
                },
                speedCamMaintenanceThreshold = {
                    description = "Порог прочности, при котором рекомендуется обслуживание камеры контроля скорости.",
                    label = "Порог обслуживания",
                },
                speedCamMaxDurability = {
                    description = "Максимальная прочность установленных камер контроля скорости.",
                    label = "Максимальная прочность",
                },
                speedCamMaxLimit = {
                    description = "Максимальное настраиваемое ограничение скорости камеры контроля скорости.",
                    label = "Максимальное ограничение скорости",
                },
                speedCamMaxTolerance = {
                    description = "Максимальный настраиваемый допуск камеры контроля скорости.",
                    label = "Максимальный допуск",
                },
                speedCamPhotoLocale = {
                    description = "Необязательная локаль, используемая для отметки времени на снимках камеры контроля скорости. Оставьте пустым для использования локали зафиксированного игрока.",
                    label = "Локаль фото",
                },
                speedCamPhotoTimeZone = {
                    description = "Необязательный часовой пояс, используемый для отметки времени на снимках камеры контроля скорости. Оставьте пустым для использования часового пояса зафиксированного игрока.",
                    label = "Часовой пояс фото",
                },
                speedCamPoliceNotification = {
                    description = "Отправлять диспетчерское уведомление, когда камера контроля скорости фиксирует нарушение.",
                    label = "Оповещение полиции камерой контроля скорости",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Рассматривать цель диспетчеризации камеры контроля скорости как группу работ.",
                    label = "Цель диспетчеризации — группа",
                },
                speedCamPoliceNotificationJob = {
                    description = "Ключ работы или группы, используемый для диспетчерских уведомлений камеры контроля скорости.",
                    label = "Цель диспетчеризации",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Уведомлять только цели диспетчеризации камеры контроля скорости, находящиеся на смене.",
                    label = "Диспетчеризация требует смены",
                },
                speedCamPoliceNotificationType = {
                    description = "Серьёзность/тип диспетчеризации, используемый для оповещений камеры контроля скорости.",
                    label = "Тип диспетчеризации",
                },
                speedCamPropModel = {
                    description = "Имя для создания целой модели камеры, например sky_speedcam. Готовый вариант также выбирает повреждённую и уничтоженную модели. Пользовательские модели должны быть доступны в игре.",
                    label = "Модель объекта камеры контроля скорости",
                    custom = "Своя модель",
                    choose = "Выбрать модель",
                    preview = "3D-просмотр",
                    customPlaceholder = "Имя объекта для спавна",
                    previewDescription = "Показывает выбранный объект в игре. Просмотр не сохраняет изменения.",
                    invalidModel = "Сначала введите допустимое имя объекта.",
                    modelMissing = "Эта модель недоступна в игре.",
                    previewFailed = "Не удалось открыть просмотр модели.",
                    intact = "Целая модель",
                    previewRequiresGame = "Откройте /jobconfig в FiveM для просмотра объекта в игре.",
                    previewHelp = "Стрелки: перемещение; PageUp/PageDown: высота; колесо: поворот; Enter: закрыть; Backspace: отменить.",
                    options = {
                        sky_speedcam = "Стандартная камера",
                        sky_germ_speedcam = "Немецкая камера",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Имя для создания повреждённой модели камеры, например sky_speedcam2. Используйте вариант, соответствующий целой модели.",
                    label = "Модель повреждённого объекта",
                },
                speedCamPropModelDestroyed = {
                    description = "Имя модели, отображаемой при прочности камеры 0, например sky_speedcam1. Используйте вариант, соответствующий целой модели.",
                    label = "Модель уничтоженного объекта",
                },
                speedCamRepairAnimDict = {
                    description = "Словарь анимации, используемый при ремонте камер контроля скорости.",
                    label = "Словарь анимации ремонта",
                },
                speedCamRepairAnimFlag = {
                    description = "Флаг анимации, используемый при ремонте камер контроля скорости.",
                    label = "Флаг анимации ремонта",
                },
                speedCamRepairAnimName = {
                    description = "Название анимации, используемое при ремонте камер контроля скорости.",
                    label = "Название анимации ремонта",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Миллисекунды перед тем, как ремонт камеры контроля скорости можно отменить.",
                    label = "Задержка отмены ремонта",
                },
                speedCamRepairDistance = {
                    description = "Расстояние, используемое для ремонта камер контроля скорости.",
                    label = "Дистанция ремонта",
                },
                speedCamRepairItem = {
                    description = "Точное внутреннее имя предмета для ремонта, например fixtool. Укажите ключ предмета, а не отображаемое название.",
                    label = "Имя предмета для ремонта",
                },
                speedCamRepairPerTick = {
                    description = "Прочность, восстанавливаемая за каждый тик ремонта камеры контроля скорости.",
                    label = "Ремонт за тик",
                },
                speedCamRepairTickMs = {
                    description = "Миллисекунды между тиками ремонта камеры контроля скорости.",
                    label = "Тик ремонта",
                },
                speedCamStreamDistance = {
                    description = "Расстояние от игрока в метрах, в пределах которого загружаются модели камер. За его пределами модели выгружаются; сохранённые камеры остаются установленными.",
                    label = "Дистанция загрузки",
                },
                speedCamTriggerRadius = {
                    description = "Радиус обнаружения превышающих скорость автомобилей вокруг камеры в метрах.",
                    label = "Радиус срабатывания",
                },
                speedCamUseMph = {
                    description = "Отображать и обрабатывать ограничения камеры контроля скорости в милях в час.",
                    label = "Использовать MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Оружие, которому разрешено повреждать камеры контроля скорости при включённом ограничении.",
                    itemLabel = "Оружие",
                    label = "Разрешённое оружие",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Только перечисленное оружие может повреждать камеры контроля скорости, пока это включено.",
                    label = "Ограничение включено",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Расстояние в метрах перед очисткой предупреждений о камере контроля скорости.",
                    label = "Дистанция очистки",
                },
                speedCameraAppDefaultApp = {
                    description = "Показывать приложение камеры контроля скорости как приложение планшета по умолчанию.",
                    label = "Приложение по умолчанию",
                },
                speedCameraAppDescription = {
                    description = "Описание, отображаемое для приложения камеры контроля скорости.",
                    label = "Описание",
                },
                speedCameraAppDeveloper = {
                    description = "Метка разработчика, отображаемая для приложения камеры контроля скорости.",
                    label = "Разработчик",
                },
                speedCameraAppEnabled = {
                    description = "Включить приложение камеры контроля скорости в полицейском планшете.",
                    label = "Приложение камеры контроля скорости",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Надзаголовок, отображаемый в приложении камеры контроля скорости.",
                    label = "Надзаголовок",
                },
                speedCameraAppHeaderTitle = {
                    description = "Заголовок, отображаемый в приложении камеры контроля скорости.",
                    label = "Заголовок",
                },
                speedCameraAppIcon = {
                    description = "Путь к иконке, используемый для приложения камеры контроля скорости.",
                    label = "Путь к иконке",
                },
                speedCameraAppIdentifier = {
                    description = "Внутренний идентификатор приложения камеры контроля скорости.",
                    label = "Идентификатор",
                },
                speedCameraAppInFrontDot = {
                    description = "Пороговое значение скалярного произведения, используемое для определения, находится ли камера контроля скорости впереди игрока.",
                    label = "Порог скалярного произведения спереди",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Минимальная скорость транспорта в км/ч перед показом предупреждений.",
                    label = "Минимальная скорость транспорта",
                },
                speedCameraAppName = {
                    description = "Отображаемое название приложения камеры контроля скорости.",
                    label = "Название приложения",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Расстояние в метрах перед уведомлением о ближайших камерах контроля скорости.",
                    label = "Дистанция уведомления",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Предупреждать о камерах контроля скорости только когда игрок находится в транспорте.",
                    label = "Только в транспорте",
                },
                speedCameraAppOverlayBackground = {
                    description = "Цвет фона, используемый для наложения изображения номерного знака.",
                    label = "Фон наложения",
                },
                speedCameraAppOverlayBorder = {
                    description = "Цвет границы, используемый для наложения изображения номерного знака.",
                    label = "Граница наложения",
                },
                speedCameraAppOverlayColor = {
                    description = "Цвет текста, используемый для наложения изображения номерного знака.",
                    label = "Цвет наложения",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Включить наложение изображения номерного знака на снимки камеры контроля скорости.",
                    label = "Наложение включено",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Масштаб шрифта, используемый для наложения изображения номерного знака.",
                    label = "Масштаб шрифта наложения",
                },
                speedCameraAppOverlayX = {
                    description = "Нормализованная позиция наложения по оси X слева направо.",
                    label = "Наложение X",
                },
                speedCameraAppOverlayY = {
                    description = "Нормализованная позиция наложения по оси Y сверху вниз.",
                    label = "Наложение Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Предупреждать только о камерах контроля скорости, находящихся впереди игрока.",
                    label = "Требовать спереди",
                },
                speedCameraAppRoute = {
                    description = "Путь маршрутизации, открываемый приложением камеры контроля скорости.",
                    label = "Маршрут",
                },
                speedCameraAppSize = {
                    description = "Отображаемый размер хранилища для приложения камеры контроля скорости.",
                    label = "Размер приложения",
                },
                speedCameraAppSoundCoord = {
                    description = "Воспроизводить предупреждающие звуки камеры контроля скорости в мировых координатах.",
                    label = "Звук по координатам",
                },
                speedCameraAppSoundEnabled = {
                    description = "Включить предупреждающие звуки для приложения камеры контроля скорости.",
                    label = "Звук включён",
                },
                speedCameraAppSoundFrontend = {
                    description = "Воспроизводить предупреждающие звуки камеры контроля скорости через фронтенд-канал.",
                    label = "Фронтенд-звук",
                },
                speedCameraAppSoundLayers = {
                    description = "Количество наложенных предупреждающих звуков, воспроизводимых приложением камеры контроля скорости.",
                    label = "Слои звука",
                },
                speedCameraAppSoundName = {
                    description = "Название звука, используемого для предупреждений приложения камеры контроля скорости.",
                    label = "Название звука",
                },
                speedCameraAppSoundRange = {
                    description = "Диапазон, используемый для звуков предупреждения приложения камеры контроля скорости.",
                    label = "Диапазон звука",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Количество повторов предупреждающего звука камеры контроля скорости.",
                    label = "Количество повторов",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Миллисекунды между повторами предупреждающего звука камеры контроля скорости.",
                    label = "Задержка повтора",
                },
                speedCameraAppSoundSet = {
                    description = "Набор звуков, используемый для предупреждений приложения камеры контроля скорости.",
                    label = "Набор звуков",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Счёт, используемый для платежей за подписку на приложение камеры контроля скорости в планшете.",
                    label = "Счёт",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Включить платные подписки для приложения камеры контроля скорости в планшете.",
                    label = "Подписка включена",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Дни между продлениями подписки на приложение камеры контроля скорости в планшете.",
                    label = "Интервал в днях",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Цена, взимаемая за подписку на приложение камеры контроля скорости в планшете.",
                    label = "Цена подписки",
                },
                speedCameraAppThemeAccent = {
                    description = "Акцентный цвет, используемый приложением камеры контроля скорости.",
                    label = "Акцент",
                },
                speedCameraAppThemeBackground = {
                    description = "Линейный градиентный фон, используемый приложением камеры контроля скорости.",
                    label = "Фон",
                },
                speedCameraAppThemeBorder = {
                    description = "Цвет границы, используемый приложением камеры контроля скорости.",
                    label = "Граница",
                },
                speedCameraAppThemeButtonText = {
                    description = "Цвет текста кнопки, используемый приложением камеры контроля скорости.",
                    label = "Текст кнопки",
                },
                speedCameraAppThemeDanger = {
                    description = "Цвет опасности, используемый приложением камеры контроля скорости.",
                    label = "Опасность",
                },
                speedCameraAppThemeGhost = {
                    description = "Цвет прозрачной кнопки, используемый приложением камеры контроля скорости.",
                    label = "Прозрачная кнопка",
                },
                speedCameraAppThemeGhostText = {
                    description = "Цвет текста прозрачной кнопки, используемый приложением камеры контроля скорости.",
                    label = "Текст прозрачной кнопки",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Цвет мягкого градиента, используемый приложением камеры контроля скорости.",
                    label = "Мягкий градиент",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Цвет неактивной границы, используемый приложением камеры контроля скорости.",
                    label = "Неактивная граница",
                },
                speedCameraAppThemeModal = {
                    description = "Цвет фона модального окна, используемый приложением камеры контроля скорости.",
                    label = "Модальное окно",
                },
                speedCameraAppThemeMutedText = {
                    description = "Приглушённый цвет текста, используемый приложением камеры контроля скорости.",
                    label = "Приглушённый текст",
                },
                speedCameraAppThemeOverlay = {
                    description = "Цвет наложения, используемый приложением камеры контроля скорости.",
                    label = "Наложение",
                },
                speedCameraAppThemePillText = {
                    description = "Цвет текста плашки, используемый приложением камеры контроля скорости.",
                    label = "Текст плашки",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Начальный цвет основного градиента, используемый приложением камеры контроля скорости.",
                    label = "Начало основного градиента",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Конечный цвет основного градиента, используемый приложением камеры контроля скорости.",
                    label = "Конец основного градиента",
                },
                speedCameraAppThemeShadow = {
                    description = "Цвет тени, используемый приложением камеры контроля скорости.",
                    label = "Тень",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Акцентный цвет подсветки, используемый приложением камеры контроля скорости.",
                    label = "Акцент подсветки",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Второстепенный цвет текста, используемый приложением камеры контроля скорости.",
                    label = "Второстепенный текст",
                },
                speedCameraAppThemeSuccess = {
                    description = "Цвет успеха, используемый приложением камеры контроля скорости.",
                    label = "Успех",
                },
                speedCameraAppThemeSurface = {
                    description = "Цвет поверхности, используемый приложением камеры контроля скорости.",
                    label = "Поверхность",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Мягкий цвет поверхности, используемый приложением камеры контроля скорости.",
                    label = "Мягкая поверхность",
                },
                speedCameraAppThemeText = {
                    description = "Основной цвет текста, используемый приложением камеры контроля скорости.",
                    label = "Текст",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Акцентный цвет RGBA, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Акцент RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Цвет RGBA, используемый для фона интерфейса предупреждения о камере контроля скорости.",
                    label = "Фон RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Цвет RGBA иконки, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Иконка RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Цвет RGBA текста иконки, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Текст иконки RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Количество секунд, в течение которых интерфейс предупреждения остаётся видимым.",
                    label = "Секунды интерфейса предупреждения",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Цвет RGBA дополнительного текста, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Дополнительный текст RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Цвет RGBA текста, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Текст RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Цвет RGBA заголовка, используемый для интерфейса предупреждения о камере контроля скорости.",
                    label = "Заголовок RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Миллисекунды между проверками близости шипованных лент.",
                    label = "Интервал проверки",
                },
                spikeStripsEnabled = {
                    description = "Включить установленные шипованные ленты.",
                    label = "Шипованные ленты",
                },
                spikeStripsModels = {
                    description = "Модели объектов, считающиеся активными шипованными лентами.",
                    itemLabel = "Модель",
                    label = "Модели",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Миллисекунды перед повторной попыткой сканирования шипованных лент после отсутствия совпадений.",
                    label = "Интервал повтора",
                },
                spikeStripsScanDistance = {
                    description = "Расстояние, используемое для поиска ближайших шипованных лент.",
                    label = "Дистанция сканирования",
                },
                spikeStripsTriggerDistance = {
                    description = "Расстояние, на котором шипованная лента прокалывает колёса.",
                    label = "Дистанция срабатывания",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Метка категории, используемая для меток участков в редакторе.",
                    label = "Категория метки участка",
                },
                stationCreatorBlipColor = {
                    description = "Цвет карты, используемый для полицейских участков.",
                    label = "Цвет метки участка",
                },
                stationCreatorBlipScale = {
                    description = "Масштаб, используемый для меток полицейских участков.",
                    label = "Масштаб метки участка",
                },
                stationCreatorBlipShortRange = {
                    description = "Показывать метки участков только на близком расстоянии.",
                    label = "Короткая дистанция метки участка",
                },
                stationCreatorBlipSprite = {
                    description = "Спрайт карты, используемый для полицейских участков.",
                    label = "Спрайт метки участка",
                },
                stationCreatorBlipUseStationName = {
                    description = "Использовать настроенное название участка в качестве подписи метки на карте.",
                    label = "Использовать название участка",
                },
                tabletAutoFillCitizens = {
                    description = "Предзаполнять реестр граждан из базы данных фреймворка.",
                    label = "Автозаполнение граждан",
                },
                tabletAutoFillVehicles = {
                    description = "Предзаполнять реестр транспорта из базы данных фреймворка.",
                    label = "Автозаполнение транспорта",
                },
                tabletBolos = {
                    description = "Показывать приложение ориентировок.",
                    label = "Ориентировки (BOLO)",
                },
                tabletCases = {
                    description = "Показывать приложение дел.",
                    label = "Дела",
                },
                tabletCitizens = {
                    description = "Показывать приложение реестра граждан.",
                    label = "Граждане",
                },
                tabletConfiscations = {
                    description = "Показать журнал предметов, изъятых при обысках.",
                    label = "Изъятия",
                },
                tabletOffences = {
                    description = "Показывать приложение правонарушений.",
                    label = "Правонарушения",
                },
                tabletPrison = {
                    description = "Показывать приложение тюрьмы.",
                    label = "Тюрьма",
                },
                tabletReportEnforcement = {
                    description = "Разрешить назначать нарушения, штрафы и сроки заключения из сохранённых отчётов.",
                    label = "Исполнение по отчётам",
                },
                tabletReports = {
                    description = "Показывать приложение отчётов.",
                    label = "Отчёты",
                },
                tabletSocialWork = {
                    description = "Показывать приложение общественных работ.",
                    label = "Общественные работы",
                },
                tabletVehicles = {
                    description = "Показывать приложение реестра транспорта.",
                    label = "Транспорт",
                },
                tabletWarrants = {
                    description = "Показывать приложение ордеров.",
                    label = "Ордера",
                },
                tabletWeapons = {
                    description = "Показывать приложение реестра оружия.",
                    label = "Оружие",
                },
                tackleCuffKey = {
                    label = "Надеть наручники на сбитого",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                tackleKey = {
                    label = "Сбить с ног",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                tackleReleaseKey = {
                    label = "Отпустить сбитого",
                    description = "Клавиша FiveM по умолчанию, например E, F6 или MOUSE_BUTTON:MOUSE_RIGHT. Пустое поле означает отсутствие клавиши по умолчанию. Игроки могут менять назначения в настройках FiveM; сохранённые личные назначения сохраняются.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Миллисекунды перед тем, как можно поднять ещё одно оповещение радара.",
                    label = "Перезарядка оповещения",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Классы транспорта, которым разрешено использовать радар.",
                    label = "Разрешённые классы транспорта",
                },
                vehicleRadarAutoFastLock = {
                    description = "Автоматически отмечать очень быстрые цели в радаре.",
                    label = "Автобыстрый захват",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Пороговое значение скорости, используемое для автобыстрого захвата.",
                    label = "Порог быстрого захвата",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Привязка клавиши, используемая для уменьшения ограничения скорости радара.",
                    label = "Клавиша уменьшения лимита",
                },
                vehicleRadarDefaultLimit = {
                    description = "Ограничение скорости по умолчанию, используемое радаром транспорта.",
                    label = "Ограничение радара по умолчанию",
                },
                vehicleRadarEnabled = {
                    description = "Включить радар патрульного транспорта.",
                    label = "Радар транспорта",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Привязка клавиши, используемая для увеличения ограничения скорости радара.",
                    label = "Клавиша увеличения лимита",
                },
                vehicleRadarLimitStep = {
                    description = "Величина изменения при каждой корректировке ограничения радара.",
                    label = "Шаг ограничения",
                },
                vehicleRadarLockFrontKey = {
                    description = "Привязка клавиши, используемая для захвата переднего радарной цели.",
                    label = "Клавиша переднего захвата",
                },
                vehicleRadarLockRearKey = {
                    description = "Привязка клавиши, используемая для захвата задней радарной цели.",
                    label = "Клавиша заднего захвата",
                },
                vehicleRadarMaxLimit = {
                    description = "Максимальное ограничение скорости, допустимое в радаре транспорта.",
                    label = "Максимальное ограничение радара",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Максимальный наклон, допустимый для наведения радара.",
                    label = "Максимальный угол наклона",
                },
                vehicleRadarMinLimit = {
                    description = "Минимальное ограничение скорости, допустимое в радаре транспорта.",
                    label = "Минимальное ограничение радара",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Минимальная скорость, прежде чем радар посчитает цель действительной.",
                    label = "Минимальная скорость цели",
                },
                vehicleRadarModeFrontKey = {
                    description = "Привязка клавиши, используемая для переключения переднего режима радара.",
                    label = "Клавиша переднего режима",
                },
                vehicleRadarModeRearKey = {
                    description = "Привязка клавиши, используемая для переключения заднего режима радара.",
                    label = "Клавиша заднего режима",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Миллисекунды между сканированиями радара, пока патрульный транспорт движется.",
                    label = "Интервал сканирования в движении",
                },
                vehicleRadarPassengerControl = {
                    description = "Разрешить пассажирам управлять радаром транспорта.",
                    label = "Управление пассажиром",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Разрешить пассажирам просматривать зеркальные данные радара.",
                    label = "Зеркало для пассажира",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Миллисекунды между обновлениями синхронизации радара для пассажиров.",
                    label = "Интервал синхронизации для пассажира",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Пороговое значение проекции, используемое при оценке целей радара.",
                    label = "Порог проекции",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Требовать чистую линию видимости перед захватом цели радаром.",
                    label = "Требовать прямую видимость",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Требовать статус смены перед использованием радара транспорта.",
                    label = "Радар требует смены",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Миллисекунды между сканированиями неподвижного радара.",
                    label = "Интервал сканирования",
                },
                vehicleRadarScanRadius = {
                    description = "Радиус сканирования радара транспорта.",
                    label = "Радиус сканирования",
                },
                vehicleRadarToggleKey = {
                    description = "Привязка клавиши, используемая для включения/выключения радара транспорта.",
                    label = "Клавиша переключения",
                },
                vehicleRadarUseMph = {
                    description = "Отображать значения скорости радара в милях в час.",
                    label = "Радар использует MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Миллисекунды между обновлениями пула ближайшего транспорта.",
                    label = "Обновление пула транспорта",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Привязка клавиши, используемая для переднего XMIT/HOLD радара.",
                    label = "Клавиша переднего XMIT",
                },
                vehicleRadarXmitRearKey = {
                    description = "Привязка клавиши, используемая для заднего XMIT/HOLD радара.",
                    label = "Клавиша заднего XMIT",
                },
                wheelClampConsumeItem = {
                    description = "Удалять предмет блокиратора колеса после установки.",
                    label = "Расходовать предмет блокиратора",
                },
                wheelClampEnabled = {
                    description = "Включить действие блокиратора колеса.",
                    label = "Блокиратор колеса",
                },
                wheelClampItem = {
                    description = "Предмет инвентаря, используемый для установки блокиратора колеса.",
                    label = "Предмет блокиратора",
                },
                wheelClampPropModel = {
                    description = "Модель объекта, используемая для установленного блокиратора колеса.",
                    label = "Модель объекта блокиратора",
                },
                wheelClampRequireItem = {
                    description = "Требовать настроенный предмет блокиратора колеса. Оставьте включённым, если режим использования блокиратора установлен на «Инвентарь» или «Оба».",
                    label = "Блокиратор требует предмет",
                },
                wheelClampRequireOnDuty = {
                    description = "Требовать статус смены перед установкой блокираторов колёс.",
                    label = "Блокиратор требует смены",
                },
                wheelClampTyreDistance = {
                    description = "Максимальное расстояние до колеса при установке или сварке блокиратора.",
                    label = "Дистанция до колеса",
                },
                wheelClampUseItem = {
                    description = "Использовать круговое меню, инвентарь или оба варианта для установки блокиратора колеса. «Инвентарь» или «Оба» следует сочетать с «Блокиратор требует предмет».",
                    label = "Режим использования блокиратора",
                    options = {
                        both = "Оба",
                        inventory = "Инвентарь",
                        radial = "Круговое меню",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Максимальное расстояние до целевого транспорта при установке блокиратора.",
                    label = "Дистанция до транспорта",
                },
                wheelClampWeldBurstTyre = {
                    description = "Прокалывать колесо после того, как блокиратор снят сваркой.",
                    label = "Прокол колеса",
                },
                wheelClampWeldDurationMs = {
                    description = "Миллисекунды, необходимые для снятия блокиратора сваркой.",
                    label = "Длительность сварки",
                },
                wheelClampWeldEnabled = {
                    description = "Разрешить снятие блокираторов колёс сварочным аппаратом.",
                    label = "Сварка блокиратора",
                },
                wheelClampWeldItem = {
                    description = "Предмет инвентаря, необходимый для сварки блокиратора.",
                    label = "Предмет сварки",
                },
                wheelClampWeldMinigame = {
                    description = "Требовать прохождения мини-игры сварки блокиратора перед завершением снятия.",
                    label = "Мини-игра сварки",
                },
                ziptiesConsumeItem = {
                    description = "Удалять предмет стяжки при использовании.",
                    label = "Расходовать стяжки",
                },
                ziptiesCutterConsumeItem = {
                    description = "Удалять предмет резака после срезания стяжек.",
                    label = "Расходовать предмет резака",
                },
                ziptiesCutterEnabled = {
                    description = "Разрешить снятие стяжек кусачками.",
                    label = "Резак стяжек",
                },
                ziptiesCutterItem = {
                    description = "Предмет инвентаря, используемый для срезания стяжек.",
                    label = "Предмет резака",
                },
                ziptiesEnabled = {
                    description = "Включить действия со стяжками.",
                    label = "Стяжки",
                },
                ziptiesItem = {
                    description = "Предмет инвентаря, используемый для действий со стяжками.",
                    label = "Предмет стяжки",
                },
                ziptiesRequireHandsUp = {
                    description = "Требовать состояние поднятых рук перед применением стяжек.",
                    label = "Стяжки требуют поднятых рук",
                },
                ziptiesRequireItem = {
                    description = "Требовать настроенный предмет стяжки.",
                    label = "Стяжки требуют предмет",
                },
                ziptiesReturnOnRemove = {
                    description = "Возвращать предмет стяжки при снятии.",
                    label = "Возврат стяжек",
                },
                evidenceGsrDurationSeconds = {
                    description = "Остатки пороха остаются на руках игрока.",
                    label = "GSR продолжительность",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Предотвратить применение GSR, когда стрелок носит перчатки.",
                    label = "Перчатки защищают руки.",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Оружие, которое не содержит следов пороха.",
                    label = "Игнорируемое оружие",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Миллисекунды между проверками на очистку воды/дожди и GSR активированы.",
                    label = "Интервал проверки стирки",
                },
                evidenceGsrWashInRain = {
                    description = "Позволь дождю удалить остатки пороха.",
                    label = "Вымойся под дождем",
                },
                evidenceGsrWashInWater = {
                    description = "Позволь воде удалить остатки пороха.",
                    label = "Вымойся в воде",
                },
                fakePlateHeliDisplay = {
                    label = "Вертолёт показывает фальшивую тарелку",
                    description = "Показывает фальшивую тарелку на камере вертолета.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Обычные инструменты показывают фальшивую тарелку",
                    description = "Показывает фальшивую тарелку в стандартных полицейских инструментах.",
                },
                fakePlateRadarDisplay = {
                    label = "Радиолокатор показывает поддельную пластину",
                    description = "Показывает фальшивую пластину на борту радара.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Позволь полицейским системам прочесть общий фальшивый мешок с тарелками.",
                    label = "Узнай фальшивые таблички",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Ключ от мешка со штатом, опубликованный Mechanicjob.",
                    label = "Ключ от мешка",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Спид-камера показывает фальшивую тарелку",
                    description = "Показывает фальшивую пластину в стационарных радиолокационных отчётах.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Оставить пустыми для всех классов разрешенных профессий.",
                    label = "VIN классы",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN профессии",
                    description = "- профессии, которым разрешено пользоваться услугами по проверке VIN.",
                },
                fakePlateVinAudit = {
                    label = "Проверка VIN",
                    description = "Сохранить VIN проверки в журнале аудита.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN Проверка включена",
                    description = "Включает команду проверки транспортного средства VIN.",
                },
                fakePlateVinCommand = {
                    label = "Команда VIN",
                    description = "Команда, использованная для проверки транспортного средства на VIN.",
                },
                fakePlateVinCooldown = {
                    label = "VIN Охлаждение",
                    description = "Задержка между двумя проверками VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN максимальное расстояние",
                    description = "Максимальное расстояние между должностным лицом и транспортным средством для проверки его VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Показать поддельный индикатор",
                    description = "Показывает индикатор, когда чек обнаруживает фальшивую пластину.",
                },
                fakePlateVinRequireDuty = {
                    label = "Обязанность",
                    description = "Требует, чтобы офицер был обязан проверить VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Требовать сканирования",
                    description = "Требует сканирования объекта для проверки VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Сканирующее устройство",
                    description = "Товарно-материальные запасы, требующиеся для проверки VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Посадите заключенного на работу, когда его посадят.",
                    label = "Устранить профессию в тюрьме",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Возвращение заключённого к прежней профессии после освобождения не может оставить его безработным.",
                    label = "Восстановить первоначальную профессию",
                },
                primaryColor = {
                    description = "Цвет по умолчанию для группы полицейских работ.",
                    label = "Основной цвет",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Позволить рецензерам выставлять счет зарегистрированному владельцу даже в тех случаях, когда табличка, взятая в плен, помечена как поддельная или клонированная.",
                    label = "Разрешите подозревать поддельные таблички",
                },
                speedCamAdvancedPageSize = {
                    description = "Максимум возвращенных записей на страницу таблеток.",
                    label = "Размер страницы обзора",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Сбоку транспортного средства, фотографии которого могут использоваться для распознавания знаков.",
                    itemLabel = "Сбоку",
                    label = "Признанные стороны",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Одобрение допускается только после загрузки фотокамеры.",
                    label = "Требуются фотодоказательства",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Разрешение Боссмену, требуемое для утверждения или отказа от поимки. 18 - Управление счетами.",
                    label = "Разрешение на пересмотр ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Держите упаковки, табличка которых отсутствует в зарегистрированной базе данных по транспортным средствам.",
                    label = "Хранить незарегистрированные автотранспортные средства",
                },
                tabletSpeedcamReviews = {
                    description = "Показать приложение для просмотра усовершенствованной скоростной камеры при включении усовершенствованного режима.",
                    label = "Обзоры скоростных камер",
                },
                tackleCommand = {
                    description = "Команда зарегистрирована для поиска ближайшего человека. Введите имя команды без резки.",
                    label = "Выполнить команду",
                },
                tackleCuffCommand = {
                    description = "Команда зарегистрирована за наручники человека, находящегося в настоящее время под стражей после захвата. Введите название команды без резки.",
                    label = "Противодействие команде наручников",
                },
                tackleCuffDescription = {
                    description = "Описание, показываемое для наручников, связывающих ключи 5M.",
                    label = "Описание наручников",
                },
                tackleDescription = {
                    description = "Описание, показываемое для привязки в меню Ключей 5M.",
                    label = "Описание ключа",
                },
                tackleEnabled = {
                    description = "Активировать контакт с ближайшим человеком и держать его на земле.",
                    label = "Сбить с ног",
                },
                tackleMaxDistance = {
                    description = "Максимальное расстояние до цели, когда начинается хватка.",
                    label = "Расстояние",
                },
                tackleNeedsSprint = {
                    description = "Предъявите офицеру, чтобы он спрыгнул, прежде чем поймать человека.",
                    label = "Поиск требует спринтирования",
                },
                tackleReleaseCommand = {
                    description = "Команда, зарегистрированная за освобождение лица, находящегося в настоящее время после хватки. Введите командное имя без резки.",
                    label = "Загрузить команду выпуска",
                },
                tackleReleaseDescription = {
                    description = "Описание, показываемое для привязки shop-релиза в меню Ключей 5M.",
                    label = "Описание ключа выпуска",
                },
                tackleRequireOnDuty = {
                    description = "Предъявите состояние службы, прежде чем офицер сможет схватить человека.",
                    label = "Решение требует обязанности",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Команда, использованная для открытия или закрытия редактора радиолокатора. Введите название команды без резки.",
                    label = "Команда радиолокационной компоновки",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Команда, использованная для восстановления планировки радиолокатора по умолчанию. Введите название команды без резки.",
                    label = "Перезапуск системы радиолокационной компоновки",
                },
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Позволяет сотрудникам зарегистрироваться на доступных учебных занятиях.",
                approvalRequired = "Держит самозачисления до тех пор, пока уполномоченный инструктор не одобрит их.",
                defaultCapacity = "Количество мест по умолчанию, используемых при создании новой тренировки.",
                enabled = "Делает приложение для обучения доступным для этой работы.",
                requireOnDuty = "Требует, чтобы сотрудники были на дежурстве перед открытием или использованием Учебного приложения.",
                upcomingDays = "Количество дней, указанных в расписании учебного приложения.",
            },
            trainingFields = {
                allowSelfEnrollment = "Разрешить самостоятельное зачисление",
                approvalRequired = "Требует одобрения регистрации",
                defaultCapacity = "Дефолтная способность",
                enabled = "Обеспечить обучение",
                requireOnDuty = "Обязанность",
                upcomingDays = "Предстоящий период (дни)",
            },
            locationDescriptions = {
                jail_public_blip = "Позиция автоматически берётся из точки появления в тюрьме или, если она не задана, из первого тюремного терминала.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "Наручники на кону не дают результатов, когда требования в отношении наручников отключаются.",
                wheelClampUseItemRequiresItem = "Инвентаризация режима использования зажима или и то, и другое требует включения зажима.",
                ziptiesConsumeRequiresItem = "Связи не оказывают никакого воздействия, когда требования в отношении покрытий отключаются.",
            },
        },
    },
    JobConfiguratorImportFailed = "Не удалось импортировать значения config.lua для '%s': %s.",
    JobConfiguratorImportHistoryFailed = "Импорт увенчался успехом, но не удалось сохранить его историю.",
    JobConfiguratorImportNoData = "\"%s\" не содержит данных об импорте config.lua.",
    JobConfiguratorImportSuccess = "Импортированные значения config.lua для \"%s\": %d профессии, %d настройки, %d функции и %d.",
    JobConfiguratorTitle = "Профессиональная деятельность Конфигуратор",
    JobConfiguratorUnknown = "Неизвестный торговец по профессии.",
}
