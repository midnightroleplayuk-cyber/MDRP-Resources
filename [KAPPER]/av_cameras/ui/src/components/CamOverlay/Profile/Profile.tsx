import { useState, useEffect } from "react";
import { Box, Flex, Text, Image, Transition } from "@mantine/core";
import { User, Car, ShieldAlert } from "lucide-react";
import classes from "./style.module.css";

interface TargetData {
  type: "ped" | "vehicle" | "player";
  model: string;
  citizenId?: string;
  netId: number;
  entity: number;
  mugshot?: string;
  mugshotUrl?: string;
  plates?: string;
}

export function TargetProfile() {
  const [active, setActive] = useState(false);
  const [data, setData] = useState<TargetData | null>(null);
  const [windowSize, setWindowSize] = useState({
    w: window.innerWidth,
    h: window.innerHeight,
  });

  useEffect(() => {
    const handleResize = () =>
      setWindowSize({ w: window.innerWidth, h: window.innerHeight });
    window.addEventListener("resize", handleResize);

    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "showProfile") {
        const targetData = event.data.data;

        if (targetData.mugshot) {
          targetData.mugshotUrl = `https://nui-img/${targetData.mugshot}/${targetData.mugshot}?t=${Date.now()}`;
        }

        setData(targetData);
        setActive(false);
        setTimeout(() => setActive(true), 50);
      } else if (event.data.action === "hideProfile") {
        setActive(false);
      }
    };

    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("resize", handleResize);
      window.removeEventListener("message", handleMessage);
    };
  }, []);

  if (!data) return null;

  const isPed = data.type === "ped" || data.type === "player";
  const centerX = windowSize.w / 2;
  const centerY = windowSize.h / 2;
  const endX = windowSize.w * 0.55;
  const endY = windowSize.h * 0.35 + 15;
  const cornerX = endX - 30;

  return (
    <Transition
      mounted={active}
      transition="fade"
      duration={200}
      timingFunction="ease"
    >
      {(styles) => (
        <Box className={classes.container} style={styles}>
          <Box className={classes.svgOverlay}>
            <svg width="100%" height="100%">
              <polyline
                points={`${centerX},${centerY} ${cornerX},${endY} ${endX},${endY}`}
                className={`${classes.connectionLine} ${active ? classes.lineActive : ""}`}
              />
            </svg>
          </Box>
          <Box
            className={`${classes.targetCard} ${active ? classes.targetCardActive : ""}`}
          >
            <Flex className={classes.cardHeader} align="center" gap={8}>
              {isPed ? (
                <User size={14} color="#fff" />
              ) : (
                <Car size={14} color="#fff" />
              )}
              <Text
                size="0.75rem"
                c="white"
                fw={600}
                className={classes.headerTitle}
              >
                {isPed ? "SUBJECT RECORD" : "VEHICLE REGISTRY"}
              </Text>
            </Flex>
            <Flex p={15} gap={15}>
              <Box className={classes.mugshotContainer}>
                <Image
                  w={75}
                  h={75}
                  p={isPed ? 0 : 5}
                  src={
                    data.mugshotUrl ||
                    `https://docs.fivem.net/vehicles/${data.model}.webp`
                  }
                  fallbackSrc="./vehicle_default.png"
                  className={classes.mugshot}
                />
                <Box className={classes.mugshotOverlay} />
              </Box>
              <Flex direction="column" gap={10} flex={1} justify="center">
                <Flex direction="column">
                  <Text
                    fz="sm"
                    c="rgba(255, 255, 255, 0.6)"
                    tt="uppercase"
                    className={classes.infoLabel}
                  >
                    {isPed ? "CITIZEN ID" : "PLATES"}
                  </Text>
                  <Text
                    fz="xs"
                    fw={500}
                    c="white"
                    className={classes.infoValue}
                  >
                    {isPed ? data.citizenId || data.netId : data.plates}
                  </Text>
                </Flex>

                <Flex direction="column">
                  <Flex align="center" gap={6}>
                    <ShieldAlert size={12} color="rgba(255, 255, 255, 0.6)" />
                    <Text
                      fz="sm"
                      c="rgba(255, 255, 255, 0.6)"
                      tt="uppercase"
                      className={classes.infoLabel}
                    >
                      THREAT LEVEL
                    </Text>
                  </Flex>
                  <Text
                    fz="xs"
                    fw={500}
                    c="white"
                    className={classes.infoValue}
                  >
                    None
                  </Text>
                </Flex>
              </Flex>
            </Flex>
          </Box>
        </Box>
      )}
    </Transition>
  );
}
