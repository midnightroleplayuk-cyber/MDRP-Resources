CUSTOM VEHICLE IMAGES
=====================

Drop a picture in THIS folder named after the vehicle's spawn code:

    html/images/adder.png
    html/images/t20.png
    html/images/mycustomcar.png      <- addon cars work too

That is the whole setup.

How a thumbnail is chosen (first hit wins):

    1. your file here      html/images/<spawncode>.<ext>
    2. the fallback URL    Config.VehicleImages.fallbackUrl
                           (https://docs.fivem.net/vehicles/<spawncode>.webp)
    3. a monogram          the vehicle initials on a styled tile

Notes
-----
* Name must match the spawn code, lowercase (adder, not Adder).
* Extensions tried in order: png, jpg, jpeg, webp (Config.VehicleImages.extensions).
* Transparent PNGs look best (the tile has its own background).
* ~600x360 is plenty.
* Restart the resource after adding files (FiveM only serves files that
  existed at start-up).

Don't know a car's spawn code? The panel shows it: open Vehicles, click a
card, and read the "Spawn code" row in the detail pane.

Turn it off with Config.VehicleImages.enabled = false (monogram only), or
Config.VehicleImages.custom = false to use only the fallback URL.

This is the same mechanism, config shape and folder convention as
apex_garage, so pictures can be copied straight across between them.
