# JW_247robbery

Store robbery for ESX. Point your gun at the clerk and the robbery starts.
The clerk reacts differently every time: he gives up, secretly hits the silent
alarm or pulls a gun himself. Pick the registers, grab the bills, get out
before the cops roll up.

Questions or a bug to report? Open a ticket here:
https://discord.gg/9WJ38URauq

## Installation

1. Copy the folder into your resources folder
2. Add to your server.cfg:
   ```cfg
   ensure JW_247robbery
   ```
3. Restart the server

Create these items in your inventory: the start item (default `lockpick`),
`cigarettes` and `scratch_ticket`. Loot pays out as marked money
(`black_money`), switchable to any item in the config.

## Features

- Robbery starts at gunpoint on the clerk, not by pressing E on a register
- Clerk with random reactions (surrender / silent alarm / fights back)
- Six custom minigames, all built in, no minigame resource needed:
  lockpicking, the cash grab with dye pack risk, safe cracking by ear,
  shaking vending machines, cutting the power box, rummaging shelves
- Back room safe as a bonus target, cracked by listening to the dial
- Vending machines around the shop drop change and goods
- Shelves with item loot and scratch tickets, redeemable from the inventory
- Prep pays off: cut the power box first and cameras plus silent alarm are
  dead, finish the job like that and the whole crew earns a perfect bonus
- Full crew support: everyone near the shop at the start robs along, shared
  live HUD, robbery survives crashes and disconnects of single members
- Police always get the initial alert so they have time to respond, dispatch
  auto-detects ps-dispatch / cd_dispatch with a built-in fallback and a
  custom hook
- Cooldowns per shop, per player, server wide and per hour, loot scales with
  cops online
- Interaction via ox_target or E key, auto-detected
- Six languages included, UI colors configurable

## Language

Six languages ship with the script: English, German, Polish, Spanish,
Portuguese (Brazil) and Thai. Switch in the config.lua:
```lua
Config.Locale = 'en' -- 'en', 'de', 'pl', 'es', 'pt', 'th'
```
Own translations: copy a file in `locales/` and edit it. Missing entries fall
back automatically.

One note on Thai: the UI and all notifications render it fine, but GTA's own
help prompts ("press E") use the game font, which has no Thai glyphs. If you
run `th`, use `Config.Interaction = 'ox_target'` so the prompts come from
ox_target instead of the game.

## Item images

The `images/` folder contains ready-to-use images for `cigarettes` and
`scratch_ticket`. Copy them into your inventory's image folder
(e.g. `ox_inventory/web/images/`).

## Running your own shop NPCs?

If your shop script already spawns clerk NPCs in the stores, set:
```lua
Config.Clerk.spawn = false
```
This script then spawns no clerk of its own. The robbery starts by aiming at
your shop NPC instead. Hands up is attempted on the foreign NPC (your shop
script may override it, that is expected) and the fight-back reaction is
disabled automatically. The own clerk is fully configurable too: model,
invincible yes/no, and via the personality values how often he surrenders,
hits the alarm or fights (`fight = 0` = never fights).

## Adding more shops

There is a commented template at the bottom of `Config.Shops`. Copy the
block, uncomment it and grab the positions ingame with `/247coords`.
The command is harmless (it only prints the player's own position), but if
you want it gone after setup, set `Config.CoordsCommand = false`.

The command prints two lines. Use the `clerk` line for the clerk (it drops the
Z to ground level and includes your heading, so stand where the NPC should
stand and face the way he should look). Use the `any prop` line for everything
else: registers, safe, power box and shelves.

Safe, power box and shelves are optional, just leave out whatever the store
does not have. `safeKeypad = true` adds an extra worn-keypad stage in front of
that shop's safe before the dial.

## Discord logs

Paste your webhook into the config and you are done:
```lua
Config.Logs.webhook = 'https://discord.com/api/webhooks/...'
```
Logged: robbery start (with crew), robbery end (haul and perfect status) and
power box sabotages.

## Developer API

The script fires server side events for your own systems (CCTV, MDT,
evidence):

```lua
-- robbery started
AddEventHandler('JW_247robbery:started', function(shopId, data)
    -- data: label, coords, crew (identifier list), camsDead, reaction
end)

-- robbery ended
AddEventHandler('JW_247robbery:ended', function(shopId, data)
    -- data: label, coords, loot, perfect, reason ('done'/'abort'/'timeout'/'dropped'), crew
end)

-- power box sabotaged
AddEventHandler('JW_247robbery:powerCut', function(shopId, data)
    -- data: label, coords, source
end)

-- evidence left behind (register picked, safe opened)
AddEventHandler('JW_247robbery:evidence', function(shopId, data)
    -- data: type ('register'/'safe'), coords, source
end)
```

Plus two exports:
```lua
exports['JW_247robbery']:IsShopActive(shopId)      -- true/false
exports['JW_247robbery']:GetActiveRobberies()      -- list of running robberies
```
Tip for CCTV systems: `camsDead` tells you whether the cameras were sabotaged
at the start. If so, your camera feed should show nothing.

## Configuration

Everything lives in `config.lua`: shops with all positions, clerk behavior,
minigame difficulty, loot, cooldowns, police settings, colors.
