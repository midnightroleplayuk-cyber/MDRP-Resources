# Radar Item Installation Guide

This guide explains how to add the `radar_camera` item to your server for all supported inventory systems.

---

## 1. QB-Inventory / LJ-Inventory / AJ-Inventory
Add the following line to your `qb-core/shared/items.lua` file:

```lua
['radar_camera'] = {['name'] = 'radar_camera', ['label'] = 'Radar Camera', ['weight'] = 500, ['type'] = 'item', ['image'] = 'radar_camera.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Portable speed radar for traffic enforcement.'},
```

---

## 2. OX-Inventory
Add the following entry to your `ox_inventory/data/items.lua` file:

```lua
['radar_camera'] = {
    label = 'Radar Camera',
    weight = 500,
    stack = true,
    close = true,
    usable = true,
    description = 'Portable speed radar for traffic enforcement.',
    client = {
        image = 'radar_camera.png',
    }
},
```

---

## 3. Quasar Inventory (qs-inventory)
Add the following entry to your `qs-inventory/shared/items.lua` file:

```lua
['radar_camera'] = {
    ['name'] = 'radar_camera',
    ['label'] = 'Radar Camera',
    ['weight'] = 500,
    ['type'] = 'item',
    ['image'] = 'radar_camera.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['description'] = 'Portable speed radar for traffic enforcement.'
},
```

---

## 4. Codem Inventory
Add the item via the Codem Inventory Dashboard or manually in `config/items.lua`:

```lua
['radar_camera'] = {
    label = "Radar Camera",
    weight = 0.5,
    stack = true,
    close = true,
    description = "Portable speed radar for traffic enforcement.",
    image = "radar_camera.png"
},
```

---

## 5. Core Inventory
Add the following entry to your `core_inventory/config.lua` (or `items.lua` depending on version):

```lua
["radar_camera"] = {
    label = "Radar Camera",
    weight = 500,
    stack = true,
    close = true,
    description = "Portable speed radar for traffic enforcement.",
    image = "radar_camera.png"
},
```

---

## 6. Chezza Inventory
Add the following to `inventory/data/items.lua`:

```lua
["radar_camera"] = {
    label = "Radar Camera",
    weight = 0.5,
    stack = true,
    close = true,
    description = "Portable speed radar for traffic enforcement.",
    image = "radar_camera.png"
},
```

---

## 7. Item Image
Ensure you place a `radar_camera.png` image in the respective inventory's image folder:
- **QB/LJ/AJ**: `qb-inventory/html/images/`
- **OX**: `ox_inventory/web/images/`
- **Quasar**: `qs-inventory/html/img/`
- **Codem**: `codem-inventory/html/images/`
- **Core**: `core_inventory/html/img/`
- **Chezza**: `inventory/html/img/`

---

## Breathalyzer Item Installation

Add the `breathalyzer` item to your inventory systems using the same method as above.

**Example (QB-Core):**
```lua
['breathalyzer'] = {['name'] = 'breathalyzer', ['label'] = 'Breathalyzer', ['weight'] = 500, ['type'] = 'item', ['image'] = 'breathalyzer.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Standard issue department breathalyzer.'},
```

**Example (OX-Inventory):**
```lua
['breathalyzer'] = {
    label = 'Breathalyzer',
    weight = 500,
    stack = true,
    close = true,
    usable = true,
    description = 'Standard issue department breathalyzer.',
    client = {
        image = 'breathalyzer.png',
    }
},
```

Ensure you place the `breathalyzer.png` image in your inventory's image folder.

---

## Megaphone Item Installation

Add the `megaphone` item to your inventory systems.

**Example (QB-Core):**
```lua
['megaphone'] = {['name'] = 'megaphone', ['label'] = 'Megaphone', ['weight'] = 500, ['type'] = 'item', ['image'] = 'megaphone.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Handheld megaphone for public address.'},
```

**Example (OX-Inventory):**
```lua
['megaphone'] = {
    label = 'Megaphone',
    weight = 500,
    stack = true,
    close = true,
    usable = true,
    description = 'Handheld megaphone for public address.',
    client = {
        image = 'megaphone.png',
    }
},
```

Ensure you place a `megaphone.png` image in your inventory's image folder.

---

## Evidence Bag Item Installation

Add the following items to your inventory systems.

### 1. Empty Evidence Bag
**Example (QB-Core):**
```lua
['evidence_bag'] = {['name'] = 'evidence_bag', ['label'] = 'Evidence Bag', ['weight'] = 100, ['type'] = 'item', ['image'] = 'evidence_bag.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Sealable bag for collecting forensic evidence.'},
```

### 2. Filled Evidence Bag
**Example (QB-Core):**
```lua
['filled_evidence_bag'] = {['name'] = 'filled_evidence_bag', ['label'] = 'Collected Evidence', ['weight'] = 200, ['type'] = 'item', ['image'] = 'filled_evidence_bag.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A bag containing forensic evidence for analysis.'},
```

### 3. Forensic Report
**Example (QB-Core):**
```lua
['forensic_report'] = {['name'] = 'forensic_report', ['label'] = 'Forensic Lab Report', ['weight'] = 50, ['type'] = 'item', ['image'] = 'forensic_report.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A certified forensic report from the ballistics lab.'},
```

**Example (OX-Inventory):**
```lua
['evidence_bag'] = {
    label = 'Evidence Bag',
    weight = 100,
    stack = true,
    close = true,
    usable = true,
    description = 'Sealable bag for collecting forensic evidence.',
    client = {
        image = 'evidence_bag.png',
    }
},
['filled_evidence_bag'] = {
    label = 'Collected Evidence',
    weight = 200,
    stack = false,
    close = true,
    usable = true,
    description = 'A bag containing forensic evidence for analysis.',
    client = {
        image = 'filled_evidence_bag.png',
    }
},
['forensic_report'] = {
    label = 'Forensic Lab Report',
    weight = 50,
    stack = false,
    close = true,
    usable = true,
    description = 'A certified forensic report from the ballistics lab.',
    client = {
        image = 'forensic_report.png',
    }
},
```

Ensure you place `evidence_bag.png`, `filled_evidence_bag.png`, and `forensic_report.png` images in your inventory's image folder.

---

## GPS Tracker Item Installation

Add the following item to your inventory systems.

### GPS Tracker
*   **Item Name**: `gps_tracker`
*   **Description**: Used to track vehicles in real-time.
*   **Usage**: Go near a vehicle and use the item. The vehicle will then appear in the Safari "Vehicle Trackers" tab in the Boss Menu.

```lua
-- For QB-Core (shared/items.lua)
['gps_tracker'] = {['name'] = 'gps_tracker', ['label'] = 'GPS Tracker', ['weight'] = 500, ['type'] = 'item', ['image'] = 'gps_tracker.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A hidden GPS tracking device.'},

-- For Ox-Inventory (data/items.lua)
['gps_tracker'] = {
    label = 'GPS Tracker',
    weight = 500,
    stack = false,
    close = true,
    usable = true,
    description = 'A hidden GPS tracking device.',
    client = {
        image = 'gps_tracker.png',
    }
},
```

Ensure you place a `gps_tracker.png` image in your inventory's image folder.
