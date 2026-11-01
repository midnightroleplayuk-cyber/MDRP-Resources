import { useEffect, useState } from "react";
import { CategoryType, MarketItem } from "../../../../types/types";
import { Loading } from "../../../Loading";
import { Grid, ScrollArea, Stack } from "@mantine/core";
import { Categories } from "./Categories";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../hooks/useNuiEvents";
import { ApiProducts } from "../../../../Api/Products";
import { ApiCategories } from "../../../../Api/Categories";
import { MarketCard } from "./MarketCard/MarketCard";
import { useSetAtom } from "jotai";
import { Profile } from "../../../../reducers/atoms";

interface MarketProps {
  search: string;
  allCategories: CategoryType[];
  setAllCategories: (categories: CategoryType[]) => void;
}

const Market = ({ search, allCategories, setAllCategories }: MarketProps) => {
  const [allProducts, setAllProducts] = useState<MarketItem[]>([]);
  const [filtered, setFiltered] = useState<MarketItem[]>([]);
  const [activeCategory, setActiveCategory] = useState("all");
  const [loaded, setLoaded] = useState(false);
  const setProfile = useSetAtom(Profile);

  useNuiEvent("newListing", (item: MarketItem) => {
    const categoryExists = allCategories.some(
      (cat) => cat.value === item.category,
    );
    if (categoryExists) {
      const updated = [item, ...allProducts];
      setAllProducts(updated);
      setFiltered(updated);
    }
  });

  useNuiEvent("listingDeleted", (post_id: string) => {
    const updated = allProducts.filter((item) => item.post_id !== post_id);
    setAllProducts(updated);
    setFiltered(updated);
  });

  useNuiEvent("listingUpdated", (updatedItem: MarketItem) => {
    const updated = allProducts.map((item) =>
      item.post_id === updatedItem.post_id ? updatedItem : item,
    );
    setAllProducts(updated);
    setFiltered(updated);
  });

  const handleActive = (category: string) => {
    setActiveCategory(category);
    const updated = allProducts.filter((item) =>
      category === "all" ? true : item.category === category,
    );
    setFiltered(updated);
  };

  useEffect(() => {
    if (search.trim() === "") {
      handleActive(activeCategory);
    } else {
      const updated = allProducts.filter((item) =>
        item.title.toLowerCase().includes(search.toLowerCase()),
      );
      setFiltered(updated);
    }
  }, [search, allProducts]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_marketplace", "getData");
      if (resp) {
        setAllProducts(resp.products);
        setFiltered(resp.products);
        setAllCategories(resp.categories);
        setProfile(resp.profile);
      } else {
        if (isEnvBrowser()) {
          setAllProducts(ApiProducts);
          setFiltered(ApiProducts);
          setAllCategories(ApiCategories);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <ScrollArea>
      <Stack p="md">
        <Categories
          active={activeCategory}
          setActive={handleActive}
          allCategories={allCategories}
        />
        <Grid>
          {filtered.map((product) => (
            <Grid.Col key={product.post_id} span={"auto"} miw={330} maw={330}>
              <MarketCard item={product} />
            </Grid.Col>
          ))}
        </Grid>
      </Stack>
    </ScrollArea>
  );
};
export default Market;
