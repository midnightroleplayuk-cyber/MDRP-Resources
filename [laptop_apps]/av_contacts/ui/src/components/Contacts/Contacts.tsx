import {
  Box,
  Text,
  Group,
  Flex,
  Image,
  Table,
  Button,
  ScrollArea,
  Progress,
} from "@mantine/core";
import classes from "./style.module.css";
import { ContactsType } from "../../types/types";
import { useViewportSize } from "@mantine/hooks";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  list: ContactsType[];
  maxLevel: number;
}

export const Contacts = ({ list, maxLevel }: Properties) => {
  const { height } = useViewportSize();
  const lang: any = useRecoilValue(Lang);
  const rows = list.map((contact, index) => (
    <Table.Tr
      key={contact.identifier}
      bg={index % 2 == 0 ? "rgba(43,48,59,0.5)" : "transparent"}
    >
      <Table.Td>
        <Image
          src={contact.avatar}
          fallbackSrc="./user_default.png"
          w={70}
          p="xs"
        />
      </Table.Td>
      <Table.Td c="gray.1" fw={600}>
        {contact.name}
      </Table.Td>
      <Table.Td maw={300} c="gray.5">
        {contact.description}
      </Table.Td>
      <Table.Td miw={height < 750 ? 200 : 250}>
        <Group className={classes.reputation} justify="space-between" p="xs">
          <Progress
            value={
              Math.floor(contact.xp / 100) >=
              (contact.max ? contact.max : maxLevel)
                ? 100
                : contact.xp % 100
            }
            size="sm"
            color="cyan.3"
            style={{ flex: 1 }}
          />
          <Text ml="auto" fz="xs" c="gray.2" fw={600}>
            {`${
              Math.floor(contact.xp / 100) >=
              (contact.max ? contact.max : maxLevel)
                ? lang.max
                : `${lang.level} ${Math.floor(contact.xp / 100)}`
            }`}
          </Text>
        </Group>
      </Table.Td>
      <Table.Td>
        <Button
          variant="light"
          color="cyan.3"
          size="xs"
          onClick={() => {
            fetchNui("av_contacts", "setGPS", contact.coords);
          }}
        >
          {lang.set_gps}
        </Button>
      </Table.Td>
    </Table.Tr>
  ));
  return (
    <Box className={classes.container} p="lg">
      <Group className={classes.header} p="md">
        <Group gap="xs">
          <Image src="./book.png" w={70} />
          <Flex direction="column">
            <Text fz="xl" lh={0.95}>
              {lang.your}
            </Text>
            <Text fz="1.5rem">{lang.contacts}</Text>
          </Flex>
        </Group>
        <Text c="gray.5" maw={300} ml="auto" fz="sm">
          {lang.header_description}
        </Text>
      </Group>
      <ScrollArea
        h={height < 750 ? "calc(75%)" : "calc(82%)"}
        classNames={classes}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={6}
        mt="md"
      >
        <Table withRowBorders={false} layout="auto">
          <Table.Thead bg="rgba(24,27,37,0.25)">
            <Table.Tr>
              <Table.Th w={70} />
              <Table.Th>{lang.name}</Table.Th>
              <Table.Th>{lang.description}</Table.Th>
              <Table.Th>{lang.reputation}</Table.Th>
              <Table.Th>{lang.location}</Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>{rows}</Table.Tbody>
        </Table>
      </ScrollArea>
    </Box>
  );
};
