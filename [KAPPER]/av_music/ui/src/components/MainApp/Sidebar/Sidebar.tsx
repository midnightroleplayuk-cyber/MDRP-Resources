import { Stack, UnstyledButton, Text, Divider } from "@mantine/core";
import { LayoutGrid, ListMusic, Radio, ListOrdered } from "lucide-react";
import { useAtom, useAtomValue } from "jotai";
import { viewAtom, Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";

const NAV_LINKS = [
  { label: "Browse", key: "browse", icon: LayoutGrid },
  { label: "Playlists", key: "playlists", icon: ListMusic },
  { label: "Radio", key: "radio", icon: Radio },
  { label: "Queue", key: "queue", icon: ListOrdered },
] as const;

export const Sidebar = () => {
  const [view, setView] = useAtom(viewAtom);
  const lang: any = useAtomValue(Lang);

  return (
    <Stack className={classes.sidebar} gap={2} mt={8}>
      <Text className={classes.sidebarSectionLabel}>
        {lang.sidebar_discover ?? "DISCOVER"}
      </Text>
      <Divider className={classes.sidebarDivider} />
      {NAV_LINKS.map(({ label, key, icon: Icon }) => (
        <UnstyledButton
          key={key}
          className={`${classes.navLink} ${view === key ? classes.navLinkActive : ""}`}
          onClick={() => setView(key)}
        >
          <Icon size={15} />
          {lang[`sidebar_${key}`] ?? label}
        </UnstyledButton>
      ))}
    </Stack>
  );
};
