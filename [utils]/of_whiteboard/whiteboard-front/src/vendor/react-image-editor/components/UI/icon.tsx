import type { IconNamesType } from "../../constants/icons";

import blurIcon from "../../assets/icons/blur.svg?raw";
import circleIcon from "../../assets/icons/circle.svg?raw";
import cropIcon from "../../assets/icons/crop.svg?raw";
import cursorIcon from "../../assets/icons/cursor.svg?raw";
import pencilIcon from "../../assets/icons/pencil.svg?raw";
import redoIcon from "../../assets/icons/redo.svg?raw";
import squareIcon from "../../assets/icons/square.svg?raw";
import undoIcon from "../../assets/icons/undo.svg?raw";
import trashIcon from "../../assets/icons/trash.svg?raw";
import textIcon from "../../assets/icons/text.svg?raw";
import boldIcon from "../../assets/icons/bold.svg?raw";
import italicIcon from "../../assets/icons/italic.svg?raw";
import underlineIcon from "../../assets/icons/underline.svg?raw";
import alignLeftIcon from "../../assets/icons/align-left.svg?raw";
import alignCenterIcon from "../../assets/icons/align-center.svg?raw";
import alignRightIcon from "../../assets/icons/align-right.svg?raw";
import highlighterIcon from "../../assets/icons/highlighter.svg?raw";
import eraserIcon from "../../assets/icons/eraser.svg?raw";
import clearFormatIcon from "../../assets/icons/clear-format.svg?raw";

const iconMap: Partial<Record<IconNamesType, string>> = {
  blur: blurIcon,
  circle: circleIcon,
  crop: cropIcon,
  cursor: cursorIcon,
  pencil: pencilIcon,
  redo: redoIcon,
  square: squareIcon,
  undo: undoIcon,
  trash: trashIcon,
  text: textIcon,
  bold: boldIcon,
  italic: italicIcon,
  underline: underlineIcon,
  "align-left": alignLeftIcon,
  "align-center": alignCenterIcon,
  "align-right": alignRightIcon,
  highlighter: highlighterIcon,
  eraser: eraserIcon,
  "clear-format": clearFormatIcon,
};

interface IconProps {
  name: IconNamesType;
  width?: number;
  height?: number;
  className?: string;
  title?: string;
}

export const Icon = ({ name, width = 20, height = 20, className, title }: IconProps) => {
  const rawSvg = iconMap[name];

  if (!rawSvg) {
    return null;
  }

  const viewBoxMatch = rawSvg.match(/viewBox=["']([^"']+)["']/);
  const viewBox = viewBoxMatch ? viewBoxMatch[1] : "0 0 20 20";

  const innerContentMatch = rawSvg.match(/<svg[^>]*>([\s\S]*?)<\/svg>/);
  const innerContent = innerContentMatch ? innerContentMatch[1] : rawSvg;

  return (
    <svg
      width={width}
      height={height}
      viewBox={viewBox}
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={`inline-block ${className || ""}`}
      role="img"
      aria-hidden={!title}
      {...(title && { "aria-label": title })}
    >
      {title && <title>{title}</title>}
      <g dangerouslySetInnerHTML={{ __html: innerContent }} />
    </svg>
  );
};

export default Icon;
