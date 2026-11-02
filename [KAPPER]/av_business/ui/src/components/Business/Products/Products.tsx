import { useEffect, useState, useMemo } from "react";
import {
  Group,
  Button,
  TextInput,
  Text,
  Select,
  ScrollArea,
  Grid,
  Flex,
} from "@mantine/core";
import { IconSearch } from "@tabler/icons-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import {
  ApiAnimations,
  ApiIngredients,
  ApiJobItems,
  ApiTypes,
} from "../../../API/products";
import {
  IngredientsType,
  ItemProperties,
  JobItem,
  SelectType,
} from "../../../types/types";
import { fetchNui, useNuiEvent } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { ModalMenu } from "./ModalMenu";
import { ProductCard } from "./ProductCard";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const Products = () => {
  const [loaded, setLoaded] = useState(false);
  const daLang: any = useAtomValue(Lang);
  const { products: lang }: any = daLang;
  const [search, setSearch] = useState("");
  const [itemTypes, setItemTypes] = useState(ApiTypes);
  const [allItems, setAllItems] = useState(ApiJobItems);
  const [currentItems, setCurrentItems] = useState(ApiJobItems);
  const [whitelisted, setWhitelisted] = useState<SelectType[]>([]);
  const [ingredients, setIngredients] =
    useState<IngredientsType[]>(ApiIngredients);
  const [animations, setAnimations] = useState(ApiAnimations);
  const [inventory, setInventory] = useState("");
  const [maxIngredients, setMaxIngredients] = useState(5);
  const [minIngredients, setMinIngredients] = useState(3);
  const [showModal, setShowModal] = useState(false);
  const [currentItem, setCurrentItem] = useState<ItemProperties | undefined>();
  const [blacklisted, setBlacklisted] = useState(false);

  useNuiEvent("products", (items: JobItem[]) => {
    setAllItems(items);
    setCurrentItems(items);
  });
  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const value = event.currentTarget.value;
    setSearch(value);
    const search = value.toLowerCase();
    const res = allItems.filter(
      (item) =>
        (item.label ? item.label.toLowerCase().includes(search) : false) ||
        (item.name ? item.name.toLowerCase().includes(search) : false),
    );
    setCurrentItems(res);
  };
  const handleEdit = (item: JobItem) => {
    const newItem = {
      name: item.name,
      description: item.description,
      image: item.image,
      type: item.type,
      ingredients: item.ingredients,
      price: item.price,
      isNew: false,
      prop: item.prop,
      cashier: item.cashier ? item.cashier : false,
    };
    setCurrentItem(newItem);
    setShowModal(true);
  };
  const handleDelete = (name: string) => {
    const filtered = allItems.filter((item) => item.name !== name);
    setAllItems(filtered);
    setCurrentItems(filtered);
    fetchNui("av_business", "deleteItem", name);
  };

  const handleFilter = (type: string | null) => {
    if (!type) {
      setCurrentItems(allItems);
    } else {
      const res = allItems.filter((item) =>
        item.type ? item.type.toLowerCase().includes(type) : false,
      );
      setCurrentItems(res);
    }
  };

  const sortedItems = useMemo(() => {
    return [...currentItems].sort((a, b) => {
      const nameA = a.name ?? a.label ?? "";
      const nameB = b.name ?? b.label ?? "";
      return nameA.localeCompare(nameB);
    });
  }, [currentItems]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getMenu");
      if (resp) {
        setAllItems(resp.items);
        setCurrentItems(resp.items);
        setItemTypes(resp.types);
        setIngredients(resp.ingredients);
        setAnimations(resp.animations);
        setInventory(resp.inventory);
        setMaxIngredients(resp.maxIngredients);
        setMinIngredients(resp.minIngredients);
        setWhitelisted(resp.whitelisted);
        setBlacklisted(resp.blacklisted ?? false);
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
      {showModal && (
        <ModalMenu
          showModal={setShowModal}
          whitelisted={whitelisted}
          max={maxIngredients}
          ingredients={ingredients}
          animations={animations}
          itemTypes={itemTypes}
          min={minIngredients}
          existing={currentItem}
          blacklisted={blacklisted}
        />
      )}
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
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {`${currentItems.length} ${lang.products}`}
          </Text>
        </Flex>
        <TextInput
          classNames={global}
          placeholder={lang.search}
          leftSection={<IconSearch size={16} stroke={1.5} />}
          value={search}
          onChange={handleSearchChange}
          size="xs"
          ml="auto"
          maw={200}
        />
        <Select
          classNames={global}
          data={itemTypes}
          placeholder={lang.filter}
          size="xs"
          w={150}
          onChange={handleFilter}
        />
        <Button
          className={classes.button}
          size="xs"
          variant="filled"
          onClick={() => {
            setCurrentItem(undefined);
            setShowModal(true);
          }}
        >
          {lang.new_product}
        </Button>
      </Group>
      <ScrollArea
        h={"calc(100% - 75px)"}
        type="hover"
        scrollbars={"y"}
        scrollbarSize={6}
        mt="sm"
      >
        <Grid>
          {sortedItems.map((item) => (
            <Grid.Col key={item.name} maw={285} miw={285}>
              <ProductCard
                product={item}
                handleDelete={handleDelete}
                handleEdit={handleEdit}
                inventory={inventory}
                ingredients={ingredients}
                lang={lang}
              />
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </>
  );
};

export default Products;
