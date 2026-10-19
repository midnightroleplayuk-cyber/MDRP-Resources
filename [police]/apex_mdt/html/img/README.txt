Images used by the MDT tablet. Replace them in place (keep the file
names) or point the config at your own files.

  police.png      background for the Police mode tablet
  ambulance.png   background for the EMS / Hospital mode tablet
                  -> shared/config.lua : Config.wallpaper

  perfil.png      default profile photo, used in every avatar slot
                  until the officer captures one
                  -> shared/config.lua : Config.avatar.defaultUrl

Backgrounds: 2560x1600 (16:10), dark and low-contrast works best --
they sit faintly behind the UI (Config.wallpaper.opacity, 0.55 by
default). Profile photo: square, 256x256 or larger.

Any .png / .jpg / .webp dropped in this folder is picked up by the
wildcards in fxmanifest.lua, but the resource only reads the file
list at start -- restart apex_mdt after adding new pictures.
