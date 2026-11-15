# NDM_MRI

MRI scanner add-on for **osp_ambulance**. It is a separate resource, so updating OSP never wipes it.

## What it does
1. A medic places the patient on the MRI table (or the patient lies down themselves).
2. The medic starts the scan, from the table or from the control-room console.
3. Everyone nearby hears the MRI noise in 3D (it fades out by distance), and the medic gets an ox_lib progress bar.
4. When the bar finishes, the medic gets an **MRI Scan Report** on screen built from the patient's OSP injuries:
   fractures, wounds per body part, active bleeding, sutures needed, tourniquets, vitals, blood level,
   cardiac rhythm and active conditions, plus a short impression.
5. Fractures found by the MRI are marked as imaged in OSP (same as the OSP X-ray), so splint / cast options open up.
   Turn this off with `Config.ConfirmFractures = false`.

## Install
1. Drop `NDM_MRI` into `resources/[medical]/` (next to `osp_ambulance`).
2. Make sure it starts **after** `ox_lib`, `ox_target`, `qbx_core` and `osp_ambulance`
   (if `[medical]` is ensured as a folder, that is already the case).
3. Set your vectors in `config.lua` (see below) and restart.

## Setting the vectors
In game, use `/mripos`. It prints your position as a `vector4` to F8 and copies it to the clipboard.
- `table`: stand on the floor in the middle of the MRI table, facing the way the patient's feet should point,
  and run `/mripos`. Your standing height is about the table height, so the z usually works as-is;
  nudge it up or down by 0.1 if the patient floats or sinks.
- `console` (optional): stand at the control-room desk and run `/mripos`, then use the x, y, z as a `vector3`.
  Leave it `nil` to start scans from the table instead.

## Sound
`html/sounds/mri_scan.ogg` is an original synthesised MRI loop (knocking, buzzing and helium pump chirps)
made for this resource, so there are no licence issues. To use your own, drop an `.ogg` in `html/sounds/`
and change `Config.SoundFile`.

## Permissions
Scans, placing and removing patients need a job listed in `Config.Jobs` (default `ambulance`) and,
if `Config.RequireOnDuty` is on, being on duty. All checks run on the server.

## Report image
The body on the report is `html/img/body_mri.jpg` (a whole-body MRI image supplied by the server owner), with the
injured regions tinted on top. To swap it, replace that file with another front-facing full-body image
(the tint regions are laid out for a 400 x 1281 image; tweak the polygons in `html/index.html` if yours differs).
