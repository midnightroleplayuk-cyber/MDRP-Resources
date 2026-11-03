import {
  Box,
  Text,
  Grid,
  Card,
  RingProgress,
  Group,
  Button,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { getDate } from "../../hooks/getDate";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { Loading } from "../Loading";
import { calculateProgress } from "../../hooks/calcProgress";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Product {
  label: string;
  lastCook?: number;
  position: {
    x: number;
    y: number;
    z: number;
  };
  cooking: boolean;
  itemName: string;
  type: string;
  color?: string;
  started?: number;
  currentTime?: number;
  endsIn?: number;
  purity?: number;
}

export const Products = () => {
  const { app: lang }: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allProducts, setAllProducts] = useState<Product[]>([]);
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_drugs", "getProducts");
      if (resp) {
        setAllProducts(resp);
        setTimeout(() => {
          setLoaded(true);
        }, 100);
      }
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      {allProducts && allProducts[0] ? (
        <Grid className={classes.container} gutter="sm">
          {allProducts.map((product, index) => (
            <Grid.Col span={3} key={index} maw={220}>
              <Card p="md" radius="md" withBorder className={classes.card}>
                <RingProgress
                  ml="auto"
                  mr="auto"
                  roundCaps
                  thickness={6}
                  size={150}
                  sections={[
                    {
                      value: calculateProgress(
                        product?.started,
                        product?.currentTime,
                        product?.endsIn
                      ),
                      color: product.color ? product.color : "cyan.3",
                    },
                  ]}
                  label={
                    <Box>
                      <Text ta="center" fz="lg" className={classes.label}>
                        {calculateProgress(
                          product.started,
                          product.currentTime,
                          product.endsIn
                        )}
                        %
                      </Text>
                      <Text ta="center" fz="xs" c="dimmed">
                        {product.cooking ? lang.cooking : lang.standby}
                      </Text>
                    </Box>
                  }
                />
                <Text
                  fz="xl"
                  className={classes.label}
                  fw={500}
                  lts={1.55}
                  c="gray.3"
                >
                  {product.label}
                </Text>
                <Group justify="space-between" mt="sm">
                  <Text fz="xs" fw={500} c="gray.4">
                    {lang.highest_purity}
                  </Text>
                  <Text fz="xs" c="gray">
                    {product.purity ? product.purity : 0}%
                  </Text>
                </Group>
                <Group justify="space-between">
                  <Text fz="xs" fw={500} c="gray.4">
                    {lang.last_cook}
                  </Text>
                  <Text fz="xs" c="gray">
                    {getDate(product.lastCook, product.currentTime)}
                  </Text>
                </Group>
                <Button
                  mt="xs"
                  variant="transparent"
                  color={product.color ? product.color : "cyan"}
                  onClick={() => {
                    fetchNui("av_drugs", "setGPS", product.position);
                  }}
                >
                  {lang.set_gps}
                </Button>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      ) : (
        <Box
          style={{
            position: "relative",
            display: "flex",
            width: "100%",
            height: "100vh",
            textAlign: "center",
            alignContent: "center",
            justifyContent: "center",
          }}
        >
          <Text fz="sm" c="dimmed" fw={500} mt="15%" lts={2}>
            {lang.empty}
          </Text>
        </Box>
      )}
    </>
  );
};
