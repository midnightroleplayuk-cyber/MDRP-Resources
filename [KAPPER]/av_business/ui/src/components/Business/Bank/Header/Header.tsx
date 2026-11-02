import { Text, Grid, Card, Group, ActionIcon, Tooltip } from "@mantine/core";
import { IconCirclePlus, IconCircleMinus } from "@tabler/icons-react";
import classes from "./style.module.css";

interface Properties {
  symbol: string;
  lang: any;
  funds: number;
  revenue: number;
  handleFunds: (type: string) => void;
}

export const Header = ({
  symbol,
  lang,
  funds,
  revenue,
  handleFunds,
}: Properties) => {
  return (
    <Grid>
      <Grid.Col span={6} maw={300}>
        <Card className={classes.card} p="md">
          <Text
            fz="1.4rem"
            c="var(--success)"
            ff="var(--font-display)"
            fw={600}
            lh={1.15}
          >{`${symbol}${funds ? Number(funds).toLocaleString("en-US") : 0}`}</Text>
          <Group mt="xs" gap="xs">
            <Text fz="sm" c="var(--text-dim)" fw={500}>
              {lang.available_funds}
            </Text>
            <Group ml="auto" gap="sm">
              <Tooltip label={lang.remove_funds} color="var(--tooltip)">
                <ActionIcon
                  size="sm"
                  variant="transparent"
                  c="var(--danger)"
                  onClick={() => {
                    handleFunds("remove");
                  }}
                >
                  <IconCircleMinus stroke={1.5} />
                </ActionIcon>
              </Tooltip>
              <Tooltip label={lang.add_funds} color="var(--tooltip)">
                <ActionIcon
                  size="sm"
                  variant="transparent"
                  c="var(--success)"
                  onClick={() => {
                    handleFunds("add");
                  }}
                >
                  <IconCirclePlus stroke={1.5} />
                </ActionIcon>
              </Tooltip>
            </Group>
          </Group>
        </Card>
      </Grid.Col>
      <Grid.Col span={6} maw={300}>
        <Card className={classes.card} p="md">
          <Text
            fz="1.4rem"
            c="var(--cyan)"
            ff="var(--font-display)"
            fw={600}
            lh={1.15}
          >{`${symbol}${revenue ? Number(revenue).toLocaleString("en-US") : 0}`}</Text>
          <Text mt="xs" fz="sm" c="var(--text-dim)" fw={500}>
            {lang.monthly_revenue}
          </Text>
        </Card>
      </Grid.Col>
    </Grid>
  );
};
