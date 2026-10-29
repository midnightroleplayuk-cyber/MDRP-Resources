import { useState, useEffect, useCallback } from "react";
import { useNuiEvent } from "../providers/nui/useNui";
import { fetchNui } from "../providers/nui/fetchNui";

interface FlavorDetail {
  key: string;
  label: string;
  color: [number, number, number];
}

interface Recipe {
  name: string;
  flavors: FlavorDetail[];
  alcoholPct: number;
  alcoholLabel: string;
}

const rgbToHex = (r: number, g: number, b: number): string =>
  `#${[r, g, b].map((v) => v.toString(16).padStart(2, "0")).join("")}`;

const isLight = (r: number, g: number, b: number): boolean =>
  0.299 * r + 0.587 * g + 0.114 * b > 160;

export const RecipeBook = () => {
  const [recipes, setRecipes] = useState<Recipe[] | null>(null);
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);

  useNuiEvent("openRecipeBook", (message: { recipes: Recipe[] }) => {
    setRecipes(message.recipes || []);
    setAnimating(true);
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        setVisible(true);
      });
    });
  });

  useNuiEvent("closeRecipeBook", () => {
    slideOut();
  });

  const slideOut = () => {
    setVisible(false);
    setTimeout(() => {
      setRecipes(null);
      setAnimating(false);
    }, 300);
  };

  const handleClose = useCallback(() => {
    slideOut();
    fetchNui("closeRecipeBook");
  }, []);

  useEffect(() => {
    if (!recipes) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        handleClose();
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, [recipes, handleClose]);

  if (!recipes && !animating) return null;

  return (
    <div
      className="fixed top-0 right-0 h-full w-[320px] z-50 pointer-events-auto"
      style={{
        transform: visible ? "translateX(0)" : "translateX(100%)",
        transition: "transform 0.3s ease-in-out",
      }}
    >
      <div className="h-full bg-background/95 border-l border-border flex flex-col shadow-2xl">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-border">
          <h2 className="text-lg font-bold text-primary">Recipe Book</h2>
          <button
            onClick={handleClose}
            className="text-muted-foreground hover:text-primary text-xl leading-none px-1"
          >
            x
          </button>
        </div>

        {/* Recipe List */}
        <div className="flex-1 overflow-y-auto p-3 space-y-2">
          {recipes && recipes.length === 0 && (
            <div className="text-sm text-muted-foreground text-center py-8">
              No recipes available
            </div>
          )}
          {recipes && recipes.map((recipe, i) => (
            <div
              key={i}
              className="bg-secondary/30 border border-border rounded-lg p-3"
            >
              {/* Drink Name */}
              <div className="font-semibold text-primary text-sm mb-2">
                {recipe.name}
              </div>

              {/* Flavors */}
              {recipe.flavors.length > 0 && (
                <div className="mb-2">
                  <div className="text-[10px] uppercase tracking-wide text-muted-foreground mb-1">
                    Flavors
                  </div>
                  <div className="flex flex-wrap gap-1">
                    {recipe.flavors.map((f) => {
                      const hex = rgbToHex(...f.color);
                      const textColor = isLight(...f.color) ? "#111" : "#fff";
                      return (
                        <span
                          key={f.key}
                          className="px-2 py-0.5 rounded-full text-[10px] font-semibold"
                          style={{ backgroundColor: hex, color: textColor }}
                        >
                          {f.label}
                        </span>
                      );
                    })}
                  </div>
                </div>
              )}

              {/* Alcohol */}
              {recipe.alcoholPct > 0 && (
                <div className="flex items-center justify-between">
                  <span className="text-[10px] uppercase tracking-wide text-muted-foreground">
                    {recipe.alcoholLabel}
                  </span>
                  <span className="text-xs font-bold text-foreground">
                    {recipe.alcoholPct}%
                  </span>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
