# hf1_scratchcard v2.0.0

Physical UK-style scratchcards for Qbox using ox_inventory metadata.

## Requirements
- qbx_core
- ox_lib
- ox_target
- ox_inventory
- Optional UI/banking frontend: LGMods_Banking

## Install
1. Put `hf1_scratchcard` in your resources folder.
2. Copy the item from `install/ox_inventory_item.lua` into `ox_inventory/data/items.lua`.
3. Restart ox_inventory after adding the item.
4. Configure `Config.AllowedIdentifiers` in `config.lua`.
5. Start after the dependencies:

```cfg
ensure ox_lib
ensure qbx_core
ensure ox_inventory
ensure ox_target
ensure LGMods_Banking # only if your server uses it
ensure hf1_scratchcard
```

Optional ACE:
```cfg
add_ace group.admin scratchcards.manage allow
```

## Behaviour
- `/scard` places/removes only this resource's `v_ret_247_lotterysign` stands.
- Buying gives a non-stackable `scratchcard` ox_inventory item with unique card metadata.
- The result, prize grid and bonus are generated server-side when purchased.
- Using the inventory item opens the scratch UI. Scratching does not consume the item.
- `Claim Winnings` is available from a managed stand.
- The card is a bearer ticket. Ownership is not stored against a character: if another player steals/receives a winning item, they can claim it.
- A winning card is removed before payout to prevent double redemption.
- If no winner exists, one detected losing card is deleted and the player gets exactly: `Error: You do not have a winner.`
- Claim and purchase events verify the player is physically near the selected managed stand.

## LGMods_Banking
LGMods_Banking's public product information does not publish a stable player-credit export. On Qbox, this resource pays the configured framework `bank` balance through `qbx_core`, which is the account banking frontends integrate with. This avoids guessing an escrow/private export name. `Config.PayoutAccount = 'bank'` is therefore recommended when using LGMods_Banking.

## Important metadata note
Do not expose inventory/admin tools that let ordinary players edit arbitrary item metadata. `winner` and `prize` are bearer-ticket metadata and are validated/capped server-side on redemption.


## Rolling 24-hour purchase limit
`Config.MaximumScratchcardsPer24Hours` controls how many cards one Rockstar license can buy during any rolling real-world 24-hour period. The default is `5`; set it to `0` to disable the limit. Purchase timestamps are stored in `purchase_limits.json`, so reconnecting and normal resource/server restarts do not reset the allowance. The purchase is only counted after the inventory item has successfully been issued.

## Optional Discord logging
Configure `Config.DiscordLogging` in `config.lua`. Set `Enabled = true` and paste your Discord webhook URL into `Webhook`. Individual toggles are provided for purchases, winning claims, losing-card claims, and stand changes. The webhook URL stays server-side and is never sent to clients.

### High-value win role ping
Inside `Config.DiscordLogging.HighValueWinPing`, set `Enabled = true`, choose the minimum `Threshold` (default `2000`), and put the numeric Discord role ID in `RoleId`. Winning claims at or above the threshold will mention that role in the webhook message. Discord Developer Mode can be used to copy a role ID. The logger restricts `allowed_mentions` to that configured role so player-controlled values cannot create arbitrary pings.


## Database-backed stand placement (v2.1)
`/scard` now contains **Place new stand**, **Manage placed stands**, and **Remove nearest stand**.
Placed `v_ret_247_lotterysign` props are stored in MySQL through oxmysql and respawn for clients after restarts. The resource automatically creates the `hf1_scratchcard_stands` table (or `Config.StandTable`).
The management list lets authorised staff set a waypoint, teleport to, or permanently delete each placed stand.

Ensure `oxmysql` starts before this resource.


## Interactive stand placement
From `/scard`, choose **Place new stand**. Aim where the sign should go; the translucent preview follows your crosshair. Use Left/Right Arrow to rotate, Page Up/Page Down to adjust height, E to save it to MySQL, or Backspace to cancel. `Config.PlacementMaxDistance` controls how far from yourself you can position it.


## Golden Edition UI
The 3x3 grid now shows a unique symbol per prize amount (edit `SYMBOLS` in `html/app.js`). Three identical symbols therefore correspond to three identical amounts, preserving the server payout logic. The bonus crown is independent. All nine grid slots are created synchronously and canvas sizing occurs after the UI becomes visible. The serial printed at bottom right is the card ID from inventory metadata.
