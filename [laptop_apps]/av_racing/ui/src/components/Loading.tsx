import { LoadingOverlay } from "@mantine/core";
import { useViewportHeight } from "../hooks/windowResize";

interface Properties {
  height?: boolean;
}

export const Loading = ({ height }: Properties) => {
  const vHeight = useViewportHeight();
  return (
    <LoadingOverlay
      visible
      zIndex={1000}
      loaderProps={{ color: "var(--accent)", type: "dots" }}
      overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
      h={height ? vHeight / 2 : undefined}
    />
  );
};
