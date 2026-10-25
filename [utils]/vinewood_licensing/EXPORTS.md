# vinewood_licensing — server exports

All exports are **server-side**. `identifier` can be a **server id** (number) or a
**citizenid** (string). Citizenid lookups fall back to the database when the player
is offline, so an MDT can search a record with nobody logged in.

```lua
-- does this person hold a full licence?
local hasAny = exports.vinewood_licensing:HasLicence(source)
local canDriveCar = exports.vinewood_licensing:HasLicence('ABC12345', 'car')

-- every category held: { car = true, bike = true }
local licences = exports.vinewood_licensing:GetLicences(source)

-- learner only?
local isLearner = exports.vinewood_licensing:HasProvisional(source)  -- online players only

-- one call for an MDT record
local record = exports.vinewood_licensing:GetLicenceData('ABC12345')

-- mugshot / licence photo URL (Fivemanage), or nil
local photo = exports.vinewood_licensing:GetLicencePhoto(source)

-- admin / court actions
exports.vinewood_licensing:GrantLicence(source, 'car')
exports.vinewood_licensing:RevokeLicence(source, 'car')   -- omit category to revoke everything
```

## GetLicenceData returns

| Field | Type | Notes |
|---|---|---|
| `citizenid` | string | |
| `online` | boolean | false means the data came from the database |
| `firstname`, `lastname` | string | |
| `licences` | table | `{ car = true }` |
| `categories` | string | UK codes, e.g. `AM, B, B1` |
| `hasLicence` | boolean | holds at least one full category |
| `hasProvisional` | boolean | online only |
| `provisionalOnly` | boolean | the item they carry is a provisional |
| `number` | string | licence number |
| `issued`, `expiry` | string | `DD.MM.YYYY` |
| `photo` | string | Fivemanage URL, or nil |
| `address` | string | may contain newlines |

Offline lookups return licence categories only. Anything read from the inventory
(`photo`, `number`, `hasProvisional`) needs the player online.

## Event

Fired server-side whenever a licence changes, so an MDT can refresh its cache:

```lua
AddEventHandler('vinewood_licensing:server:licenceUpdated', function(citizenid, action, category)
    -- action: 'granted' | 'revoked'   category: 'car' | nil (all)
end)
```

Note: this fires for the export calls above. Licences granted by passing a test go
through the same internal path, so add a listener rather than polling.

## Requirements

- Offline citizenid lookups need `oxmysql` running and the standard qbx `players`
  table with a JSON `metadata` column. Without it, offline lookups return empty.
- `GrantLicence` / `RevokeLicence` need the player online, since they write to
  character metadata and the inventory.

---

# Penalty points and driving bans

All server-side, same `identifier` rules (server id or citizenid). Points and bans
are **write-online-only** — the player must be connected.

```lua
-- endorse a licence: identifier, points, code, reason, officer
local ok, total, autoBanned = exports.vinewood_licensing:AddPoints(src, 3, 'SP30', 'Speeding 45 in a 30', 'PC 102 Shaw')

-- read them back
local total, endorsements = exports.vinewood_licensing:GetPoints('ABC12345')
-- endorsements = { { points = 3, code = 'SP30', reason = ..., officer = ..., issued = ts, expires = ts }, ... }

exports.vinewood_licensing:ClearPoints(src)              -- court appeal / admin fix

-- bans: days = nil or 0 means indefinite
exports.vinewood_licensing:BanDriver(src, 180, 'Dangerous driving', 'PC 102 Shaw')
exports.vinewood_licensing:UnbanDriver(src)

local banned, ban = exports.vinewood_licensing:IsBanned(src)
-- ban = { until_ = ts, permanent = bool, reason = ..., by = ..., issued = ts }
```

`GetLicenceData` now also returns `points`, `endorsements`, `banned` and `ban`.

## Behaviour

- **Expiry.** Points drop off automatically after `Config.Penalties.PointsExpireYears`
  (4 by default, matching UK practice). Bans clear themselves when the date passes.
  Both are pruned on read, so an MDT always sees current figures.
- **Totting up.** Reaching `TottingThreshold` (12) triggers an automatic ban of
  `AutoBanDays` (180). `AddPoints` returns `autoBanned = true` when that happens, so
  the MDT can tell the officer. Points are wiped on a totting ban by default.
- **While banned.** `HasLicence` returns false, so any script already checking it
  treats them as unlicensed. `IsBanned` tells them apart from someone who never passed.
  Set `BanBlocksLicence = false` to decouple this.
- **The physical licence.** Left in the inventory by default, but marked REVOKED -
  DISQUALIFIED in red when shown, with the photo desaturated. Set `BanRemovesItem = true`
  to confiscate it instead.
- Banned drivers cannot book theory or practical tests.
- Points appear on the card when above zero.

## Events

```lua
AddEventHandler('vinewood_licensing:server:licenceUpdated', function(citizenid, action, category)
    -- action: 'granted' | 'revoked' | 'points' | 'banned' | 'unbanned'
end)
```

## Offline drivers

Points and bans can only be written to a loaded character, so anything issued while
the driver is offline is **queued in the database and applied when they next log in**.
This is automatic — the MDT calls the same exports either way.

```lua
-- works whether they're online or not (offline needs a citizenid, not a server id)
local ok, total, autoBanned, status = exports.vinewood_licensing:AddPoints('ABC12345', 3, 'SP30', 'Speeding', 'PC Shaw')
-- status == 'queued' means it will apply at next login; total/autoBanned are nil then
```

`BanDriver`, `UnbanDriver` and `ClearPoints` behave the same way and return
`'queued'` as their second return value when parked.

Reading works offline too. `GetPoints` returns a third value listing queued
endorsements that haven't landed yet, so the MDT can show them as pending:

```lua
local total, endorsements, queued = exports.vinewood_licensing:GetPoints('ABC12345')
```

`IsBanned` reports a queued ban as banned, with `ban.pending = true`.

Managing the queue:

```lua
exports.vinewood_licensing:GetPendingActions('ABC12345')    -- list what's waiting
exports.vinewood_licensing:ClearPendingActions('ABC12345')  -- cancel it (issued in error)
```

The table `vinewood_licensing_pending` is created automatically on first start. It needs
oxmysql; without it, offline writes fail and a warning is printed.

---

# Direct database access

The script keeps a flat mirror table, `vinewood_licensing_records`, with one row
per driver. An MDT can query it directly — online or offline — without decoding
character metadata or going through exports. It's written whenever anything
changes: a pass, a provisional, a replacement, a new photo, points, a ban, and
once more when the player disconnects.

## Schema

| Column | Type | Notes |
|---|---|---|
| `citizenid` | varchar(64) PK | |
| `firstname`, `lastname` | varchar(64) | indexed on surname |
| `dob` | varchar(16) | `DD.MM.YYYY` |
| `licence_number` | varchar(32) | indexed |
| `categories` | varchar(190) | UK codes, e.g. `B, B1` |
| `has_licence` | tinyint | holds at least one full category |
| `provisional` | tinyint | holds provisional entitlement |
| `issued`, `expiry` | varchar(16) | `DD.MM.YYYY` |
| `photo` | text | Fivemanage URL |
| `address` | text | may contain newlines |
| `points` | int | current total |
| `endorsements` | longtext | JSON array of every endorsement |
| `banned` | tinyint | indexed |
| `ban_until` | int | unix time; null on an indefinite ban |
| `ban_reason`, `ban_by` | varchar | |
| `updated_at` | int | unix time of last write |

A ban is live when `banned = 1 AND (ban_until IS NULL OR ban_until > UNIX_TIMESTAMP())`.
Expired bans are cleared the next time that driver's row is written, so check the
date rather than trusting `banned` alone.

## Query helpers

If you'd rather not write SQL in the MDT:

```lua
exports.vinewood_licensing:SearchDrivers('Morgan', 25)  -- surname, forename or licence no.
exports.vinewood_licensing:GetRecord('ABC12345')        -- one row
exports.vinewood_licensing:GetBannedDrivers()           -- everyone currently disqualified
exports.vinewood_licensing:RebuildRecords()             -- re-sync everyone online
```

## Populating it

The table fills as players log in. If you're adding this to a live server, run
`RebuildRecords` once with people connected, or just let it fill over a day or
two — characters who have never logged in since the update won't have a row, and
the exports fall back to reading character metadata for them.
