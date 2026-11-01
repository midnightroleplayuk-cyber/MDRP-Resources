import { useEffect, useState } from "react";
import {
  Box,
  Flex,
  Grid,
  Text,
  Image,
  Tooltip,
  ScrollArea,
} from "@mantine/core";
import { Lock, Unlock, CheckCircle2 } from "lucide-react";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { Loading } from "../../../Loading";
import { LevelsType } from "./types";
import { useSortedRewards } from "./utils";
import { ApiProgression } from "./api";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../reducers/atoms";
import classes from "./style.module.css";

const Progression = () => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [redeeming, setRedeeming] = useState(false);
  const [rawLevels, setRawLevels] = useState<LevelsType[]>([]);
  const [redeemedList, setRedeemedList] = useState<string[]>([]);
  const [xp, setXP] = useState(0);

  const allLevels: LevelsType[] = useSortedRewards(rawLevels, redeemedList);

  const currentLevel = Math.floor(xp / 100);
  const nextLevel = currentLevel + 1;
  const progressPercentage = xp % 100;

  const handleRedeem = async (identifier: string) => {
    setRedeeming(true);
    const resp = await fetchNui("av_racing", "handleRedeem", identifier);
    if (resp) setRedeemedList(resp);
    setTimeout(() => {
      setRedeeming(false);
    }, 50);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getProgression");
      if (resp) {
        setRawLevels(resp.levels || []);
        setRedeemedList(resp.redeemed || []);
        setXP(resp.xp || 0);
      } else {
        if (isEnvBrowser()) {
          setRawLevels(ApiProgression.levels || []);
          setRedeemedList(ApiProgression.redeemed || []);
          setXP(ApiProgression.xp || 0);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Box className={classes.container}>
      <Box className={classes.xpPanel}>
        <Box className={classes.xpHeader}>
          <Text className={classes.xpLevel}>
            {currentLevel} <span>LVL</span>
          </Text>
          <Text className={classes.xpLevel}>
            {nextLevel} <span>LVL</span>
          </Text>
        </Box>

        <Tooltip
          label={`${xp} Total XP`}
          color="var(--tooltip)"
          fz="xs"
          withArrow
        >
          <Box className={classes.progressBarBg}>
            <Box
              className={classes.progressBarFill}
              style={{ width: `${progressPercentage}%` }}
            />
          </Box>
        </Tooltip>

        <Text className={classes.xpDesc}>
          {lang.xp_description ??
            "Earn XP by completing races; the higher you place, the more XP you gain."}
        </Text>
      </Box>

      {redeeming ? (
        <Loading />
      ) : (
        <ScrollArea h="100%" type="hover" offsetScrollbars>
          <Grid className={classes.rewardGrid} gutter="sm" pb="xl">
            {allLevels.map((option) => {
              const isRedeemed = option.redeemed;
              const isUnlockable = !isRedeemed && currentLevel >= option.level;
              const isLocked = !isRedeemed && currentLevel < option.level;

              let cardClass = classes.card;
              if (isRedeemed) cardClass += ` ${classes.cardRedeemed}`;
              else if (isUnlockable) cardClass += ` ${classes.cardUnlockable}`;
              else if (isLocked) cardClass += ` ${classes.cardLocked}`;

              return (
                <Grid.Col span={3} key={option.value} miw={260}>
                  <Box className={cardClass}>
                    <Box className={classes.imageContainer}>
                      <Box className={classes.levelBadge}>
                        LVL {option.level}
                      </Box>
                      <Image
                        src={option.image}
                        fallbackSrc="default_level.png"
                        className={classes.cardImage}
                        style={{
                          opacity: isLocked ? 0.3 : 1,
                        }}
                      />
                    </Box>

                    <Box className={classes.infoContainer}>
                      {!isLocked && (
                        <Tooltip
                          color="var(--tooltip)"
                          label={option.description ?? ""}
                          hidden={!option.description}
                          multiline
                          maw={200}
                          fz="xs"
                          withArrow
                        >
                          <Text className={classes.rewardTitle} lineClamp={3}>
                            {option.label}
                          </Text>
                        </Tooltip>
                      )}
                      <Box w="100%">
                        {isRedeemed && (
                          <Box
                            className={`${classes.statusIndicator} ${classes.statusRedeemed}`}
                          >
                            <CheckCircle2 size={14} />
                            {lang.redeemed ?? "REDEEMED"}
                          </Box>
                        )}

                        {isLocked && (
                          <Box
                            className={`${classes.statusIndicator} ${classes.statusLocked}`}
                          >
                            <Lock size={14} />
                            {`${lang.unlocks_at ?? "UNLOCKS AT"} ${option.level}`}
                          </Box>
                        )}

                        {isUnlockable && (
                          <button
                            className={classes.actionBtn}
                            onClick={() => handleRedeem(option.value)}
                          >
                            <Flex align="center" justify="center" gap={6}>
                              <Unlock size={14} />
                              {lang.unlock_now ?? "UNLOCK NOW"}
                            </Flex>
                          </button>
                        )}
                      </Box>
                    </Box>
                  </Box>
                </Grid.Col>
              );
            })}
          </Grid>
        </ScrollArea>
      )}
    </Box>
  );
};

export default Progression;
