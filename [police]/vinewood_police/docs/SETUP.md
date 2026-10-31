# Your first hour

From an empty install to your first arrest. You need the admin ace (see `INSTALL.md`).

## 1. Check what's running (2 minutes)
In the server console: `vpo status`. It shows the framework, inventory, migrations and each Vinewood integration as running or not. Fix anything unexpected before going on.

## 2. Put your stations where your MLOs are (15 minutes)
In game, run `/vpo`: the admin panel opens. Press **Locations editor**.
- **Stations:** for each station, stand at the front desk and press **Add station (sign-on point here)**. Then walk to the locker room and press **Add locker here**, and to the armoury and press **Add armoury here**. Rename it, then **Save**.
- **Custody:** stand at the custody desk and press **Add custody suite (desk here)**. Move the **release point** to the front door. **Save** the suite, then press **Place cells in the world**. The menu closes: walk the suite and in each cell stand where a detainee should be, facing their way, and press **E**. Keep going until you're done, then press **Enter** to save. Then **Set cell doors in the world**: walk up to each cell door (it lights up yellow, with a line to its cell) and press **E**. **Q** picks a different cell, scrolling picks a different object, **Z** undoes, **Enter** saves. Then **Place cameras in the world**: fly the camera to the corner of each cell (and around the suite), line it up and press **E**.
- **Callout places:** add a few shops (stand at the till), streets, houses (front door) and roads (on the road, facing traffic) around your map. **Save**.
- **No-hostile zones:** add your busy areas, hospital and stations, with a radius. NPCs never fight officers inside these. **Save**.
- **Changing rooms:** in Stations, stand in each station's changing room and press **Add changing room here**. **Save**.
- **Uniforms:** dress your character in a uniform with your clothing script, then in **Uniforms** press **New uniform from my clothes**. Name it, choose the lowest rank allowed, and tick units if it's only for some (e.g. Roads policing). Switch to a character of the other sex and press **Save my clothes** on the other version. **Try on** checks it, **Own clothes** puts yours back. **Save**.

Use **Walk around** to move with the editor open, and F7 to get the mouse back. Markers show what you're editing. Everything applies straight away.

## 3. Set up your first officers (5 minutes)
Give your sergeant the police job at a sergeant grade, then:
```
/collar <id> 4521
/qualgrant <id> tutor
/qualgrant <id> taser 365
```
From then on, sergeants sign off other officers' qualifications themselves (`/qualgrant`, `/quals`).

## Management (boss menu)
Senior officers use `/management` (also in the radial under Station):
- **Hire** someone standing next to you. They start as Student Officer (`Config.Management.HireRank`).
- **Rank:** promote or demote, up to the rank below your own.
- **Suspend from duty** with a reason. They come off duty and can't sign on until it's lifted.
- **Dismiss** with a reason. It works on officers who are offline too.
- **Collar** numbers.
- **Qualifications:** see what each officer holds and when it expires, sign off new ones and revoke them. The usual sign-off rules apply.

Who can do what is in `config/ranks.lua`: Inspector+ views, hires and suspends, Chief Inspector+ changes ranks, Superintendent+ dismisses. Nobody can act on someone of their own rank or above. Everything is audited.

## 4. Sign on and kit up (5 minutes)
At the station's sign-on point: callsign, unit, vehicle, then **Sign on**. At the locker, draw cuffs, baton, torch and radio, and pick a uniform. At the armoury, sign out a Taser (needs the qualification).

## 5. First arrest (10 minutes)
With a second player:
1. Target them: **Handcuff (rear)**. A use of force form is started in `/police`, Forms.
2. Target them: **Arrest**. Pick the offences, write grounds, tick a necessity reason, show and confirm the caution.
3. **Escort**, then **Put in vehicle**, and drive to custody.
4. At the custody desk: **Book in**, **Take property**, **Place in cell**.
5. Record the outcome on the MDT (bail, NFA, charge). They're released from the cell automatically. Without the MDT, use **Release** in the custody panel.

## 6. Turn on callouts (2 minutes)
Callouts start by themselves while officers are signed on. To see one now: `vpo callout shoplifting` near a shop you added. Tune how often calls come in `config/callouts.lua`.

To switch them off for an event night: `vpo callouts off` (add `clear` to also cancel calls nobody has reached yet), then `vpo callouts on` afterwards. `vpo callouts` on its own shows whether they're on. The setting is kept through restarts. Admins can still start one with `vpo callout <scenario>` while they're off.

## The radial menu
While signed on, the radial menu (ox_lib, **Z** by default) has a **Police** section:
- **Status**
- **Restrain:** cuff front or rear, remove, double-lock, escort, into or out of a vehicle
- **Search & arrest**
- **Roads:** stop the vehicle in front, roadside checks, Stinger
- **Scene:** scene kit, major incident
- **Calls & backup:** call list, request backup and urgent assistance at your position
- **Station:** custody, evidence, CID, use of force forms, notebook
- **Dog** (Dog section only)

Radial actions use the closest player or vehicle. NPCs are dealt with through the target menu. The radial is switched off while you're handcuffed.

## Day-to-day commands
`/police` hub · `/cuff` `/uncuff` `/escort` · `/stopvehicle` · `/stopsearch` · `/scenekit` · `/custody` · `/evidence` · `/calls` · `/incident` · `/cases` · `/dog` · `/stinger` · `/standards` (Inspector+) · `/complaint` (anyone)
