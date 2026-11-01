import { useEffect, useState } from "react";
import {
  Select,
  Group,
  Text,
  TextInput,
  Box,
  Transition,
  Table,
  Avatar,
  Badge,
  ActionIcon,
  Tooltip,
  ScrollArea,
  Modal,
  Image,
} from "@mantine/core";
import { Trash2, Copy } from "lucide-react";
import { Header } from "./Header";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { MarketItem, SelectType } from "../../types/types";
import { ApiProducts } from "../../Api/Products";
import { ApiCategories } from "../../Api/Categories";
import classes from "./style.module.css";

export const Admin = () => {
  const [loaded, setLoaded] = useState(false);
  const [allCategories, setAllCategories] = useState<SelectType[]>([]);
  const [allListings, setAllListings] = useState<MarketItem[]>([]);
  const [filtered, setFiltered] = useState<MarketItem[]>([]);
  const [search, setSearch] = useState("");
  const [previewImg, setPreviewImg] = useState<string | null>(null);

  const handleFilter = (category: string | null) => {
    const base = category
      ? allListings.filter((l) => l.category === category)
      : allListings;
    setFiltered(base);
  };

  const handleSearch = (query: string) => {
    setSearch(query);
    const q = query.toLowerCase();
    setFiltered(
      allListings.filter(
        (l) =>
          l.title.toLowerCase().includes(q) ||
          l.seller.toLowerCase().includes(q) ||
          l.owner.toLowerCase().includes(q) ||
          l.category.toLowerCase().includes(q),
      ),
    );
  };

  const handleDelete = async (post_id: string) => {
    await fetchNui("av_marketplace", "adminDeleteListing", post_id);
    const updated = allListings.filter((l) => l.post_id !== post_id);
    setAllListings(updated);
    setFiltered(updated);
  };

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      if (previewImg) {
        setPreviewImg(null);
        return;
      }
      setLoaded(false);
      setTimeout(() => fetchNui("av_marketplace", "closeAdmin"), 250);
    }
  };

  useEffect(() => {
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [previewImg]);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_marketplace", "adminGetListings");
      if (resp) {
        setAllListings(resp.listings);
        setFiltered(resp.listings);
        setAllCategories(resp.categories);
      } else if (isEnvBrowser()) {
        setAllListings(ApiProducts);
        setFiltered(ApiProducts);
        setAllCategories(ApiCategories);
      }
      setTimeout(() => setLoaded(true), 200);
    };
    fetchData();
  }, []);

  const rows = filtered.map((listing) => (
    <Table.Tr key={listing.post_id}>
      <Table.Td>
        <Group gap="sm" wrap="nowrap">
          <Tooltip label="Click to preview" position="right" withArrow>
            <Avatar
              src={listing.image}
              size={32}
              radius="sm"
              style={{ cursor: "pointer" }}
              onClick={() => setPreviewImg(listing.image)}
            />
          </Tooltip>
          <Text size="sm" fw={500} c="var(--text-main)" lineClamp={1}>
            {listing.title}
          </Text>
        </Group>
      </Table.Td>
      <Table.Td>
        <Badge
          variant="light"
          size="sm"
          color="var(--accent)"
          style={{
            background: "var(--accent-bg)",
            color: "var(--accent-light)",
          }}
        >
          {listing.category}
        </Badge>
      </Table.Td>
      <Table.Td>
        <Text size="sm" c="var(--text-muted)">
          {listing.seller}
        </Text>
      </Table.Td>
      <Table.Td>
        <Text size="sm" fw={600} ff="var(--font-display)" c="var(--green)">
          ${listing.price.toLocaleString()}
        </Text>
      </Table.Td>
      <Table.Td>
        <Text size="xs" c="var(--text-hint)">
          {new Date(listing.created_at * 1000).toLocaleDateString()}
        </Text>
      </Table.Td>
      <Table.Td>
        <Group gap="sm">
          <Tooltip label="Copy Player Identifier" position="left" withArrow>
            <ActionIcon
              variant="transparent"
              size="sm"
              c="cyan"
              onClick={() => fetchNui("av_laptop", "copy", listing.owner)}
            >
              <Copy size={15} />
            </ActionIcon>
          </Tooltip>
          <Tooltip label="Delete listing (2 click)" position="left" withArrow>
            <ActionIcon
              variant="transparent"
              size="sm"
              onDoubleClick={() => handleDelete(listing.post_id)}
              c="red"
            >
              <Trash2 size={15} />
            </ActionIcon>
          </Tooltip>
        </Group>
      </Table.Td>
    </Table.Tr>
  ));

  return (
    <Box className={classes.container}>
      <Modal
        opened={!!previewImg}
        onClose={() => setPreviewImg(null)}
        centered
        withCloseButton={false}
        padding={0}
        size="lg"
        styles={{
          content: { background: "transparent", boxShadow: "none" },
          overlay: { backdropFilter: "blur(6px)" },
        }}
      >
        <Image
          src={previewImg ?? ""}
          radius="md"
          fit="contain"
          mah={800}
          onClick={() => setPreviewImg(null)}
          style={{ cursor: "zoom-out" }}
        />
      </Modal>

      <Transition
        mounted={loaded}
        transition="fade-down"
        duration={500}
        exitDuration={500}
        timingFunction="ease"
      >
        {(styles) => (
          <Box className={classes.box} style={styles}>
            <Header />
            <Group p="sm" mb="xs">
              <Text fz="xs" c="dimmed">
                Manage all active listings on the server.
              </Text>
              <Group ml="auto">
                <Select
                  placeholder="Filter by category"
                  size="xs"
                  data={allCategories}
                  onChange={handleFilter}
                  clearable
                  searchable
                />
                <TextInput
                  size="xs"
                  placeholder="Search title, seller..."
                  value={search}
                  onChange={(e) => handleSearch(e.target.value)}
                />
              </Group>
            </Group>
            <ScrollArea h={475} mx="sm">
              <Table
                highlightOnHover
                verticalSpacing="sm"
                styles={{
                  table: { fontSize: "13px" },
                  th: {
                    color: "var(--text-hint)",
                    fontWeight: 500,
                    fontSize: "11px",
                    letterSpacing: "0.5px",
                    textTransform: "uppercase",
                    borderColor: "var(--border-light)",
                  },
                  td: { borderColor: "var(--border-light)" },
                  tr: { backgroundColor: "transparent" },
                }}
              >
                <Table.Thead>
                  <Table.Tr>
                    <Table.Th>Listing</Table.Th>
                    <Table.Th>Category</Table.Th>
                    <Table.Th>Seller</Table.Th>
                    <Table.Th>Price</Table.Th>
                    <Table.Th>Listed</Table.Th>
                    <Table.Th></Table.Th>
                  </Table.Tr>
                </Table.Thead>
                <Table.Tbody>
                  {rows.length > 0 ? (
                    rows
                  ) : (
                    <Table.Tr>
                      <Table.Td colSpan={6}>
                        <Text
                          ta="center"
                          size="sm"
                          c="var(--text-hint)"
                          py="xl"
                        >
                          No listings found.
                        </Text>
                      </Table.Td>
                    </Table.Tr>
                  )}
                </Table.Tbody>
              </Table>
            </ScrollArea>
          </Box>
        )}
      </Transition>
    </Box>
  );
};
