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
import { fetchNui } from "../../hooks/useNuiEvents";
import { getDate } from "../../hooks/getDate";
import useFormattedDateTime from "../../hooks/formatDate";
import classes from "../style.module.css";
import { IconCopy } from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

export const Info = ({ table, handleDelete }: any) => {
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
          <Text fz="sm" fw={600}>{`${table.identifier}`}</Text>
          <ActionIcon
            size="xs"
            variant="transparent"
            onClick={() => {
              fetchNui("av_drugs", "copy", table.identifier);
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
              x: table.position.x,
              y: table.position.y,
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
              handleDelete(table.identifier);
            }}
          >
            {lang.delete_button}
          </Button>
        </Group>
      </Group>
      <Grid mt="xs" grow>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Group gap="xs">
              <Text fz="sm" fw={600}>
                {lang.owner}
              </Text>
              <ActionIcon
                size="xs"
                variant="transparent"
                onClick={() => {
                  fetchNui("av_drugs", "copy", table.owner);
                }}
              >
                <IconCopy style={iconStyle} />
              </ActionIcon>
            </Group>
            <Text
              fz="xs"
              c="gray.6"
              style={{
                cursor: "pointer",
              }}
            >
              {table.owner}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.last_cook}
            </Text>
            <Text fz="xs" c="gray.6">
              {getDate(table.lastCook, table.now)}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.table_type}
            </Text>
            <Text fz="xs" c="gray.6">
              {table.itemName}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.highest_purity}
            </Text>
            <Text fz="xs" c="gray.6">
              {table.highestPurity ? `${table.highestPurity}%` : `N/A`}
            </Text>
          </Card>
        </Grid.Col>
        <Grid.Col span={3}>
          <Card className={classes.card}>
            <Text fz="sm" fw={500}>
              {lang.placed}
            </Text>
            <Text
              fz="xs"
              c="gray.6"
              style={{
                cursor: "pointer",
              }}
            >
              {useFormattedDateTime(table.placed)}
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
                fetchNui("av_drugs", "tp", table.position);
              }}
            >
              {`x:${Math.floor(table.position.x)}, y: ${Math.floor(
                table.position.y
              )}, z: ${Math.floor(table.position.z)}`}
            </Text>
          </Card>
        </Grid.Col>
      </Grid>
    </Box>
  );
};
