JobConfigLocales["sky_dojjob:pt"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Finanças" ,
                doj_conditions = "Patologias",
                doj_elections = "Eleições",
                doj_files = "Explorador de Ficheiros de Caso",
                doj_hearings = "Audiências",
                doj_law = "Códigos Legais",
                doj_offences = "Catálogo Fino",
                doj_shared_files = "Documentos partilhados",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Configurar o acesso aos processos",
                description = "Escolha quem pode aceder aos registos e em que área trabalha. Os cargos sem atribuição não têm acesso.",
                status = {
                    unpublished = "A atribuição ainda não foi publicada",
                    conflict = "Resolva as atribuições duplicadas",
                    disabled = "O tablet do DOJ está desativado",
                    incomplete = "Atribua pelo menos um cargo",
                    ready = "Pronto para guardar",
                },
                steps = {
                    tabletTitle = "Ativar o tablet do DOJ",
                    tabletText = "O tablet tem de estar ativado para abrir as aplicações de processos.",
                    gradesTitle = "Atribuir cargos do DOJ",
                    gradesText = "Selecione exatamente uma área de registos para cada cargo que deve receber acesso.",
                    publishTitle = "Publicar e guardar",
                    publishText = "Após cada alteração das atribuições, é preparada automaticamente uma nova versão.",
                },
                grades = {
                    title = "Atribuições de cargos",
                    description = "Selecione uma área por cargo. Escolha Sem acesso para os cargos que devem permanecer bloqueados.",
                    search = "Pesquisar cargos",
                    conflict = "Um cargo tem mais de uma atribuição. Selecione uma área ou Sem acesso para resolver o conflito.",
                    notFound = "Já não existe no framework",
                    noResults = "Não foi encontrado nenhum cargo correspondente.",
                    empty = "Não foram encontrados cargos para o emprego do DOJ configurado.",
                    emptyHint = "Crie primeiro os cargos do DOJ no framework e volte a abrir o configurador.",
                    gradeColumn = "Cargo",
                    domainColumn = "Área de registos",
                    noAccess = "Sem acesso",
                    chooseDomain = "Resolver atribuição",
                    assigned = "cargos atribuídos",
                },
                publish = {
                    saveHint = "Clique em Guardar no topo para aplicar as alterações. Os jogadores podem depois verificar novamente o acesso.",
                },
            },
            registryFiles = { licenseType = "Tipo de licença", licenseLabel = "Nome do registo", marriages = "Registo de casamentos" },
            features = {
                dojHandovers = {
                    label = "Encaminhamentos",
                    description = "Ativa encaminhamentos, decisões judiciais e relatórios de execução. Os documentos e a partilha continuam disponíveis.",
                },
                dojBodycamRequests = {
                    label = "Pedidos de gravações de câmara corporal",
                    description = "Solicitar gravações policiais. Requer Encaminhamentos; as gravações guardadas continuam disponíveis separadamente.",
                },
                dojFinance = { label = "Finanças", description = "Saldos das facções, transferências do tesouro e histórico." },
                dojConditions = {
                    description = "Ative condições estruturadas, evidências, prazos e acompanhamento de violações.",
                    label = "Patologias",
                },
                dojCourtroom = {
                    description = "Ative sessões de tribunal ao vivo seguras, apresentação de evidências e interações de sala baseadas em funções.",
                    label = "Sala do tribunal ao vivo",
                },
                dojElections = {
                    description = "Ativar a administração eleitoral e garantir a votação em cabines de votação registradas.",
                    label = "Eleições",
                },
                dojHearings = {
                    description = "Ative o agendamento do tribunal, o check-in e os controles de status de audiência autorizados.",
                    label = "Audiências",
                },
                dojLegalCodes = {
                    description = "Ative livros legais, edição de texto rico e histórico de revisões.",
                    label = "Códigos legais",
                },
                dojOffences = {
                    description = "Ative o catálogo de delito compacto e a visualização da calculadora.",
                    label = "Catálogo fino",
                },
                dojPrinters = {
                    description = "Ative impressoras físicas e sua infraestrutura de tempo de execução.",
                    label = "Impressoras",
                },
                dojPublicDisplays = {
                    description = "Ative dados ao vivo filtrados por privacidade para exibições de tribunais.",
                    label = "Exibições de tribunais públicos",
                },
                dojTablet = {
                    description = "Ative o acesso aos aplicativos do tablet DOJ.",
                    label = "DOJ comprimido",
                },
                dojTaxes = {
                    description = "Colete periodicamente impostos sobre veículos e casas de jogadores online.",
                    label = "Impostos sobre os activos",
                },
            },
            settingSections = {
                finance = "Finanças",
                courtroom = "Sala do Tribunal",
                registries = "Registo",
                courthouses = "Tribunais",
                general = "Geral",
                legalCodes = "Códigos legais",
                offences = "Catálogo fino",
                recordsAccess = "Acesso ao ficheiro de casos",
                tablet = "Comprimido",
                taxes = "Impostos",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registos de licenças",
                    description = "Escolha as licenças que o DOJ pode emitir. Cada entrada tem um registo próprio. Remover uma entrada não revoga as licenças existentes.",
                },
                dojRegistryAccess = {
                    ["label"] = "Acesso aos registos por ficheiro",
                    ["description"] = "Ajuste o acesso aos registos de config/registry. Uma lista vazia usa os valores dos ficheiros. Os campos e funções de servidor/cliente são editados nos ficheiros Lua.",
                },
                dojTreasuryJob = { label = "Emprego do tesouro", description = "Emprego cuja conta partilhada recebe cobranças e paga transferências." },
                dojFinanceJobs = { label = "Facções visíveis", description = "Chaves dos empregos registados no resumo de contas. O tesouro está sempre incluído." },
                dojFinanceLimit = { label = "Limite por operação", description = "Valor máximo por transferência ou cobrança." },
                dojFinePaymentMode = { label = "Pagamento de multas impostas", description = "Pagamento bancário direto ou fatura externa. Criar uma fatura não confirma o pagamento.", options = { bank = "Pagamento bancário", billing = "Fatura" } },
                dojFineSociety = { label = "Destinatário das multas", description = "Emprego cuja conta partilhada recebe multas impostas." },
                dojCourtroomBoardMove = {
                    label = "Mover tribunal conselho",
                    description = "A chave padrão para agarrar ou liberar uma placa móvel (por exemplo, F). Os jogadores podem substituí-la nas ligações de teclas FiveM. O movimento é temporário e é reiniciado após o reinício.",
                },
                dojCourtroomGavel = {
                    label = "Juiz Givel",
                    description = "Modelo de Gavel, acessório de mão, animação, som e padrões de greve. As alterações também se aplicam sem reiniciar.",
                },
                dojHearingParticipantRoles = {
                    label = "Funções dos participantes",
                    description = "Funções padrão: réu, testemunha, jurado, juiz. Adicione chaves de função minúsculas personalizadas aqui (até 24 caracteres, sublinhados permitidos). Mantenha o juiz. As funções personalizadas não concedem permissões de juiz ou júri.",
                },
                dojWarrantTemplateCodes = {
                    label = "Códigos de modelo de garantia",
                    description = "Códigos de modelo mostrados em PD Garantias após assinatura judicial e compartilhamento. Defaults: HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registros",
                    description = "Ative e nomeie os registros DOJ e, em seguida, defina o acesso e a autorização da profissão. As permissões de função DOJ existentes ainda se aplicam. Registros RP personalizados são gerenciados na base de profissões.",
                },
                dojCourthouseBlipCategory = {
                    description = "Etiqueta da categoria usada para blips do mapa do tribunal.",
                    label = "Blip categoria",
                },
                dojCourthouseBlipColor = {
                    description = "Map cor usada para tribunais.",
                    label = "Cor Blip",
                },
                dojCourthouseBlipScale = {
                    description = "Escala do mapa usada para os blips do tribunal.",
                    label = "Escala de Blip",
                },
                dojCourthouseBlipShortRange = {
                    description = "Apenas mostrar blips tribunal em curto alcance.",
                    label = "Curto alcance",
                },
                dojCourthouseBlipSprite = {
                    description = "Mapa sprite usado para tribunais.",
                    label = "Ícone do marcador",
                },
                dojLegalBookItem = {
                    description = "Item de inventário para uma edição de código legal fixa. O primeiro uso salva seu conteúdo e data; requer itens individuais com metadados.",
                    label = "Item de livro de código legal",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Mínimo de milissegundos entre solicitações de criação de livro legal.",
                    label = "Criar livro cooldown",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Mínimo de milissegundos entre solicitações de criação de revisão.",
                    label = "Criar a recarga da revisão",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Mínimo de milissegundos entre solicitações de exclusão de livro legal.",
                    label = "Apagar a recarga do livro",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Mínimo de milissegundos entre solicitações de exclusão de revisão.",
                    label = "Apagar a recarga da revisão",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Mínimo de milissegundos entre os pedidos de um livro legal.",
                    label = "Carregar livro cooldown",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Mínimo de milissegundos entre os pedidos para a lista de livros legais.",
                    label = "Carregar a recarga da biblioteca",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Tempo limite mínimo usado para grandes solicitações de documentos.",
                    label = "Tempo limite de solicitação em milissegundos",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Número máximo de caracteres permitidos em uma abreviatura de livro legal.",
                    label = "Comprimento máximo da abreviatura",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Número máximo de caracteres permitidos em um título de livro legal.",
                    label = "Duração máxima do título do livro",
                },
                dojLegalMaxContentBytes = {
                    description = "Tamanho máximo serializado de uma revisão completa do livro legal.",
                    label = "Tamanho máximo do conteúdo em bytes",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Duração máxima do título aceita ao importar parágrafos estruturados legados.",
                    label = "Comprimento máximo do título do parágrafo legado",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Número máximo de parágrafos estruturados aceitos durante as importações herdadas.",
                    label = "Parágrafos de legado máximo por livro",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Número máximo de caracteres permitidos em uma nota de revisão.",
                    label = "Duração máxima da nota de revisão",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Número máximo de nós de editor permitidos em uma revisão.",
                    label = "Máximos nós de rich-text",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Limite de largura de banda por jogador usado para transferir grandes documentos legais.",
                    label = "Taxa de transferência em bytes por segundo",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Mínimo de milissegundos entre pedidos de reordenação de livro legal.",
                    label = "Reordenar a recarga dos livros",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Mínimo de milissegundos entre atualizações de metadados de livros legais.",
                    label = "Atualizar a recarga do livro",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Número máximo de revisões carregadas ao abrir um livro legal.",
                    label = "Histórico de revisão visível",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Mínimo de milissegundos entre pré-visualizações da calculadora do lado do servidor.",
                    label = "Calculadora de recarga",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Mínimo de milissegundos entre pedidos de catálogo.",
                    label = "Carregar a recarga do catálogo",
                },
                dojOffenceMaxSelection = {
                    description = "Número máximo de infrações incluídas em uma pré-visualização da calculadora.",
                    label = "Seleção máxima",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Mínimo de milissegundos entre alterações no catálogo de infrações.",
                    label = "Catálogo editar recarga",
                },
                dojOffenceMirandaWarning = {
                    description = "Aviso personalizado mostrado no catálogo fino. Deixe vazio para usar o texto padrão no idioma selecionado.",
                    label = "Aviso de Miranda",
                },
                dojPrimaryColor = {
                    description = "Cor principal usada pelo grupo de profissão DOJ e tablet.",
                    label = "Cor primária",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Essas notas funcionam com a administração do tribunal e registros de registro.",
                    label = "Administração do Tribunal",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Essas notas funcionam com registros e decisões judiciais.",
                    label = "Poder Judiciário",
                },
                dojRecordsMappingVersion = {
                    description = "Revisão publicada do mapeamento de domínio de grade para registros. Um valor vazio mantém o acesso de registros desativado.",
                    label = "Versão de publicação",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Estas notas funcionam com os registos da acusação.",
                    label = "Procuradoria",
                },
                dojTabletRequireDuty = {
                    description = "Apenas os funcionários em serviço DOJ podem abrir o aplicativo de código legal.",
                    label = "Requerer o direito",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Moeda directa",
                },
                dojTaxHouseAmount = {
                    description = "Valor cobrado por cada casa de propriedade de um jogador.",
                    label = "Imposto por casa",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Segundos para esperar antes da primeira coleta quando nenhum ciclo fiscal anterior é armazenado.",
                    label = "Atraso inicial",
                },
                dojTaxIntervalMinutes = {
                    description = "Minutos entre os ciclos automáticos de cobrança de impostos sobre ativos.",
                    label = "Intervalo de recolha",
                },
                dojTaxNotifyPlayer = {
                    description = "Notificar os jogadores após uma cobrança direta, uma apresentação de conta ou fundos insuficientes.",
                    label = "Notificar jogadores",
                },
                dojTaxPaymentMode = {
                    description = "Use o saldo do banco/dinheiro selecionado diretamente ou envie uma conta da Sky Base Society por sujeito passivo e ciclo fiscal.",
                    label = "Método de pagamento",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Balanço bancário / monetário",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ profissão cuja conta da sociedade configurada recebe todas as receitas fiscais coletadas.",
                    label = "Destinatário DOJ profissão",
                },
                dojTaxVehicleAmount = {
                    description = "Montante cobrado por cada veículo de propriedade de um jogador.",
                    label = "Imposto por veículo",
                },
            },
            printers = {
                groups = {
                    paper = "Papel",
                    ink = "Tinta",
                    general = "Impressora",
                    printing = "Impressão e acesso",
                    placement = "Modelo e posição",
                },
                actions = {
                    selectExisting = "Selecionar impressora existente",
                    selectExistingHint = "Aponta para a impressora. Enter: selecionar · Esc: cancelar",
                    add = "Adicionar impressora",
                    open = "Inspecionar impressora",
                    place = "Posicionar impressora",
                    setPosition = "Usar posição atual",
                },
                classes = {
                    office = "Escritório",
                    professional = "Profissional",
                    standard = "Padrão",
                },
                description = "Configura impressoras, consumíveis, filas, acesso e posicionamento para este emprego.",
                fieldDescriptions = {
                    paperCapacity = "Quantidade máxima de papel para cada impressora deste emprego.",
                    paperEnabled = "Quando ativado, as impressoras deste emprego começam vazias e exigem o item de recarga comum.",
                    refillAmount = "Papel adicionado a uma impressora deste emprego ao usar o item de recarga comum.",
                    refillItem = "Nome interno do item do inventário consumido ao recarregar uma impressora deste emprego.",
                },
                fields = {
                    active = "Ativa",
                    class = "Classe",
                    heading = "Orientação",
                    id = "ID estável",
                    label = "Nome",
                    maxQueue = "Capacidade da fila",
                    minimumGrade = "Grau mínimo",
                    paperCapacity = "Capacidade de papel",
                    paperEnabled = "Exigir recargas de papel",
                    propModel = "Modelo do objeto",
                    refillAmount = "Papel por recarga",
                    refillItem = "Item de recarga",
                    deleteCopiesAfterRestart = "Eliminar cópias ao reiniciar",
                    deleteCopiesAfterRestartHint = "Eliminar as impressões não recolhidas ao reiniciar o serviço de impressão.",
                    spawnProp = "Criar objeto",
                    speed = "Velocidade de impressão",
                    status = "Estado",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Classe: {class}",
                    paper = "Papel: {paper} / {capacity}",
                    queue = "Fila: {queue} / {maxQueue}",
                    status = "Estado: {status}",
                    title = "Impressora",
                },
                messages = {
                    grade_too_low = "O teu grau é demasiado baixo para esta impressora.",
                    invalid_amount = "A quantidade de recarga é inválida.",
                    missingModel = "Seleciona um modelo de impressora válido antes de o posicionar.",
                    missing_refill_item = "Não tens o item de recarga configurado.",
                    no_refill_printer = "Não há nenhuma impressora acessível que use papel por perto.",
                    paper_capacity_exceeded = "A capacidade de papel seria excedida.",
                    paper_disabled = "O consumo de papel está desativado nesta impressora.",
                    paper_full = "A bandeja de papel desta impressora já está cheia.",
                    printer_inactive = "Esta impressora está desativada.",
                    printer_not_found = "A impressora já não existe.",
                    refill_cooldown = "Espera um momento antes de voltar a recarregar.",
                    refilled = "Foram adicionadas {amount} folhas. Stock: {paper} / {capacity}.",
                    too_far_away = "Aproxima-te da impressora.",
                    unavailable = "Impressora indisponível.",
                    wrong_job = "O teu emprego não permite usar esta impressora.",
                },
                settings = {
                    description = "Estas definições aplicam-se a todas as impressoras configuradas para este emprego.",
                    title = "Definições das impressoras do emprego",
                },
                statuses = {
                    maintenance = "Manutenção",
                    offline = "Sem ligação",
                    online = "Ligada",
                },
                title = "Impressoras",
                values = {
                    disabled = "Desativado",
                    enabled = "Ativado",
                    selectItem = "Selecionar item",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Configure DOJ profissões, locais do tribunal e o aplicativo de código legal.",
                    title = "Profissões do Departamento de Justiça",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Tribunal",
                    entryPluralLabel = "Tribunais",
                    label = "Tribunais",
                },
            },
            extensions = {
                invalidSelection = "Seleção inválida: {value}",
                trainingSettings = {
                    description = "Configure o acesso ao treinamento, inscrições, aprovações e planejamento de cursos para este trabalho.",
                    label = "Configuração do treino",
                },
            },
            locations = {
                stationPosition = "Localização / Blip no mapa",
                stationPositionHint = "Ponto principal deste local de trabalho. Se o blip no mapa estiver ativado em Trabalho → Blips, ele aparecerá aqui.",
                addCourtroom = "Adicionar Courtroom",
                courtroom = "Sala do Tribunal",
                courtroom_display_desk_27 = "Exibição de provas no tribunal – monitor de mesa de 27 polegadas",
                courtroom_display_wall_55 = "Exposição da evidência do tribunal – 55-inch parede TV",
                courtroom_display_wall_75 = "Exposição da evidência do tribunal – 75-inch parede TV",
                courtroom_display_wall_100 = "Exposição da evidência do tribunal – 100-inch parede TV",
                courtroom_display_wall_120 = "Exposição da evidência do tribunal – 120-inch parede TV",
                courtroom_display_wall_150 = "Exposição da evidência do tribunal – 150-inch parede TV",
                courtroom_display_board_93 = "Courtroom placa interativa – 150-polegada suporte móvel",
                courtroom_display_projection = "Exibição de evidência do tribunal – 4.5 m tela de projeção",
                courtroom_judge_mic = "Tribunal – microfone juiz",
                courtroom_jury_room = "Tribunal – sala do júri",
                courtroom_room = "Courtroom – público / centro de quartos",
                courtroom_witness = "Sala de audiências – stand de testemunhas",
                electionBooth = "Estande de votação",
                publicDisplayDesk27 = "Exibição pública – 27-inch Desk Monitor",
                publicDisplayTerminal43 = "Exibição Pública – Terminal de Piso de 43 polegadas",
                publicDisplayWall55 = "Exposição pública – 55-polegada parede TV",
                publicDisplayWall75 = "Exposição pública – 75-polegada parede TV",
                publicDisplayWall100 = "Exposição pública – 100-polegada parede TV",
                publicDisplayWall120 = "Exposição pública – 120-polegada parede TV",
                publicDisplayWall150 = "Exposição pública – 150-polegada parede TV",
                publicDisplayProjection = "Exibição pública – 4.5 m Tela de projeção",
                publicLegalCode = "Código Jurídico Público",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Mandados emitidos pelo tribunal",
                },
                dojAccess = {
                    label = "Acesso",
                },
                dojCourthouseBlip = {
                    label = "Mapa blip",
                },
                dojLegalBooks = {
                    label = "Livros",
                },
                dojLegalContentLimits = {
                    label = "Limites de conteúdo",
                },
                dojLegalItem = {
                    label = "Item de inventário",
                },
                dojLegalRateLimits = {
                    label = "Limites de taxa",
                },
                dojLegalRevisions = {
                    label = "Revisões",
                },
                dojLegalTransfers = {
                    label = "Documentos grandes",
                },
                dojOffenceCalculation = {
                    label = "Calculadora",
                },
                dojOffenceRateLimits = {
                    label = "Limites de taxa",
                },
                dojOffenceMiranda = {
                    label = "Orientação do catálogo",
                },
                dojOffenceSource = {
                    label = "Fonte do catálogo",
                },
                dojRecordsGradeBindings = {
                    description = "Atribua cada grau DOJ disponível a exatamente um domínio de registros e, em seguida, publique o mapeamento.",
                    label = "Domínios de notas e registros",
                },
                dojTaxPayment = {
                    label = "Pagamento",
                },
                dojTaxRates = {
                    label = "Tarifas",
                },
                dojTaxSchedule = {
                    label = "Agendar",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Contratos notariais",
                    powers_of_attorney = "Poderes do advogado",
                    name_changes = "Alterações de nome",
                    company_registry = "Registro da empresa",
                    association_registry = "Registro da associação",
                    licensing = "Licenciamento",
                    administrative_decisions = "Decisões administrativas",
                    administrative_objections = "Objecções administrativas",
                },
            },
            gavel = {
                enabled = "Ativado",
                cooldown = "Descarga de gatilho (ms)",
                defaultPreset = "Padrão de ataque padrão",
                prop = "Objeto do martelo do juiz",
                model = "Nome do modelo",
                bone = "Osso da mão ID",
                offset = "Deslocamento (metros)",
                rotation = "Rotação (graus)",
                presets = "Padrões de ataque",
                single = "Greve única",
                double = "Golpe duplo",
                strikes = "Número de greves",
                interval = "Intervalo de strike (ms)",
                impact = "Atraso de som (ms)",
                audio = "Som",
                asset = "Ativo de áudio",
                volume = "Volume",
                animation = "Animação",
                dict = "Dicionário de animação",
                clip = "Nome da animação",
                duration = "Duração do movimento (ms)",
                flag = "Bandeiras de animação",
                x = "X",
                y = "Y",
                z = "Z",
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
        },
    },
}
