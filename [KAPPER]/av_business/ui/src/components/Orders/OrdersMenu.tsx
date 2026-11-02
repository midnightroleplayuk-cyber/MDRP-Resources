import { useEffect, useState } from "react";
import {
  Transition,
  Box,
  Text,
  Stack,
  ScrollArea,
  Grid,
  Card,
  Menu,
  ActionIcon,
  Divider,
} from "@mantine/core";
import {
  IconListCheck,
  IconDotsVertical,
  IconHourglassEmpty,
  IconProgressCheck,
  IconBellPlus,
  IconBellMinus,
} from "@tabler/icons-react";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { ApiOrders } from "../../API/orders";
import { OrderType } from "../../types/types";
import { formatTimestamp } from "../../hooks/formatTime";
import { Loading } from "../Loading";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const OrdersMenu = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.orders;
  const [loading, setLoading] = useState(true);
  const [loaded, setLoaded] = useState(false);
  const [allOrders, setAllOrders] = useState<OrderType[]>([]);

  const handleOrder = async (callback: string, order: OrderType) => {
    if (callback == "addToQueue") {
      setLoaded(false);
      setTimeout(() => {
        fetchNui("av_business", "closeOrders");
      }, 200);
    }
    const resp = await fetchNui("av_business", callback, order);
    if (resp) {
      setAllOrders(resp);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getOrders");
      if (resp) {
        setAllOrders(resp);
      } else {
        if (isEnvBrowser()) {
          setAllOrders(ApiOrders);
        }
      }
      setLoaded(true);
      setTimeout(() => {
        setLoading(false);
      }, 100);
    };
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.code === "Escape") {
        setLoaded(false);
        setTimeout(() => {
          fetchNui("av_business", "closeOrders");
        }, 200);
      }
    };
    fetchData();
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <Box className={classes.container}>
      <Transition
        mounted={loaded}
        transition="fade-left"
        duration={800}
        exitDuration={800}
        timingFunction="ease"
      >
        {(styles) => (
          <Stack className={classes.box} style={styles} gap="xs">
            {loading ? (
              <Loading />
            ) : (
              <>
                <Text
                  mt="md"
                  fz="xl"
                  c="var(--text-main)"
                  fw={600}
                  ff="var(--font-display)"
                  tt="uppercase"
                  ta="center"
                  lts={1}
                >{`${allOrders.length} ${lang.header}`}</Text>
                <Divider color="var(--border)" />
                <ScrollArea
                  type="hover"
                  scrollbars="y"
                  scrollbarSize={4}
                  offsetScrollbars
                  h={450}
                  pr="xs"
                  pl="xs"
                  mb="xs"
                >
                  <Stack gap={1}>
                    {allOrders.map((order) => (
                      <Menu
                        key={order.identifier}
                        classNames={classes}
                        shadow="md"
                        width={200}
                        position="bottom-end"
                        withinPortal
                      >
                        <Card className={classes.order} p="md" mb="xs">
                          <Menu.Target>
                            <ActionIcon
                              size="sm"
                              variant="transparent"
                              color="var(--text-dim)"
                              style={{
                                position: "absolute",
                                top: 12,
                                right: 12,
                              }}
                            >
                              <IconDotsVertical size={18} />
                            </ActionIcon>
                          </Menu.Target>
                          <Grid grow align="flex-start">
                            <Grid.Col span={6}>
                              <Stack gap={2}>
                                <Text
                                  fz={10}
                                  c="var(--text-dim)"
                                  lts={0.5}
                                  tt="uppercase"
                                >
                                  {lang.customer}
                                </Text>
                                <Text fz="xs" fw={600} c="var(--text-main)">
                                  {order.customerName}
                                </Text>
                              </Stack>
                            </Grid.Col>
                            <Grid.Col span={6}>
                              <Stack gap={2}>
                                <Text
                                  fz={10}
                                  c="var(--text-dim)"
                                  lts={0.5}
                                  tt="uppercase"
                                >
                                  {lang.products}
                                </Text>
                                <Text fz="xs" fw={600} c="var(--text-main)">
                                  {`${order.cart.length} Items`}
                                </Text>
                              </Stack>
                            </Grid.Col>
                          </Grid>
                          <Grid grow align="flex-start" mt="sm">
                            <Grid.Col span={6}>
                              <Stack gap={2}>
                                <Text
                                  fz={10}
                                  c="var(--text-dim)"
                                  lts={0.5}
                                  tt="uppercase"
                                >
                                  {lang.generated}
                                </Text>
                                <Text fz="xs" fw={600} c="var(--text-main)">
                                  {formatTimestamp(order.generated, "HH:mm")}
                                </Text>
                              </Stack>
                            </Grid.Col>
                            <Grid.Col span={6}>
                              <Stack gap={2}>
                                <Text
                                  fz={10}
                                  c="var(--text-dim)"
                                  lts={0.5}
                                  tt="uppercase"
                                >
                                  {lang.status}
                                </Text>
                                <Text
                                  fz="sm"
                                  fw={600}
                                  tt="uppercase"
                                  c={
                                    order.inProgress
                                      ? "var(--success)"
                                      : "var(--text-dim)"
                                  }
                                  style={{ fontFamily: "var(--font-display)" }}
                                >
                                  {order.inProgress
                                    ? lang.inprogress
                                    : lang.pending}
                                </Text>
                              </Stack>
                            </Grid.Col>
                          </Grid>
                        </Card>
                        <Menu.Dropdown
                          bg="var(--bg-sidebar)"
                          style={{ border: "1px solid var(--border)" }}
                        >
                          <Menu.Item
                            leftSection={
                              <IconHourglassEmpty
                                size={16}
                                color="var(--text-dim)"
                              />
                            }
                            onClick={() => handleOrder("addToQueue", order)}
                          >
                            {lang.addqueue}
                          </Menu.Item>
                          <Menu.Item
                            leftSection={
                              order.inProgress ? (
                                <IconBellMinus
                                  size={16}
                                  color="var(--text-dim)"
                                />
                              ) : (
                                <IconBellPlus
                                  size={16}
                                  color="var(--text-dim)"
                                />
                              )
                            }
                            onClick={() => handleOrder("toggleOrder", order)}
                          >
                            {order.inProgress
                              ? lang.mark_pending
                              : lang.mark_complete}
                          </Menu.Item>
                          <Menu.Item
                            leftSection={
                              <IconProgressCheck
                                size={16}
                                color="var(--text-dim)"
                              />
                            }
                            onClick={() => handleOrder("removeOrder", order)}
                          >
                            {lang.mark_delivered}
                          </Menu.Item>
                        </Menu.Dropdown>
                      </Menu>
                    ))}
                  </Stack>
                </ScrollArea>
              </>
            )}
          </Stack>
        )}
      </Transition>
    </Box>
  );
};
