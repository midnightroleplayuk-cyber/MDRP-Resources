import {
  Stack,
  Group,
  TextInput,
  Select,
  Box,
  Text,
  ScrollArea,
} from "@mantine/core";
import { Search } from "lucide-react";
import { useState } from "react";
import { Events } from "./Events/Events";
import { Results } from "./Results/Results";
import { useRecoilValue } from "recoil";
import { Categories, Classes, Lang } from "../../../../reducers/atoms";
import { ModalType } from "../../../../types/types";
import { ModalMenu } from "../../../ModalMenu/ModalMenu";
import { Chat } from "../../Chat/Chat";
import classes from "./style.module.css";
import global from "../../../../global.module.css";
import { TodayStats } from "./Today/TodayStats";

const Home = () => {
  const lang: any = useRecoilValue(Lang);
  const categories = useRecoilValue(Categories);
  const vehClasses = useRecoilValue(Classes);
  const [tab, setTab] = useState("events");
  const [search, setSearch] = useState("");
  const [chat, setChat] = useState<null | string>(null);
  const [category, setCategory] = useState("");
  const [vehClass, setVehClass] = useState("");
  const [modalOptions, setModalOptions] = useState<ModalType>({ state: false });

  const handleChat = (id: string) => {
    setChat(id);
  };

  return (
    <>
      {modalOptions.state && <ModalMenu data={modalOptions} />}
      {chat && (
        <Chat
          id={chat}
          setId={() => {
            setChat(null);
          }}
        />
      )}
      <Stack
        gap="sm"
        h="100%"
        style={{ flex: 1, overflow: "hidden", minHeight: 0 }}
      >
        <TodayStats />
        <Box className={classes.sectionTitle}>
          <Group gap="xs">
            <Text
              component="span"
              onClick={() => setTab("events")}
              style={{
                cursor: "pointer",
                color:
                  tab === "events" ? "var(--text-main)" : "var(--text-dim)",
                fontWeight: tab === "events" ? 700 : 500,
                fontSize: "16px",
                fontFamily: "var(--font-main)",
                transition: "color 0.2s ease",
              }}
            >
              {lang?.available_events ?? "Available Events"}
            </Text>
            <Text component="span" c="var(--text-dim)" fw={500} fz="16px">
              \
            </Text>
            <Text
              component="span"
              onClick={() => setTab("results")}
              style={{
                cursor: "pointer",
                color:
                  tab === "results" ? "var(--text-main)" : "var(--text-dim)",
                fontWeight: tab === "results" ? 700 : 500,
                fontSize: "16px",
                fontFamily: "var(--font-main)",
                transition: "color 0.2s ease",
              }}
            >
              {lang?.past_events ?? "Past Events"}
            </Text>
          </Group>
          <Group gap="sm">
            <TextInput
              size="xs"
              classNames={global}
              placeholder={lang?.search_events ?? "Search events..."}
              leftSection={<Search size={14} />}
              value={search}
              onChange={(e) => setSearch(e.currentTarget.value)}
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-main)",
                },
              }}
            />
            <Select
              size="xs"
              classNames={global}
              placeholder={lang?.filter_category ?? "Filter by category"}
              data={categories}
              value={category}
              onChange={(val) => setCategory(val || "")}
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-dim)",
                },
                dropdown: {
                  backgroundColor: "var(--bg-panel)",
                  border: "1px solid var(--border-color)",
                },
                option: {
                  color: "var(--text-main)",
                },
              }}
            />
            <Select
              size="xs"
              classNames={global}
              placeholder={lang?.filter_class ?? "Filter by class"}
              data={
                vehClasses?.length > 0
                  ? vehClasses
                  : ["Class A", "Class B", "Class C", "Class D"]
              }
              value={vehClass}
              onChange={(val) => setVehClass(val || "")}
              styles={{
                input: {
                  backgroundColor: "var(--bg-main)",
                  border: "1px solid var(--border-color)",
                  color: "var(--text-dim)",
                },
                dropdown: {
                  backgroundColor: "var(--bg-panel)",
                  border: "1px solid var(--border-color)",
                },
                option: {
                  color: "var(--text-main)",
                },
              }}
            />
          </Group>
        </Box>
        <ScrollArea
          h="100%"
          type="hover"
          scrollbars="y"
          scrollbarSize={6}
          offsetScrollbars
        >
          <Box>
            {tab === "events" && (
              <Events
                search={search}
                vehClass={vehClass}
                handleChat={handleChat}
                category={category}
                setModalOptions={setModalOptions}
              />
            )}
            {tab === "results" && (
              <Results
                search={search}
                vehClass={vehClass}
                category={category}
              />
            )}
          </Box>
        </ScrollArea>
      </Stack>
    </>
  );
};

export default Home;
