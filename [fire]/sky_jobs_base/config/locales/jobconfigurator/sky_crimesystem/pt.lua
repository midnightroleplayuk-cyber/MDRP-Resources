JobConfigLocales["sky_crimesystem:pt"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Comando direto",
            roleDefaults = {
                title = "Cargos",
                description = "Escolhe a patente mínima para cada permissão predefinida. As permissões de patente guardadas no menu do chefe têm prioridade.",
                bossHint = "As patentes de chefe e subchefe mantêm sempre acesso total.",
                empty = "Ainda não existem patentes disponíveis para este emprego.",
                gradesTitle = "Patentes do emprego",
                noDefault = "Sem permissão predefinida",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Os valores partilhados aplicam-se aos campos herdados. Alterar um valor na página de definições torna-o próprio. As entradas existentes mantêm os seus valores.",
            weaponStreetDescription = "Ao usar um contacto de venda de droga, o servidor pode ocasionalmente comprar uma arma elegível. A seleção, o preço e o pagamento são decididos pelo servidor.",
            weaponGroups = {
                general = "Valores gerais",
                access = "Valores de acesso",
                collection = "Valores de recolha",
                production = "Valores de produção",
                market = "Valores de mercado",
                delivery = "Valores de pedidos",
                street = "Venda de armas na rua",
            },
            weaponOptions = {
                scrap_search = "Procurar na pilha de sucata",
                player = "Por jogador",
                global = "Global",
                money = "Dinheiro",
                bank = "Conta bancária",
                black_money = "Dinheiro sujo",
                timing = "Pare o indicador dentro da faixa ideal.",
                precision = "Realize cada corte dentro da janela de precisão.",
                pressure = "Pare a prensa em sua pressão ideal.",
            },

            reputation = {
                remove = "Eliminar",
                title = "Reputação",
                action = "Ação",
                points = "Pontos por conclusão",
                enabled = "Ativa",
                search = "Pesquisar ações",
                added = "Já adicionada",
                noResults = "Nenhuma ação correspondente encontrada.",
                empty = "Ainda não há ações. Use o botão mais para adicionar uma.",
                name = "Nome da regra",
                target = "Alvo (opcional)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Facções",
                    subtitle = "Configure trabalhos criminais e seus locais compartilhados.",
                    title = "Sistema de Crime",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Base principal",
                    entryPluralLabel = "Bases principais",
                    label = "Zona da base principal",
                },
                presetTerritories = {
                    label = "Distritos predefinidos",
                    entryLabel = "Distrito predefinido",
                    entryPluralLabel = "Distritos predefinidos",
                },
                customTerritories = {
                    label = "Territórios personalizados",
                    entryLabel = "Território personalizado",
                    entryPluralLabel = "Territórios personalizados",
                },
                objectsSection = {
                    label = "Objetos de interrogatório",
                    entryLabel = "Objeto",
                    entryPluralLabel = "Objetos de interrogatório",
                },
                blockedZonesSection = {
                    label = "Zonas bloqueadas",
                    entryLabel = "Zona",
                    entryPluralLabel = "Zonas bloqueadas",
                },
                toolsSection = {
                    label = "Ferramentas",
                    entryLabel = "Ferramenta",
                    entryPluralLabel = "Ferramentas",
                },
                sessionsSection = {
                    label = "Sessões em andamento",
                    entryLabel = "Sessão",
                    entryPluralLabel = "Sessões em andamento",
                },
                orphansSection = {
                    label = "Objetos órfãos",
                    entryLabel = "Objeto",
                    entryPluralLabel = "Objetos órfãos",
                },
            },
            darknetActions = {
                currentLocation = "Usar localização atual",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Valores mais altos tornam o cuidado ruim muito mais lento, enquanto preservam bônus fortes para o bom cuidado.",
                    label = "Curva de resposta de cuidado",
                },
                drugGrowthMaxMultiplier = {
                    description = "Multiplicador de crescimento máximo atingido sob condições excelentes.",
                    label = "Multiplicador de cuidado perfeito",
                },
                drugGrowthMinMultiplier = {
                    description = "Multiplicador de crescimento usado quando as condições da planta estão criticamente ruins.",
                    label = "Multiplicador de cuidado crítico",
                },
                drugGrowthQualityBonusMax = {
                    description = "Bônus de crescimento adicional máximo concedido pela qualidade da planta.",
                    label = "Bônus de crescimento por qualidade",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Escolhe patentes mínimas válidas para as permissões dos cargos.",
                base_raid_locked = "A base está sendo invadida. Seus locais de armazenamento e configuração estão bloqueados.",
                base_storage_outside_zone = "Todos os pontos de armazenamento, armários e armazenamento de heist devem estar dentro da zona da base.",
                base_zone_invalid_polygon = "Coloque pelo menos três pontos distintos sem cruzar bordas, então verifique a altura (3–200 m) e o routing bucket.",
                base_zone_point_limit = "Uma zona de mainbase suporta no máximo 64 pontos de limite.",
                base_zone_required = "Configure primeiro uma zona de mainbase válida para este crime job.",
                crime_interrogation_invalid_model = "Insira um modelo de objeto válido.",
                crime_interrogation_invalid_coords = "Coloque o objeto em uma posição válida.",
                crime_interrogation_invalid_zone_points = "Coloque pelo menos três pontos de limite válidos.",
                crime_interrogation_duplicate_id = "Já existe um objeto com este ID.",
                crime_interrogation_tool_invalid = "Verifique a definição da ferramenta.",
                crime_interrogation_tool_id_invalid = "Insira um ID de ferramenta válido.",
                crime_interrogation_tool_label_missing = "Insira um nome para a ferramenta.",
                crime_interrogation_effect_missing = "Configure um efeito para a ferramenta.",
                crime_interrogation_effect_type_unknown = "Selecione um tipo de efeito compatível.",
                crime_interrogation_effect_status_missing = "Indique o estado afetado por esta ferramenta.",
                crime_interrogation_minigame_missing = "Configure um minijogo para a ferramenta.",
                crime_interrogation_minigame_type_unknown = "Selecione um tipo de minijogo compatível.",
                crime_interrogation_keys_missing = "Configure os controles da ferramenta.",
                crime_interrogation_keys_invalid = "Verifique os controles configurados da ferramenta.",
                crime_interrogation_keys_duplicate = "Atribua cada ação e controle da ferramenta apenas uma vez.",
                crime_interrogation_anim_invalid = "Verifique o dicionário e o clipe de animação da ferramenta.",
                crime_interrogation_anim_missing = "Configure uma animação para quem usa a ferramenta.",
                crime_interrogation_occupied = "Já existe alguém amarrado a este objeto.",
                crime_interrogation_not_found = "Isso não existe mais lá.",
            },
            extensions = {
                baseZone = {
                    description = "Coloque os pontos de limite de 3 a 64 em ordem. O ponto colocado mais baixo define a base; a altura se estende para cima a partir dali. Os pontos são salvos como um rascunho; use Salvar para aplicar a zona. Apenas o estoque, armários e estoque de assalto dentro da zona são acessíveis durante os raids. Pontos fora da zona não impedem o salvamento ou o início de um raid. Os limites existentes permanecem ativos até que você salve.",
                    fields = {
                        bucket = "Balde de encaminhamento",
                        configured = "Configurado",
                        height = "Altura (metros)",
                        radius = "Raio (metros)",
                        x = "Centro X",
                        y = "Centro Y",
                        z = "Centro Z",
                    },
                    label = "Zona da base principal",
                },
                invalidSelection = "Seleção inválida: {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Ponto principal deste local de trabalho. Se o blip no mapa estiver ativado em Trabalho → Blips, ele aparecerá aqui.",
            },
            locationTypes = {
                crimeStationPosition = "Localização / Blip no mapa",
                heistCrafting = "Oficina de Heist",
                heistStorage = "Armazenamento de assalto",
            },
            membershipMigration = {
                cancel = "Cancelar",
                confirm = "Migrar e salvar",
                message = "As participações de organizações existentes serão migradas para o modelo selecionado. O emprego normal permanece separado no modo independente.",
                title = "Alterar modelo de participação?",
            },
            moneywashActions = {
                currentLocation = "Usar localização atual",
                invalidLocations = "Verifique IDs, nomes, seleções de interior e coordenadas. Cada local precisa de um ID único.",
                position = "Posição",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Pontos de construção", description = "Coloca equipamento compatível nestes pontos. Coordenadas relativas ao interior escolhido." },
                mwBuildNodes = "Pontos de construção",
                moneywashPublicEquipment = { label = "Equipamento público", description = "Atribui máquinas de lavar, geradores e ventoinhas a locais públicos e pontos compatíveis." },
                mwPublicEquipment = "Equipamento público",
                moneywashMaterials = { label = "Materiais", description = "Usa nomes exatos do inventário. Peso em gramas; instala os objetos em falta." },
                mwMaterials = "Materiais",
                moneywashMaterialRecipes = { label = "Receitas de materiais", description = "Entradas, saídas e duração por unidade. Os processadores usam estas receitas." },
                mwMaterialRecipes = "Receitas de materiais",
                moneywashProductionRecipes = { label = "Receitas de impressão", description = "Papel, tinta e tempos por unidade. Dinheiro após secagem e controlo de qualidade." },
                mwProductionRecipes = "Receitas de impressão",
                moneywashCollectors = { label = "Recolhedores", description = "Configura rendimento, ferramentas, espera e posição de cada recolhedor." },
                mwCollectors = "Recolhedores",
                moneywashProcessors = { label = "Processadores", description = "Escolhe receita de materiais e posição de cada processador." },
                mwProcessors = "Processadores",

                control = "Painel de controle",
                editor = {
                    addBusiness = "Adicionar negócio",
                    addInterior = "Adicionar interior",
                    advanced = "Detalhes técnicos",
                    asset_ipl = "IPL: Insira o nome exato do IPL e a posição do interior.",
                    asset_mlo = "MLO: Usa a posição de um interior instalado. O acesso atualmente utiliza a entrada do negócio.",
                    asset_shell = "Shell: O recurso de modelo deve estar instalado e em execução no servidor.",
                    businessHelp = "Nomeie o negócio, escolha seu interior e defina o preço de compra.",
                    businessListHelp = "Gerencie as entradas e os preços de compra para os seus negócios.",
                    businesses = "Negócios",
                    capture = "Definir no jogo",
                    captureOrigin = "Definir posição do interior",
                    chooseInterior = "Escolher um interior",
                    coordinates = "Editar coordenadas",
                    editSections = "Configuração",
                    emptyBusinessHelp = "Vincule uma entrada do mapa a um interior. Suas organizações poderão então comprar o negócio vazio.",
                    emptyBusinesses = "Seu primeiro negócio",
                    emptyInteriorHelp = "Conecte um IPL, uma shell ou um MLO instalado e, em seguida, defina os pontos usados pelo negócio.",
                    emptyInteriors = "Seu primeiro interior",
                    entranceHelp = "Defina a entrada onde os jogadores devem comprar e entrar no negócio.",
                    freecamHelp = "Freecam: WASD move, Q/E sobe/desce, Shift acelera, Ctrl desacelera. Botão direito: olhar. Arrastar gizmo, R rotacionar/mover, Enter posicionar, Backspace cancelar.",
                    general = "Geral",
                    heading = "Direção",
                    interiorHelp = "Escolha o tipo de interior e seu asset.",
                    interiorListHelp = "Prepare espaços vazios. Os jogadores colocam suas próprias máquinas e equipamentos.",
                    interiors = "Interiores",
                    listEmpty = "Sem entradas.",
                    locationTypes = "Gestão de localização",
                    newBusiness = "Novo negócio",
                    newInterior = "Novo interior",
                    noResults = "Nenhum registro correspondente.",
                    notSet = "Não definido",
                    offsetHelp = "Os valores de entrada são deslocamentos a partir da origem. A posição no mundo é exibida acima.",
                    origin = "Origem",
                    originHelp = "Posição do interior. Todos os outros pontos são relativos a ela.",
                    originRequired = "Defina a posição do interior em 'Geral' primeiro.",
                    outsideRange = "Fora do alcance de {range} metros",
                    point_control = "Mova e rotacione o painel de parede com o gizmo até o lugar. A altura confirmada do objeto é mantida exatamente. Alterne seu marcador em Interações → Lavagem de Dinheiro: painel de controle.",
                    point_entry = "Os jogadores chegam e saem por aqui. Sair os retorna automaticamente para a entrada do negócio deles do lado de fora.",
                    point_position = "Este ponto está fora do negócio.",
                    point_storage = "Mova e rotacione a prateleira com o gizmo até que ela esteja no chão. Membros acessam equipamentos comprados aqui. Alterne seu marcador em Interações → Lavagem de Dinheiro: estoque.",
                    points = "Pontos",
                    pointsHelp = "Selecione um ponto e defina-o diretamente no jogo.",
                    rangeNote = "Um raio de {range} metros ao redor da origem do interior se aplica, sem restrição de altura.",
                    remove = "Remover",
                    repairRange = "Mova estes pontos para mais perto da origem do interior.",
                    saveHint = "Aplique as alterações clicando em Salvar no topo.",
                    search = "Pesquisar …",
                    set = "Definir",
                    teleport = "Teletransporte",
                    viewInteriors = "Ver interiores",
                    visit = "Visitar",
                    visitHint = "Mova-se livremente. Pressione Backspace para retornar ao editor.",
                    visitTitle = "Visitar interior",
                },
                entry = "Entrada e saída",
                fields = {
                    mode = "Modo de acesso",
                    ownerKind = "Tipo de proprietário",
                    productionEnabled = "Expansão de impressão disponível",
                    feePercent = "Taxa (%) / -1 = global",
                    storageCapacity = "Capacidade de stock (objetos)",
                    maximumOrders = "Pedidos simultâneos por jogador",
                    gridPower = "Potência da rede / 0 = gerador",
                    autoService = "Manutenção pública automática",
                    maximumPendingOutputs = "Máximo de pagamentos pendentes",
                    placementRange = "Raio de colocação (m)",
                    placementHeight = "Intervalo vertical de colocação (m)",
                    interiorId = "ID do interior",
                    equipmentId = "ID do equipamento",
                    nodeId = "ID do ponto de construção",
                    generatorNode = "ID do ponto do gerador",
                    maxOffset = "Desvio máximo do ponto (m)",
                    maxHeight = "Desvio vertical máximo (m)",
                    weight = "Peso do objeto (g)",
                    inputItem = "Material de entrada",
                    secondItem = "Segundo material de entrada",
                    outputItem = "Material de saída",
                    requiredTool = "Ferramenta necessária",
                    baseQuality = "Qualidade inicial (%)",
                    minimumQuality = "Qualidade mínima (%)",
                    inspectionCards = "Cartas de inspeção",
                    inspectionPenalty = "Perda de qualidade por erro (%)",
                    rejectPercent = "Notas rejeitadas (%)",
                    accessoryModel = "Modelo acessório",
                    accessoryMaximum = "Máximo de acessórios visíveis",
                    accessoryActiveOnly = "Acessórios apenas durante o processamento",
                    animDict = "Dicionário de animação",
                    animClip = "Sequência de animação",
                    cooldown = "Espera (segundos)",
                    minimum = "Rendimento mínimo",
                    maximum = "Rendimento máximo",
                    productionPrice = "Impressão de dinheiro · Preço de compra",
                    recipeId = "Receita ID",
                    inputAmount = "Material / por unidade",
                    secondAmount = "Material / por unidade",
                    outputAmount = "Material / por unidade",
                    paperItem = "Papel de impressão",
                    inkItem = "Tinta de impressão",
                    paperAmount = "Papel de impressão / por unidade",
                    inkAmount = "Tinta de impressão / por unidade",
                    notesPerUnit = "Notas / por unidade",
                    valuePerNote = "Dinheiro / Notas",
                    maximumUnits = "Unidades (max.)",
                    printSeconds = "Imprimir / por unidade (Segundos)",
                    inspectionSeconds = "Inspecionar / por unidade (Segundos)",
                    rinseSeconds = "Lavar / por unidade (Segundos)",
                    drySeconds = "Secar / por unidade (Segundos)",
                    accessoryUnit = "Notas / por unidade",
                    accessoryX = "Modelo acessório · X (m)",
                    accessoryY = "Modelo acessório · Y (m)",
                    accessoryZ = "Modelo acessório · Z (m)",
                    accessoryStep = "Modelo acessório · Z (m)",

                    capacity = "Capacidade por ciclo",
                    controlHeading = "Orientação do painel de controle",
                    controlHeight = "Altura de montagem acima do ponto (m)",
                    controlModel = "Modelo do painel de parede",
                    controlX = "Painel de controle X",
                    controlY = "Painel de controle Y",
                    controlZ = "Painel de controle Z",
                    disableSets = "Conjuntos de entidades ocultas (separados por vírgula)",
                    enableSets = "Conjuntos de entidades ativados (separados por vírgula)",
                    entryX = "Deslocamento de entrada X",
                    entryY = "Deslocamento de entrada Y",
                    entryZ = "Deslocamento de entrada Z",
                    heading = "Direção de orientação",
                    id = "ID Único",
                    interior = "Interior",
                    ipl = "Nome do IPL",
                    kind = "Tipo",
                    label = "Nome",
                    model = "Nome do modelo",
                    power = "Unidades de energia",
                    price = "Preço de compra",
                    radius = "Raio de posicionamento (m)",
                    repairPrice = "Preço de reparo (0 = grátis)",
                    seconds = "Duração do ciclo (segundos)",
                    storageHeading = "Orientação do ponto de estoque",
                    storageModel = "Modelo de prateleira",
                    storageX = "Ponto de estoque X",
                    storageY = "Ponto de estoque Y",
                    storageZ = "Ponto de estoque Z",
                    wear = "Desgaste por ciclo (%)",
                    x = "Origem X",
                    y = "Origem Y",
                    z = "Origem Z",
                },
                interactions = {
                    control = "Lavagem de Dinheiro: painel de controle",
                    storage = "Lavagem de Dinheiro: estoque",
                },
                item = "Registo",
                moneywashBucketStart = {
                    description = "Reserve este intervalo exclusivamente para Lavagem de Dinheiro. As alterações serão aplicadas na próxima entrada.",
                    label = "Início do intervalo de instância",
                },
                moneywashEquipment = {
                    description = "Os jogadores compram e posicionam dispositivos. Capacidade, duração e desgaste aplicam-se às lavadoras. A energia é a oferta do gerador ou a demanda do dispositivo. As alterações afetam novas compras.",
                    label = "Equipamento comprável",
                },
                moneywashInteriors = {
                    description = "Configure interiores vazios de IPL, shell ou MLO. A entrada, o painel de controle, o estoque e os limites de construção são relativos à origem. Sair retorna os jogadores à entrada do seu negócio.",
                    label = "Interiores (IPL, shell ou MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Máximo de dispositivos e kits de reparo comprados por negócio.",
                    label = "Limite de equipamentos",
                },
                moneywashPreviewBucketStart = {
                    description = "A visita adiciona o ID do jogador a este valor para uma instância de admin privada. Reserve-o separadamente de negócios e outros recursos. As alterações aplicam-se à próxima visualização.",
                    label = "Início do intervalo de instância de visualização",
                },
                moneywashProperties = {
                    description = "Defina uma entrada, escolha um interior e defina o preço de compra. Estabelecimentos comprados mantêm seu interior e layout salvos.",
                    label = "Entradas de estabelecimentos",
                },
                moneywashRepairShops = {
                    description = "Defina as lojas de reparo, teletransporte para elas e defina o preço do serviço. Elas vendem kits de reparo e fazem a manutenção de máquinas armazenadas.",
                    label = "Locais das lojas",
                },
                moneywashShops = {
                    description = "Coloque lojas para lavadoras, geradores e ventiladores. Os pedidos vão para o negócio selecionado da organização.",
                    label = "Locais das lojas",
                },
                mwEquipment = "Loja de equipamentos",
                mwInteriors = "Interiores vazios",
                mwProperties = "Locais",
                mwRepairShops = "Oficina de reparos",
                mwSettings = "Configurações do negócio",
                names = {
                    mwPublicLaundry = "Lavandaria pública",
                    mwPaperPulp = "Pasta de papel",
                    mwPrintingPaper = "Papel de impressão",
                    mwPrintingInk = "Tinta de impressão",
                    mwPaperRecipe = "Produzir papel de impressão",
                    mwPrintingRecipe = "Notas normais",
                    mwPaperCollector = "Recolhedor de papel",
                    mwInkCollector = "Recolhedor de tinta",
                    mwPaperProcessor = "Processador de papel",
                    mwPrinter = "Máquina de impressão",
                    mwInspectionTable = "Mesa de inspeção",
                    mwDryingCabinet = "Armário de secagem",
                    mwNode1 = "1 · Lavar",
                    mwNode2 = "2 · Lavar",
                    mwNode3 = "3 · Pontos de construção",
                    mwNode4 = "4 · Imprimir",
                    mwNode5 = "5 · Inspecionar",
                    mwNode6 = "6 · Secar",
                    mwNode7 = "7 · Pontos de construção",

                    mwInteriorWarehouse = "Armazém vazio",
                },
                options = {
                    private = "Privado",
                    public = "Público",
                    faction = "Organização",
                    person = "Personagem",
                    printer = "Máquina de impressão",
                    inspection = "Mesa de inspeção",
                    dryer = "Armário de secagem",

                    fan = "Ventilador",
                    generator = "Gerador",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Kit de reparo",
                    shell = "Modelo Shell",
                    washer = "Máquina de lavar",
                },
                origin = "Origem",
                storage = "Ponto de estoque",
            },
            settingFields = {
                cultivationLevel = "Nível de cultivo",
                cultivationTitle = "Nome do nível",
                cultivationRequiredXp = "XP total necessária",
                cultivationAction = "Ação",
                cultivationXp = "XP",
                cultivationCategory = "Categoria",
                cultivationEntry = "Entrada",
                cultivationRequiredLevel = "Nível necessário",
                alias = "Apelido",
                atmHeading = "Direção",
                atmId = "ID",
                atmModel = "Modelo de ATM",
                centerX = "Centro X",
                centerY = "Centro Y",
                centerZ = "Centro Z",
                deliveryMethod = "Método de entrega",
                description = "Descrição",
                enabled = "Ativado",
                groupKey = "Chave do grupo",
                id = "ID",
                itemLabel = "Rótulo de mercadoria",
                itemName = "Nome do item de inventário",
                knownScammer = "Golpista conhecido",
                locationName = "Nome do local",
                observerW = "Direção do observador",
                observerX = "Observador X",
                observerY = "Observador Y",
                observerZ = "Observador Z",
                pedModel = "Modelo do ped NPC",
                pickpocketItemChance = "Chance (%)",
                pickpocketItemMaximum = "Quantidade máxima",
                pickpocketItemMinimum = "Quantidade mínima",
                pickpocketItemName = "Nome do item de inventário",
                quantity = "Quantidade",
                radius = "Raio",
                rating = "Avaliação exibida",
                ratingCount = "Contagem de avaliações exibida",
                scamChance = "Chance de golpe do comerciante (%)",
                shopCategory = "Categoria",
                shopClerkHeading = "Direção do funcionário",
                shopClerkModel = "Modelo do funcionário",
                shopClerkRequired = "Funcionário necessário",
                shopClerkX = "Funcionário X",
                shopClerkY = "Funcionário Y",
                shopClerkZ = "Funcionário Z",
                shopCodeEnabled = "Permitir abertura com código",
                shopDrillEnabled = "Permitir perfuração",
                shopEnabled = "Ativado",
                shopHackEnabled = "Permitir hackear",
                shopLocationId = "ID da Loja",
                shopLocationLabel = "Etiqueta",
                shopRegisterId = "ID do Caixa",
                shopSafeEnabled = "Cofre ativado",
                shopSafeHeading = "Direção do cofre",
                shopSafeX = "Cofre X",
                shopSafeY = "Cofre Y",
                shopSafeZ = "Cofre Z",
                side = "Lado do mercado",
                spawns = "Spawns de equipe",
                successfulTrades = "Transações bem-sucedidas exibidas",
                title = "Título da oferta",
                unitPrice = "Preço por unidade",
                verified = "Comerciante verificado",
                w = "Direção",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Posição do atendente",
                shopRegisterPosition = "Posição do caixa",
                shopSafePosition = "Posição do cofre",
                registerId = "ID da caixa registadora",
                registerX = "Coordenada X da caixa",
                registerY = "Coordenada Y da caixa",
                registerZ = "Coordenada Z da caixa",
                heading = "Orientação",
                captureLocation = "Capturar posição",
            },
            crimeDashboard = {
                jobs = "Gere facções, membros, permissões e localizações.",
                jobCreator = "Seleciona uma facção para editar as suas localizações e áreas.",
                jobsQuestion = "Onde edito facções e localizações?",
                jobsAnswer = "Abre {path}, seleciona uma facção e escolhe Editar. Aí podes configurar as suas definições e localizações.",
                creatorsAnswer = "Encontras os criadores em {path}. Estas ligações abrem o editor; as ferramentas de facção começam pela seleção de uma facção.",
                missingAnswer = "Os criadores disponíveis dependem do recurso selecionado e das suas definições. As ferramentas de facção começam na facção correspondente.",
                creators = {
                    mainbaseZones = "Seleciona uma facção e configura a área da sua base.",
                    presetTerritories = "Consulta os distritos predefinidos e escolhe quais estão ativos.",
                    objectsSection = "Gere as cadeiras de interrogatório e os carrinhos de ferramentas permanentes.",
                    blockedZonesSection = "Define áreas onde não se podem colocar objetos de interrogatório.",
                    toolsSection = "Configura as ferramentas disponíveis durante os interrogatórios.",
                    sessionsSection = "Consulta os interrogatórios ativos e termina as sessões quando necessário.",
                    orphansSection = "Revê e remove objetos de interrogatório abandonados.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Escolha como as organizações criminosas armazenam e gerenciam seus membros.",
                },
                territories = {
                    zones = "Configure «Zonas de território» na secção «Territórios».",
                    ownership = "Configure «Propriedade» na secção «Territórios».",
                    decay = "Configure «Decadência» na secção «Territórios».",
                    presence = "Configure «Presença» na secção «Territórios».",
                    activity = "Configure «Pontuação de atividade» na secção «Territórios».",
                    ownershipBenefits = "Configure «Benefícios de propriedade» na secção «Territórios».",
                },
                graffiti = {
                    general = "Configure «Geral» na secção «Grafite».",
                    streaming = "Configure «Renderizando» na secção «Grafite».",
                    moderation = "Configure «Moderação» na secção «Grafite».",
                },
                pvpEvents = {
                    pvpAvailability = "Controle se o app de eventos PvP está disponível e onde ele aparece.",
                    pvpAutomation = "Configure eventos recorrentes e o processamento de início automático.",
                    pvpRuntime = "Ajuste o tratamento de requisições, mortes e respawns durante partidas ao vivo.",
                    pvpModes = "Configure o modo de jogo pré-selecionado no tablet PvP.",
                    pvpArenas = "Cria a zona circular, o ponto de observação e os pontos de spawn de equipe usados em eventos PvP.",
                    pvpLimits = "Defina os limites de recompensa e do histórico do tablet.",
                    pvpPermissions = "Atribui o gerenciamento de eventos e finanças a permissões de ACE e de trabalho.",
                    pvpTakeoverRules = "Controla a disponibilidade e os requisitos de participação para tomadas de controle de laboratórios e trailers.",
                    pvpTakeoverZones = "Configure áreas de interação, alerta e captura junto com suas durações.",
                    pvpTakeoverMethods = "Configure quanto tempo cada método leva para invadir uma entrada.",
                },
                drugs = {
                    creator = "Abre o editor de drogas do Sky Crime e fecha o configurador de empregos.",
                    creatorSettings = "Configure «Configurações do editor» na secção «Sistema de drogas».",
                    interfaceHud = "Configure «Posições da interface» na secção «Sistema de drogas».",
                    drugsGeneral = "Configure «Geral» na secção «Sistema de drogas».",
                    runtimeAccess = "Configure «Acesso e propriedade» na secção «Sistema de drogas».",
                    runtimePayouts = "Configure «Pagamentos» na secção «Sistema de drogas».",
                    runtimeDispatch = "Configure «Central e polícia» na secção «Sistema de drogas».",
                    performanceInactiveControlIntervalMs = "Parâmetro de funcionamento para Desempenho / Inativo / Controle / Intervalo / ms.",
                    performanceInteractionIdleScanIntervalMs = "Parâmetro de funcionamento para Desempenho / Interação / Inactivo / Intervalo de análise / ms.",
                    performanceInteractionPromptIntervalMs = "Parâmetro de funcionamento para Desempenho / Interação / Aviso de interação / Intervalo / ms.",
                    performanceInteractionScanIntervalMs = "Parâmetro de funcionamento para Desempenho / Interação / Intervalo de análise / ms.",
                    performanceMinimumScanIntervalMs = "Parâmetro de funcionamento para Desempenho / Mínimo / Intervalo de análise / ms.",
                    performanceStreetPedActivationDistance = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Ativação / Distância.",
                    performanceStreetPedIdleScanIntervalMs = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Inactivo / Intervalo de análise / ms.",
                    performanceStreetPedScanIntervalMs = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Intervalo de análise / ms.",
                    performanceWorldCachePadding = "Parâmetro de funcionamento para Desempenho / Mundo / Cache / Margem adicional.",
                    performanceWorldCacheRefreshIntervalMs = "Parâmetro de funcionamento para Desempenho / Mundo / Cache / Atualização / Intervalo / ms.",
                    performanceWorldIdleIntervalMs = "Parâmetro de funcionamento para Desempenho / Mundo / Inactivo / Intervalo / ms.",
                },
                drugProduction = {
                    qualityWeights = "Configure «Qualidade / Ponderações» na secção «Produção de drogas».",
                    qualityTiers = "Configure «Qualidade / Níveis de qualidade» na secção «Produção de drogas».",
                    packagingGeneral = "Configure «Geral» na secção «Produção de drogas».",
                    processingFlow = "Configure «Fluxo de processamento» na secção «Produção de drogas».",
                    processingGeneral = "Configure «Geral» na secção «Produção de drogas».",
                },
                drugOperations = {
                    growingGeneral = "Configure «Geral» na secção «Operações de drogas».",
                    plantDefaults = "Configure «Planta / Valores padrão» na secção «Operações de drogas».",
                    harvestWindow = "Configure «Colher / Janela temporal» na secção «Operações de drogas».",
                    labsGeneral = "Ativa: laboratórios e trailers no jogo.",
                    labRent = "Configure «Aluguel e ciclo de vida» na secção «Operações de drogas».",
                    camperDefaults = "Configure «Motorhome» na secção «Operações de drogas».",
                    labUpgrades = "Multiplicador para Laboratório / Nível / Melhoria / Preços.",
                    labDefaults = "Configure «Laboratório / Valores padrão» na secção «Operações de drogas».",
                    powerGeneral = "Configure «Geral» na secção «Operações de drogas».",
                    generators = "Configure «Geradores» na secção «Operações de drogas».",
                    equipmentWear = "Multiplicador global para Desgaste do Equipamento / Processamento.",
                    workersGeneral = "Configure «Geral» na secção «Operações de drogas».",
                    cultivationGeneral = "Configure «Geral» na secção «Operações de drogas».",
                    cultivationCurve = "Configure o nome e o total de XP necessário para cada nível de cultivo.",
                    cultivationExperience = "Configure quanto XP de cultivo cada ação concede.",
                    cultivationUnlocks = "Configure o nível necessário para recipientes, substratos, equipamentos, variedades e níveis do scanner.",
                    powerRuntime = "Intervalo em segundos para atualização do consumo dos geradores e das assinaturas elétricas.",
                    powerHeat = "Configure «Suspeita e assinatura elétrica» na secção «Operações de drogas».",
                    powerModes = "Configure «Gestão / Modos» na secção «Operações de drogas».",
                    powerPriorities = "Configure «Carga / Prioridades» na secção «Operações de drogas».",
                },
                drugMarketRisk = {
                    marketGeneral = "Configure «Geral» na secção «Mercado e risco».",
                    marketPrices = "Configure «Preços» na secção «Mercado e risco».",
                    distribution = "Configure «Distribuição» na secção «Mercado e risco».",
                    threatsGeneral = "Configure «Geral» na secção «Mercado e risco».",
                    threatHeat = "Configure «Pressão policial» na secção «Mercado e risco».",
                    threatChances = "Configure «Probabilidades» na secção «Mercado e risco».",
                    consumptionGeneral = "Configure «Geral» na secção «Mercado e risco».",
                    consumerDecay = "Configure «Redução de tolerância e dependência» na secção «Mercado e risco».",
                    consumerEffects = "Configure «Efeitos e riscos» na secção «Mercado e risco».",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Parâmetro de funcionamento para Mercado Dinâmico / Cooldown de ação / segundos.",
                    dynamicMarketActionHistoryLimit = "Parâmetro de funcionamento para Mercado Dinâmico / Ação / Limite do histórico.",
                    dynamicMarketAmountSaturationWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Quantidade / Saturação / Peso.",
                    dynamicMarketBaseIntelAccuracy = "Parâmetro de funcionamento para Mercado Dinâmico / Valor base / Precisão da inteligência.",
                    dynamicMarketDefaultAverageQuality = "Parâmetro de funcionamento para Mercado Dinâmico / Valor padrão / Média / Qualidade.",
                    dynamicMarketDefaultResourceElasticity = "Parâmetro de funcionamento para Mercado Dinâmico / Valor padrão / Recurso / Elasticidade.",
                    dynamicMarketDemandCenter = "Parâmetro de funcionamento para Mercado Dinâmico / Demanda / Valor central.",
                    dynamicMarketDemandPriceImpact = "Parâmetro de funcionamento para Mercado Dinâmico / Demanda / Preço / Impacto.",
                    dynamicMarketDirectionThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Direção / Limite.",
                    dynamicMarketEnabled = "Parâmetro de funcionamento para Mercado Dinâmico / Ativado.",
                    dynamicMarketEventChance = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Chance.",
                    dynamicMarketEventDurationMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Duração / Minutos.",
                    dynamicMarketEventMinimumDurationMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Mínimo / Duração / Minutos.",
                    dynamicMarketEventStrengthMaximum = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Intensidade / Máximo.",
                    dynamicMarketEventStrengthMinimum = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Intensidade / Mínimo.",
                    dynamicMarketEvents = "Configure «Eventos» na secção «Redes de drogas».",
                    dynamicMarketExactIntelReputation = "Parâmetro de funcionamento para Mercado Dinâmico / Informações exatas / Reputação.",
                    dynamicMarketExactIntelTrust = "Parâmetro de funcionamento para Mercado Dinâmico / Informações exatas / Confiança.",
                    dynamicMarketGlobalZoneLabel = "Parâmetro de funcionamento para Mercado Dinâmico / Global / Zona / Etiqueta.",
                    dynamicMarketHistoryLimit = "Parâmetro de funcionamento para Mercado Dinâmico / Limite do histórico.",
                    dynamicMarketInitialDemand = "Parâmetro de funcionamento para Mercado Dinâmico / Valor inicial / Demanda.",
                    dynamicMarketInitialPriceMultiplier = "Parâmetro de funcionamento para Mercado Dinâmico / Valor inicial / Multiplicador de Preço.",
                    dynamicMarketIntelDemandError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Demanda / Erro.",
                    dynamicMarketIntelMaximumAccuracy = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Máximo / Precisão.",
                    dynamicMarketIntelMinimumAccuracy = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Mínimo / Precisão.",
                    dynamicMarketIntelPoliceError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Polícia / Erro.",
                    dynamicMarketIntelPriceError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Erro.",
                    dynamicMarketIntelPriceMaximum = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Máximo.",
                    dynamicMarketIntelPriceMinimum = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Mínimo.",
                    dynamicMarketIntelReputationWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Reputação / Peso.",
                    dynamicMarketIntelResourcePriceError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Recurso / Preço / Erro.",
                    dynamicMarketIntelSaturationError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Saturação / Erro.",
                    dynamicMarketIntelSeedBucketSeconds = "Parâmetro de funcionamento para Mercado Dinâmico / Janela de semente das informações / segundos.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Estado / Precisão / Limite.",
                    dynamicMarketIntelStatusErrorThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Estado / Erro / Limite.",
                    dynamicMarketIntelSupplyError = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Fornecimento / Erro.",
                    dynamicMarketIntelTrustWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Confiança / Peso.",
                    dynamicMarketManipulationCooldownMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Minutos de tempo de espera.",
                    dynamicMarketManipulationDemandShift = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Demanda / Variação.",
                    dynamicMarketManipulationDurationMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Duração / Minutos.",
                    dynamicMarketManipulationHeat = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Pressão policial.",
                    dynamicMarketManipulationMinimumBatchAmount = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Mínimo / Lote / Quantidade.",
                    dynamicMarketManipulationPaymentAccount = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Conta de pagamento.",
                    dynamicMarketManipulationPrice = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Preço.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Zona / Pressão policial / Multiplicador.",
                    dynamicMarketMaximumIntelAgeMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Máximo / Idade da inteligência / Minutos.",
                    dynamicMarketMaximumPriceMultiplier = "Parâmetro de funcionamento para Mercado Dinâmico / Máximo / Multiplicador de Preço.",
                    dynamicMarketMinimumIntelAgeMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Idade da inteligência / Minutos.",
                    dynamicMarketMinimumMetricWindowMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Métrica / Janela temporal / Minutos.",
                    dynamicMarketMinimumPriceMultiplier = "Parâmetro de funcionamento para Mercado Dinâmico / Preço mínimo / Multiplicador.",
                    dynamicMarketMinimumUpdateMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Atualização / Minutos.",
                    dynamicMarketPoliceDemandWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Polícia / Demanda / Peso.",
                    dynamicMarketPolicePriceImpact = "Parâmetro de funcionamento para Mercado Dinâmico / Polícia / Preço / Impacto.",
                    dynamicMarketPoorQualityDemandPenalty = "Parâmetro de funcionamento para Mercado Dinâmico / Baixa qualidade / Demanda / Penalidade.",
                    dynamicMarketPoorQualityThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Baixa qualidade / Limite.",
                    dynamicMarketPremiumQualityDemandBonus = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade premium / Bônus de Demanda.",
                    dynamicMarketPremiumQualityThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade premium / Limite.",
                    dynamicMarketProductionSupplyWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Produção / Fornecimento / Peso.",
                    dynamicMarketProductionWindowMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Produção / Janela temporal / Minutos.",
                    dynamicMarketQualityCenter = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Valor central.",
                    dynamicMarketQualityConfidenceImpact = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Confiança / Impacto.",
                    dynamicMarketQualityRange = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Faixa de valores.",
                    dynamicMarketRarityBonusMaximum = "Parâmetro de funcionamento para Mercado Dinâmico / Raridade / Bónus / Máximo.",
                    dynamicMarketRegionalGlobalWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Regional / Global / Peso.",
                    dynamicMarketRegionalLocalWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Regional / Local / Peso.",
                    dynamicMarketResourceAliases = "Configure «Recurso / Nomes alternativos» na secção «Redes de drogas».",
                    dynamicMarketResourceDirectionFallThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Direção / Queda / Limite.",
                    dynamicMarketResourceDirectionRiseThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Direção / Aumento / Limite.",
                    dynamicMarketResources = "Configure «Recursos» na secção «Redes de drogas».",
                    dynamicMarketSalesWindowMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Vendas / Janela temporal / Minutos.",
                    dynamicMarketSaturationDemandWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Saturação / Demanda / Peso.",
                    dynamicMarketSaturationPriceImpact = "Parâmetro de funcionamento para Mercado Dinâmico / Saturação / Preço / Impacto.",
                    dynamicMarketScarcityDemandWeight = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Demanda / Peso.",
                    dynamicMarketScarcityPriceImpact = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Preço / Impacto.",
                    dynamicMarketSeasonEndMonths = "Configure «Estação / Fim / Meses» na secção «Redes de drogas».",
                    dynamicMarketSeasonMultipliers = "Configure «Estação / Multiplicadores» na secção «Redes de drogas».",
                    dynamicMarketShortageRumorThreshold = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Rumor / Limite.",
                    dynamicMarketStatusThresholds = "Configure «Estado / Limites» na secção «Redes de drogas».",
                    dynamicMarketTargetSupply = "Parâmetro de funcionamento para Mercado Dinâmico / Alvo / Fornecimento.",
                    dynamicMarketTrendChance = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Chance.",
                    dynamicMarketTrendDurationMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Duração / Minutos.",
                    dynamicMarketTrendMaximumStrength = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Máximo / Intensidade.",
                    dynamicMarketTrendMinimumStrength = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Mínimo / Intensidade.",
                    dynamicMarketUpdateMinutes = "Parâmetro de funcionamento para Mercado Dinâmico / Atualização / Minutos.",
                    dynamicMarketVolatilityMaximum = "Parâmetro de funcionamento para Mercado Dinâmico / Volatilidade / Máximo.",
                    dynamicMarketVolatilityMinimum = "Parâmetro de funcionamento para Mercado Dinâmico / Volatilidade / Mínimo.",
                    dynamicMarketWeatherMultipliers = "Configure «Clima / Multiplicadores» na secção «Redes de drogas».",
                    dynamicMarketWeatherState = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Estado.",
                    heatActionCooldownSeconds = "Parâmetro de funcionamento para Suspeita e risco / Cooldown de ação / segundos.",
                    heatActivityRiskWeights = "Configure «Atividade / Risco / Ponderações» na secção «Redes de drogas».",
                    heatAggressiveHeatMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Modo agressivo / Pressão policial / Multiplicador.",
                    heatBurnerBurnThreshold = "Parâmetro de funcionamento para Suspeita e risco / Telefone descartável / Exposição / Limite.",
                    heatBurnerHeatPerWholesale = "Parâmetro de funcionamento para Suspeita e risco / Telefone descartável / Pressão policial / Por venda no atacado.",
                    heatBurnerPhoneItem = "Parâmetro de funcionamento para Suspeita e risco / Celular Descartável / Item.",
                    heatCamperOperationalHeatMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trailer em operação / Pressão policial / Multiplicador.",
                    heatCamperOperationalHeatThreshold = "Parâmetro de funcionamento para Suspeita e risco / Trailer em operação / Pressão policial / Limite.",
                    heatCamperParkedHeat = "Parâmetro de funcionamento para Suspeita e risco / Trailer estacionado / Pressão policial.",
                    heatContaminatedHeatMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Contaminação / Pressão policial / Multiplicador.",
                    heatContaminatedThreshold = "Parâmetro de funcionamento para Suspeita e risco / Contaminação / Limite.",
                    heatCultivationFreePlants = "Parâmetro de funcionamento para Suspeita e risco / Cultivo / Plantas sem risco adicional.",
                    heatCultivationHeatPerPlant = "Parâmetro de funcionamento para Suspeita e risco / Cultivo / Pressão policial / Por planta.",
                    heatDealerHiddenMinutes = "Parâmetro de funcionamento para Suspeita e risco / Revendedor / oculto / Minutos.",
                    heatDecayPerTick = "Configure «Decadência / Por ciclo de atualização» na secção «Redes de drogas».",
                    heatEnabled = "Parâmetro de funcionamento para Suspeita e risco / Ativado.",
                    heatEnforcementHeat = "Configure «Presença policial / Pressão policial» na secção «Redes de drogas».",
                    heatEnforcementMultipliers = "Configure «Presença policial / Multiplicadores» na secção «Redes de drogas».",
                    heatEntityTypes = "Configure «Entidade / Tipos» na secção «Redes de drogas».",
                    heatEventCooldownMinutes = "Parâmetro de funcionamento para Suspeita e risco / Evento / Minutos de tempo de espera.",
                    heatEventHistoryLimit = "Parâmetro de funcionamento para Suspeita e risco / Evento / Limite do histórico.",
                    heatLabHeatSyncThreshold = "Parâmetro de funcionamento para Suspeita e risco / Laboratório / Pressão policial / Sincronização / Limite.",
                    heatLayLowCooldownMinutes = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Minutos de tempo de espera.",
                    heatLayLowIdleMinutes = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Inactivo / Minutos.",
                    heatLayLowReduction = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Redução.",
                    heatLockdownMinutes = "Parâmetro de funcionamento para Suspeita e risco / Bloqueio / Minutos.",
                    heatMinimumDurationMinutes = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Duração / Minutos.",
                    heatMinimumEventCooldownSeconds = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Evento / Cooldown (segundos).",
                    heatMinimumIdleSeconds = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Inactivo / segundos.",
                    heatProcessingHeatMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Processamento / Pressão policial / Multiplicador.",
                    heatRiskWeights = "Configure «Risco / Ponderações» na secção «Redes de drogas».",
                    heatRotateBurnerReduction = "Parâmetro de funcionamento para Suspeita e risco / Trocar telefone descartável / Redução.",
                    heatRouteControlMinutes = "Parâmetro de funcionamento para Suspeita e risco / Rota / Controle / Minutos.",
                    heatSaleHeat = "Configure «Venda / Pressão policial» na secção «Redes de drogas».",
                    heatThresholds = "Configure «Limites» na secção «Redes de drogas».",
                    heatTickMinutes = "Parâmetro de funcionamento para Suspeita e risco / Ciclo de atualização / Minutos.",
                    heatWholesaleHeatMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Grossista / Pressão policial / Multiplicador.",
                    heatWorkerLeakAlertRadius = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Raio de Alerta.",
                    heatWorkerLeakBaseChance = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Valor base / Chance.",
                    heatWorkerLeakFactionMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Facção / Multiplicador.",
                    heatWorkerLeakHighSeverityThreshold = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Alta / Gravidade / Limite.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Lealdade / Chance / Multiplicador.",
                    heatWorkerLeakLoyaltyThreshold = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Lealdade / Limite.",
                    heatWorkerLeakMaximumChance = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Máximo / Chance.",
                    heatWorkerLeakMinimumCooldownSeconds = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Mínimo / Cooldown (segundos).",
                    heatWorkerLeakRouteMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Rota / Multiplicador.",
                    heatWorkerLeakStrengthMaximum = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Máximo.",
                    heatWorkerLeakStrengthMinimum = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Mínimo.",
                    heatWorkerLeakStrengthMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Multiplicador.",
                    heatWorkerLeakStressChanceMultiplier = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Estresse / Chance / Multiplicador.",
                    heatWorkerLeakStressThreshold = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Estresse / Limite.",
                    contactsActionCooldownSeconds = "Parâmetro de funcionamento para Rede de contatos / Cooldown de ação / segundos.",
                    contactsActiveHotspotCount = "Parâmetro de funcionamento para Rede de contatos / Número de pontos ativos.",
                    contactsBurnerHintTrust = "Parâmetro de funcionamento para Rede de contatos / Dica de burner / Confiança.",
                    contactsBurnerOfferMaximumMultiplier = "Parâmetro de funcionamento para Rede de contatos / Telefone descartável / Oferta / Máximo / Multiplicador.",
                    contactsBurnerOfferMinimumMultiplier = "Parâmetro de funcionamento para Rede de contatos / Telefone descartável / Oferta / Mínimo / Multiplicador.",
                    contactsBuyerCooldownMinutes = "Parâmetro de funcionamento para Rede de contatos / Comprador / Minutos de tempo de espera.",
                    contactsBuyerDeliveryDistance = "Parâmetro de funcionamento para Rede de contatos / Comprador / Distância de entrega.",
                    contactsBuyerPremiumSuccessScore = "Parâmetro de funcionamento para Rede de contatos / Comprador / Premium / Sucesso / Pontuação.",
                    contactsBuyerPremiumTrustGain = "Parâmetro de funcionamento para Rede de contatos / Comprador / Premium / Confiança / ganho.",
                    contactsBuyerRequestHeatRiskWeight = "Parâmetro de funcionamento para Rede de contatos / Comprador / Solicitação / Nível de procurado e Risco / Peso.",
                    contactsBuyerStandardTrustGain = "Parâmetro de funcionamento para Rede de contatos / Comprador / Padrão / Confiança / ganho.",
                    contactsContactActiveDelaySeconds = "Configure «Espera para ativar contato / segundos» na secção «Redes de drogas».",
                    contactsContactDemandRange = "Configure «Contacto / Demanda / Faixa de valores» na secção «Redes de drogas».",
                    contactsContactLossTrust = "Parâmetro de funcionamento para Rede de contatos / Contacto / Perda / Confiança.",
                    contactsDarknetExactIntelMinutes = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Informações exatas / Minutos.",
                    contactsDarknetHotspotIntelPrice = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Ponto ativo / Informações / Preço.",
                    contactsDarknetIntelPrice = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Informações / Preço.",
                    contactsDealerBasePrice = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Preço Base.",
                    contactsDealerHireCapacity = "Configure «Revendedor / Contratação / capacidade» na secção «Redes de drogas».",
                    contactsDealerHireRisk = "Configure «Revendedor / Contratação / Risco» na secção «Redes de drogas».",
                    contactsDealerHireSkill = "Configure «Revendedor / Contratação / Habilidade» na secção «Redes de drogas».",
                    contactsDealerOffers = "Configure «Ofertas do revendedor» na secção «Redes de drogas».",
                    contactsDealerProtectionHours = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Proteção / Horas.",
                    contactsDealerProtectionPrice = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Proteção / Preço.",
                    contactsDealerSaleMax = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Venda / Máximo.",
                    contactsDealerSaleMin = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Venda / Mínimo.",
                    contactsDealerSimulation = "Configure «Revendedor / Simulação» na secção «Redes de drogas».",
                    contactsDealerTickMinutes = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Ciclo de atualização / Minutos.",
                    contactsDealerWage = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário.",
                    contactsDealerWageDecay = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário / Decadência.",
                    contactsDealerWageLoyaltyGain = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário / Lealdade / ganho.",
                    contactsDealerWeaknesses = "Configure «Revendedor / Fraquezas» na secção «Redes de drogas».",
                    contactsDefaultContactDemand = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Contacto / Demanda.",
                    contactsDefaultContactRisk = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Contacto / Risco.",
                    contactsDefaultDealerCapacity = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / capacidade.",
                    contactsDefaultDealerRisk = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / Risco.",
                    contactsDefaultDealerSkill = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / Habilidade.",
                    contactsDefaultHotspotRadius = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Ponto ativo / Raio.",
                    contactsDemandResetMinutes = "Parâmetro de funcionamento para Rede de contatos / Reset de demanda (minutos).",
                    contactsEnabled = "Parâmetro de funcionamento para Rede de contatos / Ativado.",
                    contactsExactLocationTrust = "Parâmetro de funcionamento para Rede de contatos / Localização exata / Confiança.",
                    contactsFactionDiscoveryReputation = "Parâmetro de funcionamento para Rede de contatos / Facção / Descoberta / Reputação.",
                    contactsFactionHintTrust = "Parâmetro de funcionamento para Rede de contatos / Facção / Pista / Confiança.",
                    contactsFailedDeliveryCooldownMinutes = "Parâmetro de funcionamento para Rede de contatos / Entrega malsucedida / Minutos de tempo de espera.",
                    contactsFakeDealEncounter = "Configure «Negócio falso / Encontro» na secção «Redes de drogas».",
                    contactsFallbackPreferredDrug = "Parâmetro de funcionamento para Rede de contatos / Valor alternativo / Droga Preferencial.",
                    contactsFallbackProductLabel = "Parâmetro de funcionamento para Rede de contatos / Valor alternativo / Rótulo do produto.",
                    contactsGuideBookItem = "Parâmetro de funcionamento para Rede de contatos / Guia / Livro / Item.",
                    contactsGuideBookTrust = "Parâmetro de funcionamento para Rede de contatos / Guia / Livro / Confiança.",
                    contactsHireDealerPrice = "Parâmetro de funcionamento para Rede de contatos / Contratar revendedor / Preço.",
                    contactsHistoryLimit = "Parâmetro de funcionamento para Rede de contatos / Limite do histórico.",
                    contactsHotspotIntelMinutes = "Parâmetro de funcionamento para Rede de contatos / Ponto ativo / Informações / Minutos.",
                    contactsHotspotRotationMinutes = "Parâmetro de funcionamento para Rede de contatos / Ponto ativo / Rotação / Minutos.",
                    contactsListingDurationMinutes = "Parâmetro de funcionamento para Rede de contatos / Anúncio / Duração / Minutos.",
                    contactsMaxOwnedDealers = "Parâmetro de funcionamento para Rede de contatos / Máximo / Possuídas / Traficantes.",
                    contactsMinimumBuyerDeliveryDistance = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Comprador / Distância de entrega.",
                    contactsMinimumContactRotationMinutes = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Rotação de contato (minutos).",
                    contactsMinimumDemandResetMinutes = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Reset de demanda (minutos).",
                    contactsMinimumHeatMultiplier = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Pressão policial / Multiplicador.",
                    contactsMinimumHotspotIntelMinutes = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Informações / Minutos.",
                    contactsMinimumHotspotRadius = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Raio.",
                    contactsMinimumHotspotRotationMinutes = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Rotação / Minutos.",
                    contactsMinimumListingDurationMinutes = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Anúncio / Duração / Minutos.",
                    contactsMinimumRewardMultiplier = "Parâmetro de funcionamento para Rede de contatos / Recompensa mínima / Multiplicador.",
                    contactsMinimumRobberyMultiplier = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Assalto / Multiplicador.",
                    contactsMinimumSpotPriceMultiplier = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Local / Multiplicador de Preço.",
                    contactsOtherDrugPriceMultiplier = "Parâmetro de funcionamento para Rede de contatos / Outro / Droga / Multiplicador de Preço.",
                    contactsPaymentAccount = "Parâmetro de funcionamento para Rede de contatos / Conta de pagamento.",
                    contactsPostDeliveryDemandResetSeconds = "Parâmetro de funcionamento para Rede de contatos / Após a entrega / Demanda / Reset / segundos.",
                    contactsPreferredDrugPriceMultiplier = "Parâmetro de funcionamento para Rede de contatos / Droga Preferencial / Multiplicador de Preço.",
                    contactsRegionLocationTrust = "Parâmetro de funcionamento para Rede de contatos / Região / Localização / Confiança.",
                    contactsRequestAmounts = "Configure «Solicitação / Quantidades» na secção «Redes de drogas».",
                    contactsRotationMinutes = "Parâmetro de funcionamento para Rede de contatos / Rotação / Minutos.",
                    contactsSpotPools = "Configure «Local / Conjuntos de seleção» na secção «Redes de drogas».",
                    contactsStreetHotspots = "Configure «Rua / Pontos ativos» na secção «Redes de drogas».",
                    contactsTrustLevels = "Configure «Confiança / Níveis» na secção «Redes de drogas».",
                    businessActionCooldownSeconds = "Parâmetro de funcionamento para Rede de negócios / Cooldown de ação / segundos.",
                    businessBalance = "Configure «Saldo» na secção «Redes de drogas».",
                    businessContracts = "Configure «Contratos» na secção «Redes de drogas».",
                    businessDefaultBusinessName = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Nome comercial.",
                    businessDefaultRankId = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Cargo / ID.",
                    businessDefaultStaffStyle = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Pessoal / Estilo de trabalho.",
                    businessDefaultTransport = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Transportes.",
                    businessEnabled = "Parâmetro de funcionamento para Rede de negócios / Ativado.",
                    businessHubs = "Configure «Centros de distribuição» na secção «Redes de drogas».",
                    businessLimits = "Configure «Limites» na secção «Redes de drogas».",
                    businessPayments = "Escolha qual saldo paga as compras e os custos operacionais da Business Network.",
                    businessPayoutAccount = "Parâmetro de funcionamento para Rede de negócios / Pagamento / Conta.",
                    businessRanks = "Configure «Patentes» na secção «Redes de drogas».",
                    businessReportDays = "Parâmetro de funcionamento para Rede de negócios / Período do relatório / dias.",
                    businessRouteEndpointTypes = "Configure «Rota / Ponto final / Tipos» na secção «Redes de drogas».",
                    businessRuntime = "Configure «Funcionamento no jogo» na secção «Redes de drogas».",
                    businessSocietyPermission = "Parâmetro de funcionamento para Rede de negócios / Organização / Permissão.",
                    businessStaff = "Configure «Pessoal» na secção «Redes de drogas».",
                    businessTickMinutes = "Parâmetro de funcionamento para Rede de negócios / Ciclo de atualização / Minutos.",
                    businessTransports = "Configure «Transportes» na secção «Redes de drogas».",
                },
                robbery = {
                    atmAvailability = "Ative ou desative o sistema de assalto a ATM independente.",
                    atmLocations = "Gerencia as posições de ATM autorizadas pelo servidor disponíveis para assaltos.",
                    atmPolice = "Configure o requisito de policiais em serviço para iniciar um assalto.",
                    atmItems = "Configure os itens necessários de furadeira, cinta de reboque e carga explosiva.",
                    atmActionTimes = "Defina a duração das ações de prender, plantar, detonar e saquear.",
                    atmTimeouts = "Controle quanto tempo um ATM arrombado permanece disponível para saque.",
                    atmPayout = "Configure a conta de destino e a faixa de recompensa aleatória.",
                    atmDistances = "Defina os alcances de jogador e veículo usados nas interações de ATM.",
                    atmExplosionEffects = "Configura os parâmetros nativos de explosão usados durante a detonação.",
                    atmDispatchAlert = "Configure o raio, a duração e a prioridade para o alerta policial.",
                    atmDispatchRecipients = "Escolha quais nomes de jobs recebem alertas de assalto a ATM.",
                    shopAvailability = "Ative os assaltos e configure o requisito policial.",
                    shopTiming = "Configure intimidação, ações, tempo limite e cooldown.",
                    shopSafe = "Configure as tentativas no teclado e o item de furadeira.",
                    shopRegisterReward = "Configure a recompensa aleatória para cada caixa.",
                    shopSafeReward = "Configure a recompensa aleatória do cofre.",
                    shopDispatchSettings = "Configure os destinatários e as propriedades do alerta.",
                    shopLocationTable = "Gerencie lojas com funcionários e cofres.",
                    pickpocketAvailability = "Ativa o recurso e, opcionalmente, o limita aos trabalhos criminais configurados.",
                    pickpocketGameplay = "Escolha o desafio e as probabilidades independentes de fuga, chamada de emergência e contra-ataque.",
                    pickpocketItemRewards = "Controle bolsos vazios e escolhas de itens visíveis até 0.0001 por cento.",
                    pickpocketMoney = "Configure a faixa de dinheiro aleatório gerada pelo servidor.",
                    pickpocketDistances = "Defina o alcance de NPC usado pelo sistema radial e de alvo compartilhado.",
                    pickpocketRateLimits = "Controle o limite de requisições, o cooldown por NPC e a expiração de sessão.",
                    pickpocketDispatchSettings = "Configura o alerta enviado quando um NPC chama os serviços de emergência.",
                    heistCrafting = "Escolha quanta interação é necessária ao fabricar equipamentos de assalto. Aplica-se a novas tentativas em todo o Sistema de Crime.",
                    heistCreatorMenu = "Crie, edite e publique heists modulares no Heist Creator dedicado.",
                    heistExecution = "Janela de início, inatividade e tempo de recarga para tentativas de assalto.",
                    npcPoliceSupport = "Oficiais NPCs armados respondem a pé a alarmes de assalto e apoiam a polícia combatendo os assaltantes.",
                },
                baseRaids = {
                    baseRaids = "Acesso à invasão, requisitos e categorias de saque selecionáveis individualmente. Invasões abertas não possuem tempo limite de transporte.",
                },
                weapons = {
                    weaponCreatorMenu = "Gere rotas de armas e lavagem de dinheiro num único editor.",
                    weaponRuntime = "Controla a disponibilidade e o acesso às rotas de armas.",
                    weaponDefaultsgeneral = "Configure «Valores gerais» na secção «Rotas de armas».",
                    weaponDefaultsaccess = "Configure «Valores de acesso» na secção «Rotas de armas».",
                    weaponDefaultscollection = "Configure «Valores de recolha» na secção «Rotas de armas».",
                    weaponDefaultsproduction = "Configure «Valores de produção» na secção «Rotas de armas».",
                    weaponDefaultsmarket = "Configure «Valores de mercado» na secção «Rotas de armas».",
                    weaponDefaultsdelivery = "Configure «Valores de pedidos» na secção «Rotas de armas».",
                    weaponStreet = "Configure «Venda de armas na rua» na secção «Rotas de armas».",
                },
                darknetMarket = {
                    darknetAvailability = "Controla o aplicativo de tablet e seu posicionamento.",
                    darknetEconomy = "Configura saldos de carteira, câmbio de moedas e taxas de pagamento.",
                    darknetListings = "Controla limites de ofertas, preços e expiração automática.",
                    darknetChat = "Limita mensagens criptografadas do marketplace.",
                    darknetIdentity = "Configura a rotação de identidade, verificação e avisos de fraude.",
                    darknetDelivery = "Configura encontros físicos e caixas de itens roubáveis no mundo.",
                    darknetDeliveryLocations = "Configura os pools de localização atribuídos aleatoriamente às trocas de NPCs da BlackBay.",
                    darknetPolice = "Grupos de trabalho autorizados a publicar armadilhas e visualizar investigações.",
                    darknetNpcTraders = "Compradores e vendedores NPCs persistentes com risco configurável.",
                },
                interrogation = {
                    general = "Configure «Geral» na secção «Interrogatório».",
                    consent = "Configure «Proteção do jogador» na secção «Interrogatório».",
                    objects = "Configure «Objetos» na secção «Interrogatório».",
                    grab = "Configure «Imobilização» na secção «Interrogatório».",
                    session = "Configure «Sessão» na secção «Interrogatório».",
                    dispatch = "Configure «Alertas policiais» na secção «Interrogatório».",
                    logging = "Configure «Registro» na secção «Interrogatório».",
                    security = "Configure «Segurança» na secção «Interrogatório».",
                    presentation = "Configure «Apresentação» na secção «Interrogatório».",
                },
                reputation = {
                    crimeReputation = "Configure «Reputação» na secção «Reputação».",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Geral", description = "Controla a disponibilidade e o acesso às rotas de armas." },
                weaponCreatorMenu = { label = "Criador de Negócios Ilegal", description = "Gere rotas de armas e lavagem de dinheiro num único editor." },
                atmActionTimes = {
                    description = "Defina a duração das ações de prender, plantar, detonar e saquear.",
                    label = "Durações de ação",
                },
                atmAvailability = {
                    description = "Ative ou desative o sistema de assalto a ATM independente.",
                    label = "Disponibilidade",
                },
                atmDispatchAlert = {
                    description = "Configure o raio, a duração e a prioridade para o alerta policial.",
                    label = "Propriedades do alerta",
                },
                atmDispatchRecipients = {
                    description = "Escolha quais nomes de jobs recebem alertas de assalto a ATM.",
                    label = "Destinatários",
                },
                atmDistances = {
                    description = "Defina os alcances de jogador e veículo usados nas interações de ATM.",
                    label = "Distâncias de interação",
                },
                atmExplosionEffects = {
                    description = "Configura os parâmetros nativos de explosão usados durante a detonação.",
                    label = "Efeitos de explosão",
                },
                atmItems = {
                    description = "Configure os itens necessários de furadeira, cinta de reboque e carga explosiva.",
                    label = "Itens necessários",
                },
                atmLocations = {
                    description = "Gerencia as posições de ATM autorizadas pelo servidor disponíveis para assaltos.",
                    label = "Locais de ATM",
                },
                atmPayout = {
                    description = "Configure a conta de destino e a faixa de recompensa aleatória.",
                    label = "Pagamento",
                },
                atmPolice = {
                    description = "Configure o requisito de policiais em serviço para iniciar um assalto.",
                    label = "Requisito policial",
                },
                atmPulling = {
                    description = "Configure o movimento necessário para arrancar um ATM da parede.",
                    label = "Detecção de puxão",
                },
                atmTimeouts = {
                    description = "Controle quanto tempo um ATM arrombado permanece disponível para saque.",
                    label = "Tempo limite de saque",
                },
                baseRaids = {
                    description = "Acesso à invasão, requisitos e categorias de saque selecionáveis individualmente. Invasões abertas não possuem tempo limite de transporte.",
                    label = "Invasões de base",
                },
                businessPayments = {
                    description = "Escolha qual saldo paga as compras e os custos operacionais da Business Network.",
                    label = "Pagamentos",
                },
                crimeMembership = {
                    description = "Escolha como as organizações criminosas armazenam e gerenciam seus membros.",
                    label = "Modelo de associação",
                },
                darknetAvailability = {
                    description = "Controla o aplicativo de tablet e seu posicionamento.",
                    label = "Disponibilidade",
                },
                darknetChat = {
                    description = "Limita mensagens criptografadas do marketplace.",
                    label = "Chat privado",
                },
                darknetDelivery = {
                    description = "Configura encontros físicos e caixas de itens roubáveis no mundo.",
                    label = "Entregas e dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Configura os pools de localização atribuídos aleatoriamente às trocas de NPCs da BlackBay.",
                    label = "Locais de entrega",
                },
                darknetEconomy = {
                    description = "Configura saldos de carteira, câmbio de moedas e taxas de pagamento.",
                    label = "Criptomoeda",
                },
                darknetIdentity = {
                    description = "Configura a rotação de identidade, verificação e avisos de fraude.",
                    label = "Aliases e reputação",
                },
                darknetListings = {
                    description = "Controla limites de ofertas, preços e expiração automática.",
                    label = "Ofertas e validade",
                },
                darknetNpcTraders = {
                    description = "Compradores e vendedores NPCs persistentes com risco configurável.",
                    label = "Negociantes NPC",
                },
                darknetPolice = {
                    description = "Grupos de trabalho autorizados a publicar armadilhas e visualizar investigações.",
                    label = "Acesso policial",
                },
                heistCrafting = {
                    description = "Escolha quanta interação é necessária ao fabricar equipamentos de assalto. Aplica-se a novas tentativas em todo o Sistema de Crime.",
                    label = "Oficina de Heist",
                },
                heistCreatorMenu = {
                    description = "Crie, edite e publique heists modulares no Heist Creator dedicado.",
                    label = "Menu do Criador",
                },
                heistExecution = {
                    description = "Janela de início, inatividade e tempo de recarga para tentativas de assalto.",
                    label = "Tempo do assalto",
                },
                moneywashEconomy = {
                    description = "Ative os estabelecimentos e configure a conta de depósito, a taxa de serviço e as distâncias de interação.",
                    label = "Geral",
                },
                npcPoliceSupport = {
                    description = "Oficiais NPCs armados respondem a pé a alarmes de assalto e apoiam a polícia combatendo os assaltantes.",
                    label = "Suporte policial NPC",
                },
                pickpocketAvailability = {
                    description = "Ativa o recurso e, opcionalmente, o limita aos trabalhos criminais configurados.",
                    label = "Disponibilidade",
                },
                pickpocketDispatchSettings = {
                    description = "Configura o alerta enviado quando um NPC chama os serviços de emergência.",
                    label = "Despacho de emergência",
                },
                pickpocketDistances = {
                    description = "Defina o alcance de NPC usado pelo sistema radial e de alvo compartilhado.",
                    label = "Distâncias de interação",
                },
                pickpocketGameplay = {
                    description = "Escolha o desafio e as probabilidades independentes de fuga, chamada de emergência e contra-ataque.",
                    label = "Risco e minigame",
                },
                pickpocketItemRewards = {
                    description = "Controle bolsos vazios e escolhas de itens visíveis até 0.0001 por cento.",
                    label = "Itens visíveis no bolso",
                },
                pickpocketMoney = {
                    description = "Configure a faixa de dinheiro aleatório gerada pelo servidor.",
                    label = "Recompensa em dinheiro",
                },
                pickpocketRateLimits = {
                    description = "Controle o limite de requisições, o cooldown por NPC e a expiração de sessão.",
                    label = "Salvaguardas do servidor",
                },
                pvpArenas = {
                    description = "Cria a zona circular, o ponto de observação e os pontos de spawn de equipe usados em eventos PvP.",
                    label = "Arenas e zonas de combate",
                },
                pvpAutomation = {
                    description = "Configure eventos recorrentes e o processamento de início automático.",
                    label = "Automação",
                },
                pvpAvailability = {
                    description = "Controle se o app de eventos PvP está disponível e onde ele aparece.",
                    label = "Disponibilidade",
                },
                pvpLimits = {
                    description = "Defina os limites de recompensa e do histórico do tablet.",
                    label = "Limites e histórico",
                },
                pvpModes = {
                    description = "Configure o modo de jogo pré-selecionado no tablet PvP.",
                    label = "Modos de jogo",
                },
                pvpPermissions = {
                    description = "Atribui o gerenciamento de eventos e finanças a permissões de ACE e de trabalho.",
                    label = "Permissões",
                },
                pvpRuntime = {
                    description = "Ajuste o tratamento de requisições, mortes e respawns durante partidas ao vivo.",
                    label = "Duração do evento",
                },
                pvpTakeoverMethods = {
                    description = "Configure quanto tempo cada método leva para invadir uma entrada.",
                    label = "Métodos de invasão",
                },
                pvpTakeoverRules = {
                    description = "Controla a disponibilidade e os requisitos de participação para tomadas de controle de laboratórios e trailers.",
                    label = "Regras de tomada de controle",
                },
                pvpTakeoverZones = {
                    description = "Configure áreas de interação, alerta e captura junto com suas durações.",
                    label = "Zonas e horários",
                },
                shopAvailability = {
                    description = "Ative os assaltos e configure o requisito policial.",
                    label = "Disponibilidade",
                },
                shopDispatchSettings = {
                    description = "Configure os destinatários e as propriedades do alerta.",
                    label = "Alerta policial",
                },
                shopLocationTable = {
                    description = "Gerencie lojas com funcionários e cofres.",
                    label = "Locais de lojas",
                },
                shopRegisterReward = {
                    description = "Configure a recompensa aleatória para cada caixa.",
                    label = "Recompensa do caixa",
                },
                shopRegisterTable = {
                    description = "Atribua caixas registradoras individuais às lojas.",
                    label = "Caixas registradoras",
                },
                shopSafe = {
                    description = "Configure as tentativas no teclado e o item de furadeira.",
                    label = "Cofre",
                },
                shopSafeReward = {
                    description = "Configure a recompensa aleatória do cofre.",
                    label = "Recompensa do cofre",
                },
                shopTiming = {
                    description = "Configure intimidação, ações, tempo limite e cooldown.",
                    label = "Horários",
                },
            },
            settingSections = {
                weapons = "Rotas de armas",
                drugs = "Sistema de drogas",
                drugProduction = "Produção de drogas",
                drugOperations = "Operações de drogas",
                drugMarketRisk = "Mercado e risco",
                drugNetworks = "Redes de drogas",
                atmRobbery = "Assalto ao ATM",
                baseRaids = "Invasões de base",
                crimeOrganizations = "Organizações",
                darknetMarket = "Mercado Darknet",
                moneywash = "Lavagem de Dinheiro",
                pvpEvents = "PvP de Facção",
                robbery = "Assalto",
                territories = "Territórios",
                graffiti = "Grafite",
                interrogation = "Interrogatório",
            },
            settingSubsections = {
                baseRaidEquipment = "Equipamento necessário",
                baseRaidBreach = "Arrombamento",
                baseRaidLoot = "Saque e veículos",
                graffitiLimits = "Limites e moderação",
                interrogationTechnical = "Registos e segurança",
                atmDispatch = "Despacho policial",
                atmEquipment = "Equipamento",
                atmExplosion = "Explosão",
                atmOverview = "Visão geral e locais",
                atmRewards = "Recompensas",
                atmTiming = "Horários",
                atmVehicle = "Veículo e arraste",
                baseRaids = "Invasões de base",
                crimeMembership = "Associação",
                heistCreator = "Criador de Assalto",
                npcPoliceSupport = "Suporte policial NPC",
                pickpocket = "Batedor de carteira de NPC",
                pvpArenas = "Arenas",
                pvpEquipment = "Modos de jogo",
                pvpOverview = "Visão Geral",
                pvpRuntime = "Duração do evento",
                pvpTakeovers = "Invasões de laboratório",
                shopRobbery = "Assaltos a lojas",
                atmRobbery = "Assalto ao ATM",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Distância de interação" },
                weaponDefaultGeneralPedModel = { label = "Modelo de NPC padrão" },
                weaponDefaultAccessActiveHourStart = { label = "Hora de abertura (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Hora de fecho (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Polícias de serviço necessários" },
                weaponDefaultAccessPoliceJobs = { label = "Trabalhos policiais" },
                weaponDefaultCollectionDurationSeconds = { label = "Duração em segundos" },
                weaponDefaultCollectionCooldownSeconds = { label = "Espera em segundos" },
                weaponDefaultCollectionCooldownScope = { label = "Âmbito da espera" },
                weaponDefaultCollectionUseMinigame = { label = "Usar minijogo" },
                weaponDefaultCollectionMinigame = { label = "Minijogo" },
                weaponDefaultCollectionMinigameRounds = { label = "Rondas do minijogo" },
                weaponDefaultProductionDurationSeconds = { label = "Duração em segundos" },
                weaponDefaultProductionSuccessChance = { label = "Probabilidade de sucesso (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Consumir materiais em caso de falha" },
                weaponDefaultProductionUseMinigame = { label = "Usar minijogo" },
                weaponDefaultProductionMinigame = { label = "Minijogo" },
                weaponDefaultProductionMinigameRounds = { label = "Rondas do minijogo" },
                weaponDefaultProductionQualityMin = { label = "Qualidade mínima" },
                weaponDefaultProductionQualityMax = { label = "Qualidade máxima" },
                weaponDefaultProductionCooldownSeconds = { label = "Espera em segundos" },
                weaponDefaultProductionCooldownScope = { label = "Âmbito da espera" },
                weaponDefaultMarketPayoutAccount = { label = "Conta de pagamento" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Fator de preço mínimo (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Fator de preço máximo (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Intervalo de reposição em segundos" },
                weaponDefaultMarketCooldownSeconds = { label = "Espera em segundos" },
                weaponDefaultMarketCooldownScope = { label = "Âmbito da espera" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Prazo do pedido em minutos" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Bónus do pedido (%)" },
                weaponStreetEnabled = { label = "Vendas raras de armas a compradores de rua" },
                weaponStreetChance = { label = "Probabilidade de oferta de arma (%)" },
                weaponStreetCooldown = { label = "Espera em segundos" },
                weaponStreetAmount = { label = "Quantidade máxima" },
                weaponStreetPriceMin = { label = "Fator de preço mínimo (%)" },
                weaponStreetPriceMax = { label = "Fator de preço máximo (%)" },
                weaponStreetAccount = { label = "Conta de pagamento" },
                weaponStreetDirect = { label = "Venda direta" },
                weaponStreetBulk = { label = "Venda em lote" },
                weaponStreetContract = { label = "Pedido do cartel" },
                weaponSystemEnabled = { label = "Sistema de rotas de armas", description = "Ativa a recolha e o processamento de armas e a venda aos cartéis." },
                weaponRuntimeEnabled = { label = "Ações de rotas de armas", description = "Permite usar as rotas de armas configuradas no mundo do jogo." },
                weaponCreatorAccess = { label = "Acesso ao criador de armas", description = "Escolhe quem pode abrir o criador de armas.", options = { permission = "Apenas com permissão", jobManagement = "Gestão do emprego", ownerOnly = "Apenas proprietário" } },
                openWeaponCreator = { label = "Criador de Negócios Ilegal", description = "Gere rotas de armas e lavagem de dinheiro num único editor.", buttonLabel = "Criador de Negócios Ilegal", unsavedTooltip = "Guardar primeiro" },

                drugCultivationProgressionEnabled = { label = "Ativar níveis de cultivo", description = "Ativa XP de cultivo, níveis e desbloqueios baseados no nível." },
                drugCultivationMaxLevel = { label = "Nível máximo de cultivo", description = "Maior nível de cultivo alcançável. Níveis superiores ficam inacessíveis." },
                drugCultivationLevels = { label = "Curva de níveis", description = "Configure o nome e o total de XP necessário para cada nível de cultivo." },
                drugCultivationActionXp = { label = "Recompensas de XP", description = "Configure quanto XP de cultivo cada ação concede." },
                drugCultivationUnlocks = { label = "Desbloqueios por nível", description = "Configure o nível necessário para recipientes, substratos, equipamentos, variedades e níveis do scanner." },
                reputationRewards = { label = "Ações de reputação", description = "Adicione ações, altere os pontos e desative ou elimine entradas. Apenas as entradas ativas atribuem pontos." },
                reputationEnabled = { label = "Ativar reputação criminosa", description = "Atribuir reputação pessoal." },
                reputationPointsPerLevel = { label = "Pontos por nível", description = "Cada nível exige esta quantidade de pontos adicionais." },
                reputationMinimumJoinPoints = { label = "Reputação mínima para entrar", description = "Total de pontos necessários para entrar numa facção criminosa. 0 desativa o requisito. Os membros atuais mantêm o acesso." },
                reputation_atm = { label = "Assalto a caixa eletrónico", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_shop_register = { label = "Caixa da loja", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_shop_safe = { label = "Cofre da loja", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_pickpocket = { label = "Furto de carteiras", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_heist = { label = "Assalto concluído", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_harvest = { label = "Colheita de drogas", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_processing = { label = "Processamento de drogas", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_sale = { label = "Venda de drogas", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_delivery = { label = "Entrega de drogas", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_contract = { label = "Contrato de distribuição", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_drug_raid = { label = "Ataque por drogas", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_graffiti = { label = "Grafíti", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_moneywash = { label = "Branqueamento de capitais", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_base_raid = { label = "Ataque à base", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                reputation_pvp_win = { label = "Vitória PvP", description = "Pontos por ação concluída com sucesso. 0 desativa esta recompensa." },
                atmChargeProp = {
                    description = "Modelo de objeto exibido no caixa eletrônico enquanto a carga explosiva está plantada.",
                    label = "Objeto de explosão",
                },
                atmConsumeDrill = {
                    description = "Consome a quantidade configurada após concluir com sucesso cada ponto de perfuração do caixa eletrônico.",
                    label = "Consumir furadeira",
                },
                atmDrillItem = {
                    description = "ID do item do inventário necessário para perfurar um caixa eletrônico arrancado. Configuração independente da furadeira dos cofres de lojas.",
                    label = "Item de furadeira",
                },
                atmDrillItemAmount = {
                    description = "Número de itens de furadeira necessários para cada ponto de perfuração do caixa eletrônico.",
                    label = "Quantidade de furadeiras necessária",
                },
                atmDebug = {
                    description = "Escreve diagnósticos detalhados de roubo de caixa eletrônico no console do servidor e no console F8 do cliente.",
                    label = "Logs de debug do caixa eletrônico",
                },
                atmDispatchDurationSeconds = {
                    description = "Segundos que o alerta do caixa eletrônico permanece relevante para os consumidores de despacho.",
                    label = "Duração do despacho",
                },
                atmDispatchEnabled = {
                    description = "Cria um incidente de Base de Jobs quando um caixa eletrônico é invadido.",
                    label = "Ativar despacho policial",
                },
                atmDispatchJobs = {
                    description = "Nomes de cargos separados por vírgula que recebem o alerta do caixa eletrônico.",
                    label = "Cargos de despacho",
                },
                atmDispatchPriority = {
                    description = "Valor de prioridade passado sem alterações para a integração de despacho.",
                    label = "Prioridade de despacho",
                },
                atmDispatchRadius = {
                    description = "Raio aproximado de alerta enviado para a integração de despacho.",
                    label = "Raio de despacho",
                },
                atmEnabled = {
                    description = "Torna os caixas eletrônicos configurados disponíveis para roubos com corda ou explosivos.",
                    label = "Ativar roubos a caixas eletrônicos",
                },
                atmExplosionCameraShake = {
                    description = "Intensidade do tremor de câmera para o cliente que cria a explosão.",
                    label = "Tremor de câmera da explosão",
                },
                atmExplosionDamageScale = {
                    description = "Força de dano e impulso passada para a função nativa de explosão.",
                    label = "Escala de dano de explosão",
                },
                atmExplosionType = {
                    description = "Tipo de explosão do GTA usado na detonação. Mantenha o padrão, a menos que outro tipo tenha sido testado.",
                    label = "Tipo de explosão",
                },
                atmDrillDurationSeconds = {
                    label = "Tempo mínimo de perfuração por parafuso (s)",
                    description = "Tempo mínimo em segundos para cada um dos quatro parafusos. As pausas de resfriamento prolongam a tentativa. Aplica-se às tentativas de perfuração iniciadas após salvar.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Segundos necessários para plantar a carga explosiva.",
                    label = "Duração para plantar a carga",
                },
                atmExplosiveItem = {
                    description = "Item de inventário consumido após a carga ser plantada.",
                    label = "Item explosivo",
                },
                atmExplosiveItemAmount = {
                    description = "Número de itens explosivos consumidos para uma carga plantada.",
                    label = "Quantidade de explosivos consumida",
                },
                atmFuseSeconds = {
                    description = "Segundos entre o plantio e a detonação.",
                    label = "Duração da espoleta",
                },
                atmInteractionDistance = {
                    description = "Alcance máximo de interação do cliente; a validação do servidor adiciona uma margem de segurança.",
                    label = "Distância de interação",
                },
                atmLocations = {
                    description = "Localizações de produção oficiais. Localizações criadas com /atmtest permanecem temporárias.",
                    itemLabel = "Localização do caixa eletrônico",
                    label = "Locais de ATM",
                },
                atmLootDurationSeconds = {
                    description = "Segundos necessários para abrir um caixa eletrônico (ATM) arrombado.",
                    label = "Duração do saque",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Segundos máximos que um jogador pode reservar um ATM enquanto o abre; mantido automaticamente acima da duração do saque.",
                    label = "Tempo limite de reserva de saque",
                },
                atmLootWindowMinutes = {
                    description = "Minutos que um ATM arrombado permanece saqueável antes de ser esvaziado.",
                    label = "Janela de saque",
                },
                atmMinimumPolice = {
                    description = "Membros em serviço do grupo policial configurado necessários para iniciar um assalto.",
                    label = "Mínimo de policiais",
                },
                atmPoliceGroup = {
                    description = "Grupo de cargo sky_jobs_base contado para o requisito policial.",
                    label = "Grupo de cargo da polícia",
                },
                atmPullDistance = {
                    description = "Deslocamento do veículo da posição do ATM necessário para completar o arrombamento.",
                    label = "Distância de tração necessária",
                },
                atmPullMinimumSpeed = {
                    description = "Velocidade mínima do veículo em metros por segundo quando a distância de tração é atingida.",
                    label = "Velocidade mínima de tração",
                },
                atmReservationTimeoutSeconds = {
                    description = "Segundos máximos reservados enquanto um jogador instala uma espoleta ou planta uma carga; mantido automaticamente acima da duração da ação.",
                    label = "Tempo limite de reserva de preparação",
                },
                atmRewardAccount = {
                    description = "Escolha entre dinheiro e o item black_money.",
                    label = "Tipo de pagamento do ATM",
                },
                atmRewardMaximum = {
                    description = "Maior pagamento em dinheiro de um caixa eletrônico; nunca inferior ao mínimo.",
                    label = "Recompensa máxima",
                },
                atmRewardMinimum = {
                    description = "Menor pagamento em dinheiro de um ATM.",
                    label = "Recompensa mínima",
                },
                atmSlingDurationSeconds = {
                    description = "Segundos necessários para prender o laço.",
                    label = "Duração para prender o laço",
                },
                atmSlingItem = {
                    description = "Item de inventário reutilizável necessário para o método de veículo.",
                    label = "Item de arraste",
                },
                atmSlingItemAmount = {
                    description = "Número de itens de laço que devem estar presentes. Eles não são consumidos.",
                    label = "Quantidade de laços necessária",
                },
                atmTestScanDistance = {
                    description = "Distância máxima usada pelo /atmtest ao procurar por um objeto de caixa eletrônico compatível.",
                    label = "Distância de escaneamento de teste do caixa eletrônico",
                },
                atmVehicleMaxDistance = {
                    description = "Distância máxima entre o ATM e um veículo elegível ao prender a cinta.",
                    label = "Distância de fixação do veículo",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Limite de tempo de cada tentativa de arrombamento de um armazém (segundos).",
                    label = "Tempo limite de invasão (segundos)",
                },
                baseRaid_command = {
                    description = "Nome do comando sem barra. Reinicie o recurso de crime após alterá-lo.",
                    label = "Comando de invasão",
                },
                baseRaid_crimeItem = {
                    description = "Item de invasão de gangue.",
                    label = "Item de invasão de gangue",
                },
                baseRaid_crimeVehicles = {
                    description = "Acesso a veículos de gangue.",
                    label = "Acesso a veículos de gangue",
                },
                baseRaid_difficulty = {
                    description = "Dificuldade do skillcheck.",
                    label = "Dificuldade do skillcheck",
                    options = {
                        easy = "Fácil",
                        expert = "Especialista",
                        hard = "Difícil",
                        normal = "Normal",
                    },
                },
                baseRaid_enabled = {
                    description = "Ativar invasões de base.",
                    label = "Ativar invasões de base",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Espera após uma rusga terminada sem abrir qualquer armazém (minutos).",
                    label = "Tempo de espera após falha (minutos)",
                },
                baseRaid_interactionDistance = {
                    description = "Distância de interação do estoque.",
                    label = "Distância de interação do estoque",
                },
                baseRaid_lootHeistStorage = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Armazenamento de saque de assalto",
                },
                baseRaid_lootLaboratories = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Saque de laboratórios",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Saquear armários pessoais",
                },
                baseRaid_lootStorage = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Saque de armazenamento",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Saquear porta-luvas",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Permite a retirada completa desta categoria de inventário durante um assalto ativo.",
                    label = "Saquear porta-malas de veículos",
                },
                baseRaid_minimumDefenders = {
                    description = "Mínimo de defensores online.",
                    label = "Mínimo de defensores online",
                },
                baseRaid_policeItem = {
                    description = "Item de invasão policial.",
                    label = "Item de invasão policial",
                },
                baseRaid_policeRequireDuty = {
                    description = "A polícia deve estar de serviço.",
                    label = "A polícia deve estar de serviço",
                },
                baseRaid_policeVehicles = {
                    description = "Acesso a veículos da polícia.",
                    label = "Acesso a veículos da polícia",
                },
                baseRaid_protectionHours = {
                    description = "Proteção após o sucesso (horas).",
                    label = "Proteção após o sucesso (horas)",
                },
                baseRaid_requiredHits = {
                    description = "Acertos de skillcheck necessários.",
                    label = "Acertos de skillcheck necessários",
                },
                baseRaid_warrantItem = {
                    description = "Um destes itens é consumido para cada início de invasão policial válida.",
                    label = "Item de mandado de busca",
                },
                crimeMembershipMode = {
                    description = "O modo Framework mantém a integração existente de trabalho ou gangue nativa. O modo Independente executa a organização criminosa em segundo plano junto com o trabalho normal do jogador e migra as associações existentes automaticamente.",
                    label = "Modelo de associação da organização",
                    options = {
                        framework = "Trabalho de framework / gangue",
                        independent = "Organização independente",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Idade mínima de uma identidade antes que ela possa ser aposentada novamente.",
                    label = "Tempo de recarga para mudar de alias (horas)",
                },
                darknetCurrencyCode = {
                    description = "Rótulo curto exibido para o livro contábil interno de criptomoeda.",
                    label = "Código da moeda",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Distância necessária para vasculhar e reivindicar uma caixa.",
                    label = "Distância de interação do dead-drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Tempo antes que uma caixa não reivindicada expire.",
                    label = "Tempo de vida do dead-drop (horas)",
                },
                darknetDeadDropModel = {
                    description = "Modelo de prop do GTA spawnado localmente para dead-drops disponíveis.",
                    label = "Modelo da caixa de dead-drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervalo usado para atualizar caixas próximas e encontros com NPCs.",
                    label = "Intervalo de atualização do mundo (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distância na qual as caixas e os contatos de encontro com NPCs são renderizados.",
                    label = "Distância de renderização do dead-drop",
                },
                darknetDropLocations = {
                    description = "Locais atribuídos aleatoriamente para trocas de dead-drop com NPCs. Configure pelo menos dois.",
                    itemLabel = "Local de dead-drop",
                    label = "Locais de dead-drop",
                },
                darknetEnabled = {
                    description = "Disponibiliza o aplicativo de tablet do mercado negro e sua execução.",
                    label = "Ativar Mercado Darknet",
                },
                darknetExchangeBuyPrice = {
                    description = "Valor cobrado da conta de pagamento por uma moeda.",
                    label = "Preço de compra por moeda",
                },
                darknetExchangeEnabled = {
                    description = "Permite que usuários autenticados do BlackBay comprem e vendam moedas em sua página de conta.",
                    label = "Ativar troca de moedas",
                },
                darknetExchangeMaximumAmount = {
                    description = "Maior quantidade de moedas inteiras aceita em uma troca.",
                    label = "Máximo de moedas por troca",
                },
                darknetExchangeMinimumAmount = {
                    description = "Menor quantidade de moedas inteiras aceita em uma troca.",
                    label = "Mínimo de moedas por troca",
                },
                darknetExchangePaymentAccount = {
                    description = "Conta do framework usada para compras de moedas e pagamentos de vendas.",
                    label = "Conta de pagamento de troca",
                    options = {
                        bank = "Banco",
                        black_money = "Dinheiro sujo",
                        money = "Dinheiro",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Valor pago à conta de pagamento por uma moeda.",
                    label = "Preço de venda por moeda",
                },
                darknetFaceToFaceDistance = {
                    description = "Distância máxima entre ambos os jogadores ou o ponto de NPC configurado.",
                    label = "Distância de entrega",
                },
                darknetKnownScammerReports = {
                    description = "Denúncias de transações únicas necessárias para o emblema de golpista conhecido.",
                    label = "Denúncias para aviso de golpista",
                },
                darknetListingExpiryHours = {
                    description = "Ofertas ativas expiram automaticamente após este número de horas.",
                    label = "Tempo de vida da oferta (horas)",
                },
                darknetMaximumListingQuantity = {
                    description = "Limite superior de quantidade para uma oferta.",
                    label = "Quantidade máxima de itens",
                },
                darknetMaximumListings = {
                    description = "Máximo de anúncios por alias ativo.",
                    label = "Máximo de anúncios ativos",
                },
                darknetMaximumMessageLength = {
                    description = "Número máximo de caracteres por mensagem de chat criptografada.",
                    label = "Comprimento máximo da mensagem",
                },
                darknetMaximumUnitPrice = {
                    description = "Preço máximo em cripto por unidade.",
                    label = "Preço máximo por unidade",
                },
                darknetMeetingLocations = {
                    description = "Locais atribuídos aleatoriamente para trocas presenciais com NPCs. Configure pelo menos dois.",
                    itemLabel = "Local de encontro",
                    label = "Locais de encontro",
                },
                darknetNpcBuyerAliases = {
                    description = "Nomes fictícios atribuídos aleatoriamente a novos pedidos de compra de NPCs. Configure pelo menos dois aliases únicos.",
                    label = "Aliases de compradores NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Limite superior usado ao escolher aleatoriamente quantos pedidos de compra de NPCs ficarão ativos.",
                    label = "Máximo de pedidos de compra de NPCs",
                },
                darknetNpcMaximumSellListings = {
                    description = "Limite superior usado ao escolher aleatoriamente quantas ofertas de venda de NPCs tornam-se ativas.",
                    label = "Máximo de ofertas de venda de NPCs",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Quando o mercado de NPCs for reabastecido, pelo menos este número de pedidos de compra selecionados aleatoriamente permanecerá ativo.",
                    label = "Mínimo de pedidos de compra de NPCs",
                },
                darknetNpcMinimumSellListings = {
                    description = "Quando o mercado de NPCs for reabastecido, pelo menos este número de ofertas de venda selecionadas aleatoriamente permanecerá ativo.",
                    label = "Ofertas mínimas de venda de NPCs",
                },
                darknetNpcSellerAliases = {
                    description = "Nomes fictícios atribuídos aleatoriamente a novas ofertas de venda de NPCs. Configure pelo menos dois aliases únicos.",
                    label = "Aliases de vendedores NPC",
                },
                darknetNpcTraders = {
                    description = "Configura ofertas sintéticas, método de entrega, reputação e probabilidade de golpe.",
                    label = "Compradores e vendedores NPC",
                },
                darknetPoliceGroups = {
                    description = "Chaves de grupo que podem publicar ofertas de isca e visualizar investigações.",
                    label = "Grupos de trabalho policiais autorizados",
                },
                darknetRenewalHours = {
                    description = "Horas adicionadas quando um proprietário renova uma oferta.",
                    label = "Duração da renovação (horas)",
                },
                darknetScamChance = {
                    description = "Chance mínima de que um negociante NPC receba o pagamento ou os bens sem entregar a contrapartida. Uma chance maior específica do negociante ainda se aplica.",
                    label = "Chance global de golpe de NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Cripto atribuída apenas quando um jogador abre o mercado pela primeira vez.",
                    label = "Saldo inicial da carteira",
                },
                darknetTabletOrder = {
                    description = "Controla a posição do Mercado Darknet no tablet.",
                    label = "Ordem do app no tablet",
                },
                darknetVerifiedMinimumRating = {
                    description = "Avaliação média mínima para um vendedor verificado.",
                    label = "Avaliação necessária para verificação",
                },
                darknetVerifiedMinimumSales = {
                    description = "Vendas bem-sucedidas necessárias antes que um vendedor possa ser verificado.",
                    label = "Vendas necessárias para verificação",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Usada quando a fonte de pagamento é definida como conta do jogador. Pagamentos de organizações sempre usam a conta do Menu do Chefe.",
                    label = "Conta de pagamento do jogador",
                    options = {
                        bank = "Banco",
                        black_money = "Dinheiro sujo",
                        money = "Dinheiro",
                    },
                    requiresWarning = "Usado apenas com a fonte de pagamento da conta do jogador.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Use o saldo do jogador que está comprando ou a conta do Menu do Chefe da organização.",
                    label = "Fonte de pagamento",
                    options = {
                        player = "Conta do jogador",
                        society = "Conta da organização",
                    },
                },
                drugCamperLockKey = {
                    description = "Define a tecla padrão para trancar e destrancar campers próprios ou compartilhados com a facção. Os jogadores podem alterá-la em suas configurações de teclas do FiveM.",
                    label = "Tecla padrão do cadeado do camper",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Anexa dados de qualidade e lote aos resultados de coleta por padrão. Desative isso para que os materiais brutos acumulem normalmente.",
                    label = "Metadados de itens de coleta",
                },
                drugLabAssaultAlertDuration = {
                    description = "Segundos que o raio de alerta do defensor permanece visível no mapa.",
                    label = "Duração do alerta do defensor",
                },
                drugLabAssaultAlertRadius = {
                    description = "Raio da zona de ataque mostrado para a facção defensora no mapa.",
                    label = "Raio de alerta do defensor",
                },
                drugLabAssaultBreachRadius = {
                    description = "Raio no qual um invasor deve permanecer enquanto a entrada está sendo arrombada.",
                    label = "Raio de permanência na invasão",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Segundos que os atacantes devem manter a entrada sem oposição para assumir o laboratório ou o camper.",
                    label = "Duração da tomada de controle",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Área de entrada usada para contar atacantes e defensores em disputa.",
                    label = "Raio de captura",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Segundos necessários para hackear o sistema de entrada.",
                    label = "Duração da invasão eletrônica",
                },
                drugLabAssaultEnabled = {
                    description = "Permite que facções invadam e tomem o controle de laboratórios rivais e trailers compartilhados por facções.",
                    label = "Ativar invasões de laboratório e de trailers",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Segundos necessários para romper a entrada com uma carga explosiva.",
                    label = "Duração da invasão explosiva",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Distância máxima da entrada do laboratório ou do camper ao iniciar um ataque.",
                    label = "Distância de interação da entrada",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Segundos necessários para perfurar a fechadura de entrada.",
                    label = "Duração da invasão mecânica",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Número de membros online da facção defensora necessário antes que um ataque possa começar.",
                    label = "Mínimo de defensores",
                },
                drugLabAssaultRequireDuty = {
                    description = "Conta apenas membros da facção defensora que estejam atualmente em serviço.",
                    label = "Contar apenas defensores em serviço",
                },
                drugProcessingInventoryMetadata = {
                    description = "Anexa dados de qualidade e lote aos resultados do processamento por padrão. Receitas individuais podem sobrescrever esta configuração.",
                    label = "Metadados de itens de processamento",
                },
                graffitiItemName = {
                    description = "Item de inventário necessário para começar a pintar quando a exigência de item estiver ativada. O item deve existir no inventário ativo.",
                    label = "Item de graffiti necessário",
                },
                heistCooldownMinutes = {
                    description = "Bloqueia o mesmo roubo após o término e a limpeza de uma tentativa com interações reais. Zero desativa o cooldown. Uma janela de início não utilizada não o aciona.",
                    label = "Cooldown do roubo (minutos)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Barra de progresso de cinco segundos. Os ingredientes necessários são consumidos em caso de sucesso.",
                        medium = "Seleciona os ingredientes pela ordem indicada e passa um teste de tempo por ingrediente.",
                        advanced = "Montagem completa para receitas com perfil de dispositivo; nas restantes, dois testes de tempo precisos por ingrediente.",
                    },
                    description = "Simples: barra de progresso de cinco segundos. Médio: seleção de ingredientes e verificações de tempo. Máximo: montagem completa do dispositivo; receitas sem um perfil de dispositivo usam duas verificações de tempo precisas por ingrediente.",
                    label = "Complexidade de crafting",
                    options = {
                        advanced = "Complexidade máxima",
                        medium = "Complexidade média",
                        simple = "Simples",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Após a primeira interação, cada nova ação do roubo reinicia este cronômetro. O término encerra a tentativa e limpa seus objetos do mundo. Aplica-se a novas tentativas.",
                    label = "Limite de inatividade do roubo (minutos)",
                },
                heistStartTimeoutMinutes = {
                    description = "Tempo após pressionar Iniciar para interagir no alvo. Sem uma interação, a tentativa é reiniciada e pode ser iniciada novamente. Aplica-se a novas tentativas.",
                    label = "Minutos até a primeira interação do assalto",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banco",
                        black_money = "Dinheiro sujo",
                        money = "Dinheiro",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Conta da qual o dinheiro sujo de um jogador é removido quando um ciclo de lavagem é iniciado.",
                    label = "Conta de depósito",
                },
                moneywashDrawDistance = {
                    description = "Distância máxima em metros na qual as entradas de estabelecimentos e lojas são exibidas.",
                    label = "Distância de exibição",
                },
                moneywashEnabled = {
                    description = "Torna disponíveis os negócios de lavagem de dinheiro pertencentes à organização.",
                    label = "Ativar lavagem de dinheiro",
                },
                moneywashFeePercent = {
                    description = "Percentual deduzido de cada lote antes do pagamento à organização.",
                    label = "Taxa de serviço (%)",
                },
                moneywashInteractionDistance = {
                    description = "Distância máxima em metros para usar entradas de estabelecimentos e lojas.",
                    label = "Distância de interação",
                },
                npcPoliceAccuracy = {
                    description = "Precisão dos oficiais NPC de 0 a 100.",
                    label = "Precisão de tiro",
                },
                npcPoliceArmour = {
                    description = "Valor de armadura de cada policial NPC de 0 a 100.",
                    label = "Colete à prova de balas",
                },
                npcPoliceAtms = {
                    description = "Envia suporte policial de NPC quando um alarme de roubo a caixa eletrônico é acionado.",
                    label = "Suporte durante roubos a caixas eletrônicos",
                },
                npcPoliceDurationSeconds = {
                    description = "Tempo máximo que os oficiais NPCs permanecem desdobrados após o spawn (30–900 segundos).",
                    label = "Duração do desdobramento (segundos)",
                },
                npcPoliceEnabled = {
                    description = "Envia oficiais NPC armados quando um alarme de roubo é acionado. Desativado por padrão.",
                    label = "Ativar suporte policial NPC",
                },
                npcPoliceHeists = {
                    description = "Envia suporte policial NPC quando um alarme de roubo é acionado.",
                    label = "Suporte durante roubos",
                },
                npcPoliceOfficerCount = {
                    description = "Número de policiais NPCs armados enviados por alarme de assalto (1–8).",
                    label = "Policiais por resposta",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Tempo entre o alarme de roubo e a chegada dos oficiais NPC (0–300 segundos).",
                    label = "Atraso de resposta (segundos)",
                },
                npcPoliceShops = {
                    description = "Envia suporte policial de NPC quando um alarme de assalto a loja é disparado.",
                    label = "Suporte durante assaltos a lojas",
                },
                npcPoliceSpawnDistance = {
                    description = "Distância do alvo em relação ao local do roubo na qual os oficiais NPC surgem (15–150 metros).",
                    label = "Distância de spawn (metros)",
                },
                npcPoliceWeapon = {
                    description = "Arma equipada por cada policial NPC que responder à ocorrência. O padrão é uma pistola.",
                    label = "Arma de serviço",
                    options = {
                        WEAPON_CARBINERIFLE = "Carabina",
                        WEAPON_PISTOL = "Pistola",
                        WEAPON_PUMPSHOTGUN = "Espingarda pump",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Abrir Criador de Assalto",
                    description = "Abra o Heist Creator e feche o Job Configurator.",
                    label = "Criador de Assalto",
                    unsavedTooltip = "Salve as alterações primeiro",
                },
                pickpocketAggressionChance = {
                    description = "Chance independente de o NPC atacar após uma tentativa falha, cancelada ou expirada.",
                    label = "Chance de contra-ataque (%)",
                },
                pickpocketAlertChance = {
                    description = "Chance independente de o NPC reportar uma tentativa falha, cancelada ou expirada.",
                    label = "Chance de chamada de emergência (%)",
                },
                pickpocketDifficulty = {
                    description = "Controla a velocidade do cursor, a rapidez com que o alvo encolhe, a duração da sequência e os erros tolerados.",
                    label = "Dificuldade",
                    options = {
                        easy = "Fácil",
                        expert = "Especialista",
                        hard = "Difícil",
                        normal = "Normal",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Comunicar uma vez cada tentativa de furto de carteira iniciada, mesmo que tenha sucesso e independentemente da probabilidade de chamada de emergência.",
                    label = "Enviar sempre um alerta",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Segundos que o relatório permanece relevante para os receptores do despacho.",
                    label = "Duração do despacho",
                },
                pickpocketDispatchJobs = {
                    description = "Nomes de jobs separados por vírgula que recebem chamadas de emergência.",
                    label = "Jobs de despacho",
                },
                pickpocketDispatchPriority = {
                    description = "Prioridade passada sem alterações para a integração de despacho.",
                    label = "Prioridade de despacho",
                },
                pickpocketDispatchRadius = {
                    description = "Raio de alerta aproximado enviado para a integração de despacho.",
                    label = "Raio de despacho",
                },
                pickpocketEmptyChance = {
                    description = "Chance de o NPC não carregar nenhum saque selecionável.",
                    label = "Chance de bolsos vazios (%)",
                },
                pickpocketEnabled = {
                    description = "Permite que os jogadores tentem furtar NPCs ambientais em rede que sejam elegíveis.",
                    label = "Ativar furto de NPCs",
                },
                pickpocketFleeChance = {
                    description = "Chance independente de o NPC fugir após uma tentativa falha, cancelada ou expirada.",
                    label = "Chance de fuga do NPC (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Alcance máximo do cliente; o servidor valida com uma pequena margem de sincronização.",
                    label = "Distância de interação",
                },
                pickpocketItems = {
                    description = "Cada linha controla sua chance de aparecer. Quatro casas decimais suportam 0.0001 por cento.",
                    itemLabel = "Chance do item",
                    label = "Saque do item",
                },
                pickpocketItemsEnabled = {
                    description = "Também sorteia itens configurados para o conteúdo visível do bolso.",
                    label = "Ativar saque de itens",
                },
                pickpocketMaximumLootChoices = {
                    description = "Número máximo de slots de dinheiro ou itens gerados pelo servidor exibidos para um NPC.",
                    label = "Saque visível máximo",
                },
                pickpocketMinigame = {
                    description = "Escolhe um desafio ou rotaciona aleatoriamente entre os três.",
                    label = "Minijogo",
                    options = {
                        pulse = "Pulso de pressão",
                        random = "Rotação aleatória",
                        sequence = "Sequência de direção",
                        timing = "Barra de tempo",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Maior valor de dinheiro visível; mantido automaticamente no valor mínimo ou acima.",
                    label = "Dinheiro máximo",
                },
                pickpocketMoneyMinimum = {
                    description = "Menor valor gerado pelo servidor para um slot de dinheiro visível.",
                    label = "Dinheiro mínimo",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Segundos mínimos entre solicitações de início de um jogador.",
                    label = "Cooldown de solicitação",
                },
                pickpocketRequireCrimeJob = {
                    description = "Ativado: adiciona a ação apenas para cargos registrados no Sistema de Crime. Desativado: remove a ação radial integrada e exige a exportação do servidor.",
                    label = "Usar menu radial de cargo de crime",
                },
                pickpocketRequiredHits = {
                    description = "Valor base para cada minijogo. Dinheiro valioso aumenta o valor gradualmente; itens extremamente raros exigem pelo menos oito acertos.",
                    label = "Mínimo de acertos",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Segundos antes que um desafio de servidor não finalizado expire.",
                    label = "Tempo limite da sessão",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Bloqueio após tentativas canceladas ou falhas; NPCs esvaziados com sucesso permanecem indisponíveis.",
                    label = "Cooldown de NPC",
                },
                pvpAdminAce = {
                    description = "Objeto ACE que concede acesso ao gerenciamento global de eventos PvP.",
                    label = "ACE de Administrador",
                },
                pvpArenaReturnSeconds = {
                    description = "Tempo de retorno padrão para novos eventos. Os líderes de evento podem alterá-lo no tablet.",
                    label = "Tempo de retorno da arena",
                },
                pvpArenaWarningPosition = {
                    description = "Controla onde o aviso de retorno à arena aparece.",
                    label = "Posição do aviso da arena",
                    options = {
                        bottom_center = "Inferior central",
                        bottom_left = "Inferior esquerdo",
                        bottom_right = "Inferior direito",
                        middle_center = "Centro da tela",
                        middle_left = "Meio à esquerda",
                        middle_right = "Meio à direita",
                        top_center = "Superior central",
                        top_left = "Superior esquerdo",
                        top_right = "Superior direito",
                    },
                },
                pvpArenas = {
                    description = "Cria zonas de combate circulares com um ponto de observação e pelo menos dois pontos de spawn de equipe.",
                    itemLabel = "Arena",
                    label = "Arenas PvP",
                },
                pvpCountdownPosition = {
                    description = "Controla onde a contagem regressiva de início da partida aparece.",
                    label = "Posição da contagem regressiva",
                    options = {
                        bottom_center = "Inferior central",
                        bottom_left = "Inferior esquerdo",
                        bottom_right = "Inferior direito",
                        middle_center = "Centro da tela",
                        middle_left = "Meio à esquerda",
                        middle_right = "Meio à direita",
                        top_center = "Superior central",
                        top_left = "Superior esquerdo",
                        top_right = "Superior direito",
                    },
                },
                pvpDefaultMode = {
                    description = "Modo de jogo pré-selecionado para novos eventos.",
                    label = "Modo de jogo padrão",
                    options = {
                        free_for_all = "Todos Contra Todos",
                        last_man_standing = "Último Sobrevivente",
                        team_deathmatch = "Mata-Mata em Equipe",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Número padrão de abates necessários para vencer o Team Deathmatch ou Free For All.",
                    label = "Alvo de abate padrão",
                },
                pvpEventsEnabled = {
                    description = "Torna o aplicativo de tablet de PvP de facção e a execução de eventos disponíveis.",
                    label = "Ativar eventos de PvP de facção",
                },
                pvpKillfeedPosition = {
                    description = "Controla onde as eliminações recentes são exibidas.",
                    label = "Posição do Killfeed",
                    options = {
                        bottom_center = "Inferior central",
                        bottom_left = "Inferior esquerdo",
                        bottom_right = "Inferior direito",
                        middle_center = "Centro da tela",
                        middle_left = "Meio à esquerda",
                        middle_right = "Meio à direita",
                        top_center = "Superior central",
                        top_left = "Superior esquerdo",
                        top_right = "Superior direito",
                    },
                },
                pvpLeaderPermission = {
                    description = "Permissão de cargo necessária para criar, registrar, iniciar e gerenciar eventos de facção.",
                    label = "Permissão de líder de facção",
                },
                pvpMatchDurationMinutes = {
                    description = "Duração padrão em minutos para novos eventos. Zero desativa o limite de tempo.",
                    label = "Duração da partida",
                },
                pvpMaxHistory = {
                    description = "Número máximo de eventos finalizados ou cancelados retornados ao tablet.",
                    label = "Histórico de eventos visível",
                },
                pvpMaxRewards = {
                    description = "Número máximo de recompensas combinadas de itens, armas, veículos ou dinheiro por evento.",
                    label = "Máximo de recompensas adicionais",
                },
                pvpMoneyPermission = {
                    description = "Permissão de cargo necessária para taxas de entrada e prêmios.",
                    label = "Permissão financeira da facção",
                },
                pvpRequestCooldownMs = {
                    description = "Milissegundos mínimos entre solicitações de PvP mutáveis de um jogador.",
                    label = "Cooldown de ação",
                },
                pvpRespawnDelaySeconds = {
                    description = "Segundos antes de um jogador renascer ou ser movido para a área de observação após a morte.",
                    label = "Atraso de respawn",
                },
                pvpSchedulePollSeconds = {
                    description = "Segundos entre as verificações de modelos recorrentes e inícios automáticos.",
                    label = "Intervalo de verificação de cronograma",
                },
                pvpScoreboardPosition = {
                    description = "Controla onde o placar de vida compacto aparece durante confrontos de facção.",
                    label = "Posição no placar",
                    options = {
                        bottom_center = "Inferior central",
                        bottom_left = "Inferior esquerdo",
                        bottom_right = "Inferior direito",
                        middle_center = "Centro da tela",
                        middle_left = "Meio à esquerda",
                        middle_right = "Meio à direita",
                        top_center = "Superior central",
                        top_left = "Superior esquerdo",
                        top_right = "Superior direito",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Permite que administradores de PvP se registrem e iniciem manualmente com um membro da facção. Desative isso em servidores de produção.",
                    label = "Ativar teste solo de administrador",
                },
                pvpStartCountdownSeconds = {
                    description = "Contagem regressiva padrão para novos eventos criados. Os líderes do evento podem alterá-la no tablet.",
                    label = "Iniciar contagem regressiva",
                },
                pvpTabletOrder = {
                    description = "Controla onde o app de PvP de facção aparece no tablet.",
                    label = "Ordem do app no tablet",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minutos antes de um assalto abandonado falhar.",
                    label = "Tempo limite de atividade",
                },
                shopConsumeDrill = {
                    description = "Consumir a furadeira após a abertura bem-sucedida.",
                    label = "Consumir furadeira",
                },
                shopConsumeHackItem = {
                    description = "Consumir o item de hacking após abrir o cofre com sucesso.",
                    label = "Consumir item de hacking",
                },
                shopCooldownMinutes = {
                    description = "Minutos de tempo de execução antes que a loja resete.",
                    label = "Cooldown da loja",
                },
                shopDispatchAlways = {
                    description = "Comunicar uma vez cada assalto a uma loja ao começar, mesmo com intimidação contínua e em lojas sem funcionário obrigatório.",
                    label = "Enviar sempre um alerta",
                },
                shopDispatchDurationSeconds = {
                    description = "Segundos que o alerta permanece relevante.",
                    label = "Duração do despacho",
                },
                shopDispatchJobs = {
                    description = "Cargos de destinatários de alerta separados por vírgula.",
                    label = "Jobs de despacho",
                },
                shopDispatchPriority = {
                    description = "Prioridade enviada ao despacho.",
                    label = "Prioridade de despacho",
                },
                shopDispatchRadius = {
                    description = "Raio aproximado de alerta policial.",
                    label = "Raio de despacho",
                },
                shopDrillDurationSeconds = {
                    description = "Segundos necessários para perfurar o cofre.",
                    label = "Duração da perfuração do cofre",
                },
                shopDrillItem = {
                    description = "ID do item do inventário necessário para perfurar cofres de lojas. Configuração independente da furadeira dos caixas eletrônicos.",
                    label = "Item de furadeira",
                },
                shopDrillItemAmount = {
                    description = "Número de itens de furadeira necessários.",
                    label = "Quantidade de furadeiras necessária",
                },
                shopEnabled = {
                    description = "Ativa assaltos em lojas configuradas com funcionários.",
                    label = "Ativar assaltos a lojas",
                },
                shopHackItem = {
                    description = "Item necessário para o minijogo de hacking do cofre. Ative o método de abertura separadamente para cada loja.",
                    label = "Item de hacking",
                },
                shopHackItemAmount = {
                    description = "Quantidade necessária do item de hacking.",
                    label = "Quantidade de item de hacking",
                },
                shopIntimidationSeconds = {
                    description = "Segundos que o atendente deve permanecer sob mira de arma.",
                    label = "Duração da intimidação",
                },
                shopLocations = {
                    description = "Um atendente, uma caixa registradora e um cofre opcional por loja.",
                    itemLabel = "Loja",
                    label = "Locais de lojas",
                },
                shopMinimumPolice = {
                    description = "Membros da equipe de polícia em serviço necessários para iniciar.",
                    label = "Mínimo de polícia",
                },
                shopPoliceGroup = {
                    description = "Grupo de cargo contado para o requisito policial.",
                    label = "Grupo de cargo da polícia",
                },
                shopRegisterDurationSeconds = {
                    description = "Segundos necessários para esvaziar um caixa.",
                    label = "Duração do saque do caixa",
                },
                shopRegisterRewardMaximum = {
                    description = "Maior pagamento do caixa.",
                    label = "Recompensa máxima do caixa",
                },
                shopRegisterRewardMinimum = {
                    description = "Pagamento mínimo do caixa.",
                    label = "Recompensa mínima do caixa",
                },
                shopRegisterRewardName = {
                    description = "Nome opcional de item ou conta.",
                    label = "Nome da recompensa do caixa",
                },
                shopRegisterRewardSort = {
                    description = "Escolha entre dinheiro e o item black_money.",
                    label = "Tipo de pagamento da caixa",
                },
                shopRegisters = {
                    description = "Posições de caixa atribuídas por ID da loja.",
                    itemLabel = "Caixa",
                    label = "Caixas registradoras",
                },
                shopSafeLootDurationSeconds = {
                    description = "Segundos necessários para pegar o dinheiro após inserir um código de cofre válido.",
                    label = "Duração do saque do cofre",
                },
                shopSafeRewardMaximum = {
                    description = "Maior pagamento do cofre.",
                    label = "Recompensa máxima do cofre",
                },
                shopSafeRewardMinimum = {
                    description = "Pagamento mínimo do cofre.",
                    label = "Recompensa mínima do cofre",
                },
                shopSafeRewardName = {
                    description = "Nome opcional de item ou conta.",
                    label = "Nome da recompensa do cofre",
                },
                shopSafeRewardSort = {
                    description = "Escolha entre dinheiro e o item black_money.",
                    label = "Tipo de pagamento do cofre",
                },
                shopThreatGraceSeconds = {
                    description = "Interrupção permitida antes do alarme.",
                    label = "Período de tolerância de mira",
                },
                territoryDrugSalesEnabled = {
                    description = "Vendas de rua bem-sucedidas para NPCs concedem influência à gangue do vendedor no território de Rua atual.",
                    label = "Vendas para NPCs concedem influência de território",
                },
                atmLocationMode = {
                    label = "Modo de localização dos caixas",
                    description = "Detecta objetos compatíveis no mundo automaticamente ou usa apenas locais configurados manualmente.",
                    options = {
                        automatic = "Automático",
                        manual = "Manual",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Exigir policiais em serviço",
                    description = "Exige o número configurado de policiais em serviço antes de iniciar um roubo a caixa eletrônico.",
                },
                openDrugCreator = {
                    label = "Editor de drogas",
                    description = "Abre o editor de drogas do Sky Crime e fecha o configurador de empregos.",
                    buttonLabel = "Abrir editor de drogas",
                    unsavedTooltip = "Salve primeiro",
                },
                drugCreatorRuntimeDensity = {
                    label = "Densidade do painel operacional",
                    description = "Define a compactação do painel operacional no editor de drogas.",
                    options = {
                        comfortable = "Confortável",
                        compact = "Compacto",
                    },
                },
                drugCreatorListDensity = {
                    label = "Densidade da lista",
                    description = "Define a compactação da lista de entradas no editor.",
                    options = {
                        comfortable = "Confortável",
                        compact = "Compacto",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Mostrar listas operacionais vazias",
                    description = "Mostra as seções do painel operacional mesmo sem entradas.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Ocultar entradas desativadas",
                    description = "Oculta entradas de módulos desativadas na lista do editor de drogas.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Gerar IDs automaticamente",
                    description = "Gera os IDs a partir dos nomes ao criar entradas no editor de drogas.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Abrir editor ao trocar módulo",
                    description = "Abre o editor automaticamente ao trocar o módulo ativo.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Sufixo automático para cópias",
                    description = "Adiciona um sufixo automático ao duplicar entradas no editor de drogas.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Pré-selecionar alvos do jogo",
                    description = "Pré-seleciona automaticamente laboratórios e lotes disponíveis.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Focar problemas ao abrir",
                    description = "Abre o painel operacional com foco nas entradas que precisam de atenção.",
                },
                drugActivityHudPosition = {
                    label = "Posição do HUD de atividade",
                    description = "Arraste o HUD de colocação e colheita para a posição desejada no ecrã.",
                },
                drugInteractionHudPosition = {
                    label = "Posição do HUD de interação",
                    description = "Arraste o HUD de interação de plantas, laboratórios e autocaravanas para a posição desejada.",
                },
                drugPlantStatusHudPosition = {
                    label = "Posição do HUD de estado da planta",
                    description = "Arraste o HUD detalhado do estado da planta para a posição desejada no ecrã.",
                },
                drugSystemEnabled = {
                    label = "Sistema de drogas",
                    description = "Ativa: produção de drogas, dados do editor e interfaces de jogo para este emprego criminoso.",
                },
                drugCreatorAccess = {
                    label = "Acesso ao editor de drogas",
                    description = "Define quem pode abrir o editor avançado de drogas.",
                    options = {
                        permission = "Apenas com permissão",
                        job_management = "Gestão do emprego",
                        owner_only = "Apenas proprietário",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfaces operacionais",
                    description = "Permite usar as ações de laboratório, plantas, processamento e mercado no jogo.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Criação de laboratórios por jogadores",
                    description = "Permite que jogadores com acesso ao sistema criem laboratórios a partir dos modelos do editor, mesmo sem serem administradores.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Cultivo ao ar livre",
                    description = "Permite plantações externas de jogadores fora dos laboratórios configurados.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Colheita externa por outros jogadores",
                    description = "Permite que outros jogadores colham plantas externas que não plantaram.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Cobrar compra do laboratório",
                    description = "Cobra dos jogadores o preço configurado ao criar um laboratório.",
                },
                drugRuntimeStrictInventory = {
                    label = "Validar inventário rigorosamente",
                    description = "As ações só continuam se as operações configuradas de itens, ferramentas e dinheiro forem bem-sucedidas.",
                },
                drugRuntimeSalePayouts = {
                    label = "Venda / Pagamentos",
                    description = "Paga aos jogadores quando lotes ou rotas são vendidos pelo sistema de mercado.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Pagamento / Conta",
                    description = "Conta usada para pagamentos de vendas de drogas, por exemplo black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Expedição / Alertas",
                    description = "Encaminha eventos de risco de drogas à central e aos empregos policiais configurados.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Polícia / Notificações",
                    description = "Notifica os empregos policiais configurados quando um evento de risco de drogas gera um alerta.",
                },
                drugBatchPrefix = {
                    label = "Lote / Prefixo",
                    description = "Prefixo dos IDs de novos lotes de drogas.",
                },
                drugTestingKitAccuracy = {
                    label = "Kit de Teste / Precisão",
                    description = "Variação permitida dos valores ocultos com um kit de teste básico.",
                },
                drugDecayIntervalMinutes = {
                    label = "Decadência / Intervalo",
                    description = "Intervalo em minutos para verificações de perda de frescor e redução de contaminação.",
                },
                drugDefaultPackaging = {
                    label = "Valor padrão / Embalagem",
                    description = "Embalagem de lotes brutos ou processados criados sem um tipo de embalagem explícito.",
                    options = {
                        loose = "Granel",
                        baggy = "Saquinho",
                        jar = "Pote",
                        vacuum = "Saco a vácuo",
                        brick = "Embalagem de bloco",
                        premium_seal = "Selagem premium",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Qualidade / Peso",
                    description = "Influência na qualidade final: Qualidade base.",
                },
                drugQualityWeightPurity = {
                    label = "Pureza / Peso",
                    description = "Influência na qualidade final: Pureza.",
                },
                drugQualityWeightFreshness = {
                    label = "Frescor / Peso",
                    description = "Influência na qualidade final: Frescor.",
                },
                drugQualityWeightPotency = {
                    label = "Potência / Peso",
                    description = "Influência na qualidade final: Potência.",
                },
                drugQualityWeightStability = {
                    label = "Estabilidade / Peso",
                    description = "Influência na qualidade final: Estabilidade.",
                },
                drugQualityWeightContamination = {
                    label = "Contaminação / Penalidade",
                    description = "Penalidade de qualidade para produtos contaminados.",
                },
                drugTierGoodMin = {
                    label = "Bom / Nível / Mínimo",
                    description = "Pontuação mínima para o nível de qualidade Bom.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Nível / Mínimo",
                    description = "Pontuação mínima para o nível de qualidade Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Qualidade superior / Nível / Mínimo",
                    description = "Pontuação mínima para o nível de qualidade Qualidade superior.",
                },
                drugTierLabGradeMin = {
                    label = "Qualidade de laboratório / Nível / Mínimo",
                    description = "Pontuação mínima para o nível de qualidade Qualidade de laboratório.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Saquinho / Decadência",
                    description = "Multiplicador para perda de frescor / Saquinhos.",
                },
                drugJarDecayMultiplier = {
                    label = "Pote / Decadência",
                    description = "Multiplicador para perda de frescor / Potes.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vácuo / Decadência",
                    description = "Multiplicador para perda de frescor / Sacos a vácuo.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Selagem premium / Preço",
                    description = "Multiplicador para Premium / Produto selado / Preço.",
                },
                drugGrowingEnabled = {
                    label = "Cultivo / Ativado",
                    description = "Ativa: crescimento das plantas e colheita.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Verificação do local de plantio",
                    description = "Quando ativada, as plantas colocadas livremente aguardam uma verificação automática do local por um administrador. Desative para permitir o crescimento sem aprovação administrativa.",
                },
                drugGrowthTickMinutes = {
                    label = "Crescimento / Ciclo de atualização / Minutos",
                    description = "Intervalo em minutos para atualizações do crescimento das plantas.",
                },
                drugBaseGrowthPerTick = {
                    label = "Valor base / Crescimento / Por ciclo de atualização",
                    description = "Crescimento base antes dos modificadores de variedade, equipamento e cuidados.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Planta selvagem / Reaparecimento",
                    description = "Espera em minutos antes de: Planta selvagem / Reaparecimento.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Destacar plantas silvestres",
                    description = "Mostra o contorno das plantas silvestres geradas quando um jogador entra no raio de destaque.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Raio de destaque das plantas silvestres",
                    description = "Distância em metros em torno de cada planta silvestre gerada em que o seu contorno fica visível.",
                },
                drugDefaultPlantWater = {
                    label = "Valor padrão / Água",
                    description = "Valor inicial ao criar uma planta: Água.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Valor padrão / Fertilizante",
                    description = "Valor inicial ao criar uma planta: Fertilizante.",
                },
                drugDefaultPlantHealth = {
                    label = "Valor padrão / Vida",
                    description = "Valor inicial ao criar uma planta: Vida.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Valor padrão / Chance de mutação",
                    description = "Probabilidade básica de mutação quando a variedade não define um valor próprio.",
                },
                drugHarvestPerfectStart = {
                    label = "Início da colheita ideal",
                    description = "Porcentagem de crescimento para a janela ideal de colheita: Início.",
                },
                drugHarvestPerfectEnd = {
                    label = "Fim da colheita ideal",
                    description = "Porcentagem de crescimento para a janela ideal de colheita: Fim.",
                },
                drugLabsEnabled = {
                    label = "Laboratórios / Ativado",
                    description = "Ativa: laboratórios e trailers no jogo.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratórios por personagem",
                    description = "Número máximo de laboratórios fixos comprados ou alugados por proprietário. 0 significa ilimitado; autocaravanas e acessos partilhados não contam.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratórios por facção",
                    description = "Número máximo de laboratórios fixos comprados ou alugados por proprietário. 0 significa ilimitado; autocaravanas e acessos partilhados não contam.",
                },
                drugDefaultRentDays = {
                    label = "Valor padrão / Dias de Aluguel",
                    description = "Valor padrão para Laboratório / Aluguel / Duração.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Trailer roubado / Minutos",
                    description = "Tempo durante o qual os trailers roubados apresentam risco elevado.",
                },
                drugLabRentWarningHours = {
                    label = "Aluguel / Aviso / Horas",
                    description = "Horas antes do vencimento do aluguel do laboratório para exibir um aviso.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Aluguel vencido / Pressão policial",
                    description = "Suspeita adicionada quando o aluguel do laboratório vence.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Motorhome / Mover / Tempo de recarga",
                    description = "Espera em minutos antes de: Motorhome / Laboratório / Novo deslocamento.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Melhoria / Custo / Multiplicador",
                    description = "Multiplicador para Laboratório / Nível / Melhoria / Preços.",
                },
                drugCamperBaseSlots = {
                    label = "Motorhome / Espaços",
                    description = "Valor padrão para laboratórios em trailers / espaços de equipamentos.",
                },
                drugCamperBaseStorage = {
                    label = "Motorhome / Armazenamento",
                    description = "Valor padrão para laboratórios em trailers / Capacidade de Armazenamento.",
                },
                drugCamperBasePower = {
                    label = "Motorhome / Energia",
                    description = "Valor padrão para laboratórios em trailers / Alimentação integrada.",
                },
                drugBasementBaseSlots = {
                    label = "Porão / Espaços",
                    description = "Valor padrão para laboratórios em porões / espaços de equipamentos.",
                },
                drugBasementBaseStorage = {
                    label = "Porão / Armazenamento",
                    description = "Valor padrão para laboratórios em porões / Capacidade de Armazenamento.",
                },
                drugWarehouseBasePower = {
                    label = "Armazém / Energia",
                    description = "Valor padrão para laboratórios em armazéns / Alimentação integrada.",
                },
                drugPowerEnabled = {
                    label = "Energia / Sistema",
                    description = "Ativa: geração elétrica, consumo e verificações de sobrecarga do laboratório.",
                },
                drugOverloadGraceSeconds = {
                    label = "Sobrecarga / Prazo de tolerância",
                    description = "Segundos até que uma sobrecarga elétrica se torne perigosa.",
                },
                drugHeatPerKilowatt = {
                    label = "Pressão policial / Por quilowatt",
                    description = "Suspeita do laboratório gerada pelo consumo elétrico.",
                },
                drugGeneratorT1Watts = {
                    label = "Gerador T1 / Watts",
                    description = "Potência dos geradores de nível T1 em watts.",
                },
                drugGeneratorT2Watts = {
                    label = "Gerador T2 / Watts",
                    description = "Potência dos geradores de nível T2 em watts.",
                },
                drugGeneratorT3Watts = {
                    label = "Gerador T3 / Watts",
                    description = "Potência dos geradores de nível T3 em watts.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Desgaste / Multiplicador",
                    description = "Multiplicador global para Desgaste do Equipamento / Processamento.",
                },
                drugWorkersEnabled = {
                    label = "Funcionários / Ativado",
                    description = "Ativa: químicos, cultivadores, embaladores e seguranças nos laboratórios de drogas.",
                },
                drugMaxWorkersPerLab = {
                    label = "Máximo / Funcionários / Laboratório",
                    description = "Número máximo de trabalhadores por laboratório.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Fadiga por processamento",
                    description = "Fadiga adicionada para Funcionários após este trabalho: Etapa de processamento.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Cultivo / Fadiga",
                    description = "Fadiga adicionada para Cultivadores após este trabalho: Colheita ou cultivo.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Trabalhador / Recuperação",
                    description = "Recuperação de Fadiga a cada etapa: Atualização de crescimento.",
                },
                drugMarketEnabled = {
                    label = "Mercado / Ativado",
                    description = "Ativa: compradores, traficantes e vendas de lotes.",
                },
                drugMarketBasePriceFallback = {
                    label = "Valor alternativo / Preço Base",
                    description = "Preço base para drogas sem preço específico configurado.",
                },
                drugMarketStreetMultiplier = {
                    label = "Rua / Multiplicador",
                    description = "Multiplicador global para Preço / Vendas de Rua.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Grossista / Multiplicador",
                    description = "Multiplicador global para Preço / Grossista / Negócios.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Multiplicador",
                    description = "Multiplicador global para Preço / Premium / Compradores.",
                },
                drugMarketHeatPerSale = {
                    label = "Pressão policial / Venda",
                    description = "Pressão policial básica adicionada ao laboratório ao vender um lote.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribuição / Ciclo de atualização",
                    description = "Intervalo em minutos para atualizações de distribuição dos traficantes.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribuição / Intervalo",
                    description = "Valor padrão para Revendedor / Espera antes da venda / Minutos.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Máximo / Revendedor / Encomendas",
                    description = "Valor padrão para Revendedor / número máximo de pedidos de distribuição ativos.",
                },
                drugThreatsEnabled = {
                    label = "Ameaças / Ativado",
                    description = "Ativa: redução da suspeita, batidas e sabotagens nos laboratórios.",
                },
                drugThreatTickMinutes = {
                    label = "Ameaça / Ciclo de atualização",
                    description = "Intervalo em minutos para redução da suspeita e verificações de batida e sabotagem.",
                },
                drugRaidHeatThreshold = {
                    label = "Limite de suspeita para batidas",
                    description = "Pressão policial necessária no laboratório para poder ativar: Batidas.",
                },
                drugSabotageHeatThreshold = {
                    label = "Limite de suspeita para sabotagem",
                    description = "Pressão policial necessária no laboratório para poder ativar: Sabotagem.",
                },
                drugThreatHeatDecay = {
                    label = "Pressão policial / Decadência",
                    description = "Reduz a suspeita do laboratório por este valor a cada atualização de ameaças.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Probabilidade de batida",
                    description = "Probabilidade base de Ataque ao atingir o limite de pressão policial correspondente.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotagem / Chance",
                    description = "Probabilidade base de Sabotagem ao atingir o limite de pressão policial correspondente.",
                },
                drugConsumptionEnabled = {
                    label = "Consumo ativado",
                    description = "Ativa: efeitos de drogas e acompanhamento de tolerância e dependência.",
                },
                drugDoseConsumesBatch = {
                    label = "Consumir lote ao usar",
                    description = "Remove um lote consumido do estoque ativo.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolerância / Decadência",
                    description = "Intervalo em minutos para atualizações da redução de tolerância.",
                },
                drugAddictionDecayMinutes = {
                    label = "Vício / Decadência",
                    description = "Intervalo em minutos para atualizações da redução de dependência.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Potência / Multiplicador",
                    description = "Determina quanto a potência aumenta a intensidade dos efeitos.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Overdose / Limite",
                    description = "Carga de potência necessária antes de uma verificação de overdose.",
                },
                drugBaseAddictionGain = {
                    label = "Valor base / Vício / ganho",
                    description = "Aumento básico da dependência por dose.",
                },
                drugProcessingEnabled = {
                    label = "Processamento / Ativado",
                    description = "Ativa: tarefas de processamento, embalagem e kits de teste.",
                },
                drugBatchMetadataItemKey = {
                    label = "Lote / Metadados / Chave",
                    description = "Chave de metadados do inventário usada pelas integrações para os dados dos lotes.",
                },
                drugDefaultProcessDuration = {
                    label = "Duração padrão do processamento",
                    description = "Valor padrão para Processamento / Duração / segundos / Sem valor próprio da receita.",
                },
                drugDefaultFailureRisk = {
                    label = "Valor padrão / Risco de Falha",
                    description = "Valor padrão para Processamento / Risco de Falha / Sem valor próprio da receita.",
                },
                drugPackagingDuration = {
                    label = "Tempo de embalagem",
                    description = "Valor padrão para Embalagem / Duração / segundos.",
                },
                drugPowerTickSeconds = {
                    label = "Energia / Ciclo de atualização / segundos",
                    description = "Intervalo em segundos para atualização do consumo dos geradores e das assinaturas elétricas.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Assinatura elétrica / Pressão policial / Hora",
                    description = "Suspeita gerada por hora pela assinatura elétrica do laboratório.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Sobrecarga / Pressão policial / Hora",
                    description = "Pressão policial adicional por hora enquanto o laboratório está sobrecarregado.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Inactivo / Pressão policial / Decadência / Hora",
                    description = "Redução da suspeita por hora enquanto o laboratório não tiver uma assinatura elétrica ativa.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manual / Máximo / Carga",
                    description = "Valor do modo de energia Manual: Máximo / Carga.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manual / Pressão policial / Multiplicador",
                    description = "Valor do modo de energia Manual: Pressão policial / Multiplicador.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manual / Ruído / Multiplicador",
                    description = "Valor do modo de energia Manual: Ruído / Multiplicador.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Equilibrado / Máximo / Carga",
                    description = "Valor do modo de energia Equilibrado: Máximo / Carga.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Equilibrado / Pressão policial / Multiplicador",
                    description = "Valor do modo de energia Equilibrado: Pressão policial / Multiplicador.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Equilibrado / Ruído / Multiplicador",
                    description = "Valor do modo de energia Equilibrado: Ruído / Multiplicador.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Furtivo / Máximo / Carga",
                    description = "Valor do modo de energia Furtivo: Máximo / Carga.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Furtivo / Pressão policial / Multiplicador",
                    description = "Valor do modo de energia Furtivo: Pressão policial / Multiplicador.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Furtivo / Ruído / Multiplicador",
                    description = "Valor do modo de energia Furtivo: Ruído / Multiplicador.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Controle de odores / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Controle de odores / Equipamento.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilação / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Ventilação / Equipamento.",
                },
                drugPowerPrioritySecurity = {
                    label = "Segurança / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Equipamento de segurança.",
                },
                drugPowerPriorityGrowing = {
                    label = "Cultivo / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Cultivo / Equipamento.",
                },
                drugPowerPriorityLight = {
                    label = "Iluminação / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Iluminação / Equipamento.",
                },
                drugPowerPriorityTesting = {
                    label = "Análise / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Análise / Equipamento.",
                },
                drugPowerPriorityPackaging = {
                    label = "Embalagem / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Embalagem / Equipamento.",
                },
                drugPowerPriorityChemistry = {
                    label = "Química / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Química / Equipamento.",
                },
                drugPowerPriorityHeating = {
                    label = "Aquecimento / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Aquecimento / Equipamento.",
                },
                drugPowerPriorityPressing = {
                    label = "Prensagem / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Prensagem / Equipamento.",
                },
                drugPowerPriorityGeneral = {
                    label = "Geral / Prioridade",
                    description = "Prioridade de desligamento automático de cargas: Equipamento geral.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Desempenho / Inativo / Controle / Intervalo / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Inativo / Controle / Intervalo / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Desempenho / Interação / Inactivo / Intervalo de análise / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Interação / Inactivo / Intervalo de análise / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Desempenho / Interação / Aviso de interação / Intervalo / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Interação / Aviso de interação / Intervalo / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Desempenho / Interação / Intervalo de análise / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Interação / Intervalo de análise / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Desempenho / Mínimo / Intervalo de análise / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Mínimo / Intervalo de análise / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Desempenho / Rua / Ped / Ativação / Distância",
                    description = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Ativação / Distância.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Desempenho / Rua / Ped / Inactivo / Intervalo de análise / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Inactivo / Intervalo de análise / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Desempenho / Rua / Ped / Intervalo de análise / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Rua / Ped / Intervalo de análise / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Desempenho / Mundo / Cache / Margem adicional",
                    description = "Parâmetro de funcionamento para Desempenho / Mundo / Cache / Margem adicional.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Desempenho / Mundo / Cache / Atualização / Intervalo / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Mundo / Cache / Atualização / Intervalo / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Desempenho / Mundo / Inactivo / Intervalo / ms",
                    description = "Parâmetro de funcionamento para Desempenho / Mundo / Inactivo / Intervalo / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Mercado Dinâmico / Cooldown de ação / segundos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Cooldown de ação / segundos.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Mercado Dinâmico / Ação / Limite do histórico",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Ação / Limite do histórico.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Mercado Dinâmico / Quantidade / Saturação / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Quantidade / Saturação / Peso.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Mercado Dinâmico / Valor base / Precisão da inteligência",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Valor base / Precisão da inteligência.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Mercado Dinâmico / Valor padrão / Média / Qualidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Valor padrão / Média / Qualidade.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Mercado Dinâmico / Valor padrão / Recurso / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Valor padrão / Recurso / Elasticidade.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Mercado Dinâmico / Demanda / Valor central",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Demanda / Valor central.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Mercado Dinâmico / Demanda / Preço / Impacto",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Demanda / Preço / Impacto.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Mercado Dinâmico / Direção / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Direção / Limite.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Mercado Dinâmico / Ativado",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Ativado.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Mercado Dinâmico / Evento / Chance",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Chance.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Mercado Dinâmico / Evento / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Duração / Minutos.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Mercado Dinâmico / Evento / Mínimo / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Mínimo / Duração / Minutos.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Mercado Dinâmico / Evento / Intensidade / Máximo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Intensidade / Máximo.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Mercado Dinâmico / Evento / Intensidade / Mínimo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Evento / Intensidade / Mínimo.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Mercado Dinâmico / Eventos / Operação policial / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Operação policial / Demanda.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Mercado Dinâmico / Eventos / Operação policial / Polícia",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Operação policial / Polícia.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Mercado Dinâmico / Eventos / Operação policial / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Operação policial / Preço.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Mercado Dinâmico / Eventos / Festival / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Demanda.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Mercado Dinâmico / Eventos / Festival / Efeitos / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Efeitos / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Mercado Dinâmico / Eventos / Festival / Efeitos / 2",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Efeitos / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Mercado Dinâmico / Eventos / Festival / Efeitos / 3",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Efeitos / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Mercado Dinâmico / Eventos / Festival / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Preço.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Mercado Dinâmico / Eventos / Festival / Perfis / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festival / Perfis / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Mercado Dinâmico / Eventos / Conflito de gangue / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Conflito de gangue / Demanda.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Mercado Dinâmico / Eventos / Conflito de gangue / Polícia",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Conflito de gangue / Polícia.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Mercado Dinâmico / Eventos / Conflito de gangue / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Conflito de gangue / Preço.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Mercado Dinâmico / Eventos / Conflito de gangue / Perfis / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Conflito de gangue / Perfis / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Mercado Dinâmico / Eventos / Batida no laboratório / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Batida no laboratório / Demanda.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Mercado Dinâmico / Eventos / Batida no laboratório / Polícia",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Batida no laboratório / Polícia.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Mercado Dinâmico / Eventos / Batida no laboratório / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Batida no laboratório / Preço.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Mercado Dinâmico / Eventos / Batida no laboratório / Fornecimento",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Batida no laboratório / Fornecimento.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Mercado Dinâmico / Eventos / Festa / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Demanda.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Mercado Dinâmico / Eventos / Festa / Efeitos / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Efeitos / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Mercado Dinâmico / Eventos / Festa / Efeitos / 2",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Efeitos / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Mercado Dinâmico / Eventos / Festa / Efeitos / 3",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Efeitos / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Mercado Dinâmico / Eventos / Festa / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Preço.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Mercado Dinâmico / Eventos / Festa / Perfis / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Perfis / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Mercado Dinâmico / Eventos / Festa / Perfis / 2",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Festa / Perfis / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Mercado Dinâmico / Eventos / Escassez / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Escassez / Demanda.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Mercado Dinâmico / Eventos / Escassez / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Escassez / Preço.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Mercado Dinâmico / Eventos / Escassez / Fornecimento",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Eventos / Escassez / Fornecimento.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Mercado Dinâmico / Informações exatas / Reputação",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações exatas / Reputação.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Mercado Dinâmico / Informações exatas / Confiança",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações exatas / Confiança.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Mercado Dinâmico / Global / Zona / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Global / Zona / Etiqueta.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Mercado Dinâmico / Limite do histórico",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Limite do histórico.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Mercado Dinâmico / Valor inicial / Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Valor inicial / Demanda.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Mercado Dinâmico / Valor inicial / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Valor inicial / Multiplicador de Preço.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Mercado Dinâmico / Informações / Demanda / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Demanda / Erro.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Mercado Dinâmico / Informações / Máximo / Precisão",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Máximo / Precisão.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Mercado Dinâmico / Informações / Mínimo / Precisão",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Mínimo / Precisão.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Mercado Dinâmico / Informações / Polícia / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Polícia / Erro.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Mercado Dinâmico / Informações / Preço / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Erro.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Mercado Dinâmico / Informações / Preço / Máximo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Máximo.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Mercado Dinâmico / Informações / Preço / Mínimo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Preço / Mínimo.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Mercado Dinâmico / Informações / Reputação / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Reputação / Peso.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Mercado Dinâmico / Informações / Recurso / Preço / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Recurso / Preço / Erro.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Mercado Dinâmico / Informações / Saturação / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Saturação / Erro.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Mercado Dinâmico / Janela de semente das informações / segundos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Janela de semente das informações / segundos.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Mercado Dinâmico / Informações / Estado / Precisão / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Estado / Precisão / Limite.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Mercado Dinâmico / Informações / Estado / Erro / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Estado / Erro / Limite.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Mercado Dinâmico / Informações / Fornecimento / Erro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Fornecimento / Erro.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Mercado Dinâmico / Informações / Confiança / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Informações / Confiança / Peso.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Mercado Dinâmico / Manipulação / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Minutos de tempo de espera.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Mercado Dinâmico / Manipulação / Demanda / Variação",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Demanda / Variação.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Mercado Dinâmico / Manipulação / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Duração / Minutos.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Mercado Dinâmico / Manipulação / Pressão policial",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Pressão policial.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Mercado Dinâmico / Manipulação / Mínimo / Lote / Quantidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Mínimo / Lote / Quantidade.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Mercado Dinâmico / Manipulação / Conta de pagamento",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Conta de pagamento.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Mercado Dinâmico / Manipulação / Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Preço.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Mercado Dinâmico / Manipulação / Zona / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Manipulação / Zona / Pressão policial / Multiplicador.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Mercado Dinâmico / Máximo / Idade da inteligência / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Máximo / Idade da inteligência / Minutos.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Mercado Dinâmico / Máximo / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Máximo / Multiplicador de Preço.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Mercado Dinâmico / Mínimo / Idade da inteligência / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Idade da inteligência / Minutos.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Mercado Dinâmico / Mínimo / Métrica / Janela temporal / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Métrica / Janela temporal / Minutos.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Mercado Dinâmico / Preço mínimo / Multiplicador",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Preço mínimo / Multiplicador.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Mercado Dinâmico / Mínimo / Atualização / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Mínimo / Atualização / Minutos.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Mercado Dinâmico / Polícia / Demanda / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Polícia / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Mercado Dinâmico / Polícia / Preço / Impacto",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Polícia / Preço / Impacto.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Mercado Dinâmico / Baixa qualidade / Demanda / Penalidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Baixa qualidade / Demanda / Penalidade.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Mercado Dinâmico / Baixa qualidade / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Baixa qualidade / Limite.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Mercado Dinâmico / Qualidade premium / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade premium / Bônus de Demanda.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Mercado Dinâmico / Qualidade premium / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade premium / Limite.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Mercado Dinâmico / Produção / Fornecimento / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Produção / Fornecimento / Peso.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Mercado Dinâmico / Produção / Janela temporal / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Produção / Janela temporal / Minutos.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Mercado Dinâmico / Qualidade / Valor central",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Valor central.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Mercado Dinâmico / Qualidade / Confiança / Impacto",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Confiança / Impacto.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Mercado Dinâmico / Qualidade / Faixa de valores",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Qualidade / Faixa de valores.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Mercado Dinâmico / Raridade / Bónus / Máximo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Raridade / Bónus / Máximo.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Mercado Dinâmico / Regional / Global / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Regional / Global / Peso.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Mercado Dinâmico / Regional / Local / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Regional / Local / Peso.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Mercado Dinâmico / Recurso / Nomes alternativos / Droga / Embalagem",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Nomes alternativos / Droga / Embalagem.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Mercado Dinâmico / Recurso / Nomes alternativos / Galão de combustível",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Nomes alternativos / Galão de combustível.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Mercado Dinâmico / Recurso / Nomes alternativos / Óleo de máquina",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Nomes alternativos / Óleo de máquina.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Mercado Dinâmico / Recurso / Nomes alternativos / Nutrientes para Plantas",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Nomes alternativos / Nutrientes para Plantas.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Mercado Dinâmico / Recurso / Nomes alternativos / Kit de reparo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Nomes alternativos / Kit de reparo.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Mercado Dinâmico / Recurso / Direção / Queda / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Direção / Queda / Limite.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Mercado Dinâmico / Recurso / Direção / Aumento / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recurso / Direção / Aumento / Limite.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 2",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 3",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Filtro de Carvão / Drogas vinculadas / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Precursor químico / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Precursor químico / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Mercado Dinâmico / Recursos / Precursor químico / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Precursor químico / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Mercado Dinâmico / Recursos / Precursor químico / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Precursor químico / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Mercado Dinâmico / Recursos / Precursor químico / Drogas vinculadas / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Precursor químico / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Mercado Dinâmico / Recursos / Precursor químico / Drogas vinculadas / 2",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Precursor químico / Drogas vinculadas / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Peças de equipamento / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Peças de equipamento / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Mercado Dinâmico / Recursos / Peças de equipamento / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Peças de equipamento / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Mercado Dinâmico / Recursos / Peças de equipamento / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Peças de equipamento / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Fertilizante / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Fertilizante / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Mercado Dinâmico / Recursos / Fertilizante / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Fertilizante / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Mercado Dinâmico / Recursos / Fertilizante / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Fertilizante / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Mercado Dinâmico / Recursos / Fertilizante / Drogas vinculadas / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Fertilizante / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Combustível de laboratório / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Combustível de laboratório / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Mercado Dinâmico / Recursos / Combustível de laboratório / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Combustível de laboratório / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Mercado Dinâmico / Recursos / Combustível de laboratório / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Combustível de laboratório / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Saco de embalagem / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Saco de embalagem / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Mercado Dinâmico / Recursos / Saco de embalagem / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Saco de embalagem / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Mercado Dinâmico / Recursos / Saco de embalagem / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Saco de embalagem / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Vaso de Planta / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Vaso de Planta / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Mercado Dinâmico / Recursos / Vaso de Planta / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Vaso de Planta / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Mercado Dinâmico / Recursos / Vaso de Planta / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Vaso de Planta / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Mercado Dinâmico / Recursos / Vaso de Planta / Drogas vinculadas / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Vaso de Planta / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Mercado Dinâmico / Recursos / Semente de cannabis / Preço Base",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Semente de cannabis / Preço Base.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Mercado Dinâmico / Recursos / Semente de cannabis / Elasticidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Semente de cannabis / Elasticidade.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Mercado Dinâmico / Recursos / Semente de cannabis / Etiqueta",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Semente de cannabis / Etiqueta.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Mercado Dinâmico / Recursos / Semente de cannabis / Drogas vinculadas / 1",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Recursos / Semente de cannabis / Drogas vinculadas / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Mercado Dinâmico / Vendas / Janela temporal / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Vendas / Janela temporal / Minutos.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Mercado Dinâmico / Saturação / Demanda / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Saturação / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Mercado Dinâmico / Saturação / Preço / Impacto",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Saturação / Preço / Impacto.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Mercado Dinâmico / Escassez / Demanda / Peso",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Demanda / Peso.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Mercado Dinâmico / Escassez / Preço / Impacto",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Preço / Impacto.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Mercado Dinâmico / Estação / Fim / Meses / Dezembro",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Fim / Meses / Dezembro.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Mercado Dinâmico / Estação / Fim / Meses / Primavera",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Fim / Meses / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Mercado Dinâmico / Estação / Fim / Meses / Verão",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Fim / Meses / Verão.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Mercado Dinâmico / Estação / Fim / Meses / Inverno",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Fim / Meses / Inverno.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Mercado Dinâmico / Estação / Multiplicadores / Outono",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Multiplicadores / Outono.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Mercado Dinâmico / Estação / Multiplicadores / Primavera",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Multiplicadores / Primavera.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Mercado Dinâmico / Estação / Multiplicadores / Verão",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Multiplicadores / Verão.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Mercado Dinâmico / Estação / Multiplicadores / Inverno",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estação / Multiplicadores / Inverno.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Mercado Dinâmico / Escassez / Rumor / Limite",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Escassez / Rumor / Limite.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Mercado Dinâmico / Estado / Limites / Alta demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estado / Limites / Alta demanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Mercado Dinâmico / Estado / Limites / Procurado",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estado / Limites / Procurado.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Mercado Dinâmico / Estado / Limites / Baixa demanda",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estado / Limites / Baixa demanda.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Mercado Dinâmico / Estado / Limites / Saturado",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Estado / Limites / Saturado.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Mercado Dinâmico / Alvo / Fornecimento",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Alvo / Fornecimento.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Mercado Dinâmico / Tendência / Chance",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Chance.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Mercado Dinâmico / Tendência / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Duração / Minutos.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Mercado Dinâmico / Tendência / Máximo / Intensidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Máximo / Intensidade.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Mercado Dinâmico / Tendência / Mínimo / Intensidade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Tendência / Mínimo / Intensidade.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Mercado Dinâmico / Atualização / Minutos",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Atualização / Minutos.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Mercado Dinâmico / Volatilidade / Máximo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Volatilidade / Máximo.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Mercado Dinâmico / Volatilidade / Mínimo",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Volatilidade / Mínimo.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Mercado Dinâmico / Clima / Multiplicadores / Frio",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Multiplicadores / Frio.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Mercado Dinâmico / Clima / Multiplicadores / Onda de calor",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Multiplicadores / Onda de calor.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Mercado Dinâmico / Clima / Multiplicadores / Normal",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Multiplicadores / Normal.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Mercado Dinâmico / Clima / Multiplicadores / Chuva",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Multiplicadores / Chuva.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Mercado Dinâmico / Clima / Multiplicadores / Tempestade",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Multiplicadores / Tempestade.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Mercado Dinâmico / Clima / Estado",
                    description = "Parâmetro de funcionamento para Mercado Dinâmico / Clima / Estado.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Suspeita e risco / Cooldown de ação / segundos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Cooldown de ação / segundos.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Suspeita e risco / Atividade / Risco / Ponderações / Quantidade",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Atividade / Risco / Ponderações / Quantidade.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Suspeita e risco / Atividade / Risco / Ponderações / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Atividade / Risco / Ponderações / Duração / Minutos.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Suspeita e risco / Atividade / Risco / Ponderações / Pressão policial",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Atividade / Risco / Ponderações / Pressão policial.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Suspeita e risco / Atividade / Risco / Ponderações / Reputação",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Atividade / Risco / Ponderações / Reputação.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Suspeita e risco / Atividade / Risco / Ponderações / Segurança",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Atividade / Risco / Ponderações / Segurança.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Suspeita e risco / Modo agressivo / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Modo agressivo / Pressão policial / Multiplicador.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Suspeita e risco / Telefone descartável / Exposição / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Telefone descartável / Exposição / Limite.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Suspeita e risco / Telefone descartável / Pressão policial / Por venda no atacado",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Telefone descartável / Pressão policial / Por venda no atacado.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Suspeita e risco / Celular Descartável / Item",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Celular Descartável / Item.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Suspeita e risco / Trailer em operação / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trailer em operação / Pressão policial / Multiplicador.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Suspeita e risco / Trailer em operação / Pressão policial / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trailer em operação / Pressão policial / Limite.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Suspeita e risco / Trailer estacionado / Pressão policial",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trailer estacionado / Pressão policial.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Suspeita e risco / Contaminação / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Contaminação / Pressão policial / Multiplicador.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Suspeita e risco / Contaminação / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Contaminação / Limite.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Suspeita e risco / Cultivo / Plantas sem risco adicional",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Cultivo / Plantas sem risco adicional.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Suspeita e risco / Cultivo / Pressão policial / Por planta",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Cultivo / Pressão policial / Por planta.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Suspeita e risco / Revendedor / oculto / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Revendedor / oculto / Minutos.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Lote",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Lote.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Motorhome",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Motorhome.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Revendedor",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Revendedor.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Facção",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Facção.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Centro de distribuição",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Centro de distribuição.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Laboratório",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Laboratório.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Jogador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Jogador.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Rota",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Rota.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Suspeita e risco / Decadência / Por ciclo de atualização / Zona",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Decadência / Por ciclo de atualização / Zona.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Suspeita e risco / Ativado",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Ativado.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Suspeita e risco / Presença policial / Pressão policial / Crítica",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Pressão policial / Crítica.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Suspeita e risco / Presença policial / Pressão policial / Alta",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Pressão policial / Alta.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Suspeita e risco / Presença policial / Pressão policial / Baixa",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Pressão policial / Baixa.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Suspeita e risco / Presença policial / Pressão policial / Média",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Pressão policial / Média.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Suspeita e risco / Presença policial / Multiplicadores / Lote",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Multiplicadores / Lote.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Suspeita e risco / Presença policial / Multiplicadores / Facção",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Multiplicadores / Facção.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Suspeita e risco / Presença policial / Multiplicadores / Zona",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Presença policial / Multiplicadores / Zona.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Suspeita e risco / Entidade / Tipos / Lote",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Lote.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Suspeita e risco / Entidade / Tipos / Motorhome",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Motorhome.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Suspeita e risco / Entidade / Tipos / Revendedor",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Revendedor.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Suspeita e risco / Entidade / Tipos / Facção",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Facção.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Suspeita e risco / Entidade / Tipos / Centro de distribuição",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Centro de distribuição.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Suspeita e risco / Entidade / Tipos / Laboratório",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Laboratório.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Suspeita e risco / Entidade / Tipos / Jogador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Jogador.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Suspeita e risco / Entidade / Tipos / Rota",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Rota.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Suspeita e risco / Entidade / Tipos / Zona",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Entidade / Tipos / Zona.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Suspeita e risco / Evento / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Evento / Minutos de tempo de espera.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Suspeita e risco / Evento / Limite do histórico",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Evento / Limite do histórico.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Suspeita e risco / Laboratório / Pressão policial / Sincronização / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Laboratório / Pressão policial / Sincronização / Limite.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Suspeita e risco / Manter discrição / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Minutos de tempo de espera.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Suspeita e risco / Manter discrição / Inactivo / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Inactivo / Minutos.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Suspeita e risco / Manter discrição / Redução",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Manter discrição / Redução.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Suspeita e risco / Bloqueio / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Bloqueio / Minutos.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Suspeita e risco / Mínimo / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Duração / Minutos.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Suspeita e risco / Mínimo / Evento / Cooldown (segundos)",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Evento / Cooldown (segundos).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Suspeita e risco / Mínimo / Inactivo / segundos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Mínimo / Inactivo / segundos.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Suspeita e risco / Processamento / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Processamento / Pressão policial / Multiplicador.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Suspeita e risco / Risco / Ponderações / Lote",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Lote.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Suspeita e risco / Risco / Ponderações / Motorhome",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Motorhome.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Suspeita e risco / Risco / Ponderações / Revendedor",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Revendedor.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Suspeita e risco / Risco / Ponderações / Facção",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Facção.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Suspeita e risco / Risco / Ponderações / Centro de distribuição",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Centro de distribuição.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Suspeita e risco / Risco / Ponderações / Laboratório",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Laboratório.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Suspeita e risco / Risco / Ponderações / Jogador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Jogador.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Suspeita e risco / Risco / Ponderações / Rota",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Rota.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Suspeita e risco / Risco / Ponderações / Zona",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Risco / Ponderações / Zona.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Suspeita e risco / Trocar telefone descartável / Redução",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trocar telefone descartável / Redução.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Suspeita e risco / Rota / Controle / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Rota / Controle / Minutos.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Suspeita e risco / Venda / Pressão policial / Lote",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Lote.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Suspeita e risco / Venda / Pressão policial / Motorhome",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Motorhome.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Suspeita e risco / Venda / Pressão policial / Revendedor",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Revendedor.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Suspeita e risco / Venda / Pressão policial / Facção",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Facção.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Suspeita e risco / Venda / Pressão policial / Centro de distribuição",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Centro de distribuição.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Suspeita e risco / Venda / Pressão policial / Laboratório",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Laboratório.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Suspeita e risco / Venda / Pressão policial / Jogador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Jogador.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Suspeita e risco / Venda / Pressão policial / Rota",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Rota.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Suspeita e risco / Venda / Pressão policial / Zona",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Venda / Pressão policial / Zona.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Suspeita e risco / Limites / Crítica",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Limites / Crítica.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Suspeita e risco / Limites / Alta",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Limites / Alta.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Suspeita e risco / Limites / Bloqueio",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Limites / Bloqueio.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Suspeita e risco / Limites / Baixa",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Limites / Baixa.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Suspeita e risco / Limites / Média",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Limites / Média.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Suspeita e risco / Ciclo de atualização / Minutos",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Ciclo de atualização / Minutos.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Suspeita e risco / Grossista / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Grossista / Pressão policial / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Raio de Alerta",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Raio de Alerta.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Valor base / Chance",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Valor base / Chance.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Facção / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Facção / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Alta / Gravidade / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Alta / Gravidade / Limite.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Lealdade / Chance / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Lealdade / Chance / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Lealdade / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Lealdade / Limite.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Máximo / Chance",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Máximo / Chance.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Mínimo / Cooldown (segundos)",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Mínimo / Cooldown (segundos).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Rota / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Rota / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Intensidade / Máximo",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Máximo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Intensidade / Mínimo",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Mínimo.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Intensidade / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Intensidade / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Estresse / Chance / Multiplicador",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Estresse / Chance / Multiplicador.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Suspeita e risco / Trabalhador / Vazamento / Estresse / Limite",
                    description = "Parâmetro de funcionamento para Suspeita e risco / Trabalhador / Vazamento / Estresse / Limite.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Rede de contatos / Cooldown de ação / segundos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Cooldown de ação / segundos.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Rede de contatos / Número de pontos ativos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Número de pontos ativos.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Rede de contatos / Dica de burner / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Dica de burner / Confiança.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Rede de contatos / Telefone descartável / Oferta / Máximo / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Telefone descartável / Oferta / Máximo / Multiplicador.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Rede de contatos / Telefone descartável / Oferta / Mínimo / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Telefone descartável / Oferta / Mínimo / Multiplicador.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Rede de contatos / Comprador / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Minutos de tempo de espera.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Rede de contatos / Comprador / Distância de entrega",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Distância de entrega.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Rede de contatos / Comprador / Premium / Sucesso / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Premium / Sucesso / Pontuação.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Rede de contatos / Comprador / Premium / Confiança / ganho",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Premium / Confiança / ganho.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Rede de contatos / Comprador / Solicitação / Nível de procurado e Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Solicitação / Nível de procurado e Risco / Peso.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Rede de contatos / Comprador / Padrão / Confiança / ganho",
                    description = "Parâmetro de funcionamento para Rede de contatos / Comprador / Padrão / Confiança / ganho.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Rede de contatos / Espera para ativar contato / segundos / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Espera para ativar contato / segundos / Máximo.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Rede de contatos / Espera para ativar contato / segundos / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Espera para ativar contato / segundos / Mínimo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Rede de contatos / Contacto / Demanda / Faixa de valores / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Contacto / Demanda / Faixa de valores / Máximo.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Rede de contatos / Contacto / Demanda / Faixa de valores / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Contacto / Demanda / Faixa de valores / Mínimo.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Rede de contatos / Contacto / Perda / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Contacto / Perda / Confiança.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Rede de contatos / Rede obscura / Informações exatas / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Informações exatas / Minutos.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Rede de contatos / Rede obscura / Ponto ativo / Informações / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Ponto ativo / Informações / Preço.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Rede de contatos / Rede obscura / Informações / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rede obscura / Informações / Preço.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Rede de contatos / Revendedor / Preço Base",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Preço Base.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Rede de contatos / Revendedor / Contratação / capacidade / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / capacidade / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Rede de contatos / Revendedor / Contratação / capacidade / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / capacidade / Mínimo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Rede de contatos / Revendedor / Contratação / Risco / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / Risco / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Rede de contatos / Revendedor / Contratação / Risco / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / Risco / Mínimo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Rede de contatos / Revendedor / Contratação / Habilidade / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / Habilidade / Máximo.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Rede de contatos / Revendedor / Contratação / Habilidade / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Contratação / Habilidade / Mínimo.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Rede de contatos / Ofertas do revendedor / 1 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Rede de contatos / Ofertas do revendedor / 1 / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 1 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Rede de contatos / Ofertas do revendedor / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Rede de contatos / Ofertas do revendedor / 1 / Confiança mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 1 / Confiança mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Rede de contatos / Ofertas do revendedor / 1 / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 1 / Preço.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Rede de contatos / Ofertas do revendedor / 2 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Rede de contatos / Ofertas do revendedor / 2 / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 2 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Rede de contatos / Ofertas do revendedor / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Rede de contatos / Ofertas do revendedor / 2 / Confiança mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 2 / Confiança mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Rede de contatos / Ofertas do revendedor / 2 / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 2 / Preço.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Rede de contatos / Ofertas do revendedor / 3 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Rede de contatos / Ofertas do revendedor / 3 / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 3 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Rede de contatos / Ofertas do revendedor / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Rede de contatos / Ofertas do revendedor / 3 / Confiança mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 3 / Confiança mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Rede de contatos / Ofertas do revendedor / 3 / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 3 / Preço.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Rede de contatos / Ofertas do revendedor / 4 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Rede de contatos / Ofertas do revendedor / 4 / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 4 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Rede de contatos / Ofertas do revendedor / 4 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 4 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Rede de contatos / Ofertas do revendedor / 4 / Confiança mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 4 / Confiança mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Rede de contatos / Ofertas do revendedor / 4 / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 4 / Preço.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Rede de contatos / Ofertas do revendedor / 5 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Rede de contatos / Ofertas do revendedor / 5 / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 5 / Item.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Rede de contatos / Ofertas do revendedor / 5 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 5 / Etiqueta.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Rede de contatos / Ofertas do revendedor / 5 / Confiança mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 5 / Confiança mínima.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Rede de contatos / Ofertas do revendedor / 5 / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ofertas do revendedor / 5 / Preço.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Rede de contatos / Revendedor / Proteção / Horas",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Proteção / Horas.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Rede de contatos / Revendedor / Proteção / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Proteção / Preço.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Rede de contatos / Revendedor / Venda / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Venda / Máximo.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Rede de contatos / Revendedor / Venda / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Venda / Mínimo.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Rede de contatos / Revendedor / Simulação / Modo agressivo / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Modo agressivo / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Rede de contatos / Revendedor / Simulação / Qualidade base / Fator de preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Qualidade base / Fator de preço.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Rede de contatos / Revendedor / Simulação / Atacado / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Atacado / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Rede de contatos / Revendedor / Simulação / Vendas baratas / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Vendas baratas / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Rede de contatos / Revendedor / Simulação / Valor padrão / Qualidade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Valor padrão / Qualidade.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Rede de contatos / Revendedor / Simulação / Limite de deslealdade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Limite de deslealdade.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Rede de contatos / Revendedor / Simulação / Experiência / Por nível",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Experiência / Por nível.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Rede de contatos / Revendedor / Simulação / Experiência / Por unidade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Experiência / Por unidade.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Rede de contatos / Revendedor / Simulação / Incidente / Lealdade / Perda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Incidente / Lealdade / Perda.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Rede de contatos / Revendedor / Simulação / Incidente / Verificação aleatória / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Incidente / Verificação aleatória / Máximo.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Rede de contatos / Revendedor / Simulação / Nível / Preço / Bónus",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Nível / Preço / Bónus.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Rede de contatos / Revendedor / Simulação / Nível / Venda / Divisor",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Nível / Venda / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Rede de contatos / Revendedor / Simulação / Lealdade / Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Lealdade / Risco / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Rede de contatos / Revendedor / Simulação / Máximo / Incidente / Chance",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Máximo / Incidente / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Rede de contatos / Revendedor / Simulação / Máximo / Nível",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Máximo / Nível.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Rede de contatos / Revendedor / Simulação / Premium / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Premium / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Rede de contatos / Revendedor / Simulação / Perfil / Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Perfil / Risco / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Rede de contatos / Revendedor / Simulação / Proteção / Risco / Redução",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Proteção / Risco / Redução.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Rede de contatos / Revendedor / Simulação / Qualidade / Preço / Divisor",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Qualidade / Preço / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Rede de contatos / Revendedor / Simulação / Recuperação / Valor base / Chance",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Recuperação / Valor base / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Rede de contatos / Revendedor / Simulação / Recuperação / Lealdade / Peso",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Recuperação / Lealdade / Peso.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Rede de contatos / Revendedor / Simulação / Perda de estoque por roubo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Perda de estoque por roubo.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Rede de contatos / Revendedor / Simulação / Habilidade / Risco / Redução",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Habilidade / Risco / Redução.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Rede de contatos / Revendedor / Simulação / Habilidade / Venda / Divisor",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Habilidade / Venda / Divisor.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Rede de contatos / Revendedor / Simulação / Limite de lealdade estável",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Limite de lealdade estável.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Rede de contatos / Revendedor / Simulação / Território / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Território / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Rede de contatos / Revendedor / Simulação / Território / Risco / Redução",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Simulação / Território / Risco / Redução.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Rede de contatos / Revendedor / Ciclo de atualização / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Ciclo de atualização / Minutos.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Rede de contatos / Revendedor / Salário",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Rede de contatos / Revendedor / Salário / Decadência",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário / Decadência.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Rede de contatos / Revendedor / Salário / Lealdade / ganho",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Salário / Lealdade / ganho.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Rede de contatos / Revendedor / Fraquezas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Fraquezas / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Rede de contatos / Revendedor / Fraquezas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Fraquezas / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Rede de contatos / Revendedor / Fraquezas / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Fraquezas / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Rede de contatos / Revendedor / Fraquezas / 4",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Fraquezas / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Rede de contatos / Revendedor / Fraquezas / 5",
                    description = "Parâmetro de funcionamento para Rede de contatos / Revendedor / Fraquezas / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Rede de contatos / Valor padrão / Contacto / Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Contacto / Demanda.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Rede de contatos / Valor padrão / Contacto / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Contacto / Risco.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Rede de contatos / Traficante padrão / capacidade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / capacidade.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Rede de contatos / Traficante padrão / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / Risco.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Rede de contatos / Traficante padrão / Habilidade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Traficante padrão / Habilidade.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Rede de contatos / Valor padrão / Ponto ativo / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Valor padrão / Ponto ativo / Raio.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Rede de contatos / Reset de demanda (minutos)",
                    description = "Parâmetro de funcionamento para Rede de contatos / Reset de demanda (minutos).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Rede de contatos / Ativado",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ativado.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Rede de contatos / Localização exata / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Localização exata / Confiança.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Rede de contatos / Facção / Descoberta / Reputação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Facção / Descoberta / Reputação.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Rede de contatos / Facção / Pista / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Facção / Pista / Confiança.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Rede de contatos / Entrega malsucedida / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Rede de contatos / Entrega malsucedida / Minutos de tempo de espera.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Rede de contatos / Negócio falso / Encontro / Atacante / Quantidade",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Atacante / Quantidade.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Atacante / Modelos / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Rede de contatos / Negócio falso / Encontro / Duração (segundos)",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Duração (segundos).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Polícia / Modelos / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Rede de contatos / Negócio falso / Encontro / Raio de Spawn",
                    description = "Parâmetro de funcionamento para Rede de contatos / Negócio falso / Encontro / Raio de Spawn.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Rede de contatos / Valor alternativo / Droga Preferencial",
                    description = "Parâmetro de funcionamento para Rede de contatos / Valor alternativo / Droga Preferencial.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Rede de contatos / Valor alternativo / Rótulo do produto",
                    description = "Parâmetro de funcionamento para Rede de contatos / Valor alternativo / Rótulo do produto.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Rede de contatos / Guia / Livro / Item",
                    description = "Parâmetro de funcionamento para Rede de contatos / Guia / Livro / Item.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Rede de contatos / Guia / Livro / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Guia / Livro / Confiança.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Rede de contatos / Contratar revendedor / Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Contratar revendedor / Preço.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Rede de contatos / Limite do histórico",
                    description = "Parâmetro de funcionamento para Rede de contatos / Limite do histórico.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Rede de contatos / Ponto ativo / Informações / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ponto ativo / Informações / Minutos.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Rede de contatos / Ponto ativo / Rotação / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Ponto ativo / Rotação / Minutos.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Rede de contatos / Anúncio / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Anúncio / Duração / Minutos.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Rede de contatos / Máximo / Possuídas / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de contatos / Máximo / Possuídas / Traficantes.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Rede de contatos / Mínimo / Comprador / Distância de entrega",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Comprador / Distância de entrega.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Rede de contatos / Mínimo / Rotação de contato (minutos)",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Rotação de contato (minutos).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Rede de contatos / Mínimo / Reset de demanda (minutos)",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Reset de demanda (minutos).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Rede de contatos / Mínimo / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Rede de contatos / Mínimo / Ponto ativo / Informações / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Informações / Minutos.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Rede de contatos / Mínimo / Ponto ativo / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Raio.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Rede de contatos / Mínimo / Ponto ativo / Rotação / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Ponto ativo / Rotação / Minutos.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Rede de contatos / Mínimo / Anúncio / Duração / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Anúncio / Duração / Minutos.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Rede de contatos / Recompensa mínima / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Recompensa mínima / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Rede de contatos / Mínimo / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Rede de contatos / Mínimo / Local / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Mínimo / Local / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Rede de contatos / Outro / Droga / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Outro / Droga / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Rede de contatos / Conta de pagamento",
                    description = "Parâmetro de funcionamento para Rede de contatos / Conta de pagamento.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Rede de contatos / Após a entrega / Demanda / Reset / segundos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Após a entrega / Demanda / Reset / segundos.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Rede de contatos / Droga Preferencial / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Droga Preferencial / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Rede de contatos / Região / Localização / Confiança",
                    description = "Parâmetro de funcionamento para Rede de contatos / Região / Localização / Confiança.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Rede de contatos / Solicitação / Quantidades / Atacado / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Atacado / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Rede de contatos / Solicitação / Quantidades / Atacado / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Atacado / Mínimo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Rede de contatos / Solicitação / Quantidades / Premium / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Premium / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Rede de contatos / Solicitação / Quantidades / Premium / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Premium / Mínimo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Rede de contatos / Solicitação / Quantidades / Padrão / Máximo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Padrão / Máximo.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Rede de contatos / Solicitação / Quantidades / Padrão / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Solicitação / Quantidades / Padrão / Mínimo.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Rede de contatos / Rotação / Minutos",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rotação / Minutos.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante de rua / 3 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Comprador padrão / 3 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante padrão / 3 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Traficante da rede / 3 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Intermediário premium / 3 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 1 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 2 / Risco.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / W",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Coordenadas / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Região.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de contatos / Local / Conjuntos de seleção / Contato atacadista / 3 / Risco.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Bônus de aceitação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Bônus de aceitação.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Arquétipo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Arquétipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Bônus de Demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 4",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Drogas preferidas / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Raio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Região.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 1 / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 1 / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Bônus de aceitação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Bônus de aceitação.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Arquétipo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Arquétipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Bônus de Demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Qualidade mínima",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Qualidade mínima.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Drogas preferidas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Drogas preferidas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Raio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Região.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 2 / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 2 / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Bônus de aceitação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Bônus de aceitação.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Arquétipo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Arquétipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Bônus de Demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Raio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Região.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 3 / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 3 / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Bônus de aceitação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Bônus de aceitação.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Arquétipo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Arquétipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Bônus de Demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 3",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Drogas preferidas / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Raio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Região.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 4 / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 4 / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Bônus de aceitação",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Bônus de aceitação.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Arquétipo",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Arquétipo.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Coordenadas / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Bônus de Demanda",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Bônus de Demanda.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Pressão policial / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Pressão policial / Multiplicador.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / ID",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Etiqueta.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Drogas preferidas / 1",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Drogas preferidas / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Drogas preferidas / 2",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Drogas preferidas / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Multiplicador de Preço",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Multiplicador de Preço.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Raio",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Raio.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Região",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Região.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Rede de contatos / Rua / Pontos ativos / 5 / Assalto / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de contatos / Rua / Pontos ativos / 5 / Assalto / Multiplicador.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Rede de contatos / Confiança / Níveis / Conhecido",
                    description = "Parâmetro de funcionamento para Rede de contatos / Confiança / Níveis / Conhecido.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Rede de contatos / Confiança / Níveis / Confiável",
                    description = "Parâmetro de funcionamento para Rede de contatos / Confiança / Níveis / Confiável.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Rede de contatos / Confiança / Níveis / Confiável",
                    description = "Parâmetro de funcionamento para Rede de contatos / Confiança / Níveis / Confiável.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Rede de negócios / Cooldown de ação / segundos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Cooldown de ação / segundos.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Rede de negócios / Saldo / Valor base / Preço por unidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Valor base / Preço por unidade.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Rede de negócios / Saldo / Calor da rede / Por traficante",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Calor da rede / Por traficante.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Rede de negócios / Saldo / Calor da rede / Por centro de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Calor da rede / Por centro de distribuição.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Rede de negócios / Saldo / Calor da rede / Por rota",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Calor da rede / Por rota.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Rede de negócios / Saldo / Calor da rede / Por funcionário",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Calor da rede / Por funcionário.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Rede de negócios / Saldo / Confiabilidade / ganho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Confiabilidade / ganho.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Rede de negócios / Saldo / Confiabilidade / Perda",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Confiabilidade / Perda.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Rede de negócios / Saldo / Rota / Pressão policial / Decadência",
                    description = "Parâmetro de funcionamento para Rede de negócios / Saldo / Rota / Pressão policial / Decadência.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / gangue / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / gangue / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Rede de NPCs / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Rede de NPCs / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Organização / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Organização / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Premium / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Premium / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Revendedor / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Revendedor / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Especial / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Especial / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Quantidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Quantidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Quantidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Quantidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Mínimo / Cargo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Mínimo / Cargo.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Qualidade / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Qualidade / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Qualidade / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Qualidade / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Recompensa / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Recompensa / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Recompensa / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Recompensa / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Risco / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Risco / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Rede de negócios / Contratos / Categorias / Grossista / Risco / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Categorias / Grossista / Risco / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Rede de negócios / Contratos / Distância de entrega",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Distância de entrega.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Rede de negócios / Contratos / Duração / Minutos / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Duração / Minutos / Máximo.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Rede de negócios / Contratos / Duração / Minutos / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Duração / Minutos / Mínimo.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Região",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Região.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Recompensa / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 1 / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 1 / Risco.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Região",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Região.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Recompensa / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 2 / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 2 / Risco.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Região",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Região.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Recompensa / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 3 / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 3 / Risco.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / X",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / Y",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / Z",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Coordenadas / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Região",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Região.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Recompensa / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Recompensa / Multiplicador.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Rede de negócios / Contratos / Encontro / Pontos / 4 / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Encontro / Pontos / 4 / Risco.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 3",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Adiantamento / Opções / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Rede de negócios / Contratos / Negociação / Quantidade / Margem de negociação / Porcentagem",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Quantidade / Margem de negociação / Porcentagem.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Rede de negócios / Contratos / Negociação / Valor base / Aceitação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Valor base / Aceitação.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Rede de negócios / Contratos / Negociação / Prazo / Margem de negociação / Porcentagem",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Prazo / Margem de negociação / Porcentagem.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Rede de negócios / Contratos / Negociação / Máximo / Rodadas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Máximo / Rodadas.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Rede de negócios / Contratos / Negociação / Qualidade / Margem de negociação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Qualidade / Margem de negociação.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Rede de negócios / Contratos / Negociação / Rejeição / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Rejeição / Minutos de tempo de espera.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Rede de negócios / Contratos / Negociação / Rodada / Pressão",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Negociação / Rodada / Pressão.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Rede de negócios / Contratos / Oferta / Quantidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Oferta / Quantidade.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Rede de negócios / Contratos / Atualização / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Contratos / Atualização / Minutos.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Rede de negócios / Valor padrão / Nome comercial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Nome comercial.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Rede de negócios / Valor padrão / Cargo / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Cargo / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Rede de negócios / Valor padrão / Pessoal / Estilo de trabalho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Pessoal / Estilo de trabalho.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Rede de negócios / Valor padrão / Transportes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Valor padrão / Transportes.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Rede de negócios / Ativado",
                    description = "Parâmetro de funcionamento para Rede de negócios / Ativado.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Rede de negócios / Centros de distribuição / Centro de distribuição / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Centro de distribuição / capacidade.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Rede de negócios / Centros de distribuição / Centro de distribuição / Preço de compra",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Centro de distribuição / Preço de compra.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Rede de negócios / Centros de distribuição / Centro de distribuição / Segurança",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Centro de distribuição / Segurança.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Rede de negócios / Centros de distribuição / Centro de distribuição / Manutenção",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Centro de distribuição / Manutenção.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Rede de negócios / Centros de distribuição / Esconderijo / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Esconderijo / capacidade.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Rede de negócios / Centros de distribuição / Esconderijo / Preço de compra",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Esconderijo / Preço de compra.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Rede de negócios / Centros de distribuição / Esconderijo / Segurança",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Esconderijo / Segurança.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Rede de negócios / Centros de distribuição / Esconderijo / Manutenção",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Esconderijo / Manutenção.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Rede de negócios / Centros de distribuição / Armazém / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Armazém / capacidade.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Rede de negócios / Centros de distribuição / Armazém / Preço de compra",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Armazém / Preço de compra.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Rede de negócios / Centros de distribuição / Armazém / Segurança",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Armazém / Segurança.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Rede de negócios / Centros de distribuição / Armazém / Manutenção",
                    description = "Parâmetro de funcionamento para Rede de negócios / Centros de distribuição / Armazém / Manutenção.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Rede de negócios / Limites / Contratos ativos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Limites / Contratos ativos.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Rede de negócios / Limites / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Limites / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Rede de negócios / Limites / Livro contábil / Linhas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Limites / Livro contábil / Linhas.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Rede de negócios / Limites / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Limites / Rotas.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Rede de negócios / Limites / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Limites / Pessoal.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Rede de negócios / Pagamento / Conta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pagamento / Conta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Rede de negócios / Patentes / 1 / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Rede de negócios / Patentes / 1 / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Traficantes.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Rede de negócios / Patentes / 1 / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Rede de negócios / Patentes / 1 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Rede de negócios / Patentes / 1 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Rede de negócios / Patentes / 1 / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Rotas.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Rede de negócios / Patentes / 1 / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Pontuação.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Rede de negócios / Patentes / 1 / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 1 / Pessoal.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Rede de negócios / Patentes / 2 / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Rede de negócios / Patentes / 2 / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Traficantes.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Rede de negócios / Patentes / 2 / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Rede de negócios / Patentes / 2 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Rede de negócios / Patentes / 2 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Rede de negócios / Patentes / 2 / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Rotas.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Rede de negócios / Patentes / 2 / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Pontuação.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Rede de negócios / Patentes / 2 / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 2 / Pessoal.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Rede de negócios / Patentes / 3 / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Rede de negócios / Patentes / 3 / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Traficantes.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Rede de negócios / Patentes / 3 / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Rede de negócios / Patentes / 3 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Rede de negócios / Patentes / 3 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Rede de negócios / Patentes / 3 / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Rotas.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Rede de negócios / Patentes / 3 / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Pontuação.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Rede de negócios / Patentes / 3 / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 3 / Pessoal.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Rede de negócios / Patentes / 4 / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Rede de negócios / Patentes / 4 / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Traficantes.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Rede de negócios / Patentes / 4 / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Rede de negócios / Patentes / 4 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Rede de negócios / Patentes / 4 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Rede de negócios / Patentes / 4 / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Rotas.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Rede de negócios / Patentes / 4 / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Pontuação.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Rede de negócios / Patentes / 4 / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 4 / Pessoal.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Rede de negócios / Patentes / 5 / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Contratos.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Rede de negócios / Patentes / 5 / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Traficantes.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Rede de negócios / Patentes / 5 / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Rede de negócios / Patentes / 5 / ID",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Rede de negócios / Patentes / 5 / Etiqueta",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Etiqueta.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Rede de negócios / Patentes / 5 / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Rotas.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Rede de negócios / Patentes / 5 / Pontuação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Pontuação.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Rede de negócios / Patentes / 5 / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Patentes / 5 / Pessoal.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Rede de negócios / Período do relatório / dias",
                    description = "Parâmetro de funcionamento para Rede de negócios / Período do relatório / dias.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Comprador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Comprador.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Contrato",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Contrato.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Revendedor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Revendedor.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / gangue",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / gangue.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Centro de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Centro de distribuição.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Laboratório",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Laboratório.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Organização",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Organização.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Rede de negócios / Rota / Ponto final / Tipos / Revendedor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Rota / Ponto final / Tipos / Revendedor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Frequência / Minutos / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Frequência / Minutos / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Frequência / Minutos / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Frequência / Minutos / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Tempo de recarga / Mínimo / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Tempo de recarga / Mínimo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Falha / Confiabilidade / Perda",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Falha / Confiabilidade / Perda.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Mínimo / Frequência / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Mínimo / Frequência / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Mínimo / Encontro / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Mínimo / Encontro / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Rede de negócios / Funcionamento no jogo / Multa de contrato / Crescimento",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Multa de contrato / Crescimento.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Multa de contrato / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Multa de contrato / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Falha / Minutos de tempo de espera",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Falha / Minutos de tempo de espera.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Preço / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Preço / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Preço / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Qualidade / Preço / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Qualidade / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Confiabilidade / Perda / Qualidade / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Reputação / Qualidade / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Reputação / Qualidade / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Risco / Ponderações / Categoria",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Risco / Ponderações / Categoria.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Rede de negócios / Funcionamento no jogo / Contrato / Risco / Ponderações / Encontro",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Contrato / Risco / Ponderações / Encontro.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Centro de distribuição / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Centro de distribuição / capacidade.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Centro de distribuição / Segurança",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Centro de distribuição / Segurança.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Encontro / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Encontro / Risco.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Qualidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Qualidade.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Capacidade da rota",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Capacidade da rota.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Rota / Intervalo / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Rota / Intervalo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor padrão / Rota / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor padrão / Rota / Risco.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Pressão policial / Decadência",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Pressão policial / Decadência.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Carga / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Carga / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Ataque / Recuperação / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Ataque / Recuperação / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Custo / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Custo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Custo / Por nível",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Custo / Por nível.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Melhoria",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Segurança / Melhoria.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Falta de pagamento / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Falta de pagamento / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Falta de pagamento / Segurança / Perda",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Falta de pagamento / Segurança / Perda.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Rede de negócios / Funcionamento no jogo / Centro de distribuição / Manutenção / Intervalo / Horas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Centro de distribuição / Manutenção / Intervalo / Horas.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Rede de negócios / Funcionamento no jogo / Valor inicial / Confiabilidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Valor inicial / Confiabilidade.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Rede de negócios / Funcionamento no jogo / Máximo / Nome comercial / Comprimento",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Máximo / Nome comercial / Comprimento.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Mínimo / Contrato / Entrega / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Mínimo / Contrato / Entrega / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Rede de negócios / Funcionamento no jogo / Mínimo / Distância de entrega",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Mínimo / Distância de entrega.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Rede de negócios / Funcionamento no jogo / Mínimo / Livro contábil / Linhas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Mínimo / Livro contábil / Linhas.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Mínimo / Rota / Intervalo / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Mínimo / Rota / Intervalo / Minutos.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Adiantamento / Custo / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Adiantamento / Custo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Adiantamento / Preço / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Adiantamento / Preço / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Custo / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Custo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Margem de negociação / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Margem de negociação / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Quantidade / Risco / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Contraproposta / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Contraproposta / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Prazo / Margem de negociação / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Prazo / Margem de negociação / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Máximo / Aceitação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Máximo / Aceitação.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Mínimo / Aceitação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Mínimo / Aceitação.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Benefício / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Benefício / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Custo / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Custo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Margem de negociação / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Margem de negociação / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Recompensa / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Qualidade / Recompensa / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Confiabilidade / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Confiabilidade / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Reputação / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Reputação / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Recompensa solicitada / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Recompensa solicitada / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Recompensa solicitada / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Recompensa solicitada / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Custo / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Custo / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Recompensa / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Benefício / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Benefício / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Risco / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Negociação / Urgência / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Outro / Falha / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Outro / Falha / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Calor pessoal / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Calor pessoal / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Polícia / Falha / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Polícia / Falha / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Valor base / unidades",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Valor base / unidades.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Atacado / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Atacado / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Vendas baratas / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Vendas baratas / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Experiência / Por nível",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Experiência / Por nível.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Experiência / Por unidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Experiência / Por unidade.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Centro de distribuição / Pressão policial / Por unidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Centro de distribuição / Pressão policial / Por unidade.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Premium / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Premium / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Habilidade / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Habilidade / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Rede de negócios / Funcionamento no jogo / Revendedor / Habilidade / ganho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Revendedor / Habilidade / ganho.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Duração / Valor base / segundos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Duração / Valor base / segundos.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Duração / Por unidade / segundos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Duração / Por unidade / segundos.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 3",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 4",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Falha / Causas / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Falha / Valor / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Falha / Valor / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Pressão policial / Quantidade / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Pressão policial / Quantidade / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Redução de Procurado / Custo / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Redução de Procurado / Custo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Redução de Procurado / Custo / Por ponto de suspeita",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Redução de Procurado / Custo / Por ponto de suspeita.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Lealdade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Lealdade.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Corredor / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Corredor / Risco.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Habilidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Risco / Ponderações / Habilidade.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Rede de negócios / Funcionamento no jogo / Rotação de rota / Redução de Procurado",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rotação de rota / Redução de Procurado.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Rede de negócios / Funcionamento no jogo / Rotação de rota / Risco / Redução",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rotação de rota / Risco / Redução.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Venda / Base de Qualidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Venda / Base de Qualidade.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Venda / Qualidade / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Venda / Qualidade / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Venda / Risco / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Venda / Risco / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Rota / Início / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Rota / Início / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Rede de negócios / Funcionamento no jogo / Corredor / Experiência / Por nível",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Corredor / Experiência / Por nível.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Rede de negócios / Funcionamento no jogo / Corredor / Experiência / Por unidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Corredor / Experiência / Por unidade.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Rede de negócios / Funcionamento no jogo / Corredor / Falha / Lealdade / Perda",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Corredor / Falha / Lealdade / Perda.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Rede de negócios / Funcionamento no jogo / Corredor / Risco de Falha / ganho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Corredor / Risco de Falha / ganho.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Rede de negócios / Funcionamento no jogo / Corredor / Habilidade / ganho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Corredor / Habilidade / ganho.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Pressão policial",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Pressão policial.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Confiabilidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Confiabilidade.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Reputação",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Reputação.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Estrutura",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pontuação / Ponderações / Estrutura.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / capacidade / Valor base / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / capacidade / Valor base / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Lealdade / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Lealdade / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Lealdade / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Lealdade / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Risco / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Risco / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Risco / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Risco / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Habilidade / Máximo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Habilidade / Máximo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Habilidade / Mínimo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Contratação / Habilidade / Mínimo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Lealdade / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Lealdade / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Máximo / Chance",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Máximo / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 3",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 4",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Resultados / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Risco / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Incidente / Risco / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Lealdade / Decadência",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Lealdade / Decadência.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Máximo / Nível",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Máximo / Nível.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Perda de lealdade por aliciamento",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Perda de lealdade por aliciamento.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Custo / Valor base",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Custo / Valor base.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Horas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Horas.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Incidente / Redução",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Incidente / Redução.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Risco / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Proteção / Risco / Custo.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Recuperação / Valor base / Chance",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Recuperação / Valor base / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Recuperação / Lealdade / Peso",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Recuperação / Lealdade / Peso.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Valor base / Multiplicador",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Valor base / Multiplicador.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Lealdade / ganho",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Lealdade / ganho.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Habilidade / Divisor",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Salário / Habilidade / Divisor.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 1",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 2",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 3",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 4",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 5",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 6",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Pessoal / Fraquezas / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Contratos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Contratos.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Traficantes",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Traficantes.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Centros de distribuição",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Centros de distribuição.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Rotas",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Rotas.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Pessoal",
                    description = "Parâmetro de funcionamento para Rede de negócios / Funcionamento no jogo / Estrutura / Ponderações / Pessoal.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Rede de negócios / Organização / Permissão",
                    description = "Parâmetro de funcionamento para Rede de negócios / Organização / Permissão.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Rede de negócios / Pessoal / Revendedor / Valor base / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Revendedor / Valor base / capacidade.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Rede de negócios / Pessoal / Revendedor / Valor base / Salário",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Revendedor / Valor base / Salário.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Rede de negócios / Pessoal / Revendedor / Comissão",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Revendedor / Comissão.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Rede de negócios / Pessoal / Revendedor / Contratação / Preço",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Revendedor / Contratação / Preço.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Rede de negócios / Pessoal / Corredor / Valor base / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Corredor / Valor base / capacidade.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Rede de negócios / Pessoal / Corredor / Valor base / Salário",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Corredor / Valor base / Salário.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Rede de negócios / Pessoal / Corredor / Comissão",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Corredor / Comissão.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Rede de negócios / Pessoal / Corredor / Contratação / Preço",
                    description = "Parâmetro de funcionamento para Rede de negócios / Pessoal / Corredor / Contratação / Preço.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Rede de negócios / Ciclo de atualização / Minutos",
                    description = "Parâmetro de funcionamento para Rede de negócios / Ciclo de atualização / Minutos.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Rede de negócios / Transportes / Aeronave / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Aeronave / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Rede de negócios / Transportes / Aeronave / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Aeronave / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Rede de negócios / Transportes / Aeronave / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Aeronave / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Rede de negócios / Transportes / Aeronave / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Aeronave / Risco.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Rede de negócios / Transportes / Barco / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Barco / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Rede de negócios / Transportes / Barco / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Barco / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Rede de negócios / Transportes / Barco / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Barco / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Rede de negócios / Transportes / Barco / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Barco / Risco.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Rede de negócios / Transportes / Carro / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Carro / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Rede de negócios / Transportes / Carro / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Carro / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Rede de negócios / Transportes / Carro / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Carro / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Rede de negócios / Transportes / Carro / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Carro / Risco.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Rede de negócios / Transportes / A pé / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / A pé / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Rede de negócios / Transportes / A pé / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / A pé / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Rede de negócios / Transportes / A pé / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / A pé / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Rede de negócios / Transportes / A pé / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / A pé / Risco.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Rede de negócios / Transportes / Caminhão / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Caminhão / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Rede de negócios / Transportes / Caminhão / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Caminhão / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Rede de negócios / Transportes / Caminhão / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Caminhão / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Rede de negócios / Transportes / Caminhão / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Caminhão / Risco.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Rede de negócios / Transportes / Van / capacidade",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Van / capacidade.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Rede de negócios / Transportes / Van / Custo",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Van / Custo.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Rede de negócios / Transportes / Van / Multiplicador de duração",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Van / Multiplicador de duração.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Rede de negócios / Transportes / Van / Risco",
                    description = "Parâmetro de funcionamento para Rede de negócios / Transportes / Van / Risco.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Integração genérica",
                        custom = "Integração personalizada",
                        none = "Desativado",
                    },
                },
                reputationRules = {
                    label = "Regras de reputação",
                    description = "Configura regras com nome para ações e alvos opcionais. Só as regras ativadas atribuem pontos.",
                },
            },
            territoryMap = {
                addPoint = "Adicionar ponto",
                clear = "Limpar",
                create = "Criar",
                custom = "Territórios personalizados",
                deletePoint = "Apagar o ponto",
                eyebrow = "Editor de território",
                minimum = "Mínimo 3",
                pointCount = "{count} pontos",
                presets = "Distritos predefinidos",
                shown = "Mostrar no mapa",
                street = "Rua",
                supply = "Fornecimento",
                territories = "Territórios",
                type = "Tipo de território",
                undo = "Desfazer",
            },
            shopPositionTools = {
                currentPosition = "Usar posição atual",
                selectEntity = "Selecionar entidade",
                selectEntityHint = "Aponte o laser para um caixa registradora ou cofre. Enter: usar a posição e o ângulo do objeto contornado. Backspace: cancelar.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Níveis de cultivo",
                general = "Geral",
                runtime = "Acesso às ações do jogo",
                quality = "Qualidade",
                packaging = "Embalagem",
                growing = "Cultivo",
                labs = "Laboratórios e trailers",
                power = "Energia e equipamentos",
                workers = "Funcionários",
                market = "Mercado e distribuição",
                threats = "Batidas e sabotagem",
                pvpTakeovers = "Invasões de laboratório",
                consumption = "Consumo",
                processing = "Processamento",
                performance = "Desempenho",
                dynamicMarket = "Mercado Dinâmico",
                heat = "Suspeita e risco",
                contacts = "Rede de contatos",
                business = "Rede de negócios",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Geral" },
                cultivationCurve = { label = "Curva de níveis" },
                cultivationExperience = { label = "Recompensas de XP" },
                cultivationUnlocks = { label = "Desbloqueios por nível" },
                creator = {
                    label = "Abrir editor",
                },
                creatorSettings = {
                    label = "Configurações do editor",
                },
                interfaceHud = {
                    label = "Posições da interface",
                },
                drugsGeneral = {
                    label = "Geral",
                },
                runtimeAccess = {
                    label = "Acesso e propriedade",
                },
                runtimePayouts = {
                    label = "Pagamentos",
                },
                runtimeDispatch = {
                    label = "Central e polícia",
                },
                qualityWeights = {
                    label = "Qualidade / Ponderações",
                },
                qualityTiers = {
                    label = "Qualidade / Níveis de qualidade",
                },
                packagingGeneral = {
                    label = "Geral",
                },
                growingGeneral = {
                    label = "Geral",
                },
                plantDefaults = {
                    label = "Planta / Valores padrão",
                },
                harvestWindow = {
                    label = "Colher / Janela temporal",
                },
                labsGeneral = {
                    label = "Geral",
                },
                labRent = {
                    label = "Aluguel e ciclo de vida",
                },
                camperDefaults = {
                    label = "Motorhome",
                },
                labUpgrades = {
                    label = "Melhorias",
                },
                labDefaults = {
                    label = "Laboratório / Valores padrão",
                },
                powerGeneral = {
                    label = "Geral",
                },
                generators = {
                    label = "Geradores",
                },
                equipmentWear = {
                    label = "Equipamento",
                },
                workersGeneral = {
                    label = "Geral",
                },
                marketGeneral = {
                    label = "Geral",
                },
                marketPrices = {
                    label = "Preços",
                },
                distribution = {
                    label = "Distribuição",
                },
                threatsGeneral = {
                    label = "Geral",
                },
                threatHeat = {
                    label = "Pressão policial",
                },
                threatChances = {
                    label = "Probabilidades",
                },
                pvpTakeoverRules = {
                    label = "Regras de tomada de controle",
                },
                pvpTakeoverZones = {
                    label = "Zonas & Horários",
                },
                pvpTakeoverMethods = {
                    label = "Métodos de invasão",
                },
                consumptionGeneral = {
                    label = "Geral",
                },
                consumerDecay = {
                    label = "Redução de tolerância e dependência",
                },
                consumerEffects = {
                    label = "Efeitos e riscos",
                },
                processingFlow = {
                    label = "Fluxo de processamento",
                },
                processingGeneral = {
                    label = "Geral",
                },
                powerRuntime = {
                    label = "Funcionamento no jogo",
                },
                powerHeat = {
                    label = "Suspeita e assinatura elétrica",
                },
                powerModes = {
                    label = "Gestão / Modos",
                },
                powerPriorities = {
                    label = "Carga / Prioridades",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inativo / Controle / Intervalo / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interação / Inactivo / Intervalo de análise / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interação / Aviso de interação / Intervalo / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interação / Intervalo de análise / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Mínimo / Intervalo de análise / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Rua / Ped / Ativação / Distância",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Rua / Ped / Inactivo / Intervalo de análise / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Rua / Ped / Intervalo de análise / ms",
                },
                performanceWorldCachePadding = {
                    label = "Mundo / Cache / Margem adicional",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Mundo / Cache / Atualização / Intervalo / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Mundo / Inactivo / Intervalo / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Cooldown de ação / segundos",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Ação / Limite do histórico",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Quantidade / Saturação / Peso",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Valor base / Precisão da inteligência",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Valor padrão / Média / Qualidade",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Valor padrão / Recurso / Elasticidade",
                },
                dynamicMarketDemandCenter = {
                    label = "Demanda / Valor central",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Demanda / Preço / Impacto",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Direção / Limite",
                },
                dynamicMarketEnabled = {
                    label = "Ativado",
                },
                dynamicMarketEventChance = {
                    label = "Evento / Chance",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Evento / Duração / Minutos",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Evento / Mínimo / Duração / Minutos",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Evento / Intensidade / Máximo",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Evento / Intensidade / Mínimo",
                },
                dynamicMarketEvents = {
                    label = "Eventos",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Informações exatas / Reputação",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Informações exatas / Confiança",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zona / Etiqueta",
                },
                dynamicMarketHistoryLimit = {
                    label = "Limite do histórico",
                },
                dynamicMarketInitialDemand = {
                    label = "Valor inicial / Demanda",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Valor inicial / Multiplicador de Preço",
                },
                dynamicMarketIntelDemandError = {
                    label = "Informações / Demanda / Erro",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Informações / Máximo / Precisão",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Informações / Mínimo / Precisão",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Informações / Polícia / Erro",
                },
                dynamicMarketIntelPriceError = {
                    label = "Informações / Preço / Erro",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Informações / Preço / Máximo",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Informações / Preço / Mínimo",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Informações / Reputação / Peso",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Informações / Recurso / Preço / Erro",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Informações / Saturação / Erro",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Janela de semente das informações / segundos",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Informações / Estado / Precisão / Limite",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Informações / Estado / Erro / Limite",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Informações / Fornecimento / Erro",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Informações / Confiança / Peso",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulação / Minutos de tempo de espera",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulação / Demanda / Variação",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulação / Duração / Minutos",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulação / Pressão policial",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulação / Mínimo / Lote / Quantidade",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulação / Conta de pagamento",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulação / Preço",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulação / Zona / Pressão policial / Multiplicador",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Máximo / Idade da inteligência / Minutos",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Máximo / Multiplicador de Preço",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Mínimo / Idade da inteligência / Minutos",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Mínimo / Métrica / Janela temporal / Minutos",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Preço mínimo / Multiplicador",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Mínimo / Atualização / Minutos",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Polícia / Demanda / Peso",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Polícia / Preço / Impacto",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Baixa qualidade / Demanda / Penalidade",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Baixa qualidade / Limite",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Qualidade premium / Bônus de Demanda",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Qualidade premium / Limite",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Produção / Fornecimento / Peso",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Produção / Janela temporal / Minutos",
                },
                dynamicMarketQualityCenter = {
                    label = "Qualidade / Valor central",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Qualidade / Confiança / Impacto",
                },
                dynamicMarketQualityRange = {
                    label = "Qualidade / Faixa de valores",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Raridade / Bónus / Máximo",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Regional / Global / Peso",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Regional / Local / Peso",
                },
                dynamicMarketResourceAliases = {
                    label = "Recurso / Nomes alternativos",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Recurso / Direção / Queda / Limite",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Recurso / Direção / Aumento / Limite",
                },
                dynamicMarketResources = {
                    label = "Recursos",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Vendas / Janela temporal / Minutos",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Saturação / Demanda / Peso",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Saturação / Preço / Impacto",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Escassez / Demanda / Peso",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Escassez / Preço / Impacto",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Estação / Fim / Meses",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Estação / Multiplicadores",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Escassez / Rumor / Limite",
                },
                dynamicMarketStatusThresholds = {
                    label = "Estado / Limites",
                },
                dynamicMarketTargetSupply = {
                    label = "Alvo / Fornecimento",
                },
                dynamicMarketTrendChance = {
                    label = "Tendência / Chance",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Tendência / Duração / Minutos",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Tendência / Máximo / Intensidade",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Tendência / Mínimo / Intensidade",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Atualização / Minutos",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatilidade / Máximo",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatilidade / Mínimo",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Clima / Multiplicadores",
                },
                dynamicMarketWeatherState = {
                    label = "Clima / Estado",
                },
                heatActionCooldownSeconds = {
                    label = "Cooldown de ação / segundos",
                },
                heatActivityRiskWeights = {
                    label = "Atividade / Risco / Ponderações",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Modo agressivo / Pressão policial / Multiplicador",
                },
                heatBurnerBurnThreshold = {
                    label = "Telefone descartável / Exposição / Limite",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Telefone descartável / Pressão policial / Por venda no atacado",
                },
                heatBurnerPhoneItem = {
                    label = "Celular Descartável / Item",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Trailer em operação / Pressão policial / Multiplicador",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Trailer em operação / Pressão policial / Limite",
                },
                heatCamperParkedHeat = {
                    label = "Trailer estacionado / Pressão policial",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Contaminação / Pressão policial / Multiplicador",
                },
                heatContaminatedThreshold = {
                    label = "Contaminação / Limite",
                },
                heatCultivationFreePlants = {
                    label = "Cultivo / Plantas sem risco adicional",
                },
                heatCultivationHeatPerPlant = {
                    label = "Cultivo / Pressão policial / Por planta",
                },
                heatDealerHiddenMinutes = {
                    label = "Revendedor / oculto / Minutos",
                },
                heatDecayPerTick = {
                    label = "Decadência / Por ciclo de atualização",
                },
                heatEnabled = {
                    label = "Ativado",
                },
                heatEnforcementHeat = {
                    label = "Presença policial / Pressão policial",
                },
                heatEnforcementMultipliers = {
                    label = "Presença policial / Multiplicadores",
                },
                heatEntityTypes = {
                    label = "Entidade / Tipos",
                },
                heatEventCooldownMinutes = {
                    label = "Evento / Minutos de tempo de espera",
                },
                heatEventHistoryLimit = {
                    label = "Evento / Limite do histórico",
                },
                heatLabHeatSyncThreshold = {
                    label = "Laboratório / Pressão policial / Sincronização / Limite",
                },
                heatLayLowCooldownMinutes = {
                    label = "Manter discrição / Minutos de tempo de espera",
                },
                heatLayLowIdleMinutes = {
                    label = "Manter discrição / Inactivo / Minutos",
                },
                heatLayLowReduction = {
                    label = "Manter discrição / Redução",
                },
                heatLockdownMinutes = {
                    label = "Bloqueio / Minutos",
                },
                heatMinimumDurationMinutes = {
                    label = "Mínimo / Duração / Minutos",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Mínimo / Evento / Cooldown (segundos)",
                },
                heatMinimumIdleSeconds = {
                    label = "Mínimo / Inactivo / segundos",
                },
                heatProcessingHeatMultiplier = {
                    label = "Processamento / Pressão policial / Multiplicador",
                },
                heatRiskWeights = {
                    label = "Risco / Ponderações",
                },
                heatRotateBurnerReduction = {
                    label = "Trocar telefone descartável / Redução",
                },
                heatRouteControlMinutes = {
                    label = "Rota / Controle / Minutos",
                },
                heatSaleHeat = {
                    label = "Venda / Pressão policial",
                },
                heatThresholds = {
                    label = "Limites",
                },
                heatTickMinutes = {
                    label = "Ciclo de atualização / Minutos",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Grossista / Pressão policial / Multiplicador",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Trabalhador / Vazamento / Raio de Alerta",
                },
                heatWorkerLeakBaseChance = {
                    label = "Trabalhador / Vazamento / Valor base / Chance",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Trabalhador / Vazamento / Facção / Multiplicador",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Trabalhador / Vazamento / Alta / Gravidade / Limite",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Trabalhador / Vazamento / Lealdade / Chance / Multiplicador",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Trabalhador / Vazamento / Lealdade / Limite",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Trabalhador / Vazamento / Máximo / Chance",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Trabalhador / Vazamento / Mínimo / Cooldown (segundos)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Trabalhador / Vazamento / Rota / Multiplicador",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Trabalhador / Vazamento / Intensidade / Máximo",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Trabalhador / Vazamento / Intensidade / Mínimo",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Trabalhador / Vazamento / Intensidade / Multiplicador",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Trabalhador / Vazamento / Estresse / Chance / Multiplicador",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Trabalhador / Vazamento / Estresse / Limite",
                },
                contactsActionCooldownSeconds = {
                    label = "Cooldown de ação / segundos",
                },
                contactsActiveHotspotCount = {
                    label = "Número de pontos ativos",
                },
                contactsBurnerHintTrust = {
                    label = "Dica de burner / Confiança",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Telefone descartável / Oferta / Máximo / Multiplicador",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Telefone descartável / Oferta / Mínimo / Multiplicador",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Comprador / Minutos de tempo de espera",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Comprador / Distância de entrega",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Comprador / Premium / Sucesso / Pontuação",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Comprador / Premium / Confiança / ganho",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Comprador / Solicitação / Nível de procurado e Risco / Peso",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Comprador / Padrão / Confiança / ganho",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Espera para ativar contato / segundos",
                },
                contactsContactDemandRange = {
                    label = "Contacto / Demanda / Faixa de valores",
                },
                contactsContactLossTrust = {
                    label = "Contacto / Perda / Confiança",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Rede obscura / Informações exatas / Minutos",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Rede obscura / Ponto ativo / Informações / Preço",
                },
                contactsDarknetIntelPrice = {
                    label = "Rede obscura / Informações / Preço",
                },
                contactsDealerBasePrice = {
                    label = "Revendedor / Preço Base",
                },
                contactsDealerHireCapacity = {
                    label = "Revendedor / Contratação / capacidade",
                },
                contactsDealerHireRisk = {
                    label = "Revendedor / Contratação / Risco",
                },
                contactsDealerHireSkill = {
                    label = "Revendedor / Contratação / Habilidade",
                },
                contactsDealerOffers = {
                    label = "Ofertas do revendedor",
                },
                contactsDealerProtectionHours = {
                    label = "Revendedor / Proteção / Horas",
                },
                contactsDealerProtectionPrice = {
                    label = "Revendedor / Proteção / Preço",
                },
                contactsDealerSaleMax = {
                    label = "Revendedor / Venda / Máximo",
                },
                contactsDealerSaleMin = {
                    label = "Revendedor / Venda / Mínimo",
                },
                contactsDealerSimulation = {
                    label = "Revendedor / Simulação",
                },
                contactsDealerTickMinutes = {
                    label = "Revendedor / Ciclo de atualização / Minutos",
                },
                contactsDealerWage = {
                    label = "Revendedor / Salário",
                },
                contactsDealerWageDecay = {
                    label = "Revendedor / Salário / Decadência",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Revendedor / Salário / Lealdade / ganho",
                },
                contactsDealerWeaknesses = {
                    label = "Revendedor / Fraquezas",
                },
                contactsDefaultContactDemand = {
                    label = "Valor padrão / Contacto / Demanda",
                },
                contactsDefaultContactRisk = {
                    label = "Valor padrão / Contacto / Risco",
                },
                contactsDefaultDealerCapacity = {
                    label = "Traficante padrão / capacidade",
                },
                contactsDefaultDealerRisk = {
                    label = "Traficante padrão / Risco",
                },
                contactsDefaultDealerSkill = {
                    label = "Traficante padrão / Habilidade",
                },
                contactsDefaultHotspotRadius = {
                    label = "Valor padrão / Ponto ativo / Raio",
                },
                contactsDemandResetMinutes = {
                    label = "Reset de demanda (minutos)",
                },
                contactsEnabled = {
                    label = "Ativado",
                },
                contactsExactLocationTrust = {
                    label = "Localização exata / Confiança",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Facção / Descoberta / Reputação",
                },
                contactsFactionHintTrust = {
                    label = "Facção / Pista / Confiança",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Entrega malsucedida / Minutos de tempo de espera",
                },
                contactsFakeDealEncounter = {
                    label = "Negócio falso / Encontro",
                },
                contactsFallbackPreferredDrug = {
                    label = "Valor alternativo / Droga Preferencial",
                },
                contactsFallbackProductLabel = {
                    label = "Valor alternativo / Rótulo do produto",
                },
                contactsGuideBookItem = {
                    label = "Guia / Livro / Item",
                },
                contactsGuideBookTrust = {
                    label = "Guia / Livro / Confiança",
                },
                contactsHireDealerPrice = {
                    label = "Contratar revendedor / Preço",
                },
                contactsHistoryLimit = {
                    label = "Limite do histórico",
                },
                contactsHotspotIntelMinutes = {
                    label = "Ponto ativo / Informações / Minutos",
                },
                contactsHotspotRotationMinutes = {
                    label = "Ponto ativo / Rotação / Minutos",
                },
                contactsListingDurationMinutes = {
                    label = "Anúncio / Duração / Minutos",
                },
                contactsMaxOwnedDealers = {
                    label = "Máximo / Possuídas / Traficantes",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Mínimo / Comprador / Distância de entrega",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Mínimo / Rotação de contato (minutos)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Mínimo / Reset de demanda (minutos)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Mínimo / Pressão policial / Multiplicador",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Mínimo / Ponto ativo / Informações / Minutos",
                },
                contactsMinimumHotspotRadius = {
                    label = "Mínimo / Ponto ativo / Raio",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Mínimo / Ponto ativo / Rotação / Minutos",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Mínimo / Anúncio / Duração / Minutos",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Recompensa mínima / Multiplicador",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Mínimo / Assalto / Multiplicador",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Mínimo / Local / Multiplicador de Preço",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Outro / Droga / Multiplicador de Preço",
                },
                contactsPaymentAccount = {
                    label = "Conta de pagamento",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Após a entrega / Demanda / Reset / segundos",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Droga Preferencial / Multiplicador de Preço",
                },
                contactsRegionLocationTrust = {
                    label = "Região / Localização / Confiança",
                },
                contactsRequestAmounts = {
                    label = "Solicitação / Quantidades",
                },
                contactsRotationMinutes = {
                    label = "Rotação / Minutos",
                },
                contactsSpotPools = {
                    label = "Local / Conjuntos de seleção",
                },
                contactsStreetHotspots = {
                    label = "Rua / Pontos ativos",
                },
                contactsTrustLevels = {
                    label = "Confiança / Níveis",
                },
                businessActionCooldownSeconds = {
                    label = "Cooldown de ação / segundos",
                },
                businessBalance = {
                    label = "Saldo",
                },
                businessContracts = {
                    label = "Contratos",
                },
                businessDefaultBusinessName = {
                    label = "Valor padrão / Nome comercial",
                },
                businessDefaultRankId = {
                    label = "Valor padrão / Cargo / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Valor padrão / Pessoal / Estilo de trabalho",
                },
                businessDefaultTransport = {
                    label = "Valor padrão / Transportes",
                },
                businessEnabled = {
                    label = "Ativado",
                },
                businessHubs = {
                    label = "Centros de distribuição",
                },
                businessLimits = {
                    label = "Limites",
                },
                businessPayments = {
                    label = "Pagamentos",
                },
                businessPayoutAccount = {
                    label = "Pagamento / Conta",
                },
                businessRanks = {
                    label = "Patentes",
                },
                businessReportDays = {
                    label = "Período do relatório / dias",
                },
                businessRouteEndpointTypes = {
                    label = "Rota / Ponto final / Tipos",
                },
                businessRuntime = {
                    label = "Funcionamento no jogo",
                },
                businessSocietyPermission = {
                    label = "Organização / Permissão",
                },
                businessStaff = {
                    label = "Pessoal",
                },
                businessTickMinutes = {
                    label = "Ciclo de atualização / Minutos",
                },
                businessTransports = {
                    label = "Transportes",
                },
            },
            territorySettings = {
                section = "Territórios",
                zonesGroup = "Zonas de território",
                sourceLabel = "Fonte da zona",
                sourceDescription = "Use os distritos predefinidos protegidos ou defina seus próprios polígonos de território.",
                sourcePreset = "Distritos predefinidos",
                sourceCustom = "Territórios personalizados",
                editLabel = "Editor de território",
                editDescription = "Edite os distritos usados pela fonte de zona selecionada.",
                editButton = "Editar territórios",
                presetSection = "Distritos predefinidos",
                presetEntry = "Distrito predefinido",
                customSection = "Territórios personalizados",
                customEntry = "Território personalizado",
                typeLabel = "Tipo de território",
                streetType = "Rua",
                supplyType = "Fornecimento",
                enabledLabel = "Mostrar no mapa",
                enabledDescription = "Distritos predefinidos desativados são removidos do mapa e não podem ser reivindicados.",
                zoneLabel = "Limite do território",
                zoneDescription = "Adicione pelo menos três pontos em ordem ao redor do limite do território.",
                ownershipGroup = "Propriedade",
                decayGroup = "Decadência",
                presenceGroup = "Presença",
                activityGroup = "Pontuação de atividade",
                ownershipBenefitsGroup = "Benefícios de propriedade",
                ownershipThresholdLabel = "Limite de propriedade",
                ownershipThresholdDescription = "Porcentagem de controle que uma gangue deve exceder para possuir oficialmente um território.",
                activityFloorLabel = "Piso de atividade fixo",
                activityFloorDescription = "Pontos de influência necessários quando os pisos baseados em tamanho estão desativados.",
                floorByZoneSizeLabel = "Escalar piso por tamanho da zona",
                floorByZoneSizeDescription = "Calcula o piso de atividade de cada território a partir de sua área de polígono em vez de usar o piso fixo.",
                floorPointsPerSizeUnitLabel = "Pontos de piso por km²",
                floorPointsPerSizeUnitDescription = "Pontos de piso de atividade necessários para cada quilômetro quadrado de área do território.",
                fixedFloorRequirement = "Desative os pisos baseados em tamanho para editar o piso de atividade fixo.",
                sizeFloorRequirement = "Ative os pisos baseados em tamanho para editar os pontos por quilômetro quadrado.",
                dailyDecayLabel = "Decadência diária de influência",
                dailyDecayDescription = "Porcentagem de influência removida a cada 24 horas.",
                presenceIntervalLabel = "Intervalo de presença",
                presenceIntervalDescription = "Minutos entre recompensas automáticas de presença de território.",
                presencePointsLabel = "Pontos de presença por membro",
                presencePointsDescription = "Pontos de presença concedidos a cada membro elegível da gangue por intervalo.",
                drugSalesEnabledLabel = "Vendas para NPCs concedem influência de território",
                drugSalesEnabledDescription = "Vendas de rua bem-sucedidas para NPCs concedem influência à gangue do vendedor no território de Rua atual.",
                drugSalePointsLabel = "Pontos por droga vendida",
                drugSalePointsDescription = "Pontos de influência concedidos para cada unidade de droga relatada como vendida.",
                drugSalesRequirement = "Ative a influência de venda de NPC para configurar seus pontos.",
                graffitiPointsLabel = "Pontos de graffiti por 24 horas",
                graffitiPointsDescription = "Pontos de presença concedidos quando um graffiti existiu por um total de 24 horas relatadas.",
                streetSellingPriceBonusLabel = "Bônus de preço de venda de rua",
                streetSellingPriceBonusDescription = "Porcentagem adicionada aos preços de venda de drogas para o proprietário oficial de um território de Rua.",
                supplyProductionSpeedBonusLabel = "Bônus de velocidade de produção de suprimentos",
                supplyProductionSpeedBonusDescription = "Porcentagem adicionada à velocidade de produção de drogas para o proprietário oficial de um território de Suprimentos.",
                pruneToleranceLabel = "Tolerância de poda de influência",
                pruneToleranceDescription = "A influência efetiva abaixo deste valor é tratada como zero.",
            },
            graffitiSettings = {
                section = "Grafite",
                generalGroup = "Geral",
                streamingGroup = "Renderizando",
                moderationGroup = "Moderação",
                graffitiEnabledLabel = "Ativar grafite",
                graffitiEnabledDescription = "Permite que os jogadores pichem e vejam grafites.",
                graffitiRequireItemLabel = "Exigir lata de spray",
                graffitiRequireItemDescription = "Os jogadores precisam de um item de lata de spray para pichar. Caso contrário, o comando /graffiti será usado.",
                graffitiChargesPerCanLabel = "Cargas por lata",
                graffitiChargesPerCanDescription = "Quantos grafites uma única lata de spray pode criar.",
                graffitiCooldownSecondsLabel = "Tempo de recarga do spray",
                graffitiCooldownSecondsDescription = "Segundos que um jogador deve esperar entre os grafites.",
                graffitiMaxPerPlayerLabel = "Max. graffiti por jogador",
                graffitiMaxPerPlayerDescription = "Máximo de graffiti ativos que um jogador pode possuir. 0 significa ilimitado.",
                graffitiMaxDistanceLabel = "Distância máx. de spray",
                graffitiMaxDistanceDescription = "A que distância uma parede pode estar para ainda poder borrifá-la, em metros.",
                graffitiSprayDurationLabel = "Duração do spray",
                graffitiSprayDurationDescription = "Quanto tempo a animação de spray dura, em milissegundos.",
                graffitiExpiryDaysLabel = "Tempo de expiração",
                graffitiExpiryDaysDescription = "Dias até que um graffiti desapareça automaticamente. 0 significa nunca.",
                graffitiTerritoryHoursLabel = "Horas de território por spray",
                graffitiTerritoryHoursDescription = "Horas de presença de território que um graffiti novo concede à sua gangue.",
                graffitiStreamRadiusLabel = "Raio de streaming",
                graffitiStreamRadiusDescription = "Distância em metros na qual o graffiti se torna visível para os jogadores.",
                graffitiPoolSizeLabel = "Tamanho do pool de decalques",
                graffitiPoolSizeDescription = "Quantos graffiti são renderizados de uma vez. Valores mais altos consomem mais desempenho.",
                graffitiReportsEnabledLabel = "Ativar denúncias",
                graffitiReportsEnabledDescription = "Permite que os jogadores denunciem graffiti ofensivos.",
                graffitiAutoHideThresholdLabel = "Limite de ocultação automática",
                graffitiAutoHideThresholdDescription = "Número de denúncias que oculta automaticamente um graffiti. 0 desativa isso.",
            },
            darknetSettings = {
                section = "Mercado Darknet",
                availabilityGroup = "Disponibilidade",
                economyGroup = "Criptomoeda",
                listingsGroup = "Ofertas e validade",
                chatGroup = "Chat privado",
                identityGroup = "Aliases e reputação",
                deliveryGroup = "Entregas e dead drops",
                policeGroup = "Acesso policial",
                npcGroup = "Negociantes NPC",
                enabledLabel = "Ativar Mercado Darknet",
                enabledDescription = "Disponibiliza o aplicativo de tablet do mercado negro e sua execução.",
                tabletOrderLabel = "Ordem do app no tablet",
                tabletOrderDescription = "Controla a posição do Mercado Darknet no tablet.",
                currencyCodeLabel = "Código da moeda",
                currencyCodeDescription = "Rótulo curto exibido para o livro contábil interno de criptomoeda.",
                starterBalanceLabel = "Saldo inicial da carteira",
                starterBalanceDescription = "Cripto atribuída apenas quando um jogador abre o mercado pela primeira vez.",
                exchangeEnabledLabel = "Ativar troca de moedas",
                exchangeEnabledDescription = "Permite que usuários autenticados do BlackBay comprem e vendam moedas em sua página de conta.",
                exchangeAccountLabel = "Conta de pagamento de troca",
                exchangeAccountDescription = "Conta do framework usada para compras de moedas e pagamentos de vendas.",
                exchangeBuyPriceLabel = "Preço de compra por moeda",
                exchangeBuyPriceDescription = "Valor cobrado da conta de pagamento por uma moeda.",
                exchangeSellPriceLabel = "Preço de venda por moeda",
                exchangeSellPriceDescription = "Valor pago à conta de pagamento por uma moeda.",
                exchangeMinimumLabel = "Mínimo de moedas por troca",
                exchangeMinimumDescription = "Menor quantidade de moedas inteiras aceita em uma troca.",
                exchangeMaximumLabel = "Máximo de moedas por troca",
                exchangeMaximumDescription = "Maior quantidade de moedas inteiras aceita em uma troca.",
                accountMoney = "Dinheiro",
                accountBank = "Banco",
                accountBlackMoney = "Dinheiro sujo",
                scamChanceLabel = "Chance global de golpe de NPC (%)",
                scamChanceDescription = "Chance mínima de que um negociante NPC receba o pagamento ou os bens sem entregar a contrapartida. Uma chance maior específica do negociante ainda se aplica.",
                listingExpiryLabel = "Tempo de vida da oferta (horas)",
                listingExpiryDescription = "Ofertas ativas expiram automaticamente após este número de horas.",
                renewalHoursLabel = "Duração da renovação (horas)",
                renewalHoursDescription = "Horas adicionadas quando um proprietário renova uma oferta.",
                maximumListingsLabel = "Máximo de anúncios ativos",
                maximumListingsDescription = "Máximo de anúncios por alias ativo.",
                maximumQuantityLabel = "Quantidade máxima de itens",
                maximumQuantityDescription = "Limite superior de quantidade para uma oferta.",
                maximumPriceLabel = "Preço máximo por unidade",
                maximumPriceDescription = "Preço máximo em cripto por unidade.",
                maximumMessageLengthLabel = "Comprimento máximo da mensagem",
                maximumMessageLengthDescription = "Número máximo de caracteres por mensagem de chat criptografada.",
                aliasCooldownLabel = "Tempo de recarga para mudar de alias (horas)",
                aliasCooldownDescription = "Idade mínima de uma identidade antes que ela possa ser aposentada novamente.",
                verifiedSalesLabel = "Vendas necessárias para verificação",
                verifiedSalesDescription = "Vendas bem-sucedidas necessárias antes que um vendedor possa ser verificado.",
                verifiedRatingLabel = "Avaliação necessária para verificação",
                verifiedRatingDescription = "Avaliação média mínima para um vendedor verificado.",
                scammerReportsLabel = "Denúncias para aviso de golpista",
                scammerReportsDescription = "Denúncias de transações únicas necessárias para o emblema de golpista conhecido.",
                meetingDistanceLabel = "Distância de entrega",
                meetingDistanceDescription = "Distância máxima entre ambos os jogadores ou o ponto de NPC configurado.",
                dropModelLabel = "Modelo da caixa de dead-drop",
                dropModelDescription = "Modelo de prop do GTA spawnado localmente para dead-drops disponíveis.",
                dropStreamLabel = "Distância de renderização do dead-drop",
                dropStreamDescription = "Distância na qual as caixas e os contatos de encontro com NPCs são renderizados.",
                dropInteractionLabel = "Distância de interação do dead-drop",
                dropInteractionDescription = "Distância necessária para vasculhar e reivindicar uma caixa.",
                dropLifetimeLabel = "Tempo de vida do dead-drop (horas)",
                dropLifetimeDescription = "Tempo antes que uma caixa não reivindicada expire.",
                dropPollLabel = "Intervalo de atualização do mundo (ms)",
                dropPollDescription = "Intervalo usado para atualizar caixas próximas e encontros com NPCs.",
                policeGroupsLabel = "Grupos de trabalho policiais autorizados",
                policeGroupsDescription = "Chaves de grupo do Configurador de Emprego que podem publicar ofertas isca e visualizar investigações.",
                policeGroupEntry = "Grupo policial",
                groupKeyLabel = "Chave do grupo",
                npcTradersLabel = "Compradores e vendedores NPC",
                npcTradersDescription = "Configure ofertas sintéticas persistentes, método de entrega, reputação e probabilidade de golpe.",
                npcTraderEntry = "Trader NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "Apelido",
                npcSideLabel = "Lado do mercado",
                sideSell = "Vende para jogadores",
                sideBuy = "Compra de jogadores",
                npcTitleLabel = "Título da oferta",
                npcDescriptionLabel = "Descrição",
                npcItemNameLabel = "Nome do item de inventário",
                npcItemLabelLabel = "Rótulo de mercadoria",
                npcQuantityLabel = "Quantidade",
                npcPriceLabel = "Preço por unidade",
                npcDeliveryLabel = "Método de entrega",
                deliveryBoth = "Encontro e dead-drop",
                deliveryMeeting = "Apenas face a face",
                deliveryDrop = "Apenas dead-drop",
                npcScamChanceLabel = "Chance de golpe do comerciante (%)",
                npcPedModelLabel = "Modelo do ped NPC",
                npcRatingLabel = "Avaliação exibida",
                npcRatingCountLabel = "Contagem de avaliações exibida",
                npcTradesLabel = "Transações bem-sucedidas exibidas",
                npcVerifiedLabel = "Comerciante verificado",
                npcScammerLabel = "Golpista conhecido",
                npcEnabledLabel = "Ativado",
            },
            interrogationSettings = {
                section = "Interrogatório",
                generalGroup = "Geral",
                consentGroup = "Proteção do jogador",
                objectGroup = "Objetos",
                grabGroup = "Imobilização",
                sessionGroup = "Sessão",
                dispatchGroup = "Alertas policiais",
                loggingGroup = "Registro",
                securityGroup = "Segurança",
                presentationGroup = "Apresentação",
                enabledLabel = "Ativar interrogatório",
                enabledDescription = "Permite que os jogadores amarrem outros em cadeiras de interrogatório e usem ferramentas neles.",
                consentRequiredLabel = "Exigir consentimento",
                consentRequiredDescription = "Apenas jogadores que aceitaram podem se tornar vítimas. Nada concede consentimento automaticamente, portanto, isso requer a configuração abaixo.",
                consentDefaultLabel = "Consentimento padrão",
                consentDefaultDescription = "Novos personagens começam com o consentimento concedido em vez de negado.",
                globalIntensityLabel = "Intensidade do efeito",
                globalIntensityDescription = "Ajusta efeitos de tela, partículas e som. 0 desativa-os completamente.",
                maxPerPlayerLabel = "Objetos por jogador",
                maxPerPlayerDescription = "Quantidade de cadeiras e carrinhos que um jogador pode ter colocado. 0 significa ilimitado.",
                maxGlobalLabel = "Objetos em todo o servidor",
                maxGlobalDescription = "Total de objetos colocados permitidos de uma vez. 0 significa ilimitado.",
                placementDistanceLabel = "Distância de posicionamento",
                placementDistanceDescription = "A que distância do jogador um objeto pode ser colocado, em metros.",
                interactDistanceLabel = "Distância de interação",
                interactDistanceDescription = "O quão perto um jogador deve estar para usar uma cadeira ou carrinho, em metros.",
                inactivityMinutesLabel = "Remoção automática após",
                inactivityMinutesDescription = "Minutos de inatividade antes de um objeto colocado desaparecer. 0 mantém para sempre.",
                persistObjectsLabel = "Manter objetos após reinicialização",
                persistObjectsDescription = "Os objetos colocados são restaurados do banco de dados quando o servidor retorna.",
                grabEnabledLabel = "Ativar imobilização",
                grabEnabledDescription = "Permite que jogadores imobilizem e carreguem outro jogador.",
                grabItemLabel = "Item necessário",
                grabItemDescription = "Item que o agressor precisa para imobilizar alguém. Deixe vazio para não exigir nenhum.",
                grabAngleLabel = "Ângulo de aproximação",
                grabAngleDescription = "O quão longe lateralmente de trás do agressor o jogador pode estar, em graus.",
                grabHealthBelowLabel = "Limite de vida",
                grabHealthBelowDescription = "Uma vítima abaixo deste nível de vida pode ser imobilizada sem ser contida. 0 desativa isso.",
                grabCooldownLabel = "Tempo de recarga após falha",
                grabCooldownDescription = "Segundos antes de uma tentativa de imobilização falha poder ser tentada novamente.",
                grabVehiclesLabel = "Veículos permitidos",
                grabVehiclesDescription = "Modelos de veículos em que uma vítima imobilizada pode ser colocada.",
                carryEnabledLabel = "Permitir carregar",
                carryEnabledDescription = "Permite que o agressor carregue a vítima sobre o ombro.",
                restrictVisionLabel = "Restringir visão da vítima",
                restrictVisionDescription = "Escurece a tela da vítima enquanto ela está sendo transportada.",
                escapeEnabledLabel = "Permitir tentativas de fuga",
                escapeEnabledDescription = "Permite que uma vítima sendo transportada tente se libertar.",
                escapeSecondsLabel = "Duração da fuga",
                escapeSecondsDescription = "Segundos que a vítima deve segurar a tecla para se libertar.",
                maxDurationLabel = "Duração máxima",
                maxDurationDescription = "Minutos após os quais uma sessão termina sozinha.",
                warnMinutesLabel = "Aviso antes do fim",
                warnMinutesDescription = "Minutos antes do limite em que ambos os lados são avisados.",
                idleMinutesLabel = "Liberar em inatividade",
                idleMinutesDescription = "Minutos sem qualquer interação antes de a vítima ser liberada.",
                selfReleaseMinutesLabel = "Autolibertação após",
                selfReleaseMinutesDescription = "Minutos sem interação do agressor antes de a vítima poder se libertar sozinha.",
                graceSecondsLabel = "Período de tolerância após desconexão",
                graceSecondsDescription = "Segundos que a vítima permanece amarrada quando o agressor sai do servidor.",
                rescueEnabledLabel = "Permitir resgates",
                rescueEnabledDescription = "Permite que jogadores não envolvidos libertem uma vítima amarrada.",
                rescueSecondsLabel = "Duração do resgate",
                rescueSecondsDescription = "Segundos que um resgatador precisa para libertar a vítima.",
                rescueItemLabel = "Item de resgate",
                rescueItemDescription = "Item que um resgatador precisa. Deixe vazio para não exigir nenhum.",
                allowInventoryLabel = "Vítima mantém o inventário",
                allowInventoryDescription = "Uma vítima amarrada ainda pode abrir seu inventário.",
                dispatchEnabledLabel = "Ativar alertas policiais",
                dispatchEnabledDescription = "Reporta sequestros e interrogatórios aos serviços de emergência.",
                dispatchAdapterLabel = "Sistema de alerta",
                dispatchAdapterDescription = "Qual sistema de despacho recebe os relatos.",
                dispatchJobsLabel = "Empregos que recebem",
                dispatchJobsDescription = "Empregos que recebem o alerta.",
                dispatchGrabChanceLabel = "Chance ao imobilizar",
                dispatchGrabChanceDescription = "Chance percentual de que uma imobilização seja reportada.",
                dispatchFixateChanceLabel = "Chance ao amarrar",
                dispatchFixateChanceDescription = "Chance percentual de que amarrar alguém em uma cadeira seja reportado.",
                dispatchToolChanceLabel = "Chance de uso de ferramenta",
                dispatchToolChanceDescription = "Chance percentual de que o uso de uma ferramenta seja reportado.",
                dispatchWitnessLabel = "Requer uma testemunha",
                dispatchWitnessDescription = "Reportar apenas quando outro jogador estiver perto o suficiente para notar.",
                dispatchWitnessRadiusLabel = "Raio da testemunha",
                dispatchWitnessRadiusDescription = "Quão perto uma testemunha deve estar, em metros.",
                dispatchCooldownLabel = "Cooldown de alerta",
                dispatchCooldownDescription = "Segundos entre dois alertas da mesma sessão.",
                dispatchInaccuracyLabel = "Imprecisão de posição",
                dispatchInaccuracyDescription = "Metros que a posição reportada é deslocada aleatoriamente. 0 reporta o local exato.",
                loggingEnabledLabel = "Ativar log",
                loggingEnabledDescription = "Registra posicionamentos, imobilizações, uso de ferramentas, liberações e ações de admin.",
                logDatabaseLabel = "Registrar no banco de dados",
                logDatabaseDescription = "Escreve adicionalmente cada entrada na tabela de log de interrogatório.",
                logRetentionLabel = "Manter logs",
                logRetentionDescription = "Dias antes que os logs do banco de dados sejam excluídos. 0 os mantém para sempre.",
                pingToleranceLabel = "Tolerância de distância",
                pingToleranceDescription = "Metros adicionados a cada verificação de distância no lado do servidor para absorver o lag.",
                violationThresholdLabel = "Limite de violação",
                violationThresholdDescription = "Violações de segurança dentro da janela antes da reação ser disparada. 0 desativa isso.",
                violationActionLabel = "Reação a violações",
                violationActionDescription = "O que acontece assim que um jogador ultrapassa o limite de violação.",
                violationActionNone = "Não fazer nada",
                violationActionLog = "Apenas logar",
                violationActionKick = "Expulsar",
                violationActionCheating = "Reportar como trapaça",
                particlesLabel = "Efeitos de partículas",
                particlesDescription = "Mostrar sangue, faíscas e chamas durante o uso de ferramentas.",
                soundLabel = "Efeitos sonoros",
                soundDescription = "Reproduzir sons de ferramentas para todos os próximos.",
                cameraWorkLabel = "Movimentação de câmera",
                cameraWorkDescription = "Move a câmera ao amarrar alguém e durante o uso de ferramentas.",
                screenEffectsLabel = "Efeitos de tela",
                screenEffectsDescription = "Tremor, flash, desfoque e filtros de cor na tela da vítima.",
                objectsSection = "Objetos de interrogatório",
                objectsEntry = "Objeto",
                objectsEditLabel = "Objetos de interrogatório",
                objectsEditDescription = "Colocar cadeiras permanentes e carrinhos de ferramentas no mapa.",
                objectsEditButton = "Editar objetos",
                objectsKindLabel = "Tipo de objeto",
                objectsKindChair = "Cadeira",
                objectsKindCart = "Carrinho de ferramentas",
                objectsModelLabel = "Modelo do prop",
                objectsPositionLabel = "Posição",
                blockedZonesSection = "Zonas bloqueadas",
                blockedZonesEntry = "Zona",
                blockedZonesEditLabel = "Zonas bloqueadas",
                blockedZonesEditDescription = "Áreas onde nenhum objeto de interrogatório pode ser colocado.",
                blockedZonesEditButton = "Editar zonas",
                blockedZonesZoneLabel = "Contorno da zona",
                blockedZonesZoneDescription = "Arraste os cantos para moldar a área onde o posicionamento é recusado.",
                toolsSection = "Ferramentas",
                toolsEntry = "Ferramenta",
                toolsEditLabel = "Ferramentas",
                toolsEditDescription = "Adicionar ou ajustar as ferramentas que podem ser usadas em uma vítima.",
                toolsEditButton = "Editar ferramentas",
                toolsItemLabel = "Item necessário",
                toolsConsumeLabel = "Consumir item",
                toolsDamageLabel = "Dano por uso",
                toolsHealthFloorLabel = "Limite de vida",
                toolsCooldownLabel = "Cooldown em segundos",
                toolsProgressLabel = "Progresso por uso",
                sessionsSection = "Sessões em andamento",
                sessionsEntry = "Sessão",
                sessionsEditLabel = "Sessões em andamento",
                sessionsEditDescription = "Veja quem está sendo interrogado no momento e encerre se necessário.",
                sessionsEditButton = "Mostrar sessões",
                sessionsStateLabel = "Estado",
                sessionsProgressLabel = "Progresso",
                orphansSection = "Objetos órfãos",
                orphansEntry = "Objeto",
                orphansEditLabel = "Objetos órfãos",
                orphansEditDescription = "Remover objetos cujo proprietário não é visto há muito tempo.",
                orphansEditButton = "Limpar",
                sessionStates = {
                    binding = "Sendo imobilizado",
                    active = "Ativa",
                    ending = "Encerrando",
                },
            },
        },
    },
}
