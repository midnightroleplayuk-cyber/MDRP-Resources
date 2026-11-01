import { useEffect, useMemo, useState } from "react";
import { Accordion } from "@mantine/core";
import { AccordionResults } from "./AccordionResults";
import { GetTrackType } from "../../../../../hooks/getTrackType";
import { useRecoilValue } from "recoil";
import { Categories, Lang } from "../../../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../../../hooks/useNuiEvents";
import { ApiResults } from "../../../../../Api/Results";
import { EventResult } from "../../../../../types/types";
import { Loading } from "../../../../Loading";
import classes from "./style.module.css";

interface Properties {
  search: string;
  category: string;
  vehClass: string;
}

export const Results = ({ search, category, vehClass }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [oldEvents, setOldEvents] = useState<EventResult[]>([]);
  const categories = useRecoilValue(Categories);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getResults");
      if (resp) {
        setOldEvents(resp);
      } else {
        if (isEnvBrowser()) {
          setOldEvents(ApiResults);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  const filteredEvents = useMemo(() => {
    if (!search && !category && !vehClass) {
      return oldEvents;
    }

    return oldEvents.filter((event) => {
      const matchesSearch =
        !search || event.eventName.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = !category || event.type === category;
      const matchesClass = !vehClass || event.class.toLowerCase() === vehClass;
      return matchesSearch && matchesCategory && matchesClass;
    });
  }, [oldEvents, search, category, vehClass]);

  if (!loaded) return <Loading height />;

  return (
    <Accordion
      classNames={{
        item: classes.item,
        control: classes.control,
        content: classes.content,
      }}
      chevronPosition="left"
      w={"100%"}
      variant="filled"
    >
      {filteredEvents.map((event: any) => (
        <>
          {GetTrackType(event.type, categories) ? (
            <AccordionResults
              event={event}
              key={event.identifier}
              lang={lang}
            />
          ) : null}
        </>
      ))}
    </Accordion>
  );
};
