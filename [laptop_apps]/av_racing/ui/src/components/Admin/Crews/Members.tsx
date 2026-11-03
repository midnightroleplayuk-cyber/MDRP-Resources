import { useEffect, useState } from "react";
import { Table, ScrollArea, Group, Text, ActionIcon } from "@mantine/core";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { Copy as IconCopy, Trash as IconTrash } from "lucide-react";
import { ApiMembers } from "../../../Api/Members";
import { Member } from "../../../types/types";
import { getRankedLeaderboard } from "../../../hooks/sortbyElo";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  crew: string;
}
export const Members = ({ crew }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allMembers, setAllMembers] = useState<Member[]>([]);

  const handleRemove = (identifier: string) => {
    fetchNui("av_racing", "fireMember", identifier);
    setAllMembers((prev) => {
      return prev.filter((member) => member.identifier !== identifier);
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getMembers", crew);
      if (resp) {
        const ordered = getRankedLeaderboard(resp);
        setAllMembers(ordered as Member[]);
      } else {
        if (isEnvBrowser()) setAllMembers(ApiMembers);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [crew]);

  if (!loaded) return <Loading />;
  return (
    <ScrollArea h={`calc(var(--admin-content-h) - 75px)`} type="hover" scrollbars="y" scrollbarSize={6}>
      <Table layout="auto">
        <Table.Thead>
          <Table.Tr>
            <Table.Th>{lang.identifier}</Table.Th>
            <Table.Th>{lang.nickname}</Table.Th>
            <Table.Th>{lang.grade}</Table.Th>
            <Table.Th>{lang.joined}</Table.Th>
            <Table.Th>{lang.races}</Table.Th>
            <Table.Th>{lang.wins}</Table.Th>
            <Table.Th>{lang.elo}</Table.Th>
            <Table.Th>{lang.actions}</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {allMembers.map((member) => (
            <Table.Tr key={member.identifier}>
              <Table.Td>
                <Group gap="xs">
                  <Text fz="sm" truncate maw={125}>
                    {member.identifier}
                  </Text>
                  <ActionIcon
                    size="xs"
                    variant="transparent"
                    onClick={() => {
                      fetchNui("av_laptop", "copy", member.identifier);
                    }}
                  >
                    <IconCopy style={{ height: 14, width: 14 }} />
                  </ActionIcon>
                </Group>
              </Table.Td>
              <Table.Td>{member.name}</Table.Td>
              <Table.Td>{member.isBoss ? lang.boss : lang.member}</Table.Td>
              <Table.Td>{member.joined}</Table.Td>
              <Table.Td>{member.races}</Table.Td>
              <Table.Td>{member.wins}</Table.Td>
              <Table.Td>
                {member.elo ? member.elo.toLocaleString("en-US") : 0}
              </Table.Td>
              <Table.Td>
                <ActionIcon
                  variant="transparent"
                  color="red"
                  size="xs"
                  onDoubleClick={() => {
                    handleRemove(member.identifier);
                  }}
                >
                  <IconTrash style={{ height: 14, width: 14 }} />
                </ActionIcon>
              </Table.Td>
            </Table.Tr>
          ))}
        </Table.Tbody>
      </Table>
    </ScrollArea>
  );
};
