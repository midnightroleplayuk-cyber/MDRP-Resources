# Apex Billing

Standalone advanced billing / invoicing system for **FiveM**. Personal
and society invoices, itemised line items, VAT, paper invoice item
that opens a realistic invoice view, required printer item to issue,
inline print animation, public exports, and a UI that mirrors
**Apex Banking** so both resources read as one suite.

Compatible with **ESX Legacy**, **QBCore**, and **QBox**. Optional
integrations (apex_banking, ox_inventory, ox_target, ox_lib,
apex_notify, qb-inventory, qb-target, …) auto-detected at runtime.

## Quick start

1. Drop the `apex_billing` folder into your `resources/` folder.
2. Ensure your framework + oxmysql start first:
   ```
   ensure oxmysql
   ensure es_extended   # or qb-core / qbx_core
   ensure apex_billing
   ```
3. Register the two items in your inventory (see `shared/items.lua`
   for `ox_inventory`, `qb-inventory` and ESX snippets).
4. Open the panel in-game with `/billing` or `F7`.

The DB schema is auto-created on first start. A manual fallback is
in `sql/apex_billing.sql`.

## Highlights

- **Personal + society invoices** — society members bill citizens
  with the money going to the society treasury; with
  `Config.features.personalInvoices = true` every player can also
  bill other players, paid into their own bank (see below).
- **Realistic invoice view** — paper-style modal with header strip,
  watermark, line items, VAT, totals, due date, status stamp.
- **Printer item required** to issue (toggle in `Config.features`).
- **Paper invoice item** — recipient opens it and the invoice modal
  pops up, ready to pay or decline.
- **Inline print animation** when issuing.
- **Templates** — save reusable line-item presets per player or per
  society (boss-only).
- **VAT / fees** — configurable per society and globally.
- **Live updates** — every mutation broadcasts to connected clients.
- **Themed UI** — same palette + components as Apex Banking, with
  a colour picker that recalculates the full brand ramp.
- **Exports** — `:Bill()`, `:GetInvoice()`, `:OpenPanel()`,
  `:OpenInvoice()`, society stats, list helpers.
- **Auto-expire** — past-due invoices flip to `expired` after a
  configurable grace period.
- **Webhooks** — issuance / payment / decline / admin channels.
- **Admin panel** — `/billingadmin`, see below.

## Personal invoices (player → player)

Off by default. Turn it on in `shared/config.lua`:

```lua
Config.features.personalInvoices = true   -- every player can bill other players
Config.features.societyInvoices  = true   -- keep society billing too (or false)
```

- The **New** tab then shows for every player. Pick a nearby player,
  add the line items and send. When the invoice is paid, the money goes
  to **your own bank**, not to a society.
- Society members who can do both get a **Society / Personal** switch
  at the top of the New tab.
- The **Sent** tab lists the personal invoices you issued; open one to
  cancel it while it is still pending.
- If you are offline when your invoice is paid, the money waits in the
  `apex_billing_payouts` table and is paid into your bank the next time
  you join.

Options in `Config.personal`: `requiredItem` (item the issuer must
carry, `''` = none), `givePaperItem`, and `jobs` (`{}` = everyone, or a
list of job names allowed to bill personally). Amount limits are
`Config.limits.minPersonalInvoice` / `maxPersonalInvoice` /
`maxPendingPerPlayer`, and the issue fee is `Config.fees.issuePersonal`.

## Changelog

### 1.2.1
- Personal (player → player) invoices: `Config.features.personalInvoices`
  and `Config.personal`. Before this, only society members could issue
  invoices, whatever the config said.
- `Config.features.societyInvoices = false` now really switches society
  billing off.
- New **Sent** tab and **Society / Personal** switch in the panel.
- Money for a personal invoice paid while the issuer is offline is kept
  and paid in on their next join (new table `apex_billing_payouts`,
  created automatically).
- Exports: `Bill` / `QuickBill` without `issueAs` now pick society when
  allowed, otherwise personal; `CanIssue(src, kind)` takes an optional
  `'society'` / `'player'`.

## Updating: `refresh` before `ensure`

When an update **adds new files** (1.2.0 added three), restarting the
resource is not enough:

```
refresh
ensure apex_billing
```

FXServer caches a resource's *file list* when it scans the folder.
`ensure` / `restart` / the txAdmin restart button re-run the files on
that cached list with fresh contents — but they never re-read
`fxmanifest.lua`, so a file that did not exist at the last scan is
silently never loaded and never sent to clients. `refresh` re-scans.
Then **reconnect your game client** so it downloads the new files.

Both halves of the resource now detect this and say so: the server
prints `build/server/modules/admin.lua did NOT load`, and the client
prints which files were not delivered.

## Admin panel — `/billingadmin`

Staff-only, server-wide view of every invoice.

| Tab | What it does |
| --- | --- |
| **Overview** | Outstanding / collected / overdue totals, per-status counts (click one to filter), top societies by revenue |
| **Invoices** | Search by number, title, issuer, recipient or citizen ID; filter by status and society; paginated |
| **Societies** | Treasury balance plus pending / collected / outstanding per job |
| **Tools** | Force the expire sweep, purge settled invoices older than N days, push the config to every client |

Per-invoice actions: mark paid, extend the due date, void, reopen,
delete, and open the full paper view. **These only correct the
ledger — no money is moved and the issuer is not credited.** Real
payments always go through the normal pay flow.

### Who can open it

You pass the gate if **any one** of these is true:

1. You hold `Config.adminAce` (`apex_billing.admin`).
2. You hold the built-in `command` ace — which every member of
   `group.admin` has, because a stock server.cfg contains
   `add_ace group.admin command allow`. **This is why your existing
   admins work with no setup at all.** Disable with
   `Config.adminAcceptCommandAce = false`.
3. You hold an ace named after one of `Config.adminGroups`
   (`admin`, `superadmin`, `god`), or your framework reports one of
   those permission levels (QBCore `GetPermission`, QBox `HasGroup`,
   ESX `getGroup`).
4. One of your identifiers is listed in `Config.adminIdentifiers`.

To decide it yourself, define `Integrations.IsAdmin(src)` in
`shared/integrations.lua` — returning `true`/`false` overrides
everything above.

**Refused?** Run `/billingid` in game. It prints your identifiers and
the exact lines to paste on the server console. The same block is
printed automatically whenever someone is refused.

The three ways to grant access, in order of least effort:

```lua
-- shared/config.lua — no restart of the server needed, just the resource
Config.adminIdentifiers = { 'license:PASTE_YOURS_HERE' }
```

```cfg
# server.cfg — the dedicated ace
add_ace group.admin apex_billing.admin allow
add_principal identifier.license:PASTE_YOURS_HERE group.admin
```

```cfg
# server.cfg — let the resource grant its own ace on start-up.
# A resource can only run console commands when it holds `command`,
# which is why this line is needed (qb-core has the same one).
add_ace resource.apex_billing command allow
```

Set `Config.features.adminPanel = false` to disable the command entirely.

### Commands

```
/billingadmin                # open the admin panel (staff)
/billingid                   # show your identifiers + admin status (anyone)

apex_billing_expire          # run the expire sweep now
apex_billing_purge <days>    # delete settled invoices older than <days>
apex_billing_reload          # push config to every connected client
```

## Exports

Server (`exports['apex_billing']`):
```lua
:Bill({ issuer = src, recipient = otherSrc, title = '…',
        items  = { { label='…', qty=1, price=350 } },
        vatRate = 0.23, dueDays = 7,
        issueAs = 'player' })   -- 'player' | 'society' | nil (society when allowed, else personal)
:CanIssue(src, kind)       -- kind: nil (any) | 'society' | 'player'
:GetInvoice(id)            :GetInvoiceByNumber(number)
:ListReceivedFor(src)      :ListSentBy(src)
:ListForSociety(jobName)   :GetSocietyStats(jobName)
:OpenPanel(src)            :OpenInvoice(src, id)
```

Client:
```lua
exports['apex_billing']:Open()
exports['apex_billing']:OpenInvoice(id)
exports['apex_billing']:IsOpen()
exports['apex_billing']:PlayPrintAnim()
exports['apex_billing']:OpenAdmin()      -- still server-gated
exports['apex_billing']:IsAdminOpen()
```

## Open-source in escrow

`shared/*.lua`, `build/locales/*.lua` and `build/html/**` stay
open-source even in the escrowed build, so the config, theme,
integrations and HTML/CSS/JS are fully editable.

## Support

Discord: **discord.gg/apexscripts**
Store:   **apexscripts.xyz**
