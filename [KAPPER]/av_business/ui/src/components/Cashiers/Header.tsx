import { Group, Text, Button, Indicator, ActionIcon } from "@mantine/core";
import { IconShoppingCart } from "@tabler/icons-react";

interface SharedProps {
  className: string;
  variant: "filled";
  onClick: () => void;
}

interface Properties {
  cashierId: string;
  isCart: boolean;
  sharedProps: SharedProps;
  cartLength: number;
  isCustomer: boolean;
  daLang: any;
}

export const Header = ({
  cashierId,
  isCart,
  sharedProps,
  cartLength,
  isCustomer,
  daLang,
}: Properties) => {
  const lang = daLang.cashier;
  return (
    <Group bg="var(--blue-800)" p="sm">
      <Group gap="xs">
        <Text fz="md" c="white" fw={500}>
          {lang.header}
        </Text>
        <Text fz="xs">{`#${cashierId.replace(/\D/g, "")}`}</Text>
      </Group>
      {!isCustomer && (
        <>
          {isCart ? (
            <Button
              {...sharedProps}
              ml="auto"
              size="xs"
              fz="10px"
              fw={300}
              c="white"
              h={30}
            >
              {lang.products_button}
            </Button>
          ) : (
            <Indicator
              color="var(--orange-500)"
              inline
              processing
              disabled={cartLength === 0}
              ml="auto"
            >
              <ActionIcon {...sharedProps} w={40} h={30}>
                <IconShoppingCart style={{ height: "14px" }} />
              </ActionIcon>
            </Indicator>
          )}
        </>
      )}
    </Group>
  );
};
