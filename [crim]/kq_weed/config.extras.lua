Config.extras = {

    addonPressRecipes = {
        --- This example is made specifically for "kq_cocaine". All you have to do is add the "coke_brick" item to your server or change it to an existing cocaine brick item
        ['kq_cocaine_coke'] = {
            enabled = true, -- Enable only when using kq_cocaine, or if modified to work with your current items
            label = 'Cocaine',
            chunkModel = 'kq_coke_chunk',
            brickModel = 'kq_coke_brick',

            chunkItem = 'coke',
            brickItem = 'coke_brick',
            chunksPerBrick = 20,

            metadataKey = 'quality',
        },
    },

    addonBaggingRecipes = {
        --- This example is made specifically for "kq_cocaine". All you have to do is add the "coke_bag" item to your server or change it to an existing cocaine brick item
        ['cokebaggy'] = {
            enabled = true, -- Enable only when using kq_cocaine, or if modified to work with your current items
            label = 'Cocaine',
            chunkModel = 'coke',
            fullBaggieModel = 'cokebaggy',

            chunkItem = 'coke',
            baggieItem = 'kq_weed_bag_empty',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'quality',
        },


        --- This example is made specifically for "kq_meth". All you have to do is add the "kq_meth_low_bag" item to your server or change it to an existing bagged meth item
        ['kq_meth_low'] = {
            enabled = false, -- Enable only when using kq_cocaine, or if modified to work with your current items
            label = 'Meth (Low grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_meth_low',
            baggieItem = 'kq_meth_low_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },
        --- This example is made specifically for "kq_meth". All you have to do is add the "kq_meth_mid_bag" item to your server or change it to an existing bagged meth item
        ['kq_meth_mid'] = {
            enabled = false, -- Enable only when using kq_cocaine, or if modified to work with your current items
            label = 'Meth (Medium grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_meth_mid',
            baggieItem = 'kq_meth_mid_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },
        --- This example is made specifically for "kq_meth". All you have to do is add the "kq_meth_high_bag" item to your server or change it to an existing bagged meth item
        ['kq_meth_high'] = {
            enabled = false, -- Enable only when using kq_cocaine, or if modified to work with your current items
            label = 'Meth (High grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_meth_high',
            baggieItem = 'kq_meth_high_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },

        --- This example is made specifically for "kq_meth_amphetamines". All you have to do is add the "kq_amphetamines_low_bag" item to your server or change it to an existing bagged amphetamines item
        ['kq_amphetamines_low'] = {
            enabled = false, -- Enable only when using kq_meth_amphetamines, or if modified to work with your current items
            label = 'Amphetamines (Low grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_amphetamines_low',
            baggieItem = 'kq_amphetamines_low_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },
        --- This example is made specifically for "kq_meth_amphetamines". All you have to do is add the "kq_amphetamines_mid_bag" item to your server or change it to an existing bagged amphetamines item
        ['kq_amphetamines_mid'] = {
            enabled = false, -- Enable only when using kq_meth_amphetamines, or if modified to work with your current items
            label = 'Amphetamines (Medium grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_amphetamines_mid',
            baggieItem = 'kq_amphetamines_mid_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },
        --- This example is made specifically for "kq_meth_amphetamines". All you have to do is add the "kq_amphetamines_high_bag" item to your server or change it to an existing bagged amphetamines item
        ['kq_amphetamines_high'] = {
            enabled = false, -- Enable only when using kq_meth_amphetamines, or if modified to work with your current items
            label = 'Amphetamines (Medium grade)',
            chunkModel = 'kq_meth_chunk',
            fullBaggieModel = 'kq_meth_baggie_full',

            chunkItem = 'kq_amphetamines_high',
            baggieItem = 'kq_amphetamines_high_bag',
            chunksPerBaggie = 1, -- Amount of chunks per baggie (minigame will always represent this amount as 1 object)

            metadataKey = 'purity',
        },

    }
}

-- You can edit these are you wish, add more recipes etc.
