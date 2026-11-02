import {
  Stack,
  Group,
  Text,
  Button,
  TextInput,
  ScrollAreaAutosize,
  Table,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { AnimType, ApiAnimations } from "./api";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { sortAlphabetically } from "../../../hooks/sortArray";
import { SelectType } from "../../../types/types";
import { TypesInterface } from "../Items/Types/api";
import { IconEdit, IconTrash, IconCopy } from "@tabler/icons-react";
import { Panel } from "./Panel";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";

const Animations = ({
  allJobs,
  itemTypes,
}: {
  allJobs: SelectType[];
  itemTypes: TypesInterface[];
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [settings, setSettings] = useState<AnimType[]>([]);
  const [filtered, setFiltered] = useState<AnimType[]>([]);
  const [current, setCurrent] = useState<AnimType | null>(null);
  const [panel, setPanel] = useState(false);

  const handleSearch = (input: string) => {
    const res = settings.filter(
      (item) =>
        (item.value ? item.value.toLowerCase().includes(input) : false) ||
        (item.label ? item.label.toLowerCase().includes(input) : false),
    );
    setFiltered(res);
  };

  const deleteItem = (name: string) => {
    const resp = settings.filter((item) => item.value !== name);
    setSettings(resp);
    setFiltered(resp);
    fetchNui("av_business", "updateSettings", {
      type: "animations",
      settings: resp,
    });
  };

  const handleSave = (item: AnimType) => {
    let updatedSettings = [...settings];
    const exists = settings.some((s) => s.value === item.value);
    if (exists) {
      updatedSettings = settings.map((s) =>
        s.value === item.value ? item : s,
      );
    } else {
      updatedSettings = [...settings, item];
    }
    setSettings(updatedSettings);
    setFiltered(updatedSettings);
    setPanel(false);
    fetchNui("av_business", "updateSettings", {
      type: "animations",
      settings: updatedSettings,
    });
  };

  const cloneItem = (item: AnimType) => {
    setCurrent({
      ...JSON.parse(JSON.stringify(item)),
      value: "",
      label: item.label + " (Copy)",
    });
    setPanel(true);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getSettings", "animations");
      if (resp) {
        const sorted: AnimType[] = sortAlphabetically(resp);
        setSettings(sorted);
        setFiltered(sorted);
      } else {
        if (isEnvBrowser()) {
          const sorted: AnimType[] = sortAlphabetically(ApiAnimations);
          setSettings(sorted);
          setFiltered(sorted);
        }
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
          allJobs={allJobs}
          close={() => {
            setPanel(false);
            setCurrent(null);
          }}
          handleSave={handleSave}
          itemTypes={itemTypes}
          item={current}
        />
      )}
      <Stack>
        <Group>
          <Text
            fz="xs"
            maw={400}
            style={{ wordBreak: "break-word" }}
            c="var(--text-dim)"
            lts={0.55}
          >
            {lang.anims_desc}
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
                setPanel(true);
              }}
            >
              {lang.anims_add}
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
                <Table.Th>{lang.name}</Table.Th>
                <Table.Th>{lang.label}</Table.Th>
                <Table.Th>{lang.anims_types}</Table.Th>
                <Table.Th>{lang.job_restricted}</Table.Th>
                <Table.Th>{lang.anims_prop}</Table.Th>
                <Table.Th>{lang.actions}</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {filtered.map((item) => (
                <Table.Tr key={item.value}>
                  <Table.Td>{item.value}</Table.Td>
                  <Table.Td>{item.label}</Table.Td>
                  <Table.Td tt="capitalize">
                    <Text
                      size={item.type.length > 3 ? "xs" : "sm"}
                      c="var(--text-dim)"
                      style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                    >
                      {item.type.length > 0 ? item.type.join(", ") : lang.anims_no_types}
                    </Text>
                  </Table.Td>
                  <Table.Td>
                    <Text
                      size="sm"
                      c="var(--text-dim)"
                      style={{ wordBreak: "break-word", whiteSpace: "normal" }}
                    >
                      {item?.jobs ? item.jobs.length > 0 && lang.yes : lang.no}
                    </Text>
                  </Table.Td>
                  <Table.Td>{item.prop ? lang.yes : lang.no}</Table.Td>
                  <Table.Td>
                    <Group>
                      <Tooltip
                        label={lang.anims_clone_tip}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="violet"
                          onClick={() => cloneItem(item)}
                        >
                          <IconCopy
                            style={{ height: 14, width: 14 }}
                            stroke={1.55}
                          />
                        </ActionIcon>
                      </Tooltip>
                    <Tooltip
                        label={lang.anims_edit_tip}
                        color="var(--tooltip)"
                        fz="xs"
                      >
                        <ActionIcon
                          size="xs"
                          variant="transparent"
                          color="cyan"
                          onClick={() => {
                            setCurrent(item);
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
                        label={lang.anims_delete_tip}
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

export default Animations;
