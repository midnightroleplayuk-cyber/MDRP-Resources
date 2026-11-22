-- Based on pickle_surgery by Pickle Mods (Pickle License, see LICENSE / CREDITS.md).
-- Modified for NDM_Surgery by NDM Development.

local bleedTargets = {}

function AddBleedTarget(coords, center, surgeryTools) 
    local index
    repeat
        index = math.random(1, 999999) .. "_" .. math.random(1, 999999)
    until not bleedTargets[index]
    local targetId = AddHandTargetProp(`prop_golf_ball_p2`, GetOffsetFromEntityInWorldCoords(center, coords.x, coords.y, coords.z), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not bleedTargets[index] then return end
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(bleedTargets[index].targetId)
            bleedTargets[index].bleeding = true
            bleedTargets[index].targetId = AddHandTargetProp(`prop_golf_ball_p4`, GetOffsetFromEntityInWorldCoords(center, coords.x, coords.y, coords.z), 0.0, { 
                draggable = false, 
                inside = function(targetId, dragId)
                    if not dragId or dragId ~= surgeryTools.syringe then return end
                    DeleteHandTargetProp(bleedTargets[index].targetId)
                    bleedTargets[index] = nil
                end
            })
            CreateThread(function() 
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do 
                    Wait(0) 
                end
                while bleedTargets[index] do 
                    UseParticleFxAssetNextCall("core")
                    StartParticleFxNonLoopedOnEntity("td_blood_throat", GetHandTargetProp(bleedTargets[index].targetId).entity, 0.0, 0.0, 0.0, 45.0, 0.0, 0.0, 1.0)
                    Wait(100)
                end
            end)
        end
    })
    bleedTargets[index] = {
        bleeding = false,
        targetId = targetId
    }
    return index
end

function RemoveNotBleedingTargets(array)
    if array then
        for i=1, #array do 
            if bleedTargets[array[i]] and not bleedTargets[array[i]].bleeding then
                DeleteHandTargetProp(bleedTargets[array[i]].targetId)
                bleedTargets[array[i]] = nil
            end
        end
    else
        for k,v in pairs(bleedTargets) do 
            if not v.bleeding then
                DeleteHandTargetProp(bleedTargets[k].targetId)
                bleedTargets[k] = nil
            end
        end
    end
end

function RemoveBleedTargets()
    for k,v in pairs(bleedTargets) do 
        DeleteHandTargetProp(bleedTargets[k].targetId)
        bleedTargets[k] = nil
    end
end

function GetBleedingCount()
    local count = 0
    for k,v in pairs(bleedTargets) do 
        if v.bleeding then
            count = count + 1
        end
    end
    return count
end
