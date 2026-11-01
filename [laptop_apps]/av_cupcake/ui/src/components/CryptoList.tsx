import { useEffect, useState } from "react";
import { Box, Text, Tabs, rem, LoadingOverlay } from "@mantine/core"
import { IconCreditCard, IconTag, IconTransfer } from '@tabler/icons-react';
import {Buy} from "./Options/Buy"
import {Sell} from "./Options/Sell"
import {Transfer} from "./Options/Transfer"
import { useAppSelector } from "../hooks/reduxHooks";
import { selectLang } from "../reducers/language";

interface Crypto {
  name: string;
  label: string;
  buy: number;
  sell: number;
  canBuy: boolean;
  canTransfer: boolean;
  canSell: boolean;
  buyAccount: string;
  buyAccountLabel: string;
  sellAccount: string;
  sellAccountLabel: string;
}

interface TransformedCrypto {
  value: string;
  label: string;
}

export const CryptoList = ({allCryptos, updateCryptos}:any) => {
  const {lang}:any = useAppSelector(selectLang)
  const [currentCryptos, setCurrentCryptos] = useState({});
  const [loaded, setLoaded] = useState(false)
  const iconStyle = { width: rem(12), height: rem(12) };
  const [options, setOptions] = useState([])
 
  const handleField = (field: keyof Crypto) => {
    setLoaded(false)
    const filteredCryptos = filterCryptosByField(field);
    const filteredOptions:any = transformCryptos(filteredCryptos)
    setCurrentCryptos(filteredCryptos);
    setOptions(filteredOptions)
    setTimeout(() => {
      setLoaded(true)
    }, 25);
  };

  const filterCryptosByField = (field: keyof Crypto) => {
    return allCryptos.filter((crypto:any) => crypto[field]);
  };
  const transformCryptos = (cryptos: Crypto[]): TransformedCrypto[] => {
      return cryptos.map(crypto => ({
            value: crypto.name,
            label: crypto.label.substring(0, 4).toUpperCase()
      }));
  };
  useEffect(() => {
    handleField("canBuy")
  }, [])
  
  return (
    <Box style={{display: "flex", justifyContent: "center"}}>
      <Tabs 
            defaultValue={"canBuy"}
            color="teal.5"
            mih={"calc(22vh)"}
            ta={"center"}
            styles={{
                  tab: {
                        backgroundColor: "transparent"
                  },

            }}
            mt={5}
      >
            <Tabs.List justify="center">
                  <Tabs.Tab value="canBuy" leftSection={<IconCreditCard style={iconStyle} />} onClick={() => handleField("canBuy")}>
                        <Text size="xs">{lang.buy_tab}</Text>
                  </Tabs.Tab>
                  <Tabs.Tab value="canSell" leftSection={<IconTag style={iconStyle} />} onClick={() => handleField("canSell")}>
                        <Text size="xs">{lang.sell_tab}</Text>
                  </Tabs.Tab>
                  <Tabs.Tab value="canTransfer" leftSection={<IconTransfer style={iconStyle} />} onClick={() => handleField("canTransfer")}>
                        <Text size="xs">{lang.transfer_tab}</Text>
                  </Tabs.Tab>
            </Tabs.List>
            {loaded ?
                  <>
                        <Tabs.Panel value="canBuy">
                              <Buy list={currentCryptos} options={options} updateCryptos={updateCryptos}/>
                        </Tabs.Panel>
                        <Tabs.Panel value="canSell">
                              <Sell list={currentCryptos} options={options} updateCryptos={updateCryptos}/>
                        </Tabs.Panel>
                        <Tabs.Panel value="canTransfer">
                              <Transfer list={currentCryptos} options={options} updateCryptos={updateCryptos}/>
                        </Tabs.Panel>
                  </>
            :
                  <Box style={{display: "flex", alignContent: "center", alignItems: "center", height: "100%"}}>
                        <LoadingOverlay visible zIndex={1000} loaderProps={{ color: 'teal', type: 'dots'}} overlayProps={{ radius: 'sm', blur: 2, opacity: 0 }}/>
                  </Box>
            }
      </Tabs>
    </Box>
  )
}