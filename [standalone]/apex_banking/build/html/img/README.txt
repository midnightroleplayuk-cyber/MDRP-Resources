Apex Banking — custom images
============================

Drop your own images here (bank logo, card art, a background) and
reference them from the NUI as:

    img/your-file.png

fxmanifest.lua already ships `'build/html/img/*'` in its `files` block,
so anything you put in this folder is served to the NUI without any
further change. Restart the resource after adding a file.

The interface itself uses no bitmaps — every icon and illustration is
inline SVG, which is why this folder starts empty. That also means the
bank stays sharp at any resolution.

This folder is listed in `escrow_ignore`, so your images are never
encrypted and you can swap them at any time.
