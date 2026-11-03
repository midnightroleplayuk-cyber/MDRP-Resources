import {
  Stack,
  Group,
  Flex,
  Text,
  Grid,
  Image,
  ScrollArea,
  Card,
  TextInput,
  Button,
  Modal,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { useEffect, useState } from "react";
import { ApiPosters, PosterType } from "./api";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import global from "../../../global.module.css";

const Poster = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.poster;
  const [allPosters, setAllPosters] = useState<PosterType[]>([]);
  const [loaded, setLoaded] = useState(false);
  const [opened, { open, close }] = useDisclosure(false);
  const [selectedImage, setSelectedImage] = useState<string>("");

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getPosters");
      if (resp) {
        const sortedResp = [...resp].sort((a, b) =>
          a.identifier.localeCompare(b.identifier),
        );
        setAllPosters(sortedResp);
      } else {
        if (isEnvBrowser()) {
          const sortedApi = [...ApiPosters].sort((a, b) =>
            a.identifier.localeCompare(b.identifier),
          );
          setAllPosters(sortedApi);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  const handleChange = (
    identifier: string,
    field: "title" | "url",
    value: string,
  ) => {
    setAllPosters((prev) =>
      prev.map((poster) =>
        poster.identifier === identifier
          ? { ...poster, [field]: value }
          : poster,
      ),
    );
  };

  const handleSave = (poster: PosterType) => {
    fetchNui("av_business", "updatePoster", poster);
  };

  const handleImageClick = (url: string) => {
    setSelectedImage(url || "https://placehold.co/600x400?text=No+Image");
    open();
  };

  if (!loaded) return <Loading />;

  return (
    <Stack gap="lg" h="100%" style={{ fontFamily: "var(--font-display)" }}>
      <Group
        bg="var(--bg-card)"
        p="sm"
        style={{
          borderRadius: "6px",
          border: "solid 1px var(--border)",
        }}
      >
        <Flex gap="xs" direction="column">
          <Text tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {lang.description}
          </Text>
        </Flex>
      </Group>
      <ScrollArea
        h="calc(100vh - 180px)"
        type="hover"
        scrollbars="y"
        scrollbarSize={5}
        offsetScrollbars
      >
        <Grid pb="xl">
          {allPosters.map((poster) => (
            <Grid.Col
              span={{ base: 12, sm: 6, md: 4, lg: 3 }}
              key={poster.identifier}
            >
              <Card
                shadow="sm"
                padding="lg"
                radius="md"
                bg="var(--bg-card)"
                style={{ border: "solid 1px var(--border)" }}
              >
                <Card.Section>
                  <Image
                    src={
                      poster.url || "https://placehold.co/600x400?text=No+Image"
                    }
                    height={160}
                    alt={poster.title}
                    fallbackSrc="https://placehold.co/600x400?text=Invalid+Image"
                    onClick={() => handleImageClick(poster.url)}
                    style={{ cursor: "zoom-in" }}
                  />
                </Card.Section>
                <Stack gap="sm" mt="md">
                  <Text fw={500} truncate="end">
                    {poster.title || "Untitled"}
                  </Text>
                  <TextInput
                    classNames={global}
                    label={lang.titleLabel || "Title"}
                    value={poster.title}
                    onChange={(e) =>
                      handleChange(
                        poster.identifier,
                        "title",
                        e.currentTarget.value,
                      )
                    }
                    size="xs"
                  />
                  <TextInput
                    classNames={global}
                    label={lang.urlLabel || "Image URL"}
                    value={poster.url}
                    onChange={(e) =>
                      handleChange(
                        poster.identifier,
                        "url",
                        e.currentTarget.value,
                      )
                    }
                    size="xs"
                  />
                  <Button
                    className={global.button}
                    fullWidth
                    mt="sm"
                    onClick={() => handleSave(poster)}
                  >
                    {lang.saveButton || "Save"}
                  </Button>
                </Stack>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
      <Modal
        opened={opened}
        onClose={close}
        size="auto"
        centered
        withinPortal
        lockScroll={false}
        withCloseButton={false}
        padding={0}
      >
        <Image
          src={selectedImage}
          radius="md"
          style={{ maxHeight: "85vh", objectFit: "contain" }}
        />
      </Modal>
    </Stack>
  );
};

export default Poster;
