import {
  Box,
  Flex,
  Group,
  Text,
  Button,
  TextInput,
  Table,
  ScrollArea,
  Badge,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiLoyaltyPromos, LoyaltyPromoType } from "./api";
import { Loading } from "../../Loading";
import { TableHeader } from "../../TableHeader/TableHeader";
import { LoyaltyCreator } from "./Creator";
import { LoyaltyPanel } from "./Panel";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const Loyalty = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.loyalty;
  const [loaded, setLoaded] = useState(false);
  const [promos, setPromos] = useState<LoyaltyPromoType[]>([]);
  const [filtered, setFiltered] = useState<LoyaltyPromoType[]>([]);
  const [search, setSearch] = useState("");
  const [selected, setSelected] = useState<LoyaltyPromoType | null>(null);
  const [showCreator, setShowCreator] = useState(false);

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_business", "getLoyaltyPromos");
    const data: LoyaltyPromoType[] =
      resp || (isEnvBrowser() ? ApiLoyaltyPromos : []);
    setPromos(data);
    setFiltered(data);
    setTimeout(() => setLoaded(true), 100);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleSearch = (input: string) => {
    const q = input.toLowerCase().trim();
    setSearch(q);
    setFiltered(
      q === ""
        ? promos
        : promos.filter((p) => p.name.toLowerCase().includes(q)),
    );
  };

  const handleCreatorClose = (refresh: boolean) => {
    setShowCreator(false);
    if (refresh) fetchData();
  };

  const handleDelete = (id: number) => {
    const updated = promos.filter((p) => p.id !== id);
    setPromos(updated);
    setFiltered(updated);
    setSelected(null);
  };

  const toggleActive = (id: number, current: boolean) => {
    const update = (list: LoyaltyPromoType[]) =>
      list.map((p) => (p.id === id ? { ...p, active: !current } : p));
    setPromos(update);
    setFiltered(update);
    setSelected((prev) =>
      prev?.id === id ? { ...prev, active: !current } : prev,
    );
  };

  if (!loaded) return <Loading />;

  return (
    <Box h="100%" style={{ overflow: "hidden" }}>
      <LoyaltyPanel
        promo={selected}
        opened={selected !== null}
        handleClose={() => setSelected(null)}
        handleDelete={handleDelete}
        toggleActive={toggleActive}
      />
      {showCreator && <LoyaltyCreator handleClose={handleCreatorClose} />}
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
              {filtered.length} {lang.cards}
            </Text>
          </Flex>
          <Group ml="auto">
            <TextInput
              classNames={global}
              size="xs"
              placeholder={daLang.search}
              value={search}
              onChange={(e) => handleSearch(e.currentTarget.value)}
            />
            <Button
              size="xs"
              className={global.button}
              onClick={() => setShowCreator(true)}
            >
              {lang.new_card}
            </Button>
          </Group>
        </Group>
        <ScrollArea
          type="hover"
          scrollbars="y"
          scrollbarSize={6}
          style={{ flex: 1 }}
        >
          {filtered.length === 0 ? (
            <Text fz="sm" c="var(--text-dim)" ta="center" mt="xl">
              {lang.empty}
            </Text>
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
                    {lang.card_name}
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.required_visits}
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
                    {lang.total_printed}
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {lang.total_redeemed}
                  </TableHeader>
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
                {filtered.map((promo) => (
                  <Table.Tr
                    key={promo.id}
                    style={{ cursor: "pointer" }}
                    onClick={() => setSelected(promo)}
                  >
                    <Table.Td>
                      <Text fz="xs" c="var(--text-main)" maw={150} truncate>
                        {promo.name}
                      </Text>
                    </Table.Td>
                    <Table.Td fz="xs" ff="var(--font-display)">
                      {promo.required_visits}
                    </Table.Td>
                    <Table.Td
                      fz="sm"
                      ff="var(--font-display)"
                      c={
                        promo.discount_type === "amount"
                          ? "var(--success)"
                          : "var(--cyan)"
                      }
                    >
                      {promo.discount_type === "amount"
                        ? `$${promo.discount}`
                        : `${promo.discount}%`}
                    </Table.Td>
                    <Table.Td fz="xs" c="var(--text-dim)">
                      {promo.total_printed ?? 0}
                      {promo.max_prints ? ` / ${promo.max_prints}` : ""}
                    </Table.Td>
                    <Table.Td
                      fz="xs"
                      c="var(--success)"
                      ff="var(--font-display)"
                    >
                      {promo.total_redeemed ?? 0}
                    </Table.Td>
                    <Table.Td>
                      <Badge
                        color={promo.active ? "green" : "gray"}
                        size="xs"
                        variant="light"
                      >
                        {promo.active ? lang.active : lang.inactive}
                      </Badge>
                    </Table.Td>
                  </Table.Tr>
                ))}
              </Table.Tbody>
            </Table>
          )}
        </ScrollArea>
      </Flex>
    </Box>
  );
};

export default Loyalty;
