if GetResourceState('wasabi_billing') ~= 'started' then return end

Bridge.Billing = 'wasabi'
Bridge.BillingResource = 'wasabi_billing'
Billing = Billing or {}

function Billing.CreateInvoice(data)
    local targetIdentifier = data.patientIdentifier
    if not targetIdentifier then return false end

    local ok, referenceId = pcall(function()
        return exports['wasabi_billing']:CreateInvoice(
            data.medicSource,
            tostring(targetIdentifier),
            data.amount,
            data.reason,
            'society',
            'personal'
        )
    end)

    if not ok or not referenceId then return false end
    return true, tostring(referenceId)
end

function Billing.PayInvoice(src, referenceId)
    if not referenceId or tostring(referenceId) == '' then
        Framework.Notify(src, _L('ems_invoice_not_found'), 'error')
        return false
    end

    local ok, paid = pcall(function()
        return exports['wasabi_billing']:PayInvoiceByReference(src, tostring(referenceId))
    end)

    if not ok or paid ~= true then
        Framework.Notify(src, _L('ems_invoice_payment_error'), 'error')
        return false
    end

    return true
end

function Billing.DeclineInvoice(src)
    Framework.Notify(src, _L('ems_invoice_external_manage'), 'info')
    return false
end
