import { useState, useEffect } from "react";
import {
  Box,
  Group,
  Text,
  Grid,
  TextInput,
  Button,
  Flex,
  Card,
  ScrollArea,
} from "@mantine/core";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { ApiLogs } from "../../../API/settings";
import { IconBrandDiscord } from "@tabler/icons-react";
import classes from "./style.module.css";
import global from "../../../global.module.css";

interface LogsType {
  value: string;
  label: string;
  description: string;
}

const Settings = () => {
  const { settings: lang = {} }: any = useAtomValue(Lang);
  const [logs, setLogs] = useState<LogsType[]>([]);
  const [loaded, setLoaded] = useState(false);
  const icon = <IconBrandDiscord style={{ width: "16px", height: "16px" }} />;

  const handleUpdate = (value: string, input: string) => {
    setLogs((prevLogs) =>
      prevLogs.map((log) =>
        log.value === value ? { ...log, webhook: input } : log,
      ),
    );
  };
  const handleSave = (value: string) => {
    const field: any = logs.find((log) => log.value === value);
    if (field) {
      fetchNui("av_business", "saveWebhook", {
        type: field.value,
        webhook: field.webhook,
      });
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getLogs");
      if (resp) {
        setLogs(resp);
      } else {
        if (isEnvBrowser()) setLogs(ApiLogs);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      <Group
        bg="var(--bg-card)"
        p="sm"
        style={{
          borderRadius: "6px",
          border: "solid 1px var(--border)",
        }}
      >
        <Flex gap="xs" direction="column">
          <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
        </Flex>
      </Group>
      <ScrollArea
        offsetScrollbars
        h={`calc(100% - 70px)`}
        type="hover"
        scrollbars="y"
        scrollbarSize={6}
        mt="md"
      >
        <Grid>
          {logs.map((log: any) => (
            <Grid.Col key={log.value} span={{ base: 4, sm: 6, lg: 3 }}>
              <Card className={classes.card} mah={230}>
                <Text fw={500} c="var(--text-main)">
                  {log.label}
                </Text>
                <Box h={60} style={{ overflow: "auto", overflowX: "hidden" }}>
                  <Text fz="xs" c="var(--text-dim)">
                    {log.description}
                  </Text>
                </Box>
                <TextInput
                  classNames={global}
                  leftSectionPointerEvents="none"
                  leftSection={icon}
                  c="var(--text-dim)"
                  label={<Text fz="xs">{lang.webhook}</Text>}
                  placeholder={lang.placeholder}
                  value={log.webhook ? log.webhook : null}
                  onChange={(e) => {
                    handleUpdate(log.value, e.target.value);
                  }}
                  size="xs"
                />
                <Button
                  className={classes.button}
                  display="block"
                  ml={"auto"}
                  mr={"auto"}
                  mt="xs"
                  size="xs"
                  variant="filled"
                  w={"100%"}
                  ta="center"
                  onClick={() => {
                    handleSave(log.value);
                  }}
                >
                  {lang.save}
                </Button>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Settings;
