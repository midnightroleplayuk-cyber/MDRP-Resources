import { Grid } from "@mantine/core";
import { useEffect, useState } from "react";
import { ModalType, SelectType } from "../../../types/types";
import { Navbar } from "./Navbar";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { Loading } from "../../Loading";
import { Content } from "./Content/Content";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../reducers/atoms";

const sortGangs = (gangs: SelectType[]): SelectType[] => {
  return [...gangs].sort((a, b) => {
    const labelA = a.label.toLowerCase();
    const labelB = b.label.toLowerCase();

    if (labelA < labelB) {
      return -1;
    }
    if (labelA > labelB) {
      return 1;
    }
    return 0;
  });
};

const Gangs = () => {
  const daLang: any = useRecoilValue(Lang);
  const lang = daLang.admin;
  const [loaded, setLoaded] = useState(false);
  const [current, setCurrent] = useState<string | null>(null);
  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: {
      title: lang.register_gang,
      options: [
        {
          name: "gang",
          type: "text",
          title: lang.gang_name,
          asterisk: true,
          size: "xs",
        },
        {
          name: "boss",
          type: "number",
          title: lang.boss,
          description: lang.playerId,
          size: "xs",
        },
      ],
      button: "Confirm",
    },
  });
  const [allGangs, setAllGangs] = useState<SelectType[]>([]);

  const handleRegister = () => {
    setModal({ ...modal, state: true });
  };

  const callback = async (data: any) => {
    setModal({ ...modal, state: false });
    if (!data) return;
    const resp = await fetchNui("av_gangs", "newGang", data);
    if (resp) {
      setAllGangs([...allGangs, resp]);
    }
  };
  const fetchData = async () => {
    setLoaded(false);
    const resp = await fetchNui("av_gangs", "getGangs");
    if (resp) {
      const sorted = sortGangs(resp);
      setAllGangs(sorted);
      if (sorted[0]) {
        setCurrent(sorted[0].value);
      }
    } else {
      if (isEnvBrowser()) {
        setAllGangs([{ value: "ballas", label: "Ballas" }]);
        setCurrent("ballas");
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      {modal.state && <ModalMenu data={modal} callback={callback} />}
      <Grid gutter={0}>
        <Grid.Col maw={150}>
          <Navbar
            gangs={allGangs}
            current={current}
            setCurrent={setCurrent}
            handleRegister={handleRegister}
          />
        </Grid.Col>
        <Grid.Col span="auto">
          <Content gang={current} fetchData={fetchData} />
        </Grid.Col>
      </Grid>
    </>
  );
};

export default Gangs;
