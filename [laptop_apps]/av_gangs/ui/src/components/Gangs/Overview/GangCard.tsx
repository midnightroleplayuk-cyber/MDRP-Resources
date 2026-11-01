import { Card, Text, Image, Stack, Group } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Gang, Lang } from "../../../reducers/atoms";
import classes from "./style.module.css";

export const GangCard = () => {
  const lang: any = useRecoilValue(Lang);
  const { label, logo, members, maxMembers, graffitis, strain, title } =
    useRecoilValue(Gang);
  return (
    <Card className={classes.card}>
      <Image
        src={logo}
        w={115}
        h={115}
        ml="auto"
        mr="auto"
        fit="contain"
        fallbackSrc="gang_default.png"
      />
      <Text
        mt="xs"
        c="var(--color-main)"
        ta="center"
        ff="Bebas Neue"
        lts={2.5}
        fz="1.75rem"
        truncate
      >
        {label}
      </Text>
      <Text c="dimmed" ta="center" fz="sm" mt={-5}>
        {title}
      </Text>
      <Stack mt="xs">
        <Group className={classes.section}>
          <Text fz="sm" c="gray.1">
            {lang.members}
          </Text>
          <Text
            ml="auto"
            fz="sm"
            c="gray.4"
            fw={500}
          >{`${members}/${maxMembers}`}</Text>
        </Group>
        <Group className={classes.section}>
          <Text fz="sm" c="gray.1">
            {lang.graffitis}
          </Text>
          <Text ml="auto" fz="sm" c="gray.4" fw={500}>
            {graffitis}
          </Text>
        </Group>
        <Group className={classes.section}>
          <Text fz="sm" c="gray.1">
            {lang.strain}
          </Text>
          <Text ml="auto" fz="sm" c="gray.4" fw={500} truncate>
            {strain}
          </Text>
        </Group>
      </Stack>
    </Card>
  );
};
