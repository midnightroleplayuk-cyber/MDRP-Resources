import {
  Box,
  Group,
  Text,
  Table,
  TextInput,
  Pagination,
  Button,
  Avatar,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import { Member } from "../../../types/types";
import {
  IconSearch,
  IconEdit,
  IconTrash,
  IconCrown,
} from "@tabler/icons-react";
import classes from "./style.module.css";
import global from "../../../global.module.css";
import { useViewportSize } from "@mantine/hooks";
import { useState } from "react";
import { useRecoilValue } from "recoil";
import { Lang, Permissions } from "../../../reducers/atoms";

const getItemsPerPage = (height: number) => {
  if (height >= 954) {
    return 12;
  }
  if (height >= 771) {
    return 8;
  }
  return 4;
};

function paginate<T>(array: T[], page: number, itemsPerPage: number): T[] {
  const startIndex = (page - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  return array.slice(startIndex, endIndex);
}

interface Properties {
  members: Member[];
  handleSearch: (input: string) => void;
  topRanked: string;
  handleEdit: (selected: Member) => void;
  handleRemove: (identifier: string) => void;
  handleInvite: () => void;
}

export const Leaderboard = ({
  members,
  handleSearch,
  topRanked,
  handleEdit,
  handleInvite,
  handleRemove,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const permissions = useRecoilValue(Permissions);
  const { height } = useViewportSize();
  const [activePage, setPage] = useState(1);
  const itemsPerPage = getItemsPerPage(height);
  const totalPages = Math.ceil(members.length / itemsPerPage);
  const paginatedMembers = paginate(members, activePage, itemsPerPage);

  const rows = paginatedMembers.map((member) => (
    <Table.Tr className={classes.row} key={member.identifier}>
      <Table.Td>
        <Group>
          {member.identifier == topRanked && (
            <IconCrown
              style={{ height: "20px", width: "20px" }}
              stroke={1.5}
              color="#ffd43b"
            />
          )}
          <Avatar src={member.photo} ml="auto" />
        </Group>
      </Table.Td>
      <Table.Td>
        {member?.alias?.length > 0 ? member.alias : member.playerName}
      </Table.Td>
      <Table.Td>{member.rank}</Table.Td>
      <Table.Td>{member.joined}</Table.Td>
      <Table.Td>{member.reputation}</Table.Td>
      {(permissions.isBoss || permissions.members) && (
        <>
          <Table.Td>
            <Group>
              <Tooltip label={lang.edit_member} fz="xs" color="dark.5">
                <ActionIcon
                  size="xs"
                  variant="transparent"
                  color="cyan"
                  onClick={() => {
                    handleEdit(member);
                  }}
                >
                  <IconEdit />
                </ActionIcon>
              </Tooltip>
              <Tooltip label={lang.remove_member} fz="xs" color="dark.5">
                <ActionIcon
                  size="xs"
                  variant="transparent"
                  color="red"
                  onDoubleClick={() => {
                    handleRemove(member.identifier);
                  }}
                >
                  <IconTrash />
                </ActionIcon>
              </Tooltip>
            </Group>
          </Table.Td>
        </>
      )}
    </Table.Tr>
  ));

  return (
    <>
      <Group className={classes.card} p="md">
        <Text
          fz="1.3rem"
          c="white"
          ff="Bebas Neue"
          fw={500}
          lts={1.55}
        >{`${members.length} ${lang.memberss}`}</Text>
        <Group ml="auto">
          <TextInput
            classNames={global}
            size="xs"
            placeholder={lang.search}
            leftSection={<IconSearch size={16} stroke={1.5} />}
            onChange={(e) => {
              handleSearch(e.currentTarget.value);
              setPage(1);
            }}
          />
          {(permissions.isBoss || permissions.members) && (
            <Button className={global.button} size="xs" onClick={handleInvite}>
              {lang.invite_member}
            </Button>
          )}
        </Group>
      </Group>
      <Box className={classes.container} mt="sm">
        <Table
          highlightOnHover
          highlightOnHoverColor={"rgba(50, 50, 56, 0.6)"}
          striped
          stripedColor="rgba(30, 30, 36, 0.55)"
        >
          <Table.Thead>
            <Table.Tr>
              <Table.Th w={100} />
              <Table.Th>{lang.alias}</Table.Th>
              <Table.Th>{lang.rank}</Table.Th>
              <Table.Th>{lang.joined}</Table.Th>
              <Tooltip
                multiline
                label={
                  <Text fz="xs" c="gray.4">
                    {lang.rep_description}
                  </Text>
                }
                position="top-start"
                maw={300}
                color="dark.5"
              >
                <Table.Th>Rep</Table.Th>
              </Tooltip>
              {(permissions.isBoss || permissions.members) && (
                <Table.Th>{lang.actions}</Table.Th>
              )}
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>{rows}</Table.Tbody>
        </Table>
      </Box>
      <Group>
        <Pagination
          classNames={classes}
          total={totalPages}
          value={activePage}
          onChange={setPage}
          mt="sm"
          ml="auto"
          color="var(--color-main)"
          size="sm"
        />
      </Group>
    </>
  );
};
