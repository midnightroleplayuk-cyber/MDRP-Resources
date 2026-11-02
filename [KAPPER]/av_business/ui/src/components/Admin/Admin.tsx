import { Box, Transition } from "@mantine/core";
import { useEffect, useState, Suspense, lazy } from "react";
import { SelectType } from "../../types/types";
import { fetchNui, isEnvBrowser, useNuiEvent } from "../../hooks/useNuiEvents";
import { Header } from "./Header/Header";
import { Loading } from "../Loading";
import { ApiJob } from "../../API/alljobs";
import { sortAlphabetically } from "../../hooks/sortArray";
import { ApiTypes, TypesInterface } from "./Items/Types/api";
import classes from "./style.module.css";

const Home = lazy(() => import("./Home/Home"));
const Deliveries = lazy(() => import("./Deliveries/Deliveries"));
const Ingredients = lazy(() => import("./Ingredients/Ingredients"));
const Items = lazy(() => import("./Items/Items"));
const Permissions = lazy(() => import("./Permissions/Permissions"));
const Animations = lazy(() => import("./Animations/Animations"));
const Logs = lazy(() => import("./Logs/Logs"));
const Crafting = lazy(() => import("./Crafting/Crafting"));
const Pawnshops = lazy(() => import("./Pawnshop/Pawnshop"));
const Misc = lazy(() => import("./Misc/Misc"));
const Blips = lazy(() => import("./Blips/Blips"));
const Access = lazy(() => import("./Access/Access"));
const AdminBills = lazy(() => import("./AdminBills/AdminBills"));

export const AdminPanel = () => {
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [allJobs, setAllJobs] = useState<SelectType[]>([]);
  const [itemTypes, setItemTypes] = useState<TypesInterface[]>([]);
  const [allItems, setAllItems] = useState<{ value: string; label: string }[]>([
    { value: "water", label: "Water" },
    { value: "burger", label: "Burger" },
  ]);
  const [tab, setTab] = useState("home");
  const [opacity, setOpacity] = useState(1.0);
  const [inventory, setInventory] = useState("");

  useNuiEvent("itemTypes", (list: TypesInterface[]) => {
    setItemTypes(sortAlphabetically(list));
  });

  useNuiEvent("opacity", (value: number) => {
    setOpacity(value);
  });

  const onKeyDown = (e: KeyboardEvent) => {
    if (e.code === "Escape") {
      setLoaded(false);
      setTimeout(() => {
        fetchNui("av_business", "closeAdmin");
      }, 250);
    }
  };
  useEffect(() => {
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const resp = await fetchNui("av_business", "getAdminData");
        const temp_jobs = resp?.allJobs || (isEnvBrowser() ? ApiJob : []);
        const temp_types = resp?.itemTypes || (isEnvBrowser() ? ApiTypes : []);
        const temp_items = resp?.allItems;
        setInventory(resp?.inventory || "");
        if (temp_jobs.length > 0) {
          setAllJobs(sortAlphabetically(temp_jobs));
        }
        if (temp_types.length > 0) {
          setItemTypes(sortAlphabetically(temp_types));
        }
        if (temp_items) {
          setAllItems(sortAlphabetically(temp_items));
        }
      } catch (error) {
        console.error(error);
      } finally {
        setLoaded(true);
      }
    };
    fetchData();
  }, []);
  return (
    <>
      <Box className={classes.container} opacity={opacity}>
        <Transition
          mounted={loaded}
          transition="fade-down"
          duration={500}
          exitDuration={500}
          timingFunction="ease"
        >
          {(styles) => (
            <Box className={classes.box} style={styles}>
              <Header tab={tab} setTab={setTab} />
              <Box
                className={classes.content}
                style={{ backdropFilter: "unset" }}
                p="sm"
              >
                <Suspense fallback={<Loading />}>
                  {tab == "home" && <Home allJobs={allJobs} />}
                  {tab == "crafting" && <Crafting />}
                  {tab == "deliveries" && <Deliveries itemTypes={itemTypes} />}
                  {tab == "ingredients" && (
                    <Ingredients
                      allJobs={allJobs}
                      itemTypes={itemTypes}
                      allItems={allItems}
                    />
                  )}
                  {tab == "items" && (
                    <Items
                      allItems={allItems}
                      allJobs={allJobs}
                      itemTypes={itemTypes}
                    />
                  )}
                  {tab == "permissions" && <Permissions allJobs={allJobs} />}
                  {tab == "logs" && <Logs allJobs={allJobs} />}
                  {tab == "animations" && (
                    <Animations allJobs={allJobs} itemTypes={itemTypes} />
                  )}
                  {tab == "pawnshops" && (
                    <Pawnshops
                      allItems={allItems}
                      allJobs={allJobs}
                      inventory={inventory}
                    />
                  )}
                  {tab == "misc" && <Misc />}
                  {tab == "blips" && <Blips allJobs={allJobs} />}
                  {tab == "access" && <Access allJobs={allJobs} />}
                  {tab == "adminbills" && <AdminBills allJobs={allJobs} />}
                </Suspense>
              </Box>
            </Box>
          )}
        </Transition>
      </Box>
    </>
  );
};
