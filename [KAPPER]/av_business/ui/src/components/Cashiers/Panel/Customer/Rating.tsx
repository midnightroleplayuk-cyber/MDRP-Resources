import { useState } from "react";
import {
  Stack,
  Group,
  Text,
  Textarea,
  Button,
  Box,
  Divider,
} from "@mantine/core";
import { IconStarFilled, IconStar } from "@tabler/icons-react";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import classes from "./style.module.css";
import global from "../../../../global.module.css";

interface Props {
  job: string;
  daLang: any;
  onDone: () => void;
}

export const Rating = ({ job, daLang, onDone }: Props) => {
  const lang = daLang.cashier;
  const [stars, setStars] = useState(0);
  const [hovered, setHovered] = useState(0);
  const [comment, setComment] = useState("");
  const [loading, setLoading] = useState(false);
  const display = hovered || stars;

  const handleSubmit = async () => {
    if (stars === 0 || comment.trim().length < 2) return;
    setLoading(true);
    await fetchNui("av_business", "rateUs", { job, stars, comment });
    onDone();
  };

  return (
    <Stack h="100%" justify="center" align="center" gap="xl">
      <Stack gap={6} align="center">
        <Text fz="lg" fw={700} c="var(--text-main)" lts={0.5}>
          {lang.rate_header}
        </Text>
        <Text fz="xs" c="var(--text-dim)">
          {lang.rate_subheader}
        </Text>
      </Stack>
      <Group gap={6}>
        {[1, 2, 3, 4, 5].map((i) => (
          <Box
            key={i}
            style={{ cursor: "pointer", lineHeight: 1 }}
            onMouseEnter={() => setHovered(i)}
            onMouseLeave={() => setHovered(0)}
            onClick={() => setStars(i)}
          >
            {i <= display ? (
              <IconStarFilled
                size={32}
                style={{
                  color: "var(--yellow)",
                  filter:
                    i <= display
                      ? "drop-shadow(0 0 6px rgba(250,176,5,0.5))"
                      : "none",
                  transition: "color 0.1s, filter 0.1s",
                }}
              />
            ) : (
              <IconStar
                size={32}
                style={{
                  color: "var(--text-dim)",
                  transition: "color 0.1s",
                }}
              />
            )}
          </Box>
        ))}
      </Group>
      <Divider w="60%" opacity={0.3} />
      <Textarea
        classNames={global}
        size="sm"
        placeholder={lang.rate_feedback}
        value={comment}
        onChange={(e) => setComment(e.currentTarget.value)}
        minRows={3}
        maxRows={5}
        autosize
        maxLength={200}
        style={{ width: "80%" }}
      />
      <Group gap="xs">
        <Button
          size="xs"
          variant="transparent"
          c="var(--text-dim)"
          style={{ fontSize: 12 }}
          onClick={onDone}
        >
          {lang.rate_skip}
        </Button>
        <Button
          size="xs"
          className={classes.button}
          disabled={stars === 0 || comment.trim().length < 2}
          loading={loading}
          onClick={handleSubmit}
        >
          {lang.rate_submit}
        </Button>
      </Group>
    </Stack>
  );
};
