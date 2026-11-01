# Editable identity, license and service cards

These files are shipped as readable source and loaded at runtime. You can change the complete
HTML structure, styles and rendering JavaScript without a Vue or npm build.

| File | Purpose |
| --- | --- |
| `identity.html` | Identity card structure. |
| `licenses.html` | License card structure, including the held-license list. |
| `service.html` | Service ID structure. |
| `documents.css` | Main stylesheet; imports `identity.css`. |
| `identity.css` | Existing shared styles and customer overrides. |
| `documents.js` | Editable ES module that loads and fills the templates. |
| `preview.html`, `preview.js` | Standalone browser example with sample data. |
| `logo.svg`, `service-security.svg` | Editable local artwork. |

After editing deployed files, restart Jobs Base so FiveM refreshes the resource files and its
browser module cache. An HTML/CSS/JS change here does not need a frontend rebuild. Preserve
your customized files when installing an update. The whole `config/**` directory is already
excluded from escrow; `config/documents/**` is already included in the resource manifest.

Position, size, issuer and optional logo still come from `Config.PlayerIdentityCard` / Job
Configurator. Service-card presentation settings still use their existing per-department
configuration. Saved configurator values take precedence over `config.lua`.

## Change the HTML

The default renderer uses markers that can appear anywhere in your structure. You can rename
classes, replace wrappers, reorder or remove fields. For example:

```html
<section class="my-card">
  <header><strong data-field="holder.name"></strong></header>
  <img data-if="portrait" data-image="portrait" data-alt="holder.name">
  <p><span data-field="labels.birthdate"></span>: <span data-field="holder.birthdate"></span></p>
</section>
```

Style `.my-card` in `documents.css`. The shipped cards use `vh` for width, typography, spacing,
borders and printed patterns. Their reference is 1080p: `44.444444444vh` equals 480 pixels.
Height follows the content, with the data zone directly below the body. All three document
titles share the same typography. At 4K, the entire card takes the same proportion of the
screen, including text and spacing; the configured scale still applies.
Use viewport-relative dimensions for your custom layout too. Jobs Base measures the rendered
card and keeps it inside the viewport. The outer
Jobs Base frame owns position, scale, keyboard close and the 60-second expiry.

| Marker | Behavior |
| --- | --- |
| `data-field="holder.name"` | Sets plain text; character data is never interpreted as HTML. |
| `data-image="portrait"` | Sets an image source on an `img`; an empty source is removed. |
| `data-if="portrait"` | Shows the element when that model value is truthy. |
| `data-if-not="hasLicenses"` | Shows it when that value is falsey. |
| `data-title`, `data-alt`, `data-aria-label` | Reads a model field into the corresponding attribute. |
| `data-list="licenses"` | Repeats the direct child `template`, which must contain one root element. |
| `data-key="item.type"` | Keeps list rows, focus and scroll when other card data changes. |
| `data-action="openLicense"` | Calls the existing native-card selection action. |
| `data-index-field="item.cardIndex"` | Supplies that action's index; hide the button when the index is empty. |
| `data-action="close"` | Closes this card. Optional; the shipped cards have no close button. |
| `data-portrait` | Applies the default portrait/placeholder appearance and accessible label. |
| `data-document` | Applies the default service template/background attributes and color variables. |

List rows receive the same model plus `item`, for example:

```html
<ul data-list="licenses" data-key="item.type">
  <template>
    <li>
      <span data-field="item.label"></span>
      <button type="button" data-if="item.cardIndex" data-action="openLicense"
        data-index-field="item.cardIndex" data-field="labels.open"></button>
    </li>
  </template>
</ul>
<p data-if-not="hasLicenses" data-field="labels.noLicenses"></p>
```

Relative `src`, `href` and `poster` paths are resolved against this directory. CSS asset URLs
resolve against their stylesheet normally. Use this directory's URL for `srcset` or custom
JavaScript-created assets. Scripts placed inside an HTML template are not executed: put code
in `documents.js` or import another local ES module from there.

Unknown fields, invalid list templates and unsupported renderer versions produce explicit
errors. Jobs Base shows a localized failure message and retains keyboard close and expiry.

## Renderer API, version 1

`documents.js` exports `apiVersion = 1` and `mount(root, model, actions, options)`. Mount may be
async and must return `{ update(model), dispose() }`. Jobs Base mounts a new view when the
document type changes and calls `update` when its data, photo, language or presentation settings
change. Avoid rebuilding the whole DOM on each update: preserve focus, selection and scroll.

`root` is a dedicated DOM container inside the measured Jobs Base frame. It belongs to this
view; a superseded mount cannot overwrite a newer card. `options.assetBase` is this directory's
absolute URL. `options.signal` is aborted when loading is superseded or the card closes. Check
it after async work and before attaching handlers. `dispose()` must remove your listeners,
observers, timers and other effects. The supplied renderer demonstrates this lifecycle.

You can replace the entire renderer. It does not depend on Vue, internal component names or
the compiled UI bundle. Keep the versioned interface and return a view with `update`/`dispose`.
The data contract is:

| Field | Value |
| --- | --- |
| `version` | `1`. |
| `type` | `identity`, `licenses` or `service`. |
| `title` | Localized document title. |
| `holder.name`, `firstname`, `lastname` | Display strings; unavailable values are localized. |
| `holder.splitName` | Whether separate first/last name fields are available. |
| `holder.birthdate`, `gender`, `height` | Display strings; height includes its unit. |
| `portrait` | Prepared portrait URL/data URL, or an empty string. Photo processing stays in Jobs Base. |
| `issuer`, `logo` | Configured issuer and absolute local logo URL, or empty strings. |
| `licenses` | Actual held entries: `{ type, label, cardIndex }`; `cardIndex` is a number or `null`. |
| `hasLicenses` | Whether that list has entries. |
| `service` | `{ job, department, rank, number, template, background, color }`; display strings. |
| `code` | Two strings containing the existing visual data-zone representation. |
| `labels` | Localized `firstName`, `lastName`, `name`, `birthdate`, `gender`, `height`, `rank`, `number`, `licenses`, `noLicenses`, `open`, `close`, `unavailable`. |

Only use personal fields appropriate to the document: the shipped license card omits birthdate,
gender and height; the service card shows employment information. An unavailable service number
is an empty string. No document number, expiry or license is invented by the renderer.

`actions.close()` closes the current card. `actions.openLicense(cardIndex)` selects an available
native provider card through the existing authorized server path. It cannot grant/revoke a
license or select another person. The core rejects indexes absent from this card. Presentation
JavaScript is not gameplay authority; server permission, distance and character checks remain
in their existing owners. Native third-party ID resources keep their own interfaces.

## Browser preview

Serve this folder with any local static HTTP server. For example, from this directory:

```sh
python -m http.server 8787 --bind 127.0.0.1
```

Open `http://127.0.0.1:8787/preview.html`. Stop the server with Ctrl+C when finished. No npm
installation or build is needed; Python in this example only serves the files. Opening the
file directly with `file://` does not support the module/template fetches.

The preview uses the same Roboto font reference and label weight as the existing UI.
The preview exercises the actual shipped renderer, templates, styles and artwork with sample
data. Choose all three documents, empty/large license lists, long/missing names, portraits,
issuer/logo and service layout/background choices. Reload after editing HTML/CSS/JS. Preview
actions never contact FiveM or change gameplay. Real server authorization, native-provider
handoffs, photo capture and game focus require a connected FiveM client.
