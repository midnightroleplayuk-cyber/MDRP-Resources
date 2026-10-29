// NUI localization: a thin reader over Lua's `locales/translations/*.lua`.
//
// There is ONE authored string table in this resource and it lives in Lua. The front
// end used to bundle a second copy (`strings.en.json`), which meant every new string
// had to be written twice and a translator had to be told about two files. Instead the
// table is fetched once at boot (`getLocale`, see modules/locale/client.lua) and every
// component localizes against it through `_L`.
//
// Placeholders stay `string.format` style (`%s`, `%d`) so a key reads identically
// whether it is used from Lua or from React.

import { fetchNui } from "./nui";

type Strings = Record<string, string>;

let strings: Strings = {};
let loaded = false;

/**
 * Pull the language table from Lua. Awaited ONCE before the app renders (see main.tsx)
 * so no component ever paints an unlocalized frame. Safe to call more than once.
 */
export async function loadLocale(): Promise<void> {
  if (loaded) return;
  const d = await fetchNui<{ ok?: boolean; strings?: Strings }>("getLocale", {});
  if (d?.ok && d.strings) strings = d.strings;
  loaded = true;
}

/** True once the table has arrived, so a caller can tell "missing key" from "not loaded yet". */
export function localeReady() {
  return loaded;
}

/**
 * Localize `key`, filling `string.format`-style `%s`/`%d` placeholders in order.
 * An unknown key returns the key itself, which makes a missing string obvious on screen
 * instead of rendering as a silent empty gap.
 */
export function _L(key: string, ...args: (string | number)[]): string {
  const template = strings[key] ?? key;
  let i = 0;
  // `%%` is a LITERAL percent, matching Lua's string.format. Both engines read the
  // same table now, so they have to agree on escaping: a value written for one side
  // must be safe on the other. Without this a bare `%` would be fine here and blow up
  // the moment the same key was used from Lua.
  return template.replace(/%%|%[sd]/g, (m) => {
    if (m === "%%") return "%";
    const v = args[i++];
    return v === undefined ? "" : String(v);
  });
}
