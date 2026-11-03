import { Box, Text } from "@mantine/core";
import { useClickOutside } from "@mantine/hooks";
import { fetchNui } from "../../hooks/useNuiEvents";
import { useEffect, useRef, useState } from "react";
import { useAtomValue } from "jotai";
import { Lang } from "../../reducers/atoms";
import classes from "./style.module.css";

interface Properties {
  url: string;
}

export const Poster = ({ url }: Properties) => {
  const { poster: lang = {} }: any = useAtomValue(Lang);
  const [hovered, setHovered] = useState(false);
  const [pressing, setPressing] = useState(false);
  const imgRef = useRef<HTMLImageElement>(null);
  const clickRef = useClickOutside(() =>
    fetchNui("av_business", "closePoster"),
  );

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.code === "Escape") fetchNui("av_business", "closePoster");
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  const applyZoom = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!imgRef.current) return;
    const rect = e.currentTarget.getBoundingClientRect();
    const x = ((e.clientX - rect.left) / rect.width) * 100;
    const y = ((e.clientY - rect.top) / rect.height) * 100;
    imgRef.current.style.transformOrigin = `${x}% ${y}%`;
  };

  const handleMouseEnter = () => {
    setHovered(true);
    if (imgRef.current) imgRef.current.style.filter = "none";
  };

  const handleMouseLeave = () => {
    setHovered(false);
    setPressing(false);
    if (imgRef.current) {
      imgRef.current.style.filter = "blur(10px)";
      imgRef.current.style.transform = "scale(1)";
      imgRef.current.style.transformOrigin = "center center";
    }
  };

  const handleMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
    setPressing(true);
    applyZoom(e);
    if (imgRef.current) imgRef.current.style.transform = "scale(2.5)";
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!pressing) return;
    applyZoom(e);
  };

  const handleMouseUp = () => {
    setPressing(false);
    if (imgRef.current) {
      imgRef.current.style.transform = "scale(1)";
      imgRef.current.style.transformOrigin = "center center";
    }
  };

  return (
    <Box className={classes.container}>
      <Box className={classes.image} ta="center">
        {!hovered && <Text className={classes.text}>{lang.hover}</Text>}
        <div
          ref={clickRef}
          style={{
            overflow: "hidden",
            cursor: pressing ? "zoom-in" : hovered ? "crosshair" : "default",
          }}
          onMouseEnter={handleMouseEnter}
          onMouseLeave={handleMouseLeave}
          onMouseDown={handleMouseDown}
          onMouseMove={handleMouseMove}
          onMouseUp={handleMouseUp}
        >
          <img
            ref={imgRef}
            src={url}
            alt="poster"
            draggable={false}
            style={{
              display: "block",
              maxWidth: "100%",
              filter: "blur(10px)",
              transform: "scale(1)",
              transformOrigin: "center center",
              transition: "filter 0.25s ease",
              userSelect: "none",
              pointerEvents: "none",
            }}
          />
        </div>
      </Box>
    </Box>
  );
};
