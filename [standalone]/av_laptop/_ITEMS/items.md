**For QBCore/shared/items.lua (This applies for Quasar Inv too)**
['laptop'] = {['name'] = 'laptop', ['label'] = 'Laptop', ['weight'] = 500, ['type'] = 'item', ['image'] = 'laptop.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = ''},

['decrypter'] = {['name'] = 'decrypter', ['label'] = 'Decrypter', ['weight'] = 500, ['type'] = 'item', ['image'] = 'decrypter.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = ''},

['black_usb'] = {['name'] = 'black_usb', ['label'] = 'Black USB', ['weight'] = 500, ['type'] = 'item', ['image'] = 'black_usb.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = ''},

['pendrive'] = {['name'] = 'pendrive', ['label'] = 'Pendrive', ['weight'] = 500, ['type'] = 'item', ['image'] = 'pendrive.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Can store personal data'},

['citizenid'] = {['name'] = 'citizenid', ['label'] = 'Citizen ID', ['weight'] = 10, ['type'] = 'item', ['image'] = 'citizenid.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Official ID card'},

['driver_license'] = {['name'] = 'driver_license', ['label'] = 'Driver License', ['weight'] = 10, ['type'] = 'item', ['image'] = 'driver_license.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Issued by the DMV'},

['firearm_license'] = {['name'] = 'firearm_license', ['label'] = 'Firearm License', ['weight'] = 10, ['type'] = 'item', ['image'] = 'firearm_license.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Issued by the police department'},

**For Origen Inventory and OX Inventory**

```lua
    ['laptop'] = {
        label = 'Laptop',
        weight = 1,
        stack = false,
        close = true,
        description = '',
        buttons = {
            {
                label = "Devices",
                action = function(slot)
                    exports['av_laptop']:openContainer(slot)
                end,
            }
        }
    },
    ['decrypter'] = {
        label = 'Decrypter',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },
    ['black_usb'] = {
        label = 'Black USB',
        weight = 1,
        stack = true,
        close = true,
        description = ''
    },
    ['pendrive'] = {
        label = 'Pendrive',
        weight = 1,
        stack = false,
        close = false,
        description = 'Can store personal data'
    },
    ['citizenid'] = {
        label = 'Citizen ID',
        weight = 1,
        stack = false,
        close = true,
        description = 'Official ID card'
    },
    ['driver_license'] = {
        label = 'Driver License',
        weight = 1,
        stack = false,
        close = true,
        description = 'Issued by the DMV'
    },
    ['firearm_license'] = {
        label = 'Firearm License',
        weight = 1,
        stack = false,
        close = true,
        description = 'Issued by the police department'
    },
```

**For Quasar Inventory qs-inventory/shared/items.lua (ESX Only)**

```lua
["laptop"] = {
    ["name"] = "laptop",
    ["label"] = "Laptop",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "laptop.png",
    ["unique"] = true,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = ""
},
["pendrive"] = {
    ["name"] = "pendrive",
    ["label"] = "Pendrive",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "pendrive.png",
    ["unique"] = true,
    ["useable"] = false,
    ["shouldClose"] = false,
    ["combinable"] = nil,
    ["description"] = "Can store personal data"
},
["decrypter"] = {
    ["name"] = "decrypter",
    ["label"] = "Decrypter",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "decrypter.png",
    ["unique"] = false,
    ["useable"] = false,
    ["shouldClose"] = false,
    ["combinable"] = nil,
    ["description"] = ""
},
["black_usb"] = {
    ["name"] = "black_usb",
    ["label"] = "Black USB",
    ["weight"] = 1,
    ["type"] = "item",
    ["image"] = "black_usb.png",
    ["unique"] = false,
    ["useable"] = false,
    ["shouldClose"] = false,
    ["combinable"] = nil,
    ["description"] = ""
},
```
