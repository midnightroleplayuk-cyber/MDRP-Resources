# Dispatch postal datasets

Select the dataset matching your server's map in `/jobconfig` → Jobs Base → Dispatch → Postal lookup.
Postal lookup is disabled by default. The JSON file dropdown lists the `.json` files in this
directory each time the Dispatch settings are opened. Add custom files here and reopen the editor.
The chosen resource must contain the same `config/postal/` directory; choose that resource and save
before reopening if using another resource.

Files are complete copies downloaded on 2026-10-09 from these upstream revisions:

| File | Source | Rows | Distinct codes |
| --- | --- | ---: | ---: |
| `oulsen_satmap_postals.json` | [Oulsen/oulsen_satmap](https://github.com/Oulsen/oulsen_satmap/blob/e09e2ca9102f1309ee27e9c100cf252d70fd6fa5/oulsen_satmap/oulsen_satmap_postals.json) | 947 | 946 |
| `new-postals.json` | [DevBlocky/nearest-postal](https://github.com/DevBlocky/nearest-postal/blob/a0c100de02e7764bbe86ce690a9bfe2405e2841a/new-postals.json) | 1687 | 1687 |
| `old-postals.json` | [DevBlocky/nearest-postal](https://github.com/DevBlocky/nearest-postal/blob/a0c100de02e7764bbe86ce690a9bfe2405e2841a/old-postals.json) | 459 | 454 |
| `ocrp-postals.json` | [DevBlocky/nearest-postal](https://github.com/DevBlocky/nearest-postal/blob/a0c100de02e7764bbe86ce690a9bfe2405e2841a/ocrp-postals.json) | 865 | 865 |

The sources use different postal numbering systems. Only one JSON source is selected at a time;
the system does not merge the different maps. Map textures and the Nearest Postal script are not
required for this lookup and are not included. No dataset is downloaded at runtime.

Custom files use the same format:

```json
[
  { "code": "1000", "x": 1644.1221923828, "y": 6456.0561523438 },
  { "code": "1001", "x": 1538.3503417969, "y": 6344.6381835938 }
]
```

`z` and `label` are optional. Keep codes as strings to preserve leading zeros. The final occurrence
of a duplicate code wins, with a server warning. This accommodates the original Oulsen `750` and
Original Postals `891`, `892`, `893`, `895`, `897` duplicates without modifying the source data.
Manual overrides in the configurator take precedence over the selected file. Files are limited to
8 MiB / 20,000 rows. Restart `sky_jobs_base` after editing a selected file to reload its coordinates.

Oulsen data: copyright (c) 2021 Oulsen, MIT; see [LICENSE.Oulsen.txt](LICENSE.Oulsen.txt).
Nearest Postal data: copyright (c) 2019 BlockBa5her, MIT; see
[LICENSE.NearestPostal.txt](LICENSE.NearestPostal.txt). Keep these notices when redistributing.
