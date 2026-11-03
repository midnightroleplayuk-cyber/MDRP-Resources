Config = Config or {}

Config.SpawnBloodProp = false -- Whether to spawn a prop for blood donation, for example a chair if your mlo does not have any free seats. PROP CAN BE CHANGED IN LOCATIONS.LUA
Config.BloodChairOffsetZ = 1.50 -- How much to lower the player when sitting in a blood donation chair

Config.BloodDrawTime = 1000 -- Time it should take to complete blood donation
Config.BloodAnalysisTime = 5000 -- Time it should take to analyse a blood sample
Config.drawBlood = "E"
Config.drawBloodSample = "G"
Config.BloodDrawAnim = {
    name = "gang_chatting_idle01",
    dict = "anim@heists@narcotics@funding@gang_idle",
}

Config.decayTick = 5*60*1000 -- Time between decay checks, raise if you want to reduce performance impact. Recommended to keep at 5000 or above.

Config.Decay = true -- Allow for blood items to decay while in inventory. Currently tested with ox inventory on esx framework and new qb inventory on qb framework
Config.decayTime = 60*60*1000 -- Time for blood to decay while in inventory

Config.RequireAnalysis = true -- To skip blood analysis, set to false on unsupported inventories, e.g esx default inventory

Config.bloodTypes = {
    ['O-']  = { itemName = 'ominus', compatible = {'O-'} },
    ['O+']  = { itemName = 'oplus',  compatible = {'O-', 'O+'} },
    ['B-']  = { itemName = 'bminus', compatible = {'O-', 'B-'} },
    ['B+']  = { itemName = 'bplus',  compatible = {'O-', 'O+', 'B-', 'B+'} },
    ['A-']  = { itemName = 'aminus', compatible = {'O-', 'A-'} },
    ['A+']  = { itemName = 'aplus',  compatible = {'O-', 'O+', 'A-', 'A+'} },
    ['AB-'] = { itemName = 'abminus', compatible = {'O-', 'A-', 'B-', 'AB-'} },
    ['AB+'] = { itemName = 'abplus', compatible = {'O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'} }
}
 
local bloodVolumes = {
    {name = "500ml", volume = 500, timeToInject = 240*1000}
}

-- USAGE OF COMPATIBLE AND INCOMPATIBLE BLOOD PACKS 

local bAppliedS1 = false
local bAppliedS2 = false
local bAppliedS3 = false

local function ensureConflictingBlood()
    if type(BodyDamage.BodyPartDamage.ConflictingBlood) ~= 'table' then
        BodyDamage.BodyPartDamage.ConflictingBlood = { stage = 0, tick = 0 }
    end
    return BodyDamage.BodyPartDamage.ConflictingBlood
end

for bloodType, bloodData in pairs(Config.bloodTypes) do
    for _, volume in pairs(bloodVolumes) do
        table.insert(Config.Medication, {
            itemName = "blood"..volume.name.."_"..bloodData.itemName,
            type = "infusion",
            anim = {
                name = "gang_chatting_idle01",
                dict = "anim@heists@narcotics@funding@gang_idle",
            },
            lang = GetLang().progress.injected_blood_pack,
            langUsed = GetLang().vitals["injected_blood_pack"..volume.name],
            buttonLang = (GetLang().buttons["blood_pack"..volume.name] or ("Blood Pack "..volume.name)).." "..bloodType,
            time = 8000,
            removeItem = true,
            volume = volume.volume,
            injectingTime = volume.timeToInject,
            onUse = function(self)
                ensureConflictingBlood()
                bAppliedS2 = false
                bAppliedS3 = false
            end,
            onTick = function(self)
                while not PlayerLoaded do Wait(100) end
                local conflictingBlood = ensureConflictingBlood()
                local playerBloodType = BodyDamage.bloodType
                local bCompatible = isBloodCompatible(playerBloodType, bloodType)
                local health = GetEntityHealth(PlayerPedId())

                if bCompatible then
                    if BodyDamage.BodyPartDamage.BloodLevel < 6 then
                        local bloodbuff = (self.volume/1000)/self.injectingTime
                        BodyDamage.BodyPartDamage.BloodLevel = BodyDamage.BodyPartDamage.BloodLevel + bloodbuff
                    end
                else 
                    -- APPLY NEGATIVE EFFECTS IF INCOMPATIBLE
                    -- IF YOU USE THE SYSTEM BELOW, MAKE SURE THAT TOTAL TICK IS NOT ABOVE timeToInject 
                    -- 1 TICK IS 1 SECOND

                    conflictingBlood.tick = conflictingBlood.tick + 1

                    DebugPrint('conflicting blood, tick is: ', conflictingBlood.tick)
                
                
                    local stage = conflictingBlood.stage
                    if stage == 1 then
                        if conflictingBlood.tick > 120 then
                            conflictingBlood.stage = 2
                            conflictingBlood.tick = 0
                            DebugPrint("Moving to stage 2")
                        end

                        -- APPLY FIRST STAGE SYMPTOMS
                        if health > 50 then
                            SetEntityHealth(PlayerPedId(), health - 1)
                        end

                        if not bAppliedS1 then
                            DebugPrint("Applying first stage symptoms")
                            ChangeBPM(true)
                            bAppliedS1 = true
                        end

                    elseif stage == 2 then
                        if conflictingBlood.tick > 120 then
                            conflictingBlood.stage = 3
                            conflictingBlood.tick = 0
                            DebugPrint("Moving to stage 3")
                        end

                        -- APPLY SECOND STAGE SYMPTOMS
                        if not bAppliedS2 then
                            DebugPrint("Applying second stage symptoms")
                            ShakeGameplayCam("DRUNK_SHAKE", 1.0)
                            bAppliedS2 = true
                        end
                    elseif stage == 3 then
                        -- APPLY THIRD STAGE SYMPTOMS
                        if not bAppliedS3 then
                            DebugPrint("Applying third stage symptoms")
                            StopGameplayCamShaking(true)
                            SetEntityHealth(PlayerPedId(), 0)
                            conflictingBlood.tick = 0
                            bAppliedS3 = true
                        end
                    end
                end
            end,
            onFinish = function(self)
                local conflictingBlood = ensureConflictingBlood()
                conflictingBlood.stage = 1
                conflictingBlood.tick = 0
            end,
            lockAccess = true,
            bloodType = bloodType
        })
    end
end