import { useEffect, useState } from "react";
import {
  Stack,
  ScrollAreaAutosize,
  Table,
  Text,
  Group,
  Tooltip,
  ActionIcon,
  TextInput,
  Button,
} from "@mantine/core";
import { IconEdit, IconTrash } from "@tabler/icons-react";
import { Loading } from "../../Loading";
import { Panel } from "./Panel";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { SelectType } from "../../../types/types";
import { ApiPermissions, PermissionsType } from "./api";
import { sortAlphabetically } from "../../../hooks/sortArray";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";

const Permissions = ({ allJobs }: { allJobs: SelectType[] }) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [permissions, setPermissions] = useState<PermissionsType[]>([]);
  const [filtered, setFiltered] = useState<PermissionsType[]>([]);
  const [permission, setPermission] = useState<PermissionsType | null>(null);
  const [panel, setPanel] = useState(false);

  const handleSearch = (input: string) => {
    const res = permissions.filter(
      (permission) =>
        (permission.value
          ? permission.value.toLowerCase().includes(input)
          : false) ||
        (permission.label
          ? permission.label.toLowerCase().includes(input)
          : false),
    );
    setFiltered(res);
  };
  const deleteItem = (name: string) => {
    const resp = permissions.filter((permission) => permission.value !== name);
    setPermissions(resp);
    setFiltered(resp);
    fetchNui("av_business", "updateSettings", {
      type: "permissions",
      settings: resp,
    });
  };

  const handleSave = (item: PermissionsType) => {
    let updatedSettings = [...permissions];
    const exists = permissions.some((s) => s.value === item.value);
    if (exists) {
      updatedSettings = permissions.map((s) =>
        s.value === item.value ? item : s,
      );
    } else {
      updatedSettings = [...permissions, item];
    }
    setPermissions(updatedSettings);
    setFiltered(updatedSettings);
    setPanel(false);
    fetchNui("av_business", "updateSettings", {
      type: "permissions",
      settings: updatedSettings,
    });
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "permissions");
      if (resp) {
        setPermissions(sortAlphabetically(resp));
        setFiltered(sortAlphabetically(resp));
      } else {
        setPermissions(sortAlphabetically(ApiPermissions));
        setFiltered(sortAlphabetically(ApiPermissions));
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      {panel && (
        <Panel
          permission={permission}
          allJobs={allJobs}
          close={() => {
            setPanel(false);
            setPermission(null);
          }}
          handleSave={handleSave}
        />
      )}
      <Stack>
        <Group justify="space-between">
          <Text
            fz="xs"
            style={{ wordBreak: "break-word" }}
            c="var(--text-dim)"
            w={450}
            lts={0.55}
            maw={"80%"}
          >
            Configure business role permissions to define which employees can
            access specific management tools and operational features.
          </Text>
          <Group ml="auto">
            <TextInput
              classNames={global}
              size="xs"
              placeholder={lang.search}
              onChange={(e) => {
                handleSearch(e.currentTarget.value);
              }}
            />
            <Button
              className={global.button}
              size="xs"
              onClick={() => {
                setPermission(null);
                setPanel(true);
              }}
            >
              New Permission
            </Button>
          </Group>
        </Group>
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
                <Table.Th>Permission</Table.Th>
                <Table.Th>Label</Table.Th>
                <Table.Th>Job Restricted</Table.Th>
                <Table.Th>Default</Table.Th>
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
                  <Table.Td>{item.default ? `Yes` : `No`}</Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip label={lang.perms_edit_tip} color="var(--tooltip)" fz="xs">
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="cyan"
                          onClick={() => {
                            setPermission(item);
                            setPanel(true);
                          }}
                        >
                          <IconEdit
                            style={{ height: 14, width: 14 }}
                            stroke={1.55}
                          />
                        </ActionIcon>
                      </Tooltip>
                      <Tooltip
                        label={lang.perms_delete_tip}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="red"
                          onDoubleClick={() => {
                            deleteItem(item.value);
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
      </Stack>
    </>
  );
};

export default Permissions;
