import {
  ActionIcon,
  Box,
  Button,
  Grid,
  Group,
  Stack,
  Text,
  Flex,
  Tooltip,
} from "@mantine/core";
import {
  Activity,
  BatteryCharging,
  Wrench,
  Trash2,
  UserPlus,
} from "lucide-react";
import { useState } from "react";
import { CameraType, ModalType } from "../../types/types";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { ApiCameras } from "../../Api/Cameras";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { Diagnostic } from "./Diagnostic";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const CamList = () => {
  const lang: any = useAtomValue(Lang);
  const [scannedList, setScannedList] = useState<CameraType[]>(
    isEnvBrowser() ? ApiCameras : [],
  );
  const [isScanning, setIsScanning] = useState(false);
  const [modal, setModal] = useState<ModalType>({
    state: false,
  });
  const [selected, setSelected] = useState<string | null>(null);

  useNuiEvent("refreshScanner", () => {
    handleScan();
  });

  useNuiEvent("updateCamera", (camera: CameraType) => {
    setScannedList((c) =>
      c.map((x) => (x.identifier === camera.identifier ? camera : x)),
    );
  });

  const handleDelete = async (identifier: string) => {
    const resp = await fetchNui("av_cameras", "deleteTechnician", identifier);
    if (!resp) return;
    setScannedList((c) => c.filter((x) => x.identifier !== identifier));
  };

  const handleCallback = (data: any) => {
    setModal({ state: false });
    if (!data) return;
    const { identifier } = data.extraData;
    fetchNui("av_cameras", "assignCamera", {
      identifier,
      playerId: data.playerId,
    });
  };

  const handleAssign = (camera: CameraType) => {
    setModal({
      state: true,
      info: {
        title: lang.assign_camera,
        options: [
          {
            type: "info",
            description: lang.assign_camera_desc,
            size: "xs",
          },
          {
            type: "number",
            title: lang.player_id,
            name: "playerId",
            min: 1,
            max: 99999,
            asterisk: true,
            decimal: false,
          },
        ],
        extraData: {
          action: "assign",
          identifier: camera.identifier,
        },
        button: lang.assign,
      },
    });
  };

  const handleScan = async () => {
    setIsScanning(true);
    const resp =
      (await fetchNui("av_cameras", "scanner")) ||
      (isEnvBrowser() ? ApiCameras : []);

    setTimeout(
      () => {
        if (resp) {
          const sortedData = [...resp].sort((a, b) => {
            const getPriority = (status: string) => {
              if (status === "unassigned") return 2;
              if (status === "support-needed") return 1;
              return 0;
            };

            const prioA = getPriority(a.status);
            const prioB = getPriority(b.status);

            if (prioA !== prioB) {
              return prioB - prioA;
            }

            const distA = a.distance
              ? parseFloat(String(a.distance))
              : Infinity;
            const distB = b.distance
              ? parseFloat(String(b.distance))
              : Infinity;

            return distA - distB;
          });
          setScannedList(sortedData);
        }
        setIsScanning(false);
      },
      isEnvBrowser() ? 1000 : 100,
    );
  };
  return (
    <Stack gap="xl">
      {modal.state && <ModalMenu data={modal} callback={handleCallback} />}
      {selected && (
        <Diagnostic identifier={selected} onClose={() => setSelected(null)} />
      )}
      <Group justify="space-between" align="center">
        <Box>
          <Text
            ff="var(--font-display)"
            fz="lg"
            fw={600}
            c="var(--text-main)"
            tt="uppercase"
            lts="1px"
          >
            {lang.local_frequency_scanner}
          </Text>
          <Text ff="var(--font-family)" fz="sm" c="var(--text-secondary)">
            {lang.detecting_broadcast_signals}
          </Text>
        </Box>
        <Button
          leftSection={<Activity size={16} />}
          loading={isScanning}
          onClick={handleScan}
          color="var(--accent)"
          variant="outline"
          lts={1}
          tt="uppercase"
          ff="var(--font-display)"
        >
          {lang.initiate_scan}
        </Button>
      </Group>
      <Grid>
        {scannedList.map((cam) => {
          let badgeClass = classes.statusLive;
          if (cam.status === "offline") badgeClass = classes.statusOffline;
          if (cam.owner === "unassigned") badgeClass = classes.statusUnassigned;
          if (cam.status === "support-needed")
            badgeClass = classes.statusSupportNeeded;
          const canInteract =
            cam.status === "support-needed" ||
            cam.status === "offline" ||
            cam.owner === "unassigned";
          const showExtendedActions =
            cam.status === "support-needed" || cam.owner === "unassigned";
          return (
            <Grid.Col span={4} key={cam.identifier}>
              <Box className={classes.card}>
                <Group justify="space-between" align="flex-start" mb="lg">
                  <Box>
                    <Text
                      ff="var(--font-display)"
                      fz="lg"
                      fw={600}
                      c="var(--text-main)"
                      truncate
                      maw={200}
                    >
                      {cam.label}
                    </Text>
                  </Box>
                  <Text
                    ff="var(--font-mono)"
                    fz="xs"
                    c="var(--accent)"
                    fw={600}
                  >
                    {cam.distance ? `${cam.distance}m` : lang.na}
                  </Text>
                </Group>
                <Group justify="space-between" align="center" mb="xl">
                  <Box className={`${classes.statusBadge} ${badgeClass}`}>
                    {cam.owner === "unassigned" ? lang.unassigned : cam.status}
                  </Box>
                  <Text
                    ff="var(--font-mono)"
                    fz="xs"
                    c={cam.battery > 20 ? "var(--success)" : "var(--danger)"}
                    fw={600}
                  >
                    {`${cam.battery}% ${lang.bat}`}
                  </Text>
                </Group>
                {canInteract ? (
                  <Group gap="xs" grow>
                    {cam.owner === "unassigned" ? (
                      <Tooltip
                        label={lang.assign_to_user}
                        withArrow
                        position="top"
                        bg="var(--tooltip)"
                        c="var(--text-main)"
                        fz="xs"
                      >
                        <ActionIcon
                          className={classes.actionIcon}
                          size="lg"
                          radius="md"
                          onClick={() => handleAssign(cam)}
                        >
                          <UserPlus size={16} />
                        </ActionIcon>
                      </Tooltip>
                    ) : (
                      (cam.status === "offline" ||
                        cam.status === "support-needed") && (
                        <Tooltip
                          label={lang.run_diagnostic}
                          withArrow
                          position="top"
                          bg="var(--tooltip)"
                          c="var(--text-main)"
                          fz="xs"
                        >
                          <ActionIcon
                            className={classes.actionIcon}
                            size="lg"
                            radius="md"
                            onClick={() => setSelected(cam.identifier)}
                            disabled={cam.distance ? cam.distance > 7.0 : false}
                          >
                            <Wrench size={16} />
                          </ActionIcon>
                        </Tooltip>
                      )
                    )}
                    {cam.type !== "server" && showExtendedActions && (
                      <>
                        <Tooltip
                          label={lang.remove_camera}
                          withArrow
                          position="top"
                          bg="var(--tooltip)"
                          c="var(--text-main)"
                          fz="xs"
                        >
                          <ActionIcon
                            className={classes.actionIcon}
                            size="lg"
                            radius="md"
                            color="red"
                            onDoubleClick={() => handleDelete(cam.identifier)}
                          >
                            <Trash2 size={16} />
                          </ActionIcon>
                        </Tooltip>
                      </>
                    )}
                  </Group>
                ) : (
                  <Flex
                    align="center"
                    justify="center"
                    h={38}
                    bg="rgba(0, 0, 0, 0.2)"
                    style={{
                      borderRadius: "var(--border-radius-sm)",
                      border: "1px dashed var(--border-mid)",
                    }}
                  >
                    <Text
                      ff="var(--font-mono)"
                      fz="10px"
                      c="var(--text-dim)"
                      tt="uppercase"
                      lts="1px"
                    >
                      {lang.not_flagged_for_support}
                    </Text>
                  </Flex>
                )}
              </Box>
            </Grid.Col>
          );
        })}
      </Grid>
    </Stack>
  );
};
