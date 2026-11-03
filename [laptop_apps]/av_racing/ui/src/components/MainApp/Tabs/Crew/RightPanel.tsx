import { useState, useEffect } from "react";
import {
  Box,
  Stack,
  TextInput,
  Group,
  Avatar,
  Text,
  Tooltip,
  Select,
  Pagination,
  ScrollArea,
} from "@mantine/core";
import { Member } from "../../../../types/types";

import {
  UsersRound,
  Image as IconPhotoEdit,
  UserRoundPlus,
  UserMinus,
  Trash,
  Search,
  UserPlus,
} from "lucide-react";
import global from "../../../../global.module.css";
import classes from "./style.module.css";

interface Properties {
  lang: any;
  isBoss: boolean;
  members: Member[];
  setSorting: (key: keyof Member) => void;
  handleSearch: (input: string) => void;
  handleRemove: (identifier: string) => void;
  handleBoss: (identifier: string, state: boolean) => void;
  handleInvite: () => void;
  wide: boolean;
  sortBy: keyof Member | null;
  reversed: boolean;
  showModal: (state: boolean) => void;
}

export const RightPanel = ({
  lang,
  isBoss,
  members,
  setSorting,
  handleSearch,
  handleRemove,
  handleInvite,
  handleBoss,
  wide,
  sortBy,
  showModal,
}: Properties) => {
  const [activePage, setPage] = useState(1);
  const itemsPerPage = 7;

  useEffect(() => {
    setPage(1);
  }, [members.length, sortBy]);

  const totalPages = Math.ceil(members.length / itemsPerPage);
  const paginatedMembers = members.slice(
    (activePage - 1) * itemsPerPage,
    activePage * itemsPerPage,
  );

  return (
    <Stack style={{ height: "100%", flex: 1, overflow: "hidden" }} gap={0}>
      <Box className={classes.header}>
        <Group gap="md">
          <Box className={classes.iconBox}>
            <UsersRound size={20} />
          </Box>
          <Text className={classes.title}>
            {`${members.length} ${lang.members ?? "MEMBERS"}`}
          </Text>
        </Group>

        <Group gap="sm">
          {!wide && isBoss && (
            <Tooltip
              label={lang.crew_logo ?? "Edit Logo"}
              color="var(--tooltip)"
              fz="xs"
              withArrow
            >
              <button
                className={classes.actionBtn}
                onClick={() => showModal(true)}
              >
                <IconPhotoEdit size={16} />
              </button>
            </Tooltip>
          )}

          <TextInput
            classNames={global}
            placeholder={lang.search ?? "Search member..."}
            leftSection={<Search size={14} />}
            size="xs"
            w={180}
            onChange={(e) => handleSearch(e.currentTarget.value)}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                border: "1px solid var(--border-color)",
                color: "var(--text-main)",
              },
            }}
          />

          <Select
            classNames={global}
            size="xs"
            value={sortBy as string}
            onChange={(val) => setSorting(val as keyof Member)}
            data={[
              { value: "elo", label: lang.season_elo ?? "Sort by Elo" },
              { value: "wins", label: lang.season_victories ?? "Sort by Wins" },
              { value: "races", label: lang.season_races ?? "Sort by Races" },
              { value: "name", label: "Sort by Name" },
            ]}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                border: "1px solid var(--border-color)",
                color: "var(--text-dim)",
              },
              dropdown: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
              },
              option: {
                color: "var(--text-main)",
              },
            }}
          />

          {isBoss &&
            (wide ? (
              <button className={classes.solidButton} onClick={handleInvite}>
                {lang.invite_member ?? "INVITE MEMBER"}
              </button>
            ) : (
              <Tooltip
                label={lang.invite_member ?? "Invite Member"}
                color="var(--tooltip)"
                fz="xs"
                withArrow
              >
                <button
                  className={classes.actionBtn}
                  style={{
                    color: "var(--accent)",
                    borderColor: "rgba(206, 255, 28, 0.3)",
                  }}
                  onClick={handleInvite}
                >
                  <UserPlus size={16} />
                </button>
              </Tooltip>
            ))}
        </Group>
      </Box>
      <ScrollArea
        style={{ flex: 1 }}
        type="hover"
        offsetScrollbars
        scrollbarSize={4}
        pr="sm"
      >
        <Box className={classes.listContainer}>
          {paginatedMembers.map((member) => (
            <Box className={classes.memberRow} key={member.identifier}>
              <Box className={classes.memberInfo}>
                <Avatar size="lg" src={member.photo} radius="md" />
                <Box className={classes.nameBlock}>
                  <span className={classes.memberName}>{member.name}</span>
                  <span
                    className={`${classes.memberBadge} ${
                      member.isBoss ? classes.badgeBoss : classes.badgeMember
                    }`}
                  >
                    {member.isBoss
                      ? (lang.boss ?? "BOSS")
                      : (lang.member ?? "MEMBER")}
                  </span>
                </Box>
              </Box>

              <Box className={classes.statsContainer}>
                {wide && (
                  <Box
                    className={classes.statBlock}
                    style={{ minWidth: 80, alignItems: "center" }}
                  >
                    <span className={classes.statLabel}>
                      {lang.joined ?? "JOINED"}
                    </span>
                    <span
                      className={classes.statValue}
                      style={{ color: "var(--text-dim)", fontSize: "12px" }}
                    >
                      {member.joined}
                    </span>
                  </Box>
                )}
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_races ?? "RACES"}
                  </span>
                  <span className={classes.statValue}>{member.races}</span>
                </Box>
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_victories ?? "WINS"}
                  </span>
                  <span className={classes.statValue}>{member.wins}</span>
                </Box>
                <Box className={classes.statBlock}>
                  <span className={classes.statLabel}>
                    {lang.season_elo ?? "ELO"}
                  </span>
                  <span className={classes.statValueAccent}>
                    {member.elo.toLocaleString("en-US")}
                  </span>
                </Box>
              </Box>

              {isBoss && (
                <Box className={classes.actionGroup} ml="lg">
                  <Tooltip
                    label={
                      member.isBoss
                        ? (lang.remove_boss_button ?? "Demote")
                        : (lang.set_boss_button ?? "Promote")
                    }
                    color="var(--tooltip)"
                    fz="xs"
                    withArrow
                  >
                    <button
                      className={`${classes.actionBtn} ${
                        member.isBoss
                          ? classes.actionBtnDemote
                          : classes.actionBtnPromote
                      }`}
                      onDoubleClick={() =>
                        handleBoss(member.identifier, !member.isBoss)
                      }
                    >
                      {member.isBoss ? (
                        <UserMinus size={14} />
                      ) : (
                        <UserRoundPlus size={14} />
                      )}
                    </button>
                  </Tooltip>
                  <Tooltip
                    label={lang.remove_member_button ?? "Kick Member"}
                    color="var(--tooltip)"
                    fz="xs"
                    withArrow
                  >
                    <button
                      className={`${classes.actionBtn} ${classes.actionBtnKick}`}
                      onDoubleClick={() => handleRemove(member.identifier)}
                    >
                      <Trash size={14} />
                    </button>
                  </Tooltip>
                </Box>
              )}
            </Box>
          ))}
        </Box>
      </ScrollArea>
      {totalPages > 1 && (
        <Group justify="center" pt="md" pb="xs">
          <Pagination
            value={activePage}
            onChange={setPage}
            total={totalPages}
            color="var(--accent)"
            size="sm"
            styles={{
              control: {
                backgroundColor: "var(--bg-panel)",
                border: "1px solid var(--border-color)",
                color: "var(--text-main)",
                "&[data-active]": {
                  backgroundColor: "var(--accent)",
                  color: "#000",
                  borderColor: "var(--accent)",
                },
              },
            }}
          />
        </Group>
      )}
    </Stack>
  );
};
