import { useEffect, useCallback, useMemo } from "react";
import type { fabric } from "fabric";

import { Button } from "../UI";
import { useImageEditor } from "../../core";

import { CanvasEditor } from "./CanvasEditor";
import { Toolbar } from "./Toolbar";
import type { TextFormattingProps } from "./Toolbar";

import { injectStyles } from "./styles";

export interface IImageEditorProps {
  imageUrl: string;
  initialCanvasJson?: string;
  onSave: (imageBlob: Blob | null, canvasJson: string | null) => void;
  onCancel: () => void;
  onChangeImage?: () => void;
  showCancelButton?: boolean;
  className?: string;
  headerClassName?: string;
  toolbarClassName?: string;
  buttonClassName?: string;
  saveButtonClassName?: string;
  cancelButtonClassName?: string;
  canvasClassName?: string;
  canvasWrapperClassName?: string;
  zoomButtonClassName?: string;
  background?: string;
  saveButtonTitle?: string;
  cancelButtonTitle?: string;
}

const ImageEditor = (props: IImageEditorProps) => {
  const {
    imageUrl,
    initialCanvasJson,
    onSave,
    onCancel,
    onChangeImage,
    showCancelButton = false,
    className = "",
    headerClassName = "",
    toolbarClassName = "",
    buttonClassName = "",
    saveButtonClassName = "",
    cancelButtonClassName = "",
    canvasClassName = "",
    canvasWrapperClassName = "",
    zoomButtonClassName = "",
    background,
    saveButtonTitle = "Save",
    cancelButtonTitle = "Cancel",
  } = props;

  const editor = useImageEditor({
    imageUrl,
    initialCanvasJson,
    defaultColor: "#ff7000",
    defaultStrokeWidth: 2,
    maxHistorySize: 50,
  });

  useEffect(() => {
    injectStyles();
  }, []);

  const handleSave = useCallback(async () => {
    const blob = await editor.exportToBlob();
    onSave(blob, blob ? editor.exportCanvasJSON() : null);
  }, [editor, onSave]);

  const handleCancel = useCallback(() => {
    onCancel();
  }, [onCancel]);

  const handleColorChange = useCallback(
    (color: string) => {
      editor.style.setColor(color);
    },
    [editor.style]
  );

  const handleStrokeWidthChange = useCallback(
    (width: number) => {
      editor.style.setStrokeWidth(width);
    },
    [editor.style]
  );

  const handleAddShape = useCallback(
    (shapeType: "rectangle" | "circle") => {
      if (editor.crop.isActive || editor.drawing.isActive) return;
      editor.shapes.add(shapeType);
      editor.selection.enable();
    },
    [editor.crop.isActive, editor.drawing.isActive, editor.shapes, editor.selection]
  );

  const handleAddBlur = useCallback(() => {
    if (editor.drawing.isActive) return;
    editor.blur.add();
    editor.selection.disable();
  }, [editor.drawing.isActive, editor.blur, editor.selection]);

  const handleCropStart = useCallback(() => {
    if (editor.drawing.isActive || editor.eraser.isActive) return;
    editor.blur.clearAll();
    editor.crop.start();
  }, [editor.drawing.isActive, editor.eraser.isActive, editor.blur, editor.crop]);

  const handleToggleDraw = useCallback(() => {
    if (editor.crop.isActive) return;
    if (editor.eraser.isActive) editor.eraser.disable();
    editor.drawing.toggle();
    if (!editor.drawing.isActive) {
      editor.selection.disable();
    }
  }, [editor.crop.isActive, editor.eraser, editor.drawing, editor.selection]);

  const handleAddText = useCallback(() => {
    if (editor.crop.isActive || editor.drawing.isActive || editor.eraser.isActive) return;
    editor.text.add();
    editor.selection.enable();
  }, [editor.crop.isActive, editor.drawing.isActive, editor.eraser, editor.text, editor.selection]);

  const handleToggleEraser = useCallback(() => {
    if (editor.crop.isActive) return;
    if (editor.drawing.isActive) editor.drawing.disable();
    editor.eraser.toggle();
    if (!editor.eraser.isActive) {
      editor.selection.disable();
    }
  }, [editor.crop.isActive, editor.drawing, editor.eraser, editor.selection]);

  const handleToggleSelectMode = useCallback(() => {
    if (editor.drawing.isActive) {
      editor.drawing.disable();
    }
    editor.selection.toggle();
  }, [editor.drawing, editor.selection]);

  const handleDeleteObject = useCallback(() => {
    editor.selection.deleteSelected();
    editor.history.save();
  }, [editor.selection, editor.history]);

  const textFormatting: TextFormattingProps | null = useMemo(() => {
    const selected = editor.selection.selected;
    if (!selected || selected.type !== "i-text") return null;

    const textObj = selected as fabric.IText;

    return {
      fontFamilies: editor.text.fontFamilies,
      fontFamily: (textObj.fontFamily as string) || "Arial",
      fontSize: (textObj.fontSize as number) || 24,
      fontWeight: (textObj.fontWeight as "normal" | "bold") || "normal",
      fontStyle: (textObj.fontStyle as "normal" | "italic") || "normal",
      underline: !!textObj.underline,
      textAlign: (textObj.textAlign as TextFormattingProps["textAlign"]) || "left",
      lineHeight: (textObj.lineHeight as number) ?? 1.16,
      highlightColor: (textObj.textBackgroundColor as string) || null,
      onFontFamilyChange: editor.text.setFontFamily,
      onFontSizeChange: editor.text.setFontSize,
      onToggleBold: () => editor.text.setFontWeight(textObj.fontWeight === "bold" ? "normal" : "bold"),
      onToggleItalic: () => editor.text.setFontStyle(textObj.fontStyle === "italic" ? "normal" : "italic"),
      onToggleUnderline: () => editor.text.setUnderline(!textObj.underline),
      onTextAlignChange: editor.text.setTextAlign,
      onLineHeightChange: editor.text.setLineHeight,
      onHighlightColorChange: editor.text.setHighlightColor,
      onStylePreset: editor.text.applyStylePreset,
      onClearFormatting: editor.text.clearFormatting,
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    editor.selection.selected,
    editor.text,
    (editor.selection.selected as fabric.IText | null)?.fontFamily,
    (editor.selection.selected as fabric.IText | null)?.fontSize,
    (editor.selection.selected as fabric.IText | null)?.fontWeight,
    (editor.selection.selected as fabric.IText | null)?.fontStyle,
    (editor.selection.selected as fabric.IText | null)?.underline,
    (editor.selection.selected as fabric.IText | null)?.textAlign,
    (editor.selection.selected as fabric.IText | null)?.lineHeight,
    (editor.selection.selected as fabric.IText | null)?.textBackgroundColor,
  ]);

  return (
    <div className={`image-editor-container animate-fade-in ${className}`}>
      <div className={`image-editor-header ${headerClassName}`}>
        <Toolbar
          onAddShape={handleAddShape}
          onCropStart={handleCropStart}
          onAddBlur={handleAddBlur}
          onToggleDraw={handleToggleDraw}
          onToggleSelectMode={handleToggleSelectMode}
          onAddText={handleAddText}
          onToggleEraser={handleToggleEraser}
          isErasing={editor.eraser.isActive}
          hasImage={editor.hasImage}
          isCropping={editor.crop.isActive}
          isDrawing={editor.drawing.isActive}
          isSelectMode={editor.selection.isActive}
          selectedObject={editor.selection.selected}
          currentColor={editor.style.color}
          currentStrokeWidth={editor.style.strokeWidth}
          onColorChange={handleColorChange}
          onStrokeWidthChange={handleStrokeWidthChange}
          textFormatting={textFormatting}
          onUndo={editor.history.undo}
          onRedo={editor.history.redo}
          canUndo={editor.history.canUndo}
          canRedo={editor.history.canRedo}
          onDeleteObject={handleDeleteObject}
          showCancelButton={showCancelButton}
          onCancel={handleCancel}
          className={toolbarClassName}
          buttonClassName={buttonClassName}
          saveButtonClassName={saveButtonClassName}
          cancelButtonClassName={cancelButtonClassName}
          saveButtonTitle={saveButtonTitle}
          cancelButtonTitle={cancelButtonTitle}
        />

        <div className="image-editor-actions">
          {onChangeImage && (
            <Button
              onPress={onChangeImage}
              disabled={!editor.hasImage}
              color="secondary"
              className={`image-editor-button image-editor-button-secondary hover-lift ${cancelButtonClassName}`}
            >
              Change Image
            </Button>
          )}
          {showCancelButton && (
            <Button
              onPress={handleCancel}
              disabled={!editor.hasImage}
              color="secondary"
              className={`image-editor-button image-editor-button-secondary hover-lift ${cancelButtonClassName}`}
            >
              {cancelButtonTitle}
            </Button>
          )}
          <Button
            onPress={handleSave}
            disabled={!editor.hasImage}
            color="primary"
            className={`image-editor-button image-editor-button-primary hover-lift ${saveButtonClassName}`}
          >
            {saveButtonTitle}
          </Button>
        </div>
      </div>

      {editor.crop.isActive && (
        <div className="crop-mode animate-fade-in">
          <span className="crop-mode-text">Crop Mode: Drag and resize the selection area</span>
          <div className="crop-mode-actions">
            <button
              onClick={() => editor.crop.apply()}
              className="crop-button crop-button-apply hover-lift"
            >
              Apply Crop
            </button>
            <button
              onClick={() => editor.crop.cancel()}
              className="crop-button crop-button-cancel hover-lift"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      <CanvasEditor
        canvas={editor.canvas}
        canvasRef={editor.canvasRef}
        className={canvasClassName}
        canvasWrapperClassName={canvasWrapperClassName}
        zoomButtonClassName={zoomButtonClassName}
        background={background}
      />
    </div>
  );
};

export default ImageEditor;
