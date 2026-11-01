JobConfigLocales["sky_mechanicjob:pt"] = {
    Nui = {
        workshopConfig = {
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Instalação do dinamómetro móvel",
                    entryPluralLabel = "Instalações do dinamómetro móvel",
                    label = "Instalações do dinamómetro móvel",
                },
                workshops = {
                    entryLabel = "Oficina",
                    entryPluralLabel = "Oficinas",
                    label = "Oficinas",
                },
            },
            dispatchActions = {
                addChannel = "Adicionar canal de rádio",
                addKeyword = "Adicionar palavra-chave",
                addPoi = "Adicionar ponto de interesse",
                addReporter = "Adicionar comunicante",
                addStatus = "Adicionar estado FMS",
                addVehicle = "Adicionar unidade virtual",
                addVehicleType = "Adicionar tipo de unidade",
                currentLocation = "Usar a localização actual",
            },
            dispatchFieldDescriptions = {
                crewCapacity = "Número máximo de pessoas que podem guarnecer a unidade. Use 0 para uma guarnição ilimitada.",
                joinLocked = "Impede a entrada de outras pessoas depois de a unidade estar guarnecida.",
                minimumCrew = "Número mínimo de pessoas nas unidades escolhidas para este plano de resposta.",
                poiId = "Identificador técnico estável que os perfis da central mantêm mesmo após o local ser renomeado.",
                readyStatusCode = "Estado FMS aplicado quando o recurso fica disponível para despacho.",
                resourceType = "Classifica o recurso operacional para filtros e coordenação da central.",
                respondingStatusCode = "Estado FMS aplicado quando o recurso responde a uma ocorrência.",
                shortLabel = "Etiqueta curta opcional apresentada nas seis memórias de canais do rádio.",
                stationId = "Associa a unidade a uma estação configurada no perfil da central.",
                unitId = "Identificador técnico estável que preserva a unidade mesmo quando o indicativo muda.",
                autoAlarm = "Atribui imediatamente unidades disponíveis correspondentes quando um incidente é criado.",
                available = "Unidades neste status podem ser sugeridas e atribuídas a um novo incidente.",
                averageResponseSpeedKmh = "Calcula a estimativa de chegada exibida a partir da distância em linha reta.",
                callsign = "Sinal único de chamada de rádio mostrado quando os jogadores equipam esta unidade virtual.",
                centerEnabled = "Permite que os membros de serviço autorizados sejam funcionários de um centro de expedição.",
                channelId = "ID de rádio para PMA Voice, SaltyChat e YACA. IDs numéricos como 2500 permanecem inalterados; PMA Voice mapeia IDs de texto para um número estável.",
                channelLabel = "Nome do canal legível mostrado para os expedidores e unidades.",
                defaultChannel = "Os expedidores entram neste canal quando iniciam o seu turno. As unidades se unem manualmente da aba Rádio. Selecione Nenhum para usar o grupo de tarefas padrão.",
                emergencyAppEnabled = "Torna este trabalho selecionável como serviço público no aplicativo de telefone de emergência.",
                enabled = "Torna este trabalho disponível para o aplicativo de distribuição e incidentes cruzados.",
                icon = "Selecione o ícone mostrado para esta categoria de unidade na Aplicação de Envio.",
                incidentAssessmentEnabled = "Mostra questões médicas e de avaliação de perigo na ingestão total de incidentes.",
                jobs = "Nomes de trabalhos adicionais que recebem incidentes usando esta palavra-chave.",
                noUnitFallback = "Sem um centro ou unidade de funcionários, envia uma notificação Sky para todos os membros em serviço.",
                radius = "Distância máxima em metros em que o anúncio da estação pode ser ouvido.",
                requirements = "Exigência de resposta como TIPO:COUNT pares, por exemplo PATROL:2,CRIME:1.",
                statusCode = "Estado numérico FMS mostrado no rádio portátil.",
                statusLabel = "Significado deste status FMS para expedidores e unidades.",
                vehicleType = "Deve corresponder a um código de tipo de veículo configurado na subsecção anterior.",
                vehicleTypeCode = "Código unitário curto utilizado nos requisitos de resposta, por exemplo PATROL, CRIME, EMS ou RESCUE.",
                vehicleTypeLabel = "Nome legível desta categoria de unidade.",
            },
            dispatchFields = {
                crewCapacity = "Capacidade da guarnição",
                joinLocked = "Bloquear entrada na guarnição",
                minimumCrew = "Guarnição mínima",
                poiId = "ID estável do ponto de interesse",
                readyStatusCode = "Código de estado disponível",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado em resposta",
                shortLabel = "Etiqueta da memória do rádio",
                stationId = "ID da estação",
                unitId = "ID estável da unidade",
                address = "Endereço",
                autoAlarm = "Alarme automático",
                available = "Disponível para expedição",
                averageResponseSpeedKmh = "Velocidade de resposta estimada (km/h)",
                callsign = "Indicador de chamada",
                category = "Categoria",
                centerEnabled = "Habilitar centro de despacho",
                channelId = "ID do canal",
                code = "Código",
                defaultChannel = "Canal de rádio padrão",
                emergencyAppEnabled = "Mostrar na aplicação de emergência",
                enabled = "Activar a expedição",
                icon = "Ícone",
                incidentAssessmentEnabled = "Activar a avaliação de emergência",
                jobs = "Trabalhos de destino (separados por vírgulas)",
                keywordCode = "Código da palavra- chave",
                label = "Legenda",
                name = "Nome",
                noUnitFallback = "Notificar o pessoal de serviço sem unidades",
                noneChannel = "Nenhum / grupo padrão",
                note = "Nota",
                phone = "Telefone",
                radius = "Raio de aviso",
                requirements = "Unidades necessárias (por exemplo PATROL:2,CRIME:1)",
                type = "Tipo",
                vehicleType = "Tipo de unidade de resposta",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Comunicantes conhecidos",
                    channels = "Canais de rádio",
                    plans = "Planos de resposta",
                    statuses = "Estados FMS disponíveis",
                    units = "Unidades virtuais",
                },
                active = "Central de despacho ativa",
                description = "Configure a receção de emergências, o rádio, as unidades, os planos de resposta, os locais e os dados dos comunicantes para este emprego.",
                inactive = "Central de despacho desativada",
                steps = {
                    accessText = "Ative a central e decida se este emprego pode disponibilizar pessoal para a central de despacho.",
                    accessTitle = "Acesso e receção",
                    fleetText = "Configure canais, códigos de estado FMS, tipos de veículos e indicativos.",
                    fleetTitle = "Rádio e frota",
                    responseText = "Conclua com palavras-chave, requisitos de resposta e pontos de interesse.",
                    responseTitle = "Planos de resposta",
                },
                title = "Central de despacho",
                warnings = {
                    channels = "Não existem canais de rádio próprios; será usado o canal alternativo do grupo de empregos.",
                    defaultChannel = "O canal predefinido selecionado já não existe.",
                    disabled = "A central de despacho está desativada para este emprego.",
                    statuses = "Tem de existir pelo menos um estado FMS disponível para alertar as unidades.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Gere nomes de comunicantes, números de retorno e notas da central próprios deste emprego.",
                dispatchChannels = "Define os canais de rádio que unidades e centros de despacho pessoal podem participar.",
                dispatchKeywords = "Define palavras-chave incidentes, contagens de veículos necessárias, trabalhos participantes e opcional automático alarmante.",
                dispatchPois = "Armazena estações e locais comuns para formulários de incidentes e anúncios de estações baseados em posições.",
                dispatchStatusCodes = "Configura as etiquetas de status do FMS e quais status contam como disponíveis para novos incidentes.",
                dispatchVehicleTypes = "Define as categorias de unidades utilizadas pelos planos de resposta, tais como Patrulha, Unidade Criminal, EMS ou Resgate.",
                dispatchVehicles = "Define veículos de expedição virtual que podem ser com pessoal de qualquer lugar sem necessidade de um veículo gerado.",
            },
            diagnosticsSettings = {
                enabledLabel = "Ativar diagnóstico de veículos",
                enabledDescription = "Permite que este emprego abra o diagnóstico de veículos e repare peças através dele.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnóstico de veículos",
                    description = "Configura o acesso deste emprego ao diagnóstico de veículos.",
                },
                dispatchReporters = "Comunicantes conhecidos",
                invalidSelection = "Seleção inválida: {value}",
                billingPrices = {
                    description = "Configure os preços da fatura para entradas de histórico de manutenção e reparo. A chave de ação é combinada com action_key, action_type, ou a etiqueta de trabalho.",
                    label = "Motivos de faturação",
                },
                billingSettings = {
                    description = "Configure o comportamento de faturamento mecânico para essa profissão.",
                    label = "Faturação",
                },
                dispatchChannels = "Canais de rádio",
                dispatchKeywords = "Palavras-chave e planos de resposta",
                dispatchPois = "Despacho POIs",
                dispatchSettings = {
                    description = "Configure o acesso de despacho, a entrada de emergência e o canal de rádio padrão.",
                    label = "Configurações de envio",
                },
                dispatchStatusCodes = "Códigos de estado",
                dispatchVehicleTypes = "Tipos de veículos de expedição",
                dispatchVehicles = "Dados da frota de expedição",
                emptyDescription = "Use o botão adicionar acima para criar o primeiro item.",
                emptyTitle = "Nada configurado ainda",
                partsDeliveryShop = "Loja de entrega de pecas",
                trainingSettings = {
                    description = "Configure o acesso ao treinamento, inscrições, aprovações e planejamento de cursos para este trabalho.",
                    label = "Configuração do treino",
                },
                tuningCostProfile = {
                    description = "Configure custos de performance, aparencia, rodas e opcoes especiais para este job.",
                    label = "Precos de tuning",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Câmara livre no menu de tuning",
                    description = "Permite ocultar o cursor com Espaço para mover livremente a câmara. Escape continua a fechar o menu.",
                },
                tuningCamera = {
                    description = "Foca automaticamente a peça selecionada. Quando desativada, mantém a câmara normal do jogo.",
                    label = "Câmara automática de tuning",
                },
                jgMileage = {
                    description = "Usar JG Vehicle Mileage enquanto o recurso estiver ativo. Caso contrário, usar a quilometragem Sky. O JG HUD é configurado separadamente.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Mostrar a quilometragem selecionada no JG HUD. Funciona sem JG Vehicle Mileage; instale o adaptador do HUD conforme o README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Ativa o editor de administração e as regras automáticas por matrícula e modelo. Após desativar, retire novamente os veículos afetados da garagem para repor os valores já aplicados.",
                    label = "Editor de condução",
                },
                kuv = {
                    description = "Iniciar inspeção técnica",
                    label = "Inspeção técnica do veículo",
                },
                mobileDyno = {
                    description = "Ativa o dinamómetro móvel, os ecrãs de controlo e resultados, o controlador das ventoinhas e o tablet.",
                    label = "Dinamómetro móvel",
                },
                vehicleRegistration = {
                    description = "Matricular / transferir veículo",
                    label = "Matrícula do veículo",
                },
                antiLag = {
                    description = "Ative a instalação anti-lag e os efeitos de exaustão.",
                    label = "Anti-Lag",
                },
                brakeOverheating = {
                    description = "Ative o calor do freio encenado, discos brilhantes, faíscas críticas e o fade curto do freio.",
                    label = "Sobreaquecimento do freio",
                },
                carryItems = {
                    description = "Exige transportar pecas entregues pela oficina.",
                    label = "Manuseio fisico de pecas",
                },
                customHandling = {
                    description = "Ative o drivetrain personalizado e o ajuste de manuseio.",
                    label = "Manuseio personalizado",
                },
                electronicTuning = {
                    description = "Ative a iluminação ECU, persistente e as opções de ajuste de assistência ao motorista.",
                    label = "Sintonização eletrônica",
                },
                instantTuning = {
                    description = "Permitir ajuste direto em locais de ajuste público configurados.",
                    label = "Afinação instantânea",
                },
                mileageHud = {
                    description = "Mostra a quilometragem do veiculo ao dirigir.",
                    label = "HUD de quilometragem",
                },
                nitro = {
                    description = "Ative a instalação de nitro e o uso do impulso do veículo.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Ativa pedidos de pecas da oficina e zonas de entrega.",
                    label = "Entrega de pecas",
                },
                selfServiceOrderNotifications = {
                    description = "Notificar os funcionários em serviço quando uma ordem de ajuste de autoatendimento é criada.",
                    label = "Notificações de encomendas automáticas",
                },
                stance = {
                    description = "Mostrar ajustes de Stance em todos os menus de ajuste e ativar o item Kit de Stance.",
                    label = "Postura",
                },
                stanceWheelSize = {
                    description = "Mostrar, salvar e aplicar ajustes de tamanho da roda no Stance.",
                    label = "Tamanho da Roda Stance",
                },
                stanceWheelWidth = {
                    description = "Mostrar, salvar e aplicar ajustes de largura da roda no Stance.",
                    label = "Largura da roda de estancamento",
                },
                subscriptions = {
                    description = "Ative terminais de assinatura de oficina, gerenciamento e descontos do cliente.",
                    label = "Assinaturas de workshops",
                },
                twoStep = {
                    description = "Ative o controle de lançamento em duas etapas e os efeitos de exaustão.",
                    label = "Dois Passos",
                },
                vehicleMaintenanceNotifications = {
                    description = "Notificar os proprietários quando o veículo atingir o limite de manutenção configurado.",
                    label = "Notificações de manutenção do veículo",
                },
                wheelDamage = {
                    description = "Ativa dano realista nas rodas e reparos.",
                    label = "Dano nas rodas",
                },
                workshopLift = {
                    description = "Ativa pontos de elevador utilizaveis nas oficinas.",
                    label = "Elevador da oficina",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Coloca o ponto na área de inspeção da oficina. O veículo deve estar dentro da distância de inspeção configurada para a inspeção técnica e a matrícula.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Posição do monitor de resultados.",
                    label = "Monitor de resultados",
                },
                mobile_dyno_station = {
                    description = "Posição do dinamómetro móvel.",
                    label = "Estação de dinamómetro móvel",
                },
                vehicle_registry = "Ponto de inspeção e matrícula",
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "Para mostrar este emprego na aplicação de emergência, o despacho tem de estar ativo. Ativa-o ou desativa a apresentação na aplicação de emergência nas definições de despacho.",
                dispatchJobNotCovered = "Nenhuma central de despacho ativa abrange o emprego «{job}». Em sky_jobs_base/config/config.lua, adiciona «{job}» a coveredJobs no perfil adequado de Config.Dispatch.centers e reinicia sky_jobs_base. Repor as definições não altera esta atribuição.",
                invalidDispatchChannels = "Os IDs dos canais de rádio devem ser únicos e cada canal precisa de uma etiqueta válida.",
                invalidDispatchDefaultChannel = "O canal de rádio predefinido não existe. Nas definições de despacho, seleciona um canal existente ou «Nenhum».",
                invalidDispatchKeywords = "Os planos de resposta devem ter códigos únicos e requisitos TIPO:QUANTIDADE válidos.",
                invalidDispatchPois = "Os IDs, nomes e coordenadas dos pontos de interesse devem ser válidos e únicos.",
                invalidDispatchRadioButtons = "Verifica os botões de função do rádio: usa cada botão suportado apenas uma vez e seleciona uma ação da respetiva lista.",
                invalidDispatchRadioFmsKeys = "Verifica as teclas FMS do rádio: usa cada tecla (0-9, * ou #) apenas uma vez e atribui um código de estado existente ou deixa-a sem atribuição.",
                invalidDispatchReadyStatus = "Nas definições de despacho, seleciona um código de prontidão marcado como disponível na lista de códigos de estado.",
                invalidDispatchReporters = "Os dados dos comunicantes conhecidos excedem o número de entradas ou o tamanho dos campos permitido.",
                invalidDispatchRespondingStatus = "Nas definições de despacho, seleciona um código de saída para uma ocorrência marcado como indisponível na lista de códigos de estado.",
                invalidDispatchSettings = "Selecione um estado disponível existente, um estado de resposta indisponível e um canal predefinido válido.",
                invalidDispatchStatusCodes = "Os códigos FMS devem ser únicos e pelo menos um estado deve estar disponível.",
                invalidDispatchVehicleTypes = "Os códigos de tipos de unidades de resposta devem ser únicos e completos.",
                invalidDispatchVehicles = "Os IDs e indicativos das unidades devem ser únicos e todas as referências de tipo e estação devem existir.",
            },
            settingGroups = {
                diagnostics = {
                    label = "Diagnóstico",
                },
                keybinds = {
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                    label = "Teclas",
                },
                safety = {
                    label = "Validação e segurança",
                },
                antiExploit = {
                    label = "Anti-exploit",
                },
                coach = {
                    label = "Treinador de telemetria",
                },
                cooldownMultipliers = {
                    label = "Multiplicadores de arrefecimento",
                },
                crashFalloff = {
                    label = "Atenuação dos danos por colisão",
                },
                criticalEngine = {
                    label = "Motor quebrado",
                },
                deformation = {
                    label = "Deformação",
                },
                fade = {
                    label = "Perda de eficácia dos travões",
                },
                features = {
                    label = "Recursos",
                },
                format = {
                    label = "Formato",
                },
                frontalImpact = {
                    label = "Impacto frontal severo",
                },
                general = {
                    label = "Geral",
                },
                heatMultipliers = {
                    label = "Multiplicadores de aquecimento",
                },
                illegalMarket = {
                    label = "Mercado ilegal",
                },
                integration = {
                    label = "Integração",
                },
                items = {
                    label = "Itens",
                },
                lifetime = {
                    label = "Vida",
                },
                limits = {
                    label = "Limites de armazenamento",
                },
                repairRestore = {
                    label = "Reparação Restaurar",
                },
                risk = {
                    label = "Risco",
                },
                rules = {
                    label = "Regras",
                },
                stages = {
                    label = "Fases de sobreaquecimento",
                },
                tyreRepair = {
                    label = "Reparação de Pneus",
                },
                visuals = {
                    label = "Efeitos visuais",
                },
            },
            settingSections = {
                electronicTuning = "Software do motor ECU",
                handlingEditor = "Editor de condução",
                mobileDyno = "Dinamómetro móvel",
                vehicleRegistry = "Documentos do veículo",
                advancedPricing = "Preços Avançados",
                brakeOverheating = "Sobreaquecimento do freio",
                carryItems = "Levar Itens",
                fakePlates = "Placas falsas",
                firejobVehicleFires = "Incêndios de veículos",
                general = "Geral",
                instantTuning = "Afinação instantânea",
                maintenanceNotifications = "Notificações de manutenção",
                mileageHud = "HUD de quilometragem",
                oilLeaks = "Vazamento de fluido do veículo",
                partsTheft = "Roubo de peças",
                subscriptions = "Subscrições",
                tuning = "Afinação",
                vehicleCare = "Cuidados com o veículo",
                wear = "Desgaste",
                wheelDamage = "Dano nas rodas",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Adicional",
                handlingAir = "Ar",
                handlingGeneral = "Geral",
                handlingRoad = "Estrada",
                handlingWater = "Água",
            },
            settingSubsections = {
                mechanicHotkeys = "Teclas",
                database = "Base de dados",
                handlingEditorGeneral = "Definições do editor",
                handlingMaximumCBikeHandlingData = "Motocicleta",
                handlingMaximumCBoatHandlingData = "Barco",
                handlingMaximumCCarHandlingData = "Carro",
                handlingMaximumCFlyingHandlingData = "Aeronave",
                handlingMaximumCHandlingData = "Base do veículo",
                handlingMaximumCSeaPlaneHandlingData = "Hidroavião",
                handlingMaximumCSpecialFlightHandlingData = "Voo especial",
                handlingMaximumCSubmarineHandlingData = "Submarino",
                handlingMaximumCTrailerHandlingData = "Reboque",
                handlingMaximumCVehicleWeaponHandlingData = "Armas do veículo",
                keybinds = "Teclas",
                operation = "Operação",
                placementRules = "Regras de colocação",
                testFlow = "Fluxo do teste",
                tuning = "Opções de tuning imediato",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Reparação do veículo",
                    description = "Disponibilizar reparações nos locais de tuning instantâneo.",
                },
                instantTuningRepairPrice = {
                    label = "Preço da reparação",
                    description = "Preço fixo da reparação, sem o multiplicador de tuning.",
                },
                instantTuningWashEnabled = {
                    label = "Lavagem do veículo",
                    description = "Disponibilizar lavagens nos locais de tuning instantâneo.",
                },
                instantTuningWashPrice = {
                    label = "Preço da lavagem",
                    description = "Preço fixo da lavagem, sem o multiplicador de tuning.",
                },
                vehiclePriceSource = {
                    label = "Origem dos preços dos veículos",
                    description = "Automático: SQL no ESX; catálogo de veículos no QBCore/Qbox. Base de dados: tabela SQL configurada em qualquer framework.",
                    options = {
                        auto = "Automático (framework)",
                        database = "Base de dados",
                    },
                },
                vehiclePriceTable = {
                    label = "Tabela de preços dos veículos",
                    description = "Tabela com preços de compra, por exemplo dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Coluna do nome de spawn",
                    description = "Coluna com nomes de spawn, por exemplo spawn_code (JG), não o nome apresentado.",
                },
                vehiclePricePriceColumn = {
                    label = "Coluna do preço",
                    description = "Coluna com preços de compra numéricos, por exemplo price.",
                },
                vehiclePriceHashColumn = {
                    label = "Coluna do hash do modelo (opcional)",
                    description = "Coluna opcional com hashes numéricos, por exemplo hashkey (JG). Deixe vazia para calcular os hashes dos nomes de spawn.",
                },
                handlingEditorFieldMaximum = {
                    description = "Valor máximo rígido aceite pelo editor para este campo de condução.",
                },
                handlingEditorFocusKey = {
                    label = "Voltar ao editor de condução",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Bytes codificados após os quais um pedido, resposta ou instantâneo do editor é indicado como grande.",
                    label = "Limite de payload grande",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mede as operações do editor e avisa através de Sky.Debug quando os limites configurados são excedidos.",
                    label = "Verificações de desempenho",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Milissegundos entre resumos de desempenho agregados quando o registo detalhado está ativo.",
                    label = "Intervalo do resumo",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Milissegundos após os quais uma operação do editor é indicada como lenta.",
                    label = "Limite de operação lenta",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Percentagem máxima que um controlo numérico pode mover acima ou abaixo da base do veículo lida. A introdução direta e a importação XML permanecem sem perdas. Um máximo do campo diferente do predefinido substitui o limite superior do controlo.",
                    label = "Desvio máximo do controlo",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Roubo de catalisador · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Roubo de catalisador · Controlo 73",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl172 = {
                    label = "Banco de ensaio · Controlo 172",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl173 = {
                    label = "Banco de ensaio · Controlo 173",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl174 = {
                    label = "Banco de ensaio · Controlo 174",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl175 = {
                    label = "Banco de ensaio · Controlo 175",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl177 = {
                    label = "Banco de ensaio · Controlo 177",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl38 = {
                    label = "Banco de ensaio · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl45 = {
                    label = "Banco de ensaio · Controlo 45",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicDynoControl47 = {
                    label = "Banco de ensaio · Controlo 47",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Pintura · Controlo 200",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Pintura · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Cuidados do veículo · Controlo 200",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Cuidados do veículo · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Empurrar veículo · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Empurrar veículo · Controlo 33",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Empurrar veículo · Controlo 34",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Empurrar veículo · Controlo 35",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Empurrar veículo · Controlo 32",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Empurrar veículo · Controlo 21",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Troca de roda · Controlo 200",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Troca de roda · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Troca de roda · Controlo 22",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Roubo de roda · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Roubo de roda · Controlo 73",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                mobileDynoConsumeItem = {
                    description = "Remover um item após uma colocação bem-sucedida.",
                    label = "Consumir item",
                },
                mobileDynoCooldownMs = {
                    label = "Duração do arrefecimento",
                },
                mobileDynoCountdownMs = {
                    label = "Contagem decrescente",
                },
                mobileDynoDuiDistance = {
                    label = "Distância de renderização",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Distância do controlador das ventoinhas",
                    description = "Distância em metros para usar o interruptor físico entre os ventiladores de refrigeração.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Duração de carga total",
                    description = "Millissegundos gastos em carga total sustentada em perfis que incluem um estágio de carga completa.",
                },
                mobileDynoHistoryLimit = {
                    label = "Limite do histórico",
                },
                mobileDynoInteractionDistance = {
                    label = "Distância de interação",
                },
                mobileDynoItemUseEnabled = {
                    description = "Permitir colocar o dinamómetro e o monitor através de itens.",
                    label = "Colocação por item",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limite de sessões ativas",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Distância de deteção do veículo",
                },
                mobileDynoMonitorItem = {
                    description = "Item do inventário para colocar o monitor de resultados.",
                    label = "Item do monitor",
                },
                mobileDynoPersistItems = {
                    description = "Manter as novas colocações após reiniciar o servidor.",
                    label = "Guardar colocações",
                },
                mobileDynoPickupDistance = {
                    description = "Distância máxima em metros para recolher o equipamento.",
                    label = "Distância de recolha",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Variação máxima de altura",
                    description = "Máxima variação da altura do solo em metros aceita em todas as sondas de pegada de dino.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Inclinação máxima de colocação",
                    description = "A inclinação máxima do solo em graus aceita em toda a pegada de dino.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Os mecânicos devem estar de serviço para colocar e operar o equipamento.",
                    label = "Exigir serviço",
                },
                mobileDynoResultDuiDistance = {
                    label = "Distância do ecrã de resultados",
                    description = "Distância máxima em metros em que o monitor de resultados separado é renderizado.",
                },
                mobileDynoReturnItem = {
                    description = "Devolver o item consumido ao recolher o equipamento.",
                    label = "Devolver item",
                },
                mobileDynoStationItem = {
                    description = "Item do inventário para colocar o dinamómetro.",
                    label = "Item do dinamómetro",
                },
                mobileDynoTabletDistance = {
                    description = "Distância máxima do dinamómetro em metros para controlo pelo tablet e testes ativos.",
                    label = "Alcance do tablet",
                },
                nitroActivationKey = {
                    label = "Manter nitro",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                registryBikeChecks = {
                    description = "Pontos de inspeção de motos",
                    label = "Pontos de inspeção de motos",
                },
                registryCarChecks = {
                    description = "Pontos de inspeção de carros",
                    label = "Pontos de inspeção de carros",
                },
                registryDistance = {
                    description = "Distância de serviço (metros)",
                    label = "Distância de serviço (metros)",
                },
                registryKuvFee = {
                    description = "Taxa Inspeção técnica do veículo",
                    label = "Taxa Inspeção técnica do veículo",
                },
                registryKuvValidityDays = {
                    description = "Validade de novas inspeções em tempo real. Padrão: 30 dias. As datas de vencimento existentes são mantidas.",
                    label = "Validade da inspeção (dias reais)",
                },
                registryKuvWarningDays = {
                    description = "Aviso prévio (dias)",
                    label = "Aviso prévio (dias)",
                },
                registryRegistrationFee = {
                    description = "Taxa de matrícula",
                    label = "Taxa de matrícula",
                },
                registryReinspectionFee = {
                    description = "Taxa de reinspeção",
                    label = "Taxa de reinspeção",
                },
                registryRequireKuv = {
                    description = "Exigir Inspeção técnica do veículo válida para matricular",
                    label = "Exigir Inspeção técnica do veículo válida para matricular",
                },
                registrySessionSeconds = {
                    description = "Prazo de confirmação (segundos)",
                    label = "Prazo de confirmação (segundos)",
                },
                registryTransferFee = {
                    description = "Taxa de transferência",
                    label = "Taxa de transferência",
                },
                registryVehicleTypes = {
                    description = "Tipos de veículo permitidos",
                    label = "Tipos de veículo permitidos",
                },
                tuningFocusKey = {
                    label = "Interação com rato no tuning",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                addRevenueToSociety = {
                    description = "Deposite dinheiro de ordem de ajuste pago na conta da sociedade de profissão de ajuste.",
                    label = "Depositar receitas para a sociedade",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Categorias de lojas de entrega de peças que permanecem livremente compráveis enquanto os preços avançados estão ativados. A correspondência ignora o invólucro e o espaço em branco.",
                    itemLabel = "Categoria",
                    label = "Categorias sempre disponíveis",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Mantenha itens de loja configurados das categorias selecionadas disponíveis sem uma ordem de ajuste e price-os através do sistema de fornecedor dinâmico.",
                    label = "Itens de loja sempre disponíveis",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Número de dias mostrados na análise de lucro do tablet.",
                    label = "Período de análise",
                },
                advancedPricingCategoryRules = {
                    description = "Limites de participação, margem, mão-de-obra e preço do fornecedor por categoria de ajuste.",
                    label = "Regras de categoria",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Margem mecânica padrão antes dos ajustes de classe e grau.",
                    label = "Margem predefinida",
                },
                advancedPricingDifficultyRules = {
                    description = "Custo adicional de mão-de-obra para cada dificuldade de ajuste.",
                    label = "Regras de dificuldade",
                },
                advancedPricingEnabled = {
                    description = "Recalcular os preços de ajuste no servidor e, quando a entrega de peças estiver ativada, exigir que as peças Dynasty sejam compradas para sua ordem de ajuste específica.",
                    label = "Ativar preços avançados",
                },
                advancedPricingInventoryBaseStock = {
                    description = "estoque virtual normal para cada item do fornecedor.",
                    label = "Estoque base",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Pontos de demanda removidos por dia decorrido.",
                    label = "Decaimento diário da demanda",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Marcação do fornecedor adicionada para cada ponto de demanda.",
                    label = "Marcação de demanda por unidade",
                },
                advancedPricingInventoryEnabled = {
                    description = "Elevar os preços dos fornecedores quando o estoque virtual é baixo ou a demanda é alta.",
                    label = "Stock dinâmico do fornecedor",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Marcação máxima do fornecedor causada por estoque baixo.",
                    label = "Marcação de baixo estoque",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Nível de estoque abaixo do qual os preços de escassez começam.",
                    label = "Limite de existências baixas",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Limite superior para a marcação de demanda.",
                    label = "Marcação máxima da procura",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Unidades virtuais reabastecidas por dia decorrido.",
                    label = "Reabastecimento diário",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "teto de desconto global para faturas mecânicas.",
                    label = "Desconto máximo",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "A margem mecânica mais alta permitida.",
                    label = "Margem máxima",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Limite global de preço superior para uma peça de ajuste.",
                    label = "Preço máximo de venda a retalho",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Marcação, mão-de-obra e limites de desconto por grau mecânico.",
                    label = "Regras de grau mecânico",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Menor margem mecânica permitida.",
                    label = "Margem mínima",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Limite de preço global mais baixo para uma peça de ajuste.",
                    label = "Preço mínimo de venda a retalho",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Valor do veículo utilizado para o exemplo compacto.",
                    label = "Valor de pré-visualização compacto",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Exemplo de porcentagem de custo de ajuste usado pela visualização ao vivo.",
                    label = "Pré-visualizar a taxa de ajuste",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Valor do veículo usado para o exemplo esportivo.",
                    label = "Valor de pré-visualização esportiva",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Valor do veículo usado para o exemplo do supercarro.",
                    label = "Super valor de pré-visualização",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minutos antes de uma cotação de preço não paga ser recalculada.",
                    label = "Vida útil da citação",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Percentagem reembolsada por uma peça adquirida.",
                    label = "Reembolso",
                },
                advancedPricingRoundingStep = {
                    description = "Redonda cada linha de aquisição Dynasty para esta etapa de dinheiro.",
                    label = "Passo de arredondamento do fornecedor",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Percentagem do preço da peça do cliente cobrado pela Dynasty Auto Supply.",
                    label = "Partilha de fornecedores",
                },
                advancedPricingTaxPercent = {
                    description = "Percentagem de imposto armazenada separadamente na contabilidade de preços.",
                    label = "Impostos",
                },
                advancedPricingVehicleClassRules = {
                    description = "Margem e ajustes de mão-de-obra por GTA classe do veículo.",
                    label = "Regras da classe do veículo",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Multiplicadores de recarga de atualização de freio",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Multiplicadores de recarga da classe do veículo",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Atraso em milissegundos após a frenagem antes do início do resfriamento ativo.",
                    label = "Atraso de refrigeração",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "O calor é removido por segundo enquanto o freio não está sendo usado.",
                    label = "Ritmo de arrefecimento",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "O nível de calor em que faíscas e desbotamento curto do freio pode começar.",
                    label = "Limiar crítico",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Possibilidade de 0 a 1 para um curto corte de freio durante a frenagem em calor crítico.",
                    label = "Fade chance por segundo",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Descarga de Fade",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Duração máxima do fade",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Duração mínima de desvanecimento",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Multiplicadores de calor de atualização de freio",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Multiplicadores de calor de classe de veículo",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "Calor básico ganho por segundo durante a frenagem na velocidade de referência.",
                    label = "Ganho de calor",
                },
                brakeOverheatingHotThreshold = {
                    label = "Limiar quente",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Velocidade mínima do veículo em km/h antes da frenagem gerar calor.",
                    label = "Velocidade mínima de travagem",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Velocidade em km/h em que o ganho de calor base configurado é aplicado.",
                    label = "Velocidade de referência",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Intervalo máximo de faíscas",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Intervalo mínimo de faíscas",
                },
                brakeOverheatingVisualDistance = {
                    description = "Distância máxima em metros para renderização de brilho e faísca.",
                    label = "Distância visual",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Limiar quente",
                },
                carryItems = {
                    description = "Peças entregues que devem se tornar adereços físicos transportados.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Punho do motor",
                                forklift = "Empilhadeira",
                                hand = "Mão",
                            },
                        },
                    },
                    itemLabel = "Carregar item",
                    label = "Transportar itens",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 não adiciona potência; 1,10 aumenta o torque em 10%. Aplica-se aos veículos com este estágio ECU.",
                    label = "Multiplicador de torque do estágio 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 não adiciona potência; 1,10 aumenta o torque em 10%. Aplica-se aos veículos com este estágio ECU.",
                    label = "Multiplicador de torque do estágio 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 não adiciona potência; 1,10 aumenta o torque em 10%. Aplica-se aos veículos com este estágio ECU.",
                    label = "Multiplicador de torque do estágio 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 não adiciona potência; 1,10 aumenta o torque em 10%. Aplica-se aos veículos com este estágio ECU.",
                    label = "Multiplicador de torque do estágio 4",
                },
                fakePlatesAudit = {
                    label = "Registro de auditoria",
                },
                fakePlatesBlacklist = {
                    description = "Palavras bloqueadas ou fragmentos que não podem aparecer em placas falsas.",
                    label = "Lista negra",
                },
                fakePlatesBlankPlateItem = {
                    description = "Material de artesanato / loja usado para loops de economia de placa falsa.",
                    label = "Item de placa em branco",
                },
                fakePlatesCooldownMinutes = {
                    label = "Minutos de tempo de espera",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Chance de queda",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Crash falloff ativado",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Velocidade mínima de colisão",
                },
                fakePlatesEnabled = {
                    description = "Permita que os jogadores usem kits de placas falsas em veículos.",
                    label = "Ativar placas falsas",
                },
                fakePlatesExpireMinutes = {
                    description = "0 mantém placas falsas ativas até que o manuseio de reinicialização ou reinicialização as remova.",
                    label = "Expirar minutos",
                },
                fakePlatesExpireOnRestart = {
                    label = "Expirar na reinicialização",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Conta de pagamento",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Mercado ilegal habilitado",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Preço de mercado ilegal",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Multiplicador de risco",
                },
                fakePlatesInstallDurationMs = {
                    label = "Duração da instalação ms",
                },
                fakePlatesItem = {
                    description = "Um item de uso que inicia o fluxo de instalação da placa falsa.",
                    label = "Fake kit item placa",
                },
                fakePlatesMaxLength = {
                    label = "Comprimento máximo",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Distância ao veículo",
                },
                fakePlatesMinLength = {
                    label = "Comprimento mínimo",
                },
                fakePlatesPattern = {
                    description = "Lua padrão usado para validar texto de placa falsa, por exemplo [A-Z0-9]+$.",
                    label = "Padrão Lua",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Distância da posição da placa",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Bloquear placas falsas ativas duplicadas",
                },
                fakePlatesPrinterItem = {
                    description = "Ferramenta de artesanato / loja usada para loops de economia de placas falsas.",
                    label = "Item da impressora de placas",
                },
                fakePlatesRequireEngineOff = {
                    label = "O motor deve estar desligado",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Use Config.Functions.CanApplyFakePlate antes de permitir a instalação.",
                    label = "Requer proprietário ou chaves",
                },
                fakePlatesRequireStopped = {
                    label = "O veículo deve ser parado",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Reservado para integrações de garagem que chamam o evento de reset/exportação.",
                    label = "Redefinir na loja de garagem",
                },
                fakePlatesRiskCharacters = {
                    label = "Caracteres de Typo",
                },
                fakePlatesRiskEnabled = {
                    label = "Erros de tipo de risco ativados",
                },
                fakePlatesRiskTypoChance = {
                    label = "Oportunidade de Typo",
                },
                fallbackVehicleValue = {
                    description = "Valor usado quando nenhum preço do veículo pode ser resolvido.",
                    label = "Valor do veículo de retorno",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Chance de 0 a 1 depois que o motor permanece crítico.",
                    label = "Chance de incêndio do motor crítico",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Segundos antes que outro fogo de motor quebrado possa disparar.",
                    label = "Refrigeração crítica do motor",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Atraso em milissegundos antes que um motor quebrado possa inflamar.",
                    label = "Delay crítico do motor ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Permitir que os motores criticamente danificados para iniciar um incêndio veículo Firejob após um atraso.",
                    label = "Ignite motores quebrados",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Densidade de fumaça usada para solicitações de fogo de motor quebrado.",
                    label = "Densidade crítica de fumaça do motor",
                },
                firejobVehicleFiresEnabled = {
                    description = "Permitir que os sistemas de danos Mechanicjob solicitem incêndios de veículos a partir de Firejob.",
                    label = "Ativar fogos de veículos Firejob",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Relação de movimento para a frente necessária de 0 a 1.",
                    label = "Relação de movimento para a frente",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Chance de 0 a 1 de que um impacto qualificado inicie um incêndio.",
                    label = "Chance de incêndio de impacto",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Segundos antes que outro incêndio de impacto possa disparar.",
                    label = "Recarga de fogo de impacto",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Permita que acidentes frontais fortes solicitem um incêndio no veículo Firejob.",
                    label = "Ignição após acidentes graves",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Densidade de fumaça usada para solicitações de incêndio desencadeadas por acidente.",
                    label = "Densidade de fumaça de impacto",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatic usa o recurso Firejob configurado; Disabled impede Mechanicjob de criar incêndios.",
                    label = "Modo de integração",
                    options = {
                        automatic = "Automática",
                        disabled = "Desativado",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Mínima saúde corporal perdida durante o impacto.",
                    label = "Danos corporais mínimos",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "Mínimo de saúde do motor perdido durante o impacto.",
                    label = "Dano mínimo do motor",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Use 0 para desativar esta verificação de deformação.",
                    label = "Deformação dianteira mínima",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Velocidade mínima de pré-impacto em km/h.",
                    label = "Velocidade mínima de impacto",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Perda de velocidade necessária em km/h durante o impacto.",
                    label = "Perda mínima de velocidade",
                },
                firejobVehicleFiresResource = {
                    description = "Recurso que recebe pedidos de incêndio de veículos.",
                    label = "Recurso Firejob",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Evento de servidor interno usado pelo cliente mecânico para solicitar um incêndio de veículo Firejob.",
                    label = "Evento de servidor mecânico",
                },
                freeVehicles = {
                    description = "Modelos de desova de veículos que recebem ordens de ajuste gratuitas.",
                    itemLabel = "Modelo do veículo",
                    label = "Veículos de afinação gratuitos",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Impedir a aplicação enquanto existir um conflito de tratamento crítico.",
                    label = "Bloquear achados críticos",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "Expectativa de desaceleração máxima em m/s2 para um ensaio de travagem concluído.",
                    label = "Desaceleração mínima do freio",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Amostras medidas necessárias antes do Telemetry Coach avaliar uma corrida.",
                    label = "Amostras mínimas",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Velocidade de deslizamento da roda medida em km/h em que a perda de tração é relatada.",
                    label = "Aviso de deslizamento de roda",
                },
                handlingEditorDefaultTab = {
                    description = "Página selecionada sempre que o Editor de Manuseio autônomo for aberto.",
                    label = "Página inicial",
                    options = {
                        advanced = "Avançado",
                        export = "Exportar",
                        flags = "Bandeiras",
                        fleet = "Frota",
                        inspector = "Camadas",
                        profiles = "Perfis",
                        simple = "Simples",
                        telemetry = "Telemetria",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Fornecer efeito, intervalo de referência, sintomas, campos relacionados e suporte ao vivo para cada valor de manuseio.",
                    label = "Documentação de campo",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Pesquisar e filtrar nomes, efeitos, posições de bits e máscaras hexadecimais.",
                    label = "Busca de bandeira",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Pesquise, inspecione, promova e restaure regras de manuseio de modelos e placas.",
                    label = "Gestor de frota",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Mostre a base do veículo, ajuste personalizado instalado, regra do modelo, regra da placa e rascunho do editor atual para cada campo.",
                    label = "Inspector de camada",
                },
                handlingEditorMaxFleetResults = {
                    description = "Regras máximas do modelo e da placa carregadas no Fleet Manager.",
                    label = "Limite de resultados da frota",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Número máximo de revisões retidas para cada perfil.",
                    label = "Revisões de perfil",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Máximo de espaços de trabalho nomeados retidos para cada administrador.",
                    label = "Espaços de trabalho pessoais",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Crie uma revisão auditável sempre que um perfil compartilhado for atualizado ou restaurado.",
                    label = "Versionamento de perfil",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Crie recomendações transparentes baseadas em regras a partir de dados medidos de testes rodoviários.",
                    label = "Treinador de telemetria",
                },
                handlingEditorValidatorEnabled = {
                    description = "Detectar combinações inseguras ou contraditórias antes do manuseio ser aplicado.",
                    label = "Manipulação de validador",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Permita que os administradores mantenham os rascunhos do editor privado nomeados.",
                    label = "Espaços de trabalho pessoais",
                },
                instantTuningAllowedJobs = {
                    description = "Opcional lista de permissões globais. Deixe vazio para permitir que todos, a menos que apenas mecânicos estejam habilitados.",
                    itemLabel = "Nome da profissão",
                    label = "Trabalhos permitidos",
                },
                instantTuningBlipColor = {
                    description = "GTA id de cor blip.",
                    label = "Cor Blip",
                },
                instantTuningBlipEnabled = {
                    description = "Mostrar blips de mapa para locais de ajuste instantâneo.",
                    label = "Blip activado",
                },
                instantTuningBlipName = {
                    description = "Mapa blip name.",
                    label = "Nome Blip",
                },
                instantTuningBlipSprite = {
                    description = "ID do ícone do marcador no mapa do GTA.",
                    label = "Ícone do marcador",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Use a interação E no estilo marcador mesmo quando o suporte de destino estiver ativado.",
                    label = "Interação do marcador de força",
                },
                instantTuningInteractionDistance = {
                    description = "Distância padrão para usar pontos de ajuste instantâneos.",
                    label = "Distância de interação",
                },
                instantTuningLabel = {
                    description = "Texto padrão mostrado em pontos de ajuste instantâneo.",
                    label = "Rótulo padrão",
                },
                instantTuningLocations = {
                    description = "Pontos de ajuste instantâneo. Use a distância 0 para herdar a distância de interação padrão.",
                    itemLabel = "Localizações",
                    label = "Localizações",
                },
                instantTuningMarkerEnabled = {
                    description = "Desenhe um marcador mundial em locais de ajuste instantâneo.",
                    label = "Marcador ativado",
                },
                instantTuningMarkerType = {
                    description = "Tipo de marcador GTA usado para locais de ajuste instantâneo.",
                    label = "Tipo de marcador",
                },
                instantTuningMechanicOnly = {
                    description = "Restringir todos os locais de ajuste instantâneo para profissões mecânicas configuradas.",
                    label = "Mecânico apenas",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplicador aplicado aos preços de ajuste instantâneo.",
                    label = "Multiplicador de preço",
                },
                instantTuningProfile = {
                    description = "Configure quais opções de ajuste estão disponíveis em pontos de ajuste instantâneos.",
                    label = "Opções de ajuste instantâneo",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Mínimo de minutos antes que o mesmo veículo possa acionar outro lembrete de manutenção.",
                    label = "Recarga de notificação",
                },
                maintenanceNotificationsEnabled = {
                    description = "Notificar os proprietários do veículo quando uma peça de desgaste atingir o limite de manutenção.",
                    label = "Ativado",
                },
                maintenanceNotificationsThreshold = {
                    description = "Porcentagem de desgaste em ou abaixo da qual a manutenção é considerada devida.",
                    label = "Limite devido",
                },
                mileageHudDigits = {
                    description = "Número de dígitos mostrados na milhagem HUD.",
                    label = "Digitas",
                },
                mileageHudPosition = {
                    description = "Arraste a visualização da milhagem HUD para a posição da tela desejada.",
                    label = "Posição",
                },
                oilLeaksCooldownSeconds = {
                    description = "Segundos antes que outro vazamento de impacto possa desencadear.",
                    label = "Recarga de impacto",
                },
                oilLeaksEnabled = {
                    description = "Permita que veículos de combustão danificados deixem o fluido para trás durante a condução.",
                    label = "Ativar vazamentos de fluidos",
                },
                oilLeaksEngineOilChance = {
                    description = "Chance de vazamento normal de 0 a 1.",
                    label = "Chance de óleo do motor",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Chance de vazamento crítico de 0 a 1.",
                    label = "Chance crítica de óleo do motor",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "Condição do óleo do motor em ou abaixo do qual a chance crítica é usada.",
                    label = "Limiar crítico do óleo do motor",
                },
                oilLeaksEngineOilThreshold = {
                    description = "Condição de óleo do motor em ou abaixo do qual um vazamento pode começar.",
                    label = "Limiar do óleo do motor",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Relação de movimento para a frente necessária de 0 a 1.",
                    label = "Relação de movimento para a frente",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Permita que impactos frontais graves iniciem um vazamento temporário de fluido do motor.",
                    label = "Vazamentos de impacto frontal",
                },
                oilLeaksImpactChance = {
                    description = "Chance de 0 a 1 de que um impacto qualificado inicie um vazamento.",
                    label = "Chance de vazamento de impacto",
                },
                oilLeaksImpactRadius = {
                    description = "Raio do ponto fluido inicial criado por um impacto.",
                    label = "Raio de vazamento de impacto",
                },
                oilLeaksIntervalSeconds = {
                    description = "Mínimo de segundos entre os pontos de trilha.",
                    label = "Intervalo de trail",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Segundos, um vazamento continua após um impacto de qualificação.",
                    label = "Duração do vazamento de impacto",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Mínima saúde corporal perdida durante o impacto.",
                    label = "Danos corporais mínimos",
                },
                oilLeaksMinDistance = {
                    description = "Distância mínima percorrida entre os pontos de trilha.",
                    label = "Distância da trilha",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "Mínimo de saúde do motor perdido durante o impacto.",
                    label = "Dano mínimo do motor",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Deformação dianteira necessária. Use 0 para desabilitar esta verificação.",
                    label = "Deformação dianteira mínima",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Velocidade mínima de pré-impacto em km/h.",
                    label = "Velocidade mínima de impacto",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Perda de velocidade necessária em km/h durante o impacto.",
                    label = "Perda mínima de velocidade",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Velocidade mínima do veículo em km / h antes de um vazamento de fluido pode criar uma trilha.",
                    label = "Velocidade mínima",
                },
                oilLeaksRadius = {
                    description = "Raio de pontos de trilha de fluido do veículo regular.",
                    label = "Raio da trilha",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Chance de vazamento normal de 0 a 1.",
                    label = "Chance de fluido de transmissão",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Chance de vazamento crítico de 0 a 1.",
                    label = "Chance de transmissão crítica",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "Condição de fluido de transmissão em ou abaixo da qual a chance crítica é usada.",
                    label = "Limiar crítico de transmissão",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "Condição de fluido de transmissão em ou abaixo do qual um vazamento pode começar.",
                    label = "Limiar do fluido de transmissão",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Classes de veículos que podem completar o trabalho de pedido dependente do elevador sem um elevador de oficina.",
                    itemLabel = "Adicionar classe de veículo",
                    label = "Classes do veículo do desvio do elevador",
                    options = {
                        ["0"] = "Compactos",
                        ["1"] = "Sedans",
                        ["10"] = "Industrial",
                        ["11"] = "Utilidade",
                        ["12"] = "Vans",
                        ["13"] = "Ciclos",
                        ["14"] = "Barcos",
                        ["15"] = "Helicopters",
                        ["16"] = "Aviões",
                        ["17"] = "Serviço",
                        ["18"] = "Emergência",
                        ["19"] = "Militares",
                        ["2"] = "SUVs",
                        ["20"] = "Comercial",
                        ["21"] = "Comboios",
                        ["22"] = "Roda aberta",
                        ["3"] = "Coupes",
                        ["4"] = "Músculo",
                        ["5"] = "Clássicos Desportivos",
                        ["6"] = "Esportes",
                        ["7"] = "Super",
                        ["8"] = "Motociclos",
                        ["9"] = "Todo-o-terreno",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modelos de desova de veículos que podem completar o trabalho de pedido dependente do elevador sem um elevador de oficina.",
                    itemLabel = "Modelo do veículo",
                    label = "Levantar modelos de veículos de bypass",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millissegundos usados para etapas de instalação de pedidos que não executam um minijogo.",
                    label = "Duração de instalação simples",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "IDs de classe de veículo que sempre usam a instalação mecânica normal sem fluxos de elevador ou minigame especializados.",
                    label = "Classes de veículos não minigame",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modelos de geração de veículos que sempre usam a instalação mecânica normal sem fluxos de elevação ou minijogos especializados.",
                    label = "Modelos de veículos não minigame",
                },
                partsDeliveryCompanyCard = {
                    description = "Permita que as ordens de entrega de peças usem os fundos da empresa.",
                    label = "Pagamento com cartão da empresa",
                },
                partsDeliveryMode = {
                    description = "Mantenha o fluxo de entrega física padrão ou adicione a entrega completa diretamente ao inventário do jogador coletor.",
                    label = "Manipulação da entrega",
                    options = {
                        player_inventory = "Inventário do jogador",
                        standard = "Fluxo de entrega padrão",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millissegundos necessários para descompactar uma entrega de peças prontas.",
                    label = "Duração aberta",
                },
                partsDeliveryOwnCard = {
                    description = "Permita que os jogadores paguem encomendas de peças com seu próprio dinheiro.",
                    label = "Pagamento com cartão próprio",
                },
                partsDeliveryTimeSeconds = {
                    description = "Segundos entre a encomenda de peças e a entrega tornando-se pronto.",
                    label = "Prazo de entrega",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Itens de inventário concedidos quando um conversor catalítico é roubado.",
                    label = "Item do conversor catalítico",
                },
                partsTheftDealerAccount = {
                    description = "Conta usada para pagamentos de revendedores de peças roubadas, como dinheiro ou banco.",
                    label = "Conta de pagamento do revendedor",
                },
                partsTheftDealerItems = {
                    description = "Itens roubados que o dealer comprará e seus valores de pagamento.",
                    itemLabel = "Item do distribuidor",
                    label = "Itens do revendedor",
                },
                partsTheftDealerPayoutItem = {
                    description = "Item de inventário dado quando o tipo de pagamento do dealer é Item. O preço de venda é usado como o valor do item.",
                    label = "Item de pagamento do revendedor",
                },
                partsTheftDealerPayoutType = {
                    description = "Escolha se o revendedor paga em uma conta-quadro ou dá um item de inventário.",
                    label = "Tipo de pagamento do revendedor",
                    options = {
                        account = "Conta",
                        item = "Objeto",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Distância máxima do dealer para vender peças roubadas.",
                    label = "Dealer vender distância",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Segundos antes que a mesma peça do veículo possa criar outro despacho.",
                    label = "Espera do despacho",
                },
                partsTheftDispatchEnabled = {
                    description = "Crie um despacho policial quando uma roda ou conversor catalítico é roubado.",
                    label = "Enviar despacho da polícia",
                },
                partsTheftDispatchJobs = {
                    description = "nomes de profissão que recebem despachos de roubo de peças.",
                    itemLabel = "Nome da profissão",
                    label = "Jobs de despacho",
                },
                partsTheftDispatchMessage = {
                    description = "Mensagem exibida no alerta de envio. Suporta {plate}, {part} e {type}.",
                    label = "Mensagem de envio",
                },
                partsTheftDispatchTitle = {
                    description = "Título mostrado no alerta de envio. Suporta {plate}, {part} e {type}.",
                    label = "Título de envio",
                },
                partsTheftItem = {
                    description = "Inventário usado para roubar rodas e conversores catalíticos.",
                    label = "item de ferramenta de roubo",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Remova o item da ferramenta de roubo após uma ação de roubo bem-sucedida.",
                    label = "Ferramenta de roubo de consumo",
                },
                partsTheftStolenWheelItem = {
                    description = "item de inventário concedido quando as rodas são roubadas.",
                    label = "Artigo de roda roubado",
                },
                priceType = {
                    description = "A porcentagem calcula os custos do preço do veículo. Fixo usa valores monetários. A classe do veículo usa a tabela de preços da classe.",
                    label = "Tipo de preço",
                    options = {
                        class = "Classe do veículo",
                        fixed = "Corrigido",
                        percentage = "Percentagem",
                    },
                },
                primaryColor = {
                    description = "Cor padrão para o grupo de profissão mecânica e novas profissões. Use um valor hexadecimal, como #EDC001.",
                    label = "Cor primária",
                },
                publicUsersSeePrices = {
                    description = "Quando habilitado, os clientes públicos pagam durante o pedido. Desabilite isso para criar pedidos não pagos para faturamento mecânico.",
                    label = "Cobrar ordens públicas de autoatendimento",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Permitir que os chefes autorizados comprem uma assinatura para toda a sua profissão usando fundos da empresa.",
                    label = "Subscrições da empresa",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Moeda de pagamento",
                },
                subscriptionsEnabled = {
                    description = "Ative assinaturas de oficinas, terminais de clientes e descontos por assinatura.",
                    label = "Ativado",
                },
                subscriptionsMaximumDurations = {
                    description = "Duração máxima e opções de preço por modelo de assinatura.",
                    label = "Duração máxima",
                },
                subscriptionsMaximumModels = {
                    description = "Modelos de assinatura máximos que uma oficina pode configurar no tablet.",
                    label = "Modelos máximos",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Clipe de animação em loop opcional usado quando o cenário está vazio.",
                    label = "clipe emote NPC",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Dicionário de animação opcional usado quando o cenário está vazio.",
                    label = "dicionário emote NPC",
                },
                subscriptionsNpcPedModel = {
                    description = "Modelo de Ped gerado em terminais de assinatura, por exemplo s_m_m_autoshop_01.",
                    label = "Modelo de NPC padrão",
                },
                subscriptionsNpcScenario = {
                    description = "Cenário GTA opcional, como WORLD_HUMAN_CLIPBOARD. Deixe vazio para usar a animação emote.",
                    label = "Cenário NPC",
                },
                tuningBlockedPlates = {
                    description = "Os veículos com uma dessas placas não podem ser ajustados, instalados ou ter o ajuste removido. A correspondência ignora o invólucro e o espaço em branco.",
                    itemLabel = "Matrícula",
                    label = "Placas de tuning bloqueadas",
                },
                tuningWorkshopDistance = {
                    description = "Distância máxima de um ponto de ajuste de autoatendimento para ações de instalação ou remoção necessárias.",
                    label = "Distância da exigência da oficina",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Exigir instalações de ordem de ajuste para iniciar e concluir perto de um ponto de ajuste de autoatendimento.",
                    label = "Exigir oficina para instalações",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Exigir remoções de ajuste para iniciar e concluir perto de um ponto de ajuste de autoatendimento.",
                    label = "Requer oficina para remoções",
                },
                vehicleCareRepairDurationMs = {
                    description = "Reparar a duração do progresso em milissegundos.",
                    label = "Duração da reparação",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Também redefinir danos realistas da roda ao usar a ação de reparo.",
                    label = "Corrigir danos realistas na roda",
                },
                vehicleCareRepairItem = {
                    description = "Inventário usado pela ação de reparo do veículo.",
                    label = "Item de reparação",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Distância máxima do veículo durante a reparação.",
                    label = "Reparar a distância máxima",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Remova o item de reparo após o uso.",
                    label = "Consuma item de reparo",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Reparar danos normais do veículo GTA ao usar a ação de reparo.",
                    label = "Corrigir danos no veículo",
                },
                vehicleCareRepairWearParts = {
                    description = "Escolha qual desgaste e peças de serviço o item de reparo restaura. Desabilite os fluidos aqui se o óleo, o líquido refrigerante, o fluido de freio ou o fluido de transmissão exigirem o fluxo de reparo de diagnóstico.",
                    itemLabel = "Parte de desgaste",
                    label = "Kit de reparação de peças restauradas",
                },
                vehicleCareWashItem = {
                    description = "item de inventário usado para lavar um veículo.",
                    label = "Item de lavagem",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Remova o item de lavagem após o uso.",
                    label = "Consumir item de lavagem",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "A distância de um veículo encerado permanece limpa.",
                    label = "Quilômetros limpos de cera",
                },
                vehicleCareWaxItem = {
                    description = "Inventário usado para encerar um veículo.",
                    label = "Item de cera",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Remova o item de cera após o uso.",
                    label = "Consumir item de cera",
                },
                vehicleClassPricing = {
                    description = "Sobreponha o tipo de preço e o multiplicador de custo para cada classe de veículo GTA.",
                    label = "Precificação da classe do veículo",
                },
                wearParts = {
                    description = "Peças de desgaste do veículo, sua distância vitalícia, item de reparo necessário, consumo de itens e fluxo de instalação.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Conversor catalítico",
                                fluid_refill = "Reabastecimento de fluidos",
                                hood_install = "Hood instalar",
                                oil_change = "Mudança de óleo",
                                performance = "Desempenho",
                                underbody_neon = "Underbody / elevador",
                                wheel = "Roda",
                            },
                        },
                    },
                    itemLabel = "Parte de desgaste",
                    label = "Peças de desgaste",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Multiplicador de danos da roda de base.",
                    label = "Multiplicador padrão",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Filtros pontos de sonda de deformação que não apontam de volta para o corpo do veículo.",
                    label = "Limiar do ângulo da sonda",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Força adicional adicionada a cada iteração de restauração.",
                    label = "Incremento de dano de deformação",
                },
                wheelDamageDeformationEnabled = {
                    description = "Capturar e restaurar dentaduras do corpo durante a geometria de reparo de pneus reconstrói.",
                    label = "Restaurar a deformação",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Força inicial usada ao restaurar dents.",
                    label = "Danos iniciais de deformação",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Máximo SetVehiclePassos de dano usados para reconstruir dents.",
                    label = "iterações de deformação",
                },
                wheelDamageDeformationThreshold = {
                    description = "Mínimo detectado magnitude de deformação para armazenar.",
                    label = "Limite de deformação",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplicador usado quando o veículo tem rodas off-road.",
                    label = "Multiplicador de roda off-road",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Extra instantânea não-roda dano restauração passa após a geometria da roda é reconstruída.",
                    label = "Dano reaplicar passa",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Passes instantâneos extras para pneus ainda em falta ou ainda planos após a reparação de uma roda.",
                    label = "Passes de reaplicação de estado de roda",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Mantenha o corpo, o motor, as janelas, as portas, a sujeira e os danos visuais quando o reparo do pneu reconstruir a geometria da roda.",
                    label = "Preservar danos no veículo",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Restaure janelas quebradas sem o efeito de quebra alto sempre que possível.",
                    label = "Janelas quebradas silenciosas",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Reaplique pneus ainda planos sem desencadear um novo som ou efeito pop de pneus.",
                    label = "Pneu furado silencioso reaplicar",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Distância máxima do pneu danificado ou em falta para a ação de montagem.",
                    label = "Distância de fixação do pneu",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Distância máxima do conector do carro colocado para a ação de remoção.",
                    label = "Jack carro remover a distância",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Multiplicadores de danos por classe de veículo GTA.",
                    itemLabel = "Classe do veículo",
                    label = "Multiplicadores de classe de veículos",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Bloquear outras profissões quando há mecânicos de serviço",
                },
                allowsprint = {
                    label = "Permitir correr com caixas de entrega",
                },
            },
            tuningCategories = {
                bodywork = "Carroçaria",
                electronics = "ECU e eletrónica do veículo",
                engineSounds = "Sons do motor",
                handling = "Condução",
                lights = "Iluminação",
                other = "Outros",
                paint = "Pintura",
                performance = "Desempenho",
                stance = "Postura",
                wheels = "Rodas",
            },
            advancedPricingPreview = {
                compact = "Honda / Compacto",
                customer = "Preço do cliente",
                description = "Exemplo de cálculo cosmético usando as regras atuais.",
                labor = "Trabalho",
                live = "Visualização ao vivo",
                margin = "Margem",
                sports = "Carro desportivo",
                super = "Supercar",
                supplier = "Fornecedor",
                title = "Previsão do preço",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configure jobs de mecanico, lojas, veiculos e locais de oficina.",
                    title = "Jobs de mecanico",
                },
            },
            dispatchIconOptions = {
                crime = "Unidade Criminal",
                emergency = "Unidade de Emergência",
                ems = "Unidade SME",
                fire = "Unidade de Fogo",
                heavy = "Unidade Pesada",
                k9 = "Unidade K-9",
                medical = "Unidade Médica",
                patrol = "Patrulha",
                rescue = "Unidade de Resgate",
                service = "Unidade de serviço",
                supervisor = "Supervisor",
                tactical = "Unidade tática",
            },
            fields = {
                quantity = "Quantidade",
            },
            settingFieldDescriptions = {
                radialEnabled = "Abra o faturamento mecânico a partir do menu radial.",
                allowTuningInvoices = "Envie a cesta de ajuste para o cliente mais próximo. A instalação desbloqueia após o pagamento total.",
                customerRange = "Distância máxima em metros para a emissão de faturas para clientes próximos.",
                allowAnalytics = "Permitir análises de faturamento, a menos que uma regra de nota a substitua.",
                allowCustomPrices = "Permita que os mecânicos editem os preços da posição da fatura antes de emitir.",
                allowEstimates = "Permitir estimativas que os clientes devem aceitar antes do pagamento.",
                allowImmediatePayment = "Permita que as faturas dessa profissão sejam pagas diretamente.",
                allowManualItems = "Permita que os mecânicos criem posições de fatura arbitrárias.",
                allowPartialPayments = "Permitir depósitos e pagamentos múltiplos para uma fatura.",
                analyticsPeriodDays = "Dias incluídos na análise de faturamento.",
                defaultDueDays = "Dias até que uma fatura se torne atrasada.",
                depositPercent = "Percentagem de depósito necessária após a emissão de uma fatura ou a aceitação de uma estimativa.",
                enabled = "Permita que essa profissão use o faturamento mecânico.",
                estimateLifetimeHours = "Horas antes de uma estimativa não respondida expirar.",
                gradeRules = "Limites de fatura e ações disponíveis para todos os graus mecânicos.",
                maxDiscountPercent = "Maior desconto que uma fatura pode receber.",
                maximumInvoiceAmount = "Total máximo global antes dos limites de classificação.",
                maximumManualItems = "Máximo de posições arbitrárias por documento.",
                maximumReminders = "Lembretes máximos permitidos por fatura.",
                minimumInvoiceAmount = "Total mínimo para estimativas e faturas.",
                minimumPartialPayment = "O menor pagamento parcial, excluindo um saldo ou depósito remanescente menor.",
                reminderFee = "Cada um deles, por sua vez, é um lembrete válido.",
                reminderGraceDays = "Dias antes do primeiro lembrete ser permitido.",
                taxPercent = "Imposto adicionado após descontos.",
            },
            settingFields = {
                radialEnabled = "Ação radial da fatura",
                allowTuningInvoices = "Clientes de ajuste de faturas",
                customerRange = "Distância do cliente",
                allowAnalytics = "Análise de contabilidade",
                allowCancellation = "Cancelamento",
                allowCustomPrices = "Permitir preços personalizados",
                allowEstimates = "Permitir estimativas",
                allowImmediatePayment = "Permitir o pagamento imediato",
                allowManualItems = "Permitir posições próprias",
                allowPartialPayments = "Permitir pagamentos parciais",
                allowReminders = "Lembretes",
                amount = "Quantidade",
                analyticsPeriodDays = "Período de análise",
                bone = "Ponto de fixação",
                category = "Categoria",
                classId = "Classe ID",
                defaultDueDays = "Prazo de pagamento (dias)",
                depositPercent = "% de depósito",
                difficulty = "Dificuldade",
                enabled = "Ativado",
                estimateLifetimeHours = "Tempo de vida estimado (horas)",
                flow = "Instale o fluxo",
                grade = "Nível",
                gradeRules = "Regras de classificação",
                item = "Objeto",
                key = "Chave",
                kilometersToZero = "Quilômetros a zero",
                label = "Etiqueta",
                laborFee = "Custo do trabalho",
                laborMultiplier = "Multiplicador de trabalho",
                marginAdjustmentPercent = "Ajustamento da margem",
                marginPercent = "Margem %",
                maxDiscountPercent = "Desconto máximo",
                maximumInvoiceAmount = "Fatura máxima",
                maximumManualItems = "Posições próprias máximas",
                maximumPrice = "Máximo",
                maximumReminders = "Máximo de lembretes",
                minimumInvoiceAmount = "Fatura mínima",
                minimumPartialPayment = "Pagamento parcial mínimo",
                minimumPrice = "Mínimo",
                multiplier = "Multiplicador",
                name = "Nome do item",
                partKey = "Chave de parte",
                price = "Preço",
                priceType = "Tipo de preço",
                prop = "Objeto",
                reason = "Motivo",
                reminderFee = "Taxa de lembrete",
                reminderGraceDays = "Período de carência do lembrete",
                removeAfterUse = "Consumir item",
                repair = "Reparação com kit",
                repairItem = "Item de reparação",
                rx = "Rot X",
                ry = "Rot Y",
                rz = "Rot Z",
                supplierSharePercent = "Fornecedor %",
                taxPercent = "Imposto sobre as facturas",
                transport = "Transporte",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Melhoria",
                maximumDiscountPercent = "Desconto máximo",
            },
            settingValues = {
                air_filter = "Filtro de ar",
                brake_fluid = "Fluido de freio",
                brake_pads = "Almofadas freio",
                catalytic_converter = "Catalisador",
                clutch = "Embreagem",
                coolant = "Refrigerante",
                engine_oil = "leo do motor",
                inverter = "Inversor de energia",
                spark_plugs = "Spark plugues",
                suspension = "Suspensão",
                traction_battery = "Bateria de tração",
                transmission_fluid = "Fluido de transmissão",
                tyres = "Pneus",
                vehicleClass_0 = "Compactos",
                vehicleClass_1 = "Sedans",
                vehicleClass_10 = "Industrial",
                vehicleClass_11 = "Utilidade",
                vehicleClass_12 = "Vans",
                vehicleClass_13 = "Ciclos",
                vehicleClass_14 = "Barcos",
                vehicleClass_15 = "Helicópteros",
                vehicleClass_16 = "Aviões",
                vehicleClass_17 = "Serviço",
                vehicleClass_18 = "Emergência",
                vehicleClass_19 = "Militares",
                vehicleClass_2 = "SUVs",
                vehicleClass_20 = "Comercial",
                vehicleClass_21 = "Comboios",
                vehicleClass_22 = "Roda aberta",
                vehicleClass_3 = "Coupes",
                vehicleClass_4 = "Músculo",
                vehicleClass_5 = "Clássicos Desportivos",
                vehicleClass_6 = "Esportes",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Motociclos",
                vehicleClass_9 = "Todo-o-terreno",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Permite que os funcionários se inscrevam em sessões de treinamento disponíveis.",
                approvalRequired = "Mantém as auto-inscrições pendentes até que um instrutor autorizado as aprove.",
                defaultCapacity = "Número por omissão de lugares utilizados quando é criada uma nova sessão de treino.",
                enabled = "Torna o aplicativo de treinamento disponível para este trabalho.",
                requireOnDuty = "Requer que os funcionários estejam de plantão antes de abrir ou usar o aplicativo de treinamento.",
                upcomingDays = "Número de dias futuros mostrados na programação do aplicativo de treinamento.",
            },
            trainingFields = {
                allowSelfEnrollment = "Permitir o auto- matrícula",
                approvalRequired = "Requer a aprovação da matrícula",
                defaultCapacity = "Capacidade por defeito",
                enabled = "Habilitar treinamento",
                requireOnDuty = "Requerer o direito",
                upcomingDays = "Próximo período (dias)",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Desativado",
                        [1] = "GTA Padrão",
                        [2] = "Estalos do escape em modo de rua",
                        [3] = "Corrida Anti-Lag",
                        [4] = "Rali Anti-Lag",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Perigos automáticos",
                    values = {
                        [0] = "Desligado",
                        [1] = "Ligado",
                    },
                },
                electronic_brake_lights = {
                    label = "Luzes de freio",
                    values = {
                        [0] = "Normal",
                        [1] = "Flash de emergência",
                        [2] = "Desligado",
                    },
                },
                electronic_engine_tune = {
                    label = "Software do motor",
                    values = {
                        [0] = "Estoque",
                        [1] = "Fase 1",
                        [2] = "Fase 2",
                        [3] = "Fase 3",
                        [4] = "Fase 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Brilho do farol",
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
                    label = "Vigas altas no chifre",
                    values = {
                        [0] = "Desligado",
                        [1] = "Ligado",
                    },
                },
                electronic_idle_rpm = {
                    label = "Ocioso RPM",
                    values = {
                        [0] = "Estoque",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Luz interior",
                    values = {
                        [0] = "Normal",
                        [1] = "Vermelho",
                    },
                },
                electronic_mood_color = {
                    label = "Cor clara do humor",
                    values = {
                        [0] = "Desligado",
                        [1] = "Vermelho",
                        [10] = "Limão",
                        [11] = "Turquesa",
                        [12] = "Indigo",
                        [13] = "Branco",
                        [14] = "Branco Quente",
                        [15] = "Branco Frio",
                        [16] = "Amber",
                        [2] = "Azul",
                        [3] = "Verde",
                        [4] = "Cyan",
                        [5] = "Magenta",
                        [6] = "Amarelo",
                        [7] = "Laranja",
                        [8] = "Roxo",
                        [9] = "Rosa",
                    },
                },
                electronic_mood_intensity = {
                    label = "Intensidade da luz do humor",
                    values = {
                        [0] = "Dim",
                        [1] = "Normal",
                        [2] = "Brilhante",
                    },
                },
                electronic_radio_power = {
                    label = "Rádio Potência",
                    values = {
                        [0] = "Desligado",
                        [1] = "Ligado",
                    },
                },
                electronic_throttle_response = {
                    label = "Resposta do acelerador",
                    values = {
                        [0] = "Mais Tração",
                        [1] = "Agressivo",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Ajuste para empinar",
                    values = {
                        [0] = "Desligado",
                        [1] = "Macio",
                        [2] = "Intenso",
                    },
                },
            },
            vehicleClassLabel = "Classe {id} ({name})",
        },
    },
}
