Config = Config or {}

Config.Medication = { -- lockAccess = true requires an ems job from Config.Jobs
    {
        itemName = 'tourniquet',
        type = 'tourniquet',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.applying_tourniquet,
        removeLang = GetLang().progress.removing_tourniquet,
        langUsed = GetLang().update1.applied_tourniquet,
        buttonLang = GetLang().buttons.apply_tourniquet,
        buttonLangRemove = GetLang().buttons.remove_tourniquet,
        time = 3000,
        pain = 3.0,
        lockAccess = false,
    },
    {
        itemName = 'field_dressing',
        type = 'bandage',
        effectivenessModifiers = {["abrasion"] = 0.7, ["avulsion"] = 0.8, ["contusion"] = 1.0, ["crush"] = 0.9, ["cut"] = 0.9, ["laceration"] = 0.1, ["velocitywound"] = 0.5, ["lowvelocitywound"] = 0.5, ["mediumvelocitywound"] = 0.5, ["highvelocitywound"] = 0.5, ["puncturewound"] = 0.7, ["burn"] = 0.7},
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.applying_field_dressing,
        langUsed = GetLang().vitals.applied_field_dressing,
        buttonLang = GetLang().buttons.apply_field_dressing,
        time = 5000,
        removeItem = true,
        lockAccess = false,
    },
    {
        itemName = 'elastic_bandage',
        type = 'bandage',
        effectivenessModifiers = {["abrasion"] = 0.7, ["avulsion"] = 0.6, ["contusion"] = 1.0, ["crush"] = 0.7, ["cut"] = 0.7, ["laceration"] = 0.7, ["velocitywound"] = 0.6, ["lowvelocitywound"] = 0.5, ["mediumvelocitywound"] = 0.5, ["highvelocitywound"] = 0.5, ["puncturewound"] = 0.6, ["burn"] = 0.9 },
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.applying_elastic_bandage,
        langUsed = GetLang().vitals.applied_elastic_bandage,
        buttonLang = GetLang().buttons.apply_elastic_bandage,
        time = 9000,
        removeItem = true,
        lockAccess = false,
    },
    {
        itemName = 'quick_clot',
        type = 'bandage',
        effectivenessModifiers = {["abrasion"] = 0.85, ["avulsion"] = 0.8, ["contusion"] = 1.0, ["crush"] = 0.6, ["cut"] = 0.6, ["laceration"] = 0.8, ["velocitywound"] = 0.8, ["lowvelocitywound"] = 0.5, ["mediumvelocitywound"] = 0.5, ["highvelocitywound"] = 0.5, ["puncturewound"] = 0.7, ["burn"] = 0.4 },
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.applying_quick_clot,
        langUsed = GetLang().vitals.applied_quick_clot,
        buttonLang = GetLang().buttons.apply_quick_clot,
        time = 4000,
        removeItem = true,
        lockAccess = false,
    },
    {
        itemName = 'packing_bandage',
        type = 'bandage',
        effectivenessModifiers = {["abrasion"] = 0.7, ["avulsion"] = 0.6, ["contusion"] = 1.0, ["crush"] = 0.7, ["cut"] = 0.7, ["laceration"] = 0.7, ["velocitywound"] = 0.6, ["lowvelocitywound"] = 0.5, ["mediumvelocitywound"] = 0.5, ["highvelocitywound"] = 0.5, ["puncturewound"] = 0.7, ["burn"] = 0.4 },
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.applying_packing_bandage,
        langUsed = GetLang().vitals.applied_packing_bandage,
        buttonLang = GetLang().buttons.apply_packing_bandage,
        time = 4000,
        removeItem = true,
        lockAccess = false,
    },
    {
        itemName = 'sewing_kit',
        type = 'sewing',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.sewing_injuries,
        langUsed = GetLang().progress.sewing_injuries,
        buttonLang = GetLang().buttons.sewing,
        time = 7000,
        removeItem = false,
        lockAccess = true,
    },
    {
        itemName = 'morphine',
        type = 'medication',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_morphine,
        langUsed = GetLang().vitals.injected_morphine,
        buttonLang = GetLang().buttons.morphine,
        time = 3000,
        removeItem = true,
        painReduce = 9.0,
        maxDose = 3,
        hrDecrease = 40,
        hrIncrease = -20,
        onOverDose = function(self)
            -- Overdose is handled by the addiction system (server/addictions.lua)
        end,
        lockAccess = true,
    },
    {
        itemName = 'epinephrine',
        type = 'medication',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_epinephrine,
        langUsed = GetLang().vitals.injected_epinephrine,
        buttonLang = GetLang().buttons.epinephrine,
        time = 3000,
        removeItem = true,
        painReduce = 4.0,
        maxDose = 5,
        hrDecrease = -10,
        hrIncrease = 20,
        onOverDose = function(self) 
            print('Player is overdosing')
            -- Trigger the code you want to happen when a player overdoeses eg dies
        end,
        lockAccess = true,
    },
    {
        itemName = 'saline250ml',
        type = 'infusion',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_saline_pack,
        langUsed = GetLang().vitals.injected_saline_pack250ml,
        buttonLang = GetLang().buttons.saline_pack250ml,
        time = 8000,
        removeItem = true,
        volume = 250,
        injectingTime = 120*1000,
        onUse = function(self)

        end,
        onTick = function(self)
            if BodyDamage.BodyPartDamage.BloodLevel < 6 then
                local bloodbuff = (self.volume/1000)/self.injectingTime
                BodyDamage.BodyPartDamage.BloodLevel = BodyDamage.BodyPartDamage.BloodLevel + (bloodbuff/3)
            end
        end,
        onFinish = function(self)

        end,
        lockAccess = true,
    },
    {
        itemName = 'saline500ml',
        type = 'infusion',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_saline_pack,
        langUsed = GetLang().vitals.injected_saline_pack500ml,
        buttonLang = GetLang().buttons.saline_pack500ml,
        time = 8000,
        removeItem = true,
        volume = 500,
        injectingTime = 120*1000,
        onUse = function(self)

        end,
        onTick = function(self)
            if BodyDamage.BodyPartDamage.BloodLevel < 6 then
                local bloodbuff = (self.volume/1000)/self.injectingTime
                BodyDamage.BodyPartDamage.BloodLevel = BodyDamage.BodyPartDamage.BloodLevel + (bloodbuff/3)
            end
        end,
        onFinish = function(self)

        end,
        lockAccess = true,
    },
    {
        itemName = 'propofol',
        type = 'infusion',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_propofol,
        langUsed = GetLang().vitals.injected_propofol,
        buttonLang = GetLang().buttons.propofol,
        time = 1000,
        removeItem = true,
        volume = 20,
        injectingTime = 5*60*1000,
        onUse = function(self)
            DoScreenFadeOut(15000)
        end,
        onTick = function(self)
            SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0)
            if BodyDamage.BodyPartDamage.BloodLevel < 6 then
                BodyDamage.BodyPartDamage.BloodLevel = BodyDamage.BodyPartDamage.BloodLevel + 0.1
            end
            if BodyDamage.Pain > 0 then
                BodyDamage.Pain = BodyDamage.Pain - BodyDamage.Pain/5
            end
        end,
        onFinish = function(self)
            DoScreenFadeIn(15000)
        end,
        onCancel = function(self)
            DoScreenFadeIn(5000)
            local ped = PlayerPedId()
            if IsPedRagdoll(ped) then
                ClearPedTasksImmediately(ped)
            end
        end,
        lockAccess = true,
    },
    {
        itemName = 'narcan',
        type = 'custom',
        anim = {
            name = 'gang_chatting_idle01',
            dict = 'anim@heists@narcotics@funding@gang_idle',
        },
        lang = GetLang().progress.injected_narcan,
        langUsed = GetLang().vitals.injected_narcan,
        buttonLang = GetLang().buttons.narcan,
        time = 3000,
        removeItem = true,
        lockAccess = true,
        onUse = function(self)
            TriggerServerEvent('osp_ambulance:treatOverdoseSv')
            if CancelInfusion then
                CancelInfusion('propofol')
            end
        end,
    },


    -- Template to create a fully custom medication
    -- {
    --     itemName = 'customMedication',
    --     type = 'custom', -- A fully custom preset where you write all the code yourself. (almost)
    --     anim = {
    --         name = 'gang_chatting_idle01',
    --         dict = 'anim@heists@narcotics@funding@gang_idle',
    --     },
    --     lang = GetLang().progress.injected_propofol,
    --     langUsed = GetLang().vitals.injected_propofol,
    --     buttonLang = GetLang().buttons.propofol,
    --     time = 1000,
    --     removeItem = true,
    --     maxDose = 2,
    --     onOverDose = function() 
    --         print('Player is overdosing')
    --         -- Trigger the code you want to happen when a player overdoeses eg dies
    --     end,
    --     onUse = function()
    --         CreateThread(function()
    --             DoScreenFadeOut(5000)
    --             Wait(5000)
    --             DoScreenFadeIn(5000)
    --             print('onuse')
    --         end)
    --     end,
    -- },


}