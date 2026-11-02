import {
  ScrollAreaAutosize,
  Table,
  Text,
  Group,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { IconEdit, IconTrash } from "@tabler/icons-react";
import { TypesInterface } from "./api";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { useEffect, useState } from "react";

export const Types = ({
  itemTypes,
  handleItem,
  search,
}: {
  itemTypes: TypesInterface[];
  handleItem: (item: TypesInterface) => void;
  search: string;
}) => {
  const [filtered, setFiltered] = useState<TypesInterface[]>(itemTypes);
  useEffect(() => {
    if (!search || search.trim() === "") {
      setFiltered(itemTypes);
      return;
    }
    const query = search.toLowerCase().trim();
    const result = itemTypes.filter(
      (item) =>
        item.value.toLowerCase().includes(query) ||
        item.label.toLowerCase().includes(query),
    );
    setFiltered(result);
  }, [search, itemTypes]);

  return (
    <ScrollAreaAutosize h={530} type="hover" scrollbars="y" scrollbarSize={5}>
      <Table>
        <Table.Thead>
          <Table.Tr>
            <Table.Th>Type</Table.Th>
            <Table.Th>Label</Table.Th>
            <Table.Th>Job Restricted</Table.Th>
            <Table.Th>Weight</Table.Th>
            <Table.Th>Event</Table.Th>
            <Table.Th>Remove on use</Table.Th>
            <Table.Th>Actions</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {filtered.map((item) => (
            <Table.Tr key={item.value}>
              <Table.Td>{item.value}</Table.Td>
              <Table.Td>{item.label}</Table.Td>
              <Table.Td>
                <Text
                  size="sm"
                  c="var(--text-dim)"
                  style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                >
                  {item.jobs ? (item.jobs.length > 0 ? `Yes` : "No") : `No`}
                </Text>
              </Table.Td>
              <Table.Td>
                {item.weight ? item.weight.toLocaleString("en-US") : 0}
              </Table.Td>
              <Table.Td>{item.event ?? "No"}</Table.Td>
              <Table.Td>{item.remove ? `Yes` : `No`}</Table.Td>
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
                    label="Delete Type (2 click)"
                    color="var(--tooltip)"
                    fz="xs"
                  >
                    <ActionIcon
                      size="xs"
                      variant="transparent"
                      color="red"
                      onDoubleClick={() => {
                        fetchNui("av_business", "deleteType", item.value);
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
