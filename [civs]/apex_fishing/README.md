# 🎣 Apex Advanced Fishing

A complete, polished fishing system for FiveM — built for **ESX Legacy**, **QBCore** and **QBox**.

---

## ✨ Features

- 🎯 **16 fish species** across 7 rarity tiers (junk → mythic)
- 🛒 **4 rod tiers** with progressive level/rarity gates
- 🎣 **Custom NUI minigame** with per-rarity difficulty scaling
- 🪣 **Catch modal** with Keep/Release choice
- 🛥️ **Boat rental** (5 boats) with refundable deposits and 3D return marker
- 🌊 **Coast vs Deep-sea zones** with depth-based detection
- 🏆 **Server-wide leaderboard** (MySQL-synced, top 3 with real player names)
- ⚡ **25 upgrades** across 5 categories (XP-spendable, never reduces your level)
- 🎨 **Full UI personalisation** — 8 brand colors, opacity slider, scale knob
- 🌍 **5 locales** out of the box (EN/PT/ES/FR/DE)
- 🔌 **Extensive exports** for integrating with phones, jobs, missions
- 🔒 **Feature toggles** — disable any subsystem from config

---

## 📦 Installation

### 1. Requirements
- **oxmysql** (required)
- **ox_lib** (recommended)
- Any modern inventory (ox_inventory, qb-inventory, qs-inventory)

### 2. Drop the resource into `resources/`

### 3. Add to `server.cfg`
```
ensure oxmysql
ensure ox_lib
ensure es_extended       # or qb-core / qbx_core
ensure apex_fishing
```

### 4. Add the items
Copy the entries in [`installation/items.md`](installation/items.md) into your inventory's items file.

### 5. Copy item images
Copy the 27 PNGs from [`[IMAGES]/`](./[IMAGES]/) into your inventory's `web/images/` folder.

### 6. Database
The `apex_fishing_rank` table is **auto-created on first boot**. Column migrations (xp_spent, upgrades) are applied in-place if you upgrade from an older version.

### 7. Start your server
The script auto-detects the framework.

---

## ⚙️ Configuration

All settings in [`shared/config.lua`](shared/config.lua).

```lua
Config.locale = 'en'    -- 'en' | 'pt' | 'es' | 'fr' | 'de'

Config.features = {
    enableUpgrades       = true,
    enableLeaderboard    = true,
    enableSettings       = true,
    enableBoats          = true,
    enableDeepSeaBlips   = true,
    enableJunkDrops      = true,
    enableRodBreakage    = true,
    enableDevCommands    = false,  -- ⚠️ KEEP false in production
    -- 30+ toggles total
}
```

Disable any feature → corresponding tab/blip/handler removed entirely.

---

## 🔌 Exports

### Server

```lua
local rank = exports.apex_fishing:GetPlayerRank(source)
-- { identifier, level, xp, xpSpent, xpAvailable, totalCatch, bestRarity, upgrades }

exports.apex_fishing:GetPlayerLevel(source)
exports.apex_fishing:GetPlayerXP(source)
exports.apex_fishing:GetPlayerAvailableXP(source)
exports.apex_fishing:GetPlayerTotalCatch(source)
exports.apex_fishing:GetPlayerBestRarity(source)
exports.apex_fishing:GetPlayerUpgradeLevel(source, 'catch_power')

-- Mutations
local newLevel, leveledUp = exports.apex_fishing:AddPlayerXP(source, 100)
exports.apex_fishing:SetPlayerXP(source, 5000)
exports.apex_fishing:IncrementCatchCount(source, 'rare')
exports.apex_fishing:SetUpgradeLevel(source, 'big_catch', 3)

-- Inventory
exports.apex_fishing:GiveRod(source, 'fishing_rod_master')
exports.apex_fishing:GiveBait(source, 50)

-- World / UI
local lb = exports.apex_fishing:GetLeaderboard(10)
exports.apex_fishing:OpenPanelFor(source)
exports.apex_fishing:ClosePanelFor(source)

-- Config readers
exports.apex_fishing:GetFishConfig()
exports.apex_fishing:GetRodConfig()
exports.apex_fishing:GetUpgradeConfig()
```

### Client

```lua
local fishing = exports.apex_fishing:IsFishing()
local zone    = exports.apex_fishing:GetCurrentZone()   -- 'coast' | 'deep'
local depth   = exports.apex_fishing:GetCurrentDepth()

exports.apex_fishing:OpenPanel()
exports.apex_fishing:ClosePanel()
exports.apex_fishing:StartCast()
exports.apex_fishing:CancelCast()
```

---

## 🌍 Locales

| Code | Language |
|---|---|
| `en` | English (master) |
| `pt` | Português |
| `es` | Español |
| `fr` | Français |
| `de` | Deutsch |

Switch with `Config.locale = 'pt'`. Missing keys fall back to English automatically.

**Add your own**: create `shared/locales/yourLang.lua` with `Locales.yourLang = {...}` and reference it in `fxmanifest.lua`.

---

## 🎮 Player Controls

| Key | Action |
|---|---|
| `E` | Open Fisherman panel / Return boat at marker |
| `X` | Cancel current cast |
| `Q` / `E` | Move the catch zone in the minigame |
| `Space` | Lock in the catch when meter is past threshold |
| `Enter` | Keep the catch (modal) |
| `R` | Release the catch (modal) |
| `Esc` | Close any modal |

---

## 🎯 Framework Compatibility

| Framework | Status |
|---|---|
| ESX Legacy | ✅ auto-detected |
| QBCore | ✅ auto-detected |
| QBox | ✅ auto-detected |

Leaderboard reads `users` (ESX) or `players` (QBCore) for real names. Falls back to `Angler #1234` if neither exists.

---

## 🆘 Support

- **Discord**: [discord.gg/apexscriptz](https://discord.gg/apexscriptz)
- **Tebex**: [apexscriptz.tebex.io](https://apexscriptz.tebex.io)

---

## 📝 Changelog

### 4.0.0
- ✨ Upgrades tab — 5 categories × 5 levels (25 upgrades total)
- ✨ Settings panel — color/opacity/scale, saved per character
- ✨ 5-locale system (EN/PT/ES/FR/DE) with automatic fallback
- ✨ Comprehensive exports — 18+ server + client exports
- ✨ 30+ feature toggles for fine-grained control
- ✨ Top 3 leaderboard with real player name resolution
- 🐛 Rarity-based minigame difficulty scaling
- 🐛 Boat teleport-back on return
- 🐛 Level refresh after XP mutations

### 3.0.0
- Complete rewrite with new NUI design
- Coast/Deep zone system
- Catch Keep/Release modal

---

© Apex Scriptz · All rights reserved.
