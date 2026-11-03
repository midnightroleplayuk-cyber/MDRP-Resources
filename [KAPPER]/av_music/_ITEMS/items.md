# For QBCore add this into shared/items.lua:

```lua
['headphones'] = {['name'] = 'headphones', ['label'] = 'BT Headphones', ['weight'] = 100, ['type'] = 'item', ['image'] = 'discman.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Listen to your favorite music'},
```

# OX_inventory

```lua
['headphones'] = {
    label = 'BT Headphones',
    weight = 1,
    stack = false,
    close = false,
    description = 'Listen to your favorite music'
},
```

# For qs-inventory:

```lua
["headphones"] = {
    ["name"] = "headphones",
    ["label"] = "BT Headphones",
    ["weight"] = 2,
    ["type"] = "item",
    ["image"] = "headphones.png",
    ["unique"] = true,
    ["useable"] = false,
    ["shouldClose"] = false,
    ["combinable"] = nil,
    ["description"] = "Listen to your favorite music"
},
```
