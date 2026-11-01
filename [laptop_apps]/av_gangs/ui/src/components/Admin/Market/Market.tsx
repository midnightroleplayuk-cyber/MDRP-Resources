import { useEffect, useState } from "react";
import {
  Group,
  TextInput,
  Text,
  Button,
  ScrollArea,
  Table,
  Stack,
} from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import {
  ApiGangList,
  ApiIngredients,
  ApiLabsSettings,
  ApiShells,
} from "../../../api/MarketSettings";
import { ApiCategories } from "../../../api/Market";
import { Loading } from "../../Loading";
import { IconSearch } from "@tabler/icons-react";
import { ItemType } from "./types";
import { useDisclosure } from "@mantine/hooks";
import { Panel } from "./Panel";
import { ProductType, SelectType } from "../../../types/types";
import classes from "./style.module.css";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

const Market = () => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [categories, setCategories] = useState<SelectType[]>([]);
  const [allProducts, setAllProducts] = useState<ItemType[]>([]);
  const [filtered, setFiltered] = useState<ItemType[]>([]);
  const [allGangs, setAllGangs] = useState<SelectType[]>([]);
  const [shells, setShells] = useState<
    (SelectType & { preview: string; type: string })[]
  >([]);
  const [allIngredients, setAllIngredients] = useState<SelectType[]>([]);
  const [allOutputs, setAllOutputs] = useState<SelectType[]>([]);
  const [currentProduct, setCurrentProduct] = useState<null | ItemType>(null);
  const [opened, handlers] = useDisclosure(false);

  const handleSearch = (input: string) => {
    const res = allProducts.filter((product) =>
      product.label ? product.label.toLowerCase().includes(input) : false
    );
    setFiltered(res);
  };

  const handleSave = async (product: ProductType) => {
    const resp = await fetchNui("av_gangs", "admin:saveProduct", product);
    if (resp) {
      setAllProducts(resp);
      setFiltered(resp);
    }
  };
  const handleDelete = async (product: ProductType) => {
    const resp = await fetchNui("av_gangs", "admin:deleteProduct", product);
    if (resp) {
      setCurrentProduct(null);
      handlers.close();
      setAllProducts(resp);
      setFiltered(resp);
    }
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "admin:getProducts");
      if (resp) {
        setAllProducts(resp.products);
        setFiltered(resp.products);
        setCategories(resp.categories);
        setAllGangs(resp.allGangs);
        setAllIngredients(resp.ingredients);
        setAllOutputs(resp.outputs);
        setShells(resp.shells);
      } else {
        if (isEnvBrowser()) {
          setAllProducts(ApiLabsSettings);
          setFiltered(ApiLabsSettings);
          setCategories(ApiCategories);
          setAllGangs(ApiGangList);
          setAllIngredients(ApiIngredients);
          setAllOutputs(ApiIngredients);
          setShells(ApiShells);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Stack p="md">
      {(currentProduct || opened) && (
        <Panel
          handleClose={() => {
            setCurrentProduct(null);
            handlers.close();
          }}
          item={currentProduct}
          categories={categories}
          allGangs={allGangs}
          shells={shells}
          allIngredients={allIngredients}
          handleSave={handleSave}
          handleDelete={handleDelete}
          allOutputs={allOutputs}
        />
      )}
      <Group className={classes.card}>
        <Text
          fz="1.55rem"
          c="white"
          ff="Bebas Neue"
          fw={500}
          lts={1.55}
        >{`${filtered.length} ${lang.products}`}</Text>
        <Group ml="auto">
          <TextInput
            classNames={global}
            size="xs"
            placeholder="Search..."
            leftSection={<IconSearch size={16} stroke={1.5} />}
            onChange={(e) => {
              handleSearch(e.currentTarget.value);
            }}
          />
          <Button
            className={global.button}
            size="xs"
            onClick={() => {
              handlers.open();
            }}
          >
            {lang.create_product}
          </Button>
        </Group>
      </Group>
      <ScrollArea
        h={450}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Table
          striped
          stripedColor="rgba(30,30,36,0.9)"
          highlightOnHover
          highlightOnHoverColor="rgba(200,200,200,0.2)"
        >
          <Table.Thead>
            <Table.Tr>
              <Table.Th>{lang.product_label}</Table.Th>
              <Table.Th>{daLang.shell}</Table.Th>
              <Table.Th>{daLang.type}</Table.Th>
              <Table.Th>{daLang.price}</Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {filtered.map((product) => (
              <Table.Tr
                key={product.label}
                style={{ cursor: "pointer" }}
                onClick={() => {
                  setCurrentProduct(product);
                }}
              >
                <Table.Td>{product.label}</Table.Td>
                <Table.Td>{product.shell}</Table.Td>
                <Table.Td>{product.category}</Table.Td>
                <Table.Td>{`${
                  daLang.money_symbol
                }${product.price.toLocaleString("en-US")}`}</Table.Td>
              </Table.Tr>
            ))}
          </Table.Tbody>
        </Table>
      </ScrollArea>
    </Stack>
  );
};
export default Market;
