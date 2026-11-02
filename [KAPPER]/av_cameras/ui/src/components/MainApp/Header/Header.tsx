import {
  Group,
  Box,
  Flex,
  Text,
  TextInput,
  UnstyledButton,
} from "@mantine/core";
import { Search, LayoutGrid, Map } from "lucide-react";
import { ViewMode } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  view: ViewMode;
  setView: (view: ViewMode) => void;
  handleSearch: (query: string) => void;
}

export const Header = ({ view, setView, handleSearch }: Properties) => {
  const lang: any = useAtomValue(Lang);
  return (
    <Group className={classes.header} justify="space-between" wrap="nowrap">
      <Text fz={26} lts={3} lh={1} style={{ flexShrink: 0 }}>
        CAM<span style={{ color: "var(--accent)" }}>VISION</span>
      </Text>
      <Group
        wrap="nowrap"
        gap="md"
        style={{ flex: 1, justifyContent: "flex-end" }}
      >
        <TextInput
          classNames={{
            input: "input",
          }}
          size="sm"
          placeholder={lang["search"]}
          leftSection={<Search size={14} color="var(--text-dim)" />}
          onChange={(e) => handleSearch(e.currentTarget.value)}
        />
        <Box w={1} h={20} bg="var(--border-mid)" />
        <Flex
          gap={2}
          p={3}
          style={{
            background: "var(--bg-card)",
            border: "1px solid var(--border)",
            borderRadius: 4,
          }}
        >
          <UnstyledButton
            className={`${classes.vtBtn} ${view === "grid" ? classes.vtBtnActive : ""}`}
            onClick={() => setView("grid")}
          >
            <LayoutGrid size={13} />
            {lang["grid"]}
          </UnstyledButton>
          <UnstyledButton
            className={`${classes.vtBtn} ${view === "map" ? classes.vtBtnActive : ""}`}
            onClick={() => setView("map")}
          >
            <Map size={13} />
            {lang["map"]}
          </UnstyledButton>
        </Flex>
      </Group>
    </Group>
  );
};
