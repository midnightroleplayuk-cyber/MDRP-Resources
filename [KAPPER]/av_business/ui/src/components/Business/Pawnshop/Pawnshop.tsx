import { useEffect, useState } from "react";
import {
  Stack,
  Group,
  Text,
  Flex,
  SimpleGrid,
  Paper,
  TextInput,
  Box,
  ThemeIcon,
  Button,
  Tooltip,
  Modal,
  NumberInput,
  Divider,
  ActionIcon,
} from "@mantine/core";
import { ItemImage } from "../../ItemImage/ItemImage";
import {
  IconSearch,
  IconArrowDownRight,
  IconArrowUpRight,
  IconPackage,
  IconShoppingCart,
  IconCoin,
  IconInfoCircle,
  IconBuildingBank,
  IconInbox,
  IconShieldCheck,
  IconMessageCircle,
} from "@tabler/icons-react";
import { PawnItem } from "../../../API/pawnshop";
import { useAtomValue } from "jotai";
import { Lang, MyPermissions } from "../../../reducers/atoms";
import { Loading } from "../../Loading";
import global from "../../../global.module.css";
import { fetchNui } from "../../../hooks/useNuiEvents";
import classes from "./style.module.css";

const cardStyle = {
  backgroundColor: "var(--bg-card)",
  border: "1px solid var(--border)",
  fontFamily: "var(--font-display)",
};

const PawnShop = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.pawnshop;
  const myPermissions = useAtomValue(MyPermissions);
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [allItems, setAllItems] = useState<PawnItem[]>([]);
  const [fundsModal, setFundsModal] = useState(false);
  const [infoModal, setInfoModal] = useState(false);
  const [globalBalance, setGlobalBalance] = useState<number>(0);
  const [businessBalance, setBusinessBalance] = useState<number>(0);
  const [allocateAmount, setAllocateAmount] = useState<string | number>("");
  const [inventory, setInventory] = useState("");

  const filteredItems = allItems.filter((item) =>
    item.label.toLowerCase().includes(search.toLowerCase()),
  );

  const handleTransferFunds = async (type: "deposit" | "withdraw") => {
    const amount = Number(allocateAmount);
    if (!amount || amount <= 0) return;
    if (type === "deposit") {
      if (amount > globalBalance) return;
      const resp = await fetchNui("av_business", "depositToPawnshop", amount);
      if (!resp) return;
      setGlobalBalance((prev) => prev - amount);
      setBusinessBalance((prev) => prev + amount);
    } else {
      if (amount > businessBalance) return;
      const resp = await fetchNui(
        "av_business",
        "withdrawFromPawnshop",
        amount,
      );
      if (!resp) return;
      setBusinessBalance((prev) => prev - amount);
      setGlobalBalance((prev) => prev + amount);
    }
    setAllocateAmount("");
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getPawnshopData");
      if (resp) {
        setAllItems(resp.items);
        setGlobalBalance(Number(resp.globalBalance));
        setBusinessBalance(Number(resp.businessBalance));
        setInventory(resp.inventory);
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Stack gap="lg" style={{ fontFamily: "var(--font-display)" }}>
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
            {lang.title}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {lang.subtitle}
          </Text>
        </Flex>
        <Group ml="auto" gap="lg">
          <Tooltip
            label={lang.howItWorks}
            position="bottom"
            withArrow
            bg="var(--tooltip)"
            color="var(--text-main)"
            radius="4px"
          >
            <ActionIcon
              size="xs"
              variant="light"
              color="cyan"
              onClick={() => setInfoModal(true)}
              style={{
                backgroundColor: "var(--accent-dim)",
                border: "1px solid var(--border-active)",
              }}
            >
              <IconInfoCircle size={16} />
            </ActionIcon>
          </Tooltip>
          {(myPermissions.isBoss || myPermissions.bank) && (
            <Tooltip
              label={lang.manageFunds}
              position="bottom"
              withArrow
              bg="var(--tooltip)"
              color="var(--text-main)"
              radius="4px"
            >
              <ActionIcon
                size="xs"
                variant="light"
                color="teal"
                onClick={() => setFundsModal(true)}
                style={{
                  backgroundColor: "var(--accent-dim)",
                  border: "1px solid var(--border-active)",
                }}
              >
                <IconBuildingBank size={16} />
              </ActionIcon>
            </Tooltip>
          )}
          <TextInput
            classNames={global}
            ml="auto"
            size="xs"
            placeholder={lang.searchPlaceholder}
            leftSection={<IconSearch size={16} />}
            value={search}
            onChange={(e) => setSearch(e.currentTarget.value)}
            w={255}
          />
        </Group>
      </Group>
      <SimpleGrid cols={{ base: 1, sm: 2, lg: 3, xl: 4 }} spacing="md">
        {filteredItems.map((item) => (
          <Paper key={item.name} p="md" radius="sm" style={cardStyle}>
            <Group wrap="nowrap" align="flex-start" mb="md">
              <Box
                w={60}
                h={60}
                style={{
                  backgroundColor: "var(--bg-input)",
                  borderRadius: "8px",
                  border: "1px solid var(--border)",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  overflow: "hidden",
                }}
              >
                <ItemImage
                  inventory={inventory}
                  name={item.name}
                  image={item.image}
                  w={40}
                  h={40}
                  fit="contain"
                />
              </Box>
              <Box style={{ flex: 1 }}>
                <Text size="md" fw={600} c="var(--text-main)" truncate>
                  {item.label}
                </Text>
                <Group gap={4} mt={4}>
                  <IconPackage size={14} color="var(--text-dim)" />
                  <Text
                    size="xs"
                    c={item.amount > 0 ? "var(--text-dim)" : "var(--danger)"}
                    fw={500}
                  >
                    {item.amount > 0
                      ? `${item.amount} ${lang.stockSuffix}`
                      : lang.outOfStock}
                  </Text>
                </Group>
              </Box>
            </Group>
            <Stack gap="xs" mb="md">
              <Group
                justify="space-between"
                p="xs"
                style={{
                  backgroundColor: "var(--bg-panel)",
                  borderRadius: "4px",
                  border: "1px solid var(--border)",
                }}
              >
                <Group gap={6}>
                  <ThemeIcon size="sm" variant="light" color="var(--danger)">
                    <IconArrowDownRight size={14} />
                  </ThemeIcon>
                  <Text size="xs" c="var(--text-muted)" fw={500}>
                    {lang.suggestedBuy}
                  </Text>
                </Group>
                <Text size="sm" fw={700} c="var(--text-main)">
                  ${item.buyPrice.toLocaleString()}
                </Text>
              </Group>
              <Group
                justify="space-between"
                p="xs"
                style={{
                  backgroundColor: "var(--bg-panel)",
                  borderRadius: "4px",
                  border: "1px solid var(--border)",
                }}
              >
                <Group gap={6}>
                  <ThemeIcon size="sm" variant="light" color="var(--success)">
                    <IconArrowUpRight size={14} />
                  </ThemeIcon>
                  <Text size="xs" c="var(--text-muted)" fw={500}>
                    {lang.suggestedSell}
                  </Text>
                </Group>
                <Text size="sm" fw={700} c="var(--text-main)">
                  ${item.sellPrice.toLocaleString()}
                </Text>
              </Group>
            </Stack>
          </Paper>
        ))}
      </SimpleGrid>
      {filteredItems.length === 0 && (
        <Stack align="center" justify="center" py="xl">
          <ThemeIcon size={64} variant="transparent" color="var(--text-dim)">
            <IconShoppingCart size={48} />
          </ThemeIcon>
          <Text size="md" c="var(--text-dim)" fw={500}>
            {lang.noItemsFound}
          </Text>
        </Stack>
      )}
      <Modal
        classNames={global}
        opened={infoModal}
        onClose={() => setInfoModal(false)}
        title={
          <Text size="sm" fw={700} c="var(--text-main)" tt="uppercase">
            {lang.howItWorksTitle}
          </Text>
        }
        withinPortal
        lockScroll={false}
        centered
        size="md"
      >
        <Stack gap="md" p="xs">
          <Paper
            p="md"
            style={{
              backgroundColor: "var(--bg-card)",
              border: "1px solid var(--border)",
            }}
          >
            <Stack gap="sm">
              <Group wrap="nowrap" align="center">
                <ThemeIcon size="md" variant="light" color="var(--accent)">
                  <IconInbox size={18} />
                </ThemeIcon>
                <Text size="sm" c="var(--text-main)" fw={500}>
                  {lang.step1}
                </Text>
              </Group>
              <Group wrap="nowrap" align="center">
                <ThemeIcon size="md" variant="light" color="var(--accent)">
                  <IconShieldCheck size={18} />
                </ThemeIcon>
                <Text size="sm" c="var(--text-main)" fw={500}>
                  {lang.step2}
                </Text>
              </Group>
              <Group wrap="nowrap" align="center">
                <ThemeIcon size="md" variant="light" color="var(--accent)">
                  <IconMessageCircle size={18} />
                </ThemeIcon>
                <Text size="sm" c="var(--text-main)" fw={500}>
                  {lang.step3}
                </Text>
              </Group>
            </Stack>
          </Paper>
        </Stack>
      </Modal>
      <Modal
        classNames={global}
        opened={fundsModal}
        onClose={() => setFundsModal(false)}
        title={
          <Text size="sm" fw={700} c="var(--text-main)" tt="uppercase">
            {lang.fundsManagement}
          </Text>
        }
        withinPortal
        lockScroll={false}
        centered
        size="sm"
      >
        <Stack gap="md" p="xs">
          <Text fz="xs" c="var(--text-dim)">
            {lang.fundsDesc}
          </Text>
          <Paper
            p="md"
            style={{
              backgroundColor: "var(--bg-card)",
              border: "1px solid var(--border)",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <Group gap="sm">
              <ThemeIcon size="md" variant="light" color="var(--accent)">
                <IconBuildingBank size={18} />
              </ThemeIcon>
              <Text size="xs" c="var(--text-muted)" fw={600} tt="uppercase">
                {lang.businessFunds}
              </Text>
            </Group>
            <Text size="xl" fw={800} c="var(--text-main)">
              {`${daLang.money_symbol}${globalBalance.toLocaleString("en-US")}`}
            </Text>
          </Paper>
          <Paper
            p="md"
            style={{
              backgroundColor: "var(--bg-card)",
              border: "1px solid var(--border)",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <Group gap="sm">
              <ThemeIcon size="md" variant="light" color="var(--orange)">
                <IconCoin size={18} />
              </ThemeIcon>
              <Text size="xs" c="var(--text-muted)" fw={600} tt="uppercase">
                {lang.cashierFunds}
              </Text>
            </Group>
            <Text size="xl" fw={800} c="var(--green)">
              {`${daLang.money_symbol}${businessBalance.toLocaleString("en-US")}`}
            </Text>
          </Paper>
          <Divider
            color="var(--border)"
            label={lang.transferFunds}
            labelPosition="center"
          />
          <NumberInput
            label={lang.amount}
            placeholder="e.g. 10000"
            min={1}
            max={99999999999}
            allowDecimal={false}
            allowLeadingZeros={false}
            allowNegative={false}
            value={allocateAmount}
            onChange={setAllocateAmount}
            thousandSeparator=","
            prefix="$"
            styles={{
              input: {
                backgroundColor: "var(--bg-card)",
                borderColor: "var(--border)",
              },
            }}
          />
          <Group grow mt="xs">
            <Button
              color="green"
              variant="light"
              leftSection={<IconArrowDownRight size={14} />}
              disabled={
                !allocateAmount ||
                Number(allocateAmount) <= 0 ||
                Number(allocateAmount) > globalBalance
              }
              onClick={() => handleTransferFunds("deposit")}
              fw={700}
            >
              {lang.deposit}
            </Button>
            <Button
              color="red"
              variant="light"
              leftSection={<IconArrowUpRight size={14} />}
              disabled={
                !allocateAmount ||
                Number(allocateAmount) <= 0 ||
                Number(allocateAmount) > businessBalance
              }
              onClick={() => handleTransferFunds("withdraw")}
              fw={700}
            >
              {lang.withdraw}
            </Button>
          </Group>
        </Stack>
      </Modal>
    </Stack>
  );
};

export default PawnShop;
