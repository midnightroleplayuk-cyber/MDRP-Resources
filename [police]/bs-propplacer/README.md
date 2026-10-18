# 🇬🇧 BS Prop Placer — UK Road Signs

**Made by British Scripts** · Creators: **Bradadorez & SwiftlyChillin**

A clean, optimised road-sign placement system for FiveM. Give your police, traffic
officers, highway crews and event staff a proper UK road-sign toolkit — place signs
from a slick menu, preview exactly where they'll go, close roads to NPC traffic, and
keep the map tidy with automatic clean-up.

Built **session-synced** (no database to set up), **server-authoritative** (cheat-resistant),
and **0.00ms idle**.

---

## ✨ Features

- **Modern NUI menu** — searchable, category-tabbed grid of every sign with real thumbnails. British light-blue theme.
- **Ghost placement preview** — a translucent sign follows your aim, snaps to the ground, scroll to push it nearer/further, **Q/E** to rotate, **left-click** to confirm.
- **Live sync** — every player sees placed signs instantly (server-owned networked entities).
- **Pick-up** — remove a placed sign via **ox_target / qb-target** (job-restricted), with a place/pickup animation.
- **Auto-delete timer** — forgotten signs clean themselves up after X minutes (configurable / toggleable).
- **Road closure & traffic control** — flag signs (No Entry, Stop, Road Works…) to **stop NPC traffic** routing through the area. Optional **active despawn** of AI cars that wander in, to prevent pile-ups.
- **Speed zones** — speed-limit signs **cap nearby NPC vehicles** to the posted limit (30/40/60 preset). Size the zone live while placing.
- **Job restricted** — defaults to `police`, `ambulance`, `fire`. Add/remove any job in one line.
- **Admin wipe** — `/clearprops` removes every placed sign map-wide.
- **Framework auto-detect** — QBCore, Qbox and ESX out of the box. One bridge file to swap a custom core.
- **55 UK signs & traffic props** across Warning, Prohibitory, Speed, Mandatory, Stop, Information and Traffic categories.

---

## 📦 Requirements

- A FiveM server on a recent artifact (server-side object creation is used).
- **Nothing else to install** — all UK sign models (`.ydr/.ytyp`) are **bundled inside this resource's `stream/` folder**. One download, drop it in, done.
- One of: **QBCore**, **Qbox**, or **ESX** (or run standalone with job checks off).
- No database required. No `ox_lib` required.

---

## 🚀 Quick Start

1. Drop the **`bs-propplacer`** folder into your `resources` folder — the signs are already inside it.
2. In `server.cfg`: `ensure bs-propplacer`
3. Add the admin permission: `add_ace group.admin propplacer.admin allow`
4. Open `config.lua`, set your **jobs** and **timer**, and you're live. `/signs` (or **F7**) to open.

Full walkthrough → **[INSTALL.md](INSTALL.md)**

---

## 🛒 Tebex Listing Copy (paste-ready)

> **BS Prop Placer — UK Road Signs**
>
> Equip your emergency services and highway crews with a complete UK road-sign placement
> system. Open a clean, modern menu, preview your sign with a ghost overlay, and drop it
> exactly where you need it — snapped to the ground and synced to everyone on the server.
>
> Close roads to break up NPC traffic at RTCs and roadworks, let signs auto-clear so your
> map never clutters, and wipe everything instantly with an admin command. Job-locked,
> framework-agnostic (QBCore / Qbox / ESX), database-free and a flat **0.00ms** at idle.
>
> Includes 55 British signs and traffic props across every category. Simple `config.lua`, full docs, and
> drop-in support for your own sign packs.

---

© British Scripts. Redistribution of the source is not permitted — see your Tebex licence.
