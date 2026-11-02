import { useState } from "react";
import {
  Modal,
  MultiSelect,
  Stack,
  TextInput,
  Button,
  Checkbox,
} from "@mantine/core";
import { PermissionsType } from "./api";
import { SelectType } from "../../../types/types";
import { useAtomValue } from "jotai";
import { Lang } from "../../../reducers/atoms";
import global from "../../../global.module.css";
import { MultiSelector } from "../MultiSelector";

export const Panel = ({
  permission,
  allJobs,
  close,
  handleSave,
}: {
  permission: PermissionsType | null;
  allJobs: SelectType[];
  close: () => void;
  handleSave: (permission: PermissionsType) => void;
}) => {
  const daLang: any = useAtomValue(Lang);
  const lang = daLang.admin;
  const [data, setData] = useState(
    permission ?? { value: "", label: "", jobs: [], default: false },
  );
  const updateField = (field: keyof PermissionsType, value: any) => {
    setData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };
  return (
    <Modal
      classNames={global}
      opened
      onClose={close}
      withinPortal={false}
      centered
      lockScroll={false}
      size={355}
      title={lang.perms_panel_title}
    >
      <Stack gap="xs">
        <TextInput
          classNames={global}
          size="xs"
          value={data.value}
          label={lang.perms_perm}
          description={lang.perms_perm_desc}
          onChange={(e) => {
            updateField("value", e.currentTarget.value);
          }}
        />
        <TextInput
          classNames={global}
          size="xs"
          value={data.label}
          label={lang.label}
          description={lang.perms_label_desc}
          onChange={(e) => {
            updateField("label", e.currentTarget.value);
          }}
        />
        <MultiSelector
          label={lang.perms_excl_jobs}
          description={lang.perms_excl_jobs_desc}
          data={allJobs}
          values={data.jobs ? data.jobs : undefined}
          updateData={(e) => {
            updateField("jobs", e);
          }}
        />
        <Checkbox
          mt="xs"
          classNames={global}
          size="xs"
          checked={data.default}
          label={lang.perms_default}
          description={lang.perms_default_desc}
          onChange={(e) => {
            updateField("default", e.currentTarget.checked);
          }}
        />
        <Button
          className={global.button}
          variant="filled"
          size="xs"
          mt="sm"
          disabled={data.value.length == 0 || data.label.length == 0}
          onClick={() => {
            handleSave(data);
          }}
        >
          {lang.save}
        </Button>
      </Stack>
    </Modal>
  );
};
