import { Table, Text, ScrollArea, Group, ActionIcon } from "@mantine/core";
import { IconCopy } from "@tabler/icons-react";
import { useEffect, useState } from "react";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { Loading } from "../../../../Loading";
import { PropertyType } from "./types";
import { ApiProperties } from "../../../../../api/Properties";
import { PropertyModal } from "./PropertyModal";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";

interface Properties {
  gang: string;
}

export const Properties = ({ gang }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allProperties, setAllProperties] =
    useState<PropertyType[]>(ApiProperties);
  const [property, setProperty] = useState<PropertyType | null>(null);

  const handleAction = async (
    type: string,
    property: PropertyType,
    data?: any
  ) => {
    const resp = await fetchNui("av_gangs", `admin:${type}`, {
      gang,
      property,
      data,
    });
    if (type == "toggleDoor") {
      setAllProperties((prevProperties) => {
        const index = prevProperties.findIndex(
          (p) => p.identifier === property.identifier
        );
        if (index !== -1) {
          const newProperties = [...prevProperties];
          const newProperty = {
            ...newProperties[index],
            isOpen: !newProperties[index].isOpen,
          };
          newProperties[index] = newProperty;
          return newProperties;
        }
        return prevProperties;
      });
      return;
    }
    if (resp) {
      setAllProperties(resp);
    }
    if (type == "deleteProperty") setProperty(null);
  };

  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "adminProperties", gang);
    if (resp) {
      setAllProperties(resp);
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
    <>
      {property && (
        <PropertyModal
          property={property}
          handleClose={() => {
            setProperty(null);
          }}
          handleAction={handleAction}
        />
      )}
      <ScrollArea
        mt="sm"
        h={480}
        offsetScrollbars
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
      >
        <Table
          highlightOnHover
          highlightOnHoverColor="rgba(30,30,36,1)"
          style={{ cursor: "pointer" }}
        >
          <Table.Thead>
            <Table.Tr>
              <Table.Th>{daLang.identifier}</Table.Th>
              <Table.Th>{daLang.label}</Table.Th>
              <Table.Th>{daLang.type}</Table.Th>
              <Table.Th>{daLang.shell}</Table.Th>
              <Table.Th>{daLang.door}</Table.Th>
              <Table.Th>{daLang.status}</Table.Th>
            </Table.Tr>
          </Table.Thead>
          <Table.Tbody>
            {allProperties.map((property) => (
              <Table.Tr
                key={property.identifier}
                onClick={() => {
                  setProperty(property);
                }}
              >
                <Table.Td>
                  <Group gap="xs">
                    <Text fz="sm" maw={90} truncate>
                      {property.identifier}
                    </Text>
                    <ActionIcon
                      variant="transparent"
                      size="xs"
                      onClick={() => {
                        fetchNui("av_laptop", "copy", property.identifier);
                      }}
                    >
                      <IconCopy style={{ height: "14px", width: "14px" }} />
                    </ActionIcon>
                  </Group>
                </Table.Td>
                <Table.Td>{property.label}</Table.Td>
                <Table.Td>{property.type}</Table.Td>
                <Table.Td>
                  <Text fz="sm" maw={200} truncate>
                    {property.shell}
                  </Text>
                </Table.Td>
                <Table.Td>
                  {property.isOpen ? daLang.open : daLang.closed}
                </Table.Td>
                <Table.Td>{property.working}</Table.Td>
              </Table.Tr>
            ))}
          </Table.Tbody>
        </Table>
      </ScrollArea>
    </>
  );
};
