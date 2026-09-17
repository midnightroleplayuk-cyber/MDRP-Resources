Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Invoices
-- ──────────────────────────────────────────────────────────────────────────────
Config.Invoices = {
    enabled = true,
    autoOnPaidProject = true,
    manualDefaultStatus = 'unpaid', -- unpaid | paid
    nearbyDistance = 5.0,
    customerPaymentPrompt = true,
    paymentMethods = { 'card', 'cash' },
}