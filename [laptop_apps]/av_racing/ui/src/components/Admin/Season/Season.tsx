import {
  Group,
  Text,
  Stack,
  Button,
  Card,
  Grid,
  Flex,
  NumberInput,
} from "@mantine/core";
import { DatePickerInput } from "@mantine/dates";
import { useEffect, useState } from "react";
import { useToday } from "./helpers";
import { Loading } from "../../Loading";
import { fetchNui } from "../../../hooks/useNuiEvents";
import global from "../../../global.module.css";
import classes from "./style.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

const Season = () => {
  const lang: any = useRecoilValue(Lang);
  const today = useToday();
  const [loaded, setLoaded] = useState(false);
  const [endsIn, setEndsIn] = useState<string | null>(null);
  const [currentSeason, setCurrentSeason] = useState<number>(1);

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getSeasonData");
      if (resp) {
        setEndsIn(resp.endsIn);
        setCurrentSeason(resp.season || 1);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);

  const handleSave = () => {
    fetchNui("av_racing", "saveSeasonAdmin", {
      season: currentSeason,
      endsIn,
    });
  };

  if (!loaded) return <Loading />;
  return (
    <>
      <Card className={classes.card} w={300} ml="auto" mr="auto" mt="xl">
        <Stack>
          <Flex direction="column">
            <Text fz="lg" c="gray.1" fw={500}>
              {lang.season_manager}
            </Text>
            <Text fz="xs" c="dimmed">
              {lang.season_manager_description}
            </Text>
          </Flex>
          <NumberInput
            classNames={global}
            label={lang.current_season}
            min={1}
            value={currentSeason}
            onChange={(val) => setCurrentSeason(Number(val))}
            allowDecimal={false}
            size="xs"
          />
          <DatePickerInput
            classNames={global}
            size="xs"
            label={lang.season_ends}
            placeholder={lang.pick_date}
            value={endsIn}
            onChange={setEndsIn}
            minDate={today}
          />
          <Button
            size="xs"
            color="var(--accent)"
            onClick={handleSave}
            variant="outline"
          >
            {lang.update_season}
          </Button>
          <Text fz="xs" c="dimmed" ta="center">
            {lang.season_extra.a}
            <Text fz="11px" c="gray.5" lts={0.5}>
              {lang.season_extra.b}
            </Text>
          </Text>
        </Stack>
      </Card>
    </>
  );
};

export default Season;
