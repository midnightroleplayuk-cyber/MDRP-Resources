-- Based on pickle_surgery by Pickle Mods (Pickle License, see LICENSE / CREDITS.md).
-- Modified for NDM_Surgery by NDM Development.

local surgeryActive = false
local surgeryTargets = {}
local surgeryBodyProps = {}
local surgeryTools = {}
local surgeryRods = {}

function StartArmSurgeryStep_1()
    local armProps = {
        {
            position = vector3(-0.21, -0.368, -0.04),
        },
        {
            position = vector3(-0.23, -0.308, -0.04),
        },
    }
    for i=1, #armProps do 
        local pos = armProps[i].position
        AddBleedTarget(vector3(pos.x + 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        AddBleedTarget(vector3(pos.x - 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        armProps[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #armProps do
                    if armProps[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif armProps[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        armProps[i].broken = true
                        DeleteHandTargetProp(armProps[i].targetId)
                    end
                end
                if #armProps <= brokenPoints then
                    SetTimeout(50, StartArmSurgeryStep_2)
                end
            end
        })
    end
end

function StartArmSurgeryStep_2()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.21, -0.368, -0.04), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId then return end
            local found = false
            for k,v in pairs(surgeryRods) do 
                if k == dragId and not v.implanted then
                    found = true
                    surgeryRods[k].implanted = true
                end
            end
            if not found then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            SetTimeout(50, StartArmSurgeryStep_3)
        end
    })
end

function StartArmSurgeryStep_3()
    local armProps = {
        {
            position = vector3(-0.28, -0.068, 0.02),
        },
        {
            position = vector3(-0.31, -0.008, 0.02),
        },
    }
    for i=1, #armProps do 
        local pos = armProps[i].position
        AddBleedTarget(vector3(pos.x + 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        AddBleedTarget(vector3(pos.x - 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        armProps[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #armProps do
                    if armProps[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif armProps[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        armProps[i].broken = true
                        DeleteHandTargetProp(armProps[i].targetId)
                    end
                end
                if #armProps <= brokenPoints then
                    SetTimeout(50, StartArmSurgeryStep_4)
                end
            end
        })
    end
end

function StartArmSurgeryStep_4()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.28, -0.068, 0.04), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId then return end
            local found = false
            for k,v in pairs(surgeryRods) do 
                if k == dragId and not v.implanted then
                    found = true
                    surgeryRods[k].implanted = true
                end
            end
            if not found then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            SetTimeout(50, StartArmSurgeryStep_5)
        end
    })
end

function StartArmSurgeryStep_5()
    local armProps = {
        {
            position = vector3(0.21, -0.368, 0.04),
        },
        {
            position = vector3(0.23, -0.308, 0.04),
        },
    }
    for i=1, #armProps do 
        local pos = armProps[i].position
        AddBleedTarget(vector3(pos.x + 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        AddBleedTarget(vector3(pos.x - 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        armProps[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #armProps do
                    if armProps[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif armProps[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        armProps[i].broken = true
                        DeleteHandTargetProp(armProps[i].targetId)
                    end
                end
                if #armProps <= brokenPoints then
                    SetTimeout(50, StartArmSurgeryStep_6)
                end
            end
        })
    end
end

function StartArmSurgeryStep_6()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.21, -0.368, 0.04), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId then return end
            local found = false
            for k,v in pairs(surgeryRods) do 
                if k == dragId and not v.implanted then
                    found = true
                    surgeryRods[k].implanted = true
                end
            end
            if not found then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            SetTimeout(50, StartArmSurgeryStep_7)
        end
    })
end

function StartArmSurgeryStep_7()
    local armProps = {
        {
            position = vector3(0.31, -0.068, 0.02),
        },
        {
            position = vector3(0.28, -0.008, 0.02),
        },
    }
    for i=1, #armProps do 
        local pos = armProps[i].position
        AddBleedTarget(vector3(pos.x + 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        AddBleedTarget(vector3(pos.x - 0.05, pos.y, pos.z), surgeryBodyProps.center, surgeryTools)
        armProps[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #armProps do
                    if armProps[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif armProps[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        armProps[i].broken = true
                        DeleteHandTargetProp(armProps[i].targetId)
                    end
                end
                if #armProps <= brokenPoints then
                    SetTimeout(50, StartArmSurgeryStep_8)
                end
            end
        })
    end
end

function StartArmSurgeryStep_8()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.31, -0.068, 0.02), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId then return end
            local found = false
            for k,v in pairs(surgeryRods) do 
                if k == dragId and not v.implanted then
                    found = true
                    surgeryRods[k].implanted = true
                end
            end
            if not found then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            SetTimeout(250, function() CompleteSurgery() end)
        end
    })
end

function StartArmSurgeryProcess(tools)
    local heading = GetEntityHeading(surgeryBodyProps.center)
    local tools = tools or {
        scalpel = {
            position = vector3(0.25, -0.65, -0.1),
            heading = heading + 90.0,
        },
        syringe = {
            position = vector3(0.20, -0.65, -0.225),
            heading = vector3(90.0, 90.0, heading + 90.0),
        },
    }
    local scalpelId = AddHandTargetProp(`prop_scalpel`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, tools.scalpel.position.x, tools.scalpel.position.y, tools.scalpel.position.z), tools.scalpel.heading, { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(-0.06, 0.0, 0.0),
        attachment = {
            position = vector3(0.1, 0.03, 0.02),
            rotation = vector3(0.0, 180.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local syringeId = AddHandTargetProp(`prop_syringe_01`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, tools.syringe.position.x, tools.syringe.position.y, tools.syringe.position.z), tools.syringe.heading, { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    surgeryRods = {}
    for i=1, 4 do 
        local index = AddHandTargetProp(`h4_prop_battle_sniffing_pipe`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.35 + (0.05 * i), -0.65, -0.05), heading, { 
            interactDistance = 0.05, 
            interactOffset = vector3(0.0, 0.0, -0),
            dragOffset = vector3(0.0, 0.0, -0.06),
            attachment = {
                position = vector3(0.12, 0.03, 0.01),
                rotation = vector3(0.0, -90.0, 0.0),
                boneId = 0xE5F3
            }
        })
        surgeryRods[index] = {
            implanted = false,
        }
    end 
    surgeryTools = {
        scalpel = scalpelId,
        syringe = syringeId,
    }
    StartArmSurgeryStep_1()
end

function CleanupArmSurgery()
    for k,v in pairs(surgeryBodyProps) do 
        DeleteEntity(v)
    end
    surgeryTargets = {}
    surgeryRods = {}
    surgeryBodyProps = {}
    surgeryTools = {}
    RemoveBleedTargets()
    surgeryActive = false
end

function StartArmSurgery(coords, heading, patientPed)
    surgeryActive = true
    surgeryBodyProps = CreateSurgeryBody(coords, heading, patientPed, "closed")
    StartArmSurgeryProcess()
end

