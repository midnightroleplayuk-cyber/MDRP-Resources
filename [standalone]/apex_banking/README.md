# Apex Banking

Standalone advanced banking system for **FiveM** — personal & business
accounts, sub-accounts with shared permissions, IBAN transfers, debit
cards, loans with a trust-tier credit system, compounding savings, full
transaction history, an ATM rendered **in 3D on the machine's own
screen**, and a nine-section admin panel.

Compatible out of the box with **ESX Legacy**, **QBCore** and **QBox**.
Every optional integration (ox_inventory, ox_target, ox_lib,
apex_notify, qb-target, mythic_notify, okokNotify, …) is auto-detected
at runtime — no hard dependencies beyond your framework and oxmysql.

## Features

- **Personal accounts** — IBAN, PIN, balance, savings, transaction log.
- **Debit cards** — issuable item with freeze/revoke, per-card serial,
  PIN-gated ATM access. Optional ox_inventory metadata.
- **Transfers** — IBAN-to-IBAN with reason, fee, live receipt and
  recent recipients.
- **Sub-accounts (crew / family / business)** — shared wallets with
  per-partner permissions (view / deposit / withdraw / transfer /
  manage) and daily limits.
- **Loans** — interest, repayment schedule, trust-tier ceiling that
  grows as the player repays.
- **Savings pot** — compounding interest, lock-in period, early-close
  penalty.
- **Business / job treasuries** — auto-discovered from ESX `jobs` /
  `job_grades` (or `QBCore.Shared.Jobs`), per-grade wages, per-grade
  pay intervals, bonus payments, ESX society money sync.
- **3D ATM** (`atmdui/`, `Config.useDuiAtm = true`) — the terminal is
  drawn as a textured quad over the machine's own glass, on **every**
  ATM prop in the world: an idle welcome screen when nobody is using
  it, the full terminal when someone is. Nothing on the prop is
  replaced, so its signage and body stay untouched. A camera eases in
  and the player aims at the machine's physical side buttons and
  keypad. Withdraw (quick amounts / custom), deposit, transfer to an
  IBAN typed on the pad, balance, receipt item (`apex_atm_receipt`),
  animated card and cash props. Money moves only after the machine
  finishes counting.
- **Classic ATM** (`Config.useDuiAtm = false`) — fullscreen terminal,
  card+PIN auth, withdraw/deposit, daily/per-tx limits, recent ATM
  history, 3-tier card fallback.
- **12 themes and 6 layouts** — Apex, Obsidian, Fleeca, Maze, Midnight,
  Neon, Terminal, Royal, Ember plus the light Paper, Snow and Sand;
  Classic, Top nav, Mirror, Focus, Banner and Split. Applied to every
  player from the admin panel, with a live preview.
- **Admin panel** (`/bankadmin`) — dashboard, 17 feature switches,
  account directory, business treasuries, loans, placed ATMs, the
  global ledger, an audit trail and the appearance controls.
- **Real-time UI** — server broadcasts mutations to every connected
  client so balances update instantly.
- **Privacy mode** — masks every balance in the UI.

## Installation

1. Drop the `apex_banking` folder into your `resources/` (or any folder
   you start in `server.cfg`).
2. Add `ensure apex_banking` to `server.cfg` AFTER your framework
   (es_extended / qb-core / qbx_core) and `oxmysql`.
3. Grant staff access:
   ```cfg
   add_ace group.admin apex_banking.admin allow
   # QBCore / QBox admins live under their own principals:
   add_ace qbcore.admin apex_banking.admin allow
   add_ace qbcore.god   apex_banking.admin allow
   ```
   Your framework's own admin group is accepted as well, so most
   servers need no extra line at all.
4. Every table is created on first start; nothing to import by hand.
   `[SQL]/apex_banking.sql` carries the same schema for DBAs who
   prefer to run it themselves.
5. Open `shared/config.lua` and adjust:
   - `Config.framework` — `'auto'` works for 99% of servers.
   - `Config.providers` — notification, target and inventory resources.
   - `Config.features` — toggle modules on / off (the admin panel
     overrides these at runtime).
   - `Config.banks` — bank locations (peds + blips).
6. Add the items to your inventory. For ox_inventory:
   ```lua
   ['apex_atm_card'] = { label = 'Debit Card', weight = 20, stack = false, close = true },
   ['apex_atm_receipt'] = { label = 'ATM Receipt', weight = 10, stack = false, close = true,
       server = { export = 'apex_banking.use_atm_receipt' } },
   ```
   The receipt image is in `[IMAGES]/`.
7. Restart the server. The first time a player walks into a bank they
   run the onboarding ceremony (set PIN, fingerprint scan).

## Discord logs

Apex Banking does not use a Discord bot, so there is no token to
enter. It posts directly to Discord **webhook URLs**:

1. In Discord, open the channel that should receive the log → **Edit
   Channel → Integrations → Webhooks → New Webhook → Copy Webhook URL**.
2. Paste the URL into `Config.logs` in `shared/config.lua`. There is
   one slot per category; use one URL for all of them or a different
   channel for each. An empty string switches that category off.

   ```lua
   Config.logs = {
       deposit  = 'https://discord.com/api/webhooks/…',  -- deposits, savings / sub-account pay-ins
       withdraw = 'https://discord.com/api/webhooks/…',  -- withdrawals, savings / sub-account pay-outs
       transfer = 'https://discord.com/api/webhooks/…',  -- IBAN transfers
       card     = 'https://discord.com/api/webhooks/…',  -- card issued / frozen / revoked
       loan     = 'https://discord.com/api/webhooks/…',  -- loans granted / repaid
       admin    = 'https://discord.com/api/webhooks/…',  -- every /bankadmin action
   }
   ```
3. Keep `Config.providers.logger = 'webhook'` (the default). Set it to
   `'fivem_logs'` to print the same events to the server console
   instead, or `'custom'` to receive them in `Integrations.OnLog` in
   `shared/integrations.lua` and forward them anywhere you like.
4. Restart the resource. Each embed carries amount, fee, the IBANs
   involved and the player's name.

## Calibrating an ATM model

The Fleeca and `prop_atm_01` ship calibrated. Any other model gets a
screen derived from its own dimensions, which is usable immediately and
takes seconds to fine-tune. Stand next to the machine and run:

- `/apexatmquad` — the 3D screen. TAB cycles the edge (left, right,
  top, bottom, the depth of the top and bottom rows, and how far the
  screen floats off the glass), arrows move it, ENTER saves, BACKSPACE
  cancels.
- `/apexatmcalibrate` — the physical buttons (3D hit points) and the
  on-screen keys. TAB switches mode, ENTER saves, DELETE twice restores
  the config values.

Both save per ATM model to the database and apply to every player
live, and both print a config-ready block to F8 so you can bake the
values into `atmdui/config.lua`. They are also buttons in
`/bankadmin → ATM machines`.

## Commands

| Command | Who | What |
| --- | --- | --- |
| `/bank` | players | opens the bank when near one (`Config.bankCommand = false` turns it off) |
| `/bankadmin` | staff | the admin panel |
| `/placeatm` · `/removeatm` | staff | drop / remove a persistent ATM prop |
| `/apexatmquad` | staff | position the 3D screen of the nearest ATM's model |
| `/apexatmcalibrate` | staff | calibrate its buttons and on-screen keys |
| `/atmcard` | staff | give yourself a debit card |
| `/bankshowcase [ms]` | staff | cycle every theme and layout on your own screen |
| `/apex_banking_reload` | staff | push an edited `Config.banks` to every client |
| `/apex_banking_jobs_reload` | console | re-read the framework's job list |
| `/apex_banking_reset_pin <id>` | console | clear a PIN lockout |

Every staff command is gated by `Config.adminAce`, the `command` ACE, or
your framework's own admin group — see `Config.adminGroups`. The command
names themselves are configurable: `Config.bankCommand`,
`Config.adminCommand`, `Config.atmCardCommand`, `Config.showcaseCommand`
and `Config.atmPlacement.command` / `.removeCommand`. Set
`Config.showcaseCommand = false` if you would rather not register the
theme preview at all, and `Config.bankCommand = false` if players should
only open the bank in person, at the counter.

## Public Exports

Server-side (`exports['apex_banking']`):

```lua
:GetBalance(src)                  -- bank balance
:GetCash(src)                     -- cash on hand
:AddMoney(src, amount, reason)    -- credit + log
:RemoveMoney(src, amount, reason) -- debit + log
:GetAccount(src)                  -- full snapshot
:HasAccount(src)                  -- bool
:ResolveIban(iban)                -- main | sub | business descriptor
:Transfer(src, toIban, amount, reason)
:GetBusinessBalance(jobName)
:AddBusinessMoney(jobName, amount, reason, actor)
:RemoveBusinessMoney(jobName, amount, reason, actor)
:GetSocietyBalance(jobName)                       -- same three, under the
:AddSocietyMoney(jobName, amount, reason, actor)  -- names other scripts expect
:RemoveSocietyMoney(jobName, amount, reason, actor) -- from a "society banking" resource
:IssueCard(src)
:ListCards(src)
:OpenBank(src)                    -- triggers client-side open
:OpenAdmin(src)                   -- admin panel (ACE-gated)
:Notify(src, message, kind, duration)
```

Client-side:

```lua
exports['apex_banking']:OpenBank()
exports['apex_banking']:OpenBankAt(bank)
exports['apex_banking']:OpenCardsPanel()
exports['apex_banking']:OpenAtm()
exports['apex_banking']:IsBankOpen()
exports['apex_banking']:Notify(message, kind, duration)
```

### Society funds for other scripts (JG-Mechanic, shops, job scripts)

What most scripts call a **society** is a job treasury here, keyed by
the job name: `exports['apex_banking']:AddSocietyMoney('mechanic', 161,
'Repair')` pays into the treasury you see in `/bankadmin → Businesses`
and in the boss's business tab. The treasury row is created on first
use for any job your framework knows, so a job added after boot works
straight away. The add/remove exports return the new balance, or
`false, reason` (`not_found` when the name is not a job on your server,
`no_funds` when the treasury cannot cover a debit). Each movement is logged
as `society in` / `society out` with the calling resource's name and, when
the caller passes one as the optional fourth argument, the actor
("Supplies: 2× strawberry · John Doe · apex_restaurant"), so the business
history and the admin ledger show who moved what and why.

**Apex Restaurant 2.1.6 and later** uses exactly these exports: with
apex_banking started, a restaurant's treasury IS its job's business account
here — supplier purchases, register sales, customer orders, deposits,
withdrawals and payroll all land in it. Nothing has to be configured on
either side; apex_banking's own business payroll pays the restaurant's staff
from that account (the restaurant's payroll stands down), so set the wages
per grade in the Business tab or in `/bankadmin → Businesses`.

**JG-Mechanic** has no Apex Banking option, and on QBCore with
`Config.SocietyBanking = "auto"` it calls qb-management / qb-banking
exports that do not exist, so every order ends in "There was a problem
completing your order". `[INTEGRATIONS]/jg-mechanic.lua` is a
ready-made patch: set `Config.SocietyBanking = "apex_banking"` in
JG-Mechanic's config and paste the file's code at the end of
JG-Mechanic's `framework/server.lua`. The instructions are at the top
of the file.

## Integration hooks (open source)

`shared/integrations.lua` ships open-source even in the escrowed
build. Override any function to plug Apex Banking into your own
ecosystem:

- `Integrations.Notify` — route notifications elsewhere.
- `Integrations.Prompt` / `DrawWorldMarker` — your own interaction UI.
- `Integrations.RegisterTargetPed` — bespoke target system.
- `Integrations.GetCardMeta` — alternative inventory backend.
- `Integrations.CanUseBanking` / `CanUseFeature` — access control.
- `Integrations.OnCardIssued`, `OnTransaction`, `CanTakeLoan`,
  `OnLog` — analytics & lifecycle hooks.

## Locales

English (`en`), Portuguese (`pt`), Spanish (`es`), French (`fr`) and
German (`de`) ship in `build/locales/`. Set `Config.locale` to switch.
To add a language, copy `en.lua` to `xx.lua` and translate — the file
covers the bank, the ATM screen and the admin panel.

## Changelog

### 2.3.4

Straight folder replace over 2.3.3; nothing to import.

- `Config.bankCommand = false` turns `/bank` off. The command is then not
  registered at all, so players open the bank in person only, at the
  counter. Any name other than `'bank'` still renames it as before.

### 2.3.3

Straight folder replace over 2.3.2; nothing to import.

- Money moved by another resource through `AddSocietyMoney` /
  `RemoveSocietyMoney` (and the `*BusinessMoney` names) is logged as
  `society in` / `society out` with the calling resource — and the actor,
  when the caller passes one as the new fourth argument — instead of as an
  admin credit / debit by "Admin". Apex Restaurant 2.1.6 uses this for its
  supplier purchases, sales, deposits, withdrawals and payroll; see *Society
  funds for other scripts* above.
- Those movements post to the Discord `deposit` / `withdraw` channels like
  every other ledger entry.

### 2.3.2

Straight folder replace over 2.3.1; nothing to import.

- **Discord logs now fire for every category.** `Config.logs` has
  always offered `deposit`, `withdraw`, `transfer`, `card` and `loan`
  URLs, but only `admin` was ever posted to: filling the other five
  did nothing. Every money movement routed through the transaction
  ledger now posts to its category (deposits, withdrawals, ATM
  operations, savings, sub-account movements, transfers, loans), and
  card issue / freeze / unfreeze / revoke post to `card`.
- `Config.providers.logger` is honoured by all of them: `'webhook'`,
  `'fivem_logs'` (console) or `'custom'` (`Integrations.OnLog`).
- New *Discord logs* section above explains that the script uses
  webhook URLs, not a bot token.

### 2.3.1

Straight folder replace over 2.3.0; nothing to import.

- **JG-Mechanic and other "society banking" scripts.** New
  `GetSocietyBalance` / `AddSocietyMoney` / `RemoveSocietyMoney` exports
  (aliases of the business ones) and a ready-made patch in
  `[INTEGRATIONS]/jg-mechanic.lua`. See *Society funds for other
  scripts* above.
- A job treasury is now created on first use by any export, for any job
  the framework knows. Before, a job added after boot (or one whose row
  was never seeded) made `AddBusinessMoney` answer `not_found`, and the
  calling script's payment failed.
- The business exports refuse a non-string job name instead of running
  a query with it.

### 2.3.0

Upgrading from 2.2.0 is a straight folder replace. Every table this
version adds is created on start with `CREATE TABLE IF NOT EXISTS`, so
you do not need to re-import the SQL — but keep your own `shared/config.lua`
and `build/locales/`, which is exactly what `escrow_ignore` leaves
editable.

**The ATM screen is now drawn in 3D.** Earlier builds replaced the prop's
texture, and because one texture carries both the screen and the machine's
signage, that painted black bars across the casing. The screen is now a
textured quad positioned over the glass, so the prop itself is never
touched. Each ATM model carries its own calibration, and any model without
one falls back to a quad derived from its bounding box. `/apexatmquad`
tunes it live and writes the values back.

**Twelve themes and six layouts.** The layouts change where things are,
not just the colours: a top navigation bar, a mirrored sidebar, a focus
mode, a banner header and a split view.

**A rebuilt admin panel** with nine panes, including treasuries, loans, a
full ledger and an audit log of every staff action.

Framework fixes, all of which failed silently before:

- QBox never discovered a single job, so no business was ever seeded and
  no salary was ever paid. QBox moved the job tables off `QBCore.Shared`.
- On QBox, a player who picked a character after the resource had already
  started got no bank peds, no blips and no ATM sync, because the loaded
  event is spelled differently there and event names are case-sensitive.
- QBox notifications went nowhere, and the QBCore text UI was called on
  servers that do not have it.
- On any QBCore or QBox server without `qb-management`, the society
  balance lookup threw, because reading an export that does not exist is
  itself an error.
- On ESX without `esx_addonaccount`, the same lookup waited forever on a
  callback that was never going to fire.
- On ESX, a withdrawal larger than the balance quietly took whatever was
  there and reported success, which could credit a bank account more than
  it debited. It now refuses.
- A player whose job or job grade was missing crashed payroll and every
  business callback.
- `AddBusinessMoney` and `RemoveBusinessMoney` were documented but called
  functions that did not exist, so they always failed.
- Removed a network event that let any client force a server-wide rebuild
  and broadcast on demand.

## Support

Discord: `https://discord.gg/apexscripts`
Store:   `https://apexscripts.xyz`
