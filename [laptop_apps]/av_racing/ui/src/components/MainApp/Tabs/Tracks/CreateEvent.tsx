import { useEffect, useState } from "react";
import { ApiTrack } from "../../../../Api/Track";
import { EventType, SelectType } from "../../../../types/types";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Categories, Classes, Profile } from "../../../../reducers/atoms";
import { ApiCheckpoints } from "../../../../Api/Checkpoints";
import { CheckpointType } from "../../Details/types";
import { ApiEvent, ApiPhasing } from "../../../../Api/Events";
import { EventForm } from "../../../EventForm/EventForm";

interface Properties {
  track: string;
  setTrack: (option: string | null) => void;
  lang: any;
}

export const CreateEvent = ({ track, setTrack, lang }: Properties) => {
  const [loaded, setLoaded] = useState(false);
  const { crew } = useRecoilValue(Profile);
  const [minCheckpoints, setMinCheckpoints] = useState(50);
  const categories = useRecoilValue(Categories);
  const vehClasses = useRecoilValue(Classes);
  const [errorType, setErrorType] = useState("");
  const [trackData, setTrackData] = useState<any>({});
  const [accounts, setAccounts] = useState<SelectType[]>([
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
        check: !event.driftCheckpointTime || event.driftCheckpointTime == 0,
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
    setTrack(null);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getTrack", track);
      const min = await fetchNui("av_racing", "getMinRanked");
      const accountList = await fetchNui("av_racing", "getAccounts");
      const phasingOptions = await fetchNui("av_racing", "getPhasing");
      setPhasing(phasingOptions ?? []);
      const rewindOn = await fetchNui<boolean>("av_racing", "getRewindEnabled");
      if (typeof rewindOn === "boolean") setRewindAvailable(rewindOn);
      setMinCheckpoints(min ?? 50);
      setAccounts(accountList ?? []);
      if (resp) {
        setTrackData(resp);
        setCheckpoints(resp.checkpoints);
      } else {
        if (isEnvBrowser()) {
          setTrackData(ApiTrack);
          setCheckpoints(ApiTrack.checkpoints ?? ApiCheckpoints);
        } else {
          setTrack(null);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [track]);

  const notEnoughCheckpoints = minCheckpoints > checkpoints.length;

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
      onCancel={() => setTrack(null)}
      onCreate={handleCreate}
      canCrew={!!crew}
      rankedDisabled={notEnoughCheckpoints}
      rankedHint={
        lang.tooltip_ranked_min ??
        `This track needs at least ${minCheckpoints} checkpoints to be ranked.`
      }
      rewindAvailable={rewindAvailable}
    />
  );
};
