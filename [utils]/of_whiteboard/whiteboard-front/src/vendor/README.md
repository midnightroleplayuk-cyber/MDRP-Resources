# Vendored dependencies

Third-party code kept in-tree rather than pulled from npm. Treat these folders as
external: format them with the project's rules, but keep changes minimal and
documented here so an upstream bump stays tractable.

## react-image-editor

Derived from [`@ozdemircibaris/react-image-editor`](https://github.com/ozdemircibaris/react-image-editor)
(MIT), forked at v1.1.x. Vendored because the published package has no text tool,
no eraser, and no way to reopen a canvas from serialised state -- all three are
required for poster re-editing.

Changes on top of upstream:

- **Text tool** -- font family/size, bold, italic, underline, highlight, align,
  line spacing and heading presets, with RTL detection driving direction/align.
- **Eraser tool** -- a real destination-out brush rather than an undo shortcut.
- **Canvas serialisation** -- `initialCanvasJson` in, `exportCanvasJSON()` out, so
  an edit session restores the actual objects instead of a flattened image.
- **`onChangeImage`** -- lets the host swap the backing image without unmounting.
- Icons moved to `assets/icons` and inlined via `?raw` instead of being fetched.
