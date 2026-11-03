import { Stack, Button, Select, rem, TextInput, Text} from "@mantine/core"
import classes from './Buy.module.css';
import { useState, useEffect } from "react";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useAppSelector } from "../../hooks/reduxHooks";
import { selectLang } from "../../reducers/language";

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

function findCryptoByName(name: string, cryptos: Crypto[]): Crypto | undefined {
  return cryptos.find(crypto => crypto.name === name);
}

function eliminarPunto(input: number): number {
    const inputString: string = input.toString();
    if (inputString.includes('.')) {
        const sinPunto: string = inputString.replace('.', '');
        return parseFloat(sinPunto);
    } else {
        return input;
    }
}

export const Sell = ({list, options, updateCryptos}:any) => {
  const {lang}:any = useAppSelector(selectLang)
  const [payWith, setPayWith] = useState<any>(null)
  const [loaded, setLoaded] = useState(false)
  const [toBuy, setToBuy] = useState<number | null>(null)
  const [toPay, setToPay] = useState(0)

  const handleSelect = (account:null | string) => {
    if(!account) {
        setPayWith(null)
        return
    };
    const result: Crypto | undefined = findCryptoByName(account, list)
    if (result) setPayWith(result);
  }

  const handleInput = (value:any) => {
    if(!value){
        setToBuy(null)
        setToPay(0)
        return
    };
    setToBuy(eliminarPunto(value))
    setToPay(value * payWith.sell)
  }
  const handleConfirm = async () => {
    const resp = await fetchNui("av_cupcake", "sell", {amount: toBuy, name: payWith.name})
    if(resp) {
        updateCryptos(resp)
        const result: Crypto | undefined = findCryptoByName(payWith.name, resp)
        if (result) setPayWith(result);
    };
  }
  useEffect(() => {
    if (options && options[0]) {
        const result: Crypto | undefined = findCryptoByName(options[0].value, list)
        if (result) setPayWith(result);
    }
    setLoaded(true)
  }, [options])
  
  return <>
    {loaded &&
        <Stack p={5} mt={5} gap={"xs"} mb={5}>
            <TextInput
                value={toBuy ? toBuy : ""}
                size="md"
                type="number"
                placeholder="0"
                ta={"left"}
                c="gray.4"
                label={<Text size="sm" fw={500}>{lang.sell_field}</Text>}
                onChange={(e)=>{handleInput(e.target.value)}}
                rightSection={
                    <Select
                        defaultValue={options[0]?.value}
                        data={options}
                        rightSectionWidth={28}
                        onChange={(e)=>{handleSelect(e)}}
                        classNames={{
                            input: classes.input,
                            option: classes.option,
                        }}
                        styles={{
                            input: {
                                backgroundColor: "transparent",
                                fontWeight: 500,
                                border: "transparent",
                                width: rem(95),
                                marginRight: rem(-1),
                            },
                            dropdown: {
                                backgroundColor: "rgba(39, 43, 54, 0.5)",
                                backdropFilter: "blur(10px)",
                            }
                        }}
                    />
                }
                rightSectionWidth={92}
                classNames={{
                    input: classes.input
                }}
                styles={{
                    input: {
                        backgroundColor: "transparent",
                        marginTop: "5px"
                    }
                }}
                disabled={!payWith}
            />
            {payWith ? <Text fz={"xs"} fw={500}>{`${lang.you_have} ${payWith.owned} ${payWith.label}` }</Text> : <Text fz={"xs"} fw={500}>{lang.no_token}</Text>}
            <TextInput
                value={toPay}
                size="md"
                type="number"
                placeholder="0.00"
                ta={"left"}
                c="gray.4"
                label={<Text size="sm" fw={500}>{lang.receive_field}</Text>}
                rightSection={
                    <Text fw={500}>{payWith?.sellAccountLabel}</Text>
                }
                rightSectionWidth={92}
                classNames={{
                    input: classes.input
                }}
                styles={{
                    input: {
                        backgroundColor: "transparent",
                        marginTop: "5px"
                    }
                }}
                disabled
            />
            <Button color="teal" mt={10} disabled={!Number(toBuy) || !payWith?.owned} onClick={()=>{handleConfirm()}} classNames={{root: classes.button}}>{lang.confirm_button}</Button>
        </Stack>
    }
  </>
}