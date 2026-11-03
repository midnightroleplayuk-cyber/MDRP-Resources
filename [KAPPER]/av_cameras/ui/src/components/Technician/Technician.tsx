import { useState } from "react";
import { Box, Flex, Group, Text, UnstyledButton } from "@mantine/core";
import { Scan, Plus, Router } from "lucide-react";
import { Installation } from "./Installation";
import { CamList } from "./CamList";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const TechnicianApp = () => {
  const [activeTab, setActiveTab] = useState<"scan" | "install">("scan");
  const lang: any = useAtomValue(Lang);
  return (
    <Box className={classes.wrapper}>
      <Box className={classes.header}>
        <Group gap="sm">
          <Router size={21} color="var(--accent)" />
          <Text
            ff="var(--font-display)"
            fz="lg"
            fw={700}
            c="var(--text-main)"
            lts="2px"
          >
            CAM TECH TERMINAL
          </Text>
        </Group>
      </Box>
      <Flex className={classes.mainArea}>
        <Box className={classes.sidebar}>
          <UnstyledButton
            className={`${classes.navButton} ${
              activeTab === "scan" ? classes.navButtonActive : ""
            }`}
            onClick={() => setActiveTab("scan")}
          >
            <Scan size={18} />
            {lang.scanner_tab}
          </UnstyledButton>

          <UnstyledButton
            className={`${classes.navButton} ${
              activeTab === "install" ? classes.navButtonActive : ""
            }`}
            onClick={() => setActiveTab("install")}
          >
            <Plus size={18} />
            {lang.installation_tab}
          </UnstyledButton>
        </Box>
        <Box className={classes.contentArea}>
          {activeTab === "scan" && <CamList />}
          {activeTab === "install" && <Installation />}
        </Box>
      </Flex>
    </Box>
  );
};
