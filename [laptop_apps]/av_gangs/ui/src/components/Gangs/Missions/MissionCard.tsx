import { Box, Card, Text, Image, Rating, Group, Button } from "@mantine/core";
import { IconSkull } from "@tabler/icons-react";
import { MissionType } from "../../../types/types";
import classes from "./style.module.css";
import global from "../../../global.module.css";

interface LevelInfo {
  level: number;
  percentage: number;
  remaining: number;
}

interface Properties {
  lang: any;
  mission: MissionType;
  res: LevelInfo;
  handleStart: (mission: MissionType) => void;
  isWide: boolean;
}
export const MissionCard = ({
  mission,
  res,
  lang,
  handleStart,
  isWide,
}: Properties) => {
  return (
    <Card withBorder radius="md" className={classes.card} h={315}>
      <Card.Section className={classes.image}>
        {res.level < mission.level && <Box className={classes.blur} />}
        <Image
          src={mission.image}
          h={120}
          fallbackSrc="mission_default.webp"
          fit="cover"
        />
      </Card.Section>
      <Rating
        value={mission.difficulty}
        fractions={2}
        readOnly
        emptySymbol={<IconSkull size="1rem" color="gray" />}
        fullSymbol={<IconSkull size="1rem" color="rgb(255,105,105)" />}
        mt="xs"
      />
      <Text fw={500} truncate ff="Bebas Neue" fz="1.05rem" lts={1.5}>
        {res.level >= mission.level ? mission.label : lang.classified}
      </Text>
      <Text
        className={classes.description}
        fz="xs"
        c="dimmed"
        lineClamp={4}
        mt={2}
      >
        {res.level >= mission.level
          ? mission.description
          : `${lang.requiredLevel} ${mission.level}`}
      </Text>
      <Group className={classes.buttonBox} mt="auto">
        {res.level >= mission.level && mission.price && (
          <>
            <Text fw={500} c="gray.4" fz="sm">{`${
              isWide ? `${lang.price}:` : ``
            } ${lang.money_symbol}${
              mission.price ? mission.price.toLocaleString("en-US") : 0
            }`}</Text>
          </>
        )}
        <Button
          ml="auto"
          className={global.button}
          color="var(--color-main)"
          c="var(--color-text)"
          size="xs"
          variant="filled"
          disabled={res.level < mission.level || mission.started}
          onClick={() => {
            handleStart(mission);
          }}
        >
          {mission.started ? lang.started : lang.start}
        </Button>
      </Group>
    </Card>
  );
};
