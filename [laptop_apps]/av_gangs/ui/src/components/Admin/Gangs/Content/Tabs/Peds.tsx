import { useEffect, useState } from "react";
import {
  Group,
  Grid,
  ScrollArea,
  Text,
  Image,
  ActionIcon,
  TextInput,
  Stack,
} from "@mantine/core";
import { IconBackspace } from "@tabler/icons-react";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";
import classes from "./style.module.css";
import global from "../../../../../global.module.css";

interface Properties {
  gang: string;
}

export const Peds = ({ gang }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loading, setLoading] = useState(false);
  const [image, setImage] = useState<string | null>(null);
  const [allPeds, setAllPeds] = useState<string[]>([]);

  const handleNew = async (value: string) => {
    const isModelValid = await fetchNui("av_gangs", "verifyModel", value);
    if (isModelValid) {
      const copy = [...allPeds, value];
      setAllPeds(copy);
      fetchNui("av_gangs", "savePeds", { copy, gang });
    }
  };
  const removePed = (model: string) => {
    const copy = [...allPeds];
    const index = copy.indexOf(model);
    if (index !== -1) {
      copy.splice(index, 1);
    }
    setAllPeds(copy);
    fetchNui("av_gangs", "savePeds", { copy, gang });
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "adminPeds", gang);
      if (resp) setAllPeds(resp);
    };
    fetchData();
  }, [gang]);

  return (
    <Stack>
      <Text fz="xs" c="dimmed">
        {lang.peds_header}
      </Text>
      <Grid className={classes.members} justify="center">
        <Grid.Col span={"auto"}>
          <TextInput
            classNames={global}
            placeholder={lang.add_model}
            size="xs"
            rightSection={
              <Text fz="xs" c="dimmed" mr="lg" opacity={0.45}>
                {daLang.enter_key}
              </Text>
            }
            onKeyDown={(e) => {
              const value = e.key;
              if (value == "Enter") {
                handleNew(e.currentTarget.value.toLocaleLowerCase());
                e.currentTarget.value = "";
              }
            }}
          />
          <ScrollArea
            h={400}
            mt="sm"
            p="xs"
            style={{
              backgroundColor: "rgba(30, 30, 36,0.55",
              border: "solid 1.25px rgba(255,255,255,0.1)",
              borderRadius: "6px",
            }}
          >
            {allPeds.map((model: string) => (
              <Group
                mb="xs"
                onClick={() => {
                  setLoading(true);
                  setImage(model);
                  setTimeout(() => {
                    setLoading(false);
                  }, 100);
                }}
                style={{ cursor: "pointer" }}
              >
                <Text
                  fz="sm"
                  fw={500}
                  c={image == model ? `var(--color-main)` : `gray.4`}
                >
                  {model}
                </Text>
                <ActionIcon
                  ml="auto"
                  mr="sm"
                  variant="subtle"
                  color="red"
                  size="xs"
                  onClick={() => {
                    removePed(model);
                  }}
                >
                  <IconBackspace />
                </ActionIcon>
              </Group>
            ))}
          </ScrollArea>
        </Grid.Col>
        <Grid.Col span={"auto"} style={{ display: "relative" }}>
          {!loading && image ? (
            <Image
              mt="md"
              src={`https://docs.fivem.net/peds/${image.toLocaleLowerCase()}.webp`}
              h={300}
              fit="contain"
            />
          ) : (
            <Text ta="center" mt={100} c="dimmed" fz="xs">
              {daLang.no_image}
            </Text>
          )}
        </Grid.Col>
      </Grid>
    </Stack>
  );
};
