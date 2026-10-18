# Put your own badge on the station

The station ships with a generic "Los Santos Police Service" crest. Every texture a server usually rebrands is in
ONE texture dictionary that is not encrypted:

    stream/branding/nobs_ukpd_branding.ytd

The models look these textures up by name, so a texture you replace in this file changes everywhere it is shown,
inside and outside the station. Nothing else needs editing.

## The textures

| Texture | Size | Format | Artwork | Shows on | Template |
|---|---|---|---|---|---|
| `ukpd_mp_crest` | 1024 x 1024 | DXT1 | opaque | crest panels on blue: press-room and parade-room lecterns, Gold suite console, front office and press room, control room, interview rooms | `install/branding_kit/ukpd_mp_crest.png` |
| `nobs_ukpd_d38_crest_a` | 512 x 512 | DXT5 | white on transparent | crest on the seven navy feature walls: lobby, stair 2 / public interview, sergeants office, ground-floor armoury, command suite, meeting room / RPU, parade room / gym / intel | `install/branding_kit/nobs_ukpd_d38_crest_a.png` |
| `nobs_ukpd_d39_owner_logo_a` | 1024 x 1024 | DXT5 | white on transparent | large logo on the lobby feature wall | `install/branding_kit/nobs_ukpd_d39_owner_logo_a.png` |
| `nobs_ukpd_d37_material_press_backdrop` | 512 x 512 | DXT1 | opaque | press-room backdrop (repeats across the wall) | `install/branding_kit/nobs_ukpd_d37_material_press_backdrop.png` |
| `nobs_ukpd_mp_station_plate_name` | 1024 x 256 | DXT1 | opaque | POLICE STATION name plate on the front of the building | `install/branding_kit/nobs_ukpd_mp_station_plate_name.png` |
| `nobs_ukpd_mp_plaque_face` | 1024 x 512 | DXT1 | opaque | entrance plaque (front counter hours, 999 / 101) | `install/branding_kit/nobs_ukpd_mp_plaque_face.png` |

"White on transparent" textures are drawn as white artwork over the navy wall colour: keep the background fully
transparent and the artwork white (or light). "Opaque" textures fill their whole panel, background included.
`nobs_ukpd_d37_material_press_backdrop` repeats across the backdrop wall, so its left and right edges (and its
top and bottom edges) must join up.

## How to replace a texture

1. Open the PNG with the same name in `install/branding_kit/` in your image editor. It is the current artwork at the
   exact size the game uses. Put your badge, force name or station name in its place. Keep the same width and height.
2. Open `stream/branding/nobs_ukpd_branding.ytd` in a texture tool that edits GTA V texture dictionaries (for example
   OpenIV, CodeWalker's RPF explorer or a texture toolkit). Replace the texture with your image and keep the texture's
   name exactly as listed above. Use the format in the table (DXT1 for opaque textures, DXT5 for textures with
   transparency) and let the tool generate mipmaps.
3. Save the `.ytd` in the same place under the same name. Do not rename the file, do not move a texture into a
   different `.ytd`, and do not add a second texture with the same name anywhere else in your server.
4. Restart the resource or the server. If a client still shows the old artwork, clear that client's FiveM cache
   once.

## Good to know

- Keep a copy of the original `.ytd` before you edit it. Updates of the station replace this file: keep your
  edited copy and put it back after updating.
- The station's own models are encrypted by Cfx asset escrow; textures inside `.ytd` files never are, which is
  why your edits work on the escrowed resource.
- The LSPS posters, notice boards and screens are part of other dictionaries and are not covered by this guide.

## Advanced: door and room plates

The name plates on the doors and room signs are tiles of one large atlas. You can re-letter them the same way,
but every tile must stay exactly where it is in the atlas, or the wrong part of the atlas lands on a plate.

| Texture | Dictionary | Size | Format | What it is |
|---|---|---|---|---|
| `ukpd_mp_d13_sign_a` | `stream/mlo/nobs_ukpd_mp_d13_signs_txd.ytd` | 2048 x 2048 | DXT1 | door and room name plates (atlas of plate tiles) |

Template: the PNG with the same name in `install/branding_kit/advanced/`. Change the lettering inside each tile only,
keep the size and format, and save the `.ytd` under the same name.
