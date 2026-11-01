import { ReactElement } from "react";
import { IconPackage, IconUsersGroup, IconScanEye } from "@tabler/icons-react";

interface IconMap {
  [key: string]: ReactElement;
}

export const Icons: IconMap = {
  stash: <IconPackage stroke={1.5} style={{ width: "16px", height: "16px" }} />,
  production: (
    <IconUsersGroup stroke={1.5} style={{ width: "16px", height: "16px" }} />
  ),
  security: (
    <IconScanEye stroke={1.5} style={{ width: "16px", height: "16px" }} />
  ),
};
