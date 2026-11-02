import { Profile } from "../../types/types";
import { Box, Image } from "@mantine/core";
import classes from "./style.module.css";
import { IMG_TOKEN } from "../../Api/hosts";

export const fmtTime = (iso: string | number, yesterday: string) => {
  if (!iso) return "";
  const d =
    typeof iso === "number" ? new Date(iso) : new Date(iso.replace(" ", "T"));
  if (isNaN(d.getTime())) return "";
  const now = new Date();
  if (d.toDateString() === now.toDateString())
    return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  const y = new Date(now);
  y.setDate(now.getDate() - 1);
  if (d.toDateString() === y.toDateString()) return yesterday;
  return d.toLocaleDateString([], { day: "2-digit", month: "short" });
};

export const replySubject = (subject?: string) => {
  const s = (subject || "").trim();
  if (!s) return "RE: ";
  return /^re:/i.test(s) ? s : "RE: " + s;
};

export const fwdSubject = (subject?: string) => {
  const s = (subject || "").trim();
  if (!s) return "FW: ";
  return /^(fw|fwd):/i.test(s) ? s : "FW: " + s;
};

export const fmtFull = (iso: string | number) => {
  const d =
    typeof iso === "number"
      ? new Date(iso)
      : new Date(String(iso).replace(" ", "T"));
  return isNaN(d.getTime()) ? "" : d.toLocaleString();
};

export type ComposePrefill = {
  to?: string;
  subject?: string;
  body?: string;
  forwardOf?: number;
};

export const Avatar = ({
  profile,
  size = 40,
}: {
  profile: Profile | null;
  size?: number;
}) => {
  const initials = (profile?.displayName || "?").slice(0, 1).toUpperCase();
  return (
    <Box className={classes.avatar} style={{ width: size, height: size }}>
      {profile?.avatar ? (
        <Image
          src={profile.avatar}
          alt={initials}
          w="100%"
          h="100%"
          fit="cover"
        />
      ) : (
        initials
      )}
    </Box>
  );
};

type Seg = { type: "text"; value: string } | { type: "img"; url: string };
export const parse = (body: string): Seg[] => {
  const segs: Seg[] = [];
  const re = new RegExp(IMG_TOKEN.source, "gi");
  let last = 0;
  let m: RegExpExecArray | null;
  while ((m = re.exec(body)) !== null) {
    if (m.index > last)
      segs.push({ type: "text", value: body.slice(last, m.index) });
    segs.push({ type: "img", url: m[1] });
    last = m.index + m[0].length;
  }
  if (last < body.length) segs.push({ type: "text", value: body.slice(last) });
  return segs;
};
