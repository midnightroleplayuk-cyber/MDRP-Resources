import {
  Group,
  Text,
  ScrollArea,
  TextInput,
  ActionIcon,
  Tooltip,
  Flex,
  Box,
  Grid,
} from "@mantine/core";
import { DeliveriesMap } from "./DeliveriesMap";
import { useEffect, useState } from "react";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { ApiDeliveries, ApiDelivery } from "../../../API/delivery";
import { DeliveryType } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { OrderCard } from "./OrderCard";
import global from "../../../global.module.css";
import { Details } from "./Details";
import { Loading } from "../../Loading";
import {
  IconBell,
  IconBellOff,
  IconClipboardList,
  IconSearch,
  IconToggleLeft,
  IconToggleRight,
} from "@tabler/icons-react";
import { ItemsList } from "./ItemsList";

interface OrderType {
  state: boolean;
  order: DeliveryType;
}

const Deliveries = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.deliveries;
  const [loaded, setLoaded] = useState(false);
  const [allDeliveries, setAllDeliveries] = useState<DeliveryType[]>([]);
  const [filtered, setFiltered] = useState<DeliveryType[]>([]);
  const [open, setOpen] = useState(false);
  const [notify, setNotify] = useState(false);
  const [search, setSearch] = useState("");
  const [selected, setSelected] = useState<string[]>([]);
  const [myCoords, setMyCoords] = useState({ x: 0, y: 0 });
  const [myIdentifier, setMyIdentifier] = useState("");
  const [showDetails, setShowDetails] = useState<OrderType>({
    state: false,
    order: ApiDelivery,
  });
  const [showList, setShowList] = useState(false);

  const fetchData = async () => {
    const resp = await fetchNui("av_business", "getDeliveries");
    if (resp) {
      setAllDeliveries(resp.deliveries);
      setFiltered(resp.deliveries);
      setOpen(resp.isOpen);
      setNotify(resp.notify);
      setMyCoords(resp.coords);
      setMyIdentifier(resp.myIdentifier);
    } else {
      if (isEnvBrowser()) {
        setAllDeliveries(ApiDeliveries);
        setFiltered(ApiDeliveries);
      }
    }
    if (!loaded) {
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    }
  };

  useNuiEvent("updateDeliveries", () => {
    fetchData();
  });

  const handleOrder = (event: string, order: DeliveryType) => {
    fetchNui("av_business", event, order);
  };

  const handleSearch = (value: string) => {
    setSearch(value);
    const search = value.toLowerCase();
    const res = allDeliveries.filter(
      (item) =>
        (item.identifier
          ? item.identifier.toLowerCase().includes(search)
          : false) ||
        (item.claimed ? item.claimed.toLowerCase().includes(search) : false),
    );
    setFiltered(res);
  };

  const handleDetails = (order: DeliveryType) => {
    setShowDetails({
      state: true,
      order,
    });
  };

  const handleSelection = (identifier: string) => {
    setSelected((prev) =>
      prev.includes(identifier)
        ? prev.filter((id) => id !== identifier)
        : [...prev, identifier],
    );
  };

  useEffect(() => {
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box h="100%" style={{ position: "relative", overflow: "hidden" }}>
      {showDetails.state && (
        <Box style={{ position: "absolute", inset: 0, zIndex: 100 }}>
          <Details
            daLang={daLang}
            order={showDetails.order}
            setShow={() => {
              setShowDetails({ ...showDetails, state: false });
            }}
          />
        </Box>
      )}
      {showList && (
        <Box style={{ position: "absolute", inset: 0, zIndex: 99999 }}>
          <ItemsList setItemPanel={setShowList} lang={lang} />
        </Box>
      )}

      <Flex direction="column" h="100%" gap="md">
        <Group
          bg="var(--bg-card)"
          p="sm"
          style={{
            borderRadius: "6px",
            border: "solid 1px var(--border)",
            flexShrink: 0,
          }}
        >
          <Flex gap="xs" direction="column">
            <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
              {lang.header}
            </Text>
            <Text mt={-15} fz="xs" c="var(--text-dim)">
              {`${allDeliveries.length} Orders`}
            </Text>
          </Flex>
          <Group ml="auto" gap={6}>
            <Tooltip
              label={open ? lang.orders + ": ON" : lang.orders + ": OFF"}
              color="var(--tooltip)"
              fz="xs"
              withArrow
            >
              <ActionIcon
                size="md"
                variant="subtle"
                onClick={() => {
                  setOpen(!open);
                  fetchNui("av_business", "toggleDeliveries", !open);
                }}
                style={{
                  color: open ? "var(--success)" : "var(--text-dim)",
                  background: open ? "rgba(74,222,128,0.1)" : "transparent",
                  border: `1px solid ${open ? "rgba(74,222,128,0.25)" : "var(--border)"}`,
                  transition: "all 0.2s",
                }}
              >
                {open ? (
                  <IconToggleRight size={18} />
                ) : (
                  <IconToggleLeft size={18} />
                )}
              </ActionIcon>
            </Tooltip>

            <Tooltip
              label={notify ? lang.notify + ": ON" : lang.notify + ": OFF"}
              color="var(--tooltip)"
              fz="xs"
              withArrow
            >
              <ActionIcon
                size="md"
                variant="subtle"
                onClick={() => {
                  setNotify(!notify);
                  fetchNui("av_business", "notifyme", !notify);
                }}
                style={{
                  color: notify ? "var(--cyan)" : "var(--text-dim)",
                  background: notify ? "rgba(34,211,238,0.1)" : "transparent",
                  border: `1px solid ${notify ? "rgba(34,211,238,0.25)" : "var(--border)"}`,
                  transition: "all 0.2s",
                }}
              >
                {notify ? <IconBell size={16} /> : <IconBellOff size={16} />}
              </ActionIcon>
            </Tooltip>

            <Tooltip
              label={lang.inventory_header}
              color="var(--tooltip)"
              fz="xs"
              withArrow
            >
              <ActionIcon
                size="md"
                variant="subtle"
                onClick={() => {
                  setShowList(!showList);
                }}
                style={{
                  color: showList ? "var(--cyan)" : "var(--text-dim)",
                  background: showList ? "rgba(34,211,238,0.1)" : "transparent",
                  border: `1px solid ${showList ? "rgba(34,211,238,0.25)" : "var(--border)"}`,
                  transition: "all 0.2s",
                }}
              >
                <IconClipboardList size={16} />
              </ActionIcon>
            </Tooltip>

            <TextInput
              classNames={global}
              placeholder={daLang.search}
              leftSection={<IconSearch size={14} />}
              value={search}
              onChange={(e) => {
                handleSearch(e.currentTarget.value);
              }}
              size="xs"
              w={160}
            />
          </Group>
        </Group>

        <Box style={{ flex: 1, minHeight: 0 }}>
          <Flex h="100%" gap="xs" align="stretch">
            <Box
              style={{
                flex: 0.8,
                display: "flex",
                flexDirection: "column",
                minWidth: 0,
              }}
            >
              <ScrollArea h="100%" offsetScrollbars scrollbarSize={4}>
                <Grid gap="xs" pr="sm">
                  {[...filtered]
                    .sort((a, b) => {
                      const aIsMine = a.claimedIdentifier === myIdentifier;
                      const bIsMine = b.claimedIdentifier === myIdentifier;
                      return Number(bIsMine) - Number(aIsMine);
                    })
                    .map((order) => (
                      <Grid.Col span={6} key={order.identifier}>
                        <OrderCard
                          data={order}
                          symbol={daLang.money_symbol ?? "$"}
                          handleDetails={handleDetails}
                          selected={selected.includes(order.identifier)}
                          handleOrder={handleOrder}
                          daLang={daLang}
                        />
                      </Grid.Col>
                    ))}
                </Grid>
              </ScrollArea>
            </Box>

            <Box
              style={{
                flex: 1.2,
                height: "100%",
                borderRadius: "6px",
                overflow: "hidden",
              }}
            >
              <DeliveriesMap
                orders={allDeliveries}
                setSelected={handleSelection}
                myCoords={myCoords}
                myIdentifier={myIdentifier}
                daLang={daLang}
              />
            </Box>
          </Flex>
        </Box>
      </Flex>
    </Box>
  );
};

export default Deliveries;
