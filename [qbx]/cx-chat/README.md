# cx-chat

**Frameworks:** QBCore, QBox, ESX

Fully featured Custom FiveM chat — themes, reactions, pinning, moderation, minigames, drag-to-reposition chat, and native chat compatibility out of the box.

## Features

- 19 built-in themes + fully custom theme
- Drag-to-reposition UI with scale slider
- Message reactions, pinning, editing, and deletion
- Profanity filter — replace or block mode with auto-kick on repeated violations
- Player `@mentions`
- Right-click quick actions on player names — PM, report, copy ID
- Typing indicators, message history navigation, Tab channel cycling
- In-chat minigames — `/dice`, `/coinflip`, `/rps`
- `/me` above-head roleplay text, floating player ID tags (`/ids`)
- MOTD on join, join/leave notifications, configurable channels
- Report system with categories, logged to your logging service
- Staff badges via ACE permissions
- Native FiveM chat API compatibility

---

## Installation

1. Drop `cx-chat` into your resources folder
2. Add `ensure cx-chat` to `server.cfg`
3. Set `Config.Framework` and review `config.lua`
4. Add ACE permissions (see below)

---

## Permissions

| Permission | Description |
|------------|-------------|
| `group.admin` | **ADMIN** badge on messages |
| `group.mod` | **MOD** badge on messages |
| `group.staff` | **STAFF** badge on messages |
| `chat.staff` | Custom staff badge from `Config.StaffBadge` (overrides group badges) |
| `cx-chat.pin` | Pin / unpin messages |
| `cx-chat.delete` | Delete any player's message |
| `cx-chat.mute` | Mute players via context menu |

> `cx-chat.delete` and `cx-chat.mute` are validated server-side on every action.

```
add_principal group.admin group.mod
add_principal group.mod group.staff

add_ace group.staff  chat.staff     allow
add_ace group.mod    cx-chat.pin    allow
add_ace group.admin  cx-chat.delete allow
add_ace group.admin  cx-chat.mute   allow
add_ace group.mod    cx-chat.mute   allow

add_principal identifier.license:XXXXXXXXX group.admin
```

---

## Logging

Configure your logging method in `server/s_logging.lua`.  
Supported: `discord`, `ox_lib`, `fivemanage`, `fivemerr`

Logged events: profanity violations, player reports, message deletions.

---

## Message Formatting

```
**bold**   *italic*   __underline__   `code`   @PlayerName
```
---
## QBOX USERS:
If you see qbx_core throw a script error `SCRIPT ERROR: @qbx_core/client/events.lua:19: No such export addMessage in resource chat.` **To get rid of this error you can go to** `[qbx]\qbx_core\client\events.lua` and comment out the export on `line:19`
```lua
    local motd = GetConvar('qbx:motd', '')
    if motd ~= '' then
        --exports.chat:addMessage({ template = motd })
    end
```
##### Restart your server and the error should no longer occur!
---
### How to disable QBOX Chat:
##### In your server.cfg make sure you've changed these 2
`set resources_useSystemChat false`
##### Comment out chat
`# ensure chat`

---
## Server Exports

### SendCustomMessage
```lua
exports['cx-chat']:SendCustomMessage({
    message   = "Welcome!",
    name      = "Server",
    color     = "#3dd68c",
    tag       = "WELCOME",
    tagColor  = "#3dd68c",
    channel   = "global",
    target    = playerId,
    playSound = true,
})
```

### SendRichMessage
```lua
exports['cx-chat']:SendRichMessage({
    title       = "Alert",
    description = "Something happened.",
    color       = "#ef4444",
    tag         = "ALERT",
    fields      = {
        { name = "Location", value = "Downtown" },
    },
    target    = playerId,
    playSound = true,
})
```

### MutePlayer
```lua
exports['cx-chat']:MutePlayer(playerId, 300)  -- 300 seconds
```

### PinMessage / UnpinMessage
```lua
exports['cx-chat']:PinMessage({ id = msgId, message = "text", name = "Admin" })
exports['cx-chat']:UnpinMessage(msgId)
```

### AddReaction
```lua
exports['cx-chat']:AddReaction(msgId, playerId, "👍")
```

---

## Client Exports

```lua
exports['cx-chat']:openChat()
exports['cx-chat']:closeChat()

exports['cx-chat']:addMessage("System message.")
exports['cx-chat']:addMessage("Sender", "Message text.")

exports['cx-chat']:addSuggestion("/cmd", "Help text", { { name = "arg", help = "..." } })
exports['cx-chat']:addSuggestions({ { name = "/foo", help = "..." } })
exports['cx-chat']:removeSuggestion("/cmd")
exports['cx-chat']:clearSuggestions()
```

---

## Net Events

```lua
Broadcast or target a player:

TriggerClientEvent("cx-chat:addMessage", -1, {
    message   = "Server restarting in 5 minutes.",
    color     = "#ef4444",
    tag       = "NOTICE",
    tagColor  = "#ef4444",
    isSystem  = true,
    playSound = true,
})

Job announcement (player must be in Config.AnnouncementJobs):

TriggerEvent("cx-chat:server:jobAnnounce", src, "Units respond to Pillbox.", true)
```

---

## Native Chat Compatibility

Other resources using the standard FiveM chat API work without modification.

| Event | Behaviour |
|-------|-----------|
| `chat:addMessage` | Rendered as a system message |
| `chat:addSuggestion` / `chat:addSuggestions` | Registered in autocomplete |
| `chat:clear` | Clears the window |
| `chatMessage` | Cancelled — cx-chat handles routing |
