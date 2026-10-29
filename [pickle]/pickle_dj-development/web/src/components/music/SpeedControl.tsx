import { useState } from "react";
import { fetchNui } from "@/providers/nui/fetchNui";
import { useNuiEvent } from "../../providers/nui/useNui";

type SpeedSetting = "slow" | "normal" | "fast";

interface SpeedControlProps {
    stationId: number | null;
}

export default function SpeedControl({ stationId }: SpeedControlProps) {
    const [speed, setSpeed] = useState<SpeedSetting>("normal");

    // Listen for initial state from server
    useNuiEvent("music:lightControlsState", (event: any) => {
        const data = event.data || event;
        // Only process if stationId matches and we have valid data
        if (!stationId || data.stationId !== stationId) return;
        if (!data.controls || !data.controls.speed) return;
        
        const speedValue = data.controls.speed;
        if (speedValue === "slow" || speedValue === "normal" || speedValue === "fast") {
            setSpeed(speedValue);
        }
    });

    // Listen for speed updates
    useNuiEvent("music:lightSpeedUpdated", (event: any) => {
        const data = event.data || event;
        if (data.stationId === stationId && data.speed) {
            if (data.speed === "slow" || data.speed === "normal" || data.speed === "fast") {
                setSpeed(data.speed);
            }
        }
    });

    const cycleSpeed = async () => {
        if (!stationId) return;
        
        const nextSpeed: SpeedSetting = 
            speed === "slow" ? "normal" :
            speed === "normal" ? "fast" : "slow";
        
        // Send update to server
        await fetchNui("updateLightSpeed", {
            stationId,
            speed: nextSpeed,
        });
    };

    return (
        <div style={{ display: "flex", flexDirection: "column", gap: 8, alignItems: "center", minWidth: 80 }}>
            <div style={{ fontSize: 12, fontWeight: 500, color: "#ddd", marginBottom: 4 }}>
                Speed
            </div>
            
            {/* Speed Control Button (3-state: slow, normal, fast) */}
            <button
                onClick={cycleSpeed}
                style={{
                    width: 48,
                    height: 48,
                    border: `2px solid ${
                        speed === "slow" ? "#4a9eff" :
                        speed === "normal" ? "#60d394" : "#ff6b6b"
                    }`,
                    borderRadius: 6,
                    background: speed === "slow" ? "rgba(74, 158, 255, 0.1)" :
                        speed === "normal" ? "rgba(96, 211, 148, 0.1)" : "rgba(255, 107, 107, 0.1)",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    transition: "all 120ms ease",
                    flexDirection: "column",
                    gap: 2,
                }}
                title={`Speed: ${speed}`}
                aria-label={`Light rotation speed: ${speed}`}
            >
                {speed === "slow" ? (
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
                ) : speed === "normal" ? (
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
                    color: speed === "slow" ? "#4a9eff" : speed === "normal" ? "#60d394" : "#ff6b6b", 
                    textTransform: "uppercase", 
                    fontWeight: 600 
                }}>
                    {speed}
                </span>
            </button>
        </div>
    );
}
