import { Card, Grid, Group, Text } from "@mantine/core";
import {
  IconFlask2Filled,
  IconStar,
  IconArrowUpRight,
} from "@tabler/icons-react";
import classes from "./../styles.module.css";
import { LabType } from "../../types/types";
import { getDate } from "../../hooks/getDate";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  lab: LabType;
}

export const Stats = ({ lab }: Properties) => {
  const { labs: lang }: any = useRecoilValue(Lang);
  const iconStyle = {
    width: "20px",
    height: "20px",
    marginLeft: "auto",
    color: "#a5d8ff",
  };
  return (
    <Grid mr="sm">
      <Grid.Col span={4}>
        <Card className={classes.card}>
          <Group>
            <Text fz="lg" fw={500}>
              {lang.last_cook}
            </Text>
            <IconFlask2Filled style={iconStyle} stroke={1.5} />
          </Group>
          <Text fz="md" c="gray.6">
            {getDate(lab.lastCook, lab.now)}
          </Text>
        </Card>
      </Grid.Col>
      <Grid.Col span={4}>
        <Card className={classes.card}>
          <Group>
            <Text fz="lg" fw={500} truncate>
              {lang.highest_purity}
            </Text>
            <IconStar style={iconStyle} stroke={1.5} />
          </Group>
          <Text fz="md" c="gray.6">
            {`${lab.highestPurity}%`}
          </Text>
        </Card>
      </Grid.Col>
      <Grid.Col span={4}>
        <Card className={classes.card}>
          <Group>
            <Text fz="lg" fw={500}>
              {lang.lab_level}
            </Text>
            <IconArrowUpRight style={iconStyle} stroke={1.5} />
          </Group>
          <Text fz="md" c="gray.6">
            {Math.floor(lab.xp / 100)}
          </Text>
        </Card>
      </Grid.Col>
    </Grid>
  );
};
