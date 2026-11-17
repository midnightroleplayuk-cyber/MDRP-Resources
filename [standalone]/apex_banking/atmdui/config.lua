--[[
    Apex Banking — DUI ATM config
    ────────────────────────────────────────────────────────────
    The realistic ATM: the terminal UI is rendered straight onto the
    ATM prop's own screen texture (DUI), a scripted camera eases in
    front of the machine and the player aims at the PHYSICAL side
    buttons and keypad of the prop with the mouse.

    Money moves through apex_banking's own ledger (Accounts / Transfer),
    so every ATM operation shows up in the bank app's history, honours
    frozen accounts and applies Config.fees / Config.limits.

    Toggle the whole thing with Config.useDuiAtm (shared/config.lua).
    Line up the physical buttons per model with /apexatmcalibrate.
]]

AtmuiConfig = {}

AtmuiConfig.Debug = false -- Enable debug prints

-- ATM Models that will have DUI applied
AtmuiConfig.ATMModels = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

-- Prop positioning by ATM Model (X = Left/Right, Y = Forward/Back, Z = Up/Down)
AtmuiConfig.PropOffsets = {
    ['prop_fleeca_atm'] = {
        dispense = { x = -0.11, startY = 0.15, endY = -0.15, z = 0.95 },
        deposit = { x = -0.10, startY = -0.15, endY = 0.15, z = 0.95 },
        card = { x = 0.25, startY = -0.10, endY = 0.20, z = 1.2 },
        createCard = { x = 0.25, startY = 0.20, endY = -0.10, z = 1.2 }
    },
    ['prop_atm_01'] = {
        dispense = { x = -0.05, startY = -0.20, endY = -0.35, z = 0.75 },
        deposit = { x = -0.05, startY = -0.35, endY = -0.20, z = 0.95 },
        card = { x = 0.20, startY = -0.25, endY = 0.05, z = 1.12 },
        createCard = { x = 0.20, startY = 0.05, endY = -0.25, z = 1.12 }
    },
    ['prop_atm_02'] = {
        dispense = { x = -0.11, startY = 0.15, endY = -0.15, z = 0.95 },
        deposit = { x = -0.10, startY = -0.15, endY = 0.15, z = 0.95 },
        card = { x = 0.25, startY = -0.10, endY = 0.20, z = 1.20 },
        createCard = { x = 0.25, startY = 0.20, endY = -0.10, z = 1.20 }
    },
    ['prop_atm_03'] = {
        dispense = { x = -0.11, startY = 0.15, endY = -0.15, z = 0.95 },
        deposit = { x = -0.10, startY = -0.15, endY = 0.15, z = 0.95 },
        card = { x = 0.25, startY = -0.10, endY = 0.20, z = 1.2 },
        createCard = { x = 0.25, startY = 0.20, endY = -0.10, z = 1.2 }
    }
}

-- DUI Settings (the screen texture resolution)
AtmuiConfig.DUI = {
    width = 1326,
    height = 1004,
}

-- Idle screens: every ATM prop in the world shows a live welcome screen.
-- ONE small DUI serves every model — the screen is DRAWN in 3D over the
-- glass (see ScreenQuad), so the prop's own textures (signage included)
-- stay untouched.
AtmuiConfig.Idle = {
    enabled = true,
    width = 664,            -- half the session resolution: the idle screen is
    height = 502,           -- static, so it costs less and still reads clean
    distance = 90.0,        -- create the idle screen once an ATM is this close
    scanInterval = 3000,    -- ms between sweeps until it exists
}

-- How the DUI reaches the prop: NOT by replacing a texture (on the Fleeca
-- that texture also carries the signage boxes, which then went black) but
-- as a textured quad drawn over the screen glass every frame, sampling
-- only the calibrated frame of the page. The quad's corners are derived
-- from the side buttons (they sit at the glass edge); a per-model
-- `quad = { l, r, zt, zb, yt, yb }` under ScreenLayout, or one saved with
-- /apexatmquad, overrides that.
AtmuiConfig.ScreenQuad = {
    range    = 45.0,        -- draw screens on ATMs within this distance
    depth    = 0.008,       -- metres the quad floats in front of the glass
    front    = -1,          -- sign of the prop's Y axis that faces the player
    twoSided = true,        -- also draw the back winding (never invisible)
    scanInterval = 1000,    -- ms between nearby-ATM sweeps
}

-- Camera Settings
AtmuiConfig.Camera = {
    transitionTime = 500,       -- ms for camera transition
    fov = 45.0,                 -- Field of view (slightly narrower for better framing)
    distance = 0.65,            -- Distance from ATM (slightly further for full view)
    heightOffset = 1.45,        -- Height offset (player eye-level, ~1.55m from ATM base)
    sideOffset = -0.1,          -- Side offset (Left/Right)
    initialPitch = -15.0,       -- Initial downward angle (negative = looking down at ATM)
    mouseSensitivity = 4.0,     -- Camera rotation sensitivity
    -- Rotation limits (degrees from initial rotation)
    pitchUp = 18.0,             -- How far up from initial (to see top of screen)
    pitchDown = 55.0,           -- How far down from initial (to reach bottom keypad row)
    yawRange = 30.0,            -- How far left/right from initial (wide enough for side buttons)
}

-- Physical ATM Keypad Button Positions
-- Each button is defined as a 3D offset (x, y, z) from the ATM entity origin.
-- These offsets are in the ATM entity's local coordinate system.
-- They get quaternion-rotated by the entity heading to produce world positions,
-- then projected to screen coordinates to check if the crosshair (screen center) is near them.
AtmuiConfig.ButtonProximity = 0.027  -- Screen-space distance threshold for hit detection

-- Button offsets per ATM model (tune in-game with /apexatmcalibrate)
AtmuiConfig.ButtonOffsets = {
    ['prop_fleeca_atm'] = {
        -- Side buttons (left and right of screen)
        { id = 'side_l1', offset = vector3(-0.3060, 0.1000, 1.2300) },
        { id = 'side_l2', offset = vector3(-0.3060, 0.0950, 1.1700) },
        { id = 'side_l3', offset = vector3(-0.3060, 0.0900, 1.1100) },
        { id = 'side_l4', offset = vector3(-0.3060, 0.0800, 1.0600) },
        { id = 'side_r1', offset = vector3(0.0650, 0.1000, 1.2300) },
        { id = 'side_r2', offset = vector3(0.0650, 0.0950, 1.1700) },
        { id = 'side_r3', offset = vector3(0.0640, 0.0850, 1.1100) },
        { id = 'side_r4', offset = vector3(0.0630, 0.0700, 1.0550) },
        -- Number pad
        { id = 'pin_1',     offset = vector3(-0.1830, 0.0000, 0.8800) },
        { id = 'pin_2',     offset = vector3(-0.1450, 0.0000, 0.8800) },
        { id = 'pin_3',     offset = vector3(-0.1070, 0.0000, 0.8800) },
        { id = 'pin_4',     offset = vector3(-0.1830, -0.0400, 0.8750) },
        { id = 'pin_5',     offset = vector3(-0.1450, -0.0400, 0.8750) },
        { id = 'pin_6',     offset = vector3(-0.1070, -0.0400, 0.8750) },
        { id = 'pin_7',     offset = vector3(-0.1830, -0.0750, 0.8650) },
        { id = 'pin_8',     offset = vector3(-0.1450, -0.0750, 0.8650) },
        { id = 'pin_9',     offset = vector3(-0.1070, -0.0750, 0.8650) },
        { id = 'pin_0',     offset = vector3(-0.1450, -0.1200, 0.8650) },
        { id = 'pin_clear', offset = vector3(-0.1820, -0.1200, 0.8650) },
        { id = 'pin_enter', offset = vector3(-0.1080, -0.1200, 0.8650) },
    },
    ['prop_atm_01'] = {
        { id = 'side_l1', offset = vector3(-0.1900, -0.1150, 1.1380) },
        { id = 'side_l2', offset = vector3(-0.1900, -0.1220, 1.1040) },
        { id = 'side_l3', offset = vector3(-0.1900, -0.1290, 1.0640) },
        { id = 'side_l4', offset = vector3(-0.1900, -0.1360, 1.0260) },
        { id = 'side_r1', offset = vector3(0.0840, -0.1150, 1.1390) },
        { id = 'side_r2', offset = vector3(0.0840, -0.1210, 1.1030) },
        { id = 'side_r3', offset = vector3(0.0840, -0.1280, 1.0650) },
        { id = 'side_r4', offset = vector3(0.0840, -0.1350, 1.0270) },
        { id = 'pin_1',     offset = vector3(-0.0870, -0.1830, 0.8900) },
        { id = 'pin_2',     offset = vector3(-0.0540, -0.1840, 0.8920) },
        { id = 'pin_3',     offset = vector3(-0.0250, -0.1830, 0.8880) },
        { id = 'pin_4',     offset = vector3(-0.0860, -0.2050, 0.8730) },
        { id = 'pin_5',     offset = vector3(-0.0560, -0.2040, 0.8720) },
        { id = 'pin_6',     offset = vector3(-0.0250, -0.2040, 0.8720) },
        { id = 'pin_7',     offset = vector3(-0.0860, -0.2240, 0.8580) },
        { id = 'pin_8',     offset = vector3(-0.0550, -0.2240, 0.8570) },
        { id = 'pin_9',     offset = vector3(-0.0240, -0.2250, 0.8600) },
        { id = 'pin_0',     offset = vector3(-0.0540, -0.2490, 0.8460) },
        { id = 'pin_clear', offset = vector3(-0.0870, -0.2470, 0.8410) },
        { id = 'pin_enter', offset = vector3(-0.0260, -0.2540, 0.8550) },
    },
    ['prop_atm_02'] = {
        { id = 'side_l1', offset = vector3(-0.306, 0.1, 1.23) },
        { id = 'side_l2', offset = vector3(-0.306, 0.095, 1.17) },
        { id = 'side_l3', offset = vector3(-0.306, 0.09, 1.11) },
        { id = 'side_l4', offset = vector3(-0.306, 0.076, 1.05) },
        { id = 'side_r1', offset = vector3(0.065, 0.1, 1.23) },
        { id = 'side_r2', offset = vector3(0.065, 0.095, 1.17) },
        { id = 'side_r3', offset = vector3(0.064, 0.085, 1.11) },
        { id = 'side_r4', offset = vector3(0.063, 0.07, 1.055) },
        { id = 'pin_1',     offset = vector3(-0.173, 0.0, 0.88) },
        { id = 'pin_2',     offset = vector3(-0.145, 0.0, 0.88) },
        { id = 'pin_3',     offset = vector3(-0.122, 0.0, 0.88) },
        { id = 'pin_4',     offset = vector3(-0.173, -0.04, 0.87) },
        { id = 'pin_5',     offset = vector3(-0.145, -0.04, 0.87) },
        { id = 'pin_6',     offset = vector3(-0.122, -0.04, 0.87) },
        { id = 'pin_7',     offset = vector3(-0.173, -0.075, 0.865) },
        { id = 'pin_8',     offset = vector3(-0.145, -0.075, 0.865) },
        { id = 'pin_9',     offset = vector3(-0.122, -0.075, 0.865) },
        { id = 'pin_0',     offset = vector3(-0.145, -0.12, 0.865) },
        { id = 'pin_clear', offset = vector3(-0.076, 0.0, 0.88) },
        { id = 'pin_enter', offset = vector3(-0.076, -0.075, 0.865) },
    },
    ['prop_atm_03'] = {
        { id = 'side_l1', offset = vector3(-0.306, 0.095, 1.23) },
        { id = 'side_l2', offset = vector3(-0.306, 0.080, 1.17) },
        { id = 'side_l3', offset = vector3(-0.306, 0.065, 1.11) },
        { id = 'side_l4', offset = vector3(-0.306, 0.050, 1.05) },
        { id = 'side_r1', offset = vector3(0.065, 0.095, 1.23) },
        { id = 'side_r2', offset = vector3(0.065, 0.080, 1.17) },
        { id = 'side_r3', offset = vector3(0.064, 0.065, 1.11) },
        { id = 'side_r4', offset = vector3(0.063, 0.050, 1.055) },
        { id = 'pin_1',     offset = vector3(-0.181, -0.02, 0.88) },
        { id = 'pin_2',     offset = vector3(-0.153, -0.02, 0.88) },
        { id = 'pin_3',     offset = vector3(-0.116, -0.02, 0.88) },
        { id = 'pin_4',     offset = vector3(-0.181, -0.06, 0.87) },
        { id = 'pin_5',     offset = vector3(-0.153, -0.06, 0.87) },
        { id = 'pin_6',     offset = vector3(-0.116, -0.06, 0.87) },
        { id = 'pin_7',     offset = vector3(-0.181, -0.085, 0.865) },
        { id = 'pin_8',     offset = vector3(-0.153, -0.085, 0.865) },
        { id = 'pin_9',     offset = vector3(-0.116, -0.085, 0.865) },
        { id = 'pin_0',     offset = vector3(-0.153, -0.122, 0.865) },
        { id = 'pin_clear', offset = vector3(-0.076, -0.02, 0.88) },
        { id = 'pin_enter', offset = vector3(-0.076, -0.077, 0.865) },
    },
}

-- ─── On-screen layout (the UI side of the calibration) ───────
-- Where each side key is DRAWN on the ATM screen, so it sits right next to
-- the physical button it belongs to. Everything is in % of the screen area.
--   frame = the part of the texture the model actually shows
--           (x/y = offset, sx/sy = size, all in % of the DUI texture)
--   keys  = rectangle of every side key (x/y/w/h in % of the frame)
-- `default` applies to every model; a model entry only needs what differs.
-- Edit it live in-game: /apexatmcalibrate → TAB (screen mode). Saved layouts
-- are stored in the database and override these values for everyone.
AtmuiConfig.ScreenLayout = {
    default = {
        frame = { x = 0.0, y = 0.0, sx = 100.0, sy = 100.0 },
        keys = {
            side_l1 = { x = 0.6,   y = 10.125, w = 23.75, h = 8.5 },
            side_l2 = { x = 0.6,   y = 33.875, w = 23.75, h = 8.5 },
            side_l3 = { x = 0.6,   y = 57.625, w = 23.75, h = 8.5 },
            side_l4 = { x = 0.6,   y = 81.375, w = 23.75, h = 8.5 },
            side_r1 = { x = 76.25, y = 10.125, w = 23.75, h = 8.5 },
            side_r2 = { x = 76.25, y = 33.875, w = 23.75, h = 8.5 },
            side_r3 = { x = 76.25, y = 57.625, w = 23.75, h = 8.5 },
            side_r4 = { x = 76.25, y = 81.375, w = 23.75, h = 8.5 },
        },
    },
    -- prop_fleeca_atm samples only the lower-left part of its screen texture
    ['prop_fleeca_atm'] = {
        frame = { x = 0.39, y = 50.78, sx = 49.21, sy = 46.48 },
        -- 3D screen quad (prop-local metres), tuned in-game with /apexatmquad
        quad  = { l = -0.2830, r = 0.0410, zt = 1.2820, zb = 1.0225, yt = 0.1298, yb = 0.0722 },
        -- calibrated in-game with /apexatmcalibrate
        keys = {
            side_l1 = { x = 1.10, y = 18.62, w = 23.75, h = 8.50 },
            side_l2 = { x = 0.60, y = 39.88, w = 23.75, h = 8.50 },
            side_l3 = { x = 0.60, y = 61.62, w = 23.75, h = 8.50 },
            side_l4 = { x = 0.60, y = 83.38, w = 23.75, h = 8.50 },
            side_r1 = { x = 76.25, y = 18.12, w = 23.75, h = 8.50 },
            side_r2 = { x = 76.25, y = 39.88, w = 23.75, h = 8.50 },
            side_r3 = { x = 76.25, y = 61.62, w = 23.75, h = 8.50 },
            side_r4 = { x = 76.25, y = 83.38, w = 23.75, h = 8.50 },
        },
    },
    -- prop_atm_01: full-page frame + keys from `default`; only the 3D screen
    -- quad is model-specific (tuned in-game with /apexatmquad)
    ['prop_atm_01'] = {
        quad = { l = -0.1650, r = 0.0590, zt = 1.1806, zb = 0.9984, yt = -0.1159, yb = -0.1446, d = 0.0080 },
    },
}

-- PIN Settings. The PIN is checked against the player's REAL apex_banking
-- account PIN (the one set at the bank), and the lockout is the account's
-- own (Config.pin.maxTries / lockoutMs) — shared with every other ATM.
AtmuiConfig.PIN = {
    length = (Config and Config.pin and Config.pin.length) or 4, -- follows the bank's PIN length
    maxAttempts = 3,            -- Wrong PINs per session before the card is swallowed
    lockoutTime = 300,          -- Seconds this client refuses to start a new session after that
    -- true = the player must carry Config.card.item (apex_atm_card), checked server-side on
    -- ox_inventory / qb-inventory; false = the account PIN is enough. Follows Config.card.requireAtAtm.
    requireCard = (Config and Config.card and Config.card.requireAtAtm) or false,
}

-- Transaction Settings
AtmuiConfig.Transactions = {
    quickAmounts = {20, 50, 100, 200, 500}, -- Quick withdrawal amounts (L1-L4, R1)
    maxWithdraw = 10000,        -- Max single withdrawal (Config.limits still applies on top)
    maxDeposit = 50000,         -- Max single deposit
    maxTransfer = 25000,        -- Max single transfer
}

-- Receipt item handed out when the player asks for one (ox_inventory or
-- qb-inventory). Set to false to only show a notification.
AtmuiConfig.ReceiptItem = 'apex_atm_receipt'

-- Sound Settings
AtmuiConfig.Sounds = {
    enabled = true,
    volume = 0.5,
}

-- Interaction Settings
AtmuiConfig.Interaction = {
    useTarget = false,          -- false = apex 3D marker + E (like the bank); true = ox_target / qb-target
    useQBTarget = false,        -- Use qb-target if true (ox_target otherwise)
    interactKey = 38,           -- E key for proximity
    interactDistance = 1.5,     -- Distance to interact
}

-- Animation Settings
AtmuiConfig.Animation = {
    dict = 'amb@prop_human_atm@male@idle_a',
    anim = 'idle_a',
    cardDict = 'amb@prop_human_atm@male@enter',
    cardAnim = 'enter',
}

-- UI Customization
AtmuiConfig.UI = {
    bankName = '',              -- optional wordmark on the ATM screen (empty = none)
    language = nil,             -- nil = follow Config.locale
}

-- Locales — used by BOTH the Lua side (notifications) and the ATM screen.
AtmuiConfig.Locales = {
    en = {
        -- screen
        secure = 'Secure', insert_card = 'Please insert your card', reading = 'Reading card details',
        ejecting = 'Ejecting card', take_card = 'Please take your card',
        auth = 'Authentication', enter_pin = 'Enter PIN code', set_pin = 'Set new PIN', attempts = 'Attempts remaining',
        overview = 'Account overview', welcome_back = 'Welcome back', available = 'Available balance',
        quick = 'Quick cash', select_amount = 'Select the amount', limit = 'Balance',
        custom_withdraw = 'Custom withdrawal', cash_deposit = 'Cash deposit',
        transfer_account = 'Destination account', transfer_amount = 'Transfer amount',
        enter_amount = 'Enter amount', enter_account = 'Enter the account number',
        balance_title = 'Account balance', current_balance = 'Current balance',
        complete = 'Transaction complete', print_q = 'Print a receipt?', print_hint = 'The receipt goes to your inventory',
        processed = 'Processed', remaining = 'Remaining', processing = 'Processing',
        card_required = 'Card required', card_missing = 'Card not detected',
        card_missing_desc = 'You need a debit card to use this ATM. Visit any bank branch to get one.',
        to = 'To',
        welcome = 'Welcome', hint_insert = 'Insert your card to begin', select_tx = 'Please select a transaction',
        shield_pin = 'Cover the keypad when entering your PIN', hint_pin = 'Press ENTER when done · CLEAR to correct',
        hint_select = 'Press the button next to your choice', hint_amount = 'Type the amount · ENTER to confirm · CLEAR to correct',
        hint_account = 'Type the account number · ENTER to continue', hint_wait = 'Please wait', hint_take = 'Please remove your cash',
        max_per = 'Maximum per transaction', processing_sub = 'Your transaction is being processed', counting = 'Counting notes',
        thanks = 'Thank you for banking with us', terminal = 'Terminal', encrypted = 'Secure · Encrypted',
        -- side buttons
        withdraw = 'Withdraw', deposit = 'Deposit', transfer = 'Transfer', balance = 'Balance',
        eject = 'Eject card', custom = 'Custom', back = 'Return', confirm = 'Confirm', next = 'Next',
        cancel = 'Cancel', print = 'Print', no_print = 'No receipt', get_card = 'Get card',
        -- messages
        take_cash = 'Please take your cash', deposit_done = 'Deposit complete', transfer_done = 'Transfer sent',
        invalid_amount = 'Invalid amount', over_limit = 'Amount exceeds the limit', card_locked = 'Card locked — visit a bank',
        wrong_pin = 'Wrong PIN', no_account = 'No bank account — open one at a bank', frozen = 'Account frozen',
        no_funds = 'Insufficient funds', no_cash = 'Not enough cash on you', not_found = 'Account not found',
        self_transfer = 'You cannot transfer to yourself', daily = 'Daily ATM limit reached', error = 'Transaction failed',
        receipt_given = 'Receipt printed', receipt_title = 'ATM receipt',
    },
    pt = {
        secure = 'Seguro', insert_card = 'Por favor insira o cartão', reading = 'A ler o cartão',
        ejecting = 'A devolver o cartão', take_card = 'Retire o seu cartão',
        auth = 'Autenticação', enter_pin = 'Introduza o PIN', set_pin = 'Defina o novo PIN', attempts = 'Tentativas restantes',
        overview = 'Resumo da conta', welcome_back = 'Bem-vindo de volta', available = 'Saldo disponível',
        quick = 'Levantamento rápido', select_amount = 'Escolha o montante', limit = 'Saldo',
        custom_withdraw = 'Outro montante', cash_deposit = 'Depósito em numerário',
        transfer_account = 'Conta de destino', transfer_amount = 'Montante a transferir',
        enter_amount = 'Introduza o montante', enter_account = 'Introduza o número da conta',
        balance_title = 'Saldo da conta', current_balance = 'Saldo atual',
        complete = 'Operação concluída', print_q = 'Imprimir talão?', print_hint = 'O talão vai para o inventário',
        processed = 'Processado', remaining = 'Restante', processing = 'A processar',
        card_required = 'Cartão necessário', card_missing = 'Cartão não detetado',
        card_missing_desc = 'Precisa de um cartão de débito para usar este ATM. Dirija-se a um balcão.',
        to = 'Para',
        welcome = 'Bem-vindo', hint_insert = 'Insira o cartão para começar', select_tx = 'Selecione a operação',
        shield_pin = 'Tape o teclado ao introduzir o PIN', hint_pin = 'ENTER para confirmar · CLEAR para corrigir',
        hint_select = 'Prima o botão junto à opção', hint_amount = 'Digite o montante · ENTER confirma · CLEAR corrige',
        hint_account = 'Digite o número da conta · ENTER para continuar', hint_wait = 'Aguarde, por favor', hint_take = 'Retire o seu dinheiro',
        max_per = 'Máximo por operação', processing_sub = 'A sua operação está a ser processada', counting = 'A contar as notas',
        thanks = 'Obrigado por escolher o nosso banco', terminal = 'Terminal', encrypted = 'Seguro · Encriptado',
        withdraw = 'Levantar', deposit = 'Depositar', transfer = 'Transferir', balance = 'Saldo',
        eject = 'Retirar cartão', custom = 'Outro', back = 'Voltar', confirm = 'Confirmar', next = 'Seguinte',
        cancel = 'Cancelar', print = 'Imprimir', no_print = 'Sem talão', get_card = 'Obter cartão',
        take_cash = 'Retire o seu dinheiro', deposit_done = 'Depósito concluído', transfer_done = 'Transferência enviada',
        invalid_amount = 'Montante inválido', over_limit = 'Montante acima do limite', card_locked = 'Cartão bloqueado — vá a um balcão',
        wrong_pin = 'PIN errado', no_account = 'Sem conta — abra uma num balcão', frozen = 'Conta congelada',
        no_funds = 'Saldo insuficiente', no_cash = 'Não tem dinheiro suficiente', not_found = 'Conta não encontrada',
        self_transfer = 'Não pode transferir para si próprio', daily = 'Limite diário do ATM atingido', error = 'A operação falhou',
        receipt_given = 'Talão impresso', receipt_title = 'Talão do ATM',
    },
    es = {
        secure = 'Seguro', insert_card = 'Introduzca su tarjeta', reading = 'Leyendo la tarjeta',
        ejecting = 'Expulsando la tarjeta', take_card = 'Retire su tarjeta',
        auth = 'Autenticación', enter_pin = 'Introduzca el PIN', set_pin = 'Nuevo PIN', attempts = 'Intentos restantes',
        overview = 'Resumen de cuenta', welcome_back = 'Bienvenido de nuevo', available = 'Saldo disponible',
        quick = 'Retiro rápido', select_amount = 'Elija el importe', limit = 'Saldo',
        custom_withdraw = 'Otro importe', cash_deposit = 'Ingreso en efectivo',
        transfer_account = 'Cuenta de destino', transfer_amount = 'Importe a transferir',
        enter_amount = 'Introduzca el importe', enter_account = 'Introduzca el número de cuenta',
        balance_title = 'Saldo de la cuenta', current_balance = 'Saldo actual',
        complete = 'Operación completada', print_q = '¿Imprimir recibo?', print_hint = 'El recibo va a su inventario',
        processed = 'Procesado', remaining = 'Restante', processing = 'Procesando',
        card_required = 'Tarjeta necesaria', card_missing = 'Tarjeta no detectada',
        card_missing_desc = 'Necesita una tarjeta de débito para usar este cajero. Visite una sucursal.',
        to = 'Para',
        welcome = 'Bienvenido', hint_insert = 'Introduzca su tarjeta para empezar', select_tx = 'Seleccione una operación',
        shield_pin = 'Cubra el teclado al introducir el PIN', hint_pin = 'ENTER para confirmar · CLEAR para corregir',
        hint_select = 'Pulse el botón junto a su opción', hint_amount = 'Escriba el importe · ENTER confirma · CLEAR corrige',
        hint_account = 'Escriba el número de cuenta · ENTER para seguir', hint_wait = 'Espere, por favor', hint_take = 'Retire su dinero',
        max_per = 'Máximo por operación', processing_sub = 'Su operación se está procesando', counting = 'Contando billetes',
        thanks = 'Gracias por confiar en nosotros', terminal = 'Terminal', encrypted = 'Seguro · Cifrado',
        withdraw = 'Retirar', deposit = 'Ingresar', transfer = 'Transferir', balance = 'Saldo',
        eject = 'Sacar tarjeta', custom = 'Otro', back = 'Volver', confirm = 'Confirmar', next = 'Siguiente',
        cancel = 'Cancelar', print = 'Imprimir', no_print = 'Sin recibo', get_card = 'Pedir tarjeta',
        take_cash = 'Retire su dinero', deposit_done = 'Ingreso completado', transfer_done = 'Transferencia enviada',
        invalid_amount = 'Importe no válido', over_limit = 'Importe por encima del límite', card_locked = 'Tarjeta bloqueada — visite un banco',
        wrong_pin = 'PIN incorrecto', no_account = 'Sin cuenta — abra una en un banco', frozen = 'Cuenta congelada',
        no_funds = 'Saldo insuficiente', no_cash = 'No lleva suficiente efectivo', not_found = 'Cuenta no encontrada',
        self_transfer = 'No puede transferirse a sí mismo', daily = 'Límite diario del cajero alcanzado', error = 'La operación falló',
        receipt_given = 'Recibo impreso', receipt_title = 'Recibo del cajero',
    },
    fr = {
        secure = 'Sécurisé', insert_card = 'Veuillez insérer votre carte', reading = 'Lecture de la carte',
        ejecting = 'Éjection de la carte', take_card = 'Reprenez votre carte',
        auth = 'Authentification', enter_pin = 'Saisissez votre code', set_pin = 'Nouveau code', attempts = 'Essais restants',
        overview = 'Aperçu du compte', welcome_back = 'Bon retour', available = 'Solde disponible',
        quick = 'Retrait rapide', select_amount = 'Choisissez le montant', limit = 'Solde',
        custom_withdraw = 'Autre montant', cash_deposit = 'Dépôt d’espèces',
        transfer_account = 'Compte destinataire', transfer_amount = 'Montant du virement',
        enter_amount = 'Saisissez le montant', enter_account = 'Saisissez le numéro de compte',
        balance_title = 'Solde du compte', current_balance = 'Solde actuel',
        complete = 'Opération terminée', print_q = 'Imprimer un reçu ?', print_hint = 'Le reçu va dans votre inventaire',
        processed = 'Traité', remaining = 'Restant', processing = 'Traitement',
        card_required = 'Carte requise', card_missing = 'Carte non détectée',
        card_missing_desc = 'Une carte de débit est nécessaire pour ce DAB. Rendez-vous en agence.',
        to = 'Vers',
        welcome = 'Bienvenue', hint_insert = 'Insérez votre carte pour commencer', select_tx = 'Choisissez une opération',
        shield_pin = 'Cachez le clavier en saisissant votre code', hint_pin = 'ENTER pour valider · CLEAR pour corriger',
        hint_select = 'Appuyez sur la touche face à votre choix', hint_amount = 'Tapez le montant · ENTER valide · CLEAR corrige',
        hint_account = 'Tapez le numéro de compte · ENTER pour continuer', hint_wait = 'Veuillez patienter', hint_take = 'Prenez vos billets',
        max_per = 'Maximum par opération', processing_sub = 'Votre opération est en cours', counting = 'Comptage des billets',
        thanks = 'Merci de votre confiance', terminal = 'Terminal', encrypted = 'Sécurisé · Chiffré',
        withdraw = 'Retirer', deposit = 'Déposer', transfer = 'Virement', balance = 'Solde',
        eject = 'Éjecter', custom = 'Autre', back = 'Retour', confirm = 'Valider', next = 'Suivant',
        cancel = 'Annuler', print = 'Imprimer', no_print = 'Sans reçu', get_card = 'Obtenir',
        take_cash = 'Prenez vos billets', deposit_done = 'Dépôt effectué', transfer_done = 'Virement envoyé',
        invalid_amount = 'Montant invalide', over_limit = 'Montant au-dessus de la limite', card_locked = 'Carte bloquée — passez en agence',
        wrong_pin = 'Code erroné', no_account = 'Aucun compte — ouvrez-en un en agence', frozen = 'Compte gelé',
        no_funds = 'Solde insuffisant', no_cash = 'Pas assez d’espèces sur vous', not_found = 'Compte introuvable',
        self_transfer = 'Virement vers vous-même impossible', daily = 'Plafond journalier atteint', error = 'L’opération a échoué',
        receipt_given = 'Reçu imprimé', receipt_title = 'Reçu du DAB',
    },
    de = {
        secure = 'Sicher', insert_card = 'Bitte Karte einführen', reading = 'Karte wird gelesen',
        ejecting = 'Karte wird ausgegeben', take_card = 'Bitte Karte entnehmen',
        auth = 'Authentifizierung', enter_pin = 'PIN eingeben', set_pin = 'Neue PIN', attempts = 'Verbleibende Versuche',
        overview = 'Kontoübersicht', welcome_back = 'Willkommen zurück', available = 'Verfügbarer Saldo',
        quick = 'Schnellauszahlung', select_amount = 'Betrag wählen', limit = 'Saldo',
        custom_withdraw = 'Anderer Betrag', cash_deposit = 'Bareinzahlung',
        transfer_account = 'Empfängerkonto', transfer_amount = 'Überweisungsbetrag',
        enter_amount = 'Betrag eingeben', enter_account = 'Kontonummer eingeben',
        balance_title = 'Kontostand', current_balance = 'Aktueller Saldo',
        complete = 'Vorgang abgeschlossen', print_q = 'Beleg drucken?', print_hint = 'Der Beleg kommt ins Inventar',
        processed = 'Verarbeitet', remaining = 'Verbleibend', processing = 'Wird verarbeitet',
        card_required = 'Karte erforderlich', card_missing = 'Keine Karte erkannt',
        card_missing_desc = 'Für diesen Automaten brauchst du eine Debitkarte. Besuche eine Filiale.',
        to = 'An',
        welcome = 'Willkommen', hint_insert = 'Karte einführen, um zu beginnen', select_tx = 'Bitte Vorgang wählen',
        shield_pin = 'Tastatur bei der PIN-Eingabe verdecken', hint_pin = 'ENTER zum Bestätigen · CLEAR zum Korrigieren',
        hint_select = 'Taste neben Ihrer Wahl drücken', hint_amount = 'Betrag eingeben · ENTER bestätigt · CLEAR korrigiert',
        hint_account = 'Kontonummer eingeben · ENTER zum Fortfahren', hint_wait = 'Bitte warten', hint_take = 'Bitte Geld entnehmen',
        max_per = 'Maximum pro Vorgang', processing_sub = 'Ihr Vorgang wird bearbeitet', counting = 'Scheine werden gezählt',
        thanks = 'Danke, dass Sie bei uns sind', terminal = 'Terminal', encrypted = 'Sicher · Verschlüsselt',
        withdraw = 'Abheben', deposit = 'Einzahlen', transfer = 'Überweisen', balance = 'Saldo',
        eject = 'Karte raus', custom = 'Anderer', back = 'Zurück', confirm = 'Bestätigen', next = 'Weiter',
        cancel = 'Abbrechen', print = 'Drucken', no_print = 'Kein Beleg', get_card = 'Karte holen',
        take_cash = 'Bitte Geld entnehmen', deposit_done = 'Einzahlung abgeschlossen', transfer_done = 'Überweisung gesendet',
        invalid_amount = 'Ungültiger Betrag', over_limit = 'Betrag über dem Limit', card_locked = 'Karte gesperrt — Filiale besuchen',
        wrong_pin = 'Falsche PIN', no_account = 'Kein Konto — eröffne eins in einer Bank', frozen = 'Konto eingefroren',
        no_funds = 'Guthaben reicht nicht', no_cash = 'Nicht genug Bargeld dabei', not_found = 'Konto nicht gefunden',
        self_transfer = 'Überweisung an dich selbst nicht möglich', daily = 'Tageslimit erreicht', error = 'Vorgang fehlgeschlagen',
        receipt_given = 'Beleg gedruckt', receipt_title = 'Automatenbeleg',
    },
}

-- Active language table, English underneath so a missing key never shows raw.
function AtmuiConfig.Strings()
    local lang = AtmuiConfig.UI.language or (Config and Config.locale) or 'en'
    local base = AtmuiConfig.Locales.en
    local over = AtmuiConfig.Locales[lang] or {}
    local out = {}
    for k, v in pairs(base) do out[k] = over[k] or v end
    return out
end

function AtmuiConfig.T(key)
    local lang = AtmuiConfig.UI.language or (Config and Config.locale) or 'en'
    local t = AtmuiConfig.Locales[lang]
    return (t and t[key]) or AtmuiConfig.Locales.en[key] or key
end
