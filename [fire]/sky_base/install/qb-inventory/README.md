# Individual item labels for qb-inventory

Optional compatibility patch for the qb-inventory 2.0 Vue interface. Use the label
already stored in each item's `info.label` / `metadata.label` without changing the
shared item catalog. Works for all item names, including `doj_document`.

From the **qb-inventory resource directory**, after backing up `html/app.js` and
`html/index.html`, run:

```sh
git apply --check /path/to/sky_base/install/qb-inventory/item-labels.patch
git apply /path/to/sky_base/install/qb-inventory/item-labels.patch
```

If the check fails, inspect your inventory fork; do not force the patch or overwrite
its interface with stock files. A successful reverse check (`git apply --reverse
--check ...`) means these hunks are already present. To revert this change, use
`git apply --reverse ...` after checking it against your current files.

The patch uses the custom name in tooltips, hotbar, item notifications and existing
item-label markup. Tooltip names, descriptions and metadata are escaped as text.
Without a non-blank string label, the usual item label is shown. No schema change,
new item type, runtime injection or Vue build is required; reload qb-inventory on
your next controlled server start.

The Sky bridge passes metadata through its normal `AddItem` interface. This patch
only reads the data the inventory supplies; catalog-only notifications cannot show
a per-copy name unless the caller also supplies that copy's metadata.
