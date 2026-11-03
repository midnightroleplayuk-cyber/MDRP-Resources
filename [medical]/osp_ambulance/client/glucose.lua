local function GlucoseItemName()
    return Config.GlucoseItem or 'glucose'
end

local function IsDownedState(bodyDamage)
    return type(bodyDamage) == 'table' and (bodyDamage.isDead == true or bodyDamage.inLastStand == true)
end

local function GetNearbyDownedPatients()
    local coords = GetEntityCoords(PlayerPedId())
    local radius = Config.MedicalMenuMaxDistance or 10.0
    local nearby = lib.getNearbyPlayers(coords, radius, false)
    local patients = {}
    for i = 1, #nearby do
        local serverId = GetPlayerServerId(nearby[i].id)
        local bodyDamage = Player(serverId).state.BodyDamage
        if IsDownedState(bodyDamage) then
            patients[#patients + 1] = {
                id = serverId,
                name = GetPlayerName(nearby[i].id),
                needsGlucose = bodyDamage.needsGlucose == true,
            }
        end
    end
    return patients
end

local function AdministerGlucose(targetId)
    if not IsEmsStaff() then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.not_authorized, 3000, 'error')
        return
    end

    targetId = tonumber(targetId)
    if not targetId or targetId == GetPlayerServerId(PlayerId()) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.you_cant_interact_with_yourself, 3000, 'error')
        return
    end

    if getPlayerDistance(targetId) > (Config.MedicalMenuMaxDistance or 10.0) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.player_too_far_away, 3000, 'error')
        return
    end

    local bodyDamage = Player(targetId).state.BodyDamage
    if not IsDownedState(bodyDamage) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.glucose_not_downed, 3000, 'error')
        return
    end

    if bodyDamage.needsGlucose ~= true then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.glucose_no_effect, 3000, 'error')
        return
    end

    if not ProgressBar(GetLang().progress.giving_glucose, Config.GlucoseUseTime or 4000, 'mp_common', 'givetake1_a') then
        return
    end

    TriggerServerEvent('osp_ambulance:useGlucoseSv', targetId)
end

local function OpenGlucoseMenu()
    if not IsEmsStaff() then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.not_authorized, 3000, 'error')
        return
    end

    local patients = GetNearbyDownedPatients()
    if #patients == 0 then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.glucose_not_downed, 3000, 'error')
        return
    end

    if #patients == 1 then
        AdministerGlucose(patients[1].id)
        return
    end

    local options = {}
    for i = 1, #patients do
        local patient = patients[i]
        options[#options + 1] = {
            title = patient.name,
            description = (GetLang().wheelchair.player_id or 'ID:') .. ' ' .. patient.id,
            icon = 'fa-solid fa-user',
            onSelect = function()
                AdministerGlucose(patient.id)
            end,
        }
    end

    registerContext({
        id = 'glucose_patients',
        title = 'Glucose Tablet',
        options = options,
    })
    showContext('glucose_patients')
end

RegisterNetEvent('osp_ambulance:useGlucose', function()
    OpenGlucoseMenu()
end)

RegisterNUICallback('GlucoseTablet', function(data, cb)
    cb('ok')
    if RejectInsurvivableTreatment and RejectInsurvivableTreatment(data.PlayerId) then
        return
    end
    SetNuiFocus(false, false)
    SendNUIMessage({ display = false })
    AdministerGlucose(data.PlayerId)
end)
