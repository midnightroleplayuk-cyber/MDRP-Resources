Config = Config or {}

Config.UseCustomProps = false -- If enabled, the script will apply the pedvariations from the config below (The default config is intended to be used with Sinner Mod Shop medical props pack)
Config.EnableCosmeticCasts = true -- Access casts and splints with additional menu buttons, intended for expanded roleplay options. These do not require fractures to be applied.
Config.Casts = {
    {
        type = 'splint',
        lang = GetLang().progress.applying_splint,
        removeLang = GetLang().progress.removing_splint,
        langUsed = GetLang().ui.splint_applied,
        langRemoved = GetLang().ui.splint_removed,
        buttonLang = GetLang().buttons.apply_splint,
        removeButtonLang = GetLang().buttons.remove_splint,
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        time = 5000,
        timeInCast = 15*60*1000,
        casts = {
            {
                itemName = 'neckbrace',
                removalItemName = '',
                bone = 'Head',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 8,
                    pedVariationId = 217,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'legsplint',
                removalItemName = '',
                bone = 'Rleg',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 10,
                    pedVariationId = 249,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'legsplint',
                removalItemName = '',
                bone = 'Lleg',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 7,
                    pedVariationId = 202,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'armsplint',
                removalItemName = '',
                bone = 'Rarm',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 7,
                    pedVariationId = 200,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'armsplint',
                removalItemName = '',
                bone = 'Larm',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 10,
                    pedVariationId = 248,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
        }
    },
    {
        type = 'cast',
        lang = GetLang().progress.applying_cast,
        removeLang = GetLang().progress.removing_cast,
        langUsed = GetLang().ui.cast_applied,
        langRemoved = GetLang().ui.cast_removed,
        buttonLang = GetLang().buttons.apply_cast,
        removeButtonLang = GetLang().buttons.remove_cast,
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        time = 5000,
        timeInCast = 15*60*1000,
        casts = {
            {
                itemName = 'neckcast',
                removalItemName = '', -- itemname, for example castsaw or ''
                bone = 'Head',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 10,
                    pedVariationId = 247,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'legcast',
                removalItemName = 'castsaw',
                bone = 'Rleg',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 7,
                    pedVariationId = 199,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'legcast',
                removalItemName = 'castsaw',
                bone = 'Lleg',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 7,
                    pedVariationId = 199,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'armcast',
                removalItemName = 'castsaw',
                bone = 'Rarm',
                -- animationName = 'brokenarm_clip',
                -- animationDict = 'brokenarm@export@anim',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 10,
                    pedVariationId = 245,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
            {
                itemName = 'armcast',
                removalItemName = 'castsaw',
                bone = 'Larm',
                animationName = nil,
                animationDict = nil,
                male = {
                    pedVariationCategory = 10,
                    pedVariationId = 245,
                },
                female = {
                    pedVariationCategory = 8,
                    pedVariationId = 209,
                },
            },
        }
    },

}
