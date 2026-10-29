import { Config, useConfig } from "./providers/config";
import { Translate } from "./providers/locale/Locale";
import { InteractiveEntityDisplay } from "./components/InteractiveEntityDisplay";
import { OrderDisplay } from "./components/OrderDisplay";
import { ClubManagement } from "./components/club/ClubManagement";
import { InteractText } from "./components/InteractText";
import { RecipeBook } from "./components/RecipeBook";
import { DrinkOrder } from "./components/DrinkOrder";
import { SocietyPanel } from "./components/SocietyPanel";
import { ClubEntryDialog } from "./components/ClubEntryDialog";
import { SearchPanel } from "./components/SearchPanel";
import { useNuiEvent } from "./providers/nui/useNui";
import { useState } from "react";

export function GetItemLabel({item} : {item: string}) {
  const { config } = useConfig();
  if (item == "money" || item == "dirty_money") {
    return <Translate id={item} />;
  }
  const itemLabel = config.items[item]?.label || config.items[item.toUpperCase()]?.label;
  if (!itemLabel) {
    return item;
  }
  return itemLabel;
}

export function GetItemImage(item: string) {
  const { config } = useConfig();
  return config.imageDirectory ? `${config.imageDirectory}/${item}.${config.imageExtension || "png"}` : `/nui/images/${item}.${config.imageExtension || "png"}`;
}

export function DisplayCurrency({value} : {value: number}) {
  const {config} = useConfig();
  return GetCurrencyString(value, config);
}

export function GetCurrencyString(value: number, config: Config) {
  return value.toLocaleString(config.countryCode || "en-US", {style: "currency", currency: config.currency || "USD", minimumFractionDigits: 0, maximumFractionDigits: 0});
}

export function AppControls({controls} : {controls?: {key: string, label: any, progress?: number}[]}) {
    const controlsList = controls || [
        {key: "ESC", label: <Translate id="controls_exit" />},
    ];
    return (
        <div className="bg-background/95 p-2 absolute top-[20px] left-[20px] flex items-center gap-2 rounded-md">
            {controlsList.map((control, index) => (
                <div className="flex flex-col gap-1" key={index}>
                    <div className="flex items-center justify-center gap-2">
                        <div className="relative font-bold text-sm w-[28px] h-[28px] text-black rounded-md bg-white">
                            <div className="absolute top-[50%] left-[50%] z-1" style={{transform: "translate(-50%, -50%)"}}>
                                {control.key}
                            </div>
                        </div>
                        <div className="font-bold text-xl text-primary">{control.label}</div>
                    </div>
                    {control.progress !== undefined && (
                        <div className="w-full bg-secondary rounded-full h-1.5 overflow-hidden">
                            <div
                                className="bg-primary h-full rounded-full transition-all duration-100 ease-linear"
                                style={{
                                    width: `${Math.max(0, Math.min(100, control.progress))}%`,
                                }}
                            />
                        </div>
                    )}
                </div>
            ))}
        </div>
    )
}

function App() {
  const [controls, setControls] = useState<{key: string, label: any, progress?: number}[] | null>(null);

  useNuiEvent("updateControls", (data: {controls?: {key: string, label: string, progress?: number}[]}) => {
    if (data && data.controls && Array.isArray(data.controls)) {
      setControls(data.controls.map(c => {
        // Translate the label
        const label: any = <Translate id={c.label} />;
        return {key: c.key, label: label, progress: c.progress};
      }));
    } else {
      setControls(null);
    }
  });

  return (
    <div className="dark w-screen h-screen absolute text-primary top-0 left-0">
      {controls && controls.length > 0 && <AppControls controls={controls} />}
      <InteractiveEntityDisplay />
      <OrderDisplay />
      <ClubManagement />
      <InteractText />
      <RecipeBook />
      <DrinkOrder />
      <SocietyPanel />
      <ClubEntryDialog />
      <SearchPanel />
    </div>
  )
}

export default App
