import { useState, useEffect } from "react";
import { fetchNui } from "@/providers/nui/fetchNui";
import { useNuiEvent } from "../../providers/nui/useNui";
import { useLocale } from "../../providers/locale/Locale";

type LightType = "ambient" | "spotlight" | "barlight";
type FlashSetting = "off" | "low" | "high";
type SpeedSetting = "slow" | "normal" | "fast";

interface LightControlState {
    enabled: boolean;
    rotateHorizontal: boolean;
    rotateVertical: boolean;
    flash: FlashSetting;
    speed: SpeedSetting;
    primaryColor: [number, number, number]; // RGB
    secondaryColor: [number, number, number]; // RGB
}

interface LightControlsProps {
    lightType: LightType;
    label: string;
    stationId: number | null;
    initialState?: LightControlState;
}

// Helper to convert flash number to string
// Values match GetFlashString in shared.lua: 0 = off, 10 = low, 2 = high
function flashNumberToString(flash: number): FlashSetting {
    if (flash === 0) return "off";
    if (flash === 10) return "low";
    if (flash === 2) return "high";
    return "off"; // default
}

export default function LightControls({ lightType, label, stationId, initialState }: LightControlsProps) {
    const locale = useLocale();
    const defaultState: LightControlState = {
        enabled: true,
        rotateHorizontal: true,
        rotateVertical: false,
        flash: "low",
        speed: "normal",
        primaryColor: [0, 0, 0],
        secondaryColor: [0, 0, 0],
    };
    
    const [state, setState] = useState<LightControlState>(
        initialState ? {
            ...defaultState,
            ...initialState,
            primaryColor: initialState.primaryColor || defaultState.primaryColor,
            secondaryColor: initialState.secondaryColor || defaultState.secondaryColor,
        } : defaultState
    );
    
    const [isColorDialogOpen, setIsColorDialogOpen] = useState(false);
    const [pendingColors, setPendingColors] = useState<{
        primaryColor?: [number, number, number];
        secondaryColor?: [number, number, number];
    }>({});
    const [dialogInitialColors, setDialogInitialColors] = useState<{
        primaryColor: [number, number, number];
        secondaryColor: [number, number, number];
    } | null>(null);

    // Listen for initial state from server
    useNuiEvent("music:lightControlsState", (event: any) => {
        // Event structure: { type: 'music:lightControlsState', data: { stationId, controls } }
        // useNuiEvent passes event.data directly, so event is already { type, data }
        console.log(`[LightControls] Raw event received for ${lightType}:`, event);
        const data = event.data || event;
        console.log(`[LightControls] Processed data for ${lightType}:`, data);
        console.log(`[LightControls] Received lightControlsState event for ${lightType}:`, { 
            stationId, 
            dataStationId: data.stationId, 
            hasControls: !!data.controls,
            hasLights: !!(data.controls && data.controls.lights),
            hasLightType: !!(data.controls && data.controls.lights && data.controls.lights[lightType]),
            fullEvent: event
        });
        
        // Only process if we have valid data
        if (!data.stationId) {
            console.warn(`[LightControls] No stationId in event data for ${lightType}, ignoring event`);
            return;
        }
        
        // If stationId prop is set, it must match. Otherwise, accept any stationId (for timing issues)
        if (stationId !== null && stationId !== undefined && data.stationId !== stationId) {
            console.warn(`[LightControls] StationId mismatch for ${lightType}: prop=${stationId}, event=${data.stationId}`);
            return;
        }
        if (!data.controls || !data.controls.lights || !data.controls.lights[lightType]) {
            console.warn(`[LightControls] Missing controls for ${lightType}:`, data);
            return;
        }
        
        const lightControl = data.controls.lights[lightType];
        if (lightControl) {
            console.log(`[LightControls] Received controls for ${lightType}:`, lightControl);
            console.log(`[LightControls] primaryColor:`, lightControl.primaryColor, `type:`, typeof lightControl.primaryColor, `isArray:`, Array.isArray(lightControl.primaryColor));
            console.log(`[LightControls] secondaryColor:`, lightControl.secondaryColor, `type:`, typeof lightControl.secondaryColor, `isArray:`, Array.isArray(lightControl.secondaryColor));
            
            // Flash value is already converted to string by client, use directly or convert if number
            let flashValue: FlashSetting = "off";
            if (typeof lightControl.flash === "string") {
                flashValue = lightControl.flash as FlashSetting;
            } else if (typeof lightControl.flash === "number") {
                flashValue = flashNumberToString(lightControl.flash);
            }
            
            // Ensure boolean values are properly handled (defensive checks)
            const enabled = lightControl.enabled === true || (lightControl.enabled !== false && lightControl.enabled !== 0 && lightControl.enabled !== "false");
            const rotateHorizontal = lightControl.rotateHorizontal === true || lightControl.rotateHorizontal === 1 || lightControl.rotateHorizontal === "true";
            const rotateVertical = lightControl.rotateVertical === true || lightControl.rotateVertical === 1 || lightControl.rotateVertical === "true";
            
            // Speed value is already converted to string by client
            const speedValue = (lightControl.speed === "slow" || lightControl.speed === "normal" || lightControl.speed === "fast") 
                ? lightControl.speed as SpeedSetting 
                : "normal";
            
            // Handle colors (defaults if not present)
            let primaryColor: [number, number, number] = [255, 0, 0];
            let secondaryColor: [number, number, number] = [255, 100, 0];
            
            if (lightControl.primaryColor) {
                if (Array.isArray(lightControl.primaryColor) && lightControl.primaryColor.length === 3) {
                    primaryColor = [lightControl.primaryColor[0], lightControl.primaryColor[1], lightControl.primaryColor[2]];
                } else {
                    console.warn(`[LightControls] Invalid primaryColor format for ${lightType}:`, lightControl.primaryColor);
                }
            } else {
                console.warn(`[LightControls] primaryColor missing for ${lightType}, using default`);
            }
            
            if (lightControl.secondaryColor) {
                if (Array.isArray(lightControl.secondaryColor) && lightControl.secondaryColor.length === 3) {
                    secondaryColor = [lightControl.secondaryColor[0], lightControl.secondaryColor[1], lightControl.secondaryColor[2]];
                } else {
                    console.warn(`[LightControls] Invalid secondaryColor format for ${lightType}:`, lightControl.secondaryColor);
                }
            } else {
                console.warn(`[LightControls] secondaryColor missing for ${lightType}, using default`);
            }
            
            console.log(`[LightControls] Final colors for ${lightType} - primary:`, primaryColor, `secondary:`, secondaryColor);
            
            setState({
                enabled: enabled,
                rotateHorizontal: rotateHorizontal,
                rotateVertical: rotateVertical,
                flash: flashValue,
                speed: speedValue,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
            });
        }
    });

    // Listen for networked updates
    useNuiEvent("music:lightControlsUpdated", (event: any) => {
        const data = event.data || event;
        if (data.stationId === stationId && data.lightType === lightType) {
            if (data.property === "enabled") {
                // Handle boolean values defensively
                const enabled = data.value === true || data.value === 1 || data.value === "true";
                setState(prev => ({ ...prev, enabled: enabled }));
            } else if (data.property === "rotateHorizontal" || data.property === "rotateVertical") {
                // Handle boolean values defensively
                const boolValue = data.value === true || data.value === 1 || data.value === "true";
                setState(prev => ({ ...prev, [data.property]: boolValue }));
            } else if (data.property === "flash") {
                setState(prev => ({ ...prev, flash: data.value as FlashSetting }));
            } else if (data.property === "speed") {
                if (data.value === "slow" || data.value === "normal" || data.value === "fast") {
                    setState(prev => ({ ...prev, speed: data.value as SpeedSetting }));
                }
            } else if (data.property === "primaryColor" || data.property === "secondaryColor") {
                if (Array.isArray(data.value) && data.value.length === 3) {
                    setState(prev => ({ ...prev, [data.property]: [data.value[0], data.value[1], data.value[2]] }));
                }
            }
        }
    });

    const updateControl = async (property: keyof LightControlState, value: boolean | FlashSetting | SpeedSetting | [number, number, number]) => {
        if (!stationId) return;
        
        // Optimistically update local state immediately for instant UI feedback.
        // The server broadcast (music:lightControlsUpdated) will reconcile if needed.
        // Updating first means no awaited fetch is in-flight when the player closes
        // the UI, preventing a race between pending POSTs and SetNuiFocus(false,false).
        setState(prev => ({ ...prev, [property]: value }));

        fetchNui("updateLightControls", {
            stationId,
            lightType,
            property,
            value,
        }).catch(() => {});
    };

    const updateColor = (colorType: "primaryColor" | "secondaryColor", color: [number, number, number]) => {
        // Optimistically update UI for immediate feedback
        setState(prev => ({ ...prev, [colorType]: color }));
        // Store pending change (will be sent when dialog closes)
        setPendingColors(prev => ({ ...prev, [colorType]: color }));
    };

    const handleDialogClose = async () => {
        // Send only colors that actually changed
        if (dialogInitialColors) {
            // Check primary color
            const currentPrimary = pendingColors.primaryColor || state.primaryColor;
            const primaryChanged = currentPrimary[0] !== dialogInitialColors.primaryColor[0] ||
                                  currentPrimary[1] !== dialogInitialColors.primaryColor[1] ||
                                  currentPrimary[2] !== dialogInitialColors.primaryColor[2];
            if (primaryChanged) {
                await updateControl("primaryColor", currentPrimary);
            }
            
            // Check secondary color
            const currentSecondary = pendingColors.secondaryColor || state.secondaryColor;
            const secondaryChanged = currentSecondary[0] !== dialogInitialColors.secondaryColor[0] ||
                                    currentSecondary[1] !== dialogInitialColors.secondaryColor[1] ||
                                    currentSecondary[2] !== dialogInitialColors.secondaryColor[2];
            if (secondaryChanged) {
                await updateControl("secondaryColor", currentSecondary);
            }
        }
        // Clear pending colors and initial colors, then close dialog
        setPendingColors({});
        setDialogInitialColors(null);
        setIsColorDialogOpen(false);
    };

    const rgbToHex = (r: number, g: number, b: number): string => {
        return "#" + [r, g, b].map(x => {
            const hex = Math.round(x).toString(16);
            return hex.length === 1 ? "0" + hex : hex;
        }).join("");
    };

    const hexToRgb = (hex: string): [number, number, number] | null => {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? [
            parseInt(result[1], 16),
            parseInt(result[2], 16),
            parseInt(result[3], 16)
        ] : null;
    };

    const cycleFlash = () => {
        const nextFlash: FlashSetting = 
            state.flash === "off" ? "low" :
            state.flash === "low" ? "high" : "off";
        updateControl("flash", nextFlash);
    };

    const cycleSpeed = () => {
        const nextSpeed: SpeedSetting = 
            state.speed === "slow" ? "normal" :
            state.speed === "normal" ? "fast" : "slow";
        updateControl("speed", nextSpeed);
    };

    return (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "center" }}>
            <div style={{ fontSize: 12, fontWeight: 500, color: "#ddd", marginBottom: 4 }}>
                {label}
            </div>
            
            {/* Enable/Disable Toggle */}
            <button
                onClick={() => updateControl("enabled", !state.enabled)}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${state.enabled ? "#60d394" : "#d64545"}`,
                    borderRadius: 6,
                    background: state.enabled ? "rgba(96, 211, 148, 0.1)" : "rgba(214, 69, 69, 0.1)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                }}
                title={state.enabled ? locale("ui_turn_off_light") : locale("ui_turn_on_light")}
                aria-label={state.enabled ? locale("ui_turn_off_light") : locale("ui_turn_on_light")}
            >
                {state.enabled ? (
                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#60d394"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <circle cx="12" cy="12" r="5" />
                        <path d="M12 1v6M12 17v6M4.22 4.22l4.24 4.24M15.54 15.54l4.24 4.24M1 12h6M17 12h6M4.22 19.78l4.24-4.24M15.54 8.46l4.24-4.24" />
                    </svg>
                ) : (
                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#d64545"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <circle cx="12" cy="12" r="5" />
                        <line x1="12" y1="1" x2="12" y2="3" />
                        <line x1="12" y1="21" x2="12" y2="23" />
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
                        <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
                        <line x1="1" y1="12" x2="3" y2="12" />
                        <line x1="21" y1="12" x2="23" y2="12" />
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" />
                        <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
                    </svg>
                )}
            </button>
            
            {/* Rotate Horizontal Toggle */}
            <button
                onClick={() => updateControl("rotateHorizontal", !state.rotateHorizontal)}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${state.rotateHorizontal ? "#60d394" : "#555"}`,
                    borderRadius: 6,
                    background: state.rotateHorizontal ? "rgba(96, 211, 148, 0.1)" : "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                }}
                title={locale("ui_rotate_horizontal")}
                aria-label={locale("ui_toggle_horizontal_rotation")}
            >
                <svg
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke={state.rotateHorizontal ? "#60d394" : "#888"}
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                >
                    <path d="M21 12H3M18 7l3-3-3-3M6 7L3 4l3-3" />
                </svg>
            </button>

            {/* Rotate Vertical Toggle */}
            <button
                onClick={() => updateControl("rotateVertical", !state.rotateVertical)}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${state.rotateVertical ? "#60d394" : "#555"}`,
                    borderRadius: 6,
                    background: state.rotateVertical ? "rgba(96, 211, 148, 0.1)" : "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                }}
                title={locale("ui_rotate_vertical")}
                aria-label={locale("ui_toggle_vertical_rotation")}
            >
                <svg
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke={state.rotateVertical ? "#60d394" : "#888"}
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                >
                    <path d="M12 21V3M7 18l-5-5 5-5M17 18l5-5-5-5" />
                </svg>
            </button>

            {/* Flash Control (3-state: off, low, high) */}
            <button
                onClick={cycleFlash}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${
                        state.flash === "off" ? "#555" :
                        state.flash === "low" ? "#c8a43b" : "#d64545"
                    }`,
                    borderRadius: 6,
                    background: state.flash === "off" ? "#1e1e1e" :
                        state.flash === "low" ? "rgba(200, 164, 59, 0.1)" : "rgba(214, 69, 69, 0.1)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    flexDirection: "column",
                    gap: 2,
                }}
                title={locale("ui_flash", state.flash)}
                aria-label={locale("ui_flash_setting", state.flash)}
            >
                {state.flash === "off" ? (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#888"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                        <line x1="2" y1="2" x2="22" y2="22" stroke="#888" strokeWidth="2" />
                    </svg>
                ) : state.flash === "low" ? (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#c8a43b"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                    </svg>
                ) : (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#d64545"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                        <circle cx="18" cy="6" r="2" fill="#d64545" opacity="0.6" />
                    </svg>
                )}
                <span style={{ fontSize: 8, color: state.flash === "off" ? "#888" : state.flash === "low" ? "#c8a43b" : "#d64545", textTransform: "uppercase", fontWeight: 600 }}>
                    {state.flash}
                </span>
            </button>

            {/* Speed Control (3-state: slow, normal, fast) */}
            <button
                onClick={cycleSpeed}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${
                        state.speed === "slow" ? "#4a9eff" :
                        state.speed === "normal" ? "#60d394" : "#ff6b6b"
                    }`,
                    borderRadius: 6,
                    background: state.speed === "slow" ? "rgba(74, 158, 255, 0.1)" :
                        state.speed === "normal" ? "rgba(96, 211, 148, 0.1)" : "rgba(255, 107, 107, 0.1)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    flexDirection: "column",
                    gap: 2,
                }}
                title={locale("ui_speed", state.speed)}
                aria-label={locale("ui_light_rotation_speed", state.speed)}
            >
                {state.speed === "slow" ? (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#4a9eff"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <circle cx="12" cy="12" r="10" />
                        <path d="M12 6v6l4 2" />
                    </svg>
                ) : state.speed === "normal" ? (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#60d394"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <circle cx="12" cy="12" r="10" />
                        <path d="M12 6v6l4 2" />
                    </svg>
                ) : (
                    <svg
                        width="20"
                        height="20"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#ff6b6b"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <circle cx="12" cy="12" r="10" />
                        <path d="M12 6v6l4 2" />
                        <path d="M16 12h2" strokeWidth="2.5" />
                    </svg>
                )}
                <span style={{ 
                    fontSize: 8, 
                    color: state.speed === "slow" ? "#4a9eff" : state.speed === "normal" ? "#60d394" : "#ff6b6b", 
                    textTransform: "uppercase", 
                    fontWeight: 600 
                }}>
                    {state.speed}
                </span>
            </button>

            {/* Color Control Button - Shows both primary and secondary colors */}
            <button
                onClick={() => {
                    // Store initial colors and reset pending colors when opening dialog
                    setDialogInitialColors({
                        primaryColor: [...state.primaryColor],
                        secondaryColor: [...state.secondaryColor],
                    });
                    setPendingColors({});
                    setIsColorDialogOpen(true);
                }}
                style={{
                    width: 48,
                    height: 48,
                    border: "2px solid #555",
                    borderRadius: 6,
                    background: "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    padding: 2,
                    position: "relative",
                    overflow: "hidden",
                }}
                title={locale("ui_edit_colors")}
                aria-label={locale("ui_color_controls")}
            >
                {/* Split color display - left half primary, right half secondary */}
                <div style={{
                    width: "100%",
                    height: "100%",
                    display: "flex",
                    borderRadius: 4,
                    overflow: "hidden",
                }}>
                    <div
                        style={{
                            width: "50%",
                            height: "100%",
                            backgroundColor: rgbToHex(state.primaryColor[0], state.primaryColor[1], state.primaryColor[2]),
                            borderRight: "1px solid rgba(255, 255, 255, 0.2)",
                        }}
                    />
                    <div
                        style={{
                            width: "50%",
                            height: "100%",
                            backgroundColor: rgbToHex(state.secondaryColor[0], state.secondaryColor[1], state.secondaryColor[2]),
                        }}
                    />
                </div>
            </button>

            {/* Color Selection Dialog */}
            {isColorDialogOpen && (
                <div className="modalBackdrop" role="dialog" aria-modal="true" aria-labelledby="color-dialog-title" onClick={(e) => {
                    if (e.target === e.currentTarget) {
                        handleDialogClose();
                    }
                }}>
                    <div className="modal" onClick={(e) => e.stopPropagation()}>
                        <div className="modalHeader">
                            <h3 id="color-dialog-title" style={{ margin: 0, fontSize: 16 }}>{locale("ui_edit_label_colors", label)}</h3>
                            <button className="resetBtn" onClick={handleDialogClose} aria-label={locale("ui_close_color_dialog")}>✕</button>
                        </div>
                        <div className="modalBody">
                            <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                                {/* Primary Color */}
                                <div>
                                    <div style={{ marginBottom: 8, opacity: 0.8, fontSize: 14 }}>{locale("ui_primary_color")}</div>
                                    <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                                        <div
                                            style={{
                                                width: 60,
                                                height: 60,
                                                borderRadius: 6,
                                                backgroundColor: rgbToHex(state.primaryColor[0], state.primaryColor[1], state.primaryColor[2]),
                                                border: "2px solid #555",
                                                flexShrink: 0,
                                            }}
                                        />
                                        <input
                                            type="color"
                                            value={rgbToHex(state.primaryColor[0], state.primaryColor[1], state.primaryColor[2])}
                                            onChange={(e) => {
                                                const rgb = hexToRgb(e.target.value);
                                                if (rgb) {
                                                    updateColor("primaryColor", rgb);
                                                }
                                            }}
                                            style={{
                                                width: "100%",
                                                height: 40,
                                                cursor: "pointer",
                                                border: "1px solid #333",
                                                borderRadius: 6,
                                                background: "#0c0c0c",
                                            }}
                                            aria-label={locale("ui_primary_color_picker")}
                                        />
                                    </div>
                                </div>

                                <hr className="divider" />

                                {/* Secondary Color */}
                                <div>
                                    <div style={{ marginBottom: 8, opacity: 0.8, fontSize: 14 }}>{locale("ui_secondary_color")}</div>
                                    <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                                        <div
                                            style={{
                                                width: 60,
                                                height: 60,
                                                borderRadius: 6,
                                                backgroundColor: rgbToHex(state.secondaryColor[0], state.secondaryColor[1], state.secondaryColor[2]),
                                                border: "2px solid #555",
                                                flexShrink: 0,
                                            }}
                                        />
                                        <input
                                            type="color"
                                            value={rgbToHex(state.secondaryColor[0], state.secondaryColor[1], state.secondaryColor[2])}
                                            onChange={(e) => {
                                                const rgb = hexToRgb(e.target.value);
                                                if (rgb) {
                                                    updateColor("secondaryColor", rgb);
                                                }
                                            }}
                                            style={{
                                                width: "100%",
                                                height: 40,
                                                cursor: "pointer",
                                                border: "1px solid #333",
                                                borderRadius: 6,
                                                background: "#0c0c0c",
                                            }}
                                            aria-label={locale("ui_secondary_color_picker")}
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
