import { useState } from "react";
import {
  Box,
  Button,
  Group,
  TextInput,
  Text,
  Grid,
  Card,
  ActionIcon,
} from "@mantine/core";
import { IconCopy } from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import { fetchNui } from "../../hooks/useNuiEvents";
import { getDate } from "../../hooks/getDate";
import useFormattedDateTime from "../../hooks/formatDate";
import classes from "../style.module.css";

export const Info = ({ lab, handleDelete }: any) => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [sum, setSum] = useState("");
  const iconStyle = { width: "14px", height: "14px" };
  return (
    <Box
      p="sm"
      mt="xs"
      style={{
        border: "solid 1.25px rgba(255,255,255,0.1)",
        borderRadius: "4px",
      }}
    >
      <Group>
        <Group gap="xs">
          <Text fz="sm" fw={600}>{`${lab.identifier}`}</Text>
          <ActionIcon
            size="xs"
            variant="transparent"
            onClick={() => {
              fetchNui("av_drugs", "copy", lab.identifier);
            }}
          >
            <IconCopy style={iconStyle} />
          </ActionIcon>
        </Group>

        <Button
          size="xs"
          color="blue.2"
          variant="subtle"
          onClick={() => {
            fetchNui("av_drugs", "setGPS", {
              x: lab.coords.x,
              y: lab.coords.y,
            });
          }}
        >
          {lang.set_gps}
        </Button>
        <Group ml="auto">
          <TextInput
            classNames={classes}
            placeholder="2+2=?"
            size="xs"
            onChange={(e) => {
              setSum(e.target.value);
            }}
          />
          <Button
            size="xs"
            color="red.9"
            disabled={sum !== "4"}
            onClick={() => {
              handleDelete(lab.identifier);
            }}
          >
            {lang.delete_button}
          </Button>
        </Group>
      </Group>
      <Grid mt="xs" grow>
        <Grid.Col span={3}>
          <Card
            className={classes.card}
            onClick={() => {
              fetchNui("av_drugs", "copy", lab.owner);
            }}
          >
            <Text fz="sm" fw={500}>
              {lang.owner}
            </Text>
            <Text
              fz="xs"
              c="gray.6"
              style={{
                cursor: "pointer",
              }}
            >
              {lab.owner}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.last_cook}
            </Text>
            <Text fz="xs" c="gray.6">
              {getDate(lab.lastCook, lab.now)}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.lab_type}
            </Text>
            <Text fz="xs" c="gray.6">
              {lab.type}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.highest_purity}
            </Text>
            <Text fz="xs" c="gray.6">
              {lab.highestPurity ? `${lab.highestPurity}%` : `N/A`}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.created}
            </Text>
            <Text
              fz="xs"
              c="gray.6"
              style={{
                cursor: "pointer",
              }}
            >
              {useFormattedDateTime(lab.created)}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.exact_coords}
            </Text>
            <Text
              fz="xs"
              c="gray.6"
              style={{
                cursor: "pointer",
              }}
              onDoubleClick={() => {
                fetchNui("av_drugs", "tp", lab.coords);
              }}
            >
              {`x:${Math.floor(lab.coords.x)}, y: ${Math.floor(
                lab.coords.y
              )}, z: ${Math.floor(lab.coords.z)}`}
            </Text>
          </Card>
        </Grid.Col>
      </Grid>
    </Box>
  );
};
