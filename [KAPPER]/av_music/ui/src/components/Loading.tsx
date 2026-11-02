import { LoadingOverlay } from "@mantine/core";
import { useViewportSize } from "@mantine/hooks";

interface Properties {
  height?: boolean;
}

export const Loading = ({ height: pHeight }: Properties) => {
  const { height: vHeight } = useViewportSize();
  return (
    <LoadingOverlay
      visible
      zIndex={1000}
      loaderProps={{ color: "var(--accent)", type: "dots" }}
      overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
      h={pHeight ? vHeight / 2 : undefined}
    />
  );
};
