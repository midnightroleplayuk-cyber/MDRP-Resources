# vinewood-interviews

Police interview recording for FiveM. Officers start and stop a recording at a button in the room and choose **Audio only** or **Audio and CCTV**. Everyone inside the recording area has their voice captured to Fivemanage, and with CCTV replay the room is rebuilt in-game from a ceiling camera for playback in the evidence viewer. Rooms also get seats players can target to sit on.

## Requirements

- `ox_lib`, `oxmysql`
- A target script: `ox_target`, `qb-target` or `qtarget` (detected automatically). Without one, players press E at the button, monitor and seats instead
- Qbox, QBCore, ESX, or standalone (ACE permissions)
- A Fivemanage media API key
- OneSync
- Optional: [`screencapture`](https://github.com/itschip/screencapture) for real CCTV footage from the officer seat (its video capture is marked experimental by its author)
- Optional: `illenium-appearance` or `fivem-appearance`, so replay faces and hair match the players

## Files you can edit

This resource is protected by Cfx Asset Escrow. The core is encrypted, but these files are open:

| File | What it's for |
|---|---|
| `config.lua` | Every setting and all player-facing text |
| `bridge/client.lua`, `bridge/server.lua` | Framework support (Qbox, QBCore, ESX, standalone). Adapt these for a custom framework or job system |
| `bridge/target.lua` | Target support (ox_target, qb-target, qtarget, press-E fallback). Add another target script here |
| `editable/client.lua` | Swap the notification system |
| `editable/server.lua` | Server notifications, plus `OnInterviewStarted` and `OnInterviewEnded` hooks for logging or other scripts |
| `web/` | The NUI (HTML, CSS, JS) |
| `sql/install.sql` | Optional; tables are created automatically |

Keep your copies of `config.lua` and `editable/` when updating.

Requires FiveM server build 5181 or newer, and the server's license key must belong to the Cfx account that bought the script.

## Install

1. Drop `vinewood-interviews` into your resources. Tables are created on first start (`sql/install.sql` if you prefer to run it yourself).
2. `server.cfg`:

```cfg
set FIVEMANAGE_MEDIA_API_KEY "your-media-api-key"

ensure ox_lib
ensure ox_target   # or qb-target / qtarget
ensure oxmysql
ensure screencapture
ensure vinewood-interviews

# Admins: room setup and deleting recordings only.
# Starting, ending and viewing interviews always needs a police/review job, admins included.
add_ace group.admin vinewood.interviews.admin allow

# Standalone servers only - who counts as police / reviewer
# add_ace group.police vinewood.interviews.police allow
# add_ace group.police vinewood.interviews.review allow
```

If you already run `fmsdk`, it uses the same `FIVEMANAGE_MEDIA_API_KEY` convar.

If you can't edit `server.cfg`, paste the key into `Config.Upload.ApiKey` and the webhook into `Config.Discord.Webhook` instead. `server.cfg` is safer, because config files tend to get shared.

Run `vwi_checkkey` in the server console to see where the key was found and whether Fivemanage accepts it. The `set` line must be above `ensure vinewood-interviews`, in the `server.cfg` txAdmin actually runs, and changes need a full server restart.

## Setting up a room

Run `/interviewadmin`, create a room, then:

1. **Set recorder button** - aim at the wall panel and press E.
2. **Set recording area** - aim at the middle of the floor, scroll to size the sphere, arrow keys to raise/lower. Anyone inside is recorded.
3. **Set camera** - fly the camera into a ceiling corner (mouse, WASD, Space/Ctrl, Shift, scroll to widen). Enter saves. A field of view around 60-80 looks like real CCTV. **Preview camera** shows the exact shot. Without a camera, the room can only record audio.
4. **Seats** - stand at a chair, facing the way people should sit, and choose **Add seat**. Your character sits straight away using exactly the same sit players get. Slide it into place with WASD (relative to the camera), raise or lower with the up/down arrows, rotate with scroll, and hold Shift for fine adjustments. E saves and puts you back where you were. Each seat can be adjusted or removed later. If the game's chair sit won't play at a spot, a seated animation is used instead (`Config.Seats.FallbackDict`), for the preview and for players.

The key help for every setup tool is drawn by this resource's own NUI (left side of the screen), so other scripts clearing their prompts cannot hide it.
5. **Set observation monitor** (optional) - a second point to end and review interviews from.

Rooms cannot be edited while an interview is being recorded in them.

## Using it

- At the button, **Start interview recording** opens the start dialog: pick Audio and CCTV replay or Audio only, then optionally add a case reference, interviewee, officers present, solicitor and notes. Officers present is pre-filled with every on-duty officer (by job, from `Config.PoliceJobs`) standing in the recording area, so admins and civilians aren't included; remove names or add others by typing them in. Leave solicitor blank if none is present. If the room has no ceiling camera, only audio can be chosen.
- **End interview recording** opens a confirmation showing how long it has been recording.
- Both dialogs are NUI (`web/`), styled to match the evidence viewer. All their text is in `Config.Text`.
- Everyone in the area sees a recording indicator with the elapsed time, the recording type, and whether their mic is being captured.
- Players target a seat and choose **Sit down**, then press X to stand. A seat can only hold one person, and standing up by any other means (being cuffed, ragdolling) frees it automatically.
- Recordings can be ended from the button or monitor. Sessions also end after `Config.MaxDurationMinutes`, or once the area has been empty for `Config.AutoStopEmptySeconds`.
- `/interviews` (or **Review recorded interviews**) opens the evidence viewer. Each recording shows the officers present, the solicitor, and whether it has a CCTV replay. Search covers case reference, interviewee, officers, solicitor and room. Space plays/pauses, arrow keys skip 5 seconds, each speaker can be muted, and missing audio shows as hatched blocks with the reason.
- `/interviewmictest` records 4 seconds and plays it back.

## Vinewood MDT link

If `vinewood-mdt` (2.7.1 or later) is running, the Interviewee field in the start dialog searches the MDT as you type. Picking someone links the interview to their record and lists their custody records and incidents; picking one fills in the case reference. The interview then shows on that person and case in the MDT however the name was spelled. Without the MDT, or if you just type a name and don't pick anyone, it works as before.

Start `vinewood-interviews` before `vinewood-mdt` in `server.cfg`. Turn the link off with `Config.MDT.Enabled = false`.

## Officer seat CCTV (real footage)

In **Seats**, open a seat and turn on **Officer seat** (one per room). When an interview is recording **Audio and CCTV** and a police officer sits in that seat, their screen switches to the ceiling camera and it is recorded as real footage through screencapture. Their character stays in the chair, so voice works as normal. X stands them up and returns their view; the footage stops and restarts automatically if another officer sits down. If the officer is already seated when the recording starts, footage starts straight away.

Footage appears as its own lane in the evidence viewer and plays in sync with the audio, and is linked in the Discord post. Periods with nobody in the officer seat are covered by the CCTV replay.

## Discord evidence log

Add a webhook for a police-only channel to `server.cfg`:

```cfg
set vwi_discord_webhook "https://discord.com/api/webhooks/..."
```

When an interview ends, the server waits for every speaker's audio to finish uploading, then posts the case reference, interviewee, solicitor, officers present, room, start time, length, notes, and a link to each audio file, grouped by speaker and labelled with the time it starts in the interview. Missing audio is listed with the reason. Interviews with a CCTV replay include the recording number to watch it in game.

- Recordings shorter than `Config.Discord.MinSeconds` are not posted.
- `Config.Discord.MentionRoleId` pings a role (e.g. CID) on each post.
- **Send to Discord** in the evidence viewer re-posts a recording, for example if the webhook was down.
- The webhook URL is read from a convar so it never ends up in shared config files.
- Anyone with an audio link can play it, so keep the channel private. The links last as long as the files do on Fivemanage, so check your plan's retention.

## CCTV replay

When an interview is recorded with CCTV replay, each player in the area reports their position, heading, movement, talking state and any recognised animation four times a second (only when something changes, so a quiet interview produces very little data). Their clothing, and face if an appearance resource is running, is captured once when they enter.

**Watch CCTV replay** in the viewer hides the viewer and shows the room from the ceiling camera, with copies of everyone who was there moving, sitting and animating as they did, and the audio in sync. Players really in the room when you watch are hidden. The on-screen label makes clear it is a reconstruction, not real footage.

Anyone sitting in one of the room's seats is recorded as that exact seat, and replayed sitting in it the same way players sit (chair sit, or the fallback animation where that won't play), so seated positions match exactly. `Config.Replay.SeatAnim` and `SeatZOffset` only apply to sitting outside the room's seats. Add the animations your cuff and emote scripts use to `Config.Replay.Anims` (and any other sit scenarios to `Config.Replay.Scenarios`) so they reproduce too. Anything not listed shows as standing idle.

## Playback

Each audio file is downloaded and decoded before it plays, so you can jump to any point and every speaker stays in sync. While a file is downloading the clock holds and shows "Loading audio", so nothing is skipped. Playing faster than 1x raises the pitch slightly.

## How audio works

FiveM does not expose Mumble voice or game audio to scripts, so each player in the area records their own microphone through NUI. By default capture is gated to in-game voice (`Config.Audio.Gate = 'voice'`): while they are not transmitting, silence is written, so nothing said out of game is kept and every track stays aligned. If your voice script doesn't report talking to the game, use `'level'` (records whenever the mic hears speech) or `'off'` (records the whole time they are in the area).

Each uploaded track is labelled with how long the player talked and the loudest level captured, and tracks that recorded nothing are flagged as silent in the viewer and on Discord, with the likely reason. Audio uploads in chunks straight from the client with one-time Fivemanage presigned URLs, so the API key never leaves the server.

## Test on your server first

- `/interviewmictest` - hold push-to-talk and speak. It reports which mic the game is using, the level it hears, and whether in-game talking was detected, then tells you what to fix:
  - mic silent: the game's browser gets no sound. The mic must be the Windows default recording device, with app mic access allowed.
  - mic works but no in-game talking detected: your voice script doesn't report talking to the game. Set `Config.Audio.Gate = 'level'`.
  - fails with `NotAllowedError`: that client blocks NUI microphone access.
- One interview with CCTV replay - check the camera framing, that seated players line up with the chairs, and that your cuff animations reproduce.

## Notes

- Deleting a recording in the viewer removes it from the database only. Audio files stay on Fivemanage until removed there or by your retention policy.
- Players are recorded openly: the indicator shows to everyone inside the area while a session is active.
- All player-facing text is in `Config.Text` and `Config.Errors`.
