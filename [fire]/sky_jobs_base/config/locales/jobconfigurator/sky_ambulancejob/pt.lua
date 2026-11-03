JobConfigLocales["sky_ambulancejob:pt"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Avaliações médicas",
                sharedMedicalEvaluations = "Avaliações médicas partilhadas",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Permitir respawn",
                        description = "Controla se esta cama pode ser usada para respawn de jogadores.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configure trabalhos de ambulância, camas hospitalares, sistemas de morte, interações e configurações de recursos principais.",
                    title = "Empregos de ambulância",
                },
            },
            dispatchActions = {
                currentLocation = "Usar a localização actual",
                addChannel = "Adicionar canal de rádio",
                addKeyword = "Adicionar palavra-chave",
                addPoi = "Adicionar ponto de interesse",
                addReporter = "Adicionar comunicante",
                addStatus = "Adicionar estado FMS",
                addVehicle = "Adicionar unidade virtual",
                addVehicleType = "Adicionar tipo de unidade",
            },
            dispatchFieldDescriptions = {
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
                minimumCrew = "Número mínimo de pessoas nas unidades seleccionadas para este plano de resposta.",
                noUnitFallback = "Sem um centro ou unidade de funcionários, envia uma notificação Sky para todos os membros em serviço.",
                radius = "Distância máxima em metros em que o anúncio da estação pode ser ouvido.",
                requirements = "Exigência de resposta como TIPO:COUNT pares, por exemplo PATROL:2,CRIME:1.",
                statusCode = "Estado numérico FMS mostrado no rádio portátil.",
                statusLabel = "Significado deste status FMS para expedidores e unidades.",
                vehicleType = "Deve corresponder a um código de tipo de veículo configurado na subsecção anterior.",
                vehicleTypeCode = "Código unitário curto utilizado nos requisitos de resposta, por exemplo PATROL, CRIME, EMS ou RESCUE.",
                vehicleTypeLabel = "Nome legível desta categoria de unidade.",
                crewCapacity = "Número máximo de pessoas que podem guarnecer a unidade. Use 0 para uma guarnição ilimitada.",
                joinLocked = "Impede a entrada de outras pessoas depois de a unidade estar guarnecida.",
                poiId = "Identificador técnico estável que os perfis da central mantêm mesmo após o local ser renomeado.",
                readyStatusCode = "Estado FMS aplicado quando o recurso fica disponível para despacho.",
                resourceType = "Classifica o recurso operacional para filtros e coordenação da central.",
                respondingStatusCode = "Estado FMS aplicado quando o recurso responde a uma ocorrência.",
                shortLabel = "Etiqueta curta opcional apresentada nas seis memórias de canais do rádio.",
                stationId = "Associa a unidade a uma estação configurada no perfil da central.",
                unitId = "Identificador técnico estável que preserva a unidade mesmo quando o indicativo muda.",
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
                defaultChannel = "Canal de rádio padrão",
                emergencyAppEnabled = "Mostrar na aplicação de emergência",
                enabled = "Activar a expedição",
                icon = "Ícone",
                incidentAssessmentEnabled = "Activar a avaliação de emergência",
                jobs = "Trabalhos de destino (separados por vírgulas)",
                keywordCode = "Código da palavra- chave",
                label = "Legenda",
                minimumCrew = "Tripulação mínima",
                name = "Nome",
                noUnitFallback = "Notificar o pessoal de serviço sem unidades",
                noneChannel = "Nenhum / grupo padrão",
                note = "Nota",
                phone = "Telefone",
                radius = "Raio de aviso",
                requirements = "Unidades necessárias (por exemplo PATROL:2,CRIME:1)",
                type = "Tipo",
                vehicleType = "Tipo de unidade de resposta",
                crewCapacity = "Capacidade da guarnição",
                joinLocked = "Bloquear entrada na guarnição",
                poiId = "ID estável do ponto de interesse",
                readyStatusCode = "Código de estado disponível",
                resourceType = "Tipo de recurso",
                respondingStatusCode = "Código de estado em resposta",
                shortLabel = "Etiqueta da memória do rádio",
                stationId = "ID da estação",
                unitId = "ID estável da unidade",
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
                    statuses = "FMS disponível",
                    units = "Unidades virtuais",
                    reporters = "Comunicantes conhecidos",
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
                dispatchStatusCodes = "Configura as etiquetas de status do FMS e quais status contam como disponíveis para novos incidentes.",
                dispatchVehicleTypes = "Define as categorias de unidades utilizadas pelos planos de resposta, tais como Patrulha, Unidade Criminal, EMS ou Resgate.",
                dispatchVehicles = "Define veículos de expedição virtual que podem ser com pessoal de qualquer lugar sem necessidade de um veículo gerado.",
                dispatchReporters = "Gere nomes de comunicantes, números de retorno e notas da central próprios deste emprego.",
            },
            extensions = {
                invalidSelection = "Seleção inválida: {value}",
                trainingSettings = {
                    description = "Configure o acesso ao treinamento, inscrições, aprovações e planejamento de cursos para este trabalho.",
                    label = "Configuração do treino",
                },
                dispatchReporters = "Comunicantes conhecidos",
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
            },
            features = {
                bleeding = {
                    description = "Ative o sistema de purga.",
                    label = "Sangramento",
                },
                bodybags = {
                    description = "Ative os sacos para cadáveres e os fluxos de entrega de sacos para cadáveres.",
                    label = "Sacos para corpos",
                },
                consciousScenarioBloodPressure = {
                    description = "Permitir verificações da pressão arterial enquanto o doente estiver consciente.",
                    label = "Pressão Arterial Consciente",
                },
                deathTimeout = {
                    description = "Ative o fluxo de tempo limite de morte.",
                    label = "Tempo limite da morte",
                },
                fractures = {
                    description = "Permita o manuseamento e tratamento de fraturas.",
                    label = "Fraturas",
                },
                knockout = {
                    description = "Active o sistema knockout.",
                    label = "Suprimir",
                },
                legShotRagdoll = {
                    description = "Faz o jogador cair ao ser atingido nas zonas configuradas das pernas ou pés.",
                    label = "Queda por tiro na perna",
                },
                pain = {
                    description = "Active o sistema de dor.",
                    label = "Dor",
                },
                respawnInBed = {
                    description = "Respawn reanimou jogadores numa cama de hospital, quando disponível.",
                    label = "Reaparecer na cama",
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
                gang = "Gangue",
                allowInVehicle = "Permitir no veículo",
                allowMovement = "Permitir movimento",
                animDict = "Dicionário de animação",
                animFlag = "Indicador de animação",
                animName = "Nome da animação",
                bleeding = "Sangramento",
                cause = "Causa",
                chance = "Probabilidade",
                class = "Classe",
                companyPrice = "Preço da empresa",
                companyPricePerEmployee = "Preço por funcionário",
                copayPercent = "% de copagamento",
                description = "Descrição",
                dictionary = "Dicionário de animação",
                duration = "Duração",
                durationMs = "Duração (ms)",
                effect = "Efeito",
                effectDurationMs = "Duração do efeito (ms)",
                effectDurationSeconds = "Duração do efeito (segundos)",
                enabled = "Ativado",
                extractionType = "Tipo de extração",
                foreignObject = "Objeto estranho",
                heal = "Cura",
                id = "ID",
                itemName = "Nome do artigo",
                key = "Chave",
                label = "Etiqueta",
                lang = "Idioma",
                limit = "Limite",
                lossPerSecond = "Perda por segundo",
                max = "Máximo",
                min = "Mínimo",
                minGrade = "Nota mínima",
                minigame = "Minijogo",
                model = "Modelo de adereço",
                name = "Nome do trabalho",
                options = "Opções (tipos de seleção)",
                pain = "Dor",
                pauseBleedingSeconds = "Pausar sangramento (segundos)",
                price = "Preço",
                progressbarAllowInVehicle = "Progresso: permitir no veículo",
                progressbarAllowMovement = "Progresso: permitir movimento",
                progressbarCanCancel = "Progresso cancelável",
                progressbarDisableCarMovement = "Progresso: bloquear veículo",
                progressbarDisableCombat = "Progresso: bloquear combate",
                progressbarDisableMouse = "Progresso: bloquear rato",
                progressbarDisableMovement = "Progresso: bloquear movimento",
                progressbarDisableSprint = "Progresso: bloquear corrida",
                progressbarDuration = "Duração do progresso",
                progressbarEnabled = "Barra de progresso ativada",
                progressbarLabel = "Texto de progresso",
                progressbarUseWhileDead = "Progresso utilizável morto",
                questions = "Perguntas",
                requireItems = "Exigir artigos",
                required = "Obrigatório",
                requiresExtraction = "Requer extração",
                requiresOpenWound = "Requer ferida aberta",
                sort = "Ordem",
                state = "Estado",
                stopBleeding = "Parar sangramento",
                threshold = "Limite",
                time = "Tempo",
                type = "Tipo",
                useAnimation = "Usar animação",
                value = "Valor",
                zone = "Zona",
                zones = "Zonas",
                systolic = "Pressão sistólica",
                diastolic = "Pressão diastólica",
                cardiacArrest = "Paragem cardíaca",
            },
            settingGroups = {
                billingGeneral = {
                    label = "Geral",
                },
                billingRange = {
                    label = "Intervalo",
                },
                billingReasons = {
                    label = "Predefinições de motivos",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animação",
                },
                bodyBagAttachGeneral = {
                    label = "Anexar",
                },
                bodyBagAttachOffsets = {
                    label = "Deslocamentos",
                },
                bodyBagAttachRotation = {
                    label = "Rotação",
                },
                bodyBagDeliveryGeneral = {
                    label = "Geral",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Geral",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Pagamento",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Geral",
                },
                crutchAssign = {
                    label = "Tarefa",
                },
                crutchDuration = {
                    label = "Duração",
                },
                crutchGeneral = {
                    label = "Geral",
                },
                crutchItems = {
                    label = "Artigo",
                },
                crutchRestrictions = {
                    label = "Restrições",
                },
                damageHandlingBladeWeapons = {
                    label = "Armas Lâminas",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Lista negra a sangrar",
                },
                damageHandlingBleedingClasses = {
                    label = "Aulas de sangramento",
                },
                damageHandlingBloodSystem = {
                    label = "Sistema Sanguíneo",
                },
                damageHandlingDeathInjuries = {
                    label = "Lesões de morte",
                },
                damageHandlingInjuryEffects = {
                    label = "Efeitos de lesões",
                },
                damageHandlingInjuryThresholds = {
                    label = "Limiares de Lesões",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll por tiro na perna",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zonas de tiro na perna",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Fraturas de Danos Vivos",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Hipóteses de Zona",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Pilhas de feridas abertas",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limites por zona",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Aulas de feridas ao vivo",
                },
                damageHandlingMedications = {
                    label = "Medicamentos",
                },
                damageHandlingPainClasses = {
                    label = "Aulas de dor",
                },
                damageHandlingPainEffects = {
                    label = "Efeitos da dor",
                },
                damageHandlingStatusEffects = {
                    label = "Efeitos de estado",
                },
                damageHandlingVehicleDamage = {
                    label = "Danos no veículo",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Causas de danos",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Lesões",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Proteção contra impactos de veículos",
                },
                deathAnimal = {
                    label = "Reserva Animal",
                },
                deathAnimalAnimation = {
                    label = "Animação Animal",
                },
                deathAnimation = {
                    label = "Animação",
                },
                deathGeneral = {
                    label = "Geral",
                },
                deathModels = {
                    label = "Substituições por modelo",
                },
                deathScreenAiMedic = {
                    label = "Geral",
                },
                deathScreenAiMedicAvailability = {
                    label = "Disponibilidade",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Comportamento",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Forçar Reviver",
                },
                deathScreenAiMedicPayment = {
                    label = "Pagamento",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Reviva na cama",
                },
                deathScreenAiMedicSpawn = {
                    label = "Gerar",
                },
                deathScreenAiMedicTiming = {
                    label = "Tempo",
                },
                deathScreenControls = {
                    label = "Controles",
                },
                deathScreenDamageLogs = {
                    label = "Registos de dano",
                },
                deathScreenDimensions = {
                    label = "Dimensões",
                },
                deathScreenDispatch = {
                    label = "Comunicação",
                },
                deathScreenEarlyRespawn = {
                    label = "Geral",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Disponibilidade",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Pagamento",
                },
                deathScreenGeneral = {
                    label = "Geral",
                },
                deathScreenHospitalSelection = {
                    label = "Seleção Hospitalar",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Câmara de seleção",
                },
                deathScreenInformation = {
                    label = "Geral",
                },
                deathScreenIntegration = {
                    label = "Integração",
                },
                deathScreenLogs = {
                    label = "Registos de morte",
                },
                deathScreenMinigame = {
                    label = "Minijogo",
                },
                deathScreenRespawn = {
                    label = "Geral",
                },
                deathScreenRespawnAccounts = {
                    label = "Contas",
                },
                deathScreenRespawnFallback = {
                    label = "Coordenadas substitutas",
                },
                deathScreenRespawnItems = {
                    label = "Artigos",
                },
                deathScreenRespawnWeapons = {
                    label = "Armas",
                },
                deathScreenStyle = {
                    label = "Estilo de ecrã da morte",
                },
                deathScreenVoice = {
                    label = "Voz",
                },
                deathTimeoutGeneral = {
                    label = "Geral",
                },
                deathTimeoutWhitelist = {
                    label = "Empregos na lista de permissões",
                },
                diagnoseAnim = {
                    label = "Animação",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Cura completa",
                },
                diagnoseGeneral = {
                    label = "Geral",
                },
                doctorNpcAvailability = {
                    label = "Disponibilidade",
                },
                doctorNpcGeneral = {
                    label = "Geral",
                },
                doctorNpcHealOther = {
                    label = "Curar outro",
                },
                doctorNpcHealSelf = {
                    label = "Curar-se a si mesmo",
                },
                doctorNpcRanges = {
                    description = "Estes intervalos não controlam o quão perto um jogador deve estar para abrir a interação do médico NPC. Só se aplicam depois de o menu médico ser aberto.",
                    label = "Intervalos",
                },
                doctorNpcRevive = {
                    label = "Reviver",
                },
                doctorNpcReviveInBed = {
                    label = "Reviva na cama",
                },
                firstAidAnimation = {
                    label = "Animação",
                },
                firstAidGeneral = {
                    label = "Geral",
                },
                firstAidLicenseAdd = {
                    label = "Adicionar licença",
                },
                firstAidLicenseRemove = {
                    label = "Licença Remover",
                },
                firstAidPosition = {
                    label = "Posição",
                },
                healthInsuranceExpiration = {
                    label = "Expiração",
                },
                healthInsuranceGeneral = {
                    label = "Geral",
                },
                healthInsurancePayment = {
                    label = "Pagamento",
                },
                healthInsuranceProviders = {
                    label = "Provedores",
                },
                hospitalBedsBedAnimation = {
                    label = "Animação de cama",
                },
                hospitalBedsCreator = {
                    label = "Criador",
                },
                hospitalBedsDistances = {
                    label = "Distâncias",
                },
                hospitalBedsGeneral = {
                    label = "Geral",
                },
                hospitalBedsGetupAnimation = {
                    label = "Animação de preparação",
                },
                hospitalBedsModels = {
                    label = "Modelos",
                },
                hospitalBedsOffsets = {
                    label = "Deslocamentos",
                },
                hospitalBlip = {
                    label = "Mensagem Hospitalar",
                },
                imagingGeneral = {
                    label = "Geral",
                },
                imagingRanges = {
                    label = "Intervalos",
                },
                keybinds = {
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                    label = "Teclas",
                },
                knockoutGeneral = {
                    label = "Geral",
                },
                knockoutWeapons = {
                    label = "Armas",
                },
                medicCarryAttach = {
                    label = "Anexar",
                },
                medicCarryAttachOffsets = {
                    label = "Deslocamentos",
                },
                medicCarryAttachRotation = {
                    label = "Rotação",
                },
                medicCarryCarrierAnimation = {
                    label = "Animação de portadora",
                },
                medicCarryGeneral = {
                    label = "Geral",
                },
                medicCarryPassengerAnimation = {
                    label = "Animação de Passageiros",
                },
                medicCarryRestrictions = {
                    label = "Restrições",
                },
                medicRevivePersistence = {
                    label = "Geral",
                },
                medicalEvaluationRecipients = {
                    label = "Profissões de destinatários",
                },
                medicalEvaluationSharing = {
                    label = "Campos Compartilhados",
                },
                medicalEvaluationTypes = {
                    label = "Tipos de avaliação",
                },
                medicalEvaluationsGeneral = {
                    label = "Geral",
                },
                medicalWearablesArmRestrictions = {
                    label = "Restrições do gesso no braço",
                },
                medicalWearablesCasts = {
                    label = "Gessos",
                },
                medicalWearablesDuration = {
                    label = "Duração de utilização",
                },
                medicalWearablesGeneral = {
                    label = "Geral",
                },
                medicalWearablesHeadBandage = {
                    label = "Ligadura da cabeça",
                },
                medicalWearablesLegRestrictions = {
                    label = "Restrições do gesso na perna",
                },
                medicalWearablesNeckBrace = {
                    label = "Colar cervical",
                },
                medicalWearablesOxygenMask = {
                    label = "Máscara de oxigénio",
                },
                medicalWearablesPatientHud = {
                    label = "HUD do paciente",
                },
                medicalWearablesRemoval = {
                    label = "Remoção",
                },
                medicalWearablesSplints = {
                    label = "Talas",
                },
                medicalWearablesTorsoBandage = {
                    label = "Ligadura do tronco",
                },
                minigamesCprGeneral = {
                    label = "Geral",
                },
                minigamesEnabled = {
                    label = "Habilitado",
                },
                minigamesVentilationGeneral = {
                    label = "Geral",
                },
                operationsAnesthesia = {
                    label = "Anestesia",
                },
                operationsDistances = {
                    label = "Distâncias",
                },
                operationsDoctorAnimation = {
                    label = "Animação do cirurgião",
                },
                operationsGeneral = {
                    label = "Geral",
                },
                operationsPatientAnimation = {
                    label = "Animação do paciente",
                },
                operationsTrainingAnimation = {
                    label = "Animação de treino",
                },
                propPlacement = {
                    label = "Colocação de adereços",
                },
                propPlacementItems = {
                    label = "Itens de adereços",
                },
                publicTreatmentGeneral = {
                    label = "Geral",
                },
                publicTreatmentJobs = {
                    label = "Empregos permitidos",
                },
                publicTreatmentRequirements = {
                    label = "Requisitos",
                },
                reviveRewardGeneral = {
                    label = "Geral",
                },
                reviveRewardPayment = {
                    label = "Pagamento",
                },
                selfDiagnoseGeneral = {
                    label = "Geral",
                },
                stretcherAnimation = {
                    label = "Animação",
                },
                stretcherCarryAttach = {
                    label = "Anexar transporte",
                },
                stretcherFolded = {
                    label = "Variante Dobrada",
                },
                stretcherFoldedPatientAttach = {
                    label = "Anexar Paciente Dobrado",
                },
                stretcherGeneral = {
                    label = "Geral",
                },
                stretcherHelicopter = {
                    label = "Helicóptero",
                },
                stretcherPatientAttach = {
                    label = "Anexar paciente",
                },
                stretcherTreatmentAnim = {
                    label = "Animação",
                },
                stretcherVehicleAttach = {
                    label = "Anexar veículo",
                },
                stretcherVehicleLists = {
                    label = "Modelos de veículos",
                },
                treatmentAnim = {
                    label = "Animação",
                },
                treatmentEnable = {
                    label = "Ativar",
                },
                trunk = {
                    label = "Tromba",
                },
                vehiclePullGeneral = {
                    label = "Geral",
                },
                wheelchairAssign = {
                    label = "Tarefa",
                },
                wheelchairDuration = {
                    label = "Duração",
                },
                wheelchairGeneral = {
                    label = "Geral",
                },
                wheelchairItems = {
                    label = "Artigo",
                },
                wheelchairRestrictions = {
                    label = "Restrições",
                },
                xrayGeneral = {
                    label = "Geral",
                },
                xrayRanges = {
                    label = "Intervalos",
                },
                appointmentsGeneral = {
                    label = "Geral",
                },
                appointmentsLimits = {
                    label = "Limites",
                },
                appointmentsNotifications = {
                    label = "Notificações",
                },
                appointmentsScheduling = {
                    label = "Agendamento",
                },
                healthCompatibility = {
                    label = "Compatibilidade Saúde",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Geral",
                },
                minigamesRandomization = {
                    label = "Randomização",
                },
            },
            settingSections = {
                billing = "Cobrança",
                bodyBag = "Saco para cadáveres",
                damageHandling = "Tratamento de danos",
                death = "Morte",
                deathScreen = "Ecrã da Morte",
                diagnose = "Diagnosticar",
                doctorNpc = "Doutor NPC",
                general = "Geral",
                healthInsurance = "Seguro Saúde",
                hospitalBeds = "Camas hospitalares",
                knockout = "Suprimir",
                medicCarry = "Transporte Médico",
                minigames = "Minijogos",
                mobilityAid = "Auxiliares de mobilidade",
                operations = "Operações",
                organization = "Organização",
                rewards = "Recompensas",
                treatment = "Tratamento",
                vehiclePull = "Puxar veículo",
            },
            settingSubsections = {
                aiMedic = "Médico de IA",
                anesthesia = "Anestesia",
                animation = "Animação",
                animations = "Animações",
                attach = "Anexar",
                bedAnimation = "Animação de cama",
                blood = "Sangue",
                bodyBagDeliveryReward = "Recompensa de entrega de saco corporal",
                carrierAnimation = "Animação de portadora",
                classification = "Classificação",
                cpr = "CPR",
                crutch = "Muleta",
                deathInjuries = "Lesões de morte",
                deathScreenStyle = "Estilo de ecrã da morte",
                deathTimeout = "Tempo limite da morte",
                delivery = "Entrega",
                diagnoseAnim = "Diagnosticar Animação",
                dispatch = "Comunicação",
                earlyRespawn = "Ressurgimento Antecipado",
                effects = "Efeitos",
                firstAid = "Primeiro socorro",
                general = "Geral",
                getupAnimation = "Animação de preparação",
                imaging = "Imagem",
                information = "Informação",
                keybinds = "Teclas",
                liveDamage = "Dano ao Vivo",
                logs = "Registos",
                medicRevivePersistence = "Medic Revive Persistência",
                medicalEvaluations = "Avaliações médicas",
                medicalWearables = "Dispositivos médicos",
                medications = "Medicamentos",
                minigame = "Minijogo",
                passengerAnimation = "Animação de Passageiros",
                pricing = "Preços",
                propPlacement = "Colocação de adereços",
                publicTreatment = "Tratamento Público",
                respawn = "Reaparecer",
                reviveInBed = "Reviva na cama",
                reviveReward = "Recompensa de reviver",
                selfDiagnose = "Autodiagnóstico",
                stretcher = "Esticador",
                stretcherTreatmentAnim = "Animação de tratamento de maca",
                thresholds = "Limites",
                treatmentAnim = "Animação de Tratamento",
                trunk = "Tromba",
                vehicleImpact = "Impacto do veículo",
                ventilation = "Ventilação",
                wheelchair = "Cadeira de rodas",
                xray = "X-Ray",
                appointments = "Nomeações",
                bloodTransfusion = "Transfusão de Sangue",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Editor · Controlo 172",
                    description = "Configura: Editor: Mover para cima.",
                },
                ambulanceEditorControl173 = {
                    label = "Editor · Controlo 173",
                    description = "Configura: Editor: Mover para baixo.",
                },
                ambulanceEditorControl174 = {
                    label = "Editor · Controlo 174",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl175 = {
                    label = "Editor · Controlo 175",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl177 = {
                    label = "Editor · Controlo 177",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl201 = {
                    label = "Editor · Controlo 201",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl202 = {
                    label = "Editor · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl21 = {
                    label = "Editor · Controlo 21",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl32 = {
                    label = "Editor · Controlo 32",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl33 = {
                    label = "Editor · Controlo 33",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl34 = {
                    label = "Editor · Controlo 34",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl35 = {
                    label = "Editor · Controlo 35",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl36 = {
                    label = "Editor · Controlo 36",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl37 = {
                    label = "Editor · Controlo 37",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl38 = {
                    label = "Editor · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceEditorControl44 = {
                    label = "Editor · Controlo 44",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Primeiros socorros · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interação · Controlo 177",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interação · Controlo 201",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interação · Controlo 202",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interação · Controlo 21",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interação · Controlo 241",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interação · Controlo 242",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interação · Controlo 25",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interação · Controlo 32",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interação · Controlo 33",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interação · Controlo 34",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interação · Controlo 35",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interação · Controlo 36",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interação · Controlo 38",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interação · Controlo 44",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                billingAccount = {
                    description = "Conta legada da sociedade substituta utilizada para cobrança.",
                    label = "Conta",
                },
                billingCloseOnSuccess = {
                    description = "Feche a IU de faturação automaticamente após uma fatura bem-sucedida.",
                    label = "Perto do sucesso",
                },
                billingCurrency = {
                    description = "Chave de moeda opcional utilizada para pagamentos de cobrança.",
                    label = "Moeda",
                },
                billingCustomBillingReasons = {
                    description = "Permita que os médicos introduzam motivos de faturação personalizados.",
                    label = "Motivos personalizados",
                },
                billingDepositToSociety = {
                    description = "Deposite a receita da faturação na conta da sociedade.",
                    label = "Depósito para a sociedade",
                },
                billingEnabled = {
                    description = "Active o sistema de faturação médica.",
                    label = "Habilitado",
                },
                billingMaxReasonLength = {
                    description = "Duração máxima dos motivos de faturação personalizados.",
                    label = "Comprimento máximo do motivo",
                },
                billingMode = {
                    description = "Escolha se as contas médicas serão cobradas instantaneamente, se exigirão confirmação ou se utilizará o sistema de faturação estrutural.",
                    label = "Modo de cobrança",
                    options = {
                        consent = "Pagar ou recusar",
                        framework = "Projeto de lei-quadro",
                        instant = "Carga instantânea",
                    },
                },
                billingRange = {
                    description = "Alcance máximo para encontrar pacientes faturáveis.",
                    label = "Intervalo",
                },
                billingReasonPresets = {
                    description = "Motivos de cobrança predefinidos apresentados na IU de cobrança.",
                    itemLabel = "Razão",
                    label = "Predefinições de motivo",
                },
                billingRefreshSeconds = {
                    description = "Segundos entre atualizações de jogadores faturáveis.",
                    label = "Atualizar segundos",
                },
                bladeWeapons = {
                    description = "Nomes de armas ou hashes que devem ser classificados como dano de faca em vez de contundente.",
                    itemLabel = "Arma",
                    label = "Armas de lâmina",
                },
                bleedingBlacklist = {
                    description = "Armas que nunca devem causar hemorragias vivas ou feridas abertas.",
                    itemLabel = "Arma",
                    label = "Lista negra a sangrar",
                },
                bleedingClassesProfiles = {
                    description = "Perfis de gravidade da hemorragia e a sua taxa de perda de sangue.",
                    label = "Aulas de sangramento",
                },
                bloodSystemDebugLogInterval = {
                    description = "Segundos entre mensagens de registo de depuração do sistema sanguíneo.",
                    label = "Intervalo de registo de depuração",
                },
                bloodSystemMaxVolume = {
                    description = "Valor máximo do volume sanguíneo utilizado pelo sistema de estado do paciente.",
                    label = "Volume máximo",
                },
                bloodSystemRegenPerSecond = {
                    description = "Regeneração sanguínea passiva aplicada quando o paciente não está a sangrar ativamente.",
                    label = "Regeneração por segundo",
                },
                bloodSystemTickIntervalMs = {
                    description = "Intervalo de tick do servidor utilizado para atualizações de perda de sangue e recuperação.",
                    label = "Intervalo de tick ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Limiar de volume sanguíneo abaixo do qual o doente fica inconsciente.",
                    label = "Limiar inconsciente",
                },
                bodyBagAnimationDict = {
                    description = "Dicionário de animação utilizado para transportar um saco para cadáveres.",
                    label = "Dicionário de animação",
                },
                bodyBagAnimationEnabled = {
                    description = "Utilize uma animação de transporte dedicada ao transportar um saco para cadáveres.",
                    label = "Habilitado",
                },
                bodyBagAnimationFlag = {
                    description = "Sinalizador TaskPlayAnim utilizado para a animação de transporte.",
                    label = "Bandeira de animação",
                },
                bodyBagAnimationName = {
                    description = "Clip de animação utilizado para transportar um saco para cadáveres.",
                    label = "Nome da animação",
                },
                bodyBagAttachBone = {
                    description = "Nome do osso Ped ou ID do osso utilizado para a fixação do saco corporal.",
                    label = "Osso",
                },
                bodyBagAttachRx = {
                    description = "Bolsa para corpo anexa rotação X.",
                    label = "Anexar RX",
                },
                bodyBagAttachRy = {
                    description = "Saco corporal com rotação em Y.",
                    label = "Anexar RY",
                },
                bodyBagAttachRz = {
                    description = "Saco corporal com rotação Z.",
                    label = "Anexar RZ",
                },
                bodyBagAttachX = {
                    description = "Bolsa para corpo anexa com deslocamento X.",
                    label = "Anexar X",
                },
                bodyBagAttachY = {
                    description = "Bolsa para corpo anexa deslocamento em Y.",
                    label = "Anexar Y",
                },
                bodyBagAttachZ = {
                    description = "Bolsa para corpo anexa com deslocamento Z.",
                    label = "Anexar Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Chave de localidade utilizada para o aviso de ajuda para a entrega do saco para cadáveres.",
                    label = "Chave do rótulo de ajuda",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distância utilizada para validação da entrega do saco mortuário.",
                    label = "Distância de interação",
                },
                bodyBagDeliveryInteractKey = {
                    description = "ID de controlo utilizada para interações de entrega de sacos para cadáveres.",
                    label = "Chave de interação",
                },
                bodyBagDeliveryInteraction = {
                    description = "Chave do modelo de interação utilizada para a entrega de sacos para cadáveres.",
                    label = "Modelo de interação",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Exigir que os médicos entreguem os sacos para cadáveres em pontos de entrega configurados.",
                    label = "Exigir entrega",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Exigir que os médicos estejam de serviço antes da entrega do saco corporal.",
                    label = "Exigir plantão",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Chave de conta primária utilizada para recompensas de entrega de sacos para cadáveres.",
                    label = "Conta",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Tipo de conta principal utilizado para recompensas de entrega de sacos para cadáveres.",
                    label = "Tipo de conta",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Valor da recompensa paga pela entrega de um saco para cadáveres.",
                    label = "Montante",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para recompensas de entrega de sacos para cadáveres.",
                    label = "Moeda",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Paga uma recompensa configurada após a conclusão da entrega do saco para cadáveres.",
                    label = "Habilitado",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Deduza as recompensas de entrega de sacos para cadáveres da sociedade de trabalho partilhado antes de pagar ao médico.",
                    label = "Pagamento da sociedade",
                },
                bodyBagEnabled = {
                    description = "Ative o sistema de saco corporal.",
                    label = "Habilitado",
                },
                bodyBagHidePatient = {
                    description = "Esconda o doente enquanto o saco para cadáveres está preso.",
                    label = "Ocultar paciente",
                },
                bodyBagModel = {
                    description = "Modelo de suporte utilizado para sacos para cadáveres.",
                    label = "Modelo",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha aplicado ao paciente enquanto o corpo estava ensacado.",
                    label = "Paciente alfa",
                },
                crutchAssignMaxDistance = {
                    description = "Distância máxima para atribuir uma muleta a outro jogador.",
                    label = "Atribuir distância máxima",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Desequipa automaticamente a muleta quando a tarefa expirar.",
                    label = "Desequipar automaticamente ao expirar",
                },
                crutchClipset = {
                    description = "Clipset de movimento aplicado durante a utilização da canadiana.",
                    label = "Conjunto de clipes",
                },
                crutchDefaultDurationMinutes = {
                    description = "Duração da canadiana atribuída padrão em minutos.",
                    label = "Duração padrão",
                },
                crutchDisableSprint = {
                    description = "Bloqueie a corrida enquanto uma canadiana estiver equipada.",
                    label = "Desativar corrida",
                },
                crutchDisableWeapons = {
                    description = "Bloqueie o uso de armas enquanto uma muleta estiver equipada.",
                    label = "Desativar armas",
                },
                crutchItemName = {
                    description = "Artigo de inventário utilizado para a muleta.",
                    label = "Nome do artigo",
                },
                crutchMaxDurationMinutes = {
                    description = "Duração máxima permitida da atribuição da canadiana em minutos.",
                    label = "Duração máxima",
                },
                crutchMinDurationMinutes = {
                    description = "Duração mínima permitida da atribuição da canadiana em minutos.",
                    label = "Duração mínima",
                },
                crutchProp = {
                    description = "Modelo de suporte utilizado para a canadiana.",
                    label = "Suporte",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Segundos durante os quais os golpes são reunidos numa mensagem.",
                    label = "Intervalo de agrupamento",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Número máximo de golpes individuais numa mensagem do Discord.",
                    label = "Golpes por mensagem",
                },
                damageLogsEnabled = {
                    description = "Enviar para o Discord golpes não letais confirmados pelo servidor.",
                    label = "Registos de dano",
                },
                deathAnimalAnimationDictionary = {
                    description = "Dicionário de animação utilizado para a animação de morte de reserva de animal.",
                    label = "Dicionário de animais",
                },
                deathAnimalAnimationName = {
                    description = "Clip de animação utilizado para a animação de morte de reserva animal.",
                    label = "Nome da animação animal",
                },
                deathAnimalUseAnimation = {
                    description = "Permita que o substituto do animal configurado utilize uma animação de morte com script.",
                    label = "Animação animal",
                },
                deathAnimationDictionary = {
                    description = "Dicionário de animação utilizado para a animação de morte padrão.",
                    label = "Dicionário de animação",
                },
                deathAnimationName = {
                    description = "Clipe de animação utilizado para a animação de morte padrão.",
                    label = "Nome da animação",
                },
                deathInjuriesProfiles = {
                    description = "Perfis de lesões aplicados quando um jogador morre por uma causa específica.",
                    itemLabel = "Lesão",
                    label = "Lesões de morte",
                },
                deathModels = {
                    description = "Substituir o comportamento da animação de morte por modelo ped ou hash de modelo.",
                    label = "Substituições de modelo",
                },
                deathScreenAiMedicAccount = {
                    description = "Conta principal cobrada pelo médico AI.",
                    label = "Conta",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Segundos adicionados ao temporizador de hemorragia quando o médico AI é solicitado.",
                    label = "Adicionar cronómetro de morte",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Permita que o médico AI reviva feridas fatais.",
                    label = "Permitir ferimentos fatais",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distância a que o médico AI pára e se aproxima a pé.",
                    label = "Distância de aproximação",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Tempo de espera antes que o médico AI possa ser chamado novamente.",
                    label = "Segundos de arrefecimento",
                },
                deathScreenAiMedicCurrency = {
                    description = "Chave de moeda opcional utilizada para pagamentos médicos de IA.",
                    label = "Moeda",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Formatador de moeda utilizado para pagamentos médicos de IA.",
                    label = "Formatador de moeda",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Segundos antes do médico AI desaparecer após terminar.",
                    label = "Atraso no desaparecimento",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Atraso antes do início do envio médico da IA.",
                    label = "Atraso no envio",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Velocidade de condução utilizada pelo veículo médico AI.",
                    label = "Velocidade de condução",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Tempo máximo de acionamento antes dos disparos de reanimação forçada.",
                    label = "Tempo limite da unidade",
                },
                deathScreenAiMedicEnabled = {
                    description = "Ative o fluxo de resgate médico de IA.",
                    label = "Habilitado",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Conta alternativa utilizada quando a conta médica primária da IA ​​não tem fundos suficientes.",
                    label = "Conta substituta",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Force uma reanimação se o médico da IA ​​​​não conseguir alcançar o jogador.",
                    label = "Forçar reavivamento ativado",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "O médico AI só funciona enquanto os médicos de serviço estiverem nessa contagem ou abaixo dela.",
                    label = "Max médicos on-line",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Duração máxima da missão antes dos disparos de reanimação forçada.",
                    label = "Tempo limite da missão",
                },
                deathScreenAiMedicPedModel = {
                    description = "Modelo Ped utilizado para o médico AI.",
                    label = "Modelo pediátrico",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Destino usado quando o jogador abatido chama o médico de IA.",
                    label = "Destino do pedido do jogador",
                    options = {
                        hospital = "Hospital",
                        location = "Localização atual",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Preço cobrado por ligar para o médico da IA.",
                    label = "Preço",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Segundos após a morte do jogador antes de um médico poder oferecer um médico de IA remoto.",
                    label = "Espera do despacho remoto",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Permita que os médicos enviem o médico AI para um jogador caído a partir do mapa de despacho e do comando /aimedic.",
                    label = "Envio remoto",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "O envio médico remoto por IA só funciona enquanto os médicos em serviço estiverem nessa contagem ou abaixo dela.",
                    label = "Despacho remoto máximo de médicos online",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Destino usado quando um médico de IA remoto é enviado e aceite.",
                    label = "Destino do despacho remoto",
                    options = {
                        hospital = "Hospital",
                        location = "Localização atual",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Segundos disponíveis para o jogador aceitar uma oferta de médico de IA remoto.",
                    label = "Tempo limite da oferta remota",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Distância necessária antes que o médico AI comece a reanimar.",
                    label = "Reviva a distância",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Segundos gastos a reviver o jogador.",
                    label = "Duração de reviver",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Teletransporta o jogador para uma cama de hospital em vez de reviver no local.",
                    label = "Reviva na cama",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Raio de busca utilizado para encontrar uma cama de reanimação.",
                    label = "Raio de pesquisa de camas",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Segundos após a morte, antes de o médico AI estar disponível.",
                    label = "Segundos até estar disponível",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Raio máximo de spawn do médico AI.",
                    label = "Raio de desova máximo",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Raio mínimo de spawn do médico AI.",
                    label = "Raio de desova mínimo",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Modelo de veículo utilizado pelo médico AI.",
                    label = "Modelo do veículo",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Modo de voz enquanto inconsciente: nenhum, ouvir ou completo.",
                    label = "Modo de voz",
                    options = {
                        full = "cheio",
                        listen = "escutar",
                        none = "nenhum",
                    },
                },
                deathScreenAllowedControls = {
                    description = "IDs de controlo que permanecem ativados enquanto inconsciente.",
                    label = "Controles permitidos",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Os jogadores reaparecem automaticamente se o tempo de sangramento já tiver expirado enquanto ele estava desligado.",
                    label = "Reconexão expirada de respawn automático",
                },
                deathScreenBackgroundEnd = {
                    description = "Cor final do fundo da tela da morte.",
                    label = "Fim do fundo",
                },
                deathScreenBackgroundStart = {
                    description = "Cor inicial do fundo do ecrã da morte.",
                    label = "Início em segundo plano",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Segundos antes do temporizador de sangramento expirar.",
                    label = "Temporizador de sangramento",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensões onde o fluxo de reaparecimento do ecrã da morte está bloqueado.",
                    label = "Dimensões bloqueadas",
                },
                deathScreenBorderColor = {
                    description = "Cor da borda usada pela tela da morte.",
                    label = "Cor da borda",
                },
                deathScreenDispatchEnabled = {
                    description = "Envie eventos de despacho do fluxo do ecrã de morte.",
                    label = "Envio ativado",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Destinatários alternativos quando nenhum destinatário principal está vivo e em serviço. Deixe vazio para alertar sempre os empregos principais.",
                    itemLabel = "Emprego",
                    label = "Empregos de reserva",
                },
                deathScreenDispatchJobs = {
                    description = "Empregos alertados quando um jogador incapacitado pede ajuda.",
                    itemLabel = "Emprego",
                    label = "Empregos alertados",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Conta principal cobrada pelo reaparecimento antecipado.",
                    label = "Conta",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Mantenha o reaparecimento antecipado disponível mesmo para ferimentos fatais.",
                    label = "Permitir ferimentos fatais",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Chave de moeda opcional utilizada para pagamentos de reaparecimento antecipado.",
                    label = "Moeda",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Formatador de moeda utilizado para pagamentos antecipados de respawn.",
                    label = "Formatador de moeda",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Active o reaparecimento antecipado pago.",
                    label = "Habilitado",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Conta alternativa utilizada quando a conta principal não tem fundos suficientes.",
                    label = "Conta substituta",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Etiqueta opcional apresentada para o pagamento de respawn antecipado.",
                    label = "Etiqueta de pagamento",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Preço cobrado por um reaparecimento antecipado.",
                    label = "Preço",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "Permita o reaparecimento antecipado apenas quando não há médicos de serviço.",
                    label = "Não requer médicos",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Segundos após a morte antes do reaparecimento antecipado ficar disponível.",
                    label = "Segundos até estar disponível",
                },
                deathScreenEnableKeyboard = {
                    description = "Permitir o uso do teclado no ecrã da morte.",
                    label = "Ativar teclado",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Back-end de voz externo para silenciar quando ativado.",
                    label = "Sistema de voz externo",
                    options = {
                        saltychat = "bate-papo salgado",
                        yaca = "yacá",
                    },
                },
                deathScreenFocusKey = {
                    label = "Interação com rato no ecrã de morte",
                    description = "Tecla predefinida do FiveM, por exemplo E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Vazio significa sem tecla predefinida. Os jogadores podem alterar as teclas nas definições do FiveM; as atribuições pessoais guardadas são preservadas.",
                },
                deathScreenHandlingMode = {
                    description = "Utiliza a animação de morte estática ou mantém a física ragdoll natural até o corpo estabilizar.",
                    label = "Tratamento da morte",
                    options = {
                        natural = "Natural",
                        static = "Estático",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Oculta o ecrã da morte quando ESPAÇO muda para os controlos do jogo; desative para manter a interface visível anterior.",
                    label = "Ocultar interface com controlos do jogo",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Deslocamento de altura aplicado ao alvo de focagem da câmara.",
                    label = "Altura do foco",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Visualize o campo de visão da câmara.",
                    label = "Campo de visão",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Deslocamento de direção utilizado ao posicionar a câmara de visualização.",
                    label = "Deslocamento de direção",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Deslocamento de altura aplicado à câmara de visualização.",
                    label = "Altura da câmara",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Pitch aplicado à câmara de visualização.",
                    label = "Nível",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distância da câmara de visualização até ao ponto de spawn.",
                    label = "Raio da câmara",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Utilize uma transição suave ao abrir a câmara de seleção de hospital.",
                    label = "Transição suave",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Permita que os jogadores selecionem um hospital antes de reaparecer.",
                    label = "Seleção de hospitais",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Mostrar seleção de hospital apenas quando existe mais do que um hospital.",
                    label = "Requer vários hospitais",
                },
                deathScreenInformationEnabled = {
                    description = "Mostre o bloco de informação no ecrã da morte.",
                    label = "Habilitado",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Mostre a causa da morte no bloco de informação do ecrã de morte.",
                    label = "Mostrar causa de morte",
                },
                deathScreenInformationShowInjuries = {
                    description = "Mostrar ferimentos no bloco de informação do ecrã da morte.",
                    label = "Mostrar lesões",
                },
                deathScreenInformationShowKiller = {
                    description = "Mostra o nome do assassino no bloco de informação do ecrã da morte.",
                    label = "Mostrar assassino",
                },
                deathScreenInformationShowWeapon = {
                    description = "Mostra a arma no bloco de informação do ecrã da morte.",
                    label = "Mostrar arma",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangues autorizadas",
                    description = "Selecione nomes internos de gangues ou organizações independentes. Um emprego ou gangue correspondente concede a permissão ou isenção. O serviço é exigido apenas para empregos.",
                    itemLabel = "Gangue",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Os trabalhos têm permissão para ver informações alargadas do ecrã de morte.",
                    itemLabel = "Trabalho",
                    label = "Empregos na lista de permissões",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Máximo de segundos permitido para carregar cada captura de morte.",
                    label = "Tempo limite da captura",
                },
                deathScreenLogScreenshots = {
                    description = "Carregar as perspetivas da vítima e do assassino confirmado após o registo de texto.",
                    label = "Capturas de ecrã",
                },
                deathScreenLogsEnabled = {
                    description = "Enviar um registo para o Discord sempre que um jogador morrer.",
                    label = "Registos de morte",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distância em metros utilizada para contar um médico como próximo.",
                    label = "Raio próximo do médico",
                },
                deathScreenMinigameEnabled = {
                    description = "Ativa o minijogo da tela da morte.",
                    label = "Habilitado",
                },
                deathScreenMinigameUrl = {
                    description = "URL aberto para o minijogo do ecrã da morte.",
                    label = "URL do minijogo",
                },
                deathScreenMode = {
                    description = "Utiliza o ecrã de morte integrado ou uma integração externa.",
                    label = "Modo do ecrã",
                    options = {
                        external = "Externo",
                        internal = "Interno",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Silencie os sistemas de voz externos enquanto o jogador estiver morto.",
                    label = "Silenciar voz externa",
                },
                deathScreenMutedTextColor = {
                    description = "Cor de texto silenciada utilizada pelo ecrã da morte.",
                    label = "Cor do texto silenciada",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Mostra motivos detalhados no cliente e no servidor enquanto o corpo permanece em ragdoll.",
                    label = "Depuração do ragdoll natural",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Estabiliza automaticamente os corpos imóveis ou exige que um socorrista de serviço os coloque na posição lateral de segurança.",
                    label = "Estabilização natural",
                    options = {
                        automatic = "Automática",
                        medic = "Socorrista obrigatório",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Cor de fundo do painel utilizada pelo ecrã da morte.",
                    label = "Fundo do painel",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Bloqueia o reaparecimento automático após hemorragia.",
                    label = "Impedir o reaparecimento automático",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Bloqueie o reaparecimento automático enquanto um médico estiver por perto.",
                    label = "Bloquear quando o médico estiver por perto",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "O bloco revive após o tempo de hemorragia expirar.",
                    label = "Evitar reviver ao expirar",
                },
                deathScreenPrimaryColor = {
                    description = "Cor CSS base utilizada para o tema do ecrã da morte.",
                    label = "Cor primária",
                },
                deathScreenPrimaryDark = {
                    description = "Cor de destaque mais escura opcional para o ecrã da morte.",
                    label = "Escuro primário",
                },
                deathScreenPrimaryStrong = {
                    description = "Cor de destaque mais forte opcional para o ecrã da morte.",
                    label = "Primário forte",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Rumo utilizado quando a estação não tem rumo definido.",
                    label = "Título padrão",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Título de reaparecimento alternativo utilizado quando não existem posições hospitalares.",
                    label = "Título alternativo",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Coordenada X de respawn de fallback utilizada quando não existem posições hospitalares.",
                    label = "Reserva X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Coordenada Y de respawn de fallback utilizada quando não existem posições hospitalares.",
                    label = "Reserva Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Coordenada Z de respawn de fallback utilizada quando não existem posições hospitalares.",
                    label = "Reserva Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Escolha um hospital fixo para respawns. Deixe-o vazio para utilizar o hospital mais próximo.",
                    label = "Hospital de reaparecimento",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Remova os saldos das contas ao reaparecer.",
                    label = "Remover contas",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Nomes de contas removidos no respawn.",
                    itemLabel = "Conta",
                    label = "Nomes de contas",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Remova os itens do inventário ao reaparecer.",
                    label = "Remover itens",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Artigos de inventário mantidos no reaparecimento.",
                    itemLabel = "Artigo",
                    label = "Itens ignorados",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Remova as armas da roda de armas quando reaparecer.",
                    label = "Remover armas",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Armas mantidas em respawn.",
                    itemLabel = "Arma",
                    label = "Armas ignoradas",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Teletransporta o jogador para um hospital quando reaparecer.",
                    label = "Teletransporte para o hospital",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Retome o temporizador de purga após voltar a ligar, em vez de o reiniciar.",
                    label = "Retomar ao voltar a ligar",
                },
                deathScreenShadowLight = {
                    description = "Cor de sombra suave utilizada pela tela da morte.",
                    label = "Luz sombra",
                },
                deathScreenShadowMid = {
                    description = "Cor da sombra intermédia usada pela tela da morte.",
                    label = "Sombra no meio",
                },
                deathScreenShowNearestMedic = {
                    description = "Mostre o médico mais próximo no ecrã da morte.",
                    label = "Mostrar médico mais próximo",
                },
                deathScreenTextColor = {
                    description = "Cor do texto principal utilizada pelo ecrã da morte.",
                    label = "Cor do texto",
                },
                deathScreenTextShadow = {
                    description = "Cor da sombra do texto utilizada pela tela da morte.",
                    label = "Sombra de texto",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Aplique também o tempo limite de morte após a revivificação de nocaute.",
                    label = "Aplicar no nocaute",
                },
                deathTimeoutSeconds = {
                    description = "Segundos após uma reanimação, este combate permanece desativado.",
                    label = "Segundos",
                },
                deathTimeoutShowUi = {
                    description = "Mostrar o banner de contagem decrescente do tempo limite de morte enquanto estiver ativo.",
                    label = "Mostrar interface do utilizador",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangues autorizadas",
                    description = "Selecione nomes internos de gangues ou organizações independentes. Um emprego ou gangue correspondente concede a permissão ou isenção. O serviço é exigido apenas para empregos.",
                    itemLabel = "Gangue",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Trabalhos isentos das restrições de tempo limite de morte.",
                    itemLabel = "Trabalho",
                    label = "Empregos na lista de permissões",
                },
                deathUseAnimation = {
                    description = "Reproduza a animação de morte configurada para peds suportados.",
                    label = "Usar animação",
                },
                diagnoseAnimClip = {
                    description = "Clipe de animação utilizado ao abrir o diagnóstico. Deixe em branco para utilizar um cenário.",
                    label = "Nome da animação",
                },
                diagnoseAnimDict = {
                    description = "Dicionário de animação utilizado ao abrir o diagnóstico. Deixe em branco para utilizar um cenário.",
                    label = "Dicionário de animação",
                },
                diagnoseAnimScenario = {
                    description = "Cenário utilizado ao abrir o diagnóstico. Deixe em branco para usar dict + clip.",
                    label = "Cenário",
                },
                diagnoseCprAnimDict = {
                    description = "Dicionário de animação utilizado para RCP.",
                    label = "Dicionário de animação",
                },
                diagnoseCprAnimName = {
                    description = "Clipe de animação utilizado para RCP.",
                    label = "Nome da animação",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Tempo contínuo de diagnóstico necessário antes de mostrar a cura completa.",
                    label = "Atraso em segundos",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Exigir mochila de resgate",
                    description = "Exigir rescue_backpack para mostrar a barra esquerda de ferramentas de exame. Desative para mostrar sempre a barra; os requisitos de itens de cada ferramenta continuam válidos.",
                },
                diagnoseFullHealEnabled = {
                    description = "Permite a cura completa após uma sessão contínua de diagnóstico.",
                    label = "Ativado",
                },
                diagnoseInteractDistance = {
                    description = "Distância máxima necessária para diagnosticar ou levar o cadáver de um paciente.",
                    label = "Distância de interação",
                },
                diagnosePatientMovementMode = {
                    label = "Movimento do paciente",
                    description = "Imobilize o paciente enquanto outro jogador estiver com o menu de tratamento aberto, ou permita o movimento e feche o menu ao exceder a distância de tratamento. O autodiagnóstico é configurado separadamente.",
                    options = {
                        freeze = "Imobilizar paciente",
                        distance = "Fechar ao exceder a distância",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Distância de tratamento (m)",
                    description = "Distância máxima entre quem trata e o paciente antes de fechar o menu no modo de distância. A distância de abertura é configurada separadamente.",
                },
                diagnoseKey = {
                    description = "ID de controlo utilizado para diagnosticar interações.",
                    label = "Chave de interação",
                },
                diagnoseOpenDelayMs = {
                    description = "Atraso antes de a IU de diagnóstico ser aberta.",
                    label = "Atraso aberto ms",
                },
                diagnosePromptDistance = {
                    description = "Distância utilizada para mostrar o pedido de diagnóstico.",
                    label = "Distância imediata",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Duração utilizada para animações de tratamento.",
                    label = "Duração do tratamento ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Deposite os pagamentos do médico na conta da sociedade partilhada ao cobrar diretamente.",
                    label = "Adicione receita à sociedade",
                },
                doctorNpcEnabled = {
                    description = "Ative o serviço médico NPC.",
                    label = "Habilitado",
                },
                doctorNpcHealOtherAccount = {
                    description = "Chave de conta primária utilizada para cobrar a cura de outro jogador.",
                    label = "Conta",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Tipo de conta principal utilizado para cobrar a cura de outro jogador.",
                    label = "Tipo de conta",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para cobrar a cura de outro jogador.",
                    label = "Moeda",
                },
                doctorNpcHealOtherPrice = {
                    description = "Preço para curar outro jogador no NPC médico.",
                    label = "Preço",
                },
                doctorNpcHealSelfAccount = {
                    description = "Chave de conta primária utilizada para cobrar a autocorreção.",
                    label = "Conta",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Tipo de conta principal utilizado para a cobrança de autocorreção.",
                    label = "Tipo de conta",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para cobrar a autocorreção.",
                    label = "Moeda",
                },
                doctorNpcHealSelfPrice = {
                    description = "Preço para se curar no médico NPC.",
                    label = "Preço",
                },
                doctorNpcInteractionRange = {
                    description = "Quão perto o utilizador deve estar do NPC médico enquanto utiliza o menu médico aberto. Isto não altera a distância inicial do prompt do NPC.",
                    label = "Faixa de interação",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "O Doutor NPC só funciona enquanto os médicos de serviço estiverem abaixo desse limite.",
                    label = "Max médicos on-line",
                },
                doctorNpcPatientRange = {
                    description = "Quão próximo o paciente deve estar do NPC médico para curar outro ou reviver para trabalhar após selecionar a ação.",
                    label = "Faixa de doentes",
                },
                doctorNpcPaymentMode = {
                    description = "Cobre os jogadores imediatamente ou envie uma fatura.",
                    label = "Modo de pagamento",
                    options = {
                        bill = "conta",
                        remove = "remover",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Utilizado apenas para listar jogadores próximos na interface do médico NPC. Não permite o tratamento por si só.",
                    label = "Alcance de varrimento do jogador",
                },
                doctorNpcReviveAccount = {
                    description = "Chave de conta primária utilizada para cobrar reanimações médicas.",
                    label = "Conta",
                },
                doctorNpcReviveAccountType = {
                    description = "Tipo de conta principal utilizado para cobrar reanimações médicas.",
                    label = "Tipo de conta",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Permite que o médico NPC reanime ferimentos fatais ou não reanimáveis. O tempo de hemorragia expirado continua a bloquear a reanimação.",
                    label = "Permitir ferimentos fatais",
                },
                doctorNpcReviveCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para cobrar reanimações médicas.",
                    label = "Moeda",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Coloque os jogadores reanimados na cama do hospital mais próximo após a reanimação do médico.",
                    label = "Habilitado",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Distância máxima utilizada para encontrar uma cama de hospital próxima para reanimações médicas.",
                    label = "Raio de pesquisa",
                },
                doctorNpcRevivePrice = {
                    description = "Preço para reviver um jogador no NPC médico.",
                    label = "Preço",
                },
                firstAidActionDurationMs = {
                    description = "Quanto tempo demora a ação de primeiros socorros.",
                    label = "Duração da ação ms",
                },
                firstAidAnimationDict = {
                    description = "Dicionário de animação utilizado durante a ação de primeiros socorros.",
                    label = "Dicionário de animação",
                },
                firstAidAnimationFlag = {
                    description = "Bandeira TaskPlayAnim utilizada durante a ação de primeiros socorros.",
                    label = "Bandeira de animação",
                },
                firstAidAnimationName = {
                    description = "Clip de animação utilizado durante a ação de primeiros socorros.",
                    label = "Nome da animação",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Segundos adicionados ao temporizador de sangramento do paciente após os primeiros socorros.",
                    label = "Segundos de extensão de hemorragia",
                },
                firstAidEnabled = {
                    description = "Ative o recurso de primeiros socorros para jogadores licenciados.",
                    label = "Primeiros socorros ativados",
                },
                firstAidLicense = {
                    description = "Nome da licença-quadro utilizada para validar o acesso aos primeiros socorros.",
                    label = "Nome da licença",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Permitir que a equipa de ambulância conceda a licença de primeiros socorros.",
                    label = "Adicionar licença ativada",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Mostrar a ação adicionar licença no menu radial.",
                    label = "Adicionar licença radial",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Exija o dever de EMS antes que a ação de adição de licença possa ser utilizada.",
                    label = "Adicionar licença exige dever",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Permitir que a equipa da ambulância remova a licença de primeiros socorros.",
                    label = "Remover licença ativada",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Mostrar a ação de remoção de licença no menu radial.",
                    label = "Remover licença radial",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Exija o dever de EMS antes que a ação de remoção de licença possa ser utilizada.",
                    label = "Remover licença exige dever",
                },
                firstAidPositionChestOffset = {
                    description = "Deslocamento do tórax utilizado durante o alinhamento para primeiros socorros.",
                    label = "Deslocamento do peito",
                },
                firstAidPositionSideOffset = {
                    description = "Deslocamento lateral utilizado durante o alinhamento para primeiros socorros.",
                    label = "Deslocamento lateral",
                },
                firstAidPositionZOffset = {
                    description = "Deslocamento vertical utilizado durante o alinhamento para primeiros socorros.",
                    label = "Deslocamento Z",
                },
                firstAidRequireLicense = {
                    description = "Exija a licença de primeiros socorros configurada antes de um jogador poder utilizar os primeiros socorros.",
                    label = "Exigir licença",
                },
                firstAidTargetDistance = {
                    description = "Distância máxima permitida para utilização de primeiros socorros.",
                    label = "Distância alvo",
                },
                healthInsuranceAccount = {
                    description = "Chave de conta de substituição utilizada para pagamentos de seguros.",
                    label = "Conta",
                },
                healthInsuranceAccountType = {
                    description = "Tipo de conta principal utilizada para pagamentos de seguros.",
                    label = "Tipo de conta",
                },
                healthInsuranceAvailableDays = {
                    description = "Durações de seguro disponíveis em dias.",
                    label = "Dias disponíveis",
                },
                healthInsuranceCommand = {
                    description = "Comando de chat utilizado para abrir a IU do seguro de saúde.",
                    label = "Comando",
                },
                healthInsuranceCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para pagamentos de seguros.",
                    label = "Moeda",
                },
                healthInsuranceEnabled = {
                    description = "Active o sistema de seguro de saúde.",
                    label = "Habilitado",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Permite que funcionários autorizados alterem os preços dos seguros no tablet. Desative para aplicar os preços da tabela de provedores abaixo.",
                    label = "Gestão de preços no tablet",
                },
                healthInsuranceProviders = {
                    description = "Fornecedores de seguros oferecidos aos jogadores.",
                    itemLabel = "Provedor",
                    label = "Provedores",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Utiliza os mesmos fornecedores e apólices para todos os trabalhos registados neste recurso de ambulância.",
                    label = "Partilhar entre trabalhos de ambulância",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Dicionário de animação em loop enquanto o jogador está deitado na cama. Deixe em branco para utilizar o substituto padrão da animação de morte.",
                    label = "Dicionário de animação",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Duração manual opcional para a animação da cama em loop. Utilizado apenas quando uma animação de cama personalizada é configurada.",
                    label = "Duração ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Sinalizador TaskPlayAnim utilizado para a animação da cama em loop. Utilizado apenas quando uma animação de cama personalizada é configurada.",
                    label = "Bandeira de animação",
                },
                hospitalBedsBedAnimationName = {
                    description = "Clip de animação repetido enquanto o jogador está deitado na cama. Deixe em branco para utilizar o substituto padrão da animação de morte.",
                    label = "Nome da animação",
                },
                hospitalBedsBreakDistance = {
                    description = "Distância após a qual o jogador é forçado a sair da cama.",
                    label = "Quebrar distância",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Visualize o modelo ped utilizado no editor de posição da cama hospitalar.",
                    label = "Modelo ped criador",
                },
                hospitalBedsEnabled = {
                    description = "Ative as interações configuradas com camas hospitalares.",
                    label = "Habilitado",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Dicionário de animação reproduzido quando o jogador se levanta da cama. Deixe em branco para utilizar o comportamento stand-up padrão.",
                    label = "Dicionário de animação",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Duração manual opcional para a animação de preparação. Utilizado apenas quando está configurada uma animação de apresentação personalizada.",
                    label = "Duração ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Sinalizador TaskPlayAnim utilizado para a animação inicial. Utilizado apenas quando uma animação de apresentação personalizada está configurada.",
                    label = "Bandeira de animação",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Clip de animação reproduzido quando o jogador se levanta da cama. Deixe em branco para utilizar o comportamento stand-up padrão.",
                    label = "Nome da animação",
                },
                hospitalBedsHeadingOffset = {
                    description = "Deslocamento de rumo aplicado ao colocar o jogador na cama.",
                    label = "Deslocamento de direção",
                },
                hospitalBedsHeightOffset = {
                    description = "Deslocamento vertical aplicado ao colocar o leitor na cama.",
                    label = "Deslocamento de altura",
                },
                hospitalBedsInteractDistance = {
                    description = "Distância máxima necessária para utilizar uma cama hospitalar.",
                    label = "Distância de interação",
                },
                hospitalBedsInteractKey = {
                    description = "ID de controlo utilizada para entrar ou sair de uma cama hospitalar.",
                    label = "Chave de interação",
                },
                hospitalBedsModels = {
                    description = "Modelos de objetos mundiais tratados como camas hospitalares utilizáveis.",
                    itemLabel = "Modelo",
                    label = "Modelos de cama",
                },
                hospitalBedsSearchRadius = {
                    description = "Raio utilizado para encontrar suportes de cama próximos ou camas configuradas.",
                    label = "Raio de pesquisa",
                },
                hospitalBlipColor = {
                    description = "ID da cor do Blip utilizado para blips de mapas hospitalares.",
                    label = "Cor",
                },
                hospitalBlipEnabled = {
                    description = "Mostrar ícones do mapa do hospital para as posições hospitalares configuradas.",
                    label = "Habilitado",
                },
                hospitalBlipName = {
                    description = "Nome da mensagem do hospital substituto utilizado quando não está disponível nenhum nome de estação.",
                    label = "Nome",
                },
                hospitalBlipScale = {
                    description = "Escala de blips utilizada para blips de mapas hospitalares.",
                    label = "Balança",
                },
                hospitalBlipSprite = {
                    description = "ID do sprite do Blip utilizado para os blips do mapa hospitalar.",
                    label = "Sprite",
                },
                imagingInteractionRange = {
                    description = "Distância máxima da estação de imagem ao operador.",
                    label = "Faixa de interação",
                },
                imagingPatientRange = {
                    description = "Distância máxima da estação de imagem ao paciente.",
                    label = "Faixa de doentes",
                },
                imagingScanDurationSeconds = {
                    description = "Duração em segundos para resultados de tomografia computorizada e ressonância magnética.",
                    label = "Duração da verificação",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Multiplicador apenas visual para efeitos de sobreposição de hemorragia.",
                    label = "Intensidade de sobreposição de hemorragia",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Multiplicador apenas visual para efeitos de ecrã de dor.",
                    label = "Intensidade da tela de dor",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Percentagem mínima da saúde máxima perdida num único golpe antes de ser aplicado o sangramento e a dor.",
                    label = "Percentagem mínima de hemorragia/dor",
                },
                injuryThresholdRespectArmor = {
                    description = "Ignore a hemorragia e a dor quando o golpe for absorvido pela armadura.",
                    label = "Respeite a armadura",
                },
                knockoutRegenerateDamage = {
                    description = "Regenera o dano de nocaute após o tempo de reaparecimento expirar.",
                    label = "Regenerar dano",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Segundos durante os quais o dano de nocaute é curado.",
                    label = "Duração da regeneração",
                },
                knockoutRespawnSeconds = {
                    description = "Segundos antes de um reaparecimento automático quando um jogador é nocauteado.",
                    label = "Segundos de reaparecimento",
                },
                knockoutWeapons = {
                    description = "Nomes de armas ou hashes que devem desencadear o nocaute em vez do ecrã completo da morte.",
                    itemLabel = "Arma",
                    label = "Armas",
                },
                legShotRagdollChance = {
                    description = "Percentagem de chance de um impacto valido ativar ragdoll.",
                    label = "Probabilidade",
                },
                legShotRagdollCooldownMs = {
                    description = "Atraso minimo entre ragdolls por tiro na perna.",
                    label = "Cooldown ms",
                },
                legShotRagdollDebug = {
                    description = "Regista decisoes de ragdoll para testes.",
                    label = "Depurar",
                },
                legShotRagdollDurationMs = {
                    description = "Quanto tempo o ragdoll dura.",
                    label = "Duracao ms",
                },
                legShotRagdollFeet = {
                    description = "Permite que impactos nos pes ativem o ragdoll.",
                    label = "Pes",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Ignora ragdoll quando a armadura absorveu o impacto.",
                    label = "Ignorar impactos na armadura",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Permite impactos na perna inferior esquerda.",
                    label = "Perna inferior esquerda",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Permite impactos na perna superior esquerda.",
                    label = "Perna superior esquerda",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Apenas tiros podem ativar o ragdoll.",
                    label = "Apenas tiros",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Permite impactos na perna inferior direita.",
                    label = "Perna inferior direita",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Permite impactos na perna superior direita.",
                    label = "Perna superior direita",
                },
                liveDamageFracturesChance = {
                    description = "Possibilidade básica de que um dano consciente cause uma fratura.",
                    label = "Sorte",
                },
                liveDamageFracturesEnabled = {
                    description = "Permitir que os danos conscientes rolem fraturas.",
                    label = "Habilitado",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Percentagem mínima da vida máxima perdida num golpe antes de poder ocorrer uma fratura.",
                    label = "Percentagem mínima de dano",
                },
                liveDamageFracturesZones = {
                    description = "Probabilidades de fratura por zona para danos reais.",
                    label = "Hipóteses de zona",
                },
                liveOpenWoundStacksDefault = {
                    description = "Numero maximo de pilhas de feridas abertas por zona sem substituicao.",
                    label = "Limite predefinido",
                },
                liveOpenWoundStacksZones = {
                    description = "Limites opcionais de pilhas de feridas abertas por zona.",
                    itemLabel = "Zona",
                    label = "Limites por zona",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Classe de sangramento inicial aplicada por causa de dano vivo.",
                    label = "Aula de sangramento de feridas vivas",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Permite ao transportador entrar e conduzir um veículo sem largar o doente.",
                    label = "Permitir transportador no veículo",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Permitir transportar jogadores conscientes.",
                    label = "Permitir alvos conscientes",
                },
                medicCarryAllowSprint = {
                    description = "Permita correr enquanto carrega um doente.",
                    label = "Permitir sprint",
                },
                medicCarryAttachBone = {
                    description = "Índice ósseo utilizado para prender o jogador transportado.",
                    label = "Anexar osso",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Carregue a rotação do passo do anexo.",
                    label = "Nível",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Carregue a rotação do rolo de fixação.",
                    label = "Rolo",
                },
                medicCarryAttachOffsetsX = {
                    description = "Carregue o deslocamento X do anexo.",
                    label = "Deslocamento X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Transporte o deslocamento Y do anexo.",
                    label = "Deslocamento Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Carregue a rotação de guinada.",
                    label = "Guinada",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Transporte o deslocamento Z do anexo.",
                    label = "Deslocamento Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Dicionário de animação utilizado pelo médico enquanto transporta um paciente.",
                    label = "Dicionário de animação",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Sinalizador TaskPlayAnim utilizado pela animação de transporte médico.",
                    label = "Bandeira de animação",
                },
                medicCarryCarrierAnimationName = {
                    description = "Clip de animação utilizado pelo médico enquanto carregava um paciente.",
                    label = "Nome da animação",
                },
                medicCarryEnabled = {
                    description = "Active o sistema de transporte médico.",
                    label = "Habilitado",
                },
                medicCarryMaxDistance = {
                    description = "Distância máxima necessária para recolher um paciente.",
                    label = "Distância máxima",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Dicionário de animação utilizado pelo doente transportado.",
                    label = "Dicionário de animação",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Sinalizador TaskPlayAnim utilizado pela animação do paciente transportada.",
                    label = "Bandeira de animação",
                },
                medicCarryPassengerAnimationName = {
                    description = "Clip de animação utilizado pelo doente transportado.",
                    label = "Nome da animação",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Reaplique a animação de morte após deixar cair um doente inconsciente.",
                    label = "Reaplicar animação de morte",
                },
                medicCarryRequireOnDuty = {
                    description = "Apenas os médicos de serviço podem iniciar o transporte.",
                    label = "Exigir plantão",
                },
                medicReviveAllowFatalWounds = {
                    description = "Permite que médicos em serviço tratem e reanimem ferimentos fatais ou não reanimáveis. O tempo de hemorragia expirado continua a bloquear a reanimação.",
                    label = "Permitir ferimentos fatais",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Mantenha as lesões não resolvidas após o tratamento ou a lista de verificação ser revivida.",
                    label = "Mantenha lesões",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Manter os valores de dor após o tratamento ou o checklist revive quando as lesões são preservadas.",
                    label = "Mantenha a dor",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Distância máxima usada para listar jogadores próximos ao criar uma avaliação médica.",
                    label = "Alcance próximo do paciente",
                },
                medicalEvaluationRecipientJobs = {
                    description = "profissões para as quais as avaliações médicas podem ser emitidas e compartilhadas.",
                    label = "Profissões de destinatários",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Permita que as profissões receptoras vejam a data de nascimento do paciente.",
                    label = "Data de nascimento:",
                },
                medicalEvaluationShareConclusion = {
                    description = "Permita que as profissões receptoras vejam a conclusão médica.",
                    label = "Conclusão da partilha",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Permita que as profissões receptoras vejam quais tipos de avaliação foram realizados.",
                    label = "Partilhar tipos de avaliação",
                },
                medicalEvaluationShareFullName = {
                    description = "Permita que as profissões receptoras vejam o nome completo do paciente.",
                    label = "Partilhar o nome completo",
                },
                medicalEvaluationShareGender = {
                    description = "Permitir que as profissões receptoras vejam o sexo do paciente.",
                    label = "Partilhar o género",
                },
                medicalEvaluationShareHeight = {
                    description = "Permita que as profissões receptoras vejam a altura do paciente.",
                    label = "Compartilhar altura",
                },
                medicalEvaluationShareHobbies = {
                    description = "Permita que as profissões receptoras vejam as atividades de lazer e hobbies do paciente.",
                    label = "Compartilhe lazer e hobbies",
                },
                medicalEvaluationShareIssuer = {
                    description = "Mostrar o nome do autor. O emprego emissor permanece visível como pasta nos documentos partilhados.",
                    label = "Partilhar dados do autor",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Permita que as profissões receptoras vejam o ID pessoal do paciente.",
                    label = "Compartilhar pessoal ID",
                },
                medicalEvaluationShareProfession = {
                    description = "Permitir que as profissões receptoras vejam a profissão do paciente.",
                    label = "Partilhar profissão",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Permita que as profissões receptoras vejam perguntas do questionário e respostas gravadas.",
                    label = "Compartilhe perguntas e respostas",
                },
                medicalEvaluationShareResult = {
                    description = "Permitir que as profissões receptoras para ver se a avaliação está pendente, passou ou falhou.",
                    label = "Partilhar o resultado",
                },
                medicalEvaluationShareWeight = {
                    description = "Permita que as profissões receptoras vejam o peso do paciente.",
                    label = "Partilhar peso",
                },
                medicalEvaluationTypes = {
                    description = "Configure tipos de avaliação, perguntas, tipos de resposta e se cada pergunta está ativa.",
                    label = "Tipos de avaliação e questionários",
                    options = {
                        boolean = "Sim / Não",
                        boolean_text = "Sim / Não com detalhes",
                        date = "Data",
                        multi_select = "Múltipla escolha",
                        number = "Número",
                        rating = "Classificação",
                        select = "Escolha única",
                        text = "Texto",
                        textarea = "Área de texto",
                        time = "Hora",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Ativar avaliações médicas no comprimido de ambulância.",
                    label = "Ativado",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Oferece uma duração permanente que fica ativa até um médico remover o dispositivo.",
                    label = "Permitir até à remoção",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Impede ataques corpo a corpo enquanto é usado um gesso no braço.",
                    label = "Desativar combate corpo a corpo",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Força o jogador a ficar desarmado e impede a troca de arma enquanto é usado um gesso no braço.",
                    label = "Desativar armas",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Aplica restrições de combate enquanto é usado um gesso no braço.",
                    label = "Ativado",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Trata a fratura correspondente ao aplicar um gesso ou uma tala.",
                    label = "Integração de fraturas",
                },
                medicalWearablesCastsEnabled = {
                    description = "Permite gessos nos braços e pernas esquerdos e direitos.",
                    label = "Ativado",
                },
                medicalWearablesCastsItem = {
                    description = "Objeto do inventário consumido ao aplicar um gesso.",
                    label = "Objeto",
                },
                medicalWearablesCastsMinigame = {
                    description = "Minijogo de tratamento existente utilizado para gessos.",
                    label = "Minijogo",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Duração predefinida do dispositivo médico em minutos. Define 0 para ficar ativo até à remoção.",
                    label = "Minutos predefinidos",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Durações dos dispositivos médicos apresentadas aos médicos, em minutos.",
                    label = "Opções de duração",
                },
                medicalWearablesEnabled = {
                    description = "Ativa os modelos de gesso, tala, ligadura, colar e máscara de oxigénio na interface de tratamento.",
                    label = "Ativado",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Frequência com que os dispositivos médicos temporizados expirados são removidos.",
                    label = "Verificação de expiração (segundos)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Permite o modelo de ligadura da cabeça.",
                    label = "Ativado",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Objeto do inventário consumido para uma ligadura da cabeça.",
                    label = "Objeto",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Minijogo de tratamento existente utilizado para uma ligadura da cabeça.",
                    label = "Minijogo",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Impede saltar enquanto é usado um gesso na perna.",
                    label = "Desativar salto",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Impede correr enquanto é usado um gesso na perna.",
                    label = "Desativar corrida",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Força o conjunto de animações de movimento ferido enquanto é usado um gesso na perna.",
                    label = "Forçar marcha ferida",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Substitui a velocidade de movimento enquanto é usado um gesso na perna.",
                    label = "Velocidade de movimento",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Aplica restrições de movimento enquanto é usado um gesso na perna.",
                    label = "Ativado",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Permite o modelo de colar cervical.",
                    label = "Ativado",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Objeto do inventário consumido para um colar cervical.",
                    label = "Objeto",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Minijogo de tratamento existente utilizado para um colar cervical.",
                    label = "Minijogo",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Permite o modelo de máscara de oxigénio.",
                    label = "Ativado",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Objeto do inventário consumido para uma máscara de oxigénio.",
                    label = "Objeto",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Minijogo de tratamento existente utilizado para uma máscara de oxigénio.",
                    label = "Minijogo",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Mostra ao paciente os dispositivos médicos ativos e o tempo de utilização restante.",
                    label = "Ativado",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Escolhe onde o HUD de dispositivos médicos do paciente é apresentado.",
                    label = "Posição",
                    options = {
                        ["bottom-center"] = "Inferior ao centro",
                        ["bottom-left"] = "Inferior esquerdo",
                        ["bottom-right"] = "Inferior direito",
                        center = "Centro",
                        ["center-left"] = "Centro à esquerda",
                        ["center-right"] = "Centro à direita",
                        ["top-center"] = "Superior ao centro",
                        ["top-left"] = "Superior esquerdo",
                        ["top-right"] = "Superior direito",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Restaura gessos, talas, colares cervicais e ligaduras do tronco temporizados após novas ligações e reinícios do recurso.",
                    label = "Persistência dos dispositivos médicos",
                },
                medicalWearablesRemoval = {
                    description = "Permite aos médicos remover gessos, talas, colares e ligaduras do tronco ativos na interface de tratamento.",
                    label = "Remoção por médicos",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Mostra a remoção de dispositivos médicos com a ferramenta configurada na interface de tratamento.",
                    label = "Tratamento de remoção ativado",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Ferramenta reutilizável do inventário necessária para remover um dispositivo médico.",
                    label = "Objeto",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Minijogo para remover dispositivos médicos (cast_saw por predefinição).",
                    label = "Minijogo",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Permite talas de suporte nos braços esquerdo e direito.",
                    label = "Ativado",
                },
                medicalWearablesSplintsItem = {
                    description = "Objeto do inventário consumido ao aplicar uma tala.",
                    label = "Objeto",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Minijogo de tratamento existente utilizado para talas.",
                    label = "Minijogo",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Permite o modelo de ligadura do tronco.",
                    label = "Ativado",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Objeto do inventário consumido para uma ligadura do tronco.",
                    label = "Objeto",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Minijogo de tratamento existente utilizado para uma ligadura do tronco.",
                    label = "Minijogo",
                },
                medicationsProfiles = {
                    description = "Registos declarativos de medicamentos utilizados para tratamento e automedicação.",
                    itemLabel = "Medicamento",
                    label = "Medicamentos",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Active o minijogo de máscara de válvula de bolsa.",
                    label = "Máscara de válvula de saco",
                },
                minigamesCastSawEnabled = {
                    description = "Ativa o minijogo da serra para remover dispositivos médicos.",
                    label = "Serra de gesso",
                },
                minigamesBandageWrapEnabled = {
                    description = "Ative o minijogo de embrulho de bandagem.",
                    label = "Envoltório de bandagem",
                },
                minigamesBloodPressureEnabled = {
                    description = "Ative o minijogo da pressão arterial.",
                    label = "Pressão arterial",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Ative o minijogo de transfusão de sangue.",
                    label = "Transfusão de Sangue",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Ative o minijogo de extração de balas.",
                    label = "Extração de bala",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Respirações necessárias durante cada fase de ventilação.",
                    label = "Respirações por ciclo",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Segundos para completar um conjunto de compressão.",
                    label = "Duração da compressão por conjunto",
                },
                minigamesCprCompressionWindow = {
                    description = "Deslocamento permitido ao atingir uma batida de compressão.",
                    label = "Janela de compressão",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Ative o estágio do minijogo de compressões de RCP.",
                    label = "Compressões de RCP",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Número de compressões por série.",
                    label = "Compressões por série",
                },
                minigamesCprCycles = {
                    description = "Quantos ciclos de RCP são necessários para terminar o minijogo.",
                    label = "Ciclos",
                },
                minigamesCprEnabled = {
                    description = "Active o minijogo de RCP.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Contagem decrescente antes do início das compressões de RCP.",
                    label = "Segundos de atraso de introdução",
                },
                minigamesCprMaxMisses = {
                    description = "Erros permitidos antes de falhar o minijogo de RCP.",
                    label = "Max erra",
                },
                minigamesCprSetsPerCycle = {
                    description = "Quantas séries de compressão são realizadas antes de uma fase de respiração.",
                    label = "Conjuntos por ciclo",
                },
                minigamesCprVentilationEnabled = {
                    description = "Ative o estágio do minijogo de ventilação de RCP.",
                    label = "Ventilação de RCP",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Ative o minijogo do medidor de glicose.",
                    label = "Medidor de glicose",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Ative o minijogo de medição do pulso.",
                    label = "Medição de pulso",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Ative o minijogo do oxímetro de pulso.",
                    label = "Oxímetro de pulso",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Ative o minijogo de infusão salina.",
                    label = "Infusão Salina",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Segundos antes de uma tentativa de ventilação expirar. Defina 0 para desativar.",
                    label = "Segundos de tempo limite de respiração",
                },
                minigamesVentilationEnabled = {
                    description = "Ative o minijogo de ventilação.",
                    label = "Ventilação",
                },
                minigamesVentilationTolerance = {
                    description = "Tolerância da distância do pixel ao traçar a onda do fluxo de ar.",
                    label = "Tolerância",
                },
                operationsBreakDistance = {
                    description = "Distância máxima dos participantes ao bloco antes de interromper o procedimento.",
                    label = "Distância de interrupção",
                },
                operationsDoctorAnimationDict = {
                    description = "Dicionário de animações GTA usado pelo cirurgião durante uma intervenção real.",
                    label = "Dicionário de animação do cirurgião",
                },
                operationsDoctorAnimationFlag = {
                    description = "Sinalizador de animação GTA aplicado ao cirurgião durante uma intervenção real.",
                    label = "Sinalizador da animação do cirurgião",
                },
                operationsDoctorAnimationName = {
                    description = "Clip de animação usado pelo cirurgião durante uma intervenção real.",
                    label = "Nome da animação do cirurgião",
                },
                operationsEnabled = {
                    description = "Ativa os blocos operatórios e os procedimentos cirúrgicos.",
                    label = "Ativado",
                },
                operationsFadeInMs = {
                    description = "Duração em milissegundos do aparecimento do ecrã do paciente ao despertar.",
                    label = "Aparecimento ao despertar (ms)",
                },
                operationsFadeOutMs = {
                    description = "Duração em milissegundos do desvanecimento do ecrã do paciente durante a anestesia.",
                    label = "Desvanecimento da anestesia (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Tempo máximo sem uma ação válida no minijogo antes de a sessão ser abortada.",
                    label = "Limite de inatividade (s)",
                },
                operationsInteractDistance = {
                    description = "Distância máxima para mostrar e usar as interações do bloco operatório.",
                    label = "Distância de interação",
                },
                operationsInteractKey = {
                    description = "ID de controlo usado para interagir com a mesa de operações e a posição do cirurgião.",
                    label = "Tecla de interação",
                },
                operationsPatientAnimationDict = {
                    description = "Dicionário de animações GTA usado enquanto o paciente está sob anestesia geral.",
                    label = "Dicionário de animação do paciente",
                },
                operationsPatientAnimationFlag = {
                    description = "Sinalizador de animação GTA aplicado à animação do paciente deitado.",
                    label = "Sinalizador da animação do paciente",
                },
                operationsPatientAnimationName = {
                    description = "Clip de animação usado enquanto o paciente está sob anestesia geral.",
                    label = "Nome da animação do paciente",
                },
                operationsPatientRange = {
                    description = "Raio máximo usado para detetar um paciente deitado na mesa de operações.",
                    label = "Raio do paciente",
                },
                operationsRequireOnDuty = {
                    description = "Exige que os cirurgiões estejam em serviço antes de usar um bloco operatório.",
                    label = "Exigir serviço",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Tempo máximo durante o qual o cirurgião pode permanecer na seleção da operação antes de a sessão ser abortada.",
                    label = "Limite de seleção (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Dicionário de animações GTA usado no treino cirúrgico sem paciente.",
                    label = "Dicionário de animação de treino",
                },
                operationsTrainingAnimationFlag = {
                    description = "Sinalizador de animação GTA aplicado à animação de treino cirúrgico.",
                    label = "Sinalizador da animação de treino",
                },
                operationsTrainingAnimationName = {
                    description = "Clip de animação usado no treino cirúrgico sem paciente.",
                    label = "Nome da animação de treino",
                },
                painClassesProfiles = {
                    description = "Limiares de dor, rótulos e efeitos pós-processamento.",
                    label = "Aulas de dor",
                },
                painEffectsMinPainLevel = {
                    description = "Nível mínimo de dor antes do início dos efeitos da tela de dor.",
                    label = "Nível mínimo de dor",
                },
                primaryColor = {
                    description = "Cor principal da interface EMS e do grupo de empregos de socorro.",
                    label = "Cor primária",
                },
                propPlacementConsumeItem = {
                    description = "Consumir o item de inventário correspondente quando o acessório é colocado.",
                    label = "Consumir item",
                },
                propPlacementEnabled = {
                    description = "Permitir que os acessórios EMS configurados sejam colocados a partir de artigos de inventário utilizáveis.",
                    label = "Habilitado",
                },
                propPlacementItemNames = {
                    description = "Mapear modelos de suporte EMS para nomes de artigos de inventário para posicionamento baseado em artigos.",
                    label = "Nomes de artigos de acessórios",
                },
                propPlacementRequireOnDuty = {
                    description = "Exija que o jogador esteja de serviço antes de colocar acessórios EMS.",
                    label = "Exigir plantão",
                },
                propPlacementReturnItem = {
                    description = "Devolva o artigo consumido quando um acessório colocado for removido.",
                    label = "Devolver item ao remover",
                },
                propPlacementVehicleAccess = {
                    description = "Permitir que os adereços de tronco abram o fluxo de posicionamento em vez da utilização apenas de itens.",
                    label = "Acesso de veículos",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Permitir o tratamento público de jogadores conscientes.",
                    label = "Permitir aos doentes conscientes",
                },
                publicTreatmentAllowedGangs = {
                    label = "Gangues permitidas",
                    description = "Selecione nomes internos de gangues ou organizações independentes. Um emprego ou gangue correspondente concede a permissão ou isenção. O serviço é exigido apenas para empregos. Patentes mínimas opcionais. Uma lista vazia permite todas as patentes. Os requisitos de itens continuam válidos.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Empregos que podem utilizar tratamento público sem serem EMS.",
                    label = "Trabalhos permitidos",
                },
                publicTreatmentEnabled = {
                    description = "Ative o tratamento público para os inquiridos que não são do SEM com acesso válido.",
                    label = "Tratamento público ativado",
                },
                publicTreatmentInteractDistance = {
                    description = "Distância máxima necessária para iniciar o tratamento público.",
                    label = "Distância de interação",
                },
                publicTreatmentKeybind = {
                    description = "Atalho de tecla de interação padrão utilizado para tratamento público.",
                    label = "Teclado",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Mostra o aviso de tratamento e ativa a tecla correspondente. Desative esta opção ao usar exports ou um menu radial personalizado.",
                    label = "Interação por teclado ativada",
                },
                publicTreatmentPromptDistance = {
                    description = "Distância utilizada para mostrar o aviso de tratamento público.",
                    label = "Distância imediata",
                },
                publicTreatmentRequireAllItems = {
                    description = "Exija todos os itens médicos listados em vez de apenas um.",
                    label = "Exigir todos os artigos",
                },
                publicTreatmentRequiredItems = {
                    description = "Artigos de inventário que contam como equipamento de tratamento público válido.",
                    itemLabel = "Artigo",
                    label = "Itens obrigatórios",
                },
                reviveRewardAccount = {
                    description = "Chave de conta primária utilizada para reavivar os pagamentos de recompensa.",
                    label = "Conta",
                },
                reviveRewardAccountType = {
                    description = "Tipo de conta principal utilizada para reavivar os pagamentos de recompensas.",
                    label = "Tipo de conta",
                },
                reviveRewardAmount = {
                    description = "Valor da recompensa paga ao médico por uma reanimação.",
                    label = "Montante",
                },
                reviveRewardCurrency = {
                    description = "Chave de moeda personalizada opcional utilizada para reanimar pagamentos de recompensa.",
                    label = "Moeda",
                },
                reviveRewardEnabled = {
                    description = "Pague uma recompensa configurada após uma reanimação médica bem-sucedida.",
                    label = "Habilitado",
                },
                reviveRewardPayFromSociety = {
                    description = "Deduza as recompensas de recuperação da sociedade de trabalho partilhada antes de pagar ao médico.",
                    label = "Pagamento da sociedade",
                },
                selfDiagnoseCommand = {
                    description = "Comando de chat utilizado para abrir o autodiagnóstico.",
                    label = "Comando",
                },
                selfDiagnoseEnabled = {
                    description = "Permita que os jogadores abram a IU de diagnóstico por conta própria.",
                    label = "Autodiagnóstico ativado",
                },
                selfDiagnoseKeybind = {
                    description = "Atalho de tecla padrão utilizado para abrir o autodiagnóstico.",
                    label = "Teclado",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Atraso antes de a IU de autodiagnóstico ser aberta.",
                    label = "Atraso aberto ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Restrinja o autodiagnóstico apenas ao trabalho médico.",
                    label = "Exigir trabalho médico",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Não congele o leitor durante o autodiagnóstico.",
                    label = "Ignorar o congelamento de si",
                },
                statusEffectsProfiles = {
                    description = "Efeitos de ecrã configurados e limites para hemorragia, nível baixo de sangue, fome e sede.",
                    label = "Efeitos de estado",
                },
                stretcherAnimDict = {
                    description = "Dicionário de animação utilizado durante o transporte da maca.",
                    label = "Ditado de animação",
                },
                stretcherAnimName = {
                    description = "Nome da animação utilizada durante o transporte da maca.",
                    label = "Nome da animação",
                },
                stretcherAttachRx = {
                    description = "Carregue a rotação X do acessório para a maca.",
                    label = "Anexar RX",
                },
                stretcherAttachRy = {
                    description = "Carregue a rotação em Y do acessório para a maca.",
                    label = "Anexar RY",
                },
                stretcherAttachRz = {
                    description = "Transporte a rotação Z para a maca.",
                    label = "Anexar RZ",
                },
                stretcherAttachX = {
                    description = "Transporte o deslocamento X do anexo para a maca.",
                    label = "Anexar X",
                },
                stretcherAttachY = {
                    description = "Transporte o deslocamento em Y do acessório para a maca.",
                    label = "Anexar Y",
                },
                stretcherAttachZ = {
                    description = "Transporte o deslocamento Z do anexo para a maca.",
                    label = "Anexar Z",
                },
                stretcherFoldedEnabled = {
                    description = "Active a variante de maca dobrada opcional no interior dos veículos.",
                    label = "Dobrado ativado",
                },
                stretcherFoldedModel = {
                    description = "Modelo de suporte utilizado para a variante de maca dobrada.",
                    label = "Modelo dobrado",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Cabeçalho do paciente utilizado para a variante de maca dobrada.",
                    label = "Título do paciente dobrado",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Paciente fixa deslocamento X para a maca dobrada.",
                    label = "Paciente X dobrado",
                },
                stretcherFoldedPatientAttachY = {
                    description = "O paciente fixa o deslocamento em Y para a maca dobrada.",
                    label = "Paciente dobrado Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "O paciente fixa o deslocamento Z para a maca dobrada.",
                    label = "Paciente Z dobrado",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Substituição da distância de interação utilizada para helicópteros.",
                    label = "Distância de interação do helicóptero",
                },
                stretcherHelicopterModels = {
                    description = "Modelos de veículos tratados como helicópteros-maca.",
                    itemLabel = "Modelo",
                    label = "Modelos de helicóptero",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Substituição da distância de recolha utilizada para helicópteros.",
                    label = "Distância de recolha do helicóptero",
                },
                stretcherInteractDistance = {
                    description = "Distância máxima para avisos de interação com a maca.",
                    label = "Distância de interação",
                },
                stretcherItemEnabled = {
                    description = "Ativa o item de maca no inventário, incluindo a compra na loja e a utilização.",
                    label = "Item de maca",
                },
                stretcherItemPickupEnabled = {
                    description = "Permite devolver ao inventário as macas colocadas através do item de inventário.",
                    label = "Recolha do item",
                },
                stretcherModel = {
                    description = "Modelo de suporte de maca primária utilizado pelo sistema de maca EMS.",
                    label = "Modelo",
                },
                stretcherPatientAnimationDict = {
                    description = "Dicionário de animação para pacientes na maca e o NPC de pré-visualização.",
                    label = "Dicionário de animação do paciente",
                },
                stretcherPatientAnimationName = {
                    description = "Clipe de animação para pacientes na maca e o NPC de pré-visualização.",
                    label = "Nome da animação do paciente",
                },
                stretcherPatientAttachHeading = {
                    description = "Cabeçalho do paciente utilizado enquanto está deitado na maca.",
                    label = "Título do doente",
                },
                stretcherPatientAttachX = {
                    description = "O paciente fixa o deslocamento X na maca.",
                    label = "Paciente X",
                },
                stretcherPatientAttachY = {
                    description = "O paciente fixa o deslocamento em Y na maca.",
                    label = "Paciente Y",
                },
                stretcherPatientAttachZ = {
                    description = "O paciente fixa o deslocamento Z na maca.",
                    label = "Paciente Z",
                },
                stretcherPickupDistance = {
                    description = "Distância necessária para apanhar e interagir com a maca.",
                    label = "Distância de recolha",
                },
                stretcherTreatmentAnimClip = {
                    description = "Clip de animação utilizado durante o tratamento de um paciente numa maca. Deixe em branco para utilizar um cenário ou o substituto da animação de tratamento.",
                    label = "Nome da animação",
                },
                stretcherTreatmentAnimDict = {
                    description = "Dicionário de animação utilizado durante o tratamento de um paciente numa maca. Deixe em branco para utilizar um cenário ou o substituto da animação de tratamento.",
                    label = "Dicionário de animação",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Cenário opcional utilizado durante o tratamento de um paciente numa maca. Deixe em branco para usar dict + clip ou o substituto da animação de tratamento.",
                    label = "Cenário",
                },
                stretcherVehicleAttachRx = {
                    description = "Fixação do veículo Rotação X para carregamento da maca.",
                    label = "RX do veículo",
                },
                stretcherVehicleAttachRy = {
                    description = "Rotação em Y de fixação do veículo para carregamento da maca.",
                    label = "Veículo RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Rotação Z de fixação do veículo para carregamento da maca.",
                    label = "Veículo RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Fixação do veículo X offset para carregamento da maca.",
                    label = "Veículo X",
                },
                stretcherVehicleAttachY = {
                    description = "Fixação do veículo em Y para carregamento da maca.",
                    label = "Veículo Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Fixação do veículo com deslocamento Z para carregamento da maca.",
                    label = "Veículo Z",
                },
                stretcherVehicleModels = {
                    description = "Modelos de veículos permitidos para transportar a maca.",
                    itemLabel = "Modelo",
                    label = "Modelos de veículos",
                },
                treatmentAnimClip = {
                    description = "Clip de animação utilizado durante o tratamento de um paciente. Deixe em branco para utilizar um cenário.",
                    label = "Nome da animação",
                },
                treatmentAnimDict = {
                    description = "Dicionário de animação utilizado no tratamento de um doente. Deixe em branco para utilizar um cenário.",
                    label = "Dicionário de animação",
                },
                treatmentAnimScenario = {
                    description = "Cenário utilizado durante o tratamento de um paciente. Deixe em branco para usar dict + clip.",
                    label = "Cenário",
                },
                trunkPropsEnabled = {
                    label = "Props do veículo",
                    description = "Escolhe props junto de um veículo de serviço próximo.",
                },
                trunkEnabled = {
                    description = "Ative a funcionalidade de porta-bagagens do veículo para veículos ambulância.",
                    label = "Habilitado",
                },
                vehicleDamageModifier = {
                    description = "Multiplicador de dano aplicado enquanto o jogador se encontra dentro de um veículo.",
                    label = "Modificador de danos no veículo",
                },
                vehicleImpactProtectionCauses = {
                    description = "Causas de morte que devem contar como impactos de veículos protegidos.",
                    itemLabel = "Causa",
                    label = "Causas de danos",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Evite que impactos de veículos a baixa velocidade matem o jogador.",
                    label = "Habilitado",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Impactos de veículos abaixo desta velocidade não podem matar o jogador.",
                    label = "Velocidade fatal km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Os impactos de veículos a esta velocidade ou acima dela utilizam a configuração normal de lesão mortal.",
                    label = "Velocidade total de dano km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Lesões aplicadas quando a proteção contra impactos do veículo bloqueia um impacto fatal.",
                    itemLabel = "Lesão",
                    label = "Lesões",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Percentagem da saúde máxima preservada quando um impacto protegido teria matado o jogador.",
                    label = "Percentagem de saúde de sobrevivência",
                },
                vehiclePullEnabled = {
                    description = "Ative a retirada de doentes dos veículos.",
                    label = "Habilitado",
                },
                vehiclePullMaxDistance = {
                    description = "Distância máxima necessária para retirar um paciente de um veículo.",
                    label = "Distância máxima",
                },
                wheelchairAssignMaxDistance = {
                    description = "Distância máxima para atribuir uma cadeira de rodas a outro jogador.",
                    label = "Atribuir distância máxima",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Desequipar automaticamente a cadeira de rodas quando a atribuição expirar.",
                    label = "Desequipar automaticamente ao expirar",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Duração padrão atribuída à cadeira de rodas em minutos.",
                    label = "Duração padrão",
                },
                wheelchairDisableSprint = {
                    description = "Bloqueie a corrida enquanto a cadeira de rodas estiver equipada.",
                    label = "Desativar corrida",
                },
                wheelchairDisableWeapons = {
                    description = "Bloqueie o uso de armas enquanto a cadeira de rodas estiver equipada.",
                    label = "Desativar armas",
                },
                wheelchairExitControl = {
                    description = "ID de controlo utilizada para sair da cadeira de rodas.",
                    label = "Controle de saída",
                },
                wheelchairItemName = {
                    description = "Artigo de inventário utilizado para a cadeira de rodas.",
                    label = "Nome do artigo",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Duração máxima permitida para a atribuição de cadeira de rodas em minutos.",
                    label = "Duração máxima",
                },
                wheelchairMinDurationMinutes = {
                    description = "Duração mínima permitida para a atribuição de cadeira de rodas em minutos.",
                    label = "Duração mínima",
                },
                wheelchairVehicle = {
                    description = "Modelo do veículo utilizado para a cadeira de rodas.",
                    label = "Modelo do veículo",
                },
                xrayInteractionRange = {
                    description = "Distância máxima da estação de raios X ao operador.",
                    label = "Faixa de interação",
                },
                xrayPatientRange = {
                    description = "Distância máxima da estação de raios X ao paciente.",
                    label = "Faixa de doentes",
                },
                xrayScanDurationSeconds = {
                    description = "Duração em segundos do resultado da radiografia.",
                    label = "Duração da verificação",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Recarga em segundos entre tentativas de reserva do paciente.",
                    label = "Reserva de recarga",
                },
                appointmentsEnabled = {
                    description = "Ative a reserva de consulta do paciente e o calendário médico pessoal.",
                    label = "Ativado",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Número máximo de dias no futuro que os pacientes podem reservar.",
                    label = "Reserva antecipada máxima",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Número máximo de consultas ativas futuras que um paciente pode realizar.",
                    label = "Máximo de consultas por paciente",
                },
                appointmentsMinLeadMinutes = {
                    description = "Número mínimo de minutos entre a reserva e a marcação.",
                    label = "Prazo de execução mínimo",
                },
                appointmentsNotificationApp = {
                    description = "Identificador de aplicativo de telefone usado para notificações de agendamento.",
                    label = "Aplicação de notificação",
                },
                appointmentsNotificationsEnabled = {
                    description = "Notificar os pacientes em seu telefone quando as consultas são reservadas ou canceladas.",
                    label = "Notificações de telefone",
                },
                appointmentsReasonMaxLength = {
                    description = "Número máximo de caracteres aceitos para o motivo da nomeação.",
                    label = "Limite do carácter da razão",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Duração e intervalo de grade de um horário de agendamento em minutos.",
                    label = "Duração do slot",
                },
                enforceMaxHealth = {
                    description = "Mantenha a saúde máxima do jogador em 200. Desabilite isso quando outro recurso gerencia a saúde máxima.",
                    label = "Enforce a saúde máxima 200",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "A equipe da ambulância pode dar ou remover nos registros do paciente. A licença de primeiros socorros configurada está sempre incluída.",
                    itemLabel = "Licença",
                    label = "Licenças adicionais para pacientes",
                },
                minigamesBandageWrapRandomization = {
                    description = "Randomize o caminho de gaze direção, forma e proporções.",
                    label = "Variação do envoltório de bandagem",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Randomizar o caminho de acesso venoso para transfusões de sangue.",
                    label = "Variação do acesso à transfusão",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Exigir o procedimento de acesso venoso em várias etapas antes do controle do fluxo. Desabilitar para a versão simples antiga.",
                    label = "Venosa fase de acesso",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Randomize a forma do canal da ferida, largura e obstruções.",
                    label = "Variação da extração da bala",
                },
                stretcherVehicleAttachEditor = {
                    description = "Posicione e gire a maca dentro de uma ambulância configurada.",
                    label = "Anexo do veículo",
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
            warnings = {
                firstAidPublicTreatmentConflict = "Os Primeiros Socorros e Tratamento Público não podem ser ativados ao mesmo tempo. Guardar desativa ambos.",
            },
            actions = {
                actionFailed = "Unable to save changes.",
                hideDetails = "Close",
                editPosition = "Edit",
                delete = "Delete",
                editDetails = "Edit",
                remove = "Delete",
            },
        },
    },
}
