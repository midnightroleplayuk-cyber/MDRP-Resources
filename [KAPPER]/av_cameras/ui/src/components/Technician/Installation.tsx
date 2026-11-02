import { Box, Paper, Stack, Stepper, Text } from "@mantine/core";
import { MapPin, Rss, ShieldCheck, UserPlus, CheckCircle2 } from "lucide-react";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

export const Installation = () => {
  const lang: any = useAtomValue(Lang);
  return (
    <Stack gap="lg">
      <Box>
        <Text
          ff="var(--font-display)"
          fz="lg"
          fw={600}
          c="var(--text-main)"
          tt="uppercase"
          lts={1}
        >
          {lang.deployment_guide}
        </Text>
        <Text ff="var(--font-family)" fz="sm" c="var(--text-secondary)">
          {lang.deployment_guide_desc}
        </Text>
      </Box>
      <Paper className={classes.formSection} p="xl">
        <Stepper
          active={0}
          orientation="vertical"
          color="var(--accent)"
          size="sm"
          styles={{
            stepIcon: {
              backgroundColor: "var(--bg-base)",
              borderColor: "var(--border-mid)",
            },
            stepLabel: {
              color: "var(--text-main)",
              fontFamily: "var(--font-display)",
              fontSize: "16px",
              textTransform: "uppercase",
              letterSpacing: "1px",
            },
            stepDescription: {
              color: "var(--text-secondary)",
              fontFamily: "var(--font-family)",
              fontSize: "13px",
            },
            separator: {
              backgroundColor: "var(--border-mid)",
            },
          }}
        >
          <Stepper.Step
            label={lang.physical_installation}
            description={lang.physical_installation_desc}
            icon={<MapPin size={16} color="var(--accent)" />}
          />
          <Stepper.Step
            label={lang.frequency_detection}
            description={lang.frequency_detection_desc}
            icon={<Rss size={16} color="var(--accent)" />}
          />
          <Stepper.Step
            label={lang.status_identification}
            description={lang.status_identification_desc}
            icon={<ShieldCheck size={16} color="var(--accent)" />}
          />
          <Stepper.Step
            label={lang.network_provisioning}
            description={lang.network_provisioning_desc}
            icon={<UserPlus size={16} color="var(--accent)" />}
          />
          <Stepper.Step
            label={lang.final_validation}
            description={lang.final_validation_desc}
            icon={<CheckCircle2 size={16} color="var(--accent)" />}
          />
        </Stepper>
      </Paper>
    </Stack>
  );
};
