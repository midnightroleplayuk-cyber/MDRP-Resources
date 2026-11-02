import { useState, useEffect } from "react";
import { Box, Slider, Text, Group, Title, Button, Stack } from "@mantine/core";
import { InputInfo } from "../types/types";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { Loading } from "../components/Loading";
import classes from "./style.module.css";

interface Properties {
  data: InputInfo;
  show: (state: boolean) => void;
}

function convertToPercentage(value: number, min: number, max: number): number {
  const clampedValue = Math.min(Math.max(value, min), max);
  const range = max - min;
  const positiveValue = clampedValue - min;
  const percentage = (positiveValue / range) * 100;
  return Math.round(percentage);
}

const Inputs = ({ data, show }: Properties) => {
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [outputs, setOutputs] = useState(data.inputs);
  const handleValue = (field: string, value: number) => {
    const copy = outputs?.map((output) => {
      if (output.key === field) {
        return {
          ...output,
          value: value,
          valueLabel: convertToPercentage(value, output.min, output.max),
        };
      }
      return output;
    });
    setOutputs(copy);
  };

  const handleSave = () => {
    setOutputs((prevOutputs) => {
      if (!prevOutputs) return [];
      const allMax = prevOutputs.every((item) => item.value === item.max);
      const updatedOutputs = prevOutputs.map((item) => ({
        ...item,
        value: allMax
          ? item.min
          : item.value !== undefined
          ? item.value
          : item.min,
      }));
      const results = updatedOutputs.map((item) => ({
        key: item.key,
        value: item.value !== undefined ? item.value : item.min,
      }));
      fetchNui("av_drugs", "results", results);
      show(false);
      return updatedOutputs;
    });
  };

  const handleClose = () => {
    fetchNui("av_drugs", "results", false);
    show(false);
  };
  useEffect(() => {
    const updated = data?.inputs?.map((item) => ({
      ...item,
      value: item.min ? item.min : 0,
    }));
    setOutputs(updated);
    setLoaded(true);
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Box className={classes.container}>
      <Box className={classes.box} p="md">
        <Title order={1}>{data.title}</Title>
        <Text fz="xs" c="dimmed" mt={3}>
          {data.description}
        </Text>
        <Box className={classes.divider} />
        <Stack
          mt="sm"
          mah={"50vh"}
          style={{ overflowY: "auto", overflowX: "hidden" }}
        >
          {outputs?.map((input) => (
            <Box className={classes.inputBox} key={input.key}>
              <Group justify="space-between">
                <Text fw={500} fz="sm">
                  {input.label}
                </Text>
                <Text fw={500} fz="xs">
                  {input.valueLabel ? input.valueLabel : 0}%
                </Text>
              </Group>
              <Text c="dimmed" fz="xs">
                {input.description}
              </Text>
              <Slider
                mt={"xs"}
                showLabelOnHover={false}
                defaultValue={input.min}
                label={null}
                min={input.min}
                max={input.max}
                size="xs"
                color={input.color ? input.color : "cyan.2"}
                onChange={(e) => {
                  handleValue(input.key, e);
                }}
                step={1}
              />
            </Box>
          ))}
        </Stack>
        <Group mt="sm" w="100%">
          <Button
            ml="auto"
            size="xs"
            variant="transparent"
            color="red"
            onClick={handleClose}
          >
            Cancel
          </Button>
          <Button size="xs" color="cyan.9" radius={4} onClick={handleSave}>
            Start Cooking
          </Button>
        </Group>
      </Box>
    </Box>
  );
};

export default Inputs;
