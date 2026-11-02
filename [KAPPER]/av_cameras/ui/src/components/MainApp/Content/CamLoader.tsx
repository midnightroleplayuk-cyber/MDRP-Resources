import { Modal, Flex, Text, Loader, Group, Box } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Cctv } from "lucide-react";
import { useState, useEffect } from "react";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  cameraLabel: string;
}

export const CamLoader = ({ cameraLabel }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [dots, setDots] = useState("");

  useEffect(() => {
    const interval = setInterval(() => {
      setDots((prev) => (prev.length >= 3 ? "" : prev + "."));
    }, 400);

    return () => clearInterval(interval);
  }, []);

  return (
    <Modal
      opened
      onClose={() => {}}
      withCloseButton={false}
      centered
      size="sm"
      closeOnClickOutside={false}
      closeOnEscape={false}
      overlayProps={{
        backgroundOpacity: 0.85,
        blur: 4,
      }}
      zIndex={9999}
      styles={{
        content: {
          backgroundColor: "var(--bg-panel)",
          border: "1px solid var(--border)",
          borderRadius: "var(--border-radius-base)",
          boxShadow: "0 10px 30px rgba(0, 0, 0, 0.5)",
        },
        body: {
          padding: "24px",
        },
      }}
    >
      <Flex direction="column" gap="lg">
        <Group justify="space-between" align="center">
          <Group gap="sm">
            <Cctv size={18} color="var(--accent)" />
            <Text
              ff="var(--font-family)"
              fz="xs"
              c="var(--accent)"
              tt="uppercase"
              lts={2}
              fw={600}
            >
              {lang.connecting} {dots}
            </Text>
          </Group>
          <Loader size={14} color="var(--accent)" />
        </Group>
        <Box>
          <Text
            ff="var(--font-display)"
            fz="xs"
            c="var(--text-secondary)"
            tt="uppercase"
            lts={1}
            mb={4}
          >
            {lang.target_camera}
          </Text>
          <Text
            ff="var(--font-display)"
            fz="lg"
            fw={600}
            c="var(--text-main)"
            tt="uppercase"
            lts={1}
            mb={8}
          >
            {cameraLabel}
          </Text>
        </Box>
      </Flex>
    </Modal>
  );
};
