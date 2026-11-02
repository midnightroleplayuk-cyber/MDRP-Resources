import { useEffect, useState } from "react";
import {
  ScrollArea,
  Text,
  TextInput,
  Group,
  Button,
  Flex,
  Table,
  Avatar,
  ActionIcon,
  Badge,
  Box,
  Modal,
  Image,
  Tooltip,
} from "@mantine/core";
import { IconSearch, IconEdit, IconTrash } from "@tabler/icons-react";
import { ApiEmployees } from "../../../API/employees";
import { Employee, ModalType } from "../../../types/types";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { BusinessInfo, Lang } from "../../../reducers/atoms";
import { Loading } from "../../Loading";
import { TableHeader } from "../../TableHeader/TableHeader";
import { sortEmployeesAlphabetically } from "./helpers";
import { formatString } from "../../../hooks/formatString";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const keysToExclude = ["owner", "isBoss"];

type Grade = { value: string; label: string };
type SortKey = "name" | "grade" | "hours" | "activities" | "generated";

function sortEmployees(
  data: Employee[],
  key: SortKey,
  reversed: boolean,
): Employee[] {
  const sorted = [...data].sort((a, b) => {
    switch (key) {
      case "name":
        return (a.name ?? "").localeCompare(b.name ?? "");
      case "grade":
        return a.grade.level - b.grade.level;
      case "hours":
        return a.hours - b.hours;
      case "activities":
        return a.activities - b.activities;
      case "generated":
        return a.generated - b.generated;
      default:
        return 0;
    }
  });
  return reversed ? sorted.reverse() : sorted;
}

const Employees = () => {
  const mainLang: any = useAtomValue(Lang);
  const lang = mainLang.employees;
  const [loaded, setLoaded] = useState(false);
  const { name } = useAtomValue(BusinessInfo);
  const [allEmployees, setAllEmployees] = useState<Employee[]>([]);
  const [allGrades, setAllGrades] = useState<Grade[]>([]);
  const [allPermissions, setAllPermissions] = useState([]);
  const [search, setSearch] = useState("");
  const [sortBy, setSortBy] = useState<SortKey | null>(null);
  const [reversed, setReversed] = useState(false);
  const [photoSrc, setPhotoSrc] = useState<string | null>(null);
  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: { title: "", options: [] },
  });

  const getVisible = (
    employees: Employee[],
    q: string,
    key: SortKey | null,
    rev: boolean,
  ) => {
    let data = q
      ? employees.filter((e) => e.name?.toLowerCase().includes(q.toLowerCase()))
      : employees;
    if (key) data = sortEmployees(data, key, rev);
    return data;
  };

  const visibleData = getVisible(allEmployees, search, sortBy, reversed);

  const setSorting = (key: SortKey) => {
    const newReversed = key === sortBy ? !reversed : false;
    setReversed(newReversed);
    setSortBy(key);
  };

  function getGradeLabel(gradeName: string | number): string {
    const arr = Array.isArray(allGrades) ? allGrades : [allGrades];
    const match = arr.find((g) => g.value === gradeName);
    return match ? match.label : "N/A";
  }

  const handleEdit = (employee: any) => {
    const identifier = employee.identifier;
    const permissions = { ...employee.permissions };
    const currentPermissions: string[] = Object.keys(permissions).filter(
      (key) => permissions[key] === true && !keysToExclude.includes(key),
    );
    setModal({
      ...modal,
      state: true,
      info: {
        title: employee.name,
        options: [
          {
            type: "image",
            image: employee.image,
            height: 100,
            title: employee.name,
            style: { marginTop: "10px" },
            default: "./user_default.png",
          },
          {
            name: "photo",
            title: lang.photo,
            type: "text",
            default: employee.image,
          },
          {
            name: "grade",
            title: lang.grade,
            type: "select",
            default: String(employee.grade.level),
            options: allGrades,
          },
          {
            name: "permissions",
            title: lang.permissions,
            type: "multiselect",
            default: currentPermissions,
            options: allPermissions,
          },
        ],
        extraData: { event: "updateEmployee", identifier, name },
        button: lang.confirm,
      },
    });
  };

  const modalCallback = async (data?: any) => {
    setModal({ ...modal, state: false });
    if (!data?.extraData) return;
    const { event } = data.extraData;
    const resp = await fetchNui("av_business", event, data);
    if (resp) {
      const base = sortEmployeesAlphabetically(resp);
      setAllEmployees(base);
    }
  };

  const fireEmployee = (employee: any) => {
    const identifier = employee.identifier;
    setModal({
      ...modal,
      state: true,
      info: {
        title: employee.name,
        options: [{ type: "info", description: lang.fireText, size: "sm" }],
        button: lang.confirm,
        extraData: { event: "fireEmployee", identifier, name },
      },
    });
  };

  const handleHire = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_business", "hireEmployee");
    if (resp) setAllEmployees(sortEmployeesAlphabetically(resp));
    setLoaded(true);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getEmployees");
      if (resp) {
        setAllEmployees(sortEmployeesAlphabetically(resp.employees));
        setAllGrades(resp.grades);
        setAllPermissions(resp.allPermissions);
      } else if (isEnvBrowser()) {
        setAllEmployees(sortEmployeesAlphabetically(ApiEmployees));
      }
      setTimeout(() => setLoaded(true), 200);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box h="100%" style={{ overflow: "hidden" }}>
      {modal.state && <ModalMenu data={modal} callback={modalCallback} />}

      <Modal
        opened={!!photoSrc}
        onClose={() => setPhotoSrc(null)}
        centered
        lockScroll={false}
        size="sm"
        padding={0}
        withCloseButton={false}
        styles={{
          body: { padding: 0 },
          content: {
            background: "transparent",
            boxShadow: "none",
            border: "none",
          },
        }}
      >
        <Image src={photoSrc ?? ""} radius="md" fit="contain" mah={420} />
      </Modal>
      <Flex direction="column" h="100%" gap="xs">
        <Group
          bg="var(--bg-card)"
          p="sm"
          style={{
            borderRadius: "6px",
            border: "solid 1px var(--border)",
            flexShrink: 0,
          }}
        >
          <Flex direction="column" gap={2}>
            <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
              {lang.header}
            </Text>
            <Text mt={-12} fz="xs" c="var(--text-dim)">
              {formatString(lang.employees, String(visibleData.length))}
            </Text>
          </Flex>
          <Group ml="auto" gap="xs">
            <TextInput
              classNames={global}
              placeholder={lang.search}
              leftSection={<IconSearch size={14} stroke={1.5} />}
              value={search}
              onChange={(e) => setSearch(e.currentTarget.value)}
              size="xs"
              w={160}
            />
            <Button className={global.button} size="xs" onClick={handleHire}>
              {lang.hire}
            </Button>
          </Group>
        </Group>
        <ScrollArea
          type="hover"
          scrollbars="y"
          scrollbarSize={6}
          style={{ flex: 1 }}
        >
          {visibleData.length === 0 ? (
            <Text fz="sm" c="var(--text-dim)" ta="center" mt="xl">
              {lang.noEmployees ?? "No employees found"}
            </Text>
          ) : (
            <Table
              classNames={classes}
              highlightOnHover
              highlightOnHoverColor="rgba(88,88,184,0.06)"
              layout="auto"
            >
              <Table.Thead>
                <Table.Tr>
                  <TableHeader
                    sorted={sortBy === "name"}
                    reversed={reversed}
                    onSort={() => setSorting("name")}
                  >
                    {lang.employee ?? "Employee"}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "grade"}
                    reversed={reversed}
                    onSort={() => setSorting("grade")}
                  >
                    {lang.grade}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "activities"}
                    reversed={reversed}
                    onSort={() => setSorting("activities")}
                  >
                    {lang.activities}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "hours"}
                    reversed={reversed}
                    onSort={() => setSorting("hours")}
                  >
                    {lang.hours}
                  </TableHeader>
                  <TableHeader
                    sorted={sortBy === "generated"}
                    reversed={reversed}
                    onSort={() => setSorting("generated")}
                  >
                    {lang.monthlyGenerated}
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    Last Seen
                  </TableHeader>
                  <TableHeader
                    sorted={false}
                    reversed={false}
                    onSort={() => {}}
                  >
                    {""}
                  </TableHeader>
                </Table.Tr>
              </Table.Thead>
              <Table.Tbody>
                {visibleData.map((employee) => (
                  <Table.Tr key={employee.identifier}>
                    <Table.Td>
                      <Group gap="sm" wrap="nowrap">
                        <Avatar
                          src={employee.image}
                          size={38}
                          radius="sm"
                          style={{
                            border: "1px solid var(--border)",
                            flexShrink: 0,
                            cursor: "pointer",
                          }}
                          onClick={() => setPhotoSrc(employee.image)}
                        />
                        <Text
                          fz="xs"
                          fw={500}
                          c="var(--text-main)"
                          truncate
                          maw={130}
                        >
                          {employee.name}
                        </Text>
                      </Group>
                    </Table.Td>
                    <Table.Td>
                      <Badge
                        size="xs"
                        radius="sm"
                        variant="light"
                        style={{
                          backgroundColor: "rgba(88,88,184,0.12)",
                          color: "var(--accent-hover)",
                          border: "1px solid rgba(88,88,184,0.2)",
                        }}
                      >
                        {getGradeLabel(String(employee.grade.level))}
                      </Badge>
                    </Table.Td>
                    <Table.Td
                      fz="xs"
                      ff="var(--font-display)"
                      c="var(--text-main)"
                    >
                      {employee.activities}
                    </Table.Td>
                    <Table.Td
                      fz="xs"
                      ff="var(--font-display)"
                      c="var(--text-main)"
                    >
                      {employee.hours}
                    </Table.Td>
                    <Table.Td
                      fz="xs"
                      fw={500}
                      ff="var(--font-display)"
                      c="var(--success)"
                    >
                      {`${mainLang.money_symbol}${(employee.generated ?? 0).toLocaleString("en-US")}`}
                    </Table.Td>
                    <Table.Td fz="xs" c="var(--text-dim)">
                      {employee.lastSeen ?? "---"}
                    </Table.Td>
                    <Table.Td>
                      <Group gap="md" wrap="nowrap" justify="flex-end">
                        <Tooltip
                          label={lang.tooltip_edit}
                          position="top"
                          withArrow
                          fz="xs"
                          color="var(--tooltip)"
                          c="var(--text-main)"
                        >
                          <ActionIcon
                            size="sm"
                            variant="transparent"
                            color="var(--accent-hover)"
                            onClick={() => handleEdit(employee)}
                          >
                            <IconEdit
                              style={{ height: 14, width: 14 }}
                              stroke={1.5}
                            />
                          </ActionIcon>
                        </Tooltip>
                        <Tooltip
                          label={lang.tooltip_fire}
                          position="top"
                          withArrow
                          fz="xs"
                          color="var(--tooltip)"
                          c="var(--text-main)"
                        >
                          <ActionIcon
                            size="sm"
                            variant="transparent"
                            color="var(--danger)"
                            onDoubleClick={() => fireEmployee(employee)}
                          >
                            <IconTrash
                              style={{ height: 14, width: 14 }}
                              stroke={1.5}
                            />
                          </ActionIcon>
                        </Tooltip>
                      </Group>
                    </Table.Td>
                  </Table.Tr>
                ))}
              </Table.Tbody>
            </Table>
          )}
        </ScrollArea>
      </Flex>
    </Box>
  );
};

export default Employees;
