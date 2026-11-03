import { useState } from "react";
import { Box, ScrollArea } from "@mantine/core";
import { Search } from "../Search";
import { LabsTest } from "../../API/labData";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import { Info } from "./Info";
import classes from "../style.module.css";

export const Labs = () => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [allLabs, setAllLabs] = useState<any>(isEnvBrowser() ? LabsTest : []);
  const handleCallback = (data: any) => {
    if (data) {
      setAllLabs(data);
    }
  };
  const handleDelete = async (identifier: string) => {
    const resp = await fetchNui("av_drugs", "deleteLab", identifier);
    if (resp) {
      const copy = allLabs.filter(
        (item: any) => item.identifier !== identifier
      );
      setAllLabs(copy);
    }
  };
  return (
    <Box p="sm">
      <Search
        name={lang.lab}
        type={"labs"}
        event={"getInfo"}
        cb={handleCallback}
      />
      <ScrollArea
        className={classes.scroll}
        type="hover"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={7}
        mr="sm"
      >
        {allLabs.map((lab: any) => (
          <Info key={lab.identifier} lab={lab} handleDelete={handleDelete} />
        ))}
      </ScrollArea>
    </Box>
  );
};
