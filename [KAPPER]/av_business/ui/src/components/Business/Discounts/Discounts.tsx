import { useEffect, useState } from "react";
import {
  Table,
  ScrollArea,
  TextInput,
  Group,
  Text,
  Button,
  Select,
  ActionIcon,
  Flex,
  Badge,
  Box,
  SegmentedControl,
} from "@mantine/core";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiDiscounts, ApiPromos, DiscountType, PromoType } from "./api";
import { IconCopy } from "@tabler/icons-react";
import { Loading } from "../../Loading";
import { sortAlphabetically, sortData } from "./utils";
import { TableHeader } from "../../TableHeader/TableHeader";
import { Panel } from "./Panel";
import { PromoPanel } from "./PromoPanel";
import { isWide } from "../../../hooks/wide";
import { Creator } from "./Creator";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const fmtDate = (ts?: number | null) => {
  if (!ts) return "\u2014";
  return new Date(ts * 1000).toLocaleString("en-US", {
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const promoStatus = (promo: PromoType) => {
  const now = Math.floor(Date.now() / 1000);
  if (!promo.enabled) return "disabled";
  if (promo.starts_at > now) return "scheduled";
  if (promo.ends_at && promo.ends_at < now) return "expired";
  return "active";
};

const STATUS_COLOR: Record<string, string> = {
  active: "green",
  scheduled: "cyan",
  expired: "red",
  disabled: "gray",
};

const Discounts = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.discounts;
  const [loaded, setLoaded] = useState(false);
  const [view, setView] = useState<"coupons" | "promos">("coupons");

  const [allDiscounts, setAllDiscounts] = useState<DiscountType[]>([]);
  const [filtered, setFiltered] = useState<DiscountType[]>([]);
  const [sortBy, setSortBy] = useState<keyof DiscountType | null>(null);
  const [search, setSearch] = useState("");
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [item, setItem] = useState<DiscountType | null>(null);
  const [showCreator, setShowCreator] = useState(false);

  const [allPromos, setAllPromos] = useState<PromoType[]>([]);
  const [filteredPromos, setFilteredPromos] = useState<PromoType[]>([]);
  const [activePromo, setActivePromo] = useState<PromoType | null>(null);
  const [promoSearch, setPromoSearch] = useState("");

  const wide = isWide();
  const isPromoView = view === "promos";

  const setSorting = (field: keyof DiscountType) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setFiltered(sortData(filtered, { sortBy: field, reversed, search }));
  };

  const handleSearch = (input: string) => {
    const query = input.toLowerCase().trim();
    setSearch(query);
    if (query === "") {
      setFiltered(allDiscounts);
      return;
    }
    const results = allDiscounts.filter(
      (item) =>
        item.code.toLowerCase().includes(query) ||
        item.employee.toLowerCase().includes(query) ||
        item.description.toLowerCase().includes(query),
    );
    setFiltered(results);
  };

  const handlePromoSearch = (input: string) => {
    const query = input.toLowerCase().trim();
    setPromoSearch(query);
    if (query === "") {
      setFilteredPromos(allPromos);
      return;
    }
    setFilteredPromos(
      allPromos.filter(
        (p) =>
          p.label.toLowerCase().includes(query) ||
          (p.description ?? "").toLowerCase().includes(query),
      ),
    );
  };

  const handleDelete = (code: string) => {
    fetchNui("av_business", "deleteCoupon", code);
    const updatedList = allDiscounts.filter((item) => item.code !== code);
    setAllDiscounts(updatedList);
    setFiltered(updatedList);
    setItem(null);
  };

  const toggleStatus = (code: string) => {
    const currentCoupon = allDiscounts.find((c) => c.code === code);
    if (!currentCoupon) return;
    const newStatus = !currentCoupon.enabled;
    fetchNui("av_business", "toggleCoupon", { code, status: newStatus });
    const updateList = (prev: DiscountType[]) =>
      prev.map((item) =>
        item.code === code ? { ...item, enabled: newStatus } : item,
      );
    setAllDiscounts(updateList);
    setFiltered(updateList);
    setItem((prev) =>
      prev?.code === code ? { ...prev, enabled: newStatus } : prev,
    );
  };

  const handleDeletePromo = (id: number) => {
    fetchNui("av_business", "deletePromo", id);
    const updated = allPromos.filter((p) => p.id !== id);
    setAllPromos(updated);
    setFilteredPromos(updated);
    setActivePromo(null);
  };

  const togglePromoStatus = (id: number, current: boolean) => {
    const newStatus = !current;
    fetchNui("av_business", "togglePromo", { id, status: newStatus });
    const update = (prev: PromoType[]) =>
      prev.map((p) => (p.id === id ? { ...p, enabled: newStatus } : p));
    setAllPromos(update);
    setFilteredPromos(update);
    setActivePromo((prev) =>
      prev?.id === id ? { ...prev, enabled: newStatus } : prev,
    );
  };

  const handleFilter = (value: string | null) => {
    setSearch("");
    if (!value) {
      setFiltered(allDiscounts);
      return;
    }
    const results = allDiscounts.filter((item) => {
      switch (value) {
        case "active":
          return item.enabled;
        case "inactive":
          return !item.enabled;
        case "percentage":
          return item.type === "percentage";
        case "amount":
          return item.type === "amount";
        default:
          return true;
      }
    });
    setFiltered(results);
  };

  const handleCreator = async (refresh: boolean) => {
    setShowCreator(false);
    if (!refresh) return;
    if (isPromoView) fetchPromos();
    else fetchData();
  };

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_business", "getDiscounts");
    const data: DiscountType[] = resp || (isEnvBrowser() ? ApiDiscounts : []);
    const sorted = sortAlphabetically(data);
    setAllDiscounts(sorted);
    setFiltered(sorted);
    setTimeout(() => setLoaded(true), 100);
  };

  const fetchPromos = async () => {
    const resp = await fetchNui("av_business", "getPromos");
    const data: PromoType[] = resp || (isEnvBrowser() ? ApiPromos : []);
    setAllPromos(data);
    setFilteredPromos(data);
  };

  useEffect(() => {
    fetchData();
    fetchPromos();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box h="100%" style={{ position: "relative", overflow: "hidden" }}>
      {item && (
        <Box style={{ position: "absolute", inset: 0, zIndex: 100 }}>
          <Panel
            coupon={item}
            handleClose={() => setItem(null)}
            handleDelete={handleDelete}
            toggleStatus={toggleStatus}
            lang={lang}
          />
        </Box>
      )}
      {activePromo && (
        <Box style={{ position: "absolute", inset: 0, zIndex: 100 }}>
          <PromoPanel
            promo={activePromo}
            handleClose={() => setActivePromo(null)}
            handleDelete={handleDeletePromo}
            toggleStatus={togglePromoStatus}
          />
        </Box>
      )}
      {showCreator && (
        <Box style={{ position: "absolute", inset: 0, zIndex: 100 }}>
          <Creator
            handleCreator={handleCreator}
            mode={isPromoView ? "promo" : "coupon"}
          />
        </Box>
      )}

      <Flex direction="column" h="100%" gap="xs">
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
              {isPromoView
                ? `${filteredPromos.length} ${lang.promos ?? "promos"}`
                : `${filtered.length} ${lang.coupons}`}
            </Text>
          </Flex>
          <Group ml="auto">
            {!isPromoView && (
              <Select
                classNames={global}
                size="xs"
                placeholder="Filter by"
                w={wide ? "unset" : 135}
                data={[
                  { value: "active", label: lang.active },
                  { value: "inactive", label: lang.inactive },
                  { value: "percentage", label: lang.percentage },
                  { value: "amount", label: lang.amount },
                ]}
                onChange={handleFilter}
                clearable
              />
            )}
            <TextInput
              classNames={global}
              size="xs"
              w={wide ? "unset" : 135}
              placeholder={daLang.search}
              value={isPromoView ? promoSearch : search}
              onChange={(e) =>
                isPromoView
                  ? handlePromoSearch(e.currentTarget.value)
                  : handleSearch(e.currentTarget.value)
              }
            />
            <SegmentedControl
              classNames={{
                root: global.segRoot,
                indicator: global.segIndicator,
                label: global.segLabel,
              }}
              size="xs"
              value={view}
              onChange={(v) => setView(v as "coupons" | "promos")}
              data={[
                { value: "coupons", label: lang.coupons ?? "Coupons" },
                { value: "promos", label: lang.promos ?? "Promos" },
              ]}
            />
            <Button
              size="xs"
              className={global.button}
              onClick={() => setShowCreator(true)}
            >
              {isPromoView ? (lang.new_promo ?? "New Promo") : lang.new_coupon}
            </Button>
          </Group>
        </Group>

        <ScrollArea
          type="hover"
          scrollbars="y"
          scrollbarSize={6}
          style={{ flex: 1 }}
        >
          {!isPromoView ? (
            <Table
              classNames={classes}
              layout="auto"
              highlightOnHover
              highlightOnHoverColor="rgba(100,100,100,1)"
            >
              <Table.Thead>
                <Table.Tr>
                  <TableHeader
                    sorted={sortBy === "code"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("code")}
                  >
                    {lang.code}
                  </TableHeader>
                  {wide && (
                    <TableHeader
                      sorted={sortBy === "description"}
                      reversed={reverseSortDirection}
                      onSort={() => setSorting("description")}
                    >
                      {lang.description}
                    </TableHeader>
                  )}
                  <TableHeader
                    sorted={sortBy === "discount"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("discount")}
                  >
                    {lang.discount}
                  </TableHeader>
                  {wide && (
                    <TableHeader
                      sorted={sortBy === "employee"}
                      reversed={reverseSortDirection}
                      onSort={() => setSorting("employee")}
                    >
                      {lang.created_by}
                    </TableHeader>
                  )}
                  <TableHeader
                    sorted={sortBy === "redeemed"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("redeemed")}
                  >
                    {lang.redeemed}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "enabled"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("enabled")}
                  >
                    {lang.status}
                  </TableHeader>
                </Table.Tr>
              </Table.Thead>
              <Table.Tbody>
                {filtered.map((coupon) => (
                  <Table.Tr
                    key={coupon.code}
                    style={{ cursor: "pointer" }}
                    onClick={() => setItem(coupon)}
                  >
                    <Table.Td>
                      <Group wrap="nowrap" justify="space-between">
                        <Text fz="xs" c="var(--text-main)" maw={120} truncate>
                          {coupon.code}
                        </Text>
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          onClick={(e) => {
                            e.stopPropagation();
                            fetchNui("av_laptop", "copy", coupon.code);
                          }}
                        >
                          <IconCopy size={13} stroke={1.5} />
                        </ActionIcon>
                      </Group>
                    </Table.Td>
                    {wide && (
                      <Table.Td fz="xs" c="var(--text-dim)">
                        {coupon.description}
                      </Table.Td>
                    )}
                    <Table.Td
                      fz="sm"
                      c={
                        coupon.type === "amount"
                          ? "var(--success)"
                          : "var(--cyan)"
                      }
                      ff="var(--font-display)"
                    >
                      {coupon.type === "amount"
                        ? `$${coupon.discount}`
                        : `${coupon.discount}%`}
                    </Table.Td>
                    {wide && (
                      <Table.Td fz="xs" c="var(--text-dim)">
                        {coupon.employee}
                      </Table.Td>
                    )}
                    <Table.Td fz="sm" ff="var(--font-display)">
                      {`${coupon.redeemed.toLocaleString("en-US")}${coupon.limit ? ` / ${coupon.limit}` : ""}`}
                    </Table.Td>
                    <Table.Td>
                      <Badge
                        color={coupon.enabled ? "green" : "red"}
                        size="xs"
                        variant="light"
                      >
                        {coupon.enabled ? lang.active : lang.inactive}
                      </Badge>
                    </Table.Td>
                  </Table.Tr>
                ))}
              </Table.Tbody>
            </Table>
          ) : (
            <Table
              classNames={classes}
              layout="auto"
              highlightOnHover
              highlightOnHoverColor="rgba(100,100,100,1)"
            >
              <Table.Thead>
                <Table.Tr>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.label ?? "Label"}
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.discount}
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.starts_at ?? "Starts"}
                  </TableHeader>
                  {wide && (
                    <TableHeader
                      sorted={false}
                      reversed={false}
                      onSort={() => {}}
                    >
                      {lang.ends_at ?? "Ends"}
                    </TableHeader>
                  )}
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.status}
                  </TableHeader>
                </Table.Tr>
              </Table.Thead>
              <Table.Tbody>
                {filteredPromos.map((promo) => {
                  const status = promoStatus(promo);
                  return (
                    <Table.Tr
                      key={promo.id}
                      style={{ cursor: "pointer" }}
                      onClick={() => setActivePromo(promo)}
                    >
                      <Table.Td>
                        <Text fz="xs" c="var(--text-main)" maw={150} truncate>
                          {promo.label}
                        </Text>
                      </Table.Td>
                      <Table.Td
                        fz="sm"
                        c={
                          promo.type === "amount"
                            ? "var(--success)"
                            : "var(--cyan)"
                        }
                        ff="var(--font-display)"
                      >
                        {promo.type === "amount"
                          ? `$${promo.discount}`
                          : `${promo.discount}%`}
                      </Table.Td>
                      <Table.Td fz="xs" c="var(--text-dim)">
                        {fmtDate(promo.starts_at)}
                      </Table.Td>
                      {wide && (
                        <Table.Td fz="xs" c="var(--text-dim)">
                          {fmtDate(promo.ends_at)}
                        </Table.Td>
                      )}
                      <Table.Td>
                        <Badge
                          color={STATUS_COLOR[status]}
                          size="xs"
                          variant="light"
                        >
                          {status}
                        </Badge>
                      </Table.Td>
                    </Table.Tr>
                  );
                })}
              </Table.Tbody>
            </Table>
          )}
        </ScrollArea>
      </Flex>
    </Box>
  );
};

export default Discounts;
