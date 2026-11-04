# F4 Tycoon

**F4 City**, a city building board game for 2 to 4 players at a real 3D table. Every table in the config gets a game table, four chairs and the board on top. Players walk up, sit down, roll the dice, buy districts, build them up from a flag to houses and a hotel every time they come back, collect rent, play the exchange, get permits at city hall and race to the prestige target. The server owns the game; the clients only show it.

It is a standalone resource. A framework is only used for the optional stakes (qbx_core, qb-core or es_extended money).

## Install

1. Put the `f4-tycoon` folder in your resources and add `ensure f4-tycoon` to `server.cfg`.
2. Set the table position in `config.lua` (`Config.Tables`), or place tables in game with `/tycoontable add` (admins).
3. Restart the resource. Clients that already had it loaded need to reconnect once so the new models are streamed.

Nothing else is required: no database, no inventory, no target resource.

## Playing

- Walk to a free chair and press **E** to sit. The first player to sit is the host.
- In the lobby, everyone picks a token (crown, rocket, gem, rook, anchor, star). The host can set a stake, change the game settings (**Game settings**, see below) and fill empty seats with AI players (**Add bot**). When at least `Config.Game.minPlayers` are seated (bots count) and every player is ready, the game starts after a short countdown. So one player plus a bot is enough to play.
- **Space** rolls, **Enter** closes a headline card, **M** opens the city map, **C** switches the camera, **Esc** closes a window or asks to stand up. Buying, building, the exchange and choosing spaces happen in their own windows.
- Drag the empty part of the screen to turn the camera, use the wheel to zoom, double-click to reset it.
- The camera follows the dice, the moving token and drawn cards in Auto mode. Seat and Top views are fixed.
- Push-to-talk and chat keep working while you sit.
- Standing up or disconnecting during a game counts as leaving: your spaces go back to the bank and your stake stays in the pot. Players who miss `Config.Game.afkStrikes` timers in a row are removed the same way.

## Rules

The board (`data/board.json`) is a fictional city: 36 spaces, 8 between the corners. All names, texts, prices and artwork are original.

| Space | |
|---|---|
| District (20, in 8 zones) | Free: buy it, with houses at once. Yours: build every time you land there. Before your token has passed START once a district can have at most `firstLapHouses` (2) houses; the 3rd comes after that. The hotel opens once three houses stand and you stop there for the `hotelVisit`-th time (3; buying it was the 1st). The same limits apply to city hall, the contractor and urban renewal. Someone else's: pay rent (x`zoneMultiplier` when the owner has the whole zone). |
| Landmark (4) | Buy it; its rent depends on how many landmarks the owner has. No buildings. |
| START | `salary` every time you pass, `startBonus` extra for stopping on it exactly. |
| Headline (4) | A card from the F4 Times (17 cards: moves, money, kept lawyer / courier cards, urban renewal, storm, audit, tourism). |
| Rent Day | The bank pays `rentDay` for every space you own. |
| Contractor (2) | One building at `contractorDiscount` of its price on a district of your choice (optional). |
| Tax | `taxRate` of everything you own (land + buildings). |
| Exchange (corner) | Invest one of `exchangeStakes`; a market roll of two dice decides (`exchangeTable`: lose it all ... +150 %). |
| City Hall (corner) | Building permit: one level for free on a district of your choice (a grant when you have nowhere to build). |
| Traffic (corner) | Only tokens sent there are stuck (a card, three doubles): pay `trafficFee`, call a courier (card) or roll a double; after `trafficTurns` failed rolls the token drives on. |

- Owned spaces carry the owner's flag in their token colour; houses and hotels are painted in the owner's colour too. The plain zones (Harbor, Bazaar, Campus) share the standard hotel; the premium zones have their own: a beach resort with palms and a pool (Coast), an art deco tower (Arts), twin glass towers (Tech), a setback skyscraper with a gold spire (Finance), a domed mansion (Hills). Set per zone in `data/board.json` (`groups[].hotel`).
- An owned landmark shows its building: the big wheel, the stadium, the opera house, the sky tower, with details in the owner's colour.
- Every player's cash lies in front of them as piles of F4 note bundles (1M, 100K, 10K). Every payment is seen: rent flies from the payer's piles to the owner's, taxes and fees fly to the bank in the middle of the board, the salary and other income come from there.
- Doubles roll again; the third double in a row ends in traffic.
- No mortgages, no trades, no auctions: when you cannot pay, you sell spaces to the bank (`sellRate` of what they cost) or go bankrupt. Bankrupt: your cash goes to the creditor, your spaces back to the bank.
- **Winning**: reach the prestige target first (`Config.Prestige.target`, default 45), or be the last player standing. Prestige counts every district, house, hotel, complete zone and landmark (`Config.Prestige`). `Config.WealthTarget` adds a net worth target, `Config.Game.timeLimit` a time limit (the richest player wins).

## Table settings

The host sets the rules of each game in the lobby (**Game settings**). Everyone else sees them there, and during a game the city map opens them read-only (**Rules**). Changing a setting un-readies everyone and tells the other players; the game copies the settings when it starts, so they never change mid-game. When the host leaves an empty table the settings go back to the defaults.

| Setting | Default from | Choices (`Config.LobbySettings.options`) |
|---|---|---|
| Starting cash, START salary, exact stop bonus, rent day per property, tax, traffic fee, sell back rate | `Config.Game` | `startingCash`, `salary`, `startBonus`, `rentDay`, `taxRate`, `trafficFee`, `sellRate` |
| Houses on the first lap, hotel on visit N, complete zone multiplier | `Config.Game` | `firstLapHouses` (3 = no limit), `hotelVisit`, `zoneMultiplier` |
| Prestige target, net worth target, time limit | `Config.Prestige.target`, `Config.WealthTarget`, `Config.Game.timeLimit` | `prestigeTarget`, `wealthTarget`, `timeLimit` (0 = off) |
| Decision timers | `Config.Timers` x `Config.Speeds` | `speed`: `fast`, `normal`, `relaxed` |

Only the values in the lists can be picked (the server checks them). Remove a key from `options` to fix that rule, or set `Config.LobbySettings.enabled = false` to fix them all. `GetGameState(tableId).rules` returns the settings a table uses.

## AI players

With `Config.Bots.enabled` the host sees an **Add bot** button on every empty seat in the lobby (and **Remove** on a bot). A bot sits on its chair as an NPC, throws the dice with its arm and plays on the server (`server/bot.lua`) after a short pause to "think" (`thinkMin` / `thinkMax`):

- keeps a cash reserve against the rents it may land on with the next roll (it looks at the opponents' spaces ahead of its token)
- buys while the reserve allows, always when the space reaches the prestige target, finishes a zone or stops an opponent from finishing one; builds houses at once when rich
- builds on its own districts as far as the reserve allows; city hall and renewal go to the district with the best rent gain, the contractor only when it can afford it
- invests only spare cash at the exchange
- pays its way out of traffic early in the game and waits late in the game
- aims the storm at the leading opponent's most expensive district
- in debt, sells what matters least (never a whole zone first)

While a bot is seated there are no stakes. When the last human leaves, the game ends and the bots leave the table.

## Stakes (optional)

`Config.Bet.enabled = true` and a running qbx_core, qb-core or es_extended turn them on (`Config.Framework = 'auto'`). The host picks the stake in the lobby (presets or a custom amount between `min` and `max`). Changing it un-readies everyone. Every player pays it from `Config.Bet.account` when the game starts; if someone cannot pay, the start is cancelled and nobody is charged. The winner gets the pot minus `houseCut`. When the resource stops during a game, the players still in it get their own stake back.

Only the `Bridge` in `server/open.lua` talks to the framework (get, remove and add money). Another money system goes there.

## Customising: the open files

Most of the resource is encrypted (escrow). These files stay readable and are yours to edit:

| File | |
|---|---|
| `config.lua` | Everything in the Config section below |
| `locales/*.lua` | All texts: UI, log, cards, notifications. Add a language by copying `en.lua` |
| `server/open.lua` | Money for the stakes (`Bridge`), the names shown at the table, who is an admin, server hooks, server exports |
| `client/open.lua` | The "sit" prompt, notifications, controls that keep working while seated, client hooks, client exports |

Every function in `OpenServer` / `OpenClient` is called through a guard: if it errors, the error is printed (`[f4-tycoon] open.lua <name>: ...`) and the default is used, so a typo there never breaks a running game.

### Server hooks (`server/open.lua`)

Players are passed as `{ src, name, bot }`. Bots have a negative `src`: never pay or charge them.

| Hook | When | Return |
|---|---|---|
| `OpenServer.GetDisplayName(src)` | A name is shown (lobby, log, results) | the name. `USE_CHARACTER_NAMES = true` uses the character name from the framework |
| `OpenServer.IsAdmin(src)` | `/tycoontable` | `true` to allow (default: ACE `command` or `Config.AdminAce`) |
| `OpenServer.CanSitDown(src, tableId, seat)` | Someone wants to sit | `false, 'reason'` to refuse |
| `OpenServer.CanStartGame(tableId, players, stake)` | Countdown over, before stakes are taken | `false` to cancel (everyone is set back to not ready) |
| `OpenServer.OnGameStarted(tableId, players, stake)` | Game started, stakes taken | |
| `OpenServer.OnGameEnded(tableId, result)` | Game over, prize paid. `result = { winner, prize, reason, ranking, minutes }`, reason `'prestige'` / `'wealth'` / `'last'` / `'time'` / `'abandoned'` / `'stopped'` / `'error'`, ranking `{ { src, name, bot, worth, bankrupt }, ... }` | |
| `OpenServer.OnPlayerOut(tableId, player, creditor, why)` | A player is out: why `'bankrupt'` / `'left'` / `'afk'`; creditor is the player who got the remaining cash (nil: the bank) | |
| `OpenServer.OnPropertyBought(tableId, player, position, cost, level)` | A space was bought, a district maybe with houses (position 0-35, see `data/board.json`; level 0-3) | |
| `OpenServer.OnPropertyUpgraded(tableId, player, position, level, cost)` | A district got buildings (landing on it, contractor, city hall, renewal card); level 1-3 houses, 4 hotel; cost 0 when free | |

### Server exports

```lua
local tycoon = exports['f4-tycoon']
tycoon:GetTables()                      -- { { id, coords, players, bots, stake, playing, runtime, persist }, ... }
tycoon:GetTable(tableId)                -- one of those, or nil
tycoon:GetPlayerTable(src)              -- tableId, seat (or nil)
tycoon:IsPlayerPlaying(src)             -- true while in a running game (not bankrupt, not watching)
tycoon:GetGameState(tableId)            -- the full state the players' UI gets (.rules = the table settings)
tycoon:AddTable(id, vector4(x, y, z, h), persist)   -- persist (default true) keeps it in data/tables.json
tycoon:RemoveTable(tableId)             -- not while a game runs there
tycoon:StandUp(src)                     -- during a game this means leaving it
tycoon:AddBot(tableId, seat)            -- lobby only
tycoon:RemoveBot(tableId, seat)
tycoon:EndGame(tableId)                 -- stops the game, stakes go back to the players still in it
```

### Client hooks (`client/open.lua`)

| Hook | |
|---|---|
| `OpenClient.KeepControls` | Controls that keep working while seated (default push-to-talk 249 and chat 245) |
| `OpenClient.CanSitDown(tableId, seat)` | Checked before the sit request (default: not dead, not in a vehicle). `false` stays standing |
| `OpenClient.OnSeated(tableId, seat)` / `OnStoodUp(tableId)` | Hide / show your own HUD, phone, etc. |
| `OpenClient.ShowSitPrompt(text)` / `HideSitPrompt()` | The "press E" prompt. Native help text by default, ox_lib example inside |
| `OpenClient.Notify(text, kind)` | Messages while the table UI is closed (feed by default, ox_lib / QBCore examples inside) |

### Client exports

```lua
exports['f4-tycoon']:IsSeated()          -- seated, tableId, seat
exports['f4-tycoon']:StandUp()
exports['f4-tycoon']:GetNearestTable()   -- tableId, distance
exports['f4-tycoon']:SetCameraMode('auto' | 'seat' | 'top')
exports['f4-tycoon']:GetTableState(tableId)
exports['f4-tycoon']:IsUiOpen()
```

## Config

| Key | |
|---|---|
| `Config.Locale` | `tr` or `en`: UI, card texts and which printed board is used |
| `Config.Tables` | `{ id, coords = vector4(x, y, z, heading), snapToGround }`. Seat 1 is on the -Y side of the heading. With `snapToGround` the z of a player position is fine. |
| `Config.Seat` | Sitting scenario and its height / offset, if a ped floats or sinks |
| `Config.Game` | Money (start, salary, fees, shares), the exchange table, time limit, AFK strikes |
| `Config.Prestige` / `Config.WealthTarget` | How to win: the prestige target and what each thing is worth, an optional net worth target |
| `Config.LobbySettings` / `Config.Speeds` | What the host may change in the lobby and the choices; timer multipliers of the paces |
| `Config.Timers` | Decision timers in seconds; when one runs out the server plays the default move |
| `Config.Timing` | Animation lengths the server waits for |
| `Config.Bet` | Stakes |
| `Config.Tokens` | Token models and their colours |
| `Config.Bots` | AI players: on/off, names, NPC models, thinking time, minimum cash reserve |
| `Config.AdminAce` | ACE for the admin command (ACE `command` also works) |

## Admin commands

| Command | |
|---|---|
| `/tycoontable add [id]` | Places a table 1.6 m in front of you, seat 1 facing you. Saved in `data/tables.json`. |
| `/tycoontable remove` | Removes the nearest table placed in game or by an export (not while a game runs there) |
| `/tycoontable list` | Lists all tables (also from the server console) |

## Notes

- The sitting scenario is the standard `PROP_HUMAN_SEAT_CHAIR_MP_PLAYER`. Its height depends a little on the ped; adjust `Config.Seat.height` if needed.
- The UI follows Apple's dark appearance (opaque materials, no blur, system colours). It uses SF Pro when the font is installed on the player's computer; SF Pro's licence does not allow shipping it with the resource, so Inter (SIL OFL, licence in `web/dist/fonts/OFL.txt`) is bundled as the stand-in.
- The default table position in `config.lua` is at Legion Square. Move it, or place tables with `/tycoontable add`.
