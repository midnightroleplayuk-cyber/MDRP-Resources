import { useEffect, useState } from "react";
import "./countdown.css";

interface Properties {
  unmount: (state: boolean) => void;
}

export const Countdown = ({ unmount }: Properties) => {
  const [count, setCount] = useState<number>(5);
  useEffect(() => {
    if (count < 0) {
      unmount(false);
      return;
    }

    const timer = setTimeout(() => {
      setCount(count - 1);
    }, 1000);

    return () => clearTimeout(timer);
  }, [count, unmount]);

  const isGo = count === 0;
  const display = isGo ? "GO!" : count;

  return (
    <div className="countdown-container">
      <div
        key={`big-${count}`}
        className={`big-outer ${isGo ? "go-explode-bg" : "animate-pulse"}`}
      >
        {display}
      </div>
      <div
        key={`small-${count}`}
        className={`small-fill ${isGo ? "go-explode-fg" : "animate-slide"}`}
      >
        {display}
      </div>
    </div>
  );
};
