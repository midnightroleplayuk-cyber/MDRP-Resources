import { ModalType, SelectType } from "../../../types/types";
import { AnimationsType, PedsType, ShellType } from "./types";

export const getShellsForSelect = (shells: ShellType[]): SelectType[] => {
  return shells
    .filter((shell) => shell?.shell && shell?.label)
    .sort((a, b) => (a.label as string).localeCompare(b.label as string))
    .map((shell) => ({
      value: shell.shell as string,
      label: shell.label as string,
    }));
};

export const getAnimationsForSelect = (
  animations: AnimationsType[]
): SelectType[] => {
  return animations
    .map((anim) => {
      if (anim?.dict && anim?.label) {
        return {
          value: `${anim.dict}:${anim.animation}`,
          label: anim.label,
        };
      }
      return undefined;
    })
    .filter(Boolean) as SelectType[];
};

export const getPedsForSelect = (peds: PedsType[]): SelectType[] => {
  return peds
    .map((ped) => {
      if (ped?.model && ped?.label) {
        return {
          value: ped.model,
          label: ped.label,
        };
      }
      return undefined;
    })
    .filter(Boolean) as SelectType[];
};

export const ApiModal: ModalType = {
  state: false,
  info: {
    title: "",
    options: [],
    button: "",
  },
};

type AnimData = `${string}:${string}`;

export const splitAnimData = (animData?: AnimData) => {
  if (!animData) return [undefined, undefined];
  const [dictionary, animation] = animData.split(":");
  return [dictionary, animation];
};
