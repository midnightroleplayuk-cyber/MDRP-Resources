JobConfigLocales["sky_policejob:pt"] = {
    JobConfiguratorComingSoon = "Este configurador de emprego estará disponível em breve.",
    JobConfiguratorNoPermission = "Não tens permissão para usar este comando.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configura esquadras, lojas, acessórios, veículos, postos e definições das funcionalidades principais.",
                    title = "Empregos de Polícia",
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
                autoAlarm = "Atribui imediatamente unidades disponíveis correspondentes quando um incidente é criado.",
                available = "Unidades neste status podem ser sugeridas e atribuídas a um novo incidente.",
                averageResponseSpeedKmh = "Calcula a estimativa de chegada exibida a partir da distância em linha reta.",
                callsign = "Sinal único de chamada de rádio mostrado quando os jogadores equipam esta unidade virtual.",
                centerEnabled = "Permite que os membros de serviço autorizados sejam funcionários de um centro de expedição.",
                channelId = "ID de rádio para PMA Voice, SaltyChat e YACA. IDs numéricos como 2500 permanecem inalterados; PMA Voice mapeia IDs de texto para um número estável.",
                channelLabel = "Nome do canal legível mostrado para os expedidores e unidades.",
                crewCapacity = "Número máximo de pessoas que podem guarnecer a unidade. Use 0 para uma guarnição ilimitada.",
                defaultChannel = "Os expedidores entram neste canal quando iniciam o seu turno. As unidades se unem manualmente da aba Rádio. Selecione Nenhum para usar o grupo de tarefas padrão.",
                emergencyAppEnabled = "Torna este trabalho selecionável como serviço público no aplicativo de telefone de emergência.",
                enabled = "Torna este trabalho disponível para o aplicativo de distribuição e incidentes cruzados.",
                icon = "Selecione o ícone mostrado para esta categoria de unidade na Aplicação de Envio.",
                incidentAssessmentEnabled = "Mostra questões médicas e de avaliação de perigo na ingestão total de incidentes.",
                jobs = "Nomes de trabalhos adicionais que recebem incidentes usando esta palavra-chave.",
                joinLocked = "Impede a entrada de outras pessoas depois de a unidade estar guarnecida.",
                minimumCrew = "Número mínimo de pessoas nas unidades escolhidas para este plano de resposta.",
                noUnitFallback = "Sem um centro ou unidade de funcionários, envia uma notificação Sky para todos os membros em serviço.",
                poiId = "Identificador técnico estável que os perfis da central mantêm mesmo após o local ser renomeado.",
                radius = "Distância máxima em metros em que o anúncio da estação pode ser ouvido.",
                readyStatusCode = "Estado FMS aplicado quando o recurso fica disponível para despacho.",
                requirements = "Exigência de resposta como TIPO:COUNT pares, por exemplo PATROL:2,CRIME:1.",
                resourceType = "Classifica o recurso operacional para filtros e coordenação da central.",
                respondingStatusCode = "Estado FMS aplicado quando o recurso responde a uma ocorrência.",
                shortLabel = "Etiqueta curta opcional apresentada nas seis memórias de canais do rádio.",
                stationId = "Associa a unidade a uma estação configurada no perfil da central.",
                statusCode = "Estado numérico FMS mostrado no rádio portátil.",
                statusLabel = "Significado deste status FMS para expedidores e unidades.",
                unitId = "Identificador técnico estável que preserva a unidade mesmo quando o indicativo muda.",
                vehicleType = "Deve corresponder a um código de tipo de veículo configurado na subsecção anterior.",
                vehicleTypeCode = "Código unitário curto utilizado nos requisitos de resposta, por exemplo PATROL, CRIME, EMS ou RESCUE.",
                vehicleTypeLabel = "Nome legível desta categoria de unidade.",
            },
            dispatchFields = {
                address = "Endereço",
                autoAlarm = "Alarme automático",
                available = "Disponível para expedição",
                averageResponseSpeedKmh = "Velocidade de resposta estimada (km/h)",
                callsign = "Indicador de chamada",
                category = "Categoria",
                centerEnabled = "Habilitar centro de despacho",
                channelId = "ID do canal",
                code = "Código",
                crewCapacity = "Capacidade da guarnição",
                defaultChannel = "Canal de rádio padrão",
                emergencyAppEnabled = "Mostrar na aplicação de emergência",
                enabled = "Activar a expedição",
                icon = "Ícone",
                incidentAssessmentEnabled = "Activar a avaliação de emergência",
                jobs = "Trabalhos de destino (separados por vírgulas)",
                joinLocked = "Bloquear entrada na guarnição",
                keywordCode = "Código da palavra- chave",
                label = "Legenda",
                minimumCrew = "Guarnição mínima",
                name = "Nome",
                noUnitFallback = "Notificar o pessoal de serviço sem unidades",
                noneChannel = "Nenhum / grupo padrão",
                note = "Nota",
                phone = "Telefone",
                poiId = "ID estável do ponto de interesse",
                radius = "Raio de aviso",
                readyStatusCode = "Código de estado disponível",
                requirements = "Unidades necessárias (por exemplo PATROL:2,CRIME:1)",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado em resposta",
                shortLabel = "Etiqueta da memória do rádio",
                stationId = "ID da estação",
                type = "Tipo",
                unitId = "ID estável da unidade",
                vehicleType = "Tipo de unidade de resposta",
                radioButton = "Botão",
                radioButtonAction = "Ação Botão",
                radioButtonStatus = "FMS Estado",
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
            dispatchNavigation = {
                active = "Envio activo",
                description = "Configure os dados de entrada de emergência, rádio, unidades, planos de resposta, locais e repórteres para este trabalho.",
                inactive = "Desactivar a central",
                steps = {
                    accessText = "Activar o envio e decidir se este trabalho pode equipar um centro de envio.",
                    accessTitle = "Acesso e ingestão de emergência",
                    fleetText = "Configurar canais, códigos de estado FMS, tipos de veículos e sinais de chamadas.",
                    fleetTitle = "Rádio e frota",
                    responseText = "Termine com palavras-chave, requisitos de resposta e POIs.",
                    responseTitle = "Planos de resposta",
                },
                summary = {
                    channels = "Canais de rádio",
                    plans = "Planos de resposta",
                    reporters = "Comunicantes conhecidos",
                    statuses = "FMS disponível",
                    units = "Unidades virtuais",
                },
                title = "Envio",
                warnings = {
                    channels = "Não existem canais de rádio explícitos; o canal de retorno do grupo de tarefas será usado.",
                    defaultChannel = "O canal padrão selecionado já não existe.",
                    disabled = "A central está desactivada para este trabalho.",
                    statuses = "Pelo menos um status FMS deve estar disponível para que as unidades possam ser alarmadas.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Define os canais de rádio que unidades e centros de despacho pessoal podem participar.",
                dispatchKeywords = "Define palavras-chave incidentes, contagens de veículos necessárias, trabalhos participantes e opcional automático alarmante.",
                dispatchPois = "Armazena estações e locais comuns para formulários de incidentes e anúncios de estações baseados em posições.",
                dispatchReporters = "Gere nomes de comunicantes, números de retorno e notas da central próprios deste emprego.",
                dispatchStatusCodes = "Configura as etiquetas de status do FMS e quais status contam como disponíveis para novos incidentes.",
                dispatchVehicleTypes = "Define as categorias de unidades utilizadas pelos planos de resposta, tais como Patrulha, Unidade Criminal, EMS ou Resgate.",
                dispatchVehicles = "Define veículos de expedição virtual que podem ser com pessoal de qualquer lugar sem necessidade de um veículo gerado.",
                dispatchRadioButtons = "Define a ação predefinida centralmente para cada botão de função física.",
                dispatchRadioFmsKeys = "Atribui o status FMS às teclas de número físico. O teclado executa apenas FMS alterações.",
            },
            extensions = {
                caseNumbering = {
                    label = "Números de processo",
                    description = "Configura os números automáticos de processo para este trabalho.",
                    fields = {
                        prefix = {
                            label = "Prefixo do processo",
                            description = "Prefixo dos novos processos, como LSPD ou LSCSD. Até 16 caracteres, convertidos em maiúsculas; vazio usa CASE. Os números existentes e atribuídos manualmente permanecem inalterados.",
                        },
                    },
                },
                dispatchReporters = "Comunicantes conhecidos",
                invalidSelection = "Seleção inválida: {value}",
                trainingSettings = {
                    description = "Configure o acesso ao treinamento, inscrições, aprovações e planejamento de cursos para este trabalho.",
                    label = "Configuração do treino",
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
                dispatchRadioButtons = "Botões de função de rádio",
                dispatchRadioFmsKeys = "FMS atribuição chave",
            },
            features = {
                billing = {
                    description = "Ativa os fluxos de faturação da polícia.",
                    label = "Faturação",
                },
                devices = {
                    description = "Ativa dispositivos de aplicação da lei destacáveis.",
                    label = "CCTV e Radares de Velocidade",
                },
                evidence = {
                    description = "Ativa o armazenamento de provas, provas de campo e fluxos de scanner.",
                    label = "Provas",
                },
                impound = {
                    description = "Ativa os fluxos do depósito de reboque.",
                    label = "Reboque",
                },
                jail = {
                    description = "Ativa a atribuição de prisão e as atividades dos reclusos.",
                    label = "Prisão",
                },
                propPlacement = {
                    description = "Ativa acessórios policiais configuráveis e equipamento de acessórios de veículos.",
                    label = "Colocação de Acessórios",
                },
                radial = {
                    description = "Ativa ações radiais da polícia como o reboque e o cepo de roda.",
                    label = "Ações Radiais",
                },
                restraints = {
                    description = "Ativa algemas, braçadeiras, contenções de pernas e sacos de cabeça.",
                    label = "Contenções",
                },
                socialWork = {
                    description = "Ativa a atribuição de serviço comunitário e atividades de tarefas.",
                    label = "Serviço Comunitário",
                },
                tablet = {
                    description = "Ativa as aplicações do tablet policial configuradas por este recurso.",
                    label = "Tablet Policial",
                },
                tracking = {
                    description = "Ativa rastreadores GPS e monitores de tornozelo.",
                    label = "Rastreamento",
                },
                vehicleRadar = {
                    description = "Ativa o radar do veículo de patrulha.",
                    label = "Radar de Veículo",
                },
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
            settingFields = {
                gangMinimumGrade = "Patente mínima",
                gang = "Gangue",
                component = "Componente",
                description = "Descrição",
                fineAmount = "Valor da multa",
                itemName = "Nome do item",
                length = "Comprimento",
                max = "Máx",
                maxOverKmh = "Excesso máximo",
                min = "Mín",
                minOverKmh = "Excesso mínimo",
                model = "Modelo do acessório",
                propModel = "Modelo do acessório",
                reason = "Motivo",
                vehicleClass = "Classe",
            },
            settingGroups = {
                access = {
                    label = "Acesso",
                },
                animation = {
                    label = "Animação",
                },
                ankleMonitor = {
                    label = "Monitor de Tornozelo",
                },
                ankleMonitorAccess = {
                    label = "Acesso ao Monitor de Tornozelo",
                },
                ankleMonitorPlacement = {
                    label = "Colocação do Monitor de Tornozelo",
                },
                ankleMonitorZone = {
                    label = "Zona do Monitor de Tornozelo",
                },
                ankleMonitorZoneVisual = {
                    label = "Visuais da Zona do Monitor de Tornozelo",
                },
                assignment = {
                    label = "Atribuição",
                },
                blip = {
                    label = "Marcador da Esquadra",
                },
                carry = {
                    label = "Transporte",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Durabilidade de CCTV",
                },
                cctvPlacement = {
                    label = "Colocação de CCTV",
                },
                cctvRepair = {
                    label = "Reparação de CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animação de Reparação de CCTV",
                },
                clamp = {
                    label = "Cepo",
                },
                clampWeld = {
                    label = "Soldadura do Cepo",
                },
                cleanup = {
                    label = "Limpeza",
                },
                collection = {
                    label = "Recolha",
                },
                controls = {
                    label = "Controlos",
                },
                creator = {
                    label = "Criador",
                },
                crimeSceneTape = {
                    label = "Fita de cena do crime",
                },
                crimeSceneTapeAccess = {
                    label = "Acesso à fita",
                },
                crimeSceneTapeInventory = {
                    label = "Inventário da fita",
                },
                crimeSceneTapeLength = {
                    label = "Comprimento da fita",
                },
                crimeSceneTapePlacement = {
                    label = "Colocação da fita",
                },
                database = {
                    label = "Base de Dados",
                },
                delivery = {
                    label = "Entrega",
                },
                detection = {
                    label = "Deteção",
                },
                dispatch = {
                    label = "Despacho",
                },
                escape = {
                    label = "Fuga",
                },
                escort = {
                    label = "Escolta",
                },
                evidenceStorage = {
                    label = "Armazenamento de Provas",
                },
                fastLock = {
                    label = "Bloqueio Rápido Automático",
                },
                general = {
                    label = "Geral",
                },
                gpsTracker = {
                    label = "Rastreador GPS",
                },
                gpsTrackerAccess = {
                    label = "Acesso ao Rastreador GPS",
                },
                gpsTrackerPlacement = {
                    label = "Colocação do Rastreador GPS",
                },
                gpsTrackerTiming = {
                    label = "Tempos do Rastreador GPS",
                },
                handcuffs = {
                    label = "Algemas",
                },
                handsUp = {
                    label = "Mãos ao Ar",
                },
                header = {
                    label = "Cabeçalho",
                },
                impound = {
                    label = "Reboque",
                },
                imprisonment = {
                    label = "Encarceramento",
                },
                jailCanteenGeneral = {
                    label = "Cantina da Prisão",
                },
                jailCanteenPackage = {
                    label = "Pacote da Cantina da Prisão",
                },
                jailCarry = {
                    label = "Tarefa de Transporte",
                },
                jailCarryInspection = {
                    label = "Inspeção de Transporte",
                },
                jailCleaning = {
                    label = "Tarefa de Limpeza",
                },
                jailCleaningIllegalFinds = {
                    label = "Achados Ilegais",
                },
                jailCleaningOutline = {
                    label = "Contorno da Limpeza",
                },
                jailDoctor = {
                    label = "Médico da Prisão",
                },
                jailElectricalCodes = {
                    label = "Códigos Elétricos da Prisão",
                },
                jailElectricalGeneral = {
                    label = "Eletricidade da Prisão",
                },
                jailElectricalPenalties = {
                    label = "Penalizações Elétricas da Prisão",
                },
                jailElectricalRewards = {
                    label = "Recompensas Elétricas da Prisão",
                },
                jailInmatesAlcoholic = {
                    label = "Recluso Alcoólico",
                },
                jailInmatesCodeList = {
                    label = "Recluso Informador",
                },
                jailInmatesDrugDealer = {
                    label = "Recluso Traficante",
                },
                jailInmatesWireCutter = {
                    label = "Recluso Transportador de Ferramentas",
                },
                jailJobs = {
                    label = "Tarefas da Prisão",
                },
                jailOutfitFemale = {
                    label = "Roupa Feminina",
                },
                jailOutfitMale = {
                    label = "Roupa Masculina",
                },
                keybinds = {
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                    label = "Teclas",
                },
                keybindsHandcuff = {
                    label = "Atalho de Algemar",
                },
                keybindsUnhandcuff = {
                    label = "Atalho de Desalgemar",
                },
                marker = {
                    label = "Marcador",
                },
                markerColor = {
                    label = "Cor do Marcador",
                },
                mugshotAnimation = {
                    label = "Animação da Foto de Detido",
                },
                mugshotBoard = {
                    label = "Painel da Foto de Detido",
                },
                mugshotCameraCoords = {
                    label = "Posição da Câmara da Foto de Detido",
                },
                mugshotCameraRotation = {
                    label = "Rotação da Câmara da Foto de Detido",
                },
                mugshotGeneral = {
                    label = "Foto de Detido",
                },
                mugshotMetadata = {
                    label = "Metadados da Foto de Detido",
                },
                mugshotPosition = {
                    label = "Posição da Foto de Detido",
                },
                mugshotTiming = {
                    label = "Tempos da Foto de Detido",
                },
                officerDown = {
                    label = "Agente Abatido",
                },
                outfit = {
                    label = "Roupa",
                },
                overlay = {
                    label = "Sobreposição de Matrícula",
                },
                payment = {
                    label = "Pagamento",
                },
                paymentFlow = {
                    label = "Fluxo de Pagamento",
                },
                penalties = {
                    label = "Penalizações",
                },
                playerSearch = {
                    label = "Revista",
                },
                playerSearchAnimation = {
                    label = "Animação de Revista",
                },
                props = {
                    label = "Itens de Acessórios",
                },
                reasons = {
                    label = "Motivos",
                },
                release = {
                    label = "Levantamento",
                },
                restore = {
                    label = "Restauro",
                },
                rules = {
                    label = "Regras",
                },
                scan = {
                    label = "Digitalizar",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Pena",
                },
                shotsFired = {
                    label = "Disparos",
                },
                sound = {
                    label = "Som",
                },
                speedcam = {
                    label = "Radares de Velocidade",
                },
                speedcamBilling = {
                    label = "Faturação do Radar de Velocidade",
                },
                speedcamDispatch = {
                    label = "Despacho do Radar de Velocidade",
                },
                speedcamDurability = {
                    label = "Durabilidade do Radar de Velocidade",
                },
                speedcamPlacement = {
                    label = "Colocação do Radar de Velocidade",
                },
                speedcamRepair = {
                    label = "Reparação do Radar de Velocidade",
                },
                speedcamRepairAnimation = {
                    label = "Animação de Reparação do Radar de Velocidade",
                },
                speedcamTiming = {
                    label = "Tempos do Radar de Velocidade",
                },
                speedcamVisual = {
                    label = "Visuais do Radar de Velocidade",
                },
                speedcams = {
                    label = "Radares de Velocidade",
                },
                storage = {
                    label = "Armazenamento",
                },
                subscription = {
                    label = "Subscrição da Aplicação",
                },
                tasks = {
                    label = "Tarefas",
                },
                theme = {
                    label = "Tema",
                },
                timing = {
                    label = "Tempos",
                },
                warningUi = {
                    label = "Interface de Aviso",
                },
                world = {
                    label = "Mundo",
                },
                zipties = {
                    label = "Braçadeiras",
                },
                ziptiesCutter = {
                    label = "Corta-Braçadeiras",
                },
                cctvMotionDetection = {
                    label = "Deteção de movimento",
                },
                cctvMotionDispatch = {
                    label = "Despacho de detecção de movimento",
                },
                cctvMotionTiming = {
                    label = "Tempo de detecção de movimento",
                },
                display = {
                    label = "Visualização",
                },
                gsr = {
                    label = "GSR",
                },
                reports = {
                    label = "Relatórios",
                },
                speedcamAdvanced = {
                    label = "Câmera de velocidade avançada",
                },
                tackle = {
                    label = "Derrubar",
                },
                vin = {
                    label = "VIN Verificação",
                },
            },
            settingSections = {
                radarGun = "Pistola de radar",
                billing = "Faturação",
                cctv = "CCTV",
                dispatch = "Despacho",
                equipment = "Equipamento",
                evidence = "Provas",
                impound = "Reboque",
                jail = "Prisão",
                radar = "Radar de Veículo",
                radial = "Ações Radiais",
                restraints = "Contenções",
                socialWork = "Serviço Comunitário",
                speedCamera = "Radar de Velocidade",
                spikeStrips = "Tiras de Pregos",
                stations = "Esquadras",
                tablet = "Aplicações do Tablet",
                tracking = "Rastreamento",
                fakePlates = "Placas falsas",
                general = "Geral",
            },
            settingSubsections = {
                app = "Aplicação de Radar de Velocidade",
                apps = "Aplicações",
                billing = "Faturação",
                canteen = "Cantina da Prisão",
                dispatch = "Despacho",
                durability = "Durabilidade",
                electrical = "Eletricidade da Prisão",
                general = "Geral",
                handcuffs = "Algemas e abraçadeiras",
                inmates = "Reclusos",
                jobs = "Tarefas da Prisão",
                keybinds = "Teclas",
                motionDetection = "Deteção de movimento",
                mugshot = "Foto de Detido",
                placement = "Colocação",
                repair = "Reparação",
                timing = "Tempos",
                visuals = "Visuais",
            },
            settings = {
                radarGunClearKey = { label = "Pistola radar: Limpar leitura" },
                radarGunToggleUiKey = { label = "Pistola radar: Alternar interface" },
                radarGunNoTargetHoldMs = { label = "Tempo de retenção do alvo (ms)" },
                radarGunMinimumReading = { label = "Velocidade mínima apresentada" },
                radarGunSpeedSmoothing = { label = "Suavização da velocidade (0–1)" },
                radarGunBeamRadius = { label = "Raio do feixe (m)" },
                radarGunRefreshRateMs = { label = "Intervalo de medição (ms)" },
                radarGunUseMph = { label = "Usar MPH", description = "Apresenta as medições em milhas por hora em vez de quilómetros por hora." },
                radarGunRange = { label = "Alcance de medição", description = "Distância máxima em metros a que a pistola de radar deteta veículos." },
                radarGunRequireOnDuty = { label = "Exigir serviço", description = "Exige que os agentes estejam em serviço antes de medir veículos com a pistola de radar." },
                radarGunAllowedJobs = { label = "Trabalhos ou grupos permitidos", description = "police inclui todos os empregos policiais configurados; também aceita nomes diretos. Uma lista vazia remove as restrições de emprego.", itemLabel = "Emprego ou grupo" },
                radarGunEnabled = { label = "Pistola de radar", description = "Ativa a pistola de radar portátil SKY SR-2." },
                fakePlateVinAllowedGangs = {
                    label = "Gangues permitidas",
                    description = "Selecione nomes internos de gangues ou organizações independentes. Um emprego ou gangue correspondente concede a permissão ou isenção. O serviço é exigido apenas para empregos.",
                    itemLabel = "Gangue",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Patentes mínimas das gangues",
                    description = "Patentes mínimas opcionais. Uma lista vazia permite todas as patentes. Os requisitos de itens continuam válidos.",
                },

                speedCamProcessingMode = {
                    description = "Escolha cobrança imediata, pagamento no prazo configurado ou apenas análise policial.",
                    label = "Modo de processamento",
                    options = {
                        instant = "Cobrar imediatamente",
                        later = "Pagar depois (padrão)",
                        review = "Apenas análise policial",
                    },
                },
                tabletRegistry = { label = "Registo", description = "Ativar registos RP personalizados no File Explorer. Os processos de cidadãos e veículos continuam disponíveis separadamente." },
                tabletFiles = { label = "Explorador de ficheiros", description = "Agrupa os registos policiais no explorador de ficheiros. Os documentos do DOJ aparecem apenas quando o DOJ está ativo." },
                ankleMonitorAnimDurationMs = {
                    description = "Milissegundos gastos a aplicar um monitor de tornozelo.",
                    label = "Duração da aplicação",
                },
                ankleMonitorAnimScenario = {
                    description = "Cenário reproduzido ao aplicar um monitor de tornozelo.",
                    label = "Cenário de aplicação",
                },
                ankleMonitorAttachBone = {
                    description = "Osso do ped usado para fixar o acessório do monitor de tornozelo.",
                    label = "Osso de fixação",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Remove o item de monitor de tornozelo após a colocação.",
                    label = "Consumir monitor de tornozelo",
                },
                ankleMonitorCutItem = {
                    description = "Item de inventário usado para remover monitores de tornozelo.",
                    label = "Item de corte",
                },
                ankleMonitorEnabled = {
                    description = "Ativa a colocação de monitores de tornozelo.",
                    label = "Monitor de tornozelo",
                },
                ankleMonitorItem = {
                    description = "Item de inventário usado para colocar monitores de tornozelo.",
                    label = "Item do monitor de tornozelo",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Milissegundos entre atualizações do mapa do monitor de tornozelo.",
                    label = "Intervalo de atualização do mapa",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Mantém os monitores de tornozelo na base de dados quando os jogadores monitorizados se desligam, para serem restaurados após reconexões e reinícios do servidor.",
                    label = "Manter após desconexão",
                },
                ankleMonitorPlaceDistance = {
                    description = "Distância máxima para colocar um monitor de tornozelo.",
                    label = "Distância de colocação",
                },
                ankleMonitorPropModel = {
                    description = "Modelo de acessório usado para o visual do monitor de tornozelo.",
                    label = "Modelo do acessório",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Exige estado de serviço antes de usar monitores de tornozelo.",
                    label = "Monitor de tornozelo exige serviço",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Exige que o jogador esteja no grupo da polícia antes de usar monitores de tornozelo.",
                    label = "Monitor de tornozelo exige emprego policial",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Devolve o item de monitor de tornozelo quando é removido.",
                    label = "Devolver monitor de tornozelo ao remover",
                },
                ankleMonitorWarningSeconds = {
                    description = "Tempo de aviso antes de uma violação de zona do monitor de tornozelo ser despachada.",
                    label = "Segundos de aviso de zona",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Milissegundos entre sinais sonoros de aviso de zona do monitor de tornozelo.",
                    label = "Intervalo de sinal sonoro de zona",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Nome do som usado para os avisos de zona do monitor de tornozelo.",
                    label = "Som do sinal sonoro",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Conjunto de sons usado para os avisos de zona do monitor de tornozelo.",
                    label = "Conjunto de sons do sinal sonoro",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Valor de transparência usado para os marcadores de zona do monitor de tornozelo.",
                    label = "Transparência do marcador",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Cor do marcador usada quando um alvo está dentro da área permitida.",
                    label = "Cor do marcador permitido",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Cor do marcador usada quando um alvo sai da área permitida.",
                    label = "Cor do marcador excluído",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Milissegundos entre verificações de zona do monitor de tornozelo.",
                    label = "Intervalo de verificação de zona",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Segundos antes de outro despacho de zona do monitor de tornozelo poder ser enviado.",
                    label = "Tempo de espera do despacho de zona",
                },
                ankleMonitorZoneEnabled = {
                    description = "Ativa as verificações de zona do monitor de tornozelo.",
                    label = "Zonas do monitor de tornozelo",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Ícone do marcador usado para os marcadores de zona do monitor de tornozelo.",
                    label = "Ícone da etiqueta de zona",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Raio usado para os contornos de zona do monitor de tornozelo.",
                    label = "Raio do contorno",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Tamanho do passo usado para os contornos de zona do monitor de tornozelo.",
                    label = "Passo do contorno",
                },
                billingAccount = {
                    description = "Conta usada quando um emprego não tem conta de sociedade configurada.",
                    label = "Conta da sociedade de reserva",
                },
                billingCloseOnSuccess = {
                    description = "Fecha a interface de faturação depois de emitir uma fatura.",
                    label = "Fechar após sucesso",
                },
                billingCurrency = {
                    description = "Chave de moeda usada para a faturação. Deixa em branco para usar a moeda predefinida.",
                    label = "Moeda",
                },
                billingCustomReasons = {
                    description = "Permite motivos de faturação personalizados em vez de apenas predefinições.",
                    label = "Motivos personalizados",
                },
                billingDepositToSociety = {
                    description = "Deposita a receita da faturação na conta da sociedade do emprego.",
                    label = "Depositar na sociedade",
                },
                billingMaxReasonLength = {
                    description = "Número máximo de caracteres para motivos de faturação personalizados.",
                    label = "Comprimento do motivo",
                },
                billingMode = {
                    description = "Escolhe se as faturas da polícia cobram instantaneamente, exigem confirmação do cidadão, ou usam o sistema de faturação da framework.",
                    label = "Modo de faturação",
                    options = {
                        consent = "Pagar ou recusar",
                        framework = "Fatura da framework",
                        instant = "Cobrança instantânea",
                    },
                },
                billingRange = {
                    description = "Distância máxima ao alvo para emitir faturas policiais.",
                    label = "Distância de faturação",
                },
                billingReasonPresets = {
                    description = "Motivos de faturação predefinidos mostrados na interface de faturação.",
                    itemLabel = "Motivo",
                    label = "Motivos predefinidos",
                },
                billingRefreshSeconds = {
                    description = "Intervalo de atualização do alvo enquanto a interface de faturação está aberta.",
                    label = "Segundos de atualização",
                },
                billingShowRecipientName = {
                    description = "Mostra o nome do cidadão nas pré-visualizações e recibos de multas.",
                    label = "Mostrar nome do destinatário",
                },
                carryAllowCarrierInVehicle = {
                    description = "Permite ao transportador entrar e conduzir um veículo sem largar o jogador.",
                    label = "Permitir transportador no veículo",
                },
                carryAllowConscious = {
                    description = "Permite transportar alvos conscientes.",
                    label = "Transportar alvos conscientes",
                },
                carryAllowSprint = {
                    description = "Permite correr enquanto transporta outro jogador.",
                    label = "Permitir correr ao transportar",
                },
                carryEnabled = {
                    description = "Ativa o transporte de jogadores.",
                    label = "Transporte",
                },
                carryMaxDistance = {
                    description = "Distância máxima para começar a transportar um jogador.",
                    label = "Distância de transporte",
                },
                carryRequireOnDuty = {
                    description = "Exige estado de serviço antes de começar a transportar.",
                    label = "Transporte exige serviço",
                },
                cctvDamageCooldownMs = {
                    description = "Milissegundos antes do dano à CCTV poder ser aplicado novamente.",
                    label = "Tempo de espera de dano",
                },
                cctvDamagePerHit = {
                    description = "Dano de durabilidade aplicado às câmaras CCTV por impacto.",
                    label = "Dano por impacto",
                },
                cctvDefaultName = {
                    description = "Nome de exibição padrão para as câmaras CCTV destacadas.",
                    label = "Nome padrão de CCTV",
                },
                cctvDefaultPitch = {
                    description = "Inclinação padrão da câmara para a colocação de CCTV.",
                    label = "Inclinação padrão",
                },
                cctvDisassembleDistance = {
                    description = "Distância usada para desmontar câmaras CCTV.",
                    label = "Distância de desmontagem",
                },
                cctvEnabled = {
                    description = "Ativa a colocação e transmissão de câmaras CCTV.",
                    label = "Câmaras CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Distância à qual a durabilidade da CCTV é mostrada.",
                    label = "Distância de exibição da durabilidade",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Milissegundos durante os quais a durabilidade da CCTV permanece visível.",
                    label = "Duração de exibição da durabilidade",
                },
                cctvHealthTextOffset = {
                    description = "Deslocamento vertical usado para o texto de durabilidade da CCTV.",
                    label = "Deslocamento do texto de durabilidade",
                },
                cctvHeightStep = {
                    description = "Passo de altura usado ao posicionar câmaras CCTV.",
                    label = "Passo de altura",
                },
                cctvItem = {
                    description = "Item de inventário usado para colocar câmaras CCTV.",
                    label = "Item de CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Limiar de durabilidade a partir do qual se recomenda a manutenção da CCTV.",
                    label = "Limiar de manutenção",
                },
                cctvMaxDurability = {
                    description = "Durabilidade máxima da câmara CCTV.",
                    label = "Durabilidade de CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Segundos antes de uma câmara poder criar outro despacho de movimento.",
                    label = "Espera do despacho",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Milissegundos entre análises de movimento do cliente.",
                    label = "Intervalo de análise",
                },
                cctvMotionClientCooldownMs = {
                    description = "Milissegundos antes de um cliente poder reportar novamente a mesma câmara.",
                    label = "Espera do relatório do cliente",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Ativa automaticamente alertas de movimento em câmaras CCTV recém-colocadas.",
                    label = "Ativar novas câmaras por predefinição",
                },
                cctvMotionDetectionEnabled = {
                    description = "Ativa alertas de despacho de deteção de movimento por câmara CCTV.",
                    label = "Alertas de movimento",
                },
                cctvMotionDetectionRadius = {
                    description = "Distância máxima de deteção de movimento em metros.",
                    label = "Raio de deteção",
                },
                cctvMotionFieldOfView = {
                    description = "Ângulo do cone de deteção de movimento em graus.",
                    label = "Campo de visão",
                },
                cctvMotionJobs = {
                    description = "Nomes de empregos ou grupos que recebem despachos de movimento CCTV.",
                    itemLabel = "Emprego ou grupo",
                    label = "Empregos do despacho",
                },
                cctvMotionMinimumSpeed = {
                    description = "Velocidade mínima de uma entidade em metros por segundo para contar como movimento.",
                    label = "Velocidade mínima de movimento",
                },
                cctvMoveStep = {
                    description = "Passo de movimento usado ao posicionar câmaras CCTV.",
                    label = "Passo de movimento",
                },
                cctvPropModel = {
                    description = "Modelo de acessório usado para as câmaras CCTV destacadas.",
                    label = "Modelo do acessório de CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Dicionário de animação usado ao reparar câmaras CCTV.",
                    label = "Dicionário de animação de reparação",
                },
                cctvRepairAnimFlag = {
                    description = "Flag de animação usada ao reparar câmaras CCTV.",
                    label = "Flag da animação de reparação",
                },
                cctvRepairAnimName = {
                    description = "Nome da animação usado ao reparar câmaras CCTV.",
                    label = "Nome da animação de reparação",
                },
                cctvRepairCancelDelayMs = {
                    description = "Milissegundos antes da reparação de CCTV poder ser cancelada.",
                    label = "Atraso de cancelamento da reparação",
                },
                cctvRepairDistance = {
                    description = "Distância usada para reparar câmaras CCTV.",
                    label = "Distância de reparação",
                },
                cctvRepairItem = {
                    description = "Item de inventário usado para reparar câmaras CCTV.",
                    label = "Item de reparação",
                },
                cctvRepairPerTick = {
                    description = "Durabilidade restaurada por cada ciclo de reparação de CCTV.",
                    label = "Reparação por ciclo",
                },
                cctvRepairTickMs = {
                    description = "Milissegundos entre ciclos de reparação de CCTV.",
                    label = "Intervalo de reparação",
                },
                cctvRotateStep = {
                    description = "Passo de rotação usado ao posicionar câmaras CCTV.",
                    label = "Passo de rotação",
                },
                cctvStreamDistance = {
                    description = "Distância usada para carregar câmaras CCTV.",
                    label = "Distância de carregamento",
                },
                cctvViewOffset = {
                    description = "Deslocamento de vista usado para a renderização em direto da câmara CCTV.",
                    label = "Deslocamento da vista",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Cria uma barreira de colisão ao longo da fita para impedir que os jogadores a atravessem.",
                    label = "Colisão de bloqueio da fita",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Remove um item de fita do inventário após uma colocação bem-sucedida.",
                    label = "Consumir item da fita",
                },
                crimeSceneTapeDynamic = {
                    description = "Permite que a fita reaja à física e à gravidade em vez de ficar fixa no local.",
                    label = "Física dinâmica",
                },
                crimeSceneTapeEnabled = {
                    description = "Permite colocar fita de cena do crime usando um item do inventário.",
                    label = "Fita de cena do crime",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Apenas empregos autorizados podem remover a fita e, quando exigido, os seus membros devem estar em serviço.",
                    label = "Restringir remoção",
                },
                crimeSceneTapeItem = {
                    description = "Nome do item de inventário que inicia a colocação da fita de cena do crime.",
                    label = "Item da fita",
                },
                crimeSceneTapeJobs = {
                    description = "Nomes dos empregos autorizados a usar a fita de cena do crime.",
                    itemLabel = "Emprego",
                    label = "Empregos autorizados",
                },
                crimeSceneTapeLabel = {
                    description = "Nome apresentado para a fita de cena do crime durante a colocação.",
                    label = "Rótulo da fita",
                },
                crimeSceneTapeLengthStep = {
                    description = "Incremento em metros ao qual o comprimento selecionado da fita é arredondado.",
                    label = "Incremento do comprimento",
                },
                crimeSceneTapeMaxLength = {
                    description = "Distância máxima permitida entre os dois postes da fita, em metros.",
                    label = "Comprimento máximo da fita",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Distância máxima de qualquer ponto final ao agente que coloca a fita.",
                    label = "Distância máxima de colocação",
                },
                crimeSceneTapeMinLength = {
                    description = "Distância mínima permitida entre os dois postes da fita, em metros.",
                    label = "Comprimento mínimo da fita",
                },
                crimeSceneTapeModel = {
                    description = "Nome do modelo de objeto usado para a fita de cena do crime colocada.",
                    label = "Modelo da fita",
                },
                crimeSceneTapePostModel = {
                    description = "Modelo do acessório utilizado para ambos os postes da fita.",
                    label = "Modelo do poste",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Distância máxima a partir da qual a fita de cena do crime colocada pode ser removida.",
                    label = "Distância de remoção",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Apenas membros em serviço dos empregos autorizados podem colocar a fita.",
                    label = "Exigir serviço",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Devolve o item consumido quando a fita colocada é removida.",
                    label = "Devolver item ao remover",
                },
                crimeSceneTapeSag = {
                    description = "Folga máxima da fita para baixo entre os postes, em metros.",
                    label = "Folga da fita",
                },
                crimeSceneTapeSections = {
                    description = "Modelos nativos das secções da fita utilizados para compor o comprimento selecionado.",
                    itemLabel = "Secção da fita",
                    label = "Secções da fita",
                },
                crimeSceneTapeShowPosts = {
                    description = "Cria postes de suporte visíveis em ambas as extremidades da fita de cena do crime de comprimento variável.",
                    label = "Mostrar postes da fita",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Distância dentro da qual a fita de cena do crime colocada é carregada.",
                    label = "Distância de carregamento",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Altura da fita acima dos pontos do solo selecionados.",
                    label = "Altura da fita",
                },
                crimeSceneTapeVariableLength = {
                    description = "Permite aos agentes definir um ponto inicial e final para colocar a fita com um comprimento ajustável.",
                    label = "Comprimento variável da fita",
                },
                crimeSceneTapeZOffset = {
                    description = "Deslocamento vertical aplicado ao colocar o modelo da fita.",
                    label = "Deslocamento vertical",
                },
                cuffsAnimDict = {
                    description = "Dicionário de animação usado para jogadores contidos.",
                    label = "Dicionário de animação",
                },
                cuffsAnimFlag = {
                    description = "Flag de animação usada para jogadores contidos.",
                    label = "Flag da animação",
                },
                cuffsAnimName = {
                    description = "Nome da animação usado para jogadores contidos.",
                    label = "Nome da animação",
                },
                cuffsConsumeItem = {
                    description = "Remove o item de algemas quando as algemas são aplicadas.",
                    label = "Consumir algemas",
                },
                cuffsEnabled = {
                    description = "Ativa as ações de algemar.",
                    label = "Algemas",
                },
                cuffsEscapeEnabled = {
                    description = "Ativa o minijogo de fuga das algemas.",
                    label = "Fuga das algemas",
                },
                cuffsEscapeKeyPool = {
                    description = "Teclas que podem aparecer no minijogo de fuga das algemas.",
                    itemLabel = "Tecla",
                    label = "Conjunto de teclas de fuga",
                },
                cuffsEscapeRounds = {
                    description = "Número de rondas exigidas no minijogo de fuga das algemas.",
                    label = "Rondas de fuga",
                },
                cuffsEscapeWindowMs = {
                    description = "Milissegundos permitidos por janela de entrada da fuga das algemas.",
                    label = "Janela de fuga",
                },
                cuffsHandsUpEnabled = {
                    description = "Ativa o estado de mãos ao ar usado por algemas e braçadeiras.",
                    label = "Mãos ao ar",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Segundos que a tecla de mãos ao ar deve ser mantida antes da ativação.",
                    label = "Segundos a manter mãos ao ar",
                },
                cuffsHandsUpKey = {
                    description = "Tecla do teclado usada para levantar as mãos.",
                    label = "Tecla de mãos ao ar",
                },
                cuffsItem = {
                    description = "Item de inventário usado para as ações de algemar.",
                    label = "Item de algemas",
                },
                cuffsMaxDistance = {
                    description = "Distância máxima ao alvo para as ações de algemar.",
                    label = "Distância de algemar",
                },
                cuffsRequireItem = {
                    description = "Exige o item de algemas configurado.",
                    label = "Algemas exigem item",
                },
                cuffsRequireOnDuty = {
                    description = "Exige estado de serviço antes de algemar.",
                    label = "Algemas exigem serviço",
                },
                cuffsReturnOnRemove = {
                    description = "Devolve o item de algemas quando as algemas são removidas.",
                    label = "Devolver algemas",
                },
                dispatchOfficerDownEnabled = {
                    description = "Envia um alerta de despacho quando um agente em serviço é abatido.",
                    label = "Alertas de agente abatido",
                },
                dispatchOfficerDownJobs = {
                    description = "Empregos que devem receber despachos de agente abatido.",
                    itemLabel = "Emprego",
                    label = "Empregos de agente abatido",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Notifica apenas jogadores que estão atualmente em serviço.",
                    label = "Agente abatido exige serviço",
                },
                dispatchShotsFiredChance = {
                    description = "Probabilidade de 0.0 a 1.0 de um disparo detetado criar um alerta.",
                    label = "Probabilidade de alerta",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Segundos antes do mesmo jogador poder acionar outro alerta de disparos.",
                    label = "Tempo de espera de disparos",
                },
                dispatchShotsFiredEnabled = {
                    description = "Ativa os alertas de despacho de disparos.",
                    label = "Alertas de disparos",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Armas que não devem acionar alertas de disparos.",
                    itemLabel = "Arma",
                    label = "Armas ignoradas",
                },
                dispatchShotsFiredJobs = {
                    description = "Empregos que devem receber despachos de disparos.",
                    itemLabel = "Emprego",
                    label = "Empregos de disparos",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Notifica apenas jogadores que estão atualmente em serviço.",
                    label = "Disparos exigem serviço",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Cria entradas de despacho quando são detetados disparos.",
                    label = "Enviar despacho de disparos",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Probabilidade de 0.0 a 1.0 de um disparo com silenciador detetado criar um alerta.",
                    label = "Probabilidade de alerta com silenciador",
                },
                escortEnabled = {
                    description = "Ativa a escolta de jogadores.",
                    label = "Escolta",
                },
                escortMaxDistance = {
                    description = "Distância máxima para começar a escoltar um jogador.",
                    label = "Distância de escolta",
                },
                escortRequireOnDuty = {
                    description = "Exige estado de serviço antes de escoltar jogadores.",
                    label = "Escolta exige serviço",
                },
                escortVehicleDistance = {
                    description = "Distância máxima para colocar um jogador escoltado num veículo.",
                    label = "Distância de veículo da escolta",
                },
                evidenceBloodDamageThreshold = {
                    description = "Limiar mínimo de dano antes de criar provas de sangue.",
                    label = "Limiar de dano de sangue",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Milissegundos antes de outra cápsula poder ser criada.",
                    label = "Tempo de espera de cápsulas",
                },
                evidenceCasingMergeRadius = {
                    description = "Raio usado para fundir cápsulas próximas.",
                    label = "Raio de fusão de cápsulas",
                },
                evidenceCleanupIntervalMs = {
                    description = "Milissegundos entre passagens de limpeza de provas.",
                    label = "Intervalo de limpeza",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Segundos antes das provas de campo expirarem automaticamente.",
                    label = "TTL de limpeza",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Produto de limpeza para todos",
                    description = "Permitir que todos removam vestígios com peróxido de hidrogénio. Desative para usar as listas de empregos e gangues.",
                },
                evidenceCleanerJobs = {
                    label = "Empregos do produto de limpeza",
                    description = "Nomes internos permitidos sem acesso público. Um emprego ou gangue correspondente permite o acesso; listas vazias recusam-no.",
                    itemLabel = "Emprego",
                },
                evidenceCleanerGangs = {
                    label = "Gangues do produto de limpeza",
                    description = "Nomes internos permitidos sem acesso público. Um emprego ou gangue correspondente permite o acesso; listas vazias recusam-no.",
                    itemLabel = "Gangue",
                },
                evidenceCollectDistance = {
                    description = "Distância usada para recolher provas de campo.",
                    label = "Distância de recolha",
                },
                evidenceDiscoverDistance = {
                    description = "Distância usada para detetar marcadores de provas próximos.",
                    label = "Distância de deteção",
                },
                evidenceFieldEnabled = {
                    description = "Ativa a criação e recolha de provas no terreno.",
                    label = "Provas de campo",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Arma usada para inspecionar e revelar provas no terreno.",
                    label = "Arma de lanterna",
                },
                evidenceGloveFreeHands = {
                    description = "IDs de componentes de mãos tratados como sem luvas.",
                    label = "Mãos sem luvas",
                },
                evidenceMarkerColor = {
                    description = "Cor RGBA usada para os marcadores de provas de campo.",
                    label = "Cor do marcador",
                },
                evidenceMarkerDrawDistance = {
                    description = "Distância de desenho usada para os marcadores de provas de campo.",
                    label = "Distância de desenho",
                },
                evidenceMarkerOffset = {
                    description = "Deslocamento vertical do marcador usado para as provas de campo.",
                    label = "Deslocamento",
                },
                evidenceMarkerScaleX = {
                    description = "Escala X do marcador usada para as provas de campo.",
                    label = "Escala X",
                },
                evidenceMarkerScaleY = {
                    description = "Escala Y do marcador usada para as provas de campo.",
                    label = "Escala Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Escala Z do marcador usada para as provas de campo.",
                    label = "Escala Z",
                },
                evidenceMarkerType = {
                    description = "Tipo de marcador usado para as provas de campo.",
                    label = "Tipo de marcador",
                },
                evidenceMaxCreateDistance = {
                    description = "Distância máxima para criar registos de provas.",
                    label = "Distância de criação",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Milissegundos permitidos para o consentimento da amostra de saliva.",
                    label = "Tempo limite de consentimento de saliva",
                },
                evidenceScannerDistance = {
                    description = "Distância usada para as interações do scanner de provas.",
                    label = "Distância do scanner",
                },
                evidenceScannerDurationMs = {
                    description = "Duração da ação de impressão digital/scanner em milissegundos.",
                    label = "Duração do scanner",
                },
                evidenceStorageMaxCompartments = {
                    description = "Número máximo de compartimentos de armazenamento de provas.",
                    label = "Compartimentos de armazenamento",
                },
                gpsTrackerBeepDistance = {
                    description = "Distância a partir da qual o feedback sonoro do rastreador GPS se torna relevante.",
                    label = "Distância do sinal sonoro",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Milissegundos entre sinais sonoros quando longe de um rastreador.",
                    label = "Intervalo de sinal distante",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Milissegundos entre sinais sonoros quando próximo de um rastreador.",
                    label = "Intervalo de sinal próximo",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Remove o item de rastreador após a colocação.",
                    label = "Consumir rastreador GPS",
                },
                gpsTrackerEnabled = {
                    description = "Ativa a colocação e digitalização de rastreadores GPS em veículos.",
                    label = "Rastreador GPS",
                },
                gpsTrackerItem = {
                    description = "Item de inventário usado para colocar rastreadores GPS.",
                    label = "Item do rastreador",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Milissegundos entre atualizações do mapa do rastreador.",
                    label = "Intervalo de atualização do mapa",
                },
                gpsTrackerPlaceDistance = {
                    description = "Distância máxima para colocar um rastreador GPS num veículo.",
                    label = "Distância de colocação",
                },
                gpsTrackerRemoveDistance = {
                    description = "Distância máxima para remover um rastreador GPS colocado.",
                    label = "Distância de remoção",
                },
                gpsTrackerRemoveKey = {
                    description = "Código de controlo usado para remover um rastreador GPS colocado.",
                    label = "Tecla de remoção",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Exige estado de serviço antes de usar rastreadores GPS.",
                    label = "GPS exige serviço",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Exige que o jogador esteja no grupo da polícia antes de usar rastreadores GPS.",
                    label = "GPS exige emprego policial",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Devolve o item de rastreador quando é removido.",
                    label = "Devolver rastreador ao remover",
                },
                gpsTrackerScanDistance = {
                    description = "Distância máxima para procurar rastreadores.",
                    label = "Distância de digitalização GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Milissegundos gastos a procurar um rastreador GPS.",
                    label = "Duração da digitalização",
                },
                gpsTrackerScannerWeapon = {
                    description = "Arma ou ferramenta usada para procurar rastreadores GPS.",
                    label = "Arma de digitalização",
                },
                impoundAccount = {
                    description = "Conta usada para cobrar os levantamentos de reboque.",
                    label = "Conta de pagamento",
                },
                impoundCreatorVehicleModel = {
                    description = "Modelo de veículo mostrado na pré-visualização do criador de reboque.",
                    label = "Modelo de veículo do criador",
                },
                impoundCustomGarageEnabled = {
                    description = "Usa uma interface de reboque de garagem personalizada quando disponível.",
                    label = "Reboque de garagem personalizado",
                },
                impoundDefaultPrice = {
                    description = "Preço padrão de levantamento de reboque.",
                    label = "Preço padrão",
                },
                impoundDeliveryDistance = {
                    description = "Distância usada para as interações de entrega de reboque.",
                    label = "Distância de entrega",
                },
                impoundDeliveryMarker = {
                    description = "Configuração de marcador usada para as entregas de reboque.",
                    label = "Marcador de entrega",
                },
                impoundEnabled = {
                    description = "Ativa os fluxos de reboque.",
                    label = "Reboque",
                },
                impoundMarker = {
                    description = "Configuração de marcador usada para as interações de reboque.",
                    label = "Marcador de reboque",
                },
                impoundRadialEnabled = {
                    description = "Ativa as ações radiais de reboque.",
                    label = "Ação de reboque",
                },
                impoundRadialRequireOnDuty = {
                    description = "Exige estado de serviço antes de usar a ação radial de reboque.",
                    label = "Reboque exige serviço",
                },
                impoundRadialVehicleDistance = {
                    description = "Distância máxima ao veículo alvo para as ações radiais de reboque.",
                    label = "Distância do veículo a rebocar",
                },
                impoundReleaseDistance = {
                    description = "Distância usada para as interações de levantamento de reboque.",
                    label = "Distância de levantamento",
                },
                impoundReleaseKey = {
                    description = "Código de controlo usado para levantar veículos rebocados.",
                    label = "Tecla de levantamento",
                },
                impoundRequireDelivery = {
                    description = "Exige a entrega num depósito de reboque configurado.",
                    label = "Exigir entrega",
                },
                impoundStorageBasePrice = {
                    description = "Preço base de levantamento dos veículos rebocados armazenados.",
                    label = "Preço base do armazenamento",
                },
                impoundStorageDailyFee = {
                    description = "Taxa adicional de armazenamento de reboque por dia configurado.",
                    label = "Taxa diária de armazenamento",
                },
                impoundStorageDaySeconds = {
                    description = "Quantos segundos contam como um dia de faturação de armazenamento.",
                    label = "Segundos de dia de armazenamento",
                },
                impoundStorageEnabled = {
                    description = "Ativa o tratamento de armazenamento pago do reboque.",
                    label = "Armazenamento de reboque",
                },
                jailAssignRange = {
                    description = "Distância máxima para atribuir um alvo à prisão.",
                    label = "Distância de atribuição",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minutos que um recluso deve esperar antes de reclamar outro pacote da cantina.",
                    label = "Minutos de tempo de espera",
                },
                jailCanteenPackage = {
                    description = "Itens concedidos pelo pacote da cantina da prisão.",
                    label = "Pacote da cantina",
                },
                jailCellStreamDistance = {
                    description = "Distância usada para o carregamento de acessórios da cela de isolamento.",
                    label = "Distância de carregamento da cela",
                },
                jailClearInventory = {
                    description = "Limpa o inventário do jogador ao enviá-lo para a prisão.",
                    label = "Limpar inventário",
                },
                jailDefaultMonths = {
                    description = "Duração de prisão padrão ao abrir a interface de atribuição.",
                    label = "Meses padrão",
                },
                jailDispatchJobs = {
                    description = "Empregos que devem receber despachos de prisão.",
                    itemLabel = "Emprego",
                    label = "Empregos de despacho",
                },
                jailDoctorHealEvent = {
                    description = "Evento de servidor ou cliente acionado quando o médico da prisão cura um recluso.",
                    label = "Evento de cura",
                },
                jailElectricalCodeListItem = {
                    description = "Item de inventário exigido para revelar os códigos elétricos gerados.",
                    label = "Item da lista de códigos",
                },
                jailElectricalCodeMax = {
                    description = "Valor máximo do código aleatório para a caixa elétrica.",
                    label = "Código máximo",
                },
                jailElectricalCodeMin = {
                    description = "Valor mínimo do código aleatório para a caixa elétrica.",
                    label = "Código mínimo",
                },
                jailElectricalCodesCount = {
                    description = "Quantos códigos candidatos são gerados para a caixa elétrica.",
                    label = "Número de códigos",
                },
                jailElectricalEnabled = {
                    description = "Ativa o minijogo de fuga elétrica da prisão.",
                    label = "Caixa elétrica",
                },
                jailElectricalPinLength = {
                    description = "Número de dígitos usados para os códigos PIN da caixa elétrica.",
                    label = "Comprimento do PIN",
                },
                jailElectricalPropModel = {
                    description = "Modelo de acessório do mundo usado para a caixa elétrica da prisão.",
                    label = "Modelo do acessório",
                },
                jailElectricalShockDamage = {
                    description = "Dano causado quando um recluso falha a sequência elétrica.",
                    label = "Dano de choque",
                },
                jailElectricalShockRagdollMs = {
                    description = "Milissegundos de queda após um choque elétrico.",
                    label = "Queda por choque",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Minutos de pena removidos após uma tentativa de fuga elétrica bem-sucedida.",
                    label = "Minutos de redução por sucesso",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Quantidade necessária para a troca com o recluso alcoólico.",
                    label = "Quantidade necessária",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Item necessário para a troca com o recluso alcoólico.",
                    label = "Item necessário",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Quantidade de recompensa para a troca com o recluso alcoólico.",
                    label = "Quantidade de recompensa",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Item de recompensa para a troca com o recluso alcoólico.",
                    label = "Item de recompensa",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para a troca com o recluso alcoólico.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Quantidade necessária para a troca com o recluso informador.",
                    label = "Quantidade necessária",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Item necessário para a troca com o recluso informador.",
                    label = "Item necessário",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Quantidade de recompensa para a troca com o recluso informador.",
                    label = "Quantidade de recompensa",
                },
                jailInmateCodeListRewardItem = {
                    description = "Item de recompensa para a troca com o recluso informador.",
                    label = "Item de recompensa",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para a troca com o recluso informador.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Itens aceites para a troca com o recluso traficante.",
                    label = "Itens aceites",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Quantidade necessária para a troca com o recluso traficante.",
                    label = "Quantidade necessária",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Quantidade de recompensa para a troca com o recluso traficante.",
                    label = "Quantidade de recompensa",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Item de recompensa para a troca com o recluso traficante.",
                    label = "Item de recompensa",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para a troca com o recluso traficante.",
                    label = "Etiqueta de recompensa",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Permite que o contrabando encontrado durante a limpeza da prisão conte para a troca com o recluso traficante.",
                    label = "Usar contrabando da limpeza",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Quantidade necessária para a troca com o recluso transportador de ferramentas.",
                    label = "Quantidade necessária",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Item necessário para a troca com o recluso transportador de ferramentas.",
                    label = "Item necessário",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Quantidade de recompensa para a troca com o recluso transportador de ferramentas.",
                    label = "Quantidade de recompensa",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Item de recompensa para a troca com o recluso transportador de ferramentas.",
                    label = "Item de recompensa",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Etiqueta de recompensa mostrada para a troca com o recluso transportador de ferramentas.",
                    label = "Etiqueta de recompensa",
                },
                jailJobsCarryBoxModel = {
                    description = "Modelo de acessório usado para a caixa da tarefa de transporte da prisão.",
                    label = "Modelo da caixa de transporte",
                },
                jailJobsCarryDropoffKey = {
                    description = "Código de controlo usado para entregar caixas da tarefa de transporte.",
                    label = "Tecla de entrega do transporte",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Raio de entrega para a tarefa de transporte da prisão.",
                    label = "Raio de entrega",
                },
                jailJobsCarryInspectKey = {
                    description = "Código de controlo usado para inspecionar as caixas da tarefa de transporte.",
                    label = "Tecla de inspeção",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Itens sem valor que podem ser encontrados ao inspecionar as caixas da tarefa de transporte.",
                    label = "Itens de inspeção sem valor",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Chance de obter uma recompensa de saque utilizável ao inspecionar caixas.",
                    label = "Chance de saque utilizável",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Itens utilizáveis que podem ser encontrados ao inspecionar as caixas da tarefa de transporte.",
                    label = "Itens de inspeção utilizáveis",
                },
                jailJobsCarryInteractDistance = {
                    description = "Distância de interação para a tarefa de transporte da prisão.",
                    label = "Distância de interação do transporte",
                },
                jailJobsCarryMaxDistance = {
                    description = "Distância máxima permitida para o progresso da tarefa de transporte da prisão.",
                    label = "Distância máxima do transporte",
                },
                jailJobsCarryPickupKey = {
                    description = "Código de controlo usado para recolher caixas da tarefa de transporte.",
                    label = "Tecla de recolha do transporte",
                },
                jailJobsCarryPickupOffset = {
                    description = "Objeto de deslocamento usado para o local de recolha da tarefa de transporte.",
                    label = "Deslocamento de recolha",
                },
                jailJobsCarryTimeReduction = {
                    description = "Redução de pena por concluir a tarefa de transporte da prisão.",
                    label = "Redução de pena do transporte",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Código de controlo usado no contentor da prisão.",
                    label = "Tecla do contentor",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modelo usado para o acessório do contentor de limpeza da prisão.",
                    label = "Modelo do contentor",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Chance de encontrar contrabando durante a limpeza.",
                    label = "Chance de achado ilegal",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Itens que podem ser encontrados durante a limpeza na prisão.",
                    label = "Itens de achado ilegal",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Tempo limite para os avisos de achado ilegal em milissegundos.",
                    label = "Tempo limite do aviso de achado",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distância usada para a interação com o lixo da limpeza.",
                    label = "Distância de interação da limpeza",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Distância máxima antes dos acessórios de limpeza reiniciarem ou desaparecerem.",
                    label = "Distância máxima da limpeza",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Número máximo simultâneo de acessórios de lixo para a limpeza da prisão.",
                    label = "Máximo de acessórios de lixo",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Distância mínima ao centro para a geração de lixo da limpeza.",
                    label = "Raio mínimo de geração",
                },
                jailJobsCleaningPickupKey = {
                    description = "Código de controlo usado para recolher o lixo da limpeza da prisão.",
                    label = "Tecla de recolha da limpeza",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Milissegundos entre tentativas de geração de lixo da limpeza.",
                    label = "Intervalo de geração de lixo",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Raio usado para gerar os acessórios de lixo da limpeza.",
                    label = "Raio de geração de lixo",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modelos de acessórios de lixo usados para a tarefa de limpeza da prisão.",
                    itemLabel = "Modelo",
                    label = "Modelos de lixo",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Cor RGBA do contorno usada para os acessórios de lixo da limpeza da prisão.",
                    label = "Cor do contorno",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Ativa contornos nos acessórios de lixo da limpeza da prisão.",
                    label = "Contorno do lixo",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID do shader usado para os contornos do lixo da limpeza da prisão.",
                    label = "Shader do contorno",
                },
                jailJobsTimeReduction = {
                    description = "Redução de pena por concluir a tarefa de limpeza da prisão.",
                    label = "Redução de pena da limpeza",
                },
                jailJobsTrashGoal = {
                    description = "Itens de lixo necessários para concluir a tarefa de limpeza da prisão.",
                    label = "Meta de lixo da limpeza",
                },
                jailMaxMonths = {
                    description = "Duração máxima de prisão selecionável.",
                    label = "Meses máximos",
                },
                jailMinMonths = {
                    description = "Duração mínima de prisão selecionável.",
                    label = "Meses mínimos",
                },
                jailMonthMinutes = {
                    description = "Minutos em tempo real representados por um mês de prisão.",
                    label = "Minutos por mês",
                },
                jailObjectStreamDistance = {
                    description = "Distância usada para o carregamento de objetos persistentes do mundo da prisão.",
                    label = "Distância de carregamento de objetos",
                },
                jailOutfitApplyDelayMs = {
                    description = "Atraso após entrar antes da roupa da prisão ser aplicada.",
                    label = "Atraso na aplicação da roupa",
                },
                jailOutfitEnabled = {
                    description = "Ativa as roupas da prisão.",
                    label = "Roupa da prisão",
                },
                jailOutfitFemaleArms = {
                    description = "Componente dos braços da roupa feminina da prisão.",
                    label = "Braços",
                },
                jailOutfitFemaleChain1 = {
                    description = "Drawable da corrente da roupa feminina da prisão.",
                    label = "Corrente 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Textura da corrente da roupa feminina da prisão.",
                    label = "Corrente 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Drawable dos decalques da roupa feminina da prisão.",
                    label = "Decalques 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Textura dos decalques da roupa feminina da prisão.",
                    label = "Decalques 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Drawable dos óculos da roupa feminina da prisão (-1 remove os óculos).",
                    label = "Óculos 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Textura dos óculos da roupa feminina da prisão.",
                    label = "Óculos 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Drawable do capacete da roupa feminina da prisão.",
                    label = "Capacete 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Textura do capacete da roupa feminina da prisão.",
                    label = "Capacete 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Drawable das calças da roupa feminina da prisão.",
                    label = "Calças 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Textura das calças da roupa feminina da prisão.",
                    label = "Calças 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Drawable dos sapatos da roupa feminina da prisão.",
                    label = "Sapatos 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Textura dos sapatos da roupa feminina da prisão.",
                    label = "Sapatos 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Drawable do tronco da roupa feminina da prisão.",
                    label = "Tronco 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Textura do tronco da roupa feminina da prisão.",
                    label = "Tronco 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Drawable da t-shirt da roupa feminina da prisão.",
                    label = "T-shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Textura da t-shirt da roupa feminina da prisão.",
                    label = "T-shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Componente dos braços da roupa masculina da prisão.",
                    label = "Braços",
                },
                jailOutfitMaleChain1 = {
                    description = "Drawable da corrente da roupa masculina da prisão.",
                    label = "Corrente 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Textura da corrente da roupa masculina da prisão.",
                    label = "Corrente 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Drawable dos decalques da roupa masculina da prisão.",
                    label = "Decalques 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Textura dos decalques da roupa masculina da prisão.",
                    label = "Decalques 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Drawable dos óculos da roupa masculina da prisão (-1 remove os óculos).",
                    label = "Óculos 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Textura dos óculos da roupa masculina da prisão.",
                    label = "Óculos 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Drawable do capacete da roupa masculina da prisão.",
                    label = "Capacete 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Textura do capacete da roupa masculina da prisão.",
                    label = "Capacete 2",
                },
                jailOutfitMalePants1 = {
                    description = "Drawable das calças da roupa masculina da prisão.",
                    label = "Calças 1",
                },
                jailOutfitMalePants2 = {
                    description = "Textura das calças da roupa masculina da prisão.",
                    label = "Calças 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Drawable dos sapatos da roupa masculina da prisão.",
                    label = "Sapatos 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Textura dos sapatos da roupa masculina da prisão.",
                    label = "Sapatos 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Drawable do tronco da roupa masculina da prisão.",
                    label = "Tronco 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Textura do tronco da roupa masculina da prisão.",
                    label = "Tronco 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Drawable da t-shirt da roupa masculina da prisão.",
                    label = "T-shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Textura da t-shirt da roupa masculina da prisão.",
                    label = "T-shirt 2",
                },
                jailRequireJailTerminal = {
                    description = "Permitir penas de prisão aplicadas por agentes apenas perto de um terminal da prisão selecionada.",
                    label = "Exigir terminal da prisão",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Restaura a roupa civil guardada quando um recluso foge.",
                    label = "Restaurar roupa na fuga",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Janela de tolerância após o restauro antes da correção do ponto de saída deixar de se aplicar.",
                    label = "Janela de correção do restauro",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Teletransporta reclusos restaurados de volta ao ponto de saída da prisão se carregarem fora da zona da prisão.",
                    label = "Teletransportar reclusos restaurados",
                },
                jailTerminalRange = {
                    description = "Distância máxima do agente a um terminal da prisão selecionada.",
                    label = "Distância do terminal",
                },
                jailZoneExitGraceMs = {
                    description = "Janela de tolerância antes de uma saída da zona da prisão poder ser considerada uma fuga.",
                    label = "Tolerância de saída de zona",
                },
                mugshotAnimDict = {
                    description = "Dicionário de animação usado durante a captura da foto de detido.",
                    label = "Dicionário de animação",
                },
                mugshotAnimFlag = {
                    description = "Flag de animação usada durante a captura da foto de detido.",
                    label = "Flag da animação",
                },
                mugshotAnimName = {
                    description = "Nome da animação usado durante a captura da foto de detido.",
                    label = "Nome da animação",
                },
                mugshotBoardHeader = {
                    description = "Cabeçalho principal mostrado no painel da foto de detido.",
                    label = "Cabeçalho do painel",
                },
                mugshotBoardSubheader = {
                    description = "Subcabeçalho de reserva mostrado no painel da foto de detido.",
                    label = "Subcabeçalho do painel",
                },
                mugshotCameraCoordsX = {
                    description = "Coordenada X do mundo da câmara usada para as fotos de detido.",
                    label = "Câmara X",
                },
                mugshotCameraCoordsY = {
                    description = "Coordenada Y do mundo da câmara usada para as fotos de detido.",
                    label = "Câmara Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Coordenada Z do mundo da câmara usada para as fotos de detido.",
                    label = "Câmara Z",
                },
                mugshotCameraFov = {
                    description = "Campo de visão usado para as capturas de foto de detido.",
                    label = "Campo de visão da câmara",
                },
                mugshotCameraRotX = {
                    description = "Rotação X da câmara usada para as fotos de detido.",
                    label = "Rotação X",
                },
                mugshotCameraRotY = {
                    description = "Rotação Y da câmara usada para as fotos de detido.",
                    label = "Rotação Y",
                },
                mugshotCameraRotZ = {
                    description = "Rotação Z da câmara usada para as fotos de detido.",
                    label = "Rotação Z",
                },
                mugshotCaptureTimeout = {
                    description = "Milissegundos máximos permitidos para os callbacks de captura da foto de detido.",
                    label = "Tempo limite de captura",
                },
                mugshotEnabled = {
                    description = "Ativa a captura de foto de detido durante o registo na prisão.",
                    label = "Captura de foto de detido",
                },
                mugshotHeading = {
                    description = "Direção aplicada durante a captura da foto de detido.",
                    label = "Direção",
                },
                mugshotLocationX = {
                    description = "Coordenada X do mundo usada para a captura da foto de detido.",
                    label = "Localização X",
                },
                mugshotLocationY = {
                    description = "Coordenada Y do mundo usada para a captura da foto de detido.",
                    label = "Localização Y",
                },
                mugshotLocationZ = {
                    description = "Coordenada Z do mundo usada para a captura da foto de detido.",
                    label = "Localização Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Formato de descrição usado para os metadados da foto de detido armazenada.",
                    label = "Descrição dos metadados",
                },
                mugshotMetadataName = {
                    description = "Nome dos metadados de inventário usado para a foto de detido armazenada.",
                    label = "Nome dos metadados",
                },
                mugshotWaitMs = {
                    description = "Milissegundos a esperar antes de tirar a foto de detido.",
                    label = "Milissegundos de espera",
                },
                playerSearchAnimDict = {
                    description = "Dicionário de animação usado durante as revistas de jogadores.",
                    label = "Dicionário de animação",
                },
                playerSearchAnimFlag = {
                    description = "Flag de animação usada durante as revistas de jogadores.",
                    label = "Flag da animação",
                },
                playerSearchAnimName = {
                    description = "Nome da animação usado durante as revistas de jogadores.",
                    label = "Nome da animação",
                },
                playerSearchDurationMs = {
                    description = "Duração da pré-visualização de revista de jogadores em milissegundos.",
                    label = "Duração da revista",
                },
                playerSearchEnabled = {
                    description = "Ativa o fluxo de pré-visualização de revista de jogadores.",
                    label = "Revista",
                },
                playerSearchRange = {
                    description = "Distância máxima para começar a revistar um jogador.",
                    label = "Distância de revista",
                },
                playerSearchScenario = {
                    description = "Cenário usado quando não é reproduzida uma animação de revista explícita.",
                    label = "Cenário de revista",
                },
                policeBillingControl200 = {
                    label = "Faturação · Controlo 200",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeBillingControl322 = {
                    label = "Faturação · Controlo 322",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl10 = {
                    label = "Editor · Controlo 10",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl11 = {
                    label = "Editor · Controlo 11",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl172 = {
                    label = "Editor · Controlo 172",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl173 = {
                    label = "Editor · Controlo 173",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl174 = {
                    label = "Editor · Controlo 174",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl175 = {
                    label = "Editor · Controlo 175",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl177 = {
                    label = "Editor · Controlo 177",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl191 = {
                    label = "Editor · Controlo 191",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl201 = {
                    label = "Editor · Controlo 201",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl202 = {
                    label = "Editor · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl21 = {
                    label = "Editor · Controlo 21",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl32 = {
                    label = "Editor · Controlo 32",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl322 = {
                    label = "Editor · Controlo 322",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl33 = {
                    label = "Editor · Controlo 33",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl34 = {
                    label = "Editor · Controlo 34",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl35 = {
                    label = "Editor · Controlo 35",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl36 = {
                    label = "Editor · Controlo 36",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl37 = {
                    label = "Editor · Controlo 37",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl38 = {
                    label = "Editor · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl44 = {
                    label = "Editor · Controlo 44",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policeEditorControl73 = {
                    label = "Editor · Controlo 73",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                policePrimaryColor = {
                    description = "Cor padrão para o grupo de empregos da polícia.",
                    label = "Cor primária",
                },
                propPlacementConsumeItem = {
                    description = "Remove um item do inventário quando um acessório é colocado a partir do inventário.",
                    label = "Consumir item de acessório",
                },
                propPlacementEnabled = {
                    description = "Permite colocar acessórios policiais configurados a partir de itens ou veículos.",
                    label = "Colocação de acessórios",
                },
                propPlacementItemNames = {
                    description = "Associa modelos de acessórios a nomes de itens de inventário para colocação baseada em itens.",
                    label = "Nomes dos itens de acessórios",
                },
                propPlacementRequireOnDuty = {
                    description = "Apenas agentes em serviço podem colocar acessórios configurados.",
                    label = "Acessórios exigem serviço",
                },
                propPlacementReturnItem = {
                    description = "Devolve o item consumido quando um acessório colocado é removido.",
                    label = "Devolver item de acessório",
                },
                propPlacementVehicleAccess = {
                    description = "Permite que os veículos do emprego disponibilizem o seu equipamento de acessórios configurado.",
                    label = "Acesso a acessórios do veículo",
                },
                radialEnabled = {
                    description = "Ativa as ações radiais da polícia.",
                    label = "Radial da polícia",
                },
                radialHandcuffKeybindCommand = {
                    description = "Nome do comando registado para o atalho de algemar.",
                    label = "Comando de algemar",
                },
                radialHandcuffKeybindDescription = {
                    description = "Descrição mostrada para o atalho de algemar.",
                    label = "Descrição de algemar",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Ativa o atalho de teclado direto para algemar.",
                    label = "Atalho de algemar",
                },
                radialHandcuffKeybindKey = {
                    description = "Tecla do teclado usada para a ação direta de algemar.",
                    label = "Tecla de algemar",
                },
                radialKeybindsEnabled = {
                    description = "Ativa atalhos de teclado diretos para ações radiais selecionadas.",
                    label = "Atalhos diretos",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Nome do comando registado para o atalho de desalgemar.",
                    label = "Comando de desalgemar",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Descrição mostrada para o atalho de desalgemar.",
                    label = "Descrição de desalgemar",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Ativa o atalho de teclado direto para desalgemar.",
                    label = "Atalho de desalgemar",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Tecla do teclado usada para a ação direta de desalgemar.",
                    label = "Tecla de desalgemar",
                },
                socialWorkAssignRange = {
                    description = "Distância máxima para atribuir tarefas de serviço comunitário.",
                    label = "Distância de atribuição",
                },
                socialWorkDeadlineDefault = {
                    description = "Prazo padrão de serviço comunitário em minutos. Zero desativa os prazos.",
                    label = "Prazo padrão",
                },
                socialWorkDeadlineMax = {
                    description = "Prazo máximo de serviço comunitário em minutos. Zero desativa o limite.",
                    label = "Prazo máximo",
                },
                socialWorkDeadlineMin = {
                    description = "Prazo mínimo de serviço comunitário em minutos.",
                    label = "Prazo mínimo",
                },
                socialWorkDefaultTasks = {
                    description = "Número de tarefas padrão ao abrir a atribuição de serviço comunitário.",
                    label = "Tarefas padrão",
                },
                socialWorkEnabled = {
                    description = "Ativa a atribuição e os fluxos de tarefas do serviço comunitário.",
                    label = "Serviço comunitário",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID de prisão usado quando as violações do serviço comunitário resultam em encarceramento.",
                    label = "ID de prisão de reserva",
                },
                socialWorkImprisonmentMonths = {
                    description = "Meses atribuídos quando as violações do serviço comunitário resultam em prisão.",
                    label = "Meses de encarceramento",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Nome do agente usado para os registos de encarceramento do serviço comunitário.",
                    label = "Nome do agente do encarceramento",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Envia os infratores para o isolamento quando o encarceramento é acionado.",
                    label = "Usar isolamento",
                },
                socialWorkInactivityMinutes = {
                    description = "Minutos antes de aplicar as penalizações de inatividade do serviço comunitário.",
                    label = "Minutos de inatividade",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Penalização de tarefas aplicada quando um jogador de serviço comunitário permanece inativo demasiado tempo.",
                    label = "Penalização de tarefas por inatividade",
                },
                socialWorkMaxTasks = {
                    description = "Número máximo selecionável de tarefas de serviço comunitário.",
                    label = "Tarefas máximas",
                },
                socialWorkMinTasks = {
                    description = "Número mínimo selecionável de tarefas de serviço comunitário.",
                    label = "Tarefas mínimas",
                },
                speedCamBillingEnabled = {
                    description = "Emite faturas automáticas quando os radares de velocidade capturam uma infração correspondente. Requer que a funcionalidade global de Faturação esteja ativada.",
                    label = "Multas automáticas",
                },
                speedCamBillingExcludedJobs = {
                    description = "Empregos que nunca recebem faturas automáticas de radares de velocidade.",
                    itemLabel = "Emprego",
                    label = "Empregos excluídos",
                },
                speedCamBillingExcludedModels = {
                    description = "Nomes de spawn de veículos que nunca recebem faturas automáticas de radares de velocidade.",
                    itemLabel = "Modelo",
                    label = "Modelos de veículos excluídos",
                },
                speedCamBillingRules = {
                    description = "Regras de multa usadas pelos radares de velocidade. O intervalo de excesso mais próximo correspondente é faturado primeiro; se nenhuma regra corresponder, são usadas as infrações de SpeedViolation como reserva.",
                    label = "Regras de multa",
                },
                speedCamCameraEaseMs = {
                    description = "Quanto tempo demora a vista a ajustar-se ao ângulo do radar de velocidade. Valores mais baixos = movimento mais curto; demasiado baixo pode desalinhar a fotografia.",
                    label = "Suavização da câmara (ms)",
                },
                speedCamCameraFov = {
                    description = "Campo de visão usado para as capturas do radar de velocidade.",
                    label = "Campo de visão da câmara",
                },
                speedCamCheckIntervalMs = {
                    description = "Milissegundos entre digitalizações do radar de velocidade.",
                    label = "Intervalo de verificação",
                },
                speedCamCooldownMs = {
                    description = "Milissegundos antes do mesmo radar de velocidade poder ser ativado novamente.",
                    label = "Tempo de espera de ativação",
                },
                speedCamDamageCooldownMs = {
                    description = "Milissegundos antes do dano ao radar de velocidade poder ser aplicado novamente.",
                    label = "Tempo de espera de dano",
                },
                speedCamDamagePerHit = {
                    description = "Dano de durabilidade aplicado aos radares de velocidade por impacto.",
                    label = "Dano por impacto",
                },
                speedCamDamagedModelThreshold = {
                    description = "Percentagem da durabilidade máxima a partir da qual, para baixo, é apresentado o modelo danificado. Exemplo: 50 com durabilidade máxima de 200 muda o modelo ao chegar a 100.",
                    label = "Limite do modelo danificado (%)",
                },
                speedCamDefaultLimit = {
                    description = "Limite padrão do radar de velocidade.",
                    label = "Limite de velocidade padrão",
                },
                speedCamDefaultName = {
                    description = "Nome apresentado sugerido ao colocar um radar. Pode ser traduzido sem alterar o item do inventário nem o modelo.",
                    label = "Nome padrão",
                },
                speedCamDefaultTolerance = {
                    description = "Tolerância padrão do radar de velocidade.",
                    label = "Tolerância padrão",
                },
                speedCamDisassembleDistance = {
                    description = "Distância usada para desmontar radares de velocidade.",
                    label = "Distância de desmontagem",
                },
                speedCamEnabled = {
                    description = "Ativa os radares de velocidade portáteis.",
                    label = "Radares de velocidade",
                },
                speedCamFlashColor = {
                    description = "Cor RGBA do flash usada pelos radares de velocidade.",
                    label = "Cor do flash",
                },
                speedCamFlashDurationMs = {
                    description = "Tempo de desaparecimento do flash vermelho do radar de velocidade. Não definir demasiado baixo, ou o movimento da câmara torna-se visível.",
                    label = "Duração do flash (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distância à qual a durabilidade do radar de velocidade é mostrada.",
                    label = "Distância de exibição da durabilidade",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Milissegundos durante os quais a durabilidade do radar de velocidade permanece visível.",
                    label = "Duração de exibição da durabilidade",
                },
                speedCamHealthTextOffset = {
                    description = "Deslocamento vertical usado para o texto de durabilidade do radar de velocidade.",
                    label = "Deslocamento do texto de durabilidade",
                },
                speedCamItem = {
                    description = "Nome interno exato do item no inventário, por exemplo speedcam. Introduza a chave do item, não o nome apresentado; a loja do emprego deve fornecer o mesmo item.",
                    label = "Nome do item do radar",
                },
                speedCamMaintenanceThreshold = {
                    description = "Limiar de durabilidade a partir do qual se recomenda a manutenção do radar de velocidade.",
                    label = "Limiar de manutenção",
                },
                speedCamMaxDurability = {
                    description = "Durabilidade máxima dos radares de velocidade destacados.",
                    label = "Durabilidade máxima",
                },
                speedCamMaxLimit = {
                    description = "Limite máximo configurável do radar de velocidade.",
                    label = "Limite de velocidade máximo",
                },
                speedCamMaxTolerance = {
                    description = "Tolerância máxima configurável do radar de velocidade.",
                    label = "Tolerância máxima",
                },
                speedCamPhotoLocale = {
                    description = "Idioma opcional usado para a data/hora nas fotografias do radar de velocidade. Deixa em branco para usar o idioma local do jogador fotografado.",
                    label = "Idioma da fotografia",
                },
                speedCamPhotoTimeZone = {
                    description = "Fuso horário opcional usado para a data/hora nas fotografias do radar de velocidade. Deixa em branco para usar o fuso horário local do jogador fotografado.",
                    label = "Fuso horário da fotografia",
                },
                speedCamPoliceNotification = {
                    description = "Envia uma notificação de despacho quando os radares de velocidade capturam violações.",
                    label = "Alerta policial do radar",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Trata o alvo do despacho do radar de velocidade como um grupo de emprego.",
                    label = "Alvo do despacho é grupo",
                },
                speedCamPoliceNotificationJob = {
                    description = "Chave de emprego ou grupo usada para as notificações de despacho do radar de velocidade.",
                    label = "Alvo do despacho",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Notifica apenas os alvos de despacho do radar de velocidade que estão em serviço.",
                    label = "Despacho exige serviço",
                },
                speedCamPoliceNotificationType = {
                    description = "Severidade/tipo de despacho usado para os alertas do radar de velocidade.",
                    label = "Tipo de despacho",
                },
                speedCamPropModel = {
                    description = "Nome de criação do modelo intacto do radar, por exemplo sky_speedcam. Uma predefinição também seleciona os modelos danificado e destruído. Os modelos personalizados devem estar disponíveis no jogo.",
                    label = "Modelo do acessório do radar",
                    custom = "Modelo personalizado",
                    choose = "Escolher modelo",
                    preview = "Pré-visualização 3D",
                    customPlaceholder = "Nome de spawn do objeto",
                    previewDescription = "Mostra o objeto escolhido no jogo. A pré-visualização não guarda alterações.",
                    invalidModel = "Introduza primeiro um nome de objeto válido.",
                    modelMissing = "Este modelo não está disponível no jogo.",
                    previewFailed = "Não foi possível abrir a pré-visualização do modelo.",
                    intact = "Modelo intacto",
                    previewRequiresGame = "Abre /jobconfig no FiveM para ver o objeto em direto.",
                    previewHelp = "Setas: mover; PageUp/PageDown: altura; roda: rodar; Enter: fechar; Backspace: cancelar.",
                    options = {
                        sky_speedcam = "Radar padrão",
                        sky_germ_speedcam = "Radar alemão",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Nome de criação do modelo danificado do radar, por exemplo sky_speedcam2. Use uma variante correspondente ao modelo intacto.",
                    label = "Modelo de acessório danificado",
                },
                speedCamPropModelDestroyed = {
                    description = "Nome do modelo apresentado quando a durabilidade chega a 0, por exemplo sky_speedcam1. Use uma variante correspondente ao modelo intacto.",
                    label = "Modelo de acessório destruído",
                },
                speedCamRepairAnimDict = {
                    description = "Dicionário de animação usado ao reparar radares de velocidade.",
                    label = "Dicionário de animação de reparação",
                },
                speedCamRepairAnimFlag = {
                    description = "Flag de animação usada ao reparar radares de velocidade.",
                    label = "Flag da animação de reparação",
                },
                speedCamRepairAnimName = {
                    description = "Nome da animação usado ao reparar radares de velocidade.",
                    label = "Nome da animação de reparação",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Milissegundos antes da reparação do radar de velocidade poder ser cancelada.",
                    label = "Atraso de cancelamento da reparação",
                },
                speedCamRepairDistance = {
                    description = "Distância usada para reparar radares de velocidade.",
                    label = "Distância de reparação",
                },
                speedCamRepairItem = {
                    description = "Nome interno exato do item de reparação, por exemplo fixtool. Introduza a chave do item, não o nome apresentado.",
                    label = "Nome do item de reparação",
                },
                speedCamRepairPerTick = {
                    description = "Durabilidade restaurada por cada ciclo de reparação do radar de velocidade.",
                    label = "Reparação por ciclo",
                },
                speedCamRepairTickMs = {
                    description = "Milissegundos entre ciclos de reparação do radar de velocidade.",
                    label = "Intervalo de reparação",
                },
                speedCamStreamDistance = {
                    description = "Distância ao jogador em metros dentro da qual os modelos dos radares são carregados. Fora dela, os modelos são descarregados; os radares guardados permanecem colocados.",
                    label = "Distância de carregamento",
                },
                speedCamTriggerRadius = {
                    description = "Raio de deteção em metros à volta do radar para veículos em excesso de velocidade.",
                    label = "Raio de ativação",
                },
                speedCamUseMph = {
                    description = "Mostra e processa os limites do radar de velocidade em MPH.",
                    label = "Usar MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Armas que têm permissão para danificar os radares de velocidade enquanto a restrição está ativada.",
                    itemLabel = "Arma",
                    label = "Armas permitidas",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Apenas as armas listadas podem danificar os radares de velocidade enquanto isto está ativado.",
                    label = "Restrição ativada",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distância em metros antes de limpar os avisos de radar de velocidade.",
                    label = "Distância de limpeza",
                },
                speedCameraAppDefaultApp = {
                    description = "Mostra a aplicação de radar de velocidade como aplicação padrão do tablet.",
                    label = "Aplicação padrão",
                },
                speedCameraAppDescription = {
                    description = "Descrição mostrada para a aplicação de radar de velocidade do tablet.",
                    label = "Descrição",
                },
                speedCameraAppDeveloper = {
                    description = "Etiqueta de programador mostrada para a aplicação de radar de velocidade do tablet.",
                    label = "Programador",
                },
                speedCameraAppEnabled = {
                    description = "Ativa a aplicação de radar de velocidade no tablet policial.",
                    label = "Aplicação de radar de velocidade do tablet",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Antetítulo do cabeçalho mostrado na aplicação de radar de velocidade.",
                    label = "Antetítulo do cabeçalho",
                },
                speedCameraAppHeaderTitle = {
                    description = "Título do cabeçalho mostrado na aplicação de radar de velocidade.",
                    label = "Título do cabeçalho",
                },
                speedCameraAppIcon = {
                    description = "Caminho do ícone usado para a aplicação de radar de velocidade do tablet.",
                    label = "Caminho do ícone",
                },
                speedCameraAppIdentifier = {
                    description = "Identificador interno da aplicação de radar de velocidade do tablet.",
                    label = "Identificador",
                },
                speedCameraAppInFrontDot = {
                    description = "Limiar do produto escalar usado para determinar se um radar de velocidade está à frente do jogador.",
                    label = "Limiar do produto escalar frontal",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Velocidade mínima do veículo em KMH antes de mostrar avisos.",
                    label = "Velocidade mínima do veículo",
                },
                speedCameraAppName = {
                    description = "Nome de exibição da aplicação de radar de velocidade do tablet.",
                    label = "Nome da aplicação",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distância em metros antes de notificar sobre radares de velocidade próximos.",
                    label = "Distância de notificação",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "Avisa apenas sobre radares de velocidade enquanto o jogador está num veículo.",
                    label = "Apenas em veículo",
                },
                speedCameraAppOverlayBackground = {
                    description = "Cor de fundo usada para a sobreposição da imagem da matrícula.",
                    label = "Fundo da sobreposição",
                },
                speedCameraAppOverlayBorder = {
                    description = "Cor do contorno usada para a sobreposição da imagem da matrícula.",
                    label = "Contorno da sobreposição",
                },
                speedCameraAppOverlayColor = {
                    description = "Cor do texto usada para a sobreposição da imagem da matrícula.",
                    label = "Cor da sobreposição",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Ativa a sobreposição da imagem da matrícula nas imagens capturadas pelo radar de velocidade.",
                    label = "Sobreposição ativada",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Escala de fonte usada para a sobreposição da imagem da matrícula.",
                    label = "Escala da fonte da sobreposição",
                },
                speedCameraAppOverlayX = {
                    description = "Posição X normalizada da sobreposição, da esquerda para a direita.",
                    label = "Sobreposição X",
                },
                speedCameraAppOverlayY = {
                    description = "Posição Y normalizada da sobreposição, de cima para baixo.",
                    label = "Sobreposição Y",
                },
                speedCameraAppRequireInFront = {
                    description = "Avisa apenas sobre radares de velocidade que estejam à frente do jogador.",
                    label = "Exigir à frente",
                },
                speedCameraAppRoute = {
                    description = "Caminho de rota aberto pela aplicação de radar de velocidade do tablet.",
                    label = "Rota",
                },
                speedCameraAppSize = {
                    description = "Tamanho de armazenamento reportado para a aplicação de radar de velocidade do tablet.",
                    label = "Tamanho da aplicação",
                },
                speedCameraAppSoundCoord = {
                    description = "Reproduz os sons de aviso de radar de velocidade em coordenadas do mundo.",
                    label = "Som de coordenadas",
                },
                speedCameraAppSoundEnabled = {
                    description = "Ativa os sons de aviso para a aplicação de radar de velocidade.",
                    label = "Som ativado",
                },
                speedCameraAppSoundFrontend = {
                    description = "Reproduz os sons de aviso de radar de velocidade no canal de áudio do frontend.",
                    label = "Som do frontend",
                },
                speedCameraAppSoundLayers = {
                    description = "Número de sons de aviso sobrepostos reproduzidos pela aplicação de radar de velocidade.",
                    label = "Camadas de som",
                },
                speedCameraAppSoundName = {
                    description = "Nome do som usado para os avisos da aplicação de radar de velocidade.",
                    label = "Nome do som",
                },
                speedCameraAppSoundRange = {
                    description = "Alcance usado para os sons de aviso da aplicação de radar de velocidade.",
                    label = "Alcance do som",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Número de vezes que o som de aviso do radar de velocidade se repete.",
                    label = "Número de repetições",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Milissegundos entre repetições do som de aviso do radar de velocidade.",
                    label = "Atraso de repetição",
                },
                speedCameraAppSoundSet = {
                    description = "Conjunto de sons usado para os avisos da aplicação de radar de velocidade.",
                    label = "Conjunto de sons",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Conta usada para os pagamentos da subscrição da aplicação de radar de velocidade do tablet.",
                    label = "Conta",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Ativa subscrições pagas para a aplicação de radar de velocidade do tablet.",
                    label = "Subscrição ativada",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Dias entre renovações da subscrição da aplicação de radar de velocidade do tablet.",
                    label = "Dias de intervalo",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Preço cobrado pela subscrição da aplicação de radar de velocidade do tablet.",
                    label = "Preço da subscrição",
                },
                speedCameraAppThemeAccent = {
                    description = "Cor de destaque usada pela aplicação de radar de velocidade.",
                    label = "Destaque",
                },
                speedCameraAppThemeBackground = {
                    description = "Fundo em gradiente linear usado pela aplicação de radar de velocidade.",
                    label = "Fundo",
                },
                speedCameraAppThemeBorder = {
                    description = "Cor de contorno usada pela aplicação de radar de velocidade.",
                    label = "Contorno",
                },
                speedCameraAppThemeButtonText = {
                    description = "Cor do texto do botão usada pela aplicação de radar de velocidade.",
                    label = "Texto do botão",
                },
                speedCameraAppThemeDanger = {
                    description = "Cor de perigo usada pela aplicação de radar de velocidade.",
                    label = "Perigo",
                },
                speedCameraAppThemeGhost = {
                    description = "Cor do botão fantasma usada pela aplicação de radar de velocidade.",
                    label = "Botão fantasma",
                },
                speedCameraAppThemeGhostText = {
                    description = "Cor do texto fantasma usada pela aplicação de radar de velocidade.",
                    label = "Texto fantasma",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Cor de gradiente suave usada pela aplicação de radar de velocidade.",
                    label = "Gradiente suave",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Cor de contorno inativo usada pela aplicação de radar de velocidade.",
                    label = "Contorno inativo",
                },
                speedCameraAppThemeModal = {
                    description = "Cor de fundo do modal usada pela aplicação de radar de velocidade.",
                    label = "Modal",
                },
                speedCameraAppThemeMutedText = {
                    description = "Cor de texto atenuado usada pela aplicação de radar de velocidade.",
                    label = "Texto atenuado",
                },
                speedCameraAppThemeOverlay = {
                    description = "Cor de sobreposição usada pela aplicação de radar de velocidade.",
                    label = "Sobreposição",
                },
                speedCameraAppThemePillText = {
                    description = "Cor do texto da etiqueta usada pela aplicação de radar de velocidade.",
                    label = "Texto da etiqueta",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Cor de início do gradiente primário usada pela aplicação de radar de velocidade.",
                    label = "Início do gradiente primário",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Cor de fim do gradiente primário usada pela aplicação de radar de velocidade.",
                    label = "Fim do gradiente primário",
                },
                speedCameraAppThemeShadow = {
                    description = "Cor da sombra usada pela aplicação de radar de velocidade.",
                    label = "Sombra",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Cor de destaque usada pela aplicação de radar de velocidade.",
                    label = "Destaque",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Cor de texto subtil usada pela aplicação de radar de velocidade.",
                    label = "Texto subtil",
                },
                speedCameraAppThemeSuccess = {
                    description = "Cor de sucesso usada pela aplicação de radar de velocidade.",
                    label = "Sucesso",
                },
                speedCameraAppThemeSurface = {
                    description = "Cor de superfície usada pela aplicação de radar de velocidade.",
                    label = "Superfície",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Cor de superfície suave usada pela aplicação de radar de velocidade.",
                    label = "Superfície suave",
                },
                speedCameraAppThemeText = {
                    description = "Cor de texto principal usada pela aplicação de radar de velocidade.",
                    label = "Texto",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Cor RGBA de destaque usada para a interface de aviso do radar de velocidade.",
                    label = "Destaque RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Cor RGBA usada para o fundo da interface de aviso do radar de velocidade.",
                    label = "Fundo RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Cor RGBA do ícone usada para a interface de aviso do radar de velocidade.",
                    label = "Ícone RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Cor RGBA do texto do ícone usada para a interface de aviso do radar de velocidade.",
                    label = "Texto do ícone RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Segundos que a interface de aviso permanece visível.",
                    label = "Segundos da interface de aviso",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Cor RGBA do subtexto usada para a interface de aviso do radar de velocidade.",
                    label = "Subtexto RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Cor RGBA do texto usada para a interface de aviso do radar de velocidade.",
                    label = "Texto RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Cor RGBA do título usada para a interface de aviso do radar de velocidade.",
                    label = "Título RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Milissegundos entre verificações de proximidade das tiras de pregos.",
                    label = "Intervalo de verificação",
                },
                spikeStripsEnabled = {
                    description = "Ativa as tiras de pregos destacadas.",
                    label = "Tiras de pregos",
                },
                spikeStripsModels = {
                    description = "Modelos de acessórios tratados como tiras de pregos ativas.",
                    itemLabel = "Modelo",
                    label = "Modelos",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Milissegundos antes das novas tentativas de digitalização das tiras de pregos após nenhuma correspondência.",
                    label = "Intervalo de nova tentativa",
                },
                spikeStripsScanDistance = {
                    description = "Distância usada para procurar tiras de pregos próximas.",
                    label = "Distância de digitalização",
                },
                spikeStripsTriggerDistance = {
                    description = "Distância à qual os pneus são rebentados por uma tira de pregos.",
                    label = "Distância de ativação",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Etiqueta de categoria usada para os marcadores das esquadras no criador.",
                    label = "Categoria do marcador da esquadra",
                },
                stationCreatorBlipColor = {
                    description = "Cor do marcador do mapa usada para as esquadras de polícia.",
                    label = "Cor do marcador da esquadra",
                },
                stationCreatorBlipScale = {
                    description = "Escala usada para os marcadores das esquadras de polícia.",
                    label = "Escala do marcador da esquadra",
                },
                stationCreatorBlipShortRange = {
                    description = "Mostra os marcadores das esquadras apenas a curta distância.",
                    label = "Marcador de curto alcance",
                },
                stationCreatorBlipSprite = {
                    description = "Ícone do mapa usado para as esquadras de polícia.",
                    label = "Ícone do marcador da esquadra",
                },
                stationCreatorBlipUseStationName = {
                    description = "Usa o nome configurado da esquadra como etiqueta do marcador do mapa.",
                    label = "Usar nome da esquadra",
                },
                tabletAutoFillCitizens = {
                    description = "Pré-preenche o registo de cidadãos a partir da base de dados da framework.",
                    label = "Preenchimento automático de cidadãos",
                },
                tabletAutoFillVehicles = {
                    description = "Pré-preenche o registo de veículos a partir da base de dados da framework.",
                    label = "Preenchimento automático de veículos",
                },
                tabletBolos = {
                    description = "Mostra a aplicação de BOLO.",
                    label = "Alertas BOLO",
                },
                tabletCases = {
                    description = "Mostra a aplicação de casos.",
                    label = "Casos",
                },
                tabletCitizens = {
                    description = "Mostra a aplicação de registo de cidadãos.",
                    label = "Cidadãos",
                },
                tabletOffences = {
                    description = "Mostra a aplicação de infrações.",
                    label = "Infrações",
                },
                tabletPrison = {
                    description = "Mostra a aplicação de prisão.",
                    label = "Prisão",
                },
                tabletReportEnforcement = {
                    description = "Permite associar infrações e emitir multas ou penas de prisão a partir de relatórios guardados.",
                    label = "Execução de relatórios",
                },
                tabletReports = {
                    description = "Mostra a aplicação de relatórios.",
                    label = "Relatórios",
                },
                tabletSocialWork = {
                    description = "Mostra a aplicação de serviço comunitário.",
                    label = "Serviço comunitário",
                },
                tabletVehicles = {
                    description = "Mostra a aplicação de registo de veículos.",
                    label = "Veículos",
                },
                tabletWarrants = {
                    description = "Mostra a aplicação de mandados.",
                    label = "Mandados",
                },
                tabletWeapons = {
                    description = "Mostra a aplicação de registo de armas.",
                    label = "Armas",
                },
                tackleCuffKey = {
                    label = "Algemar pessoa derrubada",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                tackleKey = {
                    label = "Derrubar",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                tackleReleaseKey = {
                    label = "Soltar pessoa derrubada",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Milissegundos antes de outro alerta de radar poder ser emitido.",
                    label = "Tempo de espera do alerta",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Classes de veículos autorizadas a usar o radar.",
                    label = "Classes de veículos permitidas",
                },
                vehicleRadarAutoFastLock = {
                    description = "Assinala automaticamente alvos muito rápidos no radar.",
                    label = "Bloqueio rápido automático",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Limiar de velocidade usado para o bloqueio rápido automático.",
                    label = "Limiar de bloqueio rápido",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Mapeamento de tecla usado para diminuir o limite de velocidade do radar.",
                    label = "Tecla de diminuir limite",
                },
                vehicleRadarDefaultLimit = {
                    description = "Limite de velocidade padrão usado pelo radar do veículo.",
                    label = "Limite de radar padrão",
                },
                vehicleRadarEnabled = {
                    description = "Ativa o radar do veículo de patrulha.",
                    label = "Radar de veículo",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Mapeamento de tecla usado para aumentar o limite de velocidade do radar.",
                    label = "Tecla de aumentar limite",
                },
                vehicleRadarLimitStep = {
                    description = "Quantidade alterada por cada ajuste do limite do radar.",
                    label = "Passo do limite",
                },
                vehicleRadarLockFrontKey = {
                    description = "Mapeamento de tecla usado para bloquear o alvo do radar frontal.",
                    label = "Tecla de bloqueio frontal",
                },
                vehicleRadarLockRearKey = {
                    description = "Mapeamento de tecla usado para bloquear o alvo do radar traseiro.",
                    label = "Tecla de bloqueio traseiro",
                },
                vehicleRadarMaxLimit = {
                    description = "Limite de velocidade máximo permitido no radar do veículo.",
                    label = "Limite de radar máximo",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Inclinação máxima permitida para a deteção do radar.",
                    label = "Graus máximos de inclinação",
                },
                vehicleRadarMinLimit = {
                    description = "Limite de velocidade mínimo permitido no radar do veículo.",
                    label = "Limite de radar mínimo",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Velocidade mínima antes do radar considerar um alvo válido.",
                    label = "Velocidade mínima do alvo",
                },
                vehicleRadarModeFrontKey = {
                    description = "Mapeamento de tecla usado para alternar o modo do radar frontal.",
                    label = "Tecla de modo frontal",
                },
                vehicleRadarModeRearKey = {
                    description = "Mapeamento de tecla usado para alternar o modo do radar traseiro.",
                    label = "Tecla de modo traseiro",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Milissegundos entre digitalizações do radar enquanto o veículo de patrulha está em movimento.",
                    label = "Intervalo de digitalização em movimento",
                },
                vehicleRadarPassengerControl = {
                    description = "Permite que os passageiros controlem o radar do veículo.",
                    label = "Controlo do passageiro",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Permite que os passageiros vejam os dados espelhados do radar.",
                    label = "Espelho do passageiro",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Milissegundos entre atualizações de sincronização do radar para os passageiros.",
                    label = "Intervalo de sincronização do passageiro",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Limiar de projeção usado ao avaliar os alvos do radar.",
                    label = "Limiar de projeção",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Exige linha de visão desobstruída antes do radar bloquear um alvo.",
                    label = "Exigir linha de visão",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Exige estado de serviço antes de usar o radar do veículo.",
                    label = "Radar exige serviço",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Milissegundos entre digitalizações do radar estacionário.",
                    label = "Intervalo de digitalização",
                },
                vehicleRadarScanRadius = {
                    description = "Raio de digitalização do radar do veículo.",
                    label = "Raio de digitalização",
                },
                vehicleRadarToggleKey = {
                    description = "Mapeamento de tecla usado para ativar/desativar o radar do veículo.",
                    label = "Tecla de ativação/desativação",
                },
                vehicleRadarUseMph = {
                    description = "Mostra os valores de velocidade do radar em MPH.",
                    label = "Radar usa MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Milissegundos entre atualizações do conjunto de veículos próximos.",
                    label = "Atualização do conjunto de veículos",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Mapeamento de tecla usado para XMIT/HOLD do radar frontal.",
                    label = "Tecla XMIT frontal",
                },
                vehicleRadarXmitRearKey = {
                    description = "Mapeamento de tecla usado para XMIT/HOLD do radar traseiro.",
                    label = "Tecla XMIT traseira",
                },
                wheelClampConsumeItem = {
                    description = "Remove o item de cepo de roda após a colocação.",
                    label = "Consumir item do cepo",
                },
                wheelClampEnabled = {
                    description = "Ativa a ação de cepo de roda.",
                    label = "Cepo de roda",
                },
                wheelClampItem = {
                    description = "Item de inventário usado para colocar o cepo de roda.",
                    label = "Item do cepo",
                },
                wheelClampPropModel = {
                    description = "Modelo de acessório usado para o cepo de roda colocado.",
                    label = "Modelo do acessório do cepo",
                },
                wheelClampRequireItem = {
                    description = "Exige o item de cepo de roda configurado. Mantém isto ativo quando o modo de uso do cepo está definido como Inventário ou Ambos.",
                    label = "Cepo exige item",
                },
                wheelClampRequireOnDuty = {
                    description = "Exige estado de serviço antes de colocar cepos de roda.",
                    label = "Cepo exige serviço",
                },
                wheelClampTyreDistance = {
                    description = "Distância máxima ao pneu ao colocar ou soldar um cepo.",
                    label = "Distância ao pneu",
                },
                wheelClampUseItem = {
                    description = "Usa o radial, o inventário, ou ambos para a colocação do cepo de roda. Inventário ou Ambos deve ser combinado com Cepo exige item.",
                    label = "Modo de uso do cepo",
                    options = {
                        both = "Ambos",
                        inventory = "Inventário",
                        radial = "Radial",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Distância máxima ao veículo alvo ao colocar um cepo.",
                    label = "Distância ao veículo",
                },
                wheelClampWeldBurstTyre = {
                    description = "Rebenta o pneu depois de um cepo ser removido por soldadura.",
                    label = "Rebentar pneu",
                },
                wheelClampWeldDurationMs = {
                    description = "Milissegundos necessários para remover um cepo por soldadura.",
                    label = "Duração da soldadura",
                },
                wheelClampWeldEnabled = {
                    description = "Permite remover cepos de roda com um maçarico de soldar.",
                    label = "Soldadura do cepo",
                },
                wheelClampWeldItem = {
                    description = "Item de inventário exigido para soldar o cepo.",
                    label = "Item do maçarico",
                },
                wheelClampWeldMinigame = {
                    description = "Exige o minijogo de soldadura do cepo antes da remoção ser concluída.",
                    label = "Minijogo de soldadura",
                },
                ziptiesConsumeItem = {
                    description = "Remove um item de braçadeiras quando é aplicado.",
                    label = "Consumir braçadeiras",
                },
                ziptiesCutterConsumeItem = {
                    description = "Remove o item de corte depois de cortar braçadeiras.",
                    label = "Consumir item de corte",
                },
                ziptiesCutterEnabled = {
                    description = "Permite que alicates de corte removam braçadeiras.",
                    label = "Corta-braçadeiras",
                },
                ziptiesCutterItem = {
                    description = "Item de inventário usado para cortar braçadeiras.",
                    label = "Item de corte",
                },
                ziptiesEnabled = {
                    description = "Ativa as ações de braçadeiras.",
                    label = "Braçadeiras",
                },
                ziptiesItem = {
                    description = "Item de inventário usado para as ações de braçadeiras.",
                    label = "Item de braçadeiras",
                },
                ziptiesRequireHandsUp = {
                    description = "Exige o estado de mãos ao ar antes de aplicar braçadeiras.",
                    label = "Braçadeiras exigem mãos ao ar",
                },
                ziptiesRequireItem = {
                    description = "Exige o item de braçadeiras configurado.",
                    label = "Braçadeiras exigem item",
                },
                ziptiesReturnOnRemove = {
                    description = "Devolve um item de braçadeiras quando são removidas.",
                    label = "Devolver braçadeiras",
                },
                evidenceGsrDurationSeconds = {
                    description = "Segundos resíduos de tiro ficam nas mãos de um jogador.",
                    label = "GSR duração",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Impedir GSR de ser aplicado quando o atirador usa luvas.",
                    label = "Luvas protegem as mãos",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Armas que não aplicam resíduos de pólvora.",
                    label = "Armas ignoradas",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Milissegundos entre verificações de limpeza de água / chuva enquanto GSR está ativo.",
                    label = "Intervalo de verificação da lavagem",
                },
                evidenceGsrWashInRain = {
                    description = "Deixe a chuva remover resíduos de pólvora.",
                    label = "Lavar na chuva",
                },
                evidenceGsrWashInWater = {
                    description = "Deixe a água remover resíduos de pólvora.",
                    label = "Lavar em água",
                },
                fakePlateHeliDisplay = {
                    label = "Helicam mostra placa falsa",
                    description = "Exibe a placa falsa na câmera do helicóptero.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Ferramentas normais mostram placa falsa",
                    description = "Exibe a placa falsa em ferramentas policiais padrão.",
                },
                fakePlateRadarDisplay = {
                    label = "Radar mostra placa falsa",
                    description = "Exibe a placa falsa no radar a bordo.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Permita que os sistemas policiais leiam a placa falsa compartilhada statebag.",
                    label = "Reconhecer placas falsas",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Veículo entidade statebag chave publicado pela Mechanicjob.",
                    label = "Chave do saco de estado",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Speedcam mostra placa falsa",
                    description = "Exibe a placa falsa em relatórios de radar fixos.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Opcional profession/grade allow-list. Deixe vazio para permitir todos os graus das profissões permitidas.",
                    label = "VIN graus",
                },
                fakePlateVinAllowedJobs = {
                    label = "VIN profissões",
                    description = "profissões autorizadas a usar a verificação VIN.",
                },
                fakePlateVinAudit = {
                    label = "Auditoria VIN verificações",
                    description = "Salva VIN verificações para o log de auditoria.",
                },
                fakePlateVinCheckEnabled = {
                    label = "VIN verificação habilitado",
                    description = "Permite o comando de verificação do veículo VIN.",
                },
                fakePlateVinCommand = {
                    label = "VIN comando",
                    description = "Comando usado para verificar VIN de um veículo.",
                },
                fakePlateVinCooldown = {
                    label = "VIN recarga",
                    description = "Atraso entre duas verificações VIN.",
                },
                fakePlateVinDistance = {
                    label = "VIN distância máxima",
                    description = "Distância máxima entre o oficial e o veículo para verificar a sua VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Mostrar o indicador falso",
                    description = "Exibe um indicador quando uma verificação detecta uma placa falsa.",
                },
                fakePlateVinRequireDuty = {
                    label = "Requerer o direito",
                    description = "Requer que o oficial esteja de plantão para verificar um VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Exigir item de scanner",
                    description = "Requer o objeto de scanner configurado para verificar um VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Item Scanner",
                    description = "Item de inventário necessário para verificar um VIN.",
                },
                jailRemoveJobOnJail = {
                    description = "Coloque o prisioneiro desempregado quando ele estiver preso.",
                    label = "Remover profissão na cadeia",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Restaurar a profissão original do prisioneiro após a libertação. Desativar para mantê-los desempregados.",
                    label = "Restaurar a profissão original",
                },
                primaryColor = {
                    description = "Cor padrão para o grupo de empregos da polícia.",
                    label = "Cor primária",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Permitir que os revisores faturam o proprietário registrado, mesmo quando a placa capturada é sinalizada como falsa ou clonada.",
                    label = "Permitir placas falsas suspeitas",
                },
                speedCamAdvancedPageSize = {
                    description = "Capturas máximas retornadas por página do tablet.",
                    label = "Tamanho da página de revisão",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Os lados do veículo cujas fotos podem ser usadas para o reconhecimento da placa. Use a frente e/ou a parte traseira.",
                    itemLabel = "Lado",
                    label = "Lados reconhecidos",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Apenas permita a aprovação após o upload da foto da câmera de velocidade concluída.",
                    label = "Exigir provas fotográficas",
                },
                speedCamAdvancedReviewPermission = {
                    description = "A permissão do Bossmenu necessária para aprovar ou descartar capturas. 18 é Gerenciar Faturamento.",
                    label = "Permissão de revisão ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Mantenha as capturas cuja placa não esteja presente na base de dados do veículo registado.",
                    label = "Armazenar veículos não registados",
                },
                tabletConfiscations = {
                    description = "Mostre o registro de itens confiscados durante as buscas dos jogadores.",
                    label = "Apreensões",
                },
                tabletSpeedcamReviews = {
                    description = "Mostre o aplicativo de revisão de câmera de velocidade avançada quando o modo avançado estiver ativado.",
                    label = "Avaliações de câmera de velocidade",
                },
                tackleCommand = {
                    description = "Comando registrado para atacar a pessoa mais próxima. Digite o nome do comando sem uma barra.",
                    label = "Enfrente o comando",
                },
                tackleCuffCommand = {
                    description = "Comando registrado para algemar a pessoa atualmente mantida após um tackle. Digite o nome do comando sem uma barra.",
                    label = "Comando do manguito",
                },
                tackleCuffDescription = {
                    description = "Descrição apresentada para a ligação do manguito do tackle no menu de ligações de teclas FiveM.",
                    label = "Descrição do keybind do manguito do tackle",
                },
                tackleDescription = {
                    description = "Descrição apresentada para a ligação de tackle no menu de ligações de teclas FiveM.",
                    label = "Tackle keybind descrição",
                },
                tackleEnabled = {
                    description = "Ative o contato com a pessoa mais próxima e segure-a no chão.",
                    label = "Derrubar",
                },
                tackleMaxDistance = {
                    description = "Distância máxima para o alvo ao iniciar um tackle.",
                    label = "Enfrente a distância",
                },
                tackleNeedsSprint = {
                    description = "Exigir que o oficial esteja correndo antes de atacar uma pessoa.",
                    label = "Tackle requer sprinting",
                },
                tackleReleaseCommand = {
                    description = "Comando registrado para liberar a pessoa atualmente mantida após um tackle. Digite o nome do comando sem uma barra.",
                    label = "Lidar com o comando de liberação",
                },
                tackleReleaseDescription = {
                    description = "Descrição exibida para a vinculação de liberação do tackle no menu de vinculações de teclas FiveM.",
                    label = "Tackle release keybind descrição",
                },
                tackleRequireOnDuty = {
                    description = "Exigir o estado do dever antes que um oficial possa atacar uma pessoa.",
                    label = "Enfrentar exige dever",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Comando usado para abrir ou fechar o editor de layout de radar. Digite o nome do comando sem uma barra.",
                    label = "Comando de layout de radar",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Comando usado para restaurar o layout padrão do radar. Digite o nome do comando sem uma barra.",
                    label = "Reiniciar o comando de layout do radar",
                },
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
            locationDescriptions = {
                jail_public_blip = "A posição é obtida automaticamente do ponto de aparecimento da prisão ou, se não estiver definido, do primeiro terminal da prisão.",
            },
            warnings = {
                cuffsConsumeRequiresItem = "As algemas de consumo não têm efeito enquanto a exigência do item do manguito estiver desativada.",
                wheelClampUseItemRequiresItem = "O Inventário do modo de uso da braçadeira ou ambos exigem que a braçadeira exija que o item permaneça ativado.",
                ziptiesConsumeRequiresItem = "Consumir zipties não tem efeito enquanto a exigência do item ziptie está desabilitada.",
            },
        },
    },
    JobConfiguratorImportFailed = "Não foi possível importar valores config.lua para '%s': %s.",
    JobConfiguratorImportHistoryFailed = "A importação foi bem-sucedida, mas sua entrada no histórico não pôde ser salva.",
    JobConfiguratorImportNoData = "'%s' não fornece dados de importação config.lua.",
    JobConfiguratorImportSuccess = "Valores de config.lua importados para '%s': %d profissões, %d configuração, %d recurso e %d desvios de interação aplicados.",
    JobConfiguratorTitle = "profissão Configurador",
    JobConfiguratorUnknown = "Configurador de profissão desconhecido.",
}
