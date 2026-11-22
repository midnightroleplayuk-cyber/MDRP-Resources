-- Based on pickle_surgery by Pickle Mods (Pickle License, see LICENSE / CREDITS.md).
-- Modified for NDM_Surgery by NDM Development.

local surgeryActive = false
local surgeryTargets = {}
local surgeryBodyProps = {}
local surgeryTools = {}

function StartHeartSurgeryStep_1()
    local props = {
        {
            position = vector3(-0.01, -0.39, 0.07),
        },
        {
            position = vector3(-0.01, -0.34, 0.07),
        },
        {
            position = vector3(-0.01, -0.29, 0.07),
        },
        {
            position = vector3(-0.01, -0.24, 0.07),
        },
        {
            position = vector3(0.04, -0.19, 0.07),
        },
        {
            position = vector3(-0.06, -0.19, 0.07),
        },
    }
    for i=1, #props do 
        local pos = props[i].position
        props[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.saw then return end
                local brokenPoints = 0
                for i=1, #props do
                    if props[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif props[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        props[i].broken = true
                        DeleteHandTargetProp(props[i].targetId)
                    end
                end
                if #props <= brokenPoints then
                    ToggleHandTargetProp(surgeryTargets.rib, true)
                    CreateThread(function()
                        while not IsTargetMovedAway(surgeryTargets.rib, 0.35, surgeryBodyProps) do Wait(0) end
                        if not IsSurgeryActive() then return end
                        SetTimeout(50, StartHeartSurgeryStep_2)
                    end)
                end
            end
        })
    end
end

function StartHeartSurgeryStep_2()
    RemoveNotBleedingTargets()
    local bleedSpots = {
        AddBleedTarget(vector3(0.0, -0.19, 0.02), surgeryBodyProps.center, surgeryTools)
    }
    local props = {
        {
            position = vector3(-0.06, -0.19, 0.02),
        },
        {
            position = vector3(0.04, -0.19, 0.02),
        },
    }
    for i=1, #props do 
        local pos = props[i].position
        props[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #props do
                    if props[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif props[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        props[i].broken = true
                        DeleteHandTargetProp(props[i].targetId)
                    end
                end
                if #props <= brokenPoints then
                    ToggleHandTargetProp(surgeryTargets.upperIntestine, true)
                    CreateThread(function()
                        while not IsTargetMovedAway(surgeryTargets.upperIntestine, 0.35, surgeryBodyProps) do Wait(0) end
                        if not IsSurgeryActive() then return end
                        SetTimeout(50, StartHeartSurgeryStep_3)
                    end)
                end
            end
        })
    end
end

function StartHeartSurgeryStep_3()
    RemoveNotBleedingTargets()
    local bleedSpots = {
        AddBleedTarget(vector3(0.0, -0.16, 0.02), surgeryBodyProps.center, surgeryTools)
    }
    local props = {
        {
            position = vector3(-0.06, -0.16, 0.02),
        },
        {
            position = vector3(0.04, -0.16, 0.02),
        },
    }
    for i=1, #props do 
        local pos = props[i].position
        props[i].targetId = AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, pos.x, pos.y, pos.z), 0.0, { 
            draggable = false, 
            inside = function(targetId, dragId)
                if not dragId or dragId ~= surgeryTools.scalpel then return end
                local brokenPoints = 0
                for i=1, #props do
                    if props[i].broken then
                        brokenPoints = brokenPoints + 1
                    elseif props[i].targetId == targetId then
                        brokenPoints = brokenPoints + 1
                        props[i].broken = true
                        DeleteHandTargetProp(props[i].targetId)
                    end
                end
                if #props <= brokenPoints then
                    ToggleHandTargetProp(surgeryTargets.lowerIntestine, true)
                    CreateThread(function()
                        while not IsTargetMovedAway(surgeryTargets.lowerIntestine, 0.35, surgeryBodyProps) do Wait(0) end
                        if not IsSurgeryActive() then return end
                        SetTimeout(50, StartHeartSurgeryStep_4)
                    end)
                end
            end
        })
    end
end

function StartHeartSurgeryStep_4()
    RemoveNotBleedingTargets()
    local bleedSpots = {
        AddBleedTarget(vector3(-0.02, -0.38, 0.01), surgeryBodyProps.center, surgeryTools),
        AddBleedTarget(vector3(0.02, -0.38, 0.01), surgeryBodyProps.center, surgeryTools),
    }
    local propRemoved = {
        left = false,
        right = false
    }
    local routine = function(removed)
        propRemoved[removed] = true
        local unremoved = false
        for k,v in pairs(propRemoved) do 
            if not v then
                unremoved = true
            end
        end
        if not unremoved then
            SetTimeout(50, StartHeartSurgeryStep_5)
        end
    end
    -- Left
    AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.06, -0.38, 0.01), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(targetId)
            ToggleHandTargetProp(surgeryTargets.leftLung, true)
            CreateThread(function()
                while not IsTargetMovedAway(surgeryTargets.leftLung, 0.35, surgeryBodyProps) do Wait(0) end
                if not IsSurgeryActive() then return end
                routine("left")
            end)
        end
    })
    -- Right
    AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.06, -0.38, 0.01), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(targetId)
            ToggleHandTargetProp(surgeryTargets.rightLung, true)
            CreateThread(function()
                while not IsTargetMovedAway(surgeryTargets.rightLung, 0.35, surgeryBodyProps) do Wait(0) end
                if not IsSurgeryActive() then return end
                routine("right")
            end)
        end
    })
end

function StartHeartSurgeryStep_5()
    RemoveNotBleedingTargets()
    local bleedSpots = {
        AddBleedTarget(vector3(0.05 + 0.05,  -0.3, 0.005), surgeryBodyProps.center, surgeryTools),
        AddBleedTarget(vector3(0.05, -0.3 - 0.05, 0.005), surgeryBodyProps.center, surgeryTools),
        AddBleedTarget(vector3(-0.05 - 0.05, -0.3, 0.005), surgeryBodyProps.center, surgeryTools),
        AddBleedTarget(vector3(-0.05, -0.3 - 0.05, 0.005), surgeryBodyProps.center, surgeryTools)
    }
    local propRemoved = {
        left = false,
        center = false,
        right = false
    }
    local routine = function(removed)
        propRemoved[removed] = true
        local unremoved = false
        for k,v in pairs(propRemoved) do 
            if not v then
                unremoved = true
            end
        end
        if not unremoved then
            ToggleHandTargetProp(surgeryTargets.heart, true)
            CreateThread(function()
                while not IsTargetMovedAway(surgeryTargets.heart, 0.35, surgeryBodyProps) do Wait(0) end
                if not IsSurgeryActive() then return end
                SetTimeout(50, StartHeartSurgeryStep_6)
            end)
        end
    end
    -- Left
    AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.05,  -0.3, 0.005), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(targetId)
            CreateThread(function()
                routine("left")
            end)
        end
    })
    -- Center
    AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.35, 0.005), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(targetId)
            CreateThread(function()
                routine("center")
            end)
        end
    })
    -- Right
    AddHandTargetProp(`prop_golf_ball`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.05,  -0.3, 0.005), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTools.scalpel then return end
            DeleteHandTargetProp(targetId)
            CreateThread(function()
                routine("right")
            end)
        end
    })
end

function StartHeartSurgeryStep_6()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center,  0.0,  -0.3, -0.075), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.newHeart then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local heartId = AddHandTargetProp(`heart`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.3, -0.055), heading + 180.0, { 
                draggable = false,
                interactDistance = 0.05, 
                interactOffset = vector3(0.0, 0.0, -0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            SetTimeout(50, StartHeartSurgeryStep_7)
        end
    })
end

function StartHeartSurgeryStep_7()
    RemoveNotBleedingTargets()
    local propImplanted = {
        left = false,
        right = false
    }
    local routine = function(removed)
        propImplanted[removed] = true
        local unplanted = false
        for k,v in pairs(propImplanted) do 
            if not v then
                unplanted = true
            end
        end
        if not unplanted then
            SetTimeout(50, StartHeartSurgeryStep_8)
        end
    end
    -- Left
    AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.06,  -0.3, -0.03), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.leftLung then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local leftLungId = AddHandTargetProp(`left_lung`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center,  0.06,  -0.3, -0.03), vector3(0.0, -40.0, heading), { 
                draggable = false,
                interactDistance = 0.05, 
                interactOffset = vector3(0.0, 0.0, -0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            CreateThread(function()
                routine("left")
            end)
        end
    })
    -- Right
    AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.06,  -0.3, -0.03), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.rightLung then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local rightLungId = AddHandTargetProp(`right_lung`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.06,  -0.3, -0.03), vector3(0.0, 40.0, heading), { 
                draggable = false,
                interactDistance = 0.05, 
                interactOffset = vector3(0.0, 0.0, -0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            CreateThread(function()
                routine("right")
            end)
        end
    })
end

function StartHeartSurgeryStep_8()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.14, 0.0), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.lowerIntestine then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local lowerIntestineId = AddHandTargetProp(`lower_intestines`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.14, 0.0), heading + 180.0, { 
                draggable = false,
                interactDistance = 0.05, 
                interactOffset = vector3(0.0, 0.0, -0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            SetTimeout(50, StartHeartSurgeryStep_9)
        end
    })
end

function StartHeartSurgeryStep_9()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.14, 0.0), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.upperIntestine then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local upperIntestineId = AddHandTargetProp(`upper_intestines`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0, -0.14, 0.0), heading + 180.0, { 
                draggable = false,
                interactDistance = 0.05, 
                interactOffset = vector3(0.0, 0.0, -0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            SetTimeout(50, StartHeartSurgeryStep_10)
        end
    })
end

function StartHeartSurgeryStep_10()
    RemoveNotBleedingTargets()
    local targetBall = AddHandTargetProp(`prop_poolball_6`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.01, -0.30, -0.16), 0.0, { 
        draggable = false, 
        inside = function(targetId, dragId)
            if not dragId or dragId ~= surgeryTargets.rib then return end
            DeleteHandTargetProp(targetId)
            DeleteHandTargetProp(dragId)
            local heading = GetEntityHeading(surgeryBodyProps.center)
            local ribId = AddHandTargetProp(`ribs`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.01, -0.30, -0.16), vector3(0.0, 0.0, heading  - 180.0), { 
                draggable = false,
                interactDistance = 0.15, 
                interactOffset = vector3(0.0, 0.0, 0.0),
                dragOffset = vector3(0.0, 0.0, -0.06),
                attachment = {
                    position = vector3(0.12, 0.03, 0.01),
                    rotation = vector3(0.0, -90.0, 0.0),
                    boneId = 0xE5F3
                }
            })
            CompleteSurgery()
        end
    })
end

function StartHeartSurgeryProcess(tools)
    local heading = GetEntityHeading(surgeryBodyProps.center)
    local tools = tools or {
        saw = {
            position = vector3(0.3, -0.65, -0.1),
            heading = heading + 90.0,
        },
        scalpel = {
            position = vector3(0.20, -0.65, -0.1),
            heading = heading + 90.0,
        },
        syringe = {
            position = vector3(0.15, -0.65, -0.225),
            heading = vector3(90.0, 90.0, heading + 90.0),
        },
    }

    local sawId = AddHandTargetProp(`prop_cranial_saw`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, tools.saw.position.x, tools.saw.position.y, tools.saw.position.z), tools.saw.heading, { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(-0.1, 0.0, 0.0),
        attachment = {
            position = vector3(0.05, 0.05, 0.01),
            rotation = vector3(90.0, 180.0, 0.0),
            boneId = 0xE5F3
        }
    })
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
    local newHeartId = AddHandTargetProp(`heart`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.20, -0.65, -0.05), heading + 90.0, { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local lowerIntestineId = AddHandTargetProp(`lower_intestines`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.14, 0.0), heading + 180.0, { 
        draggable = true,
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local upperIntestineId = AddHandTargetProp(`upper_intestines`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0, -0.14, 0.0), heading + 180.0, { 
        draggable = true,
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local heartId = AddHandTargetProp(`sf_prop_sf_apple_01b`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, 0.0,  -0.3, -0.075), heading + 90.0, { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local leftLungId = AddHandTargetProp(`left_lung`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center,  0.06,  -0.3, -0.03), vector3(0.0, -40.0, heading), { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    
    local rightLungId = AddHandTargetProp(`right_lung`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.06,  -0.3, -0.03), vector3(0.0, 40.0, heading), { 
        interactDistance = 0.05, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })

    local ribId = AddHandTargetProp(`ribs`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.01, -0.30, -0.16), vector3(0.0, 0.0, heading  - 180.0), { 
        draggable = true,
        interactDistance = 0.15, 
        interactOffset = vector3(0.0, 0.0, 0.0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })
    local torsoId = AddHandTargetProp(`mrc_torso`, GetOffsetFromEntityInWorldCoords(surgeryBodyProps.center, -0.01, -0.26, -0.16), vector3(0.0, 0.0, heading - 180.0), { 
        enabled = false,
        draggable = false,
        interactDistance = 0.0, 
        interactOffset = vector3(0.0, 0.0, -0),
        dragOffset = vector3(0.0, 0.0, -0.06),
        attachment = {
            position = vector3(0.12, 0.03, 0.01),
            rotation = vector3(0.0, -90.0, 0.0),
            boneId = 0xE5F3
        }
    })

    ToggleHandTargetProp(lowerIntestineId, false)
    ToggleHandTargetProp(upperIntestineId, false)
    ToggleHandTargetProp(heartId, false)
    ToggleHandTargetProp(leftLungId, false)
    ToggleHandTargetProp(rightLungId, false)
    ToggleHandTargetProp(ribId, false)
    surgeryTargets["lowerIntestine"] = lowerIntestineId
    surgeryTargets["upperIntestine"] = upperIntestineId
    surgeryTargets["heart"] = heartId
    surgeryTargets["newHeart"] = newHeartId
    surgeryTargets["leftLung"] = leftLungId
    surgeryTargets["rightLung"] = rightLungId
    surgeryTargets["rib"] = ribId
    surgeryTargets["torso"] = torsoId
    surgeryTools = {
        saw = sawId,
        scalpel = scalpelId,
        syringe = syringeId,
    }
    StartHeartSurgeryStep_1()
end

function CleanupHeartSurgery()
    for k,v in pairs(surgeryBodyProps) do 
        DeleteEntity(v)
    end
    surgeryTargets = {}
    surgeryBodyProps = {}
    surgeryTools = {}
    RemoveBleedTargets()
    surgeryActive = false
end

function StartHeartSurgery(coords, heading, patientPed)
    surgeryActive = true
    surgeryBodyProps = CreateSurgeryBody(coords, heading, patientPed)
    StartHeartSurgeryProcess()
end