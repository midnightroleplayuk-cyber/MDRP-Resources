import { Group, Button, Select } from "@mantine/core";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import { SelectType } from "../../../types/types";
import { fetchNui } from "../../../hooks/useNuiEvents";

interface Properties {
  allJobs: SelectType[];
  job: string | null;
  tab: string;
  setJob: (option: string | null) => void;
  setTab: (option: string) => void;
}

export const Header = ({ allJobs, setJob, job, tab, setTab }: Properties) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const subTabs = [
    { value: "overview", label: lang.home_subtab_overview },
    { value: "zones", label: lang.home_subtab_zones },
    { value: "products", label: lang.home_subtab_products },
  ];
  return (
    <Group>
      <Select
        classNames={global}
        placeholder={lang.select_job}
        size="xs"
        data={allJobs}
        searchable
        onChange={(e) => {
          setJob(e);
        }}
      />
      <Group ml="auto">
        {job && (
          <Select
            classNames={global}
            value={tab}
            size="xs"
            allowDeselect={false}
            data={subTabs}
            onChange={(e) => {
              if (!e) return;
              setTab(e);
            }}
            disabled={job === null}
          />
        )}

        <Button
          className={global.button}
          size="xs"
          onClick={() => {
            fetchNui("av_business", "newZone", job);
          }}
        >
          {lang.home_create_zone}
        </Button>
      </Group>
    </Group>
  );
};
