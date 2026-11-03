import { useEffect, useState } from "react";
import {
  ScrollAreaAutosize,
  Table,
  Text,
  Group,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { IconTrash, IconEdit } from "@tabler/icons-react";
import { ApiWhitelist, WhitelistItems } from "./api";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../hooks/useNuiEvents";
import { sortAlphabetically } from "../../../../hooks/sortArray";
import { Loading } from "../../../Loading";

export const Whitelist = ({
  handleItem,
  search,
}: {
  handleItem: (item: WhitelistItems) => void;
  search: string;
}) => {
  const [loaded, setLoaded] = useState(false);
  const [whitelisted, setWhitelisted] = useState<WhitelistItems[]>([]);
  const [filtered, setFiltered] = useState<WhitelistItems[]>([]);

  useNuiEvent("whitelisted", (data: WhitelistItems[]) => {
    const sorted = sortAlphabetically(data);
    setWhitelisted(sorted);
  });

  useEffect(() => {
    const fetchData = async () => {
      const resp: WhitelistItems[] = await fetchNui(
        "av_business",
        "getSettings",
        "whitelist",
      );
      if (resp) {
        const sorted = sortAlphabetically(resp);
        setWhitelisted(sorted);
      } else {
        if (isEnvBrowser()) {
          setWhitelisted(ApiWhitelist);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  useEffect(() => {
    if (!search || search.trim() === "") {
      setFiltered(whitelisted);
      return;
    }
    const query = search.toLowerCase().trim();
    const result = whitelisted.filter(
      (item) =>
        item.value.toLowerCase().includes(query) ||
        item.label.toLowerCase().includes(query),
    );
    setFiltered(result);
  }, [search, whitelisted]);
  if (!loaded) return <Loading />;
  return (
    <ScrollAreaAutosize
      h={530}
      type="hover"
      scrollbars="y"
      scrollbarSize={5}
      mx="auto"
    >
      <Table layout="fixed">
        <Table.Thead>
          <Table.Tr>
            <Table.Th>Name</Table.Th>
            <Table.Th>Label</Table.Th>
            <Table.Th>Types</Table.Th>
            <Table.Th>Allowed Jobs</Table.Th>
            <Table.Th>Override</Table.Th>
            <Table.Th>Actions</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {filtered.map((item) => (
            <Table.Tr key={item.value}>
              <Table.Td>
                <Text fz="sm" truncate maw={200}>
                  {item.value}
                </Text>
              </Table.Td>
              <Table.Td>
                <Text fz="sm" truncate maw={200}>
                  {item.label}
                </Text>
              </Table.Td>
              <Table.Td tt="capitalize">
                <Text
                  size={item.type.length > 3 ? "xs" : "sm"}
                  c="var(--text-dim)"
                  style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                >
                  {item.type.length > 0 ? item.type.join(", ") : "No Types"}
                </Text>
              </Table.Td>
              <Table.Td>
                <Text
                  size="sm"
                  c="var(--text-dim)"
                  style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                >
                  {item.jobs.length > 0 ? item.jobs.length : "No"}
                </Text>
              </Table.Td>
              <Table.Td>{item.override ? `Yes` : `No`}</Table.Td>
              <Table.Td>
                <Group>
                  <Tooltip label="Edit Item" color="var(--tooltip)" fz="xs">
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="cyan"
                      onClick={() => {
                        handleItem(item);
                      }}
                    >
                      <IconEdit
                        style={{ height: 14, width: 14 }}
                        stroke={1.55}
                      />
                    </ActionIcon>
                  </Tooltip>
                  <Tooltip
                    label="Delete Product (2 click)"
                    color="var(--tooltip)"
                    fz="xs"
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="red"
                      onDoubleClick={() => {
                        fetchNui(
                          "av_business",
                          "deleteWhitelisted",
                          item.value,
                        );
                      }}
                    >
                      <IconTrash
                        style={{ height: 14, width: 14 }}
                        stroke={1.55}
                      />
                    </ActionIcon>
                  </Tooltip>
                </Group>
              </Table.Td>
            </Table.Tr>
          ))}
        </Table.Tbody>
      </Table>
    </ScrollAreaAutosize>
  );
};
