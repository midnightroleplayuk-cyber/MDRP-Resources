import { useEffect, useState } from "react";
import { Stack, Image, TextInput, Text, Button } from "@mantine/core";
import global from "../../../../../global.module.css";
import classes from "./style.module.css";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { Loading } from "../../../../Loading";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";

interface Properties {
  gang: string;
}

export const Graffiti = ({ gang }: Properties) => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [url, setUrl] = useState("");
  const handleSave = () => {
    fetchNui("av_gangs", "savePhotoURL", {
      gang,
      url,
    });
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getGraffiti", gang);
      if (resp) {
        setUrl(resp);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, [gang]);

  if (!loaded) return <Loading />;
  return (
    <>
      <Stack
        className={classes.card}
        ta="center"
        gap="xs"
        ml="auto"
        mr="auto"
        p="md"
        w={350}
      >
        <Stack gap={0}>
          <Text fw={500} c="white">
            {lang.graffitis_header}
          </Text>
          <Text fz="xs" c="gray.5">
            {lang.graffitis_dimensions}
          </Text>
          <Text fz="xs" c="dimmed">
            {lang.graffitis_warning}
          </Text>
        </Stack>
        <Image
          mt="sm"
          src={url}
          fallbackSrc="gang_default.png"
          h={200}
          w={200}
          ml="auto"
          mr="auto"
        />
        <TextInput
          classNames={global}
          label={daLang.image_url}
          size="xs"
          value={url}
          onChange={(e) => {
            setUrl(e.currentTarget.value);
          }}
        />
        <Button className={global.button} size="xs" onClick={handleSave}>
          {daLang.save_changes}
        </Button>
      </Stack>
    </>
  );
};
