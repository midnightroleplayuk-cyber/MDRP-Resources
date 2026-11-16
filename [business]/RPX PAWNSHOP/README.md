# RPX Pawnshop

**RPX Pawnshop** is a **free FiveM pawnshop script** that allows players to sell configured items via an NPC with a modern UI.  
Built for **Qbox, QBCore, and ESX**, with automatic detection for frameworks, inventories, notifications, and banking.

---

## 📌 Features
- NPC pawnshop with target interaction
- Configurable sellable items & prices
- Modern, fixed-size UI with scrolling
- Quantity selector per item
- Sell individual items or sell all
- Discord webhook logging
- Optional map blip
- Auto-detects framework, inventory, notifications, and banking
- Optimized and lightweight

---

## 🧩 Framework Support
- ✅ **Qbox** (fully supported)
- ✅ **QBCore**
- ✅ **ESX**

### ESX Note ⚠️
On **ESX**, payouts are made via **bank only**.  
Cash/money wallets are **not supported** by default in this script.

➡️ This is intentional for compatibility and stability.

---

## 🎒 Inventory Support
- ✅ **ox_inventory** (recommended)
- ✅ qb-inventory
- ✅ qs-inventory
- ✅ ESX default inventory (fallback)

### ESX Recommendation
> ⚠️ **We highly recommend using `ox_inventory` on ESX**  
It provides the best compatibility, item images, and reliability with this script.

---

## 💰 Banking Support
Auto-detected (no configuration required):
- Qbox default money system
- QBCore default money system
- ESX bank account
- okokBanking (if installed)
- Renewed Banking (if installed)

---

## 🖼 Item Images
Item images are pulled automatically from your inventory system:
- ox_inventory → `nui://ox_inventory/web/images/`
- qb-inventory / qs-inventory → configured paths
- ESX → depends on inventory (ox_inventory recommended)

---

## ⚙️ Installation
1. Download and extract `rpxpawnshop`
2. Place into your `resources/` folder
3. Add to `server.cfg`:

4. Configure items, NPCs, and options in `config.lua`
5. Restart your server

---

## 🆓 License
This script is **FREE**.

You are allowed to:
- Use it on your server
- Modify it for personal/server use

You are **NOT allowed** to:
- Re-sell this script
- Claim it as your own

---

## 👑 Credits
**Created by RPX (RolePlay Xclusive)**

- 🌐 Website: https://rpx.tebex.io/
- 💬 Discord: https://discord.gg/hZDMAB8n4B

If you enjoy the script, consider supporting RPX or checking out our other releases ❤️
