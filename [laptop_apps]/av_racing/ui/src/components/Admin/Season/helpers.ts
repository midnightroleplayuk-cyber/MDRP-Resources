import { useMemo } from "react";

export const useToday = () => {
  const formattedDate = useMemo(() => {
    const date = new Date();

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    return `${year} ${month} ${day}`;
  }, []);

  return formattedDate;
};
