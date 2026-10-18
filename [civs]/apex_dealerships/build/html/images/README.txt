CUSTOM VEHICLE IMAGES
=====================

Drop a picture in THIS folder named after the vehicle's spawn code:

    build/html/images/adder.png
    build/html/images/t20.png
    build/html/images/mycustomcar.png     <- your addon cars work too

That is the whole setup. No config, no list to maintain.

How a thumbnail is chosen (first hit wins):

    1. your file here          build/html/images/<spawncode>.<ext>
    2. the fallback URL        Config.vehicleImages.fallbackUrl  (base-game
                               screenshots from the FiveM docs)
    3. a monogram              the brand initials on a styled tile

So a custom image ALWAYS wins over the base-game one, and a vehicle with no
image of any kind still looks intentional instead of broken.

Notes
-----
* The name must match the spawn code exactly, lowercase (`adder`, not `Adder`
  or `Adder.png `). It is the same code you see under the vehicle name in the
  admin catalog.
* Allowed extensions: png, jpg, jpeg, webp — tried in that order. Change the
  list in Config.vehicleImages.extensions.
* Transparent PNGs look best: the tile has its own background.
* Around 600x360 is plenty. Huge files just cost the player memory.
* After adding images, restart the resource (FiveM only serves files that
  existed at start-up).

Turning it off
--------------
    Config.vehicleImages.enabled = false   -- no pictures at all, monogram only
    Config.vehicleImages.custom  = false   -- ignore this folder, URL only
    Config.vehicleImages.fallbackUrl = false  -- use ONLY the images in here
