import { Stack, Select, Text, Group, Avatar, Button, Box } from "@mantine/core";
import { Trophy } from "lucide-react";
import { useRecoilValue } from "recoil";
import { Classes, Lang } from "../../reducers/atoms";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { RecordsType } from "../../types/types";
import { ApiRecords } from "../../Api/Records";
import { Loading } from "../Loading";
import { isWide } from "../../hooks/isWide";
import global from "../../global.module.css";
import localClasses from "./style.module.css";

interface Properties {
  isAdmin: boolean;
  identifier: string;
  records?: RecordsType;
}

export const RecordComponent = ({
  identifier,
  isAdmin,
  records,
}: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const classes = useRecoilValue(Classes);
  const filteredClasses = classes.filter((item) => item.value !== "all");
  const [loaded, setLoaded] = useState(false);
  const [allRecords, setAllRecords] = useState<RecordsType>({});
  const [currentClass, setCurrentClass] = useState("");
  const wide = isWide();

  const sortedRecords =
    currentClass && allRecords[currentClass]
      ? [...allRecords[currentClass]].sort(
          (a, b) => a.miliseconds - b.miliseconds,
        )
      : [];

  const handleSelect = (type: string | null) => {
    setCurrentClass(type ? type.toUpperCase() : "");
  };

  const handleClear = async () => {
    const cloned: RecordsType = { ...allRecords };
    if (Object.prototype.hasOwnProperty.call(cloned, currentClass)) {
      delete cloned[currentClass];
    }
    setAllRecords(cloned);
    setLoaded(false);
    await fetchNui("av_racing", "updateRecords", {
      identifier,
      records: cloned,
    });
    setLoaded(true);
  };

  useEffect(() => {
    if (records) {
      setAllRecords(records);
      setLoaded(true);
      return;
    }
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getRecords", identifier);
      if (resp) {
        setAllRecords(resp);
      } else {
        if (isEnvBrowser()) setAllRecords(ApiRecords);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [identifier, records]);

  if (!loaded && isAdmin) return <Loading />;

  return (
    <Stack gap="md">
      <Select
        classNames={global}
        data={filteredClasses}
        size="xs"
        placeholder={lang.class_type ?? "Class Type"}
        onChange={(e) => {
          handleSelect(e);
        }}
      />
      <Stack gap="xs">
        {sortedRecords.map((element, index) => {
          const isFirst = index === 0;
          return (
            <Group
              key={`${currentClass}-${element.name}`}
              className={`${localClasses.recordCard} ${
                isFirst ? localClasses.firstPlace : ""
              }`}
              wrap="nowrap"
            >
              <Box className={localClasses.rankContainer}>
                {isFirst ? (
                  <Trophy size={18} className={localClasses.goldIcon} />
                ) : (
                  <Text className={localClasses.rank}>#{index + 1}</Text>
                )}
              </Box>
              <Group gap="sm" style={{ flex: 1, minWidth: 0 }} wrap="nowrap">
                {wide && <Avatar src={element.photo} size={38} radius="xl" />}
                <Stack gap={0} style={{ minWidth: 0 }}>
                  <Text className={localClasses.racerName}>{element.name}</Text>
                  <Text className={localClasses.crewName}>
                    {element.crew || (lang.no_crew ?? "N/A")}
                  </Text>
                </Stack>
              </Group>
              <Text className={localClasses.vehicle} visibleFrom="sm">
                {element.vehicle}
              </Text>
              <Box className={localClasses.timeContainer}>
                <Text className={localClasses.time}>{element.bestTime}</Text>
              </Box>
            </Group>
          );
        })}
        {sortedRecords.length === 0 && currentClass && (
          <Text ta="center" c="var(--text-dim)" fz="sm" mt="md">
            {lang.no_records ?? "No records found for this class."}
          </Text>
        )}
      </Stack>
      {isAdmin && sortedRecords.length > 0 && (
        <Group justify="center" mt="md">
          <Button
            color="red"
            variant="subtle"
            size="xs"
            onDoubleClick={() => {
              handleClear();
            }}
          >
            {lang.clear_button ?? "CLEAR RECORDS"}
          </Button>
        </Group>
      )}
    </Stack>
  );
};
