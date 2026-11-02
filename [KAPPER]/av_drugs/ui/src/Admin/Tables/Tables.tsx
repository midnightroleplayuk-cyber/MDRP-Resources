import { useState } from "react";
import { Box, ScrollArea } from "@mantine/core";
import { Search } from "../Search";
import { TableTest } from "../../API/labData";
import { fetchNui, isEnvBrowser } from "../../hooks/useNuiEvents";
import { useRecoilValue } from "recoil";
import { Lang } from "../../reducers/atoms";
import { Info } from "./Info";
import classes from "../style.module.css";

export const Tables = () => {
  const { admin: lang }: any = useRecoilValue(Lang);
  const [allTables, setAllTables] = useState<any>(
    isEnvBrowser() ? TableTest : []
  );
  const handleCallback = (data: any) => {
    if (data) {
      setAllTables(data);
    }
  };
  const handleDelete = async (identifier: string) => {
    const resp = await fetchNui("av_drugs", "deleteTable", identifier);
    if (resp) {
      const copy = allTables.filter(
        (item: any) => item.identifier !== identifier
      );
      setAllTables(copy);
    }
  };
  return (
    <Box p="sm">
      <Search
        name={"table"}
        type={"tables"}
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
        {allTables.map((table: any) => (
          <Info
            key={table.identifier}
            table={table}
            handleDelete={handleDelete}
          />
        ))}
      </ScrollArea>
    </Box>
  );
};
