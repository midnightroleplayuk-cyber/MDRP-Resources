# Designs and customization

## Custom wording

The menu includes a **Custom text** card alongside the 61 standard UK designs. Select it and use the native wording prompt. Standard design choices exit custom mode before they are accepted, so UK lettering is not replaced by a previous custom selection. Custom wording is a separate clean texture with no underlying UK text layer. Existing custom spans are unaffected by changing the future placement selection.

Use these default commands, or rename tapetext through Commands:

| Command | Action |
|---|---|
| `/tapetext` | Open GTA's native text-entry prompt for future tape |
| `/tapetext EVENT ACCESS ONLY` | Use this wording for newly placed spans |
| `/tapetext apply` | Open the prompt and change the nearest intact span you may edit |
| `/tapetext apply KEEP CLEAR` | Change nearby tape directly |
| `/tapetext clear` | Restore the nearby span's underlying design |
| `/tapetext off` | Return future placement to standard designs |

Custom wording uses a white ribbon with blue print and blocks by default, with readable faces using the existing renderer. Future-wording selection lasts for the player's current resource session; placed wording is synced and persisted with the span. Applying text uses existing server edit, ownership and reach checks. Text selection requires tape-use permission; CustomText.StaffOnly can add the configured staff gate. Normal tape placement and inventory rules still apply. Applying a standard design to an existing span clears its custom wording.

Configure CustomText.Enabled to allow or reject new text changes. Existing stored text is retained. MaxLength defaults to 64 Unicode characters. MaxUnique defaults to eight distinct messages across active spans to bound browser texture cost; repeated messages share a texture. A sole message can be replaced even when the quota is full. Background and Foreground accept six-digit hex colours. Rename the command with Commands.tapetext. Use a single CustomText/Access/Commands table for your overrides in config.lua.

```lua
UserConfig = { Version=2, Settings={
    CustomText={Enabled=true,StaffOnly=false,MaxLength=64,MaxUnique=8,
        Background='#fafafa',Foreground='#164c9a'},
    Access={Pose='one_hand',IkArm=4,GripForward=.25,GripSide=.18},
    Commands={tapetext='tapewording'},
} }
```

**Rockstar Editor:** runtime custom wording is gameplay-only. It is drawn with a runtime browser texture, which is not baked into the recording models. Such spans deliberately use the live renderer and do not count as ready recording objects; they will not reliably appear in Editor playback. Clear the wording or choose a shipped design before recording. A permanent custom design for Editor requires baked model assets; see [recording limits](recording.md).

Text is drawn literally on a local canvas, without HTML insertion, remote URLs or client-defined models. Control characters, invalid UTF-8 and excessive text are rejected by the server. Automated checks cover permissions, quotas, literal text rendering and hand-target lifecycle. Final animation quality still needs an in-game check.

## Lifting

Use the existing target lift action anywhere along the ribbon, or the configured access command. Lifting always loads and plays Access.AnimDict/AnimName at normal speed. The shipped hands-up base visibly raises the arms; the default right-arm IK refines its reach to the shared tape grip. Availability of the IK native no longer skips the base animation. The grip moves to just forward of the player's shoulder rather than leaving the tape held away from their body. The IK target follows raising and lowering; Backspace lowers early, and existing hold-to-lift/controller preferences still apply. No extra aiming or alignment step is required.

Observers apply the same hand target locally. Recording objects and procedural tape use the same authoritative lift path. The IK target expires after release and does not clear unrelated ped tasks. Set Access.Pose='animation' to use the configured base animation without IK. If IK is unavailable the same base animation still plays. A custom base clip can be supplied through Access.AnimDict/AnimName; if using the optional reach intro, configure Polish.ReachAnim for that dictionary as well. Access.IkArm is 4 for the right arm or 3 for the left. GripForward and GripSide adjust reach in metres. Ped models and other animation resources can affect the final pose, so check it on your server's male/female/custom peds.

## Translation

Set Locale to `en`, `fr` or `de`. `locales/messages.lua` contains the dictionaries and English fallback. `LocaleOverrides={['Tape repaired.']='Your replacement'}` replaces a phrase without editing vendor dictionaries. Preserve `%d`, `%s` and precision placeholders when editing formatted phrases. The 61 supplied tape designs always use UK English; interface locale changes do not translate their artwork. Customer scene names and command names stay as entered. Minor untranslated/custom text falls back to English. Layout and styling are unchanged; check longer translations at your target resolution.

## Custom artwork

To add a design, put a PNG in textures/ and add its path to the files list in fxmanifest.lua. Add a unique design ID in config.lua:

```lua
UserConfig={Version=2,Settings={TapeStyles={my_tape={
    label='My Tape',image='textures/my_tape.png',
    preview='../../textures/my_tape.png',category='event',aspect=16,enabled=true,
}}}}
```

Set aspect to image width divided by height. Custom IDs without an embedded image use their configured file path. Keep the police fallback design enabled.

After replacing a supplied PNG, run the optional helper from the resource directory: python tools/build_assets.py. It uses Python's standard library and rebuilds both embedded gameplay/menu copies. Restart and reconnect to check the result. Editing the PNG alone does not replace embedded stock artwork. The precompiled Rockstar Editor models keep their baked artwork; new or replaced designs need separately rebuilt recording models before they can be relied on in playback. Model compilation tools are excluded from this buyer package.

## Tape catalogue

61 stock designs use UK English. Some internal IDs retain older foreign names for saved-state compatibility. Disable a non-fallback design with TapeStyles={style_id={enabled=false}} inside Settings.

| ID | Design | Category |
| --- | --- | --- |
| police | UK Police Tape | police |
| fire | UK Fire Tape | fire |
| ambulance | Ambulance | medical |
| crime | Crime Scene | crime |
| caution | Caution | caution |
| danger | Danger | hazard |
| rescue | Rescue cordon | rescue |
| hazmat | Hazardous materials | hazard |
| utility | Utilities | utility |
| search | Search area | police |
| redwhite | Red / white barrier | plain |
| event | Event boundary | event |
| police_us | Police Cordon Yellow | police |
| sheriff | Police Incident | police |
| state_police | Traffic Police | police |
| federal | Major Investigation | police |
| military_police | Military Police | police |
| police_night | Police Reflective | police |
| police_fr | Police Cordon White | police |
| gendarmerie | British Transport Police | police |
| polizei | Police Search Cordon | police |
| politie | Police Restricted Area | police |
| policia_es | Police Dog Search | police |
| polizia | Collision Investigation | police |
| policia_pt | Police Authorised Access | police |
| police_au | Police Blue Cordon | police |
| police_ca | Police Scene Boundary | police |
| evidence | Evidence Preservation | crime |
| forensic | Forensic Examination | crime |
| inner_cordon | Inner Cordon | crime |
| outer_cordon | Outer Cordon | crime |
| crime_us | Crime Scene Yellow | crime |
| fire_us | Fire Cordon Red | fire |
| fire_uk | Fire Service Cordon | fire |
| fire_fr | Fire Investigation | fire |
| feuerwehr | Fire Service Restricted Area | fire |
| brandweer | Fire Appliance Access | fire |
| bomberos | Fire Safety Cordon | fire |
| medical | Medical Emergency | medical |
| triage | Triage Boundary | medical |
| ambulance_fr | Ambulance Incident | medical |
| rettungsdienst | Emergency Medical Access | medical |
| helicopter | Helicopter Landing Zone | rescue |
| water_rescue | Water Rescue | rescue |
| mountain_rescue | Mountain Rescue | rescue |
| structural | Structural Hazard | hazard |
| biohazard | Biohazard Isolation | hazard |
| radiation | Radiation Boundary | hazard |
| chemical | Chemical Spill | hazard |
| electrical | Electrical Hazard | utility |
| gas | Gas Emergency | utility |
| waterworks | Water Works | utility |
| roadworks | Road Works | utility |
| construction | Construction Boundary | caution |
| slippery | Slippery Surface | caution |
| restricted | Restricted Access | event |
| vip | VIP Boundary | event |
| plain_yellow | Yellow / Black Chevron | plain |
| plain_blue | Blue / White Chevron | plain |
| plain_green | Green / White Chevron | plain |

## UK Police Line - Blue Blocks

`police_line_uk` adds a separate blue-and-white UK option with the complete wording **POLICE LINE DO NOT CROSS** on white between solid blue blocks. The editable source is `html/tape/police_line_uk.svg`; its packaged PNG is `textures/police_line_uk.png`. It is available in the menu as **UK Police Line - Blue Blocks**. The original four supplied images remain unchanged; the catalogue now contains 61 designs.
