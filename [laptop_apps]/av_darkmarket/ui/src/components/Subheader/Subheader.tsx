import { Group, Select, TextInput } from "@mantine/core";
import { Timer } from "./Timer";
import { useRecoilState, useRecoilValue } from "recoil";
import {
  Lang,
  MoneyAccounts,
  RefreshTime,
  SubheaderAtom,
} from "../../reducers/atoms";
import global from "../../global.module.css";

export const Subheader = () => {
  const lang: any = useRecoilValue(Lang);
  const accounts = useRecoilValue(MoneyAccounts);
  const nextDrop = useRecoilValue(RefreshTime);
  const [atom, setAtom] = useRecoilState(SubheaderAtom);

  return (
    <>
      <Group>
        {nextDrop !== undefined && <Timer />}
        <Group ml="auto">
          <Select
            classNames={global}
            placeholder={lang.filter_account}
            size="xs"
            data={accounts}
            onChange={(e) => {
              setAtom({ ...atom, account: e });
            }}
          />
          <TextInput
            classNames={global}
            placeholder={lang.search}
            size="xs"
            onChange={(e) => {
              setAtom({ ...atom, search: e.currentTarget.value });
            }}
          />
        </Group>
      </Group>
    </>
  );
};
