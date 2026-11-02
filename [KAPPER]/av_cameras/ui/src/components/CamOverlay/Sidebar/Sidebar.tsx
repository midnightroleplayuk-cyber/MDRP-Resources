import { Box, Flex, Text } from "@mantine/core";
import { ChevronsLeft, ChevronsRight } from "lucide-react";
import { useEffect, useState } from "react";
import { Lang } from "../../../reducers/atoms";
import { useAtomValue } from "jotai";
import classes from "./style.module.css";

export const Sidebar = () => {
  const lang: any = useAtomValue(Lang);
  const controls = [
    { key: "SHIFT", desc: lang.toggle_cursor },
    { key: "ESC", desc: lang.exit_camera },
    { key: "WHEEL", desc: lang.zoom_in_out },
  ];

  const [pinned, setPinned] = useState(true);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Shift") {
        setPinned(false);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  return (
    <Box className={`${classes.sidebarWrap} ${pinned ? classes.pinned : ""}`}>
      <Box className={classes.sidebarHitbox}>
        {pinned ? (
          <ChevronsRight size={14} color="rgba(255,255,255,0.45)" />
        ) : (
          <ChevronsLeft size={14} color="rgba(255,255,255,0.45)" />
        )}
      </Box>
      <Box className={classes.sidebarContent}>
        <Text
          c="white"
          fz={11}
          fw={700}
          style={{ letterSpacing: "2px" }}
          mb={40}
        >
          {lang.camera_controls}
        </Text>
        <Flex direction="column" gap={20}>
          {controls.map((c) => (
            <Flex
              key={c.key}
              align="center"
              justify="space-between"
              pb={10}
              style={{ borderBottom: "1px solid rgba(255, 255, 255, 0.05)" }}
            >
              <Text className={classes.keyBadge}>{c.key}</Text>
              <Text
                c="rgba(255, 255, 255, 0.7)"
                fz={11}
                fw={500}
                style={{ letterSpacing: "0.5px" }}
              >
                {c.desc}
              </Text>
            </Flex>
          ))}
        </Flex>
      </Box>
    </Box>
  );
};
