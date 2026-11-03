import { Stack, Group, Box, Progress, Text, ScrollArea } from "@mantine/core";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

const calculateProgress = (
  xp: number
): { level: number | string; progress: number } => {
  const level = Math.floor(xp / 100);
  const xpForNextLevel = xp % 100;
  const progress = (xpForNextLevel / 100) * 100;
  return { level, progress };
};

interface DrugType {
  label: string;
  xp: number;
  name: string;
  color: string;
  sold: number;
  income: number;
}

interface Properties {
  allDrugs: DrugType[];
}

export const DrugStats = ({ allDrugs }: Properties) => {
  const { app: lang }: any = useRecoilValue(Lang);
  if (!allDrugs[0])
    return (
      <div
        style={{
          position: "relative",
          display: "flex",
          width: "100%",
          textAlign: "center",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <Text c="dimmed" fz="sm" fw={500} opacity={0.75}>
          {lang.empty}
        </Text>
      </div>
    );
  return (
    <ScrollArea
      className={classes.scroll}
      type="hover"
      scrollbars="y"
      offsetScrollbars
      scrollbarSize={7}
    >
      <Stack gap="xs">
        {allDrugs.map((drug) => (
          <Box key={drug.name} className={classes.box} p="sm">
            <Group justify="space-between">
              <Text fz="md" fw={500} c="gray">
                {drug.label}
              </Text>
              <Text fz="sm" fw={500} c="gray.3">
                {`${lang.level} ${calculateProgress(drug.xp).level}`}
              </Text>
            </Group>
            <Progress
              value={calculateProgress(drug.xp).progress}
              color={drug.color ? drug.color : "cyan.3"}
              radius={2}
              size={"xs"}
              mt={"xs"}
            />
            <Group mt="xs">
              <Group
                gap={3}
                display="flex"
                fz="xs"
                ml="auto"
                c="gray.5"
                fw={500}
              >
                <Text fz="xs" fw={600} c="gray">
                  {`${lang.bags_sold}:`}
                </Text>{" "}
                {drug.sold ? drug.sold : `0`}
              </Group>
              <Group gap={3} display="flex" fz="xs" c="gray.5" fw={500}>
                <Text fz="xs" fw={600} c="gray">
                  {`${lang.generated}:`}
                </Text>{" "}
                {drug.income ? `$${drug.income.toLocaleString("en-US")}` : `$0`}
              </Group>
            </Group>
          </Box>
        ))}
      </Stack>
    </ScrollArea>
  );
};
