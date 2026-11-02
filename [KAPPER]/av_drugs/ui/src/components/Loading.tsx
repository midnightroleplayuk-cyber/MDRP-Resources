import { Box, LoadingOverlay } from "@mantine/core";

export const Loading = () => {
  return (
    <Box
      style={{
        display: "flex",
        alignContent: "center",
        alignItems: "center",
        height: "100%",
      }}
    >
      <LoadingOverlay
        visible
        zIndex={1000}
        loaderProps={{ color: "blue.2", type: "dots" }}
        overlayProps={{ radius: "sm", blur: 2, opacity: 0 }}
      />
    </Box>
  );
};
