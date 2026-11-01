import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { EventType, SelectType } from "../../../types/types";
import { CheckpointType } from "../../MainApp/Details/types";
import { ApiTrack } from "../../../Api/Track";
import { ApiCheckpoints } from "../../../Api/Checkpoints";
import { ApiEvent, ApiPhasing } from "../../../Api/Events";
import { useRecoilState } from "recoil";
import { Classes } from "../../../reducers/atoms";
import { EventForm } from "../../EventForm/EventForm";

interface Properties {
  lang: any;
  setState: (state: boolean) => void;
}

export const CreateEvent = ({ setState, lang }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const [categories, setCategories] = useState<SelectType[]>([]);
  const [vehClasses, setVehClasses] = useRecoilState(Classes);
  const [errorType, setErrorType] = useState("");
  const [allTracks, setAllTracks] = useState<SelectType[]>([]);
  const [track, setTrack] = useState<string | null>(null);
  const [trackData, setTrackData] = useState<any>({});
  const [accounts, setAccounts] = useState([
    { value: "cash", label: "Cash" },
    { value: "cosmo", label: "Cosmo" },
  ]);
  const [phasing, setPhasing] = useState<SelectType[]>(ApiPhasing);
  const [rewindAvailable, setRewindAvailable] = useState<boolean>(
    isEnvBrowser(),
  );
  const [checkpoints, setCheckpoints] = useState<CheckpointType[]>([]);
  const [event, setEvent] = useState<EventType>(ApiEvent);

  const isDrift = event.type?.toLowerCase() === "drift";

  const fetchTracks = async () => {
    const resp = await fetchNui("av_racing", "getAdminTracks");
    if (resp) {
      setAllTracks(resp);
    } else {
      if (isEnvBrowser()) {
        setAllTracks([
          { value: "test1", label: "Test 1" },
          { value: "test2", label: "Test 2" },
        ]);
      }
    }
    const adminData = await fetchNui("av_racing", "getAdminData");
    setVehClasses(adminData.classes ?? []);
    setPhasing(adminData.phasing ?? []);
    setAccounts(adminData.accounts ?? []);
    setCategories(adminData.categories ?? []);
    const rewindOn = await fetchNui<boolean>("av_racing", "getRewindEnabled");
    if (typeof rewindOn === "boolean") setRewindAvailable(rewindOn);
  };

  const fetchData = async () => {
    const resp = await fetchNui("av_racing", "getTrack", track);
    if (resp) {
      setTrackData(resp);
      setCheckpoints(resp.checkpoints);
    } else {
      if (isEnvBrowser()) {
        setTrackData(ApiTrack);
        setCheckpoints(ApiTrack.checkpoints ?? ApiCheckpoints);
      } else {
        setState(false);
      }
    }
  };

  const handleReversed = (state: boolean) => {
    setEvent({ ...event, reversed: state });
    const currentCheckpoints = trackData.checkpoints
      ? [...trackData.checkpoints]
      : [];
    let updatedCheckpoints = currentCheckpoints;
    if (state) {
      updatedCheckpoints = currentCheckpoints.reverse();
    }
    setCheckpoints(updatedCheckpoints);
  };

  const handleUpdate = (field: string, data: any) => {
    setEvent((prev) => ({ ...prev, [field]: data }));
  };

  const handleCreate = () => {
    const requiredFields = [
      { field: "title", check: !event.title || event.title === "" },
      { field: "buyin", check: !event.buyin && event.buyin !== 0 },
      { field: "moneyAccount", check: !event.moneyAccount },
      { field: "startsin", check: !event.startsin },
      { field: "type", check: !event.type },
      { field: "laps", check: event.laps == null },
    ];

    if (isDrift) {
      requiredFields.push({
        field: "driftStartTime",
        check: !event.driftStartTime || event.driftStartTime < 5,
      });
      requiredFields.push({
        field: "driftCheckpointTime",
        check: !event.driftCheckpointTime || event.driftCheckpointTime < 5,
      });
    }

    for (const requirement of requiredFields) {
      if (requirement.check) {
        setErrorType(requirement.field);
        setTimeout(() => {
          setErrorType("");
        }, 300);
        return;
      }
    }
    const final = {
      ...event,
      checkpoints,
      name: trackData.name,
      identifier: trackData.identifier,
    };
    fetchNui("av_racing", "newRace", final);
    setState(false);
  };

  useEffect(() => {
    if (!loaded) {
      fetchTracks();
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    }
    if (track) {
      fetchData();
    }
  }, [track]);

  return (
    <EventForm
      lang={lang}
      loaded={loaded}
      event={event}
      errorType={errorType}
      checkpoints={checkpoints}
      trackData={trackData}
      accounts={accounts}
      phasing={phasing}
      categories={categories}
      vehClasses={vehClasses}
      onUpdate={handleUpdate}
      onReversed={handleReversed}
      onCancel={() => setState(false)}
      onCreate={handleCreate}
      tracks={allTracks}
      track={track}
      onTrackChange={setTrack}
      canCreate={!!track}
      canCrew
      rewindAvailable={rewindAvailable}
    />
  );
};
