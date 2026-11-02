import {
  Stack,
  Card,
  Text,
  Button,
  Group,
  Flex,
  ScrollArea,
} from "@mantine/core";
import { Stats } from "./Stats";
import classes from "./../styles.module.css";
import { LabType } from "../../types/types";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";

interface Properties {
  lab: LabType;
  upgrades: {
    maintenance: number;
    security: number;
    stash: number;
  };
  handlePayment: () => void;
  handleUpgrade: (type: string) => void;
}

export const Main = ({
  lab,
  upgrades,
  handlePayment,
  handleUpgrade,
}: Properties) => {
  const { labs: lang }: any = useRecoilValue(Lang);
  return (
    <>
      <Stats lab={lab} />
      <Text mt="md" mb="xs" fz="lg" fw={500}>
        {lang.upgrades}
      </Text>
      <ScrollArea
        className={classes.scroll}
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
        mr="sm"
      >
        <Stack gap="xs">
          {lab.isExpired && (
            <Card className={classes.card}>
              <Group>
                <Flex direction="column">
                  <Text fz="lg" fw={500}>
                    {lang.maintenance}
                  </Text>
                  <Text fz="xs" c="dimmed">
                    {lang.maintenance_description}
                  </Text>
                </Flex>
                <Group ml="auto">
                  <Text fz="sm" fw={500}>{`${
                    lang.price
                  }: $${upgrades.maintenance.toLocaleString("en-US")}`}</Text>
                  <Button
                    color="blue.1"
                    variant="light"
                    w={115}
                    onClick={() => {
                      handlePayment();
                    }}
                  >
                    {lang.renew}
                  </Button>
                </Group>
              </Group>
            </Card>
          )}
          <Card className={classes.card}>
            <Group>
              <Flex direction="column">
                <Text fz="lg" fw={500}>
                  {`${lang.security} (${lab.upgrades.security}/3)`}
                </Text>
                <Text fz="xs" c="dimmed">
                  {lang.security_description}
                </Text>
              </Flex>
              {lab.upgrades.security < 3 ? (
                <Group ml="auto">
                  <Text fz="sm" fw={500}>{`${
                    lang.price
                  }: $${upgrades.security.toLocaleString("en-US")}`}</Text>
                  <Button
                    color="blue.1"
                    variant="light"
                    w={115}
                    disabled={lab.upgrades.security >= 3}
                    onClick={() => {
                      handleUpgrade("security");
                    }}
                  >
                    {lang.upgrade_button}
                  </Button>
                </Group>
              ) : (
                <Text ml="auto" fw={500} fz="sm" c="blue.1">
                  {lang.fully_upgraded}
                </Text>
              )}
            </Group>
          </Card>
          <Card className={classes.card}>
            <Group>
              <Flex direction="column">
                <Text fz="lg" fw={500}>
                  {`${lang.stash} (${lab.upgrades.stash}/3)`}
                </Text>
                <Text fz="xs" c="dimmed">
                  {lang.stash_description}
                </Text>
              </Flex>
              {lab.upgrades.stash < 3 ? (
                <Group ml="auto">
                  <Text fz="sm" fw={500}>{`${
                    lang.price
                  }: $${upgrades.stash.toLocaleString("en-US")}`}</Text>
                  <Button
                    color="blue.1"
                    variant="light"
                    w={115}
                    disabled={lab.upgrades.stash >= 3}
                    onClick={() => {
                      handleUpgrade("stash");
                    }}
                  >
                    {lang.upgrade_button}
                  </Button>
                </Group>
              ) : (
                <Text ml="auto" fw={500} fz="sm" c="blue.1">
                  {lang.fully_upgraded}
                </Text>
              )}
            </Group>
          </Card>
        </Stack>
      </ScrollArea>
    </>
  );
};
