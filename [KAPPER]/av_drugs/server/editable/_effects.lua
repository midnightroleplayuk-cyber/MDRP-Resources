-- Effects event is located in client/editable/effects.lua
-- If u want to use your own drug effects script remove the drugs from the list otherwise my script will overwrite yours
Config = Config or {}
Config.DrugItems = {
    ['fentanyl_baggy'] = { -- item name
        requiredItems = false, -- requires some extra items to consume drug? table or false
        animation = {     
            dict = 'switch@trevor@trev_smoking_meth', 
            anim = 'trev_smoking_meth_loop',
            duration = 5000,
            disableWalk = true,
            flag = 48,
        },
        benefits = {
            health = false, -- Value added is based on drug purity
            armor = true -- Value added is based on drug purity
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.1, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "drug_drive_blend02", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 2.0 -- 1.0 is normal and max recommended is 5.0
        }
    }, 
    ['heroin_baggy'] = { -- item name
        requiredItems = { -- requires some extra items to consume drug? table or false
            {name = "water", amount = 1, remove = true}
        }, 
        animation = {     
            dict = 'rcmpaparazzo1ig_4', 
            anim = 'miranda_shooting_up',
            duration = 5000,
            disableWalk = true,
            flag = 49,
        },
        benefits = {
            health = true, -- Value added is based on drug purity
            armor = false -- Value added is based on drug purity
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.1, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "drug_drive_blend02", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 2.0 -- 1.0 is normal and max recommended is 5.0
        }
    }, 
    ['ketamine_baggy'] = { -- item name
        requiredItems = { -- requires some extra items to consume drug? table or false
            {name = "water", amount = 1, remove = true}
        }, 
        animation = {     
            dict = 'rcmpaparazzo1ig_4', 
            anim = 'miranda_shooting_up',
            duration = 5000,
            disableWalk = true,
            flag = 49,
        },
        benefits = {
            health = true, -- Value added is based on drug purity
            armor = false -- Value added is based on drug purity
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.1, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "drug_drive_blend02", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 2.0 -- 1.0 is normal and max recommended is 5.0
        }
    }, 
    ['coke_baggy'] = { -- item name
        requiredItems = false, -- requires some extra items to consume drug? table or false
        animation = {     
            dict = 'switch@trevor@trev_smoking_meth', 
            anim = 'trev_smoking_meth_loop',
            duration = 3000,
            disableWalk = false,
            flag = 48,
        },
        benefits = {
            health = true, -- Value added is based on drug purity
            armor = true -- Value added is based on drug purity
        },
        effect = {
            duration = 60, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.35, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "DRUG_2_drive", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 3.0 -- 1.0 is normal and max recommended is 5.0
        }
    },
    ['lsd_stamp'] = { -- item name
        requiredItems = false, -- requires some extra items to consume drug? table or false
        animation = {     
            dict = 'switch@trevor@trev_smoking_meth', 
            anim = 'trev_smoking_meth_loop',
            flag = 48,
            duration = 3000,
            disableWalk = false,
        },
        benefits = {
            health = false, -- Value added is based on drug purity
            armor = false, -- Value added is based on drug purity
            stamina = true, -- Gives almost unlimited stamina
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.15, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "spectator5", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 1.1 -- 1.0 is normal and max recommended is 5.0
        }
    },
    ['meth_baggy'] = { -- item name
        requiredItems = { -- requires some extra items to consume drug? table or false
            {name = "water", amount = 1, remove = false},
        }, 
        animation = {
            dict = 'switch@trevor@trev_smoking_meth', 
            anim = 'trev_smoking_meth_loop',
            flag = 48,
            duration = 3000,
            disableWalk = false,
        },
        benefits = {
            health = true, -- Value added is based on drug purity
            armor = true -- Value added is based on drug purity
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@hurry_butch@a", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.15, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "drug_drive_blend01", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 1.25 -- 1.0 is normal and max recommended is 5.0
        }
    },
    ['moonshine'] = { -- item name
        requiredItems = false, -- requires some extra items to consume drug? table or false
        animation = {
            dict = 'mp_player_intdrink', 
            anim = 'loop_bottle',
            flag = 48,
            duration = 3000,
            disableWalk = false,
        },
        benefits = {
            health = true, -- Value added is based on drug purity
            armor = true, -- Value added is based on drug purity
            stamina = true, -- Gives almost unlimited stamina
        },
        effect = {
            duration = 30, -- in seconds, purity also modifies this value. duration = duration + (purity / 10) | 30 + (100/10) = 40 seconds if purity is 100%
            clipSet = "move_m@drunk@verydrunk", -- u can find some here: https://docs.fivem.net/natives/?_0xAF8A94EDE7712BEF
            movementSpeed = 1.15, -- 1.0 is normal and max recommended is 2.0
            timeCycle = "spectator5", -- screen effect: https://forge.plebmasters.de/timecyclemods
            cameraShake = 1.15 -- 1.0 is normal and max recommended is 5.0
        }
    },
}

function onDrugUse(source,name,metadata, slot)
    metadata = metadata or {}
    dbug('onDrugUse(source,name,metadata, slot)', source, name, metadata and json.encode(metadata), slot)
    local inDrugs = Player(source).state and Player(source).state.inDrugs
    if inDrugs then
        dbug("Player is already using a drug, can't use 2 at the same time..")
        return
    end
    local label = metadata and metadata['label'] or "Drug"
    local drugInfo = Config.DrugItems and Config.DrugItems[name] or false
    local canUse = true
    dbug("name, drugInfo", name, drugInfo)
    if not drugInfo then
        print("^3[WARNING] ^7Drug ^1"..name.."^7 doesn't exist in Config.DrugItems, verify your server config.")
        return
    end
    if drugInfo['requiredItems'] and next(drugInfo['requiredItems']) then
        for _, v in pairs(drugInfo['requiredItems']) do
            dbug("requiredItem", v['name'], v['amount'])
            canUse = exports['av_laptop']:hasItem(source, v['name'], v['amount'])
            if not canUse then break end
        end
        if not canUse then
            TriggerClientEvent("av_laptop:notification", source, label, Lang['missing_items'], "error")
            return
        end
        for _, v in pairs(drugInfo['requiredItems']) do
            if v['remove'] then
                exports['av_laptop']:removeItem(source, v['name'], v['amount'])
            end
        end
    end
    if canUse then
        exports['av_laptop']:removeItem(source, name, 1, slot)
        TriggerClientEvent('av_drugs:useDrug',source, drugInfo, metadata)
    end
end