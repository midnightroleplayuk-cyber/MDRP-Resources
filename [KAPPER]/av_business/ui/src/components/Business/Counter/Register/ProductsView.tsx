import {
  Stack,
  Group,
  Text,
  Grid,
  Card,
  Flex,
  NumberInput,
  Button,
  Select,
  TextInput,
  ScrollArea,
} from "@mantine/core";
import { ItemImage } from "../../../ItemImage/ItemImage";
import { IconSearch } from "@tabler/icons-react";
import { SelectType } from "../../../../types/types";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

interface Product {
  name: string;
  label: string;
  price: number;
  stock: number;
  type: string;
}

interface Properties {
  lang: any;
  products: Product[];
  itemTypes: SelectType[];
  filterType: string | null;
  search: string;
  onSearchChange: (val: string) => void;
  onFilterChange: (val: string | null) => void;
  onAmountChange: (name: string, val: number | string) => void;
  inventory: string;
  onAddToCart: (product: Product, amount: number) => void;
  getAmount: (name: string) => number;
}

export const ProductsView = ({
  lang,
  products,
  itemTypes,
  filterType,
  search,
  inventory,
  onSearchChange,
  onFilterChange,
  onAmountChange,
  onAddToCart,
  getAmount,
}: Properties) => (
  <Stack h="calc(100% - 60px)" gap="md">
    <Group justify="space-between" align="center">
      <Text
        fz="xl"
        lh={0}
        fw={500}
        c="var(--text-main)"
        ff="var(--font-display)"
      >
        {products.length} {lang.products || "Products"}
      </Text>
      <Group gap="sm">
        <Select
          classNames={global}
          placeholder={lang.filter_by_type || "Filter by type"}
          size="xs"
          data={itemTypes}
          value={filterType}
          onChange={onFilterChange}
          clearable
        />
        <TextInput
          placeholder={lang.search || "Search..."}
          size="xs"
          leftSection={<IconSearch size={12} />}
          value={search}
          onChange={(e) => onSearchChange(e.currentTarget.value)}
          classNames={global}
        />
      </Group>
    </Group>
    <ScrollArea h="100%" type="hover" scrollbars="y" scrollbarSize={5}>
      <Grid gap="sm" w={600}>
        {products.map((product) => (
          <Grid.Col span={4} key={product.name} miw={200} maw={200}>
            <Card className={classes.productCard}>
              <Flex direction="column" align="center" mb="md">
                <ItemImage
                  inventory={inventory}
                  name={product.name}
                  w={64}
                  h={64}
                  fit="contain"
                />
              </Flex>
              <Group
                justify="space-between"
                align="flex-start"
                mb="xs"
                wrap="nowrap"
              >
                <Stack gap={0} style={{ flex: 1, minWidth: 0 }}>
                  <Text fz="sm" fw={600} c="var(--text-main)" truncate>
                    {product.label}
                  </Text>
                  <Text fz="xs" c="var(--text-dim)">
                    {lang.stock || "Stock"}: {product.stock}
                  </Text>
                </Stack>
                <Text
                  fz="sm"
                  fw={700}
                  c="var(--text-main)"
                  style={{ whiteSpace: "nowrap" }}
                >
                  ${product.price}
                </Text>
              </Group>
              <Stack gap="xs" mt="auto">
                <NumberInput
                  value={getAmount(product.name)}
                  onChange={(val) => onAmountChange(product.name, val)}
                  min={1}
                  max={product.stock > 0 ? product.stock : 1}
                  disabled={product.stock <= 0}
                  allowDecimal={false}
                  allowNegative={false}
                  size="xs"
                  styles={{
                    input: {
                      backgroundColor: "var(--bg-input)",
                      borderColor: "var(--border)",
                      color: "var(--text-main)",
                      textAlign: "center",
                    },
                  }}
                />
                <Button
                  fullWidth
                  className={global.button}
                  size="xs"
                  fw={300}
                  fz="11px"
                  disabled={product.stock <= 0}
                  onClick={() => onAddToCart(product, getAmount(product.name))}
                >
                  {lang.add_to_cart || "Add to Cart"}
                </Button>
              </Stack>
            </Card>
          </Grid.Col>
        ))}
      </Grid>
    </ScrollArea>
  </Stack>
);
