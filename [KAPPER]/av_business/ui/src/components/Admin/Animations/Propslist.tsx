import {
  Stack,
  Tooltip,
  Group,
  Text,
  ActionIcon,
  Grid,
  TextInput,
  NumberInput,
  Button,
  Divider,
  Accordion,
} from "@mantine/core";
import { IconTrash, IconPlus, IconProgressCheck } from "@tabler/icons-react";
import { AnimType, PropData } from "./api";
import { fetchNui } from "../../../hooks/useNuiEvents";
import global from "../../../global.module.css";
import { CraftingAction } from "../Crafting/api";

interface PropListProps {
  tempItem: any;
  updateField: (
    field: keyof AnimType | keyof CraftingAction,
    value: any,
  ) => void;
}

export const PropList = ({ tempItem, updateField }: PropListProps) => {
  const propsArray = Array.isArray(tempItem.prop)
    ? tempItem.prop
    : tempItem.prop
      ? [tempItem.prop]
      : [];

  const updateSpecificProp = (index: number, p: PropData) => {
    if (Array.isArray(tempItem.prop)) {
      const newProps = [...tempItem.prop];
      newProps[index] = p;
      updateField("prop", newProps);
    } else {
      updateField("prop", p);
    }
  };

  const addProp = () => {
    const newProp: PropData = {
      model: "",
      bone: 0,
      pos: { x: 0.0, y: 0.0, z: 0.0 },
      rot: { x: 0.0, y: 0.0, z: 0.0 },
    };
    updateField("prop", [...propsArray, newProp]);
  };

  const removeProp = (index: number) => {
    const filtered = propsArray.filter(
      (_: undefined, i: number) => i !== index,
    );
    updateField("prop", filtered.length > 0 ? filtered : null);
  };

  return (
    <Stack gap="md">
      <Group justify="space-between">
        <Text fz="xs" fw={700} c="var(--text-dim)">
          Animation Props
        </Text>
        <Button
          variant="light"
          size="compact-xs"
          leftSection={<IconPlus size={14} />}
          onClick={addProp}
        >
          Add Prop
        </Button>
      </Group>
      <Accordion defaultValue="" variant="default">
        {propsArray.map((p: any, index: number) => (
          <Accordion.Item key={index} value={`a${index}`}>
            <Accordion.Control>
              <Group justify="space-between">
                <Text fz="xs" fw={700} c="blue">
                  Prop #{index + 1}
                </Text>
                <ActionIcon
                  color="red"
                  variant="subtle"
                  size="sm"
                  onClick={() => removeProp(index)}
                >
                  <IconTrash size={16} />
                </ActionIcon>
              </Group>
            </Accordion.Control>
            <Accordion.Panel>
              <Grid gap="xs">
                <Grid.Col span={8}>
                  <TextInput
                    classNames={global}
                    label="Model"
                    size="xs"
                    value={p.model}
                    rightSection={
                      <Tooltip label="Verify asset" fz="xs" color="dark.6">
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          onClick={() =>
                            fetchNui("av_business", "verifyAsset", p.model)
                          }
                        >
                          <IconProgressCheck />
                        </ActionIcon>
                      </Tooltip>
                    }
                    onChange={(e) =>
                      updateSpecificProp(index, {
                        ...p,
                        model: e.currentTarget.value,
                      })
                    }
                  />
                </Grid.Col>
                <Grid.Col span={4}>
                  <NumberInput
                    classNames={global}
                    label="Bone"
                    size="xs"
                    value={p.bone}
                    allowDecimal={false}
                    onChange={(v) =>
                      updateSpecificProp(index, { ...p, bone: Number(v) })
                    }
                  />
                </Grid.Col>
              </Grid>
              <Divider
                label="Position"
                labelPosition="center"
                fz="xs"
                mt="xs"
              />
              <Group grow gap="xs">
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="X"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.pos.x}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      pos: { ...p.pos, x: Number(v) },
                    })
                  }
                />
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="Y"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.pos.y}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      pos: { ...p.pos, y: Number(v) },
                    })
                  }
                />
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="Z"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.pos.z}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      pos: { ...p.pos, z: Number(v) },
                    })
                  }
                />
              </Group>
              <Divider
                label="Rotation"
                labelPosition="center"
                fz="xs"
                mt="xs"
              />
              <Group grow gap="xs">
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="X"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.rot.x}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      rot: { ...p.rot, x: Number(v) },
                    })
                  }
                />
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="Y"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.rot.y}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      rot: { ...p.rot, y: Number(v) },
                    })
                  }
                />
                <NumberInput
                  classNames={global}
                  size="xs"
                  label="Z"
                  decimalScale={3}
                  fixedDecimalScale
                  step={0.001}
                  value={p.rot.z}
                  onChange={(v) =>
                    updateSpecificProp(index, {
                      ...p,
                      rot: { ...p.rot, z: Number(v) },
                    })
                  }
                />
              </Group>
            </Accordion.Panel>
          </Accordion.Item>
        ))}
      </Accordion>
    </Stack>
  );
};
