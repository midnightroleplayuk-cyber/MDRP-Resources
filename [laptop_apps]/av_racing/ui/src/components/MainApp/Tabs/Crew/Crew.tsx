import { Grid, Modal } from "@mantine/core";
import { useEffect, useState } from "react";
import { CrewProperties, Member } from "../../../../types/types";
import { useRecoilState, useRecoilValue } from "recoil";
import { Lang, Profile } from "../../../../reducers/atoms";
import { fetchNui, isEnvBrowser } from "../../../../hooks/useNuiEvents";
import { ApiMembers } from "../../../../Api/Members";
import { Loading } from "../../../Loading";
import { LeftPanel } from "./LeftPanel";
import { RightPanel } from "./RightPanel";
import { isWide } from "../../../../hooks/isWide";
import { sortData } from "./utils";
import global from "../../../../global.module.css";
import { getRankedLeaderboard } from "../../../../hooks/sortbyElo";

const Crew = () => {
  const lang: any = useRecoilValue(Lang);
  const [profile, setProfile] = useRecoilState(Profile);
  const [showModal, setShowModal] = useState(false);
  const { crew } = profile;
  const [loaded, setLoaded] = useState(false);
  const [search, setSearch] = useState("");
  const [reverseSortDirection, setReverseSortDirection] = useState(false);
  const [sortBy, setSortBy] = useState<keyof Member | null>(null);
  const [members, setMembers] = useState<Member[]>([]);
  const [filtered, setFiltered] = useState<Member[]>([]);

  const wide = isWide();

  const handlePhoto = (input: string) => {
    setProfile({
      ...profile,
      crew: {
        ...crew,
        photo: input,
      } as CrewProperties,
    });
  };

  const handleSave = () => {
    fetchNui("av_racing", "updateCrew", crew);
  };

  const setSorting = (field: keyof Member) => {
    const reversed = field === sortBy ? !reverseSortDirection : false;
    setReverseSortDirection(reversed);
    setSortBy(field);
    setFiltered(sortData(members, { sortBy: field, reversed, search }));
  };

  const handleSearch = (input: string) => {
    setSearch(input);
    const res = members.filter((member) =>
      member.name ? member.name.toLowerCase().includes(input) : false,
    );
    setFiltered(res);
  };

  const handleBoss = (identifier: string, state: boolean) => {
    const updated = members.map((member) => {
      if (member && member.identifier === identifier) {
        return { ...member, isBoss: state };
      }
      return member;
    });
    setMembers(updated);
    setFiltered(updated);
    fetchNui("av_racing", "changeBoss", {
      identifier,
      state,
    });
    if (identifier === profile.identifier) {
      setProfile({
        ...profile,
        crew: {
          ...crew,
          isBoss: state,
        } as CrewProperties,
      });
    }
  };

  const handleRemove = (identifier: string) => {
    const updatedMembers = members.filter(
      (member: Member) => member.identifier !== identifier,
    );
    setMembers(updatedMembers);
    setFiltered(updatedMembers);
    fetchNui("av_racing", "fireMember", identifier);
  };

  const handleInvite = async () => {
    const resp = await fetchNui("av_racing", "inviteCrew", crew);
    if (!resp) return;
    setMembers(resp);
    setFiltered(resp);
  };
  const fetchData = async () => {
    const resp = await fetchNui("av_racing", "getCrew", crew?.name);
    if (resp) {
      const ordered = getRankedLeaderboard(resp);
      setMembers(ordered as Member[]);
      setFiltered(ordered as Member[]);
    } else {
      if (isEnvBrowser()) {
        setMembers(ApiMembers);
        setFiltered(ApiMembers);
      }
    }
    setTimeout(() => {
      setLoaded(true);
    }, 100);
  };
  useEffect(() => {
    if (!loaded) fetchData();
  }, []);

  if (!loaded) return <Loading />;
  return (
    <>
      <Modal
        classNames={global}
        centered
        lockScroll={false}
        c="white"
        trapFocus={false}
        opened={showModal}
        size={355}
        onClose={() => {
          setShowModal(false);
        }}
      >
        <LeftPanel
          crew={crew}
          handlePhoto={handlePhoto}
          handleSave={handleSave}
          wide={wide}
          isModal={true}
          lang={lang}
        />
      </Modal>
      <Grid>
        {wide && (
          <Grid.Col maw={wide ? 325 : 200} miw={wide ? 325 : 200}>
            <LeftPanel
              crew={crew}
              handlePhoto={handlePhoto}
              handleSave={handleSave}
              wide={wide}
              lang={lang}
            />
          </Grid.Col>
        )}
        <Grid.Col span="auto">
          <RightPanel
            lang={lang}
            isBoss={crew?.isBoss ?? false}
            members={filtered}
            setSorting={setSorting}
            handleSearch={handleSearch}
            handleRemove={handleRemove}
            wide={wide}
            sortBy={sortBy}
            reversed={reverseSortDirection}
            handleInvite={handleInvite}
            showModal={setShowModal}
            handleBoss={handleBoss}
          />
        </Grid.Col>
      </Grid>
    </>
  );
};
export default Crew;
