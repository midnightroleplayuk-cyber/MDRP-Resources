import { useEffect, useState } from "react";
import {
  Group,
  Text,
  TextInput,
  Select,
  Button,
  ScrollArea,
  Table,
  Box,
  Flex,
  Badge,
} from "@mantine/core";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { TableHeader } from "../../TableHeader/TableHeader";
import { ApiBilling, ApiPremadeItems } from "../../../API/billing";
import { Loading } from "../../Loading";
import { useAtomValue } from "jotai";
import { IconSearch } from "@tabler/icons-react";
import { Lang, MyPermissions } from "../../../reducers/atoms";
import { sortData } from "./helpers";
import { BillingType } from "../../../types/types";
import { Details } from "./Details";
import { Creator } from "./Creator";
import global from "../../../global.module.css";
import classes from "./style.module.css";

const Billing = ({ isLaptop }: { isLaptop?: boolean }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.billing;
  const permissions = useAtomValue(MyPermissions);
  const [loaded, setLoaded] = useState(false);
  const [allBills, setAllBills] = useState<BillingType[]>([]);
  const [sortedData, setSortedData] = useState<BillingType[]>([]);
  const [items, setItems] = useState(ApiPremadeItems);
  const [search, setSearch] = useState("");
  const [sortBy, setSortBy] = useState<keyof BillingType | null>(null);
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [myIdentifier, setMyIdentifier] = useState("");
  const [showDetails, setShowDetails] = useState<BillingType | null>(null);
  const [showCreator, setShowCreator] = useState(false);

  const options = [
    { value: "paid", label: lang.paid },
    { value: "unpaid", label: lang.pending },
  ];

  useNuiEvent("bills", (data: BillingType[]) => {
    setAllBills(data);
    setSortedData(data);
  });

  const setSorting = (field: keyof BillingType) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setSortedData(sortData(allBills, { sortBy: field, reversed, search }));
  };

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const value = event.currentTarget.value;
    setSearch(value);
    setSortedData(
      sortData(allBills, {
        sortBy,
        reversed: reverseSortDirection,
        search: value,
      }),
    );
  };

  const handleFilter = (type: string | null) => {
    if (!type) {
      setSortedData(allBills);
      return;
    }
    setSortedData(
      allBills.filter((bill) => {
        if (type === "paid") return bill.paid === true;
        if (type === "unpaid") return bill.paid === false;
        return true;
      }),
    );
  };

  const handleDelete = async (identifier: string) => {
    setShowDetails(null);
    const resp = await fetchNui("av_business", "deleteInvoice", identifier);
    if (!resp) return;
    const updated = allBills.filter(
      (invoice) => invoice.invoiceid.trim() !== identifier,
    );
    setAllBills(updated);
    setSortedData(updated);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getBilling");
      if (resp) {
        setAllBills(resp.bills);
        setSortedData(resp.bills);
        setItems(resp.items);
        setMyIdentifier(resp.identifier);
      } else if (isEnvBrowser()) {
        setAllBills(ApiBilling);
        setSortedData(ApiBilling);
      }
      setTimeout(() => setLoaded(true), 200);
    };
    fetchData();
    const onKeyDown = (e: KeyboardEvent) => {
      if (isLaptop) return;
      if (e.code === "Escape") {
        setLoaded(false);
        setTimeout(() => fetchNui("av_business", "closeBillJob"), 200);
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box h="100%" style={{ overflow: "hidden" }}>
      {showCreator && (
        <Creator
          show={setShowCreator}
          items={items}
          daLang={daLang}
          isLaptop={isLaptop}
        />
      )}
      {showDetails && (
        <Details
          close={setShowDetails}
          data={showDetails}
          daLang={daLang}
          isLaptop={isLaptop}
          isBoss={permissions?.isBoss ? true : false}
          identifier={myIdentifier}
          handleDelete={handleDelete}
        />
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
          <Flex direction="column" gap={2}>
            <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
              {lang.header}
            </Text>
            <Text mt={-12} fz="xs" c="var(--text-dim)">
              {`${allBills.length} ${lang.invoices}`}
            </Text>
          </Flex>
          <Group ml="auto" gap="xs">
            <TextInput
              classNames={global}
              placeholder={lang.search}
              leftSection={<IconSearch size={14} stroke={1.5} />}
              value={search}
              onChange={handleSearchChange}
              size="xs"
              w={160}
            />
            <Select
              classNames={global}
              data={options}
              placeholder={lang.filter}
              size="xs"
              w={140}
              onChange={handleFilter}
            />
            <Button
              className={global.button}
              size="xs"
              onClick={() => setShowCreator(true)}
            >
              {lang.new_bill}
            </Button>
          </Group>
        </Group>
        <ScrollArea
          type="hover"
          scrollbars="y"
          scrollbarSize={6}
          style={{ flex: 1 }}
        >
          {sortedData.length === 0 ? (
            <Text fz="sm" c="var(--text-dim)" ta="center" mt="xl">
              {lang.noInvoices ?? "No invoices found"}
            </Text>
          ) : (
            <Table
              classNames={classes}
              highlightOnHover
              highlightOnHoverColor="rgba(88,88,184,0.06)"
              layout="auto"
            >
              <Table.Thead>
                <Table.Tr>
                  <TableHeader
                    sorted={sortBy === "customerName"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("customerName")}
                  >
                    {lang.customer}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "title"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("title")}
                  >
                    {lang.title}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "senderName"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("senderName")}
                  >
                    {lang.employee}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "amount"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("amount")}
                  >
                    {lang.amount}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "issued"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("issued")}
                  >
                    {lang.issued}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "paid"}
                    reversed={reverseSortDirection}
                    onSort={() => setSorting("paid")}
                  >
                    {lang.status}
                  </TableHeader>
                </Table.Tr>
              </Table.Thead>
              <Table.Tbody>
                {sortedData.map((row) => (
                  <Table.Tr
                    key={row.invoiceid}
                    style={{ cursor: "pointer" }}
                    onClick={() => setShowDetails(row)}
                  >
                    <Table.Td fz="xs" c="var(--text-main)">
                      {row.customerName}
                    </Table.Td>
                    <Table.Td fz="xs" c="var(--text-main)">
                      {row.title}
                    </Table.Td>
                    <Table.Td fz="xs" c="var(--text-dim)">
                      {row.senderName}
                    </Table.Td>
                    <Table.Td
                      fz="xs"
                      ff="var(--font-display)"
                      c="var(--success)"
                    >
                      {`${daLang.money_symbol}${(row.amount ?? 0).toLocaleString("en-US")}`}
                    </Table.Td>
                    <Table.Td fz="xs" c="var(--text-dim)">
                      {row.issued}
                    </Table.Td>
                    <Table.Td>
                      <Badge
                        size="xs"
                        radius="sm"
                        variant="light"
                        color={row.paid ? "green" : "yellow"}
                      >
                        {row.paid ? lang.paid : lang.pending}
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

export default Billing;
