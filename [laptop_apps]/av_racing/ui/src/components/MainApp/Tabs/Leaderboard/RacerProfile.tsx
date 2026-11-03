import { useEffect, useState } from "react";
import { Modal, Box, Text, Group, Stack } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { Loading } from "../../../Loading";
import { MOCK_PROFILE, ProfileData } from "./api";
import global from "../../../../global.module.css";
import classes from "./profile.module.css";

export const RacerProfile = ({
  identifier,
  fallbackName,
  onClose,
}: {
  identifier: string;
  fallbackName?: string;
  onClose: () => void;
}) => {
  const lang: any = useRecoilValue(Lang);
  const [data, setData] = useState<ProfileData | null>(
    isEnvBrowser() ? MOCK_PROFILE : null,
  );
  const [loaded, setLoaded] = useState(isEnvBrowser());

  useEffect(() => {
    if (isEnvBrowser()) return;
    fetchNui<ProfileData>("av_racing", "getRacerProfile", { identifier }).then(
      (resp) => {
        setData(resp && resp.name ? resp : null);
        setLoaded(true);
      },
    );
  }, [identifier]);

  const stat = (label: string, value: React.ReactNode, accent?: boolean) => (
    <Box className={classes.statBox}>
      <Text className={classes.statLabel}>{label}</Text>
      <Text className={accent ? classes.statValueAccent : classes.statValue}>
        {value}
      </Text>
    </Box>
  );

  return (
    <Modal
      classNames={global}
      opened
      onClose={onClose}
      centered
      lockScroll={false}
      size="lg"
      withCloseButton
      title={
        <Group gap={10} align="baseline">
          <Text className={classes.name}>
            {data?.name ?? fallbackName ?? "—"}
          </Text>
          {data && (
            <Text className={classes.elo}>
              {data.elo} {lang?.season_elo ?? "ELO"}
            </Text>
          )}
        </Group>
      }
    >
      {!loaded ? (
        <Loading />
      ) : !data ? (
        <Text className={classes.empty}>
          {lang?.profile_unavailable ??
            "No stats available for this racer yet."}
        </Text>
      ) : (
        <Stack gap={16}>
          <div className={classes.statGrid}>
            {stat(lang?.stat_races ?? "Races", data.races)}
            {stat(lang?.stat_wins ?? "Wins", data.wins)}
            {stat(lang?.losses ?? "Losses", data.losses)}
            {stat(lang?.winrate ?? "Winrate", `${data.winrate}%`, true)}
          </div>
          <div className={classes.favGrid}>
            <Box className={classes.favBox}>
              <Text className={classes.statLabel}>
                {lang?.fav_track ?? "FAVOURITE TRACK"}
              </Text>
              <Text className={classes.favValue}>{data.favTrack ?? "—"}</Text>
              {data.favTrackBest && (
                <Text className={classes.favSub}>
                  {(lang?.best_time ?? "Best") + ": " + data.favTrackBest}
                </Text>
              )}
            </Box>
            <Box className={classes.favBox}>
              <Text className={classes.statLabel}>
                {lang?.fav_vehicle ?? "FAVOURITE VEHICLE"}
              </Text>
              <Text className={classes.favValue}>{data.favVehicle ?? "—"}</Text>
            </Box>
          </div>
          <Box>
            <Text className={classes.section}>
              {lang?.recent_races ?? "LAST 10 RACES"}
            </Text>
            {data.last10.length === 0 ? (
              <Text className={classes.empty}>
                {lang?.no_races ?? "No races recorded yet."}
              </Text>
            ) : (
              <Box className={classes.table}>
                <Box className={`${classes.tRow} ${classes.tHead}`}>
                  <span className={classes.cTrack}>
                    {lang?.track ?? "TRACK"}
                  </span>
                  <span className={classes.cVeh}>
                    {lang?.vehicle ?? "VEHICLE"}
                  </span>
                  <span className={classes.cPos}>
                    {lang?.position ?? "POS"}
                  </span>
                  <span className={classes.cTime}>{lang?.time ?? "TIME"}</span>
                </Box>
                {data.last10.map((r, i) => (
                  <Box className={classes.tRow} key={i}>
                    <span className={classes.cTrack}>{r.track}</span>
                    <span className={classes.cVeh}>{r.vehicle}</span>
                    <span
                      className={`${classes.cPos} ${r.position === 1 ? classes.win : ""}`}
                    >
                      {r.position}/{r.total}
                    </span>
                    <span className={classes.cTime}>{r.time}</span>
                  </Box>
                ))}
              </Box>
            )}
          </Box>
        </Stack>
      )}
    </Modal>
  );
};
