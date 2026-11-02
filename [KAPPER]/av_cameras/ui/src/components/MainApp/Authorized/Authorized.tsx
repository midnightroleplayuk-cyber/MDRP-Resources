import { Modal, ScrollArea, Stack, Group, Button, Text } from "@mantine/core";
import { useEffect, useState } from "react";
import { Loading } from "../../Loading";
import { fetchNui, isEnvBrowser } from "../../../hooks/useNuiEvents";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";

interface Properties {
  type: string;
  identifier: string;
  onClose: () => void;
}

interface AuthorizedUser {
  identifier: string;
  label: string;
}

export const Authorized = ({ type, identifier, onClose }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [loaded, setLoaded] = useState(false);
  const [authorized, setAuthorized] = useState<AuthorizedUser[]>([]);

  const handleRevoke = (identifier: string) => {
    setAuthorized((prev) =>
      prev.filter((user: AuthorizedUser) => user.identifier !== identifier),
    );
  };

  const handleSave = () => {
    fetchNui("av_cameras", "updateAuthorized", {
      type,
      identifier,
      authorized,
    });
    onClose();
  };

  useEffect(() => {
    const fetchData = async () => {
      const resp = await fetchNui("av_cameras", "fetchAuthorized", {
        type,
        identifier,
      });
      if (resp) {
        setAuthorized(resp);
      } else {
        if (isEnvBrowser()) {
          setAuthorized([
            { identifier: "123456789", label: "John Doe" },
            { identifier: "987654321", label: "Jane Smith" },
            { identifier: "123456789", label: "John Doe" },
            { identifier: "987654321", label: "Jane Smith" },
            { identifier: "123456789", label: "John Doe" },
            { identifier: "987654321", label: "Jane Smith" },
            { identifier: "123456789", label: "John Doe" },
            { identifier: "987654321", label: "Jane Smith" },
            { identifier: "123456789", label: "John Doe" },
            { identifier: "987654321", label: "Jane Smith" },
          ]);
        }
      }
      setLoaded(true);
    };
    fetchData();
  }, []);

  return (
    <Modal
      opened
      onClose={onClose}
      title={lang.manage_access}
      centered
      lockScroll={false}
      c="white"
      trapFocus={false}
      styles={{
        body: {
          height: 400,
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
        },
      }}
      classNames={{
        header: "header",
        title: "title",
        body: "body",
        content: "content",
      }}
    >
      {loaded ? (
        <>
          <ScrollArea
            flex={1}
            mb="sm"
            type="hover"
            offsetScrollbars
            scrollbarSize={6}
          >
            <Stack gap="sm">
              {authorized.length > 0 ? (
                authorized.map((item: AuthorizedUser, index: number) => (
                  <Group
                    key={index}
                    bg="var(--bg-card)"
                    p="sm"
                    style={{ borderRadius: 6 }}
                  >
                    <Text fz="sm" c="var(--text-main)">
                      {item.label}
                    </Text>
                    <Button
                      ml="auto"
                      size="xs"
                      variant="outline"
                      color="red.5"
                      onClick={() => handleRevoke(item.identifier)}
                    >
                      {lang.revoke}
                    </Button>
                  </Group>
                ))
              ) : (
                <Text fz="sm" c="var(--text-dim)" ta="center">
                  {lang.no_authorized_users}
                </Text>
              )}
            </Stack>
          </ScrollArea>
          <Button
            fullWidth
            variant="outline"
            color="var(--accent)"
            onClick={handleSave}
          >
            {lang.save_changes}
          </Button>
        </>
      ) : (
        <Loading />
      )}
    </Modal>
  );
};
