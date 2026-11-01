import {
  Modal,
  Grid,
  Select,
  TextInput,
  NumberInput,
  Button,
  Textarea,
  Image,
} from "@mantine/core";
import { CategoryType } from "../../../types/types";
import { useState } from "react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  close: () => void;
  allCategories: CategoryType[];
}

export const Creator = ({ close, allCategories }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const tempCategories = allCategories
    .filter((cat) => cat.value !== "all")
    .map((cat) => ({
      label: cat.label,
      value: cat.value,
    }));

  const [product, setProduct] = useState({
    title: "",
    description: "",
    price: 0,
    image: "",
    category: "",
  });

  const handleCreate = () => {
    fetchNui("av_marketplace", "createListing", product);
    close();
  };

  return (
    <>
      <Modal opened onClose={close} title={lang.createListingTitle} centered>
        <Image
          src={product.image}
          alt={product.title}
          fallbackSrc="noimage.png"
          h={200}
        />
        <Grid mt="md" gap="xs">
          <Grid.Col span={6}>
            <TextInput
              classNames={{ input: "input" }}
              size="sm"
              label={lang.titleLabel}
              maxLength={50}
              placeholder={lang.titlePlaceholder}
              mb="sm"
              value={product.title}
              withAsterisk
              onChange={(e) =>
                setProduct({ ...product, title: e.target.value })
              }
            />
          </Grid.Col>
          <Grid.Col span={6}>
            <TextInput
              classNames={{ input: "input" }}
              size="sm"
              label={lang.imageLabel}
              maxLength={200}
              placeholder={lang.imagePlaceholder}
              mb="sm"
              value={product.image}
              onChange={(e) =>
                setProduct({ ...product, image: e.target.value })
              }
            />
          </Grid.Col>
          <Grid.Col span={6}>
            <Select
              classNames={{ input: "input" }}
              size="sm"
              label={lang.categoryLabel}
              withAsterisk
              placeholder={lang.categoryPlaceholder}
              data={tempCategories}
              value={product.category}
              searchable
              allowDeselect={false}
              onChange={(value) =>
                setProduct({ ...product, category: value || "" })
              }
            />
          </Grid.Col>
          <Grid.Col span={6}>
            <NumberInput
              classNames={{ input: "input" }}
              label={lang.priceLabel}
              placeholder={lang.pricePlaceholder}
              withAsterisk
              mb="sm"
              min={0}
              max={9999999999}
              allowDecimal={false}
              allowLeadingZeros={false}
              allowNegative={false}
              prefix="$"
              thousandSeparator=","
              value={product.price}
              onChange={(value) =>
                setProduct({ ...product, price: Number(value) || 0 })
              }
            />
          </Grid.Col>
          <Grid.Col>
            <Textarea
              classNames={{ input: "input" }}
              size="sm"
              label={lang.descLabel}
              placeholder={lang.descPlaceholder}
              mb="sm"
              maxLength={200}
              rows={4}
              value={product.description}
              onChange={(e) =>
                setProduct({ ...product, description: e.target.value })
              }
            />
          </Grid.Col>
        </Grid>
        <Button fullWidth mt="md" onClick={handleCreate}>
          {lang.createListingBtn}
        </Button>
      </Modal>
    </>
  );
};
