local InteriorId = GetInteriorAtCoords(1753.6223, 3804.6450, 35.4474)

-- Texto de los IPLS
local IPL_LABELS = {
    ["p_prompt_sandy_cityhall_fences_backopened"] = "Back Fences (Open)",
    ["p_prompt_sandy_cityhall_backtables"] = "Back Tables",
    ["p_prompt_sandy_cityhall_tables"] = "Tables",
    ["p_prompt_sandy_cityhall_coffin_closed"] = "Coffin (Closed)",
    ["p_prompt_sandy_cityhall_coffin_opened"] = "Coffin (Open)",
    ["p_prompt_sandy_cityhall_fences_backclosed"] = "Back Fences (Closed)",
    ["p_prompt_sandy_cityhall_funeral_chairs"] = "Funeral Chairs",
    ["p_prompt_sandy_cityhall_funeral_picture"] = "Funeral Picture",
    ["p_prompt_sandy_cityhall_leaves"] = "Leaves",
    ["p_prompt_sandy_cityhall_wedding_chairs"] = "Wedding Chairs",
    ["p_prompt_sandy_cityhall_wedding_spotlight"] = "Wedding Spotlight",
    ["p_prompt_sandy_cityhall_wedding_venue"] = "Wedding Venue",
}

-- Configuraciones predefinidas para eventos
local PRECONFIGURACIONES = {
    ["Dinner (Opened Back)"] = {
        "p_prompt_sandy_cityhall_backtables",
        "p_prompt_sandy_cityhall_tables",
        "p_prompt_sandy_cityhall_fences_backopened"
    },
    ["Dinner (Closed Back)"] = {
        "p_prompt_sandy_cityhall_tables",
        "p_prompt_sandy_cityhall_fences_backclosed"
    },
    ["Wedding Ceremony"] = {
        "p_prompt_sandy_cityhall_fences_backclosed",
        "p_prompt_sandy_cityhall_wedding_chairs",
        "p_prompt_sandy_cityhall_wedding_spotlight",
        "p_prompt_sandy_cityhall_wedding_venue",
        "p_prompt_sandy_cityhall_leaves"
    },
    ["Funeral"] = {
        "p_prompt_sandy_cityhall_fences_backclosed",
        "p_prompt_sandy_cityhall_funeral_chairs",
        "p_prompt_sandy_cityhall_funeral_picture",
        "p_prompt_sandy_cityhall_leaves",
        "p_prompt_sandy_cityhall_coffin_closed"
    },
}

-- Textos de los Entity Sets 
local ENTITY_SET_LABELS = {
    ["static_elevator"] = "Static Elevator",
    ["conference_chairs"] = "Conference Chairs",
    ["conference_meeting_table"] = "Meeting Table",
    ["eventroom_voting"] = "Voting Room"
}

-- Declaración anticipada de las funciones de menú
local showMainMenu, showManualMenu, showPreconfiguradoMenu, showEntitySetsMenu

-- Función para alternar (activar/desactivar) un IPL
local function toggleIPL(ipl, menuCallback)
    local currentState = IsIplActive(ipl)
    TriggerServerEvent('ipls:sync:toggleIPL', ipl, not currentState)
    -- Pequeño delay para dar tiempo a que se aplique el cambio
    SetTimeout(100, function()
        menuCallback()
    end)
end

-- Función para alternar (activar/desactivar) un Entity Set
local function toggleEntitySet(entitySet)
    local currentState = IsInteriorEntitySetActive(InteriorId, entitySet)
    TriggerServerEvent('ipls:sync:toggleEntitySet', entitySet, not currentState)
    -- Pequeño delay para dar tiempo a que se aplique el cambio
    SetTimeout(100, function()
        showEntitySetsMenu()
    end)
end

-- Función para retornar un icono basado en el estado activo/inactivo
local function getIcon(state)
    return state and 'fas fa-check' or 'fas fa-times'
end

-- Función para verificar si una configuración está completamente activa
local function isConfigurationActive(listaIPLS)
    for _, ipl in ipairs(listaIPLS) do
        if not IsIplActive(ipl) then
            return false
        end
    end
    return true
end

-- Menú de activación manual de cada IPL
showManualMenu = function()
    local menuOptions = {}

    for ipl, label in pairs(IPL_LABELS) do
        local isActive = IsIplActive(ipl)
        table.insert(menuOptions, {
            title = label,
            icon = getIcon(isActive),
            description = isActive and "Enabled" or "Disabled",
            onSelect = function()
                toggleIPL(ipl, showManualMenu)
            end
        })
    end

    lib.registerContext({
        id = 'ipls_manual_menu',
        title = 'IPLS - Manual',
        menu = 'ipls_main_menu',
        onBack = function()
            showMainMenu()
        end,
        options = menuOptions,
    })

    lib.showContext('ipls_manual_menu')
end

-- Menú de Entity Sets
showEntitySetsMenu = function()
    local menuOptions = {}

    for entitySet, label in pairs(ENTITY_SET_LABELS) do
        local isActive = IsInteriorEntitySetActive(InteriorId, entitySet)
        table.insert(menuOptions, {
            title = label,
            icon = getIcon(isActive),
            description = isActive and "Enabled" or "Disabled",
            onSelect = function()
                toggleEntitySet(entitySet)
            end
        })
    end

    lib.registerContext({
        id = 'entity_sets_menu',
        title = 'Entity Sets',
        menu = 'ipls_main_menu',
        onBack = function()
            showMainMenu()
        end,
        options = menuOptions,
    })

    lib.showContext('entity_sets_menu')
end

-- Menú de configuraciones preestablecidas
showPreconfiguradoMenu = function()
    local menuOptions = {}

    for grupo, listaIPLS in pairs(PRECONFIGURACIONES) do
        local isActive = isConfigurationActive(listaIPLS)
        table.insert(menuOptions, {
            title = grupo,
            icon = getIcon(isActive),
            description = isActive and "Configuration active" or "Configuration inactive",
            onSelect = function()
                local activar = false
                for _, ipl in ipairs(listaIPLS) do
                    if not IsIplActive(ipl) then
                        activar = true
                        break
                    end
                end
                for _, ipl in ipairs(listaIPLS) do
                    if activar and not IsIplActive(ipl) then
                        toggleIPL(ipl, showPreconfiguradoMenu)
                    elseif (not activar) and IsIplActive(ipl) then
                        toggleIPL(ipl, showPreconfiguradoMenu)
                    end
                end
            end
        })
    end

    lib.registerContext({
        id = 'ipls_preconfigurado_menu',
        title = 'IPLS - Presets',
        menu = 'ipls_main_menu',
        onBack = function()
            showMainMenu()
        end,
        options = menuOptions,
    })

    lib.showContext('ipls_preconfigurado_menu')
end

-- Menú principal
showMainMenu = function()
    lib.registerContext({
        id = 'ipls_main_menu',
        title = 'IPLS Manager',
        options = {
            {
                title = 'Presets',
                icon = 'fas fa-list',
                onSelect = function()
                    showPreconfiguradoMenu()
                end
            },
            {
                title = 'Manual',
                icon = 'fas fa-wrench',
                onSelect = function()
                    showManualMenu()
                end
            },
            {
                title = 'Entity Sets',
                icon = 'fas fa-cube',
                onSelect = function()
                    showEntitySetsMenu()
                end
            }
        }
    })

    lib.showContext('ipls_main_menu')
end

-- Registro del comando '/cityhall' para abrir el menú
RegisterCommand("cityhall", function()
    showMainMenu()
end, false)

-- También se puede registrar un evento para abrir el menú desde otro recurso
RegisterNetEvent("ipls:openMenu", function()
    showMainMenu()
end)

-- Handlers para GlobalState
AddStateBagChangeHandler('ipls', 'global', function(bagName, key, value)
    if value then
        for ipl, state in pairs(value) do
            if state then
                RequestIpl(ipl)
            else
                RemoveIpl(ipl)
            end
        end
    end
end)

AddStateBagChangeHandler('entitySets', 'global', function(bagName, key, value)
    if value then
        for entitySet, state in pairs(value) do
            if state then
                ActivateInteriorEntitySet(InteriorId, entitySet)
                RefreshInterior(InteriorId)
            else
                DeactivateInteriorEntitySet(InteriorId, entitySet)
                RefreshInterior(InteriorId)
            end
        end
    end
end)