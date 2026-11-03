import { Table, ScrollArea } from "@mantine/core";
import { useRecoilValue } from "recoil";
import { Lang } from "../../../../../reducers/atoms";
import classes from "./style.module.css";

export const PositionTable = ({
  data,
  isDrift,
}: {
  data: any[];
  isDrift?: boolean;
}) => {
  const lang: any = useRecoilValue(Lang);
  const rows = data.map((item: any, index: number) => {
    return (
      <Table.Tr key={index} className={classes.tableRow}>
        <Table.Td
          className={classes.tableCell}
          style={{ color: "var(--accent)", fontWeight: 700 }}
        >
          {`# ${item.position}`}
        </Table.Td>
        <Table.Td className={classes.tableCell}>{item.name}</Table.Td>
        <Table.Td className={classes.tableCell}>
          {item.crew ? <>{item.crew.label}</> : <>{``}</>}
        </Table.Td>
        <Table.Td className={classes.tableCell}>{item.vehicle}</Table.Td>
        <Table.Td className={classes.tableCell}>
          {isDrift
            ? item.driftPoints
              ? item.driftPoints.toLocaleString()
              : 0
            : item.bestTime}
        </Table.Td>
        <Table.Td className={classes.tableCell}>{item.time}</Table.Td>
      </Table.Tr>
    );
  });

  return (
    <ScrollArea
      h={rows.length > 3 ? 255 : 150}
      type="hover"
      scrollbars="y"
      scrollbarSize={4}
    >
      <Table verticalSpacing="sm" withRowBorders={false}>
        <Table.Thead>
          <Table.Tr>
            <Table.Th className={classes.tableHeader}>
              {lang.position ?? "POS"}
            </Table.Th>
            <Table.Th className={classes.tableHeader}>
              {lang.racer ?? "RACER"}
            </Table.Th>
            <Table.Th className={classes.tableHeader}>
              {lang.crew ?? "CREW"}
            </Table.Th>
            <Table.Th className={classes.tableHeader}>
              {lang.vehicle ?? "VEHICLE"}
            </Table.Th>
            <Table.Th className={classes.tableHeader}>
              {isDrift
                ? (lang.points ?? "POINTS")
                : (lang.best_lap ?? "BEST LAP")}
            </Table.Th>
            <Table.Th className={classes.tableHeader}>
              {lang.total_time ?? "TOTAL TIME"}
            </Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>{rows}</Table.Tbody>
      </Table>
    </ScrollArea>
  );
};
