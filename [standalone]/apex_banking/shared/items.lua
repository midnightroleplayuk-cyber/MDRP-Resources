--[[
    Apex Banking — Items
    ────────────────────────────────────────────────────────────
    Defines the only inventory item this resource ships with —
    the apex_atm_card. The metadata is read by the inventory
    integration layer so the card knows which account it belongs
    to, the owner's name on the embossed plate, and the issue
    date for display in the NUI.
]]

Items = Items or {}

Items.list = {
    apex_atm_card = {
        label       = 'Debit Card',
        weight      = 5,
        stack       = false,        -- one card per holder
        close       = true,
        description = 'A debit card linked to your bank account. Required to use any ATM.',
        client      = {
            -- Used by ox_inventory's built-in 'event' hook:
            -- when the player uses the card, fire our custom event.
            event   = 'apex_banking:client:useCard',
            anim    = { dict = 'mp_common', clip = 'givetake1_a' },
        },
    },
}

function Items.get(name)
    return Items.list[name]
end

function Items.label(name)
    local i = Items.list[name]; return i and i.label or name
end
