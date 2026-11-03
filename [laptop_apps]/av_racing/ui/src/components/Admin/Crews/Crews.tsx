import { useEffect, useState } from "react";
import { Group, Select, Stack, Button, SegmentedControl } from "@mantine/core";
import { SelectType } from "../../../types/types";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { Members } from "./Members";
import { Settings } from "./Settings";
import classes from "./styles.module.css";
import global from "../../../global.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  handleNew: () => void;
}

const Crews = ({ handleNew }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [allCrews, setAllCrews] = useState<SelectType[]>([]);
  const [crew, setCrew] = useState<null | SelectType>(null);
  const [tab, setTab] = useState("");

  useNuiEvent("updateCrews", (allCrews: SelectType[]) => {
    setAllCrews(allCrews);
  });

  const handleDelete = (name: string) => {
    setTab("");
    setCrew(null);
    setAllCrews((prev) => {
      return prev.filter((crew) => crew.value !== name);
    });
    fetchNui("av_racing", "deleteCrew", name);
  };

  const handleSelect = (option: string | null) => {
    if (!option) {
      setTab("");
      setCrew(null);
      return;
    }
    const selectedCrew = allCrews.find((crew) => crew.value === option);
    setCrew(selectedCrew || null);
  };

  const fetchData = async () => {
    const resp = await fetchNui("av_racing", "getCrews");
    if (resp) {
      setAllCrews(resp);
    } else {
      if (isEnvBrowser()) {
        setAllCrews([
          { value: "yokai", label: "Yokai Racing Crew" },
          { value: "vagos", label: "Los Santos Vagos Racing" },
        ]);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    if (!loaded) {
      fetchData();
    }
    if (crew) {
      setTab("members");
    }
  }, [crew]);
  if (!loaded) return <Loading />;
  return (
    <>
      <Stack p="sm">
        <Group ml="auto">
          <SegmentedControl
            lts={1}
            classNames={classes}
            value={tab}
            onChange={setTab}
            tt="capitalize"
            data={[
              { label: lang.members, value: "members" },
              { label: lang.settings, value: "settings" },
            ]}
            styles={{
              label: {
                fontSize: "13px",
              },
            }}
            withItemsBorders={false}
            disabled={!crew}
          />
          <Select
            classNames={global}
            data={allCrews}
            size="xs"
            placeholder={lang.select_crew}
            w={155}
            value={crew?.value ?? null}
            onChange={(e) => {
              handleSelect(e);
            }}
          />
          <Button
            size="xs"
            variant="outline"
            color="var(--accent)"
            onClick={handleNew}
          >
            {lang.create_crew}
          </Button>
        </Group>
        {crew && tab == "members" && <Members crew={crew.value} />}
        {crew && tab == "settings" && (
          <Settings crew={crew.value} handleDelete={handleDelete} />
        )}
      </Stack>
    </>
  );
};
export default Crews;
