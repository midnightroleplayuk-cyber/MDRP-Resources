--[[
    apex_strategy, shared/config.lua
    ═══════════════════════════════════════════════════════════════
    Quadro de estratégia para a polícia.

    Uma prop, dois modos:
      · draw → quadro branco normal, desenho livre
      · map  → mapa de Los Santos por baixo, desenho por cima

    O ecrã é desenhado com o mesmo pipeline da TV do dyno do apex_obd
    (DUI → scaleform → DrawScaleformMovie_3dNonAdditive). Os números
    de calibração já estão feitos, ver Config.render e Config.boards.
]]

Config = Config or {}

-- Comandos de desenvolvimento (/wb, /wbcal). Podes desligar em
-- produção: o quadro em si continua a funcionar.
Config.debug = false

-- Permissão ACE para os comandos de admin (colocar/apagar quadros).
-- false = qualquer um com Config.debug. Para trancar:
--     add_ace group.admin apex_strategy.admin allow
Config.ace = true

-- 'auto' | 'esx' | 'qb' | 'qbx'
Config.framework = 'qbx'

-- Língua. Os ficheiros estão em locales/ e são declarados no
-- fxmanifest. 'en' é a base: o que faltar numa tradução aparece em
-- inglês em vez de aparecer vazio.
Config.locale = 'en'

-- ═══════════════════════════════════════════════════════════════
--  QUEM PODE USAR
-- ═══════════════════════════════════════════════════════════════
Config.access = {
    -- Jobs que podem abrir e escrever no quadro.
    jobs = {
        police   = true,
        ambulance  = true,
    },

    -- Grade a partir do qual se pode apagar o quadro todo, trancar,
    -- ou mexer no que os outros escreveram.
    supervisorGrade = 3,

    -- Se true, quem não tem job na lista pode ABRIR o quadro mas só
    -- vê, não escreve. Bom para briefings com civis presentes.
    spectatorsAllowed = false,
}

-- ═══════════════════════════════════════════════════════════════
--  RENDER DO ECRÃ NA PROP
-- ═══════════════════════════════════════════════════════════════
Config.render = {
    -- 'scaleform' → método da TV do dyno (calibrado, é o que usamos)
    -- 'poly'      → DrawSpritePoly nos 4 cantos exactos (régua)
    method = 'scaleform',

    -- ── CONSTANTES DO SCALEFORM ───────────────────────────────
    -- Quantos metros vale cada unidade de screen.x / screen.z. É uma
    -- propriedade do .gfx, não do quadro, por isso serve para
    -- qualquer prop futura.
    --
    -- Calibrado in-game a 26/07/2026 em DOIS quadros independentes,
    -- com orientações diferentes (face -Y sem rotação, face +X a -90):
    --      whiteboard2   X 36.2328   Z 8.1611   → aspect 4.4397
    --      whiteboard1   X 36.9614   Z 8.3282   → aspect 4.4381
    -- Os aspects batem a 0.04%, o que confirma duas coisas: o
    -- quadro-base do .gfx é MESMO achatado 4.44:1 (não era erro de
    -- calibração), e a escala não depende da prop nem do rotZOffset.
    metersPerUnit = { x = 36.5971, z = 8.2447 },

    -- ONDE é que o ponto (dx,dy,dz) cai dentro do rectângulo
    -- desenhado. NÃO é o centro: é o canto superior esquerdo, visto
    -- de frente para o quadro.
    anchor = 'topleft',

    -- Quanto o ecrã salta para a frente da face (m).
    push = 0.02,

    -- Distância a que o ecrã deixa de ser desenhado. O DUI também é
    -- destruído quando ninguém está por perto, para não gastar
    -- memória com quadros do outro lado do mapa.
    drawDistance   = 30.0,
    streamDistance = 60.0,

    -- Raio usado para encontrar o quadro mais próximo.
    pickupRadius = 12.0,

    -- Distância máxima do raycast ao colocar a prop.
    placeDistance = 6.0,

    -- Quantos quadros podem ter ecrã montado ao mesmo tempo. Cada um
    -- gasta um DUI + um scaleform.
    maxLiveScreens = 3,

    -- Scaleforms que este resource traz em stream/. São cópias do
    -- television_scaleform do rcore (o mesmo que o apex_obd usa), só
    -- renomeadas para não colidirem com mais nada no servidor.
    scaleforms = {
        'apex_strategy_sf_1',
        'apex_strategy_sf_2',
        'apex_strategy_sf_3',
        'apex_strategy_sf_4',
    },

    -- Se os de cima não carregarem (os .gfx só entram depois de um
    -- restart completo), cai para estes, que já estão no ar via
    -- apex_obd / tv_scaleform.
    scaleformsFallback = {
        'television_scaleform_5',
        'television_scaleform_6',
        'television_scaleform_7',
        'television_scaleform_8',
    },
}

-- ═══════════════════════════════════════════════════════════════
--  QUADROS
-- ═══════════════════════════════════════════════════════════════
--  panel  → medida REAL do painel branco, em metros, no espaço local
--           da prop. Foi lido da malha do .glb de origem, não mexas.
--  screen → calibração do scaleform (feita, ver /wbcal para reafinar)
--  dui    → resolução da página; segue o aspect do painel para o
--           desenho não sair esticado.
Config.boards = {

    -- ─────────────────────────────────────────────────────────────
    --  QUADRO DE PÉ COM RODAS  (cavalete, 2.45 m de altura)
    --      Painel medido: 1.946 × 1.180 m · aspect 1.649
    --      A largura corre ao longo do LOCAL +Y e a face olha para o
    --      LOCAL +X, daí o rotZOffset a -90. (Se algum dia entrar
    --      outra prop, não assumas a mesma orientação: mede-a.)
    -- ─────────────────────────────────────────────────────────────
    ['apx_whiteboard2'] = {
        label = 'Quadro de estratégia',

        panel = {
            cx = 0.0000, cy = 0.0000, cz = 1.8030,
            w  = 1.9460, h  = 1.1800,
            normal = '+x',
            -- tem rodas e pés: fica sempre no chão, nunca na parede.
            wallMount = false,
        },

        -- CALIBRADO in-game a 26/07/2026.
        screen = {
            x = 0.0537, y = 0.0310, z = 0.1446,
            dx = 0.0200, dy = -0.9800, dz = 2.4130,
            rotX = 0.0000, rotY = 0.0000, rotZOffset = -90.0000,
        },

        dui = { w = 1920, h = 1164 },
    },
}

-- Modelos que já não fazem parte do script mas podem ter ficado
-- pousados no mundo (o /wbclear também os apanha).
Config.cleanupModels = {
    'apx_whiteboard1',
}

-- ═══════════════════════════════════════════════════════════════
--  MAPA
-- ═══════════════════════════════════════════════════════════════
--  O mapa é desenhado por tiles directamente num canvas, sem
--  Leaflet. A projecção é a MESMA do apex_bossmenu, para os dois
--  falarem a mesma linguagem de coordenadas:
--
--      px = (scaleX * worldX + originX) * 2^zoom
--      py = (scaleY * worldY + originY) * 2^zoom      (scaleY < 0)
--
--  Cada tile tem 256 px: tileX = floor(px / 256).
Config.map = {
    tileUrl   = 'https://www.gtamap.xyz/mapStyles/styleSatelite/{z}/{x}/{y}.jpg',
    tileSize  = 256,

    -- Zoom com tiles reais. Acima disto os tiles são esticados -
    -- fica menos nítido mas permite enquadrar uma rua.
    minZoom       = 2,
    maxNativeZoom = 5,
    maxZoom       = 8.0,

    -- Projecção (igual à do apex_bossmenu).
    originX = 117.3,
    originY = 172.8,
    scaleX  = 0.02072,
    scaleY  = -0.0205,

    -- Enquadramento inicial de um quadro novo: Los Santos centro.
    defaultView = { cx = 200.0, cy = -900.0, zoom = 4.2 },

    -- Atalhos de enquadramento na barra do editor. cx/cy são
    -- coordenadas do mundo; zoom maior = mais perto.
    presets = {
        { id = 'all',      label = 'All',  cx =  -300.0, cy =  1200.0, zoom = 2.6 },
        { id = 'city',     label = 'Midnight',   cx =   200.0, cy =  -900.0, zoom = 4.2 },
        { id = 'downtown', label = 'Downtown',     cx =   130.0, cy =  -700.0, zoom = 5.2 },
        { id = 'vinewood', label = 'Vinewood',     cx =   250.0, cy =   250.0, zoom = 4.8 },
        { id = 'port',     label = 'Port',        cx =   900.0, cy = -2900.0, zoom = 4.6 },
        { id = 'airport',  label = 'Airport',    cx = -1050.0, cy = -2700.0, zoom = 4.6 },
        { id = 'sandy',    label = 'Sandy Shores', cx =  1900.0, cy =  3700.0, zoom = 4.4 },
        { id = 'paleto',   label = 'Paleto Bay',   cx =   -80.0, cy =  6300.0, zoom = 4.6 },
    },

    -- Marcar no mapa os agentes do mesmo job, ao vivo.
    liveUnits = {
        enabled     = true,
        refreshMs   = 3000,
        -- Só mostra quem tem um dos jobs de Config.access.jobs.
        sameJobOnly = false,
    },
}

-- ═══════════════════════════════════════════════════════════════
--  FERRAMENTAS DE DESENHO
-- ═══════════════════════════════════════════════════════════════
Config.tools = {
    -- Paleta dos marcadores. A primeira é a que fica escolhida.
    colors = {
        '#1F5EFF',  -- azul Apex
        '#E5564B',  -- vermelho
        '#34C77B',  -- verde
        '#E5A93C',  -- amarelo
        '#A66DF0',  -- roxo
        '#4E9CE5',  -- azul claro
        '#F4F4F5',  -- branco
        '#131314',  -- preto
    },

    -- Espessuras do traço, em px do canvas de 1920. O quadro tem 1.95
    -- m de largura, por isso 1 px ≈ 1 mm no quadro real, 6 px eram
    -- 6 mm e não se viam de longe. Estes valores lêem-se do outro
    -- lado da sala.
    widths = { 6, 12, 22, 38 },

    -- Tamanhos de texto, em px do canvas de 1920 (≈ mm no quadro).
    textSizes = { 44, 72, 110, 160 },

    -- Marcadores tácticos. O `pic` escolhe o pictograma desenhado no
    -- canvas (vectorial, sem depender de fontes ou de imagens) e o
    -- `cat` agrupa-os no painel e decide a forma do fundo:
    --   Unidades/Pessoas → redondo · Táctico → losango · Locais → quadrado
    icons = {
        -- ── UNIDADES ────────────────────────────────────────────
        { id = 'patrol',   label = 'Vehicle',          cat = 'Unidades', pic = 'car',      color = '#1F5EFF' },
        { id = 'unmarked', label = 'Unmarked',         cat = 'Unidades', pic = 'car',      color = '#4E9CE5' },
        { id = 'van',      label = 'Van',              cat = 'Unidades', pic = 'van',      color = '#1F5EFF' },
        { id = 'moto',     label = 'Motorcycle',       cat = 'Unidades', pic = 'moto',     color = '#4E9CE5' },
        { id = 'heli',     label = 'Helicopter',       cat = 'Unidades', pic = 'heli',     color = '#A66DF0' },
        { id = 'boat',     label = 'Boat',             cat = 'Unidades', pic = 'boat',     color = '#4E9CE5' },
        { id = 'k9',       label = 'K-9 Unit',         cat = 'Unidades', pic = 'k9',       color = '#E5A93C' },
        { id = 'swat',     label = 'Firearms',         cat = 'Unidades', pic = 'shield',   color = '#232325' },
        { id = 'medic',    label = 'Medical',          cat = 'Unidades', pic = 'cross',    color = '#4b81e5' },
        { id = 'fire',     label = 'Fire',             cat = 'Unidades', pic = 'flame',    color = '#e53c3c' },

        -- ── PESSOAS ─────────────────────────────────────────────
        { id = 'officer',  label = 'Officer',            cat = 'Pessoas',  pic = 'person',   color = '#1F5EFF' },
        { id = 'suspect',  label = 'Suspect',            cat = 'Pessoas',  pic = 'person',   color = '#E5564B' },
        { id = 'armed',    label = 'Armed Suspect',      cat = 'Pessoas',  pic = 'armed',    color = '#E5564B' },
        { id = 'hostage',  label = 'Hostage',            cat = 'Pessoas',  pic = 'person',   color = '#E5A93C' },
        { id = 'witness',  label = 'Witness',            cat = 'Pessoas',  pic = 'person',   color = '#34C77B' },
        { id = 'down',     label = 'Injured / Killed',   cat = 'Pessoas',  pic = 'down',     color = '#A66DF0' },
        { id = 'sniper',   label = 'Sniper',             cat = 'Pessoas',  pic = 'scope',    color = '#A66DF0' },

        -- ── TÁCTICO ─────────────────────────────────────────────
        { id = 'entry',    label = 'Entry',         cat = 'Táctico',  pic = 'door',     color = '#34C77B' },
        { id = 'exit',     label = 'Exit',          cat = 'Táctico',  pic = 'exit',     color = '#E5A93C' },
        { id = 'cover',    label = 'Cover',         cat = 'Táctico',  pic = 'chevron',  color = '#4E9CE5' },
        { id = 'block',    label = 'Block',         cat = 'Táctico',  pic = 'barrier',  color = '#E5A93C' },
        { id = 'spikes',   label = 'Spikes',        cat = 'Táctico',  pic = 'spikes',   color = '#E5A93C' },
        { id = 'perim',    label = 'Perimeter',     cat = 'Táctico',  pic = 'perim',    color = '#4E9CE5' },
        { id = 'arrest',   label = 'Arrest',        cat = 'Táctico',  pic = 'cuffs',    color = '#1F5EFF' },
        { id = 'danger',   label = 'Danger',        cat = 'Táctico',  pic = 'warn',     color = '#E5564B' },
        { id = 'target',   label = 'Target',        cat = 'Táctico',  pic = 'target',   color = '#E5564B' },

        -- ── SEQUÊNCIA ───────────────────────────────────────────
        -- A etiqueta destes é o número. Servem para numerar os passos
        -- de uma entrada: 1 arrombar, 2 cobrir, 3 avançar.
        { id = 'step',     label = 'Step (Numbered)',  cat = 'Táctico',  pic = 'number',   color = '#1F5EFF' },

        -- ── LOCAIS ──────────────────────────────────────────────
        { id = 'hq',       label = 'HQ',                cat = 'Locais',   pic = 'building', color = '#1F5EFF' },
        { id = 'stage',    label = 'Stage',             cat = 'Locais',   pic = 'flag',     color = '#34C77B' },
        { id = 'camera',   label = 'Camera',            cat = 'Locais',   pic = 'camera',   color = '#4E9CE5' },
        { id = 'evidence', label = 'Evidence',          cat = 'Locais',   pic = 'evidence', color = '#A66DF0' },
        { id = 'radio',    label = 'Radio',             cat = 'Locais',   pic = 'radio',    color = '#34C77B' },
    },

    -- Tecto de segurança: um quadro com traços a mais mata o
    -- desempenho do DUI e engorda a linha na base de dados. O editor
    -- mostra o contador no canto, para não se chegar aqui às cegas.
    maxItems       = 1500,
    maxPointsPerStroke = 400,
}

-- ═══════════════════════════════════════════════════════════════
--  INTERACÇÃO
-- ═══════════════════════════════════════════════════════════════
Config.interact = {
    -- Como é que o jogador abre o quadro:
    --   'auto'    escolhe sozinho o melhor que estiver instalado
    --             (ox_target > qb-target > ox_lib TextUI > texto 3D)
    --   'target'  ox_target ou qb-target
    --   'textui'  ox_lib:showTextUI + tecla
    --   'text3d'  texto desenhado no mundo + tecla (sem dependências)
    --   'none'    nada; abre-se só por /quadro ou pelo teu próprio
    --             script, via exports.apex_strategy:OpenBoard(id)
    mode = 'target',

    key      = 38,           -- E
    keyLabel = 'E',          -- o que aparece escrito no aviso
    distance = 2.2,          -- a que distância aparece

    -- ox_target / qb-target
    icon  = 'fa-solid fa-chalkboard',
    label = nil,             -- nil = usa a tradução (locale interact_open)

    -- ox_lib TextUI
    textui = {
        position = 'left-center',   -- 'right-center' | 'top-center' | 'left-center'
        icon     = 'chalkboard',
    },

    -- Texto 3D (o que não precisa de nada instalado)
    text3d = {
        scale  = 0.35,
        offset = 1.10,       -- altura acima da origem da prop
    },
}

-- ═══════════════════════════════════════════════════════════════
--  ANIMAÇÃO
-- ═══════════════════════════════════════════════════════════════
--  Enquanto o quadro está aberto, o personagem fica a escrever. Quem
--  passa ao lado vê alguém a trabalhar no quadro, não uma estátua.
Config.animation = {
    enabled = true,

    -- Vira-se de frente para o quadro antes de começar.
    faceBoard = true,

    dict = 'amb@world_human_clipboard@male@base',
    name = 'base',
    -- 1 = repetir · 16 = manter a posição final · 49 = repetir só da
    -- cintura para cima (deixa andar). Junta com + se quiseres mais.
    flag = 49,
    blendIn  = 4.0,
    blendOut = 2.0,

    -- Objecto na mão. prop = false tira-o.
    prop = {
        model  = 'p_amb_clipboard_01',
        bone   = 60309,                        -- SKEL_R_Hand
        offset = { x = 0.16, y = 0.08, z = 0.02 },
        rot    = { x = -130.0, y = -50.0, z = 0.0 },
    },
}

-- ═══════════════════════════════════════════════════════════════
--  PERSISTÊNCIA
-- ═══════════════════════════════════════════════════════════════
Config.persistence = {
    -- Grava o conteúdo do quadro na base de dados. Com false, o
    -- quadro vive só em memória do servidor e perde-se no restart.
    saveToDatabase = true,

    -- O conteúdo é gravado em lote, não a cada traço.
    autosaveMs = 15000,

    -- Quadros pousados no mundo por admins (persistem no restart).
    persistPlacements = true,
}

Config.theme = {
    brand     = '#1F5EFF',
    brandDark = '#0048F0',
    bg        = '#0A0A0B',
    bgCard    = '#1A1A1B',
    bgRaised  = '#232325',
    bgSidebar = '#131314',
    border    = '#1F1F21',
    borderHi  = '#2A2A2D',
    text      = '#F4F4F5',
    textSub   = 'rgba(244,244,245,.55)',
    info      = '#4E9CE5',
    success   = '#34C77B',
    warning   = '#E5A93C',
    error     = '#E5564B',
}

-- ═══════════════════════════════════════════════════════════════
--  POSICIONAMENTO DA PROP  (admin)
-- ═══════════════════════════════════════════════════════════════
Config.place = {
    rotStep = 5.0,
    rotFast = 45.0,
    rotFine = 1.0,
    scrollDebounce = 120,   -- ms; um entalhe da roda marca vários frames

    heightStep = 0.05,      -- Shift ×5 · Alt ÷5
    reach      = 6.0,
    reachStep  = 0.5,
    reachMin   = 1.0,
    reachMax   = 20.0,

    -- Encostar automaticamente a paredes (só nas props com
    -- panel.wallMount = true). Nenhuma prop actual o usa; a lógica
    -- fica porque é genérica e serve se voltar um quadro de parede.
    wallSnap = true,
}

-- ═══════════════════════════════════════════════════════════════
--  CALIBRADOR  (/wbcal)
-- ═══════════════════════════════════════════════════════════════
Config.calibrate = {
    steps = {
        { label = 'fine',   pos = 0.0010, size = 0.0005, rot = 0.5  },
        { label = 'normal', pos = 0.0100, size = 0.0050, rot = 5.0  },
        { label = 'thick', pos = 0.0500, size = 0.0250, rot = 15.0 },
    },
    defaultStep = 2,
    zoomStep    = 0.01,
    guide       = true,
}
