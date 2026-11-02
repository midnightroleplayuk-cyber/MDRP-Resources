import { Tabs } from "@mantine/core";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../reducers/atoms";

interface Properties {
  type: string;
  setType: (option: string) => void;
}

export const Header = ({ type, setType }: Properties) => {
  const { admin: lang }: any = useRecoilValue(Lang);
  return (
    <Tabs
      classNames={classes}
      defaultValue="tables"
      value={type}
      onChange={(e) => {
        if (!e) return;
        setType(e);
      }}
      allowTabDeactivation={false}
    >
      <Tabs.List>
        <Tabs.Tab value="tables">{lang.tables_tab}</Tabs.Tab>
        <Tabs.Tab value="labs">{lang.labs_tab}</Tabs.Tab>
        <Tabs.Tab value="players">{lang.players_tab}</Tabs.Tab>
        <Tabs.Tab value="zones">{lang.zones_tab}</Tabs.Tab>
      </Tabs.List>
    </Tabs>
  );
};
