# Target actions and configurable commands — 2.0

## Default ox_target interaction

Start ox_target before APEX_Tape. With the target eye active, aim at a ribbon to see **Lift tape for access**, **Lower tape** (when open and permitted), **Remove tape**, and **Repair torn tape** (on an eligible broken span). Lift uses the same animated raise/hold/lower interaction as /tapeaccess; Backspace or the lower action releases it early. The selected span ID is used, so an adjacent ribbon cannot accidentally be chosen by a nearest-tape command.

No placement command or equipped tape item is needed to see these actions. Defaults allow authorised users to lift nearby tape. Removal requires the owner or an eligible admin. When permission or department restrictions are enabled, the actor must pass the configured server use permissions. Access also respects Access.AllowAllAuthorized and Access.Ace. Another player's held grip may only be lowered by its holder or an eligible nearby admin. Target removal defaults to owner/admin. RemovePolicy='authorized' permits removal by other authorised users. Removal still checks the optional cutting item and consumes it according to Inventory settings. A non-owner does not receive the owner's tape refund.

```lua
UserConfig={Version=2,Settings={
    Target={Enabled=true,System='ox',Resource='ox_target',
        Access=true,Remove=true,Repair=true,RemovePolicy='owner',
        Distance=2.0,StreamDistance=35,MaxZones=96,MaxTapes=32,
        SegmentLength=4.0,RefreshMs=500,PermissionRefreshMs=3000,
        Labels={Lift='Lift tape for access',Lower='Lower tape',Remove='Remove tape',Repair='Repair torn tape'}},
    Permissions={Framework='qb',Mode='jobs_or_staff',Jobs={police=0},RequireOnDuty=false},
}}
```

Omit the Permissions override for the default public policy. ESX, standalone ACE and custom framework modes use the same server permission bridge; ox_target groups are not used as the authority. Item requirements are checked on selection rather than depending on target-library inventory bridges. The eye's permission snapshot refreshes periodically; every action is checked again on the server for current permission, bucket, proximity and item costs. Commands remain usable if ox_target is missing/stopped, or Target.Enabled=false.

Long ribbons use segmented box zones that stream nearby, update as tied endpoints/raised tape/contact bows move, and clean up when the tape or resource disappears. MaxZones and MaxTapes bound local target work. With many overlapping spans, only the nearest zones within those budgets are registered. Distance is further limited by EditReach, and an interactive lift requires HoldReach. The default does not show debug boxes or zone sprites; enable Target.Debug/DrawSprite for setup. Target.AnchorOptions enables additional owner-only interactions on anchor objects and vehicles; it is off by default.

Target removal policy applies to target actions. The existing /removetape and owner cleanup commands retain their owner/admin rules. The menu layout is unchanged.

Repair follows the normal editable-span ownership/staff/department policy, not RemovePolicy. The actor must be nearby, on foot, and pass the current server use gate; reconnect timing, revision, cooldown, expiry and optional Inventory.RepairItem are checked on completion. The action follows the fallen geometry and restores the exact selected span. Target.Repair=false disables target repair, independently of the repair command. Nine possible actions are supplied to custom adapters, with visibility predicates selecting the applicable ones.

## Custom target adapter

Set Target.System='custom', set Target.Resource to your target resource name, and implement client/custom_target.lua. Retain this buyer-owned file when replacing resource files. No other target API is assumed to match ox_target automatically.

```lua
TapeTargetHooks={
    Ready=function()return GetResourceState('my_target')=='started'end,
    AddZone=function(zone)
        -- Convert zone.coords/size/rotation and zone.options to your library's API.
        -- Preserve each option's canInteract and onSelect callback.
        return exports['my_target']:AddTapeZone(zone)
    end,
    RemoveZone=function(handle)
        exports['my_target']:RemoveTapeZone(handle)
    end,
}
```

These export names are placeholders to replace with your library's actual API. AddZone must return a removable handle; RemoveZone must remove it. Ready returns true only when the adapter can register zones. Call the supplied canInteract callback for visibility and onSelect for selection; it already starts the selected action in a thread. The exported client function `exports['APEX_Tape']:TargetTape('lift', id)` also accepts lower/remove/repair/pickup/reconnect/drop/pass/inspect and uses the cached visibility gates plus the same server validation. Never turn target callbacks into trusted server PlaceTape/RemoveTape exports.

## Rename every slash command

Use stable identifiers on the left and your command names on the right, without `/`. Unspecified entries keep their defaults. Restart APEX_Tape after edits. Names must be unique (case-insensitive), 1–40 letters/numbers/underscores/hyphens, without spaces or slashes. Subcommands such as new/use/list remain unchanged.

```lua
UserConfig={Version=2,Settings={Commands={
    ptape='tape',
    changetape='tapedesign',
    tapeaccess='lifttape',
    tapeclose='lowertape',
    removetape='cutcordon',
    cleartapes='clearcordons',
}}}
```

The configured names are used for registrations, internal command shortcuts, controller dispatch, FiveM key mappings, chat suggestions and slash-command references in player hints/menu text. Existing saved key bindings may need rebinding after a rename. Old names are not automatically retained as aliases. Network event names and integration export names remain stable. Static documentation below uses default names; apply your mapping when following it.

| Stable identifier / default | Purpose |
| --- | --- |
| ptape | Toggle placement; remove/undo subcommands |
| changetape | Select design |
| removealltape | Remove your tape |
| removetape | Remove nearest owned/admin-editable span |
| restyletape | Restyle nearby span |
| tapeaccess | Lift/toggle temporary access |
| tapeclose | Lower/close access |
| tapeadmin | Admin scene panel |
| tapescenes | Scene panel |
| tapescene | Scene commands |
| tapechain | Toggle chained placement |
| tapemode | Aim/anchor placement mode |
| tapeundo | Undo latest owned span |
| tapeheight | Ground attachment height |
| tapesnap | Toggle endpoint snapping |
| tapegrid | Placement grid |
| tapeperimeter | Perimeter preset |
| tapemove | Move endpoint |
| tapegroup | Assign span to active scene |
| tapecut | Removal alias |
| taperepair | Repair torn span |
| taperefund | Claim pending item refund |
| tapedetour | Scene traffic waypoints |
| tapetemplate | Save/place layouts |
| tapepad | Controller placement shortcut alias |
| tapediag | Diagnostic report |
| tapereset | Reset selection/APEX panels |
| cleartapes | Admin/console clear |
| tapehandover | Transfer selected scene to a player or department |
| taperecover | Recover latest cleared/deleted scene within its window |
| tapefavourite | Save/load/list/delete personal placement presets |
| tapecomfort | Target tolerance, prompt size and hold/toggle preference |
| tapetension | Tension/slack choice for new tape |
| tapetrafficpreview | Toggle local traffic preview arrows |
| tapelevel | Toggle level chains / independent surface heights |
| tapeadjust | Tighten/slacken or slide existing endpoints |
| pickuptape | Carry the nearby torn tip |
| reconnecttape | Aim at a new attachment and reuse the carried end |
| droptape | Release the carried end |
| tapepass | Controlled duck/step past the nearby ribbon |
| tapeinspect | Inspect tape and scene details |


API reference: [ox_target client zone exports](https://overextended.dev/docs/ox_target/Functions/Client), [target option callbacks](https://overextended.dev/docs/ox_target/TargetOptions).

## Target the ribbon anywhere along its length

The ox backend also registers the applicable camera-aim actions for the drawn ribbon. This covers the middle and both faces without needing a collision prop or a physical ray hit on an endpoint. Aim uses the sagged/contact-bowed/raised path; the default tolerance is `Target.AimRadius=0.4` metres, with `Target.AimDistance=12` metres from the camera. Player action reach is still limited by Target.Distance/EditReach and Access.HoldReach, and the server rechecks permissions, range and the chosen span. The closest eligible span along the camera ray wins. Zone options are suppressed when the camera-aim options already cover the same span, avoiding duplicate entries. Existing zones remain as a fallback and for custom adapters. Temporary wind animation is covered by the aim tolerance, rather than sampled exactly. Backend/resource stop removes both zone and camera-aim registrations.

`/tapeeditor on|off|auto|status` controls your request for shared physical recording objects. Rename it with Commands.tapeeditor. See [recording.md](recording.md).

`/tapetext [wording]`, `/tapetext apply [wording]`, `/tapetext clear` and `/tapetext off` manage optional custom wording. Omitting wording opens the native keyboard. Rename through Commands.tapetext.

## Additional scene actions

Target options also include pickup, reconnect, drop, pass and inspect when eligible. The custom adapter must preserve their callbacks and visibility checks. See [gameplay.md](gameplay.md) for all seven additions and their independent config switches.
