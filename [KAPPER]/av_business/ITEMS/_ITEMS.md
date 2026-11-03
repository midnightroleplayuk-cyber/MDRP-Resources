**For QBCore/shared/items.lua (This applies for Quasar Inv too)**
['cleaning_rag'] = {['name'] = 'cleaning_rag', ['label'] = 'Cleaning Rag', ['weight'] = 500, ['type'] = 'item', ['image'] = 'cleaning_rag.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Use it to keep your business clean and fresh'},
['cleaning_broom'] = {['name'] = 'cleaning_broom', ['label'] = 'Cleaning Broom', ['weight'] = 500, ['type'] = 'item', ['image'] = 'cleaning_broom.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Use it to keep your business clean and fresh'},

**For Origen Inventory and OX Inventory**

```lua
    ['cleaning_rag'] = {
        label = 'Cleaning Rag',
        weight = 1,
        stack = true,
        close = true,
        description = 'Use it to keep your business clean and fresh'
    },
    ['cleaning_broom'] = {
        label = 'Cleaning Broom',
        weight = 1,
        stack = true,
        close = true,
        description = 'Use it to keep your business clean and fresh'
    },
```

**For Quasar Inventory qs-inventory/shared/items.lua (ESX Only)**

```lua
["cleaning_rag"] = {
    ["name"] = "cleaning_rag",
    ["label"] = "Cleaning Rag",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "cleaning_rag.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Use it to keep your business clean and fresh"
},
["cleaning_broom"] = {
    ["name"] = "cleaning_broom",
    ["label"] = "Cleaning Broom",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "cleaning_broom.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Use it to keep your business clean and fresh"
},
```
