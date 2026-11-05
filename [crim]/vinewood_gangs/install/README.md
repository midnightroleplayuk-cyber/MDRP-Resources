# Installing the items

vinewood_gangs uses a few items. Add them to your inventory before starting the resource.

| Item | What it's for | Needed? |
|---|---|---|
| `spraycan` | Spraying and crossing out gang tags | Yes, unless `Config.Graffiti.sprayItem = false` |
| `burner_phone` | Calling the police handler to become or act as an informant | Yes, if informants are on (`Config.Modules.informants`) |
| `gang_tablet` | Opening the gang tablet from an item | Optional: F6 and `/gangtablet` work without it. Set `Config.Tablet.item = 'gang_tablet'` to use it |
| `thermite` | Heists: burning through doors and armoured-truck backs | Only if you use thermite steps; change or turn off in `config/heists.lua` > `tools` |
| `weed_bag`, `coke_bag`, `meth_bag` | Street dealing | Only if your server doesn't already have drug items. If it does, put their names in `config/drugs.lua` instead |

Black-market contraband uses items you choose yourself in `config/auctions.lua`; nothing to add here for that.

## Which folder to use

| Your setup | Use |
|---|---|
| Qbox, or any framework with ox_inventory | `ox_inventory/items.lua` |
| qb-core with qb-inventory | `qb-core/items.lua` |
| ESX with the default inventory | `esx/items.sql` |

Each file says where to paste or import it. The icons for all three items are in `images/`
(100 x 100 PNG, drawn for this resource, free to use with it).

## How players get them

Drug bags come from your server's own drug scripts, or gangs with a weed grow or cocaine lab bag up their stock
from the Business tab. Gang members buy the spray can, phone and tablet from the **Shop** tab in the tablet, paid from their own cash (so buying a burner
phone never shows up in the gang's history). Prices, limits and payment are in `config/shop.lua`, where you
can also add your own items and lock them behind a gang tier or rank permission. You can still sell them
in other shops on your server too.

## The phone and tablet "use" actions

- **ox_inventory:** handled by the `client = { export = ... }` lines in the item definitions.
- **qb-inventory and ESX:** vinewood_gangs registers them itself on start-up. No extra code needed.

The spray can doesn't need a use action: the script checks for one (and takes one) when a tag is sprayed
or crossed out.
