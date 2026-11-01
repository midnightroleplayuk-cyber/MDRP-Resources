import { LoadingOverlay } from "@mantine/core";

export const Loading = () => {
  return (
    <LoadingOverlay
      visible
      zIndex={1000}
      loaderProps={{ color: "var(--color-main)", type: "dots" }}
      overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
    />
  );
};
