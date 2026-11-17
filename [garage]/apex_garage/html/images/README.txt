CUSTOM VEHICLE IMAGES
=====================

Drop a picture in THIS folder named after the vehicle's spawn code:

    html/images/adder.png
    html/images/t20.png
    html/images/mycustomcar.png      <- addon cars work too

That is the whole setup.

How a thumbnail is chosen (first hit wins):

    1. your file here      html/images/<spawncode>.<ext>
    2. the fallback URL    Config.vehicleImages.fallbackUrl
                           (https://docs.fivem.net/vehicles/<spawncode>.webp)
    3. a monogram          the vehicle initials on a styled tile

Notes
-----
* Name must match the spawn code, lowercase (adder, not Adder).
* Extensions tried in order: png, jpg, jpeg, webp (Config.vehicleImages.extensions).
* Transparent PNGs look best (the tile has its own background).
* ~600x360 is plenty.
* Restart the resource after adding files (FiveM only serves files that
  existed at start-up).

Turn it off with Config.vehicleImages.enabled = false (monogram only), or
Config.vehicleImages.custom = false to use only the fallback URL.
