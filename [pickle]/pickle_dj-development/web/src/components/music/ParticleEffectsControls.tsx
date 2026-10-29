import { useState, useEffect, useRef } from "react";
import { fetchNui } from "@/providers/nui/fetchNui";
import { useNuiEvent } from "../../providers/nui/useNui";
import { useLocale } from "../../providers/locale/Locale";

interface ParticleEffectsControlsProps {
    stationId: number | null;
}

interface ParticleEffectsState {
    smoke: boolean;
    fire: boolean;
}

export default function ParticleEffectsControls({ stationId }: ParticleEffectsControlsProps) {
    const locale = useLocale();
    const [state, setState] = useState<ParticleEffectsState>({
        smoke: false,
        fire: false,
    });

    const smokeHoldTimeoutRef = useRef<number | null>(null);
    const fireHoldTimeoutRef = useRef<number | null>(null);
    const smokeWasHeldRef = useRef<boolean>(false);
    const fireWasHeldRef = useRef<boolean>(false);
    const smokeClickAllowedRef = useRef<boolean>(false);
    const fireClickAllowedRef = useRef<boolean>(false);

    // Listen for initial state from server
    useNuiEvent("music:particleEffectsState", (event: any) => {
        const data = event.data || event;
        if (!stationId || data.stationId !== stationId) return;
        if (data.state) {
            setState({
                smoke: data.state.smoke === true || data.state.smoke === 1,
                fire: data.state.fire === true || data.state.fire === 1,
            });
        }
    });

    // Listen for networked updates
    useNuiEvent("music:particleEffectsUpdated", (event: any) => {
        const data = event.data || event;
        if (data.stationId === stationId) {
            if (data.effect === "smoke") {
                const smokeValue = data.value === true || data.value === 1;
                setState(prev => ({ ...prev, smoke: smokeValue }));
            } else if (data.effect === "fire") {
                const fireValue = data.value === true || data.value === 1;
                setState(prev => ({ ...prev, fire: fireValue }));
            }
        }
    });

    const updateEffect = async (effect: "smoke" | "fire", value: boolean) => {
        if (!stationId) return;
        await fetchNui("updateParticleEffect", {
            stationId,
            effect,
            value,
        });
    };

    const handleSmokeMouseDown = () => {
        smokeWasHeldRef.current = false;
        smokeClickAllowedRef.current = true;
        // Clear any existing timeout
        if (smokeHoldTimeoutRef.current) {
            clearTimeout(smokeHoldTimeoutRef.current);
        }
        // Set flag after a short delay to distinguish click from hold
        smokeHoldTimeoutRef.current = window.setTimeout(() => {
            smokeWasHeldRef.current = true;
            smokeClickAllowedRef.current = false; // Disable click toggle when held
            // Start smoke on hold
            updateEffect("smoke", true);
        }, 200); // 200ms threshold to distinguish click from hold
    };

    const handleSmokeMouseUp = () => {
        const wasHeld = smokeWasHeldRef.current;
        
        if (smokeHoldTimeoutRef.current) {
            clearTimeout(smokeHoldTimeoutRef.current);
            smokeHoldTimeoutRef.current = null;
        }
        
        // If it was held, stop on release
        if (wasHeld) {
            updateEffect("smoke", false);
            smokeClickAllowedRef.current = false; // Prevent click from toggling
        }
        
        smokeWasHeldRef.current = false;
    };

    const handleSmokeClick = () => {
        // Only toggle if it was a quick click (not a hold)
        if (smokeClickAllowedRef.current) {
            updateEffect("smoke", !state.smoke);
            smokeClickAllowedRef.current = false; // Reset flag
        }
    };

    const handleFireMouseDown = () => {
        fireWasHeldRef.current = false;
        fireClickAllowedRef.current = true;
        // Clear any existing timeout
        if (fireHoldTimeoutRef.current) {
            clearTimeout(fireHoldTimeoutRef.current);
        }
        // Set flag after a short delay to distinguish click from hold
        fireHoldTimeoutRef.current = window.setTimeout(() => {
            fireWasHeldRef.current = true;
            fireClickAllowedRef.current = false; // Disable click toggle when held
            // Start fire on hold
            updateEffect("fire", true);
        }, 200); // 200ms threshold to distinguish click from hold
    };

    const handleFireMouseUp = () => {
        const wasHeld = fireWasHeldRef.current;
        
        if (fireHoldTimeoutRef.current) {
            clearTimeout(fireHoldTimeoutRef.current);
            fireHoldTimeoutRef.current = null;
        }
        
        // If it was held, stop on release
        if (wasHeld) {
            updateEffect("fire", false);
            fireClickAllowedRef.current = false; // Prevent click from toggling
        }
        
        fireWasHeldRef.current = false;
    };

    const handleFireClick = () => {
        // Only toggle if it was a quick click (not a hold)
        if (fireClickAllowedRef.current) {
            updateEffect("fire", !state.fire);
            fireClickAllowedRef.current = false; // Reset flag
        }
    };

    // Cleanup on unmount
    useEffect(() => {
        return () => {
            if (smokeHoldTimeoutRef.current) {
                clearTimeout(smokeHoldTimeoutRef.current);
            }
            if (fireHoldTimeoutRef.current) {
                clearTimeout(fireHoldTimeoutRef.current);
            }
        };
    }, []);

    return (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "center", height: "358px" }}>
            <div style={{ fontSize: 12, fontWeight: 500, color: "#ddd", marginBottom: 4 }}>
                {locale("ui_effects")}
            </div>
            
            {/* Smoke Control */}
            <button
                onMouseDown={handleSmokeMouseDown}
                onMouseUp={handleSmokeMouseUp}
                onMouseLeave={handleSmokeMouseUp}
                onClick={handleSmokeClick}
                style={{
                    width: 48,
                    height: "100%",
                    border: `2px solid ${state.smoke ? "#60d394" : "#555"}`,
                    borderRadius: 6,
                    background: state.smoke ? "rgba(96, 211, 148, 0.1)" : "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    userSelect: "none",
                }}
                title={locale("ui_smoke_toggle")}
                aria-label={state.smoke ? locale("ui_turn_off_smoke") : locale("ui_turn_on_smoke")}
            >
                {state.smoke ? (
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
                        <path d="M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9z" />
                        <path d="M12 12v-1" opacity="0.6" />
                        <path d="M10 11v-1" opacity="0.4" />
                        <path d="M14 11v-1" opacity="0.4" />
                    </svg>
                ) : (
                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#888"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9z" />
                    </svg>
                )}
            </button>

            {/* Fire Control */}
            <button
                onMouseDown={handleFireMouseDown}
                onMouseUp={handleFireMouseUp}
                onMouseLeave={handleFireMouseUp}
                onClick={handleFireClick}
                style={{
                    width: 48,
                    height: "100%",
                    border: `2px solid ${state.fire ? "#ff6b6b" : "#555"}`,
                    borderRadius: 6,
                    background: state.fire ? "rgba(255, 107, 107, 0.1)" : "#1e1e1e",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    userSelect: "none",
                }}
                title={locale("ui_fire_toggle")}
                aria-label={state.fire ? locale("ui_turn_off_fire") : locale("ui_turn_on_fire")}
            >
                {state.fire ? (
                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#ff6b6b"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z" fill="#ff6b6b" opacity="0.2" />
                        <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z" />
                        <path d="M9 12c0 1.5 1 2.5 2 3" stroke="#ff6b6b" strokeWidth="1.5" opacity="0.6" />
                    </svg>
                ) : (
                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="#888"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                    >
                        <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z" />
                    </svg>
                )}
            </button>
        </div>
    );
}
