for qb-core/shared/items.lua:
debitcard = {
    name = 'debitcard',
    label = 'LG Debit Card',
    weight = 3,
    type = 'item',
    image = 'debitcard.png',
    unique = true,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'Debit card issued by LG Bank.'
},

for ox_inventory:
    ['debitcard'] = {
        label = 'LG Debit Card',
        weight = 3,
        type = 'item',
        image = 'bank_card.png',
        unique = true,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = 'Debit card issued by LG Bank.',
    },