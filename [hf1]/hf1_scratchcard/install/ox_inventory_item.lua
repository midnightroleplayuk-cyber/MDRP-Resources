-- Add this entry inside ox_inventory/data/items.lua
['scratchcard'] = {
    label = 'Scratchcard',
    weight = 5,
    stack = false,
    close = true,
    consume = 0,
    description = 'Scratch it & claim any winnings at a scratchcard stand.',
    client = {
        export = 'hf1_scratchcard.useScratchcard'
    }
},
