# Apex Phone admin panel (`/phoneadmin`)

## Appearance: colors, glass and blur

The phone shop and the admin panel are glass windows on top of the game. In `/phoneadmin` > Appearance you choose, for
the **shop** and for the **panel** separately:

| Setting | What it does | Default |
|---|---|---|
| Brand color | Outlines, the main button, chips, bars and the header tint. Must not be almost black. | `#1F5EFF` (Apex blue) |
| Background color | The tint of the glass. Must be dark, the text is light. | `#131314` (Apex dark grey) |
| Glass opacity | 60 to 100 %. Lower shows more of the game behind the window. | 86 % |
| Blur the game behind | Blurs the game while that window is open (`TriggerScreenblurFadeIn`). | Shop off, panel on |

Eight ready-made palettes (Apex, Elevate, Graphite, Ocean, Emerald, Violet, Amber, Ruby) fill in both colors with one
click, and each card has a live preview of the window. The panel itself changes while you pick; players only see the
new look after you press Save. "Use the same on the panel / in the shop" copies one window's look to the other, and
"Reset" goes back to the defaults.

Where it is stored: the database (admin store key `theme`), never in the files. The server validates every value (hex
colors, dark enough background, bright enough brand, glass 60 to 100, blur true or false) and publishes it to every
player in `GlobalState['apex_phone:settings'].theme`:

```lua
theme = {
  shop  = { acc = '#1F5EFF', bg = '#131314', glass = 86, blur = false },
  admin = { acc = '',        bg = '',        blur = true },   -- '' / no glass = default
}
```

Themes saved by older versions (colors only) keep working: glass and blur fall back to the defaults.
