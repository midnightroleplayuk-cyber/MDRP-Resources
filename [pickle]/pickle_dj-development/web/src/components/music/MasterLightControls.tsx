import { useState } from "react";
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
}

interface MasterLightControlsProps {
    stationId: number | null;
}

// Helper to convert flash number to string
// Values match GetFlashString in shared.lua: 0 = off, 10 = low, 2 = high
function flashNumberToString(flash: number): FlashSetting {
    if (flash === 0) return "off";
    if (flash === 10) return "low";
    if (flash === 2) return "high";
    return "off"; // default
}

export default function MasterLightControls({ stationId }: MasterLightControlsProps) {
    const locale = useLocale();
    const [state, setState] = useState<LightControlState>({
        enabled: true,
        rotateHorizontal: true,
        rotateVertical: false,
        flash: "low",
        speed: "normal",
    });
    
    const [isInfoDialogOpen, setIsInfoDialogOpen] = useState(false);

    // Listen for initial state from server - use ambient as reference (master sets all to same)
    useNuiEvent("music:lightControlsState", (event: any) => {
        const data = event.data || event;
        // Only process if stationId matches and we have valid data
        if (!stationId || data.stationId !== stationId) return;
        if (!data.controls || !data.controls.lights || !data.controls.lights.ambient) return;
        
        const lightControl = data.controls.lights.ambient;
        if (lightControl) {
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
            
            setState({
                enabled: enabled,
                rotateHorizontal: rotateHorizontal,
                rotateVertical: rotateVertical,
                flash: flashValue,
                speed: speedValue,
            });
        }
    });

    // Listen for networked updates - update master state when any light changes
    useNuiEvent("music:lightControlsUpdated", (event: any) => {
        const data = event.data || event;
        if (data.stationId === stationId) {
            // Update master state based on any light type change
            // Note: This assumes all lights are being updated together (from master control)
            // Individual light updates will also trigger this, but master will reflect the change
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
            }
        }
    });


    const updateAllLights = async (property: keyof LightControlState, value: boolean | FlashSetting | SpeedSetting) => {
        if (!stationId) return;
        
        // Send single update event for all lights
        await fetchNui("updateAllLightControls", {
            stationId,
            property,
            value,
        });
    };

    const cycleFlash = () => {
        const nextFlash: FlashSetting = 
            state.flash === "off" ? "low" :
            state.flash === "low" ? "high" : "off";
        updateAllLights("flash", nextFlash);
    };

    const cycleSpeed = () => {
        const nextSpeed: SpeedSetting = 
            state.speed === "slow" ? "normal" :
            state.speed === "normal" ? "fast" : "slow";
        updateAllLights("speed", nextSpeed);
    };

    return (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "center" }}>
            <div style={{ fontSize: 12, fontWeight: 500, color: "#ddd", marginBottom: 4 }}>
                {locale("ui_all_lights")}
            </div>
            
            {/* Enable/Disable Toggle */}
            <button
                onClick={() => updateAllLights("enabled", !state.enabled)}
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
                title={state.enabled ? locale("ui_turn_off_all_lights") : locale("ui_turn_on_all_lights")}
                aria-label={state.enabled ? locale("ui_turn_off_all_lights") : locale("ui_turn_on_all_lights")}
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
                onClick={() => updateAllLights("rotateHorizontal", !state.rotateHorizontal)}
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
                title={locale("ui_rotate_horizontal") + " (All)"}
                aria-label={locale("ui_toggle_horizontal_rotation") + " for all lights"}
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
                onClick={() => updateAllLights("rotateVertical", !state.rotateVertical)}
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
                title={locale("ui_rotate_vertical") + " (All)"}
                aria-label={locale("ui_toggle_vertical_rotation") + " for all lights"}
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
                title={locale("ui_flash", state.flash) + " (All)"}
                aria-label={locale("ui_flash_setting", state.flash) + " for all lights"}
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
                title={locale("ui_speed", state.speed) + " (All)"}
                aria-label={locale("ui_light_rotation_speed", state.speed) + " for all lights"}
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

            {/* Information Button */}
            <button
                onClick={() => setIsInfoDialogOpen(true)}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${isInfoDialogOpen ? "#60d394" : "#555"}`,
                    borderRadius: 6,
                    background: isInfoDialogOpen ? "rgba(96, 211, 148, 0.1)" : "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                }}
                onMouseEnter={(e) => {
                    if (!isInfoDialogOpen) {
                        e.currentTarget.style.borderColor = "#888";
                        e.currentTarget.style.background = "#2a2a2a";
                    }
                }}
                onMouseLeave={(e) => {
                    if (!isInfoDialogOpen) {
                        e.currentTarget.style.borderColor = "#555";
                        e.currentTarget.style.background = "#1e1e1e";
                    }
                }}
                title="DJ Controller Information"
                aria-label="Open DJ controller information"
            >
                <svg
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke={isInfoDialogOpen ? "#60d394" : "#888"}
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                >
                    <circle cx="12" cy="12" r="10" />
                    <path d="M12 16v-4M12 8h.01" />
                </svg>
            </button>

            {/* Information Dialog */}
            {isInfoDialogOpen && (
                <div 
                    className="modalBackdrop" 
                    role="dialog" 
                    aria-modal="true" 
                    aria-labelledby="info-dialog-title" 
                    onClick={(e) => {
                        if (e.target === e.currentTarget) {
                            setIsInfoDialogOpen(false);
                        }
                    }}
                >
                    <div className="modal" onClick={(e) => e.stopPropagation()} style={{ maxWidth: 600, maxHeight: 300, display: "flex", flexDirection: "column" }}>
                        <div className="modalHeader" style={{ flexShrink: 0 }}>
                            <h3 id="info-dialog-title" style={{ margin: 0, fontSize: 16 }}>DJ Controller Guide</h3>
                            <button 
                                className="resetBtn" 
                                onClick={() => setIsInfoDialogOpen(false)} 
                                aria-label="Close information dialog"
                            >
                                ✕
                            </button>
                        </div>
                        <div className="modalBody" style={{ overflowY: "auto", flex: 1, minHeight: 0 }}>
                            <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Getting Started</h4>
                                    <p style={{ margin: 0, fontSize: 13, color: "#bbb", lineHeight: 1.6 }}>
                                        Welcome to the DJ Controller! Use this interface to control music playback, lighting effects, and audio mixing for your DJ station.
                                    </p>
                                </div>

                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Music Decks</h4>
                                    <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#bbb", lineHeight: 1.8 }}>
                                        <li>Each deck (Left/Right) can play music independently</li>
                                        <li>Click the play button to start/stop playback</li>
                                        <li>Use the tempo slider to adjust playback speed</li>
                                        <li>Add songs to your playlist using the "Add Song" button</li>
                                        <li>Use the crossfader (balance slider) to mix between decks</li>
                                    </ul>
                                </div>

                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Light Controls</h4>
                                    <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#bbb", lineHeight: 1.8 }}>
                                        <li><strong>All Lights:</strong> Controls all light types simultaneously</li>
                                        <li><strong>Individual Lights:</strong> Each light type (Ambient, Spotlight, Bar Light) has its own controls</li>
                                        <li><strong>Enable/Disable:</strong> Toggle lights on or off</li>
                                        <li><strong>Rotation:</strong> Control horizontal and vertical rotation</li>
                                        <li><strong>Flash:</strong> Set flash intensity (off, low, high)</li>
                                        <li><strong>Speed:</strong> Adjust rotation speed (slow, normal, fast)</li>
                                        <li><strong>Colors:</strong> Click the color button to set primary and secondary colors for each light type</li>
                                    </ul>
                                </div>

                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Effects</h4>
                                    <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#bbb", lineHeight: 1.8 }}>
                                        <li><strong>Smoke:</strong> Hold the smoke button to activate smoke effects</li>
                                        <li><strong>Fire:</strong> Hold the fire button to activate fire effects</li>
                                        <li>Release the button to stop the effect</li>
                                    </ul>
                                </div>

                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Audio Controls</h4>
                                    <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#bbb", lineHeight: 1.8 }}>
                                        <li><strong>Master Volume:</strong> Controls overall output volume</li>
                                        <li><strong>Balance:</strong> Mix audio between left and right decks</li>
                                        <li><strong>Microphone:</strong> Select and control your microphone input</li>
                                    </ul>
                                </div>

                                <div>
                                    <h4 style={{ margin: "0 0 8px 0", fontSize: 14, fontWeight: 600, color: "#ddd" }}>Tips</h4>
                                    <ul style={{ margin: 0, paddingLeft: 20, fontSize: 13, color: "#bbb", lineHeight: 1.8 }}>
                                        <li>Use the crossfader to smoothly transition between tracks</li>
                                        <li>Experiment with different light colors and effects to create atmosphere</li>
                                        <li>Adjust tempo to match beats between tracks</li>
                                        <li>Individual lights can be set to use primary or secondary colors via the entity management menu</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
