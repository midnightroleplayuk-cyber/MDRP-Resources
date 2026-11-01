import { useMemo } from "react";
import { useRecoilValue } from "recoil";
import { Stack, Group, Text, Divider, Button, Flex } from "@mantine/core";
import { CartItems, Lang, MoneyAccounts } from "../../reducers/atoms";
import { getCartAccountTotals } from "./utils";
import global from "../../global.module.css";

interface Properties {
  handlePayment: () => void;
}

export const CartSummary = ({ handlePayment }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const cart = useRecoilValue(CartItems);
  const accountTotals = useMemo(() => getCartAccountTotals(cart), [cart]);
  const myAccounts = useRecoilValue(MoneyAccounts);
  const insufficientAccounts = useMemo(() => {
    return accountTotals.filter((total) => {
      const playerAccount = myAccounts.find((a) => a.value === total.name);
      return !playerAccount || playerAccount.amount < total.amount;
    });
  }, [accountTotals, myAccounts]);
  const hasFunds = insufficientAccounts.length === 0;
  return (
    <Stack gap="xs">
      <Divider label={lang.summary_header} labelPosition="center" />
      {accountTotals.map((acc) => (
        <Group key={acc.name} justify="space-between">
          <Text fz="xs" c="dimmed" tt="uppercase" fw={600}>
            {`${lang.total} ${acc.label}`}:
          </Text>
          <Text fz="sm" fw={600} c="var(--primary-200)">
            {acc.amount.toLocaleString("en-US")}
          </Text>
        </Group>
      ))}
      {!hasFunds && (
        <Flex direction="column" mt="md" ta="center">
          <Text fz="sm" c="var(--light)" fw={600}>
            {lang.insufficent_balance}
          </Text>
          <Text fz="sm" c="var(--text-normal)" fw={450}>
            {insufficientAccounts.map((a) => a.label).join(", ")}
          </Text>
        </Flex>
      )}
      <Group justify="center">
        <Button
          className={global.mainButton}
          size="xs"
          w="300px"
          style={{ position: "absolute", bottom: 20 }}
          disabled={cart.length == 0}
          onClick={handlePayment}
        >
          {lang.payment_button}
        </Button>
      </Group>
    </Stack>
  );
};
