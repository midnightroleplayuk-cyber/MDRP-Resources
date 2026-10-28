-- ====================================================================
-- INTERACTION PROMPT (E-press badge / 3D text / ox_lib TextUI)
-- ====================================================================
-- Prompt style, scan cadence, badge geometry, label font and fade timings.
-- label.asciiFold = 'tr' folds the Turkish letters GTA's font cannot render to ASCII.
-- ====================================================================

-- ⚠ Buyers set the prompt style with ONE key: config/config.lua ->
-- Config.InteractionStyle. Everything below is fine-tuning (geometry, fonts,
-- cadence) and rarely needs touching.
Config.Interaction = Config.Interaction or {}

Config.Interaction.provider  = nil

Config.Interaction.providerSkipDynamic = false

-- Derived from Config.InteractionStyle — do not set these by hand.
do
    local pick = Config.InteractionStyle or 'badge'
    if pick == 'ox-target' or pick == 'qb-target' or pick == 'auto' then
        Config.InteractionHandler = pick
        Config.Interaction.style  = 'badge'
    else
        Config.InteractionHandler = 'drawtext'
        Config.Interaction.style  = pick
    end
end

Config.Interaction.assets    = {
    badge = 'html/assets/tw_badge_blank.png',
    pill  = 'html/assets/tw_pill.png',
    dot   = 'html/assets/tw_dot.png',
}

Config.Interaction.fonts = {}

Config.Interaction.defaultKey = 'genel.interact'

Config.Interaction.scanMs    = 100

Config.Interaction.cellSize  = 8.0

Config.Interaction.screenBias = 0.7

Config.Interaction.distanceNorm = 10.0

Config.Interaction.badge     = {
    width      = 0.0165,
    zOffset    = 1.0,
    gap        = 0.0055,
    keyScale   = 0.36,
    keyOffsetY = -0.0128,
    keyColor   = { r = 246, g = 240, b = 224 },
    keyCharW   = 0.0062,
}

Config.Interaction.pin       = {
    width    = 0.0060,
    alpha    = 165,
    distance = 12.0,
    max      = 2,
}

-- font: GTA text font id. 4 is condensed, 0 is wider. If you change it,
-- retune charW below or the label pill will not match the text width.
-- For Chinese/Japanese/Cyrillic a real font via Config.Interaction.fonts
-- looks better than any built-in one.
Config.Interaction.label     = {
    show    = true,
    font    = 4,
    scale   = 0.315,
    padX    = 0.0130,
    charW   = 0.00268,
    offsetY = -0.0112,
    color   = { r = 255, g = 255, b = 255 },
    stripKeyPrefix = true,

    asciiFold = 'tr',
}

Config.Interaction.anim      = {
    fadeInMs  = 110,
    fadeOutMs = 90,
    punchMs   = 130,
    punchAmt  = 0.0,
    pulseAmt  = 0.0,
    pulseMs   = 1400,
}

Config.Interaction.scale     = {
    near     = 1.5,
    far      = 12.0,
    minScale = 0.62,
}

Config.Interaction.machine   = {
    minScale = 1.0,
    scaleMul = 1.15,
}

Config.Interaction.eCooldownMs = 400
