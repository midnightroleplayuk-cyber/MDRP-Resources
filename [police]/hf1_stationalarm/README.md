# hf1_stationalarm

QBox/QBX police emergency alarm using ox_target, ox_lib notifications and looping positional NUI OGG audio.

## Install
1. Place `hf1_stationalarm` in your server's resources directory.
2. Add **your own** sound as `hf1_stationalarm/sounds/alarm.ogg` (the ZIP does not include copyrighted audio).
3. Change the example vector3 coordinates in `config.lua` to your actual station points and reset prop location. Set `soundOrigin` where the siren should be heard.
4. Ensure `qbx_core`, `ox_lib`, `ox_target` start before `ensure hf1_stationalarm` in server.cfg.
5. Restart the resource.

## Notes
- Only **on-duty** `police` (any grade) can trigger/reset; target filtering is client-side and server independently validates job and proximity.
- Alarm and reset actions are available at configured sphere zones, including coordinates positioned on props.
- Every connected player receives the alarm notification; audio plays near its configured origin and fades with distance. Reset stops audio for all clients.
- Alarm state is synced to joining clients and remains until reset or resource/server restart.
- Add stations by copying a `Config.Stations` entry with a unique key. Each station has independent state.
- Sound is local to each client, so a proper mono or stereo OGG is recommended. NUI audio autoplay behavior can vary by client; test in your server.
- For off-duty police too, remove `and player.PlayerData.job.onduty == true` from `server.lua`.
