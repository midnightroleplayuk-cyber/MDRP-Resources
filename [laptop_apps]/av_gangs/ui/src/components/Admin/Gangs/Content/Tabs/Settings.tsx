import { Stack, Group, Button, Text, NumberInput } from "@mantine/core";
import { useEffect, useState } from "react";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";
import classes from "./style.module.css";
import global from "../../../../../global.module.css";
import { Loading } from "../../../../Loading";

interface Properties {
  gang: string;
  refreshData: () => void;
}

export const Settings = ({ gang, refreshData }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [gangXP, setGangXP] = useState<string | number>(0);
  const [bossId, setBossId] = useState<string | number>(0);
  const [playerId, setPlayerId] = useState<string | number>(0);
  const [toInvite, setToInvite] = useState<number>(0);

  const handleBoss = () => {
    fetchNui("av_gangs", "setAdminBoss", { id: bossId, gang });
  };
  const handleXP = () => {
    fetchNui("av_gangs", "setAdminXP", { gang, xp: gangXP });
  };
  const sendSpray = () => {
    fetchNui("av_gangs", "giveSpray", { playerId, gang });
  };

  const handleInvite = () => {
    fetchNui("av_gangs", "admin:invite", { playerId: toInvite, gang });
  };
  const fetchData = async () => {
    const resp = await fetchNui("av_gangs", "getGangXP", gang);
    if (resp) {
      setGangXP(resp);
    }
  };
  useEffect(() => {
    setLoaded(false);
    fetchData();
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  }, [gang]);

  if (!loaded) return <Loading />;
  return (
    <Stack className={classes.card} ml="auto" mr="auto" mt="sm" w={350} p="md">
      <Group gap="sm">
        <Text fz="sm" fw={500}>
          {lang.newBoss}
        </Text>
        <Group ml="auto">
          <NumberInput
            classNames={global}
            placeholder={daLang.playerId}
            min={1}
            size="xs"
            w={100}
            allowDecimal={false}
            allowNegative={false}
            onChange={(e) => {
              setBossId(e);
            }}
          />
          <Button
            color="var(--color-main)"
            variant="subtle"
            size="xs"
            onClick={handleBoss}
          >
            {daLang.save}
          </Button>
        </Group>
      </Group>
      <Group gap="sm">
        <Text fz="sm" fw={500}>
          {daLang.invite_member}
        </Text>
        <Group ml="auto">
          <NumberInput
            classNames={global}
            placeholder={daLang.playerId}
            min={1}
            size="xs"
            w={100}
            allowDecimal={false}
            allowNegative={false}
            allowLeadingZeros={false}
            onChange={(e) => {
              setToInvite(Number(e));
            }}
          />
          <Button
            color="var(--color-main)"
            variant="subtle"
            size="xs"
            onClick={handleInvite}
          >
            {daLang.save}
          </Button>
        </Group>
      </Group>
      <Group gap="sm">
        <Text fz="sm" fw={500}>
          {lang.setXP}
        </Text>
        <Group ml="auto">
          <NumberInput
            classNames={global}
            placeholder={lang.playerId}
            min={1}
            size="xs"
            w={100}
            allowDecimal={false}
            allowNegative={false}
            value={gangXP}
            onChange={(e) => {
              setGangXP(e);
            }}
          />
          <Button
            color="var(--color-main)"
            variant="subtle"
            size="xs"
            onClick={handleXP}
          >
            {daLang.save}
          </Button>
        </Group>
      </Group>
      <Group gap="sm">
        <Text fz="sm" fw={500}>
          {lang.sendSpray}
        </Text>
        <Group ml="auto">
          <NumberInput
            classNames={global}
            placeholder={daLang.playerId}
            min={1}
            size="xs"
            w={100}
            allowDecimal={false}
            allowNegative={false}
            onChange={(e) => {
              setPlayerId(e);
            }}
          />
          <Button
            color="var(--color-main)"
            variant="subtle"
            size="xs"
            onClick={sendSpray}
          >
            {daLang.send}
          </Button>
        </Group>
      </Group>
      <Button
        onDoubleClick={() => {
          fetchNui("av_gangs", "deleteAdminGang", gang);
          setTimeout(() => {
            refreshData();
          }, 100);
        }}
        size="xs"
        color="red"
        variant="subtle"
      >
        {lang.delete_gang}
      </Button>
    </Stack>
  );
};
