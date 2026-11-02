import { useState } from "react";
import { Box, Text, Image, Modal } from "@mantine/core";
import { parse } from "./utils";
import classes from "./style.module.css";
import global from "../../global.module.css";

export const MailBody = ({ body }: { body: string }) => {
  const [zoom, setZoom] = useState<string | null>(null);
  const segs = parse(body || "");
  return (
    <>
      <Box className={classes.mailBody}>
        {segs.map((s, i) =>
          s.type === "text" ? (
            <Text span key={i}>
              {s.value}
            </Text>
          ) : (
            <Box
              key={i}
              className={classes.bodyImage}
              onClick={() => setZoom(s.url)}
            >
              <Image
                src={s.url}
                alt=""
                fit="cover"
                className={classes.bodyImageInner}
              />
            </Box>
          ),
        )}
      </Box>
      <Modal
        opened={!!zoom}
        onClose={() => setZoom(null)}
        size="auto"
        centered
        withinPortal
        classNames={{ content: global.content, header: global.header }}
      >
        {zoom && (
          <Image
            src={zoom}
            alt=""
            fit="contain"
            className={classes.lightboxImg}
          />
        )}
      </Modal>
    </>
  );
};
