import { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvents";
import { Countdown } from "../Countdown/Countdown";
import { RacingUI } from "./RacingUI";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

export const RacingPanel = () => {
  const lang: any = useRecoilValue(Lang);
  const [countdown, setCountdown] = useState(false);
  useNuiEvent("showCountdown", (state: boolean) => {
    setCountdown(state);
  });

  return (
    <>
      {countdown && <Countdown unmount={setCountdown} />}
      <RacingUI lang={lang} />
    </>
  );
};
