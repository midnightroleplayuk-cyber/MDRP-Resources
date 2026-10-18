DROP YOUR MINIMAP IN THIS FOLDER
================================

Then run, from the tools folder:

   Windows   double-click  import_map.bat
             (or drag your folder / .zip straight onto it)

   Linux     bash import_map.sh
   macOS     bash import_map.sh

Your map becomes a new base map inside the studio: open it, go to
the Maps tab and it is there, ready to paint on and export.


WHAT YOU CAN DROP IN HERE
-------------------------
Anything of these — it works out which one it is:

  * The whole resource folder of a minimap you downloaded or bought.
    Just copy the folder in. It digs through stream/ for you.

  * The six tile files, however they are named:
        minimap_0_0.ytd  minimap_0_1.ytd
        minimap_1_0.ytd  minimap_1_1.ytd
        minimap_2_0.ytd  minimap_2_1.ytd
    (minimap_sea_0_0.ytd and friends work too.)

  * The same six as .dds  (DXT1 / DXT3 / DXT5 or 32-bit)

  * The same six as .png

  * A .zip containing any of the above.

  * ONE big PNG of the whole map. The GTA atlas is 2:3 — 4096x6144
    is ideal — and it gets cut into the six tiles for you.


NOT SUPPORTED
-------------
  * .rar and .7z  — extract them first, then drop the folder in.
  * .jpg / .jpeg  — open it and re-save as .png.
  * .rpf archives — export the .ytd files out of the .rpf first.


IF A TILE IS MISSING
--------------------
Nothing breaks. Any tile your pack does not have is filled in from
the stock GTA map, and the tool tells you which ones.


NAMING IT
---------
By default the map is named after the folder or zip you dropped in.
To choose the name yourself:

   node import_map.js --label "Roxwood" --desc "Roxwood County map"

To see what is installed, or remove one you imported:

   node import_map.js --list
   node import_map.js --remove <id>


AFTER IMPORTING
---------------
   restart apex_minimap

Files left in this folder are never read again after an import, so
you can delete them (or leave them — they are ignored by the game).
