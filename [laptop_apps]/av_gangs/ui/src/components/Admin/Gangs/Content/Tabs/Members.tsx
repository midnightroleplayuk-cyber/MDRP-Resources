import {
  Table,
  Group,
  ActionIcon,
  Tooltip,
  ScrollArea,
  Text,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { ApiMembers } from "../../../../../api/Members";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { Loading } from "../../../../Loading";
import { IconTrash, IconCopy } from "@tabler/icons-react";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";

interface Properties {
  gang: string;
}

export const Members = ({ gang }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allMembers, setAllMembers] = useState(ApiMembers);

  const handleRemove = async (identifier: string) => {
    const resp = await fetchNui("av_gangs", "deleteMember2", {
      gang,
      identifier,
    });
    if (resp) {
      setAllMembers(resp);
    }
  };
  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "adminMembers", gang);
    if (resp) {
      setAllMembers(resp);
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    fetchData();
  }, [gang]);
  if (!loaded) return <Loading />;
  return (
    <ScrollArea
      mt="sm"
      h={480}
      offsetScrollbars
      type="hover"
      scrollbars="y"
      scrollbarSize={5}
    >
      <Table highlightOnHover highlightOnHoverColor="rgba(30,30,36,1)">
        <Table.Thead>
          <Table.Tr>
            <Table.Th>{daLang.identifier}</Table.Th>
            <Table.Th>{daLang.name}</Table.Th>
            <Table.Th>{daLang.alias}</Table.Th>
            <Table.Th>{daLang.rank}</Table.Th>
            <Table.Th>{daLang.joined}</Table.Th>
            <Table.Th>{daLang.actions}</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {allMembers.map((member) => (
            <Table.Tr key={member.identifier}>
              <Table.Td>
                <Group>
                  <Text fz="sm">{member.identifier}</Text>
                  <ActionIcon
                    variant="transparent"
                    size="xs"
                    onClick={() => {
                      fetchNui("av_laptop", "copy", member.identifier);
                    }}
                  >
                    <IconCopy style={{ height: "14px", width: "14px" }} />
                  </ActionIcon>
                </Group>
              </Table.Td>
              <Table.Td>{member.playerName}</Table.Td>
              <Table.Td>{member.alias ?? `N/A`}</Table.Td>
              <Table.Td>{member.rank}</Table.Td>
              <Table.Td>{member.joined}</Table.Td>
              <Table.Td>
                <Tooltip label={daLang.removeMember} color="dark.5">
                  <ActionIcon
                    variant="transparent"
                    color="red"
                    size="xs"
                    onDoubleClick={() => {
                      handleRemove(member.identifier);
                    }}
                  >
                    <IconTrash style={{ height: "14px", width: "14px" }} />
                  </ActionIcon>
                </Tooltip>
              </Table.Td>
            </Table.Tr>
          ))}
        </Table.Tbody>
      </Table>
    </ScrollArea>
  );
};
