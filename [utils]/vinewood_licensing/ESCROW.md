# Escrow build notes (Vinewood Licensing)

## Uploading

1. Zip the `vinewood_licensing` folder (folder included, not just its contents).
2. Go to https://portal.cfx.re/assets -> Create new asset -> upload the zip.
3. Wait for processing. Most assets encrypt in under two hours.
4. Attach the asset to your Tebex package.

`lua54 'yes'` is already set in the manifest, which Cfx requires for escrowed
assets. The 1GB upload limit is not a concern here.

## What buyers can still edit

Everything in `escrow_ignore`. Everything else is encrypted.

| File | Why it's open |
|---|---|
| `shared/config.lua` | all settings, theory questions, test routes, locations, fees, penalties |
| `server/config.lua` | their Fivemanage API key and update-check URL |
| `locales/*.json` | translations |
| `web/css/config.css` | UI colours |
| `EXPORTS.md`, `MIGRATION.md`, `INSTALL-...txt` | documentation |

Worth checking before each release: anything a buyer legitimately needs to change
must live in one of these. A support ticket asking "how do I move the desk" that
ends with "you can't, it's encrypted" is a refund.

## Things to know

- **Protection covers the Lua and the NUI.** `web/js/app.js` is encrypted along
  with everything else, since it isn't in `escrow_ignore`.
- **Test the escrowed build, not your local copy.** Download it back from Keymaster
  and run it on a test server. Escrow has broken resources before when a file was
  read at runtime that turned out to be encrypted.
- **GTAV Enhanced.** Asset escrow is not supported there yet, so say so on the
  Tebex page if your buyers ask.
- **Transfers.** Escrowed assets can't be moved between Cfx accounts, so upload
  from the account you intend to sell under.
- **Buyer file transfers.** Tell buyers to use WinSCP rather than FileZilla;
  FileZilla corrupts escrow files and produces "Failed to verify protected
  resource".

## Version checker

`server/version.lua` prints a console notice when a newer version exists. Point
`Config.VersionCheck.Url` in `server/config.lua` at a plain text file containing
just the version number, e.g. `2.0.0`. Leave it empty and the check never runs.

Bump `version` in `fxmanifest.lua` with every Keymaster release so the comparison
means something.
