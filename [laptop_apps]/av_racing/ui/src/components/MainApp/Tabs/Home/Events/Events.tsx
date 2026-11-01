import { useEffect, useState, useMemo } from "react";
import { Text, Box } from "@mantine/core";
import { EventType, ModalType } from "../../../../../types/types";
import { Loading } from "../../../../Loading";
import {
  fetchNui,
  isEnvBrowser,
  useNuiEvent,
} from "../../../../../hooks/useNuiEvents";
import { ApiEvents } from "../../../../../Api/Events";
import { useRecoilValue, useSetRecoilState } from "recoil";
import {
  Categories,
  eventDetails,
  Lang,
  Profile,
} from "../../../../../reducers/atoms";
import { JoinedRace } from "../../../../../hooks/joinedRace";
import {
  GetListByCategories,
  GetTrackType,
} from "../../../../../hooks/getTrackType";
import classes from "./style.module.css";
import { Element } from "./Element";

interface EventsProps {
  search: string;
  category: string;
  vehClass: string;
  setModalOptions: (data: ModalType) => void;
  handleChat: (id: string) => void;
}

export const Events = ({
  search,
  category,
  vehClass,
  setModalOptions,
  handleChat,
}: EventsProps) => {
  const categories = useRecoilValue(Categories);
  const lang: any = useRecoilValue(Lang);
  const profile = useRecoilValue(Profile);
  const [loaded, setLoaded] = useState(false);
  const [allEvents, setAllEvents] = useState<EventType[]>([]);
  const setDetails = useSetRecoilState(eventDetails);

  useNuiEvent("updateEvent", (event: EventType) => {
    setAllEvents((prevEvents) => {
      return prevEvents.map((oldEvent) => {
        if (oldEvent.identifier === event.identifier) {
          return event;
        }
        return oldEvent;
      });
    });
  });

  useNuiEvent("updateEvents", (events: EventType[]) => {
    const filtered = GetListByCategories(categories, events);
    setAllEvents(filtered);
  });

  useNuiEvent("newEvent", (event: EventType) => {
    if (GetTrackType(event.type, categories)) {
      setAllEvents([...allEvents, event]);
    }
  });

  useNuiEvent("removeEvent", (identifier: string) => {
    setAllEvents((prevEvents) => {
      return prevEvents.filter((event) => event.identifier !== identifier);
    });
  });

  const handleDetails = async (event: EventType, joined: boolean) => {
    if (event.password) {
      setModalOptions({
        state: true,
        info: {
          title: lang.details,
          options: [
            {
              name: "password",
              title: lang.password,
              type: "password",
            },
          ],
          button: lang.confirm_button,
          extraData: event,
        },
        callback: detailsCallback,
      });
    } else {
      const haveAccess = await fetchNui(
        "av_racing",
        "accessDetails",
        event.identifier,
      );
      if (!haveAccess) return;
      setDetails(event);
    }
  };

  const detailsCallback = async (data: any) => {
    setModalOptions({ state: false });
    if (!data) return;
    const { extraData, password } = data;
    const resp = await fetchNui("av_racing", "getDetails", {
      identifier: extraData.identifier,
      password,
    });
    if (!resp) return;
    setDetails(resp);
  };

  const handleJoin = async (event: EventType) => {
    if (event.password) {
      setModalOptions({
        state: true,
        info: {
          title: lang.join_event,
          options: [
            {
              name: "password",
              title: lang.password,
              type: "password",
            },
          ],
          button: lang.confirm_button,
          extraData: {
            event: "joinRace",
            eventInfo: event,
            settings: profile.settings,
            crew: profile.crew,
          },
        },
        callback: handleCallback,
      });
    } else {
      fetchNui("av_racing", "joinRace", {
        eventInfo: event,
        settings: profile.settings,
        crew: profile.crew,
      });
    }
  };

  const handleRoute = async (event: EventType, joined: boolean) => {
    if (event.password && !joined) {
      setModalOptions({
        state: true,
        info: {
          title: lang.join_event,
          options: [
            {
              name: "password",
              title: lang.password,
              type: "password",
            },
          ],
          button: lang.confirm_button,
          extraData: {
            event: "setRoute",
            track: event.identifier,
          },
        },
        callback: handleCallback,
      });
    } else {
      const haveAccess = await fetchNui(
        "av_racing",
        "accessDetails",
        event.identifier,
      );
      if (!haveAccess) return;
      fetchNui("av_racing", "setRoute", event.identifier);
    }
  };

  const handleQuit = async (event: EventType) => {
    fetchNui("av_racing", "quitRace", event.identifier);
  };

  const handleStart = async (event: EventType) => {
    fetchNui("av_racing", "startRace", event);
  };

  const handleDelete = async (id: string) => {
    fetchNui("av_racing", "deleteEvent", id);
  };

  const handleCheckin = (id: string) => {
    fetchNui("av_racing", "checkin", {
      identifier: id,
      settings: profile.settings,
    });
  };

  const handleCallback = async (data: any) => {
    setModalOptions({ state: false });
    if (!data) return;
    if (data.extraData.event == "startRace") {
      const resp = await fetchNui("av_racing", "startRace", {
        event: data.extraData.eventInfo,
      });
      if (resp) setAllEvents(resp);
    } else {
      fetchNui("av_racing", data.extraData.event, data);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getEvents");
      if (resp) {
        const filtered = GetListByCategories(categories, resp);
        setAllEvents(filtered);
      } else {
        if (isEnvBrowser()) {
          setAllEvents(ApiEvents);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };

    fetchData();
  }, []);

  const filteredEvents = useMemo(() => {
    let result = [...allEvents];
    if (search || category || vehClass) {
      result = result.filter((event) => {
        const matchesSearch =
          !search || event.title.toLowerCase().includes(search.toLowerCase());
        const matchesCategory = !category || event.type === category;
        const matchesClass = !vehClass || event.class.toLowerCase() == vehClass;
        return matchesSearch && matchesCategory && matchesClass;
      });
    }
    return result.sort((a, b) => {
      const aJoined = JoinedRace(a.racers, profile.identifier);
      const bJoined = JoinedRace(b.racers, profile.identifier);

      if (aJoined && !bJoined) return -1;
      if (!aJoined && bJoined) return 1;
      return a.seconds - b.seconds;
    });
  }, [allEvents, search, category, vehClass, profile.identifier]);

  if (!loaded) return <Loading height />;

  return (
    <>
      {filteredEvents.length > 0 ? (
        <Box className={classes.eventsList}>
          {filteredEvents.map((event) => {
            const isJoined = JoinedRace(event.racers, profile.identifier);
            const isHostOrAdmin =
              profile.identifier === event.host || profile.isAdmin;

            return (
              <Element
                key={event.identifier}
                event={event}
                joined={isJoined}
                isHostAdmin={isHostOrAdmin}
                lang={lang}
                handleJoin={handleJoin}
                handleDetails={handleDetails}
                handleRoute={handleRoute}
                handleQuit={handleQuit}
                handleStart={handleStart}
                handleDelete={handleDelete}
                handleCheckin={handleCheckin}
                handleChat={handleChat}
              />
            );
          })}
        </Box>
      ) : (
        <Text fz="sm" c="dimmed">
          {lang.no_events}
        </Text>
      )}
    </>
  );
};
