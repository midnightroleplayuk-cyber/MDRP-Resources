import { useState, useEffect } from "react";
import { NumberInput, ActionIcon, Group } from "@mantine/core";
import { useDebouncedValue } from "@mantine/hooks";
import { CartType } from "../../types/types";
import { Minus, Plus } from "lucide-react";
import global from "../../global.module.css";

interface Properties {
  product: CartType;
  handleControl: (item: CartType, type: string, amount: number) => void;
  width?: string;
}

export const Modifier = ({ product, handleControl, width }: Properties) => {
  const [localAmount, setLocalAmount] = useState<number | string>(
    product.amount || 1,
  );
  const [debounced] = useDebouncedValue(localAmount, 500);

  useEffect(() => {
    if (product.amount !== undefined && !isNaN(Number(product.amount))) {
      setLocalAmount(product.amount);
    }
  }, [product.amount]);

  useEffect(() => {
    const num = Number(debounced);
    if (debounced !== "" && !isNaN(num) && num !== product.amount) {
      handleControl(product, "set", num);
    }
  }, [debounced]);

  const onStep = (type: "add" | "remove") => {
    const current = Number(localAmount);
    let next = current;

    if (type === "add") {
      next = Math.min(product.stock, current + 1);
    } else {
      next = Math.max(1, current - 1);
    }

    setLocalAmount(next);
    handleControl(product, type, 1);
  };

  return (
    <Group
      gap="sm"
      wrap="nowrap"
      w={width ?? "unset"}
      justify="center"
      ml="auto"
      mr="auto"
    >
      <ActionIcon
        className={global.mainButton}
        size="xs"
        onClick={() => onStep("remove")}
      >
        <Minus size={12} />
      </ActionIcon>
      <NumberInput
        classNames={global}
        allowNegative={false}
        allowDecimal={false}
        min={1}
        max={product.stock}
        value={localAmount === 0 ? "" : localAmount}
        flex={1}
        w={45}
        size="xs"
        hideControls
        styles={{ input: { textAlign: "center" } }}
        onChange={(val) => setLocalAmount(val)}
      />
      <ActionIcon
        className={global.mainButton}
        size="xs"
        onClick={() => onStep("add")}
      >
        <Plus size={12} />
      </ActionIcon>
    </Group>
  );
};
