# APEX Tape 2.0

Police and emergency-service cordons for FiveM. Includes 61 UK/English designs, custom wording, chained placement, lifting, cutting, repair, scenes and torn-end reuse.

## Install in five steps

1. Copy **APEX_Tape** into your server's resources directory. Run one copy of the resource.
2. Enable OneSync. No framework or inventory is required for the default setup.
3. Add the following to server.cfg, using your server's administrator group:

```text
add_ace group.admin apex.policetape.admin allow
ensure APEX_Tape
```

4. Open **config.lua**. This is the only file most buyers need to edit. Choose your access policy and any optional integrations, then restart APEX_Tape.
5. On foot, run **/ptape**. Aim and press **E** at the first point, then the second. Run **/changetape** to choose a design. Backspace clears the current selection; /ptape puts tape away.

Placement is public by default. Target removal is restricted to the owner/admin. For job or ACE restrictions, use the examples in [setup](docs/setup.md). Start ox_target before APEX_Tape if you want target actions; commands also work without it.

## Common actions

| Action | Default command |
| --- | --- |
| Place / put away | /ptape |
| Choose a design | /changetape |
| Lift / lower tape | /tapeaccess / /tapeclose |
| Repair nearby torn tape | /taperepair |
| Remove nearby owned tape | /removetape |
| Undo your latest span | /tapeundo |
| Open scenes | /tapescenes |
| Reset selection or close panels | /tapereset |

## Guides

- [Setup](docs/setup.md): access, optional inventory, file layout, backups and troubleshooting.
- [Commands](docs/commands.md): full command list, target settings and custom adapters.
- [Gameplay](docs/gameplay.md): scenes, templates, traffic, NPCs and controller controls.
- [Customization](docs/customization.md): designs, wording, translations and textures.
- [Integrations](docs/integrations.md): framework/inventory adapters and developer exports.
- [Recording](docs/recording.md): Rockstar Editor setup and limits.

Keep the complete runtime folders, including stream/. Test on a development server with two clients before going live. Live FiveM behaviour has not been verified in this workspace; runtime custom wording is excluded from recording objects.

RJ / APEX Studios. Original APEX attribution and artwork retained.
