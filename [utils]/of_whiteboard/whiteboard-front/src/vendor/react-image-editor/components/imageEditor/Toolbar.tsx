import React from "react";

import { Icon, Popover, Slider } from "../UI";
import type { IconNamesType } from "../../constants/icons";
import type { TextStylePreset } from "../../core/hooks/useText";

export interface TextFormattingProps {
  fontFamilies: string[];
  fontFamily: string;
  fontSize: number;
  fontWeight: "normal" | "bold";
  fontStyle: "normal" | "italic";
  underline: boolean;
  textAlign: "left" | "center" | "right" | "justify";
  lineHeight: number;
  highlightColor: string | null;
  onFontFamilyChange: (family: string) => void;
  onFontSizeChange: (size: number) => void;
  onToggleBold: () => void;
  onToggleItalic: () => void;
  onToggleUnderline: () => void;
  onTextAlignChange: (align: "left" | "center" | "right" | "justify") => void;
  onLineHeightChange: (lineHeight: number) => void;
  onHighlightColorChange: (color: string | null) => void;
  onStylePreset: (preset: TextStylePreset) => void;
  onClearFormatting: () => void;
}

export const PREDEFINED_COLORS = [
  "#ff7000",
  "#D64045",
  "#2D3748",
  "#E53E3E",
  "#38A169",
  "#3182CE",
  "#D69E2E",
  "#805AD5",
  "#DD6B20",
  "#319795",
  "#F56565",
  "#48BB78",
  "#4299E1",
  "#ECC94B",
  "#9F7AEA",
  "#ED8936",
] as const;

interface ToolbarButtonProps {
  iconName: IconNamesType;
  onClick: () => void;
  title: string;
  isActive?: boolean;
  disabled?: boolean;
  className?: string;
}

const ToolbarButton: React.FC<ToolbarButtonProps> = ({
  iconName,
  onClick,
  title,
  isActive = false,
  disabled = false,
  className = "",
}) => {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`toolbar-button ${isActive ? "active" : ""} ${disabled ? "disabled" : ""} ${className}`}
      title={title}
    >
      <Icon name={iconName} width={20} height={20} className="text-white" />
    </button>
  );
};

interface ColorPaletteProps {
  currentColor: string;
  onColorChange: (color: string) => void;
}

const ColorPalette: React.FC<ColorPaletteProps> = ({ currentColor, onColorChange }) => {
  return (
    <div className="color-palette">
      <div className="color-palette-grid">
        {PREDEFINED_COLORS.map((color) => (
          <button
            key={color}
            onClick={() => onColorChange(color)}
            className={`color-button ${currentColor === color ? "active" : ""}`}
            style={{ backgroundColor: color }}
            title={color}
          />
        ))}
      </div>
    </div>
  );
};

interface WidthSliderProps {
  currentWidth: number;
  onWidthChange: (width: number) => void;
}

const WidthSlider: React.FC<WidthSliderProps> = ({ currentWidth, onWidthChange }) => {
  return (
    <div className="width-slider">
      <div className="width-slider-content">
        <label className="width-slider-label">Stroke Width:</label>
        <Slider
          size="sm"
          step={1}
          min={1}
          max={20}
          value={currentWidth}
          onChange={onWidthChange}
          className="width-slider-input"
        />
        <span className="width-slider-value">{currentWidth}px</span>
      </div>
    </div>
  );
};

const HighlightPalette: React.FC<{
  currentColor: string | null;
  onColorChange: (color: string | null) => void;
}> = ({ currentColor, onColorChange }) => {
  return (
    <div className="color-palette">
      <div className="color-palette-grid">
        <button
          onClick={() => onColorChange(null)}
          className={`color-button ${currentColor === null ? "active" : ""}`}
          style={{
            backgroundImage:
              "linear-gradient(45deg, transparent 45%, #E53E3E 45%, #E53E3E 55%, transparent 55%)",
            backgroundColor: "#2D3748",
          }}
          title="None"
        />
        {PREDEFINED_COLORS.map((color) => (
          <button
            key={color}
            onClick={() => onColorChange(color)}
            className={`color-button ${currentColor === color ? "active" : ""}`}
            style={{ backgroundColor: color }}
            title={color}
          />
        ))}
      </div>
    </div>
  );
};

const selectStyle: React.CSSProperties = {
  background: "#1f2937",
  color: "#e5e7eb",
  border: "1px solid rgba(255,255,255,0.1)",
  borderRadius: 6,
  padding: "4px 6px",
  fontSize: 12,
  maxWidth: 130,
};

const STYLE_PRESET_OPTIONS: { value: TextStylePreset; label: string }[] = [
  { value: "normal", label: "Normal text" },
  { value: "heading1", label: "Heading 1" },
  { value: "heading2", label: "Heading 2" },
  { value: "heading3", label: "Heading 3" },
];

const TextFormattingBar: React.FC<{ text: TextFormattingProps; buttonClassName?: string }> = ({
  text,
  buttonClassName = "",
}) => {
  return (
    <div className="toolbar text-formatting-bar">
      <select
        style={selectStyle}
        value=""
        onChange={(e) => text.onStylePreset(e.target.value as TextStylePreset)}
        title="Style"
      >
        <option value="" disabled>
          Style
        </option>
        {STYLE_PRESET_OPTIONS.map((opt) => (
          <option key={opt.value} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>

      <select
        style={selectStyle}
        value={text.fontFamily}
        onChange={(e) => text.onFontFamilyChange(e.target.value)}
        title="Font"
      >
        {text.fontFamilies.map((family) => (
          <option key={family} value={family} style={{ fontFamily: family }}>
            {family}
          </option>
        ))}
      </select>

      <Popover
        trigger={
          <div className={`toolbar-button ${buttonClassName}`} title="Font size">
            <span style={{ color: "white", fontSize: 12, minWidth: 20, display: "inline-block", textAlign: "center" }}>
              {text.fontSize}
            </span>
          </div>
        }
        content={
          <div className="width-slider">
            <div className="width-slider-content">
              <label className="width-slider-label">Font Size:</label>
              <Slider
                size="sm"
                step={1}
                min={8}
                max={160}
                value={text.fontSize}
                onChange={text.onFontSizeChange}
                className="width-slider-input"
              />
              <span className="width-slider-value">{text.fontSize}px</span>
            </div>
          </div>
        }
        contentClassName="glass-effect-strong"
        placement="bottom"
      />

      <div className="toolbar-divider" />

      <ToolbarButton
        iconName="bold"
        onClick={text.onToggleBold}
        title="Bold"
        isActive={text.fontWeight === "bold"}
        className={buttonClassName}
      />
      <ToolbarButton
        iconName="italic"
        onClick={text.onToggleItalic}
        title="Italic"
        isActive={text.fontStyle === "italic"}
        className={buttonClassName}
      />
      <ToolbarButton
        iconName="underline"
        onClick={text.onToggleUnderline}
        title="Underline"
        isActive={text.underline}
        className={buttonClassName}
      />

      <div className="toolbar-divider" />

      <ToolbarButton
        iconName="align-left"
        onClick={() => text.onTextAlignChange("left")}
        title="Align left"
        isActive={text.textAlign === "left"}
        className={buttonClassName}
      />
      <ToolbarButton
        iconName="align-center"
        onClick={() => text.onTextAlignChange("center")}
        title="Align center"
        isActive={text.textAlign === "center"}
        className={buttonClassName}
      />
      <ToolbarButton
        iconName="align-right"
        onClick={() => text.onTextAlignChange("right")}
        title="Align right"
        isActive={text.textAlign === "right"}
        className={buttonClassName}
      />

      <div className="toolbar-divider" />

      <Popover
        trigger={
          <div className={`toolbar-button ${buttonClassName}`} title="Highlight color">
            <Icon name="highlighter" width={20} height={20} className="text-white" />
          </div>
        }
        content={<HighlightPalette currentColor={text.highlightColor} onColorChange={text.onHighlightColorChange} />}
        contentClassName="glass-effect-strong"
        placement="bottom"
      />

      <Popover
        trigger={
          <div className={`toolbar-button ${buttonClassName}`} title="Line & paragraph spacing">
            <span style={{ color: "white", fontSize: 11 }}>{text.lineHeight.toFixed(1)}x</span>
          </div>
        }
        content={
          <div className="width-slider">
            <div className="width-slider-content">
              <label className="width-slider-label">Line Spacing:</label>
              <Slider
                size="sm"
                step={0.1}
                min={0.8}
                max={3}
                value={text.lineHeight}
                onChange={text.onLineHeightChange}
                className="width-slider-input"
              />
              <span className="width-slider-value">{text.lineHeight.toFixed(1)}x</span>
            </div>
          </div>
        }
        contentClassName="glass-effect-strong"
        placement="bottom"
      />

      <div className="toolbar-divider" />

      <ToolbarButton
        iconName="clear-format"
        onClick={text.onClearFormatting}
        title="Clear formatting"
        className={buttonClassName}
      />
    </div>
  );
};

interface ToolbarProps {
  onAddShape: (shapeType: "rectangle" | "circle") => void;
  onCropStart: () => void;
  onAddBlur: () => void;
  onToggleDraw: () => void;
  onToggleSelectMode: () => void;
  onAddText: () => void;
  onToggleEraser: () => void;
  isErasing: boolean;
  hasImage: boolean;
  isCropping: boolean;
  isDrawing: boolean;
  isSelectMode: boolean;
  activeShape?: "rectangle" | "circle" | null;
  isBlurActive?: boolean;
  selectedObject?: fabric.Object | null;
  currentColor?: string;
  currentStrokeWidth?: number;
  onColorChange?: (color: string) => void;
  onStrokeWidthChange?: (width: number) => void;
  textFormatting?: TextFormattingProps | null;
  onUndo?: () => void;
  onRedo?: () => void;
  canUndo?: boolean;
  canRedo?: boolean;
  onDeleteObject?: () => void;
  showCancelButton?: boolean;
  onCancel?: () => void;
  className?: string;
  buttonClassName?: string;
  saveButtonClassName?: string;
  cancelButtonClassName?: string;
  saveButtonTitle?: string;
  cancelButtonTitle?: string;
}

export const Toolbar: React.FC<ToolbarProps> = ({
  onAddShape,
  onCropStart,
  onAddBlur,
  onToggleDraw,
  onToggleSelectMode,
  onAddText,
  onToggleEraser,
  isErasing,
  hasImage,
  isCropping,
  isDrawing,
  isSelectMode,
  activeShape,
  isBlurActive = false,
  selectedObject,
  currentColor = "#D64045",
  currentStrokeWidth = 2,
  onColorChange,
  onStrokeWidthChange,
  textFormatting,
  onUndo,
  onRedo,
  canUndo = false,
  canRedo = false,
  onDeleteObject,
  className = "",
  buttonClassName = "",
}) => {
  return (
    <div className={`toolbar-stack`}>
    <div className={`toolbar ${className}`}>
      {hasImage && (
        <>
          <ToolbarButton
            iconName="cursor"
            onClick={onToggleSelectMode}
            title="Select"
            isActive={isSelectMode}
            disabled={false}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="pencil"
            onClick={onToggleDraw}
            title="Draw"
            isActive={isDrawing}
            disabled={isCropping}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="crop"
            onClick={onCropStart}
            title="Crop"
            disabled={isCropping || isDrawing}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="blur"
            onClick={onAddBlur}
            title="Blur"
            isActive={isBlurActive}
            disabled={isCropping || isDrawing}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="square"
            onClick={() => onAddShape("rectangle")}
            title="Rectangle"
            isActive={activeShape === "rectangle"}
            disabled={isCropping || isDrawing}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="circle"
            onClick={() => onAddShape("circle")}
            title="Circle"
            isActive={activeShape === "circle"}
            disabled={isCropping || isDrawing}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="text"
            onClick={onAddText}
            title="Text"
            disabled={isCropping || isDrawing || isErasing}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="eraser"
            onClick={onToggleEraser}
            title="Eraser"
            isActive={isErasing}
            disabled={isCropping}
            className={buttonClassName}
          />

          <div className="toolbar-divider" />

          <Popover
            trigger={
              <div className={`toolbar-button ${selectedObject || isDrawing ? "" : "disabled"} ${buttonClassName}`}>
                <div className="w-6 h-6 rounded border-2 border-gray-700" style={{ backgroundColor: currentColor }} />
              </div>
            }
            content={<ColorPalette currentColor={currentColor} onColorChange={onColorChange || (() => {})} />}
            contentClassName="glass-effect-strong"
            placement="bottom"
          />

          <Popover
            trigger={
              <div className={`toolbar-button ${selectedObject || isDrawing ? "" : "disabled"} ${buttonClassName}`}>
                <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                  <div
                    style={{
                      width: 18,
                      height: 2,
                      background: "#9ca3af",
                      borderRadius: 9999,
                      position: "relative",
                    }}
                  >
                    <div
                      style={{
                        position: "absolute",
                        left: 0,
                        top: "50%",
                        transform: "translate(0,-50%)",
                        width: Math.max(2, Math.min(12, currentStrokeWidth)) + 2,
                        height: Math.max(2, Math.min(12, currentStrokeWidth)),
                        borderRadius: 9999,
                        background: "linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%)",
                        boxShadow: "0 0 0 1px rgba(0,0,0,0.4)",
                      }}
                    />
                  </div>
                </div>
              </div>
            }
            content={
              <WidthSlider currentWidth={currentStrokeWidth} onWidthChange={onStrokeWidthChange || (() => {})} />
            }
            placement="bottom"
            contentClassName="glass-effect-strong"
          />

          <div className="toolbar-divider" />

          <ToolbarButton
            iconName="undo"
            onClick={onUndo || (() => {})}
            title="Undo (Ctrl+Z)"
            disabled={!canUndo}
            className={buttonClassName}
          />
          <ToolbarButton
            iconName="redo"
            onClick={onRedo || (() => {})}
            title="Redo (Ctrl+Y)"
            disabled={!canRedo}
            className={buttonClassName}
          />

          {selectedObject && (
            <>
              <div className="toolbar-divider" />
              <ToolbarButton
                iconName="trash"
                onClick={onDeleteObject || (() => {})}
                title="Delete (Backspace)"
                disabled={false}
                className={`delete-button ${buttonClassName}`}
              />
            </>
          )}
        </>
      )}
    </div>
    {hasImage && textFormatting && <TextFormattingBar text={textFormatting} buttonClassName={buttonClassName} />}
    </div>
  );
};
