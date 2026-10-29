import { useState } from "react";
import { useNuiEvent } from "../providers/nui/useNui";

interface DisplayRow {
  type: string;
  label: string;
  [key: string]: any;
}

interface EntityDisplay {
  title?: string;
  secondaryTitle?: string;
  rows?: DisplayRow[];
  [key: string]: any;
}

interface EntityDisplayData {
  entity: number;
  coords: { x: number; y: number; z: number };
  pitch: number;
  display: EntityDisplay;
  onScreen: boolean;
  screenX?: number;
  screenY?: number;
  scale?: number;
}

interface EntityDisplayMessage {
  type: string;
  data: EntityDisplayData;
}

const EntityDisplayCard = ({ data }: { data: EntityDisplayData }) => {
  if (!data.onScreen || !data.display) return null;

  // Don't render if scale is 0
  const scale = data.scale !== undefined ? data.scale : 1;
  if (scale === 0) return null;

  // Calculate position - if screenX/screenY are provided, use them; otherwise center
  const left = data.screenX !== undefined 
    ? `${data.screenX * 100}%` 
    : '50%';
  const top = data.screenY !== undefined 
    ? `${data.screenY * 100}%` 
    : '50%';

  // Apply pitch rotation (Z-axis rotation) and scale
  const pitchRotation = `rotateZ(${data.pitch}deg)`;
  const scaleTransform = `scale(${scale})`;

  return (
    <div
      className="absolute pointer-events-none"
      style={{
        left,
        top,
        transform: `translate(-50%, -50%) ${pitchRotation} ${scaleTransform}`,
        zIndex: 1000,
      }}
    >
      <div className="bg-background/95 border border-border rounded-lg p-3 min-w-[200px] shadow-lg">
        {(data.display.title || data.display.secondaryTitle) && (
          <div className="flex items-center gap-2 mb-2 border-b border-border pb-1">
            {data.display.title && (
              <div className="font-bold text-lg text-primary">
                {data.display.title}
              </div>
            )}
            {data.display.secondaryTitle && (
              <div className="text-sm text-muted-foreground ml-auto">
                {data.display.secondaryTitle}
              </div>
            )}
          </div>
        )}
        {data.display.rows && data.display.rows.length > 0 && (
          <div className="space-y-1">
            {data.display.rows.map((row, index) => (
              <div
                key={index}
                className="text-sm text-foreground"
              >
                {row.type === "text" && (
                  <div className={`${row.center ? "text-center" : ""} ${
                    row.color === "primary" ? "text-primary" : 
                    row.color === "secondary" ? "text-primary/85" : 
                    "text-foreground"
                  }`}>{row.label}</div>
                )}
                {row.type === "progress" && (
                  <div>
                    <div className="flex justify-between mb-1">
                      <span>{row.label}</span>
                      {row.value !== undefined && (
                        <span>{Math.round(row.value)}%</span>
                      )}
                    </div>
                    <div className="w-full bg-secondary rounded-full h-2">
                      <div
                        className="bg-primary h-2 rounded-full transition-all"
                        style={{
                          width: `${(row.value || 0)}%`,
                        }}
                      />
                    </div>
                  </div>
                )}
                {row.type === "item" && (
                  <div className="flex items-center gap-2">
                    {row.image && (
                      <img
                        src={row.image}
                        alt={row.label}
                        className="w-6 h-6 object-contain"
                      />
                    )}
                    <span>{row.label}</span>
                    {row.amount !== undefined && (
                      <span className="ml-auto text-muted-foreground">
                        x{row.amount}
                      </span>
                    )}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export const InteractiveEntityDisplay = () => {
  const [entityDisplays, setEntityDisplays] = useState<Map<number, EntityDisplayData>>(
    new Map()
  );

  useNuiEvent(
    "updateInteractiveEntityDisplay",
    (message: EntityDisplayMessage) => {
      const { data } = message;
      
      setEntityDisplays((prev) => {
        const newMap = new Map(prev);
        
        // If onScreen is false or display is null, remove the entity
        if (!data.onScreen || !data.display) {
          newMap.delete(data.entity);
        } else {
          // Update or add the entity display
          newMap.set(data.entity, data);
        }
        
        return newMap;
      });
    }
  );

  return (
    <div className="fixed inset-0 pointer-events-none">
      {Array.from(entityDisplays.values()).map((data) => (
        <EntityDisplayCard key={data.entity} data={data} />
      ))}
    </div>
  );
};
