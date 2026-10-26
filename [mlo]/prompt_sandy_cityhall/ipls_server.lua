-- Inicializar estados en GlobalState
CreateThread(function()
    -- IPLs
    if not GlobalState.ipls then
        GlobalState.ipls = {
            p_prompt_sandy_cityhall_fences_backopened = false,
            p_prompt_sandy_cityhall_backtables = false,
            p_prompt_sandy_cityhall_tables = false,
            p_prompt_sandy_cityhall_coffin_closed = false,
            p_prompt_sandy_cityhall_coffin_opened = false,
            p_prompt_sandy_cityhall_fences_backclosed = false,
            p_prompt_sandy_cityhall_funeral_chairs = false,
            p_prompt_sandy_cityhall_funeral_picture = false,
            p_prompt_sandy_cityhall_leaves = false,
            p_prompt_sandy_cityhall_wedding_chairs = false,
            p_prompt_sandy_cityhall_wedding_spotlight = false,
            p_prompt_sandy_cityhall_wedding_venue = false
        }
    end

    -- Entity Sets
    if not GlobalState.entitySets then
        GlobalState.entitySets = {
            static_elevator = false,
            conference_chairs = false,
            conference_meeting_table = false,
            eventroom_voting = false
        }
    end
end)

-- Event handlers para actualizar GlobalState
RegisterNetEvent('ipls:sync:toggleIPL', function(ipl, state)
    local ipls = GlobalState.ipls
    ipls[ipl] = state
    GlobalState.ipls = ipls
end)

RegisterNetEvent('ipls:sync:toggleEntitySet', function(entitySet, state)
    local entitySets = GlobalState.entitySets
    entitySets[entitySet] = state
    GlobalState.entitySets = entitySets
end)
