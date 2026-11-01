import { Stack, Modal, Text, Textarea, Group, Button } from "@mantine/core";
import { Send } from "lucide-react";
import { useState } from "react";
import { fetchNui } from "../../../../../hooks/useNuiEvents";
import { MarketItem } from "../../../../../types/types";
import { Lang } from "../../../../../reducers/atoms";
import { useAtomValue } from "jotai";

export const Contact = ({
  item,
  contactOpened,
  closeContact,
}: {
  item: MarketItem;
  contactOpened: boolean;
  closeContact: () => void;
}) => {
  const lang: any = useAtomValue(Lang);
  const [message, setMessage] = useState("");

  const handleSendMessage = () => {
    fetchNui("av_marketplace", "sendMessageToSeller", {
      itemId: item.post_id,
      message: message.trim(),
    });
    setMessage("");
    closeContact();
  };

  return (
    <>
      <Modal
        opened={contactOpened}
        onClose={closeContact}
        title={`${lang.contactSendMessageTo} ${item.seller}`}
        centered
        radius="lg"
        size="lg"
      >
        <Stack gap="md">
          <Text size="xs" fw={500} style={{ color: "var(--text-hint)" }} mt={8}>
            {lang.contactItem}:{" "}
            <Text span fw={600} style={{ color: "var(--text-main)" }}>
              {item.title}
            </Text>{" "}
            ({`$${item.price.toLocaleString("en-US")}`})
          </Text>
          <Textarea
            placeholder={lang.contactPlaceholder}
            minRows={4}
            maxRows={6}
            maxLength={200}
            autosize
            radius="md"
            value={message}
            onChange={(event) => setMessage(event.currentTarget.value)}
            styles={{
              input: {
                backgroundColor: "var(--bg-main)",
                borderColor: "var(--border-light)",
                color: "var(--text-main)",
                fontSize: "14px",
              },
            }}
          />
          <Group justify="flex-end" gap="sm">
            <Button
              variant="unstyled"
              radius="md"
              onClick={closeContact}
              style={{
                height: "38px",
                padding: "0 16px",
                backgroundColor: "var(--bg-elevated)",
                border: "1px solid var(--border-light)",
                color: "var(--text-muted)",
                fontSize: "13px",
                fontWeight: 600,
              }}
            >
              {lang.contactCancel}
            </Button>
            <Button
              radius="md"
              rightSection={<Send size={14} />}
              onClick={handleSendMessage}
              disabled={!message.trim()}
              style={{
                height: "38px",
                padding: "0 16px",
                backgroundColor: "var(--accent)",
                color: "var(--text-main)",
                fontSize: "13px",
                fontWeight: 600,
                border: "none",
                opacity: message.trim() ? 1 : 0.4,
              }}
            >
              {lang.contactSend}
            </Button>
          </Group>
        </Stack>
      </Modal>
    </>
  );
};
