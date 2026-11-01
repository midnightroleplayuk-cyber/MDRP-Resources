import { Modal } from "@mantine/core";
import { TrackType } from "../../types/types";
import global from "../../global.module.css";
import { RecordComponent } from "./RecordComponent";

interface Properties {
  isAdmin: boolean;
  track?: TrackType;
  closeTrack: (state: TrackType | null) => void;
}

export const Records = ({ track, closeTrack, isAdmin }: Properties) => {
  return (
    <Modal
      opened
      title={track?.name}
      onClose={() => {
        closeTrack(null);
      }}
      classNames={global}
      centered
      size={700}
      lockScroll={false}
      c="white"
      trapFocus={false}
      styles={{
        content: {
          height: 465,
          backdropFilter: isAdmin ? "unset" : undefined,
        },
      }}
    >
      <RecordComponent isAdmin={isAdmin} identifier={track?.identifier ?? ""} />
    </Modal>
  );
};
