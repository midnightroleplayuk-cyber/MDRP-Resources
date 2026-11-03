# Custom job bell sounds

Put your own OGG, WAV or MP3 files in this folder. Use simple filenames without spaces
or dots before the extension, for example `reception.ogg`. Subfolders are supported.

In `/jobconfig` open **Jobs Base → Bells → Custom sounds** and add a unique ID, display
name, file path and the complete file duration in seconds (0.1–15). Example:

```lua
Config.Bells.customSounds = {
    { id = "reception", label = "Reception", file = "config/sounds/bells/custom/reception.ogg", duration = 2.0 },
}
```

Restart `sky_jobs_base` after adding new files so FiveM includes them in the resource
download. Then select the sound on the job's bell. Saved `/jobconfig` values take
precedence over this plaintext configuration example. Export/import transfers the
catalog settings; copy the audio files separately.

Use files you have permission to distribute. The seven bundled bells are original
procedural synthesis; their provenance is recorded in `../provenance.json`.
