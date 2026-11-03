import { lazy, Suspense, useState } from "react";
import { Box } from "@mantine/core";
import { Sidebar } from "./Sidebar/Sidebar";
import { Header } from "./Header/Header";
import { Loading } from "../Loading";
import { Creator } from "./Creator/Creator";
import { CategoryType } from "../../types/types";
import classes from "./style.module.css";

const Market = lazy(() => import("./Tabs/Market/Market"));
const MyListings = lazy(() => import("./Tabs/Listings/MyListings"));
const Messages = lazy(() => import("./Tabs/Messages/Messages"));
const Settings = lazy(() => import("./Tabs/Settings/Settings"));

const MainApp = () => {
  const [tab, setTab] = useState("market");
  const [search, setSearch] = useState("");
  const [creator, setCreator] = useState(false);
  const [allCategories, setAllCategories] = useState<CategoryType[]>([]);
  const [showSettings, setShowSettings] = useState(false);

  return (
    <Box className={classes.wrapper}>
      <Settings opened={showSettings} close={() => setShowSettings(false)} />
      <Sidebar tab={tab} setTab={setTab} setShowSettings={setShowSettings} />
      <Box className={classes.mainContent}>
        <Header
          tab={tab}
          setSearch={setSearch}
          search={search}
          setCreator={() => setCreator(true)}
        />
        {creator && (
          <Creator
            close={() => setCreator(false)}
            allCategories={allCategories}
          />
        )}

        <Suspense fallback={<Loading />}>
          {tab === "market" && (
            <Market
              search={search}
              setAllCategories={setAllCategories}
              allCategories={allCategories}
            />
          )}
          {tab === "listings" && <MyListings search={search} />}
          {tab === "messages" && <Messages />}
        </Suspense>
      </Box>
    </Box>
  );
};

export default MainApp;
