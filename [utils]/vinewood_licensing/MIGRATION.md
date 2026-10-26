# Migrating from `citydriving` to `vinewood_licensing`

Existing licences are kept. Nothing is wiped and no one has to retake a test.

## What carries over on its own

| Thing | Carries over | Why |
|---|---|---|
| Licence categories passed | Yes | stored on the character (`metadata.licences`), untouched by the rename |
| Physical licence + provisional items | Yes | item names are unchanged (`driving_licence`, `provisional_licence`) |
| Licence number, dates, photo on the item | Yes | item metadata is untouched |
| Penalty points and bans | Yes | stored on the character |
| Queued offline actions | Yes | copied out of `citydriving_pending` on first start |

## Three steps

1. **Stop and delete the old resource.** Change `ensure citydriving` to
   `ensure vinewood_licensing` in `server.cfg` and remove the old folder. If both
   are running you get duplicate desks and double menus — the console warns you.

2. **Update the item export** in `ox_inventory/data/items.lua`, for both items:

   ```lua
   export = 'vinewood_licensing.useLicence'
   ```

   The console prints a warning naming any item still pointing at the old export.

3. **Restart.** On first start the script migrates the pending-actions table. The
   old table is renamed to `citydriving_pending_migrated` rather than dropped, so
   nothing is lost if something goes wrong. Delete it once you're happy.

## Older MDTs

`Config.Legacy.MirrorEvents` (on by default) also fires
`citydriving:server:licenceUpdated` alongside the new event, so an MDT that hasn't
been updated keeps receiving updates. Export calls (`exports.citydriving:...`) must
be renamed — a resource cannot provide exports under another resource's name.

Turn mirroring off once everything is switched over.

## Licences issued before v2

Before v2 the photo and provisional entitlement existed only on the item, so losing
the item lost the record. Each character is repaired automatically when they next
log in: their photo and entitlement are read back off the item they carry and saved
to their character, which makes replacements and photo updates work for them.

To repair everyone currently online without waiting, run `dvlamigrate` from the
server console. In-game it needs the `command.dvlamigrate` ace permission.

Anyone whose provisional was already lost before the upgrade has nothing to read
back and will need a fresh application.
