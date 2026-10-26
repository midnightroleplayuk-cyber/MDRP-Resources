# Gameplay and scenes

Configure these features through config.lua and restart the resource. All commands below use their default names.

## Save and reuse scene templates

1. Select a scene with `/tapescene use ID` or create one, then build its cordon.
2. Stand facing the direction you want to treat as the layout's forward direction.
3. Run `/tapetemplate save NAME`.
4. List saved layouts with `/tapetemplate list`.
5. Run `/tapetemplate place ID`, aim at the new ground location, adjust rotation/height, then confirm.
6. Delete a layout with `/tapetemplate delete ID`.

Saving the same name again replaces your own template of that name. Templates store intact span geometry, designs and post flags relative to the layout center and capture heading. They do not retain network entity bindings, opened gaps, torn state or world-space detour routes. On placement, endpoints become portable static world anchors. Relative endpoint heights are retained; the base placement height comes from the ground preview. Uneven terrain may need endpoint edits afterwards.

A selected active scene receives the copied spans. With no active scene (`/tapescene use none`), a new scene is created automatically. A quota, style, inventory or distance failure rolls back the entire batch, including any newly created empty scene. Normal tape and scene limits still apply. The template's own saved designs must be allowed for the placing user's current department.

Templates are private to the owner/admin by default and are saved in data/tapes.json. Config.Templates.Shared=true allows other authorised users to place them, while deletion remains owner/admin only. Defaults: 15 layouts per owner, 100 total, 40 spans per layout and a 35 m capture radius.

## Vehicle attachment safety

```lua
UserConfig={Version=2,Settings={
    Attachments={Enabled=true,CheckMs=200,MissingGraceMs=1500,
        MaxAnchorTravel=8.0,MaxVehicleSpeedKmh=25.0,OnUnsafe='freeze'},
}}
```

The server tracks attachment entity/model, bucket and current transform. Despawned/unavailable anchors get a short grace interval; excessive travel or vehicle speed acts immediately on the next check. OnUnsafe='freeze' detaches at the last safe world position. OnUnsafe='tear' detaches and tears the span. This prevents a departing vehicle from dragging an unlimited ribbon across the map. Speed safety applies to vehicle anchors; travel/missing-entity checks also protect other networked anchors.

Network entity handles and models are checked to reduce reuse mistakes. They do not provide a universal identity guarantee for heavily customised entity managers. Normal session tracking follows heading; extreme vehicle pitch/roll or moving mirror bones can differ from the server transform approximation. Restarted vehicle attachments remain static world anchors, as documented in the buyer guide.

## Realistic deployment

New placement, perimeter and template operations use a default 1.8-second deployment. Repair also uses it; endpoint movement can opt in. Existing prompts display progress. Moving beyond the configured distance, death, entering a vehicle, pause/NUI focus, cancellation or putting tape away cancels the action. Props and the animation clean up afterwards and on resource stop.

```lua
UserConfig={Version=2,Settings={
    Deployment={Enabled=true,DurationMs=1800,TicketLifetimeMs=30000,
        MaxMovement=2.0,ApplyToRepair=true,ApplyToMove=false,
        AnimDict='mini@repair',AnimName='fixing_a_ped',
        PropModel='prop_gaffer_tape',NetworkedProp=false},
}}
```

The built-in hand prop is a generic gaffer-tape roll, not a custom branded police-tape spool. Change its model, hand bone, offsets and rotation in Config.Deployment. Empty PropModel disables the hand prop. Asset loading has timeouts; missing visual assets do not bypass the server's minimum deployment time. NetworkedProp=false keeps the object local; enable it if observers should see the prop and your entity policy allows client-created network props. Strict entity lockdown may require keeping it local.

The server issues a ticket bound to the actor and operation, checks elapsed time, current on-foot state and distance from the starting point, and consumes it after a successful commit. Cancelled, expired, early or replayed commits fail. Client animations remain visual; this is not a full anti-cheat system. Inventory is charged only when the operation commits successfully.

## Tape tension

Config.Tension controls span-dependent sag, slack, stretch threshold and break delay:

```lua
UserConfig={Version=2,Settings={
    Tension={Enabled=true,BreakEnabled=true,MaxStretch=1.18,
        BreakDelayMs=600,ReferenceSpan=8.0,SagAtReference=0.12,
        MaxSag=0.75,SlackMultiplier=2.0},
}}
```

Each intact span has a rest length. Lengthening moving endpoints reduces sag; sustained extension beyond MaxStretch tears it on the server. Moving an endpoint with the editing tool or repairing tape resets its rest length. Short spans are tighter and long spans sag more. Wind remains independently configurable. Disabling BreakEnabled retains visual sag/tension without strain tearing; normal vehicle-impact tearing still follows Config.Breakaway.Enabled. Disabling Tension.Enabled restores the original Ribbon sag settings.

This measures endpoint strain. It does not model tape wrapping around detailed pedestrian or vehicle bodywork, fabric dynamics or physical forces on vehicles. Attachment safety and tension are independent: an unsafe anchor may freeze before it accumulates enough strain to tear, depending on your thresholds.

## Traffic diversion

Automatic diversion attempts road-node paths around either end of a closed span. The controlling client only retasks ambient NPC vehicles it controls; player vehicles and mission entities are excluded. Routes are checked geometrically against nearby closed spans. If nodes are unavailable or no clear route is found, the original braking/stopping behaviour remains.

For map-specific routes, select the scene and stand at successive safe road locations:

```text
/tapedetour add
/tapedetour add
/tapedetour add
/tapedetour clear
```

These commands save player-position waypoints for that scene; place them on driveable roads. The client considers both waypoint orders for approaching traffic. Defaults allow eight waypoints within 250 m of the scene. Scene detours persist and are removed with the scene. Layout templates do not copy them, since they refer to specific world roads.

Config.Traffic includes Automatic, StartDistance, end/side clearance, node snapping tolerance, vehicle clearance, speed (m/s), driving flags, retry timeout, route timeout and a concurrent vehicle cap. Automatic=false retains explicit scene routes. Enabled=false disables detour attempts while preserving the existing closure traffic stops. Config.BlockAiTraffic defaults to true in 2.0; turning it off disables both systems. DiagonalOnly=true limits automatic bypass to angled spans relative to vehicle approach. DiagonalThreshold=.35 means roughly 20 degrees away from a square-on crossing. If no safe route is available, vehicles stop. Explicit scene detours remain usable regardless of angle.

Completed, cancelled and timed-out diversions restore ambient wandering when it is safe to issue AI tasks. Player takeover or ownership loss clears local tracking without issuing AI driving tasks to that vehicle. Stopped traffic is released when its closure clears. The resource cannot reconstruct every NPC's original mission or custom task stack; mission entities are excluded from retasking by default.

Road-node routing is best effort: geometric clearance does not prove the game's navigation route will follow the same line. Maps with isolated roads, bridges, narrow junctions, custom road nodes or missing bypass roads require manual routes and live testing. AI braking/stopping remains the fallback; physical collision barriers are not created. This is not a replacement for a full traffic-management resource.

## Controller controls

Default controller shortcuts (labels depend on your pad):

| Action | Default |
| --- | --- |
| Toggle tape placement | Hold LB / L1, press X / Square |
| Confirm point or tool preview | A / Cross |
| Cancel selection/tool/deployment | B / Circle |
| Adjust ground attachment height | D-pad up/down |
| Cycle designs in ordinary placement | D-pad left/right |
| Rotate preset/template preview | D-pad left/right |
| Toggle nearest access gap | Hold LB / L1, press Y / Triangle |
| Repair nearest torn tape while placement is off | Hold LB / L1, press B / Circle |

Keyboard controls are retained. `/tapepad` is another placement-toggle command, and the access/repair commands have optional FiveM bindings. Config.Controller exposes native control IDs, modifier buttons and displayed confirm/cancel labels. The original help prompt switches labels for controller input; no new UI panel is added. Controller input mappings vary with game settings and other resources, so verify and adjust them on your server.

Scene/template naming and management still use the existing chat commands or scene panel. Template placement and manipulation can then use the controller. This release does not add a controller-native text keyboard or redesign the mouse-based NUI menus.

## Traffic preview

While previewing a span or perimeter near moving NPC traffic, red arrows show a stop before the cordon and gold arrows show a validated route around an end. Preview and live routing share the route checker, including other intact spans. Work is bounded by PreviewVehicles, PreviewDistance and PreviewEveryMs. The preview is advisory: vehicles, network control and available road nodes may change before deployment. Mission-vehicle exclusions and engine driving behaviour still apply to actual traffic control.

Use `/tapetrafficpreview` to toggle your local arrows. A square-on road closure stops NPCs; angled tape permits a safe bypass attempt under Traffic.DiagonalOnly. No safe bypass means stop. Traffic preview requires BlockAiTraffic=true. Player vehicles continue to use contact/breakaway behaviour.

## Scene handover

Select a scene and use `/tapehandover PLAYER_ID`, or enter a player ID and choose Hand over in the scene panel. The recipient must be online, authorised and in the scene bucket, with room under scene/tape limits. Ownership of the scene and its tape transfers; the previous owner loses owner privileges. Admin authority remains independent.

`/tapehandover department police` shares the scene with a configured department. The panel accepts a department name in the same recipient field. The original owner remains custodian; matching authorised job members may manage/edit the scene and add tape. Only its owner/admin may change the handover again. Configure Polish.Departments and the framework job bridge. Department sharing needs a functioning job adapter (QB/ESX/custom); plain standalone mode has no job information. Handover is manual, including when planning for the original officer to leave; admins can handle abandoned scenes later.

Department sharing persists in scene data. The default per-span target removal policy is still separate from department sharing.

## Undo accidental scene cleanup

Clear tape and Delete scene capture one latest recovery snapshot per acting license for Polish.RecoverSeconds (30 seconds by default). Use Undo last clear in the panel or `/taperecover` before the window expires. Recovery restores the saved geometry after rechecking access, ownership changes, expiry, duplicate placement and tape limits. If paid spools were refunded during clearing, those returned items must be repaid before restoration. Failure rolls back staged spans and leaves the snapshot available until expiry. Successful recovery is single use.

Snapshots are bounded by MaxRecoverySpans/MaxRecoveries, stored in temporary server memory, and cleared by a resource restart. This is recovery for explicit scene clear/delete, not undo for every cut or administrative bulk wipe. Large scenes beyond the configured snapshot bound cannot use this window. Normal backups remain separate.

## Saved favourites and accessibility

| Default command | Purpose |
| --- | --- |
| `/tapefavourite save NAME` | Save selected design, height, slack/tension and current/last basic perimeter |
| `/tapefavourite load NAME` | Restore choices; a saved perimeter enters preview and still needs confirmation |
| `/tapefavourite list` | List local favourites |
| `/tapefavourite delete NAME` | Delete one favourite |
| `/tapetension tight` | Set slack ratio 0.98 for new spans |
| `/tapetension normal` | Set slack ratio 1.0 |
| `/tapetension loose` | Set slack ratio 1.06 |
| `/tapecomfort target 0.8` | Increase local ribbon aim tolerance in metres, bounded by MaxAimRadius |
| `/tapecomfort scale 1.5` | Increase placement/access prompt text size through a NUI overlay |
| `/tapecomfort lift hold` | Use hold/release lifting |
| `/tapecomfort lift toggle` | Use the timed toggle interaction |

Favourites and comfort choices use local resource KVP storage. They survive reconnects/resource restarts on that client installation. Names are limited to 32 characters and MaxFavourites defaults to 12. These are personal settings, not shared server scene templates. Select a scene before loading a perimeter favourite. Custom scene templates remain managed by the existing template tools. Saved tension is applied to newly created spans; it does not retroactively change existing tape. A numeric slack ratio from 0.98 to 1.08 is also accepted.

All 37 command names remain configurable in Commands. Subcommands and favourite names are arguments rather than separate command registrations.

## Contact, lifting and torn tape

Intact tape bows with walking and vehicle contact. Walking meets a configurable soft stop; fast perpendicular crossings can tear tape. Contact.Pedestrians.TearSpeed defaults to 3.2 m/s; Contact.Vehicles.TearSpeed defaults to 1.12 m/s. Breakaway profiles also govern vehicle tearing. Contact uses approximate shapes and server-observed motion; tune it for your vehicles and latency. Tape is a procedural ribbon with scripted contact and loose-tail motion.

BlockAiTraffic defaults to true. NPC vehicles stop at square-on tape and attempt safe routes around angled tape. Set it false to disable traffic control. This is not a solid vehicle barricade.

Stand within reach and run /tapeaccess [seconds] or use the target lift action. Backspace or /tapeclose lowers early. The default one-hand pose is configured through Access; HoldReach defaults to 2.0 m and HandHeight to 1.3 m above the ped origin. Death, vehicle entry, permission loss and unsafe movement end the hold. See [customization](customization.md) for pose settings.

Torn tips fall and settle towards the floor while outer ends remain attached. TornEnds controls gravity, settling and probe budgets. Floor approximation can differ on multilevel maps. Use /taperepair or the eligible target action to repair a span you may edit; optional repair-item costs apply. A span whose remnants have expired must be placed again.

## Scene tools

## Using the tools

| Feature | Default operation |
| --- | --- |
| Adjust placed tape | `/tapeadjust tight` or `/tapeadjust loose`; `/tapeadjust up a 1` moves endpoint A one 5 cm step. Use down/left/right/forward/back, endpoint a/b and 1–5 steps. Directions use world axes. Omit the endpoint to choose the nearest. Shared junctions use the existing validation. |
| Loose anchors | Strong vehicle, running or tension impacts release configured cone models. Solid walls and unlisted models stay attached. Nearby locally controlled cones can physically tip; network ownership is respected. |
| Reuse torn ends | Target a fallen tip and choose **Pick up loose end**, or `/pickuptape`. Walk it to a new anchor, aim at that anchor and select **Reconnect carried end** or `/reconnecttape`. Backspace/controller cancel, **Drop loose end**, or `/droptape` drops it. |
| Controlled passage | Choose **Duck / step past tape**, or `/tapepass`. The character crouches or hops according to tape height. The route must be clear; the short permission applies only to this player and this span. Cancel to stop. |
| Inspect | **Inspect tape / scene**, or `/tapeinspect`, reports placer name, scene, design, length, expiry, wear and torn state through the existing notification surface. |
| Weather wear | Storm/rain/snow rates gradually stretch tape and can tear severely worn spans. Clear weather has no base wear by default. |
| Placement feedback | Exact attachment markers and ready/rejection messages explain short spans, out-of-reach points and unsuitable surfaces. |

Every new command can be renamed under Config.Commands using the stable names in the table. Target adapters receive nine possible actions in total: lift, lower, remove, repair, pickup, reconnect, drop, pass and inspect. Visibility depends on the selected span, proximity and permission snapshot; the server validates again when selected.

Pickup/reconnection/adjustment require the existing owner, staff or shared-department editing authority. Inspection is public by default. Passage allows authorised users by default; `Passage.AllowAllAuthorized=false` limits it to editors. Existing use/job/staff checks still apply. Reconnection uses normal repair timing and optional repair-item costs. Ordinary lift and repair remain available.

A carried tail has only its original half-length plus the small configured allowance. Reconnecting consumes that half and leaves the other half available. Once both halves are reused, the original record disappears. Only one paid-spool entitlement transfers: reusing two ends cannot create two spool refunds. A partly consumed original cannot be restored with ordinary repair. Carrying ends automatically on death, vehicle entry, permission loss, excessive distance or timeout. Transient carry poses are not saved across restart.

## Configuration

Merge the desired entries into your existing UserConfig Settings table; do not create duplicate Lua keys.

```lua
UserConfig={Version=2,Settings={
    Adjustment={Enabled=true,Step=.05,MaxSteps=5},
    LooseEnds={Enabled=true,Reach=1.8,MaxWalk=12,MaxHoldSeconds=90},
    Passage={Enabled=true,AllowAllAuthorized=true,DurationMs=4000},
    Inspection={Enabled=true,Public=true},
    AnchorFailure={Enabled=true,VehicleSpeed=3.5,FootSpeed=7.5,PullRatio=1.06},
    WeatherWear={Enabled=true,Weather='auto',TearEnabled=true},
    PlacementFeedback={Enabled=true,ShowReason=true},
}}
```

Full defaults and model whitelist are in shared/defaults.lua. AnchorFailure only releases explicitly configured models; add exact custom cone model names to Models. Physical tipping is best effort for nearby controlled objects and does not take control of other resources' entities.

Weather auto mode reads a string from `GlobalState.weather` or `GlobalState.Weather`, falling back to CLEAR. If your weather resource uses a different schema, bridge it in the preserved server/custom.lua:

```lua
TapeEnhanceHooks=TapeEnhanceHooks or {}
function TapeEnhanceHooks.Weather()
    -- Replace with your weather resource's authoritative server state.
    return 'RAIN', 3.0
end
```

The second value is wind strength. WeatherWear.Rates are wear per minute; wind multiplies the rate. Defaults are slow (rain .002/minute, thunder .006/minute), with tearing at .98. TickMs, MaxPerTick and MaxStepSeconds bound processing; no client can submit weather wear. Set a fixed Weather value for servers without a weather bridge, or disable WeatherWear.

Passage uses normal character movement with a four-second maximum, without teleporting or disabling world collision. It does not open an NPC traffic gap. If another resource supplies a custom walk style, implement `TapeEnhanceHooks.RestoreMovement(ped)` in client/custom_target.lua to restore that style after crouching; otherwise the stock movement clipset is restored.

## Ambient pedestrians

## Behaviour

An approaching NPC treats a square-on span as a closure and moves to a waiting point. An angled span permits a route around a clear end. Like vehicle diversion, the angle is measured against the pedestrian's direction of travel, rather than compass north. Walking parallel or away is ignored. Routes are checked against nearby closed spans and GTA's safe pedestrian navigation points; failed, blocked or stalled routes fall back to stopping.

Stopped NPCs can watch impatiently, take photos with a camera, film on a phone, check their mobile, or ask a nearby player a question. Weighted selection, reaction probability, dwell time, cooldowns and caps keep every pedestrian from doing the same thing. The photo/filming behaviours are animations; they do not save screenshots or video files.

Questions appear as short text above the NPC, such as "What's happening here?" or "Is everyone alright?" An optional stock GTA speech line accompanies them. **GTA speech does not read the configured question text aloud**; availability and wording depend on the ped model. Custom recorded audio can be connected to the client event `apex_policetape:npcQuestionSpoken(ped, text, spanId)`. This event is local to the controlling client and does not send messages to external services.

After the configured dwell, NPCs attempt to leave on their original side and return to ambient walking. If no safe exit exists, they wait and retry. Opening, tearing or removing the span releases affected pedestrians when a clear onward path exists. Other closed cordons can still prevent that path. Temporary access is treated using the resource's existing open-span state.

Mission/job peds, players, animals, occupied vehicles, combat/fleeing/ragdoll peds and unrelated existing scenarios are excluded by default. Active unrelated script tasks are also excluded. Only the current network owner issues tasks. Ownership migration, another script taking over, scene changes, disabling the feature and resource shutdown have cleanup handling. Peds are not frozen or made invincible. No control requests or crowd spawning are used.

## Configuration

Put overrides inside your existing `UserConfig.Settings.NpcPedestrians` table in config.lua. These examples are alternatives; combine the desired fields into one table.

```lua
UserConfig = { Version=2, Settings={
    NpcPedestrians={
        Enabled=true,
        DivertAngled=true,
        ReactionsEnabled=true,
        ReactionChance=.85,
        MaxActive=24,
        MaxReactions=8,
        MaxPerScene=4,
        MinDwellMs=12000,
        MaxDwellMs=30000,
        CooldownMs=60000,
        Questions={Enabled=true,Bubbles=true,Voice=true,
            Lines={"What's happening here?","Can I get through?"}},
    },
} }
```

Use Enabled=false to switch the pedestrian system off. ReactionsEnabled=false retains stop/bypass handling without photo/phone/question reactions. Disable an individual reaction under Reactions, for example photo.Enabled=false. Questions.Enabled=false disables questions; Bubbles and Voice can be switched separately. The question pool replaces the default pool rather than appending to it.

```lua
UserConfig = { Version=2, Settings={
    NpcPedestrians={
        Reactions={
            watch={Enabled=true,Weight=35},
            photo={Enabled=true,Weight=20},
            film={Enabled=true,Weight=15},
            phone={Enabled=true,Weight=15},
            ask={Enabled=true,Weight=15},
        },
        Questions={Bubbles=true,Voice=false},
    },
} }
```

Each reaction has an editable Scenario field. Defaults use WORLD_HUMAN_STAND_IMPATIENT, WORLD_HUMAN_PAPARAZZI, WORLD_HUMAN_MOBILE_FILM_SHOCKING and WORLD_HUMAN_STAND_MOBILE; ask uses standing/look-at behaviour. A failed scenario falls back to waiting. For testing, set one reaction's Weight=1 and the others' Weight=0, with ReactionChance=1.

| Setting | Default / purpose |
|---|---|
| UpdateMs / MaxPedsPerTick | 250 ms / 32 rotated ambient-pool entries per update |
| ScanDistance / MaxTapes | 50 m / 48 nearby spans; managed spans are prioritised |
| MaxActive | 24 managed pedestrians per controlling client |
| MaxReactions / MaxPerScene | 8 concurrent reaction/wait phases, at most 4 per scene on that client |
| StartDistance / LookAhead | 7 m detection range / 3 seconds of approach prediction |
| StopDistance / Clearance | Wait 1.8 m from tape / reject paths closer than 0.45 m |
| DiagonalThreshold | 0.35; increase to require more diagonal approaches before bypassing |
| EndClearance / SideClearance | 2 m beyond an endpoint / 1.8 m on either side |
| OnlyPavement / NavFlags | true / 48; pavement paths, avoiding water |
| MaxSnapDistance / MaxRouteDistance | Reject safe-point snaps over 1 m or routes over 60 m |
| RouteTimeoutMs / ProgressTimeoutMs | 45 seconds total / 6 seconds without progress |
| StopApproachMs | Fall back to waiting in place after a 5 second failed approach |
| Questions.PlayerDistance / DrawDistance | Ask a player within 6 m / draw bubbles within 10 m |
| Questions.DisplayMs | 4.5 seconds per bubble |
| Questions.GlobalCooldownMs / PedCooldownMs | At most one relayed question per routing bucket every 5 seconds; 60 seconds per NPC |

On custom plazas/maps without pavement flags, OnlyPavement=false and NavFlags=32 allow other dry pedestrian navigation surfaces. Navmesh availability and scenario suitability still depend on the map and ped model. Respect the active/scan limits when testing: this is a bounded ambient system, not an invisible collision wall for every NPC in the world. Multiplayer caps apply per controlling client; network ownership prevents multiple clients retasking the same ped. Question relays enforce server ownership, entity type, player exclusion, tape proximity, routing bucket and cooldown checks.
