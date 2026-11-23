local pharmacyPeds = {}
local pharmacyPoly = {}
local pharmacyTargetIds = {}
local pharmacyTargetNames = {}
local pharmacyCheck = false

local function PharmacyControls()
    CreateThread(function()
        pharmacyCheck = true
        while pharmacyCheck do
            if IsControlJustPressed(0, 38) then
                OpenPharmacyMenu()
            end
            Wait(3)
        end
    end)
end

local function SetupPharmacyZone(hospitalId, index, coords)
    local function onEnter(self)
        textUi(GetLang().text.pharmacy_button)
        PharmacyControls()
    end

    local function onExit(self)
        pharmacyCheck = false
        removeTextUi()
    end

    pharmacyPoly[#pharmacyPoly + 1] = lib.zones.box({
        coords = vec3(coords.x, coords.y, coords.z),
        name = 'hospital-pharmacy-' .. hospitalId .. '-' .. index,
        size = vec3(3.5, 3.5, 2.0),
        rotation = coords.w or 0,
        debug = false,
        onEnter = onEnter,
        onExit = onExit,
    })
end

local function PrescriptionLang()
    local current = GetLang()
    if current and current.prescriptions then
        return current.prescriptions
    end
    return (lang['en'] and lang['en'].prescriptions) or {}
end

local function GetConditionLabel(conditionId)
    for _, condition in pairs(Config.PrescriptionConditions or {}) do
        if condition.id == conditionId then
            return condition.label
        end
    end
end

local function MedicationTreatsLabel(medication)
    local labels = {}
    for _, conditionId in pairs(medication.treatsConditions or {}) do
        local label = GetConditionLabel(conditionId)
        if label then
            labels[#labels + 1] = label
        end
    end
    if #labels == 0 then
        return GetLang().prescriptions.medication_desc
    end
    return table.concat(labels, ', ')
end

local function GetMedicationById(medicationId)
    for _, medication in ipairs(Config.PrescriptionMedications or {}) do
        if medication.id == medicationId then
            return medication
        end
    end
end

local function CollectNotepadPatients(preferredId)
    local myId = GetPlayerServerId(PlayerId())
    local ids = { myId }
    local seen = { [myId] = true }
    local coords = GetEntityCoords(PlayerPedId())
    local radius = Config.MedicalMenuMaxDistance or 10.0
    local closestPlayers = (lib.getNearbyPlayers and lib.getNearbyPlayers(coords, radius, false)) or {}
    for i = 1, #closestPlayers do
        local serverId = GetPlayerServerId(closestPlayers[i].id)
        if serverId and not seen[serverId] then
            seen[serverId] = true
            ids[#ids + 1] = serverId
        end
    end
    preferredId = tonumber(preferredId)
    if preferredId and not seen[preferredId] then
        ids[#ids + 1] = preferredId
    end

    local names = lib.callback.await('osp_ambulance:getCharacterNames', false, ids) or {}
    local patients = {}
    for i = 1, #ids do
        local id = ids[i]
        local name = names[tostring(id)]
        if type(name) ~= 'string' or name == '' or name == 'Unknown' then
            name = 'Unknown'
        end
        if id == myId then
            name = name .. ' (You)'
        end
        patients[#patients + 1] = {
            value = id,
            label = name,
        }
    end
    return patients
end

local notepadOpen = false

local function OpenPrescriptionNotepad(preferredId)
    if notepadOpen then return end
    notepadOpen = true

    local pLang = PrescriptionLang()
    local patients = CollectNotepadPatients(tonumber(preferredId))
    local medications = {}
    local maxQuantity = 10
    for _, medication in ipairs(Config.PrescriptionMedications or {}) do
        medications[#medications + 1] = {
            value = medication.id,
            label = medication.label .. ' — ' .. MedicationTreatsLabel(medication),
        }
        if (medication.maxQuantity or 10) > maxQuantity then
            maxQuantity = medication.maxQuantity or 10
        end
    end

    if #medications == 0 then
        notepadOpen = false
        return
    end

    ExecuteCommand('e notepad')
    local input = lib.inputDialog(pLang.dialog_title or pLang.notepad, {
        {
            type = 'select',
            label = pLang.select_patient or 'Patient',
            options = patients,
            default = tonumber(preferredId) or patients[1].value,
            required = true,
        },
        {
            type = 'select',
            label = pLang.medication,
            description = pLang.medication_desc,
            options = medications,
            required = true,
        },
        {
            type = 'number',
            label = pLang.quantity,
            description = pLang.quantity_desc,
            default = 2,
            min = 1,
            max = maxQuantity,
            required = true,
        },
        {
            type = 'number',
            label = pLang.expiry_days,
            description = pLang.expiry_days_desc,
            default = Config.PrescriptionExpiryDays or 2,
            min = 1,
            max = 30,
            required = true,
        },
    })

    ExecuteCommand('e c')
    notepadOpen = false
    if not input then return end

    local medication = GetMedicationById(input[2])
    if not medication then return end

    local quantity = math.floor(tonumber(input[3]) or 1)
    if quantity < 1 then quantity = 1 end
    if quantity > (medication.maxQuantity or 10) then
        quantity = medication.maxQuantity or 10
    end

    TriggerServerEvent('osp_ambulance:issuePrescriptionSv', tonumber(input[1]), {
        medicationId = input[2],
        quantity = quantity,
        expiryDays = tonumber(input[4]) or Config.PrescriptionExpiryDays,
    })
end

RegisterNetEvent('osp_ambulance:usePrescriptionNotepad', function()
    OpenPrescriptionNotepad()
end)

AddEventHandler('osp_ambulance:usePrescriptionNotepad', function()
    OpenPrescriptionNotepad()
end)

exports('prescription_pad', function()
    OpenPrescriptionNotepad()
end)

exports('prescription_notepad', function()
    OpenPrescriptionNotepad()
end)

RegisterCommand('prescriptionpad', function()
    OpenPrescriptionNotepad()
end, false)

RegisterNetEvent('osp_ambulance:issuePrescription', function(targetId)
    OpenPrescriptionNotepad(targetId)
end)

local function IsPrescriptionExpired(info)
    if not info then return true end
    if info.expiryTimestamp then
        return GetServerTime() > tonumber(info.expiryTimestamp)
    end
    return false
end

-- Prevents errors when doing multiple prescription checks in a short time frame
-- Like opening the pharmacy menus
local prescriptionCache = nil
local prescriptionCacheTime = 0
local PRESCRIPTION_CACHE_DURATION = 5000 -- 5 seconds

local function GetValidPrescriptions(forceRefresh)
    local now = GetGameTimer()

    if not forceRefresh
        and prescriptionCache
        and (now - prescriptionCacheTime) < PRESCRIPTION_CACHE_DURATION
    then
        return prescriptionCache
    end

    local prescriptions = {}
    local inventory = Inventory[GetInventoryTool()].GetInventory()

    for _, item in pairs(inventory or {}) do
        local itemName = item.name or item.item
        local info = item.info or item.metadata

        if itemName == 'prescription' and info then
            local quantity = tonumber(info.quantity) or 0
            local dispensed = tonumber(info.dispensed) or 0

            if not IsPrescriptionExpired(info) and dispensed < quantity then
                prescriptions[#prescriptions + 1] = {
                    slot = item.slot,
                    info = info,
                    remaining = quantity - dispensed,
                }
            end
        end
    end

    prescriptionCache = prescriptions
    prescriptionCacheTime = now

    return prescriptions
end

RegisterNUICallback('IssuePrescription', function(data, cb)
    if RejectInsurvivableTreatment(data.PlayerId) then
        cb('ok')
        return
    end
    SetNuiFocus(false, false)
    SendNUIMessage({ display = false })
    TriggerEvent('osp_ambulance:issuePrescription', data.PlayerId)
    cb('ok')
end)

RegisterNUICallback('GetPatientPrescriptions', function(data, cb)
    if not IsEmsStaff() then
        cb({})
        return
    end

    local prescriptions = lib.callback.await('osp_ambulance:getPatientPrescriptions', 2000, data.PlayerId) or {}
    cb(prescriptions)
end)

RegisterNUICallback('DeletePrescription', function(data, cb)
    local slot = tonumber(data and data.slot)
    if not slot then
        cb({ ok = false })
        return
    end

    local localId = GetPlayerServerId(PlayerId())
    local playerId = tonumber(data and data.PlayerId)
    if (data and data.self) or not playerId or playerId <= 0 then
        playerId = localId
    end

    if RejectInsurvivableTreatment(playerId) then
        cb({ ok = false })
        return
    end

    if playerId ~= localId then
        if not IsEmsStaff() then
            cb({ ok = false })
            return
        end

        local dist = getPlayerDistance(playerId)
        if dist >= Config.MedicalMenuMaxDistance then
            cb({ ok = false })
            return
        end
    end

    local result = lib.callback.await('osp_ambulance:deletePrescription', false, playerId, slot)
    cb(type(result) == 'table' and result or { ok = false })
end)

RegisterNUICallback('SaveReportedBloodType', function(data, cb)
    local playerId = tonumber(data.PlayerId)
    local bloodType = data.bloodType

    if not playerId or type(bloodType) ~= 'string' then
        cb({ ok = false })
        return
    end
    if RejectInsurvivableTreatment(playerId) then
        cb({ ok = false })
        return
    end

    if bloodType ~= '' and not Config.bloodTypes[bloodType] then
        cb({ ok = false })
        return
    end

    local dist = getPlayerDistance(playerId)
    if dist >= Config.MedicalMenuMaxDistance then
        cb({ ok = false })
        return
    end

    local result = lib.callback.await('osp_ambulance:saveReportedBloodType', false, playerId, bloodType)
    if type(result) ~= 'table' or not result.ok or type(result.bodyDamage) ~= 'table' then
        cb({ ok = false })
        return
    end

    SendNUIMessage({
        damageStatus = json.encode(result.bodyDamage),
    })

    cb({ ok = true })
end)

RegisterNetEvent('osp_ambulance:viewPrescription', function(info, slot)
    if type(info) ~= 'table' then return end
    local payload = {}

    if type(info.metadata) == 'table' then
        for key, value in pairs(info.metadata) do
            payload[key] = value
        end
    else
        for key, value in pairs(info) do
            payload[key] = value
        end
    end

    payload.slot = tonumber(slot) or tonumber(info.slot)

    local quantity = tonumber(payload.quantity) or 0
    local dispensed = tonumber(payload.dispensed) or 0
    payload.remaining = quantity - dispensed
    payload.active = payload.remaining > 0 and not IsPrescriptionExpired(payload)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openPrescription',
        data = payload,
    })
end)

RegisterNUICallback('closePrescription', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closePrescription' })
    cb('ok')
end)

local function OpenPharmacyPrescriptionsMenu(pLang, parentMenu)
    local prescriptions = GetValidPrescriptions()
    if #prescriptions == 0 then
        SendTextMessage(GetLang().interactions.medicalHeader, pLang.no_valid_prescriptions, 4000, 'error')
        return
    end

    local options = {}
    for _, prescription in pairs(prescriptions) do
        local info = prescription.info
        local quote = lib.callback.await('osp_ambulance:getPrescriptionRedeemQuote', false, info.medicationId, 1) or {}
        local priceText

        if quote.covered then
            priceText = pLang.covered_by_insurance or 'Covered by insurance'
        else
            priceText = pLang.no_charge or '£0 — no charge'
        end

        options[#options + 1] = {
            title = info.medicationLabel or 'Prescription',
            description = string.format(pLang.remaining_doses, prescription.remaining) .. ' · ' .. priceText,
            icon = 'fa-solid fa-pills',
            onSelect = function()
                local input = lib.inputDialog(pLang.redeem_title, {
                    {
                        type = 'number',
                        label = pLang.redeem_amount,
                        description = pLang.redeem_amount_desc,
                        default = 1,
                        min = 1,
                        max = prescription.remaining,
                        required = true,
                    },
                })

                if not input then return end

                local amount = math.floor(tonumber(input[1]) or 1)
                local totalQuote = lib.callback.await('osp_ambulance:getPrescriptionRedeemQuote', false, info.medicationId, amount) or {}
                if totalQuote.ok and totalQuote.total and totalQuote.total > 0 then
                    local confirm = lib.alertDialog({
                        header = pLang.redeem_title,
                        content = string.format(
                            pLang.confirm_purchase or 'Collect %s x %s for $%s?',
                            amount,
                            info.medicationLabel or 'Medication',
                            totalQuote.total
                        ),
                        centered = true,
                        cancel = true,
                    })
                    if confirm ~= 'confirm' then return end
                end

                TriggerServerEvent('osp_ambulance:redeemPrescriptionSv', prescription.slot, amount)
            end,
        }
    end

    registerContext({
        id = 'pharmacy_prescriptions',
        title = parentMenu and (pLang.prescriptions_menu or 'Prescriptions') or pLang.pharmacy,
        menu = parentMenu,
        options = options,
    })
    showContext('pharmacy_prescriptions')
end

local function OpenPharmacyOTCMenu(pLang, parentMenu)
    local otcItems = Config.PharmacyOTCItems or {}
    local maxAmount = Config.PharmacyOTCMaxAmount or 10
    local options = {}

    for _, item in pairs(otcItems) do
        if item.name and item.label then
            local price = tonumber(item.price) or 0
            options[#options + 1] = {
                title = item.label,
                description = string.format(pLang.price_each or '$%s each', price),
                icon = item.icon or 'fa-solid fa-kit-medical',
                onSelect = function()
                    local input = lib.inputDialog(pLang.buy_title or 'Buy Item', {
                        {
                            type = 'number',
                            label = pLang.buy_amount or 'Amount',
                            description = pLang.buy_amount_desc or 'How many to purchase',
                            default = 1,
                            min = 1,
                            max = maxAmount,
                            required = true,
                        },
                    })

                    if not input then return end

                    local amount = math.floor(tonumber(input[1]) or 1)
                    if amount < 1 then return end
                    if amount > maxAmount then amount = maxAmount end

                    local total = price * amount
                    if total > 0 then
                        local confirm = lib.alertDialog({
                            header = pLang.buy_title or 'Buy Item',
                            content = string.format(
                                pLang.confirm_otc_purchase or 'Buy %s x %s for $%s?',
                                amount,
                                item.label,
                                total
                            ),
                            centered = true,
                            cancel = true,
                        })
                        if confirm ~= 'confirm' then return end
                    end

                    TriggerServerEvent('osp_ambulance:buyPharmacyOTCSv', item.name, amount)
                end,
            }
        end
    end

    registerContext({
        id = 'pharmacy_otc',
        title = parentMenu and (pLang.otc_items or 'Over-the-Counter') or pLang.pharmacy,
        menu = parentMenu,
        options = options,
    })
    showContext('pharmacy_otc')
end

function OpenPharmacyMenu()
    local pLang = PrescriptionLang()
    local otcItems = Config.PharmacyOTCItems or {}
    local hasOTC = type(otcItems) == 'table' and next(otcItems) ~= nil
    local prescriptions = GetValidPrescriptions()
    local hasPrescriptions = #prescriptions > 0

    if not hasOTC and not hasPrescriptions then
        SendTextMessage(GetLang().interactions.medicalHeader, pLang.nothing_available or pLang.no_valid_prescriptions, 4000, 'error')
        return
    end

    -- Skip submenu when only one category is available
    if hasOTC and not hasPrescriptions then
        OpenPharmacyOTCMenu(pLang)
        return
    end

    if hasPrescriptions and not hasOTC then
        OpenPharmacyPrescriptionsMenu(pLang)
        return
    end

    registerContext({
        id = 'pharmacy_main',
        title = pLang.pharmacy,
        options = {
            {
                title = pLang.otc_items or 'Over-the-Counter',
                description = pLang.otc_items_desc or 'Buy basic medical supplies without a prescription',
                icon = 'fa-solid fa-kit-medical',
                arrow = true,
                onSelect = function()
                    OpenPharmacyOTCMenu(pLang, 'pharmacy_main')
                end,
            },
            {
                title = pLang.prescriptions_menu or 'Prescriptions',
                description = pLang.prescriptions_menu_desc or 'Collect medication from your active prescriptions',
                icon = 'fa-solid fa-file-prescription',
                arrow = true,
                onSelect = function()
                    OpenPharmacyPrescriptionsMenu(pLang, 'pharmacy_main')
                end,
            },
        },
    })
    showContext('pharmacy_main')
end

RegisterNetEvent('osp_ambulance:openPharmacy', function()
    OpenPharmacyMenu()
end)

-- Bumped on every reload. A reload that was overtaken while waiting for the model stops
-- spawning, otherwise two overlapping reloads each spawn a full set of peds (duplicates).
local pharmacyReloadId = 0

local function SpawnPharmacyPed(hospitalId, index, coords, reloadId)
    if type(coords) == 'table' and coords.coords then
        coords = coords.coords
    end
    if not coords or coords.x == nil or coords.y == nil or coords.z == nil then
        return
    end

    local heading = coords.w or 0.0
    local model = joaat(Config.PharmacyNPCModel or 's_m_m_doctor_01')
    lib.requestModel(model)
    if reloadId ~= pharmacyReloadId then return end

    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, heading, false, false)
    SetEntityHeading(ped, heading)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    if Config.PharmacyNPCScenario then
        TaskStartScenarioInPlace(ped, Config.PharmacyNPCScenario, 0, true)
    end

    pharmacyPeds[#pharmacyPeds + 1] = ped

    if Config.UseTarget then
        local zoneName = "hospital-pharmacy-" .. hospitalId .. "-" .. index
        local zoneId = TargetingBoxZone(zoneName, coords, 2.5, 2.5, 2, {
            type = "client",
            event = "osp_ambulance:openPharmacy",
            icon = "fa-solid fa-pills",
            label = GetLang().prescriptions.pharmacy,
        })
        if Config.UseOxTarget then
            if zoneId then
                pharmacyTargetIds[#pharmacyTargetIds + 1] = zoneId
            end
        else
            pharmacyTargetNames[#pharmacyTargetNames + 1] = zoneName
        end
    else
        SetupPharmacyZone(hospitalId, index, coords)
    end
end

local function DeletePharmacyPeds()
    for _, ped in pairs(pharmacyPeds) do
        if ped and DoesEntityExist(ped) then
            SetEntityAsMissionEntity(ped, true, true)
            DeleteEntity(ped)
        end
    end
    pharmacyPeds = {}
end

function ReloadPharmacyLocations()
    pharmacyReloadId = pharmacyReloadId + 1
    local reloadId = pharmacyReloadId
    pharmacyCheck = false
    removeTextUi()

    if Config.UseTarget then
        if Config.UseOxTarget then
            for _, id in pairs(pharmacyTargetIds) do
                if id then
                    RemoveZone(id)
                end
            end
        else
            for _, name in pairs(pharmacyTargetNames) do
                RemoveZone(name)
            end
        end
        pharmacyTargetIds = {}
        pharmacyTargetNames = {}
    else
        for _, zone in pairs(pharmacyPoly) do
            if zone and zone.remove then
                zone:remove()
            end
        end
        pharmacyPoly = {}
    end

    DeletePharmacyPeds()

    if type(Config.Hospitals) ~= 'table' then
        return
    end

    for hospitalId, hospital in pairs(Config.Hospitals) do
        if type(hospital.pharmacy) == 'table' then
            for index, coords in pairs(hospital.pharmacy) do
                if reloadId ~= pharmacyReloadId then return end
                SpawnPharmacyPed(hospitalId, index, coords, reloadId)
            end
        end
    end
end

CreateThread(function()
    Wait(2000)
    ReloadPharmacyLocations()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    pharmacyCheck = false
    removeTextUi()
    DeletePharmacyPeds()
end)
