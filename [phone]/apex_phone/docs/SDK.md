# Apex Phone SDK 1.5.0: build your own app for the phone

The SDK lets you write a phone app from scratch, in plain HTML, CSS and JavaScript, with your own server logic in Lua. The app runs inside the phone (PearOS and Nova UI), follows the player's theme, uses the phone's keyboard, sounds, notifications, badges, live pushes and a per character storage on the server. Nothing inside `apex_phone` has to be edited, and apps registered the old way (README, "Custom apps") keep working exactly as before.

What you get in `apex_phone/sdk/`:

| File | What it is |
|---|---|
| `apexphone-sdk.js` | The JavaScript library for your page: `window.ApexPhone`. No dependencies, plain ES5. |
| `apexphone-ui.css` | The UI kit: the phone's tokens and components (`.ap-*`) for both systems and both themes. |
| `example/apex_phone_example/` | A complete resource ("Taxi Rank") you can copy to `resources/` and start. |

## 1. Install in 5 steps

1. Copy `sdk/example/apex_phone_example` to your `resources/` folder and rename it (for example `my_phone_app`). Keep the `html/` folder with `apexphone-sdk.js`, `apexphone-ui.css` and `fonts/`.
2. In `fxmanifest.lua` keep every file your page loads listed in `files { ... }` (the phone loads your page from `nui://<resource>/html/index.html`, and the CEF only serves listed files).
3. In `server.lua` change `APP` (the app id: letters, digits, `_ - . :`, up to 64), the `url` to your resource name and the `name`, `icon`, `description`.
4. Add `ensure my_phone_app` to `server.cfg` after `ensure apex_phone` (the example has `dependency 'apex_phone'`, so the order is also enforced).
5. Start the server. The icon appears on every phone; open it. Edit `html/index.html`, `html/app.js` and `server.lua` from there.

If you already have a page registered the old way, just add `<script src="apexphone-sdk.js"></script>` and the CSS to it. The `postMessage` protocol described in the README still works underneath.

You can also load the two files straight from the phone instead of copying them, so you always run the version that ships with the installed `apex_phone`: `<link rel="stylesheet" href="nui://apex_phone/sdk/apexphone-ui.css">` and `<script src="nui://apex_phone/sdk/apexphone-sdk.js"></script>`. Copying is the safer choice when you customise the kit.

## 2. How it works (lifecycle)

1. Your `server.lua` calls `exports['apex_phone']:RegisterApp({...})` when it starts (and again when `apex_phone` restarts: the registrations live in the phone's memory).
2. The phone shows the icon. When the player opens it, your page is loaded in an iframe of 440 x 956 CSS px (see section 8 for the foldables).
3. The phone sends `init` to your page. `ApexPhone.ready()` resolves with it: theme, player, account, screen size, system (`ios` or `android`), language. The SDK writes `data-os` and `data-theme` on your `<html>` so the UI kit switches look.
4. Your page asks your server with `ApexPhone.call('name', data)`. The phone forwards it to the handler you registered with `exports['apex_phone']:RegisterAppRPC(appId, 'name', fn)`. Only the resource that registered the app can register handlers for it.
5. Your server can push to the open page at any time with `exports['apex_phone']:PushToApp(target, appId, 'event', data)`; the page listens with `ApexPhone.on('event:event', fn)`.
6. The phone sends `theme`, `size`, `lang`, `player`, `pause` and `resume` while the app is open.
7. When the player leaves, the iframe is kept in the background (the app switcher) until the phone closes it. Save state you care about with `ApexPhone.storage`, never only in page variables.

## 3. JavaScript API (`window.ApexPhone`)

Every method that waits for the phone returns a Promise. A failure rejects with an `Error` whose `.code` is one of the codes in section 11. Outside the phone (opening your page in a browser) everything rejects with `nophone`, so the page can still be previewed.

### 3.1 Start and state

| Method | Returns | Notes |
|---|---|---|
| `ApexPhone.ready()` | Promise of `init` | Resolves at once if `init` already arrived. |
| `ApexPhone.info` | the last `init` merged with later `theme` and `size` messages | `null` before `init`. |
| `ApexPhone.inPhone` | boolean | `false` when the page is not inside the phone. |
| `ApexPhone.version` | `'1.5.0'` | |
| `ApexPhone.config` | `{ autoTheme: true, autoTyping: true, autoKeyboard: false }` | Change before `init` arrives (top of your script). |

The `init` object: `{ app, theme: 'light' | 'dark', dark, accent, lang, glassTint, player, account: { username, phone, avatar }, screen: { w, h }, form: 'bar' | 'fold', foldOpen, os: 'ios' | 'android', model }`. `player.money` is only present after the player allowed "Bank" (section 10).

### 3.2 Events: `ApexPhone.on(name, fn)` returns a function that removes the listener; `ApexPhone.off(name, fn)` does the same.

| Event | Argument | When |
|---|---|---|
| `init` | the init object | Each time the phone sends `init` (also after `ready` re-asks). |
| `theme` | `{ theme, dark, accent, lang, glassTint }` | The player changed theme, accent or the Liquid Glass tint. |
| `size` | `{ screen: { w, h }, form, foldOpen, os, model }` | The container changed (fold opened or closed). Also listen to your own `window` `resize`. |
| `lang` | `'en'`, `'pt'`, ... | The phone language changed. |
| `resume` / `pause` | nothing | The app came back to the front / went to the switcher or the phone closed. |
| `player` | the player object | Money, job or name changed. |
| `event` | `{ name, data }` | Any push from your server (`PushToApp`). |
| `event:<name>` | `data` | A push with that exact name (`ApexPhone.on('event:ride:new', fn)`). |
| `keyboard` | `{ shown, height, enter, hidden, value }` | The phone keyboard opened, typed, pressed Enter or closed (section 9). |
| `vera` | the pattern | A Vera command you registered was said. |

### 3.3 Your server (the part the old protocol did not have)

| Method | Message to the phone | Server side | Result |
|---|---|---|---|
| `ApexPhone.call(name, data)` | `appcall` | `RegisterAppRPC(appId, name, function(src, data) ... end)` | Resolves with whatever your handler returned (`nil` becomes `null`). If the handler returns a table with an `error` field the promise rejects with that code. |
| `ApexPhone.storage.get(key)` | `kv` get | table `apex_phone_app_kv` | The value you stored (any JSON value) or `null`. |
| `ApexPhone.storage.set(key, value)` | `kv` set | | `true`. Value is JSON encoded; limits in section 11. |
| `ApexPhone.storage.remove(key)` | `kv` remove | | `true` |
| `ApexPhone.storage.keys()` | `kv` keys | | Array of keys of this app for this character. |

Storage is per app and per character (citizen id), saved on the server: the player keeps it on another PC and after a cache wipe. Your Lua reads and writes the same values with `GetAppStorage` and `SetAppStorage` (section 5).

`data` sent with `call` must be JSON (no functions, no cycles) and under 48 KB. Lists coming back from Lua: a table with keys 1..n arrives as an array, an EMPTY table arrives as `{}`. Use `ApexPhone.util.list(v)` to always get an array.

### 3.4 Actions on the phone

| Method | Does |
|---|---|
| `ApexPhone.notify({ title, msg })` | Banner notification with your app's icon. For notifications while the app is closed, use the server export `SendNotification` (README). |
| `ApexPhone.toast(msg)` | Short text at the bottom of the phone. |
| `ApexPhone.close()` | Closes your app (back to the home screen). |
| `ApexPhone.openApp(id)` | Opens another app. |
| `ApexPhone.openURL('phone://messages/thread/555-0101')` | Opens a phone deep link (`phone://<app>/<path>?a=b`). Only `phone://` links. |
| `ApexPhone.setWaypoint(x, y, name)` | GPS waypoint. |
| `ApexPhone.dial(number, name)` | Starts a phone call. |
| `ApexPhone.message(number, name)` | Opens the Messages thread with that number. |
| `ApexPhone.setBadge(n)` | Number on your icon (0 removes it). Respects the player's notification settings for your app. |
| `ApexPhone.haptic('light' | 'heavy')` | Short tap sound (the phone has no vibration). |
| `ApexPhone.sound(name)` | Plays a phone sound: `click`, `tap`, `success`, `error`, `notify`, `pop`, `send`, `lock`, `unlock`. |
| `ApexPhone.typing(on)` | Tells the phone a text field of yours has (`true`) or lost (`false`) the focus, so the game stops receiving the keys. Sent automatically for `input`, `textarea` and `contenteditable` (`config.autoTyping`). |
| `ApexPhone.widget({ id, name, size, template, data })` | Home screen widget. Templates `stat`, `list`, `progress`, `text` (README). |
| `ApexPhone.activity.start(id, { title, subtitle, icon, progress, eta, state })`, `.update(id, {...})`, `.stop(id)` | Live activity in the Dynamic Island. |
| `ApexPhone.vera(pattern, reply, fn)` | Answers a sentence said to Vera (regex pattern, up to 20 per app) and calls `fn`. |
| `ApexPhone.theme.apply(document)` | Writes `data-os`, `data-theme`, `data-form`, `lang`, `--accent`, `--ap-tint`, `--ap-screen-w/h` on a document. Done automatically on your own document (`config.autoTheme`); call it for another document (an inner iframe) if you need. |
| `ApexPhone.keyboard.show(field)`, `.hide()`, `.attach(root)` | The phone's own keyboard for your fields (section 9). |

### 3.5 Data from the phone (ask the player the first time)

| Method | Returns | Permission |
|---|---|---|
| `ApexPhone.getPlayer()` | player object | none (`money` only with "Bank") |
| `ApexPhone.getContacts()` | array of contacts | Contacts |
| `ApexPhone.getLocation()` | `{ x, y, z, heading }` | Location |
| `ApexPhone.rpc(name, data)` | the phone RPC result | the phone RPCs allowed to external apps: `contacts.list`, `photos.list`, `messages.send`, `bank.info`, `player.get`, `services.list` (`Config.ExternalApps.rpc`); the sensitive ones ask the player |

### 3.6 Helpers: `ApexPhone.util.list(v)` (array from a Lua table), `ApexPhone.util.esc(text)` (HTML escape; never put player text in `innerHTML` without it), `ApexPhone.util.el(html)` (one element from an HTML string).

## 4. Minimal page

```html
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="apexphone-ui.css">
</head>
<body>
<div class="ap-screen">
  <div class="ap-navbar ap-large"><div class="ap-nb-left"></div><div class="ap-nb-title">Notes</div><div class="ap-nb-right"></div></div>
  <div class="ap-content">
    <div class="ap-large-title">Notes</div>
    <div class="ap-group" id="list"></div>
  </div>
</div>
<script src="apexphone-sdk.js"></script>
<script>
ApexPhone.ready().then(function (init) {
  return ApexPhone.call('list');
}).then(function (r) {
  var box = document.getElementById('list');
  ApexPhone.util.list(r.items).forEach(function (it) {
    var row = ApexPhone.util.el('<div class="ap-li"><div class="ap-li-body"><div class="ap-li-label"></div></div></div>');
    row.querySelector('.ap-li-label').textContent = it.text;
    box.appendChild(row);
  });
}).catch(function (e) { ApexPhone.toast('Error: ' + e.code); });
</script>
</body>
</html>
```

## 5. Lua API (server exports of `apex_phone`)

```lua
local APP = 'myapp'

exports['apex_phone']:RegisterApp({ id = APP, name = 'My App', url = 'nui://my_phone_app/html/index.html',
    icon = { label = 'MA', color = '#FF9F0A' }, category = 'Utilitários', description = 'What it does', defaultInstalled = true })

exports['apex_phone']:RegisterAppRPC(APP, 'list', function(src, data)
    return { items = Items }                 -- anything JSON. nil is fine. { error = 'code' } rejects on the page.
end)

exports['apex_phone']:PushToApp(-1, APP, 'item:new', item)       -- every open page; src, citizen id, phone number or a list also work
exports['apex_phone']:SetAppBadge(src, APP, 3)                   -- 0 removes it
local prefs = exports['apex_phone']:GetAppStorage(cid, APP, 'settings')   -- what the page saved with ApexPhone.storage
exports['apex_phone']:SetAppStorage(cid, APP, 'settings', { driver = true })  -- nil deletes
exports['apex_phone']:UnregisterAppRPC(APP, 'list')
```

| Export | Arguments | Returns |
|---|---|---|
| `RegisterApp(def)` | see README "Custom apps" | `true` / `false` |
| `RegisterAppRPC(appId, name, fn)` | `fn(src, data, appId)`; `name` letters, digits, `_ - . :` up to 64 | `true`, or `false` when the app belongs to another resource or the name is invalid |
| `UnregisterAppRPC(appId, name)` | | `true` / `false` |
| `PushToApp(target, appId, event, data)` | `target` = `src` (number), citizen id (string), phone number (string), `-1` (everyone) or a list; `data` JSON up to 32 KB | number of recipients, or `false` |
| `SetAppBadge(target, appId, n)` | `n` 0..9999 | number of recipients, or `false` |
| `GetAppStorage(cid, appId, key)` | | the decoded value or `nil` |
| `SetAppStorage(cid, appId, key, value)` | `value` any JSON value, `nil` deletes | `true`, or `false, 'invalid' | 'toolarge' | 'limit'` |
| `SendNotification(target, { app = APP, title, msg })` | README | persistent notification, also for offline players (citizen id as target) |
| `GetPlayerInfo(src)` | | `{ citizenid, firstname, lastname, phone, job, money }` |

Rules:

1. Handlers belong to the resource that registered the app. If you call `RegisterAppRPC` before `RegisterApp` the handlers are kept, but the app must then be registered by the same resource, or they are dropped (with a console line).
2. `PushToApp` and `SetAppBadge` are refused for an app owned by another resource.
3. Handlers may use `MySQL.*.await` and other blocking calls: each request runs in its own thread, under `pcall`. A Lua error prints in the server console and the page gets `internal`.
4. Everything that leaves a handler is copied through JSON: functions and userdata are not allowed, the result is capped at 200 KB.
5. Register again when `apex_phone` restarts: `AddEventHandler('onResourceStart', function(res) if res == 'apex_phone' then setup() end end)` (see the example).

## 6. UI kit (`apexphone-ui.css`)

Load it before your own CSS. Everything is a class starting with `ap-`. The look switches by itself with `data-os` and `data-theme` on `<html>` (written by the SDK). Colours come from the phone's tokens: `--accent` (the player's accent), `--label`, `--label2`, `--label3`, `--bg`, `--bg2`, `--fill`, `--fill2`, `--fill3`, `--sep`, `--red`, `--green`, `--orange`, ... and the type scale `--t-large`, `--t-title2`, `--t-headline`, `--t-body`, `--t-subhead`, `--t-foot`. Use them in your own CSS and your app follows the theme too.

### 6.1 Screen, bar and content

```html
<div class="ap-screen">
  <div class="ap-navbar ap-large" id="nav">
    <div class="ap-nb-left"><div class="ap-nb-back"><svg viewBox="0 0 24 24"><path d="M15 6l-6 6 6 6"/></svg>Back</div></div>
    <div class="ap-nb-title">Title</div>
    <div class="ap-nb-right"><div class="ap-nb-btn ap-glass"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg></div></div>
  </div>
  <div class="ap-content ap-has-tabbar">
    <div class="ap-large-title">Title<small>Subtitle</small></div>
    ...
  </div>
</div>
```

1. `.ap-navbar` already reserves the status bar (`--ap-safe-top`). `.ap-large` hides the small title until you add `.ap-show-title` (do it when the content scrolls past the large title, see the example `onScroll`). `.ap-solid` gives the bar a background.
2. `.ap-nb-btn` is a text button; `.ap-nb-btn.ap-glass` is the PearOS glass circle (material, ring and drop shadow; no backdrop-filter); `.ap-capsule` makes it a capsule with text; `.ap-nb-group` puts several glass buttons in one capsule.
3. `.ap-content` scrolls. Add `.ap-has-tabbar` when a tab bar floats over it.

### 6.2 Tab bar

```html
<div class="ap-tabbar">
  <div class="ap-tb-pill">
    <div class="ap-tab on" data-tab="a"><svg viewBox="0 0 24 24">...</svg><span>Rides</span><i class="ap-tb-badge">2</i></div>
    <div class="ap-tab" data-tab="b"><svg viewBox="0 0 24 24">...</svg><span>New</span></div>
  </div>
  <div class="ap-tab-round"><svg viewBox="0 0 24 24">...</svg></div>
</div>
```

`.on` marks the active tab. `.ap-tabbar.ap-compact` shrinks it while scrolling down, `.ap-hide` slides it out. `.ap-tab-round` is the separate search circle. On Nova UI the pill spans the width, as in the One UI 8.5 apps.

### 6.3 Grouped lists

```html
<div class="ap-group-header">Section</div>
<div class="ap-group">
  <div class="ap-li ap-has-icon">
    <div class="ap-li-icon" style="background:var(--orange)"><svg viewBox="0 0 24 24">...</svg></div>
    <div class="ap-li-body"><div class="ap-li-label">Label</div><div class="ap-li-sub">Second line</div></div>
    <div class="ap-li-value">Value</div>
    <svg class="ap-chev" viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg>
  </div>
  <label class="ap-li ap-static">
    <div class="ap-li-body"><div class="ap-li-label">Toggle</div></div>
    <span class="ap-toggle"><input type="checkbox"><span></span></span>
  </label>
  <label class="ap-li ap-static"><span class="ap-li-key">Name</span><input type="text" placeholder="Required"></label>
  <div class="ap-li ap-center">Centered action</div>
  <div class="ap-li ap-danger">Delete</div>
</div>
<div class="ap-group-footer">Explanation under the group.</div>
```

`.ap-static` removes the press highlight. `.ap-has-icon` moves the separator to the text. `.ap-li.on .ap-check` shows a check mark (`<svg class="ap-check">`). `.ap-avatar` (with `.ap-sm`, `.ap-lg`, `.ap-tint`) fits as the first child.

### 6.4 Buttons, cards, segmented, chips, search, fields

```html
<div class="ap-btn">Primary</div>
<div class="ap-btn ap-secondary">Secondary</div>
<div class="ap-btn ap-danger">Destructive</div>
<div class="ap-btn-row"><div class="ap-btn ap-secondary">A</div><div class="ap-btn ap-secondary">B</div></div>
<div class="ap-btn ap-small ap-inline">Small</div>
<div class="ap-fab"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg></div>

<div class="ap-card"><div class="ap-card-title">Title</div><div class="ap-card-sub">Sub</div><div class="ap-stat">12<small>km</small></div></div>
<div class="ap-seg"><div class="on">All</div><div>Open</div><div>Mine</div></div>
<div class="ap-chips"><span class="on">All</span><span>Open</span><span class="ap-tint">Mine</span></div>
<div class="ap-search"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/></svg><input type="search" placeholder="Search"></div>
<div class="ap-field"><label>Pickup</label><input type="text"></div>
<div class="ap-field"><textarea placeholder="Note"></textarea></div>
```

Add `.ap-dis` to disable a button (or the `disabled` attribute on a real `<button class="ap-btn">`).

### 6.5 Sheet, alert, toast, empty state, badges, skeleton, spinner

```html
<div class="ap-sheet-wrap" id="sheet">
  <div class="ap-sheet">
    <div class="ap-sheet-grab"></div>
    <div class="ap-sheet-head"><div class="ap-sh-l">Cancel</div><b>Title</b><div class="ap-sh-r">Done</div></div>
    <div class="ap-sheet-body">...</div>
    <div class="ap-sheet-foot"><div class="ap-btn">Save</div></div>
  </div>
</div>
<div class="ap-alert-wrap" id="alert">
  <div class="ap-alert">
    <div class="ap-alert-body"><div class="ap-alert-title">Delete?</div><div class="ap-alert-msg">This cannot be undone.</div></div>
    <div class="ap-alert-btns"><div>Cancel</div><div class="ap-danger ap-bold">Delete</div></div>
  </div>
</div>
<div class="ap-toast" id="toast">Saved</div>
<div class="ap-empty"><svg viewBox="0 0 24 24">...</svg><b>No rides</b><span>Nobody is waiting right now.</span></div>
<span class="ap-badge">3</span> <span class="ap-pill ap-green">open</span>
<div class="ap-li ap-skeleton"><div class="ap-sk ap-sk-circle"></div><div class="ap-li-body"><div class="ap-sk ap-sk-l1"></div><div class="ap-sk ap-sk-l2"></div></div></div>
<div class="ap-spinner"></div>
```

Open a sheet or alert by adding the class `in` to the wrapper (`sheet.classList.add('in')`); remove it to close. The toast shows with `in` too. Empty states are centred by the kit (`.ap-empty` grows in the flex column of `.ap-content`).

### 6.6 Glass material and press glow

`.ap-glass` gives any floating piece the material (`.ap-round` or `.ap-card-r` for the shape). The glass pieces (`.ap-tb-pill`, `.ap-nb-btn.ap-glass`, `.ap-fab`, `.ap-glass`) can light up from the finger: on `pointerdown` set `--px` and `--py` to the pointer position inside the element and add `.ap-press` (the example's `press()` does it). Only `transform` and `opacity` animate.

### 6.7 Nova UI (Android)

Nothing to do: with `data-os="android"` the same classes draw the One UI 8.5 shapes (56 px bar with the title on the left, centred large title zone, cards with 26 px corners, pill buttons, full width floating bottom bar, dialogs with text buttons on the right). The accent is the Nova blue when the player kept the default.

## 7. Fonts

The kit uses Inter, the phone's font. The example ships the two Latin files in `html/fonts/` (SIL Open Font License, see `Inter-OFL.txt`) and the CSS points to `fonts/Inter-var-latin.woff2` first. If you do not copy them, the browser tries `nui://apex_phone/html/fonts/...` (the apex_phone manifest serves them) and falls back to the system font. Keep the copies: a font from another origin is not guaranteed to load in every CEF build.

## 8. Screen sizes

The phone is drawn at a logical size and scaled as a whole; your page always sees the same CSS pixels. Design for 440 x 956 with relative units and keep the safe areas free (the kit's `.ap-navbar` and `.ap-content` do it).

| Device | `wide = false` (default): what your page sees | `wide = true` |
|---|---|---|
| PearPhone 18, NOVA S26 (every normal phone) | 440 x 956 | 440 x 956 |
| NOVA Fold8 closed | 440 x 956, centred on the 670 px outer screen | 670 x 956 |
| NOVA Fold8 open | 440 x 956, centred on the inner screen | 1340 x 956 |
| PearPhone Fold closed (PearOS draws apps 1.45x larger on the outer screen) | 356 x 659 | 294 x 659 (the side rail is reserved) |
| PearPhone Fold open (apps drawn 1.25x larger) | 356 x 659 | 868 x 765 |

Status bar: 68 px on PearOS, 48 px on Nova UI (`--ap-safe-top`). Home indicator: 34 px / 20 px (`--ap-safe-bottom`). With `wide = true` listen to `ApexPhone.on('size', ...)` or your `window` `resize`.

## 9. Keyboard

Your page is another origin, so the phone cannot see your text fields. Two things happen:

1. Typing lock. While one of your fields has the focus the game must not receive the letters (T opens the chat, M closes the phone). The SDK sends `typing` automatically on focusin/focusout. If you draw your own editor call `ApexPhone.typing(true|false)` yourself.
2. The phone's own on screen keyboard. The phone cannot type into your field directly. `ApexPhone.keyboard.show(field)` asks for the keyboard; the phone types into a hidden proxy and sends every change to the SDK, which writes it into `field` and fires `input`. Enter fires `change` and a `keydown` with `key: 'Enter'`. While the keyboard is up the field (and its `.ap-li` / `.ap-field` wrapper) has the class `ap-kb-on`. `ApexPhone.keyboard.attach()` does this for every `input` and `textarea` of your page when they get the focus (the example does it); set `ApexPhone.config.autoKeyboard = true` before `init` to attach automatically. `ApexPhone.on('keyboard', fn)` gives you `{ shown, height }` so you can pad your content above the keys.

Limits: the caret is not shown inside your field while the phone keyboard types (the focus is in the phone's proxy); the kit draws the accent ring instead. Selection inside the field is not synced. The physical keyboard always works, with or without the phone keyboard. The phone keyboard is used in game, and in the browser when the player turned it on in Settings; when it is not available `show()` still works as a bridge for the physical keyboard.

## 10. Permissions and consent

1. `getContacts`, `getLocation`, `rpc('contacts.list')`, `rpc('photos.list')`, `rpc('messages.send')`, `rpc('bank.info')` ask the player the first time ("Allow", "Allow once", "Don't allow"). The answer is kept in Settings > Privacy and recorded on the server (`apex_phone_app_grants`). A refusal rejects with `denied`; a missing server record with `nogrant`.
2. `player.money` is only present after "Bank" was allowed.
3. `call`, `storage`, `notify`, `setBadge`, `sound`, `haptic`, `keyboard` and `PushToApp` do not ask: they only touch your own app and your own server.
4. The server never trusts the page: every RPC from an iframe carries the app id (`__ext`), and the SDK RPCs (`app.call`, `app.kv.*`) are refused without it.

## 11. Limits, rate limits and errors

| What | Limit |
|---|---|
| Requests from your page | the external app bucket: `Config.ExternalApps.rateLimit` (1 per second, burst 10, per app and player) plus the player's general bucket |
| `call` payload | 48 KB (page to server), 200 KB (handler result) |
| `PushToApp` data | 32 KB |
| Storage | `Config.ExternalApps.kv = { maxKeys = 200, maxBytes = 16000 }` per app and character (defaults when missing; `maxBytes` capped at 60 000) |
| Keys, names, ids | letters, digits, `_ - . :`, up to 64 |
| Badge | 0..9999 |
| Vera commands | 20 per app |
| Live activities | 8 at the same time on the whole phone |

Error codes (`e.code` of a rejected promise):

| Code | Meaning |
|---|---|
| `nohandler` | No `RegisterAppRPC` for that name (server side not running, or `apex_phone` restarted and you did not register again). |
| `internal` | Your handler threw a Lua error (see the server console) or returned something that is not JSON. |
| `invalid` | Bad name, bad payload, value not JSON. |
| `toolarge` | Payload or stored value over the limit. |
| `limit` | Too many storage keys. |
| `key` | Storage key with invalid characters. |
| `ratelimit` | Too many requests; wait a moment. |
| `forbidden` | RPC not allowed to external apps. |
| `denied` / `nogrant` | The player refused, or the server has no record of the consent. |
| `noplayer` | The player has no character loaded. |
| `timeout` | No answer in 12 seconds. |
| `nophone` | The page is not inside the phone. |
| anything else | The `error` field your own handler returned. |

## 12. Performance inside the game (CEF)

1. No `backdrop-filter`: in game it paints an opaque black box. The kit's glass is a material.
2. Animate only `transform` and `opacity`. Never `box-shadow`, `width`, `filter` or `background-position` in keyframes or transitions on moving elements.
3. No `color-mix()`, no `calc()` inside `rgba()`, no `clip-path`, no `:has()`, no `aspect-ratio`, no `<select>` or `<input type="color">` (draw your own), no `color-scheme: dark`.
4. Build the DOM once and update text and classes in place (the example's `render()` diffs rows by id). Re-creating a list on every change flashes and costs frames.
5. One `requestAnimationFrame` loop at most, stopped on `pause`.
6. Keep images small: the whole page is composited over the game every frame.
7. Fonts: ship them in your resource (section 7). Never load CSS or scripts from the internet in the `<head>`: the CEF may have no route and the page blocks.

## 13. FAQ

1. The icon appears but the page is blank. Check `files { ... }` in your `fxmanifest.lua` (every file, including `apexphone-sdk.js` and the fonts) and the `url` in `RegisterApp`. Open F8 in game: a 404 is printed there.
2. `call` rejects with `nohandler`. Your `RegisterAppRPC` ran before `apex_phone` started, or `apex_phone` restarted. Register in `onResourceStart` of `apex_phone` as the example does.
3. `RegisterAppRPC` returns `false` with "belongs to resource". The app was registered by another resource; register handlers from the same one.
4. The player sees the app but another player does not. `job` / `jobs` in `RegisterApp` filter the icon by job (the registry does it on the server since 1.5.0).
5. Can I persist rides, items, anything global? Use your own tables in `server.lua`; `storage` is per character and meant for preferences and small state.
6. How do I test outside the game? Open `apex_phone/html/index.html` in a browser with `--allow-file-access-from-files`, then in the console `ThirdParty.mockRPC('myapp', 'list', d => ({ items: [] }))` and `ThirdParty.register({ id: 'myapp', name: 'My App', url: 'file:///.../html/index.html' })`. The harness in the dev folder (`harness/scenes_sdk.mjs`) shows the full recipe.
7. Does the old `postMessage` protocol still work? Yes, unchanged. The SDK is a wrapper plus the new messages (`appcall`, `kv`, `setBadge`, `sound`, `haptic`, `keyboard`, `openURL`, `ready`).
8. Where do notifications go when the app is closed? Use the server export `SendNotification(target, { app = APP, title, msg })`: it is stored and shown even to offline players when they come back. `PushToApp` only reaches an open page.
