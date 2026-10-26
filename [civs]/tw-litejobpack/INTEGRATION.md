# External Integration API (Battlepass / Mission Systems)

tw-litejobpack fires **server-side events** that any other resource can listen to
with `AddEventHandler`. Event names always use the hardcoded `tw-litejobpack:`
prefix — they do NOT depend on `Config.EventPrefix`, so your integration keeps
working regardless of the pack's configuration.

No dependency line is required to listen to events. All events fire **server-side
only** — listen from a server script.

---

## 1. `tw-litejobpack:jobAction` — the generic action bus

Fires for **every tracked job action**, independent of the built-in quest system
(works even when `Config.Quests.enabled = false`). This is the event to build
your own battlepass missions on.

```lua
--- @param src        number  player server id
--- @param jobId      string  e.g. "powerwash", "miner", "metaldetector"
--- @param actionType string  'collect' | 'process' | 'earn' | 'complete'
--- @param count      number  amount (money for 'earn', item count otherwise)
--- @param meta       table|nil optional detail, see below
AddEventHandler('tw-litejobpack:jobAction', function(src, jobId, actionType, count, meta)
    -- your battlepass progress logic here
end)
```

### Action types

| actionType | When it fires | count | meta |
|---|---|---|---|
| `earn` | every payout to a player (per player, **after** all multipliers — daily bonus, weather, shift, perks, coop) | money amount | `nil` |
| `collect` | a world item is collected (rock broken, animal killed, spot dug, …) | `1` | may include `itemModel`, `itemId`, `itemName`, `value` (see below) |
| `process` | items are processed/sold at the scale/NPC | processed count | `nil` |
| `complete` | a job run finishes (fires once **per lobby member**) | `1` | `{ regionName, payment, xp, durationSeconds }` |

### meta detail for `collect`

- **miner / lumberjack / scrapyard** (collectable jobs): `{ itemModel = "prop_rock_5_d_emerald", itemId = "emerald", itemName = "Emerald" }` — `itemId`/`itemName` are only present when the job defines `oreTypes`.
- **hunting**: `{ itemModel = "a_c_deer" }` (the animal model).
- **metaldetector**: `{ itemId = "gold", itemName = "Gold Nugget", value = 1400 }`.
- Other jobs may pass `nil` — always nil-check `meta`.

### Examples

**"Earn $1,000 in the Powerwash job":**

```lua
AddEventHandler('tw-litejobpack:jobAction', function(src, jobId, actionType, count, meta)
    if jobId == 'powerwash' and actionType == 'earn' then
        MyBattlepass.AddProgress(src, 'powerwash_earn_1000', count) -- count = $ paid
    end
end)
```

**"Mine an emerald in the Mining job":**

```lua
AddEventHandler('tw-litejobpack:jobAction', function(src, jobId, actionType, count, meta)
    if jobId == 'miner' and actionType == 'collect' and meta and meta.itemId == 'emerald' then
        MyBattlepass.AddProgress(src, 'mine_emerald', 1)
    end
end)
```

**"Finish 5 job runs of any job":**

```lua
AddEventHandler('tw-litejobpack:jobAction', function(src, jobId, actionType, count, meta)
    if actionType == 'complete' then
        MyBattlepass.AddProgress(src, 'any_job_complete_5', 1)
    end
end)
```

### Semantics worth knowing

- `earn` events are **debounced**: rapid sub-payments within ~1.5s are merged into
  one event with the summed amount. Totals are always correct.
- In coop lobbies, `earn` and `complete` fire once per lobby member with that
  member's own (coop-adjusted) amounts.
- Amounts for `earn` are the final paid values (post-multiplier), matching what
  the player actually received.

---

## 2. Quest (monthly mission) events

If you want to mirror the pack's **built-in missions** into your battlepass
("reward on both sides at the same time"), listen to these. They only fire when
`Config.Quests.enabled = true`.

### `tw-litejobpack:questCompleted`

Fires once when a player completes a quest (right after the pack pays its own
quest reward).

```lua
--- @param src        number player server id
--- @param identifier string framework identifier (citizenid / license / passport)
--- @param quest      table  { questId, jobId, action, target, resetPeriod, rewards = { money, xp } }
AddEventHandler('tw-litejobpack:questCompleted', function(src, identifier, quest)
    MyBattlepass.CompleteMission(src, 'litejobs_' .. quest.questId)
end)
```

### `tw-litejobpack:questProgress`

Fires on **every progress change**, including the completing tick
(`data.completed = true` on the final one).

```lua
--- @param data table { questId, jobId, action, progress, target, completed }
AddEventHandler('tw-litejobpack:questProgress', function(src, identifier, data)
    MyBattlepass.SetProgress(src, 'litejobs_' .. data.questId, data.progress, data.target)
end)
```

Quest definitions (ids, jobs, targets, rewards) live in `Config.Quests.quests`
inside `shared/config_settings.lua`.

---

## 3. Related existing exports

These already exist and complement the events:

| Export | Direction | Purpose |
|---|---|---|
| `exports['tw-litejobpack']:TrackQuestAction(src, jobId, actionType, count)` | you → pack | push external progress INTO the pack's quest system |
| `exports['tw-litejobpack']:GetPlayerQuests(identifier, jobId)` | you ← pack | read a player's quest states (progress/completed) |
| `exports['tw-litejobpack']:GetJobLevel(identifier, jobId)` / `GetAllJobLevels(identifier)` | you ← pack | job levels (e.g. "reach level 5 in miner" missions) |
| `exports['tw-litejobpack']:SetJobPayMultiplier(jobId, mult, seconds)` | you → pack | timed pay boost (e.g. a battlepass reward) |

---

## 4. Menu open/close events (client-side)

Fired on the **client** when the job-center menu (the fullscreen job list /
job-start lobby screen) opens and closes. Use them to hide your HUD, minimap
overlays, etc. while the menu is on screen.

| Event | When |
|---|---|
| `tw-litejobpack:client:menuOpened` | menu opened — pressing E at the job center NPC, or being pulled into the job-start screen by accepting a lobby invite |
| `tw-litejobpack:client:menuClosed` | menu closed — any path: X button / ESC, job started, external job selected, kicked from lobby, lobby transferred/closed, job reset, resource stop/restart |

Guarantees:

- **Client-side local events** — listen with `AddEventHandler` in a client
  script (they are not networked, `RegisterNetEvent` is not needed).
- **Always paired**: every `menuOpened` is eventually followed by exactly one
  `menuClosed`, including on `restart tw-litejobpack` while the menu is open —
  your HUD can never get stuck hidden.
- **Never double-fired**: internal screen switches inside the menu (job list ↔
  job-start lobby ↔ UI position-move mode) do not re-fire either event.
- The finish-job modal, `/progress` panel and invite toast do **not** fire
  these events — they only cover the fullscreen job-center menu.

### Example — hide your HUD while the menu is open

```lua
-- client-side, in your HUD resource
AddEventHandler('tw-litejobpack:client:menuOpened', function()
    -- hide your UI here
    SendNUIMessage({ action = 'setHudVisible', visible = false })
    DisplayRadar(false)
end)

AddEventHandler('tw-litejobpack:client:menuClosed', function()
    -- restore it here
    SendNUIMessage({ action = 'setHudVisible', visible = true })
    DisplayRadar(true)
end)
```

---

## Notes

- Events are fire-and-forget; a crashing handler in your resource cannot break
  the job pack (emission is pcall-wrapped), and vice versa.
- Do not rely on event ordering between `jobAction('earn')` and
  `questProgress` — treat them as independent streams.
- Added in v1.4.1. Ask support if your version predates these events.
