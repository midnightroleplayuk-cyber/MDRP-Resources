--[[
    Apex Minimap Studio — Configuration
    ────────────────────────────────────────────────────────────
    Everything an owner may want to touch lives here. The file
    stays open source even in an escrowed build.
]]

Config = {}

-- ─── General ────────────────────────────────────────────────

Config.locale  = 'en'            -- 'en' | 'pt' | any file in locales/
Config.debug   = false           -- verbose F8/console logging

Config.command = 'minimapstudio' -- /minimapstudio toggles the studio
Config.keybind = ''              -- e.g. 'F7' — '' disables the keybind

-- ─── Access control ─────────────────────────────────────────
-- mode 'ace'      → server.cfg:  add_ace group.admin apex.minimap allow
-- mode 'jobs'     → jobs table below (framework auto-detected)
-- mode 'everyone' → no gate (open testing)

-- CINCO MÉTODOS, cada um com o seu interruptor. SOMAM-SE: um builder
-- entra assim que o PRIMEIRO método ligado disser que sim, e ligar um
-- método nunca tira o acesso a quem já o tinha. De origem só o `ace` vem
-- ligado. Tudo é verificado do lado do SERVIDOR — ao abrir e outra vez em
-- cada gravação, export, live e transferência. O cliente nunca é
-- acreditado. Trancado de fora? Corre  /minimapstudio_access  em jogo.
Config.access = {
    -- 1. Sem restrição. Só para servidores de desenvolvimento: quem
    --    conseguir escrever o comando fica com o estúdio inteiro.
    everyone = { enabled = false },

    -- 2. Permissão ace (o método por omissão).
    --      add_ace group.admin apex.minimap allow
    --      add_principal identifier.license:AQUI_A_TUA_LICENSE group.admin
    --    ⚠ Um add_ace no server.cfg só entra em vigor no ARRANQUE do
    --    servidor — reiniciar o recurso não chega. Para aplicar já, cola
    --    as duas linhas na consola do servidor.
    --    ⚠ O prefixo license: não se escreve duas vezes.
    ace = {
        enabled = true,
        -- basta UMA delas; acrescenta as tuas para separar equipas
        permissions = { 'apex.minimap' },
        -- aceita também as aces que as frameworks e o txAdmin já dão ao
        -- dono, para uma instalação nova não dizer "não" a quem a acabou
        -- de instalar. false = exige exatamente as permissions de cima.
        acceptOwnerAces = true,
        ownerAces = { 'command', 'txadmin.everything', 'group.admin' },
    },

    -- 3. Cargo da framework. Cada nome é procurado em quatro sítios
    --    (ESX users.group, QBCore HasPermission, QBox HasPermission e as
    --    aces normais), por isso funciona até sem framework nenhuma.
    groups = {
        enabled = false,
        list = { 'owner', 'god', 'superadmin', 'admin' },
    },

    -- 4. Emprego com grade mínimo (nome = grade). Precisa de framework.
    jobs = {
        enabled = false,
        list = {
            -- mapper = 0,
            -- police = 3,
        },
    },

    -- 5. Lista escolhida à mão. Não precisa de framework nem de ace, e é
    --    por isso o caminho de emergência quando as permissões de um
    --    servidor estão partidas.
    identifiers = {
        enabled = false,
        list = {
            -- 'license:c14af569131376631fcc98a32c649cf5cbf5ceeb',
            -- 'fivem:11750483',
            -- 'discord:123456789012345678',
        },
    },

    -- 'auto' procura es_extended, qbx_core e qb-core por essa ordem.
    framework = 'auto',
}

-- ─── Assistente de AI ───────────────────────────────────────
-- Um assistente de apoio dentro do estúdio: como faço X, porque é que
-- isto não acontece, o que é o modo Live. Responde sobre ESTE estúdio e
-- sobre desenhar minimapas, e recusa o resto. Vai com um retrato do que
-- está a acontecer (ferramenta, camadas, mapa, postais, zoom), por isso
-- consegue responder "não tens nenhuma camada selecionada" em vez de um
-- parágrafo genérico. As sugestões viram botões que abrem o separador ou
-- escolhem a ferramenta — nunca mexem no mapa.
--
-- ⚠ A CHAVE NÃO SE PÕE AQUI. Este ficheiro é `shared_script`: vai para
-- todos os clientes. Põe-na em `server/ai_key.lua`, que só corre no
-- servidor. O campo abaixo existe porque funciona, não porque é seguro.
Config.ai = {
    enabled = true,

    -- 'gemini' → Google Gemini (o gratuito chega bem para chat)
    -- 'openai' → OpenAI chat completions
    -- 'custom' → qualquer endpoint compatível com /chat/completions
    provider = 'gemini',

    -- ⚠ expõe a chave a todos os clientes — preferir server/ai_key.lua
    apiKey = '',

    gemini = { model = 'gemini-flash-latest' },
    openai = { model = 'gpt-4o-mini' },
    custom = { url = '', model = '', authHeader = 'Authorization', authPrefix = 'Bearer ' },

    timeoutMs = 45000,     -- teto antes de desistir do pedido
    cooldownSeconds = 3,   -- por jogador, entre perguntas
    maxPerHour = 60,       -- por jogador
    historyTurns = 6,      -- turnos de conversa enviados como contexto
}

-- ─── Aparência (Apex UI design system) ──────────────────────
-- O estúdio deriva a paleta INTEIRA de três cores (acento, canvas
-- e texto) — a rampa do acento sai por HSL e a tinta por contraste
-- WCAG real, por isso qualquer acento funciona. Isto é só o ponto
-- de partida: cada jogador pode mudar em /minimapstudiosettings
-- (guardado em KVP) e um admin pode forçar um tema para todos.
Config.theme = {
    brand     = '#1F5EFF',   -- acento único
    brandDark = '#0048F0',   -- hover/pressed de superfícies sólidas
    bg        = '#0A0A0B',   -- canvas
    bgSidebar = '#131314',   -- rails, cabeçalhos, rodapés
    bgCard    = '#1A1A1B',   -- cartões
    bgRaised  = '#232325',   -- inputs, botões neutros, elevado
    border    = '#1F1F21',   -- hairline padrão
    borderHi  = '#2A2A2D',   -- hairline forte
    text      = '#F4F4F5',
    textSub   = 'rgba(244,244,245,.55)',
    info      = '#4E9CE5',
    success   = '#34C77B',
    warning   = '#E5A93C',
    error     = '#E5564B',

    -- Valores de partida da janela de aparência (o jogador manda).
    radius = 8,      -- raio do cartão; a escala toda deriva daqui
    glow   = 100,    -- intensidade do glow do acento, em %
    veil   = 0,      -- véu do acento nas margens da tela, em %
    anim   = true,   -- animações de entrada e transições
    mirror = false,  -- true = dock do lado esquerdo
}

-- ─── Map atlas ──────────────────────────────────────────────
-- The GTA minimap raster is 6 streamed tiles named
-- minimap_<row>_<col> (3 rows × 2 cols) plus byte-identical
-- minimap_sea_<row>_<col> variants. tileSize is the editor's
-- WORKING resolution per tile — the export rebuilds each tile at
-- its base map's native size (2048 or 4096) automatically.

Config.atlas = {
    rows     = 3,
    cols     = 2,
    tileSize = 2048,
}

-- ─── Base maps ──────────────────────────────────────────────
-- Which base map the studio opens on. Must be a folder that exists
-- under templates/<id>/ (and html/tiles/<id>/). The full picker is
-- built from html/tiles/maps.json (generated by extract_tiles.js);
-- see MAP_META in tools/extract_tiles.js to rename/reorder them.
Config.defaultMap = 'original'

-- World-space rectangle the atlas covers. This is NOT cosmetic: it is
-- what turns world coordinates into map pixels, so it decides where the
-- postal codes land, where a blip you place ends up in game, and which
-- area a map extension covers.
--
-- MEDIDO, não estimado (2026-08-04): os valores antigos eram um palpite
-- (8440 × 12440) e punham o mapa comprimido ~6% em X e ~8% em Y — os
-- postais ficavam ~125 px ao lado. Estes saíram de um ajuste por mínimos
-- quadrados a 11 códigos postais lidos nos tiles de um mapa gerado pela
-- fivem-tools (onde os números estão pintados): erro máximo 1,1 px no
-- espaço de edição, com escala isotrópica (píxeis quadrados), como tem
-- de ser. Só mexer aqui com uma medição melhor.
Config.worldBounds = {
    left   = -4137.4,   -- world X at the atlas' left edge
    top    =  8397.6,   -- world Y at the atlas' top edge
    right  =  4860.5,   -- world X at the right edge
    bottom = -5099.4,   -- world Y at the bottom edge
}

-- ─── Live preview / Live on Server ─────────────────────────
Config.live = {
    -- Persist "Live on Server" tiles to data/live.json so they
    -- survive a server restart and apply to players who join later.
    persist = true,
    -- Runtime texture dictionary used for the replacements.
    txd = 'apex_minimap_live',
}

-- ─── Editor ─────────────────────────────────────────────────
Config.editor = {
    maxLayers      = 40,
    historyLimit   = 25,       -- undo steps
    frameThrottleMs = 120,     -- live-preview repaint throttle
}

-- ─── Export ─────────────────────────────────────────────────
Config.export = {
    -- Default name for the generated resource (editable in the UI).
    defaultName = 'my_minimap',
    -- Also duplicate each tile as minimap_sea_<r>_<c>.ytd (the
    -- vanilla pack does; keep true unless you know better).
    seaVariants = true,
}

-- ─── Limits ─────────────────────────────────────────────────
Config.limits = {
    maxTransferBytes = 24 * 1024 * 1024,  -- latent-event payload cap
    maxProjects      = 30,                -- per identifier
    saveCooldownMs   = 3000,
}
