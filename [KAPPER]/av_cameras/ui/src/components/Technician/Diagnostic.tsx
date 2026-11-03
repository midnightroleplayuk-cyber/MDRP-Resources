import { useState, useEffect } from "react";
import {
  Modal,
  Text,
  Button,
  Group,
  Stack,
  Badge,
  Center,
  ThemeIcon,
  Loader,
  Progress,
  Box,
} from "@mantine/core";
import {
  Wifi,
  Camera,
  BatteryWarning,
  Wrench,
  CheckCircle,
  AlertTriangle,
  ScanSearch,
} from "lucide-react";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";

interface DiagnosticProps {
  identifier: string;
  onClose: () => void;
}

export const Diagnostic = ({ identifier, onClose }: DiagnosticProps) => {
  const lang: any = useAtomValue(Lang);
  const [status, setStatus] = useState<
    "idle" | "connecting" | "analyzing" | "result" | "fixing" | "fixed"
  >("idle");
  const [progress, setProgress] = useState(0);
  const [issue, setIssue] = useState<"battery" | "damaged" | null>(null);

  useEffect(() => {
    let interval: ReturnType<typeof setInterval>;

    if (status === "analyzing") {
      interval = setInterval(() => {
        setProgress((prev) => {
          const nextProgress = prev + Math.floor(Math.random() * 10) + 2;
          if (nextProgress >= 100) {
            clearInterval(interval);
            setStatus(issue ? "result" : "fixed");
            return 100;
          }
          return nextProgress;
        });
      }, 150);
    } else if (status === "fixing") {
      interval = setInterval(() => {
        setProgress((prev) => {
          const nextProgress = prev + 1;
          if (nextProgress >= 100) {
            clearInterval(interval);
            setStatus("fixed");
            fetchNui("av_cameras", "finishFix", identifier);
            return 100;
          }
          return nextProgress;
        });
      }, 100);
    }

    return () => clearInterval(interval);
  }, [status, issue, identifier]);

  const handleStart = async () => {
    setStatus("connecting");
    try {
      const res = await fetchNui("av_cameras", "runDiagnostic", identifier);
      setIssue(res === "ok" ? null : res);
    } catch (e) {
      setIssue(Math.random() > 0.5 ? "battery" : "damaged");
    }
    setStatus("analyzing");
    setProgress(0);
  };

  const handleFix = async () => {
    try {
      const canFix = await fetchNui("av_cameras", "fixCamera", {
        identifier: identifier,
        status: issue,
      });

      if (canFix) {
        setStatus("fixing");
        setProgress(0);
      }
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <Modal
      opened
      onClose={onClose}
      centered
      withCloseButton={false}
      size={450}
      padding="lg"
      radius="md"
      classNames={{
        content: "content",
        body: "body",
      }}
    >
      <Stack gap="lg">
        <Group justify="space-between">
          <Group gap="sm">
            <ThemeIcon variant="light" color="var(--text-dim)" size="md">
              <Camera size={16} />
            </ThemeIcon>
            <Box>
              <Text
                fw={700}
                fz="md"
                ff="var(--font-display)"
                tt="uppercase"
                lts={1}
                lh={1.2}
              >
                Diagnostic
              </Text>
            </Box>
          </Group>
          <Badge
            color={
              status === "fixed"
                ? "var(--success)"
                : status === "result"
                  ? "var(--danger)"
                  : "var(--accent)"
            }
            variant="dot"
            size="md"
          >
            {status.toUpperCase()}
          </Badge>
        </Group>

        <Center
          mih={180}
          bg="var(--bg-panel)"
          style={{
            borderRadius: "var(--border-radius-base, 8px)",
            border: "solid 1px var(--border)",
          }}
          p="lg"
        >
          {status === "idle" && (
            <Stack align="center" gap="xs">
              <ScanSearch size={48} color="var(--text-dim)" />
              <Text c="var(--text-dim)" fz="sm" ta="center">
                Waiting for user input.
              </Text>
            </Stack>
          )}

          {status === "connecting" && (
            <Stack align="center" gap="xs">
              <Loader color="var(--accent)" type="bars" size="sm" />
              <Group gap="xs">
                <Wifi size={16} color="var(--accent)" />
                <Text fz="sm" fw={500} c="var(--accent)">
                  Establishing secure connection...
                </Text>
              </Group>
            </Stack>
          )}

          {(status === "analyzing" || status === "fixing") && (
            <Stack w="100%" gap="xs">
              <Group justify="space-between" align="flex-end">
                <Text
                  fz="xs"
                  fw={600}
                  tt="uppercase"
                  lts={1}
                  c="var(--text-dim)"
                >
                  {status === "analyzing"
                    ? lang.connecting_to_camera
                    : lang.applying_patches}
                </Text>
                <Text
                  fz="xl"
                  fw={800}
                  ff="var(--font-display)"
                  c={status === "analyzing" ? "var(--accent)" : "var(--yellow)"}
                  lh={1}
                >
                  {progress}%
                </Text>
              </Group>
              <Progress.Root size="xs" radius="xl" bg="rgba(0, 0, 0, 0.4)">
                <Progress.Section
                  value={progress}
                  color={
                    status === "analyzing" ? "var(--accent)" : "var(--yellow)"
                  }
                />
              </Progress.Root>
            </Stack>
          )}

          {status === "result" && issue && (
            <Stack align="center" gap="xs">
              <ThemeIcon
                size={56}
                radius="xl"
                color={issue === "battery" ? "var(--yellow)" : "var(--danger)"}
                variant="light"
              >
                {issue === "battery" ? (
                  <BatteryWarning size={32} />
                ) : (
                  <AlertTriangle size={32} />
                )}
              </ThemeIcon>
              <Text
                fz="lg"
                fw={700}
                c={issue === "battery" ? "var(--yellow)" : "var(--danger)"}
                ff="var(--font-display)"
                tt="uppercase"
                lts={1}
              >
                {issue === "battery"
                  ? lang.battery_depleted
                  : lang.hardware_damaged}
              </Text>
              <Text c="var(--text-dim)" fz="xs" ta="center">
                {issue === "battery"
                  ? lang.battery_depleted_desc
                  : lang.hardware_damaged_desc}
              </Text>
            </Stack>
          )}
          {status === "fixed" && (
            <Stack align="center" gap="xs">
              <ThemeIcon
                size={56}
                radius="xl"
                color="var(--success)"
                variant="light"
              >
                <CheckCircle size={32} />
              </ThemeIcon>
              <Text
                fz="lg"
                fw={700}
                c="var(--success)"
                ff="var(--font-display)"
                tt="uppercase"
                lts={1}
              >
                {lang.system_restored}
              </Text>
              <Text c="var(--text-dim)" fz="xs" ta="center">
                {lang.system_restored_desc}
              </Text>
            </Stack>
          )}
        </Center>

        {status === "idle" && (
          <Button
            fullWidth
            onClick={handleStart}
            leftSection={<ScanSearch size={16} />}
            color="var(--accent)"
            variant="light"
          >
            {lang.start_diagnostic}
          </Button>
        )}

        {status === "result" && (
          <Button
            fullWidth
            color="var(--yellow)"
            variant="light"
            onClick={handleFix}
            leftSection={<Wrench size={16} />}
          >
            {lang.fix_issue}
          </Button>
        )}
      </Stack>
    </Modal>
  );
};
