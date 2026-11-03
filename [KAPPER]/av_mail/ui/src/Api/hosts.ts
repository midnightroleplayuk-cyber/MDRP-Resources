const hostOf = (url: string): string | null => {
  const m = /^https:\/\/([^/]+)/i.exec((url || "").trim());
  if (!m) return null;
  return m[1].toLowerCase().replace(/:\d+$/, "");
};

export const isAllowedHost = (url: string, hosts?: string[]): boolean => {
  const host = hostOf(url);
  if (!host) return false;
  for (const raw of hosts || []) {
    const allowed = String(raw).toLowerCase();
    if (!allowed) continue;
    if (host === allowed || host.endsWith("." + allowed)) return true;
    if (!allowed.includes(".") && host.split(".").includes(allowed)) return true;
  }
  return false;
};

export const IMG_TOKEN = /\[img\]\s*(.*?)\s*\[\/img\]/gi;

export const countBodyImages = (body: string): number => {
  const m = (body || "").match(IMG_TOKEN);
  return m ? m.length : 0;
};
