import {
  Grid,
  Group,
  Button,
  Flex,
  TextInput,
  Text,
  Card,
  Stack,
  Select,
  ScrollArea,
  Tooltip,
  Switch,
  Divider,
  ScrollAreaAutosize,
  Box,
} from "@mantine/core";
import { useEffect, useState } from "react";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import { ApiAppForm, ApiApplications } from "../../../API/applications";
import { fetchNui } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { formatTimestamp } from "../../../hooks/formatTime";
import classes from "./style.module.css";
import global from "../../../global.module.css";

const normalizeForm = (f: any) => {
  if (Array.isArray(f)) return [...f];
  if (f && typeof f === "object") {
    const sortedKeys = Object.keys(f).sort((a, b) => Number(a) - Number(b));
    return sortedKeys.map((key) => f[key]);
  }
  return [];
};

const AnswerForm = ({
  question,
  answer,
}: {
  question: string;
  answer: string;
}) => {
  return (
    <Flex
      direction="column"
      gap={1}
      bg="var(--bg-main)"
      p="xs"
      style={{ borderRadius: 6, border: "solid 1px var(--border)" }}
    >
      <Text c="var(--text-main)" fz="sm">
        {question}
      </Text>
      <Text
        c="var(--text-dim)"
        fz="xs"
        mah={80}
        style={{ overflow: "auto", userSelect: "all" }}
      >
        {answer}
      </Text>
    </Flex>
  );
};

const Applications = () => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.applications;
  const [loaded, setLoaded] = useState(false);
  const [allApplications, setAllApplications] = useState(ApiApplications);
  const [form, setForm] = useState(() => normalizeForm(ApiAppForm));
  const [maxQuestions, setMaxQuestions] = useState(3);
  const [isOpen, setIsOpen] = useState(false);

  const options = [
    { value: "input", label: lang.text_input },
    { value: "number", label: lang.number_input },
    { value: "textarea", label: lang.textarea },
  ];

  const handleUpdate = (
    index: number,
    field: "type" | "title",
    value: string | null,
  ) => {
    setForm((prevForm) => {
      const updated = [...prevForm];
      if (updated[index]) {
        updated[index] = {
          ...updated[index],
          [field]: value ?? "",
        };
      } else {
        updated[index] = {
          type: field === "type" ? (value ?? "input") : "input",
          title: field === "title" ? (value ?? "") : "",
        };
      }
      return updated;
    });
  };

  const handleSave = () => {
    fetchNui("av_business", "saveForm", form);
  };

  const handleDelete = (identifier: string) => {
    fetchNui("av_business", "deleteApplications", identifier);
    const resp = allApplications.filter(
      (app: any) => app.identifier !== identifier,
    );
    setAllApplications(resp);
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getApplications");
      if (resp) {
        setAllApplications(resp.applications);
        setForm(normalizeForm(resp.form));
        setMaxQuestions(resp.maxQuestions);
        setIsOpen(resp.isOpen);
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);

  if (!loaded) return <Loading />;

  return (
    <Flex direction="column" h="100%" gap="md" style={{ overflow: "hidden" }}>
      <Group
        bg="var(--bg-card)"
        p="sm"
        style={{
          borderRadius: "6px",
          border: "solid 1px var(--border)",
          flexShrink: 0,
        }}
      >
        <Flex gap="xs" direction="column">
          <Text ff="var(--font-display)" tt="uppercase" fz="xl" fw={700}>
            {lang.header}
          </Text>
          <Text mt={-15} fz="xs" c="var(--text-dim)">
            {`${allApplications.length} ${lang.applications}`}
          </Text>
        </Flex>
        <Switch
          checked={isOpen}
          defaultChecked
          ml="auto"
          labelPosition="left"
          label={lang.toggle_switch}
          color="var(--cyan)"
          size="xs"
          onChange={(e) => {
            setIsOpen(e.currentTarget.checked);
            fetchNui(
              "av_business",
              "toggleApplications",
              e.currentTarget.checked,
            );
          }}
        />
      </Group>

      <Flex gap="md" style={{ flex: 1, minHeight: 0 }}>
        <Card
          className={classes.card}
          bg="var(--bg-sidebar)"
          style={{
            flex: "0 0 33%",
            maxWidth: 400,
            display: "flex",
            flexDirection: "column",
          }}
        >
          <Text c="var(--cyan)" fw={600} style={{ flexShrink: 0 }}>
            {lang.application_form}
          </Text>
          <ScrollArea
            offsetScrollbars
            type="hover"
            scrollbars={"y"}
            scrollbarSize={6}
            style={{ flex: 1 }}
            mt="md"
          >
            <Stack gap="sm" pr="sm">
              {[...Array(maxQuestions)].map((_, i) => {
                const question = form[i];
                return (
                  <Stack
                    key={i}
                    gap="xs"
                    bg="var(--bg-card)"
                    p="sm"
                    style={{
                      border: "solid 1px var(--border)",
                      borderRadius: "4px",
                    }}
                  >
                    <Text fz="xs" c="var(--text-dim)">{`${lang.question} ${
                      i + 1
                    }`}</Text>
                    <TextInput
                      classNames={global}
                      placeholder={lang.question_title}
                      size="xs"
                      value={question?.title ?? ""}
                      onChange={(e) => {
                        handleUpdate(i, "title", e.currentTarget.value);
                      }}
                    />
                    <Select
                      classNames={global}
                      placeholder={lang.input_type}
                      data={options}
                      size="xs"
                      value={question?.type ?? undefined}
                      onChange={(e) => {
                        handleUpdate(i, "type", e);
                      }}
                    />
                  </Stack>
                );
              })}
            </Stack>
          </ScrollArea>
          <Button
            className={classes.button}
            size="xs"
            mt="md"
            onClick={handleSave}
            style={{ flexShrink: 0 }}
          >
            {lang.save_changes}
          </Button>
        </Card>

        <Box style={{ flex: 1, minWidth: 0, height: "100%" }}>
          {allApplications.length > 0 ? (
            <ScrollArea
              h="100%"
              offsetScrollbars
              type="hover"
              scrollbars={"y"}
              scrollbarSize={6}
            >
              <Grid pr="sm">
                {allApplications.map((application: any) => (
                  <Grid.Col span={4} miw={250} key={application.identifier}>
                    <Card className={classes.card} h={330}>
                      <Stack gap="xs" h="100%">
                        <Group>
                          <Text fz="xs" c="var(--text-dim)">
                            {formatTimestamp(application.date)}
                          </Text>
                          <Tooltip
                            label={lang.playerIdentifier}
                            color="var(--tooltip)"
                            fz="sm"
                          >
                            <Text
                              fz="xs"
                              c="var(--text-dim)"
                              ml="auto"
                              truncate
                              onClick={() => {
                                fetchNui(
                                  "av_laptop",
                                  "copy",
                                  application.playerIdentifier,
                                );
                              }}
                              style={{ cursor: "pointer", maxWidth: 100 }}
                            >
                              {application.playerIdentifier}
                            </Text>
                          </Tooltip>
                        </Group>
                        <ScrollAreaAutosize
                          mah={210}
                          offsetScrollbars
                          type="hover"
                          scrollbars={"y"}
                          scrollbarSize={6}
                        >
                          <Stack gap="xs" pr="xs">
                            {application.form.map((field: any) => (
                              <AnswerForm
                                key={field.title}
                                question={field.title}
                                answer={field.answer}
                              />
                            ))}
                          </Stack>
                        </ScrollAreaAutosize>
                        <Stack gap="xs" mt="auto">
                          <Divider color="var(--border)" />
                          <Button
                            size="xs"
                            color="var(--danger)"
                            variant="light"
                            onDoubleClick={() => {
                              handleDelete(application.identifier);
                            }}
                          >
                            {lang.remove}
                          </Button>
                        </Stack>
                      </Stack>
                    </Card>
                  </Grid.Col>
                ))}
              </Grid>
            </ScrollArea>
          ) : (
            <Text ta="center" mt="30%" c="var(--text-dim)" fz="sm">
              {lang.noApplications}
            </Text>
          )}
        </Box>
      </Flex>
    </Flex>
  );
};

export default Applications;
