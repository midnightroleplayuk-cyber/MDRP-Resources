-- Items must exist in ox_inventory; anything missing is hidden from the kiosk.
Config.Canteen = {
    Items = {
        { item = 'water',    label = 'Bottled water', price = 1, max = 4, minIep = 'basic' },
        { item = 'bread',    label = 'Bread roll',    price = 1, max = 4, minIep = 'basic' },
        { item = 'sandwich', label = 'Sandwich',      price = 2, max = 3, minIep = 'basic' },
        { item = 'coffee',   label = 'Coffee',        price = 2, max = 2, minIep = 'standard' },
        { item = 'kurkakola', label = 'Fizzy drink',  price = 2, max = 2, minIep = 'standard' },
        { item = 'twerks_candy', label = 'Chocolate bar', price = 1, max = 3, minIep = 'enhanced' },
    },
}
