import { Grid } from "@mantine/core";
import { GangCard } from "./GangCard";
import { useEffect, useState } from "react";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { ApiMembers } from "../../../api/Members";
import { Loading } from "../../Loading";
import { Member, ModalType } from "../../../types/types";
import { Leaderboard } from "./Leaderboard";
import { useViewportSize } from "@mantine/hooks";
import { ModalMenu } from "../../ModalMenu/ModalMenu";
import { useRecoilValue } from "recoil";
import { Gang, Lang } from "../../../reducers/atoms";

const sortMembersByScore = (members: Member[]) => {
  const sortedMembers = members.sort((a, b) => b.reputation - a.reputation);
  return sortedMembers;
};

const Overview = () => {
  const daLang: any = useRecoilValue(Lang);
  const { allPermissions, name } = useRecoilValue(Gang);
  const [loaded, setLoaded] = useState(false);
  const [allMembers, setAllMembers] = useState<Member[]>([]);
  const [filtered, setfiltered] = useState<Member[]>([]);
  const { height } = useViewportSize();
  const [topRanked, setTopRanked] = useState("");
  const [modal, setModal] = useState<ModalType>({
    state: false,
    info: {
      title: "",
      options: [],
    },
  });

  const handleRemove = (identifier: string) => {
    fetchNui("av_gangs", "removeMember", identifier);
    const result = allMembers.filter(
      (member) => member.identifier !== identifier,
    );
    setAllMembers(result);
    setfiltered(result);
  };
  const handleEdit = (member: Member) => {
    setModal({
      ...modal,
      state: true,
      info: {
        size: "255",
        title: member.alias ? member.alias : member.playerName,
        options: [
          {
            type: "avatar",
            image: member.photo,
            size: "xl",
            style: { marginTop: "10px" },
          },
          {
            name: "photo",
            title: daLang.photo,
            type: "text",
            default: member.photo,
          },
          {
            name: "alias",
            title: daLang.alias,
            type: "text",
            default: member.alias,
          },
          {
            name: "rank",
            title: daLang.rank,
            type: "text",
            default: member.rank,
          },
          {
            name: "permissions",
            title: daLang.permissions,
            type: "multiselect",
            default: member.permissions,
            options: allPermissions,
          },
        ],
        extraData: {
          event: "updateMember",
          identifier: member.identifier,
          name,
        },
        button: daLang.confirm,
      },
    });
  };
  const handleSearch = (input: string) => {
    const res = allMembers.filter((member) =>
      member.alias ? member.alias.toLowerCase().includes(input) : false,
    );
    setfiltered(res);
  };
  const handleInvite = async () => {
    const resp = await fetchNui("av_gangs", "invite");
    if (resp) {
      const sorted = sortMembersByScore(resp);
      setAllMembers(sorted);
      setfiltered(sorted);
      if (sorted[0] && sorted[0].reputation > 0)
        setTopRanked(sorted[0].identifier);
    }
  };
  const modalCallback = async (data?: any) => {
    if (!data) {
      setModal({ ...modal, state: false });
      return;
    }
    setModal({ ...modal, state: false });
    const { extraData } = data;
    const resp = await fetchNui("av_gangs", extraData.event, data);
    if (!resp) return;
    const sorted = sortMembersByScore(resp);
    setAllMembers(sorted);
    setfiltered(sorted);
  };
  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_gangs", "getMembers");
      if (resp) {
        const sorted = sortMembersByScore(resp);
        setAllMembers(sorted);
        setfiltered(sorted);
        if (sorted[0] && sorted[0].reputation > 0)
          setTopRanked(sorted[0].identifier);
      } else {
        if (isEnvBrowser()) {
          const sorted = sortMembersByScore(ApiMembers);
          setAllMembers(sorted);
          setfiltered(sorted);
          if (sorted[0] && sorted[0].reputation > 0)
            setTopRanked(sorted[0].identifier);
        }
      }
      setTimeout(() => {
        setLoaded(true);
      }, 100);
    };
    fetchData();
  }, []);
  if (!loaded) return <Loading />;
  return (
    <Grid>
      {modal.state && <ModalMenu data={modal} callback={modalCallback} />}
      <Grid.Col maw={height > 700 ? 300 : 250}>
        <GangCard />
      </Grid.Col>
      <Grid.Col span="auto">
        <Leaderboard
          members={filtered}
          handleSearch={handleSearch}
          topRanked={topRanked}
          handleEdit={handleEdit}
          handleInvite={handleInvite}
          handleRemove={handleRemove}
        />
      </Grid.Col>
    </Grid>
  );
};

export default Overview;
