APEX GANGS — GRAFFITI IMAGE GALLERY
===================================

Drop your .png images in THIS folder (html/images/). To show one in the graffiti
editor's IMG panel, list its file name in:

    shared/config.lua  ->  Config.graffiti.images.gallery = {
        'gorilla.png',
        'crown.png',
        'ballas.png',
    }

Restart the resource and the images appear in the editor's IMG gallery. They
load LOCALLY (no external URL). Players drag them onto the canvas to compose a
tag together with text and freehand drawing; the finished piece is flattened to
a single image and sprayed on the wall.

Tips:
  - Transparent PNGs work best (the transparency is preserved on the wall).
  - Keep them reasonably sized (e.g. 256-512 px) for crisp results.
  - You can mix gallery images, custom URLs, text and freehand drawing as layers.
