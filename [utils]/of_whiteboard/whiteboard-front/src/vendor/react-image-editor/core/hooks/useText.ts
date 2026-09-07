import { fabric } from "fabric";
import { useCallback } from "react";

import type { EditorFabricObject, UseTextReturn } from "../types";
import { getViewportCenter, getImageBounds } from "../utils";

interface UseTextOptions {
  defaultColor?: string;
  defaultFontSize?: number;
  defaultFontFamily?: string;
  onTextAdd?: (text: fabric.IText) => void;
  onTextEditEnd?: (text: fabric.IText) => void;
}

const CUSTOM_FONT_FAMILIES = [
  "Roboto",
  "Montserrat",
  "Playfair Display",
  "Oswald",
  "Pacifico",
  "Anton",
  "Bebas Neue",
  "JetBrains Mono",
];

const SYSTEM_FONT_FAMILIES = [
  "Arial",
  "Helvetica",
  "Times New Roman",
  "Georgia",
  "Verdana",
  "Courier New",
  "Impact",
];

const DEFAULT_FONT_FAMILIES = [...CUSTOM_FONT_FAMILIES, ...SYSTEM_FONT_FAMILIES];

export const TEXT_STYLE_PRESETS = {
  normal: { fontSize: 24, fontWeight: "normal" as const },
  heading1: { fontSize: 48, fontWeight: "bold" as const },
  heading2: { fontSize: 36, fontWeight: "bold" as const },
  heading3: { fontSize: 28, fontWeight: "bold" as const },
};

export type TextStylePreset = keyof typeof TEXT_STYLE_PRESETS;

const DEFAULT_PLACEHOLDER_TEXT = "Text";

const RTL_CHAR_PATTERN = /[֐-׿؀-ۿݐ-ݿࢠ-ࣿ]/;

function isRtlText(text: string): boolean {
  return RTL_CHAR_PATTERN.test(text);
}

function applyAutoDirection(textObj: fabric.IText, canvas: fabric.Canvas) {
  const rtl = isRtlText(textObj.text || "");
  const nextDirection = rtl ? "rtl" : "ltr";
  const currentAlign = textObj.textAlign;
  const wasAutoAligned = currentAlign === "left" || currentAlign === "right";

  if (textObj.direction === nextDirection && (!wasAutoAligned || currentAlign === (rtl ? "right" : "left"))) {
    return;
  }

  const props: Partial<fabric.IText> = { direction: nextDirection };
  if (wasAutoAligned) {
    props.textAlign = rtl ? "right" : "left";
  }

  textObj.set(props);
  canvas.requestRenderAll();
}

export function useText(
  canvasRef: React.MutableRefObject<fabric.Canvas | null>,
  imageRef: React.MutableRefObject<fabric.Image | null>,
  options: UseTextOptions = {}
): UseTextReturn {
  const {
    defaultColor = "#000000",
    defaultFontSize = 24,
    defaultFontFamily = "Arial",
    onTextAdd,
    onTextEditEnd,
  } = options;

  const calculateTextPosition = useCallback(
    (
      canvas: fabric.Canvas,
      textWidth: number,
      textHeight: number
    ): { x: number; y: number } => {
      const originalImage = imageRef.current;
      const imgBounds = getImageBounds(originalImage);

      const viewportCenter = getViewportCenter(canvas);
      let x = viewportCenter.x;
      let y = viewportCenter.y;

      if (imgBounds) {
        const halfWidth = textWidth / 2;
        const halfHeight = textHeight / 2;

        x = Math.max(
          imgBounds.left + halfWidth + 10,
          Math.min(x, imgBounds.left + imgBounds.width - halfWidth - 10)
        );
        y = Math.max(
          imgBounds.top + halfHeight + 10,
          Math.min(y, imgBounds.top + imgBounds.height - halfHeight - 10)
        );
      }

      return { x, y };
    },
    [imageRef]
  );

  const addText = useCallback(
    (initialText: string = DEFAULT_PLACEHOLDER_TEXT) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const textObj = new fabric.IText(initialText, {
        fontSize: defaultFontSize,
        fontFamily: defaultFontFamily,
        originX: "center",
        originY: "center",
        editable: true,
        selectable: true,
        evented: true,
        hasControls: true,
        hasBorders: true,
        cornerSize: 10,
        transparentCorners: false,
        objectCaching: false,
      });

      const estimatedWidth = textObj.width || 100;
      const estimatedHeight = textObj.height || defaultFontSize;

      const position = calculateTextPosition(
        canvas,
        estimatedWidth,
        estimatedHeight
      );

      textObj.set({
        fill: defaultColor,
        cornerColor: defaultColor,
        borderColor: defaultColor,
        left: position.x,
        top: position.y,
      });

      const customText = textObj as EditorFabricObject;
      customText.isText = true;
      customText.isShape = true;
      customText.shapeType = "text";
      customText.id = `text-${Date.now()}`;

      textObj.on("editing:exited", () => {
        onTextEditEnd?.(textObj);
      });

      textObj.on("changed", () => applyAutoDirection(textObj, canvas));
      applyAutoDirection(textObj, canvas);

      canvas.add(textObj);
      canvas.setActiveObject(textObj);
      canvas.renderAll();

      textObj.enterEditing();
      textObj.selectAll();

      onTextAdd?.(textObj);
    },
    [
      canvasRef,
      calculateTextPosition,
      defaultColor,
      defaultFontSize,
      defaultFontFamily,
      onTextAdd,
      onTextEditEnd,
    ]
  );

  const applyToSelectedText = useCallback(
    (props: Partial<fabric.IText>) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const activeObject = canvas.getActiveObject();
      if (!activeObject || activeObject.type !== "i-text") return;

      activeObject.set(props);
      canvas.renderAll();
      canvas.fire("object:modified", { target: activeObject });
    },
    [canvasRef]
  );

  const setFontSize = useCallback(
    (size: number) => applyToSelectedText({ fontSize: size }),
    [applyToSelectedText]
  );

  const setFontFamily = useCallback(
    (family: string) => applyToSelectedText({ fontFamily: family }),
    [applyToSelectedText]
  );

  const setTextColor = useCallback(
    (color: string) => applyToSelectedText({ fill: color }),
    [applyToSelectedText]
  );

  const setFontWeight = useCallback(
    (weight: "normal" | "bold") => applyToSelectedText({ fontWeight: weight }),
    [applyToSelectedText]
  );

  const setFontStyle = useCallback(
    (style: "normal" | "italic") => applyToSelectedText({ fontStyle: style }),
    [applyToSelectedText]
  );

  const setUnderline = useCallback(
    (underline: boolean) => applyToSelectedText({ underline }),
    [applyToSelectedText]
  );

  const setHighlightColor = useCallback(
    (color: string | null) => applyToSelectedText({ textBackgroundColor: color || "" }),
    [applyToSelectedText]
  );

  const setTextAlign = useCallback(
    (align: "left" | "center" | "right" | "justify") => applyToSelectedText({ textAlign: align }),
    [applyToSelectedText]
  );

  const setLineHeight = useCallback(
    (lineHeight: number) => applyToSelectedText({ lineHeight }),
    [applyToSelectedText]
  );

  const applyStylePreset = useCallback(
    (preset: TextStylePreset) => applyToSelectedText(TEXT_STYLE_PRESETS[preset]),
    [applyToSelectedText]
  );

  const clearFormatting = useCallback(
    () =>
      applyToSelectedText({
        fontFamily: defaultFontFamily,
        fontSize: defaultFontSize,
        fontWeight: "normal",
        fontStyle: "normal",
        underline: false,
        textAlign: "left",
        lineHeight: 1.16,
        fill: defaultColor,
        textBackgroundColor: "",
      }),
    [applyToSelectedText, defaultFontFamily, defaultFontSize, defaultColor]
  );

  return {
    addText,
    setFontSize,
    setFontFamily,
    setTextColor,
    setFontWeight,
    setFontStyle,
    setUnderline,
    setHighlightColor,
    setTextAlign,
    setLineHeight,
    applyStylePreset,
    clearFormatting,
    fontFamilies: DEFAULT_FONT_FAMILIES,
  };
}

export default useText;
