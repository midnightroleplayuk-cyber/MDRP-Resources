import { useEffect, useState } from "react";
import {
  Table,
  Group,
  Text,
  ActionIcon,
  Image,
  Badge,
  Modal,
  Button,
  TextInput,
  Stack,
  Textarea,
  NumberInput,
  ScrollArea,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import { Edit2, Trash2 } from "lucide-react";
import { MarketItem } from "../../../../types/types";
import { Loading } from "../../../Loading";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../hooks/useNuiEvents";
import { useTimestamp } from "../../../../hooks/formatTime";
import { ApiProducts } from "../../../../Api/Products";
import { Lang } from "../../../../reducers/atoms";
import { useAtomValue } from "jotai";

interface Properties {
  search: string;
}

const MyListings = ({ search }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [myAds, setMyAds] = useState<MarketItem[]>([]);
  const [filtered, setFiltered] = useState<MarketItem[]>([]);
  const [editOpened, { open: openEdit, close: closeEdit }] =
    useDisclosure(false);
  const [deleteOpened, { open: openDelete, close: closeDelete }] =
    useDisclosure(false);
  const [selectedItem, setSelectedItem] = useState<MarketItem | null>(null);
  const [editForm, setEditForm] = useState({
    title: "",
    description: "",
    image: "",
    price: 0,
  });

  useNuiEvent("listingUpdated", (listing: MarketItem) => {
    const updated = myAds.map((item) =>
      item.post_id === listing.post_id ? listing : item,
    );
    setMyAds(updated);
    setFiltered(updated);
  });

  useEffect(() => {
    if (search.trim() === "") {
      setFiltered(myAds);
    } else {
      const updated = myAds.filter((item) =>
        item.title.toLowerCase().includes(search.toLowerCase()),
      );
      setFiltered(updated);
    }
  }, [search, myAds]);

  const fetchData = async () => {
    const resp = await fetchNui("av_marketplace", "getMyListings");
    if (resp) {
      setMyAds(resp);
      setFiltered(resp);
    } else {
      if (isEnvBrowser()) {
        setMyAds(ApiProducts);
        setFiltered(ApiProducts);
      }
    }
    setLoaded(true);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleOpenEdit = (item: MarketItem) => {
    setSelectedItem(item);
    setEditForm({
      title: item.title,
      description: item.description,
      image: item.image,
      price: item.price,
    });
    openEdit();
  };

  const handleOpenDelete = (item: MarketItem) => {
    setSelectedItem(item);
    openDelete();
  };

  const submitEdit = async () => {
    if (!selectedItem) return;
    await fetchNui("av_marketplace", "editListing", {
      post_id: selectedItem.post_id,
      ...editForm,
    });
    closeEdit();
  };

  const submitDelete = async () => {
    if (!selectedItem) return;
    await fetchNui("av_marketplace", "deleteListing", {
      post_id: selectedItem.post_id,
    });
    const updated = myAds.filter(
      (item) => item.post_id !== selectedItem.post_id,
    );
    setMyAds(updated);
    setFiltered(updated);
    closeDelete();
  };

  if (!loaded) return <Loading />;

  return (
    <ScrollArea p="md">
      <Table verticalSpacing="sm" horizontalSpacing="md">
        <Table.Thead>
          <Table.Tr>
            <Table.Th style={{ color: "var(--text-hint)", fontWeight: 500 }}>
              {lang.tableItem}
            </Table.Th>
            <Table.Th style={{ color: "var(--text-hint)", fontWeight: 500 }}>
              {lang.tableCategory}
            </Table.Th>
            <Table.Th style={{ color: "var(--text-hint)", fontWeight: 500 }}>
              {lang.tablePrice}
            </Table.Th>
            <Table.Th style={{ color: "var(--text-hint)", fontWeight: 500 }}>
              {lang.tableListedOn}
            </Table.Th>
            <Table.Th
              style={{
                color: "var(--text-hint)",
                fontWeight: 500,
                textAlign: "right",
              }}
            >
              {lang.tableActions}
            </Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {filtered.map((item) => (
            <Table.Tr
              key={item.post_id}
              style={{ borderBottom: "1px solid var(--border-light)" }}
            >
              <Table.Td>
                <Group gap="sm" wrap="nowrap">
                  <Image
                    src={item.image}
                    radius="md"
                    fallbackSrc="/noimage.png"
                    style={{
                      width: 48,
                      height: 48,
                      minWidth: 48,
                      minHeight: 48,
                      flexShrink: 0,
                      border: "1px solid var(--border-light)",
                      objectFit: "cover",
                    }}
                  />
                  <Text
                    size="sm"
                    fw={600}
                    style={{ color: "var(--text-main)" }}
                  >
                    {item.title}
                  </Text>
                </Group>
              </Table.Td>
              <Table.Td>
                <Badge
                  variant="unstyled"
                  radius="sm"
                  style={{
                    backgroundColor: "var(--bg-elevated)",
                    color: "var(--text-secondary)",
                    border: "1px solid var(--border-light)",
                    textTransform: "capitalize",
                  }}
                >
                  {item.category}
                </Badge>
              </Table.Td>
              <Table.Td>
                <Text
                  fw={600}
                  style={{
                    color: "var(--green)",
                    fontFamily: "var(--font-display)",
                    fontSize: 16,
                  }}
                >
                  {`$${item.price.toLocaleString("en-US")}`}
                </Text>
              </Table.Td>
              <Table.Td>
                <DateDisplay timestamp={item.created_at} />
              </Table.Td>
              <Table.Td>
                <Group gap={8} justify="flex-end" wrap="nowrap">
                  <ActionIcon
                    variant="transparent"
                    onClick={() => handleOpenEdit(item)}
                    c="cyan.4"
                  >
                    <Edit2 size={16} />
                  </ActionIcon>
                  <ActionIcon
                    variant="transparent"
                    c="red.4"
                    onClick={() => handleOpenDelete(item)}
                  >
                    <Trash2 size={16} />
                  </ActionIcon>
                </Group>
              </Table.Td>
            </Table.Tr>
          ))}
        </Table.Tbody>
      </Table>

      <Modal
        opened={editOpened}
        onClose={closeEdit}
        title={lang.editListingTitle}
        centered
        radius="lg"
      >
        <Stack gap="md" mt="sm">
          <TextInput
            label={lang.titleLabel}
            value={editForm.title}
            onChange={(e) =>
              setEditForm({ ...editForm, title: e.target.value })
            }
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: { color: "var(--text-secondary)" },
            }}
          />
          <TextInput
            label={lang.imageLabel}
            value={editForm.image}
            onChange={(e) =>
              setEditForm({ ...editForm, image: e.target.value })
            }
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: { color: "var(--text-secondary)" },
            }}
          />
          <NumberInput
            label={lang.priceLabel}
            value={editForm.price}
            min={0}
            max={99999999}
            prefix="$"
            onChange={(e) => setEditForm({ ...editForm, price: Number(e) })}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: { color: "var(--text-secondary)" },
            }}
          />
          <Textarea
            label={lang.descLabel}
            value={editForm.description}
            rows={4}
            maxLength={200}
            onChange={(e) =>
              setEditForm({ ...editForm, description: e.target.value })
            }
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: { color: "var(--text-secondary)" },
            }}
          />

          <Group justify="flex-end" mt="md">
            <Button variant="default" onClick={closeEdit}>
              {lang.cancelBtn}
            </Button>
            <Button
              color="blue"
              onClick={submitEdit}
              style={{ backgroundColor: "var(--accent)" }}
            >
              {lang.saveBtn}
            </Button>
          </Group>
        </Stack>
      </Modal>
      <Modal
        opened={deleteOpened}
        onClose={closeDelete}
        title={lang.confirmDeletionTitle}
        centered
        radius="lg"
      >
        <Text size="sm" style={{ color: "var(--text-muted)" }} mb="xl" mt="sm">
          {lang.confirmDeletionText}
        </Text>
        <Group justify="flex-end">
          <Button variant="default" onClick={closeDelete}>
            {lang.cancelBtn}
          </Button>
          <Button
            color="red"
            onClick={submitDelete}
            style={{ backgroundColor: "var(--red)" }}
          >
            {lang.deleteListingBtn}
          </Button>
        </Group>
      </Modal>
    </ScrollArea>
  );
};

const DateDisplay = ({ timestamp }: { timestamp: number }) => {
  const formatted = useTimestamp(timestamp, "date");
  return (
    <Text size="sm" style={{ color: "var(--text-secondary)" }}>
      {formatted}
    </Text>
  );
};

export default MyListings;
