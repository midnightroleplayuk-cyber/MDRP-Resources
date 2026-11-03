import { Box } from "@mantine/core";
import { Contacts } from "./Contacts/Contacts";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../hooks/useNuiEvents";
import { ApiContacts } from "../API/contacts";
import { ContactsType } from "../types/types";
import { Loading } from "./Loading";
import classes from "./app.module.css";

export const MainApp = () => {
  const [loaded, setLoaded] = useState(false);
  const [contactList, setContactList] = useState<ContactsType[]>([]);
  const [maxLevel, setMaxLevel] = useState(10);
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_contacts", "getContacts");
      if (resp) {
        setContactList(resp.contacts);
        setMaxLevel(resp.maxLevel);
      } else {
        if (isEnvBrowser()) {
          setContactList(ApiContacts);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);

  return (
    <Box className={classes.app}>
      <Box className={classes.box}>
        {loaded ? (
          <>
            <Box className={classes.cover} />
            <Contacts list={contactList} maxLevel={maxLevel} />
          </>
        ) : (
          <Loading />
        )}
      </Box>
    </Box>
  );
};
