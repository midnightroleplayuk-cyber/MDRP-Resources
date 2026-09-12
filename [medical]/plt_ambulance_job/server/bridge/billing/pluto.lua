if GetResourceState('wasabi_billing') == 'started' then return end

Bridge.Billing = 'pluto'
Bridge.BillingResource = 'Pluto internal'
Billing = Billing or {}

local PendingEMSInvoices = {}
local nextEMSInvoiceId = 0

local function GetInvoiceConfig()
    return Config.EMSInvoice or {}
end

local function CleanupExpiredInvoices()
    local expireSeconds = (tonumber(GetInvoiceConfig().ExpireMinutes) or 10) * 60
    if expireSeconds <= 0 then return end

    local now = os.time()
    for id, invoice in pairs(PendingEMSInvoices) do
        if not invoice.createdAt or now - invoice.createdAt > expireSeconds then
            PendingEMSInvoices[id] = nil
        end
    end
end

local function GetPendingInvoice(patientSrc, invoiceId)
    CleanupExpiredInvoices()

    if invoiceId then
        local invoice = PendingEMSInvoices[invoiceId]
        if invoice and invoice.patientSrc == patientSrc then
            return invoice
        end
        return nil
    end

    local newestInvoice
    for _, invoice in pairs(PendingEMSInvoices) do
        if invoice.patientSrc == patientSrc and (not newestInvoice or invoice.id > newestInvoice.id) then
            newestInvoice = invoice
        end
    end
    return newestInvoice
end

local function RemovePayment(player, amount)
    local accounts = GetInvoiceConfig().PaymentAccounts
    if type(accounts) ~= 'table' or #accounts == 0 then
        accounts = { 'bank', 'cash' }
    end

    for _, account in ipairs(accounts) do
        account = tostring(account or '')
        if account ~= '' then
            local balance = tonumber(player.functions.GetMoney(account)) or 0
            if balance >= amount and player.functions.RemoveMoney(account, amount, 'ems-invoice-payment') then
                return true, account
            end
        end
    end

    return false
end

function Billing.CreateInvoice(data)
    CleanupExpiredInvoices()
    nextEMSInvoiceId = nextEMSInvoiceId + 1

    local invoice = {
        id = nextEMSInvoiceId,
        medicSrc = data.medicSource,
        patientSrc = data.patientSource,
        dept = data.department,
        amount = data.amount,
        reason = data.reason,
        medicName = data.medicName,
        patientName = data.patientName,
        departmentLabel = data.departmentLabel,
        createdAt = os.time()
    }

    PendingEMSInvoices[invoice.id] = invoice

    local cfg = GetInvoiceConfig()
    Framework.Notify(invoice.patientSrc, _L('ems_invoice_received', {
        department = invoice.departmentLabel,
        id = invoice.id,
        amount = invoice.amount,
        reason = invoice.reason,
        payCommand = cfg.PayCommandName or 'payemsinvoice',
        declineCommand = cfg.DeclineCommandName or 'declineemsinvoice'
    }), 'warning')
    TriggerClientEvent('amb_client:EMSInvoiceReceived', invoice.patientSrc, invoice)

    return true, invoice.id
end

function Billing.PayInvoice(src, invoiceId)
    local patient = Framework.GetPlayer(src)
    if not patient then return false end

    local parsedInvoiceId = tonumber(invoiceId)
    if invoiceId and tostring(invoiceId) ~= '' and not parsedInvoiceId then
        Framework.Notify(src, _L('ems_invoice_not_found'), 'error')
        return false
    end

    local invoice = GetPendingInvoice(src, parsedInvoiceId)
    if not invoice then
        Framework.Notify(src, _L(invoiceId and 'ems_invoice_not_found' or 'ems_invoice_none'), 'error')
        return false
    end

    local paid, account = RemovePayment(patient, invoice.amount)
    if not paid then
        Framework.Notify(src, _L('ems_invoice_no_money'), 'error')
        return false
    end

    local financeLabel = ('EMS Invoice #%s - %s'):format(invoice.id, invoice.reason)
    if not AddFinanceEntry(invoice.dept, 'deposit', invoice.amount, financeLabel, patient.name) then
        patient.functions.AddMoney(account, invoice.amount, 'ems-invoice-refund')
        Framework.Notify(src, _L('ems_invoice_finance_error'), 'error')
        return false
    end

    PendingEMSInvoices[invoice.id] = nil
    Framework.Notify(src, _L('ems_invoice_paid_patient', { id = invoice.id, amount = invoice.amount }), 'success')

    if GetPlayerName(invoice.medicSrc) then
        Framework.Notify(invoice.medicSrc, _L('ems_invoice_paid_ems', {
            id = invoice.id,
            amount = invoice.amount,
            name = patient.name
        }), 'success')
    end

    return true
end

function Billing.DeclineInvoice(src, invoiceId)
    local patient = Framework.GetPlayer(src)
    if not patient then return false end

    local parsedInvoiceId = tonumber(invoiceId)
    if invoiceId and tostring(invoiceId) ~= '' and not parsedInvoiceId then
        Framework.Notify(src, _L('ems_invoice_not_found'), 'error')
        return false
    end

    local invoice = GetPendingInvoice(src, parsedInvoiceId)
    if not invoice then
        Framework.Notify(src, _L(invoiceId and 'ems_invoice_not_found' or 'ems_invoice_none'), 'error')
        return false
    end

    PendingEMSInvoices[invoice.id] = nil
    Framework.Notify(src, _L('ems_invoice_declined_patient', { id = invoice.id }), 'info')

    if GetPlayerName(invoice.medicSrc) then
        Framework.Notify(invoice.medicSrc, _L('ems_invoice_declined_ems', {
            id = invoice.id,
            name = patient.name
        }), 'warning')
    end

    return true
end

AddEventHandler('playerDropped', function()
    local droppedSrc = source
    for id, invoice in pairs(PendingEMSInvoices) do
        if invoice.medicSrc == droppedSrc or invoice.patientSrc == droppedSrc then
            PendingEMSInvoices[id] = nil
        end
    end
end)
