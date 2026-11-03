import {
  Card,
  Image,
  Text,
  Group,
  Badge,
  Button,
  ActionIcon,
  Stack,
  Box,
} from "@mantine/core";
import { useHover, useDisclosure } from "@mantine/hooks";
import { Info, Calendar } from "lucide-react";
import { MarketItem } from "../../../../../types/types";
import { Details } from "./Details";
import { Contact } from "./Contact";
import { useTimestamp } from "../../../../../hooks/formatTime";
import { Lang } from "../../../../../reducers/atoms";
import { useAtomValue } from "jotai";
import classes from "./style.module.css";

export const MarketCard = ({ item }: { item: MarketItem }) => {
  const lang: any = useAtomValue(Lang);
  const [detailsOpened, { open: openDetails, close: closeDetails }] =
    useDisclosure(false);
  const [contactOpened, { open: openContact, close: closeContact }] =
    useDisclosure(false);
  const { hovered, ref } = useHover();

  return (
    <>
      {detailsOpened && <Details item={item} close={closeDetails} />}
      {contactOpened && (
        <Contact
          item={item}
          contactOpened={contactOpened}
          closeContact={closeContact}
        />
      )}

      <Card radius="lg" p={0} className={classes.card}>
        <Box className={classes.imageContainer}>
          <Image
            src={item.image}
            alt={item.title}
            className={classes.image}
            ref={ref}
            fallbackSrc="/noimage.png"
            style={{
              filter: hovered ? "none" : "blur(5px)",
            }}
          />
          <Box className={classes.imageOverlay} />
          <Group gap={6} className={classes.tagFloatingGroup}>
            <Badge
              variant="unstyled"
              radius="sm"
              className={classes.tagBadge}
              style={{
                color: `var(--green-light)`,
                border: `1px solid var(--border-light)`,
              }}
            >
              {item.category}
            </Badge>
          </Group>
        </Box>
        <Stack p="lg" justify="space-between" style={{ flex: 1 }}>
          <Box>
            <Group justify="space-between" align="center" wrap="nowrap" mb={10}>
              <Text className={classes.title}>{item.title}</Text>
              <Text
                className={classes.price}
              >{`$${item.price.toLocaleString("en-US")}`}</Text>
            </Group>
            <Text size="sm" lineClamp={2} className={classes.description}>
              {item.description}
            </Text>
          </Box>
          <Box style={{ marginTop: "auto" }}>
            <Group gap={10} mb="md" wrap="nowrap">
              <Button
                className={classes.purchaseButton}
                radius="md"
                onClick={openContact}
              >
                {lang.marketCardContactSeller}
              </Button>
              <ActionIcon
                size={42}
                radius="md"
                variant="unstyled"
                className={classes.bookmarkButton}
                onClick={openDetails}
              >
                <Info size={18} />
              </ActionIcon>
            </Group>
            <Group
              justify="space-between"
              align="center"
              className={classes.footerRow}
            >
              <Text size="xs" className={classes.sellerName}>
                {item.seller}
              </Text>
              <Group gap={4} align="center">
                <Calendar size={13} color="var(--text-hint)" />
                <Text size="xs" className={classes.ratingNumber}>
                  {useTimestamp(item.created_at, "date")}
                </Text>
              </Group>
            </Group>
          </Box>
        </Stack>
      </Card>
    </>
  );
};
