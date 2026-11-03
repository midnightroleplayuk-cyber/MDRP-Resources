import { useEffect, useState } from "react";
import {
  Box,
  Modal,
  Text,
  Grid,
  MultiSelect,
  TextInput,
  NumberInput,
  Select,
  Image,
  Button,
  Group,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { IconCopy } from "@tabler/icons-react";
import { ItemType } from "./types";
import { ProductType, SelectType } from "../../../types/types";
import { cleanString } from "../../../hooks/cleanString";
import { fetchNui } from "../../../hooks/useNuiEvents";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

type ItemWithNew = ItemType & { isNew: boolean };
type ShellWithPreview = SelectType & { preview: string; type: string };

interface Properties {
  item?: ItemType | null;
  handleClose: () => void;
  categories: SelectType[];
  allGangs: SelectType[];
  shells: ShellWithPreview[];
  allIngredients: SelectType[];
  allOutputs: SelectType[];
  handleSave: (product: any) => void;
  handleDelete: (product: any) => void;
}

const filterShells = (type: string, list: ShellWithPreview[]) => {
  const res = list.filter((shell) =>
    shell.type ? shell.type.toLowerCase().includes(type) : false
  );
  return res;
};

export const Panel = ({
  item,
  handleClose,
  categories,
  allGangs,
  shells,
  allIngredients,
  allOutputs,
  handleSave,
  handleDelete,
}: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [product, setProduct] = useState<ItemWithNew>(
    item ? { ...item, isNew: false } : ({ isNew: true } as ItemWithNew)
  );
  const [filteredShells, setFilteredShells] = useState(shells);
  const handleUpdate = (field: string, value: any) => {
    switch (field) {
      case "shell":
        const res = filteredShells.find((option) =>
          option.value ? option.value.toLowerCase().includes(value) : false
        );
        if (res) {
          setProduct({ ...product, ["photo"]: res.preview, ["shell"]: value });
        }
        break;
      case "label":
        const name = cleanString(value);
        setProduct({ ...product, ["name"]: name, ["label"]: value });
        break;
      default:
        setProduct({ ...product, [field]: value });
        break;
    }
  };
  useEffect(() => {
    if (!product.category) return;
    const filtered = filterShells(product.category, shells);
    setFilteredShells(filtered);
  }, [product.category]);

  return (
    <Modal
      classNames={global}
      opened
      onClose={handleClose}
      lockScroll={false}
      c="white"
      centered
      trapFocus={false}
      size={700}
      title={
        <Text c="gray.3" fw={500}>
          {product?.isNew ? lang.register_product : lang.edit_product}
        </Text>
      }
    >
      {product.photo ? (
        <Image src={product.photo} h={150} fit="cover" mb="sm" />
      ) : (
        <Box ta="center" h={150} p="3rem">
          <Text c="dimmed" fz="xs">
            {lang.select_shell}
          </Text>
        </Box>
      )}
      <Grid grow>
        <Grid.Col span={4}>
          <TextInput
            classNames={global}
            label={
              <Group gap="xs">
                <Text fz="xs" fw={500}>
                  {lang.product_name}
                </Text>
                <Tooltip label="Copy Name" color="dark.6" fz="xs">
                  <ActionIcon
                    variant="transparent"
                    size="xs"
                    onClick={() => {
                      fetchNui("av_laptop", "copy", product.name);
                    }}
                  >
                    <IconCopy style={{ height: "10px", width: "10px" }} />
                  </ActionIcon>
                </Tooltip>
              </Group>
            }
            size="xs"
            value={cleanString(product.label ?? "") ?? undefined}
            disabled
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <TextInput
            classNames={global}
            label={lang.product_label}
            maxLength={50}
            size="xs"
            value={product.label ?? undefined}
            onChange={(e) => {
              handleUpdate("label", e.currentTarget.value);
            }}
            withAsterisk
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <Select
            classNames={global}
            label={daLang.category}
            size="xs"
            data={categories}
            allowDeselect={false}
            defaultValue={product.category ?? undefined}
            disabled={!product.isNew}
            onChange={(e) => {
              handleUpdate("category", e);
            }}
            withAsterisk
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <Select
            classNames={global}
            size="xs"
            label={daLang.shell_model}
            placeholder={!product.category ? lang.select_category : undefined}
            data={filteredShells}
            defaultValue={product.shell}
            allowDeselect={false}
            withAsterisk
            disabled={!product.category}
            onChange={(e) => {
              handleUpdate("shell", e);
            }}
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <TextInput
            classNames={global}
            label={daLang.description}
            maxLength={100}
            size="xs"
            value={product.description ?? undefined}
            onChange={(e) => {
              handleUpdate("description", e.currentTarget.value);
            }}
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <NumberInput
            classNames={global}
            size="xs"
            label={daLang.price}
            defaultValue={product.price}
            min={0}
            max={1000000000}
            allowDecimal={false}
            allowLeadingZeros={false}
            allowNegative={false}
            thousandSeparator
            prefix="$"
            onChange={(e) => {
              handleUpdate("price", e);
            }}
            withAsterisk
          />
        </Grid.Col>
        <Grid.Col span={4}>
          <NumberInput
            classNames={global}
            label={lang.min_level}
            size="xs"
            placeholder="0"
            allowDecimal={false}
            allowLeadingZeros={false}
            allowNegative={false}
            value={product.level ?? undefined}
            onChange={(e) => {
              handleUpdate("level", e);
            }}
          />
        </Grid.Col>
        {product.category == "labs" && (
          <>
            <Grid.Col span={4}>
              <TextInput
                classNames={global}
                label={
                  <Group gap="xs">
                    <Text fz="xs" fw={500}>
                      {lang.lab_type}
                    </Text>
                    <Tooltip
                      label={lang.lab_type_description}
                      color="dark.6"
                      multiline
                      w={200}
                      fz="xs"
                    >
                      <Text fz="xs" c="dimmed">
                        ?
                      </Text>
                    </Tooltip>
                  </Group>
                }
                size="xs"
                placeholder="drugs, laundromat, etc..."
                value={product.type ?? ""}
                maxLength={20}
                onChange={(e) => {
                  handleUpdate("type", e.currentTarget.value);
                }}
              />
            </Grid.Col>
            <Grid.Col span={4}>
              <MultiSelect
                classNames={global}
                size="xs"
                label={
                  <Group gap="xs">
                    <Text fz="xs" fw={500}>
                      {lang.ingredients}
                    </Text>
                    <Tooltip
                      label={lang.ingredients_description}
                      color="dark.6"
                      multiline
                      w={200}
                      fz="xs"
                    >
                      <Text fz="xs" c="dimmed">
                        ?
                      </Text>
                    </Tooltip>
                  </Group>
                }
                data={allIngredients}
                max={5}
                defaultValue={product.ingredients}
                onChange={(e) => {
                  handleUpdate("ingredients", e);
                }}
              />
            </Grid.Col>
            <Grid.Col span={4}>
              <Select
                classNames={global}
                label={
                  <Group gap="xs">
                    <Text fz="xs" fw={500}>
                      {lang.output_item}
                    </Text>
                    <Tooltip
                      label={lang.output_description}
                      color="dark.6"
                      multiline
                      w={200}
                      fz="xs"
                    >
                      <Text fz="xs" c="dimmed">
                        ?
                      </Text>
                    </Tooltip>
                  </Group>
                }
                size="xs"
                data={allOutputs}
                searchable
                defaultValue={product.output ?? undefined}
                onChange={(e) => {
                  handleUpdate("output", e);
                }}
              />
            </Grid.Col>
          </>
        )}

        <Grid.Col span={4}>
          <MultiSelect
            classNames={global}
            label={
              <Group gap="xs">
                <Text fz="xs" fw={500}>
                  {lang.restrict_product}
                </Text>
                <Tooltip
                  label={lang.restrict_description}
                  color="dark.6"
                  multiline
                  w={200}
                  fz="xs"
                >
                  <Text fz="xs" c="dimmed">
                    ?
                  </Text>
                </Tooltip>
              </Group>
            }
            size="xs"
            data={allGangs}
            searchable
            defaultValue={product.allowedGangs ?? undefined}
            onChange={(e) => {
              handleUpdate("allowedGangs", e);
            }}
          />
        </Grid.Col>
      </Grid>
      <Group mt="md">
        {!product.isNew && (
          <Button
            ml="auto"
            size="xs"
            color="red"
            variant="subtle"
            onDoubleClick={() => {
              handleDelete(product.name);
            }}
          >
            {lang.delete_product}
          </Button>
        )}
        <Button
          ml={product.isNew ? "auto" : "none"}
          className={global.button}
          size="xs"
          onClick={() => {
            handleSave(product);
          }}
        >
          {daLang.save_changes}
        </Button>
      </Group>
    </Modal>
  );
};
