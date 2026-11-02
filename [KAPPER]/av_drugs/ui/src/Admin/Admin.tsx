import { useEffect, useState } from "react";
import { Box } from "@mantine/core";
import { Header } from "./Header";
import { Tables } from "./Tables/Tables";
import { fetchNui } from "../hooks/useNuiEvents";
import classes from "./style.module.css";
import { Labs } from "./Labs/Labs";
import { Players } from "./Players/Players";
import { Zones } from "./Zones/Zones";

const Admin = () => {
  const [type, setType] = useState("tables");
  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_drugs", "closeAdmin");
        break;
      default:
        break;
    }
  };
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
  }, []);

  return (
    <Box className={classes.container}>
      <Box className={classes.box}>
        <Header type={type} setType={setType} />
        {type == "tables" && <Tables />}
        {type == "labs" && <Labs />}
        {type == "players" && <Players />}
        {type == "zones" && <Zones />}
      </Box>
    </Box>
  );
};

export default Admin;
