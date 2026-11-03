# Sky-Systems Base Resource

sky_base is the foundational library for all Sky-Systems scripts, designed to enhance performance, streamline configuration, and provide a unified framework for easier management.

## Configuration layout

- `framework/` contains the framework adapters.
- `integration/` contains provider adapters, grouped by feature (banking, billing, fuel, garage, helpnotify, housing, inventory, license, notification, phone, progress, tablet, target, vehiclekeys, voice).
- `locales/` contains translations; general settings and helper files remain directly in `config/`.
- When updating an existing installation, replace the resource folder so obsolete adapter paths are removed. Keep custom provider changes in the matching `config/integration/<feature>/` folder.

## Notifications and interaction help

`Config.notification` and `Config.helpnotify` both default to `"default"`, using Sky's built-in NUI. Adapters live in `integration/notification/` and `integration/helpnotify/`. Select a provider by its file name without `.lua`, or use `"auto"` for startup detection. HEX uses one `hex.lua` per group; select the exact HEX resource name listed in `config.lua`. The full provider list, priority order and source links are in [Notification integrations](../../docs/notification-integrations.md).

Both groups support the eight HEX HUD versions, ox_lib, Lation UI, ESX, QBCore, Qbox and Wasabi UIKit. Additional providers include CodeM Supreme/Venice, Quasar, ATY UI v1/v2, 17mov, Risk, MSK, Core Notify, CP Notify (`cp_notify`), RTX, VMS, Brutal, FRKN UIKit, RxNotify, CodeStudio, Prism, okok and Mythic. Each provider is available only for the features listed in the integration documentation. Help includes JG TextUI and esx_textui. Existing Sky/Zenit adapters remain available.

- ox_lib uses direct exports for notifications and TextUI; no `init.lua` or `imports.lua` entry is needed.
- Persistent TextUIs use `Sky.Show.RegisterToggle`, update only when their text/key changes and hide when calls stop. HEX uses its documented per-frame `HelpNotify` export, including v1.
- Implement the `custom.lua` template in each folder before selecting `"custom"`. Custom adapters are never selected automatically.
- Start external providers before sky_base when using `auto`; select providers that depend on sky_base explicitly. Restart sky_base after changing the selection. If no supported resource is started, `auto` uses `default`.

Multi-action instructional help remains in `functions.lua`. Only normal TextUI is integrated; world/3D interactions are excluded. CodeM mNotification uses its documented event as an explicit exception. mTextUI uses the provided OpenTextUI/CloseTextUI exports with an editable theme in its adapter. Codesign's event-only APIs are not selectable under the export requirement. See the provider documentation for details.

## Progress bars

`Config.progressbar` supports the additional export-based adapters `codem-supreme-hud`, `aty_uikitv2`, `17mov_Hud`, `risk-notify`, `prism_uipack`, `frkn-uikit` and `msk_core`, including startup autodetection. Their callbacks use Sky's existing `cancelled` convention. MSK also provides bar/circle selection.

Supported options and programmatic cancellation vary by provider; ATY v2 and FRKN do not document a cancellation export. See [Progress integrations](../../docs/progress-integrations.md) before switching an existing installation.

## Vehicle keys

For `tgiann-hotwire`, set `Config.vehiclekeys = "tgiann"` or keep `"auto"` and start `tgiann-hotwire` before `sky_base`. Restart `sky_base` and its dependent Sky resources after changing the selection. The adapter uses the existing client grant path, trims the plate and checks for an existing key before giving one. Existing keys remain valid.

Tgiann intentionally provides no key-removal export: physical keys remain in the player's inventory or ignition. Sky's removal hook therefore returns `false` without removing a key. See the [Tgiann export documentation](https://tgiann.gitbook.io/tgiann/scripts/tgiann-hotwire/exports). Provider selection remains plaintext-only because it selects adapters at resource startup.

## Documentation Links

- [Introduction](https://docs.sky-systems.net/docs/base/introduction)
- [Installation Docs](https://docs.sky-systems.net/docs/installation)

## Support

If you need any assistance or have further questions, join our Discord community for support:

[Sky-Systems Discord](https://discord.gg/sky-systems)

Thank you for choosing Sky-Systems!
