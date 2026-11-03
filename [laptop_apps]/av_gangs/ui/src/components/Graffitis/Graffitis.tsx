import { useState, useEffect, useCallback, CSSProperties } from "react";

interface MessageData {
  action: "setVisible" | "setImage" | "setScale" | "setRotation";
  url?: string;
  scale?: number;
  rotation?: number;
  visible: boolean;
}

const photoStyle: CSSProperties = {
  maxWidth: "100%",
  maxHeight: "100%",
  objectFit: "contain",
  display: "block",
  transformOrigin: "center center",
  transition: "transform 0.1s ease-out",
};

const getContainerStyle = (isVisible: boolean): CSSProperties => ({
  width: "100%",
  height: "100vh",
  background: "transparent",
  display: isVisible ? "flex" : "none",
  justifyContent: "center",
  alignItems: "center",
  overflow: "hidden",
  position: "absolute",
  top: 0,
  left: 0,
});

export const Graffitis = () => {
  const [imageUrl, setImageUrl] = useState<string>("");
  const [currentScale, setCurrentScale] = useState<number>(1.0);
  const [currentRotation, setCurrentRotation] = useState<number>(0);
  const [isVisible, setIsVisible] = useState<boolean>(false);

  const getTransformStyle = useCallback((): CSSProperties => {
    return {
      ...photoStyle,
      transform: `scale(${currentScale}) rotate(${currentRotation}deg)`,
    };
  }, [currentScale, currentRotation]);

  useEffect(() => {
    const handleMessage = (event: MessageEvent<MessageData>) => {
      const data = event.data;
      if (!data || !data.action) return;
      switch (data.action) {
        case "setVisible":
          setIsVisible(data.visible);
          break;
        case "setImage":
          setImageUrl(data.url || "");
          setCurrentScale(data.scale || 1.0);
          setCurrentRotation(0);
          break;

        case "setScale":
          const newScale = Math.max(
            0.1,
            Math.min(5.0, data.scale || currentScale)
          );
          setCurrentScale(newScale);
          break;

        case "setRotation":
          setCurrentRotation(data.rotation || currentRotation);
          break;

        default:
          break;
      }
    };

    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, [currentScale, currentRotation]);

  return (
    <div style={getContainerStyle(isVisible)}>
      <img id="photo" src={imageUrl} alt="Photo" style={getTransformStyle()} />
    </div>
  );
};
