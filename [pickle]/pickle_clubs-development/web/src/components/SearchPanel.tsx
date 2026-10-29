import { useState, useEffect, useCallback } from "react";
import { useNuiEvent } from "../providers/nui/useNui";
import { fetchNui } from "../providers/nui/fetchNui";

interface InventoryItem {
  name: string;
  label?: string;
  count?: number;
  weight?: number;
  description?: string;
}

interface SearchData {
  playerName: string;
  items: InventoryItem[];
  imageDirectory: string;
  imageExtension: string;
}

export const SearchPanel = () => {
  const [data, setData] = useState<SearchData | null>(null);
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);
  const [hoveredItem, setHoveredItem] = useState<InventoryItem | null>(null);
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  useNuiEvent("openSearchPanel", (message: { data: SearchData }) => {
    setData(message.data);
    setHoveredItem(null);
    setAnimating(true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => setVisible(true));
    });
  });

  useNuiEvent("closeSearchPanel", () => slideOut());

  const slideOut = () => {
    setVisible(false);
    setTimeout(() => {
      setData(null);
      setAnimating(false);
      setHoveredItem(null);
    }, 300);
  };

  const handleClose = useCallback(() => {
    slideOut();
    fetchNui("closeSearchPanel");
  }, []);

  useEffect(() => {
    if (!data) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") handleClose();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [data, handleClose]);

  if (!data && !animating) return null;

  const getItemImage = (name: string) => {
    if (!data) return "";
    return `${data.imageDirectory}${name}.${data.imageExtension}`;
  };

  return (
    <div
      className="fixed top-0 right-0 h-full w-[380px] z-50 pointer-events-auto"
      style={{
        transform: visible ? "translateX(0)" : "translateX(100%)",
        transition: "transform 0.3s ease-in-out",
      }}
    >
      <div className="h-full bg-background/95 border-l border-border flex flex-col shadow-2xl">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-border">
          <div>
            <h2 className="text-lg font-bold text-primary">Search</h2>
            {data && <div className="text-xs text-muted-foreground">{data.playerName}</div>}
          </div>
          <button onClick={handleClose} className="text-muted-foreground hover:text-primary text-xl leading-none px-1">
            x
          </button>
        </div>

        {/* Item Grid */}
        <div className="flex-1 overflow-y-auto p-3">
          {data && data.items.length === 0 && (
            <div className="text-sm text-muted-foreground text-center py-8">
              No items found
            </div>
          )}
          {data && (
            <div className="grid grid-cols-5 gap-1.5">
              {data.items.map((item, i) => (
                <div
                  key={`${item.name}-${i}`}
                  className="relative aspect-square rounded-lg border border-border bg-secondary/30 hover:bg-secondary/60 transition-colors cursor-default flex items-center justify-center"
                  onMouseEnter={() => setHoveredItem(item)}
                  onMouseMove={(e) => setMousePos({ x: e.clientX, y: e.clientY })}
                  onMouseLeave={() => setHoveredItem(null)}
                >
                  <img
                    src={getItemImage(item.name)}
                    alt={item.label || item.name}
                    className="w-10 h-10 object-contain"
                    onError={(e) => {
                      (e.target as HTMLImageElement).style.display = "none";
                    }}
                  />
                  {item.count && item.count > 1 && (
                    <div className="absolute bottom-0.5 right-1 text-[10px] font-bold text-foreground">
                      x{item.count}
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Cursor Tooltip */}
        {hoveredItem && (
          <div
            className="fixed z-[9999] pointer-events-none"
            style={{
              left: mousePos.x + 16,
              top: mousePos.y + 16,
            }}
          >
            <div className="bg-background/95 border border-border rounded-lg p-3 shadow-xl min-w-[180px] max-w-[240px]">
              <div className="flex items-center gap-3">
                <img
                  src={getItemImage(hoveredItem.name)}
                  alt={hoveredItem.label || hoveredItem.name}
                  className="w-10 h-10 object-contain rounded border border-border bg-secondary/30 p-1 flex-shrink-0"
                  onError={(e) => {
                    (e.target as HTMLImageElement).style.display = "none";
                  }}
                />
                <div className="flex-1 min-w-0">
                  <div className="font-semibold text-sm text-primary truncate">
                    {hoveredItem.label || hoveredItem.name}
                  </div>
                  {hoveredItem.count !== undefined && (
                    <div className="text-[10px] text-muted-foreground">
                      x{hoveredItem.count}
                    </div>
                  )}
                </div>
              </div>
              {hoveredItem.description && (
                <div className="text-[11px] text-muted-foreground mt-2 line-clamp-3">
                  {hoveredItem.description}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
