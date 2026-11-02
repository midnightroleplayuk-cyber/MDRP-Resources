import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { ApiBankLogs } from "../../../API/bank";
import { ModalType } from "../../../types/types";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { Loading } from "../../Loading";
import { Lang } from "../../../reducers/atoms";
import { Header } from "./Header/Header";
import { Transactions } from "./Transactions/Transactions";

const Bank = () => {
  const daLang: any = useAtomValue(Lang);
  const lang: any = daLang.bank;
  const [funds, setFunds] = useState(0);
  const [monthly, setMonthly] = useState(0);
  const [loaded, setLoaded] = useState(false);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: {
      title: "",
      options: [],
    },
  });
  const handleFunds = (type: string) => {
    setModal({
      state: true,
      info: {
        title: type == "add" ? lang.add_funds : lang.remove_funds,
        options: [
          {
            name: "amount",
            type: "number",
            description: type == "add" ? lang.amount_add : lang.amount_remove,
            zero: false,
            negative: false,
            decimal: false,
            isMoney: true,
            min: 0,
          },
        ],
        extraData: { event: "managefunds", type },
        button: lang.confirm,
      },
    });
  };
  const modalCallback = async (data?: any) => {
    if (!data) {
      setModal({ ...modal, state: false });
      return;
    }
    setModal({ ...modal, state: false });
    const { extraData } = data;
    const resp = await fetchNui("av_business", extraData.event, data);
    if (!resp) return;
    setFunds(resp.funds);
    setTransactions(resp.transactions);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_business", "getBank");
      if (resp) {
        setTransactions(resp.logs);
        setFunds(resp.funds);
        setMonthly(resp.monthly);
      } else {
        if (isEnvBrowser()) {
          setTransactions(ApiBankLogs);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 200);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <>
      {modal.state && <ModalMenu data={modal} callback={modalCallback} />}
      <Header
        symbol={daLang.money_symbol}
        lang={lang}
        funds={funds}
        revenue={monthly}
        handleFunds={handleFunds}
      />
      <Transactions myLogs={transactions} />
    </>
  );
};

export default Bank;
