import { useState, useEffect } from "react";

const useFormattedDateTime = (unixTimestamp: number): string => {
  const [formattedDateTime, setFormattedDateTime] = useState<string>("");

  useEffect(() => {
    if (unixTimestamp) {
      const date = new Date(unixTimestamp * 1000);
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const year = date.getFullYear();
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");
      const usaFormattedDateTime = `${month}/${day}/${year} ${hours}:${minutes}`;
      setFormattedDateTime(usaFormattedDateTime);
    }
  }, [unixTimestamp]);

  return formattedDateTime;
};

export default useFormattedDateTime;
