import { useEffect, useState } from "react";
import {
  Box,
  Stack,
  Group,
  Text,
  Button,
  Divider,
  Tooltip,
  ActionIcon,
  TextInput,
  NumberInput,
  Image,
} from "@mantine/core";
import { ArrowRight as IconArrowNarrowRight } from "lucide-react";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import global from "../../../global.module.css";
import classes from "./styles.module.css";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  crew: string;
  handleDelete: (crew: string) => void;
}

export const Settings = ({ crew, handleDelete }: Properties) => {
  const lang: any = useRecoilValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [photo, setPhoto] = useState("");
  const [bossId, setBossId] = useState<number | null>();
  const [memberId, setMemberId] = useState<number | null>();
  const iconStyle = { height: 14, width: 14 };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_racing", "getPhoto", crew);
      if (resp) {
        setPhoto(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [crew]);

  const applyIcon = (onClick: () => void) => (
    <Tooltip
      label={lang.apply_tooltip}
      color="var(--tooltip)"
      position="right-end"
      fz="xs"
    >
      <ActionIcon
        size="sm"
        variant="subtle"
        color="var(--accent)"
        mr={4}
        onClick={onClick}
      >
        <IconArrowNarrowRight style={iconStyle} />
      </ActionIcon>
    </Tooltip>
  );

  if (!loaded) return <Loading />;

  return (
    <Box className={classes.settingsWrap}>
      <Box className={classes.settingsCard}>
        <Stack className={classes.avatarCol} gap="sm">
          <Box className={classes.avatarFrame}>
            <Image
              src={photo}
              fallbackSrc="avatar_default.png"
              w={220}
              h={220}
              fit="cover"
            />
          </Box>
          <Stack gap={2}>
            <Text className={classes.crewName}>{crew}</Text>
            <Text className={classes.crewNameSub}>
              {lang.crews_tab ?? "Crew"}
            </Text>
          </Stack>
        </Stack>

        <Stack className={classes.formCol} gap="md">
          <Stack gap={6}>
            <Text className={classes.sectionTitle}>
              {lang.photo ?? "Photo"}
            </Text>
            <TextInput
              classNames={global}
              value={photo}
              placeholder={lang.image_url}
              size="sm"
              onChange={(e) => {
                setPhoto(e.currentTarget.value);
              }}
              rightSection={applyIcon(() => {
                fetchNui("av_racing", "setPhoto", { crew, photo });
              })}
            />
          </Stack>

          <Divider color="var(--border-color)" />

          <Stack gap={6}>
            <Text className={classes.sectionTitle}>
              {lang.set_boss ?? "Set Boss"}
            </Text>
            <NumberInput
              classNames={global}
              size="sm"
              placeholder={lang.player_serverid}
              allowDecimal={false}
              allowLeadingZeros={false}
              min={1}
              max={5000}
              allowNegative={false}
              value={bossId ?? undefined}
              onChange={(e) => {
                if (!e) return;
                setBossId(Number(e));
              }}
              rightSection={applyIcon(() => {
                fetchNui("av_racing", "setBoss", { crew, playerId: bossId });
              })}
            />
          </Stack>

          <Stack gap={6}>
            <Text className={classes.sectionTitle}>
              {lang.add_member ?? "Add Member"}
            </Text>
            <NumberInput
              classNames={global}
              size="sm"
              placeholder={lang.player_serverid}
              allowDecimal={false}
              allowLeadingZeros={false}
              min={1}
              max={5000}
              allowNegative={false}
              value={memberId ?? undefined}
              onChange={(e) => {
                if (!e) return;
                setMemberId(Number(e));
              }}
              rightSection={applyIcon(() => {
                fetchNui("av_racing", "addMember", { crew, playerId: memberId });
              })}
            />
          </Stack>

          <Divider color="var(--border-color)" />

          <Box className={classes.dangerZone}>
            <Stack gap={2}>
              <Text className={classes.dangerTitle}>
                {lang.delete_crew_button}
              </Text>
              <Text className={classes.dangerDesc}>
                {lang.double_click_confirm ?? "Double click to confirm"}
              </Text>
            </Stack>
            <Button
              color="red"
              variant="light"
              size="xs"
              onDoubleClick={() => {
                handleDelete(crew);
              }}
            >
              {lang.delete_button ?? lang.delete_crew_button}
            </Button>
          </Box>
        </Stack>
      </Box>
    </Box>
  );
};
