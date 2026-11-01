import {
  Modal,
  Text,
  TextInput,
  Image,
  Button,
  Group,
  Stack,
} from "@mantine/core";
import { User, Save } from "lucide-react";
import { fetchNui } from "../../../../hooks/useNuiEvents";
import { useAtom, useAtomValue } from "jotai";
import { Lang, Profile } from "../../../../reducers/atoms";

interface Properties {
  opened: boolean;
  close: () => void;
}

export const Settings = ({ opened, close }: Properties) => {
  const lang: any = useAtomValue(Lang);
  const [profile, setProfile] = useAtom(Profile);

  const handleSaveProfile = async () => {
    await fetchNui("av_marketplace", "saveProfileSettings", profile);
    close();
  };

  return (
    <Modal
      opened={opened}
      onClose={close}
      p="lg"
      centered
      title={
        <Group gap="sm">
          <User size={20} color="var(--accent-light)" />
          <Text size="lg" fw={600} c="var(--text-main)">
            {lang.settingsPublicProfile}
          </Text>
        </Group>
      }
    >
      <Group align="flex-start" gap="xl" wrap="nowrap" mt="lg">
        <Stack align="center" gap="sm" mt="md">
          <Image
            src={profile.avatar}
            h={100}
            w={100}
            radius="100%"
            fallbackSrc="avatar_default.png"
          />
        </Stack>
        <Stack gap="md" style={{ flex: 1 }}>
          <TextInput
            label={lang.settingsDisplayName}
            placeholder={lang.settingsDisplayNamePlaceholder}
            value={profile.username}
            onChange={(e) =>
              setProfile({ ...profile, username: e.target.value })
            }
            maxLength={50}
            styles={{
              input: {
                backgroundColor: "var(--bg-card)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: {
                color: "var(--text-secondary)",
                marginBottom: "4px",
              },
            }}
          />
          <TextInput
            label={lang.settingsAvatar}
            placeholder={lang.settingsAvatarPlaceholder}
            value={profile.avatar}
            onChange={(e) => setProfile({ ...profile, avatar: e.target.value })}
            maxLength={200}
            styles={{
              input: {
                backgroundColor: "var(--bg-card)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
              },
              label: {
                color: "var(--text-secondary)",
                marginBottom: "4px",
              },
            }}
          />
        </Stack>
      </Group>
      <Button
        fullWidth
        mt="lg"
        leftSection={<Save size={16} />}
        radius="md"
        onClick={handleSaveProfile}
        style={{
          backgroundColor: "var(--accent)",
          color: "var(--text-main)",
        }}
      >
        {lang.settingsSaveChanges}
      </Button>
    </Modal>
  );
};

export default Settings;
