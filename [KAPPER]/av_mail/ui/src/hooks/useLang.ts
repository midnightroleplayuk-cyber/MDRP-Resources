import { useAtomValue } from "jotai";
import { Lang } from "../reducers/atoms";

type Params = Record<string, string | number>;

export function useT() {
  const lang = useAtomValue(Lang) as Record<string, any>;
  return (path?: string, params?: Params): string => {
    if (!path) return "";
    const value = path
      .split(".")
      .reduce<any>((acc, key) => (acc == null ? acc : acc[key]), lang);
    let out = typeof value === "string" ? value : path;
    if (params) {
      for (const key of Object.keys(params)) {
        out = out.split("{" + key + "}").join(String(params[key]));
      }
    }
    return out;
  };
}
