--[[
    Apex Billing — Inventory item definitions
    ────────────────────────────────────────────────────────────
    Copy the appropriate block into your inventory resource.
    All metadata is auto-managed by apex_billing — you only
    register the item itself.

    OX_INVENTORY  (recommended)  — items.lua / generated.lua
    ──────────────────────────────────────────────────────────

    ['apex_invoice'] = {
        label  = 'Invoice',
        weight = 5,
        stack  = false,
        close  = true,
        description = 'A printed invoice. Inspect it to view details and pay.',
        client = {
            -- apex_billing reads the metadata.invoiceId on use.
            export = 'apex_billing.useInvoice',
        },
    },

    ['apex_printer'] = {
        label  = 'Invoice Printer',
        weight = 1200,
        stack  = false,
        close  = true,
        description = 'Required to issue invoices. Carry one to use /billing.',
    },

    QB-INVENTORY — qb-core/shared/items.lua
    ──────────────────────────────────────────────────────────

    apex_invoice  = { name = 'apex_invoice',  label = 'Invoice',         weight = 5,    type = 'item', image = 'invoice.png',  unique = true,  useable = true,  shouldClose = true,  description = 'A printed invoice.' },
    apex_printer  = { name = 'apex_printer',  label = 'Invoice Printer', weight = 1200, type = 'item', image = 'printer.png',  unique = true,  useable = false, shouldClose = false, description = 'Required to issue invoices.' },

    ESX (legacy) — INSERT into items
    ──────────────────────────────────────────────────────────

    INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
        ('apex_invoice', 'Invoice', 5, 0, 1),
        ('apex_printer', 'Invoice Printer', 1, 1, 1);
]]
