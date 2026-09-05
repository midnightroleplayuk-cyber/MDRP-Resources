# ox_lib UI — Star brand redesign

React + TypeScript + Tailwind rebuild of the ox_lib NUI, themed with the Star
design system. Built to **coexist with the existing compiled UI** so the live
resource never breaks while the redesign is in progress.

## Layout

```
ox_lib/
├─ ui/               ← PRODUCTION build (vite build output) — served in-game
│  ├─ index.html
│  └─ assets/        index.js · index.css
└─ web/              ← dev workspace (source) — never shipped at runtime
   ├─ build/         ← legacy official bundle, kept as a backup
   ├─ src/
   │  ├─ nui/        bridge: fetchNui · useNuiEvent · debugData · locale
   │  ├─ components/ Notifications · ContextMenu · InputDialog · AlertDialog ·
   │  │              Progress · TextUI · SkillCheck · RadialMenu · MenuList ·
   │  │              SystemBridge · Icon
   │  ├─ dev/        DevPanel — web-only preview launcher
   │  ├─ types/      contracts mirrored from resource/interface/client/*.lua
   │  ├─ App.tsx     mounts live components + DevPanel (browser only)
   │  └─ style.css   Star :root tokens + Tailwind layers
   └─ vite.config.ts  outDir = ../ui
```

`fxmanifest.lua` serves `ui/index.html`. Rebuilding (`npm run build`) refreshes
`ui/`; the dev preview (`npm run dev`) is independent of it.

## Develop (web preview)

```bash
cd web
npm install
npm run dev     # http://localhost:5173
```

`GetParentResourceName` is undefined in the browser, so `IN_GAME` is false:
the **DevPanel** appears and fires real `notify` / `showContext` / `openDialog`
payloads through `debugData`, exercising the same handlers the game uses.
`fetchNui` just logs in dev — nothing is sent to a server.

## Build

```bash
npm run build   # → ox_lib/ui
```

Outputs the FiveM-ready UI to `ox_lib/ui`. `fxmanifest.lua` already serves it
(`ui_page 'ui/index.html'`), so a rebuild is all that's needed to ship changes.
The dev workspace (`web/`) is never required at runtime.

## Implemented (9/9 components + plumbing)

| Component     | NUI action(s)                                   | Reply callbacks |
|---------------|-------------------------------------------------|-----------------|
| Notifications | `notify`                                        | — |
| Context menu  | `showContext`, `hideContext`                    | `openContext`, `clickContext`, `closeContext` |
| Input dialog  | `openDialog`, `closeInputDialog`                | `inputData` |
| Alert dialog  | `sendAlert`, `closeAlertDialog`                 | `closeAlert` |
| Progress      | `progress`, `circleProgress`, `progressCancel`  | `progressComplete` |
| TextUI        | `textUi`, `textUiHide`                          | — |
| Skill check   | `startSkillCheck`, `skillCheckCancel`           | `skillCheckOver` |
| Radial menu   | `openRadialMenu`                                | `radialClick`, `radialBack`, `radialClose` |
| List menu     | `setMenu`, `closeMenu`                          | `confirmSelected`, `changeSelected`, `changeIndex`, `changeChecked`, `closeMenu` |
| System bridge | `setLocale`, `setClipboard`                     | `init` |

## Notes

- Fonts load from Google Fonts CDN (works in CEF with internet). For fully
  offline-proof rendering, self-host via `@fontsource` later.
- `web/build/` is the legacy official bundle, kept only as a backup; it is no
  longer referenced by the manifest and can be deleted.
